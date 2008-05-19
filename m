Return-Path: <linux-kernel-owner+w=401wt.eu-S1764589AbYESNbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764589AbYESNbv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:31:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760969AbYESNUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:20:35 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45964 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760951AbYESNUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:20:33 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 41/57] sb_wdog: Clean up and switch to unlocked_ioctl
To: akpm@osdl.org, linux-kernel@vger.kernel.org, wim@iguana.be
Date: Mon, 19 May 2008 14:08:33 +0100
Message-ID: <20080519130833.31722.78050.stgit@core>
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

 drivers/watchdog/sb_wdog.c |   78 +++++++++++++++++++++++---------------------
 1 files changed, 40 insertions(+), 38 deletions(-)


diff --git a/drivers/watchdog/sb_wdog.c b/drivers/watchdog/sb_wdog.c
index b944314..c8b544c 100644
--- a/drivers/watchdog/sb_wdog.c
+++ b/drivers/watchdog/sb_wdog.c
@@ -57,6 +57,7 @@
 #include <asm/sibyte/sb1250_int.h>
 #include <asm/sibyte/sb1250_scd.h>
 
+static DEFINE_SPINLOCK(sbwd_lock);
 
 /*
  * set the initial count value of a timer
@@ -65,8 +66,10 @@
  */
 void sbwdog_set(char __iomem *wdog, unsigned long t)
 {
+	spin_lock(&sbwd_lock);
 	__raw_writeb(0, wdog - 0x10);
 	__raw_writeq(t & 0x7fffffUL, wdog);
+	spin_unlock(&sbwd_lock);
 }
 
 /*
@@ -77,7 +80,9 @@ void sbwdog_set(char __iomem *wdog, unsigned long t)
  */
 void sbwdog_pet(char __iomem *wdog)
 {
+	spin_lock(&sbwd_lock);
 	__raw_writeb(__raw_readb(wdog) | 1, wdog);
+	spin_unlock(&sbwd_lock);
 }
 
 static unsigned long sbwdog_gate; /* keeps it to one thread only */
@@ -86,8 +91,9 @@ static char __iomem *user_dog = (char __iomem *)(IO_BASE + (A_SCD_WDOG_CFG_1));
 static unsigned long timeout = 0x7fffffUL;	/* useconds: 8.3ish secs. */
 static int expect_close;
 
