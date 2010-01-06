Return-Path: <linux-kernel-owner+w=401wt.eu-S1752082Ab0AFFWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082Ab0AFFWA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 00:22:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751274Ab0AFFV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 00:21:59 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:42481 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207Ab0AFFV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 00:21:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=JWzpyRvvfk1+MslPw/4w4d8FAAqopGirtsX9HZmVe/qZeq4Kh3fZMiX2gpTz8tvVgx
         eNFvi+3S5oG2QuoGrW36RHy7jx2paN6Q3cCaQ13rEMvCdFzIi9YqghBLasKGwDcW6RnZ
         Fix3DJDdb7HwHei+U6lIC+M6EyZaJDOnzsNGs=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: ian@mnementh.co.uk, Magnus Damm <magnus.damm@gmail.com>,
       sameo@linux.intel.com, linux-sh@vger.kernel.org
Date: Wed, 06 Jan 2010 14:15:36 +0900
Message-Id: <20100106051536.4619.851.sendpatchset@rxone.opensource.se>
Subject: [PATCH] MMC: hardware abstraction for CNF area fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

This patch contains fixes for the recently posted
"[PATCH] MMC: hardware abstraction for CNF area".

Changes:
 - move struct resources
 - drop ->suspend(), ->resume(), ->disable() changes
 - a few cosmetic changes
 - replace tmio_core shift with function argument
 - rename ->set_no_clk_div() to ->set_clk_div()

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 This patch has been lightly tested on the KFR2R09 board
 using tmio_mmc together with sh_mobile_sdhi. Other mfd
 drivers are untested.

 drivers/mfd/asic3.c         |   13 +++++--------
 drivers/mfd/t7l66xb.c       |   36 +++++++++++++++++-------------------
 drivers/mfd/tc6387xb.c      |   36 +++++++++++++++++-------------------
 drivers/mfd/tc6393xb.c      |    8 ++++----
 drivers/mfd/tmio_core.c     |   20 +++++---------------
 drivers/mmc/host/tmio_mmc.c |   10 +++++-----
 drivers/mmc/host/tmio_mmc.h |    2 +-
 include/linux/mfd/tmio.h    |   11 +++++------
 8 files changed, 59 insertions(+), 77 deletions(-)

