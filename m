Return-Path: <linux-kernel-owner+w=401wt.eu-S1755660AbYF2FDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660AbYF2FDt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 01:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751478AbYF2FDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 01:03:18 -0400
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:26944 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751329AbYF2FDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 01:03:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=3EomFsHsm6TNvEGK5EgcPCpfQ0hesWAxtt9gyXjFw5AgedFyG+H2li/fI9jcJMm+Yi6gbxYjVclY8VDxHotQwxzP7eXvMwfKZhXAPO7yLUGx/UnVvVqc6OlR0bE1l+JsQEj81ySDh+o05/TzbyeXCwt/L5mXH0jdOYVT7aWOWww=  ;
X-YMail-OSG: gdtE7BkVM1lRxGg11tc5zBXQGx7XVsRJOMZDG6U6.ZQgurJUGTS8o1VEP.9pvkYC6DyQLwCivdEtlu5nQKSeIifWoxPxhUv7kx3Tipxwyj5u9KKEERPRAopjvRo5Iqy4p9M-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2.6.26-rc-mm] gpio max7301: check spi_setup() return code, cleanup
Date: Fri, 27 Jun 2008 18:37:45 -0700
User-Agent: KMail/1.9.9
Cc: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>,
       lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806271837.45968.david-b@pacbell.net>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>

Fix inaccuracies in comments, check spi_setup() return code, mask off high 
byte in max7301_read(). Thanks to David Brownell for the review.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
Same as what Guennadi sent 12-june, but with a minor comment tweak.

 drivers/gpio/max7301.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/drivers/gpio/max7301.c	2008-06-27 18:29:35.000000000 -0700
+++ b/drivers/gpio/max7301.c	2008-06-27 18:30:23.000000000 -0700
@@ -71,7 +71,7 @@ struct max7301 {
  *
  * A write to the MAX7301 means one message with one transfer
  *
- * Returns 0 if successfull or a negative value on error
+ * Returns 0 if successful or a negative value on error
  */
 static int max7301_write(struct spi_device *spi, unsigned int reg, unsigned int val)
 {
@@ -84,9 +84,9 @@ static int max7301_write(struct spi_devi
  * @spi: The SPI device
  * @reg: Register offset
  *
- * A read from the MAX7301 means one message with two transfers
+ * A read from the MAX7301 means two transfers; here, one message each
  *
- * Returns positive 8 bit value from device if successfull or a
+ * Returns positive 8 bit value from device if successful or a
  * negative value on error
  */
 static int max7301_read(struct spi_device *spi, unsigned int reg)
@@ -99,12 +99,13 @@ static int max7301_read(struct spi_devic
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
@@ -224,7 +225,9 @@ static int __devinit max7301_probe(struc
 	 */
 	spi->bits_per_word = 16;
 
-	spi->master->setup(spi);
+	ret = spi_setup(spi);
+	if (ret < 0)
+		return ret;
 
 	ts = kzalloc(sizeof(struct max7301), GFP_KERNEL);
 	if (!ts)
