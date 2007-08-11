Return-Path: <linux-kernel-owner+w=401wt.eu-S1760772AbXHKLdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760772AbXHKLdY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 07:33:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754101AbXHKLdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 07:33:14 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:21029 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbXHKLdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 07:33:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=rsHUkR4lKA2H/v5oVzsHQ7tHatWg4aVDnGsq/kLmaItMmnKtYENPaPcV6+8+Pia7p+iuRXikk/hNfBQAihUEXh7Gia4/iA0JsmeNKNcpsTIuny48TtCT/tSWOPDxWoo82RO7A7dUFsiwWgTK8gKfGgCQ7G+jiNesACxcWa71GME=
Subject: [PATCH 2.6.23-rc2]  hwmon: HP Mobile Data Protection System 3D
	ACPI driver (resend)
From: Yan Burman <burman.yan@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: khali@linux-fr.org
Content-Type: text/plain
Date: Sat, 11 Aug 2007 14:26:02 +0300
Message-Id: <1186831562.6452.10.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 (2.6.3-2.fc5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

HP Mobile Data Protection System 3D ACPI driver. Similar to hdaps in functionality.
This driver provides 4 kinds of functionality:
1) Creates a misc device /dev/accel that acts similar to /dev/rtc and unblocks
the process reading from it when the device detects free-fall interrupt
2) Functions as an input class device to provide similar functionality to
hdaps, in order to be able to use the laptop as a joystick
3) Provides an interface similar to hdaps, so that hdapsd could work with it
4) Makes it possible to power the device off.

Applications such as hdaps-gl and hdapsd as well as neverball work with
this driver unmodified.

Changes:
Fixed all checkpatch warnings/errors
Fixed a potential race in getting the coordinates
Fixed TASK_INTERRUPTIBLE handling
Fixed documentation to state that nw9440 is also supported (it was reported to work)

Signed-off-by: Yan Burman <burman.yan@gmail.com>

diff -Nrubp linux-2.6.23-rc2_orig/Documentation/hwmon/mdps linux-2.6.23-rc2/Documentation/hwmon/mdps
--- linux-2.6.23-rc2_orig/Documentation/hwmon/mdps	1970-01-01 02:00:00.000000000 +0200
+++ linux-2.6.23-rc2/Documentation/hwmon/mdps	2007-08-10 13:39:00.000000000 +0300
@@ -0,0 +1,86 @@
+Kernel driver mdps
+==================
+
+Supported chips:
+
+  * STMicroelectronics LIS3LV02DL and LIS3LV02DQ
+
+Author:
+        Yan Burman <burman.yan@gmail.com>
+
+
+Description
+-----------
+
+This driver provides support for the HP Mobile Data Protection
+System 3D (mdps), which is an accelerometer. HP nc6420, nw9440 and nx9420
+are supported right now, but it may work on other models as well. The
+accelerometer data is readable via /sys/devices/platform/mdps.
+
+Sysfs attributes under /sys/devices/platform/mdps/:
+position - 2D position that the accelerometer reports. Format: "(x,y)"
+position3d - 3D position that the accelerometer reports. Format: "(x,y,z)"
+calibrate - read: values (x, y) that are used as the base for input class device operation.
+            write: forces the base to be recalibrated.
+rate - reports the sampling rate of the accelerometer device in HZ
+state - read: the current power state of the accelerometer device
+        write: "0" or "1" to power on/off the device
+joystick - read: whether the input class device is active or not
+           write: "0" or "1" to enable/disable the input device
+
+Load time parameters:
+bool joystick - whether to enable the input class device or not (default 1)
+bool power_off - whether to power off the device on module load (default 0)
+bool hdaps_compat - Make the driver export same interfaces as hdaps,
+	so that apps like hdaps-gl will work the same as with hdaps (default 0)
+	The effect of this is:
+	1) Instead of /sys/devices/platform/mdps/, /sys/devices/platform/hdaps/ is created
+	2) Sensitivity is adjusted to match that of hdaps
+bool input_3d - Whether to operate as a 3D input device. (default 0)
+		BIG FAT WARNING: Do not enable this mode unless you are sure
+		that you want it, since it eats more CPU
+
+This driver also provides an absolute input class device, allowing
+the laptop to act as a pinball machine-esque joystick.
+
+Another feature of the driver is misc device called accel that acts
+similar to /dev/rtc and reacts on free-fall interrupts received from
+the device. It supports blocking operations, poll/select and fasync
+operation modes. You must read 4 bytes from the device.
+The result is number of free-fall interrupts since the last successful read.
+
+Example userspace code:
+
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
+	int fd, ret;
+	uint32_t count;
+
+	fd = open("/dev/accel", O_RDONLY);
+	if (fd < 0) {
+		perror("open");
+		return EXIT_FAILURE;
+	}
+
+	for (;;) {
+		ret = read(fd, &count, sizeof(count));
+		if (ret != sizeof(count)) {
+			perror("read");
+			break;
+		}
+
+		printf("Got %d free-fall interrupts\n", count);
+	}
+
+	close(fd);
+	return EXIT_SUCCESS;
+}
diff -Nrubp linux-2.6.23-rc2_orig/drivers/hwmon/Kconfig linux-2.6.23-rc2/drivers/hwmon/Kconfig
--- linux-2.6.23-rc2_orig/drivers/hwmon/Kconfig	2007-08-10 13:37:23.000000000 +0300
+++ linux-2.6.23-rc2/drivers/hwmon/Kconfig	2007-08-10 13:39:00.000000000 +0300
@@ -660,6 +660,26 @@ config SENSORS_HDAPS
 	  Say Y here if you have an applicable laptop and want to experience
 	  the awesome power of hdaps.
 
