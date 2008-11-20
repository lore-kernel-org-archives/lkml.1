Return-Path: <linux-kernel-owner+w=401wt.eu-S1756845AbYKTUhJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845AbYKTUhJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 15:37:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755323AbYKTUf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 15:35:56 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:62888 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756AbYKTUfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 15:35:53 -0500
Message-Id: <20081120203551.873831232@goodmis.org>
References: <20081120203415.251344054@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 20 Nov 2008 15:34:17 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linuxppc-dev@ozlabs.org, Paul Mundt <lethal@linux-sh.org>,
       Matt Fleming <mjf@gentoo.org>, Jim Radford <radford@galvanix.net>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/3] ftrace: add support for powerpc to recordmcount.pl script
Content-Disposition: inline; filename=0002-ftrace-add-support-for-powerpc-to-recordmcount.pl-s.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: Add PowerPC port to recordmcount.pl script

This patch updates the recordmcount.pl script to process
PowerPC.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 scripts/recordmcount.pl |   19 +++++++++++++++++--
 1 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 9f75438..7ec032e 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -130,6 +130,7 @@ my %weak;		# List of weak functions
 my %convert;		# List of local functions used that needs conversion
 
 my $type;
+my $nm_regex;		# Find the local functions (return function)
 my $section_regex;	# Find the start of a section
 my $function_regex;	# Find the name of a function
 			#    (return offset and func name)
@@ -145,6 +146,7 @@ if ($arch eq "x86") {
 }
 
 if ($arch eq "x86_64") {
+    $nm_regex = "^[0-9a-fA-F]+\\s+t\\s+(\\S+)";
     $section_regex = "Disassembly of section\\s+(\\S+):";
     $function_regex = "^([0-9a-fA-F]+)\\s+<(.*?)>:";
     $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\smcount([+-]0x[0-9a-zA-Z]+)?\$";
@@ -158,6 +160,7 @@ if ($arch eq "x86_64") {
     $cc .= " -m64";
 
 } elsif ($arch eq "i386") {
+    $nm_regex = "^[0-9a-fA-F]+\\s+t\\s+(\\S+)";
     $section_regex = "Disassembly of section\\s+(\\S+):";
     $function_regex = "^([0-9a-fA-F]+)\\s+<(.*?)>:";
     $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\smcount\$";
@@ -171,6 +174,7 @@ if ($arch eq "x86_64") {
     $cc .= " -m32";
 
 } elsif ($arch eq "sh") {
+    $nm_regex = "^[0-9a-fA-F]+\\s+t\\s+(\\S+)";
     $section_regex = "Disassembly of section\\s+(\\S+):";
     $function_regex = "^([0-9a-fA-F]+)\\s+<(.*?)>:";
     $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\smcount\$";
@@ -181,6 +185,17 @@ if ($arch eq "x86_64") {
     $objcopy .= " -O elf32-sh-linux";
     $cc .= " -m32";
 
+} elsif ($arch eq "powerpc") {
+    $nm_regex = "^[0-9a-fA-F]+\\s+t\\s+(\\.?\\S+)";
+    $section_regex = "Disassembly of section\\s+(\\S+):";
+    $function_regex = "^([0-9a-fA-F]+)\\s+<(\\.?.*?)>:";
+    $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\s\\.?_mcount\$";
+    if ($bits == 64) {
+	$type = ".quad";
+    } else {
+	$type = ".long";
+    }
+
 } else {
     die "Arch $arch is not supported with CONFIG_FTRACE_MCOUNT_RECORD";
 }
@@ -250,7 +265,7 @@ if (!$found_version) {
 #
 open (IN, "$nm $inputfile|") || die "error running $nm";
 while (<IN>) {
-    if (/^[0-9a-fA-F]+\s+t\s+(\S+)/) {
+    if (/$nm_regex/) {
 	$locals{$1} = 1;
     } elsif (/^[0-9a-fA-F]+\s+([wW])\s+(\S+)/) {
 	$weak{$2} = $1;
@@ -302,7 +317,7 @@ sub update_funcs
 	    open(FILE, ">$mcount_s") || die "can't create $mcount_s\n";
 	    $opened = 1;
 	    print FILE "\t.section $mcount_section,\"a\",\@progbits\n";
-	    print FILE "\t.align $alignment\n";
+	    print FILE "\t.align $alignment\n" if (defined($alignment));
 	}
 	printf FILE "\t%s %s + %d\n", $type, $ref_func, $offsets[$i] - $offset;
     }
-- 
1.5.6.5

-- 
