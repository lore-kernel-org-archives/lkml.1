Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191Ab0CJOTJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 09:19:09 -0500
Received: from zmc.proxad.net ([212.27.53.206]:48363 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661Ab0CJOTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 09:19:07 -0500
X-Greylist: delayed 367 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Mar 2010 09:19:06 EST
X-Spam-Flag: NO
X-Spam-Score: -3.796
From: Florian Fainelli <ffainelli@freebox.fr>
Date: Wed, 10 Mar 2010 15:11:44 +0100
Subject: [PATCH] LEDS: fix race between LED device uevent and actual attributes creation
MIME-Version: 1.0
X-Length: 3869
Organization: Freebox
To: linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201003101511.44770.ffainelli@freebox.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we were to dynamically register/unregister leds and have udev or other
daemons handle the leds class uevents, we would be notified of the adding of a
new LED and if the daemon immediately tries to open one of the attributes of
the led device, it would fail with a "no such file or directory" error since the 
attributes are not yet created. Fix this by switching attributes to be 
class-wide, such that the driver core will register these attributes with
device_add_attrs and then emit the kobject_uevent ADD signal.

Signed-off-by: Florian Fainelli <ffainelli@freebox.fr>
CC: stable@kernel.org
---
diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index 782f958..0be0310 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -78,6 +78,14 @@ static DEVICE_ATTR(max_brightness, 0444, led_max_brightness_show, NULL);
 static DEVICE_ATTR(trigger, 0644, led_trigger_show, led_trigger_store);
 #endif
 
+static struct device_attribute *leds_class_attrs[] = {
+	&dev_attr_brightness,
+	&dev_attr_max_brightness,
+#ifdef CONFIG_LEDS_TRIGGERS
+	&dev_attr_trigger,
+#endif
+};
+
 /**
  * led_classdev_suspend - suspend an led_classdev.
  * @led_cdev: the led_classdev to suspend.
@@ -127,18 +135,11 @@ static int led_resume(struct device *dev)
  */
 int led_classdev_register(struct device *parent, struct led_classdev *led_cdev)
 {
-	int rc;
-
 	led_cdev->dev = device_create(leds_class, parent, 0, led_cdev,
 				      "%s", led_cdev->name);
 	if (IS_ERR(led_cdev->dev))
 		return PTR_ERR(led_cdev->dev);
 
-	/* register the attributes */
-	rc = device_create_file(led_cdev->dev, &dev_attr_brightness);
-	if (rc)
-		goto err_out;
-
 #ifdef CONFIG_LEDS_TRIGGERS
 	init_rwsem(&led_cdev->trigger_lock);
 #endif
@@ -150,17 +151,9 @@ int led_classdev_register(struct device *parent, struct led_classdev *led_cdev)
 	if (!led_cdev->max_brightness)
 		led_cdev->max_brightness = LED_FULL;
 
-	rc = device_create_file(led_cdev->dev, &dev_attr_max_brightness);
-	if (rc)
-		goto err_out_attr_max;
-
 	led_update_brightness(led_cdev);
 
 #ifdef CONFIG_LEDS_TRIGGERS
-	rc = device_create_file(led_cdev->dev, &dev_attr_trigger);
-	if (rc)
-		goto err_out_led_list;
-
 	led_trigger_set_default(led_cdev);
 #endif
 
@@ -168,18 +161,8 @@ int led_classdev_register(struct device *parent, struct led_classdev *led_cdev)
 			led_cdev->name);
 
 	return 0;
-
-#ifdef CONFIG_LEDS_TRIGGERS
-err_out_led_list:
-	device_remove_file(led_cdev->dev, &dev_attr_max_brightness);
-#endif
-err_out_attr_max:
-	device_remove_file(led_cdev->dev, &dev_attr_brightness);
-	list_del(&led_cdev->node);
-err_out:
-	device_unregister(led_cdev->dev);
-	return rc;
 }
+
 EXPORT_SYMBOL_GPL(led_classdev_register);
 
 /**
@@ -215,6 +198,7 @@ static int __init leds_init(void)
 		return PTR_ERR(leds_class);
 	leds_class->suspend = led_suspend;
 	leds_class->resume = led_resume;
+	leds_class->dev_attrs = *leds_class_attrs;
 	return 0;
 }
 

