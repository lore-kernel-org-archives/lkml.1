Return-Path: <linux-kernel-owner+w=401wt.eu-S1756518AbYB0PS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756518AbYB0PS5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 10:18:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754167AbYB0PSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 10:18:47 -0500
Received: from 73-236-dsl.kielnet.net ([89.27.236.73]:39231 "EHLO
	einstein.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755992AbYB0PSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 10:18:44 -0500
X-Greylist: delayed 1367 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Feb 2008 10:18:43 EST
Message-ID: <47C579FA.7060403@aol.com>
Date: Wed, 27 Feb 2008 15:55:54 +0100
From: Oliver Schuster <olivers137@aol.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20080213)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, wim@iguana.be
Subject: [PATCH] add watchdog driver IT8716 IT8726 IT8712J/K
Content-Type: multipart/mixed;
 boundary="------------050108010201080901070807"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050108010201080901070807
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hi,
this patch add a hardware watchdog device driver. It supports the
16 bit watchdog timer on superio chip it8712f-j, it 8712f-k, it8716f
and it8726f. Today it was tested under vanilla 2.6.24.3, vanilla
2.6.24.2 and Mandriva with 2.6.24.2 and 2.6.24 kernel.

Regards,
Oliver


--------------050108010201080901070807
Content-Type: text/x-patch;
 name="2.6.24.3-it87_wdt.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="2.6.24.3-it87_wdt.patch"

Add it87xx watchdog driver
IT8716F IT8726F IT8712F-J IT8712F-K

Signed-off-by: Oliver Schuster <olivers137@aol.com>

===

