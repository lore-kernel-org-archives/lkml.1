Return-Path: <linux-kernel-owner+w=401wt.eu-S1755742AbZFGNpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742AbZFGNpP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 09:45:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755296AbZFGNoz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 09:44:55 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:37756 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755443AbZFGNou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 09:44:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:user-agent:cc:mime-version:content-disposition:date
         :message-id:content-type:content-transfer-encoding;
        b=WdkKEkFwqwwsbTqDleYsvQ7p4Hi9wBjsHw5co/8wfAs2vhpDRI13ZLnWiQXv6W6yAp
         mMf2neeG3ZxE6udewZTfKAP+Ec/XVmYro/tfDoocPUKg30zRYI0BZ5cRbKUVbCgoQjJ4
         4M6EUXmNqolE7BkV27OMsW/Kq7IqtBtbwertM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] IDE fixes
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Date: Sun, 7 Jun 2009 14:44:32 +0200
Message-Id: <200906071444.33047.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Fixes for pdc202xx_old host driver and for Host Protected Area (HPA) support.

The latter ones come a bit late but since they were tested and reviewed
(fs/partitions/ part was acked by Al, drivers/ide/ parts by Alan and Sergei)
I see no real reason to delay them till 2.6.31, especially since they should
make everyone's life easier (as we have now the same default HPA behavior in
both ide/libata).


Linus, please pull from 'for-linus' branch of:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git for-linus

to receive the following updates:

 Documentation/ide/ide.txt           |    2 +
 Documentation/kernel-parameters.txt |    7 +--
 drivers/ide/ide-disk.c              |   71 ++++++++++++++++++++++++++++++-----
 drivers/ide/ide-gd.c                |   14 +++++++
 drivers/ide/ide.c                   |   10 +++++
 drivers/ide/pdc202xx_old.c          |   22 +++--------
 fs/partitions/check.c               |   42 ++++++++++++++++-----
 include/linux/blkdev.h              |    2 +
 include/linux/genhd.h               |    1 +
 include/linux/ide.h                 |    6 ++-
 10 files changed, 134 insertions(+), 43 deletions(-)


Bartlomiej Zolnierkiewicz (4):
      partitions: warn about the partition exceeding device capacity
      partitions: add ->set_capacity block device method
      ide-gd: implement block device ->set_capacity method (v2)
      ide: preserve Host Protected Area by default (v2)

Sergei Shtylyov (2):
      pdc202xx_old: fix 'pdc20246_dma_ops'
      pdc202xx_old: fix resetproc() method


diff --git a/Documentation/ide/ide.txt b/Documentation/ide/ide.txt
index 0c78f4b..e77bebf 100644
--- a/Documentation/ide/ide.txt
+++ b/Documentation/ide/ide.txt
@@ -216,6 +216,8 @@ Other kernel parameters for ide_core are:
 
 * "noflush=[interface_number.device_number]" to disable flush requests
 
+* "nohpa=[interface_number.device_number]" to disable Host Protected Area
+
 * "noprobe=[interface_number.device_number]" to skip probing
 
 * "nowerr=[interface_number.device_number]" to ignore the WRERR_STAT bit
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index a19f021..e58c91c 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -835,11 +835,8 @@ and is between 256 and 4096 characters. It is defined in the file
 
 	ide-core.nodma=	[HW] (E)IDE subsystem
 			Format: =0.0 to prevent dma on hda, =0.1 hdb =1.0 hdc
-			.vlb_clock .pci_clock .noflush .noprobe .nowerr .cdrom
-			.chs .ignore_cable are additional options
-			See Documentation/ide/ide.txt.
-
-	idebus=		[HW] (E)IDE subsystem - VLB/PCI bus speed
+			.vlb_clock .pci_clock .noflush .nohpa .noprobe .nowerr
+			.cdrom .chs .ignore_cable are additional options
 			See Documentation/ide/ide.txt.
 
 	ide-pci-generic.all-generic-ide [HW] (E)IDE subsystem
diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index a9fbe2c..3d92c9d 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -302,14 +302,12 @@ static const struct drive_list_entry hpa_list[] = {
 	{ NULL,		NULL }
 };
 
-static void idedisk_check_hpa(ide_drive_t *drive)
+static u64 ide_disk_hpa_get_native_capacity(ide_drive_t *drive, int lba48)
 {
-	unsigned long long capacity, set_max;
-	int lba48 = ata_id_lba48_enabled(drive->id);
+	u64 capacity, set_max;
 
 	capacity = drive->capacity64;
-
-	set_max = idedisk_read_native_max_address(drive, lba48);
+	set_max  = idedisk_read_native_max_address(drive, lba48);
 
 	if (ide_in_drive_list(drive->id, hpa_list)) {
 		/*
@@ -320,9 +318,31 @@ static void idedisk_check_hpa(ide_drive_t *drive)
 			set_max--;
 	}
 
+	return set_max;
+}
+
+static u64 ide_disk_hpa_set_capacity(ide_drive_t *drive, u64 set_max, int lba48)
+{
+	set_max = idedisk_set_max_address(drive, set_max, lba48);
+	if (set_max)
+		drive->capacity64 = set_max;
+
+	return set_max;
+}
+
+static void idedisk_check_hpa(ide_drive_t *drive)
+{
+	u64 capacity, set_max;
+	int lba48 = ata_id_lba48_enabled(drive->id);
+
+	capacity = drive->capacity64;
+	set_max  = ide_disk_hpa_get_native_capacity(drive, lba48);
+
 	if (set_max <= capacity)
 		return;
 
+	drive->probed_capacity = set_max;
+
 	printk(KERN_INFO "%s: Host Protected Area detected.\n"
 			 "\tcurrent capacity is %llu sectors (%llu MB)\n"
 			 "\tnative  capacity is %llu sectors (%llu MB)\n",
@@ -330,13 +350,13 @@ static void idedisk_check_hpa(ide_drive_t *drive)
 			 capacity, sectors_to_MB(capacity),
 			 set_max, sectors_to_MB(set_max));
 
-	set_max = idedisk_set_max_address(drive, set_max, lba48);
+	if ((drive->dev_flags & IDE_DFLAG_NOHPA) == 0)
+		return;
 
-	if (set_max) {
-		drive->capacity64 = set_max;
+	set_max = ide_disk_hpa_set_capacity(drive, set_max, lba48);
+	if (set_max)
 		printk(KERN_INFO "%s: Host Protected Area disabled.\n",
 				 drive->name);
-	}
 }
 
 static int ide_disk_get_capacity(ide_drive_t *drive)
@@ -358,6 +378,8 @@ static int ide_disk_get_capacity(ide_drive_t *drive)
 		drive->capacity64 = drive->cyl * drive->head * drive->sect;
 	}
 
+	drive->probed_capacity = drive->capacity64;
+
 	if (lba) {
 		drive->dev_flags |= IDE_DFLAG_LBA;
 
@@ -376,7 +398,7 @@ static int ide_disk_get_capacity(ide_drive_t *drive)
 		       "%llu sectors (%llu MB)\n",
 		       drive->name, (unsigned long long)drive->capacity64,
 		       sectors_to_MB(drive->capacity64));
-		drive->capacity64 = 1ULL << 28;
+		drive->probed_capacity = drive->capacity64 = 1ULL << 28;
 	}
 
 	if ((drive->hwif->host_flags & IDE_HFLAG_NO_LBA48_DMA) &&
@@ -392,6 +414,34 @@ static int ide_disk_get_capacity(ide_drive_t *drive)
 	return 0;
 }
 
+static u64 ide_disk_set_capacity(ide_drive_t *drive, u64 capacity)
+{
+	u64 set = min(capacity, drive->probed_capacity);
+	u16 *id = drive->id;
+	int lba48 = ata_id_lba48_enabled(id);
+
+	if ((drive->dev_flags & IDE_DFLAG_LBA) == 0 ||
+	    ata_id_hpa_enabled(id) == 0)
+		goto out;
+
+	/*
+	 * according to the spec the SET MAX ADDRESS command shall be
+	 * immediately preceded by a READ NATIVE MAX ADDRESS command
+	 */
+	capacity = ide_disk_hpa_get_native_capacity(drive, lba48);
+	if (capacity == 0)
+		goto out;
+
+	set = ide_disk_hpa_set_capacity(drive, set, lba48);
+	if (set) {
+		/* needed for ->resume to disable HPA */
+		drive->dev_flags |= IDE_DFLAG_NOHPA;
+		return set;
+	}
+out:
+	return drive->capacity64;
+}
+
 static void idedisk_prepare_flush(struct request_queue *q, struct request *rq)
 {
 	ide_drive_t *drive = q->queuedata;
@@ -741,6 +791,7 @@ static int ide_disk_set_doorlock(ide_drive_t *drive, struct gendisk *disk,
 
 const struct ide_disk_ops ide_ata_disk_ops = {
 	.check		= ide_disk_check,
+	.set_capacity	= ide_disk_set_capacity,
 	.get_capacity	= ide_disk_get_capacity,
 	.setup		= ide_disk_setup,
 	.flush		= ide_disk_flush,
diff --git a/drivers/ide/ide-gd.c b/drivers/ide/ide-gd.c
index 4b6b71e..2141190 100644
--- a/drivers/ide/ide-gd.c
+++ b/drivers/ide/ide-gd.c
@@ -287,6 +287,19 @@ static int ide_gd_media_changed(struct gendisk *disk)
 	return ret;
 }
 
+static unsigned long long ide_gd_set_capacity(struct gendisk *disk,
+					      unsigned long long capacity)
+{
+	struct ide_disk_obj *idkp = ide_drv_g(disk, ide_disk_obj);
+	ide_drive_t *drive = idkp->drive;
+	const struct ide_disk_ops *disk_ops = drive->disk_ops;
+
+	if (disk_ops->set_capacity)
+		return disk_ops->set_capacity(drive, capacity);
+
+	return drive->capacity64;
+}
+
 static int ide_gd_revalidate_disk(struct gendisk *disk)
 {
 	struct ide_disk_obj *idkp = ide_drv_g(disk, ide_disk_obj);
@@ -315,6 +328,7 @@ static struct block_device_operations ide_gd_ops = {
 	.locked_ioctl		= ide_gd_ioctl,
 	.getgeo			= ide_gd_getgeo,
 	.media_changed		= ide_gd_media_changed,
+	.set_capacity		= ide_gd_set_capacity,
 	.revalidate_disk	= ide_gd_revalidate_disk
 };
 
diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index 92c9b90..16d0569 100644
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -211,6 +211,11 @@ static unsigned int ide_noflush;
 module_param_call(noflush, ide_set_dev_param_mask, NULL, &ide_noflush, 0);
 MODULE_PARM_DESC(noflush, "disable flush requests for a device");
 
+static unsigned int ide_nohpa;
+
+module_param_call(nohpa, ide_set_dev_param_mask, NULL, &ide_nohpa, 0);
+MODULE_PARM_DESC(nohpa, "disable Host Protected Area for a device");
+
 static unsigned int ide_noprobe;
 
 module_param_call(noprobe, ide_set_dev_param_mask, NULL, &ide_noprobe, 0);
@@ -281,6 +286,11 @@ static void ide_dev_apply_params(ide_drive_t *drive, u8 unit)
 				 drive->name);
 		drive->dev_flags |= IDE_DFLAG_NOFLUSH;
 	}
+	if (ide_nohpa & (1 << i)) {
+		printk(KERN_INFO "ide: disabling Host Protected Area for %s\n",
+				 drive->name);
+		drive->dev_flags |= IDE_DFLAG_NOHPA;
+	}
 	if (ide_noprobe & (1 << i)) {
 		printk(KERN_INFO "ide: skipping probe for %s\n", drive->name);
 		drive->dev_flags |= IDE_DFLAG_NOPROBE;
diff --git a/drivers/ide/pdc202xx_old.c b/drivers/ide/pdc202xx_old.c
index 248a54b..b3bc96f 100644
--- a/drivers/ide/pdc202xx_old.c
+++ b/drivers/ide/pdc202xx_old.c
@@ -1,6 +1,6 @@
 /*
  *  Copyright (C) 1998-2002		Andre Hedrick <andre@linux-ide.org>
- *  Copyright (C) 2006-2007		MontaVista Software, Inc.
+ *  Copyright (C) 2006-2007, 2009	MontaVista Software, Inc.
  *  Copyright (C) 2007			Bartlomiej Zolnierkiewicz
  *
  *  Portions Copyright (C) 1999 Promise Technology, Inc.
@@ -227,28 +227,19 @@ somebody_else:
 	return (dma_stat & 4) == 4;	/* return 1 if INTR asserted */
 }
 
-static void pdc202xx_reset_host (ide_hwif_t *hwif)
+static void pdc202xx_reset(ide_drive_t *drive)
 {
+	ide_hwif_t *hwif	= drive->hwif;
 	unsigned long high_16	= hwif->extra_base - 16;
 	u8 udma_speed_flag	= inb(high_16 | 0x001f);
 
+	printk(KERN_WARNING "PDC202xx: software reset...\n");
+
 	outb(udma_speed_flag | 0x10, high_16 | 0x001f);
 	mdelay(100);
 	outb(udma_speed_flag & ~0x10, high_16 | 0x001f);
 	mdelay(2000);	/* 2 seconds ?! */
 
-	printk(KERN_WARNING "PDC202XX: %s channel reset.\n",
-		hwif->channel ? "Secondary" : "Primary");
-}
-
-static void pdc202xx_reset (ide_drive_t *drive)
-{
-	ide_hwif_t *hwif	= drive->hwif;
-	ide_hwif_t *mate	= hwif->mate;
-
-	pdc202xx_reset_host(hwif);
-	pdc202xx_reset_host(mate);
-
 	ide_set_max_pio(drive);
 }
 
@@ -328,9 +319,8 @@ static const struct ide_dma_ops pdc20246_dma_ops = {
 	.dma_start		= ide_dma_start,
 	.dma_end		= ide_dma_end,
 	.dma_test_irq		= pdc202xx_dma_test_irq,
-	.dma_lost_irq		= pdc202xx_dma_lost_irq,
+	.dma_lost_irq		= ide_dma_lost_irq,
 	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
-	.dma_clear		= pdc202xx_reset,
 	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
 
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 99e33ef..4bc2c43 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -546,27 +546,49 @@ int rescan_partitions(struct gendisk *disk, struct block_device *bdev)
 
 	/* add partitions */
 	for (p = 1; p < state->limit; p++) {
-		sector_t size = state->parts[p].size;
-		sector_t from = state->parts[p].from;
+		sector_t size, from;
+try_scan:
+		size = state->parts[p].size;
 		if (!size)
 			continue;
+
+		from = state->parts[p].from;
 		if (from >= get_capacity(disk)) {
 			printk(KERN_WARNING
 			       "%s: p%d ignored, start %llu is behind the end of the disk\n",
 			       disk->disk_name, p, (unsigned long long) from);
 			continue;
 		}
+
 		if (from + size > get_capacity(disk)) {
-			/*
-			 * we can not ignore partitions of broken tables
-			 * created by for example camera firmware, but we
-			 * limit them to the end of the disk to avoid
-			 * creating invalid block devices
-			 */
+			struct block_device_operations *bdops = disk->fops;
+			unsigned long long capacity;
+
 			printk(KERN_WARNING
-			       "%s: p%d size %llu limited to end of disk\n",
+			       "%s: p%d size %llu exceeds device capacity, ",
 			       disk->disk_name, p, (unsigned long long) size);
-			size = get_capacity(disk) - from;
+
+			if (bdops->set_capacity &&
+			    (disk->flags & GENHD_FL_NATIVE_CAPACITY) == 0) {
+				printk(KERN_CONT "enabling native capacity\n");
+				capacity = bdops->set_capacity(disk, ~0ULL);
+				disk->flags |= GENHD_FL_NATIVE_CAPACITY;
+				if (capacity > get_capacity(disk)) {
+					set_capacity(disk, capacity);
+					check_disk_size_change(disk, bdev);
+					bdev->bd_invalidated = 0;
+				}
+				goto try_scan;
+			} else {
+				/*
+				 * we can not ignore partitions of broken tables
+				 * created by for example camera firmware, but
+				 * we limit them to the end of the disk to avoid
+				 * creating invalid block devices
+				 */
+				printk(KERN_CONT "limited to end of disk\n");
+				size = get_capacity(disk) - from;
+			}
 		}
 		part = add_partition(disk, p, from, size,
 				     state->parts[p].flags);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 6f841fb..a2d7298 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1106,6 +1106,8 @@ struct block_device_operations {
 	int (*direct_access) (struct block_device *, sector_t,
 						void **, unsigned long *);
 	int (*media_changed) (struct gendisk *);
+	unsigned long long (*set_capacity) (struct gendisk *,
+						unsigned long long);
 	int (*revalidate_disk) (struct gendisk *);
 	int (*getgeo)(struct block_device *, struct hd_geometry *);
 	struct module *owner;
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 634c530..239e24b 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -113,6 +113,7 @@ struct hd_struct {
 #define GENHD_FL_UP				16
 #define GENHD_FL_SUPPRESS_PARTITION_INFO	32
 #define GENHD_FL_EXT_DEVT			64 /* allow extended devt */
+#define GENHD_FL_NATIVE_CAPACITY		128
 
 #define BLK_SCSI_MAX_CMDS	(256)
 #define BLK_SCSI_CMD_PER_LONG	(BLK_SCSI_MAX_CMDS / (sizeof(long) * 8))
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 9fed365..45dce3b 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -397,6 +397,7 @@ struct ide_drive_s;
 struct ide_disk_ops {
 	int		(*check)(struct ide_drive_s *, const char *);
 	int		(*get_capacity)(struct ide_drive_s *);
+	u64		(*set_capacity)(struct ide_drive_s *, u64);
 	void		(*setup)(struct ide_drive_s *);
 	void		(*flush)(struct ide_drive_s *);
 	int		(*init_media)(struct ide_drive_s *, struct gendisk *);
@@ -474,6 +475,8 @@ enum {
 	IDE_DFLAG_NICE1			= (1 << 5),
 	/* device is physically present */
 	IDE_DFLAG_PRESENT		= (1 << 6),
+	/* disable Host Protected Area */
+	IDE_DFLAG_NOHPA			= (1 << 7),
 	/* id read from device (synthetic if not set) */
 	IDE_DFLAG_ID_READ		= (1 << 8),
 	IDE_DFLAG_NOPROBE		= (1 << 9),
@@ -568,8 +571,7 @@ struct ide_drive_s {
 	unsigned int	drive_data;	/* used by set_pio_mode/dev_select() */
 	unsigned int	failures;	/* current failure count */
 	unsigned int	max_failures;	/* maximum allowed failure count */
-	u64		probed_capacity;/* initial reported media capacity (ide-cd only currently) */
-
+	u64		probed_capacity;/* initial/native media capacity */
 	u64		capacity64;	/* total number of sectors */
 
 	int		lun;		/* logical unit */