+config SENSORS_MDPS
+	tristate "HP Mobile Data Protection System 3D (mdps)"
+	depends on ACPI && INPUT && X86
+	default n
+	help
+	  This driver provides support for the HP Mobile Data Protection
+	  System 3D (mdps), which is an accelerometer. HP nc6420, nw9440 and nx9420
+	  are supported right now, but it may work on other models as well. The
+	  accelerometer data is readable via /sys/devices/platform/mdps.
+
+	  This driver also provides an absolute input class device, allowing
+	  the laptop to act as a pinball machine-esque joystick.
+
+	  Another feature of the driver is misc device called accel that acts
+	  similar to /dev/rtc and reacts on free-fall interrupts received from
+	  the device.
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called mdps.
+
 config SENSORS_APPLESMC
 	tristate "Apple SMC (Motion sensor, light sensor, keyboard backlight)"
 	depends on INPUT && X86
diff -Nrubp linux-2.6.23-rc2_orig/drivers/hwmon/Makefile linux-2.6.23-rc2/drivers/hwmon/Makefile
--- linux-2.6.23-rc2_orig/drivers/hwmon/Makefile	2007-08-10 13:37:23.000000000 +0300
+++ linux-2.6.23-rc2/drivers/hwmon/Makefile	2007-08-10 13:39:00.000000000 +0300
@@ -34,6 +34,7 @@ obj-$(CONFIG_SENSORS_FSCPOS)	+= fscpos.o
 obj-$(CONFIG_SENSORS_GL518SM)	+= gl518sm.o
 obj-$(CONFIG_SENSORS_GL520SM)	+= gl520sm.o
 obj-$(CONFIG_SENSORS_HDAPS)	+= hdaps.o
+obj-$(CONFIG_SENSORS_MDPS)	+= mdps.o
 obj-$(CONFIG_SENSORS_IT87)	+= it87.o
 obj-$(CONFIG_SENSORS_K8TEMP)	+= k8temp.o
 obj-$(CONFIG_SENSORS_LM63)	+= lm63.o
