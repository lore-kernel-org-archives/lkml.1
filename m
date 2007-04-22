Return-Path: <linux-kernel-owner+w=401wt.eu-S1754282AbXDVSEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282AbXDVSEe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 14:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754288AbXDVSEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 14:04:34 -0400
Received: from h155.mvista.com ([63.81.120.155]:56241 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754275AbXDVSEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 14:04:33 -0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
To: bzolnier@gmail.com, codermattie@gmail.com
Subject: [PATCH pata-2.6 fix queue] aec62xx: fix PIO/DMA setup issues
Date: Sun, 22 Apr 2007 22:05:27 +0400
User-Agent: KMail/1.5
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200702032309.43867.sshtylyov@ru.mvista.com> <200702040004.24918.sshtylyov@ru.mvista.com> <200702162321.40813.sshtylyov@ru.mvista.com>
In-Reply-To: <200702162321.40813.sshtylyov@ru.mvista.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200704222205.27410.sshtylyov@ru.mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Teach the driver's tuneproc() method to do PIO auto-runing properly since it
treated 5 instead of 255 as auto-tune request, and also passed the mode limit
of PIO5 to ide_get_best_pio_mode() despite supporting up to PIO4 only.

While at it, also:

- remove the driver's wrong claim about supporting SWDMA modes;

- stop hooking ide_dma_timeout() method as the handler clearly doesn't fit for
  the task...

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

---
Warning: the patch has only been compile tested (the driver was on the way of
some cleanup -- that's why I got around to fixing it :-).

 drivers/ide/pci/aec62xx.c |   22 ++++++----------------
 1 files changed, 6 insertions(+), 16 deletions(-)

Index: linux-2.6/drivers/ide/pci/aec62xx.c
===================================================================
--- linux-2.6.orig/drivers/ide/pci/aec62xx.c
+++ linux-2.6/drivers/ide/pci/aec62xx.c
@@ -1,7 +1,8 @@
 /*
- * linux/drivers/ide/pci/aec62xx.c		Version 0.11	March 27, 2002
+ * linux/drivers/ide/pci/aec62xx.c		Version 0.21	Apr 21, 2007
  *
  * Copyright (C) 1999-2002	Andre Hedrick <andre@linux-ide.org>
+ * Copyright (C) 2007		MontaVista Software, Inc. <source@mvista.com>
  *
  */
 
@@ -193,18 +194,8 @@ static int config_chipset_for_dma (ide_d
 
 static void aec62xx_tune_drive (ide_drive_t *drive, u8 pio)
 {
-	u8 speed = 0;
-	u8 new_pio = XFER_PIO_0 + ide_get_best_pio_mode(drive, 255, 5, NULL);
-
-	switch(pio) {
-		case 5:		speed = new_pio; break;
-		case 4:		speed = XFER_PIO_4; break;
-		case 3:		speed = XFER_PIO_3; break;
-		case 2:		speed = XFER_PIO_2; break;
-		case 1:		speed = XFER_PIO_1; break;
-		default:	speed = XFER_PIO_0; break;
-	}
-	(void) aec62xx_tune_chipset(drive, speed);
+	pio = ide_get_best_pio_mode(drive, pio, 4, NULL);
+	(void) aec62xx_tune_chipset(drive, pio + XFER_PIO_0);
 }
 
 static int aec62xx_config_drive_xfer_rate (ide_drive_t *drive)
@@ -213,7 +204,7 @@ static int aec62xx_config_drive_xfer_rat
 		return 0;
 
 	if (ide_use_fast_pio(drive))
-		aec62xx_tune_drive(drive, 5);
+		aec62xx_tune_drive(drive, 255);
 
 	return -1;
 }
@@ -288,11 +279,10 @@ static void __devinit init_hwif_aec62xx(
 
 	hwif->ultra_mask = 0x7f;
 	hwif->mwdma_mask = 0x07;
-	hwif->swdma_mask = 0x07;
 
 	hwif->ide_dma_check	= &aec62xx_config_drive_xfer_rate;
 	hwif->ide_dma_lostirq	= &aec62xx_irq_timeout;
-	hwif->ide_dma_timeout	= &aec62xx_irq_timeout;
+
 	if (!noautodma)
 		hwif->autodma = 1;
 	hwif->drives[0].autodma = hwif->autodma;

