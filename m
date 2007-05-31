Return-Path: <linux-kernel-owner+w=401wt.eu-S1757086AbXEaOa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757086AbXEaOa1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 10:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752359AbXEaOaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 10:30:17 -0400
Received: from lazybastard.de ([212.112.238.170]:44794 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675AbXEaOaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 10:30:15 -0400
Date: Thu, 31 May 2007 16:25:35 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, David Chinner <dgc@sgi.com>,
       Anton Altaparmakov <aia21@cam.ac.uk>, Al Viro <viro@ftp.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH resend] introduce I_SYNC
Message-ID: <20070531142535.GA25236@lazybastard.org>
References: <20070516170110.GC8113@lazybastard.org> <20070516101535.94e44b3b.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070516101535.94e44b3b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2007 10:15:35 -0700, Andrew Morton wrote:
>
> If we're going to do this then please let's get some exhaustive commentary
> in there so that others have a chance of understanding these flags without
> having to do the amount of reverse-engineering which you've been put through.

Done.  Found and fixed some bugs in the process.  By now I feal
reasonable certain that the patch fixes more than it breaks.

Jörn

-- 
Good warriors cause others to come to them and do not go to others.
-- Sun Tzu

Introduce I_SYNC.

I_LOCK was used for several unrelated purposes, which caused deadlock
situations in certain filesystems as a side effect.  One of the purposes
now uses the new I_SYNC bit.

Also document the various bits and change their order from historical to
logical.

Signed-off-by: Jörn Engel <joern@wohnheim.fh-wedel.de>
---

 fs/fs-writeback.c           |   39 +++++++++++++++---------
 fs/hugetlbfs/inode.c        |    2 -
 fs/inode.c                  |    6 +--
 fs/jfs/jfs_txnmgr.c         |    9 +++++
 fs/xfs/linux-2.6/xfs_iops.c |    4 +-
 include/linux/fs.h          |   70 ++++++++++++++++++++++++++++++++++++++------
 include/linux/writeback.h   |    7 ++++
 mm/page-writeback.c         |    2 -
 8 files changed, 107 insertions(+), 32 deletions(-)

--- linux-2.6.21logfs/fs/fs-writeback.c~I_LOCK	2007-05-07 10:28:53.000000000 +0200
+++ linux-2.6.21logfs/fs/fs-writeback.c	2007-05-07 13:29:35.000000000 +0200
@@ -99,11 +99,11 @@ void __mark_inode_dirty(struct inode *in
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
@@ -139,6 +139,15 @@ static int write_inode(struct inode *ino
 	return 0;
 }
 
+static void inode_sync_complete(struct inode *inode)
+{
+	/*
+	 * Prevent speculative execution through spin_unlock(&inode_lock);
+	 */
+	smp_mb();
+	wake_up_bit(&inode->i_state, __I_SYNC);
+}
+
 /*
  * Write a single inode's dirty pages and inode data out to disk.
  * If `wait' is set, wait on the writeout.
@@ -158,11 +167,11 @@ __sync_single_inode(struct inode *inode,
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
@@ -183,7 +192,7 @@ __sync_single_inode(struct inode *inode,
 	}
 
 	spin_lock(&inode_lock);
-	inode->i_state &= ~I_LOCK;
+	inode->i_state &= ~I_SYNC;
 	if (!(inode->i_state & I_FREEING)) {
 		if (!(inode->i_state & I_DIRTY) &&
 		    mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
@@ -231,7 +240,7 @@ __sync_single_inode(struct inode *inode,
 			list_move(&inode->i_list, &inode_unused);
 		}
 	}
-	wake_up_inode(inode);
+	inode_sync_complete(inode);
 	return ret;
 }
 
@@ -250,7 +259,7 @@ __writeback_single_inode(struct inode *i
 	else
 		WARN_ON(inode->i_state & I_WILL_FREE);
 
-	if ((wbc->sync_mode != WB_SYNC_ALL) && (inode->i_state & I_LOCK)) {
+	if ((wbc->sync_mode != WB_SYNC_ALL) && (inode->i_state & I_SYNC)) {
 		struct address_space *mapping = inode->i_mapping;
 		int ret;
 
@@ -269,16 +278,16 @@ __writeback_single_inode(struct inode *i
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
@@ -311,7 +320,7 @@ __writeback_single_inode(struct inode *i
  * The inodes to be written are parked on sb->s_io.  They are moved back onto
  * sb->s_dirty as they are selected for writing.  This way, none can be missed
  * on the writer throttling path, and we get decent balancing between many
- * throttled threads: we don't want them all piling up on __wait_on_inode.
+ * throttled threads: we don't want them all piling up on inode_sync_wait.
  */
 static void
 sync_sb_inodes(struct super_block *sb, struct writeback_control *wbc)
@@ -583,7 +592,7 @@ int write_inode_now(struct inode *inode,
 	ret = __writeback_single_inode(inode, &wbc);
 	spin_unlock(&inode_lock);
 	if (sync)
-		wait_on_inode(inode);
+		inode_sync_wait(inode);
 	return ret;
 }
 EXPORT_SYMBOL(write_inode_now);
@@ -658,7 +667,7 @@ int generic_osync_inode(struct inode *in
 			err = err2;
 	}
 	else
-		wait_on_inode(inode);
+		inode_sync_wait(inode);
 
 	return err;
 }
