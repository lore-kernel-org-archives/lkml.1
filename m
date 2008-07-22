Return-Path: <linux-kernel-owner+w=401wt.eu-S1757357AbYGVVRn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357AbYGVVRn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 17:17:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755985AbYGVVPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 17:15:05 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:36945 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756576AbYGVVPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 17:15:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=mm3/ixDgrDVz8Hwouy2nsmJsgtiw/vrYMGZDZtmOrZ5LPcKDTenU7ydQ67WiPhuLeS
         mLLqEPtg8/x68aZm14uaopWWa0u0X5t4Q2px+XPq4n6o5F7BhxreLzLHzpsOOTJgh3hM
         cm8FNsDS8Ly4q2PqMIueESSploDtD04tQ0wvk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 22 Jul 2008 23:12:50 +0200
Message-Id: <20080722211250.20478.35402.sendpatchset@localhost.localdomain>
In-Reply-To: <20080722211159.20478.74184.sendpatchset@localhost.localdomain>
References: <20080722211159.20478.74184.sendpatchset@localhost.localdomain>
Subject: [PATCH 07/10] ide: remove drive->driveid
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Factor out HDIO_[OBSOLETE,GET]_IDENTITY ioctls handling
  to ide_get_identity_ioctl().

* Use temporary buffer in ide_get_identity_ioctl() instead
  of accessing drive->id directly.

* Add ide_id_to_hd_driveid() inline to convert raw id into
  struct hd_driveid format (needed on big-endian).

* Use ide_id_to_hd_driveid() in ide_get_identity_ioctl(),
  cleanup ide_fix_driveid() and switch ide to use use raw id.

* Remove no longer needed drive->driveid.

  This leaves us with 3 users of struct hd_driveid in tree:
  - arch/um/drivers/ubd_kern.c
  - drivers/block/xsysace.c
  - drivers/usb/storage/isd200.c

While at it:

* Use ata_id_u{32,64}() and ata_id_has_{dma,lba,iordy}() macros.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-disk.c         |   23 +++++++--------
 drivers/ide/ide-dma.c          |    6 ++--
 drivers/ide/ide-iops.c         |   20 +------------
 drivers/ide/ide-lib.c          |    4 +-
 drivers/ide/ide-probe.c        |   22 +++++++--------
 drivers/ide/ide-timings.c      |    2 -
 drivers/ide/ide.c              |   59 +++++++++++++++++++++++++++++++++++------
 drivers/ide/legacy/qd65xx.c    |    4 +-
 drivers/ide/pci/cs5530.c       |    2 -
 drivers/ide/pci/it821x.c       |    4 +-
 drivers/ide/pci/pdc202xx_old.c |    2 -
 drivers/ide/pci/sc1200.c       |    2 -
 include/linux/ide.h            |    9 +-----
 13 files changed, 90 insertions(+), 69 deletions(-)

