Return-Path: <linux-kernel-owner+w=401wt.eu-S1761404AbXLTBvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761404AbXLTBvA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 20:51:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759424AbXLTBgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 20:36:46 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:12147 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756836AbXLTBex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 20:34:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Vwi7XAfwwFhseyFKwaMs0bngLBC8+UxiN4ztPkNeFLvX/XVZahzRMPo1Oky2Ek8KAOb7fZtypGFvRU9XA9S0YIU2aNHlWPdBJHiNWBxVp7a6rQKcz/gpiWCrSbB/qQPOFgKh2Lqp5doF7taugrXMG4SBkt3lNtVsVfZNH3xpcg4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 49/63] ide-cd: merge cdrom_pc_intr() and cdrom_newpc_intr()
Date: Thu, 20 Dec 2007 02:29:47 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712200229.47595.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add handling of REQ_TYPE_{SENSE,ATA_PC} requests to cdrom_newpc_intr()
(please note that these requests never have 'bio' attached to them
and they never use DMA), then remove no longer needed cdrom_pc_intr().

There should be no functionality changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
-264 bytes
 drivers/ide/ide-cd.c |  159 +++++++++++++++++----------------------------------
 1 file changed, 55 insertions(+), 104 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1061,90 +1061,7 @@ static void ide_cd_request_sense_fixup(s
 		}
 }
 
-/* Interrupt routine for packet command completion. */
-static ide_startstop_t cdrom_pc_intr (ide_drive_t *drive)
-{
-	struct request *rq = HWGROUP(drive)->rq;
-	xfer_func_t *xferfunc = NULL;
-	int stat, ireason, len, thislen, write, update;
-	u8 lowcyl = 0, highcyl = 0;
-
-	/* Check for errors. */
-	if (cdrom_decode_status(drive, 0, &stat))
-		return ide_stopped;
-
-	/* Read the interrupt reason and the transfer length. */
-	ireason = HWIF(drive)->INB(IDE_IREASON_REG) & 0x3;
-	lowcyl  = HWIF(drive)->INB(IDE_BCOUNTL_REG);
-	highcyl = HWIF(drive)->INB(IDE_BCOUNTH_REG);
-
-	len = lowcyl + (256 * highcyl);
-
-	/* If DRQ is clear, the command has completed.
-	   Complain if we still have data left to transfer. */
-	if ((stat & DRQ_STAT) == 0) {
-		ide_cd_request_sense_fixup(rq);
-		update = rq->data_len ? 0 : 1;
-		goto end_request;
-	}
-
-	/* Figure out how much data to transfer. */
-	thislen = rq->data_len;
-	if (thislen > len)
-		thislen = len;
-
-	if (ireason == 0) {
-		write = 1;
-		xferfunc = HWIF(drive)->atapi_output_bytes;
-	} else if (ireason == 2) {
-		write = 0;
-		xferfunc = HWIF(drive)->atapi_input_bytes;
-	}
-
-	if (xferfunc) {
-		if (!rq->data) {
-			printk(KERN_ERR "%s: confused, missing data\n",
-					drive->name);
-			blk_dump_rq_flags(rq, write ? "cdrom_pc_intr, write"
-						    : "cdrom_pc_intr, read");
-			goto pad;
-		}
-		/* Transfer the data. */
-		xferfunc(drive, rq->data, thislen);
-
-		/* Keep count of how much data we've moved. */
-		len -= thislen;
-		rq->data += thislen;
-		rq->data_len -= thislen;
-
-		if (write && blk_sense_request(rq))
-			rq->sense_len += thislen;
-	} else {
-		printk (KERN_ERR "%s: cdrom_pc_intr: The drive "
-			"appears confused (ireason = 0x%02x). "
-			"Trying to recover by ending request.\n",
-			drive->name, ireason);
-		update = 0;
-		goto end_request;
-	}
-pad:
-	/*
-	 * If we haven't moved enough data to satisfy the drive,
-	 * add some padding.
-	 */
-	if (len > 0)
-		ide_cd_pad_transfer(drive, xferfunc, len);
-
-	/* Now we wait for another interrupt. */
-	ide_set_handler(drive, &cdrom_pc_intr, ATAPI_WAIT_PC, cdrom_timer_expiry);
-	return ide_started;
-
-end_request:
-	if (!update)
-		rq->cmd_flags |= REQ_FAILED;
-	cdrom_end_request(drive, update);
-	return ide_stopped;
-}
+static ide_startstop_t cdrom_newpc_intr(ide_drive_t *);
 
 static ide_startstop_t cdrom_do_pc_continuation (ide_drive_t *drive)
 {
@@ -1154,10 +1071,9 @@ static ide_startstop_t cdrom_do_pc_conti
 		rq->timeout = ATAPI_WAIT_PC;
 
 	/* Send the command to the drive and return. */
-	return cdrom_transfer_packet_command(drive, rq, &cdrom_pc_intr);
+	return cdrom_transfer_packet_command(drive, rq, cdrom_newpc_intr);
 }
 
