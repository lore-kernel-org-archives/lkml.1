Return-Path: <linux-kernel-owner+w=401wt.eu-S1760270AbZBYUEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760270AbZBYUEg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 15:04:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758438AbZBYUES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 15:04:18 -0500
Received: from mail-fx0-f176.google.com ([209.85.220.176]:52800 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758299AbZBYUEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 15:04:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:user-agent:cc:mime-version:content-disposition:date
         :message-id:content-type:content-transfer-encoding;
        b=bXNn0eLZcDwX61Vgun9hSQlQwZ59BCwJpP8BuWngnrVJ2wVLxvY4z8m12UH1UJ8MCH
         2WuNvPXjnEwl4p2Zb6D2wAVYykk5xAJLCufX42ftCyx6L9C3xdyn9VeXLz9cv1RKbV8z
         i7oEtbYh1a1ES4ELETAIlj6powjv1WiTNv4JU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] IDE fixes
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Date: Wed, 25 Feb 2009 20:54:07 +0100
Message-Id: <200902252054.07961.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


amd74xx/atiixp bugfixes (from Roel Kluin), host driver module removal
issue fix (debugged/tested by Stanislaw Gruszka) and ide documentation
updates (from David Fries)

Linus, Please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 Documentation/kernel-parameters.txt |    6 ++++--
 drivers/ide/Kconfig                 |    2 +-
 drivers/ide/amd74xx.c               |    2 +-
 drivers/ide/atiixp.c                |    4 ++--
 drivers/ide/ide-cd.c                |   35 ++++++++++++++++++++++++++---------
 drivers/ide/ide-cd.h                |    2 +-
 drivers/ide/ide-gd.c                |   26 +++++++++++++++++---------
 drivers/ide/ide-gd.h                |    2 +-
 drivers/ide/ide-tape.c              |   29 +++++++++++++++++++----------
 drivers/ide/ide.c                   |   11 ++++++++---
 drivers/ide/it821x.c                |    5 ++---
 include/linux/ide.h                 |    2 +-
 12 files changed, 83 insertions(+), 43 deletions(-)


Bartlomiej Zolnierkiewicz (3):
      it821x: remove dead URL
      ide-cd: document capacity hack
      ide: fix refcounting in device drivers

David Fries (1):
      ide: ide.c 'clear' fix, update "ide=nodma" documentation

Roel Kluin (2):
      amd74xx: device/vendor confusion
      atiixp: fix missing parentheses


diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 319785b..0ed3234 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -868,8 +868,10 @@ and is between 256 and 4096 characters. It is defined in the file
 	icn=		[HW,ISDN]
 			Format: <io>[,<membase>[,<icn_id>[,<icn_id2>]]]
 
-	ide=		[HW] (E)IDE subsystem
-			Format: ide=nodma or ide=doubler
+	ide-core.nodma=	[HW] (E)IDE subsystem
+			Format: =0.0 to prevent dma on hda, =0.1 hdb =1.0 hdc
+			.vlb_clock .pci_clock .noflush .noprobe .nowerr .cdrom
+			.chs .ignore_cable are additional options
 			See Documentation/ide/ide.txt.
 
 	idebus=		[HW] (E)IDE subsystem - VLB/PCI bus speed
diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index 3dad229..e072903 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -46,7 +46,7 @@ menuconfig IDE
 	  SMART parameters from disk drives.
 
 	  To compile this driver as a module, choose M here: the
-	  module will be called ide.
+	  module will be called ide-core.ko.
 
 	  For further information, please read <file:Documentation/ide/ide.txt>.
 
diff --git a/drivers/ide/amd74xx.c b/drivers/ide/amd74xx.c
index 69660a4..77267c8 100644
--- a/drivers/ide/amd74xx.c
+++ b/drivers/ide/amd74xx.c
@@ -166,7 +166,7 @@ static unsigned int init_chipset_amd74xx(struct pci_dev *dev)
 	 * Check for broken FIFO support.
 	 */
 	if (dev->vendor == PCI_VENDOR_ID_AMD &&
-	    dev->vendor == PCI_DEVICE_ID_AMD_VIPER_7411)
+	    dev->device == PCI_DEVICE_ID_AMD_VIPER_7411)
 		t &= 0x0f;
 	else
 		t |= 0xf0;
