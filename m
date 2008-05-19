Return-Path: <linux-kernel-owner+w=401wt.eu-S1762308AbYESNXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762308AbYESNXv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:23:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757837AbYESNS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:18:26 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45852 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760158AbYESNSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:18:21 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 19/57] bfin: watchdog cleanup and unlocked_ioctl
To: akpm@osdl.org, linux-kernel@vger.kernel.org, wim@iguana.be
Date: Mon, 19 May 2008 14:06:30 +0100
Message-ID: <20080519130630.31722.22996.stgit@core>
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

Scan, tidy and check for unlocked_ioctl
---

 drivers/watchdog/bfin_wdt.c |  147 +++++++++++++++++++++----------------------
 1 files changed, 71 insertions(+), 76 deletions(-)


diff --git a/drivers/watchdog/bfin_wdt.c b/drivers/watchdog/bfin_wdt.c
index 1237113..cd34652 100644
--- a/drivers/watchdog/bfin_wdt.c
+++ b/drivers/watchdog/bfin_wdt.c
@@ -25,7 +25,7 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <asm/blackfin.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 #define stamp(fmt, args...) pr_debug("%s:%i: " fmt "\n", __func__, __LINE__, ## args)
 #define stampit() stamp("here i am")
@@ -147,7 +147,8 @@ static int bfin_wdt_set_timeout(unsigned long t)
 		int run = bfin_wdt_running();
 		bfin_wdt_stop();
 		bfin_write_WDOG_CNT(cnt);
-		if (run) bfin_wdt_start();
+		if (run)
+			bfin_wdt_start();
 	}
 	spin_unlock_irqrestore(&bfin_wdt_spinlock, flags);
 