-static struct watchdog_info ident = {
-	.options	= WDIOF_CARDRESET | WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
+static const struct watchdog_info ident = {
+	.options	= WDIOF_CARDRESET | WDIOF_SETTIMEOUT |
+						WDIOF_KEEPALIVEPING,
 	.identity	= "SiByte Watchdog",
 };
 
@@ -97,9 +103,8 @@ static struct watchdog_info ident = {
 static int sbwdog_open(struct inode *inode, struct file *file)
 {
 	nonseekable_open(inode, file);
-	if (test_and_set_bit(0, &sbwdog_gate)) {
+	if (test_and_set_bit(0, &sbwdog_gate))
 		return -EBUSY;
-	}
 	__module_get(THIS_MODULE);
 
 	/*
@@ -120,8 +125,9 @@ static int sbwdog_release(struct inode *inode, struct file *file)
 		__raw_writeb(0, user_dog);
 		module_put(THIS_MODULE);
 	} else {
-		printk(KERN_CRIT "%s: Unexpected close, not stopping watchdog!\n",
-			ident.identity);
+		printk(KERN_CRIT
+			"%s: Unexpected close, not stopping watchdog!\n",
+						ident.identity);
 		sbwdog_pet(user_dog);
 	}
 	clear_bit(0, &sbwdog_gate);
@@ -147,12 +153,10 @@ static ssize_t sbwdog_write(struct file *file, const char __user *data,
 		for (i = 0; i != len; i++) {
 			char c;
 
-			if (get_user(c, data + i)) {
+			if (get_user(c, data + i))
 				return -EFAULT;
-			}
-			if (c == 'V') {
+			if (c == 'V')
 				expect_close = 42;
-			}
 		}
 		sbwdog_pet(user_dog);
 	}
@@ -160,8 +164,8 @@ static ssize_t sbwdog_write(struct file *file, const char __user *data,
 	return len;
 }
 
-static int sbwdog_ioctl(struct inode *inode, struct file *file,
-			unsigned int cmd, unsigned long arg)
+static long sbwdog_ioctl(struct file *file, unsigned int cmd,
+						unsigned long arg)
 {
 	int ret = -ENOTTY;
 	unsigned long time;
@@ -180,9 +184,8 @@ static int sbwdog_ioctl(struct inode *inode, struct file *file,
 
 	case WDIOC_SETTIMEOUT:
 		ret = get_user(time, p);
-		if (ret) {
+		if (ret)
 			break;
-		}
 
 		time *= 1000000;
 		if (time > 0x7fffffUL) {
@@ -226,18 +229,16 @@ sbwdog_notify_sys(struct notifier_block *this, unsigned long code, void *erf)
 	return NOTIFY_DONE;
 }
 
-static const struct file_operations sbwdog_fops =
-{
+static const struct file_operations sbwdog_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= sbwdog_write,
-	.ioctl		= sbwdog_ioctl,
+	.unlocked_ioctl	= sbwdog_ioctl,
 	.open		= sbwdog_open,
 	.release	= sbwdog_release,
 };
 
-static struct miscdevice sbwdog_miscdev =
-{
+static struct miscdevice sbwdog_miscdev = {
 	.minor		= WATCHDOG_MINOR,
 	.name		= "watchdog",
 	.fops		= &sbwdog_fops,
@@ -267,13 +268,12 @@ irqreturn_t sbwdog_interrupt(int irq, void *addr)
 	/*
 	 * if it's the second watchdog timer, it's for those users
 	 */
-	if (wd_cfg_reg == user_dog) {
+	if (wd_cfg_reg == user_dog)
 		printk(KERN_CRIT
 			"%s in danger of initiating system reset in %ld.%01ld seconds\n",
 			ident.identity, wd_init / 1000000, (wd_init / 100000) % 10);
-	} else {
+	else
 		cfg |= 1;
-	}
 
 	__raw_writeb(cfg, wd_cfg_reg);
 
@@ -289,28 +289,31 @@ static int __init sbwdog_init(void)
 	 */
 	ret = register_reboot_notifier(&sbwdog_notifier);
 	if (ret) {
-		printk (KERN_ERR "%s: cannot register reboot notifier (err=%d)\n",
-			ident.identity, ret);
+		printk(KERN_ERR
+			"%s: cannot register reboot notifier (err=%d)\n",
+						ident.identity, ret);
 		return ret;
 	}
 
 	/*
 	 * get the resources
 	 */
-	ret = misc_register(&sbwdog_miscdev);
-	if (ret == 0) {
-		printk(KERN_INFO "%s: timeout is %ld.%ld secs\n", ident.identity,
-			timeout / 1000000, (timeout / 100000) % 10);
-	}
 
 	ret = request_irq(1, sbwdog_interrupt, IRQF_DISABLED | IRQF_SHARED,
 		ident.identity, (void *)user_dog);
 	if (ret) {
-		printk(KERN_ERR "%s: failed to request irq 1 - %d\n", ident.identity,
-			ret);
-		misc_deregister(&sbwdog_miscdev);
+		printk(KERN_ERR "%s: failed to request irq 1 - %d\n",
+						ident.identity, ret);
+		return ret;
 	}
 
+	ret = misc_register(&sbwdog_miscdev);
+	if (ret == 0) {
+		printk(KERN_INFO "%s: timeout is %ld.%ld secs\n",
+				ident.identity,
+				timeout / 1000000, (timeout / 100000) % 10);
+	} else
+		free_irq(1, (void *)user_dog);
 	return ret;
 }
 
@@ -327,7 +330,7 @@ MODULE_DESCRIPTION("SiByte Watchdog");
 
 module_param(timeout, ulong, 0);
 MODULE_PARM_DESC(timeout,
-	"Watchdog timeout in microseconds (max/default 8388607 or 8.3ish secs)");
+      "Watchdog timeout in microseconds (max/default 8388607 or 8.3ish secs)");
 
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
@@ -336,16 +339,15 @@ MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
  * example code that can be put in a platform code area to utilize the
  * first watchdog timer for the kernels own purpose.
 
- void
-platform_wd_setup(void)
+void platform_wd_setup(void)
 {
 	int ret;
 
-	ret = request_irq(0, sbwdog_interrupt, IRQF_DISABLED | IRQF_SHARED,
+	ret = request_irq(1, sbwdog_interrupt, IRQF_DISABLED | IRQF_SHARED,
 		"Kernel Watchdog", IOADDR(A_SCD_WDOG_CFG_0));
 	if (ret) {
-		printk(KERN_CRIT "Watchdog IRQ zero(0) failed to be requested - %d\n",
-			ret);
+		printk(KERN_CRIT
+		  "Watchdog IRQ zero(0) failed to be requested - %d\n", ret);
 	}
 }
 

