Return-Path: <linux-kernel-owner+w=401wt.eu-S1757710AbZAVCDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757710AbZAVCDY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 21:03:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756730AbZAVCAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 21:00:44 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:44921 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756705AbZAVCAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 21:00:43 -0500
Date: Thu, 22 Jan 2009 05:00:41 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Pierre Ossman <drzeus-sdhci@drzeus.cx>
Cc: Ben Dooks <ben-linux@fluff.org>, Arnd Bergmann <arnd@arndb.de>,
       Kumar Gala <galak@kernel.crashing.org>,
       Liu Dave <DaveLiu@freescale.com>, Xie Xiaobo <X.Xie@freescale.com>,
       Konjin Lai <Konjin.Lai@freescale.com>,
       "Joe D'Abbraccio" <Joe.D'abbraccio@freescale.com>,
       sdhci-devel@list.drzeus.cx, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: [PATCH 10/10] mmc: Add OpenFirmware bindings for SDHCI driver
Message-ID: <20090122020041.GJ11492@oksana.dev.rtsoft.ru>
References: <20090122015649.GA6835@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20090122015649.GA6835@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new driver: sdhci-of. The driver is similar to
the sdhci-pci, it contains common probe code, and controller-specific
ops and quirks.

So far there are only Freescale eSDHC ops and quirks.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/mmc/host/Kconfig    |   10 ++
 drivers/mmc/host/Makefile   |    1 +
 drivers/mmc/host/sdhci-of.c |  274 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 285 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mmc/host/sdhci-of.c

diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index dfa585f..8b5cdef 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -65,6 +65,16 @@ config MMC_RICOH_MMC
 
 	  If unsure, say Y.
 
+config MMC_SDHCI_OF
+	tristate "SDHCI support on OpenFirmware platforms"
+	depends on MMC_SDHCI && PPC_OF
+	help
+	  This selects the OF Secure Digital Host Controller Interface.
+	  So far there is only Freescale eSDHC controller known to exists
+	  on OF platforms.
+
+	  If unsure, say N.
+
 config MMC_OMAP
 	tristate "TI OMAP Multimedia Card Interface support"
 	depends on ARCH_OMAP
diff --git a/drivers/mmc/host/Makefile b/drivers/mmc/host/Makefile
index f485328..5296793 100644
--- a/drivers/mmc/host/Makefile
+++ b/drivers/mmc/host/Makefile
@@ -12,6 +12,7 @@ obj-$(CONFIG_MMC_IMX)		+= imxmmc.o
 obj-$(CONFIG_MMC_SDHCI)		+= sdhci.o
 obj-$(CONFIG_MMC_SDHCI_PCI)	+= sdhci-pci.o
 obj-$(CONFIG_MMC_RICOH_MMC)	+= ricoh_mmc.o
+obj-$(CONFIG_MMC_SDHCI_OF)	+= sdhci-of.o
 obj-$(CONFIG_MMC_WBSD)		+= wbsd.o
 obj-$(CONFIG_MMC_AU1X)		+= au1xmmc.o
 obj-$(CONFIG_MMC_OMAP)		+= omap.o
