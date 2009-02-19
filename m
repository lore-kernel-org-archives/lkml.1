Return-Path: <linux-kernel-owner+w=401wt.eu-S1754412AbZBSRiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412AbZBSRiU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 12:38:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752379AbZBSRiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 12:38:06 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:27259 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbZBSRiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 12:38:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=cHEi8wYH+H2mpDipKNMDkkhz7qVjDRXzkvMCwoAxI+p/hCk062nv1ufOMqBddsXVd4
         FqVzU4vzL0Y4bsf7K6Dj7zxl6hRECWedwCMeP8JibChAkDTxKl/yRisae6vZsWllAMl+
         J/SQM4PAe34oKKWeXHl3lw/+i0CbW0KXpMy7Q=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] ide: remove ide_execute_pkt_cmd() (v2)
Date: Thu, 19 Feb 2009 18:37:03 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-next-20090218; KDE/4.2.0; i686; ; )
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <petkovbb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902191837.04904.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: remove ide_execute_pkt_cmd() (v2)

* Pass command structure to ide_execute_command() and skip
  __ide_set_handler() for ATAPI protocols on non-DRQ devices.

* Convert ide_issue_pc() to always use ide_execute_command()
  and remove no longer needed ide_execute_pkt_cmd().

v2:
* Fix for non-DRQ devices (based on report from Borislav).

There should be no functional changes caused by this patch.

Acked-by: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
replacement patch for the one in pata-2.6 tree

 drivers/ide/ide-atapi.c    |   15 +++++++--------
 drivers/ide/ide-iops.c     |   25 ++++++++-----------------
 drivers/ide/ide-taskfile.c |    6 ++----
 include/linux/ide.h        |    5 ++---
 4 files changed, 19 insertions(+), 32 deletions(-)

