Return-Path: <linux-kernel-owner+w=401wt.eu-S1760602AbYBEUve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760602AbYBEUve (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 15:51:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760839AbYBEUvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 15:51:10 -0500
Received: from smtp1.stealer.net ([88.198.224.204]:37007 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760813AbYBEUvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 15:51:09 -0500
X-Greylist: delayed 1243 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Feb 2008 15:51:08 EST
From: Sven Wegener <sven.wegener@stealer.net>
To: rpurdie@rpsys.net
Cc: kris@krisk.org, linux-kernel@vger.kernel.org
Subject: [PATCH] leds: Add support for power LED on WRAP systems
Date: Tue,  5 Feb 2008 21:51:02 +0100
Message-Id: <1202244662-5556-1-git-send-email-sven.wegener@stealer.net>
X-Mailer: git-send-email 1.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WRAP systems have an additional LED. The power LED is normally lit after boot
and doesn't serve any other purpose besides showing that the system is powered
on. Nevertheless, its state is controllable and we can attach a trigger to it.

Cc: Kristian Kielhofner <kris@krisk.org>
Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
---
 drivers/leds/leds-wrap.c |   41 +++++++++++++++++++++++++++++++++++------
 1 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/drivers/leds/leds-wrap.c b/drivers/leds/leds-wrap.c
index 27fb2d8..0ccb483 100644
--- a/drivers/leds/leds-wrap.c
+++ b/drivers/leds/leds-wrap.c
@@ -19,11 +19,21 @@
 #include <linux/scx200_gpio.h>
 
 #define DRVNAME "wrap-led"
+#define WRAP_POWER_LED_GPIO	2
 #define WRAP_ERROR_LED_GPIO	3
 #define	WRAP_EXTRA_LED_GPIO	18
 
 static struct platform_device *pdev;
 
+static void wrap_power_led_set(struct led_classdev *led_cdev,
+		enum led_brightness value)
+{
+	if (value)
+		scx200_gpio_set_low(WRAP_POWER_LED_GPIO);
+	else
+		scx200_gpio_set_high(WRAP_POWER_LED_GPIO);
+}
+
 static void wrap_error_led_set(struct led_classdev *led_cdev,
 		enum led_brightness value)
 {
@@ -42,6 +52,11 @@ static void wrap_extra_led_set(struct led_classdev *led_cdev,
 		scx200_gpio_set_high(WRAP_EXTRA_LED_GPIO);
 }
 
+static struct led_classdev wrap_power_led = {
+	.name		= "wrap:power",
+	.brightness_set	= wrap_power_led_set,
+};
+
 static struct led_classdev wrap_error_led = {
 	.name		= "wrap:error",
 	.brightness_set	= wrap_error_led_set,
@@ -56,6 +71,7 @@ static struct led_classdev wrap_extra_led = {
 static int wrap_led_suspend(struct platform_device *dev,
 		pm_message_t state)
 {
+	led_classdev_suspend(&wrap_power_led);
 	led_classdev_suspend(&wrap_error_led);
 	led_classdev_suspend(&wrap_extra_led);
 	return 0;
@@ -63,6 +79,7 @@ static int wrap_led_suspend(struct platform_device *dev,
 
 static int wrap_led_resume(struct platform_device *dev)
 {
+	led_classdev_resume(&wrap_power_led);
 	led_classdev_resume(&wrap_error_led);
 	led_classdev_resume(&wrap_extra_led);
 	return 0;
@@ -76,17 +93,30 @@ static int wrap_led_probe(struct platform_device *pdev)
 {
 	int ret;
 
+	ret = led_classdev_register(&pdev->dev, &wrap_power_led);
+	if (ret < 0)
+		goto out;
 	ret = led_classdev_register(&pdev->dev, &wrap_error_led);
-	if (ret == 0) {
-		ret = led_classdev_register(&pdev->dev, &wrap_extra_led);
-		if (ret < 0)
-			led_classdev_unregister(&wrap_error_led);
-	}
+	if (ret < 0)
+		goto outpower;
+	ret = led_classdev_register(&pdev->dev, &wrap_extra_led);
+	if (ret < 0)
+		goto outerror;
+
+	return 0;
+
+outerror:
+	led_classdev_unregister(&wrap_error_led);
+outpower:
+	led_classdev_unregister(&wrap_power_led);
+out:
+
 	return ret;
 }
 
 static int wrap_led_remove(struct platform_device *pdev)
 {
+	led_classdev_unregister(&wrap_power_led);
 	led_classdev_unregister(&wrap_error_led);
 	led_classdev_unregister(&wrap_extra_led);
 	return 0;
@@ -139,4 +169,3 @@ module_exit(wrap_led_exit);
 MODULE_AUTHOR("Kristian Kielhofner <kris@krisk.org>");
 MODULE_DESCRIPTION("PCEngines WRAP LED driver");
 MODULE_LICENSE("GPL");
-
-- 
1.5.4

