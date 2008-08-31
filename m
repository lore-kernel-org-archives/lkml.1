Return-Path: <linux-kernel-owner+w=401wt.eu-S1759535AbYHaNPQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759535AbYHaNPQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 09:15:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758881AbYHaNOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 09:14:44 -0400
Received: from smtp.nokia.com ([192.100.122.233]:61149 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758755AbYHaNOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 09:14:43 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: linux-fsdevel-owner@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <ext-adrian.hunter@nokia.com>
Subject: [PATCH] UBIFS: fix zero-length truncations
Date: Sun, 31 Aug 2008 17:52:35 +0300
Message-Id: <1220194366-12731-2-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1220194366-12731-1-git-send-email-dedekind@infradead.org>
References: <1220194366-12731-1-git-send-email-dedekind@infradead.org>
X-OriginalArrivalTime: 31 Aug 2008 13:14:25.0494 (UTC) FILETIME=[7DB12F60:01C90B6B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

Always allow truncations to zero, even if budgeting thinks there
is no space. UBIFS reserves some space for deletions anyway.

Otherwise, the following happans:
1. create a file, and write as much as possible there, until ENOSPC
2. truncate the file, which fails with ENOSPC, which is not good.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/ubifs/dir.c  |    1 -
 fs/ubifs/file.c |   20 ++++++++++++++++----
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index 5c96f1f..2b267c9 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -587,7 +587,6 @@ static int ubifs_unlink(struct inode *dir, struct dentry *dentry)
 	if (err) {
 		if (err != -ENOSPC)
 			return err;
-		err = 0;
 		budgeted = 0;
 	}
 
diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index 4071d1c..3d698e2 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -793,7 +793,7 @@ static int do_truncation(struct ubifs_info *c, struct inode *inode,
 	int err;
 	struct ubifs_budget_req req;
 	loff_t old_size = inode->i_size, new_size = attr->ia_size;
-	int offset = new_size & (UBIFS_BLOCK_SIZE - 1);
+	int offset = new_size & (UBIFS_BLOCK_SIZE - 1), budgeted = 1;
 	struct ubifs_inode *ui = ubifs_inode(inode);
 
 	dbg_gen("ino %lu, size %lld -> %lld", inode->i_ino, old_size, new_size);
@@ -811,8 +811,15 @@ static int do_truncation(struct ubifs_info *c, struct inode *inode,
 	/* A funny way to budget for truncation node */
 	req.dirtied_ino_d = UBIFS_TRUN_NODE_SZ;
 	err = ubifs_budget_space(c, &req);
-	if (err)
-		return err;
+	if (err) {
+		/*
+		 * Treat truncations to zero as deletion and always allow them,
+		 * just like we do for '->unlink()'.
+		 */
+		if (new_size || err != -ENOSPC)
+			return err;
+		budgeted = 0;
+	}
 
 	err = vmtruncate(inode, new_size);
 	if (err)
@@ -869,7 +876,12 @@ static int do_truncation(struct ubifs_info *c, struct inode *inode,
 	err = ubifs_jnl_truncate(c, inode, old_size, new_size);
 	mutex_unlock(&ui->ui_mutex);
 out_budg:
-	ubifs_release_budget(c, &req);
+	if (budgeted)
+		ubifs_release_budget(c, &req);
+	else {
+		c->nospace = c->nospace_rp = 0;
+		smp_wmb();
+	}
 	return err;
 }
 
-- 
1.5.4.1

