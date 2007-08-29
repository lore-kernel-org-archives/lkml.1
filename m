Return-Path: <linux-kernel-owner+w=401wt.eu-S932600AbXH2Ik6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932600AbXH2Ik6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 04:40:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755799AbXH2Ikr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 04:40:47 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:57927 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751247AbXH2Iko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 04:40:44 -0400
Message-ID: <388376840.29283@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Wed, 29 Aug 2007 16:40:39 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Martin Knoblauch <spamtrap@knobisoft.de>
Cc: linux-kernel@vger.kernel.org, Peter zijlstra <a.p.zijlstra@chello.nl>,
       mingo@redhat.com
Subject: Re: Understanding I/O behaviour - next try
Message-ID: <20070829084039.GA32016@mail.ustc.edu.cn>
References: <388351538.28936@ustc.edu.cn> <353439.71100.qm@web32603.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="qMm9M+Fa2AknHoGS"
Content-Disposition: inline
In-Reply-To: <353439.71100.qm@web32603.mail.mud.yahoo.com>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 29, 2007 at 01:15:45AM -0700, Martin Knoblauch wrote:
> 
> --- Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:
> 
> > You are apparently running into the sluggish kupdate-style writeback
> > problem with large files: huge amount of dirty pages are getting
> > accumulated and flushed to the disk all at once when dirty background
> > ratio is reached. The current -mm tree has some fixes for it, and
> > there are some more in my tree. Martin, I'll send you the patch if
> > you'd like to try it out.
> >
> Hi Fengguang,
> 
>  Yeah, that pretty much describes the situation we end up. Although
> "sluggish" is much to friendly if we hit the situation :-)
> 
>  Yes, I am very interested  to check out your patch. I saw your
> postings on LKML already and was already curious. Any chance you have
> something agains 2.6.22-stable? I have reasons not to move to -23 or
> -mm.

Well, they are a dozen patches from various sources.  I managed to
back-port them. It compiles and runs, however I cannot guarantee
more...

> > >  Another thing I saw during my tests is that when writing to NFS,
> > the
> > > "dirty" or "nr_dirty" numbers are always 0. Is this a conceptual
> > thing,
> > > or a bug?
> > 
> > What are the nr_unstable numbers?
> >
> 
>  Ahh. Yes, they go up to 80-90k pages. Comparable to the nr_dirty
> numbers for the disk case. Good to know.
> 
>  For NFS, the nr_writeback numbers seem surprisingly high. They also go
> to 80-90k (pages ?). In the disk case they rarely go over 12k.

Maybe the difference of throttling one single 'cp' and a dozen 'nfsd'?

Fengguang

--qMm9M+Fa2AknHoGS
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="writeback-fixes.patch"

--- linux-2.6.22.orig/fs/fs-writeback.c
+++ linux-2.6.22/fs/fs-writeback.c
@@ -24,6 +24,148 @@
 #include <linux/buffer_head.h>
 #include "internal.h"
 
+/*
+ * Add @inode to its superblock's radix tree of dirty inodes.
+ *
+ * - the radix tree is indexed by inode number
+ * - inode_tree is not authoritative; inode_list is
+ * - inode_tree is a superset of inode_list: it is possible that an inode
+ *   get synced elsewhere and moved to other lists, while still remaining
+ *   in the radix tree.
+ */
+static void add_to_dirty_tree(struct inode *inode)
+{
+	struct super_block *sb = inode->i_sb;
+	struct dirty_inode_tree *dt = &sb->s_dirty_tree;
+	int e;
+
+	e = radix_tree_preload(GFP_ATOMIC);
+	if (!e) {
+		e = radix_tree_insert(&dt->inode_tree, inode->i_ino, inode);
+		/*
+		 * - inode numbers are not necessarily unique
+		 * - an inode might somehow be redirtied and resent to us
+		 */
+		if (!e) {
+			__iget(inode);
+			dt->nr_inodes++;
+			if (dt->max_index < inode->i_ino)
+			    dt->max_index = inode->i_ino;
+			list_move(&inode->i_list, &sb->s_dirty_tree.inode_list);
+		}
+		radix_tree_preload_end();
+	}
+}
+
+#define DIRTY_SCAN_BATCH	16
+#define DIRTY_SCAN_ALL		LONG_MAX
+#define DIRTY_SCAN_REMAINING	(LONG_MAX-1)
+
+/*
+ * Scan the dirty inode tree and pull some inodes onto s_io.
+ * It could go beyond @end - it is a soft/approx limit.
+ */
+static unsigned long scan_dirty_tree(struct super_block *sb,
+					unsigned long begin, unsigned long end)
+{
+	struct dirty_inode_tree *dt = &sb->s_dirty_tree;
+	struct inode *inodes[DIRTY_SCAN_BATCH];
+	struct inode *inode = NULL;
+	int i, j;
+	void *p;
+
+	while (begin < end) {
+		j = radix_tree_gang_lookup(&dt->inode_tree, (void **)inodes,
+						begin, DIRTY_SCAN_BATCH);
+		if (!j)
+			break;
+		for (i = 0; i < j; i++) {
+			inode = inodes[i];
+			if (end != DIRTY_SCAN_ALL) {
+				/* skip young volatile ones */
+				if (time_after(inode->dirtied_when,
+					jiffies - dirty_volatile_interval)) {
+					inodes[i] = 0;
+					continue;
+				}
+			}
+
+			dt->nr_inodes--;
+			p = radix_tree_delete(&dt->inode_tree, inode->i_ino);
+			BUG_ON(!p);
+
+			if (!(inode->i_state & I_SYNC))
+				list_move(&inode->i_list, &sb->s_io);
+		}
+		begin = inode->i_ino + 1;
+
+		spin_unlock(&inode_lock);
+		for (i = 0; i < j; i++)
+			if (inodes[i])
+				iput(inodes[i]);
+		cond_resched();
+		spin_lock(&inode_lock);
+	}
+
+	return begin;
+}
+
+/*
+ * Move a cluster of dirty inodes to the io dispatch queue.
+ */
+static void dispatch_cluster_inodes(struct super_block *sb,
+					unsigned long *older_than_this)
+{
+	struct dirty_inode_tree *dt = &sb->s_dirty_tree;
+	int scan_interval = dirty_expire_interval - dirty_volatile_interval;
+	unsigned long begin;
+	unsigned long end;
+
+	if (!older_than_this) {
+		/*
+		 * Be aggressive: either it is a sync(), or we fall into
+		 * background writeback because kupdate-style writebacks
+		 * could not catch up with fast writers.
+		 */
+		begin = 0;
+		end = DIRTY_SCAN_ALL;
+	} else if (time_after_eq(jiffies,
+				dt->start_jiffies + scan_interval)) {
+		begin = dt->next_index;
+		end = DIRTY_SCAN_REMAINING; /* complete this sweep */
+	} else {
+		unsigned long time_total = max(scan_interval, 1);
+		unsigned long time_delta = jiffies - dt->start_jiffies;
+		unsigned long scan_total = dt->max_index;
+		unsigned long scan_delta = scan_total * time_delta / time_total;
+
+		begin = dt->next_index;
+		end = scan_delta;
+	}
+
+	scan_dirty_tree(sb, begin, end);
+
+	if (end < DIRTY_SCAN_REMAINING) {
+		dt->next_index = begin;
+	} else {
+		/* wrap around and setup a new sweep */
+		dt->next_index = 0;
+		dt->start_jiffies = jiffies;
+	}
+}
+
+
+/*
+ * Enqueue a newly dirtied inode.
+ */
+static void queue_dirty(struct inode *inode)
+{
+	inode->dirtied_when = jiffies;
+	list_move(&inode->i_list, &inode->i_sb->s_dirty);
+	if (dirty_volatile_interval < dirty_expire_interval)
+		add_to_dirty_tree(inode);
+}
+
 /**
  *	__mark_inode_dirty -	internal function
  *	@inode: inode to mark
@@ -99,11 +241,11 @@ void __mark_inode_dirty(struct inode *in
 		inode->i_state |= flags;
 
 		/*
-		 * If the inode is locked, just update its dirty state. 
+		 * If the inode is being synced, just update its dirty state.
 		 * The unlocker will place the inode on the appropriate
 		 * superblock list, based upon its state.
 		 */
