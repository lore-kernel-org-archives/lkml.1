Return-Path: <linux-kernel-owner+w=401wt.eu-S1753598AbZEOGn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598AbZEOGn6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 02:43:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753227AbZEOGnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 02:43:40 -0400
Received: from sh.osrg.net ([192.16.179.4]:39322 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752476AbZEOGnj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 02:43:39 -0400
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
       Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 4/4] nilfs2: reduce bd_mount_sem use to a minimum
Date: Fri, 15 May 2009 15:37:26 +0900
Message-Id: <1242369446-25771-5-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1242369446-25771-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1242369446-25771-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Dispatcher: imput version 20050308(IM148)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 15 May 2009 15:43:12 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will get rid of bd_mount_sem use from nilfs except ones
surrounding an sget() call.

The intended exclusion control is replaced by ns_mount_mutex that
this patch inserts in the nilfs object.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/nilfs2/cpfile.c    |    6 +++---
 fs/nilfs2/super.c     |   20 +++++++++++---------
 fs/nilfs2/the_nilfs.c |    1 +
 fs/nilfs2/the_nilfs.h |    2 ++
 4 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/fs/nilfs2/cpfile.c b/fs/nilfs2/cpfile.c
index e90b60d..79346a5 100644
--- a/fs/nilfs2/cpfile.c
+++ b/fs/nilfs2/cpfile.c
@@ -862,11 +862,11 @@ int nilfs_cpfile_change_cpmode(struct inode *cpfile, __u64 cno, int mode)
 	case NILFS_CHECKPOINT:
 		/*
 		 * Check for protecting existing snapshot mounts:
-		 * bd_mount_sem is used to make this operation atomic and
+		 * ns_mount_sem is used to make this operation atomic and
 		 * exclusive with a new mount job.  Though it doesn't cover
 		 * umount, it's enough for the purpose.
 		 */