--- linux-2.6.21logfs/include/linux/fs.h~I_LOCK	2007-05-07 13:24:00.000000000 +0200
+++ linux-2.6.21logfs/include/linux/fs.h	2007-05-29 08:42:18.000000000 +0200
@@ -1174,16 +1174,68 @@ struct super_operations {
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
 
--- linux-2.6.21logfs/include/linux/writeback.h~I_LOCK	2007-05-07 13:24:01.000000000 +0200
+++ linux-2.6.21logfs/include/linux/writeback.h	2007-05-07 13:29:35.000000000 +0200
@@ -77,6 +77,13 @@ static inline void wait_on_inode(struct 
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
--- linux-2.6.21logfs/fs/inode.c~I_LOCK	2007-05-07 10:28:55.000000000 +0200
+++ linux-2.6.21logfs/fs/inode.c	2007-05-29 13:26:57.000000000 +0200
@@ -228,7 +228,7 @@ void __iget(struct inode * inode)
 		return;
 	}
 	atomic_inc(&inode->i_count);
-	if (!(inode->i_state & (I_DIRTY|I_LOCK)))
+	if (!(inode->i_state & (I_DIRTY|I_SYNC)))
 		list_move(&inode->i_list, &inode_in_use);
 	inodes_stat.nr_unused--;
 }
@@ -249,7 +249,7 @@ void clear_inode(struct inode *inode)
 	BUG_ON(inode->i_data.nrpages);
 	BUG_ON(!(inode->i_state & I_FREEING));
 	BUG_ON(inode->i_state & I_CLEAR);
-	wait_on_inode(inode);
+	inode_sync_wait(inode);
 	DQUOT_DROP(inode);
 	if (inode->i_sb && inode->i_sb->s_op->clear_inode)
 		inode->i_sb->s_op->clear_inode(inode);
@@ -1038,7 +1038,7 @@ static void generic_forget_inode(struct 
 	struct super_block *sb = inode->i_sb;
 
 	if (!hlist_unhashed(&inode->i_hash)) {
-		if (!(inode->i_state & (I_DIRTY|I_LOCK)))
+		if (!(inode->i_state & (I_DIRTY|I_SYNC)))
 			list_move(&inode->i_list, &inode_unused);
 		inodes_stat.nr_unused++;
 		if (!sb || (sb->s_flags & MS_ACTIVE)) {
--- linux-2.6.21logfs/fs/jfs/jfs_txnmgr.c~I_LOCK	2007-05-07 10:28:55.000000000 +0200
+++ linux-2.6.21logfs/fs/jfs/jfs_txnmgr.c	2007-05-29 13:10:32.000000000 +0200
@@ -1286,7 +1286,14 @@ int txCommit(tid_t tid,		/* transaction 
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
 
--- linux-2.6.21logfs/fs/xfs/linux-2.6/xfs_iops.c~I_LOCK	2007-05-07 10:29:00.000000000 +0200
+++ linux-2.6.21logfs/fs/xfs/linux-2.6/xfs_iops.c	2007-05-29 13:15:14.000000000 +0200
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
 
--- linux-2.6.21logfs/fs/hugetlbfs/inode.c~I_LOCK	2007-05-07 10:28:55.000000000 +0200
+++ linux-2.6.21logfs/fs/hugetlbfs/inode.c	2007-05-29 13:25:05.000000000 +0200
@@ -229,7 +229,7 @@ static void hugetlbfs_forget_inode(struc
 	struct super_block *sb = inode->i_sb;
 
 	if (!hlist_unhashed(&inode->i_hash)) {
-		if (!(inode->i_state & (I_DIRTY|I_LOCK)))
+		if (!(inode->i_state & (I_DIRTY|I_SYNC)))
 			list_move(&inode->i_list, &inode_unused);
 		inodes_stat.nr_unused++;
 		if (!sb || (sb->s_flags & MS_ACTIVE)) {
--- linux-2.6.21logfs/mm/page-writeback.c~I_LOCK	2007-05-07 13:24:03.000000000 +0200
+++ linux-2.6.21logfs/mm/page-writeback.c	2007-05-29 13:28:10.000000000 +0200
@@ -36,7 +36,7 @@
 
 /*
  * The maximum number of pages to writeout in a single bdflush/kupdate
- * operation.  We do this so we don't hold I_LOCK against an inode for
+ * operation.  We do this so we don't hold I_SYNC against an inode for
  * enormous amounts of time, which would block a userspace task which has
  * been forced to throttle against that inode.  Also, the code reevaluates
  * the dirty each time it has written this many pages.
