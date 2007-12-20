Return-Path: <linux-kernel-owner+w=401wt.eu-S1760983AbXLTBps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760983AbXLTBps (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 20:45:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759249AbXLTBf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 20:35:56 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:11731 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758962AbXLTBfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 20:35:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=TNprUlEYPcz1utqH1QHQprODCd/VZrIUugADjAEUSy3dhXaWVoBGc6I/8PWhXXQnR3LiJnFhr75iSpunzOaXHHdvv+H5/zas7SyUeCVOL3td7WZ2Ma1Chrghf96rsyWMgx5zwbwJsdXgvWSM4fgcWU4zHMYGNLriLBG13jwF0IM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 60/63] ide-cd: merge cdrom_rw_intr() and cdrom_newpc_intr()
Date: Thu, 20 Dec 2007 02:38:07 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712200238.07525.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add handling of fs read/write requests to cdrom_nepwc_intr()
and remove no longer needed cdrom_rw_intr().

There should be no functionality changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
-496 bytes
 drivers/ide/ide-cd.c |  272 +++++++++++++++++----------------------------------
 1 file changed, 94 insertions(+), 178 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -797,7 +797,7 @@ static int cdrom_read_from_buffer (ide_d
 	return 0;
 }
 
-static ide_startstop_t cdrom_rw_intr(ide_drive_t *);
+static ide_startstop_t cdrom_newpc_intr(ide_drive_t *);
 
 /*
  * Routine to send a read/write packet command to the drive.
@@ -846,7 +846,7 @@ static ide_startstop_t cdrom_start_rw_co
 	rq->timeout = ATAPI_WAIT_PC;
 
 	/* Send the command to the drive and return. */
-	return cdrom_transfer_packet_command(drive, rq, cdrom_rw_intr);
+	return cdrom_transfer_packet_command(drive, rq, cdrom_newpc_intr);
 }
 
 #define IDECD_SEEK_THRESHOLD	(1000)			/* 1000 blocks */
@@ -1013,17 +1013,12 @@ static int cdrom_write_check_ireason(ide
 	return 1;
 }
 
