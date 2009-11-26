Return-Path: <linux-kernel-owner+w=401wt.eu-S1759973AbZKZLPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759973AbZKZLPa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 06:15:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759399AbZKZLP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 06:15:29 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:42061 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759584AbZKZLP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 06:15:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=VN35fAR2spOhluLlHMsED7q97Xn+FhjU72vMsHGz+kM0HMhx0qaFJpLoScb5JqGjY1
         wFOBmk7FdkxQYEn8gsNlFOtXoXAYmqKjHHjETTtUkencUQDDckzkJ8aBhuEF1L5dH2z7
         7MLdZbxYMkrbN7tnOt5zJ6uhKhtcXHrBD5ZVw=
From: Magnus Damm <magnus.damm@gmail.com>
To: spi-devel-general@lists.sourceforge.net
Cc: dbrownell@users.sourceforge.net, linux-kernel@vger.kernel.org,
       grant.likely@secretlab.ca, lethal@linux-sh.org,
       Magnus Damm <magnus.damm@gmail.com>, akpm@linux-foundation.org
Date: Thu, 26 Nov 2009 20:10:05 +0900
Message-Id: <20091126111005.32731.14515.sendpatchset@rxone.opensource.se>
Subject: [PATCH] spi: SuperH MSIOF SPI Master driver V2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

This patch is V2 of SPI Master support for the SuperH MSIOF.
Full duplex, spi mode 0-3, active high cs, 3-wire and lsb
first should all be supported, but the driver has so far
only been tested with "mmc_spi".

The MSIOF hardware comes with 32-bit FIFOs for receive and
transmit, and this driver simply breaks the SPI messages
into FIFO-sized chunks. The MSIOF hardware manages the pins
for clock, receive and transmit (sck/miso/mosi), but the chip
select pin is managed by software and must be configured as
a regular GPIO pin by the board code.

Performance wise there is still room for improvement, but
on a Ecovec board with the built-in sh7724 MSIOF0 this driver
gets Mini-sd read speeds of about half a megabyte per second.

Future work include better clock setup and merging of 8-bit
transfers into 32-bit words to reduce interrupt load and
improve throughput.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 Changes since V1:
 - added timeout handling code
 - const, size_t, WARN_ON(), BUG() fixes
 - use spi_bitbang_setup_transfer()
 - cosmetic stuff

 drivers/spi/Kconfig          |    7 
 drivers/spi/Makefile         |    1 
 drivers/spi/spi_sh_msiof.c   |  691 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/spi/sh_msiof.h |   10 
 4 files changed, 709 insertions(+)

--- 0001/drivers/spi/Kconfig
+++ work/drivers/spi/Kconfig	2009-11-26 19:50:27.000000000 +0900
@@ -220,6 +220,13 @@ config SPI_S3C24XX_GPIO
 	  the inbuilt hardware cannot provide the transfer mode, or
 	  where the board is using non hardware connected pins.
 
+config SPI_SH_MSIOF
+	tristate "SuperH MSIOF SPI controller"
+	depends on SUPERH && HAVE_CLK
+	select SPI_BITBANG
+	help
+	  SPI driver for SuperH MSIOF blocks.
+
 config SPI_SH_SCI
 	tristate "SuperH SCI SPI controller"
 	depends on SUPERH
--- 0001/drivers/spi/Makefile
+++ work/drivers/spi/Makefile	2009-11-26 19:50:27.000000000 +0900
@@ -33,6 +33,7 @@ obj-$(CONFIG_SPI_S3C24XX)		+= spi_s3c24x
 obj-$(CONFIG_SPI_TXX9)			+= spi_txx9.o
 obj-$(CONFIG_SPI_XILINX)		+= xilinx_spi.o
 obj-$(CONFIG_SPI_SH_SCI)		+= spi_sh_sci.o
+obj-$(CONFIG_SPI_SH_MSIOF)		+= spi_sh_msiof.o
 obj-$(CONFIG_SPI_STMP3XXX)		+= spi_stmp.o
 # 	... add above this line ...
 
