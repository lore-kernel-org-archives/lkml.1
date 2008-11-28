Return-Path: <linux-kernel-owner+w=401wt.eu-S1753427AbYK1IUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427AbYK1IUk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 03:20:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751762AbYK1IUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 03:20:31 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40763 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbYK1IU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 03:20:28 -0500
Date: Fri, 28 Nov 2008 09:22:15 +0100
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>, Eric.Piel@tremplin-utc.net,
       trenn@suse.de, hmh@hmh.eng.br
Subject: HP accelerometer: free fall detection working, testers wanted
Message-ID: <20081128082215.GA2013@elf.ucw.cz>
References: <20081121212121.GA7222@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081121212121.GA7222@elf.ucw.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I got free fall detection to work -- apparently BIOS does all the
important stuff itself. 

Now... I'd like some testers. (Don't comment on code... yet. Yes, it
has some issues).

hp3dg script should do all the important things.

Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/Documentation/hwmon/hp3dg b/Documentation/hwmon/hp3dg
new file mode 100755
index 0000000..6b7114b
--- /dev/null
+++ b/Documentation/hwmon/hp3dg
@@ -0,0 +1,26 @@
+#!/bin/bash
+#
+# HP 3d driveguard disk protection example
+#mount /dev/sdb2 /mmc
+#cd /mmc/local/linux/drivers/hwmon/
+#rmmod hp_accel; rmmod lis3lv02d; insmod lis3lv02d.ko ; insmod hp_accel.ko
+#cd /usr/src
+
+unload() {
+	echo $[($1*1000)+100] > /sys/block/sda/device/unload_heads
+	echo 1 > /sys/class/leds/hp\:red\:hddprotect/brightness
+	(
+		sleep $1
+		if cat /sys/block/sda/device/unload_heads | grep ^0$; then
+			echo 0 > /sys/class/leds/hp\:red\:hddprotect/brightness
+		fi
+	) &
+}
+
+while true; do
+	./readaccel foo
+	unload 2
+	if cat /proc/acpi/button/lid/LID/state | grep open && cat /proc/acpi/ac_adapter/AC0/state | grep off-line; then
+		unload 20
+	fi
+done
diff --git a/Documentation/hwmon/readaccel.c b/Documentation/hwmon/readaccel.c
new file mode 100755
index 0000000..cb9a71c
--- /dev/null
+++ b/Documentation/hwmon/readaccel.c
@@ -0,0 +1,35 @@
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <string.h>
+#include <stdint.h>
+
+int main(int argc, char* argv[])
+{
+       int fd, ret;
+       unsigned char count;
+
+       fd = open("/dev/freefall", O_RDONLY);
+       if (fd < 0) {
+               perror("open");
+               return EXIT_FAILURE;
+       }
+
+       for (;;) {
+               ret = read(fd, &count, sizeof(count));
+               if (ret != sizeof(count)) {
+                       perror("read");
+                       break;
+               }
+
+               printf("Got %d free-fall interrupts\n", (int) count);
+	       if (argc > 1)
+		        return EXIT_SUCCESS;
+       }
+
+       close(fd);
+       return EXIT_SUCCESS;
+}
diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index c709e82..ab9b163 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -838,6 +838,8 @@ config SENSORS_HDAPS
 config SENSORS_LIS3LV02D
 	tristate "STMicroeletronics LIS3LV02Dx three-axis digital accelerometer"
 	depends on ACPI && INPUT
+	select NEW_LEDS
+	select LEDS_CLASS
 	default n
 	help
 	  This driver provides support for the LIS3LV02Dx accelerometer. In
@@ -849,10 +851,16 @@ config SENSORS_LIS3LV02D
 	  /sys/devices/platform/lis3lv02d.
 
 	  This driver also provides an absolute input class device, allowing
-	  the laptop to act as a pinball machine-esque joystick.
+	  the laptop to act as a pinball machine-esque joystick. On HP laptops,
+	  if the led infrastructure is activated, support for a led indicating
+	  disk protection will be provided as hp:red:hddprotection.
 
