Return-Path: <linux-kernel-owner+w=401wt.eu-S1756345AbXFFOET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345AbXFFOET (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 10:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751113AbXFFOEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 10:04:13 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:64960 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750949AbXFFOEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 10:04:11 -0400
From: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
To: linux-kernel@vger.kernel.org
Cc: Hans-Christian Egtvedt <hcegtvedt@atmel.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [PATCH 1/1] Watchdog driver for AT32AP700X devices
Date: Wed,  6 Jun 2007 16:04:07 +0200
Message-Id: <1181138647434-git-send-email-hcegtvedt@atmel.com>
X-Mailer: git-send-email 1.4.4.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the built in watchdog in AT32AP700X devices.

Tested on AT32AP7000 and ATSTK1000.

Hardware documentation can be found in the AT32AP7000 datasheet.

Signed-off-by: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
 drivers/char/watchdog/Kconfig          |   20 ++
 drivers/char/watchdog/Makefile         |    3 +
 drivers/char/watchdog/at32ap700x_wdt.c |  313 ++++++++++++++++++++++++++++++++
 3 files changed, 336 insertions(+), 0 deletions(-)

diff --git a/drivers/char/watchdog/Kconfig b/drivers/char/watchdog/Kconfig
index e812aa1..84d9847 100644
--- a/drivers/char/watchdog/Kconfig
+++ b/drivers/char/watchdog/Kconfig
@@ -183,6 +183,26 @@ config PNX4008_WATCHDOG
 
 	  Say N if you are unsure.
 
+# AVR32 Architecture
+
+config AT32AP700X_WDT
+	tristate "AT32AP700x watchdog"
+	depends on WATCHDOG && CPU_AT32AP7000
+	help
+	  Watchdog timer embedded into AT32AP700x devices. This will reboot
+	  your system when the timeout is reached.
+
+config AT32AP700X_WDT_TIMEOUT
+	int "Timeout value for AT32AP700x watchdog"
+	depends on AT32AP700X_WDT
+	default "2"
+	range 1 2
+	help
+	  Sets the timeout value for the watchdog in AT32AP700x devices.
+	  Limited by hardware to be 1 or 2 seconds.
+
+	  Set to 2 seconds by default.
+
 # X86 (i386 + ia64 + x86_64) Architecture
 
 config ACQUIRE_WDT
diff --git a/drivers/char/watchdog/Makefile b/drivers/char/watchdog/Makefile
index 2cd8ff8..8b2a530 100644
--- a/drivers/char/watchdog/Makefile
+++ b/drivers/char/watchdog/Makefile
@@ -35,6 +35,9 @@ obj-$(CONFIG_MPCORE_WATCHDOG) += mpcore_wdt.o
 obj-$(CONFIG_EP93XX_WATCHDOG) += ep93xx_wdt.o
 obj-$(CONFIG_PNX4008_WATCHDOG) += pnx4008_wdt.o
 
+# AVR32 Architecture
+obj-$(CONFIG_AT32AP700X_WDT) += at32ap700x_wdt.o
+
 # X86 (i386 + ia64 + x86_64) Architecture
 obj-$(CONFIG_ACQUIRE_WDT) += acquirewdt.o
 obj-$(CONFIG_ADVANTECH_WDT) += advantechwdt.o
diff --git a/drivers/char/watchdog/at32ap700x_wdt.c b/drivers/char/watchdog/at32ap700x_wdt.c
new file mode 100644
index 0000000..2a01e08
--- /dev/null
+++ b/drivers/char/watchdog/at32ap700x_wdt.c
@@ -0,0 +1,313 @@
+/*
+ * Watchdog driver for Atmel AT32AP700X devices
+ *
+ * Copyright (C) 2005-2006 Atmel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/miscdevice.h>
+#include <linux/fs.h>
+#include <linux/platform_device.h>
+#include <linux/watchdog.h>
+
+#include <asm/uaccess.h>
+#include <asm/io.h>
+
+#define TIMEOUT_MIN		1
+#define TIMEOUT_DEFAULT		CONFIG_AT32AP700X_WDT_TIMEOUT
+#define TIMEOUT_MAX		2
+
+/* Watchdog registers and write/read macro */
+#define WDT_CTRL		0x00
+#define WDT_CTRL_EN		   0
+#define WDT_CTRL_PSEL		   8
+#define WDT_CTRL_KEY		  24
+
+#define WDT_CLR			0x04
+
+#define WDT_BIT(name)		(1 << WDT_##name)
+#define WDT_BF(name,value)	((value) << WDT_##name)
+
+#define wdt_readl(dev,reg)				\
+	__raw_readl((dev)->regs + WDT_##reg)
+#define wdt_writel(dev,reg,value)			\
+	__raw_writel((value), (dev)->regs + WDT_##reg)
+
+struct wdt_at32ap700x {
+	void __iomem		*regs;
+	int			timeout;
+	int			users;
+	struct miscdevice	miscdev;
+};
+
+static struct wdt_at32ap700x *wdt;
+
+/*
+ * Disable the watchdog.
+ */
+static void inline at32_wdt_stop(void)
+{
+	unsigned long psel = wdt_readl(wdt, CTRL) & WDT_BF(CTRL_PSEL, 0x0f);
+	wdt_writel(wdt, CTRL, psel | WDT_BF(CTRL_KEY, 0x55));
+	wdt_writel(wdt, CTRL, psel | WDT_BF(CTRL_KEY, 0xaa));
+}
+
+/*
+ * Enable and reset the watchdog.
+ */
+static void inline at32_wdt_start(void)
+{
+	/* 0xf is 2^16 divider = 2 sec, 0xe is 2^15 divider = 1 sec */
+	unsigned long psel = (wdt->timeout > 1) ? 0xf : 0xe;
+
+	wdt_writel(wdt, CTRL, WDT_BIT(CTRL_EN)
+			| WDT_BF(CTRL_PSEL, psel)
+			| WDT_BF(CTRL_KEY, 0x55));
+	wdt_writel(wdt, CTRL, WDT_BIT(CTRL_EN)
+			| WDT_BF(CTRL_PSEL, psel)
+			| WDT_BF(CTRL_KEY, 0xaa));
+}
+
+/*
+ * Pat the watchdog timer.
+ */
+static void inline at32_wdt_pat(void)
+{
+	wdt_writel(wdt, CLR, 0x42);
+}
+
+/*
+ * Watchdog device is opened, and watchdog starts running.
+ */
+static int at32_wdt_open(struct inode *inode, struct file *file)
+{
+	if (test_and_set_bit(1, &wdt->users))
+		return -EBUSY;
+
+	at32_wdt_start();
+	return nonseekable_open(inode, file);
+}
+
+/*
+ * Close the watchdog device. If CONFIG_WATCHDOG_NOWAYOUT is _not_ defined then
+ * the watchdog is also disabled.
+ */
+static int at32_wdt_close(struct inode *inode, struct file *file)
+{
+#ifndef CONFIG_WATCHDOG_NOWAYOUT
+	at32_wdt_stop();
+#endif
+	clear_bit(1, &wdt->users);
+	return 0;
+}
+
+/*
+ * Change the watchdog time interval.
+ */
+static int at32_wdt_settimeout(int time)
+{
+	/*
+	 * All counting occurs at 1 / SLOW_CLOCK (32 kHz) and max prescaler is
+	 * 2 ^ 16 allowing up to 2 seconds timeout.
+	 */
+	if ((time < TIMEOUT_MIN) || (time > TIMEOUT_MAX))
+		return -EINVAL;
+
+	/* Set new watchdog time. It will be used when at32_wdt_start() is called. */
+	wdt->timeout = time;
+	return 0;
+}
+
+static struct watchdog_info at32_wdt_info = {
+	.identity	= "at32ap700x watchdog",
+	.options	= WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
+};
+
+/*
+ * Handle commands from user-space.
+ */
+static int at32_wdt_ioctl(struct inode *inode, struct file *file,
+		unsigned int cmd, unsigned long arg)
+{
+	int ret = -ENOTTY;
+	int time;
+	void __user *argp = (void __user *)arg;
+	int __user *p = argp;
+
+	switch(cmd) {
+	case WDIOC_KEEPALIVE:
+		at32_wdt_pat();
+		ret = 0;
+		break;
+	case WDIOC_GETSUPPORT:
+		ret = copy_to_user(argp, &at32_wdt_info,
+				sizeof(at32_wdt_info)) ? -EFAULT : 0;
+		break;
+	case WDIOC_SETTIMEOUT:
+		ret = get_user(time, p);
+		if (ret)
+			break;
+		ret = at32_wdt_settimeout(time);
+		if (ret)
+			break;
+		/* Enable new time value */
+		at32_wdt_start();
+		/* fall through */
+	case WDIOC_GETTIMEOUT:
+		ret = put_user(wdt->timeout, p);
+		break;
+	case WDIOC_GETSTATUS: /* fall through */
+	case WDIOC_GETBOOTSTATUS:
+		ret = put_user(0, p);
+		break;
+	case WDIOC_SETOPTIONS:
+		ret = get_user(time, p);
+		if (ret)
+			break;
+		if (time & WDIOS_DISABLECARD)
+			at32_wdt_stop();
+		if (time & WDIOS_ENABLECARD)
+			at32_wdt_start();
+		ret = 0;
+		break;
+	}
+
+	return ret;
+}
+
+static ssize_t at32_wdt_write(struct file *file, const char *data, size_t len, loff_t *ppos)
+{
+	at32_wdt_pat();
+	return len;
+}
+
+static const struct file_operations at32_wdt_fops = {
+	.owner		= THIS_MODULE,
+	.llseek		= no_llseek,
+	.ioctl		= at32_wdt_ioctl,
+	.open		= at32_wdt_open,
+	.release	= at32_wdt_close,
+	.write		= at32_wdt_write,
+};
+
+static int __init at32_wdt_probe(struct platform_device *pdev)
+{
+	struct resource	*regs;
+	int ret;
+
+	if (wdt) {
+		dev_dbg(&pdev->dev, "only 1 wdt instance supported.\n");
+		return -EBUSY;
+	}
+
+	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!regs) {
+		dev_dbg(&pdev->dev, "missing mmio resource\n");
+		return -ENXIO;
+	}
+
+	wdt = kzalloc(sizeof(struct wdt_at32ap700x), GFP_KERNEL);
+	if (!wdt) {
+		dev_dbg(&pdev->dev, "no memory for wdt structure\n");
+		return -ENOMEM;
+	}
+
+	wdt->regs = ioremap(regs->start, regs->end - regs->start + 1);
+	wdt->users = 0;
+	wdt->miscdev.minor = WATCHDOG_MINOR;
+	wdt->miscdev.name = "watchdog";
+	wdt->miscdev.fops = &at32_wdt_fops;
+
+	if (at32_wdt_settimeout(TIMEOUT_DEFAULT)) {
+		at32_wdt_settimeout(TIMEOUT_MAX);
+		dev_dbg(&pdev->dev,
+			"default timeout invalid, set to %d sec.\n",
+			TIMEOUT_MAX);
+	}
+
+	ret = misc_register(&wdt->miscdev);
+	if (ret) {
+		dev_dbg(&pdev->dev, "failed to register wdt miscdev\n");
+		goto err_register;
+	}
+
+	platform_set_drvdata(pdev, wdt);
+	wdt->miscdev.parent = &pdev->dev;
+	dev_info(&pdev->dev, "AT32AP700X WDT at 0x%p\n", wdt->regs);
+
+	return 0;
+
+err_register:
+	kfree(wdt);
+	wdt = NULL;
+	return ret;
+}
+
+static int __exit at32_wdt_remove(struct platform_device *pdev)
+{
+	if (wdt && platform_get_drvdata(pdev) == wdt) {
+		misc_deregister(&wdt->miscdev);
+		kfree(wdt);
+		wdt = NULL;
+		platform_set_drvdata(pdev, NULL);
+	}
+
+	return 0;
+}
+
+static void at32_wdt_shutdown(struct platform_device *pdev)
+{
+	at32_wdt_stop();
+}
+
+#ifdef CONFIG_PM
+static int at32_wdt_suspend(struct platform_device *pdev, pm_message_t message)
+{
+	at32_wdt_stop();
+	return 0;
+}
+
+static int at32_wdt_resume(struct platform_device *pdev)
+{
+	if (wdt->users)
+		at32_wdt_start();
+	return 0;
+}
+#endif
+
+static struct platform_driver at32_wdt_driver = {
+	.remove		= __exit_p(at32_wdt_remove),
+#ifdef CONFIG_PM
+	.suspend	= at32_wdt_suspend,
+	.resume		= at32_wdt_resume,
+#endif
+	.driver		= {
+		.name	= "at32_wdt",
+		.owner	= THIS_MODULE,
+	},
+	.shutdown	= at32_wdt_shutdown,
+};
+
+static int __init at32_wdt_init(void)
+{
+	return platform_driver_probe(&at32_wdt_driver, at32_wdt_probe);
+}
+module_init(at32_wdt_init);
+
+static void __exit at32_wdt_exit(void)
+{
+	platform_driver_unregister(&at32_wdt_driver);
+}
+module_exit(at32_wdt_exit);
+
+MODULE_AUTHOR("Hans-Christian Egtvedt <hcegtvedt@atmel.com>");
+MODULE_DESCRIPTION("Watchdog driver for Atmel AT32AP700X");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
-- 
1.4.4.2

