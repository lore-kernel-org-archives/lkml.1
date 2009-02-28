Return-Path: <linux-kernel-owner+w=401wt.eu-S1755277AbZB1S6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277AbZB1S6c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 13:58:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753546AbZB1S6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 13:58:24 -0500
Received: from smtprelay03.ispgateway.de ([80.67.18.15]:46074 "EHLO
	smtprelay03.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbZB1S6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 13:58:22 -0500
References: <cone.1234471033.988571.5384.1000@mentalhome> <20090213134024.GA26549@srcf.ucam.org> <cone.1234551556.57236.4642.1000@onepiie> <20090213191815.GB1379@srcf.ucam.org> <cone.1235761090.678709.5345.1000@onepiie> <1235763653.24506.6.camel@localhost>
Message-ID: <cone.1235847508.919525.5537.1000@onepiie>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <peter@piie.net>
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] acerhdf: Acer Aspire One fan control
Date: Sat, 28 Feb 2009 19:58:28 +0100
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
X-Df-Sender: 404094
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe, Hi List,

thank you very much for your tips!

Joe Perches writes:
> On Fri, 2009-02-27 at 19:58 +0100, Peter Feuerer wrote:
>> What do you think about this piece of code?
> 
> I think you should run it through lindent/checkpatch.

I let the checkpatch.pl script ran over the code and corrected every single 
warning and error. The resulting code is at the end of this email.

Do you (or anyobdy else on this list) have any further tips, suggestions or 
advices? If everybody is fine with the code, what will be the next steps?

kind regards,
--peter



diff -Naur linux-2.6.28_original/drivers/misc/Kconfig linux-2.6.28_foo/drivers/misc/Kconfig
--- linux-2.6.28_original/drivers/misc/Kconfig	2008-12-25 00:26:37.000000000 +0100
+++ linux-2.6.28_foo/drivers/misc/Kconfig	2009-02-27 19:30:40.000000000 +0100
@@ -158,6 +158,18 @@
 	  If you have an ACPI-WMI compatible Acer/ Wistron laptop, say Y or M
 	  here.
 
+config ACERHDF
+        tristate "Acer Aspire One Fan Control (EXPERIMENTAL)"
+	depends on X86
+	depends on EXPERIMENTAL
+	depends on ACPI
+	depends on THERMAL
+	---help---
+      This is the driver for monitoring the temperature and controlling
+      the fan of Acer Aspire One netbooks.
+      The temperature can be read from
+      /sys/class/thermal/thermal_zone0/temp
+
 config ASUS_LAPTOP
         tristate "Asus Laptop Extras (EXPERIMENTAL)"
         depends on X86
diff -Naur linux-2.6.28_original/drivers/misc/Makefile linux-2.6.28_foo/drivers/misc/Makefile
--- linux-2.6.28_original/drivers/misc/Makefile	2008-12-25 00:26:37.000000000 +0100
+++ linux-2.6.28_foo/drivers/misc/Makefile	2009-02-19 22:57:16.000000000 +0100
@@ -10,6 +10,7 @@
 obj-$(CONFIG_MSI_LAPTOP)	+= msi-laptop.o
 obj-$(CONFIG_COMPAL_LAPTOP)	+= compal-laptop.o
 obj-$(CONFIG_ACER_WMI)		+= acer-wmi.o
+obj-$(CONFIG_ACERHDF)		+= acerhdf.o
 obj-$(CONFIG_ATMEL_PWM)		+= atmel_pwm.o
 obj-$(CONFIG_ATMEL_SSC)		+= atmel-ssc.o
 obj-$(CONFIG_ATMEL_TCLIB)	+= atmel_tclib.o