-		if (inode->i_state & I_LOCK)
+		if (inode->i_state & I_SYNC)
 			goto out;
 
 		/*
@@ -118,13 +260,11 @@ void __mark_inode_dirty(struct inode *in
 			goto out;
 
 		/*
-		 * If the inode was already on s_dirty or s_io, don't
+		 * If the inode was already on s_dirty/s_io/s_more_io, don't
 		 * reposition it (that would break s_dirty time-ordering).
 		 */
-		if (!was_dirty) {
-			inode->dirtied_when = jiffies;
-			list_move(&inode->i_list, &sb->s_dirty);
-		}
+		if (!was_dirty)
+			queue_dirty(inode);
 	}
 out:
 	spin_unlock(&inode_lock);
@@ -140,6 +280,84 @@ static int write_inode(struct inode *ino
 }
 
 /*
+ * Redirty an inode: set its when-it-was dirtied timestamp and move it to the
+ * furthest end of its superblock's dirty-inode list.
+ *
+ * Before stamping the inode's ->dirtied_when, we check to see whether it is
+ * already the most-recently-dirtied inode on the s_dirty list.  If that is
+ * the case then the inode must have been redirtied while it was being written
+ * out and we don't reset its dirtied_when.
+ */
+static void redirty_tail(struct inode *inode)
+{
+	struct super_block *sb = inode->i_sb;
+
+	if (!list_empty(&sb->s_dirty)) {
+		struct inode *tail_inode;
+
+		tail_inode = list_entry(sb->s_dirty.next, struct inode, i_list);
+		if (!time_after_eq(inode->dirtied_when,
+				tail_inode->dirtied_when))
+			inode->dirtied_when = jiffies;
+	}
+	list_move(&inode->i_list, &sb->s_dirty);
+}
+
+/*
+ * requeue inode for re-scanning after sb->s_io list is exhausted.
+ */
+static void requeue_io(struct inode *inode)
+{
+	list_move(&inode->i_list, &inode->i_sb->s_more_io);
+}
+
+static void inode_sync_complete(struct inode *inode)
+{
+	/*
+	 * Prevent speculative execution through spin_unlock(&inode_lock);
+	 */
+	smp_mb();
+	wake_up_bit(&inode->i_state, __I_SYNC);
+}
+
+/*
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
+	dispatch_cluster_inodes(sb, older_than_this);
+}
+
+int sb_has_dirty_inodes(struct super_block *sb)
+{
+	return !list_empty(&sb->s_dirty) ||
+	       !list_empty(&sb->s_dirty_tree.inode_list) ||
+	       !list_empty(&sb->s_io) ||
+	       !list_empty(&sb->s_more_io);
+}
+EXPORT_SYMBOL(sb_has_dirty_inodes);
+
+/*
  * Write a single inode's dirty pages and inode data out to disk.
  * If `wait' is set, wait on the writeout.
  *
@@ -154,15 +372,14 @@ __sync_single_inode(struct inode *inode,
 {
 	unsigned dirty;
 	struct address_space *mapping = inode->i_mapping;
-	struct super_block *sb = inode->i_sb;
 	int wait = wbc->sync_mode == WB_SYNC_ALL;
 	int ret;
 
-	BUG_ON(inode->i_state & I_LOCK);
+	BUG_ON(inode->i_state & I_SYNC);
 
-	/* Set I_LOCK, reset I_DIRTY */
+	/* Set I_SYNC, reset I_DIRTY */
 	dirty = inode->i_state & I_DIRTY;
