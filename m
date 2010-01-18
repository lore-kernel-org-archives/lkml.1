Return-Path: <linux-kernel-owner+w=401wt.eu-S1755591Ab0ARRZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591Ab0ARRZp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:25:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754923Ab0ARRWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:22:54 -0500
Received: from mail-ew0-f214.google.com ([209.85.219.214]:52797 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755453Ab0ARRWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:22:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Es3ob2rfFrW9JyuA/pmVW7MLw+srtMNLrWmroKO7KgxM9YVa1IobmnOEnng5cdjpfV
         ZeAAPN5sGQduYtNp38xogR01icSSc0lu9bOwHqE6vWHXkl86oOF5L5RrxaZ8eC/XtROK
         BFxuN5bfsCdZGsFSFHugWtgmdGUNgrbGlcUSw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 18 Jan 2010 18:21:26 +0100
Message-Id: <20100118172126.14623.55960.sendpatchset@localhost>
In-Reply-To: <20100118171349.14623.90030.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
Subject: [PATCH 54/64] alim15x3: fix handling of UDMA enable bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] alim15x3: fix handling of UDMA enable bit

Clear UDMA enable bit also for PIO modes.

Based on libata pata_ali host driver.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/alim15x3.c |   43 ++++++++++++++++++-------------------------
 1 file changed, 18 insertions(+), 25 deletions(-)

Index: b/drivers/ide/alim15x3.c
===================================================================
--- a/drivers/ide/alim15x3.c
+++ b/drivers/ide/alim15x3.c
@@ -62,11 +62,22 @@ static void ali_fifo_control(ide_hwif_t
 }
 
 static void ali_program_timings(ide_hwif_t *hwif, ide_drive_t *drive,
-				struct ide_timing *t)
+				struct ide_timing *t, u8 ultra)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	int port = hwif->channel ? 0x5c : 0x58;
-	u8 unit = drive->dn & 1;
+	int udmat = 0x56 + hwif->channel;
+	u8 unit = drive->dn & 1, udma;
+	int shift = 4 * unit;
+
+	/* Set up the UDMA */
+	pci_read_config_byte(dev, udmat, &udma);
+	udma &= ~(0x0F << shift);
+	udma |= ultra << shift;
+	pci_write_config_byte(dev, udmat, udma);
+
+	if (t == NULL)
+		return;
 
 	t->setup = clamp_val(t->setup, 1, 8) & 7;
 	t->act8b = clamp_val(t->act8b, 1, 8) & 7;
@@ -114,7 +125,7 @@ static void ali_set_pio_mode(ide_hwif_t
 	 */
 	ali_fifo_control(hwif, drive, (drive->media == ide_disk) ? 0x05 : 0x00);
 
-	ali_program_timings(hwif, drive, &t);
+	ali_program_timings(hwif, drive, &t, 0);
 }
 
 /**
@@ -152,29 +163,16 @@ static u8 ali_udma_filter(ide_drive_t *d
 
 static void ali_set_dma_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
+	static u8 udma_timing[7] = { 0xC, 0xB, 0xA, 0x9, 0x8, 0xF, 0xD };
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	ide_drive_t *pair	= ide_get_pair_dev(drive);
 	int bus_speed		= ide_pci_clk ? ide_pci_clk : 33;
 	unsigned long T		=  1000000 / bus_speed; /* PCI clock based */
 	const u8 speed		= drive->dma_mode;
-	u8 speed1		= speed;
-	u8 unit			= drive->dn & 1;
 	u8 tmpbyte		= 0x00;
-	int m5229_udma		= (hwif->channel) ? 0x57 : 0x56;
 	struct ide_timing t;
 
-	if (speed == XFER_UDMA_6)
-		speed1 = 0x47;
-
 	if (speed < XFER_UDMA_0) {
-		u8 ultra_enable	= (unit) ? 0x7f : 0xf7;
-		/*
-		 * clear "ultra enable" bit
-		 */
-		pci_read_config_byte(dev, m5229_udma, &tmpbyte);
-		tmpbyte &= ultra_enable;
-		pci_write_config_byte(dev, m5229_udma, tmpbyte);
-
 		ide_timing_compute(drive, drive->dma_mode, &t, T, 1);
 		if (pair) {
 			struct ide_timing p;
@@ -189,15 +187,10 @@ static void ali_set_dma_mode(ide_hwif_t
 					IDE_TIMING_SETUP | IDE_TIMING_8BIT);
 			}
 		}
-		ali_program_timings(hwif, drive, &t);
+		ali_program_timings(hwif, drive, &t, 0);
 	} else {
-		pci_read_config_byte(dev, m5229_udma, &tmpbyte);
-		tmpbyte &= (0x0f << ((1-unit) << 2));
-		/*
-		 * enable ultra dma and set timing
-		 */
-		tmpbyte |= ((0x08 | ((4-speed1)&0x07)) << (unit << 2));
-		pci_write_config_byte(dev, m5229_udma, tmpbyte);
+		ali_program_timings(hwif, drive, NULL,
+				udma_timing[speed - XFER_UDMA_0]);
 		if (speed >= XFER_UDMA_3) {
 			pci_read_config_byte(dev, 0x4b, &tmpbyte);
 			tmpbyte |= 1;
