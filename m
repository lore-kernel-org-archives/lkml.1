Return-Path: <linux-kernel-owner+w=401wt.eu-S1755725AbZCZIIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725AbZCZIIR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 04:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753336AbZCZIH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 04:07:58 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:52793 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbZCZIHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 04:07:54 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: david-b@pacbell.net
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] spi: Add support for the OpenCores SPI controller.
Date: Thu, 26 Mar 2009 09:07:53 +0100
Message-Id: <1238054874-28215-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.6.2.1
X-Provags-ID: V01U2FsdGVkX1/H60f8u2zXq7IfNjXvTYLeWSRog+qoaWvnq/9
 nn9grkcezJe64TsAsi0vE8FJtchp+8r/gQt67eezgnQi9oiI7y
 W+8+t0WK6MujboslWGgiw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a platform device driver that supports the OpenCores SPI
controller.

The driver expects two resources: an IORESOURCE_MEM resource defining the
core's memory-mapped registers and an IORESOURCE_IRQ for the associated
interrupt. It also requires a clock, "spi-master-clk", used to compute the
clock divider.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>

---
 drivers/spi/Kconfig       |    5 +
 drivers/spi/Makefile      |    1 +
 drivers/spi/spioc.c       |  528 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/spi/spioc.h |   25 +++
 4 files changed, 559 insertions(+), 0 deletions(-)

diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index 83a185d..ff76d29 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -151,6 +151,11 @@ config SPI_MPC83xx
 	  technology. This driver uses a simple set of shift registers for data
 	  (opposed to the CPM based descriptor model).
 
+config SPI_OCORES
+	tristate "OpenCores SPI Controller"
+	help
+	  This enables using the OpenCores SPI controller.
+
 config SPI_OMAP_UWIRE
 	tristate "OMAP1 MicroWire"
 	depends on ARCH_OMAP1
diff --git a/drivers/spi/Makefile b/drivers/spi/Makefile
index 5d04519..7802d0c 100644
--- a/drivers/spi/Makefile
+++ b/drivers/spi/Makefile
@@ -30,6 +30,7 @@ obj-$(CONFIG_SPI_S3C24XX)		+= spi_s3c24xx.o
 obj-$(CONFIG_SPI_TXX9)			+= spi_txx9.o
 obj-$(CONFIG_SPI_XILINX)		+= xilinx_spi.o
 obj-$(CONFIG_SPI_SH_SCI)		+= spi_sh_sci.o
+obj-$(CONFIG_SPI_OCORES)		+= spioc.o
 # 	... add above this line ...
 
 # SPI protocol drivers (device/link on bus)
