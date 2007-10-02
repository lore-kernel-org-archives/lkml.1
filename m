Return-Path: <linux-kernel-owner+w=401wt.eu-S1756686AbXJBJEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686AbXJBJEj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 05:04:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754352AbXJBJDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 05:03:08 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:39060 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752504AbXJBJDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 05:03:00 -0400
Message-ID: <391315778.17593@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20071002090254.596842343@mail.ustc.edu.cn>
References: <20071002084143.110486039@mail.ustc.edu.cn>
User-Agent: quilt/0.46-1
Date: Tue, 02 Oct 2007 16:41:45 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, Ken Chen <kenchen@google.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Michael Rubin <mrubin@google.com>
Subject: [PATCH 2/5] writeback: fix time ordering of the per superblock inode lists 8
Content-Disposition: inline; filename=inode-dirty-time-ordering-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Streamline the management of dirty inode lists and fix time ordering bugs.

The writeback logic used to moving not-yet-expired dirty inodes from s_dirty to
s_io, *only to* move them back. The move-inodes-back-and-forth thing is a mess,
which is eliminated by this patch.

The new scheme is:
- s_dirty acts as a time ordered io delaying queue;
- s_io/s_more_io together acts as an io dispatching queue.

On kupdate writeback, we pull some inodes from s_dirty to s_io at the start of
every full scan of s_io.  Otherwise(i.e. for sync/throttle/background
writeback), we always pull from s_dirty on each run(a partial scan).

Note that the line
	list_splice_init(&sb->s_more_io, &sb->s_io);
is moved to queue_io() to leave s_io empty. Otherwise a big dirtied file will
sit in s_io for a long time, preventing new expired inodes to get in.

Cc: Ken Chen <kenchen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 fs/fs-writeback.c |   59 ++++++++++++++++++++++++++++----------------
 1 file changed, 38 insertions(+), 21 deletions(-)

--- linux-2.6.23-rc8-mm2.orig/fs/fs-writeback.c
+++ linux-2.6.23-rc8-mm2/fs/fs-writeback.c
@@ -119,7 +119,7 @@ void __mark_inode_dirty(struct inode *in
 			goto out;
 
 		/*
-		 * If the inode was already on s_dirty or s_io, don't
+		 * If the inode was already on s_dirty/s_io/s_more_io, don't
 		 * reposition it (that would break s_dirty time-ordering).
 		 */
 		if (!was_dirty) {
@@ -182,6 +182,33 @@ static void inode_sync_complete(struct i
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
+	list_splice_init(&sb->s_more_io, sb->s_io.prev);
+	move_expired_inodes(&sb->s_dirty, &sb->s_io, older_than_this);
+}
+
+/*
  * Write a single inode's dirty pages and inode data out to disk.
  * If `wait' is set, wait on the writeout.
  *
@@ -231,7 +258,7 @@ __sync_single_inode(struct inode *inode,
 			/*
 			 * We didn't write back all the pages.  nfs_writepages()
 			 * sometimes bales out without doing anything. Redirty
-			 * the inode.  It is moved from s_io onto s_dirty.
+			 * the inode; Move it from s_io onto s_more_io/s_dirty.
 			 */
 			/*
 			 * akpm: if the caller was the kupdate function we put
@@ -244,10 +271,9 @@ __sync_single_inode(struct inode *inode,
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
@@ -305,10 +331,10 @@ __writeback_single_inode(struct inode *i
 
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
 
@@ -376,7 +402,7 @@ int generic_sync_sb_inodes(struct super_
 	spin_lock(&inode_lock);
 
 	if (!wbc->for_kupdate || list_empty(&sb->s_io))
-		list_splice_init(&sb->s_dirty, &sb->s_io);
+		queue_io(sb, wbc->older_than_this);
 
 	while (!list_empty(&sb->s_io)) {
 		int err;
@@ -423,13 +449,6 @@ int generic_sync_sb_inodes(struct super_
 		if (time_after(inode->dirtied_when, start))
 			break;
 
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
@@ -461,8 +480,6 @@ int generic_sync_sb_inodes(struct super_
 			break;
 	}
 
-	if (list_empty(&sb->s_io))
-		list_splice_init(&sb->s_more_io, &sb->s_io);
 	spin_unlock(&inode_lock);
 	return ret;		/* Leave any unwritten inodes on s_io */
 }
@@ -482,7 +499,7 @@ static int sync_sb_inodes(struct super_b
  * Note:
  * We don't need to grab a reference to superblock here. If it has non-empty
  * ->s_dirty it's hadn't been killed yet and kill_super() won't proceed
- * past sync_inodes_sb() until both the ->s_dirty and ->s_io lists are
+ * past sync_inodes_sb() until the ->s_dirty/s_io/s_more_io lists are all
  * empty. Since __sync_single_inode() regains inode_lock before it finally moves
  * inode from superblock lists we are OK.
  *

-- 