-	inode->i_state |= I_LOCK;
+	inode->i_state |= I_SYNC;
 	inode->i_state &= ~I_DIRTY;
 
 	spin_unlock(&inode_lock);
@@ -183,24 +400,32 @@ __sync_single_inode(struct inode *inode,
 	}
 
 	spin_lock(&inode_lock);
-	inode->i_state &= ~I_LOCK;
+	inode->i_state &= ~I_SYNC;
 	if (!(inode->i_state & I_FREEING)) {
 		if (!(inode->i_state & I_DIRTY) &&
 		    mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
 			/*
 			 * We didn't write back all the pages.  nfs_writepages()
 			 * sometimes bales out without doing anything. Redirty
-			 * the inode.  It is still on sb->s_io.
+			 * the inode; Move it from s_io onto s_more_io/s_dirty.
+			 */
+			/*
+			 * akpm: if the caller was the kupdate function we put
+			 * this inode at the head of s_dirty so it gets first
+			 * consideration.  Otherwise, move it to the tail, for
+			 * the reasons described there.  I'm not really sure
+			 * how much sense this makes.  Presumably I had a good
+			 * reasons for doing it this way, and I'd rather not
+			 * muck with it at present.
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
-				list_move_tail(&inode->i_list, &sb->s_dirty);
+				requeue_io(inode);
 			} else {
 				/*
 				 * Otherwise fully redirty the inode so that
@@ -210,15 +435,14 @@ __sync_single_inode(struct inode *inode,
 				 * all the other files.
 				 */
 				inode->i_state |= I_DIRTY_PAGES;
-				inode->dirtied_when = jiffies;
-				list_move(&inode->i_list, &sb->s_dirty);
+				redirty_tail(inode);
 			}
 		} else if (inode->i_state & I_DIRTY) {
 			/*
 			 * Someone redirtied the inode while were writing back
 			 * the pages.
 			 */
-			list_move(&inode->i_list, &sb->s_dirty);
+			redirty_tail(inode);
 		} else if (atomic_read(&inode->i_count)) {
 			/*
 			 * The inode is clean, inuse
@@ -231,7 +455,7 @@ __sync_single_inode(struct inode *inode,
 			list_move(&inode->i_list, &inode_unused);
 		}
 	}
-	wake_up_inode(inode);
+	inode_sync_complete(inode);
 	return ret;
 }
 
@@ -250,11 +474,18 @@ __writeback_single_inode(struct inode *i
 	else
 		WARN_ON(inode->i_state & I_WILL_FREE);
 
-	if ((wbc->sync_mode != WB_SYNC_ALL) && (inode->i_state & I_LOCK)) {
+	if ((wbc->sync_mode != WB_SYNC_ALL) && (inode->i_state & I_SYNC)) {
 		struct address_space *mapping = inode->i_mapping;
 		int ret;
 
-		list_move(&inode->i_list, &inode->i_sb->s_dirty);
+		/*
+		 * We're skipping this inode because it's locked, and we're not
+		 * doing writeback-for-data-integrity.  Move it to s_more_io so
+		 * that writeback can proceed with the other inodes on s_io.
+		 * We'll have another go at writing back this inode when we
+		 * completed a full scan of s_io.
+		 */
+		requeue_io(inode);
 
 		/*
 		 * Even if we don't actually write the inode itself here,
@@ -269,16 +500,16 @@ __writeback_single_inode(struct inode *i
 	/*
 	 * It's a data-integrity sync.  We must wait.
 	 */
-	if (inode->i_state & I_LOCK) {
-		DEFINE_WAIT_BIT(wq, &inode->i_state, __I_LOCK);
+	if (inode->i_state & I_SYNC) {
+		DEFINE_WAIT_BIT(wq, &inode->i_state, __I_SYNC);
 
-		wqh = bit_waitqueue(&inode->i_state, __I_LOCK);
+		wqh = bit_waitqueue(&inode->i_state, __I_SYNC);
 		do {
 			spin_unlock(&inode_lock);
 			__wait_on_bit(wqh, &wq, inode_wait,
 							TASK_UNINTERRUPTIBLE);
 			spin_lock(&inode_lock);
-		} while (inode->i_state & I_LOCK);
+		} while (inode->i_state & I_SYNC);
 	}
 	return __sync_single_inode(inode, wbc);
 }