diff -urP linux-2.6.24.3/drivers/watchdog/it87_wdt.c linux-2.6.24.3/drivers/watchdog/it87_wdt.c
--- linux-2.6.24.3/drivers/watchdog/it87_wdt.c	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.24.3/drivers/watchdog/it87_wdt.c	2008-02-27 14:57:26.581535025 +0100
@@ -0,0 +1,619 @@
+/*
+ *	Watchdog Timer Driver
+ *	   for ITE IT87xx Environment Control - Low Pin Count Input / Output
+ *
+ *	(c) Copyright 2007  Oliver Schuster <olivers137@aol.com>
+ *
+ *	Based on softdog.c	by Alan Cox,
+ *		 83977f_wdt.c	by Jose Goncalves,
+ *		 it87.c		by Chris Gauthron, Jean Delvare
+ *
+ *	Datasheets: Publicly available at the ITE website
+ *		    http://www.ite.com.tw/
+ *
+ *	Support of watchdog timer, which are available on
+ *	IT8712F (J,K version), IT8716F and IT8726F
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License
+ *	as published by the Free Software Foundation; either version
+ *	2 of the License, or (at your option) any later version.
+ *
+ *	This program is distributed in the hope that it will be useful,
+ *	but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *	GNU General Public License for more details.
+ *
+ *	You should have received a copy of the GNU General Public License
+ *	along with this program; if not, write to the Free Software
+ *	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/fs.h>
+#include <linux/miscdevice.h>
+#include <linux/init.h>
+#include <linux/ioport.h>
+#include <linux/watchdog.h>
+#include <linux/notifier.h>
+#include <linux/reboot.h>
+
+#include <asm/io.h>
+#include <asm/system.h>
+#include <asm/uaccess.h>
+
+#define WATCHDOG_VERSION	"1.00"
+#define WATCHDOG_NAME		"IT87 WDT"
+#define PFX			WATCHDOG_NAME ": "
+#define DRIVER_VERSION		WATCHDOG_NAME " driver, v" WATCHDOG_VERSION "\n"
+#define WD_MAGIC		42
+#define DEFAULT_EXCLUSIV	1	/* only one programm can open device */
+#define DEFAULT_TIMEOUT 	60	/* default timeout in seconds */
+#define DEFAULT_TESTMODE	0
+#define DEFAULT_NOWAYOUT	WATCHDOG_NOWAYOUT
+
+/* IO Ports */
+#define REG		0x2e
+#define VAL		0x2f
+
+/* Logical device Numbers LDN */
+#define GPIO		0x07
+#define GAMEPORT	0x09
+
+/* Configuration Registers and Functions */
+#define LDNREG		0x07
+#define CHIPID		0x20
+#define CHIPREV 	0x22
+#define ACTREG		0x30
+#define BASEREG 	0x60
+
+/* ChipId numbers */
+#define NO_DEV_ID	0xffff
+#define IT8705F_ID	0x8705
+#define IT8712F_ID	0x8712
+#define IT8716F_ID	0x8716
+#define IT8718F_ID	0x8718
+#define IT8726F_ID	0x8726	/* the datasheet suggest wrongly 0x8716 */
+
+/* GPIO Configuration Registers LDN=0x07 */
+#define WDTCTRL 	0x71
+#define WDTCFG		0x72
+#define WDTVALLSB	0x73
+#define WDTVALMSB	0x74
+
+/* GPIO Bits WDTCTRL */
+#define WDT_CIRINT	0x80
+#define WDT_MOUSEINT	0x40
+#define WDT_KYBINT	0x20
+#define WDT_GAMEPORT	0x10 /* not it8718f */
+#define WDT_FORCE	0x02
+#define WDT_ZERO	0x01
+
+/* GPIO Bits WDTCFG */
+#define WDT_TOV1	0x80
+#define WDT_KRST	0x40
+#define WDT_TOVE	0x20
+#define WDT_PWROK	0x10
+#define WDT_INT_MASK	0x0f
+
+/* wdt_status */
+#define WDTS_TIMER_RUN	0
+#define WDTS_DEV_OPEN	1
+#define WDTS_KEEPALIVE	2
+#define WDTS_LOCKED	3
+
+static	unsigned int gameport_base, gpact;
+static	unsigned long wdt_status;
+static	unsigned char expect_close;
+static	DEFINE_SPINLOCK(spinlock);
+
+static	int exclusiv = DEFAULT_EXCLUSIV;
+static	int timeout  = DEFAULT_TIMEOUT;
+static	int testmode = DEFAULT_TESTMODE;
+static	int nowayout = DEFAULT_NOWAYOUT;
+
+module_param(exclusiv, int, 0);
+MODULE_PARM_DESC(exclusiv, "Watchdog exclusiv device open, default="
+		__MODULE_STRING(DEFAULT_EXCLUSIV));
+
+module_param(timeout, int, 0);
+MODULE_PARM_DESC(timeout, "Watchdog timeout in seconds, default="
+		__MODULE_STRING(DEFAULT_TIMEOUT));
+
+module_param(testmode, int, 0);
+MODULE_PARM_DESC(testmode, "Watchdog testmode (1 = no reboot), default="
+		__MODULE_STRING(DEFAULT_TESTMODE));
+
+module_param(nowayout, int, 0);
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started, default="
+		__MODULE_STRING(WATCHDOG_NOWAYOUT));
+
+/*
+ *  The Superio Chip
+ */
+
+static inline void superio_enter(void)
+{
+	outb(0x87, REG);
+	outb(0x01, REG);
+	outb(0x55, REG);
+	outb(0x55, REG);
+}
+
+static inline void superio_exit(void)
+{
+	outb(0x02, REG);
+	outb(0x02, VAL);
+}
+
+static inline void superio_select(int ldn)
+{
+	outb(LDNREG, REG);
+	outb(ldn, VAL);
+}
+
+static inline int superio_inb(int reg)
+{
+	outb(reg, REG);
+	return inb(VAL);
+}
+
+static inline void superio_outb(int val, int reg)
+{
+       outb(reg, REG);
+       outb(val, VAL);
+}
+
+static inline int superio_inw(int reg)
+{
+	int val;
+	outb(reg++, REG);
+	val = inb(VAL) << 8;
+	outb(reg, REG);
+	val |= inb(VAL);
+	return val;
+}
+
+static inline void superio_outw(int val, int reg)
+{
+       outb(reg++, REG);
+       outb(val, VAL);
+       outb(reg, REG);
+       outb(val >> 8, VAL);
+}
+
+/*
+ *  watchdog timer handling
+ */
+
+static void wdt_keepalive(void)
+{
+	inb(gameport_base);
+	set_bit(WDTS_KEEPALIVE, &wdt_status);
+}
+
+static void wdt_start(void)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&spinlock, flags);
+	superio_enter();
+
+	superio_select(GPIO);
+	superio_outb(WDT_GAMEPORT, WDTCTRL);
+	if (!testmode)
+		superio_outb(WDT_TOV1 | WDT_KRST | WDT_PWROK, WDTCFG);
+	else
+		superio_outb(WDT_TOV1, WDTCFG);
+	superio_outb(timeout>>8, WDTVALMSB);
+	superio_outb(timeout, WDTVALLSB);
+
+	superio_exit();
+	spin_unlock_irqrestore(&spinlock, flags);
+}
+
+static void wdt_stop(void)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&spinlock, flags);
+	superio_enter();
+
+	superio_select(GPIO);
+	superio_outb(0x00, WDTCTRL);
+	superio_outb(WDT_TOV1, WDTCFG);
+	superio_outb(0x00, WDTVALMSB);
+	superio_outb(0x00, WDTVALLSB);
+
+	superio_exit();
+	spin_unlock_irqrestore(&spinlock, flags);
+}
+
+static int wdt_set_timeout(int t)
+{
+	unsigned long flags;
+
+	if (t < 1 || t > 65535)
+		return -EINVAL;
+
+	timeout = t;
+
+	if (wdt_status & BIT_MASK(WDTS_TIMER_RUN)) {
+		spin_lock_irqsave(&spinlock, flags);
+		superio_enter();
+
+		superio_select(GPIO);
+		superio_outb(t>>8, WDTVALMSB);
+		superio_outb(t, WDTVALLSB);
+
+		superio_exit();
+		spin_unlock_irqrestore(&spinlock, flags);
+	}
+	return 0;
+}
+
+/*
+ * The status bit does not allow to distinguish between a regular
+ * system reset and a watchdog forced reset. But, in testmode it
+ * is useful, so it is supported through WDIOC_GETSTATUS
+ */
+
+static int wdt_get_status(int *status)
+{
+	int new_status = 0;
+	unsigned long flags;
+
+	if (testmode) {
+		spin_lock_irqsave(&spinlock, flags);
+		superio_enter();
+
+		superio_select(GPIO);
+		new_status = superio_inb(WDTCTRL);
+		superio_outb(new_status & 0xfe, WDTCTRL);
+		new_status &= 0x01;
+
+		superio_exit();
+		spin_unlock_irqrestore(&spinlock, flags);
+	}
+	*status = 0;
+	if (new_status)
+		*status |= WDIOF_CARDRESET;
+	if (wdt_status & BIT_MASK(WDTS_KEEPALIVE))
+		*status |= WDIOF_KEEPALIVEPING;
+	clear_bit(WDTS_KEEPALIVE, &wdt_status);
+	return 0;
+}
+
+/*
+ *	/dev/watchdog handling
+ */
+
+static int wdt_open(struct inode *inode, struct file *file)
+{
+	if (exclusiv && test_and_set_bit(WDTS_DEV_OPEN, &wdt_status))
+		return -EBUSY;
+	if (!test_and_set_bit(WDTS_TIMER_RUN, &wdt_status)) {
+		if (nowayout && !test_and_set_bit(WDTS_LOCKED, &wdt_status))
+			__module_get(THIS_MODULE);
+		wdt_start();
+	} else {
+		wdt_keepalive();
+	}
+	return nonseekable_open(inode, file);
+}
+
+static int wdt_release(struct inode *inode, struct file *file)
+{
+	if (wdt_status & BIT_MASK(WDTS_TIMER_RUN)) {
+		if (expect_close == WD_MAGIC) {
+			wdt_stop();
+			clear_bit(WDTS_TIMER_RUN, &wdt_status);
+		} else {
+			wdt_keepalive();
+			printk(KERN_CRIT PFX
+			       "unexpected close, not stopping watchdog!\n");
+		}
+	}
+	expect_close = 0;
+	clear_bit(WDTS_DEV_OPEN, &wdt_status);
+	return 0;
+}
+
+/*
+ *      wdt_write:
+ *      @file: file handle to the watchdog
+ *      @buf: buffer to write (unused as data does not matter here)
+ *      @count: count of bytes
+ *      @ppos: pointer to the position to write. No seeks allowed
+ *
+ *      A write to a watchdog device is defined as a keepalive signal. Any
+ *      write of data will do, as we we don't define content meaning.
+ */
+
+static ssize_t wdt_write(struct file *file, const char __user *buf,
+			    size_t count, loff_t *ppos)
+{
+	if (count) {
+		if (!nowayout) {
+			size_t ofs;
+
+	/* note: just in case someone wrote the magic character long ago */
+			expect_close = 0;
+			for (ofs = 0; ofs != count; ofs++) {
+				char c;
+				if (get_user(c, buf + ofs))
+					return -EFAULT;
+				if (c == 'V')
+					expect_close = WD_MAGIC;
+			}
+		}
+		wdt_keepalive();
+	}
+	return count;
+}
+
+/*
+ *      wdt_ioctl:
+ *      @inode: inode of the device
+ *      @file: file handle to the device
+ *      @cmd: watchdog command
+ *      @arg: argument pointer
+ *
+ *      The watchdog API defines a common set of functions for all watchdogs
+ *      according to their available features.
+ */
+
+static struct watchdog_info ident = {
+	.options = WDIOF_SETTIMEOUT | WDIOF_MAGICCLOSE | WDIOF_KEEPALIVEPING,
+	.firmware_version =	1,
+	.identity = WATCHDOG_NAME,
+};
+
+static int wdt_ioctl(struct inode *inode, struct file *file,
+	unsigned int cmd, unsigned long arg)
+{
+	int rc = 0, status, new_options, new_timeout;
+	union {
+		struct watchdog_info __user *ident;
+		int __user *i;
+	} uarg;
+
+	uarg.i = (int __user *)arg;
+
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(uarg.ident,
+				    &ident, sizeof(ident)) ? -EFAULT : 0;
+
+	case WDIOC_GETSTATUS:
+		wdt_get_status(&status);
+		return put_user(status, uarg.i);
+
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, uarg.i);
+
+	case WDIOC_KEEPALIVE:
+		wdt_keepalive();
+		return 0;
+
+	case WDIOC_SETOPTIONS:
+		if (get_user(new_options, uarg.i))
+			return -EFAULT;
+
+		switch (new_options) {
+		case WDIOS_DISABLECARD:
+			if (wdt_status & BIT_MASK(WDTS_TIMER_RUN))
+				wdt_stop();
+			clear_bit(WDTS_TIMER_RUN, &wdt_status);
+			return 0;
+
+		case WDIOS_ENABLECARD:
+			if (!test_and_set_bit(WDTS_TIMER_RUN, &wdt_status))
+				wdt_start();
+			return 0;
+
+		default:
+			return -EFAULT;
+		}
+
+	case WDIOC_SETTIMEOUT:
+		if (get_user(new_timeout, uarg.i))
+			return -EFAULT;
+		rc = wdt_set_timeout(new_timeout);
+	case WDIOC_GETTIMEOUT:
+		if (put_user(timeout, uarg.i))
+			return -EFAULT;
+		return rc;
+
+	default:
+		return -ENOTTY;
+	}
+}
+
+static int wdt_notify_sys(struct notifier_block *this, unsigned long code,
+	void *unused)
+{
+	if (code == SYS_DOWN || code == SYS_HALT)
+		wdt_stop();
+	return NOTIFY_DONE;
+}
+
+static const struct file_operations wdt_fops = {
+	.owner		= THIS_MODULE,
+	.llseek		= no_llseek,
+	.write		= wdt_write,
+	.ioctl		= wdt_ioctl,
+	.open		= wdt_open,
+	.release	= wdt_release,
+};
+
+static struct miscdevice wdt_miscdev = {
+	.minor		= WATCHDOG_MINOR,
+	.name		= "watchdog",
+	.fops		= &wdt_fops,
+};
+
+static struct notifier_block wdt_notifier = {
+	.notifier_call = wdt_notify_sys,
+};
+
+static int __init it87_wdt_init(void)
+{
+	int rc;
+	u16 chip_type;
+	u8  chip_rev, printk_message = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&spinlock, flags);
+	superio_enter();
+
+	chip_type = superio_inw(CHIPID);
+	chip_rev  = superio_inb(CHIPREV) & 0x0f;
+	switch (chip_type) {
+	case IT8716F_ID:
+		break;
+	case IT8712F_ID:
+		if (chip_rev > 7)
+			break;
+	case IT8705F_ID:
+	case IT8718F_ID:
+		printk_message = 1;
+		rc = -ENODEV;
+		goto err_out_superio;
+	case NO_DEV_ID:
+		printk_message = 2;
+		rc = -ENODEV;
+		goto err_out_superio;
+	default:
+		printk_message = 3;
+		rc = -ENODEV;
+		goto err_out_superio;
+	}
+
+	superio_select(GPIO);
+	superio_outb(0x00, WDTCTRL);
+	superio_outb(WDT_TOV1, WDTCFG);
+
+	superio_select(GAMEPORT);
+	gpact = superio_inb(ACTREG);
+	superio_outb(0x01, ACTREG);
+	gameport_base = superio_inw(BASEREG);
+
+	if (!(superio_inb(ACTREG) & 0x01)) {
+		printk_message = 4;
+		rc = -EBUSY;
+		goto err_out_superio;
+	}
+	if (!gameport_base) {
+		printk_message = 5;
+		rc = -ENODEV;
+		goto err_out_superio;
+	}
+	superio_exit();
+	spin_unlock_irqrestore(&spinlock, flags);
+
+	if (!request_region(gameport_base, 1, WATCHDOG_NAME)) {
+		printk(KERN_ERR PFX "I/O Address 0x%04x already in use\n",
+			gameport_base);
+		rc = -EIO;
+		goto err_out;
+	}
+
+	rc = misc_register(&wdt_miscdev);
+	if (rc) {
+		printk(KERN_ERR PFX
+		       "Cannot register miscdev on minor=%d (err=%d)\n",
+			wdt_miscdev.minor, rc);
+		goto err_out_region;
+	}
+
+	rc = register_reboot_notifier(&wdt_notifier);
+	if (rc) {
+		printk(KERN_ERR PFX
+		       "Cannot register reboot notifier (err=%d)\n", rc);
+		goto err_out_miscdev;
+	}
+
+	if (timeout < 1 || timeout > 65535) {
+		timeout = DEFAULT_TIMEOUT;
+		printk(KERN_WARNING PFX
+		       "Timeout value out of range, use default\n");
+	}
+
+	printk(KERN_INFO PFX "Chip %04x revision %02x initialized. "
+		"timeout=%d sec (nowayout=%d testmode=%d exclusiv=%d)\n",
+		chip_type, chip_rev, timeout, nowayout, testmode, exclusiv);
+
+	return 0;
+
+err_out_miscdev:
+	misc_deregister(&wdt_miscdev);
+err_out_region:
+	release_region(gameport_base, 1);
+err_out:
+	spin_lock_irqsave(&spinlock, flags);
+	superio_enter();
+	superio_select(GAMEPORT);
+	superio_outb(gpact, ACTREG);
+err_out_superio:
+	superio_exit();
+	spin_unlock_irqrestore(&spinlock, flags);
+
+	switch (printk_message) {
+	case 1:
+		printk(KERN_ERR PFX
+		       "Unsupported Chip found, Chip %04x Revision %02x\n",
+		       chip_type, chip_rev);
+		break;
+	case 2:
+		printk(KERN_ERR PFX "no device\n");
+		break;
+	case 3:
+		printk(KERN_ERR PFX
+		       "Unknown Chip found, Chip %04x Revision %04x\n",
+		       chip_type, chip_rev);
+	case 4:
+		printk(KERN_ERR PFX "Device refuse activation\n");
+		break;
+	case 5:
+		printk(KERN_ERR PFX "No Portaddress\n");
+		break;
+	}
+
+	return rc;
+}
+
+static void __exit it87_wdt_exit(void)
+{
+	unsigned long flags;
+
+	int nolock = !spin_trylock_irqsave(&spinlock, flags);
+	superio_enter();
+
+	superio_select(GPIO);
+	superio_outb(0x00, WDTCTRL);
+	superio_outb(WDT_TOV1, WDTCFG);
+	superio_outb(0x00, WDTVALMSB);
+	superio_outb(0x00, WDTVALLSB);
+	superio_select(GAMEPORT);
+	superio_outb(gpact, ACTREG);
+
+	superio_exit();
+	if (!nolock)
+		spin_unlock_irqrestore(&spinlock, flags);
+
+	misc_deregister(&wdt_miscdev);
+	unregister_reboot_notifier(&wdt_notifier);
+	release_region(gameport_base, 1);
+}
+
+module_init(it87_wdt_init);
+module_exit(it87_wdt_exit);
+
+MODULE_AUTHOR("Oliver Schuster");
+MODULE_DESCRIPTION("Hardware Watchdog Device Driver for IT87xx EC-LPC I/O");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
diff -urP linux-2.6.24.3/drivers/watchdog/Kconfig linux-2.6.24.3/drivers/watchdog/Kconfig
--- linux-2.6.24.3/drivers/watchdog/Kconfig	2008-02-26 01:20:20.000000000 +0100
+++ linux-2.6.24.3/drivers/watchdog/Kconfig	2008-02-27 14:57:26.582535866 +0100
@@ -565,6 +565,19 @@
 	  To compile this driver as a module, choose M here: the
 	  module will be called w83977f_wdt.
 
