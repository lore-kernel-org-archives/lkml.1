Return-Path: <linux-kernel-owner+w=401wt.eu-S932095AbZJ0HCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095AbZJ0HCW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 03:02:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755476AbZJ0HCV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 03:02:21 -0400
Received: from mail-px0-f180.google.com ([209.85.216.180]:64373 "EHLO
	mail-px0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755172AbZJ0HCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 03:02:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :x-operating-system:user-agent;
        b=GMPmCnzEZW5fmZIjEe6f/F+NSwVdv427T0KFC407ixp6rNVPbgOjSClY5zyPSiFEZ7
         IJKix6akA0sqc54vj/6BLFC/a8SgrVDRv8r+zYBYLIcsHgBF0AARikwWVuBuJVS91NEj
         O6CKZ2+D3LPQKGJiW2KQLfV+Y0WkKWnqFBStA=
Date: Tue, 27 Oct 2009 15:02:12 +0800
From: Li Hong <lihong.hi@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 6/9] tracing: recordmcount.pl Exit early if no work to do 
Message-ID: <20091027070212.GF22032@uhli>
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

>From 1589563d8113db41fa77dd657459b563dcecd389 Mon Sep 17 00:00:00 2001
From: Li Hong <lihong.hi@gmail.com>
Date: Tue, 27 Oct 2009 13:13:37 +0800
Subject: [PATCH] tracing: recordmcount.pl Exit early if no work to do

Also keep the global symbols and use it to check if no work to do, exit
early.

Signed-off-by: Li Hong <lihong.hi@gmail.com>

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index a6585b6..d750da8 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -91,7 +91,7 @@
 #
 # Here are the steps we take:
 #
-# 1) Record all the local symbols by using 'nm'
+# 1) Record all the global, local and weak symbols by using 'nm'
 # 2) Use objdump to find all the call site offsets and sections for
 #    mcount.
 # 3) Compile the list into its own object.
@@ -143,12 +143,15 @@ $mv = "mv" if ((length $mv) == 0);
 #print STDERR "running: $P '$arch' '$objdump' '$objcopy' '$cc' '$ld' " .
 #    "'$nm' '$rm' '$mv' '$inputfile'\n";
 
+my %globals;		# List of global functions
 my %locals;		# List of local (static) functions
 my %weak;		# List of weak functions
 my %convert;		# List of local functions used that needs conversion
 
 my $type;
-my $nm_regex;		# Find the local functions (return function)
+my $global_regex;	# Match a global function (return function)
+my $local_regex;	# Match a local function (return function)
+my $weak_regex; 	# Match a weak function (return function)
 my $section_regex;	# Find the start of a section
 my $function_regex;	# Find the name of a function
 			#    (return offset and func name)
@@ -190,7 +193,9 @@ if ($arch eq "x86") {
 # We base the defaults off of i386, the other archs may
 # feel free to change them in the below if statements.
 #
-$nm_regex = "^[0-9a-fA-F]+\\s+t\\s+(\\S+)";
+$global_regex = "^[0-9a-fA-F]+\\s+T\\s+(\\S+)";
+$local_regex = "^[0-9a-fA-F]+\\s+t\\s+(\\S+)";
+$weak_regex = "^[0-9a-fA-F]+\\s+([wW])\\s+(\\S+)";
 $section_regex = "Disassembly of section\\s+(\\S+):";
 $function_regex = "^([0-9a-fA-F]+)\\s+<(.*?)>:";
 $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\smcount\$";
@@ -239,7 +244,8 @@ if ($arch eq "x86_64") {
     $cc .= " -m32";
 
 } elsif ($arch eq "powerpc") {
-    $nm_regex = "^[0-9a-fA-F]+\\s+t\\s+(\\.?\\S+)";
+    $global_regex = "^[0-9a-fA-F]+\\s+T\\s+(\\.?\\S+)";
+    $local_regex = "^[0-9a-fA-F]+\\s+t\\s+(\\.?\\S+)";
     $function_regex = "^([0-9a-fA-F]+)\\s+<(\\.?.*?)>:";
     $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\s\\.?_mcount\$";
 
@@ -314,19 +320,24 @@ my $mcount_o = $dirname . "/.tmp_mc_" . $prefix . ".o";
 check_objcopy();
 
 #
-# Step 1: find all the local (static functions) and weak symbols.
-#        't' is local, 'w/W' is weak (we never use a weak function)
+# Step 1: find all the global and local (static functions) and weak symbols.
+#        'T' is global 't' is local, 'w/W' is weak
 #
 open (IN, "$nm $inputfile|") || die "error running $nm";
 while (<IN>) {
-    if (/$nm_regex/) {
+    if (/$global_regex/) {
+        $globals{$1} = 1;
+    } elsif (/$local_regex/) {
 	$locals{$1} = 1;
-    } elsif (/^[0-9a-fA-F]+\s+([wW])\s+(\S+)/) {
+    } elsif (/$weak_regex/) {
 	$weak{$2} = $1;
     }
 }
 close(IN);
 
+# Exit early if no work to do 
+exit(0) unless (%globals or (%locals and $can_use_local)); 
+
 my @offsets;		# Array of offsets of mcount callers
 my $ref_func;		# reference function to use for offsets
 my $offset = 0;		# offset of ref_func to section beginning
-- 
1.6.0.4

