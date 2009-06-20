Return-Path: <linux-kernel-owner+w=401wt.eu-S1757482AbZFTSiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482AbZFTSiz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 14:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754518AbZFTSis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 14:38:48 -0400
Received: from smtprelay10.ispgateway.de ([80.67.31.33]:47805 "EHLO
	smtprelay10.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753451AbZFTSir convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 14:38:47 -0400
Date: Sat, 20 Jun 2009 20:38:46 +0200
From: Peter Feuerer <peter@piie.net>
To: Borislav Petkov <petkovbb@googlemail.com>
Cc: Andreas Mohr <andi@lisas.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Acer Aspire One fan control, simplified and scrubbed
Message-Id: <20090620203846.bbe19d0d.peter@piie.net>
In-Reply-To: <20090620170835.GA3295@liondog.tnic>
References: <20090620170835.GA3295@liondog.tnic>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Df-Sender: 650477
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,

thanks for the cleanup!

On Sat, 20 Jun 2009 19:08:35 +0200
Borislav Petkov <petkovbb@googlemail.com> wrote:

> Hi guys,
> 
> I went and gave the driver a bunch of scrubbing today. Lots of
> cleanups, especially all those redundant kernelmode variables are gone,
> conversion of error handling paths to kernel coding style, proper
> reading of temperature and fanstate with error handling and lots of
> other simplifications. I've tested it here on my machine, suspend/resume
> works.
> 
> Please give it a good testing and let me know if I missed something.
> Thanks.

You removed the feature of controlling the fan from userspace, while the
driver is running in kernelmode=off!
( echo 0 > /sys/class/thermal/thermal_zone0/cdev0/cur_state calls also the
acerhdf_set_cur_state function )

But I'm fine with this.
 
There were some small issues, I fixed them and attached new patch.
Everything is working fine for me so far, suspend/resume too.

regards,
	peter

--

Acerhdf is a driver for Acer Aspire One netbooks. It allows
to access the temperature sensor and to control the fan.

Peter:

 - fixed bios table terminator Version string ( 0 to "" )
 - added acerhdf_enable_kernelmode
 - modified acerhdf_revert_to_bios_mode to disable polling
 - modified acerhdf_get_temp to omit the pr_notice (temperature
   should not be printed out in verbose mode, when called from
   acerhdf_set_cur_state)

Signed-off-by: Peter Feuerer <peter@piie.net>
Signed-off-by: Andreas Mohr <andi@lisas.de>
Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
diff --git a/MAINTAINERS b/MAINTAINERS
index dc226e7..aea0ec2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -230,6 +230,13 @@ L:	linux-acenic@sunsite.dk
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
index c682ac5..5613483 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -34,6 +34,23 @@ config ACER_WMI
 	  If you have an ACPI-WMI compatible Acer/ Wistron laptop, say Y or M
 	  here.
 
+config ACERHDF
+	tristate "Acer Aspire One temperature and fan driver"
+	depends on THERMAL && THERMAL_HWMON && ACPI
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
index 0000000..1e631cc
--- /dev/null
+++ b/drivers/platform/x86/acerhdf.c
@@ -0,0 +1,602 @@
+/*
+ * acerhdf - A driver which monitors the temperature
+ *           of the aspire one netbook, turns on/off the fan
+ *           as soon as the upper/lower threshold is reached.
+ *
+ * (C) 2009 - Peter Feuerer     peter (a) piie.net
+ *                              http://piie.net
+ *     2009 Borislav Petkov <petkovbb@gmail.com>
+ *
+ * Inspired by and many thanks to:
+ *  o acerfand   - Rachel Greenham
+ *  o acer_ec.pl - Michael Kurz     michi.kurz (at) googlemail.com
+ *               - Petr Tomasek     tomasek (#) etf,cuni,cz
+ *               - Carlos Corbacho  cathectic (at) gmail.com
+ *  o lkml       - Matthew Garrett
+ *               - Borislav Petkov
+ *               - Andreas Mohr
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
+ * The driver is started with "kernel mode off" by default. That means, the BIOS
+ * is still in control of the fan. In this mode the driver allows to read the
+ * temperature of the cpu and a userspace tool may take over control of the fan.
+ * If the driver is switched to "kernel mode" (e.g. via module parameter) the
+ * driver is in full control of the fan. If you want the module to be started in
+ * kernel mode by default, define the following:
+ */
+#undef START_IN_KERNEL_MODE
+
+#define DRV_VER "0.5.12"
+
+/*
+ * According to the Atom N270 datasheet,
+ * (http://download.intel.com/design/processor/datashts/320032.pdf) the
+ * CPU's optimal operating limits denoted in junction temperature as
+ * measured by the on-die thermal monitor are within 0 <= Tj <= 90. So,
+ * assume 89°C is critical temperature.
+ */
+#define ACERHDF_TEMP_CRIT 89
+#define ACERHDF_FAN_OFF 0
+#define ACERHDF_FAN_AUTO 1
+
+/*
+ * No matter what value the user puts into the fanon variable, turn on the fan
+ * at 80 degree Celsius to prevent hardware damage
+ */
+#define ACERHDF_MAX_FANON 80
+
+/*
+ * Maximum interval between two temperature checks is 15 seconds, as the die
+ * can get hot really fast under heavy load (plus we shouldn't forget about
+ * possible impact of _external_ aggressive sources such as heaters, sun etc.)
+ */
+#define ACERHDF_MAX_INTERVAL 15
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
+static char force_bios[16];
+static unsigned int prev_interval;
+struct thermal_zone_device *thz_dev;
+struct thermal_cooling_device *cl_dev;
+struct platform_device *acerhdf_dev;
+
+module_param(kernelmode, uint, 0);
+MODULE_PARM_DESC(kernelmode, "Kernel mode fan control on / off");
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
+	unsigned char fancmd[2]; /* fan off and auto commands */
+};
+
+/* Register addresses and values for different BIOS versions */
+static const struct bios_settings_t bios_tbl[] = {
+	{"Acer", "v0.3109", 0x55, 0x58, {0x1f, 0x00} },
+	{"Acer", "v0.3114", 0x55, 0x58, {0x1f, 0x00} },
+	{"Acer", "v0.3301", 0x55, 0x58, {0xaf, 0x00} },
+	{"Acer", "v0.3304", 0x55, 0x58, {0xaf, 0x00} },
+	{"Acer", "v0.3305", 0x55, 0x58, {0xaf, 0x00} },
+	{"Acer", "v0.3308", 0x55, 0x58, {0x21, 0x00} },
+	{"Acer", "v0.3309", 0x55, 0x58, {0x21, 0x00} },
+	{"Acer", "v0.3310", 0x55, 0x58, {0x21, 0x00} },
+	{"Gateway", "v0.3103", 0x55, 0x58, {0x21, 0x00} },
+	{"Packard Bell", "v0.3105", 0x55, 0x58, {0x21, 0x00} },
+	{"", "", 0, 0, {0, 0} }
+};
+
+static const struct bios_settings_t *bios_cfg __read_mostly;
+
+
+static int acerhdf_get_temp(int *temp, int report)
+{
+	u8 read_temp;
+
+	if (ec_read(bios_cfg->tempreg, &read_temp))
+		return -EINVAL;
+
+	if (verbose && report)
+		pr_notice("temp %d\n", read_temp);
+	*temp = read_temp;
+
+	return 0;
+}
+
+static int acerhdf_get_fanstate(int *state)
+{
+	u8 fan;
+	bool tmp;
+
+	if (ec_read(bios_cfg->fanreg, &fan))
+		return -EINVAL;
+
+	tmp = (fan == bios_cfg->fancmd[ACERHDF_FAN_OFF]);
+	*state = tmp ? ACERHDF_FAN_OFF : ACERHDF_FAN_AUTO;
+
+	return 0;
+}
+
+static void acerhdf_change_fanstate(int state)
+{
+	unsigned char cmd;
+
+	if (verbose)
+		pr_notice("fan %s\n", (state == ACERHDF_FAN_OFF) ?
+				"OFF" : "ON");
+
+	if ((state != ACERHDF_FAN_OFF) && (state != ACERHDF_FAN_AUTO)) {
+		pr_err("invalid fan state %d requested, setting to auto!\n",
+			state);
+		state = ACERHDF_FAN_AUTO;
+	}
+
+	cmd = bios_cfg->fancmd[state];
+	fanstate = state;
+
+	ec_write(bios_cfg->fanreg, cmd);
+}
+
+static void acerhdf_check_param(struct thermal_zone_device *thermal)
+{
+	if (fanon > ACERHDF_MAX_FANON) {
+		pr_err("fanon temperature too high, set to %d\n",
+				ACERHDF_MAX_FANON);
+		fanon = ACERHDF_MAX_FANON;
+	}
+
+	if (kernelmode && prev_interval != interval) {
+		if (interval > ACERHDF_MAX_INTERVAL) {
+			pr_err("interval too high, set to %d\n",
+				ACERHDF_MAX_INTERVAL);
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
+/*
+ * This is the thermal zone callback which does the delayed polling of the fan
+ * state. We do check /sysfs-originating settings here in acerhdf_check_param()
+ * as late as the polling interval is since we can't do that in the respective
+ * accessors of the module parameters.
+ */
+static int acerhdf_get_ec_temp(struct thermal_zone_device *thermal,
+			       unsigned long *t)
+{
+	int temp, err = 0;
+
+	acerhdf_check_param(thermal);
+
+	err = acerhdf_get_temp(&temp, 1);
+	if (err)
+		return err;
+
+	*t = temp;
+	return 0;
+}
+
+static int acerhdf_bind(struct thermal_zone_device *thermal,
+			struct thermal_cooling_device *cdev)
+{
+	/* if the cooling device is the one from acerhdf bind it */
+	if (cdev != cl_dev)
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
+			  struct thermal_cooling_device *cdev)
+{
+	if (cdev != cl_dev)
+		return 0;
+
+	if (thermal_zone_unbind_cooling_device(thermal, 0, cdev)) {
+		pr_err("error unbinding cooling dev\n");
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static inline void acerhdf_revert_to_bios_mode(void)
+{
+	acerhdf_change_fanstate(ACERHDF_FAN_AUTO);
+	kernelmode = 0;
+	if (thz_dev)
+		thz_dev->polling_delay = 0;
+	pr_notice("kernel mode fan control OFF\n");
+}
+static inline void acerhdf_enable_kernelmode(void)
+{
+	kernelmode = 1;
+
+	thz_dev->polling_delay = interval*1000;
+	thermal_zone_device_update(thz_dev);
+	pr_notice("kernel mode fan control ON\n");
+}
+
+static int acerhdf_get_mode(struct thermal_zone_device *thermal,
+			    enum thermal_device_mode *mode)
+{
+	if (verbose)
+		pr_notice("kernel mode fan control %d\n", kernelmode);
+
+	*mode = (kernelmode) ? THERMAL_DEVICE_ENABLED
+			     : THERMAL_DEVICE_DISABLED;
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
+			    enum thermal_device_mode mode)
+{
+	if (mode == THERMAL_DEVICE_DISABLED && kernelmode)
+		acerhdf_revert_to_bios_mode();
+	else if (mode == THERMAL_DEVICE_ENABLED && !kernelmode)
+		acerhdf_enable_kernelmode();
+
+	return 0;
+}
+
+static int acerhdf_get_trip_type(struct thermal_zone_device *thermal, int trip,
+				 enum thermal_trip_type *type)
+{
+	if (trip == 0)
+		*type = THERMAL_TRIP_ACTIVE;
+
+	return 0;
+}
+
+static int acerhdf_get_trip_temp(struct thermal_zone_device *thermal, int trip,
+				 unsigned long *temp)
+{
+	if (trip == 0)
+		*temp = fanon;
+
+	return 0;
+}
+
+static int acerhdf_get_crit_temp(struct thermal_zone_device *thermal,
+				 unsigned long *temperature)
+{
+	*temperature = ACERHDF_TEMP_CRIT;
+	return 0;
+}
+
+/* bind callback functions to thermalzone */
+struct thermal_zone_device_ops acerhdf_dev_ops = {
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
+				 unsigned long *state)
+{
+	*state = 1;
+
+	return 0;
+}
+
+static int acerhdf_get_cur_state(struct thermal_cooling_device *cdev,
+				 unsigned long *state)
+{
+	int err = 0, tmp;
+
+	err = acerhdf_get_fanstate(&tmp);
+	if (err)
+		return err;
+
+	*state = (tmp == ACERHDF_FAN_AUTO) ? 1 : 0;
+	return 0;
+}
+
+/* change current fan state - is overwritten when running in kernel mode */
+static int acerhdf_set_cur_state(struct thermal_cooling_device *cdev,
+				 unsigned long state)
+{
+	int cur_temp, cur_state, err = 0;
+
+	if (!kernelmode)
+		return 0;
+
+	err = acerhdf_get_temp(&cur_temp, 0);
+	if (err) {
+		pr_err("error reading temperature, hand off control to BIOS\n");
+		goto err_out;
+	}
+
+	err = acerhdf_get_fanstate(&cur_state);
+	if (err) {
+		pr_err("error reading fan state, hand off control to BIOS\n");
+		goto err_out;
+	}
+
+	if (state == 0) {
+		/* turn fan off only if below fanoff temperature */
+		if ((cur_state == ACERHDF_FAN_AUTO) &&
+		    (cur_temp < fanoff))
+			acerhdf_change_fanstate(ACERHDF_FAN_OFF);
+	} else {
+		if (cur_state == ACERHDF_FAN_OFF)
+			acerhdf_change_fanstate(ACERHDF_FAN_AUTO);
+	}
+	return 0;
+
+err_out:
+	acerhdf_revert_to_bios_mode();
+	return -EINVAL;
+}
+
+/* bind fan callbacks to fan device */
+struct thermal_cooling_device_ops acerhdf_cooling_ops = {
+	.get_max_state = acerhdf_get_max_state,
+	.get_cur_state = acerhdf_get_cur_state,
+	.set_cur_state = acerhdf_set_cur_state,
+};
+
+/* suspend / resume functionality */
+static int acerhdf_suspend(struct platform_device *dev,	pm_message_t state)
+{
+	if (kernelmode)
+		acerhdf_change_fanstate(ACERHDF_FAN_AUTO);
+
+	if (verbose)
+		pr_notice("going suspend\n");
+
+	return 0;
+}
+
+static int acerhdf_resume(struct platform_device *device)
+{
+	if (verbose)
+		pr_notice("resuming\n");
+
+	return 0;
+}
+
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
+struct platform_driver acerhdf_drv = {
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
+
+/* check hardware */
+static int acerhdf_check_hardware(void)
+{
+	char const *vendor, *version, *product;
+	int i;
+
+	/* get BIOS data */
+	vendor  = dmi_get_system_info(DMI_SYS_VENDOR);
+	version = dmi_get_system_info(DMI_BIOS_VERSION);
+	product = dmi_get_system_info(DMI_PRODUCT_NAME);
+
+	pr_info("Acer Aspire One Fan driver, v.%s\n", DRV_VER);
+
+	if (!force_bios[0]) {
+		if (strncmp(product, "AO", 2)) {
+			pr_err("no Aspire One hardware found\n");
+			return -EINVAL;
+		}
+	} else {
+		pr_info("forcing BIOS version: %s\n", version);
+		version = force_bios;
+		kernelmode = 0;
+	}
+
+	if (verbose)
+		pr_info("BIOS info: %s %s, product: %s\n",
+			vendor, version, product);
+
+	/* search BIOS version and vendor in BIOS settings table */
+	for (i = 0; bios_tbl[i].version[0]; i++) {
+		if (!strcmp(bios_tbl[i].vendor, vendor) &&
+		    !strcmp(bios_tbl[i].version, version)) {
+			bios_cfg = &bios_tbl[i];
+			break;
+		}
+	}
+
+	if (!bios_cfg) {
+		pr_err("unknown (unsupported) BIOS version %s/%s, "
+			"please report, aborting!\n", vendor, version);
+		return -EINVAL;
+	}
+
+	/*
+	 * if started with kernel mode off, prevent the kernel from switching
+	 * off the fan
+	 */
+	if (!kernelmode) {
+		pr_notice("Fan control off, to enable do:\n");
+		pr_notice("echo -n \"enabled\" > "
+			"/sys/class/thermal/thermal_zone0/mode\n");
+	}
+
+	return 0;
+}
+
+static int acerhdf_register_platform(void)
+{
+	int err = 0;
+
+	err = platform_driver_register(&acerhdf_drv);
+	if (err)
+		return err;
+
+	acerhdf_dev = platform_device_alloc("acerhdf", -1);
+	platform_device_add(acerhdf_dev);
+
+	return 0;
+}
+
+static void acerhdf_unregister_platform(void)
+{
+	if (!acerhdf_dev)
+		return;
+
+	platform_device_del(acerhdf_dev);
+	platform_driver_unregister(&acerhdf_drv);
+}
+
+static int acerhdf_register_thermal(void)
+{
+	cl_dev = thermal_cooling_device_register("acerhdf-fan", NULL,
+						 &acerhdf_cooling_ops);
+
+	if (IS_ERR(cl_dev))
+		return -EINVAL;
+
+	thz_dev = thermal_zone_device_register("acerhdf", 1, NULL,
+					      &acerhdf_dev_ops, 0, 0, 0,
+					      (kernelmode) ? interval*1000 : 0);
+	if (IS_ERR(thz_dev))
+		return -EINVAL;
+
+	return 0;
+}
+
+static void acerhdf_unregister_thermal(void)
+{
+	if (cl_dev) {
+		thermal_cooling_device_unregister(cl_dev);
+		cl_dev = NULL;
+	}
+
+	if (thz_dev) {
+		thermal_zone_device_unregister(thz_dev);
+		thz_dev = NULL;
+	}
+}
+
+/* kernel module init / exit functions */
+static int __init acerhdf_init(void)
+{
+	int err = 0;
+
+	err = acerhdf_check_hardware();
+	if (err)
+		goto out_err;
+
+	err = acerhdf_register_platform();
+	if (err)
+		goto err_unreg;
+
+	err = acerhdf_register_thermal();
+	if (err)
+		goto err_unreg;
+
+	return 0;
+
+err_unreg:
+	acerhdf_unregister_thermal();
+	acerhdf_unregister_platform();
+
+out_err:
+	return -ENODEV;
+}
+
+static void __exit acerhdf_exit(void)
+{
+	acerhdf_change_fanstate(ACERHDF_FAN_AUTO);
+	acerhdf_unregister_thermal();
+	acerhdf_unregister_platform();
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