Index: b/drivers/ide/ide-atapi.c
===================================================================
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -481,6 +481,7 @@ static void ide_init_packet_cmd(struct i
 	cmd->protocol  = dma ? ATAPI_PROT_DMA : ATAPI_PROT_PIO;
 	cmd->tf_flags |= IDE_TFLAG_OUT_LBAH | IDE_TFLAG_OUT_LBAM |
 			 IDE_TFLAG_OUT_FEATURE | tf_flags;
+	cmd->tf.command = ATA_CMD_PACKET;
 	cmd->tf.feature = dma;		/* Use PIO/DMA */
 	cmd->tf.lbam    = bcount & 0xff;
 	cmd->tf.lbah    = (bcount >> 8) & 0xff;
@@ -626,6 +627,7 @@ ide_startstop_t ide_issue_pc(ide_drive_t
 	unsigned int timeout;
 	u32 tf_flags;
 	u16 bcount;
+	u8 drq_int = !!(drive->atapi_flags & IDE_AFLAG_DRQ_INTERRUPT);
 
 	if (dev_is_idecd(drive)) {
 		tf_flags = IDE_TFLAG_OUT_NSECT | IDE_TFLAG_OUT_LBAL;
@@ -675,17 +677,14 @@ ide_startstop_t ide_issue_pc(ide_drive_t
 
 	(void)do_rw_taskfile(drive, cmd);
 
-	/* Issue the packet command */
-	if (drive->atapi_flags & IDE_AFLAG_DRQ_INTERRUPT) {
+	if (drq_int) {
 		if (drive->dma)
 			drive->waiting_for_dma = 0;
 		hwif->expiry = expiry;
-		ide_execute_command(drive, ATA_CMD_PACKET, ide_transfer_pc,
-				    timeout);
-		return ide_started;
-	} else {
-		ide_execute_pkt_cmd(drive);
-		return ide_transfer_pc(drive);
 	}
+
+	ide_execute_command(drive, cmd, ide_transfer_pc, timeout);
+
+	return drq_int ? ide_started : ide_transfer_pc(drive);
 }
 EXPORT_SYMBOL_GPL(ide_issue_pc);
Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -451,7 +451,7 @@ EXPORT_SYMBOL(ide_set_handler);
 /**
  *	ide_execute_command	-	execute an IDE command
  *	@drive: IDE drive to issue the command against
- *	@command: command byte to write
+ *	@cmd: command
  *	@handler: handler for next phase
  *	@timeout: timeout for command
  *
@@ -461,15 +461,18 @@ EXPORT_SYMBOL(ide_set_handler);
  *	should go via this function or do equivalent locking.
  */
 
-void ide_execute_command(ide_drive_t *drive, u8 cmd, ide_handler_t *handler,
-			 unsigned timeout)
+void ide_execute_command(ide_drive_t *drive, struct ide_cmd *cmd,
+			 ide_handler_t *handler, unsigned timeout)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	unsigned long flags;
 
 	spin_lock_irqsave(&hwif->lock, flags);
-	__ide_set_handler(drive, handler, timeout);
-	hwif->tp_ops->exec_command(hwif, cmd);
+	if ((cmd->protocol != ATAPI_PROT_DMA &&
+	     cmd->protocol != ATAPI_PROT_PIO) ||
+	    (drive->atapi_flags & IDE_AFLAG_DRQ_INTERRUPT))
+		__ide_set_handler(drive, handler, timeout);
+	hwif->tp_ops->exec_command(hwif, cmd->tf.command);
 	/*
 	 * Drive takes 400nS to respond, we must avoid the IRQ being
 	 * serviced before that.
@@ -480,18 +483,6 @@ void ide_execute_command(ide_drive_t *dr
 	spin_unlock_irqrestore(&hwif->lock, flags);
 }
 
-void ide_execute_pkt_cmd(ide_drive_t *drive)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	unsigned long flags;
-
-	spin_lock_irqsave(&hwif->lock, flags);
-	hwif->tp_ops->exec_command(hwif, ATA_CMD_PACKET);
-	ndelay(400);
-	spin_unlock_irqrestore(&hwif->lock, flags);
-}
-EXPORT_SYMBOL_GPL(ide_execute_pkt_cmd);
-
 /*
  * ide_wait_not_busy() waits for the currently selected device on the hwif
  * to report a non-busy status, see comments in ide_probe_port().
Index: b/drivers/ide/ide-taskfile.c
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -97,8 +97,7 @@ ide_startstop_t do_rw_taskfile(ide_drive
 	case ATA_PROT_NODATA:
 		if (handler == NULL)
 			handler = task_no_data_intr;
-		ide_execute_command(drive, tf->command, handler,
-				    WAIT_WORSTCASE);
+		ide_execute_command(drive, cmd, handler, WAIT_WORSTCASE);
 		return ide_started;
 	case ATA_PROT_DMA:
 		if ((drive->dev_flags & IDE_DFLAG_USING_DMA) == 0 ||
@@ -106,8 +105,7 @@ ide_startstop_t do_rw_taskfile(ide_drive
 		    dma_ops->dma_setup(drive, cmd))
 			return ide_stopped;
 		hwif->expiry = dma_ops->dma_timer_expiry;
-		ide_execute_command(drive, tf->command, ide_dma_intr,
-				    2 * WAIT_CMD);
+		ide_execute_command(drive, cmd, ide_dma_intr, 2 * WAIT_CMD);
 		dma_ops->dma_start(drive);
 	default:
 		return ide_started;
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1135,9 +1135,8 @@ void ide_kill_rq(ide_drive_t *, struct r
 void __ide_set_handler(ide_drive_t *, ide_handler_t *, unsigned int);
 void ide_set_handler(ide_drive_t *, ide_handler_t *, unsigned int);
 
-void ide_execute_command(ide_drive_t *, u8, ide_handler_t *, unsigned int);
-
-void ide_execute_pkt_cmd(ide_drive_t *);
+void ide_execute_command(ide_drive_t *, struct ide_cmd *, ide_handler_t *,
+			 unsigned int);
 
 void ide_pad_transfer(ide_drive_t *, int, int);
 
