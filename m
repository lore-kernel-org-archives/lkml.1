Return-Path: <linux-kernel-owner+w=401wt.eu-S932621AbZJ3QT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932621AbZJ3QT4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 12:19:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932599AbZJ3QTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 12:19:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:58220 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932547AbZJ3QTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 12:19:54 -0400
Date: Fri, 30 Oct 2009 16:19:34 GMT
From: tip-bot for Li Hong <lihong.hi@gmail.com>
Cc: linux-kernel@vger.kernel.org, lihong.hi@gmail.com, hpa@zytor.com,
       mingo@redhat.com, rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, lihong.hi@gmail.com,
       linux-kernel@vger.kernel.org, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <20091028050421.GD30758@uhli>
References: <20091028050421.GD30758@uhli>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing: Fix objcopy revision check in recordmcount.pl
Message-ID: <tip-7b7edc27683e20624f4daf17c76041719184201c@git.kernel.org>
Git-Commit-ID: 7b7edc27683e20624f4daf17c76041719184201c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7b7edc27683e20624f4daf17c76041719184201c
Gitweb:     http://git.kernel.org/tip/7b7edc27683e20624f4daf17c76041719184201c
Author:     Li Hong <lihong.hi@gmail.com>
AuthorDate: Wed, 28 Oct 2009 13:04:21 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 29 Oct 2009 15:11:44 -0400

tracing: Fix objcopy revision check in recordmcount.pl

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
