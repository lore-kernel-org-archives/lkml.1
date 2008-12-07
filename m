Return-Path: <linux-kernel-owner+w=401wt.eu-S1755958AbYLGScL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958AbYLGScL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 13:32:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754006AbYLGSbD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 13:31:03 -0500
Received: from bigben2.bytemark.co.uk ([80.68.81.132]:55699 "EHLO
	bigben2.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099AbYLGSbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 13:31:00 -0500
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 03/13] checkpatch: Add warning for p0-patches
Date: Sun,  7 Dec 2008 18:30:40 +0000
Message-Id: <1228674650-24392-4-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.6.0.4.911.gc990
In-Reply-To: <1228674650-24392-1-git-send-email-apw@shadowen.org>
References: <1228674650-24392-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wolfram Sang <w.sang@pengutronix.de>

Some people work internally with -p0-patches which has the danger that
one forgets to convert them to -p1 before mainlining. Bitten myself and
seen p0-patches in mailing lists occasionally, this patch adds a warning
to checkpatch.pl in case a patch is -p0. If you really want, you can
fool this check to generate false positives, this is why it just spits a
warning. Making the check 100% proof is trickier than it looks, so let's
start with a version which catches the cases of real use.

[apw@canonical.com: update message language, handle null prefix, add tests]
Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index f015698..b953c76 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1057,6 +1057,7 @@ sub process {
 	my $in_comment = 0;
 	my $comment_edge = 0;
 	my $first_line = 0;
+	my $p1_prefix = '';
 
 	my $prev_values = 'E';
 
@@ -1205,7 +1206,12 @@ sub process {
 		# extract the filename as it passes
 		if ($line=~/^\+\+\+\s+(\S+)/) {
 			$realfile = $1;
-			$realfile =~ s@^[^/]*/@@;
+			$realfile =~ s@^([^/]*)/@@;
+
+			$p1_prefix = $1;
+			if ($tree && $p1_prefix ne '' && -e "$root/$p1_prefix") {
+				WARN("patch prefix '$p1_prefix' exists, appears to be a -p0 patch\n");
+			}
 
 			if ($realfile =~ m@^include/asm/@) {
 				ERROR("do not modify files in include/asm, change architecture specific files in include/asm-<architecture>\n" . "$here$rawline\n");
-- 
1.6.0.4.911.gc990

