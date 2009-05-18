Return-Path: <linux-kernel-owner+w=401wt.eu-S1755378AbZERUMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378AbZERUMb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 16:12:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755219AbZERUMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 16:12:13 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1939 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755050AbZERUMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 16:12:09 -0400
From: Joe Perches <joe@perches.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Krzysztof Halasa <khc@pm.waw.pl>, Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Elias Oltmanns <eo@nebensachen.de>
Subject: [PATCH 2/2] drivers/ide/ide-core: Convert pr_<foo> to dev_<foo>
Date: Mon, 18 May 2009 13:11:28 -0700
Message-Id: <b51d10ef8cb4f955b7663833ee559d1f0bc4064f.1242676752.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1242676752.git.joe@perches.com>
References: <cover.1242676752.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Standardize logging when drive->name or hwif->name
is used.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/ide/ide-atapi.c     |   63 ++++++++++++++++-----------------
 drivers/ide/ide-dma-sff.c   |    8 ++--
 drivers/ide/ide-dma.c       |   27 +++++++-------
 drivers/ide/ide-eh.c        |   17 ++++-----
 drivers/ide/ide-io.c        |   13 ++++---
 drivers/ide/ide-ioctls.c    |    4 +-
 drivers/ide/ide-iops.c      |    9 ++---
 drivers/ide/ide-lib.c       |   10 +++---
 drivers/ide/ide-pm.c        |   11 +++---
 drivers/ide/ide-probe.c     |   82 ++++++++++++++++++++++--------------------
 drivers/ide/ide-proc.c      |    7 ++--
 drivers/ide/ide-taskfile.c  |   25 +++++++------
 drivers/ide/ide-xfer-mode.c |    6 ++--
 drivers/ide/ide.c           |   17 +++++----
 drivers/ide/setup-pci.c     |    7 ++--
 15 files changed, 157 insertions(+), 149 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index 9a6ec77..591ccd9 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -50,21 +50,21 @@ int ide_check_atapi_device(ide_drive_t *drive, const char *s)
 #endif
 
 	if (protocol != 2)
-		pr_err("%s: %s: protocol (0x%02x) is not ATAPI\n",
-		       s, drive->name, protocol);
+		dev_err(&drive->gendev, "%s: protocol (0x%02x) is not ATAPI\n",
+			s, protocol);
 	else if ((drive->media == ide_floppy && device_type != 0) ||
 		 (drive->media == ide_tape && device_type != 1))
-		pr_err("%s: %s: invalid device type (0x%02x)\n",
-		       s, drive->name, device_type);
+		dev_err(&drive->gendev, "%s: invalid device type (0x%02x)\n",
+		       s, device_type);
 	else if (removable == 0)
-		pr_err("%s: %s: the removable flag is not set\n",
-		       s, drive->name);
+		dev_err(&drive->gendev, "%s: the removable flag is not set\n",
+			s);
 	else if (drive->media == ide_floppy && drq_type == 3)
-		pr_err("%s: %s: sorry, DRQ type (0x%02x) not supported\n",
-		       s, drive->name, drq_type);
+		dev_err(&drive->gendev, "%s: sorry, DRQ type (0x%02x) not supported\n",
+			s, drq_type);
 	else if (packet_size != 0)
-		pr_err("%s: %s: packet size (0x%02x) is not 12 bytes\n",
-		       s, drive->name, packet_size);
+		dev_err(&drive->gendev, "%s: packet size (0x%02x) is not 12 bytes\n",
+			s, packet_size);
 	else
 		return 1;
 	return 0;
@@ -231,7 +231,8 @@ int ide_cd_expiry(ide_drive_t *drive)
 		break;
 	default:
 		if (!(rq->cmd_flags & REQ_QUIET))
-			pr_info("cmd 0x%x timed out\n", rq->cmd[0]);
+			dev_info(&drive->gendev, "cmd 0x%x timed out\n",
+				 rq->cmd[0]);
 		wait = 0;
 		break;
 	}
