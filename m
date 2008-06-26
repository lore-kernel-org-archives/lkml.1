Return-Path: <linux-kernel-owner+w=401wt.eu-S1756838AbYFZJTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838AbYFZJTe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 05:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753445AbYFZJTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 05:19:24 -0400
Received: from xi.wantstofly.org ([83.160.184.112]:58481 "EHLO
	xi.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272AbYFZJTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 05:19:23 -0400
X-Greylist: delayed 1834 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Jun 2008 05:19:22 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=1148133259;
	d=wantstofly.org;
	h=date:from:to:cc:subject:message-id:mime-version:content-type:
	content-disposition:user-agent;
	b=sza+02qmA+OaUJyfdOfKh9vAUpo40fG0ghsn9Nx4CZUDjnu+xpLr68392d1cx
	ANUNWYgUD2dW4lfAt21aKvgxg==
Date: Thu, 26 Jun 2008 10:47:45 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-kernel@vger.kernel.org,
       Sylver Bruneau <sylver.bruneau@googlemail.com>,
       Nicolas Pitre <nico@cam.org>
Subject: [WATCHDOG] Orion: add hardware watchdog support
Message-ID: <20080626084745.GB10320@xi.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sylver Bruneau <sylver.bruneau@googlemail.com>

This patch allows the use of the hardware watchdog in the
Marvell Orion series of ARM SoCs.

Signed-off-by: Sylver Bruneau <sylver.bruneau@googlemail.com>
Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>

Index: linux-2.6.26-rc8/drivers/watchdog/Kconfig
===================================================================
--- linux-2.6.26-rc8.orig/drivers/watchdog/Kconfig
+++ linux-2.6.26-rc8/drivers/watchdog/Kconfig
@@ -217,6 +217,15 @@ config DAVINCI_WATCHDOG
 	  NOTE: once enabled, this timer cannot be disabled.
 	  Say N if you are unsure.
 
+config ORION5X_WATCHDOG
+	tristate "Orion5x watchdog"
+	depends on ARCH_ORION5X
+	help
+	  Say Y here if to include support for the watchdog timer
+	  in the Orion5x ARM SoCs.
+	  To compile this driver as a module, choose M here: the
+	  module will be called orion5x_wdt.
+
 # ARM26 Architecture
 
 # AVR32 Architecture
Index: linux-2.6.26-rc8/drivers/watchdog/Makefile
===================================================================
--- linux-2.6.26-rc8.orig/drivers/watchdog/Makefile
+++ linux-2.6.26-rc8/drivers/watchdog/Makefile
@@ -39,6 +39,7 @@ obj-$(CONFIG_EP93XX_WATCHDOG) += ep93xx_
 obj-$(CONFIG_PNX4008_WATCHDOG) += pnx4008_wdt.o
 obj-$(CONFIG_IOP_WATCHDOG) += iop_wdt.o
 obj-$(CONFIG_DAVINCI_WATCHDOG) += davinci_wdt.o
+obj-$(CONFIG_ORION5X_WATCHDOG) += orion5x_wdt.o
 
 # ARM26 Architecture
 
Index: linux-2.6.26-rc8/drivers/watchdog/orion5x_wdt.c
===================================================================
--- /dev/null
+++ linux-2.6.26-rc8/drivers/watchdog/orion5x_wdt.c
@@ -0,0 +1,232 @@
+/*
+ * drivers/watchdog/orion5x_wdt.c
+ *
+ * Watchdog driver for Orion5x processors
+ *
+ * Author: Sylver Bruneau <sylver.bruneau@googlemail.com>
+ *
+ * This file is licensed under  the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/fs.h>
+#include <linux/miscdevice.h>
+#include <linux/watchdog.h>
+#include <linux/init.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
+
+#include <asm/hardware.h>
+
+/*
+ * Watchdog timer block registers.
+ */
+#define TIMER_CTRL		(TIMER_VIRT_BASE + 0x0000)
+#define  WDT_EN			0x0010
+#define WDT_VAL			(TIMER_VIRT_BASE + 0x0024)
+
+#define WDT_MAX_DURATION	(0xffffffff / ORION5X_TCLK)
+#define WDT_IN_USE		0
+#define WDT_OK_TO_CLOSE		1
+
+static int nowayout = WATCHDOG_NOWAYOUT;
+static int heartbeat =  WDT_MAX_DURATION;	/* (seconds) */
+static unsigned long wdt_status;
+
+static void wdt_enable(void)
+{
+	u32 reg;
+
+	/* Set watchdog duration */
+	writel(ORION5X_TCLK * heartbeat, WDT_VAL);
+
+	/* Clear watchdog timer interrupt */
+	reg = readl(BRIDGE_CAUSE);
+	reg &= ~WDT_INT_REQ;
+	writel(reg, BRIDGE_CAUSE);
+
+	/* Enable watchdog timer */
+	reg = readl(TIMER_CTRL);
+	reg |= WDT_EN;
+	writel(reg, TIMER_CTRL);
+
+	/* Enable reset on watchdog */
+	reg = readl(CPU_RESET_MASK);
+	reg |= WDT_RESET;
+	writel(reg, CPU_RESET_MASK);
+}
+
+static void wdt_disable(void)
+{
+	u32 reg;
+
+	/* Disable reset on watchdog */
+	reg = readl(CPU_RESET_MASK);
+	reg &= ~WDT_RESET;
+	writel(reg, CPU_RESET_MASK);
+
+	/* Disable watchdog timer */
+	reg = readl(TIMER_CTRL);
+	reg &= ~WDT_EN;
+	writel(reg, TIMER_CTRL);
+}
+
+static int orion5x_wdt_open(struct inode *inode, struct file *file)
+{
+	if (test_and_set_bit(WDT_IN_USE, &wdt_status))
+		return -EBUSY;
+	clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
+	wdt_enable();
+	return nonseekable_open(inode, file);
+}
+
+static int orion5x_wdt_get_timeleft(int *time_left)
+{
+	*time_left = readl(WDT_VAL) / ORION5X_TCLK;
+	return 0;
+}
+
+static ssize_t orion5x_wdt_write(struct file *file, const char *data,
+					size_t len, loff_t *ppos)
+{
+	if (len) {
+		if (!nowayout) {
+			size_t i;
+
+			clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
+			for (i = 0; i != len; i++) {
+				char c;
+
+				if (get_user(c, data + i))
+					return -EFAULT;
+				if (c == 'V')
+					set_bit(WDT_OK_TO_CLOSE, &wdt_status);
+			}
+		}
+		wdt_enable();
+	}
+	return len;
+}
+
+static struct watchdog_info ident = {
+	.options	= WDIOF_MAGICCLOSE | WDIOF_SETTIMEOUT |
+			  WDIOF_KEEPALIVEPING,
+	.identity	= "Orion5x Watchdog",
+};
+
+
+static int orion5x_wdt_ioctl(struct inode *inode, struct file *file,
+				unsigned int cmd, unsigned long arg)
+{
+	int ret = -ENOTTY;
+	int time;
+
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		ret = copy_to_user((struct watchdog_info *)arg, &ident,
+				   sizeof(ident)) ? -EFAULT : 0;
+		break;
+
+	case WDIOC_GETSTATUS:
+		ret = put_user(0, (int *)arg);
+		break;
+
+	case WDIOC_SETTIMEOUT:
+		ret = get_user(time, (int *)arg);
+		if (ret)
+			break;
+
+		if (time <= 0 || time > WDT_MAX_DURATION) {
+			ret = -EINVAL;
+			break;
+		}
+		heartbeat = time;
+		wdt_enable();
+		/* Fall through */
+
+	case WDIOC_GETTIMEOUT:
+		ret = put_user(heartbeat, (int *)arg);
+		break;
+
+	case WDIOC_KEEPALIVE:
+		wdt_enable();
+		ret = 0;
+		break;
+
+	case WDIOC_GETTIMELEFT:
+		if (orion5x_wdt_get_timeleft(&time)) {
+			ret = -EINVAL;
+			break;
+		}
+		ret = put_user(time, (int *)arg);
+		break;
+	}
+	return ret;
+}
+
+static int orion5x_wdt_release(struct inode *inode, struct file *file)
+{
+	if (test_bit(WDT_OK_TO_CLOSE, &wdt_status))
+		wdt_disable();
+	else
+		printk(KERN_CRIT "WATCHDOG: Device closed unexpectedly - "
+					"timer will not stop\n");
+	clear_bit(WDT_IN_USE, &wdt_status);
+	clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
+
+	return 0;
+}
+
+
+static const struct file_operations orion5x_wdt_fops = {
+	.owner		= THIS_MODULE,
+	.llseek		= no_llseek,
+	.write		= orion5x_wdt_write,
+	.ioctl		= orion5x_wdt_ioctl,
+	.open		= orion5x_wdt_open,
+	.release	= orion5x_wdt_release,
+};
+
+static struct miscdevice orion5x_wdt_miscdev = {
+	.minor		= WATCHDOG_MINOR,
+	.name		= "watchdog",
+	.fops		= &orion5x_wdt_fops,
+};
+
+static int __init orion5x_wdt_init(void)
+{
+	int ret;
+
+	ret = misc_register(&orion5x_wdt_miscdev);
+	if (ret == 0)
+		printk("Orion5x Watchdog Timer: heartbeat %d sec\n",
+								heartbeat);
+
+	return ret;
+}
+
+static void __exit orion5x_wdt_exit(void)
+{
+	misc_deregister(&orion5x_wdt_miscdev);
+}
+
+module_init(orion5x_wdt_init);
+module_exit(orion5x_wdt_exit);
+
+MODULE_AUTHOR("Sylver Bruneau <sylver.bruneau@googlemail.com>");
+MODULE_DESCRIPTION("Orion5x Processor Watchdog");
+
+module_param(heartbeat, int, 0);
+MODULE_PARM_DESC(heartbeat, "Watchdog heartbeat in seconds (default is "
+					__MODULE_STRING(WDT_MAX_DURATION) ")");
+
+module_param(nowayout, int, 0);
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started");
+
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
Index: linux-2.6.26-rc8/include/asm-arm/arch-orion5x/orion5x.h
===================================================================
--- linux-2.6.26-rc8.orig/include/asm-arm/arch-orion5x/orion5x.h
+++ linux-2.6.26-rc8/include/asm-arm/arch-orion5x/orion5x.h
@@ -148,9 +148,11 @@
 #define CPU_CONF		ORION5X_BRIDGE_REG(0x100)
 #define CPU_CTRL		ORION5X_BRIDGE_REG(0x104)
 #define CPU_RESET_MASK		ORION5X_BRIDGE_REG(0x108)
+#define  WDT_RESET		0x0002
 #define CPU_SOFT_RESET		ORION5X_BRIDGE_REG(0x10c)
 #define POWER_MNG_CTRL_REG	ORION5X_BRIDGE_REG(0x11C)
 #define BRIDGE_CAUSE		ORION5X_BRIDGE_REG(0x110)
+#define  WDT_INT_REQ		0x0008
 #define BRIDGE_MASK		ORION5X_BRIDGE_REG(0x114)
 #define  BRIDGE_INT_TIMER0	0x0002
 #define  BRIDGE_INT_TIMER1	0x0004
