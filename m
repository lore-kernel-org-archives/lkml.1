Return-Path: <linux-kernel-owner+w=401wt.eu-S1760589AbYESNVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760589AbYESNVk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:21:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759963AbYESNRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:17:42 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45822 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759934AbYESNRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:17:41 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 12/57] ib700wdt: clean up and switch to unlocked_ioctl
To: akpm@osdl.org, linux-kernel@vger.kernel.org, wim@iguana.be
Date: Mon, 19 May 2008 14:05:52 +0100
Message-ID: <20080519130552.31722.62910.stgit@core>
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

 drivers/watchdog/ib700wdt.c |  103 ++++++++++++++++++++++---------------------
 1 files changed, 52 insertions(+), 51 deletions(-)


diff --git a/drivers/watchdog/ib700wdt.c b/drivers/watchdog/ib700wdt.c
index 4b89f40..805a54b 100644
--- a/drivers/watchdog/ib700wdt.c
+++ b/drivers/watchdog/ib700wdt.c
@@ -42,8 +42,8 @@
 #include <linux/moduleparam.h>
 #include <linux/platform_device.h>
 
-#include <asm/io.h>
-#include <asm/uaccess.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 #include <asm/system.h>
 
 static struct platform_device *ibwdt_platform_device;
@@ -120,7 +120,9 @@ static int wd_margin = WD_TIMO;
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+		"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 
 /*
@@ -165,8 +167,8 @@ ibwdt_set_heartbeat(int t)
  *	/dev/watchdog handling
  */
 
-static ssize_t
-ibwdt_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
+static ssize_t ibwdt_write(struct file *file, const char __user *buf,
+						size_t count, loff_t *ppos)
 {
 	if (count) {
 		if (!nowayout) {
@@ -188,77 +190,71 @@ ibwdt_write(struct file *file, const char __user *buf, size_t count, loff_t *ppo
 	return count;
 }
 
-static int
-ibwdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-	  unsigned long arg)
+static long ibwdt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	int new_margin;
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
 
 	static struct watchdog_info ident = {
-		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT | WDIOF_MAGICCLOSE,
+		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT
+							| WDIOF_MAGICCLOSE,
 		.firmware_version = 1,
 		.identity = "IB700 WDT",
 	};
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
-	  if (copy_to_user(argp, &ident, sizeof(ident)))
-	    return -EFAULT;
-	  break;
+		if (copy_to_user(argp, &ident, sizeof(ident)))
+			return -EFAULT;
+		break;
 
 	case WDIOC_GETSTATUS:
 	case WDIOC_GETBOOTSTATUS:
-	  return put_user(0, p);
+		return put_user(0, p);
 
 	case WDIOC_KEEPALIVE:
-	  ibwdt_ping();
-	  break;
+		ibwdt_ping();
+		break;
 
 	case WDIOC_SETTIMEOUT:
-	  if (get_user(new_margin, p))
-		  return -EFAULT;
-	  if (ibwdt_set_heartbeat(new_margin))
-		  return -EINVAL;
-	  ibwdt_ping();
-	  /* Fall */
+		if (get_user(new_margin, p))
+			return -EFAULT;
+		if (ibwdt_set_heartbeat(new_margin))
+			return -EINVAL;
+		ibwdt_ping();
+		/* Fall */
 
 	case WDIOC_GETTIMEOUT:
-	  return put_user(wd_times[wd_margin], p);
+		return put_user(wd_times[wd_margin], p);
 
 	case WDIOC_SETOPTIONS:
 	{
-	  int options, retval = -EINVAL;
+		int options, retval = -EINVAL;
 
-	  if (get_user(options, p))
-	    return -EFAULT;
+		if (get_user(options, p))
+			return -EFAULT;
 
-	  if (options & WDIOS_DISABLECARD) {
-	    ibwdt_disable();
-	    retval = 0;
-	  }
-
-	  if (options & WDIOS_ENABLECARD) {
-	    ibwdt_ping();
-	    retval = 0;
-	  }
-
-	  return retval;
+		if (options & WDIOS_DISABLECARD) {
+			ibwdt_disable();
+			retval = 0;
+		}
+		if (options & WDIOS_ENABLECARD) {
+			ibwdt_ping();
+			retval = 0;
+		}
+		return retval;
 	}
-
 	default:
-	  return -ENOTTY;
+		return -ENOTTY;
 	}
 	return 0;
 }
 
