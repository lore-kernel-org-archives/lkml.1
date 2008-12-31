Return-Path: <linux-kernel-owner+w=401wt.eu-S1756662AbYLaQQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662AbYLaQQT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 11:16:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755782AbYLaQQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 11:16:08 -0500
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:14241 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755531AbYLaQQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 11:16:04 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqYEAOsnW0lR9TGm/2dsb2JhbACBbMsEhkQ
Date: Wed, 31 Dec 2008 17:15:57 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [WATCHDOG] v2.6.29-rc1 watchdog patches
Message-ID: <20081231161557.GU11454@infomag.infomag.iguana.be>
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

 drivers/watchdog/Kconfig       |   19 +
 drivers/watchdog/Makefile      |    2 
 drivers/watchdog/ib700wdt.c    |   49 +--
 drivers/watchdog/sch311x_wdt.c |  578 +++++++++++++++++++++++++++++++++++++++++
 drivers/watchdog/wm8350_wdt.c  |  329 +++++++++++++++++++++++
 5 files changed, 947 insertions(+), 30 deletions(-)

with these Changes:

Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
Date:   Thu Nov 6 10:56:21 2008 +0000

    [WATCHDOG] Add support for the WM8350 watchdog
    
    This driver implements support for the watchdog functionality provided
    by the Wolfson Microelectronics WM8350, a multi-function audio and
    power management subsystem intended for use in embedded systems. It is
    based on a driver originally written by Graeme Gregory, though it has
    been extensively modified since then.
    
    Use of a GPIO to kick the watchdog is not yet supported.
    
    Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Wed Oct 22 08:59:25 2008 +0000

    [WATCHDOG] Add SMSC SCH311x Watchdog Timer.
    
    Add a watchdog driver for the hardware watchdog timer on the
    SMSC SCH3112, SCH3114 and SCH3116 Super IO chipset.
    
    Tested-by: Marco Chiappero <marco@absence.it>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Wed Oct 15 11:44:40 2008 +0000

    [WATCHDOG] ib700wdt - add timeout parameter
    
    Add the timeout module parameter to ib700wdt.c
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 4fd3fa5..ec68c74 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -55,6 +55,13 @@ config SOFT_WATCHDOG
 	  To compile this driver as a module, choose M here: the
 	  module will be called softdog.
 
+config WM8350_WATCHDOG
+	tristate "WM8350 watchdog"
+	depends on MFD_WM8350
+	help
+	  Support for the watchdog in the WM8350 AudioPlus PMIC.  When
+	  the watchdog triggers the system will be reset.
+
 # ALPHA Architecture
 
 # ARM Architecture
@@ -551,6 +558,18 @@ config CPU5_WDT
 	  To compile this driver as a module, choose M here: the
 	  module will be called cpu5wdt.
 
+config SMSC_SCH311X_WDT
+	tristate "SMSC SCH311X Watchdog Timer"
+	depends on X86
+	---help---
+	  This is the driver for the hardware watchdog timer on the
+	  SMSC SCH3112, SCH3114 and SCH3116 Super IO chipset
+	  (LPC IO with 8042 KBC, Reset Generation, HWM and multiple
+	  serial ports).
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called sch311x_wdt.
+
 config SMSC37B787_WDT
 	tristate "Winbond SMsC37B787 Watchdog Timer"
 	depends on X86
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index e352bbb..c19b866 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -83,6 +83,7 @@ obj-$(CONFIG_60XX_WDT) += sbc60xxwdt.o
 obj-$(CONFIG_SBC8360_WDT) += sbc8360.o
 obj-$(CONFIG_SBC7240_WDT) += sbc7240_wdt.o
 obj-$(CONFIG_CPU5_WDT) += cpu5wdt.o
+obj-$(CONFIG_SMSC_SCH311X_WDT) += sch311x_wdt.o
 obj-$(CONFIG_SMSC37B787_WDT) += smsc37b787_wdt.o
 obj-$(CONFIG_W83627HF_WDT) += w83627hf_wdt.o
 obj-$(CONFIG_W83697HF_WDT) += w83697hf_wdt.o
@@ -133,4 +134,5 @@ obj-$(CONFIG_WATCHDOG_CP1XXX)		+= cpwd.o
 # XTENSA Architecture
 
 # Architecture Independant
+obj-$(CONFIG_WM8350_WATCHDOG) += wm8350_wdt.o
 obj-$(CONFIG_SOFT_WATCHDOG) += softdog.o
diff --git a/drivers/watchdog/ib700wdt.c b/drivers/watchdog/ib700wdt.c
index 317ef2b..4bef3dd 100644
--- a/drivers/watchdog/ib700wdt.c
+++ b/drivers/watchdog/ib700wdt.c
@@ -91,32 +91,16 @@ static char expect_close;
  *
  */
 
