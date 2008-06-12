Return-Path: <linux-kernel-owner+w=401wt.eu-S1760116AbYFLMHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760116AbYFLMHr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 08:07:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754617AbYFLMHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 08:07:38 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:4307 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214AbYFLMHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 08:07:37 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 09/23] checkpatch: trailing statement indent: fix end of statement location
Date: Thu, 12 Jun 2008 13:05:48 +0100
Message-Id: <1213272362-19457-10-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.5.6.rc0.140.ga9675
In-Reply-To: <1213272362-19457-1-git-send-email-apw@shadowen.org>
References: <1213272362-19457-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix end of statement location.  Where the last line of the statement is
replaced we are miss reporting the newly added replacement an incorrectly
indented trailing statement for the negative context.  We are also
incorrectly reporting negative statements generally.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 scripts/checkpatch.pl |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index add8686..89177c3 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1249,17 +1249,22 @@ sub process {
 			my $pre_ctx = "$1$2";
 
 			my ($level, @ctx) = ctx_statement_level($linenr, $realcnt, 0);
-			my $ctx_ln = $linenr + $#ctx + 1;
 			my $ctx_cnt = $realcnt - $#ctx - 1;
 			my $ctx = join("\n", @ctx);
 
-			##warn "realcnt<$realcnt> ctx_cnt<$ctx_cnt>\n";
+			my $ctx_ln = $linenr;
+			my $ctx_skip = $realcnt;
 
-			# Skip over any removed lines in the context following statement.
-			while (defined($lines[$ctx_ln - 1]) && $lines[$ctx_ln - 1] =~ /^-/) {
+			while ($ctx_skip > $ctx_cnt || ($ctx_skip == $ctx_cnt &&
+					defined $lines[$ctx_ln - 1] &&
+					$lines[$ctx_ln - 1] =~ /^-/)) {
+				##print "SKIP<$ctx_skip> CNT<$ctx_cnt>\n";
+				$ctx_skip-- if (!defined $lines[$ctx_ln - 1] || $lines[$ctx_ln - 1] !~ /^-/);
 				$ctx_ln++;
 			}
-			##warn "pre<$pre_ctx>\nline<$line>\nctx<$ctx>\nnext<$lines[$ctx_ln - 1]>\n";
+
+			##print "realcnt<$realcnt> ctx_cnt<$ctx_cnt>\n";
+			##print "pre<$pre_ctx>\nline<$line>\nctx<$ctx>\nnext<$lines[$ctx_ln - 1]>\n";
 
 			if ($ctx !~ /{\s*/ && defined($lines[$ctx_ln -1]) && $lines[$ctx_ln - 1] =~ /^\+\s*{/) {
 				ERROR("that open brace { should be on the previous line\n" .
-- 
1.5.6.rc0.140.ga9675

