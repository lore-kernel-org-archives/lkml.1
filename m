Return-Path: <linux-kernel-owner+w=401wt.eu-S1754192AbZIAL72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192AbZIAL72 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 07:59:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753197AbZIAL71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 07:59:27 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:36162 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178AbZIAL70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 07:59:26 -0400
From: Sudhakar Rajashekhara <sudhakar.raj@ti.com>
To: linux-parport@lists.infradead.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       davinci-linux-open-source@linux.davincidsp.com,
       Sudhakar Rajashekhara <sudhakar.raj@ti.com>
Subject: [PATCH] parport: Add character LCD driver for da850/omap-l138
Date: Tue,  1 Sep 2009 17:22:39 -0400
Message-Id: <1251840159-22313-1-git-send-email-sudhakar.raj@ti.com>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On TI DA850/OMAP-L138 EVM, HD44780 (24x2) LCD panel is
being used, interfaced through the SoC specific LCD
interface[1].

Driver from drivers/staging/panel/panel.c works for this
LCD panel but that driver expects the LCD panel to be
interfaced through a parallel port.

This patch implements a dummy parallel port driver which
interfaces to the panel driver in staging area through the
LCD interface available on SoC.

Signed-off-by: Sudhakar Rajashekhara <sudhakar.raj@ti.com>
---
 drivers/parport/Kconfig               |    8 +
 drivers/parport/Makefile              |    3 +-
 drivers/parport/parport_da8xx.c       |  324 +++++++++++++++++++++++++++++++++
 include/linux/parport_da8xx.h         |   28 +++
 4 files changed, 362 insertions(+), 1 deletions(-)
 create mode 100644 drivers/parport/parport_da8xx.c
 create mode 100644 include/linux/parport_da8xx.h

