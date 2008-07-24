Return-Path: <linux-kernel-owner+w=401wt.eu-S1755291AbYGXT1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291AbYGXT1y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 15:27:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753585AbYGXT1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 15:27:17 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:13336 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280AbYGXT1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 15:27:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=FQNModHlTrhe2OzAqkHaHOfXIQhfdB03SXkgSr5ELs+j/jf7I+/4zZNqvjlfQ41AvH
         1yXx+L1Z9v3PRNVNgJqI7JKbCvVty9+8jAEIVty0t5q45aPhwDshUUPmH7QHK2Tu763N
         xGUZXB2kol+g6kPzNRwYkRMRqLZ9L12ylKOac=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 2/4] ide: use ATA_* defines instead of *_STAT and *_ERR ones
Date: Thu, 24 Jul 2008 21:22:43 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807242122.43332.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* ERR_STAT   -> ATA_ERR
* INDEX_STAT -> ATA_IDX
* ECC_STAT   -> ATA_CORR
* DRQ_STAT   -> ATA_DRQ
* SEEK_STAT  -> ATA_DSC
* WRERR_STAT -> ATA_DF
* READY_STAT -> ATA_DRDY
* BUSY_STAT  -> ATA_BUSY

* MARK_ERR   -> ATA_AMNF
* TRK0_ERR   -> ATA_TRK0NF
* ABRT_ERR   -> ATA_ABORTED
* MCR_ERR    -> ATA_MCR
* ID_ERR     -> ATA_IDNF
* MC_ERR     -> ATA_MC
* ECC_ERR    -> ATA_UNC
* ICRC_ERR   -> ATA_ICRC

* BBD_ERR    -> ATA_BBK

Also:

* ILI_ERR    -> ATAPI_ILI
* EOM_ERR    -> ATAPI_EOM
* LFS_ERR    -> ATAPI_LFS

* CD         -> ATAPI_COD
* IO         -> ATAPI_IO

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-atapi.c    |   32 +++++++++++++++---------------
 drivers/ide/ide-cd.c       |   16 +++++++--------
 drivers/ide/ide-dma.c      |    2 -
 drivers/ide/ide-floppy.c   |    2 -
 drivers/ide/ide-io.c       |   25 ++++++++++++-----------
 drivers/ide/ide-iops.c     |   22 ++++++++++----------
 drivers/ide/ide-lib.c      |   48 ++++++++++++++++++++++-----------------------
 drivers/ide/ide-probe.c    |   16 +++++++--------
 drivers/ide/ide-tape.c     |    6 ++---
 drivers/ide/ide-taskfile.c |   26 ++++++++++++------------
 drivers/ide/ide.c          |    8 +++----
 drivers/ide/pci/ns87415.c  |    6 ++---
 drivers/ide/pci/scc_pata.c |    4 +--
 drivers/scsi/ide-scsi.c    |    2 -
 include/linux/ide.h        |   15 +++++++-------
 15 files changed, 117 insertions(+), 113 deletions(-)

