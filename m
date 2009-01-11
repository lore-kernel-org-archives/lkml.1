Return-Path: <linux-kernel-owner+w=401wt.eu-S1753769AbZAKWlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769AbZAKWlu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 17:41:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751568AbZAKWll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 17:41:41 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59439 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbZAKWli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 17:41:38 -0500
Date: Sun, 11 Jan 2009 23:43:31 +0100
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>, hmh@hmh.eng.br,
       rpurdie@rpsys.net
Subject: introduce delayed-leds.h to reduce code duplication
Message-ID: <20090111224331.GA28010@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="pWyiEgJYm5f9v55/"
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


What about something like this? 

[Alternatively, I can add a flag to the leds class, and make delayed
leds a built-in functionality...]

[Attached is driver that uses new infrastructure for hp_accel, but it
does a bit more.]

---
 
It reduces code duplication and cleans
up code a bit. The code is already useful for thinkpad and hp_accel,
and there's one more driver that could use conversion.

Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 3478453..ee68654 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -69,6 +69,8 @@ #include <linux/hwmon-sysfs.h>
 #include <linux/input.h>
 #include <linux/leds.h>
 #include <linux/rfkill.h>
+#include <linux/delayed-leds.h>
+
 #include <asm/uaccess.h>
 
 #include <linux/dmi.h>
@@ -79,7 +81,6 @@ #include <acpi/acpi_drivers.h>
 
 #include <linux/pci_ids.h>
 
-
 /* ThinkPad CMOS commands */
 #define TP_CMOS_VOLUME_DOWN	0
 #define TP_CMOS_VOLUME_UP	1
@@ -280,13 +281,8 @@ static u32 dbg_level;
 
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
@@ -3462,9 +3458,13 @@ static int light_get_status(void)
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
@@ -3482,37 +3482,24 @@ static int light_set_status(int status)
 	return -ENXIO;
 }
 
-static void light_set_status_worker(struct work_struct *work)
+static void light_set_class_brightness(struct delayed_led_classdev *data, enum led_brightness value)
 {
-	struct tpacpi_led_classdev *data =
-			container_of(work, struct tpacpi_led_classdev, work);
-
-	if (likely(tpacpi_lifecycle == TPACPI_LIFE_RUNNING))
-		light_set_status((data->new_brightness != LED_OFF));
+	light_set_brightness(data, value);
 }
 
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
+	.set_brightness = light_set_class_brightness,
 };
 
 static int __init light_init(struct ibm_init_struct *iibm)
