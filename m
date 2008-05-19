Return-Path: <linux-kernel-owner+w=401wt.eu-S1760841AbYESNTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760841AbYESNTt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:19:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755983AbYESNRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:17:17 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57968 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759512AbYESNRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:17:15 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 07/57] cpu5_wdt: switch to unlocked_ioctl
To: akpm@osdl.org, linux-kernel@vger.kernel.org, wim@iguana.be
Date: Mon, 19 May 2008 14:05:24 +0100
Message-ID: <20080519130524.31722.18774.stgit@core>
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

 drivers/watchdog/cpu5wdt.c |  144 +++++++++++++++++++++-----------------------
 1 files changed, 70 insertions(+), 74 deletions(-)


diff --git a/drivers/watchdog/cpu5wdt.c b/drivers/watchdog/cpu5wdt.c
index df72f90..ec324e5 100644
--- a/drivers/watchdog/cpu5wdt.c
+++ b/drivers/watchdog/cpu5wdt.c
@@ -30,16 +30,16 @@
 #include <linux/timer.h>
 #include <linux/completion.h>
 #include <linux/jiffies.h>
-#include <asm/io.h>
-#include <asm/uaccess.h>
-
+#include <linux/io.h>
+#include <linux/uaccess.h>
 #include <linux/watchdog.h>
 
 /* adjustable parameters */
 
-static int verbose = 0;
+static int verbose;
 static int port = 0x91;
 static int ticks = 10000;
+static spinlock_t cpu5wdt_lock;
 
 #define PFX			"cpu5wdt: "
 
@@ -70,12 +70,13 @@ static struct {
 
 static void cpu5wdt_trigger(unsigned long unused)
 {
-	if ( verbose > 2 )
+	if (verbose > 2)
 		printk(KERN_DEBUG PFX "trigger at %i ticks\n", ticks);
 
-	if( cpu5wdt_device.running )
+	if (cpu5wdt_device.running)
 		ticks--;
 
+	spin_lock(&cpu5wdt_lock);
 	/* keep watchdog alive */
 	outb(1, port + CPU5WDT_TRIGGER_REG);
 
@@ -86,6 +87,7 @@ static void cpu5wdt_trigger(unsigned long unused)
 		/* ticks doesn't matter anyway */
 		complete(&cpu5wdt_device.stop);
 	}
+	spin_unlock(&cpu5wdt_lock);
 
 }
 
