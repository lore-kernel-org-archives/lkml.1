Return-Path: <linux-kernel-owner+w=401wt.eu-S1758275AbYA1TsH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758275AbYA1TsH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 14:48:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753850AbYA1Trz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 14:47:55 -0500
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:7360 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753033AbYA1Trx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 14:47:53 -0500
X-Belgacom-Dynamic: yes
Date: Mon, 28 Jan 2008 20:47:44 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [WATCHOG] v2.6.24 watchdog patches
Message-ID: <20080128194744.GA3031@infomag.infomag.iguana.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
or if master.kernel.org hasn't synced up yet:
	master.kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git

This will update the following files:

 drivers/watchdog/Kconfig        |    6 
 drivers/watchdog/Makefile       |    1 
 drivers/watchdog/alim1535_wdt.c |   20 +-
 drivers/watchdog/alim7101_wdt.c |   18 +-
 drivers/watchdog/ar7_wdt.c      |    2 
 drivers/watchdog/bfin_wdt.c     |    2 
 drivers/watchdog/it8712f_wdt.c  |    2 
 drivers/watchdog/mpc5200_wdt.c  |    2 
 drivers/watchdog/mtx-1_wdt.c    |    2 
 drivers/watchdog/sbc60xxwdt.c   |   18 +-
 drivers/watchdog/scx200_wdt.c   |   10 -
 drivers/watchdog/txx9wdt.c      |  276 ++++++++++++++++++++++++++++++++++++++++
 drivers/watchdog/w83877f_wdt.c  |   18 +-
 drivers/watchdog/w83977f_wdt.c  |   18 +-
 drivers/watchdog/wdt.c          |   30 +++-
 drivers/watchdog/wdt977.c       |   18 +-
 16 files changed, 375 insertions(+), 68 deletions(-)

with these Changes:

Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Tue Jan 22 20:48:10 2008 +0100

    [WATCHDOG] constify function pointer tables
    
    "static struct file_operations" should be
    "static const struct file_operations".
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Date:   Mon Nov 12 01:32:17 2007 +0900

    [WATCHDOG] TXx9 watchdog driver
    
    This is a driver for watchdog timer built into TXx9 MIPS SoCs.
    
    Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
    Cc: Ralf Baechle <ralf@linux-mips.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Wed Dec 26 20:32:51 2007 +0000

    [WATCHDOG] misc_register patch
    
    Make sure that we first do a register_reboot_notifier before we
    do a misc_register. A misc_register opens the interface to
    userspace and it's best to do this as the last action.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date:   Wed Jan 9 21:36:01 2008 -0800

    [WATCHDOG] wdt: fix locking
    
    The audit of _p usage shows various drivers assume inb_p is somehow atomic.
     Of course it isn't and the delay can be split from the I/O cycle causing a
    timing violation on chips that matter (eg this one)
    
    With the proposed use of udelay() for some _p delays this will cease to be
    a mostly theoretical bug (as the delay stall is unsplittable) and wants
    fixing.
    
    Lots of other drivers need fixing this way too.
    
    Signed-off-by: Alan Cox <alan@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index fbd6112..899fc13 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -639,6 +639,12 @@ config AR7_WDT
 	help
 	  Hardware driver for the TI AR7 Watchdog Timer.
 
+config TXX9_WDT
+	tristate "Toshiba TXx9 Watchdog Timer"
+	depends on CPU_TX39XX || CPU_TX49XX
+	help
+	  Hardware driver for the built-in watchdog timer on TXx9 MIPS SoCs.
+
 # PARISC Architecture
 
 # POWERPC Architecture
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index 87483cc..ebc2114 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -93,6 +93,7 @@ obj-$(CONFIG_INDYDOG) += indydog.o
 obj-$(CONFIG_WDT_MTX1)	+= mtx-1_wdt.o
 obj-$(CONFIG_WDT_RM9K_GPI) += rm9k_wdt.o
 obj-$(CONFIG_AR7_WDT) += ar7_wdt.o
+obj-$(CONFIG_TXX9_WDT) += txx9wdt.o
 
 # PARISC Architecture
 