@@ -3524,7 +3511,7 @@ static int __init light_init(struct ibm_
 	TPACPI_ACPIHANDLE_INIT(ledb);
 	TPACPI_ACPIHANDLE_INIT(lght);
 	TPACPI_ACPIHANDLE_INIT(cmos);
-	INIT_WORK(&tpacpi_led_thinklight.work, light_set_status_worker);
+	INIT_WORK(&tpacpi_led_thinklight.work, delayed_set_status_worker);
 
 	/* light not supported on 570, 600e/x, 770e, 770x, G4x, R30, R31 */
 	tp_features.light = (cmos_handle || lght_handle) && !ledb_handle;
@@ -3558,8 +3545,8 @@ static int __init light_init(struct ibm_
 static void light_exit(void)
 {
 	led_classdev_unregister(&tpacpi_led_thinklight.led_classdev);
-	if (work_pending(&tpacpi_led_thinklight.work))
-		flush_workqueue(tpacpi_wq);
+	while (work_pending(&tpacpi_led_thinklight.work))
+		schedule();
 }
 
 static int light_read(char *p)
@@ -3600,7 +3587,7 @@ static int light_write(char *buf)
 			return -EINVAL;
 	}
 
-	return light_set_status(newstatus);
+	return light_set_brightness(&tpacpi_led_thinklight, newstatus);
 }
 
 static struct ibm_struct light_driver_data = {
@@ -4020,7 +4007,7 @@ TPACPI_HANDLE(led, ec, "SLED",	/* 570 */
 	   );			/* R30, R31 */
 
 #define TPACPI_LED_NUMLEDS 8
-static struct tpacpi_led_classdev *tpacpi_leds;
+static struct delayed_led_classdev *tpacpi_leds;
 static enum led_status_t tpacpi_led_state_cache[TPACPI_LED_NUMLEDS];
 static const char * const tpacpi_led_names[TPACPI_LED_NUMLEDS] = {
 	/* there's a limit of 19 chars + NULL before 2.6.26 */
@@ -4064,7 +4051,6 @@ static int led_set_status(const unsigned
 	/* off, on, blink. Index is led_status_t */
 	static const unsigned int led_sled_arg1[] = { 0, 1, 3 };
 	static const unsigned int led_led_arg1[] = { 0, 0x80, 0xc0 };
-
 	int rc = 0;
 
 	switch (led_supported) {
@@ -4104,40 +4090,21 @@ static int led_set_status(const unsigned
 	return rc;
 }
 
-static void led_sysfs_set_status(unsigned int led,
-				 enum led_brightness brightness)
-{
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
+static void led_set_class_brightness(struct delayed_led_classdev *data, enum led_brightness value)
 {
-	struct tpacpi_led_classdev *data = container_of(led_cdev,
-			     struct tpacpi_led_classdev, led_classdev);
-
-	data->new_brightness = brightness;
-	queue_work(tpacpi_wq, &data->work);
+	if (tpacpi_lifecycle != TPACPI_LIFE_RUNNING)
+		return;
+	led_set_status(data->led, (value == LED_OFF) ?
+                       TPACPI_LED_OFF :
+                       (tpacpi_led_state_cache[data->led] == TPACPI_LED_BLINK) ?
+		       TPACPI_LED_BLINK : TPACPI_LED_ON);
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
@@ -4148,7 +4115,7 @@ static int led_sysfs_blink_set(struct le
 		return -EINVAL;
 
 	data->new_brightness = TPACPI_LED_BLINK;
-	queue_work(tpacpi_wq, &data->work);
+	schedule_work(&data->work);
 
 	return 0;
 }
@@ -4157,8 +4124,8 @@ static enum led_brightness led_sysfs_get
 {
 	int rc;
 
-	struct tpacpi_led_classdev *data = container_of(led_cdev,
-			     struct tpacpi_led_classdev, led_classdev);
+	struct delayed_led_classdev *data = container_of(led_cdev,
+			     struct delayed_led_classdev, led_classdev);
 
 	rc = led_get_status(data->led);
 
@@ -4217,15 +4184,16 @@ static int __init led_init(struct ibm_in
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
index 0000000..31644b8
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
+	void (*set_brightness)(struct delayed_led_classdev *data, enum led_brightness value);
+};
+
+static inline void delayed_set_status_worker(struct work_struct *work)
+{
+	struct delayed_led_classdev *data =
+			container_of(work, struct delayed_led_classdev, work);
+
+	data->set_brightness(data, data->new_brightness);
+}
+
+static inline void delayed_sysfs_set(struct led_classdev *led_cdev,
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

--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=delme

diff --git a/drivers/hwmon/hp_accel.c b/drivers/hwmon/hp_accel.c
index bd8497b..284508b 100644
--- a/drivers/hwmon/hp_accel.c
+++ b/drivers/hwmon/hp_accel.c
@@ -37,6 +37,7 @@ #include <linux/freezer.h>
 #include <linux/version.h>
 #include <linux/uaccess.h>
 #include <linux/leds.h>
+#include <linux/delayed-leds.h>
 #include <acpi/acpi_drivers.h>
 #include <asm/atomic.h>
 #include "lis3lv02d.h"
@@ -155,29 +156,52 @@ static struct dmi_system_id lis3lv02d_dm
  */
 };
 
-static acpi_status hpled_acpi_write(acpi_handle handle, int reg)
+static void hpled_set(struct delayed_led_classdev *led_cdev, enum led_brightness value)
 {
+	acpi_handle handle = adev.device->handle;
 	unsigned long long ret; /* Not used when writing */
 	union acpi_object in_obj[1];
 	struct acpi_object_list args = { 1, in_obj };
 
 	in_obj[0].type          = ACPI_TYPE_INTEGER;
-	in_obj[0].integer.value = reg;
+	in_obj[0].integer.value = !!value;
 
-	return acpi_evaluate_integer(handle, "ALED", &args, &ret);
+	acpi_evaluate_integer(handle, "ALED", &args, &ret);
 }
 
-static void hpled_set(struct led_classdev *led_cdev,
-			       enum led_brightness value)
+static struct delayed_led_classdev hpled_led = {
+	.led_classdev = {
+		.name			= "hp::hddprotect",
+		.default_trigger	= "none",
+		.brightness_set		= delayed_sysfs_set,
+		.flags                  = LED_CORE_SUSPENDRESUME,
+	},
+	.set_brightness = hpled_set,
+};
+
+static acpi_status
+lis3lv02d_get_resource(struct acpi_resource *resource, void *context)
 {
-	hpled_acpi_write(adev.device->handle, !!value);
+	if (resource->type == ACPI_RESOURCE_TYPE_EXTENDED_IRQ) {
+		struct acpi_resource_extended_irq *irq;
+		u32 *device_irq = context;
+
+		irq = &resource->data.extended_irq;
+		*device_irq = irq->interrupts[0];
+	}
+
+	return AE_OK;
 }
 
-static struct led_classdev hpled_led = {
-	.name			= "hp:red:hddprotection",
-	.default_trigger	= "heartbeat",
-	.brightness_set		= hpled_set,
-};
+static void lis3lv02d_enum_resources(struct acpi_device *device)
+{
+	acpi_status status;
+
+	status = acpi_walk_resources(device->handle, METHOD_NAME__CRS,
+					lis3lv02d_get_resource, &adev.irq);
+	if (ACPI_FAILURE(status))
+		printk(KERN_DEBUG DRIVER_NAME ": Error getting resources\n");
+}
 
 static int lis3lv02d_add(struct acpi_device *device)
 {
@@ -208,13 +232,20 @@ static int lis3lv02d_add(struct acpi_dev
 		adev.ac = lis3lv02d_axis_normal;
 	}
 
-	ret = led_classdev_register(NULL, &hpled_led);
+	INIT_WORK(&hpled_led.work, delayed_set_status_worker);
+	ret = led_classdev_register(NULL, &hpled_led.led_classdev);
 	if (ret)
 		return ret;
 
+	/* obtain IRQ number of our device from ACPI */
+	lis3lv02d_enum_resources(adev.device);
+
 	ret = lis3lv02d_init_device(&adev);
 	if (ret) {
-		led_classdev_unregister(&hpled_led);
+		while (work_pending(&hpled_led.work))
+			schedule();
+
+		led_classdev_unregister(&hpled_led.led_classdev);
 		return ret;
 	}
 
@@ -229,7 +260,9 @@ static int lis3lv02d_remove(struct acpi_
 	lis3lv02d_joystick_disable();
 	lis3lv02d_poweroff(device->handle);
 
-	led_classdev_unregister(&hpled_led);
+	while (work_pending(&hpled_led.work))
+		schedule();
+	led_classdev_unregister(&hpled_led.led_classdev);
 
 	return lis3lv02d_remove_fs();
 }
@@ -240,7 +273,6 @@ static int lis3lv02d_suspend(struct acpi
 {
 	/* make sure the device is off when we suspend */
 	lis3lv02d_poweroff(device->handle);
-	led_classdev_suspend(&hpled_led);
 	return 0;
 }
 
@@ -253,7 +285,6 @@ static int lis3lv02d_resume(struct acpi_
 	else
 		lis3lv02d_poweroff(device->handle);
 	mutex_unlock(&adev.lock);
-	led_classdev_resume(&hpled_led);
 	return 0;
 }
 #else
diff --git a/drivers/hwmon/lis3lv02d.c b/drivers/hwmon/lis3lv02d.c
index 219d2d0..7dc3eb2 100644
--- a/drivers/hwmon/lis3lv02d.c
+++ b/drivers/hwmon/lis3lv02d.c
@@ -35,6 +35,7 @@ #include <linux/wait.h>
 #include <linux/poll.h>
 #include <linux/freezer.h>
 #include <linux/uaccess.h>
+#include <linux/miscdevice.h>
 #include <acpi/acpi_drivers.h>
 #include <asm/atomic.h>
 #include "lis3lv02d.h"
@@ -52,10 +53,20 @@ #define MDPS_POLL_INTERVAL 50
  * joystick.
  */
 
+/*
+ * Automatic timeout to turn off the device in jiffies.
+ * Don't do it too early as it's quite costly to turn it on.
+ */
+#define MDPS_TIMEOUT msecs_to_jiffies(30 * 1000) /* 30 seconds */
 /* Maximum value our axis may get for the input device (signed 12 bits) */
 #define MDPS_MAX_VAL 2048
 
-struct acpi_lis3lv02d adev;
+struct acpi_lis3lv02d adev = {
+	.misc_wait   = __WAIT_QUEUE_HEAD_INITIALIZER(adev.misc_wait),
+	.usage       = 0,
+	.misc_opened = 0,
+};
+
 EXPORT_SYMBOL_GPL(adev);
 
 static int lis3lv02d_add_fs(struct acpi_device *device);
@@ -110,17 +121,14 @@ static void lis3lv02d_get_xyz(acpi_handl
 void lis3lv02d_poweroff(acpi_handle handle)
 {
 	adev.is_on = 0;
-	/* disable X,Y,Z axis and power down */
-	adev.write(handle, CTRL_REG1, 0x00);
 }
 EXPORT_SYMBOL_GPL(lis3lv02d_poweroff);
 
 void lis3lv02d_poweron(acpi_handle handle)
 {
-	u8 val;
-
 	adev.is_on = 1;
 	adev.init(handle);
+#if 0
 	adev.write(handle, FF_WU_CFG, 0);
 	/*
 	 * BDU: LSB and MSB values are not updated until both have been read.
@@ -130,6 +138,21 @@ void lis3lv02d_poweron(acpi_handle handl
 	adev.read(handle, CTRL_REG2, &val);
 	val |= CTRL2_BDU | CTRL2_IEN;
 	adev.write(handle, CTRL_REG2, val);
+	if (test_bit(0, &adev.misc_opened)) {
+#if 0
+		/* Threshold not too big (10) */
+		lis3lv02d_write_16(handle, FF_WU_THS_L, 10);
+#endif
+		/* FIXME: All this should be done by BIOS, automagically */
+		/* 2 samples in a row before activation */
+		adev.write(handle, FF_WU_DURATION, 2);
+		/* detect every direction, don't wait for validation */
+		adev.write(handle, FF_WU_CFG, FF_WU_CFG_AOI
+			   	   | FF_WU_CFG_XLIE | FF_WU_CFG_XHIE
+				   | FF_WU_CFG_YLIE | FF_WU_CFG_YHIE
+				   | FF_WU_CFG_ZLIE | FF_WU_CFG_ZHIE);
+	}
+#endif
 }
 EXPORT_SYMBOL_GPL(lis3lv02d_poweron);
 
@@ -162,6 +185,161 @@ static void lis3lv02d_decrease_use(struc
 	mutex_unlock(&dev->lock);
 }
 
+static void lis3lv02d_poweroff_timeout(unsigned long data)
+{
+	struct acpi_lis3lv02d *dev = (void *)data;
+	lis3lv02d_poweroff(dev->device->handle);
+	printk(KERN_DEBUG DRIVER_NAME ": Turning off the device\n");
+}
+
+static irqreturn_t lis302dl_interrupt(int irq, void *dummy)
+{
+//	unsigned long long lret;
+
+	/*
+	 * Be careful: on some HP laptops the bios force DD when on battery and
+	 * the lid is closed. This leads to interrupts as soon as a little move
+	 * is done.
+	 */
+	atomic_inc(&adev.count);
+
+	wake_up_interruptible(&adev.misc_wait);
+	kill_fasync(&adev.async_queue, SIGIO, POLL_IN);
+
+
+	printk("lis3_interrupt: its here\n");
+//	acpi_evaluate_object(adev.device->handle, "CLRI", NULL, &lret);
+
+	return IRQ_HANDLED;
+}
+
+static int lis3lv02d_misc_open(struct inode *inode, struct file *file)
+{
+	unsigned long long lret;
+	int ret;
+
+	printk("lis3: misc dev open\n");
+
+	if (test_and_set_bit(0, &adev.misc_opened))
+		return -EBUSY; /* already open */
+
+	atomic_set(&adev.count, 0);
+
+	/*
+	 * The sensor can generate interrupts for free-fall and direction
+	 * detection (distinguishable with FF_WU_SRC and DD_SRC) but to keep
+	 * the things simple and _fast_ we activate it only for free-fall, so
+	 * no need to read register (very slow with ACPI). For the same reason,
+	 * we forbid shared interrupts.
+	 *
+	 * IRQF_TRIGGER_RISING seems pointless on HP laptops because the
+	 * io-apic is not configurable (and generates a warning) but I keep it
+	 * in case of support for other hardware.
+	 */
+	ret = request_irq(adev.irq, lis302dl_interrupt, IRQF_TRIGGER_RISING,
+			  DRIVER_NAME, &adev);
+
+	if (ret) {
+		clear_bit(0, &adev.misc_opened);
+		printk(KERN_ERR DRIVER_NAME ": IRQ%d allocation failed\n", adev.irq);
+		return -EBUSY;
+	}
+	lis3lv02d_increase_use(&adev);
+	printk("lis3: registered interrupt %d\n", adev.irq);
+
+//	acpi_evaluate_object(adev.device->handle, "CLRI", NULL, &lret);
+	return 0;
+}
+
+static int lis3lv02d_misc_release(struct inode *inode, struct file *file)
+{
+	fasync_helper(-1, file, 0, &adev.async_queue);
+	lis3lv02d_decrease_use(&adev);
+	free_irq(adev.irq, &adev);
+	clear_bit(0, &adev.misc_opened); /* release the device */
+	return 0;
+}
+
+static ssize_t lis3lv02d_misc_read(struct file *file, char __user *buf,
+				size_t count, loff_t *pos)
+{
+	DECLARE_WAITQUEUE(wait, current);
+	u32 data;
+	unsigned char byte_data;
+	ssize_t retval = 1;
+
+	printk("lis3: read\n");
+
+	if (count < 1)
+		return -EINVAL;
+
+	add_wait_queue(&adev.misc_wait, &wait);
+	while (true) {
+		set_current_state(TASK_INTERRUPTIBLE);
+		data = atomic_xchg(&adev.count, 0);
+		if (data)
+			break;
+
+		if (file->f_flags & O_NONBLOCK) {
+			retval = -EAGAIN;
+			goto out;
+		}
+
+		if (signal_pending(current)) {
+			retval = -ERESTARTSYS;
+			goto out;
+		}
+
+		schedule();
+	}
+
+	if (data < 255)
+		byte_data = data;
+	else
+		byte_data = 255;
+
+	/* make sure we are not going into copy_to_user() with
+	 * TASK_INTERRUPTIBLE state */
+	set_current_state(TASK_RUNNING);
+	if (copy_to_user(buf, &byte_data, sizeof(byte_data)))
+		retval = -EFAULT;
+
+out:
+	__set_current_state(TASK_RUNNING);
+	remove_wait_queue(&adev.misc_wait, &wait);
+
+	return retval;
+}
+
+static unsigned int lis3lv02d_misc_poll(struct file *file, poll_table *wait)
+{
+	poll_wait(file, &adev.misc_wait, wait);
+	if (atomic_read(&adev.count))
+		return POLLIN | POLLRDNORM;
+	return 0;
+}
+
+static int lis3lv02d_misc_fasync(int fd, struct file *file, int on)
+{
+	return fasync_helper(fd, file, on, &adev.async_queue);
+}
+
+static const struct file_operations lis3lv02d_misc_fops = {
+	.owner   = THIS_MODULE,
+	.llseek  = no_llseek,
+	.read    = lis3lv02d_misc_read,
+	.open    = lis3lv02d_misc_open,
+	.release = lis3lv02d_misc_release,
+	.poll    = lis3lv02d_misc_poll,
+	.fasync  = lis3lv02d_misc_fasync,
+};
+
+static struct miscdevice lis3lv02d_misc_device = {
+	.minor   = MISC_DYNAMIC_MINOR,
+	.name    = "freefall",
+	.fops    = &lis3lv02d_misc_fops,
+};
+
 /**
  * lis3lv02d_joystick_kthread - Kthread polling function
  * @data: unused - here to conform to threadfn prototype
@@ -203,7 +381,6 @@ static void lis3lv02d_joystick_close(str
 	lis3lv02d_decrease_use(&adev);
 }
 
-
 static inline void lis3lv02d_calibrate_joystick(void)
 {
 	lis3lv02d_get_xyz(adev.device->handle, &adev.xcalib, &adev.ycalib, &adev.zcalib);
@@ -250,7 +427,9 @@ void lis3lv02d_joystick_disable(void)
 	if (!adev.idev)
 		return;
 
+	misc_deregister(&lis3lv02d_misc_device);
 	input_unregister_device(adev.idev);
+	del_timer(&adev.poff_timer);
 	adev.idev = NULL;
 }
 EXPORT_SYMBOL_GPL(lis3lv02d_joystick_disable);
@@ -261,13 +440,29 @@ EXPORT_SYMBOL_GPL(lis3lv02d_joystick_dis
  */
 int lis3lv02d_init_device(struct acpi_lis3lv02d *dev)
 {
+	printk("lis3_init_device\n");
 	mutex_init(&dev->lock);
 	lis3lv02d_add_fs(dev->device);
+	setup_timer(&dev->poff_timer, lis3lv02d_poweroff_timeout, (unsigned long)dev);
+	init_timer_deferrable(&dev->poff_timer);
 	lis3lv02d_increase_use(dev);
 
 	if (lis3lv02d_joystick_enable())
 		printk(KERN_ERR DRIVER_NAME ": joystick initialization failed\n");
 
+	printk("lis3_init_device: irq %d\n", dev->irq);
+
+	/* if we did not get an IRQ from ACPI - we have nothing more to do */
+	if (!dev->irq) {
+		printk(KERN_ERR DRIVER_NAME
+			": No IRQ in ACPI. Disabling /dev/accel\n");
+		goto out;
+	}
+
+	printk("lis3: registering device\n");
+	if (misc_register(&lis3lv02d_misc_device))
+		printk(KERN_ERR DRIVER_NAME ": misc_register failed\n");
+out:
 	lis3lv02d_decrease_use(dev);
 	return 0;
 }
diff --git a/drivers/hwmon/lis3lv02d.h b/drivers/hwmon/lis3lv02d.h
index 223f1c0..7f2c514 100644
--- a/drivers/hwmon/lis3lv02d.h
+++ b/drivers/hwmon/lis3lv02d.h
@@ -170,6 +170,12 @@ struct acpi_lis3lv02d {
 	unsigned char		is_on;     /* whether the device is on or off */
 	unsigned char		usage;     /* usage counter */
 	struct axis_conversion	ac;        /* hw -> logical axis */
+
+	u32			irq;       /* IRQ number */
+	struct timer_list	poff_timer; /* for automatic power off */
+	struct fasync_struct	*async_queue; /* queue for the misc device */
+	wait_queue_head_t	misc_wait; /* Wait queue for the misc device */
+	unsigned long		misc_opened; /* bit0: whether the device is open */
 };
 
 int lis3lv02d_init_device(struct acpi_lis3lv02d *dev);

--pWyiEgJYm5f9v55/--
