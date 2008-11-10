Return-Path: <linux-kernel-owner+w=401wt.eu-S1754845AbYKJMAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845AbYKJMAW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 07:00:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754533AbYKJMAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 07:00:07 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:55555 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529AbYKJMAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 07:00:05 -0500
Date: Mon, 10 Nov 2008 12:59:43 +0100
From: Pavel Machek <pavel@suse.cz>
To: Eric Piel <eric.piel@tremplin-utc.net>
Cc: Thomas Renninger <trenn@suse.de>, burman.yan@gmail.com, rpurdie@rpsys.net,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <len.brown@intel.com>
Subject: Re: leds-hp-disk vs lis3lv02d
Message-ID: <20081110115943.GA9441@elf.ucw.cz>
References: <200810162255.m9GMtKj4001733@imap1.linux-foundation.org> <200810192106.15905.trenn@suse.de> <20081019204819.GC1465@ucw.cz> <4902F817.4050108@tremplin-utc.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="3V7upXqbjpZ4EhLz"
Content-Disposition: inline
In-Reply-To: <4902F817.4050108@tremplin-utc.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat 2008-10-25 12:42:31, Eric Piel wrote:
> Pavel Machek schreef:
> > Hi!
> > 
> >> shouldn't this one be integrated into Eric's/Yan's driver?
> > 
> > It is separate piece of hardware, completely unrelated to lids3v
> > chip. No, it should not be integrated, but I'll makesure they work
> > toggether well.
> Hello,
> I think I talked too fast: it seems impossible to have both drivers
> (leds-hp-disk and lis3lv02d) working at the same time. Only the first
> driver loaded is used.
> 
> After a little look at it, I think it comes from the fact that both
> drivers are assigned to the same MODALIAS (HPQ0004). The ACPI PNP
> (through the generic bus infrastructure) only declare the device to one
> of the drivers supporting it, not all of them.
> 
> How can I tell to ACPI that it should load both drivers for the same PNP
> ID match?

Here's patch that moves both to ec_accel driver, so LED and
accelerometer should work at the same time. Testing would be welcome,
relative to linux-mm.

(Incremental version relative to last version I posted is attached; it
is easier to read).

									Pavel
diff -ur clean-real-mm/drivers/hwmon/Makefile linux-mm/drivers/hwmon/Makefile
--- clean-real-mm/drivers/hwmon/Makefile	2008-11-10 10:48:57.000000000 +0100
+++ linux-mm/drivers/hwmon/Makefile	2008-11-06 09:18:16.000000000 +0100
@@ -48,7 +48,7 @@
 obj-$(CONFIG_SENSORS_IBMPEX)	+= ibmpex.o
 obj-$(CONFIG_SENSORS_IT87)	+= it87.o
 obj-$(CONFIG_SENSORS_K8TEMP)	+= k8temp.o
-obj-$(CONFIG_SENSORS_LIS3LV02D) += lis3lv02d.o
+obj-$(CONFIG_SENSORS_LIS3LV02D) += lis3lv02d.o hp_accel.o
 obj-$(CONFIG_SENSORS_LM63)	+= lm63.o
 obj-$(CONFIG_SENSORS_LM70)	+= lm70.o
 obj-$(CONFIG_SENSORS_LM75)	+= lm75.o
diff -ur clean-real-mm/drivers/hwmon/lis3lv02d.c linux-mm/drivers/hwmon/lis3lv02d.c
--- clean-real-mm/drivers/hwmon/lis3lv02d.c	2008-11-10 10:48:57.000000000 +0100
+++ linux-mm/drivers/hwmon/lis3lv02d.c	2008-11-06 12:27:27.000000000 +0100
@@ -3,6 +3,7 @@
  *
  *  Copyright (C) 2007-2008 Yan Burman
  *  Copyright (C) 2008 Eric Piel
+ *  Copyright (C) 2008 Pavel Machek
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
@@ -42,6 +43,7 @@
 #define DRIVER_NAME     "lis3lv02d"
 #define ACPI_MDPS_CLASS "accelerometer"
 
+
 /* joystick device poll interval in milliseconds */
 #define MDPS_POLL_INTERVAL 50
 /*
@@ -56,100 +58,18 @@
 /* Maximum value our axis may get for the input device (signed 12 bits) */
 #define MDPS_MAX_VAL 2048
 
