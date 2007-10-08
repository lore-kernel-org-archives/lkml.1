Return-Path: <linux-kernel-owner+w=401wt.eu-S1754236AbXJHGkD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236AbXJHGkD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 02:40:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbXJHGjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 02:39:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:59661 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542AbXJHGjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 02:39:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: David Miller <davem@davemloft.net>
Subject: [PATCHv2 1/9] compat_ioctl: move common block ioctls to compat_blkdev_ioctl
Date: Mon, 8 Oct 2007 08:38:56 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
References: <20071006181902.141862534@arndb.de> <20071008051218.GS8181@ftp.linux.org.uk> <20071007.230407.07619446.davem@davemloft.net>
In-Reply-To: <20071007.230407.07619446.davem@davemloft.net>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
Cc: viro@ftp.linux.org.uk, jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       hch@lst.de
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710080838.58257.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19DFq014+vexPKjiNAbN/zXcUtXsj7AiYFaC1s
 6r0D5S5gQHLXW5DYFAkSCZUYDVNDsLbeT9iczEUHNkKY+K0ZZj
 0iqTHnsMybSSkhz7x6Ybg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make compat_blkdev_ioctl and blkdev_ioctl reflect the respective
native versions. This is somewhat more efficient and makes it easier
to keep the two in sync.

Also get rid of the bogus handling for broken_blkgetsize and the
duplicate entry for BLKRASET.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

---

On Monday 08 October 2007, you wrote:
> From: Al Viro <viro@ftp.linux.org.uk>
> > I'd simply kill that.
> 
> Agreed.

ok.

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
@@ -0,0 +1,121 @@
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