diff --git a/drivers/mmc/host/sdhci-of.c b/drivers/mmc/host/sdhci-of.c
new file mode 100644
index 0000000..8ee89a1
--- /dev/null
+++ b/drivers/mmc/host/sdhci-of.c
@@ -0,0 +1,274 @@
+/*
+ * OpenFirmware bindings for Secure Digital Host Controller Interface.
+ *
+ * Copyright (c) 2007 Freescale Semiconductor, Inc.
+ * Copyright (c) 2009 MontaVista Software, Inc.
+ *
+ * Authors: Xiaobo Xie <X.Xie@freescale.com>
+ *	    Anton Vorontsov <avorontsov@ru.mvista.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or (at
+ * your option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
+#include <linux/mmc/host.h>
+#include "sdhci.h"
+
+struct sdhci_of_data {
+	unsigned int quirks;
+	struct sdhci_ops ops;
+};
+
+/*
+ * Ops and quirks for the Freescale eSDHC controller.
+ */
+
+#define ESDHC_DMA_SYSCTL	0x40c
+#define ESDHC_DMA_SNOOP		0x00000040
+
+#define ESDHC_SYSTEM_CONTROL	0x2c
+#define ESDHC_CLOCK_MASK	0x0000fff0
+#define ESDHC_PREDIV_SHIFT	8
+#define ESDHC_DIVIDER_SHIFT	4
+#define ESDHC_CLOCK_PEREN	0x00000004
+#define ESDHC_CLOCK_HCKEN	0x00000002
+#define ESDHC_CLOCK_IPGEN	0x00000001
+
+static u32 esdhc_readl(struct sdhci_host *host, int reg)
+{
+	return in_be32(host->ioaddr + reg);
+}
+
+static u16 esdhc_readw(struct sdhci_host *host, int reg)
+{
+	return in_be16(host->ioaddr + (reg ^ 0x2));
+}
+
+static u8 esdhc_readb(struct sdhci_host *host, int reg)
+{
+	return in_8(host->ioaddr + (reg ^ 0x3));
+}
+
+static void esdhc_writel(struct sdhci_host *host, int reg, u32 val)
+{
+	out_be32(host->ioaddr + reg, val);
+}
+
+static void esdhc_writew(struct sdhci_host *host, int reg, u16 val)
+{
+	int base = reg & ~0x3;
+	int shift = (reg & 0x2) * 8;
+
+	clrsetbits_be32(host->ioaddr + base, 0xffff << shift, val << shift);
+}
+
+static void esdhc_writeb(struct sdhci_host *host, int reg, u8 val)
+{
+	int base = reg & ~0x3;
+	int shift = (reg & 0x3) * 8;
+
+	clrsetbits_be32(host->ioaddr + base , 0xff << shift, val << shift);
+}
+
+static void esdhc_set_clock(struct sdhci_host *host, unsigned int clock)
+{
+	int div;
+	int pre_div = 1;
+
+	setbits32(host->ioaddr + ESDHC_SYSTEM_CONTROL, ESDHC_CLOCK_IPGEN |
+		  ESDHC_CLOCK_HCKEN | ESDHC_CLOCK_PEREN);
+
+	clrbits32(host->ioaddr + ESDHC_SYSTEM_CONTROL, ESDHC_CLOCK_MASK);
+
+	if (clock == 0)
+		goto out;
+
+	if (host->max_clk / 16 > clock) {
+		for (; pre_div < 256; pre_div *= 2) {
+			if (host->max_clk / pre_div < clock*16)
+				break;
+		}
+	}
+
+	for (div = 1; div <= 16; div++) {
+		if (host->max_clk / (div * pre_div) <= clock)
+			break;
+	}
+
+	pre_div >>= 1;
+	div -= 1;
+
+	setbits32(host->ioaddr + ESDHC_SYSTEM_CONTROL,
+		div << ESDHC_DIVIDER_SHIFT | pre_div << ESDHC_PREDIV_SHIFT);
+	mdelay(10);
+out:
+	host->clock = clock;
+}
+
+static int esdhc_enable_dma(struct sdhci_host *host)
+{
+	setbits32(host->ioaddr + ESDHC_DMA_SYSCTL, ESDHC_DMA_SNOOP);
+	return 0;
+}
+
+static struct sdhci_of_data sdhci_esdhc = {
+	.quirks = SDHCI_QUIRK_FSL |
+		  SDHCI_QUIRK_32BIT_REGISTERS |
+		  SDHCI_QUIRK_PIO_IRQS_DURING_DMA |
+		  SDHCI_QUIRK_BROKEN_CARD_DETECTION |
+		  SDHCI_QUIRK_INVERTED_WRITE_PROTECT |
+		  SDHCI_QUIRK_NO_BUSY_IRQ |
+		  SDHCI_QUIRK_NO_CARD_NO_RESET,
+	.ops = {
+		.readl = esdhc_readl,
+		.readw = esdhc_readw,
+		.readb = esdhc_readb,
+		.writel = esdhc_writel,
+		.writew = esdhc_writew,
+		.writeb = esdhc_writeb,
+		.set_clock = esdhc_set_clock,
+		.enable_dma = esdhc_enable_dma,
+	},
+};
+
+#ifdef CONFIG_PM
+
+static int sdhci_of_suspend(struct of_device *ofdev, pm_message_t state)
+{
+	struct sdhci_host *host = dev_get_drvdata(&ofdev->dev);
+
+	return mmc_suspend_host(host->mmc, state);
+}
+
+static int sdhci_of_resume(struct of_device *ofdev)
+{
+	struct sdhci_host *host = dev_get_drvdata(&ofdev->dev);
+
+	return mmc_resume_host(host->mmc);
+}
+
+#else
+
+#define sdhci_of_suspend NULL
+#define sdhci_of_resume NULL
+
+#endif
+
+static int __devinit sdhci_of_probe(struct of_device *ofdev,
+				 const struct of_device_id *match)
+{
+	struct device_node *np = ofdev->node;
+	struct sdhci_of_data *sdhci_of_data = match->data;
+	struct sdhci_host *host;
+	struct resource mem;
+	const u32 *clk;
+	int size;
+	int ret;
+
+	host = sdhci_alloc_host(&ofdev->dev, sizeof(*host));
+	if (!host)
+		return -ENOMEM;
+
+	dev_set_drvdata(&ofdev->dev, host);
+
+	ret = of_address_to_resource(np, 0, &mem);
+	if (ret)
+		goto err_no_addr;
+
+	host->ioaddr = ioremap(mem.start, resource_size(&mem));
+	if (!host->ioaddr) {
+		ret = -ENOMEM;
+		goto err_addr_map;
+	}
+
+	host->irq = irq_of_parse_and_map(np, 0);
+	if (!host->irq) {
+		ret = -EINVAL;
+		goto err_no_irq;
+	}
+
+	host->hw_name = dev_name(&ofdev->dev);
+	if (sdhci_of_data) {
+		host->quirks = sdhci_of_data->quirks;
+		host->ops = &sdhci_of_data->ops;
+	}
+
+	clk = of_get_property(np, "clock-frequency", &size);
+	if (clk && size == sizeof(*clk) && *clk) {
+		host->max_clk = *clk;
+		host->timeout_clk = *clk / 1000;
+	}
+
+	ret = sdhci_add_host(host);
+	if (ret)
+		goto err_add_host;
+
+	return 0;
+
+err_add_host:
+	irq_dispose_mapping(host->irq);
+err_no_irq:
+	iounmap(host->ioaddr);
+err_addr_map:
+err_no_addr:
+	sdhci_free_host(host);
+	return ret;
+}
+
+static int __devexit sdhci_of_remove(struct of_device *ofdev)
+{
+	struct sdhci_host *host = dev_get_drvdata(&ofdev->dev);
+
+	sdhci_remove_host(host, 0);
+	sdhci_free_host(host);
+	irq_dispose_mapping(host->irq);
+	iounmap(host->ioaddr);
+	return 0;
+}
+
+static const struct of_device_id sdhci_of_match[] = {
+	{
+		.compatible = "fsl,esdhc",
+		.data = &sdhci_esdhc,
+	},
+	{
+		.compatible = "generic-sdhci",
+	},
+	{},
+};
+MODULE_DEVICE_TABLE(of, sdhci_of_match);
+
+static struct of_platform_driver sdhci_of_driver = {
+	.driver.name = "sdhci-of",
+	.match_table = sdhci_of_match,
+	.probe = sdhci_of_probe,
+	.remove = __devexit_p(sdhci_of_remove),
+	.suspend = sdhci_of_suspend,
+	.resume	= sdhci_of_resume,
+};
+
+static int __init sdhci_of_init(void)
+{
+	return of_register_platform_driver(&sdhci_of_driver);
+}
+module_init(sdhci_of_init);
+
+static void __exit sdhci_of_exit(void)
+{
+	of_unregister_platform_driver(&sdhci_of_driver);
+}
+module_exit(sdhci_of_exit);
+
+MODULE_DESCRIPTION("Secure Digital Host Controller Interface OF driver");
+MODULE_AUTHOR("Xiaobo Xie <X.Xie@freescale.com>, "
+	      "Anton Vorontsov <avorontsov@ru.mvista.com>");
+MODULE_LICENSE("GPL");
-- 
1.5.6.5