-/*
- * best way to deal with dma that is not sector aligned right now... note
- * that in this path we are not using ->data or ->buffer at all. this irs
- * can replace cdrom_rw_intr() in the future.
- */
 static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 {
 	struct cdrom_info *info = drive->driver_data;
 	struct request *rq = HWGROUP(drive)->rq;
 	xfer_func_t *xferfunc;
-	ide_expiry_t *expiry;
+	ide_expiry_t *expiry = NULL;
 	int dma_error = 0, dma, stat, ireason, len, thislen, uptodate = 0;
 	int write = (rq_data_dir(rq) == WRITE) ? 1 : 0;
 	unsigned int timeout;
@@ -1051,6 +1046,10 @@ static ide_startstop_t cdrom_newpc_intr(
 		if (dma_error)
 			return ide_error(drive, "dma error", stat);
 
+		if (blk_fs_request(rq)) {
+			ide_end_request(drive, 1, rq->nr_sectors);
+			return ide_stopped;
+		}
 		end_that_request_chunk(rq, 1, rq->data_len);
 		rq->data_len = 0;
 		goto end_request;
@@ -1064,7 +1063,8 @@ static ide_startstop_t cdrom_newpc_intr(
 	highcyl = HWIF(drive)->INB(IDE_BCOUNTH_REG);
 
 	len = lowcyl + (256 * highcyl);
-	thislen = rq->data_len;
+
+	thislen = blk_fs_request(rq) ? len : rq->data_len;
 	if (thislen > len)
 		thislen = len;
 
@@ -1072,7 +1072,24 @@ static ide_startstop_t cdrom_newpc_intr(
 	 * If DRQ is clear, the command has completed.
 	 */
 	if ((stat & DRQ_STAT) == 0) {
-		if (!blk_pc_request(rq)) {
+		if (blk_fs_request(rq)) {
+			/*
+			 * If we're not done reading/writing, complain.
+			 * Otherwise, complete the command normally.
+			 */
+			uptodate = 1;
+			if (rq->current_nr_sectors > 0) {
+				printk(KERN_ERR "%s: %s: data underrun "
+						"(%d blocks)\n",
+						drive->name, __FUNCTION__,
+						rq->current_nr_sectors);
+				if (!write)
+					rq->cmd_flags |= REQ_FAILED;
+				uptodate = 0;
+			}
+			cdrom_end_request(drive, uptodate);
+			return ide_stopped;
+		} else if (!blk_pc_request(rq)) {
 			ide_cd_request_sense_fixup(rq);
 			/* Complain if we still have data left to transfer. */
 			uptodate = rq->data_len ? 0 : 1;
@@ -1083,24 +1100,47 @@ static ide_startstop_t cdrom_newpc_intr(
 	/*
 	 * check which way to transfer data
 	 */
-	if (blk_pc_request(rq) && rq_data_dir(rq) == WRITE) {
+	if ((blk_fs_request(rq) || blk_pc_request(rq)) && write) {
 		/*
 		 * write to drive
 		 */
 		if (cdrom_write_check_ireason(drive, len, ireason))
 			return ide_stopped;
-	} else if (blk_pc_request(rq)) {
+	} else if (blk_fs_request(rq) || blk_pc_request(rq)) {
 		/*
 		 * read from drive
 		 */
 		if (cdrom_read_check_ireason(drive, len, ireason))
 			return ide_stopped;
+
+		if (blk_fs_request(rq)) {
+			int nskip;
+
+			if (ide_cd_check_transfer_size(drive, len)) {
+				cdrom_end_request(drive, 0);
+				return ide_stopped;
+			}
+
+			/*
+			 * First, figure out if we need to bit-bucket
+			 * any of the leading sectors.
+			 */
+			nskip = min_t(int, rq->current_nr_sectors
+					   - bio_cur_sectors(rq->bio),
+					   thislen >> 9);
+			if (nskip > 0) {
+				ide_cd_drain_data(drive, nskip);
+				rq->current_nr_sectors -= nskip;
+				thislen -= (nskip << 9);
+			}
+		}
 	}
 
 	if (ireason == 0) {
 		write = 1;
 		xferfunc = HWIF(drive)->atapi_output_bytes;
-	} else if (ireason == 2 || (ireason == 1 && blk_pc_request(rq))) {
+	} else if (ireason == 2 || (ireason == 1 &&
+		   (blk_fs_request(rq) || blk_pc_request(rq)))) {
 		write = 0;
 		xferfunc = HWIF(drive)->atapi_input_bytes;
 	} else {
@@ -1115,23 +1155,37 @@ static ide_startstop_t cdrom_newpc_intr(
 	 * transfer data
 	 */
 	while (thislen > 0) {
-		u8 *ptr = rq->data;
+		u8 *ptr = blk_fs_request(rq) ? NULL : rq->data;
 		int blen = rq->data_len;
 
 		/*
 		 * bio backed?
 		 */
 		if (rq->bio) {
-			ptr = bio_data(rq->bio);
-			blen = bio_iovec(rq->bio)->bv_len;
+			if (blk_fs_request(rq)) {
+				ptr = rq->buffer;
+				blen = rq->current_nr_sectors << 9;
+			} else {
+				ptr = bio_data(rq->bio);
+				blen = bio_iovec(rq->bio)->bv_len;
+			}
 		}
 
 		if (!ptr) {
-			printk(KERN_ERR "%s: confused, missing data\n",
-					drive->name);
-			blk_dump_rq_flags(rq, rq_data_dir(rq)
-					      ? "cdrom_newpc_intr, write"
-					      : "cdrom_newpc_intr, read");
+			if (blk_fs_request(rq) && !write)
+				/*
+				 * If the buffers are full, cache the rest
+				 * of the data in our internal buffer.
+				 */
+				cdrom_buffer_sectors(drive, rq->sector,
+						     thislen >> 9);
+			else {
+				printk(KERN_ERR "%s: confused, missing data\n",
+						drive->name);
+				blk_dump_rq_flags(rq, rq_data_dir(rq)
+						  ? "cdrom_newpc_intr, write"
+						  : "cdrom_newpc_intr, read");
+			}
 			break;
 		}
 
@@ -1142,12 +1196,23 @@ static ide_startstop_t cdrom_newpc_intr(
 
 		thislen -= blen;
 		len -= blen;
-		rq->data_len -= blen;
 
-		if (rq->bio)
-			end_that_request_chunk(rq, 1, blen);
-		else
-			rq->data += blen;
+		if (blk_fs_request(rq)) {
+			rq->buffer += blen;
+			rq->nr_sectors -= (blen >> 9);
+			rq->current_nr_sectors -= (blen >> 9);
+			rq->sector += (blen >> 9);
+
+			if (rq->current_nr_sectors == 0 && rq->nr_sectors)
+				cdrom_end_request(drive, 1);
+		} else {
+			rq->data_len -= blen;
+
+			if (rq->bio)
+				end_that_request_chunk(rq, 1, blen);
+			else
+				rq->data += blen;
+		}
 	}
 
 	if (write && blk_sense_request(rq))
@@ -1156,15 +1221,15 @@ static ide_startstop_t cdrom_newpc_intr(
 	/*
 	 * pad, if necessary
 	 */
-	if (len > 0)
+	if (!blk_fs_request(rq) && len > 0)
 		ide_cd_pad_transfer(drive, xferfunc, len);
 
 	if (blk_pc_request(rq)) {
 		timeout = rq->timeout;
-		expiry = NULL;
 	} else {
 		timeout = ATAPI_WAIT_PC;
-		expiry = cdrom_timer_expiry;
+		if (!blk_fs_request(rq))
+			expiry = cdrom_timer_expiry;
 	}
 
 	ide_set_handler(drive, cdrom_newpc_intr, timeout, expiry);
@@ -1187,155 +1252,6 @@ end_request:
 	return ide_stopped;
 }
 
-static ide_startstop_t cdrom_rw_intr(ide_drive_t *drive)
-{
-	struct cdrom_info *info = drive->driver_data;
-	struct request *rq = HWGROUP(drive)->rq;
-	xfer_func_t *xferfunc;
-	int stat, ireason, len, thislen, uptodate, nskip;
-	int dma_error = 0, dma = info->dma, write = rq_data_dir(rq) == WRITE;
-	u8 lowcyl = 0, highcyl = 0;
-
-	/* Check for errors. */
-	if (dma) {
-		info->dma = 0;
-		dma_error = HWIF(drive)->ide_dma_end(drive);
-		if (dma_error) {
-			printk(KERN_ERR "%s: DMA %s error\n", drive->name,
-					write ? "write" : "read");
-			ide_dma_off(drive);
-		}
-	}
-
-	if (cdrom_decode_status(drive, 0, &stat))
-		return ide_stopped;
-
-	/*
-	 * using dma, transfer is complete now
-	 */
-	if (dma) {
-		if (dma_error)
-			return ide_error(drive, "dma error", stat);
-
-		ide_end_request(drive, 1, rq->nr_sectors);
-		return ide_stopped;
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
-		/*
-		 * If we're not done reading/writing, complain.
-		 * Otherwise, complete the command normally.
-		 */
-		uptodate = 1;
-		if (rq->current_nr_sectors > 0) {
-			printk(KERN_ERR "%s: %s: data underrun (%d blocks)\n",
-					drive->name, __FUNCTION__,
-					rq->current_nr_sectors);
-			if (!write)
-				rq->cmd_flags |= REQ_FAILED;
-			uptodate = 0;
-		}
-		cdrom_end_request(drive, uptodate);
-		return ide_stopped;
-	}
-
-	thislen = len;
-
-	/* Check that the drive is expecting to do the same thing we are. */
-	if (write) {
-		if (cdrom_write_check_ireason(drive, len, ireason))
-			return ide_stopped;
-
-		xferfunc = HWIF(drive)->atapi_output_bytes;
-	} else {
-		if (cdrom_read_check_ireason(drive, len, ireason))
-			return ide_stopped;
-
-		if (ide_cd_check_transfer_size(drive, len)) {
-			cdrom_end_request(drive, 0);
-			return ide_stopped;
-		}
-
-		/*
-		 * First, figure out if we need to bit-bucket
-		 * any of the leading sectors.
-		 */
-		nskip = min_t(int, rq->current_nr_sectors
-				   - bio_cur_sectors(rq->bio),
-				   thislen >> 9);
-
-		if (nskip > 0) {
-			ide_cd_drain_data(drive, nskip);
-			rq->current_nr_sectors -= nskip;
-			thislen -= (nskip << 9);
-		}
-
-		xferfunc = HWIF(drive)->atapi_input_bytes;
-	}
-
-	/*
-	 * now loop and read/write the data
-	 */
-	while (thislen > 0) {
-		u8 *ptr = NULL;
-		int blen;
-
-		if (rq->bio) {
-			ptr = rq->buffer;
-			blen = rq->current_nr_sectors << 9;
-		}
-
-		if (!ptr) {
-			if (!write)
-				/*
-				 * If the buffers are full, cache the rest
-				 * of the data in our internal buffer.
-				 */
-				cdrom_buffer_sectors(drive, rq->sector,
-						     thislen >> 9);
-			else {
-				printk(KERN_ERR "%s: %s: confused, missing "
-						"data\n",
-						drive->name, __FUNCTION__);
-				blk_dump_rq_flags(rq, "cdrom_rw_intr, write");
-			}
-			break;
-		}
-
-		/*
-		 * Figure out how many sectors we can transfer
-		 */
-		if (blen > thislen)
-			blen = thislen;
-
-		xferfunc(drive, ptr, blen);
-
-		thislen -= blen;
-		rq->buffer += blen;
-		rq->nr_sectors -= (blen >> 9);
-		rq->current_nr_sectors -= (blen >> 9);
-		rq->sector += (blen >> 9);
-
-		/*
-		 * current buffer complete, move on
-		 */
-		if (rq->current_nr_sectors == 0 && rq->nr_sectors)
-			cdrom_end_request(drive, 1);
-	}
-
-	/* re-arm handler */
-	ide_set_handler(drive, cdrom_rw_intr, ATAPI_WAIT_PC, NULL);
-	return ide_started;
-}
-
 static ide_startstop_t cdrom_start_rw(ide_drive_t *drive, struct request *rq)
 {
 	struct cdrom_info *cd = drive->driver_data;
