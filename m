Return-Path: <linux-kernel-owner+w=401wt.eu-S1758321AbYBAT21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758321AbYBAT21 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 14:28:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758694AbYBAT1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 14:27:43 -0500
Received: from smtp110.sbc.mail.mud.yahoo.com ([68.142.198.209]:45601 "HELO
	smtp110.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755672AbYBAT1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 14:27:41 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=1JLU6OOnrG9gu7K71ujhAp11nkfHoQZ9Y6Se1oiUjlX1ex6KdIeZQ1r6Ocbfiy8KUuGczt1BcZz2nhIXqR3tJ5uzJ/MxBCIC65Fat+Okg807TTmIWFGH03KlKU/bUV2BfIhs41yoxUrEJU6grI03lDqTTma5mUdsa0nxYo8CWcI=  ;
X-YMail-OSG: nWWyDKsVM1mROELtMr72QR61iyWkRduaook9906w2p3O2eGb50YSlSdWIPm4D2sbSp3X8Ravvw--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 2.6.24-git + mm-gpiolib 3/3] gpio: handle pca953{4,5,6,7,8} too
Date: Fri, 1 Feb 2008 11:26:29 -0800
User-Agent: KMail/1.9.6
Cc: lkml <linux-kernel@vger.kernel.org>, eric miao <eric.y.miao@gmail.com>,
       Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802011126.29518.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>

This third part of an extension to support more pca953x chips
updates the logic to handle the smaller register widths used by
the 4-bit and 8-bit parts, and to use the chip type to determine
how many GPIOs it provides.

As long as we don't support interrupt and reset capabilities, those size
issues are the only software-visible differences between these parts.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/gpio/pca953x.c |   73 ++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 55 insertions(+), 18 deletions(-)

--- g26.orig/drivers/gpio/pca953x.c	2008-01-31 14:41:19.000000000 -0800
+++ g26/drivers/gpio/pca953x.c	2008-01-31 15:20:28.000000000 -0800
@@ -1,5 +1,5 @@
 /*
- *  pca953x.c - 16-bit I/O port with interrupt and reset
+ *  pca953x.c - 4/8/16 bit I/O ports
  *
  *  Copyright (C) 2005 Ben Gardner <bgardner@wabtec.com>
  *  Copyright (C) 2007 Marvell International Ltd.
@@ -18,13 +18,26 @@
 
 #include <asm/gpio.h>
 
+#define PCA953X_INPUT          0
+#define PCA953X_OUTPUT         1
+#define PCA953X_INVERT         2
+#define PCA953X_DIRECTION      3
+
+/* This is temporary - in 2.6.26 i2c_driver_data should replace it. */
+struct pca953x_desc {
+	char		name[I2C_NAME_SIZE];
+	unsigned long	driver_data;
+};
 
-#define NR_PCA953X_GPIOS	16
-
-#define PCA953X_INPUT		0
-#define PCA953X_OUTPUT		2
-#define PCA953X_INVERT		4
-#define PCA953X_DIRECTION	6
+static const struct pca953x_desc pca953x_descs[] = {
+	{ "pca9534", 8, },
+	{ "pca9535", 16, },
+	{ "pca9536", 4, },
+	{ "pca9537", 4, },
+	{ "pca9538", 8, },
+	{ "pca9539", 16, },
+	/* REVISIT several pca955x parts should work here too */
+};
 
 struct pca953x_chip {
 	unsigned gpio_start;
@@ -40,17 +53,30 @@ struct pca953x_chip {
  */
 static int pca953x_write_reg(struct pca953x_chip *chip, int reg, uint16_t val)
 {
-	if (i2c_smbus_write_word_data(chip->client, reg, val) < 0)
-		return -EIO;
+	int ret;
+
+	if (chip->gpio_chip.ngpio <= 8)
+		ret = i2c_smbus_write_byte_data(chip->client, reg, val);
 	else
-		return 0;
+		ret = i2c_smbus_write_word_data(chip->client, reg << 1, val);
+
+	if (ret < 0) {
+		dev_err(&chip->client->dev, "failed writing register\n");
+		return -EIO;
+	}
+
+	return 0;
 }
 
 static int pca953x_read_reg(struct pca953x_chip *chip, int reg, uint16_t *val)
 {
 	int ret;
 
-	ret = i2c_smbus_read_word_data(chip->client, reg);
+	if (chip->gpio_chip.ngpio <= 8)
+		ret = i2c_smbus_read_byte_data(chip->client, reg);
+	else
+		ret = i2c_smbus_read_word_data(chip->client, reg << 1);
+
 	if (ret < 0) {
 		dev_err(&chip->client->dev, "failed reading register\n");
 		return -EIO;
@@ -148,7 +174,7 @@ static void pca953x_gpio_set_value(struc
 	chip->reg_output = reg_val;
 }
 
-static int pca953x_init_gpio(struct pca953x_chip *chip)
+static void pca953x_setup_gpio(struct pca953x_chip *chip, int gpios)
 {
 	struct gpio_chip *gc;
 
@@ -160,22 +186,30 @@ static int pca953x_init_gpio(struct pca9
 	gc->set = pca953x_gpio_set_value;
 
 	gc->base = chip->gpio_start;
-	gc->ngpio = NR_PCA953X_GPIOS;
-	gc->label = "pca953x";
-
-	return gpiochip_add(gc);
+	gc->ngpio = gpios;
+	gc->label = chip->client->name;
 }
 
 static int __devinit pca953x_probe(struct i2c_client *client)
 {
 	struct pca953x_platform_data *pdata;
 	struct pca953x_chip *chip;
-	int ret;
+	int ret, i;
+	const struct pca953x_desc *id = NULL;
 
 	pdata = client->dev.platform_data;
 	if (pdata == NULL)
 		return -ENODEV;
 
+	/* this loop vanishes when we get i2c_device_id */
+	for (i = 0; i < ARRAY_SIZE(pca953x_descs); i++)
+		if (!strcmp(pca953x_descs[i].name, client->name)) {
+			id = pca953x_descs + i;
+			break;
+		}
+	if (!id)
+		return -ENODEV;
+
 	chip = kzalloc(sizeof(struct pca953x_chip), GFP_KERNEL);
 	if (chip == NULL)
 		return -ENOMEM;
@@ -187,6 +221,8 @@ static int __devinit pca953x_probe(struc
 	/* initialize cached registers from their original values.
 	 * we can't share this chip with another i2c master.
 	 */
+	pca953x_setup_gpio(chip, id->driver_data);
+
 	ret = pca953x_read_reg(chip, PCA953X_OUTPUT, &chip->reg_output);
 	if (ret)
 		goto out_failed;
@@ -200,7 +236,8 @@ static int __devinit pca953x_probe(struc
 	if (ret)
 		goto out_failed;
 
-	ret = pca953x_init_gpio(chip);
+
+	ret = gpiochip_add(&chip->gpio_chip);
 	if (ret)
 		goto out_failed;
 