-	  This driver can also be built as a module.  If so, the module
-	  will be called lis3lv02d.
+	  This driver can also be built as modules.  If so, the core module
+	  will be called lis3lv02d and a specific module for HP laptops will be
+	  called hp_accel.
+
+	  Say Y here if you have an applicable laptop and want to experience
+	  the awesome power of lis3lv02d.
 
 config SENSORS_APPLESMC
 	tristate "Apple SMC (Motion sensor, light sensor, keyboard backlight)"
diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
index 58fc5be..9f891ff 100644
--- a/drivers/hwmon/Makefile
+++ b/drivers/hwmon/Makefile
@@ -49,7 +49,7 @@ obj-$(CONFIG_SENSORS_IBMAEM)	+= ibmaem.o
 obj-$(CONFIG_SENSORS_IBMPEX)	+= ibmpex.o
 obj-$(CONFIG_SENSORS_IT87)	+= it87.o
 obj-$(CONFIG_SENSORS_K8TEMP)	+= k8temp.o
-obj-$(CONFIG_SENSORS_LIS3LV02D) += lis3lv02d.o
+obj-$(CONFIG_SENSORS_LIS3LV02D) += lis3lv02d.o hp_accel.o
 obj-$(CONFIG_SENSORS_LM63)	+= lm63.o
 obj-$(CONFIG_SENSORS_LM70)	+= lm70.o
 obj-$(CONFIG_SENSORS_LM75)	+= lm75.o