--- /dev/null
+++ work/drivers/spi/spi_sh_msiof.c	2009-11-26 19:51:01.000000000 +0900
@@ -0,0 +1,691 @@
+/*
+ * SuperH MSIOF SPI Master Interface
+ *
+ * Copyright (c) 2009 Magnus Damm
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/completion.h>
+#include <linux/pm_runtime.h>
+#include <linux/gpio.h>
+#include <linux/bitmap.h>
+#include <linux/clk.h>
+#include <linux/io.h>
+
+#include <linux/spi/spi.h>
+#include <linux/spi/spi_bitbang.h>
+#include <linux/spi/sh_msiof.h>
+
+#include <asm/spi.h>
+#include <asm/unaligned.h>
+
+struct sh_msiof_spi_priv {
+	struct spi_bitbang bitbang; /* must be first for spi_bitbang.c */
+	void __iomem *mapbase;
+	struct clk *clk;
+	struct platform_device *pdev;
+	struct sh_msiof_spi_info *info;
+	struct completion done;
+	unsigned long flags;
+	int tx_fifo_size;
+	int rx_fifo_size;
+};
+
+#define TMDR1	0x00
+#define TMDR2	0x04
+#define TMDR3	0x08
+#define RMDR1	0x10
+#define RMDR2	0x14
+#define RMDR3	0x18
+#define TSCR	0x20
+#define RSCR	0x22
+#define CTR	0x28
+#define FCTR	0x30
+#define STR	0x40
+#define IER	0x44
+#define TDR1	0x48
+#define TDR2	0x4c
+#define TFDR	0x50
+#define RDR1	0x58
+#define RDR2	0x5c
+#define RFDR	0x60
+
+#define CTR_TSCKE (1 << 15)
+#define CTR_TFSE  (1 << 14)
+#define CTR_TXE   (1 << 9)
+#define CTR_RXE   (1 << 8)
+
+#define STR_TEOF  (1 << 23)
+#define STR_REOF  (1 << 7)
+
+static unsigned long sh_msiof_read(struct sh_msiof_spi_priv *p, int reg_offs)
+{
+	switch (reg_offs) {
+	case TSCR:
+	case RSCR:
+		return ioread16(p->mapbase + reg_offs);
+	default:
+		return ioread32(p->mapbase + reg_offs);
+	}
+}
+
+static void sh_msiof_write(struct sh_msiof_spi_priv *p, int reg_offs,
+			   unsigned long value)
+{
+	switch (reg_offs) {
+	case TSCR:
+	case RSCR:
+		iowrite16(value, p->mapbase + reg_offs);
+		break;
+	default:
+		iowrite32(value, p->mapbase + reg_offs);
+		break;
+	}
+}
+
+static int sh_msiof_modify_ctr_wait(struct sh_msiof_spi_priv *p,
+				    unsigned long clr, unsigned long set)
+{
+	unsigned long mask = clr | set;
+	unsigned long data;
+	int k;
+
+	data = sh_msiof_read(p, CTR);
+	data &= ~clr;
+	data |= set;
+	sh_msiof_write(p, CTR, data);
+
+	for (k = 100; k > 0; k--) {
+		if ((sh_msiof_read(p, CTR) & mask) == set)
+			break;
+
+		udelay(10);
+	}
+
+	return k > 0 ? 0 : -ETIMEDOUT;
+}
+
+static irqreturn_t sh_msiof_spi_irq(int irq, void *data)
+{
+	struct sh_msiof_spi_priv *p = data;
+
+	/* just disable the interrupt and wake up */
+	sh_msiof_write(p, IER, 0);
+	complete(&p->done);
+
+	return IRQ_HANDLED;
+}
+
+static struct {
+	unsigned short div;
+	unsigned short scr;
+} const sh_msiof_spi_clk_table[] = {
+	{ 1, 0x0007 },
+	{ 2, 0x0000 },
+	{ 4, 0x0001 },
+	{ 8, 0x0002 },
+	{ 16, 0x0003 },
+	{ 32, 0x0004 },
+	{ 64, 0x1f00 },
+	{ 128, 0x1f01 },
+	{ 256, 0x1f02 },
+	{ 512, 0x1f03 },
+	{ 1024, 0x1f04 },
+};
+
+static void sh_msiof_spi_set_clk_regs(struct sh_msiof_spi_priv *p,
+				      unsigned long parent_rate,
+				      unsigned long spi_hz)
+{
+	unsigned long div = 1024;
+	size_t k;
+
+	if (!WARN_ON(!spi_hz || !parent_rate))
+		div = parent_rate / spi_hz;
+
+	/* TODO: make more fine grained */
+
+	for (k = 0; k < ARRAY_SIZE(sh_msiof_spi_clk_table); k++) {
+		if (sh_msiof_spi_clk_table[k].div >= div)
+			break;
+	}
+
+	k = min_t(int, k, ARRAY_SIZE(sh_msiof_spi_clk_table) - 1);
+
+	sh_msiof_write(p, TSCR, sh_msiof_spi_clk_table[k].scr);
+	sh_msiof_write(p, RSCR, sh_msiof_spi_clk_table[k].scr);
+}
+
+static void sh_msiof_spi_set_pin_regs(struct sh_msiof_spi_priv *p,
+				      int cpol, int cpha,
+				      int tx_hi_z, int lsb_first)
+{
+	unsigned long tmp;
+	int edge;
+
+	/*
+	 * CPOL CPHA     TSCKIZ RSCKIZ TEDG REDG(!)
+	 *    0    0         10     10    1    0
+	 *    0    1         10     10    0    1
+	 *    1    0         11     11    0    1
+	 *    1    1         11     11    1    0
+	 *
+	 * (!) Note: REDG is inverted recommended data sheet setting
+	 */
+
+	sh_msiof_write(p, FCTR, 0);
+	sh_msiof_write(p, TMDR1, 0xe2000005 | (lsb_first << 24));
+	sh_msiof_write(p, RMDR1, 0x22000005 | (lsb_first << 24));
+
+	tmp = 0xa0000000;
+	tmp |= cpol << 30; /* TSCKIZ */
+	tmp |= cpol << 28; /* RSCKIZ */
+
+	edge = cpol ? cpha : !cpha;
+
+	tmp |= edge << 27; /* TEDG */
+	tmp |= !edge << 26; /* REDG */
+	tmp |= (tx_hi_z ? 2 : 0) << 22; /* TXDIZ */
+	sh_msiof_write(p, CTR, tmp);
+}
+
+static void sh_msiof_spi_set_mode_regs(struct sh_msiof_spi_priv *p,
+				       const void *tx_buf, void *rx_buf,
+				       int bits, int words)
+{
+	unsigned long dr2;
+
+	dr2 = ((bits - 1) << 24) | ((words - 1) << 16);
+
+	if (tx_buf)
+		sh_msiof_write(p, TMDR2, dr2);
+	else
+		sh_msiof_write(p, TMDR2, dr2 | 1);
+
+	if (rx_buf)
+		sh_msiof_write(p, RMDR2, dr2);
+
+	sh_msiof_write(p, IER, STR_TEOF | STR_REOF);
+}
+
+static void sh_msiof_reset_str(struct sh_msiof_spi_priv *p)
+{
+	sh_msiof_write(p, STR, sh_msiof_read(p, STR));
+}
+
+static void sh_msiof_spi_write_fifo_8(struct sh_msiof_spi_priv *p,
+				      const void *tx_buf, int words, int fs)
+{
+	const unsigned char *buf_8 = tx_buf;
+	int k;
+
+	for (k = 0; k < words; k++)
+		sh_msiof_write(p, TFDR, buf_8[k] << fs);
+}
+
+static void sh_msiof_spi_write_fifo_16(struct sh_msiof_spi_priv *p,
+				       const void *tx_buf, int words, int fs)
+{
+	const unsigned short *buf_16 = tx_buf;
+	int k;
+
+	for (k = 0; k < words; k++)
+		sh_msiof_write(p, TFDR, buf_16[k] << fs);
+}
+
+static void sh_msiof_spi_write_fifo_16u(struct sh_msiof_spi_priv *p,
+					const void *tx_buf, int words, int fs)
+{
+	const unsigned short *buf_16 = tx_buf;
+	int k;
+
+	for (k = 0; k < words; k++)
+		sh_msiof_write(p, TFDR, get_unaligned(&buf_16[k]) << fs);
+}
+
+static void sh_msiof_spi_write_fifo_32(struct sh_msiof_spi_priv *p,
+				       const void *tx_buf, int words, int fs)
+{
+	const unsigned int *buf_32 = tx_buf;
+	int k;
+
+	for (k = 0; k < words; k++)
+		sh_msiof_write(p, TFDR, buf_32[k] << fs);
+}
+
+static void sh_msiof_spi_write_fifo_32u(struct sh_msiof_spi_priv *p,
+					const void *tx_buf, int words, int fs)
+{
+	const unsigned int *buf_32 = tx_buf;
+	int k;
+
+	for (k = 0; k < words; k++)
+		sh_msiof_write(p, TFDR, get_unaligned(&buf_32[k]) << fs);
+}
+
+static void sh_msiof_spi_read_fifo_8(struct sh_msiof_spi_priv *p,
+				     void *rx_buf, int words, int fs)
+{
+	unsigned char *buf_8 = rx_buf;
+	int k;
+
+	for (k = 0; k < words; k++)
+		buf_8[k] = sh_msiof_read(p, RFDR) >> fs;
+}
+
+static void sh_msiof_spi_read_fifo_16(struct sh_msiof_spi_priv *p,
+				      void *rx_buf, int words, int fs)
+{
+	unsigned short *buf_16 = rx_buf;
+	int k;
+
+	for (k = 0; k < words; k++)
+		buf_16[k] = sh_msiof_read(p, RFDR) >> fs;
+}
+
+static void sh_msiof_spi_read_fifo_16u(struct sh_msiof_spi_priv *p,
+				       void *rx_buf, int words, int fs)
+{
+	unsigned short *buf_16 = rx_buf;
+	int k;
+
+	for (k = 0; k < words; k++)
+		put_unaligned(sh_msiof_read(p, RFDR) >> fs, &buf_16[k]);
+}
+
+static void sh_msiof_spi_read_fifo_32(struct sh_msiof_spi_priv *p,
+				      void *rx_buf, int words, int fs)
+{
+	unsigned int *buf_32 = rx_buf;
+	int k;
+
+	for (k = 0; k < words; k++)
+		buf_32[k] = sh_msiof_read(p, RFDR) >> fs;
+}
+
+static void sh_msiof_spi_read_fifo_32u(struct sh_msiof_spi_priv *p,
+				       void *rx_buf, int words, int fs)
+{
+	unsigned int *buf_32 = rx_buf;
+	int k;
+
+	for (k = 0; k < words; k++)
+		put_unaligned(sh_msiof_read(p, RFDR) >> fs, &buf_32[k]);
+}
+
+static int sh_msiof_spi_bits(struct spi_device *spi, struct spi_transfer *t)
+{
+	int bits;
+
+	bits = t ? t->bits_per_word : 0;
+	bits = bits ? bits : spi->bits_per_word;
+	return bits;
+}
+
+static unsigned long sh_msiof_spi_hz(struct spi_device *spi,
+				     struct spi_transfer *t)
+{
+	unsigned long hz;
+
+	hz = t ? t->speed_hz : 0;
+	hz = hz ? hz : spi->max_speed_hz;
+	return hz;
+}
+
+static int sh_msiof_spi_setup_transfer(struct spi_device *spi,
+				       struct spi_transfer *t)
+{
+	int bits;
+
+	/* noting to check hz values against since parent clock is disabled */
+
+	bits = sh_msiof_spi_bits(spi, t);
+	if (bits < 8)
+		return -EINVAL;
+	if (bits > 32)
+		return -EINVAL;
+
+	return spi_bitbang_setup_transfer(spi, t);
+}
+
+static void sh_msiof_spi_chipselect(struct spi_device *spi, int is_on)
+{
+	struct sh_msiof_spi_priv *p = spi_master_get_devdata(spi->master);
+	int value;
+
+	/* chip select is active low unless SPI_CS_HIGH is set */
+	if (spi->mode & SPI_CS_HIGH)
+		value = (is_on == BITBANG_CS_ACTIVE) ? 1 : 0;
+	else
+		value = (is_on == BITBANG_CS_ACTIVE) ? 0 : 1;
+
+	if (is_on == BITBANG_CS_ACTIVE) {
+		if (!test_and_set_bit(0, &p->flags)) {
+			pm_runtime_get_sync(&p->pdev->dev);
+			clk_enable(p->clk);
+		}
+
+		/* Configure pins before asserting CS */
+		sh_msiof_spi_set_pin_regs(p, !!(spi->mode & SPI_CPOL),
+					  !!(spi->mode & SPI_CPHA),
+					  !!(spi->mode & SPI_3WIRE),
+					  !!(spi->mode & SPI_LSB_FIRST));
+	}
+
+	/* use spi->controller data for CS (same strategy as spi_gpio) */
+	gpio_set_value((unsigned)spi->controller_data, value);
+
+	if (is_on == BITBANG_CS_INACTIVE) {
+		if (test_and_clear_bit(0, &p->flags)) {
+			clk_disable(p->clk);
+			pm_runtime_put(&p->pdev->dev);
+		}
+	}
+}
+
+static int sh_msiof_spi_txrx_once(struct sh_msiof_spi_priv *p,
+				  void (*tx_fifo)(struct sh_msiof_spi_priv *,
+						  const void *, int, int),
+				  void (*rx_fifo)(struct sh_msiof_spi_priv *,
+						  void *, int, int),
+				  const void *tx_buf, void *rx_buf,
+				  int words, int bits)
+{
+	int fifo_shift;
+	int ret;
+
+	/* limit maximum word transfer to rx/tx fifo size */
+	if (tx_buf)
+		words = min_t(int, words, p->tx_fifo_size);
+	if (rx_buf)
+		words = min_t(int, words, p->rx_fifo_size);
+
+	/* the fifo contents need shifting */
+	fifo_shift = 32 - bits;
+
+	/* setup msiof transfer mode registers */
+	sh_msiof_spi_set_mode_regs(p, tx_buf, rx_buf, bits, words);
+
+	/* write tx fifo */
+	if (tx_buf)
+		tx_fifo(p, tx_buf, words, fifo_shift);
+
+	/* setup clock and rx/tx signals */
+	ret = sh_msiof_modify_ctr_wait(p, 0, CTR_TSCKE);
+	if (rx_buf)
+		ret = ret ? ret : sh_msiof_modify_ctr_wait(p, 0, CTR_RXE);
+	ret = ret ? ret : sh_msiof_modify_ctr_wait(p, 0, CTR_TXE);
+
+	/* start by setting frame bit */
+	INIT_COMPLETION(p->done);
+	ret = ret ? ret : sh_msiof_modify_ctr_wait(p, 0, CTR_TFSE);
+	if (ret) {
+		dev_err(&p->pdev->dev, "failed to start hardware\n");
+		goto err;
+	}
+
+	/* wait for tx fifo to be emptied / rx fifo to be filled */
+	wait_for_completion(&p->done);
+
+	/* read rx fifo */
+	if (rx_buf)
+		rx_fifo(p, rx_buf, words, fifo_shift);
+
+	/* clear status bits */
+	sh_msiof_reset_str(p);
+
+	/* shut down frame, tx/tx and clock signals */
+	ret = sh_msiof_modify_ctr_wait(p, CTR_TFSE, 0);
+	ret = ret ? ret : sh_msiof_modify_ctr_wait(p, CTR_TXE, 0);
+	if (rx_buf)
+		ret = ret ? ret : sh_msiof_modify_ctr_wait(p, CTR_RXE, 0);
+	ret = ret ? ret : sh_msiof_modify_ctr_wait(p, CTR_TSCKE, 0);
+	if (ret) {
+		dev_err(&p->pdev->dev, "failed to shut down hardware\n");
+		goto err;
+	}
+
+	return words;
+
+ err:
+	sh_msiof_write(p, IER, 0);
+	return ret;
+}
+
+static int sh_msiof_spi_txrx(struct spi_device *spi, struct spi_transfer *t)
+{
+	struct sh_msiof_spi_priv *p = spi_master_get_devdata(spi->master);
+	void (*tx_fifo)(struct sh_msiof_spi_priv *, const void *, int, int);
+	void (*rx_fifo)(struct sh_msiof_spi_priv *, void *, int, int);
+	int bits;
+	int bytes_per_word;
+	int bytes_done;
+	int words;
+	int n;
+
+	bits = sh_msiof_spi_bits(spi, t);
+
+	/* setup bytes per word and fifo read/write functions */
+	if (bits <= 8) {
+		bytes_per_word = 1;
+		tx_fifo = sh_msiof_spi_write_fifo_8;
+		rx_fifo = sh_msiof_spi_read_fifo_8;
+	} else if (bits <= 16) {
+		bytes_per_word = 2;
+		if ((unsigned long)t->tx_buf & 0x01)
+			tx_fifo = sh_msiof_spi_write_fifo_16u;
+		else
+			tx_fifo = sh_msiof_spi_write_fifo_16;
+
+		if ((unsigned long)t->rx_buf & 0x01)
+			rx_fifo = sh_msiof_spi_read_fifo_16u;
+		else
+			rx_fifo = sh_msiof_spi_read_fifo_16;
+	} else {
+		bytes_per_word = 4;
+		if ((unsigned long)t->tx_buf & 0x03)
+			tx_fifo = sh_msiof_spi_write_fifo_32u;
+		else
+			tx_fifo = sh_msiof_spi_write_fifo_32;
+
+		if ((unsigned long)t->rx_buf & 0x03)
+			rx_fifo = sh_msiof_spi_read_fifo_32u;
+		else
+			rx_fifo = sh_msiof_spi_read_fifo_32;
+	}
+
+	/* setup clocks (clock already enabled in chipselect()) */
+	sh_msiof_spi_set_clk_regs(p, clk_get_rate(p->clk),
+				  sh_msiof_spi_hz(spi, t));
+
+	/* transfer in fifo sized chunks */
+	words = t->len / bytes_per_word;
+	bytes_done = 0;
+
+	while (bytes_done < t->len) {
+		n = sh_msiof_spi_txrx_once(p, tx_fifo, rx_fifo,
+					   t->tx_buf + bytes_done,
+					   t->rx_buf + bytes_done,
+					   words, bits);
+		if (n < 0)
+			break;
+
+		bytes_done += n * bytes_per_word;
+		words -= n;
+	}
+
+	return bytes_done;
+}
+
+static u32 sh_msiof_spi_txrx_word(struct spi_device *spi, unsigned nsecs,
+				  u32 word, u8 bits)
+{
+	BUG(); /* unused but needed by bitbang code */
+	return 0;
+}
+
+static int sh_msiof_spi_probe(struct platform_device *pdev)
+{
+	struct resource	*r;
+	struct spi_master *master;
+	struct sh_msiof_spi_priv *p;
+	char clk_name[16];
+	int i;
+	int ret;
+
+	master = spi_alloc_master(&pdev->dev, sizeof(struct sh_msiof_spi_priv));
+	if (master == NULL) {
+		dev_err(&pdev->dev, "failed to allocate spi master\n");
+		ret = -ENOMEM;
+		goto err0;
+	}
+
+	p = spi_master_get_devdata(master);
+
+	platform_set_drvdata(pdev, p);
+	p->info = pdev->dev.platform_data;
+	init_completion(&p->done);
+
+	snprintf(clk_name, sizeof(clk_name), "msiof%d", pdev->id);
+	p->clk = clk_get(&pdev->dev, clk_name);
+	if (IS_ERR(p->clk)) {
+		dev_err(&pdev->dev, "cannot get clock \"%s\"\n", clk_name);
+		ret = PTR_ERR(p->clk);
+		goto err1;
+	}
+
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	i = platform_get_irq(pdev, 0);
+	if (!r || i < 0) {
+		dev_err(&pdev->dev, "cannot get platform resources\n");
+		ret = -ENOENT;
+		goto err2;
+	}
+	p->mapbase = ioremap_nocache(r->start, resource_size(r));
+	if (!p->mapbase) {
+		dev_err(&pdev->dev, "unable to ioremap\n");
+		ret = -ENXIO;
+		goto err2;
+	}
+
+	ret = request_irq(i, sh_msiof_spi_irq, IRQF_DISABLED,
+			  dev_name(&pdev->dev), p);
+	if (ret) {
+		dev_err(&pdev->dev, "unable to request irq\n");
+		goto err3;
+	}
+
+	p->pdev = pdev;
+	pm_runtime_enable(&pdev->dev);
+
+	/* The standard version of MSIOF use 64 word FIFOs */
+	p->tx_fifo_size = 64;
+	p->rx_fifo_size = 64;
+
+	/* Platform data may override FIFO sizes */
+	if (p->info->tx_fifo_override)
+		p->tx_fifo_size = p->info->tx_fifo_override;
+	if (p->info->rx_fifo_override)
+		p->rx_fifo_size = p->info->rx_fifo_override;
+
+	/* init master and bitbang code */
+	master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_CS_HIGH;
+	master->mode_bits |= SPI_LSB_FIRST | SPI_3WIRE;
+	master->flags = 0;
+	master->bus_num = pdev->id;
+	master->num_chipselect = p->info->num_chipselect;
+	master->setup = spi_bitbang_setup;
+	master->cleanup = spi_bitbang_cleanup;
+
+	p->bitbang.master = master;
+	p->bitbang.chipselect = sh_msiof_spi_chipselect;
+	p->bitbang.setup_transfer = sh_msiof_spi_setup_transfer;
+	p->bitbang.txrx_bufs = sh_msiof_spi_txrx;
+	p->bitbang.txrx_word[SPI_MODE_0] = sh_msiof_spi_txrx_word;
+	p->bitbang.txrx_word[SPI_MODE_1] = sh_msiof_spi_txrx_word;
+	p->bitbang.txrx_word[SPI_MODE_2] = sh_msiof_spi_txrx_word;
+	p->bitbang.txrx_word[SPI_MODE_3] = sh_msiof_spi_txrx_word;
+
+	ret = spi_bitbang_start(&p->bitbang);
+	if (ret == 0)
+		return 0;
+
+	pm_runtime_disable(&pdev->dev);
+ err3:
+	iounmap(p->mapbase);
+ err2:
+	clk_put(p->clk);
+ err1:
+	spi_master_put(master);
+ err0:
+	return ret;
+}
+
+static int sh_msiof_spi_remove(struct platform_device *pdev)
+{
+	struct sh_msiof_spi_priv *p = platform_get_drvdata(pdev);
+	int ret;
+
+	ret = spi_bitbang_stop(&p->bitbang);
+	if (!ret) {
+		pm_runtime_disable(&pdev->dev);
+		free_irq(platform_get_irq(pdev, 0), sh_msiof_spi_irq);
+		iounmap(p->mapbase);
+		clk_put(p->clk);
+		spi_master_put(p->bitbang.master);
+	}
+	return ret;
+}
+
+static int sh_msiof_spi_runtime_nop(struct device *dev)
+{
+	/* Runtime PM callback shared between ->runtime_suspend()
+	 * and ->runtime_resume(). Simply returns success.
+	 *
+	 * This driver re-initializes all registers after
+	 * pm_runtime_get_sync() anyway so there is no need
+	 * to save and restore registers here.
+	 */
+	return 0;
+}
+
+static struct dev_pm_ops sh_msiof_spi_dev_pm_ops = {
+	.runtime_suspend = sh_msiof_spi_runtime_nop,
+	.runtime_resume = sh_msiof_spi_runtime_nop,
+};
+
+static struct platform_driver sh_msiof_spi_drv = {
+	.probe		= sh_msiof_spi_probe,
+	.remove		= sh_msiof_spi_remove,
+	.driver		= {
+		.name		= "spi_sh_msiof",
+		.owner		= THIS_MODULE,
+		.pm		= &sh_msiof_spi_dev_pm_ops,
+	},
+};
+
+static int __init sh_msiof_spi_init(void)
+{
+	return platform_driver_register(&sh_msiof_spi_drv);
+}
+module_init(sh_msiof_spi_init);
+
+static void __exit sh_msiof_spi_exit(void)
+{
+	platform_driver_unregister(&sh_msiof_spi_drv);
+}
+module_exit(sh_msiof_spi_exit);
+
+MODULE_DESCRIPTION("SuperH MSIOF SPI Master Interface Driver");
+MODULE_AUTHOR("Magnus Damm");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:spi_sh_msiof");
--- /dev/null
+++ work/include/linux/spi/sh_msiof.h	2009-11-26 19:50:28.000000000 +0900
@@ -0,0 +1,10 @@
+#ifndef __SPI_SH_MSIOF_H__
+#define __SPI_SH_MSIOF_H__
+
+struct sh_msiof_spi_info {
+	int tx_fifo_override;
+	int rx_fifo_override;
+	u16 num_chipselect;
+};
+
+#endif /* __SPI_SH_MSIOF_H__ */
