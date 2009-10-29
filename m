Return-Path: <linux-kernel-owner+w=401wt.eu-S1756880AbZJ2WdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880AbZJ2WdV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 18:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756826AbZJ2WdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 18:33:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:58010 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756803AbZJ2WdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 18:33:16 -0400
Message-Id: <20091029223320.437410937@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 29 Oct 2009 18:33:00 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Li Hong <lihong.hi@gmail.com>
Subject: [PATCH 6/8] [PATCH 6/8] tracing: Add regex for weak functions in recordmcount.pl
References: <20091029223254.504427063@goodmis.org>
Content-Disposition: inline; filename=0006-tracing-Add-regex-for-weak-functions-in-recordmcount.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Hong <lihong.hi@gmail.com>

Add a variable to contain the regex needed to find weak functions
in the 'nm' output. This will allow other archs to easily override it.

Also rename the regex variable $nm_regex to $local_regex to be more
descriptive.

Signed-off-by: Li Hong <lihong.hi@gmail.com>
LKML-Reference: <20091028050619.GF30758@uhli>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/recordmcount.pl |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 02c8055..7265a7d 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -92,7 +92,7 @@
 #
 # Here are the steps we take:
 #
-# 1) Record all the local symbols by using 'nm'
+# 1) Record all the local and weak symbols by using 'nm'
 # 2) Use objdump to find all the call site offsets and sections for
 #    mcount.
 # 3) Compile the list into its own object.
@@ -152,7 +152,8 @@ my %weak;		# List of weak functions
 my %convert;		# List of local functions used that needs conversion
 
 my $type;
-my $nm_regex;		# Find the local functions (return function)
+my $local_regex;	# Match a local function (return function)
+my $weak_regex; 	# Match a weak function (return function)
 my $section_regex;	# Find the start of a section
 my $function_regex;	# Find the name of a function
 			#    (return offset and func name)
@@ -197,7 +198,8 @@ if ($arch eq "x86") {
 # We base the defaults off of i386, the other archs may
 # feel free to change them in the below if statements.
 #
-$nm_regex = "^[0-9a-fA-F]+\\s+t\\s+(\\S+)";
+$local_regex = "^[0-9a-fA-F]+\\s+t\\s+(\\S+)";
+$weak_regex = "^[0-9a-fA-F]+\\s+([wW])\\s+(\\S+)";
 $section_regex = "Disassembly of section\\s+(\\S+):";
 $function_regex = "^([0-9a-fA-F]+)\\s+<(.*?)>:";
 $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\smcount\$";
@@ -246,7 +248,7 @@ if ($arch eq "x86_64") {
     $cc .= " -m32";
 
 } elsif ($arch eq "powerpc") {
-    $nm_regex = "^[0-9a-fA-F]+\\s+t\\s+(\\.?\\S+)";
+    $local_regex = "^[0-9a-fA-F]+\\s+t\\s+(\\.?\\S+)";
     $function_regex = "^([0-9a-fA-F]+)\\s+<(\\.?.*?)>:";
     $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\s\\.?_mcount\$";
 
@@ -322,13 +324,13 @@ check_objcopy();
 
 #
 # Step 1: find all the local (static functions) and weak symbols.
-#        't' is local, 'w/W' is weak (we never use a weak function)
+#         't' is local, 'w/W' is weak
 #
 open (IN, "$nm $inputfile|") || die "error running $nm";
 while (<IN>) {
-    if (/$nm_regex/) {
+    if (/$local_regex/) {
 	$locals{$1} = 1;
-    } elsif (/^[0-9a-fA-F]+\s+([wW])\s+(\S+)/) {
+    } elsif (/$weak_regex/) {
 	$weak{$2} = $1;
     }
 }
-- 
1.6.3.3


