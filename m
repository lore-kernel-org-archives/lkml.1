Return-Path: <linux-kernel-owner+w=401wt.eu-S1761284AbYESNVE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761284AbYESNVE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:21:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759710AbYESNRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:17:32 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45814 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759681AbYESNRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:17:30 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 10/57] eurotechwdt: unlocked_ioctl, code lock check and tidy
To: akpm@osdl.org, linux-kernel@vger.kernel.org, wim@iguana.be
Date: Mon, 19 May 2008 14:05:41 +0100
Message-ID: <20080519130541.31722.15804.stgit@core>
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

 drivers/watchdog/eurotechwdt.c |   57 +++++++++++++++++++++++++---------------
 1 files changed, 36 insertions(+), 21 deletions(-)


diff --git a/drivers/watchdog/eurotechwdt.c b/drivers/watchdog/eurotechwdt.c
index b14e9d1..b94e6ef 100644
--- a/drivers/watchdog/eurotechwdt.c
+++ b/drivers/watchdog/eurotechwdt.c
@@ -56,14 +56,15 @@
 #include <linux/notifier.h>
 #include <linux/reboot.h>
 #include <linux/init.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 
-#include <asm/io.h>
-#include <asm/uaccess.h>
 #include <asm/system.h>
 
 static unsigned long eurwdt_is_open;
 static int eurwdt_timeout;
 static char eur_expect_close;
+static spinlock_t eurwdt_lock;
 
 /*
  * You must set these - there is no sane way to probe for this board.
@@ -78,7 +79,9 @@ static char *ev = "int";
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+		"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 /*
  * Some symbolic names
@@ -137,7 +140,8 @@ static void eurwdt_activate_timer(void)
 {
 	eurwdt_disable_timer();
 	eurwdt_write_reg(WDT_CTRL_REG, 0x01);	/* activate the WDT */
-	eurwdt_write_reg(WDT_OUTPIN_CFG, !strcmp("int", ev) ? WDT_EVENT_INT : WDT_EVENT_REBOOT);
+	eurwdt_write_reg(WDT_OUTPIN_CFG,
+		!strcmp("int", ev) ? WDT_EVENT_INT : WDT_EVENT_REBOOT);
 
 	/* Setting interrupt line */
 	if (irq == 2 || irq > 15 || irq < 0) {
@@ -206,21 +210,21 @@ size_t count, loff_t *ppos)
 
 			for (i = 0; i != count; i++) {
 				char c;
-				if(get_user(c, buf+i))
+				if (get_user(c, buf+i))
 					return -EFAULT;
 				if (c == 'V')
 					eur_expect_close = 42;
 			}
 		}
+		spin_lock(&eurwdt_lock);
 		eurwdt_ping();	/* the default timeout */
+		spin_unlock(&eurwdt_lock);
 	}
-
 	return count;
 }
 
 /**
  * eurwdt_ioctl:
- * @inode: inode of the device
  * @file: file handle to the device
  * @cmd: watchdog command
  * @arg: argument pointer
@@ -229,13 +233,14 @@ size_t count, loff_t *ppos)
  * according to their available features.
  */
 
-static int eurwdt_ioctl(struct inode *inode, struct file *file,
-	unsigned int cmd, unsigned long arg)
+static long eurwdt_ioctl(struct file *file,
+					unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
 	static struct watchdog_info ident = {
-		.options	  = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT | WDIOF_MAGICCLOSE,
+		.options	  = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT
+							| WDIOF_MAGICCLOSE,
 		.firmware_version = 1,
 		.identity	  = "WDT Eurotech CPU-1220/1410",
 	};
@@ -243,7 +248,7 @@ static int eurwdt_ioctl(struct inode *inode, struct file *file,
 	int time;
 	int options, retval = -EINVAL;
 
-	switch(cmd) {
+	switch (cmd) {
 	default:
 		return -ENOTTY;
 
@@ -255,7 +260,9 @@ static int eurwdt_ioctl(struct inode *inode, struct file *file,
 		return put_user(0, p);
 
 	case WDIOC_KEEPALIVE:
+		spin_lock(&eurwdt_lock);
 		eurwdt_ping();
+		spin_unlock(&eurwdt_lock);
 		return 0;
 
 	case WDIOC_SETTIMEOUT:
@@ -266,8 +273,10 @@ static int eurwdt_ioctl(struct inode *inode, struct file *file,
 		if (time < 0 || time > 255)
 			return -EINVAL;
 
+		spin_lock(&eurwdt_lock);
 		eurwdt_timeout = time;
 		eurwdt_set_timeout(time);
+		spin_unlock(&eurwdt_lock);
 		/* Fall */
 
 	case WDIOC_GETTIMEOUT:
@@ -276,6 +285,7 @@ static int eurwdt_ioctl(struct inode *inode, struct file *file,
 	case WDIOC_SETOPTIONS:
 		if (get_user(options, p))
 			return -EFAULT;
+		spin_lock(&eurwdt_lock);
 		if (options & WDIOS_DISABLECARD) {
 			eurwdt_disable_timer();
 			retval = 0;
@@ -285,6 +295,7 @@ static int eurwdt_ioctl(struct inode *inode, struct file *file,
 			eurwdt_ping();
 			retval = 0;
 		}
+		spin_unlock(&eurwdt_lock);
 		return retval;
 	}
 }
@@ -322,10 +333,11 @@ static int eurwdt_open(struct inode *inode, struct file *file)
 
 static int eurwdt_release(struct inode *inode, struct file *file)
 {
-	if (eur_expect_close == 42) {
+	if (eur_expect_close == 42)
 		eurwdt_disable_timer();
-	} else {
-		printk(KERN_CRIT "eurwdt: Unexpected close, not stopping watchdog!\n");
+	else {
+		printk(KERN_CRIT
+			"eurwdt: Unexpected close, not stopping watchdog!\n");
 		eurwdt_ping();
 	}
 	clear_bit(0, &eurwdt_is_open);
@@ -362,11 +374,11 @@ static int eurwdt_notify_sys(struct notifier_block *this, unsigned long code,
 
 
 static const struct file_operations eurwdt_fops = {
-	.owner	= THIS_MODULE,
-	.llseek	= no_llseek,
-	.write	= eurwdt_write,
-	.ioctl	= eurwdt_ioctl,
-	.open	= eurwdt_open,
+	.owner		= THIS_MODULE,
+	.llseek		= no_llseek,
+	.write		= eurwdt_write,
+	.unlocked_ioctl	= eurwdt_ioctl,
+	.open		= eurwdt_open,
 	.release	= eurwdt_release,
 };
 
@@ -419,7 +431,7 @@ static int __init eurwdt_init(void)
 	int ret;
 
 	ret = request_irq(irq, eurwdt_interrupt, IRQF_DISABLED, "eurwdt", NULL);
-	if(ret) {
+	if (ret) {
 		printk(KERN_ERR "eurwdt: IRQ %d is not free.\n", irq);
 		goto out;
 	}
@@ -432,10 +444,13 @@ static int __init eurwdt_init(void)
 
 	ret = register_reboot_notifier(&eurwdt_notifier);
 	if (ret) {
-		printk(KERN_ERR "eurwdt: can't register reboot notifier (err=%d)\n", ret);
+		printk(KERN_ERR
+		    "eurwdt: can't register reboot notifier (err=%d)\n", ret);
 		goto outreg;
 	}
 
+	spin_lock_init(&eurwdt_lock);
+
 	ret = misc_register(&eurwdt_miscdev);
 	if (ret) {
 		printk(KERN_ERR "eurwdt: can't misc_register on minor=%d\n",