diff --git a/drivers/watchdog/alim1535_wdt.c b/drivers/watchdog/alim1535_wdt.c
index b481cc0..2b1fbdb 100644
--- a/drivers/watchdog/alim1535_wdt.c
+++ b/drivers/watchdog/alim1535_wdt.c
@@ -413,18 +413,18 @@ static int __init watchdog_init(void)
 	/* Calculate the watchdog's timeout */
 	ali_settimer(timeout);
 
-	ret = misc_register(&ali_miscdev);
+	ret = register_reboot_notifier(&ali_notifier);
 	if (ret != 0) {
-		printk(KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
-			WATCHDOG_MINOR, ret);
+		printk(KERN_ERR PFX "cannot register reboot notifier (err=%d)\n",
+			ret);
 		goto out;
 	}
 
-	ret = register_reboot_notifier(&ali_notifier);
+	ret = misc_register(&ali_miscdev);
 	if (ret != 0) {
-		printk(KERN_ERR PFX "cannot register reboot notifier (err=%d)\n",
-			ret);
-		goto unreg_miscdev;
+		printk(KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
+			WATCHDOG_MINOR, ret);
+		goto unreg_reboot;
 	}
 
 	printk(KERN_INFO PFX "initialized. timeout=%d sec (nowayout=%d)\n",
@@ -432,8 +432,8 @@ static int __init watchdog_init(void)
 
 out:
 	return ret;
-unreg_miscdev:
-	misc_deregister(&ali_miscdev);
+unreg_reboot:
+	unregister_reboot_notifier(&ali_notifier);
 	goto out;
 }
 
@@ -449,8 +449,8 @@ static void __exit watchdog_exit(void)
 	ali_stop();
 
 	/* Deregister */
-	unregister_reboot_notifier(&ali_notifier);
 	misc_deregister(&ali_miscdev);
+	unregister_reboot_notifier(&ali_notifier);
 	pci_dev_put(ali_pci);
 }
 
diff --git a/drivers/watchdog/alim7101_wdt.c b/drivers/watchdog/alim7101_wdt.c
index 67aed9f..238273c 100644
--- a/drivers/watchdog/alim7101_wdt.c
+++ b/drivers/watchdog/alim7101_wdt.c
@@ -377,18 +377,18 @@ static int __init alim7101_wdt_init(void)
 			timeout);
 	}
 
-	rc = misc_register(&wdt_miscdev);
+	rc = register_reboot_notifier(&wdt_notifier);
 	if (rc) {
-		printk(KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
-			wdt_miscdev.minor, rc);
+		printk(KERN_ERR PFX "cannot register reboot notifier (err=%d)\n",
+			rc);
 		goto err_out;
 	}
 
-	rc = register_reboot_notifier(&wdt_notifier);
+	rc = misc_register(&wdt_miscdev);
 	if (rc) {
-		printk(KERN_ERR PFX "cannot register reboot notifier (err=%d)\n",
-			rc);
-		goto err_out_miscdev;
+		printk(KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
+			wdt_miscdev.minor, rc);
+		goto err_out_reboot;
 	}
 
 	if (nowayout) {
@@ -399,8 +399,8 @@ static int __init alim7101_wdt_init(void)
 		timeout, nowayout);
 	return 0;
 
-err_out_miscdev:
-	misc_deregister(&wdt_miscdev);
+err_out_reboot:
+	unregister_reboot_notifier(&wdt_notifier);
 err_out:
 	pci_dev_put(alim7101_pmu);
 	return rc;
diff --git a/drivers/watchdog/ar7_wdt.c b/drivers/watchdog/ar7_wdt.c
index cdaab8c..2eb48c0 100644
--- a/drivers/watchdog/ar7_wdt.c
+++ b/drivers/watchdog/ar7_wdt.c
@@ -279,7 +279,7 @@ static int ar7_wdt_ioctl(struct inode *inode, struct file *file,
 	}
 }
 
