Return-Path: <linux-kernel-owner+w=401wt.eu-S1753233AbXL0ONg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233AbXL0ONg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 09:13:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751854AbXL0ON3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 09:13:29 -0500
Received: from mx01.ap-wdsl.de ([88.198.184.82]:34991 "EHLO mx01.ap-wdsl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751933AbXL0ON2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 09:13:28 -0500
X-Greylist: delayed 2494 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Dec 2007 09:13:28 EST
Subject: [PATCH] leds: Add support for the 3rd LED on the PCEngines WRAP
From: Michael Loeffler <zvpunry@zvpunry.de>
To: linux-kernel@vger.kernel.org
Cc: Richard Purdie <rpurdie@rpsys.net>, Kristian Kielhofner <kris@krisk.org>
Content-Type: text/plain
Date: Thu, 27 Dec 2007 14:31:42 +0100
Message-Id: <1198762302.15874.6.camel@macbook>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 3rd LED on this board is something like a power-led, it is on all the
time. With this change to the leds-wrap driver it is possible to use this
LED too.

Signed-off-by: Michael Loeffler <zvpunry@zvpunry.de>
---
Hi

I wonder why there was no support for this LED. This LED and the GPIO
line is documented in the first commit message (0d75565f) for this file.

I use this changed version for five weeks and it just works. I think this
patch can be included in 2.6.25.

bye

PS: I'm not subscribed to the lkml, so please Cc me.

 drivers/leds/leds-wrap.c |   43 +++++++++++++++++++++++++++++++++++++------
 1 files changed, 37 insertions(+), 6 deletions(-)

diff --git a/drivers/leds/leds-wrap.c b/drivers/leds/leds-wrap.c
index 27fb2d8..254e426 100644
--- a/drivers/leds/leds-wrap.c
+++ b/drivers/leds/leds-wrap.c
@@ -19,11 +19,21 @@
 #include <linux/scx200_gpio.h>
 
 #define DRVNAME "wrap-led"
+#define WRAP_POWER_LED_GPIO	2
 #define WRAP_ERROR_LED_GPIO	3
-#define	WRAP_EXTRA_LED_GPIO	18
+#define WRAP_EXTRA_LED_GPIO	18
 
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
@@ -76,17 +93,31 @@ static int wrap_led_probe(struct platform_device *pdev)
 {
 	int ret;
 
+	ret = led_classdev_register(&pdev->dev, &wrap_power_led);
+	if (ret < 0)
+		return ret;
+
 	ret = led_classdev_register(&pdev->dev, &wrap_error_led);
-	if (ret == 0) {
-		ret = led_classdev_register(&pdev->dev, &wrap_extra_led);
-		if (ret < 0)
-			led_classdev_unregister(&wrap_error_led);
-	}
+	if (ret < 0)
+		goto err1;
+
+	ret = led_classdev_register(&pdev->dev, &wrap_extra_led);
+	if (ret < 0)
+		goto err2;
+
+	return ret;
+
+err2:
+	led_classdev_unregister(&wrap_error_led);
+err1:
+	led_classdev_unregister(&wrap_power_led);
+
 	return ret;
 }
 
 static int wrap_led_remove(struct platform_device *pdev)
 {
+	led_classdev_unregister(&wrap_power_led);
 	led_classdev_unregister(&wrap_error_led);
 	led_classdev_unregister(&wrap_extra_led);
 	return 0;
-- 
1.5.3.7.1112.g9758e


