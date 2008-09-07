Return-Path: <linux-kernel-owner+w=401wt.eu-S1756775AbYIGWWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775AbYIGWWg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 18:22:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756200AbYIGWS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 18:18:26 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:25685 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756193AbYIGWSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 18:18:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=n5bkRhYySrjPJ4NAiguPBEHYqkFugYMUXrSYnxL6LHCoDUl31nWf9WULQCRczyryAu
         vIXeiB9m/xNtRqOKpM2NoiW5+/+LiNW3f7QeQNK+l4fmCXqOd01njTqvm6t3jt2Wq2x7
         Z1IBJBBG4SPBXB/aLGtmRwp4xPsNhuSECEFqM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 08 Sep 2008 00:16:15 +0200
Message-Id: <20080907221615.24285.34603.sendpatchset@localhost.localdomain>
In-Reply-To: <20080907221424.24285.81137.sendpatchset@localhost.localdomain>
References: <20080907221424.24285.81137.sendpatchset@localhost.localdomain>
Subject: [PATCH 16/18] ide: prepare for merging ide-gd-floppy.c with ide-gd.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- idefloppy_ref_mutex -> ide_disk_ref_mutex
- idefloppy_cleanup_obj() -> ide_disk_release()
- ide_floppy_get() -> ide_disk_get()
- ide_floppy_put() -> ide_disk_put()
- ide_floppy_capacity() -> ide_gd_capacity()
- ide_floppy_remove() -> ide_gd_remove()
- ide_floppy_probe() -> ide_gd_probe()
- idefloppy_driver -> ide_gd_driver
- idefloppy_open() -> ide_gd_open()
- idefloppy_release() -> ide_gd_release()
- idefloppy_getgeo() -> ide_gd_getgeo()
- idefloppy_media_changed() -> ide_gd_media_changed()
- idefloppy_revalidate_disk() -> ide_gd_revalidate_disk()
- idefloppy_ops -> ide_gd_ops
- idefloppy_init() -> ide_gd_init()
- idefloppy_exit() -> ide_gd_exit()

- 'floppy' -> 'idkp' in ide_disk_*() and ide_gd_*()
- idefloppy_floppy_t -> struct ide_floppy_obj

There should be no functional changes caused by this patch.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-floppy.h      |    2 
 drivers/ide/ide-floppy_proc.c |    2 
 drivers/ide/ide-gd-floppy.c   |  179 ++++++++++++++++++++----------------------
 3 files changed, 91 insertions(+), 92 deletions(-)

