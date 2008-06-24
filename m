Return-Path: <linux-kernel-owner+w=401wt.eu-S1758897AbYFXWAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758897AbYFXWAx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 18:00:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754961AbYFXWAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 18:00:44 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:64373 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754856AbYFXWAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 18:00:43 -0400
Subject: SM501: Fixes for akpms comments on gpiolib addition.
Message-Id: <20080624220037.356265849@fluff.org.uk>
User-Agent: quilt/0.46-1
From: Ben Dooks <ben-linux@fluff.org>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Ben Dooks <ben-linux@fluff.org>
Content-Disposition: inline; filename=simtec/simtec-drivers-mfd-sm501-akpmfixes1.patch
Date: Tue, 24 Jun 2008 23:00:37 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixup the comments from the patch that added the gpiolib
support from Andrew Morton. These include spotting some
missing frees on error or release, and changing a memcpy
for a type-safe assingment.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.26-rc7-quilt1/drivers/mfd/sm501.c
===================================================================
--- linux-2.6.26-rc7-quilt1.orig/drivers/mfd/sm501.c	2008-06-24 22:53:32.000000000 +0100
+++ linux-2.6.26-rc7-quilt1/drivers/mfd/sm501.c	2008-06-24 22:57:33.000000000 +0100
@@ -999,7 +999,7 @@ static int __devinit sm501_gpio_register
 	struct gpio_chip *gchip = &chip->gpio;
 	int base = pdata->gpio_base;
 
-	memcpy(chip, &gpio_chip_template, sizeof(struct gpio_chip));
+	chip->gpio = gpio_chip_template;
 
 	if (chip == &gpio->high) {
 		if (base > 0)
@@ -1039,7 +1039,7 @@ static int sm501_register_gpio(struct sm
 	if (gpio->regs == NULL) {
 		dev_err(sm->dev, "gpio: failed to remap registers\n");
 		ret = -ENXIO;
-		goto err_mapped;
+		goto err_claimed;
 	}
 
 	/* Register both our chips. */
@@ -1068,6 +1068,9 @@ static int sm501_register_gpio(struct sm
 	}
 
  err_mapped:
+	iounmap(gpio->regs);
+
+ err_claimed:
 	release_resource(gpio->regs_res);
 	kfree(gpio->regs_res);
 
@@ -1076,33 +1079,38 @@ static int sm501_register_gpio(struct sm
 
 static void sm501_gpio_remove(struct sm501_devdata *sm)
 {
+	struct sm501_gpio *gpio = &sm->gpio;
 	int ret;
 
-	ret = gpiochip_remove(&sm->gpio.low.gpio);
+	ret = gpiochip_remove(&gpio->low.gpio);
 	if (ret)
 		dev_err(sm->dev, "cannot remove low chip, cannot tidy up\n");
 
-	ret = gpiochip_remove(&sm->gpio.high.gpio);
+	ret = gpiochip_remove(&gpio->high.gpio);
 	if (ret)
 		dev_err(sm->dev, "cannot remove high chip, cannot tidy up\n");
+
+	iounmap(gpio->regs);
+	release_resource(gpio->regs_res);
+	kfree(gpio->regs_res);
 }
 
-static int sm501_gpio_pin2nr(struct sm501_devdata *sm, unsigned int pin)
+static inline int sm501_gpio_pin2nr(struct sm501_devdata *sm, unsigned int pin)
 {
 	struct sm501_gpio *gpio = &sm->gpio;
 	return pin + (pin < 32) ? gpio->low.gpio.base : gpio->high.gpio.base;
 }
 #else
-static int sm501_register_gpio(struct sm501_devdata *sm)
+static inline int sm501_register_gpio(struct sm501_devdata *sm)
 {
 	return 0;
 }
 
-static void sm501_gpio_remove(struct sm501_devdata *sm)
+static inline void sm501_gpio_remove(struct sm501_devdata *sm)
 {
 }
 
-static int sm501_gpio_pin2nr(struct sm501_devdata *sm, unsigned int pin)
+static inline int sm501_gpio_pin2nr(struct sm501_devdata *sm, unsigned int pin)
 {
 	return -1;
 }

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
