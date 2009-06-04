Return-Path: <linux-kernel-owner+w=401wt.eu-S1752855AbZFDSh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855AbZFDSh6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 14:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753706AbZFDShO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 14:37:14 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:20279 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753652AbZFDShM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 14:37:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=MloL83NSKaWJkAzy3dwH11+1Pvt7vKRJad7L1fO0lfmbjv3SjklXSsBJ8OzFiBXXIo
         6P/JCL/950wfFbc15X0BkrnnQhUskRvGv+RgxkPKdY5tamBmGHqBEgS7Hziw/9C4tfC9
         KSp/oI9Kq2f+drrZoc8MiVOMymLEcBXQ+x5rg=
From: Philipp Zabel <philipp.zabel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@openedhand.com>,
       Philipp Zabel <philipp.zabel@gmail.com>
Subject: [PATCH 7/7] MFD: ASIC3: enable SD/SDIO cell
Date: Thu,  4 Jun 2009 20:36:16 +0200
Message-Id: <1244140576-18006-8-git-send-email-philipp.zabel@gmail.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244140576-18006-1-git-send-email-philipp.zabel@gmail.com>
References: <1244140576-18006-1-git-send-email-philipp.zabel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This enables the ASIC3's SD/SDIO MFD cell, supported by the tmio_mmc driver.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
---
 drivers/mfd/asic3.c |  111 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 108 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/asic3.c b/drivers/mfd/asic3.c
index cfe8b32..f25cc1e 100644
--- a/drivers/mfd/asic3.c
+++ b/drivers/mfd/asic3.c
@@ -27,6 +27,7 @@
 #include <linux/mfd/asic3.h>
 #include <linux/mfd/core.h>
 #include <linux/mfd/ds1wm.h>