+config IT87_WDT
+	tristate "IT87 Watchdog Timer"
+	depends on EXPERIMENTAL
+	---help---
+	  This is the driver for the hardware watchdog on the ITE IT8716F,
+	  IT8726F, IT8712F(Version J,K) Super I/O chips.  This watchdog 
+	  simply watches your kernel to make sure it doesn't freeze, and
+	  if it does, it reboots your computer after a certain amount of
+	  time.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called it87_wdt.
+
 config MACHZ_WDT
 	tristate "ZF MachZ Watchdog"
 	depends on X86
diff -urP linux-2.6.24.3/drivers/watchdog/Makefile linux-2.6.24.3/drivers/watchdog/Makefile
--- linux-2.6.24.3/drivers/watchdog/Makefile	2008-02-26 01:20:20.000000000 +0100
+++ linux-2.6.24.3/drivers/watchdog/Makefile	2008-02-27 14:57:26.583537195 +0100
@@ -79,6 +79,7 @@
 obj-$(CONFIG_W83697HF_WDT) += w83697hf_wdt.o
 obj-$(CONFIG_W83877F_WDT) += w83877f_wdt.o
 obj-$(CONFIG_W83977F_WDT) += w83977f_wdt.o
+obj-$(CONFIG_IT87_WDT) += it87_wdt.o
 obj-$(CONFIG_MACHZ_WDT) += machzwd.o
 obj-$(CONFIG_SBC_EPX_C3_WATCHDOG) += sbc_epx_c3.o
 



--------------050108010201080901070807--
