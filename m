Return-Path: <linux-kernel-owner+w=401wt.eu-S1752956AbYLZNy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956AbYLZNy1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 08:54:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752090AbYLZNyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 08:54:17 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:45036 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077AbYLZNyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 08:54:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent:from;
        b=Nr9TOYFe33BnfBFPAhFEqptgSsjgyQn9PgtOOekxfLYGMiA9HTfmkWld/KWI3GcKJm
         am31JqpghLGN9ra+nh3Y6sboeKwkHfJx+uSzh1UGehDqUd+Gh8TOCFh9k2+lPyK+zFHI
         l1fjsIMru8FKDDFhaQu7MkU6WATppBqk1fzws=
Date: Fri, 26 Dec 2008 14:46:53 +0100
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 0/8] ide-cd: first conversion batch
Message-ID: <20081226134653.GC23503@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1229586052-3542-1-git-send-email-petkovbb@gmail.com> <200812192115.41068.bzolnier@gmail.com> <20081220062849.GA14770@gollum.tnic> <200812212005.56973.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812212005.56973.bzolnier@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <petkovbb@gmail.com>
Date: Fri, 26 Dec 2008 14:39:54 +0100
Subject: [PATCH 11/11] ide-cd: convert to ide-atapi facilities

... and remove no longer needed cdrom_start_packet_command and
cdrom_transfer_packet_command.

Tested lightly with ide-cd and ide-floppy.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-atapi.c |    5 ++-
 drivers/ide/ide-cd.c    |   96 +----------------------------------------------
 include/linux/ide.h     |    2 +
 3 files changed, 8 insertions(+), 95 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index d6a50d6..e96c012 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -549,7 +549,10 @@ static ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
 	}
 
 	/* Set the interrupt routine */
-	ide_set_handler(drive, ide_pc_intr, timeout, expiry);
+	ide_set_handler(drive,
+			(dev_is_idecd(drive) ? drive->irq_handler
+					     : ide_pc_intr),
+			timeout, expiry);
 
 	/* Begin DMA, if necessary */
 	if (dev_is_idecd(drive)) {
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 2cb301d..cae6937 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -510,99 +510,6 @@ end_request:
 	return 1;
 }
 
-static ide_startstop_t cdrom_transfer_packet_command(ide_drive_t *);
-static ide_startstop_t cdrom_newpc_intr(ide_drive_t *);
-
-/*
- * Set up the device registers for transferring a packet command on DEV,
- * expecting to later transfer XFERLEN bytes.  HANDLER is the routine
- * which actually transfers the command to the drive.  If this is a
- * drq_interrupt device, this routine will arrange for HANDLER to be
- * called when the interrupt from the drive arrives.  Otherwise, HANDLER
- * will be called immediately after the drive is prepared for the transfer.
- */
-static ide_startstop_t cdrom_start_packet_command(ide_drive_t *drive)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	struct request *rq = hwif->rq;
-	int xferlen;
-
-	xferlen = ide_cd_get_xferlen(rq);
-
-	ide_debug_log(IDE_DBG_PC, "Call %s, xferlen: %d\n", __func__, xferlen);
-
-	/* FIXME: for Virtual DMA we must check harder */
-	if (drive->dma)
-		drive->dma = !hwif->dma_ops->dma_setup(drive);
-
-	/* set up the controller registers */
-	ide_pktcmd_tf_load(drive, IDE_TFLAG_OUT_NSECT | IDE_TFLAG_OUT_LBAL,
-			   xferlen, drive->dma);
-
-	if (drive->atapi_flags & IDE_AFLAG_DRQ_INTERRUPT) {
-		/* waiting for CDB interrupt, not DMA yet. */
-		if (drive->dma)
-			drive->waiting_for_dma = 0;
-
-		/* packet command */
-		ide_execute_command(drive, ATA_CMD_PACKET,
-				    cdrom_transfer_packet_command,
-				    ATAPI_WAIT_PC, ide_cd_expiry);
-		return ide_started;
-	} else {
-		ide_execute_pkt_cmd(drive);
-
-		return cdrom_transfer_packet_command(drive);
-	}
-}
-
-/*
- * Send a packet command to DRIVE described by CMD_BUF and CMD_LEN. The device
- * registers must have already been prepared by cdrom_start_packet_command.
- * HANDLER is the interrupt handler to call when the command completes or
- * there's data ready.
- */
-#define ATAPI_MIN_CDB_BYTES 12
-static ide_startstop_t cdrom_transfer_packet_command(ide_drive_t *drive)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	struct request *rq = hwif->rq;
-	int cmd_len;
-	ide_startstop_t startstop;
-
-	ide_debug_log(IDE_DBG_PC, "Call %s\n", __func__);
-
-	/* we must wait for DRQ to get set */
-	if (ide_wait_stat(&startstop, drive, ATA_DRQ, ATA_BUSY, WAIT_READY)) {
-		printk(KERN_ERR "%s: timeout while waiting for DRQ to assert\n",
-				drive->name);
-		return startstop;
-	}
-
-	if (drive->atapi_flags & IDE_AFLAG_DRQ_INTERRUPT) {
-		/* ok, next interrupt will be DMA interrupt */
-		if (drive->dma)
-			drive->waiting_for_dma = 1;
-	}
-
-	/* arm the interrupt handler */
-	ide_set_handler(drive, cdrom_newpc_intr, rq->timeout, ide_cd_expiry);
-
-	/* ATAPI commands get padded out to 12 bytes minimum */
-	cmd_len = COMMAND_SIZE(rq->cmd[0]);
-	if (cmd_len < ATAPI_MIN_CDB_BYTES)
-		cmd_len = ATAPI_MIN_CDB_BYTES;
-
-	/* start the DMA if need be */
-	if (drive->dma)
-		hwif->dma_ops->dma_start(drive);
-
-	/* send the command to the device */
-	hwif->tp_ops->output_data(drive, NULL, rq->cmd, cmd_len);
-
-	return ide_started;
-}
-
 /*
  * Check the contents of the interrupt reason register from the cdrom
  * and attempt to recover if there are problems.  Returns  0 if everything's
@@ -1174,7 +1081,7 @@ static ide_startstop_t ide_cd_do_request(ide_drive_t *drive, struct request *rq,
 		return ide_stopped;
 	}
 
-	return cdrom_start_packet_command(drive);
+	return ide_issue_pc(drive);
 }
 
 /*
@@ -2072,6 +1979,7 @@ static int ide_cd_probe(ide_drive_t *drive)
 	}
 
 	drive->debug_mask = debug_mask;
+	drive->irq_handler = cdrom_newpc_intr;
 
 	info = kzalloc(sizeof(struct cdrom_info), GFP_KERNEL);
 	if (info == NULL) {
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 9f6fe1f..1cb460f 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -654,6 +654,8 @@ struct ide_drive_s {
 	int  (*pc_io_buffers)(struct ide_drive_s *, struct ide_atapi_pc *,
 			      unsigned int, int);
 
+	ide_startstop_t (*irq_handler)(struct ide_drive_s *);
+
 	unsigned long atapi_flags;
 
 	struct ide_atapi_pc request_sense_pc;
-- 
1.6.0.4

-- 
Regards/Gruss,
    Boris.