diff --git a/drivers/hwmon/hp_accel.c b/drivers/hwmon/hp_accel.c
new file mode 100644
index 0000000..d58d3b1
--- /dev/null
+++ b/drivers/hwmon/hp_accel.c
@@ -0,0 +1,304 @@
+/*
+ *  hp_accel.c - Interface between LIS3LV02DL driver and HP ACPI BIOS
+ *
+ *  Copyright (C) 2007-2008 Yan Burman
+ *  Copyright (C) 2008 Eric Piel
+ *  Copyright (C) 2008 Pavel Machek
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/dmi.h>
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/input.h>
+#include <linux/kthread.h>
+#include <linux/semaphore.h>
+#include <linux/delay.h>
+#include <linux/wait.h>
+#include <linux/poll.h>
+#include <linux/freezer.h>
+#include <linux/version.h>
+#include <linux/uaccess.h>
+#include <linux/leds.h>
+#include <acpi/acpi_drivers.h>
+#include <asm/atomic.h>
+#include "lis3lv02d.h"
+
+#define DRIVER_NAME     "lis3lv02d"
+#define ACPI_MDPS_CLASS "accelerometer"
+
+
+/* For automatic insertion of the module */
+static struct acpi_device_id lis3lv02d_device_ids[] = {
+	{"HPQ0004", 0}, /* HP Mobile Data Protection System PNP */
+	{"", 0},
+};
+MODULE_DEVICE_TABLE(acpi, lis3lv02d_device_ids);
+
+
+/**
+ * lis3lv02d_acpi_init - ACPI _INI method: initialize the device.
+ * @handle: the handle of the device
+ *
+ * Returns AE_OK on success.
+ */
+acpi_status lis3lv02d_acpi_init(acpi_handle handle)
+{
+	return acpi_evaluate_object(handle, METHOD_NAME__INI, NULL, NULL);
+}
+
+/**
+ * lis3lv02d_acpi_read - ACPI ALRD method: read a register
+ * @handle: the handle of the device
+ * @reg:    the register to read
+ * @ret:    result of the operation
+ *
+ * Returns AE_OK on success.
+ */
+acpi_status lis3lv02d_acpi_read(acpi_handle handle, int reg, u8 *ret)
+{
+	union acpi_object arg0 = { ACPI_TYPE_INTEGER };
+	struct acpi_object_list args = { 1, &arg0 };
+	unsigned long long lret;
+	acpi_status status;
+
+	arg0.integer.value = reg;
+
+	status = acpi_evaluate_integer(handle, "ALRD", &args, &lret);
+	*ret = lret;
+	return status;
+}
+
+/**
+ * lis3lv02d_acpi_write - ACPI ALWR method: write to a register
+ * @handle: the handle of the device
+ * @reg:    the register to write to
+ * @val:    the value to write
+ *
+ * Returns AE_OK on success.
+ */
+acpi_status lis3lv02d_acpi_write(acpi_handle handle, int reg, u8 val)
+{
+	unsigned long long ret; /* Not used when writting */
+	union acpi_object in_obj[2];
+	struct acpi_object_list args = { 2, in_obj };
+
+	in_obj[0].type          = ACPI_TYPE_INTEGER;
+	in_obj[0].integer.value = reg;
+	in_obj[1].type          = ACPI_TYPE_INTEGER;
+	in_obj[1].integer.value = val;
+
+	return acpi_evaluate_integer(handle, "ALWR", &args, &ret);
+}
+
+static int lis3lv02d_dmi_matched(const struct dmi_system_id *dmi)
+{
+	adev.ac = *((struct axis_conversion *)dmi->driver_data);
+	printk(KERN_INFO DRIVER_NAME ": hardware type %s found.\n", dmi->ident);
+
+	return 1;
+}
+
+/* Represents, for each axis seen by userspace, the corresponding hw axis (+1).
+ * If the value is negative, the opposite of the hw value is used. */
+static struct axis_conversion lis3lv02d_axis_normal = {1, 2, 3};
+static struct axis_conversion lis3lv02d_axis_y_inverted = {1, -2, 3};
+static struct axis_conversion lis3lv02d_axis_x_inverted = {-1, 2, 3};
+static struct axis_conversion lis3lv02d_axis_z_inverted = {1, 2, -3};
+static struct axis_conversion lis3lv02d_axis_xy_rotated_left = {-2, 1, 3};
+static struct axis_conversion lis3lv02d_axis_xy_swap_inverted = {-2, -1, 3};
+
+#define AXIS_DMI_MATCH(_ident, _name, _axis) {		\
+	.ident = _ident,				\
+	.callback = lis3lv02d_dmi_matched,		\
+	.matches = {					\
+		DMI_MATCH(DMI_PRODUCT_NAME, _name)	\
+	},						\
+	.driver_data = &lis3lv02d_axis_##_axis		\
+}
+static struct dmi_system_id lis3lv02d_dmi_ids[] = {
+	/* product names are truncated to match all kinds of a same model */
+	AXIS_DMI_MATCH("NC64x0", "HP Compaq nc64", x_inverted),
+	AXIS_DMI_MATCH("NC84x0", "HP Compaq nc84", z_inverted),
+	AXIS_DMI_MATCH("NX9420", "HP Compaq nx9420", x_inverted),
+	AXIS_DMI_MATCH("NW9440", "HP Compaq nw9440", x_inverted),
+	AXIS_DMI_MATCH("NC2510", "HP Compaq 2510", y_inverted),
+	AXIS_DMI_MATCH("NC8510", "HP Compaq 8510", xy_swap_inverted),
+	AXIS_DMI_MATCH("HP2133", "HP 2133", xy_rotated_left),
+	{ NULL, }
+/* Laptop models without axis info (yet):
+ * "NC651xx" "HP Compaq 651"
+ * "NC671xx" "HP Compaq 671"
+ * "NC6910" "HP Compaq 6910"
+ * HP Compaq 8710x Notebook PC / Mobile Workstation
+ * "NC2400" "HP Compaq nc2400"
+ * "NX74x0" "HP Compaq nx74"
+ * "NX6325" "HP Compaq nx6325"
+ * "NC4400" "HP Compaq nc4400"
+ */
+};
+
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
+	.name			= "hp:red:hddprotect",
+	.default_trigger	= "none",
+	.brightness_set		= hpled_set,
+};
+
+static int lis3lv02d_add(struct acpi_device *device)
+{
+	u8 val;
+	int ret;
+
+	if (!device)
+		return -EINVAL;
+
+	adev.device = device;
+	adev.init = lis3lv02d_acpi_init;
+	adev.read = lis3lv02d_acpi_read;
+	adev.write = lis3lv02d_acpi_write;
+	strcpy(acpi_device_name(device), DRIVER_NAME);
+	strcpy(acpi_device_class(device), ACPI_MDPS_CLASS);
+	device->driver_data = &adev;
+
+	lis3lv02d_acpi_read(device->handle, WHO_AM_I, &val);
+	if ((val != LIS3LV02DL_ID) && (val != LIS302DL_ID)) {
+		printk(KERN_ERR DRIVER_NAME
+				": Accelerometer chip not LIS3LV02D{L,Q}\n");
+	}
+
+	/* If possible use a "standard" axes order */
+	if (dmi_check_system(lis3lv02d_dmi_ids) == 0) {
+		printk(KERN_INFO DRIVER_NAME ": laptop model unknown, "
+				 "using default axes configuration\n");
+		adev.ac = lis3lv02d_axis_normal;
+	}
+
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
+}
+
+static int lis3lv02d_remove(struct acpi_device *device, int type)
+{
+	if (!device)
+		return -EINVAL;
+
+	lis3lv02d_joystick_disable();
+	lis3lv02d_poweroff(device->handle);
+
+	led_classdev_unregister(&hpled_led);
+
+	return lis3lv02d_remove_fs();
+}
+
+
+#ifdef CONFIG_PM
+static int lis3lv02d_suspend(struct acpi_device *device, pm_message_t state)
+{
+	/* make sure the device is off when we suspend */
+	lis3lv02d_poweroff(device->handle);
+	led_classdev_suspend(&hpled_led);
+	return 0;
+}
+
+static int lis3lv02d_resume(struct acpi_device *device)
+{
+	/* put back the device in the right state (ACPI might turn it on) */
+	mutex_lock(&adev.lock);
+	if (adev.usage > 0)
+		lis3lv02d_poweron(device->handle);
+	else
+		lis3lv02d_poweroff(device->handle);
+	mutex_unlock(&adev.lock);
+	led_classdev_resume(&hpled_led);
+	return 0;
+}
+#else
+#define lis3lv02d_suspend NULL
+#define lis3lv02d_resume NULL
+#endif
+
+/* For the HP MDPS aka 3D Driveguard */
+static struct acpi_driver lis3lv02d_driver = {
+	.name  = DRIVER_NAME,
+	.class = ACPI_MDPS_CLASS,
+	.ids   = lis3lv02d_device_ids,
+	.ops = {
+		.add     = lis3lv02d_add,
+		.remove  = lis3lv02d_remove,
+		.suspend = lis3lv02d_suspend,
+		.resume  = lis3lv02d_resume,
+	}
+};
+
+static int __init lis3lv02d_init_module(void)
+{
+	int ret;
+
+	if (acpi_disabled)
+		return -ENODEV;
+
+	ret = acpi_bus_register_driver(&lis3lv02d_driver);
+	if (ret < 0)
+		return ret;
+
+	printk(KERN_INFO DRIVER_NAME " driver loaded.\n");
+
+	return 0;
+}
+
+static void __exit lis3lv02d_exit_module(void)
+{
+	acpi_bus_unregister_driver(&lis3lv02d_driver);
+}
+
+MODULE_DESCRIPTION("Glue between LIS3LV02Dx and HP ACPI BIOS and support for disk protection LED.");
+MODULE_AUTHOR("Yan Burman, Eric Piel, Pavel Machek");
+MODULE_LICENSE("GPL");
+
+module_init(lis3lv02d_init_module);
+module_exit(lis3lv02d_exit_module);
+
diff --git a/drivers/hwmon/lis3lv02d.c b/drivers/hwmon/lis3lv02d.c
index c002144..aef5958 100644
--- a/drivers/hwmon/lis3lv02d.c
+++ b/drivers/hwmon/lis3lv02d.c
@@ -3,6 +3,7 @@
  *
  *  Copyright (C) 2007-2008 Yan Burman
  *  Copyright (C) 2008 Eric Piel
