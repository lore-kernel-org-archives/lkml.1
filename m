Return-Path: <linux-kernel-owner+w=401wt.eu-S1761078AbYDKPln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761078AbYDKPln (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 11:41:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760829AbYDKPlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 11:41:22 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:1694 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760820AbYDKPlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 11:41:21 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Andy Whitcroft <apw@shadowen.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] update checkpatch.pl to version 0.18
Date: Fri, 11 Apr 2008 16:41:38 +0100
Message-Id: <1207928498.0@pinky>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[This update is lighter than normal as I want to get these out before
leaving for vacation.]

This version brings a few fixes for the extern checks, and a couple of
new checks.

Of note:
 - false is now recognised as a 0 assignment in static/external
   assignments,
 - printf format strings including %L are reported,
 - a number of fixes for the extern in .c file detector which had
   temporarily lost its ability to detect variables; undetected due to
   the loss of its test.

Andy Whitcroft (8):
      Version: 0.18
      false should trip 0 assignment checks
      tests: reinstate missing tests
      tests: allow specification of the file extension for a test
      fix extern checks for variables
      check for and report %Lu, %Ld, and %Li
      ensure we only start a statement on lines with some content
      extern spacing

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 scripts/checkpatch.pl |   25 ++++++++++++++++++++-----
 1 files changed, 20 insertions(+), 5 deletions(-)
diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 523ec0f..257fbd5 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -9,7 +9,7 @@ use strict;
 my $P = $0;
 $P =~ s@.*/@@g;
 
-my $V = '0.17';
+my $V = '0.18';
 
 use Getopt::Long qw(:config no_auto_abbrev);
 
@@ -1144,7 +1144,7 @@ sub process {
 
 # Check for potential 'bare' types
 		my ($stat, $cond);
-		if ($realcnt) {
+		if ($realcnt && $line =~ /.\s*\S/) {
 			($stat, $cond) = ctx_statement_block($linenr,
 								$realcnt, 0);
 			$stat =~ s/\n./\n /g;
@@ -1316,12 +1316,12 @@ sub process {
 		}
 
 # check for external initialisers.
-		if ($line =~ /^.$Type\s*$Ident\s*=\s*(0|NULL);/) {
+		if ($line =~ /^.$Type\s*$Ident\s*=\s*(0|NULL|false)\s*;/) {
 			ERROR("do not initialise externals to 0 or NULL\n" .
 				$herecurr);
 		}
 # check for static initialisers.
-		if ($line =~ /\s*static\s.*=\s*(0|NULL);/) {
+		if ($line =~ /\s*static\s.*=\s*(0|NULL|false)\s*;/) {
 			ERROR("do not initialise statics to 0 or NULL\n" .
 				$herecurr);
 		}
@@ -1966,7 +1966,7 @@ sub process {
 
 # check for new externs in .c files.
 		if ($realfile =~ /\.c$/ && defined $stat &&
-		    $stat =~ /^.(?:extern\s+)?$Type\s+$Ident(\s*)\(/s)
+		    $stat =~ /^.\s*(?:extern\s+)?$Type\s+$Ident(\s*)\(/s)
 		{
 			my $paren_space = $1;
 
@@ -1981,6 +1981,11 @@ sub process {
 			if ($paren_space =~ /\n/) {
 				WARN("arguments for function declarations should follow identifier\n" . $herecurr);
 			}
+
+		} elsif ($realfile =~ /\.c$/ && defined $stat &&
+		    $stat =~ /^.\s*extern\s+/)
+		{
+			WARN("externs should be avoided in .c files\n" .  $herecurr);
 		}
 
 # checks for new __setup's
@@ -2026,6 +2031,16 @@ sub process {
 		{
 			WARN("usage of NR_CPUS is often wrong - consider using cpu_possible(), num_possible_cpus(), for_each_possible_cpu(), etc\n" . $herecurr);
 		}
+
+# check for %L{u,d,i} in strings
+		my $string;
+		while ($line =~ /(?:^|")([X\t]*)(?:"|$)/g) {
+			$string = substr($rawline, $-[1], $+[1] - $-[1]);
+			if ($string =~ /(?<!%)%L[udi]/) {
+				WARN("\%Ld/%Lu are not-standard C, use %lld/%llu\n" . $herecurr);
+				last;
+			}
+		}
 	}
 
 	# If we have no input at all, then there is nothing to report on
