Return-Path: <linux-kernel-owner+w=401wt.eu-S1755729AbXJaGbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755729AbXJaGbz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 02:31:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753245AbXJaGbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 02:31:48 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:58006 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080AbXJaGbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 02:31:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=MCL8whe+d+xKvjoG5DmrJZR2VIhJQZyP5RzO66vXdDzFak7T1AdiHiyNHz7Uuhhj9CbBvzre9khsHFMrt7+7d018Ma5G3gDj6FFkN1CL67MQ6lJ78hxql/+ZUjF8OEKvk3F/+kreWNc21T5sgAKm6GHrcXwH8DRItI2d8XjLoeo=
Date: Wed, 31 Oct 2007 16:31:42 +1000
From: Gilles Gigan <gilles.gigan@gmail.com>
To: wim@iguana.be, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] watchdog: add Nano 7240 driver
Message-Id: <20071031163142.ca4d855f.gilles.gigan@gmail.com>
In-Reply-To: <20071023192948.1fe5dd8d.akpm@linux-foundation.org>
References: <20071024121159.03d209ec.gilles.gigan@gmail.com>
	<20071023192948.1fe5dd8d.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.5 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Wim,
I made the changes you requested.
Cheers,
Gilles

From: Gilles Gigan<gilles.gigan@gmail.com>

Adds support for the built-in watchdog on EPIC Nano 7240 boards from IEI.

Tested on Nano-7240RS.

Hardware documentation of the platform (including watchdog) can be found
on the IEI website: http://www.ieiworld.com

Signed-off-by: Gilles Gigan <gilles.gigan@gmail.com>

---

 drivers/watchdog/Kconfig       |   13 ++
 drivers/watchdog/Makefile      |    1 
 drivers/watchdog/sbc7240_wdt.c |  307 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 321 insertions(+), 0 deletions(-)

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 2792bc1..c9d5ada 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -456,6 +456,19 @@ config SBC8360_WDT
 
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
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index 7d9e573..d57bfd0 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -71,6 +71,7 @@ obj-$(CONFIG_SCx200_WDT) += scx200_wdt.o
 obj-$(CONFIG_PC87413_WDT) += pc87413_wdt.o
 obj-$(CONFIG_60XX_WDT) += sbc60xxwdt.o
 obj-$(CONFIG_SBC8360_WDT) += sbc8360.o
+obj-$(CONFIG_SBC7240_WDT) += sbc7240_wdt.o
 obj-$(CONFIG_CPU5_WDT) += cpu5wdt.o
 obj-$(CONFIG_SMSC37B787_WDT) += smsc37b787_wdt.o
 obj-$(CONFIG_W83627HF_WDT) += w83627hf_wdt.o
