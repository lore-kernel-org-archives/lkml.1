Return-Path: <linux-kernel-owner+w=401wt.eu-S1761273AbZCZWWF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761273AbZCZWWF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 18:22:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757498AbZCZWVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 18:21:52 -0400
Received: from smtprelay08.ispgateway.de ([80.67.29.8]:38571 "EHLO
	smtprelay08.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757393AbZCZWVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 18:21:50 -0400
References: <cone.1234471033.988571.5384.1000@mentalhome> <20090213134024.GA26549@srcf.ucam.org> <cone.1234551556.57236.4642.1000@onepiie> <20090213191815.GB1379@srcf.ucam.org> <cone.1235761090.678709.5345.1000@onepiie> <1235763653.24506.6.camel@localhost> <cone.1235847508.919525.5537.1000@onepiie> <20090301143851.GA11852@srcf.ucam.org>
Message-ID: <cone.1238106129.570865.4879.1000@onepiie>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <peter@piie.net>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Joe Perches <joe@perches.com>, LKML <linux-kernel@vger.kernel.org>,
       lenb@kernel.org
Subject: Re: [PATCH] acerhdf: Acer Aspire One fan control
Date: Thu, 26 Mar 2009 23:22:09 +0100
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
X-Df-Sender: 404094
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew, Hi Len,

I've been improving and testing the acerhdf module the last few days and 
here's a new patch. Thank you Matthew for your hints!

Matthew Garrett writes:
> *) It looks like the patch has ended up linewrapped - it probably won't 
> apply as a result.

Hope this is fixed now, as I'm now using git diff to create the patch.

> *) x86 specific drivers are mostly moving from drivers/misc to 
> drivers/platform/x86.

Done.

> *) It should probably have a DMI modalias to allow it to autoload on 
> appropriate hardware.

Done.

> *) You have user and kernel modes - it should probably also have a bios 
> mode that just leaves fan control in the same state it would be if the 
> driver had never been loaded, and this should be the default.

It's now started in user mode by default. The bios cares in usermode about 
the fan unless a userspace program does.

> *) The thermal code has been moved from ACPI into the generic thermal 
> layer for 2.6.30. If you register thermal trip points and indicate that 
> you require polling you should be able to get rid of the kernel thread 
> in your driver and leave that up to the kernel.

Didn't find anything about polling in the drivers/thermal/ yet, but I'll 
keep on looking for that.

> Once that's all dealt with you should submit the patch to linux-kernel 
> and Cc: Len Brown who maintains drivers/platform/x86. Include a 
> description and a signed-off-by: line (and an entry in the MAINTAINERS 
> file) and it should get merged.

Here we go:

Acerhdf is a driver for Acer Aspire One netbooks. It allows to access
the temperature sensor and to control the fan. 

Signed-off-by: Peter Feuerer <peter@piie.net>

diff --git a/MAINTAINERS b/MAINTAINERS
index 5d460c9..ed823bc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -189,6 +189,12 @@ M:	jes@trained-monkey.org
 L:	linux-acenic@sunsite.dk
 S:	Maintained
 
+ACER ASPIRE ONE TEMPERATURE AND FAN DRIVER
+P:	Peter Feuerer
+M:	peter@piie.net
+W:	http://piie.net/?section=acerhdf
+S:	Maintained
+
 ACER WMI LAPTOP EXTRAS
 P:	Carlos Corbacho
 M:	carlos@strangeworlds.co.uk
diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 3608081..4bb04aa 100644
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
index e290651..01e9353 100644
--- a/drivers/platform/x86/Makefile
+++ b/drivers/platform/x86/Makefile
@@ -8,6 +8,7 @@ obj-$(CONFIG_MSI_LAPTOP)	+= msi-laptop.o
 obj-$(CONFIG_COMPAL_LAPTOP)	+= compal-laptop.o
 obj-$(CONFIG_DELL_LAPTOP)	+= dell-laptop.o
 obj-$(CONFIG_ACER_WMI)		+= acer-wmi.o
+obj-$(CONFIG_ACERHDF)		+= acerhdf.o
 obj-$(CONFIG_HP_WMI)		+= hp-wmi.o
 obj-$(CONFIG_TC1100_WMI)	+= tc1100-wmi.o
 obj-$(CONFIG_SONY_LAPTOP)	+= sony-laptop.o
diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
new file mode 100644
index 0000000..63e7f1f
--- /dev/null
+++ b/drivers/platform/x86/acerhdf.c
@@ -0,0 +1,646 @@
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
+#include <linux/kthread.h>
+
+#define VERSION "0.4.2"
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Peter Feuerer");
+MODULE_DESCRIPTION("Aspire One temperature and fan driver");
+MODULE_ALIAS("dmi:*:*Acer*:*:");
+MODULE_ALIAS("dmi:*:*Gateway*:*:");
+MODULE_ALIAS("dmi:*:*Packard Bell*:*:");
+
+/* thread handling variables / funktions */
+static struct task_struct *thread;
+static struct pid *thread_pid;
+static wait_queue_head_t wq;
+static DECLARE_COMPLETION(on_exit);
+static int acerhdf_thread(void *data);
+
+/* global variables */
+static int interval = 10;
+static int fanon = 67;
+static int fanoff = 62;
+static int verbose;
+static int kernelmode = 0;
+static int fanstate = 1;
+static int bios_version = -1;
+static char force_bios[16];
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
+	{"Acer", "v0.3308", 0x55, 0x58, 0xaf, 0x00, 0xaf},
+	{"Acer", "v0.3309", 0x55, 0x58, 0x21, 0x00, 0x21},
+	{"Gateway", "v0.3103", 0x55, 0x58, 0x21, 0x00, 0x21},
+	{"Packard Bell", "v0.3105", 0x55, 0x58, 0x21, 0x00, 0x21},
+	{"", 0, 0, 0, 0, 0}
+};
+
+
+/* start kthread */
+static int acerhdf_thread_start(void)
+{
+	thread = kthread_run(acerhdf_thread, NULL, "acerhdf");
+	if (IS_ERR(thread))
+		return -1;
+	return 0;
+}
+
+
+/* acer ec functions */
+/**********************************************************************/
+/* switch on/off the fan */
+static void change_fanstate(int state)
+{
+	if (verbose)
+		printk(KERN_NOTICE "acerhdf: fan %s\n", state ? "ON" : "OFF");
+
+	ec_write(bios_settings[bios_version].fanreg,
+			state ? bios_settings[bios_version].cmd_auto :
+			bios_settings[bios_version].cmd_off);
+}
+
+/* thread to monitor the temperature and control the fan */
+static int acerhdf_thread(void *data)
+{
+	unsigned long timeout;
+	u8 temp = 0;
+	u8 last_temp = 0;
+	int unchanged_cnt = 0;
+
+	fanstate = 1;
+	daemonize("acerhdf");
+	allow_signal(SIGTERM);
+	thread_pid = task_pid(current);
+	for (;;) {
+		if (!ec_read(bios_settings[bios_version].tempreg, &temp)) {
+			/* print temperature in verbose mode */
+			if (verbose)
+				printk(KERN_NOTICE "acerhdf: Temperature is: %d\n",
+					temp);
+
+			/* if temperature is greater than fanon,
+			 * switch on fan */
+			if (temp >= fanon && fanstate == 0) {
+				change_fanstate(1);
+				fanstate = 1;
+			}
+			/* if temperature is less than fanoff,
+			 * switch off fan */
+			else if (temp < fanoff && fanstate == 1) {
+				change_fanstate(0);
+				fanstate = 0;
+			}
+		}
+
+		/* sleep interval seconds */
+		timeout = HZ*interval;
+		timeout = wait_event_interruptible_timeout(wq,
+				(timeout == 0), timeout);
+
+		/* if wait was interrupted by SIGTERM, end thread */
+		if (timeout == -ERESTARTSYS) {
+			printk(KERN_NOTICE "acerhdf: ending kernelmode\n");
+			break;
+		}
+
+		/* check if read temperature is reasonable. If not,
+		 * change to user mode and turn on fan to save the
+		 * hardware */
+		if (last_temp == temp && temp < 30) {
+			if (unchanged_cnt++ >= 10) {
+				printk(KERN_ERR
+					"acerhdf: cannot read temperature:\n");
+				printk(KERN_ERR
+					"acerhdf: switching to user mode\n");
+				kernelmode = 0;
+				break;
+			}
+		} else
+			unchanged_cnt = 0;
+
+		last_temp = temp;
+	}
+	/* turn on fan before ending the thread */
+	change_fanstate(1);
+	thread_pid = NULL;
+	complete_and_exit(&on_exit, 0);
+}
+
+/* thermal zone callback functions */
+/**********************************************************************/
+static int get_ec_temp(struct thermal_zone_device *thermal, char *buf)
+{
+	u8 temp;
+	/* return temperature */
+	if (!ec_read(bios_settings[bios_version].tempreg, &temp))
+		return sprintf(buf, "%d\n", temp);
+
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
+		if (thermal_zone_bind_cooling_device(thermal, 1, cdev)) {
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
+		if (thermal_zone_unbind_cooling_device(thermal, 1, cdev)) {
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
+		char *buf)
+{
+	if (!kernelmode)
+		return sprintf(buf, "user\n");
+
+	else
+		return sprintf(buf, "kernel\n");
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
+		const char *buf)
+{
+	/* set mode to user mode */
+	if (!strncmp(buf, "user", 4)) {
+		if (verbose)
+			printk(KERN_NOTICE "acerhdf: set to usermode\n");
+
+		/* send SIGTERM to thread and wait until thread died */
+		if (thread_pid)
+			kill_pid(thread_pid, SIGTERM, 1);
+
+		wait_for_completion(&on_exit);
+		kernelmode = 0;
+		return 0;
+	}
+	/* set to kernel mode */
+	else if (!strncmp(buf, "kernel", 6)) {
+		/* start acerhdf_thread */
+		if (!kernelmode) {
+			if (acerhdf_thread_start())
+				return -EIO;
+		}
+
+		if (verbose)
+			printk(KERN_NOTICE "acerhdf: set to kernelmode\n");
+
+		kernelmode = 1;
+		return 0;
+	}
+	return -EINVAL;
+}
+
+/* print the name of the trip point */
+static int get_trip_type(struct thermal_zone_device *thermal,
+		int trip, char *buf)
+{
+	if (trip == 0)
+		return sprintf(buf, "fanoff\n");
+
+	else if (trip == 1)
+		return sprintf(buf, "fanon\n");
+
+	return 0;
+}
+
+/* print the temperature at which the trip point gets active */
+static int get_trip_temp(struct thermal_zone_device *thermal,
+		int trip, char *buf)
+{
+	if (trip == 0)
+		return sprintf(buf, "%d\n", fanoff);
+
+	else if (trip == 1)
+		return sprintf(buf, "%d\n", fanon);
+
+	return 0;
+}
+
+static int get_crit_temp(struct thermal_zone_device *thermal,
+		unsigned long *temperature)
+{
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
+static int get_max_state(struct thermal_cooling_device *cdev, char *buf)
+{
+	return sprintf(buf, "1\n");
+}
+
+/* print current fan state */
+static int get_cur_state(struct thermal_cooling_device *cdev, char *buf)
+{
+	u8 fan;
+	if (!ec_read(bios_settings[bios_version].fanreg, &fan)) {
+		return sprintf(buf, "%d\n",
+				(fan == bios_settings[bios_version].cmd_auto));
+	}
+	return 0;
+}
+
+/* change current fan state - is overwritten when running in kernel mode */
+static int set_cur_state(struct thermal_cooling_device *cdev,
+		unsigned int state)
+{
+	if (kernelmode) {
+		printk(KERN_ERR
+			"acerhdf: cannot change fanstate in kernelmode\n");
+		return -EINVAL;
+	}
+
+	change_fanstate(state);
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
+	/* send SIGTERM to thread and wait until thread died */
+	if (thread_pid)
+		kill_pid(thread_pid, SIGTERM, 1);
+
+	wait_for_completion(&on_exit);
+	return 0;
+}
+
+/* wake up */
+static int acerhdf_resume(struct platform_device *device)
+{
+	if (verbose)
+		printk(KERN_NOTICE "acerhdf: resuming\n");
+	if (kernelmode) {
+		if (acerhdf_thread_start())
+			return -EIO;
+	}
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
+		printk(KERN_NOTICE
+			"acerhdf: kernelmode disabled\n");
+		printk(KERN_NOTICE
+			"acerhdf: for more information read:\n");
+		printk(KERN_NOTICE
+			"acerhdf: http://piie.net/files/acerhdf_README.txt\n");
+		version = force_bios;
+		kernelmode = 0;
+	}
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
+	acerhdf_thz_dev = thermal_zone_device_register("acerhdf", 2,
+			NULL, &acerhdf_device_ops);
+	if (IS_ERR(acerhdf_thz_dev)) {
+		ret_val = -ENODEV;
+		goto EXIT_COOL_UNREG;
+	}
+
+	init_waitqueue_head(&wq);
+	/* start acerhdf_thread */
+	if (kernelmode) {
+		if (acerhdf_thread_start()) {
+			ret_val = -EIO;
+			goto EXIT_THERM_UNREG;
+		}
+	}
+	goto EXIT;
+
+EXIT_THERM_UNREG:
+	/* unregister thermal zone */
+	if (acerhdf_thz_dev) {
+		thermal_zone_device_unregister(acerhdf_thz_dev);
+		acerhdf_thz_dev = NULL;
+	}
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
+	/* send SIGTERM to thread */
+	if (thread_pid) {
+		kill_pid(thread_pid, SIGTERM, 1);
+		wait_for_completion(&on_exit);
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
