Return-Path: <linux-kernel-owner+w=401wt.eu-S1751484AbYLBPnH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484AbYLBPnH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 10:43:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752523AbYLBPk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 10:40:56 -0500
Received: from aeryn.fluff.org.uk ([87.194.8.8]:34932 "EHLO
	teyla.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751146AbYLBPkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 10:40:51 -0500
Message-Id: <20081202154112.640260459@fluff.org.uk>
References: <20081202154018.906091477@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Tue, 02 Dec 2008 15:40:23 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: sdhci-devel@list.drzeus.cx, linux-kernel@vger.kernel.org,
       drzeus-sdhci@drzeus.cx
Cc: Ben Dooks <ben-linux@fluff.org>
Subject: [patch 5/8] SDHCI: Samsung SDHCI (HSMMC) driver
Content-Disposition: inline; filename=simtec/s3c64xx/sdhci-samsung.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the 'HSMMC' block(s) in the Samsung SoC
line. These are compatible with the SDHCI driver so add
the necessary setup and driver binding for the platform
devices.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux.git/drivers/mmc/host/Kconfig
===================================================================
--- linux.git.orig/drivers/mmc/host/Kconfig	2008-12-01 23:18:20.000000000 +0000
+++ linux.git/drivers/mmc/host/Kconfig	2008-12-01 23:25:18.000000000 +0000
@@ -48,6 +48,18 @@ config MMC_SDHCI_PCI
 
 	  If unsure, say N.
 
+config MMC_SDHCI_S3C
+	tristate "SDHCI support on Samsung S3C SoC"
+	depends on MMC_SDHCI && (PLAT_S3C24XX || PLAT_S3C64XX)
+	help
+	  This selects the Secure Digital Host Controller Interface (SDHCI)
+	  often referrered to as the HSMMC block in some of the Samsung S3C
+	  range of SoC.
+
+	  If you have a controller with this interface, say Y or M here.
+
+	  If unsure, say N.
+
 config MMC_RICOH_MMC
 	tristate "Ricoh MMC Controller Disabler  (EXPERIMENTAL)"
 	depends on MMC_SDHCI_PCI
Index: linux.git/drivers/mmc/host/Makefile
===================================================================
--- linux.git.orig/drivers/mmc/host/Makefile	2008-12-01 23:18:20.000000000 +0000
+++ linux.git/drivers/mmc/host/Makefile	2008-12-01 23:25:18.000000000 +0000
@@ -11,6 +11,7 @@ obj-$(CONFIG_MMC_PXA)		+= pxamci.o
 obj-$(CONFIG_MMC_IMX)		+= imxmmc.o
 obj-$(CONFIG_MMC_SDHCI)		+= sdhci.o
 obj-$(CONFIG_MMC_SDHCI_PCI)	+= sdhci-pci.o
+obj-$(CONFIG_MMC_SDHCI_S3C)	+= sdhci-s3c.o
 obj-$(CONFIG_MMC_RICOH_MMC)	+= ricoh_mmc.o
 obj-$(CONFIG_MMC_WBSD)		+= wbsd.o
 obj-$(CONFIG_MMC_AU1X)		+= au1xmmc.o
Index: linux.git/drivers/mmc/host/sdhci-s3c.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux.git/drivers/mmc/host/sdhci-s3c.c	2008-12-02 14:13:21.000000000 +0000
@@ -0,0 +1,256 @@
+/* linux/drivers/mmc/host/sdhci-s3c.c
+ *
+ * Copyright 2008 Openmoko Inc.
+ * Copyright 2008 Simtec Electronics
+ *      Ben Dooks <ben@simtec.co.uk>
+ *      http://armlinux.simtec.co.uk/
+ *
+ * SDHCI (HSMMC) support for Samsung SoC
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/delay.h>
+#include <linux/dma-mapping.h>
+#include <linux/platform_device.h>
+#include <linux/clk.h>
+#include <linux/io.h>
+
+#include <linux/mmc/host.h>
+
+#include <plat/sdhci.h>
+
+#include "sdhci.h"
+
+#define MAX_BUS_CLK	(4)
+
+struct sdhci_s3c {
+	struct sdhci_host	*host;
+	struct platform_device	*pdev;
+	struct resource		*ioarea;
+	struct s3c_sdhci_platdata *pdata;
+
+	struct clk		*clk_io;	/* clock for io bus */
+	struct clk		*clk_bus[MAX_BUS_CLK];
+};
+
+static inline struct sdhci_s3c *to_s3c(struct sdhci_host *host)
+{
+	return sdhci_priv(host);
+}
+
+static unsigned int sdhci_s3c_get_max_clk(struct sdhci_host *host)
+{
+	struct sdhci_s3c *ourhost = to_s3c(host);
+	unsigned int rate;
+	u32 control2;
+	int clk;
+
+	/* note, a reset will reset the clock source */
+
+	control2 = readl(host->ioaddr + 0x80);
+	clk = clk_get_rate(ourhost->clk_bus[(control2 >> 4) & 3]);
+
+	return clk;
+}
+
+static unsigned int sdhci_s3c_get_timeout_clk(struct sdhci_host *host)
+{
+	return sdhci_s3c_get_max_clk(host) / 1000000;
+}
+
+static void sdhci_s3c_set_ios(struct sdhci_host *host,
+			      struct mmc_ios *ios)
+{
+	struct sdhci_s3c *ourhost = to_s3c(host);
+	struct s3c_sdhci_platdata *pdata = ourhost->pdata;
+
+	if (pdata->cfg_card)
+		pdata->cfg_card(ourhost->pdev, host->ioaddr, ios);
+}
+
+static struct sdhci_ops sdhci_s3c_ops = {
+	.get_max_clock		= sdhci_s3c_get_max_clk,
+	.get_timeout_clock	= sdhci_s3c_get_timeout_clk,
+	.set_ios		= sdhci_s3c_set_ios,
+};
+
+static int __devinit sdhci_s3c_probe(struct platform_device *pdev)
+{
+	struct s3c_sdhci_platdata *pdata = pdev->dev.platform_data;
+	struct device *dev = &pdev->dev;
+	struct sdhci_host *host;
+	struct sdhci_s3c *sc;
+	struct resource *res;
+	int ret, irq, ptr, clks;
+
+	if (!pdata) {
+		dev_err(dev, "no device data specified\n");
+		return -ENOENT;
+	}
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
+		dev_err(dev, "no irq specified\n");
+		return irq;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(dev, "no memory specified\n");
+		return -ENOENT;
+	}
+
+	host = sdhci_alloc_host(dev, sizeof(struct sdhci_s3c));
+	if (IS_ERR(host)) {
+		dev_err(dev, "sdhci_alloc_host() failed\n");
+		return PTR_ERR(host);
+	}
+
+	sc = sdhci_priv(host);
+
+	sc->host = host;
+	sc->pdev = pdev;
+	sc->pdata = pdata;
+
+	sc->clk_io = clk_get(dev, "hsmmc");
+	if (IS_ERR(sc->clk_io)) {
+		dev_err(dev, "failed to get io clock\n");
+		ret = PTR_ERR(sc->clk_io);
+		goto err_io_clk;
+	}
+
+	/* enable the local io clock and keep it running for the moment. */
+	clk_enable(sc->clk_io);
+
+	for (clks = 0, ptr = 0; ptr < MAX_BUS_CLK; ptr++) {
+		char *name = pdata->clocks[ptr];
+		struct clk *clk;
+
+		if (name == NULL)
+			continue;
+
+		clk = clk_get(dev, name);
+		if (IS_ERR(clk)) {
+			dev_err(dev, "failed to get clock %s\n", name);
+			continue;
+		}
+
+		clks++;
+		sc->clk_bus[ptr] = clk;
+		clk_enable(clk);
+
+		dev_info(dev, "clock source %d: %s (%ld Hz)\n",
+			 ptr, name, clk_get_rate(clk));
+	}
+
+	if (clks == 0) {
+		dev_err(dev, "failed to find any bus clocks\n");
+		ret = -ENOENT;
+		goto err_no_busclks;
+	}
+
+	sc->ioarea = request_mem_region(res->start, resource_size(res),
+					mmc_hostname(host->mmc));
+	if (!sc->ioarea) {
+		dev_err(dev, "failed to reserve register area\n");
+		ret = -ENXIO;
+		goto err_req_regs;
+	}
+
+	host->ioaddr = ioremap_nocache(res->start, resource_size(res));
+	if (!host->ioaddr) {
+		dev_err(dev, "failed to map registers\n");
+		ret = -ENXIO;
+		goto err_req_regs;
+	}
+
+	/* Setup our GPIO */
+	if (pdata->cfg_gpio)
+		pdata->cfg_gpio(pdev, pdata->max_width);
+
+	host->hw_name = "samsung-hsmmc";
+	host->ops = &sdhci_s3c_ops;
+	host->quirks = 0;
+	host->irq = irq;
+
+	/* Setup quirks for the controller */
+
+	/* Currently with ADMA enabled we are getting some length
+	 * interrupts that are not being dealt with, so disable
+	 * ADMA until this is sorted out. */
+	host->quirks |= SDHCI_QUIRK_BROKEN_ADMA;
+	host->quirks |= SDHCI_QUIRK_32BIT_ADMA_SIZE;
+
+	/* It seems we do not get an DATA transfer complete on non-busy
+	 * transfers, not sure if this is a problem with this specific
+	 * SDHCI block, or a missing configuration that needs to be set. */
+	host->quirks |= SDHCI_QUIRK_NO_BUSY_IRQ;
+
+	host->quirks |= (SDHCI_QUIRK_32BIT_DMA_ADDR |
+			 SDHCI_QUIRK_32BIT_DMA_SIZE);
+
+	ret = sdhci_add_host(host);
+	if (ret) {
+		dev_err(dev, "sdhci_add_host() failed (%d)\n", ret);
+		goto err_add_host;
+	}
+
+	return 0;
+
+ err_add_host:
+	release_resource(sc->ioarea);
+	kfree(sc->ioarea);
+
+ err_req_regs:
+	for (ptr = 0; ptr < MAX_BUS_CLK; ptr++) {
+		if (!sc->clk_bus[ptr])
+			continue;
+
+		clk_disable(sc->clk_bus[ptr]);
+		clk_put(sc->clk_bus[ptr]);
+	}
+
+ err_no_busclks:
+	clk_disable(sc->clk_io);
+	clk_put(sc->clk_io);
+
+ err_io_clk:
+	sdhci_free_host(host);
+
+	return ret;
+}
+
+static int __devexit sdhci_s3c_remove(struct platform_device *pdev)
+{
+	return 0;
+}
+
+static struct platform_driver sdhci_s3c_driver = {
+	.probe		= sdhci_s3c_probe,
+	.remove		= __devexit_p(sdhci_s3c_remove),
+	.driver		= {
+		.owner	= THIS_MODULE,
+		.name	= "s3c-sdhci",
+	},
+};
+
+static int __init sdhci_s3c_init(void)
+{
+	return platform_driver_register(&sdhci_s3c_driver);
+}
+
+static void __exit sdhci_s3c_exit(void)
+{
+	platform_driver_unregister(&sdhci_s3c_driver);
+}
+
+module_init(sdhci_s3c_init);
+module_exit(sdhci_s3c_exit);
+
+MODULE_DESCRIPTION("Samsung SDHCI (HSMMC) glue");
+MODULE_AUTHOR("Ben Dooks, <ben@simtec.co.uk>");
+MODULE_LICENSE("GPLv2");
+MODULE_ALIAS("platform:s3c-sdhci");

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
