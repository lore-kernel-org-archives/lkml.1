Return-Path: <linux-kernel-owner+w=401wt.eu-S1763099AbZEFWXI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763099AbZEFWXI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 18:23:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752975AbZEFWRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 18:17:09 -0400
Received: from smtprelay09.ispgateway.de ([80.67.29.23]:57207 "EHLO
	smtprelay09.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763470AbZEFWRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 18:17:04 -0400
References: <cone.1240623959.159615.9486.1000@mentalhome> <cone.1240648971.372002.7492.1000@mentalhome> <20090426172947.GB3643@liondog.tnic> <cone.1240858632.795110.5316.1000@onepiie> <20090428072519.GA12170@liondog.tnic> <1240913055.29860.14.camel@maxim-laptop> <cone.1240949852.549814.7466.1000@mentalhome> <1240950704.3781.12.camel@maxim-laptop> <cone.1241299309.265715.3948.1000@mentalhome> <20090503184617.GA3555@liondog.tnic>
Message-ID: <cone.1241648222.299676.7476.1000@mentalhome>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <peter@piie.net>
To: petkovbb@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>, lenb@kernel.org,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [PATCH] Acer Aspire One Fan Control
Date: Thu, 07 May 2009 00:17:02 +0200
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
X-Df-Sender: 404094
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

new patch attached. Compiled and tested with latest linus git. Any further suggestions?

kind regards,
--peter


Acerhdf is a driver for Acer Aspire One netbooks. It allows to access
the temperature sensor and to control the fan.

Signed-off-by: Peter Feuerer <peter@piie.net>

diff --git a/MAINTAINERS b/MAINTAINERS
index c547f4a..262d721 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -222,6 +222,13 @@ L:	linux-acenic@sunsite.dk
 S:	Maintained
 F:	drivers/net/acenic*
 
+ACER ASPIRE ONE TEMPERATURE AND FAN DRIVER
+P: Peter Feuerer
+M: peter@piie.net
+W: http://piie.net/?section=acerhdf
+S: Maintained
+F: drivers/platform/x86/acerhdf.c
+
 ACER WMI LAPTOP EXTRAS
 P:	Carlos Corbacho
 M:	carlos@strangeworlds.co.uk
diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 284ebac..c4fce42 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -34,6 +34,24 @@ config ACER_WMI
 	  If you have an ACPI-WMI compatible Acer/ Wistron laptop, say Y or M
 	  here.
 
+config ACERHDF
+	tristate "Acer Aspire One temperature and fan driver"
+	depends on THERMAL && THERMAL_HWMON
+	---help---
+	  This is a driver for Acer Aspire One netbooks. It allows to access
+	  the temperature sensor and to control the fan.
+
+	  The driver is started in "user" mode where the Bios takes care about
+	  controlling the fan, unless a userspace program controls it.
+	  To let the module handle the fan, do:
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
index e40c7bd..641b8bf 100644
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
index 0000000..fd76f44
--- /dev/null
+++ b/drivers/platform/x86/acerhdf.c
@@ -0,0 +1,518 @@
+/*
+ * acerhdf - A kernelmodule which monitors the temperature
+ *           of the aspire one netbook, turns on/off the fan
+ *           as soon as the upper/lower threshold is reached.
+ *
+ * (C) 2009 - Peter Feuerer     peter (a) piie.net
+ *                              http://piie.net
+ *
+ * Inspired by and many thanks to:
+ *  o acerfand   - Rachel Greenham
+ *  o acer_ec.pl - Michael Kurz     michi.kurz (at) googlemail.com
+ *               - Petr Tomasek     tomasek (#) etf,cuni,cz
+ *               - Carlos Corbacho  cathectic (at) gmail.com
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
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/dmi.h>
+#include <acpi/acpi_drivers.h>
+#include <linux/sched.h>
+#include <linux/thermal.h>
+#include <linux/platform_device.h>
+
+/* if you want the module to be started in kernelmode,
+ * uncomment following line */
+/* #define START_IN_KERNEL_MODE */
+
+#define VERSION "0.5.1"
+/* Referring the Atom N270 Datasheet are 90 degree Celsius on-die fine. So
+ * critical temperature is 89 degree Celsius to prevent hardware damage */
+#define ACERHDF_TEMP_CRIT 89
+#define ACERHDF_FAN_AUTO 1
+#define ACERHDF_FAN_OFF 0
+/* No matter what value the user puts into the fanon variable, turn on the fan
+ * at 80 degree Celsius to prevent hardware damage */
+#define ACERHDF_MAX_FANON 80
+/* Maximal interval between to temperature checks is 20 seconds, as the die
+ * can get hot really fast under heavy load */
+#define ACERHDF_MAX_INTERVAL 20
+#define ACERHDF_ERROR -0xffff
+
+#define acerhdf_printk(loglevel, fmt, args...) \
+	printk(loglevel "acerhdf: " fmt, ## args);
+
+#define acerhdf_notice(fmt, args...) \
+	acerhdf_printk(KERN_NOTICE, fmt, ## args);
+
+#define acerhdf_error(fmt, args...) \
+	acerhdf_printk(KERN_ERR, fmt, ## args);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Peter Feuerer");
+MODULE_DESCRIPTION("Aspire One temperature and fan driver");
+MODULE_ALIAS("dmi:*:*Acer*:*:");
+MODULE_ALIAS("dmi:*:*Gateway*:*:");
+MODULE_ALIAS("dmi:*:*Packard Bell*:*:");
+
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
+static int fanstate = ACERHDF_FAN_AUTO;
+static int disable_kernelmode;
+static int bios_version = -1;
+static char force_bios[16];
+static int prev_interval;
+struct thermal_zone_device *acerhdf_thz_dev;
+struct thermal_cooling_device *acerhdf_cool_dev;
+
+module_param(kernelmode, int, 0);
+MODULE_PARM_DESC(kernelmode, "Kernel mode on / off");
+module_param(interval, int, 0600);
+MODULE_PARM_DESC(interval, "Polling interval of temperature check");
+module_param(fanon, int, 0600);
+MODULE_PARM_DESC(fanon, "Turn the fan on above this temperature");
+module_param(fanoff, int, 0600);
+MODULE_PARM_DESC(fanoff, "Turn the fan off below this temperature");
+module_param(verbose, int, 0600);
+MODULE_PARM_DESC(verbose, "Enable verbose dmesg outputs");
+module_param_string(force_bios, force_bios, 16, 0);
+MODULE_PARM_DESC(force_bios, "Force BIOS version and omit BIOS check");
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
+};
+
+/* some bios versions have different commands and
+ * maybe also different register addresses */
+static const struct bios_settings_t bios_settings[] = {
+	{"Acer", "v0.3109", 0x55, 0x58, 0x1f, 0x00},
+	{"Acer", "v0.3114", 0x55, 0x58, 0x1f, 0x00},
+	{"Acer", "v0.3301", 0x55, 0x58, 0xaf, 0x00},
+	{"Acer", "v0.3304", 0x55, 0x58, 0xaf, 0x00},
+	{"Acer", "v0.3305", 0x55, 0x58, 0xaf, 0x00},
+	{"Acer", "v0.3308", 0x55, 0x58, 0x21, 0x00},
+	{"Acer", "v0.3309", 0x55, 0x58, 0x21, 0x00},
+	{"Gateway", "v0.3103", 0x55, 0x58, 0x21, 0x00},
+	{"Packard Bell", "v0.3105", 0x55, 0x58, 0x21, 0x00},
+	{"", 0, 0, 0, 0, 0}
+};
+
+
+/* acer ec functions */
+/**********************************************************************/
+/* return temperature */
+static int acerhdf_get_temp(void)
+{
+	u8 temp;
+	/* read temperature */
+	if (!ec_read(bios_settings[bios_version].tempreg, &temp)) {
+		if (verbose)
+			acerhdf_notice("temp %d\n", temp);
+		return temp;
+	}
+	return ACERHDF_ERROR;
+}
+
+/* return state of the fan */
+static int acerhdf_get_fanstate(void)
+{
+	u8 fan;
+	if (!ec_read(bios_settings[bios_version].fanreg, &fan))
+		return (fan == bios_settings[bios_version].cmd_off) ?
+			ACERHDF_FAN_OFF : ACERHDF_FAN_AUTO;
+
+	return ACERHDF_ERROR;
+}
+
+/* switch on/off the fan */
+static void acerhdf_change_fanstate(int state)
+{
+	unsigned char cmd;
+
+	if (verbose)
+		acerhdf_notice("fan %s\n", (state == ACERHDF_FAN_AUTO) ?
+				"ON" : "OFF");
+
+	if (state == ACERHDF_FAN_AUTO) {
+		cmd = bios_settings[bios_version].cmd_auto;
+		fanstate = ACERHDF_FAN_AUTO;
+	} else {
+		cmd = bios_settings[bios_version].cmd_off;
+		fanstate = ACERHDF_FAN_OFF;
+	}
+
+	ec_write(bios_settings[bios_version].fanreg, cmd);
+
+}
+
+/* helpers */
+/**********************************************************************/
+/* check if parameters have changed */
+static void acerhdf_check_param(struct thermal_zone_device *thermal)
+{
+	if (fanon > ACERHDF_MAX_FANON) {
+		acerhdf_error("fanon temperature too high, set to %d\n",
+				ACERHDF_MAX_FANON);
+		fanon = ACERHDF_MAX_FANON;
+	}
+	if (kernelmode && prev_interval != interval) {
+		if (interval > ACERHDF_MAX_INTERVAL) {
+			acerhdf_error("interval too high, set to %d\n",
+					ACERHDF_MAX_INTERVAL);
+			interval = ACERHDF_MAX_INTERVAL;
+		}
+		if (verbose)
+			acerhdf_notice("interval changed to: %d\n",
+					interval);
+		thermal->polling_delay = interval*1000;
+		prev_interval = interval;
+	}
+}
+
+/* thermal zone callback functions */
+/**********************************************************************/
+/* return temperature */
+static int acerhdf_get_ec_temp(struct thermal_zone_device *thermal,
+		unsigned long *t)
+{
+	int temp;
+
+	/* check if parameters have changed */
+	acerhdf_check_param(thermal);
+
+	/* return temperature */
+	temp = acerhdf_get_temp();
+	if (temp == ACERHDF_ERROR)
+		return -EINVAL;
+
+	*t = temp;
+	return 0;
+}
+
+/* bind the cooling device to the thermal zone */
+static int acerhdf_bind(struct thermal_zone_device *thermal,
+		struct thermal_cooling_device *cdev)
+{
+	/* if the cooling device is the one from acerhdf bind it */
+	if (cdev == acerhdf_cool_dev) {
+		if (thermal_zone_bind_cooling_device(thermal, 0, cdev)) {
+			acerhdf_error("error binding cooling dev\n");
+			return -EINVAL;
+		}
+	}
+	return 0;
+}
+
+/* unbind cooling device from thermal zone */
+static int acerhdf_unbind(struct thermal_zone_device *thermal,
+		struct thermal_cooling_device *cdev)
+{
+	if (cdev == acerhdf_cool_dev) {
+		if (thermal_zone_unbind_cooling_device(thermal, 0, cdev)) {
+			acerhdf_error("acerhdf: error unbinding cooling dev\n");
+			return -EINVAL;
+		}
+	}
+	return 0;
+}
+
+/*  current operation mode - kernel / user */
+static int acerhdf_get_mode(struct thermal_zone_device *thermal,
+		enum thermal_device_mode *mode)
+{
+	if (verbose)
+		acerhdf_notice("kernelmode %d\n", kernelmode);
+
+	*mode = (kernelmode) ? THERMAL_DEVICE_ENABLED :
+		THERMAL_DEVICE_DISABLED;
+
+	return 0;
+}
+
+/* set operation mode;
+ * kernel: the thermal layer of the kernel takes care about
+ *         the temperature and the fan.
+ * user: the BIOS takes control of the fan until a userspace
+ *       tool does.
+ */
+static int acerhdf_set_mode(struct thermal_zone_device *thermal,
+		enum thermal_device_mode mode)
+{
+	if (mode == THERMAL_DEVICE_DISABLED) {
+		acerhdf_notice("kernelmode OFF\n");
+		thermal->polling_delay = 0;
+		thermal_zone_device_update(thermal);
+		acerhdf_change_fanstate(ACERHDF_FAN_AUTO);
+
+		/* let the thermal layer disable kernelmode. This ensures that
+		 * the thermal layer doesn't switch off the fan again */
+		disable_kernelmode = 1;
+	} else {
+		acerhdf_notice("kernelmode ON\n");
+		thermal->polling_delay = interval*1000;
+		thermal_zone_device_update(thermal);
+		kernelmode = 1;
+	}
+	return 0;
+}
+
+/* get the type of the trip point */
+static int acerhdf_get_trip_type(struct thermal_zone_device *thermal,
+		int trip, enum thermal_trip_type *type)
+{
+	if (trip == 0)
+		*type = THERMAL_TRIP_ACTIVE;
+	return 0;
+}
+
+/* get the temperature at which the trip point gets active */
+static int acerhdf_get_trip_temp(struct thermal_zone_device *thermal,
+		int trip, unsigned long *temp)
+{
+	if (trip == 0)
+		*temp = fanon;
+	return 0;
+}
+
+static int acerhdf_get_crit_temp(struct thermal_zone_device *thermal,
+		unsigned long *temperature)
+{
+	*temperature = ACERHDF_TEMP_CRIT;
+	return 0;
+}
+
+/* bind callback functions to thermalzone */
+struct thermal_zone_device_ops acerhdf_device_ops = {
+	.bind = acerhdf_bind,
+	.unbind = acerhdf_unbind,
+	.get_temp = acerhdf_get_ec_temp,
+	.get_mode = acerhdf_get_mode,
+	.set_mode = acerhdf_set_mode,
+	.get_trip_type = acerhdf_get_trip_type,
+	.get_trip_temp = acerhdf_get_trip_temp,
+	.get_crit_temp = acerhdf_get_crit_temp,
+};
+
+
+/* cooling device callback functions */
+/**********************************************************************/
+/* get maximal fan cooling state */
+static int acerhdf_get_max_state(struct thermal_cooling_device *cdev,
+		unsigned long *state)
+{
+	*state = 1;
+	return 0;
+}
+
+/* get current fan state */
+static int acerhdf_get_cur_state(struct thermal_cooling_device *cdev,
+		unsigned long *state)
+{
+	unsigned long st = acerhdf_get_fanstate();
+
+	if (st == ACERHDF_ERROR)
+		return -EINVAL;
+
+	*state = (st == ACERHDF_FAN_AUTO) ? 1 : 0;
+	return 0;
+}
+
+/* change current fan state - is overwritten when running in kernel mode */
+static int acerhdf_set_cur_state(struct thermal_cooling_device *cdev,
+		unsigned long state)
+{
+	int old_state;
+
+	/* let the thermal layer disable kernelmode. This ensures that
+	 * the thermal layer doesn't switch off the fan again */
+	if (disable_kernelmode) {
+		acerhdf_change_fanstate(ACERHDF_FAN_AUTO);
+		disable_kernelmode = 0;
+		kernelmode = 0;
+		return 0;
+	}
+
+	if (!kernelmode) {
+		acerhdf_change_fanstate(state);
+		return 0;
+	}
+
+	old_state = acerhdf_get_fanstate();
+
+	/* if reading the fan's state returns unexpected value, there's a
+	 * problem with the ec register. -> let the BIOS take control of
+	 * the fan to prevent hardware damage */
+	if (old_state != fanstate) {
+		acerhdf_error("failed reading fan state, "
+				"disabling kernelmode.\n");
+
+		if (verbose)
+			acerhdf_error("read state: %d expected state: %d\n",
+					old_state, fanstate);
+
+		acerhdf_change_fanstate(ACERHDF_FAN_AUTO);
+		disable_kernelmode = 1;
+	}
+
+	if (state == 0) {
+		/* turn fan off only if below fanoff temperature */
+		if ((old_state == ACERHDF_FAN_AUTO) &&
+				(acerhdf_get_temp() < fanoff))
+			acerhdf_change_fanstate(ACERHDF_FAN_OFF);
+	} else {
+		if (old_state == ACERHDF_FAN_OFF)
+			acerhdf_change_fanstate(ACERHDF_FAN_AUTO);
+	}
+
+	return 0;
+}
+
+/* bind fan callbacks to fan device */
+struct thermal_cooling_device_ops acerhdf_cooling_ops = {
+	.get_max_state = acerhdf_get_max_state,
+	.get_cur_state = acerhdf_get_cur_state,
+	.set_cur_state = acerhdf_set_cur_state,
+};
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
+	/* get BIOS data */
+	vendor = dmi_get_system_info(DMI_SYS_VENDOR);
+	version = dmi_get_system_info(DMI_BIOS_VERSION);
+	release = dmi_get_system_info(DMI_BIOS_DATE);
+	product = dmi_get_system_info(DMI_PRODUCT_NAME);
+
+
+	/* print out BIOS data */
+	acerhdf_notice("%s found BIOS vendor: \"%s\" version: \"%s\"\n",
+			VERSION, vendor, version);
+	if (verbose)
+		acerhdf_notice("BIOS release: \"%s\" product: \"%s\"\n",
+				release, product);
+
+	if (!force_bios[0]) {
+		/* check if product is a AO - Aspire One */
+		if (strncmp(product, "AO", 2)) {
+			acerhdf_error("no Aspire One hardware found\n");
+			ret_val = -ENODEV;
+			goto EXIT;
+		}
+	} else {
+		acerhdf_notice("acerhdf: BIOS version: %s forced\n", version);
+		version = force_bios;
+		kernelmode = 0;
+	}
+
+	/* if started in user mode, prevent the kernel from switching
+	 * off the fan */
+	if (!kernelmode) {
+		disable_kernelmode = 1;
+		acerhdf_notice("kernelmode OFF, to enable:\n");
+		acerhdf_notice("echo -n \"enabled\" > "
+			"/sys/class/thermal/thermal_zone0/mode\n");
+		acerhdf_notice("http://piie.net/files/acerhdf_README.txt\n");
+	}
+
+
+	/* search BIOS version and BIOS vendor in BIOS settings table */
+	for (i = 0; bios_settings[i].version[0]; ++i) {
+		if (!strcmp(bios_settings[i].vendor, vendor) &&
+				!strcmp(bios_settings[i].version, version)) {
+			bios_version = i;
+			break;
+		}
+	}
+	if (bios_version == -1) {
+		acerhdf_error("cannot find BIOS version\n");
+		ret_val = -ENODEV;
+		goto EXIT;
+	}
+
+	acerhdf_cool_dev = thermal_cooling_device_register("acerhdf-fan", NULL,
+			&acerhdf_cooling_ops);
+	if (IS_ERR(acerhdf_cool_dev)) {
+		ret_val = -ENODEV;
+		goto EXIT;
+	}
+
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
+	if (acerhdf_cool_dev) {
+		thermal_cooling_device_unregister(acerhdf_cool_dev);
+		acerhdf_cool_dev = NULL;
+	}
+
+EXIT:
+	return ret_val;
+}
+
+/* exit the module */
+static void __exit acerhdf_exit(void)
+{
+	acerhdf_change_fanstate(ACERHDF_FAN_AUTO);
+
+	if (acerhdf_cool_dev) {
+		thermal_cooling_device_unregister(acerhdf_cool_dev);
+		acerhdf_cool_dev = NULL;
+	}
+
+	if (acerhdf_thz_dev) {
+		thermal_zone_device_unregister(acerhdf_thz_dev);
+		acerhdf_thz_dev = NULL;
+	}
+}
+
+/* what are the module init/exit functions */
+module_init(acerhdf_init);
+module_exit(acerhdf_exit);
