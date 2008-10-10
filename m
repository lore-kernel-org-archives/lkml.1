Return-Path: <linux-kernel-owner+w=401wt.eu-S1759858AbYJJNz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759858AbYJJNz7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 09:55:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756578AbYJJNzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 09:55:50 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41283 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756471AbYJJNzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 09:55:49 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] watchdog: Add support for the WM8350 watchdog
Date: Fri, 10 Oct 2008 14:55:47 +0100
Message-Id: <1223646947-10078-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver implements support for the watchdog functionality provided
by the Wolfson Microelectronics WM8350, a multi-function audio and
power management subsystem intended for use in embedded systems. It is
based on a driver originally written by Graeme Gregory, though it has
been extensively modified since then.

Use of a GPIO to kick the watchdog is not yet supported.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---

This patch depends on the WM8350 core support which is currently in the
process of being merged via the regulator tree - Wim, are you OK with
also merging this via there?

 drivers/mfd/wm8350-core.c       |    5 +
 drivers/watchdog/Kconfig        |    7 +
 drivers/watchdog/Makefile       |    1 +
 drivers/watchdog/wm8350_wdt.c   |  316 +++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/wm8350/core.h |    2 +
 include/linux/mfd/wm8350/wdt.h  |    8 +-
 6 files changed, 338 insertions(+), 1 deletions(-)
 create mode 100644 drivers/watchdog/wm8350_wdt.c

