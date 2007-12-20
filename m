Return-Path: <linux-kernel-owner+w=401wt.eu-S1761026AbXLTBry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761026AbXLTBry (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 20:47:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758365AbXLTBgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 20:36:13 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:12621 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758931AbXLTBe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 20:34:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Z7ii7vYVfAsSbizeZ0uj2Ns+ecOD4pR8azJGpIMnLFduir9K9e1Nm/ILnuWn+rkkz35A9dXFWkMxZlhl7c1xruGVa4t+vS8bLJCN1QxNcYleR97h6DbRaFzQg+lAb7F9Hxk47ibQEZKZIAtZESNbHNlNSmB3zb9Z6R9lKtc4+Is=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 55/63] ide-cd: merge cdrom_start_read_continuation() and cdrom_start_rw_cont()
Date: Thu, 20 Dec 2007 02:34:23 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712200234.23238.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Add handling of write requests to cdrom_start_read_continuation(),
  rename it to cdrom_start_rw_cont() and remove no longer needed
  cdrom_start_write_cont().

* Remove redundant '(rq->sector & (sectors_per_frame - 1)' check.

There should be no functionality changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
-51 bytes
 drivers/ide/ide-cd.c |   74 ++++++++++++++++++++++++---------------------------
 1 file changed, 35 insertions(+), 39 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -800,39 +800,48 @@ static int cdrom_read_from_buffer (ide_d
 static ide_startstop_t cdrom_rw_intr(ide_drive_t *);
 
 /*
- * Routine to send a read packet command to the drive.
- * This is usually called directly from cdrom_start_read.
+ * Routine to send a read/write packet command to the drive.
+ * This is usually called directly from cdrom_start_{read,write}().
  * However, for drq_interrupt devices, it is called from an interrupt
  * when the drive is ready to accept the command.
  */
-static ide_startstop_t cdrom_start_read_continuation (ide_drive_t *drive)
+static ide_startstop_t cdrom_start_rw_cont(ide_drive_t *drive)
 {
 	struct request *rq = HWGROUP(drive)->rq;
-	unsigned short sectors_per_frame;
-	int nskip;
 
-	sectors_per_frame = queue_hardsect_size(drive->queue) >> SECTOR_BITS;
+	if (rq_data_dir(rq) == READ) {
+		unsigned short sectors_per_frame =
+			queue_hardsect_size(drive->queue) >> SECTOR_BITS;
+		int nskip = rq->sector & (sectors_per_frame - 1);
 
-	/* If the requested sector doesn't start on a cdrom block boundary,
-	   we must adjust the start of the transfer so that it does,
-	   and remember to skip the first few sectors.
-	   If the CURRENT_NR_SECTORS field is larger than the size
-	   of the buffer, it will mean that we're to skip a number
-	   of sectors equal to the amount by which CURRENT_NR_SECTORS
-	   is larger than the buffer size. */
-	nskip = rq->sector & (sectors_per_frame - 1);
-	if (nskip > 0) {
-		/* Sanity check... */
-		if (rq->current_nr_sectors != bio_cur_sectors(rq->bio) &&
-			(rq->sector & (sectors_per_frame - 1))) {
-			printk(KERN_ERR "%s: cdrom_start_read_continuation: buffer botch (%u)\n",
-				drive->name, rq->current_nr_sectors);
-			cdrom_end_request(drive, 0);
-			return ide_stopped;
+		/*
+		 * If the requested sector doesn't start on a frame boundary,
+		 * we must adjust the start of the transfer so that it does,
+		 * and remember to skip the first few sectors.
+		 *
+		 * If the rq->current_nr_sectors field is larger than the size
+		 * of the buffer, it will mean that we're to skip a number of
+		 * sectors equal to the amount by which rq->current_nr_sectors
+		 * is larger than the buffer size.
+		 */
+		if (nskip > 0) {
+			/* Sanity check... */
+			if (rq->current_nr_sectors !=
+			    bio_cur_sectors(rq->bio)) {
+				printk(KERN_ERR "%s: %s: buffer botch (%u)\n",
+						drive->name, __FUNCTION__,
+						rq->current_nr_sectors);
+				cdrom_end_request(drive, 0);
+				return ide_stopped;
+			}
+			rq->current_nr_sectors += nskip;
 		}
-		rq->current_nr_sectors += nskip;
 	}
-
+#if 0
+	else
+		/* the immediate bit */
+		rq->cmd[1] = 1 << 3;
+#endif
 	/* Set up the command */
 	rq->timeout = ATAPI_WAIT_PC;
 
@@ -840,7 +849,6 @@ static ide_startstop_t cdrom_start_read_
 	return cdrom_transfer_packet_command(drive, rq, cdrom_rw_intr);
 }
 
-
 #define IDECD_SEEK_THRESHOLD	(1000)			/* 1000 blocks */
 #define IDECD_SEEK_TIMER	(5 * WAIT_MIN_SLEEP)	/* 100 ms */
 #define IDECD_SEEK_TIMEOUT	(2 * WAIT_CMD)		/* 20 sec */
@@ -939,7 +947,7 @@ static ide_startstop_t cdrom_start_read 
 		info->dma = 0;
 
 	/* Start sending the read request to the drive. */
-	return cdrom_start_packet_command(drive, 32768, cdrom_start_read_continuation);
+	return cdrom_start_packet_command(drive, 32768, cdrom_start_rw_cont);
 }
 
 /****************************************************************************
@@ -1360,18 +1368,6 @@ static ide_startstop_t cdrom_rw_intr(ide
 	return ide_started;
 }
 
-static ide_startstop_t cdrom_start_write_cont(ide_drive_t *drive)
-{
-	struct request *rq = HWGROUP(drive)->rq;
-
-#if 0	/* the immediate bit */
-	rq->cmd[1] = 1 << 3;
-#endif
-	rq->timeout = ATAPI_WAIT_PC;
-
-	return cdrom_transfer_packet_command(drive, rq, cdrom_rw_intr);
-}
-
 static ide_startstop_t cdrom_start_write(ide_drive_t *drive, struct request *rq)
 {
 	struct cdrom_info *info = drive->driver_data;
@@ -1404,7 +1400,7 @@ static ide_startstop_t cdrom_start_write
 	info->devinfo.media_written = 1;
 
 	/* Start sending the write request to the drive. */
-	return cdrom_start_packet_command(drive, 32768, cdrom_start_write_cont);
+	return cdrom_start_packet_command(drive, 32768, cdrom_start_rw_cont);
 }
 
 static ide_startstop_t cdrom_do_newpc_cont(ide_drive_t *drive)
