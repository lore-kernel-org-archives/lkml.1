Return-Path: <linux-kernel-owner+w=401wt.eu-S1760743AbXGWNNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760743AbXGWNNR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 09:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753794AbXGWNNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 09:13:04 -0400
Received: from tim.rpsys.net ([194.106.48.114]:53199 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753790AbXGWNNB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 09:13:01 -0400
Subject: Re: [1/2] 2.6.23-rc1: known regressions
From: Richard Purdie <rpurdie@rpsys.net>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Trent Piepho <xyzzy@speakeasy.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, acpi4asus-u@pimp.vs19.net,
       Gabriel C <nix.or.die@googlemail.com>,
       Corentin Chary <corentincj@iksaif.net>,
       Andreas Gruenbacher <agruen@suse.de>
In-Reply-To: <20070723112557.GG21668@ftp.linux.org.uk>
References: <46A47932.8000709@googlemail.com>
	 <Pine.LNX.4.58.0707230404290.5535@shell2.speakeasy.net>
	 <20070723112557.GG21668@ftp.linux.org.uk>
Content-Type: text/plain
Date: Mon, 23 Jul 2007 14:12:07 +0100
Message-Id: <1185196327.6148.51.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-23 at 12:25 +0100, Al Viro wrote:
> On Mon, Jul 23, 2007 at 04:17:05AM -0700, Trent Piepho wrote:
>  
> > Here's a trivial patch for this one.
> > ------------------------------------------------------------------------
> > asus-laptop: Sync with changes to led class
> > 
> > Driver was broken by commit f8a7c6fe14f556ca8eeddce258cb21392d0c3a2f
> > 	leds: Convert from struct class_device to struct device
> > 
> > 	Convert the LEDs class from struct class_device to struct device
> > 	since class_device is scheduled for removal.
> > 
> > Use (struct led_classdev).dev instead of (struct led_classdev).class_dev
> 
> It doesn't fix the real bug in there - if you look carefully at the code,
> you'll see that we don't get to these checks if allocation fails halfway
> through (and we leak in that case) *and* these checks are not needed at
> all if failure happens elsewhere.

leds: Allow led_classdev_unregister() to ignore unregistered drivers

Allow led_classdev_unregister() to return for devices that were already
unregistered, never registered or failed to register to simplify
drivers. 

Fix error leftover from LED class struct device conversion (after the
above, drivers don't need to look at the device structure).

Fix the leak where asus-led registration fails half way through.

Signed-off-by: Richard Purdie <rpurdie@rpsys.net>

diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index 4211293..68d26b8 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -95,8 +95,10 @@ int led_classdev_register(struct device *parent, struct led_classdev *led_cdev)
 
 	led_cdev->dev = device_create(leds_class, parent, 0, "%s",
 					    led_cdev->name);
-	if (unlikely(IS_ERR(led_cdev->dev)))
-		return PTR_ERR(led_cdev->dev);
+	if (unlikely(IS_ERR(led_cdev->dev))) {
+		rc = PTR_ERR(led_cdev->dev);
+		goto create_err;
+	}
 
 	dev_set_drvdata(led_cdev->dev, led_cdev);
 
@@ -132,6 +134,8 @@ err_out_led_list:
 #endif
 err_out:
 	device_unregister(led_cdev->dev);
+create_err:
+	led_cdev->dev = NULL;
 	return rc;
 }
 EXPORT_SYMBOL_GPL(led_classdev_register);
@@ -144,6 +148,9 @@ EXPORT_SYMBOL_GPL(led_classdev_register);
  */
 void led_classdev_unregister(struct led_classdev *led_cdev)
 {
+	if (!led_cdev->dev)
+		return;
+
 	device_remove_file(led_cdev->dev, &dev_attr_brightness);
 #ifdef CONFIG_LEDS_TRIGGERS
 	device_remove_file(led_cdev->dev, &dev_attr_trigger);
diff --git a/drivers/misc/asus-laptop.c b/drivers/misc/asus-laptop.c
index f753060..2bc4f6e 100644
--- a/drivers/misc/asus-laptop.c
+++ b/drivers/misc/asus-laptop.c
@@ -1066,18 +1066,13 @@ static void asus_backlight_exit(void)
 		backlight_device_unregister(asus_backlight_device);
 }
 
-#define  ASUS_LED_UNREGISTER(object)				\
-	if(object##_led.class_dev				\
-	   && !IS_ERR(object##_led.class_dev))			\
-		led_classdev_unregister(&object##_led)
-
 static void asus_led_exit(void)
 {
-	ASUS_LED_UNREGISTER(mled);
-	ASUS_LED_UNREGISTER(tled);
-	ASUS_LED_UNREGISTER(pled);
-	ASUS_LED_UNREGISTER(rled);
-	ASUS_LED_UNREGISTER(gled);
+	led_classdev_unregister(&mled_led);
+	led_classdev_unregister(&tled_led);
+	led_classdev_unregister(&pled_led);
+	led_classdev_unregister(&rled_led);
+	led_classdev_unregister(&gled_led);
 
 	destroy_workqueue(led_workqueue);
 }
@@ -1226,9 +1221,8 @@ static int __init asus_laptop_init(void)
 	platform_driver_unregister(&asuspf_driver);
 
       fail_platform_driver:
-	asus_led_exit();
-
       fail_led:
+	asus_led_exit();
 	asus_backlight_exit();
 
       fail_backlight:

