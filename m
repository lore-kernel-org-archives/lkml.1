Return-Path: <linux-kernel-owner+w=401wt.eu-S1752765AbZH0OGE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765AbZH0OGE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 10:06:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752703AbZH0OGC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 10:06:02 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:34373 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699AbZH0OGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 10:06:00 -0400
Message-ID: <4A9692CA.7020607@oss.ntt.co.jp>
Date: Thu, 27 Aug 2009 23:06:02 +0900
From: =?ISO-8859-1?Q?Fernando_Luis_V=E1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: t-sato@yk.jp.nec.com, m-hamaguchi@ys.jp.nec.com,
       Al Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 2/4] freeze_bdev: grab active reference to frozen superblocks
References: <4A94C151.8020900@oss.ntt.co.jp> <20090826173839.GA20175@lst.de> <4A965BD1.205@oss.ntt.co.jp>
In-Reply-To: <4A965BD1.205@oss.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Author: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/4] freeze_bdev: grab active reference to frozen superblocks

Currently we held s_umount while a filesystem is frozen, despite that we
might return to userspace and unlock it from a different process.  Instead
grab an active reference to keep the file system busy and add an explicit
check for frozen filesystems in remount and reject the remount instead
of blocking on s_umount.

Add a new get_active_super helper to super.c for use by freeze_bdev that
grabs an active reference to a superblock from a given block device.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---

