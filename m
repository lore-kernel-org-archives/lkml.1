Return-Path: <linux-kernel-owner+w=401wt.eu-S1756914AbZJ2WeN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914AbZJ2WeN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 18:34:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756780AbZJ2WeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 18:34:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:57999 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756741AbZJ2WdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 18:33:15 -0400
Message-Id: <20091029223319.893099216@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 29 Oct 2009 18:32:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Li Hong <lihong.hi@gmail.com>
Subject: [PATCH 4/8] [PATCH 4/8] tracing: Fix objcopy revision check in recordmcount.pl
References: <20091029223254.504427063@goodmis.org>
Content-Disposition: inline; filename=0004-tracing-Fix-objcopy-revision-check-in-recordmcount.p.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Hong <lihong.hi@gmail.com>

The current logic to check objcopy's version is incorrect. This patch
fixes the algorithm and disables the use of local functions as a reference
if the objcopy version does not support static to global conversions.

Also remove some usused variables.

Signed-off-by: Li Hong <lihong.hi@gmail.com>
LKML-Reference: <20091028050421.GD30758@uhli>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/recordmcount.pl |   56 ++++++++++++++++++++++------------------------
 1 files changed, 27 insertions(+), 29 deletions(-)

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index b80e5d0..d6199fc 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -159,6 +159,31 @@ my $function_regex;	# Find the name of a function
 my $mcount_regex;	# Find the call site to mcount (return offset)
 my $alignment;		# The .align value to use for $mcount_section
 my $section_type;	# Section header plus possible alignment command
+my $can_use_local = 0; 	# If we can use local function references
+
+##
+# check_objcopy - whether objcopy supports --globalize-symbols
+#
+#  --globalize-symbols came out in 2.17, we must test the version
+#  of objcopy, and if it is less than 2.17, then we can not
+#  record local functions.
+sub check_objcopy
+{
+    open (IN, "$objcopy --version |") or die "error running $objcopy";
+    while (<IN>) {
+	if (/objcopy.*\s(\d+)\.(\d+)/) {
+	    $can_use_local = 1 if ($1 > 2 || ($1 == 2 && $2 >= 17));
+	    last;
+	}
+    }
+    close (IN);
+
+    if (!$can_use_local) {
+	print STDERR "WARNING: could not find objcopy version or version " .
+	    "is less than 2.17.\n" .
+	    "\tLocal function references is disabled.\n";
+    }
+}
 
 if ($arch eq "x86") {
     if ($bits == 64) {
@@ -293,34 +318,7 @@ if ($filename =~ m,^(.*)(\.\S),) {
 my $mcount_s = $dirname . "/.tmp_mc_" . $prefix . ".s";
 my $mcount_o = $dirname . "/.tmp_mc_" . $prefix . ".o";
 
-#
-# --globalize-symbols came out in 2.17, we must test the version
-# of objcopy, and if it is less than 2.17, then we can not
-# record local functions.
-my $use_locals = 01;
-my $local_warn_once = 0;
-my $found_version = 0;
-
-open (IN, "$objcopy --version |") || die "error running $objcopy";
-while (<IN>) {
-    if (/objcopy.*\s(\d+)\.(\d+)/) {
-	my $major = $1;
-	my $minor = $2;
-
-	$found_version = 1;
-	if ($major < 2 ||
-	    ($major == 2 && $minor < 17)) {
-	    $use_locals = 0;
-	}
-	last;
-    }
-}
-close (IN);
-
-if (!$found_version) {
-    print STDERR "WARNING: could not find objcopy version.\n" .
-	"\tDisabling local function references.\n";
-}
+check_objcopy();
 
 #
 # Step 1: find all the local (static functions) and weak symbols.
@@ -367,7 +365,7 @@ sub update_funcs
     if (defined $locals{$ref_func}) {
 
 	# only use locals if objcopy supports globalize-symbols
-	if (!$use_locals) {
+	if (!$can_use_local) {
 	    return;
 	}
 	$convert{$ref_func} = 1;
-- 
1.6.3.3


