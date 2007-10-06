Return-Path: <linux-kernel-owner+w=401wt.eu-S1764300AbXJFSaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764300AbXJFSaT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 14:30:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764866AbXJFS32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 14:29:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:58088 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764849AbXJFS3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 14:29:24 -0400
Message-Id: <20071006182343.052354547@arndb.de>
References: <20071006181902.141862534@arndb.de>
User-Agent: quilt/0.46-1
Date: Sat, 06 Oct 2007 20:19:06 +0200
From: Arnd Bergmann <arnd@arndb.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net, hch@lst.de,
       Al Viro <viro@ftp.linux.org.uk>
Subject: [patch 4/9] compat_ioctl: move hdio calls to block/compat_ioctl.c
Content-Disposition: inline; filename=compat-hdiogetgeo.diff
X-Provags-ID: V01U2FsdGVkX1/I2LD1NNJVXi6TfU5PmIHCBaVSidVkQHGF8XD
 x8mtI1TvRKuhm3Z1G67bh3K7cLV3deZNHu1x5NPPx8xiZole5l
 a4FStoULRQUVDvAXEnZhA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

These are common to multiple block drivers, so they should
be handled by the block layer.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Index: linux-2.6/block/compat_ioctl.c
===================================================================
--- linux-2.6.orig/block/compat_ioctl.c
+++ linux-2.6/block/compat_ioctl.c
@@ -36,6 +36,62 @@ static int compat_put_u64(unsigned long 
 	return put_user(val, (compat_u64 __user *)compat_ptr(arg));
 }
 
+struct compat_hd_geometry {
+	unsigned char heads;
+	unsigned char sectors;
+	unsigned short cylinders;
+	u32 start;
+};
+
+static int compat_hdio_getgeo(struct gendisk *disk, struct block_device *bdev,
+			struct compat_hd_geometry __user *ugeo)
+{
+	struct hd_geometry geo;
+	int ret;
+
+	if (!ugeo)
+		return -EINVAL;
+	if (!disk->fops->getgeo)
+		return -ENOTTY;
+
+	/*
+	 * We need to set the startsect first, the driver may
+	 * want to override it.
+	 */
+	geo.start = get_start_sect(bdev);
+	ret = disk->fops->getgeo(bdev, &geo);
+	if (ret)
+		return ret;
+
+	ret = copy_to_user(ugeo, &geo, 4);
+	ret |= __put_user(geo.start, &ugeo->start);
+	if (ret)
+		ret = -EFAULT;
+
+	return ret;
+}
+
+static int compat_hdio_ioctl(struct inode *inode, struct file *file,
+		struct gendisk *disk, unsigned int cmd, unsigned long arg)
+{
+	mm_segment_t old_fs = get_fs();
+	unsigned long kval;
+	unsigned int __user *uvp;
+	int error;
+
+	set_fs(KERNEL_DS);
+	error = blkdev_driver_ioctl(inode, file, disk,
+				cmd, (unsigned long)(&kval));
+	set_fs(old_fs);
+
+	if (error == 0) {
+		uvp = compat_ptr(arg);
+		if (put_user(kval, uvp))
+			error = -EFAULT;
+	}
+	return error;
+}
+
 #define BLKBSZGET_32		_IOR(0x12, 112, int)
 #define BLKBSZSET_32		_IOW(0x12, 113, int)
 #define BLKGETSIZE64_32		_IOR(0x12, 114, int)
