Return-Path: <linux-kernel-owner+w=401wt.eu-S1760094AbYGFRij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760094AbYGFRij (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 13:38:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758315AbYGFRfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 13:35:00 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:6801 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755646AbYGFRer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 13:34:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:date:from:to:cc:subject:content-disposition:message-id;
        b=wiq1sRScrSQfJoPEp+E8Xq4xWYCTrOUaOImswY+NH4t+8Ix38nD6cimIaEGH1jcjDd
         OdQNrxSBKmf+VRERXSlrUDWdubXgGOmAmadi2FkwP15wldkjZFVwH91JrwA+sTXD+0Mv
         zAnepF14ox3//Qit5MXbFzmovHAKZrWxEnhG4=
References: <20080706172010.559358957@bzolnier@gmail.com>
Date: Sun, 06 Jul 2008 19:20:17 +0200
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 07/50] ide: add ide_device_{get,put}() helpers
Content-Disposition: inline; filename=ide-add-ide_device_get-put-helpers.patch
Message-ID: <48710235.1ade660a.3458.6277@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Add 'struct ide_host *host' field to ide_hwif_t and set it
  in ide_host_alloc_all().

* Add ide_device_{get,put}() helpers loosely based on SCSI's
  scsi_device_{get,put}() ones.

* Convert IDE device drivers to use ide_device_{get,put}().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c     |   12 +++++++++---
 drivers/ide/ide-disk.c   |   12 +++++++++---
 drivers/ide/ide-floppy.c |   12 +++++++++---
 drivers/ide/ide-probe.c  |    2 ++
 drivers/ide/ide-tape.c   |   12 +++++++++---
 drivers/ide/ide.c        |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ide-scsi.c  |    8 +++++++-
 include/linux/ide.h      |    7 +++++++
 8 files changed, 99 insertions(+), 13 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -57,23 +57,29 @@ static DEFINE_MUTEX(idecd_ref_mutex);
 #define ide_cd_g(disk) \
 	container_of((disk)->private_data, struct cdrom_info, driver)
 
+static void ide_cd_release(struct kref *);
+
 static struct cdrom_info *ide_cd_get(struct gendisk *disk)
 {
 	struct cdrom_info *cd = NULL;
 
 	mutex_lock(&idecd_ref_mutex);
 	cd = ide_cd_g(disk);
-	if (cd)
+	if (cd) {
 		kref_get(&cd->kref);
+		if (ide_device_get(cd->drive)) {
+			kref_put(&cd->kref, ide_cd_release);
+			cd = NULL;
+		}
+	}
 	mutex_unlock(&idecd_ref_mutex);
 	return cd;
 }
 
-static void ide_cd_release(struct kref *);
-
 static void ide_cd_put(struct cdrom_info *cd)
 {
 	mutex_lock(&idecd_ref_mutex);
+	ide_device_put(cd->drive);
 	kref_put(&cd->kref, ide_cd_release);
 	mutex_unlock(&idecd_ref_mutex);
 }
Index: b/drivers/ide/ide-disk.c
===================================================================
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -56,23 +56,29 @@ static DEFINE_MUTEX(idedisk_ref_mutex);
 #define ide_disk_g(disk) \
 	container_of((disk)->private_data, struct ide_disk_obj, driver)
 
+static void ide_disk_release(struct kref *);
+
 static struct ide_disk_obj *ide_disk_get(struct gendisk *disk)
 {
 	struct ide_disk_obj *idkp = NULL;
 
 	mutex_lock(&idedisk_ref_mutex);
 	idkp = ide_disk_g(disk);
-	if (idkp)
+	if (idkp) {
 		kref_get(&idkp->kref);
+		if (ide_device_get(idkp->drive)) {
+			kref_put(&idkp->kref, ide_disk_release);
+			idkp = NULL;
+		}
+	}
 	mutex_unlock(&idedisk_ref_mutex);
 	return idkp;
 }
 
-static void ide_disk_release(struct kref *);
-
 static void ide_disk_put(struct ide_disk_obj *idkp)
 {
 	mutex_lock(&idedisk_ref_mutex);
+	ide_device_put(idkp->drive);
 	kref_put(&idkp->kref, ide_disk_release);
 	mutex_unlock(&idedisk_ref_mutex);
 }
Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -158,23 +158,29 @@ static DEFINE_MUTEX(idefloppy_ref_mutex)
 #define ide_floppy_g(disk) \
 	container_of((disk)->private_data, struct ide_floppy_obj, driver)
 
+static void idefloppy_cleanup_obj(struct kref *);
+
 static struct ide_floppy_obj *ide_floppy_get(struct gendisk *disk)
 {
 	struct ide_floppy_obj *floppy = NULL;
 
 	mutex_lock(&idefloppy_ref_mutex);
 	floppy = ide_floppy_g(disk);
-	if (floppy)
+	if (floppy) {
 		kref_get(&floppy->kref);
+		if (ide_device_get(floppy->drive)) {
+			kref_put(&floppy->kref, idefloppy_cleanup_obj);
+			floppy = NULL;
+		}
+	}
 	mutex_unlock(&idefloppy_ref_mutex);
 	return floppy;
 }
 
