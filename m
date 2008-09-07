Return-Path: <linux-kernel-owner+w=401wt.eu-S1757137AbYIGWWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757137AbYIGWWQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 18:22:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754285AbYIGWSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 18:18:21 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:58901 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755896AbYIGWSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 18:18:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=UvbFdxiTtGSo7mDJp7/23CziiJ71P3Nw38M1TE9qZ6nTBmL2UDJ6P/+U8u29YA7GTj
         +FxCuEbCWqHUqAHy3lFlWZS+wq1/DEMqETkaTSyRL+wWpS3B/kQv/cH/Uq7oxJIyQaOG
         rhQhRKGx4QS18j+yV+1ci2BYPssXjZZJSRyRc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 08 Sep 2008 00:16:08 +0200
Message-Id: <20080907221608.24285.33212.sendpatchset@localhost.localdomain>
In-Reply-To: <20080907221424.24285.81137.sendpatchset@localhost.localdomain>
References: <20080907221424.24285.81137.sendpatchset@localhost.localdomain>
Subject: [PATCH 15/18] ide-floppy: factor out generic disk handling code to ide-gd-floppy.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While at it:
- idefloppy_do_request() -> ide_floppy_do_request()
- idefloppy_end_request() -> ide_floppy_end_request()
- idefloppy_setup() -> ide_floppy_setup()

There should be no functional changes caused by this patch.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/Makefile        |    2 
 drivers/ide/ide-floppy.c    |  319 +-------------------------------------------
 drivers/ide/ide-floppy.h    |   19 ++
 drivers/ide/ide-gd-floppy.c |  298 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 327 insertions(+), 311 deletions(-)

Index: b/drivers/ide/Makefile
===================================================================
--- a/drivers/ide/Makefile
+++ b/drivers/ide/Makefile
@@ -39,7 +39,7 @@ obj-$(CONFIG_BLK_DEV_IDEPNP)		+= ide-pnp
 
 ide-disk_mod-y += ide-gd.o ide-disk.o ide-disk_ioctl.o
 ide-cd_mod-y += ide-cd.o ide-cd_ioctl.o ide-cd_verbose.o
-ide-floppy_mod-y += ide-floppy.o ide-floppy_ioctl.o
+ide-floppy_mod-y += ide-gd-floppy.o ide-floppy.o ide-floppy_ioctl.o
 
 ifeq ($(CONFIG_IDE_PROC_FS), y)
 	ide-disk_mod-y += ide-disk_proc.o
Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -15,12 +15,6 @@
  * Documentation/ide/ChangeLog.ide-floppy.1996-2002
  */
 
-#define DRV_NAME "ide-floppy"
-#define PFX DRV_NAME ": "
-
-#define IDEFLOPPY_VERSION "1.00"
-
-#include <linux/module.h>
 #include <linux/types.h>
 #include <linux/string.h>
 #include <linux/kernel.h>
@@ -49,19 +43,6 @@
 
 #include "ide-floppy.h"
 
-/* module parameters */
-static unsigned long debug_mask;
-module_param(debug_mask, ulong, 0644);
-
-/* define to see debug info */
-#define IDEFLOPPY_DEBUG_LOG	0
-
-#if IDEFLOPPY_DEBUG_LOG
-#define ide_debug_log(lvl, fmt, args...) __ide_debug_log(lvl, fmt, args)
-#else
-#define ide_debug_log(lvl, fmt, args...) do {} while (0)
-#endif
-
 /*
  * After each failed packet command we issue a request sense command and retry
  * the packet command IDEFLOPPY_MAX_PC_RETRIES times.
@@ -83,41 +64,11 @@ module_param(debug_mask, ulong, 0644);
 /* Error code returned in rq->errors to the higher part of the driver. */
 #define	IDEFLOPPY_ERROR_GENERAL		101
 
