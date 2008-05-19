Return-Path: <linux-kernel-owner+w=401wt.eu-S1760435AbYESNiM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760435AbYESNiM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:38:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761623AbYESNWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:22:00 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46032 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761610AbYESNV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:21:58 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 53/57] wafer5823wdt: Clean up, coding style,
	switch to unlocked_ioctl
To: akpm@osdl.org, linux-kernel@vger.kernel.org, wim@iguana.be
Date: Mon, 19 May 2008 14:09:40 +0100
Message-ID: <20080519130940.31722.297.stgit@core>
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

 drivers/watchdog/wafer5823wdt.c |   80 ++++++++++++++++++++++-----------------
 1 files changed, 46 insertions(+), 34 deletions(-)


diff --git a/drivers/watchdog/wafer5823wdt.c b/drivers/watchdog/wafer5823wdt.c
index 9e36809..886cbbc 100644
--- a/drivers/watchdog/wafer5823wdt.c
+++ b/drivers/watchdog/wafer5823wdt.c
@@ -36,8 +36,8 @@
 #include <linux/reboot.h>
 #include <linux/init.h>
 #include <linux/spinlock.h>
-#include <asm/io.h>
-#include <asm/uaccess.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 
 #define WATCHDOG_NAME "Wafer 5823 WDT"
 #define PFX WATCHDOG_NAME ": "
@@ -61,11 +61,15 @@ static int wdt_start = 0x443;
 
 static int timeout = WD_TIMO;  /* in seconds */
 module_param(timeout, int, 0);
-MODULE_PARM_DESC(timeout, "Watchdog timeout in seconds. 1<= timeout <=255, default=" __MODULE_STRING(WD_TIMO) ".");
+MODULE_PARM_DESC(timeout,
+		"Watchdog timeout in seconds. 1 <= timeout <= 255, default="
+				__MODULE_STRING(WD_TIMO) ".");
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+		"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 static void wafwdt_ping(void)
 {
@@ -90,7 +94,8 @@ wafwdt_stop(void)
 	inb_p(wdt_stop);
 }
 
