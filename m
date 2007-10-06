Return-Path: <linux-kernel-owner+w=401wt.eu-S1764576AbXJFS3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764576AbXJFS3v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 14:29:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764355AbXJFS24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 14:28:56 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:58272 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764238AbXJFS2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 14:28:54 -0400
Message-Id: <20071006182342.566716634@arndb.de>
References: <20071006181902.141862534@arndb.de>
User-Agent: quilt/0.46-1
Date: Sat, 06 Oct 2007 20:19:03 +0200
From: Arnd Bergmann <arnd@arndb.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net, hch@lst.de,
       Al Viro <viro@ftp.linux.org.uk>
Subject: [patch 1/9] compat_ioctl: move common block ioctls to compat_blkdev_ioctl
Content-Disposition: inline; filename=block-compat-base.diff
X-Provags-ID: V01U2FsdGVkX1+qgeYAJRgIASADVGMaNlG1suIjchcG7PC6AB7
 4cBsGYlTmPf+XfaOKu/qOKmEMby95xVztE9CTNR1q/0Xa73vBE
 VGwdkNeyuR5h22eGO22pg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make compat_blkdev_ioctl and blkdev_ioctl reflect the respective
native versions. This is somewhat more efficient and makes it easier
to keep the two in sync.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Index: linux-2.6/block/Makefile
===================================================================
--- linux-2.6.orig/block/Makefile
+++ linux-2.6/block/Makefile
@@ -11,3 +11,4 @@ obj-$(CONFIG_IOSCHED_DEADLINE)	+= deadli
 obj-$(CONFIG_IOSCHED_CFQ)	+= cfq-iosched.o
 
 obj-$(CONFIG_BLK_DEV_IO_TRACE)	+= blktrace.o