@@ -296,8 +527,6 @@ __writeback_single_inode(struct inode *i
  * WB_SYNC_HOLD is a hack for sys_sync(): reattach the inode to sb->s_dirty so
  * that it can be located for waiting on in __writeback_single_inode().
  *
- * Called under inode_lock.
- *
  * If `bdi' is non-zero then we're being asked to writeback a specific queue.
  * This function assumes that the blockdev superblock's inodes are backed by
  * a variety of queues, so all inodes are searched.  For other superblocks,
@@ -311,17 +540,22 @@ __writeback_single_inode(struct inode *i
  * The inodes to be written are parked on sb->s_io.  They are moved back onto
  * sb->s_dirty as they are selected for writing.  This way, none can be missed
  * on the writer throttling path, and we get decent balancing between many
- * throttled threads: we don't want them all piling up on __wait_on_inode.
+ * throttled threads: we don't want them all piling up on inode_sync_wait.
  */
-static void
-sync_sb_inodes(struct super_block *sb, struct writeback_control *wbc)
+int generic_sync_sb_inodes(struct super_block *sb,
+			struct writeback_control *wbc)
 {
 	const unsigned long start = jiffies;	/* livelock avoidance */
+	int ret = 0;
+
+	spin_lock(&inode_lock);
 
 	if (!wbc->for_kupdate || list_empty(&sb->s_io))
-		list_splice_init(&sb->s_dirty, &sb->s_io);
+		queue_io(sb, wbc->older_than_this);
 
 	while (!list_empty(&sb->s_io)) {
+		int err;
+
 		struct inode *inode = list_entry(sb->s_io.prev,
 						struct inode, i_list);
 		struct address_space *mapping = inode->i_mapping;
@@ -329,7 +563,7 @@ sync_sb_inodes(struct super_block *sb, s
 		long pages_skipped;
 
 		if (!bdi_cap_writeback_dirty(bdi)) {
-			list_move(&inode->i_list, &sb->s_dirty);
+			redirty_tail(inode);
 			if (sb_is_blkdev_sb(sb)) {
 				/*
 				 * Dirty memory-backed blockdev: the ramdisk
@@ -349,14 +583,14 @@ sync_sb_inodes(struct super_block *sb, s
 			wbc->encountered_congestion = 1;
 			if (!sb_is_blkdev_sb(sb))
 				break;		/* Skip a congested fs */
-			list_move(&inode->i_list, &sb->s_dirty);
+			requeue_io(inode);
 			continue;		/* Skip a congested blockdev */
 		}
 
 		if (wbc->bdi && bdi != wbc->bdi) {
 			if (!sb_is_blkdev_sb(sb))
 				break;		/* fs has the wrong queue */
-			list_move(&inode->i_list, &sb->s_dirty);
+			requeue_io(inode);
 			continue;		/* blockdev has wrong queue */
 		}
 
@@ -364,11 +598,6 @@ sync_sb_inodes(struct super_block *sb, s
 		if (time_after(inode->dirtied_when, start))
 			break;
 
-		/* Was this inode dirtied too recently? */
-		if (wbc->older_than_this && time_after(inode->dirtied_when,
-						*wbc->older_than_this))
-			break;
-
 		/* Is another pdflush already flushing this queue? */
 		if (current_is_pdflush() && !writeback_acquire(bdi))
 			break;
@@ -376,11 +605,11 @@ sync_sb_inodes(struct super_block *sb, s
 		BUG_ON(inode->i_state & I_FREEING);
 		__iget(inode);
 		pages_skipped = wbc->pages_skipped;
-		__writeback_single_inode(inode, wbc);
-		if (wbc->sync_mode == WB_SYNC_HOLD) {
-			inode->dirtied_when = jiffies;
-			list_move(&inode->i_list, &sb->s_dirty);
-		}
+		err = __writeback_single_inode(inode, wbc);
+		if (!ret)
+			ret = err;
+		if (wbc->sync_mode == WB_SYNC_HOLD)
+			queue_dirty(inode);
 		if (current_is_pdflush())
 			writeback_release(bdi);
 		if (wbc->pages_skipped != pages_skipped) {
@@ -388,7 +617,7 @@ sync_sb_inodes(struct super_block *sb, s
 			 * writeback is not making progress due to locked
 			 * buffers.  Skip this inode for now.
 			 */
-			list_move(&inode->i_list, &sb->s_dirty);
+			redirty_tail(inode);
 		}
 		spin_unlock(&inode_lock);
 		iput(inode);
@@ -397,7 +626,19 @@ sync_sb_inodes(struct super_block *sb, s
 		if (wbc->nr_to_write <= 0)
 			break;
 	}
-	return;		/* Leave any unwritten inodes on s_io */
+	if (!list_empty(&sb->s_more_io))
+		wbc->more_io = 1;
+	spin_unlock(&inode_lock);
+	return ret;		/* Leave any unwritten inodes on s_io */
+}
+EXPORT_SYMBOL(generic_sync_sb_inodes);
+
+static int sync_sb_inodes(struct super_block *sb, struct writeback_control *wbc)
+{
+	if (sb->s_op->sync_inodes)
+		return sb->s_op->sync_inodes(sb, wbc);
+	else
+		return generic_sync_sb_inodes(sb, wbc);
 }
 
 /*
@@ -406,7 +647,7 @@ sync_sb_inodes(struct super_block *sb, s
  * Note:
  * We don't need to grab a reference to superblock here. If it has non-empty
  * ->s_dirty it's hadn't been killed yet and kill_super() won't proceed
- * past sync_inodes_sb() until both the ->s_dirty and ->s_io lists are
+ * past sync_inodes_sb() until the ->s_dirty/s_io/s_more_io lists are all
  * empty. Since __sync_single_inode() regains inode_lock before it finally moves
  * inode from superblock lists we are OK.
  *
@@ -419,17 +660,17 @@ sync_sb_inodes(struct super_block *sb, s
  * sync_sb_inodes will seekout the blockdev which matches `bdi'.  Maybe not
  * super-efficient but we're about to do a ton of I/O...
  */
-void
-writeback_inodes(struct writeback_control *wbc)
+int writeback_inodes(struct writeback_control *wbc)
 {
 	struct super_block *sb;
+	int ret = 0;
 
 	might_sleep();
 	spin_lock(&sb_lock);
 restart:
 	sb = sb_entry(super_blocks.prev);
 	for (; sb != sb_entry(&super_blocks); sb = sb_entry(sb->s_list.prev)) {
-		if (!list_empty(&sb->s_dirty) || !list_empty(&sb->s_io)) {
+		if (sb_has_dirty_inodes(sb)) {
 			/* we're making our own get_super here */
 			sb->s_count++;
 			spin_unlock(&sb_lock);
@@ -440,9 +681,9 @@ restart:
 			 */
 			if (down_read_trylock(&sb->s_umount)) {
 				if (sb->s_root) {
-					spin_lock(&inode_lock);
-					sync_sb_inodes(sb, wbc);
-					spin_unlock(&inode_lock);
+					int err = sync_sb_inodes(sb, wbc);
+					if (!ret)
+						ret = err;
 				}
 				up_read(&sb->s_umount);
 			}
@@ -454,6 +695,7 @@ restart:
 			break;
 	}
 	spin_unlock(&sb_lock);
+	return ret;
 }
 
 /*
@@ -467,7 +709,7 @@ restart:
  * We add in the number of potentially dirty inodes, because each inode write
  * can dirty pagecache in the underlying blockdev.
  */
-void sync_inodes_sb(struct super_block *sb, int wait)
+int sync_inodes_sb(struct super_block *sb, int wait)
 {
 	struct writeback_control wbc = {
 		.sync_mode	= wait ? WB_SYNC_ALL : WB_SYNC_HOLD,
@@ -481,9 +723,7 @@ void sync_inodes_sb(struct super_block *
 			(inodes_stat.nr_inodes - inodes_stat.nr_unused) +
 			nr_dirty + nr_unstable;
 	wbc.nr_to_write += wbc.nr_to_write / 2;		/* Bit more for luck */
-	spin_lock(&inode_lock);
-	sync_sb_inodes(sb, &wbc);
-	spin_unlock(&inode_lock);
+	return sync_sb_inodes(sb, &wbc);
 }
 
 /*
@@ -519,13 +759,16 @@ static void set_sb_syncing(int val)
  * outstanding dirty inodes, the writeback goes block-at-a-time within the
  * filesystem's write_inode().  This is extremely slow.
  */
-static void __sync_inodes(int wait)
+static int __sync_inodes(int wait)
 {
 	struct super_block *sb;
+	int ret = 0;
 
 	spin_lock(&sb_lock);
 restart:
 	list_for_each_entry(sb, &super_blocks, s_list) {
+		int err;
+
 		if (sb->s_syncing)
 			continue;
 		sb->s_syncing = 1;
@@ -533,8 +776,12 @@ restart:
 		spin_unlock(&sb_lock);
 		down_read(&sb->s_umount);
 		if (sb->s_root) {
-			sync_inodes_sb(sb, wait);
-			sync_blockdev(sb->s_bdev);
+			err = sync_inodes_sb(sb, wait);
+			if (!ret)
+				ret = err;
+			err = sync_blockdev(sb->s_bdev);
+			if (!ret)
+				ret = err;
 		}
 		up_read(&sb->s_umount);
 		spin_lock(&sb_lock);
@@ -542,17 +789,25 @@ restart:
 			goto restart;
 	}
 	spin_unlock(&sb_lock);
+	return ret;
 }
 
-void sync_inodes(int wait)
+int sync_inodes(int wait)
 {
+	int ret;
+
 	set_sb_syncing(0);
-	__sync_inodes(0);
+	ret = __sync_inodes(0);
 
 	if (wait) {
+		int err;
+
 		set_sb_syncing(0);
-		__sync_inodes(1);
+		err = __sync_inodes(1);
+		if (!ret)
+			ret = err;
 	}
+	return ret;
 }
 
 /**
@@ -583,7 +838,7 @@ int write_inode_now(struct inode *inode,
 	ret = __writeback_single_inode(inode, &wbc);
 	spin_unlock(&inode_lock);
 	if (sync)
-		wait_on_inode(inode);
+		inode_sync_wait(inode);
 	return ret;
 }
 EXPORT_SYMBOL(write_inode_now);
@@ -658,7 +913,7 @@ int generic_osync_inode(struct inode *in
 			err = err2;
 	}
 	else
-		wait_on_inode(inode);
+		inode_sync_wait(inode);
 
 	return err;
 }
--- linux-2.6.22.orig/fs/super.c
+++ linux-2.6.22/fs/super.c
@@ -65,8 +65,11 @@ static struct super_block *alloc_super(s
 			s = NULL;
 			goto out;
 		}
+		INIT_RADIX_TREE(&s->s_dirty_tree.inode_tree, GFP_ATOMIC);
+		INIT_LIST_HEAD(&s->s_dirty_tree.inode_list);
 		INIT_LIST_HEAD(&s->s_dirty);
 		INIT_LIST_HEAD(&s->s_io);
+		INIT_LIST_HEAD(&s->s_more_io);
 		INIT_LIST_HEAD(&s->s_files);
 		INIT_LIST_HEAD(&s->s_instances);
 		INIT_HLIST_HEAD(&s->s_anon);
--- linux-2.6.22.orig/include/linux/fs.h
+++ linux-2.6.22/include/linux/fs.h
@@ -961,6 +961,15 @@ extern int send_sigurg(struct fown_struc
 extern struct list_head super_blocks;
 extern spinlock_t sb_lock;
 
+struct dirty_inode_tree {
+	struct list_head	inode_list;
+	struct radix_tree_root	inode_tree;
+	unsigned long		nr_inodes;
+	unsigned long		max_index;
+	unsigned long		start_jiffies; /* when the scan started? */
+	unsigned long		next_index;    /* where it is in the scan? */
+};
+
 #define sb_entry(list)	list_entry((list), struct super_block, s_list)
 #define S_BIAS (1<<30)
 struct super_block {
@@ -990,8 +999,10 @@ struct super_block {
 	struct xattr_handler	**s_xattr;
 
 	struct list_head	s_inodes;	/* all inodes */
+	struct dirty_inode_tree	s_dirty_tree;
 	struct list_head	s_dirty;	/* dirty inodes */
 	struct list_head	s_io;		/* parked for writeback */
+	struct list_head	s_more_io;	/* parked for more writeback */
 	struct hlist_head	s_anon;		/* anonymous dentries for (nfs) exporting */
 	struct list_head	s_files;
 
@@ -1237,6 +1248,8 @@ struct super_operations {
 	void (*clear_inode) (struct inode *);
 	void (*umount_begin) (struct vfsmount *, int);
 
+	int (*sync_inodes) (struct super_block *sb,
+				struct writeback_control *wbc);
 	int (*show_options)(struct seq_file *, struct vfsmount *);
 	int (*show_stats)(struct seq_file *, struct vfsmount *);
 #ifdef CONFIG_QUOTA
@@ -1245,16 +1258,68 @@ struct super_operations {
 #endif
 };
 
-/* Inode state bits.  Protected by inode_lock. */
-#define I_DIRTY_SYNC		1 /* Not dirty enough for O_DATASYNC */
-#define I_DIRTY_DATASYNC	2 /* Data-related inode changes pending */
-#define I_DIRTY_PAGES		4 /* Data-related inode changes pending */
-#define __I_LOCK		3
+/*
+ * Inode state bits.  Protected by inode_lock.
+ *
+ * Three bits determine the dirty state of the inode, I_DIRTY_SYNC,
+ * I_DIRTY_DATASYNC and I_DIRTY_PAGES.
+ *
+ * Four bits define the lifetime of an inode.  Initially, inodes are I_NEW,
+ * until that flag is cleared.  I_WILL_FREE, I_FREEING and I_CLEAR are set at
+ * various stages of removing an inode.
+ *
+ * Two bits are used for locking and completion notification, I_LOCK and I_SYNC.
+ *
+ * I_DIRTY_SYNC		Inode itself is dirty.
+ * I_DIRTY_DATASYNC	Data-related inode changes pending
+ * I_DIRTY_PAGES	Inode has dirty pages.  Inode itself may be clean.
+ * I_NEW		get_new_inode() sets i_state to I_LOCK|I_NEW.  Both
+ *			are cleared by unlock_new_inode(), called from iget().
+ * I_WILL_FREE		Must be set when calling write_inode_now() if i_count
+ *			is zero.  I_FREEING must be set when I_WILL_FREE is
+ *			cleared.
+ * I_FREEING		Set when inode is about to be freed but still has dirty
+ *			pages or buffers attached or the inode itself is still
+ *			dirty.
+ * I_CLEAR		Set by clear_inode().  In this state the inode is clean
+ *			and can be destroyed.
+ *
+ *			Inodes that are I_WILL_FREE, I_FREEING or I_CLEAR are
+ *			prohibited for many purposes.  iget() must wait for
+ *			the inode to be completely released, then create it
+ *			anew.  Other functions will just ignore such inodes,
+ *			if appropriate.  I_LOCK is used for waiting.
+ *
+ * I_LOCK		Serves as both a mutex and completion notification.
+ *			New inodes set I_LOCK.  If two processes both create
+ *			the same inode, one of them will release its inode and
+ *			wait for I_LOCK to be released before returning.
+ *			Inodes in I_WILL_FREE, I_FREEING or I_CLEAR state can
+ *			also cause waiting on I_LOCK, without I_LOCK actually
+ *			being set.  find_inode() uses this to prevent returning
+ *			nearly-dead inodes.
+ * I_SYNC		Similar to I_LOCK, but limited in scope to writeback
+ *			of inode dirty data.  Having a seperate lock for this
+ *			purpose reduces latency and prevents some filesystem-
+ *			specific deadlocks.
+ *
+ * Q: Why does I_DIRTY_DATASYNC exist?  It appears as if it could be replaced
+ *    by (I_DIRTY_SYNC|I_DIRTY_PAGES).
+ * Q: What is the difference between I_WILL_FREE and I_FREEING?
+ * Q: igrab() only checks on (I_FREEING|I_WILL_FREE).  Should it also check on
+ *    I_CLEAR?  If not, why?
+ */
+#define I_DIRTY_SYNC		1
+#define I_DIRTY_DATASYNC	2
+#define I_DIRTY_PAGES		4
+#define I_NEW			8
+#define I_WILL_FREE		16
+#define I_FREEING		32
+#define I_CLEAR			64
+#define __I_LOCK		7
 #define I_LOCK			(1 << __I_LOCK)
-#define I_FREEING		16
-#define I_CLEAR			32
-#define I_NEW			64
-#define I_WILL_FREE		128
+#define __I_SYNC		8
+#define I_SYNC			(1 << __I_SYNC)
 
 #define I_DIRTY (I_DIRTY_SYNC | I_DIRTY_DATASYNC | I_DIRTY_PAGES)
 
@@ -1688,6 +1753,7 @@ extern int invalidate_inode_pages2(struc
 extern int invalidate_inode_pages2_range(struct address_space *mapping,
 					 pgoff_t start, pgoff_t end);
 extern int write_inode_now(struct inode *, int);
+extern int generic_sync_sb_inodes(struct super_block *, struct writeback_control *);
 extern int filemap_fdatawrite(struct address_space *);
 extern int filemap_flush(struct address_space *);
 extern int filemap_fdatawait(struct address_space *);
@@ -1805,6 +1871,7 @@ extern int bdev_read_only(struct block_d
 extern int set_blocksize(struct block_device *, int);
 extern int sb_set_blocksize(struct super_block *, int);
 extern int sb_min_blocksize(struct super_block *, int);
+extern int sb_has_dirty_inodes(struct super_block *);
 
 extern int generic_file_mmap(struct file *, struct vm_area_struct *);
 extern int generic_file_readonly_mmap(struct file *, struct vm_area_struct *);
--- linux-2.6.22.orig/fs/ntfs/super.c
+++ linux-2.6.22/fs/ntfs/super.c
@@ -2381,14 +2381,14 @@ static void ntfs_put_super(struct super_
 	 */
 	ntfs_commit_inode(vol->mft_ino);
 	write_inode_now(vol->mft_ino, 1);
-	if (!list_empty(&sb->s_dirty)) {
+	if (sb_has_dirty_inodes(sb)) {
 		const char *s1, *s2;
 
 		mutex_lock(&vol->mft_ino->i_mutex);
 		truncate_inode_pages(vol->mft_ino->i_mapping, 0);
 		mutex_unlock(&vol->mft_ino->i_mutex);
 		write_inode_now(vol->mft_ino, 1);
-		if (!list_empty(&sb->s_dirty)) {
+		if (sb_has_dirty_inodes(sb)) {
 			static const char *_s1 = "inodes";
 			static const char *_s2 = "";
 			s1 = _s1;
--- linux-2.6.22.orig/fs/buffer.c
+++ linux-2.6.22/fs/buffer.c
@@ -1700,7 +1700,6 @@ done:
 		 * The page and buffer_heads can be released at any time from
 		 * here on.
 		 */
-		wbc->pages_skipped++;	/* We didn't write this page */
 	}
 	return err;
 
--- linux-2.6.22.orig/include/linux/writeback.h
+++ linux-2.6.22/include/linux/writeback.h
@@ -61,18 +61,17 @@ struct writeback_control {
 	unsigned for_reclaim:1;		/* Invoked from the page allocator */
 	unsigned for_writepages:1;	/* This is a writepages() call */
 	unsigned range_cyclic:1;	/* range_start is cyclic */
-
+	unsigned more_io:1;		/* more io to be dispatched */
 	void *fs_private;		/* For use by ->writepages() */
 };
 
 /*
  * fs/fs-writeback.c
  */	
-void writeback_inodes(struct writeback_control *wbc);
-void wake_up_inode(struct inode *inode);
+int writeback_inodes(struct writeback_control *wbc);
 int inode_wait(void *);
-void sync_inodes_sb(struct super_block *, int wait);
-void sync_inodes(int wait);
+int sync_inodes_sb(struct super_block *, int wait);
+int sync_inodes(int wait);
 
 /* writeback.h requires fs.h; it, too, is not included from here. */
 static inline void wait_on_inode(struct inode *inode)
@@ -81,6 +80,13 @@ static inline void wait_on_inode(struct 
 	wait_on_bit(&inode->i_state, __I_LOCK, inode_wait,
 							TASK_UNINTERRUPTIBLE);
 }
+static inline void inode_sync_wait(struct inode *inode)
+{
+	might_sleep();
+	wait_on_bit(&inode->i_state, __I_SYNC, inode_wait,
+							TASK_UNINTERRUPTIBLE);
+}
+
 
 /*
  * mm/page-writeback.c
@@ -101,6 +107,7 @@ extern int dirty_background_ratio;
 extern int vm_dirty_ratio;
 extern int dirty_writeback_interval;
 extern int dirty_expire_interval;
+extern int dirty_volatile_interval;
 extern int block_dump;
 extern int laptop_mode;
 
--- linux-2.6.22.orig/mm/page-writeback.c
+++ linux-2.6.22/mm/page-writeback.c
@@ -36,7 +36,7 @@
 
 /*
  * The maximum number of pages to writeout in a single bdflush/kupdate
- * operation.  We do this so we don't hold I_LOCK against an inode for
+ * operation.  We do this so we don't hold I_SYNC against an inode for
  * enormous amounts of time, which would block a userspace task which has
  * been forced to throttle against that inode.  Also, the code reevaluates
  * the dirty each time it has written this many pages.
@@ -85,6 +85,11 @@ int dirty_writeback_interval = 5 * HZ;
 int dirty_expire_interval = 30 * HZ;
 
 /*
+ * The shortest number of jiffies for which data should remain dirty
+ */
+int dirty_volatile_interval = 5 * HZ;
+
+/*
  * Flag that makes the machine dump writes/reads and block dirtyings.
  */
 int block_dump;
@@ -382,6 +387,7 @@ static void background_writeout(unsigned
 			global_page_state(NR_UNSTABLE_NFS) < background_thresh
 				&& min_pages <= 0)
 			break;
+		wbc.more_io = 0;
 		wbc.encountered_congestion = 0;
 		wbc.nr_to_write = MAX_WRITEBACK_PAGES;
 		wbc.pages_skipped = 0;
@@ -389,8 +395,9 @@ static void background_writeout(unsigned
 		min_pages -= MAX_WRITEBACK_PAGES - wbc.nr_to_write;
 		if (wbc.nr_to_write > 0 || wbc.pages_skipped > 0) {
 			/* Wrote less than expected */
-			congestion_wait(WRITE, HZ/10);
-			if (!wbc.encountered_congestion)
+			if (wbc.encountered_congestion || wbc.more_io)
+				congestion_wait(WRITE, HZ/10);
+			else
 				break;
 		}
 	}
@@ -455,11 +462,12 @@ static void wb_kupdate(unsigned long arg
 			global_page_state(NR_UNSTABLE_NFS) +
 			(inodes_stat.nr_inodes - inodes_stat.nr_unused);
 	while (nr_to_write > 0) {
+		wbc.more_io = 0;
 		wbc.encountered_congestion = 0;
 		wbc.nr_to_write = MAX_WRITEBACK_PAGES;
 		writeback_inodes(&wbc);
 		if (wbc.nr_to_write > 0) {
-			if (wbc.encountered_congestion)
+			if (wbc.encountered_congestion || wbc.more_io)
 				congestion_wait(WRITE, HZ/10);
 			else
 				break;	/* All the old data is written */
--- linux-2.6.22.orig/fs/hugetlbfs/inode.c
+++ linux-2.6.22/fs/hugetlbfs/inode.c
@@ -233,7 +233,7 @@ static void hugetlbfs_forget_inode(struc
 	struct super_block *sb = inode->i_sb;
 
 	if (!hlist_unhashed(&inode->i_hash)) {
-		if (!(inode->i_state & (I_DIRTY|I_LOCK)))
+		if (!(inode->i_state & (I_DIRTY|I_SYNC)))
 			list_move(&inode->i_list, &inode_unused);
 		inodes_stat.nr_unused++;
 		if (!sb || (sb->s_flags & MS_ACTIVE)) {
--- linux-2.6.22.orig/fs/inode.c
+++ linux-2.6.22/fs/inode.c
@@ -107,6 +107,15 @@ static inline void inode_created_by(stru
 #endif
 }
 
+static void wake_up_inode(struct inode *inode)
+{
+	/*
+	 * Prevent speculative execution through spin_unlock(&inode_lock);
+	 */
+	smp_mb();
+	wake_up_bit(&inode->i_state, __I_LOCK);
+}
+
 static struct inode *alloc_inode(struct super_block *sb)
 {
 	static const struct address_space_operations empty_aops;
@@ -235,7 +244,7 @@ void __iget(struct inode * inode)
 		return;
 	}
 	atomic_inc(&inode->i_count);
-	if (!(inode->i_state & (I_DIRTY|I_LOCK)))
+	if (!(inode->i_state & (I_DIRTY|I_SYNC)))
 		list_move(&inode->i_list, &inode_in_use);
 	inodes_stat.nr_unused--;
 }
@@ -256,7 +265,7 @@ void clear_inode(struct inode *inode)
 	BUG_ON(inode->i_data.nrpages);
 	BUG_ON(!(inode->i_state & I_FREEING));
 	BUG_ON(inode->i_state & I_CLEAR);
-	wait_on_inode(inode);
+	inode_sync_wait(inode);
 	DQUOT_DROP(inode);
 	if (inode->i_sb->s_op->clear_inode)
 		inode->i_sb->s_op->clear_inode(inode);
@@ -1051,7 +1060,7 @@ static void generic_forget_inode(struct 
 	struct super_block *sb = inode->i_sb;
 
 	if (!hlist_unhashed(&inode->i_hash)) {
-		if (!(inode->i_state & (I_DIRTY|I_LOCK)))
+		if (!(inode->i_state & (I_DIRTY|I_SYNC)))
 			list_move(&inode->i_list, &inode_unused);
 		inodes_stat.nr_unused++;
 		if (sb->s_flags & MS_ACTIVE) {
@@ -1294,15 +1303,6 @@ static void __wait_on_freeing_inode(stru
 	spin_lock(&inode_lock);
 }
 
-void wake_up_inode(struct inode *inode)
-{
-	/*
-	 * Prevent speculative execution through spin_unlock(&inode_lock);
-	 */
-	smp_mb();
-	wake_up_bit(&inode->i_state, __I_LOCK);
-}
-
 /*
  * We rarely want to lock two inodes that do not have a parent/child
  * relationship (such as directory, child inode) simultaneously. The
--- linux-2.6.22.orig/fs/jfs/jfs_txnmgr.c
+++ linux-2.6.22/fs/jfs/jfs_txnmgr.c
@@ -1285,7 +1285,14 @@ int txCommit(tid_t tid,		/* transaction 
 		 * commit the transaction synchronously, so the last iput
 		 * will be done by the calling thread (or later)
 		 */
-		if (tblk->u.ip->i_state & I_LOCK)
+		/*
+		 * I believe this code is no longer needed.  Splitting I_LOCK
+		 * into two bits, I_LOCK and I_SYNC should prevent this
+		 * deadlock as well.  But since I don't have a JFS testload
+		 * to verify this, only a trivial s/I_LOCK/I_SYNC/ was done.
+		 * Joern
+		 */
+		if (tblk->u.ip->i_state & I_SYNC)
 			tblk->xflag &= ~COMMIT_LAZY;
 	}
 
--- linux-2.6.22.orig/fs/xfs/linux-2.6/xfs_iops.c
+++ linux-2.6.22/fs/xfs/linux-2.6/xfs_iops.c
@@ -133,7 +133,7 @@ xfs_ichgtime(
 	 */
 	SYNCHRONIZE();
 	ip->i_update_core = 1;
-	if (!(inode->i_state & I_LOCK))
+	if (!(inode->i_state & I_SYNC))
 		mark_inode_dirty_sync(inode);
 }
 
@@ -185,7 +185,7 @@ xfs_ichgtime_fast(
 	 */
 	SYNCHRONIZE();
 	ip->i_update_core = 1;
-	if (!(inode->i_state & I_LOCK))
+	if (!(inode->i_state & I_SYNC))
 		mark_inode_dirty_sync(inode);
 }
 
--- linux-2.6.22.orig/kernel/sysctl.c
+++ linux-2.6.22/kernel/sysctl.c
@@ -702,6 +702,13 @@ static ctl_table vm_table[] = {
 		.proc_handler	= &proc_dointvec_userhz_jiffies,
 	},
 	{
+		.procname	= "dirty_volatile_centisecs",
+		.data		= &dirty_volatile_interval,
+		.maxlen		= sizeof(dirty_volatile_interval),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_userhz_jiffies,
+	},
+	{
 		.ctl_name	= VM_NR_PDFLUSH_THREADS,
 		.procname	= "nr_pdflush_threads",
 		.data		= &nr_pdflush_threads,

--qMm9M+Fa2AknHoGS--