-		down(&nilfs->ns_bdev->bd_mount_sem);
+		mutex_lock(&nilfs->ns_mount_mutex);
 		if (nilfs_checkpoint_is_mounted(nilfs, cno, 1)) {
 			/* Current implementation does not have to protect
 			   plain read-only mounts since they are exclusive
@@ -875,7 +875,7 @@ int nilfs_cpfile_change_cpmode(struct inode *cpfile, __u64 cno, int mode)
 			ret = -EBUSY;
 		} else
 			ret = nilfs_cpfile_clear_snapshot(cpfile, cno);
-		up(&nilfs->ns_bdev->bd_mount_sem);
+		mutex_unlock(&nilfs->ns_mount_mutex);
 		return ret;
 	case NILFS_SNAPSHOT:
 		return nilfs_cpfile_set_snapshot(cpfile, cno);
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 5992997..64ef0b9 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -750,7 +750,7 @@ int nilfs_store_magic_and_option(struct super_block *sb,
  * @silent: silent mode flag
  * @nilfs: the_nilfs struct
  *
- * This function is called exclusively by bd_mount_mutex.
+ * This function is called exclusively by nilfs->ns_mount_mutex.
  * So, the recovery process is protected from other simultaneous mounts.
  */
 static int
@@ -943,7 +943,7 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 		 * store the current valid flag.  (It may have been changed
 		 * by fsck since we originally mounted the partition.)
 		 */
-		down(&sb->s_bdev->bd_mount_sem);
+		mutex_lock(&nilfs->ns_mount_mutex);
 		if (nilfs_current_mount_is_there(nilfs, 0, sbi)) {
 			printk(KERN_WARNING "NILFS (device %s): couldn't "
 			       "remount because an RW-mount exists.\n",
@@ -971,13 +971,13 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 		nilfs_setup_super(sbi);
 		up_write(&nilfs->ns_sem);
 
-		up(&sb->s_bdev->bd_mount_sem);
+		mutex_unlock(&nilfs->ns_mount_mutex);
 	}
  out:
 	return 0;
 
  rw_remount_failed:
-	up(&sb->s_bdev->bd_mount_sem);
+	mutex_unlock(&nilfs->ns_mount_mutex);
  restore_opts:
 	sb->s_flags = old_sb_flags;
 	sbi->s_mount_opt = old_opts.mount_opt;
@@ -1100,7 +1100,7 @@ nilfs_get_sb(struct file_system_type *fs_type, int flags,
 		goto failed;
 	}
 
-	down(&sd.bdev->bd_mount_sem);
+	mutex_lock(&nilfs->ns_mount_mutex);
 
 	if (!sd.cno &&
 	    nilfs_current_mount_is_there(nilfs, !(flags & MS_RDONLY), NULL)) {
@@ -1115,7 +1115,9 @@ nilfs_get_sb(struct file_system_type *fs_type, int flags,
 		/* trying to get the latest checkpoint.  */
 		sd.cno = nilfs_last_cno(nilfs);
 
+	down(&sd.bdev->bd_mount_sem);
 	s = sget(fs_type, nilfs_test_bdev_super, nilfs_set_bdev_super, &sd);
+	up(&sd.bdev->bd_mount_sem);
 	if (IS_ERR(s)) {
 		err = PTR_ERR(s);
 		goto failed_unlock;
@@ -1137,7 +1139,7 @@ nilfs_get_sb(struct file_system_type *fs_type, int flags,
 		need_to_close = 0;
 	}
 
-	up(&sd.bdev->bd_mount_sem);
+	mutex_unlock(&nilfs->ns_mount_mutex);
 	put_nilfs(nilfs);
 	if (need_to_close)
 		close_bdev_exclusive(sd.bdev, flags);
@@ -1145,7 +1147,7 @@ nilfs_get_sb(struct file_system_type *fs_type, int flags,
 	return 0;
 
  failed_unlock:
-	up(&sd.bdev->bd_mount_sem);
+	mutex_unlock(&nilfs->ns_mount_mutex);
 	put_nilfs(nilfs);
  failed:
 	close_bdev_exclusive(sd.bdev, flags);
@@ -1154,14 +1156,14 @@ nilfs_get_sb(struct file_system_type *fs_type, int flags,
 
  cancel_new:
 	/* Abandoning the newly allocated superblock */
-	up(&sd.bdev->bd_mount_sem);
+	mutex_unlock(&nilfs->ns_mount_mutex);
 	put_nilfs(nilfs);
 	up_write(&s->s_umount);
 	deactivate_super(s);
 	/*
 	 * deactivate_super() invokes close_bdev_exclusive().
 	 * We must finish all post-cleaning before this call;
-	 * put_nilfs() and unlocking bd_mount_sem need the block device.
+	 * put_nilfs() needs the block device.
 	 */
 	return err;
 }
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 8ac22f6..51ffde0 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -72,6 +72,7 @@ static struct the_nilfs *alloc_nilfs(struct block_device *bdev)
 	atomic_set(&nilfs->ns_writer_refcount, -1);
 	atomic_set(&nilfs->ns_ndirtyblks, 0);
 	init_rwsem(&nilfs->ns_sem);
+	mutex_init(&nilfs->ns_mount_mutex);
 	mutex_init(&nilfs->ns_writer_mutex);
 	INIT_LIST_HEAD(&nilfs->ns_list);
 	INIT_LIST_HEAD(&nilfs->ns_supers);
diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
index 4249eb3..76af4c9 100644
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -48,6 +48,7 @@ enum {
  * @ns_bdi: backing dev info
  * @ns_writer: back pointer to writable nilfs_sb_info
  * @ns_sem: semaphore for shared states
+ * @ns_mount_mutex: mutex protecting mount/remount process of nilfs
  * @ns_writer_mutex: mutex protecting ns_writer attach/detach
  * @ns_writer_refcount: number of referrers on ns_writer
  * @ns_sbh: buffer heads of on-disk super blocks
@@ -95,6 +96,7 @@ struct the_nilfs {
 	struct backing_dev_info *ns_bdi;
 	struct nilfs_sb_info   *ns_writer;
 	struct rw_semaphore	ns_sem;
+	struct mutex		ns_mount_mutex;
 	struct mutex		ns_writer_mutex;
 	atomic_t		ns_writer_refcount;
 
-- 
1.6.2