diff --git a/drivers/ide/atiixp.c b/drivers/ide/atiixp.c
index b2735d2..ecd1e62 100644
--- a/drivers/ide/atiixp.c
+++ b/drivers/ide/atiixp.c
@@ -52,7 +52,7 @@ static void atiixp_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
 	struct pci_dev *dev = to_pci_dev(drive->hwif->dev);
 	unsigned long flags;
-	int timing_shift = (drive->dn & 2) ? 16 : 0 + (drive->dn & 1) ? 0 : 8;
+	int timing_shift = (drive->dn ^ 1) * 8;
 	u32 pio_timing_data;
 	u16 pio_mode_data;
 
@@ -85,7 +85,7 @@ static void atiixp_set_dma_mode(ide_drive_t *drive, const u8 speed)
 {
 	struct pci_dev *dev = to_pci_dev(drive->hwif->dev);
 	unsigned long flags;
-	int timing_shift = (drive->dn & 2) ? 16 : 0 + (drive->dn & 1) ? 0 : 8;
+	int timing_shift = (drive->dn ^ 1) * 8;
 	u32 tmp32;
 	u16 tmp16;
 	u16 udma_ctl = 0;
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 0bfeb0c..ddfbea4 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -55,7 +55,7 @@
 
 static DEFINE_MUTEX(idecd_ref_mutex);
 
-static void ide_cd_release(struct kref *);
+static void ide_cd_release(struct device *);
 
 static struct cdrom_info *ide_cd_get(struct gendisk *disk)
 {
@@ -67,7 +67,7 @@ static struct cdrom_info *ide_cd_get(struct gendisk *disk)
 		if (ide_device_get(cd->drive))
 			cd = NULL;
 		else
-			kref_get(&cd->kref);
+			get_device(&cd->dev);
 
 	}
 	mutex_unlock(&idecd_ref_mutex);
@@ -79,7 +79,7 @@ static void ide_cd_put(struct cdrom_info *cd)
 	ide_drive_t *drive = cd->drive;
 
 	mutex_lock(&idecd_ref_mutex);
-	kref_put(&cd->kref, ide_cd_release);
+	put_device(&cd->dev);
 	ide_device_put(drive);
 	mutex_unlock(&idecd_ref_mutex);
 }
@@ -194,6 +194,14 @@ static void cdrom_analyze_sense_data(ide_drive_t *drive,
 			bio_sectors = max(bio_sectors(failed_command->bio), 4U);
 			sector &= ~(bio_sectors - 1);
 
+			/*
+			 * The SCSI specification allows for the value
+			 * returned by READ CAPACITY to be up to 75 2K
+			 * sectors past the last readable block.
+			 * Therefore, if we hit a medium error within the
+			 * last 75 2K sectors, we decrease the saved size
+			 * value.
+			 */
 			if (sector < get_capacity(info->disk) &&
 			    drive->probed_capacity - sector < 4 * 75)
 				set_capacity(info->disk, sector);
@@ -1790,15 +1798,17 @@ static void ide_cd_remove(ide_drive_t *drive)
 	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
 
 	ide_proc_unregister_driver(drive, info->driver);
-
+	device_del(&info->dev);
 	del_gendisk(info->disk);
 
-	ide_cd_put(info);
+	mutex_lock(&idecd_ref_mutex);
+	put_device(&info->dev);
+	mutex_unlock(&idecd_ref_mutex);
 }
 
