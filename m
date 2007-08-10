Return-Path: <linux-kernel-owner+w=401wt.eu-S1761277AbXHJGgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761277AbXHJGgk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 02:36:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759299AbXHJGey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 02:34:54 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:53369 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753805AbXHJGeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 02:34:25 -0400
Message-ID: <386727660.82703@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070810063419.657077419@mail.ustc.edu.cn>
References: <20070810063412.238042387@mail.ustc.edu.cn>
User-Agent: quilt/0.46-1
Date: Fri, 10 Aug 2007 14:34:15 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Ken Chen <kenchen@google.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Subject: [PATCH 3/4] writeback: function renames and cleanups
Content-Disposition: inline; filename=fs-writeback-cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Two function renames:
	- rename redirty_tail() to queue_dirty_inode()
	- rename requeue_io() to queue_for_more_io()

Also some code cleanups on fs-writeback.c. No behavior changes.

Cc: Ken Chen <kenchen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 fs/fs-writeback.c |  133 ++++++++++++++++++++------------------------
 1 file changed, 62 insertions(+), 71 deletions(-)

--- linux-2.6.23-rc1-mm2.orig/fs/fs-writeback.c
+++ linux-2.6.23-rc1-mm2/fs/fs-writeback.c
@@ -102,6 +102,55 @@ int sb_has_dirty_inodes(struct super_blo
 }
 EXPORT_SYMBOL(sb_has_dirty_inodes);
 
+/*
+ * Enqueue a newly dirtied inode:
+ * 	- set its when-it-was dirtied timestamp
+ * 	- move it to the furthest end of its superblock's dirty-inode list
+ */
+static void queue_dirty_inode(struct inode *inode)
+{
+	check_dirty_inode(inode);
+	inode->dirtied_when = jiffies;
+	list_move(&inode->i_list, &inode->i_sb->s_dirty);
+	check_dirty_inode(inode);
+}
+
+/*
+ * Queue an inode for more io in the next full scan of s_io.
+ */
+static void queue_for_more_io(struct inode *inode)
+{
+	check_dirty_inode(inode);
+	list_move(&inode->i_list, &inode->i_sb->s_more_io);
+	check_dirty_inode(inode);
+}
+
+/*
+ * Queue all possible inodes for a run of io.
+ * The resulting s_io is in order of:
+ * 	- inodes queued for more io from s_more_io(once for a full scan of s_io)
+ * 	- possible remaining inodes in s_io(was a partial scan)
+ * 	- dirty inodes (old enough) from s_dirty
+ */
+static void queue_inodes_for_io(struct super_block *sb,
+				unsigned long *older_than_this)
+{
+	check_dirty_inode_list(sb);
+	if (list_empty(&sb->s_io))
+		list_splice_init(&sb->s_more_io, &sb->s_io); /* eldest first */
+	check_dirty_inode_list(sb);
+	while (!list_empty(&sb->s_dirty)) {
+		struct inode *inode = list_entry(sb->s_dirty.prev,
+						struct inode, i_list);
+		/* Was this inode dirtied too recently? */
+		if (older_than_this &&
+			time_after(inode->dirtied_when, *older_than_this))
+			break;
+		list_move(&inode->i_list, &sb->s_io);
+	}
+	check_dirty_inode_list(sb);
+}
+
 /**
  *	__mark_inode_dirty -	internal function
  *	@inode: inode to mark
@@ -199,12 +248,8 @@ void __mark_inode_dirty(struct inode *in
 		 * If the inode was already on s_dirty/s_io/s_more_io, don't
 		 * reposition it (that would break s_dirty time-ordering).
 		 */
-		if (!was_dirty) {
-			check_dirty_inode(inode);
-			inode->dirtied_when = jiffies;
-			list_move(&inode->i_list, &sb->s_dirty);
-			check_dirty_inode(inode);
-		}
+		if (!was_dirty)
+			queue_dirty_inode(inode);
 	}
 out:
 	spin_unlock(&inode_lock);
@@ -219,55 +264,6 @@ static int write_inode(struct inode *ino
 	return 0;
 }
 