diff -Nrubp linux-2.6.23-rc2_orig/drivers/hwmon/mdps.c linux-2.6.23-rc2/drivers/hwmon/mdps.c
--- linux-2.6.23-rc2_orig/drivers/hwmon/mdps.c	1970-01-01 02:00:00.000000000 +0200
+++ linux-2.6.23-rc2/drivers/hwmon/mdps.c	2007-08-10 13:53:04.000000000 +0300
@@ -0,0 +1,884 @@
+/*
+ *  mdps.c - HP Mobile Data Protection System 3D ACPI driver
+ *
+ *  Copyright (C) 2007 Yan Burman
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
+ * 30/12/2006
+ * Added support for NX9420 and hdaps compatibility mode.
+ * Thanks to Jonas Majauskas for testing this on NX9420
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/input.h>
+#include <linux/kthread.h>
+#include <linux/delay.h>
+#include <linux/miscdevice.h>
+#include <linux/wait.h>
+#include <linux/poll.h>
+#include <linux/freezer.h>
+#include <linux/version.h>
+
+#include <acpi/acpi_drivers.h>
+#include <acpi/acnamesp.h>
+
+#include <asm/uaccess.h>
+#include <asm/atomic.h>
+
+#define VERSION "0.9"
+
+#define DRIVER_NAME     "mdps"
+#define ACPI_MDPS_CLASS "accelerometer"
+#define ACPI_MDPS_ID    "HPQ0004"
+
+/* The actual chip is STMicroelectronics LIS3LV02DL or LIS3LV02DQ
+ * that seems to be connected via SPI */
+
+#define MDPS_WHO_AM_I        0x0F /*r      00111010 */
+#define MDPS_OFFSET_X        0x16 /*rw              */
+#define MDPS_OFFSET_Y        0x17 /*rw              */
+#define MDPS_OFFSET_Z        0x18 /*rw              */
+#define MDPS_GAIN_X          0x19 /*rw              */
+#define MDPS_GAIN_Y          0x1A /*rw              */
+#define MDPS_GAIN_Z          0x1B /*rw              */
+#define MDPS_CTRL_REG1       0x20 /*rw     00000111 */
+#define MDPS_CTRL_REG2       0x21 /*rw     00000000 */
+#define MDPS_CTRL_REG3       0x22 /*rw     00001000 */
+#define MDPS_HP_FILTER RESET 0x23 /*r               */
+#define MDPS_STATUS_REG      0x27 /*rw     00000000 */
+#define MDPS_OUTX_L          0x28 /*r               */
+#define MDPS_OUTX_H          0x29 /*r               */
+#define MDPS_OUTY_L          0x2A /*r               */
+#define MDPS_OUTY_H          0x2B /*r               */
+#define MDPS_OUTZ_L          0x2C /*r               */
+#define MDPS_OUTZ_H          0x2D /*r               */
+#define MDPS_FF_WU_CFG       0x30 /*rw     00000000 */
+#define MDPS_FF_WU_SRC       0x31 /*rw     00000000 */
+#define MDPS_FF_WU_ACK       0x32 /*r               */
+#define MDPS_FF_WU_THS_L     0x34 /*rw     00000000 */
+#define MDPS_FF_WU_THS_H     0x35 /*rw     00000000 */
+#define MDPS_FF_WU_DURATION  0x36 /*rw     00000000 */
+#define MDPS_DD_CFG          0x38 /*rw     00000000 */
+#define MDPS_DD_SRC          0x39 /*rw     00000000 */
+#define MDPS_DD_ACK          0x3A /*r               */
+#define MDPS_DD_THSI_L       0x3C /*rw     00000000 */
+#define MDPS_DD_THSI_H       0x3D /*rw     00000000 */
+#define MDPS_DD_THSE_L       0x3E /*rw     00000000 */
+#define MDPS_DD_THSE_H       0x3F /*rw     00000000 */
+
+#define MDPS_ID 0x3A
+
+/* joystick device poll interval in milliseconds */
+#define MDPS_POLL_INTERVAL 30
+
+/* Maximum value our axis may get for the input device */
+#define MDPS_MAX_VAL 1024
+
+/* how many times at most should we try to get accurate reading */
+#define RETRY_CNT 5
+
+static unsigned int joystick = 1;
+module_param(joystick, bool, S_IRUGO);
+MODULE_PARM_DESC(joystick, "Enable the input device on module load");
+
+static unsigned int power_off;
+module_param(power_off, bool, S_IRUGO);
+MODULE_PARM_DESC(power_off, "Turn off device on module load");
+
+static unsigned int hdaps_compat;
+module_param(hdaps_compat, bool, S_IRUGO);
+MODULE_PARM_DESC(hdaps_compat, "Operate in hdaps compatibility mode");
+
+static unsigned int input_3d;
+module_param(input_3d, bool, S_IRUGO);
+MODULE_PARM_DESC(input_3d, "Operate as a 3D joystick instead of 2D");
+
+enum mdps_type {
+	MDPS_NC64x0,
+	MDPS_NX94x0,
+};
+
+struct acpi_mdps
+{
+	struct acpi_device     *device;    /* The ACPI device */
+	u32                     irq;       /* IRQ number */
+	struct input_dev       *idev;      /* input device */
+	struct task_struct     *kthread;   /* kthread for input */
+	int                     xcalib;    /* calibrated null value for x */
+	int                     ycalib;    /* calibrated null value for y */
+	int                     zcalib;    /* calibrated null value for z */
+	int                     is_on;     /* whether the device is on or off */
+	struct platform_device *pdev;      /* platform device */
+	atomic_t                count;     /* interrupt count after last read */
+	struct fasync_struct   *async_queue;
+	atomic_t                available; /* whether the device is open */
+	wait_queue_head_t       misc_wait; /* Wait queue for the misc device */
+	enum mdps_type          type;
+};
+
+static struct acpi_mdps mdps;
+
+static int mdps_add(struct acpi_device *device);
+static int mdps_remove(struct acpi_device *device, int type);
+#if LINUX_VERSION_CODE > KERNEL_VERSION(2, 6, 20)
+static int mdps_suspend(struct acpi_device *device, pm_message_t state);
+static int mdps_resume(struct acpi_device *device);
+#else
+static int mdps_suspend(struct acpi_device *device, int state);
+static int mdps_resume(struct acpi_device *device, int state);
+#endif
+static int mdps_remove_fs(void);
+static int mdps_add_fs(struct acpi_device *device);
+static void mdps_joystick_enable(void);
+static void mdps_joystick_disable(void);
+
+static struct acpi_driver mdps_driver = {
+	.name  = DRIVER_NAME,
+	.class = ACPI_MDPS_CLASS,
+	.ids   = ACPI_MDPS_ID,
+	.ops = {
+		.add     = mdps_add,
+		.remove  = mdps_remove,
+#ifdef CONFIG_PM
+		.suspend = mdps_suspend,
+		.resume  = mdps_resume
+#endif
+	}
+};
+
+/** Create a single value from 2 bytes received from the accelerometer
+ * @param hi the high byte
+ * @param lo the low byte
+ * @return the resulting value
+ */
+static inline s16 mdps_glue_bytes(unsigned long hi, unsigned long lo)
+{
+	/* In "12 bit right justified" mode, bit 6, bit 7, bit 8 = bit 5 */
+	return (s16)((hi << 8) | lo);
+}
+
+/** ACPI ALRD method: read a register
+ * @param handle the handle of the device
+ * @param reg the register to read
+ * @param[out] ret result of the operation
+ * @return AE_OK on success
+ */
+static acpi_status mdps_ALRD(acpi_handle handle, int reg,
+				unsigned long *ret)
+{
+	union acpi_object arg0 = { ACPI_TYPE_INTEGER };
+	struct acpi_object_list args = { 1, &arg0 };
+
+	arg0.integer.value = reg;
+
+	return acpi_evaluate_integer(handle, "ALRD", &args, ret);
+}
+
+/** ACPI _INI method: initialize the device.
+ * @param handle the handle of the device
+ * @return 0 on success
+ */
+static inline acpi_status mdps__INI(acpi_handle handle)
+{
+	return acpi_evaluate_object(handle, METHOD_NAME__INI, NULL, NULL);
+}
+
+/** ACPI ALWR method: write to a register
+ * @param handle the handle of the device
+ * @param reg the register to write to
+ * @param val the value to write
+ * @param[out] ret result of the operation
+ * @return AE_OK on success
+ */
+static acpi_status mdps_ALWR(acpi_handle handle, int reg, int val,
+				unsigned long *ret)
+{
+	union acpi_object in_obj[2];
+	struct acpi_object_list args = { 2, in_obj };
+
+	in_obj[0].type          = ACPI_TYPE_INTEGER;
+	in_obj[0].integer.value = reg;
+	in_obj[1].type          = ACPI_TYPE_INTEGER;
+	in_obj[1].integer.value = val;
+
+	return acpi_evaluate_integer(handle, "ALWR", &args, ret);
+}
+
+/** Get X and Y axis values from the accelerometer
+ * @param handle the handle to the device
+ * @param[out] x where to store the X axis value
+ * @param[out] y where to store the Y axis value
+ * @param accurate whether we want accurate result at the price of CPU usage
+ * @note With accurate results, input device can eat up about 50% CPU at 1.3GHZ
+ */
+static void mdps_get_xy(acpi_handle handle, int *x, int *y, int accurate)
+{
+	unsigned long x_lo;
+	unsigned long x_hi;
+	unsigned long y_lo;
+	unsigned long y_hi;
+	unsigned long tmp_hi;
+	unsigned long tmp_lo;
+
+	if (accurate) {
+		unsigned int i = 0;
+		do {
+			mdps_ALRD(mdps.device->handle, MDPS_OUTX_L, &tmp_lo);
+			mdps_ALRD(mdps.device->handle, MDPS_OUTX_H, &tmp_hi);
+			mdps_ALRD(mdps.device->handle, MDPS_OUTX_L, &x_lo);
+			mdps_ALRD(mdps.device->handle, MDPS_OUTX_H, &x_hi);
+			++i;
+		} while (i < RETRY_CNT && (tmp_hi != x_hi || tmp_lo != x_lo));
+
+		if (RETRY_CNT == i)
+			printk(KERN_WARNING "mdps: inconsistent data for X\n");
+
+		i = 0;
+		do {
+			mdps_ALRD(mdps.device->handle, MDPS_OUTY_L, &tmp_lo);
+			mdps_ALRD(mdps.device->handle, MDPS_OUTY_H, &tmp_hi);
+			mdps_ALRD(mdps.device->handle, MDPS_OUTY_L, &y_lo);
+			mdps_ALRD(mdps.device->handle, MDPS_OUTY_H, &y_hi);
+			++i;
+		} while (i < RETRY_CNT && (tmp_hi != y_hi || tmp_lo != y_lo));
+
+		if (RETRY_CNT == i)
+			printk(KERN_WARNING "mdps: inconsistent data for Y\n");
+	} else {
+		mdps_ALRD(mdps.device->handle, MDPS_OUTX_L, &x_lo);
+		mdps_ALRD(mdps.device->handle, MDPS_OUTX_H, &x_hi);
+		mdps_ALRD(mdps.device->handle, MDPS_OUTY_L, &y_lo);
+		mdps_ALRD(mdps.device->handle, MDPS_OUTY_H, &y_hi);
+	}
+
+	if (MDPS_NX94x0 == mdps.type) {
+		/* On NX94x0 X and Y axis seem to be swapped */
+		*y = mdps_glue_bytes(x_hi, x_lo);
+		*x = mdps_glue_bytes(y_hi, y_lo);
+	} else {
+		/* On NC6420 X is inverted */
+		*x = -mdps_glue_bytes(x_hi, x_lo);
+		*y = mdps_glue_bytes(y_hi, y_lo);
+	}
+}
+
+/** Get X, Y and Z axis values from the accelerometer
+ * @param handle the handle to the device
+ * @param[out] x where to store the X axis value
+ * @param[out] y where to store the Y axis value
+ * @param[out] z where to store the Z axis value
+ * @param accurate whether we want accurate result at the price of CPU usage
+ */
+static void mdps_get_xyz(acpi_handle handle, int *x, int *y, int *z,
+			int accurate)
+{
+	unsigned long z_lo;
+	unsigned long z_hi;
+	unsigned long tmp_hi;
+	unsigned long tmp_lo;
+
+	mdps_get_xy(mdps.device->handle, x, y, accurate);
+
+	if (accurate) {
+		unsigned int i = 0;
+		do {
+			mdps_ALRD(mdps.device->handle, MDPS_OUTZ_L, &tmp_lo);
+			mdps_ALRD(mdps.device->handle, MDPS_OUTZ_H, &tmp_hi);
+			mdps_ALRD(mdps.device->handle, MDPS_OUTZ_L, &z_lo);
+			mdps_ALRD(mdps.device->handle, MDPS_OUTZ_H, &z_hi);
+			++i;
+		} while (i < RETRY_CNT && (tmp_hi != z_hi || tmp_lo != z_lo));
+
+		if (RETRY_CNT == i)
+			printk(KERN_WARNING "mdps: inconsistent data for Z\n");
+	} else {
+		mdps_ALRD(mdps.device->handle, MDPS_OUTZ_L, &z_lo);
+		mdps_ALRD(mdps.device->handle, MDPS_OUTZ_H, &z_hi);
+	}
+
+	*z = mdps_glue_bytes(z_hi, z_lo);
+}
+
+/** Kthread polling function
+ * @param data unused - here to conform to threadfn prototype
+ */
+static int mdps_joystick_kthread(void *data)
+{
+	int x = 0;
+	int y = 0;
+	int z = 0;
+
+	while (!kthread_should_stop()) {
+		if (input_3d) {
+			mdps_get_xyz(mdps.device->handle, &x, &y, &z, 0);
+			input_report_abs(mdps.idev, ABS_Z, z - mdps.zcalib);
+		} else
+			mdps_get_xy(mdps.device->handle, &x, &y, 0);
+
+		input_report_abs(mdps.idev, ABS_X, x - mdps.xcalib);
+		input_report_abs(mdps.idev, ABS_Y, y - mdps.ycalib);
+
+		input_sync(mdps.idev);
+
+		try_to_freeze();
+		msleep_interruptible(MDPS_POLL_INTERVAL);
+	}
+
+	return 0;
+}
+
+static inline void mdps_poweroff(acpi_handle handle)
+{
+	unsigned long ret;
+	mdps.is_on = 0;
+	/* disable X,Y,Z axis and power down */
+	mdps_ALWR(handle, MDPS_CTRL_REG1, 0x00, &ret);
+}
+
+static inline void mdps_poweron(acpi_handle handle)
+{
+	mdps.is_on = 1;
+	mdps__INI(handle);
+}
+
+#ifdef CONFIG_PM
+#if LINUX_VERSION_CODE > KERNEL_VERSION(2, 6, 20)
+static int mdps_suspend(struct acpi_device *device, pm_message_t state)
+#else
+static int mdps_suspend(struct acpi_device *device, int state)
+#endif /* LINUX_VERSION_CODE */
+{
+	/* make sure the device is off when we suspend */
+	mdps_poweroff(mdps.device->handle);
+	return 0;
+}
+#endif
+
+#if LINUX_VERSION_CODE > KERNEL_VERSION(2, 6, 20)
+static int mdps_resume(struct acpi_device *device)
+#else
+static int mdps_resume(struct acpi_device *device, int state)
+#endif
+{
+	/* make sure the device went online */
+	mdps_poweron(mdps.device->handle);
+	return 0;
+}
+
+static irqreturn_t mdps_irq(int irq, void *dev_id)
+{
+	atomic_inc(&mdps.count);
+
+	wake_up_interruptible(&mdps.misc_wait);
+	kill_fasync(&mdps.async_queue, SIGIO, POLL_IN);
+
+	return IRQ_HANDLED;
+}
+
+static int mdps_misc_open(struct inode *inode, struct file *file)
+{
+	int ret;
+
+	if (!atomic_dec_and_test(&mdps.available)) {
+		atomic_inc(&mdps.available);
+		return -EBUSY; /* already open */
+	}
+
+	atomic_set(&mdps.count, 0);
+
+	/* Can't have shared interrupts here, since we have no way
+	 * to determine in interrupt context
+	 * if it was our device that caused the interrupt */
+	ret = request_irq(mdps.irq, mdps_irq, 0, "mdps", mdps_irq);
+	if (ret) {
+		atomic_inc(&mdps.available);
+		printk(KERN_ERR "mdps: IRQ%d allocation failed\n", mdps.irq);
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+static int mdps_misc_release(struct inode *inode, struct file *file)
+{
+	fasync_helper(-1, file, 0, &mdps.async_queue);
+	free_irq(mdps.irq, mdps_irq);
+	atomic_inc(&mdps.available); /* release the device */
+	return 0;
+}
+
+static ssize_t mdps_misc_read(struct file *file, char __user *buf,
+				size_t count, loff_t *pos)
+{
+	DECLARE_WAITQUEUE(wait, current);
+	u32 data;
+	ssize_t retval = count;
+
+	if (count != sizeof(u32))
+		return -EINVAL;
+
+	add_wait_queue(&mdps.misc_wait, &wait);
+	for (; ; ) {
+		set_current_state(TASK_INTERRUPTIBLE);
+		data = atomic_xchg(&mdps.count, 0);
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
+	remove_wait_queue(&mdps.misc_wait, &wait);
+
+	return retval;
+}
+
+static unsigned int mdps_misc_poll(struct file *file, poll_table *wait)
+{
+	poll_wait(file, &mdps.misc_wait, wait);
+	if (atomic_read(&mdps.count))
+		return POLLIN | POLLRDNORM;
+	return 0;
+}
+
+static int mdps_misc_fasync(int fd, struct file *file, int on)
+{
+	return fasync_helper(fd, file, on, &mdps.async_queue);
+}
+
+static const struct file_operations mdps_misc_fops = {
+	.owner   = THIS_MODULE,
+	.llseek  = no_llseek,
+	.read    = mdps_misc_read,
+	.open    = mdps_misc_open,
+	.release = mdps_misc_release,
+	.poll    = mdps_misc_poll,
+	.fasync  = mdps_misc_fasync,
+};
+
+static struct miscdevice mdps_misc_device = {
+	.minor   = MISC_DYNAMIC_MINOR,
+	.name    = "accel",
+	.fops    = &mdps_misc_fops,
+};
+
+static acpi_status
+mdps_get_resource(struct acpi_resource *resource, void *context)
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
+static void mdps_enum_resources(struct acpi_device *device)
+{
+	acpi_status status;
+
+	status = acpi_walk_resources(device->handle, METHOD_NAME__CRS,
+					mdps_get_resource, &mdps.irq);
+	if (ACPI_FAILURE(status))
+		printk(KERN_DEBUG "mdps: Error getting resources\n");
+}
+
+static int mdps_add(struct acpi_device *device)
+{
+	unsigned long val;
+	int ret;
+
+	if (!device)
+		return -EINVAL;
+
+	mdps.device = device;
+	strcpy(acpi_device_name(device), DRIVER_NAME);
+	strcpy(acpi_device_class(device), ACPI_MDPS_CLASS);
+	acpi_driver_data(device) = &mdps;
+
+	mdps_ALRD(device->handle, MDPS_WHO_AM_I, &val);
+	if (val != MDPS_ID) {
+		printk(KERN_ERR
+			"mdps: Accelerometer chip not LIS3LV02D{L,Q}\n");
+		return -ENODEV;
+	}
+
+	mdps_add_fs(device);
+#if LINUX_VERSION_CODE > KERNEL_VERSION(2, 6, 20)
+	mdps_resume(device);
+#else
+	mdps_resume(device, 0);
+#endif
+
+	if (joystick)
+		mdps_joystick_enable();
+
+	/* obtain IRQ numer of our device from ACPI */
+	mdps_enum_resources(device);
+
+	if (power_off) /* see if user wanted to power off the device on load */
+		mdps_poweroff(mdps.device->handle);
+
+	/* if we did not get an IRQ from ACPI - we have nothing more to do */
+	if (!mdps.irq) {
+		printk(KERN_INFO
+			"mdps: No IRQ in ACPI. Disabling /dev/accel\n");
+		return 0;
+	}
+
+	atomic_set(&mdps.available, 1); /* init the misc device open count */
+	init_waitqueue_head(&mdps.misc_wait);
+
+	ret = misc_register(&mdps_misc_device);
+	if (ret)
+		printk(KERN_ERR "mdps: misc_register failed\n");
+
+	return 0;
+}
+
+static int mdps_remove(struct acpi_device *device, int type)
+{
+	if (!device)
+		return -EINVAL;
+
+	if (mdps.irq)
+		misc_deregister(&mdps_misc_device);
+
+	mdps_joystick_disable();
+
+	return mdps_remove_fs();
+}
+
+static inline void mdps_calibrate_joystick(void)
+{
+	mdps_get_xyz(mdps.device->handle, &mdps.xcalib, &mdps.ycalib,
+		&mdps.zcalib, 1);
+}
+
+static int mdps_joystick_open(struct input_dev *dev)
+{
+	mdps.kthread = kthread_run(mdps_joystick_kthread, NULL, "kmdps");
+	if (IS_ERR(mdps.kthread))
+		return PTR_ERR(mdps.kthread);
+
+	return 0;
+}
+
+static void mdps_joystick_close(struct input_dev *dev)
+{
+	kthread_stop(mdps.kthread);
+}
+
+static void mdps_joystick_enable(void)
+{
+	if (mdps.idev)
+		return;
+
+	mdps.idev = input_allocate_device();
+	if (!mdps.idev)
+		return;
+
+	mdps_calibrate_joystick();
+
+	mdps.idev->name       = "HP Mobile Data Protection System";
+	mdps.idev->id.bustype = BUS_HOST;
+	mdps.idev->id.vendor  = 0;
+	mdps.idev->cdev.dev   = &mdps.pdev->dev;
+
+	set_bit(EV_ABS, mdps.idev->evbit);
+
+	input_set_abs_params(mdps.idev, ABS_X, -MDPS_MAX_VAL, MDPS_MAX_VAL,
+		3, 0);
+	input_set_abs_params(mdps.idev, ABS_Y, -MDPS_MAX_VAL, MDPS_MAX_VAL,
+		3, 0);
+	if (input_3d)
+		input_set_abs_params(mdps.idev, ABS_Z, -MDPS_MAX_VAL,
+			MDPS_MAX_VAL, 3, 0);
+
+	mdps.idev->open  = mdps_joystick_open;
+	mdps.idev->close = mdps_joystick_close;
+
+	if (input_register_device(mdps.idev)) {
+		input_free_device(mdps.idev);
+		mdps.idev = NULL;
+	}
+}
+
+static void mdps_joystick_disable(void)
+{
+	if (!mdps.idev)
+		return;
+
+	input_unregister_device(mdps.idev);
+	mdps.idev = NULL;
+}
+
+/* Sysfs stuff */
+static ssize_t mdps_position_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	int x;
+	int y;
+	mdps_get_xy(mdps.device->handle, &x, &y, 1);
+
+	if (hdaps_compat) { /* mdps is 10 times more sensitive than hdaps */
+		x /= 10;
+		y /= 10;
+	}
+
+	return sprintf(buf, "(%d,%d)\n", x, y);
+}
+
+static ssize_t mdps_position3d_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	int x;
+	int y;
+	int z;
+	mdps_get_xyz(mdps.device->handle, &x, &y, &z, 1);
+
+	return sprintf(buf, "(%d,%d,%d)\n", x, y, z);
+}
+
+static ssize_t mdps_state_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%s\n", (mdps.is_on ? "on" : "off"));
+}
+
+static ssize_t mdps_input_show_joystick(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%s\n", (joystick ? "enabled" : "disabled"));
+}
+
+static ssize_t mdps_input_store_joystick(struct device *dev,
+	struct device_attribute *attr, const char *buf, size_t count)
+{
+	int state;
+	if (sscanf(buf, "%d", &state) != 1 || (state != 1 && state != 0))
+		return -EINVAL;
+
+	joystick = state;
+
+	if (joystick)
+		mdps_joystick_enable();
+	else
+		mdps_joystick_disable();
+
+	return count;
+}
+
+static ssize_t mdps_calibrate_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	if (input_3d)
+		return sprintf(buf, "(%d,%d,%d)\n", mdps.xcalib, mdps.ycalib,
+			mdps.zcalib);
+
+	return sprintf(buf, "(%d,%d)\n", mdps.xcalib, mdps.ycalib);
+}
+
+static ssize_t mdps_calibrate_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	mdps_calibrate_joystick();
+	return count;
+}
+
+static ssize_t mdps_rate_show(struct device *dev,
+			struct device_attribute *attr, char *buf)
+{
+	unsigned long ctrl;
+	int rate = 0;
+
+	mdps_ALRD(mdps.device->handle, MDPS_CTRL_REG1, &ctrl);
+
+	/* get the sampling rate of the accelerometer in HZ */
+	switch ((ctrl & 0x30) >> 4) {
+	case 00:
+		rate = 40;
+		break;
+
+	case 01:
+		rate = 160;
+		break;
+
+	case 02:
+		rate = 640;
+		break;
+
+	case 03:
+		rate = 2560;
+		break;
+	}
+
+	return sprintf(buf, "%d\n", rate);
+}
+
+static ssize_t mdps_state_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	int state;
+	if (sscanf(buf, "%d", &state) != 1 || (state != 1 && state != 0))
+		return -EINVAL;
+
+	mdps.is_on = state;
+
+	if (mdps.is_on)
+		mdps_poweron(mdps.device->handle);
+	else
+		mdps_poweroff(mdps.device->handle);
+
+	return count;
+}
+
+static DEVICE_ATTR(position, S_IRUGO, mdps_position_show, NULL);
+static DEVICE_ATTR(position3d, S_IRUGO, mdps_position3d_show, NULL);
+static DEVICE_ATTR(calibrate, S_IRUGO|S_IWUSR, mdps_calibrate_show,
+	mdps_calibrate_store);
+static DEVICE_ATTR(rate, S_IRUGO, mdps_rate_show, NULL);
+static DEVICE_ATTR(state, S_IRUGO|S_IWUSR, mdps_state_show, mdps_state_store);
+static DEVICE_ATTR(joystick, S_IRUGO|S_IWUSR, mdps_input_show_joystick,
+	mdps_input_store_joystick);
+
+static struct attribute *mdps_attributes[] = {
+	&dev_attr_position.attr,
+	&dev_attr_position3d.attr,
+	&dev_attr_calibrate.attr,
+	&dev_attr_rate.attr,
+	&dev_attr_state.attr,
+	&dev_attr_joystick.attr,
+	NULL
+};
+
+static struct attribute_group mdps_attribute_group = {
+	.attrs = mdps_attributes
+};
+
+static int mdps_add_fs(struct acpi_device *device)
+{
+	char *name = DRIVER_NAME;
+
+	if (hdaps_compat)
+		name = "hdaps";
+
+	mdps.pdev = platform_device_register_simple(name, -1, NULL, 0);
+	if (IS_ERR(mdps.pdev))
+		return PTR_ERR(mdps.pdev);
+
+	return sysfs_create_group(&mdps.pdev->dev.kobj, &mdps_attribute_group);
+}
+
+static int mdps_remove_fs(void)
+{
+	sysfs_remove_group(&mdps.pdev->dev.kobj, &mdps_attribute_group);
+	platform_device_unregister(mdps.pdev);
+	return 0;
+}
+
+struct mdps_id {
+	acpi_string path;
+	enum mdps_type type;
+	const char *name;
+};
+
+static struct mdps_id mdps_devices[] __initdata = {
+	{"\\_SB.C002.ACEL", MDPS_NC64x0, "NC64x0"},
+	{"\\_SB.C003.ACEL", MDPS_NX94x0, "NC94x0"},
+	{ }
+};
+
+static int __init mdps_init_module(void)
+{
+	int ret;
+	int device_found;
+	unsigned int i;
+	acpi_status status;
+	acpi_handle handle = 0;
+
+	if (acpi_disabled)
+		return -ENODEV;
+
+	/* see if our device is present in ACPI */
+	device_found = 0;
+	for (i = 0; mdps_devices[i].path; ++i) {
+		status = acpi_get_handle(NULL, mdps_devices[i].path, &handle);
+		if (ACPI_SUCCESS(status)) {
+			mdps.type = mdps_devices[i].type;
+			printk(KERN_INFO "mdps: hardware type %s found.\n",
+				mdps_devices[i].name);
+			device_found = 1;
+			break;
+		}
+	}
+
+	if (!device_found) {
+		printk(KERN_ERR
+			"mdps: HP Mobile Data Protection System not found\n");
+		return -ENODEV;
+	}
+
+	ret = acpi_bus_register_driver(&mdps_driver);
+	if (ret < 0)
+		return ret;
+
+	printk(KERN_INFO "mdps: (" VERSION ") loaded.\n");
+
+	return 0;
+}
+
+static void __exit mdps_exit_module(void)
+{
+	acpi_bus_unregister_driver(&mdps_driver);
+}
+
+MODULE_DESCRIPTION("HP three-axis digital accelerometer ACPI driver");
+MODULE_AUTHOR("Yan Burman (burman.yan@gmail.com)");
+MODULE_VERSION(VERSION);
+MODULE_LICENSE("GPL");
+
+module_init(mdps_init_module);
+module_exit(mdps_exit_module);


