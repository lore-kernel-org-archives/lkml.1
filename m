Return-Path: <linux-kernel-owner+w=401wt.eu-S1753318AbYAHSaF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318AbYAHSaF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 13:30:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752818AbYAHS3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 13:29:52 -0500
Received: from an-out-0708.google.com ([209.85.132.240]:63706 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbYAHS3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 13:29:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=HlKUcSyoC0WPJad3QWocAiDL8kBDTz9XLa7xgQKG179xyPeAl2GIb1Mn0cyxs+G6hWWaUq9ENN3vrynojdTrX0J+YUafyzXTVaWzPcUr6snJNStLDrl1DF4sEv1h97+wQ75MIUkOJS9CgsHofku7/JNTXEeTVtr2cXhuhDO+b1U=
From: Mike Frysinger <vapier.adi@gmail.com>
Organization: ADI
To: drzeus-mmc@drzeus.cx, linux-kernel@vger.kernel.org
Subject: [patch] split MMC_CAP_4_BIT_DATA
Date: Tue, 8 Jan 2008 13:29:39 -0500
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801081329.39611.vapier.adi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The on-chip Blackfin MMC/SD/SDIO host controller has the ability to do 1-bit
MMC, 1-bit/4-bit SD, and 1-bit/4-bit SDIO.  Thus the current convention of
MMC_CAP_4_BIT_DATA meaning "your host controller can do 1-bit or 4-bit for all
modes" is insufficient for our needs.  The attached patch splits
MMC_CAP_4_BIT_DATA into MMC_CAP_MMC_4_BIT_DATA and MMC_CAP_SD_4_BIT_DATA and
updates all host controllers to include these in their caps and then changes
existing code to check the new defines.  At the moment, SD/SDIO are lumped
into MMC_CAP_SD_4_BIT_DATA ... should I bother with splitting that into SD and
SDIO as well while I'm doing this ?

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index 68c0e3b..ca12db7 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -397,7 +397,7 @@ static int mmc_init_card(struct mmc_host *host, u32 ocr,
 	 * Activate wide bus (if supported).
 	 */
 	if ((card->csd.mmca_vsn >= CSD_SPEC_VER_4) &&
-		(host->caps & MMC_CAP_4_BIT_DATA)) {
+		(host->caps & MMC_CAP_MMC_4_BIT_DATA)) {
 		err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
 			EXT_CSD_BUS_WIDTH, EXT_CSD_BUS_WIDTH_4);
 		if (err)
diff --git a/drivers/mmc/core/sd.c b/drivers/mmc/core/sd.c
index d1c1e0f..974b63d 100644
--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -441,7 +441,7 @@ static int mmc_sd_init_card(struct mmc_host *host, u32 ocr,
 	/*
 	 * Switch to wider bus (if supported).
 	 */
-	if ((host->caps & MMC_CAP_4_BIT_DATA) &&
+	if ((host->caps & MMC_CAP_SD_4_BIT_DATA) &&
 		(card->scr.bus_widths & SD_SCR_BUS_WIDTH_4)) {
 		err = mmc_app_set_bus_width(card, MMC_BUS_WIDTH_4);
 		if (err)
diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
index 87a50f4..1d389c8 100644
--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -143,7 +143,7 @@ static int sdio_enable_wide(struct mmc_card *card)
 	int ret;
 	u8 ctrl;
 
-	if (!(card->host->caps & MMC_CAP_4_BIT_DATA))
+	if (!(card->host->caps & MMC_CAP_SD_4_BIT_DATA))
 		return 0;
 
 	if (card->cccr.low_speed && !card->cccr.wide_bus)
diff --git a/drivers/mmc/host/at91_mci.c b/drivers/mmc/host/at91_mci.c
index b1edcef..63d89b0 100644
--- a/drivers/mmc/host/at91_mci.c
+++ b/drivers/mmc/host/at91_mci.c
@@ -851,7 +851,7 @@ static int __init at91_mci_probe(struct platform_device *pdev)
 	host->board = pdev->dev.platform_data;
 	if (host->board->wire4) {
 		if (cpu_is_at91sam9260() || cpu_is_at91sam9263())
-			mmc->caps |= MMC_CAP_4_BIT_DATA;
+			mmc->caps |= (MMC_CAP_SD_4_BIT_DATA | MMC_CAP_MMC_4_BIT_DATA);
 		else
 			printk("AT91 MMC: 4 wire bus mode not supported"
 				" - using 1 wire\n");
diff --git a/drivers/mmc/host/imxmmc.c b/drivers/mmc/host/imxmmc.c
index f2070a1..67d4bc0 100644
--- a/drivers/mmc/host/imxmmc.c
+++ b/drivers/mmc/host/imxmmc.c
@@ -975,7 +975,7 @@ static int imxmci_probe(struct platform_device *pdev)
 	mmc->f_min = 150000;
 	mmc->f_max = CLK_RATE/2;
 	mmc->ocr_avail = MMC_VDD_32_33;
-	mmc->caps = MMC_CAP_4_BIT_DATA;
+	mmc->caps = (MMC_CAP_SD_4_BIT_DATA | MMC_CAP_MMC_4_BIT_DATA);
 
 	/* MMC core transfer sizes tunable parameters */
 	mmc->max_hw_segs = 64;
diff --git a/drivers/mmc/host/omap.c b/drivers/mmc/host/omap.c
index 971e18b..b1ae793 100644
--- a/drivers/mmc/host/omap.c
+++ b/drivers/mmc/host/omap.c
@@ -1079,7 +1079,7 @@ static int __init mmc_omap_probe(struct platform_device *pdev)
 	mmc->caps = MMC_CAP_MULTIWRITE | MMC_CAP_BYTEBLOCK;
 
 	if (minfo->wire4)
-		 mmc->caps |= MMC_CAP_4_BIT_DATA;
+		 mmc->caps |= (MMC_CAP_SD_4_BIT_DATA | MMC_CAP_MMC_4_BIT_DATA);
 
 	/* Use scatterlist DMA to reduce per-transfer costs.
 	 * NOTE max_seg_size assumption that small blocks aren't
diff --git a/drivers/mmc/host/pxamci.c b/drivers/mmc/host/pxamci.c
index 1654a33..4fa00f1 100644
--- a/drivers/mmc/host/pxamci.c
+++ b/drivers/mmc/host/pxamci.c
@@ -527,7 +527,7 @@ static int pxamci_probe(struct platform_device *pdev)
 	mmc->caps = 0;
 	host->cmdat = 0;
 	if (!cpu_is_pxa21x() && !cpu_is_pxa25x()) {
-		mmc->caps |= MMC_CAP_4_BIT_DATA | MMC_CAP_SDIO_IRQ;
+		mmc->caps |= MMC_CAP_SD_4_BIT_DATA | MMC_CAP_MMC_4_BIT_DATA | MMC_CAP_SDIO_IRQ;
 		host->cmdat |= CMDAT_SDIO_INT_EN;
 	}
 
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 785bbdc..09c4358 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1405,7 +1405,7 @@ static int __devinit sdhci_probe_slot(struct pci_dev *pdev, int slot)
 	mmc->ops = &sdhci_ops;
 	mmc->f_min = host->max_clk / 256;
 	mmc->f_max = host->max_clk;
-	mmc->caps = MMC_CAP_4_BIT_DATA | MMC_CAP_MULTIWRITE | MMC_CAP_SDIO_IRQ;
+	mmc->caps = MMC_CAP_SD_4_BIT_DATA | MMC_CAP_MMC_4_BIT_DATA | MMC_CAP_MULTIWRITE | MMC_CAP_SDIO_IRQ;
 
 	if (caps & SDHCI_CAN_DO_HISPD)
 		mmc->caps |= MMC_CAP_SD_HIGHSPEED;
diff --git a/drivers/mmc/host/tifm_sd.c b/drivers/mmc/host/tifm_sd.c
index 20d5c7b..78cad6b 100644
--- a/drivers/mmc/host/tifm_sd.c
+++ b/drivers/mmc/host/tifm_sd.c
@@ -973,7 +973,7 @@ static int tifm_sd_probe(struct tifm_dev *sock)
 
 	mmc->ops = &tifm_sd_ops;
 	mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34;
-	mmc->caps = MMC_CAP_4_BIT_DATA | MMC_CAP_MULTIWRITE;
+	mmc->caps = MMC_CAP_SD_4_BIT_DATA | MMC_CAP_MMC_4_BIT_DATA | MMC_CAP_MULTIWRITE;
 	mmc->f_min = 20000000 / 60;
 	mmc->f_max = 24000000;
 
diff --git a/drivers/mmc/host/wbsd.c b/drivers/mmc/host/wbsd.c
index 4d5f374..70d6071 100644
--- a/drivers/mmc/host/wbsd.c
+++ b/drivers/mmc/host/wbsd.c
@@ -1219,7 +1219,7 @@ static int __devinit wbsd_alloc_mmc(struct device *dev)
 	mmc->f_min = 375000;
 	mmc->f_max = 24000000;
 	mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34;
-	mmc->caps = MMC_CAP_4_BIT_DATA | MMC_CAP_MULTIWRITE;
+	mmc->caps = MMC_CAP_SD_4_BIT_DATA | MMC_CAP_MMC_4_BIT_DATA | MMC_CAP_MULTIWRITE;
 
 	spin_lock_init(&host->lock);
 
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index 7ab962f..142fa69 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -88,12 +88,13 @@ struct mmc_host {
 
 	unsigned long		caps;		/* Host capabilities */
 
-#define MMC_CAP_4_BIT_DATA	(1 << 0)	/* Can the host do 4 bit transfers */
+#define MMC_CAP_SD_4_BIT_DATA	(1 << 0)	/* Can the host do SD 4 bit transfers */
 #define MMC_CAP_MULTIWRITE	(1 << 1)	/* Can accurately report bytes sent to card on error */
 #define MMC_CAP_MMC_HIGHSPEED	(1 << 2)	/* Can do MMC high-speed timing */
 #define MMC_CAP_SD_HIGHSPEED	(1 << 3)	/* Can do SD high-speed timing */
 #define MMC_CAP_SDIO_IRQ	(1 << 4)	/* Can signal pending SDIO IRQs */
 #define MMC_CAP_SPI		(1 << 5)	/* Talks only SPI protocols */
+#define MMC_CAP_MMC_4_BIT_DATA	(1 << 6)	/* Can the host do MMC 4 bit transfers */
 
 	/* host specific block data */
 	unsigned int		max_seg_size;	/* see blk_queue_max_segment_size */
