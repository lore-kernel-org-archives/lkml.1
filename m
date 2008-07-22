Return-Path: <linux-kernel-owner+w=401wt.eu-S1757285AbYGVVRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285AbYGVVRZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 17:17:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756004AbYGVVPC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 17:15:02 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:1590 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756548AbYGVVOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 17:14:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=k6LKTFWQ/vAXKbH3T8BdbsXGFFC0s5FgasV11I0IKjl94pL/q8m9kvqzdnpnRDpxn5
         2dRLrQBq/OTHOQbX8XGoQG7bmsd515QFWr63QfAQyGO+OBp9WLZXgTvC64OQaqs+EMEw
         wRNKJsE5zV+58BTD1FXvuipBB5yQypHbeXbVY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 22 Jul 2008 23:12:41 +0200
Message-Id: <20080722211241.20478.53705.sendpatchset@localhost.localdomain>
In-Reply-To: <20080722211159.20478.74184.sendpatchset@localhost.localdomain>
References: <20080722211159.20478.74184.sendpatchset@localhost.localdomain>
Subject: [PATCH 06/10] ide: make drive->id an union
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make drive->id an unnamed union so id can be accessed either by using
'u16 *id' or 'struct hd_driveid *driveid'.  Then convert all existing
drive->id users accordingly (using 'u16 *id' when possible).

This is an intermediate step to make ide 'struct hd_driveid'-free.

While at it:

- Add missing KERN_CONTs in it821x.c.

- Use ATA_ID_WORDS and ATA_ID_*_LEN defines.

- Remove unnecessary checks for drive->id.

- s/drive_table/table/ in ide_in_drive_list().

- Cleanup ide_config_drive_speed() a bit.

- s/drive1/dev1/ & s/drive0/dev0/ in ide_undecoded_slave().

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/arm/icside.c       |    4 -
 drivers/ide/arm/palm_bk3710.c  |    3 -
 drivers/ide/ide-acpi.c         |    6 +-
 drivers/ide/ide-cd.c           |   15 ++---
 drivers/ide/ide-disk.c         |   63 +++++++++++-----------
 drivers/ide/ide-dma.c          |   50 +++++++++--------
 drivers/ide/ide-floppy.c       |   14 ++--
 drivers/ide/ide-iops.c         |   78 ++++++++++++---------------
 drivers/ide/ide-lib.c          |   24 ++++----
 drivers/ide/ide-probe.c        |  117 +++++++++++++++++++++--------------------
 drivers/ide/ide-proc.c         |    5 -
 drivers/ide/ide-tape.c         |    7 +-
 drivers/ide/ide-taskfile.c     |    6 +-
 drivers/ide/ide-timings.c      |   21 +++----
 drivers/ide/ide.c              |    8 +-
 drivers/ide/legacy/qd65xx.c    |   22 ++++---
 drivers/ide/pci/alim15x3.c     |    4 -
 drivers/ide/pci/cs5530.c       |   10 ++-
 drivers/ide/pci/hpt366.c       |    8 +-
 drivers/ide/pci/it821x.c       |   51 ++++++++---------
 drivers/ide/pci/pdc202xx_new.c |    4 -
 drivers/ide/pci/pdc202xx_old.c |    6 +-
 drivers/ide/pci/sc1200.c       |   10 ++-
 drivers/ide/pci/serverworks.c  |    4 +
 drivers/ide/pci/siimage.c      |    8 +-
 drivers/ide/ppc/pmac.c         |    6 +-
 drivers/scsi/ide-scsi.c        |   13 ++--
 include/linux/ide.h            |   23 ++++----
 28 files changed, 311 insertions(+), 279 deletions(-)

