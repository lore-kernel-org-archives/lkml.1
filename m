Return-Path: <linux-kernel-owner+w=401wt.eu-S1756757AbYGMV2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757AbYGMV2Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 17:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755122AbYGMV2B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 17:28:01 -0400
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:26295 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752922AbYGMV2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 17:28:00 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=kYC+86tB9yCVvbFBD8Szt8/a4uWwrJjuPkIyrsl+PuqtDhOOCwIL+2cNfs+P/igG6DHA9o63RQqiytbybOYrr0oiMYF8Q1SVZh6dcZERiUQihtGM9uWqQSXeTtyH/J8s3yPPSXE32yXWcbYfutOzSmQ8cegMPKdNV3fIwssZx3U=  ;
X-YMail-OSG: Q2BtsrUVM1mcnL33Q0j1VpaP9smwOmKzopK2texDMeuc85mgyqBz.wana5XLPp3nFChbeI7qZIIylWaK2vvx25aSxmyCtYuHeFaecufXlmCq99i7XduR5sDBvurbs9a9tM4-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 2.6.26-rc9] gpio: pcf857x, add lock and handle more chips
Date: Sun, 13 Jul 2008 14:27:58 -0700
User-Agent: KMail/1.9.9
Cc: lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807131427.58635.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Two small updates to the pcf857x driver:  (a) the max732[89] chips
are also second sources for the pcf8574/a, and (b) add a mutex to
prevent trashing the cached state.  Adding the lock is effectively
a bugfix, although it seems unlikely that anyone would have run
into the issue it protects against.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/gpio/Kconfig   |    5 +++--
 drivers/gpio/pcf857x.c |   33 +++++++++++++++++++++++++++++----
 2 files changed, 32 insertions(+), 6 deletions(-)

--- a/drivers/gpio/Kconfig	2008-07-13 13:42:29.000000000 -0700
+++ b/drivers/gpio/Kconfig	2008-07-13 14:25:55.000000000 -0700
@@ -79,7 +79,7 @@ config GPIO_PCA953X
 	  will be called pca953x.
 
 config GPIO_PCF857X
-	tristate "PCF857x, PCA857x, and PCA967x I2C GPIO expanders"
+	tristate "PCF857x, PCA{85,96}7x, and MAX732[89] I2C GPIO expanders"
 	depends on I2C
 	help
 	  Say yes here to provide access to most "quasi-bidirectional" I2C
@@ -88,7 +88,8 @@ config GPIO_PCF857X
 	  some of them.  Compatible models include:
 
 	  8 bits:   pcf8574, pcf8574a, pca8574, pca8574a,
-	            pca9670, pca9672, pca9674, pca9674a
+	            pca9670, pca9672, pca9674, pca9674a,
+	  	    max7328, max7329
 
 	  16 bits:  pcf8575, pcf8575c, pca8575,
 	            pca9671, pca9673, pca9675
--- a/drivers/gpio/pcf857x.c	2008-07-13 13:41:36.000000000 -0700
+++ b/drivers/gpio/pcf857x.c	2008-07-13 13:54:06.000000000 -0700
@@ -37,6 +37,8 @@ static const struct i2c_device_id pcf857
 	{ "pca9671", 16 },
 	{ "pca9673", 16 },
 	{ "pca9675", 16 },
+	{ "max7328", 8 },
+	{ "max7329", 8 },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, pcf857x_id);
@@ -56,6 +58,7 @@ MODULE_DEVICE_TABLE(i2c, pcf857x_id);
 struct pcf857x {
 	struct gpio_chip	chip;
 	struct i2c_client	*client;
+	struct mutex		lock;		/* protect 'out' */
 	unsigned		out;		/* software latch */
 };
 
@@ -66,9 +69,14 @@ struct pcf857x {
 static int pcf857x_input8(struct gpio_chip *chip, unsigned offset)
 {
 	struct pcf857x	*gpio = container_of(chip, struct pcf857x, chip);
+	int		status;
 
+	mutex_lock(&gpio->lock);
 	gpio->out |= (1 << offset);
-	return i2c_smbus_write_byte(gpio->client, gpio->out);
+	status = i2c_smbus_write_byte(gpio->client, gpio->out);
+	mutex_unlock(&gpio->lock);
+
+	return status;
 }
 
 static int pcf857x_get8(struct gpio_chip *chip, unsigned offset)
@@ -84,12 +92,17 @@ static int pcf857x_output8(struct gpio_c
 {
 	struct pcf857x	*gpio = container_of(chip, struct pcf857x, chip);
 	unsigned	bit = 1 << offset;
+	int		status;
 
+	mutex_lock(&gpio->lock);
 	if (value)
 		gpio->out |= bit;
 	else
 		gpio->out &= ~bit;
-	return i2c_smbus_write_byte(gpio->client, gpio->out);
+	status = i2c_smbus_write_byte(gpio->client, gpio->out);
+	mutex_unlock(&gpio->lock);
+
+	return status;
 }
 
 static void pcf857x_set8(struct gpio_chip *chip, unsigned offset, int value)
@@ -124,9 +137,14 @@ static int i2c_read_le16(struct i2c_clie
 static int pcf857x_input16(struct gpio_chip *chip, unsigned offset)
 {
 	struct pcf857x	*gpio = container_of(chip, struct pcf857x, chip);
+	int		status;
 
+	mutex_lock(&gpio->lock);
 	gpio->out |= (1 << offset);
-	return i2c_write_le16(gpio->client, gpio->out);
+	status = i2c_write_le16(gpio->client, gpio->out);
+	mutex_unlock(&gpio->lock);
+
+	return status;
 }
 
 static int pcf857x_get16(struct gpio_chip *chip, unsigned offset)
@@ -142,12 +160,17 @@ static int pcf857x_output16(struct gpio_
 {
 	struct pcf857x	*gpio = container_of(chip, struct pcf857x, chip);
 	unsigned	bit = 1 << offset;
+	int		status;
 
+	mutex_lock(&gpio->lock);
 	if (value)
 		gpio->out |= bit;
 	else
 		gpio->out &= ~bit;
-	return i2c_write_le16(gpio->client, gpio->out);
+	status = i2c_write_le16(gpio->client, gpio->out);
+	mutex_unlock(&gpio->lock);
+
+	return status;
 }
 
 static void pcf857x_set16(struct gpio_chip *chip, unsigned offset, int value)
@@ -173,6 +196,8 @@ static int pcf857x_probe(struct i2c_clie
 	if (!gpio)
 		return -ENOMEM;
 
+	mutex_init(&gpio->lock);
+
 	gpio->chip.base = pdata->gpio_base;
 	gpio->chip.can_sleep = 1;
 	gpio->chip.dev = &client->dev;
