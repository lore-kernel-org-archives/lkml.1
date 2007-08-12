Return-Path: <linux-kernel-owner+w=401wt.eu-S933675AbXHLJXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933675AbXHLJXe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 05:23:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932927AbXHLJVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 05:21:24 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:37142 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1759808AbXHLJVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 05:21:14 -0400
Message-ID: <386910470.26990@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070812092052.558804846@mail.ustc.edu.cn>
References: <20070812091120.189651872@mail.ustc.edu.cn>
User-Agent: quilt/0.46-1
Date: Sun, 12 Aug 2007 17:11:21 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: "Cc: Ken Chen" <kenchen@google.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Subject: [PATCH 1/6] writeback: fix time ordering of the per superblock inode lists 8
Content-Disposition: inline; filename=inode-dirty-time-ordering-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the time ordering bug re-introduced by
writeback-fix-periodic-superblock-dirty-inode-flushing.patch.

The old logic moves not-yet-expired dirty inodes from s_dirty to s_io,
*only to* move them back. The move-inodes-back-and-forth thing is a mess,
which is eliminated by this patch.

Note that the line
	list_splice_init(&sb->s_more_io, &sb->s_io);
is also moved to queue_io(). Otherwise when there are big dirtied files,
s_io never becomes empty, preventing new expired inodes to get in.

Cc: Ken Chen <kenchen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 fs/fs-writeback.c |   67 +++++++++++++++++++++++++-------------------
 1 file changed, 39 insertions(+), 28 deletions(-)

--- linux-2.6.23-rc2-mm2.orig/fs/fs-writeback.c
+++ linux-2.6.23-rc2-mm2/fs/fs-writeback.c
@@ -118,7 +118,7 @@ void __mark_inode_dirty(struct inode *in
 			goto out;
 
 		/*
-		 * If the inode was already on s_dirty or s_io, don't
+		 * If the inode was already on s_dirty/s_io/s_more_io, don't
 		 * reposition it (that would break s_dirty time-ordering).
 		 */
 		if (!was_dirty) {
@@ -172,6 +172,34 @@ static void requeue_io(struct inode *ino
 }
 
 /*
+ * Move expired dirty inodes from @delaying_queue to @dispatch_queue.
+ */
+static void move_expired_inodes(struct list_head *delaying_queue,
+			       struct list_head *dispatch_queue,
+				unsigned long *older_than_this)
+{
+	while (!list_empty(delaying_queue)) {
+		struct inode *inode = list_entry(delaying_queue->prev,
+						struct inode, i_list);
+		if (older_than_this &&
+			time_after(inode->dirtied_when, *older_than_this))
+			break;
+		list_move(&inode->i_list, dispatch_queue);
+	}
+}
+
+/*
+ * Queue all expired dirty inodes for io, eldest first.
+ */
+static void queue_io(struct super_block *sb,
+				unsigned long *older_than_this)
+{
+	if (list_empty(&sb->s_io))
+		list_splice_init(&sb->s_more_io, &sb->s_io);
+	move_expired_inodes(&sb->s_dirty, &sb->s_io, older_than_this);
+}
+
+/*
  * Write a single inode's dirty pages and inode data out to disk.
  * If `wait' is set, wait on the writeout.
  *
@@ -221,7 +249,7 @@ __sync_single_inode(struct inode *inode,
 			/*
 			 * We didn't write back all the pages.  nfs_writepages()
 			 * sometimes bales out without doing anything. Redirty
-			 * the inode.  It is moved from s_io onto s_dirty.
+			 * the inode; Move it from s_io onto s_more_io/s_dirty.
 			 */
 			/*
 			 * akpm: if the caller was the kupdate function we put
@@ -234,10 +262,9 @@ __sync_single_inode(struct inode *inode,
 			 */
 			if (wbc->for_kupdate) {
 				/*
-				 * For the kupdate function we leave the inode
-				 * at the head of sb_dirty so it will get more
-				 * writeout as soon as the queue becomes
-				 * uncongested.
+				 * For the kupdate function we move the inode
+				 * to s_more_io so it will get more writeout as
+				 * soon as the queue becomes uncongested.
 				 */
 				inode->i_state |= I_DIRTY_PAGES;
 				requeue_io(inode);
@@ -295,10 +322,10 @@ __writeback_single_inode(struct inode *i
 
 		/*
 		 * We're skipping this inode because it's locked, and we're not
-		 * doing writeback-for-data-integrity.  Move it to the head of
-		 * s_dirty so that writeback can proceed with the other inodes
-		 * on s_io.  We'll have another go at writing back this inode
-		 * when the s_dirty iodes get moved back onto s_io.
+		 * doing writeback-for-data-integrity.  Move it to s_more_io so
+		 * that writeback can proceed with the other inodes on s_io.
+		 * We'll have another go at writing back this inode when we
+		 * completed a full scan of s_io.
 		 */
 		requeue_io(inode);
 
@@ -362,10 +389,8 @@ __writeback_single_inode(struct inode *i
 static void
 sync_sb_inodes(struct super_block *sb, struct writeback_control *wbc)
 {
-	const unsigned long start = jiffies;	/* livelock avoidance */
-
 	if (!wbc->for_kupdate || list_empty(&sb->s_io))
-		list_splice_init(&sb->s_dirty, &sb->s_io);
+		queue_io(sb, wbc->older_than_this);
 
 	while (!list_empty(&sb->s_io)) {
 		struct inode *inode = list_entry(sb->s_io.prev,
@@ -406,17 +431,6 @@ sync_sb_inodes(struct super_block *sb, s
 			continue;		/* blockdev has wrong queue */
 		}
 
-		/* Was this inode dirtied after sync_sb_inodes was called? */
-		if (time_after(inode->dirtied_when, start))
-			break;
-
-		/* Was this inode dirtied too recently? */
-		if (wbc->older_than_this && time_after(inode->dirtied_when,
-						*wbc->older_than_this)) {
-			list_splice_init(&sb->s_io, sb->s_dirty.prev);
-			break;
-		}
-
 		/* Is another pdflush already flushing this queue? */
 		if (current_is_pdflush() && !writeback_acquire(bdi))
 			break;
@@ -446,9 +460,6 @@ sync_sb_inodes(struct super_block *sb, s
 			break;
 	}
 
-	if (list_empty(&sb->s_io))
-		list_splice_init(&sb->s_more_io, &sb->s_io);
-
 	return;		/* Leave any unwritten inodes on s_io */
 }
 
@@ -458,7 +469,7 @@ sync_sb_inodes(struct super_block *sb, s
  * Note:
  * We don't need to grab a reference to superblock here. If it has non-empty
  * ->s_dirty it's hadn't been killed yet and kill_super() won't proceed
- * past sync_inodes_sb() until both the ->s_dirty and ->s_io lists are
+ * past sync_inodes_sb() until the ->s_dirty/s_io/s_more_io lists are all
  * empty. Since __sync_single_inode() regains inode_lock before it finally moves
  * inode from superblock lists we are OK.
  *

-- 
