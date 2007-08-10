Return-Path: <linux-kernel-owner+w=401wt.eu-S1759561AbXHJGgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759561AbXHJGgL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 02:36:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759306AbXHJGe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 02:34:57 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:53351 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753292AbXHJGeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 02:34:25 -0400
Message-ID: <386727659.72627@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070810063419.549052142@mail.ustc.edu.cn>
References: <20070810063412.238042387@mail.ustc.edu.cn>
User-Agent: quilt/0.46-1
Date: Fri, 10 Aug 2007 14:34:14 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Ken Chen <kenchen@google.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Subject: [PATCH 2/4] writeback: 3-queue based writeback schedule
Content-Disposition: inline; filename=io-dirty-order-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Properly manage the 3 queues of sb->s_dirty/s_io/s_more_io so that
	- time-ordering of dirtied_when can be easily maintained
	- writeback can continue from where previous run left out

The majority work has been done by Andrew Morton and Ken Chen,
this patch just clarifies the roles of the 3 queues:
- s_dirty   for io delay(up to dirty_expire_interval)
- s_io      for io run(a full scan of s_io may involve multiple runs)
- s_more_io for io continuation

The following paradigm shows the data flow.

                            requeue on new scan(empty s_io)
                            +-----------------------------+
                            |                             |
 dirty           old        |                             |
 inodes          enough     V                             |
 ======> s_dirty ======> s_io                             |
         ^                |     requeue io                |
         |                +---------------------> s_more_io
         |   hold back    |
         +----------------+----------> disk write requests

sb->s_dirty: a FIFO queue
- s_dirty hosts not-yet-expired(recently dirtied) dirty inodes
- once expired, inodes will be moved out of s_dirty and *never put back*
  (unless for some reason we have to hold on the inode for some time)

sb->s_io and sb->s_more_io: a cyclic queue scanned for io
- on each run of generic_sync_sb_inodes(), some more s_dirty inodes may be
  appended to s_io
- on each full scan of s_io, all s_more_io inodes will be moved back to s_io
- large files that cannot be synced in one run will be moved to s_more_io for
  retry on next full scan

inode->dirtied_when
- inode->dirtied_when is updated to the *current* jiffies on pushing into
  s_dirty, and is never changed in other cases.
- time-ordering thus can be simply ensured while moving inodes between lists,
  since (time order == enqueue order)

Cc: Ken Chen <kenchen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 fs/fs-writeback.c |  106 +++++++++++++++++++++-----------------------
 1 file changed, 52 insertions(+), 54 deletions(-)

--- linux-2.6.23-rc1-mm2.orig/fs/fs-writeback.c
+++ linux-2.6.23-rc1-mm2/fs/fs-writeback.c
@@ -93,6 +93,15 @@ static void __check_dirty_inode_list(str
 						__FILE__, __LINE__);	\
 	} while (0)
 
