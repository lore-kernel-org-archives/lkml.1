Return-Path: <linux-kernel-owner+w=401wt.eu-S1763874AbYASBPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763874AbYASBPb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 20:15:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759528AbYASBPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 20:15:13 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:20310 "EHLO
	outbound2-va3-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759507AbYASBPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 20:15:08 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: DF9F24A0-1A5C-40A5-8B0A-DEB676E72ECF
Date: Fri, 18 Jan 2008 18:06:24 -0700
From: "Jordan Crouse" <jordan.crouse@amd.com>
To: "Arnd Hannemann" <hannemann@i4.informatik.rwth-aachen.de>
cc: "Andres Salomon" <dilinger@queued.net>, marc.jones@amd.com,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       wim@iguana.be
Subject: [GEODE] Geode GX/LX watchdog timer (was 2.6.24-rc8 hangs at
 mfgpt-timer)
Message-ID: <20080119010624.GA25328@cosmic.amd.com>
References: <478E4267.7020509@i4.informatik.rwth-aachen.de>
 <20080116161912.7b449466@ephemeral> <20080116165606.3ebc06a4@ephemeral>
 <478F25D6.3060503@i4.informatik.rwth-aachen.de>
 <20080117134032.4cc1a1cf@ephemeral>
 <478FB255.5040001@i4.informatik.rwth-aachen.de>
 <20080117211917.GF8244@cosmic.amd.com>
 <478FCDB6.4010708@i4.informatik.rwth-aachen.de>
 <20080117223644.GK8244@cosmic.amd.com>
 <478FDC12.6020505@i4.informatik.rwth-aachen.de>
MIME-Version: 1.0
In-Reply-To: <478FDC12.6020505@i4.informatik.rwth-aachen.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-OriginalArrivalTime: 19 Jan 2008 01:05:42.0310 (UTC)
 FILETIME=[69B30460:01C85A37]
X-WSS-ID: 6B8F91B507S8496921-01-01
Content-Type: multipart/mixed;
 boundary=rwEMma7ioTxnRzrJ
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rwEMma7ioTxnRzrJ
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

On 17/01/08 23:52 +0100, Arnd Hannemann wrote:
> >> Watchdog for the new API would be great :-)
> > 
> > Coming soon.

As promised, a watchdog driver for the Geode GX/LX processors is attached.
I basically just ported the previous patch forward to 2.6.24.

I also have good news or bad news depending on your perspective.  I wanted
to test this against 2.6.24, and OLPC is stuck at an older kernel version,
so I had to test this with coreboot (LinuxBIOS) on another Geode 
platform.  Like all BIOSen execpt for the OLPC firmware, coreboot uses
VSA (SMM handler) which consumes all the timers.

So I used the magical MSR and surprise! - the timer tick hung.  
I compiled out the timer tick, and tested the watchdog timer instead,
and it worked fine on timer 0.  So I don't think the MFGPTs themselves
have anything to do with this problem, but I do think it might be 
related to VSA and possibly interrupts too.  I'm going to invoke the
strong BIOS fu of our LinuxBIOS / BIOS expert Marc Jones, and see what
he comes up with.

I don't know how much of a hassle it would be for Andres to get a 2.6.24
kernel running on the OLPC to make sure that this isn't a regression
in the timer tick code (I suspect it isn't a regression, but you never
know).  I also think that it would probably be in our best interest to
default CONFIG_GEODE_MFGPT_TIMER to 'n' until we get this figured
out.  Since most BIOSen don't have timers available, that shouldn't affect
too many people.

So, anyway, enjoy the watchdog timer - I hope it meets everybody's
expectations for the 2.6.25 kernel.

Jordan
-- 
Jordan Crouse
Systems Software Development Engineer 
Advanced Micro Devices, Inc.

--rwEMma7ioTxnRzrJ
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline;
 filename=geode-watchdog.patch
Content-Transfer-Encoding: 7bit

[GEODE] Add a watchdog driver based on the CS5535/CS5536 MFGPT timers

From: Jordan Crouse <jordan.crouse@amd.com>

