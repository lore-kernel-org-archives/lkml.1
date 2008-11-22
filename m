Return-Path: <linux-kernel-owner+w=401wt.eu-S1758333AbYKVO2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758333AbYKVO2e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 09:28:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758077AbYKVO2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 09:28:24 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:2524 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758070AbYKVO2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 09:28:23 -0500
X-Spam-Flag: NO
X-Spam-Score: -9.389
Message-ID: <492816FD.5090603@tremplin-utc.net>
Date: Sat, 22 Nov 2008 15:28:13 +0100
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.18) Gecko/20081120 Mandriva/2.0.0.18-1mdv2009.1 (2009.1) Thunderbird/2.0.0.18 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, trenn@suse.de, rpurdie@rpsys.net,
       hmh@hmh.eng.br
Subject: Re: [PATCH 1/2] LIS3LV02D: separate the core from HP ACPI API
References: <20081121212121.GA7222@elf.ucw.cz> <20081121160022.86020953.akpm@linux-foundation.org> <49275194.6070604@tremplin-utc.net> <492757A8.6010509@tremplin-utc.net> <49275870.7050900@tremplin-utc.net> <20081122123526.GA1990@ucw.cz>
In-Reply-To: <20081122123526.GA1990@ucw.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek schreef:
> On Sat 2008-11-22 01:55:12, ?ric Piel wrote:
>> The sensor can be accessed via various buses. In particular, SPI, I?C
>> and, on HP laptops, via a specific ACPI API (the only one currently
>> supported). Separate this latest platform from the core of the sensor
>> driver to allow support for the other bus type. The second, and more
>> direct goal is actually to be able to merge this part with the
>> hp-disk-leds driver, which has the same ACPI PNP number.
>>
>> Signed-off-by: Pavel Machek <pavel@suse.cz>
>> Signed-off-by: Eric Piel <eric.piel@tremplin-utc.net>
> 
> Oops, I sent wrong patch. This should fix the 'compile as module'
> problems...
> 
Well, the patch you are answering to already contains this fix :-) To be
precise, excepted this line:

> --- ../l/READ-ONLY/linux/drivers/hwmon/lis3lv02d.c	2008-11-21 14:28:33.000000000 +0100
> +++ linux-mm/drivers/hwmon/lis3lv02d.c	2008-11-06 12:27:27.000000000 +0100
> @@ -34,6 +34,7 @@
>  #include <linux/wait.h>
>  #include <linux/poll.h>
>  #include <linux/freezer.h>
> +#include <linux/version.h>
Is it needed?

Now that I read again this patch, I could see some "not so clean" parts.
Here is a new version of it,  which should follow better the Linux
coding style. Patch 2/2 is still valid and applies fine over this
updated version. Andrew this little series should be now safe to take 
into your tree :-)

Eric
=
LIS3LV02D: separate the core from HP ACPI API
 
The sensor can be accessed via various buses. In particular, SPI, I²C
and, on HP laptops, via a specific ACPI API (the only one currently
supported). Separate this latest platform from the core of the sensor
driver to allow support for the other bus type. The second, and more
direct goal is actually to be able to merge this part with the
hp-disk-leds driver, which has the same ACPI PNP number.

Signed-off-by: Pavel Machek <pavel@suse.cz>
Signed-off-by: Eric Piel <eric.piel@tremplin-utc.net>
---
 drivers/hwmon/Makefile    |    2 +-
 drivers/hwmon/hp_accel.c  |  265 +++++++++++++++++++++++++++++++++++++++++++
 drivers/hwmon/lis3lv02d.c |  273 ++++-----------------------------------------
 drivers/hwmon/lis3lv02d.h |   35 ++++++-
 4 files changed, 324 insertions(+), 251 deletions(-)
 create mode 100644 drivers/hwmon/hp_accel.c

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
index 0000000..bf8d405
--- /dev/null
+++ b/drivers/hwmon/hp_accel.c
@@ -0,0 +1,265 @@
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
+
+static int lis3lv02d_add(struct acpi_device *device)
+{
+	u8 val;
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
+MODULE_DESCRIPTION("Glue between LIS3LV02Dx and HP ACPI BIOS");
+MODULE_AUTHOR("Yan Burman, Eric Piel, Pavel Machek");
+MODULE_LICENSE("GPL");
+
+module_init(lis3lv02d_init_module);
+module_exit(lis3lv02d_exit_module);
+
diff --git a/drivers/hwmon/lis3lv02d.c b/drivers/hwmon/lis3lv02d.c
index c002144..219d2d0 100644
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
@@ -39,7 +40,6 @@
 #include "lis3lv02d.h"
 
 #define DRIVER_NAME     "lis3lv02d"
-#define ACPI_MDPS_CLASS "accelerometer"
 
 /* joystick device poll interval in milliseconds */
 #define MDPS_POLL_INTERVAL 50
@@ -55,100 +55,17 @@
 /* Maximum value our axis may get for the input device (signed 12 bits) */
 #define MDPS_MAX_VAL 2048
 
-struct axis_conversion {
-	s8	x;
-	s8	y;
-	s8	z;
-};
-
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
+struct acpi_lis3lv02d adev;
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
@@ -190,54 +107,31 @@ static void lis3lv02d_get_xyz(acpi_handle handle, int *x, int *y, int *z)
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
+	adev.write(handle, CTRL_REG2, val);
 }
