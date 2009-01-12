Return-Path: <linux-kernel-owner+w=401wt.eu-S1753813AbZALJ6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813AbZALJ6z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 04:58:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752041AbZALJ6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 04:58:46 -0500
Received: from casper.infradead.org ([85.118.1.10]:54814 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbZALJ6p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 04:58:45 -0500
Date: Mon, 12 Jan 2009 10:00:54 +0000
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, torvalds@linux-foundation.org, tytso@mit.edu
Subject: [patch] Improve oops decoding for modules
Message-ID: <20090112100054.642850e8@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

the patch below improves our debugability of crashes in modules; it 
improves markup_oops.pl to also show a source/asm mixed output for
the module case. Hopefully this ends that flamewar now...




>From f5a3a13d255b150d1cc2b87f1c2ce8f9c7c55419 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sun, 11 Jan 2009 15:03:23 +0000
Subject: [PATCH] script: improve markup_oops.pl to also decode oopses in modules

There has been some light flamewar on lkml about decoding oopses
in modules (as part of the crashdump flamewar).

Now this isn't rocket science, just the markup_oops.pl script
cheaped out and didn't handle modules. But really; a flamewar
all about that?? What happened to C++ in the kernel or reading
files from inside the kernel?

This patch adds module support to markup_oops.pl; it's not the
most pretty perl but it works for my testcases...

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 scripts/markup_oops.pl |   59 ++++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 50 insertions(+), 9 deletions(-)

diff --git a/scripts/markup_oops.pl b/scripts/markup_oops.pl
index 700a7a6..d40449c 100644
--- a/scripts/markup_oops.pl
+++ b/scripts/markup_oops.pl
@@ -1,5 +1,7 @@
 #!/usr/bin/perl -w
 
+use File::Basename;
+
 # Copyright 2008, Intel Corporation
 #
 # This file is part of the Linux kernel
@@ -13,23 +15,41 @@
 
 
 my $vmlinux_name = $ARGV[0];
-
+if (!defined($vmlinux_name)) {
+	my $kerver = `uname -r`;
+	chomp($kerver);
+	$vmlinux_name = "/lib/modules/$kerver/build/vmlinux";
+	print "No vmlinux specified, assuming $vmlinux_name\n";
+}
+my $filename = $vmlinux_name;
 #
 # Step 1: Parse the oops to find the EIP value
 #
 
 my $target = "0";
+my $function;
+my $module = "";
+my $func_offset;
+my $vmaoffset = 0;
+
 while (<STDIN>) {
-	if ($_ =~ /EIP: 0060:\[\<([a-z0-9]+)\>\]/) {
+	my $line = $_;
+	if ($line =~ /EIP: 0060:\[\<([a-z0-9]+)\>\]/) {
 		$target = $1;
 	}
-}
+	if ($line =~ /EIP is at ([a-zA-Z0-9\_]+)\+(0x[0-9a-f]+)\/0x[a-f0-9]/) {
+		$function = $1;
+		$func_offset = $2;
+	}
 
-if ($target =~ /^f8/) {
-	print "This script does not work on modules ... \n";
-	exit;
+	# check if it's a module
+	if ($line =~ /EIP is at ([a-zA-Z0-9\_]+)\+(0x[0-9a-f]+)\/0x[a-f0-9]+\W\[([a-zA-Z0-9\_\-]+)\]/) {
+		$module = $3;
+	}
 }
 
+my $decodestart = hex($target) - hex($func_offset);
+my $decodestop = $decodestart + 8192;
 if ($target eq "0") {
 	print "No oops found!\n";
 	print "Usage: \n";
@@ -37,6 +57,29 @@ if ($target eq "0") {
 	exit;
 }
 
+# if it's a module, we need to find the .ko file and calculate a load offset
+if ($module ne "") {
+	my $dir = dirname($filename);
+	$dir = $dir . "/";
+	my $mod = $module . ".ko";
+	my $modulefile = `find $dir -name $mod | head -1`;
+	chomp($modulefile);
+	$filename = $modulefile;
+	if ($filename eq "") {
+		print "Module .ko file for $module not found. Aborting\n";
+		exit;
+	}
+	# ok so we found the module, now we need to calculate the vma offset
+	open(FILE, "objdump -dS $filename |") || die "Cannot start objdump";
+	while (<FILE>) {
+		if ($_ =~ /^([0-9a-f]+) \<$function\>\:/) {
+			my $fu = $1;
+			$vmaoffset = hex($target) - hex($fu) - hex($func_offset);
+		}
+	}
+	close(FILE);
+}
+
 my $counter = 0;
 my $state   = 0;
 my $center  = 0;
@@ -59,9 +102,7 @@ sub InRange {
 # first, parse the input into the lines array, but to keep size down,
 # we only do this for 4Kb around the sweet spot
 
-my $filename;
-
-open(FILE, "objdump -dS $vmlinux_name |") || die "Cannot start objdump";
+open(FILE, "objdump -dS --adjust-vma=$vmaoffset --start-address=$decodestart --stop-address=$decodestop $filename |") || die "Cannot start objdump";
 
 while (<FILE>) {
 	my $line = $_;
-- 
1.6.0.6


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
