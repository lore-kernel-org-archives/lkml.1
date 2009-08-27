Return-Path: <linux-kernel-owner+w=401wt.eu-S1752819AbZH0OGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819AbZH0OGX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 10:06:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752580AbZH0OGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 10:06:20 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:34398 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbZH0OGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 10:06:17 -0400
Message-ID: <4A9692DA.20805@oss.ntt.co.jp>
Date: Thu, 27 Aug 2009 23:06:18 +0900
From: =?UTF-8?B?RmVybmFuZG8gTHVpcyBWw6F6cXVleiBDYW8=?= 
	<fernando@oss.ntt.co.jp>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: =?UTF-8?B?RmVybmFuZG8gTHVpcyBWw6F6cXVleiBDYW8=?= 
	<fernando@oss.ntt.co.jp>
CC: t-sato@yk.jp.nec.com, m-hamaguchi@ys.jp.nec.com,
       Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 4/4] filesystem freeze: add ISFROZEN ioctl
References: <4A94C151.8020900@oss.ntt.co.jp>
In-Reply-To: <4A94C151.8020900@oss.ntt.co.jp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ISFROZEN ioctl can be use by HA and monitoring software to check
the freeze state of a filesystem.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

diff -urNp linux-2.6.31-rc7-orig/fs/block_dev.c linux-2.6.31-rc7/fs/block_dev.c
--- linux-2.6.31-rc7-orig/fs/block_dev.c	2009-08-27 14:48:12.000000000 +0900
+++ linux-2.6.31-rc7/fs/block_dev.c	2009-08-27 18:49:46.000000000 +0900
@@ -334,6 +334,21 @@ out_unlock:
  }
  EXPORT_SYMBOL(thaw_bdev);

+/**
+ *
+ */
+int isfrozen_bdev(struct block_device *bdev, struct super_block *sb)
+{
+	int ret;
+
+	mutex_lock(&bdev->bd_fsfreeze_mutex);
+	ret = sb->s_frozen > SB_UNFROZEN ? 1:0;
+	mutex_unlock(&bdev->bd_fsfreeze_mutex);
+
+	return ret;
+}
+EXPORT_SYMBOL(isfrozen_bdev);
+
  static int blkdev_writepage(struct page *page, struct writeback_control *wbc)
  {
  	return block_write_full_page(page, blkdev_get_block, wbc);
diff -urNp linux-2.6.31-rc7-orig/fs/ioctl.c linux-2.6.31-rc7/fs/ioctl.c
--- linux-2.6.31-rc7-orig/fs/ioctl.c	2009-08-27 10:08:00.000000000 +0900
+++ linux-2.6.31-rc7/fs/ioctl.c	2009-08-27 18:49:17.000000000 +0900
@@ -536,6 +536,20 @@ static int ioctl_fsthaw(struct file *fil
  	return thaw_bdev(sb->s_bdev, sb);
  }

+static int ioctl_isfrozen(struct file *filp)
+{
+	struct super_block *sb = filp->f_path.dentry->d_inode->i_sb;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	/* If a blockdevice-backed filesystem isn't specified, return EINVAL. */
+	if (sb->s_bdev == NULL)
+		return -EINVAL;
+
+	return isfrozen_bdev(sb->s_bdev, sb);
+}
+
  /*
   * When you add any new common ioctls to the switches above and below
   * please update compat_sys_ioctl() too.
@@ -586,6 +600,12 @@ int do_vfs_ioctl(struct file *filp, unsi
  		error = ioctl_fsthaw(filp);
  		break;

+	case FIISFROZEN:
+		error = ioctl_isfrozen(filp);
+		if (error >= 0)
+			return put_user(error, (int __user *)arg);
+		break;
+
  	case FS_IOC_FIEMAP:
  		return ioctl_fiemap(filp, arg);

diff -urNp linux-2.6.31-rc7-orig/include/linux/fs.h linux-2.6.31-rc7/include/linux/fs.h
--- linux-2.6.31-rc7-orig/include/linux/fs.h	2009-08-27 14:48:12.000000000 +0900
+++ linux-2.6.31-rc7/include/linux/fs.h	2009-08-27 16:33:19.000000000 +0900
@@ -306,6 +306,7 @@ struct inodes_stat_t {
  #define FIGETBSZ   _IO(0x00,2)	/* get the block size used for bmap */
  #define FIFREEZE	_IOWR('X', 119, int)	/* Freeze */
  #define FITHAW		_IOWR('X', 120, int)	/* Thaw */
+#define FIISFROZEN	_IOWR('X', 121, int)	/* Is frozen? */

  #define	FS_IOC_GETFLAGS			_IOR('f', 1, long)
  #define	FS_IOC_SETFLAGS			_IOW('f', 2, long)
@@ -1955,6 +1956,7 @@ extern int sync_blockdev(struct block_de
  extern struct super_block *freeze_bdev(struct block_device *);
  extern void emergency_thaw_all(void);
  extern int thaw_bdev(struct block_device *bdev, struct super_block *sb);
+extern int isfrozen_bdev(struct block_device *bdev, struct super_block *sb);
  extern int fsync_bdev(struct block_device *);
  #else
  static inline void bd_forget(struct inode *inode) {}
@@ -1970,6 +1972,12 @@ static inline int thaw_bdev(struct block
  {
  	return 0;
  }
+
+extern int isfrozen_bdev(struct block_device *bdev, struct super_block *sb)
+{
+	return 0;
+}
+
  #endif
  extern int sync_filesystem(struct super_block *);
  extern const struct file_operations def_blk_fops;
