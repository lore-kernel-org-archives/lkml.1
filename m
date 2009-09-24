Return-Path: <linux-kernel-owner+w=401wt.eu-S1752613AbZIXPMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613AbZIXPMt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 11:12:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751947AbZIXPMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 11:12:49 -0400
Received: from adelie.canonical.com ([91.189.90.139]:46555 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbZIXPMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 11:12:46 -0400
From: Ike Panhc <ike.pan@canonical.com>
To: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alexandre Rostovtsev <tetromino@gmail.com>
Subject: [PATCH] ACPI: New driver for Lenovo SL laptops
Date: Thu, 24 Sep 2009 23:12:43 +0800
Message-Id: <1253805163-12493-1-git-send-email-ike.pan@canonical.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lenovo-sl-laptop is a new driver that provides support for hotkeys, bluetooth,
LenovoCare LEDs and fan speed on the Lenovo ThinkPad SL series laptops. The
original author is Alexandre Rostovtsev. [1] In February 2009 Alexandre has
posted the driver on the linux-acpi mailing list and and there was some
feedback suggesting further modifications. [2] I would like to see Linux
working properly on these laptops. I was encouraged to push this driver again
with the modifications that where suggested in the responses to the initial
post in order to allow me and others interested in that driver to improve it
and hopefully get it included upstream.

[1] homepage : http://github.com/tetromino/lenovo-sl-laptop/tree/master
[2] http://patchwork.kernel.org/patch/7427/

Following the suggestions when last time the origin author has posted on the
linux-acpi mailing list. The major modification of this driver is listed below.
 - Remove backlight control
 - Remove procfs EC debug
 - Remove fan control function
 - Using generic debugging infrastructure
 - Support for lastest rfkill infrastructure (by Alexandre)
 - Register query function into EC for detecting hotkey event

Patch against current checkout of linux-acpi 2.6.31 is below.


=== 8< ===

lenovo-sl-laptop: Extra driver for Lenovo SL series laptop

This driver provides support for the following functions.
 - Hotkeys: LenovoCare, Volumn up/down/mute, Battery, Suspend, WLAN switch,
            Video switch, Pointer switch (as KEY_PROG1), Dock eject (as
            KEY_PROG2), Hibernate, Lock screen, Screen Zoom and LCD brightness
            up/down.
 - Radio RFKILL: switching on/off UWB, bluetooth and wifi.
 - LenovoCare LEDs: On, off, Dimmed blinking and standard blinking.
                    (Blinking supported with ledtrig_timer)
 - Fan speed: Reading current fan speed

The original author of this driver is Alexandre Rostovtsev

The Lenovo ThinkPad SL series laptops are not supported by the normal
thinkpad_acpi driver because their firmware is quite different from the
T-series/R-series/X-series ThinkPads. [3]

[3] http://mailman.linux-thinkpad.org/pipermail/linux-thinkpad/2009-January/046122.html


Signed-off-by: Ike Panhc <ike.pan@canonical.com>
---
 drivers/platform/x86/Kconfig            |   12 +
 drivers/platform/x86/Makefile           |    1 +
 drivers/platform/x86/lenovo-sl-laptop.c |  825 +++++++++++++++++++++++++++++++
 3 files changed, 838 insertions(+), 0 deletions(-)
 create mode 100644 drivers/platform/x86/lenovo-sl-laptop.c

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 55ca39d..1ae72e3 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -143,6 +143,18 @@ config HP_WMI
 	 To compile this driver as a module, choose M here: the module will
 	 be called hp-wmi.
 
+config LENOVO_SL_LAPTOP
+	tristate "Lenovo ThinkPad SL Series Laptop Extras"
+	depends on ACPI
+	select HWMON
+	select INPUT
+	select RFKILL
+	---help---
+	  This is a driver for the Lenovo ThinkPad SL series laptops
+	  (SL300/400/500), which are not supported by the thinkpad_acpi
+	  driver. This driver adds support for hotkeys, rfkill control,
+	  the Lenovo Care LED, fan speed.
+
 config MSI_LAPTOP
 	tristate "MSI Laptop Extras"
 	depends on ACPI
diff --git a/drivers/platform/x86/Makefile b/drivers/platform/x86/Makefile
index d1c1621..1037739 100644
--- a/drivers/platform/x86/Makefile
+++ b/drivers/platform/x86/Makefile
@@ -11,6 +11,7 @@ obj-$(CONFIG_DELL_WMI)		+= dell-wmi.o
 obj-$(CONFIG_ACER_WMI)		+= acer-wmi.o
 obj-$(CONFIG_ACERHDF)		+= acerhdf.o
 obj-$(CONFIG_HP_WMI)		+= hp-wmi.o
+obj-$(CONFIG_LENOVO_SL_LAPTOP)	+= lenovo-sl-laptop.o
 obj-$(CONFIG_TC1100_WMI)	+= tc1100-wmi.o
 obj-$(CONFIG_SONY_LAPTOP)	+= sony-laptop.o
 obj-$(CONFIG_THINKPAD_ACPI)	+= thinkpad_acpi.o
diff --git a/drivers/platform/x86/lenovo-sl-laptop.c b/drivers/platform/x86/lenovo-sl-laptop.c
new file mode 100644
index 0000000..b5c19a9
--- /dev/null
+++ b/drivers/platform/x86/lenovo-sl-laptop.c
@@ -0,0 +1,825 @@
+/*
+ *  lenovo-sl-laptop.c - Lenovo ThinkPad SL Series Extras Driver
+ *
+ *
+ *  Copyright (C) 2008-2009 Alexandre Rostovtsev <tetromino@gmail.com>
+ *
+ *  Largely based on thinkpad_acpi.c, eeepc-laptop.c, and video.c which
+ *  are copyright their respective authors.
+ *
+ *  The original website of this driver is at
+ *  http://github.com/tetromino/lenovo-sl-laptop/tree/master
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
+ *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ *  02110-1301, USA.
+ *
+ */
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/version.h>
+#include <linux/init.h>
+#include <linux/acpi.h>
+#include <linux/pci_ids.h>
+#include <linux/rfkill.h>
+#include <linux/hwmon.h>
+#include <linux/hwmon-sysfs.h>
+#include <linux/platform_device.h>
+#include <linux/input.h>
+#include <linux/uaccess.h>
+
+#define LENSL_MODULE_DESC "Lenovo ThinkPad SL Series Extras driver"
+#define LENSL_MODULE_NAME "lenovo-sl-laptop"
+
+MODULE_AUTHOR("Alexandre Rostovtsev");
+MODULE_DESCRIPTION(LENSL_MODULE_DESC);
+MODULE_LICENSE("GPL");
+
+#define LENSL_HKEY_FILE LENSL_MODULE_NAME
+#define LENSL_DRVR_NAME LENSL_MODULE_NAME
+
+#define LENSL_WORKQUEUE_NAME "klensl_wq"
+
+#define LENSL_EC0 "\\_SB.PCI0.SBRG.EC0"
+#define LENSL_HKEY LENSL_EC0 ".HKEY"
+
+#define LENSL_MAX_ACPI_ARGS 3
+
+/* parameters */
+
+static int bluetooth_auto_enable = 1;
+static int wwan_auto_enable = 1;
+static int uwb_auto_enable = 1;
+module_param(bluetooth_auto_enable, bool, S_IRUGO);
+MODULE_PARM_DESC(bluetooth_auto_enable,
+	"Automatically enable bluetooth (if supported by hardware) when the "
+	"module is loaded.");
+module_param(wwan_auto_enable, bool, S_IRUGO);
+MODULE_PARM_DESC(wwan_auto_enable,
+	"Automatically enable WWAN (if supported by hardware) when the "
+	"module is loaded.");
+module_param(uwb_auto_enable, bool, S_IRUGO);
+MODULE_PARM_DESC(wwan_auto_enable,
+	"Automatically enable UWB (if supported by hardware) when the "
+	"module is loaded.");
+
+/* general */
+
+static acpi_handle hkey_handle, ec0_handle;
+static struct platform_device *lensl_pdev;
+static struct workqueue_struct *lensl_wq;
+
+static int lensl_acpi_int_func(acpi_handle handle, char *pathname, int *ret,
+				int n_arg, ...)
+{
+	acpi_status status;
+	struct acpi_object_list params;
+	union acpi_object in_obj[LENSL_MAX_ACPI_ARGS], out_obj;
+	struct acpi_buffer result, *resultp;
+	int i;
+	va_list ap;
+
+	if (!handle)
+		return -EINVAL;
+	if (n_arg < 0 || n_arg > LENSL_MAX_ACPI_ARGS)
+		return -EINVAL;
+	va_start(ap, n_arg);
+	for (i = 0; i < n_arg; i++) {
+		in_obj[i].integer.value = va_arg(ap, int);
+		in_obj[i].type = ACPI_TYPE_INTEGER;
+	}
+	va_end(ap);
+	params.count = n_arg;
+	params.pointer = in_obj;
+
+	if (ret) {
+		result.length = sizeof(out_obj);
+		result.pointer = &out_obj;
+		resultp = &result;
+	} else
+		resultp = NULL;
+
+	status = acpi_evaluate_object(handle, pathname, &params, resultp);
+	if (ACPI_FAILURE(status))
+		return -EIO;
+	if (ret)
+		*ret = out_obj.integer.value;
+
+	switch (n_arg) {
+	case 0:
+		if (ret)
+			pr_devel("ACPI : %s() == %d\n",
+				pathname, *ret);
+		else
+			pr_devel("ACPI : %s()\n", pathname);
+		break;
+	case 1:
+		if (ret)
+			pr_devel("ACPI : %s(%d) == %d\n",
+				pathname,
+				(int)(in_obj[0].integer.value),
+				*ret);
+		else
+			pr_devel("ACPI : %s(%d)\n",
+				pathname,
+				(int)(in_obj[0].integer.value));
+		break;
+	case 2:
+		if (ret)
+			pr_devel("ACPI : %s(%d, %d) == %d\n",
+				pathname,
+				(int)in_obj[0].integer.value,
+				(int)in_obj[1].integer.value,
+				*ret);
+		else
+			pr_devel("ACPI : %s(%d, %d)\n",
+				pathname,
+				(int)in_obj[0].integer.value,
+				(int)in_obj[1].integer.value);
+		break;
+	default:
+		pr_warning("Not an expected argument.\n");
+	}
+	return 0;
+}
+
+/*************************************************************************
+    Bluetooth, WWAN, UWB
+ *************************************************************************/
+
+enum {
+	/* ACPI GBDC/SBDC, GWAN/SWAN, GUWB/SUWB bits */
+	LENSL_RADIO_HWPRESENT	= 0x01, /* hardware is available */
+	LENSL_RADIO_RADIOSSW	= 0x02, /* radio is enabled */
+	LENSL_RADIO_RESUMECTRL	= 0x04, /* state at resume: off/last state */
+};
+
+typedef enum {
+	LENSL_BLUETOOTH = 0,
+	LENSL_WWAN,
+	LENSL_UWB,
+} lensl_radio_type;
+
+/* pretend_blocked indicates whether we pretend that the device is
+   hardware-blocked (used primarily to prevent the device from coming
+   online when the module is loaded) */
+struct lensl_radio {
+	lensl_radio_type type;
+	enum rfkill_type rfktype;
+	int present;
+	char *name;
+	char *rfkname;
+	struct rfkill *rfk;
+	int (*get_acpi)(int *);
+	int (*set_acpi)(int);
+	int *auto_enable;
+};
+
+static inline int get_wlsw(int *value)
+{
+	return lensl_acpi_int_func(hkey_handle, "WLSW", value, 0);
+}
+
+static inline int get_gbdc(int *value)
+{
+	return lensl_acpi_int_func(hkey_handle, "GBDC", value, 0);
+}
+
+static inline int get_gwan(int *value)
+{
+	return lensl_acpi_int_func(hkey_handle, "GWAN", value, 0);
+}
+
+static inline int get_guwb(int *value)
+{
+	return lensl_acpi_int_func(hkey_handle, "GUWB", value, 0);
+}
+
+static inline int set_sbdc(int value)
+{
+	return lensl_acpi_int_func(hkey_handle, "SBDC", NULL, 1, value);
+}
+
+static inline int set_swan(int value)
+{
+	return lensl_acpi_int_func(hkey_handle, "SWAN", NULL, 1, value);
+}
+
+static inline int set_suwb(int value)
+{
+	return lensl_acpi_int_func(hkey_handle, "SUWB", NULL, 1, value);
+}
+
+static int lensl_radio_get(struct lensl_radio *radio, int *hw_blocked,
+				int *value)
+{
+	int wlsw;
+
+	*hw_blocked = 0;
+	if (!radio)
+		return -EINVAL;
+	if (!radio->present)
+		return -ENODEV;
+	if (!get_wlsw(&wlsw) && !wlsw)
+		*hw_blocked = 1;
+	if (radio->get_acpi(value))
+		return -EIO;
+	return 0;
+}
+
+static int lensl_radio_set_on(struct lensl_radio *radio, int *hw_blocked,
+				bool on)
+{
+	int value, ret;
+	ret = lensl_radio_get(radio, hw_blocked, &value);
+	if (ret < 0)
+		return ret;
+	/* WLSW overrides radio in firmware/hardware, but there is
+	   no reason to risk weird behaviour. */
+	if (*hw_blocked)
+		return ret;
+	if (on)
+		value |= LENSL_RADIO_RADIOSSW;
+	else
+		value &= ~LENSL_RADIO_RADIOSSW;
+	if (radio->set_acpi(value))
+		return -EIO;
+	return 0;
+}
+
+/* Bluetooth/WWAN/UWB rfkill interface */
+
+static void lensl_radio_rfkill_query(struct rfkill *rfk, void *data)
+{
+	int ret, value = 0;
+	ret = get_wlsw(&value);
+	if (ret)
+		return;
+	rfkill_set_hw_state(rfk, !value);
+}
+
+static int lensl_radio_rfkill_set_block(void *data, bool blocked)
+{
+	int ret, hw_blocked = 0;
+	ret = lensl_radio_set_on((struct lensl_radio *)data,
+		&hw_blocked, !blocked);
+	/* rfkill spec: just return 0 on hard block */
+	return ret;
+}
+
+static struct rfkill_ops rfkops = {
+	NULL,
+	lensl_radio_rfkill_query,
+	lensl_radio_rfkill_set_block,
+};
+
+static int lensl_radio_new_rfkill(struct lensl_radio *radio,
+			struct rfkill **rfk, bool sw_blocked,
+			bool hw_blocked)
+{
+	int res;
+
+	*rfk = rfkill_alloc(radio->rfkname, &lensl_pdev->dev, radio->rfktype,
+			&rfkops, radio);
+	if (!*rfk) {
+		pr_err("Failed to allocate memory for rfkill class\n");
+		return -ENOMEM;
+	}
+
+	rfkill_set_hw_state(*rfk, hw_blocked);
+	rfkill_set_sw_state(*rfk, sw_blocked);
+
+	res = rfkill_register(*rfk);
+	if (res < 0) {
+		pr_err("Failed to register %s rfkill switch: %d\n",
+			radio->rfkname, res);
+		rfkill_destroy(*rfk);
+		*rfk = NULL;
+		return res;
+	}
+
+	return 0;
+}
+
+/* Bluetooth/WWAN/UWB init and exit */
+
+static struct lensl_radio lensl_radios[3] = {
+	{
+		LENSL_BLUETOOTH,
+		RFKILL_TYPE_BLUETOOTH,
+		0,
+		"bluetooth",
+		"lensl_bluetooth_sw",
+		NULL,
+		get_gbdc,
+		set_sbdc,
+		&bluetooth_auto_enable,
+	},
+	{
+		LENSL_WWAN,
+		RFKILL_TYPE_WWAN,
+		0,
+		"WWAN",
+		"lensl_wwan_sw",
+		NULL,
+		get_gwan,
+		set_swan,
+		&wwan_auto_enable,
+	},
+	{
+		LENSL_UWB,
+		RFKILL_TYPE_UWB,
+		0,
+		"UWB",
+		"lensl_uwb_sw",
+		NULL,
+		get_guwb,
+		set_suwb,
+		&uwb_auto_enable,
+	},
+};
+
+static void radio_exit(lensl_radio_type type)
+{
+	if (lensl_radios[type].rfk)
+		rfkill_unregister(lensl_radios[type].rfk);
+}
+
+static int radio_init(lensl_radio_type type)
+{
+	int value, res, hw_blocked = 0, sw_blocked;
+
+	if (!hkey_handle)
+		return -ENODEV;
+	lensl_radios[type].present = 1; /* need for lensl_radio_get */
+	res = lensl_radio_get(&lensl_radios[type], &hw_blocked, &value);
+	lensl_radios[type].present = 0;
+	if (res && !hw_blocked)
+		return -EIO;
+	if (!(value & LENSL_RADIO_HWPRESENT))
+		return -ENODEV;
+	lensl_radios[type].present = 1;
+
+	if (*lensl_radios[type].auto_enable) {
+		sw_blocked = 0;
+		value |= LENSL_RADIO_RADIOSSW;
+		lensl_radios[type].set_acpi(value);
+	} else {
+		sw_blocked = 1;
+		value &= ~LENSL_RADIO_RADIOSSW;
+		lensl_radios[type].set_acpi(value);
+	}
+
+	res = lensl_radio_new_rfkill(&lensl_radios[type],
+				     &lensl_radios[type].rfk,
+				     sw_blocked, hw_blocked);
+
+	if (res) {
+		radio_exit(type);
+		return res;
+	}
+	pr_devel("Initialized %s subdriver\n", lensl_radios[type].name);
+
+	return 0;
+}
+
+/*************************************************************************
+    LEDs
+ *************************************************************************/
+#ifdef CONFIG_NEW_LEDS
+
+#define LENSL_LED_TV_OFF   0
+#define LENSL_LED_TV_ON    0x02
+#define LENSL_LED_TV_BLINK 0x01
+#define LENSL_LED_TV_DIM   0x100
+
+/* equivalent to the ThinkVantage LED on other ThinkPads */
+#define LENSL_LED_TV_NAME "lensl::lenovocare"
+
+struct {
+	struct led_classdev cdev;
+	enum led_brightness brightness;
+	int supported, new_code;
+	struct work_struct work;
+} led_tv;
+
+static inline int set_tvls(int code)
+{
+	return lensl_acpi_int_func(hkey_handle, "TVLS", NULL, 1, code);
+}
+
+static void led_tv_worker(struct work_struct *work)
+{
+	if (!led_tv.supported)
+		return;
+	set_tvls(led_tv.new_code);
+	if (led_tv.new_code)
+		led_tv.brightness = LED_FULL;
+	else
+		led_tv.brightness = LED_OFF;
+}
+
+static void led_tv_brightness_set_sysfs(struct led_classdev *led_cdev,
+				enum led_brightness brightness)
+{
+	switch (brightness) {
+	case LED_OFF:
+		led_tv.new_code = LENSL_LED_TV_OFF;
+		break;
+	case LED_FULL:
+		led_tv.new_code = LENSL_LED_TV_ON;
+		break;
+	default:
+		return;
+	}
+	queue_work(lensl_wq, &led_tv.work);
+}
+
+static enum led_brightness led_tv_brightness_get_sysfs(
+					struct led_classdev *led_cdev)
+{
+	return led_tv.brightness;
+}
+
+static int led_tv_blink_set_sysfs(struct led_classdev *led_cdev,
+			unsigned long *delay_on, unsigned long *delay_off)
+{
+	if (*delay_on == 0 && *delay_off == 0) {
+		/* If we can choose the flash rate, use dimmed blinking --
+		   it looks better */
+		led_tv.new_code = LENSL_LED_TV_ON |
+			LENSL_LED_TV_BLINK | LENSL_LED_TV_DIM;
+		*delay_on = 2000;
+		*delay_off = 2000;
+	} else if (*delay_on + *delay_off == 4000) {
+		/* User wants dimmed blinking */
+		led_tv.new_code = LENSL_LED_TV_ON |
+			LENSL_LED_TV_BLINK | LENSL_LED_TV_DIM;
+	} else if (*delay_on == 7250 && *delay_off == 500) {
+		/* User wants standard blinking mode */
+		led_tv.new_code = LENSL_LED_TV_ON | LENSL_LED_TV_BLINK;
+	} else
+		return -EINVAL;
+	queue_work(lensl_wq, &led_tv.work);
+	return 0;
+}
+
+static void led_exit(void)
+{
+	if (led_tv.supported) {
+		led_classdev_unregister(&led_tv.cdev);
+		led_tv.supported = 0;
+		set_tvls(LENSL_LED_TV_OFF);
+	}
+}
+
+static int led_init(void)
+{
+	int res;
+
+	memset(&led_tv, 0, sizeof(led_tv));
+	led_tv.cdev.brightness_get = led_tv_brightness_get_sysfs;
+	led_tv.cdev.brightness_set = led_tv_brightness_set_sysfs;
+	led_tv.cdev.blink_set = led_tv_blink_set_sysfs;
+	led_tv.cdev.name = LENSL_LED_TV_NAME;
+	INIT_WORK(&led_tv.work, led_tv_worker);
+	set_tvls(LENSL_LED_TV_OFF);
+	res = led_classdev_register(&lensl_pdev->dev, &led_tv.cdev);
+	if (res) {
+		pr_warning("Failed to register LED device\n");
+		return res;
+	}
+	led_tv.supported = 1;
+	pr_devel("Initialized LED subdriver\n");
+	return 0;
+}
+
+#else /* CONFIG_NEW_LEDS */
+
+static void led_exit(void)
+{
+}
+
+static int led_init(void)
+{
+	return -ENODEV;
+}
+
+#endif /* CONFIG_NEW_LEDS */
+
+/*************************************************************************
+    hwmon & fans
+ *************************************************************************/
+
+static struct device *lensl_hwmon_device;
+
+static inline int get_tach(int *value, int fan)
+{
+	return lensl_acpi_int_func(ec0_handle, "TACH", value, 1, fan);
+}
+
+static ssize_t fan1_input_show(struct device *dev,
+			struct device_attribute *attr, char *buf)
+{
+	int res;
+	int rpm;
+
+	res = get_tach(&rpm, 0);
+	if (res)
+		return res;
+	return snprintf(buf, PAGE_SIZE, "%u\n", rpm);
+}
+
+static struct device_attribute dev_attr_fan1_input =
+	__ATTR(fan1_input, S_IRUGO, fan1_input_show, NULL);
+
+static struct attribute *hwmon_attributes[] = {
+	&dev_attr_fan1_input.attr,
+	NULL
+};
+
+static const struct attribute_group hwmon_attr_group = {
+	.attrs = hwmon_attributes,
+};
+
+static void hwmon_exit(void)
+{
+	if (!lensl_hwmon_device)
+		return;
+
+	sysfs_remove_group(&lensl_hwmon_device->kobj,
+			   &hwmon_attr_group);
+	hwmon_device_unregister(lensl_hwmon_device);
+	lensl_hwmon_device = NULL;
+}
+
+static int hwmon_init(void)
+{
+	int res;
+
+	lensl_hwmon_device = hwmon_device_register(&lensl_pdev->dev);
+	if (!lensl_hwmon_device) {
+		pr_err("Failed to register hwmon device\n");
+		return -ENODEV;
+	}
+
+	res = sysfs_create_group(&lensl_hwmon_device->kobj,
+				 &hwmon_attr_group);
+	if (res < 0) {
+		pr_err("Failed to create hwmon sysfs group\n");
+		hwmon_device_unregister(lensl_hwmon_device);
+		lensl_hwmon_device = NULL;
+		return -ENODEV;
+	}
+	pr_devel("Initialized hwmon subdriver\n");
+	return 0;
+}
+
+/*************************************************************************
+    hotkeys
+ *************************************************************************/
+
+static struct input_dev *hkey_inputdev;
+
+struct key_entry {
+	char type;
+	u8 scancode;
+	int keycode;
+};
+
+enum { KE_KEY, KE_END };
+
+static struct key_entry ec_keymap[] = {
+	{KE_KEY, 0x0B, KEY_COFFEE },
+	{KE_KEY, 0x0C, KEY_BATTERY },
+	{KE_KEY, 0x0D, KEY_SLEEP },
+	{KE_KEY, 0x0E, KEY_WLAN },
+	{KE_KEY, 0x10, KEY_SWITCHVIDEOMODE },
+	{KE_KEY, 0x11, KEY_PROG1 },
+	{KE_KEY, 0x12, KEY_PROG2 },
+	{KE_KEY, 0x15, KEY_SUSPEND },
+	{KE_KEY, 0x69, KEY_VOLUMEUP },
+	{KE_KEY, 0x6A, KEY_VOLUMEDOWN },
+	{KE_KEY, 0x6B, KEY_MUTE },
+	{KE_KEY, 0x6C, KEY_BRIGHTNESSDOWN },
+	{KE_KEY, 0x6D, KEY_BRIGHTNESSUP },
+	{KE_KEY, 0x71, KEY_ZOOM },
+	{KE_KEY, 0x80, KEY_VENDOR },
+	{KE_END, 0},
+};
+
+static int hkey_action(void *data)
+{
+	int keycode;
+	struct key_entry *this_key = data;
+
+	if (!data)
+		return -EINVAL;
+	keycode = this_key->keycode;
+
+	if (keycode != KEY_RESERVED) {
+		input_report_key(hkey_inputdev, keycode, 1);
+		input_sync(hkey_inputdev);
+		input_report_key(hkey_inputdev, keycode, 0);
+		input_sync(hkey_inputdev);
+	}
+
+	return 0;
+}
+
+typedef int (*acpi_ec_query_func) (void *data);
+extern int acpi_ec_add_query_handler(void *ec, u8 query_bit,
+				     acpi_handle handle,
+				     acpi_ec_query_func func,
+				     void *data);
+static int hkey_add(struct acpi_device *device)
+{
+	int result;
+	struct key_entry *key;
+
+	for (key = ec_keymap; key->type != KE_END; key++) {
+		result = acpi_ec_add_query_handler(
+				acpi_driver_data(device->parent),
+				key->scancode, NULL,
+				hkey_action, key);
+		if (result) {
+			pr_err("Failed to register hotkey notification.\n");
+			return -ENODEV;
+		}
+	}
+	return 0;
+}
+
+extern void acpi_ec_remove_query_handler(void *ec, u8 query_bit);
+static int hkey_remove(struct acpi_device *device, int type)
+{
+	struct key_entry *key;
+
+	for (key = ec_keymap; key->type != KE_END; key++) {
+		acpi_ec_remove_query_handler(
+			acpi_driver_data(device->parent),
+			key->scancode);
+	}
+	return 0;
+}
+
+static const struct acpi_device_id hkey_ids[] = {
+	{"LEN0014", 0},
+	{"", 0},
+};
+
+static struct acpi_driver hkey_driver = {
+	.name = "lenovo-sl-laptop-hotkey",
+	.class = "lenovo",
+	.ids = hkey_ids,
+	.ops = {
+		.add = hkey_add,
+		.remove = hkey_remove,
+	},
+};
+
+static void hkey_inputdev_exit(void)
+{
+	if (hkey_inputdev) {
+		input_unregister_device(hkey_inputdev);
+		input_free_device(hkey_inputdev);
+		hkey_inputdev = NULL;
+	}
+}
+
+static int hkey_inputdev_init(void)
+{
+	int result;
+	struct key_entry *key;
+
+	hkey_inputdev = input_allocate_device();
+	if (!hkey_inputdev) {
+		pr_err("Failed to allocate hotkey input device\n");
+		return -ENODEV;
+	}
+	hkey_inputdev->name = "Lenovo ThinkPad SL Series extra buttons";
+	hkey_inputdev->phys = LENSL_HKEY_FILE "/input0";
+	hkey_inputdev->uniq = LENSL_HKEY_FILE;
+	hkey_inputdev->id.bustype = BUS_HOST;
+	hkey_inputdev->id.vendor = PCI_VENDOR_ID_LENOVO;
+	set_bit(EV_KEY, hkey_inputdev->evbit);
+
+	for (key = ec_keymap; key->type != KE_END; key++)
+		set_bit(key->keycode, hkey_inputdev->keybit);
+
+	result = input_register_device(hkey_inputdev);
+	if (result) {
+		pr_err("Failed to register hotkey input device\n");
+		input_free_device(hkey_inputdev);
+		hkey_inputdev = NULL;
+		return -ENODEV;
+	}
+	pr_devel("Initialized hotkey subdriver\n");
+	return 0;
+}
+
+static void hkey_register_notify(void)
+{
+	int result;
+
+	result = hkey_inputdev_init();
+	if (result) {
+		pr_err("Failed to register input device for hotkeys\n");
+		return;
+	}
+	result = acpi_bus_register_driver(&hkey_driver);
+	if (result)
+		pr_err("Failed to register hotkey driver\n");
+	return;
+}
+
+static void hkey_unregister_notify(void)
+{
+	hkey_inputdev_exit();
+	acpi_bus_unregister_driver(&hkey_driver);
+}
+
+/*************************************************************************
+    init/exit
+ *************************************************************************/
+
+static int __init lenovo_sl_laptop_init(void)
+{
+	int ret;
+	acpi_status status;
+
+	if (acpi_disabled)
+		return -ENODEV;
+
+	lensl_wq = create_singlethread_workqueue(LENSL_WORKQUEUE_NAME);
+	if (!lensl_wq) {
+		pr_err("Failed to create a workqueue\n");
+		return -ENOMEM;
+	}
+
+	hkey_handle = ec0_handle = NULL;
+	status = acpi_get_handle(NULL, LENSL_HKEY, &hkey_handle);
+	if (ACPI_FAILURE(status)) {
+		pr_err("Failed to get ACPI handle for %s\n", LENSL_HKEY);
+		return -ENODEV;
+	}
+	status = acpi_get_handle(NULL, LENSL_EC0, &ec0_handle);
+	if (ACPI_FAILURE(status)) {
+		pr_err("Failed to get ACPI handle for %s\n", LENSL_EC0);
+		return -ENODEV;
+	}
+
+	lensl_pdev = platform_device_register_simple(LENSL_DRVR_NAME, -1,
+						     NULL, 0);
+	if (IS_ERR(lensl_pdev)) {
+		ret = PTR_ERR(lensl_pdev);
+		lensl_pdev = NULL;
+		pr_err("Failed to register platform device\n");
+		return ret;
+	}
+
+	radio_init(LENSL_BLUETOOTH);
+	radio_init(LENSL_WWAN);
+	radio_init(LENSL_UWB);
+
+	hkey_register_notify();
+	led_init();
+	hwmon_init();
+
+	pr_info("Loaded Lenovo ThinkPad SL Series driver\n");
+	return 0;
+}
+
+static void __exit lenovo_sl_laptop_exit(void)
+{
+	hwmon_exit();
+	led_exit();
+	hkey_unregister_notify();
+
+	radio_exit(LENSL_UWB);
+	radio_exit(LENSL_WWAN);
+	radio_exit(LENSL_BLUETOOTH);
+
+	if (lensl_pdev)
+		platform_device_unregister(lensl_pdev);
+	destroy_workqueue(lensl_wq);
+
+	pr_info("Unloaded Lenovo ThinkPad SL Series driver\n");
+}
+
+MODULE_ALIAS("dmi:bvnLENOVO:*:svnLENOVO*:*:pvrThinkPad SL*:rvnLENOVO:*");
+MODULE_ALIAS("dmi:bvnLENOVO:*:svnLENOVO*:*:pvrThinkPadSL*:rvnLENOVO:*");
+
+module_init(lenovo_sl_laptop_init);
+module_exit(lenovo_sl_laptop_exit);
-- 
1.6.0.4

