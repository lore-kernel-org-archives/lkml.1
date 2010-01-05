Return-Path: <linux-kernel-owner+w=401wt.eu-S1751179Ab0AEFPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751179Ab0AEFPa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 00:15:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750789Ab0AEFP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 00:15:29 -0500
Received: from mail-yx0-f188.google.com ([209.85.210.188]:59308 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab0AEFP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 00:15:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=YLo+7GK593xGdXHbbHxsfAHQOk/ai7fiXNl0tpbZH2aDYnIMWhqoaSEXdbqkFSAAI5
         IItwUk8EK3iaW7k2MZPRhtEdVcpxg6Glu99CCXRacGwXFRyue5ggP5Tng6WrdD4xKHuJ
         cFYs0UBiNQy9iyjTXGLzv1AcSksZ7IQETPbLk=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: ian@mnementh.co.uk, Magnus Damm <magnus.damm@gmail.com>,
       sameo@linux.intel.com, linux-sh@vger.kernel.org
Date: Tue, 05 Jan 2010 14:09:14 +0900
Message-Id: <20100105050914.32264.762.sendpatchset@rxone.opensource.se>
Subject: [PATCH] MMC: hardware abstraction for CNF area
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Molton <ian@mnementh.co.uk>

This patch abstracts out the CNF area code from tmio_mmc which
is not present in all hardware that can use this driver. This
is required so that we can support non-toshiba based hardware.

ASIC3 support by Philipp Zabel

[ Magnus Damm: extracted patch from git.mnementh.co.uk, tried
  to apply on top of current linux-2.6 but got rejects due to
  -mm patch 14f1b75b1d31673d7ab6ac6d2f8fe7f23c705229, solved
  conflict by hand, regenerated patch and posted to lkml ]

Signed-off-by: Ian Molton <ian@mnementh.co.uk>
---

 See http://lkml.org/lkml/2009/12/28/38 for more information.

 drivers/mfd/Makefile        |    6 +-
 drivers/mfd/asic3.c         |   43 +++++++++++++++----
 drivers/mfd/t7l66xb.c       |   31 +++++++++++--
 drivers/mfd/tc6387xb.c      |   97 ++++++++++++++++++++++++++++++++++---------
 drivers/mfd/tc6393xb.c      |   56 ++++++++++++++++++++----
 drivers/mfd/tmio_core.c     |   62 +++++++++++++++++++++++++++
 drivers/mmc/host/tmio_mmc.c |   63 +++++++++------------------
 drivers/mmc/host/tmio_mmc.h |   46 ++------------------
 include/linux/mfd/tmio.h    |   40 +++++++++++++++++
 9 files changed, 318 insertions(+), 126 deletions(-)

--- 0001/drivers/mfd/Makefile
+++ work/drivers/mfd/Makefile	2010-01-05 13:27:31.000000000 +0900
@@ -11,9 +11,9 @@ obj-$(CONFIG_HTC_PASIC3)	+= htc-pasic3.o
 
 obj-$(CONFIG_MFD_DM355EVM_MSP)	+= dm355evm_msp.o
 
-obj-$(CONFIG_MFD_T7L66XB)	+= t7l66xb.o
-obj-$(CONFIG_MFD_TC6387XB)	+= tc6387xb.o
-obj-$(CONFIG_MFD_TC6393XB)	+= tc6393xb.o
+obj-$(CONFIG_MFD_T7L66XB)	+= t7l66xb.o tmio_core.o
+obj-$(CONFIG_MFD_TC6387XB)	+= tc6387xb.o tmio_core.o
+obj-$(CONFIG_MFD_TC6393XB)	+= tc6393xb.o tmio_core.o
 
 obj-$(CONFIG_MFD_WM8400)	+= wm8400-core.o
 wm831x-objs			:= wm831x-core.o wm831x-irq.o wm831x-otp.o
--- 0001/drivers/mfd/asic3.c
+++ work/drivers/mfd/asic3.c	2010-01-05 13:27:31.000000000 +0900
@@ -80,6 +80,7 @@ struct asic3 {
 	u16 irq_bothedge[4];
 	struct gpio_chip gpio;
 	struct device *dev;
+	void __iomem *tmio_cnf;
 
 	struct asic3_clk clocks[ARRAY_SIZE(asic3_clk_init)];
 };
@@ -685,8 +686,24 @@ static struct mfd_cell asic3_cell_ds1wm 
 	.resources     = ds1wm_resources,
 };
 
