Return-Path: <linux-kernel-owner+w=401wt.eu-S932447AbXLTBs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932447AbXLTBs0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 20:48:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758133AbXLTBgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 20:36:16 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:11752 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756730AbXLTBe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 20:34:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=AoSdMiXTwcudKP8JvzghIO5UTObsHH8r3tk2433dadZYSH57607PtAFBNIN+RNlE1sOnciQEjakaG+R7yPhfav9z4WLBG38AZPq17hThoP4Ml4du1Zqr62ODsedhg8kmZ5Icmd30cAwM0JF4JRph/4KPCLbu4/kxBtL/yleyLbc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 54/63] ide-cd: merge cdrom_read_intr() and cdrom_write_intr()
Date: Thu, 20 Dec 2007 02:33:36 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712200233.36211.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add handling of read requests to cdrom_write_intr(), rename it
to cdrom_rw_intr() and remove no longer needed cdrom_read_intr().

There should be no functionality changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
-368 bytes
 drivers/ide/ide-cd.c |  207 +++++++++++++++++----------------------------------
 1 file changed, 69 insertions(+), 138 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -739,125 +739,6 @@ static int ide_cd_check_transfer_size(id
 }
 
 /*
- * Interrupt routine.  Called when a read request has completed.
- */
-static ide_startstop_t cdrom_read_intr (ide_drive_t *drive)
-{
-	int stat;
-	int ireason, len, sectors_to_transfer, nskip;
-	struct cdrom_info *info = drive->driver_data;
-	u8 lowcyl = 0, highcyl = 0;
-	int dma = info->dma, dma_error = 0;
-
-	struct request *rq = HWGROUP(drive)->rq;
-
-	/*
-	 * handle dma case
-	 */
-	if (dma) {
-		info->dma = 0;
-		dma_error = HWIF(drive)->ide_dma_end(drive);
-		if (dma_error) {
-			printk(KERN_ERR "%s: DMA read error\n", drive->name);
-			ide_dma_off(drive);
-		}
-	}
-
-	if (cdrom_decode_status(drive, 0, &stat))
-		return ide_stopped;
-
-	if (dma) {
-		if (!dma_error) {
-			ide_end_request(drive, 1, rq->nr_sectors);
-			return ide_stopped;
-		} else
-			return ide_error(drive, "dma error", stat);
-	}
-
-	/* Read the interrupt reason and the transfer length. */
-	ireason = HWIF(drive)->INB(IDE_IREASON_REG) & 0x3;
-	lowcyl  = HWIF(drive)->INB(IDE_BCOUNTL_REG);
-	highcyl = HWIF(drive)->INB(IDE_BCOUNTH_REG);
-
-	len = lowcyl + (256 * highcyl);
-
-	/* If DRQ is clear, the command has completed. */
-	if ((stat & DRQ_STAT) == 0) {
-		/* If we're not done filling the current buffer, complain.
-		   Otherwise, complete the command normally. */
-		if (rq->current_nr_sectors > 0) {
-			printk (KERN_ERR "%s: cdrom_read_intr: data underrun (%d blocks)\n",
-				drive->name, rq->current_nr_sectors);
-			rq->cmd_flags |= REQ_FAILED;
-			cdrom_end_request(drive, 0);
-		} else
-			cdrom_end_request(drive, 1);
-		return ide_stopped;
-	}
-
-	/* Check that the drive is expecting to do the same thing we are. */
-	if (cdrom_read_check_ireason (drive, len, ireason))
-		return ide_stopped;
-
-	if (ide_cd_check_transfer_size(drive, len)) {
-		cdrom_end_request(drive, 0);
-		return ide_stopped;
-	}
-
-	/* The number of sectors we need to read from the drive. */
-	sectors_to_transfer = len / SECTOR_SIZE;
-
-	/* First, figure out if we need to bit-bucket
-	   any of the leading sectors. */
-	nskip = min_t(int, rq->current_nr_sectors - bio_cur_sectors(rq->bio), sectors_to_transfer);
-
-	if (nskip > 0) {
-		ide_cd_drain_data(drive, nskip);
-		rq->current_nr_sectors -= nskip;
-		sectors_to_transfer -= nskip;
-	}
-
-	/* Now loop while we still have data to read from the drive. */
-	while (sectors_to_transfer > 0) {
-		int this_transfer;
-
-		/* If we've filled the present buffer but there's another
-		   chained buffer after it, move on. */
-		if (rq->current_nr_sectors == 0 && rq->nr_sectors)
-			cdrom_end_request(drive, 1);
-
-		/* If the buffers are full, cache the rest of the data in our
-		   internal buffer. */
-		if (rq->current_nr_sectors == 0) {
-			cdrom_buffer_sectors(drive, rq->sector, sectors_to_transfer);
-			sectors_to_transfer = 0;
-		} else {
-			/* Transfer data to the buffers.
-			   Figure out how many sectors we can transfer
-			   to the current buffer. */
-			this_transfer = min_t(int, sectors_to_transfer,
-					     rq->current_nr_sectors);
-
-			/* Read this_transfer sectors
-			   into the current buffer. */
-			while (this_transfer > 0) {
-				HWIF(drive)->atapi_input_bytes(drive, rq->buffer, SECTOR_SIZE);
-				rq->buffer += SECTOR_SIZE;
-				--rq->nr_sectors;
-				--rq->current_nr_sectors;
-				++rq->sector;
-				--this_transfer;
-				--sectors_to_transfer;
-			}
-		}
-	}
-
-	/* Done moving data!  Wait for another interrupt. */
-	ide_set_handler(drive, &cdrom_read_intr, ATAPI_WAIT_PC, NULL);
-	return ide_started;
-}
-
-/*
  * Try to satisfy some of the current read request from our cached data.
  * Returns nonzero if the request has been completed, zero otherwise.
  */
