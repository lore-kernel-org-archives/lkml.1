Return-Path: <linux-kernel-owner+w=401wt.eu-S1755472AbZKQGsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472AbZKQGsn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 01:48:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754164AbZKQGsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 01:48:42 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:54004 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970AbZKQGsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 01:48:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=Gx7NNo5W8gtFbTiZd9yLtrnn7vFwAlUXn3TlIj8udLoY0i+5KEqgO2ydbuZSg2TiW2
         Pgc+Fm9bS9xHoscqRJamoUy8syPjzyfKzPVvEbSroWaAO/rf4b6zTPX8LyIgwRUYz/qj
         PPraqb04Wx3FfVKjPH1oio767teGwcsnakoAg=
Message-ID: <4B024748.9080001@gmail.com>
Date: Tue, 17 Nov 2009 14:48:40 +0800
From: Wan ZongShun <mcuos.com@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-spi <spi-devel-general@lists.sourceforge.net>,
       David Brownell-sourceforge <dbrownell@users.sourceforge.net>
CC: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] ARM: Add spi controller driver support for NUC900
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear David,

Add winbond/nuvoton NUC900 spi controller driver support, 
on my evaluation board,there is a winbond w25x16 spi flash,
so I test my spi controller driver with m25p80.c.

Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>
---
 arch/arm/mach-w90x900/include/mach/nuc900_spi.h |   35 ++
 drivers/spi/Kconfig                             |    7 +
 drivers/spi/Makefile                            |    1 +
 drivers/spi/spi_nuc900.c                        |  458 +++++++++++++++++++++++
 4 files changed, 501 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-w90x900/include/mach/nuc900_spi.h
 create mode 100644 drivers/spi/spi_nuc900.c

diff --git a/arch/arm/mach-w90x900/include/mach/nuc900_spi.h b/arch/arm/mach-w90x900/include/mach/nuc900_spi.h
new file mode 100644
index 0000000..24ea23b
--- /dev/null
+++ b/arch/arm/mach-w90x900/include/mach/nuc900_spi.h
@@ -0,0 +1,35 @@
+/*
+ * arch/arm/mach-w90x900/include/mach/nuc900_spi.h
+ *
+ * Copyright (c) 2009 Nuvoton technology corporation.
+ *
+ * Wan ZongShun <mcuos.com@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation;version 2 of the License.
+ *
+ */
+
+#ifndef __ASM_ARCH_SPI_H
+#define __ASM_ARCH_SPI_H
+
+extern void mfp_set_groupg(struct device *dev);
+
+struct w90p910_spi_info {
+	unsigned int num_cs;
+	unsigned int lsb;
+	unsigned int txneg;
+	unsigned int rxneg;
+	unsigned int divider;
+	unsigned int sleep;
+	unsigned int txnum;
+	unsigned int txbitlen;
+	int bus_num;
+};
+
+struct w90p910_spi_chip {
+	unsigned char bits_per_word;
+};
+
+#endif /* __ASM_ARCH_SPI_H */
diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index 4b6f7cb..2e1b20c 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -244,6 +244,13 @@ config SPI_XILINX
 	  See the "OPB Serial Peripheral Interface (SPI) (v1.00e)"
 	  Product Specification document (DS464) for hardware details.
 
+config SPI_NUC900
+	tristate "Nuvoton NUC900 series SPI"
+	depends on ARCH_W90X900 && EXPERIMENTAL
+	select SPI_BITBANG
+	help
+	  SPI driver for Nuvoton NUC900 series ARM SoCs
+
 #
 # Add new SPI master controllers in alphabetical order above this line
 #
diff --git a/drivers/spi/Makefile b/drivers/spi/Makefile
index 21a1182..694a4cb 100644
--- a/drivers/spi/Makefile
+++ b/drivers/spi/Makefile
@@ -33,6 +33,7 @@ obj-$(CONFIG_SPI_TXX9)			+= spi_txx9.o
 obj-$(CONFIG_SPI_XILINX)		+= xilinx_spi.o
 obj-$(CONFIG_SPI_SH_SCI)		+= spi_sh_sci.o
 obj-$(CONFIG_SPI_STMP3XXX)		+= spi_stmp.o
+obj-$(CONFIG_SPI_NUC900)		+= spi_nuc900.o
 # 	... add above this line ...
 
 # SPI protocol drivers (device/link on bus)
