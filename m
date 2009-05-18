Return-Path: <linux-kernel-owner+w=401wt.eu-S1755255AbZERUMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255AbZERUMR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 16:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754075AbZERUMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 16:12:00 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1936 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758AbZERUL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 16:11:56 -0400
From: Joe Perches <joe@perches.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Krzysztof Halasa <khc@pm.waw.pl>, Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Elias Oltmanns <eo@nebensachen.de>
Subject: [PATCH 1/2] drivers/ide/ide-core: Convert printk(KERN_<foo> to pr_<foo>( without KERN_DEBUG
Date: Mon, 18 May 2009 13:11:27 -0700
Message-Id: <8f8b7efae05ec8e7a86fdf4eaca08df12e5d3e19.1242676752.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1242676752.git.joe@perches.com>
References: <cover.1242676752.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/ide/ide-acpi.c      |   17 +++-----
 drivers/ide/ide-atapi.c     |   66 +++++++++++++++----------------
 drivers/ide/ide-dma-sff.c   |    8 ++--
 drivers/ide/ide-dma.c       |   27 ++++++-------
 drivers/ide/ide-eh.c        |   26 ++++++------
 drivers/ide/ide-io.c        |   15 +++----
 drivers/ide/ide-ioctls.c    |    4 +-
 drivers/ide/ide-iops.c      |   10 ++--
 drivers/ide/ide-legacy.c    |    8 ++--
 drivers/ide/ide-lib.c       |   68 ++++++++++++++++----------------
 drivers/ide/ide-pm.c        |    6 +-
 drivers/ide/ide-probe.c     |   88 +++++++++++++++++++++---------------------
 drivers/ide/ide-proc.c      |   15 +++----
 drivers/ide/ide-scan-pci.c  |    4 +-
 drivers/ide/ide-taskfile.c  |   26 ++++++-------
 drivers/ide/ide-xfer-mode.c |    6 +-
 drivers/ide/ide.c           |   24 +++++-------
 drivers/ide/setup-pci.c     |   86 ++++++++++++++++++++---------------------
 18 files changed, 242 insertions(+), 262 deletions(-)

diff --git a/drivers/ide/ide-acpi.c b/drivers/ide/ide-acpi.c
index 77f79d2..87da341 100644
--- a/drivers/ide/ide-acpi.c
+++ b/drivers/ide/ide-acpi.c
@@ -67,7 +67,7 @@ static bool ide_noacpi_psx;
 static int no_acpi_psx(const struct dmi_system_id *id)
 {
 	ide_noacpi_psx = true;
-	printk(KERN_NOTICE"%s detected - disable ACPI _PSx.\n", id->ident);
+	pr_notice("%s detected - disable ACPI _PSx.\n", id->ident);
 	return 0;
 }
 
@@ -262,8 +262,7 @@ static int do_drive_get_GTF(ide_drive_t *drive,
 
 	if (!out_obj->buffer.length || !out_obj->buffer.pointer ||
 	    out_obj->buffer.length % REGS_PER_GTF) {
-		printk(KERN_ERR
-		       "%s: unexpected GTF length (%d) or addr (0x%p)\n",
+		pr_err("%s: unexpected GTF length (%d) or addr (0x%p)\n",
 		       __func__, out_obj->buffer.length,
 		       out_obj->buffer.pointer);
 		err = -ENOENT;
@@ -324,8 +323,8 @@ static int do_drive_set_taskfiles(ide_drive_t *drive,
 
 		err = ide_no_data_taskfile(drive, &cmd);
 		if (err) {
-			printk(KERN_ERR "%s: ide_no_data_taskfile failed: %u\n",
-					__func__, err);
+			pr_err("%s: ide_no_data_taskfile failed: %u\n",
+			       __func__, err);
 			rc = err;
 		}
 	}
@@ -436,11 +435,9 @@ void ide_acpi_get_timing(ide_hwif_t *hwif)
 	if (!out_obj->buffer.length || !out_obj->buffer.pointer ||
 	    out_obj->buffer.length != sizeof(struct GTM_buffer)) {
 		kfree(output.pointer);
-		printk(KERN_ERR
-			"%s: unexpected _GTM length (0x%x)[should be 0x%zx] or "
-			"addr (0x%p)\n",
-			__func__, out_obj->buffer.length,
-			sizeof(struct GTM_buffer), out_obj->buffer.pointer);
+		pr_err("%s: unexpected _GTM length (0x%x)[should be 0x%zx] or addr (0x%p)\n",
+		       __func__, out_obj->buffer.length,
+		       sizeof(struct GTM_buffer), out_obj->buffer.pointer);
 		return;
 	}
 
diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index 7201b17..9a6ec77 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -12,7 +12,7 @@
 
 #ifdef DEBUG
 #define debug_log(fmt, args...) \
-	printk(KERN_INFO "ide: " fmt, ## args)
+	pr_info("ide: " fmt, ## args)
 #else
 #define debug_log(fmt, args...) do {} while (0)
 #endif
@@ -50,21 +50,21 @@ int ide_check_atapi_device(ide_drive_t *drive, const char *s)
 #endif
 
 	if (protocol != 2)
-		printk(KERN_ERR "%s: %s: protocol (0x%02x) is not ATAPI\n",
-			s, drive->name, protocol);
+		pr_err("%s: %s: protocol (0x%02x) is not ATAPI\n",
+		       s, drive->name, protocol);
 	else if ((drive->media == ide_floppy && device_type != 0) ||
 		 (drive->media == ide_tape && device_type != 1))
-		printk(KERN_ERR "%s: %s: invalid device type (0x%02x)\n",
-			s, drive->name, device_type);
+		pr_err("%s: %s: invalid device type (0x%02x)\n",
+		       s, drive->name, device_type);
 	else if (removable == 0)
-		printk(KERN_ERR "%s: %s: the removable flag is not set\n",
-			s, drive->name);
+		pr_err("%s: %s: the removable flag is not set\n",
+		       s, drive->name);
 	else if (drive->media == ide_floppy && drq_type == 3)
-		printk(KERN_ERR "%s: %s: sorry, DRQ type (0x%02x) not "
-			"supported\n", s, drive->name, drq_type);
+		pr_err("%s: %s: sorry, DRQ type (0x%02x) not supported\n",
+		       s, drive->name, drq_type);
 	else if (packet_size != 0)
-		printk(KERN_ERR "%s: %s: packet size (0x%02x) is not 12 "
-			"bytes\n", s, drive->name, packet_size);
+		pr_err("%s: %s: packet size (0x%02x) is not 12 bytes\n",
+		       s, drive->name, packet_size);
 	else
 		return 1;
 	return 0;
@@ -231,8 +231,7 @@ int ide_cd_expiry(ide_drive_t *drive)
 		break;
 	default:
 		if (!(rq->cmd_flags & REQ_QUIET))
-			printk(KERN_INFO "cmd 0x%x timed out\n",
-					 rq->cmd[0]);
+			pr_info("cmd 0x%x timed out\n", rq->cmd[0]);
 		wait = 0;
 		break;
 	}
@@ -299,9 +298,9 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 
 		if (rc || (drive->media == ide_tape && (stat & ATA_ERR))) {
 			if (drive->media == ide_floppy)
-				printk(KERN_ERR "%s: DMA %s error\n",
-					drive->name, rq_data_dir(pc->rq)
-						     ? "write" : "read");
+				pr_err("%s: DMA %s error\n",
+				       drive->name,
+				       rq_data_dir(pc->rq) ? "write" : "read");
 			pc->flags |= PC_FLAG_DMA_ERROR;
 		} else {
 			pc->xferred = pc->req_xfer;
@@ -335,8 +334,8 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 				pc->rq->errors++;
 
 			if (rq->cmd[0] == REQUEST_SENSE) {
-				printk(KERN_ERR "%s: I/O error in request sense"
-						" command\n", drive->name);
+				pr_err("%s: I/O error in request sense command\n",
+				       drive->name);
 				return ide_do_reset(drive);
 			}
 
@@ -384,8 +383,8 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 
 	if (pc->flags & PC_FLAG_DMA_IN_PROGRESS) {
 		pc->flags &= ~PC_FLAG_DMA_IN_PROGRESS;
-		printk(KERN_ERR "%s: The device wants to issue more interrupts "
-				"in DMA mode\n", drive->name);
+		pr_err("%s: The device wants to issue more interrupts in DMA mode\n",
+		       drive->name);
 		ide_dma_off(drive);
 		return ide_do_reset(drive);
 	}
@@ -394,16 +393,16 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 	ide_read_bcount_and_ireason(drive, &bcount, &ireason);
 
 	if (ireason & ATAPI_COD) {
-		printk(KERN_ERR "%s: CoD != 0 in %s\n", drive->name, __func__);
+		pr_err("%s: CoD != 0 in %s\n", drive->name, __func__);
 		return ide_do_reset(drive);
 	}
 
 	if (((ireason & ATAPI_IO) == ATAPI_IO) == write) {
 		/* Hopefully, we will never get here */
-		printk(KERN_ERR "%s: We wanted to %s, but the device wants us "
-				"to %s!\n", drive->name,
-				(ireason & ATAPI_IO) ? "Write" : "Read",
-				(ireason & ATAPI_IO) ? "Read" : "Write");
+		pr_err("%s: We wanted to %s, but the device wants us to %s!\n",
+		       drive->name,
+		       (ireason & ATAPI_IO) ? "Write" : "Read",
+		       (ireason & ATAPI_IO) ? "Read" : "Write");
 		return ide_do_reset(drive);
 	}
 
@@ -463,14 +462,13 @@ static u8 ide_wait_ireason(ide_drive_t *drive, u8 ireason)
 
 	while (retries-- && ((ireason & ATAPI_COD) == 0 ||
 		(ireason & ATAPI_IO))) {
-		printk(KERN_ERR "%s: (IO,CoD != (0,1) while issuing "
-				"a packet command, retrying\n", drive->name);
+		pr_err("%s: (IO,CoD != (0,1) while issuing a packet command, retrying\n",
+		       drive->name);
 		udelay(100);
 		ireason = ide_read_ireason(drive);
 		if (retries == 0) {
-			printk(KERN_ERR "%s: (IO,CoD != (0,1) while issuing "
-					"a packet command, ignoring\n",
-					drive->name);
+			pr_err("%s: (IO,CoD != (0,1) while issuing a packet command, ignoring\n",
+			       drive->name);
 			ireason |= ATAPI_COD;
 			ireason &= ~ATAPI_IO;
 		}
@@ -500,8 +498,8 @@ static ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
 	u8 ireason;
 
 	if (ide_wait_stat(&startstop, drive, ATA_DRQ, ATA_BUSY, WAIT_READY)) {
-		printk(KERN_ERR "%s: Strange, packet command initiated yet "
-				"DRQ isn't asserted\n", drive->name);
+		pr_err("%s: Strange, packet command initiated yet DRQ isn't asserted\n",
+		       drive->name);
 		return startstop;
 	}
 
@@ -542,8 +540,8 @@ static ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
 			ireason = ide_wait_ireason(drive, ireason);
 
 		if ((ireason & ATAPI_COD) == 0 || (ireason & ATAPI_IO)) {
-			printk(KERN_ERR "%s: (IO,CoD) != (0,1) while issuing "
-					"a packet command\n", drive->name);
+			pr_err("%s: (IO,CoD) != (0,1) while issuing a packet command\n",
+			       drive->name);
 
 			return ide_do_reset(drive);
 		}
diff --git a/drivers/ide/ide-dma-sff.c b/drivers/ide/ide-dma-sff.c
index e4cdf78..b3d9fb6 100644
--- a/drivers/ide/ide-dma-sff.c
+++ b/drivers/ide/ide-dma-sff.c
@@ -162,8 +162,8 @@ int ide_build_dmatable(ide_drive_t *drive, struct ide_cmd *cmd)
 	}
 
 use_pio_instead:
-	printk(KERN_ERR "%s: %s\n", drive->name,
-		count ? "DMA table too small" : "empty DMA table?");
+	pr_err("%s: %s\n", drive->name,
+	       count ? "DMA table too small" : "empty DMA table?");
 
 	return 0; /* revert to PIO for this request */
 }
@@ -238,8 +238,8 @@ int ide_dma_sff_timer_expiry(ide_drive_t *drive)
 	ide_hwif_t *hwif = drive->hwif;
 	u8 dma_stat = hwif->dma_ops->dma_sff_read_status(hwif);
 
-	printk(KERN_WARNING "%s: %s: DMA status (0x%02x)\n",
-		drive->name, __func__, dma_stat);
+	pr_warning("%s: %s: DMA status (0x%02x)\n",
+		   drive->name, __func__, dma_stat);
 
 	if ((dma_stat & 0x18) == 0x18)	/* BUSY Stupid Early Timer !! */
 		return WAIT_CMD;
diff --git a/drivers/ide/ide-dma.c b/drivers/ide/ide-dma.c
index a0b8cab..bd33ed4 100644
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -106,8 +106,8 @@ ide_startstop_t ide_dma_intr(ide_drive_t *drive)
 						cmd->rq->nr_sectors << 9);
 			return ide_stopped;
 		}
-		printk(KERN_ERR "%s: %s: bad DMA status (0x%02x)\n",
-			drive->name, __func__, dma_stat);
+		pr_err("%s: %s: bad DMA status (0x%02x)\n",
+		       drive->name, __func__, dma_stat);
 	}
 	return ide_error(drive, "dma_intr", stat);
 }
@@ -194,7 +194,7 @@ EXPORT_SYMBOL(ide_dma_off_quietly);
 
 void ide_dma_off(ide_drive_t *drive)
 {
-	printk(KERN_INFO "%s: DMA disabled\n", drive->name);
+	pr_info("%s: DMA disabled\n", drive->name);
 	ide_dma_off_quietly(drive);
 }
 EXPORT_SYMBOL(ide_dma_off);
@@ -220,8 +220,8 @@ int __ide_dma_bad_drive(ide_drive_t *drive)
 
 	int blacklist = ide_in_drive_list(id, drive_blacklist);
 	if (blacklist) {
-		printk(KERN_WARNING "%s: Disabling (U)DMA for %s (blacklisted)\n",
-				    drive->name, (char *)&id[ATA_ID_PROD]);
+		pr_warning("%s: Disabling (U)DMA for %s (blacklisted)\n",
+			   drive->name, (char *)&id[ATA_ID_PROD]);
 		return blacklist;
 	}
 	return 0;
@@ -342,8 +342,8 @@ u8 ide_find_dma_mode(ide_drive_t *drive, u8 req_mode)
 
 	mode = min(mode, req_mode);
 
-	printk(KERN_INFO "%s: %s mode selected\n", drive->name,
-			  mode ? ide_xfer_verbose(mode) : "no DMA");
+	pr_info("%s: %s mode selected\n", drive->name,
+		mode ? ide_xfer_verbose(mode) : "no DMA");
 
 	return mode;
 }
@@ -409,7 +409,7 @@ int ide_id_dma_bug(ide_drive_t *drive)
 
 	return 0;
 err_out:
-	printk(KERN_ERR "%s: bad DMA info in identify block\n", drive->name);
+	pr_err("%s: bad DMA info in identify block\n", drive->name);
 	return 1;
 }
 
