Return-Path: <linux-kernel-owner+w=401wt.eu-S1753736AbYJaCKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736AbYJaCKe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 22:10:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751866AbYJaCKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 22:10:25 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:55176 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbYJaCKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 22:10:24 -0400
From: Trent Piepho <tpiepho@freescale.com>
To: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Grant Likely <grant.likely@secretlab.ca>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Trent Piepho <tpiepho@freescale.com>
Subject: [PATCH v2] of_gpio: Return GPIO flags from of_get_gpio()
Date: Thu, 30 Oct 2008 19:03:09 -0700
Message-Id: <1225418589-8545-1-git-send-email-tpiepho@freescale.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <20081030111500.GB22008@oksana.dev.rtsoft.ru>
References: <20081030111500.GB22008@oksana.dev.rtsoft.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The device binding spec for OF GPIOs defines a flags field, but there is
currently no way to get it.  This patch adds a parameter to of_get_gpio()
where the flags will be returned if non-NULL.  of_get_gpio() in turn passes
the parameter to the of_gpio_chip's xlate method, which can extract any
flags present from the gpio_spec.

The default (and currently only) of_gpio_chip xlate method,
of_gpio_simple_xlate(), is modified to do this.

Signed-off-by: Trent Piepho <tpiepho@freescale.com>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
Acked-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
Since this patch changes an API, it would be nice to get it into powerpc-next
soon so that people who have new patches that use this API, like Anton, can
base off it.

 drivers/mtd/nand/fsl_upm.c              |    2 +-
 drivers/net/fs_enet/fs_enet-main.c      |    2 +-
 drivers/net/phy/mdio-ofgpio.c           |    4 ++--
 drivers/of/gpio.c                       |   13 ++++++++++---
 drivers/serial/cpm_uart/cpm_uart_core.c |    2 +-
 include/linux/of_gpio.h                 |   21 +++++++++++++++++----
 6 files changed, 32 insertions(+), 12 deletions(-)

diff --git a/drivers/mtd/nand/fsl_upm.c b/drivers/mtd/nand/fsl_upm.c
index 024e3ff..a25d962 100644
--- a/drivers/mtd/nand/fsl_upm.c
+++ b/drivers/mtd/nand/fsl_upm.c
@@ -218,7 +218,7 @@ static int __devinit fun_probe(struct of_device *ofdev,
 	}
 	fun->upm_cmd_offset = *prop;
 
