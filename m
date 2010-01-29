Return-Path: <linux-kernel-owner+w=401wt.eu-S1754473Ab0A2QHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473Ab0A2QHJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:07:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754831Ab0A2QG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:06:57 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:53041 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502Ab0A2QGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:06:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=KLye+jECieANIXrbw4AXvzX67Y2CWOgGeHSZYK483lesRU+YpPi7GyQyvjesdoYIaq
         tU9mT6LQW99NoAGInSTZ/ybyYwZfpDw3Gsct54Ug3svd5eH+PD61I/VnGq5LPfPqUNMZ
         aoh1iVW6pqhKBPzdgI7UByEbj1YjipkSx2ZMA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 29 Jan 2010 17:06:47 +0100
Message-Id: <20100129160647.21495.41249.sendpatchset@localhost>
In-Reply-To: <20100129160308.21495.14120.sendpatchset@localhost>
References: <20100129160308.21495.14120.sendpatchset@localhost>
Subject: [PATCH 34/68] amd74xx: convert to ide2libata
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] amd74xx: convert to ide2libata

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_amd.h |    2 +
 drivers/ide/amd74xx.c  |   85 +++++++++++++------------------------------------
 2 files changed, 25 insertions(+), 62 deletions(-)

Index: b/drivers/ata/pata_amd.h
===================================================================
--- a/drivers/ata/pata_amd.h
+++ b/drivers/ata/pata_amd.h
@@ -25,7 +25,9 @@ static void timing_setup(struct ata_port
 	int dn = ap->port_no * 2 + adev->devno;
 	struct ata_timing at, apeer;
 	int T, UT;
+#ifndef __IDE2LIBATA
 	const int amd_clock = 33333;	/* KHz. */
+#endif
 	u8 t;
 
 	T = 1000000000 / amd_clock;
Index: b/drivers/ide/amd74xx.c
===================================================================
--- a/drivers/ide/amd74xx.c
+++ b/drivers/ide/amd74xx.c
@@ -26,9 +26,6 @@
 enum {
 	AMD_IDE_CONFIG		= 0x41,
 	AMD_CABLE_DETECT	= 0x42,
-	AMD_DRIVE_TIMING	= 0x48,
-	AMD_8BIT_TIMING		= 0x4e,
-	AMD_ADDRESS_SETUP	= 0x4c,
 	AMD_UDMA_TIMING		= 0x50,
 };
 
@@ -36,83 +33,47 @@ static unsigned int amd_80w;
 static unsigned int amd_clock;
 
 static char *amd_dma[] = { "16", "25", "33", "44", "66", "100", "133" };
-static unsigned char amd_cyc2udma[] = { 6, 6, 5, 4, 0, 1, 1, 2, 2, 3, 3, 3, 3, 3, 3, 7 };
 
 static inline u8 amd_offset(struct pci_dev *dev)
 {
 	return (dev->vendor == PCI_VENDOR_ID_NVIDIA) ? 0x10 : 0;
 }
 
-/*
- * amd_set_speed() writes timing values to the chipset registers
- */
+#include <linux/ide2libata.h>
+#include "../ata/pata_amd.h"
 
-static void amd_set_speed(struct pci_dev *dev, u8 dn, u8 udma_mask,
-			  struct ata_timing *timing)
+static int amd_get_clock(ide_hwif_t *hwif)
 {
-	u8 t = 0, offset = amd_offset(dev);
+	int clock = 0;
 
-	pci_read_config_byte(dev, AMD_ADDRESS_SETUP + offset, &t);
-	t = (t & ~(3 << ((3 - dn) << 1))) | ((clamp_val(timing->setup, 1, 4) - 1) << ((3 - dn) << 1));
-	pci_write_config_byte(dev, AMD_ADDRESS_SETUP + offset, t);
-
-	pci_write_config_byte(dev, AMD_8BIT_TIMING + offset + (1 - (dn >> 1)),
-		((clamp_val(timing->act8b, 1, 16) - 1) << 4) | (clamp_val(timing->rec8b, 1, 16) - 1));
-
-	pci_write_config_byte(dev, AMD_DRIVE_TIMING + offset + (3 - dn),
-		((clamp_val(timing->active, 1, 16) - 1) << 4) | (clamp_val(timing->recover, 1, 16) - 1));
-
-	switch (udma_mask) {
-	case ATA_UDMA2: t = timing->udma ? (0xc0 | (clamp_val(timing->udma, 2, 5) - 2)) : 0x03; break;
-	case ATA_UDMA4: t = timing->udma ? (0xc0 | amd_cyc2udma[clamp_val(timing->udma, 2, 10)]) : 0x03; break;
-	case ATA_UDMA5: t = timing->udma ? (0xc0 | amd_cyc2udma[clamp_val(timing->udma, 1, 10)]) : 0x03; break;
-	case ATA_UDMA6: t = timing->udma ? (0xc0 | amd_cyc2udma[clamp_val(timing->udma, 1, 15)]) : 0x03; break;
-	default: return;
-	}
+	switch (hwif->udma_mask) {
+	case ATA_UDMA2:
+		clock = 1; break;
+	case ATA_UDMA4:
+		clock = 2; break;
+	case ATA_UDMA5:
+		clock = 3; break;
+	case ATA_UDMA6:
+		clock = 4; break;
+	};
 
-	if (timing->udma)
-		pci_write_config_byte(dev, AMD_UDMA_TIMING + offset + 3 - dn, t);
+	return clock;
 }
 
 /*
- * amd_set_drive() computes timing values and configures the chipset
- * to a desired transfer mode.  It also can be called by upper layers.
+ * amd_set_pio_mode() is a callback from upper layers for PIO-only tuning.
  */
 
-static void amd_set_drive(ide_hwif_t *hwif, ide_drive_t *drive)
+static void amd_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
-	struct pci_dev *dev = to_pci_dev(hwif->dev);
-	ide_drive_t *peer = ide_get_pair_dev(drive);
-	struct ata_timing t, p;
-	int T, UT;
-	u8 udma_mask = hwif->ultra_mask;
-	const u8 speed = drive->dma_mode;
-
-	T = 1000000000 / amd_clock;
-	UT = (udma_mask == ATA_UDMA2) ? T : (T / 2);
-
-	ata_timing_compute(drive->id, speed, drive->pio_mode, &t, T, UT);
-
-	if (peer) {
-		ata_timing_compute(peer->id, peer->pio_mode,
-				   peer->pio_mode, &p, T, UT);
-		ata_timing_merge(&p, &t, &t, ATA_TIMING_8BIT);
-	}
-
-	if (speed == XFER_UDMA_5 && amd_clock <= 33333) t.udma = 1;
-	if (speed == XFER_UDMA_6 && amd_clock <= 33333) t.udma = 15;
-
-	amd_set_speed(dev, drive->dn, udma_mask, &t);
+	timing_setup(hwif, drive, 0x40 + amd_offset(to_pci_dev(hwif->dev)),
+		     drive->pio_mode, amd_get_clock(hwif));
 }
 
-/*
- * amd_set_pio_mode() is a callback from upper layers for PIO-only tuning.
- */
-
-static void amd_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
+static void amd_set_dma_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
-	drive->dma_mode = drive->pio_mode;
-	amd_set_drive(hwif, drive);
+	timing_setup(hwif, drive, 0x40 + amd_offset(to_pci_dev(hwif->dev)),
+		     drive->dma_mode, amd_get_clock(hwif));
 }
 
 static void amd7409_cable_detect(struct pci_dev *dev)
@@ -188,7 +149,7 @@ static int amd_cable_detect(ide_hwif_t *
 
 static const struct ide_port_ops amd_port_ops = {
 	.set_pio_mode		= amd_set_pio_mode,
-	.set_dma_mode		= amd_set_drive,
+	.set_dma_mode		= amd_set_dma_mode,
 	.cable_detect		= amd_cable_detect,
 };
 
