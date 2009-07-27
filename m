Return-Path: <linux-kernel-owner+w=401wt.eu-S1755645AbZG0NuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645AbZG0NuP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 09:50:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754718AbZG0Nt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 09:49:58 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59116 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754606AbZG0Nq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 09:46:27 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Wim Van Sebroeck <wim@iguana.be>
Subject: [PATCH 22/22] [WATCHDOG] Add support for WM831x watchdog
Date: Mon, 27 Jul 2009 14:46:12 +0100
Message-Id: <1248702372-29534-22-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <20090727134527.GA12849@rakim.wolfsonmicro.main>
References: <20090727134527.GA12849@rakim.wolfsonmicro.main>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The WM831x series of devices provide a watchdog with configurable
behaviour on timer expiry.

Currently this driver support refreshes via a register or GPIO line and
autonomous refreshes from a hardware source (eg, a clock).

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Wim Van Sebroeck <wim@iguana.be>
---
 drivers/watchdog/Kconfig            |    7 +
 drivers/watchdog/Makefile           |    1 +
 drivers/watchdog/wm831x_wdt.c       |  441 +++++++++++++++++++++++++++++++++++
 include/linux/mfd/wm831x/watchdog.h |   52 ++++
 4 files changed, 501 insertions(+), 0 deletions(-)
 create mode 100644 drivers/watchdog/wm831x_wdt.c
 create mode 100644 include/linux/mfd/wm831x/watchdog.h

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index b1ccc04..2d22ab6 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -55,6 +55,13 @@ config SOFT_WATCHDOG
 	  To compile this driver as a module, choose M here: the
 	  module will be called softdog.
 
+config WM831X_WATCHDOG
+	tristate "WM831x watchdog"
+	depends on MFD_WM831X
+	help
+	  Support for the watchdog in the WM831x AudioPlus PMICs.  When
+	  the watchdog triggers the system will be reset.
+
 config WM8350_WATCHDOG
 	tristate "WM8350 watchdog"
 	depends on MFD_WM8350
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index 3d77429..244be98 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -139,5 +139,6 @@ obj-$(CONFIG_WATCHDOG_CP1XXX)		+= cpwd.o
 # XTENSA Architecture
 
 # Architecture Independant
+obj-$(CONFIG_WM831X_WATCHDOG) += wm831x_wdt.o
 obj-$(CONFIG_WM8350_WATCHDOG) += wm8350_wdt.o
 obj-$(CONFIG_SOFT_WATCHDOG) += softdog.o
