Return-Path: <linux-kernel-owner+w=401wt.eu-S1755462AbYBYK6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462AbYBYK6W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 05:58:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753084AbYBYK6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 05:58:15 -0500
Received: from mx1.minet.net ([157.159.40.25]:35699 "EHLO mx1.minet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751986AbYBYK6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 05:58:13 -0500
X-Greylist: delayed 626 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Feb 2008 05:58:13 EST
From: Florian Fainelli <florian.fainelli@telecomint.eu>
Date: Mon, 25 Feb 2008 11:44:07 +0100
Subject: [PATCH][x86] rdc321x: remove watchdog file
MIME-Version: 1.0
X-Length: 8699
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802251144.08962.florian.fainelli@telecomint.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver should be moved to drivers/watchdog so let's
remove the arch/x86/mach-rdc321x/wdt.c file.

Signed-off-by: Florian Fainelli <florian.fainelli@telecomint.eu>
---
diff --git a/arch/x86/mach-rdc321x/Makefile b/arch/x86/mach-rdc321x/Makefile
index 1faac81..8325b4c 100644
--- a/arch/x86/mach-rdc321x/Makefile
+++ b/arch/x86/mach-rdc321x/Makefile
@@ -1,5 +1,5 @@
 #
 # Makefile for the RDC321x specific parts of the kernel
 #
-obj-$(CONFIG_X86_RDC321X)        := gpio.o platform.o wdt.o
+obj-$(CONFIG_X86_RDC321X)        := gpio.o platform.o
 
diff --git a/arch/x86/mach-rdc321x/wdt.c b/arch/x86/mach-rdc321x/wdt.c
deleted file mode 100644
index ec5625a..0000000
--- a/arch/x86/mach-rdc321x/wdt.c
+++ /dev/null
@@ -1,275 +0,0 @@
-/*
- * RDC321x watchdog driver
- *
- * Copyright (C) 2007 Florian Fainelli <florian@openwrt.org>
- *
- * This driver is highly inspired from the cpu5_wdt driver
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- *
- */
-
-#include <linux/module.h>
-#include <linux/moduleparam.h>
-#include <linux/types.h>
-#include <linux/errno.h>
-#include <linux/miscdevice.h>
-#include <linux/fs.h>
-#include <linux/init.h>
-#include <linux/ioport.h>
-#include <linux/timer.h>
-#include <linux/completion.h>
-#include <linux/jiffies.h>
-#include <linux/platform_device.h>
-#include <linux/watchdog.h>
-#include <linux/io.h>
-#include <linux/uaccess.h>
-
-#include <asm/mach-rdc321x/rdc321x_defs.h>
-
-#define RDC_WDT_MASK	0x80000000 /* Mask */
-#define RDC_WDT_EN	0x00800000 /* Enable bit */
-#define RDC_WDT_WTI	0x00200000 /* Generate CPU reset/NMI/WDT on timeout */
-#define RDC_WDT_RST	0x00100000 /* Reset bit */
-#define RDC_WDT_WIF	0x00040000 /* WDT IRQ Flag */
-#define RDC_WDT_IRT	0x00000100 /* IRQ Routing table */
-#define RDC_WDT_CNT	0x00000001 /* WDT count */
-
-#define RDC_CLS_TMR	0x80003844 /* Clear timer */
-
-#define RDC_WDT_INTERVAL	(HZ/10+1)
-
-int nowayout = WATCHDOG_NOWAYOUT;
-module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
-
-static int ticks = 1000;
-
-/* some device data */
-
-static struct {
-	struct completion stop;
-	volatile int running;
-	struct timer_list timer;
-	volatile int queue;
-	int default_ticks;
-	unsigned long inuse;
-} rdc321x_wdt_device;
-
-/* generic helper functions */
-
-static void rdc321x_wdt_trigger(unsigned long unused)
-{
-	if (rdc321x_wdt_device.running)
-		ticks--;
-
-	/* keep watchdog alive */
-	outl(RDC_WDT_EN|inl(RDC3210_CFGREG_DATA), RDC3210_CFGREG_DATA);
-
-	/* requeue?? */
-	if (rdc321x_wdt_device.queue && ticks)
-		mod_timer(&rdc321x_wdt_device.timer,
-				jiffies + RDC_WDT_INTERVAL);
-	else {
-		/* ticks doesn't matter anyway */
-		complete(&rdc321x_wdt_device.stop);
-	}
-
-}
-
-static void rdc321x_wdt_reset(void)
-{
-	ticks = rdc321x_wdt_device.default_ticks;
-}
-
-static void rdc321x_wdt_start(void)
-{
-	if (!rdc321x_wdt_device.queue) {
-		rdc321x_wdt_device.queue = 1;
-
-		/* Clear the timer */
-		outl(RDC_CLS_TMR, RDC3210_CFGREG_ADDR);
-
-		/* Enable watchdog and set the timeout to 81.92 us */
-		outl(RDC_WDT_EN|RDC_WDT_CNT, RDC3210_CFGREG_DATA);
-
-		mod_timer(&rdc321x_wdt_device.timer,
-				jiffies + RDC_WDT_INTERVAL);
-	}
-
-	/* if process dies, counter is not decremented */
-	rdc321x_wdt_device.running++;
-}
-
-static int rdc321x_wdt_stop(void)
-{
-	if (rdc321x_wdt_device.running)
-		rdc321x_wdt_device.running = 0;
-
-	ticks = rdc321x_wdt_device.default_ticks;
-
-	return -EIO;
-}
-
-/* filesystem operations */
-
-static int rdc321x_wdt_open(struct inode *inode, struct file *file)
-{
-	if (test_and_set_bit(0, &rdc321x_wdt_device.inuse))
-		return -EBUSY;
-
-	return nonseekable_open(inode, file);
-}
-
-static int rdc321x_wdt_release(struct inode *inode, struct file *file)
-{
-	clear_bit(0, &rdc321x_wdt_device.inuse);
-	return 0;
-}
-
-static int rdc321x_wdt_ioctl(struct inode *inode, struct file *file,
-				unsigned int cmd, unsigned long arg)
-{
-	void __user *argp = (void __user *)arg;
-	unsigned int value;
-	static struct watchdog_info ident = {
-		.options = WDIOF_CARDRESET,
-		.identity = "RDC321x WDT",
-	};
-
-	switch (cmd) {
-	case WDIOC_KEEPALIVE:
-		rdc321x_wdt_reset();
-		break;
-	case WDIOC_GETSTATUS:
-		/* Read the value from the DATA register */
-		value = inl(RDC3210_CFGREG_DATA);
-		if (copy_to_user(argp, &value, sizeof(int)))
-			return -EFAULT;
-		break;
-	case WDIOC_GETSUPPORT:
-		if (copy_to_user(argp, &ident, sizeof(ident)))
-			return -EFAULT;
-		break;
-	case WDIOC_SETOPTIONS:
-		if (copy_from_user(&value, argp, sizeof(int)))
-			return -EFAULT;
-		switch (value) {
-		case WDIOS_ENABLECARD:
-			rdc321x_wdt_start();
-			break;
-		case WDIOS_DISABLECARD:
-			return rdc321x_wdt_stop();
-		default:
-			return -EINVAL;
-		}
-		break;
-	default:
-		return -ENOTTY;
-	}
-	return 0;
-}
-
-static ssize_t rdc321x_wdt_write(struct file *file, const char __user *buf,
-				size_t count, loff_t *ppos)
-{
-	if (!count)
-		return -EIO;
-
-	rdc321x_wdt_reset();
-
-	return count;
-}
-
-static const struct file_operations rdc321x_wdt_fops = {
-	.owner		= THIS_MODULE,
-	.llseek		= no_llseek,
-	.ioctl		= rdc321x_wdt_ioctl,
-	.open		= rdc321x_wdt_open,
-	.write		= rdc321x_wdt_write,
-	.release	= rdc321x_wdt_release,
-};
-
-static struct miscdevice rdc321x_wdt_misc = {
-	.minor	= WATCHDOG_MINOR,
-	.name	= "watchdog",
-	.fops	= &rdc321x_wdt_fops,
-};
-
-static int __devinit rdc321x_wdt_probe(struct platform_device *pdev)
-{
-	int err;
-
-	err = misc_register(&rdc321x_wdt_misc);
-	if (err < 0) {
-		printk(KERN_ERR PFX "watchdog misc_register failed\n");
-		return err;
-	}
-
-	/* Reset the watchdog */
-	outl(RDC_WDT_RST, RDC3210_CFGREG_DATA);
-
-	init_completion(&rdc321x_wdt_device.stop);
-	rdc321x_wdt_device.queue = 0;
-
-	clear_bit(0, &rdc321x_wdt_device.inuse);
-
-	setup_timer(&rdc321x_wdt_device.timer, rdc321x_wdt_trigger, 0);
-
-	rdc321x_wdt_device.default_ticks = ticks;
-
-	printk(KERN_INFO PFX "watchdog init success\n");
-
-	return 0;
-}
-
-static int rdc321x_wdt_remove(struct platform_device *pdev)
-{
-	if (rdc321x_wdt_device.queue) {
-		rdc321x_wdt_device.queue = 0;
-		wait_for_completion(&rdc321x_wdt_device.stop);
-	}
-
-	misc_deregister(&rdc321x_wdt_misc);
-
-	return 0;
-}
-
-static struct platform_driver rdc321x_wdt_driver = {
-	.probe = rdc321x_wdt_probe,
-	.remove = rdc321x_wdt_remove,
-	.driver = {
-		.owner = THIS_MODULE,
-		.name = "rdc321x-wdt",
-	},
-};
-
-static int __init rdc321x_wdt_init(void)
-{
-	return platform_driver_register(&rdc321x_wdt_driver);
-}
-
-static void __exit rdc321x_wdt_exit(void)
-{
-	platform_driver_unregister(&rdc321x_wdt_driver);
-}
-
-module_init(rdc321x_wdt_init);
-module_exit(rdc321x_wdt_exit);
-
-MODULE_AUTHOR("Florian Fainelli <florian@openwrt.org>");
-MODULE_DESCRIPTION("RDC321x watchdog driver");
-MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