-struct axis_conversion {
-	s8	x;
-	s8	y;
-	s8	z;
-};
 
-struct acpi_lis3lv02d {
-	struct acpi_device	*device;   /* The ACPI device */
-	struct input_dev	*idev;     /* input device */
-	struct task_struct	*kthread;  /* kthread for input */
-	struct mutex            lock;
-	struct platform_device	*pdev;     /* platform device */
-	atomic_t		count;     /* interrupt count after last read */
-	int			xcalib;    /* calibrated null value for x */
-	int			ycalib;    /* calibrated null value for y */
-	int			zcalib;    /* calibrated null value for z */
-	unsigned char		is_on;     /* whether the device is on or off */
-	unsigned char		usage;     /* usage counter */
-	struct axis_conversion	ac;        /* hw -> logical axis */
-};
 
-static struct acpi_lis3lv02d adev;
+struct acpi_lis3lv02d adev;
 
-static int lis3lv02d_remove_fs(void);
 static int lis3lv02d_add_fs(struct acpi_device *device);
 
-/* For automatic insertion of the module */
-static struct acpi_device_id lis3lv02d_device_ids[] = {
-	{"HPQ0004", 0}, /* HP Mobile Data Protection System PNP */
-	{"", 0},
-};
-MODULE_DEVICE_TABLE(acpi, lis3lv02d_device_ids);
-
-/**
- * lis3lv02d_acpi_init - ACPI _INI method: initialize the device.
- * @handle: the handle of the device
- *
- * Returns AE_OK on success.
- */
-static inline acpi_status lis3lv02d_acpi_init(acpi_handle handle)
-{
-	return acpi_evaluate_object(handle, METHOD_NAME__INI, NULL, NULL);
-}
-
-/**
- * lis3lv02d_acpi_read - ACPI ALRD method: read a register
- * @handle: the handle of the device
- * @reg:    the register to read
- * @ret:    result of the operation
- *
- * Returns AE_OK on success.
- */
-static acpi_status lis3lv02d_acpi_read(acpi_handle handle, int reg, u8 *ret)
-{
-	union acpi_object arg0 = { ACPI_TYPE_INTEGER };
-	struct acpi_object_list args = { 1, &arg0 };
-	unsigned long long lret;
-	acpi_status status;
-
-	arg0.integer.value = reg;
-
-	status = acpi_evaluate_integer(handle, "ALRD", &args, &lret);
-	*ret = lret;
-	return status;
-}
-
-/**
- * lis3lv02d_acpi_write - ACPI ALWR method: write to a register
- * @handle: the handle of the device
- * @reg:    the register to write to
- * @val:    the value to write
- *
- * Returns AE_OK on success.
- */
-static acpi_status lis3lv02d_acpi_write(acpi_handle handle, int reg, u8 val)
-{
-	unsigned long long ret; /* Not used when writting */
-	union acpi_object in_obj[2];
-	struct acpi_object_list args = { 2, in_obj };
-
-	in_obj[0].type          = ACPI_TYPE_INTEGER;
-	in_obj[0].integer.value = reg;
-	in_obj[1].type          = ACPI_TYPE_INTEGER;
-	in_obj[1].integer.value = val;
-
-	return acpi_evaluate_integer(handle, "ALWR", &args, &ret);
-}
-
 static s16 lis3lv02d_read_16(acpi_handle handle, int reg)
 {
 	u8 lo, hi;
 
-	lis3lv02d_acpi_read(handle, reg, &lo);
-	lis3lv02d_acpi_read(handle, reg + 1, &hi);
+	adev.read(handle, reg, &lo);
+	adev.read(handle, reg + 1, &hi);
 	/* In "12 bit right justified" mode, bit 6, bit 7, bit 8 = bit 5 */
 	return (s16)((hi << 8) | lo);
 }
@@ -191,54 +111,30 @@
 	*z = lis3lv02d_get_axis(adev.ac.z, position);
 }
 
-static inline void lis3lv02d_poweroff(acpi_handle handle)
+void lis3lv02d_poweroff(acpi_handle handle)
 {
 	adev.is_on = 0;
 	/* disable X,Y,Z axis and power down */
-	lis3lv02d_acpi_write(handle, CTRL_REG1, 0x00);
+	adev.write(handle, CTRL_REG1, 0x00);
 }
 