-static struct file_operations ar7_wdt_fops = {
+static const struct file_operations ar7_wdt_fops = {
 	.owner		= THIS_MODULE,
 	.write		= ar7_wdt_write,
 	.ioctl		= ar7_wdt_ioctl,
diff --git a/drivers/watchdog/bfin_wdt.c b/drivers/watchdog/bfin_wdt.c
index 31dc7a6..472be10 100644
--- a/drivers/watchdog/bfin_wdt.c
+++ b/drivers/watchdog/bfin_wdt.c
@@ -390,7 +390,7 @@ static struct platform_driver bfin_wdt_driver = {
 	.resume    = bfin_wdt_resume,
 };
 
-static struct file_operations bfin_wdt_fops = {
+static const struct file_operations bfin_wdt_fops = {
 	.owner    = THIS_MODULE,
 	.llseek   = no_llseek,
 	.write    = bfin_wdt_write,
diff --git a/drivers/watchdog/it8712f_wdt.c b/drivers/watchdog/it8712f_wdt.c
index 6330fc0..1b6d7d1 100644
--- a/drivers/watchdog/it8712f_wdt.c
+++ b/drivers/watchdog/it8712f_wdt.c
@@ -296,7 +296,7 @@ it8712f_wdt_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static struct file_operations it8712f_wdt_fops = {
+static const struct file_operations it8712f_wdt_fops = {
 	.owner = THIS_MODULE,
 	.llseek = no_llseek,
 	.write = it8712f_wdt_write,
diff --git a/drivers/watchdog/mpc5200_wdt.c b/drivers/watchdog/mpc5200_wdt.c
index 11f6a11..80a91d4 100644
--- a/drivers/watchdog/mpc5200_wdt.c
+++ b/drivers/watchdog/mpc5200_wdt.c
@@ -158,7 +158,7 @@ static int mpc5200_wdt_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static struct file_operations mpc5200_wdt_fops = {
+static const struct file_operations mpc5200_wdt_fops = {
 	.owner	= THIS_MODULE,
 	.write	= mpc5200_wdt_write,
 	.ioctl	= mpc5200_wdt_ioctl,
diff --git a/drivers/watchdog/mtx-1_wdt.c b/drivers/watchdog/mtx-1_wdt.c
index dcfd401..9845174 100644
--- a/drivers/watchdog/mtx-1_wdt.c
+++ b/drivers/watchdog/mtx-1_wdt.c
@@ -180,7 +180,7 @@ static ssize_t mtx1_wdt_write(struct file *file, const char *buf, size_t count,
 	return count;
 }
 
-static struct file_operations mtx1_wdt_fops = {
+static const struct file_operations mtx1_wdt_fops = {
 	.owner 		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.ioctl		= mtx1_wdt_ioctl,
diff --git a/drivers/watchdog/sbc60xxwdt.c b/drivers/watchdog/sbc60xxwdt.c
index e4f3cb6..ef76f01 100644
--- a/drivers/watchdog/sbc60xxwdt.c
+++ b/drivers/watchdog/sbc60xxwdt.c
@@ -359,20 +359,20 @@ static int __init sbc60xxwdt_init(void)
 		}
 	}
 
-	rc = misc_register(&wdt_miscdev);
+	rc = register_reboot_notifier(&wdt_notifier);
 	if (rc)
 	{
-		printk(KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
-			wdt_miscdev.minor, rc);
+		printk(KERN_ERR PFX "cannot register reboot notifier (err=%d)\n",
+			rc);
 		goto err_out_region2;
 	}
 
-	rc = register_reboot_notifier(&wdt_notifier);
+	rc = misc_register(&wdt_miscdev);
 	if (rc)
 	{
-		printk(KERN_ERR PFX "cannot register reboot notifier (err=%d)\n",
-			rc);
-		goto err_out_miscdev;
+		printk(KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
+			wdt_miscdev.minor, rc);
+		goto err_out_reboot;
 	}
 
 	printk(KERN_INFO PFX "WDT driver for 60XX single board computer initialised. timeout=%d sec (nowayout=%d)\n",
@@ -380,8 +380,8 @@ static int __init sbc60xxwdt_init(void)
 
 	return 0;
 
-err_out_miscdev:
-	misc_deregister(&wdt_miscdev);
+err_out_reboot:
+	unregister_reboot_notifier(&wdt_notifier);
 err_out_region2:
 	if ((wdt_stop != 0x45) && (wdt_stop != wdt_start))
 		release_region(wdt_stop,1);
diff --git a/drivers/watchdog/scx200_wdt.c b/drivers/watchdog/scx200_wdt.c
index d4fd0fa..d55882b 100644
--- a/drivers/watchdog/scx200_wdt.c
+++ b/drivers/watchdog/scx200_wdt.c
@@ -231,17 +231,17 @@ static int __init scx200_wdt_init(void)
 
 	sema_init(&open_semaphore, 1);
 
-	r = misc_register(&scx200_wdt_miscdev);
+	r = register_reboot_notifier(&scx200_wdt_notifier);
 	if (r) {
+		printk(KERN_ERR NAME ": unable to register reboot notifier");
 		release_region(scx200_cb_base + SCx200_WDT_OFFSET,
 				SCx200_WDT_SIZE);
 		return r;
 	}
 
-	r = register_reboot_notifier(&scx200_wdt_notifier);
+	r = misc_register(&scx200_wdt_miscdev);
 	if (r) {
-		printk(KERN_ERR NAME ": unable to register reboot notifier");
-		misc_deregister(&scx200_wdt_miscdev);
+		unregister_reboot_notifier(&scx200_wdt_notifier);
 		release_region(scx200_cb_base + SCx200_WDT_OFFSET,
 				SCx200_WDT_SIZE);
 		return r;
@@ -252,8 +252,8 @@ static int __init scx200_wdt_init(void)
 
 static void __exit scx200_wdt_cleanup(void)
 {
-	unregister_reboot_notifier(&scx200_wdt_notifier);
 	misc_deregister(&scx200_wdt_miscdev);
+	unregister_reboot_notifier(&scx200_wdt_notifier);
 	release_region(scx200_cb_base + SCx200_WDT_OFFSET,
 		       SCx200_WDT_SIZE);
 }
diff --git a/drivers/watchdog/txx9wdt.c b/drivers/watchdog/txx9wdt.c
new file mode 100644
index 0000000..328b3c7
--- /dev/null
+++ b/drivers/watchdog/txx9wdt.c
@@ -0,0 +1,276 @@
+/*
+ * txx9wdt: A Hardware Watchdog Driver for TXx9 SoCs
+ *
+ * Copyright (C) 2007 Atsushi Nemoto <anemo@mba.ocn.ne.jp>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/types.h>
+#include <linux/miscdevice.h>
+#include <linux/watchdog.h>
+#include <linux/fs.h>
+#include <linux/reboot.h>
+#include <linux/init.h>
+#include <linux/uaccess.h>
+#include <linux/platform_device.h>
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <asm/txx9tmr.h>
+
+#define TIMER_MARGIN	60		/* Default is 60 seconds */
+
+static int timeout = TIMER_MARGIN;	/* in seconds */
+module_param(timeout, int, 0);
+MODULE_PARM_DESC(timeout,
+	"Watchdog timeout in seconds. "
+	"(0<timeout<((2^" __MODULE_STRING(TXX9_TIMER_BITS) ")/(IMCLK/256)), "
+	"default=" __MODULE_STRING(TIMER_MARGIN) ")");
+
+static int nowayout = WATCHDOG_NOWAYOUT;
+module_param(nowayout, int, 0);
+MODULE_PARM_DESC(nowayout,
+	"Watchdog cannot be stopped once started "
+	"(default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+
+#define WD_TIMER_CCD	7	/* 1/256 */
+#define WD_TIMER_CLK	(clk_get_rate(txx9_imclk) / (2 << WD_TIMER_CCD))
+#define WD_MAX_TIMEOUT	((0xffffffff >> (32 - TXX9_TIMER_BITS)) / WD_TIMER_CLK)
+
+static unsigned long txx9wdt_alive;
+static int expect_close;
+static struct txx9_tmr_reg __iomem *txx9wdt_reg;
+static struct clk *txx9_imclk;
+
+static void txx9wdt_ping(void)
+{
+	__raw_writel(TXx9_TMWTMR_TWIE | TXx9_TMWTMR_TWC, &txx9wdt_reg->wtmr);
+}
+
+static void txx9wdt_start(void)
+{
+	__raw_writel(WD_TIMER_CLK * timeout, &txx9wdt_reg->cpra);
+	__raw_writel(WD_TIMER_CCD, &txx9wdt_reg->ccdr);
+	__raw_writel(0, &txx9wdt_reg->tisr);	/* clear pending interrupt */
+	__raw_writel(TXx9_TMTCR_TCE | TXx9_TMTCR_CCDE | TXx9_TMTCR_TMODE_WDOG,
+		     &txx9wdt_reg->tcr);
+	__raw_writel(TXx9_TMWTMR_TWIE | TXx9_TMWTMR_TWC, &txx9wdt_reg->wtmr);
+}
+
+static void txx9wdt_stop(void)
+{
+	__raw_writel(TXx9_TMWTMR_WDIS, &txx9wdt_reg->wtmr);
+	__raw_writel(__raw_readl(&txx9wdt_reg->tcr) & ~TXx9_TMTCR_TCE,
+		     &txx9wdt_reg->tcr);
+}
+
+static int txx9wdt_open(struct inode *inode, struct file *file)
+{
+	if (test_and_set_bit(0, &txx9wdt_alive))
+		return -EBUSY;
+
+	if (__raw_readl(&txx9wdt_reg->tcr) & TXx9_TMTCR_TCE) {
+		clear_bit(0, &txx9wdt_alive);
+		return -EBUSY;
+	}
+
+	if (nowayout)
+		__module_get(THIS_MODULE);
+
+	txx9wdt_start();
+	return nonseekable_open(inode, file);
+}
+
+static int txx9wdt_release(struct inode *inode, struct file *file)
+{
+	if (expect_close)
+		txx9wdt_stop();
+	else {
+		printk(KERN_CRIT "txx9wdt: "
+		       "Unexpected close, not stopping watchdog!\n");
+		txx9wdt_ping();
+	}
+	clear_bit(0, &txx9wdt_alive);
+	expect_close = 0;
+	return 0;
+}
+
+static ssize_t txx9wdt_write(struct file *file, const char __user *data,
+			     size_t len, loff_t *ppos)
+{
+	if (len) {
+		if (!nowayout) {
+			size_t i;
+
+			expect_close = 0;
+			for (i = 0; i != len; i++) {
+				char c;
+				if (get_user(c, data + i))
+					return -EFAULT;
+				if (c == 'V')
+					expect_close = 1;
+			}
+		}
+		txx9wdt_ping();
+	}
+	return len;
+}
+
+static int txx9wdt_ioctl(struct inode *inode, struct file *file,
+	unsigned int cmd, unsigned long arg)
+{
+	void __user *argp = (void __user *)arg;
+	int __user *p = argp;
+	int new_timeout;
+	static struct watchdog_info ident = {
+		.options =		WDIOF_SETTIMEOUT |
+					WDIOF_KEEPALIVEPING |
+					WDIOF_MAGICCLOSE,
+		.firmware_version =	0,
+		.identity =		"Hardware Watchdog for TXx9",
+	};
+
+	switch (cmd) {
+	default:
+		return -ENOTTY;
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(argp, &ident, sizeof(ident)) ? -EFAULT : 0;
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, p);
+	case WDIOC_KEEPALIVE:
+		txx9wdt_ping();
+		return 0;
+	case WDIOC_SETTIMEOUT:
+		if (get_user(new_timeout, p))
+			return -EFAULT;
+		if (new_timeout < 1 || new_timeout > WD_MAX_TIMEOUT)
+			return -EINVAL;
+		timeout = new_timeout;
+		txx9wdt_stop();
+		txx9wdt_start();
+		/* Fall */
+	case WDIOC_GETTIMEOUT:
+		return put_user(timeout, p);
+	}
+}
+
+static int txx9wdt_notify_sys(struct notifier_block *this, unsigned long code,
+	void *unused)
+{
+	if (code == SYS_DOWN || code == SYS_HALT)
+		txx9wdt_stop();
+	return NOTIFY_DONE;
+}
+
+static const struct file_operations txx9wdt_fops = {
+	.owner =	THIS_MODULE,
+	.llseek =	no_llseek,
+	.write =	txx9wdt_write,
+	.ioctl =	txx9wdt_ioctl,
+	.open =		txx9wdt_open,
+	.release =	txx9wdt_release,
+};
+
+static struct miscdevice txx9wdt_miscdev = {
+	.minor =	WATCHDOG_MINOR,
+	.name =		"watchdog",
+	.fops =		&txx9wdt_fops,
+};
+
+static struct notifier_block txx9wdt_notifier = {
+	.notifier_call = txx9wdt_notify_sys
+};
+
+static int __init txx9wdt_probe(struct platform_device *dev)
+{
+	struct resource *res;
+	int ret;
+
+	txx9_imclk = clk_get(NULL, "imbus_clk");
+	if (IS_ERR(txx9_imclk)) {
+		ret = PTR_ERR(txx9_imclk);
+		txx9_imclk = NULL;
+		goto exit;
+	}
+	ret = clk_enable(txx9_imclk);
+	if (ret) {
+		clk_put(txx9_imclk);
+		txx9_imclk = NULL;
+		goto exit;
+	}
+
+	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
+	if (!res)
+		goto exit_busy;
+	if (!devm_request_mem_region(&dev->dev,
+				     res->start, res->end - res->start + 1,
+				     "txx9wdt"))
+		goto exit_busy;
+	txx9wdt_reg = devm_ioremap(&dev->dev,
+				   res->start, res->end - res->start + 1);
+	if (!txx9wdt_reg)
+		goto exit_busy;
+
+	ret = register_reboot_notifier(&txx9wdt_notifier);
+	if (ret)
+		goto exit;
+
+	ret = misc_register(&txx9wdt_miscdev);
+	if (ret) {
+		unregister_reboot_notifier(&txx9wdt_notifier);
+		goto exit;
+	}
+
+	printk(KERN_INFO "Hardware Watchdog Timer for TXx9: "
+	       "timeout=%d sec (max %ld) (nowayout= %d)\n",
+	       timeout, WD_MAX_TIMEOUT, nowayout);
+
+	return 0;
+exit_busy:
+	ret = -EBUSY;
+exit:
+	if (txx9_imclk) {
+		clk_disable(txx9_imclk);
+		clk_put(txx9_imclk);
+	}
+	return ret;
+}
+
+static int __exit txx9wdt_remove(struct platform_device *dev)
+{
+	misc_deregister(&txx9wdt_miscdev);
+	unregister_reboot_notifier(&txx9wdt_notifier);
+	clk_disable(txx9_imclk);
+	clk_put(txx9_imclk);
+	return 0;
+}
+
+static struct platform_driver txx9wdt_driver = {
+	.remove = __exit_p(txx9wdt_remove),
+	.driver = {
+		.name = "txx9wdt",
+		.owner = THIS_MODULE,
+	},
+};
+
+static int __init watchdog_init(void)
+{
+	return platform_driver_probe(&txx9wdt_driver, txx9wdt_probe);
+}
+
+static void __exit watchdog_exit(void)
+{
+	platform_driver_unregister(&txx9wdt_driver);
+}
+
+module_init(watchdog_init);
+module_exit(watchdog_exit);
+
+MODULE_DESCRIPTION("TXx9 Watchdog Driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
diff --git a/drivers/watchdog/w83877f_wdt.c b/drivers/watchdog/w83877f_wdt.c
index bcc9d48..f510a3a 100644
--- a/drivers/watchdog/w83877f_wdt.c
+++ b/drivers/watchdog/w83877f_wdt.c
@@ -373,20 +373,20 @@ static int __init w83877f_wdt_init(void)
 		goto err_out_region1;
 	}
 
-	rc = misc_register(&wdt_miscdev);
+	rc = register_reboot_notifier(&wdt_notifier);
 	if (rc)
 	{
-		printk(KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
-			wdt_miscdev.minor, rc);
+		printk(KERN_ERR PFX "cannot register reboot notifier (err=%d)\n",
+			rc);
 		goto err_out_region2;
 	}
 
-	rc = register_reboot_notifier(&wdt_notifier);
+	rc = misc_register(&wdt_miscdev);
 	if (rc)
 	{
-		printk(KERN_ERR PFX "cannot register reboot notifier (err=%d)\n",
-			rc);
-		goto err_out_miscdev;
+		printk(KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
+			wdt_miscdev.minor, rc);
+		goto err_out_reboot;
 	}
 
 	printk(KERN_INFO PFX "WDT driver for W83877F initialised. timeout=%d sec (nowayout=%d)\n",
@@ -394,8 +394,8 @@ static int __init w83877f_wdt_init(void)
 
 	return 0;
 
-err_out_miscdev:
-	misc_deregister(&wdt_miscdev);
+err_out_reboot:
+	unregister_reboot_notifier(&wdt_notifier);
 err_out_region2:
 	release_region(WDT_PING,1);
 err_out_region1:
diff --git a/drivers/watchdog/w83977f_wdt.c b/drivers/watchdog/w83977f_wdt.c
index b475529..b209bcd 100644
--- a/drivers/watchdog/w83977f_wdt.c
+++ b/drivers/watchdog/w83977f_wdt.c
@@ -494,20 +494,20 @@ static int __init w83977f_wdt_init(void)
 		goto err_out;
 	}
 
-	rc = misc_register(&wdt_miscdev);
+	rc = register_reboot_notifier(&wdt_notifier);
 	if (rc)
 	{
-		printk(KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
-			wdt_miscdev.minor, rc);
+		printk(KERN_ERR PFX "cannot register reboot notifier (err=%d)\n",
+			rc);
 		goto err_out_region;
 	}
 
-	rc = register_reboot_notifier(&wdt_notifier);
+	rc = misc_register(&wdt_miscdev);
 	if (rc)
 	{
-		printk(KERN_ERR PFX "cannot register reboot notifier (err=%d)\n",
-			rc);
-		goto err_out_miscdev;
+		printk(KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
+			wdt_miscdev.minor, rc);
+		goto err_out_reboot;
 	}
 
 	printk(KERN_INFO PFX "initialized. timeout=%d sec (nowayout=%d testmode=%d)\n",
@@ -515,8 +515,8 @@ static int __init w83977f_wdt_init(void)
 
 	return 0;
 
-err_out_miscdev:
-	misc_deregister(&wdt_miscdev);
+err_out_reboot:
+	unregister_reboot_notifier(&wdt_notifier);
 err_out_region:
 	release_region(IO_INDEX_PORT,2);
 err_out:
diff --git a/drivers/watchdog/wdt.c b/drivers/watchdog/wdt.c
index 53d0bb4..756fb15 100644
--- a/drivers/watchdog/wdt.c
+++ b/drivers/watchdog/wdt.c
@@ -70,6 +70,8 @@ MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" _
 static int io=0x240;
 static int irq=11;
 
+static DEFINE_SPINLOCK(wdt_lock);
+
 module_param(io, int, 0);
 MODULE_PARM_DESC(io, "WDT io port (default=0x240)");
 module_param(irq, int, 0);
@@ -109,6 +111,8 @@ static void wdt_ctr_load(int ctr, int val)
 
 static int wdt_start(void)
 {
+	unsigned long flags;
+	spin_lock_irqsave(&wdt_lock, flags);
 	inb_p(WDT_DC);			/* Disable watchdog */
 	wdt_ctr_mode(0,3);		/* Program CTR0 for Mode 3: Square Wave Generator */
 	wdt_ctr_mode(1,2);		/* Program CTR1 for Mode 2: Rate Generator */
@@ -117,6 +121,7 @@ static int wdt_start(void)
 	wdt_ctr_load(1,wd_heartbeat);	/* Heartbeat */
 	wdt_ctr_load(2,65535);		/* Length of reset pulse */
 	outb_p(0, WDT_DC);		/* Enable watchdog */
+	spin_unlock_irqrestore(&wdt_lock, flags);
 	return 0;
 }
 
@@ -128,9 +133,12 @@ static int wdt_start(void)
 
 static int wdt_stop (void)
 {
+	unsigned long flags;
+	spin_lock_irqsave(&wdt_lock, flags);
 	/* Turn the card off */
 	inb_p(WDT_DC);			/* Disable watchdog */
 	wdt_ctr_load(2,0);		/* 0 length reset pulses now */
+	spin_unlock_irqrestore(&wdt_lock, flags);
 	return 0;
 }
 
@@ -143,11 +151,14 @@ static int wdt_stop (void)
 
 static int wdt_ping(void)
 {
+	unsigned long flags;
+	spin_lock_irqsave(&wdt_lock, flags);
 	/* Write a watchdog value */
 	inb_p(WDT_DC);			/* Disable watchdog */
 	wdt_ctr_mode(1,2);		/* Re-Program CTR1 for Mode 2: Rate Generator */
 	wdt_ctr_load(1,wd_heartbeat);	/* Heartbeat */
 	outb_p(0, WDT_DC);		/* Enable watchdog */
+	spin_unlock_irqrestore(&wdt_lock, flags);
 	return 0;
 }
 
@@ -182,7 +193,12 @@ static int wdt_set_heartbeat(int t)
 
 static int wdt_get_status(int *status)
 {
-	unsigned char new_status=inb_p(WDT_SR);
+	unsigned char new_status;
+	unsigned long flags;
+
+	spin_lock_irqsave(&wdt_lock, flags);
+	new_status = inb_p(WDT_SR);
+	spin_unlock_irqrestore(&wdt_lock, flags);
 
 	*status=0;
 	if (new_status & WDC_SR_ISOI0)
@@ -214,8 +230,12 @@ static int wdt_get_status(int *status)
 
 static int wdt_get_temperature(int *temperature)
 {
-	unsigned short c=inb_p(WDT_RT);
+	unsigned short c;
+	unsigned long flags;
 
+	spin_lock_irqsave(&wdt_lock, flags);
+	c = inb_p(WDT_RT);
+	spin_unlock_irqrestore(&wdt_lock, flags);
 	*temperature = (c * 11 / 15) + 7;
 	return 0;
 }
@@ -237,7 +257,10 @@ static irqreturn_t wdt_interrupt(int irq, void *dev_id)
 	 *	Read the status register see what is up and
 	 *	then printk it.
 	 */
-	unsigned char status=inb_p(WDT_SR);
+	unsigned char status;
+
+	spin_lock(&wdt_lock);
+	status = inb_p(WDT_SR);
 
 	printk(KERN_CRIT "WDT status %d\n", status);
 
@@ -265,6 +288,7 @@ static irqreturn_t wdt_interrupt(int irq, void *dev_id)
 		printk(KERN_CRIT "Reset in 5ms.\n");
 #endif
 	}
+	spin_unlock(&wdt_lock);
 	return IRQ_HANDLED;
 }
 
diff --git a/drivers/watchdog/wdt977.c b/drivers/watchdog/wdt977.c
index 9b7f6b6..fb4b876 100644
--- a/drivers/watchdog/wdt977.c
+++ b/drivers/watchdog/wdt977.c
@@ -470,20 +470,20 @@ static int __init wd977_init(void)
 		}
 	}
 
-	rc = misc_register(&wdt977_miscdev);
+	rc = register_reboot_notifier(&wdt977_notifier);
 	if (rc)
 	{
-		printk(KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
-			wdt977_miscdev.minor, rc);
+		printk(KERN_ERR PFX "cannot register reboot notifier (err=%d)\n",
+			rc);
 		goto err_out_region;
 	}
 
-	rc = register_reboot_notifier(&wdt977_notifier);
+	rc = misc_register(&wdt977_miscdev);
 	if (rc)
 	{
-		printk(KERN_ERR PFX "cannot register reboot notifier (err=%d)\n",
-			rc);
-		goto err_out_miscdev;
+		printk(KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
+			wdt977_miscdev.minor, rc);
+		goto err_out_reboot;
 	}
 
 	printk(KERN_INFO PFX "initialized. timeout=%d sec (nowayout=%d, testmode=%i)\n",
@@ -491,8 +491,8 @@ static int __init wd977_init(void)
 
 	return 0;
 
-err_out_miscdev:
-        misc_deregister(&wdt977_miscdev);
+err_out_reboot:
+	unregister_reboot_notifier(&wdt977_notifier);
 err_out_region:
 	if (!machine_is_netwinder())
 	        release_region(IO_INDEX_PORT,2);