--- 0002/drivers/mfd/asic3.c
+++ work/drivers/mfd/asic3.c	2010-01-06 13:22:40.000000000 +0900
@@ -690,20 +690,20 @@ static void asic3_mmc_pwr(struct platfor
 {
 	struct asic3 *asic = dev_get_drvdata(pdev->dev.parent);
 
-	tmio_core_mmc_pwr(asic->tmio_cnf, state);
+	tmio_core_mmc_pwr(asic->tmio_cnf, 1 - asic->bus_shift, state);
 }
 
 static void asic3_mmc_clk_div(struct platform_device *pdev, int state)
 {
 	struct asic3 *asic = dev_get_drvdata(pdev->dev.parent);
 
-	tmio_core_mmc_clk_div(asic->tmio_cnf, state);
+	tmio_core_mmc_clk_div(asic->tmio_cnf, 1 - asic->bus_shift, state);
 }
 
 static struct tmio_mmc_data asic3_mmc_data = {
 	.hclk           = 24576000,
 	.set_pwr        = asic3_mmc_pwr,
-	.set_no_clk_div = asic3_mmc_clk_div,
+	.set_clk_div    = asic3_mmc_clk_div,
 };
 
 static struct resource asic3_mmc_resources[] = {
@@ -756,7 +756,8 @@ static int asic3_mmc_enable(struct platf
 			   ASIC3_SDHWCTRL_SDPWR, 1);
 
 	/* ASIC3_SD_CTRL_BASE assumes 32-bit addressing, TMIO is 16-bit */
-	tmio_core_mmc_enable(asic->tmio_cnf, ASIC3_SD_CTRL_BASE >> 1);
+	tmio_core_mmc_enable(asic->tmio_cnf, 1 - asic->bus_shift,
+			     ASIC3_SD_CTRL_BASE >> 1);
 
 	return 0;
 }
@@ -781,8 +782,6 @@ static struct mfd_cell asic3_cell_mmc = 
 	.name          = "tmio-mmc",
 	.enable        = asic3_mmc_enable,
 	.disable       = asic3_mmc_disable,
-	.suspend       = asic3_mmc_disable,
-	.resume        = asic3_mmc_enable,
 	.driver_data   = &asic3_mmc_data,
 	.num_resources = ARRAY_SIZE(asic3_mmc_resources),
 	.resources     = asic3_mmc_resources,
@@ -827,8 +826,6 @@ static int __init asic3_mfd_probe(struct
 	asic3_cell_mmc.platform_data = &asic3_cell_mmc;
 	asic3_cell_mmc.data_size = sizeof(asic3_cell_mmc);
 
-	tmio_core_set_bus_shift(1 - asic->bus_shift);
-
 	ret = mfd_add_devices(&pdev->dev, pdev->id,
 			&asic3_cell_ds1wm, 1, mem, asic->irq_base);
 	if (ret < 0)
--- 0002/drivers/mfd/t7l66xb.c
+++ work/drivers/mfd/t7l66xb.c	2010-01-06 13:18:44.000000000 +0900
@@ -38,7 +38,18 @@ enum {
 	T7L66XB_CELL_MMC,
 };
 
-static const struct resource t7l66xb_mmc_resources[];
+static const struct resource t7l66xb_mmc_resources[] = {
+	{
+		.start = 0x800,
+		.end	= 0x9ff,
+		.flags = IORESOURCE_MEM,
+	},
+	{
+		.start = IRQ_T7L66XB_MMC,
+		.end	= IRQ_T7L66XB_MMC,
+		.flags = IORESOURCE_IRQ,
+	},
+};
 
 #define SCR_REVID	0x08		/* b Revision ID	*/
 #define SCR_IMR		0x42		/* b Interrupt Mask	*/
@@ -85,7 +96,7 @@ static int t7l66xb_mmc_enable(struct pla
 
 	spin_unlock_irqrestore(&t7l66xb->lock, flags);
 
-	tmio_core_mmc_enable(t7l66xb->scr + 0x200,
+	tmio_core_mmc_enable(t7l66xb->scr + 0x200, 0,
 		t7l66xb_mmc_resources[0].start & 0xfffe);
 
 	return 0;
@@ -116,7 +127,7 @@ static void t7l66xb_mmc_pwr(struct platf
 	struct platform_device *dev = to_platform_device(mmc->dev.parent);
 	struct t7l66xb *t7l66xb = platform_get_drvdata(dev);
 
-	tmio_core_mmc_pwr(t7l66xb->scr + 0x200, state);
+	tmio_core_mmc_pwr(t7l66xb->scr + 0x200, 0, state);
 }
 
 static void t7l66xb_mmc_clk_div(struct platform_device *mmc, int state)
@@ -124,7 +135,7 @@ static void t7l66xb_mmc_clk_div(struct p
 	struct platform_device *dev = to_platform_device(mmc->dev.parent);
 	struct t7l66xb *t7l66xb = platform_get_drvdata(dev);
 
-	tmio_core_mmc_clk_div(t7l66xb->scr + 0x200, state);
+	tmio_core_mmc_clk_div(t7l66xb->scr + 0x200, 0, state);
 }
 
 /*--------------------------------------------------------------------------*/
@@ -132,20 +143,7 @@ static void t7l66xb_mmc_clk_div(struct p
 static struct tmio_mmc_data t7166xb_mmc_data = {
 	.hclk = 24000000,
 	.set_pwr = t7l66xb_mmc_pwr,
-	.set_no_clk_div = t7l66xb_mmc_clk_div,
-};
-
-static const struct resource t7l66xb_mmc_resources[] = {
-	{
-		.start = 0x800,
-		.end	= 0x9ff,
-		.flags = IORESOURCE_MEM,
-	},
-	{
-		.start = IRQ_T7L66XB_MMC,
-		.end	= IRQ_T7L66XB_MMC,
-		.flags = IORESOURCE_IRQ,
-	},
+	.set_clk_div = t7l66xb_mmc_clk_div,
 };
 
 static const struct resource t7l66xb_nand_resources[] = {
@@ -300,7 +298,7 @@ static int t7l66xb_resume(struct platfor
 	if (pdata && pdata->resume)
 		pdata->resume(dev);
 
-	tmio_core_mmc_enable(t7l66xb->scr + 0x200,
+	tmio_core_mmc_enable(t7l66xb->scr + 0x200, 0,
 		t7l66xb_mmc_resources[0].start & 0xfffe);
 
 	return 0;
--- 0002/drivers/mfd/tc6387xb.c
+++ work/drivers/mfd/tc6387xb.c	2010-01-06 13:21:04.000000000 +0900
@@ -28,7 +28,18 @@ struct tc6387xb {
 	struct resource rscr;
 };
 
-static struct resource tc6387xb_mmc_resources[];
+static struct resource tc6387xb_mmc_resources[] = {
+	{
+		.start = 0x800,
+		.end   = 0x9ff,
+		.flags = IORESOURCE_MEM,
+	},
+	{
+		.start = 0,
+		.end   = 0,
+		.flags = IORESOURCE_IRQ,
+	},
+};
 
 /*--------------------------------------------------------------------------*/
 
@@ -54,7 +65,7 @@ static int tc6387xb_resume(struct platfo
 	if (pdata && pdata->resume)
 		pdata->resume(dev);
 
-	tmio_core_mmc_resume(tc6387xb->scr + 0x200,
+	tmio_core_mmc_resume(tc6387xb->scr + 0x200, 0,
 		tc6387xb_mmc_resources[0].start & 0xfffe);
 
 	return 0;
@@ -71,7 +82,7 @@ static void tc6387xb_mmc_pwr(struct plat
 	struct platform_device *dev = to_platform_device(mmc->dev.parent);
 	struct tc6387xb *tc6387xb = platform_get_drvdata(dev);
 
-	tmio_core_mmc_pwr(tc6387xb->scr + 0x200, state);
+	tmio_core_mmc_pwr(tc6387xb->scr + 0x200, 0, state);
 }
 
 static void tc6387xb_mmc_clk_div(struct platform_device *mmc, int state)
@@ -79,7 +90,7 @@ static void tc6387xb_mmc_clk_div(struct 
 	struct platform_device *dev = to_platform_device(mmc->dev.parent);
 	struct tc6387xb *tc6387xb = platform_get_drvdata(dev);
 
-	tmio_core_mmc_clk_div(tc6387xb->scr + 0x200, state);
+	tmio_core_mmc_clk_div(tc6387xb->scr + 0x200, 0, state);
 }
 
 
@@ -90,7 +101,7 @@ static int tc6387xb_mmc_enable(struct pl
 
 	clk_enable(tc6387xb->clk32k);
 
-	tmio_core_mmc_enable(tc6387xb->scr + 0x200,
+	tmio_core_mmc_enable(tc6387xb->scr + 0x200, 0,
 		tc6387xb_mmc_resources[0].start & 0xfffe);
 
 	return 0;
@@ -109,24 +120,11 @@ static int tc6387xb_mmc_disable(struct p
 static struct tmio_mmc_data tc6387xb_mmc_data = {
 	.hclk = 24000000,
 	.set_pwr = tc6387xb_mmc_pwr,
-	.set_no_clk_div = tc6387xb_mmc_clk_div,
+	.set_clk_div = tc6387xb_mmc_clk_div,
 };
 
 /*--------------------------------------------------------------------------*/
 
-static struct resource tc6387xb_mmc_resources[] = {
-	{
-		.start = 0x800,
-		.end   = 0x9ff,
-		.flags = IORESOURCE_MEM,
-	},
-	{
-		.start = 0,
-		.end   = 0,
-		.flags = IORESOURCE_IRQ,
-	},
-};
-
 static struct mfd_cell tc6387xb_cells[] = {
 	[TC6387XB_CELL_MMC] = {
 		.name = "tmio-mmc",
--- 0002/drivers/mfd/tc6393xb.c
+++ work/drivers/mfd/tc6393xb.c	2010-01-06 13:20:08.000000000 +0900
@@ -342,7 +342,7 @@ static int tc6393xb_mmc_enable(struct pl
 	struct platform_device *dev = to_platform_device(mmc->dev.parent);
 	struct tc6393xb *tc6393xb = platform_get_drvdata(dev);
 
-	tmio_core_mmc_enable(tc6393xb->scr + 0x200,
+	tmio_core_mmc_enable(tc6393xb->scr + 0x200, 0,
 		tc6393xb_mmc_resources[0].start & 0xfffe);
 
 	return 0;
@@ -353,7 +353,7 @@ static int tc6393xb_mmc_resume(struct pl
 	struct platform_device *dev = to_platform_device(mmc->dev.parent);
 	struct tc6393xb *tc6393xb = platform_get_drvdata(dev);
 
-	tmio_core_mmc_resume(tc6393xb->scr + 0x200,
+	tmio_core_mmc_resume(tc6393xb->scr + 0x200, 0,
 		tc6393xb_mmc_resources[0].start & 0xfffe);
 
 	return 0;
@@ -364,7 +364,7 @@ static void tc6393xb_mmc_pwr(struct plat
 	struct platform_device *dev = to_platform_device(mmc->dev.parent);
 	struct tc6393xb *tc6393xb = platform_get_drvdata(dev);
 
-	tmio_core_mmc_pwr(tc6393xb->scr + 0x200, state);
+	tmio_core_mmc_pwr(tc6393xb->scr + 0x200, 0, state);
 }
 
 static void tc6393xb_mmc_clk_div(struct platform_device *mmc, int state)
@@ -372,7 +372,7 @@ static void tc6393xb_mmc_clk_div(struct 
 	struct platform_device *dev = to_platform_device(mmc->dev.parent);
 	struct tc6393xb *tc6393xb = platform_get_drvdata(dev);
 
-	tmio_core_mmc_clk_div(tc6393xb->scr + 0x200, state);
+	tmio_core_mmc_clk_div(tc6393xb->scr + 0x200, 0, state);
 }
 
 static struct tmio_mmc_data tc6393xb_mmc_data = {
--- 0002/drivers/mfd/tmio_core.c
+++ work/drivers/mfd/tmio_core.c	2010-01-06 13:16:21.000000000 +0900
@@ -1,6 +1,4 @@
 /*
- * Toshiba TC6393XB SoC support
- *
  * Copyright(c) 2009 Ian Molton <spyro@f2s.com>
  *
  * This program is free software; you can redistribute it and/or modify
@@ -10,9 +8,7 @@
 
 #include <linux/mfd/tmio.h>
 
-static int shift;
-
-int tmio_core_mmc_enable(void __iomem *cnf, unsigned long base)
+int tmio_core_mmc_enable(void __iomem *cnf, int shift, unsigned long base)
 {
 	/* Enable the MMC/SD Control registers */
 	sd_config_write16(cnf, shift, CNF_CMD, SDCREN);
@@ -24,14 +20,14 @@ int tmio_core_mmc_enable(void __iomem *c
 	/* The below is required but why? FIXME */
 	sd_config_write8(cnf, shift, CNF_STOP_CLK_CTL, 0x1f);
 
-	/* Power down SD bus*/
+	/* Power down SD bus */
 	sd_config_write8(cnf, shift, CNF_PWR_CTL_2, 0x00);
 
 	return 0;
 }
 EXPORT_SYMBOL(tmio_core_mmc_enable);
 
-int tmio_core_mmc_resume(void __iomem *cnf, unsigned long base)
+int tmio_core_mmc_resume(void __iomem *cnf, int shift, unsigned long base)
 {
 
 	/* Enable the MMC/SD Control registers */
@@ -42,21 +38,15 @@ int tmio_core_mmc_resume(void __iomem *c
 }
 EXPORT_SYMBOL(tmio_core_mmc_resume);
 
-void tmio_core_mmc_pwr(void __iomem *cnf, int state)
+void tmio_core_mmc_pwr(void __iomem *cnf, int shift, int state)
 {
 	sd_config_write8(cnf, shift, CNF_PWR_CTL_2, state ? 0x02 : 0x00);
 }
 EXPORT_SYMBOL(tmio_core_mmc_pwr);
 
-void tmio_core_mmc_clk_div(void __iomem *cnf, int state)
+void tmio_core_mmc_clk_div(void __iomem *cnf, int shift, int state)
 {
 	sd_config_write8(cnf, shift, CNF_SD_CLK_MODE, state ? 1 : 0);
 }
 EXPORT_SYMBOL(tmio_core_mmc_clk_div);
 
-void tmio_core_set_bus_shift(int bus_shift)
-{
-	shift = bus_shift;
-}
-EXPORT_SYMBOL(tmio_core_set_bus_shift);
-
--- 0002/drivers/mmc/host/tmio_mmc.c
+++ work/drivers/mmc/host/tmio_mmc.c	2010-01-06 13:45:59.000000000 +0900
@@ -46,8 +46,8 @@ static void tmio_mmc_set_clock(struct tm
 		clk |= 0x100;
 	}
 
-	if (host->set_no_clk_div)
-		host->set_no_clk_div(host->pdev, (clk>>22) & 1);
+	if (host->set_clk_div)
+		host->set_clk_div(host->pdev, (clk>>22) & 1);
 
 	sd_ctrl_write16(host, CTL_SD_CARD_CLK_CTL, clk & 0x1ff);
 }
@@ -478,8 +478,8 @@ static int tmio_mmc_suspend(struct platf
 	ret = mmc_suspend_host(mmc, state);
 
 	/* Tell MFD core it can disable us now.*/
-	if (!ret && cell->suspend)
-		cell->suspend(dev);
+	if (!ret && cell->disable)
+		cell->disable(dev);
 
 	return ret;
 }
@@ -539,7 +539,7 @@ static int __devinit tmio_mmc_probe(stru
 	platform_set_drvdata(dev, mmc);
 
 	host->set_pwr = pdata->set_pwr;
-	host->set_no_clk_div = pdata->set_no_clk_div;
+	host->set_clk_div = pdata->set_clk_div;
 
 	/* SD control register space size is 0x200, 0x400 for bus_shift=1 */
 	host->bus_shift = resource_size(res_ctl) >> 10;
--- 0002/drivers/mmc/host/tmio_mmc.h
+++ work/drivers/mmc/host/tmio_mmc.h	2010-01-06 13:26:06.000000000 +0900
@@ -100,7 +100,7 @@ struct tmio_mmc_host {
 
 	/* Callbacks for clock / power control */
 	void (*set_pwr)(struct platform_device *host, int state);
-	void (*set_no_clk_div)(struct platform_device *host, int state);
+	void (*set_clk_div)(struct platform_device *host, int state);
 
 	/* pio related stuff */
 	struct scatterlist      *sg_ptr;
--- 0002/include/linux/mfd/tmio.h
+++ work/include/linux/mfd/tmio.h	2010-01-06 13:16:33.000000000 +0900
@@ -50,11 +50,10 @@
 	tmio_iowrite16((val) >> 16, (base) + ((reg + 2) << (shift))); \
 	} while (0)
 
-int tmio_core_mmc_enable(void __iomem *cnf, unsigned long base);
-int tmio_core_mmc_resume(void __iomem *cnf, unsigned long base);
-void tmio_core_mmc_pwr(void __iomem *cnf, int state);
-void tmio_core_mmc_clk_div(void __iomem *cnf, int state);
-void tmio_core_set_bus_shift(int bus_shift);
+int tmio_core_mmc_enable(void __iomem *cnf, int shift, unsigned long base);
+int tmio_core_mmc_resume(void __iomem *cnf, int shift, unsigned long base);
+void tmio_core_mmc_pwr(void __iomem *cnf, int shift, int state);
+void tmio_core_mmc_clk_div(void __iomem *cnf, int shift, int state);
 
 /*
  * data for the MMC controller
@@ -62,7 +61,7 @@ void tmio_core_set_bus_shift(int bus_shi
 struct tmio_mmc_data {
 	const unsigned int		hclk;
 	void (*set_pwr)(struct platform_device *host, int state);
-	void (*set_no_clk_div)(struct platform_device *host, int state);
+	void (*set_clk_div)(struct platform_device *host, int state);
 };
 
 /*