Add a watchdog timer based on the MFGPT timers in the CS5535/CS5536 
companion chips to the AMD Geode GX and LX processors.  Only caveat
is that the BIOS must provide at least a one free timer, and most
do not.

Signed-off-by: Jordan Crouse <jordan.crouse@amd.com>
---

 drivers/watchdog/Kconfig    |   13 ++
 drivers/watchdog/Makefile   |    1 
 drivers/watchdog/geodewdt.c |  321 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 335 insertions(+), 0 deletions(-)

Index: git/drivers/watchdog/Kconfig
===================================================================
--- git.orig/drivers/watchdog/Kconfig	2008-01-18 15:06:44.000000000 -0700
+++ git/drivers/watchdog/Kconfig	2008-01-18 17:50:25.000000000 -0700
@@ -295,6 +295,20 @@
 
 	  Most people will say N.
 
+config GEODE_WDT
+       tristate "AMD Geode CS5535/CS5536 Watchdog"
+       depends on MGEODE_LX
+       default n
+       help
+         This driver enables a watchdog capability built into the
+	 CS5535/CS5536 companion chips for the AMD Geode GX and LX
+	 processors.  This watchdog watches your kernel to make sure
+	 it doesn't freeze, and if it does, it reboots your computer after
+	 a certain amount of time.
+
+	 You can compile this driver directly into the kernel, or use
+	 it as a module.  The module will be called geodewdt.
+
 config SC520_WDT
 	tristate "AMD Elan SC520 processor Watchdog"
 	depends on X86
Index: git/drivers/watchdog/Makefile
===================================================================
--- git.orig/drivers/watchdog/Makefile	2008-01-18 15:06:44.000000000 -0700
+++ git/drivers/watchdog/Makefile	2008-01-18 16:32:15.000000000 -0700
@@ -59,6 +59,7 @@
 obj-$(CONFIG_ADVANTECH_WDT) += advantechwdt.o
 obj-$(CONFIG_ALIM1535_WDT) += alim1535_wdt.o
 obj-$(CONFIG_ALIM7101_WDT) += alim7101_wdt.o
+obj-$(CONFIG_GEODE_WDT) += geodewdt.o
 obj-$(CONFIG_SC520_WDT) += sc520_wdt.o
 obj-$(CONFIG_EUROTECH_WDT) += eurotechwdt.o
 obj-$(CONFIG_IB700_WDT) += ib700wdt.o
