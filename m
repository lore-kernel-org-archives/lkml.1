Return-Path: <linux-kernel-owner+w=401wt.eu-S932411AbXLTBrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932411AbXLTBrb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 20:47:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759006AbXLTBgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 20:36:09 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:13030 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758934AbXLTBfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 20:35:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=uSKHpn1VpNA3/KAcpHm7hVq2YCSxk8tjwCY15BKwH6h3jzP9XxqyDBgGgX8ESbnPUA4MoL/doiCzk1oNs83Naln0M9wo0vBeSrJhDhpto72/0X2T9yq5/tf5LVxsehg15OoJeVgwRtsXsGNeupJniGBV98ynWSuEbUzmUKnv9j8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 56/63] ide-cd: merge cdrom_start_read() and cdrom_start_write()
Date: Thu, 20 Dec 2007 02:35:14 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712200235.14503.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add handling of read requests to cdrom_start_write(), rename it
to cdrom_start_rw() and remove no longer needed cdrom_start_read().

There should be no functionality changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
-20 bytes
 drivers/ide/ide-cd.c |  101 ++++++++++++++++++++-------------------------------
 1 file changed, 40 insertions(+), 61 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -918,38 +918,6 @@ static void restore_request (struct requ
 	rq->q->prep_rq_fn(rq->q, rq);
 }
 
-/*
- * Start a read request from the CD-ROM.
- */
-static ide_startstop_t cdrom_start_read (ide_drive_t *drive, unsigned int block)
-{
-	struct cdrom_info *info = drive->driver_data;
-	struct request *rq = HWGROUP(drive)->rq;
-	unsigned short sectors_per_frame;
-
-	sectors_per_frame = queue_hardsect_size(drive->queue) >> SECTOR_BITS;
-
-	/* We may be retrying this request after an error.  Fix up
-	   any weirdness which might be present in the request packet. */
-	restore_request(rq);
-
-	/* Satisfy whatever we can of this request from our cached sector. */
-	if (cdrom_read_from_buffer(drive))
-		return ide_stopped;
-
-	/* Clear the local sector buffer. */
-	info->nsectors_buffered = 0;
-
-	/* use dma, if possible. */
-	info->dma = drive->using_dma;
-	if ((rq->sector & (sectors_per_frame - 1)) ||
-	    (rq->nr_sectors & (sectors_per_frame - 1)))
-		info->dma = 0;
-
-	/* Start sending the read request to the drive. */
-	return cdrom_start_packet_command(drive, 32768, cdrom_start_rw_cont);
-}
-
 /****************************************************************************
  * Execute all other packet commands.
  */
@@ -1368,38 +1336,53 @@ static ide_startstop_t cdrom_rw_intr(ide
 	return ide_started;
 }
 
-static ide_startstop_t cdrom_start_write(ide_drive_t *drive, struct request *rq)
+static ide_startstop_t cdrom_start_rw(ide_drive_t *drive, struct request *rq)
 {
-	struct cdrom_info *info = drive->driver_data;
-	struct gendisk *g = info->disk;
-	unsigned short sectors_per_frame = queue_hardsect_size(drive->queue) >> SECTOR_BITS;
+	struct cdrom_info *cd = drive->driver_data;
+	int write = rq_data_dir(rq) == WRITE;
+	unsigned short sectors_per_frame =
+		queue_hardsect_size(drive->queue) >> SECTOR_BITS;
 
-	/*
-	 * writes *must* be hardware frame aligned
-	 */
-	if ((rq->nr_sectors & (sectors_per_frame - 1)) ||
-	    (rq->sector & (sectors_per_frame - 1))) {
-		cdrom_end_request(drive, 0);
-		return ide_stopped;
+	if (write) {
+		/*
+		 * disk has become write protected
+		 */
+		if (cd->disk->policy) {
+			cdrom_end_request(drive, 0);
+			return ide_stopped;
+		}
+	} else {
+		/*
+		 * We may be retrying this request after an error.  Fix up any
+		 * weirdness which might be present in the request packet.
+		 */
+		restore_request(rq);
+
+		/* Satisfy whatever we can of this request from our cache. */
+		if (cdrom_read_from_buffer(drive))
+			return ide_stopped;
 	}
 
 	/*
-	 * disk has become write protected
+	 * use DMA, if possible / writes *must* be hardware frame aligned
 	 */
-	if (g->policy) {
-		cdrom_end_request(drive, 0);
-		return ide_stopped;
-	}
-
-	info->nsectors_buffered = 0;
+	if ((rq->nr_sectors & (sectors_per_frame - 1)) ||
+	    (rq->sector & (sectors_per_frame - 1))) {
+		if (write) {
+			cdrom_end_request(drive, 0);
+			return ide_stopped;
+		}
+		cd->dma = 0;
+	} else
+		cd->dma = drive->using_dma;
 
-	/* use dma, if possible. we don't need to check more, since we
-	 * know that the transfer is always (at least!) frame aligned */
-	info->dma = drive->using_dma ? 1 : 0;
+	/* Clear the local sector buffer. */
+	cd->nsectors_buffered = 0;
 
-	info->devinfo.media_written = 1;
+	if (write)
+		cd->devinfo.media_written = 1;
 
-	/* Start sending the write request to the drive. */
+	/* Start sending the read/write request to the drive. */
 	return cdrom_start_packet_command(drive, 32768, cdrom_start_rw_cont);
 }
 
@@ -1472,12 +1455,8 @@ ide_do_rw_cdrom (ide_drive_t *drive, str
 		}
 		if ((rq_data_dir(rq) == READ) && IDE_LARGE_SEEK(info->last_block, block, IDECD_SEEK_THRESHOLD) 
&& drive->dsc_overlap) {
 			action = cdrom_start_seek(drive, block);
-		} else {
-			if (rq_data_dir(rq) == READ)
-				action = cdrom_start_read(drive, block);
-			else
-				action = cdrom_start_write(drive, rq);
-		}
+		} else
+			action = cdrom_start_rw(drive, rq);
 		info->last_block = block;
 		return action;
 	} else if (blk_sense_request(rq) || blk_pc_request(rq) ||
