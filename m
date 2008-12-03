Return-Path: <linux-kernel-owner+w=401wt.eu-S1755253AbYLCV3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253AbYLCV3g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 16:29:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752920AbYLCV3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 16:29:11 -0500
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:38940 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752848AbYLCV3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 16:29:09 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=wHOPxa/l5BtbtRQlMdFjOlROBunqOD3Z9EyrvUTZmEoZ34E/6lO8y0DHe6D/3I5BtZ3fEIpb5lW2mzFJQT3rn4Dnzs33tIou8sUyy+tHNyZKWnxAae2iWN6+sg9+SxW+Nb7r2Ieob+72q7XsUNoB6Z7sG3Uz/eGdYUjclGv9LKo=  ;
X-YMail-OSG: 0yy7IHgVM1menrRWs_igpdrmv59JcF1_BEfYWQdVuUgj3S5lBPPvB.f2cFay2wnX58mwz4rP0b3szba2V98T1lbg9sSGb7WWIugT5U4xq8qECSHXCY6JkF7G7uIFRHjD_.33rHYSrhd46CmHP4jqxa02b7FUacFgdEneMFZrusgtwzhEW19YvOaO8OPH
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 2.6.28-rc7] gpio: pca953x handles more chips, i2c fault codes
Date: Wed, 3 Dec 2008 13:29:04 -0800
User-Agent: KMail/1.9.10
Cc: Eric Miao <eric.y.miao@gmail.com>, lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812031329.04914.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Minor updates to the pca953x GPIO expander driver:  handle several
more compatible parts, and stop assuming that the I2C layer's return
codes are garbage (that's now been fixed).

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Eric Miao <eric.miao@marvell.com>
---
 drivers/gpio/Kconfig   |    7 ++++---
 drivers/gpio/pca953x.c |   12 +++++++-----
 2 files changed, 11 insertions(+), 8 deletions(-)

--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -95,7 +95,7 @@ config GPIO_MAX732X
 	  number for these GPIOs.
 
 config GPIO_PCA953X
-	tristate "PCA953x, PCA955x, and MAX7310 I/O ports"
+	tristate "PCA953x, PCA955x, TCA64xx, and MAX7310 I/O ports"
 	depends on I2C
 	help
 	  Say yes here to provide access to several register-oriented
@@ -104,9 +104,10 @@ config GPIO_PCA953X
 
 	  4 bits:	pca9536, pca9537
 
-	  8 bits:	max7310, pca9534, pca9538, pca9554, pca9557
+	  8 bits:	max7310, pca9534, pca9538, pca9554, pca9557,
+	  		tca6408
 
-	  16 bits:	pca9535, pca9539, pca9555
+	  16 bits:	pca9535, pca9539, pca9555, tca6416
 
 	  This driver can also be built as a module.  If so, the module
 	  will be called pca953x.
--- a/drivers/gpio/pca953x.c
+++ b/drivers/gpio/pca953x.c
@@ -33,7 +33,12 @@ static const struct i2c_device_id pca953
 	{ "pca9554", 8, },
 	{ "pca9555", 16, },
 	{ "pca9557", 8, },
+
 	{ "max7310", 8, },
+	{ "pca6107", 8, },
+	{ "tca6408", 8, },
+	{ "tca6416", 16, },
+	/* NYET:  { "tca6424", 24, }, */
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, pca953x_id);
@@ -47,9 +52,6 @@ struct pca953x_chip {
 	struct gpio_chip gpio_chip;
 };
 
-/* NOTE:  we can't currently rely on fault codes to come from SMBus
- * calls, so we map all errors to EIO here and return zero otherwise.
- */
 static int pca953x_write_reg(struct pca953x_chip *chip, int reg, uint16_t val)
 {
 	int ret;
@@ -61,7 +63,7 @@ static int pca953x_write_reg(struct pca9
 
 	if (ret < 0) {
 		dev_err(&chip->client->dev, "failed writing register\n");
-		return -EIO;
+		return ret;
 	}
 
 	return 0;
@@ -78,7 +80,7 @@ static int pca953x_read_reg(struct pca95
 
 	if (ret < 0) {
 		dev_err(&chip->client->dev, "failed reading register\n");
-		return -EIO;
+		return ret;
 	}
 
 	*val = (uint16_t)ret;
