Return-Path: <linux-kernel-owner+w=401wt.eu-S932267AbYESNdF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267AbYESNdF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:33:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759293AbYESNUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:20:47 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45977 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761098AbYESNUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:20:46 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 45/57] shwdt: coding style, cleanup, switch to unlocked_ioctl
To: akpm@osdl.org, linux-kernel@vger.kernel.org, wim@iguana.be
Date: Mon, 19 May 2008 14:08:55 +0100
Message-ID: <20080519130855.31722.43696.stgit@core>
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

 drivers/watchdog/shwdt.c |  139 +++++++++++++++++++++++++++-------------------
 1 files changed, 82 insertions(+), 57 deletions(-)


diff --git a/drivers/watchdog/shwdt.c b/drivers/watchdog/shwdt.c
index 1277f7e..60f0036 100644
--- a/drivers/watchdog/shwdt.c
+++ b/drivers/watchdog/shwdt.c
@@ -28,9 +28,9 @@
 #include <linux/ioport.h>
 #include <linux/fs.h>
 #include <linux/mm.h>
-#include <asm/io.h>
-#include <asm/uaccess.h>
-#include <asm/watchdog.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
+#include <linux/watchdog.h>
 
 #define PFX "shwdt: "
 
@@ -72,6 +72,7 @@ static struct watchdog_info sh_wdt_info;
 static char shwdt_expect_close;
 static DEFINE_TIMER(timer, sh_wdt_ping, 0, 0);
 static unsigned long next_heartbeat;
+static DEFINE_SPINLOCK(shwdt_lock);
 
 #define WATCHDOG_HEARTBEAT 30			/* 30 sec default heartbeat */
 static int heartbeat = WATCHDOG_HEARTBEAT;	/* in seconds */
@@ -86,6 +87,9 @@ static int nowayout = WATCHDOG_NOWAYOUT;
 static void sh_wdt_start(void)
 {
 	__u8 csr;
+	unsigned long flags;
+
+	spin_lock_irqsave(&wdt_lock, flags);
 
 	next_heartbeat = jiffies + (heartbeat * HZ);
 	mod_timer(&timer, next_ping_period(clock_division_ratio));
@@ -123,6 +127,7 @@ static void sh_wdt_start(void)
 	csr &= ~RSTCSR_RSTS;
 	sh_wdt_write_rstcsr(csr);
 #endif
+	spin_unlock_irqrestore(&wdt_lock, flags);
 }
 
 /**
@@ -132,12 +137,16 @@ static void sh_wdt_start(void)
 static void sh_wdt_stop(void)
 {
 	__u8 csr;
+	unsigned long flags;
+
+	spin_lock_irqsave(&wdt_lock, flags);
 
 	del_timer(&timer);
 
 	csr = sh_wdt_read_csr();
 	csr &= ~WTCSR_TME;
 	sh_wdt_write_csr(csr);
+	spin_unlock_irqrestore(&wdt_lock, flags);
 }
 
 /**
@@ -146,7 +155,11 @@ static void sh_wdt_stop(void)
  */
 static inline void sh_wdt_keepalive(void)
 {
+	unsigned long flags;
+
+	spin_lock_irqsave(&wdt_lock, flags);
 	next_heartbeat = jiffies + (heartbeat * HZ);
+	spin_unlock_irqrestore(&wdt_lock, flags);
 }
 
 /**
@@ -155,10 +168,14 @@ static inline void sh_wdt_keepalive(void)
  */
 static int sh_wdt_set_heartbeat(int t)
 {
-	if (unlikely((t < 1) || (t > 3600))) /* arbitrary upper limit */
+	unsigned long flags;
+
+	if (unlikely(t < 1 || t > 3600)) /* arbitrary upper limit */
 		return -EINVAL;
 
+	spin_lock_irqsave(&wdt_lock, flags);
 	heartbeat = t;
+	spin_unlock_irqrestore(&wdt_lock, flags);
 	return 0;
 }
 
@@ -170,6 +187,9 @@ static int sh_wdt_set_heartbeat(int t)
  */
 static void sh_wdt_ping(unsigned long data)
 {
+	unsigned long flags;
+
+	spin_lock_irqsave(&wdt_lock, flags);
 	if (time_before(jiffies, next_heartbeat)) {
 		__u8 csr;
 
@@ -183,6 +203,7 @@ static void sh_wdt_ping(unsigned long data)
 	} else
 		printk(KERN_WARNING PFX "Heartbeat lost! Will not ping "
 		       "the watchdog\n");
+	spin_unlock_irqrestore(&wdt_lock, flags);
 }
 
 /**
@@ -310,7 +331,6 @@ static int sh_wdt_mmap(struct file *file, struct vm_area_struct *vma)
 
 /**
  * 	sh_wdt_ioctl - Query Device
- * 	@inode: inode of device
  * 	@file: file handle of device
  * 	@cmd: watchdog command
  * 	@arg: argument
@@ -318,53 +338,51 @@ static int sh_wdt_mmap(struct file *file, struct vm_area_struct *vma)
  * 	Query basic information from the device or ping it, as outlined by the
  * 	watchdog API.
  */
