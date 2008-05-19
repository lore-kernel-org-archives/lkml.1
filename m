Return-Path: <linux-kernel-owner+w=401wt.eu-S1763063AbYESNfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763063AbYESNfL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:35:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761364AbYESNVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:21:22 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46008 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761357AbYESNVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:21:21 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 51/57] w83877f_wdt: clean up code, coding style,
	switch to unlocked_ioctl
To: akpm@osdl.org, linux-kernel@vger.kernel.org, wim@iguana.be
Date: Mon, 19 May 2008 14:09:29 +0100
Message-ID: <20080519130928.31722.61588.stgit@core>
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

 drivers/watchdog/w83877f_wdt.c |  199 ++++++++++++++++++++--------------------
 1 files changed, 101 insertions(+), 98 deletions(-)


diff --git a/drivers/watchdog/w83877f_wdt.c b/drivers/watchdog/w83877f_wdt.c
index f510a3a..75b546d 100644
--- a/drivers/watchdog/w83877f_wdt.c
+++ b/drivers/watchdog/w83877f_wdt.c
@@ -23,13 +23,16 @@
  *                            Added KERN_* tags to printks
  *                            add CONFIG_WATCHDOG_NOWAYOUT support
  *                            fix possible wdt_is_open race
- *                            changed watchdog_info to correctly reflect what the driver offers
- *                            added WDIOC_GETSTATUS, WDIOC_GETBOOTSTATUS, WDIOC_SETTIMEOUT,
+ *                            changed watchdog_info to correctly reflect what
+ *			      the driver offers
+ *                            added WDIOC_GETSTATUS, WDIOC_GETBOOTSTATUS,
+ *			      WDIOC_SETTIMEOUT,
  *                            WDIOC_GETTIMEOUT, and WDIOC_SETOPTIONS ioctls
  *           09/8 - 2003      [wim@iguana.be] cleanup of trailing spaces
  *                            added extra printk's for startup problems
  *                            use module_param
- *                            made timeout (the emulated heartbeat) a module_param
+ *                            made timeout (the emulated heartbeat) a
+ *			      module_param
  *                            made the keepalive ping an internal subroutine
  *
  *  This WDT driver is different from most other Linux WDT
@@ -51,8 +54,8 @@
 #include <linux/notifier.h>
 #include <linux/reboot.h>
 #include <linux/init.h>
-#include <asm/io.h>
-#include <asm/uaccess.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 #include <asm/system.h>
 
 #define OUR_NAME "w83877f_wdt"
@@ -80,14 +83,19 @@
  */
 
 #define WATCHDOG_TIMEOUT 30            /* 30 sec default timeout */
-static int timeout = WATCHDOG_TIMEOUT; /* in seconds, will be multiplied by HZ to get seconds to wait for a ping */
+/* in seconds, will be multiplied by HZ to get seconds to wait for a ping */
+static int timeout = WATCHDOG_TIMEOUT;
 module_param(timeout, int, 0);
-MODULE_PARM_DESC(timeout, "Watchdog timeout in seconds. (1<=timeout<=3600, default=" __MODULE_STRING(WATCHDOG_TIMEOUT) ")");
+MODULE_PARM_DESC(timeout,
+	"Watchdog timeout in seconds. (1<=timeout<=3600, default="
+				__MODULE_STRING(WATCHDOG_TIMEOUT) ")");
 
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+		"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 static void wdt_timer_ping(unsigned long);
 static DEFINE_TIMER(timer, wdt_timer_ping, 0, 0);
@@ -105,8 +113,7 @@ static void wdt_timer_ping(unsigned long data)
 	/* If we got a heartbeat pulse within the WDT_US_INTERVAL
 	 * we agree to ping the WDT
 	 */
-	if(time_before(jiffies, next_heartbeat))
-	{
+	if (time_before(jiffies, next_heartbeat)) {
 		/* Ping the WDT */
 		spin_lock(&wdt_spinlock);
 
@@ -118,9 +125,9 @@ static void wdt_timer_ping(unsigned long data)
 
 		spin_unlock(&wdt_spinlock);
 
-	} else {
-		printk(KERN_WARNING PFX "Heartbeat lost! Will not ping the watchdog\n");
-	}
+	} else
+		printk(KERN_WARNING PFX
+			"Heartbeat lost! Will not ping the watchdog\n");
 }
 
 /*
@@ -181,22 +188,21 @@ static void wdt_keepalive(void)
  * /dev/watchdog handling
  */
 
