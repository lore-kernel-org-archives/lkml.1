Return-Path: <linux-kernel-owner+w=401wt.eu-S1752359AbXA0TZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359AbXA0TZg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 14:25:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752363AbXA0TZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 14:25:36 -0500
Received: from smtp112.sbc.mail.mud.yahoo.com ([68.142.198.211]:47455 "HELO
	smtp112.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752359AbXA0TZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 14:25:35 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=PlmjW+q3PsgnkkjwL7bpNwbpri/W0JxWyPgok/7U5KrqrDubwGSTu7qBAyfCM7REIziyvF0s0m9tW5en4nXnKyIMKr78/HdJhMSBdNvHB8NQRnhHotv9o16+Be47b8jT198H5lO/I7m1lE64UcvaI+ZA83zJZ3IpXMT8sUyyoLs=  ;
X-YMail-OSG: c6kGVvwVM1lDRD.DK1jMXWgQkw.EvIACZ42_N2MGJUtfz.N07CeE3jwkIc0zHuTzMZcL9mTmiQ--
From: David Brownell <david-b@pacbell.net>
To: Hans-Peter Nilsson <hans-peter.nilsson@axis.com>
Subject: Re: [PATCH 1/2] take 2: (was-kind-of: 3/5 SPI tx_default) 2.6.20-rc6
Date: Fri, 26 Jan 2007 20:21:54 -0800
User-Agent: KMail/1.7.1
Cc: linux-kernel@vger.kernel.org, mikael.starvik@axis.com,
       spi-devel-general@lists.sourceforge.net
References: <200701261046.l0QAkIdt032408@ignucius.se.axis.com> <200701261521.15844.david-b@pacbell.net>
In-Reply-To: <200701261521.15844.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701262021.55317.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 January 2007 3:21 pm, David Brownell wrote:
> > FWIW, I defined it as a single bit in that patch, because that's
> > what my HW can do when the transmitter is disabled - and because
> > MOSI *is* a single-valued signal. ;-) 
> 
> I wouldn't mind a single bit flag either, saying whether to shift
> out all ones or all zeroes.  The controller driver would morph it
> to something appropriate ... 0xff, 0xffffffff, etc.

In fact, how about this one instead?  It uses a bit in spi->mode
since that's pretty easy to test.  And while it doesn't get rid
of the multiple conditionals when the tx buffer is null, it does
let the other values be constants (0, ~0) that compilers like.

(I can update your patch #4, etc, to match.)

- Dave


Index: g26/include/linux/spi/spi.h
===================================================================
--- g26.orig/include/linux/spi/spi.h	2007-01-26 15:16:26.000000000 -0800
+++ g26/include/linux/spi/spi.h	2007-01-26 17:07:30.000000000 -0800
@@ -71,6 +71,7 @@ struct spi_device {
 #define	SPI_MODE_3	(SPI_CPOL|SPI_CPHA)
 #define	SPI_CS_HIGH	0x04			/* chipselect active high? */
 #define	SPI_LSB_FIRST	0x08			/* per-word bits-on-wire */
+#define	SPI_TX_1	0x10			/* shift out ones on rx-only */
 	u8			bits_per_word;
 	int			irq;
 	void			*controller_state;
@@ -296,8 +297,9 @@ extern struct spi_master *spi_busnum_to_
  * the data being transferred; that may reduce overhead, when the
  * underlying driver uses dma.
  *
- * If the transmit buffer is null, zeroes will be shifted out
- * while filling rx_buf.  If the receive buffer is null, the data
+ * If the transmit buffer is null, zeroes will be shifted out while
+ * filling rx_buf, unless SPI_TX_1 is set in spi->mode (in which case
+ * ones will be shifted out).  If the receive buffer is null, the data
  * shifted in will be discarded.  Only "len" bytes shift out (or in).
  * It's an error to try to shift out a partial word.  (For example, by
  * shifting out three bytes with word size of sixteen or twenty bits;
Index: g26/drivers/spi/spi_bitbang.c
===================================================================
--- g26.orig/drivers/spi/spi_bitbang.c	2007-01-26 17:29:55.000000000 -0800
+++ g26/drivers/spi/spi_bitbang.c	2007-01-26 17:36:17.000000000 -0800
@@ -73,10 +73,14 @@ static unsigned bitbang_txrx_8(
 	u8			*rx = t->rx_buf;
 
 	while (likely(count > 0)) {
-		u8		word = 0;
+		u8		word;
 
 		if (tx)
 			word = *tx++;
+		else if (spi->mode & SPI_TX_1)
+			word = ~0;
+		else
+			word = 0;
 		word = txrx_word(spi, ns, word, bits);
 		if (rx)
 			*rx++ = word;
@@ -99,10 +103,14 @@ static unsigned bitbang_txrx_16(
 	u16			*rx = t->rx_buf;
 
 	while (likely(count > 1)) {
-		u16		word = 0;
+		u16		word;
 
 		if (tx)
 			word = *tx++;
+		else if (spi->mode & SPI_TX_1)
+			word = ~0;
+		else
+			word = 0;
 		word = txrx_word(spi, ns, word, bits);
 		if (rx)
 			*rx++ = word;
@@ -125,10 +133,14 @@ static unsigned bitbang_txrx_32(
 	u32			*rx = t->rx_buf;
 
 	while (likely(count > 3)) {
-		u32		word = 0;
+		u32		word;
 
 		if (tx)
 			word = *tx++;
+		else if (spi->mode & SPI_TX_1)
+			word = ~0;
+		else
+			word = 0;
 		word = txrx_word(spi, ns, word, bits);
 		if (rx)
 			*rx++ = word;
@@ -176,6 +188,8 @@ int spi_bitbang_setup_transfer(struct sp
 }
 EXPORT_SYMBOL_GPL(spi_bitbang_setup_transfer);
 
+#define MODEBITS	(SPI_CPHA | SPI_CPOL | SPI_CS_HIGH | SPI_TX_1)
+
 /**
  * spi_bitbang_setup - default setup for per-word I/O loops
  */
@@ -192,8 +206,11 @@ int spi_bitbang_setup(struct spi_device 
 	 * just bitbang_txrx_le_cphaX() routines shifting the other way, and
 	 * some hardware controllers also have this support.
 	 */
-	if ((spi->mode & SPI_LSB_FIRST) != 0)
+	if (spi->mode & ~MODEBITS) {
+		dev_dbg(&spi->dev, "unsupported SPI mode bits %04x\n",
+				spi->mode & ~MODEBITS);
 		return -EINVAL;
+	}
 
 	if (!cs) {
 		cs = kzalloc(sizeof *cs, GFP_KERNEL);
