Return-Path: <linux-kernel-owner+w=401wt.eu-S1761973AbYFLNN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761973AbYFLNN4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 09:13:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759850AbYFLNNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 09:13:45 -0400
Received: from mail.gmx.net ([213.165.64.20]:54226 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757050AbYFLNNo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 09:13:44 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1+c8ZMJ33yceXZ4vvfU0s9nGgGYB6Gc6YnA0r/Tdu
	Nkg2gwb4CHM0cu
Date: Thu, 12 Jun 2008 15:13:53 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
X-X-Sender: lyakh@axis700.grange
To: David Brownell <david-b@pacbell.net>
cc: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm] max7301: check spi_setup() return code, general cleanup
In-Reply-To: <200806120015.50953.david-b@pacbell.net>
Message-ID: <Pine.LNX.4.64.0806121504560.18017@axis700.grange>
References: <Pine.LNX.4.64.0806061625260.3338@axis700.grange>
 <200806120015.50953.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix inaccuracies in comments, check spi_setup() return code, mask off high 
byte in max7301_read(). Thanks to David Brownell for the review.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>

---

On Thu, 12 Jun 2008, David Brownell wrote:

> Some comments about one routine; presumably more to follow:

Hopefully all points addressed.

Thanks
Guennadi

diff --git a/drivers/gpio/max7301.c b/drivers/gpio/max7301.c
index f35fac5..fc7cebc 100644
--- a/drivers/gpio/max7301.c
+++ b/drivers/gpio/max7301.c
@@ -71,7 +71,7 @@ struct max7301 {
  *
  * A write to the MAX7301 means one message with one transfer
  *
- * Returns 0 if successfull or a negative value on error
+ * Returns 0 if successful or a negative value on error
  */
 static int max7301_write(struct spi_device *spi, unsigned int reg, unsigned int val)
 {
@@ -84,9 +84,9 @@ static int max7301_write(struct spi_device *spi, unsigned int reg, unsigned int
  * @spi: The SPI device
  * @reg: Register offset
  *
- * A read from the MAX7301 means one message with two transfers
+ * A read from the MAX7301 means two messages with one transfer each
  *
- * Returns positive 8 bit value from device if successfull or a
+ * Returns positive 8 bit value from device if successful or a
  * negative value on error
  */
 static int max7301_read(struct spi_device *spi, unsigned int reg)
@@ -99,12 +99,13 @@ static int max7301_read(struct spi_device *spi, unsigned int reg)
 	if (ret)
 		return ret;
 	/*
-	 * FIXME: This read should write 0x0000 (=NOOP at MAX7301 side)
+	 * This relies on the fact, that a transfer with NULL tx_buf shifts out
+	 * zero bytes (=NOOP for MAX7301)
 	 */
 	ret = spi_read(spi, (u8 *)&word, sizeof(word));
 	if (ret)
 		return ret;
-	return word;
+	return word & 0xff;
 }
 
 static int max7301_direction_input(struct gpio_chip *chip, unsigned offset)
@@ -224,7 +225,9 @@ static int __devinit max7301_probe(struct spi_device *spi)
 	 */
 	spi->bits_per_word = 16;
 
-	spi->master->setup(spi);
+	ret = spi_setup(spi);
+	if (ret < 0)
+		return ret;
 
 	ts = kzalloc(sizeof(struct max7301), GFP_KERNEL);
 	if (!ts)