Index: b/drivers/ide/ide-disk.c
===================================================================
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -94,13 +94,14 @@ static void ide_disk_put(struct ide_disk
  */
 static int lba_capacity_is_ok(u16 *id)
 {
-	struct hd_driveid *driveid = (struct hd_driveid *)id;
 	unsigned long lba_sects, chs_sects, head, tail;
 
 	/* No non-LBA info .. so valid! */
 	if (id[ATA_ID_CYLS] == 0)
 		return 1;
 
+	lba_sects = ata_id_u32(id, ATA_ID_LBA_CAPACITY);
+
 	/*
 	 * The ATA spec tells large drives to return
 	 * C/H/S = 16383/16/63 independent of their size.
@@ -111,10 +112,9 @@ static int lba_capacity_is_ok(u16 *id)
 	     (id[ATA_ID_CYLS] == 4092 && id[ATA_ID_CUR_CYLS] == 16383)) &&
 	    id[ATA_ID_SECTORS] == 63 &&
 	    (id[ATA_ID_HEADS] == 15 || id[ATA_ID_HEADS] == 16) &&
-	    (driveid->lba_capacity >= 16383 * 63 * id[ATA_ID_HEADS]))
+	    (lba_sects >= 16383 * 63 * id[ATA_ID_HEADS]))
 		return 1;
 
-	lba_sects = driveid->lba_capacity;
 	chs_sects = id[ATA_ID_CYLS] * id[ATA_ID_HEADS] * id[ATA_ID_SECTORS];
 
 	/* perform a rough sanity check on lba_sects:  within 10% is OK */
@@ -126,7 +126,7 @@ static int lba_capacity_is_ok(u16 *id)
 	tail = (lba_sects & 0xffff);
 	lba_sects = (head | (tail << 16));
 	if ((lba_sects - chs_sects) < chs_sects/10) {
-		driveid->lba_capacity = lba_sects;
+		*(__le32 *)&id[ATA_ID_LBA_CAPACITY] = __cpu_to_le32(lba_sects);
 		return 1;	/* lba_capacity is (now) good */
 	}
 
@@ -396,7 +396,7 @@ static inline int idedisk_supports_lba48
 {
 	return (id[ATA_ID_COMMAND_SET_2] & 0x0400) &&
 	       (id[ATA_ID_CFS_ENABLE_2] & 0x0400) &&
-	       ((struct hd_driveid *)id)->lba_capacity_2;
+	       ata_id_u64(id, ATA_ID_LBA_CAPACITY_2);
 }
 
 /*
@@ -463,7 +463,6 @@ static void idedisk_check_hpa(ide_drive_
  */
 static void init_idedisk_capacity(ide_drive_t *drive)
 {
-	struct hd_driveid *driveid = drive->driveid;
 	u16 *id = drive->id;
 	/*
 	 * If this drive supports the Host Protected Area feature set,
@@ -474,13 +473,13 @@ static void init_idedisk_capacity(ide_dr
 	if (idedisk_supports_lba48(id)) {
 		/* drive speaks 48-bit LBA */
 		drive->select.b.lba = 1;
-		drive->capacity64 = driveid->lba_capacity_2;
+		drive->capacity64 = ata_id_u64(id, ATA_ID_LBA_CAPACITY_2);
 		if (hpa)
 			idedisk_check_hpa(drive);
-	} else if ((driveid->capability & 2) && lba_capacity_is_ok(id)) {
+	} else if (ata_id_has_lba(id) && lba_capacity_is_ok(id)) {
 		/* drive speaks 28-bit LBA */
 		drive->select.b.lba = 1;
-		drive->capacity64 = driveid->lba_capacity;
+		drive->capacity64 = ata_id_u32(id, ATA_ID_LBA_CAPACITY);
 		if (hpa)
 			idedisk_check_hpa(drive);
 	} else {
@@ -629,7 +628,7 @@ static int set_multcount(ide_drive_t *dr
 	struct request *rq;
 	int error;
 
-	if (arg < 0 || arg > drive->driveid->max_multsect)
+	if (arg < 0 || arg > (drive->id[ATA_ID_MAX_MULTSECT] & 0xff))
 		return -EINVAL;
 
 	if (drive->special.b.set_multmode)
@@ -782,8 +781,8 @@ static void idedisk_add_settings(ide_dri
 	ide_add_setting(drive, "address", SETTING_RW, TYPE_BYTE, 0, 2, 1, 1,
 			&drive->addressing, set_lba_addressing);
 	ide_add_setting(drive, "multcount", SETTING_RW, TYPE_BYTE, 0,
-			drive->driveid->max_multsect, 1, 1, &drive->mult_count,
-			set_multcount);
+			drive->id[ATA_ID_MAX_MULTSECT] & 0xff, 1, 1,
+			&drive->mult_count, set_multcount);
 	ide_add_setting(drive, "nowerr", SETTING_RW, TYPE_BYTE, 0, 1, 1, 1,
 			&drive->nowerr, set_nowerr);
 	ide_add_setting(drive, "lun", SETTING_RW, TYPE_INT, 0, 7, 1, 1,
Index: b/drivers/ide/ide-dma.c
===================================================================
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -649,8 +649,8 @@ static unsigned int ide_get_mode_mask(id
 	case XFER_SW_DMA_0:
 		if (id[ATA_ID_FIELD_VALID] & 2) {
 			mask = id[ATA_ID_SWDMA_MODES] & hwif->swdma_mask;
-		} else if (drive->driveid->tDMA) {
-			u8 mode = drive->driveid->tDMA;
+		} else if (id[ATA_ID_OLD_DMA_MODES] >> 8) {
+			u8 mode = id[ATA_ID_OLD_DMA_MODES] >> 8;
 
 			/*
 			 * if the mode is valid convert it to the mask
@@ -727,7 +727,7 @@ static int ide_tune_dma(ide_drive_t *dri
 	ide_hwif_t *hwif = drive->hwif;
 	u8 speed;
 
-	if (drive->nodma || (drive->driveid->capability & 1) == 0)
+	if (drive->nodma || ata_id_has_dma(drive->id) == 0)
 		return 0;
 
 	/* consult the list of known "bad" drives */
Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -404,26 +404,10 @@ void ide_fix_driveid(u16 *id)
 {
 #ifndef __LITTLE_ENDIAN
 # ifdef __BIG_ENDIAN
-	struct hd_driveid *driveid = (struct hd_driveid *)id;
 	int i;
 
-	for (i = 0; i < 256; i++) {
-		/*  these words are accessed as two 8-bit values */
-		if (i == 47 || i == 49 || i == 51 || i == 52 || i == 59)
-			continue;
-		if (i == 60 || i == 61)	/* ->lba_capacity is 32-bit */
-			continue;
-		if (i == 98 || i == 99)	/* ->spg is 32-bit */
-			continue;
-		if (i > 99 && i < 104)	/* ->lba_capacity_2 is 64-bit */
-			continue;
-
+	for (i = 0; i < 256; i++)
 		id[i] = __le16_to_cpu(id[i]);
-	}
-
-	driveid->lba_capacity	= __le32_to_cpu(driveid->lba_capacity);
-	driveid->spg		= __le32_to_cpu(driveid->spg);
-	driveid->lba_capacity_2	= __le64_to_cpu(driveid->lba_capacity_2);
 # else
 #  error "Please fix <asm/byteorder.h>"
 # endif
@@ -752,7 +736,7 @@ int ide_config_drive_speed(ide_drive_t *
 #endif
 
 	/* Skip setting PIO flow-control modes on pre-EIDE drives */
-	if ((speed & 0xf8) == XFER_PIO_0 && !(drive->driveid->capability & 8))
+	if ((speed & 0xf8) == XFER_PIO_0 && ata_id_has_iordy(drive->id) == 0)
 		goto skip;
 
 	/*
Index: b/drivers/ide/ide-lib.c
===================================================================
--- a/drivers/ide/ide-lib.c
+++ b/drivers/ide/ide-lib.c
@@ -102,14 +102,14 @@ u8 ide_get_best_pio_mode (ide_drive_t *d
 	if (pio_mode != -1) {
 		printk(KERN_INFO "%s: is on PIO blacklist\n", drive->name);
 	} else {
-		pio_mode = drive->driveid->tPIO;
+		pio_mode = id[ATA_ID_OLD_PIO_MODES] >> 8;
 		if (pio_mode > 2) {	/* 2 is maximum allowed tPIO value */
 			pio_mode = 2;
 			overridden = 1;
 		}
 
 		if (id[ATA_ID_FIELD_VALID] & 2) {	      /* ATA2? */
-			if (drive->driveid->capability & 8) { /* IORDY sup? */
+			if (ata_id_has_iordy(id)) {
 				if (id[ATA_ID_PIO_MODES] & 7) {
 					overridden = 0;
 					if (id[ATA_ID_PIO_MODES] & 4)
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -87,20 +87,20 @@ static void ide_disk_init_chs(ide_drive_
 
 static void ide_disk_init_mult_count(ide_drive_t *drive)
 {
-	struct hd_driveid *id = drive->driveid;
+	u16 *id = drive->id;
+	u8 max_multsect = id[ATA_ID_MAX_MULTSECT] & 0xff;
 
-	if (id->max_multsect) {
+	if (max_multsect) {
 #ifdef CONFIG_IDEDISK_MULTI_MODE
-		if ((id->max_multsect / 2) > 1) {
-			id->multsect = id->max_multsect;
-			id->multsect_valid = 1;
-		} else {
-			id->multsect = 0;
-			id->multsect_valid = 0;
-		}
-		drive->mult_req = id->multsect;
+		if ((max_multsect / 2) > 1)
+			id[ATA_ID_MULTSECT] = max_multsect | 0x100;
+		else
+			id[ATA_ID_MULTSECT] &= ~0x1ff;
+
+		drive->mult_req = id[ATA_ID_MULTSECT] & 0xff;
 #endif
-		if ((id->multsect_valid & 1) && id->multsect)
+		if ((id[ATA_ID_MULTSECT] & 0x100) &&
+		    (id[ATA_ID_MULTSECT] & 0xff))
 			drive->special.b.set_multmode = 1;
 	}
 }
Index: b/drivers/ide/ide-timings.c
===================================================================
--- a/drivers/ide/ide-timings.c
+++ b/drivers/ide/ide-timings.c
@@ -83,7 +83,7 @@ u16 ide_pio_cycle_time(ide_drive_t *driv
 	u16 cycle = 0;
 
 	if (id[ATA_ID_FIELD_VALID] & 2) {
-		if (drive->driveid->capability & 8)
+		if (ata_id_has_iordy(drive->id))
 			cycle = id[ATA_ID_EIDE_PIO_IORDY];
 		else
 			cycle = id[ATA_ID_EIDE_PIO];
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -328,7 +328,7 @@ int set_using_dma(ide_drive_t *drive, in
 	if (arg < 0 || arg > 1)
 		return -EINVAL;
 
-	if ((drive->driveid->capability & 1) == 0)
+	if (ata_id_has_dma(drive->id) == 0)
 		goto out;
 
 	if (hwif->dma_ops == NULL)
@@ -502,12 +502,60 @@ static int generic_drive_reset(ide_drive
 	return ret;
 }
 
+static inline void ide_id_to_hd_driveid(u16 *id)
+{
+#ifdef __BIG_ENDIAN
+	/* accessed in struct hd_driveid as 8-bit values */
+	id[ATA_ID_MAX_MULTSECT]	 = __cpu_to_le16(id[ATA_ID_MAX_MULTSECT]);
+	id[ATA_ID_CAPABILITY]	 = __cpu_to_le16(id[ATA_ID_CAPABILITY]);
+	id[ATA_ID_OLD_PIO_MODES] = __cpu_to_le16(id[ATA_ID_OLD_PIO_MODES]);
+	id[ATA_ID_OLD_DMA_MODES] = __cpu_to_le16(id[ATA_ID_OLD_DMA_MODES]);
+	id[ATA_ID_MULTSECT]	 = __cpu_to_le16(id[ATA_ID_MULTSECT]);
+
+	/* as 32-bit values */
+	*(u32 *)&id[ATA_ID_LBA_CAPACITY] = ata_id_u32(id, ATA_ID_LBA_CAPACITY);
+	*(u32 *)&id[ATA_ID_SPG]		 = ata_id_u32(id, ATA_ID_SPG);
+
+	/* as 64-bit value */
+	*(u64 *)&id[ATA_ID_LBA_CAPACITY_2] =
+		ata_id_u64(id, ATA_ID_LBA_CAPACITY_2);
+#endif
+}
+
+static int ide_get_identity_ioctl(ide_drive_t *drive, unsigned int cmd,
+				  unsigned long arg)
+{
+	u16 *id = NULL;
+	int size = (cmd == HDIO_GET_IDENTITY) ? (ATA_ID_WORDS * 2) : 142;
+	int rc = 0;
+
+	if (drive->id_read == 0) {
+		rc = -ENOMSG;
+		goto out;
+	}
+
+	id = kmalloc(size, GFP_KERNEL);
+	if (id == NULL) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	memcpy(id, drive->id, size);
+	ide_id_to_hd_driveid(id);
+
+	if (copy_to_user((void __user *)arg, id, size))
+		rc = -EFAULT;
+
+	kfree(id);
+out:
+	return rc;
+}
+
 int generic_ide_ioctl(ide_drive_t *drive, struct file *file, struct block_device *bdev,
 			unsigned int cmd, unsigned long arg)
 {
 	unsigned long flags;
 	ide_driver_t *drv;
-	void __user *p = (void __user *)arg;
 	int err = 0, (*setfunc)(ide_drive_t *, int);
 	u8 *val;
 
@@ -528,12 +576,7 @@ int generic_ide_ioctl(ide_drive_t *drive
 		case HDIO_GET_IDENTITY:
 			if (bdev != bdev->bd_contains)
 				return -EINVAL;
-			if (drive->id_read == 0)
-				return -ENOMSG;
-			if (copy_to_user(p, drive->id, (cmd == HDIO_GET_IDENTITY) ? sizeof(*drive->id) : 142))
-				return -EFAULT;
-			return 0;
-
+			return ide_get_identity_ioctl(drive, cmd, arg);
 		case HDIO_GET_NICE:
 			return put_user(drive->dsc_overlap	<<	IDE_NICE_DSC_OVERLAP	|
 					drive->atapi_overlap	<<	IDE_NICE_ATAPI_OVERLAP	|
Index: b/drivers/ide/legacy/qd65xx.c
===================================================================
--- a/drivers/ide/legacy/qd65xx.c
+++ b/drivers/ide/legacy/qd65xx.c
@@ -195,10 +195,10 @@ static void qd6500_set_pio_mode(ide_driv
 	 * FIXME: use "pio" value
 	 */
 	if (!qd_find_disk_type(drive, &active_time, &recovery_time) &&
-	    drive->driveid->tPIO && (id[ATA_ID_FIELD_VALID] & 2) &&
+	    (id[ATA_ID_OLD_PIO_MODES] & 0xff) && (id[ATA_ID_FIELD_VALID] & 2) &&
 	    id[ATA_ID_EIDE_PIO] >= 240) {
 		printk(KERN_INFO "%s: PIO mode%d\n", drive->name,
-				drive->driveid->tPIO);
+			id[ATA_ID_OLD_PIO_MODES] & 0xff);
 		active_time = 110;
 		recovery_time = drive->id[ATA_ID_EIDE_PIO] - 120;
 	}
Index: b/drivers/ide/pci/cs5530.c
===================================================================
--- a/drivers/ide/pci/cs5530.c
+++ b/drivers/ide/pci/cs5530.c
@@ -88,7 +88,7 @@ static u8 cs5530_udma_filter(ide_drive_t
 	if (mate->present == 0)
 		goto out;
 
-	if ((mate->driveid->capability & 1) && __ide_dma_bad_drive(mate) == 0) {
+	if (ata_id_has_dma(mateid) && __ide_dma_bad_drive(mate) == 0) {
 		if ((mateid[ATA_ID_FIELD_VALID] & 4) &&
 		    (mateid[ATA_ID_UDMA_MODES] & 7))
 			goto out;
Index: b/drivers/ide/pci/it821x.c
===================================================================
--- a/drivers/ide/pci/it821x.c
+++ b/drivers/ide/pci/it821x.c
@@ -470,7 +470,7 @@ static void __devinit it821x_quirkproc(i
 			/* In raid mode the ident block is slightly buggy
 			   We need to set the bits so that the IDE layer knows
 			   LBA28. LBA48 and DMA ar valid */
-			drive->driveid->capability |= 3;      /* LBA28, DMA */
+			id[ATA_ID_CAPABILITY]    |= (3 << 8); /* LBA28, DMA */
 			id[ATA_ID_COMMAND_SET_2] |= 0x0400;   /* LBA48 valid */
 			id[ATA_ID_CFS_ENABLE_2]  |= 0x0400;   /* LBA48 on */
 			/* Reporting logic */
@@ -504,7 +504,7 @@ static void __devinit it821x_quirkproc(i
 		 * IDE core that DMA is supported (it821x hardware
 		 * takes care of DMA mode programming).
 		 */
-		if (drive->driveid->capability & 1) {
+		if (ata_id_has_dma(id)) {
 			id[ATA_ID_MWDMA_MODES] |= 0x0101;
 			drive->current_speed = XFER_MW_DMA_0;
 		}
Index: b/drivers/ide/pci/pdc202xx_old.c
===================================================================
--- a/drivers/ide/pci/pdc202xx_old.c
+++ b/drivers/ide/pci/pdc202xx_old.c
@@ -86,7 +86,7 @@ static void pdc202xx_set_mode(ide_drive_
 		 * Prefetch_EN / IORDY_EN / PA[3:0] bits of register A
 		 */
 		AP &= ~0x3f;
-		if (drive->driveid->capability & 4)
+		if (ata_id_iordy_disable(drive->id))
 			AP |= 0x20;	/* set IORDY_EN bit */
 		if (drive->media == ide_disk)
 			AP |= 0x10;	/* set Prefetch_EN bit */
Index: b/drivers/ide/pci/sc1200.c
===================================================================
--- a/drivers/ide/pci/sc1200.c
+++ b/drivers/ide/pci/sc1200.c
@@ -111,7 +111,7 @@ static u8 sc1200_udma_filter(ide_drive_t
 	if (mate->present == 0)
 		goto out;
 
-	if ((mate->driveid->capability & 1) && __ide_dma_bad_drive(mate) == 0) {
+	if (ata_id_has_dma(mateid) && __ide_dma_bad_drive(mate) == 0) {
 		if ((mateid[ATA_ID_FIELD_VALID] & 4) &&
 		    (mateid[ATA_ID_UDMA_MODES] & 7))
 			goto out;
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -389,11 +389,7 @@ struct ide_drive_s {
 	struct request		*rq;	/* current request */
 	struct ide_drive_s 	*next;	/* circular list of hwgroup drives */
 	void		*driver_data;	/* extra driver data */
-	union {
-		/* identification info */
-		struct hd_driveid	*driveid;
-		u16			*id;
-	};
+	u16			*id;	/* identification info */
 #ifdef CONFIG_IDE_PROC_FS
 	struct proc_dir_entry *proc;	/* /proc/ide/ directory entry */
 	struct ide_settings_s *settings;/* /proc/ide/ drive settings */
@@ -1353,8 +1349,7 @@ extern int ide_set_xfer_rate(ide_drive_t
 
 static inline int ide_dev_has_iordy(u16 *id)
 {
-	return ((id[ATA_ID_FIELD_VALID] & 2) &&
-		(((struct hd_driveid *)id)->capability & 8)) ? 1 : 0;
+	return ((id[ATA_ID_FIELD_VALID] & 2) && ata_id_has_iordy(id)) ? 1 : 0;
 }
 
 static inline int ide_dev_is_sata(u16 *id)
