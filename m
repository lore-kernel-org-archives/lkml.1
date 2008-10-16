Return-Path: <linux-kernel-owner+w=401wt.eu-S1756616AbYJPRPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616AbYJPRPl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:15:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755186AbYJPRNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:13:14 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:7156 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752920AbYJPRNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:13:12 -0400
Date: Thu, 16 Oct 2008 21:13:09 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       "Steven A. Falco" <sfalco@harris.com>,
       Grant Likely <grant.likely@secretlab.ca>,
       Jean Delvare <khali@linux-fr.org>, David Miller <davem@davemloft.net>,
       i2c@lm-sensors.org, linuxppc-dev@ozlabs.org
Subject: [PATCH 7/7] i2c/mcu_mpc8349emitx: convert to the new I2C/OF/GPIO
	infrastructure
Message-ID: <20081016171309.GG5515@oksana.dev.rtsoft.ru>
References: <20081016171222.GA24812@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <20081016171222.GA24812@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the new subsystem it's much easier to handle I2C GPIO controllers.
Now drivers don't need to deal with the OF-specific bits.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/i2c/chips/mcu_mpc8349emitx.c |   65 ++++++---------------------------
 1 files changed, 12 insertions(+), 53 deletions(-)

diff --git a/drivers/i2c/chips/mcu_mpc8349emitx.c b/drivers/i2c/chips/mcu_mpc8349emitx.c
index 82a9bcb..985a1a4 100644
--- a/drivers/i2c/chips/mcu_mpc8349emitx.c
+++ b/drivers/i2c/chips/mcu_mpc8349emitx.c
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
@@ -75,52 +72,6 @@ static int mcu_gpio_dir_out(struct gpio_chip *gc, unsigned int gpio, int val)
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
@@ -140,7 +91,15 @@ static int __devinit mcu_probe(struct i2c_client *client,
 		goto err;
 	mcu->reg_ctrl = ret;
 
-	ret = mcu_gpiochip_add(mcu);
+	mcu->gc.owner = THIS_MODULE;
+	mcu->gc.label = client->dev.bus_id;
+	mcu->gc.can_sleep = 1;
+	mcu->gc.ngpio = MCU_NUM_GPIO;
+	mcu->gc.base = -1;
+	mcu->gc.set = mcu_gpio_set;
+	mcu->gc.direction_output = mcu_gpio_dir_out;
+
+	ret = dev_gpiochip_add(&client->dev, &mcu->gc);
 	if (ret)
 		goto err;
 
@@ -167,7 +126,7 @@ static int __devexit mcu_remove(struct i2c_client *client)
 		glob_mcu = NULL;
 	}
 
-	ret = mcu_gpiochip_remove(mcu);
+	ret = dev_gpiochip_remove(&client->dev, &mcu->gc);
 	if (ret)
 		return ret;
 	i2c_set_clientdata(client, NULL);
-- 
1.5.6.3
