Return-Path: <linux-kernel-owner+w=401wt.eu-S1752062AbYJQEBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062AbYJQEBR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 00:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750819AbYJQEBB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 00:01:01 -0400
Received: from kerrek.lightcubesolutions.com ([71.6.131.223]:41545 "EHLO
	mail.lightcubesolutions.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750801AbYJQEBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 00:01:00 -0400
X-Greylist: delayed 1462 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Oct 2008 00:01:00 EDT
Message-Id: <EA1CEB12-7E00-4939-AFA9-84B865E185B4@lightcubesolutions.com>
From: Jeremy Huntwork <jhuntwork@lightcubesolutions.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: headers_install broken on early versions of perl
Date: Thu, 16 Oct 2008 23:36:35 -0400
X-Mailer: Apple Mail (2.929.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This may not be a very large concern, but the new headers_install.pl  
and headers_check.pl scripts do not work with versions of Perl <  
5.6.0. This is largely to do with syntax changes in that version.  
Previously, open() only allowed two arguments. The following patch  
(against 2.6.27.1) alters the syntax to be backwards compatible with  
earlier versions. It has been tested on 5.005_03, and 5.8.8.

Please CC me on any comments as I am not subscribed to this list.

Thanks,

Jeremy Huntwork


diff -Naur linux-2.6.27.1.orig/scripts/headers_check.pl linux-2.6.27.1/ 
scripts/headers_check.pl
--- linux-2.6.27.1.orig/scripts/headers_check.pl        Wed Oct 15  
19:02:53 2008
+++ linux-2.6.27.1/scripts/headers_check.pl     Thu Oct 16 19:10:37 2008
@@ -1,4 +1,4 @@
-#!/usr/bin/perl
+#!/usr/bin/perl -w
  #
  # headers_check.pl execute a number of trivial consistency checks
  #
@@ -17,7 +17,6 @@
  # 2) TODO: check for leaked CONFIG_ symbols

  use strict;
-use warnings;

  my ($dir, $arch, @files) = @ARGV;

@@ -27,14 +26,15 @@
  my $filename;

  foreach my $file (@files) {
+       local *FH;
         $filename = $file;
-       open(my $fh, '<', "$filename") or die "$filename: $!\n";
+       open(FH, "<$filename") or die "$filename: $!\n";
         $lineno = 0;
-       while ($line = <$fh>) {
+       while ($line = <FH>) {
                 $lineno++;
                 check_include();
         }
-       close $fh;
+       close FH;
  }
  exit $ret;

diff -Naur linux-2.6.27.1.orig/scripts/headers_install.pl  
linux-2.6.27.1/scripts/headers_install.pl
--- linux-2.6.27.1.orig/scripts/headers_install.pl      Wed Oct 15  
19:02:53 2008
+++ linux-2.6.27.1/scripts/headers_install.pl   Thu Oct 16 19:10:48 2008
@@ -1,4 +1,4 @@
-#!/usr/bin/perl
+#!/usr/bin/perl -w
  #
  # headers_install prepare the listed header files for use in
  # user space and copy the files to their destination.
@@ -17,28 +17,29 @@
  # 3) Drop all sections defined out by __KERNEL__ (using unifdef)

  use strict;
-use warnings;

  my ($readdir, $installdir, $arch, @files) = @ARGV;

  my $unifdef = "scripts/unifdef -U__KERNEL__";

  foreach my $file (@files) {
+       local *INFILE;
+       local *OUTFILE;
         my $tmpfile = "$installdir/$file.tmp";
-       open(my $infile, '<', "$readdir/$file")
+       open(INFILE, "<$readdir/$file")
                 or die "$readdir/$file: $!\n";
-       open(my $outfile, '>', "$tmpfile") or die "$tmpfile: $!\n";
-       while (my $line = <$infile>) {
+       open(OUTFILE, ">$tmpfile") or die "$tmpfile: $!\n";
+       while (my $line = <INFILE>) {
                 $line =~ s/([\s(])__user\s/$1/g;
                 $line =~ s/([\s(])__force\s/$1/g;
                 $line =~ s/([\s(])__iomem\s/$1/g;
                 $line =~ s/\s__attribute_const__\s/ /g;
                 $line =~ s/\s__attribute_const__$//g;
                 $line =~ s/^#include <linux\/compiler.h>//;
-               printf $outfile "%s", $line;
+               printf OUTFILE "%s", $line;
         }
-       close $outfile;
-       close $infile;
+       close OUTFILE;
+       close INFILE;
         system $unifdef . " $tmpfile > $installdir/$file";
         unlink $tmpfile;
  }