@@ -456,7 +456,7 @@ void ide_check_dma_crc(ide_drive_t *drive)
 
 void ide_dma_lost_irq(ide_drive_t *drive)
 {
-	printk(KERN_ERR "%s: DMA interrupt recovery\n", drive->name);
+	pr_err("%s: DMA interrupt recovery\n", drive->name);
 }
 EXPORT_SYMBOL_GPL(ide_dma_lost_irq);
 
@@ -478,17 +478,17 @@ ide_startstop_t ide_dma_timeout_retry(ide_drive_t *drive, int error)
 	 */
 
 	if (error < 0) {
-		printk(KERN_WARNING "%s: DMA timeout error\n", drive->name);
+		pr_warning("%s: DMA timeout error\n", drive->name);
 		drive->waiting_for_dma = 0;
 		(void)dma_ops->dma_end(drive);
 		ide_dma_unmap_sg(drive, cmd);
 		ret = ide_error(drive, "dma timeout error",
 				hwif->tp_ops->read_status(hwif));
 	} else {
-		printk(KERN_WARNING "%s: DMA timeout retry\n", drive->name);
+		pr_warning("%s: DMA timeout retry\n", drive->name);
 		if (dma_ops->dma_clear)
 			dma_ops->dma_clear(drive);
-		printk(KERN_ERR "%s: timeout waiting for DMA\n", drive->name);
+		pr_err("%s: timeout waiting for DMA\n", drive->name);
 		if (dma_ops->dma_test_irq(drive) == 0) {
 			ide_dump_status(drive, "DMA timeout",
 					hwif->tp_ops->read_status(hwif));
@@ -557,8 +557,7 @@ int ide_allocate_dma_engine(ide_hwif_t *hwif)
 						&hwif->dmatable_dma,
 						GFP_ATOMIC);
 	if (hwif->dmatable_cpu == NULL) {
-		printk(KERN_ERR "%s: unable to allocate PRD table\n",
-			hwif->name);
+		pr_err("%s: unable to allocate PRD table\n", hwif->name);
 		return -ENOMEM;
 	}
 
diff --git a/drivers/ide/ide-eh.c b/drivers/ide/ide-eh.c
index 5d5fb96..a7f0142 100644
--- a/drivers/ide/ide-eh.c
+++ b/drivers/ide/ide-eh.c
@@ -173,7 +173,7 @@ static ide_startstop_t atapi_reset_pollfunc(ide_drive_t *drive)
 	stat = tp_ops->read_status(hwif);
 
 	if (OK_STAT(stat, 0, ATA_BUSY))
-		printk(KERN_INFO "%s: ATAPI reset complete\n", drive->name);
+		pr_info("%s: ATAPI reset complete\n", drive->name);
 	else {
 		if (time_before(jiffies, hwif->poll_timeout)) {
 			ide_set_handler(drive, &atapi_reset_pollfunc, HZ/20);
@@ -182,8 +182,8 @@ static ide_startstop_t atapi_reset_pollfunc(ide_drive_t *drive)
 		}
 		/* end of polling */
 		hwif->polling = 0;
-		printk(KERN_ERR "%s: ATAPI reset timed-out, status=0x%02x\n",
-			drive->name, stat);
+		pr_err("%s: ATAPI reset timed-out, status=0x%02x\n",
+		       drive->name, stat);
 		/* do it the old fashioned way */
 		return do_reset1(drive, 1);
 	}
@@ -202,14 +202,14 @@ static void ide_reset_report_error(ide_hwif_t *hwif, u8 err)
 
 	u8 err_master = err & 0x7f;
 
-	printk(KERN_ERR "%s: reset: master: ", hwif->name);
+	pr_err("%s: reset: master: ", hwif->name);
 	if (err_master && err_master < 6)
-		printk(KERN_CONT "%s", err_master_vals[err_master]);
+		pr_cont("%s", err_master_vals[err_master]);
 	else
-		printk(KERN_CONT "error (0x%02x?)", err);
+		pr_cont("error (0x%02x?)", err);
 	if (err & 0x80)
-		printk(KERN_CONT "; slave: failed");
-	printk(KERN_CONT "\n");
+		pr_cont("; slave: failed");
+	pr_cont("\n");
 }
 
 /*
@@ -228,8 +228,8 @@ static ide_startstop_t reset_pollfunc(ide_drive_t *drive)
 	if (port_ops && port_ops->reset_poll) {
 		err = port_ops->reset_poll(drive);
 		if (err) {
-			printk(KERN_ERR "%s: host reset_poll failure for %s.\n",
-				hwif->name, drive->name);
+			pr_err("%s: host reset_poll failure for %s.\n",
+			       hwif->name, drive->name);
 			goto out;
 		}
 	}
@@ -242,15 +242,15 @@ static ide_startstop_t reset_pollfunc(ide_drive_t *drive)
 			/* continue polling */
 			return ide_started;
 		}
