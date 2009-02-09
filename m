Return-Path: <linux-kernel-owner+w=401wt.eu-S1756227AbZBIXTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227AbZBIXTd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 18:19:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755468AbZBIXSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 18:18:48 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:23002 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755284AbZBIXSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 18:18:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=jKds7PuaGBX+UBHKsAydhaTxI48y0wSesD2awXu71CXvCmRX4eKbKaz8D2yoHNvabz
         lxwVa6gXl8hFahrUbIkN2QcmpLvqc1B3xEgNzo/90EUoqHYb8S1c/0VjoQ5t63fN3VQY
         nMCkpYOnXGGRC1VSqs1NztkRY7WE8MRNktYbE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 10 Feb 2009 00:19:58 +0100
Message-Id: <20090209231958.32406.59196.sendpatchset@localhost.localdomain>
In-Reply-To: <20090209231945.32406.14874.sendpatchset@localhost.localdomain>
References: <20090209231945.32406.14874.sendpatchset@localhost.localdomain>
Subject: [PATCH 2/6] ide: use do_rw_taskfile() for ATA_CMD_PACKET commands
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: use do_rw_taskfile() for ATA_CMD_PACKET commands

* Pass command to ide_issue_pc() and update ->do_request methods
  in ide-{cd,floppy,tape}.c accordingly.

* Convert ide_pktcmd_tf_load() to ide_init_packet_cmd() which
  just initializes command structure and use do_rw_taskfile()
  to load ATA_CMD_PACKET commands.

While at it:

* Rename ide{floppy,tape}_issue_pc() to ide_{floppy,tape}_issue_pc().

There should be no functional changes caused by this patch.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-atapi.c    |   37 ++++++++++++-------------------------
 drivers/ide/ide-cd.c       |   11 ++++++++++-
 drivers/ide/ide-floppy.c   |   24 ++++++++++++++----------
 drivers/ide/ide-tape.c     |   19 ++++++++++++++-----
 drivers/ide/ide-taskfile.c |    3 ++-
 include/linux/ide.h        |    2 +-
 6 files changed, 53 insertions(+), 43 deletions(-)

Index: b/drivers/ide/ide-atapi.c
===================================================================
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -475,23 +475,15 @@ next_irq:
 	return ide_started;
 }
 
-static void ide_pktcmd_tf_load(ide_drive_t *drive, u32 tf_flags, u16 bcount)
+static void ide_init_packet_cmd(struct ide_cmd *cmd, u32 tf_flags,
+				u16 bcount, u8 dma)
 {
-	ide_hwif_t *hwif = drive->hwif;
-	struct ide_cmd cmd;
-	u8 dma = drive->dma;
-
-	memset(&cmd, 0, sizeof(cmd));
-	cmd.tf_flags = IDE_TFLAG_OUT_LBAH | IDE_TFLAG_OUT_LBAM |
-		       IDE_TFLAG_OUT_FEATURE | tf_flags;
-	cmd.tf.feature = dma;		/* Use PIO/DMA */
-	cmd.tf.lbam    = bcount & 0xff;
-	cmd.tf.lbah    = (bcount >> 8) & 0xff;
-
-	ide_tf_dump(drive->name, &cmd.tf);
-	hwif->tp_ops->set_irq(hwif, 1);
-	SELECT_MASK(drive, 0);
-	hwif->tp_ops->tf_load(drive, &cmd);
+	cmd->protocol  = dma ? ATAPI_PROT_DMA : ATAPI_PROT_PIO;
+	cmd->tf_flags |= IDE_TFLAG_OUT_LBAH | IDE_TFLAG_OUT_LBAM |
+			 IDE_TFLAG_OUT_FEATURE | tf_flags;
+	cmd->tf.feature = dma;		/* Use PIO/DMA */
+	cmd->tf.lbam    = bcount & 0xff;
+	cmd->tf.lbah    = (bcount >> 8) & 0xff;
 }
 
 static u8 ide_read_ireason(ide_drive_t *drive)
@@ -622,24 +614,17 @@ static ide_startstop_t ide_transfer_pc(i
 	return ide_started;
 }
 
