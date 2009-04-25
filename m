Return-Path: <linux-kernel-owner+w=401wt.eu-S1760010AbZDYBqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760010AbZDYBqT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 21:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753515AbZDYBqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 21:46:06 -0400
Received: from smtprelay10.ispgateway.de ([80.67.29.24]:42044 "EHLO
	smtprelay10.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627AbZDYBqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 21:46:04 -0400
Message-ID: <cone.1240623959.159615.9486.1000@mentalhome>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <peter@piie.net>
To: LKML <linux-kernel@vger.kernel.org>
Cc: lenb@kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>
Subject: [PATCH] Acer Aspire One Fan Control
Date: Sat, 25 Apr 2009 03:45:59 +0200
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
X-Df-Sender: 404094
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I updated the acerhdf module, it uses now the polling functionality of 
the thermal api.

kind regards,
--peter


Acerhdf is a driver for Acer Aspire One netbooks. It allows to access
the temperature sensor and to control the fan.

Signed-off-by: Peter Feuerer <peter@piie.net>

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 284ebac..d1bf882 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -34,6 +34,25 @@ config ACER_WMI
 	  If you have an ACPI-WMI compatible Acer/ Wistron laptop, say Y or M
 	  here.
 
+config ACERHDF
+	tristate "Acer Aspire One temperature and fan driver"
+	depends on THERMAL
+	depends on THERMAL_HWMON
+	---help---
+	  This is a driver for Acer Aspire One netbooks. It allows to access
+	  the temperature sensor and to control the fan.
+
+	  The driver is started in "user" mode where the Bios takes care about
+	  controlling the fan, unless a userspace program controls it.
+	  To let the kernelmodule handle the fan, do:
+	  echo kernel > /sys/class/thermal/thermal_zone0/mode
+
+	  For more information about this driver see
+	  <http://piie.net/files/acerhdf_README.txt>
+
+	  If you have an Acer Aspire One netbook, say Y or M
+	  here.
+
 config ASUS_LAPTOP
 	tristate "Asus Laptop Extras (EXPERIMENTAL)"
 	depends on ACPI
diff --git a/drivers/platform/x86/Makefile b/drivers/platform/x86/Makefile
index e40c7bd..581b44f 100644
--- a/drivers/platform/x86/Makefile
+++ b/drivers/platform/x86/Makefile
@@ -9,6 +9,7 @@ obj-$(CONFIG_COMPAL_LAPTOP)	+= compal-laptop.o
 obj-$(CONFIG_DELL_LAPTOP)	+= dell-laptop.o
 obj-$(CONFIG_DELL_WMI)		+= dell-wmi.o
 obj-$(CONFIG_ACER_WMI)		+= acer-wmi.o
+obj-$(CONFIG_ACERHDF)		+= acerhdf.o
 obj-$(CONFIG_HP_WMI)		+= hp-wmi.o
 obj-$(CONFIG_TC1100_WMI)	+= tc1100-wmi.o
 obj-$(CONFIG_SONY_LAPTOP)	+= sony-laptop.o
diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
new file mode 100644
index 0000000..63dc485
--- /dev/null
+++ b/drivers/platform/x86/acerhdf.c
@@ -0,0 +1,594 @@
+/*
+ * acerhdf - A kernelmodule which monitors the temperature
+ *           of the aspire one netbook, turns on/off the fan
+ *           as soon as the upper/lower threshold is reached.
+ *
+ * (C) 2009 - Peter Feuerer     peter (a) piie.net
+ *                              http://piie.net
+ *
+ *
+ *
+ * Inspired by and many thanks to:
+ *  o acerfand   - Rachel Greenham
+ *  o acer_ec.pl - Michael Kurz     michi.kurz (at) googlemail.com
+ *               - Petr Tomasek     tomasek (#) etf,cuni,cz
+ *               - Carlos Corbacho  cathectic (at) gmail.com
+ *
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
+ *
+ *
+ *  06-February-2009: Version 0.1:
+ *  - first relase, containing absolutely no bugs! ;)
+ *
+ *  06-February-2009: Version 0.1.1:
+ *  - found first bug :-) - it didn't check the bios vendor
+ *  - check if the bios vendor is Acer
+ *  - added bios 3301
+ *
+ *  06-February-2009: Version 0.1.2:
+ *  - added fork for deamon mode, now a real daemon is spawned
+ *  - added device vendor "INSYDE"
+ *
+ *  13-February-2009: Version 0.2:
+ *  - ported to kernelspace
+ *
+ *  19-February-2009: Version 0.2.1:
+ *  - added Bios Version 3308
+ *  - cleaned up the includes
+ *
+ *  21-February-2009: Version 0.2.2:
+ *  - changed settings for Bios 3309 as old settings caused lock ups
+ *     - thanks to Frank Reimann
+ *
+ *  21-February-2009: Version 0.2.2-2:
+ *  - added linux/sched.h to includes again, as it won't compile for
+ *    kernel < 2.6.28 without it.
+ *
+ *  23-February-2009: Version 0.3:
+ *  - tied to termal layer
+ *  - added parameters to /sys/modules/acerhdf/parameters/
+ *
+ *  25-February-2009: Version 0.3.1:
+ *  - fixed starting the module in user mode when force_bios param
+ *    is given
+ *
+ *  28-February-2009: Version 0.3.2:
+ *  - changed coding style to fit the coding style of the kernel
+ *    and checked it via checkpatch
+ *
+ *  24-March-2009: Version 0.4.0:
+ *  - added MODULE_ALIAS macro
+ *  - added Gateway and Packard Bell Bios
+ *  - added suspend / resume functionality
+ *
+ *  25-March-2009: Version 0.4.1:
+ *  - coding style
+ *  - minor bugfixes
+ *
+ *  26-March-2009: Version 0.4.2:
+ *  - replaced kernel threads by kthread api
+ *
+ *  25-April-2009: Version 0.5:
+ *  - ported to 2.6.30
+ *  - removed kthread and used polling of thermal api
+ *
+ */
+
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/dmi.h>
+#include <acpi/acpi_drivers.h>
+#include <linux/sched.h>
+#include <linux/thermal.h>
+#include <linux/platform_device.h>
+
+#define VERSION "0.5.0"
+
+/* if you want the module to be started in kernelmode,
+ * uncomment following line */
+/* #define START_IN_KERNEL_MODE */
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Peter Feuerer");
+MODULE_DESCRIPTION("Aspire One temperature and fan driver");
+MODULE_ALIAS("dmi:*:*Acer*:*:");
+MODULE_ALIAS("dmi:*:*Gateway*:*:");
+MODULE_ALIAS("dmi:*:*Packard Bell*:*:");
+
+/* global variables */
+
+#ifdef START_IN_KERNEL_MODE
+static int kernelmode = 1;
+#else /* START_IN_KERNEL_MODE */
+static int kernelmode;
+#endif /* START_IN_KERNEL_MODE */
+
+static int interval = 10;
+static int fanon = 67;
+static int fanoff = 62;
+static int verbose;
+static int fanstate = 1;
+static int recently_changed;
+static int bios_version = -1;
+static char force_bios[16];
+static int prev_interval;
+struct thermal_zone_device *acerhdf_thz_dev;
+struct thermal_cooling_device *acerhdf_cool_dev;
+
+/* module parameters */
+module_param(interval, int, 0600);
+MODULE_PARM_DESC(interval, "Polling interval of temperature check");
+module_param(fanon, int, 0600);
+MODULE_PARM_DESC(fanon, "Turn the fan on above this temperature");
+module_param(fanoff, int, 0600);
+MODULE_PARM_DESC(fanoff, "Turn the fan off below this temperature");
+module_param(verbose, int, 0600);
+MODULE_PARM_DESC(verbose, "Enable verbose dmesg outputs");
+module_param_string(force_bios, force_bios, 16, 0);
+MODULE_PARM_DESC(force_bios, "Force bios version and omit bios check");
+
+/* bios settings */
+/**********************************************************************/
+struct bios_settings_t {
+	const char *vendor;
+	const char *version;
+	unsigned char fanreg;
+	unsigned char tempreg;
+	unsigned char cmd_off;
+	unsigned char cmd_auto;
+	unsigned char state_off;
+};
+
+/* some bios versions have different commands and
+ * maybe also different register addresses */
+static const struct bios_settings_t bios_settings[] = {
+	{"Acer", "v0.3109", 0x55, 0x58, 0x1f, 0x00, 0x1f},
+	{"Acer", "v0.3114", 0x55, 0x58, 0x1f, 0x00, 0x1f},
+	{"Acer", "v0.3301", 0x55, 0x58, 0xaf, 0x00, 0xaf},
+	{"Acer", "v0.3304", 0x55, 0x58, 0xaf, 0x00, 0xaf},
+	{"Acer", "v0.3305", 0x55, 0x58, 0xaf, 0x00, 0xaf},
+	{"Acer", "v0.3308", 0x55, 0x58, 0x21, 0x00, 0x21},
+	{"Acer", "v0.3309", 0x55, 0x58, 0x21, 0x00, 0x21},
+	{"Gateway", "v0.3103", 0x55, 0x58, 0x21, 0x00, 0x21},
+	{"Packard Bell", "v0.3105", 0x55, 0x58, 0x21, 0x00, 0x21},
+	{"", 0, 0, 0, 0, 0}
+};
+
+
+/* acer ec functions */
+/**********************************************************************/
+/* return temperature */
+static int get_temp(void)
+{
+	u8 temp;
+	/* read temperature */
+	if (!ec_read(bios_settings[bios_version].tempreg, &temp)) {
+		if (verbose)
+			printk(KERN_NOTICE "acerhdf: temp %d\n", temp);
+		return temp;
+	}
+	return -0xffff;
+}
+
+/* return state of the fan */
+static int get_fanstate(void)
+{
+	u8 fan;
+	if (!ec_read(bios_settings[bios_version].fanreg, &fan))
+		return (fan == bios_settings[bios_version].cmd_off) ? 0 : 1;
+
+	return -1;
+}
+
+/* switch on/off the fan */
+static void change_fanstate(int state)
+{
+	if (verbose)
+		printk(KERN_NOTICE "acerhdf: fan %s\n", (state) ? "ON" : "OFF");
+
+	ec_write(bios_settings[bios_version].fanreg,
+			(state) ? bios_settings[bios_version].cmd_auto :
+			bios_settings[bios_version].cmd_off);
+
+	fanstate = state;
+}
+
+/* thermal zone callback functions */
+/**********************************************************************/
+/* check if parameter have changed */
+static void check_param(struct thermal_zone_device *thermal)
+{
+	if (kernelmode && prev_interval != interval) {
+		if (verbose)
+			printk(KERN_NOTICE "acerhdf: interval changed to: %d\n",
+					interval);
+		thermal->polling_delay = interval*1000;
+		prev_interval = interval;
+	}
+}
+
+/* return temperature */
+static int get_ec_temp(struct thermal_zone_device *thermal, unsigned long *t)
+{
+	int temp;
+	/* check if parameter have changed */
+	check_param(thermal);
+	/* return temperature */
+	temp = get_temp();
+	if (temp != -0xffff) {
+		*t = temp;
+		return 0;
+	}
+	return -EINVAL;
+}
+
+/* bind the cooling device to the thermal zone */
+static int bind(struct thermal_zone_device *thermal,
+		struct thermal_cooling_device *cdev)
+{
+	/* if the cooling device is the one from acerhdf bind it */
+	if (cdev == acerhdf_cool_dev) {
+		if (thermal_zone_bind_cooling_device(thermal, 0, cdev)) {
+			printk(KERN_ERR
+				"acerhdf: error binding cooling dev\n");
+			return -EINVAL;
+		}
+	}
+	return 0;
+}
+
+/* unbind cooling device from thermal zone */
+static int unbind(struct thermal_zone_device *thermal,
+		struct thermal_cooling_device *cdev)
+{
+	if (cdev == acerhdf_cool_dev) {
+		if (thermal_zone_unbind_cooling_device(thermal, 0, cdev)) {
+			printk(KERN_ERR
+				"acerhdf: error unbinding cooling dev\n");
+			return -EINVAL;
+		}
+	}
+	return 0;
+}
+
+/* print currend operation mode - kernel / user */
+static int get_mode(struct thermal_zone_device *thermal,
+		enum thermal_device_mode *mode)
+{
+	if (verbose)
+		printk(KERN_NOTICE "acerhdf: kernelmode %d\n", kernelmode);
+	*mode = (kernelmode) ? THERMAL_DEVICE_ENABLED :
+		THERMAL_DEVICE_DISABLED;
+
+	return 0;
+}
+
+/* set operation mode;
+ * kernel: a kernel thread takes care about managing the
+ *	 fan (see acerhdf_thread)
+ * user: kernel thread is stopped and a userspace tool
+ *	 should take care about managing the fan
+ */
+static int set_mode(struct thermal_zone_device *thermal,
+		enum thermal_device_mode mode)
+{
+	if (mode == THERMAL_DEVICE_DISABLED) {
+		if (verbose)
+			printk(KERN_NOTICE "acerhdf: kernelmode OFF\n");
+		thermal->polling_delay = 0;
+		thermal_zone_device_update(thermal);
+		change_fanstate(1);
+		/* silly hack - let the polling thread disable
+		 * kernelmode. This ensures, that the polling thread
+		 * doesn't switch off the fan again */
+		recently_changed = 1;
+	} else if (mode == THERMAL_DEVICE_ENABLED) {
+		if (verbose)
+			printk(KERN_NOTICE "acerhdf: kernelmode ON\n");
+		thermal->polling_delay = interval*1000;
+		thermal_zone_device_update(thermal);
+		kernelmode = 1;
+	}
+	return 0;
+}
+
+/* print the name of the trip point */
+static int get_trip_type(struct thermal_zone_device *thermal,
+		int trip, enum thermal_trip_type *type)
+{
+	if (trip == 0)
+		*type = THERMAL_TRIP_ACTIVE;
+	return 0;
+}
+
+/* print the temperature at which the trip point gets active */
+static int get_trip_temp(struct thermal_zone_device *thermal,
+		int trip, unsigned long *temp)
+{
+	if (trip == 0)
+		*temp = fanon;
+	return 0;
+}
+
+static int get_crit_temp(struct thermal_zone_device *thermal,
+		unsigned long *temperature)
+{
+	*temperature = 89;
+	return 0;
+}
+
+/* bind callback functions to thermalzone */
+struct thermal_zone_device_ops acerhdf_device_ops = {
+	.bind = bind,
+	.unbind = unbind,
+	.get_temp = get_ec_temp,
+	.get_mode = get_mode,
+	.set_mode = set_mode,
+	.get_trip_type = get_trip_type,
+	.get_trip_temp = get_trip_temp,
+	.get_crit_temp = get_crit_temp,
+};
+
+
+/* cooling device callback functions */
+/**********************************************************************/
+/* print maximal fan cooling state */
+static int get_max_state(struct thermal_cooling_device *cdev,
+		unsigned long *state)
+{
+	*state = 1;
+	return 0;
+}
+
+/* print current fan state */
+static int get_cur_state(struct thermal_cooling_device *cdev,
+		unsigned long *state)
+{
+	*state = get_fanstate();
+
+	return 0;
+}
+
+/* change current fan state - is overwritten when running in kernel mode */
+static int set_cur_state(struct thermal_cooling_device *cdev,
+		unsigned long state)
+{
+	int old_state;
+
+	/* silly hack - let the polling thread disable
+	 * kernelmode. This ensures, that the polling thread
+	 * doesn't switch off the fan again */
+	if (recently_changed) {
+		recently_changed = 0;
+		kernelmode = 0;
+		return 0;
+	}
+
+	if (!kernelmode) {
+		change_fanstate(state);
+		return 0;
+	}
+
+	old_state = get_fanstate();
+
+	if (state && !old_state)
+		change_fanstate(1);
+
+	if (!state && old_state && (get_temp() < fanoff))
+		change_fanstate(0);
+
+	return 0;
+}
+
+/* bind fan callbacks to fan device */
+struct thermal_cooling_device_ops acerhdf_cooling_ops = {
+	.get_max_state = get_max_state,
+	.get_cur_state = get_cur_state,
+	.set_cur_state = set_cur_state,
+};
+
+/* platform callbacks */
+/**********************************************************************/
+/* go suspend */
+static int acerhdf_suspend(struct platform_device *dev,
+		pm_message_t state)
+{
+	if (verbose)
+		printk(KERN_NOTICE "acerhdf: going suspend\n");
+	return 0;
+}
+
+/* wake up */
+static int acerhdf_resume(struct platform_device *device)
+{
+	if (verbose)
+		printk(KERN_NOTICE "acerhdf: resuming\n");
+	return 0;
+}
+
+/* platform probe */
+static int __devinit acerhdf_probe(struct platform_device *device)
+{
+	return 0;
+}
+
+static int acerhdf_remove(struct platform_device *device)
+{
+	return 0;
+}
+
+static struct platform_driver acerhdf_driver = {
+	.driver = {
+		.name = "acerhdf",
+		.owner = THIS_MODULE,
+	},
+	.probe = acerhdf_probe,
+	.remove = acerhdf_remove,
+	.suspend = acerhdf_suspend,
+	.resume = acerhdf_resume,
+};
+
+static struct platform_device *acerhdf_device;
+
+/* kernel module init / exit functions */
+/**********************************************************************/
+/* initialize the module */
+static int __init acerhdf_init(void)
+{
+	char const *vendor;
+	char const *version;
+	char const *release;
+	char const *product;
+	int i;
+	int ret_val = 0;
+
+
+	/* get bios data */
+	vendor = dmi_get_system_info(DMI_SYS_VENDOR);
+	version = dmi_get_system_info(DMI_BIOS_VERSION);
+	release = dmi_get_system_info(DMI_BIOS_DATE);
+	product = dmi_get_system_info(DMI_PRODUCT_NAME);
+
+
+	/* print out bios data */
+	printk(KERN_NOTICE "acerhdf: version: %s compilation date: %s %s\n",
+			VERSION, __DATE__, __TIME__);
+	printk(KERN_NOTICE "acerhdf: biosvendor:%s\n", vendor);
+	printk(KERN_NOTICE "acerhdf: biosversion:%s\n", version);
+	printk(KERN_NOTICE "acerhdf: biosrelease:%s\n", release);
+	printk(KERN_NOTICE "acerhdf: biosproduct:%s\n", product);
+
+	if (!force_bios[0]) {
+		/* check if product is a AO - Aspire One */
+		if (strncmp(product, "AO", 2)) {
+			printk(KERN_ERR
+				"acerhdf: no Aspire One hardware found\n");
+			ret_val = -ENODEV;
+			goto EXIT;
+		}
+	} else {
+		printk(KERN_NOTICE
+			"acerhdf: bios version: %s forced\n",
+			version);
+		version = force_bios;
+		kernelmode = 0;
+	}
+
+	/* if started in user mode, prevent the kernel from switching
+	 * off the fan */
+	if (!kernelmode) {
+		recently_changed = 1;
+		printk(KERN_NOTICE
+			"acerhdf: kernelmode disabled\n");
+		printk(KERN_NOTICE
+			"acerhdf: to enable kernelmode:\n");
+		printk(KERN_NOTICE
+			"acerhdf: echo -n \"enabled\" > "
+			"/sys/class/thermal/thermal_zone0/mode\n");
+		printk(KERN_NOTICE
+			"acerhdf: for more information read:\n");
+		printk(KERN_NOTICE
+			"acerhdf: http://piie.net/files/acerhdf_README.txt\n");
+	}
+
+
+	/* search bios and bios vendor in bios settings table */
+	for (i = 0; bios_settings[i].version[0]; ++i) {
+		if (!strcmp(bios_settings[i].vendor, vendor) &&
+				!strcmp(bios_settings[i].version, version)) {
+			bios_version = i;
+			break;
+		}
+	}
+	if (bios_version == -1) {
+		printk(KERN_ERR "acerhdf: cannot find bios version\n");
+		ret_val = -ENODEV;
+		goto EXIT;
+	}
+
+	/* register platform device */
+	if (platform_driver_register(&acerhdf_driver)) {
+		ret_val = -ENODEV;
+		goto EXIT;
+	}
+	acerhdf_device = platform_device_alloc("acerhdf", -1);
+	platform_device_add(acerhdf_device);
+
+	/* create cooling device */
+	acerhdf_cool_dev = thermal_cooling_device_register("acerhdf-fan", NULL,
+			&acerhdf_cooling_ops);
+	if (IS_ERR(acerhdf_cool_dev)) {
+		ret_val = -ENODEV;
+		goto EXIT_PLAT_UNREG;
+	}
+
+	/* create thermal zone */
+	acerhdf_thz_dev = thermal_zone_device_register("acerhdf", 1,
+			NULL, &acerhdf_device_ops, 0, 0, 0,
+			(kernelmode) ? interval*1000 : 0);
+	if (IS_ERR(acerhdf_thz_dev)) {
+		ret_val = -ENODEV;
+		goto EXIT_COOL_UNREG;
+	}
+
+	goto EXIT;
+
+EXIT_COOL_UNREG:
+	/* unregister cooling device */
+	if (acerhdf_cool_dev) {
+		thermal_cooling_device_unregister(acerhdf_cool_dev);
+		acerhdf_cool_dev = NULL;
+	}
+
+EXIT_PLAT_UNREG:
+	/* unregister platform device */
+	if (acerhdf_device) {
+		platform_device_del(acerhdf_device);
+		platform_driver_unregister(&acerhdf_driver);
+	}
+
+EXIT:
+	return ret_val;
+}
+
+/* exit the module */
+static void __exit acerhdf_exit(void)
+{
+	change_fanstate(1);
+
+	/* unregister cooling device */
+	if (acerhdf_cool_dev) {
+		thermal_cooling_device_unregister(acerhdf_cool_dev);
+		acerhdf_cool_dev = NULL;
+	}
+	/* unregister thermal zone */
+	if (acerhdf_thz_dev) {
+		thermal_zone_device_unregister(acerhdf_thz_dev);
+		acerhdf_thz_dev = NULL;
+	}
+
+	/* unregister platform device */
+	if (acerhdf_device) {
+		platform_device_del(acerhdf_device);
+		platform_driver_unregister(&acerhdf_driver);
+	}
+}
+
+/* what are the module init/exit functions */
+module_init(acerhdf_init);
+module_exit(acerhdf_exit);