-static int wd_times[] = {
-	30,	/* 0x0 */
-	28,	/* 0x1 */
-	26,	/* 0x2 */
-	24,	/* 0x3 */
-	22,	/* 0x4 */
-	20,	/* 0x5 */
-	18,	/* 0x6 */
-	16,	/* 0x7 */
-	14,	/* 0x8 */
-	12,	/* 0x9 */
-	10,	/* 0xA */
-	8,	/* 0xB */
-	6,	/* 0xC */
-	4,	/* 0xD */
-	2,	/* 0xE */
-	0,	/* 0xF */
-};
-
 #define WDT_STOP 0x441
 #define WDT_START 0x443
 
 /* Default timeout */
-#define WD_TIMO 0		/* 30 seconds +/- 20%, from table */
-
-static int wd_margin = WD_TIMO;
+#define WATCHDOG_TIMEOUT 30		/* 30 seconds +/- 20% */
+static int timeout = WATCHDOG_TIMEOUT;	/* in seconds */
+module_param(timeout, int, 0);
+MODULE_PARM_DESC(timeout,
+	"Watchdog timeout in seconds. 0<= timeout <=30, default="
+		__MODULE_STRING(WATCHDOG_TIMEOUT) ".");
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
@@ -131,6 +115,8 @@ MODULE_PARM_DESC(nowayout,
 
 static void ibwdt_ping(void)
 {
+	int wd_margin = 15 - ((timeout + 1) / 2);
+
 	spin_lock(&ibwdt_lock);
 
 	/* Write a watchdog value */
@@ -148,15 +134,10 @@ static void ibwdt_disable(void)
 
 static int ibwdt_set_heartbeat(int t)
 {
-	int i;
-
-	if ((t < 0) || (t > 30))
+	if (t < 0 || t > 30)
 		return -EINVAL;
 
-	for (i = 0x0F; i > -1; i--)
-		if (wd_times[i] >= t)
-			break;
-	wd_margin = i;
+	timeout = t;
 	return 0;
 }
 
@@ -240,7 +221,7 @@ static long ibwdt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		/* Fall */
 
 	case WDIOC_GETTIMEOUT:
-		return put_user(wd_times[wd_margin], p);
+		return put_user(timeout, p);
 
 	default:
 		return -ENOTTY;
@@ -317,6 +298,14 @@ static int __devinit ibwdt_probe(struct platform_device *dev)
 		goto out_nostartreg;
 	}
 
+	/* Check that the heartbeat value is within it's range ;
+	 * if not reset to the default */
+	if (ibwdt_set_heartbeat(timeout)) {
+		ibwdt_set_heartbeat(WATCHDOG_TIMEOUT);
+		printk(KERN_INFO PFX
+			"timeout value must be 0<=x<=30, using %d\n", timeout);
+	}
+
 	res = misc_register(&ibwdt_miscdev);
 	if (res) {
 		printk(KERN_ERR PFX "failed to register misc device\n");
diff --git a/drivers/watchdog/sch311x_wdt.c b/drivers/watchdog/sch311x_wdt.c
new file mode 100644
index 0000000..569eb29
--- /dev/null
+++ b/drivers/watchdog/sch311x_wdt.c
@@ -0,0 +1,578 @@
+/*
+ *	sch311x_wdt.c - Driver for the SCH311x Super-I/O chips
+ *			integrated watchdog.
+ *
+ *	(c) Copyright 2008 Wim Van Sebroeck <wim@iguana.be>.
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License
+ *	as published by the Free Software Foundation; either version
+ *	2 of the License, or (at your option) any later version.
+ *
+ *	Neither Wim Van Sebroeck nor Iguana vzw. admit liability nor
+ *	provide warranty for any of this software. This material is
+ *	provided "AS-IS" and at no charge.
+ */
+
+/*
+ *	Includes, defines, variables, module parameters, ...
+ */
+
+/* Includes */
+#include <linux/module.h>		/* For module specific items */
+#include <linux/moduleparam.h>		/* For new moduleparam's */
+#include <linux/types.h>		/* For standard types (like size_t) */
+#include <linux/errno.h>		/* For the -ENODEV/... values */
+#include <linux/kernel.h>		/* For printk/... */
+#include <linux/miscdevice.h>		/* For MODULE_ALIAS_MISCDEV
+							(WATCHDOG_MINOR) */
+#include <linux/watchdog.h>		/* For the watchdog specific items */
+#include <linux/init.h>			/* For __init/__exit/... */
+#include <linux/fs.h>			/* For file operations */
+#include <linux/platform_device.h>	/* For platform_driver framework */
+#include <linux/ioport.h>		/* For io-port access */
+#include <linux/spinlock.h>		/* For spin_lock/spin_unlock/... */
+#include <linux/uaccess.h>		/* For copy_to_user/put_user/... */
+#include <linux/io.h>			/* For inb/outb/... */
+
+/* Module and version information */
+#define DRV_NAME	"sch311x_wdt"
+#define PFX		DRV_NAME ": "
+
+/* Runtime registers */
+#define RESGEN			0x1d
+#define GP60			0x47
+#define WDT_TIME_OUT		0x65
+#define WDT_VAL			0x66
+#define WDT_CFG			0x67
+#define WDT_CTRL		0x68
+
+/* internal variables */
+static unsigned long sch311x_wdt_is_open;
+static char sch311x_wdt_expect_close;
+static struct platform_device *sch311x_wdt_pdev;
+
+static int sch311x_ioports[] = { 0x2e, 0x4e, 0x162e, 0x164e, 0x00 };
+
+static struct {	/* The devices private data */
+	/* the Runtime Register base address */
+	unsigned short runtime_reg;
+	/* The card's boot status */
+	int boot_status;
+	/* the lock for io operations */
+	spinlock_t io_lock;
+} sch311x_wdt_data;
+
+/* Module load parameters */
+static unsigned short force_id;
+module_param(force_id, ushort, 0);
+MODULE_PARM_DESC(force_id, "Override the detected device ID");
+
+static unsigned short therm_trip;
+module_param(therm_trip, ushort, 0);
+MODULE_PARM_DESC(therm_trip, "Should a ThermTrip trigger the reset generator");
+
+#define WATCHDOG_TIMEOUT 60		/* 60 sec default timeout */
+static int timeout = WATCHDOG_TIMEOUT;	/* in seconds */
+module_param(timeout, int, 0);
+MODULE_PARM_DESC(timeout,
+	"Watchdog timeout in seconds. 1<= timeout <=15300, default="
+		__MODULE_STRING(WATCHDOG_TIMEOUT) ".");
+
+static int nowayout = WATCHDOG_NOWAYOUT;
+module_param(nowayout, int, 0);
+MODULE_PARM_DESC(nowayout,
+	"Watchdog cannot be stopped once started (default="
+		__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+
+/*
+ *	Super-IO functions
+ */
+
+static inline void sch311x_sio_enter(int sio_config_port)
+{
+	outb(0x55, sio_config_port);
+}
+
+static inline void sch311x_sio_exit(int sio_config_port)
+{
+	outb(0xaa, sio_config_port);
+}
+
+static inline int sch311x_sio_inb(int sio_config_port, int reg)
+{
+	outb(reg, sio_config_port);
+	return inb(sio_config_port + 1);
+}
+
+static inline void sch311x_sio_outb(int sio_config_port, int reg, int val)
+{
+	outb(reg, sio_config_port);
+	outb(val, sio_config_port + 1);
+}
+
+/*
+ *	Watchdog Operations
+ */
+
+static void sch311x_wdt_set_timeout(int t)
+{
+	unsigned char timeout_unit = 0x80;
+
+	/* When new timeout is bigger then 255 seconds, we will use minutes */
+	if (t > 255) {
+		timeout_unit = 0;
+		t /= 60;
+	}
+
+	/* -- Watchdog Timeout --
+	 * Bit 0-6 (Reserved)
+	 * Bit 7   WDT Time-out Value Units Select
+	 *         (0 = Minutes, 1 = Seconds)
+	 */
+	outb(timeout_unit, sch311x_wdt_data.runtime_reg + WDT_TIME_OUT);
+
+	/* -- Watchdog Timer Time-out Value --
+	 * Bit 0-7 Binary coded units (0=Disabled, 1..255)
+	 */
+	outb(t, sch311x_wdt_data.runtime_reg + WDT_VAL);
+}
+
+static void sch311x_wdt_start(void)
+{
+	spin_lock(&sch311x_wdt_data.io_lock);
+
+	/* set watchdog's timeout */
+	sch311x_wdt_set_timeout(timeout);
+	/* enable the watchdog */
+	/* -- General Purpose I/O Bit 6.0 --
+	 * Bit 0,   In/Out: 0 = Output, 1 = Input
+	 * Bit 1,   Polarity: 0 = No Invert, 1 = Invert
+	 * Bit 2-3, Function select: 00 = GPI/O, 01 = LED1, 11 = WDT,
+	 *                           10 = Either Edge Triggered Intr.4
+	 * Bit 4-6  (Reserved)
+	 * Bit 7,   Output Type: 0 = Push Pull Bit, 1 = Open Drain
+	 */
+	outb(0x0e, sch311x_wdt_data.runtime_reg + GP60);
+
+	spin_unlock(&sch311x_wdt_data.io_lock);
+
+}
+
+static void sch311x_wdt_stop(void)
+{
+	spin_lock(&sch311x_wdt_data.io_lock);
+
+	/* stop the watchdog */
+	outb(0x01, sch311x_wdt_data.runtime_reg + GP60);
+	/* disable timeout by setting it to 0 */
+	sch311x_wdt_set_timeout(0);
+
+	spin_unlock(&sch311x_wdt_data.io_lock);
+}
+
+static void sch311x_wdt_keepalive(void)
+{
+	spin_lock(&sch311x_wdt_data.io_lock);
+	sch311x_wdt_set_timeout(timeout);
+	spin_unlock(&sch311x_wdt_data.io_lock);
+}
+
+static int sch311x_wdt_set_heartbeat(int t)
+{
+	if (t < 1 || t > (255*60))
+		return -EINVAL;
+
+	/* When new timeout is bigger then 255 seconds,
+	 * we will round up to minutes (with a max of 255) */
+	if (t > 255)
+		t = (((t - 1) / 60) + 1) * 60;
+
+	timeout = t;
+	return 0;
+}
+
+static void sch311x_wdt_get_status(int *status)
+{
+	unsigned char new_status;
+
+	*status = 0;
+
+	spin_lock(&sch311x_wdt_data.io_lock);
+
+	/* -- Watchdog timer control --
+	 * Bit 0   Status Bit: 0 = Timer counting, 1 = Timeout occured
+	 * Bit 1   Reserved
+	 * Bit 2   Force Timeout: 1 = Forces WD timeout event (self-cleaning)
+	 * Bit 3   P20 Force Timeout enabled:
+	 *          0 = P20 activity does not generate the WD timeout event
+	 *          1 = P20 Allows rising edge of P20, from the keyboard
+	 *              controller, to force the WD timeout event.
+	 * Bit 4-7 Reserved
+	 */
+	new_status = inb(sch311x_wdt_data.runtime_reg + WDT_CTRL);
+	if (new_status & 0x01)
+		*status |= WDIOF_CARDRESET;
+
+	spin_unlock(&sch311x_wdt_data.io_lock);
+}
+
+/*
+ *	/dev/watchdog handling
+ */
+
+static ssize_t sch311x_wdt_write(struct file *file, const char __user *buf,
+						size_t count, loff_t *ppos)
+{
+	if (count) {
+		if (!nowayout) {
+			size_t i;
+
+			sch311x_wdt_expect_close = 0;
+
+			for (i = 0; i != count; i++) {
+				char c;
+				if (get_user(c, buf + i))
+					return -EFAULT;
+				if (c == 'V')
+					sch311x_wdt_expect_close = 42;
+			}
+		}
+		sch311x_wdt_keepalive();
+	}
+	return count;
+}
+
+static long sch311x_wdt_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
+{
+	int status;
+	int new_timeout;
+	void __user *argp = (void __user *)arg;
+	int __user *p = argp;
+	static struct watchdog_info ident = {
+		.options		= WDIOF_KEEPALIVEPING |
+					  WDIOF_SETTIMEOUT |
+					  WDIOF_MAGICCLOSE,
+		.firmware_version	= 1,
+		.identity		= DRV_NAME,
+	};
+
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		if (copy_to_user(argp, &ident, sizeof(ident)))
+			return -EFAULT;
+		break;
+
+	case WDIOC_GETSTATUS:
+	{
+		sch311x_wdt_get_status(&status);
+		return put_user(status, p);
+	}
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(sch311x_wdt_data.boot_status, p);
+
+	case WDIOC_SETOPTIONS:
+	{
+		int options, retval = -EINVAL;
+
+		if (get_user(options, p))
+			return -EFAULT;
+		if (options & WDIOS_DISABLECARD) {
+			sch311x_wdt_stop();
+			retval = 0;
+		}
+		if (options & WDIOS_ENABLECARD) {
+			sch311x_wdt_start();
+			retval = 0;
+		}
+		return retval;
+	}
+	case WDIOC_KEEPALIVE:
+		sch311x_wdt_keepalive();
+		break;
+
+	case WDIOC_SETTIMEOUT:
+		if (get_user(new_timeout, p))
+			return -EFAULT;
+		if (sch311x_wdt_set_heartbeat(new_timeout))
+			return -EINVAL;
+		sch311x_wdt_keepalive();
+		/* Fall */
+	case WDIOC_GETTIMEOUT:
+		return put_user(timeout, p);
+	default:
+		return -ENOTTY;
+	}
+	return 0;
+}
+
+static int sch311x_wdt_open(struct inode *inode, struct file *file)
+{
+	if (test_and_set_bit(0, &sch311x_wdt_is_open))
+		return -EBUSY;
+	/*
+	 *	Activate
+	 */
+	sch311x_wdt_start();
+	return nonseekable_open(inode, file);
+}
+
+static int sch311x_wdt_close(struct inode *inode, struct file *file)
+{
+	if (sch311x_wdt_expect_close == 42) {
+		sch311x_wdt_stop();
+	} else {
+		printk(KERN_CRIT PFX
+				"Unexpected close, not stopping watchdog!\n");
+		sch311x_wdt_keepalive();
+	}
+	clear_bit(0, &sch311x_wdt_is_open);
+	sch311x_wdt_expect_close = 0;
+	return 0;
+}
+
+/*
+ *	Kernel Interfaces
+ */
+
+static const struct file_operations sch311x_wdt_fops = {
+	.owner		= THIS_MODULE,
+	.llseek		= no_llseek,
+	.write		= sch311x_wdt_write,
+	.unlocked_ioctl	= sch311x_wdt_ioctl,
+	.open		= sch311x_wdt_open,
+	.release	= sch311x_wdt_close,
+};
+
+static struct miscdevice sch311x_wdt_miscdev = {
+	.minor	= WATCHDOG_MINOR,
+	.name	= "watchdog",
+	.fops	= &sch311x_wdt_fops,
+};
+
+/*
+ *	Init & exit routines
+ */
+
+static int __devinit sch311x_wdt_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	unsigned char val;
+	int err;
+
+	spin_lock_init(&sch311x_wdt_data.io_lock);
+
+	if (!request_region(sch311x_wdt_data.runtime_reg + RESGEN, 1,
+								DRV_NAME)) {
+		dev_err(dev, "Failed to request region 0x%04x-0x%04x.\n",
+			sch311x_wdt_data.runtime_reg + RESGEN,
+			sch311x_wdt_data.runtime_reg + RESGEN);
+		err = -EBUSY;
+		goto exit;
+	}
+
+	if (!request_region(sch311x_wdt_data.runtime_reg + GP60, 1, DRV_NAME)) {
+		dev_err(dev, "Failed to request region 0x%04x-0x%04x.\n",
+			sch311x_wdt_data.runtime_reg + GP60,
+			sch311x_wdt_data.runtime_reg + GP60);
+		err = -EBUSY;
+		goto exit_release_region;
+	}
+
+	if (!request_region(sch311x_wdt_data.runtime_reg + WDT_TIME_OUT, 4,
+								DRV_NAME)) {
+		dev_err(dev, "Failed to request region 0x%04x-0x%04x.\n",
+			sch311x_wdt_data.runtime_reg + WDT_TIME_OUT,
+			sch311x_wdt_data.runtime_reg + WDT_CTRL);
+		err = -EBUSY;
+		goto exit_release_region2;
+	}
+
+	/* Make sure that the watchdog is not running */
+	sch311x_wdt_stop();
+
+	/* Disable keyboard and mouse interaction and interrupt */
+	/* -- Watchdog timer configuration --
+	 * Bit 0   Reserved
+	 * Bit 1   Keyboard enable: 0* = No Reset, 1 = Reset WDT upon KBD Intr.
+	 * Bit 2   Mouse enable: 0* = No Reset, 1 = Reset WDT upon Mouse Intr
+	 * Bit 3   Reserved
+	 * Bit 4-7 WDT Interrupt Mapping: (0000* = Disabled,
+	 *            0001=IRQ1, 0010=(Invalid), 0011=IRQ3 to 1111=IRQ15)
+	 */
+	outb(0, sch311x_wdt_data.runtime_reg + WDT_CFG);
+
+	/* Check that the heartbeat value is within it's range ;
+	 * if not reset to the default */
+	if (sch311x_wdt_set_heartbeat(timeout)) {
+		sch311x_wdt_set_heartbeat(WATCHDOG_TIMEOUT);
+		dev_info(dev, "timeout value must be 1<=x<=15300, using %d\n",
+			timeout);
+	}
+
+	/* Get status at boot */
+	sch311x_wdt_get_status(&sch311x_wdt_data.boot_status);
+
+	/* enable watchdog */
+	/* -- Reset Generator --
+	 * Bit 0   Enable Watchdog Timer Generation: 0* = Enabled, 1 = Disabled
+	 * Bit 1   Thermtrip Source Select: O* = No Source, 1 = Source
+	 * Bit 2   WDT2_CTL: WDT input bit
+	 * Bit 3-7 Reserved
+	 */
+	outb(0, sch311x_wdt_data.runtime_reg + RESGEN);
+	val = therm_trip ? 0x06 : 0x04;
+	outb(val, sch311x_wdt_data.runtime_reg + RESGEN);
+
+	err = misc_register(&sch311x_wdt_miscdev);
+	if (err != 0) {
+		dev_err(dev, "cannot register miscdev on minor=%d (err=%d)\n",
+							WATCHDOG_MINOR, err);
+		goto exit_release_region3;
+	}
+
+	sch311x_wdt_miscdev.parent = dev;
+
+	dev_info(dev,
+		"SMSC SCH311x WDT initialized. timeout=%d sec (nowayout=%d)\n",
+		timeout, nowayout);
+
+	return 0;
+
+exit_release_region3:
+	release_region(sch311x_wdt_data.runtime_reg + WDT_TIME_OUT, 4);
+exit_release_region2:
+	release_region(sch311x_wdt_data.runtime_reg + GP60, 1);
+exit_release_region:
+	release_region(sch311x_wdt_data.runtime_reg + RESGEN, 1);
+	sch311x_wdt_data.runtime_reg = 0;
+exit:
+	return err;
+}
+
+static int __devexit sch311x_wdt_remove(struct platform_device *pdev)
+{
+	/* Stop the timer before we leave */
+	if (!nowayout)
+		sch311x_wdt_stop();
+
+	/* Deregister */
+	misc_deregister(&sch311x_wdt_miscdev);
+	release_region(sch311x_wdt_data.runtime_reg + WDT_TIME_OUT, 4);
+	release_region(sch311x_wdt_data.runtime_reg + GP60, 1);
+	release_region(sch311x_wdt_data.runtime_reg + RESGEN, 1);
+	sch311x_wdt_data.runtime_reg = 0;
+	return 0;
+}
+
+static void sch311x_wdt_shutdown(struct platform_device *dev)
+{
+	/* Turn the WDT off if we have a soft shutdown */
+	sch311x_wdt_stop();
+}
+
+#define sch311x_wdt_suspend NULL
+#define sch311x_wdt_resume  NULL
+
+static struct platform_driver sch311x_wdt_driver = {
+	.probe		= sch311x_wdt_probe,
+	.remove		= __devexit_p(sch311x_wdt_remove),
+	.shutdown	= sch311x_wdt_shutdown,
+	.suspend	= sch311x_wdt_suspend,
+	.resume		= sch311x_wdt_resume,
+	.driver		= {
+		.owner = THIS_MODULE,
+		.name = DRV_NAME,
+	},
+};
+
+static int __init sch311x_detect(int sio_config_port, unsigned short *addr)
+{
+	int err = 0, reg;
+	unsigned short base_addr;
+	unsigned char dev_id;
+
+	sch311x_sio_enter(sio_config_port);
+
+	/* Check device ID. We currently know about:
+	 * SCH3112 (0x7c), SCH3114 (0x7d), and SCH3116 (0x7f). */
+	reg = force_id ? force_id : sch311x_sio_inb(sio_config_port, 0x20);
+	if (!(reg == 0x7c || reg == 0x7d || reg == 0x7f)) {
+		err = -ENODEV;
+		goto exit;
+	}
+	dev_id = reg == 0x7c ? 2 : reg == 0x7d ? 4 : 6;
+
+	/* Select logical device A (runtime registers) */
+	sch311x_sio_outb(sio_config_port, 0x07, 0x0a);
+
+	/* Check if Logical Device Register is currently active */
+	if (sch311x_sio_inb(sio_config_port, 0x30) && 0x01 == 0)
+		printk(KERN_INFO PFX "Seems that LDN 0x0a is not active...\n");
+
+	/* Get the base address of the runtime registers */
+	base_addr = (sch311x_sio_inb(sio_config_port, 0x60) << 8) |
+			   sch311x_sio_inb(sio_config_port, 0x61);
+	if (!base_addr) {
+		printk(KERN_ERR PFX "Base address not set.\n");
+		err = -ENODEV;
+		goto exit;
+	}
+	*addr = base_addr;
+
+	printk(KERN_INFO PFX "Found an SMSC SCH311%d chip at 0x%04x\n",
+		dev_id, base_addr);
+
+exit:
+	sch311x_sio_exit(sio_config_port);
+	return err;
+}
+
+static int __init sch311x_wdt_init(void)
+{
+	int err, i, found = 0;
+	unsigned short addr = 0;
+
+	for (i = 0; !found && sch311x_ioports[i]; i++)
+		if (sch311x_detect(sch311x_ioports[i], &addr) == 0)
+			found++;
+
+	if (!found)
+		return -ENODEV;
+
+	sch311x_wdt_data.runtime_reg = addr;
+
+	err = platform_driver_register(&sch311x_wdt_driver);
+	if (err)
+		return err;
+
+	sch311x_wdt_pdev = platform_device_register_simple(DRV_NAME, addr,
+								NULL, 0);
+
+	if (IS_ERR(sch311x_wdt_pdev)) {
+		err = PTR_ERR(sch311x_wdt_pdev);
+		goto unreg_platform_driver;
+	}
+
+	return 0;
+
+unreg_platform_driver:
+	platform_driver_unregister(&sch311x_wdt_driver);
+	return err;
+}
+
+static void __exit sch311x_wdt_exit(void)
+{
+	platform_device_unregister(sch311x_wdt_pdev);
+	platform_driver_unregister(&sch311x_wdt_driver);
+}
+
+module_init(sch311x_wdt_init);
+module_exit(sch311x_wdt_exit);
+
+MODULE_AUTHOR("Wim Van Sebroeck <wim@iguana.be>");
+MODULE_DESCRIPTION("SMSC SCH311x WatchDog Timer Driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
+
diff --git a/drivers/watchdog/wm8350_wdt.c b/drivers/watchdog/wm8350_wdt.c
new file mode 100644
index 0000000..2bc0d4d
--- /dev/null
+++ b/drivers/watchdog/wm8350_wdt.c
@@ -0,0 +1,329 @@
+/*
+ * Watchdog driver for the wm8350
+ *
+ * Copyright (C) 2007, 2008 Wolfson Microelectronics <linux@wolfsonmicro.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/fs.h>
+#include <linux/miscdevice.h>
+#include <linux/platform_device.h>
+#include <linux/watchdog.h>
+#include <linux/uaccess.h>
+#include <linux/mfd/wm8350/core.h>
+
+static int nowayout = WATCHDOG_NOWAYOUT;
+module_param(nowayout, int, 0);
+MODULE_PARM_DESC(nowayout,
+		 "Watchdog cannot be stopped once started (default="
+		 __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+
+static unsigned long wm8350_wdt_users;
+static struct miscdevice wm8350_wdt_miscdev;
+static int wm8350_wdt_expect_close;
+static DEFINE_MUTEX(wdt_mutex);
+
+static struct {
+	int time;  /* Seconds */
+	u16 val;   /* To be set in WM8350_SYSTEM_CONTROL_2 */
+} wm8350_wdt_cfgs[] = {
+	{ 1, 0x02 },
+	{ 2, 0x04 },
+	{ 4, 0x05 },
+};
+
+static struct wm8350 *get_wm8350(void)
+{
+	return dev_get_drvdata(wm8350_wdt_miscdev.parent);
+}
+
+static int wm8350_wdt_set_timeout(struct wm8350 *wm8350, u16 value)
+{
+	int ret;
+	u16 reg;
+
+	mutex_lock(&wdt_mutex);
+	wm8350_reg_unlock(wm8350);
+
+	reg = wm8350_reg_read(wm8350, WM8350_SYSTEM_CONTROL_2);
+	reg &= ~WM8350_WDOG_TO_MASK;
+	reg |= value;
+	ret = wm8350_reg_write(wm8350, WM8350_SYSTEM_CONTROL_2, reg);
+
+	wm8350_reg_lock(wm8350);
+	mutex_unlock(&wdt_mutex);
+
+	return ret;
+}
+
+static int wm8350_wdt_start(struct wm8350 *wm8350)
+{
+	int ret;
+	u16 reg;
+
+	mutex_lock(&wdt_mutex);
+	wm8350_reg_unlock(wm8350);
+
+	reg = wm8350_reg_read(wm8350, WM8350_SYSTEM_CONTROL_2);
+	reg &= ~WM8350_WDOG_MODE_MASK;
+	reg |= 0x20;
+	ret = wm8350_reg_write(wm8350, WM8350_SYSTEM_CONTROL_2, reg);
+
+	wm8350_reg_lock(wm8350);
+	mutex_unlock(&wdt_mutex);
+
+	return ret;
+}
+
+static int wm8350_wdt_stop(struct wm8350 *wm8350)
+{
+	int ret;
+	u16 reg;
+
+	mutex_lock(&wdt_mutex);
+	wm8350_reg_unlock(wm8350);
+
+	reg = wm8350_reg_read(wm8350, WM8350_SYSTEM_CONTROL_2);
+	reg &= ~WM8350_WDOG_MODE_MASK;
+	ret = wm8350_reg_write(wm8350, WM8350_SYSTEM_CONTROL_2, reg);
+
+	wm8350_reg_lock(wm8350);
+	mutex_unlock(&wdt_mutex);
+
+	return ret;
+}
+
+static int wm8350_wdt_kick(struct wm8350 *wm8350)
+{
+	int ret;
+	u16 reg;
+
+	mutex_lock(&wdt_mutex);
+
+	reg = wm8350_reg_read(wm8350, WM8350_SYSTEM_CONTROL_2);
+	ret = wm8350_reg_write(wm8350, WM8350_SYSTEM_CONTROL_2, reg);
+
+	mutex_unlock(&wdt_mutex);
+
+	return ret;
+}
+
+static int wm8350_wdt_open(struct inode *inode, struct file *file)
+{
+	struct wm8350 *wm8350 = get_wm8350();
+	int ret;
+
+	if (!wm8350)
+		return -ENODEV;
+
+	if (test_and_set_bit(0, &wm8350_wdt_users))
+		return -EBUSY;
+
+	ret = wm8350_wdt_start(wm8350);
+	if (ret != 0)
+		return ret;
+
+	return nonseekable_open(inode, file);
+}
+
+static int wm8350_wdt_release(struct inode *inode, struct file *file)
+{
+	struct wm8350 *wm8350 = get_wm8350();
+
+	if (wm8350_wdt_expect_close)
+		wm8350_wdt_stop(wm8350);
+	else {
+		dev_warn(wm8350->dev, "Watchdog device closed uncleanly\n");
+		wm8350_wdt_kick(wm8350);
+	}
+
+	clear_bit(0, &wm8350_wdt_users);
+
+	return 0;
+}
+
+static ssize_t wm8350_wdt_write(struct file *file,
+				const char __user *data, size_t count,
+				loff_t *ppos)
+{
+	struct wm8350 *wm8350 = get_wm8350();
+	size_t i;
+
+	if (count) {
+		wm8350_wdt_kick(wm8350);
+
+		if (!nowayout) {
+			/* In case it was set long ago */
+			wm8350_wdt_expect_close = 0;
+
+			/* scan to see whether or not we got the magic
+			   character */
+			for (i = 0; i != count; i++) {
+				char c;
+				if (get_user(c, data + i))
+					return -EFAULT;
+				if (c == 'V')
+					wm8350_wdt_expect_close = 42;
+			}
+		}
+	}
+	return count;
+}
+
+static struct watchdog_info ident = {
+	.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING | WDIOF_MAGICCLOSE,
+	.identity = "WM8350 Watchdog",
+};
+
+static long wm8350_wdt_ioctl(struct file *file, unsigned int cmd,
+			     unsigned long arg)
+{
+	struct wm8350 *wm8350 = get_wm8350();
+	int ret = -ENOTTY, time, i;
+	void __user *argp = (void __user *)arg;
+	int __user *p = argp;
+	u16 reg;
+
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		ret = copy_to_user(argp, &ident, sizeof(ident)) ? -EFAULT : 0;
+		break;
+
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		ret = put_user(0, p);
+		break;
+
+	case WDIOC_SETOPTIONS:
+	{
+		int options;
+
+		if (get_user(options, p))
+			return -EFAULT;
+
+		ret = -EINVAL;
+
+		/* Setting both simultaneously means at least one must fail */
+		if (options == WDIOS_DISABLECARD)
+			ret = wm8350_wdt_start(wm8350);
+
+		if (options == WDIOS_ENABLECARD)
+			ret = wm8350_wdt_stop(wm8350);
+		break;
+	}
+
+	case WDIOC_KEEPALIVE:
+		ret = wm8350_wdt_kick(wm8350);
+		break;
+
+	case WDIOC_SETTIMEOUT:
+		ret = get_user(time, p);
+		if (ret)
+			break;
+
+		if (time == 0) {
+			if (nowayout)
+				ret = -EINVAL;
+			else
+				wm8350_wdt_stop(wm8350);
+			break;
+		}
+
+		for (i = 0; i < ARRAY_SIZE(wm8350_wdt_cfgs); i++)
+			if (wm8350_wdt_cfgs[i].time == time)
+				break;
+		if (i == ARRAY_SIZE(wm8350_wdt_cfgs))
+			ret = -EINVAL;
+		else
+			ret = wm8350_wdt_set_timeout(wm8350,
+						     wm8350_wdt_cfgs[i].val);
+		break;
+
+	case WDIOC_GETTIMEOUT:
+		reg = wm8350_reg_read(wm8350, WM8350_SYSTEM_CONTROL_2);
+		reg &= WM8350_WDOG_TO_MASK;
+		for (i = 0; i < ARRAY_SIZE(wm8350_wdt_cfgs); i++)
+			if (wm8350_wdt_cfgs[i].val == reg)
+				break;
+		if (i == ARRAY_SIZE(wm8350_wdt_cfgs)) {
+			dev_warn(wm8350->dev,
+				 "Unknown watchdog configuration: %x\n", reg);
+			ret = -EINVAL;
+		} else
+			ret = put_user(wm8350_wdt_cfgs[i].time, p);
+
+	}
+
+	return ret;
+}
+
+static const struct file_operations wm8350_wdt_fops = {
+	.owner = THIS_MODULE,
+	.llseek = no_llseek,
+	.write = wm8350_wdt_write,
+	.unlocked_ioctl = wm8350_wdt_ioctl,
+	.open = wm8350_wdt_open,
+	.release = wm8350_wdt_release,
+};
+
+static struct miscdevice wm8350_wdt_miscdev = {
+	.minor = WATCHDOG_MINOR,
+	.name = "watchdog",
+	.fops = &wm8350_wdt_fops,
+};
+
+static int wm8350_wdt_probe(struct platform_device *pdev)
+{
+	struct wm8350 *wm8350 = platform_get_drvdata(pdev);
+
+	if (!wm8350) {
+		dev_err(wm8350->dev, "No driver data supplied\n");
+		return -ENODEV;
+	}
+
+	/* Default to 4s timeout */
+	wm8350_wdt_set_timeout(wm8350, 0x05);
+
+	wm8350_wdt_miscdev.parent = &pdev->dev;
+
+	return misc_register(&wm8350_wdt_miscdev);
+}
+
+static int __exit wm8350_wdt_remove(struct platform_device *pdev)
+{
+	misc_deregister(&wm8350_wdt_miscdev);
+
+	return 0;
+}
+
+static struct platform_driver wm8350_wdt_driver = {
+	.probe = wm8350_wdt_probe,
+	.remove = wm8350_wdt_remove,
+	.driver = {
+		.name = "wm8350-wdt",
+	},
+};
+
+static int __init wm8350_wdt_init(void)
+{
+	return platform_driver_register(&wm8350_wdt_driver);
+}
+module_init(wm8350_wdt_init);
+
+static void __exit wm8350_wdt_exit(void)
+{
+	platform_driver_unregister(&wm8350_wdt_driver);
+}
+module_exit(wm8350_wdt_exit);
+
+MODULE_AUTHOR("Mark Brown");
+MODULE_DESCRIPTION("WM8350 Watchdog");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:wm8350-wdt");