Index: git/drivers/watchdog/geodewdt.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ git/drivers/watchdog/geodewdt.c	2008-01-18 17:47:39.000000000 -0700
@@ -0,0 +1,308 @@
+/* Watchdog timer for the Geode GX/LX with the CS5535/CS5536 companion chip
+ *
+ * Copyright (C) 2006-2007, Advanced Micro Devices, Inc.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/types.h>
+#include <linux/miscdevice.h>
+#include <linux/watchdog.h>
+#include <linux/fs.h>
+#include <linux/platform_device.h>
+#include <linux/reboot.h>
+
+#include <asm/uaccess.h>
+#include <asm/geode.h>
+
+#define GEODEWDT_HZ 500
+#define GEODEWDT_SCALE 6
+#define GEODEWDT_MAX_SECONDS 131
+
+#define WDT_FLAGS_OPEN 1
+#define WDT_FLAGS_ORPHAN 2
+
+#define DRV_NAME "geodewdt"
+#define WATCHDOG_NAME "Geode GX/LX WDT"
+#define WATCHDOG_TIMEOUT 60
+
+static int timeout = WATCHDOG_TIMEOUT;
+module_param(timeout, int, 0);
+MODULE_PARM_DESC(timeout, "Watchdog timeout in seconds. 1<= timeout <=131, default=" __MODULE_STRING(WATCHDOG_TIMEOUT) ".");
+
+static int nowayout = WATCHDOG_NOWAYOUT;
+module_param(nowayout, int, 0);
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+
+static struct platform_device *geodewdt_platform_device;
+static unsigned long wdt_flags;
+static int wdt_timer;
+static int safe_close;
+
+static void geodewdt_ping(void)
+{
+	/* Stop the counter */
+	geode_mfgpt_write(wdt_timer, MFGPT_REG_SETUP, 0);
+
+	/* Reset the counter */
+	geode_mfgpt_write(wdt_timer, MFGPT_REG_COUNTER, 0);
+
+	/* Enable the counter */
+	geode_mfgpt_write(wdt_timer, MFGPT_REG_SETUP, MFGPT_SETUP_CNTEN);
+}
+
+static void geodewdt_disable(void)
+{
+	geode_mfgpt_write(wdt_timer, MFGPT_REG_SETUP, 0);
+	geode_mfgpt_write(wdt_timer, MFGPT_REG_COUNTER, 0);
+}
+
+static int geodewdt_set_heartbeat(int val)
+{
+	if (val < 1 || val > GEODEWDT_MAX_SECONDS)
+		return -EINVAL;
+
+	geode_mfgpt_write(wdt_timer, MFGPT_REG_SETUP, 0);
+	geode_mfgpt_write(wdt_timer, MFGPT_REG_CMP2, val * GEODEWDT_HZ);
+	geode_mfgpt_write(wdt_timer, MFGPT_REG_COUNTER, 0);
+	geode_mfgpt_write(wdt_timer, MFGPT_REG_SETUP, MFGPT_SETUP_CNTEN);
+
+	timeout = val;
+	return 0;
+}
+
+static int
+geodewdt_open(struct inode *inode, struct file *file)
+{
+        if (test_and_set_bit(WDT_FLAGS_OPEN, &wdt_flags))
+                return -EBUSY;
+
+        if (!test_and_clear_bit(WDT_FLAGS_ORPHAN, &wdt_flags))
+                __module_get(THIS_MODULE);
+
+	geodewdt_ping();
+        return nonseekable_open(inode, file);
+}
+
+static int
+geodewdt_release(struct inode *inode, struct file *file)
+{
+	if (safe_close) {
+		geodewdt_disable();
+		module_put(THIS_MODULE);
+	}
+	else {
+		printk(KERN_CRIT "Unexpected close - watchdog is not stopping.\n");
+		geodewdt_ping();
+
+		set_bit(WDT_FLAGS_ORPHAN, &wdt_flags);
+	}
+
+	clear_bit(WDT_FLAGS_OPEN, &wdt_flags);
+	safe_close = 0;
+	return 0;
+}
+
+static ssize_t
+geodewdt_write(struct file *file, const char __user *data, size_t len,
+	       loff_t *ppos)
+{
+        if(len) {
+		if (!nowayout) {
+			size_t i;
+			safe_close = 0;
+
+			for (i = 0; i != len; i++) {
+				char c;
+
+				if (get_user(c, data + i))
+					return -EFAULT;
+
+				if (c == 'V')
+					safe_close = 1;
+			}
+		}
+
+		geodewdt_ping();
+	}
+	return len;
+}
+
+static int
+geodewdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
+	       unsigned long arg)
+{
+	void __user *argp = (void __user *)arg;
+	int __user *p = argp;
+	int interval;
+
+	static struct watchdog_info ident = {
+		.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING
+		| WDIOF_MAGICCLOSE,
+		.firmware_version =     1,
+		.identity =             WATCHDOG_NAME,
+        };
+
+	switch(cmd) {
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(argp, &ident,
+				    sizeof(ident)) ? -EFAULT : 0;
+		break;
+
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, p);
+
+	case WDIOC_KEEPALIVE:
+		geodewdt_ping();
+		return 0;
+
+	case WDIOC_SETTIMEOUT:
+		if (get_user(interval, p))
+			return -EFAULT;
+
+		if (geodewdt_set_heartbeat(interval))
+			return -EINVAL;
+
+/* Fall through */
+
+	case WDIOC_GETTIMEOUT:
+		return put_user(timeout, p);
+
+	case WDIOC_SETOPTIONS:
+	{
+		int options, ret = -EINVAL;
+
+		if (get_user(options, p))
+			return -EFAULT;
+
+		if (options & WDIOS_DISABLECARD) {
+			geodewdt_disable();
+			ret = 0;
+		}
+
+		if (options & WDIOS_ENABLECARD) {
+			geodewdt_ping();
+			ret = 0;
+		}
+
+		return ret;
+	}
+	default:
+		return -ENOTTY;
+	}
+
+	return 0;
+}
+
+static const struct file_operations geodewdt_fops = {
+        .owner          = THIS_MODULE,
+        .llseek         = no_llseek,
+        .write          = geodewdt_write,
+        .ioctl          = geodewdt_ioctl,
+        .open           = geodewdt_open,
+        .release        = geodewdt_release,
+};
+
+static struct miscdevice geodewdt_miscdev = {
+	.minor = WATCHDOG_MINOR,
+	.name = "geode-watchdog",
+	.fops = &geodewdt_fops
+};
+
+static int __devinit
+geodewdt_probe(struct platform_device *dev)
+{
+	int ret, timer;
+
+	timer = geode_mfgpt_alloc_timer(MFGPT_TIMER_ANY,
+					MFGPT_DOMAIN_WORKING, THIS_MODULE);
+
+	if (timer == -1) {
+		printk(KERN_ERR "geodewdt:  No timers were available\n");
+		return -ENODEV;
+	}
+
+	wdt_timer = timer;
+
+	/* Set up the timer */
+
+	geode_mfgpt_write(wdt_timer, MFGPT_REG_SETUP,
+			  GEODEWDT_SCALE | (3 << 8));
+
+	/* Set up comparator 2 to reset when the event fires */
+	geode_mfgpt_toggle_event(wdt_timer, MFGPT_CMP2, MFGPT_EVENT_RESET, 1);
+
+	/* Set up the initial timeout */
+
+	geode_mfgpt_write(wdt_timer, MFGPT_REG_CMP2,
+		timeout * GEODEWDT_HZ);
+
+	ret = misc_register(&geodewdt_miscdev);
+
+	return ret;
+}
+
+static int __devexit
+geodewdt_remove(struct platform_device *dev)
+{
+	misc_deregister(&geodewdt_miscdev);
+}
+
+static void
+geodewdt_shutdown(struct platform_device *dev)
+{
+	geodewdt_disable();
+}
+
+static struct platform_driver geodewdt_driver = {
+	.probe		= geodewdt_probe,
+	.remove		= __devexit_p(geodewdt_remove),
+	.shutdown	= geodewdt_shutdown,
+	.driver		= {
+		.owner	= THIS_MODULE,
+		.name	= DRV_NAME,
+	},
+};
+
+static int __init
+geodewdt_init(void)
+{
+	int ret;
+
+	ret = platform_driver_register(&geodewdt_driver);
+	if (ret)
+		return ret;
+
+	geodewdt_platform_device = platform_device_register_simple(DRV_NAME, -1, NULL, 0);
+	if (IS_ERR(geodewdt_platform_device)) {
+		ret = PTR_ERR(geodewdt_platform_device);
+		goto err;
+	}
+
+	return 0;
+err:
+	platform_driver_unregister(&geodewdt_driver);
+	return ret;
+}
+
+static void __exit
+geodewdt_exit(void)
+{
+	platform_device_unregister(geodewdt_platform_device);
+	platform_driver_unregister(&geodewdt_driver);
+}
+
+module_init(geodewdt_init);
+module_exit(geodewdt_exit);
+
+MODULE_AUTHOR("Advanced Micro Devices, Inc");
+MODULE_DESCRIPTION("Geode GX/LX Watchdog Driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
Index: git/arch/x86/kernel/mfgpt_32.c
===================================================================
--- git.orig/arch/x86/kernel/mfgpt_32.c	2008-01-18 16:57:50.000000000 -0700
+++ git/arch/x86/kernel/mfgpt_32.c	2008-01-18 17:48:22.000000000 -0700
@@ -142,6 +142,8 @@
 	return 0;
 }
 
+EXPORT_SYMBOL_GPL(geode_mfgpt_toggle_event);
+
 int geode_mfgpt_set_irq(int timer, int cmp, int irq, int enable)
 {
 	u32 val, dummy;
@@ -204,6 +206,7 @@
 	return -1;
 }
 
+EXPORT_SYMBOL_GPL(geode_mfgpt_alloc_timer);
 
 #ifdef CONFIG_GEODE_MFGPT_TIMER
 

--rwEMma7ioTxnRzrJ--