-static int sh_wdt_ioctl(struct inode *inode, struct file *file,
-			unsigned int cmd, unsigned long arg)
+static long sh_wdt_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
 	int new_heartbeat;
 	int options, retval = -EINVAL;
 
 	switch (cmd) {
-		case WDIOC_GETSUPPORT:
-			return copy_to_user((struct watchdog_info *)arg,
-					  &sh_wdt_info,
-					  sizeof(sh_wdt_info)) ? -EFAULT : 0;
-		case WDIOC_GETSTATUS:
-		case WDIOC_GETBOOTSTATUS:
-			return put_user(0, (int *)arg);
-		case WDIOC_KEEPALIVE:
-			sh_wdt_keepalive();
-			return 0;
-		case WDIOC_SETTIMEOUT:
-			if (get_user(new_heartbeat, (int *)arg))
-				return -EFAULT;
-
-			if (sh_wdt_set_heartbeat(new_heartbeat))
-				return -EINVAL;
-
-			sh_wdt_keepalive();
-			/* Fall */
-		case WDIOC_GETTIMEOUT:
-			return put_user(heartbeat, (int *)arg);
-		case WDIOC_SETOPTIONS:
-			if (get_user(options, (int *)arg))
-				return -EFAULT;
-
-			if (options & WDIOS_DISABLECARD) {
-				sh_wdt_stop();
-				retval = 0;
-			}
+	case WDIOC_GETSUPPORT:
+		return copy_to_user((struct watchdog_info *)arg,
+			  &sh_wdt_info, sizeof(sh_wdt_info)) ? -EFAULT : 0;
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, (int *)arg);
+	case WDIOC_KEEPALIVE:
+		sh_wdt_keepalive();
+		return 0;
+	case WDIOC_SETTIMEOUT:
+		if (get_user(new_heartbeat, (int *)arg))
+			return -EFAULT;
 
-			if (options & WDIOS_ENABLECARD) {
-				sh_wdt_start();
-				retval = 0;
-			}
+		if (sh_wdt_set_heartbeat(new_heartbeat))
+			return -EINVAL;
 
-			return retval;
-		default:
-			return -ENOTTY;
-	}
+		sh_wdt_keepalive();
+		/* Fall */
+	case WDIOC_GETTIMEOUT:
+		return put_user(heartbeat, (int *)arg);
+	case WDIOC_SETOPTIONS:
+		if (get_user(options, (int *)arg))
+			return -EFAULT;
+
+		if (options & WDIOS_DISABLECARD) {
+			sh_wdt_stop();
+			retval = 0;
+		}
+
+		if (options & WDIOS_ENABLECARD) {
+			sh_wdt_start();
+			retval = 0;
+		}
 
+		return retval;
+	default:
+		return -ENOTTY;
+	}
 	return 0;
 }
 
@@ -390,13 +408,13 @@ static const struct file_operations sh_wdt_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= sh_wdt_write,
-	.ioctl		= sh_wdt_ioctl,
+	.unlocked_ioctl	= sh_wdt_ioctl,
 	.open		= sh_wdt_open,
 	.release	= sh_wdt_close,
 	.mmap		= sh_wdt_mmap,
 };
 
-static struct watchdog_info sh_wdt_info = {
+static const struct watchdog_info sh_wdt_info = {
 	.options		= WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT |
 				  WDIOF_MAGICCLOSE,
 	.firmware_version	= 1,
@@ -422,30 +440,33 @@ static int __init sh_wdt_init(void)
 {
 	int rc;
 
-	if ((clock_division_ratio < 0x5) || (clock_division_ratio > 0x7)) {
+	if (clock_division_ratio < 0x5 || clock_division_ratio > 0x7) {
 		clock_division_ratio = WTCSR_CKS_4096;
-		printk(KERN_INFO PFX "clock_division_ratio value must "
-		       "be 0x5<=x<=0x7, using %d\n", clock_division_ratio);
+		printk(KERN_INFO PFX
+		  "clock_division_ratio value must be 0x5<=x<=0x7, using %d\n",
+				clock_division_ratio);
 	}
 
 	rc = sh_wdt_set_heartbeat(heartbeat);
 	if (unlikely(rc)) {
 		heartbeat = WATCHDOG_HEARTBEAT;
-		printk(KERN_INFO PFX "heartbeat value must "
-		       "be 1<=x<=3600, using %d\n", heartbeat);
+		printk(KERN_INFO PFX
+			"heartbeat value must be 1<=x<=3600, using %d\n",
+								heartbeat);
 	}
 
 	rc = register_reboot_notifier(&sh_wdt_notifier);
 	if (unlikely(rc)) {
-		printk(KERN_ERR PFX "Can't register reboot notifier (err=%d)\n",
-		       rc);
+		printk(KERN_ERR PFX
+			"Can't register reboot notifier (err=%d)\n", rc);
 		return rc;
 	}
 
 	rc = misc_register(&sh_wdt_miscdev);
 	if (unlikely(rc)) {
-		printk(KERN_ERR PFX "Can't register miscdev on "
-		       "minor=%d (err=%d)\n", sh_wdt_miscdev.minor, rc);
+		printk(KERN_ERR PFX
+			"Can't register miscdev on minor=%d (err=%d)\n",
+						sh_wdt_miscdev.minor, rc);
 		unregister_reboot_notifier(&sh_wdt_notifier);
 		return rc;
 	}
@@ -476,10 +497,14 @@ module_param(clock_division_ratio, int, 0);
 MODULE_PARM_DESC(clock_division_ratio, "Clock division ratio. Valid ranges are from 0x5 (1.31ms) to 0x7 (5.25ms). (default=" __MODULE_STRING(clock_division_ratio) ")");
 
 module_param(heartbeat, int, 0);
-MODULE_PARM_DESC(heartbeat, "Watchdog heartbeat in seconds. (1<=heartbeat<=3600, default=" __MODULE_STRING(WATCHDOG_HEARTBEAT) ")");
+MODULE_PARM_DESC(heartbeat,
+	"Watchdog heartbeat in seconds. (1 <= heartbeat <= 3600, default="
+				__MODULE_STRING(WATCHDOG_HEARTBEAT) ")");
 
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+	"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 module_init(sh_wdt_init);
 module_exit(sh_wdt_exit);