diff --git a/drivers/spi/spioc.c b/drivers/spi/spioc.c
new file mode 100644
index 0000000..2ec2c66
--- /dev/null
+++ b/drivers/spi/spioc.c
@@ -0,0 +1,528 @@
+/*
+ * linux/drivers/spi/spioc.c
+ *
+ * Copyright (C) 2007-2008 Avionic Design Development GmbH
+ * Copyright (C) 2008-2009 Avionic Design GmbH
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Written by Thierry Reding <thierry.reding@avionic-design.de>
+ */
+
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/platform_device.h>
+#include <linux/spi/spioc.h>
+
+/* register definitions */
+#define SPIOC_RX(i)	(i * 4)
+#define SPIOC_TX(i)	(i * 4)
+#define SPIOC_CTRL	0x10
+#define SPIOC_DIV	0x14
+#define SPIOC_SS	0x18
+
+/* SPIOC_CTRL register */
+#define CTRL_LEN(x)	((x < 128) ? x : 0)
+#define CTRL_BUSY	(1 <<  8)
+#define CTRL_RXNEG	(1 <<  9)
+#define CTRL_TXNEG	(1 << 10)
+#define CTRL_LSB	(1 << 11)
+#define CTRL_IE		(1 << 12)
+#define CTRL_ASS	(1 << 13)
+
+/**
+ * struct spioc - driver-specific context information
+ * @master:	SPI master device
+ * @info:	pointer to platform data
+ * @clk:	SPI master clock
+ * @irq:	SPI controller interrupt
+ * @mmio:	physical I/O memory resource
+ * @base:	base of memory-mapped I/O
+ * @message:	current SPI message
+ * @transfer:	current transfer of current SPI message
+ * @nx:		number of bytes sent/received for current transfer
+ * @queue:	SPI message queue
+ */
+struct spioc {
+	struct spi_master *master;
+	struct spioc_info *info;
+	struct clk *clk;
+	int irq;
+
+	struct resource *mmio;
+	void __iomem *base;
+
+	struct spi_message *message;
+	struct spi_transfer *transfer;
+	unsigned long nx;
+
+	struct list_head queue;
+	struct workqueue_struct *workqueue;
+	struct work_struct process_messages;
+	struct tasklet_struct process_transfers;
+	struct completion complete;
+	spinlock_t lock;
+};
+
+static inline u32 spioc_read(struct spioc *spioc, unsigned long offset)
+{
+	return ioread32(spioc->base + offset);
+}
+
+static inline void spioc_write(struct spioc *spioc, unsigned offset,
+		u32 value)
+{
+	iowrite32(value, spioc->base + offset);
+}
+
+static void spioc_chipselect(struct spioc *master, struct spi_device *spi)
+{
+	if (spi)
+		spioc_write(master, SPIOC_SS, 1 << spi->chip_select);
+	else
+		spioc_write(master, SPIOC_SS, 0);
+}
+
+/* count is assumed to be less than or equal to the maximum number of bytes
+ * that can be transferred in one go */
+static void spioc_copy_tx(struct spioc *spioc, const void *src, size_t count)
+{
+	u32 val = 0;
+	int i;
+
+	for (i = 0; i < count; i++) {
+		int rem = count - i;
+		int reg = (rem - 1) / 4;
+		int ofs = (rem - 1) % 4;
+
+		val |= (((u8 *)src)[i] & 0xff) << (ofs * 8);
+		if (!ofs) {
+			spioc_write(spioc, SPIOC_TX(reg), val);
+			val = 0;
+		}
+	}
+}
+
+static void spioc_copy_rx(struct spioc *spioc, void *dest, size_t count)
+{
+	u32 val = 0;
+	int i;
+
+	for (i = 0; i < count; i++) {
+		int rem = count - i;
+		int reg = (rem - 1) / 4;
+		int ofs = (rem - 1) % 4;
+
+		if ((i == 0) || (rem % 4 == 0))
+			val = spioc_read(spioc, SPIOC_RX(reg));
+
+		((u8 *)dest)[i] = (val >> (ofs * 8)) & 0xff;
+	}
+}
+
+static void process_messages(struct work_struct *work)
+{
+	struct spioc *spioc =
+		container_of(work, struct spioc, process_messages);
+	unsigned long flags;
+
+	spin_lock_irqsave(&spioc->lock, flags);
+
+	/* obtain next message */
+	if (list_empty(&spioc->queue)) {
+		spin_unlock_irqrestore(&spioc->lock, flags);
+		return;
+	}
+
+	spioc->message = list_entry(spioc->queue.next, struct spi_message,
+			queue);
+	list_del_init(&spioc->message->queue);
+
+	/* process transfers */
+	tasklet_schedule(&spioc->process_transfers);
+	spin_unlock_irqrestore(&spioc->lock, flags);
+}
+
+static void process_transfers(unsigned long data)
+{
+	struct spioc *spioc = (struct spioc *)data;
+	struct spi_transfer *transfer = spioc->transfer;
+	size_t rem;
+	u32 ctrl;
+
+	/* if this is the start of a message, get a pointer to the first
+	 * transfer */
+	if (!transfer || (spioc->nx >= transfer->len)) {
+		if (!transfer) {
+			transfer = list_entry(spioc->message->transfers.next,
+					struct spi_transfer, transfer_list);
+			spioc_chipselect(spioc, spioc->message->spi);
+		} else {
+			struct list_head *next = transfer->transfer_list.next;
+
+			if (next != &spioc->message->transfers) {
+				transfer = list_entry(next,
+						struct spi_transfer,
+						transfer_list);
+			} else {
+				spioc->message->actual_length = spioc->nx;
+				complete(spioc->message->context);
+				spioc->transfer = NULL;
+				spioc_chipselect(spioc, NULL);
+				return;
+			}
+		}
+
+		spioc->transfer = transfer;
+		spioc->nx = 0;
+	}
+
+	/* write data to registers */
+	rem = min_t(size_t, transfer->len - spioc->nx, 16);
+	if (transfer->tx_buf)
+		spioc_copy_tx(spioc, transfer->tx_buf + spioc->nx, rem);
+
+	/* read control register */
+	ctrl  = spioc_read(spioc, SPIOC_CTRL);
+	ctrl &= ~CTRL_LEN(127);    /* clear length bits */
+	ctrl |= CTRL_IE            /* assert interrupt on completion */
+	     |  CTRL_LEN(rem * 8); /* set word length */
+	spioc_write(spioc, SPIOC_CTRL, ctrl);
+
+	/* start transfer */
+	ctrl |= CTRL_BUSY;
+	spioc_write(spioc, SPIOC_CTRL, ctrl);
+}
+
+static int spioc_setup(struct spi_device *spi)
+{
+	struct spioc *spioc = spi_master_get_devdata(spi->master);
+	unsigned long clkdiv = 0x0000ffff;
+	u32 ctrl = spioc_read(spioc, SPIOC_CTRL);
+
+	/* make sure we're not busy */
+	ctrl &= ~CTRL_BUSY;
+
+	if (!spi->bits_per_word)
+		spi->bits_per_word = 8;
+
+	if (spi->mode & SPI_LSB_FIRST)
+		ctrl |=  CTRL_LSB;
+	else
+		ctrl &= ~CTRL_LSB;
+
+	/* adapt to clock polarity and phase */
+	if (spi->mode & SPI_CPOL) {
+		if (spi->mode & SPI_CPHA) {
+			ctrl |=  CTRL_TXNEG;
+			ctrl &= ~CTRL_RXNEG;
+		} else {
+			ctrl &= ~CTRL_TXNEG;
+			ctrl |=  CTRL_RXNEG;
+		}
+	} else {
+		if (spi->mode & SPI_CPHA) {
+			ctrl &= ~CTRL_TXNEG;
+			ctrl |=  CTRL_RXNEG;
+		} else {
+			ctrl |=  CTRL_TXNEG;
+			ctrl &= ~CTRL_RXNEG;
+		}
+	}
+
+	/* set the clock divider */
+	if (spi->max_speed_hz)
+		clkdiv = DIV_ROUND_UP(clk_get_rate(spioc->clk),
+				2 * spi->max_speed_hz) - 1;
+
+	if (clkdiv > 0x0000ffff)
+		clkdiv = 0x0000ffff;
+
+	spioc_write(spioc, SPIOC_DIV, clkdiv);
+	spioc_write(spioc, SPIOC_CTRL, ctrl);
+
+	/* deassert chip-select */
+	spioc_chipselect(spioc, NULL);
+
+	return 0;
+}
+
+static int spioc_transfer(struct spi_device *spi, struct spi_message *message)
+{
+	struct spi_master *master = spi->master;
+	struct spioc *spioc = spi_master_get_devdata(master);
+	unsigned long flags;
+
+	spin_lock_irqsave(&spioc->lock, flags);
+
+	list_add_tail(&message->queue, &spioc->queue);
+	queue_work(spioc->workqueue, &spioc->process_messages);
+
+	spin_unlock_irqrestore(&spioc->lock, flags);
+	return 0;
+}
+
+static void spioc_cleanup(struct spi_device *spi)
+{
+}
+
+static irqreturn_t spioc_interrupt(int irq, void *dev_id)
+{
+	struct spi_master *master = (struct spi_master *)dev_id;
+	struct spioc *spioc = spi_master_get_devdata(master);
+	struct spi_transfer *transfer = spioc->transfer;
+	size_t rem;
+
+	if (!transfer)
+		return IRQ_NONE;
+
+	/* read data from registers */
+	rem = min_t(size_t, transfer->len - spioc->nx, 16);
+	if (transfer->rx_buf)
+		spioc_copy_rx(spioc, transfer->rx_buf + spioc->nx, rem);
+	spioc->nx += rem;
+
+	tasklet_schedule(&spioc->process_transfers);
+	return IRQ_HANDLED;
+}
+
+static int init_queue(struct spi_master *master)
+{
+	struct spioc *spioc = spi_master_get_devdata(master);
+
+	INIT_LIST_HEAD(&spioc->queue);
+
+	/* initialize transfer processing tasklet */
+	tasklet_init(&spioc->process_transfers, process_transfers,
+			(unsigned long)spioc);
+
+	/* initialize message workqueue */
+	INIT_WORK(&spioc->process_messages, process_messages);
+	spioc->workqueue = create_singlethread_workqueue(
+			master->dev.bus_id);
+	if (!spioc->workqueue)
+		return -EBUSY;
+
+	return 0;
+}
+
+static int start_queue(struct spi_master *master)
+{
+	struct spioc *spioc = spi_master_get_devdata(master);
+
+	WARN_ON(spioc->message  != NULL);
+	WARN_ON(spioc->transfer != NULL);
+
+	spioc->message  = NULL;
+	spioc->transfer = NULL;
+
+	queue_work(spioc->workqueue, &spioc->process_messages);
+	return 0;
+}
+
+static int stop_queue(struct spi_master *master)
+{
+	return 0;
+}
+
+static int destroy_queue(struct spi_master *master)
+{
+	struct spioc *spioc = spi_master_get_devdata(master);
+	int retval = 0;
+
+	retval = stop_queue(master);
+	if (retval)
+		return retval;
+
+	destroy_workqueue(spioc->workqueue);
+	return 0;
+}
+
+static int __devinit spioc_probe(struct platform_device *pdev)
+{
+	struct resource *res = NULL;
+	void __iomem *mmio = NULL;
+	int retval = 0, irq;
+	struct spi_master *master = NULL;
+	struct spioc *spioc = NULL;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(&pdev->dev, "MMIO resource not defined\n");
+		return -ENXIO;
+	}
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
+		dev_err(&pdev->dev, "IRQ not defined\n");
+		return -ENXIO;
+	}
+
+	res = request_mem_region(res->start, res->end - res->start + 1,
+			res->name);
+	if (!res) {
+		dev_err(&pdev->dev, "unable to request memory region\n");
+		return -ENXIO;
+	}
+
+	mmio = ioremap_nocache(res->start, res->end - res->start + 1);
+	if (!mmio) {
+		dev_err(&pdev->dev, "can't remap I/O region\n");
+		retval = -ENXIO;
+		goto release;
+	}
+
+	master = spi_alloc_master(&pdev->dev, sizeof(struct spioc));
+	if (!master) {
+		dev_err(&pdev->dev, "unable to allocate SPI master\n");
+		retval = -ENOMEM;
+		goto unmap;
+	}
+
+	master->setup = spioc_setup;
+	master->transfer = spioc_transfer;
+	master->cleanup = spioc_cleanup;
+
+	spioc = spi_master_get_devdata(master);
+	if (!spioc) {
+		dev_err(&master->dev, "no controller data\n");
+		retval = -ENOMEM;
+		goto free;
+	}
+
+	spioc->master = master;
+	spioc->info = pdev->dev.platform_data;
+	spioc->irq = irq;
+	spioc->mmio = res;
+	spioc->base = mmio;
+	spioc->message = NULL;
+	spioc->transfer = NULL;
+	spin_lock_init(&spioc->lock);
+
+	spioc->clk = clk_get(NULL, "spi-master-clk");
+	if (IS_ERR(spioc->clk)) {
+		dev_err(&master->dev, "unable to get SPI master clock\n");
+		retval = PTR_ERR(spioc->clk);
+		spioc->clk = NULL;
+		goto free;
+	}
+
+	retval = init_queue(master);
+	if (retval) {
+		dev_err(&master->dev, "unable to initialize workqueue\n");
+		goto free;
+	}
+
+	retval = start_queue(master);
+	if (retval) {
+		dev_err(&master->dev, "unable to start workqueue\n");
+		goto free;
+	}
+
+	init_completion(&spioc->complete);
+
+	retval = request_irq(irq, spioc_interrupt, IRQF_SHARED, "spioc",
+			master);
+	if (retval) {
+		dev_err(&master->dev, "unable to install handler for "
+				"IRQ%d\n", irq);
+		goto free;
+	}
+
+	/* set SPI bus number and number of chipselects */
+	master->bus_num        = spioc->info->bus_num;
+	master->num_chipselect = spioc->info->num_chipselect;
+
+	retval = spi_register_master(master);
+	if (retval) {
+		dev_err(&master->dev, "unable to register SPI master\n");
+		goto free_irq;
+	}
+
+	dev_info(&master->dev, "SPI master registered\n");
+	platform_set_drvdata(pdev, master);
+
+out:
+	return retval;
+free_irq:
+	free_irq(irq, master);
+free:
+	(void)destroy_queue(master);
+	spi_master_put(master);
+
+	if (spioc && spioc->clk && !IS_ERR(spioc->clk))
+		clk_put(spioc->clk);
+unmap:
+	if (mmio)
+		iounmap(mmio);
+release:
+	if (res)
+		release_mem_region(res->start, res->end - res->start + 1);
+	goto out;
+}
+
+static int __devexit spioc_remove(struct platform_device *pdev)
+{
+	struct spi_master *master = platform_get_drvdata(pdev);
+	struct spioc *spioc = spi_master_get_devdata(master);
+	struct resource *res = spioc->mmio;
+
+	spi_master_get(master);
+	platform_set_drvdata(pdev, NULL);
+	spi_unregister_master(master);
+	destroy_queue(master);
+	free_irq(spioc->irq, master);
+	iounmap(spioc->base);
+	release_mem_region(res->start, res->end - res->start + 1);
+	clk_put(spioc->clk);
+	spi_master_put(master);
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int spioc_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	return -ENOSYS;
+}
+
+static int spioc_resume(struct platform_device *pdev)
+{
+	return -ENOSYS;
+}
+#else
+#define spioc_suspend NULL
+#define spioc_resume  NULL
+#endif /* CONFIG_PM */
+
+static struct platform_driver spioc_driver = {
+	.probe = spioc_probe,
+	.remove = __devexit_p(spioc_remove),
+	.suspend = spioc_suspend,
+	.resume = spioc_resume,
+	.driver = {
+		.name  = "spioc",
+		.owner = THIS_MODULE,
+	},
+};
+
+static int __init spioc_init(void)
+{
+	return platform_driver_register(&spioc_driver);
+}
+
+static void __exit spioc_exit(void)
+{
+	platform_driver_unregister(&spioc_driver);
+}
+
+module_init(spioc_init);
+module_exit(spioc_exit);
+
+MODULE_AUTHOR("Thierry Reding <thierry.reding@avionic-design.de>");
+MODULE_DESCRIPTION("OpenCores SPI controller driver");
+MODULE_LICENSE("GPL v2");
+
diff --git a/include/linux/spi/spioc.h b/include/linux/spi/spioc.h
new file mode 100644
index 0000000..1a4d7ad
--- /dev/null
+++ b/include/linux/spi/spioc.h
@@ -0,0 +1,25 @@
+/*
+ * linux/include/linux/spi/spioc.h
+ *
+ * Copyright (C) 2007-2008 Avionic Design Development GmbH
+ * Copyright (C) 2008-2009 Avionic Design GmbH
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Written by Thierry Reding <thierry.reding@avionic-design.de>
+ */
+
+#ifndef LINUX_SPI_SPIOC_H
+#define LINUX_SPI_SPIOC_H
+
+#include <linux/spi/spi.h>
+
+struct spioc_info {
+	s16 bus_num;
+	u16 num_chipselect;
+};
+
+#endif /* !LINUX_SPI_SPIOC_H */
+
-- 
tg: (cb7b158..) adx/spi/spioc (depends on: adx/master)