diff --git a/drivers/mfd/wm8350-core.c b/drivers/mfd/wm8350-core.c
index cd1f76e..db354de 100644
--- a/drivers/mfd/wm8350-core.c
+++ b/drivers/mfd/wm8350-core.c
@@ -1234,6 +1234,8 @@ int wm8350_device_init(struct wm8350 *wm8350, int irq,
 
 	wm8350_reg_write(wm8350, WM8350_SYSTEM_INTERRUPTS_MASK, 0x0);
 
+	wm8350_client_dev_register(wm8350, "wm8350-wdt", &(wm8350->wdt.pdev));
+
 	return 0;
 
 err:
@@ -1250,6 +1252,9 @@ void wm8350_device_exit(struct wm8350 *wm8350)
 		if (wm8350->pmic.pdev[i] != NULL)
 			platform_device_unregister(wm8350->pmic.pdev[i]);
 
+	if (wm8350->wdt.pdev)
+		platform_device_unregister(wm8350->wdt.pdev);
+
 	free_irq(wm8350->chip_irq, wm8350);
 	flush_work(&wm8350->irq_work);
 	kfree(wm8350->reg_cache);
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index c510367..bf0d1bc 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -55,6 +55,13 @@ config SOFT_WATCHDOG
 	  To compile this driver as a module, choose M here: the
 	  module will be called softdog.
 
+config WM8350_WATCHDOG
+	tristate "WM8350 watchdog"
+	depends on MFD_WM8350
+	help
+	  Support for the watchdog in the WM8350 AudioPlus PMIC.  When
+	  the watchdog triggers the system will be reset.
+
 # ALPHA Architecture
 
 # ARM Architecture
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index e0ef123..e9d36c9 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -127,3 +127,4 @@ obj-$(CONFIG_SH_WDT) += shwdt.o
 
 # Architecture Independant
 obj-$(CONFIG_SOFT_WATCHDOG) += softdog.o
+obj-$(CONFIG_WM8350_WATCHDOG) += wm8350_wdt.o
diff --git a/drivers/watchdog/wm8350_wdt.c b/drivers/watchdog/wm8350_wdt.c
new file mode 100644
index 0000000..3cae199
--- /dev/null
+++ b/drivers/watchdog/wm8350_wdt.c
@@ -0,0 +1,316 @@
+/*
+ * Watchdog driver for the wm8350
+ *
+ * Copyright (C) 2007, 2008 Wolfson Microelectronics <linux@wolfsonmicro.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/fs.h>
+#include <linux/miscdevice.h>
+#include <linux/platform_device.h>
+#include <linux/watchdog.h>
+#include <linux/uaccess.h>
+#include <linux/mfd/wm8350/core.h>
+
+static int nowayout = WATCHDOG_NOWAYOUT;
+module_param(nowayout, int, 0);
+MODULE_PARM_DESC(nowayout,
+		 "Watchdog cannot be stopped once started (default="
+		 __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+
+static unsigned long wm8350_wdt_users;
+static struct miscdevice wm8350_wdt_miscdev;
+static int wm8350_wdt_expect_close;
+
+static struct {
+	int time;  /* Seconds */
+	u16 val;   /* To be set in WM8350_SYSTEM_CONTROL_2 */
+} wm8350_wdt_cfgs[] = {
+	{ 1, 0x02 },
+	{ 2, 0x04 },
+	{ 4, 0x05 },
+};
+
+static struct wm8350 *get_wm8350(void)
+{
+	return dev_get_drvdata(wm8350_wdt_miscdev.parent);
+}
+
+static int wm8350_wdt_set_timeout(struct wm8350 *wm8350, u16 value)
+{
+	int ret;
+	u16 reg;
+
+	wm8350_reg_unlock(wm8350);
+
+	reg = wm8350_reg_read(wm8350, WM8350_SYSTEM_CONTROL_2);
+	reg &= ~WM8350_WDOG_TO_MASK;
+	reg |= value;
+	ret = wm8350_reg_write(wm8350, WM8350_SYSTEM_CONTROL_2, reg);
+
+	wm8350_reg_lock(wm8350);
+
+	return ret;
+}
+
+static int wm8350_wdt_start(struct wm8350 *wm8350)
+{
+	int ret;
+	u16 reg;
+
+	wm8350_reg_unlock(wm8350);
+
+	reg = wm8350_reg_read(wm8350, WM8350_SYSTEM_CONTROL_2);
+	reg &= ~WM8350_WDOG_MODE_MASK;
+	reg |= 0x20;
+	ret = wm8350_reg_write(wm8350, WM8350_SYSTEM_CONTROL_2, reg);
+
+	wm8350_reg_lock(wm8350);
+
+	return ret;
+}
+
+static int wm8350_wdt_stop(struct wm8350 *wm8350)
+{
+	int ret;
+	u16 reg;
+
+	wm8350_reg_unlock(wm8350);
+
+	reg = wm8350_reg_read(wm8350, WM8350_SYSTEM_CONTROL_2);
+	reg &= ~WM8350_WDOG_MODE_MASK;
+	ret = wm8350_reg_write(wm8350, WM8350_SYSTEM_CONTROL_2, reg);
+
+	wm8350_reg_lock(wm8350);
+
+	return ret;
+}
+
+static int wm8350_wdt_kick(struct wm8350 *wm8350)
+{
+	int ret;
+	u16 reg;
+
+	reg = wm8350_reg_read(wm8350, WM8350_SYSTEM_CONTROL_2);
+	ret = wm8350_reg_write(wm8350, WM8350_SYSTEM_CONTROL_2, reg);
+
+	return ret;
+}
+
+static int wm8350_wdt_open(struct inode *inode, struct file *file)
+{
+	struct wm8350 *wm8350 = get_wm8350();
+	int ret;
+
+	if (!wm8350) {
+		printk(KERN_CRIT "FNORD\n");
+		return -ENODEV;
+	}
+	if (test_and_set_bit(1, &wm8350_wdt_users))
+		return -EBUSY;
+
+	ret = wm8350_wdt_start(wm8350);
+	if (ret != 0)
+		return ret;
+
+	return nonseekable_open(inode, file);
+}
+
+static int wm8350_wdt_release(struct inode *inode, struct file *file)
+{
+	struct wm8350 *wm8350 = get_wm8350();
+
+	if (wm8350_wdt_expect_close)
+		wm8350_wdt_stop(wm8350);
+	else
+		dev_warn(wm8350->dev, "Watchdog device closed uncleanly\n");
+
+	clear_bit(1, &wm8350_wdt_users);
+
+	return 0;
+}
+
+static ssize_t wm8350_wdt_write(struct file *file,
+				const char __user *data, size_t count,
+				loff_t *ppos)
+{
+	struct wm8350 *wm8350 = get_wm8350();
+	size_t i;
+
+	if (count) {
+		wm8350_wdt_kick(wm8350);
+
+		if (!nowayout) {
+			/* In case it was set long ago */
+			wm8350_wdt_expect_close = 0;
+
+			/* scan to see whether or not we got the magic
+			   character */
+			for (i = 0; i != count; i++) {
+				char c;
+				if (get_user(c, data + i))
+					return -EFAULT;
+				if (c == 'V')
+					wm8350_wdt_expect_close = 42;
+			}
+		}
+	}
+	return count;
+}
+
+static struct watchdog_info ident = {
+	.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING | WDIOF_MAGICCLOSE,
+	.identity = "WM8350 Watchdog",
+};
+
+static int wm8350_wdt_ioctl(struct inode *inode, struct file *file,
+			    unsigned int cmd, unsigned long arg)
+{
+	struct wm8350 *wm8350 = get_wm8350();
+	int ret = -ENOTTY, time, i;
+	void __user *argp = (void __user *)arg;
+	int __user *p = argp;
+	u16 reg;
+
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		ret = copy_to_user(argp, &ident, sizeof(ident)) ? -EFAULT : 0;
+		break;
+
+	case WDIOC_GETSTATUS:
+		ret = put_user(0, p);
+		break;
+
+	case WDIOC_SETTIMEOUT:
+		ret = get_user(time, p);
+		if (ret)
+			break;
+
+		if (time == 0) {
+			if (nowayout)
+				ret = -EINVAL;
+			else
+				wm8350_wdt_stop(wm8350);
+			break;
+		}
+
+		for (i = 0; i < ARRAY_SIZE(wm8350_wdt_cfgs); i++)
+			if (wm8350_wdt_cfgs[i].time == time)
+				break;
+		if (i == ARRAY_SIZE(wm8350_wdt_cfgs))
+			ret = -EINVAL;
+		else
+			ret = wm8350_wdt_set_timeout(wm8350,
+						     wm8350_wdt_cfgs[i].val);
+		break;
+
+	case WDIOC_GETTIMEOUT:
+		reg = wm8350_reg_read(wm8350, WM8350_SYSTEM_CONTROL_2);
+		reg &= WM8350_WDOG_TO_MASK;
+		for (i = 0; i < ARRAY_SIZE(wm8350_wdt_cfgs); i++)
+			if (wm8350_wdt_cfgs[i].val == reg)
+				break;
+		if (i == ARRAY_SIZE(wm8350_wdt_cfgs)) {
+			dev_warn(wm8350->dev,
+				 "Unknown watchdog configuration: %x\n", reg);
+			ret = -EINVAL;
+		} else
+			ret = put_user(wm8350_wdt_cfgs[i].time, p);
+		break;
+
+	case WDIOC_KEEPALIVE:
+		ret = wm8350_wdt_kick(wm8350);
+		break;
+
+	case WDIOC_SETOPTIONS:
+	{
+		int options;
+
+		if (get_user(options, p))
+			return -EFAULT;
+
+		ret = -EINVAL;
+
+		/* Setting both simultaneously means at least one must fail */
+		if (options == WDIOS_DISABLECARD)
+			ret = wm8350_wdt_start(wm8350);
+
+		if (options == WDIOS_ENABLECARD)
+			ret = wm8350_wdt_stop(wm8350);
+	}
+
+	}
+
+	return ret;
+}
+
+static const struct file_operations wm8350_wdt_fops = {
+	.owner = THIS_MODULE,
+	.llseek = no_llseek,
+	.write = wm8350_wdt_write,
+	.ioctl = wm8350_wdt_ioctl,
+	.open = wm8350_wdt_open,
+	.release = wm8350_wdt_release,
+};
+
+static struct miscdevice wm8350_wdt_miscdev = {
+	.minor = WATCHDOG_MINOR,
+	.name = "watchdog",
+	.fops = &wm8350_wdt_fops,
+};
+
+static int wm8350_wdt_probe(struct platform_device *pdev)
+{
+	struct wm8350 *wm8350 = platform_get_drvdata(pdev);
+
+	if (!wm8350) {
+		dev_err(wm8350->dev, "No driver data supplied\n");
+		return -ENODEV;
+	}
+
+	/* Default to 4s timeout */
+	wm8350_wdt_set_timeout(wm8350, 0x05);
+
+	wm8350_wdt_miscdev.parent = &pdev->dev;
+
+	return misc_register(&wm8350_wdt_miscdev);
+}
+
+static int __exit wm8350_wdt_remove(struct platform_device *pdev)
+{
+	misc_deregister(&wm8350_wdt_miscdev);
+
+	return 0;
+}
+
+static struct platform_driver wm8350_wdt_driver = {
+	.probe = wm8350_wdt_probe,
+	.remove = wm8350_wdt_remove,
+	.driver = {
+		.name = "wm8350-wdt",
+	},
+};
+
+static int __init wm8350_wdt_init(void)
+{
+	return platform_driver_register(&wm8350_wdt_driver);
+}
+module_init(wm8350_wdt_init);
+
+static void __exit wm8350_wdt_exit(void)
+{
+	platform_driver_unregister(&wm8350_wdt_driver);
+}
+module_exit(wm8350_wdt_exit);
+
+MODULE_AUTHOR("Mark Brown");
+MODULE_DESCRIPTION("WM8350 Watchdog");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:wm8350-wdt");
diff --git a/include/linux/mfd/wm8350/core.h b/include/linux/mfd/wm8350/core.h
index 348101c..5df704f 100644
--- a/include/linux/mfd/wm8350/core.h
+++ b/include/linux/mfd/wm8350/core.h
@@ -18,6 +18,7 @@
 #include <linux/workqueue.h>
 
 #include <linux/mfd/wm8350/pmic.h>