@@ -93,14 +95,17 @@ static void cpu5wdt_reset(void)
 {
 	ticks = cpu5wdt_device.default_ticks;
 
-	if ( verbose )
+	if (verbose)
 		printk(KERN_DEBUG PFX "reset (%i ticks)\n", (int) ticks);
 
 }
 
 static void cpu5wdt_start(void)
 {
-	if ( !cpu5wdt_device.queue ) {
+	unsigned long flags;
+
+	spin_lock_irqsave(&cpu5wdt_lock, flags);
+	if (!cpu5wdt_device.queue) {
 		cpu5wdt_device.queue = 1;
 		outb(0, port + CPU5WDT_TIME_A_REG);
 		outb(0, port + CPU5WDT_TIME_B_REG);
@@ -111,18 +116,20 @@ static void cpu5wdt_start(void)
 	}
 	/* if process dies, counter is not decremented */
 	cpu5wdt_device.running++;
+	spin_unlock_irqrestore(&cpu5wdt_lock, flags);
 }
 
 static int cpu5wdt_stop(void)
 {
-	if ( cpu5wdt_device.running )
-		cpu5wdt_device.running = 0;
+	unsigned long flags;
 
+	spin_lock_irqsave(&cpu5wdt_lock, flags);
+	if (cpu5wdt_device.running)
+		cpu5wdt_device.running = 0;
 	ticks = cpu5wdt_device.default_ticks;
-
-	if ( verbose )
+	spin_unlock_irqrestore(&cpu5wdt_lock, flags);
+	if (verbose)
 		printk(KERN_CRIT PFX "stop not possible\n");
-
 	return -EIO;
 }
 
@@ -130,9 +137,8 @@ static int cpu5wdt_stop(void)
 
 static int cpu5wdt_open(struct inode *inode, struct file *file)
 {
-	if ( test_and_set_bit(0, &cpu5wdt_device.inuse) )
+	if (test_and_set_bit(0, &cpu5wdt_device.inuse))
 		return -EBUSY;
-
 	return nonseekable_open(inode, file);
 }
 
@@ -142,67 +148,58 @@ static int cpu5wdt_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static int cpu5wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
+static long cpu5wdt_ioctl(struct file *file, unsigned int cmd,
+						unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
+	int __user *p = argp;
 	unsigned int value;
-	static struct watchdog_info ident =
-	{
+	static struct watchdog_info ident = {
 		.options = WDIOF_CARDRESET,
 		.identity = "CPU5 WDT",
 	};
 
-	switch(cmd) {
-		case WDIOC_KEEPALIVE:
-			cpu5wdt_reset();
-			break;
-		case WDIOC_GETSTATUS:
-			value = inb(port + CPU5WDT_STATUS_REG);
-			value = (value >> 2) & 1;
-			if ( copy_to_user(argp, &value, sizeof(int)) )
-				return -EFAULT;
-			break;
-		case WDIOC_GETBOOTSTATUS:
-			if ( copy_to_user(argp, &value, sizeof(int)) )
-				return -EFAULT;
-			break;
-		case WDIOC_GETSUPPORT:
-			if ( copy_to_user(argp, &ident, sizeof(ident)) )
-				return -EFAULT;
-			break;
-		case WDIOC_SETOPTIONS:
-			if ( copy_from_user(&value, argp, sizeof(int)) )
-				return -EFAULT;
-			switch(value) {
-				case WDIOS_ENABLECARD:
-					cpu5wdt_start();
-					break;
-				case WDIOS_DISABLECARD:
-					return cpu5wdt_stop();
-				default:
-					return -EINVAL;
-			}
-			break;
-		default:
-    			return -ENOTTY;
+	switch (cmd) {
+	case WDIOC_KEEPALIVE:
+		cpu5wdt_reset();
+		break;
+	case WDIOC_GETSTATUS:
+		value = inb(port + CPU5WDT_STATUS_REG);
+		value = (value >> 2) & 1;
+		return put_user(value, p);
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, p);
+	case WDIOC_GETSUPPORT:
+		if (copy_to_user(argp, &ident, sizeof(ident)))
+			return -EFAULT;
+		break;
+	case WDIOC_SETOPTIONS:
+		if (get_user(value, p))
+			return -EFAULT;
+		if (value & WDIOS_ENABLECARD)
+			cpu5wdt_start();
+		if (value & WDIOS_DISABLECARD)
+			cpu5wdt_stop();
+		break;
+	default:
+		return -ENOTTY;
 	}
 	return 0;
 }
 
-static ssize_t cpu5wdt_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
+static ssize_t cpu5wdt_write(struct file *file, const char __user *buf,
+						size_t count, loff_t *ppos)
 {
-	if ( !count )
+	if (!count)
 		return -EIO;
-
 	cpu5wdt_reset();
-
 	return count;
 }
 
 static const struct file_operations cpu5wdt_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
-	.ioctl		= cpu5wdt_ioctl,
+	.unlocked_ioctl	= cpu5wdt_ioctl,
 	.open		= cpu5wdt_open,
 	.write		= cpu5wdt_write,
 	.release	= cpu5wdt_release,
@@ -221,37 +218,36 @@ static int __devinit cpu5wdt_init(void)
 	unsigned int val;
 	int err;
 
-	if ( verbose )
-		printk(KERN_DEBUG PFX "port=0x%x, verbose=%i\n", port, verbose);
+	if (verbose)
+		printk(KERN_DEBUG PFX
+				"port=0x%x, verbose=%i\n", port, verbose);
 
-	if ( !request_region(port, CPU5WDT_EXTENT, PFX) ) {
+	init_completion(&cpu5wdt_device.stop);
+	spin_lock_init(&cpu5wdt_lock);
+	cpu5wdt_device.queue = 0;
+	setup_timer(&cpu5wdt_device.timer, cpu5wdt_trigger, 0);
+	cpu5wdt_device.default_ticks = ticks;
+
+	if (!request_region(port, CPU5WDT_EXTENT, PFX)) {
 		printk(KERN_ERR PFX "request_region failed\n");
 		err = -EBUSY;
 		goto no_port;
 	}
 
-	if ( (err = misc_register(&cpu5wdt_misc)) < 0 ) {
-		printk(KERN_ERR PFX "misc_register failed\n");
-		goto no_misc;
-	}
-
 	/* watchdog reboot? */
 	val = inb(port + CPU5WDT_STATUS_REG);
 	val = (val >> 2) & 1;
-	if ( !val )
+	if (!val)
 		printk(KERN_INFO PFX "sorry, was my fault\n");
 
-	init_completion(&cpu5wdt_device.stop);
-	cpu5wdt_device.queue = 0;
-
-	clear_bit(0, &cpu5wdt_device.inuse);
-
-	setup_timer(&cpu5wdt_device.timer, cpu5wdt_trigger, 0);
+	err = misc_register(&cpu5wdt_misc);
+	if (err < 0) {
+		printk(KERN_ERR PFX "misc_register failed\n");
+		goto no_misc;
+	}
 
-	cpu5wdt_device.default_ticks = ticks;
 
 	printk(KERN_INFO PFX "init success\n");
-
 	return 0;
 
 no_misc:
@@ -267,7 +263,7 @@ static int __devinit cpu5wdt_init_module(void)
 
 static void __devexit cpu5wdt_exit(void)
 {
-	if ( cpu5wdt_device.queue ) {
+	if (cpu5wdt_device.queue) {
 		cpu5wdt_device.queue = 0;
 		wait_for_completion(&cpu5wdt_device.stop);
 	}