+ *  Copyright (C) 2008 Pavel Machek
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
@@ -34,12 +35,12 @@ #include <linux/wait.h>
 #include <linux/poll.h>
 #include <linux/freezer.h>
 #include <linux/uaccess.h>
+#include <linux/miscdevice.h>
 #include <acpi/acpi_drivers.h>
 #include <asm/atomic.h>
 #include "lis3lv02d.h"
 
 #define DRIVER_NAME     "lis3lv02d"
-#define ACPI_MDPS_CLASS "accelerometer"
 
 /* joystick device poll interval in milliseconds */
 #define MDPS_POLL_INTERVAL 50
@@ -52,103 +53,31 @@ #define MDPS_POLL_INTERVAL 50
  * joystick.
  */
 
+/*
+ * Automatic timeout to turn off the device in jiffies.
+ * Don't do it too early as it's quite costly to turn it on.
+ */
+#define MDPS_TIMEOUT msecs_to_jiffies(30 * 1000) /* 30 seconds */
 /* Maximum value our axis may get for the input device (signed 12 bits) */
 #define MDPS_MAX_VAL 2048
 
-struct axis_conversion {
-	s8	x;
-	s8	y;
-	s8	z;
+struct acpi_lis3lv02d adev = {
+	.misc_wait   = __WAIT_QUEUE_HEAD_INITIALIZER(adev.misc_wait),
+	.poff_sem   = __SEMAPHORE_INITIALIZER(adev.poff_sem, 1),
+	.usage       = 0,
+	.misc_opened = 0,
 };
 
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
+EXPORT_SYMBOL_GPL(adev);
 
-static struct acpi_lis3lv02d adev;
-
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
@@ -190,54 +119,45 @@ static void lis3lv02d_get_xyz(acpi_handl
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
+EXPORT_SYMBOL_GPL(lis3lv02d_poweroff);
 
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
-}
-
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
+	adev.write(handle, CTRL_REG2, val);
+	if (test_bit(0, &adev.misc_opened)) {
+#if 0
+		/* Threshold not too big (10) */
+		lis3lv02d_write_16(handle, FF_WU_THS_L, 10);
 #endif
-
+		/* FIXME: All this should be done by BIOS, automagically */
+		/* 2 samples in a row before activation */
+		adev.write(handle, FF_WU_DURATION, 2);
+		/* detect every direction, don't wait for validation */
+		adev.write(handle, FF_WU_CFG, FF_WU_CFG_AOI
+			   	   | FF_WU_CFG_XLIE | FF_WU_CFG_XHIE
+				   | FF_WU_CFG_YLIE | FF_WU_CFG_YHIE
+				   | FF_WU_CFG_ZLIE | FF_WU_CFG_ZHIE);
+	}
+}
+EXPORT_SYMBOL_GPL(lis3lv02d_poweron);
 
 /*
  * To be called before starting to use the device. It makes sure that the
@@ -268,6 +188,202 @@ static void lis3lv02d_decrease_use(struc
 	mutex_unlock(&dev->lock);
 }
 
+static void lis3lv02d_poweroff_timeout(unsigned long data)
+{
+	struct acpi_lis3lv02d *dev = (void *)data;
+	up(&dev->poff_sem);
+	lis3lv02d_poweroff(dev->device->handle);
+	down(&dev->poff_sem);
+	printk(KERN_DEBUG DRIVER_NAME ": Turning off the device\n");
+}
+
+static irqreturn_t lis302dl_interrupt(int irq, void *dummy)
+{
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
+//	//lis3lv02d_display_reg(STATUS_REG);
+//	lis3lv02d_display_reg(FF_WU_SRC);
+//	lis3lv02d_display_reg(DD_SRC);
+//	//lis3lv02d_display_reg(CTRL_REG1);
+//	//lis3lv02d_display_reg(CTRL_REG2);
+//	//lis3lv02d_display_reg(CTRL_REG3);
+//	lis3lv02d_display_reg(FF_WU_ACK);
+//	lis3lv02d_display_reg(FF_WU_CFG);
+//	lis3lv02d_display_reg(DD_CFG);
+//	//lis3lv02d_display_reg(FF_WU_THS_L);
+//	//lis3lv02d_display_reg(FF_WU_THS_H);
+//	//lis3lv02d_display_reg(FF_WU_DURATION);
+//	//lis3lv02d_acpi_write(adev.device->handle, FF_WU_SRC, 0);
+//	printk(KERN_DEBUG DRIVER_NAME ": irq received\n");
+
+	return IRQ_HANDLED;
+}
+
+static int lis3lv02d_misc_open(struct inode *inode, struct file *file)
+{
+	int ret;
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
+	if (ret) {
+		clear_bit(0, &adev.misc_opened);
+		printk(KERN_ERR DRIVER_NAME ": IRQ%d allocation failed\n", adev.irq);
+		return -EBUSY;
+	}
+	lis3lv02d_increase_use(&adev);
+	printk("lis3: registered interrupt %d\n", adev.irq);
+	// TODO: set up the registers correctly
+//	lis3lv02d_display_reg(STATUS_REG);
+//	lis3lv02d_display_reg(CTRL_REG1);
+//	lis3lv02d_display_reg(CTRL_REG2);
+//	lis3lv02d_display_reg(CTRL_REG3);
+	//lis3lv02d_display_reg(FF_WU_CFG);
+//	lis3lv02d_display_reg(FF_WU_SRC);
+//	lis3lv02d_display_reg(FF_WU_THS_L);
+//	lis3lv02d_display_reg(FF_WU_THS_H);
+//	lis3lv02d_display_reg(FF_WU_DURATION);
+//	lis3lv02d_display_reg(DD_CFG);
+//	lis3lv02d_display_reg(DD_SRC);
+//	lis3lv02d_display_reg(DD_THSI_L);
+//	lis3lv02d_display_reg(DD_THSI_H);
+//	lis3lv02d_display_reg(DD_THSE_L);
+//	lis3lv02d_display_reg(DD_THSE_H);
+//	lis3lv02d_acpi_write(adev.device->handle, FF_WU_SRC, 0);
+	/* Threshold not too big (10) */
+//	lis3lv02d_write_16(adev.device->handle, FF_WU_THS_L, 10);
+//	/* 2 samples in a row before activation */
+//	lis3lv02d_acpi_write(adev.device->handle, FF_WU_DURATION, 2);
+//	/* detect every direction, don't wait for validation */
+	adev.write(adev.device->handle, FF_WU_CFG, 0);
+//	lis3lv02d_acpi_write(adev.device->handle, FF_WU_CFG, FF_WU_CFG_XLIE | FF_WU_CFG_XHIE
+//					| FF_WU_CFG_YLIE | FF_WU_CFG_YHIE
+//					| FF_WU_CFG_ZLIE | FF_WU_CFG_ZHIE);
+	// TODO after turning on, this generates one useless interrupt just after set up, it shouldn't be passed to userspace
+//	lis3lv02d_display_reg(STATUS_REG);
+//	lis3lv02d_display_reg(CTRL_REG1);
+//	lis3lv02d_display_reg(CTRL_REG2);
+//	lis3lv02d_display_reg(CTRL_REG3);
+	//lis3lv02d_display_reg(FF_WU_CFG);
+//	lis3lv02d_display_reg(FF_WU_SRC);
+//	lis3lv02d_display_reg(FF_WU_THS_L);
+//	lis3lv02d_display_reg(FF_WU_THS_H);
+//	lis3lv02d_display_reg(FF_WU_DURATION);
+//	lis3lv02d_display_reg(DD_CFG);
+//	lis3lv02d_display_reg(DD_SRC);
+//	lis3lv02d_display_reg(DD_THSI_L);
+//	lis3lv02d_display_reg(DD_THSI_H);
+//	lis3lv02d_display_reg(DD_THSE_L);
+//	lis3lv02d_display_reg(DD_THSE_H);
+
+	return 0;
+}
+
+static int lis3lv02d_misc_release(struct inode *inode, struct file *file)
+{
+	fasync_helper(-1, file, 0, &adev.async_queue);
+	adev.write(adev.device->handle, FF_WU_CFG, 0);
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
+	ssize_t retval = count;
+
+	if (count != sizeof(u32))
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
+	/* make sure we are not going into copy_to_user() with
+	 * TASK_INTERRUPTIBLE state */
+	set_current_state(TASK_RUNNING);
+	if (copy_to_user(buf, &data, sizeof(data)))
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
+	.name    = "accel",
+	.fops    = &lis3lv02d_misc_fops,
+};
+
 /**
  * lis3lv02d_joystick_kthread - Kthread polling function
  * @data: unused - here to conform to threadfn prototype
@@ -309,13 +425,36 @@ static void lis3lv02d_joystick_close(str
 	lis3lv02d_decrease_use(&adev);
 }
 
+static acpi_status
+lis3lv02d_get_resource(struct acpi_resource *resource, void *context)
+{
+	if (resource->type == ACPI_RESOURCE_TYPE_EXTENDED_IRQ) {
+		struct acpi_resource_extended_irq *irq;
+		u32 *device_irq = context;
+
+		irq = &resource->data.extended_irq;
+		*device_irq = irq->interrupts[0];
+	}
+
+	return AE_OK;
+}
+
+static void lis3lv02d_enum_resources(struct acpi_device *device)
+{
+	acpi_status status;
+
+	status = acpi_walk_resources(device->handle, METHOD_NAME__CRS,
+					lis3lv02d_get_resource, &adev.irq);
+	if (ACPI_FAILURE(status))
+		printk(KERN_DEBUG DRIVER_NAME ": Error getting resources\n");
+}
 
 static inline void lis3lv02d_calibrate_joystick(void)
 {
 	lis3lv02d_get_xyz(adev.device->handle, &adev.xcalib, &adev.ycalib, &adev.zcalib);
 }
 
-static int lis3lv02d_joystick_enable(void)
+int lis3lv02d_joystick_enable(void)
 {
 	int err;
 
@@ -349,120 +488,52 @@ static int lis3lv02d_joystick_enable(voi
 
 	return err;
 }
+EXPORT_SYMBOL_GPL(lis3lv02d_joystick_enable);
 
-static void lis3lv02d_joystick_disable(void)
+void lis3lv02d_joystick_disable(void)
 {
 	if (!adev.idev)
 		return;
 
+	misc_deregister(&lis3lv02d_misc_device);
 	input_unregister_device(adev.idev);
+	del_timer(&adev.poff_timer);
 	adev.idev = NULL;
 }
-
+EXPORT_SYMBOL_GPL(lis3lv02d_joystick_disable);
 
 /*
  * Initialise the accelerometer and the various subsystems.
  * Should be rather independant of the bus system.
  */
