Return-Path: <linux-kernel-owner+w=401wt.eu-S1758239AbYFVVP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758239AbYFVVP2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 17:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756324AbYFVVOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 17:14:10 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:57495 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756070AbYFVVOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 17:14:07 -0400
Message-Id: <20080622211406.267909778@fluff.org.uk>
References: <20080622211247.734979275@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Sun, 22 Jun 2008 22:12:51 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org
Cc: arnaud.patard@rtp-net.org, akpm@linux-foundation.org,
       Ben Dooks <ben-linux@fluff.org>
Subject: [patch 4/4] SM501: GPIO I2C support
Content-Disposition: inline; filename=simtec/simtec-drivers-mfd-sm501-gpio-i2c.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for adding the GPIO based I2C resources.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.26-rc6-quilt3/drivers/mfd/sm501.c
===================================================================
--- linux-2.6.26-rc6-quilt3.orig/drivers/mfd/sm501.c	2008-06-22 20:18:23.000000000 +0100
+++ linux-2.6.26-rc6-quilt3/drivers/mfd/sm501.c	2008-06-22 20:19:07.000000000 +0100
@@ -20,6 +20,7 @@
 #include <linux/platform_device.h>
 #include <linux/pci.h>
 #include <linux/gpio.h>
+#include <linux/i2c-gpio.h>
 
 #include <linux/sm501.h>
 #include <linux/sm501-regs.h>
@@ -1086,6 +1087,11 @@ static void sm501_gpio_remove(struct sm5
 		dev_err(sm->dev, "cannot remove high chip, cannot tidy up\n");
 }
 
+static int sm501_gpio_pin2nr(struct sm501_devdata *sm, unsigned int pin)
+{
+	struct sm501_gpio *gpio = &sm->gpio;
+	return pin + (pin < 32) ? gpio->low.gpio.base : gpio->high.gpio.base;
+}
 #else
 static int sm501_register_gpio(struct sm501_devdata *sm)
 {
@@ -1095,8 +1101,66 @@ static int sm501_register_gpio(struct sm
 static void sm501_gpio_remove(struct sm501_devdata *sm)
 {
 }
+
+static int sm501_gpio_pin2nr(struct sm501_devdata *sm, unsigned int pin)
+{
+	return -1;
+}
 #endif
 
+static int sm501_register_gpio_i2c_instance(struct sm501_devdata *sm,
+					    struct sm501_platdata_gpio_i2c *iic)
+{
+	struct i2c_gpio_platform_data *icd;
+	struct platform_device *pdev;
+
+	pdev = sm501_create_subdev(sm, "i2c-gpio", 0,
+				   sizeof(struct i2c_gpio_platform_data));
+	if (!pdev)
+		return -ENOMEM;
+
+	icd = pdev->dev.platform_data;
+
+	/* We keep the pin_sda and pin_scl fields relative in case the
+	 * same platform data is passed to >1 SM501.
+	 */
+
+	icd->sda_pin = sm501_gpio_pin2nr(sm, iic->pin_sda);
+	icd->scl_pin = sm501_gpio_pin2nr(sm, iic->pin_scl);
+	icd->timeout = iic->timeout;
+	icd->udelay = iic->udelay;
+
+	/* note, we can't use either of the pin numbers, as the i2c-gpio
+	 * driver uses the platform.id field to generate the bus number
+	 * to register with the i2c core; The i2c core doesn't have enough
+	 * entries to deal with anything we currently use.
+	*/
+
+	pdev->id = iic->bus_num;
+
+	dev_info(sm->dev, "registering i2c-%d: sda=%d (%d), scl=%d (%d)\n",
+		 iic->bus_num,
+		 icd->sda_pin, iic->pin_sda, icd->scl_pin, iic->pin_scl);
+
+	return sm501_register_device(sm, pdev);
+}
+
+static int sm501_register_gpio_i2c(struct sm501_devdata *sm,
+				   struct sm501_platdata *pdata)
+{
+	struct sm501_platdata_gpio_i2c *iic = pdata->gpio_i2c;
+	int index;
+	int ret;
+
+	for (index = 0; index < pdata->gpio_i2c_nr; index++, iic++) {
+		ret = sm501_register_gpio_i2c_instance(sm, iic);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
 /* sm501_dbg_regs
  *
  * Debug attribute to attach to parent device to show core registers
@@ -1204,6 +1268,7 @@ static unsigned int sm501_mem_local[] = 
 static int sm501_init_dev(struct sm501_devdata *sm)
 {
 	struct sm501_initdata *idata;
+	struct sm501_platdata *pdata;
 	resource_size_t mem_avail;
 	unsigned long dramctrl;
 	unsigned long devid;
@@ -1242,7 +1307,9 @@ static int sm501_init_dev(struct sm501_d
 
 	/* check to see if we have some device initialisation */
 
-	idata = sm->platdata ? sm->platdata->init : NULL;
+	pdata = sm->platdata;
+	idata = pdata ? pdata->init : NULL;
+
 	if (idata) {
 		sm501_init_regs(sm, idata);
 
@@ -1254,6 +1321,13 @@ static int sm501_init_dev(struct sm501_d
 			sm501_register_gpio(sm);
 	}
 
+	if (pdata->gpio_i2c != NULL && pdata->gpio_i2c_nr > 0) {
+		if (!sm->gpio.registered)
+			dev_err(sm->dev, "no gpio registered for i2c gpio.\n");
+		else
+			sm501_register_gpio_i2c(sm, pdata);
+	}
+
 	ret = sm501_check_clocks(sm);
 	if (ret) {
 		dev_err(sm->dev, "M1X and M clocks sourced from different "
Index: linux-2.6.26-rc6-quilt3/include/linux/sm501.h
===================================================================
--- linux-2.6.26-rc6-quilt3.orig/include/linux/sm501.h	2008-06-22 20:18:23.000000000 +0100
+++ linux-2.6.26-rc6-quilt3/include/linux/sm501.h	2008-06-22 20:19:01.000000000 +0100
@@ -86,11 +86,19 @@ struct sm501_platdata_fb {
 	struct sm501_platdata_fbsub	*fb_pnl;
 };
 
-/* gpio i2c */
+/* gpio i2c
+ *
+ * Note, we have to pass in the bus number, as the number used will be
+ * passed to the i2c-gpio driver's platform_device.id, subsequently used
+ * to register the i2c bus.
+*/
 
 struct sm501_platdata_gpio_i2c {
+	unsigned int		bus_num;
 	unsigned int		pin_sda;
 	unsigned int		pin_scl;
+	int			udelay;
+	int			timeout;
 };
 
 /* sm501_initdata

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