+obj-$(CONFIG_COMPAT)		+= compat_ioctl.o
Index: linux-2.6/block/compat_ioctl.c
===================================================================
--- /dev/null
+++ linux-2.6/block/compat_ioctl.c
@@ -0,0 +1,123 @@
+#include <linux/blkdev.h>
+#include <linux/blkpg.h>
+#include <linux/blktrace_api.h>
+#include <linux/cdrom.h>
+#include <linux/compat.h>
+#include <linux/elevator.h>
+#include <linux/fd.h>
+#include <linux/hdreg.h>
+#include <linux/syscalls.h>
+#include <linux/smp_lock.h>
+#include <linux/types.h>
+#include <linux/uaccess.h>
+
+static int compat_put_ushort(unsigned long arg, unsigned short val)
+{
+	return put_user(val, (unsigned short __user *)compat_ptr(arg));
+}
+
+static int compat_put_int(unsigned long arg, int val)
+{
+	return put_user(val, (compat_int_t __user *)compat_ptr(arg));
+}
+
+static int compat_put_long(unsigned long arg, long val)
+{
+	return put_user(val, (compat_long_t __user *)compat_ptr(arg));
+}
+
+static int compat_put_ulong(unsigned long arg, compat_ulong_t val)
+{
+	return put_user(val, (compat_ulong_t __user *)compat_ptr(arg));
+}
+
+static int compat_put_u64(unsigned long arg, u64 val)
+{
+	return put_user(val, (compat_u64 __user *)compat_ptr(arg));
+}
+
+#define BLKBSZGET_32		_IOR(0x12, 112, int)
+#define BLKBSZSET_32		_IOW(0x12, 113, int)
+#define BLKGETSIZE64_32		_IOR(0x12, 114, int)
+
+static int compat_blkdev_locked_ioctl(struct inode *inode, struct file *file,
+				struct block_device *bdev,
+				unsigned cmd, unsigned long arg)
+{
+	struct backing_dev_info *bdi;
+
+	switch (cmd) {
+	case BLKRAGET:
+	case BLKFRAGET:
+		if (!arg)
+			return -EINVAL;
+		bdi = blk_get_backing_dev_info(bdev);
+		if (bdi == NULL)
+			return -ENOTTY;
+		return compat_put_long(arg,
+				       (bdi->ra_pages * PAGE_CACHE_SIZE) / 512);
+	case BLKROGET: /* compatible */
+		return compat_put_int(arg, bdev_read_only(bdev) != 0);
+	case BLKBSZGET_32: /* get the logical block size (cf. BLKSSZGET) */
+		return compat_put_int(arg, block_size(bdev));
+	case BLKSSZGET: /* get block device hardware sector size */
+		return compat_put_int(arg, bdev_hardsect_size(bdev));
+	case BLKSECTGET:
+		return compat_put_ushort(arg,
+					 bdev_get_queue(bdev)->max_sectors);
+	case BLKRASET: /* compatible, but no compat_ptr (!) */
+	case BLKFRASET:
+		if (!capable(CAP_SYS_ADMIN))
+			return -EACCES;
+		bdi = blk_get_backing_dev_info(bdev);
+		if (bdi == NULL)
+			return -ENOTTY;
+		bdi->ra_pages = (arg * 512) / PAGE_CACHE_SIZE;
+		return 0;
+	/* The mkswap binary hard codes it to Intel value :-((( */
+	case 0x1260:
+	case BLKGETSIZE:
+		if ((bdev->bd_inode->i_size >> 9) > ~0UL)
+			return -EFBIG;
+		return compat_put_ulong(arg, bdev->bd_inode->i_size >> 9);
+
+	case BLKGETSIZE64_32:
+		return compat_put_u64(arg, bdev->bd_inode->i_size);
+	}
+	return -ENOIOCTLCMD;
+}
+
+/* Most of the generic ioctls are handled in the normal fallback path.
+   This assumes the blkdev's low level compat_ioctl always returns
+   ENOIOCTLCMD for unknown ioctls. */
+long compat_blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg)
+{
+	int ret = -ENOIOCTLCMD;
+	struct inode *inode = file->f_mapping->host;
+	struct block_device *bdev = inode->i_bdev;
+	struct gendisk *disk = bdev->bd_disk;
+
+	switch (cmd) {
+	case BLKFLSBUF:
+	case BLKROSET:
+	/*
+	 * the ones below are implemented in blkdev_locked_ioctl,
+	 * but we call blkdev_ioctl, which gets the lock for us
+	 */
+	case BLKRRPART:
+		return blkdev_ioctl(inode, file, cmd,
+				(unsigned long)compat_ptr(arg));
+	case BLKBSZSET_32:
+		return blkdev_ioctl(inode, file, BLKBSZSET,
+				(unsigned long)compat_ptr(arg));
+	}
+
+	lock_kernel();
+	ret = compat_blkdev_locked_ioctl(inode, file, bdev, cmd, arg);
+	/* FIXME: why do we assume -> compat_ioctl needs the BKL? */
+	if (ret == -ENOIOCTLCMD && disk->fops->compat_ioctl)
+		ret = disk->fops->compat_ioctl(file, cmd, arg);
+	unlock_kernel();
+
+	return ret;
+}
Index: linux-2.6/block/ioctl.c
===================================================================
--- linux-2.6.orig/block/ioctl.c
+++ linux-2.6/block/ioctl.c
@@ -217,6 +217,10 @@ int blkdev_driver_ioctl(struct inode *in
 }
 EXPORT_SYMBOL_GPL(blkdev_driver_ioctl);
 
+/*
+ * always keep this in sync with compat_blkdev_ioctl() and
+ * compat_blkdev_locked_ioctl()
+ */
 int blkdev_ioctl(struct inode *inode, struct file *file, unsigned cmd,
 			unsigned long arg)
 {
@@ -284,21 +288,4 @@ int blkdev_ioctl(struct inode *inode, st
 
 	return blkdev_driver_ioctl(inode, file, disk, cmd, arg);
 }
-
-/* Most of the generic ioctls are handled in the normal fallback path.
-   This assumes the blkdev's low level compat_ioctl always returns
-   ENOIOCTLCMD for unknown ioctls. */
-long compat_blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg)
-{
-	struct block_device *bdev = file->f_path.dentry->d_inode->i_bdev;
-	struct gendisk *disk = bdev->bd_disk;
-	int ret = -ENOIOCTLCMD;
-	if (disk->fops->compat_ioctl) {
-		lock_kernel();
-		ret = disk->fops->compat_ioctl(file, cmd, arg);
-		unlock_kernel();
-	}
-	return ret;
-}
-
 EXPORT_SYMBOL_GPL(blkdev_ioctl);
Index: linux-2.6/fs/compat_ioctl.c
===================================================================
--- linux-2.6.orig/fs/compat_ioctl.c
+++ linux-2.6/fs/compat_ioctl.c
@@ -1537,12 +1537,6 @@ ret_einval(unsigned int fd, unsigned int
 }
 
 #ifdef CONFIG_BLOCK