@@ -298,9 +299,8 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 
 		if (rc || (drive->media == ide_tape && (stat & ATA_ERR))) {
 			if (drive->media == ide_floppy)
-				pr_err("%s: DMA %s error\n",
-				       drive->name,
-				       rq_data_dir(pc->rq) ? "write" : "read");
+				dev_err(&drive->gendev, "DMA %s error\n",
+					rq_data_dir(pc->rq) ? "write" : "read");
 			pc->flags |= PC_FLAG_DMA_ERROR;
 		} else {
 			pc->xferred = pc->req_xfer;
@@ -334,8 +334,8 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 				pc->rq->errors++;
 
 			if (rq->cmd[0] == REQUEST_SENSE) {
-				pr_err("%s: I/O error in request sense command\n",
-				       drive->name);
+				dev_err(&drive->gendev,
+					"I/O error in request sense command\n");
 				return ide_do_reset(drive);
 			}
 
@@ -383,8 +383,8 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 
 	if (pc->flags & PC_FLAG_DMA_IN_PROGRESS) {
 		pc->flags &= ~PC_FLAG_DMA_IN_PROGRESS;
-		pr_err("%s: The device wants to issue more interrupts in DMA mode\n",
-		       drive->name);
+		dev_err(&drive->gendev,
+			"The device wants to issue more interrupts in DMA mode\n");
 		ide_dma_off(drive);
 		return ide_do_reset(drive);
 	}
@@ -393,16 +393,16 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 	ide_read_bcount_and_ireason(drive, &bcount, &ireason);
 
 	if (ireason & ATAPI_COD) {
-		pr_err("%s: CoD != 0 in %s\n", drive->name, __func__);
+		dev_err(&drive->gendev, "CoD != 0 in %s\n", __func__);
 		return ide_do_reset(drive);
 	}
 
 	if (((ireason & ATAPI_IO) == ATAPI_IO) == write) {
 		/* Hopefully, we will never get here */
-		pr_err("%s: We wanted to %s, but the device wants us to %s!\n",
-		       drive->name,
-		       (ireason & ATAPI_IO) ? "Write" : "Read",
-		       (ireason & ATAPI_IO) ? "Read" : "Write");
+		dev_err(&drive->gendev,
+			"We wanted to %s, but the device wants us to %s!\n",
+			(ireason & ATAPI_IO) ? "Write" : "Read",
+			(ireason & ATAPI_IO) ? "Read" : "Write");
 		return ide_do_reset(drive);
 	}
 
@@ -462,13 +462,13 @@ static u8 ide_wait_ireason(ide_drive_t *drive, u8 ireason)
 
 	while (retries-- && ((ireason & ATAPI_COD) == 0 ||
 		(ireason & ATAPI_IO))) {
-		pr_err("%s: (IO,CoD != (0,1) while issuing a packet command, retrying\n",
-		       drive->name);
+		dev_err(&drive->gendev,
+			"(IO,CoD != (0,1) while issuing a packet command, retrying\n");
 		udelay(100);
 		ireason = ide_read_ireason(drive);
 		if (retries == 0) {
-			pr_err("%s: (IO,CoD != (0,1) while issuing a packet command, ignoring\n",
-			       drive->name);
+			dev_err(&drive->gendev,
+				"(IO,CoD != (0,1) while issuing a packet command, ignoring\n");
 			ireason |= ATAPI_COD;
 			ireason &= ~ATAPI_IO;
 		}
@@ -498,8 +498,8 @@ static ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
 	u8 ireason;
 
 	if (ide_wait_stat(&startstop, drive, ATA_DRQ, ATA_BUSY, WAIT_READY)) {
-		pr_err("%s: Strange, packet command initiated yet DRQ isn't asserted\n",
-		       drive->name);
+		dev_err(&drive->gendev,
+			"Strange, packet command initiated yet DRQ isn't asserted\n");
 		return startstop;
 	}
 
@@ -540,9 +540,8 @@ static ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
 			ireason = ide_wait_ireason(drive, ireason);
 
 		if ((ireason & ATAPI_COD) == 0 || (ireason & ATAPI_IO)) {
-			pr_err("%s: (IO,CoD) != (0,1) while issuing a packet command\n",
-			       drive->name);
-
+			dev_err(&drive->gendev,
+				"(IO,CoD) != (0,1) while issuing a packet command\n");
 			return ide_do_reset(drive);
 		}
 	}
diff --git a/drivers/ide/ide-dma-sff.c b/drivers/ide/ide-dma-sff.c
index b3d9fb6..9fcebf3 100644
--- a/drivers/ide/ide-dma-sff.c
+++ b/drivers/ide/ide-dma-sff.c
@@ -162,8 +162,8 @@ int ide_build_dmatable(ide_drive_t *drive, struct ide_cmd *cmd)
 	}
 
 use_pio_instead:
-	pr_err("%s: %s\n", drive->name,
-	       count ? "DMA table too small" : "empty DMA table?");
+	dev_err(&drive->gendev, "%s\n",
+		count ? "DMA table too small" : "empty DMA table?");
 
 	return 0; /* revert to PIO for this request */
 }
@@ -238,8 +238,8 @@ int ide_dma_sff_timer_expiry(ide_drive_t *drive)
 	ide_hwif_t *hwif = drive->hwif;
 	u8 dma_stat = hwif->dma_ops->dma_sff_read_status(hwif);
 
-	pr_warning("%s: %s: DMA status (0x%02x)\n",
-		   drive->name, __func__, dma_stat);
+	dev_warn(&drive->gendev, "%s: DMA status (0x%02x)\n",
+		 __func__, dma_stat);
 
 	if ((dma_stat & 0x18) == 0x18)	/* BUSY Stupid Early Timer !! */
 		return WAIT_CMD;
diff --git a/drivers/ide/ide-dma.c b/drivers/ide/ide-dma.c
index bd33ed4..f4c4a42 100644
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -106,8 +106,8 @@ ide_startstop_t ide_dma_intr(ide_drive_t *drive)
 						cmd->rq->nr_sectors << 9);
 			return ide_stopped;
 		}
-		pr_err("%s: %s: bad DMA status (0x%02x)\n",
-		       drive->name, __func__, dma_stat);
+		dev_err(&drive->gendev, "%s: bad DMA status (0x%02x)\n",
+			__func__, dma_stat);
 	}
 	return ide_error(drive, "dma_intr", stat);
 }
@@ -194,7 +194,7 @@ EXPORT_SYMBOL(ide_dma_off_quietly);
 
 void ide_dma_off(ide_drive_t *drive)
 {
-	pr_info("%s: DMA disabled\n", drive->name);
+	dev_info(&drive->gendev, "DMA disabled\n");
 	ide_dma_off_quietly(drive);
 }
 EXPORT_SYMBOL(ide_dma_off);
@@ -220,8 +220,9 @@ int __ide_dma_bad_drive(ide_drive_t *drive)
 
 	int blacklist = ide_in_drive_list(id, drive_blacklist);
 	if (blacklist) {
-		pr_warning("%s: Disabling (U)DMA for %s (blacklisted)\n",
-			   drive->name, (char *)&id[ATA_ID_PROD]);
+		dev_warn(&drive->gendev,
+			 "Disabling (U)DMA for %s (blacklisted)\n",
+			 (char *)&id[ATA_ID_PROD]);
 		return blacklist;
 	}
 	return 0;
@@ -342,8 +343,8 @@ u8 ide_find_dma_mode(ide_drive_t *drive, u8 req_mode)
 
 	mode = min(mode, req_mode);
 
