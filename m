Return-Path: <linux-kernel-owner+w=401wt.eu-S1760164AbZD1LBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760164AbZD1LBh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 07:01:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755637AbZD1LB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 07:01:26 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:65143 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754369AbZD1LBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 07:01:25 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: David Brownell <david-b@pacbell.net>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH v2] spi: Add support for the OpenCores SPI controller.
Date: Tue, 28 Apr 2009 13:01:04 +0200
Message-Id: <1240916464-4187-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <200904041227.54687.david-b@pacbell.net>
References: <200904041227.54687.david-b@pacbell.net>
X-Provags-ID: V01U2FsdGVkX19d1ivdJB1LnF8iTV4RNFszVDFHBxuqgc6rI8a
 whOoK3Zk8fMZUHLFSrJHz7TwK449b2FVrXl8vOcVg5e++ScCR/
 yJjAX84tDWzsRTYM1O6EA==
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
 drivers/spi/Kconfig  |    5 +
 drivers/spi/Makefile |    1 +
 drivers/spi/spioc.c  |  633 ++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 639 insertions(+), 0 deletions(-)

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
index 0000000..231d43c
--- /dev/null
+++ b/drivers/spi/spioc.c
@@ -0,0 +1,633 @@
+/*
+ * linux/drivers/spi/spioc.c
+ *
+ * Copyright (C) 2007-2008 Avionic Design Development GmbH
+ * Copyright (C) 2008-2009 Avionic Design GmbH
+ *
+ * Partially inspired by code from linux/drivers/spi/pxa2xx_spi.c.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Written by Thierry Reding <thierry.reding@avionic-design.de>
+ */
+
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/platform_device.h>
+#include <linux/spi/spi.h>
+
+/* register definitions */
+#define	SPIOC_RX(i)	(i * 4)
+#define	SPIOC_TX(i)	(i * 4)
+#define	SPIOC_CTRL	0x10
+#define	SPIOC_DIV	0x14
+#define	SPIOC_SS	0x18
+
+/* SPIOC_CTRL register */
+#define	CTRL_LEN(x)	((x < 128) ? x : 0)
+#define	CTRL_BUSY	(1 <<  8)
+#define	CTRL_RXNEG	(1 <<  9)
+#define	CTRL_TXNEG	(1 << 10)
+#define	CTRL_LSB	(1 << 11)
+#define	CTRL_IE		(1 << 12)
+#define	CTRL_ASS	(1 << 13)
+
+#define	SPIOC_MAX_LEN	((unsigned int)16)
+
+static const u32 clock_mode[4] = {
+	[SPI_MODE_0] = CTRL_TXNEG,
+	[SPI_MODE_1] = CTRL_RXNEG,
+	[SPI_MODE_2] = CTRL_TXNEG,
+	[SPI_MODE_3] = CTRL_RXNEG,
+};
+
+/* valid SPI mode bits */
+#define	MODEBITS	(SPI_CPHA | SPI_CPOL | SPI_LSB_FIRST)
+
+struct spioc_ctldata {
+	u32 ctrl;
+	u32 div;
+};
+
+struct spioc {
+	struct spi_master *master;
+	void __iomem *base;
+	struct clk *clk;
+	int irq;
+
+	struct workqueue_struct *workqueue;
+	struct work_struct work;
+	struct tasklet_struct tasklet;
+
+	struct list_head queue;
+	struct completion msg_done;
+	unsigned int state;
+	unsigned int busy;
+	spinlock_t lock;
+
+	struct spi_device *slave;
+	struct spi_message *message;
+	struct spi_transfer *transfer;
+	unsigned int cur_pos;
+	unsigned int cur_len;
+};
+
+/* queue states */
+#define	QUEUE_STOPPED	0
+#define	QUEUE_RUNNING	1
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
+static u32 spioc_get_clkdiv(struct spioc *spioc, unsigned long speed)
+{
+	unsigned long rate = clk_get_rate(spioc->clk);
+	return DIV_ROUND_UP(rate, 2 * speed) - 1;
+}
+
+static void spioc_chipselect(struct spioc *spioc, struct spi_device *spi)
+{
+	if (spi != spioc->slave) {
+		u32 ss = spi ? (1 << spi->chip_select) : 0;
+		spioc_write(spioc, SPIOC_SS, ss);
+		spioc->slave = spi;
+	}
+}
+
+static void spioc_copy_tx(struct spioc *spioc)
+{
+	const void *src;
+	u32 val = 0;
+	int i;
+
+	if (!spioc->transfer->tx_buf)
+		return;
+
+	src = spioc->transfer->tx_buf + spioc->cur_pos;
+
+	for (i = 0; i < spioc->cur_len; i++) {
+		int rem = spioc->cur_len - i;
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
+static void spioc_copy_rx(struct spioc *spioc)
+{
+	void *dest;
+	u32 val = 0;
+	int i;
+
+	if (!spioc->transfer->rx_buf)
+		return;
+
+	dest = spioc->transfer->rx_buf + spioc->cur_pos;
+
+	for (i = 0; i < spioc->cur_len; i++) {
+		int rem = spioc->cur_len - i;
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
+static inline struct spi_transfer *next_transfer(struct list_head *head)
+{
+	return list_entry(head->next, struct spi_transfer, transfer_list);
+}
+
+static void finish_message(struct spioc *spioc, int ec)
+{
+	struct spi_message *message = spioc->message;
+
+	spioc->transfer = NULL;
+	spioc->message = NULL;
+
+	message->status = ec;
+
+	if (message->complete)
+		message->complete(message->context);
+}
+
+static void queue_message(struct spioc *spioc)
+{
+	if (spioc->state == QUEUE_RUNNING)
+		queue_work(spioc->workqueue, &spioc->work);
+
+	if (spioc->state == QUEUE_STOPPED)
+		complete(&spioc->msg_done);
+}
+
+static struct spi_transfer *continue_message(struct spioc *spioc)
+{
+	struct spi_transfer *transfer = spioc->transfer;
+	struct spi_message *message = spioc->message;
+	unsigned long flags;
+
+	if (!transfer)
+		return next_transfer(&message->transfers);
+
+	if (transfer->transfer_list.next != &message->transfers)
+		return next_transfer(&transfer->transfer_list);
+
+	spin_lock_irqsave(&spioc->lock, flags);
+	finish_message(spioc, 0);
+	queue_message(spioc);
+	spin_unlock_irqrestore(&spioc->lock, flags);
+
+	return NULL;
+}
+
+static void process_transfers(unsigned long data)
+{
+	struct spioc *spioc = (struct spioc *)data;
+	struct spi_transfer *transfer;
+	struct spi_message *message;
+	struct spioc_ctldata *ctl;
+	u32 ctrl = 0;
+	u32 div = 0;
+
+	WARN_ON(spioc->message == NULL);
+	message = spioc->message;
+	transfer = spioc->transfer;
+
+	/* finish up the last partial transfer */
+	if (transfer) {
+		spioc_copy_rx(spioc);
+		spioc->message->actual_length += spioc->cur_len;
+		spioc->cur_pos += spioc->cur_len;
+	}
+
+	/* proceed to next (or first) transfer in message */
+	if (!transfer || (spioc->cur_pos >= transfer->len)) {
+		if (transfer) {
+			if (transfer->delay_usecs)
+				udelay(transfer->delay_usecs);
+
+			if (!transfer->cs_change)
+				spioc_chipselect(spioc, NULL);
+		}
+
+		transfer = continue_message(spioc);
+		if (!transfer)
+			return;
+
+		spioc->transfer = transfer;
+		spioc->cur_pos = 0;
+		spioc->cur_len = 0;
+	}
+
+	ctl = spi_get_ctldata(message->spi);
+	div = ctl->div;
+
+	if (transfer->speed_hz) {
+		div = spioc_get_clkdiv(spioc, transfer->speed_hz);
+		if (div > 0xffff) {
+			finish_message(spioc, -EIO);
+			return;
+		}
+	}
+
+	spioc->cur_len = min(transfer->len - spioc->cur_pos, SPIOC_MAX_LEN);
+	spioc_copy_tx(spioc);
+
+	ctrl = ctl->ctrl;
+	ctrl |= CTRL_LEN(spioc->cur_len * 8);
+	ctrl |= CTRL_BUSY;
+	ctrl |= CTRL_IE;
+
+	spioc_chipselect(spioc, spioc->message->spi);
+	spioc_write(spioc, SPIOC_DIV, div);
+	spioc_write(spioc, SPIOC_CTRL, ctrl);
+}
+
+static void process_messages(struct work_struct *work)
+{
+	struct spioc *spioc = container_of(work, struct spioc, work);
+	struct spi_message *message;
+	unsigned long flags;
+
+	WARN_ON(spioc->message != NULL);
+
+	spin_lock_irqsave(&spioc->lock, flags);
+
+	if (list_empty(&spioc->queue)) {
+		spioc->busy = 0;
+		spin_unlock_irqrestore(&spioc->lock, flags);
+		return;
+	}
+
+	message = list_entry(spioc->queue.next, struct spi_message, queue);
+	list_del_init(&message->queue);
+	spioc->message = message;
+	tasklet_schedule(&spioc->tasklet);
+	spioc->busy = 1;
+
+	spin_unlock_irqrestore(&spioc->lock, flags);
+}
+
+static int spioc_setup(struct spi_device *spi)
+{
+	struct spioc *spioc = spi_master_get_devdata(spi->master);
+	struct spioc_ctldata *ctl = spi_get_ctldata(spi);
+	u32 div = 0;
+
+	if (spi->mode & ~MODEBITS)
+		return -EINVAL;
+
+	if (!spi->max_speed_hz)
+		return -EINVAL;
+
+	div = spioc_get_clkdiv(spioc, spi->max_speed_hz);
+	if (div > 0xffff)
+		return -EINVAL;
+
+	if (!ctl) {
+		ctl = kzalloc(sizeof(*ctl), GFP_KERNEL);
+		if (!ctl)
+			return -EINVAL;
+
+		spi_set_ctldata(spi, ctl);
+	}
+
+	ctl->div = div;
+	ctl->ctrl = 0;
+
+	if (spi->mode & SPI_LSB_FIRST)
+		ctl->ctrl |= CTRL_LSB;
+
+	ctl->ctrl |= clock_mode[spi->mode & 0x3];
+
+	return 0;
+}
+
+static int spioc_transfer(struct spi_device *spi, struct spi_message *message)
+{
+	struct spioc *spioc = spi_master_get_devdata(spi->master);
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&spioc->lock, flags);
+
+	if (spioc->state == QUEUE_STOPPED) {
+		spin_unlock_irqrestore(&spioc->lock, flags);
+		return -ESHUTDOWN;
+	}
+
+	message->status = -EINPROGRESS;
+	message->actual_length = 0;
+
+	list_add_tail(&message->queue, &spioc->queue);
+
+	if ((spioc->state == QUEUE_RUNNING) && !spioc->busy)
+		queue_work(spioc->workqueue, &spioc->work);
+
+	spin_unlock_irqrestore(&spioc->lock, flags);
+
+	return 0;
+}
+
+static void spioc_cleanup(struct spi_device *spi)
+{
+	struct spioc_ctldata *ctl = spi_get_ctldata(spi);
+	spi_set_ctldata(spi, NULL);
+	kfree(ctl);
+}
+
+static irqreturn_t spioc_interrupt(int irq, void *dev_id)
+{
+	struct spi_master *master = dev_id;
+	struct spioc *spioc;
+
+	if (!dev_id)
+		return IRQ_NONE;
+
+	spioc = spi_master_get_devdata(master);
+	tasklet_schedule(&spioc->tasklet);
+
+	return IRQ_HANDLED;
+}
+
+static int init_queue(struct spi_master *master)
+{
+	struct spioc *spioc = spi_master_get_devdata(master);
+
+	spioc->workqueue = create_workqueue(dev_name(&master->dev));
+	if (!spioc->workqueue)
+		return -ENOMEM;
+
+	INIT_WORK(&spioc->work, process_messages);
+	tasklet_init(&spioc->tasklet, process_transfers,
+			(unsigned long)spioc);
+
+	INIT_LIST_HEAD(&spioc->queue);
+	init_completion(&spioc->msg_done);
+	spin_lock_init(&spioc->lock);
+
+	spioc->state = QUEUE_STOPPED;
+	spioc->busy = 0;
+
+	return 0;
+}
+
+static int start_queue(struct spi_master *master)
+{
+	struct spioc *spioc = spi_master_get_devdata(master);
+	unsigned long flags;
+
+	spin_lock_irqsave(&spioc->lock, flags);
+
+	if ((spioc->state == QUEUE_RUNNING) || spioc->busy) {
+		spin_unlock_irqrestore(&spioc->lock, flags);
+		return -EBUSY;
+	}
+
+	spioc->state = QUEUE_RUNNING;
+	spioc->message = NULL;
+	spioc->transfer = NULL;
+
+	spin_unlock_irqrestore(&spioc->lock, flags);
+
+	queue_work(spioc->workqueue, &spioc->work);
+	return 0;
+}
+
+static int stop_queue(struct spi_master *master)
+{
+	struct spioc *spioc = spi_master_get_devdata(master);
+	unsigned long flags;
+	unsigned int empty;
+	unsigned int busy;
+
+	spin_lock_irqsave(&spioc->lock, flags);
+
+	empty = list_empty(&spioc->queue);
+	spioc->state = QUEUE_STOPPED;
+	busy = spioc->busy;
+
+	spin_unlock_irqrestore(&spioc->lock, flags);
+
+	if (!empty && busy)
+		wait_for_completion(&spioc->msg_done);
+
+	return 0;
+}
+
+static int destroy_queue(struct spi_master *master)
+{
+	struct spioc *spioc = spi_master_get_devdata(master);
+	int ret;
+
+	ret = stop_queue(master);
+	if (ret < 0)
+		return ret;
+
+	destroy_workqueue(spioc->workqueue);
+
+	return 0;
+}
+
+static int __devinit spioc_probe(struct platform_device *pdev)
+{
+	struct resource *res = NULL;
+	int irq = 0;
+	void __iomem *mmio = NULL;
+	struct spi_master *master = NULL;
+	struct spioc *spioc = NULL;
+	int ret = 0;
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
+	res = devm_request_mem_region(&pdev->dev, res->start,
+			resource_size(res), res->name);
+	if (!res) {
+		dev_err(&pdev->dev, "failed to request memory region\n");
+		return -ENXIO;
+	}
+
+	mmio = devm_ioremap_nocache(&pdev->dev, res->start,
+			resource_size(res));
+	if (!mmio) {
+		dev_err(&pdev->dev, "failed to remap I/O region\n");
+		ret = -ENXIO;
+		goto free;
+	}
+
+	master = spi_alloc_master(&pdev->dev, sizeof(struct spioc));
+	if (!master) {
+		dev_err(&pdev->dev, "failed to allocate SPI master\n");
+		ret = -ENOMEM;
+		goto free;
+	}
+
+	master->setup = spioc_setup;
+	master->transfer = spioc_transfer;
+	master->cleanup = spioc_cleanup;
+
+	spioc = spi_master_get_devdata(master);
+	if (!spioc) {
+		ret = -ENXIO;
+		goto free;
+	}
+
+	spioc->master = master;
+	spioc->base = mmio;
+	spioc->irq = irq;
+	spioc->slave = NULL;
+
+	ret = init_queue(master);
+	if (ret < 0) {
+		dev_err(&master->dev, "failed to initialize message queue\n");
+		goto free;
+	}
+
+	ret = start_queue(master);
+	if (ret < 0) {
+		dev_err(&master->dev, "failed to start message queue\n");
+		goto free;
+	}
+
+	spioc->clk = clk_get(NULL, "spi-master-clk");
+	if (IS_ERR(spioc->clk)) {
+		dev_err(&master->dev, "SPI master clock undefined\n");
+		ret = PTR_ERR(spioc->clk);
+		spioc->clk = NULL;
+		goto free;
+	}
+
+	ret = devm_request_irq(&pdev->dev, irq, spioc_interrupt, IRQF_SHARED,
+			"spioc", master);
+	if (ret) {
+		dev_err(&master->dev, "failed to install handler for "
+				"IRQ%d\n", irq);
+		goto put_clock;
+	}
+
+	/* set SPI bus number and number of chipselects */
+	master->bus_num = pdev->id;
+	master->num_chipselect = 8;
+
+	ret = spi_register_master(master);
+	if (ret) {
+		dev_err(&master->dev, "failed to register SPI master\n");
+		goto put_clock;
+	}
+
+	platform_set_drvdata(pdev, master);
+	return ret;
+
+put_clock:
+	clk_put(spioc->clk);
+free:
+	spi_master_put(master);
+	return ret;
+}
+
+static int __devexit spioc_remove(struct platform_device *pdev)
+{
+	struct spi_master *master = platform_get_drvdata(pdev);
+	struct spioc *spioc = spi_master_get_devdata(master);
+
+	spi_master_get(master);
+	platform_set_drvdata(pdev, NULL);
+	spi_unregister_master(master);
+	destroy_queue(master);
+	clk_put(spioc->clk);
+	spi_master_put(master);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int spioc_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	struct spi_master *master;
+	int ret = 0;
+
+	master = platform_get_drvdata(pdev);
+
+	ret = stop_queue(master);
+	if (ret < 0)
+		dev_err(&master->dev, "failed to stop queue\n");
+
+	return ret;
+}
+
+static int spioc_resume(struct platform_device *pdev)
+{
+	struct spi_master *master;
+	int ret = 0;
+
+	master = platform_get_drvdata(pdev);
+
+	ret = start_queue(master);
+	if (ret < 0)
+		dev_err(&master->dev, "failed to start queue\n");
+
+	return ret;
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
-- 
tg: (f2deb5b..) adx/spi/spioc (depends on: adx/master)