Index: b/drivers/ide/ide-floppy.h
===================================================================
--- a/drivers/ide/ide-floppy.h
+++ b/drivers/ide/ide-floppy.h
@@ -57,7 +57,7 @@ typedef struct ide_floppy_obj {
 #define	IDEFLOPPY_IOCTL_FORMAT_START		0x4602
 #define IDEFLOPPY_IOCTL_FORMAT_GET_PROGRESS	0x4603
 
-sector_t ide_floppy_capacity(ide_drive_t *);
+sector_t ide_gd_capacity(ide_drive_t *);
 
 /* ide-floppy.c */
 void ide_floppy_create_mode_sense_cmd(struct ide_atapi_pc *, u8);
Index: b/drivers/ide/ide-floppy_proc.c
===================================================================
--- a/drivers/ide/ide-floppy_proc.c
+++ b/drivers/ide/ide-floppy_proc.c
@@ -9,7 +9,7 @@ static int proc_idefloppy_read_capacity(
 	ide_drive_t*drive = (ide_drive_t *)data;
 	int len;
 
-	len = sprintf(page, "%llu\n", (long long)ide_floppy_capacity(drive));
+	len = sprintf(page, "%llu\n", (long long)ide_gd_capacity(drive));
 	PROC_IDE_READ_RETURN(page, start, off, count, eof, len);
 }
 
Index: b/drivers/ide/ide-gd-floppy.c
===================================================================
--- a/drivers/ide/ide-gd-floppy.c
+++ b/drivers/ide/ide-gd-floppy.c
@@ -16,75 +16,75 @@
 static unsigned long debug_mask;
 module_param(debug_mask, ulong, 0644);
 
-static DEFINE_MUTEX(idefloppy_ref_mutex);
+static DEFINE_MUTEX(ide_disk_ref_mutex);
 
-static void idefloppy_cleanup_obj(struct kref *);
+static void ide_disk_release(struct kref *);
 
-static struct ide_floppy_obj *ide_floppy_get(struct gendisk *disk)
+static struct ide_floppy_obj *ide_disk_get(struct gendisk *disk)
 {
-	struct ide_floppy_obj *floppy = NULL;
+	struct ide_floppy_obj *idkp = NULL;
 
-	mutex_lock(&idefloppy_ref_mutex);
-	floppy = ide_drv_g(disk, ide_floppy_obj);
-	if (floppy) {
-		if (ide_device_get(floppy->drive))
-			floppy = NULL;
+	mutex_lock(&ide_disk_ref_mutex);
+	idkp = ide_drv_g(disk, ide_floppy_obj);
+	if (idkp) {
+		if (ide_device_get(idkp->drive))
+			idkp = NULL;
 		else
-			kref_get(&floppy->kref);
+			kref_get(&idkp->kref);
 	}
-	mutex_unlock(&idefloppy_ref_mutex);
-	return floppy;
+	mutex_unlock(&ide_disk_ref_mutex);
+	return idkp;
 }
 
-static void ide_floppy_put(struct ide_floppy_obj *floppy)
+static void ide_disk_put(struct ide_floppy_obj *idkp)
 {
-	ide_drive_t *drive = floppy->drive;
+	ide_drive_t *drive = idkp->drive;
 
-	mutex_lock(&idefloppy_ref_mutex);
-	kref_put(&floppy->kref, idefloppy_cleanup_obj);
+	mutex_lock(&ide_disk_ref_mutex);
+	kref_put(&idkp->kref, ide_disk_release);
 	ide_device_put(drive);
-	mutex_unlock(&idefloppy_ref_mutex);
+	mutex_unlock(&ide_disk_ref_mutex);
 }
 
-sector_t ide_floppy_capacity(ide_drive_t *drive)
+sector_t ide_gd_capacity(ide_drive_t *drive)
 {
 	return drive->capacity64;
 }
 
-static void ide_floppy_remove(ide_drive_t *drive)
+static int ide_gd_probe(ide_drive_t *);
+
+static void ide_gd_remove(ide_drive_t *drive)
 {
-	idefloppy_floppy_t *floppy = drive->driver_data;
-	struct gendisk *g = floppy->disk;
+	struct ide_floppy_obj *idkp = drive->driver_data;
+	struct gendisk *g = idkp->disk;
 
-	ide_proc_unregister_driver(drive, floppy->driver);
+	ide_proc_unregister_driver(drive, idkp->driver);
 
 	del_gendisk(g);
 
-	ide_floppy_put(floppy);
+	ide_disk_put(idkp);
 }
 
-static void idefloppy_cleanup_obj(struct kref *kref)
+static void ide_disk_release(struct kref *kref)
 {
-	struct ide_floppy_obj *floppy = to_ide_drv(kref, ide_floppy_obj);
-	ide_drive_t *drive = floppy->drive;
-	struct gendisk *g = floppy->disk;
+	struct ide_floppy_obj *idkp = to_ide_drv(kref, ide_floppy_obj);
+	ide_drive_t *drive = idkp->drive;
+	struct gendisk *g = idkp->disk;
 
 	drive->driver_data = NULL;
 	g->private_data = NULL;
 	put_disk(g);
-	kfree(floppy);
+	kfree(idkp);
 }
 
-static int ide_floppy_probe(ide_drive_t *);
-
-static ide_driver_t idefloppy_driver = {
+static ide_driver_t ide_gd_driver = {
 	.gen_driver = {
 		.owner		= THIS_MODULE,
 		.name		= "ide-floppy",
 		.bus		= &ide_bus_type,
 	},
-	.probe			= ide_floppy_probe,
-	.remove			= ide_floppy_remove,
+	.probe			= ide_gd_probe,
+	.remove			= ide_gd_remove,
 	.version		= IDEFLOPPY_VERSION,
 	.do_request		= ide_floppy_do_request,
 	.end_request		= ide_floppy_end_request,
@@ -95,24 +95,24 @@ static ide_driver_t idefloppy_driver = {
 #endif
 };
 
-static int idefloppy_open(struct inode *inode, struct file *filp)
+static int ide_gd_open(struct inode *inode, struct file *filp)
 {
 	struct gendisk *disk = inode->i_bdev->bd_disk;
-	struct ide_floppy_obj *floppy;
+	struct ide_floppy_obj *idkp;
 	ide_drive_t *drive;
 	int ret = 0;
 
-	floppy = ide_floppy_get(disk);
-	if (!floppy)
+	idkp = ide_disk_get(disk);
+	if (idkp == NULL)
 		return -ENXIO;
 
-	drive = floppy->drive;
+	drive = idkp->drive;
 
 	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
 
-	floppy->openers++;
+	idkp->openers++;
 
-	if (floppy->openers == 1) {
+	if (idkp->openers == 1) {
 		drive->dev_flags &= ~IDE_DFLAG_FORMAT_IN_PROGRESS;
 		/* Just in case */
 
@@ -121,7 +121,7 @@ static int idefloppy_open(struct inode *
 
 		ret = ide_floppy_get_capacity(drive);
 
-		set_capacity(disk, ide_floppy_capacity(drive));
+		set_capacity(disk, ide_gd_capacity(drive));
 
 		if (ret && (filp->f_flags & O_NDELAY) == 0) {
 		    /*
@@ -130,12 +130,12 @@ static int idefloppy_open(struct inode *
 		     * of the drive or begin the format - Sam
 		     */
 			ret = -EIO;
-			goto out_put_floppy;
+			goto out_put_idkp;
 		}
 
 		if ((drive->dev_flags & IDE_DFLAG_WP) && (filp->f_mode & 2)) {
 			ret = -EROFS;
-			goto out_put_floppy;
+			goto out_put_idkp;
 		}
 
 		ide_set_media_lock(drive, disk, 1);
@@ -143,41 +143,40 @@ static int idefloppy_open(struct inode *
 		check_disk_change(inode->i_bdev);
 	} else if (drive->dev_flags & IDE_DFLAG_FORMAT_IN_PROGRESS) {
 		ret = -EBUSY;
-		goto out_put_floppy;
+		goto out_put_idkp;
 	}
 	return 0;
 
-out_put_floppy:
-	floppy->openers--;
-	ide_floppy_put(floppy);
+out_put_idkp:
+	idkp->openers--;
+	ide_disk_put(idkp);
 	return ret;
 }
 
-static int idefloppy_release(struct inode *inode, struct file *filp)
+static int ide_gd_release(struct inode *inode, struct file *filp)
 {
 	struct gendisk *disk = inode->i_bdev->bd_disk;
-	struct ide_floppy_obj *floppy = ide_drv_g(disk, ide_floppy_obj);
-	ide_drive_t *drive = floppy->drive;
+	struct ide_floppy_obj *idkp = ide_drv_g(disk, ide_floppy_obj);
+	ide_drive_t *drive = idkp->drive;
 
 	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
 
-	if (floppy->openers == 1) {
+	if (idkp->openers == 1) {
 		ide_set_media_lock(drive, disk, 0);
 		drive->dev_flags &= ~IDE_DFLAG_FORMAT_IN_PROGRESS;
 	}
 
-	floppy->openers--;
+	idkp->openers--;
 
-	ide_floppy_put(floppy);
+	ide_disk_put(idkp);
 
 	return 0;
 }
 
-static int idefloppy_getgeo(struct block_device *bdev, struct hd_geometry *geo)
+static int ide_gd_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 {
-	struct ide_floppy_obj *floppy = ide_drv_g(bdev->bd_disk,
-						     ide_floppy_obj);
-	ide_drive_t *drive = floppy->drive;
+	struct ide_floppy_obj *idkp = ide_drv_g(bdev->bd_disk, ide_floppy_obj);
+	ide_drive_t *drive = idkp->drive;
 
 	geo->heads = drive->bios_head;
 	geo->sectors = drive->bios_sect;
@@ -185,10 +184,10 @@ static int idefloppy_getgeo(struct block
 	return 0;
 }
 
-static int idefloppy_media_changed(struct gendisk *disk)
+static int ide_gd_media_changed(struct gendisk *disk)
 {
-	struct ide_floppy_obj *floppy = ide_drv_g(disk, ide_floppy_obj);
-	ide_drive_t *drive = floppy->drive;
+	struct ide_floppy_obj *idkp = ide_drv_g(disk, ide_floppy_obj);
+	ide_drive_t *drive = idkp->drive;
 	int ret;
 
 	/* do not scan partitions twice if this is a removable device */
@@ -203,26 +202,26 @@ static int idefloppy_media_changed(struc
 	return ret;
 }
 
-static int idefloppy_revalidate_disk(struct gendisk *disk)
+static int ide_gd_revalidate_disk(struct gendisk *disk)
 {
-	struct ide_floppy_obj *floppy = ide_drv_g(disk, ide_floppy_obj);
-	set_capacity(disk, ide_floppy_capacity(floppy->drive));
+	struct ide_floppy_obj *idkp = ide_drv_g(disk, ide_floppy_obj);
+	set_capacity(disk, ide_gd_capacity(idkp->drive));
 	return 0;
 }
 
-static struct block_device_operations idefloppy_ops = {
+static struct block_device_operations ide_gd_ops = {
 	.owner			= THIS_MODULE,
-	.open			= idefloppy_open,
-	.release		= idefloppy_release,
+	.open			= ide_gd_open,
+	.release		= ide_gd_release,
 	.ioctl			= ide_floppy_ioctl,
-	.getgeo			= idefloppy_getgeo,
-	.media_changed		= idefloppy_media_changed,
-	.revalidate_disk	= idefloppy_revalidate_disk
+	.getgeo			= ide_gd_getgeo,
+	.media_changed		= ide_gd_media_changed,
+	.revalidate_disk	= ide_gd_revalidate_disk
 };
 
-static int ide_floppy_probe(ide_drive_t *drive)
+static int ide_gd_probe(ide_drive_t *drive)
 {
-	idefloppy_floppy_t *floppy;
+	struct ide_floppy_obj *idkp;
 	struct gendisk *g;
 
 	if (!strstr("ide-floppy", drive->driver_req))
@@ -236,8 +235,8 @@ static int ide_floppy_probe(ide_drive_t 
 		       DRV_NAME "\n", drive->name);
 		goto failed;
 	}
-	floppy = kzalloc(sizeof(idefloppy_floppy_t), GFP_KERNEL);
-	if (!floppy) {
+	idkp = kzalloc(sizeof(*idkp), GFP_KERNEL);
+	if (!idkp) {
 		printk(KERN_ERR PFX "%s: Can't allocate a floppy structure\n",
 		       drive->name);
 		goto failed;
@@ -245,54 +244,54 @@ static int ide_floppy_probe(ide_drive_t 
 
 	g = alloc_disk_node(1 << PARTN_BITS, hwif_to_node(drive->hwif));
 	if (!g)
-		goto out_free_floppy;
+		goto out_free_idkp;
 
 	ide_init_disk(g, drive);
 
-	kref_init(&floppy->kref);
+	kref_init(&idkp->kref);
 
-	floppy->drive = drive;
-	floppy->driver = &idefloppy_driver;
-	floppy->disk = g;
+	idkp->drive = drive;
+	idkp->driver = &ide_gd_driver;
+	idkp->disk = g;
 
-	g->private_data = &floppy->driver;
+	g->private_data = &idkp->driver;
 
-	drive->driver_data = floppy;
+	drive->driver_data = idkp;
 
 	drive->debug_mask = debug_mask;
 
 	ide_floppy_setup(drive);
 
-	set_capacity(g, ide_floppy_capacity(drive));
+	set_capacity(g, ide_gd_capacity(drive));
 
 	g->minors = 1 << PARTN_BITS;
 	g->driverfs_dev = &drive->gendev;
 	if (drive->dev_flags & IDE_DFLAG_REMOVABLE)
 		g->flags = GENHD_FL_REMOVABLE;
-	g->fops = &idefloppy_ops;
+	g->fops = &ide_gd_ops;
 	add_disk(g);
 	return 0;
 
-out_free_floppy:
-	kfree(floppy);
+out_free_idkp:
+	kfree(idkp);
 failed:
 	return -ENODEV;
 }
 
-static int __init idefloppy_init(void)
+static int __init ide_gd_init(void)
 {
 	printk(KERN_INFO DRV_NAME " driver " IDEFLOPPY_VERSION "\n");
-	return driver_register(&idefloppy_driver.gen_driver);
+	return driver_register(&ide_gd_driver.gen_driver);
 }
 
-static void __exit idefloppy_exit(void)
+static void __exit ide_gd_exit(void)
 {
-	driver_unregister(&idefloppy_driver.gen_driver);
+	driver_unregister(&ide_gd_driver.gen_driver);
 }
 
 MODULE_ALIAS("ide:*m-floppy*");
 MODULE_ALIAS("ide-floppy");
-module_init(idefloppy_init);
-module_exit(idefloppy_exit);
+module_init(ide_gd_init);
+module_exit(ide_gd_exit);
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("ATAPI FLOPPY Driver");
