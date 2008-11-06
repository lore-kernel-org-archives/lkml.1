Return-Path: <linux-kernel-owner+w=401wt.eu-S1753453AbYKFDIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453AbYKFDIV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 22:08:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752627AbYKFDIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 22:08:11 -0500
Received: from casper.infradead.org ([85.118.1.10]:51046 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622AbYKFDIJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 22:08:09 -0500
Date: Wed, 5 Nov 2008 19:07:26 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, mingo@elte.hu,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] scripts: script from kerneloops.org to pretty print oops
 dumps
Message-ID: <20081105190726.31952581@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I had this script lying around (used on kerneloops.org in a slightly modified form, 
where I use a database as input rather than stdin). I think it's a useful tool,
at least I find it extremely useful in turning oopses into an "oh duh yes there"
experience...

I know it's in perl, and I know I suck at writing good perl. So I welcome all feedback I
can get... both on the perl and on the usefulness of having this script.
 

>From 260d3f2246a4fe92f4ec633db82ab44605654d4f Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Wed, 5 Nov 2008 19:00:36 -0800
Subject: [PATCH] scripts: script from kerneloops.org to pretty print oops dumps

We're strugling all the time to figure out where the code came from
that oopsed.. The script below (a adaption from a script used by kerneloops.org)
can help developers quite a bit, at least for non-module cases.

It works and looks like this:

[/home/arjan/linux]$ dmesg | perl scripts/markup_code.pl vmlinux
 {
 	struct agp_memory *memory;

 	memory = agp_allocate_memory(agp_bridge, pg_count, type);
 c055c10f:	89 c2                	mov    %eax,%edx
 	if (memory == NULL)
 c055c111:	74 19                	je     c055c12c <agp_allocate_memory_wrap+0x30>
 /* This function must only be called when current_controller != NULL */
 static void agp_insert_into_pool(struct agp_memory * temp)
 {
 	struct agp_memory *prev;

 	prev = agp_fe.current_controller->pool;
 c055c113:	a1 ec dc 8f c0       	mov    0xc08fdcec,%eax
*c055c118:	8b 40 10             	mov    0x10(%eax),%eax     <----- faulting instruction

 	if (prev != NULL) {
 c055c11b:	85 c0                	test   %eax,%eax
 c055c11d:	74 05                	je     c055c124 <agp_allocate_memory_wrap+0x28>
 		prev->prev = temp;
 c055c11f:	89 50 04             	mov    %edx,0x4(%eax)
 		temp->next = prev;
 c055c122:	89 02                	mov    %eax,(%edx)
 	}
 	agp_fe.current_controller->pool = temp;
 c055c124:	a1 ec dc 8f c0       	mov    0xc08fdcec,%eax
 c055c129:	89 50 10             	mov    %edx,0x10(%eax)
 	if (memory == NULL)
 		return NULL;

 	agp_insert_into_pool(memory);

so in this case, we faulted while dereferencing agp_fe.current_controller pointer, and we get to see
exactly which function and line it affects... Personally I find this very useful, and I can
see value for having this script in the kernel for more-than-just-me to use.

Caveats:
* It only works for oopses not-in-modules
* It only works nicely for kernels compiled with CONFIG_DEBUG_INFO
* It's not very fast.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 scripts/markup_oops.pl |  165 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 165 insertions(+), 0 deletions(-)
 create mode 100644 scripts/markup_oops.pl

diff --git a/scripts/markup_oops.pl b/scripts/markup_oops.pl
new file mode 100644
index 0000000..c8a2200
--- /dev/null
+++ b/scripts/markup_oops.pl
@@ -0,0 +1,165 @@
+#!/usr/bin/perl -w
+
+# Copyright 2008, Intel Corporation
+#
+# This file is part of the Linux kernel
+#
+# This program file is free software; you can redistribute it and/or modify it
+# under the terms of the GNU General Public License as published by the
+# Free Software Foundation; version 2 of the License.
+#
+# Authors:
+# 	Arjan van de Ven <arjan@linux.intel.com>
+
+
+my $vmlinux_name = $ARGV[0];
+
+#
+# Step 1: Parse the oops to find the EIP value
+# 
+
+my $target = "0";
+while (<STDIN>) {
+  if ($_ =~ /EIP: 0060:\[\<([a-z0-9]+)\>\]/) {
+      $target = $1;
+  }
+}
+
+if ($target =~ /^f8/) {
+  print "This script does not work on modules ... \n";
+  exit;
+}
+
+if ($target eq "0") {
+  print "No oops found!\n";
+  print "Usage: \n";
+  print "    dmesg | perl scripts/markup_oops.pl vmlinux\n";
+  exit;
+}
+
+my $counter = 0;
+my $state = 0;
+my $center = 0;
+my @lines;
+
+sub InRange {
+  my ($address, $target) = @_;
+  my $ad = "0x".$address;
+  my $ta = "0x".$target;
+  my $delta = hex($ad) - hex($ta);
+
+  if (($delta > -4096) && ($delta < 4096)) {
+    return 1;
+  }
+  return 0;
+}
+                            
+ 
+
+# first, parse the input into the lines array, but to keep size down,
+# we only do this for 4Kb around the sweet spot
+
+my $filename;
+
+open(FILE, "objdump -dS $vmlinux_name |") || die "Cannot start objdump";
+
+while (<FILE>) {
+  my $line = $_;
+  chomp($line);
+  if ($state == 0) {
+      if ($line =~ /^([a-f0-9]+)\:/) {
+          if (InRange($1, $target)) {
+              $state = 1;
+          }
+      }
+  } else {
+      if ($line =~ /^([a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9]+)\:/) {
+          my $val = $1;
+          if (!InRange($val, $target)) {
+              last;
+          }
+          if ($val eq $target) {
+              $center = $counter;
+          }
+      }
+     $lines[$counter] = $line;
+     
+     $counter = $counter + 1;     
+  }
+}
+
+close(FILE);
+
+if ($counter == 0) {
+  print "No matching code found \n";
+  exit;
+}
+
+if ($center == 0) {
+  print "No matching code found \n";
+  exit;
+}
+
+my $start;
+my $finish;
+my $codelines;
+my $binarylines;
+# now we go up and down in the array to find how much we want to print
+
+$start = $center;
+$codelines = 0;
+$binarylines = 0;
+while ($start > 1) {
+  $start = $start - 1;
+  my $line = $lines[$start];
+  if ($line =~ /^([a-f0-9]+)\:/) {
+      $binarylines = $binarylines + 1;
+  } else {
+      $codelines = $codelines + 1;
+  }
+  if ($codelines > 10) {
+    last;
+  }
+  if ($binarylines > 20) {
+    last;
+  }
+}
+
+
+$finish = $center;
+$codelines = 0;
+$binarylines = 0;
+while ($finish < $counter) {
+  $finish = $finish + 1;
+  my $line = $lines[$finish];
+  if ($line =~ /^([a-f0-9]+)\:/) {
+      $binarylines = $binarylines + 1;
+  } else {
+      $codelines = $codelines + 1;
+  }
+  if ($codelines > 10) {
+    last;
+  }
+  if ($binarylines > 20) {
+    last;
+  }
+}
+
+
+my $i;
+
+my $fulltext = "";
+$i = $start;
+while ($i < $finish) {
+    if ($i == $center) {
+      $fulltext = $fulltext . "*$lines[$i]     <----- faulting instruction\n";
+    } else {
+      $fulltext = $fulltext .  " $lines[$i]\n";
+    }
+    $i = $i +1;
+}
+
+
+
+print $fulltext;
+
-- 
1.6.0.3



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