@@ -916,6 +797,8 @@ static int cdrom_read_from_buffer (ide_d
 	return 0;
 }
 
+static ide_startstop_t cdrom_rw_intr(ide_drive_t *);
+
 /*
  * Routine to send a read packet command to the drive.
  * This is usually called directly from cdrom_start_read.
@@ -954,7 +837,7 @@ static ide_startstop_t cdrom_start_read_
 	rq->timeout = ATAPI_WAIT_PC;
 
 	/* Send the command to the drive and return. */
-	return cdrom_transfer_packet_command(drive, rq, &cdrom_read_intr);
+	return cdrom_transfer_packet_command(drive, rq, cdrom_rw_intr);
 }
 
 
@@ -1157,7 +1040,7 @@ static int cdrom_write_check_ireason(ide
 /*
  * best way to deal with dma that is not sector aligned right now... note
  * that in this path we are not using ->data or ->buffer at all. this irs
- * can replace cdrom_read_intr() and cdrom_write_intr() in the future.
+ * can replace cdrom_rw_intr() in the future.
  */
 static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 {
@@ -1328,21 +1211,22 @@ end_request:
 	return ide_stopped;
 }
 
-static ide_startstop_t cdrom_write_intr(ide_drive_t *drive)
+static ide_startstop_t cdrom_rw_intr(ide_drive_t *drive)
 {
-	int stat, ireason, len, sectors_to_transfer, uptodate;
 	struct cdrom_info *info = drive->driver_data;
-	int dma_error = 0, dma = info->dma;
-	u8 lowcyl = 0, highcyl = 0;
-
 	struct request *rq = HWGROUP(drive)->rq;
+	xfer_func_t *xferfunc;
+	int stat, ireason, len, sectors_to_transfer, uptodate, nskip;
+	int dma_error = 0, dma = info->dma, write = rq_data_dir(rq) == WRITE;
+	u8 lowcyl = 0, highcyl = 0;
 
 	/* Check for errors. */
 	if (dma) {
 		info->dma = 0;
 		dma_error = HWIF(drive)->ide_dma_end(drive);
 		if (dma_error) {
-			printk(KERN_ERR "%s: DMA write error\n", drive->name);
+			printk(KERN_ERR "%s: DMA %s error\n", drive->name,
+					write ? "write" : "read");
 			ide_dma_off(drive);
 		}
 	}
@@ -1370,7 +1254,8 @@ static ide_startstop_t cdrom_write_intr(
 
 	/* If DRQ is clear, the command has completed. */
 	if ((stat & DRQ_STAT) == 0) {
-		/* If we're not done writing, complain.
+		/*
+		 * If we're not done reading/writing, complain.
 		 * Otherwise, complete the command normally.
 		 */
 		uptodate = 1;
@@ -1378,27 +1263,73 @@ static ide_startstop_t cdrom_write_intr(
 			printk(KERN_ERR "%s: %s: data underrun (%d blocks)\n",
 					drive->name, __FUNCTION__,
 					rq->current_nr_sectors);
+			if (!write)
+				rq->cmd_flags |= REQ_FAILED;
 			uptodate = 0;
 		}
 		cdrom_end_request(drive, uptodate);
 		return ide_stopped;
 	}
 
+	sectors_to_transfer = len / SECTOR_SIZE;
+
 	/* Check that the drive is expecting to do the same thing we are. */
-	if (cdrom_write_check_ireason(drive, len, ireason))
-		return ide_stopped;
+	if (write) {
+		if (cdrom_write_check_ireason(drive, len, ireason))
+			return ide_stopped;
 
-	sectors_to_transfer = len / SECTOR_SIZE;
+		xferfunc = HWIF(drive)->atapi_output_bytes;
+	} else {
+		if (cdrom_read_check_ireason(drive, len, ireason))
+			return ide_stopped;
+
+		if (ide_cd_check_transfer_size(drive, len)) {
+			cdrom_end_request(drive, 0);
+			return ide_stopped;
+		}
+
+		/*
+		 * First, figure out if we need to bit-bucket
+		 * any of the leading sectors.
+		 */
+		nskip = min_t(int, rq->current_nr_sectors
+				   - bio_cur_sectors(rq->bio),
+				   sectors_to_transfer);
+
+		if (nskip > 0) {
+			ide_cd_drain_data(drive, nskip);
+			rq->current_nr_sectors -= nskip;
+			sectors_to_transfer -= nskip;
+		}
+
+		xferfunc = HWIF(drive)->atapi_input_bytes;
+	}
 
 	/*
-	 * now loop and write out the data
+	 * now loop and read/write the data
 	 */
 	while (sectors_to_transfer > 0) {
 		int this_transfer;
 
+		/*
+		 * If we've filled the present buffer but there's another
+		 * chained buffer after it, move on.
+		 */
+		if (!write && rq->current_nr_sectors == 0 && rq->nr_sectors)
+			cdrom_end_request(drive, 1);
+
 		if (!rq->current_nr_sectors) {
-			printk(KERN_ERR "%s: %s: confused, missing data\n",
-					drive->name, __FUNCTION__);
+			if (!write)
+				/*
+				 * If the buffers are full, cache the rest
+				 * of the data in our internal buffer.
+				 */
+				cdrom_buffer_sectors(drive, rq->sector,
+						     sectors_to_transfer);
+			else
+				printk(KERN_ERR "%s: %s: confused, missing "
+						"data\n",
+						drive->name, __FUNCTION__);
 			break;
 		}
 
@@ -1408,7 +1339,7 @@ static ide_startstop_t cdrom_write_intr(
 		this_transfer = min_t(int, sectors_to_transfer, rq->current_nr_sectors);
 
 		while (this_transfer > 0) {
-			HWIF(drive)->atapi_output_bytes(drive, rq->buffer, SECTOR_SIZE);
+			xferfunc(drive, rq->buffer, SECTOR_SIZE);
 			rq->buffer += SECTOR_SIZE;
 			--rq->nr_sectors;
 			--rq->current_nr_sectors;
@@ -1420,12 +1351,12 @@ static ide_startstop_t cdrom_write_intr(
 		/*
 		 * current buffer complete, move on
 		 */
-		if (rq->current_nr_sectors == 0 && rq->nr_sectors)
+		if (write && rq->current_nr_sectors == 0 && rq->nr_sectors)
 			cdrom_end_request(drive, 1);
 	}
 
 	/* re-arm handler */
-	ide_set_handler(drive, &cdrom_write_intr, ATAPI_WAIT_PC, NULL);
+	ide_set_handler(drive, cdrom_rw_intr, ATAPI_WAIT_PC, NULL);
 	return ide_started;
 }
 
@@ -1438,7 +1369,7 @@ static ide_startstop_t cdrom_start_write
 #endif
 	rq->timeout = ATAPI_WAIT_PC;
 
-	return cdrom_transfer_packet_command(drive, rq, cdrom_write_intr);
+	return cdrom_transfer_packet_command(drive, rq, cdrom_rw_intr);
 }
 
 static ide_startstop_t cdrom_start_write(ide_drive_t *drive, struct request *rq)
