Return-Path: <linux-kernel-owner+w=401wt.eu-S1756311AbYKTUgK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311AbYKTUgK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 15:36:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754771AbYKTUfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 15:35:54 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:52807 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642AbYKTUfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 15:35:53 -0500
Message-Id: <20081120203552.112676000@goodmis.org>
References: <20081120203415.251344054@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 20 Nov 2008 15:34:18 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linuxppc-dev@ozlabs.org, Paul Mundt <lethal@linux-sh.org>,
       Matt Fleming <mjf@gentoo.org>, Jim Radford <radford@galvanix.net>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 3/3] ftrace: create default variables for archs in recordmcount.pl
Content-Disposition: inline; filename=0003-ftrace-create-default-variables-for-archs-in-record.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: cleanup of recordmcount.pl

Now that more architectures are being ported to the MCOUNT_RECORD
method, there is no reason to have each declare their own arch
specific variable if most of them share the same value. This patch
creates a set of default values for the arch specific variables
based off of i386.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 scripts/recordmcount.pl |   27 +++++++++++----------------
 1 files changed, 11 insertions(+), 16 deletions(-)

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 7ec032e..c5c58ac 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -145,10 +145,17 @@ if ($arch eq "x86") {
     }
 }
 
+#
+# We base the defaults off of i386, the other archs may
+# feel free to change them in the below if statements.
+#
+$nm_regex = "^[0-9a-fA-F]+\\s+t\\s+(\\S+)";
+$section_regex = "Disassembly of section\\s+(\\S+):";
+$function_regex = "^([0-9a-fA-F]+)\\s+<(.*?)>:";
+$mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\smcount\$";
+$type = ".long";
+
 if ($arch eq "x86_64") {
-    $nm_regex = "^[0-9a-fA-F]+\\s+t\\s+(\\S+)";
-    $section_regex = "Disassembly of section\\s+(\\S+):";
-    $function_regex = "^([0-9a-fA-F]+)\\s+<(.*?)>:";
     $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\smcount([+-]0x[0-9a-zA-Z]+)?\$";
     $type = ".quad";
     $alignment = 8;
@@ -160,11 +167,6 @@ if ($arch eq "x86_64") {
     $cc .= " -m64";
 
 } elsif ($arch eq "i386") {
-    $nm_regex = "^[0-9a-fA-F]+\\s+t\\s+(\\S+)";
-    $section_regex = "Disassembly of section\\s+(\\S+):";
-    $function_regex = "^([0-9a-fA-F]+)\\s+<(.*?)>:";
-    $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\smcount\$";
-    $type = ".long";
     $alignment = 4;
 
     # force flags for this arch
@@ -174,11 +176,6 @@ if ($arch eq "x86_64") {
     $cc .= " -m32";
 
 } elsif ($arch eq "sh") {
-    $nm_regex = "^[0-9a-fA-F]+\\s+t\\s+(\\S+)";
-    $section_regex = "Disassembly of section\\s+(\\S+):";
-    $function_regex = "^([0-9a-fA-F]+)\\s+<(.*?)>:";
-    $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\smcount\$";
-    $type = ".long";
 
     # force flags for this arch
     $ld .= " -m shlelf_linux";
@@ -187,13 +184,11 @@ if ($arch eq "x86_64") {
 
 } elsif ($arch eq "powerpc") {
     $nm_regex = "^[0-9a-fA-F]+\\s+t\\s+(\\.?\\S+)";
-    $section_regex = "Disassembly of section\\s+(\\S+):";
     $function_regex = "^([0-9a-fA-F]+)\\s+<(\\.?.*?)>:";
     $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\s\\.?_mcount\$";
+
     if ($bits == 64) {
 	$type = ".quad";
-    } else {
-	$type = ".long";
     }
 
 } else {
-- 
1.5.6.5

-- 
