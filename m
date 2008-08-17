Return-Path: <linux-kernel-owner+w=401wt.eu-S1755759AbYHQRSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759AbYHQRSq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 13:18:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752838AbYHQRRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 13:17:54 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:30781 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946AbYHQRRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 13:17:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=WJyuCCsV8GY3vSASFpy6sZNO/Q8h/qVC03z08jeRRcywdhyUY5Tdl50oA/XBenzuUU
         NryEQAsTik3c2CZ8uRMsi0Xpuw3VnFawey2TI2ixOAVNBWEpDEmZWT8NN5thZmNKYYwf
         EOoKVFQfUAloJBeAcr5Y41QJ6sn1EkKtrOYJI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 17 Aug 2008 19:15:21 +0200
Message-Id: <20080817171521.27943.21873.sendpatchset@localhost.localdomain>
In-Reply-To: <20080817171454.27943.37234.sendpatchset@localhost.localdomain>
References: <20080817171454.27943.37234.sendpatchset@localhost.localdomain>
Subject: [PATCH 5/9] ide: add device flags
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add 'unsigned long dev_flags' to ide_drive_t and convert bitfields
to IDE_DFLAG_* flags.

While at it:
- IDE_DFLAG_ADDRESSING -> IDE_DFLAG_LBA48
- fixup some comments
- remove needless g->flags zeroing from ide*_probe()

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-acpi.c         |   12 ++--
 drivers/ide/ide-atapi.c        |   21 ++++----
 drivers/ide/ide-cd.c           |   17 +++---
 drivers/ide/ide-disk.c         |   93 ++++++++++++++++++++++--------------
 drivers/ide/ide-dma.c          |    7 +-
 drivers/ide/ide-floppy.c       |    9 +--
 drivers/ide/ide-io.c           |   55 +++++++++++++--------
 drivers/ide/ide-ioctls.c       |   21 +++++---
 drivers/ide/ide-iops.c         |   24 +++++----
 drivers/ide/ide-lib.c          |    2 
 drivers/ide/ide-probe.c        |  104 ++++++++++++++++++++++-------------------
 drivers/ide/ide-proc.c         |    6 --
 drivers/ide/ide-tape.c         |   30 +++++++----
 drivers/ide/ide-taskfile.c     |   14 ++---
 drivers/ide/ide.c              |   35 ++++++++-----
 drivers/ide/legacy/ht6560b.c   |    9 +--
 drivers/ide/pci/amd74xx.c      |    2 
 drivers/ide/pci/cmd640.c       |   14 ++---
 drivers/ide/pci/it821x.c       |    2 
 drivers/ide/pci/ns87415.c      |   11 +++-
 drivers/ide/pci/pdc202xx_old.c |    4 -
 drivers/ide/pci/sc1200.c       |    3 -
 drivers/ide/pci/trm290.c       |    4 -
 drivers/ide/ppc/pmac.c         |    4 -
 drivers/scsi/ide-scsi.c        |    9 +--
 include/linux/ide.h            |  100 ++++++++++++++++++++++++++++-----------
 26 files changed, 370 insertions(+), 242 deletions(-)

