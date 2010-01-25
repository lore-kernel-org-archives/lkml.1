Return-Path: <linux-kernel-owner+w=401wt.eu-S1754704Ab0AYSLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704Ab0AYSLX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 13:11:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754678Ab0AYSLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 13:11:19 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:51297 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754676Ab0AYSLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 13:11:14 -0500
Date: Mon, 25 Jan 2010 21:11:12 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Grant Likely <grant.likely@secretlab.ca>,
       David Brownell <dbrownell@users.sourceforge.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Bill Gatliff <bgat@billgatliff.com>,
       Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] of/gpio: Implement GPIOLIB notifier hooks
Message-ID: <20100125181112.GC13805@oksana.dev.rtsoft.ru>
References: <20100125180957.GA5380@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100125180957.GA5380@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements GPIOLIB notifier hooks, and thus makes device-enabled
GPIO chips (i.e. the ones that have gpio_chip->dev specified) automatically
attached to the OpenFirmware subsystem. Which means that now we can handle
I2C and SPI GPIO chips almost* transparently.

* "Almost" because some chips still require platform data, and for these
  chips OF-glue is still needed, though with this support the glue will
  be much smaller.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/of/Kconfig |    1 +
 drivers/of/gpio.c  |  100 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 101 insertions(+), 0 deletions(-)

diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
index d2fa27c..de9f987 100644
--- a/drivers/of/Kconfig
+++ b/drivers/of/Kconfig
@@ -5,6 +5,7 @@ config OF_DEVICE
 config OF_GPIO
 	def_bool y
 	depends on OF && (PPC_OF || MICROBLAZE) && GPIOLIB
+	select GPIOLIB_NOTIFIER
 	help
 	  OpenFirmware GPIO accessors
 
diff --git a/drivers/of/gpio.c b/drivers/of/gpio.c
index 12c4af0..9d8df77 100644
--- a/drivers/of/gpio.c
+++ b/drivers/of/gpio.c
@@ -13,6 +13,7 @@
 
 #include <linux/kernel.h>
 #include <linux/errno.h>
+#include <linux/notifier.h>
 #include <linux/io.h>
 #include <linux/of.h>
 #include <linux/of_gpio.h>
@@ -236,3 +237,102 @@ err0:
 	return ret;
 }
 EXPORT_SYMBOL(of_mm_gpiochip_add);
+
+/**
+ * of_gpiochip_register_simple - Register a chip with the OF GPIO subsystem
+ * @chip	pointer to a GPIO chip
+ * @np:		device node to register the GPIO chip with
+ *
+ * This function registers a GPIO chip with the OF infrastructure. It is
+ * assumed that the chip was previsously allocated and added to a generic
+ * GPIOLIB framework (using gpiochip_add() function).
+ *
+ * The `simple' name means that the chip is using simple two-cells scheme for
+ * the gpio-specifier.
+ */
+static int of_gpiochip_register_simple(struct gpio_chip *chip,
+				       struct device_node *np)
+{
+	struct of_gpio_chip *of_gc;
+
+	if (np->data) {
+		WARN_ON(1);
+		return -EBUSY;
+	}
+
+	of_gc = kzalloc(sizeof(*of_gc), GFP_KERNEL);
+	if (!of_gc)
+		return -ENOMEM;
+
+	of_gc->gpio_cells = 2;
+	of_gc->xlate = of_gpio_simple_xlate;
+	of_gc->chip = chip;
+	np->data = of_gc;
+	of_node_get(np);
+
+	return 0;
+}
+EXPORT_SYMBOL(of_gpiochip_register_simple);
+
+/**
+ * of_gpiochip_unregister - Unregister a GPIO chip
+ * @chip	pointer to a GPIO chip
+ * @np:		device node for which the GPIO chip was previously registered
+ *
+ * This function unregisters a GPIO chip that was previsously registered
+ * with of_gpiochip_register*().
+ */
+static int of_gpiochip_unregister(struct gpio_chip *chip,
+				  struct device_node *np)
+{
+	struct of_gpio_chip *of_gc = np->data;
+
+	if (!of_gc || of_gc->chip != chip) {
+		WARN_ON(1);
+		return -EINVAL;
+	}
+
+	np->data = NULL;
+	kfree(of_gc);
+	of_node_put(np);
+
+	return 0;
+}
+
+static int of_gpio_notify(struct notifier_block *nb, unsigned long msg,
+			  void *chip)
+{
+	struct gpio_chip *gc = chip;
+	struct device_node *np;
+	int ret = 0;
+
+	if (!gc->dev)
+		return NOTIFY_DONE;
+
+	np = dev_archdata_get_node(&gc->dev->archdata);
+	if (!np)
+		return NOTIFY_DONE;
+
+	switch (msg) {
+	case GPIO_NOTIFY_CHIP_ADDED:
+		ret = of_gpiochip_register_simple(gc, np);
+		break;
+	case GPIO_NOTIFY_CHIP_REMOVE:
+		ret = of_gpiochip_unregister(gc, np);
+		break;
+	default:
+		break;
+	}
+
+	return ret ? notifier_from_errno(ret) : NOTIFY_OK;
+}
+
+static struct notifier_block of_gpio_nb = {
+	.notifier_call = of_gpio_notify,
+};
+
+static int __init of_gpio_notifier_init(void)
+{
+	return blocking_notifier_chain_register(&gpio_notifier, &of_gpio_nb);
+}
+arch_initcall(of_gpio_notifier_init);
-- 
1.6.5.7

