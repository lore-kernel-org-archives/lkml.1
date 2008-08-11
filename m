Return-Path: <linux-kernel-owner+w=401wt.eu-S1757974AbYHKUSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757974AbYHKUSW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 16:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753949AbYHKUSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 16:18:11 -0400
Received: from bigben2.bytemark.co.uk ([80.68.81.132]:41241 "EHLO
	bigben2.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853AbYHKUSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 16:18:10 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 13/17] checkpatch: suspect indent -- skip over preprocessor, label and blank lines
Date: Mon, 11 Aug 2008 21:13:08 +0100
Message-Id: <1218485592-6679-14-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.6.0.rc1.258.g80295
In-Reply-To: <1218485592-6679-1-git-send-email-apw@shadowen.org>
References: <1218485592-6679-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should skip over and check the lines which follow preprocessor
statements, labels, and blank lines.  These all have legitimate reasons
to be indented differently.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 scripts/checkpatch.pl |   27 ++++++++++++++++-----------
 1 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index e3ae79a..6ddae89 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1434,7 +1434,7 @@ sub process {
 			if ($s =~ s/^\s*\\//) {
 				$continuation = 1;
 			}
-			if ($s =~ s/^\s*\n//) {
+			if ($s =~ s/^\s*?\n//) {
 				$check = 1;
 				$cond_lines++;
 			}
@@ -1446,15 +1446,20 @@ sub process {
 				$check = 0;
 			}
 
-			# Ignore the current line if its is a preprocessor
-			# line.
-			if ($s =~ /^\s*#\s*/) {
-				$check = 0;
-			}
+			my $cond_ptr = -1;
+			while ($cond_ptr != $cond_lines) {
+				$cond_ptr = $cond_lines;
 
-			# Ignore the current line if it is label.
-			if ($s =~ /^\s*$Ident\s*:/) {
-				$check = 0;
+				# Ignore:
+				#  1) blank lines, they should be at 0,
+				#  2) preprocessor lines, and
+				#  3) labels.
+				if ($s =~ /^\s*?\n/ ||
+				    $s =~ /^\s*#\s*?/ ||
+				    $s =~ /^\s*$Ident\s*:/) {
+					$s =~ s/^.*?\n//;
+					$cond_lines++;
+				}
 			}
 
 			my (undef, $sindent) = line_stats("+" . $s);
@@ -1470,7 +1475,7 @@ sub process {
 				$stat_real = "[...]\n$stat_real";
 			}
 
-			##print "line<$line> prevline<$prevline> indent<$indent> sindent<$sindent> check<$check> continuation<$continuation> s<$s> cond_lines<$cond_lines> stat_real<$stat_real> stat<$stat>\n";
+			#print "line<$line> prevline<$prevline> indent<$indent> sindent<$sindent> check<$check> continuation<$continuation> s<$s> cond_lines<$cond_lines> stat_real<$stat_real> stat<$stat>\n";
 
 			if ($check && (($sindent % 8) != 0 ||
 			    ($sindent <= $indent && $s ne ''))) {
-- 
1.6.0.rc1.258.g80295

