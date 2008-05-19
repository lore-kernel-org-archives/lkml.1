Return-Path: <linux-kernel-owner+w=401wt.eu-S1759622AbYESNR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759622AbYESNR1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:17:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757918AbYESNQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:16:42 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57947 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756991AbYESNQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:16:41 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 02/57] clean up and check advantech watchdog
To: akpm@osdl.org, linux-kernel@vger.kernel.org, wim@iguana.be
Date: Mon, 19 May 2008 14:04:51 +0100
Message-ID: <20080519130451.31722.45007.stgit@core>
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

Clean up the advantech watchdog code and inspect for BKL problems
---

 drivers/watchdog/advantechwdt.c |  133 ++++++++++++++++++---------------------
 1 files changed, 61 insertions(+), 72 deletions(-)


diff --git a/drivers/watchdog/advantechwdt.c b/drivers/watchdog/advantechwdt.c
index 8121cc2..7597571 100644
--- a/drivers/watchdog/advantechwdt.c
+++ b/drivers/watchdog/advantechwdt.c
@@ -72,35 +72,35 @@ MODULE_PARM_DESC(wdt_start, "Advantech WDT 'start' io port (default 0x443)");
 
 static int timeout = WATCHDOG_TIMEOUT;	/* in seconds */
 module_param(timeout, int, 0);
-MODULE_PARM_DESC(timeout, "Watchdog timeout in seconds. 1<= timeout <=63, default=" __MODULE_STRING(WATCHDOG_TIMEOUT) ".");
+MODULE_PARM_DESC(timeout,
+	"Watchdog timeout in seconds. 1<= timeout <=63, default="
+		__MODULE_STRING(WATCHDOG_TIMEOUT) ".");
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+	"Watchdog cannot be stopped once started (default="
+		__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 /*
  *	Watchdog Operations
  */
 
-static void
-advwdt_ping(void)
+static void advwdt_ping(void)
 {
 	/* Write a watchdog value */
 	outb_p(timeout, wdt_start);
 }
 
-static void
-advwdt_disable(void)
+static void advwdt_disable(void)
 {
 	inb_p(wdt_stop);
 }
 
-static int
-advwdt_set_heartbeat(int t)
+static int advwdt_set_heartbeat(int t)
 {
-	if ((t < 1) || (t > 63))
+	if (t < 1 || t > 63)
 		return -EINVAL;
-
 	timeout = t;
 	return 0;
 }
@@ -109,8 +109,8 @@ advwdt_set_heartbeat(int t)
  *	/dev/watchdog handling
  */
 
