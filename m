Return-Path: <linux-kernel-owner+w=401wt.eu-S1759097AbYAUXYF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759097AbYAUXYF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 18:24:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761169AbYAUXT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 18:19:26 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:43432 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761153AbYAUXTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 18:19:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=E0tXFlu25eIM0/HvJ/PfugX4RXcr9VX8oO/82fVBXLCV1RGnJmOwHEcZO+gdZ5PoUjf4Ysuxj+9rx2Z7442mx99R+z6BhwRZKZ/Jt0tA5QCfAAgwvzQSE4vQ8S259W7qaiHuY5tR+uF09Bt1tjJ+UV5nPKQ71CP1+6+InWWdTXs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 22 Jan 2008 00:32:26 +0100
Message-Id: <20080121233226.30311.40535.sendpatchset@localhost.localdomain>
In-Reply-To: <20080121233036.30311.76015.sendpatchset@localhost.localdomain>
References: <20080121233036.30311.76015.sendpatchset@localhost.localdomain>
Subject: [PATCH 16/16] ide: move check_dma_crc() to ide-dma.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Move check_dma_crc() to ide-dma.c and add inline version for
  CONFIG_BLK_DEV_IDEDMA=n case.

* Rename check_dma_crc() to ide_check_dma_crc().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-dma.c  |   20 ++++++++++++++++++++
 drivers/ide/ide-iops.c |   24 +-----------------------
 include/linux/ide.h    |    2 ++
 3 files changed, 23 insertions(+), 23 deletions(-)

Index: b/drivers/ide/ide-dma.c
===================================================================
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -821,6 +821,26 @@ int ide_set_dma(ide_drive_t *drive)
 	return 0;
 }
 
+void ide_check_dma_crc(ide_drive_t *drive)
+{
+	u8 mode;
+
+	ide_dma_off_quietly(drive);
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
+	if (drive->current_speed >= XFER_SW_DMA_0)
+		ide_dma_on(drive);
+}
+
 #ifdef CONFIG_BLK_DEV_IDEDMA_PCI
 void ide_dma_lost_irq (ide_drive_t *drive)
 {
Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -938,28 +938,6 @@ static ide_startstop_t reset_pollfunc (i
 	return ide_stopped;
 }
 
-static void check_dma_crc(ide_drive_t *drive)
-{
-#ifdef CONFIG_BLK_DEV_IDEDMA
-	u8 mode;
-
-	ide_dma_off_quietly(drive);
-	drive->crc_count = 0;
-	mode = drive->current_speed;
-	/*
-	 * Don't try non Ultra-DMA modes without iCRC's.  Force the
-	 * device to PIO and make the user enable SWDMA/MWDMA modes.
-	 */
-	if (mode > XFER_UDMA_0 && mode <= XFER_UDMA_7)
-		mode--;
-	else
-		mode = XFER_PIO_4;
-	ide_set_xfer_rate(drive, mode);
-	if (drive->current_speed >= XFER_SW_DMA_0)
-		ide_dma_on(drive);
-#endif
-}
-
 static void ide_disk_pre_reset(ide_drive_t *drive)
 {
 	int legacy = (drive->id->cfs_enable_2 & 0x0400) ? 0 : 1;
@@ -983,7 +961,7 @@ static void pre_reset(ide_drive_t *drive
 
 	if (drive->using_dma) {
 		if (drive->crc_count)
-			check_dma_crc(drive);
+			ide_check_dma_crc(drive);
 		else
 			ide_dma_off(drive);
 	}
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1158,6 +1158,7 @@ void ide_dma_off_quietly(ide_drive_t *);
 void ide_dma_off(ide_drive_t *);
 void ide_dma_on(ide_drive_t *);
 int ide_set_dma(ide_drive_t *);
+void ide_check_dma_crc(ide_drive_t *);
 ide_startstop_t ide_dma_intr(ide_drive_t *);
 
 int ide_build_sglist(ide_drive_t *, struct request *);
@@ -1185,6 +1186,7 @@ static inline void ide_dma_off(ide_drive
 static inline void ide_dma_on(ide_drive_t *drive) { ; }
 static inline void ide_dma_verbose(ide_drive_t *drive) { ; }
 static inline int ide_set_dma(ide_drive_t *drive) { return 1; }
+static inline void ide_check_dma_crc(ide_drive_t *drive) { ; }
 #endif /* CONFIG_BLK_DEV_IDEDMA */
 
 #ifndef CONFIG_BLK_DEV_IDEDMA_PCI