-	pr_info("%s: %s mode selected\n", drive->name,
-		mode ? ide_xfer_verbose(mode) : "no DMA");
+	dev_info(&drive->gendev, "%s mode selected\n",
+		 mode ? ide_xfer_verbose(mode) : "no DMA");
 
 	return mode;
 }
@@ -409,7 +410,7 @@ int ide_id_dma_bug(ide_drive_t *drive)
 
 	return 0;
 err_out:
-	pr_err("%s: bad DMA info in identify block\n", drive->name);
+	dev_err(&drive->gendev, "bad DMA info in identify block\n");
 	return 1;
 }
 
@@ -456,7 +457,7 @@ void ide_check_dma_crc(ide_drive_t *drive)
 
 void ide_dma_lost_irq(ide_drive_t *drive)
 {
-	pr_err("%s: DMA interrupt recovery\n", drive->name);
+	dev_err(&drive->gendev, "DMA interrupt recovery\n");
 }
 EXPORT_SYMBOL_GPL(ide_dma_lost_irq);
 
@@ -478,17 +479,17 @@ ide_startstop_t ide_dma_timeout_retry(ide_drive_t *drive, int error)
 	 */
 
 	if (error < 0) {
-		pr_warning("%s: DMA timeout error\n", drive->name);
+		dev_warn(&drive->gendev, "DMA timeout error\n");
 		drive->waiting_for_dma = 0;
 		(void)dma_ops->dma_end(drive);
 		ide_dma_unmap_sg(drive, cmd);
 		ret = ide_error(drive, "dma timeout error",
 				hwif->tp_ops->read_status(hwif));
 	} else {
-		pr_warning("%s: DMA timeout retry\n", drive->name);
+		dev_warn(&drive->gendev, "DMA timeout retry\n");
 		if (dma_ops->dma_clear)
 			dma_ops->dma_clear(drive);
-		pr_err("%s: timeout waiting for DMA\n", drive->name);
+		dev_err(&drive->gendev, "timeout waiting for DMA\n");
 		if (dma_ops->dma_test_irq(drive) == 0) {
 			ide_dump_status(drive, "DMA timeout",
 					hwif->tp_ops->read_status(hwif));
@@ -557,7 +558,7 @@ int ide_allocate_dma_engine(ide_hwif_t *hwif)
 						&hwif->dmatable_dma,
 						GFP_ATOMIC);
 	if (hwif->dmatable_cpu == NULL) {
-		pr_err("%s: unable to allocate PRD table\n", hwif->name);
+		dev_err(hwif->dev, "unable to allocate PRD table\n");
 		return -ENOMEM;
 	}
 
diff --git a/drivers/ide/ide-eh.c b/drivers/ide/ide-eh.c
index a7f0142..af6d512 100644
--- a/drivers/ide/ide-eh.c
+++ b/drivers/ide/ide-eh.c
@@ -173,7 +173,7 @@ static ide_startstop_t atapi_reset_pollfunc(ide_drive_t *drive)
 	stat = tp_ops->read_status(hwif);
 
 	if (OK_STAT(stat, 0, ATA_BUSY))
-		pr_info("%s: ATAPI reset complete\n", drive->name);
+		dev_info(&drive->gendev, "ATAPI reset complete\n");
 	else {
 		if (time_before(jiffies, hwif->poll_timeout)) {
 			ide_set_handler(drive, &atapi_reset_pollfunc, HZ/20);
@@ -182,8 +182,8 @@ static ide_startstop_t atapi_reset_pollfunc(ide_drive_t *drive)
 		}
 		/* end of polling */
 		hwif->polling = 0;
-		pr_err("%s: ATAPI reset timed-out, status=0x%02x\n",
-		       drive->name, stat);
+		dev_err(&drive->gendev, "ATAPI reset timed-out, status=0x%02x\n",
+		        stat);
 		/* do it the old fashioned way */
 		return do_reset1(drive, 1);
 	}
@@ -202,7 +202,7 @@ static void ide_reset_report_error(ide_hwif_t *hwif, u8 err)
 
 	u8 err_master = err & 0x7f;
 
-	pr_err("%s: reset: master: ", hwif->name);
+	dev_err(hwif->dev, "reset: master: ");
 	if (err_master && err_master < 6)
 		pr_cont("%s", err_master_vals[err_master]);
 	else
@@ -228,8 +228,8 @@ static ide_startstop_t reset_pollfunc(ide_drive_t *drive)
 	if (port_ops && port_ops->reset_poll) {
 		err = port_ops->reset_poll(drive);
 		if (err) {
-			pr_err("%s: host reset_poll failure for %s.\n",
-			       hwif->name, drive->name);
+			dev_err(hwif->dev, "host reset_poll failure for %s.\n",
+				drive->name);
 			goto out;
 		}
 	}
@@ -242,15 +242,14 @@ static ide_startstop_t reset_pollfunc(ide_drive_t *drive)
 			/* continue polling */
 			return ide_started;
 		}