diff --git a/drivers/watchdog/sbc7240_wdt.c b/drivers/watchdog/sbc7240_wdt.c
new file mode 100644
index 0000000..63be21b
--- /dev/null
+++ b/drivers/watchdog/sbc7240_wdt.c
@@ -0,0 +1,307 @@
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
+ *	(c) Copyright 2007  Gilles GIGAN <gilles.gigan@jcu.edu.au>
+ *
+ */
+
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/ioport.h>
+#include <linux/jiffies.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/miscdevice.h>
+#include <linux/notifier.h>
+#include <linux/reboot.h>
+#include <linux/types.h>
+#include <linux/watchdog.h>
+#include <asm/atomic.h>
+#include <asm/io.h>
+#include <asm/system.h>
+#include <asm/uaccess.h>
+
+#define SBC7240_PREFIX "sbc7240_wdt: "
+
+#define SBC7240_ENABLE_PORT		0x443
+#define SBC7240_DISABLE_PORT		0x043
+#define SBC7240_SET_TIMEOUT_PORT	SBC7240_ENABLE_PORT
+#define SBC7240_MAGIC_CHAR		'V'
+
+#define SBC7240_TIMEOUT		30
+#define SBC7240_MAX_TIMEOUT		255
+static int timeout = SBC7240_TIMEOUT;	/* in seconds */
+module_param(timeout, int, 0);
+MODULE_PARM_DESC(timeout, "Watchdog timeout in seconds. (1<=timeout<="
+		 __MODULE_STRING(SBC7240_MAX_TIMEOUT) ", default="
+		 __MODULE_STRING(SBC7240_TIMEOUT) ")");
+
+static int nowayout = WATCHDOG_NOWAYOUT;
+module_param(nowayout, int, 0);
+MODULE_PARM_DESC(nowayout, "Disable watchdog when closing device file");
+
+#define SBC7240_OPEN_STATUS_BIT		0
+#define SBC7240_ENABLED_STATUS_BIT	1
+#define SBC7240_EXPECT_CLOSE_STATUS_BIT	2
+static unsigned long wdt_status;
+
+/*
+ * Utility routines
+ */
+
+static void wdt_disable(void)
+{
+	/* disable the watchdog */
+	if (test_and_clear_bit(SBC7240_ENABLED_STATUS_BIT, &wdt_status)) {
+		inb_p(SBC7240_DISABLE_PORT);
+		printk(KERN_INFO SBC7240_PREFIX
+		       "Watchdog timer is now disabled.\n");
+	}
+}
+
+static void wdt_enable(void)
+{
+	/* enable the watchdog */
+	if (!test_and_set_bit(SBC7240_ENABLED_STATUS_BIT, &wdt_status)) {
+		inb_p(SBC7240_ENABLE_PORT);
+		printk(KERN_INFO SBC7240_PREFIX
+		       "Watchdog timer is now enabled.\n");
+	}
+}
+
+static int wdt_set_timeout(int t)
+{
+	if (t < 1 || t > SBC7240_MAX_TIMEOUT) {
+		printk(KERN_ERR SBC7240_PREFIX
+		       "timeout value must be 1<=x<=%d\n",
+		       SBC7240_MAX_TIMEOUT);
+		return -1;
+	}
+	/* set the timeout */
+	outb_p((unsigned)t, SBC7240_SET_TIMEOUT_PORT);
+	printk(KERN_INFO SBC7240_PREFIX "timeout set to %d seconds\n", t);
+	return 0;
+}
+
+/* Whack the dog */
+static inline void wdt_keepalive(void)
+{
+	if (test_bit(SBC7240_ENABLED_STATUS_BIT, &wdt_status))
+		inb_p(SBC7240_ENABLE_PORT);
+}
+
+/*
+ * /dev/watchdog handling
+ */
+static ssize_t fop_write(struct file *file, const char __user *buf,
+			 size_t count, loff_t *ppos)
+{
+	size_t i;
+	char c;
+
+	if (!nowayout) {
+		/* is there a magic char ? */
+		for (i = 0; i != count; i++) {
+			if (get_user(c, buf + i))
+				return -EFAULT;
+			if (c == SBC7240_MAGIC_CHAR) {
+				set_bit(SBC7240_EXPECT_CLOSE_STATUS_BIT,
+					&wdt_status);
+				break;
+			}
+		}
+	}
+
+	wdt_keepalive();
+
+	return count;
+}
+
+static int fop_open(struct inode *inode, struct file *file)
+{
+	if (test_and_set_bit(SBC7240_OPEN_STATUS_BIT, &wdt_status))
+		return -EBUSY;
+
+	return nonseekable_open(inode, file);
+}
+
+static int fop_close(struct inode *inode, struct file *file)
+{
+	if (test_and_clear_bit(SBC7240_EXPECT_CLOSE_STATUS_BIT, &wdt_status)
+	    || !nowayout)
+		wdt_disable();
+
+	clear_bit(SBC7240_OPEN_STATUS_BIT, &wdt_status);
+	return 0;
+}
+
+static struct watchdog_info ident = {
+	.options = WDIOF_KEEPALIVEPING|WDIOF_SETTIMEOUT|
+		   WDIOF_MAGICCLOSE,
+	.firmware_version = 1,
+	.identity = "SBC7240",
+};
+
+
+static int fop_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
+		     unsigned long arg)
+{
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		return copy_to_user
+			((void __user *)arg, &ident, sizeof(ident))
+			 ? -EFAULT : 0;
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, (int __user *)arg);
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
+			if (get_user(new_timeout, (int __user *)arg))
+				return -EFAULT;
+
+			if (wdt_set_timeout(new_timeout))
+				return -EINVAL;
+
+			timeout = new_timeout;
+			return 0;
+		}
+	case WDIOC_GETTIMEOUT:
+		return put_user(timeout, (int __user *)arg);
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
+	printk(KERN_INFO SBC7240_PREFIX "Removing watchdog\n");
+	misc_deregister(&wdt_miscdev);
+
+	unregister_reboot_notifier(&wdt_notifier);
+	release_region(SBC7240_ENABLE_PORT, 1);
+}
+
+static int __init sbc7240_wdt_init(void)
+{
+	int rc = -EBUSY;
+
+	if (!request_region(SBC7240_ENABLE_PORT, 1, "SBC7240 WDT")) {
+		printk(KERN_ERR SBC7240_PREFIX
+		       "I/O address 0x%04x already in use\n",
+		       SBC7240_ENABLE_PORT);
+		rc = -EIO;
+		goto err_out;
+	}
+
+	/* The IO port 0x043 used to disable the watchdog
+	 * is already claimed by the system timer, so we
+	 * cant request_region() it ...*/
+
+	rc = register_reboot_notifier(&wdt_notifier);
+	if (rc) {
+		printk(KERN_ERR SBC7240_PREFIX
+		       "cannot register reboot notifier (err=%d)\n", rc);
+		goto err_out_miscdev;
+	}
+
+	if (timeout < 1 || timeout > SBC7240_MAX_TIMEOUT) {
+		timeout = SBC7240_TIMEOUT;
+		printk(KERN_INFO SBC7240_PREFIX
+		       "timeout value must be 1<=x<=%d, using %d\n",
+		       SBC7240_MAX_TIMEOUT, timeout);
+	}
+	wdt_set_timeout(timeout);
+	wdt_disable();
+
+	rc = misc_register(&wdt_miscdev);
+	if (rc) {
+		printk(KERN_ERR SBC7240_PREFIX
+		       "cannot register miscdev on minor=%d (err=%d)\n",
+		       wdt_miscdev.minor, rc);
+		goto err_out_region;
+	}
+
+	printk(KERN_INFO SBC7240_PREFIX
+	       "Watchdog driver for SBC7240 initialised (nowayout=%d)\n",
+	       nowayout);
+
+	return 0;
+
+err_out_miscdev:
+	misc_deregister(&wdt_miscdev);
+err_out_region:
+	release_region(SBC7240_ENABLE_PORT, 1);
+err_out:
+	return rc;
+}
+
+module_init(sbc7240_wdt_init);
+module_exit(sbc7240_wdt_unload);
+
+MODULE_AUTHOR("Gilles Gigan");
+MODULE_DESCRIPTION("Watchdog device driver for single board"
+		   " computers EPIC Nano 7240 from iEi");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
+