+
+int sb_has_dirty_inodes(struct super_block *sb)
+{
+	return !list_empty(&sb->s_dirty) ||
+	       !list_empty(&sb->s_io) ||
+	       !list_empty(&sb->s_more_io);
+}
+EXPORT_SYMBOL(sb_has_dirty_inodes);
+
 /**
  *	__mark_inode_dirty -	internal function
  *	@inode: inode to mark
@@ -187,7 +196,7 @@ void __mark_inode_dirty(struct inode *in
 			goto out;
 
 		/*
-		 * If the inode was already on s_dirty or s_io, don't
+		 * If the inode was already on s_dirty/s_io/s_more_io, don't
 		 * reposition it (that would break s_dirty time-ordering).
 		 */
 		if (!was_dirty) {
@@ -211,33 +220,20 @@ static int write_inode(struct inode *ino
 }
 
 /*
- * Redirty an inode: set its when-it-was dirtied timestamp and move it to the
- * furthest end of its superblock's dirty-inode list.
- *
- * Before stamping the inode's ->dirtied_when, we check to see whether it is
- * already the most-recently-dirtied inode on the s_dirty list.  If that is
- * the case then the inode must have been redirtied while it was being written
- * out and we don't reset its dirtied_when.
+ * Enqueue a newly dirtied inode:
+ * 	- set its when-it-was dirtied timestamp
+ * 	- move it to the furthest end of its superblock's dirty-inode list
  */
 static void redirty_tail(struct inode *inode)
 {
-	struct super_block *sb = inode->i_sb;
-
 	check_dirty_inode(inode);
-	if (!list_empty(&sb->s_dirty)) {
-		struct inode *tail_inode;
-
-		tail_inode = list_entry(sb->s_dirty.next, struct inode, i_list);
-		if (!time_after_eq(inode->dirtied_when,
-				tail_inode->dirtied_when))
-			inode->dirtied_when = jiffies;
-	}
-	list_move(&inode->i_list, &sb->s_dirty);
+	inode->dirtied_when = jiffies;
+	list_move(&inode->i_list, &inode->i_sb->s_dirty);
 	check_dirty_inode(inode);
 }
 
 /*
- * requeue inode for re-scanning after sb->s_io list is exhausted.
+ * Queue an inode for more io in the next full scan of s_io.
  */
 static void requeue_io(struct inode *inode)
 {
@@ -246,6 +242,32 @@ static void requeue_io(struct inode *ino
 	check_dirty_inode(inode);
 }
 
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
 static void inode_sync_complete(struct inode *inode)
 {
 	/*
@@ -305,7 +327,7 @@ __sync_single_inode(struct inode *inode,
 			/*
 			 * We didn't write back all the pages.  nfs_writepages()
 			 * sometimes bales out without doing anything. Redirty
-			 * the inode.  It is moved from s_io onto s_dirty.
+			 * the inode; Move it from s_io onto s_more_io/s_dirty.
 			 */
 			/*
 			 * akpm: if the caller was the kupdate function we put
@@ -318,10 +340,9 @@ __sync_single_inode(struct inode *inode,
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
@@ -380,9 +401,9 @@ __writeback_single_inode(struct inode *i
 		/*
 		 * We're skipping this inode because it's locked, and we're not
 		 * doing writeback-for-data-integrity.  Move it to the head of
-		 * s_dirty so that writeback can proceed with the other inodes
+		 * s_more_io so that writeback can proceed with the other inodes
 		 * on s_io.  We'll have another go at writing back this inode
-		 * when the s_dirty iodes get moved back onto s_io.
+		 * when we completed a full scan of s_io.
 		 */
 		requeue_io(inode);
 
@@ -444,16 +465,12 @@ __writeback_single_inode(struct inode *i
 int generic_sync_sb_inodes(struct super_block *sb,
 			struct writeback_control *wbc)
 {
-	const unsigned long start = jiffies;	/* livelock avoidance */
 	int ret = 0;
 
 	spin_lock(&inode_lock);
 
-	if (!wbc->for_kupdate || list_empty(&sb->s_io)) {
-		check_dirty_inode_list(sb);
-		list_splice_init(&sb->s_dirty, &sb->s_io);
-		check_dirty_inode_list(sb);
-	}
+	if (!wbc->for_kupdate || list_empty(&sb->s_io))
+		queue_inodes_for_io(sb, wbc->older_than_this);
 
 	while (!list_empty(&sb->s_io)) {
 		int err;
@@ -496,19 +513,6 @@ int generic_sync_sb_inodes(struct super_
 			continue;		/* blockdev has wrong queue */
 		}
 
-		/* Was this inode dirtied after sync_sb_inodes was called? */
-		if (time_after(inode->dirtied_when, start))
-			break;
-
-		/* Was this inode dirtied too recently? */
-		if (wbc->older_than_this && time_after(inode->dirtied_when,
-						*wbc->older_than_this)) {
-			check_dirty_inode_list(sb);
-			list_splice_init(&sb->s_io, sb->s_dirty.prev);
-			check_dirty_inode_list(sb);
-			break;
-		}
-
 		/* Is another pdflush already flushing this queue? */
 		if (current_is_pdflush() && !writeback_acquire(bdi))
 			break;
@@ -541,12 +545,6 @@ int generic_sync_sb_inodes(struct super_
 		if (wbc->nr_to_write <= 0)
 			break;
 	}
-
-	if (list_empty(&sb->s_io)) {
-		check_dirty_inode_list(sb);
-		list_splice_init(&sb->s_more_io, &sb->s_io);
-		check_dirty_inode_list(sb);
-	}
 	spin_unlock(&inode_lock);
 	return ret;		/* Leave any unwritten inodes on s_io */
 }
@@ -566,7 +564,7 @@ static int sync_sb_inodes(struct super_b
  * Note:
  * We don't need to grab a reference to superblock here. If it has non-empty
  * ->s_dirty it's hadn't been killed yet and kill_super() won't proceed
- * past sync_inodes_sb() until both the ->s_dirty and ->s_io lists are
+ * past sync_inodes_sb() until the ->s_dirty/s_io/s_more_io lists are all
  * empty. Since __sync_single_inode() regains inode_lock before it finally moves
  * inode from superblock lists we are OK.
  *
@@ -589,7 +587,7 @@ int writeback_inodes(struct writeback_co
 restart:
 	sb = sb_entry(super_blocks.prev);
 	for (; sb != sb_entry(&super_blocks); sb = sb_entry(sb->s_list.prev)) {
-		if (!list_empty(&sb->s_dirty) || !list_empty(&sb->s_io)) {
+		if (sb_has_dirty_inodes(sb)) {
 			/* we're making our own get_super here */
 			sb->s_count++;
 			spin_unlock(&sb_lock);

-- 
