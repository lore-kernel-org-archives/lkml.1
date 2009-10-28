Return-Path: <linux-kernel-owner+w=401wt.eu-S1757350AbZJ1FG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350AbZJ1FG1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 01:06:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757292AbZJ1FG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 01:06:26 -0400
Received: from mail-gx0-f216.google.com ([209.85.217.216]:42916 "EHLO
	mail-gx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755910AbZJ1FGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 01:06:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :x-operating-system:user-agent;
        b=Edxo/5nPPgmuzdZK2IEf3xdb1ziTxb1VLGPtMQ9GnXH016C8TUMER8SwCRn7u95NEC
         Pd9AZgIaw09+Z0AfHyS3Oz63Ji6tnVLjV2ideceHGLeMf7Pam4sloQz7Um1NmHj4hhv/
         G1rWWM6/o3Ql1QKYu6IyjSa+cZ5J2frwDjdHs=
Date: Wed, 28 Oct 2009 13:06:19 +0800
From: Li Hong <lihong.hi@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v3 6/8] tracing: recordmcount.pl Use more friendly
	variables to clean up the code
Message-ID: <20091028050619.GF30758@uhli>
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

>From 71a781c99a89573b57011cb8999b98db8238b3ed Mon Sep 17 00:00:00 2001
From: Li Hong <lihong.hi@gmail.com>
Date: Tue, 27 Oct 2009 13:13:37 +0800
Subject: [PATCH] tracing: recordmcount.pl Use more friendly variables to clean up the code

Signed-off-by: Li Hong <lihong.hi@gmail.com>
---
 scripts/recordmcount.pl |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index f4117d6..0f1107d 100755
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
@@ -151,7 +151,8 @@ my %weak;		# List of weak functions
 my %convert;		# List of local functions used that needs conversion
 
 my $type;
-my $nm_regex;		# Find the local functions (return function)
+my $local_regex;	# Match a local function (return function)
+my $weak_regex; 	# Match a weak function (return function)
 my $section_regex;	# Find the start of a section
 my $function_regex;	# Find the name of a function
 			#    (return offset and func name)
@@ -195,7 +196,8 @@ if ($arch eq "x86") {
 # We base the defaults off of i386, the other archs may
 # feel free to change them in the below if statements.
 #
-$nm_regex = "^[0-9a-fA-F]+\\s+t\\s+(\\S+)";
+$local_regex = "^[0-9a-fA-F]+\\s+t\\s+(\\S+)";
+$weak_regex = "^[0-9a-fA-F]+\\s+([wW])\\s+(\\S+)";
 $section_regex = "Disassembly of section\\s+(\\S+):";
 $function_regex = "^([0-9a-fA-F]+)\\s+<(.*?)>:";
 $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\smcount\$";
@@ -244,7 +246,7 @@ if ($arch eq "x86_64") {
     $cc .= " -m32";
 
 } elsif ($arch eq "powerpc") {
-    $nm_regex = "^[0-9a-fA-F]+\\s+t\\s+(\\.?\\S+)";
+    $local_regex = "^[0-9a-fA-F]+\\s+t\\s+(\\.?\\S+)";
     $function_regex = "^([0-9a-fA-F]+)\\s+<(\\.?.*?)>:";
     $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\s\\.?_mcount\$";
 
@@ -320,13 +322,13 @@ check_objcopy();
 
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
1.6.0.4