-static int lis3lv02d_init_device(struct acpi_lis3lv02d *dev)
+int lis3lv02d_init_device(struct acpi_lis3lv02d *dev)
 {
 	mutex_init(&dev->lock);
 	lis3lv02d_add_fs(dev->device);
+	setup_timer(&dev->poff_timer, lis3lv02d_poweroff_timeout, (unsigned long)dev);
+	init_timer_deferrable(&dev->poff_timer);
 	lis3lv02d_increase_use(dev);
 
 	if (lis3lv02d_joystick_enable())
 		printk(KERN_ERR DRIVER_NAME ": joystick initialization failed\n");
 
-	lis3lv02d_decrease_use(dev);
-	return 0;
-}
+	/* obtain IRQ number of our device from ACPI */
+	lis3lv02d_enum_resources(dev->device);
 
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
+	/* if we did not get an IRQ from ACPI - we have nothing more to do */
+	if (!dev->irq) {
 		printk(KERN_ERR DRIVER_NAME
-				": Accelerometer chip not LIS3LV02D{L,Q}\n");
+			": No IRQ in ACPI. Disabling /dev/accel\n");
+		goto out;
 	}
 
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
+	if (misc_register(&lis3lv02d_misc_device))
+		printk(KERN_ERR DRIVER_NAME ": misc_register failed\n");
+out:
+	lis3lv02d_decrease_use(dev);
+	return 0;
 }
