Return-Path: <linux-kernel-owner+w=401wt.eu-S1753300AbZFAOSa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300AbZFAOSa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 10:18:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751263AbZFAOSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 10:18:23 -0400
Received: from smtprelay07.ispgateway.de ([80.67.31.41]:33493 "EHLO
	smtprelay07.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbZFAOSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 10:18:22 -0400
X-Greylist: delayed 355 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Jun 2009 10:18:21 EDT
References: <1240913055.29860.14.camel@maxim-laptop> <cone.1240949852.549814.7466.1000@mentalhome> <1240950704.3781.12.camel@maxim-laptop> <cone.1241299309.265715.3948.1000@mentalhome> <20090503184617.GA3555@liondog.tnic> <cone.1241648222.299676.7476.1000@mentalhome> <20090509171432.GA31126@liondog.tnic> <cone.1242065107.695268.13534.1000@onepiie> <20090512060231.GB26286@liondog.tnic> <cone.1242669880.118150.4276.1000@deskpiie> <20090524192219.GA30285@liondog.tnic>
Message-ID: <cone.1243865900.580144.4368.1000@deskpiie>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <peter@piie.net>
To: Borislav Petkov <petkovbb@googlemail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, lenb@kernel.org,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [PATCH] Acer Aspire One Fan Control
Date: Mon, 01 Jun 2009 16:18:20 +0200
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Df-Sender: 404094
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everybody,

new acerhdf patch, as usual patched against and tested with recent linus git tree.
I lowered the default trip points to fanon=63 and fanoff=58 as it's more 
secure and still high enaugh to keep the netbook quiet while idling.

kind regards,
--peter




Acerhdf is a driver for Acer Aspire One netbooks. It allows to access
the temperature sensor and to control the fan.

Signed-off-by: Peter Feuerer <peter@piie.net>
Reviewed-by: Borislav Petkov <petkovbb@gmail.com>
Tested-by: Borislav Petkov <petkovbb@gmail.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 41c6605..bd7617e 100644
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
index 284ebac..fe14dfd 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -34,6 +34,23 @@ config ACER_WMI
 	  If you have an ACPI-WMI compatible Acer/ Wistron laptop, say Y or M
 	  here.
 
+config ACERHDF
+	tristate "Acer Aspire One temperature and fan driver"
+	depends on THERMAL && THERMAL_HWMON
+	---help---
+	  This is a driver for Acer Aspire One netbooks. It allows to access
+	  the temperature sensor and to control the fan.
+
+	  After loading this driver the BIOS is still in control of the fan.
+	  To let the kernel handle the fan, do:
+	  echo -n enabled > /sys/class/thermal/thermal_zone0/mode
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
index 0000000..dcfb8b2
--- /dev/null
+++ b/drivers/platform/x86/acerhdf.c
@@ -0,0 +1,533 @@
+/*
+ * acerhdf - A driver which monitors the temperature
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
+ *               - Matthew Garrett
+ *               - Borislav Petkov
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
+#define pr_fmt(fmt) "acerhdf: " fmt
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
+/*
+ * if you want the module to be started in kernel mode,
+ * define the following:
+ */
+#undef START_IN_KERNEL_MODE
+
+#define VERSION "0.5.3"
+
+/*
+ * According to the Atom N270 datasheet,
+ * (http://download.intel.com/design/processor/datashts/320032.pdf) the
+ * CPU's optimal operating limits denoted in junction temperature as
+ * measured by the on-die thermal monitor are within 0 <= Tj <= 90. So,
+ * assume 89°C is critical temperature.
+ */
+#define ACERHDF_TEMP_CRIT 89
+#define ACERHDF_FAN_AUTO 1
+#define ACERHDF_FAN_OFF 0
+
+/*
+ * No matter what value the user puts into the fanon variable, turn on the fan
+ * at 80 degree Celsius to prevent hardware damage
+ */
+#define ACERHDF_MAX_FANON 80
+
+/*
+ * Maximal interval between to temperature checks is 20 seconds, as the die
+ * can get hot really fast under heavy load
+ */
+#define ACERHDF_MAX_INTERVAL 20
+
+#define ACERHDF_ERROR -0xffff
+
+
+
+#ifdef START_IN_KERNEL_MODE
+static int kernelmode = 1;
+#else
+static int kernelmode;
+#endif
+
+static unsigned int interval = 10;
+static unsigned int fanon = 63;
+static unsigned int fanoff = 58;
+static unsigned int verbose;
+static unsigned int fanstate = ACERHDF_FAN_AUTO;
+static int disable_kernelmode;
+static int bios_version = -1;
+static char force_bios[16];
+static unsigned int prev_interval;
+struct thermal_zone_device *acerhdf_thz_dev;
+struct thermal_cooling_device *acerhdf_cool_dev;
+
+module_param(kernelmode, uint, 0);
+MODULE_PARM_DESC(kernelmode, "Kernel mode on / off");
+module_param(interval, uint, 0600);
+MODULE_PARM_DESC(interval, "Polling interval of temperature check");
+module_param(fanon, uint, 0600);
+MODULE_PARM_DESC(fanon, "Turn the fan on above this temperature");
+module_param(fanoff, uint, 0600);
+MODULE_PARM_DESC(fanoff, "Turn the fan off below this temperature");
+module_param(verbose, uint, 0600);
+MODULE_PARM_DESC(verbose, "Enable verbose dmesg output");
+module_param_string(force_bios, force_bios, 16, 0);
+MODULE_PARM_DESC(force_bios, "Force BIOS version and omit BIOS check");
+
+/* BIOS settings */
+struct bios_settings_t {
+	const char *vendor;
+	const char *version;
+	unsigned char fanreg;
+	unsigned char tempreg;
+	unsigned char cmd_off;
+	unsigned char cmd_auto;
+};
+
+/* Register addresses and values for different BIOS versions */
+static const struct bios_settings_t bios_settings[] = {
+	{"Acer", "v0.3109", 0x55, 0x58, 0x1f, 0x00},
+	{"Acer", "v0.3114", 0x55, 0x58, 0x1f, 0x00},
+	{"Acer", "v0.3301", 0x55, 0x58, 0xaf, 0x00},
+	{"Acer", "v0.3304", 0x55, 0x58, 0xaf, 0x00},
+	{"Acer", "v0.3305", 0x55, 0x58, 0xaf, 0x00},
+	{"Acer", "v0.3308", 0x55, 0x58, 0x21, 0x00},
+	{"Acer", "v0.3309", 0x55, 0x58, 0x21, 0x00},
+	{"Acer", "v0.3310", 0x55, 0x58, 0x21, 0x00},
+	{"Gateway", "v0.3103", 0x55, 0x58, 0x21, 0x00},
+	{"Packard Bell", "v0.3105", 0x55, 0x58, 0x21, 0x00},
+	{"", 0, 0, 0, 0, 0}
+};
+
+
+/* acer ec functions */
+static int acerhdf_get_temp(void)
+{
+	u8 temp;
+
+	/* read temperature */
+	if (!ec_read(bios_settings[bios_version].tempreg, &temp)) {
+		if (verbose)
+			pr_notice("temp %d\n", temp);
+		return temp;
+	}
+	return ACERHDF_ERROR;
+}
+
+static int acerhdf_get_fanstate(void)
+{
+	u8 fan;
+
+	if (!ec_read(bios_settings[bios_version].fanreg, &fan))
+		return (fan == bios_settings[bios_version].cmd_off) ?
+			ACERHDF_FAN_OFF : ACERHDF_FAN_AUTO;
+
+	return ACERHDF_ERROR;
+}
+
+static void acerhdf_change_fanstate(int state)
+{
+	unsigned char cmd;
+
+	if (verbose)
+		pr_notice("fan %s\n", (state == ACERHDF_FAN_AUTO) ?
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
+static void acerhdf_check_param(struct thermal_zone_device *thermal)
+{
+	if (fanon > ACERHDF_MAX_FANON) {
+		pr_err("fanon temperature too high, set to %d\n",
+				ACERHDF_MAX_FANON);
+		fanon = ACERHDF_MAX_FANON;
+	}
+	if (kernelmode && prev_interval != interval) {
+		if (interval > ACERHDF_MAX_INTERVAL) {
+			pr_err("interval too high, set to %d\n",
+					ACERHDF_MAX_INTERVAL);
+			interval = ACERHDF_MAX_INTERVAL;
+		}
+		if (verbose)
+			pr_notice("interval changed to: %d\n",
+					interval);
+		thermal->polling_delay = interval*1000;
+		prev_interval = interval;
+	}
+}
+
+/* thermal zone callback functions */
+static int acerhdf_get_ec_temp(struct thermal_zone_device *thermal,
+		unsigned long *t)
+{
+	int temp;
+
+	acerhdf_check_param(thermal);
+
+	temp = acerhdf_get_temp();
+	if (temp == ACERHDF_ERROR)
+		return -EINVAL;
+
+	*t = temp;
+	return 0;
+}
+
+static int acerhdf_bind(struct thermal_zone_device *thermal,
+		struct thermal_cooling_device *cdev)
+{
+	/* if the cooling device is the one from acerhdf bind it */
+	if (cdev != acerhdf_cool_dev)
+		return 0;
+
+	if (thermal_zone_bind_cooling_device(thermal, 0, cdev)) {
+		pr_err("error binding cooling dev\n");
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int acerhdf_unbind(struct thermal_zone_device *thermal,
+		struct thermal_cooling_device *cdev)
+{
+	if (cdev != acerhdf_cool_dev)
+		return 0;
+
+	if (thermal_zone_unbind_cooling_device(thermal, 0, cdev)) {
+		pr_err("acerhdf: error unbinding cooling dev\n");
+		return -EINVAL;
+	}
+	return 0;
+}
+
+/*  current operation mode - enabled / disabled */
+static int acerhdf_get_mode(struct thermal_zone_device *thermal,
+		enum thermal_device_mode *mode)
+{
+	if (verbose)
+		pr_notice("kernel mode %d\n", kernelmode);
+
+	*mode = (kernelmode) ? THERMAL_DEVICE_ENABLED :
+		THERMAL_DEVICE_DISABLED;
+
+	return 0;
+}
+
+/*
+ * set operation mode;
+ * enabled: the thermal layer of the kernel takes care about
+ *          the temperature and the fan.
+ * disabled: the BIOS takes control of the fan.
+ */
+static int acerhdf_set_mode(struct thermal_zone_device *thermal,
+		enum thermal_device_mode mode)
+{
+	if (mode == THERMAL_DEVICE_DISABLED) {
+		pr_notice("kernel mode OFF\n");
+		thermal->polling_delay = 0;
+		thermal_zone_device_update(thermal);
+		acerhdf_change_fanstate(ACERHDF_FAN_AUTO);
+
+		/*
+		 * let the thermal layer disable kernel mode. This ensures that
+		 * the thermal layer doesn't switch off the fan again
+		 */
+		disable_kernelmode = 1;
+	} else {
+		kernelmode = 1;
+		pr_notice("kernel mode ON\n");
+		thermal->polling_delay = interval*1000;
+		thermal_zone_device_update(thermal);
+	}
+	return 0;
+}
+
+static int acerhdf_get_trip_type(struct thermal_zone_device *thermal,
+		int trip, enum thermal_trip_type *type)
+{
+	if (trip == 0)
+		*type = THERMAL_TRIP_ACTIVE;
+	return 0;
+}
+
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
+/*
+ * cooling device callback functions
+ * get maximal fan cooling state
+ */
+static int acerhdf_get_max_state(struct thermal_cooling_device *cdev,
+		unsigned long *state)
+{
+	*state = 1;
+	return 0;
+}
+
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
+	int cur_state;
+
+	/*
+	 * let the thermal layer disable kernel mode. This ensures that
+	 * the thermal layer doesn't switch off the fan again
+	 */
+	if (disable_kernelmode) {
+		acerhdf_change_fanstate(ACERHDF_FAN_AUTO);
+		disable_kernelmode = 0;
+		kernelmode = 0;
+		return 0;
+	}
+
+	if (!kernelmode) {
+		pr_err("changing fan state is not allowed\n");
+		return -EINVAL;
+	}
+
+	cur_state = acerhdf_get_fanstate();
+
+	/*
+	 * if reading the fan's state returns unexpected value, there's a
+	 * problem with the ec register. -> let the BIOS take control of
+	 * the fan to prevent hardware damage
+	 */
+	if (cur_state != fanstate) {
+		pr_err("failed reading fan state, "
+				"disabling kernelmode.\n");
+
+		if (verbose)
+			pr_err("read state: %d expected state: %d\n",
+					cur_state, fanstate);
+
+		acerhdf_change_fanstate(ACERHDF_FAN_AUTO);
+		disable_kernelmode = 1;
+	}
+
+	if (state == 0) {
+		/* turn fan off only if below fanoff temperature */
+		if ((cur_state == ACERHDF_FAN_AUTO) &&
+				(acerhdf_get_temp() < fanoff))
+			acerhdf_change_fanstate(ACERHDF_FAN_OFF);
+	} else {
+		if (cur_state == ACERHDF_FAN_OFF)
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
+/* check hardware */
+static int acerhdf_check_hardware(void)
+{
+	int i;
+	char const *vendor;
+	char const *version;
+	char const *release;
+	char const *product;
+
+	/* get BIOS data */
+	vendor  = dmi_get_system_info(DMI_SYS_VENDOR);
+	version = dmi_get_system_info(DMI_BIOS_VERSION);
+	release = dmi_get_system_info(DMI_BIOS_DATE);
+	product = dmi_get_system_info(DMI_PRODUCT_NAME);
+
+
+	if (verbose)
+		pr_notice("version %s\n", VERSION);
+   pr_notice("found BIOS vendor: \"%s\" version: \"%s\"\n",
+			vendor, version);
+	if (verbose)
+		pr_notice("BIOS release: \"%s\" product: \"%s\"\n",
+				release, product);
+
+	if (!force_bios[0]) {
+		/* check if product is a AO - Aspire One */
+		if (strncmp(product, "AO", 2)) {
+			pr_err("no Aspire One hardware found\n");
+			return ACERHDF_ERROR;
+		}
+	} else {
+		pr_notice("acerhdf: BIOS version: %s forced\n", version);
+		version = force_bios;
+		kernelmode = 0;
+	}
+
+	/*
+	 * if started with kernel mode off, prevent the kernel from switching
+	 * off the fan
+	 */
+	if (!kernelmode) {
+		disable_kernelmode = 1;
+		pr_notice("Fan control off, to enable:\n");
+		pr_notice("echo -n \"enabled\" > "
+			"/sys/class/thermal/thermal_zone0/mode\n");
+		pr_notice("http://piie.net/files/acerhdf_README.txt\n");
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
+		pr_err("cannot find BIOS version\n");
+		return ACERHDF_ERROR;
+	}
+	return 0;
+}
+
+static int acerhdf_register_thermal(void)
+{
+	acerhdf_cool_dev = thermal_cooling_device_register("acerhdf-fan", NULL,
+			&acerhdf_cooling_ops);
+	if (IS_ERR(acerhdf_cool_dev))
+		return ACERHDF_ERROR;
+
+	acerhdf_thz_dev = thermal_zone_device_register("acerhdf", 1,
+			NULL, &acerhdf_device_ops, 0, 0, 0,
+			(kernelmode) ? interval*1000 : 0);
+	if (IS_ERR(acerhdf_thz_dev))
+		return ACERHDF_ERROR;
+
+	return 0;
+}
+
+static void acerhdf_unregister_thermal(void)
+{
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
+/* kernel module init / exit functions */
+static int __init acerhdf_init(void)
+{
+	if (acerhdf_check_hardware() == ACERHDF_ERROR)
+		goto err;
+
+	if (acerhdf_register_thermal() == ACERHDF_ERROR)
+		goto err_unreg;
+
+	return 0;
+
+err_unreg:
+	acerhdf_unregister_thermal();
+
+err:
+	return -ENODEV;
+}
+
+static void __exit acerhdf_exit(void)
+{
+	acerhdf_change_fanstate(ACERHDF_FAN_AUTO);
+
+	acerhdf_unregister_thermal();
+}
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Peter Feuerer");
+MODULE_DESCRIPTION("Aspire One temperature and fan driver");
+MODULE_ALIAS("dmi:*:*Acer*:*:");
+MODULE_ALIAS("dmi:*:*Gateway*:*:");
+MODULE_ALIAS("dmi:*:*Packard Bell*:*:");
+
+module_init(acerhdf_init);
+module_exit(acerhdf_exit);
