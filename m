Return-Path: <linux-kernel-owner+w=401wt.eu-S1756365AbYJPROq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756365AbYJPROq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:14:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755093AbYJPRNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:13:06 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:7148 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755033AbYJPRNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:13:04 -0400
Date: Thu, 16 Oct 2008 21:13:03 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       "Steven A. Falco" <sfalco@harris.com>,
       Grant Likely <grant.likely@secretlab.ca>,
       Jean Delvare <khali@linux-fr.org>, David Miller <davem@davemloft.net>,
       i2c@lm-sensors.org, linuxppc-dev@ozlabs.org
Subject: [PATCH 5/7] of/gpio: implement of_dev_gpiochip_{add,remove} calls
Message-ID: <20081016171303.GE5515@oksana.dev.rtsoft.ru>
References: <20081016171222.GA24812@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <20081016171222.GA24812@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And let the gpiolib forward all dev_gpiochip_ calls to of_ versions, there
we can glue the gpiochips with the device tree.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 arch/powerpc/include/asm/gpio.h |    7 +++-
 drivers/of/gpio.c               |   75 +++++++++++++++++++++++++++++++++++++-
 include/linux/of_gpio.h         |    7 ++++
 3 files changed, 86 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/include/asm/gpio.h b/arch/powerpc/include/asm/gpio.h
index ea04632..92610b1 100644
--- a/arch/powerpc/include/asm/gpio.h
+++ b/arch/powerpc/include/asm/gpio.h
@@ -14,8 +14,13 @@
 #ifndef __ASM_POWERPC_GPIO_H
 #define __ASM_POWERPC_GPIO_H
 
-#include <linux/errno.h>
+/* Tell the gpiolib that we'll handle the dev_gpiochip_* calls. */
+#define __dev_gpiochip_add of_dev_gpiochip_add
+#define __dev_gpiochip_remove of_dev_gpiochip_remove
+
 #include <asm-generic/gpio.h>
+#include <linux/errno.h>
+#include <linux/of_gpio.h>
 
 #ifdef CONFIG_GPIOLIB
 
diff --git a/drivers/of/gpio.c b/drivers/of/gpio.c
index 7cd7301..b6f56af 100644
--- a/drivers/of/gpio.c
+++ b/drivers/of/gpio.c
@@ -12,12 +12,33 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/device.h>
 #include <linux/errno.h>
 #include <linux/io.h>
 #include <linux/of.h>
 #include <linux/of_gpio.h>
 #include <asm/prom.h>
 
+static struct gpio_chip *of_gc_to_gc(struct of_gpio_chip *of_gc)
+{
+	/*
+	 * Currently there are two ways to register OF GPIO controllers:
+	 *
+	 * 1. Allocating the of_gpio_chip structure and passing the
+	 *    &of_gc->gc pointer to the gpiochip_add. (Can use container_of
+	 *    to convert the gpio_chip to the of_gpio_chip.)
+	 *
+	 * 2. Allocating and registering the gpio_chip structure separately
+	 *    from the of_gpio_chip. (Since two allocations are separate,
+	 *    container_of won't work.)
+	 *
+	 * As time goes by we may kill the first option.
+	 */
+	if (of_gc->chip)
+		return of_gc->chip;
+	return &of_gc->gc;
+}
+
 /**
  * of_get_gpio - Get a GPIO number from the device tree to use with GPIO API
  * @np:		device node to get GPIO from
@@ -63,7 +84,7 @@ int of_get_gpio(struct device_node *np, int index)
 	if (ret < 0)
 		goto err1;
 
-	ret += of_gc->gc.base;
+	ret += of_gc_to_gc(of_gc)->base;
 err1:
 	of_node_put(gc);
 err0:
@@ -87,7 +108,7 @@ int of_gpio_simple_xlate(struct of_gpio_chip *of_gc, struct device_node *np,
 {
 	const u32 *gpio = gpio_spec;
 
-	if (*gpio > of_gc->gc.ngpio)
+	if (*gpio > of_gc_to_gc(of_gc)->ngpio)
 		return -EINVAL;
 
 	return *gpio;
@@ -161,3 +182,53 @@ err0:
 	return ret;
 }
 EXPORT_SYMBOL(of_mm_gpiochip_add);
+
+int of_dev_gpiochip_add(struct device *dev, struct gpio_chip *chip)
+{
+	struct device_node *np = dev_archdata_get_node(&dev->archdata);
+	struct of_gpio_chip *of_gc;
+	int ret;
+
+	if (!np || np->data)
+		return -EINVAL;
+
+	of_gc = kzalloc(sizeof(*of_gc), GFP_KERNEL);
+	if (!of_gc)
+		return -ENOMEM;
+	/*
+	 * NOTE: for simple cases we use the simple_xlate with 2 cells scheme.
+	 * You can always overwrite it with an exceptions list that would
+	 * match on of_device_is_compatible().
+	 */
+	of_gc->gpio_cells = 2;
+	of_gc->xlate = of_gpio_simple_xlate;
+
+	chip->dev = dev;
+	of_gc->chip = chip;
+	np->data = of_gc;
+
+	ret = gpiochip_add(chip);
+	if (ret)
+		goto err_gpiochip_add;
+	return 0;
+
+err_gpiochip_add:
+	np->data = NULL;
+	chip->dev = NULL;
+	kfree(of_gc);
+	return ret;
+}
+EXPORT_SYMBOL(of_dev_gpiochip_add);
+
+int of_dev_gpiochip_remove(struct device *dev, struct gpio_chip *chip)
+{
+	struct device_node *np = dev_archdata_get_node(&dev->archdata);
+	int ret;
+
+	ret = gpiochip_remove(chip);
+	if (ret)
+		return ret;
+	np->data = NULL;
+	return 0;
+}
+EXPORT_SYMBOL(of_dev_gpiochip_remove);
diff --git a/include/linux/of_gpio.h b/include/linux/of_gpio.h
index 67db101..273cd79 100644
--- a/include/linux/of_gpio.h
+++ b/include/linux/of_gpio.h
@@ -14,16 +14,21 @@
 #ifndef __LINUX_OF_GPIO_H
 #define __LINUX_OF_GPIO_H
 
+#include <linux/compiler.h>
 #include <linux/errno.h>
 #include <linux/gpio.h>
 
 #ifdef CONFIG_OF_GPIO
 
+struct device_node;
+struct device;
+
 /*
  * Generic OF GPIO chip
  */
 struct of_gpio_chip {
 	struct gpio_chip gc;
+	struct gpio_chip *chip;
 	int gpio_cells;
 	int (*xlate)(struct of_gpio_chip *of_gc, struct device_node *np,
 		     const void *gpio_spec);
@@ -53,6 +58,8 @@ static inline struct of_mm_gpio_chip *to_of_mm_gpio_chip(struct gpio_chip *gc)
 extern int of_get_gpio(struct device_node *np, int index);
 extern int of_mm_gpiochip_add(struct device_node *np,
 			      struct of_mm_gpio_chip *mm_gc);
+extern int of_dev_gpiochip_add(struct device *dev, struct gpio_chip *chip);
+extern int of_dev_gpiochip_remove(struct device *dev, struct gpio_chip *chip);
 extern int of_gpio_simple_xlate(struct of_gpio_chip *of_gc,
 				struct device_node *np,
 				const void *gpio_spec);
-- 
1.5.6.3

