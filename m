Return-Path: <linux-kernel-owner+w=401wt.eu-S1758722AbZD0Otc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758722AbZD0Otc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 10:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757843AbZD0OoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 10:44:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37607 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757851AbZD0On5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 10:43:57 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH 5/8] vfs: Move syncing code from super.c to sync.c (version 4)
Date: Mon, 27 Apr 2009 16:43:52 +0200
Message-Id: <1240843435-1786-6-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1240843435-1786-1-git-send-email-jack@suse.cz>
References: <1240843435-1786-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move sync_filesystems(), __fsync_super(), fsync_super() from
super.c to sync.c where it fits better.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/super.c         |   86 ----------------------------------------------------
 fs/sync.c          |   86 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h |    1 -
 3 files changed, 86 insertions(+), 87 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index b5d7dfb..c0302a5 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -257,42 +257,6 @@ void unlock_super(struct super_block * sb)
 EXPORT_SYMBOL(lock_super);
 EXPORT_SYMBOL(unlock_super);
 
-/*
- * Do the filesystem syncing work. For simple filesystems sync_inodes_sb(sb, 0)
- * just dirties buffers with inodes so we have to submit IO for these buffers
- * via __sync_blockdev(). This also speeds up the wait == 1 case since in that
- * case write_inode() functions do sync_dirty_buffer() and thus effectively
- * write one block at a time.
- */
-static int __fsync_super(struct super_block *sb, int wait)
-{
-	vfs_dq_sync(sb);
-	sync_inodes_sb(sb, wait);
-	lock_super(sb);
-	if (sb->s_dirt && sb->s_op->write_super)
-		sb->s_op->write_super(sb);
-	unlock_super(sb);
-	if (sb->s_op->sync_fs)
-		sb->s_op->sync_fs(sb, wait);
-	return __sync_blockdev(sb->s_bdev, wait);
-}
-
-/*
- * Write out and wait upon all dirty data associated with this
- * superblock.  Filesystem data as well as the underlying block
- * device.  Takes the superblock lock.
- */
-int fsync_super(struct super_block *sb)
-{
-	int ret;
-
-	ret = __fsync_super(sb, 0);
-	if (ret < 0)
-		return ret;
-	return __fsync_super(sb, 1);
-}
-EXPORT_SYMBOL_GPL(fsync_super);
-
 /**
  *	generic_shutdown_super	-	common helper for ->kill_sb()
  *	@sb: superblock to kill
@@ -452,56 +416,6 @@ restart:
 	spin_unlock(&sb_lock);
 }
 
-/*
- * Sync all the data for all the filesystems (called by sys_sync() and
- * emergency sync)
- *
- * This operation is careful to avoid the livelock which could easily happen
- * if two or more filesystems are being continuously dirtied.  s_need_sync
- * is used only here.  We set it against all filesystems and then clear it as
- * we sync them.  So redirtied filesystems are skipped.
- *
- * But if process A is currently running sync_filesystems and then process B
- * calls sync_filesystems as well, process B will set all the s_need_sync
- * flags again, which will cause process A to resync everything.  Fix that with
- * a local mutex.
- */
-void sync_filesystems(int wait)
-{
-	struct super_block *sb;
-	static DEFINE_MUTEX(mutex);
-
-	mutex_lock(&mutex);		/* Could be down_interruptible */
-	spin_lock(&sb_lock);
-	list_for_each_entry(sb, &super_blocks, s_list) {
-		if (sb->s_flags & MS_RDONLY)
-			continue;
-		sb->s_need_sync = 1;
-	}
-
-restart:
-	list_for_each_entry(sb, &super_blocks, s_list) {
-		if (!sb->s_need_sync)
-			continue;
-		sb->s_need_sync = 0;
-		if (sb->s_flags & MS_RDONLY)
-			continue;	/* hm.  Was remounted r/o meanwhile */
-		sb->s_count++;
-		spin_unlock(&sb_lock);
-		down_read(&sb->s_umount);
-		async_synchronize_full_domain(&sb->s_async_list);
-		if (sb->s_root)
-			__fsync_super(sb, wait);
-		up_read(&sb->s_umount);
-		/* restart only when sb is no longer on the list */
-		spin_lock(&sb_lock);
-		if (__put_super_and_need_restart(sb))
-			goto restart;
-	}
-	spin_unlock(&sb_lock);
-	mutex_unlock(&mutex);
-}
-
 /**
  *	get_super - get the superblock of a device
  *	@bdev: device to get the superblock for
diff --git a/fs/sync.c b/fs/sync.c
index 86c6a86..a0a163a 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -17,6 +17,92 @@
 #define VALID_FLAGS (SYNC_FILE_RANGE_WAIT_BEFORE|SYNC_FILE_RANGE_WRITE| \
 			SYNC_FILE_RANGE_WAIT_AFTER)
 
+/*
+ * Do the filesystem syncing work. For simple filesystems sync_inodes_sb(sb, 0)
+ * just dirties buffers with inodes so we have to submit IO for these buffers
+ * via __sync_blockdev(). This also speeds up the wait == 1 case since in that
+ * case write_inode() functions do sync_dirty_buffer() and thus effectively
+ * write one block at a time.
+ */
+static int __fsync_super(struct super_block *sb, int wait)
+{
+	vfs_dq_sync(sb);
+	sync_inodes_sb(sb, wait);
+	lock_super(sb);
+	if (sb->s_dirt && sb->s_op->write_super)
+		sb->s_op->write_super(sb);
+	unlock_super(sb);
+	if (sb->s_op->sync_fs)
+		sb->s_op->sync_fs(sb, wait);
+	return __sync_blockdev(sb->s_bdev, wait);
+}
+
+/*
+ * Write out and wait upon all dirty data associated with this
+ * superblock.  Filesystem data as well as the underlying block
+ * device.  Takes the superblock lock.
+ */
+int fsync_super(struct super_block *sb)
+{
+	int ret;
+
+	ret = __fsync_super(sb, 0);
+	if (ret < 0)
+		return ret;
+	return __fsync_super(sb, 1);
+}
+EXPORT_SYMBOL_GPL(fsync_super);
+
+/*
+ * Sync all the data for all the filesystems (called by sys_sync() and
+ * emergency sync)
+ *
+ * This operation is careful to avoid the livelock which could easily happen
+ * if two or more filesystems are being continuously dirtied.  s_need_sync
+ * is used only here.  We set it against all filesystems and then clear it as
+ * we sync them.  So redirtied filesystems are skipped.
+ *
+ * But if process A is currently running sync_filesystems and then process B
+ * calls sync_filesystems as well, process B will set all the s_need_sync
+ * flags again, which will cause process A to resync everything.  Fix that with
+ * a local mutex.
+ */
+static void sync_filesystems(int wait)
+{
+	struct super_block *sb;
+	static DEFINE_MUTEX(mutex);
+
+	mutex_lock(&mutex);		/* Could be down_interruptible */
+	spin_lock(&sb_lock);
+	list_for_each_entry(sb, &super_blocks, s_list) {
+		if (sb->s_flags & MS_RDONLY)
+			continue;
+		sb->s_need_sync = 1;
+	}
+
+restart:
+	list_for_each_entry(sb, &super_blocks, s_list) {
+		if (!sb->s_need_sync)
+			continue;
+		sb->s_need_sync = 0;
+		if (sb->s_flags & MS_RDONLY)
+			continue;	/* hm.  Was remounted r/o meanwhile */
+		sb->s_count++;
+		spin_unlock(&sb_lock);
+		down_read(&sb->s_umount);
+		async_synchronize_full_domain(&sb->s_async_list);
+		if (sb->s_root)
+			__fsync_super(sb, wait);
+		up_read(&sb->s_umount);
+		/* restart only when sb is no longer on the list */
+		spin_lock(&sb_lock);
+		if (__put_super_and_need_restart(sb))
+			goto restart;
+	}
+	spin_unlock(&sb_lock);
+	mutex_unlock(&mutex);
+}
+
 SYSCALL_DEFINE0(sync)
 {
 	sync_filesystems(0);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index be2be8d..cbef739 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2083,7 +2083,6 @@ extern int filemap_fdatawrite_range(struct address_space *mapping,
 
 extern int vfs_fsync(struct file *file, struct dentry *dentry, int datasync);
 extern void sync_supers(void);
-extern void sync_filesystems(int wait);
 extern void emergency_sync(void);
 extern void emergency_remount(void);
 extern int do_remount_sb(struct super_block *sb, int flags,
-- 
1.6.0.2

