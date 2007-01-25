Return-Path: <linux-kernel-owner+w=401wt.eu-S933232AbXAYFB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933232AbXAYFB0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 00:01:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933231AbXAYFB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 00:01:26 -0500
Received: from nic2.axis.se ([193.13.178.10]:41828 "EHLO krynn.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933232AbXAYFBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 00:01:24 -0500
Date: Thu, 25 Jan 2007 05:52:07 +0100
Message-Id: <200701250452.l0P4q76u017140@ignucius.se.axis.com>
From: Hans-Peter Nilsson <hans-peter.nilsson@axis.com>
To: dbrownell@users.sourceforge.net
CC: mikael.starvik@axis.com, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: [PATCH] 3/5: Updates to SPI and mmc_spi: tx_default, kernel 2.6.19
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(Please CC me on replies, I'm not subscribed to LKML or the SPI list.  Thanks.)

The SD/MMC SPI-based protocol isn't really duplex.  In the
normal case there's either information transmitted or received,
not both simultaneously.  The unused data is always 0xff; ones.
Unfortunately, the SPI framework leaves outgoing data for a
left-out tx_buf just as "undefined" with no other way to send
constant data than to actually pass a buffer full of ones.  I
imagine other SPI-based protocols being in the same situation so
here's a feature implementation: a controller can say it
supports a default value for the bit being shifted out whenever
there's no tx_buf.  I measured it to improve read performance by
3% for SD/MMC SPI (timing "dd" of the MMC block device) for a
DMA-based controller.  As with the cs_interactive patch, the
functionality is optional for a driver/controller, but I include
an update for the spi_bitbang framework, for clients that don't
implement their own bitbang->txrx_bufs function.  I don't expect
it to save much performance for bitbanged transfers (though the
lessened memory and cache footprint might be nice); it's mostly
to provide an example implementation.  (To make sure, I did
measure it for spi_crisv32_gpio and found no measurable
difference; less than .5% difference with same difference
between equal samples).

Tested together with the other patches on the spi_crisv32_sser
and spi_crisv32_gpio drivers (not yet in the kernel, will IIUC
be submitted as part of the usual arch-maintainer-pushes).

This patch is intended to be applied on top of the cs_inactive
patch (the previous one, 2/5).

Signed-off-by: Hans-Peter Nilsson <hp@axis.com>

diff -upr a/include/linux/spi/spi.h b/include/linux/spi/spi.h
--- a/include/linux/spi/spi.h	2007-01-24 07:10:09.000000000 +0100
+++ b/include/linux/spi/spi.h	2007-01-24 03:58:32.000000000 +0100
@@ -153,6 +153,9 @@ static inline void spi_unregister_driver
  *	SPI slaves, and are numbered from zero to num_chipselects.
  *	each slave has a chipselect signal, but it's common that not
  *	every chipselect is connected to a slave.
+ * @can_tx_default: the controller can specify the "default" bit value:
+ *	if this bit is set and there's no tx data in a message,
+ *	spi_transfer.tx_default then controls the data shifted out.
  * @can_cs_inactive: the controller can send data (or at least toggle the
  *	clock with undefined data output) while having chipselect inactive.
  * @setup: updates the device mode and clocking records used by a
@@ -187,6 +190,11 @@ struct spi_master {
 	 */
 	u16			num_chipselect;
 
+	/* clients can check this to see if they can avoid passing
+	 * transfers where the tx buffer is just zero or is just ones.
+	 */
+	unsigned		can_tx_default:1;
+
 	/* clients that want to toggle the clock while chipselect is
 	 * inactive (has different polarity compared to when data is
 	 * output) must test this bit.
@@ -296,6 +304,9 @@ extern struct spi_master *spi_busnum_to_
  *	important information, and it's ok to pass NULL for both tx_buf
  *	and rx_buf.  It is an error to set this bit if spi_device
  *	.can_cs_inactive == 0.
+ * @tx_default: tx data value (0 or 1) in absence of tx_buf, *iff* the
+ *      master controller supports it (see spi_master.can_tx_default),
+ *      otherwise the tx data is undefined and this bit is unused.
  * @delay_usecs: microseconds to delay after this transfer before
  *	(optionally) changing the chipselect status, then starting
  *	the next transfer or completing this spi_message.
@@ -308,7 +319,9 @@ extern struct spi_master *spi_busnum_to_
  * underlying driver uses dma.
  *
  * If the transmit buffer is null, undefined data will be shifted out
- * while filling rx_buf.  If the receive buffer is null, the data
+ * while filling rx_buf, unless the master controller has indicated
+ * can_tx_default = 1, in which case the data shifted out is specified by
+ * spi_message.tx_default.  If the receive buffer is null, the data
  * shifted in will be discarded.  Only "len" bytes shift out (or in).
  * It's an error to try to shift out a partial word.  (For example, by
  * shifting out three bytes with word size of sixteen or twenty bits;
@@ -351,6 +364,7 @@ struct spi_transfer {
 
 	unsigned	cs_change:1;
 	unsigned	cs_inactive:1;
+	unsigned	tx_default:1;
 	u8		bits_per_word;
 	u16		delay_usecs;
 	u32		speed_hz;
diff -upr a/drivers/spi/spi_bitbang.c b/drivers/spi/spi_bitbang.c
--- a/drivers/spi/spi_bitbang.c	2007-01-24 07:14:12.000000000 +0100
+++ b/drivers/spi/spi_bitbang.c	2007-01-24 06:15:56.000000000 +0100
@@ -77,6 +77,8 @@ static unsigned bitbang_txrx_8(
 
 		if (tx)
 			word = *tx++;
+		else if (t->tx_default)
+			word = 0xff;
 		word = txrx_word(spi, ns, word, bits);
 		if (rx)
 			*rx++ = word;
@@ -103,6 +105,8 @@ static unsigned bitbang_txrx_16(
 
 		if (tx)
 			word = *tx++;
+		else if (t->tx_default)
+			word = 0xffff;
 		word = txrx_word(spi, ns, word, bits);
 		if (rx)
 			*rx++ = word;
@@ -129,6 +133,8 @@ static unsigned bitbang_txrx_32(
 
 		if (tx)
 			word = *tx++;
+		else if (t->tx_default)
+			word = 0xffffffffu;
 		word = txrx_word(spi, ns, word, bits);
 		if (rx)
 			*rx++ = word;
@@ -305,6 +311,7 @@ static void bitbang_work(void *_bitbang)
 		list_for_each_entry (t, &m->transfers, transfer_list) {
 			cs_inactive = t->cs_inactive;
 			BUG_ON(cs_inactive && !spi->master->can_cs_inactive);
+			BUG_ON(t->tx_default && !spi->master->can_tx_default);
 
 			if (bitbang->shutdown) {
 				status = -ESHUTDOWN;
@@ -481,6 +488,17 @@ int spi_bitbang_start(struct spi_bitbang
 	if (!bitbang->txrx_bufs) {
 		bitbang->use_dma = 0;
 		bitbang->txrx_bufs = spi_bitbang_bufs;
+
+		/*
+		 * Because we use spi_bitbang_bufs, spi_bitbang_setup
+		 * must been called (at least from the function
+		 * overriding it) to set cs->txrx_bufs, so the
+		 * function looping over the transfer bytes must be
+		 * one of bitbang_txrx_(8|16|32) where we implement
+		 * tx_default.
+		 */
+		bitbang->master->can_tx_default = 1;
+
 		if (!bitbang->master->setup) {
 			if (!bitbang->setup_transfer)
 				bitbang->setup_transfer =


brgds, H-P
