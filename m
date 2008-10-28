Return-Path: <linux-kernel-owner+w=401wt.eu-S1754645AbYJ1RrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbYJ1RrV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 13:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753998AbYJ1RqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 13:46:19 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:57678 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753818AbYJ1RqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 13:46:18 -0400
Date: Tue, 28 Oct 2008 20:46:16 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Grant Likely <grant.likely@secretlab.ca>,
       David Brownell <david-b@pacbell.net>
Cc: benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>
Subject: [PATCH 4/6] of/gpio: add support for two-stage registration for
	the of_gpio_chips
Message-ID: <20081028174616.GD25349@oksana.dev.rtsoft.ru>
References: <20081028174532.GA23834@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <20081028174532.GA23834@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently there are two ways to register OF GPIO controllers:
1. Allocating the of_gpio_chip structure and passing the
   &of_gc->gc pointer to the gpiochip_add. (Can use container_of
   to convert the gpio_chip to the of_gpio_chip.)

2. Allocating and registering the gpio_chip structure separately
   from the of_gpio_chip. (Since two allocations are separate,
   container_of won't work.)

As time goes by we'll kill the first option.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/i2c/chips/mcu_mpc8349emitx.c |    1 +
 drivers/of/gpio.c                    |   21 +++++++++++++++++++--
 include/linux/of_gpio.h              |    5 +++++
 3 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/chips/mcu_mpc8349emitx.c b/drivers/i2c/chips/mcu_mpc8349emitx.c
index 82a9bcb..73c7e6b 100644
--- a/drivers/i2c/chips/mcu_mpc8349emitx.c
+++ b/drivers/i2c/chips/mcu_mpc8349emitx.c
@@ -93,6 +93,7 @@ static int mcu_gpiochip_add(struct mcu *mcu)
 	gc->base = -1;
 	gc->set = mcu_gpio_set;
 	gc->direction_output = mcu_gpio_dir_out;
+	of_gc->chip = gc;
 	of_gc->gpio_cells = 2;
 	of_gc->xlate = of_gpio_simple_xlate;
 
diff --git a/drivers/of/gpio.c b/drivers/of/gpio.c
index 7cd7301..8de478e 100644
--- a/drivers/of/gpio.c
+++ b/drivers/of/gpio.c
@@ -63,7 +63,7 @@ int of_get_gpio(struct device_node *np, int index)
 	if (ret < 0)
 		goto err1;
 
-	ret += of_gc->gc.base;
+	ret += of_gc->chip->base;
 err1:
 	of_node_put(gc);
 err0:
@@ -87,7 +87,7 @@ int of_gpio_simple_xlate(struct of_gpio_chip *of_gc, struct device_node *np,
 {
 	const u32 *gpio = gpio_spec;
 
-	if (*gpio > of_gc->gc.ngpio)
+	if (*gpio > of_gc->chip->ngpio)
 		return -EINVAL;
 
 	return *gpio;
@@ -122,6 +122,23 @@ int of_mm_gpiochip_add(struct device_node *np,
 	struct of_gpio_chip *of_gc = &mm_gc->of_gc;
 	struct gpio_chip *gc = &of_gc->gc;
 
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
+	 * As time goes by we'll kill the first option. For now just check
+	 * if it's "new-style" registration or "old-style" one.
+	 */
+	if (of_gc->chip)
+		gc = of_gc->chip;
+
 	gc->label = kstrdup(np->full_name, GFP_KERNEL);
 	if (!gc->label)
 		goto err0;
diff --git a/include/linux/of_gpio.h b/include/linux/of_gpio.h
index 67db101..3a8545c 100644
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
-- 
1.5.6.3