-		pr_err("%s: reset timed-out, status=0x%02x\n",
-		       hwif->name, tmp);
+		dev_err(hwif->dev, "reset timed-out, status=0x%02x\n", tmp);
 		drive->failures++;
 		err = -EIO;
 	} else  {
 		tmp = ide_read_error(drive);
 
 		if (tmp == 1) {
-			pr_info("%s: reset: success\n", hwif->name);
+			dev_info(hwif->dev, "reset: success\n");
 			drive->failures = 0;
 		} else {
 			ide_reset_report_error(hwif, tmp);
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 75812db..3a53704 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -95,7 +95,7 @@ void ide_complete_cmd(ide_drive_t *drive, struct ide_cmd *cmd, u8 stat, u8 err)
 	if ((cmd->tf_flags & IDE_TFLAG_CUSTOM_HANDLER) &&
 	    tf_cmd == ATA_CMD_IDLEIMMEDIATE) {
 		if (tf->lbal != 0xc4) {
-			pr_err("%s: head unload failed!\n", drive->name);
+			dev_err(&drive->gendev, "head unload failed!\n");
 			ide_tf_dump(drive->name, cmd);
 		} else
 			drive->dev_flags |= IDE_DFLAG_PARKED;
@@ -203,7 +203,7 @@ static ide_startstop_t ide_disk_special(ide_drive_t *drive)
 	} else if (s->all) {
 		int special = s->all;
 		s->all = 0;
-		pr_err("%s: bad special flag: 0x%02x\n", drive->name, special);
+		dev_err(&drive->gendev, "bad special flag: 0x%02x\n", special);
 		return ide_stopped;
 	}
 
@@ -354,7 +354,7 @@ static ide_startstop_t start_request (ide_drive_t *drive, struct request *rq)
 	drive->hwif->tp_ops->dev_select(drive);
 	if (ide_wait_stat(&startstop, drive, drive->ready_stat,
 			  ATA_BUSY | ATA_DRQ, WAIT_READY)) {
-		pr_err("%s: drive not ready for command\n", drive->name);
+		dev_err(&drive->gendev, "drive not ready for command\n");
 		return startstop;
 	}
 	if (!drive->special.all) {
@@ -683,7 +683,7 @@ void ide_timer_expiry (unsigned long data)
 				hwif->dma_ops->dma_lost_irq(drive);
 			if (hwif->ack_intr)
 				hwif->ack_intr(hwif);
-			pr_warning("%s: lost interrupt\n", drive->name);
+			dev_warn(&drive->gendev, "lost interrupt\n");
 			startstop = handler(drive);
 		} else {
 			if (drive->waiting_for_dma)
@@ -747,8 +747,9 @@ static void unexpected_intr(int irq, ide_hwif_t *hwif)
 
 		if (time_after(jiffies, last_msgtime + HZ)) {
 			last_msgtime = jiffies;
-			pr_err("%s: unexpected interrupt, status=0x%02x, count=%ld\n",
-			       hwif->name, stat, count);
+			dev_err(hwif->dev,
+				"unexpected interrupt, status=0x%02x, count=%ld\n",
+				stat, count);
 		}
 	}
 }
diff --git a/drivers/ide/ide-ioctls.c b/drivers/ide/ide-ioctls.c
index aea6cc3..5cd2c17 100644
--- a/drivers/ide/ide-ioctls.c
+++ b/drivers/ide/ide-ioctls.c
@@ -167,8 +167,8 @@ static int ide_cmd_ioctl(ide_drive_t *drive, unsigned long arg)
 	     id[ATA_ID_SWDMA_MODES])) {
 		xfer_rate = args[1];
 		if (tf->nsect > XFER_UDMA_2 && !eighty_ninty_three(drive)) {
-			pr_warning("%s: UDMA speeds >UDMA33 cannot be set\n",
-				   drive->name);
+			dev_warn(&drive->gendev,
+				 "UDMA speeds >UDMA33 cannot be set\n");
 			goto abort;
 		}
 	}
diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
index 8fe778c..6dbb96e 100644
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -259,10 +259,9 @@ no_80w:
 	if (drive->dev_flags & IDE_DFLAG_UDMA33_WARNED)
 		return 0;
 
-	pr_warning("%s: %s side 80-wire cable detection failed, "
-		   "limiting max speed to UDMA33\n",
-		   drive->name,
-		   hwif->cbl == ATA_CBL_PATA80 ? "drive" : "host");
+	dev_warn(&drive->gendev, "%s side 80-wire cable detection failed, "
+		 "limiting max speed to UDMA33\n",
+		 hwif->cbl == ATA_CBL_PATA80 ? "drive" : "host");
 
 	drive->dev_flags |= IDE_DFLAG_UDMA33_WARNED;
 
@@ -300,7 +299,7 @@ int ide_driveid_update(ide_drive_t *drive)
 out_err:
 	SELECT_MASK(drive, 0);
 	if (rc == 2)
-		pr_err("%s: %s: bad status\n", drive->name, __func__);
+		dev_err(&drive->gendev, "%s: bad status\n", __func__);
 	kfree(id);
 	return 0;
 }
diff --git a/drivers/ide/ide-lib.c b/drivers/ide/ide-lib.c
index b7b7474..2f3c111 100644
--- a/drivers/ide/ide-lib.c
+++ b/drivers/ide/ide-lib.c
@@ -42,7 +42,7 @@ static void ide_dump_opcode(ide_drive_t *drive)
 	if (rq->cmd_type == REQ_TYPE_ATA_TASKFILE)
 		cmd = rq->special;
 
-	pr_err("ide: failed opcode was: ");
+	dev_err(&drive->gendev, "ide: failed opcode was: ");
 	if (cmd == NULL)
 		pr_cont("unknown\n");
 	else