-static void lis3lv02d_poweron(acpi_handle handle)
+void lis3lv02d_poweron(acpi_handle handle)
 {
 	u8 val;
 
 	adev.is_on = 1;
-	lis3lv02d_acpi_init(handle);
-	lis3lv02d_acpi_write(handle, FF_WU_CFG, 0);
+	adev.init(handle);
+	adev.write(handle, FF_WU_CFG, 0);
 	/*
 	 * BDU: LSB and MSB values are not updated until both have been read.
 	 *      So the value read will always be correct.
 	 * IEN: Interrupt for free-fall and DD, not for data-ready.
 	 */
-	lis3lv02d_acpi_read(handle, CTRL_REG2, &val);
+	adev.read(handle, CTRL_REG2, &val);
 	val |= CTRL2_BDU | CTRL2_IEN;
-	lis3lv02d_acpi_write(handle, CTRL_REG2, val);
-}
-
-#ifdef CONFIG_PM
-static int lis3lv02d_suspend(struct acpi_device *device, pm_message_t state)
-{
-	/* make sure the device is off when we suspend */
-	lis3lv02d_poweroff(device->handle);
-	return 0;
+	adev.write(handle, CTRL_REG2, val);
 }
 
-static int lis3lv02d_resume(struct acpi_device *device)
-{
-	/* put back the device in the right state (ACPI might turn it on) */
-	mutex_lock(&adev.lock);
-	if (adev.usage > 0)
-		lis3lv02d_poweron(device->handle);
-	else
-		lis3lv02d_poweroff(device->handle);
-	mutex_unlock(&adev.lock);
-	return 0;
-}
-#else
-#define lis3lv02d_suspend NULL
-#define lis3lv02d_resume NULL
-#endif
-
 
 /*
  * To be called before starting to use the device. It makes sure that the
@@ -316,7 +212,7 @@
 	lis3lv02d_get_xyz(adev.device->handle, &adev.xcalib, &adev.ycalib, &adev.zcalib);
 }
 
-static int lis3lv02d_joystick_enable(void)
+int lis3lv02d_joystick_enable(void)
 {
 	int err;
 
@@ -351,7 +247,7 @@
 	return err;
 }
 
-static void lis3lv02d_joystick_disable(void)
+void lis3lv02d_joystick_disable(void)
 {
 	if (!adev.idev)
 		return;
@@ -361,11 +257,12 @@
 }
 
 
+
 /*
  * Initialise the accelerometer and the various subsystems.
  * Should be rather independant of the bus system.
  */
-static int lis3lv02d_init_device(struct acpi_lis3lv02d *dev)
+int lis3lv02d_init_device(struct acpi_lis3lv02d *dev)
 {
 	mutex_init(&dev->lock);
 	lis3lv02d_add_fs(dev->device);
@@ -378,91 +275,6 @@
 	return 0;
 }
 
