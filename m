Return-Path: <linux-kernel-owner+w=401wt.eu-S1760696AbXLTBqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760696AbXLTBqi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 20:46:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756647AbXLTBgD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 20:36:03 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:12465 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758952AbXLTBfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 20:35:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=OZ10iiN4eC5lrkzPb53g2CZBYmEY+t7qKv+IfgW5eSsT4IdGts23ph0w3JyMXktVrULzqQctuKk6yfhqjyEbU7m06oUSd6JLqByf7ev6dgU8exv2gf8WYOgUGsJIsSPJ8vZyPVRVD1m1ireHjtRSQvJYNuUIGug5odAA/g+d2TM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 58/63] ide-cd: prepare cdrom_rw_intr() and cdrom_newpc_intr() to be merged
Date: Thu, 20 Dec 2007 02:36:41 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712200236.41270.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In cdrom_newpc_intr():
* cleanup variables in the 'transfer data' loop

In cdrom_rw_intr():
* rename 'sectors_to_transfer' to 'thislen'
* rename 'this_transfer' to 'blen'
* keep number of bytes (instead of sectors) in 'thislen' and 'blen'
* call 'xferfunc' only once for 'blen'
* cache 'rq->buffer' in 'ptr' variable
* check for 'rq->bio' before setting 'ptr' and 'blen'
* check for 'ptr' instead of 'rq->current_nr_sectors'

There should be no functionality changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
+54 bytes
 drivers/ide/ide-cd.c |   45 +++++++++++++++++++++++++--------------------
 1 file changed, 25 insertions(+), 20 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1115,8 +1115,8 @@ static ide_startstop_t cdrom_newpc_intr(
 	 * transfer data
 	 */
 	while (thislen > 0) {
-		int blen = blen = rq->data_len;
-		char *ptr = rq->data;
+		u8 *ptr = rq->data;
+		int blen = rq->data_len;
 
 		/*
 		 * bio backed?
@@ -1192,7 +1192,7 @@ static ide_startstop_t cdrom_rw_intr(ide
 	struct cdrom_info *info = drive->driver_data;
 	struct request *rq = HWGROUP(drive)->rq;
 	xfer_func_t *xferfunc;
-	int stat, ireason, len, sectors_to_transfer, uptodate, nskip;
+	int stat, ireason, len, thislen, uptodate, nskip;
 	int dma_error = 0, dma = info->dma, write = rq_data_dir(rq) == WRITE;
 	u8 lowcyl = 0, highcyl = 0;
 
@@ -1247,7 +1247,7 @@ static ide_startstop_t cdrom_rw_intr(ide
 		return ide_stopped;
 	}
 
-	sectors_to_transfer = len / SECTOR_SIZE;
+	thislen = len;
 
 	/* Check that the drive is expecting to do the same thing we are. */
 	if (write) {
@@ -1270,12 +1270,12 @@ static ide_startstop_t cdrom_rw_intr(ide
 		 */
 		nskip = min_t(int, rq->current_nr_sectors
 				   - bio_cur_sectors(rq->bio),
-				   sectors_to_transfer);
+				   thislen >> 9);
 
 		if (nskip > 0) {
 			ide_cd_drain_data(drive, nskip);
 			rq->current_nr_sectors -= nskip;
-			sectors_to_transfer -= nskip;
+			thislen -= (nskip << 9);
 		}
 
 		xferfunc = HWIF(drive)->atapi_input_bytes;
@@ -1284,17 +1284,23 @@ static ide_startstop_t cdrom_rw_intr(ide
 	/*
 	 * now loop and read/write the data
 	 */
-	while (sectors_to_transfer > 0) {
-		int this_transfer;
+	while (thislen > 0) {
+		u8 *ptr = NULL;
+		int blen;
+
+		if (rq->bio) {
+			ptr = rq->buffer;
+			blen = rq->current_nr_sectors << 9;
+		}
 
-		if (!rq->current_nr_sectors) {
+		if (!ptr) {
 			if (!write)
 				/*
 				 * If the buffers are full, cache the rest
 				 * of the data in our internal buffer.
 				 */
 				cdrom_buffer_sectors(drive, rq->sector,
-						     sectors_to_transfer);
+						     thislen >> 9);
 			else
 				printk(KERN_ERR "%s: %s: confused, missing "
 						"data\n",
@@ -1305,17 +1311,16 @@ static ide_startstop_t cdrom_rw_intr(ide
 		/*
 		 * Figure out how many sectors we can transfer
 		 */
-		this_transfer = min_t(int, sectors_to_transfer, rq->current_nr_sectors);
+		if (blen > thislen)
+			blen = thislen;
 
-		while (this_transfer > 0) {
-			xferfunc(drive, rq->buffer, SECTOR_SIZE);
-			rq->buffer += SECTOR_SIZE;
-			--rq->nr_sectors;
-			--rq->current_nr_sectors;
-			++rq->sector;
-			--this_transfer;
-			--sectors_to_transfer;
-		}
+		xferfunc(drive, ptr, blen);
+
+		thislen -= blen;
+		rq->buffer += blen;
+		rq->nr_sectors -= (blen >> 9);
+		rq->current_nr_sectors -= (blen >> 9);
+		rq->sector += (blen >> 9);
 
 		/*
 		 * current buffer complete, move on