@@ -190,16 +191,15 @@ static int bfin_wdt_release(struct inode *inode, struct file *file)
 {
 	stampit();
 
-	if (expect_close == 42) {
+	if (expect_close == 42)
 		bfin_wdt_stop();
-	} else {
-		printk(KERN_CRIT PFX "Unexpected close, not stopping watchdog!\n");
+	else {
+		printk(KERN_CRIT PFX
+			"Unexpected close, not stopping watchdog!\n");
 		bfin_wdt_keepalive();
 	}
-
 	expect_close = 0;
 	clear_bit(0, &open_check);
-
 	return 0;
 }
 
@@ -213,7 +213,7 @@ static int bfin_wdt_release(struct inode *inode, struct file *file)
  *	Pings the watchdog on write.
  */
 static ssize_t bfin_wdt_write(struct file *file, const char __user *data,
-                              size_t len, loff_t *ppos)
+						size_t len, loff_t *ppos)
 {
 	stampit();
 
@@ -240,7 +240,6 @@ static ssize_t bfin_wdt_write(struct file *file, const char __user *data,
 
 /**
  *	bfin_wdt_ioctl - Query Device
- *	@inode: inode of device
  *	@file: file handle of device
  *	@cmd: watchdog command
  *	@arg: argument
@@ -248,8 +247,8 @@ static ssize_t bfin_wdt_write(struct file *file, const char __user *data,
  *	Query basic information from the device or ping it, as outlined by the
  *	watchdog API.
  */
-static int bfin_wdt_ioctl(struct inode *inode, struct file *file,
-                          unsigned int cmd, unsigned long arg)
+static long bfin_wdt_ioctl(struct file *file,
+				unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
@@ -257,59 +256,49 @@ static int bfin_wdt_ioctl(struct inode *inode, struct file *file,
 	stampit();
 
 	switch (cmd) {
-		default:
-			return -ENOTTY;
-
-		case WDIOC_GETSUPPORT:
-			if (copy_to_user(argp, &bfin_wdt_info, sizeof(bfin_wdt_info)))
-				return -EFAULT;
-			else
-				return 0;
-
-		case WDIOC_GETSTATUS:
-		case WDIOC_GETBOOTSTATUS:
-			return put_user(!!(_bfin_swrst & SWRST_RESET_WDOG), p);
-
-		case WDIOC_KEEPALIVE:
-			bfin_wdt_keepalive();
+	case WDIOC_GETSUPPORT:
+		if (copy_to_user(argp, &bfin_wdt_info, sizeof(bfin_wdt_info)))
+			return -EFAULT;
+		else
 			return 0;
-
-		case WDIOC_SETTIMEOUT: {
-			int new_timeout;
-
-			if (get_user(new_timeout, p))
-				return -EFAULT;
-
-			if (bfin_wdt_set_timeout(new_timeout))
-				return -EINVAL;
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(!!(_bfin_swrst & SWRST_RESET_WDOG), p);
+	case WDIOC_KEEPALIVE:
+		bfin_wdt_keepalive();
+		return 0;
+	case WDIOC_SETTIMEOUT: {
+		int new_timeout;
+
+		if (get_user(new_timeout, p))
+			return -EFAULT;
+		if (bfin_wdt_set_timeout(new_timeout))
+			return -EINVAL;
+	}
+	/* Fall */
+	case WDIOC_GETTIMEOUT:
+		return put_user(timeout, p);
+	case WDIOC_SETOPTIONS: {
+		unsigned long flags;
+		int options, ret = -EINVAL;
+
+		if (get_user(options, p))
+			return -EFAULT;
+
+		spin_lock_irqsave(&bfin_wdt_spinlock, flags);
+		if (options & WDIOS_DISABLECARD) {
+			bfin_wdt_stop();
+			ret = 0;
 		}
-			/* Fall */
-		case WDIOC_GETTIMEOUT:
-			return put_user(timeout, p);
-
-		case WDIOC_SETOPTIONS: {
-			unsigned long flags;
-			int options, ret = -EINVAL;
-
-			if (get_user(options, p))
-				return -EFAULT;
-
-			spin_lock_irqsave(&bfin_wdt_spinlock, flags);
-
-			if (options & WDIOS_DISABLECARD) {
-				bfin_wdt_stop();
-				ret = 0;
-			}
-
-			if (options & WDIOS_ENABLECARD) {
-				bfin_wdt_start();
-				ret = 0;
-			}
-
-			spin_unlock_irqrestore(&bfin_wdt_spinlock, flags);
-
-			return ret;
+		if (options & WDIOS_ENABLECARD) {
+			bfin_wdt_start();
+			ret = 0;
 		}
+		spin_unlock_irqrestore(&bfin_wdt_spinlock, flags);
+		return ret;
+	}
+	default:
+		return -ENOTTY;
 	}
 }
 
@@ -322,8 +311,8 @@ static int bfin_wdt_ioctl(struct inode *inode, struct file *file,
  *	Handles specific events, such as turning off the watchdog during a
  *	shutdown event.
  */
-static int bfin_wdt_notify_sys(struct notifier_block *this, unsigned long code,
-                               void *unused)
+static int bfin_wdt_notify_sys(struct notifier_block *this,
+					unsigned long code, void *unused)
 {
 	stampit();
 
@@ -392,12 +381,12 @@ static struct platform_driver bfin_wdt_driver = {
 };
 
 static const struct file_operations bfin_wdt_fops = {
-	.owner    = THIS_MODULE,
-	.llseek   = no_llseek,
-	.write    = bfin_wdt_write,
-	.ioctl    = bfin_wdt_ioctl,
-	.open     = bfin_wdt_open,
-	.release  = bfin_wdt_release,
+	.owner		= THIS_MODULE,
+	.llseek		= no_llseek,
+	.write    	= bfin_wdt_write,
+	.unlocked_ioctl	= bfin_wdt_ioctl,
+	.open		= bfin_wdt_open,
+	.release	= bfin_wdt_release,
 };
 
 static struct miscdevice bfin_wdt_miscdev = {
@@ -409,8 +398,8 @@ static struct miscdevice bfin_wdt_miscdev = {
 static struct watchdog_info bfin_wdt_info = {
 	.identity = "Blackfin Watchdog",
 	.options  = WDIOF_SETTIMEOUT |
-	            WDIOF_KEEPALIVEPING |
-	            WDIOF_MAGICCLOSE,
+		    WDIOF_KEEPALIVEPING |
+		    WDIOF_MAGICCLOSE,
 };
 
 static struct notifier_block bfin_wdt_notifier = {
@@ -446,14 +435,16 @@ static int __init bfin_wdt_init(void)
 
 	ret = register_reboot_notifier(&bfin_wdt_notifier);
 	if (ret) {
-		pr_init(KERN_ERR PFX "cannot register reboot notifier (err=%d)\n", ret);
+		pr_init(KERN_ERR PFX
+			"cannot register reboot notifier (err=%d)\n", ret);
 		return ret;
 	}
 
 	ret = misc_register(&bfin_wdt_miscdev);
 	if (ret) {
-		pr_init(KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
-		       WATCHDOG_MINOR, ret);
+		pr_init(KERN_ERR PFX
+			"cannot register miscdev on minor=%d (err=%d)\n",
+					WATCHDOG_MINOR, ret);
 		unregister_reboot_notifier(&bfin_wdt_notifier);
 		return ret;
 	}
@@ -485,7 +476,11 @@ MODULE_LICENSE("GPL");
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
 
 module_param(timeout, uint, 0);
-MODULE_PARM_DESC(timeout, "Watchdog timeout in seconds. (1<=timeout<=((2^32)/SCLK), default=" __MODULE_STRING(WATCHDOG_TIMEOUT) ")");
+MODULE_PARM_DESC(timeout,
+	"Watchdog timeout in seconds. (1<=timeout<=((2^32)/SCLK), default="
+		__MODULE_STRING(WATCHDOG_TIMEOUT) ")");
 
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+	"Watchdog cannot be stopped once started (default="
+		__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");