diff --git a/drivers/watchdog/wm831x_wdt.c b/drivers/watchdog/wm831x_wdt.c
new file mode 100644
index 0000000..775bcd8
--- /dev/null
+++ b/drivers/watchdog/wm831x_wdt.c
@@ -0,0 +1,441 @@
+/*
+ * Watchdog driver for the wm831x PMICs
+ *
+ * Copyright (C) 2009 Wolfson Microelectronics
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
+#include <linux/gpio.h>
+
+#include <linux/mfd/wm831x/core.h>
+#include <linux/mfd/wm831x/pdata.h>
+#include <linux/mfd/wm831x/watchdog.h>
+
+static int nowayout = WATCHDOG_NOWAYOUT;
+module_param(nowayout, int, 0);
+MODULE_PARM_DESC(nowayout,
+		 "Watchdog cannot be stopped once started (default="
+		 __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+
+static unsigned long wm831x_wdt_users;
+static struct miscdevice wm831x_wdt_miscdev;
+static int wm831x_wdt_expect_close;
+static DEFINE_MUTEX(wdt_mutex);
+static struct wm831x *wm831x;
+static unsigned int update_gpio;
+static unsigned int update_state;
+
+/* We can't use the sub-second values here but they're included
+ * for completeness.  */
+static struct {
+	int time;  /* Seconds */
+	u16 val;   /* WDOG_TO value */
+} wm831x_wdt_cfgs[] = {
+	{  1, 2 },
+	{  2, 3 },
+	{  4, 4 },
+	{  8, 5 },
+	{ 16, 6 },
+	{ 32, 7 },
+	{ 33, 7 },  /* Actually 32.768s so include both, others round down */
+};
+
+static int wm831x_wdt_set_timeout(struct wm831x *wm831x, u16 value)
+{
+	int ret;
+
+	mutex_lock(&wdt_mutex);
+
+	ret = wm831x_reg_unlock(wm831x);
+	if (ret == 0) {
+		ret = wm831x_set_bits(wm831x, WM831X_WATCHDOG,
+				      WM831X_WDOG_TO_MASK, value);
+		wm831x_reg_lock(wm831x);
+	} else {
+		dev_err(wm831x->dev, "Failed to unlock security key: %d\n",
+			ret);
+	}
+
+	mutex_unlock(&wdt_mutex);
+
+	return ret;
+}
+
+static int wm831x_wdt_start(struct wm831x *wm831x)
+{
+	int ret;
+
+	mutex_lock(&wdt_mutex);
+
+	ret = wm831x_reg_unlock(wm831x);
+	if (ret == 0) {
+		ret = wm831x_set_bits(wm831x, WM831X_WATCHDOG,
+				      WM831X_WDOG_ENA, WM831X_WDOG_ENA);
+		wm831x_reg_lock(wm831x);
+	} else {
+		dev_err(wm831x->dev, "Failed to unlock security key: %d\n",
+			ret);
+	}
+
+	mutex_unlock(&wdt_mutex);
+
+	return ret;
+}
+
+static int wm831x_wdt_stop(struct wm831x *wm831x)
+{
+	int ret;
+
+	mutex_lock(&wdt_mutex);
+
+	ret = wm831x_reg_unlock(wm831x);
+	if (ret == 0) {
+		ret = wm831x_set_bits(wm831x, WM831X_WATCHDOG,
+				      WM831X_WDOG_ENA, 0);
+		wm831x_reg_lock(wm831x);
+	} else {
+		dev_err(wm831x->dev, "Failed to unlock security key: %d\n",
+			ret);
+	}
+
+	mutex_unlock(&wdt_mutex);
+
+	return ret;
+}
+
+static int wm831x_wdt_kick(struct wm831x *wm831x)
+{
+	int ret;
+	u16 reg;
+
+	mutex_lock(&wdt_mutex);
+
+	if (update_gpio) {
+		gpio_set_value_cansleep(update_gpio, update_state);
+		update_state = !update_state;
+		ret = 0;
+		goto out;
+	}
+
+
+	reg = wm831x_reg_read(wm831x, WM831X_WATCHDOG);
+
+	if (!(reg & WM831X_WDOG_RST_SRC)) {
+		dev_err(wm831x->dev, "Hardware watchdog update unsupported\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	reg |= WM831X_WDOG_RESET;
+
+	ret = wm831x_reg_unlock(wm831x);
+	if (ret == 0) {
+		ret = wm831x_reg_write(wm831x, WM831X_WATCHDOG, reg);
+		wm831x_reg_lock(wm831x);
+	} else {
+		dev_err(wm831x->dev, "Failed to unlock security key: %d\n",
+			ret);
+	}
+
+out:
+	mutex_unlock(&wdt_mutex);
+
+	return ret;
+}
+
+static int wm831x_wdt_open(struct inode *inode, struct file *file)
+{
+	int ret;
+
+	if (!wm831x)
+		return -ENODEV;
+
+	if (test_and_set_bit(0, &wm831x_wdt_users))
+		return -EBUSY;
+
+	ret = wm831x_wdt_start(wm831x);
+	if (ret != 0)
+		return ret;
+
+	return nonseekable_open(inode, file);
+}
+
+static int wm831x_wdt_release(struct inode *inode, struct file *file)
+{
+	if (wm831x_wdt_expect_close)
+		wm831x_wdt_stop(wm831x);
+	else {
+		dev_warn(wm831x->dev, "Watchdog device closed uncleanly\n");
+		wm831x_wdt_kick(wm831x);
+	}
+
+	clear_bit(0, &wm831x_wdt_users);
+
+	return 0;
+}
+
+static ssize_t wm831x_wdt_write(struct file *file,
+				const char __user *data, size_t count,
+				loff_t *ppos)
+{
+	size_t i;
+
+	if (count) {
+		wm831x_wdt_kick(wm831x);
+
+		if (!nowayout) {
+			/* In case it was set long ago */
+			wm831x_wdt_expect_close = 0;
+
+			/* scan to see whether or not we got the magic
+			   character */
+			for (i = 0; i != count; i++) {
+				char c;
+				if (get_user(c, data + i))
+					return -EFAULT;
+				if (c == 'V')
+					wm831x_wdt_expect_close = 42;
+			}
+		}
+	}
+	return count;
+}
+
+static struct watchdog_info ident = {
+	.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING | WDIOF_MAGICCLOSE,
+	.identity = "WM831x Watchdog",
+};
+
+static long wm831x_wdt_ioctl(struct file *file, unsigned int cmd,
+			     unsigned long arg)
+{
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
+	case WDIOC_GETBOOTSTATUS:
+		ret = put_user(0, p);
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
+			ret = wm831x_wdt_start(wm831x);
+
+		if (options == WDIOS_ENABLECARD)
+			ret = wm831x_wdt_stop(wm831x);
+		break;
+	}
+
+	case WDIOC_KEEPALIVE:
+		ret = wm831x_wdt_kick(wm831x);
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
+				wm831x_wdt_stop(wm831x);
+			break;
+		}
+
+		for (i = 0; i < ARRAY_SIZE(wm831x_wdt_cfgs); i++)
+			if (wm831x_wdt_cfgs[i].time == time)
+				break;
+		if (i == ARRAY_SIZE(wm831x_wdt_cfgs))
+			ret = -EINVAL;
+		else
+			ret = wm831x_wdt_set_timeout(wm831x,
+						     wm831x_wdt_cfgs[i].val);
+		break;
+
+	case WDIOC_GETTIMEOUT:
+		reg = wm831x_reg_read(wm831x, WM831X_WATCHDOG);
+		reg &= WM831X_WDOG_TO_MASK;
+		for (i = 0; i < ARRAY_SIZE(wm831x_wdt_cfgs); i++)
+			if (wm831x_wdt_cfgs[i].val == reg)
+				break;
+		if (i == ARRAY_SIZE(wm831x_wdt_cfgs)) {
+			dev_warn(wm831x->dev,
+				 "Unknown watchdog configuration: %x\n", reg);
+			ret = -EINVAL;
+		} else
+			ret = put_user(wm831x_wdt_cfgs[i].time, p);
+
+	}
+
+	return ret;
+}
+
+static const struct file_operations wm831x_wdt_fops = {
+	.owner = THIS_MODULE,
+	.llseek = no_llseek,
+	.write = wm831x_wdt_write,
+	.unlocked_ioctl = wm831x_wdt_ioctl,
+	.open = wm831x_wdt_open,
+	.release = wm831x_wdt_release,
+};
+
+static struct miscdevice wm831x_wdt_miscdev = {
+	.minor = WATCHDOG_MINOR,
+	.name = "watchdog",
+	.fops = &wm831x_wdt_fops,
+};
+
+static int __devinit wm831x_wdt_probe(struct platform_device *pdev)
+{
+	struct wm831x_pdata *chip_pdata;
+	struct wm831x_watchdog_pdata *pdata;
+	int reg, ret;
+
+	wm831x = dev_get_drvdata(pdev->dev.parent);
+
+	ret = wm831x_reg_read(wm831x, WM831X_WATCHDOG);
+	if (ret < 0) {
+		dev_err(wm831x->dev, "Failed to read watchdog status: %d\n",
+			ret);
+		goto err;
+	}
+	reg = ret;
+
+	if (reg & WM831X_WDOG_DEBUG)
+		dev_warn(wm831x->dev, "Watchdog is paused\n");
+
+	/* Apply any configuration */
+	if (pdev->dev.parent->platform_data) {
+		chip_pdata = pdev->dev.parent->platform_data;
+		pdata = chip_pdata->watchdog;
+	} else {
+		pdata = NULL;
+	}
+
+	if (pdata) {
+		reg &= ~(WM831X_WDOG_SECACT_MASK | WM831X_WDOG_PRIMACT_MASK |
+			 WM831X_WDOG_RST_SRC);
+
+		reg |= pdata->primary << WM831X_WDOG_PRIMACT_SHIFT;
+		reg |= pdata->secondary << WM831X_WDOG_SECACT_SHIFT;
+		reg |= pdata->software << WM831X_WDOG_RST_SRC_SHIFT;
+
+		if (pdata->update_gpio) {
+			ret = gpio_request(pdata->update_gpio,
+					   "Watchdog update");
+			if (ret < 0) {
+				dev_err(wm831x->dev,
+					"Failed to request update GPIO: %d\n",
+					ret);
+				goto err;
+			}
+
+			ret = gpio_direction_output(pdata->update_gpio, 0);
+			if (ret != 0) {
+				dev_err(wm831x->dev,
+					"gpio_direction_output returned: %d\n",
+					ret);
+				goto err_gpio;
+			}
+
+			update_gpio = pdata->update_gpio;
+
+			/* Make sure the watchdog takes hardware updates */
+			reg |= WM831X_WDOG_RST_SRC;
+		}
+
+		ret = wm831x_reg_unlock(wm831x);
+		if (ret == 0) {
+			ret = wm831x_reg_write(wm831x, WM831X_WATCHDOG, reg);
+			wm831x_reg_lock(wm831x);
+		} else {
+			dev_err(wm831x->dev,
+				"Failed to unlock security key: %d\n", ret);
+			goto err_gpio;
+		}
+	}
+
+	wm831x_wdt_miscdev.parent = &pdev->dev;
+
+	ret = misc_register(&wm831x_wdt_miscdev);
+	if (ret != 0) {
+		dev_err(wm831x->dev, "Failed to register miscdev: %d\n", ret);
+		goto err_gpio;
+	}
+
+	return 0;
+
+err_gpio:
+	if (update_gpio) {
+		gpio_free(update_gpio);
+		update_gpio = 0;
+	}
+err:
+	return ret;
+}
+
+static int __devexit wm831x_wdt_remove(struct platform_device *pdev)
+{
+	if (update_gpio) {
+		gpio_free(update_gpio);
+		update_gpio = 0;
+	}
+
+	misc_deregister(&wm831x_wdt_miscdev);
+
+	return 0;
+}
+
+static struct platform_driver wm831x_wdt_driver = {
+	.probe = wm831x_wdt_probe,
+	.remove = __devexit_p(wm831x_wdt_remove),
+	.driver = {
+		.name = "wm831x-watchdog",
+	},
+};
+
+static int __init wm831x_wdt_init(void)
+{
+	return platform_driver_register(&wm831x_wdt_driver);
+}
+module_init(wm831x_wdt_init);
+
+static void __exit wm831x_wdt_exit(void)
+{
+	platform_driver_unregister(&wm831x_wdt_driver);
+}
+module_exit(wm831x_wdt_exit);
+
+MODULE_AUTHOR("Mark Brown");
+MODULE_DESCRIPTION("WM831x Watchdog");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:wm831x-watchdog");
diff --git a/include/linux/mfd/wm831x/watchdog.h b/include/linux/mfd/wm831x/watchdog.h
new file mode 100644
index 0000000..97a99b5
--- /dev/null
+++ b/include/linux/mfd/wm831x/watchdog.h
@@ -0,0 +1,52 @@
+/*
+ * include/linux/mfd/wm831x/watchdog.h -- Watchdog for WM831x
+ *
+ * Copyright 2009 Wolfson Microelectronics PLC.
+ *
+ * Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#ifndef __MFD_WM831X_WATCHDOG_H__
+#define __MFD_WM831X_WATCHDOG_H__
+
+
+/*
+ * R16388 (0x4004) - Watchdog
+ */
+#define WM831X_WDOG_ENA                         0x8000  /* WDOG_ENA */
+#define WM831X_WDOG_ENA_MASK                    0x8000  /* WDOG_ENA */
+#define WM831X_WDOG_ENA_SHIFT                       15  /* WDOG_ENA */
+#define WM831X_WDOG_ENA_WIDTH                        1  /* WDOG_ENA */
+#define WM831X_WDOG_DEBUG                       0x4000  /* WDOG_DEBUG */
+#define WM831X_WDOG_DEBUG_MASK                  0x4000  /* WDOG_DEBUG */
+#define WM831X_WDOG_DEBUG_SHIFT                     14  /* WDOG_DEBUG */
+#define WM831X_WDOG_DEBUG_WIDTH                      1  /* WDOG_DEBUG */
+#define WM831X_WDOG_RST_SRC                     0x2000  /* WDOG_RST_SRC */
+#define WM831X_WDOG_RST_SRC_MASK                0x2000  /* WDOG_RST_SRC */
+#define WM831X_WDOG_RST_SRC_SHIFT                   13  /* WDOG_RST_SRC */
+#define WM831X_WDOG_RST_SRC_WIDTH                    1  /* WDOG_RST_SRC */
+#define WM831X_WDOG_SLPENA                      0x1000  /* WDOG_SLPENA */
+#define WM831X_WDOG_SLPENA_MASK                 0x1000  /* WDOG_SLPENA */
+#define WM831X_WDOG_SLPENA_SHIFT                    12  /* WDOG_SLPENA */
+#define WM831X_WDOG_SLPENA_WIDTH                     1  /* WDOG_SLPENA */
+#define WM831X_WDOG_RESET                       0x0800  /* WDOG_RESET */
+#define WM831X_WDOG_RESET_MASK                  0x0800  /* WDOG_RESET */
+#define WM831X_WDOG_RESET_SHIFT                     11  /* WDOG_RESET */
+#define WM831X_WDOG_RESET_WIDTH                      1  /* WDOG_RESET */
+#define WM831X_WDOG_SECACT_MASK                 0x0300  /* WDOG_SECACT - [9:8] */
+#define WM831X_WDOG_SECACT_SHIFT                     8  /* WDOG_SECACT - [9:8] */
+#define WM831X_WDOG_SECACT_WIDTH                     2  /* WDOG_SECACT - [9:8] */
+#define WM831X_WDOG_PRIMACT_MASK                0x0030  /* WDOG_PRIMACT - [5:4] */
+#define WM831X_WDOG_PRIMACT_SHIFT                    4  /* WDOG_PRIMACT - [5:4] */
+#define WM831X_WDOG_PRIMACT_WIDTH                    2  /* WDOG_PRIMACT - [5:4] */
+#define WM831X_WDOG_TO_MASK                     0x0007  /* WDOG_TO - [2:0] */
+#define WM831X_WDOG_TO_SHIFT                         0  /* WDOG_TO - [2:0] */
+#define WM831X_WDOG_TO_WIDTH                         3  /* WDOG_TO - [2:0] */
+
+#endif
-- 
1.6.3.3