-static int broken_blkgetsize(unsigned int fd, unsigned int cmd, unsigned long arg)
-{
-	/* The mkswap binary hard codes it to Intel value :-((( */
-	return w_long(fd, BLKGETSIZE, arg);
-}
-
 struct blkpg_ioctl_arg32 {
 	compat_int_t op;
 	compat_int_t flags;
@@ -1578,29 +1572,6 @@ static int ioc_settimeout(unsigned int f
 	return rw_long(fd, AUTOFS_IOC_SETTIMEOUT, arg);
 }
 
-#ifdef CONFIG_BLOCK
-/* Fix sizeof(sizeof()) breakage */
-#define BLKBSZGET_32   _IOR(0x12,112,int)
-#define BLKBSZSET_32   _IOW(0x12,113,int)
-#define BLKGETSIZE64_32        _IOR(0x12,114,int)
-
-static int do_blkbszget(unsigned int fd, unsigned int cmd, unsigned long arg)
-{
-       return sys_ioctl(fd, BLKBSZGET, (unsigned long)compat_ptr(arg));
-}
-
-static int do_blkbszset(unsigned int fd, unsigned int cmd, unsigned long arg)
-{
-       return sys_ioctl(fd, BLKBSZSET, (unsigned long)compat_ptr(arg));
-}
-
-static int do_blkgetsize64(unsigned int fd, unsigned int cmd,
-                          unsigned long arg)
-{
-       return sys_ioctl(fd, BLKGETSIZE64, (unsigned long)compat_ptr(arg));
-}
-#endif
-
 /* Bluetooth ioctls */
 #define HCIUARTSETPROTO	_IOW('U', 200, int)
 #define HCIUARTGETPROTO	_IOR('U', 201, int)
@@ -2546,19 +2517,11 @@ COMPATIBLE_IOCTL(FDFMTTRK)
 COMPATIBLE_IOCTL(FDRAWCMD)
 /* 0x12 */
 #ifdef CONFIG_BLOCK
-COMPATIBLE_IOCTL(BLKRASET)
-COMPATIBLE_IOCTL(BLKROSET)
-COMPATIBLE_IOCTL(BLKROGET)
-COMPATIBLE_IOCTL(BLKRRPART)
-COMPATIBLE_IOCTL(BLKFLSBUF)
 COMPATIBLE_IOCTL(BLKSECTSET)
-COMPATIBLE_IOCTL(BLKSSZGET)
 COMPATIBLE_IOCTL(BLKTRACESTART)
 COMPATIBLE_IOCTL(BLKTRACESTOP)
 COMPATIBLE_IOCTL(BLKTRACESETUP)
 COMPATIBLE_IOCTL(BLKTRACETEARDOWN)
-ULONG_IOCTL(BLKRASET)
-ULONG_IOCTL(BLKFRASET)
 #endif
 /* RAID */
 COMPATIBLE_IOCTL(RAID_VERSION)
@@ -3337,11 +3300,6 @@ HANDLE_IOCTL(SIOCGSTAMPNS, do_siocgstamp
 #endif
 #ifdef CONFIG_BLOCK
 HANDLE_IOCTL(HDIO_GETGEO, hdio_getgeo)
-HANDLE_IOCTL(BLKRAGET, w_long)
-HANDLE_IOCTL(BLKGETSIZE, w_long)
-HANDLE_IOCTL(0x1260, broken_blkgetsize)
-HANDLE_IOCTL(BLKFRAGET, w_long)
-HANDLE_IOCTL(BLKSECTGET, w_long)
 HANDLE_IOCTL(BLKPG, blkpg_ioctl_trans)
 HANDLE_IOCTL(HDIO_GET_UNMASKINTR, hdio_ioctl_trans)
 HANDLE_IOCTL(HDIO_GET_MULTCOUNT, hdio_ioctl_trans)
@@ -3415,9 +3373,6 @@ HANDLE_IOCTL(SONET_GETFRAMING, do_atm_io
 HANDLE_IOCTL(SONET_GETFRSENSE, do_atm_ioctl)
 /* block stuff */
 #ifdef CONFIG_BLOCK
-HANDLE_IOCTL(BLKBSZGET_32, do_blkbszget)
-HANDLE_IOCTL(BLKBSZSET_32, do_blkbszset)
-HANDLE_IOCTL(BLKGETSIZE64_32, do_blkgetsize64)
 /* Raw devices */
 HANDLE_IOCTL(RAW_SETBIND, raw_ioctl)
 HANDLE_IOCTL(RAW_GETBIND, raw_ioctl)

-- 

