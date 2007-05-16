Return-Path: <linux-kernel-owner+w=401wt.eu-S1759967AbXEPRFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759967AbXEPRFq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 13:05:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755222AbXEPRFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 13:05:38 -0400
Received: from lazybastard.de ([212.112.238.170]:37110 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742AbXEPRFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 13:05:36 -0400
Date: Wed, 16 May 2007 19:01:14 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, David Chinner <dgc@sgi.com>,
       Anton Altaparmakov <aia21@cam.ac.uk>, Al Viro <viro@ftp.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>
Subject: [PATCH resend] introduce I_SYNC
Message-ID: <20070516170110.GC8113@lazybastard.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

While others are busy coming up with new silly names, here is something
substantial to worry about.

Patches fixes a deadlock problem well enough for LogFS to survive.  The
problem itself is generic and seems to be ancient.  Shaggy has code in
JFS from about 2.4.20 that seems to work around the deadlock.  Dave
Chinner indicated that this could cause latency problems (not a
deadlock) on the NFS server side.  I still suspect that NTFS has hit the
same deadlock and its current "fix" will cause data corruption instead.

After all that, I consider it important that some version of this patch
gets merged.  But before doing so, the patch needs better review and
testing.  The code it changes is quite subtle and and easy to get wrong.


1. Introduction

In its write path, LogFS may have to do some Garbage Collection when
space is getting tight.  GC requires reading inodes, so the I_LOCK bit
is taken for some random inodes.

I_LOCK is also held when syncing inodes to flash, so LogFS has to wait
for those inodes.  Inodes are written by the same code path as regular
file data and needs to acquire an fs-global mutex.  Call stacks of the
1-2 processes will look roughly like this:

Process A:				Process B:
inode_wait				[filesystem locking write path]
__wait_on_bit				__writeback_single_inode
out_of_line_wait_on_bit
ifind_fast
[filesystem calling iget()]
[filesystem locking write path]


2. The usage of inode_lock and I_LOCK

Almost all modifications of inodes are protected by the inode_lock, a
global spinlock.  Some modifications, however, can block for various
reasons and require the inode_lock to get dropped temporarily.  In the
meantime, the individual inode needs to get protected somehow.  Usually
this happens through the use of I_LOCK.

But I_LOCK is not a simple mutex.  It is a Janus-faced bit in the inode
that is used for several things, including mutual exclusion and
completion notification.  Most users are open-coded, so it is not easy
to follow, but can be summarized in the table below.

In this table columns indicate events when I_LOCK is either set or
reset (or not reset but all waiters are notified anyway).  Rows
indicate code that either checks for I_LOCK and changes behaviour
depending on its state or is waiting until I_LOCK gets reset (or is
waiting even if I_LOCK is not set).

			__sync_single_inode
			|	get_new_inode[_fast]
			|	| unlock_new_inode
			|	| |	dispose_list
			|	| |	|	generic_delete_inode
			|	| |	|	|	generic_forget_inode
lock			v	v |	|	|	|
unlock/complete		v	v	v	v	v	comment
-------------------------------------------------------------------------------
__writeback_single_inodeX	O	O	O	O	sync
write_inode_now		X	O	O	O	O	sync
clear_inode		X	O	O	O	O	sync
__mark_inode_dirty	X	O	O	O	O	lists
generic_osync_inode	X	O	O	O	O	sync
get_new_inode[_fast]	O	X	O	O	O	mutex
find_inode[_fast]	O	O	X	X	X	I_FREEING
ifind[_fast]		O	X	O	O	O	read

jfs txCommit		?	?	?	?	?	?
xfs_ichgtime[_fast]	X	O	O	O	O	sync

Comments:
sync - wait for writeout to finish
lists - move inode to dirty list without racing against __sync_single_inode
mutex - protect against two concurrent get_new_inode[_fast] creating two inodes
I_FREEING - wait for inode to get freed, then repeat
read - don't return inode until it is read from medium

Now, the "X"s mark combinations where columns and rows are related.
"O"s mark combinations where afaics columns and rows share no
relationship whatsoever except that both use either I_LOCK or
wake_up_inode()/wait_on_inode() or any other of the partially open-coded
variants.

The table shows that two large usage groups exist for I_LOCK, one
dealing exclusively with the various sync() functions in
fs/fs-writeback.c and another basically confined to fs/inode.c code.
JFS has one remaining user that is unclear to me.


This patch introduces a new flag, I_SYNC and seperates out all sync()
users of I_LOCK to use the new flag instead.


 fs/fs-writeback.c           |   39 ++++++++++++++++++++++++---------------
 fs/xfs/linux-2.6/xfs_iops.c |    4 ++--
 include/linux/fs.h          |    2 ++
 include/linux/writeback.h   |    7 +++++++
 4 files changed, 35 insertions(+), 17 deletions(-)

--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
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
unchanged:
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1184,6 +1184,8 @@ #define I_FREEING		16
 #define I_CLEAR			32
 #define I_NEW			64
 #define I_WILL_FREE		128
+#define __I_SYNC		8
+#define I_SYNC			(1 << __I_SYNC) /* Currently being synced */
 
 #define I_DIRTY (I_DIRTY_SYNC | I_DIRTY_DATASYNC | I_DIRTY_PAGES)
 
unchanged:
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
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
only in patch2:
unchanged:
--- a/fs/xfs/linux-2.6/xfs_iops.c
+++ b/fs/xfs/linux-2.6/xfs_iops.c
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
 
