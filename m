Return-Path: <linux-kernel-owner+w=401wt.eu-S1752728AbYJQEs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728AbYJQEs0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 00:48:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbYJQEsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 00:48:19 -0400
Received: from kerrek.lightcubesolutions.com ([71.6.131.223]:59568 "EHLO
	mail.lightcubesolutions.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751207AbYJQEsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 00:48:18 -0400
Message-Id: <CE149741-15A2-4563-B4B8-69FC87E02D09@lightcubesolutions.com>
From: Jeremy Huntwork <jhuntwork@lightcubesolutions.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: [PATCH] Fix incompatibility with versions of Perl less than 5.6.0
Date: Fri, 17 Oct 2008 00:48:12 -0400
X-Mailer: Apple Mail (2.929.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resubmitting after Alexander kindly clued me into the documentation I  
missed.

This patch (made against 2.6.27.1 vanilla) fixes headers_install.pl  
and headers_check.pl to be compatible with versions of Perl less than  
5.6.0. It has been tested with Perl 5.005_03 and 5.8.8. I realize this  
may not be an issue for most people, but there will still be some that  
hit it, I imagine. There are three basic issues:

1. Prior to 5.6.0 open() only used 2 arguments, and the versions of  
the scripts in 2.6.27.1 use 3.
2. 5.6.0 also introduced the ability to use uninitialized scalar  
variables as file handles, which the current scripts make use of.
3. Lastly, 5.6.0 also introduced the pragma 'use warnings'. We can use  
the -w switch and be backwards compatible.

I am not subscribed to this list so please CC me on replies.

Signed-off-by: Jeremy Huntwork <jhuntwork@lightcubesolutions.com>

diff -uprN -X linux-2.6.27.1.orig/Documentation/dontdiff  
linux-2.6.27.1.orig/scripts/headers_check.pl linux-2.6.27.1/scripts/ 
headers_check.pl
--- linux-2.6.27.1.orig/scripts/headers_check.pl        2008-10-15  
19:02:53.000000000 -0400
+++ linux-2.6.27.1/scripts/headers_check.pl     2008-10-17  
00:24:50.000000000 -0400
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

@@ -27,14 +26,15 @@ my $lineno = 0;
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

diff -uprN -X linux-2.6.27.1.orig/Documentation/dontdiff  
linux-2.6.27.1.orig/scripts/headers_install.pl linux-2.6.27.1/scripts/ 
headers_install.pl
--- linux-2.6.27.1.orig/scripts/headers_install.pl      2008-10-15  
19:02:53.000000000 -0400
+++ linux-2.6.27.1/scripts/headers_install.pl   2008-10-17  
00:24:50.000000000 -0400
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