Index: b/drivers/ide/ide-atapi.c
===================================================================
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -41,7 +41,7 @@ ide_startstop_t ide_pc_intr(ide_drive_t 
 
 	if (pc->flags & PC_FLAG_DMA_IN_PROGRESS) {
 		if (hwif->dma_ops->dma_end(drive) ||
-		    (drive->media == ide_tape && !scsi && (stat & ERR_STAT))) {
+		    (drive->media == ide_tape && !scsi && (stat & ATA_ERR))) {
 			if (drive->media == ide_floppy && !scsi)
 				printk(KERN_ERR "%s: DMA %s error\n",
 					drive->name, rq_data_dir(pc->rq)
@@ -56,7 +56,7 @@ ide_startstop_t ide_pc_intr(ide_drive_t 
 	}
 
 	/* No more interrupts */
-	if ((stat & DRQ_STAT) == 0) {
+	if ((stat & ATA_DRQ) == 0) {
 		debug_log("Packet command completed, %d bytes transferred\n",
 			  pc->xferred);
 
@@ -65,10 +65,10 @@ ide_startstop_t ide_pc_intr(ide_drive_t 
 		local_irq_enable_in_hardirq();
 
 		if (drive->media == ide_tape && !scsi &&
-		    (stat & ERR_STAT) && rq->cmd[0] == REQUEST_SENSE)
-			stat &= ~ERR_STAT;
+		    (stat & ATA_ERR) && rq->cmd[0] == REQUEST_SENSE)
+			stat &= ~ATA_ERR;
 
-		if ((stat & ERR_STAT) || (pc->flags & PC_FLAG_DMA_ERROR)) {
+		if ((stat & ATA_ERR) || (pc->flags & PC_FLAG_DMA_ERROR)) {
 			/* Error detected */
 			debug_log("%s: I/O error\n", drive->name);
 
@@ -95,7 +95,7 @@ ide_startstop_t ide_pc_intr(ide_drive_t 
 cmd_finished:
 		pc->error = 0;
 		if ((pc->flags & PC_FLAG_WAIT_FOR_DSC) &&
-		    (stat & SEEK_STAT) == 0) {
+		    (stat & ATA_DSC) == 0) {
 			dsc_handle(drive);
 			return ide_stopped;
 		}
@@ -117,17 +117,18 @@ cmd_finished:
 	/* Get the number of bytes to transfer on this interrupt. */
 	ide_read_bcount_and_ireason(drive, &bcount, &ireason);
 
-	if (ireason & CD) {
+	if (ireason & ATAPI_COD) {
 		printk(KERN_ERR "%s: CoD != 0 in %s\n", drive->name, __func__);
 		return ide_do_reset(drive);
 	}
 
-	if (((ireason & IO) == IO) == !!(pc->flags & PC_FLAG_WRITING)) {
+	if (((ireason & ATAPI_IO) == ATAPI_IO) ==
+		!!(pc->flags & PC_FLAG_WRITING)) {
 		/* Hopefully, we will never get here */
 		printk(KERN_ERR "%s: We wanted to %s, but the device wants us "
 				"to %s!\n", drive->name,
-				(ireason & IO) ? "Write" : "Read",
-				(ireason & IO) ? "Read" : "Write");
+				(ireason & ATAPI_IO) ? "Write" : "Read",
+				(ireason & ATAPI_IO) ? "Read" : "Write");
 		return ide_do_reset(drive);
 	}
 
@@ -205,7 +206,8 @@ static u8 ide_wait_ireason(ide_drive_t *
 {
 	int retries = 100;
 
-	while (retries-- && ((ireason & CD) == 0 || (ireason & IO))) {
+	while (retries-- && ((ireason & ATAPI_COD) == 0 ||
+		(ireason & ATAPI_IO))) {
 		printk(KERN_ERR "%s: (IO,CoD != (0,1) while issuing "
 				"a packet command, retrying\n", drive->name);
 		udelay(100);
@@ -214,8 +216,8 @@ static u8 ide_wait_ireason(ide_drive_t *
 			printk(KERN_ERR "%s: (IO,CoD != (0,1) while issuing "
 					"a packet command, ignoring\n",
 					drive->name);
-			ireason |= CD;
-			ireason &= ~IO;
+			ireason |= ATAPI_COD;
+			ireason &= ~ATAPI_IO;
 		}
 	}
 
@@ -231,7 +233,7 @@ ide_startstop_t ide_transfer_pc(ide_driv
 	ide_startstop_t startstop;
 	u8 ireason;
 
-	if (ide_wait_stat(&startstop, drive, DRQ_STAT, BUSY_STAT, WAIT_READY)) {
+	if (ide_wait_stat(&startstop, drive, ATA_DRQ, ATA_BUSY, WAIT_READY)) {
 		printk(KERN_ERR "%s: Strange, packet command initiated yet "
 				"DRQ isn't asserted\n", drive->name);
 		return startstop;
@@ -241,7 +243,7 @@ ide_startstop_t ide_transfer_pc(ide_driv
 	if (drive->media == ide_tape && !drive->scsi)
 		ireason = ide_wait_ireason(drive, ireason);
 
-	if ((ireason & CD) == 0 || (ireason & IO)) {
+	if ((ireason & ATAPI_COD) == 0 || (ireason & ATAPI_IO)) {
 		printk(KERN_ERR "%s: (IO,CoD) != (0,1) while issuing "
 				"a packet command\n", drive->name);
 		return ide_do_reset(drive);
Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -434,7 +434,7 @@ static int cdrom_decode_status(ide_drive
 			ide_dump_status_no_sense(drive, "media error (blank)",
 						 stat);
 			do_end_request = 1;
-		} else if ((err & ~ABRT_ERR) != 0) {
+		} else if ((err & ~ATA_ABORTED) != 0) {
 			/* go to the default handler for other errors */
 			ide_error(drive, "cdrom_decode_status", stat);
 			return 1;
@@ -455,7 +455,7 @@ static int cdrom_decode_status(ide_drive
 		 * If we got a CHECK_CONDITION status, queue
 		 * a request sense command.
 		 */
-		if (stat & ERR_STAT)
+		if (stat & ATA_ERR)
 			cdrom_queue_request_sense(drive, NULL, NULL);
 	} else {
 		blk_dump_rq_flags(rq, "ide-cd: bad rq");
@@ -466,7 +466,7 @@ static int cdrom_decode_status(ide_drive
 	return 1;
 
 end_request:
-	if (stat & ERR_STAT) {
+	if (stat & ATA_ERR) {
 		unsigned long flags;
 
 		spin_lock_irqsave(&ide_lock, flags);
@@ -572,7 +572,7 @@ static ide_startstop_t cdrom_transfer_pa
 		 */
 
 		/* check for errors */
-		if (cdrom_decode_status(drive, DRQ_STAT, NULL))
+		if (cdrom_decode_status(drive, ATA_DRQ, NULL))
 			return ide_stopped;
 
 		/* ok, next interrupt will be DMA interrupt */
@@ -580,8 +580,8 @@ static ide_startstop_t cdrom_transfer_pa
 			drive->waiting_for_dma = 1;
 	} else {
 		/* otherwise, we must wait for DRQ to get set */
-		if (ide_wait_stat(&startstop, drive, DRQ_STAT,
-				BUSY_STAT, WAIT_READY))
+		if (ide_wait_stat(&startstop, drive, ATA_DRQ,
+				  ATA_BUSY, WAIT_READY))
 			return startstop;
 	}
 
@@ -936,7 +936,7 @@ static ide_startstop_t cdrom_newpc_intr(
 		thislen = len;
 
 	/* If DRQ is clear, the command has completed. */
-	if ((stat & DRQ_STAT) == 0) {
+	if ((stat & ATA_DRQ) == 0) {
 		if (blk_fs_request(rq)) {
 			/*
 			 * If we're not done reading/writing, complain.
@@ -1204,7 +1204,7 @@ static ide_startstop_t ide_cd_do_request
 			unsigned long elapsed = jiffies - info->start_seek;
 			int stat = hwif->tp_ops->read_status(hwif);
 
-			if ((stat & SEEK_STAT) != SEEK_STAT) {
+			if ((stat & ATA_DSC) != ATA_DSC) {
 				if (elapsed < IDECD_SEEK_TIMEOUT) {
 					ide_stall_queue(drive,
 							IDECD_SEEK_TIMER);
Index: b/drivers/ide/ide-dma.c
===================================================================
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -106,7 +106,7 @@ ide_startstop_t ide_dma_intr (ide_drive_
 	dma_stat = hwif->dma_ops->dma_end(drive);
 	stat = hwif->tp_ops->read_status(hwif);
 
-	if (OK_STAT(stat,DRIVE_READY,drive->bad_wstat|DRQ_STAT)) {
+	if (OK_STAT(stat, DRIVE_READY, drive->bad_wstat | ATA_DRQ)) {
 		if (!dma_stat) {
 			struct request *rq = HWGROUP(drive)->rq;
 
Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -944,7 +944,7 @@ static int idefloppy_get_format_progress
 		stat = hwif->tp_ops->read_status(hwif);
 		local_irq_restore(flags);
 
-		progress_indication = ((stat & SEEK_STAT) == 0) ? 0 : 0x10000;
+		progress_indication = ((stat & ATA_DSC) == 0) ? 0 : 0x10000;
 	}
 	if (put_user(progress_indication, arg))
 		return (-EFAULT);
Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -322,7 +322,7 @@ void ide_end_drive_cmd (ide_drive_t *dri
 		ide_task_t *task = (ide_task_t *)rq->special;
 
 		if (rq->errors == 0)
-			rq->errors = !OK_STAT(stat, READY_STAT, BAD_STAT);
+			rq->errors = !OK_STAT(stat, ATA_DRDY, BAD_STAT);
 
 		if (task) {
 			struct ide_taskfile *tf = &task->tf;
@@ -373,12 +373,12 @@ static ide_startstop_t ide_ata_error(ide
 {
 	ide_hwif_t *hwif = drive->hwif;
 
-	if (stat & BUSY_STAT || ((stat & WRERR_STAT) && !drive->nowerr)) {
+	if ((stat & ATA_BUSY) || ((stat & ATA_DF) && !drive->nowerr)) {
 		/* other bits are useless when BUSY */
 		rq->errors |= ERROR_RESET;
-	} else if (stat & ERR_STAT) {
+	} else if (stat & ATA_ERR) {
 		/* err has different meaning on cdrom and tape */
-		if (err == ABRT_ERR) {
+		if (err == ATA_ABORTED) {
 			if (drive->select.b.lba &&
 			    /* some newer drives don't support ATA_CMD_INIT_DEV_PARAMS */
 			    hwif->tp_ops->read_status(hwif) == ATA_CMD_INIT_DEV_PARAMS)
@@ -386,16 +386,16 @@ static ide_startstop_t ide_ata_error(ide
 		} else if ((err & BAD_CRC) == BAD_CRC) {
 			/* UDMA crc error, just retry the operation */
 			drive->crc_count++;
-		} else if (err & (BBD_ERR | ECC_ERR)) {
+		} else if (err & (ATA_BBK | ATA_UNC)) {
 			/* retries won't help these */
 			rq->errors = ERROR_MAX;
-		} else if (err & TRK0_ERR) {
+		} else if (err & ATA_TRK0NF) {
 			/* help it find track zero */
 			rq->errors |= ERROR_RECAL;
 		}
 	}
 
-	if ((stat & DRQ_STAT) && rq_data_dir(rq) == READ &&
+	if ((stat & ATA_DRQ) && rq_data_dir(rq) == READ &&
 	    (hwif->host_flags & IDE_HFLAG_ERROR_STOPS_FIFO) == 0) {
 		int nsect = drive->mult_count ? drive->mult_count : 1;
 
@@ -407,7 +407,7 @@ static ide_startstop_t ide_ata_error(ide
 		return ide_stopped;
 	}
 
-	if (hwif->tp_ops->read_status(hwif) & (BUSY_STAT | DRQ_STAT))
+	if (hwif->tp_ops->read_status(hwif) & (ATA_BUSY | ATA_DRQ))
 		rq->errors |= ERROR_RESET;
 
 	if ((rq->errors & ERROR_RESET) == ERROR_RESET) {
@@ -427,14 +427,14 @@ static ide_startstop_t ide_atapi_error(i
 {
 	ide_hwif_t *hwif = drive->hwif;
 
-	if (stat & BUSY_STAT || ((stat & WRERR_STAT) && !drive->nowerr)) {
+	if ((stat & ATA_BUSY) || ((stat & ATA_DF) && !drive->nowerr)) {
 		/* other bits are useless when BUSY */
 		rq->errors |= ERROR_RESET;
 	} else {
 		/* add decoding error stuff */
 	}
 
-	if (hwif->tp_ops->read_status(hwif) & (BUSY_STAT | DRQ_STAT))
+	if (hwif->tp_ops->read_status(hwif) & (ATA_BUSY | ATA_DRQ))
 		/* force an abort */
 		hwif->tp_ops->exec_command(hwif, ATA_CMD_IDLEIMMEDIATE);
 
@@ -804,7 +804,8 @@ static ide_startstop_t start_request (id
 		ide_check_pm_state(drive, rq);
 
 	SELECT_DRIVE(drive);
-	if (ide_wait_stat(&startstop, drive, drive->ready_stat, BUSY_STAT|DRQ_STAT, WAIT_READY)) {
+	if (ide_wait_stat(&startstop, drive, drive->ready_stat,
+			  ATA_BUSY | ATA_DRQ, WAIT_READY)) {
 		printk(KERN_ERR "%s: drive not ready for command\n", drive->name);
 		return startstop;
 	}
@@ -1324,7 +1325,7 @@ static void unexpected_intr (int irq, id
 		if (hwif->irq == irq) {
 			stat = hwif->tp_ops->read_status(hwif);
 
-			if (!OK_STAT(stat, READY_STAT, BAD_STAT)) {
+			if (!OK_STAT(stat, ATA_DRDY, BAD_STAT)) {
 				/* Try to not flood the console with msgs */
 				static unsigned long last_msgtime, count;
 				++count;
Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -473,7 +473,7 @@ int drive_is_ready (ide_drive_t *drive)
 		/* Note: this may clear a pending IRQ!! */
 		stat = hwif->tp_ops->read_status(hwif);
 
-	if (stat & BUSY_STAT)
+	if (stat & ATA_BUSY)
 		/* drive busy:  definitely not interrupting */
 		return 0;
 
@@ -505,10 +505,10 @@ static int __ide_wait_stat(ide_drive_t *
 	udelay(1);	/* spec allows drive 400ns to assert "BUSY" */
 	stat = tp_ops->read_status(hwif);
 
-	if (stat & BUSY_STAT) {
+	if (stat & ATA_BUSY) {
 		local_irq_set(flags);
 		timeout += jiffies;
-		while ((stat = tp_ops->read_status(hwif)) & BUSY_STAT) {
+		while ((stat = tp_ops->read_status(hwif)) & ATA_BUSY) {
 			if (time_after(jiffies, timeout)) {
 				/*
 				 * One last read after the timeout in case
@@ -516,7 +516,7 @@ static int __ide_wait_stat(ide_drive_t *
 				 * progress during the timeout..
 				 */
 				stat = tp_ops->read_status(hwif);
-				if (!(stat & BUSY_STAT))
+				if ((stat & ATA_BUSY) == 0)
 					break;
 
 				local_irq_restore(flags);
@@ -685,12 +685,12 @@ int ide_driveid_update(ide_drive_t *driv
 
 		msleep(50);	/* give drive a breather */
 		stat = tp_ops->read_altstatus(hwif);
-	} while (stat & BUSY_STAT);
+	} while (stat & ATA_BUSY);
 
-	msleep(50);	/* wait for IRQ and DRQ_STAT */
+	msleep(50);	/* wait for IRQ and ATA_DRQ */
 	stat = tp_ops->read_status(hwif);
 
-	if (!OK_STAT(stat, DRQ_STAT, BAD_R_STAT)) {
+	if (!OK_STAT(stat, ATA_DRQ, BAD_R_STAT)) {
 		SELECT_MASK(drive, 0);
 		printk("%s: CHECK for good STATUS\n", drive->name);
 		return 0;
@@ -776,7 +776,7 @@ int ide_config_drive_speed(ide_drive_t *
 		tp_ops->set_irq(hwif, 1);
 
 	error = __ide_wait_stat(drive, drive->ready_stat,
-				BUSY_STAT|DRQ_STAT|ERR_STAT,
+				ATA_BUSY | ATA_DRQ | ATA_ERR,
 				WAIT_CMD, &stat);
 
 	SELECT_MASK(drive, 0);
@@ -923,7 +923,7 @@ static ide_startstop_t atapi_reset_pollf
 	udelay (10);
 	stat = hwif->tp_ops->read_status(hwif);
 
-	if (OK_STAT(stat, 0, BUSY_STAT))
+	if (OK_STAT(stat, 0, ATA_BUSY))
 		printk("%s: ATAPI reset complete\n", drive->name);
 	else {
 		if (time_before(jiffies, hwgroup->poll_timeout)) {
@@ -969,7 +969,7 @@ static ide_startstop_t reset_pollfunc (i
 
 	tmp = hwif->tp_ops->read_status(hwif);
 
-	if (!OK_STAT(tmp, 0, BUSY_STAT)) {
+	if (!OK_STAT(tmp, 0, ATA_BUSY)) {
 		if (time_before(jiffies, hwgroup->poll_timeout)) {
 			ide_set_handler(drive, &reset_pollfunc, HZ/20, NULL);
 			/* continue polling */
@@ -1183,7 +1183,7 @@ int ide_wait_not_busy(ide_hwif_t *hwif, 
 		 */
 		mdelay(1);
 		stat = hwif->tp_ops->read_status(hwif);
-		if ((stat & BUSY_STAT) == 0)
+		if ((stat & ATA_BUSY) == 0)
 			return 0;
 		/*
 		 * Assume a value of 0xff means nothing is connected to
Index: b/drivers/ide/ide-lib.c
===================================================================
--- a/drivers/ide/ide-lib.c
+++ b/drivers/ide/ide-lib.c
@@ -340,16 +340,16 @@ static void ide_dump_sector(ide_drive_t 
 static void ide_dump_ata_error(ide_drive_t *drive, u8 err)
 {
 	printk("{ ");
-	if (err & ABRT_ERR)	printk("DriveStatusError ");
-	if (err & ICRC_ERR)
-		printk((err & ABRT_ERR) ? "BadCRC " : "BadSector ");
-	if (err & ECC_ERR)	printk("UncorrectableError ");
-	if (err & ID_ERR)	printk("SectorIdNotFound ");
-	if (err & TRK0_ERR)	printk("TrackZeroNotFound ");
-	if (err & MARK_ERR)	printk("AddrMarkNotFound ");
+	if (err & ATA_ABORTED)	printk("DriveStatusError ");
+	if (err & ATA_ICRC)
+		printk((err & ATA_ABORTED) ? "BadCRC " : "BadSector ");
+	if (err & ATA_UNC)	printk("UncorrectableError ");
+	if (err & ATA_IDNF)	printk("SectorIdNotFound ");
+	if (err & ATA_TRK0NF)	printk("TrackZeroNotFound ");
+	if (err & ATA_AMNF)	printk("AddrMarkNotFound ");
 	printk("}");
-	if ((err & (BBD_ERR | ABRT_ERR)) == BBD_ERR ||
-	    (err & (ECC_ERR|ID_ERR|MARK_ERR))) {
+	if ((err & (ATA_BBK | ATA_ABORTED)) == ATA_BBK ||
+	    (err & (ATA_UNC | ATA_IDNF | ATA_AMNF))) {
 		ide_dump_sector(drive);
 		if (HWGROUP(drive) && HWGROUP(drive)->rq)
 			printk(", sector=%llu",
@@ -361,12 +361,12 @@ static void ide_dump_ata_error(ide_drive
 static void ide_dump_atapi_error(ide_drive_t *drive, u8 err)
 {
 	printk("{ ");
-	if (err & ILI_ERR)	printk("IllegalLengthIndication ");
-	if (err & EOM_ERR)	printk("EndOfMedia ");
-	if (err & ABRT_ERR)	printk("AbortedCommand ");
-	if (err & MCR_ERR)	printk("MediaChangeRequested ");
-	if (err & LFS_ERR)	printk("LastFailedSense=0x%02x ",
-				       (err & LFS_ERR) >> 4);
+	if (err & ATAPI_ILI)	printk("IllegalLengthIndication ");
+	if (err & ATAPI_EOM)	printk("EndOfMedia ");
+	if (err & ATA_ABORTED)	printk("AbortedCommand ");
+	if (err & ATA_MCR)	printk("MediaChangeRequested ");
+	if (err & ATAPI_LFS)	printk("LastFailedSense=0x%02x ",
+				       (err & ATAPI_LFS) >> 4);
 	printk("}\n");
 }
 
@@ -388,19 +388,19 @@ u8 ide_dump_status(ide_drive_t *drive, c
 
 	local_irq_save(flags);
 	printk("%s: %s: status=0x%02x { ", drive->name, msg, stat);
-	if (stat & BUSY_STAT)
+	if (stat & ATA_BUSY)
 		printk("Busy ");
 	else {
-		if (stat & READY_STAT)	printk("DriveReady ");
-		if (stat & WRERR_STAT)	printk("DeviceFault ");
-		if (stat & SEEK_STAT)	printk("SeekComplete ");
-		if (stat & DRQ_STAT)	printk("DataRequest ");
-		if (stat & ECC_STAT)	printk("CorrectedError ");
-		if (stat & INDEX_STAT)	printk("Index ");
-		if (stat & ERR_STAT)	printk("Error ");
+		if (stat & ATA_DRDY)	printk("DriveReady ");
+		if (stat & ATA_DF)	printk("DeviceFault ");
+		if (stat & ATA_DSC)	printk("SeekComplete ");
+		if (stat & ATA_DRQ)	printk("DataRequest ");
+		if (stat & ATA_CORR)	printk("CorrectedError ");
+		if (stat & ATA_IDX)	printk("Index ");
+		if (stat & ATA_ERR)	printk("Error ");
 	}
 	printk("}\n");
-	if ((stat & (BUSY_STAT|ERR_STAT)) == ERR_STAT) {
+	if ((stat & (ATA_BUSY | ATA_ERR)) == ATA_ERR) {
 		err = ide_read_error(drive);
 		printk("%s: %s: error=0x%02x ", drive->name, msg, err);
 		if (drive->media == ide_disk)
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -264,7 +264,7 @@ static int actual_try_to_identify (ide_d
 	if (io_ports->ctl_addr) {
 		a = tp_ops->read_altstatus(hwif);
 		s = tp_ops->read_status(hwif);
-		if ((a ^ s) & ~INDEX_STAT)
+		if ((a ^ s) & ~ATA_IDX)
 			/* ancient Seagate drives, broken interfaces */
 			printk(KERN_INFO "%s: probing with STATUS(0x%02x) "
 					 "instead of ALTSTATUS(0x%02x)\n",
@@ -301,13 +301,13 @@ static int actual_try_to_identify (ide_d
 		msleep(50);
 		s = use_altstatus ? tp_ops->read_altstatus(hwif)
 				  : tp_ops->read_status(hwif);
-	} while (s & BUSY_STAT);
+	} while (s & ATA_BUSY);
 
-	/* wait for IRQ and DRQ_STAT */
+	/* wait for IRQ and ATA_DRQ */
 	msleep(50);
 	s = tp_ops->read_status(hwif);
 
-	if (OK_STAT(s, DRQ_STAT, BAD_R_STAT)) {
+	if (OK_STAT(s, ATA_DRQ, BAD_R_STAT)) {
 		unsigned long flags;
 
 		/* local CPU only; some systems need this */
@@ -391,7 +391,7 @@ static int ide_busy_sleep(ide_hwif_t *hw
 	do {
 		msleep(50);
 		stat = hwif->tp_ops->read_status(hwif);
-		if ((stat & BUSY_STAT) == 0)
+		if ((stat & ATA_BUSY) == 0)
 			return 0;
 	} while (time_before(jiffies, timeout));
 
@@ -460,7 +460,7 @@ static int do_probe (ide_drive_t *drive,
 		if (drive->select.b.unit != 0) {
 			/* exit with drive0 selected */
 			SELECT_DRIVE(&hwif->drives[0]);
-			/* allow BUSY_STAT to assert & clear */
+			/* allow ATA_BUSY to assert & clear */
 			msleep(50);
 		}
 		/* no i/f present: mmm.. this should be a 4 -ml */
@@ -469,7 +469,7 @@ static int do_probe (ide_drive_t *drive,
 
 	stat = tp_ops->read_status(hwif);
 
-	if (OK_STAT(stat, READY_STAT, BUSY_STAT) ||
+	if (OK_STAT(stat, ATA_DRDY, ATA_BUSY) ||
 	    drive->present || cmd == ATA_CMD_ID_ATAPI) {
 		/* send cmd and wait */
 		if ((rc = try_to_identify(drive, cmd))) {
@@ -479,7 +479,7 @@ static int do_probe (ide_drive_t *drive,
 
 		stat = tp_ops->read_status(hwif);
 
-		if (stat == (BUSY_STAT | READY_STAT))
+		if (stat == (ATA_BUSY | ATA_DRDY))
 			return 4;
 
 		if (rc == 1 && cmd == ATA_CMD_ID_ATAPI) {
Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -919,8 +919,8 @@ static ide_startstop_t idetape_media_acc
 
 	stat = hwif->tp_ops->read_status(hwif);
 
-	if (stat & SEEK_STAT) {
-		if (stat & ERR_STAT) {
+	if (stat & ATA_DSC) {
+		if (stat & ATA_ERR) {
 			/* Error detected */
 			if (pc->c[0] != TEST_UNIT_READY)
 				printk(KERN_ERR "ide-tape: %s: I/O error, ",
@@ -1020,7 +1020,7 @@ static ide_startstop_t idetape_do_reques
 	}
 
 	if (!test_and_clear_bit(IDE_AFLAG_IGNORE_DSC, &drive->atapi_flags) &&
-	    (stat & SEEK_STAT) == 0) {
+	    (stat & ATA_DSC) == 0) {
 		if (postponed_rq == NULL) {
 			tape->dsc_polling_start = jiffies;
 			tape->dsc_poll_freq = tape->best_dsc_rw_freq;
Index: b/drivers/ide/ide-taskfile.c
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -136,7 +136,7 @@ static ide_startstop_t set_multmode_intr
 	local_irq_enable_in_hardirq();
 	stat = hwif->tp_ops->read_status(hwif);
 
-	if (OK_STAT(stat, READY_STAT, BAD_STAT))
+	if (OK_STAT(stat, ATA_DRDY, BAD_STAT))
 		drive->mult_count = drive->mult_req;
 	else {
 		drive->mult_req = drive->mult_count = 0;
@@ -159,15 +159,15 @@ static ide_startstop_t set_geometry_intr
 
 	while (1) {
 		stat = hwif->tp_ops->read_status(hwif);
-		if ((stat & BUSY_STAT) == 0 || retries-- == 0)
+		if ((stat & ATA_BUSY) == 0 || retries-- == 0)
 			break;
 		udelay(10);
 	};
 
-	if (OK_STAT(stat, READY_STAT, BAD_STAT))
+	if (OK_STAT(stat, ATA_DRDY, BAD_STAT))
 		return ide_stopped;
 
-	if (stat & (ERR_STAT|DRQ_STAT))
+	if (stat & (ATA_ERR | ATA_DRQ))
 		return ide_error(drive, "set_geometry_intr", stat);
 
 	ide_set_handler(drive, &set_geometry_intr, WAIT_WORSTCASE, NULL);
@@ -185,7 +185,7 @@ static ide_startstop_t recal_intr(ide_dr
 	local_irq_enable_in_hardirq();
 	stat = hwif->tp_ops->read_status(hwif);
 
-	if (!OK_STAT(stat, READY_STAT, BAD_STAT))
+	if (!OK_STAT(stat, ATA_DRDY, BAD_STAT))
 		return ide_error(drive, "recal_intr", stat);
 	return ide_stopped;
 }
@@ -202,7 +202,7 @@ static ide_startstop_t task_no_data_intr
 	local_irq_enable_in_hardirq();
 	stat = hwif->tp_ops->read_status(hwif);
 
-	if (!OK_STAT(stat, READY_STAT, BAD_STAT))
+	if (!OK_STAT(stat, ATA_DRDY, BAD_STAT))
 		return ide_error(drive, "task_no_data_intr", stat);
 		/* calls ide_end_drive_cmd */
 
@@ -225,13 +225,13 @@ static u8 wait_drive_not_busy(ide_drive_
 	for (retries = 0; retries < 1000; retries++) {
 		stat = hwif->tp_ops->read_status(hwif);
 
-		if (stat & BUSY_STAT)
+		if (stat & ATA_BUSY)
 			udelay(10);
 		else
 			break;
 	}
 
-	if (stat & BUSY_STAT)
+	if (stat & ATA_BUSY)
 		printk(KERN_ERR "%s: drive still BUSY!\n", drive->name);
 
 	return stat;
@@ -390,7 +390,7 @@ void task_end_request(ide_drive_t *drive
 static ide_startstop_t task_in_unexpected(ide_drive_t *drive, struct request *rq, u8 stat)
 {
 	/* Command all done? */
-	if (OK_STAT(stat, READY_STAT, BUSY_STAT)) {
+	if (OK_STAT(stat, ATA_DRDY, ATA_BUSY)) {
 		task_end_request(drive, rq, stat);
 		return ide_stopped;
 	}
@@ -410,11 +410,11 @@ static ide_startstop_t task_in_intr(ide_
 	u8 stat = hwif->tp_ops->read_status(hwif);
 
 	/* Error? */
-	if (stat & ERR_STAT)
+	if (stat & ATA_ERR)
 		return task_error(drive, rq, __func__, stat);
 
 	/* Didn't want any data? Odd. */
-	if (!(stat & DRQ_STAT))
+	if ((stat & ATA_DRQ) == 0)
 		return task_in_unexpected(drive, rq, stat);
 
 	ide_pio_datablock(drive, rq, 0);
@@ -447,7 +447,7 @@ static ide_startstop_t task_out_intr (id
 		return task_error(drive, rq, __func__, stat);
 
 	/* Deal with unexpected ATA data phase. */
-	if (((stat & DRQ_STAT) == 0) ^ !hwif->nleft)
+	if (((stat & ATA_DRQ) == 0) ^ !hwif->nleft)
 		return task_error(drive, rq, __func__, stat);
 
 	if (!hwif->nleft) {
@@ -466,7 +466,7 @@ static ide_startstop_t pre_task_out_intr
 {
 	ide_startstop_t startstop;
 
-	if (ide_wait_stat(&startstop, drive, DRQ_STAT,
+	if (ide_wait_stat(&startstop, drive, ATA_DRQ,
 			  drive->bad_wstat, WAIT_DRQ)) {
 		printk(KERN_ERR "%s: no DRQ after issuing %sWRITE%s\n",
 				drive->name,
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -119,7 +119,7 @@ static void ide_port_init_devices_data(i
 		drive->media			= ide_disk;
 		drive->select.all		= (unit<<4)|0xa0;
 		drive->hwif			= hwif;
-		drive->ready_stat		= READY_STAT;
+		drive->ready_stat		= ATA_DRDY;
 		drive->bad_wstat		= BAD_W_STAT;
 		drive->special.b.recalibrate	= 1;
 		drive->special.b.set_geometry	= 1;
@@ -884,7 +884,7 @@ MODULE_PARM_DESC(noprobe, "skip probing 
 static unsigned int ide_nowerr;
 
 module_param_call(nowerr, ide_set_dev_param_mask, NULL, &ide_nowerr, 0);
-MODULE_PARM_DESC(nowerr, "ignore the WRERR_STAT bit for a device");
+MODULE_PARM_DESC(nowerr, "ignore the ATA_DF bit for a device");
 
 static unsigned int ide_cdroms;
 
@@ -949,7 +949,7 @@ static void ide_dev_apply_params(ide_dri
 		drive->noprobe = 1;
 	}
 	if (ide_nowerr & (1 << i)) {
-		printk(KERN_INFO "ide: ignoring the WRERR_STAT bit for %s\n",
+		printk(KERN_INFO "ide: ignoring the ATA_DF bit for %s\n",
 				 drive->name);
 		drive->bad_wstat = BAD_R_STAT;
 	}
@@ -970,7 +970,7 @@ static void ide_dev_apply_params(ide_dri
 				 drive->cyl, drive->head, drive->sect);
 		drive->present = 1;
 		drive->media = ide_disk;
-		drive->ready_stat = READY_STAT;
+		drive->ready_stat = ATA_DRDY;
 	}
 }
 
Index: b/drivers/ide/pci/ns87415.c
===================================================================
--- a/drivers/ide/pci/ns87415.c
+++ b/drivers/ide/pci/ns87415.c
@@ -274,9 +274,9 @@ static void __devinit init_hwif_ns87415 
 		do {
 			udelay(50);
 			stat = hwif->tp_ops->read_status(hwif);
-                	if (stat == 0xff)
-                        	break;
-        	} while ((stat & BUSY_STAT) && --timeout);
+			if (stat == 0xff)
+				break;
+		} while ((stat & ATA_BUSY) && --timeout);
 #endif
 	}
 
Index: b/drivers/ide/pci/scc_pata.c
===================================================================
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -400,7 +400,7 @@ static int scc_dma_end(ide_drive_t *driv
 	/* errata A308 workaround: Step5 (check data loss) */
 	/* We don't check non ide_disk because it is limited to UDMA4 */
 	if (!(in_be32((void __iomem *)hwif->io_ports.ctl_addr)
-	      & ERR_STAT) &&
+	      & ATA_ERR) &&
 	    drive->media == ide_disk && drive->current_speed > XFER_UDMA_4) {
 		reg = in_be32((void __iomem *)intsts_port);
 		if (!(reg & INTSTS_ACTEINT)) {
@@ -504,7 +504,7 @@ static int scc_dma_test_irq(ide_drive_t 
 
 	/* SCC errata A252,A308 workaround: Step4 */
 	if ((in_be32((void __iomem *)hwif->io_ports.ctl_addr)
-	     & ERR_STAT) &&
+	     & ATA_ERR) &&
 	    (int_stat & INTSTS_INTRQ))
 		return 1;
 
Index: b/drivers/scsi/ide-scsi.c
===================================================================
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -243,7 +243,7 @@ idescsi_atapi_error(ide_drive_t *drive, 
 {
 	ide_hwif_t *hwif = drive->hwif;
 
-	if (hwif->tp_ops->read_status(hwif) & (BUSY_STAT | DRQ_STAT))
+	if (hwif->tp_ops->read_status(hwif) & (ATA_BUSY | ATA_DRQ))
 		/* force an abort */
 		hwif->tp_ops->exec_command(hwif, ATA_CMD_IDLEIMMEDIATE);
 
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -87,12 +87,13 @@ struct ide_io_ports {
 };
 
 #define OK_STAT(stat,good,bad)	(((stat)&((good)|(bad)))==(good))
-#define BAD_R_STAT		(BUSY_STAT   | ERR_STAT)
-#define BAD_W_STAT		(BAD_R_STAT  | WRERR_STAT)
-#define BAD_STAT		(BAD_R_STAT  | DRQ_STAT)
-#define DRIVE_READY		(READY_STAT  | SEEK_STAT)
 
-#define BAD_CRC			(ABRT_ERR    | ICRC_ERR)
+#define BAD_R_STAT	(ATA_BUSY | ATA_ERR)
+#define BAD_W_STAT	(BAD_R_STAT | ATA_DF)
+#define BAD_STAT	(BAD_R_STAT | ATA_DRQ)
+#define DRIVE_READY	(ATA_DRDY | ATA_DSC)
+
+#define BAD_CRC		(ATA_ABORTED | ATA_ICRC)
 
 #define SATA_NR_PORTS		(3)	/* 16 possible ?? */
 
@@ -447,8 +448,8 @@ struct ide_drive_s {
 	u8	mult_req;	/* requested multiple sector setting */
 	u8	tune_req;	/* requested drive tuning setting */
 	u8	io_32bit;	/* 0=16-bit, 1=32-bit, 2/3=32bit+sync */
-	u8	bad_wstat;	/* used for ignoring WRERR_STAT */
-	u8	nowerr;		/* used for ignoring WRERR_STAT */
+	u8	bad_wstat;	/* used for ignoring ATA_DF */
+	u8	nowerr;		/* used for ignoring ATA_DF */
 	u8	sect0;		/* offset of first sector for DM6:DDO */
 	u8	head;		/* "real" number of heads */
 	u8	sect;		/* "real" sectors per track */
