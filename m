Return-Path: <linux-kernel-owner+w=401wt.eu-S1755424AbYHSSne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424AbYHSSne (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 14:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752655AbYHSSm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 14:42:26 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:48055 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755515AbYHSSmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 14:42:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=V7WcCGS5tgOjl9VWhGpRNHB+syIU/sfosE2GutPYSFcit7Y0v68cPl/EL8zLX2/Nbo
         K71CoMJm+Upwy409IcFUZ5AJvP8AytJwitgO0cj4grI4uFaSaRac3q9o3V1sbPTC15gt
         dCZjIS0lC0elSgdaq6V6gKwRvc56zkD6AXcdQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 19 Aug 2008 20:40:03 +0200
Message-Id: <20080819184003.16469.39090.sendpatchset@localhost.localdomain>
In-Reply-To: <20080819183934.16469.69799.sendpatchset@localhost.localdomain>
References: <20080819183934.16469.69799.sendpatchset@localhost.localdomain>
Subject: [PATCH 5/6] ide-disk: move all ioctl handling to ide-disk_ioctl.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While at it:
- idedisk_ioctl() -> ide_disk_ioctl()

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/Makefile         |    3 +-
 drivers/ide/ide-disk.c       |   48 +++++++------------------------------------
 drivers/ide/ide-disk.h       |   25 ++++++++++++++++++++++
 drivers/ide/ide-disk_ioctl.c |   29 +++++++++++++++++++++++++
 drivers/ide/ide.c            |   11 +++------
 include/linux/ide.h          |    7 ++++--
 6 files changed, 73 insertions(+), 50 deletions(-)

Index: b/drivers/ide/Makefile
===================================================================
--- a/drivers/ide/Makefile
+++ b/drivers/ide/Makefile
@@ -36,10 +36,11 @@ obj-$(CONFIG_IDE_H8300)			+= h8300/
 obj-$(CONFIG_IDE_GENERIC)		+= ide-generic.o
 obj-$(CONFIG_BLK_DEV_IDEPNP)		+= ide-pnp.o
 
+ide-disk_mod-y += ide-disk.o ide-disk_ioctl.o
 ide-cd_mod-y += ide-cd.o ide-cd_ioctl.o ide-cd_verbose.o
 ide-floppy_mod-y += ide-floppy.o ide-floppy_ioctl.o ide-floppy_proc.o
 
-obj-$(CONFIG_BLK_DEV_IDEDISK)		+= ide-disk.o
+obj-$(CONFIG_BLK_DEV_IDEDISK)		+= ide-disk_mod.o
 obj-$(CONFIG_BLK_DEV_IDECD)		+= ide-cd_mod.o
 obj-$(CONFIG_BLK_DEV_IDEFLOPPY)		+= ide-floppy_mod.o
 obj-$(CONFIG_BLK_DEV_IDETAPE)		+= ide-tape.o
Index: b/drivers/ide/ide-disk.c
===================================================================
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -39,21 +39,12 @@
 #include <asm/io.h>
 #include <asm/div64.h>
 
-struct ide_disk_obj {
-	ide_drive_t	*drive;
-	ide_driver_t	*driver;
-	struct gendisk	*disk;
-	struct kref	kref;
-	unsigned int	openers;	/* protected by BKL for now */
-};
+#include "ide-disk.h"
 
 static DEFINE_MUTEX(idedisk_ref_mutex);
 
 #define to_ide_disk(obj) container_of(obj, struct ide_disk_obj, kref)
 
-#define ide_disk_g(disk) \
-	container_of((disk)->private_data, struct ide_disk_obj, driver)
-
 static void ide_disk_release(struct kref *);
 
 static struct ide_disk_obj *ide_disk_get(struct gendisk *disk)
@@ -716,12 +707,12 @@ static int set_addressing(ide_drive_t *d
 	return 0;
 }
 
-ide_devset_rw(acoustic, acoustic);
-ide_devset_rw(address, addressing);
-ide_devset_rw(multcount, multcount);
-ide_devset_rw(wcache, wcache);
+ide_ext_devset_rw(acoustic, acoustic);
+ide_ext_devset_rw(address, addressing);
+ide_ext_devset_rw(multcount, multcount);
+ide_ext_devset_rw(wcache, wcache);
 
-ide_devset_rw_sync(nowerr, nowerr);
+ide_ext_devset_rw_sync(nowerr, nowerr);
 
 #ifdef CONFIG_IDE_PROC_FS
 ide_devset_rw_field(bios_cyl, bios_cyl);
@@ -1019,30 +1010,6 @@ static int idedisk_getgeo(struct block_d
 	return 0;
 }
 
-static const struct ide_ioctl_devset ide_disk_ioctl_settings[] = {
-{ HDIO_GET_ADDRESS,	HDIO_SET_ADDRESS,   &ide_devset_address   },
-{ HDIO_GET_MULTCOUNT,	HDIO_SET_MULTCOUNT, &ide_devset_multcount },
-{ HDIO_GET_NOWERR,	HDIO_SET_NOWERR,    &ide_devset_nowerr	  },
-{ HDIO_GET_WCACHE,	HDIO_SET_WCACHE,    &ide_devset_wcache	  },
-{ HDIO_GET_ACOUSTIC,	HDIO_SET_ACOUSTIC,  &ide_devset_acoustic  },
-{ 0 }
-};
-
-static int idedisk_ioctl(struct inode *inode, struct file *file,
-			unsigned int cmd, unsigned long arg)
-{
-	struct block_device *bdev = inode->i_bdev;
-	struct ide_disk_obj *idkp = ide_disk_g(bdev->bd_disk);
-	ide_drive_t *drive = idkp->drive;
-	int err;
-
-	err = ide_setting_ioctl(drive, bdev, cmd, arg, ide_disk_ioctl_settings);
-	if (err != -EOPNOTSUPP)
-		return err;
-
-	return generic_ide_ioctl(drive, file, bdev, cmd, arg);
-}
-
 static int idedisk_media_changed(struct gendisk *disk)
 {
 	struct ide_disk_obj *idkp = ide_disk_g(disk);
@@ -1069,7 +1036,7 @@ static struct block_device_operations id
 	.owner			= THIS_MODULE,
 	.open			= idedisk_open,
 	.release		= idedisk_release,
-	.ioctl			= idedisk_ioctl,
+	.ioctl			= ide_disk_ioctl,
 	.getgeo			= idedisk_getgeo,
 	.media_changed		= idedisk_media_changed,
 	.revalidate_disk	= idedisk_revalidate_disk
@@ -1145,6 +1112,7 @@ static int __init idedisk_init(void)
 }
 
 MODULE_ALIAS("ide:*m-disk*");
+MODULE_ALIAS("ide-disk");
 module_init(idedisk_init);
 module_exit(idedisk_exit);
 MODULE_LICENSE("GPL");
Index: b/drivers/ide/ide-disk.h
===================================================================
--- /dev/null
+++ b/drivers/ide/ide-disk.h
@@ -0,0 +1,25 @@
+#ifndef __IDE_DISK_H
+#define __IDE_DISK_H
+
+struct ide_disk_obj {
+	ide_drive_t	*drive;
+	ide_driver_t	*driver;
+	struct gendisk	*disk;
+	struct kref	kref;
+	unsigned int	openers;	/* protected by BKL for now */
+};
+
+#define ide_disk_g(disk) \
+	container_of((disk)->private_data, struct ide_disk_obj, driver)
+
+/* ide-disk.c */
+ide_decl_devset(address);
+ide_decl_devset(multcount);
+ide_decl_devset(nowerr);
+ide_decl_devset(wcache);
+ide_decl_devset(acoustic);
+
+/* ide-disk_ioctl.c */
+int ide_disk_ioctl(struct inode *, struct file *, unsigned int, unsigned long);
+
+#endif /* __IDE_DISK_H */
Index: b/drivers/ide/ide-disk_ioctl.c
===================================================================
--- /dev/null
+++ b/drivers/ide/ide-disk_ioctl.c
@@ -0,0 +1,29 @@
+#include <linux/kernel.h>
+#include <linux/ide.h>
+#include <linux/hdreg.h>
+
+#include "ide-disk.h"
+
+static const struct ide_ioctl_devset ide_disk_ioctl_settings[] = {
+{ HDIO_GET_ADDRESS,	HDIO_SET_ADDRESS,   &ide_devset_address   },
+{ HDIO_GET_MULTCOUNT,	HDIO_SET_MULTCOUNT, &ide_devset_multcount },
+{ HDIO_GET_NOWERR,	HDIO_SET_NOWERR,    &ide_devset_nowerr	  },
+{ HDIO_GET_WCACHE,	HDIO_SET_WCACHE,    &ide_devset_wcache	  },
+{ HDIO_GET_ACOUSTIC,	HDIO_SET_ACOUSTIC,  &ide_devset_acoustic  },
+{ 0 }
+};
+
+int ide_disk_ioctl(struct inode *inode, struct file *file,
+		   unsigned int cmd, unsigned long arg)
+{
+	struct block_device *bdev = inode->i_bdev;
+	struct ide_disk_obj *idkp = ide_disk_g(bdev->bd_disk);
+	ide_drive_t *drive = idkp->drive;
+	int err;
+
+	err = ide_setting_ioctl(drive, bdev, cmd, arg, ide_disk_ioctl_settings);
+	if (err != -EOPNOTSUPP)
+		return err;
+
+	return generic_ide_ioctl(drive, file, bdev, cmd, arg);
+}
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -392,13 +392,10 @@ static int set_unmaskirq(ide_drive_t *dr
 	return 0;
 }
 
-#define ide_gen_devset_rw(_name, _func) \
-__IDE_DEVSET(_name, DS_SYNC, get_##_func, set_##_func)
-
-ide_gen_devset_rw(io_32bit, io_32bit);
-ide_gen_devset_rw(keepsettings, ksettings);
-ide_gen_devset_rw(unmaskirq, unmaskirq);
-ide_gen_devset_rw(using_dma, using_dma);
+ide_ext_devset_rw_sync(io_32bit, io_32bit);
+ide_ext_devset_rw_sync(keepsettings, ksettings);
+ide_ext_devset_rw_sync(unmaskirq, unmaskirq);
+ide_ext_devset_rw_sync(using_dma, using_dma);
 __IDE_DEVSET(pio_mode, DS_SYNC, NULL, set_pio_mode);
 
 static int generic_ide_suspend(struct device *dev, pm_message_t mesg)
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -942,8 +942,11 @@ IDE_DEVSET(_name, 0, get_##_func, set_##
 #define ide_devset_w(_name, _func) \
 IDE_DEVSET(_name, 0, NULL, set_##_func)
 
-#define ide_devset_rw_sync(_name, _func) \
-IDE_DEVSET(_name, DS_SYNC, get_##_func, set_##_func)
+#define ide_ext_devset_rw(_name, _func) \
+__IDE_DEVSET(_name, 0, get_##_func, set_##_func)
+
+#define ide_ext_devset_rw_sync(_name, _func) \
+__IDE_DEVSET(_name, DS_SYNC, get_##_func, set_##_func)
 
 #define ide_decl_devset(_name) \
 extern const struct ide_devset ide_devset_##_name
