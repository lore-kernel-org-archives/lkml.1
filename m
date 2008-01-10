Return-Path: <linux-kernel-owner+w=401wt.eu-S1760806AbYAJPMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760806AbYAJPMs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 10:12:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761773AbYAJPLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 10:11:17 -0500
Received: from mail.hevs.ch ([153.109.23.15]:53092 "EHLO mail.hevs.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761762AbYAJPLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 10:11:15 -0500
From: Marc Pignat <marc.pignat@hevs.ch>
Organization: HEVs
To: wim@iguana.be
Subject: [RFC, PATCH] watchdog on gpio
Date: Thu, 10 Jan 2008 16:11:08 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801101611.08867.marc.pignat@hevs.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

watchdog driver for embedded systems with a supervisor watchdog (MAX823 or so)
connected to a gpio. This is the platform_driver and needs platform_data for
defining the gpio pin and the watchdog timeout.

Signed-off-by: Marc Pignat <marc.pignat@hevs.ch>
---

Hi!

If you've got a max823, 824 or any cpu supervisor like this connected to your
cpu by a gpio pin, you can use this watchdog driver.

Simply add this to your board specific setup file:

#include <linux/gpio_wdt.h>

static struct gpio_wdt_pdata my_wdt = {
	/* WDI input connected to this gpio */
	.pin		= AT91_PIN_PD27,
	/* The *min* timeout */
	.timeout_ms	= 1140
};

static struct platform_device my_watchdog_device =
{
	.name = GPIO_WDT_DRIVER_NAME,
	.id   = 0,
	.dev  =	{
		.platform_data=&my_wdt,
	}
};

then

platform_device_register(&my_watchdog_device);



This patch is against 2.6.24-rc7-git2

Comments are welcome

Regards

Marc

diff -urN a/drivers/watchdog/gpio_wdt.c b/drivers/watchdog/gpio_wdt.c
--- a/drivers/watchdog/gpio_wdt.c	1970-01-01 01:00:00.000000000 +0100
+++ b/drivers/watchdog/gpio_wdt.c	2008-01-10 16:06:09.000000000 +0100
@@ -0,0 +1,300 @@
+/*
+ * Generic GPIO based watchdog driver
+ *
+ * Copyright (C) 2007 Marc Pignat for www.hevs.ch
+ *
+ * This is a driver for the MAXIM MAX823 (and similar watchdog chips) connected
+ * on a generic gpio line.
+ *
+ * Principle of operation:
+ *
+ *  When the WDI input is not driven (or in high impedance state), the
+ *  watchdog is disabled. This mode of operations supposes that the gpio line
+ *  can be put in high-impedance state (input) and is not driving too much
+ *  current from the WDI pin.
+ *
+ *  When the WDI input is driven, it must be toggled before the timeout,
+ *  otherwise a reset is generated.
+ *
+ * Other supported chips:
+ *  MAXIM: MAX824, ...
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/pm.h>
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/miscdevice.h>
+#include <linux/watchdog.h>
+#include <linux/gpio_wdt.h>
+#include <linux/fs.h>
+#include <linux/reboot.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+
+#include <asm/uaccess.h>
+#include <asm/arch/gpio.h>
+
+static int nowayout = WATCHDOG_NOWAYOUT;
+module_param(nowayout, int, 0);
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+
+struct gpio_wdt {
+	struct gpio_wdt_pdata *pdata;
+	unsigned long driver_open;
+	char expect_close;
+};
+
+static struct gpio_wdt *watchdog;
+
+#define PFX GPIO_WDT_DRIVER_NAME":"
+
+static int gpio_wdt_keepalive(struct gpio_wdt *wdt)
+{
+	gpio_set_value(wdt->pdata->pin, 0);
+	gpio_set_value(wdt->pdata->pin, 1);
+	return 0;
+}
+
+static int gpio_wdt_stop(struct gpio_wdt *wdt)
+{
+	gpio_wdt_keepalive(wdt);
+	gpio_direction_input(wdt->pdata->pin);
+	return 0;
+}
+
+static int gpio_wdt_start(struct gpio_wdt *wdt)
+{
+	gpio_direction_output(wdt->pdata->pin, 0);
+	gpio_wdt_keepalive(wdt);
+	return 0;
+}
+
+static int gpio_wdt_open(struct inode *inode, struct file *file)
+{
+	if (test_and_set_bit(0, &watchdog->driver_open))
+		return -EBUSY;
+
+	gpio_wdt_start(watchdog);
+	gpio_wdt_keepalive(watchdog);
+
+	return nonseekable_open(inode, file);
+}
+
+static int gpio_wdt_release(struct inode *inode, struct file *file)
+{
+	if (watchdog->expect_close == 42) {
+		gpio_wdt_stop(watchdog);
+		module_put(THIS_MODULE);
+	} else {
+		printk(KERN_CRIT PFX "Unexpected close, not stopping watchdog!\n");
+		gpio_wdt_keepalive(watchdog);
+	}
+	clear_bit(0, &watchdog->driver_open);
+	watchdog->expect_close = 0;
+	return 0;
+}
+
+static ssize_t gpio_wdt_write(struct file *file, const char __user *data, size_t len, loff_t *ppos)
+{
+	/*
+	 *	Refresh the timer.
+	 */
+	if (len) {
+		if (!nowayout) {
+			size_t i;
+
+			/* In case it was set long ago */
+			watchdog->expect_close = 0;
+
+			for (i = 0; i != len; i++) {
+				char c;
+
+				if (get_user(c, data + i))
+					return -EFAULT;
+				if (c == 'V')
+					watchdog->expect_close = 42;
+			}
+		}
+		gpio_wdt_keepalive(watchdog);
+	}
+	return len;
+
+	gpio_wdt_keepalive(watchdog);
+	return len;
+}
+
+static struct watchdog_info ident = {
+	.options =  WDIOF_KEEPALIVEPING | WDIOF_MAGICCLOSE,
+	.firmware_version = 0,
+	.identity = GPIO_WDT_DRIVER_NAME,
+};
+
+static int gpio_wdt_ioctl(struct inode *inode, struct file *file,
+    unsigned int cmd, unsigned long arg)
+{
+	struct gpio_wdt *wdt = (struct gpio_wdt *)file->private_data;
+	void __user *argp = (void __user *)arg;
+	int __user *p = argp;
+	u32 timeout = wdt->pdata->timeout_ms;
+
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(argp, &ident, sizeof(ident)) ? -EFAULT : 0;
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, p);
+	case WDIOC_KEEPALIVE:
+		gpio_wdt_keepalive(wdt);
+		return 0;
+	case WDIOC_GETTIMEOUT:
+		return put_user(timeout, p);
+	case WDIOC_SETTIMEOUT:
+		return -EINVAL;
+	default:
+		return -ENOIOCTLCMD;
+	}
+}
+
+static int gpio_wdt_notify_sys(struct notifier_block *this,
+	unsigned long code, void *unused)
+{
+	if (code == SYS_DOWN || code == SYS_HALT)
+		gpio_wdt_stop(watchdog);
+
+	return NOTIFY_DONE;
+}
+
+static struct file_operations gpio_wdt_fops = {
+	.owner	= THIS_MODULE,
+	.llseek	= no_llseek,
+	.write	= gpio_wdt_write,
+	.ioctl	= gpio_wdt_ioctl,
+	.open	= gpio_wdt_open,
+	.release	= gpio_wdt_release,
+};
+
+static struct miscdevice gpio_wdt_miscdev = {
+	.minor	= WATCHDOG_MINOR,
+	.name	= "watchdog",
+	.fops	= &gpio_wdt_fops,
+};
+
+static struct notifier_block gpio_wdt_notifier = {
+	.notifier_call    = gpio_wdt_notify_sys,
+};
+
+static char banner[] __initdata = KERN_INFO PFX "fixed %d.%03d seconds timeout (nowayout= %d)\n";
+
+static int __init gpio_wdt_probe(struct platform_device *pdev)
+{
+	struct gpio_wdt_pdata *pdata = (struct gpio_wdt_pdata *)pdev->dev.platform_data;
+	int ret;
+
+	if (watchdog) {
+		printk(KERN_ERR PFX "only one device supported\n");
+		return -ENODEV;
+	}
+
+	if (!pdata) {
+		printk(KERN_ERR PFX "no private data\n");
+		return -ENODEV;
+	}
+
+	watchdog = kzalloc(sizeof(*watchdog), GFP_KERNEL);
+
+	if (!watchdog)
+		return -ENOMEM;
+
+	watchdog->pdata = pdata;
+
+	if (watchdog->pdata->pin == 0 || watchdog->pdata->timeout_ms == 0) {
+		kfree(watchdog);
+		printk(KERN_ERR PFX "invalid private data\n");
+		return -ENODEV;
+	}
+
+	ret = register_reboot_notifier(&gpio_wdt_notifier);
+	if (ret) {
+		kfree(watchdog);
+		printk(KERN_ERR PFX "cannot register reboot notifier (err=%d)\n", ret);
+		return ret;
+	}
+
+	ret = misc_register(&gpio_wdt_miscdev);
+	if (ret) {
+		unregister_reboot_notifier(&gpio_wdt_notifier);
+		kfree(watchdog);
+		printk(KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
+							WATCHDOG_MINOR, ret);
+		return ret;
+	}
+
+	printk(banner, watchdog->pdata->timeout_ms/1000, watchdog->pdata->timeout_ms%1000, nowayout);
+
+	return 0;
+}
+
+static int __exit gpio_wdt_remove(struct platform_device *pdev)
+{
+	misc_deregister(&gpio_wdt_miscdev);
+	unregister_reboot_notifier(&gpio_wdt_notifier);
+	kfree(watchdog);
+	watchdog = NULL;
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+int gpio_wdt_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	gpio_wdt_stop(watchdog);
+	return 0;
+}
+
+int gpio_wdt_resume(struct platform_device *pdev)
+{
+	if (test_bit(0, &watchdog->driver_open))
+		gpio_wdt_start(watchdog);
+	return 0;
+}
+
+#else
+#define gpio_wdt_suspend()
+#define gpio_wdt_resume()
+#endif
+
+/* the device driver */
+static struct platform_driver gpio_wdt_driver = {
+	.probe		= gpio_wdt_probe,
+	.remove		= __exit_p(gpio_wdt_remove),
+	.suspend	= gpio_wdt_suspend,
+	.resume		= gpio_wdt_resume,
+	.driver		= {
+		.name	= GPIO_WDT_DRIVER_NAME,
+		.owner	= THIS_MODULE,
+	},
+};
+
+/* module init or kerel entry point */
+static int __init gpio_wdt_driver_init(void)
+{
+	return platform_driver_register(&gpio_wdt_driver);
+}
+
+/* module exit */
+static void __exit gpio_wdt_driver_exit(void)
+{
+	platform_driver_unregister(&gpio_wdt_driver);
+}
+
+module_init(gpio_wdt_driver_init);
+module_exit(gpio_wdt_driver_exit);
+
+MODULE_AUTHOR("Marc Pignat");
+MODULE_DESCRIPTION("Watchdog driver on a generic gpio line");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
diff -urN a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
--- a/drivers/watchdog/Kconfig	2008-01-08 17:30:30.000000000 +0100
+++ b/drivers/watchdog/Kconfig	2008-01-10 14:00:30.000000000 +0100
@@ -55,6 +55,13 @@
 	  To compile this driver as a module, choose M here: the
 	  module will be called softdog.
 