diff -Naur linux-2.6.28_original/drivers/misc/acerhdf.c linux-2.6.28_foo/drivers/misc/acerhdf.c
--- linux-2.6.28_original/drivers/misc/acerhdf.c	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.28_foo/drivers/misc/acerhdf.c	2009-02-28 19:34:55.000000000 +0100
@@ -0,0 +1,527 @@
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
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/dmi.h>
+#include <acpi/acpi_drivers.h>
+#include <linux/sched.h>
+#include <linux/thermal.h>
+
+#define VERSION "0.3.2"
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Peter Feuerer");
+
+/* thread handling variables */
+static int thread_id;
+static struct pid *thread_pid;
+static wait_queue_head_t wq;
+static DECLARE_COMPLETION(on_exit);
+
+/* global variables */
+static int interval = 10;
+static int fanon = 67;
+static int fanoff = 62;
+static int verbose;
+static int kernelmode = 1;
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
+	const char version[10];
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
+	{"v0.3109", 0x55, 0x58, 0x1f, 0x00, 0x1f},
+	{"v0.3114", 0x55, 0x58, 0x1f, 0x00, 0x1f},
+	{"v0.3301", 0x55, 0x58, 0xaf, 0x00, 0xaf},
+	{"v0.3304", 0x55, 0x58, 0xaf, 0x00, 0xaf},
+	{"v0.3305", 0x55, 0x58, 0xaf, 0x00, 0xaf},
+	{"v0.3308", 0x55, 0x58, 0xaf, 0x00, 0xaf},
+	{"v0.3309", 0x55, 0x58, 0x21, 0x00, 0x21},
+	{"", 0, 0, 0, 0, 0}
+};
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
+	thread_id = 0;
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
+		if (!kernelmode && !thread_id) {
+			thread_id = kernel_thread(acerhdf_thread, NULL,
+					CLONE_KERNEL);
+
+			if (thread_id == 0)
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
+	printk(KERN_NOTICE "acerhdf: version: %s compiledate: %s %s\n",
+			VERSION, __DATE__, __TIME__);
+	printk(KERN_NOTICE "acerhdf: biosvendor:%s\n", vendor);
+	printk(KERN_NOTICE "acerhdf: biosversion:%s\n", version);
+	printk(KERN_NOTICE "acerhdf: biosrelease:%s\n", release);
+	printk(KERN_NOTICE "acerhdf: biosproduct:%s\n", product);
+
+	if (!force_bios[0]) {
+
+		/* check if vendor of the hardware is Acer */
+		if (strcmp(vendor, "Acer")) {
+			printk(KERN_ERR
+					"acerhdf: no Acer hardware found\n");
+			return -ENODEV;
+		}
+		/* check if product is a AO - Aspire One */
+		if (strncmp(product, "AO", 2)) {
+			printk(KERN_ERR
+				"acerhdf: no Aspire One hardware found\n");
+			return -ENODEV;
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
+	/* search bios in bios settings table */
+	for (i = 0; bios_settings[i].version[0]; ++i) {
+		if (!strcmp(bios_settings[i].version, version)) {
+			bios_version = i;
+			break;
+		}
+	}
+	if (bios_version == -1) {
+		printk(KERN_ERR "acerhdf: cannot find bios version\n");
+		return -ENODEV;
+	}
+
+	/* create cooling device */
+	acerhdf_cool_dev = thermal_cooling_device_register("acerhdf-fan", NULL,
+			&acerhdf_cooling_ops);
+	if (IS_ERR(acerhdf_cool_dev))
+		return -ENODEV;
+
+	/* create thermal zone */
+	acerhdf_thz_dev = thermal_zone_device_register("acerhdf", 2,
+			NULL, &acerhdf_device_ops);
+	if (IS_ERR(acerhdf_thz_dev))
+		return -ENODEV;
+
+	init_waitqueue_head(&wq);
+	/* start acerhdf_thread */
+	if (kernelmode) {
+		thread_id = kernel_thread(acerhdf_thread, NULL, CLONE_KERNEL);
+		if (thread_id == 0)
+			return -EIO;
+	}
+
+	return 0;
+}
+
+/* exit the module */
+static void __exit acerhdf_exit(void)
+{
+	/* unregister thermal zone */
+	if (acerhdf_thz_dev) {
+		thermal_zone_device_unregister(acerhdf_thz_dev);
+		acerhdf_thz_dev = NULL;
+	}
+	/* unregister cooling device */
+	if (acerhdf_cool_dev) {
+		thermal_cooling_device_unregister(acerhdf_cool_dev);
+		acerhdf_cool_dev = NULL;
+	}
+	/* send SIGTERM to thread */
+	if (thread_id) {
+		kill_pid(thread_pid, SIGTERM, 1);
+		wait_for_completion(&on_exit);
+	}
+}
+
+/* what are the module init/exit functions */
+module_init(acerhdf_init);
+module_exit(acerhdf_exit);
