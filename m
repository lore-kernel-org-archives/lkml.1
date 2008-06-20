Return-Path: <linux-kernel-owner+w=401wt.eu-S1762197AbYFTVeJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762197AbYFTVeJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 17:34:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760720AbYFTVcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 17:32:21 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:5898 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761426AbYFTVcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 17:32:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=h4uMxzJXBJ6b5/1dGKUjZxyQZg5+DHo55DnBDJ2eMcjAXQZLWF91tsukPht4O4f2Ej
         KR9OGnNiLuJXjtWHck53GRqjoTp0Yj2TtSnnBBHoo0rcPWe20m580h3judhn2JCKVJoL
         24YkxyIsaelyq94paeaWLAlrKsb1ErZ+mH1kI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2008 23:34:10 +0200
Message-Id: <20080620213410.13202.28865.sendpatchset@localhost.localdomain>
In-Reply-To: <20080620213323.13202.71450.sendpatchset@localhost.localdomain>
References: <20080620213323.13202.71450.sendpatchset@localhost.localdomain>
Subject: [PATCH 07/18] ide: add ->read_status method
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Remove ide_read_status() inline helper.

* Add ->read_status method for reading ATA Status register
  and use it instead of ->INB.

While at it:

* Don't use HWGROUP() macro.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/arm/icside.c   |    4 +++-
 drivers/ide/ide-atapi.c    |    2 +-
 drivers/ide/ide-cd.c       |   12 ++++++++----
 drivers/ide/ide-dma.c      |    5 +++--
 drivers/ide/ide-floppy.c   |    3 ++-
 drivers/ide/ide-io.c       |   19 ++++++++++---------
 drivers/ide/ide-iops.c     |   33 ++++++++++++++++++++++-----------
 drivers/ide/ide-probe.c    |   22 +++++++++++-----------
 drivers/ide/ide-tape.c     |    6 ++++--
 drivers/ide/ide-taskfile.c |   23 ++++++++++++++---------
 drivers/ide/pci/ns87415.c  |    8 +++++++-
 drivers/ide/pci/scc_pata.c |    6 ++++++
 drivers/ide/pci/sgiioc4.c  |   19 ++++++++++---------
 drivers/scsi/ide-scsi.c    |    2 +-
 include/linux/ide.h        |    8 +-------
 15 files changed, 103 insertions(+), 69 deletions(-)