-
+EXPORT_SYMBOL_GPL(lis3lv02d_init_device);
 
 /* Sysfs stuff */
 static ssize_t lis3lv02d_position_show(struct device *dev,
@@ -501,7 +572,7 @@ static ssize_t lis3lv02d_rate_show(struc
 	int val;
 
 	lis3lv02d_increase_use(&adev);
-	lis3lv02d_acpi_read(adev.device->handle, CTRL_REG1, &ctrl);
+	adev.read(adev.device->handle, CTRL_REG1, &ctrl);
 	lis3lv02d_decrease_use(&adev);
 	val = (ctrl & (CTRL1_DF0 | CTRL1_DF1)) >> 4;
 	return sprintf(buf, "%d\n", lis3lv02dl_df_val[val]);
@@ -523,6 +594,7 @@ static struct attribute_group lis3lv02d_
 	.attrs = lis3lv02d_attributes
 };
 
+
 static int lis3lv02d_add_fs(struct acpi_device *device)
 {
 	adev.pdev = platform_device_register_simple(DRIVER_NAME, -1, NULL, 0);
@@ -532,50 +604,15 @@ static int lis3lv02d_add_fs(struct acpi_
 	return sysfs_create_group(&adev.pdev->dev.kobj, &lis3lv02d_attribute_group);
 }
 
-static int lis3lv02d_remove_fs(void)
+int lis3lv02d_remove_fs(void)
 {
 	sysfs_remove_group(&adev.pdev->dev.kobj, &lis3lv02d_attribute_group);
 	platform_device_unregister(adev.pdev);
 	return 0;
 }
-
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
+EXPORT_SYMBOL_GPL(lis3lv02d_remove_fs);
 
 MODULE_DESCRIPTION("ST LIS3LV02Dx three-axis digital accelerometer driver");
 MODULE_AUTHOR("Yan Burman and Eric Piel");
 MODULE_LICENSE("GPL");
 
-module_init(lis3lv02d_init_module);
-module_exit(lis3lv02d_exit_module);
diff --git a/drivers/hwmon/lis3lv02d.h b/drivers/hwmon/lis3lv02d.h
index 330cfc6..14fbcd8 100644
--- a/drivers/hwmon/lis3lv02d.h
+++ b/drivers/hwmon/lis3lv02d.h
@@ -23,7 +23,7 @@
  * The actual chip is STMicroelectronics LIS3LV02DL or LIS3LV02DQ that seems to
  * be connected via SPI. There exists also several similar chips (such as LIS302DL or
  * LIS3L02DQ) but not in the HP laptops and they have slightly different registers.
- * They can also be connected via IĂËC.
+ * They can also be connected via IÂ˛C.
  */
 
 #define LIS3LV02DL_ID	0x3A /* Also the LIS3LV02DQ */
@@ -147,3 +147,43 @@ enum lis3lv02d_dd_src {
 	DD_SRC_IA	= 0x40,
 };
 
+struct axis_conversion {
+	s8	x;
+	s8	y;
+	s8	z;
+};
+
+struct acpi_lis3lv02d {
+	struct acpi_device	*device;   /* The ACPI device */
+	acpi_status (*init) (acpi_handle handle);
+	acpi_status (*write) (acpi_handle handle, int reg, u8 val);
+	acpi_status (*read) (acpi_handle handle, int reg, u8 *ret);
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
+
+	u32			irq;       /* IRQ number */
+	struct timer_list	poff_timer; /* for automatic power off */
+	struct semaphore	poff_sem;  /* lock to handle on/off timer */
+	struct fasync_struct	*async_queue; /* queue for the misc device */
+	wait_queue_head_t	misc_wait; /* Wait queue for the misc device */
+	unsigned long		misc_opened; /* bit0: whether the device is open */
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