-
 static ide_startstop_t cdrom_do_packet_command (ide_drive_t *drive)
 {
 	int len;
@@ -1252,27 +1168,27 @@ static int cdrom_write_check_ireason(ide
 /*
  * best way to deal with dma that is not sector aligned right now... note
  * that in this path we are not using ->data or ->buffer at all. this irs
- * can replace cdrom_pc_intr, cdrom_read_intr, and cdrom_write_intr in the
- * future.
+ * can replace cdrom_read_intr() and cdrom_write_intr() in the future.
  */
 static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 {
 	struct cdrom_info *info = drive->driver_data;
 	struct request *rq = HWGROUP(drive)->rq;
-	int dma_error, dma, stat, ireason, len, thislen;
-	u8 lowcyl, highcyl;
 	xfer_func_t *xferfunc;
-	unsigned long flags;
+	ide_expiry_t *expiry;
+	int dma_error = 0, dma, stat, ireason, len, thislen, uptodate = 0;
+	int write = (rq_data_dir(rq) == WRITE) ? 1 : 0;
+	unsigned int timeout;
+	u8 lowcyl, highcyl;
 
 	/* Check for errors. */
-	dma_error = 0;
 	dma = info->dma;
 	if (dma) {
 		info->dma = 0;
 		dma_error = HWIF(drive)->ide_dma_end(drive);
 		if (dma_error) {
 			printk(KERN_ERR "%s: DMA %s error\n", drive->name,
-					rq_data_dir(rq) ? "write" : "read");
+					write ? "write" : "read");
 			ide_dma_off(drive);
 		}
 	}
@@ -1307,28 +1223,44 @@ static ide_startstop_t cdrom_newpc_intr(
 	/*
 	 * If DRQ is clear, the command has completed.
 	 */
-	if ((stat & DRQ_STAT) == 0)
+	if ((stat & DRQ_STAT) == 0) {
+		if (!blk_pc_request(rq)) {
+			ide_cd_request_sense_fixup(rq);
+			/* Complain if we still have data left to transfer. */
+			uptodate = rq->data_len ? 0 : 1;
+		}
 		goto end_request;
+	}
 
 	/*
 	 * check which way to transfer data
 	 */
-	if (rq_data_dir(rq) == WRITE) {
+	if (blk_pc_request(rq) && rq_data_dir(rq) == WRITE) {
 		/*
 		 * write to drive
 		 */
 		if (cdrom_write_check_ireason(drive, len, ireason))
 			return ide_stopped;
-
-		xferfunc = HWIF(drive)->atapi_output_bytes;
-	} else  {
+	} else if (blk_pc_request(rq)) {
 		/*
 		 * read from drive
 		 */
 		if (cdrom_read_check_ireason(drive, len, ireason))
 			return ide_stopped;
+	}
 
+	if (ireason == 0) {
+		write = 1;
+		xferfunc = HWIF(drive)->atapi_output_bytes;
+	} else if (ireason == 2 || (ireason == 1 && blk_pc_request(rq))) {
+		write = 0;
 		xferfunc = HWIF(drive)->atapi_input_bytes;
+	} else {
+		printk(KERN_ERR "%s: %s: The drive "
+				"appears confused (ireason = 0x%02x). "
+				"Trying to recover by ending request.\n",
+				drive->name, __FUNCTION__, ireason);
+		goto end_request;
 	}
 
 	/*
@@ -1370,21 +1302,40 @@ static ide_startstop_t cdrom_newpc_intr(
 			rq->data += blen;
 	}
 
+	if (write && blk_sense_request(rq))
+		rq->sense_len += thislen;
+
 	/*
 	 * pad, if necessary
 	 */
 	if (len > 0)
 		ide_cd_pad_transfer(drive, xferfunc, len);
 
-	ide_set_handler(drive, cdrom_newpc_intr, rq->timeout, NULL);
+	if (blk_pc_request(rq)) {
+		timeout = rq->timeout;
+		expiry = NULL;
+	} else {
+		timeout = ATAPI_WAIT_PC;
+		expiry = cdrom_timer_expiry;
+	}
+
+	ide_set_handler(drive, cdrom_newpc_intr, timeout, expiry);
 	return ide_started;
 
 end_request:
-	spin_lock_irqsave(&ide_lock, flags);
-	blkdev_dequeue_request(rq);
-	end_that_request_last(rq, 1);
-	HWGROUP(drive)->rq = NULL;
-	spin_unlock_irqrestore(&ide_lock, flags);
+	if (blk_pc_request(rq)) {
+		unsigned long flags;
+
+		spin_lock_irqsave(&ide_lock, flags);
+		blkdev_dequeue_request(rq);
+		end_that_request_last(rq, 1);
+		HWGROUP(drive)->rq = NULL;
+		spin_unlock_irqrestore(&ide_lock, flags);
+	} else {
+		if (!uptodate)
+			rq->cmd_flags |= REQ_FAILED;
+		cdrom_end_request(drive, uptodate);
+	}
 	return ide_stopped;
 }
 
