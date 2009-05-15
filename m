Return-Path: <linux-kernel-owner+w=401wt.eu-S1756654AbZEOGoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654AbZEOGoz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 02:44:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753976AbZEOGnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 02:43:49 -0400
Received: from sh.osrg.net ([192.16.179.4]:39329 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754178AbZEOGnp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 02:43:45 -0400
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 2/4] nilfs2: stop using sget to check if current mount is there
Date: Fri, 15 May 2009 15:37:24 +0900
Message-Id: <1242369446-25771-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1242369446-25771-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1242369446-25771-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Dispatcher: imput version 20050308(IM148)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 15 May 2009 15:43:12 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This stops using sget() for checking if an r/w-mount or an r/o-mount
exists on the device.  This elimination is achieved by scanning
existent nilfs->ns_supers list.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/nilfs2/super.c     |   71 +++++++------------------------------------------
 fs/nilfs2/the_nilfs.c |   35 ++++++++++++++++++++++++
 fs/nilfs2/the_nilfs.h |    2 +
 3 files changed, 47 insertions(+), 61 deletions(-)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 8131615..afa67ec 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -66,8 +66,6 @@ MODULE_DESCRIPTION("A New Implementation of the Log-structured Filesystem "
 MODULE_LICENSE("GPL");
 
 static int nilfs_remount(struct super_block *sb, int *flags, char *data);
-static int test_exclusive_mount(struct file_system_type *fs_type,
-				struct block_device *bdev, int flags);
 
 /**
  * nilfs_error() - report failure condition on a filesystem
@@ -946,10 +944,9 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 		 * by fsck since we originally mounted the partition.)
 		 */
 		down(&sb->s_bdev->bd_mount_sem);
-		/* Check existing RW-mount */
-		if (test_exclusive_mount(sb->s_type, sb->s_bdev, 0)) {
+		if (nilfs_current_mount_is_there(nilfs, 0, sbi)) {
 			printk(KERN_WARNING "NILFS (device %s): couldn't "
-			       "remount because a RW-mount exists.\n",
+			       "remount because an RW-mount exists.\n",
 			       sb->s_id);
 			err = -EBUSY;
 			goto rw_remount_failed;
@@ -1110,11 +1107,6 @@ nilfs_get_sb(struct file_system_type *fs_type, int flags,
 	 * while we are mounting
 	 */
 	down(&sd.bdev->bd_mount_sem);
-	if (!sd.cno &&
-	    (err = test_exclusive_mount(fs_type, sd.bdev, flags ^ MS_RDONLY))) {
-		err = (err < 0) ? : -EBUSY;
-		goto failed_unlock;
-	}
 
 	/*
 	 * Phase-1: search any existent instance and get the_nilfs
@@ -1139,6 +1131,14 @@ nilfs_get_sb(struct file_system_type *fs_type, int flags,
 		get_nilfs(nilfs);
 		up_write(&s->s_umount);
 
+		if (!sd.cno &&
+		    nilfs_current_mount_is_there(nilfs, !(flags & MS_RDONLY),
+						 NULL)) {
+			err = -EBUSY;
+			deactivate_super(s);
+			put_nilfs(nilfs);
+			goto failed_unlock;
+		}
 		/*
 		 * Phase-2: search specified snapshot or R/W mode super_block
 		 */
@@ -1210,57 +1210,6 @@ nilfs_get_sb(struct file_system_type *fs_type, int flags,
 	return err;
 }
 
-static int nilfs_test_bdev_super3(struct super_block *s, void *data)
-{
-	struct nilfs_super_data *sd = data;
-	int ret;
-
-	if (s->s_bdev != sd->bdev)
-		return 0;
-	if (down_read_trylock(&s->s_umount)) {
-		ret = (s->s_flags & MS_RDONLY) && s->s_root &&
-			nilfs_test_opt(NILFS_SB(s), SNAPSHOT);
-		up_read(&s->s_umount);
-		if (ret)
-			return 0; /* ignore snapshot mounts */
-	}
-	return !((sd->flags ^ s->s_flags) & MS_RDONLY);
-}
-
-static int __false_bdev_super(struct super_block *s, void *data)
-{
-#if 0 /* XXX: workaround for lock debug. This is not good idea */
-	up_write(&s->s_umount);
-#endif
-	return -EFAULT;
-}
-
-/**
- * test_exclusive_mount - check whether an exclusive RW/RO mount exists or not.
- * fs_type: filesystem type
- * bdev: block device
- * flag: 0 (check rw-mount) or MS_RDONLY (check ro-mount)
- * res: pointer to an integer to store result
- *
- * This function must be called within a section protected by bd_mount_mutex.
- */
-static int test_exclusive_mount(struct file_system_type *fs_type,
-				struct block_device *bdev, int flags)
-{
-	struct super_block *s;
-	struct nilfs_super_data sd = { .flags = flags, .bdev = bdev };
-
-	s = sget(fs_type, nilfs_test_bdev_super3, __false_bdev_super, &sd);
-	if (IS_ERR(s)) {
-		if (PTR_ERR(s) != -EFAULT)
-			return PTR_ERR(s);
-		return 0;  /* Not found */
-	}
-	up_write(&s->s_umount);
-	deactivate_super(s);
-	return 1;  /* Found */
-}
-
 struct file_system_type nilfs_fs_type = {
 	.owner    = THIS_MODULE,
 	.name     = "nilfs2",
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 7f65b3b..e5599e1 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -639,3 +639,38 @@ int nilfs_checkpoint_is_mounted(struct the_nilfs *nilfs, __u64 cno,
 	up_read(&nilfs->ns_sem);
 	return ret;
 }
+
+/**
+ * nilfs_current_mount_is_there - check if a non-snapshot mount is there
+ * nilfs: nilfs object
+ * ro_mount: mount type (0: ro-mount, otherwise: r/w-mount)
+ * me: instance which should be excluded from the test
+ *
+ * nilfs_current_mount_is_there() returns a non-zero value if a
+ * current mount with the specified mount type exists.  Otherwise zero
+ * is returned.  The optional @me argument specifies the instance
+ * which should be excluded fronm this test.  if NULL is specified to
+ * @me, this will check every instance.
+ */
+int nilfs_current_mount_is_there(struct the_nilfs *nilfs, int ro_mount,
+				 struct nilfs_sb_info *me)
+{
+	struct nilfs_sb_info *sbi;
+	int found = 0;
+
+	down_read(&nilfs->ns_sem);
+	list_for_each_entry(sbi, &nilfs->ns_supers, s_list) {
+		/*
+		 * The SNAPSHOT flag and sb->s_flags are supposed to be
+		 * protected with nilfs->ns_sem.
+		 */
+		if (nilfs_test_opt(sbi, SNAPSHOT) || sbi == me)
+			continue; /* exclude snapshot mounts and self */
+		if (!ro_mount == !(sbi->s_super->s_flags & MS_RDONLY)) {
+			found++;
+			break;
+		}
+	}
+	up_read(&nilfs->ns_sem);
+	return found;
+}
diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
index 30fe587..e9cfd74 100644
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -197,6 +197,8 @@ int init_nilfs(struct the_nilfs *, struct nilfs_sb_info *, char *);
 int load_nilfs(struct the_nilfs *, struct nilfs_sb_info *);
 int nilfs_count_free_blocks(struct the_nilfs *, sector_t *);
 int nilfs_checkpoint_is_mounted(struct the_nilfs *, __u64, int);
+int nilfs_current_mount_is_there(struct the_nilfs *, int,
+				 struct nilfs_sb_info *);
 int nilfs_near_disk_full(struct the_nilfs *);
 void nilfs_fall_back_super_block(struct the_nilfs *);
 void nilfs_swap_super_block(struct the_nilfs *);
-- 
1.6.2

