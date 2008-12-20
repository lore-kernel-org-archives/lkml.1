Return-Path: <linux-kernel-owner+w=401wt.eu-S1753367AbYLTG3B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367AbYLTG3B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 01:29:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752120AbYLTG2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 01:28:50 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:57764 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041AbYLTG2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 01:28:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent:from;
        b=M2XvceCZJ/VkTPQzMVb7iK3ie2pZwPHJVXlXmWtV54ShsXjQJz79hWZDufo/f3EKyC
         M5LUrrFLHE5jRuvNSz/ugNvKPbf3QSU+H9PQEzEwe135NnM6Soe6Cubhruy0MsZfDK2O
         ieBH1p5HjV0S4286LFkDOaq7eifecukhFqNsg=
Date: Sat, 20 Dec 2008 07:28:49 +0100
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 0/8] ide-cd: first conversion batch
Message-ID: <20081220062849.GA14770@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1229586052-3542-1-git-send-email-petkovbb@gmail.com> <200812192115.41068.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812192115.41068.bzolnier@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Dec 19, 2008 at 09:15:40PM +0100, Bartlomiej Zolnierkiewicz wrote:

[.. ]

> Yes, we don't want to move them over.  In worst case we can add
> ide_handler_t *__old_pc_handler to ide_drive_t and set it in ide-cd
> (an acceptable hack this time) but there might be better options.

Ok, here's the final patch moving ide-cd to the services of
ide_(issue|transfer)_pc. The only change in functionality is that we
don't do cdrom_decode_status for DRQ_INTERRUPT devices but this is
probably not that relevant anymore since we busy-wait for DRQ to get set
through ide_wait_stat, as we talked about it before - it being a bugfix for
all atapi devices. If there's still interest for that (and I think it
could be of use to have an all-atapi function ide_decode_status() that
dumps error messages if DRQ doesn't get set based on the sense_key) I'll
add cook something up.

--
From: Borislav Petkov <petkovbb@gmail.com>
Date: Sat, 20 Dec 2008 07:06:48 +0100
Subject: [PATCH 9/9] ide-cd: convert to ide-atapi facilities

... and remove no longer needed cdrom_start_packet_command and
cdrom_transfer_packet_command.

Tested lightly with ide-cd and ide-floppy.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-atapi.c |    6 ++-
 drivers/ide/ide-cd.c    |  102 +----------------------------------------------
 include/linux/ide.h     |    2 +
 3 files changed, 9 insertions(+), 101 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index 5b92e0a..0e96da5 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -550,7 +550,10 @@ static ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
 	}
 
 	/* Set the interrupt routine */
-	ide_set_handler(drive, ide_pc_intr, timeout, expiry);
+	ide_set_handler(drive,
+			(dev_is_idecd(drive) ? drive->irq_handler
+					     : ide_pc_intr),
+			timeout, expiry);
 
 	/* Begin DMA, if necessary */
 	if (dev_is_idecd(drive)) {
@@ -580,6 +583,7 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive)
 	u16 bcount;
 
 	if (dev_is_idecd(drive)) {
+
 		tf_flags = IDE_TFLAG_OUT_NSECT | IDE_TFLAG_OUT_LBAL;
 		bcount = ide_cd_get_xferlen(hwif->hwgroup->rq);
 		expiry = ide_cd_expiry;
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index f3c7cc3..b6087a2 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -511,105 +511,6 @@ end_request:
 	return 1;
 }
 
-static ide_startstop_t cdrom_newpc_intr(ide_drive_t *);
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
-	struct request *rq = hwif->hwgroup->rq;
-	int cmd_len;
-	ide_startstop_t startstop;
-
-	ide_debug_log(IDE_DBG_PC, "Call %s\n", __func__);
-
-	if (drive->atapi_flags & IDE_AFLAG_DRQ_INTERRUPT) {
-		/*
-		 * Here we should have been called after receiving an interrupt
-		 * from the device.  DRQ should how be set.
-		 */
-
-		/* check for errors */
-		if (cdrom_decode_status(drive, ATA_DRQ, NULL))
-			return ide_stopped;
-
-		/* ok, next interrupt will be DMA interrupt */
-		if (drive->dma)
-			drive->waiting_for_dma = 1;
-	} else {
-		/* otherwise, we must wait for DRQ to get set */
-		if (ide_wait_stat(&startstop, drive, ATA_DRQ,
-				  ATA_BUSY, WAIT_READY))
-			return startstop;
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
-	/* send the command to the device */
-	hwif->tp_ops->output_data(drive, NULL, rq->cmd, cmd_len);
-
-	/* start the DMA if need be */
-	if (drive->dma)
-		hwif->dma_ops->dma_start(drive);
-
-	return ide_started;
-}
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
-	struct request *rq = hwif->hwgroup->rq;
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
 /*
  * Check the contents of the interrupt reason register from the cdrom
  * and attempt to recover if there are problems.  Returns  0 if everything's
@@ -1185,7 +1086,7 @@ static ide_startstop_t ide_cd_do_request(ide_drive_t *drive, struct request *rq,
 		return ide_stopped;
 	}
 
-	return cdrom_start_packet_command(drive);
+	return ide_issue_pc(drive);
 }
 
 /*
@@ -2084,6 +1985,7 @@ static int ide_cd_probe(ide_drive_t *drive)
 	}
 
 	drive->debug_mask = debug_mask;
+	drive->irq_handler = cdrom_newpc_intr;
 
 	info = kzalloc(sizeof(struct cdrom_info), GFP_KERNEL);
 	if (info == NULL) {
diff --git a/include/linux/ide.h b/include/linux/ide.h
index db5ef8a..2fa5539 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -662,6 +662,8 @@ struct ide_drive_s {
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
