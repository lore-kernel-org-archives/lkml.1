Return-Path: <linux-kernel-owner+w=401wt.eu-S932647AbZJ3QUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932647AbZJ3QUf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 12:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932613AbZJ3QUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 12:20:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:40596 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932596AbZJ3QU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 12:20:28 -0400
Date: Fri, 30 Oct 2009 16:20:06 GMT
From: tip-bot for Li Hong <lihong.hi@gmail.com>
Cc: linux-kernel@vger.kernel.org, lihong.hi@gmail.com, hpa@zytor.com,
       mingo@redhat.com, rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, lihong.hi@gmail.com,
       linux-kernel@vger.kernel.org, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <20091028050619.GF30758@uhli>
References: <20091028050619.GF30758@uhli>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing: Add regex for weak functions in recordmcount.pl
Message-ID: <tip-306dcf47d28aaf9aedfafb17a602768584cfc0f2@git.kernel.org>
Git-Commit-ID: 306dcf47d28aaf9aedfafb17a602768584cfc0f2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  306dcf47d28aaf9aedfafb17a602768584cfc0f2
Gitweb:     http://git.kernel.org/tip/306dcf47d28aaf9aedfafb17a602768584cfc0f2
Author:     Li Hong <lihong.hi@gmail.com>
AuthorDate: Wed, 28 Oct 2009 13:06:19 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 29 Oct 2009 15:11:52 -0400

tracing: Add regex for weak functions in recordmcount.pl

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
