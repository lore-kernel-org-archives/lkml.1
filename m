Return-Path: <linux-kernel-owner+w=401wt.eu-S1761756AbYESN1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761756AbYESN1a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:27:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760512AbYESNTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:19:15 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45898 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759916AbYESNTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:19:13 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 28/57] mtx-1_wdt: clean up, coding style, unlocked ioctl
To: akpm@osdl.org, linux-kernel@vger.kernel.org, wim@iguana.be
Date: Mon, 19 May 2008 14:07:21 +0100
Message-ID: <20080519130720.31722.92503.stgit@core>
In-Reply-To: <20080519124659.31722.51847.stgit@core>
References: <20080519124659.31722.51847.stgit@core>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@redhat.com>


---

 drivers/watchdog/mtx-1_wdt.c |  107 ++++++++++++++++++++----------------------
 1 files changed, 52 insertions(+), 55 deletions(-)


diff --git a/drivers/watchdog/mtx-1_wdt.c b/drivers/watchdog/mtx-1_wdt.c
index a8e6738..e0b8cdf 100644
--- a/drivers/watchdog/mtx-1_wdt.c
+++ b/drivers/watchdog/mtx-1_wdt.c
@@ -1,7 +1,8 @@
 /*
  *      Driver for the MTX-1 Watchdog.
  *
- *      (C) Copyright 2005 4G Systems <info@4g-systems.biz>, All Rights Reserved.
+ *      (C) Copyright 2005 4G Systems <info@4g-systems.biz>,
+ *							All Rights Reserved.
  *                              http://www.4g-systems.biz
  *
  * 	(C) Copyright 2007 OpenWrt.org, Florian Fainelli <florian@openwrt.org>
@@ -46,12 +47,11 @@
 #include <linux/jiffies.h>
 #include <linux/watchdog.h>
 #include <linux/platform_device.h>
-
-#include <asm/io.h>
-#include <asm/uaccess.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
+#include <linux/gpio.h>
 
 #include <asm/mach-au1x00/au1000.h>
-#include <asm/gpio.h>
 
 #define MTX1_WDT_INTERVAL	(5 * HZ)
 
@@ -59,6 +59,7 @@ static int ticks = 100 * HZ;
 
 static struct {
 	struct completion stop;
+	spinlock_t lock;
 	int running;
 	struct timer_list timer;
 	int queue;
@@ -71,6 +72,7 @@ static void mtx1_wdt_trigger(unsigned long unused)
 {
 	u32 tmp;
 
+	spin_lock(&mtx1_wdt_device.lock);
 	if (mtx1_wdt_device.running)
 		ticks--;
 	/*
@@ -79,13 +81,13 @@ static void mtx1_wdt_trigger(unsigned long unused)
 	tmp = au_readl(GPIO2_DIR);
 	tmp = (tmp & ~(1 << mtx1_wdt_device.gpio)) |
 	      ((~tmp) & (1 << mtx1_wdt_device.gpio));
-	au_writel (tmp, GPIO2_DIR);
+	au_writel(tmp, GPIO2_DIR);
 
 	if (mtx1_wdt_device.queue && ticks)
 		mod_timer(&mtx1_wdt_device.timer, jiffies + MTX1_WDT_INTERVAL);
-	else {
+	else
 		complete(&mtx1_wdt_device.stop);
-	}
+	spin_unlock(&mtx1_wdt_device.lock);
 }
 
 static void mtx1_wdt_reset(void)
@@ -96,23 +98,25 @@ static void mtx1_wdt_reset(void)
 
 static void mtx1_wdt_start(void)
 {
+	spin_lock_irqsave(&mtx1_wdt_device.lock, flags);
 	if (!mtx1_wdt_device.queue) {
 		mtx1_wdt_device.queue = 1;
 		gpio_set_value(mtx1_wdt_device.gpio, 1);
 		mod_timer(&mtx1_wdt_device.timer, jiffies + MTX1_WDT_INTERVAL);
 	}
 	mtx1_wdt_device.running++;
+	spin_unlock_irqrestore(&mtx1_wdt_device.lock, flags);
 }
 
 static int mtx1_wdt_stop(void)
 {
+	spin_lock_irqsave(&mtx1_wdt_device.lock, flags);
 	if (mtx1_wdt_device.queue) {
 		mtx1_wdt_device.queue = 0;
 		gpio_set_value(mtx1_wdt_device.gpio, 0);
 	}
-
 	ticks = mtx1_wdt_device.default_ticks;
-
+	spin_unlock_irqrestore(&mtx1_wdt_device.lock, flags);
 	return 0;
 }
 
@@ -122,7 +126,6 @@ static int mtx1_wdt_open(struct inode *inode, struct file *file)
 {
 	if (test_and_set_bit(0, &mtx1_wdt_device.inuse))
 		return -EBUSY;
-
 	return nonseekable_open(inode, file);
 }
 
@@ -133,54 +136,51 @@ static int mtx1_wdt_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static int mtx1_wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
+static long mtx1_wdt_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
+	int __user *p = (int __user *)argp;
 	unsigned int value;
-	static struct watchdog_info ident =
-	{
+	static const struct watchdog_info ident = {
 		.options = WDIOF_CARDRESET,
 		.identity = "MTX-1 WDT",
 	};
 
-	switch(cmd) {
-		case WDIOC_KEEPALIVE:
-			mtx1_wdt_reset();
-			break;
-		case WDIOC_GETSTATUS:
-		case WDIOC_GETBOOTSTATUS:
-			if ( copy_to_user(argp, &value, sizeof(int)) )
-				return -EFAULT;
-			break;
-		case WDIOC_GETSUPPORT:
-			if ( copy_to_user(argp, &ident, sizeof(ident)) )
-				return -EFAULT;
-			break;
-		case WDIOC_SETOPTIONS:
-			if ( copy_from_user(&value, argp, sizeof(int)) )
-				return -EFAULT;
-			switch(value) {
-				case WDIOS_ENABLECARD:
-					mtx1_wdt_start();
-					break;
-				case WDIOS_DISABLECARD:
-					return mtx1_wdt_stop();
-				default:
-					return -EINVAL;
-			}
-			break;
-		default:
-			return -ENOTTY;
+	switch (cmd) {
+	case WDIOC_KEEPALIVE:
+		mtx1_wdt_reset();
+		break;
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		put_user(0, p);
+		break;
+	case WDIOC_GETSUPPORT:
+		if (copy_to_user(argp, &ident, sizeof(ident)))
+			return -EFAULT;
+		break;
+	case WDIOC_SETOPTIONS:
+		if (get_user(value, p))
+			return -EFAULT;
+		if (value & WDIOS_ENABLECARD)
+			mtx1_wdt_start();
+		else if (value & WDIOS_DISABLECARD)
+			mtx1_wdt_stop();
+		else
+			return -EINVAL;
+		return 0;
+	default:
+		return -ENOTTY;
 	}
 	return 0;
 }
 
 
-static ssize_t mtx1_wdt_write(struct file *file, const char *buf, size_t count, loff_t *ppos)
+static ssize_t mtx1_wdt_write(struct file *file, const char *buf,
+						size_t count, loff_t *ppos)
 {
 	if (!count)
 		return -EIO;
-
 	mtx1_wdt_reset();
 	return count;
 }
@@ -188,7 +188,7 @@ static ssize_t mtx1_wdt_write(struct file *file, const char *buf, size_t count,
 static const struct file_operations mtx1_wdt_fops = {
 	.owner 		= THIS_MODULE,
 	.llseek		= no_llseek,
-	.ioctl		= mtx1_wdt_ioctl,
+	.unlocked_ioctl	= mtx1_wdt_ioctl,
 	.open 		= mtx1_wdt_open,
 	.write 		= mtx1_wdt_write,
 	.release 	= mtx1_wdt_release
@@ -208,29 +208,26 @@ static int mtx1_wdt_probe(struct platform_device *pdev)
 
 	mtx1_wdt_device.gpio = pdev->resource[0].start;
 
-	if ((ret = misc_register(&mtx1_wdt_misc)) < 0) {
-		printk(KERN_ERR " mtx-1_wdt : failed to register\n");
-		return ret;
-	}
-
+	spin_lock_init(&mtx1_wdt_device.lock);
 	init_completion(&mtx1_wdt_device.stop);
 	mtx1_wdt_device.queue = 0;
-
 	clear_bit(0, &mtx1_wdt_device.inuse);
-
 	setup_timer(&mtx1_wdt_device.timer, mtx1_wdt_trigger, 0L);
-
 	mtx1_wdt_device.default_ticks = ticks;
 
+	ret = misc_register(&mtx1_wdt_misc);
+	if (ret < 0) {
+		printk(KERN_ERR " mtx-1_wdt : failed to register\n");
+		return ret;
+	}
 	mtx1_wdt_start();
-
 	printk(KERN_INFO "MTX-1 Watchdog driver\n");
-
 	return 0;
 }
 
 static int mtx1_wdt_remove(struct platform_device *pdev)
 {
+	/* FIXME: do we need to lock this test ? */
 	if (mtx1_wdt_device.queue) {
 		mtx1_wdt_device.queue = 0;
 		wait_for_completion(&mtx1_wdt_device.stop);