+#include <linux/mfd/tmio.h>
 
 enum {
 	ASIC3_CLOCK_SPI,
@@ -714,11 +715,101 @@ static struct mfd_cell asic3_cell_ds1wm = {
 	.resources     = ds1wm_resources,
 };
 
+static struct tmio_mmc_data asic3_mmc_data = {
+	.hclk = 24576000,
+};
+
+static struct resource asic3_mmc_resources[] = {
+	{
+		.start = ASIC3_SD_CTRL_BASE,
+		.end   = ASIC3_SD_CTRL_BASE + 0x3ff,
+		.flags = IORESOURCE_MEM,
+	},
+	{
+		.start = ASIC3_SD_CONFIG_BASE,
+		.end   = ASIC3_SD_CONFIG_BASE + 0x1ff,
+		.flags = IORESOURCE_MEM,
+	},
+	{
+		.start = 0,
+		.end   = 0,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static int asic3_mmc_enable(struct platform_device *pdev)
+{
+	struct device *dev = pdev->dev.parent;
+	struct asic3 *asic = dev->driver_data;
+
+	/* Not sure if it must be done bit by bit, but leaving as-is */
+	asic3_set_sdhwctrl(asic, ASIC3_SDHWCTRL_LEVCD, 1);
+	asic3_set_sdhwctrl(asic, ASIC3_SDHWCTRL_LEVWP, 1);
+	asic3_set_sdhwctrl(asic, ASIC3_SDHWCTRL_SUSPEND, 0);
+	asic3_set_sdhwctrl(asic, ASIC3_SDHWCTRL_PCLR, 0);
+
+	asic3_clk_enable(asic, &asic->clocks[ASIC3_CLOCK_EX0]);
+	/* CLK32 used for card detection and for interruption detection
+	 * when HCLK is stopped.
+	 */
+	asic3_clk_enable(asic, &asic->clocks[ASIC3_CLOCK_EX1]);
+	msleep(1);
+
+	/* HCLK 24.576 MHz, BCLK 12.288 MHz: */
+	asic3_write_register(asic, ASIC3_OFFSET(CLOCK, SEL),
+		CLOCK_SEL_CX | CLOCK_SEL_SD_HCLK_SEL);
+
+	asic3_clk_enable(asic, &asic->clocks[ASIC3_CLOCK_SD_HOST]);
+	asic3_clk_enable(asic, &asic->clocks[ASIC3_CLOCK_SD_BUS]);
+	msleep(1);
+
+	asic3_set_extcf_select(dev, ASIC3_EXTCF_SD_MEM_ENABLE, 1);
+
+	/* Enable SD card slot 3.3V power supply */
+	asic3_set_sdhwctrl(asic, ASIC3_SDHWCTRL_SDPWR, 1);
+
+	return 0;
+}
+
+static int asic3_mmc_disable(struct platform_device *pdev)
+{
+	struct device *dev = pdev->dev.parent;
+	struct asic3 *asic = dev->driver_data;
+
+	/* Put in suspend mode */
+	asic3_set_sdhwctrl(asic, ASIC3_SDHWCTRL_SUSPEND, 1);
+
+	/* Disable clocks */
+	asic3_clk_disable(asic, &asic->clocks[ASIC3_CLOCK_SD_HOST]);
+	asic3_clk_disable(asic, &asic->clocks[ASIC3_CLOCK_SD_BUS]);
+	asic3_clk_disable(asic, &asic->clocks[ASIC3_CLOCK_EX0]);
+	asic3_clk_disable(asic, &asic->clocks[ASIC3_CLOCK_EX1]);
+	return 0;
+}
+
+static struct mfd_cell asic3_cell_mmc = {
+	.name = "tmio-mmc",
+	.enable = asic3_mmc_enable,
+	.disable = asic3_mmc_disable,
+	.driver_data = &asic3_mmc_data,
+	.num_resources = ARRAY_SIZE(asic3_mmc_resources),
+	.resources = asic3_mmc_resources,
+};
+
 static int __init asic3_mfd_probe(struct platform_device *pdev,
 				  struct resource *mem)
 {
 	struct asic3 *asic = platform_get_drvdata(pdev);
-	int ret;
+	struct resource *mem_sdio;
+	int irq, ret;
+
+	mem_sdio = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+	if (!mem_sdio)
+		dev_dbg(asic->dev, "no SDIO MEM resource\n");
+
+	irq = platform_get_irq(pdev, 1);
+	if (irq < 0)
+		dev_dbg(asic->dev, "no SDIO IRQ resource\n");
 
 	/* DS1WM */
 	asic3_set_extcf_select(&pdev->dev, ASIC3_EXTCF_OWM_SMB, 0);
@@ -730,16 +821,30 @@ static int __init asic3_mfd_probe(struct platform_device *pdev,
 	asic3_cell_ds1wm.platform_data = &asic3_cell_ds1wm;
 	asic3_cell_ds1wm.data_size = sizeof(asic3_cell_ds1wm);
 
+	/* MMC */
+	asic3_mmc_resources[0].start >>= (2 - asic->bus_shift);
+	asic3_mmc_resources[0].end   >>= (2 - asic->bus_shift);
+	asic3_mmc_resources[1].start >>= (2 - asic->bus_shift);
+	asic3_mmc_resources[1].end   >>= (2 - asic->bus_shift);
+
+	asic3_cell_mmc.platform_data = &asic3_cell_mmc;
+	asic3_cell_mmc.data_size = sizeof(asic3_cell_mmc);
+
 	ret = mfd_add_devices(&pdev->dev, pdev->id,
 			&asic3_cell_ds1wm, 1, mem, asic->irq_base);
+	if (ret < 0)
+		goto out;
 
+	if (mem_sdio && (irq >= 0))
+		ret = mfd_add_devices(&pdev->dev, pdev->id,
+			&asic3_cell_mmc, 1, mem_sdio, irq);
+
+ out:
 	return ret;
 }
 
 static void asic3_mfd_remove(struct platform_device *pdev)
 {
-	struct asic3 *asic = platform_get_drvdata(pdev);
-
 	mfd_remove_devices(&pdev->dev);
 }
 
-- 
1.6.3.1

