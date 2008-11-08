Return-Path: <linux-kernel-owner+w=401wt.eu-S1754772AbYKHDuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772AbYKHDuf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 22:50:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753071AbYKHDr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 22:47:58 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:42760 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657AbYKHDrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 22:47:52 -0500
Message-Id: <20081108034750.183495492@goodmis.org>
References: <20081108034605.289816911@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 07 Nov 2008 22:46:13 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Matt Fleming <matthew.fleming@imgtec.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 08/10] ftrace: Align __mcount_loc sections
Content-Disposition: inline; filename=0008-ftrace-Align-__mcount_loc-sections.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: alignment option for recordmcount.pl script

Align the __mcount_loc sections so that architectures with strict
alignment requirements need not worry about performing unaligned
accesses.

This fixes an issue where I was seeing unaligned accesses, which are not
supported on our architecture (the results of an unaligned access are
undefined).

Signed-off-by: Matt Fleming <matthew.fleming@imgtec.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 scripts/recordmcount.pl |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 6b9fe3e..eeac71c 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -134,6 +134,7 @@ my $section_regex;	# Find the start of a section
 my $function_regex;	# Find the name of a function
 			#    (return offset and func name)
 my $mcount_regex;	# Find the call site to mcount (return offset)
+my $alignment;         # The .align value to use for $mcount_section
 
 if ($arch eq "x86") {
     if ($bits == 64) {
@@ -148,6 +149,7 @@ if ($arch eq "x86_64") {
     $function_regex = "^([0-9a-fA-F]+)\\s+<(.*?)>:";
     $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\smcount([+-]0x[0-9a-zA-Z]+)?\$";
     $type = ".quad";
+    $alignment = 8;
 
     # force flags for this arch
     $ld .= " -m elf_x86_64";
@@ -160,6 +162,7 @@ if ($arch eq "x86_64") {
     $function_regex = "^([0-9a-fA-F]+)\\s+<(.*?)>:";
     $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\smcount\$";
     $type = ".long";
+    $alignment = 4;
 
     # force flags for this arch
     $ld .= " -m elf_i386";
@@ -288,6 +291,7 @@ sub update_funcs
 	    open(FILE, ">$mcount_s") || die "can't create $mcount_s\n";
 	    $opened = 1;
 	    print FILE "\t.section $mcount_section,\"a\",\@progbits\n";
+	    print FILE "\t.align $alignment\n";
 	}
 	printf FILE "\t%s %s + %d\n", $type, $ref_func, $offsets[$i] - $offset;
     }
-- 
1.5.6.5

-- 
