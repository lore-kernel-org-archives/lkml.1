Return-Path: <linux-kernel-owner+w=401wt.eu-S1757436AbYERStm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757436AbYERStm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 14:49:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757782AbYERSlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 14:41:44 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:17236 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757264AbYERSlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 14:41:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=fojadfxdKiivKOolCa2UaZtif7F3Cs28A1u9TAHvLju9ed47+ipr2wq8/IolLersAnKoz0Mi44iM/5nSYEshQA1yzcgpQKOZc/d6AjIxWko9AWTI3DtVBiC+MRIgnDBlPzHT2iL+4mVDMRfAVupOSwhHj7Xvh1cuI7lP7L3ZWjk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 18 May 2008 20:59:06 +0200
Message-Id: <20080518185906.5636.53076.sendpatchset@localhost.localdomain>
In-Reply-To: <20080518185428.5636.77234.sendpatchset@localhost.localdomain>
References: <20080518185428.5636.77234.sendpatchset@localhost.localdomain>
Subject: [PATCH 31/40] ide: add ide_issue_pc() helper
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add generic ide_issue_pc() helper to ide-atapi.c and then
convert ide-{floppy,tape,scsi} device drivers to use it.

There should be no functional changes caused by this patch.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-atapi.c  |   49 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/ide/ide-floppy.c |   37 ++---------------------------------
 drivers/ide/ide-tape.c   |   32 ++----------------------------
 drivers/scsi/ide-scsi.c  |   32 ++----------------------------
 include/linux/ide.h      |    2 +
 5 files changed, 60 insertions(+), 92 deletions(-)

Index: b/drivers/ide/ide-atapi.c
===================================================================
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -68,3 +68,52 @@ ide_startstop_t ide_transfer_pc(ide_driv
 	return ide_started;
 }
 EXPORT_SYMBOL_GPL(ide_transfer_pc);
+
+ide_startstop_t ide_issue_pc(ide_drive_t *drive, struct ide_atapi_pc *pc,
+			     ide_handler_t *handler, unsigned int timeout,
+			     ide_expiry_t *expiry)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	u16 bcount;
+	u8 dma = 0;
+
+	/* We haven't transferred any data yet */
+	pc->xferred = 0;
+	pc->cur_pos = pc->buf;
+
+	/* Request to transfer the entire buffer at once */
+	if (drive->media == ide_tape && !drive->scsi)
+		bcount = pc->req_xfer;
+	else
+		bcount = min(pc->req_xfer, 63 * 1024);
+
+	if (pc->flags & PC_FLAG_DMA_ERROR) {
+		pc->flags &= ~PC_FLAG_DMA_ERROR;
+		ide_dma_off(drive);
+	}
+
+	if ((pc->flags & PC_FLAG_DMA_OK) && drive->using_dma) {
+		if (drive->scsi)
+			hwif->sg_mapped = 1;
+		dma = !hwif->dma_ops->dma_setup(drive);
+		if (drive->scsi)
+			hwif->sg_mapped = 0;
+	}
+
+	if (!dma)
+		pc->flags &= ~PC_FLAG_DMA_OK;
+
+	ide_pktcmd_tf_load(drive, drive->scsi ? 0 : IDE_TFLAG_OUT_DEVICE,
+			   bcount, dma);
+
+	/* Issue the packet command */
+	if (pc->flags & PC_FLAG_DRQ_INTERRUPT) {
+		ide_execute_command(drive, WIN_PACKETCMD, handler,
+				    timeout, NULL);
+		return ide_started;
+	} else {
+		ide_execute_pkt_cmd(drive);
+		return (*handler)(drive);
+	}
+}
+EXPORT_SYMBOL_GPL(ide_issue_pc);
Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -576,9 +576,6 @@ static ide_startstop_t idefloppy_issue_p
 		struct ide_atapi_pc *pc)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
-	ide_hwif_t *hwif = drive->hwif;
-	u16 bcount;
-	u8 dma;
 
 	if (floppy->failed_pc == NULL &&
 	    pc->c[0] != GPCMD_REQUEST_SENSE)
@@ -600,37 +597,9 @@ static ide_startstop_t idefloppy_issue_p
 	debug_log("Retry number - %d\n", pc->retries);
 
 	pc->retries++;
