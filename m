Return-Path: <linux-kernel-owner+w=401wt.eu-S1762349AbZCPVRM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762349AbZCPVRM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 17:17:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761858AbZCPVOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 17:14:10 -0400
Received: from [213.79.90.228] ([213.79.90.228]:2081 "EHLO
	buildserver.ru.mvista.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761810AbZCPVOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 17:14:08 -0400
Date: Tue, 17 Mar 2009 00:14:05 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Pierre Ossman <drzeus-sdhci@drzeus.cx>
Cc: Ben Dooks <ben-linux@fluff.org>, Arnd Bergmann <arnd@arndb.de>,
       Kumar Gala <galak@kernel.crashing.org>,
       Liu Dave <DaveLiu@freescale.com>, sdhci-devel@list.drzeus.cx,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: [PATCH 11/11] mmc: Add OpenFirmware bindings for SDHCI driver
Message-ID: <20090316211405.GK9375@oksana.dev.rtsoft.ru>
References: <20090316211306.GA1736@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20090316211306.GA1736@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new driver: sdhci-of. The driver is similar to
the sdhci-pci, it contains common probe code, and controller-specific
ops and quirks.

So far there are only Freescale eSDHC ops and quirks.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 MAINTAINERS                 |    7 +
 drivers/mmc/host/Kconfig    |   11 ++
 drivers/mmc/host/Makefile   |    1 +
 drivers/mmc/host/sdhci-of.c |  309 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 328 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mmc/host/sdhci-of.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 4a1cfca..77c3ec0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3837,6 +3837,13 @@ M:	drzeus-sdhci@drzeus.cx
 L:	sdhci-devel@list.drzeus.cx
 S:	Maintained
 
+SECURE DIGITAL HOST CONTROLLER INTERFACE, OPEN FIRMWARE BINDINGS (SDHCI-OF)
+P:	Anton Vorontsov
+M:	avorontsov@ru.mvista.com
+L:	linuxppc-dev@ozlabs.org
+L:	sdhci-devel@list.drzeus.cx
+S:	Maintained
+
 SECURITY SUBSYSTEM
 F:	security/
 P:	James Morris
diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index e032a42..69bd124 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -72,6 +72,17 @@ config MMC_RICOH_MMC
 
 	  If unsure, say Y.
 
+config MMC_SDHCI_OF
+	tristate "SDHCI support on OpenFirmware platforms"
+	depends on MMC_SDHCI && PPC_OF
+	select MMC_SDHCI_IO_ACCESSORS
+	help
+	  This selects the OF support for Secure Digital Host Controller
+	  Interfaces. So far, only the Freescale eSDHC controller is known
+	  to exist on OF platforms.
+
+	  If unsure, say N.
+
 config MMC_OMAP
 	tristate "TI OMAP Multimedia Card Interface support"
 	depends on ARCH_OMAP
diff --git a/drivers/mmc/host/Makefile b/drivers/mmc/host/Makefile
index dedec55..dd512d9 100644
--- a/drivers/mmc/host/Makefile
+++ b/drivers/mmc/host/Makefile
@@ -13,6 +13,7 @@ obj-$(CONFIG_MMC_MXC)		+= mxcmmc.o
 obj-$(CONFIG_MMC_SDHCI)		+= sdhci.o
 obj-$(CONFIG_MMC_SDHCI_PCI)	+= sdhci-pci.o
 obj-$(CONFIG_MMC_RICOH_MMC)	+= ricoh_mmc.o
+obj-$(CONFIG_MMC_SDHCI_OF)	+= sdhci-of.o
 obj-$(CONFIG_MMC_WBSD)		+= wbsd.o
 obj-$(CONFIG_MMC_AU1X)		+= au1xmmc.o
 obj-$(CONFIG_MMC_OMAP)		+= omap.o
diff --git a/drivers/mmc/host/sdhci-of.c b/drivers/mmc/host/sdhci-of.c
new file mode 100644
index 0000000..3ff4ac3
--- /dev/null
+++ b/drivers/mmc/host/sdhci-of.c
@@ -0,0 +1,309 @@
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
+struct sdhci_of_host {
+	unsigned int clock;
+	u16 xfer_mode_shadow;
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
+static void esdhc_writel(struct sdhci_host *host, u32 val, int reg)
+{
+	out_be32(host->ioaddr + reg, val);
+}
+
+static void esdhc_writew(struct sdhci_host *host, u16 val, int reg)
+{
+	struct sdhci_of_host *of_host = sdhci_priv(host);
+	int base = reg & ~0x3;
+	int shift = (reg & 0x2) * 8;
+
+	switch (reg) {
+	case SDHCI_TRANSFER_MODE:
+		/*
+		 * Postpone this write, we must do it together with a
+		 * command write that is down below.
+		 */
+		of_host->xfer_mode_shadow = val;
+		return;
+	case SDHCI_COMMAND:
+		esdhc_writel(host, val << 16 | of_host->xfer_mode_shadow,
+			     SDHCI_TRANSFER_MODE);
+		return;
+	case SDHCI_BLOCK_SIZE:
+		/*
+		 * Two last DMA bits are reserved, and first one is used for
+		 * non-standard blksz of 4096 bytes that we don't support
+		 * yet. So clear the DMA boundary bits.
+		 */
+		val &= ~SDHCI_MAKE_BLKSZ(0x7, 0);
+		/* fall through */
+	}
+	clrsetbits_be32(host->ioaddr + base, 0xffff << shift, val << shift);
+}
+
+static void esdhc_writeb(struct sdhci_host *host, u8 val, int reg)
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
+	int pre_div = 2;
+
+	clrbits32(host->ioaddr + ESDHC_SYSTEM_CONTROL, ESDHC_CLOCK_IPGEN |
+		  ESDHC_CLOCK_HCKEN | ESDHC_CLOCK_PEREN | ESDHC_CLOCK_MASK);
+
+	if (clock == 0)
+		goto out;
+
+	if (host->max_clk / 16 > clock) {
+		for (; pre_div < 256; pre_div *= 2) {
+			if (host->max_clk / pre_div < clock * 16)
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
+
+	setbits32(host->ioaddr + ESDHC_SYSTEM_CONTROL, ESDHC_CLOCK_IPGEN |
+		  ESDHC_CLOCK_HCKEN | ESDHC_CLOCK_PEREN |
+		  div << ESDHC_DIVIDER_SHIFT | pre_div << ESDHC_PREDIV_SHIFT);
+	mdelay(100);
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
+static unsigned int esdhc_get_max_clock(struct sdhci_host *host)
+{
+	struct sdhci_of_host *of_host = sdhci_priv(host);
+
+	return of_host->clock;
+}
+
+static unsigned int esdhc_get_timeout_clock(struct sdhci_host *host)
+{
+	struct sdhci_of_host *of_host = sdhci_priv(host);
+
+	return of_host->clock / 1000;
+}
+
+static struct sdhci_of_data sdhci_esdhc = {
+	.quirks = SDHCI_QUIRK_FORCE_BLK_SZ_2048 |
+		  SDHCI_QUIRK_BROKEN_CARD_DETECTION |
+		  SDHCI_QUIRK_INVERTED_WRITE_PROTECT |
+		  SDHCI_QUIRK_NO_BUSY_IRQ |
+		  SDHCI_QUIRK_NONSTANDARD_CLOCK |
+		  SDHCI_QUIRK_PIO_NEEDS_DELAY |
+		  SDHCI_QUIRK_RESTORE_IRQS_AFTER_RESET |
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
+		.get_max_clock = esdhc_get_max_clock,
+		.get_timeout_clock = esdhc_get_timeout_clock,
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
+	struct sdhci_of_host *of_host;
+	const u32 *clk;
+	int size;
+	int ret;
+
+	if (!of_device_is_available(np))
+		return -ENODEV;
+
+	host = sdhci_alloc_host(&ofdev->dev, sizeof(*of_host));
+	if (!host)
+		return -ENOMEM;
+
+	of_host = sdhci_priv(host);
+	dev_set_drvdata(&ofdev->dev, host);
+
+	host->ioaddr = of_iomap(np, 0);
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
+	if (clk && size == sizeof(*clk) && *clk)
+		of_host->clock = *clk;
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
+	{ .compatible = "fsl,mpc8379-esdhc", .data = &sdhci_esdhc, },
+	{ .compatible = "fsl,mpc8536-esdhc", .data = &sdhci_esdhc, },
+	{ .compatible = "generic-sdhci", },
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
