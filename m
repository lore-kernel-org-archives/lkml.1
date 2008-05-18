Return-Path: <linux-kernel-owner+w=401wt.eu-S1759128AbYERSnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759128AbYERSnn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 14:43:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757128AbYERSjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 14:39:11 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:17569 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754098AbYERSjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 14:39:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=DyFVQzcF0v1nMWwkfyFnmCa94DnhDCFHLWNuk0ajZvEtdD+yYrb6NEJGBpuCATng489nTkUVT3QfJBGlXjKoPMeDd2b/CbMru5Thy8RXrG7yd7vaxaU5LPKNk8Q/M3Kzqdz8MolxIKHxP4ByZCGZfVH7pefMyfBWMyqRQPd8HHU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 18 May 2008 20:56:33 +0200
Message-Id: <20080518185633.5636.61364.sendpatchset@localhost.localdomain>
In-Reply-To: <20080518185428.5636.77234.sendpatchset@localhost.localdomain>
References: <20080518185428.5636.77234.sendpatchset@localhost.localdomain>
Subject: [PATCH 14/40] ide-floppy: merge idefloppy_transfer_pc() and idefloppy_transfer_pc1()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Check IDEFLOPPY_FLAG_ZIP_DRIVE flag in idefloppy_transfer_pc1()
  and skip idefloppy_transfer_pc2()-phase if the flag is not set.

* Always use idefloppy_transfer_pc1() in idefloppy_issue_pc()
  and remove no longer needed idefloppy_transfer_pc().

There should be no functional changes caused by this patch.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-floppy.c |   65 ++++++++++++-----------------------------------
 1 file changed, 17 insertions(+), 48 deletions(-)

Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -522,40 +522,6 @@ static ide_startstop_t idefloppy_pc_intr
 }
 
 /*
- * This is the original routine that did the packet transfer.
- * It fails at high speeds on the Iomega ZIP drive, so there's a slower version
- * for that drive below. The algorithm is chosen based on drive type
- */
-static ide_startstop_t idefloppy_transfer_pc(ide_drive_t *drive)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	ide_startstop_t startstop;
-	idefloppy_floppy_t *floppy = drive->driver_data;
-	u8 ireason;
-
-	if (ide_wait_stat(&startstop, drive, DRQ_STAT, BUSY_STAT, WAIT_READY)) {
-		printk(KERN_ERR "ide-floppy: Strange, packet command "
-				"initiated yet DRQ isn't asserted\n");
-		return startstop;
-	}
-	ireason = hwif->INB(hwif->io_ports.nsect_addr);
-	if ((ireason & CD) == 0 || (ireason & IO)) {
-		printk(KERN_ERR "ide-floppy: (IO,CoD) != (0,1) while "
-				"issuing a packet command\n");
-		return ide_do_reset(drive);
-	}
-
-	/* Set the interrupt routine */
-	ide_set_handler(drive, &idefloppy_pc_intr, IDEFLOPPY_WAIT_CMD, NULL);
-
-	/* Send the actual packet */
-	hwif->output_data(drive, NULL, floppy->pc->c, 12);
-
-	return ide_started;
-}
-
-
-/*
  * What we have here is a classic case of a top half / bottom half interrupt
  * service routine. In interrupt mode, the device sends an interrupt to signal
  * that it is ready to receive a packet. However, we need to delay about 2-3
@@ -580,6 +546,8 @@ static ide_startstop_t idefloppy_transfe
 {
 	ide_hwif_t *hwif = drive->hwif;
 	idefloppy_floppy_t *floppy = drive->driver_data;
+	ide_expiry_t *expiry;
+	unsigned int timeout;
 	ide_startstop_t startstop;
 	u8 ireason;
 
@@ -602,9 +570,20 @@ static ide_startstop_t idefloppy_transfe
 	 * 40 and 50msec work well. idefloppy_pc_intr will not be actually
 	 * used until after the packet is moved in about 50 msec.
 	 */
+	if (floppy->flags & IDEFLOPPY_FLAG_ZIP_DRIVE) {
+		timeout = floppy->ticks;
+		expiry = &idefloppy_transfer_pc2;
+	} else {
+		timeout = IDEFLOPPY_WAIT_CMD;
+		expiry = NULL;
+	}
+
+	ide_set_handler(drive, &idefloppy_pc_intr, timeout, expiry);
+
+	if ((floppy->flags & IDEFLOPPY_FLAG_ZIP_DRIVE) == 0)
+		/* Send the actual packet */
+		hwif->output_data(drive, NULL, floppy->pc->c, 12);
 
-	ide_set_handler(drive, &idefloppy_pc_intr, floppy->ticks,
-			&idefloppy_transfer_pc2);
 	return ide_started;
 }
 
@@ -629,7 +608,6 @@ static ide_startstop_t idefloppy_issue_p
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
 	ide_hwif_t *hwif = drive->hwif;
-	ide_handler_t *pkt_xfer_routine;
 	u16 bcount;
 	u8 dma;
 
@@ -675,26 +653,17 @@ static ide_startstop_t idefloppy_issue_p
 		hwif->dma_ops->dma_start(drive);
 	}
 
-	/* Can we transfer the packet when we get the interrupt or wait? */
-	if (floppy->flags & IDEFLOPPY_FLAG_ZIP_DRIVE) {
-		/* wait */
-		pkt_xfer_routine = &idefloppy_transfer_pc1;
-	} else {
-		/* immediate */
-		pkt_xfer_routine = &idefloppy_transfer_pc;
-	}
-
 	if (floppy->flags & IDEFLOPPY_FLAG_DRQ_INTERRUPT) {
 		/* Issue the packet command */
 		ide_execute_command(drive, WIN_PACKETCMD,
-				pkt_xfer_routine,
+				&idefloppy_transfer_pc1,
 				IDEFLOPPY_WAIT_CMD,
 				NULL);
 		return ide_started;
 	} else {
 		/* Issue the packet command */
 		ide_execute_pkt_cmd(drive);
-		return (*pkt_xfer_routine) (drive);
+		return idefloppy_transfer_pc1(drive);
 	}
 }
 
