Return-Path: <linux-kernel-owner+w=401wt.eu-S1757332AbZJ1FEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332AbZJ1FEa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 01:04:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755392AbZJ1FE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 01:04:29 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:40930 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755354AbZJ1FE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 01:04:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :x-operating-system:user-agent;
        b=MOnVtU/vspP6gt8S3nDQNY1seArBpYmJ/VY3sv/Zr8zPoEoVfNn0R5KDazSLdDApMx
         mlhUkmQO+Lo+YqEuwaE7VhHv7p3rhKaZ0jsrZPl3+m72XbNQzbhgFDj9uCs3AxhRo0YB
         QqXAQ78H7w6KHGxyOPpjcbxyNR0paw8FcERwQ=
Date: Wed, 28 Oct 2009 13:04:21 +0800
From: Li Hong <lihong.hi@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v3 4/8] tracing: recordmcount.pl Objcopy check should
	disable local reference correctly
Message-ID: <20091028050421.GD30758@uhli>
Mail-Followup-To: Steven Rostedt <rostedt@goodmis.org>,
	linux-kernel@vger.kernel.org
References: <20091028045532.GA30036@uhli>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091028045532.GA30036@uhli>
X-Operating-System: Linux uhli 2.6.28-11-generic 
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From ceb80d8ba4fc55916c5f88d8c0a7655b869702cf Mon Sep 17 00:00:00 2001
From: Li Hong <lihong.hi@gmail.com>
Date: Tue, 27 Oct 2009 12:41:22 +0800
Subject: [PATCH] tracing: recordmcount.pl Objcopy check should disable local reference correctly

Use a function to do objcopy version check. Disable the local reference if
copy can't support it. Remove some unused variables.

Signed-off-by: Li Hong <lihong.hi@gmail.com>
---
 scripts/recordmcount.pl |   55 ++++++++++++++++++++++------------------------
 1 files changed, 26 insertions(+), 29 deletions(-)

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 8ff9eab..1de9826 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -158,6 +158,30 @@ my $function_regex;	# Find the name of a function
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
+        if (/objcopy.*\s(\d+)\.(\d+)/) {
+            $can_use_local = 1 if ($1 > 2 || ($1 == 2 && $2 >= 17)); 
+            last;
+        }
+    }
+    close (IN);
+
+    if (!$can_use_local) {
+        print STDERR "WARNING: could not find objcopy version or version is less than 2.17.\n" .
+	"\tLocal function references is disabled.\n"  
+    }
+}
 
 if ($arch eq "x86") {
     if ($bits == 64) {
@@ -292,34 +316,7 @@ if ($filename =~ m,^(.*)(\.\S),) {
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
@@ -366,7 +363,7 @@ sub update_funcs
     if (defined $locals{$ref_func}) {
 
 	# only use locals if objcopy supports globalize-symbols
-	if (!$use_locals) {
+	if (!$can_use_local) {
 	    return;
 	}
 	$convert{$ref_func} = 1;
-- 
1.6.0.4

