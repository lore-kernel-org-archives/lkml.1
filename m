Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757390Ab0BEUcq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 15:32:46 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:43955 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933363Ab0BEUcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 15:32:41 -0500
Date: Fri, 5 Feb 2010 23:32:39 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Grant Likely <grant.likely@secretlab.ca>,
       David Brownell <dbrownell@users.sourceforge.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Bill Gatliff <bgat@billgatliff.com>,
       Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] powerpc/mcu_mpc8349emitx: Remove OF GPIO handling stuff
Message-ID: <20100205203239.GD1475@oksana.dev.rtsoft.ru>
References: <20100205203201.GA32281@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100205203201.GA32281@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the new OF GPIO infrastructure it's much easier to handle I2C
GPIO controllers, i.e. now drivers don't have to deal with the
OF-specific bits.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c |   68 +++++-------------------
 1 files changed, 14 insertions(+), 54 deletions(-)

diff --git a/arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c b/arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c
index 73c7e6b..5525175 100644
--- a/arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c
+++ b/arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c
@@ -18,8 +18,6 @@
 #include <linux/mutex.h>
 #include <linux/i2c.h>
 #include <linux/gpio.h>
-#include <linux/of.h>
-#include <linux/of_gpio.h>
 #include <asm/prom.h>
 #include <asm/machdep.h>
 
@@ -36,7 +34,7 @@ struct mcu {
 	struct mutex lock;
 	struct device_node *np;
 	struct i2c_client *client;
-	struct of_gpio_chip of_gc;
+	struct gpio_chip gc;
 	u8 reg_ctrl;
 };
 
@@ -55,8 +53,7 @@ static void mcu_power_off(void)
 
 static void mcu_gpio_set(struct gpio_chip *gc, unsigned int gpio, int val)
 {
-	struct of_gpio_chip *of_gc = to_of_gpio_chip(gc);
-	struct mcu *mcu = container_of(of_gc, struct mcu, of_gc);
+	struct mcu *mcu = container_of(gc, struct mcu, gc);
 	u8 bit = 1 << (4 + gpio);
 
 	mutex_lock(&mcu->lock);
@@ -75,53 +72,6 @@ static int mcu_gpio_dir_out(struct gpio_chip *gc, unsigned int gpio, int val)
 	return 0;
 }
 
-static int mcu_gpiochip_add(struct mcu *mcu)
-{
-	struct device_node *np;
-	struct of_gpio_chip *of_gc = &mcu->of_gc;
-	struct gpio_chip *gc = &of_gc->gc;
-	int ret;
-
-	np = of_find_compatible_node(NULL, NULL, "fsl,mcu-mpc8349emitx");
-	if (!np)
-		return -ENODEV;
-
-	gc->owner = THIS_MODULE;
-	gc->label = np->full_name;
-	gc->can_sleep = 1;
-	gc->ngpio = MCU_NUM_GPIO;
-	gc->base = -1;
-	gc->set = mcu_gpio_set;
-	gc->direction_output = mcu_gpio_dir_out;
-	of_gc->chip = gc;
-	of_gc->gpio_cells = 2;
-	of_gc->xlate = of_gpio_simple_xlate;
-
-	np->data = of_gc;
-	mcu->np = np;
-
-	/*
-	 * We don't want to lose the node, its ->data and ->full_name...
-	 * So, if succeeded, we don't put the node here.
-	 */
-	ret = gpiochip_add(gc);
-	if (ret)
-		of_node_put(np);
-	return ret;
-}
-
-static int mcu_gpiochip_remove(struct mcu *mcu)
-{
-	int ret;
-
-	ret = gpiochip_remove(&mcu->of_gc.gc);
-	if (ret)
-		return ret;
-	of_node_put(mcu->np);
-
-	return 0;
-}
-
 static int __devinit mcu_probe(struct i2c_client *client,
 			       const struct i2c_device_id *id)
 {
@@ -141,7 +91,16 @@ static int __devinit mcu_probe(struct i2c_client *client,
 		goto err;
 	mcu->reg_ctrl = ret;
 
-	ret = mcu_gpiochip_add(mcu);
+	mcu->gc.dev = &client->dev;
+	mcu->gc.owner = THIS_MODULE;
+	mcu->gc.label = dev_name(&client->dev);
+	mcu->gc.can_sleep = 1;
+	mcu->gc.ngpio = MCU_NUM_GPIO;
+	mcu->gc.base = -1;
+	mcu->gc.set = mcu_gpio_set;
+	mcu->gc.direction_output = mcu_gpio_dir_out;
+
+	ret = gpiochip_add(&mcu->gc);
 	if (ret)
 		goto err;
 
@@ -168,9 +127,10 @@ static int __devexit mcu_remove(struct i2c_client *client)
 		glob_mcu = NULL;
 	}
 
-	ret = mcu_gpiochip_remove(mcu);
+	ret = gpiochip_remove(&mcu->gc);
 	if (ret)
 		return ret;
+
 	i2c_set_clientdata(client, NULL);
 	kfree(mcu);
 	return 0;
-- 
1.6.5.7