-static void idefloppy_cleanup_obj(struct kref *);
-
 static void ide_floppy_put(struct ide_floppy_obj *floppy)
 {
 	mutex_lock(&idefloppy_ref_mutex);
+	ide_device_put(floppy->drive);
 	kref_put(&floppy->kref, idefloppy_cleanup_obj);
 	mutex_unlock(&idefloppy_ref_mutex);
 }
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1599,6 +1599,8 @@ struct ide_host *ide_host_alloc_all(cons
 
 		ide_init_port_data(hwif, idx);
 
+		hwif->host = host;
+
 		host->ports[i] = hwif;
 		host->n_ports++;
 	}
Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -322,23 +322,29 @@ static struct class *idetape_sysfs_class
 #define ide_tape_g(disk) \
 	container_of((disk)->private_data, struct ide_tape_obj, driver)
 
+static void ide_tape_release(struct kref *);
+
 static struct ide_tape_obj *ide_tape_get(struct gendisk *disk)
 {
 	struct ide_tape_obj *tape = NULL;
 
 	mutex_lock(&idetape_ref_mutex);
 	tape = ide_tape_g(disk);
-	if (tape)
+	if (tape) {
 		kref_get(&tape->kref);
+		if (ide_device_get(tape->drive)) {
+			kref_put(&tape->kref, ide_tape_release);
+			tape = NULL;
+		}
+	}
 	mutex_unlock(&idetape_ref_mutex);
 	return tape;
 }
 
-static void ide_tape_release(struct kref *);
-
 static void ide_tape_put(struct ide_tape_obj *tape)
 {
 	mutex_lock(&idetape_ref_mutex);
+	ide_device_put(tape->drive);
 	kref_put(&tape->kref, ide_tape_release);
 	mutex_unlock(&idetape_ref_mutex);
 }
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -618,6 +618,53 @@ set_val:
 
 EXPORT_SYMBOL(generic_ide_ioctl);
 
+/**
+ * ide_device_get	-	get an additional reference to a ide_drive_t
+ * @drive:	device to get a reference to
+ *
+ * Gets a reference to the ide_drive_t and increments the use count of the
+ * underlying LLDD module.
+ */
+int ide_device_get(ide_drive_t *drive)
+{
+	struct device *host_dev;
+	struct module *module;
+
+	if (!get_device(&drive->gendev))
+		return -ENXIO;
+
+	host_dev = drive->hwif->host->dev[0];
+	module = host_dev ? host_dev->driver->owner : NULL;
+
+	if (module && !try_module_get(module)) {
+		put_device(&drive->gendev);
+		return -ENXIO;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ide_device_get);
+
+/**
+ * ide_device_put	-	release a reference to a ide_drive_t
+ * @drive:	device to release a reference on
+ *
+ * Release a reference to the ide_drive_t and decrements the use count of
+ * the underlying LLDD module.
+ */
+void ide_device_put(ide_drive_t *drive)
+{
+#ifdef CONFIG_MODULE_UNLOAD
+	struct device *host_dev = drive->hwif->host->dev[0];
+	struct module *module = host_dev ? host_dev->driver->owner : NULL;
+
+	if (module)
+		module_put(module);
+#endif
+	put_device(&drive->gendev);
+}
+EXPORT_SYMBOL_GPL(ide_device_put);
+
 static int ide_bus_match(struct device *dev, struct device_driver *drv)
 {
 	return 1;
Index: b/drivers/scsi/ide-scsi.c
===================================================================
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -101,8 +101,13 @@ static struct ide_scsi_obj *ide_scsi_get
 
 	mutex_lock(&idescsi_ref_mutex);
 	scsi = ide_scsi_g(disk);
-	if (scsi)
+	if (scsi) {
 		scsi_host_get(scsi->host);
+		if (ide_device_get(scsi->drive)) {
+			scsi_host_put(scsi->host);
+			scsi = NULL;
+		}
+	}
 	mutex_unlock(&idescsi_ref_mutex);
 	return scsi;
 }
@@ -110,6 +115,7 @@ static struct ide_scsi_obj *ide_scsi_get
 static void ide_scsi_put(struct ide_scsi_obj *scsi)
 {
 	mutex_lock(&idescsi_ref_mutex);
+	ide_device_put(scsi->drive);
 	scsi_host_put(scsi->host);
 	mutex_unlock(&idescsi_ref_mutex);
 }
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -517,12 +517,16 @@ struct ide_dma_ops {
 	void	(*dma_timeout)(struct ide_drive_s *);
 };
 
+struct ide_host;
+
 typedef struct hwif_s {
 	struct hwif_s *next;		/* for linked-list in ide_hwgroup_t */
 	struct hwif_s *mate;		/* other hwif from same PCI chip */
 	struct hwgroup_s *hwgroup;	/* actually (ide_hwgroup_t *) */
 	struct proc_dir_entry *proc;	/* /proc/ide/ directory entry */
 
+	struct ide_host *host;
+
 	char name[6];			/* name of interface, eg. "ide0" */
 
 	struct ide_io_ports	io_ports;
@@ -861,6 +865,9 @@ struct ide_driver_s {
 
 #define to_ide_driver(drv) container_of(drv, ide_driver_t, gen_driver)
 
+int ide_device_get(ide_drive_t *);
+void ide_device_put(ide_drive_t *);
+
 int generic_ide_ioctl(ide_drive_t *, struct file *, struct block_device *, unsigned, unsigned long);
 
 extern int ide_vlb_clk;

-- 

