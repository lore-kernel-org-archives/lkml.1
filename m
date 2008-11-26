Return-Path: <linux-kernel-owner+w=401wt.eu-S1752888AbYKZPqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888AbYKZPqW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 10:46:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752292AbYKZPqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 10:46:13 -0500
Received: from mail.gmx.net ([213.165.64.20]:44877 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751280AbYKZPqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 10:46:10 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1+dDrxmAJqdkiwGifdKe9HW6voiLJVr34XCxPrbEh
	Vm3lAFPBG2bogs
Date: Wed, 26 Nov 2008 16:46:12 +0100 (CET)
From: Guennadi Liakhovetski <lg@denx.de>
X-X-Sender: lyakh@axis700.grange
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
cc: rpurdie@rpsys.net, linux-kernel@vger.kernel.org
Subject: [PATCH v2] LEDs: allow led-drivers to use a wider than 0...255 range
 of brightness values
In-Reply-To: <20081125180241.GA4783@khazad-dum.debian.net>
Message-ID: <Pine.LNX.4.64.0811261535590.4749@axis700.grange>
References: <Pine.LNX.4.64.0811251751480.6290@axis700.grange>
 <20081125180241.GA4783@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows drivers to override the default maximum brightness value 
of 255. We take care to preserve backwards-compatibility as much as 
possible, so that user-space ABI doesn't change for existing drivers. All 
existing drivers have been modified to explicitly set their maximum 
brightness to LED_FULL. LED trigger code has also been updated to use the 
per-LED maximum.

Signed-off-by: Guennadi Liakhovetski <lg@denx.de>
---

On Tue, 25 Nov 2008, 
Henrique de Moraes Holschuh wrote:

> On Tue, 25 Nov 2008, Guennadi Liakhovetski wrote:
> > This patch allows drivers to override the default maximum brightness value of
> > 255. We take care to preserve backwards-compatibility, so that user-space
> > ABI doesn't change for existing drivers. All existing drivers have been verified
> > to use a zero-initialised memory for their struct led_classdev objects, so that
> > they will get the default maximum value of 255. New user-space software 
> > can use a new read-only sysfs file /sys/class/leds/*/max_brightness to 
> > retrieve maximum supported brightness of a specific LED.
> 
> I am not speaking AGAINST this change, I actually like the idea, especially
> if we can set max_brightness to 1 and support binary (on/off) leds in a much
> easier way :p
> 
> However, you must be aware that it IS still an ABI and API change.  Generic
> LED drivers and triggers expect the [0, 255] scale, and expect 0 and 255 to
> have special meanings (LED_OFF and LED_FULL).
> 
> I'd suggest that you set the new max_brightness field PROPERLY for all LEDs

Done.

> (i.e. set it to 255), and fix all of the LED trigger code to use
> max_brightness when it wants LED_FULL.

Done.

> In fact, LED_FULL probably will need to become a function (inlineable), so
> that triggers can just call led_set_to_max_brightness(theled), or
> whatever...

Triggers do this in different ways, two of them first calculate the new 
brightness in a variable, then use it to update brightness, one of them 
(default-on) just sets it permanently to FULL / max, yet another one 
(ide-disk) calls led_trigger_event(). So, it looks like such a function 
wouldn't being much.

> That would still leave us with non-updated userspace not doing the right
> thing when faced with a led with a range different from [0, 255], but there is
> probably not a big set of userland doing generic LED control (and specific
> LEDs have no reason to change their range from the default [0, 255]).

I also don't think there are too many applications out there that will be 
endangered by this patch.

> Either that, or maybe you could use an alternative way, like adding a
> fractional component to the scale (which has its own problems, but it
> probably can be done cleanly).  In that case, it is best to also add an
> attribute to disclose the granularity supported by the LED driver.

Would you then have to do "echo 100.5 > brightness"?...

A second version of the patch below.

 drivers/leds/led-class.c          |   21 ++++++++++++++++++++-
 drivers/leds/leds-ams-delta.c     |    6 ++++++
 drivers/leds/leds-atmel-pwm.c     |    1 +
 drivers/leds/leds-clevo-mail.c    |    1 +
 drivers/leds/leds-cobalt-qube.c   |    1 +
 drivers/leds/leds-cobalt-raq.c    |    2 ++
 drivers/leds/leds-da903x.c        |    1 +
 drivers/leds/leds-fsg.c           |    6 ++++++
 drivers/leds/leds-gpio.c          |    1 +
 drivers/leds/leds-h1940.c         |    3 +++
 drivers/leds/leds-hp-disk.c       |    1 +
 drivers/leds/leds-hp6xx.c         |    2 ++
 drivers/leds/leds-locomo.c        |    2 ++
 drivers/leds/leds-net48xx.c       |    1 +
 drivers/leds/leds-pca9532.c       |    1 +
 drivers/leds/leds-pca955x.c       |    1 +
 drivers/leds/leds-s3c24xx.c       |    1 +
 drivers/leds/leds-sunfire.c       |    1 +
 drivers/leds/leds-wrap.c          |    3 +++
 drivers/leds/leds.h               |    4 ++--
 drivers/leds/ledtrig-default-on.c |    2 +-
 drivers/leds/ledtrig-heartbeat.c  |    4 ++--
 drivers/leds/ledtrig-ide-disk.c   |    3 ++-
 drivers/leds/ledtrig-timer.c      |    2 +-
 include/linux/leds.h              |    1 +
 25 files changed, 64 insertions(+), 8 deletions(-)

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
diff --git a/drivers/leds/leds-ams-delta.c b/drivers/leds/leds-ams-delta.c
index 1bd590b..08484dc 100644
--- a/drivers/leds/leds-ams-delta.c
+++ b/drivers/leds/leds-ams-delta.c
@@ -39,6 +39,7 @@ static struct ams_delta_led ams_delta_leds[] = {
 		.cdev		= {
 			.name		= "ams-delta::camera",
 			.brightness_set = ams_delta_led_set,
+			.max_brightness	= LED_FULL,
 		},
 		.bitmask	= AMS_DELTA_LATCH1_LED_CAMERA,
 	},
@@ -46,6 +47,7 @@ static struct ams_delta_led ams_delta_leds[] = {
 		.cdev		= {
 			.name		= "ams-delta::advert",
 			.brightness_set = ams_delta_led_set,
+			.max_brightness	= LED_FULL,
 		},
 		.bitmask	= AMS_DELTA_LATCH1_LED_ADVERT,
 	},
@@ -53,6 +55,7 @@ static struct ams_delta_led ams_delta_leds[] = {
 		.cdev		= {
 			.name		= "ams-delta::email",
 			.brightness_set = ams_delta_led_set,
+			.max_brightness	= LED_FULL,
 		},
 		.bitmask	= AMS_DELTA_LATCH1_LED_EMAIL,
 	},
@@ -60,6 +63,7 @@ static struct ams_delta_led ams_delta_leds[] = {
 		.cdev		= {
 			.name		= "ams-delta::handsfree",
 			.brightness_set = ams_delta_led_set,
+			.max_brightness	= LED_FULL,
 		},
 		.bitmask	= AMS_DELTA_LATCH1_LED_HANDSFREE,
 	},
@@ -67,6 +71,7 @@ static struct ams_delta_led ams_delta_leds[] = {
 		.cdev		= {
 			.name		= "ams-delta::voicemail",
 			.brightness_set = ams_delta_led_set,
+			.max_brightness	= LED_FULL,
 		},
 		.bitmask	= AMS_DELTA_LATCH1_LED_VOICEMAIL,
 	},
@@ -74,6 +79,7 @@ static struct ams_delta_led ams_delta_leds[] = {
 		.cdev		= {
 			.name		= "ams-delta::voice",
 			.brightness_set = ams_delta_led_set,
+			.max_brightness	= LED_FULL,
 		},
 		.bitmask	= AMS_DELTA_LATCH1_LED_VOICE,
 	},
diff --git a/drivers/leds/leds-atmel-pwm.c b/drivers/leds/leds-atmel-pwm.c
index 52297c3..14e0d97 100644
--- a/drivers/leds/leds-atmel-pwm.c
+++ b/drivers/leds/leds-atmel-pwm.c
@@ -55,6 +55,7 @@ static int __init pwmled_probe(struct platform_device *pdev)
 
 		led->cdev.name = dat->name;
 		led->cdev.brightness = LED_OFF;
+		led->cdev.max_brightness = LED_FULL;
 		led->cdev.brightness_set = pwmled_brightness;
 		led->cdev.default_trigger = dat->default_trigger;
 
diff --git a/drivers/leds/leds-clevo-mail.c b/drivers/leds/leds-clevo-mail.c
index eb3415e..6d0cb1e 100644
--- a/drivers/leds/leds-clevo-mail.c
+++ b/drivers/leds/leds-clevo-mail.c
@@ -142,6 +142,7 @@ static struct led_classdev clevo_mail_led = {
 	.name			= "clevo::mail",
 	.brightness_set		= clevo_mail_led_set,
 	.blink_set		= clevo_mail_led_blink,
+	.max_brightness		= LED_FULL,
 };
 
 static int __init clevo_mail_led_probe(struct platform_device *pdev)
diff --git a/drivers/leds/leds-cobalt-qube.c b/drivers/leds/leds-cobalt-qube.c
index 059aa29..fe92727 100644
--- a/drivers/leds/leds-cobalt-qube.c
+++ b/drivers/leds/leds-cobalt-qube.c
@@ -30,6 +30,7 @@ static void qube_front_led_set(struct led_classdev *led_cdev,
 static struct led_classdev qube_front_led = {
 	.name			= "qube-front",
 	.brightness		= LED_FULL,
+	.max_brightness		= LED_FULL,
 	.brightness_set		= qube_front_led_set,
 	.default_trigger	= "ide-disk",
 };
diff --git a/drivers/leds/leds-cobalt-raq.c b/drivers/leds/leds-cobalt-raq.c
index ff0e8c3..742ae24 100644
--- a/drivers/leds/leds-cobalt-raq.c
+++ b/drivers/leds/leds-cobalt-raq.c
@@ -51,6 +51,7 @@ static void raq_web_led_set(struct led_classdev *led_cdev,
 static struct led_classdev raq_web_led = {
 	.name		= "raq-web",
 	.brightness_set	= raq_web_led_set,
+	.max_brightness	= LED_FULL,
 };
 
 static void raq_power_off_led_set(struct led_classdev *led_cdev,
@@ -72,6 +73,7 @@ static void raq_power_off_led_set(struct led_classdev *led_cdev,
 static struct led_classdev raq_power_off_led = {
 	.name			= "raq-power-off",
 	.brightness_set		= raq_power_off_led_set,
+	.max_brightness		= LED_FULL,
 	.default_trigger	= "power-off",
 };
 
diff --git a/drivers/leds/leds-da903x.c b/drivers/leds/leds-da903x.c
index 1f3cc51..986ed7c 100644
--- a/drivers/leds/leds-da903x.c
+++ b/drivers/leds/leds-da903x.c
@@ -117,6 +117,7 @@ static int __devinit da903x_led_probe(struct platform_device *pdev)
 	led->cdev.default_trigger = pdata->default_trigger;
 	led->cdev.brightness_set = da903x_led_set;
 	led->cdev.brightness = LED_OFF;
+	led->cdev.max_brightness = LED_FULL;
 
 	led->id = id;
 	led->flags = pdata->flags;
diff --git a/drivers/leds/leds-fsg.c b/drivers/leds/leds-fsg.c
index 3493515..2729425 100644
--- a/drivers/leds/leds-fsg.c
+++ b/drivers/leds/leds-fsg.c
@@ -103,31 +103,37 @@ static void fsg_led_ring_set(struct led_classdev *led_cdev,
 static struct led_classdev fsg_wlan_led = {
 	.name			= "fsg:blue:wlan",
 	.brightness_set		= fsg_led_wlan_set,
+	.max_brightness		= LED_FULL,
 };
 
 static struct led_classdev fsg_wan_led = {
 	.name			= "fsg:blue:wan",
 	.brightness_set		= fsg_led_wan_set,
+	.max_brightness		= LED_FULL,
 };
 
 static struct led_classdev fsg_sata_led = {
 	.name			= "fsg:blue:sata",
 	.brightness_set		= fsg_led_sata_set,
+	.max_brightness		= LED_FULL,
 };
 
 static struct led_classdev fsg_usb_led = {
 	.name			= "fsg:blue:usb",
 	.brightness_set		= fsg_led_usb_set,
+	.max_brightness		= LED_FULL,
 };
 
 static struct led_classdev fsg_sync_led = {
 	.name			= "fsg:blue:sync",
 	.brightness_set		= fsg_led_sync_set,
+	.max_brightness		= LED_FULL,
 };
 
 static struct led_classdev fsg_ring_led = {
 	.name			= "fsg:blue:ring",
 	.brightness_set		= fsg_led_ring_set,
+	.max_brightness		= LED_FULL,
 };
 
 
diff --git a/drivers/leds/leds-gpio.c b/drivers/leds/leds-gpio.c
index b13bd29..84edf0d 100644
--- a/drivers/leds/leds-gpio.c
+++ b/drivers/leds/leds-gpio.c
@@ -105,6 +105,7 @@ static int gpio_led_probe(struct platform_device *pdev)
 		}
 		led_dat->cdev.brightness_set = gpio_led_set;
 		led_dat->cdev.brightness = LED_OFF;
+		led_dat->cdev.max_brightness = LED_FULL;
 
 		gpio_direction_output(led_dat->gpio, led_dat->active_low);
 
diff --git a/drivers/leds/leds-h1940.c b/drivers/leds/leds-h1940.c
index 11b77a7..e301c31 100644
--- a/drivers/leds/leds-h1940.c
+++ b/drivers/leds/leds-h1940.c
@@ -48,6 +48,7 @@ static struct led_classdev h1940_greenled = {
 	.name			= "h1940:green",
 	.brightness_set		= h1940_greenled_set,
 	.default_trigger	= "h1940-charger",
+	.max_brightness		= LED_FULL,
 };
 
 /*
@@ -78,6 +79,7 @@ static struct led_classdev h1940_redled = {
 	.name			= "h1940:red",
 	.brightness_set		= h1940_redled_set,
 	.default_trigger	= "h1940-charger",
+	.max_brightness		= LED_FULL,
 };
 
 /*
@@ -102,6 +104,7 @@ static struct led_classdev h1940_blueled = {
 	.name			= "h1940:blue",
 	.brightness_set		= h1940_blueled_set,
 	.default_trigger	= "h1940-bluetooth",
+	.max_brightness		= LED_FULL,
 };
 
 static int __init h1940leds_probe(struct platform_device *pdev)
diff --git a/drivers/leds/leds-hp-disk.c b/drivers/leds/leds-hp-disk.c
index 44fa757..5c79e0e 100644
--- a/drivers/leds/leds-hp-disk.c
+++ b/drivers/leds/leds-hp-disk.c
@@ -68,6 +68,7 @@ static struct led_classdev hpled_led = {
 	.name			= "hp:red:hddprotection",
 	.default_trigger	= "heartbeat",
 	.brightness_set		= hpled_set,
+	.max_brightness		= LED_FULL,
 };
 
 #ifdef CONFIG_PM
diff --git a/drivers/leds/leds-hp6xx.c b/drivers/leds/leds-hp6xx.c
index e8fb1ba..5ab6399 100644
--- a/drivers/leds/leds-hp6xx.c
+++ b/drivers/leds/leds-hp6xx.c
@@ -45,12 +45,14 @@ static struct led_classdev hp6xx_red_led = {
 	.name			= "hp6xx:red",
 	.default_trigger	= "hp6xx-charge",
 	.brightness_set		= hp6xxled_red_set,
+	.max_brightness		= LED_FULL,
 };
 
 static struct led_classdev hp6xx_green_led = {
 	.name			= "hp6xx:green",
 	.default_trigger	= "ide-disk",
 	.brightness_set		= hp6xxled_green_set,
+	.max_brightness		= LED_FULL,
 };
 
 #ifdef CONFIG_PM
diff --git a/drivers/leds/leds-locomo.c b/drivers/leds/leds-locomo.c
index 5d91362..89aeb1d 100644
--- a/drivers/leds/leds-locomo.c
+++ b/drivers/leds/leds-locomo.c
@@ -46,12 +46,14 @@ static struct led_classdev locomo_led0 = {
 	.name			= "locomo:amber:charge",
 	.default_trigger	= "sharpsl-charge",
 	.brightness_set		= locomoled_brightness_set0,
+	.max_brightness		= LED_FULL,
 };
 
 static struct led_classdev locomo_led1 = {
 	.name			= "locomo:green:mail",
 	.default_trigger	= "nand-disk",
 	.brightness_set		= locomoled_brightness_set1,
+	.max_brightness		= LED_FULL,
 };
 
 static int locomoled_probe(struct locomo_dev *ldev)
diff --git a/drivers/leds/leds-net48xx.c b/drivers/leds/leds-net48xx.c
index 0543604..50fca74 100644
--- a/drivers/leds/leds-net48xx.c
+++ b/drivers/leds/leds-net48xx.c
@@ -33,6 +33,7 @@ static void net48xx_error_led_set(struct led_classdev *led_cdev,
 static struct led_classdev net48xx_error_led = {
 	.name		= "net48xx::error",
 	.brightness_set	= net48xx_error_led_set,
+	.max_brightness	= LED_FULL,
 };
 
 #ifdef CONFIG_PM
diff --git a/drivers/leds/leds-pca9532.c b/drivers/leds/leds-pca9532.c
index 4064d4f..f042662 100644
--- a/drivers/leds/leds-pca9532.c
+++ b/drivers/leds/leds-pca9532.c
@@ -202,6 +202,7 @@ static int pca9532_configure(struct i2c_client *client,
 			led->name =  pled->name;
 			led->ldev.name = led->name;
 			led->ldev.brightness = LED_OFF;
+			led->ldev.max_brightness = LED_FULL;
 			led->ldev.brightness_set = pca9532_set_brightness;
 			led->ldev.blink_set = pca9532_set_blink;
 			if (led_classdev_register(&client->dev,
diff --git a/drivers/leds/leds-pca955x.c b/drivers/leds/leds-pca955x.c
index 4e2d1a4..ff24ebb 100644
--- a/drivers/leds/leds-pca955x.c
+++ b/drivers/leds/leds-pca955x.c
@@ -310,6 +310,7 @@ static int __devinit pca955x_probe(struct i2c_client *client,
 
 		pca955x[i].led_cdev.name = pca955x[i].name;
 		pca955x[i].led_cdev.brightness_set = pca955x_led_set;
+		pca955x[i].led_cdev.max_brightness = LED_FULL;
 
 		INIT_WORK(&pca955x[i].work, pca955x_led_work);
 
diff --git a/drivers/leds/leds-s3c24xx.c b/drivers/leds/leds-s3c24xx.c
index 25a07f2..f98af40 100644
--- a/drivers/leds/leds-s3c24xx.c
+++ b/drivers/leds/leds-s3c24xx.c
@@ -80,6 +80,7 @@ static int s3c24xx_led_probe(struct platform_device *dev)
 	platform_set_drvdata(dev, led);
 
 	led->cdev.brightness_set = s3c24xx_led_set;
+	led->cdev.max_brightness = LED_FULL;
 	led->cdev.default_trigger = pdata->def_trigger;
 	led->cdev.name = pdata->name;
 
diff --git a/drivers/leds/leds-sunfire.c b/drivers/leds/leds-sunfire.c
index 6b008f0..fe8051f 100644
--- a/drivers/leds/leds-sunfire.c
+++ b/drivers/leds/leds-sunfire.c
@@ -146,6 +146,7 @@ static int __devinit sunfire_led_generic_probe(struct platform_device *pdev,
 		p->leds[i].reg = (void __iomem *) pdev->resource[0].start;
 		lp->name = types[i].name;
 		lp->brightness = LED_FULL;
+		lp->max_brightness = LED_FULL;
 		lp->brightness_set = types[i].handler;
 		lp->default_trigger = types[i].default_trigger;
 
diff --git a/drivers/leds/leds-wrap.c b/drivers/leds/leds-wrap.c
index 2f3aa87..83956f0 100644
--- a/drivers/leds/leds-wrap.c
+++ b/drivers/leds/leds-wrap.c
@@ -56,16 +56,19 @@ static struct led_classdev wrap_power_led = {
 	.name			= "wrap::power",
 	.brightness_set		= wrap_power_led_set,
 	.default_trigger	= "default-on",
+	.max_brightness		= LED_FULL,
 };
 
 static struct led_classdev wrap_error_led = {
 	.name		= "wrap::error",
 	.brightness_set	= wrap_error_led_set,
+	.max_brightness	= LED_FULL,
 };
 
 static struct led_classdev wrap_extra_led = {
 	.name           = "wrap::extra",
 	.brightness_set = wrap_extra_led_set,
+	.max_brightness	= LED_FULL,
 };
 
 #ifdef CONFIG_PM
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
diff --git a/drivers/leds/ledtrig-default-on.c b/drivers/leds/ledtrig-default-on.c
index 92995e4..a4ef54b 100644
--- a/drivers/leds/ledtrig-default-on.c
+++ b/drivers/leds/ledtrig-default-on.c
@@ -19,7 +19,7 @@
 
 static void defon_trig_activate(struct led_classdev *led_cdev)
 {
-	led_set_brightness(led_cdev, LED_FULL);
+	led_set_brightness(led_cdev, led_cdev->max_brightness);
 }
 
 static struct led_trigger defon_led_trigger = {
diff --git a/drivers/leds/ledtrig-heartbeat.c b/drivers/leds/ledtrig-heartbeat.c
index 4bf8cec..c1c1ea6 100644
--- a/drivers/leds/ledtrig-heartbeat.c
+++ b/drivers/leds/ledtrig-heartbeat.c
@@ -47,7 +47,7 @@ static void led_heartbeat_function(unsigned long data)
 			msecs_to_jiffies(heartbeat_data->period);
 		delay = msecs_to_jiffies(70);
 		heartbeat_data->phase++;
-		brightness = LED_FULL;
+		brightness = led_cdev->max_brightness;
 		break;
 	case 1:
 		delay = heartbeat_data->period / 4 - msecs_to_jiffies(70);
@@ -56,7 +56,7 @@ static void led_heartbeat_function(unsigned long data)
 	case 2:
 		delay = msecs_to_jiffies(70);
 		heartbeat_data->phase++;
-		brightness = LED_FULL;
+		brightness = led_cdev->max_brightness;
 		break;
 	default:
 		delay = heartbeat_data->period - heartbeat_data->period / 4 -
diff --git a/drivers/leds/ledtrig-ide-disk.c b/drivers/leds/ledtrig-ide-disk.c
index 883a577..ec099fc 100644
--- a/drivers/leds/ledtrig-ide-disk.c
+++ b/drivers/leds/ledtrig-ide-disk.c
@@ -37,7 +37,8 @@ static void ledtrig_ide_timerfunc(unsigned long data)
 {
 	if (ide_lastactivity != ide_activity) {
 		ide_lastactivity = ide_activity;
-		led_trigger_event(ledtrig_ide, LED_FULL);
+		/* INT_MAX will set each LED to its maximum brightness */
+		led_trigger_event(ledtrig_ide, INT_MAX);
 		mod_timer(&ledtrig_ide_timer, jiffies + msecs_to_jiffies(10));
 	} else {
 		led_trigger_event(ledtrig_ide, LED_OFF);
diff --git a/drivers/leds/ledtrig-timer.c b/drivers/leds/ledtrig-timer.c
index db68196..6e8bb0e 100644
--- a/drivers/leds/ledtrig-timer.c
+++ b/drivers/leds/ledtrig-timer.c
@@ -166,7 +166,7 @@ static void timer_trig_activate(struct led_classdev *led_cdev)
 
 	timer_data->brightness_on = led_get_brightness(led_cdev);
 	if (timer_data->brightness_on == LED_OFF)
-		timer_data->brightness_on = LED_FULL;
+		timer_data->brightness_on = led_cdev->max_brightness;
 	led_cdev->trigger_data = timer_data;
 
 	init_timer(&timer_data->timer);
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
