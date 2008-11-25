Return-Path: <linux-kernel-owner+w=401wt.eu-S1753831AbYKYQ5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831AbYKYQ5g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 11:57:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752447AbYKYQ50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 11:57:26 -0500
Received: from mail.gmx.net ([213.165.64.20]:43798 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752023AbYKYQ5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 11:57:24 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1+ItsElxPmIAqC3MX9UGQaPcvoIuJSR4BO/ARcOku
	4rJa+st5YbyYAY
Date: Tue, 25 Nov 2008 17:57:31 +0100 (CET)
From: Guennadi Liakhovetski <lg@denx.de>
X-X-Sender: lyakh@axis700.grange
To: rpurdie@rpsys.net
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] LEDs: allow led-drivers to use a wider than 0...255 range
 of brightness values
Message-ID: <Pine.LNX.4.64.0811251751480.6290@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows drivers to override the default maximum brightness value of
255. We take care to preserve backwards-compatibility, so that user-space
ABI doesn't change for existing drivers. All existing drivers have been verified
to use a zero-initialised memory for their struct led_classdev objects, so that
they will get the default maximum value of 255. New user-space software 
can use a new read-only sysfs file /sys/class/leds/*/max_brightness to 
retrieve maximum supported brightness of a specific LED.

Signed-off-by: Guennadi Liakhovetski <lg@denx.de>
---
This will be needed for a new LED driver for an SPI DAC, used as a 
photo-flash and for camera calibration, so, its brightness has to be 
adjustable at a finer than 256 levels scale.

 drivers/leds/led-class.c |   21 ++++++++++++++++++++-
 drivers/leds/leds.h      |    4 ++--
 include/linux/leds.h     |    1 +
 3 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index 6c4a326..c3b4ace 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -64,7 +64,16 @@ static ssize_t led_brightness_store(struct device *dev,
 	return ret;
 }
 
+static ssize_t led_max_brightness_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%u\n", led_cdev->max_brightness);
+}
+
 static DEVICE_ATTR(brightness, 0644, led_brightness_show, led_brightness_store);
+static DEVICE_ATTR(max_brightness, 0444, led_max_brightness_show, NULL);
 #ifdef CONFIG_LEDS_TRIGGERS
 static DEVICE_ATTR(trigger, 0644, led_trigger_show, led_trigger_store);
 #endif
@@ -118,6 +127,13 @@ int led_classdev_register(struct device *parent, struct led_classdev *led_cdev)
 	list_add_tail(&led_cdev->node, &leds_list);
 	up_write(&leds_list_lock);
 
+	if (!led_cdev->max_brightness)
+		led_cdev->max_brightness = LED_FULL;
+
+	rc = device_create_file(led_cdev->dev, &dev_attr_max_brightness);
+	if (rc)
+		goto err_out_attr_max;
+
 	led_update_brightness(led_cdev);
 
 #ifdef CONFIG_LEDS_TRIGGERS
@@ -135,9 +151,11 @@ int led_classdev_register(struct device *parent, struct led_classdev *led_cdev)
 
 #ifdef CONFIG_LEDS_TRIGGERS
 err_out_led_list:
+	device_remove_file(led_cdev->dev, &dev_attr_max_brightness);
+#endif
+err_out_attr_max:
 	device_remove_file(led_cdev->dev, &dev_attr_brightness);
 	list_del(&led_cdev->node);
-#endif
 err_out:
 	device_unregister(led_cdev->dev);
 	return rc;
@@ -152,6 +170,7 @@ EXPORT_SYMBOL_GPL(led_classdev_register);
  */
 void led_classdev_unregister(struct led_classdev *led_cdev)
 {
+	device_remove_file(led_cdev->dev, &dev_attr_max_brightness);
 	device_remove_file(led_cdev->dev, &dev_attr_brightness);
 #ifdef CONFIG_LEDS_TRIGGERS
 	device_remove_file(led_cdev->dev, &dev_attr_trigger);
diff --git a/drivers/leds/leds.h b/drivers/leds/leds.h
index 5edbf52..2dd8ecb 100644
--- a/drivers/leds/leds.h
+++ b/drivers/leds/leds.h
@@ -20,8 +20,8 @@
 static inline void led_set_brightness(struct led_classdev *led_cdev,
 					enum led_brightness value)
 {
-	if (value > LED_FULL)
-		value = LED_FULL;
+	if (value > led_cdev->max_brightness)
+		value = led_cdev->max_brightness;
 	led_cdev->brightness = value;
 	if (!(led_cdev->flags & LED_SUSPENDED))
 		led_cdev->brightness_set(led_cdev, value);
diff --git a/include/linux/leds.h b/include/linux/leds.h
index d3a73f5..4f8b842 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -30,6 +30,7 @@ enum led_brightness {
 struct led_classdev {
 	const char		*name;
 	int			 brightness;
+	int			 max_brightness;
 	int			 flags;
 
 #define LED_SUSPENDED		(1 << 0)
-- 
1.5.4