diff -urNp linux-2.6.31-rc7-orig/fs/block_dev.c linux-2.6.31-rc7/fs/block_dev.c
--- linux-2.6.31-rc7-orig/fs/block_dev.c	2009-08-27 19:38:47.000000000 +0900
+++ linux-2.6.31-rc7/fs/block_dev.c	2009-08-27 19:38:55.000000000 +0900
@@ -230,43 +230,54 @@ struct super_block *freeze_bdev(struct b
  	int error = 0;

  	mutex_lock(&bdev->bd_fsfreeze_mutex);
-	if (bdev->bd_fsfreeze_count > 0) {
-		bdev->bd_fsfreeze_count++;
+	if (++bdev->bd_fsfreeze_count > 1) {
+		/*
+		 * We don't even need to grab a reference - the first call
+		 * to freeze_bdev grab an active reference and only the last
+		 * thaw_bdev drops it.
+		 */
  		sb = get_super(bdev);
+		drop_super(sb);
  		mutex_unlock(&bdev->bd_fsfreeze_mutex);
  		return sb;
  	}
-	bdev->bd_fsfreeze_count++;

-	sb = get_super(bdev);
-	if (sb && !(sb->s_flags & MS_RDONLY)) {
-		sb->s_frozen = SB_FREEZE_WRITE;
-		smp_wmb();
-
-		sync_filesystem(sb);
-
-		sb->s_frozen = SB_FREEZE_TRANS;
-		smp_wmb();
-
-		sync_blockdev(sb->s_bdev);
-
-		if (sb->s_op->freeze_fs) {
-			error = sb->s_op->freeze_fs(sb);
-			if (error) {
-				printk(KERN_ERR
-					"VFS:Filesystem freeze failed\n");
-				sb->s_frozen = SB_UNFROZEN;
-				drop_super(sb);
-				bdev->bd_fsfreeze_count--;
-				mutex_unlock(&bdev->bd_fsfreeze_mutex);
-				return ERR_PTR(error);
-			}
+	sb = get_active_super(bdev);
+	if (!sb)
+		goto out;
+	if (sb->s_flags & MS_RDONLY) {
+		deactivate_locked_super(sb);
+		mutex_unlock(&bdev->bd_fsfreeze_mutex);
+		return sb;
+	}
+
+	sb->s_frozen = SB_FREEZE_WRITE;
+	smp_wmb();
+
+	sync_filesystem(sb);
+
+	sb->s_frozen = SB_FREEZE_TRANS;
+	smp_wmb();
+
+	sync_blockdev(sb->s_bdev);
+
+	if (sb->s_op->freeze_fs) {
+		error = sb->s_op->freeze_fs(sb);
+		if (error) {
+			printk(KERN_ERR
+				"VFS:Filesystem freeze failed\n");
+			sb->s_frozen = SB_UNFROZEN;
+			deactivate_locked_super(sb);
+			bdev->bd_fsfreeze_count--;
+			mutex_unlock(&bdev->bd_fsfreeze_mutex);
+			return ERR_PTR(error);
  		}
  	}
+	up_write(&sb->s_umount);

+ out:
  	sync_blockdev(bdev);
  	mutex_unlock(&bdev->bd_fsfreeze_mutex);
-
  	return sb;	/* thaw_bdev releases s->s_umount */
  }
  EXPORT_SYMBOL(freeze_bdev);
@@ -280,43 +291,44 @@ EXPORT_SYMBOL(freeze_bdev);
   */
  int thaw_bdev(struct block_device *bdev, struct super_block *sb)
  {
-	int error = 0;
+	int error = -EINVAL;

  	mutex_lock(&bdev->bd_fsfreeze_mutex);
-	if (!bdev->bd_fsfreeze_count) {
-		mutex_unlock(&bdev->bd_fsfreeze_mutex);
-		return -EINVAL;
-	}
+	if (!bdev->bd_fsfreeze_count)
+		goto out_unlock;

-	bdev->bd_fsfreeze_count--;
-	if (bdev->bd_fsfreeze_count > 0) {
-		if (sb)
-			drop_super(sb);
-		mutex_unlock(&bdev->bd_fsfreeze_mutex);
-		return 0;
-	}
-
-	if (sb) {
-		BUG_ON(sb->s_bdev != bdev);
-		if (!(sb->s_flags & MS_RDONLY)) {
-			if (sb->s_op->unfreeze_fs) {
-				error = sb->s_op->unfreeze_fs(sb);
-				if (error) {
-					printk(KERN_ERR
-						"VFS:Filesystem thaw failed\n");
-					sb->s_frozen = SB_FREEZE_TRANS;
-					bdev->bd_fsfreeze_count++;
-					mutex_unlock(&bdev->bd_fsfreeze_mutex);
-					return error;
-				}
-			}
-			sb->s_frozen = SB_UNFROZEN;
-			smp_wmb();
-			wake_up(&sb->s_wait_unfrozen);
+	error = 0;
+	if (--bdev->bd_fsfreeze_count > 0)
+		goto out_unlock;
+
+	if (!sb)
+		goto out_unlock;
+
+	BUG_ON(sb->s_bdev != bdev);
+	down_write(&sb->s_umount);
+	if (sb->s_flags & MS_RDONLY)
+		goto out_deactivate;
+
+	if (sb->s_op->unfreeze_fs) {
+		error = sb->s_op->unfreeze_fs(sb);
+		if (error) {
+			printk(KERN_ERR
+				"VFS:Filesystem thaw failed\n");
+			sb->s_frozen = SB_FREEZE_TRANS;
+			bdev->bd_fsfreeze_count++;
+			mutex_unlock(&bdev->bd_fsfreeze_mutex);
+			return error;
  		}
-		drop_super(sb);
  	}

+	sb->s_frozen = SB_UNFROZEN;
+	smp_wmb();
+	wake_up(&sb->s_wait_unfrozen);
+
+out_deactivate:
+	if (sb)
+		deactivate_locked_super(sb);
+out_unlock:
  	mutex_unlock(&bdev->bd_fsfreeze_mutex);
  	return 0;
  }
diff -urNp linux-2.6.31-rc7-orig/fs/super.c linux-2.6.31-rc7/fs/super.c
--- linux-2.6.31-rc7-orig/fs/super.c	2009-08-27 19:38:47.000000000 +0900
+++ linux-2.6.31-rc7/fs/super.c	2009-08-27 19:38:55.000000000 +0900
@@ -468,6 +468,48 @@ rescan:
  }

  EXPORT_SYMBOL(get_super);
+
+/**
+ * get_active_super - get an active reference to the superblock of a device
+ * @bdev: device to get the superblock for
+ *
+ * Scans the superblock list and finds the superblock of the file system
+ * mounted on the device given.  Returns the superblock with an active
+ * reference and s_umount held exclusively or %NULL if none was found.
+ */
+struct super_block *get_active_super(struct block_device *bdev)
+{
+	struct super_block *sb;
+
+	if (!bdev)
+		return NULL;
+
+	spin_lock(&sb_lock);
+	list_for_each_entry(sb, &super_blocks, s_list) {
+		if (sb->s_bdev != bdev)
+			continue;
+
+		sb->s_count++;
+		spin_unlock(&sb_lock);
+		down_write(&sb->s_umount);
+		if (sb->s_root) {
+			spin_lock(&sb_lock);
+			if (sb->s_count > S_BIAS) {
+				atomic_inc(&sb->s_active);
+				sb->s_count--;
+				spin_unlock(&sb_lock);
+				return sb;
+			}
+			spin_unlock(&sb_lock);
+		}
+		up_write(&sb->s_umount);
+		put_super(sb);
+		yield();
+		spin_lock(&sb_lock);
+	}
+	spin_unlock(&sb_lock);
+	return NULL;
+}

  struct super_block * user_get_super(dev_t dev)
  {
@@ -530,11 +572,15 @@ int do_remount_sb(struct super_block *sb
  {
  	int retval;
  	int remount_rw;
-	
+
+	if (sb->s_frozen != SB_UNFROZEN)
+		return -EBUSY;
+
  #ifdef CONFIG_BLOCK
  	if (!(flags & MS_RDONLY) && bdev_read_only(sb->s_bdev))
  		return -EACCES;
  #endif
+
  	if (flags & MS_RDONLY)
  		acct_auto_close(sb);
  	shrink_dcache_sb(sb);
diff -urNp linux-2.6.31-rc7-orig/include/linux/fs.h linux-2.6.31-rc7/include/linux/fs.h
--- linux-2.6.31-rc7-orig/include/linux/fs.h	2009-08-27 19:38:47.000000000 +0900
+++ linux-2.6.31-rc7/include/linux/fs.h	2009-08-27 19:38:55.000000000 +0900
@@ -2320,6 +2320,7 @@ extern void get_filesystem(struct file_s
  extern void put_filesystem(struct file_system_type *fs);
  extern struct file_system_type *get_fs_type(const char *name);
  extern struct super_block *get_super(struct block_device *);
+extern struct super_block *get_active_super(struct block_device *bdev);
  extern struct super_block *user_get_super(dev_t);
  extern void drop_super(struct super_block *sb);