-ide_startstop_t ide_issue_pc(ide_drive_t *drive)
+ide_startstop_t ide_issue_pc(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	struct ide_atapi_pc *pc;
 	ide_hwif_t *hwif = drive->hwif;
 	const struct ide_dma_ops *dma_ops = hwif->dma_ops;
-	struct ide_cmd *cmd = &hwif->cmd;
 	ide_expiry_t *expiry = NULL;
 	struct request *rq = hwif->rq;
 	unsigned int timeout;
 	u32 tf_flags;
 	u16 bcount;
 
-	if (drive->media != ide_floppy) {
-		if (rq_data_dir(rq))
-			cmd->tf_flags |= IDE_TFLAG_WRITE;
-		cmd->rq = rq;
-	}
-
 	if (dev_is_idecd(drive)) {
 		tf_flags = IDE_TFLAG_OUT_NSECT | IDE_TFLAG_OUT_LBAL;
 		bcount = ide_cd_get_xferlen(rq);
@@ -684,7 +669,9 @@ ide_startstop_t ide_issue_pc(ide_drive_t
 						       : WAIT_TAPE_CMD;
 	}
 
-	ide_pktcmd_tf_load(drive, tf_flags, bcount);
+	ide_init_packet_cmd(cmd, tf_flags, bcount, drive->dma);
+
+	(void)do_rw_taskfile(drive, cmd);
 
 	/* Issue the packet command */
 	if (drive->atapi_flags & IDE_AFLAG_DRQ_INTERRUPT) {
Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1060,6 +1060,8 @@ static void cdrom_do_block_pc(ide_drive_
 static ide_startstop_t ide_cd_do_request(ide_drive_t *drive, struct request *rq,
 					sector_t block)
 {
+	struct ide_cmd cmd;
+
 	ide_debug_log(IDE_DBG_RQ, "cmd: 0x%x, block: %llu",
 				  rq->cmd[0], (unsigned long long)block);
 
@@ -1088,7 +1090,14 @@ static ide_startstop_t ide_cd_do_request
 		return ide_stopped;
 	}
 
-	return ide_issue_pc(drive);
+	memset(&cmd, 0, sizeof(cmd));
+
+	if (rq_data_dir(rq))
+		cmd.tf_flags |= IDE_TFLAG_WRITE;
+
+	cmd.rq = rq;
+
+	return ide_issue_pc(drive, &cmd);
 }
 
 /*
Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -130,8 +130,9 @@ static void ide_floppy_report_error(stru
 
 }
 
-static ide_startstop_t idefloppy_issue_pc(ide_drive_t *drive,
-		struct ide_atapi_pc *pc)
+static ide_startstop_t ide_floppy_issue_pc(ide_drive_t *drive,
+					   struct ide_cmd *cmd,
+					   struct ide_atapi_pc *pc)
 {
 	struct ide_disk_obj *floppy = drive->driver_data;
 
@@ -157,7 +158,7 @@ static ide_startstop_t idefloppy_issue_p
 
 	pc->retries++;
 
-	return ide_issue_pc(drive);
+	return ide_issue_pc(drive, cmd);
 }
 
 void ide_floppy_create_read_capacity_cmd(struct ide_atapi_pc *pc)
@@ -244,7 +245,7 @@ static ide_startstop_t ide_floppy_do_req
 {
 	struct ide_disk_obj *floppy = drive->driver_data;
 	ide_hwif_t *hwif = drive->hwif;
-	struct ide_cmd *cmd = &hwif->cmd;
+	struct ide_cmd cmd;
 	struct ide_atapi_pc *pc;
 
 	if (drive->debug_mask & IDE_DBG_RQ)
@@ -285,19 +286,22 @@ static ide_startstop_t ide_floppy_do_req
 		goto out_end;
 	}
 
+	memset(&cmd, 0, sizeof(cmd));
+
 	if (rq_data_dir(rq))
-		cmd->tf_flags |= IDE_TFLAG_WRITE;
-	cmd->rq = rq;
+		cmd.tf_flags |= IDE_TFLAG_WRITE;
+
+	cmd.rq = rq;
 
-	ide_init_sg_cmd(cmd, rq->nr_sectors);
-	ide_map_sg(drive, cmd);
+	ide_init_sg_cmd(&cmd, rq->nr_sectors);
+	ide_map_sg(drive, &cmd);
 
 	pc->sg = hwif->sg_table;
-	pc->sg_cnt = cmd->sg_nents;
+	pc->sg_cnt = cmd.sg_nents;
 
 	pc->rq = rq;
 
-	return idefloppy_issue_pc(drive, pc);
+	return ide_floppy_issue_pc(drive, &cmd, pc);
 out_end:
 	drive->failed_pc = NULL;
 	if (blk_fs_request(rq) == 0 && rq->errors == 0)
Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -580,7 +580,7 @@ static int ide_tape_io_buffers(ide_drive
  *
  * The handling will be done in three stages:
  *
- * 1. idetape_issue_pc will send the packet command to the drive, and will set
+ * 1. ide_tape_issue_pc will send the packet command to the drive, and will set
  * the interrupt handler to ide_pc_intr.
  *
  * 2. On each interrupt, ide_pc_intr will be called. This step will be
@@ -608,8 +608,9 @@ static int ide_tape_io_buffers(ide_drive
  * request.
  */
 
-static ide_startstop_t idetape_issue_pc(ide_drive_t *drive,
-		struct ide_atapi_pc *pc)
+static ide_startstop_t ide_tape_issue_pc(ide_drive_t *drive,
+					 struct ide_cmd *cmd,
+					 struct ide_atapi_pc *pc)
 {
 	idetape_tape_t *tape = drive->driver_data;
 
@@ -654,7 +655,7 @@ static ide_startstop_t idetape_issue_pc(
 
 	pc->retries++;
 
-	return ide_issue_pc(drive);
+	return ide_issue_pc(drive, cmd);
 }
 
 /* A mode sense command is used to "sense" tape parameters. */
@@ -749,6 +750,7 @@ static ide_startstop_t idetape_do_reques
 	idetape_tape_t *tape = drive->driver_data;
 	struct ide_atapi_pc *pc = NULL;
 	struct request *postponed_rq = tape->postponed_rq;
+	struct ide_cmd cmd;
 	u8 stat;
 
 	debug_log(DBG_SENSE, "sector: %llu, nr_sectors: %lu,"
@@ -844,7 +846,14 @@ static ide_startstop_t idetape_do_reques
 	BUG();
 
 out:
-	return idetape_issue_pc(drive, pc);
+	memset(&cmd, 0, sizeof(cmd));
+
+	if (rq_data_dir(rq))
+		cmd.tf_flags |= IDE_TFLAG_WRITE;
+
+	cmd.rq = rq;
+
+	return ide_tape_issue_pc(drive, &cmd, pc);
 }
 
 /*
Index: b/drivers/ide/ide-taskfile.c
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -100,13 +100,14 @@ ide_startstop_t do_rw_taskfile(ide_drive
 		ide_execute_command(drive, tf->command, handler,
 				    WAIT_WORSTCASE, NULL);
 		return ide_started;
-	default:
+	case ATA_PROT_DMA:
 		if ((drive->dev_flags & IDE_DFLAG_USING_DMA) == 0 ||
 		    ide_build_sglist(drive, cmd) == 0 ||
 		    dma_ops->dma_setup(drive, cmd))
 			return ide_stopped;
 		dma_ops->dma_exec_cmd(drive, tf->command);
 		dma_ops->dma_start(drive);
+	default:
 		return ide_started;
 	}
 }
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1223,7 +1223,7 @@ int ide_cd_expiry(ide_drive_t *);
 
 int ide_cd_get_xferlen(struct request *);
 
-ide_startstop_t ide_issue_pc(ide_drive_t *);
+ide_startstop_t ide_issue_pc(ide_drive_t *, struct ide_cmd *);
 
 ide_startstop_t do_rw_taskfile(ide_drive_t *, struct ide_cmd *);
 
