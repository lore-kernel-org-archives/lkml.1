Return-Path: <linux-kernel-owner+w=401wt.eu-S1754212AbZDTFXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212AbZDTFXR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 01:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753097AbZDTFXB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 01:23:01 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:44433 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbZDTFXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 01:23:00 -0400
Date: Mon, 20 Apr 2009 14:22:46 +0900
From: Kim Kyuwon <q1.kim@samsung.com>
Subject: Suggestion on GPIO sysfs interface (gpio_export)
To: LKML <linux-kernel@vger.kernel.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Greg KH <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>,
       =?windows-1252?Q?=22=3F=3F=3F=22?= <kyungmin.park@samsung.com>,
       chammoru@gmail.com
Message-id: <49EC06A6.4040506@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7BIT
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
X-OriginalArrivalTime: 20 Apr 2009 05:22:48.0203 (UTC)
 FILETIME=[0B073DB0:01C9C178]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

Exporting GPIOs by using gpio_export() is very useful to me.
But I want to access each GPIO by its name(or label) instead of
GPIO number, because GPIO label is more descriptive.

So I just modified gpio_export() to show the label information as shown below.
(This patch just shows the idea)

==
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 42fb2fd..392303d 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -363,7 +363,7 @@ static ssize_t export_store(struct class *class, const char *buf, size_t len)
 	if (status < 0)
 		goto done;
 
-	status = gpio_export(gpio, true);
+	status = gpio_export(gpio, true, false);
 	if (status < 0)
 		gpio_free(gpio);
 	else
@@ -422,6 +422,7 @@ static struct class gpio_class = {
  * gpio_export - export a GPIO through sysfs
  * @gpio: gpio to make available, already requested
  * @direction_may_change: true if userspace may change gpio direction
+ * @label_may_show: true if gpio label may show, instead of gpio number
  * Context: arch_initcall or later
  *
  * When drivers want to make a GPIO accessible to userspace after they
@@ -433,7 +434,7 @@ static struct class gpio_class = {
  *
  * Returns zero on success, else an error.
  */
-int gpio_export(unsigned gpio, bool direction_may_change)
+int gpio_export(unsigned gpio, bool direction_may_change, bool label_may_show)
 {
 	unsigned long		flags;
 	struct gpio_desc	*desc;
@@ -464,8 +465,15 @@ int gpio_export(unsigned gpio, bool direction_may_change)
 	if (status == 0) {
 		struct device	*dev;
 
-		dev = device_create(&gpio_class, desc->chip->dev, MKDEV(0, 0),
-					desc, "gpio%d", gpio);
+#ifdef CONFIG_DEBUG_FS
+		if (label_may_show && desc->label)
+			dev = device_create(&gpio_class, desc->chip->dev,
+				MKDEV(0, 0), desc, "%s", desc->label);
+		else
+#endif
+			dev = device_create(&gpio_class, desc->chip->dev,
+				MKDEV(0, 0), desc, "gpio%d", gpio);
+
 		if (dev) {
 			if (direction_may_change)
 				status = sysfs_create_group(&dev->kobj,
diff --git a/drivers/mfd/dm355evm_msp.c b/drivers/mfd/dm355evm_msp.c
index 7ac12cb..4a37ff1 100644
--- a/drivers/mfd/dm355evm_msp.c
+++ b/drivers/mfd/dm355evm_msp.c
@@ -304,7 +304,7 @@ static int add_children(struct i2c_client *client)
 		gpio_direction_input(gpio);
 
 		/* make it easy for userspace to see these */
-		gpio_export(gpio, false);
+		gpio_export(gpio, false, false);
 	}
 
 	/* MMC/SD inputs -- right after the last config input */
diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index 81797ec..9852da4 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -135,7 +135,8 @@ extern int __gpio_to_irq(unsigned gpio);
  * A sysfs interface can be exported by individual drivers if they want,
  * but more typically is configured entirely from userspace.
  */
-extern int gpio_export(unsigned gpio, bool direction_may_change);
+extern int gpio_export(unsigned gpio, bool direction_may_change,
+							bool label_may_show);
 extern void gpio_unexport(unsigned gpio);
 
 #endif	/* CONFIG_GPIO_SYSFS */
@@ -175,7 +176,8 @@ static inline void gpio_set_value_cansleep(unsigned gpio, int value)
 
 /* sysfs support is only available with gpiolib, where it's optional */
 
-static inline int gpio_export(unsigned gpio, bool direction_may_change)
+static inline int gpio_export(unsigned gpio, bool direction_may_change,
+							bool label_may_show)
 {
 	return -ENOSYS;
 }
diff --git a/include/linux/gpio.h b/include/linux/gpio.h
index e10c49a..1209149 100644
--- a/include/linux/gpio.h
+++ b/include/linux/gpio.h
@@ -82,7 +82,8 @@ static inline void gpio_set_value_cansleep(unsigned gpio, int value)
 	WARN_ON(1);
 }
 
-static inline int gpio_export(unsigned gpio, bool direction_may_change)
+static inline int gpio_export(unsigned gpio, bool direction_may_change,
+							bool label_may_show)
 {
 	/* GPIO can never have been requested or set as {in,out}put */
 	WARN_ON(1);
==

Can I ask you opinion about this idea?
If I get the positive answer, I will send the full patch set which
changes all board files and documentation related to gpio_export.

Regards,
Kim Kyuwon