+static void asic3_mmc_pwr(struct platform_device *pdev, int state)
+{
+	struct asic3 *asic = dev_get_drvdata(pdev->dev.parent);
+
+	tmio_core_mmc_pwr(asic->tmio_cnf, state);
+}
+
+static void asic3_mmc_clk_div(struct platform_device *pdev, int state)
+{
+	struct asic3 *asic = dev_get_drvdata(pdev->dev.parent);
+
+	tmio_core_mmc_clk_div(asic->tmio_cnf, state);
+}
+
 static struct tmio_mmc_data asic3_mmc_data = {
-	.hclk = 24576000,
+	.hclk           = 24576000,
+	.set_pwr        = asic3_mmc_pwr,
+	.set_no_clk_div = asic3_mmc_clk_div,
 };
 
 static struct resource asic3_mmc_resources[] = {
@@ -696,11 +713,6 @@ static struct resource asic3_mmc_resourc
 		.flags = IORESOURCE_MEM,
 	},
 	{
-		.start = ASIC3_SD_CONFIG_BASE,
-		.end   = ASIC3_SD_CONFIG_BASE + 0x1ff,
-		.flags = IORESOURCE_MEM,
-	},
-	{
 		.start = 0,
 		.end   = 0,
 		.flags = IORESOURCE_IRQ,
@@ -743,6 +755,9 @@ static int asic3_mmc_enable(struct platf
 	asic3_set_register(asic, ASIC3_OFFSET(SDHWCTRL, SDCONF),
 			   ASIC3_SDHWCTRL_SDPWR, 1);
 
+	/* ASIC3_SD_CTRL_BASE assumes 32-bit addressing, TMIO is 16-bit */
+	tmio_core_mmc_enable(asic->tmio_cnf, ASIC3_SD_CTRL_BASE >> 1);
+
 	return 0;
 }
 
@@ -766,6 +781,8 @@ static struct mfd_cell asic3_cell_mmc = 
 	.name          = "tmio-mmc",
 	.enable        = asic3_mmc_enable,
 	.disable       = asic3_mmc_disable,
+	.suspend       = asic3_mmc_disable,
+	.resume        = asic3_mmc_enable,
 	.driver_data   = &asic3_mmc_data,
 	.num_resources = ARRAY_SIZE(asic3_mmc_resources),
 	.resources     = asic3_mmc_resources,
@@ -797,14 +814,21 @@ static int __init asic3_mfd_probe(struct
 	asic3_cell_ds1wm.data_size = sizeof(asic3_cell_ds1wm);
 
 	/* MMC */
+	asic->tmio_cnf = ioremap((ASIC3_SD_CONFIG_BASE >> asic->bus_shift) +
+				 mem_sdio->start, 0x400 >> asic->bus_shift);
+	if (!asic->tmio_cnf) {
+		ret = -ENOMEM;
+		dev_dbg(asic->dev, "Couldn't ioremap SD_CONFIG\n");
+		goto out;
+	}
 	asic3_mmc_resources[0].start >>= asic->bus_shift;
 	asic3_mmc_resources[0].end   >>= asic->bus_shift;
-	asic3_mmc_resources[1].start >>= asic->bus_shift;
-	asic3_mmc_resources[1].end   >>= asic->bus_shift;
 
 	asic3_cell_mmc.platform_data = &asic3_cell_mmc;
 	asic3_cell_mmc.data_size = sizeof(asic3_cell_mmc);
 
+	tmio_core_set_bus_shift(1 - asic->bus_shift);
+
 	ret = mfd_add_devices(&pdev->dev, pdev->id,
 			&asic3_cell_ds1wm, 1, mem, asic->irq_base);
 	if (ret < 0)
@@ -820,7 +844,10 @@ static int __init asic3_mfd_probe(struct
 
 static void asic3_mfd_remove(struct platform_device *pdev)
 {
+	struct asic3 *asic = platform_get_drvdata(pdev);
+
 	mfd_remove_devices(&pdev->dev);
+	iounmap(asic->tmio_cnf);
 }
 
 /* Core */
--- 0001/drivers/mfd/t7l66xb.c
+++ work/drivers/mfd/t7l66xb.c	2010-01-05 13:27:31.000000000 +0900
@@ -38,6 +38,8 @@ enum {
 	T7L66XB_CELL_MMC,
 };
 
+static const struct resource t7l66xb_mmc_resources[];
+
 #define SCR_REVID	0x08		/* b Revision ID	*/
 #define SCR_IMR		0x42		/* b Interrupt Mask	*/
 #define SCR_DEV_CTL	0xe0		/* b Device control	*/
@@ -83,6 +85,9 @@ static int t7l66xb_mmc_enable(struct pla
 
 	spin_unlock_irqrestore(&t7l66xb->lock, flags);
 
+	tmio_core_mmc_enable(t7l66xb->scr + 0x200,
+		t7l66xb_mmc_resources[0].start & 0xfffe);
+
 	return 0;
 }
 
@@ -106,10 +111,28 @@ static int t7l66xb_mmc_disable(struct pl
 	return 0;
 }
 
+static void t7l66xb_mmc_pwr(struct platform_device *mmc, int state)
+{
+	struct platform_device *dev = to_platform_device(mmc->dev.parent);
+	struct t7l66xb *t7l66xb = platform_get_drvdata(dev);
+
+	tmio_core_mmc_pwr(t7l66xb->scr + 0x200, state);
+}
+
+static void t7l66xb_mmc_clk_div(struct platform_device *mmc, int state)
+{
+	struct platform_device *dev = to_platform_device(mmc->dev.parent);
+	struct t7l66xb *t7l66xb = platform_get_drvdata(dev);
+
+	tmio_core_mmc_clk_div(t7l66xb->scr + 0x200, state);
+}
+
 /*--------------------------------------------------------------------------*/
 
 static struct tmio_mmc_data t7166xb_mmc_data = {
 	.hclk = 24000000,
+	.set_pwr = t7l66xb_mmc_pwr,
+	.set_no_clk_div = t7l66xb_mmc_clk_div,
 };
 
 static const struct resource t7l66xb_mmc_resources[] = {
@@ -119,11 +142,6 @@ static const struct resource t7l66xb_mmc
 		.flags = IORESOURCE_MEM,
 	},
 	{
-		.start = 0x200,
-		.end	= 0x2ff,
-		.flags = IORESOURCE_MEM,
-	},
-	{
 		.start = IRQ_T7L66XB_MMC,
 		.end	= IRQ_T7L66XB_MMC,
 		.flags = IORESOURCE_IRQ,
@@ -282,6 +300,9 @@ static int t7l66xb_resume(struct platfor
 	if (pdata && pdata->resume)
 		pdata->resume(dev);
 
+	tmio_core_mmc_enable(t7l66xb->scr + 0x200,
+		t7l66xb_mmc_resources[0].start & 0xfffe);
+
 	return 0;
 }
 #else
--- 0001/drivers/mfd/tc6387xb.c
+++ work/drivers/mfd/tc6387xb.c	2010-01-05 13:27:31.000000000 +0900
@@ -22,28 +22,41 @@ enum {
 	TC6387XB_CELL_MMC,
 };
 
+struct tc6387xb {
+	void __iomem *scr;
+	struct clk *clk32k;
+	struct resource rscr;
+};
+
+static struct resource tc6387xb_mmc_resources[];
+
+/*--------------------------------------------------------------------------*/
+
 #ifdef CONFIG_PM
 static int tc6387xb_suspend(struct platform_device *dev, pm_message_t state)
 {
-	struct clk *clk32k = platform_get_drvdata(dev);
+	struct tc6387xb *tc6387xb = platform_get_drvdata(dev);
 	struct tc6387xb_platform_data *pdata = dev->dev.platform_data;
 
 	if (pdata && pdata->suspend)
 		pdata->suspend(dev);
-	clk_disable(clk32k);
+	clk_disable(tc6387xb->clk32k);
 
 	return 0;
 }
 
 static int tc6387xb_resume(struct platform_device *dev)
 {
-	struct clk *clk32k = platform_get_drvdata(dev);
+	struct tc6387xb *tc6387xb = platform_get_drvdata(dev);
 	struct tc6387xb_platform_data *pdata = dev->dev.platform_data;
 
-	clk_enable(clk32k);
+	clk_enable(tc6387xb->clk32k);
 	if (pdata && pdata->resume)
 		pdata->resume(dev);
 
+	tmio_core_mmc_resume(tc6387xb->scr + 0x200,
+		tc6387xb_mmc_resources[0].start & 0xfffe);
+
 	return 0;
 }
 #else
@@ -53,12 +66,32 @@ static int tc6387xb_resume(struct platfo
 
 /*--------------------------------------------------------------------------*/
 
+static void tc6387xb_mmc_pwr(struct platform_device *mmc, int state)
+{
+	struct platform_device *dev = to_platform_device(mmc->dev.parent);
+	struct tc6387xb *tc6387xb = platform_get_drvdata(dev);
+
+	tmio_core_mmc_pwr(tc6387xb->scr + 0x200, state);
+}
+
+static void tc6387xb_mmc_clk_div(struct platform_device *mmc, int state)
+{
+	struct platform_device *dev = to_platform_device(mmc->dev.parent);
+	struct tc6387xb *tc6387xb = platform_get_drvdata(dev);
+
+	tmio_core_mmc_clk_div(tc6387xb->scr + 0x200, state);
+}
+
+
 static int tc6387xb_mmc_enable(struct platform_device *mmc)
 {
 	struct platform_device *dev      = to_platform_device(mmc->dev.parent);
-	struct clk *clk32k = platform_get_drvdata(dev);
+	struct tc6387xb *tc6387xb = platform_get_drvdata(dev);
 
-	clk_enable(clk32k);
+	clk_enable(tc6387xb->clk32k);
+
+	tmio_core_mmc_enable(tc6387xb->scr + 0x200,
+		tc6387xb_mmc_resources[0].start & 0xfffe);
 
 	return 0;
 }
@@ -66,19 +99,21 @@ static int tc6387xb_mmc_enable(struct pl
 static int tc6387xb_mmc_disable(struct platform_device *mmc)
 {
 	struct platform_device *dev      = to_platform_device(mmc->dev.parent);
-	struct clk *clk32k = platform_get_drvdata(dev);
+	struct tc6387xb *tc6387xb = platform_get_drvdata(dev);
 
-	clk_disable(clk32k);
+	clk_disable(tc6387xb->clk32k);
 
 	return 0;
 }
 
-/*--------------------------------------------------------------------------*/
-
 static struct tmio_mmc_data tc6387xb_mmc_data = {
 	.hclk = 24000000,
+	.set_pwr = tc6387xb_mmc_pwr,
+	.set_no_clk_div = tc6387xb_mmc_clk_div,
 };
 
+/*--------------------------------------------------------------------------*/
+
 static struct resource tc6387xb_mmc_resources[] = {
 	{
 		.start = 0x800,
@@ -86,11 +121,6 @@ static struct resource tc6387xb_mmc_reso
 		.flags = IORESOURCE_MEM,
 	},
 	{
-		.start = 0x200,
-		.end   = 0x2ff,
-		.flags = IORESOURCE_MEM,
-	},
-	{
 		.start = 0,
 		.end   = 0,
 		.flags = IORESOURCE_IRQ,
@@ -111,8 +141,9 @@ static struct mfd_cell tc6387xb_cells[] 
 static int tc6387xb_probe(struct platform_device *dev)
 {
 	struct tc6387xb_platform_data *pdata = dev->dev.platform_data;
-	struct resource *iomem;
+	struct resource *iomem, *rscr;
 	struct clk *clk32k;
+	struct tc6387xb *tc6387xb;
 	int irq, ret;
 
 	iomem = platform_get_resource(dev, IORESOURCE_MEM, 0);
@@ -120,18 +151,40 @@ static int tc6387xb_probe(struct platfor
 		return -EINVAL;
 	}
 
+	tc6387xb = kzalloc(sizeof *tc6387xb, GFP_KERNEL);
+	if (!tc6387xb)
+		return -ENOMEM;
+
 	ret  = platform_get_irq(dev, 0);
 	if (ret >= 0)
 		irq = ret;
 	else
-		goto err_resource;
+		goto err_no_irq;
 
 	clk32k = clk_get(&dev->dev, "CLK_CK32K");
 	if (IS_ERR(clk32k)) {
 		ret = PTR_ERR(clk32k);
+		goto err_no_clk;
+	}
+
+	rscr = &tc6387xb->rscr;
+	rscr->name = "tc6387xb-core";
+	rscr->start = iomem->start;
+	rscr->end = iomem->start + 0xff;
+	rscr->flags = IORESOURCE_MEM;
+
+	ret = request_resource(iomem, rscr);
+	if (ret)
 		goto err_resource;
+
+	tc6387xb->scr = ioremap(rscr->start, rscr->end - rscr->start + 1);
+	if (!tc6387xb->scr) {
+		ret = -ENOMEM;
+		goto err_ioremap;
 	}
-	platform_set_drvdata(dev, clk32k);
+
+	tc6387xb->clk32k = clk32k;
+	platform_set_drvdata(dev, tc6387xb);
 
 	if (pdata && pdata->enable)
 		pdata->enable(dev);
@@ -149,8 +202,13 @@ static int tc6387xb_probe(struct platfor
 	if (!ret)
 		return 0;
 
-	clk_put(clk32k);
+err_ioremap:
+	release_resource(&tc6387xb->rscr);
 err_resource:
+	clk_put(clk32k);
+err_no_clk:
+err_no_irq:
+	kfree(tc6387xb);
 	return ret;
 }
 
@@ -195,3 +253,4 @@ MODULE_DESCRIPTION("Toshiba TC6387XB cor
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Ian Molton");
 MODULE_ALIAS("platform:tc6387xb");
+
--- 0001/drivers/mfd/tc6393xb.c
+++ work/drivers/mfd/tc6393xb.c	2010-01-05 13:27:31.000000000 +0900
@@ -136,10 +136,6 @@ static int tc6393xb_nand_enable(struct p
 	return 0;
 }
 
-static struct tmio_mmc_data tc6393xb_mmc_data = {
-	.hclk = 24000000,
-};
-
 static struct resource __devinitdata tc6393xb_nand_resources[] = {
 	{
 		.start	= 0x1000,
@@ -165,11 +161,6 @@ static struct resource __devinitdata tc6
 		.flags	= IORESOURCE_MEM,
 	},
 	{
-		.start	= 0x200,
-		.end	= 0x2ff,
-		.flags	= IORESOURCE_MEM,
-	},
-	{
 		.start	= IRQ_TC6393_MMC,
 		.end	= IRQ_TC6393_MMC,
 		.flags	= IORESOURCE_IRQ,
@@ -346,6 +337,50 @@ int tc6393xb_lcd_mode(struct platform_de
 }
 EXPORT_SYMBOL(tc6393xb_lcd_mode);
 
+static int tc6393xb_mmc_enable(struct platform_device *mmc)
+{
+	struct platform_device *dev = to_platform_device(mmc->dev.parent);
+	struct tc6393xb *tc6393xb = platform_get_drvdata(dev);
+
+	tmio_core_mmc_enable(tc6393xb->scr + 0x200,
+		tc6393xb_mmc_resources[0].start & 0xfffe);
+
+	return 0;
+}
+
+static int tc6393xb_mmc_resume(struct platform_device *mmc)
+{
+	struct platform_device *dev = to_platform_device(mmc->dev.parent);
+	struct tc6393xb *tc6393xb = platform_get_drvdata(dev);
+
+	tmio_core_mmc_resume(tc6393xb->scr + 0x200,
+		tc6393xb_mmc_resources[0].start & 0xfffe);
+
+	return 0;
+}
+
+static void tc6393xb_mmc_pwr(struct platform_device *mmc, int state)
+{
+	struct platform_device *dev = to_platform_device(mmc->dev.parent);
+	struct tc6393xb *tc6393xb = platform_get_drvdata(dev);
+
+	tmio_core_mmc_pwr(tc6393xb->scr + 0x200, state);
+}
+
+static void tc6393xb_mmc_clk_div(struct platform_device *mmc, int state)
+{
+	struct platform_device *dev = to_platform_device(mmc->dev.parent);
+	struct tc6393xb *tc6393xb = platform_get_drvdata(dev);
+
+	tmio_core_mmc_clk_div(tc6393xb->scr + 0x200, state);
+}
+
+static struct tmio_mmc_data tc6393xb_mmc_data = {
+	.hclk = 24000000,
+	.set_pwr = tc6393xb_mmc_pwr,
+	.set_no_clk_div = tc6393xb_mmc_clk_div,
+};
+
 static struct mfd_cell __devinitdata tc6393xb_cells[] = {
 	[TC6393XB_CELL_NAND] = {
 		.name = "tmio-nand",
@@ -355,6 +390,8 @@ static struct mfd_cell __devinitdata tc6
 	},
 	[TC6393XB_CELL_MMC] = {
 		.name = "tmio-mmc",
+		.enable = tc6393xb_mmc_enable,
+		.resume = tc6393xb_mmc_resume,
 		.driver_data = &tc6393xb_mmc_data,
 		.num_resources = ARRAY_SIZE(tc6393xb_mmc_resources),
 		.resources = tc6393xb_mmc_resources,
@@ -836,3 +873,4 @@ MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Ian Molton, Dmitry Baryshkov and Dirk Opfer");
 MODULE_DESCRIPTION("tc6393xb Toshiba Mobile IO Controller");
 MODULE_ALIAS("platform:tc6393xb");
+
--- /dev/null
+++ work/drivers/mfd/tmio_core.c	2010-01-05 13:27:31.000000000 +0900
@@ -0,0 +1,62 @@
+/*
+ * Toshiba TC6393XB SoC support
+ *
+ * Copyright(c) 2009 Ian Molton <spyro@f2s.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/mfd/tmio.h>
+
+static int shift;
+
+int tmio_core_mmc_enable(void __iomem *cnf, unsigned long base)
+{
+	/* Enable the MMC/SD Control registers */
+	sd_config_write16(cnf, shift, CNF_CMD, SDCREN);
+	sd_config_write32(cnf, shift, CNF_CTL_BASE, base & 0xfffe);
+
+	/* Disable SD power during suspend */
+	sd_config_write8(cnf, shift, CNF_PWR_CTL_3, 0x01);
+
+	/* The below is required but why? FIXME */
+	sd_config_write8(cnf, shift, CNF_STOP_CLK_CTL, 0x1f);
+
+	/* Power down SD bus*/
+	sd_config_write8(cnf, shift, CNF_PWR_CTL_2, 0x00);
+
+	return 0;
+}
+EXPORT_SYMBOL(tmio_core_mmc_enable);
+
+int tmio_core_mmc_resume(void __iomem *cnf, unsigned long base)
+{
+
+	/* Enable the MMC/SD Control registers */
+	sd_config_write16(cnf, shift, CNF_CMD, SDCREN);
+	sd_config_write32(cnf, shift, CNF_CTL_BASE, base & 0xfffe);
+
+	return 0;
+}
+EXPORT_SYMBOL(tmio_core_mmc_resume);
+
+void tmio_core_mmc_pwr(void __iomem *cnf, int state)
+{
+	sd_config_write8(cnf, shift, CNF_PWR_CTL_2, state ? 0x02 : 0x00);
+}
+EXPORT_SYMBOL(tmio_core_mmc_pwr);
+
+void tmio_core_mmc_clk_div(void __iomem *cnf, int state)
+{
+	sd_config_write8(cnf, shift, CNF_SD_CLK_MODE, state ? 1 : 0);
+}
+EXPORT_SYMBOL(tmio_core_mmc_clk_div);
+
+void tmio_core_set_bus_shift(int bus_shift)
+{
+	shift = bus_shift;
+}
+EXPORT_SYMBOL(tmio_core_set_bus_shift);
+
--- 0001/drivers/mmc/host/tmio_mmc.c
+++ work/drivers/mmc/host/tmio_mmc.c	2010-01-05 13:28:07.000000000 +0900
@@ -46,7 +46,9 @@ static void tmio_mmc_set_clock(struct tm
 		clk |= 0x100;
 	}
 
-	sd_config_write8(host, CNF_SD_CLK_MODE, clk >> 22);
+	if (host->set_no_clk_div)
+		host->set_no_clk_div(host->pdev, (clk>>22) & 1);
+
 	sd_ctrl_write16(host, CTL_SD_CARD_CLK_CTL, clk & 0x1ff);
 }
 
@@ -427,12 +429,13 @@ static void tmio_mmc_set_ios(struct mmc_
 	/* Power sequence - OFF -> ON -> UP */
 	switch (ios->power_mode) {
 	case MMC_POWER_OFF: /* power down SD bus */
-		sd_config_write8(host, CNF_PWR_CTL_2, 0x00);
+		if (host->set_pwr)
+			host->set_pwr(host->pdev, 0);
 		tmio_mmc_clk_stop(host);
 		break;
 	case MMC_POWER_ON: /* power up SD bus */
-
-		sd_config_write8(host, CNF_PWR_CTL_2, 0x02);
+		if (host->set_pwr)
+			host->set_pwr(host->pdev, 1);
 		break;
 	case MMC_POWER_UP: /* start bus clock */
 		tmio_mmc_clk_start(host);
@@ -475,8 +478,8 @@ static int tmio_mmc_suspend(struct platf
 	ret = mmc_suspend_host(mmc, state);
 
 	/* Tell MFD core it can disable us now.*/
-	if (!ret && cell->disable)
-		cell->disable(dev);
+	if (!ret && cell->suspend)
+		cell->suspend(dev);
 
 	return ret;
 }
@@ -485,21 +488,15 @@ static int tmio_mmc_resume(struct platfo
 {
 	struct mfd_cell	*cell = (struct mfd_cell *)dev->dev.platform_data;
 	struct mmc_host *mmc = platform_get_drvdata(dev);
-	struct tmio_mmc_host *host = mmc_priv(mmc);
 	int ret = 0;
 
 	/* Tell the MFD core we are ready to be enabled */
-	if (cell->enable) {
-		ret = cell->enable(dev);
+	if (cell->resume) {
+		ret = cell->resume(dev);
 		if (ret)
 			goto out;
 	}
 
-	/* Enable the MMC/SD Control registers */
-	sd_config_write16(host, CNF_CMD, SDCREN);
-	sd_config_write32(host, CNF_CTL_BASE,
-		(dev->resource[0].start >> host->bus_shift) & 0xfffe);
-
 	mmc_resume_host(mmc);
 
 out:
@@ -514,17 +511,16 @@ static int __devinit tmio_mmc_probe(stru
 {
 	struct mfd_cell	*cell = (struct mfd_cell *)dev->dev.platform_data;
 	struct tmio_mmc_data *pdata;
-	struct resource *res_ctl, *res_cnf;
+	struct resource *res_ctl;
 	struct tmio_mmc_host *host;
 	struct mmc_host *mmc;
 	int ret = -EINVAL;
 
-	if (dev->num_resources != 3)
+	if (dev->num_resources != 2)
 		goto out;
 
 	res_ctl = platform_get_resource(dev, IORESOURCE_MEM, 0);
-	res_cnf = platform_get_resource(dev, IORESOURCE_MEM, 1);
-	if (!res_ctl || !res_cnf)
+	if (!res_ctl)
 		goto out;
 
 	pdata = cell->driver_data;
@@ -539,8 +535,12 @@ static int __devinit tmio_mmc_probe(stru
 
 	host = mmc_priv(mmc);
 	host->mmc = mmc;
+	host->pdev = dev;
 	platform_set_drvdata(dev, mmc);
 
+	host->set_pwr = pdata->set_pwr;
+	host->set_no_clk_div = pdata->set_no_clk_div;
+
 	/* SD control register space size is 0x200, 0x400 for bus_shift=1 */
 	host->bus_shift = resource_size(res_ctl) >> 10;
 
@@ -548,10 +548,6 @@ static int __devinit tmio_mmc_probe(stru
 	if (!host->ctl)
 		goto host_free;
 
-	host->cnf = ioremap(res_cnf->start, resource_size(res_cnf));
-	if (!host->cnf)
-		goto unmap_ctl;
-
 	mmc->ops = &tmio_mmc_ops;
 	mmc->caps = MMC_CAP_4_BIT_DATA;
 	mmc->f_max = pdata->hclk;
@@ -562,23 +558,9 @@ static int __devinit tmio_mmc_probe(stru
 	if (cell->enable) {
 		ret = cell->enable(dev);
 		if (ret)
-			goto unmap_cnf;
+			goto unmap_ctl;
 	}
 
-	/* Enable the MMC/SD Control registers */
-	sd_config_write16(host, CNF_CMD, SDCREN);
-	sd_config_write32(host, CNF_CTL_BASE,
-		(dev->resource[0].start >> host->bus_shift) & 0xfffe);
-
-	/* Disable SD power during suspend */
-	sd_config_write8(host, CNF_PWR_CTL_3, 0x01);
-
-	/* The below is required but why? FIXME */
-	sd_config_write8(host, CNF_STOP_CLK_CTL, 0x1f);
-
-	/* Power down SD bus*/
-	sd_config_write8(host, CNF_PWR_CTL_2, 0x00);
-
 	tmio_mmc_clk_stop(host);
 	reset(host);
 
@@ -586,14 +568,14 @@ static int __devinit tmio_mmc_probe(stru
 	if (ret >= 0)
 		host->irq = ret;
 	else
-		goto unmap_cnf;
+		goto unmap_ctl;
 
 	disable_mmc_irqs(host, TMIO_MASK_ALL);
 
 	ret = request_irq(host->irq, tmio_mmc_irq, IRQF_DISABLED |
 		IRQF_TRIGGER_FALLING, dev_name(&dev->dev), host);
 	if (ret)
-		goto unmap_cnf;
+		goto unmap_ctl;
 
 	mmc_add_host(mmc);
 
@@ -605,8 +587,6 @@ static int __devinit tmio_mmc_probe(stru
 
 	return 0;
 
-unmap_cnf:
-	iounmap(host->cnf);
 unmap_ctl:
 	iounmap(host->ctl);
 host_free:
@@ -626,7 +606,6 @@ static int __devexit tmio_mmc_remove(str
 		mmc_remove_host(mmc);
 		free_irq(host->irq, host);
 		iounmap(host->ctl);
-		iounmap(host->cnf);
 		mmc_free_host(mmc);
 	}
 
--- 0001/drivers/mmc/host/tmio_mmc.h
+++ work/drivers/mmc/host/tmio_mmc.h	2010-01-05 13:27:31.000000000 +0900
@@ -11,26 +11,6 @@
 
 #include <linux/highmem.h>
 
-#define CNF_CMD     0x04
-#define CNF_CTL_BASE   0x10
-#define CNF_INT_PIN  0x3d
-#define CNF_STOP_CLK_CTL 0x40
-#define CNF_GCLK_CTL 0x41
-#define CNF_SD_CLK_MODE 0x42
-#define CNF_PIN_STATUS 0x44
-#define CNF_PWR_CTL_1 0x48
-#define CNF_PWR_CTL_2 0x49
-#define CNF_PWR_CTL_3 0x4a
-#define CNF_CARD_DETECT_MODE 0x4c
-#define CNF_SD_SLOT 0x50
-#define CNF_EXT_GCLK_CTL_1 0xf0
-#define CNF_EXT_GCLK_CTL_2 0xf1
-#define CNF_EXT_GCLK_CTL_3 0xf9
-#define CNF_SD_LED_EN_1 0xfa
-#define CNF_SD_LED_EN_2 0xfe
-
-#define   SDCREN 0x2   /* Enable access to MMC CTL regs. (flag in COMMAND_REG)*/
-
 #define CTL_SD_CMD 0x00
 #define CTL_ARG_REG 0x04
 #define CTL_STOP_INTERNAL_ACTION 0x08
@@ -110,7 +90,6 @@
 
 
 struct tmio_mmc_host {
-	void __iomem *cnf;
 	void __iomem *ctl;
 	unsigned long bus_shift;
 	struct mmc_command      *cmd;
@@ -119,10 +98,16 @@ struct tmio_mmc_host {
 	struct mmc_host         *mmc;
 	int                     irq;
 
+	/* Callbacks for clock / power control */
+	void (*set_pwr)(struct platform_device *host, int state);
+	void (*set_no_clk_div)(struct platform_device *host, int state);
+
 	/* pio related stuff */
 	struct scatterlist      *sg_ptr;
 	unsigned int            sg_len;
 	unsigned int            sg_off;
+
+	struct platform_device *pdev;
 };
 
 #include <linux/io.h>
@@ -163,25 +148,6 @@ static inline void sd_ctrl_write32(struc
 	writew(val >> 16, host->ctl + ((addr + 2) << host->bus_shift));
 }
 
-static inline void sd_config_write8(struct tmio_mmc_host *host, int addr,
-		u8 val)
-{
-	writeb(val, host->cnf + (addr << host->bus_shift));
-}
-
-static inline void sd_config_write16(struct tmio_mmc_host *host, int addr,
-		u16 val)
-{
-	writew(val, host->cnf + (addr << host->bus_shift));
-}
-
-static inline void sd_config_write32(struct tmio_mmc_host *host, int addr,
-		u32 val)
-{
-	writew(val, host->cnf + (addr << host->bus_shift));
-	writew(val >> 16, host->cnf + ((addr + 2) << host->bus_shift));
-}
-
 #include <linux/scatterlist.h>
 #include <linux/blkdev.h>
 
--- 0001/include/linux/mfd/tmio.h
+++ work/include/linux/mfd/tmio.h	2010-01-05 13:27:31.000000000 +0900
@@ -2,6 +2,8 @@
 #define MFD_TMIO_H
 
 #include <linux/fb.h>
+#include <linux/io.h>
+#include <linux/platform_device.h>
 
 #define tmio_ioread8(addr) readb(addr)
 #define tmio_ioread16(addr) readw(addr)
@@ -18,11 +20,49 @@
 	writew((val) >> 16, (addr) + 2); \
 	} while (0)
 
+#define CNF_CMD     0x04
+#define CNF_CTL_BASE   0x10
+#define CNF_INT_PIN  0x3d
+#define CNF_STOP_CLK_CTL 0x40
+#define CNF_GCLK_CTL 0x41
+#define CNF_SD_CLK_MODE 0x42
+#define CNF_PIN_STATUS 0x44
+#define CNF_PWR_CTL_1 0x48
+#define CNF_PWR_CTL_2 0x49
+#define CNF_PWR_CTL_3 0x4a
+#define CNF_CARD_DETECT_MODE 0x4c
+#define CNF_SD_SLOT 0x50
+#define CNF_EXT_GCLK_CTL_1 0xf0
+#define CNF_EXT_GCLK_CTL_2 0xf1
+#define CNF_EXT_GCLK_CTL_3 0xf9
+#define CNF_SD_LED_EN_1 0xfa
+#define CNF_SD_LED_EN_2 0xfe
+
+#define   SDCREN 0x2   /* Enable access to MMC CTL regs. (flag in COMMAND_REG)*/
+
+#define sd_config_write8(base, shift, reg, val) \
+	tmio_iowrite8((val), (base) + ((reg) << (shift)))
+#define sd_config_write16(base, shift, reg, val) \
+	tmio_iowrite16((val), (base) + ((reg) << (shift)))
+#define sd_config_write32(base, shift, reg, val) \
+	do { \
+	tmio_iowrite16((val), (base) + ((reg) << (shift))); \
+	tmio_iowrite16((val) >> 16, (base) + ((reg + 2) << (shift))); \
+	} while (0)
+
+int tmio_core_mmc_enable(void __iomem *cnf, unsigned long base);
+int tmio_core_mmc_resume(void __iomem *cnf, unsigned long base);
+void tmio_core_mmc_pwr(void __iomem *cnf, int state);
+void tmio_core_mmc_clk_div(void __iomem *cnf, int state);
+void tmio_core_set_bus_shift(int bus_shift);
+
 /*
  * data for the MMC controller
  */
 struct tmio_mmc_data {
 	const unsigned int		hclk;
+	void (*set_pwr)(struct platform_device *host, int state);
+	void (*set_no_clk_div)(struct platform_device *host, int state);
 };
 
 /*
