Return-Path: <linux-kernel-owner+w=401wt.eu-S1756905AbYIGWVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905AbYIGWVh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 18:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754124AbYIGWSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 18:18:07 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:64118 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756159AbYIGWSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 18:18:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=CC6o6LxUEIBYUQZtMelsRQQBNR+d7KQygBVTSRln6PBAV+G12o1du+eqsY2UGBIC9e
         LAOaO3gaLO9hNeWHVapvBidmKmoSfoctIqqAVgpGb9HD7IK8zxhM8KtHpYRp96Uc79vR
         Kts5NTdylg3X2hu9LBbh8EgiuukeZSdOFqvOA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 08 Sep 2008 00:15:54 +0200
Message-Id: <20080907221554.24285.88995.sendpatchset@localhost.localdomain>
In-Reply-To: <20080907221424.24285.81137.sendpatchset@localhost.localdomain>
References: <20080907221424.24285.81137.sendpatchset@localhost.localdomain>
Subject: [PATCH 13/18] ide-disk: factor out generic disk handling code to ide-gd.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While at it:
- IDEDISK_VERSION -> IDE_GD_VERSION
- ide_cacheflush_p() -> ide_disk_flush()
- init_idedisk_capacity() -> ide_disk_init_capacity()
- idedisk_set_doorlock() -> ide_disk_set_doorlock()
- idedisk_setup() -> ide_disk_setup()

- ide_disk_capacity() -> ide_gd_capacity()
- ide_disk_remove() -> ide_gd_remove()
- ide_disk_probe() -> ide_gd_probe()
- ide_disk_resume() -> ide_gd_resume()
- ide_device_shutdown() -> ide_gd_shutdown()
- idedisk_driver -> ide_gd_driver
- idedisk_open() -> ide_gd_open()
- idedisk_release() -> ide_gd_release()
- idedisk_getgeo() -> ide_gd_getgeo()
- idedisk_media_changed() -> ide_gd_media_changed()
- idedisk_revalidate_disk() -> ide_gd_revalidate_disk()
- idedisk_ops -> ide_gd_ops
- idedisk_init() -> ide_gd_init()
- idedisk_exit() -> ide_gd_exit()

There should be no functional changes caused by this patch.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/Makefile        |    2 
 drivers/ide/ide-disk.c      |  299 +-------------------------------------------
 drivers/ide/ide-disk.h      |    8 +
 drivers/ide/ide-disk_proc.c |    2 
 drivers/ide/ide-gd.c        |  289 ++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 307 insertions(+), 293 deletions(-)

Index: b/drivers/ide/Makefile
===================================================================
--- a/drivers/ide/Makefile
+++ b/drivers/ide/Makefile
@@ -37,7 +37,7 @@ obj-$(CONFIG_IDE_H8300)			+= h8300/
 obj-$(CONFIG_IDE_GENERIC)		+= ide-generic.o
 obj-$(CONFIG_BLK_DEV_IDEPNP)		+= ide-pnp.o
 
-ide-disk_mod-y += ide-disk.o ide-disk_ioctl.o
+ide-disk_mod-y += ide-gd.o ide-disk.o ide-disk_ioctl.o
 ide-cd_mod-y += ide-cd.o ide-cd_ioctl.o ide-cd_verbose.o
 ide-floppy_mod-y += ide-floppy.o ide-floppy_ioctl.o
 
Index: b/drivers/ide/ide-disk.c
===================================================================
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -14,9 +14,6 @@
  * This is the IDE/ATA disk driver, as evolved from hd.c and ide.c.
  */
 
-#define IDEDISK_VERSION	"1.18"
-
-#include <linux/module.h>
 #include <linux/types.h>
 #include <linux/string.h>
 #include <linux/kernel.h>
@@ -41,36 +38,6 @@
 
 #include "ide-disk.h"
 