Index: b/drivers/ide/arm/icside.c
===================================================================
--- a/drivers/ide/arm/icside.c
+++ b/drivers/ide/arm/icside.c
@@ -265,8 +265,8 @@ static void icside_set_dma_mode(ide_driv
 	 * If we're going to be doing MW_DMA_1 or MW_DMA_2, we should
 	 * take care to note the values in the ID...
 	 */
-	if (use_dma_info && drive->id->eide_dma_time > cycle_time)
-		cycle_time = drive->id->eide_dma_time;
+	if (use_dma_info && drive->id[ATA_ID_EIDE_DMA_TIME] > cycle_time)
+		cycle_time = drive->id[ATA_ID_EIDE_DMA_TIME];
 
 	drive->drive_data = cycle_time;
 
Index: b/drivers/ide/arm/palm_bk3710.c
===================================================================
--- a/drivers/ide/arm/palm_bk3710.c
+++ b/drivers/ide/arm/palm_bk3710.c
@@ -213,7 +213,8 @@ static void palm_bk3710_set_dma_mode(ide
 		palm_bk3710_setudmamode(base, is_slave,
 					xferspeed - XFER_UDMA_0);
 	} else {
-		palm_bk3710_setdmamode(base, is_slave, drive->id->eide_dma_min,
+		palm_bk3710_setdmamode(base, is_slave,
+				       drive->id[ATA_ID_EIDE_DMA_MIN],
 				       xferspeed);
 	}
 }
Index: b/drivers/ide/ide-acpi.c
===================================================================
--- a/drivers/ide/ide-acpi.c
+++ b/drivers/ide/ide-acpi.c
@@ -584,7 +584,7 @@ void ide_acpi_get_timing(ide_hwif_t *hwi
  * This function executes the _STM ACPI method for the target channel.
  *
  * _STM requires Identify Drive data, which has to passed as an argument.
- * Unfortunately hd_driveid is a mangled version which we can't readily
+ * Unfortunately drive->id is a mangled version which we can't readily
  * use; hence we'll get the information afresh.
  */
 void ide_acpi_push_timing(ide_hwif_t *hwif)
@@ -614,10 +614,10 @@ void ide_acpi_push_timing(ide_hwif_t *hw
 	in_params[0].buffer.length = sizeof(struct GTM_buffer);
 	in_params[0].buffer.pointer = (u8 *)&hwif->acpidata->gtm;
 	in_params[1].type = ACPI_TYPE_BUFFER;
-	in_params[1].buffer.length = sizeof(struct hd_driveid);
+	in_params[1].buffer.length = sizeof(ATA_ID_WORDS * 2);
 	in_params[1].buffer.pointer = (u8 *)&master->idbuff;
 	in_params[2].type = ACPI_TYPE_BUFFER;
-	in_params[2].buffer.length = sizeof(struct hd_driveid);
+	in_params[2].buffer.length = sizeof(ATA_ID_WORDS * 2);
 	in_params[2].buffer.pointer = (u8 *)&slave->idbuff;
 	/* Output buffer: _STM has no output */
 
Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1858,14 +1858,14 @@ static const struct cd_list_entry ide_cd
 	{ NULL, NULL, 0 }
 };
 
-static unsigned int ide_cd_flags(struct hd_driveid *id)
+static unsigned int ide_cd_flags(u16 *id)
 {
 	const struct cd_list_entry *cle = ide_cd_quirks_list;
 
 	while (cle->id_model) {
-		if (strcmp(cle->id_model, id->model) == 0 &&
+		if (strcmp(cle->id_model, (char *)&id[ATA_ID_PROD]) == 0 &&
 		    (cle->id_firmware == NULL ||
-		     strstr(id->fw_rev, cle->id_firmware)))
+		     strstr((char *)&id[ATA_ID_FW_REV], cle->id_firmware)))
 			return cle->cd_flags;
 		cle++;
 	}
@@ -1877,7 +1877,8 @@ static int ide_cdrom_setup(ide_drive_t *
 {
 	struct cdrom_info *cd = drive->driver_data;
 	struct cdrom_device_info *cdi = &cd->devinfo;
-	struct hd_driveid *id = drive->id;
+	u16 *id = drive->id;
+	char *fw_rev = (char *)&id[ATA_ID_FW_REV];
 	int nslots;
 
 	blk_queue_prep_rq(drive->queue, ide_cdrom_prep_fn);
@@ -1892,15 +1893,15 @@ static int ide_cdrom_setup(ide_drive_t *
 	drive->atapi_flags = IDE_AFLAG_MEDIA_CHANGED | IDE_AFLAG_NO_EJECT |
 		       ide_cd_flags(id);
 
-	if ((id->config & 0x0060) == 0x20)
+	if ((id[ATA_ID_CONFIG] & 0x0060) == 0x20)
 		drive->atapi_flags |= IDE_AFLAG_DRQ_INTERRUPT;
 
 	if ((drive->atapi_flags & IDE_AFLAG_VERTOS_300_SSD) &&
-	    id->fw_rev[4] == '1' && id->fw_rev[6] <= '2')
+	    fw_rev[4] == '1' && fw_rev[6] <= '2')
 		drive->atapi_flags |= (IDE_AFLAG_TOCTRACKS_AS_BCD |
 				     IDE_AFLAG_TOCADDR_AS_BCD);
 	else if ((drive->atapi_flags & IDE_AFLAG_VERTOS_600_ESD) &&
-		 id->fw_rev[4] == '1' && id->fw_rev[6] <= '2')
+		 fw_rev[4] == '1' && fw_rev[6] <= '2')
 		drive->atapi_flags |= IDE_AFLAG_TOCTRACKS_AS_BCD;
 	else if (drive->atapi_flags & IDE_AFLAG_SANYO_3CD)
 		/* 3 => use CD in slot 0 */
Index: b/drivers/ide/ide-disk.c
===================================================================
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -92,12 +92,13 @@ static void ide_disk_put(struct ide_disk
  *
  * It is called only once for each drive.
  */
-static int lba_capacity_is_ok(struct hd_driveid *id)
+static int lba_capacity_is_ok(u16 *id)
 {
+	struct hd_driveid *driveid = (struct hd_driveid *)id;
 	unsigned long lba_sects, chs_sects, head, tail;
 
 	/* No non-LBA info .. so valid! */
-	if (id->cyls == 0)
+	if (id[ATA_ID_CYLS] == 0)
 		return 1;
 
 	/*
@@ -106,15 +107,15 @@ static int lba_capacity_is_ok(struct hd_
 	 * Some drives can be jumpered to use 15 heads instead of 16.
 	 * Some drives can be jumpered to use 4092 cyls instead of 16383.
 	 */
-	if ((id->cyls == 16383
-	     || (id->cyls == 4092 && id->cur_cyls == 16383)) &&
-	    id->sectors == 63 &&
-	    (id->heads == 15 || id->heads == 16) &&
-	    (id->lba_capacity >= 16383*63*id->heads))
+	if ((id[ATA_ID_CYLS] == 16383 ||
+	     (id[ATA_ID_CYLS] == 4092 && id[ATA_ID_CUR_CYLS] == 16383)) &&
+	    id[ATA_ID_SECTORS] == 63 &&
+	    (id[ATA_ID_HEADS] == 15 || id[ATA_ID_HEADS] == 16) &&
+	    (driveid->lba_capacity >= 16383 * 63 * id[ATA_ID_HEADS]))
 		return 1;
 
-	lba_sects   = id->lba_capacity;
-	chs_sects   = id->cyls * id->heads * id->sectors;
+	lba_sects = driveid->lba_capacity;
+	chs_sects = id[ATA_ID_CYLS] * id[ATA_ID_HEADS] * id[ATA_ID_SECTORS];
 
 	/* perform a rough sanity check on lba_sects:  within 10% is OK */
 	if ((lba_sects - chs_sects) < chs_sects/10)
@@ -125,7 +126,7 @@ static int lba_capacity_is_ok(struct hd_
 	tail = (lba_sects & 0xffff);
 	lba_sects = (head | (tail << 16));
 	if ((lba_sects - chs_sects) < chs_sects/10) {
-		id->lba_capacity = lba_sects;
+		driveid->lba_capacity = lba_sects;
 		return 1;	/* lba_capacity is (now) good */
 	}
 
@@ -382,18 +383,20 @@ static unsigned long long sectors_to_MB(
  * so on non-buggy drives we need test only one.
  * However, we should also check whether these fields are valid.
  */
-static inline int idedisk_supports_hpa(const struct hd_driveid *id)
+static inline int idedisk_supports_hpa(const u16 *id)
 {
-	return (id->command_set_1 & 0x0400) && (id->cfs_enable_1 & 0x0400);
+	return (id[ATA_ID_COMMAND_SET_1] & 0x0400) &&
+	       (id[ATA_ID_CFS_ENABLE_1] & 0x0400);
 }
 
 /*
  * The same here.
  */
-static inline int idedisk_supports_lba48(const struct hd_driveid *id)
+static inline int idedisk_supports_lba48(const u16 *id)
 {
-	return (id->command_set_2 & 0x0400) && (id->cfs_enable_2 & 0x0400)
-	       && id->lba_capacity_2;
+	return (id[ATA_ID_COMMAND_SET_2] & 0x0400) &&
+	       (id[ATA_ID_CFS_ENABLE_2] & 0x0400) &&
+	       ((struct hd_driveid *)id)->lba_capacity_2;
 }
 
 /*
@@ -460,7 +463,8 @@ static void idedisk_check_hpa(ide_drive_
  */
 static void init_idedisk_capacity(ide_drive_t *drive)
 {
-	struct hd_driveid *id = drive->id;
+	struct hd_driveid *driveid = drive->driveid;
+	u16 *id = drive->id;
 	/*
 	 * If this drive supports the Host Protected Area feature set,
 	 * then we may need to change our opinion about the drive's capacity.
@@ -470,13 +474,13 @@ static void init_idedisk_capacity(ide_dr
 	if (idedisk_supports_lba48(id)) {
 		/* drive speaks 48-bit LBA */
 		drive->select.b.lba = 1;
-		drive->capacity64 = id->lba_capacity_2;
+		drive->capacity64 = driveid->lba_capacity_2;
 		if (hpa)
 			idedisk_check_hpa(drive);
-	} else if ((id->capability & 2) && lba_capacity_is_ok(id)) {
+	} else if ((driveid->capability & 2) && lba_capacity_is_ok(id)) {
 		/* drive speaks 28-bit LBA */
 		drive->select.b.lba = 1;
-		drive->capacity64 = id->lba_capacity;
+		drive->capacity64 = driveid->lba_capacity;
 		if (hpa)
 			idedisk_check_hpa(drive);
 	} else {
@@ -530,7 +534,7 @@ static int proc_idedisk_read_cache
 	int		len;
 
 	if (drive->id_read)
-		len = sprintf(out, "%i\n", drive->id->buf_size / 2);
+		len = sprintf(out, "%i\n", drive->id[ATA_ID_BUF_SIZE] / 2);
 	else
 		len = sprintf(out, "(none)\n");
 
@@ -625,7 +629,7 @@ static int set_multcount(ide_drive_t *dr
 	struct request *rq;
 	int error;
 
-	if (arg < 0 || arg > drive->id->max_multsect)
+	if (arg < 0 || arg > drive->driveid->max_multsect)
 		return -EINVAL;
 
 	if (drive->special.b.set_multmode)
@@ -657,7 +661,7 @@ static int set_nowerr(ide_drive_t *drive
 
 static void update_ordered(ide_drive_t *drive)
 {
-	struct hd_driveid *id = drive->id;
+	u16 *id = drive->id;
 	unsigned ordered = QUEUE_ORDERED_NONE;
 	prepare_flush_fn *prep_fn = NULL;
 
@@ -769,8 +773,6 @@ static int set_lba_addressing(ide_drive_
 #ifdef CONFIG_IDE_PROC_FS
 static void idedisk_add_settings(ide_drive_t *drive)
 {
-	struct hd_driveid *id = drive->id;
-
 	ide_add_setting(drive, "bios_cyl", SETTING_RW, TYPE_INT, 0, 65535, 1, 1,
 			&drive->bios_cyl, NULL);
 	ide_add_setting(drive, "bios_head", SETTING_RW, TYPE_BYTE, 0, 255, 1, 1,
@@ -780,7 +782,7 @@ static void idedisk_add_settings(ide_dri
 	ide_add_setting(drive, "address", SETTING_RW, TYPE_BYTE, 0, 2, 1, 1,
 			&drive->addressing, set_lba_addressing);
 	ide_add_setting(drive, "multcount", SETTING_RW, TYPE_BYTE, 0,
-			id->max_multsect, 1, 1, &drive->mult_count,
+			drive->driveid->max_multsect, 1, 1, &drive->mult_count,
 			set_multcount);
 	ide_add_setting(drive, "nowerr", SETTING_RW, TYPE_BYTE, 0, 1, 1, 1,
 			&drive->nowerr, set_nowerr);
@@ -802,7 +804,8 @@ static inline void idedisk_add_settings(
 static void idedisk_setup(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	struct hd_driveid *id = drive->id;
+	u16 *id = drive->id;
+	char *m = (char *)&id[ATA_ID_PROD];
 	unsigned long long capacity;
 
 	idedisk_add_settings(drive);
@@ -814,7 +817,7 @@ static void idedisk_setup(ide_drive_t *d
 		/*
 		 * Removable disks (eg. SYQUEST); ignore 'WD' drives
 		 */
-		if (id->model[0] != 'W' || id->model[1] != 'D')
+		if (m[0] != 'W' || m[1] != 'D')
 			drive->doorlocking = 1;
 	}
 
@@ -887,14 +890,14 @@ static void idedisk_setup(ide_drive_t *d
 			 drive->name, capacity, sectors_to_MB(capacity));
 
 	/* Only print cache size when it was specified */
-	if (id->buf_size)
-		printk(KERN_CONT " w/%dKiB Cache", id->buf_size / 2);
+	if (id[ATA_ID_BUF_SIZE])
+		printk(KERN_CONT " w/%dKiB Cache", id[ATA_ID_BUF_SIZE] / 2);
 
 	printk(KERN_CONT ", CHS=%d/%d/%d\n",
 			 drive->bios_cyl, drive->bios_head, drive->bios_sect);
 
 	/* write cache enabled? */
-	if ((id->csfo & 1) || (id->cfs_enable_1 & (1 << 5)))
+	if ((id[ATA_ID_CSFO] & 1) || (id[ATA_ID_CFS_ENABLE_1] & (1 << 5)))
 		drive->wcache = 1;
 
 	write_cache(drive, 1);
Index: b/drivers/ide/ide-dma.c
===================================================================
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -288,7 +288,7 @@ EXPORT_SYMBOL_GPL(ide_destroy_dmatable);
 static int config_drive_for_dma (ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	struct hd_driveid *id = drive->id;
+	u16 *id = drive->id;
 
 	if (drive->media != ide_disk) {
 		if (hwif->host_flags & IDE_HFLAG_NO_ATAPI_DMA)
@@ -299,16 +299,17 @@ static int config_drive_for_dma (ide_dri
 	 * Enable DMA on any drive that has
 	 * UltraDMA (mode 0/1/2/3/4/5/6) enabled
 	 */
-	if ((id->field_valid & 4) && ((id->dma_ultra >> 8) & 0x7f))
+	if ((id[ATA_ID_FIELD_VALID] & 4) &&
+	    ((id[ATA_ID_UDMA_MODES] >> 8) & 0x7f))
 		return 1;
 
 	/*
 	 * Enable DMA on any drive that has mode2 DMA
 	 * (multi or single) enabled
 	 */
-	if (id->field_valid & 2)	/* regular DMA */
-		if ((id->dma_mword & 0x404) == 0x404 ||
-		    (id->dma_1word & 0x404) == 0x404)
+	if (id[ATA_ID_FIELD_VALID] & 2)	/* regular DMA */
+		if ((id[ATA_ID_MWDMA_MODES] & 0x404) == 0x404 ||
+		    (id[ATA_ID_SWDMA_MODES] & 0x404) == 0x404)
 			return 1;
 
 	/* Consult the list of known "good" drives */
@@ -591,12 +592,12 @@ static inline int config_drive_for_dma(i
 
 int __ide_dma_bad_drive (ide_drive_t *drive)
 {
-	struct hd_driveid *id = drive->id;
+	u16 *id = drive->id;
 
 	int blacklist = ide_in_drive_list(id, drive_blacklist);
 	if (blacklist) {
 		printk(KERN_WARNING "%s: Disabling (U)DMA for %s (blacklisted)\n",
-				    drive->name, id->model);
+				    drive->name, (char *)&id[ATA_ID_PROD]);
 		return blacklist;
 	}
 	return 0;
@@ -612,21 +613,21 @@ static const u8 xfer_mode_bases[] = {
 
 static unsigned int ide_get_mode_mask(ide_drive_t *drive, u8 base, u8 req_mode)
 {
-	struct hd_driveid *id = drive->id;
+	u16 *id = drive->id;
 	ide_hwif_t *hwif = drive->hwif;
 	const struct ide_port_ops *port_ops = hwif->port_ops;
 	unsigned int mask = 0;
 
 	switch(base) {
 	case XFER_UDMA_0:
-		if ((id->field_valid & 4) == 0)
+		if ((id[ATA_ID_FIELD_VALID] & 4) == 0)
 			break;
 
 		if (port_ops && port_ops->udma_filter)
 			mask = port_ops->udma_filter(drive);
 		else
 			mask = hwif->ultra_mask;
-		mask &= id->dma_ultra;
+		mask &= id[ATA_ID_UDMA_MODES];
 
 		/*
 		 * avoid false cable warning from eighty_ninty_three()
@@ -637,19 +638,19 @@ static unsigned int ide_get_mode_mask(id
 		}
 		break;
 	case XFER_MW_DMA_0:
-		if ((id->field_valid & 2) == 0)
+		if ((id[ATA_ID_FIELD_VALID] & 2) == 0)
 			break;
 		if (port_ops && port_ops->mdma_filter)
 			mask = port_ops->mdma_filter(drive);
 		else
 			mask = hwif->mwdma_mask;
-		mask &= id->dma_mword;
+		mask &= id[ATA_ID_MWDMA_MODES];
 		break;
 	case XFER_SW_DMA_0:
-		if (id->field_valid & 2) {
-			mask = id->dma_1word & hwif->swdma_mask;
-		} else if (id->tDMA) {
-			u8 mode = id->tDMA;
+		if (id[ATA_ID_FIELD_VALID] & 2) {
+			mask = id[ATA_ID_SWDMA_MODES] & hwif->swdma_mask;
+		} else if (drive->driveid->tDMA) {
+			u8 mode = drive->driveid->tDMA;
 
 			/*
 			 * if the mode is valid convert it to the mask
@@ -706,7 +707,8 @@ u8 ide_find_dma_mode(ide_drive_t *drive,
 		/*
 		 * is this correct?
 		 */
-		if (ide_dma_good_drive(drive) && drive->id->eide_dma_time < 150)
+		if (ide_dma_good_drive(drive) &&
+		    drive->id[ATA_ID_EIDE_DMA_TIME] < 150)
 			mode = XFER_MW_DMA_1;
 	}
 
@@ -725,7 +727,7 @@ static int ide_tune_dma(ide_drive_t *dri
 	ide_hwif_t *hwif = drive->hwif;
 	u8 speed;
 
-	if (drive->nodma || (drive->id->capability & 1) == 0)
+	if (drive->nodma || (drive->driveid->capability & 1) == 0)
 		return 0;
 
 	/* consult the list of known "bad" drives */
@@ -767,13 +769,15 @@ static int ide_dma_check(ide_drive_t *dr
 
 int ide_id_dma_bug(ide_drive_t *drive)
 {
-	struct hd_driveid *id = drive->id;
+	u16 *id = drive->id;
 
-	if (id->field_valid & 4) {
-		if ((id->dma_ultra >> 8) && (id->dma_mword >> 8))
+	if (id[ATA_ID_FIELD_VALID] & 4) {
+		if ((id[ATA_ID_UDMA_MODES] >> 8) &&
+		    (id[ATA_ID_MWDMA_MODES] >> 8))
 			goto err_out;
-	} else if (id->field_valid & 2) {
-		if ((id->dma_mword >> 8) && (id->dma_1word >> 8))
+	} else if (id[ATA_ID_FIELD_VALID] & 2) {
+		if ((id[ATA_ID_MWDMA_MODES] >> 8) &&
+		    (id[ATA_ID_SWDMA_MODES] >> 8))
 			goto err_out;
 	}
 	return 0;
Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -964,12 +964,12 @@ static sector_t idefloppy_capacity(ide_d
  * Check whether we can support a drive, based on the ATAPI IDENTIFY command
  * results.
  */
-static int idefloppy_identify_device(ide_drive_t *drive, struct hd_driveid *id)
+static int idefloppy_identify_device(ide_drive_t *drive, u16 *id)
 {
 	u8 gcw[2];
 	u8 device_type, protocol, removable, drq_type, packet_size;
 
-	*((u16 *) &gcw) = id->config;
+	*((u16 *)&gcw) = id[ATA_ID_CONFIG];
 
 	device_type =  gcw[1] & 0x1F;
 	removable   = (gcw[0] & 0x80) >> 7;
@@ -980,7 +980,8 @@ static int idefloppy_identify_device(ide
 #ifdef CONFIG_PPC
 	/* kludge for Apple PowerBook internal zip */
 	if (device_type == 5 &&
-	    !strstr(id->model, "CD-ROM") && strstr(id->model, "ZIP"))
+	    !strstr((char *)&id[ATA_ID_PROD], "CD-ROM") &&
+	    strstr((char *)&id[ATA_ID_PROD], "ZIP"))
 		device_type = 0;
 #endif
 
@@ -1023,9 +1024,10 @@ static inline void idefloppy_add_setting
 
 static void idefloppy_setup(ide_drive_t *drive, idefloppy_floppy_t *floppy)
 {
+	u16 *id = drive->id;
 	u8 gcw[2];
 
-	*((u16 *) &gcw) = drive->id->config;
+	*((u16 *)&gcw) = id[ATA_ID_CONFIG];
 	floppy->pc = floppy->pc_stack;
 	drive->pc_callback = ide_floppy_callback;
 
@@ -1040,7 +1042,7 @@ static void idefloppy_setup(ide_drive_t 
 	 * it. It should be fixed as of version 1.9, but to be on the safe side
 	 * we'll leave the limitation below for the 2.2.x tree.
 	 */
-	if (!strncmp(drive->id->model, "IOMEGA ZIP 100 ATAPI", 20)) {
+	if (!strncmp((char *)&id[ATA_ID_PROD], "IOMEGA ZIP 100 ATAPI", 20)) {
 		drive->atapi_flags |= IDE_AFLAG_ZIP_DRIVE;
 		/* This value will be visible in the /proc/ide/hdx/settings */
 		floppy->ticks = IDEFLOPPY_TICKS_DELAY;
@@ -1051,7 +1053,7 @@ static void idefloppy_setup(ide_drive_t 
 	 * Guess what? The IOMEGA Clik! drive also needs the above fix. It makes
 	 * nasty clicking noises without it, so please don't remove this.
 	 */
-	if (strncmp(drive->id->model, "IOMEGA Clik!", 11) == 0) {
+	if (strncmp((char *)&id[ATA_ID_PROD], "IOMEGA Clik!", 11) == 0) {
 		blk_queue_max_sectors(drive->queue, 64);
 		drive->atapi_flags |= IDE_AFLAG_CLIK_DRIVE;
 	}
Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -400,11 +400,11 @@ const struct ide_tp_ops default_tp_ops =
 	.output_data		= ide_output_data,
 };
 
-void ide_fix_driveid(struct hd_driveid *driveid)
+void ide_fix_driveid(u16 *id)
 {
 #ifndef __LITTLE_ENDIAN
 # ifdef __BIG_ENDIAN
-	u16 *id = (u16 *)driveid;
+	struct hd_driveid *driveid = (struct hd_driveid *)id;
 	int i;
 
 	for (i = 0; i < 256; i++) {
@@ -593,18 +593,18 @@ EXPORT_SYMBOL(ide_wait_stat);
 /**
  *	ide_in_drive_list	-	look for drive in black/white list
  *	@id: drive identifier
- *	@drive_table: list to inspect
+ *	@table: list to inspect
  *
  *	Look for a drive in the blacklist and the whitelist tables
  *	Returns 1 if the drive is found in the table.
  */
 
-int ide_in_drive_list(struct hd_driveid *id, const struct drive_list_entry *drive_table)
+int ide_in_drive_list(u16 *id, const struct drive_list_entry *table)
 {
-	for ( ; drive_table->id_model; drive_table++)
-		if ((!strcmp(drive_table->id_model, id->model)) &&
-		    (!drive_table->id_firmware ||
-		     strstr(id->fw_rev, drive_table->id_firmware)))
+	for ( ; table->id_model; table++)
+		if ((!strcmp(table->id_model, (char *)&id[ATA_ID_PROD])) &&
+		    (!table->id_firmware ||
+		     strstr((char *)&id[ATA_ID_FW_REV], table->id_firmware)))
 			return 1;
 	return 0;
 }
@@ -635,7 +635,7 @@ static const struct drive_list_entry ivb
 u8 eighty_ninty_three (ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	struct hd_driveid *id = drive->id;
+	u16 *id = drive->id;
 	int ivb = ide_in_drive_list(id, ivb_list);
 
 	if (hwif->cbl == ATA_CBL_PATA40_SHORT)
@@ -657,7 +657,8 @@ u8 eighty_ninty_three (ide_drive_t *driv
 	 * - force bit13 (80c cable present) check also for !ivb devices
 	 *   (unless the slave device is pre-ATA3)
 	 */
-	if ((id->hw_config & 0x4000) || (ivb && (id->hw_config & 0x2000)))
+	if ((id[ATA_ID_HW_CONFIG] & 0x4000) ||
+	    (ivb && (id[ATA_ID_HW_CONFIG] & 0x2000)))
 		return 1;
 
 no_80w:
@@ -678,7 +679,7 @@ int ide_driveid_update(ide_drive_t *driv
 {
 	ide_hwif_t *hwif = drive->hwif;
 	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
-	struct hd_driveid *id;
+	u16 *id;
 	unsigned long timeout, flags;
 	u8 stat;
 
@@ -722,16 +723,16 @@ int ide_driveid_update(ide_drive_t *driv
 	local_irq_enable();
 	local_irq_restore(flags);
 	ide_fix_driveid(id);
-	if (id) {
-		drive->id->dma_ultra = id->dma_ultra;
-		drive->id->dma_mword = id->dma_mword;
-		drive->id->dma_1word = id->dma_1word;
-		/* anything more ? */
-		kfree(id);
 
-		if (drive->using_dma && ide_id_dma_bug(drive))
-			ide_dma_off(drive);
-	}
+	drive->id[ATA_ID_UDMA_MODES]  = id[ATA_ID_UDMA_MODES];
+	drive->id[ATA_ID_MWDMA_MODES] = id[ATA_ID_MWDMA_MODES];
+	drive->id[ATA_ID_SWDMA_MODES] = id[ATA_ID_SWDMA_MODES];
+	/* anything more ? */
+
+	kfree(id);
+
+	if (drive->using_dma && ide_id_dma_bug(drive))
+		ide_dma_off(drive);
 
 	return 1;
 }
@@ -740,6 +741,7 @@ int ide_config_drive_speed(ide_drive_t *
 {
 	ide_hwif_t *hwif = drive->hwif;
 	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
+	u16 *id = drive->id, i;
 	int error = 0;
 	u8 stat;
 	ide_task_t task;
@@ -750,7 +752,7 @@ int ide_config_drive_speed(ide_drive_t *
 #endif
 
 	/* Skip setting PIO flow-control modes on pre-EIDE drives */
-	if ((speed & 0xf8) == XFER_PIO_0 && !(drive->id->capability & 0x08))
+	if ((speed & 0xf8) == XFER_PIO_0 && !(drive->driveid->capability & 8))
 		goto skip;
 
 	/*
@@ -802,9 +804,9 @@ int ide_config_drive_speed(ide_drive_t *
 		return error;
 	}
 
-	drive->id->dma_ultra &= ~0xFF00;
-	drive->id->dma_mword &= ~0x0F00;
-	drive->id->dma_1word &= ~0x0F00;
+	id[ATA_ID_UDMA_MODES]  &= ~0xFF00;
+	id[ATA_ID_MWDMA_MODES] &= ~0x0F00;
+	id[ATA_ID_SWDMA_MODES] &= ~0x0F00;
 
  skip:
 #ifdef CONFIG_BLK_DEV_IDEDMA
@@ -814,23 +816,17 @@ int ide_config_drive_speed(ide_drive_t *
 		ide_dma_off_quietly(drive);
 #endif
 
-	switch(speed) {
-		case XFER_UDMA_7:   drive->id->dma_ultra |= 0x8080; break;
-		case XFER_UDMA_6:   drive->id->dma_ultra |= 0x4040; break;
-		case XFER_UDMA_5:   drive->id->dma_ultra |= 0x2020; break;
-		case XFER_UDMA_4:   drive->id->dma_ultra |= 0x1010; break;
-		case XFER_UDMA_3:   drive->id->dma_ultra |= 0x0808; break;
-		case XFER_UDMA_2:   drive->id->dma_ultra |= 0x0404; break;
-		case XFER_UDMA_1:   drive->id->dma_ultra |= 0x0202; break;
-		case XFER_UDMA_0:   drive->id->dma_ultra |= 0x0101; break;
-		case XFER_MW_DMA_2: drive->id->dma_mword |= 0x0404; break;
-		case XFER_MW_DMA_1: drive->id->dma_mword |= 0x0202; break;
-		case XFER_MW_DMA_0: drive->id->dma_mword |= 0x0101; break;
-		case XFER_SW_DMA_2: drive->id->dma_1word |= 0x0404; break;
-		case XFER_SW_DMA_1: drive->id->dma_1word |= 0x0202; break;
-		case XFER_SW_DMA_0: drive->id->dma_1word |= 0x0101; break;
-		default: break;
+	if (speed >= XFER_UDMA_0) {
+		i = 1 << (speed - XFER_UDMA_0);
+		id[ATA_ID_UDMA_MODES] |= (i << 8 | i);
+	} else if (speed >= XFER_MW_DMA_0) {
+		i = 1 << (speed - XFER_MW_DMA_0);
+		id[ATA_ID_MWDMA_MODES] |= (i << 8 | i);
+	} else if (speed >= XFER_SW_DMA_0) {
+		i = 1 << (speed - XFER_SW_DMA_0);
+		id[ATA_ID_SWDMA_MODES] |= (i << 8 | i);
 	}
+
 	if (!drive->init_speed)
 		drive->init_speed = speed;
 	drive->current_speed = speed;
@@ -1035,7 +1031,7 @@ out:
 
 static void ide_disk_pre_reset(ide_drive_t *drive)
 {
-	int legacy = (drive->id->cfs_enable_2 & 0x0400) ? 0 : 1;
+	int legacy = (drive->id[ATA_ID_CFS_ENABLE_2] & 0x0400) ? 0 : 1;
 
 	drive->special.all = 0;
 	drive->special.b.set_geometry = legacy;
Index: b/drivers/ide/ide-lib.c
===================================================================
--- a/drivers/ide/ide-lib.c
+++ b/drivers/ide/ide-lib.c
@@ -90,29 +90,31 @@ static u8 ide_rate_filter(ide_drive_t *d
 
 u8 ide_get_best_pio_mode (ide_drive_t *drive, u8 mode_wanted, u8 max_mode)
 {
-	int pio_mode;
-	struct hd_driveid* id = drive->id;
-	int overridden  = 0;
+	u16 *id = drive->id;
+	int pio_mode = -1, overridden = 0;
 
 	if (mode_wanted != 255)
 		return min_t(u8, mode_wanted, max_mode);
 
-	if ((drive->hwif->host_flags & IDE_HFLAG_PIO_NO_BLACKLIST) == 0 &&
-	    (pio_mode = ide_scan_pio_blacklist(id->model)) != -1) {
+	if ((drive->hwif->host_flags & IDE_HFLAG_PIO_NO_BLACKLIST) == 0)
+		pio_mode = ide_scan_pio_blacklist((char *)&id[ATA_ID_PROD]);
+
+	if (pio_mode != -1) {
 		printk(KERN_INFO "%s: is on PIO blacklist\n", drive->name);
 	} else {
-		pio_mode = id->tPIO;
+		pio_mode = drive->driveid->tPIO;
 		if (pio_mode > 2) {	/* 2 is maximum allowed tPIO value */
 			pio_mode = 2;
 			overridden = 1;
 		}
-		if (id->field_valid & 2) {	  /* drive implements ATA2? */
-			if (id->capability & 8) { /* IORDY supported? */
-				if (id->eide_pio_modes & 7) {
+
+		if (id[ATA_ID_FIELD_VALID] & 2) {	      /* ATA2? */
+			if (drive->driveid->capability & 8) { /* IORDY sup? */
+				if (id[ATA_ID_PIO_MODES] & 7) {
 					overridden = 0;
-					if (id->eide_pio_modes & 4)
+					if (id[ATA_ID_PIO_MODES] & 4)
 						pio_mode = 5;
-					else if (id->eide_pio_modes & 2)
+					else if (id[ATA_ID_PIO_MODES] & 2)
 						pio_mode = 4;
 					else
 						pio_mode = 3;
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -50,44 +50,44 @@
  
 static void generic_id(ide_drive_t *drive)
 {
-	drive->id->cyls = drive->cyl;
-	drive->id->heads = drive->head;
-	drive->id->sectors = drive->sect;
-	drive->id->cur_cyls = drive->cyl;
-	drive->id->cur_heads = drive->head;
-	drive->id->cur_sectors = drive->sect;
+	u16 *id = drive->id;
+
+	id[ATA_ID_CUR_CYLS]	= id[ATA_ID_CYLS]	= drive->cyl;
+	id[ATA_ID_CUR_HEADS]	= id[ATA_ID_HEADS]	= drive->head;
+	id[ATA_ID_CUR_SECTORS]	= id[ATA_ID_SECTORS]	= drive->sect;
 }
 
 static void ide_disk_init_chs(ide_drive_t *drive)
 {
-	struct hd_driveid *id = drive->id;
+	u16 *id = drive->id;
 
 	/* Extract geometry if we did not already have one for the drive */
 	if (!drive->cyl || !drive->head || !drive->sect) {
-		drive->cyl  = drive->bios_cyl  = id->cyls;
-		drive->head = drive->bios_head = id->heads;
-		drive->sect = drive->bios_sect = id->sectors;
+		drive->cyl  = drive->bios_cyl  = id[ATA_ID_CYLS];
+		drive->head = drive->bios_head = id[ATA_ID_HEADS];
+		drive->sect = drive->bios_sect = id[ATA_ID_SECTORS];
 	}
 
 	/* Handle logical geometry translation by the drive */
-	if ((id->field_valid & 1) && id->cur_cyls &&
-	    id->cur_heads && (id->cur_heads <= 16) && id->cur_sectors) {
-		drive->cyl  = id->cur_cyls;
-		drive->head = id->cur_heads;
-		drive->sect = id->cur_sectors;
+	if ((id[ATA_ID_FIELD_VALID] & 1) && id[ATA_ID_CUR_CYLS] &&
+	    id[ATA_ID_CUR_HEADS] && id[ATA_ID_CUR_HEADS] <= 16 &&
+	    id[ATA_ID_CUR_SECTORS]) {
+		drive->cyl  = id[ATA_ID_CUR_CYLS];
+		drive->head = id[ATA_ID_CUR_HEADS];
+		drive->sect = id[ATA_ID_CUR_SECTORS];
 	}
 
 	/* Use physical geometry if what we have still makes no sense */
-	if (drive->head > 16 && id->heads && id->heads <= 16) {
-		drive->cyl  = id->cyls;
-		drive->head = id->heads;
-		drive->sect = id->sectors;
+	if (drive->head > 16 && id[ATA_ID_HEADS] && id[ATA_ID_HEADS] <= 16) {
+		drive->cyl  = id[ATA_ID_CYLS];
+		drive->head = id[ATA_ID_HEADS];
+		drive->sect = id[ATA_ID_SECTORS];
 	}
 }
 
 static void ide_disk_init_mult_count(ide_drive_t *drive)
 {
-	struct hd_driveid *id = drive->id;
+	struct hd_driveid *id = drive->driveid;
 
 	if (id->max_multsect) {
 #ifdef CONFIG_IDEDISK_MULTI_MODE
@@ -118,10 +118,10 @@ static void ide_disk_init_mult_count(ide
 static inline void do_identify (ide_drive_t *drive, u8 cmd)
 {
 	ide_hwif_t *hwif = HWIF(drive);
+	u16 *id = drive->id;
+	char *m = (char *)&id[ATA_ID_PROD];
 	int bswap = 1;
-	struct hd_driveid *id;
 
-	id = drive->id;
 	/* read 512 bytes of id info */
 	hwif->tp_ops->input_data(drive, NULL, id, SECTOR_SIZE);
 
@@ -138,23 +138,24 @@ static inline void do_identify (ide_driv
 	 *  WIN_PIDENTIFY *usually* returns little-endian info.
 	 */
 	if (cmd == WIN_PIDENTIFY) {
-		if ((id->model[0] == 'N' && id->model[1] == 'E') /* NEC */
-		 || (id->model[0] == 'F' && id->model[1] == 'X') /* Mitsumi */
-		 || (id->model[0] == 'P' && id->model[1] == 'i'))/* Pioneer */
+		if ((m[0] == 'N' && m[1] == 'E') ||  /* NEC */
+		    (m[0] == 'F' && m[1] == 'X') ||  /* Mitsumi */
+		    (m[0] == 'P' && m[1] == 'i'))    /* Pioneer */
 			/* Vertos drives may still be weird */
-			bswap ^= 1;	
+			bswap ^= 1;
 	}
-	ide_fixstring(id->model,     sizeof(id->model),     bswap);
-	ide_fixstring(id->fw_rev,    sizeof(id->fw_rev),    bswap);
-	ide_fixstring(id->serial_no, sizeof(id->serial_no), bswap);
+
+	ide_fixstring(m, ATA_ID_PROD_LEN, bswap);
+	ide_fixstring((char *)&id[ATA_ID_FW_REV], ATA_ID_FW_REV_LEN, bswap);
+	ide_fixstring((char *)&id[ATA_ID_SERNO], ATA_ID_SERNO_LEN, bswap);
 
 	/* we depend on this a lot! */
-	id->model[sizeof(id->model)-1] = '\0';
+	m[ATA_ID_PROD_LEN - 1] = '\0';
 
-	if (strstr(id->model, "E X A B Y T E N E S T"))
+	if (strstr(m, "E X A B Y T E N E S T"))
 		goto err_misc;
 
-	printk(KERN_INFO "%s: %s, ", drive->name, id->model);
+	printk(KERN_INFO "%s: %s, ", drive->name, m);
 
 	drive->present = 1;
 	drive->dead = 0;
@@ -163,15 +164,15 @@ static inline void do_identify (ide_driv
 	 * Check for an ATAPI device
 	 */
 	if (cmd == WIN_PIDENTIFY) {
-		u8 type = (id->config >> 8) & 0x1f;
+		u8 type = (id[ATA_ID_CONFIG] >> 8) & 0x1f;
 
 		printk(KERN_CONT "ATAPI ");
 		switch (type) {
 			case ide_floppy:
-				if (!strstr(id->model, "CD-ROM")) {
-					if (!strstr(id->model, "oppy") &&
-					    !strstr(id->model, "poyp") &&
-					    !strstr(id->model, "ZIP"))
+				if (!strstr(m, "CD-ROM")) {
+					if (!strstr(m, "oppy") &&
+					    !strstr(m, "poyp") &&
+					    !strstr(m, "ZIP"))
 						printk(KERN_CONT "cdrom or floppy?, assuming ");
 					if (drive->media != ide_cdrom) {
 						printk(KERN_CONT "FLOPPY");
@@ -185,8 +186,7 @@ static inline void do_identify (ide_driv
 				drive->removable = 1;
 #ifdef CONFIG_PPC
 				/* kludge for Apple PowerBook internal zip */
-				if (!strstr(id->model, "CD-ROM") &&
-				    strstr(id->model, "ZIP")) {
+				if (!strstr(m, "CD-ROM") && strstr(m, "ZIP")) {
 					printk(KERN_CONT "FLOPPY");
 					type = ide_floppy;
 					break;
@@ -220,14 +220,13 @@ static inline void do_identify (ide_driv
 	 * 0x848a = CompactFlash device
 	 * These are *not* removable in Linux definition of the term
 	 */
-
-	if ((id->config != 0x848a) && (id->config & (1<<7)))
+	if (id[ATA_ID_CONFIG] != 0x848a && (id[ATA_ID_CONFIG] & (1 << 7)))
 		drive->removable = 1;
 
 	drive->media = ide_disk;
 
 	printk(KERN_CONT "%s DISK drive\n",
-		(id->config == 0x848a) ? "CFA" : "ATA");
+		(id[ATA_ID_CONFIG] == 0x848a) ? "CFA" : "ATA");
 
 	return;
 
@@ -525,7 +524,8 @@ static void enable_nest (ide_drive_t *dr
 	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
 	u8 stat;
 
-	printk(KERN_INFO "%s: enabling %s -- ", hwif->name, drive->id->model);
+	printk(KERN_INFO "%s: enabling %s -- ",
+		hwif->name, (char *)&drive->id[ATA_ID_PROD]);
 
 	SELECT_DRIVE(drive);
 	msleep(50);
@@ -566,6 +566,8 @@ static void enable_nest (ide_drive_t *dr
  
 static inline u8 probe_for_drive (ide_drive_t *drive)
 {
+	char *m;
+
 	/*
 	 *	In order to keep things simple we have an id
 	 *	block for all drives at all times. If the device
@@ -582,8 +584,10 @@ static inline u8 probe_for_drive (ide_dr
 		printk(KERN_ERR "ide: out of memory for id data.\n");
 		return 0;
 	}
-	strcpy(drive->id->model, "UNKNOWN");
-	
+
+	m = (char *)&drive->id[ATA_ID_PROD];
+	strcpy(m, "UNKNOWN");
+
 	/* skip probing? */
 	if (!drive->noprobe)
 	{
@@ -595,7 +599,8 @@ static inline u8 probe_for_drive (ide_dr
 		if (!drive->present)
 			/* drive not found */
 			return 0;
-		if (strstr(drive->id->model, "E X A B Y T E N E S T"))
+
+		if (strstr(m, "E X A B Y T E N E S T"))
 			enable_nest(drive);
 	
 		/* identification failed? */
@@ -739,36 +744,38 @@ out:
 
 /**
  *	ide_undecoded_slave	-	look for bad CF adapters
- *	@drive1: drive
+ *	@dev1: slave device
  *
  *	Analyse the drives on the interface and attempt to decide if we
  *	have the same drive viewed twice. This occurs with crap CF adapters
  *	and PCMCIA sometimes.
  */
 
-void ide_undecoded_slave(ide_drive_t *drive1)
+void ide_undecoded_slave(ide_drive_t *dev1)
 {
-	ide_drive_t *drive0 = &drive1->hwif->drives[0];
+	ide_drive_t *dev0 = &dev1->hwif->drives[0];
 
-	if ((drive1->dn & 1) == 0 || drive0->present == 0)
+	if ((dev1->dn & 1) == 0 || dev0->present == 0)
 		return;
 
 	/* If the models don't match they are not the same product */
-	if (strcmp(drive0->id->model, drive1->id->model))
+	if (strcmp((char *)&dev0->id[ATA_ID_PROD],
+		   (char *)&dev1->id[ATA_ID_PROD]))
 		return;
 
 	/* Serial numbers do not match */
-	if (strncmp(drive0->id->serial_no, drive1->id->serial_no, 20))
+	if (strncmp((char *)&dev0->id[ATA_ID_SERNO],
+		    (char *)&dev1->id[ATA_ID_SERNO], ATA_ID_SERNO_LEN))
 		return;
 
 	/* No serial number, thankfully very rare for CF */
-	if (drive0->id->serial_no[0] == 0)
+	if (*(char *)&dev0->id[ATA_ID_SERNO] == 0)
 		return;
 
 	/* Appears to be an IDE flash adapter with decode bugs */
 	printk(KERN_WARNING "ide-probe: ignoring undecoded slave\n");
 
-	drive1->present = 0;
+	dev1->present = 0;
 }
 
 EXPORT_SYMBOL_GPL(ide_undecoded_slave);
@@ -852,7 +859,7 @@ static void ide_port_tune_devices(ide_hw
 		if (hwif->host_flags & IDE_HFLAG_NO_IO_32BIT)
 			drive->no_io_32bit = 1;
 		else
-			drive->no_io_32bit = drive->id->dword_io ? 1 : 0;
+			drive->no_io_32bit = drive->id[ATA_ID_DWORD_IO] ? 1 : 0;
 	}
 }
 
Index: b/drivers/ide/ide-proc.c
===================================================================
--- a/drivers/ide/ide-proc.c
+++ b/drivers/ide/ide-proc.c
@@ -561,11 +561,10 @@ static int proc_ide_read_dmodel
 	(char *page, char **start, off_t off, int count, int *eof, void *data)
 {
 	ide_drive_t	*drive = (ide_drive_t *) data;
-	struct hd_driveid *id = drive->id;
+	char		*m = (char *)&drive->id[ATA_ID_PROD];
 	int		len;
 
-	len = sprintf(page, "%.40s\n",
-		(id && id->model[0]) ? (char *)id->model : "(none)");
+	len = sprintf(page, "%.40s\n", m[0] ? m : "(none)");
 	PROC_IDE_READ_RETURN(page, start, off, count, eof, len);
 }
 
Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -2309,7 +2309,7 @@ static int idetape_identify_device(ide_d
 	if (drive->id_read == 0)
 		return 1;
 
-	*((unsigned short *) &gcw) = drive->id->config;
+	*((u16 *)&gcw) = drive->id[ATA_ID_CONFIG];
 
 	protocol	=   (gcw[1] & 0xC0) >> 6;
 	device_type	=    gcw[1] & 0x1F;
@@ -2461,7 +2461,7 @@ static void idetape_setup(ide_drive_t *d
 		drive->dsc_overlap = 0;
 	}
 	/* Seagate Travan drives do not support DSC overlap. */
-	if (strstr(drive->id->model, "Seagate STT3401"))
+	if (strstr((char *)&drive->id[ATA_ID_PROD], "Seagate STT3401"))
 		drive->dsc_overlap = 0;
 	tape->minor = minor;
 	tape->name[0] = 'h';
@@ -2469,7 +2469,8 @@ static void idetape_setup(ide_drive_t *d
 	tape->name[2] = '0' + minor;
 	tape->chrdev_dir = IDETAPE_DIR_NONE;
 	tape->pc = tape->pc_stack;
-	*((unsigned short *) &gcw) = drive->id->config;
+
+	*((u16 *)&gcw) = drive->id[ATA_ID_CONFIG];
 
 	/* Command packet DRQ type */
 	if (((gcw[0] & 0x60) >> 5) == 1)
Index: b/drivers/ide/ide-taskfile.c
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -729,7 +729,7 @@ int ide_cmd_ioctl (ide_drive_t *drive, u
 	u8 args[4], xfer_rate = 0;
 	ide_task_t tfargs;
 	struct ide_taskfile *tf = &tfargs.tf;
-	struct hd_driveid *id = drive->id;
+	u16 *id = drive->id;
 
 	if (NULL == (void *) arg) {
 		struct request *rq;
@@ -772,7 +772,9 @@ int ide_cmd_ioctl (ide_drive_t *drive, u
 	if (tf->command == WIN_SETFEATURES &&
 	    tf->feature == SETFEATURES_XFER &&
 	    tf->nsect >= XFER_SW_DMA_0 &&
-	    (id->dma_ultra || id->dma_mword || id->dma_1word)) {
+	    (id[ATA_ID_UDMA_MODES] ||
+	     id[ATA_ID_MWDMA_MODES] ||
+	     id[ATA_ID_SWDMA_MODES])) {
 		xfer_rate = args[1];
 		if (tf->nsect > XFER_UDMA_2 && !eighty_ninty_three(drive)) {
 			printk(KERN_WARNING "%s: UDMA speeds >UDMA33 cannot "
Index: b/drivers/ide/ide-timings.c
===================================================================
--- a/drivers/ide/ide-timings.c
+++ b/drivers/ide/ide-timings.c
@@ -78,15 +78,15 @@ EXPORT_SYMBOL_GPL(ide_timing_find_mode);
 
 u16 ide_pio_cycle_time(ide_drive_t *drive, u8 pio)
 {
-	struct hd_driveid *id = drive->id;
+	u16 *id = drive->id;
 	struct ide_timing *t = ide_timing_find_mode(XFER_PIO_0 + pio);
 	u16 cycle = 0;
 
-	if (id->field_valid & 2) {
-		if (id->capability & 8)
-			cycle = id->eide_pio_iordy;
+	if (id[ATA_ID_FIELD_VALID] & 2) {
+		if (drive->driveid->capability & 8)
+			cycle = id[ATA_ID_EIDE_PIO_IORDY];
 		else
-			cycle = id->eide_pio;
+			cycle = id[ATA_ID_EIDE_PIO];
 
 		/* conservative "downgrade" for all pre-ATA2 drives */
 		if (pio < 3 && cycle < t->cycle)
@@ -138,7 +138,7 @@ EXPORT_SYMBOL_GPL(ide_timing_merge);
 int ide_timing_compute(ide_drive_t *drive, u8 speed,
 		       struct ide_timing *t, int T, int UT)
 {
-	struct hd_driveid *id = drive->id;
+	u16 *id = drive->id;
 	struct ide_timing *s, p;
 
 	/*
@@ -157,16 +157,15 @@ int ide_timing_compute(ide_drive_t *driv
 	 * If the drive is an EIDE drive, it can tell us it needs extended
 	 * PIO/MWDMA cycle timing.
 	 */
-	if (id && id->field_valid & 2) {	/* EIDE drive */
-
+	if (id[ATA_ID_FIELD_VALID] & 2) {	/* EIDE drive */
 		memset(&p, 0, sizeof(p));
 
 		if (speed <= XFER_PIO_2)
-			p.cycle = p.cyc8b = id->eide_pio;
+			p.cycle = p.cyc8b = id[ATA_ID_EIDE_PIO];
 		else if (speed <= XFER_PIO_5)
-			p.cycle = p.cyc8b = id->eide_pio_iordy;
+			p.cycle = p.cyc8b = id[ATA_ID_EIDE_PIO_IORDY];
 		else if (speed >= XFER_MW_DMA_0 && speed <= XFER_MW_DMA_2)
-			p.cycle = id->eide_dma_min;
+			p.cycle = id[ATA_ID_EIDE_DMA_MIN];
 
 		ide_timing_merge(&p, t, t, IDE_TIMING_CYCLE | IDE_TIMING_CYC8B);
 	}
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -328,7 +328,7 @@ int set_using_dma(ide_drive_t *drive, in
 	if (arg < 0 || arg > 1)
 		return -EINVAL;
 
-	if (!drive->id || !(drive->id->capability & 1))
+	if ((drive->driveid->capability & 1) == 0)
 		goto out;
 
 	if (hwif->dma_ops == NULL)
@@ -710,21 +710,21 @@ static ssize_t model_show(struct device 
 			  char *buf)
 {
 	ide_drive_t *drive = to_ide_device(dev);
-	return sprintf(buf, "%s\n", drive->id->model);
+	return sprintf(buf, "%s\n", (char *)&drive->id[ATA_ID_PROD]);
 }
 
 static ssize_t firmware_show(struct device *dev, struct device_attribute *attr,
 			     char *buf)
 {
 	ide_drive_t *drive = to_ide_device(dev);
-	return sprintf(buf, "%s\n", drive->id->fw_rev);
+	return sprintf(buf, "%s\n", (char *)&drive->id[ATA_ID_FW_REV]);
 }
 
 static ssize_t serial_show(struct device *dev, struct device_attribute *attr,
 			   char *buf)
 {
 	ide_drive_t *drive = to_ide_device(dev);
-	return sprintf(buf, "%s\n", drive->id->serial_no);
+	return sprintf(buf, "%s\n", (char *)&drive->id[ATA_ID_SERNO]);
 }
 
 static struct device_attribute ide_dev_attrs[] = {
Index: b/drivers/ide/legacy/qd65xx.c
===================================================================
--- a/drivers/ide/legacy/qd65xx.c
+++ b/drivers/ide/legacy/qd65xx.c
@@ -151,12 +151,14 @@ static int qd_find_disk_type (ide_drive_
 		int *active_time, int *recovery_time)
 {
 	struct qd65xx_timing_s *p;
-	char model[40];
+	char *m = (char *)&drive->id[ATA_ID_PROD];
+	char model[ATA_ID_PROD_LEN];
 
-	if (!*drive->id->model) return 0;
+	if (*m == 0)
+		return 0;
 
-	strncpy(model,drive->id->model,40);
-	ide_fixstring(model,40,1); /* byte-swap */
+	strncpy(model, m, ATA_ID_PROD_LEN);
+	ide_fixstring(model, ATA_ID_PROD_LEN, 1); /* byte-swap */
 
 	for (p = qd65xx_timing ; p->offset != -1 ; p++) {
 		if (!strncmp(p->model, model+p->offset, 4)) {
@@ -185,20 +187,20 @@ static void qd_set_timing (ide_drive_t *
 
 static void qd6500_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
+	u16 *id = drive->id;
 	int active_time   = 175;
 	int recovery_time = 415; /* worst case values from the dos driver */
 
 	/*
 	 * FIXME: use "pio" value
 	 */
-	if (drive->id && !qd_find_disk_type(drive, &active_time, &recovery_time)
-		&& drive->id->tPIO && (drive->id->field_valid & 0x02)
-		&& drive->id->eide_pio >= 240) {
-
+	if (!qd_find_disk_type(drive, &active_time, &recovery_time) &&
+	    drive->driveid->tPIO && (id[ATA_ID_FIELD_VALID] & 2) &&
+	    id[ATA_ID_EIDE_PIO] >= 240) {
 		printk(KERN_INFO "%s: PIO mode%d\n", drive->name,
-				drive->id->tPIO);
+				drive->driveid->tPIO);
 		active_time = 110;
-		recovery_time = drive->id->eide_pio - 120;
+		recovery_time = drive->id[ATA_ID_EIDE_PIO] - 120;
 	}
 
 	qd_set_timing(drive, qd6500_compute_timing(HWIF(drive), active_time, recovery_time));
Index: b/drivers/ide/pci/alim15x3.c
===================================================================
--- a/drivers/ide/pci/alim15x3.c
+++ b/drivers/ide/pci/alim15x3.c
@@ -134,8 +134,8 @@ static u8 ali_udma_filter(ide_drive_t *d
 	if (m5229_revision > 0x20 && m5229_revision < 0xC2) {
 		if (drive->media != ide_disk)
 			return 0;
-		if (chip_is_1543c_e && strstr(drive->id->model, "WDC ") &&
-		    wdc_udma == 0)
+		if (wdc_udma == 0 && chip_is_1543c_e &&
+		    strstr((char *)&drive->id[ATA_ID_PROD], "WDC "))
 			return 0;
 	}
 
Index: b/drivers/ide/pci/cs5530.c
===================================================================
--- a/drivers/ide/pci/cs5530.c
+++ b/drivers/ide/pci/cs5530.c
@@ -82,16 +82,18 @@ static u8 cs5530_udma_filter(ide_drive_t
 {
 	ide_hwif_t *hwif = drive->hwif;
 	ide_drive_t *mate = &hwif->drives[(drive->dn & 1) ^ 1];
-	struct hd_driveid *mateid = mate->id;
+	u16 *mateid = mate->id;
 	u8 mask = hwif->ultra_mask;
 
 	if (mate->present == 0)
 		goto out;
 
-	if ((mateid->capability & 1) && __ide_dma_bad_drive(mate) == 0) {
-		if ((mateid->field_valid & 4) && (mateid->dma_ultra & 7))
+	if ((mate->driveid->capability & 1) && __ide_dma_bad_drive(mate) == 0) {
+		if ((mateid[ATA_ID_FIELD_VALID] & 4) &&
+		    (mateid[ATA_ID_UDMA_MODES] & 7))
 			goto out;
-		if ((mateid->field_valid & 2) && (mateid->dma_mword & 7))
+		if ((mateid[ATA_ID_FIELD_VALID] & 2) &&
+		    (mateid[ATA_ID_MWDMA_MODES] & 7))
 			mask = 0;
 	}
 out:
Index: b/drivers/ide/pci/hpt366.c
===================================================================
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -605,10 +605,10 @@ static const struct hpt_info hpt371n __d
 
 static int check_in_drive_list(ide_drive_t *drive, const char **list)
 {
-	struct hd_driveid *id = drive->id;
+	char *m = (char *)&drive->id[ATA_ID_PROD];
 
 	while (*list)
-		if (!strcmp(*list++,id->model))
+		if (!strcmp(*list++, m))
 			return 1;
 	return 0;
 }
@@ -728,11 +728,11 @@ static void hpt3xx_set_pio_mode(ide_driv
 
 static void hpt3xx_quirkproc(ide_drive_t *drive)
 {
-	struct hd_driveid *id	= drive->id;
+	char *m			= (char *)&drive->id[ATA_ID_PROD];
 	const  char **list	= quirk_drives;
 
 	while (*list)
-		if (strstr(id->model, *list++)) {
+		if (strstr(m, *list++)) {
 			drive->quirk_list = 1;
 			return;
 		}
Index: b/drivers/ide/pci/it821x.c
===================================================================
--- a/drivers/ide/pci/it821x.c
+++ b/drivers/ide/pci/it821x.c
@@ -446,8 +446,7 @@ static u8 __devinit it821x_cable_detect(
 static void __devinit it821x_quirkproc(ide_drive_t *drive)
 {
 	struct it821x_dev *itdev = ide_get_hwifdata(drive->hwif);
-	struct hd_driveid *id = drive->id;
-	u16 *idbits = (u16 *)drive->id;
+	u16 *id = drive->id;
 
 	if (!itdev->smart) {
 		/*
@@ -466,36 +465,36 @@ static void __devinit it821x_quirkproc(i
 	 */
 
 		/* Check for RAID v native */
-		if(strstr(id->model, "Integrated Technology Express")) {
+		if (strstr((char *)&id[ATA_ID_PROD],
+			   "Integrated Technology Express")) {
 			/* In raid mode the ident block is slightly buggy
 			   We need to set the bits so that the IDE layer knows
 			   LBA28. LBA48 and DMA ar valid */
-			id->capability |= 3;		/* LBA28, DMA */
-			id->command_set_2 |= 0x0400;	/* LBA48 valid */
-			id->cfs_enable_2 |= 0x0400;	/* LBA48 on */
+			drive->driveid->capability |= 3;      /* LBA28, DMA */
+			id[ATA_ID_COMMAND_SET_2] |= 0x0400;   /* LBA48 valid */
+			id[ATA_ID_CFS_ENABLE_2]  |= 0x0400;   /* LBA48 on */
 			/* Reporting logic */
 			printk(KERN_INFO "%s: IT8212 %sRAID %d volume",
-				drive->name,
-				idbits[147] ? "Bootable ":"",
-				idbits[129]);
-				if(idbits[129] != 1)
-					printk("(%dK stripe)", idbits[146]);
-				printk(".\n");
+				drive->name, id[147] ? "Bootable " : "",
+				id[ATA_ID_CSFO]);
+			if (id[ATA_ID_CSFO] != 1)
+				printk(KERN_CONT "(%dK stripe)", id[146]);
+			printk(KERN_CONT ".\n");
 		} else {
 			/* Non RAID volume. Fixups to stop the core code
 			   doing unsupported things */
-			id->field_valid &= 3;
-			id->queue_depth = 0;
-			id->command_set_1 = 0;
-			id->command_set_2 &= 0xC400;
-			id->cfsse &= 0xC000;
-			id->cfs_enable_1 = 0;
-			id->cfs_enable_2 &= 0xC400;
-			id->csf_default &= 0xC000;
-			id->word127 = 0;
-			id->dlf = 0;
-			id->csfo = 0;
-			id->cfa_power = 0;
+			id[ATA_ID_FIELD_VALID]	 &= 3;
+			id[ATA_ID_QUEUE_DEPTH]	  = 0;
+			id[ATA_ID_COMMAND_SET_1]  = 0;
+			id[ATA_ID_COMMAND_SET_2] &= 0xC400;
+			id[ATA_ID_CFSSE]	 &= 0xC000;
+			id[ATA_ID_CFS_ENABLE_1]	  = 0;
+			id[ATA_ID_CFS_ENABLE_2]	 &= 0xC400;
+			id[ATA_ID_CSF_DEFAULT]	 &= 0xC000;
+			id[127]			  = 0;
+			id[ATA_ID_DLF]		  = 0;
+			id[ATA_ID_CSFO]		  = 0;
+			id[ATA_ID_CFA_POWER]	  = 0;
 			printk(KERN_INFO "%s: Performing identify fixups.\n",
 				drive->name);
 		}
@@ -505,8 +504,8 @@ static void __devinit it821x_quirkproc(i
 		 * IDE core that DMA is supported (it821x hardware
 		 * takes care of DMA mode programming).
 		 */
-		if (id->capability & 1) {
-			id->dma_mword |= 0x0101;
+		if (drive->driveid->capability & 1) {
+			id[ATA_ID_MWDMA_MODES] |= 0x0101;
 			drive->current_speed = XFER_MW_DMA_0;
 		}
 	}
Index: b/drivers/ide/pci/pdc202xx_new.c
===================================================================
--- a/drivers/ide/pci/pdc202xx_new.c
+++ b/drivers/ide/pci/pdc202xx_new.c
@@ -203,10 +203,10 @@ static u8 __devinit pdcnew_cable_detect(
 
 static void pdcnew_quirkproc(ide_drive_t *drive)
 {
-	const char **list, *model = drive->id->model;
+	const char **list, *m = (char *)&drive->id[ATA_ID_PROD];
 
 	for (list = pdc_quirk_drives; *list != NULL; list++)
-		if (strstr(model, *list) != NULL) {
+		if (strstr(m, *list) != NULL) {
 			drive->quirk_list = 2;
 			return;
 		}
Index: b/drivers/ide/pci/pdc202xx_old.c
===================================================================
--- a/drivers/ide/pci/pdc202xx_old.c
+++ b/drivers/ide/pci/pdc202xx_old.c
@@ -86,7 +86,7 @@ static void pdc202xx_set_mode(ide_drive_
 		 * Prefetch_EN / IORDY_EN / PA[3:0] bits of register A
 		 */
 		AP &= ~0x3f;
-		if (drive->id->capability & 4)
+		if (drive->driveid->capability & 4)
 			AP |= 0x20;	/* set IORDY_EN bit */
 		if (drive->media == ide_disk)
 			AP |= 0x10;	/* set Prefetch_EN bit */
@@ -154,10 +154,10 @@ static void pdc_old_disable_66MHz_clock(
 
 static void pdc202xx_quirkproc(ide_drive_t *drive)
 {
-	const char **list, *model = drive->id->model;
+	const char **list, *m = (char *)&drive->id[ATA_ID_PROD];
 
 	for (list = pdc_quirk_drives; *list != NULL; list++)
-		if (strstr(model, *list) != NULL) {
+		if (strstr(m, *list) != NULL) {
 			drive->quirk_list = 2;
 			return;
 		}
Index: b/drivers/ide/pci/sc1200.c
===================================================================
--- a/drivers/ide/pci/sc1200.c
+++ b/drivers/ide/pci/sc1200.c
@@ -105,16 +105,18 @@ static u8 sc1200_udma_filter(ide_drive_t
 {
 	ide_hwif_t *hwif = drive->hwif;
 	ide_drive_t *mate = &hwif->drives[(drive->dn & 1) ^ 1];
-	struct hd_driveid *mateid = mate->id;
+	u16 *mateid = mate->id;
 	u8 mask = hwif->ultra_mask;
 
 	if (mate->present == 0)
 		goto out;
 
-	if ((mateid->capability & 1) && __ide_dma_bad_drive(mate) == 0) {
-		if ((mateid->field_valid & 4) && (mateid->dma_ultra & 7))
+	if ((mate->driveid->capability & 1) && __ide_dma_bad_drive(mate) == 0) {
+		if ((mateid[ATA_ID_FIELD_VALID] & 4) &&
+		    (mateid[ATA_ID_UDMA_MODES] & 7))
 			goto out;
-		if ((mateid->field_valid & 2) && (mateid->dma_mword & 7))
+		if ((mateid[ATA_ID_FIELD_VALID] & 2) &&
+		    (mateid[ATA_ID_MWDMA_MODES] & 7))
 			mask = 0;
 	}
 out:
Index: b/drivers/ide/pci/serverworks.c
===================================================================
--- a/drivers/ide/pci/serverworks.c
+++ b/drivers/ide/pci/serverworks.c
@@ -57,8 +57,10 @@ static struct pci_dev *isa_dev;
 
 static int check_in_drive_lists (ide_drive_t *drive, const char **list)
 {
+	char *m = (char *)&drive->id[ATA_ID_PROD];
+
 	while (*list)
-		if (!strcmp(*list++, drive->id->model))
+		if (!strcmp(*list++, m))
 			return 1;
 	return 0;
 }
Index: b/drivers/ide/pci/siimage.c
===================================================================
--- a/drivers/ide/pci/siimage.c
+++ b/drivers/ide/pci/siimage.c
@@ -223,7 +223,9 @@ static u8 sil_pata_udma_filter(ide_drive
 
 static u8 sil_sata_udma_filter(ide_drive_t *drive)
 {
-	return strstr(drive->id->model, "Maxtor") ? ATA_UDMA5 : ATA_UDMA6;
+	char *m = (char *)&drive->id[ATA_ID_PROD];
+
+	return strstr(m, "Maxtor") ? ATA_UDMA5 : ATA_UDMA6;
 }
 
 /**
@@ -616,8 +618,8 @@ static void __devinit init_mmio_iops_sii
 
 static int is_dev_seagate_sata(ide_drive_t *drive)
 {
-	const char *s	= &drive->id->model[0];
-	unsigned len	= strnlen(s, sizeof(drive->id->model));
+	const char *s	= (const char *)&drive->id[ATA_ID_PROD];
+	unsigned len	= strnlen(s, ATA_ID_PROD_LEN);
 
 	if ((len > 4) && (!memcmp(s, "ST", 2)))
 		if ((!memcmp(s + len - 2, "AS", 2)) ||
Index: b/drivers/ide/ppc/pmac.c
===================================================================
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -669,9 +669,9 @@ static void
 set_timings_mdma(ide_drive_t *drive, int intf_type, u32 *timings, u32 *timings2,
 		 	u8 speed)
 {
+	u16 *id = drive->id;
 	int cycleTime, accessTime = 0, recTime = 0;
 	unsigned accessTicks, recTicks;
-	struct hd_driveid *id = drive->id;
 	struct mdma_timings_t* tm = NULL;
 	int i;
 
@@ -686,8 +686,8 @@ set_timings_mdma(ide_drive_t *drive, int
 	}
 
 	/* Check if drive provides explicit DMA cycle time */
-	if ((id->field_valid & 2) && id->eide_dma_time)
-		cycleTime = max_t(int, id->eide_dma_time, cycleTime);
+	if ((id[ATA_ID_FIELD_VALID] & 2) && id[ATA_ID_EIDE_DMA_TIME)
+		cycleTime = max_t(int, id[ATA_ID_EIDE_DMA_TIME], cycleTime);
 
 	/* OHare limits according to some old Apple sources */	
 	if ((intf_type == controller_ohare) && (cycleTime < 150))
Index: b/drivers/scsi/ide-scsi.c
===================================================================
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -451,7 +451,7 @@ static inline void idescsi_add_settings(
  */
 static void idescsi_setup (ide_drive_t *drive, idescsi_scsi_t *scsi)
 {
-	if (drive->id && (drive->id->config & 0x0060) == 0x20)
+	if ((drive->id[ATA_ID_CONFIG] & 0x0060) == 0x20)
 		set_bit(IDE_AFLAG_DRQ_INTERRUPT, &drive->atapi_flags);
 	clear_bit(IDESCSI_SG_TRANSFORM, &scsi->transform);
 #if IDESCSI_DEBUG_LOG
@@ -810,6 +810,7 @@ static int ide_scsi_probe(ide_drive_t *d
 	struct gendisk *g;
 	static int warned;
 	int err = -ENOMEM;
+	u16 last_lun;
 
 	if (!warned && drive->media == ide_cdrom) {
 		printk(KERN_WARNING "ide-scsi is deprecated for cd burning! Use ide-cd and give dev=/dev/hdX as device\n");
@@ -835,12 +836,12 @@ static int ide_scsi_probe(ide_drive_t *d
 
 	host->max_id = 1;
 
-	if (drive->id->last_lun)
-		debug_log("%s: id->last_lun=%u\n", drive->name,
-			  drive->id->last_lun);
+	last_lun = drive->id[ATA_ID_LAST_LUN];
+	if (last_lun)
+		debug_log("%s: last_lun=%u\n", drive->name, last_lun);
 
-	if ((drive->id->last_lun & 0x7) != 7)
-		host->max_lun = (drive->id->last_lun & 0x7) + 1;
+	if ((last_lun & 7) != 7)
+		host->max_lun = (last_lun & 7) + 1;
 	else
 		host->max_lun = 1;
 
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -389,7 +389,11 @@ struct ide_drive_s {
 	struct request		*rq;	/* current request */
 	struct ide_drive_s 	*next;	/* circular list of hwgroup drives */
 	void		*driver_data;	/* extra driver data */
-	struct hd_driveid	*id;	/* drive model identification info */
+	union {
+		/* identification info */
+		struct hd_driveid	*driveid;
+		u16			*id;
+	};
 #ifdef CONFIG_IDE_PROC_FS
 	struct proc_dir_entry *proc;	/* /proc/ide/ directory entry */
 	struct ide_settings_s *settings;/* /proc/ide/ drive settings */
@@ -920,7 +924,7 @@ ide_startstop_t __ide_error(ide_drive_t 
 
 ide_startstop_t ide_error (ide_drive_t *drive, const char *msg, byte stat);
 
-extern void ide_fix_driveid(struct hd_driveid *);
+void ide_fix_driveid(u16 *);
 
 extern void ide_fixstring(u8 *, const int, const int);
 
@@ -1241,7 +1245,7 @@ struct drive_list_entry {
 	const char *id_firmware;
 };
 
-int ide_in_drive_list(struct hd_driveid *, const struct drive_list_entry *);
+int ide_in_drive_list(u16 *, const struct drive_list_entry *);
 
 #ifdef CONFIG_BLK_DEV_IDEDMA
 int __ide_dma_bad_drive(ide_drive_t *);
@@ -1347,12 +1351,13 @@ const char *ide_xfer_verbose(u8 mode);
 extern void ide_toggle_bounce(ide_drive_t *drive, int on);
 extern int ide_set_xfer_rate(ide_drive_t *drive, u8 rate);
 
-static inline int ide_dev_has_iordy(struct hd_driveid *id)
+static inline int ide_dev_has_iordy(u16 *id)
 {
-	return ((id->field_valid & 2) && (id->capability & 8)) ? 1 : 0;
+	return ((id[ATA_ID_FIELD_VALID] & 2) &&
+		(((struct hd_driveid *)id)->capability & 8)) ? 1 : 0;
 }
 
-static inline int ide_dev_is_sata(struct hd_driveid *id)
+static inline int ide_dev_is_sata(u16 *id)
 {
 	/*
 	 * See if word 93 is 0 AND drive is at least ATA-5 compatible
@@ -1360,7 +1365,7 @@ static inline int ide_dev_is_sata(struct
 	 * this trick allows us to filter out the reserved values of
 	 * 0x0000 and 0xffff along with the earlier ATA revisions...
 	 */
-	if (id->hw_config == 0 && (short)id->major_rev_num >= 0x0020)
+	if (id[ATA_ID_HW_CONFIG] == 0 && (short)id[ATA_ID_MAJOR_VER] >= 0x0020)
 		return 1;
 	return 0;
 }
@@ -1437,11 +1442,11 @@ extern struct bus_type ide_bus_type;
 extern struct class *ide_port_class;
 
 /* check if CACHE FLUSH (EXT) command is supported (bits defined in ATA-6) */
-#define ide_id_has_flush_cache(id)	((id)->cfs_enable_2 & 0x3000)
+#define ide_id_has_flush_cache(id)	((id)[ATA_ID_CFS_ENABLE_2] & 0x3000)
 
 /* some Maxtor disks have bit 13 defined incorrectly so check bit 10 too */
 #define ide_id_has_flush_cache_ext(id)	\
-	(((id)->cfs_enable_2 & 0x2400) == 0x2400)
+	(((id)[ATA_ID_CFS_ENABLE_2] & 0x2400) == 0x2400)
 
 static inline void ide_dump_identify(u8 *id)
 {
