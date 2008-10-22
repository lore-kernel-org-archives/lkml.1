Return-Path: <linux-kernel-owner+w=401wt.eu-S1756904AbYJVPnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904AbYJVPnj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 11:43:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751665AbYJVPn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 11:43:29 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:37097 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458AbYJVPn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 11:43:28 -0400
Date: Wed, 22 Oct 2008 17:44:59 +0200
From: Pavel Machek <pavel@suse.cz>
To: Andrew Morton <akpm@osdl.org>, kernel list <linux-kernel@vger.kernel.org>,
       Eric Piel <eric.piel@tremplin-utc.net>,
       Yan Burman <burman.yan@gmail.com>, Pau Oliva Fora <pau@eslack.org>
Subject: [PATCH] LIS3LV02Dx Accelerometer driver
Message-ID: <20081022154459.GA26291@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


LIS3LV02Dx Accelerometer driver

This adds a driver to the accelerometer sensor found in several HP
laptops (under the commercial names of "HP Mobile Data Protection
System 3D" and "HP 3D driveguard"). It tries to have more or less the
same interfaces as the hdaps and other accelerometer drivers: in sysfs
and as a joystick.

This driver was first written by Yan Burman. Eric Piel has updated it
and slimed it up (including the removal of an interface to access to
the free-fall feature of the sensor because it is not reliable enough
for now). Pavel Machek removed few more features and switched locking
from semaphore to mutex.

Several people have contributed to the database of the axes.

Signed-off-by: Eric Piel <eric.piel@tremplin-utc.net>
Signed-off-by: Yan Burman <burman.yan@gmail.com>
Signed-off-by: Pavel Machek <pavel@suse.cz>

---
This should fix the locking and all the comments from Andrew. Relative
to 2.6.27-git10.

 MAINTAINERS                         |    5 
 linux/Documentation/hwmon/lis3lv02d |   49 +++
 linux/drivers/hwmon/Kconfig         |   19 +
 linux/drivers/hwmon/Makefile        |    1 
 linux/drivers/hwmon/lis3lv02d.c     |  582 ++++++++++++++++++++++++++++++++++++
 linux/drivers/hwmon/lis3lv02d.h     |  149 +++++++++
 6 files changed, 805 insertions(+)


diff -urN -X linux/.gitignore clean/drivers/hwmon/Kconfig linux/drivers/hwmon/Kconfig
--- clean/drivers/hwmon/Kconfig	2008-10-22 16:16:26.000000000 +0200
+++ linux/drivers/hwmon/Kconfig	2008-10-22 13:15:26.000000000 +0200
@@ -825,6 +825,25 @@
 	  Say Y here if you have an applicable laptop and want to experience
 	  the awesome power of hdaps.
 
+config SENSORS_LIS3LV02D
+	tristate "STMicroeletronics LIS3LV02Dx three-axis digital accelerometer"
+	depends on ACPI && INPUT
+	default n
+	help
+	  This driver provides support for the LIS3LV02Dx accelerometer. In
+	  particular, it can be found in a number of HP laptops, which have the
+	  "Mobile Data Protection System 3D" or "3D DriveGuard" feature. On such
+	  systems the driver should load automatically (via ACPI). The
+	  accelerometer might also be found in other systems, connected via SPI
+	  or IÂ˛C.  The accelerometer data is readable via
+	  /sys/devices/platform/lis3lv02d.
+
+	  This driver also provides an absolute input class device, allowing
+	  the laptop to act as a pinball machine-esque joystick.
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called lis3lv02d.
+
 config SENSORS_APPLESMC
 	tristate "Apple SMC (Motion sensor, light sensor, keyboard backlight)"
 	depends on INPUT && X86
diff -urN -X linux/.gitignore clean/drivers/hwmon/Makefile linux/drivers/hwmon/Makefile
--- clean/drivers/hwmon/Makefile	2008-10-22 16:16:26.000000000 +0200
+++ linux/drivers/hwmon/Makefile	2008-10-22 13:21:14.000000000 +0200
@@ -48,6 +48,7 @@
 obj-$(CONFIG_SENSORS_IBMPEX)	+= ibmpex.o
 obj-$(CONFIG_SENSORS_IT87)	+= it87.o
 obj-$(CONFIG_SENSORS_K8TEMP)	+= k8temp.o
+obj-$(CONFIG_SENSORS_LIS3LV02D) += lis3lv02d.o
 obj-$(CONFIG_SENSORS_LM63)	+= lm63.o
 obj-$(CONFIG_SENSORS_LM70)	+= lm70.o
 obj-$(CONFIG_SENSORS_LM75)	+= lm75.o
diff -urN -X linux/.gitignore clean/drivers/hwmon/lis3lv02d.c linux/drivers/hwmon/lis3lv02d.c
--- clean/drivers/hwmon/lis3lv02d.c	1970-01-01 01:00:00.000000000 +0100
+++ linux/drivers/hwmon/lis3lv02d.c	2008-10-22 17:25:08.000000000 +0200
@@ -0,0 +1,582 @@
+/*
+ *  lis3lv02d.c - ST LIS3LV02DL accelerometer driver
+ *
+ *  Copyright (C) 2007-2008 Yan Burman
+ *  Copyright (C) 2008 Eric Piel
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
+#include <acpi/acpi_drivers.h>
+#include <asm/atomic.h>
+#include "lis3lv02d.h"
+
+#define DRIVER_NAME     "lis3lv02d"
+#define ACPI_MDPS_CLASS "accelerometer"
+
+/* joystick device poll interval in milliseconds */
+#define MDPS_POLL_INTERVAL 50
+/*
+ * The sensor can also generate interrupts (DRDY) but it's pretty pointless
+ * because their are generated even if the data do not change. So it's better
+ * to keep the interrupt for the free-fall event. The values are updated at
+ * 40Hz (at the lowest frequency), but as it can be pretty time consuming on
+ * some low processor, we poll the sensor only at 20Hz... enough for the
+ * joystick.
+ */
+
+/* Maximum value our axis may get for the input device (signed 12 bits) */
+#define MDPS_MAX_VAL 2048
+
+struct axis_conversion {
+	s8	x;
+	s8	y;
+	s8	z;
+};
+
+struct acpi_lis3lv02d {
+	struct acpi_device	*device;   /* The ACPI device */
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
+static struct acpi_lis3lv02d adev;
+
+static int lis3lv02d_remove_fs(void);
+static int lis3lv02d_add_fs(struct acpi_device *device);
+
+/* For automatic insertion of the module */
+static struct acpi_device_id lis3lv02d_device_ids[] = {
+	{"HPQ0004", 0}, /* HP Mobile Data Protection System PNP */
+	{"", 0},
+};
+MODULE_DEVICE_TABLE(acpi, lis3lv02d_device_ids);
+
+/**
+ * lis3lv02d_acpi_init - ACPI _INI method: initialize the device.
+ * @handle: the handle of the device
+ *
+ * Returns AE_OK on success.
+ */
+static inline acpi_status lis3lv02d_acpi_init(acpi_handle handle)
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
+static acpi_status lis3lv02d_acpi_read(acpi_handle handle, int reg, u8 *ret)
+{
+	union acpi_object arg0 = { ACPI_TYPE_INTEGER };
+	struct acpi_object_list args = { 1, &arg0 };
+	unsigned long lret;
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
+static acpi_status lis3lv02d_acpi_write(acpi_handle handle, int reg, u8 val)
+{
+	unsigned long ret; /* Not used when writting */
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
+static s16 lis3lv02d_read_16(acpi_handle handle, int reg)
+{
+	u8 lo, hi;
+
+	lis3lv02d_acpi_read(handle, reg, &lo);
+	lis3lv02d_acpi_read(handle, reg + 1, &hi);
+	/* In "12 bit right justified" mode, bit 6, bit 7, bit 8 = bit 5 */
+	return (s16)((hi << 8) | lo);
+}
+
+/**
+ * lis3lv02d_get_axis - For the given axis, give the value converted
+ * @axis:      1,2,3 - can also be negative
+ * @hw_values: raw values returned by the hardware
+ *
+ * Returns the converted value.
+ */
+static inline int lis3lv02d_get_axis(s8 axis, int hw_values[3])
+{
+	if (axis > 0)
+		return hw_values[axis - 1];
+	else
+		return -hw_values[-axis - 1];
+}
+
+/**
+ * lis3lv02d_get_xyz - Get X, Y and Z axis values from the accelerometer
+ * @handle: the handle to the device
+ * @x:      where to store the X axis value
+ * @y:      where to store the Y axis value
+ * @z:      where to store the Z axis value
+ *
+ * Note that 40Hz input device can eat up about 10% CPU at 800MHZ
+ */
+static void lis3lv02d_get_xyz(acpi_handle handle, int *x, int *y, int *z)
+{
+	int position[3];
+
+	position[0] = lis3lv02d_read_16(handle, OUTX_L);
+	position[1] = lis3lv02d_read_16(handle, OUTY_L);
+	position[2] = lis3lv02d_read_16(handle, OUTZ_L);
+
+	*x = lis3lv02d_get_axis(adev.ac.x, position);
+	*y = lis3lv02d_get_axis(adev.ac.y, position);
+	*z = lis3lv02d_get_axis(adev.ac.z, position);
+}
+
+static inline void lis3lv02d_poweroff(acpi_handle handle)
+{
+	adev.is_on = 0;
+	/* disable X,Y,Z axis and power down */
+	lis3lv02d_acpi_write(handle, CTRL_REG1, 0x00);
+}
+
+static void lis3lv02d_poweron(acpi_handle handle)
+{
+	u8 val;
+
+	adev.is_on = 1;
+	lis3lv02d_acpi_init(handle);
+	lis3lv02d_acpi_write(handle, FF_WU_CFG, 0);
+	/*
+	 * BDU: LSB and MSB values are not updated until both have been read.
+	 *      So the value read will always be correct.
+	 * IEN: Interrupt for free-fall and DD, not for data-ready.
+	 */
+	lis3lv02d_acpi_read(handle, CTRL_REG2, &val);
+	val |= CTRL2_BDU | CTRL2_IEN;
+	lis3lv02d_acpi_write(handle, CTRL_REG2, val);
+}
+
+#ifdef CONFIG_PM
+static int lis3lv02d_suspend(struct acpi_device *device, pm_message_t state)
+{
+	/* make sure the device is off when we suspend */
+	lis3lv02d_poweroff(device->handle);
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
+	return 0;
+}
+#else
+#define lis3lv02d_suspend NULL
+#define lis3lv02d_resume NULL
+#endif
+
+
+/*
+ * To be called before starting to use the device. It makes sure that the
+ * device will always be on until a call to lis3lv02d_decrease_use(). Not to be
+ * used from interrupt context.
+ */
+static void lis3lv02d_increase_use(struct acpi_lis3lv02d *dev)
+{
+	mutex_lock(&dev->lock);
+	dev->usage++;
+	if (dev->usage == 1) {
+		if (!dev->is_on)
+			lis3lv02d_poweron(dev->device->handle);
+	}
+	mutex_unlock(&dev->lock);
+}
+
+/*
+ * To be called whenever a usage of the device is stopped.
+ * It will make sure to turn off the device when there is not usage.
+ */
+static void lis3lv02d_decrease_use(struct acpi_lis3lv02d *dev)
+{
+	mutex_lock(&dev->lock);
+	dev->usage--;
+	if (dev->usage == 0)
+		lis3lv02d_poweroff(dev->device->handle);
+	mutex_unlock(&dev->lock);
+}
+
+/**
+ * lis3lv02d_joystick_kthread - Kthread polling function
+ * @data: unused - here to conform to threadfn prototype
+ */
+static int lis3lv02d_joystick_kthread(void *data)
+{
+	int x, y, z;
+
+	while (!kthread_should_stop()) {
+		lis3lv02d_get_xyz(adev.device->handle, &x, &y, &z);
+		input_report_abs(adev.idev, ABS_X, x - adev.xcalib);
+		input_report_abs(adev.idev, ABS_Y, y - adev.ycalib);
+		input_report_abs(adev.idev, ABS_Z, z - adev.zcalib);
+
+		input_sync(adev.idev);
+
+		try_to_freeze();
+		msleep_interruptible(MDPS_POLL_INTERVAL);
+	}
+
+	return 0;
+}
+
+static int lis3lv02d_joystick_open(struct input_dev *input)
+{
+	lis3lv02d_increase_use(&adev);
+	adev.kthread = kthread_run(lis3lv02d_joystick_kthread, NULL, "klis3lv02d");
+	if (IS_ERR(adev.kthread)) {
+		lis3lv02d_decrease_use(&adev);
+		return PTR_ERR(adev.kthread);
+	}
+
+	return 0;
+}
+
+static void lis3lv02d_joystick_close(struct input_dev *input)
+{
+	kthread_stop(adev.kthread);
+	lis3lv02d_decrease_use(&adev);
+}
+
+
+static inline void lis3lv02d_calibrate_joystick(void)
+{
+	lis3lv02d_get_xyz(adev.device->handle, &adev.xcalib, &adev.ycalib, &adev.zcalib);
+}
+
+static int lis3lv02d_joystick_enable(void)
+{
+	int err;
+
+	if (adev.idev)
+		return -EINVAL;
+
+	adev.idev = input_allocate_device();
+	if (!adev.idev)
+		return -ENOMEM;
+
+	lis3lv02d_calibrate_joystick();
+
+	adev.idev->name       = "ST LIS3LV02DL Accelerometer";
+	adev.idev->phys       = DRIVER_NAME "/input0";
+	adev.idev->id.bustype = BUS_HOST;
+	adev.idev->id.vendor  = 0;
+	adev.idev->dev.parent = &adev.pdev->dev;
+	adev.idev->open       = lis3lv02d_joystick_open;
+	adev.idev->close      = lis3lv02d_joystick_close;
+
+	set_bit(EV_ABS, adev.idev->evbit);
+	input_set_abs_params(adev.idev, ABS_X, -MDPS_MAX_VAL, MDPS_MAX_VAL, 3, 3);
+	input_set_abs_params(adev.idev, ABS_Y, -MDPS_MAX_VAL, MDPS_MAX_VAL, 3, 3);
+	input_set_abs_params(adev.idev, ABS_Z, -MDPS_MAX_VAL, MDPS_MAX_VAL, 3, 3);
+
+	err = input_register_device(adev.idev);
+	if (err) {
+		input_free_device(adev.idev);
+		adev.idev = NULL;
+	}
+
+	return err;
+}
+
+static void lis3lv02d_joystick_disable(void)
+{
+	if (!adev.idev)
+		return;
+
+	input_unregister_device(adev.idev);
+	adev.idev = NULL;
+}
+
+
+/*
+ * Initialise the accelerometer and the various subsystems.
+ * Should be rather independant of the bus system.
+ */
+static int lis3lv02d_init_device(struct acpi_lis3lv02d *dev)
+{
+	mutex_init(&dev->lock);
+	lis3lv02d_add_fs(dev->device);
+	lis3lv02d_increase_use(dev);
+
+	if (lis3lv02d_joystick_enable())
+		printk(KERN_ERR DRIVER_NAME ": joystick initialization failed\n");
+
+	lis3lv02d_decrease_use(dev);
+	return 0;
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
+static int lis3lv02d_add(struct acpi_device *device)
+{
+	u8 val;
+
+	if (!device)
+		return -EINVAL;
+
+	adev.device = device;
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
+	return lis3lv02d_init_device(&adev);
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
+	return lis3lv02d_remove_fs();
+}
+
+
+/* Sysfs stuff */
+static ssize_t lis3lv02d_position_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	int x, y, z;
+
+	lis3lv02d_increase_use(&adev);
+	lis3lv02d_get_xyz(adev.device->handle, &x, &y, &z);
+	lis3lv02d_decrease_use(&adev);
+	return sprintf(buf, "(%d,%d,%d)\n", x, y, z);
+}
+
+static ssize_t lis3lv02d_calibrate_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "(%d,%d,%d)\n", adev.xcalib, adev.ycalib, adev.zcalib);
+}
+
+static ssize_t lis3lv02d_calibrate_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	lis3lv02d_increase_use(&adev);
+	lis3lv02d_calibrate_joystick();
+	lis3lv02d_decrease_use(&adev);
+	return count;
+}
+
+/* conversion btw sampling rate and the register values */
+static int lis3lv02dl_df_val[4] = {40, 160, 640, 2560};
+static ssize_t lis3lv02d_rate_show(struct device *dev,
+			struct device_attribute *attr, char *buf)
+{
+	u8 ctrl;
+	int val;
+
+	lis3lv02d_increase_use(&adev);
+	lis3lv02d_acpi_read(adev.device->handle, CTRL_REG1, &ctrl);
+	lis3lv02d_decrease_use(&adev);
+	val = (ctrl & (CTRL1_DF0 | CTRL1_DF1)) >> 4;
+	return sprintf(buf, "%d\n", lis3lv02dl_df_val[val]);
+}
+
+static DEVICE_ATTR(position, S_IRUGO, lis3lv02d_position_show, NULL);
+static DEVICE_ATTR(calibrate, S_IRUGO|S_IWUSR, lis3lv02d_calibrate_show,
+	lis3lv02d_calibrate_store);
+static DEVICE_ATTR(rate, S_IRUGO, lis3lv02d_rate_show, NULL);
+
+static struct attribute *lis3lv02d_attributes[] = {
+	&dev_attr_position.attr,
+	&dev_attr_calibrate.attr,
+	&dev_attr_rate.attr,
+	NULL
+};
+
+static struct attribute_group lis3lv02d_attribute_group = {
+	.attrs = lis3lv02d_attributes
+};
+
+static int lis3lv02d_add_fs(struct acpi_device *device)
+{
+	adev.pdev = platform_device_register_simple(DRIVER_NAME, -1, NULL, 0);
+	if (IS_ERR(adev.pdev))
+		return PTR_ERR(adev.pdev);
+
+	return sysfs_create_group(&adev.pdev->dev.kobj, &lis3lv02d_attribute_group);
+}
+
+static int lis3lv02d_remove_fs(void)
+{
+	sysfs_remove_group(&adev.pdev->dev.kobj, &lis3lv02d_attribute_group);
+	platform_device_unregister(adev.pdev);
+	return 0;
+}
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
+MODULE_DESCRIPTION("ST LIS3LV02Dx three-axis digital accelerometer driver");
+MODULE_AUTHOR("Yan Burman and Eric Piel");
+MODULE_LICENSE("GPL");
+
+module_init(lis3lv02d_init_module);
+module_exit(lis3lv02d_exit_module);
diff -urN -X linux/.gitignore clean/drivers/hwmon/lis3lv02d.h linux/drivers/hwmon/lis3lv02d.h
--- clean/drivers/hwmon/lis3lv02d.h	1970-01-01 01:00:00.000000000 +0100
+++ linux/drivers/hwmon/lis3lv02d.h	2008-10-22 13:15:26.000000000 +0200
@@ -0,0 +1,149 @@
+/*
+ *  lis3lv02d.h - ST LIS3LV02DL accelerometer driver
+ *
+ *  Copyright (C) 2007-2008 Yan Burman
+ *  Copyright (C) 2008 Eric Piel
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
+/*
+ * The actual chip is STMicroelectronics LIS3LV02DL or LIS3LV02DQ that seems to
+ * be connected via SPI. There exists also several similar chips (such as LIS302DL or
+ * LIS3L02DQ) but not in the HP laptops and they have slightly different registers.
+ * They can also be connected via IÂ˛C.
+ */
+
+#define LIS3LV02DL_ID	0x3A /* Also the LIS3LV02DQ */
+#define LIS302DL_ID	0x3B /* Also the LIS202DL! */
+
+enum lis3lv02d_reg {
+	WHO_AM_I	= 0x0F,
+	OFFSET_X	= 0x16,
+	OFFSET_Y	= 0x17,
+	OFFSET_Z	= 0x18,
+	GAIN_X		= 0x19,
+	GAIN_Y		= 0x1A,
+	GAIN_Z		= 0x1B,
+	CTRL_REG1	= 0x20,
+	CTRL_REG2	= 0x21,
+	CTRL_REG3	= 0x22,
+	HP_FILTER_RESET	= 0x23,
+	STATUS_REG	= 0x27,
+	OUTX_L		= 0x28,
+	OUTX_H		= 0x29,
+	OUTY_L		= 0x2A,
+	OUTY_H		= 0x2B,
+	OUTZ_L		= 0x2C,
+	OUTZ_H		= 0x2D,
+	FF_WU_CFG	= 0x30,
+	FF_WU_SRC	= 0x31,
+	FF_WU_ACK	= 0x32,
+	FF_WU_THS_L	= 0x34,
+	FF_WU_THS_H	= 0x35,
+	FF_WU_DURATION	= 0x36,
+	DD_CFG		= 0x38,
+	DD_SRC		= 0x39,
+	DD_ACK		= 0x3A,
+	DD_THSI_L	= 0x3C,
+	DD_THSI_H	= 0x3D,
+	DD_THSE_L	= 0x3E,
+	DD_THSE_H	= 0x3F,
+};
+
+enum lis3lv02d_ctrl1 {
+	CTRL1_Xen	= 0x01,
+	CTRL1_Yen	= 0x02,
+	CTRL1_Zen	= 0x04,
+	CTRL1_ST	= 0x08,
+	CTRL1_DF0	= 0x10,
+	CTRL1_DF1	= 0x20,
+	CTRL1_PD0	= 0x40,
+	CTRL1_PD1	= 0x80,
+};
+enum lis3lv02d_ctrl2 {
+	CTRL2_DAS	= 0x01,
+	CTRL2_SIM	= 0x02,
+	CTRL2_DRDY	= 0x04,
+	CTRL2_IEN	= 0x08,
+	CTRL2_BOOT	= 0x10,
+	CTRL2_BLE	= 0x20,
+	CTRL2_BDU	= 0x40, /* Block Data Update */
+	CTRL2_FS	= 0x80, /* Full Scale selection */
+};
+
+
+enum lis3lv02d_ctrl3 {
+	CTRL3_CFS0	= 0x01,
+	CTRL3_CFS1	= 0x02,
+	CTRL3_FDS	= 0x10,
+	CTRL3_HPFF	= 0x20,
+	CTRL3_HPDD	= 0x40,
+	CTRL3_ECK	= 0x80,
+};
+
+enum lis3lv02d_status_reg {
+	STATUS_XDA	= 0x01,
+	STATUS_YDA	= 0x02,
+	STATUS_ZDA	= 0x04,
+	STATUS_XYZDA	= 0x08,
+	STATUS_XOR	= 0x10,
+	STATUS_YOR	= 0x20,
+	STATUS_ZOR	= 0x40,
+	STATUS_XYZOR	= 0x80,
+};
+
+enum lis3lv02d_ff_wu_cfg {
+	FF_WU_CFG_XLIE	= 0x01,
+	FF_WU_CFG_XHIE	= 0x02,
+	FF_WU_CFG_YLIE	= 0x04,
+	FF_WU_CFG_YHIE	= 0x08,
+	FF_WU_CFG_ZLIE	= 0x10,
+	FF_WU_CFG_ZHIE	= 0x20,
+	FF_WU_CFG_LIR	= 0x40,
+	FF_WU_CFG_AOI	= 0x80,
+};
+
+enum lis3lv02d_ff_wu_src {
+	FF_WU_SRC_XL	= 0x01,
+	FF_WU_SRC_XH	= 0x02,
+	FF_WU_SRC_YL	= 0x04,
+	FF_WU_SRC_YH	= 0x08,
+	FF_WU_SRC_ZL	= 0x10,
+	FF_WU_SRC_ZH	= 0x20,
+	FF_WU_SRC_IA	= 0x40,
+};
+
+enum lis3lv02d_dd_cfg {
+	DD_CFG_XLIE	= 0x01,
+	DD_CFG_XHIE	= 0x02,
+	DD_CFG_YLIE	= 0x04,
+	DD_CFG_YHIE	= 0x08,
+	DD_CFG_ZLIE	= 0x10,
+	DD_CFG_ZHIE	= 0x20,
+	DD_CFG_LIR	= 0x40,
+	DD_CFG_IEND	= 0x80,
+};
+
+enum lis3lv02d_dd_src {
+	DD_SRC_XL	= 0x01,
+	DD_SRC_XH	= 0x02,
+	DD_SRC_YL	= 0x04,
+	DD_SRC_YH	= 0x08,
+	DD_SRC_ZL	= 0x10,
+	DD_SRC_ZH	= 0x20,
+	DD_SRC_IA	= 0x40,
+};
+
diff -urN -X linux/.gitignore clean/Documentation/hwmon/lis3lv02d linux/Documentation/hwmon/lis3lv02d
--- clean/Documentation/hwmon/lis3lv02d	1970-01-01 01:00:00.000000000 +0100
+++ linux/Documentation/hwmon/lis3lv02d	2008-10-22 13:15:00.000000000 +0200
@@ -0,0 +1,49 @@
+Kernel driver lis3lv02d
+==================
+
+Supported chips:
+
+  * STMicroelectronics LIS3LV02DL and LIS3LV02DQ
+
+Author:
+        Yan Burman <burman.yan@gmail.com>
+	Eric Piel <eric.piel@tremplin-utc.net>
+
+
+Description
+-----------
+
+This driver provides support for the accelerometer found in various HP laptops
+sporting the feature officially called "HP Mobile Data Protection System 3D" or
+"HP 3D DriveGuard". It detect automatically laptops with this sensor. Known models
+(for now the HP 2133, nc6420, nc2510, nc8510, nc84x0, nw9440 and nx9420) will
+have their axis automatically oriented on standard way (eg: you can directly
+play neverball).  The accelerometer data is readable via
+/sys/devices/platform/lis3lv02d.
+
+Sysfs attributes under /sys/devices/platform/lis3lv02d/:
+position - 3D position that the accelerometer reports. Format: "(x,y,z)"
+calibrate - read: values (x, y, z) that are used as the base for input class device operation.
+            write: forces the base to be recalibrated with the current position.
+rate - reports the sampling rate of the accelerometer device in HZ
+
+This driver also provides an absolute input class device, allowing
+the laptop to act as a pinball machine-esque joystick.
+
+Axes orientation
+----------------
+
+For better compatibility between the various laptops. The values reported by
+the accelerometer are converted into a "standard" organisation of the axes
+(aka "can play neverball out of the box"):
+ * When the laptop is horizontal the position reported is about 0 for X and Y
+and a positive value for Z
+ * If the left side is elevated, X increases (becomes positive)
+ * If the front side (where the touchpad is) is elevated, Y decreases (becomes negative)
+ * If the laptop is put upside-down, Z becomes negative
+
+If your laptop model is not recognized (cf "dmesg"), you can send an email to the
+authors to add it to the database.  When reporting a new laptop, please include
+the output of "dmidecode" plus the value of /sys/devices/platform/lis3lv02d/position
+in these four cases.
+
--- clean/MAINTAINERS	2008-10-22 16:16:03.000000000 +0200
+++ linux/MAINTAINERS	2008-10-22 13:15:00.000000000 +0200
@@ -2638,6 +2638,11 @@
 M:	acme@ghostprotocols.net
 S:	Maintained
 
+LIS3LV02D ACCELEROMETER DRIVER
+P:	Eric Piel
+M:	eric.piel@tremplin-utc.net
+S:	Maintained
+
 LM83 HARDWARE MONITOR DRIVER
 P:	Jean Delvare
 M:	khali@linux-fr.org


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
