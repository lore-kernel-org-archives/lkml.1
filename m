Return-Path: <linux-kernel-owner+w=401wt.eu-S1759607AbYJVVgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759607AbYJVVgs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 17:36:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757597AbYJVVf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 17:35:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:54777 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757003AbYJVVfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 17:35:53 -0400
Message-Id: <20081022213551.370747764@goodmis.org>
References: <20081022212721.167005680@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 22 Oct 2008 17:27:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       "David S. Miller" <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 02/13 v2] ftrace: dynamic ftrace process only text section
Content-Disposition: inline; filename=ftrace-record-only-text.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The text section stays in memory without ever leaving. With the exception
of modules, but modules know how to handle that case. With the dynamic
ftrace tracer, we need to make sure that it does not try to modify code
that no longer exists. The only safe section is .text.

This patch changes the recordmcount script to only record the mcount calls
in the .text sections.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 scripts/recordmcount.pl |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

Index: linux-compile.git/scripts/recordmcount.pl
===================================================================
--- linux-compile.git.orig/scripts/recordmcount.pl	2008-10-22 11:45:59.000000000 -0400
+++ linux-compile.git/scripts/recordmcount.pl	2008-10-22 11:46:33.000000000 -0400
@@ -109,6 +109,11 @@ if ($#ARGV < 6) {
 my ($arch, $bits, $objdump, $objcopy, $cc,
     $ld, $nm, $rm, $mv, $inputfile) = @ARGV;
 
+# Acceptible sections to record.
+my %text_sections = (
+     ".text" => 1,
+);
+
 $objdump = "objdump" if ((length $objdump) == 0);
 $objcopy = "objcopy" if ((length $objcopy) == 0);
 $cc = "gcc" if ((length $cc) == 0);
@@ -139,7 +144,7 @@ if ($arch eq "x86") {
 }
 
 if ($arch eq "x86_64") {
-    $section_regex = "Disassembly of section";
+    $section_regex = "Disassembly of section\\s+(\\S+):";
     $function_regex = "^([0-9a-fA-F]+)\\s+<(.*?)>:";
     $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\smcount([+-]0x[0-9a-zA-Z]+)?\$";
     $type = ".quad";
@@ -151,7 +156,7 @@ if ($arch eq "x86_64") {
     $cc .= " -m64";
 
 } elsif ($arch eq "i386") {
-    $section_regex = "Disassembly of section";
+    $section_regex = "Disassembly of section\\s+(\\S+):";
     $function_regex = "^([0-9a-fA-F]+)\\s+<(.*?)>:";
     $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\smcount\$";
     $type = ".long";
@@ -298,7 +303,13 @@ my $text;
 while (<IN>) {
     # is it a section?
     if (/$section_regex/) {
-	$read_function = 1;
+
+	# Only record text sections that we know are safe
+	if (defined($text_sections{$1})) {
+	    $read_function = 1;
+	} else {
+	    $read_function = 0;
+	}
 	# print out any recorded offsets
 	update_funcs() if ($text_found);
 

-- 
