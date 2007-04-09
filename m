Return-Path: <linux-kernel-owner+w=401wt.eu-S933795AbXDIO4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933795AbXDIO4e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 10:56:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933760AbXDIOzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 10:55:07 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:44031 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933793AbXDIOzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 10:55:03 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 06/21] Unionfs: Provide more helpful info on branch leaks during unmount
Date: Mon,  9 Apr 2007 10:53:57 -0400
Message-Id: <11761304531397-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.0.3.268.g3dda
In-Reply-To: <11761304521844-git-send-email-jsipek@cs.sunysb.edu>
References: <11761304521844-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
[jsipek: no need to take a read lock on the superblock private data]
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/super.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/fs/unionfs/super.c b/fs/unionfs/super.c
index 571b589..037c47d 100644
--- a/fs/unionfs/super.c
+++ b/fs/unionfs/super.c
@@ -97,6 +97,7 @@ static void unionfs_put_super(struct super_block *sb)
 {
 	int bindex, bstart, bend;
 	struct unionfs_sb_info *spd;
+	int leaks = 0;
 
 	spd = UNIONFS_SB(sb);
 	if (!spd)
@@ -107,7 +108,12 @@ static void unionfs_put_super(struct super_block *sb)
 
 	/* Make sure we have no leaks of branchget/branchput. */
 	for (bindex = bstart; bindex <= bend; bindex++)
-		BUG_ON(branch_count(sb, bindex) != 0);
+		if (branch_count(sb, bindex) != 0) {
+			printk("unionfs: branch %d has %d references left!\n",
+			       bindex, branch_count(sb,bindex));
+			leaks = 1;
+		}
+	BUG_ON(leaks != 0);
 
 	kfree(spd->data);
 	kfree(spd);
-- 
1.5.0.3.268.g3dda