-#else
-#define lis3lv02d_suspend NULL
-#define lis3lv02d_resume NULL
-#endif
-
+EXPORT_SYMBOL_GPL(lis3lv02d_poweron);
 
 /*
  * To be called before starting to use the device. It makes sure that the
@@ -315,7 +209,7 @@ static inline void lis3lv02d_calibrate_joystick(void)
 	lis3lv02d_get_xyz(adev.device->handle, &adev.xcalib, &adev.ycalib, &adev.zcalib);
 }
 
-static int lis3lv02d_joystick_enable(void)
+int lis3lv02d_joystick_enable(void)
 {
 	int err;
 
@@ -349,8 +243,9 @@ static int lis3lv02d_joystick_enable(void)
 
 	return err;
 }
+EXPORT_SYMBOL_GPL(lis3lv02d_joystick_enable);
 
-static void lis3lv02d_joystick_disable(void)
+void lis3lv02d_joystick_disable(void)
 {
 	if (!adev.idev)
 		return;
@@ -358,13 +253,13 @@ static void lis3lv02d_joystick_disable(void)
 	input_unregister_device(adev.idev);
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
@@ -376,93 +271,7 @@ static int lis3lv02d_init_device(struct acpi_lis3lv02d *dev)
 	lis3lv02d_decrease_use(dev);
 	return 0;
 }
-
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
-
+EXPORT_SYMBOL_GPL(lis3lv02d_init_device);
 
 /* Sysfs stuff */
 static ssize_t lis3lv02d_position_show(struct device *dev,
@@ -501,7 +310,7 @@ static ssize_t lis3lv02d_rate_show(struct device *dev,
 	int val;
 
 	lis3lv02d_increase_use(&adev);
-	lis3lv02d_acpi_read(adev.device->handle, CTRL_REG1, &ctrl);
+	adev.read(adev.device->handle, CTRL_REG1, &ctrl);
 	lis3lv02d_decrease_use(&adev);
 	val = (ctrl & (CTRL1_DF0 | CTRL1_DF1)) >> 4;
 	return sprintf(buf, "%d\n", lis3lv02dl_df_val[val]);
@@ -523,6 +332,7 @@ static struct attribute_group lis3lv02d_attribute_group = {
 	.attrs = lis3lv02d_attributes
 };
 
+
 static int lis3lv02d_add_fs(struct acpi_device *device)
 {
 	adev.pdev = platform_device_register_simple(DRIVER_NAME, -1, NULL, 0);
@@ -532,50 +342,15 @@ static int lis3lv02d_add_fs(struct acpi_device *device)
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
index 330cfc6..223f1c0 100644
--- a/drivers/hwmon/lis3lv02d.h
+++ b/drivers/hwmon/lis3lv02d.h
@@ -23,7 +23,7 @@
  * The actual chip is STMicroelectronics LIS3LV02DL or LIS3LV02DQ that seems to
  * be connected via SPI. There exists also several similar chips (such as LIS302DL or
  * LIS3L02DQ) but not in the HP laptops and they have slightly different registers.
- * They can also be connected via IÂ˛C.
+ * They can also be connected via I²C.
  */
 
 #define LIS3LV02DL_ID	0x3A /* Also the LIS3LV02DQ */
@@ -147,3 +147,36 @@ enum lis3lv02d_dd_src {
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
1.6.0.4