+config GPIO_WATCHDOG
+	tristate "Support for GPIO connected watchdog"
+	depends on GENERIC_GPIO
+	help
+	  This option enables support for a MAX823-like watchdog connected to
+	  GPIO input/output.
+
 # ALPHA Architecture
 
 # ARM Architecture
diff -urN a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
--- a/drivers/watchdog/Makefile	2008-01-08 17:30:30.000000000 +0100
+++ b/drivers/watchdog/Makefile	2008-01-10 14:01:32.000000000 +0100
@@ -121,3 +121,4 @@
 
 # Architecture Independant
 obj-$(CONFIG_SOFT_WATCHDOG) += softdog.o
+obj-$(CONFIG_GPIO_WATCHDOG) += gpio_wdt.o
--- a/include/linux/gpio_wdt.h	1970-01-01 01:00:00.000000000 +0100
+++ b/include/linux/gpio_wdt.h	2008-01-10 15:48:42.000000000 +0100
@@ -0,0 +1,30 @@
+/*
+ * linux/include/gpio_watchdog.h
+ *
+ * Copyright (C) 2007 Marc Pignat for www.hevs.ch
+ *
+ * Watchdog using a MAX823 (or similar) watchdog input connected to a
+ * generic gpio line.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+
+#ifndef _LINUX_LINUX_GPIO_WDT_H
+#define _LINUX_LINUX_GPIO_WDT_H
+
+#include <asm/arch/hardware.h>
+
+#define GPIO_WDT_DRIVER_NAME "gpio_wdt"
+
+struct gpio_wdt_pdata {
+	/* the pin as defined in asm/arch/gpio.h */
+	u32 pin;
+	/* the timeout in milliseconds */
+	u32 timeout_ms;
+};
+
+#endif
