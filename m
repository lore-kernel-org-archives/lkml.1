Return-Path: <linux-kernel-owner+w=401wt.eu-S1761941AbYESNWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761941AbYESNWh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:22:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759656AbYESNR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:17:59 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45834 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760038AbYESNR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:17:57 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 15/57] indydog: Clean up and tidy
To: akpm@osdl.org, linux-kernel@vger.kernel.org, wim@iguana.be
Date: Mon, 19 May 2008 14:06:08 +0100
Message-ID: <20080519130608.31722.82375.stgit@core>
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

Switch to unlocked_ioctl as well
---

 drivers/watchdog/indydog.c |  114 ++++++++++++++++++++++++--------------------
 1 files changed, 62 insertions(+), 52 deletions(-)


diff --git a/drivers/watchdog/indydog.c b/drivers/watchdog/indydog.c
index 788245b..0bffea3 100644
--- a/drivers/watchdog/indydog.c
+++ b/drivers/watchdog/indydog.c
@@ -1,7 +1,8 @@
 /*
  *	IndyDog	0.3	A Hardware Watchdog Device for SGI IP22
  *
- *	(c) Copyright 2002 Guido Guenther <agx@sigxcpu.org>, All Rights Reserved.
+ *	(c) Copyright 2002 Guido Guenther <agx@sigxcpu.org>,
+ *						All Rights Reserved.
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
@@ -22,32 +23,42 @@
 #include <linux/notifier.h>
 #include <linux/reboot.h>
 #include <linux/init.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <asm/sgi/mc.h>
 
 #define PFX "indydog: "
-static int indydog_alive;
+static unsigned long indydog_alive;
+static spinlock_t indydog_lock;
 
 #define WATCHDOG_TIMEOUT 30		/* 30 sec default timeout */
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+		"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 static void indydog_start(void)
 {
-	u32 mc_ctrl0 = sgimc->cpuctrl0;
+	u32 mc_ctrl0;
 
+	spin_lock(&indydog_lock);
+	mc_ctrl0 = sgimc->cpuctrl0;
 	mc_ctrl0 = sgimc->cpuctrl0 | SGIMC_CCTRL0_WDOG;
 	sgimc->cpuctrl0 = mc_ctrl0;
+	spin_unlock(&indydog_lock);
 }
 
 static void indydog_stop(void)
 {
-	u32 mc_ctrl0 = sgimc->cpuctrl0;
+	u32 mc_ctrl0;
 
+	spin_lock(&indydog_lock);
+
+	mc_ctrl0 = sgimc->cpuctrl0;
 	mc_ctrl0 &= ~SGIMC_CCTRL0_WDOG;
 	sgimc->cpuctrl0 = mc_ctrl0;
+	spin_unlock(&indydog_lock);
 
 	printk(KERN_INFO PFX "Stopped watchdog timer.\n");
 }
@@ -62,7 +73,7 @@ static void indydog_ping(void)
  */
 static int indydog_open(struct inode *inode, struct file *file)
 {
-	if (indydog_alive)
+	if (test_and_set_bit(0, &indydog_alive))
 		return -EBUSY;
 
 	if (nowayout)
@@ -84,23 +95,21 @@ static int indydog_release(struct inode *inode, struct file *file)
 	 * Lock it in if it's a module and we defined ...NOWAYOUT */
 	if (!nowayout)
 		indydog_stop();		/* Turn the WDT off */
-
-	indydog_alive = 0;
-
+	clear_bit(0, &indydog_alive);
 	return 0;
 }
 
-static ssize_t indydog_write(struct file *file, const char *data, size_t len, loff_t *ppos)
+static ssize_t indydog_write(struct file *file, const char *data,
+						size_t len, loff_t *ppos)
 {
 	/* Refresh the timer. */
-	if (len) {
+	if (len)
 		indydog_ping();
-	}
 	return len;
 }
 
-static int indydog_ioctl(struct inode *inode, struct file *file,
-	unsigned int cmd, unsigned long arg)
+static long indydog_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
 	int options, retval = -EINVAL;
 	static struct watchdog_info ident = {
@@ -111,42 +120,40 @@ static int indydog_ioctl(struct inode *inode, struct file *file,
 	};
 
 	switch (cmd) {
-		default:
-			return -ENOTTY;
-		case WDIOC_GETSUPPORT:
-			if (copy_to_user((struct watchdog_info *)arg,
-					 &ident, sizeof(ident)))
-				return -EFAULT;
-			return 0;
-		case WDIOC_GETSTATUS:
-		case WDIOC_GETBOOTSTATUS:
-			return put_user(0,(int *)arg);
-		case WDIOC_KEEPALIVE:
-			indydog_ping();
-			return 0;
-		case WDIOC_GETTIMEOUT:
-			return put_user(WATCHDOG_TIMEOUT,(int *)arg);
-		case WDIOC_SETOPTIONS:
-		{
-			if (get_user(options, (int *)arg))
-				return -EFAULT;
-
-			if (options & WDIOS_DISABLECARD) {
-				indydog_stop();
-				retval = 0;
-			}
-
-			if (options & WDIOS_ENABLECARD) {
-				indydog_start();
-				retval = 0;
-			}
-
-			return retval;
+	case WDIOC_GETSUPPORT:
+		if (copy_to_user((struct watchdog_info *)arg,
+				 &ident, sizeof(ident)))
+			return -EFAULT;
+		return 0;
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, (int *)arg);
+	case WDIOC_KEEPALIVE:
+		indydog_ping();
+		return 0;
+	case WDIOC_GETTIMEOUT:
+		return put_user(WATCHDOG_TIMEOUT, (int *)arg);
+	case WDIOC_SETOPTIONS:
+	{
+		if (get_user(options, (int *)arg))
+			return -EFAULT;
+		if (options & WDIOS_DISABLECARD) {
+			indydog_stop();
+			retval = 0;
+		}
+		if (options & WDIOS_ENABLECARD) {
+			indydog_start();
+			retval = 0;
 		}
+		return retval;
+	}
+	default:
+		return -ENOTTY;
 	}
 }
 
-static int indydog_notify_sys(struct notifier_block *this, unsigned long code, void *unused)
+static int indydog_notify_sys(struct notifier_block *this,
+					unsigned long code, void *unused)
 {
 	if (code == SYS_DOWN || code == SYS_HALT)
 		indydog_stop();		/* Turn the WDT off */
@@ -158,7 +165,7 @@ static const struct file_operations indydog_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= indydog_write,
-	.ioctl		= indydog_ioctl,
+	.unlocked_ioctl	= indydog_ioctl,
 	.open		= indydog_open,
 	.release	= indydog_release,
 };
@@ -180,17 +187,20 @@ static int __init watchdog_init(void)
 {
 	int ret;
 
+	spin_lock_init(&indydog_lock);
+
 	ret = register_reboot_notifier(&indydog_notifier);
 	if (ret) {
-		printk(KERN_ERR PFX "cannot register reboot notifier (err=%d)\n",
-			ret);
+		printk(KERN_ERR PFX
+			"cannot register reboot notifier (err=%d)\n", ret);
 		return ret;
 	}
 
 	ret = misc_register(&indydog_miscdev);
 	if (ret) {
-		printk(KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
-			WATCHDOG_MINOR, ret);
+		printk(KERN_ERR PFX
+			"cannot register miscdev on minor=%d (err=%d)\n",
+							WATCHDOG_MINOR, ret);
 		unregister_reboot_notifier(&indydog_notifier);
 		return ret;
 	}

