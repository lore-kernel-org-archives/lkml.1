Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018Ab0BBHwY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 02:52:24 -0500
Received: from iksaif.net ([88.191.73.63]:50263 "EHLO iksaif.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755805Ab0BBHwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 02:52:09 -0500
From: Corentin Chary <corentincj@iksaif.net>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, acpi4asus-user@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Corentin Chary <corentincj@iksaif.net>
Subject: [PATCH 26/28] asus-laptop: clean led code
Date: Tue,  2 Feb 2010 08:39:09 +0100
Message-Id: <1265096351-15239-27-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1265096351-15239-26-git-send-email-corentincj@iksaif.net>
References: <1265096351-15239-1-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-2-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-3-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-4-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-5-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-6-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-7-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-8-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-9-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-10-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-11-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-12-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-13-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-14-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-15-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-16-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-17-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-18-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-19-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-20-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-21-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-22-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-23-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-24-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-25-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-26-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove all "templates" and add a generic struct asus_led instead.

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/platform/x86/asus-laptop.c |  235 ++++++++++++++++++------------------
 1 files changed, 115 insertions(+), 120 deletions(-)

diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index e1df92a..ae53026 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -193,29 +193,12 @@ ASUS_HANDLE(display_get,
 /*
  * Define a specific led structure to keep the main structure clean
  */
-#define ASUS_DEFINE_LED(object)					\
-	int object##_wk;					\
-	struct work_struct object##_work;			\
-	struct led_classdev object;
-
-
-#define led_to_asus(led_cdev, led)					\
-	container_of(container_of(led_cdev, struct asus_laptop_leds,	\
-				  led),					\
-		     struct asus_laptop, leds)
-#define work_to_asus(work, led)						\
-	container_of(container_of(work, struct asus_laptop_leds,	\
-				  led##_work),				\
-		     struct asus_laptop, leds)
-
-struct asus_laptop_leds {
-	ASUS_DEFINE_LED(mled)
-	ASUS_DEFINE_LED(tled)
-	ASUS_DEFINE_LED(rled)
-	ASUS_DEFINE_LED(pled)
-	ASUS_DEFINE_LED(gled)
-	ASUS_DEFINE_LED(kled)
-	struct workqueue_struct *workqueue;
+struct asus_led {
+	int wk;
+	struct work_struct work;
+	struct led_classdev led;
+	struct asus_laptop *asus;
+	const char *method;
 };
 
 /*
@@ -233,7 +216,13 @@ struct asus_laptop {
 	struct input_dev *inputdev;
 	struct key_entry *keymap;
 
-	struct asus_laptop_leds leds;
+	struct asus_led mled;
+	struct asus_led tled;
+	struct asus_led rled;
+	struct asus_led pled;
+	struct asus_led gled;
+	struct asus_led kled;
+	struct workqueue_struct *led_workqueue;
 
 	int wireless_status;
 	bool have_rsts;
@@ -353,7 +342,7 @@ static int acpi_check_handle(acpi_handle handle, const char *method,
 }
 
 /* Generic LED function */
-static int asus_led_set(struct asus_laptop *asus, char *method,
+static int asus_led_set(struct asus_laptop *asus, const char *method,
 			 int value)
 {
 	if (!strcmp(method, METHOD_MLED))
@@ -369,50 +358,29 @@ static int asus_led_set(struct asus_laptop *asus, char *method,
 /*
  * LEDs
  */
-#define ASUS_LED(object, ledname, max)					\
-	static void object##_led_set(struct led_classdev *led_cdev,	\
-				     enum led_brightness value);	\
-	static enum led_brightness object##_led_get(			\
-		struct led_classdev *led_cdev);				\
-	static void object##_led_update(struct work_struct *ignored);
-
-ASUS_LED(mled, "mail", 1);
-ASUS_LED(tled, "touchpad", 1);
-ASUS_LED(rled, "record", 1);
-ASUS_LED(pled, "phone", 1);
-ASUS_LED(gled, "gaming", 1);
-ASUS_LED(kled, "kbd_backlight", 3);
-
 /* /sys/class/led handlers */
-#define ASUS_LED_HANDLER(object, method)				\
-	static void object##_led_set(struct led_classdev *led_cdev,	\
-				     enum led_brightness value)		\
-	{								\
-		struct asus_laptop *asus =				\
-			led_to_asus(led_cdev, object);			\
-									\
-		asus->leds.object##_wk = (value > 0) ? 1 : 0;		\
-		queue_work(asus->leds.workqueue,			\
-			   &asus->leds.object##_work);			\
-	}								\
-	static void object##_led_update(struct work_struct *work)	\
-	{								\
-		struct asus_laptop *asus = work_to_asus(work, object);	\
-									\
-		int value = asus->leds.object##_wk;			\
-		asus_led_set(asus, method, value);			\
-	}								\
-	static enum led_brightness object##_led_get(			\
-		struct led_classdev *led_cdev)				\
-	{								\
-		return led_cdev->brightness;				\
-	}
+static void asus_led_cdev_set(struct led_classdev *led_cdev,
+			 enum led_brightness value)
+{
+	struct asus_led *led = container_of(led_cdev, struct asus_led, led);
+	struct asus_laptop *asus = led->asus;
+
+	led->wk = !!value;
+	queue_work(asus->led_workqueue, &led->work);
+}
+
+static void asus_led_cdev_update(struct work_struct *work)
+{
+	struct asus_led *led = container_of(work, struct asus_led, work);
+	struct asus_laptop *asus = led->asus;
 
-ASUS_LED_HANDLER(mled, METHOD_MLED);
-ASUS_LED_HANDLER(pled, METHOD_PLED);
-ASUS_LED_HANDLER(rled, METHOD_RLED);
-ASUS_LED_HANDLER(tled, METHOD_TLED);
-ASUS_LED_HANDLER(gled, METHOD_GLED);
+	asus_led_set(asus, led->method, led->wk);
+}
+
+static enum led_brightness asus_led_cdev_get(struct led_classdev *led_cdev)
+{
+	return led_cdev->brightness;
+}
 
 /*
  * Keyboard backlight (also a LED)
@@ -452,70 +420,76 @@ static int asus_kled_set(struct asus_laptop *asus, int kblv)
 	return 0;
 }
 
-static void kled_led_set(struct led_classdev *led_cdev,
-			 enum led_brightness value)
+static void asus_kled_cdev_set(struct led_classdev *led_cdev,
+			      enum led_brightness value)
 {
-	struct asus_laptop *asus = led_to_asus(led_cdev, kled);
+	struct asus_led *led = container_of(led_cdev, struct asus_led, led);
+	struct asus_laptop *asus = led->asus;
 
-	asus->leds.kled_wk = value;
-	queue_work(asus->leds.workqueue, &asus->leds.kled_work);
+        led->wk = value;
+	queue_work(asus->led_workqueue, &led->work);
 }
 
-static void kled_led_update(struct work_struct *work)
+static void asus_kled_cdev_update(struct work_struct *work)
 {
-	struct asus_laptop *asus = work_to_asus(work, kled);
+	struct asus_led *led = container_of(work, struct asus_led, work);
+	struct asus_laptop *asus = led->asus;
 
-	asus_kled_set(asus, asus->leds.kled_wk);
+	asus_kled_set(asus, led->wk);
 }
 
-static enum led_brightness kled_led_get(struct led_classdev *led_cdev)
+static enum led_brightness asus_kled_cdev_get(struct led_classdev *led_cdev)
 {
-	struct asus_laptop *asus = led_to_asus(led_cdev, kled);
+	struct asus_led *led = container_of(led_cdev, struct asus_led, led);
+	struct asus_laptop *asus = led->asus;
 
 	return asus_kled_lvl(asus);
 }
 
 static void asus_led_exit(struct asus_laptop *asus)
 {
-	if (asus->leds.mled.dev)
-		led_classdev_unregister(&asus->leds.mled);
-	if (asus->leds.tled.dev)
-		led_classdev_unregister(&asus->leds.tled);
-	if (asus->leds.pled.dev)
-		led_classdev_unregister(&asus->leds.pled);
-	if (asus->leds.rled.dev)
-		led_classdev_unregister(&asus->leds.rled);
-	if (asus->leds.gled.dev)
-		led_classdev_unregister(&asus->leds.gled);
-	if (asus->leds.kled.dev)
-		led_classdev_unregister(&asus->leds.kled);
-	if (asus->leds.workqueue) {
-		destroy_workqueue(asus->leds.workqueue);
-		asus->leds.workqueue = NULL;
+	if (asus->mled.led.dev)
+		led_classdev_unregister(&asus->mled.led);
+	if (asus->tled.led.dev)
+		led_classdev_unregister(&asus->tled.led);
+	if (asus->pled.led.dev)
+		led_classdev_unregister(&asus->pled.led);
+	if (asus->rled.led.dev)
+		led_classdev_unregister(&asus->rled.led);
+	if (asus->gled.led.dev)
+		led_classdev_unregister(&asus->gled.led);
+	if (asus->kled.led.dev)
+		led_classdev_unregister(&asus->kled.led);
+	if (asus->led_workqueue) {
+		destroy_workqueue(asus->led_workqueue);
+		asus->led_workqueue = NULL;
 	}
 }
 
 /*  Ugly macro, need to fix that later */
-#define ASUS_LED_REGISTER(asus, object, _name, max, method)		\
-	do {								\
-		struct led_classdev *ldev = &asus->leds.object;		\
-									\
-		if (method && acpi_check_handle(asus->handle, method, NULL)) \
-			break ;						\
-									\
-		INIT_WORK(&asus->leds.object##_work, object##_led_update); \
-		ldev->name = "asus::" _name;				\
-		ldev->brightness_set = object##_led_set;		\
-		ldev->brightness_get = object##_led_get;		\
-		ldev->max_brightness = max;				\
-		rv = led_classdev_register(&asus->platform_device->dev, ldev); \
-		if (rv)							\
-			goto error;					\
-	} while (0)
+static int asus_led_register(struct asus_laptop *asus,
+			     struct asus_led *led,
+			     const char *name, const char *method)
+{
+	struct led_classdev *led_cdev = &led->led;
+
+	if (!method || acpi_check_handle(asus->handle, method, NULL))
+	    return 0; /* Led not present */
+
+	led->asus = asus;
+	led->method = method;
+
+	INIT_WORK(&led->work, asus_led_cdev_update);
+	led_cdev->name = name;
+	led_cdev->brightness_set = asus_led_cdev_set;
+	led_cdev->brightness_get = asus_led_cdev_get;
+	led_cdev->max_brightness = 1;
+	return led_classdev_register(&asus->platform_device->dev, led_cdev);
+}
 
 static int asus_led_init(struct asus_laptop *asus)
 {
-	int rv;
+	int r;
 
 	/*
 	 * Functions that actually update the LED's are called from a
@@ -523,22 +497,43 @@ static int asus_led_init(struct asus_laptop *asus)
 	 * subsystem asks, we avoid messing with the Asus ACPI stuff during a
 	 * potentially bad time, such as a timer interrupt.
 	 */
-	asus->leds.workqueue = create_singlethread_workqueue("led_workqueue");
-	if (!asus->leds.workqueue)
+	asus->led_workqueue = create_singlethread_workqueue("led_workqueue");
+	if (!asus->led_workqueue)
 		return -ENOMEM;
 
-	ASUS_LED_REGISTER(asus, mled, "mail", 1, METHOD_MLED);
-	ASUS_LED_REGISTER(asus, tled, "touchpad", 1, METHOD_TLED);
-	ASUS_LED_REGISTER(asus, rled, "record", 1, METHOD_RLED);
-	ASUS_LED_REGISTER(asus, pled, "phone", 1, METHOD_PLED);
-	ASUS_LED_REGISTER(asus, gled, "gaming", 1, METHOD_GLED);
+	r = asus_led_register(asus, &asus->mled, "asus::mail", METHOD_MLED);
+	if (r)
+		goto error;
+	r = asus_led_register(asus, &asus->tled, "asus::touchpad", METHOD_TLED);
+	if (r)
+		goto error;
+	r = asus_led_register(asus, &asus->rled, "asus::record", METHOD_RLED);
+	if (r)
+		goto error;
+	r = asus_led_register(asus, &asus->pled, "asus::phone", METHOD_PLED);
+	if (r)
+		goto error;
+	r = asus_led_register(asus, &asus->gled, "asus::gaming", METHOD_GLED);
+	if (r)
+		goto error;
 	if (!acpi_check_handle(asus->handle, METHOD_KBD_LIGHT_SET, NULL) &&
-	    !acpi_check_handle(asus->handle, METHOD_KBD_LIGHT_GET, NULL))
-		ASUS_LED_REGISTER(asus, kled, "kbd_backlight", 3, NULL);
+	    !acpi_check_handle(asus->handle, METHOD_KBD_LIGHT_GET, NULL)) {
+		struct asus_led *led = &asus->kled;
+		struct led_classdev *cdev = &led->led;
+
+		led->asus = asus;
+
+		INIT_WORK(&led->work, asus_kled_cdev_update);
+		cdev->name = "asus::kbd_backlight";
+		cdev->brightness_set = asus_kled_cdev_set;
+		cdev->brightness_get = asus_kled_cdev_get;
+		cdev->max_brightness = 3;
+		r = led_classdev_register(&asus->platform_device->dev, cdev);
+	}
 error:
-	if (rv)
+	if (r)
 		asus_led_exit(asus);
-	return rv;
+	return r;
 }
 
 /*
-- 
1.6.6.1