+#include <linux/mfd/wm8350/wdt.h>
 
 /*
  * Register values.
@@ -575,6 +576,7 @@ struct wm8350 {
 
 	/* Client devices */
 	struct wm8350_pmic pmic;
+	struct wm8350_wdt wdt;
 };
 
 /**
diff --git a/include/linux/mfd/wm8350/wdt.h b/include/linux/mfd/wm8350/wdt.h
index 72fc9f5..f6135b5 100644
--- a/include/linux/mfd/wm8350/wdt.h
+++ b/include/linux/mfd/wm8350/wdt.h
@@ -1,7 +1,7 @@
 /*
  * wdt.h  --  Watchdog Driver for Wolfson WM8350 PMIC
  *
- * Copyright 2007 Wolfson Microelectronics PLC
+ * Copyright 2007, 2008 Wolfson Microelectronics PLC
  *
  *  This program is free software; you can redistribute  it and/or modify it
  *  under  the terms of  the GNU General  Public License as published by the
@@ -12,6 +12,8 @@
 #ifndef __LINUX_MFD_WM8350_WDT_H_
 #define __LINUX_MFD_WM8350_WDT_H_
 
+#include <linux/platform_device.h>
+
 #define WM8350_WDOG_HIB_MODE                    0x0080
 #define WM8350_WDOG_DEBUG                       0x0040
 #define WM8350_WDOG_MODE_MASK                   0x0030
@@ -19,4 +21,8 @@
 
 #define WM8350_IRQ_SYS_WDOG_TO			24
 
+struct wm8350_wdt {
+	struct platform_device *pdev;
+};
+
 #endif
-- 
1.5.6.5