-static int lis3lv02d_dmi_matched(const struct dmi_system_id *dmi)
-{
-	adev.ac = *((struct axis_conversion *)dmi->driver_data);
-	printk(KERN_INFO DRIVER_NAME ": hardware type %s found.\n", dmi->ident);
-
-	return 1;
-}
-
-/* Represents, for each axis seen by userspace, the corresponding hw axis (+1).
- * If the value is negative, the opposite of the hw value is used. */
-static struct axis_conversion lis3lv02d_axis_normal = {1, 2, 3};
-static struct axis_conversion lis3lv02d_axis_y_inverted = {1, -2, 3};
-static struct axis_conversion lis3lv02d_axis_x_inverted = {-1, 2, 3};
-static struct axis_conversion lis3lv02d_axis_z_inverted = {1, 2, -3};
-static struct axis_conversion lis3lv02d_axis_xy_rotated_left = {-2, 1, 3};
-static struct axis_conversion lis3lv02d_axis_xy_swap_inverted = {-2, -1, 3};
-
-#define AXIS_DMI_MATCH(_ident, _name, _axis) {		\
-	.ident = _ident,				\
-	.callback = lis3lv02d_dmi_matched,		\
-	.matches = {					\
-		DMI_MATCH(DMI_PRODUCT_NAME, _name)	\
-	},						\
-	.driver_data = &lis3lv02d_axis_##_axis		\
-}
-static struct dmi_system_id lis3lv02d_dmi_ids[] = {
-	/* product names are truncated to match all kinds of a same model */
-	AXIS_DMI_MATCH("NC64x0", "HP Compaq nc64", x_inverted),
-	AXIS_DMI_MATCH("NC84x0", "HP Compaq nc84", z_inverted),
-	AXIS_DMI_MATCH("NX9420", "HP Compaq nx9420", x_inverted),
-	AXIS_DMI_MATCH("NW9440", "HP Compaq nw9440", x_inverted),
-	AXIS_DMI_MATCH("NC2510", "HP Compaq 2510", y_inverted),
-	AXIS_DMI_MATCH("NC8510", "HP Compaq 8510", xy_swap_inverted),
-	AXIS_DMI_MATCH("HP2133", "HP 2133", xy_rotated_left),
-	{ NULL, }
-/* Laptop models without axis info (yet):
- * "NC651xx" "HP Compaq 651"
- * "NC671xx" "HP Compaq 671"
- * "NC6910" "HP Compaq 6910"
- * HP Compaq 8710x Notebook PC / Mobile Workstation
- * "NC2400" "HP Compaq nc2400"
- * "NX74x0" "HP Compaq nx74"
- * "NX6325" "HP Compaq nx6325"
- * "NC4400" "HP Compaq nc4400"
- */
-};
-
-static int lis3lv02d_add(struct acpi_device *device)
-{
-	u8 val;
-
-	if (!device)
-		return -EINVAL;
-
-	adev.device = device;
-	strcpy(acpi_device_name(device), DRIVER_NAME);
-	strcpy(acpi_device_class(device), ACPI_MDPS_CLASS);
-	device->driver_data = &adev;
-
-	lis3lv02d_acpi_read(device->handle, WHO_AM_I, &val);
-	if ((val != LIS3LV02DL_ID) && (val != LIS302DL_ID)) {
-		printk(KERN_ERR DRIVER_NAME
-				": Accelerometer chip not LIS3LV02D{L,Q}\n");
-	}
-
-	/* If possible use a "standard" axes order */
-	if (dmi_check_system(lis3lv02d_dmi_ids) == 0) {
-		printk(KERN_INFO DRIVER_NAME ": laptop model unknown, "
-				 "using default axes configuration\n");
-		adev.ac = lis3lv02d_axis_normal;
-	}
-
-	return lis3lv02d_init_device(&adev);
-}
-
-static int lis3lv02d_remove(struct acpi_device *device, int type)
-{
-	if (!device)
-		return -EINVAL;
-
-	lis3lv02d_joystick_disable();
-	lis3lv02d_poweroff(device->handle);
-
-	return lis3lv02d_remove_fs();
-}
 
 
 /* Sysfs stuff */
@@ -502,7 +314,7 @@
 	int val;
 
 	lis3lv02d_increase_use(&adev);
-	lis3lv02d_acpi_read(adev.device->handle, CTRL_REG1, &ctrl);
+	adev.read(adev.device->handle, CTRL_REG1, &ctrl);
 	lis3lv02d_decrease_use(&adev);
 	val = (ctrl & (CTRL1_DF0 | CTRL1_DF1)) >> 4;
 	return sprintf(buf, "%d\n", lis3lv02dl_df_val[val]);
@@ -524,6 +336,7 @@
 	.attrs = lis3lv02d_attributes
 };
 
+
 static int lis3lv02d_add_fs(struct acpi_device *device)
 {
 	adev.pdev = platform_device_register_simple(DRIVER_NAME, -1, NULL, 0);
@@ -533,50 +346,22 @@
 	return sysfs_create_group(&adev.pdev->dev.kobj, &lis3lv02d_attribute_group);
 }
 
-static int lis3lv02d_remove_fs(void)
+int lis3lv02d_remove_fs(void)
 {
 	sysfs_remove_group(&adev.pdev->dev.kobj, &lis3lv02d_attribute_group);
 	platform_device_unregister(adev.pdev);
 	return 0;
 }
 