Index: b/drivers/ide/ide-acpi.c
===================================================================
--- a/drivers/ide/ide-acpi.c
+++ b/drivers/ide/ide-acpi.c
@@ -290,7 +290,7 @@ static int do_drive_get_GTF(ide_drive_t 
 	DEBPRINT("ENTER: %s at %s, port#: %d, hard_port#: %d\n",
 		 hwif->name, dev->bus_id, port, hwif->channel);
 
-	if (!drive->present) {
+	if ((drive->dev_flags & IDE_DFLAG_PRESENT) == 0) {
 		DEBPRINT("%s drive %d:%d not present\n",
 			 hwif->name, hwif->channel, port);
 		goto out;
@@ -420,8 +420,9 @@ static int do_drive_set_taskfiles(ide_dr
 
 	DEBPRINT("ENTER: %s, hard_port#: %d\n", drive->name, drive->dn);
 
-	if (!drive->present)
+	if ((drive->dev_flags & IDE_DFLAG_PRESENT) == 0)
 		goto out;
+
 	if (!gtf_count)		/* shouldn't be here */
 		goto out;
 
@@ -660,7 +661,8 @@ void ide_acpi_set_state(ide_hwif_t *hwif
 		if (!drive->acpidata->obj_handle)
 			drive->acpidata->obj_handle = ide_acpi_drive_get_handle(drive);
 
-		if (drive->acpidata->obj_handle && drive->present) {
+		if (drive->acpidata->obj_handle &&
+		    (drive->dev_flags & IDE_DFLAG_PRESENT)) {
 			acpi_bus_set_power(drive->acpidata->obj_handle,
 				on? ACPI_STATE_D0: ACPI_STATE_D3);
 		}
@@ -720,7 +722,7 @@ void ide_acpi_port_init_devices(ide_hwif
 
 		memset(drive->acpidata, 0, sizeof(*drive->acpidata));
 
-		if (!drive->present)
+		if ((drive->dev_flags & IDE_DFLAG_PRESENT) == 0)
 			continue;
 
 		err = taskfile_lib_get_identify(drive, drive->acpidata->idbuff);
@@ -745,7 +747,7 @@ void ide_acpi_port_init_devices(ide_hwif
 	for (i = 0; i < MAX_DRIVES; i++) {
 		drive = &hwif->drives[i];
 
-		if (drive->present)
+		if (drive->dev_flags & IDE_DFLAG_PRESENT)
 			/* Execute ACPI startup code */
 			ide_acpi_exec_tfs(drive);
 	}
Index: b/drivers/ide/ide-atapi.c
===================================================================
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -261,7 +261,7 @@ static ide_startstop_t ide_pc_intr(ide_d
 	ide_expiry_t *expiry;
 	unsigned int timeout, temp;
 	u16 bcount;
-	u8 stat, ireason, scsi = drive->scsi, dsc = 0;
+	u8 stat, ireason, scsi = !!(drive->dev_flags & IDE_DFLAG_SCSI), dsc = 0;
 
 	debug_log("Enter %s - interrupt handler\n", __func__);
 
@@ -494,7 +494,8 @@ static ide_startstop_t ide_transfer_pc(i
 	}
 
 	ireason = ide_read_ireason(drive);
-	if (drive->media == ide_tape && !drive->scsi)
+	if (drive->media == ide_tape &&
+	    (drive->dev_flags & IDE_DFLAG_SCSI) == 0)
 		ireason = ide_wait_ireason(drive, ireason);
 
 	if ((ireason & ATAPI_COD) == 0 || (ireason & ATAPI_IO)) {
@@ -512,7 +513,7 @@ static ide_startstop_t ide_transfer_pc(i
 		timeout = drive->pc_delay;
 		expiry = &ide_delayed_transfer_pc;
 	} else {
-		if (drive->scsi) {
+		if (drive->dev_flags & IDE_DFLAG_SCSI) {
 			timeout = ide_scsi_get_timeout(pc);
 			expiry = ide_scsi_expiry;
 		} else {
@@ -544,14 +545,14 @@ ide_startstop_t ide_issue_pc(ide_drive_t
 	struct ide_atapi_pc *pc = drive->pc;
 	ide_hwif_t *hwif = drive->hwif;
 	u16 bcount;
-	u8 dma = 0;
+	u8 dma = 0, scsi = !!(drive->dev_flags & IDE_DFLAG_SCSI);
 
 	/* We haven't transferred any data yet */
 	pc->xferred = 0;
 	pc->cur_pos = pc->buf;
 
 	/* Request to transfer the entire buffer at once */
-	if (drive->media == ide_tape && !drive->scsi)
+	if (drive->media == ide_tape && scsi == 0)
 		bcount = pc->req_xfer;
 	else
 		bcount = min(pc->req_xfer, 63 * 1024);
@@ -561,19 +562,19 @@ ide_startstop_t ide_issue_pc(ide_drive_t
 		ide_dma_off(drive);
 	}
 
-	if ((pc->flags & PC_FLAG_DMA_OK) && drive->using_dma) {
-		if (drive->scsi)
+	if ((pc->flags & PC_FLAG_DMA_OK) &&
+	    (drive->dev_flags & IDE_DFLAG_USING_DMA)) {
+		if (scsi)
 			hwif->sg_mapped = 1;
 		dma = !hwif->dma_ops->dma_setup(drive);
-		if (drive->scsi)
+		if (scsi)
 			hwif->sg_mapped = 0;
 	}
 
 	if (!dma)
 		pc->flags &= ~PC_FLAG_DMA_OK;
 
-	ide_pktcmd_tf_load(drive, drive->scsi ? 0 : IDE_TFLAG_OUT_DEVICE,
-			   bcount, dma);
+	ide_pktcmd_tf_load(drive, scsi ? 0 : IDE_TFLAG_OUT_DEVICE, bcount, dma);
 
 	/* Issue the packet command */
 	if (drive->atapi_flags & IDE_AFLAG_DRQ_INTERRUPT) {
Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -746,7 +746,7 @@ static ide_startstop_t cdrom_seek_intr(i
 
 	if (retry && time_after(jiffies, info->start_seek + IDECD_SEEK_TIMER)) {
 		if (--retry == 0)
-			drive->dsc_overlap = 0;
+			drive->dev_flags &= ~IDE_DFLAG_DSC_OVERLAP;
 	}
 	return ide_stopped;
 }
@@ -1134,7 +1134,7 @@ static ide_startstop_t cdrom_start_rw(id
 		}
 		cd->dma = 0;
 	} else
-		cd->dma = drive->using_dma;
+		cd->dma = !!(drive->dev_flags & IDE_DFLAG_USING_DMA);
 
 	if (write)
 		cd->devinfo.media_written = 1;
@@ -1171,7 +1171,7 @@ static void cdrom_do_block_pc(ide_drive_
 		else
 			buf = rq->data;
 
-		info->dma = drive->using_dma;
+		info->dma = !!(drive->dev_flags & IDE_DFLAG_USING_DMA);
 
 		/*
 		 * check if dma is safe
@@ -1216,7 +1216,7 @@ static ide_startstop_t ide_cd_do_request
 		if (rq_data_dir(rq) == READ &&
 		    IDE_LARGE_SEEK(info->last_block, block,
 			    IDECD_SEEK_THRESHOLD) &&
-		    drive->dsc_overlap) {
+		    (drive->dev_flags & IDE_DFLAG_DSC_OVERLAP)) {
 			xferlen = 0;
 			fn = cdrom_start_seek_continuation;
 
@@ -1807,7 +1807,7 @@ static ide_proc_entry_t idecd_proc[] = {
 	{ NULL, 0, NULL, NULL }
 };
 
-ide_devset_rw_field(dsc_overlap, dsc_overlap);
+ide_devset_rw_flag(dsc_overlap, IDE_DFLAG_DSC_OVERLAP);
 
 static const struct ide_proc_devset idecd_settings[] = {
 	IDE_PROC_DEVSET(dsc_overlap, 0, 1),
@@ -1911,7 +1911,10 @@ static int ide_cdrom_setup(ide_drive_t *
 	/* set correct block size */
 	blk_queue_hardsect_size(drive->queue, CD_FRAMESIZE);
 
-	drive->dsc_overlap = (drive->next != drive);
+	if (drive->next != drive)
+		drive->dev_flags |= IDE_DFLAG_DSC_OVERLAP;
+	else
+		drive->dev_flags &= ~IDE_DFLAG_DSC_OVERLAP;
 
 	if (ide_cdrom_register(drive, nslots)) {
 		printk(KERN_ERR "%s: %s failed to register device with the"
@@ -1945,7 +1948,7 @@ static void ide_cd_release(struct kref *
 	kfree(info->toc);
 	if (devinfo->handle == drive)
 		unregister_cdrom(devinfo);
-	drive->dsc_overlap = 0;
+	drive->dev_flags &= ~IDE_DFLAG_DSC_OVERLAP;
 	drive->driver_data = NULL;
 	blk_queue_prep_rq(drive->queue, NULL);
 	g->private_data = NULL;
Index: b/drivers/ide/ide-disk.c
===================================================================
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -134,9 +134,9 @@ static ide_startstop_t __ide_do_rw_disk(
 					sector_t block)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
-	unsigned int dma	= drive->using_dma;
 	u16 nsectors		= (u16)rq->nr_sectors;
-	u8 lba48		= (drive->addressing == 1) ? 1 : 0;
+	u8 lba48		= !!(drive->dev_flags & IDE_DFLAG_LBA48);
+	u8 dma			= !!(drive->dev_flags & IDE_DFLAG_USING_DMA);
 	ide_task_t		task;
 	struct ide_taskfile	*tf = &task.tf;
 	ide_startstop_t		rc;
@@ -231,7 +231,7 @@ static ide_startstop_t ide_do_rw_disk(id
 {
 	ide_hwif_t *hwif = HWIF(drive);
 
-	BUG_ON(drive->blocked);
+	BUG_ON(drive->dev_flags & IDE_DFLAG_BLOCKED);
 
 	if (!blk_fs_request(rq)) {
 		blk_dump_rq_flags(rq, "ide_do_rw_disk - bad command");
@@ -446,7 +446,7 @@ static int proc_idedisk_read_cache
 	char		*out = page;
 	int		len;
 
-	if (drive->id_read)
+	if (drive->dev_flags & IDE_DFLAG_ID_READ)
 		len = sprintf(out, "%i\n", drive->id[ATA_ID_BUF_SIZE] / 2);
 	else
 		len = sprintf(out, "(none)\n");
@@ -562,15 +562,20 @@ static int set_multcount(ide_drive_t *dr
 	return (drive->mult_count == arg) ? 0 : -EIO;
 }
 
-ide_devset_get(nowerr, nowerr);
+ide_devset_get_flag(nowerr, IDE_DFLAG_NOWERR);
 
 static int set_nowerr(ide_drive_t *drive, int arg)
 {
 	if (arg < 0 || arg > 1)
 		return -EINVAL;
 
-	drive->nowerr = arg;
+	if (arg)
+		drive->dev_flags |= IDE_DFLAG_NOWERR;
+	else
+		drive->dev_flags &= ~IDE_DFLAG_NOWERR;
+
 	drive->bad_wstat = arg ? BAD_R_STAT : BAD_W_STAT;
+
 	return 0;
 }
 
@@ -593,7 +598,7 @@ static void update_ordered(ide_drive_t *
 	unsigned ordered = QUEUE_ORDERED_NONE;
 	prepare_flush_fn *prep_fn = NULL;
 
-	if (drive->wcache) {
+	if (drive->dev_flags & IDE_DFLAG_WCACHE) {
 		unsigned long long capacity;
 		int barrier;
 		/*
@@ -605,8 +610,10 @@ static void update_ordered(ide_drive_t *
 		 * not available so we don't need to recheck that.
 		 */
 		capacity = idedisk_capacity(drive);
-		barrier = ata_id_flush_enabled(id) && !drive->noflush &&
-			(drive->addressing == 0 || capacity <= (1ULL << 28) ||
+		barrier = ata_id_flush_enabled(id) &&
+			(drive->dev_flags & IDE_DFLAG_NOFLUSH) == 0 &&
+			((drive->dev_flags & IDE_DFLAG_LBA48) == 0 ||
+			 capacity <= (1ULL << 28) ||
 			 ata_id_flush_ext_enabled(id));
 
 		printk(KERN_INFO "%s: cache flushes %ssupported\n",
@@ -622,7 +629,7 @@ static void update_ordered(ide_drive_t *
 	blk_queue_ordered(drive->queue, ordered, prep_fn);
 }
 
-ide_devset_get(wcache, wcache);
+ide_devset_get_flag(wcache, IDE_DFLAG_WCACHE);
 
 static int set_wcache(ide_drive_t *drive, int arg)
 {
@@ -634,8 +641,12 @@ static int set_wcache(ide_drive_t *drive
 	if (ata_id_flush_enabled(drive->id)) {
 		err = ide_do_setfeature(drive,
 			arg ? SETFEATURES_WC_ON : SETFEATURES_WC_OFF, 0);
-		if (err == 0)
-			drive->wcache = arg;
+		if (err == 0) {
+			if (arg)
+				drive->dev_flags |= IDE_DFLAG_WCACHE;
+			else
+				drive->dev_flags &= ~IDE_DFLAG_WCACHE;
+		}
 	}
 
 	update_ordered(drive);
@@ -671,7 +682,7 @@ static int set_acoustic(ide_drive_t *dri
 	return 0;
 }
 
-ide_devset_get(addressing, addressing);
+ide_devset_get_flag(addressing, IDE_DFLAG_LBA48);
 
 /*
  * drive->addressing:
@@ -691,7 +702,10 @@ static int set_addressing(ide_drive_t *d
 	if (arg == 2)
 		arg = 0;
 
-	drive->addressing = arg;
+	if (arg)
+		drive->dev_flags |= IDE_DFLAG_LBA48;
+	else
+		drive->dev_flags &= ~IDE_DFLAG_LBA48;
 
 	return 0;
 }
@@ -737,20 +751,20 @@ static void idedisk_setup(ide_drive_t *d
 
 	ide_proc_register_driver(drive, idkp->driver);
 
-	if (drive->id_read == 0)
+	if ((drive->dev_flags & IDE_DFLAG_ID_READ) == 0)
 		return;
 
-	if (drive->removable) {
+	if (drive->dev_flags & IDE_DFLAG_REMOVABLE) {
 		/*
 		 * Removable disks (eg. SYQUEST); ignore 'WD' drives
 		 */
 		if (m[0] != 'W' || m[1] != 'D')
-			drive->doorlocking = 1;
+			drive->dev_flags |= IDE_DFLAG_DOORLOCKING;
 	}
 
 	(void)set_addressing(drive, 1);
 
-	if (drive->addressing == 1) {
+	if (drive->dev_flags & IDE_DFLAG_LBA48) {
 		int max_s = 2048;
 
 		if (max_s > hwif->rqsize)
@@ -766,7 +780,8 @@ static void idedisk_setup(ide_drive_t *d
 	init_idedisk_capacity(drive);
 
 	/* limit drive capacity to 137GB if LBA48 cannot be used */
-	if (drive->addressing == 0 && drive->capacity64 > 1ULL << 28) {
+	if ((drive->dev_flags & IDE_DFLAG_LBA48) == 0 &&
+	    drive->capacity64 > 1ULL << 28) {
 		printk(KERN_WARNING "%s: cannot use LBA48 - full capacity "
 		       "%llu sectors (%llu MB)\n",
 		       drive->name, (unsigned long long)drive->capacity64,
@@ -774,13 +789,14 @@ static void idedisk_setup(ide_drive_t *d
 		drive->capacity64 = 1ULL << 28;
 	}
 
-	if ((hwif->host_flags & IDE_HFLAG_NO_LBA48_DMA) && drive->addressing) {
+	if ((hwif->host_flags & IDE_HFLAG_NO_LBA48_DMA) &&
+	    (drive->dev_flags & IDE_DFLAG_LBA48)) {
 		if (drive->capacity64 > 1ULL << 28) {
 			printk(KERN_INFO "%s: cannot use LBA48 DMA - PIO mode"
 					 " will be used for accessing sectors "
 					 "> %u\n", drive->name, 1 << 28);
 		} else
-			drive->addressing = 0;
+			drive->dev_flags &= ~IDE_DFLAG_LBA48;
 	}
 
 	/*
@@ -789,7 +805,7 @@ static void idedisk_setup(ide_drive_t *d
 	 */
 	capacity = idedisk_capacity(drive);
 
-	if (!drive->forced_geom) {
+	if ((drive->dev_flags & IDE_DFLAG_FORCED_GEOM) == 0) {
 		if (ata_id_lba48_enabled(drive->id)) {
 			/* compatibility */
 			drive->bios_sect = 63;
@@ -824,14 +840,15 @@ static void idedisk_setup(ide_drive_t *d
 
 	/* write cache enabled? */
 	if ((id[ATA_ID_CSFO] & 1) || ata_id_wcache_enabled(id))
-		drive->wcache = 1;
+		drive->dev_flags |= IDE_DFLAG_WCACHE;
 
 	set_wcache(drive, 1);
 }
 
 static void ide_cacheflush_p(ide_drive_t *drive)
 {
-	if (!drive->wcache || ata_id_flush_enabled(drive->id) == 0)
+	if (ata_id_flush_enabled(drive->id) == 0 ||
+	    (drive->dev_flags & IDE_DFLAG_WCACHE) == 0)
 		return;
 
 	if (do_idedisk_flushcache(drive))
@@ -950,15 +967,16 @@ static int idedisk_open(struct inode *in
 
 	idkp->openers++;
 
-	if (drive->removable && idkp->openers == 1) {
+	if ((drive->dev_flags & IDE_DFLAG_REMOVABLE) && idkp->openers == 1) {
 		check_disk_change(inode->i_bdev);
 		/*
 		 * Ignore the return code from door_lock,
 		 * since the open() has already succeeded,
 		 * and the door_lock is irrelevant at this point.
 		 */
-		if (drive->doorlocking && idedisk_set_doorlock(drive, 1))
-			drive->doorlocking = 0;
+		if ((drive->dev_flags & IDE_DFLAG_DOORLOCKING) &&
+		    idedisk_set_doorlock(drive, 1))
+			drive->dev_flags &= ~IDE_DFLAG_DOORLOCKING;
 	}
 	return 0;
 }
@@ -972,9 +990,10 @@ static int idedisk_release(struct inode 
 	if (idkp->openers == 1)
 		ide_cacheflush_p(drive);
 
-	if (drive->removable && idkp->openers == 1) {
-		if (drive->doorlocking && idedisk_set_doorlock(drive, 0))
-			drive->doorlocking = 0;
+	if ((drive->dev_flags & IDE_DFLAG_REMOVABLE) && idkp->openers == 1) {
+		if ((drive->dev_flags & IDE_DFLAG_DOORLOCKING) &&
+		    idedisk_set_doorlock(drive, 0))
+			drive->dev_flags &= ~IDE_DFLAG_DOORLOCKING;
 	}
 
 	idkp->openers--;
@@ -1025,12 +1044,13 @@ static int idedisk_media_changed(struct 
 	ide_drive_t *drive = idkp->drive;
 
 	/* do not scan partitions twice if this is a removable device */
-	if (drive->attach) {
-		drive->attach = 0;
+	if (drive->dev_flags & IDE_DFLAG_ATTACH) {
+		drive->dev_flags &= ~IDE_DFLAG_ATTACH;
 		return 0;
 	}
+
 	/* if removable, always assume it was changed */
-	return drive->removable;
+	return !!(drive->dev_flags & IDE_DFLAG_REMOVABLE);
 }
 
 static int idedisk_revalidate_disk(struct gendisk *disk)
@@ -1089,13 +1109,14 @@ static int ide_disk_probe(ide_drive_t *d
 	if ((!drive->head || drive->head > 16) && !drive->select.b.lba) {
 		printk(KERN_ERR "%s: INVALID GEOMETRY: %d PHYSICAL HEADS?\n",
 			drive->name, drive->head);
-		drive->attach = 0;
+		drive->dev_flags &= ~IDE_DFLAG_ATTACH;
 	} else
-		drive->attach = 1;
+		drive->dev_flags |= IDE_DFLAG_ATTACH;
 
 	g->minors = 1 << PARTN_BITS;
 	g->driverfs_dev = &drive->gendev;
-	g->flags = drive->removable ? GENHD_FL_REMOVABLE : 0;
+	if (drive->dev_flags & IDE_DFLAG_REMOVABLE)
+		g->flags = GENHD_FL_REMOVABLE;
 	set_capacity(g, idedisk_capacity(drive));
 	g->fops = &idedisk_ops;
 	add_disk(g);
Index: b/drivers/ide/ide-dma.c
===================================================================
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -397,7 +397,7 @@ EXPORT_SYMBOL_GPL(ide_dma_host_set);
 
 void ide_dma_off_quietly(ide_drive_t *drive)
 {
-	drive->using_dma = 0;
+	drive->dev_flags &= ~IDE_DFLAG_USING_DMA;
 	ide_toggle_bounce(drive, 0);
 
 	drive->hwif->dma_ops->dma_host_set(drive, 0);
@@ -430,7 +430,7 @@ EXPORT_SYMBOL(ide_dma_off);
 
 void ide_dma_on(ide_drive_t *drive)
 {
-	drive->using_dma = 1;
+	drive->dev_flags |= IDE_DFLAG_USING_DMA;
 	ide_toggle_bounce(drive, 1);
 
 	drive->hwif->dma_ops->dma_host_set(drive, 1);
@@ -727,7 +727,8 @@ static int ide_tune_dma(ide_drive_t *dri
 	ide_hwif_t *hwif = drive->hwif;
 	u8 speed;
 
-	if (drive->nodma || ata_id_has_dma(drive->id) == 0)
+	if (ata_id_has_dma(drive->id) == 0 ||
+	    (drive->dev_flags & IDE_DFLAG_NODMA))
 		return 0;
 
 	/* consult the list of known "bad" drives */
Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -817,8 +817,8 @@ static int idefloppy_media_changed(struc
 	int ret;
 
 	/* do not scan partitions twice if this is a removable device */
-	if (drive->attach) {
-		drive->attach = 0;
+	if (drive->dev_flags & IDE_DFLAG_ATTACH) {
+		drive->dev_flags &= ~IDE_DFLAG_ATTACH;
 		return 0;
 	}
 	ret = !!(drive->atapi_flags & IDE_AFLAG_MEDIA_CHANGED);
@@ -883,12 +883,13 @@ static int ide_floppy_probe(ide_drive_t 
 	drive->driver_data = floppy;
 
 	idefloppy_setup(drive, floppy);
+	drive->dev_flags |= IDE_DFLAG_ATTACH;
 
 	g->minors = 1 << PARTN_BITS;
 	g->driverfs_dev = &drive->gendev;
-	g->flags = drive->removable ? GENHD_FL_REMOVABLE : 0;
+	if (drive->dev_flags & IDE_DFLAG_REMOVABLE)
+		g->flags = GENHD_FL_REMOVABLE;
 	g->fops = &idefloppy_ops;
-	drive->attach = 1;
 	add_disk(g);
 	return 0;
 
Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -184,7 +184,8 @@ static ide_startstop_t ide_start_power_s
 		if (drive->media != ide_disk)
 			break;
 		/* Not supported? Switch to next step now. */
-		if (!drive->wcache || ata_id_flush_enabled(drive->id) == 0) {
+		if (ata_id_flush_enabled(drive->id) == 0 ||
+		    (drive->dev_flags & IDE_DFLAG_WCACHE) == 0) {
 			ide_complete_power_step(drive, rq, 0, 0);
 			return ide_stopped;
 		}
@@ -222,7 +223,7 @@ static ide_startstop_t ide_start_power_s
 		if (drive->hwif->dma_ops == NULL)
 			break;
 		/*
-		 * TODO: respect ->using_dma setting
+		 * TODO: respect IDE_DFLAG_USING_DMA
 		 */
 		ide_set_dma(drive);
 		break;
@@ -287,7 +288,7 @@ static void ide_complete_pm_request (ide
 	if (blk_pm_suspend_request(rq)) {
 		blk_stop_queue(drive->queue);
 	} else {
-		drive->blocked = 0;
+		drive->dev_flags &= ~IDE_DFLAG_BLOCKED;
 		blk_start_queue(drive->queue);
 	}
 	HWGROUP(drive)->rq = NULL;
@@ -374,7 +375,8 @@ static ide_startstop_t ide_ata_error(ide
 {
 	ide_hwif_t *hwif = drive->hwif;
 
-	if ((stat & ATA_BUSY) || ((stat & ATA_DF) && !drive->nowerr)) {
+	if ((stat & ATA_BUSY) ||
+	    ((stat & ATA_DF) && (drive->dev_flags & IDE_DFLAG_NOWERR) == 0)) {
 		/* other bits are useless when BUSY */
 		rq->errors |= ERROR_RESET;
 	} else if (stat & ATA_ERR) {
@@ -428,7 +430,8 @@ static ide_startstop_t ide_atapi_error(i
 {
 	ide_hwif_t *hwif = drive->hwif;
 
-	if ((stat & ATA_BUSY) || ((stat & ATA_DF) && !drive->nowerr)) {
+	if ((stat & ATA_BUSY) ||
+	    ((stat & ATA_DF) && (drive->dev_flags & IDE_DFLAG_NOWERR) == 0)) {
 		/* other bits are useless when BUSY */
 		rq->errors |= ERROR_RESET;
 	} else {
@@ -607,7 +610,7 @@ static ide_startstop_t do_special (ide_d
 
 		if (set_pio_mode_abuse(drive->hwif, req_pio)) {
 			/*
-			 * take ide_lock for drive->[no_]unmask/[no_]io_32bit
+			 * take ide_lock for IDE_DFLAG_[NO_]UNMASK/[NO_]IO_32BIT
 			 */
 			if (req_pio == 8 || req_pio == 9) {
 				unsigned long flags;
@@ -618,7 +621,8 @@ static ide_startstop_t do_special (ide_d
 			} else
 				port_ops->set_pio_mode(drive, req_pio);
 		} else {
-			int keep_dma = drive->using_dma;
+			int keep_dma =
+				!!(drive->dev_flags & IDE_DFLAG_USING_DMA);
 
 			ide_set_pio(drive, req_pio);
 
@@ -775,7 +779,7 @@ static void ide_check_pm_state(ide_drive
 	if (blk_pm_suspend_request(rq) &&
 	    pm->pm_step == ide_pm_state_start_suspend)
 		/* Mark drive blocked when starting the suspend sequence. */
-		drive->blocked = 1;
+		drive->dev_flags |= IDE_DFLAG_BLOCKED;
 	else if (blk_pm_resume_request(rq) &&
 		 pm->pm_step == ide_pm_state_start_resume) {
 		/* 
@@ -895,7 +899,7 @@ void ide_stall_queue (ide_drive_t *drive
 	if (timeout > WAIT_WORSTCASE)
 		timeout = WAIT_WORSTCASE;
 	drive->sleep = timeout + jiffies;
-	drive->sleeping = 1;
+	drive->dev_flags |= IDE_DFLAG_SLEEPING;
 }
 
 EXPORT_SYMBOL(ide_stall_queue);
@@ -935,18 +939,23 @@ repeat:	
 	}
 
 	do {
-		if ((!drive->sleeping || time_after_eq(jiffies, drive->sleep))
-		    && !elv_queue_empty(drive->queue)) {
-			if (!best
-			 || (drive->sleeping && (!best->sleeping || time_before(drive->sleep, best->sleep)))
-			 || (!best->sleeping && time_before(WAKEUP(drive), WAKEUP(best))))
-			{
+		u8 dev_s = !!(drive->dev_flags & IDE_DFLAG_SLEEPING);
+		u8 best_s = (best && !!(best->dev_flags & IDE_DFLAG_SLEEPING));
+
+		if ((dev_s == 0 || time_after_eq(jiffies, drive->sleep)) &&
+		    !elv_queue_empty(drive->queue)) {
+			if (best == NULL ||
+			    (dev_s && (best_s == 0 || time_before(drive->sleep, best->sleep))) ||
+			    (best_s == 0 && time_before(WAKEUP(drive), WAKEUP(best)))) {
 				if (!blk_queue_plugged(drive->queue))
 					best = drive;
 			}
 		}
 	} while ((drive = drive->next) != hwgroup->drive);
-	if (best && best->nice1 && !best->sleeping && best != hwgroup->drive && best->service_time > WAIT_MIN_SLEEP) {
+
+	if (best && (best->dev_flags & IDE_DFLAG_NICE1) &&
+	    (best->dev_flags & IDE_DFLAG_SLEEPING) == 0 &&
+	    best != hwgroup->drive && best->service_time > WAIT_MIN_SLEEP) {
 		long t = (signed long)(WAKEUP(best) - jiffies);
 		if (t >= WAIT_MIN_SLEEP) {
 		/*
@@ -955,7 +964,7 @@ repeat:	
 		 */
 			drive = best->next;
 			do {
-				if (!drive->sleeping
+				if ((drive->dev_flags & IDE_DFLAG_SLEEPING) == 0
 				 && time_before(jiffies - best->service_time, WAKEUP(drive))
 				 && time_before(WAKEUP(drive), jiffies + t))
 				{
@@ -1026,7 +1035,9 @@ static void ide_do_request (ide_hwgroup_
 			hwgroup->rq = NULL;
 			drive = hwgroup->drive;
 			do {
-				if (drive->sleeping && (!sleeping || time_before(drive->sleep, sleep))) {
+				if ((drive->dev_flags & IDE_DFLAG_SLEEPING) &&
+				    (sleeping == 0 ||
+				     time_before(drive->sleep, sleep))) {
 					sleeping = 1;
 					sleep = drive->sleep;
 				}
@@ -1075,7 +1086,7 @@ static void ide_do_request (ide_hwgroup_
 		}
 		hwgroup->hwif = hwif;
 		hwgroup->drive = drive;
-		drive->sleeping = 0;
+		drive->dev_flags &= ~IDE_DFLAG_SLEEPING;
 		drive->service_start = jiffies;
 
 		if (blk_queue_plugged(drive->queue)) {
@@ -1109,7 +1120,9 @@ static void ide_do_request (ide_hwgroup_
 		 * We count how many times we loop here to make sure we service
 		 * all drives in the hwgroup without looping for ever
 		 */
-		if (drive->blocked && !blk_pm_request(rq) && !(rq->cmd_flags & REQ_PREEMPT)) {
+		if ((drive->dev_flags & IDE_DFLAG_BLOCKED) &&
+		    blk_pm_request(rq) == 0 &&
+		    (rq->cmd_flags & REQ_PREEMPT) == 0) {
 			drive = drive->next ? drive->next : hwgroup->drive;
 			if (loops++ < 4 && !blk_queue_plugged(drive->queue))
 				goto again;
@@ -1491,7 +1504,7 @@ irqreturn_t ide_intr (int irq, void *dev
 		 */
 		hwif->ide_dma_clear_irq(drive);
 
-	if (drive->unmask)
+	if (drive->dev_flags & IDE_DFLAG_UNMASK)
 		local_irq_enable_in_hardirq();
 	/* service this interrupt, may set handler for next interrupt */
 	startstop = handler(drive);
Index: b/drivers/ide/ide-ioctls.c
===================================================================
--- a/drivers/ide/ide-ioctls.c
+++ b/drivers/ide/ide-ioctls.c
@@ -62,7 +62,7 @@ static int ide_get_identity_ioctl(ide_dr
 	int size = (cmd == HDIO_GET_IDENTITY) ? (ATA_ID_WORDS * 2) : 142;
 	int rc = 0;
 
-	if (drive->id_read == 0) {
+	if ((drive->dev_flags & IDE_DFLAG_ID_READ) == 0) {
 		rc = -ENOMSG;
 		goto out;
 	}
@@ -86,8 +86,10 @@ out:
 
 static int ide_get_nice_ioctl(ide_drive_t *drive, unsigned long arg)
 {
-	return put_user((drive->dsc_overlap << IDE_NICE_DSC_OVERLAP) |
-			(drive->nice1 << IDE_NICE_1), (long __user *)arg);
+	return put_user((!!(drive->dev_flags & IDE_DFLAG_DSC_OVERLAP)
+			 << IDE_NICE_DSC_OVERLAP) |
+			(!!(drive->dev_flags & IDE_DFLAG_NICE1)
+			 << IDE_NICE_1), (long __user *)arg);
 }
 
 static int ide_set_nice_ioctl(ide_drive_t *drive, unsigned long arg)
@@ -97,11 +99,18 @@ static int ide_set_nice_ioctl(ide_drive_
 
 	if (((arg >> IDE_NICE_DSC_OVERLAP) & 1) &&
 	    (drive->media == ide_disk || drive->media == ide_floppy ||
-	     drive->scsi))
+	     (drive->dev_flags & IDE_DFLAG_SCSI)))
 		return -EPERM;
 
-	drive->dsc_overlap = (arg >> IDE_NICE_DSC_OVERLAP) & 1;
-	drive->nice1 = (arg >> IDE_NICE_1) & 1;
+	if ((arg >> IDE_NICE_DSC_OVERLAP) & 1)
+		drive->dev_flags |= IDE_DFLAG_DSC_OVERLAP;
+	else
+		drive->dev_flags &= ~IDE_DFLAG_DSC_OVERLAP;
+
+	if ((arg >> IDE_NICE_1) & 1)
+		drive->dev_flags |= IDE_DFLAG_NICE1;
+	else
+		drive->dev_flags &= ~IDE_DFLAG_NICE1;
 
 	return 0;
 }
Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -647,7 +647,7 @@ u8 eighty_ninty_three (ide_drive_t *driv
 		return 1;
 
 no_80w:
-	if (drive->udma33_warned == 1)
+	if (drive->dev_flags & IDE_DFLAG_UDMA33_WARNED)
 		return 0;
 
 	printk(KERN_WARNING "%s: %s side 80-wire cable detection failed, "
@@ -655,7 +655,7 @@ no_80w:
 			    drive->name,
 			    hwif->cbl == ATA_CBL_PATA80 ? "drive" : "host");
 
-	drive->udma33_warned = 1;
+	drive->dev_flags |= IDE_DFLAG_UDMA33_WARNED;
 
 	return 0;
 }
@@ -711,7 +711,7 @@ int ide_driveid_update(ide_drive_t *driv
 
 	kfree(id);
 
-	if (drive->using_dma && ide_id_dma_bug(drive))
+	if ((drive->dev_flags & IDE_DFLAG_USING_DMA) && ide_id_dma_bug(drive))
 		ide_dma_off(drive);
 
 	return 1;
@@ -790,7 +790,7 @@ int ide_config_drive_speed(ide_drive_t *
 
  skip:
 #ifdef CONFIG_BLK_DEV_IDEDMA
-	if (speed >= XFER_SW_DMA_0 && drive->using_dma)
+	if (speed >= XFER_SW_DMA_0 && (drive->dev_flags & IDE_DFLAG_USING_DMA))
 		hwif->dma_ops->dma_host_set(drive, 1);
 	else if (hwif->dma_ops)	/* check if host supports DMA */
 		ide_dma_off_quietly(drive);
@@ -1016,9 +1016,13 @@ static void ide_disk_pre_reset(ide_drive
 	drive->special.all = 0;
 	drive->special.b.set_geometry = legacy;
 	drive->special.b.recalibrate  = legacy;
+
 	drive->mult_count = 0;
-	if (!drive->keep_settings && !drive->using_dma)
+
+	if ((drive->dev_flags & IDE_DFLAG_KEEP_SETTINGS) == 0 &&
+	    (drive->dev_flags & IDE_DFLAG_USING_DMA) == 0)
 		drive->mult_req = 0;
+
 	if (drive->mult_req != drive->mult_count)
 		drive->special.b.set_multmode = 1;
 }
@@ -1030,18 +1034,18 @@ static void pre_reset(ide_drive_t *drive
 	if (drive->media == ide_disk)
 		ide_disk_pre_reset(drive);
 	else
-		drive->post_reset = 1;
+		drive->dev_flags |= IDE_DFLAG_POST_RESET;
 
-	if (drive->using_dma) {
+	if (drive->dev_flags & IDE_DFLAG_USING_DMA) {
 		if (drive->crc_count)
 			ide_check_dma_crc(drive);
 		else
 			ide_dma_off(drive);
 	}
 
-	if (!drive->keep_settings) {
-		if (!drive->using_dma) {
-			drive->unmask = 0;
+	if ((drive->dev_flags & IDE_DFLAG_KEEP_SETTINGS) == 0) {
+		if ((drive->dev_flags & IDE_DFLAG_USING_DMA) == 0) {
+			drive->dev_flags &= ~IDE_DFLAG_UNMASK;
 			drive->io_32bit = 0;
 		}
 		return;
Index: b/drivers/ide/ide-lib.c
===================================================================
--- a/drivers/ide/ide-lib.c
+++ b/drivers/ide/ide-lib.c
@@ -317,7 +317,7 @@ static void ide_dump_sector(ide_drive_t 
 {
 	ide_task_t task;
 	struct ide_taskfile *tf = &task.tf;
-	int lba48 = (drive->addressing == 1) ? 1 : 0;
+	u8 lba48 = !!(drive->dev_flags & IDE_DFLAG_LBA48);
 
 	memset(&task, 0, sizeof(task));
 	if (lba48)
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -121,7 +121,8 @@ static inline void do_identify (ide_driv
 	/* read 512 bytes of id info */
 	hwif->tp_ops->input_data(drive, NULL, id, SECTOR_SIZE);
 
-	drive->id_read = 1;
+	drive->dev_flags |= IDE_DFLAG_ID_READ;
+
 	local_irq_enable();
 #ifdef DEBUG
 	printk(KERN_INFO "%s: dumping identify data\n", drive->name);
@@ -153,8 +154,8 @@ static inline void do_identify (ide_driv
 
 	printk(KERN_INFO "%s: %s, ", drive->name, m);
 
-	drive->present = 1;
-	drive->dead = 0;
+	drive->dev_flags |= IDE_DFLAG_PRESENT;
+	drive->dev_flags &= ~IDE_DFLAG_DEAD;
 
 	/*
 	 * Check for an ATAPI device
@@ -172,14 +173,14 @@ static inline void do_identify (ide_driv
 						printk(KERN_CONT "cdrom or floppy?, assuming ");
 					if (drive->media != ide_cdrom) {
 						printk(KERN_CONT "FLOPPY");
-						drive->removable = 1;
+						drive->dev_flags |= IDE_DFLAG_REMOVABLE;
 						break;
 					}
 				}
 				/* Early cdrom models used zero */
 				type = ide_cdrom;
 			case ide_cdrom:
-				drive->removable = 1;
+				drive->dev_flags |= IDE_DFLAG_REMOVABLE;
 #ifdef CONFIG_PPC
 				/* kludge for Apple PowerBook internal zip */
 				if (!strstr(m, "CD-ROM") && strstr(m, "ZIP")) {
@@ -195,7 +196,7 @@ static inline void do_identify (ide_driv
 				break;
 			case ide_optical:
 				printk(KERN_CONT "OPTICAL");
-				drive->removable = 1;
+				drive->dev_flags |= IDE_DFLAG_REMOVABLE;
 				break;
 			default:
 				printk(KERN_CONT "UNKNOWN (type %d)", type);
@@ -216,7 +217,7 @@ static inline void do_identify (ide_driv
 
 	/* CF devices are *not* removable in Linux definition of the term */
 	if (is_cfa == 0 && (id[ATA_ID_CONFIG] & (1 << 7)))
-		drive->removable = 1;
+		drive->dev_flags |= IDE_DFLAG_REMOVABLE;
 
 	drive->media = ide_disk;
 
@@ -226,7 +227,7 @@ static inline void do_identify (ide_driv
 
 err_misc:
 	kfree(id);
-	drive->present = 0;
+	drive->dev_flags &= ~IDE_DFLAG_PRESENT;
 	return;
 }
 
@@ -426,16 +427,15 @@ static int do_probe (ide_drive_t *drive,
 	ide_hwif_t *hwif = HWIF(drive);
 	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
 	int rc;
-	u8 stat;
+	u8 present = !!(drive->dev_flags & IDE_DFLAG_PRESENT), stat;
+
+	/* avoid waiting for inappropriate probes */
+	if (present && drive->media != ide_disk && cmd == ATA_CMD_ID_ATA)
+		return 4;
 
-	if (drive->present) {
-		/* avoid waiting for inappropriate probes */
-		if (drive->media != ide_disk && cmd == ATA_CMD_ID_ATA)
-			return 4;
-	}
 #ifdef DEBUG
 	printk(KERN_INFO "probing for %s: present=%d, media=%d, probetype=%s\n",
-		drive->name, drive->present, drive->media,
+		drive->name, present, drive->media,
 		(cmd == ATA_CMD_ID_ATA) ? "ATA" : "ATAPI");
 #endif
 
@@ -446,7 +446,7 @@ static int do_probe (ide_drive_t *drive,
 	SELECT_DRIVE(drive);
 	msleep(50);
 
-	if (ide_read_device(drive) != drive->select.all && !drive->present) {
+	if (ide_read_device(drive) != drive->select.all && present == 0) {
 		if (drive->select.b.unit != 0) {
 			/* exit with drive0 selected */
 			SELECT_DRIVE(&hwif->drives[0]);
@@ -460,7 +460,7 @@ static int do_probe (ide_drive_t *drive,
 	stat = tp_ops->read_status(hwif);
 
 	if (OK_STAT(stat, ATA_DRDY, ATA_BUSY) ||
-	    drive->present || cmd == ATA_CMD_ID_ATAPI) {
+	    present || cmd == ATA_CMD_ID_ATAPI) {
 		/* send cmd and wait */
 		if ((rc = try_to_identify(drive, cmd))) {
 			/* failed: try again */
@@ -542,8 +542,8 @@ static void enable_nest (ide_drive_t *dr
  *	and presents things to the user as needed.
  *
  *	Returns:	0  no device was found
- *			1  device was found (note: drive->present might
- *			   still be 0)
+ *			1  device was found
+ *			   (note: IDE_DFLAG_PRESENT might still be not set)
  */
  
 static inline u8 probe_for_drive (ide_drive_t *drive)
@@ -559,10 +559,10 @@ static inline u8 probe_for_drive (ide_dr
 	 *	Also note that 0 everywhere means "can't do X"
 	 */
  
+	drive->dev_flags &= ~IDE_DFLAG_ID_READ;
+
 	drive->id = kzalloc(SECTOR_SIZE, GFP_KERNEL);
-	drive->id_read = 0;
-	if(drive->id == NULL)
-	{
+	if (drive->id == NULL) {
 		printk(KERN_ERR "ide: out of memory for id data.\n");
 		return 0;
 	}
@@ -571,14 +571,14 @@ static inline u8 probe_for_drive (ide_dr
 	strcpy(m, "UNKNOWN");
 
 	/* skip probing? */
-	if (!drive->noprobe) {
+	if ((drive->dev_flags & IDE_DFLAG_NOPROBE) == 0) {
 retry:
 		/* if !(success||timed-out) */
 		if (do_probe(drive, ATA_CMD_ID_ATA) >= 2)
 			/* look for ATAPI device */
 			(void)do_probe(drive, ATA_CMD_ID_ATAPI);
 
-		if (!drive->present)
+		if ((drive->dev_flags & IDE_DFLAG_PRESENT) == 0)
 			/* drive not found */
 			return 0;
 
@@ -588,7 +588,7 @@ retry:
 		}
 
 		/* identification failed? */
-		if (!drive->id_read) {
+		if ((drive->dev_flags & IDE_DFLAG_ID_READ) == 0) {
 			if (drive->media == ide_disk) {
 				printk(KERN_INFO "%s: non-IDE drive, CHS=%d/%d/%d\n",
 					drive->name, drive->cyl,
@@ -598,15 +598,17 @@ retry:
 			} else {
 				/* nuke it */
 				printk(KERN_WARNING "%s: Unknown device on bus refused identification. Ignoring.\n", drive->name);
-				drive->present = 0;
+				drive->dev_flags &= ~IDE_DFLAG_PRESENT;
 			}
 		}
 		/* drive was found */
 	}
-	if(!drive->present)
+
+	if ((drive->dev_flags & IDE_DFLAG_PRESENT) == 0)
 		return 0;
+
 	/* The drive wasn't being helpful. Add generic info only */
-	if (drive->id_read == 0) {
+	if ((drive->dev_flags & IDE_DFLAG_ID_READ) == 0) {
 		generic_id(drive);
 		return 1;
 	}
@@ -616,7 +618,7 @@ retry:
 		ide_disk_init_mult_count(drive);
 	}
 
-	return drive->present;
+	return !!(drive->dev_flags & IDE_DFLAG_PRESENT);
 }
 
 static void hwif_release_dev(struct device *dev)
@@ -707,7 +709,8 @@ static int ide_port_wait_ready(ide_hwif_
 		ide_drive_t *drive = &hwif->drives[unit];
 
 		/* Ignore disks that we will not probe for later. */
-		if (!drive->noprobe || drive->present) {
+		if ((drive->dev_flags & IDE_DFLAG_NOPROBE) == 0 ||
+		    (drive->dev_flags & IDE_DFLAG_PRESENT)) {
 			SELECT_DRIVE(drive);
 			hwif->tp_ops->set_irq(hwif, 1);
 			mdelay(2);
@@ -739,7 +742,7 @@ void ide_undecoded_slave(ide_drive_t *de
 {
 	ide_drive_t *dev0 = &dev1->hwif->drives[0];
 
-	if ((dev1->dn & 1) == 0 || dev0->present == 0)
+	if ((dev1->dn & 1) == 0 || (dev0->dev_flags & IDE_DFLAG_PRESENT) == 0)
 		return;
 
 	/* If the models don't match they are not the same product */
@@ -759,7 +762,7 @@ void ide_undecoded_slave(ide_drive_t *de
 	/* Appears to be an IDE flash adapter with decode bugs */
 	printk(KERN_WARNING "ide-probe: ignoring undecoded slave\n");
 
-	dev1->present = 0;
+	dev1->dev_flags &= ~IDE_DFLAG_PRESENT;
 }
 
 EXPORT_SYMBOL_GPL(ide_undecoded_slave);
@@ -772,7 +775,8 @@ static int ide_probe_port(ide_hwif_t *hw
 
 	BUG_ON(hwif->present);
 
-	if (hwif->drives[0].noprobe && hwif->drives[1].noprobe)
+	if ((hwif->drives[0].dev_flags & IDE_DFLAG_NOPROBE) &&
+	    (hwif->drives[1].dev_flags & IDE_DFLAG_NOPROBE))
 		return -EACCES;
 
 	/*
@@ -796,7 +800,7 @@ static int ide_probe_port(ide_hwif_t *hw
 		ide_drive_t *drive = &hwif->drives[unit];
 		drive->dn = (hwif->channel ? 2 : 0) + unit;
 		(void) probe_for_drive(drive);
-		if (drive->present)
+		if (drive->dev_flags & IDE_DFLAG_PRESENT)
 			rc = 0;
 	}
 
@@ -820,17 +824,19 @@ static void ide_port_tune_devices(ide_hw
 	for (unit = 0; unit < MAX_DRIVES; unit++) {
 		ide_drive_t *drive = &hwif->drives[unit];
 
-		if (drive->present && port_ops && port_ops->quirkproc)
-			port_ops->quirkproc(drive);
+		if (drive->dev_flags & IDE_DFLAG_PRESENT) {
+			if (port_ops && port_ops->quirkproc)
+				port_ops->quirkproc(drive);
+		}
 	}
 
 	for (unit = 0; unit < MAX_DRIVES; ++unit) {
 		ide_drive_t *drive = &hwif->drives[unit];
 
-		if (drive->present) {
+		if (drive->dev_flags & IDE_DFLAG_PRESENT) {
 			ide_set_max_pio(drive);
 
-			drive->nice1 = 1;
+			drive->dev_flags |= IDE_DFLAG_NICE1;
 
 			if (hwif->dma_ops)
 				ide_set_dma(drive);
@@ -840,10 +846,11 @@ static void ide_port_tune_devices(ide_hw
 	for (unit = 0; unit < MAX_DRIVES; ++unit) {
 		ide_drive_t *drive = &hwif->drives[unit];
 
-		if (hwif->host_flags & IDE_HFLAG_NO_IO_32BIT)
-			drive->no_io_32bit = 1;
+		if ((hwif->host_flags & IDE_HFLAG_NO_IO_32BIT) ||
+		    drive->id[ATA_ID_DWORD_IO])
+			drive->dev_flags |= IDE_DFLAG_NO_IO_32BIT;
 		else
-			drive->no_io_32bit = drive->id[ATA_ID_DWORD_IO] ? 1 : 0;
+			drive->dev_flags &= ~IDE_DFLAG_NO_IO_32BIT;
 	}
 }
 
@@ -957,7 +964,7 @@ static void ide_port_setup_devices(ide_h
 	for (i = 0; i < MAX_DRIVES; i++) {
 		ide_drive_t *drive = &hwif->drives[i];
 
-		if (!drive->present)
+		if ((drive->dev_flags & IDE_DFLAG_PRESENT) == 0)
 			continue;
 
 		if (ide_init_queue(drive)) {
@@ -1151,12 +1158,13 @@ static struct kobject *ata_probe(dev_t d
 	ide_hwif_t *hwif = data;
 	int unit = *part >> PARTN_BITS;
 	ide_drive_t *drive = &hwif->drives[unit];
-	if (!drive->present)
+
+	if ((drive->dev_flags & IDE_DFLAG_PRESENT) == 0)
 		return NULL;
 
 	if (drive->media == ide_disk)
 		request_module("ide-disk");
-	if (drive->scsi)
+	if (drive->dev_flags & IDE_DFLAG_SCSI)
 		request_module("ide-scsi");
 	if (drive->media == ide_cdrom || drive->media == ide_optical)
 		request_module("ide-cd");
@@ -1246,7 +1254,7 @@ static void drive_release_dev (struct de
 	ide_remove_drive_from_hwgroup(drive);
 	kfree(drive->id);
 	drive->id = NULL;
-	drive->present = 0;
+	drive->dev_flags &= ~IDE_DFLAG_PRESENT;
 	/* Messed up locking ... */
 	spin_unlock_irq(&ide_lock);
 	blk_cleanup_queue(drive->queue);
@@ -1325,7 +1333,7 @@ static void hwif_register_devices(ide_hw
 		struct device *dev = &drive->gendev;
 		int ret;
 
-		if (!drive->present)
+		if ((drive->dev_flags & IDE_DFLAG_PRESENT) == 0)
 			continue;
 
 		snprintf(dev->bus_id, BUS_ID_SIZE, "%u.%u", hwif->index, i);
@@ -1352,9 +1360,9 @@ static void ide_port_init_devices(ide_hw
 		if (hwif->host_flags & IDE_HFLAG_IO_32BIT)
 			drive->io_32bit = 1;
 		if (hwif->host_flags & IDE_HFLAG_UNMASK_IRQS)
-			drive->unmask = 1;
+			drive->dev_flags |= IDE_DFLAG_UNMASK;
 		if (hwif->host_flags & IDE_HFLAG_NO_UNMASK_IRQS)
-			drive->no_unmask = 1;
+			drive->dev_flags |= IDE_DFLAG_NO_UNMASK;
 
 		if (port_ops && port_ops->init_dev)
 			port_ops->init_dev(drive);
Index: b/drivers/ide/ide-proc.c
===================================================================
--- a/drivers/ide/ide-proc.c
+++ b/drivers/ide/ide-proc.c
@@ -227,7 +227,7 @@ static int set_xfer_rate (ide_drive_t *d
 
 ide_devset_rw(current_speed, xfer_rate);
 ide_devset_rw_field(init_speed, init_speed);
-ide_devset_rw_field(nice1, nice1);
+ide_devset_rw_flag(nice1, IDE_DFLAG_NICE1);
 ide_devset_rw_field(number, dn);
 
 static const struct ide_proc_devset ide_generic_settings[] = {
@@ -622,9 +622,7 @@ void ide_proc_port_register_devices(ide_
 	for (d = 0; d < MAX_DRIVES; d++) {
 		ide_drive_t *drive = &hwif->drives[d];
 
-		if (!drive->present)
-			continue;
-		if (drive->proc)
+		if ((drive->dev_flags & IDE_DFLAG_PRESENT) == 0 || drive->proc)
 			continue;
 
 		drive->proc = proc_mkdir(drive->name, parent);
Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -832,12 +832,13 @@ static ide_startstop_t idetape_do_reques
 	 */
 	stat = hwif->tp_ops->read_status(hwif);
 
-	if (!drive->dsc_overlap && !(rq->cmd[13] & REQ_IDETAPE_PC2))
+	if ((drive->dev_flags & IDE_DFLAG_DSC_OVERLAP) == 0 &&
+	    (rq->cmd[13] & REQ_IDETAPE_PC2) == 0)
 		set_bit(IDE_AFLAG_IGNORE_DSC, &drive->atapi_flags);
 
-	if (drive->post_reset == 1) {
+	if (drive->dev_flags & IDE_DFLAG_POST_RESET) {
 		set_bit(IDE_AFLAG_IGNORE_DSC, &drive->atapi_flags);
-		drive->post_reset = 0;
+		drive->dev_flags &= ~IDE_DFLAG_POST_RESET;
 	}
 
 	if (!test_and_clear_bit(IDE_AFLAG_IGNORE_DSC, &drive->atapi_flags) &&
@@ -1360,7 +1361,7 @@ static int idetape_init_read(ide_drive_t
 		 * No point in issuing this if DSC overlap isn't supported, some
 		 * drives (Seagate STT3401A) will return an error.
 		 */
-		if (drive->dsc_overlap) {
+		if (drive->dev_flags & IDE_DFLAG_DSC_OVERLAP) {
 			bytes_read = idetape_queue_rw_tail(drive,
 							REQ_IDETAPE_READ, 0,
 							tape->merge_bh);
@@ -1636,7 +1637,7 @@ static ssize_t idetape_chrdev_write(stru
 		 * point in issuing this if DSC overlap isn't supported, some
 		 * drives (Seagate STT3401A) will return an error.
 		 */
-		if (drive->dsc_overlap) {
+		if (drive->dev_flags & IDE_DFLAG_DSC_OVERLAP) {
 			ssize_t retval = idetape_queue_rw_tail(drive,
 							REQ_IDETAPE_WRITE, 0,
 							tape->merge_bh);
@@ -2151,7 +2152,7 @@ static int divf_tdsc(ide_drive_t *drive)
 static int divf_buffer(ide_drive_t *drive)	{ return    2; }
 static int divf_buffer_size(ide_drive_t *drive)	{ return 1024; }
 
-ide_devset_rw_field(dsc_overlap, dsc_overlap);
+ide_devset_rw_flag(dsc_overlap, IDE_DFLAG_DSC_OVERLAP);
 
 ide_tape_devset_rw_field(debug_mask, debug_mask);
 ide_tape_devset_rw_field(tdsc, best_dsc_rw_freq);
@@ -2198,15 +2199,19 @@ static void idetape_setup(ide_drive_t *d
 	drive->pc_io_buffers	 = ide_tape_io_buffers;
 
 	spin_lock_init(&tape->lock);
-	drive->dsc_overlap = 1;
+
+	drive->dev_flags |= IDE_DFLAG_DSC_OVERLAP;
+
 	if (drive->hwif->host_flags & IDE_HFLAG_NO_DSC) {
 		printk(KERN_INFO "ide-tape: %s: disabling DSC overlap\n",
 				 tape->name);
-		drive->dsc_overlap = 0;
+		drive->dev_flags &= ~IDE_DFLAG_DSC_OVERLAP;
 	}
+
 	/* Seagate Travan drives do not support DSC overlap. */
 	if (strstr((char *)&drive->id[ATA_ID_PROD], "Seagate STT3401"))
-		drive->dsc_overlap = 0;
+		drive->dev_flags &= ~IDE_DFLAG_DSC_OVERLAP;
+
 	tape->minor = minor;
 	tape->name[0] = 'h';
 	tape->name[1] = 't';
@@ -2253,7 +2258,7 @@ static void idetape_setup(ide_drive_t *d
 		(*(u16 *)&tape->caps[16] * 512) / tape->buffer_size,
 		tape->buffer_size / 1024,
 		tape->best_dsc_rw_freq * 1000 / HZ,
-		drive->using_dma ? ", DMA":"");
+		(drive->dev_flags & IDE_DFLAG_USING_DMA) ? ", DMA" : "");
 
 	ide_proc_register_driver(drive, tape->driver);
 }
@@ -2277,7 +2282,7 @@ static void ide_tape_release(struct kref
 
 	BUG_ON(tape->merge_bh_size);
 
-	drive->dsc_overlap = 0;
+	drive->dev_flags &= ~IDE_DFLAG_DSC_OVERLAP;
 	drive->driver_data = NULL;
 	device_destroy(idetape_sysfs_class, MKDEV(IDETAPE_MAJOR, tape->minor));
 	device_destroy(idetape_sysfs_class,
@@ -2392,7 +2397,8 @@ static int ide_tape_probe(ide_drive_t *d
 	if (drive->media != ide_tape)
 		goto failed;
 
-	if (drive->id_read == 1 && !ide_check_atapi_device(drive, DRV_NAME)) {
+	if ((drive->dev_flags & IDE_DFLAG_ID_READ) &&
+	    ide_check_atapi_device(drive, DRV_NAME) == 0) {
 		printk(KERN_ERR "ide-tape: %s: not supported by this version of"
 				" the driver\n", drive->name);
 		goto failed;
Index: b/drivers/ide/ide-taskfile.c
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -116,7 +116,8 @@ ide_startstop_t do_rw_taskfile (ide_driv
 				    WAIT_WORSTCASE, NULL);
 		return ide_started;
 	default:
-		if (drive->using_dma == 0 || dma_ops->dma_setup(drive))
+		if ((drive->dev_flags & IDE_DFLAG_USING_DMA) == 0 ||
+		    dma_ops->dma_setup(drive))
 			return ide_stopped;
 		dma_ops->dma_exec_cmd(drive, tf->command);
 		dma_ops->dma_start(drive);
@@ -469,13 +470,12 @@ static ide_startstop_t pre_task_out_intr
 	if (ide_wait_stat(&startstop, drive, ATA_DRQ,
 			  drive->bad_wstat, WAIT_DRQ)) {
 		printk(KERN_ERR "%s: no DRQ after issuing %sWRITE%s\n",
-				drive->name,
-				drive->hwif->data_phase ? "MULT" : "",
-				drive->addressing ? "_EXT" : "");
+			drive->name, drive->hwif->data_phase ? "MULT" : "",
+			(drive->dev_flags & IDE_DFLAG_LBA48) ? "_EXT" : "");
 		return startstop;
 	}
 
-	if (!drive->unmask)
+	if ((drive->dev_flags & IDE_DFLAG_UNMASK) == 0)
 		local_irq_disable();
 
 	ide_set_handler(drive, &task_out_intr, WAIT_WORSTCASE, NULL);
@@ -591,7 +591,7 @@ int ide_taskfile_ioctl (ide_drive_t *dri
 
 	args.tf_flags = IDE_TFLAG_IO_16BIT | IDE_TFLAG_DEVICE |
 			IDE_TFLAG_IN_TF;
-	if (drive->addressing == 1)
+	if (drive->dev_flags & IDE_DFLAG_LBA48)
 		args.tf_flags |= (IDE_TFLAG_LBA48 | IDE_TFLAG_IN_HOB);
 
 	if (req_task->out_flags.all) {
@@ -694,7 +694,7 @@ int ide_taskfile_ioctl (ide_drive_t *dri
 	if ((args.tf_flags & IDE_TFLAG_FLAGGED_SET_IN_FLAGS) &&
 	    req_task->in_flags.all == 0) {
 		req_task->in_flags.all = IDE_TASKFILE_STD_IN_FLAGS;
-		if (drive->addressing == 1)
+		if (drive->dev_flags & IDE_DFLAG_LBA48)
 			req_task->in_flags.all |= (IDE_HOB_STD_IN_FLAGS << 8);
 	}
 
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -138,7 +138,7 @@ static void __ide_port_unregister_device
 	for (i = 0; i < MAX_DRIVES; i++) {
 		ide_drive_t *drive = &hwif->drives[i];
 
-		if (drive->present) {
+		if (drive->dev_flags & IDE_DFLAG_PRESENT) {
 			spin_unlock_irq(&ide_lock);
 			device_unregister(&drive->gendev);
 			wait_for_completion(&drive->gendev_rel_comp);
@@ -254,7 +254,7 @@ ide_devset_get(io_32bit, io_32bit);
 
 static int set_io_32bit(ide_drive_t *drive, int arg)
 {
-	if (drive->no_io_32bit)
+	if (drive->dev_flags & IDE_DFLAG_NO_IO_32BIT)
 		return -EPERM;
 
 	if (arg < 0 || arg > 1 + (SUPPORT_VLB_SYNC << 1))
@@ -265,19 +265,22 @@ static int set_io_32bit(ide_drive_t *dri
 	return 0;
 }
 
-ide_devset_get(ksettings, keep_settings);
+ide_devset_get_flag(ksettings, IDE_DFLAG_KEEP_SETTINGS);
 
 static int set_ksettings(ide_drive_t *drive, int arg)
 {
 	if (arg < 0 || arg > 1)
 		return -EINVAL;
 
-	drive->keep_settings = arg;
+	if (arg)
+		drive->dev_flags |= IDE_DFLAG_KEEP_SETTINGS;
+	else
+		drive->dev_flags &= ~IDE_DFLAG_KEEP_SETTINGS;
 
 	return 0;
 }
 
-ide_devset_get(using_dma, using_dma);
+ide_devset_get_flag(using_dma, IDE_DFLAG_USING_DMA);
 
 static int set_using_dma(ide_drive_t *drive, int arg)
 {
@@ -339,17 +342,20 @@ static int set_pio_mode(ide_drive_t *dri
 	return 0;
 }
 
-ide_devset_get(unmaskirq, unmask);
+ide_devset_get_flag(unmaskirq, IDE_DFLAG_UNMASK);
 
 static int set_unmaskirq(ide_drive_t *drive, int arg)
 {
-	if (drive->no_unmask)
+	if (drive->dev_flags & IDE_DFLAG_NO_UNMASK)
 		return -EPERM;
 
 	if (arg < 0 || arg > 1)
 		return -EINVAL;
 
-	drive->unmask = arg;
+	if (arg)
+		drive->dev_flags |= IDE_DFLAG_UNMASK;
+	else
+		drive->dev_flags &= ~IDE_DFLAG_UNMASK;
 
 	return 0;
 }
@@ -713,16 +719,16 @@ static void ide_dev_apply_params(ide_dri
 
 	if (ide_nodma & (1 << i)) {
 		printk(KERN_INFO "ide: disallowing DMA for %s\n", drive->name);
-		drive->nodma = 1;
+		drive->dev_flags |= IDE_DFLAG_NODMA;
 	}
 	if (ide_noflush & (1 << i)) {
 		printk(KERN_INFO "ide: disabling flush requests for %s\n",
 				 drive->name);
-		drive->noflush = 1;
+		drive->dev_flags |= IDE_DFLAG_NOFLUSH;
 	}
 	if (ide_noprobe & (1 << i)) {
 		printk(KERN_INFO "ide: skipping probe for %s\n", drive->name);
-		drive->noprobe = 1;
+		drive->dev_flags |= IDE_DFLAG_NOPROBE;
 	}
 	if (ide_nowerr & (1 << i)) {
 		printk(KERN_INFO "ide: ignoring the ATA_DF bit for %s\n",
@@ -731,7 +737,7 @@ static void ide_dev_apply_params(ide_dri
 	}
 	if (ide_cdroms & (1 << i)) {
 		printk(KERN_INFO "ide: forcing %s as a CD-ROM\n", drive->name);
-		drive->present = 1;
+		drive->dev_flags |= IDE_DFLAG_PRESENT;
 		drive->media = ide_cdrom;
 		/* an ATAPI device ignores DRDY */
 		drive->ready_stat = 0;
@@ -740,11 +746,12 @@ static void ide_dev_apply_params(ide_dri
 		drive->cyl  = drive->bios_cyl  = ide_disks_chs[i].cyl;
 		drive->head = drive->bios_head = ide_disks_chs[i].head;
 		drive->sect = drive->bios_sect = ide_disks_chs[i].sect;
-		drive->forced_geom = 1;
+
 		printk(KERN_INFO "ide: forcing %s as a disk (%d/%d/%d)\n",
 				 drive->name,
 				 drive->cyl, drive->head, drive->sect);
-		drive->present = 1;
+
+		drive->dev_flags |= IDE_DFLAG_FORCED_GEOM | IDE_DFLAG_PRESENT;
 		drive->media = ide_disk;
 		drive->ready_stat = ATA_DRDY;
 	}
Index: b/drivers/ide/legacy/ht6560b.c
===================================================================
--- a/drivers/ide/legacy/ht6560b.c
+++ b/drivers/ide/legacy/ht6560b.c
@@ -120,7 +120,8 @@ static void ht6560b_selectproc (ide_driv
 	 * Need to enforce prefetch sometimes because otherwise
 	 * it'll hang (hard).
 	 */
-	if (drive->media != ide_disk || !drive->present)
+	if (drive->media != ide_disk ||
+	    (drive->dev_flags & IDE_DFLAG_PRESENT) == 0)
 		select |= HT_PREFETCH_MODE;
 
 	if (select != current_select || timing != current_timing) {
@@ -249,11 +250,11 @@ static void ht_set_prefetch(ide_drive_t 
 	 */
 	if (state) {
 		drive->drive_data |= t;   /* enable prefetch mode */
-		drive->no_unmask = 1;
-		drive->unmask = 0;
+		drive->dev_flags |= IDE_DFLAG_NO_UNMASK;
+		drive->dev_flags &= ~IDE_DFLAG_UNMASK;
 	} else {
 		drive->drive_data &= ~t;  /* disable prefetch mode */
-		drive->no_unmask = 0;
+		drive->dev_flags &= ~IDE_DFLAG_NO_UNMASK;
 	}
 
 	spin_unlock_irqrestore(&ht6560b_lock, flags);
Index: b/drivers/ide/pci/amd74xx.c
===================================================================
--- a/drivers/ide/pci/amd74xx.c
+++ b/drivers/ide/pci/amd74xx.c
@@ -92,7 +92,7 @@ static void amd_set_drive(ide_drive_t *d
 
 	ide_timing_compute(drive, speed, &t, T, UT);
 
-	if (peer->present) {
+	if (peer->dev_flags & IDE_DFLAG_PRESENT) {
 		ide_timing_compute(peer, peer->current_speed, &p, T, UT);
 		ide_timing_merge(&p, &t, &t, IDE_TIMING_8BIT);
 	}
Index: b/drivers/ide/pci/cmd640.c
===================================================================
--- a/drivers/ide/pci/cmd640.c
+++ b/drivers/ide/pci/cmd640.c
@@ -378,13 +378,13 @@ static void __set_prefetch_mode(ide_driv
 {
 	if (mode) {	/* want prefetch on? */
 #if CMD640_PREFETCH_MASKS
-		drive->no_unmask = 1;
-		drive->unmask = 0;
+		drive->dev_flags |= IDE_DFLAG_NO_UNMASK;
+		drive->dev_flags &= ~IDE_DFLAG_UNMASK;
 #endif
-		drive->no_io_32bit = 0;
+		drive->dev_flags &= ~IDE_DFLAG_NO_IO_32BIT;
 	} else {
-		drive->no_unmask = 0;
-		drive->no_io_32bit = 1;
+		drive->dev_flags &= ~IDE_DFLAG_NO_UNMASK;
+		drive->dev_flags |= IDE_DFLAG_NO_IO_32BIT;
 		drive->io_32bit = 0;
 	}
 }
@@ -471,7 +471,7 @@ static void program_drive_counts(ide_dri
 		ide_drive_t *peer = &hwif->drives[!drive->select.b.unit];
 		unsigned int mate = index ^ 1;
 
-		if (peer->present) {
+		if (peer->dev_flags & IDE_DFLAG_PRESENT) {
 			if (setup_count < setup_counts[mate])
 				setup_count = setup_counts[mate];
 			if (active_count < active_counts[mate])
@@ -626,7 +626,7 @@ static void cmd640_init_dev(ide_drive_t 
 	 */
 	check_prefetch(drive, i);
 	printk(KERN_INFO DRV_NAME ": drive%d timings/prefetch(%s) preserved\n",
-				  i, drive->no_io_32bit ? "off" : "on");
+		i, (drive->dev_flags & IDE_DFLAG_NO_IO_32BIT) ? "off" : "on");
 #endif /* CONFIG_BLK_DEV_CMD640_ENHANCED */
 }
 
Index: b/drivers/ide/pci/it821x.c
===================================================================
--- a/drivers/ide/pci/it821x.c
+++ b/drivers/ide/pci/it821x.c
@@ -454,7 +454,7 @@ static void it821x_quirkproc(ide_drive_t
 		 *	IRQ mask as we may well be in PIO (eg rev 0x10)
 		 *	for now and we know unmasking is safe on this chipset.
 		 */
-		drive->unmask = 1;
+		drive->dev_flags |= IDE_DFLAG_UNMASK;
 	} else {
 	/*
 	 *	Perform fixups on smart mode. We need to "lose" some
Index: b/drivers/ide/pci/ns87415.c
===================================================================
--- a/drivers/ide/pci/ns87415.c
+++ b/drivers/ide/pci/ns87415.c
@@ -137,7 +137,7 @@ static void __devinit superio_init_iops(
 static unsigned int ns87415_count = 0, ns87415_control[MAX_HWIFS] = { 0 };
 
 /*
- * This routine either enables/disables (according to drive->present)
+ * This routine either enables/disables (according to IDE_DFLAG_PRESENT)
  * the IRQ associated with the port (HWIF(drive)),
  * and selects either PIO or DMA handshaking for the next I/O operation.
  */
@@ -153,7 +153,11 @@ static void ns87415_prepare_drive (ide_d
 
 	/* Adjust IRQ enable bit */
 	bit = 1 << (8 + hwif->channel);
-	new = drive->present ? (new & ~bit) : (new | bit);
+
+	if (drive->dev_flags & IDE_DFLAG_PRESENT)
+		new &= ~bit;
+	else
+		new |= bit;
 
 	/* Select PIO or DMA, DMA may only be selected for one drive/channel. */
 	bit   = 1 << (20 + drive->select.b.unit       + (hwif->channel << 1));
@@ -187,7 +191,8 @@ static void ns87415_prepare_drive (ide_d
 
 static void ns87415_selectproc (ide_drive_t *drive)
 {
-	ns87415_prepare_drive (drive, drive->using_dma);
+	ns87415_prepare_drive(drive,
+			      !!(drive->dev_flags & IDE_DFLAG_USING_DMA));
 }
 
 static int ns87415_dma_end(ide_drive_t *drive)
Index: b/drivers/ide/pci/pdc202xx_old.c
===================================================================
--- a/drivers/ide/pci/pdc202xx_old.c
+++ b/drivers/ide/pci/pdc202xx_old.c
@@ -168,7 +168,7 @@ static void pdc202xx_dma_start(ide_drive
 {
 	if (drive->current_speed > XFER_UDMA_2)
 		pdc_old_enable_66MHz_clock(drive->hwif);
-	if (drive->media != ide_disk || drive->addressing == 1) {
+	if (drive->media != ide_disk || (drive->dev_flags & IDE_DFLAG_LBA48)) {
 		struct request *rq	= HWGROUP(drive)->rq;
 		ide_hwif_t *hwif	= HWIF(drive);
 		unsigned long high_16	= hwif->extra_base - 16;
@@ -188,7 +188,7 @@ static void pdc202xx_dma_start(ide_drive
 
 static int pdc202xx_dma_end(ide_drive_t *drive)
 {
-	if (drive->media != ide_disk || drive->addressing == 1) {
+	if (drive->media != ide_disk || (drive->dev_flags & IDE_DFLAG_LBA48)) {
 		ide_hwif_t *hwif	= HWIF(drive);
 		unsigned long high_16	= hwif->extra_base - 16;
 		unsigned long atapi_reg	= high_16 + (hwif->channel ? 0x24 : 0x20);
Index: b/drivers/ide/pci/sc1200.c
===================================================================
--- a/drivers/ide/pci/sc1200.c
+++ b/drivers/ide/pci/sc1200.c
@@ -216,7 +216,8 @@ static void sc1200_set_pio_mode(ide_driv
 	if (mode != -1) {
 		printk("SC1200: %s: changing (U)DMA mode\n", drive->name);
 		ide_dma_off_quietly(drive);
-		if (ide_set_dma_mode(drive, mode) == 0 && drive->using_dma)
+		if (ide_set_dma_mode(drive, mode) == 0 &&
+		    (drive->dev_flags & IDE_DFLAG_USING_DMA))
 			hwif->dma_ops->dma_host_set(drive, 1);
 		return;
 	}
Index: b/drivers/ide/pci/trm290.c
===================================================================
--- a/drivers/ide/pci/trm290.c
+++ b/drivers/ide/pci/trm290.c
@@ -161,7 +161,7 @@ static void trm290_prepare_drive (ide_dr
 	}
 
 	/* enable IRQ if not probing */
-	if (drive->present) {
+	if (drive->dev_flags & IDE_DFLAG_PRESENT) {
 		reg = inw(hwif->config_data + 3);
 		reg &= 0x13;
 		reg &= ~(1 << hwif->channel);
@@ -173,7 +173,7 @@ static void trm290_prepare_drive (ide_dr
 
 static void trm290_selectproc (ide_drive_t *drive)
 {
-	trm290_prepare_drive(drive, drive->using_dma);
+	trm290_prepare_drive(drive, !!(drive->dev_flags & IDE_DFLAG_USING_DMA));
 }
 
 static void trm290_dma_exec_cmd(ide_drive_t *drive, u8 command)
Index: b/drivers/ide/ppc/pmac.c
===================================================================
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -966,11 +966,11 @@ static void pmac_ide_init_dev(ide_drive_
 	if (pmif->mediabay) {
 #ifdef CONFIG_PMAC_MEDIABAY
 		if (check_media_bay_by_base(pmif->regbase, MB_CD) == 0) {
-			drive->noprobe = 0;
+			drive->dev_flags &= ~IDE_DFLAG_NOPROBE;
 			return;
 		}
 #endif
-		drive->noprobe = 1;
+		drive->dev_flags |= IDE_DFLAG_NOPROBE;
 	}
 }
 
Index: b/drivers/scsi/ide-scsi.c
===================================================================
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -331,7 +331,8 @@ static ide_startstop_t idescsi_do_reques
 	if (blk_sense_request(rq) || blk_special_request(rq)) {
 		struct ide_atapi_pc *pc = (struct ide_atapi_pc *)rq->special;
 
-		if (drive->using_dma && !idescsi_map_sg(drive, pc))
+		if ((drive->dev_flags & IDE_DFLAG_USING_DMA) &&
+		    idescsi_map_sg(drive, pc) == 0)
 			pc->flags |= PC_FLAG_DMA_OK;
 
 		return idescsi_issue_pc(drive, pc);
@@ -415,7 +416,7 @@ static void ide_scsi_remove(ide_drive_t 
 
 	ide_scsi_put(scsi);
 
-	drive->scsi = 0;
+	drive->dev_flags &= ~IDE_DFLAG_SCSI;
 }
 
 static int ide_scsi_probe(ide_drive_t *);
@@ -767,7 +768,7 @@ static int ide_scsi_probe(ide_drive_t *d
 	    !(host = scsi_host_alloc(&idescsi_template,sizeof(idescsi_scsi_t))))
 		return -ENODEV;
 
-	drive->scsi = 1;
+	drive->dev_flags |= IDE_DFLAG_SCSI;
 
 	g = alloc_disk(1 << PARTN_BITS);
 	if (!g)
@@ -808,7 +809,7 @@ static int ide_scsi_probe(ide_drive_t *d
 
 	put_disk(g);
 out_host_put:
-	drive->scsi = 0;
+	drive->dev_flags &= ~IDE_DFLAG_SCSI;
 	scsi_host_put(host);
 	return err;
 }
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -457,6 +457,55 @@ enum {
 	IDE_AFLAG_MEDIUM_PRESENT	= (1 << 28)
 };
 
+/* device flags */
+enum {
+	/* restore settings after device reset */
+	IDE_DFLAG_KEEP_SETTINGS		= (1 << 0),
+	/* device is using DMA for read/write */
+	IDE_DFLAG_USING_DMA		= (1 << 1),
+	/* okay to unmask other IRQs */
+	IDE_DFLAG_UNMASK		= (1 << 2),
+	/* don't attempt flushes */
+	IDE_DFLAG_NOFLUSH		= (1 << 3),
+	/* DSC overlap */
+	IDE_DFLAG_DSC_OVERLAP		= (1 << 4),
+	/* give potential excess bandwidth */
+	IDE_DFLAG_NICE1			= (1 << 5),
+	/* device is physically present */
+	IDE_DFLAG_PRESENT		= (1 << 6),
+	/* device ejected hint */
+	IDE_DFLAG_DEAD			= (1 << 7),
+	/* id read from device (synthetic if not set) */
+	IDE_DFLAG_ID_READ		= (1 << 8),
+	IDE_DFLAG_NOPROBE		= (1 << 9),
+	/* need to do check_media_change() */
+	IDE_DFLAG_REMOVABLE		= (1 << 10),
+	/* needed for removable devices */
+	IDE_DFLAG_ATTACH		= (1 << 11),
+	IDE_DFLAG_FORCED_GEOM		= (1 << 12),
+	/* disallow setting unmask bit */
+	IDE_DFLAG_NO_UNMASK		= (1 << 13),
+	/* disallow enabling 32-bit I/O */
+	IDE_DFLAG_NO_IO_32BIT		= (1 << 14),
+	/* for removable only: door lock/unlock works */
+	IDE_DFLAG_DOORLOCKING		= (1 << 15),
+	/* disallow DMA */
+	IDE_DFLAG_NODMA			= (1 << 16),
+	/* powermanagment told us not to do anything, so sleep nicely */
+	IDE_DFLAG_BLOCKED		= (1 << 17),
+	/* ide-scsi emulation */
+	IDE_DFLAG_SCSI			= (1 << 18),
+	/* sleeping & sleep field valid */
+	IDE_DFLAG_SLEEPING		= (1 << 19),
+	IDE_DFLAG_POST_RESET		= (1 << 20),
+	IDE_DFLAG_UDMA33_WARNED		= (1 << 21),
+	IDE_DFLAG_LBA48			= (1 << 22),
+	/* status of write cache */
+	IDE_DFLAG_WCACHE		= (1 << 23),
+	/* used for ignoring ATA_DF */
+	IDE_DFLAG_NOWERR		= (1 << 24),
+};
+
 struct ide_drive_s {
 	char		name[4];	/* drive name, such as "hda" */
         char            driver_req[10];	/* requests specific driver */
@@ -473,6 +522,8 @@ struct ide_drive_s {
 #endif
 	struct hwif_s		*hwif;	/* actually (ide_hwif_t *) */
 
+	unsigned long dev_flags;
+
 	unsigned long sleep;		/* sleep until this time */
 	unsigned long service_start;	/* time we started last request */
 	unsigned long service_time;	/* service time of last request */
@@ -485,32 +536,6 @@ struct ide_drive_s {
 	u8	state;			/* retry state */
 	u8	waiting_for_dma;	/* dma currently in progress */
 
-	unsigned keep_settings	: 1;	/* restore settings after drive reset */
-	unsigned using_dma	: 1;	/* disk is using dma for read/write */
-	unsigned unmask		: 1;	/* okay to unmask other irqs */
-	unsigned noflush	: 1;	/* don't attempt flushes */
-	unsigned dsc_overlap	: 1;	/* DSC overlap */
-	unsigned nice1		: 1;	/* give potential excess bandwidth */
-	unsigned present	: 1;	/* drive is physically present */
-	unsigned dead		: 1;	/* device ejected hint */
-	unsigned id_read	: 1;	/* 1=id read from disk 0 = synthetic */
-	unsigned noprobe 	: 1;	/* from:  hdx=noprobe */
-	unsigned removable	: 1;	/* 1 if need to do check_media_change */
-	unsigned attach		: 1;	/* needed for removable devices */
-	unsigned forced_geom	: 1;	/* 1 if hdx=c,h,s was given at boot */
-	unsigned no_unmask	: 1;	/* disallow setting unmask bit */
-	unsigned no_io_32bit	: 1;	/* disallow enabling 32bit I/O */
-	unsigned doorlocking	: 1;	/* for removable only: door lock/unlock works */
-	unsigned nodma		: 1;	/* disallow DMA */
-	unsigned blocked        : 1;	/* 1=powermanagment told us not to do anything, so sleep nicely */
-	unsigned scsi		: 1;	/* 0=default, 1=ide-scsi emulation */
-	unsigned sleeping	: 1;	/* 1=sleeping & sleep field valid */
-	unsigned post_reset	: 1;
-	unsigned udma33_warned	: 1;
-	unsigned addressing	: 1;	/* 0=28-bit, 1=48-bit */
-	unsigned wcache		: 1;	/* status of write cache */
-	unsigned nowerr		: 1;	/* used for ignoring ATA_DF */
-
         u8	quirk_list;	/* considered quirky, set for a specific host */
         u8	init_speed;	/* transfer rate set at boot */
         u8	current_speed;	/* current transfer rate set */
@@ -815,6 +840,22 @@ static int set_##name(ide_drive_t *drive
 	return 0; \
 }
 
+#define ide_devset_get_flag(name, flag) \
+static int get_##name(ide_drive_t *drive) \
+{ \
+	return !!(drive->dev_flags & flag); \
+}
+
+#define ide_devset_set_flag(name, flag) \
+static int set_##name(ide_drive_t *drive, int arg) \
+{ \
+	if (arg) \
+		drive->dev_flags |= flag; \
+	else \
+		drive->dev_flags &= ~flag; \
+	return 0; \
+}
+
 #define __IDE_DEVSET(_name, _flags, _get, _set) \
 const struct ide_devset ide_devset_##_name = \
 	__DEVSET(_flags, _get, _set)
@@ -850,6 +891,11 @@ ide_devset_get(_name, _field); \
 ide_devset_set(_name, _field); \
 IDE_DEVSET(_name, DS_SYNC, get_##_name, set_##_name)
 
+#define ide_devset_rw_flag(_name, _field) \
+ide_devset_get_flag(_name, _field); \
+ide_devset_set_flag(_name, _field); \
+IDE_DEVSET(_name, DS_SYNC, get_##_name, set_##_name)
+
 struct ide_proc_devset {
 	const char		*name;
 	const struct ide_devset	*setting;
@@ -1554,6 +1600,6 @@ static inline ide_drive_t *ide_get_pair_
 {
 	ide_drive_t *peer = &drive->hwif->drives[(drive->dn ^ 1) & 1];
 
-	return peer->present ? peer : NULL;
+	return (peer->dev_flags & IDE_DFLAG_PRESENT) ? peer : NULL;
 }
 #endif /* _IDE_H */