-		printk(KERN_ERR "%s: reset timed-out, status=0x%02x\n",
-			hwif->name, tmp);
+		pr_err("%s: reset timed-out, status=0x%02x\n",
+		       hwif->name, tmp);
 		drive->failures++;
 		err = -EIO;
 	} else  {
 		tmp = ide_read_error(drive);
 
 		if (tmp == 1) {
-			printk(KERN_INFO "%s: reset: success\n", hwif->name);
+			pr_info("%s: reset: success\n", hwif->name);
 			drive->failures = 0;
 		} else {
 			ide_reset_report_error(hwif, tmp);
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 35dc38d..75812db 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -95,8 +95,7 @@ void ide_complete_cmd(ide_drive_t *drive, struct ide_cmd *cmd, u8 stat, u8 err)
 	if ((cmd->tf_flags & IDE_TFLAG_CUSTOM_HANDLER) &&
 	    tf_cmd == ATA_CMD_IDLEIMMEDIATE) {
 		if (tf->lbal != 0xc4) {
-			printk(KERN_ERR "%s: head unload failed!\n",
-			       drive->name);
+			pr_err("%s: head unload failed!\n", drive->name);
 			ide_tf_dump(drive->name, cmd);
 		} else
 			drive->dev_flags |= IDE_DFLAG_PARKED;
@@ -204,7 +203,7 @@ static ide_startstop_t ide_disk_special(ide_drive_t *drive)
 	} else if (s->all) {
 		int special = s->all;
 		s->all = 0;
-		printk(KERN_ERR "%s: bad special flag: 0x%02x\n", drive->name, special);
+		pr_err("%s: bad special flag: 0x%02x\n", drive->name, special);
 		return ide_stopped;
 	}
 
@@ -355,7 +354,7 @@ static ide_startstop_t start_request (ide_drive_t *drive, struct request *rq)
 	drive->hwif->tp_ops->dev_select(drive);
 	if (ide_wait_stat(&startstop, drive, drive->ready_stat,
 			  ATA_BUSY | ATA_DRQ, WAIT_READY)) {
-		printk(KERN_ERR "%s: drive not ready for command\n", drive->name);
+		pr_err("%s: drive not ready for command\n", drive->name);
 		return startstop;
 	}
 	if (!drive->special.all) {
@@ -684,8 +683,7 @@ void ide_timer_expiry (unsigned long data)
 				hwif->dma_ops->dma_lost_irq(drive);
 			if (hwif->ack_intr)
 				hwif->ack_intr(hwif);
-			printk(KERN_WARNING "%s: lost interrupt\n",
-				drive->name);
+			pr_warning("%s: lost interrupt\n", drive->name);
 			startstop = handler(drive);
 		} else {
 			if (drive->waiting_for_dma)
@@ -749,9 +747,8 @@ static void unexpected_intr(int irq, ide_hwif_t *hwif)
 
 		if (time_after(jiffies, last_msgtime + HZ)) {
 			last_msgtime = jiffies;
-			printk(KERN_ERR "%s: unexpected interrupt, "
-				"status=0x%02x, count=%ld\n",
-				hwif->name, stat, count);
+			pr_err("%s: unexpected interrupt, status=0x%02x, count=%ld\n",
+			       hwif->name, stat, count);
 		}
 	}
 }
diff --git a/drivers/ide/ide-ioctls.c b/drivers/ide/ide-ioctls.c
index c1c25eb..aea6cc3 100644
--- a/drivers/ide/ide-ioctls.c
+++ b/drivers/ide/ide-ioctls.c
@@ -167,8 +167,8 @@ static int ide_cmd_ioctl(ide_drive_t *drive, unsigned long arg)
 	     id[ATA_ID_SWDMA_MODES])) {
 		xfer_rate = args[1];
 		if (tf->nsect > XFER_UDMA_2 && !eighty_ninty_three(drive)) {
-			printk(KERN_WARNING "%s: UDMA speeds >UDMA33 cannot "
-					    "be set\n", drive->name);
+			pr_warning("%s: UDMA speeds >UDMA33 cannot be set\n",
+				   drive->name);
 			goto abort;
 		}
 	}
diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
index c19a221..8fe778c 100644
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -259,10 +259,10 @@ no_80w:
 	if (drive->dev_flags & IDE_DFLAG_UDMA33_WARNED)
 		return 0;
 
-	printk(KERN_WARNING "%s: %s side 80-wire cable detection failed, "
-			    "limiting max speed to UDMA33\n",
-			    drive->name,
-			    hwif->cbl == ATA_CBL_PATA80 ? "drive" : "host");
+	pr_warning("%s: %s side 80-wire cable detection failed, "
+		   "limiting max speed to UDMA33\n",
+		   drive->name,
+		   hwif->cbl == ATA_CBL_PATA80 ? "drive" : "host");
 
 	drive->dev_flags |= IDE_DFLAG_UDMA33_WARNED;
 
@@ -300,7 +300,7 @@ int ide_driveid_update(ide_drive_t *drive)
 out_err:
 	SELECT_MASK(drive, 0);
 	if (rc == 2)
-		printk(KERN_ERR "%s: %s: bad status\n", drive->name, __func__);
+		pr_err("%s: %s: bad status\n", drive->name, __func__);
 	kfree(id);
 	return 0;
 }
diff --git a/drivers/ide/ide-legacy.c b/drivers/ide/ide-legacy.c
index 8c5dcbf..bb42707 100644
--- a/drivers/ide/ide-legacy.c
+++ b/drivers/ide/ide-legacy.c
@@ -19,14 +19,14 @@ static void ide_legacy_init_one(hw_regs_t **hws, hw_regs_t *hw,
 	}
 
 	if (!request_region(base, 8, d->name)) {
-		printk(KERN_ERR "%s: I/O resource 0x%lX-0x%lX not free.\n",
-				d->name, base, base + 7);
+		pr_err("%s: I/O resource 0x%lX-0x%lX not free.\n",
+		       d->name, base, base + 7);
 		return;
 	}
 
 	if (!request_region(ctl, 1, d->name)) {
-		printk(KERN_ERR "%s: I/O resource 0x%lX not free.\n",
-				d->name, ctl);
+		pr_err("%s: I/O resource 0x%lX not free.\n",
+		       d->name, ctl);
 		release_region(base, 8);
 		return;
 	}
