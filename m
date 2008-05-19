Return-Path: <linux-kernel-owner+w=401wt.eu-S1761317AbYESNdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761317AbYESNdt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:33:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759790AbYESNU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:20:58 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45987 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760517AbYESNU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:20:57 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 47/57] softdog: clean up,
	coding style and switch to unlocked_ioctl
To: akpm@osdl.org, linux-kernel@vger.kernel.org, wim@iguana.be
Date: Mon, 19 May 2008 14:09:06 +0100
Message-ID: <20080519130906.31722.25125.stgit@core>
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

 drivers/watchdog/softdog.c |   87 +++++++++++++++++++++++---------------------
 1 files changed, 46 insertions(+), 41 deletions(-)


diff --git a/drivers/watchdog/softdog.c b/drivers/watchdog/softdog.c
index 9c36949..bb3c75e 100644
--- a/drivers/watchdog/softdog.c
+++ b/drivers/watchdog/softdog.c
@@ -47,19 +47,22 @@
 #include <linux/reboot.h>
 #include <linux/init.h>
 #include <linux/jiffies.h>
-
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 #define PFX "SoftDog: "
 
 #define TIMER_MARGIN	60		/* Default is 60 seconds */
 static int soft_margin = TIMER_MARGIN;	/* in seconds */
 module_param(soft_margin, int, 0);
-MODULE_PARM_DESC(soft_margin, "Watchdog soft_margin in seconds. (0<soft_margin<65536, default=" __MODULE_STRING(TIMER_MARGIN) ")");
+MODULE_PARM_DESC(soft_margin,
+	"Watchdog soft_margin in seconds. (0 < soft_margin < 65536, default="
+					__MODULE_STRING(TIMER_MARGIN) ")");
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+		"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 #ifdef ONLY_TESTING
 static int soft_noboot = 1;
@@ -93,8 +96,7 @@ static void watchdog_fire(unsigned long data)
 
 	if (soft_noboot)
 		printk(KERN_CRIT PFX "Triggered - Reboot ignored.\n");
-	else
-	{
+	else {
 		printk(KERN_CRIT PFX "Initiating system reboot.\n");
 		emergency_restart();
 		printk(KERN_CRIT PFX "Reboot didn't ?????\n");
@@ -153,7 +155,8 @@ static int softdog_release(struct inode *inode, struct file *file)
 		softdog_stop();
 		module_put(THIS_MODULE);
 	} else {
-		printk(KERN_CRIT PFX "Unexpected close, not stopping watchdog!\n");
+		printk(KERN_CRIT PFX
+			"Unexpected close, not stopping watchdog!\n");
 		set_bit(0, &orphan_timer);
 		softdog_keepalive();
 	}
@@ -162,12 +165,13 @@ static int softdog_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static ssize_t softdog_write(struct file *file, const char __user *data, size_t len, loff_t *ppos)
+static ssize_t softdog_write(struct file *file, const char __user *data,
+						size_t len, loff_t *ppos)
 {
 	/*
 	 *	Refresh the timer.
 	 */
-	if(len) {
+	if (len) {
 		if (!nowayout) {
 			size_t i;
 
@@ -188,13 +192,13 @@ static ssize_t softdog_write(struct file *file, const char __user *data, size_t
 	return len;
 }
 
-static int softdog_ioctl(struct inode *inode, struct file *file,
-	unsigned int cmd, unsigned long arg)
+static long softdog_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
 	int new_margin;
-	static struct watchdog_info ident = {
+	static const struct watchdog_info ident = {
 		.options =		WDIOF_SETTIMEOUT |
 					WDIOF_KEEPALIVEPING |
 					WDIOF_MAGICCLOSE,
@@ -202,26 +206,25 @@ static int softdog_ioctl(struct inode *inode, struct file *file,
 		.identity =		"Software Watchdog",
 	};
 	switch (cmd) {
-		default:
-			return -ENOTTY;
-		case WDIOC_GETSUPPORT:
-			return copy_to_user(argp, &ident,
-				sizeof(ident)) ? -EFAULT : 0;
-		case WDIOC_GETSTATUS:
-		case WDIOC_GETBOOTSTATUS:
-			return put_user(0, p);
-		case WDIOC_KEEPALIVE:
-			softdog_keepalive();
-			return 0;
-		case WDIOC_SETTIMEOUT:
-			if (get_user(new_margin, p))
-				return -EFAULT;
-			if (softdog_set_heartbeat(new_margin))
-				return -EINVAL;
-			softdog_keepalive();
-			/* Fall */
-		case WDIOC_GETTIMEOUT:
-			return put_user(soft_margin, p);
+	default:
+		return -ENOTTY;
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(argp, &ident, sizeof(ident)) ? -EFAULT : 0;
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, p);
+	case WDIOC_KEEPALIVE:
+		softdog_keepalive();
+		return 0;
+	case WDIOC_SETTIMEOUT:
+		if (get_user(new_margin, p))
+			return -EFAULT;
+		if (softdog_set_heartbeat(new_margin))
+			return -EINVAL;
+		softdog_keepalive();
+		/* Fall */
+	case WDIOC_GETTIMEOUT:
+		return put_user(soft_margin, p);
 	}
 }
 
@@ -232,10 +235,9 @@ static int softdog_ioctl(struct inode *inode, struct file *file,
 static int softdog_notify_sys(struct notifier_block *this, unsigned long code,
 	void *unused)
 {
-	if(code==SYS_DOWN || code==SYS_HALT) {
+	if (code == SYS_DOWN || code == SYS_HALT)
 		/* Turn the WDT off */
 		softdog_stop();
-	}
 	return NOTIFY_DONE;
 }
 
@@ -247,7 +249,7 @@ static const struct file_operations softdog_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= softdog_write,
-	.ioctl		= softdog_ioctl,
+	.unlocked_ioctl	= softdog_ioctl,
 	.open		= softdog_open,
 	.release	= softdog_release,
 };
@@ -268,24 +270,27 @@ static int __init watchdog_init(void)
 {
 	int ret;
 
-	/* Check that the soft_margin value is within it's range ; if not reset to the default */
+	/* Check that the soft_margin value is within it's range;
+	   if not reset to the default */
 	if (softdog_set_heartbeat(soft_margin)) {
 		softdog_set_heartbeat(TIMER_MARGIN);
-		printk(KERN_INFO PFX "soft_margin value must be 0<soft_margin<65536, using %d\n",
+		printk(KERN_INFO PFX
+		    "soft_margin must be 0 < soft_margin < 65536, using %d\n",
 			TIMER_MARGIN);
 	}
 
 	ret = register_reboot_notifier(&softdog_notifier);
 	if (ret) {
-		printk (KERN_ERR PFX "cannot register reboot notifier (err=%d)\n",
-			ret);
+		printk(KERN_ERR PFX
+			"cannot register reboot notifier (err=%d)\n", ret);
 		return ret;
 	}
 
 	ret = misc_register(&softdog_miscdev);
 	if (ret) {
-		printk (KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
-			WATCHDOG_MINOR, ret);
+		printk(KERN_ERR PFX
+			"cannot register miscdev on minor=%d (err=%d)\n",
+						WATCHDOG_MINOR, ret);
 		unregister_reboot_notifier(&softdog_notifier);
 		return ret;
 	}