-/*
- * Enqueue a newly dirtied inode:
- * 	- set its when-it-was dirtied timestamp
- * 	- move it to the furthest end of its superblock's dirty-inode list
- */
-static void redirty_tail(struct inode *inode)
-{
-	check_dirty_inode(inode);
-	inode->dirtied_when = jiffies;
-	list_move(&inode->i_list, &inode->i_sb->s_dirty);
-	check_dirty_inode(inode);
-}
-
-/*
- * Queue an inode for more io in the next full scan of s_io.
- */
-static void requeue_io(struct inode *inode)
-{
-	check_dirty_inode(inode);
-	list_move(&inode->i_list, &inode->i_sb->s_more_io);
-	check_dirty_inode(inode);
-}
-
-/*
- * Queue all possible inodes for a run of io.
- * The resulting s_io is in order of:
- * 	- inodes queued for more io from s_more_io(once for a full scan of s_io)
- * 	- possible remaining inodes in s_io(was a partial scan)
- * 	- dirty inodes (old enough) from s_dirty
- */
-static void queue_inodes_for_io(struct super_block *sb,
-				unsigned long *older_than_this)
-{
-	check_dirty_inode_list(sb);
-	if (list_empty(&sb->s_io))
-		list_splice_init(&sb->s_more_io, &sb->s_io); /* eldest first */
-	check_dirty_inode_list(sb);
-	while (!list_empty(&sb->s_dirty)) {
-		struct inode *inode = list_entry(sb->s_dirty.prev,
-						struct inode, i_list);
-		/* Was this inode dirtied too recently? */
-		if (older_than_this &&
-			time_after(inode->dirtied_when, *older_than_this))
-			break;
-		list_move(&inode->i_list, &sb->s_io);
-	}
-	check_dirty_inode_list(sb);
-}
-
 static void inode_sync_complete(struct inode *inode)
 {
 	/*
@@ -329,6 +325,7 @@ __sync_single_inode(struct inode *inode,
 			 * sometimes bales out without doing anything. Redirty
 			 * the inode; Move it from s_io onto s_more_io/s_dirty.
 			 */
+			inode->i_state |= I_DIRTY_PAGES;
 			/*
 			 * akpm: if the caller was the kupdate function we put
 			 * this inode at the head of s_dirty so it gets first
@@ -344,8 +341,7 @@ __sync_single_inode(struct inode *inode,
 				 * to s_more_io so it will get more writeout as
 				 * soon as the queue becomes uncongested.
 				 */
-				inode->i_state |= I_DIRTY_PAGES;
-				requeue_io(inode);
+				queue_for_more_io(inode);
 			} else {
 				/*
 				 * Otherwise fully redirty the inode so that
@@ -354,15 +350,14 @@ __sync_single_inode(struct inode *inode,
 				 * file would indefinitely suspend writeout of
 				 * all the other files.
 				 */
-				inode->i_state |= I_DIRTY_PAGES;
-				redirty_tail(inode);
+				queue_dirty_inode(inode);
 			}
 		} else if (inode->i_state & I_DIRTY) {
 			/*
 			 * Someone redirtied the inode while were writing back
 			 * the pages.
 			 */
-			redirty_tail(inode);
+			queue_dirty_inode(inode);
 		} else if (atomic_read(&inode->i_count)) {
 			/*
 			 * The inode is clean, inuse
@@ -405,7 +400,7 @@ __writeback_single_inode(struct inode *i
 		 * on s_io.  We'll have another go at writing back this inode
 		 * when we completed a full scan of s_io.
 		 */
-		requeue_io(inode);
+		queue_for_more_io(inode);
 
 		/*
 		 * Even if we don't actually write the inode itself here,
@@ -482,7 +477,7 @@ int generic_sync_sb_inodes(struct super_
 		long pages_skipped;
 
 		if (!bdi_cap_writeback_dirty(bdi)) {
-			redirty_tail(inode);
+			queue_dirty_inode(inode);
 			if (sb_is_blkdev_sb(sb)) {
 				/*
 				 * Dirty memory-backed blockdev: the ramdisk
@@ -502,14 +497,14 @@ int generic_sync_sb_inodes(struct super_
 			wbc->encountered_congestion = 1;
 			if (!sb_is_blkdev_sb(sb))
 				break;		/* Skip a congested fs */
-			requeue_io(inode);
+			queue_for_more_io(inode);
 			continue;		/* Skip a congested blockdev */
 		}
 
 		if (wbc->bdi && bdi != wbc->bdi) {
 			if (!sb_is_blkdev_sb(sb))
 				break;		/* fs has the wrong queue */
-			requeue_io(inode);
+			queue_for_more_io(inode);
 			continue;		/* blockdev has wrong queue */
 		}
 
@@ -523,12 +518,8 @@ int generic_sync_sb_inodes(struct super_
 		err = __writeback_single_inode(inode, wbc);
 		if (!ret)
 			ret = err;
-		if (wbc->sync_mode == WB_SYNC_HOLD) {
-			check_dirty_inode(inode);
-			inode->dirtied_when = jiffies;
-			list_move(&inode->i_list, &sb->s_dirty);
-			check_dirty_inode(inode);
-		}
+		if (wbc->sync_mode == WB_SYNC_HOLD)
+			queue_dirty_inode(inode);
 		if (current_is_pdflush())
 			writeback_release(bdi);
 		if (wbc->pages_skipped != pages_skipped) {
@@ -536,7 +527,7 @@ int generic_sync_sb_inodes(struct super_
 			 * writeback is not making progress due to locked
 			 * buffers.  Skip this inode for now.
 			 */
-			redirty_tail(inode);
+			queue_dirty_inode(inode);
 		}
 		spin_unlock(&inode_lock);
 		iput(inode);

-- 
