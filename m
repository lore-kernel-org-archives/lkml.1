Return-Path: <linux-kernel-owner+w=401wt.eu-S1758181AbXGILlF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758181AbXGILlF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 07:41:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757864AbXGILkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 07:40:36 -0400
Received: from tim.rpsys.net ([194.106.48.114]:54840 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757770AbXGILk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 07:40:29 -0400
Subject: [PATCH] leds: Convert from struct class_device to struct device
From: Richard Purdie <rpurdie@rpsys.net>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>
Content-Type: text/plain
Date: Mon, 09 Jul 2007 12:40:13 +0100
Message-Id: <1183981213.5757.33.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the LEDs class from struct class_device to struct device
since class_device is scheduled for removal.

Signed-off-by: Richard Purdie <rpurdie@rpsys.net>

[I've applied this patch to the LEDs for-mm branch for testing but will
work in any feedback] 

 drivers/leds/led-class.c     |   49 +++++++++++++++++++------------------------
 drivers/leds/led-triggers.c  |   13 ++++++-----
 drivers/leds/leds-locomo.c   |    2 -
 drivers/leds/leds.h          |    8 ++++---
 drivers/leds/ledtrig-timer.c |   49 ++++++++++++++++++++-----------------------
 include/linux/leds.h         |    3 --
 6 files changed, 59 insertions(+), 65 deletions(-)

diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index 3c17112..4211293 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -2,7 +2,7 @@
  * LED Class Core
  *
  * Copyright (C) 2005 John Lenz <lenz@cs.wisc.edu>
- * Copyright (C) 2005-2006 Richard Purdie <rpurdie@openedhand.com>
+ * Copyright (C) 2005-2007 Richard Purdie <rpurdie@openedhand.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -24,9 +24,10 @@
 
 static struct class *leds_class;
 
-static ssize_t led_brightness_show(struct class_device *dev, char *buf)
+static ssize_t led_brightness_show(struct device *dev, 
+		struct device_attribute *attr, char *buf)
 {
-	struct led_classdev *led_cdev = class_get_devdata(dev);
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
 	ssize_t ret = 0;
 
 	/* no lock needed for this */
@@ -36,10 +37,10 @@ static ssize_t led_brightness_show(struct class_device *dev, char *buf)
 	return ret;
 }
 
-static ssize_t led_brightness_store(struct class_device *dev,
-				const char *buf, size_t size)
+static ssize_t led_brightness_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
 {
-	struct led_classdev *led_cdev = class_get_devdata(dev);
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
 	ssize_t ret = -EINVAL;
 	char *after;
 	unsigned long state = simple_strtoul(buf, &after, 10);
@@ -56,10 +57,9 @@ static ssize_t led_brightness_store(struct class_device *dev,
 	return ret;
 }
 
-static CLASS_DEVICE_ATTR(brightness, 0644, led_brightness_show,
-			led_brightness_store);
+static DEVICE_ATTR(brightness, 0644, led_brightness_show, led_brightness_store);
 #ifdef CONFIG_LEDS_TRIGGERS
-static CLASS_DEVICE_ATTR(trigger, 0644, led_trigger_show, led_trigger_store);
+static DEVICE_ATTR(trigger, 0644, led_trigger_show, led_trigger_store);
 #endif
 
 /**
@@ -93,16 +93,15 @@ int led_classdev_register(struct device *parent, struct led_classdev *led_cdev)
 {
 	int rc;
 
-	led_cdev->class_dev = class_device_create(leds_class, NULL, 0,
-						parent, "%s", led_cdev->name);
-	if (unlikely(IS_ERR(led_cdev->class_dev)))
-		return PTR_ERR(led_cdev->class_dev);
+	led_cdev->dev = device_create(leds_class, parent, 0, "%s",
+					    led_cdev->name);
+	if (unlikely(IS_ERR(led_cdev->dev)))
+		return PTR_ERR(led_cdev->dev);
 
-	class_set_devdata(led_cdev->class_dev, led_cdev);
+	dev_set_drvdata(led_cdev->dev, led_cdev);
 
 	/* register the attributes */
-	rc = class_device_create_file(led_cdev->class_dev,
-				      &class_device_attr_brightness);
+	rc = device_create_file(led_cdev->dev, &dev_attr_brightness);
 	if (rc)
 		goto err_out;
 
@@ -114,8 +113,7 @@ int led_classdev_register(struct device *parent, struct led_classdev *led_cdev)
 #ifdef CONFIG_LEDS_TRIGGERS
 	rwlock_init(&led_cdev->trigger_lock);
 
-	rc = class_device_create_file(led_cdev->class_dev,
-				      &class_device_attr_trigger);
+	rc = device_create_file(led_cdev->dev, &dev_attr_trigger);
 	if (rc)
 		goto err_out_led_list;
 
@@ -123,18 +121,17 @@ int led_classdev_register(struct device *parent, struct led_classdev *led_cdev)
 #endif
 
 	printk(KERN_INFO "Registered led device: %s\n",
-			led_cdev->class_dev->class_id);
+			led_cdev->name);
 
 	return 0;
 
 #ifdef CONFIG_LEDS_TRIGGERS
 err_out_led_list:
-	class_device_remove_file(led_cdev->class_dev,
-				&class_device_attr_brightness);
+	device_remove_file(led_cdev->dev, &dev_attr_brightness);
 	list_del(&led_cdev->node);
 #endif
 err_out:
-	class_device_unregister(led_cdev->class_dev);
+	device_unregister(led_cdev->dev);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(led_classdev_register);
@@ -147,18 +144,16 @@ EXPORT_SYMBOL_GPL(led_classdev_register);
  */
 void led_classdev_unregister(struct led_classdev *led_cdev)
 {
-	class_device_remove_file(led_cdev->class_dev,
-				&class_device_attr_brightness);
+	device_remove_file(led_cdev->dev, &dev_attr_brightness);
 #ifdef CONFIG_LEDS_TRIGGERS
-	class_device_remove_file(led_cdev->class_dev,
-				&class_device_attr_trigger);
+	device_remove_file(led_cdev->dev, &dev_attr_trigger);
 	write_lock(&led_cdev->trigger_lock);
 	if (led_cdev->trigger)
 		led_trigger_set(led_cdev, NULL);
 	write_unlock(&led_cdev->trigger_lock);
 #endif
 
-	class_device_unregister(led_cdev->class_dev);
+	device_unregister(led_cdev->dev);
 
 	write_lock(&leds_list_lock);
 	list_del(&led_cdev->node);
diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
index b2438a0..7103d54 100644
--- a/drivers/leds/led-triggers.c
+++ b/drivers/leds/led-triggers.c
@@ -1,7 +1,7 @@
 /*
  * LED Triggers Core
  *
- * Copyright 2005-2006 Openedhand Ltd.
+ * Copyright 2005-2007 Openedhand Ltd.
  *
  * Author: Richard Purdie <rpurdie@openedhand.com>
  *
@@ -28,10 +28,10 @@
 static DEFINE_RWLOCK(triggers_list_lock);
 static LIST_HEAD(trigger_list);
 
-ssize_t led_trigger_store(struct class_device *dev, const char *buf,
-			size_t count)
+ssize_t led_trigger_store(struct device *dev, struct device_attribute *attr, 
+		const char *buf, size_t count)
 {
-	struct led_classdev *led_cdev = class_get_devdata(dev);
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
 	char trigger_name[TRIG_NAME_MAX];
 	struct led_trigger *trig;
 	size_t len;
@@ -67,9 +67,10 @@ ssize_t led_trigger_store(struct class_device *dev, const char *buf,
 }
 

-ssize_t led_trigger_show(struct class_device *dev, char *buf)
+ssize_t led_trigger_show(struct device *dev, struct device_attribute *attr, 
+		char *buf)
 {
-	struct led_classdev *led_cdev = class_get_devdata(dev);
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
 	struct led_trigger *trig;
 	int len = 0;
 
diff --git a/drivers/leds/leds-locomo.c b/drivers/leds/leds-locomo.c
index 6f2d449..bfac499 100644
--- a/drivers/leds/leds-locomo.c
+++ b/drivers/leds/leds-locomo.c
@@ -19,7 +19,7 @@
 static void locomoled_brightness_set(struct led_classdev *led_cdev,
 				enum led_brightness value, int offset)
 {
-	struct locomo_dev *locomo_dev = LOCOMO_DEV(led_cdev->class_dev->dev);
+	struct locomo_dev *locomo_dev = LOCOMO_DEV(led_cdev->dev);
 	unsigned long flags;
 
 	local_irq_save(flags);
diff --git a/drivers/leds/leds.h b/drivers/leds/leds.h
index a715c4e..53b2c85 100644
--- a/drivers/leds/leds.h
+++ b/drivers/leds/leds.h
@@ -13,6 +13,7 @@
 #ifndef __LEDS_H_INCLUDED
 #define __LEDS_H_INCLUDED
 
+#include <linux/device.h>
 #include <linux/leds.h>
 
 static inline void led_set_brightness(struct led_classdev *led_cdev,
@@ -37,8 +38,9 @@ void led_trigger_set(struct led_classdev *led_cdev,
 #define led_trigger_set(x, y) do {} while(0)
 #endif
 
-ssize_t led_trigger_store(struct class_device *dev, const char *buf,
-			size_t count);
-ssize_t led_trigger_show(struct class_device *dev, char *buf);
+ssize_t led_trigger_store(struct device *dev, struct device_attribute *attr, 
+			const char *buf, size_t count);
+ssize_t led_trigger_show(struct device *dev, struct device_attribute *attr, 
+			char *buf);
 
 #endif	/* __LEDS_H_INCLUDED */
diff --git a/drivers/leds/ledtrig-timer.c b/drivers/leds/ledtrig-timer.c
index d756bdb..ed9ff02 100644
--- a/drivers/leds/ledtrig-timer.c
+++ b/drivers/leds/ledtrig-timer.c
@@ -52,9 +52,10 @@ static void led_timer_function(unsigned long data)
 	mod_timer(&timer_data->timer, jiffies + msecs_to_jiffies(delay));
 }
 
-static ssize_t led_delay_on_show(struct class_device *dev, char *buf)
+static ssize_t led_delay_on_show(struct device *dev, 
+		struct device_attribute *attr, char *buf)
 {
-	struct led_classdev *led_cdev = class_get_devdata(dev);
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
 	struct timer_trig_data *timer_data = led_cdev->trigger_data;
 
 	sprintf(buf, "%lu\n", timer_data->delay_on);
@@ -62,10 +63,10 @@ static ssize_t led_delay_on_show(struct class_device *dev, char *buf)
 	return strlen(buf) + 1;
 }
 
-static ssize_t led_delay_on_store(struct class_device *dev, const char *buf,
-				size_t size)
+static ssize_t led_delay_on_store(struct device *dev, 
+		struct device_attribute *attr, const char *buf, size_t size)
 {
-	struct led_classdev *led_cdev = class_get_devdata(dev);
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
 	struct timer_trig_data *timer_data = led_cdev->trigger_data;
 	int ret = -EINVAL;
 	char *after;
@@ -84,9 +85,10 @@ static ssize_t led_delay_on_store(struct class_device *dev, const char *buf,
 	return ret;
 }
 
-static ssize_t led_delay_off_show(struct class_device *dev, char *buf)
+static ssize_t led_delay_off_show(struct device *dev, 
+		struct device_attribute *attr, char *buf)
 {
-	struct led_classdev *led_cdev = class_get_devdata(dev);
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
 	struct timer_trig_data *timer_data = led_cdev->trigger_data;
 
 	sprintf(buf, "%lu\n", timer_data->delay_off);
@@ -94,10 +96,10 @@ static ssize_t led_delay_off_show(struct class_device *dev, char *buf)
 	return strlen(buf) + 1;
 }
 
-static ssize_t led_delay_off_store(struct class_device *dev, const char *buf,
-				size_t size)
+static ssize_t led_delay_off_store(struct device *dev, 
+		struct device_attribute *attr, const char *buf, size_t size)
 {
-	struct led_classdev *led_cdev = class_get_devdata(dev);
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
 	struct timer_trig_data *timer_data = led_cdev->trigger_data;
 	int ret = -EINVAL;
 	char *after;
@@ -116,10 +118,8 @@ static ssize_t led_delay_off_store(struct class_device *dev, const char *buf,
 	return ret;
 }
 
-static CLASS_DEVICE_ATTR(delay_on, 0644, led_delay_on_show,
-			led_delay_on_store);
-static CLASS_DEVICE_ATTR(delay_off, 0644, led_delay_off_show,
-			led_delay_off_store);
+static DEVICE_ATTR(delay_on, 0644, led_delay_on_show, led_delay_on_store);
+static DEVICE_ATTR(delay_off, 0644, led_delay_off_show, led_delay_off_store);
 
 static void timer_trig_activate(struct led_classdev *led_cdev)
 {
@@ -136,18 +136,17 @@ static void timer_trig_activate(struct led_classdev *led_cdev)
 	timer_data->timer.function = led_timer_function;
 	timer_data->timer.data = (unsigned long) led_cdev;
 
-	rc = class_device_create_file(led_cdev->class_dev,
-				&class_device_attr_delay_on);
-	if (rc) goto err_out;
-	rc = class_device_create_file(led_cdev->class_dev,
-				&class_device_attr_delay_off);
-	if (rc) goto err_out_delayon;
+	rc = device_create_file(led_cdev->dev, &dev_attr_delay_on);
+	if (rc)
+		goto err_out;
+	rc = device_create_file(led_cdev->dev, &dev_attr_delay_off);
+	if (rc)
+		goto err_out_delayon;
 
 	return;
 
 err_out_delayon:
-	class_device_remove_file(led_cdev->class_dev,
-				&class_device_attr_delay_on);
+	device_remove_file(led_cdev->dev, &dev_attr_delay_on);
 err_out:
 	led_cdev->trigger_data = NULL;
 	kfree(timer_data);
@@ -158,10 +157,8 @@ static void timer_trig_deactivate(struct led_classdev *led_cdev)
 	struct timer_trig_data *timer_data = led_cdev->trigger_data;
 
 	if (timer_data) {
-		class_device_remove_file(led_cdev->class_dev,
-					&class_device_attr_delay_on);
-		class_device_remove_file(led_cdev->class_dev,
-					&class_device_attr_delay_off);
+		device_remove_file(led_cdev->dev, &dev_attr_delay_on);
+		device_remove_file(led_cdev->dev, &dev_attr_delay_off);
 		del_timer_sync(&timer_data->timer);
 		kfree(timer_data);
 	}
diff --git a/include/linux/leds.h b/include/linux/leds.h
index 059abfe..dc1178f 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -16,7 +16,6 @@
 #include <linux/spinlock.h>
 
 struct device;
-struct class_device;
 /*
  * LED Core
  */
@@ -38,7 +37,7 @@ struct led_classdev {
 	void		(*brightness_set)(struct led_classdev *led_cdev,
 					  enum led_brightness brightness);
 
-	struct class_device	*class_dev;
+	struct device		*dev;
 	struct list_head	 node;			/* LED Device list */
 	char			*default_trigger;	/* Trigger to use */
 

