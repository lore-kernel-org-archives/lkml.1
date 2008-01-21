Return-Path: <linux-kernel-owner+w=401wt.eu-S1763139AbYAUXXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763139AbYAUXXq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 18:23:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761104AbYAUXTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 18:19:15 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:43432 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761080AbYAUXTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 18:19:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=kvZfbVUYmUK/ccpnGjL49kLKPbleaGEffVn/R/uHWUc/8fWsvLMMzMkIIdme0ZJi00DtCi3rDJXhqzlgKYhMmatLIAD9j8UTUNl/+eq8hEcFStxg7P5rYT2gUQFuwIO6IvMrl5V+pC5W3SuhlUPuEC3oy6caq0+2Jp54HNbddE0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 22 Jan 2008 00:32:19 +0100
Message-Id: <20080121233219.30311.13119.sendpatchset@localhost.localdomain>
In-Reply-To: <20080121233036.30311.76015.sendpatchset@localhost.localdomain>
References: <20080121233036.30311.76015.sendpatchset@localhost.localdomain>
Subject: [PATCH 15/16] ide: remove ide_auto_reduce_xfer()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


While at it:

* Remove needless '!drive->crc_count' check.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-iops.c |   41 +++++++++++++----------------------------
 1 file changed, 13 insertions(+), 28 deletions(-)

Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -612,33 +612,6 @@ no_80w:
 	return 0;
 }
 
-#ifdef CONFIG_BLK_DEV_IDEDMA
-static u8 ide_auto_reduce_xfer (ide_drive_t *drive)
-{
-	if (!drive->crc_count)
-		return drive->current_speed;
-	drive->crc_count = 0;
-
-	switch(drive->current_speed) {
-		case XFER_UDMA_7:	return XFER_UDMA_6;
-		case XFER_UDMA_6:	return XFER_UDMA_5;
-		case XFER_UDMA_5:	return XFER_UDMA_4;
-		case XFER_UDMA_4:	return XFER_UDMA_3;
-		case XFER_UDMA_3:	return XFER_UDMA_2;
-		case XFER_UDMA_2:	return XFER_UDMA_1;
-		case XFER_UDMA_1:	return XFER_UDMA_0;
-			/*
-			 * OOPS we do not goto non Ultra DMA modes
-			 * without iCRC's available we force
-			 * the system to PIO and make the user
-			 * invoke the ATA-1 ATA-2 DMA modes.
-			 */
-		case XFER_UDMA_0:
-		default:		return XFER_PIO_4;
-	}
-}
-#endif /* CONFIG_BLK_DEV_IDEDMA */
-
 int ide_driveid_update(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
@@ -968,8 +941,20 @@ static ide_startstop_t reset_pollfunc (i
 static void check_dma_crc(ide_drive_t *drive)
 {
 #ifdef CONFIG_BLK_DEV_IDEDMA
+	u8 mode;
+
 	ide_dma_off_quietly(drive);
-	ide_set_xfer_rate(drive, ide_auto_reduce_xfer(drive));
+	drive->crc_count = 0;
+	mode = drive->current_speed;
+	/*
+	 * Don't try non Ultra-DMA modes without iCRC's.  Force the
+	 * device to PIO and make the user enable SWDMA/MWDMA modes.
+	 */
+	if (mode > XFER_UDMA_0 && mode <= XFER_UDMA_7)
+		mode--;
+	else
+		mode = XFER_PIO_4;
+	ide_set_xfer_rate(drive, mode);
 	if (drive->current_speed >= XFER_SW_DMA_0)
 		ide_dma_on(drive);
 #endif