diff --git a/drivers/ide/ide-lib.c b/drivers/ide/ide-lib.c
index 56ff8c4..b7b7474 100644
--- a/drivers/ide/ide-lib.c
+++ b/drivers/ide/ide-lib.c
@@ -42,11 +42,11 @@ static void ide_dump_opcode(ide_drive_t *drive)
 	if (rq->cmd_type == REQ_TYPE_ATA_TASKFILE)
 		cmd = rq->special;
 
-	printk(KERN_ERR "ide: failed opcode was: ");
+	pr_err("ide: failed opcode was: ");
 	if (cmd == NULL)
-		printk(KERN_CONT "unknown\n");
+		pr_cont("unknown\n");
 	else
-		printk(KERN_CONT "0x%02x\n", cmd->tf.command);
+		pr_cont("0x%02x\n", cmd->tf.command);
 }
 
 u64 ide_get_lba_addr(struct ide_cmd *cmd, int lba48)
@@ -82,30 +82,30 @@ static void ide_dump_sector(ide_drive_t *drive)
 	ide_tf_readback(drive, &cmd);
 
 	if (lba48 || (tf->device & ATA_LBA))
-		printk(KERN_CONT ", LBAsect=%llu",
+		pr_cont(", LBAsect=%llu",
 			(unsigned long long)ide_get_lba_addr(&cmd, lba48));
 	else
-		printk(KERN_CONT ", CHS=%d/%d/%d", (tf->lbah << 8) + tf->lbam,
+		pr_cont(", CHS=%d/%d/%d", (tf->lbah << 8) + tf->lbam,
 			tf->device & 0xf, tf->lbal);
 }
 
 static void ide_dump_ata_error(ide_drive_t *drive, u8 err)
 {
-	printk(KERN_ERR "{ ");
+	pr_err("{ ");
 	if (err & ATA_ABORTED)
-		printk(KERN_CONT "DriveStatusError ");
+		pr_cont("DriveStatusError ");
 	if (err & ATA_ICRC)
-		printk(KERN_CONT "%s",
+		pr_cont("%s",
 			(err & ATA_ABORTED) ? "BadCRC " : "BadSector ");
 	if (err & ATA_UNC)
-		printk(KERN_CONT "UncorrectableError ");
+		pr_cont("UncorrectableError ");
 	if (err & ATA_IDNF)
-		printk(KERN_CONT "SectorIdNotFound ");
+		pr_cont("SectorIdNotFound ");
 	if (err & ATA_TRK0NF)
-		printk(KERN_CONT "TrackZeroNotFound ");
+		pr_cont("TrackZeroNotFound ");
 	if (err & ATA_AMNF)
-		printk(KERN_CONT "AddrMarkNotFound ");
-	printk(KERN_CONT "}");
+		pr_cont("AddrMarkNotFound ");
+	pr_cont("}");
 	if ((err & (ATA_BBK | ATA_ABORTED)) == ATA_BBK ||
 	    (err & (ATA_UNC | ATA_IDNF | ATA_AMNF))) {
 		struct request *rq = drive->hwif->rq;
@@ -113,27 +113,27 @@ static void ide_dump_ata_error(ide_drive_t *drive, u8 err)
 		ide_dump_sector(drive);
 
 		if (rq)
-			printk(KERN_CONT ", sector=%llu",
-			       (unsigned long long)rq->sector);
+			pr_cont(", sector=%llu",
+				(unsigned long long)rq->sector);
 	}
-	printk(KERN_CONT "\n");
+	pr_cont("\n");
 }
 
 static void ide_dump_atapi_error(ide_drive_t *drive, u8 err)
 {
-	printk(KERN_ERR "{ ");
+	pr_err("{ ");
 	if (err & ATAPI_ILI)
-		printk(KERN_CONT "IllegalLengthIndication ");
+		pr_cont("IllegalLengthIndication ");
 	if (err & ATAPI_EOM)
-		printk(KERN_CONT "EndOfMedia ");
+		pr_cont("EndOfMedia ");
 	if (err & ATA_ABORTED)
-		printk(KERN_CONT "AbortedCommand ");
+		pr_cont("AbortedCommand ");
 	if (err & ATA_MCR)
-		printk(KERN_CONT "MediaChangeRequested ");
+		pr_cont("MediaChangeRequested ");
 	if (err & ATAPI_LFS)
-		printk(KERN_CONT "LastFailedSense=0x%02x ",
+		pr_cont("LastFailedSense=0x%02x ",
 			(err & ATAPI_LFS) >> 4);
-	printk(KERN_CONT "}\n");
+	pr_cont("}\n");
 }
 
 /**
@@ -151,29 +151,29 @@ u8 ide_dump_status(ide_drive_t *drive, const char *msg, u8 stat)
 {
 	u8 err = 0;
 
-	printk(KERN_ERR "%s: %s: status=0x%02x { ", drive->name, msg, stat);
+	pr_err("%s: %s: status=0x%02x { ", drive->name, msg, stat);
 	if (stat & ATA_BUSY)
-		printk(KERN_CONT "Busy ");
+		pr_cont("Busy ");
 	else {
 		if (stat & ATA_DRDY)
-			printk(KERN_CONT "DriveReady ");
+			pr_cont("DriveReady ");
 		if (stat & ATA_DF)
-			printk(KERN_CONT "DeviceFault ");
+			pr_cont("DeviceFault ");
 		if (stat & ATA_DSC)
-			printk(KERN_CONT "SeekComplete ");
+			pr_cont("SeekComplete ");
 		if (stat & ATA_DRQ)
-			printk(KERN_CONT "DataRequest ");
+			pr_cont("DataRequest ");
 		if (stat & ATA_CORR)
-			printk(KERN_CONT "CorrectedError ");
+			pr_cont("CorrectedError ");
 		if (stat & ATA_IDX)
-			printk(KERN_CONT "Index ");
+			pr_cont("Index ");
 		if (stat & ATA_ERR)
-			printk(KERN_CONT "Error ");
+			pr_cont("Error ");
 	}
-	printk(KERN_CONT "}\n");
+	pr_cont("}\n");
 	if ((stat & (ATA_BUSY | ATA_ERR)) == ATA_ERR) {
 		err = ide_read_error(drive);
-		printk(KERN_ERR "%s: %s: error=0x%02x ", drive->name, msg, err);
+		pr_err("%s: %s: error=0x%02x ", drive->name, msg, err);
 		if (drive->media == ide_disk)
 			ide_dump_ata_error(drive, err);
 		else
diff --git a/drivers/ide/ide-pm.c b/drivers/ide/ide-pm.c
index 0d8a151..7402bb5 100644
--- a/drivers/ide/ide-pm.c
+++ b/drivers/ide/ide-pm.c
@@ -80,7 +80,7 @@ void ide_complete_power_step(ide_drive_t *drive, struct request *rq)
 	struct request_pm_state *pm = rq->data;
 
 #ifdef DEBUG_PM
-	printk(KERN_INFO "%s: complete_power_step(step: %d)\n",
+	pr_info("%s: complete_power_step(step: %d)\n",
 		drive->name, pm->pm_step);
 #endif
 	if (drive->media != ide_disk)
@@ -233,12 +233,12 @@ void ide_check_pm_state(ide_drive_t *drive, struct request *rq)
 #endif
 		rc = ide_wait_not_busy(hwif, 35000);
 		if (rc)
-			printk(KERN_WARNING "%s: bus not ready on wakeup\n", drive->name);
+			pr_warning("%s: bus not ready on wakeup\n", drive->name);
 		tp_ops->dev_select(drive);
 		tp_ops->write_devctl(hwif, ATA_DEVCTL_OBS);
 		rc = ide_wait_not_busy(hwif, 100000);
 		if (rc)
-			printk(KERN_WARNING "%s: drive not ready on wakeup\n", drive->name);
+			pr_warning("%s: drive not ready on wakeup\n", drive->name);
 
 		spin_lock_irqsave(q->queue_lock, flags);
 		blk_start_queue(q);
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 7f264ed..18c58c9 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -116,7 +116,7 @@ static void ide_classify_ata_dev(ide_drive_t *drive)
 	if (!ata_id_has_unload(drive->id))
 		drive->dev_flags |= IDE_DFLAG_NO_UNLOAD;
 
-	printk(KERN_INFO "%s: %s, %s DISK drive\n", drive->name, m,
+	pr_info("%s: %s, %s DISK drive\n", drive->name, m,
 		is_cfa ? "CFA" : "ATA");
 }
 
@@ -126,16 +126,16 @@ static void ide_classify_atapi_dev(ide_drive_t *drive)
 	char *m = (char *)&id[ATA_ID_PROD];
 	u8 type = (id[ATA_ID_CONFIG] >> 8) & 0x1f;
 
-	printk(KERN_INFO "%s: %s, ATAPI ", drive->name, m);
+	pr_info("%s: %s, ATAPI ", drive->name, m);
 	switch (type) {
 	case ide_floppy:
 		if (!strstr(m, "CD-ROM")) {
 			if (!strstr(m, "oppy") &&
 			    !strstr(m, "poyp") &&
 			    !strstr(m, "ZIP"))
-				printk(KERN_CONT "cdrom or floppy?, assuming ");
+				pr_cont("cdrom or floppy?, assuming ");
 			if (drive->media != ide_cdrom) {
-				printk(KERN_CONT "FLOPPY");
+				pr_cont("FLOPPY");
 				drive->dev_flags |= IDE_DFLAG_REMOVABLE;
 				break;
 			}
@@ -147,26 +147,26 @@ static void ide_classify_atapi_dev(ide_drive_t *drive)
 #ifdef CONFIG_PPC
 		/* kludge for Apple PowerBook internal zip */
 		if (!strstr(m, "CD-ROM") && strstr(m, "ZIP")) {
-			printk(KERN_CONT "FLOPPY");
+			pr_cont("FLOPPY");
 			type = ide_floppy;
 			break;
 		}
 #endif
-		printk(KERN_CONT "CD/DVD-ROM");
+		pr_cont("CD/DVD-ROM");
 		break;
 	case ide_tape:
-		printk(KERN_CONT "TAPE");
+		pr_cont("TAPE");
 		break;
 	case ide_optical:
-		printk(KERN_CONT "OPTICAL");
+		pr_cont("OPTICAL");
 		drive->dev_flags |= IDE_DFLAG_REMOVABLE;
 		break;
 	default:
-		printk(KERN_CONT "UNKNOWN (type %d)", type);
+		pr_cont("UNKNOWN (type %d)", type);
 		break;
 	}
 
-	printk(KERN_CONT " drive\n");
+	pr_cont(" drive\n");
 	drive->media = type;
 	/* an ATAPI device ignores DRDY */
 	drive->ready_stat = 0;
@@ -203,7 +203,7 @@ static void do_identify(ide_drive_t *drive, u8 cmd, u16 *id)
 
 	drive->dev_flags |= IDE_DFLAG_ID_READ;
 #ifdef DEBUG
-	printk(KERN_INFO "%s: dumping identify data\n", drive->name);
+	pr_info("%s: dumping identify data\n", drive->name);
 	ide_dump_identify((u8 *)id);
 #endif
 	ide_fix_driveid(id);
@@ -271,9 +271,9 @@ int ide_dev_read_id(ide_drive_t *drive, u8 cmd, u16 *id)
 		s = tp_ops->read_status(hwif);
 		if ((a ^ s) & ~ATA_IDX)
 			/* ancient Seagate drives, broken interfaces */
-			printk(KERN_INFO "%s: probing with STATUS(0x%02x) "
-					 "instead of ALTSTATUS(0x%02x)\n",
-					 drive->name, s, a);
+			pr_info("%s: probing with STATUS(0x%02x) "
+				"instead of ALTSTATUS(0x%02x)\n",
+				drive->name, s, a);
 		else
 			/* use non-intrusive polling */
 			use_altstatus = 1;
@@ -376,7 +376,7 @@ static int do_probe (ide_drive_t *drive, u8 cmd)
 		return 4;
 
 #ifdef DEBUG
-	printk(KERN_INFO "probing for %s: present=%d, media=%d, probetype=%s\n",
+	pr_info("probing for %s: present=%d, media=%d, probetype=%s\n",
 		drive->name, present, drive->media,
 		(cmd == ATA_CMD_ID_ATA) ? "ATA" : "ATAPI");
 #endif
@@ -414,8 +414,8 @@ static int do_probe (ide_drive_t *drive, u8 cmd)
 			return 4;
 
 		if (rc == 1 && cmd == ATA_CMD_ID_ATAPI) {
-			printk(KERN_ERR "%s: no response (status = 0x%02x), "
-					"resetting drive\n", drive->name, stat);
+			pr_err("%s: no response (status = 0x%02x), resetting drive\n",
+			       drive->name, stat);
 			msleep(50);
 			tp_ops->dev_select(drive);
 			msleep(50);
@@ -428,8 +428,8 @@ static int do_probe (ide_drive_t *drive, u8 cmd)
 		stat = tp_ops->read_status(hwif);
 
 		if (rc == 1)
-			printk(KERN_ERR "%s: no response (status = 0x%02x)\n",
-					drive->name, stat);
+			pr_err("%s: no response (status = 0x%02x)\n",
+			       drive->name, stat);
 	} else {
 		/* not present or maybe ATAPI */
 		rc = 3;
@@ -475,7 +475,7 @@ static u8 probe_for_drive(ide_drive_t *drive)
 
 	drive->id = kzalloc(SECTOR_SIZE, GFP_KERNEL);
 	if (drive->id == NULL) {
-		printk(KERN_ERR "ide: out of memory for id data.\n");
+		pr_err("ide: out of memory for id data.\n");
 		return 0;
 	}
 
@@ -499,14 +499,15 @@ static u8 probe_for_drive(ide_drive_t *drive)
 		/* identification failed? */
 		if ((drive->dev_flags & IDE_DFLAG_ID_READ) == 0) {
 			if (drive->media == ide_disk) {
-				printk(KERN_INFO "%s: non-IDE drive, CHS=%d/%d/%d\n",
+				pr_info("%s: non-IDE drive, CHS=%d/%d/%d\n",
 					drive->name, drive->cyl,
 					drive->head, drive->sect);
 			} else if (drive->media == ide_cdrom) {
-				printk(KERN_INFO "%s: ATAPI cdrom (?)\n", drive->name);
+				pr_info("%s: ATAPI cdrom (?)\n", drive->name);
 			} else {
 				/* nuke it */
-				printk(KERN_WARNING "%s: Unknown device on bus refused identification. Ignoring.\n", drive->name);
+				pr_warning("%s: Unknown device on bus refused identification. Ignoring.\n",
+					   drive->name);
 				drive->dev_flags &= ~IDE_DFLAG_PRESENT;
 			}
 		} else {
@@ -557,8 +558,8 @@ static int ide_register_port(ide_hwif_t *hwif)
 
 	ret = device_register(&hwif->gendev);
 	if (ret < 0) {
-		printk(KERN_WARNING "IDE: %s: device_register error: %d\n",
-			__func__, ret);
+		pr_warning("IDE: %s: device_register error: %d\n",
+			   __func__, ret);
 		goto out;
 	}
 
@@ -672,7 +673,7 @@ void ide_undecoded_slave(ide_drive_t *dev1)
 		return;
 
 	/* Appears to be an IDE flash adapter with decode bugs */
-	printk(KERN_WARNING "ide-probe: ignoring undecoded slave\n");
+	pr_warning("ide-probe: ignoring undecoded slave\n");
 
 	dev1->dev_flags &= ~IDE_DFLAG_PRESENT;
 }
@@ -812,8 +813,7 @@ static int ide_port_setup_devices(ide_hwif_t *hwif)
 	mutex_lock(&ide_cfg_mtx);
 	ide_port_for_each_present_dev(i, drive, hwif) {
 		if (ide_init_queue(drive)) {
-			printk(KERN_ERR "ide: failed to init %s\n",
-					drive->name);
+			pr_err("ide: failed to init %s\n", drive->name);
 			kfree(drive->id);
 			drive->id = NULL;
 			drive->dev_flags &= ~IDE_DFLAG_PRESENT;
@@ -847,16 +847,16 @@ static int init_irq (ide_hwif_t *hwif)
 		goto out_up;
 
 #if !defined(__mc68000__)
-	printk(KERN_INFO "%s at 0x%03lx-0x%03lx,0x%03lx on irq %d", hwif->name,
+	pr_info("%s at 0x%03lx-0x%03lx,0x%03lx on irq %d", hwif->name,
 		io_ports->data_addr, io_ports->status_addr,
 		io_ports->ctl_addr, hwif->irq);
 #else
-	printk(KERN_INFO "%s at 0x%08lx on irq %d", hwif->name,
+	pr_info("%s at 0x%08lx on irq %d", hwif->name,
 		io_ports->data_addr, hwif->irq);
 #endif /* __mc68000__ */
 	if (hwif->host->host_flags & IDE_HFLAG_SERIALIZE)
-		printk(KERN_CONT " (serialized)");
-	printk(KERN_CONT "\n");
+		pr_cont(" (serialized)");
+	pr_cont("\n");
 
 	return 0;
 out_up:
@@ -955,7 +955,7 @@ static void drive_release_dev (struct device *dev)
 static int hwif_init(ide_hwif_t *hwif)
 {
 	if (!hwif->irq) {
-		printk(KERN_ERR "%s: disabled, no IRQ\n", hwif->name);
+		pr_err("%s: disabled, no IRQ\n", hwif->name);
 		return 0;
 	}
 
@@ -968,15 +968,15 @@ static int hwif_init(ide_hwif_t *hwif)
 	hwif->sg_table = kmalloc(sizeof(struct scatterlist)*hwif->sg_max_nents,
 				 GFP_KERNEL);
 	if (!hwif->sg_table) {
-		printk(KERN_ERR "%s: unable to allocate SG table.\n", hwif->name);
+		pr_err("%s: unable to allocate SG table.\n", hwif->name);
 		goto out;
 	}
 
 	sg_init_table(hwif->sg_table, hwif->sg_max_nents);
 	
 	if (init_irq(hwif)) {
-		printk(KERN_ERR "%s: disabled, unable to get IRQ %d\n",
-			hwif->name, hwif->irq);
+		pr_err("%s: disabled, unable to get IRQ %d\n",
+		       hwif->name, hwif->irq);
 		goto out;
 	}
 
@@ -1006,8 +1006,8 @@ static void hwif_register_devices(ide_hwif_t *hwif)
 
 		ret = device_register(dev);
 		if (ret < 0)
-			printk(KERN_WARNING "IDE: %s: device_register error: "
-					    "%d\n", __func__, ret);
+			pr_warning("IDE: %s: device_register error: %d\n",
+				   __func__, ret);
 	}
 }
 
@@ -1071,7 +1071,7 @@ static void ide_init_port(ide_hwif_t *hwif, unsigned int port,
 			rc = ide_hwif_setup_dma(hwif, d);
 
 		if (rc < 0) {
-			printk(KERN_INFO "%s: DMA disabled\n", hwif->name);
+			pr_info("%s: DMA disabled\n", hwif->name);
 
 			hwif->dma_ops = NULL;
 			hwif->dma_base = 0;
@@ -1283,8 +1283,8 @@ struct ide_host *ide_host_alloc(const struct ide_port_info *d, hw_regs_t **hws)
 
 		idx = ide_find_port_slot(d);
 		if (idx < 0) {
-			printk(KERN_ERR "%s: no free slot for interface\n",
-					d ? d->name : "ide");
+			pr_err("%s: no free slot for interface\n",
+			       d ? d->name : "ide");
 			kfree(hwif);
 			continue;
 		}
@@ -1328,7 +1328,7 @@ static void ide_disable_port(ide_hwif_t *hwif)
 	struct ide_host *host = hwif->host;
 	int i;
 
-	printk(KERN_INFO "%s: disabling port\n", hwif->name);
+	pr_info("%s: disabling port\n", hwif->name);
 
 	for (i = 0; i < MAX_HOST_PORTS; i++) {
 		if (host->ports[i] == hwif) {
@@ -1391,8 +1391,8 @@ int ide_host_register(struct ide_host *host, const struct ide_port_info *d,
 			continue;
 
 		if (hwif_init(hwif) == 0) {
-			printk(KERN_INFO "%s: failed to initialize IDE "
-					 "interface\n", hwif->name);
+			pr_info("%s: failed to initialize IDE interface\n",
+				hwif->name);
 			device_unregister(&hwif->gendev);
 			ide_disable_port(hwif);
 			continue;
diff --git a/drivers/ide/ide-proc.c b/drivers/ide/ide-proc.c
index 3242698..0fa097e 100644
--- a/drivers/ide/ide-proc.c
+++ b/drivers/ide/ide-proc.c
@@ -241,8 +241,7 @@ static void proc_ide_settings_warn(void)
 	if (warned)
 		return;
 
-	printk(KERN_WARNING "Warning: /proc/ide/hd?/settings interface is "
-			    "obsolete, and will be removed soon!\n");
+	pr_warning("Warning: /proc/ide/hd?/settings interface is obsolete, and will be removed soon!\n");
 	warned = 1;
 }
 
@@ -464,15 +463,13 @@ static int ide_replace_subdriver(ide_drive_t *drive, const char *driver)
 	strlcpy(drive->driver_req, driver, sizeof(drive->driver_req));
 	err = device_attach(dev);
 	if (err < 0)
-		printk(KERN_WARNING "IDE: %s: device_attach error: %d\n",
-			__func__, err);
+		pr_warning("IDE: %s: device_attach error: %d\n", __func__, err);
 	drive->driver_req[0] = 0;
 	if (dev->driver == NULL) {
 		err = device_attach(dev);
 		if (err < 0)
-			printk(KERN_WARNING
-				"IDE: %s: device_attach(2) error: %d\n",
-				__func__, err);
+			pr_warning("IDE: %s: device_attach(2) error: %d\n",
+				   __func__, err);
 	}
 	if (dev->driver && !strcmp(dev->driver->name, driver))
 		ret = 0;
@@ -666,8 +663,8 @@ static int ide_drivers_show(struct seq_file *s, void *p)
 
 	err = bus_for_each_drv(&ide_bus_type, NULL, s, proc_print_driver);
 	if (err < 0)
-		printk(KERN_WARNING "IDE: %s: bus_for_each_drv error: %d\n",
-			__func__, err);
+		pr_warning("IDE: %s: bus_for_each_drv error: %d\n",
+			   __func__, err);
 	return 0;
 }
 
diff --git a/drivers/ide/ide-scan-pci.c b/drivers/ide/ide-scan-pci.c
index 0e79eff..84e791a 100644
--- a/drivers/ide/ide-scan-pci.c
+++ b/drivers/ide/ide-scan-pci.c
@@ -101,8 +101,8 @@ static int __init ide_scan_pcibus(void)
 		d = list_entry(l, struct pci_driver, node);
 		if (__pci_register_driver(d, d->driver.owner,
 					  d->driver.mod_name))
-			printk(KERN_ERR "%s: failed to register %s driver\n",
-					__func__, d->driver.mod_name);
+			pr_err("%s: failed to register %s driver\n",
+			       __func__, d->driver.mod_name);
 	}
 
 	return 0;
diff --git a/drivers/ide/ide-taskfile.c b/drivers/ide/ide-taskfile.c
index 4aa6223..baf0956 100644
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -86,7 +86,7 @@ ide_startstop_t do_rw_taskfile(ide_drive_t *drive, struct ide_cmd *orig_cmd)
 	if (orig_cmd->protocol == ATA_PROT_PIO &&
 	    (orig_cmd->tf_flags & IDE_TFLAG_MULTI_PIO) &&
 	    drive->mult_count == 0) {
-		printk(KERN_ERR "%s: multimode not set!\n", drive->name);
+		pr_err("%s: multimode not set!\n", drive->name);
 		return ide_stopped;
 	}
 
@@ -215,7 +215,7 @@ static u8 wait_drive_not_busy(ide_drive_t *drive)
 	}
 
 	if (stat & ATA_BUSY)
-		printk(KERN_ERR "%s: drive still BUSY!\n", drive->name);
+		pr_err("%s: drive still BUSY!\n", drive->name);
 
 	return stat;
 }
@@ -399,10 +399,10 @@ static ide_startstop_t pre_task_out_intr(ide_drive_t *drive,
 
 	if (ide_wait_stat(&startstop, drive, ATA_DRQ,
 			  drive->bad_wstat, WAIT_DRQ)) {
-		printk(KERN_ERR "%s: no DRQ after issuing %sWRITE%s\n",
-			drive->name,
-			(cmd->tf_flags & IDE_TFLAG_MULTI_PIO) ? "MULT" : "",
-			(drive->dev_flags & IDE_DFLAG_LBA48) ? "_EXT" : "");
+		pr_err("%s: no DRQ after issuing %sWRITE%s\n",
+		       drive->name,
+		       (cmd->tf_flags & IDE_TFLAG_MULTI_PIO) ? "MULT" : "",
+		       (drive->dev_flags & IDE_DFLAG_LBA48) ? "_EXT" : "");
 		return startstop;
 	}
 
@@ -576,9 +576,8 @@ int ide_taskfile_ioctl(ide_drive_t *drive, unsigned long arg)
 		case TASKFILE_MULTI_OUT:
 			if (!drive->mult_count) {
 				/* (hs): give up if multcount is not set */
-				printk(KERN_ERR "%s: %s Multimode Write " \
-					"multcount is not set\n",
-					drive->name, __func__);
+				pr_err("%s: %s Multimode Write multcount is not set\n",
+				       drive->name, __func__);
 				err = -EPERM;
 				goto abort;
 			}
@@ -596,9 +595,8 @@ int ide_taskfile_ioctl(ide_drive_t *drive, unsigned long arg)
 		case TASKFILE_MULTI_IN:
 			if (!drive->mult_count) {
 				/* (hs): give up if multcount is not set */
-				printk(KERN_ERR "%s: %s Multimode Read failure " \
-					"multcount is not set\n",
-					drive->name, __func__);
+				pr_err("%s: %s Multimode Read failure multcount is not set\n",
+				       drive->name, __func__);
 				err = -EPERM;
 				goto abort;
 			}
@@ -626,8 +624,8 @@ int ide_taskfile_ioctl(ide_drive_t *drive, unsigned long arg)
 		nsect = (cmd.hob.nsect << 8) | cmd.tf.nsect;
 
 		if (!nsect) {
-			printk(KERN_ERR "%s: in/out command without data\n",
-					drive->name);
+			pr_err("%s: in/out command without data\n",
+			       drive->name);
 			err = -EFAULT;
 			goto abort;
 		}
diff --git a/drivers/ide/ide-xfer-mode.c b/drivers/ide/ide-xfer-mode.c
index af44be9..03d8e14 100644
--- a/drivers/ide/ide-xfer-mode.c
+++ b/drivers/ide/ide-xfer-mode.c
@@ -70,7 +70,7 @@ u8 ide_get_best_pio_mode(ide_drive_t *drive, u8 mode_wanted, u8 max_mode)
 		pio_mode = ide_scan_pio_blacklist((char *)&id[ATA_ID_PROD]);
 
 	if (pio_mode != -1) {
-		printk(KERN_INFO "%s: is on PIO blacklist\n", drive->name);
+		pr_info("%s: is on PIO blacklist\n", drive->name);
 	} else {
 		pio_mode = id[ATA_ID_OLD_PIO_MODES] >> 8;
 		if (pio_mode > 2) {	/* 2 is maximum allowed tPIO value */
@@ -96,8 +96,8 @@ u8 ide_get_best_pio_mode(ide_drive_t *drive, u8 mode_wanted, u8 max_mode)
 		}
 
 		if (overridden)
-			printk(KERN_INFO "%s: tPIO > 2, assuming tPIO = 2\n",
-					 drive->name);
+			pr_info("%s: tPIO > 2, assuming tPIO = 2\n",
+				drive->name);
 	}
 
 	if (pio_mode > max_mode)
diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index 92c9b90..966c2da 100644
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -273,25 +273,23 @@ static void ide_dev_apply_params(ide_drive_t *drive, u8 unit)
 	int i = drive->hwif->index * MAX_DRIVES + unit;
 
 	if (ide_nodma & (1 << i)) {
-		printk(KERN_INFO "ide: disallowing DMA for %s\n", drive->name);
+		pr_info("ide: disallowing DMA for %s\n", drive->name);
 		drive->dev_flags |= IDE_DFLAG_NODMA;
 	}
 	if (ide_noflush & (1 << i)) {
-		printk(KERN_INFO "ide: disabling flush requests for %s\n",
-				 drive->name);
+		pr_info("ide: disabling flush requests for %s\n", drive->name);
 		drive->dev_flags |= IDE_DFLAG_NOFLUSH;
 	}
 	if (ide_noprobe & (1 << i)) {
-		printk(KERN_INFO "ide: skipping probe for %s\n", drive->name);
+		pr_info("ide: skipping probe for %s\n", drive->name);
 		drive->dev_flags |= IDE_DFLAG_NOPROBE;
 	}
 	if (ide_nowerr & (1 << i)) {
-		printk(KERN_INFO "ide: ignoring the ATA_DF bit for %s\n",
-				 drive->name);
+		pr_info("ide: ignoring the ATA_DF bit for %s\n", drive->name);
 		drive->bad_wstat = BAD_R_STAT;
 	}
 	if (ide_cdroms & (1 << i)) {
-		printk(KERN_INFO "ide: forcing %s as a CD-ROM\n", drive->name);
+		pr_info("ide: forcing %s as a CD-ROM\n", drive->name);
 		drive->dev_flags |= IDE_DFLAG_PRESENT;
 		drive->media = ide_cdrom;
 		/* an ATAPI device ignores DRDY */
@@ -302,9 +300,8 @@ static void ide_dev_apply_params(ide_drive_t *drive, u8 unit)
 		drive->head = drive->bios_head = ide_disks_chs[i].head;
 		drive->sect = drive->bios_sect = ide_disks_chs[i].sect;
 
-		printk(KERN_INFO "ide: forcing %s as a disk (%d/%d/%d)\n",
-				 drive->name,
-				 drive->cyl, drive->head, drive->sect);
+		pr_info("ide: forcing %s as a disk (%d/%d/%d)\n",
+			drive->name, drive->cyl, drive->head, drive->sect);
 
 		drive->dev_flags |= IDE_DFLAG_FORCED_GEOM | IDE_DFLAG_PRESENT;
 		drive->media = ide_disk;
@@ -343,8 +340,7 @@ void ide_port_apply_params(ide_hwif_t *hwif)
 	int i;
 
 	if (ide_ignore_cable & (1 << hwif->index)) {
-		printk(KERN_INFO "ide: ignoring cable detection for %s\n",
-				 hwif->name);
+		pr_info("ide: ignoring cable detection for %s\n", hwif->name);
 		hwif->cbl = ATA_CBL_PATA40_SHORT;
 	}
 
@@ -359,11 +355,11 @@ static int __init ide_init(void)
 {
 	int ret;
 
-	printk(KERN_INFO "Uniform Multi-Platform E-IDE driver\n");
+	pr_info("Uniform Multi-Platform E-IDE driver\n");
 
 	ret = bus_register(&ide_bus_type);
 	if (ret < 0) {
-		printk(KERN_WARNING "IDE: bus_register error: %d\n", ret);
+		pr_warning("IDE: bus_register error: %d\n", ret);
 		return ret;
 	}
 
diff --git a/drivers/ide/setup-pci.c b/drivers/ide/setup-pci.c
index 7a3a12d..42887b2 100644
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -39,18 +39,18 @@ static int ide_setup_pci_baseregs(struct pci_dev *dev, const char *name)
 	if (pci_read_config_byte(dev, PCI_CLASS_PROG, &progif) ||
 			 (progif & 5) != 5) {
 		if ((progif & 0xa) != 0xa) {
-			printk(KERN_INFO "%s %s: device not capable of full "
-				"native PCI mode\n", name, pci_name(dev));
+			pr_info("%s %s: device not capable of full native PCI mode\n",
+				name, pci_name(dev));
 			return -EOPNOTSUPP;
 		}
-		printk(KERN_INFO "%s %s: placing both ports into native PCI "
-			"mode\n", name, pci_name(dev));
+		pr_info("%s %s: placing both ports into native PCI mode\n",
+			name, pci_name(dev));
 		(void) pci_write_config_byte(dev, PCI_CLASS_PROG, progif|5);
 		if (pci_read_config_byte(dev, PCI_CLASS_PROG, &progif) ||
 		    (progif & 5) != 5) {
-			printk(KERN_ERR "%s %s: rewrite of PROGIF failed, "
-				"wanted 0x%04x, got 0x%04x\n",
-				name, pci_name(dev), progif | 5, progif);
+			pr_err("%s %s: rewrite of PROGIF failed, "
+			       "wanted 0x%04x, got 0x%04x\n",
+			       name, pci_name(dev), progif | 5, progif);
 			return -EOPNOTSUPP;
 		}
 	}
@@ -92,8 +92,8 @@ unsigned long ide_pci_dma_base(ide_hwif_t *hwif, const struct ide_port_info *d)
 		dma_base = pci_resource_start(dev, baridx);
 
 		if (dma_base == 0) {
-			printk(KERN_ERR "%s %s: DMA base is invalid\n",
-				d->name, pci_name(dev));
+			pr_err("%s %s: DMA base is invalid\n",
+			       d->name, pci_name(dev));
 			return 0;
 		}
 	}
@@ -115,7 +115,7 @@ int ide_pci_check_simplex(ide_hwif_t *hwif, const struct ide_port_info *d)
 
 	if (d->host_flags & IDE_HFLAG_CLEAR_SIMPLEX) {
 		if (ide_pci_clear_simplex(hwif->dma_base, d->name))
-			printk(KERN_INFO "%s %s: simplex device: DMA forced\n",
+			pr_info("%s %s: simplex device: DMA forced\n",
 				d->name, pci_name(dev));
 		goto out;
 	}
@@ -132,7 +132,7 @@ int ide_pci_check_simplex(ide_hwif_t *hwif, const struct ide_port_info *d)
 	 */
 	dma_stat = hwif->dma_ops->dma_sff_read_status(hwif);
 	if ((dma_stat & 0x80) && hwif->mate && hwif->mate->dma_base) {
-		printk(KERN_INFO "%s %s: simplex device: DMA disabled\n",
+		pr_info("%s %s: simplex device: DMA disabled\n",
 			d->name, pci_name(dev));
 		return -1;
 	}
@@ -155,8 +155,8 @@ int ide_pci_set_master(struct pci_dev *dev, const char *name)
 
 		if (pci_read_config_word(dev, PCI_COMMAND, &pcicmd) ||
 		    (pcicmd & PCI_COMMAND_MASTER) == 0) {
-			printk(KERN_ERR "%s %s: error updating PCICMD\n",
-				name, pci_name(dev));
+			pr_err("%s %s: error updating PCICMD\n",
+			       name, pci_name(dev));
 			return -EIO;
 		}
 	}
@@ -168,7 +168,7 @@ EXPORT_SYMBOL_GPL(ide_pci_set_master);
 
 void ide_setup_pci_noise(struct pci_dev *dev, const struct ide_port_info *d)
 {
-	printk(KERN_INFO "%s %s: IDE controller (0x%04x:0x%04x rev 0x%02x)\n",
+	pr_info("%s %s: IDE controller (0x%04x:0x%04x rev 0x%02x)\n",
 		d->name, pci_name(dev),
 		dev->vendor, dev->device, dev->revision);
 }
@@ -195,12 +195,12 @@ static int ide_pci_enable(struct pci_dev *dev, const struct ide_port_info *d)
 	if (pci_enable_device(dev)) {
 		ret = pci_enable_device_io(dev);
 		if (ret < 0) {
-			printk(KERN_WARNING "%s %s: couldn't enable device\n",
-				d->name, pci_name(dev));
+			pr_warning("%s %s: couldn't enable device\n",
+				   d->name, pci_name(dev));
 			goto out;
 		}
-		printk(KERN_WARNING "%s %s: BIOS configuration fixed\n",
-			d->name, pci_name(dev));
+		pr_warning("%s %s: BIOS configuration fixed\n",
+			   d->name, pci_name(dev));
 	}
 
 	/*
@@ -210,8 +210,7 @@ static int ide_pci_enable(struct pci_dev *dev, const struct ide_port_info *d)
 	 */
 	ret = pci_set_dma_mask(dev, DMA_BIT_MASK(32));
 	if (ret < 0) {
-		printk(KERN_ERR "%s %s: can't set DMA mask\n",
-			d->name, pci_name(dev));
+		pr_err("%s %s: can't set DMA mask\n", d->name, pci_name(dev));
 		goto out;
 	}
 
@@ -229,8 +228,8 @@ static int ide_pci_enable(struct pci_dev *dev, const struct ide_port_info *d)
 
 	ret = pci_request_selected_regions(dev, bars, d->name);
 	if (ret < 0)
-		printk(KERN_ERR "%s %s: can't reserve resources\n",
-			d->name, pci_name(dev));
+		pr_err("%s %s: can't reserve resources\n",
+		       d->name, pci_name(dev));
 out:
 	return ret;
 }
@@ -256,18 +255,18 @@ static int ide_pci_configure(struct pci_dev *dev, const struct ide_port_info *d)
 	 */
 	if (ide_setup_pci_baseregs(dev, d->name) ||
 	    pci_write_config_word(dev, PCI_COMMAND, pcicmd | PCI_COMMAND_IO)) {
-		printk(KERN_INFO "%s %s: device disabled (BIOS)\n",
+		pr_info("%s %s: device disabled (BIOS)\n",
 			d->name, pci_name(dev));
 		return -ENODEV;
 	}
 	if (pci_read_config_word(dev, PCI_COMMAND, &pcicmd)) {
-		printk(KERN_ERR "%s %s: error accessing PCI regs\n",
-			d->name, pci_name(dev));
+		pr_err("%s %s: error accessing PCI regs\n",
+		       d->name, pci_name(dev));
 		return -EIO;
 	}
 	if (!(pcicmd & PCI_COMMAND_IO)) {
-		printk(KERN_ERR "%s %s: unable to enable IDE controller\n",
-			d->name, pci_name(dev));
+		pr_err("%s %s: unable to enable IDE controller\n",
+		       d->name, pci_name(dev));
 		return -ENXIO;
 	}
 	return 0;
@@ -322,9 +321,8 @@ static int ide_hw_configure(struct pci_dev *dev, const struct ide_port_info *d,
 	if ((d->host_flags & IDE_HFLAG_ISA_PORTS) == 0) {
 		if (ide_pci_check_iomem(dev, d, 2 * port) ||
 		    ide_pci_check_iomem(dev, d, 2 * port + 1)) {
-			printk(KERN_ERR "%s %s: I/O baseregs (BIOS) are "
-				"reported as MEM for port %d!\n",
-				d->name, pci_name(dev), port);
+			pr_err("%s %s: I/O baseregs (BIOS) are reported as MEM for port %d!\n",
+			       d->name, pci_name(dev), port);
 			return -EINVAL;
 		}
 
@@ -337,8 +335,8 @@ static int ide_hw_configure(struct pci_dev *dev, const struct ide_port_info *d,
 	}
 
 	if (!base || !ctl) {
-		printk(KERN_ERR "%s %s: bad PCI BARs for port %d, skipping\n",
-			d->name, pci_name(dev), port);
+		pr_err("%s %s: bad PCI BARs for port %d, skipping\n",
+		       d->name, pci_name(dev), port);
 		return -EINVAL;
 	}
 
@@ -385,10 +383,10 @@ int ide_hwif_setup_dma(ide_hwif_t *hwif, const struct ide_port_info *d)
 			return -1;
 
 		if (hwif->host_flags & IDE_HFLAG_MMIO)
-			printk(KERN_INFO "    %s: MMIO-DMA\n", hwif->name);
+			pr_info("    %s: MMIO-DMA\n", hwif->name);
 		else
-			printk(KERN_INFO "    %s: BM-DMA at 0x%04lx-0x%04lx\n",
-					 hwif->name, base, base + 7);
+			pr_info("    %s: BM-DMA at 0x%04lx-0x%04lx\n",
+				hwif->name, base, base + 7);
 
 		hwif->extra_base = base + (hwif->channel ? 8 : 16);
 
@@ -426,15 +424,15 @@ static int ide_setup_pci_controller(struct pci_dev *dev,
 
 	ret = pci_read_config_word(dev, PCI_COMMAND, &pcicmd);
 	if (ret < 0) {
-		printk(KERN_ERR "%s %s: error accessing PCI regs\n",
-			d->name, pci_name(dev));
+		pr_err("%s %s: error accessing PCI regs\n",
+		       d->name, pci_name(dev));
 		goto out;
 	}
 	if (!(pcicmd & PCI_COMMAND_IO)) {	/* is device disabled? */
 		ret = ide_pci_configure(dev, d);
 		if (ret < 0)
 			goto out;
-		printk(KERN_INFO "%s %s: device enabled (Linux)\n",
+		pr_info("%s %s: device enabled (Linux)\n",
 			d->name, pci_name(dev));
 	}
 
@@ -473,7 +471,7 @@ void ide_pci_setup_ports(struct pci_dev *dev, const struct ide_port_info *d,
 
 		if (e->reg && (pci_read_config_byte(dev, e->reg, &tmp) ||
 		    (tmp & e->mask) != e->val)) {
-			printk(KERN_INFO "%s %s: IDE port disabled\n",
+			pr_info("%s %s: IDE port disabled\n",
 				d->name, pci_name(dev));
 			continue;	/* port not enabled */
 		}
@@ -519,14 +517,14 @@ static int do_ide_setup_pci_device(struct pci_dev *dev,
 
 	if (ide_pci_is_in_compatibility_mode(dev)) {
 		if (noisy)
-			printk(KERN_INFO "%s %s: not 100%% native mode: will "
-				"probe irqs later\n", d->name, pci_name(dev));
+			pr_info("%s %s: not 100%% native mode: will probe irqs later\n",
+				d->name, pci_name(dev));
 		pciirq = 0;
 	} else if (!pciirq && noisy) {
-		printk(KERN_WARNING "%s %s: bad irq (%d): will probe later\n",
-			d->name, pci_name(dev), pciirq);
+		pr_warning("%s %s: bad irq (%d): will probe later\n",
+			   d->name, pci_name(dev), pciirq);
 	} else if (noisy) {
-		printk(KERN_INFO "%s %s: 100%% native mode on irq %d\n",
+		pr_info("%s %s: 100%% native mode on irq %d\n",
 			d->name, pci_name(dev), pciirq);
 	}
 
-- 
1.6.3.1.10.g659a0.dirty

