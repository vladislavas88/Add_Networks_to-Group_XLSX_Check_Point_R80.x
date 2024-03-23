#!/usr/bin/env perl

=pod

=head1 Using the script for add network objects to group for Check Point R80.x mgmt_cli 
#===============================================================================
#
#       FILE: add_networks_to_group_xlsx_R80.pl 
#
#       USAGE: $ sudo dnf install perl-App-cpanminus 
#		 	   $ cpanm Spreadsheet::ParseExcel Spreadsheet::XLSX Spreadsheet::Read
#		 
#		 	   $./add_networks_to_group_xlsx_R80.pl gr_Group_01 in_network_objects.xlsx 
#
#		$ cat ./add_networks_to_group_R80.txt
#		  set group name "gr_Group_01" members.add "gn_10.1.1.0_24" --version 1.3 
#		  set group name "gr_Group_01" members.add "gn_10.2.2.0_25" --version 1.3
#	      set group name "gr_Group_01" members.add "gn_10.3.3.0_26" --version 1.3
#	      set group name "gr_Group_01" members.add "gn_10.4.4.0_27" --version 1.3
#
#  DESCRIPTION: Create network objects for Check Point dbedit
#
#      OPTIONS: ---
# REQUIREMENTS: Perl v5.14+ 
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Vladislav Sapunov 
# ORGANIZATION:
#      VERSION: 1.0.0
#      CREATED: 22.02.2024 22:48:36
#     REVISION: ---
#===============================================================================
=cut

use strict;
use warnings;
use v5.14;
use utf8;
use Spreadsheet::Read;

#use Data::Dumper; # for debug
my $groupName = $ARGV[0];
my $inNetworks = $ARGV[1];

# Source XLSX File with groups names
my $workbook = ReadData($inNetworks) or die "Couldn't Open file " . "$!\n";
my $sheet = $workbook->[1];
my @column = ($sheet->{cell}[1]);

# Result outFile for mgmt_cli
my $outFile = 'add_networks_to_group_R80.txt';

my $setGroupName = "set group name";
my $membersAdd = "members.add";
my $version     = "--version 1.3";

# Open result outFile for writing
open( FHW, '>', $outFile ) or die "Couldn't Open file $outFile" . "$!\n";

foreach my $row (@column) {
	for (@$row) {
    	say FHW "$setGroupName" . " " . "\"" . "$groupName" . "\"" . " " . "$membersAdd" . " " . "$_" . " " . "$version" if (defined);
	}
}

# Close the filehandles
close(FHW) or die "$!\n";

say "**********************************************************************************\n";
say "Add networks to group TXT file: $outFile created successfully!";

my $cpUsage = <<__USAGE__;

****************************************************************************************************
* # Create the actual object
* >set group namei "gr_Group_01" members.add "gn_10.1.1.0_24" --version 1.3 
* > set group name "gr_Group_01" members.add "gn_10.2.2.0_25" --version 1.3
* > set group name "gr_Group_01" members.add "gn_10.3.3.0_26" --version 1.3
* > set group name "gr_Group_01" members.add "gn_10.4.4.0_27" --version 1.3
* > set group name "gr_Group_01" members.add "gn_10.5.5.0_28" --version 1.3
* > set group name "gr_Group_01" members.add "gn_10.6.6.0_29" --version 1.3
* > set group name "gr_Group_01" members.add "gn_10.7.7.0_30" --version 1.3
* #				
****************************************************************************************************

__USAGE__

say $cpUsage;