-static void ide_cd_release(struct kref *kref)
+static void ide_cd_release(struct device *dev)
 {
-	struct cdrom_info *info = to_ide_drv(kref, cdrom_info);
+	struct cdrom_info *info = to_ide_drv(dev, cdrom_info);
 	struct cdrom_device_info *devinfo = &info->devinfo;
 	ide_drive_t *drive = info->drive;
 	struct gendisk *g = info->disk;
@@ -1997,7 +2007,12 @@ static int ide_cd_probe(ide_drive_t *drive)
 
 	ide_init_disk(g, drive);
 
-	kref_init(&info->kref);
+	info->dev.parent = &drive->gendev;
+	info->dev.release = ide_cd_release;
+	dev_set_name(&info->dev, dev_name(&drive->gendev));
+
+	if (device_register(&info->dev))
+		goto out_free_disk;
 
 	info->drive = drive;
 	info->driver = &ide_cdrom_driver;
@@ -2011,7 +2026,7 @@ static int ide_cd_probe(ide_drive_t *drive)
 	g->driverfs_dev = &drive->gendev;
 	g->flags = GENHD_FL_CD | GENHD_FL_REMOVABLE;
 	if (ide_cdrom_setup(drive)) {
-		ide_cd_release(&info->kref);
+		put_device(&info->dev);
 		goto failed;
 	}
 
@@ -2021,6 +2036,8 @@ static int ide_cd_probe(ide_drive_t *drive)
 	add_disk(g);
 	return 0;
 
+out_free_disk:
+	put_disk(g);
 out_free_cd:
 	kfree(info);
 failed:
diff --git a/drivers/ide/ide-cd.h b/drivers/ide/ide-cd.h
index ac40d6c..c878bfc 100644
--- a/drivers/ide/ide-cd.h
+++ b/drivers/ide/ide-cd.h
@@ -80,7 +80,7 @@ struct cdrom_info {
 	ide_drive_t		*drive;
 	struct ide_driver	*driver;
 	struct gendisk		*disk;
-	struct kref		kref;
+	struct device		dev;
 
 	/* Buffer for table of contents.  NULL if we haven't allocated
 	   a TOC buffer for this device yet. */
diff --git a/drivers/ide/ide-gd.c b/drivers/ide/ide-gd.c
index 7857b20..0471094 100644
--- a/drivers/ide/ide-gd.c
+++ b/drivers/ide/ide-gd.c
@@ -25,7 +25,7 @@ module_param(debug_mask, ulong, 0644);
 
 static DEFINE_MUTEX(ide_disk_ref_mutex);
 
-static void ide_disk_release(struct kref *);
+static void ide_disk_release(struct device *);
 
 static struct ide_disk_obj *ide_disk_get(struct gendisk *disk)
 {
@@ -37,7 +37,7 @@ static struct ide_disk_obj *ide_disk_get(struct gendisk *disk)
 		if (ide_device_get(idkp->drive))
 			idkp = NULL;
 		else
-			kref_get(&idkp->kref);
+			get_device(&idkp->dev);
 	}
 	mutex_unlock(&ide_disk_ref_mutex);
 	return idkp;
@@ -48,7 +48,7 @@ static void ide_disk_put(struct ide_disk_obj *idkp)
 	ide_drive_t *drive = idkp->drive;
 
 	mutex_lock(&ide_disk_ref_mutex);
-	kref_put(&idkp->kref, ide_disk_release);
+	put_device(&idkp->dev);
 	ide_device_put(drive);
 	mutex_unlock(&ide_disk_ref_mutex);
 }
@@ -66,17 +66,18 @@ static void ide_gd_remove(ide_drive_t *drive)
 	struct gendisk *g = idkp->disk;
 
 	ide_proc_unregister_driver(drive, idkp->driver);
-
+	device_del(&idkp->dev);
 	del_gendisk(g);
-
 	drive->disk_ops->flush(drive);
 
-	ide_disk_put(idkp);
+	mutex_lock(&ide_disk_ref_mutex);
+	put_device(&idkp->dev);
+	mutex_unlock(&ide_disk_ref_mutex);
 }
 
