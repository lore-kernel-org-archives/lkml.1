Return-Path: <linux-kernel-owner+w=401wt.eu-S1759284AbYEPTi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759284AbYEPTi3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 15:38:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755069AbYEPTh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 15:37:59 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:34201 "EHLO
	pd4mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607AbYEPTh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 15:37:56 -0400
Date: Fri, 16 May 2008 13:36:18 -0600
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 4/4] [CSB] Add new mpc5200-spi (non-psc) device driver
In-reply-to: <20080516193054.28030.35126.stgit@trillian.secretlab.ca>
To: linuxppc-dev@ozlabs.org, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net
Cc: fabrizio.garetto@gmail.com, jonsmirl@gmail.com
Message-id: <20080516193618.28030.15219.stgit@trillian.secretlab.ca>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
References: <20080516193054.28030.35126.stgit@trillian.secretlab.ca>
User-Agent: StGIT/0.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>

Unlike the old CSB driver, this driver uses the SPI infrastructure.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

 drivers/spi/Kconfig             |    8 +
 drivers/spi/Makefile            |    1 
 drivers/spi/mpc52xx_spi.c       |  561 +++++++++++++++++++++++++++++++++++++++
 include/linux/spi/mpc52xx_spi.h |   10 +
 4 files changed, 580 insertions(+), 0 deletions(-)

diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index 12c35da..bd07429 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -120,6 +120,14 @@ config SPI_LM70_LLP
 	  which interfaces to an LM70 temperature sensor using
 	  a parallel port.
 
+config SPI_MPC52xx
+	tristate "Freescale MPC52xx SPI (non-PSC) controller support"
+	depends on PPC_MPC52xx && SPI
+	select SPI_MASTER_OF
+	help
+	  This drivers supports the MPC52xx SPI controller in master SPI
+	  mode.
+
 config SPI_MPC52xx_PSC
 	tristate "Freescale MPC52xx PSC SPI controller"
 	depends on SPI_MASTER && PPC_MPC52xx && EXPERIMENTAL
diff --git a/drivers/spi/Makefile b/drivers/spi/Makefile
index 29c592f..805bef1 100644
--- a/drivers/spi/Makefile
+++ b/drivers/spi/Makefile
@@ -23,6 +23,7 @@ obj-$(CONFIG_SPI_PXA2XX)		+= pxa2xx_spi.o
 obj-$(CONFIG_SPI_OMAP_UWIRE)		+= omap_uwire.o
 obj-$(CONFIG_SPI_OMAP24XX)		+= omap2_mcspi.o
 obj-$(CONFIG_SPI_MPC52xx_PSC)		+= mpc52xx_psc_spi.o
+obj-$(CONFIG_SPI_MPC52xx)		+= mpc52xx_spi.o
 obj-$(CONFIG_SPI_MPC83xx)		+= spi_mpc83xx.o
 obj-$(CONFIG_SPI_S3C24XX_GPIO)		+= spi_s3c24xx_gpio.o
 obj-$(CONFIG_SPI_S3C24XX)		+= spi_s3c24xx.o