-static ssize_t wafwdt_write(struct file *file, const char __user *buf, size_t count, loff_t * ppos)
+static ssize_t wafwdt_write(struct file *file, const char __user *buf,
+						size_t count, loff_t *ppos)
 {
 	/* See if we got the magic character 'V' and reload the timer */
 	if (count) {
@@ -100,7 +105,8 @@ static ssize_t wafwdt_write(struct file *file, const char __user *buf, size_t co
 			/* In case it was set long ago */
 			expect_close = 0;
 
-			/* scan to see whether or not we got the magic character */
+			/* scan to see whether or not we got the magic
+			   character */
 			for (i = 0; i != count; i++) {
 				char c;
 				if (get_user(c, buf + i))
@@ -109,27 +115,29 @@ static ssize_t wafwdt_write(struct file *file, const char __user *buf, size_t co
 					expect_close = 42;
 			}
 		}
-		/* Well, anyhow someone wrote to us, we should return that favour */
+		/* Well, anyhow someone wrote to us, we should
+		   return that favour */
 		wafwdt_ping();
 	}
 	return count;
 }
 
-static int wafwdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-	     unsigned long arg)
+static long wafwdt_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
 	int new_timeout;
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
-	static struct watchdog_info ident = {
-		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT | WDIOF_MAGICCLOSE,
+	static const struct watchdog_info ident = {
+		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT |
+							WDIOF_MAGICCLOSE,
 		.firmware_version = 1,
 		.identity = "Wafer 5823 WDT",
 	};
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
-		if (copy_to_user(argp, &ident, sizeof (ident)))
+		if (copy_to_user(argp, &ident, sizeof(ident)))
 			return -EFAULT;
 		break;
 
@@ -194,10 +202,11 @@ static int wafwdt_open(struct inode *inode, struct file *file)
 static int
 wafwdt_close(struct inode *inode, struct file *file)
 {
-	if (expect_close == 42) {
+	if (expect_close == 42)
 		wafwdt_stop();
-	} else {
-		printk(KERN_CRIT PFX "WDT device closed unexpectedly.  WDT will not stop!\n");
+	else {
+		printk(KERN_CRIT PFX
+		    "WDT device closed unexpectedly.  WDT will not stop!\n");
 		wafwdt_ping();
 	}
 	clear_bit(0, &wafwdt_is_open);
@@ -209,12 +218,11 @@ wafwdt_close(struct inode *inode, struct file *file)
  *	Notifier for system down
  */
 
-static int wafwdt_notify_sys(struct notifier_block *this, unsigned long code, void *unused)
+static int wafwdt_notify_sys(struct notifier_block *this, unsigned long code,
+								void *unused)
 {
-	if (code == SYS_DOWN || code == SYS_HALT) {
-		/* Turn the WDT off */
+	if (code == SYS_DOWN || code == SYS_HALT)
 		wafwdt_stop();
-	}
 	return NOTIFY_DONE;
 }
 
@@ -226,7 +234,7 @@ static const struct file_operations wafwdt_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= wafwdt_write,
-	.ioctl		= wafwdt_ioctl,
+	.unlocked_ioctl	= wafwdt_ioctl,
 	.open		= wafwdt_open,
 	.release	= wafwdt_close,
 };
@@ -250,25 +258,28 @@ static int __init wafwdt_init(void)
 {
 	int ret;
 
-	printk(KERN_INFO "WDT driver for Wafer 5823 single board computer initialising.\n");
+	printk(KERN_INFO
+	  "WDT driver for Wafer 5823 single board computer initialising.\n");
 
 	if (timeout < 1 || timeout > 255) {
 		timeout = WD_TIMO;
-		printk (KERN_INFO PFX "timeout value must be 1<=x<=255, using %d\n",
-			timeout);
+		printk(KERN_INFO PFX
+			"timeout value must be 1 <= x <= 255, using %d\n",
+								timeout);
 	}
 
 	if (wdt_stop != wdt_start) {
-		if(!request_region(wdt_stop, 1, "Wafer 5823 WDT")) {
-			printk (KERN_ERR PFX "I/O address 0x%04x already in use\n",
-			wdt_stop);
+		if (!request_region(wdt_stop, 1, "Wafer 5823 WDT")) {
+			printk(KERN_ERR PFX
+				"I/O address 0x%04x already in use\n",
+								wdt_stop);
 			ret = -EIO;
 			goto error;
 		}
 	}
 
-	if(!request_region(wdt_start, 1, "Wafer 5823 WDT")) {
-		printk (KERN_ERR PFX "I/O address 0x%04x already in use\n",
+	if (!request_region(wdt_start, 1, "Wafer 5823 WDT")) {
+		printk(KERN_ERR PFX "I/O address 0x%04x already in use\n",
 			wdt_start);
 		ret = -EIO;
 		goto error2;
@@ -276,19 +287,20 @@ static int __init wafwdt_init(void)
 
 	ret = register_reboot_notifier(&wafwdt_notifier);
 	if (ret != 0) {
-		printk (KERN_ERR PFX "cannot register reboot notifier (err=%d)\n",
-			ret);
+		printk(KERN_ERR PFX
+			"cannot register reboot notifier (err=%d)\n", ret);
 		goto error3;
 	}
 
 	ret = misc_register(&wafwdt_miscdev);
 	if (ret != 0) {
-		printk (KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
-			WATCHDOG_MINOR, ret);
+		printk(KERN_ERR PFX
+			"cannot register miscdev on minor=%d (err=%d)\n",
+						WATCHDOG_MINOR, ret);
 		goto error4;
 	}
 
-	printk (KERN_INFO PFX "initialized. timeout=%d sec (nowayout=%d)\n",
+	printk(KERN_INFO PFX "initialized. timeout=%d sec (nowayout=%d)\n",
 		timeout, nowayout);
 
 	return ret;
@@ -307,7 +319,7 @@ static void __exit wafwdt_exit(void)
 {
 	misc_deregister(&wafwdt_miscdev);
 	unregister_reboot_notifier(&wafwdt_notifier);
-	if(wdt_stop != wdt_start)
+	if (wdt_stop != wdt_start)
 		release_region(wdt_stop, 1);
 	release_region(wdt_start, 1);
 }