-static void ide_disk_release(struct kref *kref)
+static void ide_disk_release(struct device *dev)
 {
-	struct ide_disk_obj *idkp = to_ide_drv(kref, ide_disk_obj);
+	struct ide_disk_obj *idkp = to_ide_drv(dev, ide_disk_obj);
 	ide_drive_t *drive = idkp->drive;
 	struct gendisk *g = idkp->disk;
 
@@ -348,7 +349,12 @@ static int ide_gd_probe(ide_drive_t *drive)
 
 	ide_init_disk(g, drive);
 
-	kref_init(&idkp->kref);
+	idkp->dev.parent = &drive->gendev;
+	idkp->dev.release = ide_disk_release;
+	dev_set_name(&idkp->dev, dev_name(&drive->gendev));
+
+	if (device_register(&idkp->dev))
+		goto out_free_disk;
 
 	idkp->drive = drive;
 	idkp->driver = &ide_gd_driver;
@@ -373,6 +379,8 @@ static int ide_gd_probe(ide_drive_t *drive)
 	add_disk(g);
 	return 0;
 
+out_free_disk:
+	put_disk(g);
 out_free_idkp:
 	kfree(idkp);
 failed:
diff --git a/drivers/ide/ide-gd.h b/drivers/ide/ide-gd.h
index a86779f..b604bdd 100644
--- a/drivers/ide/ide-gd.h
+++ b/drivers/ide/ide-gd.h
@@ -17,7 +17,7 @@ struct ide_disk_obj {
 	ide_drive_t		*drive;
 	struct ide_driver	*driver;
 	struct gendisk		*disk;
-	struct kref		kref;
+	struct device		dev;
 	unsigned int		openers;	/* protected by BKL for now */
 
 	/* Last failed packet command */
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index d7ecd3c..bb450a7 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -169,7 +169,7 @@ typedef struct ide_tape_obj {
 	ide_drive_t		*drive;
 	struct ide_driver	*driver;
 	struct gendisk		*disk;
-	struct kref		kref;
+	struct device		dev;
 
 	/*
 	 *	failed_pc points to the last failed packet command, or contains
@@ -267,7 +267,7 @@ static DEFINE_MUTEX(idetape_ref_mutex);
 
 static struct class *idetape_sysfs_class;
 
-static void ide_tape_release(struct kref *);
+static void ide_tape_release(struct device *);
 
 static struct ide_tape_obj *ide_tape_get(struct gendisk *disk)
 {
@@ -279,7 +279,7 @@ static struct ide_tape_obj *ide_tape_get(struct gendisk *disk)
 		if (ide_device_get(tape->drive))
 			tape = NULL;
 		else
-			kref_get(&tape->kref);
+			get_device(&tape->dev);
 	}
 	mutex_unlock(&idetape_ref_mutex);
 	return tape;
@@ -290,7 +290,7 @@ static void ide_tape_put(struct ide_tape_obj *tape)
 	ide_drive_t *drive = tape->drive;
 
 	mutex_lock(&idetape_ref_mutex);
-	kref_put(&tape->kref, ide_tape_release);
+	put_device(&tape->dev);
 	ide_device_put(drive);
 	mutex_unlock(&idetape_ref_mutex);
 }
@@ -308,7 +308,7 @@ static struct ide_tape_obj *ide_tape_chrdev_get(unsigned int i)
 	mutex_lock(&idetape_ref_mutex);
 	tape = idetape_devs[i];
 	if (tape)
-		kref_get(&tape->kref);
+		get_device(&tape->dev);
 	mutex_unlock(&idetape_ref_mutex);
 	return tape;
 }
@@ -2256,15 +2256,17 @@ static void ide_tape_remove(ide_drive_t *drive)
 	idetape_tape_t *tape = drive->driver_data;
 
 	ide_proc_unregister_driver(drive, tape->driver);
-
+	device_del(&tape->dev);
 	ide_unregister_region(tape->disk);
 
-	ide_tape_put(tape);
+	mutex_lock(&idetape_ref_mutex);
+	put_device(&tape->dev);
+	mutex_unlock(&idetape_ref_mutex);
 }
 
-static void ide_tape_release(struct kref *kref)
+static void ide_tape_release(struct device *dev)
 {
-	struct ide_tape_obj *tape = to_ide_drv(kref, ide_tape_obj);
+	struct ide_tape_obj *tape = to_ide_drv(dev, ide_tape_obj);
 	ide_drive_t *drive = tape->drive;
 	struct gendisk *g = tape->disk;
 
@@ -2407,7 +2409,12 @@ static int ide_tape_probe(ide_drive_t *drive)
 
 	ide_init_disk(g, drive);
 
-	kref_init(&tape->kref);
+	tape->dev.parent = &drive->gendev;
+	tape->dev.release = ide_tape_release;
+	dev_set_name(&tape->dev, dev_name(&drive->gendev));
+
+	if (device_register(&tape->dev))
+		goto out_free_disk;
 
 	tape->drive = drive;
 	tape->driver = &idetape_driver;
@@ -2436,6 +2443,8 @@ static int ide_tape_probe(ide_drive_t *drive)
 
 	return 0;
 
+out_free_disk:
+	put_disk(g);
 out_free_tape:
 	kfree(tape);
 failed:
diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index 258805d..0920e3b 100644
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -337,6 +337,7 @@ static int ide_set_dev_param_mask(const char *s, struct kernel_param *kp)
 	int a, b, i, j = 1;
 	unsigned int *dev_param_mask = (unsigned int *)kp->arg;
 
+	/* controller . device (0 or 1) [ : 1 (set) | 0 (clear) ] */
 	if (sscanf(s, "%d.%d:%d", &a, &b, &j) != 3 &&
 	    sscanf(s, "%d.%d", &a, &b) != 2)
 		return -EINVAL;
@@ -349,7 +350,7 @@ static int ide_set_dev_param_mask(const char *s, struct kernel_param *kp)
 	if (j)
 		*dev_param_mask |= (1 << i);
 	else
-		*dev_param_mask &= (1 << i);
+		*dev_param_mask &= ~(1 << i);
 
 	return 0;
 }
@@ -392,6 +393,8 @@ static int ide_set_disk_chs(const char *str, struct kernel_param *kp)
 {
 	int a, b, c = 0, h = 0, s = 0, i, j = 1;
 
+	/* controller . device (0 or 1) : Cylinders , Heads , Sectors */
+	/* controller . device (0 or 1) : 1 (use CHS) | 0 (ignore CHS) */
 	if (sscanf(str, "%d.%d:%d,%d,%d", &a, &b, &c, &h, &s) != 5 &&
 	    sscanf(str, "%d.%d:%d", &a, &b, &j) != 3)
 		return -EINVAL;
@@ -407,7 +410,7 @@ static int ide_set_disk_chs(const char *str, struct kernel_param *kp)
 	if (j)
 		ide_disks |= (1 << i);
 	else
-		ide_disks &= (1 << i);
+		ide_disks &= ~(1 << i);
 
 	ide_disks_chs[i].cyl  = c;
 	ide_disks_chs[i].head = h;
@@ -469,6 +472,8 @@ static int ide_set_ignore_cable(const char *s, struct kernel_param *kp)
 {
 	int i, j = 1;
 
+	/* controller (ignore) */
+	/* controller : 1 (ignore) | 0 (use) */
 	if (sscanf(s, "%d:%d", &i, &j) != 2 && sscanf(s, "%d", &i) != 1)
 		return -EINVAL;
 
@@ -478,7 +483,7 @@ static int ide_set_ignore_cable(const char *s, struct kernel_param *kp)
 	if (j)
 		ide_ignore_cable |= (1 << i);
 	else
-		ide_ignore_cable &= (1 << i);
+		ide_ignore_cable &= ~(1 << i);
 
 	return 0;
 }
diff --git a/drivers/ide/it821x.c b/drivers/ide/it821x.c
index e1c4f54..13b8153 100644
--- a/drivers/ide/it821x.c
+++ b/drivers/ide/it821x.c
@@ -5,9 +5,8 @@
  *  May be copied or modified under the terms of the GNU General Public License
  *  Based in part on the ITE vendor provided SCSI driver.
  *
- *  Documentation available from
- * 	http://www.ite.com.tw/pc/IT8212F_V04.pdf
- *  Some other documents are NDA.
+ *  Documentation:
+ *	Datasheet is freely available, some other documents under NDA.
  *
  *  The ITE8212 isn't exactly a standard IDE controller. It has two
  *  modes. In pass through mode then it is an IDE controller. In its smart
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 194da5a..fe235b6 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -663,7 +663,7 @@ typedef struct ide_drive_s ide_drive_t;
 #define to_ide_device(dev)		container_of(dev, ide_drive_t, gendev)
 
 #define to_ide_drv(obj, cont_type)	\
-	container_of(obj, struct cont_type, kref)
+	container_of(obj, struct cont_type, dev)
 
 #define ide_drv_g(disk, cont_type)	\
 	container_of((disk)->private_data, struct cont_type, driver)