diff --git a/drivers/spi/mpc52xx_spi.c b/drivers/spi/mpc52xx_spi.c
new file mode 100644
index 0000000..39dc6a2
--- /dev/null
+++ b/drivers/spi/mpc52xx_spi.c
@@ -0,0 +1,561 @@
+/*
+ * MPC52xx SPI master driver.
+ * Copyright (C) 2008 Secret Lab Technologies Ltd.
+ *
+ * This is the driver for the MPC5200's dedicated SPI device (not for a
+ * PSC in SPI mode)
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/errno.h>
+#include <linux/of_platform.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+#include <linux/spi/spi.h>
+#include <linux/spi/spi_of.h>
+#include <linux/spi/mpc52xx_spi.h>
+#include <linux/io.h>
+#include <linux/time.h>
+#include <asm/mpc52xx.h>
+
+MODULE_AUTHOR("Grant Likely <grant.likely@secretlab.ca>");
+MODULE_DESCRIPTION("MPC52xx SPI (non-PSC) Driver");
+MODULE_LICENSE("GPL");
+
+/* Register offsets */
+#define SPI_CTRL1	0x00
+#define SPI_CTRL1_SPIE		(1 << 7)
+#define SPI_CTRL1_SPE		(1 << 6)
+#define SPI_CTRL1_MSTR		(1 << 4)
+#define SPI_CTRL1_CPOL		(1 << 3)
+#define SPI_CTRL1_CPHA		(1 << 2)
+#define SPI_CTRL1_SSOE		(1 << 1)
+#define SPI_CTRL1_LSBFE		(1 << 0)
+
+#define SPI_CTRL2	0x01
+#define SPI_BRR		0x04
+
+#define SPI_STATUS	0x05
+#define SPI_STATUS_SPIF		(1 << 7)
+#define SPI_STATUS_WCOL		(1 << 6)
+#define SPI_STATUS_MODF		(1 << 4)
+
+#define SPI_DATA	0x09
+#define SPI_PORTDATA	0x0d
+#define SPI_DATADIR	0x10
+
+/* FSM state return values */
+#define FSM_STOP	0
+#define FSM_POLL	1
+#define FSM_CONTINUE	2
+
+/* Driver internal data */
+struct mpc52xx_spi {
+	struct spi_master *master;
+	u32 sysclk;
+	void __iomem *regs;
+	int irq;
+	int ipb_freq;
+
+	/* Statistics */
+	int msg_count;
+	int wcol_count;
+	int wcol_ticks;
+	u32 wcol_tx_timestamp;
+	int modf_count;
+	int byte_count;
+
+	/* Hooks for platform modification of behaviour */
+	void (*premessage)(struct spi_message *m, void *context);
+	void *premessage_context;
+
+	struct list_head queue;		/* queue of pending messages */
+	spinlock_t lock;
+	struct work_struct work;
+
+
+	/* Details of current transfer (length, and buffer pointers) */
+	struct spi_message *message;	/* current message */
+	struct spi_transfer *transfer;	/* current transfer */
+	int (*state)(struct mpc52xx_spi *ms);
+	int len;
+	int timestamp;
+	u8 *rx_buf;
+	const u8 *tx_buf;
+	int cs_change;
+};
+
+/*
+ * CS control function
+ */
+static void mpc52xx_spi_chipsel(struct mpc52xx_spi *ms, int value)
+{
+	if (value)
+		writeb(0, ms->regs + SPI_PORTDATA); /* Assert SS pin */
+	else
+		writeb(0x08, ms->regs + SPI_PORTDATA); /* Deassert SS pin */
+}
+
+/*
+ * Start a new transfer.  This is called both by the idle state
+ * for the first transfer in a message, and by the wait state when the
+ * previous transfer in a message is complete.
+ */
+static void mpc52xx_spi_start_transfer(struct mpc52xx_spi *ms)
+{
+	ms->rx_buf = ms->transfer->rx_buf;
+	ms->tx_buf = ms->transfer->tx_buf;
+	ms->len = ms->transfer->len;
+
+	/* Activate the chip select */
+	if (ms->cs_change)
+		mpc52xx_spi_chipsel(ms, 1);
+	ms->cs_change = ms->transfer->cs_change;
+
+	/* Write out the first byte */
+	ms->wcol_tx_timestamp = get_tbl();
+	if (ms->tx_buf)
+		writeb(*ms->tx_buf++, ms->regs + SPI_DATA);
+	else
+		writeb(0, ms->regs + SPI_DATA);
+}
+
+/* Forward declaration of state handlers */
+static int mpc52xx_spi_fsmstate_transfer(struct mpc52xx_spi *ms);
+static int mpc52xx_spi_fsmstate_wait(struct mpc52xx_spi *ms);
+
+/*
+ * IDLE state
+ *
+ * No transfers are in progress; if another transfer is pending then retrieve
+ * it and kick it off.  Otherwise, stop processing the state machine
+ */
+static int mpc52xx_spi_fsmstate_idle(struct mpc52xx_spi *ms)
+{
+	struct spi_message *m;
+	struct spi_device *spi;
+	int spr, sppr;
+	u8 ctrl1;
+
+	/* Check if there is another transfer waiting */
+	if (list_empty(&ms->queue))
+		return FSM_STOP;
+
+	/* Get the next message */
+	spin_lock(&ms->lock);
+
+	/* Call the pre-message hook with a pointer to the next
+	 * message.  The pre-message hook may enqueue a new message for
+	 * changing the chip select value to the head of the queue */
+	m = list_first_entry(&ms->queue, struct spi_message, queue);
+	if (ms->premessage)
+		ms->premessage(m, ms->premessage_context);
+
+	/* reget the head of the queue (the premessage hook may have enqueued
+	 * something before it.) and drop the spinlock */
+	ms->message = list_first_entry(&ms->queue, struct spi_message, queue);
+	list_del_init(&ms->message->queue);
+	spin_unlock(&ms->lock);
+
+	/* Setup the controller parameters */
+	ctrl1 = SPI_CTRL1_SPIE | SPI_CTRL1_SPE | SPI_CTRL1_MSTR;
+	spi = ms->message->spi;
+	if (spi->mode & SPI_CPHA)
+		ctrl1 |= SPI_CTRL1_CPHA;
+	if (spi->mode & SPI_CPOL)
+		ctrl1 |= SPI_CTRL1_CPOL;
+	if (spi->mode & SPI_LSB_FIRST)
+		ctrl1 |= SPI_CTRL1_LSBFE;
+	writeb(ctrl1, ms->regs + SPI_CTRL1);
+
+	/* Setup the controller speed */
+	/* minimum divider is '2'.  Also, add '1' to force rounding up. */
+	sppr = ((ms->ipb_freq / ms->message->spi->max_speed_hz) + 1) >> 1;
+	spr = 0;
+	if (sppr < 1)
+		sppr = 1;
+	while (((sppr - 1) & ~0x7) != 0) {
+		sppr = (sppr + 1) >> 1; /* add '1' to force rounding up */
+		spr++;
+	}
+	sppr--;		/* sppr quantity in register is offset by 1 */
+	if (spr > 7) {
+		/* Don't overrun limits of SPI baudrate register */
+		spr = 7;
+		sppr = 7;
+	}
+	writeb(sppr << 4 | spr, ms->regs + SPI_BRR); /* Set speed */
+
+	ms->cs_change = 1;
+	ms->transfer = container_of(ms->message->transfers.next,
+				    struct spi_transfer, transfer_list);
+
+	mpc52xx_spi_start_transfer(ms);
+	ms->state = mpc52xx_spi_fsmstate_transfer;
+
+#if defined(VERBOSE_DEBUG)
+	dev_info(&ms->master->dev, "msg:%p, max_speed:%i, brr:%.2x\n",
+		 ms->message, ms->message->spi->max_speed_hz,
+		 readb(ms->regs + SPI_BRR));
+#endif
+
+	return FSM_CONTINUE;
+}
+
+/*
+ * TRANSFER state
+ *
+ * In the middle of a transfer.  If the SPI core has completed processing
+ * a byte, then read out the received data and write out the next byte
+ * (unless this transfer is finished; in which case go on to the wait
+ * state)
+ */
+static int mpc52xx_spi_fsmstate_transfer(struct mpc52xx_spi *ms)
+{
+	u8 status = readb(ms->regs + SPI_STATUS);
+	u8 data;
+
+	/* Interrupt cleared by read of STATUS followed by read of DATA */
+	if (!status)
+		return ms->irq == NO_IRQ ? FSM_POLL : FSM_STOP;
+
+	if (status & SPI_STATUS_WCOL) {
+		/* The SPI device is stoopid.  At slower speeds, it may raise
+		 * the SPIF flag before the state machine is actually finished.
+		 * which causes a collision (internal to the state machine
+		 * only).  The manual recommends inserting a delay between
+		 * receving the interrupt and sending the next byte, but
+		 * it can also be worked around simply by retrying the
+		 * transfer which is what we do here. */
+		ms->wcol_count++;
+		ms->wcol_ticks += get_tbl() - ms->wcol_tx_timestamp;
+		ms->wcol_tx_timestamp = get_tbl();
+		readb(ms->regs + SPI_DATA); /* clear status */
+		data = 0;
+		if (ms->tx_buf)
+			data = *(ms->tx_buf-1);
+		writeb(data, ms->regs + SPI_DATA); /* try again */
+		return FSM_CONTINUE;
+	} else if (status & SPI_STATUS_MODF) {
+		ms->modf_count++;
+		dev_err(&ms->master->dev, "mod fault\n");
+		readb(ms->regs + SPI_DATA); /* clear status */
+		mpc52xx_spi_chipsel(ms, 0);
+		ms->message->status = -EIO;
+		if (ms->message->complete)
+			ms->message->complete(ms->message->context);
+		ms->state = mpc52xx_spi_fsmstate_idle;
+		return FSM_CONTINUE;
+	}
+
+	/* Read data out of the spi device */
+	ms->byte_count++;
+	data = readb(ms->regs + SPI_DATA);
+	if (ms->rx_buf)
+		*ms->rx_buf++ = data;
+
+	/* Is the transfer complete? */
+	ms->len--;
+	if (ms->len == 0) {
+		ms->timestamp = get_tbl();
+		ms->timestamp += ms->transfer->delay_usecs * tb_ticks_per_usec;
+		ms->state = mpc52xx_spi_fsmstate_wait;
+		return FSM_CONTINUE;
+	}
+
+	/* Write out the next byte */
+	ms->wcol_tx_timestamp = get_tbl();
+	if (ms->tx_buf)
+		writeb(*ms->tx_buf++, ms->regs + SPI_DATA);
+	else
+		writeb(0, ms->regs + SPI_DATA);
+
+	return FSM_CONTINUE;
+}
+
+/*
+ * WAIT state
+ *
+ * A transfer has completed; need to wait for the delay period to complete
+ * before starting the next transfer
+ */
+static int mpc52xx_spi_fsmstate_wait(struct mpc52xx_spi *ms)
+{
+	if (((int)get_tbl()) - ms->timestamp < 0)
+		return FSM_POLL;
+
+	ms->message->actual_length += ms->transfer->len;
+
+	/* Check if there is another transfer in this message.  If there
+	 * aren't then deactivate CS, notify sender, and drop back to idle
+	 * to start the next message. */
+	if (ms->transfer->transfer_list.next == &ms->message->transfers) {
+		ms->msg_count++;
+		mpc52xx_spi_chipsel(ms, 0);
+		ms->message->status = 0;
+		if (ms->message->complete)
+			ms->message->complete(ms->message->context);
+		ms->state = mpc52xx_spi_fsmstate_idle;
+		return FSM_CONTINUE;
+	}
+
+	/* There is another transfer; kick it off */
+
+	if (ms->cs_change)
+		mpc52xx_spi_chipsel(ms, 0);
+
+	ms->transfer = container_of(ms->transfer->transfer_list.next,
+				    struct spi_transfer, transfer_list);
+	mpc52xx_spi_start_transfer(ms);
+	ms->state = mpc52xx_spi_fsmstate_transfer;
+	return FSM_CONTINUE;
+}
+
+/*
+ * IRQ handler
+ */
+static irqreturn_t mpc52xx_spi_irq(int irq, void *_ms)
+{
+	struct mpc52xx_spi *ms = _ms;
+	int rc = FSM_CONTINUE;
+
+	while (rc == FSM_CONTINUE)
+		rc = ms->state(ms);
+
+	if (rc == FSM_POLL)
+		schedule_work(&ms->work);
+
+	return IRQ_HANDLED;
+}
+
+/*
+ * Workqueue method of running the state machine
+ */
+static void mpc52xx_spi_wq(struct work_struct *work)
+{
+	struct mpc52xx_spi *ms = container_of(work, struct mpc52xx_spi, work);
+	mpc52xx_spi_irq(ms->irq, ms);
+}
+
+/*
+ * spi_master callbacks
+ */
+
+static int mpc52xx_spi_setup(struct spi_device *spi)
+{
+	return 0;
+}
+
+static int mpc52xx_spi_transfer(struct spi_device *spi, struct spi_message *m)
+{
+	struct mpc52xx_spi *ms = spi_master_get_devdata(spi->master);
+	unsigned long flags;
+
+	m->actual_length = 0;
+	m->status = -EINPROGRESS;
+
+	spin_lock_irqsave(&ms->lock, flags);
+	list_add_tail(&m->queue, &ms->queue);
+	spin_unlock_irqrestore(&ms->lock, flags);
+	schedule_work(&ms->work);
+
+	return 0;
+}
+
+/*
+ * Hook to modify premessage hook
+ */
+void mpc52xx_spi_set_premessage_hook(struct spi_master *master,
+				     void (*hook)(struct spi_message *m,
+						  void *context),
+				     void *hook_context)
+{
+	struct mpc52xx_spi *ms = spi_master_get_devdata(master);
+	ms->premessage = hook;
+	ms->premessage_context = hook_context;
+}
+EXPORT_SYMBOL(mpc52xx_spi_set_premessage_hook);
+
+/*
+ * SysFS files
+ */
+static int
+*mpc52xx_spi_sysfs_get_counter(struct mpc52xx_spi *ms, const char *name)
+{
+	if (strcmp(name, "msg_count") == 0)
+		return &ms->msg_count;
+	if (strcmp(name, "byte_count") == 0)
+		return &ms->byte_count;
+	if (strcmp(name, "wcol_count") == 0)
+		return &ms->wcol_count;
+	if (strcmp(name, "wcol_ticks") == 0)
+		return &ms->wcol_ticks;
+	if (strcmp(name, "modf_count") == 0)
+		return &ms->modf_count;
+	return NULL;
+}
+
+static ssize_t mpc52xx_spi_show_count(struct device *dev,
+				      struct device_attribute *attr,
+				      char *buf)
+{
+	struct spi_master *master = container_of(dev, struct spi_master, dev);
+	struct mpc52xx_spi *ms = spi_master_get_devdata(master);
+	int *counter;
+
+	counter = mpc52xx_spi_sysfs_get_counter(ms, attr->attr.name);
+	if (!counter)
+		return sprintf(buf, "error\n");
+	return sprintf(buf, "%d\n", *counter);
+}
+
+static ssize_t mpc52xx_spi_set_count(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t count)
+{
+	struct spi_master *master = container_of(dev, struct spi_master, dev);
+	struct mpc52xx_spi *ms = spi_master_get_devdata(master);
+	int *counter;
+	int value = strict_strtoul(buf, NULL, 0);
+
+	counter = mpc52xx_spi_sysfs_get_counter(ms, attr->attr.name);
+	if (counter)
+		*counter = value;
+	return count;
+}
+
+DEVICE_ATTR(msg_count, 0644, mpc52xx_spi_show_count, mpc52xx_spi_set_count);
+DEVICE_ATTR(byte_count, 0644, mpc52xx_spi_show_count, mpc52xx_spi_set_count);
+DEVICE_ATTR(wcol_count, 0644, mpc52xx_spi_show_count, mpc52xx_spi_set_count);
+DEVICE_ATTR(wcol_ticks, 0644, mpc52xx_spi_show_count, mpc52xx_spi_set_count);
+DEVICE_ATTR(modf_count, 0644, mpc52xx_spi_show_count, mpc52xx_spi_set_count);
+
+/*
+ * OF Platform Bus Binding
+ */
+static int __devinit mpc52xx_spi_of_probe(struct of_device *op,
+					  const struct of_device_id *match)
+{
+	struct spi_master *master;
+	struct mpc52xx_spi *ms;
+	void __iomem *regs;
+	const u32 *prop;
+	int irq0, irq1, rc, len;
+
+	/* MMIO registers */
+	dev_dbg(&op->dev, "probing mpc5200 SPI device\n");
+	regs = of_iomap(op->node, 0);
+	if (!regs)
+		return -ENODEV;
+
+	/* irq */
+	irq0 = irq_of_parse_and_map(op->node, 0);
+	irq1 = irq_of_parse_and_map(op->node, 1);
+
+	dev_dbg(&op->dev, "allocating spi_master struct\n");
+	master = spi_alloc_master(&op->dev, sizeof *ms);
+	if (!master)
+		return -ENOMEM;
+	master->bus_num = -1;
+	master->num_chipselect = 1;
+	prop = of_get_property(op->node, "num-slaves", &len);
+	if (prop && len >= sizeof(*prop))
+		master->num_chipselect = *prop;
+
+	master->setup = mpc52xx_spi_setup;
+	master->transfer = mpc52xx_spi_transfer;
+	dev_set_drvdata(&op->dev, master);
+
+	ms = spi_master_get_devdata(master);
+	ms->master = master;
+	ms->regs = regs;
+	ms->irq = irq0;
+	ms->state = mpc52xx_spi_fsmstate_idle;
+	ms->ipb_freq = mpc52xx_find_ipb_freq(op->node);
+	spin_lock_init(&ms->lock);
+	INIT_LIST_HEAD(&ms->queue);
+	INIT_WORK(&ms->work, mpc52xx_spi_wq);
+
+	writeb(SPI_CTRL1_SPIE | SPI_CTRL1_SPE | SPI_CTRL1_MSTR,
+	       ms->regs + SPI_CTRL1);
+	writeb(0x0, ms->regs + SPI_CTRL2);
+	writeb(0xe, ms->regs + SPI_DATADIR);	/* Set output pins */
+	writeb(0x8, ms->regs + SPI_PORTDATA);	/* Deassert /SS signal */
+
+	dev_dbg(&op->dev, "registering spi_master struct\n");
+	rc = spi_register_master(master);
+	if (rc < 0)
+		goto err_register;
+
+	rc = request_irq(irq0, mpc52xx_spi_irq, IRQF_SAMPLE_RANDOM,
+			  "mpc5200 SPI MODF", ms);
+	rc |= request_irq(irq1, mpc52xx_spi_irq, IRQF_SAMPLE_RANDOM,
+			  "mpc5200 SPI SPIF", ms);
+	if (rc) {
+		dev_info(&op->dev, "error requesting irq; using polled mode\n");
+		ms->irq = NO_IRQ; /* operate in polled mode */
+	}
+
+	/* Create SysFS files */
+	rc = device_create_file(&ms->master->dev, &dev_attr_msg_count);
+	rc |= device_create_file(&ms->master->dev, &dev_attr_byte_count);
+	rc |= device_create_file(&ms->master->dev, &dev_attr_wcol_count);
+	rc |= device_create_file(&ms->master->dev, &dev_attr_wcol_ticks);
+	rc |= device_create_file(&ms->master->dev, &dev_attr_modf_count);
+	if (rc)
+		dev_info(&ms->master->dev, "error creating sysfs files\n");
+
+	dev_info(&ms->master->dev, "registered MPC5200 SPI bus\n");
+
+	spi_of_register_devices(master, op->node);
+
+	return rc;
+
+ err_register:
+	spi_master_put(master);
+	return rc;
+}
+
+static void __devexit mpc52xx_spi_of_remove(struct of_device *op)
+{
+	struct spi_master *master = dev_get_drvdata(&op->dev);
+	struct mpc52xx_spi *ms = spi_master_get_devdata(master);
+
+	device_remove_file(&ms->master->dev, &dev_attr_msg_count);
+	device_remove_file(&ms->master->dev, &dev_attr_byte_count);
+	device_remove_file(&ms->master->dev, &dev_attr_wcol_count);
+	device_remove_file(&ms->master->dev, &dev_attr_wcol_ticks);
+	device_remove_file(&ms->master->dev, &dev_attr_modf_count);
+
+	spi_unregister_master(master);
+	spi_master_put(master);
+	iounmap(ms->regs);
+}
+
+static struct of_device_id mpc52xx_spi_of_match[] __devinitdata = {
+	{ .compatible = "fsl,mpc5200-spi", },
+	{}
+};
+MODULE_DEVICE_TABLE(of, mpc52xx_psc_spi_of_match);
+
+static struct of_platform_driver mpc52xx_spi_of_driver = {
+	.owner = THIS_MODULE,
+	.name = "mpc52xx-spi",
+	.match_table = mpc52xx_spi_of_match,
+	.probe = mpc52xx_spi_of_probe,
+	.remove = __exit_p(mpc52xx_spi_of_remove),
+};
+
+static int __init mpc52xx_spi_init(void)
+{
+	return of_register_platform_driver(&mpc52xx_spi_of_driver);
+}
+module_init(mpc52xx_spi_init);
+
+static void __exit mpc52xx_spi_exit(void)
+{
+	of_unregister_platform_driver(&mpc52xx_spi_of_driver);
+}
+module_exit(mpc52xx_spi_exit);
+
diff --git a/include/linux/spi/mpc52xx_spi.h b/include/linux/spi/mpc52xx_spi.h
new file mode 100644
index 0000000..d1004cf
--- /dev/null
+++ b/include/linux/spi/mpc52xx_spi.h
@@ -0,0 +1,10 @@
+
+#ifndef INCLUDE_MPC5200_SPI_H
+#define INCLUDE_MPC5200_SPI_H
+
+extern void mpc52xx_spi_set_premessage_hook(struct spi_master *master,
+					    void (*hook)(struct spi_message *m,
+							 void *context),
+					    void *hook_context);
+
+#endif

