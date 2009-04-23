Return-Path: <linux-kernel-owner+w=401wt.eu-S1758906AbZDWOtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758906AbZDWOtQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 10:49:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757899AbZDWOrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 10:47:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47333 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754344AbZDWOr2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 10:47:28 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH 4/4] vfs: Make sys_sync() use fsync_super() (version 2)
Date: Thu, 23 Apr 2009 16:47:25 +0200
Message-Id: <1240498045-14288-5-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1240498045-14288-1-git-send-email-jack@suse.cz>
References: <1240498045-14288-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is unnecessarily fragile to have two places (fsync_super() and do_sync())
doing data integrity sync of the filesystem. Alter __fsync_super() to
accommodate needs of both callers and use it. So after this patch
__fsync_super() is the only place where we gather all the calls needed to
properly send all data on a filesystem to disk.

Nice bonus is that we get a complete livelock avoidance and write_supers()
is now only used for periodic writeback of superblocks.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/block_dev.c            |   15 +++++++---
 fs/fs-writeback.c         |   49 ---------------------------------
 fs/super.c                |   66 +++++++++++---------------------------------
 fs/sync.c                 |   31 +++++++--------------
 include/linux/fs.h        |    4 +-
 include/linux/writeback.h |    1 -
 6 files changed, 39 insertions(+), 127 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 48d1290..2609cce 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -175,17 +175,22 @@ blkdev_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
 				iov, offset, nr_segs, blkdev_get_blocks, NULL);
 }
 
+int __sync_blockdev(struct block_device *bdev, int wait)
+{
+	if (!bdev)
+		return 0;
+	if (!wait)
+		return filemap_flush(bdev->bd_inode->i_mapping);
+	return filemap_write_and_wait(bdev->bd_inode->i_mapping);
+}
+
 /*
  * Write out and wait upon all the dirty data associated with a block
  * device via its mapping.  Does not take the superblock lock.
  */
 int sync_blockdev(struct block_device *bdev)
 {
-	int ret = 0;
-
-	if (bdev)
-		ret = filemap_write_and_wait(bdev->bd_inode->i_mapping);
-	return ret;
+	return __sync_blockdev(bdev, 1);
 }
 EXPORT_SYMBOL(sync_blockdev);
 
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 91013ff..e0fb2e7 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -679,55 +679,6 @@ void sync_inodes_sb(struct super_block *sb, int wait)
 }
 
 /**
- * sync_inodes - writes all inodes to disk
- * @wait: wait for completion
- *
- * sync_inodes() goes through each super block's dirty inode list, writes the
- * inodes out, waits on the writeout and puts the inodes back on the normal
- * list.
- *
- * This is for sys_sync().  fsync_dev() uses the same algorithm.  The subtle
- * part of the sync functions is that the blockdev "superblock" is processed
- * last.  This is because the write_inode() function of a typical fs will
- * perform no I/O, but will mark buffers in the blockdev mapping as dirty.
- * What we want to do is to perform all that dirtying first, and then write
- * back all those inode blocks via the blockdev mapping in one sweep.  So the
- * additional (somewhat redundant) sync_blockdev() calls here are to make
- * sure that really happens.  Because if we call sync_inodes_sb(wait=1) with
- * outstanding dirty inodes, the writeback goes block-at-a-time within the
- * filesystem's write_inode().  This is extremely slow.
- */
-static void __sync_inodes(int wait)
-{
-	struct super_block *sb;
-
-	spin_lock(&sb_lock);
-restart:
-	list_for_each_entry(sb, &super_blocks, s_list) {
-		sb->s_count++;
-		spin_unlock(&sb_lock);
-		down_read(&sb->s_umount);
-		if (sb->s_root) {
-			sync_inodes_sb(sb, wait);
-			sync_blockdev(sb->s_bdev);
-		}
-		up_read(&sb->s_umount);
-		spin_lock(&sb_lock);
-		if (__put_super_and_need_restart(sb))
-			goto restart;
-	}
-	spin_unlock(&sb_lock);
-}
-
-void sync_inodes(int wait)
-{
-	__sync_inodes(0);
-
-	if (wait)
-		__sync_inodes(1);
-}
-
-/**
  * write_inode_now	-	write an inode to disk
  * @inode: inode to write to disk
  * @sync: whether the write should be synchronous or not
diff --git a/fs/super.c b/fs/super.c
index 4c92068..80d46c7 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -257,24 +257,17 @@ void unlock_super(struct super_block * sb)
 EXPORT_SYMBOL(lock_super);
 EXPORT_SYMBOL(unlock_super);
 
-/*
- * Write out and wait upon all dirty data associated with this
- * superblock.  Filesystem data as well as the underlying block
- * device.  Takes the superblock lock.  Requires a second blkdev
- * flush by the caller to complete the operation.
- */
-static int __fsync_super(struct super_block *sb)
+static int __fsync_super(struct super_block *sb, int wait)
 {
-	sync_inodes_sb(sb, 0);
 	vfs_dq_sync(sb);
-	sync_inodes_sb(sb, 1);
+	sync_inodes_sb(sb, wait);
 	lock_super(sb);
 	if (sb->s_dirt && sb->s_op->write_super)
 		sb->s_op->write_super(sb);
 	unlock_super(sb);
 	if (sb->s_op->sync_fs)
-		sb->s_op->sync_fs(sb, 1);
-	sync_blockdev(sb->s_bdev);
+		sb->s_op->sync_fs(sb, wait);
+	return __sync_blockdev(sb->s_bdev, wait);
 }
 
 /*
@@ -284,7 +277,12 @@ static int __fsync_super(struct super_block *sb)
  */
 int fsync_super(struct super_block *sb)
 {
-	return __fsync_super(sb);
+	int ret;
+
+	ret = __fsync_super(sb, 0);
+	if (ret < 0)
+		return ret;
+	return __fsync_super(sb, 1);
 }
 EXPORT_SYMBOL_GPL(fsync_super);
 
