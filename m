Return-Path: <linux-kernel-owner+w=401wt.eu-S1758106AbXIBTli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758106AbXIBTli (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 15:41:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750719AbXIBTlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 15:41:31 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:2896 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750715AbXIBTla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 15:41:30 -0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
To: bzolnier@gmail.com
Subject: [PATCH 3/4] ide: make ide_rate_filter() also respect PIO and SW/MW DMA mode masks (take 2)
Date: Sun, 2 Sep 2007 23:44:18 +0400
User-Agent: KMail/1.5
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200709022344.18565.sshtylyov@ru.mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make ide_rate_filter() also respect PIO/SWDMA/MWDMA mode masks.  While at it,
make the udma_filter() method calls take precedence over using the mode masks.

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

---
Alas, the previous version of the patch wasn't even worth signing it off --
the code had to be much trickier. The patch against the current Linus' tree and
unfortunately I was able to only compile test it since that tree gives MODPOST
warning and dies early on bootup. I'm hoping to give it more tesring when/if
I have time... :-)

 drivers/ide/ide-dma.c |    7 +++---
 drivers/ide/ide-lib.c |   57 ++++++++++++++++++++++++++++++--------------------
 2 files changed, 39 insertions(+), 25 deletions(-)

Index: linux-2.6/drivers/ide/ide-dma.c
===================================================================
--- linux-2.6.orig/drivers/ide/ide-dma.c
+++ linux-2.6/drivers/ide/ide-dma.c
@@ -664,10 +664,11 @@ static unsigned int ide_get_mode_mask(id
 		if ((id->field_valid & 4) == 0)
 			break;
 
-		mask = id->dma_ultra & hwif->ultra_mask;
-
 		if (hwif->udma_filter)
-			mask &= hwif->udma_filter(drive);
+			mask = hwif->udma_filter(drive);
+		else
+			mask = hwif->ultra_mask;
+		mask &= id->dma_ultra;
 
 		if ((mask & 0x78) && (eighty_ninty_three(drive) == 0))
 			mask &= 0x07;
Index: linux-2.6/drivers/ide/ide-lib.c
===================================================================
--- linux-2.6.orig/drivers/ide/ide-lib.c
+++ linux-2.6/drivers/ide/ide-lib.c
@@ -75,38 +75,51 @@ EXPORT_SYMBOL(ide_xfer_verbose);
  *
  *	Given the available transfer modes this function returns
  *	the best available speed at or below the speed requested.
- *
- *	FIXME: filter also PIO/SWDMA/MWDMA modes
  */
 
 u8 ide_rate_filter(ide_drive_t *drive, u8 speed)
 {
-#ifdef CONFIG_BLK_DEV_IDEDMA
 	ide_hwif_t *hwif = drive->hwif;
-	u8 mask = hwif->ultra_mask, mode = XFER_MW_DMA_2;
+	u8 mask, base = speed & 0xf8, bit = 1 << (speed & 0x07);
 
-	if (hwif->udma_filter)
-		mask = hwif->udma_filter(drive);
+	switch (base) {
+#ifdef CONFIG_BLK_DEV_IDEDMA
+	case XFER_UDMA_0:
+		mask = hwif->udma_filter ? hwif->udma_filter(drive) :
+					   hwif->ultra_mask;
 
-	/*
-	 * TODO: speed > XFER_UDMA_2 extra check is needed to avoid false
-	 * cable warning from eighty_ninty_three(), moving ide_rate_filter()
-	 * calls from ->speedproc to core code will make this hack go away
-	 */
-	if (speed > XFER_UDMA_2) {
-		if ((mask & 0x78) && (eighty_ninty_three(drive) == 0))
+		/*
+		 * TODO: if speed > XFER_UDMA_2, an extra check is needed to
+		 * avoid a false cable warning from eighty_ninty_three() --
+		 * moving ide_rate_filter() calls from ->speedproc to core
+		 * code will make this hack go away...
+		 */
+		if (speed > XFER_UDMA_2 && (mask & 0x78) &&
+		    eighty_ninty_three(drive) == 0)
 			mask &= 0x07;
-	}
-
-	if (mask)
-		mode = fls(mask) - 1 + XFER_UDMA_0;
 
-//	printk("%s: mode 0x%02x, speed 0x%02x\n", __FUNCTION__, mode, speed);
-
-	return min(speed, mode);
-#else /* !CONFIG_BLK_DEV_IDEDMA */
-	return min(speed, (u8)XFER_PIO_4);
+		if (mask & bit)
+			break;
+		base = XFER_MW_DMA_0;
+		/* Fall thru */
+	case XFER_MW_DMA_0:
+		if (hwif->mwdma_mask & bit)
+			break;
+		base = XFER_SW_DMA_0;
+		/* Fall thru */
+	case XFER_SW_DMA_0:
+		if (hwif->swdma_mask & bit)
+			break;
+		base = XFER_PIO_0;
+		/* Fall thru */
 #endif /* CONFIG_BLK_DEV_IDEDMA */
+	case XFER_PIO_0:
+		if (hwif->pio_mask & bit)
+			break;
+	default:
+		BUG();
+	}
+	return base | bit;
 }
 
 EXPORT_SYMBOL(ide_rate_filter);

