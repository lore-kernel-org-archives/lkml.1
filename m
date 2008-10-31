Return-Path: <linux-kernel-owner+w=401wt.eu-S1753385AbYJaPgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385AbYJaPgV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 11:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751818AbYJaPfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 11:35:53 -0400
Received: from metis.extern.pengutronix.de ([83.236.181.26]:56446 "EHLO
	metis.extern.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751666AbYJaPfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 11:35:52 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: apw@shadowen.org
Cc: linux-kernel@vger.kernel.org, Wolfram Sang <w.sang@pengutronix.de>
Subject: [PATCH][RESEND] checkpatch: Add warning for p0-patches
Date: Fri, 31 Oct 2008 16:36:10 +0100
Message-Id: <1225467370-19143-1-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.5.6.5
X-SA-Exim-Connect-IP: 10.1.0.89
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.extern.pengutronix.de); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some people work internally with -p0-patches which has the danger that
one forgets to convert them to -p1 before mainlining. Bitten myself and
seen p0-patches in mailing lists occasionally, this patch adds a warning
to checkpatch.pl in case a patch is -p0. If you really want, you can
fool this check to generate false positives, this is why it just spits a
warning. Making the check 100% proof is trickier than it looks, so let's
start with a version which catches the cases of real use.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
---
 scripts/checkpatch.pl |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index f88bb3e..dae5854 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1051,6 +1051,7 @@ sub process {
 	my $in_comment = 0;
 	my $comment_edge = 0;
 	my $first_line = 0;
+	my $p1_prefix = '';
 
 	my $prev_values = 'E';
 
@@ -1196,7 +1197,12 @@ sub process {
 		# extract the filename as it passes
 		if ($line=~/^\+\+\+\s+(\S+)/) {
 			$realfile = $1;
-			$realfile =~ s@^[^/]*/@@;
+			$realfile =~ s@^([^/]*)/@@;
+
+			$p1_prefix = $1;
+			if ($tree && -e "$root/$p1_prefix") {
+				WARN("Patch prefix '$p1_prefix' exists. Is it maybe a p0-patch?\n");
+			}
 
 			if ($realfile =~ m@^include/asm/@) {
 				ERROR("do not modify files in include/asm, change architecture specific files in include/asm-<architecture>\n" . "$here$rawline\n");
-- 
1.5.6.5