diff --git a/drivers/spi/spi_nuc900.c b/drivers/spi/spi_nuc900.c
new file mode 100644
index 0000000..bb3b50c
--- /dev/null
+++ b/drivers/spi/spi_nuc900.c
@@ -0,0 +1,458 @@
+/* linux/drivers/spi/spi_nuc900.c
+ *
+ * Copyright (c) 2009 Nuvoton technology.
+ * Wan ZongShun <mcuos.com@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+*/
+
+#include <linux/init.h>
+#include <linux/spinlock.h>
+#include <linux/workqueue.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/clk.h>
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/gpio.h>
+#include <linux/io.h>
+
+#include <linux/spi/spi.h>
+#include <linux/spi/spi_bitbang.h>
+
+#include <mach/nuc900_spi.h>
+
+/* usi registers offset */
+#define USI_CNT		0x00
+#define USI_DIV		0x04
+#define USI_SSR		0x08
+#define USI_RX0		0x10
+#define USI_TX0		0x10
+
+/* usi register bit */
+#define ENINT		(0x01 << 17)
+#define ENFLG		(0x01 << 16)
+#define TXNUM		(0x03 << 8)
+#define TXNEG		(0x01 << 2)
+#define RXNEG		(0x01 << 1)
+#define LSB		(0x01 << 10)
+#define SELECTLEV	(0x01 << 2)
+#define SELECTPOL	(0x01 << 31)
+#define SELECTSLAVE	0x01
+#define GOBUSY		0x01
+
+struct w90p910_spi {
+	struct spi_bitbang	 bitbang;
+	struct completion	 done;
+	void __iomem		*regs;
+	int			 irq;
+	int			 len;
+	int			 count;
+	const unsigned char	*tx;
+	unsigned char		*rx;
+	struct clk		*clk;
+	struct resource		*ioarea;
+	struct spi_master	*master;
+	struct spi_device	*curdev;
+	struct device		*dev;
+	struct w90p910_spi_info *pdata;
+};
+
+static inline struct w90p910_spi *to_hw(struct spi_device *sdev)
+{
+	return spi_master_get_devdata(sdev->master);
+}
+
+static void w90p910_slave_seclect(struct spi_device *spi, unsigned int ssr)
+{
+	struct w90p910_spi *hw = to_hw(spi);
+	unsigned int val;
+	unsigned int cs = spi->mode & SPI_CS_HIGH ? 1 : 0;
+	unsigned int cpol = spi->mode & SPI_CPOL ? 1 : 0;
+
+	val = __raw_readl(hw->regs + USI_SSR);
+
+	if (!cs)
+		val &= ~SELECTLEV;
+	else
+		val |= SELECTLEV;
+
+	if (!ssr)
+		val &= ~SELECTSLAVE;
+	else
+		val |= SELECTSLAVE;
+
+	__raw_writel(val, hw->regs + USI_SSR);
+
+	val = __raw_readl(hw->regs + USI_CNT);
+
+	if (!cpol)
+		val &= ~SELECTPOL;
+	else
+		val |= SELECTPOL;
+
+	__raw_writel(val, hw->regs + USI_CNT);
+}
+
+static void w90p910_spi_chipsel(struct spi_device *spi, int value)
+{
+	switch (value) {
+	case BITBANG_CS_INACTIVE:
+		w90p910_slave_seclect(spi, 0);
+		break;
+
+	case BITBANG_CS_ACTIVE:
+		w90p910_slave_seclect(spi, 1);
+		break;
+	}
+}
+
+static void w90p910_spi_setup_txnum(struct w90p910_spi *hw,
+							unsigned int txnum)
+{
+	unsigned int val;
+
+	val = __raw_readl(hw->regs + USI_CNT);
+
+	if (!txnum)
+		val &= ~TXNUM;
+	else
+		val |= txnum << 0x08;
+
+	__raw_writel(val, hw->regs + USI_CNT);
+
+}
+
+static void w90p910_spi_setup_txbitlen(struct w90p910_spi *hw,
+							unsigned int txbitlen)
+{
+	unsigned int val;
+
+	val = __raw_readl(hw->regs + USI_CNT);
+
+	val |= (txbitlen << 0x03);
+
+	__raw_writel(val, hw->regs + USI_CNT);
+}
+
+static void w90p910_spi_gobusy(struct w90p910_spi *hw)
+{
+	unsigned int val;
+
+	val = __raw_readl(hw->regs + USI_CNT);
+
+	val |= GOBUSY;
+
+	__raw_writel(val, hw->regs + USI_CNT);
+}
+
+static int w90p910_spi_setupxfer(struct spi_device *spi,
+				 struct spi_transfer *t)
+{
+	return 0;
+}
+
+static int w90p910_spi_setup(struct spi_device *spi)
+{
+	return 0;
+}
+
+static inline unsigned int hw_txbyte(struct w90p910_spi *hw, int count)
+{
+	return hw->tx ? hw->tx[count] : 0;
+}
+
+static int w90p910_spi_txrx(struct spi_device *spi, struct spi_transfer *t)
+{
+	struct w90p910_spi *hw = to_hw(spi);
+
+	hw->tx = t->tx_buf;
+	hw->rx = t->rx_buf;
+	hw->len = t->len;
+	hw->count = 0;
+
+	init_completion(&hw->done);
+
+	__raw_writel(hw_txbyte(hw, 0x0), hw->regs + USI_TX0);
+
+	w90p910_spi_gobusy(hw);
+
+	wait_for_completion(&hw->done);
+
+	return hw->count;
+}
+
+static irqreturn_t w90p910_spi_irq(int irq, void *dev)
+{
+	struct w90p910_spi *hw = dev;
+	unsigned int status;
+	unsigned int count = hw->count;
+
+	status = __raw_readl(hw->regs + USI_CNT);
+	__raw_writel(status, hw->regs + USI_CNT);
+
+	if (status & ENFLG) {
+		hw->count++;
+
+		if (hw->rx)
+			hw->rx[count] = __raw_readl(hw->regs + USI_RX0);
+		count++;
+
+		if (count < hw->len) {
+			__raw_writel(hw_txbyte(hw, count), hw->regs + USI_TX0);
+			w90p910_spi_gobusy(hw);
+		} else {
+			complete(&hw->done);
+		}
+
+		return IRQ_HANDLED;
+	}
+
+	complete(&hw->done);
+	return IRQ_HANDLED;
+}
+
+static void w90p910_tx_edge(struct w90p910_spi *hw, unsigned int edge)
+{
+	unsigned int val;
+
+	val = __raw_readl(hw->regs + USI_CNT);
+
+	if (edge)
+		val |= TXNEG;
+	else
+		val &= ~TXNEG;
+	__raw_writel(val, hw->regs + USI_CNT);
+}
+
+static void w90p910_rx_edge(struct w90p910_spi *hw, unsigned int edge)
+{
+	unsigned int val;
+
+	val = __raw_readl(hw->regs + USI_CNT);
+
+	if (edge)
+		val |= RXNEG;
+	else
+		val &= ~RXNEG;
+	__raw_writel(val, hw->regs + USI_CNT);
+}
+
+static void w90p910_send_first(struct w90p910_spi *hw, unsigned int lsb)
+{
+	unsigned int val;
+
+	val = __raw_readl(hw->regs + USI_CNT);
+
+	if (lsb)
+		val |= LSB;
+	else
+		val &= ~LSB;
+	__raw_writel(val, hw->regs + USI_CNT);
+}
+
+static void w90p910_set_sleep(struct w90p910_spi *hw, unsigned int sleep)
+{
+	unsigned int val;
+
+	val = __raw_readl(hw->regs + USI_CNT);
+
+	if (sleep)
+		val |= (sleep << 12);
+	else
+		val &= ~(0x0f << 12);
+	__raw_writel(val, hw->regs + USI_CNT);
+}
+
+static void w90p910_enable_int(struct w90p910_spi *hw)
+{
+	unsigned int val;
+
+	val = __raw_readl(hw->regs + USI_CNT);
+
+	val |= ENINT;
+
+	__raw_writel(val, hw->regs + USI_CNT);
+}
+
+static void w90p910_set_divider(struct w90p910_spi *hw)
+{
+	__raw_writel(hw->pdata->divider, hw->regs + USI_DIV);
+}
+
+static void w90p910_init_spi(struct w90p910_spi *hw)
+{
+	clk_enable(hw->clk);
+
+	w90p910_tx_edge(hw, hw->pdata->txneg);
+	w90p910_rx_edge(hw, hw->pdata->rxneg);
+	w90p910_send_first(hw, hw->pdata->lsb);
+	w90p910_set_sleep(hw, hw->pdata->sleep);
+	w90p910_spi_setup_txbitlen(hw, hw->pdata->txbitlen);
+	w90p910_spi_setup_txnum(hw, hw->pdata->txnum);
+	w90p910_set_divider(hw);
+	w90p910_enable_int(hw);
+}
+
+static int __devinit w90p910_spi_probe(struct platform_device *pdev)
+{
+	struct w90p910_spi *hw;
+	struct spi_master *master;
+	struct resource *res;
+	int err = 0;
+
+	master = spi_alloc_master(&pdev->dev, sizeof(struct w90p910_spi));
+	if (master == NULL) {
+		dev_err(&pdev->dev, "No memory for spi_master\n");
+		err = -ENOMEM;
+		goto err_nomem;
+	}
+
+	hw = spi_master_get_devdata(master);
+	memset(hw, 0, sizeof(struct w90p910_spi));
+
+	hw->master = spi_master_get(master);
+	hw->pdata  = pdev->dev.platform_data;
+	hw->dev = &pdev->dev;
+
+	if (hw->pdata == NULL) {
+		dev_err(&pdev->dev, "No platform data supplied\n");
+		err = -ENOENT;
+		goto err_pdata;
+	}
+
+	platform_set_drvdata(pdev, hw);
+	init_completion(&hw->done);
+
+	master->mode_bits          = SPI_MODE_0;
+	master->num_chipselect     = hw->pdata->num_cs;
+	master->bus_num            = hw->pdata->bus_num;
+	hw->bitbang.master         = hw->master;
+	hw->bitbang.setup_transfer = w90p910_spi_setupxfer;
+	hw->bitbang.chipselect     = w90p910_spi_chipsel;
+	hw->bitbang.txrx_bufs      = w90p910_spi_txrx;
+	hw->bitbang.master->setup  = w90p910_spi_setup;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (res == NULL) {
+		dev_err(&pdev->dev, "Cannot get IORESOURCE_MEM\n");
+		err = -ENOENT;
+		goto err_pdata;
+	}
+
+	hw->ioarea = request_mem_region(res->start,
+					resource_size(res), pdev->name);
+
+	if (hw->ioarea == NULL) {
+		dev_err(&pdev->dev, "Cannot reserve region\n");
+		err = -ENXIO;
+		goto err_pdata;
+	}
+
+	hw->regs = ioremap(res->start, resource_size(res));
+	if (hw->regs == NULL) {
+		dev_err(&pdev->dev, "Cannot map IO\n");
+		err = -ENXIO;
+		goto err_iomap;
+	}
+
+	hw->irq = platform_get_irq(pdev, 0);
+	if (hw->irq < 0) {
+		dev_err(&pdev->dev, "No IRQ specified\n");
+		err = -ENOENT;
+		goto err_irq;
+	}
+
+	err = request_irq(hw->irq, w90p910_spi_irq, 0, pdev->name, hw);
+	if (err) {
+		dev_err(&pdev->dev, "Cannot claim IRQ\n");
+		goto err_irq;
+	}
+
+	hw->clk = clk_get(&pdev->dev, "spi");
+	if (IS_ERR(hw->clk)) {
+		dev_err(&pdev->dev, "No clock for device\n");
+		err = PTR_ERR(hw->clk);
+		goto err_clk;
+	}
+
+	mfp_set_groupg(&pdev->dev);
+	w90p910_init_spi(hw);
+
+	err = spi_bitbang_start(&hw->bitbang);
+	if (err) {
+		dev_err(&pdev->dev, "Failed to register SPI master\n");
+		goto err_register;
+	}
+
+	return 0;
+
+err_register:
+	clk_disable(hw->clk);
+	clk_put(hw->clk);
+err_clk:
+	free_irq(hw->irq, hw);
+err_irq:
+	iounmap(hw->regs);
+err_iomap:
+	release_resource(hw->ioarea);
+	kfree(hw->ioarea);
+err_pdata:
+	spi_master_put(hw->master);;
+
+err_nomem:
+	return err;
+}
+
+static int __devexit w90p910_spi_remove(struct platform_device *dev)
+{
+	struct w90p910_spi *hw = platform_get_drvdata(dev);
+
+	platform_set_drvdata(dev, NULL);
+
+	spi_unregister_master(hw->master);
+
+	clk_disable(hw->clk);
+	clk_put(hw->clk);
+
+	free_irq(hw->irq, hw);
+	iounmap(hw->regs);
+
+	release_resource(hw->ioarea);
+	kfree(hw->ioarea);
+
+	spi_master_put(hw->master);
+	return 0;
+}
+
+static struct platform_driver w90p910_spi_driver = {
+	.probe		= w90p910_spi_probe,
+	.remove		= __devexit_p(w90p910_spi_remove),
+	.driver		= {
+		.name	= "w90p910-spi",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init w90p910_spi_init(void)
+{
+	return platform_driver_register(&w90p910_spi_driver);
+}
+
+static void __exit w90p910_spi_exit(void)
+{
+	platform_driver_unregister(&w90p910_spi_driver);
+}
+
+module_init(w90p910_spi_init);
+module_exit(w90p910_spi_exit);
+
+MODULE_AUTHOR("Wan ZongShun <mcuos.com@gmail.com>");
+MODULE_DESCRIPTION("w90p910 spi driver!");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:w90p910-spi");
-- 
1.5.6.3
