Return-Path: <linux-kernel-owner+w=401wt.eu-S1764377AbXJFQu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764377AbXJFQu0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 12:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758913AbXJFQuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 12:50:12 -0400
Received: from mi1.bluebottle.com ([206.188.25.14]:45127 "EHLO
	mi1.bluebottle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755344AbXJFQuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 12:50:09 -0400
X-Greylist: delayed 4228 seconds by postgrey-1.27 at vger.kernel.org; Sat, 06 Oct 2007 12:50:08 EDT
DomainKey-Signature: a=rsa-sha1; s=mail; d=bluebottle.com; c=nofws; q=dns;
	h=received:date:from:user-agent:mime-version:to:cc:subject:
	content-type:content-transfer-encoding:x-trusted-delivery;
	b=DZVeVSOFmvoiUADfuVM98zOqs/TWYEzwvZaxmMoIveqfhnrwIbuvcJaZ9gzRrVwi6
	lbUK+E11AHe6UXiSX7+thcsKOQEUXp/+DLjRFh463w/uN+rohkFg0jGFz1hybx0
Message-Id: <200710061539.l96FddWs002059@mi1.bluebottle.com>
Date: Sun, 07 Oct 2007 01:39:28 +1000
From: Gilles Gigan <gilles.gigan@bluebottle.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: wim@iguana.be
Subject: [PATCH] watchdog: add Nano 7240 driver
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Trusted-Delivery: <9675f2d22731ac84edf973e7287b3892>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

from: Gilles Gigan <gilles.gigan@bluebottle.com>

Adds watchdog driver for EPIC Nano 7240 boards from IEI

Signed-off-by: Gilles Gigan <gilles.gigan@bluebottle.com>
---

diff -uprN -X linux-2.6.23-rc9/Documentation/dontdiff linux-2.6.23-rc9/drivers/char/watchdog/Kconfig
linux-2.6.23-rc9-dirty/drivers/char/watchdog/Kconfig
--- linux-2.6.23-rc9/drivers/char/watchdog/Kconfig	2007-10-06 01:43:44.000000000 +1000
+++ linux-2.6.23-rc9-dirty/drivers/char/watchdog/Kconfig	2007-10-06 14:49:03.000000000 +1000
@@ -455,6 +455,19 @@ config SBC8360_WDT

   	  Most people will say N.

+config SBC7240_WDT
+	tristate "SBC Nano 7240 Watchdog Timer"
+	depends on X86_32
+	---help---
+	  This is the driver for the hardware watchdog found on the IEI
+	  single board computers EPIC Nano 7240 (and likely others). This
+	  watchdog simply watches your kernel to make sure it doesn't freeze,
+	  and if it does, it reboots your computer after a certain amount of
+	  time.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called sbc7240_wdt.
+
   config CPU5_WDT
   	tristate "SMA CPU5 Watchdog"
   	depends on X86
diff -uprN -X linux-2.6.23-rc9/Documentation/dontdiff
linux-2.6.23-rc9/drivers/char/watchdog/Makefile linux-2.6.23-rc9-dirty/drivers/char/watchdog/Makefile
--- linux-2.6.23-rc9/drivers/char/watchdog/Makefile	2007-10-06 01:43:44.000000000 +1000
+++ linux-2.6.23-rc9-dirty/drivers/char/watchdog/Makefile	2007-10-06 14:49:03.000000000 +1000
@@ -71,6 +71,7 @@ obj-$(CONFIG_SCx200_WDT) += scx200_wdt.o
   obj-$(CONFIG_PC87413_WDT) += pc87413_wdt.o
   obj-$(CONFIG_60XX_WDT) += sbc60xxwdt.o
   obj-$(CONFIG_SBC8360_WDT) += sbc8360.o
+obj-$(CONFIG_SBC7240_WDT) += sbc7240.o
   obj-$(CONFIG_CPU5_WDT) += cpu5wdt.o
   obj-$(CONFIG_SMSC37B787_WDT) += smsc37b787_wdt.o
   obj-$(CONFIG_W83627HF_WDT) += w83627hf_wdt.o
diff -uprN -X linux-2.6.23-rc9/Documentation/dontdiff
linux-2.6.23-rc9/drivers/char/watchdog/sbc7240_wdt.c
linux-2.6.23-rc9-dirty/drivers/char/watchdog/sbc7240_wdt.c
--- linux-2.6.23-rc9/drivers/char/watchdog/sbc7240_wdt.c	1970-01-01 10:00:00.000000000 +1000
+++ linux-2.6.23-rc9-dirty/drivers/char/watchdog/sbc7240_wdt.c	2007-10-06 16:54:52.000000000 +1000
@@ -0,0 +1,311 @@
+/*
+ *	NANO7240 SBC Watchdog device driver
+ *
+ *	Based on w83877f.c by Scott Jennings,
+ *
+ *	This program is free software; you can redistribute it and/or modify
+ *	it under the terms of the GNU General Public License version 2 as
+ *	published by the Free Software Foundation;
+ *
+ *	Software distributed under the License is distributed on an "AS IS"
+ *	basis, WITHOUT WARRANTY OF ANY KIND, either express or
+ *	implied. See the License for the specific language governing
+ *	rights and limitations under the License.
+ *
+ *	(c) Copyright 2007  Gilles GIGAN <gilles.gigan at jcu.edu.au>
+ *
+ *      10/01- 2007   [Initial revision]
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/types.h>
+#include <linux/jiffies.h>
+#include <linux/miscdevice.h>
+#include <linux/watchdog.h>
+#include <linux/fs.h>
+#include <linux/ioport.h>
+#include <linux/notifier.h>
+#include <linux/reboot.h>
+#include <linux/init.h>
+#include <asm/io.h>
+#include <asm/uaccess.h>
+#include <asm/system.h>
+#include <asm/atomic.h>
+
+#define PREFIX "sbc7240_wdt: "
+
+#define ENABLE_SBC7240_PORT 		0x443
+#define DISABLE_SBC7240_PORT 		0x043
+#define SET_TIMEOUT_SBC7240_PORT 	ENABLE_SBC7240_PORT
+#define WDT_MAGIC_CHAR			'V'
+
+#define WATCHDOG_TIMEOUT 		30	/* 30 sec default timeout */
+#define WATCHDOG_MAX_TIMEOUT 		255
+static int timeout = WATCHDOG_TIMEOUT;	/* in seconds */
+module_param(timeout, int, 0);
+MODULE_PARM_DESC(timeout, "Watchdog timeout in seconds. (1<=timeout<="
+		 __MODULE_STRING(WATCHDOG_MAX_TIMEOUT) ", default="
+		 __MODULE_STRING(WATCHDOG_TIMEOUT) ")");
+
+#ifdef CONFIG_WATCHDOG_NOWAYOUT
+#define NOWAYOUT			1
+#else
+#define NOWAYOUT			0
+#endif
+static int nowayout = NOWAYOUT;
+module_param(nowayout, int, 0);
+MODULE_PARM_DESC(nowayout, "Disable watchdog when closing device file");
+
+#define OPEN_STATUS_BIT			0
+#define ENABLED_STATUS_BIT		1
+static unsigned long wdt_status;
+
+/*
+ * Utility routines
+ */
+
+static void wdt_disable(void)
+{
+	/* disable the watchdog */
+	if (test_and_clear_bit(ENABLED_STATUS_BIT, &wdt_status)) {
+		inb_p(DISABLE_SBC7240_PORT);
+		printk(KERN_INFO PREFIX "Watchdog timer is now disabled.\n");
+	}
+}
+
+static void wdt_enable(void)
+{
+	/* enable the watchdog */
+	if (!test_and_set_bit(ENABLED_STATUS_BIT, &wdt_status)) {
+		inb_p(ENABLE_SBC7240_PORT);
+		printk(KERN_INFO PREFIX "Watchdog timer is now enabled.\n");
+	}
+}
+
+static int wdt_set_timeout(int t)
+{
+	if (t < 1 || t > WATCHDOG_MAX_TIMEOUT) {
+		printk(KERN_ERR PREFIX "timeout value must be 1<=x<=%d\n",
+		       WATCHDOG_MAX_TIMEOUT);
+		return -1;
+	}
+	/* set the timeout */
+	outb_p((unsigned)t, ENABLE_SBC7240_PORT);
+	printk(KERN_INFO PREFIX "timeout set to %d seconds\n", t);
+	return 0;
+}
+
+/* Whack the dog */
+static inline void wdt_keepalive(void)
+{
+	if (test_bit(ENABLED_STATUS_BIT, &wdt_status))
+		inb_p(ENABLE_SBC7240_PORT);
+}
+
+/*
+ * /dev/watchdog handling
+ */
+static ssize_t fop_write(struct file *file, const char __user * buf,
+			 size_t count, loff_t * ppos)
+{
+	size_t i;
+	char c;
+	int got_magic_char = 0;
+
+	/* is there a magic char ? */
+	for (i = 0; i != count; i++) {
+		if (get_user(c, buf + i))
+			return -EFAULT;
+		if (c == WDT_MAGIC_CHAR) {
+			got_magic_char = 1;
+			break;
+		}
+	}
+
+	if (got_magic_char)
+		wdt_disable();
+	else
+		wdt_keepalive();
+
+	return count;
+}
+
+static int fop_open(struct inode *inode, struct file *file)
+{
+	if (test_and_set_bit(OPEN_STATUS_BIT, &wdt_status))
+		return -EBUSY;
+
+	return nonseekable_open(inode, file);
+}
+
+static int fop_close(struct inode *inode, struct file *file)
+{
+	if (!nowayout)
+		wdt_disable();
+
+	clear_bit(OPEN_STATUS_BIT, &wdt_status);
+	return 0;
+}
+
+static int fop_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
+		     unsigned long arg)
+{
+	static struct watchdog_info ident = {
+		.options =
+		    WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT | WDIOF_MAGICCLOSE,
+		.firmware_version = 1,
+		.identity = "SBC7240",
+	};
+
+	if ((_IOC_DIR(cmd) & _IOC_READ) &&
+	    (!access_ok(VERIFY_WRITE, (void __user *)arg, _IOC_SIZE(cmd))))
+		return -EFAULT;
+	if ((_IOC_DIR(cmd) & _IOC_WRITE) &&
+	    (!access_ok(VERIFY_READ, (void __user *)arg, _IOC_SIZE(cmd))))
+		return -EFAULT;
+
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		return __copy_to_user((void __user *)arg,
+				      &ident, sizeof(ident)) ? -EFAULT : 0;
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		return __put_user(0, (int __user *)arg);
+	case WDIOC_KEEPALIVE:
+		wdt_keepalive();
+		return 0;
+	case WDIOC_SETOPTIONS:{
+			int retval = -EINVAL;
+
+			if (arg & WDIOS_DISABLECARD) {
+				wdt_disable();
+				retval = 0;
+			}
+
+			if (arg & WDIOS_ENABLECARD) {
+				wdt_enable();
+				retval = 0;
+			}
+
+			return retval;
+		}
+	case WDIOC_SETTIMEOUT:{
+			int new_timeout;
+
+			if (__get_user(new_timeout, (int __user *)arg))
+				return -EFAULT;
+
+			if (wdt_set_timeout(new_timeout))
+				return -EINVAL;
+
+			timeout = new_timeout;
+			return 0;
+		}
+	case WDIOC_GETTIMEOUT:
+		return __put_user(timeout, (int __user *)arg);
+	default:
+		return -ENOTTY;
+	}
+}
+
+static const struct file_operations wdt_fops = {
+	.owner = THIS_MODULE,
+	.llseek = no_llseek,
+	.write = fop_write,
+	.open = fop_open,
+	.release = fop_close,
+	.ioctl = fop_ioctl,
+};
+
+static struct miscdevice wdt_miscdev = {
+	.minor = WATCHDOG_MINOR,
+	.name = "watchdog",
+	.fops = &wdt_fops,
+};
+
+/*
+ *	Notifier for system down
+ */
+
+static int wdt_notify_sys(struct notifier_block *this, unsigned long code,
+			  void *unused)
+{
+	if (code == SYS_DOWN || code == SYS_HALT)
+		wdt_disable();
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block wdt_notifier = {
+	.notifier_call = wdt_notify_sys,
+};
+
+static void __exit sbc7240_wdt_unload(void)
+{
+	printk(KERN_INFO PREFIX "Removing watchdog\n");
+	misc_deregister(&wdt_miscdev);
+
+	unregister_reboot_notifier(&wdt_notifier);
+	release_region(ENABLE_SBC7240_PORT, 1);
+}
+
+static int __init sbc7240_wdt_init(void)
+{
+	int rc = -EBUSY;
+
+	if (!request_region(ENABLE_SBC7240_PORT, 1, "SBC7240 WDT")) {
+		printk(KERN_ERR PREFIX "I/O address 0x%04x already in use\n",
+		       ENABLE_SBC7240_PORT);
+		rc = -EIO;
+		goto err_out;
+	}
+
+	/* The IO port 0x043 used to disable the watchdog
+	 * is already claimed by the system timer, so we
+	 * cant request_region() it ...*/
+
+	rc = misc_register(&wdt_miscdev);
+	if (rc) {
+		printk(KERN_ERR PREFIX
+		       "cannot register miscdev on minor=%d (err=%d)\n",
+		       wdt_miscdev.minor, rc);
+		goto err_out_region1;
+	}
+
+	rc = register_reboot_notifier(&wdt_notifier);
+	if (rc) {
+		printk(KERN_ERR PREFIX
+		       "cannot register reboot notifier (err=%d)\n", rc);
+		goto err_out_miscdev;
+	}
+
+	if (timeout < 1 || timeout > WATCHDOG_MAX_TIMEOUT) {
+		timeout = WATCHDOG_TIMEOUT;
+		printk(KERN_INFO PREFIX
+		       "timeout value must be 1<=x<=%d, using %d\n",
+		       WATCHDOG_MAX_TIMEOUT, timeout);
+	}
+	wdt_set_timeout(timeout);
+
+	printk(KERN_INFO PREFIX
+	       "Watchdog driver for SBC7240 initialised (nowayout=%d)\n",
+	       nowayout);
+
+	return 0;
+
+      err_out_miscdev:
+	misc_deregister(&wdt_miscdev);
+      err_out_region1:
+	release_region(ENABLE_SBC7240_PORT, 1);
+      err_out:
+	return rc;
+}
+
+module_init(sbc7240_wdt_init);
+module_exit(sbc7240_wdt_unload);
+
+MODULE_AUTHOR("Gilles Gigan");
+MODULE_DESCRIPTION
+    ("Watchdog device driver for single board computer EPIC Nano 7240 from iEi");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);

----------------------------------------------------------------------
Free pop3 email with a spam filter.
http://www.bluebottle.com/tag/5