-	fun->rnb_gpio = of_get_gpio(ofdev->node, 0);
+	fun->rnb_gpio = of_get_gpio(ofdev->node, 0, NULL);
 	if (fun->rnb_gpio >= 0) {
 		ret = gpio_request(fun->rnb_gpio, ofdev->dev.bus_id);
 		if (ret) {
diff --git a/drivers/net/fs_enet/fs_enet-main.c b/drivers/net/fs_enet/fs_enet-main.c
index cb51c1f..5a3c7ee 100644
--- a/drivers/net/fs_enet/fs_enet-main.c
+++ b/drivers/net/fs_enet/fs_enet-main.c
@@ -994,7 +994,7 @@ static int __devinit find_phy(struct device_node *np,
 		goto out_put_phy;
 	}
 
-	bus_id = of_get_gpio(mdionode, 0);
+	bus_id = of_get_gpio(mdionode, 0, NULL);
 	if (bus_id < 0) {
 		struct resource res;
 		ret = of_address_to_resource(mdionode, 0, &res);
diff --git a/drivers/net/phy/mdio-ofgpio.c b/drivers/net/phy/mdio-ofgpio.c
index 2ff9775..e3757c6 100644
--- a/drivers/net/phy/mdio-ofgpio.c
+++ b/drivers/net/phy/mdio-ofgpio.c
@@ -78,8 +78,8 @@ static int __devinit mdio_ofgpio_bitbang_init(struct mii_bus *bus,
 {
 	struct mdio_gpio_info *bitbang = bus->priv;
 
-	bitbang->mdc = of_get_gpio(np, 0);
-	bitbang->mdio = of_get_gpio(np, 1);
+	bitbang->mdc = of_get_gpio(np, 0, NULL);
+	bitbang->mdio = of_get_gpio(np, 1, NULL);
 
 	if (bitbang->mdc < 0 || bitbang->mdio < 0)
 		return -ENODEV;
diff --git a/drivers/of/gpio.c b/drivers/of/gpio.c
index 7cd7301..ae14215 100644
--- a/drivers/of/gpio.c
+++ b/drivers/of/gpio.c
@@ -22,11 +22,12 @@
  * of_get_gpio - Get a GPIO number from the device tree to use with GPIO API
  * @np:		device node to get GPIO from
  * @index:	index of the GPIO
+ * @flags:	GPIO's flags are returned here if non-NULL
  *
  * Returns GPIO number to use with Linux generic GPIO API, or one of the errno
  * value on the error condition.
  */
-int of_get_gpio(struct device_node *np, int index)
+int of_get_gpio(struct device_node *np, int index, enum of_gpio_flags *flags)
 {
 	int ret;
 	struct device_node *gc;
@@ -59,7 +60,9 @@ int of_get_gpio(struct device_node *np, int index)
 		goto err1;
 	}
 
-	ret = of_gc->xlate(of_gc, np, gpio_spec);
+	if (flags)
+		*flags = 0;
+	ret = of_gc->xlate(of_gc, np, gpio_spec, flags);
 	if (ret < 0)
 		goto err1;
 
@@ -77,19 +80,23 @@ EXPORT_SYMBOL(of_get_gpio);
  * @of_gc:	pointer to the of_gpio_chip structure
  * @np:		device node of the GPIO chip
  * @gpio_spec:	gpio specifier as found in the device tree
+ * @flags:	if non-NULL flags are returned here
  *
  * This is simple translation function, suitable for the most 1:1 mapped
  * gpio chips. This function performs only one sanity check: whether gpio
  * is less than ngpios (that is specified in the gpio_chip).
  */
 int of_gpio_simple_xlate(struct of_gpio_chip *of_gc, struct device_node *np,
-			 const void *gpio_spec)
+			 const void *gpio_spec, enum of_gpio_flags *flags)
 {
 	const u32 *gpio = gpio_spec;
 
 	if (*gpio > of_gc->gc.ngpio)
 		return -EINVAL;
 
+	if (flags && of_gc->gpio_cells > 1)
+		*flags = gpio[1];
+
 	return *gpio;
 }
 EXPORT_SYMBOL(of_gpio_simple_xlate);
diff --git a/drivers/serial/cpm_uart/cpm_uart_core.c b/drivers/serial/cpm_uart/cpm_uart_core.c
index bde4b4b..7835cd4 100644
--- a/drivers/serial/cpm_uart/cpm_uart_core.c
+++ b/drivers/serial/cpm_uart/cpm_uart_core.c
@@ -1094,7 +1094,7 @@ static int cpm_uart_init_port(struct device_node *np,
 	}
 
 	for (i = 0; i < NUM_GPIOS; i++)
-		pinfo->gpios[i] = of_get_gpio(np, i);
+		pinfo->gpios[i] = of_get_gpio(np, i, NULL);
 
 	return cpm_uart_request_port(&pinfo->port);
 
diff --git a/include/linux/of_gpio.h b/include/linux/of_gpio.h
index 67db101..d611746 100644
--- a/include/linux/of_gpio.h
+++ b/include/linux/of_gpio.h
@@ -20,13 +20,23 @@
 #ifdef CONFIG_OF_GPIO
 
 /*
+ * Flags as returned by OF GPIO chip's xlate method.
+ * The GPIO specifier in the OF device tree does not need to use this
+ * same format for its flags, but it's convenient if it does.  For
+ * example, the of_mm_gpio_chip driver works this way.
+ */
+enum of_gpio_flags {
+	OF_GPIO_ACTIVE_LOW = 1,
+};
+
+/*
  * Generic OF GPIO chip
  */
 struct of_gpio_chip {
 	struct gpio_chip gc;
 	int gpio_cells;
 	int (*xlate)(struct of_gpio_chip *of_gc, struct device_node *np,
-		     const void *gpio_spec);
+		     const void *gpio_spec, enum of_gpio_flags *flags);
 };
 
 static inline struct of_gpio_chip *to_of_gpio_chip(struct gpio_chip *gc)
@@ -50,16 +60,19 @@ static inline struct of_mm_gpio_chip *to_of_mm_gpio_chip(struct gpio_chip *gc)
 	return container_of(of_gc, struct of_mm_gpio_chip, of_gc);
 }
 
-extern int of_get_gpio(struct device_node *np, int index);
+extern int of_get_gpio(struct device_node *np, int index,
+		       enum of_gpio_flags *flags);
 extern int of_mm_gpiochip_add(struct device_node *np,
 			      struct of_mm_gpio_chip *mm_gc);
 extern int of_gpio_simple_xlate(struct of_gpio_chip *of_gc,
 				struct device_node *np,
-				const void *gpio_spec);
+				const void *gpio_spec,
+				enum of_gpio_flags *flags);
 #else
 
 /* Drivers may not strictly depend on the GPIO support, so let them link. */
-static inline int of_get_gpio(struct device_node *np, int index)
+static inline int of_get_gpio(struct device_node *np, int index,
+			      enum of_gpio_flags *flags)
 {
 	return -ENOSYS;
 }
-- 
1.5.4.3

