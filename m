Return-Path: <linux-kernel-owner+w=401wt.eu-S1765838AbYBBAiN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765838AbYBBAiN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 19:38:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763453AbYBBAhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 19:37:04 -0500
Received: from py-out-1112.google.com ([64.233.166.179]:6920 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762693AbYBBAgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 19:36:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=ZmaY1iZgdx2/2kJoewW+PyOCqnccjCjNGi78tWov4/UQc7yAk+OZEmfxES566OEldF7D/ZaNSgcTYprrV3CNl2ZDEBv2aD+lnkoFb7NwCcTOuViEQ9vuJf4MeXM8WN49px1Kbmf4EMV+C6HytpqNFyAie0+rtpNOCxx7MRML3Eo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 4/5] ide: add ide_read_[alt]status() inline helpers
Date: Sat, 2 Feb 2008 01:48:57 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802020148.57222.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/arm/icside.c   |    2 -
 drivers/ide/ide-cd.c       |    7 +++---
 drivers/ide/ide-dma.c      |    3 +-
 drivers/ide/ide-floppy.c   |    4 +--
 drivers/ide/ide-io.c       |   12 +++++------
 drivers/ide/ide-iops.c     |   39 +++++++++++++++++++++++--------------
 drivers/ide/ide-probe.c    |   47 +++++++++++++++++++++++----------------------
 drivers/ide/ide-tape.c     |    7 +++---
 drivers/ide/ide-taskfile.c |   30 ++++++++++++++--------------
 drivers/scsi/ide-scsi.c    |    4 +--
 include/linux/ide.h        |   14 +++++++++++++
 11 files changed, 100 insertions(+), 69 deletions(-)

