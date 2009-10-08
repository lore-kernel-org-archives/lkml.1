Return-Path: <linux-kernel-owner+w=401wt.eu-S1753733AbZJHGDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733AbZJHGDs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 02:03:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751721AbZJHGDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 02:03:47 -0400
Received: from msr24.hinet.net ([168.95.4.124]:49668 "EHLO msr24.hinet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459AbZJHGDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 02:03:46 -0400
From: Thomas Chou <thomas@wytron.com.tw>
To: spi-devel-general@lists.sourceforge.net
Cc: Nios2 development list <nios2-dev@sopc.et.ntust.edu.tw>,
       linux-kernel@vger.kernel.org, Thomas Chou <thomas@wytron.com.tw>
Subject: [PATCH] spi: New driver for Altera SPI
Date: Thu,  8 Oct 2009 14:03:58 +0800
Message-Id: <1254981838-20584-1-git-send-email-thomas@wytron.com.tw>
X-Mailer: git-send-email 1.6.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new SPI driver to support the Altera SOPC Builder
SPI component. It uses the bitbanging library.

Signed-off-by: Thomas Chou <thomas@wytron.com.tw>
---
 drivers/spi/Kconfig      |    7 +
 drivers/spi/Makefile     |    1 +
 drivers/spi/spi_altera.c |  397 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 405 insertions(+), 0 deletions(-)
 create mode 100644 drivers/spi/spi_altera.c

diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index 4b6f7cb..64f1148 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -53,6 +53,13 @@ if SPI_MASTER
 
 comment "SPI Master Controller Drivers"
 
+config SPI_ALTERA
+	tristate "Altera SPI Controller"
+	depends on EMBEDDED
+	select SPI_BITBANG
+	help
+	  This is the driver for the Altera SPI Controller.
+
 config SPI_ATMEL
 	tristate "Atmel SPI Controller"
 	depends on (ARCH_AT91 || AVR32)
diff --git a/drivers/spi/Makefile b/drivers/spi/Makefile
index 21a1182..f5f43f1 100644
--- a/drivers/spi/Makefile
+++ b/drivers/spi/Makefile
@@ -11,6 +11,7 @@ endif
 obj-$(CONFIG_SPI_MASTER)		+= spi.o
 
 # SPI master controller drivers (bus)
+obj-$(CONFIG_SPI_ALTERA)		+= spi_altera.o
 obj-$(CONFIG_SPI_ATMEL)			+= atmel_spi.o
 obj-$(CONFIG_SPI_BFIN)			+= spi_bfin5xx.o
 obj-$(CONFIG_SPI_BITBANG)		+= spi_bitbang.o
diff --git a/drivers/spi/spi_altera.c b/drivers/spi/spi_altera.c
new file mode 100644
index 0000000..337dc95
--- /dev/null
+++ b/drivers/spi/spi_altera.c
@@ -0,0 +1,397 @@
+/*
+ * Altera SPI driver
+ *
+ * Copyright (C) 2008 Thomas Chou <thomas@wytron.com.tw>
+ *
+ * Based on spi_s3c24xx.c, which is:
+ * Copyright (c) 2006 Ben Dooks
+ * Copyright (c) 2006 Simtec Electronics
+ *	Ben Dooks <ben@simtec.co.uk>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/init.h>
+#include <linux/spinlock.h>
+#include <linux/workqueue.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/clk.h>
+#include <linux/platform_device.h>
+#include <linux/spi/spi.h>
+#include <linux/spi/spi_bitbang.h>
+#include <linux/io.h>
+
+#define DRV_NAME "spi_altera"
+
+#define ALTERA_SPI_RXDATA	0
+#define ALTERA_SPI_TXDATA	4
+#define ALTERA_SPI_STATUS	8
+#define ALTERA_SPI_CONTROL	12
+#define ALTERA_SPI_SLAVE_SEL	20
+
+#define ALTERA_SPI_STATUS_ROE_MSK	(0x8)
+#define ALTERA_SPI_STATUS_TOE_MSK	(0x10)
+#define ALTERA_SPI_STATUS_TMT_MSK	(0x20)
+#define ALTERA_SPI_STATUS_TRDY_MSK	(0x40)
+#define ALTERA_SPI_STATUS_RRDY_MSK	(0x80)
+#define ALTERA_SPI_STATUS_E_MSK		(0x100)
+
+#define ALTERA_SPI_CONTROL_IROE_MSK	(0x8)
+#define ALTERA_SPI_CONTROL_ITOE_MSK	(0x10)
+#define ALTERA_SPI_CONTROL_ITRDY_MSK	(0x40)
+#define ALTERA_SPI_CONTROL_IRRDY_MSK	(0x80)
+#define ALTERA_SPI_CONTROL_IE_MSK	(0x100)
+#define ALTERA_SPI_CONTROL_SSO_MSK	(0x400)
+
+struct altera_spi {
+	/* bitbang has to be first */
+	struct spi_bitbang bitbang;
+	struct completion done;
+
+	unsigned long base;
+	int irq;
+	int len;
+	int count;
+	int bytes_per_word;
+	unsigned long imr;
+
+	/* data buffers */
+	const unsigned char *tx;
+	unsigned char *rx;
+
+	struct resource *ioarea;
+	struct spi_master *master;
+	struct spi_device *curdev;
+	struct device *dev;
+};
+
+static inline struct altera_spi *to_hw(struct spi_device *sdev)
+{
+	return spi_master_get_devdata(sdev->master);
+}
+
+static void altera_spi_chipsel(struct spi_device *spi, int value)
+{
+	struct altera_spi *hw = to_hw(spi);
+
+	if (spi->mode & SPI_CS_HIGH) {
+		switch (value) {
+		case BITBANG_CS_INACTIVE:
+			writel(1 << spi->chip_select,
+			       hw->base + ALTERA_SPI_SLAVE_SEL);
+			hw->imr |= ALTERA_SPI_CONTROL_SSO_MSK;
+			writel(hw->imr, hw->base + ALTERA_SPI_CONTROL);
+			break;
+
+		case BITBANG_CS_ACTIVE:
+			hw->imr &= ~ALTERA_SPI_CONTROL_SSO_MSK;
+			writel(hw->imr, hw->base + ALTERA_SPI_CONTROL);
+			writel(0, hw->base + ALTERA_SPI_SLAVE_SEL);
+			break;
+		}
+	} else {
+		switch (value) {
+		case BITBANG_CS_INACTIVE:
+			hw->imr &= ~ALTERA_SPI_CONTROL_SSO_MSK;
+			writel(hw->imr, hw->base + ALTERA_SPI_CONTROL);
+			break;
+
+		case BITBANG_CS_ACTIVE:
+			writel(1 << spi->chip_select,
+			       hw->base + ALTERA_SPI_SLAVE_SEL);
+			hw->imr |= ALTERA_SPI_CONTROL_SSO_MSK;
+			writel(hw->imr, hw->base + ALTERA_SPI_CONTROL);
+			break;
+		}
+	}
+}
+
+static int altera_spi_setupxfer(struct spi_device *spi, struct spi_transfer *t)
+{
+	struct altera_spi *hw = to_hw(spi);
+
+	spin_lock(&hw->bitbang.lock);
+	if (!hw->bitbang.busy) {
+		hw->bitbang.chipselect(spi, BITBANG_CS_INACTIVE);
+		/* need to ndelay for 0.5 clocktick ? */
+	}
+	spin_unlock(&hw->bitbang.lock);
+
+	return 0;
+}
+
+/* the spi->mode bits understood by this driver: */
+#define MODEBITS (SPI_CPOL | SPI_CPHA | SPI_CS_HIGH)
+
+static int altera_spi_setup(struct spi_device *spi)
+{
+	int ret;
+
+	if (!spi->bits_per_word)
+		spi->bits_per_word = 8;
+
+	if (spi->mode & ~MODEBITS) {
+		dev_dbg(&spi->dev, "setup: unsupported mode bits %x\n",
+			spi->mode & ~MODEBITS);
+		return -EINVAL;
+	}
+
+	ret = altera_spi_setupxfer(spi, NULL);
+	if (ret < 0) {
+		dev_err(&spi->dev, "setupxfer returned %d\n", ret);
+		return ret;
+	}
+
+	dev_dbg(&spi->dev, "%s: mode %d, %u bpw, %d hz\n",
+		__func__, spi->mode, spi->bits_per_word, spi->max_speed_hz);
+
+	return 0;
+}
+
+static inline unsigned int hw_txbyte(struct altera_spi *hw, int count)
+{
+	if (hw->tx) {
+		switch (hw->bytes_per_word) {
+		case 1:
+			return hw->tx[count];
+		case 2:
+			return (hw->tx[count * 2]
+				| (hw->tx[count * 2 + 1] << 8));
+		}
+	}
+
+	return 0;
+}
+
+static int altera_spi_txrx(struct spi_device *spi, struct spi_transfer *t)
+{
+	struct altera_spi *hw = to_hw(spi);
+
+	dev_dbg(&spi->dev, "txrx: tx %p, rx %p, len %d\n",
+		t->tx_buf, t->rx_buf, t->len);
+
+	hw->tx = t->tx_buf;
+	hw->rx = t->rx_buf;
+	hw->count = 0;
+	hw->bytes_per_word = (t->bits_per_word ? : spi->bits_per_word) / 8;
+	hw->len = t->len / hw->bytes_per_word;
+
+	init_completion(&hw->done);
+
+	/* send the first byte */
+	writel(hw_txbyte(hw, 0), hw->base + ALTERA_SPI_TXDATA);
+
+	wait_for_completion(&hw->done);
+
+	return hw->count * hw->bytes_per_word;
+}
+
+static irqreturn_t altera_spi_irq(int irq, void *dev)
+{
+	struct altera_spi *hw = dev;
+	unsigned int spsta = readl(hw->base + ALTERA_SPI_STATUS);
+	unsigned int count = hw->count;
+	unsigned int rxd;
+
+	if (spsta & ALTERA_SPI_STATUS_ROE_MSK) {
+		dev_dbg(hw->dev, "data-collision\n");
+		complete(&hw->done);
+		goto irq_done;
+	}
+
+	if (!(spsta & ALTERA_SPI_STATUS_TRDY_MSK)) {
+		dev_dbg(hw->dev, "spi not ready for tx?\n");
+		complete(&hw->done);
+		goto irq_done;
+	}
+
+	hw->count++;
+
+	rxd = readl(hw->base + ALTERA_SPI_RXDATA);
+	if (hw->rx) {
+		switch (hw->bytes_per_word) {
+		case 1:
+			hw->rx[count] = rxd;
+			break;
+		case 2:
+			hw->rx[count * 2] = rxd;
+			hw->rx[count * 2 + 1] = rxd >> 8;
+			break;
+		}
+	}
+
+	count++;
+
+	if (count < hw->len)
+		writel(hw_txbyte(hw, count), hw->base + ALTERA_SPI_TXDATA);
+	else
+		complete(&hw->done);
+
+irq_done:
+	return IRQ_HANDLED;
+}
+
+static int __init altera_spi_probe(struct platform_device *pdev)
+{
+	struct altera_spi *hw;
+	struct spi_master *master;
+	struct resource *res;
+	int err = 0;
+
+	master = spi_alloc_master(&pdev->dev, sizeof(struct altera_spi));
+	if (master == NULL) {
+		dev_err(&pdev->dev, "No memory for spi_master\n");
+		err = -ENOMEM;
+		goto err_nomem;
+	}
+
+	hw = spi_master_get_devdata(master);
+	memset(hw, 0, sizeof(struct altera_spi));
+
+	hw->master = spi_master_get(master);
+	hw->dev = &pdev->dev;
+
+	platform_set_drvdata(pdev, hw);
+	init_completion(&hw->done);
+
+	/* setup the master state. */
+
+	master->bus_num = pdev->id;
+	master->num_chipselect = 16;
+
+	/* setup the state for the bitbang driver */
+
+	hw->bitbang.master = hw->master;
+	hw->bitbang.setup_transfer = altera_spi_setupxfer;
+	hw->bitbang.chipselect = altera_spi_chipsel;
+	hw->bitbang.txrx_bufs = altera_spi_txrx;
+	hw->bitbang.master->setup = altera_spi_setup;
+
+	dev_dbg(hw->dev, "bitbang at %p\n", &hw->bitbang);
+
+	/* find and map our resources */
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (res == NULL) {
+		dev_err(&pdev->dev, "Cannot get IORESOURCE_MEM\n");
+		err = -ENOENT;
+		goto err_no_iores;
+	}
+
+	hw->ioarea = request_mem_region(res->start, (res->end - res->start) + 1,
+					pdev->name);
+
+	if (hw->ioarea == NULL) {
+		dev_err(&pdev->dev, "Cannot reserve region\n");
+		err = -ENXIO;
+		goto err_no_iores;
+	}
+
+	hw->base =
+	    (unsigned long)ioremap(res->start, (res->end - res->start) + 1);
+	if (hw->base == 0) {
+		dev_err(&pdev->dev, "Cannot map IO\n");
+		err = -ENXIO;
+		goto err_no_iomap;
+	}
+
+	hw->irq = platform_get_irq(pdev, 0);
+	if (hw->irq < 0) {
+		dev_err(&pdev->dev, "No IRQ specified\n");
+		err = -ENOENT;
+		goto err_no_irq;
+	}
+
+	/* program defaults into the registers */
+	hw->imr = 0;		/* disable spi interrupts */
+	writel(hw->imr, hw->base + ALTERA_SPI_CONTROL);
+	writel(0, hw->base + ALTERA_SPI_STATUS);	/* clear status reg */
+	if (readl(hw->base + ALTERA_SPI_STATUS) & ALTERA_SPI_STATUS_RRDY_MSK)
+		readl(hw->base + ALTERA_SPI_RXDATA);	/* flush rxdata */
+
+	err = request_irq(hw->irq, altera_spi_irq, 0, pdev->name, hw);
+	if (err) {
+		dev_err(&pdev->dev, "Cannot claim IRQ\n");
+		goto err_no_irq;
+	}
+
+	/* enable receive interrupt */
+	hw->imr |= ALTERA_SPI_CONTROL_IRRDY_MSK;
+	writel(hw->imr, hw->base + ALTERA_SPI_CONTROL);
+
+	/* register our spi controller */
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
+	free_irq(hw->irq, hw);
+err_no_irq:
+	iounmap((void *)hw->base);
+err_no_iomap:
+	release_resource(hw->ioarea);
+	kfree(hw->ioarea);
+err_no_iores:
+	spi_master_put(hw->master);;
+err_nomem:
+	return err;
+}
+
+static int __exit altera_spi_remove(struct platform_device *dev)
+{
+	struct altera_spi *hw = platform_get_drvdata(dev);
+
+	/* disable spi interrupts */
+	hw->imr = 0;
+	writel(hw->imr, hw->base + ALTERA_SPI_CONTROL);
+
+	platform_set_drvdata(dev, NULL);
+
+	spi_unregister_master(hw->master);
+
+	free_irq(hw->irq, hw);
+	iounmap((void *)hw->base);
+
+	release_resource(hw->ioarea);
+	kfree(hw->ioarea);
+
+	spi_master_put(hw->master);
+	return 0;
+}
+
+static struct platform_driver altera_spidrv = {
+	.remove = __exit_p(altera_spi_remove),
+	.driver = {
+		.name = DRV_NAME,
+		.owner = THIS_MODULE,
+		.pm = NULL,
+	},
+};
+
+static int __init altera_spi_init(void)
+{
+	return platform_driver_probe(&altera_spidrv, altera_spi_probe);
+}
+
+static void __exit altera_spi_exit(void)
+{
+	platform_driver_unregister(&altera_spidrv);
+}
+
+module_init(altera_spi_init);
+module_exit(altera_spi_exit);
+
+MODULE_DESCRIPTION("Altera SPI driver");
+MODULE_AUTHOR("Thomas Chou <thomas@wytron.com.tw>");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:" DRV_NAME);
-- 
1.6.2.5

