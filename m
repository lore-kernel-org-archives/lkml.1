Return-Path: <linux-kernel-owner+w=401wt.eu-S1759214AbZBBVid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759214AbZBBVid (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 16:38:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758625AbZBBVhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 16:37:17 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:63868 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754567AbZBBVhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 16:37:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=YyXLF9AbFc+rp1B8CVrbiAfpHtU8IbisGvrmL1Do+PlLXqq1hnRa2OcJ2mDevr4a1B
         jJSYpeXmGoLXfoAWdodY7pZ1utEjuCM41qPBIkPrQaygIzvL10kDqLIjW+GmzN06D2Nm
         B4WZbxXzSlE1no8HJtvn5CB9eA2Ep3nM2hD78=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 02 Feb 2009 22:38:08 +0100
Message-Id: <20090202213808.17960.38620.sendpatchset@localhost.localdomain>
In-Reply-To: <20090202213707.17960.61897.sendpatchset@localhost.localdomain>
References: <20090202213707.17960.61897.sendpatchset@localhost.localdomain>
Subject: [PATCH 08/14] ide: merge task_{in,out}_intr()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: merge task_{in,out}_intr()

* Merge task_out_intr() with task_in_intr().

* Rename task_in_intr() to task_pio_intr().

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-taskfile.c |   72 +++++++++++++++++++--------------------------
 1 file changed, 31 insertions(+), 41 deletions(-)

Index: b/drivers/ide/ide-taskfile.c
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -55,7 +55,7 @@ int taskfile_lib_get_identify (ide_drive
 
 static ide_startstop_t task_no_data_intr(ide_drive_t *);
 static ide_startstop_t pre_task_out_intr(ide_drive_t *, struct ide_cmd *);
-static ide_startstop_t task_in_intr(ide_drive_t *);
+static ide_startstop_t task_pio_intr(ide_drive_t *);
 
 ide_startstop_t do_rw_taskfile(ide_drive_t *drive, struct ide_cmd *orig_cmd)
 {
@@ -92,7 +92,7 @@ ide_startstop_t do_rw_taskfile(ide_drive
 			ndelay(400);	/* FIXME */
 			return pre_task_out_intr(drive, cmd);
 		}
-		handler = task_in_intr;
+		handler = task_pio_intr;
 		/* fall-through */
 	case ATA_PROT_NODATA:
 		if (handler == NULL)
@@ -325,68 +325,57 @@ static ide_startstop_t task_in_unexpecte
 	}
 
 	/* Assume it was a spurious irq */
-	ide_set_handler(drive, &task_in_intr, WAIT_WORSTCASE, NULL);
+	ide_set_handler(drive, &task_pio_intr, WAIT_WORSTCASE, NULL);
+
 	return ide_started;
 }
 
 /*
- * Handler for command with PIO data-in phase (Read/Read Multiple).
+ * Handler for command with PIO data phase.
  */
-static ide_startstop_t task_in_intr(ide_drive_t *drive)
+static ide_startstop_t task_pio_intr(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct ide_cmd *cmd = &drive->hwif->cmd;
 	u8 stat = hwif->tp_ops->read_status(hwif);
+	u8 write = !!(cmd->tf_flags & IDE_TFLAG_WRITE);
 
-	/* Error? */
-	if (stat & ATA_ERR)
-		return task_error(drive, cmd, __func__, stat);
-
-	/* Didn't want any data? Odd. */
-	if ((stat & ATA_DRQ) == 0)
-		return task_in_unexpected(drive, cmd, stat);
+	if (write == 0) {
+		/* Error? */
+		if (stat & ATA_ERR)
+			return task_error(drive, cmd, __func__, stat);
 
-	ide_pio_datablock(drive, cmd, 0);
+		/* Didn't want any data? Odd. */
+		if ((stat & ATA_DRQ) == 0)
+			return task_in_unexpected(drive, cmd, stat);
+	} else {
+		if (!OK_STAT(stat, DRIVE_READY, drive->bad_wstat))
+			return task_error(drive, cmd, __func__, stat);
 
-	/* Are we done? Check status and finish transfer. */
-	if (cmd->nleft == 0) {
-		stat = wait_drive_not_busy(drive);
-		if (!OK_STAT(stat, 0, BAD_STAT))
+		/* Deal with unexpected ATA data phase. */
+		if (((stat & ATA_DRQ) == 0) ^ (cmd->nleft == 0))
 			return task_error(drive, cmd, __func__, stat);
+	}
+
+	if (write && cmd->nleft == 0) {
 		ide_finish_cmd(drive, cmd, stat);
 		return ide_stopped;
 	}
 
 	/* Still data left to transfer. */
-	ide_set_handler(drive, &task_in_intr, WAIT_WORSTCASE, NULL);
+	ide_pio_datablock(drive, cmd, write);
 
-	return ide_started;
-}
-
-/*
- * Handler for command with PIO data-out phase (Write/Write Multiple).
- */
-static ide_startstop_t task_out_intr (ide_drive_t *drive)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	struct ide_cmd *cmd = &drive->hwif->cmd;
-	u8 stat = hwif->tp_ops->read_status(hwif);
-
-	if (!OK_STAT(stat, DRIVE_READY, drive->bad_wstat))
-		return task_error(drive, cmd, __func__, stat);
-
-	/* Deal with unexpected ATA data phase. */
-	if (((stat & ATA_DRQ) == 0) ^ (cmd->nleft == 0))
-		return task_error(drive, cmd, __func__, stat);
-
-	if (cmd->nleft == 0) {
+	/* Are we done? Check status and finish transfer. */
+	if (write == 0 && cmd->nleft == 0) {
+		stat = wait_drive_not_busy(drive);
+		if (!OK_STAT(stat, 0, BAD_STAT))
+			return task_error(drive, cmd, __func__, stat);
 		ide_finish_cmd(drive, cmd, stat);
 		return ide_stopped;
 	}
 
 	/* Still data left to transfer. */
-	ide_pio_datablock(drive, cmd, 1);
-	ide_set_handler(drive, &task_out_intr, WAIT_WORSTCASE, NULL);
+	ide_set_handler(drive, &task_pio_intr, WAIT_WORSTCASE, NULL);
 
 	return ide_started;
 }
@@ -408,7 +397,8 @@ static ide_startstop_t pre_task_out_intr
 	if ((drive->dev_flags & IDE_DFLAG_UNMASK) == 0)
 		local_irq_disable();
 
-	ide_set_handler(drive, &task_out_intr, WAIT_WORSTCASE, NULL);
+	ide_set_handler(drive, &task_pio_intr, WAIT_WORSTCASE, NULL);
+
 	ide_pio_datablock(drive, cmd, 1);
 
 	return ide_started;