Index: b/drivers/ide/arm/icside.c
===================================================================
--- a/drivers/ide/arm/icside.c
+++ b/drivers/ide/arm/icside.c
@@ -375,12 +375,14 @@ static int icside_dma_test_irq(ide_drive
 
 static void icside_dma_timeout(ide_drive_t *drive)
 {
+	ide_hwif_t *hwif = drive->hwif;
+
 	printk(KERN_ERR "%s: DMA timeout occurred: ", drive->name);
 
 	if (icside_dma_test_irq(drive))
 		return;
 
-	ide_dump_status(drive, "DMA timeout", ide_read_status(drive));
+	ide_dump_status(drive, "DMA timeout", hwif->read_status(hwif));
 
 	icside_dma_end(drive);
 }
Index: b/drivers/ide/ide-atapi.c
===================================================================
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -35,7 +35,7 @@ ide_startstop_t ide_pc_intr(ide_drive_t 
 	}
 
 	/* Clear the interrupt */
-	stat = ide_read_status(drive);
+	stat = hwif->read_status(hwif);
 
 	if (pc->flags & PC_FLAG_DMA_IN_PROGRESS) {
 		if (hwif->dma_ops->dma_end(drive) ||
Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -280,11 +280,12 @@ static void ide_dump_status_no_sense(ide
  */
 static int cdrom_decode_status(ide_drive_t *drive, int good_stat, int *stat_ret)
 {
-	struct request *rq = HWGROUP(drive)->rq;
+	ide_hwif_t *hwif = drive->hwif;
+	struct request *rq = hwif->hwgroup->rq;
 	int stat, err, sense_key;
 
 	/* check for errors */
-	stat = ide_read_status(drive);
+	stat = hwif->read_status(hwif);
 
 	if (stat_ret)
 		*stat_ret = stat;
@@ -606,6 +607,8 @@ static ide_startstop_t cdrom_transfer_pa
 static int ide_cd_check_ireason(ide_drive_t *drive, struct request *rq,
 				int len, int ireason, int rw)
 {
+	ide_hwif_t *hwif = drive->hwif;
+
 	/*
 	 * ireason == 0: the drive wants to receive data from us
 	 * ireason == 2: the drive is expecting to transfer data to us
@@ -624,7 +627,7 @@ static int ide_cd_check_ireason(ide_driv
 		 * Some drives (ASUS) seem to tell us that status info is
 		 * available.  Just get it and ignore.
 		 */
-		(void)ide_read_status(drive);
+		(void)hwif->read_status(hwif);
 		return 0;
 	} else {
 		/* drive wants a command packet, or invalid ireason... */
@@ -1188,8 +1191,9 @@ static ide_startstop_t ide_cd_do_request
 
 	if (blk_fs_request(rq)) {
 		if (info->cd_flags & IDE_CD_FLAG_SEEKING) {
+			ide_hwif_t *hwif = drive->hwif;
 			unsigned long elapsed = jiffies - info->start_seek;
-			int stat = ide_read_status(drive);
+			int stat = hwif->read_status(hwif);
 
 			if ((stat & SEEK_STAT) != SEEK_STAT) {
 				if (elapsed < IDECD_SEEK_TIMEOUT) {
Index: b/drivers/ide/ide-dma.c
===================================================================
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -100,10 +100,11 @@ static const struct drive_list_entry dri
  
 ide_startstop_t ide_dma_intr (ide_drive_t *drive)
 {
+	ide_hwif_t *hwif = drive->hwif;
 	u8 stat = 0, dma_stat = 0;
 
-	dma_stat = drive->hwif->dma_ops->dma_end(drive);
-	stat = ide_read_status(drive);
+	dma_stat = hwif->dma_ops->dma_end(drive);
+	stat = hwif->read_status(hwif);
 
 	if (OK_STAT(stat,DRIVE_READY,drive->bad_wstat|DRQ_STAT)) {
 		if (!dma_stat) {
Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -949,11 +949,12 @@ static int idefloppy_get_format_progress
 
 		/* Else assume format_unit has finished, and we're at 0x10000 */
 	} else {
+		ide_hwif_t *hwif = drive->hwif;
 		unsigned long flags;
 		u8 stat;
 
 		local_irq_save(flags);
-		stat = ide_read_status(drive);
+		stat = hwif->read_status(hwif);
 		local_irq_restore(flags);
 
 		progress_indication = ((stat & SEEK_STAT) == 0) ? 0 : 0x10000;
Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -381,8 +381,7 @@ static ide_startstop_t ide_ata_error(ide
 		if (err == ABRT_ERR) {
 			if (drive->select.b.lba &&
 			    /* some newer drives don't support WIN_SPECIFY */
-			    hwif->INB(hwif->io_ports.command_addr) ==
-				WIN_SPECIFY)
+			    hwif->read_status(hwif) == WIN_SPECIFY)
 				return ide_stopped;
 		} else if ((err & BAD_CRC) == BAD_CRC) {
 			/* UDMA crc error, just retry the operation */
@@ -408,7 +407,7 @@ static ide_startstop_t ide_ata_error(ide
 		return ide_stopped;
 	}
 
-	if (ide_read_status(drive) & (BUSY_STAT | DRQ_STAT))
+	if (hwif->read_status(hwif) & (BUSY_STAT | DRQ_STAT))
 		rq->errors |= ERROR_RESET;
 
 	if ((rq->errors & ERROR_RESET) == ERROR_RESET) {
@@ -435,7 +434,7 @@ static ide_startstop_t ide_atapi_error(i
 		/* add decoding error stuff */
 	}
 
-	if (ide_read_status(drive) & (BUSY_STAT | DRQ_STAT))
+	if (hwif->read_status(hwif) & (BUSY_STAT | DRQ_STAT))
 		/* force an abort */
 		hwif->exec_command(hwif, WIN_IDLEIMMEDIATE);
 
@@ -760,7 +759,8 @@ static ide_startstop_t execute_drive_cmd
 #ifdef DEBUG
  	printk("%s: DRIVE_CMD (null)\n", drive->name);
 #endif
-	ide_end_drive_cmd(drive, ide_read_status(drive), ide_read_error(drive));
+	ide_end_drive_cmd(drive, hwif->read_status(hwif),
+			  ide_read_error(drive));
 
  	return ide_stopped;
 }
@@ -1169,7 +1169,7 @@ static ide_startstop_t ide_dma_timeout_r
 		printk(KERN_WARNING "%s: DMA timeout error\n", drive->name);
 		(void)hwif->dma_ops->dma_end(drive);
 		ret = ide_error(drive, "dma timeout error",
-				ide_read_status(drive));
+				hwif->read_status(hwif));
 	} else {
 		printk(KERN_WARNING "%s: DMA timeout retry\n", drive->name);
 		hwif->dma_ops->dma_timeout(drive);
@@ -1294,7 +1294,7 @@ void ide_timer_expiry (unsigned long dat
 				} else
 					startstop =
 					ide_error(drive, "irq timeout",
-						  ide_read_status(drive));
+						  hwif->read_status(hwif));
 			}
 			drive->service_time = jiffies - drive->service_start;
 			spin_lock_irq(&ide_lock);
@@ -1350,7 +1350,8 @@ static void unexpected_intr (int irq, id
 	 */
 	do {
 		if (hwif->irq == irq) {
-			stat = hwif->INB(hwif->io_ports.status_addr);
+			stat = hwif->read_status(hwif);
+
 			if (!OK_STAT(stat, READY_STAT, BAD_STAT)) {
 				/* Try to not flood the console with msgs */
 				static unsigned long last_msgtime, count;
@@ -1440,7 +1441,7 @@ irqreturn_t ide_intr (int irq, void *dev
 			 * Whack the status register, just in case
 			 * we have a leftover pending IRQ.
 			 */
-			(void) hwif->INB(hwif->io_ports.status_addr);
+			(void)hwif->read_status(hwif);
 #endif /* CONFIG_BLK_DEV_IDEPCI */
 		}
 		spin_unlock_irqrestore(&ide_lock, flags);
Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -111,6 +111,14 @@ static void ide_exec_command(ide_hwif_t 
 		outb(cmd, hwif->io_ports.command_addr);
 }
 
+static u8 ide_read_status(ide_hwif_t *hwif)
+{
+	if (hwif->host_flags & IDE_HFLAG_MMIO)
+		return readb((void __iomem *)hwif->io_ports.status_addr);
+	else
+		return inb(hwif->io_ports.status_addr);
+}
+
 static u8 ide_read_sff_dma_status(ide_hwif_t *hwif)
 {
 	if (hwif->host_flags & IDE_HFLAG_MMIO)
@@ -340,6 +348,7 @@ static void ata_output_data(ide_drive_t 
 void default_hwif_transport(ide_hwif_t *hwif)
 {
 	hwif->exec_command	  = ide_exec_command;
+	hwif->read_status	  = ide_read_status;
 	hwif->read_sff_dma_status = ide_read_sff_dma_status;
 
 	hwif->tf_load	  = ide_tf_load;
@@ -505,7 +514,7 @@ int drive_is_ready (ide_drive_t *drive)
 		stat = ide_read_altstatus(drive);
 	else
 		/* Note: this may clear a pending IRQ!! */
-		stat = ide_read_status(drive);
+		stat = hwif->read_status(hwif);
 
 	if (stat & BUSY_STAT)
 		/* drive busy:  definitely not interrupting */
@@ -530,24 +539,25 @@ EXPORT_SYMBOL(drive_is_ready);
  */
 static int __ide_wait_stat(ide_drive_t *drive, u8 good, u8 bad, unsigned long timeout, u8 *rstat)
 {
+	ide_hwif_t *hwif = drive->hwif;
 	unsigned long flags;
 	int i;
 	u8 stat;
 
 	udelay(1);	/* spec allows drive 400ns to assert "BUSY" */
-	stat = ide_read_status(drive);
+	stat = hwif->read_status(hwif);
 
 	if (stat & BUSY_STAT) {
 		local_irq_set(flags);
 		timeout += jiffies;
-		while ((stat = ide_read_status(drive)) & BUSY_STAT) {
+		while ((stat = hwif->read_status(hwif)) & BUSY_STAT) {
 			if (time_after(jiffies, timeout)) {
 				/*
 				 * One last read after the timeout in case
 				 * heavy interrupt load made us not make any
 				 * progress during the timeout..
 				 */
-				stat = ide_read_status(drive);
+				stat = hwif->read_status(hwif);
 				if (!(stat & BUSY_STAT))
 					break;
 
@@ -567,7 +577,7 @@ static int __ide_wait_stat(ide_drive_t *
 	 */
 	for (i = 0; i < 10; i++) {
 		udelay(1);
-		stat = ide_read_status(drive);
+		stat = hwif->read_status(hwif);
 
 		if (OK_STAT(stat, good, bad)) {
 			*rstat = stat;
@@ -718,7 +728,7 @@ int ide_driveid_update(ide_drive_t *driv
 	} while (stat & BUSY_STAT);
 
 	msleep(50);	/* wait for IRQ and DRQ_STAT */
-	stat = ide_read_status(drive);
+	stat = hwif->read_status(hwif);
 
 	if (!OK_STAT(stat, DRQ_STAT, BAD_R_STAT)) {
 		SELECT_MASK(drive, 0);
@@ -733,7 +743,7 @@ int ide_driveid_update(ide_drive_t *driv
 		return 0;
 	}
 	hwif->input_data(drive, NULL, id, SECTOR_SIZE);
-	(void)ide_read_status(drive);	/* clear drive IRQ */
+	(void)hwif->read_status(hwif);	/* clear drive IRQ */
 	local_irq_enable();
 	local_irq_restore(flags);
 	ide_fix_driveid(id);
@@ -935,12 +945,13 @@ static ide_startstop_t do_reset1 (ide_dr
  */
 static ide_startstop_t atapi_reset_pollfunc (ide_drive_t *drive)
 {
-	ide_hwgroup_t *hwgroup	= HWGROUP(drive);
+	ide_hwif_t *hwif = drive->hwif;
+	ide_hwgroup_t *hwgroup = hwif->hwgroup;
 	u8 stat;
 
 	SELECT_DRIVE(drive);
 	udelay (10);
-	stat = ide_read_status(drive);
+	stat = hwif->read_status(hwif);
 
 	if (OK_STAT(stat, 0, BUSY_STAT))
 		printk("%s: ATAPI reset complete\n", drive->name);
@@ -984,7 +995,7 @@ static ide_startstop_t reset_pollfunc (i
 		}
 	}
 
-	tmp = ide_read_status(drive);
+	tmp = hwif->read_status(hwif);
 
 	if (!OK_STAT(tmp, 0, BUSY_STAT)) {
 		if (time_before(jiffies, hwgroup->poll_timeout)) {
@@ -1196,7 +1207,7 @@ int ide_wait_not_busy(ide_hwif_t *hwif, 
 		 * about locking issues (2.5 work ?).
 		 */
 		mdelay(1);
-		stat = hwif->INB(hwif->io_ports.status_addr);
+		stat = hwif->read_status(hwif);
 		if ((stat & BUSY_STAT) == 0)
 			return 0;
 		/*
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -276,7 +276,7 @@ static int actual_try_to_identify (ide_d
 
 	if (io_ports->ctl_addr) {
 		a = ide_read_altstatus(drive);
-		s = ide_read_status(drive);
+		s = hwif->read_status(hwif);
 		if ((a ^ s) & ~INDEX_STAT)
 			/* ancient Seagate drives, broken interfaces */
 			printk(KERN_INFO "%s: probing with STATUS(0x%02x) "
@@ -307,12 +307,12 @@ static int actual_try_to_identify (ide_d
 		/* give drive a breather */
 		msleep(50);
 		s = use_altstatus ? ide_read_altstatus(drive)
-				  : ide_read_status(drive);
+				  : hwif->read_status(hwif);
 	} while (s & BUSY_STAT);
 
 	/* wait for IRQ and DRQ_STAT */
 	msleep(50);
-	s = ide_read_status(drive);
+	s = hwif->read_status(hwif);
 
 	if (OK_STAT(s, DRQ_STAT, BAD_R_STAT)) {
 		unsigned long flags;
@@ -324,7 +324,7 @@ static int actual_try_to_identify (ide_d
 		/* drive responded with ID */
 		rc = 0;
 		/* clear drive IRQ */
-		(void)ide_read_status(drive);
+		(void)hwif->read_status(hwif);
 		local_irq_restore(flags);
 	} else {
 		/* drive refused ID */
@@ -371,7 +371,7 @@ static int try_to_identify (ide_drive_t 
 
 		ide_set_irq(drive, 0);
 		/* clear drive IRQ */
-		(void)ide_read_status(drive);
+		(void)hwif->read_status(hwif);
 		udelay(5);
 		irq = probe_irq_off(cookie);
 		if (!hwif->irq) {
@@ -396,7 +396,7 @@ static int ide_busy_sleep(ide_hwif_t *hw
 
 	do {
 		msleep(50);
-		stat = hwif->INB(hwif->io_ports.status_addr);
+		stat = hwif->read_status(hwif);
 		if ((stat & BUSY_STAT) == 0)
 			return 0;
 	} while (time_before(jiffies, timeout));
@@ -461,7 +461,7 @@ static int do_probe (ide_drive_t *drive,
 		return 3;
 	}
 
-	stat = ide_read_status(drive);
+	stat = hwif->read_status(hwif);
 
 	if (OK_STAT(stat, READY_STAT, BUSY_STAT) ||
 	    drive->present || cmd == WIN_PIDENTIFY) {
@@ -471,7 +471,7 @@ static int do_probe (ide_drive_t *drive,
 			rc = try_to_identify(drive,cmd);
 		}
 
-		stat = ide_read_status(drive);
+		stat = hwif->read_status(hwif);
 
 		if (stat == (BUSY_STAT | READY_STAT))
 			return 4;
@@ -488,7 +488,7 @@ static int do_probe (ide_drive_t *drive,
 		}
 
 		/* ensure drive IRQ is clear */
-		stat = ide_read_status(drive);
+		stat = hwif->read_status(hwif);
 
 		if (rc == 1)
 			printk(KERN_ERR "%s: no response (status = 0x%02x)\n",
@@ -502,7 +502,7 @@ static int do_probe (ide_drive_t *drive,
 		SELECT_DRIVE(&hwif->drives[0]);
 		msleep(50);
 		/* ensure drive irq is clear */
-		(void)ide_read_status(drive);
+		(void)hwif->read_status(hwif);
 	}
 	return rc;
 }
@@ -527,7 +527,7 @@ static void enable_nest (ide_drive_t *dr
 
 	msleep(50);
 
-	stat = ide_read_status(drive);
+	stat = hwif->read_status(hwif);
 
 	if (!OK_STAT(stat, 0, BAD_STAT))
 		printk(KERN_CONT "failed (status = 0x%02x)\n", stat);
Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -927,11 +927,12 @@ static void idetape_create_mode_sense_cm
 
 static ide_startstop_t idetape_media_access_finished(ide_drive_t *drive)
 {
+	ide_hwif_t *hwif = drive->hwif;
 	idetape_tape_t *tape = drive->driver_data;
 	struct ide_atapi_pc *pc = tape->pc;
 	u8 stat;
 
-	stat = ide_read_status(drive);
+	stat = hwif->read_status(hwif);
 
 	if (stat & SEEK_STAT) {
 		if (stat & ERR_STAT) {
@@ -980,6 +981,7 @@ static void ide_tape_create_rw_cmd(ideta
 static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 					  struct request *rq, sector_t block)
 {
+	ide_hwif_t *hwif = drive->hwif;
 	idetape_tape_t *tape = drive->driver_data;
 	struct ide_atapi_pc *pc = NULL;
 	struct request *postponed_rq = tape->postponed_rq;
@@ -1017,7 +1019,7 @@ static ide_startstop_t idetape_do_reques
 	 * If the tape is still busy, postpone our request and service
 	 * the other device meanwhile.
 	 */
-	stat = ide_read_status(drive);
+	stat = hwif->read_status(hwif);
 
 	if (!drive->dsc_overlap && !(rq->cmd[0] & REQ_IDETAPE_PC2))
 		set_bit(IDETAPE_FLAG_IGNORE_DSC, &tape->flags);
Index: b/drivers/ide/ide-taskfile.c
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -124,7 +124,8 @@ EXPORT_SYMBOL_GPL(do_rw_taskfile);
  */
 static ide_startstop_t set_multmode_intr(ide_drive_t *drive)
 {
-	u8 stat = ide_read_status(drive);
+	ide_hwif_t *hwif = drive->hwif;
+	u8 stat = hwif->read_status(hwif);
 
 	if (OK_STAT(stat, READY_STAT, BAD_STAT))
 		drive->mult_count = drive->mult_req;
@@ -141,10 +142,11 @@ static ide_startstop_t set_multmode_intr
  */
 static ide_startstop_t set_geometry_intr(ide_drive_t *drive)
 {
+	ide_hwif_t *hwif = drive->hwif;
 	int retries = 5;
 	u8 stat;
 
-	while (((stat = ide_read_status(drive)) & BUSY_STAT) && retries--)
+	while (((stat = hwif->read_status(hwif)) & BUSY_STAT) && retries--)
 		udelay(10);
 
 	if (OK_STAT(stat, READY_STAT, BAD_STAT))
@@ -162,7 +164,8 @@ static ide_startstop_t set_geometry_intr
  */
 static ide_startstop_t recal_intr(ide_drive_t *drive)
 {
-	u8 stat = ide_read_status(drive);
+	ide_hwif_t *hwif = drive->hwif;
+	u8 stat = hwif->read_status(hwif);
 
 	if (!OK_STAT(stat, READY_STAT, BAD_STAT))
 		return ide_error(drive, "recal_intr", stat);
@@ -174,11 +177,12 @@ static ide_startstop_t recal_intr(ide_dr
  */
 static ide_startstop_t task_no_data_intr(ide_drive_t *drive)
 {
-	ide_task_t *args	= HWGROUP(drive)->rq->special;
+	ide_hwif_t *hwif = drive->hwif;
+	ide_task_t *args = hwif->hwgroup->rq->special;
 	u8 stat;
 
 	local_irq_enable_in_hardirq();
-	stat = ide_read_status(drive);
+	stat = hwif->read_status(hwif);
 
 	if (!OK_STAT(stat, READY_STAT, BAD_STAT))
 		return ide_error(drive, "task_no_data_intr", stat);
@@ -192,6 +196,7 @@ static ide_startstop_t task_no_data_intr
 
 static u8 wait_drive_not_busy(ide_drive_t *drive)
 {
+	ide_hwif_t *hwif = drive->hwif;
 	int retries;
 	u8 stat;
 
@@ -200,7 +205,7 @@ static u8 wait_drive_not_busy(ide_drive_
 	 * take up to 6 ms on some ATAPI devices, so we will wait max 10 ms.
 	 */
 	for (retries = 0; retries < 1000; retries++) {
-		stat = ide_read_status(drive);
+		stat = hwif->read_status(hwif);
 
 		if (stat & BUSY_STAT)
 			udelay(10);
@@ -383,8 +388,8 @@ static ide_startstop_t task_in_unexpecte
 static ide_startstop_t task_in_intr(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	struct request *rq = HWGROUP(drive)->rq;
-	u8 stat = ide_read_status(drive);
+	struct request *rq = hwif->hwgroup->rq;
+	u8 stat = hwif->read_status(hwif);
 
 	/* Error? */
 	if (stat & ERR_STAT)
@@ -418,7 +423,7 @@ static ide_startstop_t task_out_intr (id
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct request *rq = HWGROUP(drive)->rq;
-	u8 stat = ide_read_status(drive);
+	u8 stat = hwif->read_status(hwif);
 
 	if (!OK_STAT(stat, DRIVE_READY, drive->bad_wstat))
 		return task_error(drive, rq, __func__, stat);
Index: b/drivers/ide/pci/ns87415.c
===================================================================
--- a/drivers/ide/pci/ns87415.c
+++ b/drivers/ide/pci/ns87415.c
@@ -63,6 +63,11 @@ static u8 superio_ide_inb (unsigned long
 	return inb(port);
 }
 
+static u8 superio_read_status(ide_hwif_t *hwif)
+{
+	return superio_ide_inb(hwif->io_ports.status_addr);
+}
+
 static u8 superio_read_sff_dma_status(ide_hwif_t *hwif)
 {
 	return superio_ide_inb(hwif->dma_base + ATA_DMA_STATUS);
@@ -127,6 +132,7 @@ static void __devinit superio_ide_init_i
 	tmp = superio_ide_inb(superio_ide_dma_status[port]);
 	outb(tmp | 0x66, superio_ide_dma_status[port]);
 
+	hwif->read_status	  = superio_read_status;
 	hwif->read_sff_dma_status = superio_read_sff_dma_status;
 
 	hwif->tf_read = superio_tf_read;
@@ -287,7 +293,7 @@ static void __devinit init_hwif_ns87415 
 		outb(8, hwif->io_ports.ctl_addr);
 		do {
 			udelay(50);
-			stat = hwif->INB(hwif->io_ports.status_addr);
+			stat = hwif->read_status(hwif);
                 	if (stat == 0xff)
                         	break;
         	} while ((stat & BUSY_STAT) && --timeout);
Index: b/drivers/ide/pci/scc_pata.c
===================================================================
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -134,6 +134,11 @@ static void scc_exec_command(ide_hwif_t 
 	eieio();
 }
 
+static u8 scc_read_status(ide_hwif_t *hwif)
+{
+	return (u8)in_be32((void *)hwif->io_ports.status_addr);
+}
+
 static u8 scc_read_sff_dma_status(ide_hwif_t *hwif)
 {
 	return (u8)in_be32((void *)(hwif->dma_base + 4));
@@ -789,6 +794,7 @@ static void __devinit init_mmio_iops_scc
 	ide_set_hwifdata(hwif, ports);
 
 	hwif->exec_command	  = scc_exec_command;
+	hwif->read_status	  = scc_read_status;
 	hwif->read_sff_dma_status = scc_read_sff_dma_status;
 
 	hwif->tf_load = scc_tf_load;
Index: b/drivers/ide/pci/sgiioc4.c
===================================================================
--- a/drivers/ide/pci/sgiioc4.c
+++ b/drivers/ide/pci/sgiioc4.c
@@ -127,7 +127,7 @@ sgiioc4_checkirq(ide_hwif_t * hwif)
 	return 0;
 }
 
-static u8 sgiioc4_INB(unsigned long);
+static u8 sgiioc4_read_status(ide_hwif_t *);
 
 static int
 sgiioc4_clearirq(ide_drive_t * drive)
@@ -141,18 +141,19 @@ sgiioc4_clearirq(ide_drive_t * drive)
 	intr_reg = readl((void __iomem *)other_ir);
 	if (intr_reg & 0x03) { /* Valid IOC4-IDE interrupt */
 		/*
-		 * Using sgiioc4_INB to read the Status register has a side
-		 * effect of clearing the interrupt.  The first read should
+		 * Using sgiioc4_read_status to read the Status register has a
+		 * side effect of clearing the interrupt.  The first read should
 		 * clear it if it is set.  The second read should return
 		 * a "clear" status if it got cleared.  If not, then spin
 		 * for a bit trying to clear it.
 		 */
-		u8 stat = sgiioc4_INB(io_ports->status_addr);
+		u8 stat = sgiioc4_read_status(hwif);
 		int count = 0;
-		stat = sgiioc4_INB(io_ports->status_addr);
+
+		stat = sgiioc4_read_status(hwif);
 		while ((stat & 0x80) && (count++ < 100)) {
 			udelay(1);
-			stat = sgiioc4_INB(io_ports->status_addr);
+			stat = sgiioc4_read_status(hwif);
 		}
 
 		if (intr_reg & 0x02) {
@@ -304,9 +305,9 @@ sgiioc4_dma_lost_irq(ide_drive_t * drive
 	ide_dma_lost_irq(drive);
 }
 
-static u8
-sgiioc4_INB(unsigned long port)
+static u8 sgiioc4_read_status(ide_hwif_t *hwif)
 {
+	unsigned long port = hwif->io_ports.status_addr;
 	u8 reg = (u8) readb((void __iomem *) port);
 
 	if ((port & 0xFFF) == 0x11C) {	/* Status register of IOC4 */
@@ -628,7 +629,7 @@ sgiioc4_ide_setup_pci_device(struct pci_
 	/* Initializing chipset IRQ Registers */
 	writel(0x03, (void __iomem *)(irqport + IOC4_INTR_SET * 4));
 
-	hwif->INB = &sgiioc4_INB;
+	hwif->read_status = sgiioc4_read_status;
 
 	idx[0] = hwif->index;
 
Index: b/drivers/scsi/ide-scsi.c
===================================================================
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -246,7 +246,7 @@ idescsi_atapi_error(ide_drive_t *drive, 
 {
 	ide_hwif_t *hwif = drive->hwif;
 
-	if (ide_read_status(drive) & (BUSY_STAT | DRQ_STAT))
+	if (hwif->read_status(hwif) & (BUSY_STAT | DRQ_STAT))
 		/* force an abort */
 		hwif->exec_command(hwif, WIN_IDLEIMMEDIATE);
 
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -469,6 +469,7 @@ typedef struct hwif_s {
 	const struct ide_dma_ops	*dma_ops;
 
 	void	(*exec_command)(struct hwif_s *, u8);
+	u8	(*read_status)(struct hwif_s *);
 	u8	(*read_sff_dma_status)(struct hwif_s *);
 
 	void (*tf_load)(ide_drive_t *, struct ide_task_s *);
@@ -1348,13 +1349,6 @@ static inline void ide_set_irq(ide_drive
 		       hwif->io_ports.ctl_addr);
 }
 
-static inline u8 ide_read_status(ide_drive_t *drive)
-{
-	ide_hwif_t *hwif = drive->hwif;
-
-	return hwif->INB(hwif->io_ports.status_addr);
-}
-
 static inline u8 ide_read_altstatus(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
