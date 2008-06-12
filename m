Return-Path: <linux-kernel-owner+w=401wt.eu-S1761226AbYFLM3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761226AbYFLM3i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 08:29:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760327AbYFLM33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 08:29:29 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:3386 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761074AbYFLM3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 08:29:24 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 14/23] checkpatch: condition/loop indent checks
Date: Thu, 12 Jun 2008 13:05:53 +0100
Message-Id: <1213272362-19457-15-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.5.6.rc0.140.ga9675
In-Reply-To: <1213272362-19457-1-git-send-email-apw@shadowen.org>
References: <1213272362-19457-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check to see if the block/statement which a condition or loop introduces
is indented correctly.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 scripts/checkpatch.pl |   59 +++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 55 insertions(+), 4 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 8616bae..13d7a33 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1167,10 +1167,10 @@ sub process {
 		}
 
 # Check for potential 'bare' types
-		my ($stat, $cond);
+		my ($stat, $cond, $line_nr_next, $remain_next);
 		if ($realcnt && $line =~ /.\s*\S/) {
-			($stat, $cond) = ctx_statement_block($linenr,
-								$realcnt, 0);
+			($stat, $cond, $line_nr_next, $remain_next) =
+				ctx_statement_block($linenr, $realcnt, 0);
 			$stat =~ s/\n./\n /g;
 			$cond =~ s/\n./\n /g;
 
@@ -1712,7 +1712,8 @@ sub process {
 			ERROR("space required before the open parenthesis '('\n" . $herecurr);
 		}
 
-# Check for illegal assignment in if conditional.
+# Check for illegal assignment in if conditional -- and check for trailing
+# statements after the conditional.
 		if ($line =~ /\b(?:if|while|for)\s*\(/ && $line !~ /^.\s*#/) {
 			my ($s, $c) = ($stat, $cond);
 
@@ -1732,6 +1733,56 @@ sub process {
 			}
 		}
 
+# Check relative indent for conditionals and blocks.
+		if ($line =~ /\b(?:(?:if|while|for)\s*\(|do\b)/ && $line !~ /^.\s*#/ && $line !~ /\}\s*while\s*/) {
+			my ($s, $c) = ($stat, $cond);
+
+			substr($s, 0, length($c), '');
+
+			# Make sure we remove the line prefixes as we have
+			# none on the first line, and are going to readd them
+			# where necessary.
+			$s =~ s/\n./\n/gs;
+
+			# We want to check the first line inside the block
+			# starting at the end of the conditional, so remove:
+			#  1) any blank line termination
+			#  2) any opening brace { on end of the line
+			#  3) any do (...) {
+			my $continuation = 0;
+			my $check = 0;
+			$s =~ s/^.*\bdo\b//;
+			$s =~ s/^\s*{//;
+			if ($s =~ s/^\s*\\//) {
+				$continuation = 1;
+			}
+			if ($s =~ s/^\s*\n//) {
+				$check = 1;
+			}
+
+			# Also ignore a loop construct at the end of a
+			# preprocessor statement.
+			if (($prevline =~ /^.\s*#\s*define\s/ ||
+			    $prevline =~ /\\\s*$/) && $continuation == 0) {
+				$check = 0;
+			}
+
+			# Ignore the current line if its is a preprocessor
+			# line.
+			if ($s =~ /^\s*#\s*/) {
+				$check = 0;
+			}
+
+			my (undef, $sindent) = line_stats("+" . $s);
+
+			##print "line<$line> prevline<$prevline> indent<$indent> sindent<$sindent> check<$check> continuation<$continuation> s<$s>\n";
+
+			if ($check && (($sindent % 8) != 0 ||
+			    ($sindent <= $indent && $s ne ''))) {
+				WARN("suspect code indent for conditional statements\n" . $herecurr);
+			}
+		}
+
 # Check for bitwise tests written as boolean
 		if ($line =~ /
 			(?:
-- 
1.5.6.rc0.140.ga9675