-/* For the HP MDPS aka 3D Driveguard */
-static struct acpi_driver lis3lv02d_driver = {
-	.name  = DRIVER_NAME,
-	.class = ACPI_MDPS_CLASS,
-	.ids   = lis3lv02d_device_ids,
-	.ops = {
-		.add     = lis3lv02d_add,
-		.remove  = lis3lv02d_remove,
-		.suspend = lis3lv02d_suspend,
-		.resume  = lis3lv02d_resume,
-	}
-};
-
-static int __init lis3lv02d_init_module(void)
-{
-	int ret;
-
-	if (acpi_disabled)
-		return -ENODEV;
-
-	ret = acpi_bus_register_driver(&lis3lv02d_driver);
-	if (ret < 0)
-		return ret;
-
-	printk(KERN_INFO DRIVER_NAME " driver loaded.\n");
-
-	return 0;
-}
-
-static void __exit lis3lv02d_exit_module(void)
-{
-	acpi_bus_unregister_driver(&lis3lv02d_driver);
-}
-
 MODULE_DESCRIPTION("ST LIS3LV02Dx three-axis digital accelerometer driver");
 MODULE_AUTHOR("Yan Burman and Eric Piel");
 MODULE_LICENSE("GPL");
 
-module_init(lis3lv02d_init_module);
-module_exit(lis3lv02d_exit_module);
+EXPORT_SYMBOL_GPL(lis3lv02d_init_device);
+EXPORT_SYMBOL_GPL(lis3lv02d_joystick_enable);
+EXPORT_SYMBOL_GPL(lis3lv02d_joystick_disable);
+EXPORT_SYMBOL_GPL(lis3lv02d_poweroff);
+EXPORT_SYMBOL_GPL(lis3lv02d_poweron);
+EXPORT_SYMBOL_GPL(lis3lv02d_remove_fs);
+
+EXPORT_SYMBOL_GPL(adev);
diff -ur clean-real-mm/drivers/hwmon/lis3lv02d.h linux-mm/drivers/hwmon/lis3lv02d.h
--- clean-real-mm/drivers/hwmon/lis3lv02d.h	2008-11-10 10:48:57.000000000 +0100
+++ linux-mm/drivers/hwmon/lis3lv02d.h	2008-11-06 12:24:05.000000000 +0100
@@ -147,3 +147,38 @@
 	DD_SRC_IA	= 0x40,
 };
 
+acpi_status lis3lv02d_acpi_init(acpi_handle handle);
+
+struct axis_conversion {
+	s8	x;
+	s8	y;
+	s8	z;
+};
+
+struct acpi_lis3lv02d {
+	struct acpi_device	*device;   /* The ACPI device */
+	acpi_status (* init) (acpi_handle handle);
+	acpi_status (* write) (acpi_handle handle, int reg, u8 val);
+	acpi_status (* read) (acpi_handle handle, int reg, u8 *ret);
+
+	struct input_dev	*idev;     /* input device */
+	struct task_struct	*kthread;  /* kthread for input */
+	struct mutex            lock;
+	struct platform_device	*pdev;     /* platform device */
+	atomic_t		count;     /* interrupt count after last read */
+	int			xcalib;    /* calibrated null value for x */
+	int			ycalib;    /* calibrated null value for y */
+	int			zcalib;    /* calibrated null value for z */
+	unsigned char		is_on;     /* whether the device is on or off */
+	unsigned char		usage;     /* usage counter */
+	struct axis_conversion	ac;        /* hw -> logical axis */
+};
+
+int lis3lv02d_init_device(struct acpi_lis3lv02d *dev);
+int lis3lv02d_joystick_enable(void);
+void lis3lv02d_joystick_disable(void);
+void lis3lv02d_poweroff(acpi_handle handle);
+void lis3lv02d_poweron(acpi_handle handle);
+int lis3lv02d_remove_fs(void);
+
+extern struct acpi_lis3lv02d adev;




-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

--3V7upXqbjpZ4EhLz
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="lis.4inc.diff"

Only in linux-mm/.tmp_versions: scsi_wait_scan.mod
diff -ur linux-mm.middle/drivers/hwmon/.hp_accel.o.cmd linux-mm/drivers/hwmon/.hp_accel.o.cmd
--- linux-mm.middle/drivers/hwmon/.hp_accel.o.cmd	2008-11-06 12:30:58.000000000 +0100
+++ linux-mm/drivers/hwmon/.hp_accel.o.cmd	2008-11-10 09:12:22.000000000 +0100
@@ -538,6 +538,9 @@
     $(wildcard include/config/cgroup/freezer.h) \
   include/linux/version.h \
   include/linux/uaccess.h \