-static DEFINE_MUTEX(idefloppy_ref_mutex);
-
-static void idefloppy_cleanup_obj(struct kref *);
-
-static struct ide_floppy_obj *ide_floppy_get(struct gendisk *disk)
-{
-	struct ide_floppy_obj *floppy = NULL;
-
-	mutex_lock(&idefloppy_ref_mutex);
-	floppy = ide_drv_g(disk, ide_floppy_obj);
-	if (floppy) {
-		if (ide_device_get(floppy->drive))
-			floppy = NULL;
-		else
-			kref_get(&floppy->kref);
-	}
-	mutex_unlock(&idefloppy_ref_mutex);
-	return floppy;
-}
-
-static void ide_floppy_put(struct ide_floppy_obj *floppy)
-{
-	ide_drive_t *drive = floppy->drive;
-
-	mutex_lock(&idefloppy_ref_mutex);
-	kref_put(&floppy->kref, idefloppy_cleanup_obj);
-	ide_device_put(drive);
-	mutex_unlock(&idefloppy_ref_mutex);
-}
-
 /*
  * Used to finish servicing a request. For read/write requests, we will call
  * ide_end_request to pass to the next buffer.
  */
-static int idefloppy_end_request(ide_drive_t *drive, int uptodate, int nsecs)
+int ide_floppy_end_request(ide_drive_t *drive, int uptodate, int nsecs)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
 	struct request *rq = HWGROUP(drive)->rq;
@@ -161,7 +112,7 @@ static void idefloppy_update_buffers(ide
 	struct bio *bio = rq->bio;
 
 	while ((bio = rq->bio) != NULL)
-		idefloppy_end_request(drive, 1, 0);
+		ide_floppy_end_request(drive, 1, 0);
 }
 
 static void ide_floppy_callback(ide_drive_t *drive, int dsc)
@@ -200,7 +151,7 @@ static void ide_floppy_callback(ide_driv
 			       "Aborting request!\n");
 	}
 
-	idefloppy_end_request(drive, uptodate, 0);
+	ide_floppy_end_request(drive, uptodate, 0);
 }
 
 static void ide_floppy_report_error(idefloppy_floppy_t *floppy,
@@ -329,8 +280,8 @@ static void idefloppy_blockpc_cmd(ideflo
 	pc->req_xfer = pc->buf_size = rq->data_len;
 }
 
-static ide_startstop_t idefloppy_do_request(ide_drive_t *drive,
-		struct request *rq, sector_t block_s)
+ide_startstop_t ide_floppy_do_request(ide_drive_t *drive, struct request *rq,
+				      sector_t block_s)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
 	ide_hwif_t *hwif = drive->hwif;
@@ -353,7 +304,7 @@ static ide_startstop_t idefloppy_do_requ
 		else
 			printk(KERN_ERR PFX "%s: I/O error\n", drive->name);
 
-		idefloppy_end_request(drive, 0, 0);
+		ide_floppy_end_request(drive, 0, 0);
 		return ide_stopped;
 	}
 	if (blk_fs_request(rq)) {
@@ -361,7 +312,7 @@ static ide_startstop_t idefloppy_do_requ
 		    (rq->nr_sectors % floppy->bs_factor)) {
 			printk(KERN_ERR PFX "%s: unsupported r/w rq size\n",
 				drive->name);
-			idefloppy_end_request(drive, 0, 0);
+			ide_floppy_end_request(drive, 0, 0);
 			return ide_stopped;
 		}
 		pc = &floppy->queued_pc;
@@ -373,7 +324,7 @@ static ide_startstop_t idefloppy_do_requ
 		idefloppy_blockpc_cmd(floppy, pc, rq);
 	} else {
 		blk_dump_rq_flags(rq, PFX "unsupported command in queue");
-		idefloppy_end_request(drive, 0, 0);
+		ide_floppy_end_request(drive, 0, 0);
 		return ide_stopped;
 	}
 
@@ -455,7 +406,7 @@ static int ide_floppy_get_flexible_disk_
  * Determine if a media is present in the floppy drive, and if so, its LBA
  * capacity.
  */
-static int ide_floppy_get_capacity(ide_drive_t *drive)
+int ide_floppy_get_capacity(ide_drive_t *drive)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
 	struct gendisk *disk = floppy->disk;
@@ -554,12 +505,7 @@ static int ide_floppy_get_capacity(ide_d
 	return rc;
 }
 
