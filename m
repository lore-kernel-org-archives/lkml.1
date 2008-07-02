Return-Path: <linux-kernel-owner+w=401wt.eu-S1763424AbYGBJWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763424AbYGBJWr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 05:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752943AbYGBJWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 05:22:39 -0400
Received: from hull.simtec.co.uk ([78.105.113.97]:57672 "EHLO
	ivanova.local.simtec.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752688AbYGBJWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 05:22:39 -0400
X-Greylist: delayed 2876 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Jul 2008 05:22:38 EDT
Message-Id: <20080702083429.070304181@fluff.org>
References: <20080702083428.963530966@fluff.org>
User-Agent: quilt/0.46-1
Date: Wed, 02 Jul 2008 09:34:29 +0100
From: Ben Dooks <ben-linux@fluff.org>
Cc: akpm@linux-foundation.org, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, lethal@linux-sh.org,
       Ben Dooks <ben-linux@fluff.org>
Subject: [patch 1/1] MFD: SM501 build fixes when CONFIG_MFD_SM501_GPIO unset.
Content-Disposition: inline; filename=simtec/simtec-drivers-mfd-sm501-gpiofix.patch
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the build problems if CONFIG_MFD_SM501_GPIO is not set,
which is generally when there is no gpiolib support available
as currently happens on x86 when building PCI SM501.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.26-rc8-quilt3/drivers/mfd/sm501.c
===================================================================
--- linux-2.6.26-rc8-quilt3.orig/drivers/mfd/sm501.c	2008-07-02 09:24:46.000000000 +0100
+++ linux-2.6.26-rc8-quilt3/drivers/mfd/sm501.c	2008-07-02 09:27:11.000000000 +0100
@@ -19,7 +19,6 @@
 #include <linux/device.h>
 #include <linux/platform_device.h>
 #include <linux/pci.h>
-#include <linux/gpio.h>
 #include <linux/i2c-gpio.h>
 
 #include <linux/sm501.h>
@@ -35,6 +34,9 @@ struct sm501_device {
 
 struct sm501_gpio;
 
+#ifdef CONFIG_MFD_SM501_GPIO
+#include <linux/gpio.h>
+
 struct sm501_gpio_chip {
 	struct gpio_chip	gpio;
 	struct sm501_gpio	*ourgpio;	/* to get back to parent. */
@@ -50,6 +52,11 @@ struct sm501_gpio {
 	void __iomem		*regs;
 	struct resource		*regs_res;
 };
+#else
+struct sm501_gpio {
+	/* no gpio support, empty definition for sm501_devdata. */
+};
+#endif
 
 struct sm501_devdata {
 	spinlock_t			 reg_lock;
@@ -1082,6 +1089,9 @@ static void sm501_gpio_remove(struct sm5
 	struct sm501_gpio *gpio = &sm->gpio;
 	int ret;
 
+	if (!sm->gpio.registered)
+		return;
+
 	ret = gpiochip_remove(&gpio->low.gpio);
 	if (ret)
 		dev_err(sm->dev, "cannot remove low chip, cannot tidy up\n");
@@ -1100,6 +1110,11 @@ static inline int sm501_gpio_pin2nr(stru
 	struct sm501_gpio *gpio = &sm->gpio;
 	return pin + (pin < 32) ? gpio->low.gpio.base : gpio->high.gpio.base;
 }
+
+static inline int sm501_gpio_isregistered(struct sm501_devdata *sm)
+{
+	return sm->gpio.registered;
+}
 #else
 static inline int sm501_register_gpio(struct sm501_devdata *sm)
 {
@@ -1114,6 +1129,11 @@ static inline int sm501_gpio_pin2nr(stru
 {
 	return -1;
 }
+
+static inline int sm501_gpio_isregistered(struct sm501_devdata *sm)
+{
+	return 0;
+}
 #endif
 
 static int sm501_register_gpio_i2c_instance(struct sm501_devdata *sm,
@@ -1330,8 +1350,8 @@ static int sm501_init_dev(struct sm501_d
 	}
 
 	if (pdata->gpio_i2c != NULL && pdata->gpio_i2c_nr > 0) {
-		if (!sm->gpio.registered)
-			dev_err(sm->dev, "no gpio registered for i2c gpio.\n");
+		if (!sm501_gpio_isregistered(sm))
+			dev_err(sm->dev, "no gpio available for i2c gpio.\n");
 		else
 			sm501_register_gpio_i2c(sm, pdata);
 	}
@@ -1643,8 +1663,7 @@ static void sm501_dev_remove(struct sm50
 
 	device_remove_file(sm->dev, &dev_attr_dbg_regs);
 
-	if (sm->gpio.registered)
-		sm501_gpio_remove(sm);
+	sm501_gpio_remove(sm);
 }
 
 static void sm501_pci_remove(struct pci_dev *dev)

-- 