@@ -93,6 +149,18 @@ static int compat_blkdev_driver_ioctl(st
 	int ret;
 
 	switch (arg) {
+	case HDIO_GET_UNMASKINTR:
+	case HDIO_GET_MULTCOUNT:
+	case HDIO_GET_KEEPSETTINGS:
+	case HDIO_GET_32BIT:
+	case HDIO_GET_NOWERR:
+	case HDIO_GET_DMA:
+	case HDIO_GET_NICE:
+	case HDIO_GET_WCACHE:
+	case HDIO_GET_ACOUSTIC:
+	case HDIO_GET_ADDRESS:
+	case HDIO_GET_BUSSTATE:
+		return compat_hdio_ioctl(inode, file, disk, cmd, arg);
 	/*
 	 * No handler required for the ones below, we just need to
 	 * convert arg to a 64 bit pointer.
@@ -268,6 +336,8 @@ long compat_blkdev_ioctl(struct file *fi
 	struct gendisk *disk = bdev->bd_disk;
 
 	switch (cmd) {
+	case HDIO_GETGEO:
+		return compat_hdio_getgeo(disk, bdev, compat_ptr(arg));
 	case BLKFLSBUF:
 	case BLKROSET:
 	/*
Index: linux-2.6/fs/compat_ioctl.c
===================================================================
--- linux-2.6.orig/fs/compat_ioctl.c
+++ linux-2.6/fs/compat_ioctl.c
@@ -21,7 +21,6 @@
 #include <linux/if.h>
 #include <linux/if_bridge.h>
 #include <linux/slab.h>
-#include <linux/hdreg.h>
 #include <linux/raid/md.h>
 #include <linux/kd.h>
 #include <linux/dirent.h>
@@ -667,53 +666,6 @@ out:
 #endif
 
 #ifdef CONFIG_BLOCK
-struct hd_geometry32 {
-	unsigned char heads;
-	unsigned char sectors;
-	unsigned short cylinders;
-	u32 start;
-};
-                        
-static int hdio_getgeo(unsigned int fd, unsigned int cmd, unsigned long arg)
-{
-	mm_segment_t old_fs = get_fs();
-	struct hd_geometry geo;
-	struct hd_geometry32 __user *ugeo;
-	int err;
-	
-	set_fs (KERNEL_DS);
-	err = sys_ioctl(fd, HDIO_GETGEO, (unsigned long)&geo);
-	set_fs (old_fs);
-	ugeo = compat_ptr(arg);
-	if (!err) {
-		err = copy_to_user (ugeo, &geo, 4);
-		err |= __put_user (geo.start, &ugeo->start);
-		if (err)
-			err = -EFAULT;
-	}
-	return err;
-}
-
-static int hdio_ioctl_trans(unsigned int fd, unsigned int cmd, unsigned long arg)
-{
-	mm_segment_t old_fs = get_fs();
-	unsigned long kval;
-	unsigned int __user *uvp;
-	int error;
-
-	set_fs(KERNEL_DS);
-	error = sys_ioctl(fd, cmd, (long)&kval);
-	set_fs(old_fs);
-
-	if(error == 0) {
-		uvp = compat_ptr(arg);
-		if(put_user(kval, uvp))
-			error = -EFAULT;
-	}
-	return error;
-}
-
-
 typedef struct sg_io_hdr32 {
 	compat_int_t interface_id;	/* [i] 'S' for SCSI generic (required) */
 	compat_int_t dxfer_direction;	/* [i] data transfer direction  */
@@ -3208,19 +3160,7 @@ HANDLE_IOCTL(SIOCGSTAMP, do_siocgstamp)
 HANDLE_IOCTL(SIOCGSTAMPNS, do_siocgstampns)
 #endif
 #ifdef CONFIG_BLOCK
-HANDLE_IOCTL(HDIO_GETGEO, hdio_getgeo)
 HANDLE_IOCTL(BLKPG, blkpg_ioctl_trans)
-HANDLE_IOCTL(HDIO_GET_UNMASKINTR, hdio_ioctl_trans)
-HANDLE_IOCTL(HDIO_GET_MULTCOUNT, hdio_ioctl_trans)
-HANDLE_IOCTL(HDIO_GET_KEEPSETTINGS, hdio_ioctl_trans)
-HANDLE_IOCTL(HDIO_GET_32BIT, hdio_ioctl_trans)
-HANDLE_IOCTL(HDIO_GET_NOWERR, hdio_ioctl_trans)
-HANDLE_IOCTL(HDIO_GET_DMA, hdio_ioctl_trans)
-HANDLE_IOCTL(HDIO_GET_NICE, hdio_ioctl_trans)
-HANDLE_IOCTL(HDIO_GET_WCACHE, hdio_ioctl_trans)
-HANDLE_IOCTL(HDIO_GET_ACOUSTIC, hdio_ioctl_trans)
-HANDLE_IOCTL(HDIO_GET_ADDRESS, hdio_ioctl_trans)
-HANDLE_IOCTL(HDIO_GET_BUSSTATE, hdio_ioctl_trans)
 HANDLE_IOCTL(FDSETPRM32, fd_ioctl_trans)
 HANDLE_IOCTL(FDDEFPRM32, fd_ioctl_trans)
 HANDLE_IOCTL(FDGETPRM32, fd_ioctl_trans)

-- 