-sector_t ide_floppy_capacity(ide_drive_t *drive)
-{
-	return drive->capacity64;
-}
-
-static void idefloppy_setup(ide_drive_t *drive)
+void ide_floppy_setup(ide_drive_t *drive)
 {
 	struct ide_floppy_obj *floppy = drive->driver_data;
 	u16 *id = drive->id;
@@ -601,248 +547,3 @@ static void idefloppy_setup(ide_drive_t 
 
 	drive->dev_flags |= IDE_DFLAG_ATTACH;
 }
-
-static void ide_floppy_remove(ide_drive_t *drive)
-{
-	idefloppy_floppy_t *floppy = drive->driver_data;
-	struct gendisk *g = floppy->disk;
-
-	ide_proc_unregister_driver(drive, floppy->driver);
-
-	del_gendisk(g);
-
-	ide_floppy_put(floppy);
-}
-
-static void idefloppy_cleanup_obj(struct kref *kref)
-{
-	struct ide_floppy_obj *floppy = to_ide_drv(kref, ide_floppy_obj);
-	ide_drive_t *drive = floppy->drive;
-	struct gendisk *g = floppy->disk;
-
-	drive->driver_data = NULL;
-	g->private_data = NULL;
-	put_disk(g);
-	kfree(floppy);
-}
-
-static int ide_floppy_probe(ide_drive_t *);
-
-static ide_driver_t idefloppy_driver = {
-	.gen_driver = {
-		.owner		= THIS_MODULE,
-		.name		= "ide-floppy",
-		.bus		= &ide_bus_type,
-	},
-	.probe			= ide_floppy_probe,
-	.remove			= ide_floppy_remove,
-	.version		= IDEFLOPPY_VERSION,
-	.do_request		= idefloppy_do_request,
-	.end_request		= idefloppy_end_request,
-	.error			= __ide_error,
-#ifdef CONFIG_IDE_PROC_FS
-	.proc			= ide_floppy_proc,
-	.settings		= ide_floppy_settings,
-#endif
-};
-
-static int idefloppy_open(struct inode *inode, struct file *filp)
-{
-	struct gendisk *disk = inode->i_bdev->bd_disk;
-	struct ide_floppy_obj *floppy;
-	ide_drive_t *drive;
-	int ret = 0;
-
-	floppy = ide_floppy_get(disk);
-	if (!floppy)
-		return -ENXIO;
-
-	drive = floppy->drive;
-
-	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
-
-	floppy->openers++;
-
-	if (floppy->openers == 1) {
-		drive->dev_flags &= ~IDE_DFLAG_FORMAT_IN_PROGRESS;
-		/* Just in case */
-
-		if (ide_do_test_unit_ready(drive, disk))
-			ide_do_start_stop(drive, disk, 1);
-
-		ret = ide_floppy_get_capacity(drive);
-
-		set_capacity(disk, ide_floppy_capacity(drive));
-
-		if (ret && (filp->f_flags & O_NDELAY) == 0) {
-		    /*
-		     * Allow O_NDELAY to open a drive without a disk, or with an
-		     * unreadable disk, so that we can get the format capacity
-		     * of the drive or begin the format - Sam
-		     */
-			ret = -EIO;
-			goto out_put_floppy;
-		}
-
-		if ((drive->dev_flags & IDE_DFLAG_WP) && (filp->f_mode & 2)) {
-			ret = -EROFS;
-			goto out_put_floppy;
-		}
-
-		ide_set_media_lock(drive, disk, 1);
-		drive->dev_flags |= IDE_DFLAG_MEDIA_CHANGED;
-		check_disk_change(inode->i_bdev);
-	} else if (drive->dev_flags & IDE_DFLAG_FORMAT_IN_PROGRESS) {
-		ret = -EBUSY;
-		goto out_put_floppy;
-	}
-	return 0;
-
-out_put_floppy:
-	floppy->openers--;
-	ide_floppy_put(floppy);
-	return ret;
-}
-
-static int idefloppy_release(struct inode *inode, struct file *filp)
-{
-	struct gendisk *disk = inode->i_bdev->bd_disk;
-	struct ide_floppy_obj *floppy = ide_drv_g(disk, ide_floppy_obj);
-	ide_drive_t *drive = floppy->drive;
-
-	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
-
-	if (floppy->openers == 1) {
-		ide_set_media_lock(drive, disk, 0);
-		drive->dev_flags &= ~IDE_DFLAG_FORMAT_IN_PROGRESS;
-	}
-
-	floppy->openers--;
-
-	ide_floppy_put(floppy);
-
-	return 0;
-}
-
-static int idefloppy_getgeo(struct block_device *bdev, struct hd_geometry *geo)
-{
-	struct ide_floppy_obj *floppy = ide_drv_g(bdev->bd_disk,
-						     ide_floppy_obj);
-	ide_drive_t *drive = floppy->drive;
-
-	geo->heads = drive->bios_head;
-	geo->sectors = drive->bios_sect;
-	geo->cylinders = (u16)drive->bios_cyl; /* truncate */
-	return 0;
-}
-
-static int idefloppy_media_changed(struct gendisk *disk)
-{
-	struct ide_floppy_obj *floppy = ide_drv_g(disk, ide_floppy_obj);
-	ide_drive_t *drive = floppy->drive;
-	int ret;
-
-	/* do not scan partitions twice if this is a removable device */
-	if (drive->dev_flags & IDE_DFLAG_ATTACH) {
-		drive->dev_flags &= ~IDE_DFLAG_ATTACH;
-		return 0;
-	}
-	ret = !!(drive->dev_flags & IDE_DFLAG_MEDIA_CHANGED);
-	drive->dev_flags &= ~IDE_DFLAG_MEDIA_CHANGED;
-	return ret;
-}
-
-static int idefloppy_revalidate_disk(struct gendisk *disk)
-{
-	struct ide_floppy_obj *floppy = ide_drv_g(disk, ide_floppy_obj);
-	set_capacity(disk, ide_floppy_capacity(floppy->drive));
-	return 0;
-}
-
-static struct block_device_operations idefloppy_ops = {
-	.owner			= THIS_MODULE,
-	.open			= idefloppy_open,
-	.release		= idefloppy_release,
-	.ioctl			= ide_floppy_ioctl,
-	.getgeo			= idefloppy_getgeo,
-	.media_changed		= idefloppy_media_changed,
-	.revalidate_disk	= idefloppy_revalidate_disk
-};
-
-static int ide_floppy_probe(ide_drive_t *drive)
-{
-	idefloppy_floppy_t *floppy;
-	struct gendisk *g;
-
-	if (!strstr("ide-floppy", drive->driver_req))
-		goto failed;
-
-	if (drive->media != ide_floppy)
-		goto failed;
-
-	if (!ide_check_atapi_device(drive, DRV_NAME)) {
-		printk(KERN_ERR PFX "%s: not supported by this version of "
-		       DRV_NAME "\n", drive->name);
-		goto failed;
-	}
-	floppy = kzalloc(sizeof(idefloppy_floppy_t), GFP_KERNEL);
-	if (!floppy) {
-		printk(KERN_ERR PFX "%s: Can't allocate a floppy structure\n",
-		       drive->name);
-		goto failed;
-	}
-
-	g = alloc_disk_node(1 << PARTN_BITS, hwif_to_node(drive->hwif));
-	if (!g)
-		goto out_free_floppy;
-
-	ide_init_disk(g, drive);
-
-	kref_init(&floppy->kref);
-
-	floppy->drive = drive;
-	floppy->driver = &idefloppy_driver;
-	floppy->disk = g;
-
-	g->private_data = &floppy->driver;
-
-	drive->driver_data = floppy;
-
-	drive->debug_mask = debug_mask;
-
-	idefloppy_setup(drive);
-
-	set_capacity(g, ide_floppy_capacity(drive));
-
-	g->minors = 1 << PARTN_BITS;
-	g->driverfs_dev = &drive->gendev;
-	if (drive->dev_flags & IDE_DFLAG_REMOVABLE)
-		g->flags = GENHD_FL_REMOVABLE;
-	g->fops = &idefloppy_ops;
-	add_disk(g);
-	return 0;
-
-out_free_floppy:
-	kfree(floppy);
-failed:
-	return -ENODEV;
-}
-
-static void __exit idefloppy_exit(void)
-{
-	driver_unregister(&idefloppy_driver.gen_driver);
-}
-
-static int __init idefloppy_init(void)
-{
-	printk(KERN_INFO DRV_NAME " driver " IDEFLOPPY_VERSION "\n");
-	return driver_register(&idefloppy_driver.gen_driver);
-}
-
-MODULE_ALIAS("ide:*m-floppy*");
-MODULE_ALIAS("ide-floppy");
-module_init(idefloppy_init);
-module_exit(idefloppy_exit);
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("ATAPI FLOPPY Driver");
-
Index: b/drivers/ide/ide-floppy.h
===================================================================
--- a/drivers/ide/ide-floppy.h
+++ b/drivers/ide/ide-floppy.h
@@ -1,6 +1,18 @@
 #ifndef __IDE_FLOPPY_H
 #define __IDE_FLOPPY_H
 
+#define DRV_NAME "ide-floppy"
+#define PFX DRV_NAME ": "
+
+/* define to see debug info */
+#define IDEFLOPPY_DEBUG_LOG	0
+
+#if IDEFLOPPY_DEBUG_LOG
+#define ide_debug_log(lvl, fmt, args...) __ide_debug_log(lvl, fmt, args)
+#else
+#define ide_debug_log(lvl, fmt, args...) do {} while (0)
+#endif
+
 /*
  * Most of our global data which we need to save even as we leave the driver
  * due to an interrupt or a timer event is stored in a variable of type
@@ -45,10 +57,15 @@ typedef struct ide_floppy_obj {
 #define	IDEFLOPPY_IOCTL_FORMAT_START		0x4602
 #define IDEFLOPPY_IOCTL_FORMAT_GET_PROGRESS	0x4603
 
+sector_t ide_floppy_capacity(ide_drive_t *);
+
 /* ide-floppy.c */
 void ide_floppy_create_mode_sense_cmd(struct ide_atapi_pc *, u8);
 void ide_floppy_create_read_capacity_cmd(struct ide_atapi_pc *);
-sector_t ide_floppy_capacity(ide_drive_t *);
+int ide_floppy_get_capacity(ide_drive_t *);
+void ide_floppy_setup(ide_drive_t *);
+ide_startstop_t ide_floppy_do_request(ide_drive_t *, struct request *, sector_t);
+int ide_floppy_end_request(ide_drive_t *, int, int);
 
 /* ide-floppy_ioctl.c */
 int ide_floppy_ioctl(struct inode *, struct file *, unsigned, unsigned long);
Index: b/drivers/ide/ide-gd-floppy.c
===================================================================
--- /dev/null
+++ b/drivers/ide/ide-gd-floppy.c
@@ -0,0 +1,298 @@
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/string.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/genhd.h>
+#include <linux/mutex.h>
+#include <linux/ide.h>
+#include <linux/hdreg.h>
+
+#include "ide-floppy.h"
+
+#define IDEFLOPPY_VERSION "1.00"
+
+/* module parameters */
+static unsigned long debug_mask;
+module_param(debug_mask, ulong, 0644);
+
+static DEFINE_MUTEX(idefloppy_ref_mutex);
+
+static void idefloppy_cleanup_obj(struct kref *);
+
+static struct ide_floppy_obj *ide_floppy_get(struct gendisk *disk)
+{
+	struct ide_floppy_obj *floppy = NULL;
+
+	mutex_lock(&idefloppy_ref_mutex);
+	floppy = ide_drv_g(disk, ide_floppy_obj);
+	if (floppy) {
+		if (ide_device_get(floppy->drive))
+			floppy = NULL;
+		else
+			kref_get(&floppy->kref);
+	}
+	mutex_unlock(&idefloppy_ref_mutex);
+	return floppy;
+}
+
+static void ide_floppy_put(struct ide_floppy_obj *floppy)
+{
+	ide_drive_t *drive = floppy->drive;
+
+	mutex_lock(&idefloppy_ref_mutex);
+	kref_put(&floppy->kref, idefloppy_cleanup_obj);
+	ide_device_put(drive);
+	mutex_unlock(&idefloppy_ref_mutex);
+}
+
+sector_t ide_floppy_capacity(ide_drive_t *drive)
+{
+	return drive->capacity64;
+}
+
+static void ide_floppy_remove(ide_drive_t *drive)
+{
+	idefloppy_floppy_t *floppy = drive->driver_data;
+	struct gendisk *g = floppy->disk;
+
+	ide_proc_unregister_driver(drive, floppy->driver);
+
+	del_gendisk(g);
+
+	ide_floppy_put(floppy);
+}
+
+static void idefloppy_cleanup_obj(struct kref *kref)
+{
+	struct ide_floppy_obj *floppy = to_ide_drv(kref, ide_floppy_obj);
+	ide_drive_t *drive = floppy->drive;
+	struct gendisk *g = floppy->disk;
+
+	drive->driver_data = NULL;
+	g->private_data = NULL;
+	put_disk(g);
+	kfree(floppy);
+}
+
+static int ide_floppy_probe(ide_drive_t *);
+
+static ide_driver_t idefloppy_driver = {
+	.gen_driver = {
+		.owner		= THIS_MODULE,
+		.name		= "ide-floppy",
+		.bus		= &ide_bus_type,
+	},
+	.probe			= ide_floppy_probe,
+	.remove			= ide_floppy_remove,
+	.version		= IDEFLOPPY_VERSION,
+	.do_request		= ide_floppy_do_request,
+	.end_request		= ide_floppy_end_request,
+	.error			= __ide_error,
+#ifdef CONFIG_IDE_PROC_FS
+	.proc			= ide_floppy_proc,
+	.settings		= ide_floppy_settings,
+#endif
+};
+
+static int idefloppy_open(struct inode *inode, struct file *filp)
+{
+	struct gendisk *disk = inode->i_bdev->bd_disk;
+	struct ide_floppy_obj *floppy;
+	ide_drive_t *drive;
+	int ret = 0;
+
+	floppy = ide_floppy_get(disk);
+	if (!floppy)
+		return -ENXIO;
+
+	drive = floppy->drive;
+
+	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
+
+	floppy->openers++;
+
+	if (floppy->openers == 1) {
+		drive->dev_flags &= ~IDE_DFLAG_FORMAT_IN_PROGRESS;
+		/* Just in case */
+
+		if (ide_do_test_unit_ready(drive, disk))
+			ide_do_start_stop(drive, disk, 1);
+
+		ret = ide_floppy_get_capacity(drive);
+
+		set_capacity(disk, ide_floppy_capacity(drive));
+
+		if (ret && (filp->f_flags & O_NDELAY) == 0) {
+		    /*
+		     * Allow O_NDELAY to open a drive without a disk, or with an
+		     * unreadable disk, so that we can get the format capacity
+		     * of the drive or begin the format - Sam
+		     */
+			ret = -EIO;
+			goto out_put_floppy;
+		}
+
+		if ((drive->dev_flags & IDE_DFLAG_WP) && (filp->f_mode & 2)) {
+			ret = -EROFS;
+			goto out_put_floppy;
+		}
+
+		ide_set_media_lock(drive, disk, 1);
+		drive->dev_flags |= IDE_DFLAG_MEDIA_CHANGED;
+		check_disk_change(inode->i_bdev);
+	} else if (drive->dev_flags & IDE_DFLAG_FORMAT_IN_PROGRESS) {
+		ret = -EBUSY;
+		goto out_put_floppy;
+	}
+	return 0;
+
+out_put_floppy:
+	floppy->openers--;
+	ide_floppy_put(floppy);
+	return ret;
+}
+
+static int idefloppy_release(struct inode *inode, struct file *filp)
+{
+	struct gendisk *disk = inode->i_bdev->bd_disk;
+	struct ide_floppy_obj *floppy = ide_drv_g(disk, ide_floppy_obj);
+	ide_drive_t *drive = floppy->drive;
+
+	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
+
+	if (floppy->openers == 1) {
+		ide_set_media_lock(drive, disk, 0);
+		drive->dev_flags &= ~IDE_DFLAG_FORMAT_IN_PROGRESS;
+	}
+
+	floppy->openers--;
+
+	ide_floppy_put(floppy);
+
+	return 0;
+}
+
+static int idefloppy_getgeo(struct block_device *bdev, struct hd_geometry *geo)
+{
+	struct ide_floppy_obj *floppy = ide_drv_g(bdev->bd_disk,
+						     ide_floppy_obj);
+	ide_drive_t *drive = floppy->drive;
+
+	geo->heads = drive->bios_head;
+	geo->sectors = drive->bios_sect;
+	geo->cylinders = (u16)drive->bios_cyl; /* truncate */
+	return 0;
+}
+
+static int idefloppy_media_changed(struct gendisk *disk)
+{
+	struct ide_floppy_obj *floppy = ide_drv_g(disk, ide_floppy_obj);
+	ide_drive_t *drive = floppy->drive;
+	int ret;
+
+	/* do not scan partitions twice if this is a removable device */
+	if (drive->dev_flags & IDE_DFLAG_ATTACH) {
+		drive->dev_flags &= ~IDE_DFLAG_ATTACH;
+		return 0;
+	}
+
+	ret = !!(drive->dev_flags & IDE_DFLAG_MEDIA_CHANGED);
+	drive->dev_flags &= ~IDE_DFLAG_MEDIA_CHANGED;
+
+	return ret;
+}
+
+static int idefloppy_revalidate_disk(struct gendisk *disk)
+{
+	struct ide_floppy_obj *floppy = ide_drv_g(disk, ide_floppy_obj);
+	set_capacity(disk, ide_floppy_capacity(floppy->drive));
+	return 0;
+}
+
+static struct block_device_operations idefloppy_ops = {
+	.owner			= THIS_MODULE,
+	.open			= idefloppy_open,
+	.release		= idefloppy_release,
+	.ioctl			= ide_floppy_ioctl,
+	.getgeo			= idefloppy_getgeo,
+	.media_changed		= idefloppy_media_changed,
+	.revalidate_disk	= idefloppy_revalidate_disk
+};
+
+static int ide_floppy_probe(ide_drive_t *drive)
+{
+	idefloppy_floppy_t *floppy;
+	struct gendisk *g;
+
+	if (!strstr("ide-floppy", drive->driver_req))
+		goto failed;
+
+	if (drive->media != ide_floppy)
+		goto failed;
+
+	if (!ide_check_atapi_device(drive, DRV_NAME)) {
+		printk(KERN_ERR PFX "%s: not supported by this version of "
+		       DRV_NAME "\n", drive->name);
+		goto failed;
+	}
+	floppy = kzalloc(sizeof(idefloppy_floppy_t), GFP_KERNEL);
+	if (!floppy) {
+		printk(KERN_ERR PFX "%s: Can't allocate a floppy structure\n",
+		       drive->name);
+		goto failed;
+	}
+
+	g = alloc_disk_node(1 << PARTN_BITS, hwif_to_node(drive->hwif));
+	if (!g)
+		goto out_free_floppy;
+
+	ide_init_disk(g, drive);
+
+	kref_init(&floppy->kref);
+
+	floppy->drive = drive;
+	floppy->driver = &idefloppy_driver;
+	floppy->disk = g;
+
+	g->private_data = &floppy->driver;
+
+	drive->driver_data = floppy;
+
+	drive->debug_mask = debug_mask;
+
+	ide_floppy_setup(drive);
+
+	set_capacity(g, ide_floppy_capacity(drive));
+
+	g->minors = 1 << PARTN_BITS;
+	g->driverfs_dev = &drive->gendev;
+	if (drive->dev_flags & IDE_DFLAG_REMOVABLE)
+		g->flags = GENHD_FL_REMOVABLE;
+	g->fops = &idefloppy_ops;
+	add_disk(g);
+	return 0;
+
+out_free_floppy:
+	kfree(floppy);
+failed:
+	return -ENODEV;
+}
+
+static int __init idefloppy_init(void)
+{
+	printk(KERN_INFO DRV_NAME " driver " IDEFLOPPY_VERSION "\n");
+	return driver_register(&idefloppy_driver.gen_driver);
+}
+
+static void __exit idefloppy_exit(void)
+{
+	driver_unregister(&idefloppy_driver.gen_driver);
+}
+
+MODULE_ALIAS("ide:*m-floppy*");
+MODULE_ALIAS("ide-floppy");
+module_init(idefloppy_init);
+module_exit(idefloppy_exit);
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("ATAPI FLOPPY Driver");
