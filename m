Return-Path: <linux-kernel-owner+w=401wt.eu-S1756465AbZJ0HAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465AbZJ0HAV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 03:00:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756432AbZJ0HAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 03:00:20 -0400
Received: from mail-px0-f180.google.com ([209.85.216.180]:43159 "EHLO
	mail-px0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756406AbZJ0HAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 03:00:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :x-operating-system:user-agent;
        b=iLUjfpTWVl4avATTyjO0BMT8diRxIZ9Uz2MPfIANyCypYvNvaMZ9GvBC3cuy6qF7Rr
         t9fH2j6tKsAIX2bV7bl0AtfJl3Bq3CpztS4L1vhy6uIu716PMZ+sR/vBlCaah5h/6/Fn
         dSIOdpxZZyb31AtHkOXicBajm3CrEJLNDDGHI=
Date: Tue, 27 Oct 2009 15:00:11 +0800
From: Li Hong <lihong.hi@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/9] tracing: recordmcount.pl Objcopy check should disable
	local reference correctly 
Message-ID: <20091027070011.GD22032@uhli>
Mail-Followup-To: Steven Rostedt <rostedt@goodmis.org>,
	linux-kernel@vger.kernel.org
References: <20091027065421.GA22032@uhli>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091027065421.GA22032@uhli>
X-Operating-System: Linux uhli 2.6.28-11-generic 
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 580ea035d04d4ca58300423db3dd5b4c73c8d61c Mon Sep 17 00:00:00 2001
From: Li Hong <lihong.hi@gmail.com>
Date: Tue, 27 Oct 2009 12:41:22 +0800
Subject: [PATCH] tracing: recordmcount.pl Objcopy check should disable local reference correctly

Use a function to do objcopy version check. Disable the local reference if
copy can't support it. Remove some unused variables.

Signed-off-by: Li Hong <lihong.hi@gmail.com>

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 94daf9e..970c6d6 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -155,6 +155,28 @@ my $function_regex;	# Find the name of a function
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
+    print STDERR "WARNING: could not find objcopy version or version is less than 2.17.\n" .
+	"\tLocal function references is disabled.\n" if !$can_use_local; 
+}
 
 if ($arch eq "x86") {
     if ($bits == 64) {
@@ -289,34 +311,7 @@ if ($filename =~ m,^(.*)(\.\S),) {
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
@@ -363,7 +358,7 @@ sub update_funcs
     if (defined $locals{$ref_func}) {
 
 	# only use locals if objcopy supports globalize-symbols
-	if (!$use_locals) {
+	if (!$can_use_local) {
 	    return;
 	}
 	$convert{$ref_func} = 1;
-- 
1.6.0.4