@@ -91,7 +91,7 @@ static void ide_dump_sector(ide_drive_t *drive)
 
 static void ide_dump_ata_error(ide_drive_t *drive, u8 err)
 {
-	pr_err("{ ");
+	dev_err(&drive->gendev, "{ ");
 	if (err & ATA_ABORTED)
 		pr_cont("DriveStatusError ");
 	if (err & ATA_ICRC)
@@ -121,7 +121,7 @@ static void ide_dump_ata_error(ide_drive_t *drive, u8 err)
 
 static void ide_dump_atapi_error(ide_drive_t *drive, u8 err)
 {
-	pr_err("{ ");
+	dev_err(&drive->gendev, "{ ");
 	if (err & ATAPI_ILI)
 		pr_cont("IllegalLengthIndication ");
 	if (err & ATAPI_EOM)
@@ -151,7 +151,7 @@ u8 ide_dump_status(ide_drive_t *drive, const char *msg, u8 stat)
 {
 	u8 err = 0;
 
-	pr_err("%s: %s: status=0x%02x { ", drive->name, msg, stat);
+	dev_err(&drive->gendev, "%s: status=0x%02x { ", msg, stat);
 	if (stat & ATA_BUSY)
 		pr_cont("Busy ");
 	else {
@@ -173,7 +173,7 @@ u8 ide_dump_status(ide_drive_t *drive, const char *msg, u8 stat)
 	pr_cont("}\n");
 	if ((stat & (ATA_BUSY | ATA_ERR)) == ATA_ERR) {
 		err = ide_read_error(drive);
-		pr_err("%s: %s: error=0x%02x ", drive->name, msg, err);
+		dev_err(&drive->gendev, "%s: error=0x%02x ", msg, err);
 		if (drive->media == ide_disk)
 			ide_dump_ata_error(drive, err);
 		else
diff --git a/drivers/ide/ide-pm.c b/drivers/ide/ide-pm.c
index 7402bb5..e165f9b 100644
--- a/drivers/ide/ide-pm.c
+++ b/drivers/ide/ide-pm.c
@@ -80,8 +80,8 @@ void ide_complete_power_step(ide_drive_t *drive, struct request *rq)
 	struct request_pm_state *pm = rq->data;
 
 #ifdef DEBUG_PM
-	pr_info("%s: complete_power_step(step: %d)\n",
-		drive->name, pm->pm_step);
+	dev_info(&drive->gendev, "complete_power_step(step: %d)\n",
+		 pm->pm_step);
 #endif
 	if (drive->media != ide_disk)
 		return;
@@ -229,16 +229,17 @@ void ide_check_pm_state(ide_drive_t *drive, struct request *rq)
 		unsigned long flags;
 		int rc;
 #ifdef DEBUG_PM
-		printk("%s: Wakeup request inited, waiting for !BSY...\n", drive->name);
+		dev_info(&drive->gendev,
+			 "Wakeup request inited, waiting for !BSY...\n");
 #endif
 		rc = ide_wait_not_busy(hwif, 35000);
 		if (rc)
-			pr_warning("%s: bus not ready on wakeup\n", drive->name);
+			dev_warn(&drive->gendev, "bus not ready on wakeup\n");
 		tp_ops->dev_select(drive);
 		tp_ops->write_devctl(hwif, ATA_DEVCTL_OBS);
 		rc = ide_wait_not_busy(hwif, 100000);
 		if (rc)
-			pr_warning("%s: drive not ready on wakeup\n", drive->name);
+			dev_warn(&drive->gendev, "drive not ready on wakeup\n");
 
 		spin_lock_irqsave(q->queue_lock, flags);
 		blk_start_queue(q);
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 18c58c9..521850a 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -116,8 +116,8 @@ static void ide_classify_ata_dev(ide_drive_t *drive)
 	if (!ata_id_has_unload(drive->id))
 		drive->dev_flags |= IDE_DFLAG_NO_UNLOAD;
 
-	pr_info("%s: %s, %s DISK drive\n", drive->name, m,
-		is_cfa ? "CFA" : "ATA");
+	dev_info(&drive->gendev, "%s, %s DISK drive\n",
+		 m, is_cfa ? "CFA" : "ATA");
 }
 
 static void ide_classify_atapi_dev(ide_drive_t *drive)
@@ -126,7 +126,7 @@ static void ide_classify_atapi_dev(ide_drive_t *drive)
 	char *m = (char *)&id[ATA_ID_PROD];
 	u8 type = (id[ATA_ID_CONFIG] >> 8) & 0x1f;
 
-	pr_info("%s: %s, ATAPI ", drive->name, m);
+	dev_info(&drive->gendev, "%s, ATAPI ", m);
 	switch (type) {
 	case ide_floppy:
 		if (!strstr(m, "CD-ROM")) {
@@ -203,7 +203,7 @@ static void do_identify(ide_drive_t *drive, u8 cmd, u16 *id)
 
 	drive->dev_flags |= IDE_DFLAG_ID_READ;
 #ifdef DEBUG
-	pr_info("%s: dumping identify data\n", drive->name);
+	dev_info(&drive->gendev, "dumping identify data\n");
 	ide_dump_identify((u8 *)id);
 #endif
 	ide_fix_driveid(id);
@@ -271,9 +271,10 @@ int ide_dev_read_id(ide_drive_t *drive, u8 cmd, u16 *id)
 		s = tp_ops->read_status(hwif);
 		if ((a ^ s) & ~ATA_IDX)
 			/* ancient Seagate drives, broken interfaces */
-			pr_info("%s: probing with STATUS(0x%02x) "
-				"instead of ALTSTATUS(0x%02x)\n",
-				drive->name, s, a);
+			dev_info(&drive->gendev,
+				 "probing with STATUS(0x%02x) "
+				 "instead of ALTSTATUS(0x%02x)\n",
+				 s, a);
 		else
 			/* use non-intrusive polling */
 			use_altstatus = 1;
@@ -376,9 +377,10 @@ static int do_probe (ide_drive_t *drive, u8 cmd)
 		return 4;
 
 #ifdef DEBUG
-	pr_info("probing for %s: present=%d, media=%d, probetype=%s\n",
-		drive->name, present, drive->media,
-		(cmd == ATA_CMD_ID_ATA) ? "ATA" : "ATAPI");
+	dev_info(&drive->gendev,
+		 "probing for %s: present=%d, media=%d, probetype=%s\n",
+		 present, drive->media,
+		 (cmd == ATA_CMD_ID_ATA) ? "ATA" : "ATAPI");
 #endif
 
 	/* needed for some systems
@@ -414,8 +416,9 @@ static int do_probe (ide_drive_t *drive, u8 cmd)
 			return 4;
 
 		if (rc == 1 && cmd == ATA_CMD_ID_ATAPI) {
-			pr_err("%s: no response (status = 0x%02x), resetting drive\n",
-			       drive->name, stat);
+			dev_err(&drive->gendev,
+				"no response (status = 0x%02x), resetting drive\n",
+				stat);
 			msleep(50);
 			tp_ops->dev_select(drive);
 			msleep(50);
@@ -428,8 +431,8 @@ static int do_probe (ide_drive_t *drive, u8 cmd)
 		stat = tp_ops->read_status(hwif);
 
 		if (rc == 1)
-			pr_err("%s: no response (status = 0x%02x)\n",
-			       drive->name, stat);
+			dev_err(&drive->gendev,
+				"no response (status = 0x%02x)\n", stat);
 	} else {
 		/* not present or maybe ATAPI */
 		rc = 3;
@@ -499,15 +502,16 @@ static u8 probe_for_drive(ide_drive_t *drive)
 		/* identification failed? */
 		if ((drive->dev_flags & IDE_DFLAG_ID_READ) == 0) {
 			if (drive->media == ide_disk) {
-				pr_info("%s: non-IDE drive, CHS=%d/%d/%d\n",
-					drive->name, drive->cyl,
-					drive->head, drive->sect);
+				dev_info(&drive->gendev,
+					 "non-IDE drive, CHS=%d/%d/%d\n",
+					 drive->cyl, drive->head, drive->sect);
 			} else if (drive->media == ide_cdrom) {
-				pr_info("%s: ATAPI cdrom (?)\n", drive->name);
+				dev_info(&drive->gendev,
+					 "ATAPI cdrom (?)\n");
 			} else {
 				/* nuke it */
-				pr_warning("%s: Unknown device on bus refused identification. Ignoring.\n",
-					   drive->name);
+				dev_warn(&drive->gendev,
+					 "Unknown device on bus refused identification. Ignoring.\n");
 				drive->dev_flags &= ~IDE_DFLAG_PRESENT;
 			}
 		} else {
@@ -558,8 +562,8 @@ static int ide_register_port(ide_hwif_t *hwif)
 
 	ret = device_register(&hwif->gendev);
 	if (ret < 0) {
-		pr_warning("IDE: %s: device_register error: %d\n",
-			   __func__, ret);
+		dev_warn(&hwif->gendev, "ide: %s: device_register error: %d\n",
+			 __func__, ret);
 		goto out;
 	}
 
@@ -673,7 +677,7 @@ void ide_undecoded_slave(ide_drive_t *dev1)
 		return;
 
 	/* Appears to be an IDE flash adapter with decode bugs */
-	pr_warning("ide-probe: ignoring undecoded slave\n");
+	dev_warn(&dev1->gendev, "ide-probe: ignoring undecoded slave\n");
 
 	dev1->dev_flags &= ~IDE_DFLAG_PRESENT;
 }
@@ -813,7 +817,7 @@ static int ide_port_setup_devices(ide_hwif_t *hwif)
 	mutex_lock(&ide_cfg_mtx);
 	ide_port_for_each_present_dev(i, drive, hwif) {
 		if (ide_init_queue(drive)) {
-			pr_err("ide: failed to init %s\n", drive->name);
+			dev_err(&drive->gendev, "ide: failed to init\n");
 			kfree(drive->id);
 			drive->id = NULL;
 			drive->dev_flags &= ~IDE_DFLAG_PRESENT;
@@ -847,12 +851,12 @@ static int init_irq (ide_hwif_t *hwif)
 		goto out_up;
 
 #if !defined(__mc68000__)
-	pr_info("%s at 0x%03lx-0x%03lx,0x%03lx on irq %d", hwif->name,
-		io_ports->data_addr, io_ports->status_addr,
-		io_ports->ctl_addr, hwif->irq);
+	dev_info(&hwif->gendev, "at 0x%03lx-0x%03lx,0x%03lx on irq %d",
+		 io_ports->data_addr, io_ports->status_addr,
+		 io_ports->ctl_addr, hwif->irq);
 #else
-	pr_info("%s at 0x%08lx on irq %d", hwif->name,
-		io_ports->data_addr, hwif->irq);
+	dev_info(&hwif->gendev, "at 0x%08lx on irq %d",
+		 io_ports->data_addr, hwif->irq);
 #endif /* __mc68000__ */
 	if (hwif->host->host_flags & IDE_HFLAG_SERIALIZE)
 		pr_cont(" (serialized)");
@@ -955,7 +959,7 @@ static void drive_release_dev (struct device *dev)
 static int hwif_init(ide_hwif_t *hwif)
 {
 	if (!hwif->irq) {
-		pr_err("%s: disabled, no IRQ\n", hwif->name);
+		dev_err(&hwif->gendev, "disabled, no IRQ\n");
 		return 0;
 	}
 
@@ -968,15 +972,15 @@ static int hwif_init(ide_hwif_t *hwif)
 	hwif->sg_table = kmalloc(sizeof(struct scatterlist)*hwif->sg_max_nents,
 				 GFP_KERNEL);
 	if (!hwif->sg_table) {
-		pr_err("%s: unable to allocate SG table.\n", hwif->name);
+		dev_err(&hwif->gendev, "unable to allocate SG table.\n");
 		goto out;
 	}
 
 	sg_init_table(hwif->sg_table, hwif->sg_max_nents);
 	
 	if (init_irq(hwif)) {
-		pr_err("%s: disabled, unable to get IRQ %d\n",
-		       hwif->name, hwif->irq);
+		dev_err(&hwif->gendev, "disabled, unable to get IRQ %d\n",
+			hwif->irq);
 		goto out;
 	}
 
@@ -1006,8 +1010,8 @@ static void hwif_register_devices(ide_hwif_t *hwif)
 
 		ret = device_register(dev);
 		if (ret < 0)
-			pr_warning("IDE: %s: device_register error: %d\n",
-				   __func__, ret);
+			dev_warn(dev, "IDE: %s: device_register error: %d\n",
+				 __func__, ret);
 	}
 }
 
@@ -1071,7 +1075,7 @@ static void ide_init_port(ide_hwif_t *hwif, unsigned int port,
 			rc = ide_hwif_setup_dma(hwif, d);
 
 		if (rc < 0) {
-			pr_info("%s: DMA disabled\n", hwif->name);
+			dev_info(&hwif->gendev, "DMA disabled\n");
 
 			hwif->dma_ops = NULL;
 			hwif->dma_base = 0;
@@ -1328,7 +1332,7 @@ static void ide_disable_port(ide_hwif_t *hwif)
 	struct ide_host *host = hwif->host;
 	int i;
 
-	pr_info("%s: disabling port\n", hwif->name);
+	dev_info(&hwif->gendev, "disabling port\n");
 
 	for (i = 0; i < MAX_HOST_PORTS; i++) {
 		if (host->ports[i] == hwif) {
@@ -1391,8 +1395,8 @@ int ide_host_register(struct ide_host *host, const struct ide_port_info *d,
 			continue;
 
 		if (hwif_init(hwif) == 0) {
-			pr_info("%s: failed to initialize IDE interface\n",
-				hwif->name);
+			dev_info(&hwif->gendev,
+				 "failed to initialize IDE interface\n");
 			device_unregister(&hwif->gendev);
 			ide_disable_port(hwif);
 			continue;
diff --git a/drivers/ide/ide-proc.c b/drivers/ide/ide-proc.c
index 0fa097e..fcc4fcb 100644
--- a/drivers/ide/ide-proc.c
+++ b/drivers/ide/ide-proc.c
@@ -463,13 +463,14 @@ static int ide_replace_subdriver(ide_drive_t *drive, const char *driver)
 	strlcpy(drive->driver_req, driver, sizeof(drive->driver_req));
 	err = device_attach(dev);
 	if (err < 0)
-		pr_warning("IDE: %s: device_attach error: %d\n", __func__, err);
+		dev_warn(dev, "IDE: %s: device_attach error: %d\n",
+			 __func__, err);
 	drive->driver_req[0] = 0;
 	if (dev->driver == NULL) {
 		err = device_attach(dev);
 		if (err < 0)
-			pr_warning("IDE: %s: device_attach(2) error: %d\n",
-				   __func__, err);
+			dev_warn(dev, "IDE: %s: device_attach(2) error: %d\n",
+				 __func__, err);
 	}
 	if (dev->driver && !strcmp(dev->driver->name, driver))
 		ret = 0;
diff --git a/drivers/ide/ide-taskfile.c b/drivers/ide/ide-taskfile.c
index baf0956..cdaa9af 100644
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -86,7 +86,7 @@ ide_startstop_t do_rw_taskfile(ide_drive_t *drive, struct ide_cmd *orig_cmd)
 	if (orig_cmd->protocol == ATA_PROT_PIO &&
 	    (orig_cmd->tf_flags & IDE_TFLAG_MULTI_PIO) &&
 	    drive->mult_count == 0) {
-		pr_err("%s: multimode not set!\n", drive->name);
+		dev_err(&drive->gendev, "multimode not set!\n");
 		return ide_stopped;
 	}
 
@@ -215,7 +215,7 @@ static u8 wait_drive_not_busy(ide_drive_t *drive)
 	}
 
 	if (stat & ATA_BUSY)
-		pr_err("%s: drive still BUSY!\n", drive->name);
+		dev_err(&drive->gendev, "drive still BUSY!\n");
 
 	return stat;
 }
@@ -399,10 +399,9 @@ static ide_startstop_t pre_task_out_intr(ide_drive_t *drive,
 
 	if (ide_wait_stat(&startstop, drive, ATA_DRQ,
 			  drive->bad_wstat, WAIT_DRQ)) {
-		pr_err("%s: no DRQ after issuing %sWRITE%s\n",
-		       drive->name,
-		       (cmd->tf_flags & IDE_TFLAG_MULTI_PIO) ? "MULT" : "",
-		       (drive->dev_flags & IDE_DFLAG_LBA48) ? "_EXT" : "");
+		dev_err(&drive->gendev, "no DRQ after issuing %sWRITE%s\n",
+			(cmd->tf_flags & IDE_TFLAG_MULTI_PIO) ? "MULT" : "",
+			(drive->dev_flags & IDE_DFLAG_LBA48) ? "_EXT" : "");
 		return startstop;
 	}
 
@@ -576,8 +575,9 @@ int ide_taskfile_ioctl(ide_drive_t *drive, unsigned long arg)
 		case TASKFILE_MULTI_OUT:
 			if (!drive->mult_count) {
 				/* (hs): give up if multcount is not set */
-				pr_err("%s: %s Multimode Write multcount is not set\n",
-				       drive->name, __func__);
+				dev_err(&drive->gendev,
+					"%s Multimode Write multcount is not set\n",
+					__func__);
 				err = -EPERM;
 				goto abort;
 			}
@@ -595,8 +595,9 @@ int ide_taskfile_ioctl(ide_drive_t *drive, unsigned long arg)
 		case TASKFILE_MULTI_IN:
 			if (!drive->mult_count) {
 				/* (hs): give up if multcount is not set */
-				pr_err("%s: %s Multimode Read failure multcount is not set\n",
-				       drive->name, __func__);
+				dev_err(&drive->gendev,
+					"%s Multimode Read failure multcount is not set\n",
+					__func__);
 				err = -EPERM;
 				goto abort;
 			}
@@ -624,8 +625,8 @@ int ide_taskfile_ioctl(ide_drive_t *drive, unsigned long arg)
 		nsect = (cmd.hob.nsect << 8) | cmd.tf.nsect;
 
 		if (!nsect) {
-			pr_err("%s: in/out command without data\n",
-			       drive->name);
+			dev_err(&drive->gendev,
+				"in/out command without data\n");
 			err = -EFAULT;
 			goto abort;
 		}
diff --git a/drivers/ide/ide-xfer-mode.c b/drivers/ide/ide-xfer-mode.c
index 03d8e14..023d6bb 100644
--- a/drivers/ide/ide-xfer-mode.c
+++ b/drivers/ide/ide-xfer-mode.c
@@ -70,7 +70,7 @@ u8 ide_get_best_pio_mode(ide_drive_t *drive, u8 mode_wanted, u8 max_mode)
 		pio_mode = ide_scan_pio_blacklist((char *)&id[ATA_ID_PROD]);
 
 	if (pio_mode != -1) {
-		pr_info("%s: is on PIO blacklist\n", drive->name);
+		dev_info(&drive->gendev, "is on PIO blacklist\n");
 	} else {
 		pio_mode = id[ATA_ID_OLD_PIO_MODES] >> 8;
 		if (pio_mode > 2) {	/* 2 is maximum allowed tPIO value */
@@ -96,8 +96,8 @@ u8 ide_get_best_pio_mode(ide_drive_t *drive, u8 mode_wanted, u8 max_mode)
 		}
 
 		if (overridden)
-			pr_info("%s: tPIO > 2, assuming tPIO = 2\n",
-				drive->name);
+			dev_info(&drive->gendev,
+				 "tPIO > 2, assuming tPIO = 2\n");
 	}
 
 	if (pio_mode > max_mode)
diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index 966c2da..103c6a4 100644
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -273,23 +273,23 @@ static void ide_dev_apply_params(ide_drive_t *drive, u8 unit)
 	int i = drive->hwif->index * MAX_DRIVES + unit;
 
 	if (ide_nodma & (1 << i)) {
-		pr_info("ide: disallowing DMA for %s\n", drive->name);
+		dev_info(&drive->gendev, "ide: disallowing DMA\n");
 		drive->dev_flags |= IDE_DFLAG_NODMA;
 	}
 	if (ide_noflush & (1 << i)) {
-		pr_info("ide: disabling flush requests for %s\n", drive->name);
+		dev_info(&drive->gendev, "ide: disabling flush requests\n");
 		drive->dev_flags |= IDE_DFLAG_NOFLUSH;
 	}
 	if (ide_noprobe & (1 << i)) {
-		pr_info("ide: skipping probe for %s\n", drive->name);
+		dev_info(&drive->gendev, "ide: skipping probe\n");
 		drive->dev_flags |= IDE_DFLAG_NOPROBE;
 	}
 	if (ide_nowerr & (1 << i)) {
-		pr_info("ide: ignoring the ATA_DF bit for %s\n", drive->name);
+		dev_info(&drive->gendev, "ide: ignoring the ATA_DF bit\n");
 		drive->bad_wstat = BAD_R_STAT;
 	}
 	if (ide_cdroms & (1 << i)) {
-		pr_info("ide: forcing %s as a CD-ROM\n", drive->name);
+		dev_info(&drive->gendev, "ide: forcing use as a CD-ROM\n");
 		drive->dev_flags |= IDE_DFLAG_PRESENT;
 		drive->media = ide_cdrom;
 		/* an ATAPI device ignores DRDY */
@@ -300,8 +300,9 @@ static void ide_dev_apply_params(ide_drive_t *drive, u8 unit)
 		drive->head = drive->bios_head = ide_disks_chs[i].head;
 		drive->sect = drive->bios_sect = ide_disks_chs[i].sect;
 
-		pr_info("ide: forcing %s as a disk (%d/%d/%d)\n",
-			drive->name, drive->cyl, drive->head, drive->sect);
+		dev_info(&drive->gendev,
+			 "ide: forcing use as a disk (%d/%d/%d)\n",
+			 drive->cyl, drive->head, drive->sect);
 
 		drive->dev_flags |= IDE_DFLAG_FORCED_GEOM | IDE_DFLAG_PRESENT;
 		drive->media = ide_disk;
@@ -340,7 +341,7 @@ void ide_port_apply_params(ide_hwif_t *hwif)
 	int i;
 
 	if (ide_ignore_cable & (1 << hwif->index)) {
-		pr_info("ide: ignoring cable detection for %s\n", hwif->name);
+		dev_info(&hwif->gendev, "ide: ignoring cable detection\n");
 		hwif->cbl = ATA_CBL_PATA40_SHORT;
 	}
 
diff --git a/drivers/ide/setup-pci.c b/drivers/ide/setup-pci.c
index 42887b2..b9ec731 100644
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -383,10 +383,11 @@ int ide_hwif_setup_dma(ide_hwif_t *hwif, const struct ide_port_info *d)
 			return -1;
 
 		if (hwif->host_flags & IDE_HFLAG_MMIO)
-			pr_info("    %s: MMIO-DMA\n", hwif->name);
+			dev_info(&hwif->gendev, "    MMIO-DMA\n");
 		else
-			pr_info("    %s: BM-DMA at 0x%04lx-0x%04lx\n",
-				hwif->name, base, base + 7);
+			dev_info(&hwif->gendev,
+				 "    BM-DMA at 0x%04lx-0x%04lx\n",
+				 base, base + 7);
 
 		hwif->extra_base = base + (hwif->channel ? 8 : 16);
 
-- 
1.6.3.1.10.g659a0.dirty

