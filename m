Return-Path: <linux-kernel-owner+w=401wt.eu-S1755727Ab0ARR3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727Ab0ARR3k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:29:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753839Ab0ARRTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:19:15 -0500
Received: from mail-ew0-f214.google.com ([209.85.219.214]:52797 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754881Ab0ARRTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:19:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=B6n8ZujZoVvvi+4CndHidN5okGA15l+OnHNojzoNpHVKhZmAk+k8+1T62OTZOW06nT
         VCk+pEZVv2Vf5zFD4/zoBbDJyfiZJv4o8WxsDCjtErEWuEMEmX58uxCvzR8PQ/o8mQEm
         at3766DkS382doprVxIQCbjH/7c8FiQhccvZ8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 18 Jan 2010 18:17:37 +0100
Message-Id: <20100118171737.14623.10091.sendpatchset@localhost>
In-Reply-To: <20100118171349.14623.90030.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
Subject: [PATCH 26/64] alim15x3: fix PIO timings calculations
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] alim15x3: fix PIO timings calculations

Just use the standard ide_timing_compute() helper to calculate
PIO timings.  This fixes many issues with the open-coded version
like potential recovery timings underclocking or not accounting
for the enhanced cycle time specified by the device.

Based on libata pata_ali host driver.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/alim15x3.c |   34 +++++++++++++++-------------------
 1 file changed, 15 insertions(+), 19 deletions(-)

Index: b/drivers/ide/alim15x3.c
===================================================================
--- a/drivers/ide/alim15x3.c
+++ b/drivers/ide/alim15x3.c
@@ -8,7 +8,7 @@
  *  Copyright (C) 2002 Alan Cox
  *  ALi (now ULi M5228) support by Clear Zhang <Clear.Zhang@ali.com.tw>
  *  Copyright (C) 2007 MontaVista Software, Inc. <source@mvista.com>
- *  Copyright (C) 2007 Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
+ *  Copyright (C) 2007-2010 Bartlomiej Zolnierkiewicz
  *
  *  (U)DMA capable version of ali 1533/1543(C), 1535(D)
  *
@@ -60,28 +60,22 @@ static void ali_set_pio_mode(ide_drive_t
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
-	struct ide_timing *t = ide_timing_find_mode(XFER_PIO_0 + pio);
-	int s_time = t->setup, a_time = t->active, c_time = t->cycle;
-	u8 s_clc, a_clc, r_clc;
 	unsigned long flags;
 	int bus_speed = ide_pci_clk ? ide_pci_clk : 33;
+	unsigned long T =  1000000 / bus_speed; /* PCI clock based */
 	int port = hwif->channel ? 0x5c : 0x58;
 	int portFIFO = hwif->channel ? 0x55 : 0x54;
 	u8 cd_dma_fifo = 0, unit = drive->dn & 1;
+	struct ide_timing t;
 
-	if ((s_clc = (s_time * bus_speed + 999) / 1000) >= 8)
-		s_clc = 0;
-	if ((a_clc = (a_time * bus_speed + 999) / 1000) >= 8)
-		a_clc = 0;
+	ide_timing_compute(drive, XFER_PIO_0 + pio, &t, T, 1);
+
+	t.setup = clamp_val(t.setup, 1, 8) & 7;
+	t.active = clamp_val(t.active, 1, 8) & 7;
+	t.recover = clamp_val(t.recover, 1, 16) & 15;
 
-	if (!(r_clc = (c_time * bus_speed + 999) / 1000 - a_clc - s_clc)) {
-		r_clc = 1;
-	} else {
-		if (r_clc >= 16)
-			r_clc = 0;
-	}
 	local_irq_save(flags);
-	
+
 	/* 
 	 * PIO mode => ATA FIFO on, ATAPI FIFO off
 	 */
@@ -99,9 +93,11 @@ static void ali_set_pio_mode(ide_drive_t
 			pci_write_config_byte(dev, portFIFO, cd_dma_fifo & 0xF0);
 		}
 	}
-	
-	pci_write_config_byte(dev, port, s_clc);
-	pci_write_config_byte(dev, port + unit + 2, (a_clc << 4) | r_clc);
+
+	pci_write_config_byte(dev, port, t.setup);
+	pci_write_config_byte(dev, port + unit + 2,
+			      (t.active << 4) | t.recover);
+
 	local_irq_restore(flags);
 }
 
@@ -584,6 +580,6 @@ static void __exit ali15x3_ide_exit(void
 module_init(ali15x3_ide_init);
 module_exit(ali15x3_ide_exit);
 
-MODULE_AUTHOR("Michael Aubry, Andrzej Krzysztofowicz, CJ, Andre Hedrick, Alan Cox");
+MODULE_AUTHOR("Michael Aubry, Andrzej Krzysztofowicz, CJ, Andre Hedrick, Alan Cox, Bartlomiej Zolnierkiewicz");
 MODULE_DESCRIPTION("PCI driver module for ALi 15x3 IDE");
 MODULE_LICENSE("GPL");