-static ssize_t
-advwdt_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
+static ssize_t advwdt_write(struct file *file, const char __user *buf,
+						size_t count, loff_t *ppos)
 {
 	if (count) {
 		if (!nowayout) {
@@ -131,9 +131,7 @@ advwdt_write(struct file *file, const char __user *buf, size_t count, loff_t *pp
 	return count;
 }
 
-static int
-advwdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-	  unsigned long arg)
+static long advwdt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	int new_timeout;
 	void __user *argp = (void __user *)arg;
@@ -146,57 +144,50 @@ advwdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
-	  if (copy_to_user(argp, &ident, sizeof(ident)))
-	    return -EFAULT;
-	  break;
+	if (copy_to_user(argp, &ident, sizeof(ident)))
+		return -EFAULT;
+		break;
 
 	case WDIOC_GETSTATUS:
 	case WDIOC_GETBOOTSTATUS:
-	  return put_user(0, p);
+		return put_user(0, p);
 
 	case WDIOC_KEEPALIVE:
-	  advwdt_ping();
-	  break;
+		advwdt_ping();
+		break;
 
 	case WDIOC_SETTIMEOUT:
-	  if (get_user(new_timeout, p))
-		  return -EFAULT;
-	  if (advwdt_set_heartbeat(new_timeout))
-		  return -EINVAL;
-	  advwdt_ping();
-	  /* Fall */
-
+		if (get_user(new_timeout, p))
+			return -EFAULT;
+		if (advwdt_set_heartbeat(new_timeout))
+			return -EINVAL;
+		advwdt_ping();
+		/* Fall */
 	case WDIOC_GETTIMEOUT:
-	  return put_user(timeout, p);
-
+		return put_user(timeout, p);
 	case WDIOC_SETOPTIONS:
 	{
-	  int options, retval = -EINVAL;
-
-	  if (get_user(options, p))
-	    return -EFAULT;
+		int options, retval = -EINVAL;
 
-	  if (options & WDIOS_DISABLECARD) {
-	    advwdt_disable();
-	    retval = 0;
-	  }
-
-	  if (options & WDIOS_ENABLECARD) {
-	    advwdt_ping();
-	    retval = 0;
-	  }
-
-	  return retval;
+		if (get_user(options, p))
+			return -EFAULT;
+		if (options & WDIOS_DISABLECARD) {
+			advwdt_disable();
+			retval = 0;
+		}
+		if (options & WDIOS_ENABLECARD) {
+			advwdt_ping();
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
-advwdt_open(struct inode *inode, struct file *file)
+static int advwdt_open(struct inode *inode, struct file *file)
 {
 	if (test_and_set_bit(0, &advwdt_is_open))
 		return -EBUSY;
@@ -214,7 +205,8 @@ advwdt_close(struct inode *inode, struct file *file)
 	if (adv_expect_close == 42) {
 		advwdt_disable();
 	} else {
-		printk(KERN_CRIT PFX "Unexpected close, not stopping watchdog!\n");
+		printk(KERN_CRIT PFX
+				"Unexpected close, not stopping watchdog!\n");
 		advwdt_ping();
 	}
 	clear_bit(0, &advwdt_is_open);
@@ -230,7 +222,7 @@ static const struct file_operations advwdt_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= advwdt_write,
-	.ioctl		= advwdt_ioctl,
+	.unlocked_ioctl	= advwdt_ioctl,
 	.open		= advwdt_open,
 	.release	= advwdt_close,
 };
@@ -245,23 +237,24 @@ static struct miscdevice advwdt_miscdev = {
  *	Init & exit routines
  */
 
-static int __devinit
-advwdt_probe(struct platform_device *dev)
+static int __devinit advwdt_probe(struct platform_device *dev)
 {
 	int ret;
 
 	if (wdt_stop != wdt_start) {
 		if (!request_region(wdt_stop, 1, WATCHDOG_NAME)) {
-			printk (KERN_ERR PFX "I/O address 0x%04x already in use\n",
-				wdt_stop);
+			printk (KERN_ERR PFX
+				"I/O address 0x%04x already in use\n",
+								wdt_stop);
 			ret = -EIO;
 			goto out;
 		}
 	}
 
 	if (!request_region(wdt_start, 1, WATCHDOG_NAME)) {
-		printk (KERN_ERR PFX "I/O address 0x%04x already in use\n",
-			wdt_start);
+		printk (KERN_ERR PFX
+				"I/O address 0x%04x already in use\n",
+								wdt_start);
 		ret = -EIO;
 		goto unreg_stop;
 	}
@@ -269,20 +262,19 @@ advwdt_probe(struct platform_device *dev)
 	/* Check that the heartbeat value is within it's range ; if not reset to the default */
 	if (advwdt_set_heartbeat(timeout)) {
 		advwdt_set_heartbeat(WATCHDOG_TIMEOUT);
-		printk (KERN_INFO PFX "timeout value must be 1<=x<=63, using %d\n",
-			timeout);
+		printk (KERN_INFO PFX
+			"timeout value must be 1<=x<=63, using %d\n", timeout);
 	}
 
 	ret = misc_register(&advwdt_miscdev);
 	if (ret != 0) {
-		printk (KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
-			WATCHDOG_MINOR, ret);
+		printk (KERN_ERR PFX
+			"cannot register miscdev on minor=%d (err=%d)\n",
+							WATCHDOG_MINOR, ret);
 		goto unreg_regions;
 	}
-
 	printk (KERN_INFO PFX "initialized. timeout=%d sec (nowayout=%d)\n",
 		timeout, nowayout);
-
 out:
 	return ret;
 unreg_regions:
@@ -293,8 +285,7 @@ unreg_stop:
 	goto out;
 }
 
-static int __devexit
-advwdt_remove(struct platform_device *dev)
+static int __devexit advwdt_remove(struct platform_device *dev)
 {
 	misc_deregister(&advwdt_miscdev);
 	release_region(wdt_start,1);
@@ -304,8 +295,7 @@ advwdt_remove(struct platform_device *dev)
 	return 0;
 }
 
-static void
-advwdt_shutdown(struct platform_device *dev)
+static void advwdt_shutdown(struct platform_device *dev)
 {
 	/* Turn the WDT off if we have a soft shutdown */
 	advwdt_disable();
@@ -321,8 +311,7 @@ static struct platform_driver advwdt_driver = {
 	},
 };
 
-static int __init
-advwdt_init(void)
+static int __init advwdt_init(void)
 {
 	int err;
 
@@ -332,7 +321,8 @@ advwdt_init(void)
 	if (err)
 		return err;
 
-	advwdt_platform_device = platform_device_register_simple(DRV_NAME, -1, NULL, 0);
+	advwdt_platform_device = platform_device_register_simple(DRV_NAME,
+								-1, NULL, 0);
 	if (IS_ERR(advwdt_platform_device)) {
 		err = PTR_ERR(advwdt_platform_device);
 		goto unreg_platform_driver;
@@ -345,8 +335,7 @@ unreg_platform_driver:
 	return err;
 }
 
-static void __exit
-advwdt_exit(void)
+static void __exit advwdt_exit(void)
 {
 	platform_device_unregister(advwdt_platform_device);
 	platform_driver_unregister(&advwdt_driver);

