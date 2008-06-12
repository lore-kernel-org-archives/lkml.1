Return-Path: <linux-kernel-owner+w=401wt.eu-S1760335AbYFLMIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760335AbYFLMIZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 08:08:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757039AbYFLMHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 08:07:41 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:4312 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756625AbYFLMHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 08:07:40 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 08/23] checkpatch: macros: fix statement counting block end detection
Date: Thu, 12 Jun 2008 13:05:47 +0100
Message-Id: <1213272362-19457-9-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.5.6.rc0.140.ga9675
In-Reply-To: <1213272362-19457-1-git-send-email-apw@shadowen.org>
References: <1213272362-19457-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are incorrectly counting the lines in a block while accumulating
the trailing lines in a macro statement, leading to false positives.
Fix end of block handling and general counting for negative context lines.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 scripts/checkpatch.pl |   23 +++++++++++------------
 1 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index b2b0648..add8686 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -470,7 +470,9 @@ sub ctx_statement_block {
 		}
 		$off++;
 	}
+	# We are truly at the end, so shuffle to the next line.
 	if ($off == $len) {
+		$loff = $len + 1;
 		$line++;
 		$remain--;
 	}
@@ -1793,30 +1795,26 @@ sub process {
 				$lines[$ln - 1] =~ /^(?:-|..*\\$)/)
 			{
 				$ctx .= $rawlines[$ln - 1] . "\n";
+				$cnt-- if ($lines[$ln - 1] !~ /^-/);
 				$ln++;
-				$cnt--;
 			}
 			$ctx .= $rawlines[$ln - 1];
 
 			($dstat, $dcond, $ln, $cnt, $off) =
 				ctx_statement_block($linenr, $ln - $linenr + 1, 0);
 			#print "dstat<$dstat> dcond<$dcond> cnt<$cnt> off<$off>\n";
-			#print "LINE<$lines[$ln]> len<" . length($lines[$ln]) . "\n";
+			#print "LINE<$lines[$ln-1]> len<" . length($lines[$ln-1]) . "\n";
 
 			# Extract the remainder of the define (if any) and
 			# rip off surrounding spaces, and trailing \'s.
 			$rest = '';
-			if (defined $lines[$ln - 1] &&
-			    $off > length($lines[$ln - 1]))
-			{
-				$ln++;
-				$cnt--;
-				$off = 0;
-			}
-			while ($cnt > 0) {
-				$rest .= substr($lines[$ln - 1], $off) . "\n";
+			while ($off != 0 || ($cnt > 0 && $rest =~ /(?:^|\\)\s*$/)) {
+				#print "ADDING $off <" . substr($lines[$ln - 1], $off) . ">\n";
+				if ($off != 0 || $lines[$ln - 1] !~ /^-/) {
+					$rest .= substr($lines[$ln - 1], $off) . "\n";
+					$cnt--;
+				}
 				$ln++;
-				$cnt--;
 				$off = 0;
 			}
 			$rest =~ s/\\\n.//g;
@@ -1847,6 +1845,7 @@ sub process {
 				DEFINE_PER_CPU|
 				__typeof__\(
 			}x;
+			#print "REST<$rest>\n";
 			if ($rest ne '') {
 				if ($rest !~ /while\s*\(/ &&
 				    $dstat !~ /$exceptions/)
-- 
1.5.6.rc0.140.ga9675