@@ -448,20 +446,17 @@ restart:
 }
 
 /*
- * Call the ->sync_fs super_op against all filesystems which are r/w and
- * which implement it.
+ * Sync all the data for all the filesystems (called by do_sync())
  *
  * This operation is careful to avoid the livelock which could easily happen
- * if two or more filesystems are being continuously dirtied.  s_need_sync_fs
+ * if two or more filesystems are being continuously dirtied.  s_need_sync
  * is used only here.  We set it against all filesystems and then clear it as
  * we sync them.  So redirtied filesystems are skipped.
  *
  * But if process A is currently running sync_filesystems and then process B
- * calls sync_filesystems as well, process B will set all the s_need_sync_fs
+ * calls sync_filesystems as well, process B will set all the s_need_sync
  * flags again, which will cause process A to resync everything.  Fix that with
  * a local mutex.
- *
- * (Fabian) Avoid sync_fs with clean fs & wait mode 0
  */
 void sync_filesystems(int wait)
 {
@@ -471,18 +466,16 @@ void sync_filesystems(int wait)
 	mutex_lock(&mutex);		/* Could be down_interruptible */
 	spin_lock(&sb_lock);
 	list_for_each_entry(sb, &super_blocks, s_list) {
-		if (!sb->s_op->sync_fs)
-			continue;
 		if (sb->s_flags & MS_RDONLY)
 			continue;
-		sb->s_need_sync_fs = 1;
+		sb->s_need_sync = 1;
 	}
 
 restart:
 	list_for_each_entry(sb, &super_blocks, s_list) {
-		if (!sb->s_need_sync_fs)
+		if (!sb->s_need_sync)
 			continue;
-		sb->s_need_sync_fs = 0;
+		sb->s_need_sync = 0;
 		if (sb->s_flags & MS_RDONLY)
 			continue;	/* hm.  Was remounted r/o meanwhile */
 		sb->s_count++;
@@ -490,7 +483,7 @@ restart:
 		down_read(&sb->s_umount);
 		async_synchronize_full_domain(&sb->s_async_list);
 		if (sb->s_root)
-			sb->s_op->sync_fs(sb, wait);
+			__fsync_super(sb, wait);
 		up_read(&sb->s_umount);
 		/* restart only when sb is no longer on the list */
 		spin_lock(&sb_lock);
@@ -501,31 +494,6 @@ restart:
 	mutex_unlock(&mutex);
 }
 
-/*
- *  Sync all block devices underlying some superblock
- */
-void sync_blockdevs(void)
-{
-	struct super_block *sb;
-
-	spin_lock(&sb_lock);
-restart:
-	list_for_each_entry(sb, &super_blocks, s_list) {
-		if (!sb->s_bdev)
-			continue;
-		sb->s_count++;
-		spin_unlock(&sb_lock);
-		down_read(&sb->s_umount);
-		if (sb->s_root)
-			sync_blockdev(sb->s_bdev);
-		up_read(&sb->s_umount);
-		spin_lock(&sb_lock);
-		if (__put_super_and_need_restart(sb))
-			goto restart;
-	}
-	spin_unlock(&sb_lock);
-}
-
 /**
  *	get_super - get the superblock of a device
  *	@bdev: device to get the superblock for
diff --git a/fs/sync.c b/fs/sync.c
index fa14e42..86c6a86 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -17,35 +17,24 @@
 #define VALID_FLAGS (SYNC_FILE_RANGE_WAIT_BEFORE|SYNC_FILE_RANGE_WRITE| \
 			SYNC_FILE_RANGE_WAIT_AFTER)
 
-/*
- * sync everything.  Start out by waking pdflush, because that writes back
- * all queues in parallel.
- */
-static void do_sync(unsigned long wait)
+SYSCALL_DEFINE0(sync)
 {
-	wakeup_pdflush(0);
-	sync_inodes(0);		/* All mappings, inodes and their blockdevs */
-	vfs_dq_sync(NULL);
-	sync_inodes(wait);	/* Mappings, inodes and blockdevs, again. */
-	sync_supers();		/* Write the superblocks */
-	sync_filesystems(0);	/* Start syncing the filesystems */
-	sync_filesystems(wait);	/* Waitingly sync the filesystems */
-	sync_blockdevs();
-	if (!wait)
-		printk("Emergency Sync complete\n");
+	sync_filesystems(0);
+	sync_filesystems(1);
 	if (unlikely(laptop_mode))
 		laptop_sync_completion();
-}
-
-SYSCALL_DEFINE0(sync)
-{
-	do_sync(1);
 	return 0;
 }
 
 static void do_sync_work(struct work_struct *work)
 {
-	do_sync(0);
+	/*
+	 * Sync twice to reduce the possibility we skipped some inodes / pages
+	 * because they were temporarily locked
+	 */
+	sync_filesystems(0);
+	sync_filesystems(0);
+	printk("Emergency Sync complete\n");
 	kfree(work);
 }
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 47a67c9..be2be8d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1321,7 +1321,7 @@ struct super_block {
 	struct rw_semaphore	s_umount;
 	struct mutex		s_lock;
 	int			s_count;
-	int			s_need_sync_fs;
+	int			s_need_sync;
 	atomic_t		s_active;
 #ifdef CONFIG_SECURITY
 	void                    *s_security;
@@ -1942,7 +1942,7 @@ extern void bdput(struct block_device *);
 extern struct block_device *open_by_devnum(dev_t, fmode_t);
 extern void invalidate_bdev(struct block_device *);
 extern int sync_blockdev(struct block_device *bdev);
-extern void sync_blockdevs(void);
+extern int __sync_blockdev(struct block_device *bdev, int wait);
 extern struct super_block *freeze_bdev(struct block_device *);
 extern void emergency_thaw_all(void);
 extern int thaw_bdev(struct block_device *bdev, struct super_block *sb);
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index 9c1ed1f..943d1c9 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -79,7 +79,6 @@ struct writeback_control {
 void writeback_inodes(struct writeback_control *wbc);
 int inode_wait(void *);
 void sync_inodes_sb(struct super_block *, int wait);
-void sync_inodes(int wait);
 
 /* writeback.h requires fs.h; it, too, is not included from here. */
 static inline void wait_on_inode(struct inode *inode)
-- 
1.6.0.2