+  include/linux/leds.h \
+    $(wildcard include/config/leds/triggers.h) \
+    $(wildcard include/config/leds/trigger/ide/disk.h) \
   include/acpi/acpi_drivers.h \
     $(wildcard include/config/acpi/power.h) \
     $(wildcard include/config/acpi/ec.h) \
diff -ur linux-mm.middle/drivers/hwmon/hp_accel.c linux-mm/drivers/hwmon/hp_accel.c
--- linux-mm.middle/drivers/hwmon/hp_accel.c	2008-11-06 12:26:03.000000000 +0100
+++ linux-mm/drivers/hwmon/hp_accel.c	2008-11-10 09:11:40.000000000 +0100
@@ -36,6 +36,7 @@
 #include <linux/freezer.h>
 #include <linux/version.h>
 #include <linux/uaccess.h>
+#include <linux/leds.h>
 #include <acpi/acpi_drivers.h>
 #include <asm/atomic.h>
 #include "lis3lv02d.h"
@@ -155,9 +156,34 @@
 };
 
 
+static acpi_status hpled_acpi_write(acpi_handle handle, int reg)
+{
+	unsigned long long ret; /* Not used when writing */
+	union acpi_object in_obj[1];
+	struct acpi_object_list args = { 1, in_obj };
+
+	in_obj[0].type          = ACPI_TYPE_INTEGER;
+	in_obj[0].integer.value = reg;
+
+	return acpi_evaluate_integer(handle, "ALED", &args, &ret);
+}
+
+static void hpled_set(struct led_classdev *led_cdev,
+			       enum led_brightness value)
+{
+	hpled_acpi_write(adev.device->handle, !!value);
+}
+
+static struct led_classdev hpled_led = {
+	.name			= "hp:red:hddprotection",
+	.default_trigger	= "heartbeat",
+	.brightness_set		= hpled_set,
+};
+
 static int lis3lv02d_add(struct acpi_device *device)
 {
 	u8 val;
+	int ret;
 
 	if (!device)
 		return -EINVAL;
@@ -183,7 +209,17 @@
 		adev.ac = lis3lv02d_axis_normal;
 	}
 
-	return lis3lv02d_init_device(&adev);
+	ret = led_classdev_register(NULL, &hpled_led);
+	if (ret)
+		return ret;
+
+	ret = lis3lv02d_init_device(&adev);
+	if (ret) {
+		led_classdev_unregister(&hpled_led);
+		return ret;
+	}
+	
+	return ret;
 }
 
 static int lis3lv02d_remove(struct acpi_device *device, int type)
@@ -194,6 +230,8 @@
 	lis3lv02d_joystick_disable();
 	lis3lv02d_poweroff(device->handle);
 
+	led_classdev_unregister(&hpled_led);
+
 	return lis3lv02d_remove_fs();
 }
 
@@ -203,6 +241,7 @@
 {
 	/* make sure the device is off when we suspend */
 	lis3lv02d_poweroff(device->handle);
+	led_classdev_suspend(&hpled_led);
 	return 0;
 }
 
@@ -215,6 +254,7 @@
 	else
 		lis3lv02d_poweroff(device->handle);
 	mutex_unlock(&adev.lock);
+	led_classdev_resume(&hpled_led);
 	return 0;
 }
 #else
Binary files linux-mm.middle/drivers/hwmon/hp_accel.ko and linux-mm/drivers/hwmon/hp_accel.ko differ
Binary files linux-mm.middle/drivers/hwmon/hp_accel.o and linux-mm/drivers/hwmon/hp_accel.o differ
diff -ur linux-mm.middle/modules.order linux-mm/modules.order
--- linux-mm.middle/modules.order	2008-11-10 08:56:49.000000000 +0100
+++ linux-mm/modules.order	2008-11-10 09:16:23.000000000 +0100
@@ -0,0 +1,8 @@
+kernel/drivers/block/nbd.ko
+kernel/drivers/scsi/scsi_wait_scan.ko
+kernel/drivers/input/ff-memless.ko
+kernel/drivers/hwmon/lis3lv02d.ko
+kernel/drivers/hwmon/hp_accel.ko
+kernel/drivers/hid/hid-dummy.ko
+kernel/drivers/hid/hid-tmff.ko
+kernel/drivers/hid/hid-zpff.ko

--3V7upXqbjpZ4EhLz--