-static ssize_t fop_write(struct file * file, const char __user * buf, size_t count, loff_t * ppos)
+static ssize_t fop_write(struct file *file, const char __user *buf,
+						size_t count, loff_t *ppos)
 {
 	/* See if we got the magic character 'V' and reload the timer */
-	if(count)
-	{
-		if (!nowayout)
-		{
+	if (count) {
+		if (!nowayout) {
 			size_t ofs;
 
-			/* note: just in case someone wrote the magic character
-			 * five months ago... */
+			/* note: just in case someone wrote the magic
+			   character five months ago... */
 			wdt_expect_close = 0;
 
-			/* scan to see whether or not we got the magic character */
-			for(ofs = 0; ofs != count; ofs++)
-			{
+			/* scan to see whether or not we got the
+			   magic character */
+			for (ofs = 0; ofs != count; ofs++) {
 				char c;
 				if (get_user(c, buf + ofs))
 					return -EFAULT;
@@ -211,10 +217,10 @@ static ssize_t fop_write(struct file * file, const char __user * buf, size_t cou
 	return count;
 }
 
-static int fop_open(struct inode * inode, struct file * file)
+static int fop_open(struct inode *inode, struct file *file)
 {
 	/* Just in case we're already talking to someone... */
-	if(test_and_set_bit(0, &wdt_is_open))
+	if (test_and_set_bit(0, &wdt_is_open))
 		return -EBUSY;
 
 	/* Good, fire up the show */
@@ -222,78 +228,78 @@ static int fop_open(struct inode * inode, struct file * file)
 	return nonseekable_open(inode, file);
 }
 
-static int fop_close(struct inode * inode, struct file * file)
+static int fop_close(struct inode *inode, struct file *file)
 {
-	if(wdt_expect_close == 42)
+	if (wdt_expect_close == 42)
 		wdt_turnoff();
 	else {
 		del_timer(&timer);
-		printk(KERN_CRIT PFX "device file closed unexpectedly. Will not stop the WDT!\n");
+		printk(KERN_CRIT PFX
+		  "device file closed unexpectedly. Will not stop the WDT!\n");
 	}
 	clear_bit(0, &wdt_is_open);
 	wdt_expect_close = 0;
 	return 0;
 }
 
-static int fop_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-	unsigned long arg)
+static long fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
-	static struct watchdog_info ident=
-	{
-		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT | WDIOF_MAGICCLOSE,
+	static const struct watchdog_info ident = {
+		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT
+							| WDIOF_MAGICCLOSE,
 		.firmware_version = 1,
 		.identity = "W83877F",
 	};
 
-	switch(cmd)
+	switch (cmd) {
+	default:
+		return -ENOTTY;
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(argp, &ident, sizeof(ident)) ? -EFAULT : 0;
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, p);
+	case WDIOC_KEEPALIVE:
+		wdt_keepalive();
+		return 0;
+	case WDIOC_SETOPTIONS:
 	{
-		default:
-			return -ENOTTY;
-		case WDIOC_GETSUPPORT:
-			return copy_to_user(argp, &ident, sizeof(ident))?-EFAULT:0;
-		case WDIOC_GETSTATUS:
-		case WDIOC_GETBOOTSTATUS:
-			return put_user(0, p);
-		case WDIOC_KEEPALIVE:
-			wdt_keepalive();
-			return 0;
-		case WDIOC_SETOPTIONS:
-		{
-			int new_options, retval = -EINVAL;
-
-			if(get_user(new_options, p))
-				return -EFAULT;
-
-			if(new_options & WDIOS_DISABLECARD) {
-				wdt_turnoff();
-				retval = 0;
-			}
+		int new_options, retval = -EINVAL;
 
-			if(new_options & WDIOS_ENABLECARD) {
-				wdt_startup();
-				retval = 0;
-			}
+		if (get_user(new_options, p))
+			return -EFAULT;
 
-			return retval;
+		if (new_options & WDIOS_DISABLECARD) {
+			wdt_turnoff();
+			retval = 0;
 		}
-		case WDIOC_SETTIMEOUT:
-		{
-			int new_timeout;
 
-			if(get_user(new_timeout, p))
-				return -EFAULT;
+		if (new_options & WDIOS_ENABLECARD) {
+			wdt_startup();
+			retval = 0;
+		}
 
-			if(new_timeout < 1 || new_timeout > 3600) /* arbitrary upper limit */
-				return -EINVAL;
+		return retval;
+	}
+	case WDIOC_SETTIMEOUT:
+	{
+		int new_timeout;
 
-			timeout = new_timeout;
-			wdt_keepalive();
-			/* Fall through */
-		}
-		case WDIOC_GETTIMEOUT:
-			return put_user(timeout, p);
+		if (get_user(new_timeout, p))
+			return -EFAULT;
+
+		/* arbitrary upper limit */
+		if (new_timeout < 1 || new_timeout > 3600)
+			return -EINVAL;
+
+		timeout = new_timeout;
+		wdt_keepalive();
+		/* Fall through */
+	}
+	case WDIOC_GETTIMEOUT:
+		return put_user(timeout, p);
 	}
 }
 
@@ -303,7 +309,7 @@ static const struct file_operations wdt_fops = {
 	.write		= fop_write,
 	.open		= fop_open,
 	.release	= fop_close,
-	.ioctl		= fop_ioctl,
+	.unlocked_ioctl	= fop_ioctl,
 };
 
 static struct miscdevice wdt_miscdev = {
@@ -319,7 +325,7 @@ static struct miscdevice wdt_miscdev = {
 static int wdt_notify_sys(struct notifier_block *this, unsigned long code,
 	void *unused)
 {
-	if(code==SYS_DOWN || code==SYS_HALT)
+	if (code == SYS_DOWN || code == SYS_HALT)
 		wdt_turnoff();
 	return NOTIFY_DONE;
 }
@@ -329,8 +335,7 @@ static int wdt_notify_sys(struct notifier_block *this, unsigned long code,
  *	turn the timebomb registers off.
  */
 
-static struct notifier_block wdt_notifier=
-{
+static struct notifier_block wdt_notifier = {
 	.notifier_call = wdt_notify_sys,
 };
 
@@ -342,31 +347,29 @@ static void __exit w83877f_wdt_unload(void)
 	misc_deregister(&wdt_miscdev);
 
 	unregister_reboot_notifier(&wdt_notifier);
-	release_region(WDT_PING,1);
-	release_region(ENABLE_W83877F_PORT,2);
+	release_region(WDT_PING, 1);
+	release_region(ENABLE_W83877F_PORT, 2);
 }
 
 static int __init w83877f_wdt_init(void)
 {
 	int rc = -EBUSY;
 
-	if(timeout < 1 || timeout > 3600) /* arbitrary upper limit */
-	{
+	if (timeout < 1 || timeout > 3600) { /* arbitrary upper limit */
 		timeout = WATCHDOG_TIMEOUT;
-		printk(KERN_INFO PFX "timeout value must be 1<=x<=3600, using %d\n",
-			timeout);
+		printk(KERN_INFO PFX
+			"timeout value must be 1 <= x <= 3600, using %d\n",
+							timeout);
 	}
 
-	if (!request_region(ENABLE_W83877F_PORT, 2, "W83877F WDT"))
-	{
+	if (!request_region(ENABLE_W83877F_PORT, 2, "W83877F WDT")) {
 		printk(KERN_ERR PFX "I/O address 0x%04x already in use\n",
 			ENABLE_W83877F_PORT);
 		rc = -EIO;
 		goto err_out;
 	}
 
-	if (!request_region(WDT_PING, 1, "W8387FF WDT"))
-	{
+	if (!request_region(WDT_PING, 1, "W8387FF WDT")) {
 		printk(KERN_ERR PFX "I/O address 0x%04x already in use\n",
 			WDT_PING);
 		rc = -EIO;
@@ -374,22 +377,22 @@ static int __init w83877f_wdt_init(void)
 	}
 
 	rc = register_reboot_notifier(&wdt_notifier);
-	if (rc)
-	{
-		printk(KERN_ERR PFX "cannot register reboot notifier (err=%d)\n",
-			rc);
+	if (rc) {
+		printk(KERN_ERR PFX
+			"cannot register reboot notifier (err=%d)\n", rc);
 		goto err_out_region2;
 	}
 
 	rc = misc_register(&wdt_miscdev);
-	if (rc)
-	{
-		printk(KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
-			wdt_miscdev.minor, rc);
+	if (rc) {
+		printk(KERN_ERR PFX
+			"cannot register miscdev on minor=%d (err=%d)\n",
+							wdt_miscdev.minor, rc);
 		goto err_out_reboot;
 	}
 
-	printk(KERN_INFO PFX "WDT driver for W83877F initialised. timeout=%d sec (nowayout=%d)\n",
+	printk(KERN_INFO PFX
+	  "WDT driver for W83877F initialised. timeout=%d sec (nowayout=%d)\n",
 		timeout, nowayout);
 
 	return 0;
@@ -397,9 +400,9 @@ static int __init w83877f_wdt_init(void)
 err_out_reboot:
 	unregister_reboot_notifier(&wdt_notifier);
 err_out_region2:
-	release_region(WDT_PING,1);
+	release_region(WDT_PING, 1);
 err_out_region1:
-	release_region(ENABLE_W83877F_PORT,2);
+	release_region(ENABLE_W83877F_PORT, 2);
 err_out:
 	return rc;
 }

