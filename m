Return-Path: <linux-kernel-owner+w=401wt.eu-S1757879AbYHKUP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757879AbYHKUP6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 16:15:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753937AbYHKUNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 16:13:25 -0400
Received: from bigben2.bytemark.co.uk ([80.68.81.132]:41175 "EHLO
	bigben2.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954AbYHKUNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 16:13:19 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 08/17] checkpatch: fix up comment checks search to scan the entire block
Date: Mon, 11 Aug 2008 21:13:03 +0100
Message-Id: <1218485592-6679-9-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.6.0.rc1.258.g80295
In-Reply-To: <1218485592-6679-1-git-send-email-apw@shadowen.org>
References: <1218485592-6679-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are not counting the lines in the block correctly which causes the
comment scan to stop prematurly and thus miss comments which end at the
end of the block.  Fix this up.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 scripts/checkpatch.pl |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 586f9a4..482768c 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1029,9 +1029,14 @@ sub process {
 			# edge is a close comment then we must be in a comment
 			# at context start.
 			my $edge;
-			for (my $ln = $linenr + 1; $ln < ($linenr + $realcnt); $ln++) {
-				next if ($line =~ /^-/);
-				($edge) = ($rawlines[$ln - 1] =~ m@(/\*|\*/)@);
+			my $cnt = $realcnt;
+			for (my $ln = $linenr + 1; $cnt > 0; $ln++) {
+				next if (defined $rawlines[$ln - 1] &&
+					 $rawlines[$ln - 1] =~ /^-/);
+				$cnt--;
+				#print "RAW<$rawlines[$ln - 1]>\n";
+				($edge) = (defined $rawlines[$ln - 1] &&
+					$rawlines[$ln - 1] =~ m@(/\*|\*/)@);
 				last if (defined $edge);
 			}
 			if (defined $edge && $edge eq '*/') {
-- 
1.6.0.rc1.258.g80295

