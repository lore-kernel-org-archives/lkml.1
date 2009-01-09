Return-Path: <linux-kernel-owner+w=401wt.eu-S1755549AbZAIJUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549AbZAIJUr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 04:20:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751132AbZAIJUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 04:20:31 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36415 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbZAIJU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 04:20:28 -0500
Date: Fri, 9 Jan 2009 10:22:34 +0100
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>, hmh@hmh.eng.br,
       rpurdie@rpsys.net
Subject: thinkpad-acpi: split delayed LEDs stuff, clean up code.
Message-ID: <20090109092234.GA2064@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduce code duplication and clean up thinkpad_acpi a bit. The code is
already in shape where it can be used for HP accelerometer LED (but that
one needs to trickle from -mm to Linus, first).

Signed-off-by: Pavel Machek <pavel@suse.cz>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Richard Purdie <rpurdie@rpsys.net>

diff --git a/drivers/misc/thinkpad_acpi.c b/drivers/misc/thinkpad_acpi.c
index 899766e..486b248 100644
--- a/drivers/misc/thinkpad_acpi.c
+++ b/drivers/misc/thinkpad_acpi.c
@@ -69,6 +69,8 @@ #include <linux/hwmon-sysfs.h>
 #include <linux/input.h>
 #include <linux/leds.h>
 #include <linux/rfkill.h>
+#include <linux/delayed-leds.h>
+
 #include <asm/uaccess.h>
 
 #include <linux/dmi.h>
@@ -80,7 +82,6 @@ #include <acpi/acnamesp.h>
 
 #include <linux/pci_ids.h>
 
-
 /* ThinkPad CMOS commands */
 #define TP_CMOS_VOLUME_DOWN	0
 #define TP_CMOS_VOLUME_UP	1
@@ -281,13 +282,8 @@ static u32 dbg_level;
 
 static struct workqueue_struct *tpacpi_wq;
 
-/* Special LED class that can defer work */
-struct tpacpi_led_classdev {
-	struct led_classdev led_classdev;
-	struct work_struct work;
-	enum led_brightness new_brightness;
-	unsigned int led;
-};
+
+
 
 /****************************************************************************
  ****************************************************************************
@@ -3463,9 +3459,13 @@ static int light_get_status(void)
 	return -ENXIO;
 }
 
-static int light_set_status(int status)
+static int light_set_brightness(struct delayed_led_classdev *data, enum led_brightness value)
 {
 	int rc;
+	int status = (value != LED_OFF);
+
+	if (tpacpi_lifecycle != TPACPI_LIFE_RUNNING)
+		return -EINVAL;
 
 	if (tp_features.light) {
 		if (cmos_handle) {
@@ -3483,37 +3483,19 @@ static int light_set_status(int status)
 	return -ENXIO;
 }
 
-static void light_set_status_worker(struct work_struct *work)
-{
-	struct tpacpi_led_classdev *data =
-			container_of(work, struct tpacpi_led_classdev, work);
-
-	if (likely(tpacpi_lifecycle == TPACPI_LIFE_RUNNING))
-		light_set_status((data->new_brightness != LED_OFF));
-}
-
-static void light_sysfs_set(struct led_classdev *led_cdev,
-			enum led_brightness brightness)
-{
-	struct tpacpi_led_classdev *data =
-		container_of(led_cdev,
-			     struct tpacpi_led_classdev,
-			     led_classdev);
-	data->new_brightness = brightness;
-	queue_work(tpacpi_wq, &data->work);
-}
 
 static enum led_brightness light_sysfs_get(struct led_classdev *led_cdev)
 {
 	return (light_get_status() == 1)? LED_FULL : LED_OFF;
 }
 
-static struct tpacpi_led_classdev tpacpi_led_thinklight = {
+static struct delayed_led_classdev tpacpi_led_thinklight = {
 	.led_classdev = {
 		.name		= "tpacpi::thinklight",
-		.brightness_set	= &light_sysfs_set,
+		.brightness_set	= &delayed_sysfs_set,
 		.brightness_get	= &light_sysfs_get,
-	}
+	},
+	.set_brightness = light_set_brightness,
 };
 
 static int __init light_init(struct ibm_init_struct *iibm)
@@ -3525,7 +3507,7 @@ static int __init light_init(struct ibm_
 	TPACPI_ACPIHANDLE_INIT(ledb);
 	TPACPI_ACPIHANDLE_INIT(lght);
 	TPACPI_ACPIHANDLE_INIT(cmos);
-	INIT_WORK(&tpacpi_led_thinklight.work, light_set_status_worker);
+	INIT_WORK(&tpacpi_led_thinklight.work, delayed_set_status_worker);
 
 	/* light not supported on 570, 600e/x, 770e, 770x, G4x, R30, R31 */
 	tp_features.light = (cmos_handle || lght_handle) && !ledb_handle;