-	/* We haven't transferred any data yet */
-	pc->xferred = 0;
-	pc->cur_pos = pc->buf;
-	bcount = min(pc->req_xfer, 63 * 1024);
-
-	if (pc->flags & PC_FLAG_DMA_ERROR) {
-		pc->flags &= ~PC_FLAG_DMA_ERROR;
-		ide_dma_off(drive);
-	}
-	dma = 0;
-
-	if ((pc->flags & PC_FLAG_DMA_OK) && drive->using_dma)
-		dma = !hwif->dma_ops->dma_setup(drive);
-
-	if (!dma)
-		pc->flags &= ~PC_FLAG_DMA_OK;
-
-	ide_pktcmd_tf_load(drive, IDE_TFLAG_OUT_DEVICE, bcount, dma);
-
-	if (pc->flags & PC_FLAG_DRQ_INTERRUPT) {
-		/* Issue the packet command */
-		ide_execute_command(drive, WIN_PACKETCMD,
-				&idefloppy_transfer_pc1,
-				IDEFLOPPY_WAIT_CMD,
-				NULL);
-		return ide_started;
-	} else {
-		/* Issue the packet command */
-		ide_execute_pkt_cmd(drive);
-		return idefloppy_transfer_pc1(drive);
-	}
+
+	return ide_issue_pc(drive, pc, idefloppy_transfer_pc1,
+			    IDEFLOPPY_WAIT_CMD, NULL);
 }
 
 static void idefloppy_create_prevent_cmd(struct ide_atapi_pc *pc, int prevent)
Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -958,10 +958,7 @@ static ide_startstop_t idetape_transfer_
 static ide_startstop_t idetape_issue_pc(ide_drive_t *drive,
 		struct ide_atapi_pc *pc)
 {
-	ide_hwif_t *hwif = drive->hwif;
 	idetape_tape_t *tape = drive->driver_data;
-	int dma_ok = 0;
-	u16 bcount;
 
 	if (tape->pc->c[0] == REQUEST_SENSE &&
 	    pc->c[0] == REQUEST_SENSE) {
@@ -1002,32 +999,9 @@ static ide_startstop_t idetape_issue_pc(
 	debug_log(DBG_SENSE, "Retry #%d, cmd = %02X\n", pc->retries, pc->c[0]);
 
 	pc->retries++;
-	/* We haven't transferred any data yet */
-	pc->xferred = 0;
-	pc->cur_pos = pc->buf;
-	/* Request to transfer the entire buffer at once */
-	bcount = pc->req_xfer;
-
-	if (pc->flags & PC_FLAG_DMA_ERROR) {
-		pc->flags &= ~PC_FLAG_DMA_ERROR;
-		ide_dma_off(drive);
-	}
-	if ((pc->flags & PC_FLAG_DMA_OK) && drive->using_dma)
-		dma_ok = !hwif->dma_ops->dma_setup(drive);
-
-	if (!dma_ok)
-		pc->flags &= ~PC_FLAG_DMA_OK;
-
-	ide_pktcmd_tf_load(drive, IDE_TFLAG_OUT_DEVICE, bcount, dma_ok);
-
-	if (pc->flags & PC_FLAG_DRQ_INTERRUPT) {
-		ide_execute_command(drive, WIN_PACKETCMD, &idetape_transfer_pc,
-				    IDETAPE_WAIT_CMD, NULL);
-		return ide_started;
-	} else {
-		ide_execute_pkt_cmd(drive);
-		return idetape_transfer_pc(drive);
-	}
+
+	return ide_issue_pc(drive, pc, idetape_transfer_pc,
+			    IDETAPE_WAIT_CMD, NULL);
 }
 
 /* A mode sense command is used to "sense" tape parameters. */
Index: b/drivers/scsi/ide-scsi.c
===================================================================
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -502,38 +502,12 @@ static ide_startstop_t idescsi_issue_pc(
 		struct ide_atapi_pc *pc)
 {
 	idescsi_scsi_t *scsi = drive_to_idescsi(drive);
-	ide_hwif_t *hwif = drive->hwif;
-	u16 bcount;
-	u8 dma = 0;
 
 	/* Set the current packet command */
 	scsi->pc = pc;
-	/* We haven't transferred any data yet */
-	pc->xferred = 0;
-	pc->cur_pos = pc->buf;
-	/* Request to transfer the entire buffer at once */
-	bcount = min(pc->req_xfer, 63 * 1024);
-
-	if ((pc->flags & PC_FLAG_DMA_OK) && drive->using_dma) {
-		hwif->sg_mapped = 1;
-		dma = !hwif->dma_ops->dma_setup(drive);
-		hwif->sg_mapped = 0;
-	}
-
-	if (!dma)
-		pc->flags &= ~PC_FLAG_DMA_OK;
-
-	ide_pktcmd_tf_load(drive, 0, bcount, dma);
-
-	if (pc->flags & PC_FLAG_DRQ_INTERRUPT) {
-		ide_execute_command(drive, WIN_PACKETCMD, &idescsi_transfer_pc,
-				    get_timeout(pc), idescsi_expiry);
-		return ide_started;
-	} else {
-		/* Issue the packet command */
-		ide_execute_pkt_cmd(drive);
-		return idescsi_transfer_pc(drive);
-	}
+
+	return ide_issue_pc(drive, pc, idescsi_transfer_pc,
+			    get_timeout(pc), idescsi_expiry);
 }
 
 /*
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -955,6 +955,8 @@ void ide_pktcmd_tf_load(ide_drive_t *, u
 
 ide_startstop_t ide_transfer_pc(ide_drive_t *, struct ide_atapi_pc *,
 				ide_handler_t *, unsigned int, ide_expiry_t *);
+ide_startstop_t ide_issue_pc(ide_drive_t *, struct ide_atapi_pc *,
+			     ide_handler_t *, unsigned int, ide_expiry_t *);
 
 ide_startstop_t do_rw_taskfile(ide_drive_t *, ide_task_t *);
 
