Return-Path: <linux-kernel-owner+w=401wt.eu-S1759178AbZCWPfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759178AbZCWPfL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 11:35:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757657AbZCWPd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 11:33:29 -0400
Received: from mx1.emlix.com ([193.175.82.87]:38969 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755303AbZCWPdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 11:33:24 -0400
From: =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
To: Chris Zankel <chris@zankel.net>,
       David Brownell <dbrownell@users.sourceforge.net>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Johannes Weiner <jw@emlix.com>,
       =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
Subject: [patch 1/6] spi: s6000 spi host driver
Date: Mon, 23 Mar 2009 16:34:17 +0100
Message-Id: <1237822462-32109-1-git-send-email-dg@emlix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Organization: emlix gmbh, Goettingen, Germany"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Weiner <jw@emlix.com>

The host controller has a 128 bit buffer which is shared between rx and tx.
Filling and reading of this buffer happens in a dedicated workqueue.
We always fill it with an integer number of words but don't cross
spi_transfer boundaries.

The driver usually uses interrupts but falls back to polling if the
transfer is expected to finish within a certain window of time.

Signed-off-by: Johannes Weiner <jw@emlix.com>
Signed-off-by: Daniel Glöckner <dg@emlix.com>
---
 drivers/spi/Kconfig           |    6 +
 drivers/spi/Makefile          |    1 +
 drivers/spi/spi_s6000.c       |  648 +++++++++++++++++++++++++++++++++++++++++
 drivers/spi/spi_s6000.h       |   26 ++
 include/linux/spi/spi_s6000.h |   10 +
 5 files changed, 691 insertions(+), 0 deletions(-)
 create mode 100644 drivers/spi/spi_s6000.c
 create mode 100644 drivers/spi/spi_s6000.h
 create mode 100644 include/linux/spi/spi_s6000.h

diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index 83a185d..c373717 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -197,6 +197,12 @@ config SPI_S3C24XX_GPIO
 	  the inbuilt hardware cannot provide the transfer mode, or
 	  where the board is using non hardware connected pins.
 
+config SPI_S6000
+	tristate "S6000 SPI master"
+	depends on SPI_MASTER && XTENSA_VARIANT_S6000
+	help
+	  SPI driver for the Stretch S6000 family SoCs.
+
 config SPI_SH_SCI
 	tristate "SuperH SCI SPI controller"
 	depends on SUPERH
diff --git a/drivers/spi/Makefile b/drivers/spi/Makefile
index 5d04519..3a4dae7 100644
--- a/drivers/spi/Makefile
+++ b/drivers/spi/Makefile
@@ -27,6 +27,7 @@ obj-$(CONFIG_SPI_MPC52xx_PSC)		+= mpc52xx_psc_spi.o
 obj-$(CONFIG_SPI_MPC83xx)		+= spi_mpc83xx.o
 obj-$(CONFIG_SPI_S3C24XX_GPIO)		+= spi_s3c24xx_gpio.o
 obj-$(CONFIG_SPI_S3C24XX)		+= spi_s3c24xx.o
+obj-$(CONFIG_SPI_S6000)			+= spi_s6000.o
 obj-$(CONFIG_SPI_TXX9)			+= spi_txx9.o
 obj-$(CONFIG_SPI_XILINX)		+= xilinx_spi.o
 obj-$(CONFIG_SPI_SH_SCI)		+= spi_sh_sci.o
diff --git a/drivers/spi/spi_s6000.c b/drivers/spi/spi_s6000.c
new file mode 100644
index 0000000..3f3eb92
--- /dev/null
+++ b/drivers/spi/spi_s6000.c
@@ -0,0 +1,648 @@
+/*
+ * s6000 SPI master driver
+ *
+ * Copyright (C) 2009 emlix GmbH
+ * Authors:	Johannes Weiner <jw@emlix.com>
+ *		Daniel Gloeckner <dg@emlix.com>
+ *
+ * All code subject to the GNU GPL version 2.
+ */
+
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/platform_device.h>
+#include <linux/spi/spi.h>
+#include <linux/spi/spi_s6000.h>
+#include <asm/io.h>
+
+#include "spi_s6000.h"
+
+static unsigned long irq_thres = 20000;
+module_param(irq_thres, ulong, 0644);
+
+/* Maximum transfer chunk */
+#define CHUNK_MAX_BITS	(1 << 7)
+#define CHUNK_MAX	(CHUNK_MAX_BITS / 8)
+
+/* Master state */
+struct s6spi {
+	u8 __iomem *mem;
+	struct mutex mutex;
+	spinlock_t lock;
+	struct spi_transfer *xfer;
+	unsigned int busylen;
+	unsigned int remain;
+	unsigned int bits;
+	struct spi_device *spi;
+	struct list_head messages;
+	struct work_struct work;
+	struct workqueue_struct *workqueue;
+	struct clk *clk;
+	struct resource *region;
+	int irq;
+	u32 speed;
+	u8 scratch[CHUNK_MAX_BITS]; /* _BITS for bits_per_word == 1 */
+	u8 cs_deasserted;
+	u8 went_busy;
+};
+
+struct bufstate {
+	u32 __iomem *reg;
+	u32 val;
+	int fill;
+};
+
+#define SPI_READ(s6spi, reg) readl(s6spi->mem + reg)
+#define SPI_WRITE(s6spi, reg, val) writel(val, s6spi->mem + reg)
+
+static u32 get_rx(struct bufstate *bs, int bits)
+{
+	u32 val = bs->val;
+	bs->val >>= bits;
+	bs->fill -= bits;
+	if (bs->fill < 0) {
+		bs->val = readl(bs->reg);
+		bs->reg++;
+		if (bits + bs->fill == 0)
+			val = bs->val; /* there may have been garbage in val */
+		else
+			val |= bs->val << (bits + bs->fill);
+		bs->val >>= -bs->fill;
+		bs->fill += 32;
+	}
+	if (bits < 32)
+		val &= (1 << bits) - 1;
+	return val;
+}
+
+static void put_tx(struct bufstate *bs, u32 val, int bits)
+{
+	bs->val |= val << bs->fill;
+	bs->fill += bits;
+	if (bs->fill >= 32) {
+		bs->fill -= 32;
+		writel(bs->val, bs->reg);
+		bs->val = 0; /* catch u32 >> 32 case */
+		if (bs->fill)
+			bs->val = val >> (bits - bs->fill);
+		bs->reg++;
+	}
+	bs->val &= (1 << bs->fill) - 1;
+}
+
+/*
+ * s6spi_read_rx - read words from receive registers
+ * @s6spi: Device structure
+ * @rx_buf: pointer to buffer for received words
+ * @xfer_len: size of buffer in bytes
+ * @bits: bits per word
+ * @returns: number of bytes written to buffer or -EINVAL
+ */
+static int s6spi_read_rx(struct s6spi *s6spi, void *rx_buf)
+{
+	struct spi_device *spi = s6spi->spi;
+	unsigned int len, xfer_len, bits;
+	struct bufstate bs;
+	int i;
+
+	xfer_len = s6spi->busylen;
+	bits = s6spi->bits;
+	len = CHUNK_MAX_BITS / bits;
+
+	bs.reg = (u32 __iomem *)(s6spi->mem + S6_SPI_RX0);
+	bs.val = 0;
+	bs.fill = 0;
+
+	if (bits <= 8) {
+		u8 *buf = rx_buf;
+		if (len > xfer_len)
+			len = xfer_len;
+		if (spi->mode & SPI_LSB_FIRST)
+			for (i = 0; i < len; i++)
+				buf[i] = get_rx(&bs, bits);
+		else
+			for (i = len; i--;)
+				buf[i] = get_rx(&bs, bits);
+	} else if (bits <= 16) {
+		u16 *buf = rx_buf;
+		xfer_len /= 2;
+		if (len > xfer_len)
+			len = xfer_len;
+		if (spi->mode & SPI_LSB_FIRST)
+			for (i = 0; i < len; i++)
+				buf[i] = get_rx(&bs, bits);
+		else
+			for (i = len; i--;)
+				buf[i] = get_rx(&bs, bits);
+		len *= 2;
+	} else if (bits <= 32) {
+		u32 *buf = rx_buf;
+		xfer_len /= 4;
+		if (len > xfer_len)
+			len = xfer_len;
+		if (spi->mode & SPI_LSB_FIRST)
+			for (i = 0; i < len; i++)
+				buf[i] = get_rx(&bs, bits);
+		else
+			for (i = len; i--;)
+				buf[i] = get_rx(&bs, bits);
+		len *= 4;
+	} else
+		return -EINVAL;
+	return len;
+}
+
+/*
+ * s6spi_write_tx - write words to transmit registers
+ * @s6spi: Device structure
+ * @rx_buf: pointer to buffer of words to send
+ * @xfer_len: size of buffer in bytes
+ * @bits: bits per word
+ * @returns: number of bytes taken from the buffer or -EINVAL
+ */
+static int s6spi_write_tx(struct s6spi *s6spi, const void *tx_buf)
+{
+	struct spi_device *spi = s6spi->spi;
+	unsigned int len, xfer_len, bits;
+	struct bufstate bs;
+	int i;
+	unsigned int words, ctrl;
+
+	xfer_len = s6spi->remain;
+	bits = s6spi->bits;
+	words = CHUNK_MAX_BITS / bits;
+
+	bs.reg = (u32 __iomem *)(s6spi->mem + S6_SPI_TX0);
+	bs.val = 0;
+	bs.fill = 0;
+
+	if (bits <= 8) {
+		u8 *buf = (u8 *)tx_buf;
+		if (words > xfer_len)
+			words = xfer_len;
+		if (spi->mode & SPI_LSB_FIRST)
+			for (i = 0; i < words; i++)
+				put_tx(&bs, buf[i], bits);
+		else
+			for (i = words; i--;)
+				put_tx(&bs, buf[i], bits);
+		len = words;
+	} else if (bits <= 16) {
+		u16 *buf = (u16 *)tx_buf;
+		xfer_len /= 2;
+		if (words > xfer_len)
+			words = xfer_len;
+		if (spi->mode & SPI_LSB_FIRST)
+			for (i = 0; i < words; i++)
+				put_tx(&bs, buf[i], bits);
+		else
+			for (i = words; i--;)
+				put_tx(&bs, buf[i], bits);
+		len = words * 2;
+	} else if (bits <= 32) {
+		u32 *buf = (u32 *)tx_buf;
+		xfer_len /= 4;
+		if (words > xfer_len)
+			words = xfer_len;
+		if (spi->mode & SPI_LSB_FIRST)
+			for (i = 0; i < words; i++)
+				put_tx(&bs, buf[i], bits);
+		else
+			for (i = words; i--;)
+				put_tx(&bs, buf[i], bits);
+		len = words * 4;
+	} else
+		return -EINVAL;
+	if (bs.fill)
+		writel(bs.val, bs.reg);
+
+	ctrl = SPI_READ(s6spi, S6_SPI_CTRL);
+	ctrl &= ~((CHUNK_MAX_BITS - 1) << S6_SPI_CTRL_CHAR_LEN);
+	ctrl |=	((words * bits) & (CHUNK_MAX_BITS - 1)) << S6_SPI_CTRL_CHAR_LEN;
+	SPI_WRITE(s6spi, S6_SPI_CTRL, ctrl);
+
+	return len;
+}
+
+static void s6spi_init_hw(struct s6spi *s6spi)
+{
+	SPI_WRITE(s6spi, S6_SPI_CTRL, 0);
+	SPI_WRITE(s6spi, S6_SPI_SS, s6spi->cs_deasserted);
+}
+
+static void s6spi_set_speed(struct s6spi *s6spi, u32 hz)
+{
+	u32 divider;
+
+	if (!hz) {
+		printk(KERN_ERR "s6spi: 0Hz bus speed requested\n");
+		return;
+	}
+	if (s6spi->speed == hz)
+		return;
+	s6spi->speed = hz;
+	/*
+	 *            clock
+	 * hz = -----------------
+	 *      (divider + 1) * 2
+	 */
+	divider = (clk_get_rate(s6spi->clk) + (2 * hz) - 1) / (2 * hz) - 1;
+	if (divider > S6_SPI_DIVIDER_MAX)
+		divider = S6_SPI_DIVIDER_MAX;
+	SPI_WRITE(s6spi, S6_SPI_DIVIDER, divider);
+}
+
+static void s6spi_set_parms(struct spi_device *spi)
+{
+	struct s6spi *s6spi = spi_master_get_devdata(spi->master);
+	u32 ctrl;
+	int cpol = !!(spi->mode & SPI_CPOL);
+
+	ctrl = SPI_READ(s6spi, S6_SPI_CTRL);
+	/*
+	 * 0			= S6_SPI_CTRL_Tx_NEG
+	 * 0 | CPHA		= S6_SPI_CTRL_Rx_NEG
+	 * CPOL | 0		= S6_SPI_CTRL_Rx_NEG
+	 * CPOL | CPHA		= S6_SPI_CTRL_Tx_NEG
+	 */
+	if (spi->mode & SPI_CPHA)
+		cpol = !cpol;
+
+	ctrl |= cpol << S6_SPI_CTRL_Rx_NEG;
+	ctrl |= !cpol << S6_SPI_CTRL_Tx_NEG;
+
+	if (cpol)
+		ctrl |= (1 << S6_SPI_CTRL_CPOL);
+	if (spi->mode & SPI_LSB_FIRST)
+		ctrl |= (1 << S6_SPI_CTRL_LSB);
+	SPI_WRITE(s6spi, S6_SPI_CTRL, ctrl);
+}
+
+static void s6spi_chip_select(struct spi_device *spi, int on)
+{
+	struct s6spi *s6spi = spi_master_get_devdata(spi->master);
+	u32 value = s6spi->cs_deasserted;
+
+	if (on) {
+		s6spi_set_parms(spi);
+		value ^= 1 << spi->chip_select;
+	}
+	SPI_WRITE(s6spi, S6_SPI_SS, value);
+}
+
+static int s6spi_go_busy(struct s6spi *s6spi)
+{
+	int use_irq;
+	u32 ctrl, divider, bits;
+	divider = SPI_READ(s6spi, S6_SPI_DIVIDER) & S6_SPI_DIVIDER_MAX;
+	divider++;
+	ctrl = SPI_READ(s6spi, S6_SPI_CTRL);
+	bits = (ctrl >> S6_SPI_CTRL_CHAR_LEN) & (CHUNK_MAX_BITS - 1);
+	if (!bits)
+		bits = CHUNK_MAX_BITS;
+	use_irq = (bits * divider > irq_thres);
+	s6spi->went_busy = use_irq;
+	ctrl &= ~(1 << S6_SPI_CTRL_IE);
+	ctrl |= use_irq << S6_SPI_CTRL_IE;
+	ctrl |= 1 << S6_SPI_CTRL_GO_BSY;
+	SPI_WRITE(s6spi, S6_SPI_CTRL, ctrl);
+	return use_irq;
+}
+
+static u32 s6spi_is_busy(struct s6spi *s6spi)
+{
+	return SPI_READ(s6spi, S6_SPI_CTRL) & (1 << S6_SPI_CTRL_GO_BSY);
+}
+
+static void s6spi_int_clear(struct s6spi *s6spi)
+{
+	SPI_WRITE(s6spi, S6_SPI_INT_CLR, 1);
+}
+
+static void s6spi_setup_xfer(struct s6spi *s6spi)
+{
+	struct spi_transfer *xfer = s6spi->xfer;
+	struct spi_device *spi = s6spi->spi;
+	u32 speed;
+
+	speed = xfer->speed_hz;
+	if (!speed)
+		speed = spi->max_speed_hz;
+	s6spi_set_speed(s6spi, speed);
+
+	s6spi->bits = xfer->bits_per_word;
+	if (!s6spi->bits)
+		s6spi->bits = spi->bits_per_word;
+	if (!s6spi->bits)
+		s6spi->bits = 8;
+}
+
+static int s6spi_start_xfer(struct s6spi *s6spi)
+{
+	const void *tx_buf;
+	struct spi_transfer *xfer = s6spi->xfer;
+
+	if (!xfer) {			/* Next message */
+		struct spi_device *spi;
+		struct spi_message *msg;
+
+		if (list_empty(&s6spi->messages))
+			return 1;
+
+		msg = list_first_entry(&s6spi->messages,
+				struct spi_message, queue);
+		xfer = list_first_entry(&msg->transfers,
+				struct spi_transfer, transfer_list);
+
+		msg->status = -EINPROGRESS;
+		msg->actual_length = 0;
+
+		spi = msg->spi;
+		s6spi->spi = spi;
+		s6spi_chip_select(spi, 1);
+
+		s6spi->xfer = xfer;
+		s6spi->remain = xfer->len;
+		s6spi_setup_xfer(s6spi);
+	} else if (!s6spi->remain) {	/* Next transfer in message */
+		if (xfer->delay_usecs)
+			udelay(xfer->delay_usecs);
+		if (xfer->cs_change) {
+			s6spi_chip_select(s6spi->spi, 0);
+			udelay(1);
+			s6spi_chip_select(s6spi->spi, 1);
+		}
+		xfer = list_entry(xfer->transfer_list.next,
+				struct spi_transfer, transfer_list);
+		s6spi->xfer = xfer;
+		s6spi->remain = xfer->len;
+		s6spi_setup_xfer(s6spi);
+	}
+
+	tx_buf = s6spi->scratch;
+	if (xfer->tx_buf)
+		tx_buf = xfer->tx_buf + xfer->len - s6spi->remain;
+
+	s6spi->busylen = s6spi_write_tx(s6spi, tx_buf);
+	return s6spi_go_busy(s6spi);
+}
+
+static void s6spi_end_xfer(struct s6spi *s6spi)
+{
+	void *rx_buf;
+	struct spi_message *msg;
+	struct spi_transfer *xfer = s6spi->xfer;
+
+	if (!xfer)
+		return;
+
+	rx_buf = xfer->rx_buf + xfer->len - s6spi->remain;
+	s6spi->remain -= s6spi->busylen;
+
+	msg = list_first_entry(&s6spi->messages, struct spi_message, queue);
+	msg->actual_length += s6spi->busylen;
+
+	if (xfer->rx_buf)
+		s6spi_read_rx(s6spi, rx_buf);
+
+	if (s6spi->remain)
+		return;
+
+	if (xfer->transfer_list.next == &msg->transfers) {
+		/*
+		 * Last transfer, complete the message
+		 * and check the message queue.
+		 */
+		if (xfer->delay_usecs)
+			udelay(xfer->delay_usecs);
+		if (!xfer->cs_change)
+			s6spi_chip_select(msg->spi, 0);
+		s6spi->xfer = NULL;
+
+		spin_lock(&s6spi->lock);
+		list_del(&msg->queue);
+		spin_unlock(&s6spi->lock);
+
+		msg->status = 0;
+		msg->complete(msg->context);
+	}
+}
+
+static irqreturn_t s6spi_interrupt(int irq, void *dev_id)
+{
+	struct spi_master *master = dev_id;
+	struct s6spi *s6spi = spi_master_get_devdata(master);
+
+	s6spi_int_clear(s6spi);
+	if (!s6spi->went_busy || s6spi_is_busy(s6spi))
+		return IRQ_NONE;
+	s6spi->went_busy = 0;
+	queue_work(s6spi->workqueue, &s6spi->work);
+	return IRQ_HANDLED;
+}
+
+static void s6spi_worker(struct work_struct *ws)
+{
+	int use_irq;
+	struct s6spi *s6spi = container_of(ws, struct s6spi, work);
+
+	do {
+		while (s6spi_is_busy(s6spi));
+
+		mutex_lock(&s6spi->mutex);
+		s6spi_end_xfer(s6spi);
+		use_irq = s6spi_start_xfer(s6spi);
+		mutex_unlock(&s6spi->mutex);
+	} while (!use_irq);
+}
+
+static int s6spi_setup(struct spi_device *spi)
+{
+	u8 mask;
+	struct s6spi *s6spi = spi_master_get_devdata(spi->master);
+
+	mask = 1 << spi->chip_select;
+	mutex_lock(&s6spi->mutex);
+	if (spi->mode & SPI_CS_HIGH)
+		s6spi->cs_deasserted |= mask;
+	else
+		s6spi->cs_deasserted &= ~mask;
+	if (!s6spi->xfer)
+		s6spi_chip_select(spi, 0);
+	mutex_unlock(&s6spi->mutex);
+
+	return 0;
+}
+
+static int s6spi_transfer(struct spi_device *spi, struct spi_message *msg)
+{
+	struct s6spi *s6spi = spi_master_get_devdata(spi->master);
+
+	if (list_empty(&msg->transfers))
+		return -EINVAL;
+
+	spin_lock(&s6spi->lock);
+	list_add_tail(&msg->queue, &s6spi->messages);
+	spin_unlock(&s6spi->lock);
+
+	if (!s6spi->xfer)
+		queue_work(s6spi->workqueue, &s6spi->work);
+
+	return 0;
+}
+
+static int __devinit s6spi_probe(struct platform_device *pdev)
+{
+	int ret;
+	struct s6spi *s6spi;
+	struct spi_master *master;
+	struct resource *res;
+	const char *clock;
+
+	master = spi_alloc_master(&pdev->dev, sizeof(struct s6spi));
+	if (!master)
+		return -ENOMEM;
+
+	master->bus_num = -1;
+	master->setup = s6spi_setup;
+	master->transfer = s6spi_transfer;
+	master->num_chipselect = 8;
+	platform_set_drvdata(pdev, master);
+
+	ret = platform_get_irq(pdev, 0);
+	if (ret < 0)
+		goto error_master;
+
+	s6spi = spi_master_get_devdata(master);
+	s6spi->irq = ret;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		ret = -EINVAL;
+		goto error_master;
+	}
+	s6spi->region = request_mem_region(res->start,
+					   res->end - res->start + 1,
+					   pdev->dev.bus_id);
+	if (!s6spi->region) {
+		ret = -EBUSY;
+		goto error_master;
+	}
+	s6spi->mem = ioremap_nocache(res->start, res->end - res->start + 1);
+	if (!s6spi->mem) {
+		ret = -ENOMEM;
+		goto error_region;
+	}
+
+	s6spi->cs_deasserted = 0;
+	clock = 0;
+	if (pdev->dev.platform_data) {
+		struct s6_spi_platform_data *pdata = pdev->dev.platform_data;
+		s6spi->cs_deasserted = pdata->cs_polarity;
+		master->bus_num = pdata->bus_num;
+		clock = pdata->clock;
+	}
+
+	s6spi->clk = clk_get(&pdev->dev, clock);
+	if (IS_ERR(s6spi->clk)) {
+		ret = PTR_ERR(s6spi->clk);
+		goto error_mapping;
+	}
+	ret = clk_enable(s6spi->clk);
+	if (ret < 0)
+		goto error_clk_put;
+
+	s6spi->workqueue = create_workqueue("spi_s6000");
+	if (!s6spi->workqueue) {
+		ret = -ENOMEM;
+		goto error_clk_dis;
+	}
+
+	ret = request_irq(s6spi->irq, s6spi_interrupt, IRQF_SHARED,
+			  pdev->dev.bus_id, master);
+	if (ret < 0)
+		goto error_wq;
+
+	INIT_WORK(&s6spi->work, s6spi_worker);
+	mutex_init(&s6spi->mutex);
+	spin_lock_init(&s6spi->lock);
+	INIT_LIST_HEAD(&s6spi->messages);
+
+	s6spi->speed = 0;
+	s6spi_init_hw(s6spi);
+
+	ret = spi_register_master(master);
+	if (ret < 0)
+		goto error_irq;
+
+
+	printk(KERN_INFO "s6spi: S6000 SPI master driver <info@emlix.com>\n");
+	return 0;
+
+error_irq:
+	free_irq(s6spi->irq, master);
+error_wq:
+	destroy_workqueue(s6spi->workqueue);
+error_clk_dis:
+	clk_disable(s6spi->clk);
+error_clk_put:
+	clk_put(s6spi->clk);
+error_mapping:
+	iounmap(s6spi->mem);
+error_region:
+	release_mem_region(s6spi->region->start,
+			   s6spi->region->end - s6spi->region->start + 1);
+error_master:
+	spi_master_put(master);
+	return ret;
+}
+
+static int __devexit s6spi_remove(struct platform_device *pdev)
+{
+	struct s6spi *s6spi;
+	struct spi_master *master;
+
+	master = platform_get_drvdata(pdev);
+	s6spi = spi_master_get_devdata(master);
+
+	/* TODO: wait for transfers to finish */
+	destroy_workqueue(s6spi->workqueue);
+	iounmap(s6spi->mem);
+	release_mem_region(s6spi->region->start,
+			   s6spi->region->end - s6spi->region->start + 1);
+	clk_disable(s6spi->clk);
+	clk_put(s6spi->clk);
+	free_irq(s6spi->irq, master);
+	spi_unregister_master(master);
+	return 0;
+}
+
+static struct platform_driver s6spi_driver = {
+	.probe	= s6spi_probe,
+	.remove = __devexit_p(s6spi_remove),
+	.driver	= {
+		.name	= "spi_s6000",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init s6spi_init(void)
+{
+	return platform_driver_register(&s6spi_driver);
+}
+module_init(s6spi_init);
+
+static void __exit s6spi_exit(void)
+{
+	platform_driver_unregister(&s6spi_driver);
+}
+module_exit(s6spi_exit);
+
+MODULE_AUTHOR("Johannes Weiner <jw@emlix.com>");
+MODULE_DESCRIPTION("S6000 SPI master driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/spi/spi_s6000.h b/drivers/spi/spi_s6000.h
new file mode 100644
index 0000000..eff82e3
--- /dev/null
+++ b/drivers/spi/spi_s6000.h
@@ -0,0 +1,26 @@
+#ifndef __DRIVERS_SPI_SPI_S6000_H
+#define __DRIVERS_SPI_SPI_S6000_H
+
+#define S6_SPI_RX0		0x00
+#define S6_SPI_RX1		0x04
+#define S6_SPI_RX2		0x08
+#define S6_SPI_RX3		0x0C
+#define S6_SPI_TX0		0x00
+#define S6_SPI_TX1		0x04
+#define S6_SPI_TX2		0x08
+#define S6_SPI_TX3		0x0C
+#define S6_SPI_CTRL		0x10
+#define S6_SPI_CTRL_GO_BSY		0
+#define S6_SPI_CTRL_Rx_NEG		1
+#define S6_SPI_CTRL_Tx_NEG		2
+#define S6_SPI_CTRL_CHAR_LEN		3
+#define S6_SPI_CTRL_LSB			10
+#define S6_SPI_CTRL_IE			11
+#define S6_SPI_CTRL_ASS			12
+#define S6_SPI_CTRL_CPOL		13
+#define S6_SPI_DIVIDER		0x14
+#define S6_SPI_DIVIDER_MAX		0xffff
+#define S6_SPI_SS		0x18
+#define S6_SPI_INT_CLR		0x20
+
+#endif
diff --git a/include/linux/spi/spi_s6000.h b/include/linux/spi/spi_s6000.h
new file mode 100644
index 0000000..9a02bb5
--- /dev/null
+++ b/include/linux/spi/spi_s6000.h
@@ -0,0 +1,10 @@
+#ifndef __LINUX_SPI_SPI_S6000_H
+#define __LINUX_SPI_SPI_S6000_H
+
+struct s6_spi_platform_data {
+	const char *clock;
+	s16 bus_num;
+	u8 cs_polarity;
+};
+
+#endif
-- 
1.6.2.107.ge47ee