@@ -3559,8 +3541,8 @@ static int __init light_init(struct ibm_
 static void light_exit(void)
 {
 	led_classdev_unregister(&tpacpi_led_thinklight.led_classdev);
-	if (work_pending(&tpacpi_led_thinklight.work))
-		flush_workqueue(tpacpi_wq);
+	while (work_pending(&tpacpi_led_thinklight.work))
+		schedule();
 }
 
 static int light_read(char *p)
@@ -3601,7 +3583,7 @@ static int light_write(char *buf)
 			return -EINVAL;
 	}
 
-	return light_set_status(newstatus);
+	return light_set_brightness(&tpacpi_led_thinklight, newstatus);
 }
 
 static struct ibm_struct light_driver_data = {
@@ -4021,7 +4003,7 @@ TPACPI_HANDLE(led, ec, "SLED",	/* 570 */
 	   );			/* R30, R31 */
 
 #define TPACPI_LED_NUMLEDS 8
-static struct tpacpi_led_classdev *tpacpi_leds;
+static struct delayed_led_classdev *tpacpi_leds;
 static enum led_status_t tpacpi_led_state_cache[TPACPI_LED_NUMLEDS];
 static const char * const tpacpi_led_names[TPACPI_LED_NUMLEDS] = {
 	/* there's a limit of 19 chars + NULL before 2.6.26 */
@@ -4065,7 +4047,6 @@ static int led_set_status(const unsigned
 	/* off, on, blink. Index is led_status_t */
 	static const unsigned int led_sled_arg1[] = { 0, 1, 3 };
 	static const unsigned int led_led_arg1[] = { 0, 0x80, 0xc0 };
-
 	int rc = 0;
 
 	switch (led_supported) {
@@ -4105,40 +4086,21 @@ static int led_set_status(const unsigned
 	return rc;
 }
 
-static void led_sysfs_set_status(unsigned int led,
-				 enum led_brightness brightness)
+static int led_set_class_brightness(struct delayed_led_classdev *data, enum led_brightness value)
 {
-	led_set_status(led,
-			(brightness == LED_OFF) ?
-			TPACPI_LED_OFF :
-			(tpacpi_led_state_cache[led] == TPACPI_LED_BLINK) ?
-				TPACPI_LED_BLINK : TPACPI_LED_ON);
-}
-
-static void led_set_status_worker(struct work_struct *work)
-{
-	struct tpacpi_led_classdev *data =
-		container_of(work, struct tpacpi_led_classdev, work);
-
-	if (likely(tpacpi_lifecycle == TPACPI_LIFE_RUNNING))
-		led_sysfs_set_status(data->led, data->new_brightness);
-}
-
-static void led_sysfs_set(struct led_classdev *led_cdev,
-			enum led_brightness brightness)
-{
-	struct tpacpi_led_classdev *data = container_of(led_cdev,
-			     struct tpacpi_led_classdev, led_classdev);
-
-	data->new_brightness = brightness;
-	queue_work(tpacpi_wq, &data->work);
+	if (tpacpi_lifecycle != TPACPI_LIFE_RUNNING)
+		return -EINVAL;
+	return led_set_status(data->led, (value == LED_OFF) ?
+                       TPACPI_LED_OFF :
+                       (tpacpi_led_state_cache[data->led] == TPACPI_LED_BLINK) ?
+                              TPACPI_LED_BLINK : TPACPI_LED_ON);
 }
 
 static int led_sysfs_blink_set(struct led_classdev *led_cdev,
 			unsigned long *delay_on, unsigned long *delay_off)
 {
-	struct tpacpi_led_classdev *data = container_of(led_cdev,
-			     struct tpacpi_led_classdev, led_classdev);
+	struct delayed_led_classdev *data = container_of(led_cdev,
+			     struct delayed_led_classdev, led_classdev);
 
 	/* Can we choose the flash rate? */
 	if (*delay_on == 0 && *delay_off == 0) {
@@ -4149,7 +4111,7 @@ static int led_sysfs_blink_set(struct le
 		return -EINVAL;
 
 	data->new_brightness = TPACPI_LED_BLINK;
-	queue_work(tpacpi_wq, &data->work);
+	schedule_work(&data->work);
 
 	return 0;
 }
@@ -4158,8 +4120,8 @@ static enum led_brightness led_sysfs_get
 {
 	int rc;
 
-	struct tpacpi_led_classdev *data = container_of(led_cdev,
-			     struct tpacpi_led_classdev, led_classdev);
+	struct delayed_led_classdev *data = container_of(led_cdev,
+			     struct delayed_led_classdev, led_classdev);
 
 	rc = led_get_status(data->led);
 
@@ -4218,15 +4180,16 @@ static int __init led_init(struct ibm_in
 	for (i = 0; i < TPACPI_LED_NUMLEDS; i++) {
 		tpacpi_leds[i].led = i;
 
-		tpacpi_leds[i].led_classdev.brightness_set = &led_sysfs_set;
+		tpacpi_leds[i].led_classdev.brightness_set = &delayed_sysfs_set;
 		tpacpi_leds[i].led_classdev.blink_set = &led_sysfs_blink_set;
 		if (led_supported == TPACPI_LED_570)
 			tpacpi_leds[i].led_classdev.brightness_get =
 							&led_sysfs_get;
 
 		tpacpi_leds[i].led_classdev.name = tpacpi_led_names[i];
+		tpacpi_leds[i].set_brightness = led_set_class_brightness;
 
-		INIT_WORK(&tpacpi_leds[i].work, led_set_status_worker);
+		INIT_WORK(&tpacpi_leds[i].work, delayed_set_status_worker);
 
 		rc = led_classdev_register(&tpacpi_pdev->dev,
 					   &tpacpi_leds[i].led_classdev);
diff --git a/include/linux/delayed-leds.h b/include/linux/delayed-leds.h
new file mode 100644
index 0000000..1b5cacf
--- /dev/null
+++ b/include/linux/delayed-leds.h
@@ -0,0 +1,39 @@
+/*
+ *  delayed-leds.h - LEDs that can't be set from atomic context
+ *
+ *
+ *  Copyright (C) 2004-2005 Borislav Deianov <borislav@users.sf.net>
+ *  Copyright (C) 2006-2008 Henrique de Moraes Holschuh <hmh@hmh.eng.br>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ */
+
+/* Special LED class that can defer work */
+struct delayed_led_classdev {
+	struct led_classdev led_classdev;
+	struct work_struct work;
+	enum led_brightness new_brightness;
+
+	unsigned int led;		/* For driver */
+	int (*set_brightness)(struct delayed_led_classdev *data, enum led_brightness value);
+};
+
+static void delayed_set_status_worker(struct work_struct *work)
+{
+	struct delayed_led_classdev *data =
+			container_of(work, struct delayed_led_classdev, work);
+
+	data->set_brightness(data, data->new_brightness);
+}
+
+static void delayed_sysfs_set(struct led_classdev *led_cdev,
+			      enum led_brightness brightness)
+{
+	struct delayed_led_classdev *data = container_of(led_cdev,
+			     struct delayed_led_classdev, led_classdev);
+	data->new_brightness = brightness;
+	schedule_work(&data->work);
+}



-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
