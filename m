Return-Path: <linux-kernel-owner+w=401wt.eu-S1754717AbYJCP0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717AbYJCP0q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 11:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752429AbYJCP0D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 11:26:03 -0400
Received: from tallyho.bytemark.co.uk ([80.68.81.166]:57486 "EHLO
	tallyho.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbYJCP0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 11:26:00 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 03/13] checkpatch: handle do without braces if we have enough context
Date: Fri,  3 Oct 2008 16:25:44 +0100
Message-Id: <1223047554-31111-4-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.6.0.1.451.gc8d31
In-Reply-To: <1223047554-31111-1-git-send-email-apw@shadowen.org>
References: <1223047554-31111-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we have sufficient context detect and handle do without braces ({).
Else these incorrectly trigger a trailing statements error for the
associated while.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 scripts/checkpatch.pl |   27 ++++++++++++++++++++++++---
 1 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 17e1d94..19690a2 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1051,6 +1051,7 @@ sub process {
 
 	# suppression flags
 	my %suppress_ifbraces;
+	my %suppress_whiletrailers;
 
 	# Pre-scan the patch sanitizing the lines.
 	# Pre-scan the patch looking for any __setup documentation.
@@ -1156,6 +1157,7 @@ sub process {
 			$prev_values = 'E';
 
 			%suppress_ifbraces = ();
+			%suppress_whiletrailers = ();
 			next;
 
 # track the line number as we move through the hunk, note that
@@ -1301,9 +1303,9 @@ sub process {
 		}
 
 # Check for potential 'bare' types
-		my ($stat, $cond, $line_nr_next, $remain_next);
+		my ($stat, $cond, $line_nr_next, $remain_next, $off_next);
 		if ($realcnt && $line =~ /.\s*\S/) {
-			($stat, $cond, $line_nr_next, $remain_next) =
+			($stat, $cond, $line_nr_next, $remain_next, $off_next) =
 				ctx_statement_block($linenr, $realcnt, 0);
 			$stat =~ s/\n./\n /g;
 			$cond =~ s/\n./\n /g;
@@ -1952,7 +1954,26 @@ sub process {
 
 # Check for illegal assignment in if conditional -- and check for trailing
 # statements after the conditional.
-		if ($line =~ /\b(?:if|while|for)\s*\(/ && $line !~ /^.\s*#/) {
+		if ($line =~ /do\s*(?!{)/) {
+			my ($stat_next) = ctx_statement_block($line_nr_next,
+						$remain_next, $off_next);
+			$stat_next =~ s/\n./\n /g;
+			##print "stat<$stat> stat_next<$stat_next>\n";
+
+			if ($stat_next =~ /^\s*while\b/) {
+				# If the statement carries leading newlines,
+				# then count those as offsets.
+				my ($whitespace) =
+					($stat_next =~ /^((?:\s*\n[+-])*\s*)/s);
+				my $offset =
+					statement_rawlines($whitespace) - 1;
+
+				$suppress_whiletrailers{$line_nr_next +
+								$offset} = 1;
+			}
+		}
+		if (!defined $suppress_whiletrailers{$linenr} &&
+		    $line =~ /\b(?:if|while|for)\s*\(/ && $line !~ /^.\s*#/) {
 			my ($s, $c) = ($stat, $cond);
 
 			if ($c =~ /\bif\s*\(.*[^<>!=]=[^=].*/) {
-- 
1.6.0.1.451.gc8d31