Index: b/drivers/ide/arm/icside.c
===================================================================
--- a/drivers/ide/arm/icside.c
+++ b/drivers/ide/arm/icside.c
@@ -365,7 +365,7 @@ static void icside_dma_timeout(ide_drive
 	if (icside_dma_test_irq(drive))
 		return;
 
-	ide_dump_status(drive, "DMA timeout", HWIF(drive)->INB(IDE_STATUS_REG));
+	ide_dump_status(drive, "DMA timeout", ide_read_status(drive));
 
 	icside_dma_end(drive);
 }
Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -295,7 +295,8 @@ static int cdrom_decode_status(ide_drive
 	int stat, err, sense_key;
 	
 	/* Check for errors. */
-	stat = HWIF(drive)->INB(IDE_STATUS_REG);
+	stat = ide_read_status(drive);
+
 	if (stat_ret)
 		*stat_ret = stat;
 
@@ -692,7 +693,7 @@ int ide_cd_check_ireason(ide_drive_t *dr
 		/* Some drives (ASUS) seem to tell us that status
 		 * info is available. just get it and ignore.
 		 */
-		(void) HWIF(drive)->INB(IDE_STATUS_REG);
+		(void)ide_read_status(drive);
 		return 0;
 	} else {
 		/* Drive wants a command packet, or invalid ireason... */
@@ -1326,7 +1327,7 @@ ide_do_rw_cdrom (ide_drive_t *drive, str
 	if (blk_fs_request(rq)) {
 		if (info->cd_flags & IDE_CD_FLAG_SEEKING) {
 			unsigned long elapsed = jiffies - info->start_seek;
-			int stat = HWIF(drive)->INB(IDE_STATUS_REG);
+			int stat = ide_read_status(drive);
 
 			if ((stat & SEEK_STAT) != SEEK_STAT) {
 				if (elapsed < IDECD_SEEK_TIMEOUT) {
Index: b/drivers/ide/ide-dma.c
===================================================================
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -147,7 +147,8 @@ ide_startstop_t ide_dma_intr (ide_drive_
 	u8 stat = 0, dma_stat = 0;
 
 	dma_stat = HWIF(drive)->ide_dma_end(drive);
-	stat = HWIF(drive)->INB(IDE_STATUS_REG);	/* get drive status */
+	stat = ide_read_status(drive);
+
 	if (OK_STAT(stat,DRIVE_READY,drive->bad_wstat|DRQ_STAT)) {
 		if (!dma_stat) {
 			struct request *rq = HWGROUP(drive)->rq;
Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -503,7 +503,7 @@ static ide_startstop_t idefloppy_pc_intr
 	}
 
 	/* Clear the interrupt */
-	stat = drive->hwif->INB(IDE_STATUS_REG);
+	stat = ide_read_status(drive);
 
 	/* No more interrupts */
 	if ((stat & DRQ_STAT) == 0) {
@@ -1247,7 +1247,7 @@ static int idefloppy_get_format_progress
 		u8 stat;
 
 		local_irq_save(flags);
-		stat = drive->hwif->INB(IDE_STATUS_REG);
+		stat = ide_read_status(drive);
 		local_irq_restore(flags);
 
 		progress_indication = ((stat & SEEK_STAT) == 0) ? 0 : 0x10000;
Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -466,7 +466,7 @@ static ide_startstop_t ide_ata_error(ide
 		return ide_stopped;
 	}
 
-	if (hwif->INB(IDE_STATUS_REG) & (BUSY_STAT|DRQ_STAT))
+	if (ide_read_status(drive) & (BUSY_STAT | DRQ_STAT))
 		rq->errors |= ERROR_RESET;
 
 	if ((rq->errors & ERROR_RESET) == ERROR_RESET) {
@@ -493,7 +493,7 @@ static ide_startstop_t ide_atapi_error(i
 		/* add decoding error stuff */
 	}
 
-	if (hwif->INB(IDE_STATUS_REG) & (BUSY_STAT|DRQ_STAT))
+	if (ide_read_status(drive) & (BUSY_STAT | DRQ_STAT))
 		/* force an abort */
 		hwif->OUTB(WIN_IDLEIMMEDIATE, IDE_COMMAND_REG);
 
@@ -821,8 +821,7 @@ static ide_startstop_t execute_drive_cmd
 #ifdef DEBUG
  	printk("%s: DRIVE_CMD (null)\n", drive->name);
 #endif
- 	ide_end_drive_cmd(drive,
-			hwif->INB(IDE_STATUS_REG),
+	ide_end_drive_cmd(drive, ide_read_status(drive),
 			hwif->INB(IDE_ERROR_REG));
  	return ide_stopped;
 }
@@ -1231,7 +1230,7 @@ static ide_startstop_t ide_dma_timeout_r
 		printk(KERN_WARNING "%s: DMA timeout error\n", drive->name);
 		(void)HWIF(drive)->ide_dma_end(drive);
 		ret = ide_error(drive, "dma timeout error",
-						hwif->INB(IDE_STATUS_REG));
+				ide_read_status(drive));
 	} else {
 		printk(KERN_WARNING "%s: DMA timeout retry\n", drive->name);
 		hwif->dma_timeout(drive);
@@ -1355,7 +1354,8 @@ void ide_timer_expiry (unsigned long dat
 					startstop = ide_dma_timeout_retry(drive, wait);
 				} else
 					startstop =
-					ide_error(drive, "irq timeout", hwif->INB(IDE_STATUS_REG));
+					ide_error(drive, "irq timeout",
+						  ide_read_status(drive));
 			}
 			drive->service_time = jiffies - drive->service_start;
 			spin_lock_irq(&ide_lock);
Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -430,10 +430,10 @@ int drive_is_ready (ide_drive_t *drive)
 	 * about possible isa-pnp and pci-pnp issues yet.
 	 */
 	if (IDE_CONTROL_REG)
-		stat = hwif->INB(IDE_ALTSTATUS_REG);
+		stat = ide_read_altstatus(drive);
 	else
 		/* Note: this may clear a pending IRQ!! */
-		stat = hwif->INB(IDE_STATUS_REG);
+		stat = ide_read_status(drive);
 
 	if (stat & BUSY_STAT)
 		/* drive busy:  definitely not interrupting */
@@ -458,23 +458,24 @@ EXPORT_SYMBOL(drive_is_ready);
  */
 static int __ide_wait_stat(ide_drive_t *drive, u8 good, u8 bad, unsigned long timeout, u8 *rstat)
 {
-	ide_hwif_t *hwif = drive->hwif;
 	unsigned long flags;
 	int i;
 	u8 stat;
 
 	udelay(1);	/* spec allows drive 400ns to assert "BUSY" */
-	if ((stat = hwif->INB(IDE_STATUS_REG)) & BUSY_STAT) {
+	stat = ide_read_status(drive);
+
+	if (stat & BUSY_STAT) {
 		local_irq_set(flags);
 		timeout += jiffies;
-		while ((stat = hwif->INB(IDE_STATUS_REG)) & BUSY_STAT) {
+		while ((stat = ide_read_status(drive)) & BUSY_STAT) {
 			if (time_after(jiffies, timeout)) {
 				/*
 				 * One last read after the timeout in case
 				 * heavy interrupt load made us not make any
 				 * progress during the timeout..
 				 */
-				stat = hwif->INB(IDE_STATUS_REG);
+				stat = ide_read_status(drive);
 				if (!(stat & BUSY_STAT))
 					break;
 
@@ -494,7 +495,9 @@ static int __ide_wait_stat(ide_drive_t *
 	 */
 	for (i = 0; i < 10; i++) {
 		udelay(1);
-		if (OK_STAT((stat = hwif->INB(IDE_STATUS_REG)), good, bad)) {
+		stat = ide_read_status(drive);
+
+		if (OK_STAT(stat, good, bad)) {
 			*rstat = stat;
 			return 0;
 		}
@@ -617,6 +620,7 @@ int ide_driveid_update(ide_drive_t *driv
 	ide_hwif_t *hwif = drive->hwif;
 	struct hd_driveid *id;
 	unsigned long timeout, flags;
+	u8 stat;
 
 	/*
 	 * Re-read drive->id for possible DMA mode
@@ -633,10 +637,15 @@ int ide_driveid_update(ide_drive_t *driv
 			SELECT_MASK(drive, 0);
 			return 0;	/* drive timed-out */
 		}
+
 		msleep(50);	/* give drive a breather */
-	} while (hwif->INB(IDE_ALTSTATUS_REG) & BUSY_STAT);
+		stat = ide_read_altstatus(drive);
+	} while (stat & BUSY_STAT);
+
 	msleep(50);	/* wait for IRQ and DRQ_STAT */
-	if (!OK_STAT(hwif->INB(IDE_STATUS_REG),DRQ_STAT,BAD_R_STAT)) {
+	stat = ide_read_status(drive);
+
+	if (!OK_STAT(stat, DRQ_STAT, BAD_R_STAT)) {
 		SELECT_MASK(drive, 0);
 		printk("%s: CHECK for good STATUS\n", drive->name);
 		return 0;
@@ -649,7 +658,7 @@ int ide_driveid_update(ide_drive_t *driv
 		return 0;
 	}
 	ata_input_data(drive, id, SECTOR_WORDS);
-	(void) hwif->INB(IDE_STATUS_REG);	/* clear drive IRQ */
+	(void)ide_read_status(drive);	/* clear drive IRQ */
 	local_irq_enable();
 	local_irq_restore(flags);
 	ide_fix_driveid(id);
@@ -850,15 +859,15 @@ static ide_startstop_t do_reset1 (ide_dr
 static ide_startstop_t atapi_reset_pollfunc (ide_drive_t *drive)
 {
 	ide_hwgroup_t *hwgroup	= HWGROUP(drive);
-	ide_hwif_t *hwif	= HWIF(drive);
 	u8 stat;
 
 	SELECT_DRIVE(drive);
 	udelay (10);
+	stat = ide_read_status(drive);
 
-	if (OK_STAT(stat = hwif->INB(IDE_STATUS_REG), 0, BUSY_STAT)) {
+	if (OK_STAT(stat, 0, BUSY_STAT))
 		printk("%s: ATAPI reset complete\n", drive->name);
-	} else {
+	else {
 		if (time_before(jiffies, hwgroup->poll_timeout)) {
 			ide_set_handler(drive, &atapi_reset_pollfunc, HZ/20, NULL);
 			/* continue polling */
@@ -897,7 +906,9 @@ static ide_startstop_t reset_pollfunc (i
 		}
 	}
 
-	if (!OK_STAT(tmp = hwif->INB(IDE_STATUS_REG), 0, BUSY_STAT)) {
+	tmp = ide_read_status(drive);
+
+	if (!OK_STAT(tmp, 0, BUSY_STAT)) {
 		if (time_before(jiffies, hwgroup->poll_timeout)) {
 			ide_set_handler(drive, &reset_pollfunc, HZ/20, NULL);
 			/* continue polling */
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -264,8 +264,7 @@ err_misc:
 static int actual_try_to_identify (ide_drive_t *drive, u8 cmd)
 {
 	ide_hwif_t *hwif = HWIF(drive);
-	int rc;
-	unsigned long hd_status;
+	int use_altstatus = 0, rc;
 	unsigned long timeout;
 	u8 s = 0, a = 0;
 
@@ -273,19 +272,17 @@ static int actual_try_to_identify (ide_d
 	msleep(50);
 
 	if (IDE_CONTROL_REG) {
-		a = hwif->INB(IDE_ALTSTATUS_REG);
-		s = hwif->INB(IDE_STATUS_REG);
-		if ((a ^ s) & ~INDEX_STAT) {
-			printk(KERN_INFO "%s: probing with STATUS(0x%02x) instead of "
-				"ALTSTATUS(0x%02x)\n", drive->name, s, a);
+		a = ide_read_altstatus(drive);
+		s = ide_read_status(drive);
+		if ((a ^ s) & ~INDEX_STAT)
 			/* ancient Seagate drives, broken interfaces */
-			hd_status = IDE_STATUS_REG;
-		} else {
+			printk(KERN_INFO "%s: probing with STATUS(0x%02x) "
+					 "instead of ALTSTATUS(0x%02x)\n",
+					 drive->name, s, a);
+		else
 			/* use non-intrusive polling */
-			hd_status = IDE_ALTSTATUS_REG;
-		}
-	} else
-		hd_status = IDE_STATUS_REG;
+			use_altstatus = 1;
+	}
 
 	/* set features register for atapi
 	 * identify command to be sure of reply
@@ -306,11 +303,15 @@ static int actual_try_to_identify (ide_d
 		}
 		/* give drive a breather */
 		msleep(50);
-	} while ((hwif->INB(hd_status)) & BUSY_STAT);
+		s = use_altstatus ? ide_read_altstatus(drive)
+				  : ide_read_status(drive);
+	} while (s & BUSY_STAT);
 
 	/* wait for IRQ and DRQ_STAT */
 	msleep(50);
-	if (OK_STAT((hwif->INB(IDE_STATUS_REG)), DRQ_STAT, BAD_R_STAT)) {
+	s = ide_read_status(drive);
+
+	if (OK_STAT(s, DRQ_STAT, BAD_R_STAT)) {
 		unsigned long flags;
 
 		/* local CPU only; some systems need this */
@@ -320,7 +321,7 @@ static int actual_try_to_identify (ide_d
 		/* drive responded with ID */
 		rc = 0;
 		/* clear drive IRQ */
-		(void) hwif->INB(IDE_STATUS_REG);
+		(void)ide_read_status(drive);
 		local_irq_restore(flags);
 	} else {
 		/* drive refused ID */
@@ -367,7 +368,7 @@ static int try_to_identify (ide_drive_t 
 
 		ide_set_irq(drive, 0);
 		/* clear drive IRQ */
-		(void) hwif->INB(IDE_STATUS_REG);
+		(void)ide_read_status(drive);
 		udelay(5);
 		irq = probe_irq_off(cookie);
 		if (!hwif->irq) {
@@ -455,7 +456,9 @@ static int do_probe (ide_drive_t *drive,
 		return 3;
 	}
 
-	if (OK_STAT((hwif->INB(IDE_STATUS_REG)), READY_STAT, BUSY_STAT) ||
+	stat = ide_read_status(drive);
+
+	if (OK_STAT(stat, READY_STAT, BUSY_STAT) ||
 	    drive->present || cmd == WIN_PIDENTIFY) {
 		/* send cmd and wait */
 		if ((rc = try_to_identify(drive, cmd))) {
@@ -463,7 +466,7 @@ static int do_probe (ide_drive_t *drive,
 			rc = try_to_identify(drive,cmd);
 		}
 
-		stat = hwif->INB(IDE_STATUS_REG);
+		stat = ide_read_status(drive);
 
 		if (stat == (BUSY_STAT | READY_STAT))
 			return 4;
@@ -482,7 +485,7 @@ static int do_probe (ide_drive_t *drive,
 		}
 
 		/* ensure drive IRQ is clear */
-		stat = hwif->INB(IDE_STATUS_REG);
+		stat = ide_read_status(drive);
 
 		if (rc == 1)
 			printk(KERN_ERR "%s: no response (status = 0x%02x)\n",
@@ -496,7 +499,7 @@ static int do_probe (ide_drive_t *drive,
 		SELECT_DRIVE(&hwif->drives[0]);
 		msleep(50);
 		/* ensure drive irq is clear */
-		(void) hwif->INB(IDE_STATUS_REG);
+		(void)ide_read_status(drive);
 	}
 	return rc;
 }
@@ -521,7 +524,7 @@ static void enable_nest (ide_drive_t *dr
 
 	msleep(50);
 
-	stat = hwif->INB(IDE_STATUS_REG);
+	stat = ide_read_status(drive);
 
 	if (!OK_STAT(stat, 0, BAD_STAT))
 		printk(KERN_CONT "failed (status = 0x%02x)\n", stat);
Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -1178,7 +1178,7 @@ static ide_startstop_t idetape_pc_intr (
 #endif /* IDETAPE_DEBUG_LOG */	
 
 	/* Clear the interrupt */
-	stat = hwif->INB(IDE_STATUS_REG);
+	stat = ide_read_status(drive);
 
 	if (test_bit(PC_DMA_IN_PROGRESS, &pc->flags)) {
 		if (hwif->ide_dma_end(drive) || (stat & ERR_STAT)) {
@@ -1598,7 +1598,8 @@ static ide_startstop_t idetape_media_acc
 	idetape_pc_t *pc = tape->pc;
 	u8 stat;
 
-	stat = drive->hwif->INB(IDE_STATUS_REG);
+	stat = ide_read_status(drive);
+
 	if (stat & SEEK_STAT) {
 		if (stat & ERR_STAT) {
 			/* Error detected */
@@ -1758,7 +1759,7 @@ static ide_startstop_t idetape_do_reques
 	 * If the tape is still busy, postpone our request and service
 	 * the other device meanwhile.
 	 */
-	stat = drive->hwif->INB(IDE_STATUS_REG);
+	stat = ide_read_status(drive);
 
 	if (!drive->dsc_overlap && !(rq->cmd[0] & REQ_IDETAPE_PC2))
 		set_bit(IDETAPE_IGNORE_DSC, &tape->flags);
Index: b/drivers/ide/ide-taskfile.c
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -189,12 +189,11 @@ EXPORT_SYMBOL_GPL(do_rw_taskfile);
  */
 static ide_startstop_t set_multmode_intr(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = HWIF(drive);
-	u8 stat;
+	u8 stat = ide_read_status(drive);
 
-	if (OK_STAT(stat = hwif->INB(IDE_STATUS_REG),READY_STAT,BAD_STAT)) {
+	if (OK_STAT(stat, READY_STAT, BAD_STAT))
 		drive->mult_count = drive->mult_req;
-	} else {
+	else {
 		drive->mult_req = drive->mult_count = 0;
 		drive->special.b.recalibrate = 1;
 		(void) ide_dump_status(drive, "set_multmode", stat);
@@ -207,11 +206,10 @@ static ide_startstop_t set_multmode_intr
  */
 static ide_startstop_t set_geometry_intr(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = HWIF(drive);
 	int retries = 5;
 	u8 stat;
 
-	while (((stat = hwif->INB(IDE_STATUS_REG)) & BUSY_STAT) && retries--)
+	while (((stat = ide_read_status(drive)) & BUSY_STAT) && retries--)
 		udelay(10);
 
 	if (OK_STAT(stat, READY_STAT, BAD_STAT))
@@ -230,10 +228,9 @@ static ide_startstop_t set_geometry_intr
  */
 static ide_startstop_t recal_intr(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = HWIF(drive);
-	u8 stat;
+	u8 stat = ide_read_status(drive);
 
-	if (!OK_STAT(stat = hwif->INB(IDE_STATUS_REG), READY_STAT, BAD_STAT))
+	if (!OK_STAT(stat, READY_STAT, BAD_STAT))
 		return ide_error(drive, "recal_intr", stat);
 	return ide_stopped;
 }
@@ -248,10 +245,12 @@ static ide_startstop_t task_no_data_intr
 	u8 stat;
 
 	local_irq_enable_in_hardirq();
-	if (!OK_STAT(stat = hwif->INB(IDE_STATUS_REG),READY_STAT,BAD_STAT)) {
+	stat = ide_read_status(drive);
+
+	if (!OK_STAT(stat, READY_STAT, BAD_STAT))
 		return ide_error(drive, "task_no_data_intr", stat);
 		/* calls ide_end_drive_cmd */
-	}
+
 	if (args)
 		ide_end_drive_cmd(drive, stat, hwif->INB(IDE_ERROR_REG));
 
@@ -260,7 +259,6 @@ static ide_startstop_t task_no_data_intr
 
 u8 wait_drive_not_busy(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = HWIF(drive);
 	int retries;
 	u8 stat;
 
@@ -269,7 +267,9 @@ u8 wait_drive_not_busy(ide_drive_t *driv
 	 * This can take up to 10 usec, but we will wait max 1 ms.
 	 */
 	for (retries = 0; retries < 100; retries++) {
-		if ((stat = hwif->INB(IDE_STATUS_REG)) & BUSY_STAT)
+		stat = ide_read_status(drive);
+
+		if (stat & BUSY_STAT)
 			udelay(10);
 		else
 			break;
@@ -430,7 +430,7 @@ static ide_startstop_t task_in_intr(ide_
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct request *rq = HWGROUP(drive)->rq;
-	u8 stat = hwif->INB(IDE_STATUS_REG);
+	u8 stat = ide_read_status(drive);
 
 	/* new way for dealing with premature shared PCI interrupts */
 	if (!OK_STAT(stat, DRQ_STAT, BAD_R_STAT)) {
@@ -465,7 +465,7 @@ static ide_startstop_t task_out_intr (id
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct request *rq = HWGROUP(drive)->rq;
-	u8 stat = hwif->INB(IDE_STATUS_REG);
+	u8 stat = ide_read_status(drive);
 
 	if (!OK_STAT(stat, DRIVE_READY, drive->bad_wstat))
 		return task_error(drive, rq, __FUNCTION__, stat);
Index: b/drivers/scsi/ide-scsi.c
===================================================================
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -287,7 +287,7 @@ static int idescsi_end_request(ide_drive
 static ide_startstop_t
 idescsi_atapi_error(ide_drive_t *drive, struct request *rq, u8 stat, u8 err)
 {
-	if (HWIF(drive)->INB(IDE_STATUS_REG) & (BUSY_STAT|DRQ_STAT))
+	if (ide_read_status(drive) & (BUSY_STAT | DRQ_STAT))
 		/* force an abort */
 		HWIF(drive)->OUTB(WIN_IDLEIMMEDIATE,IDE_COMMAND_REG);
 
@@ -423,7 +423,7 @@ static ide_startstop_t idescsi_pc_intr (
 	}
 
 	/* Clear the interrupt */
-	stat = drive->hwif->INB(IDE_STATUS_REG);
+	stat = ide_read_status(drive);
 
 	if ((stat & DRQ_STAT) == 0) {
 		/* No more interrupts */
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1311,4 +1311,18 @@ static inline void ide_set_irq(ide_drive
 	drive->hwif->OUTB(drive->ctl | (on ? 0 : 2), IDE_CONTROL_REG);
 }
 
+static inline u8 ide_read_status(ide_drive_t *drive)
+{
+	ide_hwif_t *hwif = drive->hwif;
+
+	return hwif->INB(hwif->io_ports[IDE_STATUS_OFFSET]);
+}
+
+static inline u8 ide_read_altstatus(ide_drive_t *drive)
+{
+	ide_hwif_t *hwif = drive->hwif;
+
+	return hwif->INB(hwif->io_ports[IDE_CONTROL_OFFSET]);
+}
+
 #endif /* _IDE_H */