-static DEFINE_MUTEX(idedisk_ref_mutex);
-
-static void ide_disk_release(struct kref *);
-
-static struct ide_disk_obj *ide_disk_get(struct gendisk *disk)
-{
-	struct ide_disk_obj *idkp = NULL;
-
-	mutex_lock(&idedisk_ref_mutex);
-	idkp = ide_drv_g(disk, ide_disk_obj);
-	if (idkp) {
-		if (ide_device_get(idkp->drive))
-			idkp = NULL;
-		else
-			kref_get(&idkp->kref);
-	}
-	mutex_unlock(&idedisk_ref_mutex);
-	return idkp;
-}
-
-static void ide_disk_put(struct ide_disk_obj *idkp)
-{
-	ide_drive_t *drive = idkp->drive;
-
-	mutex_lock(&idedisk_ref_mutex);
-	kref_put(&idkp->kref, ide_disk_release);
-	ide_device_put(drive);
-	mutex_unlock(&idedisk_ref_mutex);
-}
-
 static const u8 ide_rw_cmds[] = {
 	ATA_CMD_READ_MULTI,
 	ATA_CMD_WRITE_MULTI,
@@ -217,8 +184,8 @@ static ide_startstop_t __ide_do_rw_disk(
  * 1073741822 == 549756 MB or 48bit addressing fake drive
  */
 
-static ide_startstop_t ide_do_rw_disk(ide_drive_t *drive, struct request *rq,
-				      sector_t block)
+ide_startstop_t ide_do_rw_disk(ide_drive_t *drive, struct request *rq,
+			       sector_t block)
 {
 	ide_hwif_t *hwif = HWIF(drive);
 
@@ -366,7 +333,7 @@ static void idedisk_check_hpa(ide_drive_
 	}
 }
 
-static void init_idedisk_capacity(ide_drive_t *drive)
+void ide_disk_init_capacity(ide_drive_t *drive)
 {
 	u16 *id = drive->id;
 	int lba;
@@ -417,11 +384,6 @@ static void init_idedisk_capacity(ide_dr
 	}
 }
 
-sector_t ide_disk_capacity(ide_drive_t *drive)
-{
-	return drive->capacity64;
-}
-
 static void idedisk_prepare_flush(struct request_queue *q, struct request *rq)
 {
 	ide_drive_t *drive = q->queuedata;
@@ -520,7 +482,7 @@ static void update_ordered(ide_drive_t *
 		 * time we have trimmed the drive capacity if LBA48 is
 		 * not available so we don't need to recheck that.
 		 */
-		capacity = ide_disk_capacity(drive);
+		capacity = ide_gd_capacity(drive);
 		barrier = ata_id_flush_enabled(id) &&
 			(drive->dev_flags & IDE_DFLAG_NOFLUSH) == 0 &&
 			((drive->dev_flags & IDE_DFLAG_LBA48) == 0 ||
@@ -628,7 +590,7 @@ ide_ext_devset_rw(wcache, wcache);
 
 ide_ext_devset_rw_sync(nowerr, nowerr);
 
-static void idedisk_setup(ide_drive_t *drive)
+void ide_disk_setup(ide_drive_t *drive)
 {
 	struct ide_disk_obj *idkp = drive->driver_data;
 	ide_hwif_t *hwif = drive->hwif;
@@ -664,13 +626,13 @@ static void idedisk_setup(ide_drive_t *d
 			 drive->queue->max_sectors / 2);
 
 	/* calculate drive capacity, and select LBA if possible */
-	init_idedisk_capacity(drive);
+	ide_disk_init_capacity(drive);
 
 	/*
 	 * if possible, give fdisk access to more of the drive,
 	 * by correcting bios_cyls:
 	 */
-	capacity = ide_disk_capacity(drive);
+	capacity = ide_gd_capacity(drive);
 
 	if ((drive->dev_flags & IDE_DFLAG_FORCED_GEOM) == 0) {
 		if (ata_id_lba48_enabled(drive->id)) {
@@ -720,7 +682,7 @@ static void idedisk_setup(ide_drive_t *d
 		drive->dev_flags |= IDE_DFLAG_ATTACH;
 }
 
-static void ide_cacheflush_p(ide_drive_t *drive)
+void ide_disk_flush(ide_drive_t *drive)
 {
 	if (ata_id_flush_enabled(drive->id) == 0 ||
 	    (drive->dev_flags & IDE_DFLAG_WCACHE) == 0)
@@ -730,93 +692,7 @@ static void ide_cacheflush_p(ide_drive_t
 		printk(KERN_INFO "%s: wcache flush failed!\n", drive->name);
 }
 
-static void ide_disk_remove(ide_drive_t *drive)
-{
-	struct ide_disk_obj *idkp = drive->driver_data;
-	struct gendisk *g = idkp->disk;
-
-	ide_proc_unregister_driver(drive, idkp->driver);
-
-	del_gendisk(g);
-
-	ide_cacheflush_p(drive);
-
-	ide_disk_put(idkp);
-}
-
-static void ide_disk_release(struct kref *kref)
-{
-	struct ide_disk_obj *idkp = to_ide_drv(kref, ide_disk_obj);
-	ide_drive_t *drive = idkp->drive;
-	struct gendisk *g = idkp->disk;
-
-	drive->driver_data = NULL;
-	g->private_data = NULL;
-	put_disk(g);
-	kfree(idkp);
-}
-
-static int ide_disk_probe(ide_drive_t *drive);
-
-/*
- * On HPA drives the capacity needs to be
- * reinitilized on resume otherwise the disk
- * can not be used and a hard reset is required
- */
-static void ide_disk_resume(ide_drive_t *drive)
-{
-	if (ata_id_hpa_enabled(drive->id))
-		init_idedisk_capacity(drive);
-}
-
-static void ide_device_shutdown(ide_drive_t *drive)
-{
-#ifdef	CONFIG_ALPHA
-	/* On Alpha, halt(8) doesn't actually turn the machine off,
-	   it puts you into the sort of firmware monitor. Typically,
-	   it's used to boot another kernel image, so it's not much
-	   different from reboot(8). Therefore, we don't need to
-	   spin down the disk in this case, especially since Alpha
-	   firmware doesn't handle disks in standby mode properly.
-	   On the other hand, it's reasonably safe to turn the power
-	   off when the shutdown process reaches the firmware prompt,
-	   as the firmware initialization takes rather long time -
-	   at least 10 seconds, which should be sufficient for
-	   the disk to expire its write cache. */
-	if (system_state != SYSTEM_POWER_OFF) {
-#else
-	if (system_state == SYSTEM_RESTART) {
-#endif
-		ide_cacheflush_p(drive);
-		return;
-	}
-
-	printk(KERN_INFO "Shutdown: %s\n", drive->name);
-
-	drive->gendev.bus->suspend(&drive->gendev, PMSG_SUSPEND);
-}
-
-static ide_driver_t idedisk_driver = {
-	.gen_driver = {
-		.owner		= THIS_MODULE,
-		.name		= "ide-disk",
-		.bus		= &ide_bus_type,
-	},
-	.probe			= ide_disk_probe,
-	.remove			= ide_disk_remove,
-	.resume			= ide_disk_resume,
-	.shutdown		= ide_device_shutdown,
-	.version		= IDEDISK_VERSION,
-	.do_request		= ide_do_rw_disk,
-	.end_request		= ide_end_request,
-	.error			= __ide_error,
-#ifdef CONFIG_IDE_PROC_FS
-	.proc			= ide_disk_proc,
-	.settings		= ide_disk_settings,
-#endif
-};
-
-static int idedisk_set_doorlock(ide_drive_t *drive, int on)
+int ide_disk_set_doorlock(ide_drive_t *drive, int on)
 {
 	ide_task_t task;
 	int ret;
@@ -835,160 +711,3 @@ static int idedisk_set_doorlock(ide_driv
 
 	return ret;
 }
-
-static int idedisk_open(struct inode *inode, struct file *filp)
-{
-	struct gendisk *disk = inode->i_bdev->bd_disk;
-	struct ide_disk_obj *idkp;
-	ide_drive_t *drive;
-
-	idkp = ide_disk_get(disk);
-	if (idkp == NULL)
-		return -ENXIO;
-
-	drive = idkp->drive;
-
-	idkp->openers++;
-
-	if ((drive->dev_flags & IDE_DFLAG_REMOVABLE) && idkp->openers == 1) {
-		/*
-		 * Ignore the return code from door_lock,
-		 * since the open() has already succeeded,
-		 * and the door_lock is irrelevant at this point.
-		 */
-		idedisk_set_doorlock(drive, 1);
-		check_disk_change(inode->i_bdev);
-	}
-	return 0;
-}
-
-static int idedisk_release(struct inode *inode, struct file *filp)
-{
-	struct gendisk *disk = inode->i_bdev->bd_disk;
-	struct ide_disk_obj *idkp = ide_drv_g(disk, ide_disk_obj);
-	ide_drive_t *drive = idkp->drive;
-
-	if (idkp->openers == 1)
-		ide_cacheflush_p(drive);
-
-	if ((drive->dev_flags & IDE_DFLAG_REMOVABLE) && idkp->openers == 1)
-		idedisk_set_doorlock(drive, 0);
-
-	idkp->openers--;
-
-	ide_disk_put(idkp);
-
-	return 0;
-}
-
-static int idedisk_getgeo(struct block_device *bdev, struct hd_geometry *geo)
-{
-	struct ide_disk_obj *idkp = ide_drv_g(bdev->bd_disk, ide_disk_obj);
-	ide_drive_t *drive = idkp->drive;
-
-	geo->heads = drive->bios_head;
-	geo->sectors = drive->bios_sect;
-	geo->cylinders = (u16)drive->bios_cyl; /* truncate */
-	return 0;
-}
-
-static int idedisk_media_changed(struct gendisk *disk)
-{
-	struct ide_disk_obj *idkp = ide_drv_g(disk, ide_disk_obj);
-	ide_drive_t *drive = idkp->drive;
-
-	/* do not scan partitions twice if this is a removable device */
-	if (drive->dev_flags & IDE_DFLAG_ATTACH) {
-		drive->dev_flags &= ~IDE_DFLAG_ATTACH;
-		return 0;
-	}
-
-	/* if removable, always assume it was changed */
-	return !!(drive->dev_flags & IDE_DFLAG_REMOVABLE);
-}
-
-static int idedisk_revalidate_disk(struct gendisk *disk)
-{
-	struct ide_disk_obj *idkp = ide_drv_g(disk, ide_disk_obj);
-	set_capacity(disk, ide_disk_capacity(idkp->drive));
-	return 0;
-}
-
-static struct block_device_operations idedisk_ops = {
-	.owner			= THIS_MODULE,
-	.open			= idedisk_open,
-	.release		= idedisk_release,
-	.ioctl			= ide_disk_ioctl,
-	.getgeo			= idedisk_getgeo,
-	.media_changed		= idedisk_media_changed,
-	.revalidate_disk	= idedisk_revalidate_disk
-};
-
-MODULE_DESCRIPTION("ATA DISK Driver");
-
-static int ide_disk_probe(ide_drive_t *drive)
-{
-	struct ide_disk_obj *idkp;
-	struct gendisk *g;
-
-	/* strstr("foo", "") is non-NULL */
-	if (!strstr("ide-disk", drive->driver_req))
-		goto failed;
-
-	if (drive->media != ide_disk)
-		goto failed;
-
-	idkp = kzalloc(sizeof(*idkp), GFP_KERNEL);
-	if (!idkp)
-		goto failed;
-
-	g = alloc_disk_node(1 << PARTN_BITS,
-			hwif_to_node(drive->hwif));
-	if (!g)
-		goto out_free_idkp;
-
-	ide_init_disk(g, drive);
-
-	kref_init(&idkp->kref);
-
-	idkp->drive = drive;
-	idkp->driver = &idedisk_driver;
-	idkp->disk = g;
-
-	g->private_data = &idkp->driver;
-
-	drive->driver_data = idkp;
-
-	idedisk_setup(drive);
-
-	set_capacity(g, ide_disk_capacity(drive));
-
-	g->minors = 1 << PARTN_BITS;
-	g->driverfs_dev = &drive->gendev;
-	if (drive->dev_flags & IDE_DFLAG_REMOVABLE)
-		g->flags = GENHD_FL_REMOVABLE;
-	g->fops = &idedisk_ops;
-	add_disk(g);
-	return 0;
-
-out_free_idkp:
-	kfree(idkp);
-failed:
-	return -ENODEV;
-}
-
-static void __exit idedisk_exit(void)
-{
-	driver_unregister(&idedisk_driver.gen_driver);
-}
-
-static int __init idedisk_init(void)
-{
-	return driver_register(&idedisk_driver.gen_driver);
-}
-
-MODULE_ALIAS("ide:*m-disk*");
-MODULE_ALIAS("ide-disk");
-module_init(idedisk_init);
-module_exit(idedisk_exit);
-MODULE_LICENSE("GPL");
Index: b/drivers/ide/ide-disk.h
===================================================================
--- a/drivers/ide/ide-disk.h
+++ b/drivers/ide/ide-disk.h
@@ -9,8 +9,14 @@ struct ide_disk_obj {
 	unsigned int	openers;	/* protected by BKL for now */
 };
 
+sector_t ide_gd_capacity(ide_drive_t *);
+
 /* ide-disk.c */
-sector_t ide_disk_capacity(ide_drive_t *);
+void ide_disk_init_capacity(ide_drive_t *);
+void ide_disk_setup(ide_drive_t *);
+void ide_disk_flush(ide_drive_t *);
+int ide_disk_set_doorlock(ide_drive_t *, int);
+ide_startstop_t ide_do_rw_disk(ide_drive_t *, struct request *, sector_t);
 ide_decl_devset(address);
 ide_decl_devset(multcount);
 ide_decl_devset(nowerr);
Index: b/drivers/ide/ide-disk_proc.c
===================================================================
--- a/drivers/ide/ide-disk_proc.c
+++ b/drivers/ide/ide-disk_proc.c
@@ -56,7 +56,7 @@ static int proc_idedisk_read_capacity
 	ide_drive_t*drive = (ide_drive_t *)data;
 	int len;
 
-	len = sprintf(page, "%llu\n", (long long)ide_disk_capacity(drive));
+	len = sprintf(page, "%llu\n", (long long)ide_gd_capacity(drive));
 
 	PROC_IDE_READ_RETURN(page, start, off, count, eof, len);
 }
Index: b/drivers/ide/ide-gd.c
===================================================================
--- /dev/null
+++ b/drivers/ide/ide-gd.c
@@ -0,0 +1,289 @@
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
+#include "ide-disk.h"
+
+#define IDE_GD_VERSION	"1.18"
+
+static DEFINE_MUTEX(ide_disk_ref_mutex);
+
+static void ide_disk_release(struct kref *);
+
+static struct ide_disk_obj *ide_disk_get(struct gendisk *disk)
+{
+	struct ide_disk_obj *idkp = NULL;
+
+	mutex_lock(&ide_disk_ref_mutex);
+	idkp = ide_drv_g(disk, ide_disk_obj);
+	if (idkp) {
+		if (ide_device_get(idkp->drive))
+			idkp = NULL;
+		else
+			kref_get(&idkp->kref);
+	}
+	mutex_unlock(&ide_disk_ref_mutex);
+	return idkp;
+}
+
+static void ide_disk_put(struct ide_disk_obj *idkp)
+{
+	ide_drive_t *drive = idkp->drive;
+
+	mutex_lock(&ide_disk_ref_mutex);
+	kref_put(&idkp->kref, ide_disk_release);
+	ide_device_put(drive);
+	mutex_unlock(&ide_disk_ref_mutex);
+}
+
+sector_t ide_gd_capacity(ide_drive_t *drive)
+{
+	return drive->capacity64;
+}
+
+static int ide_gd_probe(ide_drive_t *);
+
+static void ide_gd_remove(ide_drive_t *drive)
+{
+	struct ide_disk_obj *idkp = drive->driver_data;
+	struct gendisk *g = idkp->disk;
+
+	ide_proc_unregister_driver(drive, idkp->driver);
+
+	del_gendisk(g);
+
+	ide_disk_flush(drive);
+
+	ide_disk_put(idkp);
+}
+
+static void ide_disk_release(struct kref *kref)
+{
+	struct ide_disk_obj *idkp = to_ide_drv(kref, ide_disk_obj);
+	ide_drive_t *drive = idkp->drive;
+	struct gendisk *g = idkp->disk;
+
+	drive->driver_data = NULL;
+	g->private_data = NULL;
+	put_disk(g);
+	kfree(idkp);
+}
+
+/*
+ * On HPA drives the capacity needs to be
+ * reinitilized on resume otherwise the disk
+ * can not be used and a hard reset is required
+ */
+static void ide_gd_resume(ide_drive_t *drive)
+{
+	if (ata_id_hpa_enabled(drive->id))
+		ide_disk_init_capacity(drive);
+}
+
+static void ide_gd_shutdown(ide_drive_t *drive)
+{
+#ifdef	CONFIG_ALPHA
+	/* On Alpha, halt(8) doesn't actually turn the machine off,
+	   it puts you into the sort of firmware monitor. Typically,
+	   it's used to boot another kernel image, so it's not much
+	   different from reboot(8). Therefore, we don't need to
+	   spin down the disk in this case, especially since Alpha
+	   firmware doesn't handle disks in standby mode properly.
+	   On the other hand, it's reasonably safe to turn the power
+	   off when the shutdown process reaches the firmware prompt,
+	   as the firmware initialization takes rather long time -
+	   at least 10 seconds, which should be sufficient for
+	   the disk to expire its write cache. */
+	if (system_state != SYSTEM_POWER_OFF) {
+#else
+	if (system_state == SYSTEM_RESTART) {
+#endif
+		ide_disk_flush(drive);
+		return;
+	}
+
+	printk(KERN_INFO "Shutdown: %s\n", drive->name);
+
+	drive->gendev.bus->suspend(&drive->gendev, PMSG_SUSPEND);
+}
+
+static ide_driver_t ide_gd_driver = {
+	.gen_driver = {
+		.owner		= THIS_MODULE,
+		.name		= "ide-disk",
+		.bus		= &ide_bus_type,
+	},
+	.probe			= ide_gd_probe,
+	.remove			= ide_gd_remove,
+	.resume			= ide_gd_resume,
+	.shutdown		= ide_gd_shutdown,
+	.version		= IDE_GD_VERSION,
+	.do_request		= ide_do_rw_disk,
+	.end_request		= ide_end_request,
+	.error			= __ide_error,
+#ifdef CONFIG_IDE_PROC_FS
+	.proc			= ide_disk_proc,
+	.settings		= ide_disk_settings,
+#endif
+};
+
+static int ide_gd_open(struct inode *inode, struct file *filp)
+{
+	struct gendisk *disk = inode->i_bdev->bd_disk;
+	struct ide_disk_obj *idkp;
+	ide_drive_t *drive;
+
+	idkp = ide_disk_get(disk);
+	if (idkp == NULL)
+		return -ENXIO;
+
+	drive = idkp->drive;
+
+	idkp->openers++;
+
+	if ((drive->dev_flags & IDE_DFLAG_REMOVABLE) && idkp->openers == 1) {
+		/*
+		 * Ignore the return code from door_lock,
+		 * since the open() has already succeeded,
+		 * and the door_lock is irrelevant at this point.
+		 */
+		ide_disk_set_doorlock(drive, 1);
+		check_disk_change(inode->i_bdev);
+	}
+	return 0;
+}
+
+static int ide_gd_release(struct inode *inode, struct file *filp)
+{
+	struct gendisk *disk = inode->i_bdev->bd_disk;
+	struct ide_disk_obj *idkp = ide_drv_g(disk, ide_disk_obj);
+	ide_drive_t *drive = idkp->drive;
+
+	if (idkp->openers == 1)
+		ide_disk_flush(drive);
+
+	if ((drive->dev_flags & IDE_DFLAG_REMOVABLE) && idkp->openers == 1)
+		ide_disk_set_doorlock(drive, 0);
+
+	idkp->openers--;
+
+	ide_disk_put(idkp);
+
+	return 0;
+}
+
+static int ide_gd_getgeo(struct block_device *bdev, struct hd_geometry *geo)
+{
+	struct ide_disk_obj *idkp = ide_drv_g(bdev->bd_disk, ide_disk_obj);
+	ide_drive_t *drive = idkp->drive;
+
+	geo->heads = drive->bios_head;
+	geo->sectors = drive->bios_sect;
+	geo->cylinders = (u16)drive->bios_cyl; /* truncate */
+	return 0;
+}
+
+static int ide_gd_media_changed(struct gendisk *disk)
+{
+	struct ide_disk_obj *idkp = ide_drv_g(disk, ide_disk_obj);
+	ide_drive_t *drive = idkp->drive;
+
+	/* do not scan partitions twice if this is a removable device */
+	if (drive->dev_flags & IDE_DFLAG_ATTACH) {
+		drive->dev_flags &= ~IDE_DFLAG_ATTACH;
+		return 0;
+	}
+
+	/* if removable, always assume it was changed */
+	return !!(drive->dev_flags & IDE_DFLAG_REMOVABLE);
+}
+
+static int ide_gd_revalidate_disk(struct gendisk *disk)
+{
+	struct ide_disk_obj *idkp = ide_drv_g(disk, ide_disk_obj);
+	set_capacity(disk, ide_gd_capacity(idkp->drive));
+	return 0;
+}
+
+static struct block_device_operations ide_gd_ops = {
+	.owner			= THIS_MODULE,
+	.open			= ide_gd_open,
+	.release		= ide_gd_release,
+	.ioctl			= ide_disk_ioctl,
+	.getgeo			= ide_gd_getgeo,
+	.media_changed		= ide_gd_media_changed,
+	.revalidate_disk	= ide_gd_revalidate_disk
+};
+
+static int ide_gd_probe(ide_drive_t *drive)
+{
+	struct ide_disk_obj *idkp;
+	struct gendisk *g;
+
+	/* strstr("foo", "") is non-NULL */
+	if (!strstr("ide-disk", drive->driver_req))
+		goto failed;
+
+	if (drive->media != ide_disk)
+		goto failed;
+
+	idkp = kzalloc(sizeof(*idkp), GFP_KERNEL);
+	if (!idkp)
+		goto failed;
+
+	g = alloc_disk_node(1 << PARTN_BITS, hwif_to_node(drive->hwif));
+	if (!g)
+		goto out_free_idkp;
+
+	ide_init_disk(g, drive);
+
+	kref_init(&idkp->kref);
+
+	idkp->drive = drive;
+	idkp->driver = &ide_gd_driver;
+	idkp->disk = g;
+
+	g->private_data = &idkp->driver;
+
+	drive->driver_data = idkp;
+
+	ide_disk_setup(drive);
+
+	set_capacity(g, ide_gd_capacity(drive));
+
+	g->minors = 1 << PARTN_BITS;
+	g->driverfs_dev = &drive->gendev;
+	if (drive->dev_flags & IDE_DFLAG_REMOVABLE)
+		g->flags = GENHD_FL_REMOVABLE;
+	g->fops = &ide_gd_ops;
+	add_disk(g);
+	return 0;
+
+out_free_idkp:
+	kfree(idkp);
+failed:
+	return -ENODEV;
+}
+
+static int __init ide_gd_init(void)
+{
+	return driver_register(&ide_gd_driver.gen_driver);
+}
+
+static void __exit ide_gd_exit(void)
+{
+	driver_unregister(&ide_gd_driver.gen_driver);
+}
+
+MODULE_ALIAS("ide:*m-disk*");
+MODULE_ALIAS("ide-disk");
+module_init(ide_gd_init);
+module_exit(ide_gd_exit);
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("ATA DISK Driver");
