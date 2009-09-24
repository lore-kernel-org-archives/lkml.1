Return-Path: <linux-kernel-owner+w=401wt.eu-S1753270AbZIXOkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270AbZIXOkq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 10:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753236AbZIXOkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 10:40:41 -0400
Received: from brick.kernel.dk ([93.163.65.50]:44140 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753181AbZIXOki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 10:40:38 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: fengguang.wu@intel.com, shaohua.li@intel.com, chris.mason@oracle.com,
       jack@suse.cz, Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 10/10] writeback: make the super_block pinning more efficient
Date: Thu, 24 Sep 2009 16:40:36 +0200
Message-Id: <1253803236-20760-11-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.3.3.385.g60647
In-Reply-To: <1253803236-20760-1-git-send-email-jens.axboe@oracle.com>
References: <1253803236-20760-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we pin the inode->i_sb for every single inode. This
increases cache traffic on sb->s_umount sem. Lets instead
cache the inode sb pin state and keep the super_block pinned
for as long as keep writing out inodes from the same
super_block.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/fs-writeback.c |   46 +++++++++++++++++++++++++++++-----------------
 1 files changed, 29 insertions(+), 17 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 225c731..c6bf775 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -540,6 +540,17 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 	return ret;
 }
 
+static void unpin_sb_for_writeback(struct super_block **psb)
+{
+	struct super_block *sb = *psb;
+
+	if (sb) {
+		up_read(&sb->s_umount);
+		put_super(sb);
+		*psb = NULL;
+	}
+}
+
 /*
  * For WB_SYNC_NONE writeback, the caller does not have the sb pinned
  * before calling writeback. So make sure that we do pin it, so it doesn't
@@ -549,11 +560,20 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
  * 1 if we failed.
  */
 static int pin_sb_for_writeback(struct writeback_control *wbc,
-				   struct inode *inode)
+				struct inode *inode, struct super_block **psb)
 {
 	struct super_block *sb = inode->i_sb;
 
 	/*
+	 * If this sb is already pinned, nothing more to do. If not and
+	 * *psb is non-NULL, unpin the old one first
+	 */
+	if (sb == *psb)
+		return 0;
+	else if (*psb)
+		unpin_sb_for_writeback(psb);
+
+	/*
 	 * Caller must already hold the ref for this
 	 */
 	if (wbc->sync_mode == WB_SYNC_ALL) {
@@ -566,7 +586,7 @@ static int pin_sb_for_writeback(struct writeback_control *wbc,
 	if (down_read_trylock(&sb->s_umount)) {
 		if (sb->s_root) {
 			spin_unlock(&sb_lock);
-			return 0;
+			goto pinned;
 		}
 		/*
 		 * umounted, drop rwsem again and fall through to failure
@@ -577,24 +597,15 @@ static int pin_sb_for_writeback(struct writeback_control *wbc,
 	sb->s_count--;
 	spin_unlock(&sb_lock);
 	return 1;
-}
-
-static void unpin_sb_for_writeback(struct writeback_control *wbc,
-				   struct inode *inode)
-{
-	struct super_block *sb = inode->i_sb;
-
-	if (wbc->sync_mode == WB_SYNC_ALL)
-		return;
-
-	up_read(&sb->s_umount);
-	put_super(sb);
+pinned:
+	*psb = sb;
+	return 0;
 }
 
 static void writeback_inodes_wb(struct bdi_writeback *wb,
 				struct writeback_control *wbc)
 {
-	struct super_block *sb = wbc->sb;
+	struct super_block *sb = wbc->sb, *pin_sb = NULL;
 	const int is_blkdev_sb = sb_is_blkdev_sb(sb);
 	const unsigned long start = jiffies;	/* livelock avoidance */
 
@@ -653,7 +664,7 @@ static void writeback_inodes_wb(struct bdi_writeback *wb,
 		if (inode_dirtied_after(inode, start))
 			break;
 
-		if (pin_sb_for_writeback(wbc, inode)) {
+		if (pin_sb_for_writeback(wbc, inode, &pin_sb)) {
 			requeue_io(inode);
 			continue;
 		}
@@ -662,7 +673,6 @@ static void writeback_inodes_wb(struct bdi_writeback *wb,
 		__iget(inode);
 		pages_skipped = wbc->pages_skipped;
 		writeback_single_inode(inode, wbc);
-		unpin_sb_for_writeback(wbc, inode);
 		if (wbc->pages_skipped != pages_skipped) {
 			/*
 			 * writeback is not making progress due to locked
@@ -682,6 +692,8 @@ static void writeback_inodes_wb(struct bdi_writeback *wb,
 			wbc->more_io = 1;
 	}
 
+	unpin_sb_for_writeback(&pin_sb);
+
 	spin_unlock(&inode_lock);
 	/* Leave any unwritten inodes on b_io */
 }
-- 
1.6.4.1.207.g68ea