-static int
-ibwdt_open(struct inode *inode, struct file *file)
+static int ibwdt_open(struct inode *inode, struct file *file)
 {
-	if (test_and_set_bit(0, &ibwdt_is_open)) {
+	if (test_and_set_bit(0, &ibwdt_is_open))
 		return -EBUSY;
-	}
 	if (nowayout)
 		__module_get(THIS_MODULE);
 
@@ -273,7 +269,8 @@ ibwdt_close(struct inode *inode, struct file *file)
 	if (expect_close == 42) {
 		ibwdt_disable();
 	} else {
-		printk(KERN_CRIT PFX "WDT device closed unexpectedly.  WDT will not stop!\n");
+		printk(KERN_CRIT PFX
+		     "WDT device closed unexpectedly.  WDT will not stop!\n");
 		ibwdt_ping();
 	}
 	clear_bit(0, &ibwdt_is_open);
@@ -289,7 +286,7 @@ static const struct file_operations ibwdt_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= ibwdt_write,
-	.ioctl		= ibwdt_ioctl,
+	.unlocked_ioctl	= ibwdt_ioctl,
 	.open		= ibwdt_open,
 	.release	= ibwdt_close,
 };
@@ -310,21 +307,23 @@ static int __devinit ibwdt_probe(struct platform_device *dev)
 
 #if WDT_START != WDT_STOP
 	if (!request_region(WDT_STOP, 1, "IB700 WDT")) {
-		printk (KERN_ERR PFX "STOP method I/O %X is not available.\n", WDT_STOP);
+		printk(KERN_ERR PFX "STOP method I/O %X is not available.\n",
+								WDT_STOP);
 		res = -EIO;
 		goto out_nostopreg;
 	}
 #endif
 
 	if (!request_region(WDT_START, 1, "IB700 WDT")) {
-		printk (KERN_ERR PFX "START method I/O %X is not available.\n", WDT_START);
+		printk(KERN_ERR PFX "START method I/O %X is not available.\n",
+								WDT_START);
 		res = -EIO;
 		goto out_nostartreg;
 	}
 
 	res = misc_register(&ibwdt_miscdev);
 	if (res) {
-		printk (KERN_ERR PFX "failed to register misc device\n");
+		printk(KERN_ERR PFX "failed to register misc device\n");
 		goto out_nomisc;
 	}
 	return 0;
@@ -342,9 +341,9 @@ out_nostopreg:
 static int __devexit ibwdt_remove(struct platform_device *dev)
 {
 	misc_deregister(&ibwdt_miscdev);
-	release_region(WDT_START,1);
+	release_region(WDT_START, 1);
 #if WDT_START != WDT_STOP
-	release_region(WDT_STOP,1);
+	release_region(WDT_STOP, 1);
 #endif
 	return 0;
 }
@@ -369,13 +368,15 @@ static int __init ibwdt_init(void)
 {
 	int err;
 
-	printk(KERN_INFO PFX "WDT driver for IB700 single board computer initialising.\n");
+	printk(KERN_INFO PFX
+		"WDT driver for IB700 single board computer initialising.\n");
 
 	err = platform_driver_register(&ibwdt_driver);
 	if (err)
 		return err;
 
-	ibwdt_platform_device = platform_device_register_simple(DRV_NAME, -1, NULL, 0);
+	ibwdt_platform_device = platform_device_register_simple(DRV_NAME,
+								-1, NULL, 0);
 	if (IS_ERR(ibwdt_platform_device)) {
 		err = PTR_ERR(ibwdt_platform_device);
 		goto unreg_platform_driver;

