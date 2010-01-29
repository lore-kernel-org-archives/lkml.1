Return-Path: <linux-kernel-owner+w=401wt.eu-S1753113Ab0A2QKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113Ab0A2QKb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:10:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932160Ab0A2QKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:10:22 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:53041 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755931Ab0A2QKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:10:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=VD33EK7LXzEx5byzXRs0Chp9u5+7fCLRKhlWMdPjavik2/EOtaOOHuC/kpooNxYZAV
         WUZ2/AEi2B6sL7fjDwlzeV8a4SuJa6oJ+fCCiCfnSI71wXxFr3fP+6QgmXvO0L4jwG4j
         K7L1/PIGI+KOYPtZhex/SzBy/pXXANqxcUgEc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 29 Jan 2010 17:10:07 +0100
Message-Id: <20100129161007.21495.57251.sendpatchset@localhost>
In-Reply-To: <20100129160308.21495.14120.sendpatchset@localhost>
References: <20100129160308.21495.14120.sendpatchset@localhost>
Subject: [PATCH 65/68] triflex: convert to ide2libata
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] triflex: convert to ide2libata

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/triflex.c |   57 +++++---------------------------------------------
 1 file changed, 6 insertions(+), 51 deletions(-)

Index: b/drivers/ide/triflex.c
===================================================================
--- a/drivers/ide/triflex.c
+++ b/drivers/ide/triflex.c
@@ -34,62 +34,17 @@
 
 #define DRV_NAME "triflex"
 
-static void triflex_set_mode(ide_hwif_t *hwif, ide_drive_t *drive)
-{
-	struct pci_dev *dev = to_pci_dev(hwif->dev);
-	u32 triflex_timings = 0;
-	u16 timing = 0;
-	u8 channel_offset = hwif->channel ? 0x74 : 0x70, unit = drive->dn & 1;
-
-	pci_read_config_dword(dev, channel_offset, &triflex_timings);
-
-	switch (drive->dma_mode) {
-		case XFER_MW_DMA_2:
-			timing = 0x0103; 
-			break;
-		case XFER_MW_DMA_1:
-			timing = 0x0203;
-			break;
-		case XFER_MW_DMA_0:
-			timing = 0x0808;
-			break;
-		case XFER_SW_DMA_2:
-		case XFER_SW_DMA_1:
-		case XFER_SW_DMA_0:
-			timing = 0x0f0f;
-			break;
-		case XFER_PIO_4:
-			timing = 0x0202;
-			break;
-		case XFER_PIO_3:
-			timing = 0x0204;
-			break;
-		case XFER_PIO_2:
-			timing = 0x0404;
-			break;
-		case XFER_PIO_1:
-			timing = 0x0508;
-			break;
-		case XFER_PIO_0:
-			timing = 0x0808;
-			break;
-	}
-
-	triflex_timings &= ~(0xFFFF << (16 * unit));
-	triflex_timings |= (timing << (16 * unit));
-	
-	pci_write_config_dword(dev, channel_offset, triflex_timings);
-}
+#include <linux/ide2libata.h>
+#include "../ata/pata_triflex.h"
 
-static void triflex_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
+static void triflex_set_dmamode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
-	drive->dma_mode = drive->pio_mode;
-	triflex_set_mode(hwif, drive);
+	triflex_load_timing(hwif, drive, drive->dma_mode);
 }
 
 static const struct ide_port_ops triflex_port_ops = {
-	.set_pio_mode		= triflex_set_pio_mode,
-	.set_dma_mode		= triflex_set_mode,
+	.set_pio_mode		= triflex_set_piomode,
+	.set_dma_mode		= triflex_set_dmamode,
 };
 
 static const struct ide_port_info triflex_device __devinitdata = {