diff --git a/drivers/parport/Kconfig b/drivers/parport/Kconfig
index 855f389..5709b88 100644
--- a/drivers/parport/Kconfig
+++ b/drivers/parport/Kconfig
@@ -154,6 +154,14 @@ config PARPORT_1284
 	  transfer modes. Also say Y if you want device ID information to
 	  appear in /proc/sys/dev/parport/*/autoprobe*. It is safe to say N.
 
+config PARPORT_DA8XX
+	tristate "DA8XX Dummy Parallel Port"
+	depends on ARCH_DAVINCI_DA8XX && !(FB_DA8XX = y) && !(FB_DA8XX = m)
+	select PARPORT_NOT_PC
+	help
+	  Say Y here if you need support for the DA8XX/OMAP-L1XX character
+	  LCD which is using the staging panel driver.
+
 config PARPORT_NOT_PC
 	bool
 
diff --git a/drivers/parport/Makefile b/drivers/parport/Makefile
index 696b8d4..ad7dfd0 100644
--- a/drivers/parport/Makefile
+++ b/drivers/parport/Makefile
@@ -18,4 +18,5 @@ obj-$(CONFIG_PARPORT_ATARI)	+= parport_atari.o
 obj-$(CONFIG_PARPORT_SUNBPP)	+= parport_sunbpp.o
 obj-$(CONFIG_PARPORT_GSC)	+= parport_gsc.o
 obj-$(CONFIG_PARPORT_AX88796)	+= parport_ax88796.o
-obj-$(CONFIG_PARPORT_IP32)	+= parport_ip32.o
\ No newline at end of file
+obj-$(CONFIG_PARPORT_IP32)	+= parport_ip32.o
+obj-$(CONFIG_PARPORT_DA8XX)	+= parport_da8xx.o
diff --git a/drivers/parport/parport_da8xx.c b/drivers/parport/parport_da8xx.c
new file mode 100644
index 0000000..117123f
--- /dev/null
+++ b/drivers/parport/parport_da8xx.c
@@ -0,0 +1,324 @@
+/* linux/drivers/parport/parport_da8xx.c
+ *
+ * Copyright (C) 2009 Texas Instruments Incorporated - http://www.ti.com/
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed .as is. WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/parport.h>
+#include <linux/parport_da8xx.h>
+#include <linux/interrupt.h>
+#include <linux/errno.h>
+#include <linux/delay.h>
+#include <linux/clk.h>
+#include <linux/platform_device.h>
+#include <linux/io.h>
+
+#include <asm/irq.h>
+
+/* LCDC register offsets */
+#define LCDC_LCD_CTRL			0x04
+#define LCDC_LIDD_CTRL			0x0c
+#define LCDC_LIDD_CS0_CONF		0x10
+#define LCDC_LIDD_CS0_ADDR		0x14
+#define LCDC_LIDD_CS0_DATA		0x18
+#define LCDC_LIDD_CS1_CONF		0x1c
+#define LCDC_LIDD_CS1_ADDR		0x20
+#define LCDC_LIDD_CS1_DATA		0x24
+
+#define LCD_CTRL_RASTER_MODE		BIT(0)
+#define LIDD_CONF_W_SU			BIT(27)
+#define LIDD_CONF_W_STROBE		(4 << 21)
+#define LIDD_CONF_W_HOLD		BIT(17)
+#define LIDD_CONF_R_SU			BIT(12)
+#define LIDD_CONF_R_STROBE		(4 << 6)
+#define LIDD_CONF_R_HOLD		BIT(2)
+#define LIDD_CTRL_MODE_SEL_MASK		0x7
+#define LIDD_CTRL_MODE_HITACHI		0x4
+
+struct da8xx_drvdata {
+	struct parport		*parport;
+
+	struct device		*dev;
+	struct resource		*io;
+	struct clk		*clk;
+
+	unsigned char		irq_enabled;
+	unsigned char		version;
+
+	void __iomem		*base;
+	void __iomem            *spp_data;
+	void __iomem            *spp_cpr;
+};
+
+static inline struct da8xx_drvdata *pp_to_drv(struct parport *p)
+{
+	return p->private_data;
+}
+
+static void
+parport_da8xx_init_state(struct pardevice *d, struct parport_state *s)
+{
+	struct da8xx_drvdata *dd = pp_to_drv(d->port);
+
+	memset(s, 0, sizeof(struct parport_state));
+
+	dev_dbg(dd->dev, "init_state: %p: state=%p\n", d, s);
+}
+
+static void
+parport_da8xx_save_state(struct parport *p, struct parport_state *s)
+{
+	/* do nothing */
+}
+
+static void
+parport_da8xx_restore_state(struct parport *p, struct parport_state *s)
+{
+	/* do nothing */
+}
+
+static unsigned char
+parport_da8xx_read_data(struct parport *p)
+{
+	struct da8xx_drvdata *dd = pp_to_drv(p);
+
+	return readl(dd->spp_data);
+}
+
+static void
+parport_da8xx_write_data(struct parport *p, unsigned char data)
+{
+	struct da8xx_drvdata *dd = pp_to_drv(p);
+
+	writel(data, dd->spp_data);
+}
+
+static unsigned char
+parport_da8xx_read_control(struct parport *p)
+{
+	struct da8xx_drvdata *dd = pp_to_drv(p);
+
+	return readl(dd->spp_cpr);
+}
+
+static void
+parport_da8xx_write_control(struct parport *p, unsigned char control)
+{
+	struct da8xx_drvdata *dd = pp_to_drv(p);
+
+	writel(control, dd->spp_cpr);
+}
+
+static void da8xx_init_clcd(struct parport *p)
+{
+	struct da8xx_drvdata *dd = pp_to_drv(p);
+	unsigned int regval;
+
+	regval = readl(dd->base + LCDC_LCD_CTRL);
+	regval &= ~LCD_CTRL_RASTER_MODE;
+	writel(regval, dd->base + LCDC_LCD_CTRL);
+
+	regval = readl(dd->base + LCDC_LCD_CTRL);
+	regval &= ~0xFF00;
+	writel(regval, dd->base + LCDC_LCD_CTRL);
+
+	regval = readl(dd->base + LCDC_LCD_CTRL);
+	regval |= 0x7F00;
+	writel(regval, dd->base + LCDC_LCD_CTRL);
+
+	regval = readl(dd->base + LCDC_LIDD_CTRL);
+	regval &= ~LIDD_CTRL_MODE_SEL_MASK;
+	writel(regval, dd->base + LCDC_LIDD_CTRL);
+
+	regval = readl(dd->base + LCDC_LIDD_CTRL);
+	regval |= LIDD_CTRL_MODE_HITACHI;
+	writel(regval, dd->base + LCDC_LIDD_CTRL);
+
+	regval = LIDD_CONF_W_SU | LIDD_CONF_W_STROBE | LIDD_CONF_W_HOLD |
+		LIDD_CONF_R_SU | LIDD_CONF_R_STROBE | LIDD_CONF_R_HOLD;
+
+	if (dd->version == CONFIG_SPACE_0)
+		writel(regval, dd->base + LCDC_LIDD_CS0_CONF);
+	else
+		writel(regval, dd->base + LCDC_LIDD_CS1_CONF);
+}
+
+static struct parport_operations parport_da8xx_ops = {
+	.init_state	= parport_da8xx_init_state,
+	.save_state	= parport_da8xx_save_state,
+	.restore_state	= parport_da8xx_restore_state,
+
+	.write_data	= parport_da8xx_write_data,
+	.read_data	= parport_da8xx_read_data,
+
+	.write_control	= parport_da8xx_write_control,
+	.read_control	= parport_da8xx_read_control,
+
+	.owner		= THIS_MODULE,
+};
+
+static int parport_da8xx_probe(struct platform_device *pdev)
+{
+	struct da8xx_clcd_platform_data *pdata = pdev->dev.platform_data;
+	struct device *_dev = &pdev->dev;
+	struct da8xx_drvdata *dd;
+	struct parport *pp = NULL;
+	struct resource *res;
+	unsigned long size;
+	int irq;
+	int ret;
+
+	dd = kzalloc(sizeof(struct da8xx_drvdata), GFP_KERNEL);
+	if (dd == NULL) {
+		dev_err(_dev, "no memory for private data\n");
+		return -ENOMEM;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (res == NULL) {
+		dev_err(_dev, "no MEM specified\n");
+		ret = -ENXIO;
+		goto exit_mem;
+	}
+
+	size = resource_size(res);
+
+	dd->io = request_mem_region(res->start, size, pdev->name);
+	if (dd->io == NULL) {
+		dev_err(_dev, "cannot reserve memory\n");
+		ret = -ENXIO;
+		goto exit_mem;
+	}
+
+	dd->base = ioremap(res->start, size);
+	if (dd->base == NULL) {
+		dev_err(_dev, "cannot ioremap region\n");
+		ret = -ENXIO;
+		goto exit_res;
+	}
+
+	dd->clk = clk_get(&pdev->dev, NULL);
+	if (IS_ERR(dd->clk)) {
+		dev_err(_dev, "Can not get device clock\n");
+		ret = -ENODEV;
+		goto exit_unmap;
+	}
+	clk_enable(dd->clk);
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq <= 0)
+		irq = PARPORT_IRQ_NONE;
+
+	pp = parport_register_port((unsigned long)dd->base, irq,
+				   PARPORT_DMA_NONE,
+				   &parport_da8xx_ops);
+
+	if (pp == NULL) {
+		dev_err(_dev, "failed to register parallel port\n");
+		ret = -ENOMEM;
+		goto exit_clk_put;
+	}
+
+	pp->private_data = dd;
+	dd->parport = pp;
+	dd->dev = pp->dev = _dev;
+	dd->version = pdata->version;
+
+	if (dd->version == CONFIG_SPACE_0) {
+		dd->spp_data = dd->base + LCDC_LIDD_CS0_DATA;
+		dd->spp_cpr  = dd->base + LCDC_LIDD_CS0_ADDR;
+	} else {
+		dd->spp_data = dd->base + LCDC_LIDD_CS1_DATA;
+		dd->spp_cpr  = dd->base + LCDC_LIDD_CS1_ADDR;
+	}
+
+	/* initialize LCDC */
+	da8xx_init_clcd(pp);
+
+	if (irq >= 0) {
+		/* request irq */
+		ret = request_irq(irq, parport_irq_handler,
+				  IRQF_TRIGGER_FALLING, pdev->name, pp);
+
+		if (ret < 0)
+			goto exit_port;
+
+		dd->irq_enabled = 1;
+	}
+
+	platform_set_drvdata(pdev, pp);
+
+	dev_info(_dev, "attached parallel port driver\n");
+	parport_announce_port(pp);
+
+	return 0;
+
+ exit_port:
+	parport_remove_port(pp);
+ exit_clk_put:
+	clk_disable(dd->clk);
+	clk_put(dd->clk);
+ exit_unmap:
+	iounmap(dd->base);
+ exit_res:
+	release_resource(dd->io);
+	kfree(dd->io);
+ exit_mem:
+	kfree(dd);
+	return ret;
+}
+
+static int parport_da8xx_remove(struct platform_device *pdev)
+{
+	struct parport *p = platform_get_drvdata(pdev);
+	struct da8xx_drvdata *dd = pp_to_drv(p);
+
+	free_irq(p->irq, p);
+	parport_remove_port(p);
+	clk_disable(dd->clk);
+	clk_put(dd->clk);
+	iounmap(dd->base);
+	release_resource(dd->io);
+	kfree(dd->io);
+	kfree(dd);
+
+	return 0;
+}
+
+MODULE_ALIAS("platform:da8xx_lcdc");
+
+static struct platform_driver da8xx_drv = {
+	.driver		= {
+		.name	= "da8xx_lcdc",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= parport_da8xx_probe,
+	.remove		= parport_da8xx_remove,
+};
+
+static int __init parport_da8xx_init(void)
+{
+	return platform_driver_register(&da8xx_drv);
+}
+
+static void __exit parport_da8xx_exit(void)
+{
+	platform_driver_unregister(&da8xx_drv);
+}
+
+module_init(parport_da8xx_init)
+module_exit(parport_da8xx_exit)
+
+MODULE_AUTHOR("Texas Instruments");
+MODULE_DESCRIPTION("DA8xx/OMAP-L1xx Parport parallel port driver");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/parport_da8xx.h b/include/linux/parport_da8xx.h
new file mode 100644
index 0000000..53a01a3
--- /dev/null
+++ b/include/linux/parport_da8xx.h
@@ -0,0 +1,28 @@
+/*
+ * Header file for TI DA8XX/OMAP-L1XX LCD controller platform data.
+ *
+ * Copyright (C) 2009 Texas Instruments Incorporated - http://www.ti.com/
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed .as is. WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef PARPORT_DA8XX_H
+#define PARPORT_DA8XX_H
+
+struct da8xx_clcd_platform_data {
+	u8 version;
+};
+
+enum {
+	CONFIG_SPACE_0 = 0,	/* DA830 */
+	CONFIG_SPACE_1,		/* DA850 */
+};
+
+#endif  /* ifndef PARPORT_DA8XX_H */
-- 
1.5.6

