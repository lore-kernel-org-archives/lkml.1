Return-Path: <linux-kernel-owner+w=401wt.eu-S965570AbXEAHoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965570AbXEAHoi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 03:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965573AbXEAHoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 03:44:38 -0400
Received: from outmx013.isp.belgacom.be ([195.238.5.64]:55257 "EHLO
	outmx013.isp.belgacom.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965570AbXEAHoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 03:44:34 -0400
Date: Tue, 1 May 2007 09:45:20 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Adrian Bunk <bunk@stusta.de>, Alexey Dobriyan <adobriyan@gmail.com>,
       Vlad Drukker <vlad@storewiz.com>
Subject: [WATCHDOG] patches for v2.6.22-rc1
Message-ID: <20070501074520.GA2953@infomag.infomag.iguana.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
or if master.kernel.org hasn't synced up yet:
	master.kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git

This will update the following files:

 Documentation/feature-removal-schedule.txt |    8 
 MAINTAINERS                                |    6 
 drivers/char/watchdog/Kconfig              |   22 -
 drivers/char/watchdog/Makefile             |    1 
 drivers/char/watchdog/cpu5wdt.c            |   14 
 drivers/char/watchdog/eurotechwdt.c        |   22 -
 drivers/char/watchdog/i8xx_tco.c           |  571 -----------------------------
 drivers/char/watchdog/i8xx_tco.h           |   42 --
 drivers/char/watchdog/ibmasr.c             |   11 
 drivers/char/watchdog/machzwd.c            |   18 
 drivers/char/watchdog/sbc8360.c            |   28 -
 drivers/char/watchdog/w83627hf_wdt.c       |   23 -
 12 files changed, 64 insertions(+), 702 deletions(-)

with these Changes:

Author: Adrian Bunk <bunk@stusta.de>
Date:   Fri Apr 6 12:22:17 2007 +0200

    [WATCHDOG] the scheduled removal of the i8xx_tco watchdog driver
    
    This patch contains the scheduled removal of the i8xx_tco watchdog
    driver.
    
    Signed-off-by: Adrian Bunk <bunk@stusta.de>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Merge: fb8f7ba... dc87c39...
Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Tue May 1 06:53:01 2007 +0000

    Merge /pub/scm/linux/kernel/git/torvalds/linux-2.6

Author: Alexey Dobriyan <adobriyan@gmail.com>
Date:   Sat Mar 24 15:58:12 2007 +0300

    [WATCHDOG] Semi-typical watchdog bug re early misc_register()
    
    It seems that some watchdog drivers are doing following mistake:
    
    	rv = misc_register();
    	if (rv < 0)
    		return rv;
    	rv = request_region();
    	if (rv < 0) {
    		misc_deregister();
    		return rv;
    	}
    
    But, right after misc_register() returns, misc device can be opened and
    ioctls interacting with hardware issued, and driver can do outb() to
    port it doesn't own yet, because request_region() is still pending.
    
    Here is my patch, compile-tested only.
    
    Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Vlad Drukker <vlad@storewiz.com>
Date:   Sun Mar 25 17:34:39 2007 +0200

    [WATCHDOG] add support for the w83627thf chipset.
    
    Added support for W83627THF, watchdog chip.
    
    Signed-off-by: Vlad Drukker <vlad@storewiz.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 5c88ba1..d6d183f 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -288,14 +288,6 @@ Who:	Richard Purdie <rpurdie@rpsys.net>
 
 ---------------------------
 
-What:	i8xx_tco watchdog driver
-When:	in 2.6.22
-Why:	the i8xx_tco watchdog driver has been replaced by the iTCO_wdt
-	watchdog driver.
-Who:	Wim Van Sebroeck <wim@iguana.be>
-
----------------------------
-
 What:	Multipath cached routing support in ipv4
 When:	in 2.6.23
 Why:	Code was merged, then submitter immediately disappeared leaving
diff --git a/MAINTAINERS b/MAINTAINERS
index af1c792..6fd435d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1644,12 +1644,6 @@ P:	H. Peter Anvin
 M:	hpa@zytor.com
 S:	Maintained
 
-i810 TCO TIMER WATCHDOG
-P:	Nils Faerber
-M:	nils@kernelconcepts.de
-W:	http://www.kernelconcepts.de/
-S:	Maintained
-
 IA64 (Itanium) PLATFORM
 P:	Tony Luck
 M:	tony.luck@intel.com
diff --git a/drivers/char/watchdog/Kconfig b/drivers/char/watchdog/Kconfig
index 60198a7..684812f 100644
--- a/drivers/char/watchdog/Kconfig
+++ b/drivers/char/watchdog/Kconfig
@@ -298,28 +298,6 @@ config I6300ESB_WDT
 	  To compile this driver as a module, choose M here: the
 	  module will be called i6300esb.
 
-config I8XX_TCO
-	tristate "Intel i8xx TCO Timer/Watchdog"
-	depends on WATCHDOG && (X86 || IA64) && PCI
-	default n
-	---help---
-	  Hardware driver for the TCO timer built into the Intel 82801
-	  I/O Controller Hub family.  The TCO (Total Cost of Ownership)
-	  timer is a watchdog timer that will reboot the machine after
-	  its second expiration. The expiration time can be configured
-	  with the "heartbeat" parameter.
-
-	  On some motherboards the driver may fail to reset the chipset's
-	  NO_REBOOT flag which prevents the watchdog from rebooting the
-	  machine. If this is the case you will get a kernel message like
-	  "failed to reset NO_REBOOT flag, reboot disabled by hardware".
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called i8xx_tco.
-
-	  Note: This driver will be removed in the near future. Please
-	  use the Intel TCO Timer/Watchdog driver.
-
 config ITCO_WDT
 	tristate "Intel TCO Timer/Watchdog"
 	depends on WATCHDOG && (X86 || IA64) && PCI
diff --git a/drivers/char/watchdog/Makefile b/drivers/char/watchdog/Makefile
index 2cd8ff8..387eb80 100644
--- a/drivers/char/watchdog/Makefile
+++ b/drivers/char/watchdog/Makefile
@@ -46,7 +46,6 @@ obj-$(CONFIG_IB700_WDT) += ib700wdt.o
 obj-$(CONFIG_IBMASR) += ibmasr.o
 obj-$(CONFIG_WAFER_WDT) += wafer5823wdt.o
 obj-$(CONFIG_I6300ESB_WDT) += i6300esb.o
-obj-$(CONFIG_I8XX_TCO) += i8xx_tco.o
 obj-$(CONFIG_ITCO_WDT) += iTCO_wdt.o iTCO_vendor_support.o
 obj-$(CONFIG_SC1200_WDT) += sc1200wdt.o
 obj-$(CONFIG_SCx200_WDT) += scx200_wdt.o
diff --git a/drivers/char/watchdog/cpu5wdt.c b/drivers/char/watchdog/cpu5wdt.c
index bcd7e36..d0d45a8 100644
--- a/drivers/char/watchdog/cpu5wdt.c
+++ b/drivers/char/watchdog/cpu5wdt.c
@@ -220,17 +220,17 @@ static int __devinit cpu5wdt_init(void)
 	if ( verbose )
 		printk(KERN_DEBUG PFX "port=0x%x, verbose=%i\n", port, verbose);
 
-	if ( (err = misc_register(&cpu5wdt_misc)) < 0 ) {
-		printk(KERN_ERR PFX "misc_register failed\n");
-		goto no_misc;
-	}
-
 	if ( !request_region(port, CPU5WDT_EXTENT, PFX) ) {
 		printk(KERN_ERR PFX "request_region failed\n");
 		err = -EBUSY;
 		goto no_port;
 	}
 
+	if ( (err = misc_register(&cpu5wdt_misc)) < 0 ) {
+		printk(KERN_ERR PFX "misc_register failed\n");
+		goto no_misc;
+	}
+
 	/* watchdog reboot? */
 	val = inb(port + CPU5WDT_STATUS_REG);
 	val = (val >> 2) & 1;
@@ -250,9 +250,9 @@ static int __devinit cpu5wdt_init(void)
 
 	return 0;
 
-no_port:
-	misc_deregister(&cpu5wdt_misc);
 no_misc:
+	release_region(port, CPU5WDT_EXTENT);
+no_port:
 	return err;
 }
 
diff --git a/drivers/char/watchdog/eurotechwdt.c b/drivers/char/watchdog/eurotechwdt.c
index f70387f..b070324 100644
--- a/drivers/char/watchdog/eurotechwdt.c
+++ b/drivers/char/watchdog/eurotechwdt.c
@@ -413,17 +413,10 @@ static int __init eurwdt_init(void)
 {
 	int ret;
 
-	ret = misc_register(&eurwdt_miscdev);
-	if (ret) {
-		printk(KERN_ERR "eurwdt: can't misc_register on minor=%d\n",
-		WATCHDOG_MINOR);
-		goto out;
-	}
-
 	ret = request_irq(irq, eurwdt_interrupt, IRQF_DISABLED, "eurwdt", NULL);
 	if(ret) {
 		printk(KERN_ERR "eurwdt: IRQ %d is not free.\n", irq);
-		goto outmisc;
+		goto out;
 	}
 
 	if (!request_region(io, 2, "eurwdt")) {
@@ -438,6 +431,13 @@ static int __init eurwdt_init(void)
 		goto outreg;
 	}
 
+	ret = misc_register(&eurwdt_miscdev);
+	if (ret) {
+		printk(KERN_ERR "eurwdt: can't misc_register on minor=%d\n",
+		WATCHDOG_MINOR);
+		goto outreboot;
+	}
+
 	eurwdt_unlock_chip();
 
 	ret = 0;
@@ -448,14 +448,14 @@ static int __init eurwdt_init(void)
 out:
 	return ret;
 
+outreboot:
+	unregister_reboot_notifier(&eurwdt_notifier);
+
 outreg:
 	release_region(io, 2);
 
 outirq:
 	free_irq(irq, NULL);
-
-outmisc:
-	misc_deregister(&eurwdt_miscdev);
 	goto out;
 }
 
diff --git a/drivers/char/watchdog/i8xx_tco.c b/drivers/char/watchdog/i8xx_tco.c
deleted file mode 100644
index a62ef48..0000000
--- a/drivers/char/watchdog/i8xx_tco.c
+++ /dev/null
@@ -1,571 +0,0 @@
-/*
- *	i8xx_tco:	TCO timer driver for i8xx chipsets
- *
- *	(c) Copyright 2000 kernel concepts <nils@kernelconcepts.de>, All Rights Reserved.
- *				http://www.kernelconcepts.de
- *
- *	This program is free software; you can redistribute it and/or
- *	modify it under the terms of the GNU General Public License
- *	as published by the Free Software Foundation; either version
- *	2 of the License, or (at your option) any later version.
- *
- *	Neither kernel concepts nor Nils Faerber admit liability nor provide
- *	warranty for any of this software. This material is provided
- *	"AS-IS" and at no charge.
- *
- *	(c) Copyright 2000	kernel concepts <nils@kernelconcepts.de>
- *				developed for
- *                              Jentro AG, Haar/Munich (Germany)
- *
- *	TCO timer driver for i8xx chipsets
- *	based on softdog.c by Alan Cox <alan@redhat.com>
- *
- *	The TCO timer is implemented in the following I/O controller hubs:
- *	(See the intel documentation on http://developer.intel.com.)
- *	82801AA  (ICH)    : document number 290655-003, 290677-014,
- *	82801AB  (ICHO)   : document number 290655-003, 290677-014,
- *	82801BA  (ICH2)   : document number 290687-002, 298242-027,
- *	82801BAM (ICH2-M) : document number 290687-002, 298242-027,
- *	82801CA  (ICH3-S) : document number 290733-003, 290739-013,
- *	82801CAM (ICH3-M) : document number 290716-001, 290718-007,
- *	82801DB  (ICH4)   : document number 290744-001, 290745-020,
- *	82801DBM (ICH4-M) : document number 252337-001, 252663-005,
- *	82801E   (C-ICH)  : document number 273599-001, 273645-002,
- *	82801EB  (ICH5)   : document number 252516-001, 252517-003,
- *	82801ER  (ICH5R)  : document number 252516-001, 252517-003,
- *
- *  20000710 Nils Faerber
- *	Initial Version 0.01
- *  20000728 Nils Faerber
- *	0.02 Fix for SMI_EN->TCO_EN bit, some cleanups
- *  20011214 Matt Domsch <Matt_Domsch@dell.com>
- *	0.03 Added nowayout module option to override CONFIG_WATCHDOG_NOWAYOUT
- *	     Didn't add timeout option as i810_margin already exists.
- *  20020224 Joel Becker, Wim Van Sebroeck
- *	0.04 Support for 82801CA(M) chipset, timer margin needs to be > 3,
- *	     add support for WDIOC_SETTIMEOUT and WDIOC_GETTIMEOUT.
- *  20020412 Rob Radez <rob@osinvestor.com>, Wim Van Sebroeck
- *	0.05 Fix possible timer_alive race, add expect close support,
- *	     clean up ioctls (WDIOC_GETSTATUS, WDIOC_GETBOOTSTATUS and
- *	     WDIOC_SETOPTIONS), made i810tco_getdevice __init,
- *	     removed boot_status, removed tco_timer_read,
- *	     added support for 82801DB and 82801E chipset,
- *	     added support for 82801EB and 8280ER chipset,
- *	     general cleanup.
- *  20030921 Wim Van Sebroeck <wim@iguana.be>
- *	0.06 change i810_margin to heartbeat, use module_param,
- *	     added notify system support, renamed module to i8xx_tco.
- *  20050128 Wim Van Sebroeck <wim@iguana.be>
- *	0.07 Added support for the ICH4-M, ICH6, ICH6R, ICH6-M, ICH6W and ICH6RW
- *	     chipsets. Also added support for the "undocumented" ICH7 chipset.
- *  20050807 Wim Van Sebroeck <wim@iguana.be>
- *	0.08 Make sure that the watchdog is only "armed" when started.
- *	     (Kernel Bug 4251)
- *  20060416 Wim Van Sebroeck <wim@iguana.be>
- *	0.09 Remove support for the ICH6, ICH6R, ICH6-M, ICH6W and ICH6RW and
- *	     ICH7 chipsets. (See Kernel Bug 6031 - other code will support these
- *	     chipsets)
- */
-
-/*
- *	Includes, defines, variables, module parameters, ...
- */
-
-#include <linux/module.h>
-#include <linux/moduleparam.h>
-#include <linux/types.h>
-#include <linux/miscdevice.h>
-#include <linux/watchdog.h>
-#include <linux/notifier.h>
-#include <linux/reboot.h>
-#include <linux/init.h>
-#include <linux/fs.h>
-#include <linux/pci.h>
-#include <linux/ioport.h>
-
-#include <asm/uaccess.h>
-#include <asm/io.h>
-
-#include "i8xx_tco.h"
-
-/* Module and version information */
-#define TCO_VERSION "0.09"
-#define TCO_MODULE_NAME "i8xx TCO timer"
-#define TCO_DRIVER_NAME   TCO_MODULE_NAME ", v" TCO_VERSION
-#define PFX TCO_MODULE_NAME ": "
-
-/* internal variables */
-static unsigned int ACPIBASE;
-static spinlock_t tco_lock;	/* Guards the hardware */
-static unsigned long timer_alive;
-static char tco_expect_close;
-static struct pci_dev *i8xx_tco_pci;
-
-/* module parameters */
-#define WATCHDOG_HEARTBEAT 30	/* 30 sec default heartbeat (2<heartbeat<39) */
-static int heartbeat = WATCHDOG_HEARTBEAT;  /* in seconds */
-module_param(heartbeat, int, 0);
-MODULE_PARM_DESC(heartbeat, "Watchdog heartbeat in seconds. (2<heartbeat<39, default=" __MODULE_STRING(WATCHDOG_HEARTBEAT) ")");
-
-static int nowayout = WATCHDOG_NOWAYOUT;
-module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
-
-/*
- * Some TCO specific functions
- */
-
-static inline unsigned char seconds_to_ticks(int seconds)
-{
-	/* the internal timer is stored as ticks which decrement
-	 * every 0.6 seconds */
-	return (seconds * 10) / 6;
-}
-
-static int tco_timer_start (void)
-{
-	unsigned char val;
-
-	spin_lock(&tco_lock);
-
-	/* disable chipset's NO_REBOOT bit */
-	pci_read_config_byte (i8xx_tco_pci, 0xd4, &val);
-	val &= 0xfd;
-	pci_write_config_byte (i8xx_tco_pci, 0xd4, val);
-
-	/* Bit 11: TCO Timer Halt -> 0 = The TCO timer is enabled to count */
-	val = inb (TCO1_CNT + 1);
-	val &= 0xf7;
-	outb (val, TCO1_CNT + 1);
-	val = inb (TCO1_CNT + 1);
-
-	spin_unlock(&tco_lock);
-
-	if (val & 0x08)
-		return -1;
-	return 0;
-}
-
-static int tco_timer_stop (void)
-{
-	unsigned char val, val1;
-
-	spin_lock(&tco_lock);
-	/* Bit 11: TCO Timer Halt -> 1 = The TCO timer is disabled */
-	val = inb (TCO1_CNT + 1);
-	val |= 0x08;
-	outb (val, TCO1_CNT + 1);
-	val = inb (TCO1_CNT + 1);
-
-	/* Set the NO_REBOOT bit to prevent later reboots, just for sure */
-	pci_read_config_byte (i8xx_tco_pci, 0xd4, &val1);
-	val1 |= 0x02;
-	pci_write_config_byte (i8xx_tco_pci, 0xd4, val1);
-
-	spin_unlock(&tco_lock);
-
-	if ((val & 0x08) == 0)
-		return -1;
-	return 0;
-}
-
-static int tco_timer_keepalive (void)
-{
-	spin_lock(&tco_lock);
-	/* Reload the timer by writing to the TCO Timer Reload register */
-	outb (0x01, TCO1_RLD);
-	spin_unlock(&tco_lock);
-	return 0;
-}
-
-static int tco_timer_set_heartbeat (int t)
-{
-	unsigned char val;
-	unsigned char tmrval;
-
-	tmrval = seconds_to_ticks(t);
-	/* from the specs: */
-	/* "Values of 0h-3h are ignored and should not be attempted" */
-	if (tmrval > 0x3f || tmrval < 0x04)
-		return -EINVAL;
-
-	/* Write new heartbeat to watchdog */
-	spin_lock(&tco_lock);
-	val = inb (TCO1_TMR);
-	val &= 0xc0;
-	val |= tmrval;
-	outb (val, TCO1_TMR);
-	val = inb (TCO1_TMR);
-	spin_unlock(&tco_lock);
-
-	if ((val & 0x3f) != tmrval)
-		return -EINVAL;
-
-	heartbeat = t;
-	return 0;
-}
-
-static int tco_timer_get_timeleft (int *time_left)
-{
-	unsigned char val;
-
-	spin_lock(&tco_lock);
-
-	/* read the TCO Timer */
-	val = inb (TCO1_RLD);
-	val &= 0x3f;
-
-	spin_unlock(&tco_lock);
-
-	*time_left = (int)((val * 6) / 10);
-
-	return 0;
-}
-
-/*
- *	/dev/watchdog handling
- */
-
-static int i8xx_tco_open (struct inode *inode, struct file *file)
-{
-	/* /dev/watchdog can only be opened once */
-	if (test_and_set_bit(0, &timer_alive))
-		return -EBUSY;
-
-	/*
-	 *      Reload and activate timer
-	 */
-	tco_timer_keepalive ();
-	tco_timer_start ();
-	return nonseekable_open(inode, file);
-}
-
-static int i8xx_tco_release (struct inode *inode, struct file *file)
-{
-	/*
-	 *      Shut off the timer.
-	 */
-	if (tco_expect_close == 42) {
-		tco_timer_stop ();
-	} else {
-		printk(KERN_CRIT PFX "Unexpected close, not stopping watchdog!\n");
-		tco_timer_keepalive ();
-	}
-	clear_bit(0, &timer_alive);
-	tco_expect_close = 0;
-	return 0;
-}
-
-static ssize_t i8xx_tco_write (struct file *file, const char __user *data,
-			      size_t len, loff_t * ppos)
-{
-	/* See if we got the magic character 'V' and reload the timer */
-	if (len) {
-		if (!nowayout) {
-			size_t i;
-
-			/* note: just in case someone wrote the magic character
-			 * five months ago... */
-			tco_expect_close = 0;
-
-			/* scan to see whether or not we got the magic character */
-			for (i = 0; i != len; i++) {
-				char c;
-				if(get_user(c, data+i))
-					return -EFAULT;
-				if (c == 'V')
-					tco_expect_close = 42;
-			}
-		}
-
-		/* someone wrote to us, we should reload the timer */
-		tco_timer_keepalive ();
-	}
-	return len;
-}
-
-static int i8xx_tco_ioctl (struct inode *inode, struct file *file,
-			  unsigned int cmd, unsigned long arg)
-{
-	int new_options, retval = -EINVAL;
-	int new_heartbeat;
-	int time_left;
-	void __user *argp = (void __user *)arg;
-	int __user *p = argp;
-	static struct watchdog_info ident = {
-		.options =		WDIOF_SETTIMEOUT |
-					WDIOF_KEEPALIVEPING |
-					WDIOF_MAGICCLOSE,
-		.firmware_version =	0,
-		.identity =		TCO_MODULE_NAME,
-	};
-
-	switch (cmd) {
-		case WDIOC_GETSUPPORT:
-			return copy_to_user(argp, &ident,
-				sizeof (ident)) ? -EFAULT : 0;
-
-		case WDIOC_GETSTATUS:
-		case WDIOC_GETBOOTSTATUS:
-			return put_user (0, p);
-
-		case WDIOC_KEEPALIVE:
-			tco_timer_keepalive ();
-			return 0;
-
-		case WDIOC_SETOPTIONS:
-		{
-			if (get_user (new_options, p))
-				return -EFAULT;
-
-			if (new_options & WDIOS_DISABLECARD) {
-				tco_timer_stop ();
-				retval = 0;
-			}
-
-			if (new_options & WDIOS_ENABLECARD) {
-				tco_timer_keepalive ();
-				tco_timer_start ();
-				retval = 0;
-			}
-
-			return retval;
-		}
-
-		case WDIOC_SETTIMEOUT:
-		{
-			if (get_user(new_heartbeat, p))
-				return -EFAULT;
-
-			if (tco_timer_set_heartbeat(new_heartbeat))
-				return -EINVAL;
-
-			tco_timer_keepalive ();
-			/* Fall */
-		}
-
-		case WDIOC_GETTIMEOUT:
-			return put_user(heartbeat, p);
-
-		case WDIOC_GETTIMELEFT:
-		{
-			if (tco_timer_get_timeleft(&time_left))
-				return -EINVAL;
-
-			return put_user(time_left, p);
-		}
-
-		default:
-			return -ENOTTY;
-	}
-}
-
-/*
- *	Notify system
- */
-
-static int i8xx_tco_notify_sys (struct notifier_block *this, unsigned long code, void *unused)
-{
-	if (code==SYS_DOWN || code==SYS_HALT) {
-		/* Turn the WDT off */
-		tco_timer_stop ();
-	}
-
-	return NOTIFY_DONE;
-}
-
-/*
- *	Kernel Interfaces
- */
-
-static const struct file_operations i8xx_tco_fops = {
-	.owner =	THIS_MODULE,
-	.llseek =	no_llseek,
-	.write =	i8xx_tco_write,
-	.ioctl =	i8xx_tco_ioctl,
-	.open =		i8xx_tco_open,
-	.release =	i8xx_tco_release,
-};
-
-static struct miscdevice i8xx_tco_miscdev = {
-	.minor =	WATCHDOG_MINOR,
-	.name =		"watchdog",
-	.fops =		&i8xx_tco_fops,
-};
-
-static struct notifier_block i8xx_tco_notifier = {
-	.notifier_call =	i8xx_tco_notify_sys,
-};
-
-/*
- * Data for PCI driver interface
- *
- * This data only exists for exporting the supported
- * PCI ids via MODULE_DEVICE_TABLE.  We do not actually
- * register a pci_driver, because someone else might one day
- * want to register another driver on the same PCI id.
- */
-static struct pci_device_id i8xx_tco_pci_tbl[] = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801AA_0) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801AB_0) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801BA_0) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801BA_10) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801CA_0) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801CA_12) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801DB_0) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801DB_12) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801E_0) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801EB_0) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ESB_1) },
-	{ },			/* End of list */
-};
-MODULE_DEVICE_TABLE (pci, i8xx_tco_pci_tbl);
-
-/*
- *	Init & exit routines
- */
-
-static unsigned char __init i8xx_tco_getdevice (void)
-{
-	struct pci_dev *dev = NULL;
-	u8 val1, val2;
-	u16 badr;
-	/*
-	 *      Find the PCI device
-	 */
-
-	for_each_pci_dev(dev)
-		if (pci_match_id(i8xx_tco_pci_tbl, dev)) {
-			i8xx_tco_pci = dev;
-			break;
-		}
-
-	if (i8xx_tco_pci) {
-		/*
-		 *      Find the ACPI base I/O address which is the base
-		 *      for the TCO registers (TCOBASE=ACPIBASE + 0x60)
-		 *      ACPIBASE is bits [15:7] from 0x40-0x43
-		 */
-		pci_read_config_byte (i8xx_tco_pci, 0x40, &val1);
-		pci_read_config_byte (i8xx_tco_pci, 0x41, &val2);
-		badr = ((val2 << 1) | (val1 >> 7)) << 7;
-		ACPIBASE = badr;
-		/* Something's wrong here, ACPIBASE has to be set */
-		if (badr == 0x0001 || badr == 0x0000) {
-			printk (KERN_ERR PFX "failed to get TCOBASE address\n");
-			pci_dev_put(i8xx_tco_pci);
-			return 0;
-		}
-
-		/* Check chipset's NO_REBOOT bit */
-		pci_read_config_byte (i8xx_tco_pci, 0xd4, &val1);
-		if (val1 & 0x02) {
-			val1 &= 0xfd;
-			pci_write_config_byte (i8xx_tco_pci, 0xd4, val1);
-			pci_read_config_byte (i8xx_tco_pci, 0xd4, &val1);
-			if (val1 & 0x02) {
-				printk (KERN_ERR PFX "failed to reset NO_REBOOT flag, reboot disabled by hardware\n");
-				pci_dev_put(i8xx_tco_pci);
-				return 0;	/* Cannot reset NO_REBOOT bit */
-			}
-		}
-		/* Disable reboots untill the watchdog starts */
-		val1 |= 0x02;
-		pci_write_config_byte (i8xx_tco_pci, 0xd4, val1);
-
-		/* Set the TCO_EN bit in SMI_EN register */
-		if (!request_region (SMI_EN + 1, 1, "i8xx TCO")) {
-			printk (KERN_ERR PFX "I/O address 0x%04x already in use\n",
-				SMI_EN + 1);
-			pci_dev_put(i8xx_tco_pci);
-			return 0;
-		}
-		val1 = inb (SMI_EN + 1);
-		val1 &= 0xdf;
-		outb (val1, SMI_EN + 1);
-		release_region (SMI_EN + 1, 1);
-		return 1;
-	}
-	return 0;
-}
-
-static int __init watchdog_init (void)
-{
-	int ret;
-
-	spin_lock_init(&tco_lock);
-
-	/* Check whether or not the hardware watchdog is there */
-	if (!i8xx_tco_getdevice () || i8xx_tco_pci == NULL)
-		return -ENODEV;
-
-	if (!request_region (TCOBASE, 0x10, "i8xx TCO")) {
-		printk (KERN_ERR PFX "I/O address 0x%04x already in use\n",
-			TCOBASE);
-		ret = -EIO;
-		goto out;
-	}
-
-	/* Clear out the (probably old) status */
-	outb (0, TCO1_STS);
-	outb (3, TCO2_STS);
-
-	/* Check that the heartbeat value is within it's range ; if not reset to the default */
-	if (tco_timer_set_heartbeat (heartbeat)) {
-		heartbeat = WATCHDOG_HEARTBEAT;
-		tco_timer_set_heartbeat (heartbeat);
-		printk(KERN_INFO PFX "heartbeat value must be 2<heartbeat<39, using %d\n",
-			heartbeat);
-	}
-
-	ret = register_reboot_notifier(&i8xx_tco_notifier);
-	if (ret != 0) {
-		printk(KERN_ERR PFX "cannot register reboot notifier (err=%d)\n",
-			ret);
-		goto unreg_region;
-	}
-
-	ret = misc_register(&i8xx_tco_miscdev);
-	if (ret != 0) {
-		printk(KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
-			WATCHDOG_MINOR, ret);
-		goto unreg_notifier;
-	}
-
-	tco_timer_stop ();
-
-	printk (KERN_INFO PFX "initialized (0x%04x). heartbeat=%d sec (nowayout=%d)\n",
-		TCOBASE, heartbeat, nowayout);
-
-	return 0;
-
-unreg_notifier:
-	unregister_reboot_notifier(&i8xx_tco_notifier);
-unreg_region:
-	release_region (TCOBASE, 0x10);
-out:
-	pci_dev_put(i8xx_tco_pci);
-	return ret;
-}
-
-static void __exit watchdog_cleanup (void)
-{
-	/* Stop the timer before we leave */
-	if (!nowayout)
-		tco_timer_stop ();
-
-	/* Deregister */
-	misc_deregister (&i8xx_tco_miscdev);
-	unregister_reboot_notifier(&i8xx_tco_notifier);
-	release_region (TCOBASE, 0x10);
-
-	pci_dev_put(i8xx_tco_pci);
-}
-
-module_init(watchdog_init);
-module_exit(watchdog_cleanup);
-
-MODULE_AUTHOR("Nils Faerber");
-MODULE_DESCRIPTION("TCO timer driver for i8xx chipsets");
-MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
diff --git a/drivers/char/watchdog/i8xx_tco.h b/drivers/char/watchdog/i8xx_tco.h
deleted file mode 100644
index cc14eb8..0000000
--- a/drivers/char/watchdog/i8xx_tco.h
+++ /dev/null
@@ -1,42 +0,0 @@
-/*
- *	i8xx_tco:	TCO timer driver for i8xx chipsets
- *
- *	(c) Copyright 2000 kernel concepts <nils@kernelconcepts.de>, All Rights Reserved.
- *				http://www.kernelconcepts.de
- *
- *	This program is free software; you can redistribute it and/or
- *	modify it under the terms of the GNU General Public License
- *	as published by the Free Software Foundation; either version
- *	2 of the License, or (at your option) any later version.
- *
- *	Neither kernel concepts nor Nils Faerber admit liability nor provide
- *	warranty for any of this software. This material is provided
- *	"AS-IS" and at no charge.
- *
- *	(c) Copyright 2000	kernel concepts <nils@kernelconcepts.de>
- *				developed for
- *                              Jentro AG, Haar/Munich (Germany)
- *
- *	TCO timer driver for i8xx chipsets
- *	based on softdog.c by Alan Cox <alan@redhat.com>
- *
- *	For history and the complete list of supported I/O Controller Hub's
- *	see i8xx_tco.c
- */
-
-
-/*
- * Some address definitions for the TCO
- */
-
-#define	TCOBASE		ACPIBASE + 0x60	/* TCO base address		*/
-#define TCO1_RLD	TCOBASE + 0x00	/* TCO Timer Reload and Current Value */
-#define TCO1_TMR	TCOBASE + 0x01	/* TCO Timer Initial Value	*/
-#define	TCO1_DAT_IN	TCOBASE + 0x02	/* TCO Data In Register		*/
-#define	TCO1_DAT_OUT	TCOBASE + 0x03	/* TCO Data Out Register	*/
-#define	TCO1_STS	TCOBASE + 0x04	/* TCO1 Status Register		*/
-#define	TCO2_STS	TCOBASE + 0x06	/* TCO2 Status Register		*/
-#define TCO1_CNT	TCOBASE + 0x08	/* TCO1 Control Register	*/
-#define TCO2_CNT	TCOBASE + 0x0a	/* TCO2 Control Register	*/
-
-#define	SMI_EN		ACPIBASE + 0x30	/* SMI Control and Enable Register */
diff --git a/drivers/char/watchdog/ibmasr.c b/drivers/char/watchdog/ibmasr.c
index 8195f50..94155f6 100644
--- a/drivers/char/watchdog/ibmasr.c
+++ b/drivers/char/watchdog/ibmasr.c
@@ -367,18 +367,17 @@ static int __init ibmasr_init(void)
 	if (!asr_type)
 		return -ENODEV;
 
+	rc = asr_get_base_address();
+	if (rc)
+		return rc;
+
 	rc = misc_register(&asr_miscdev);
 	if (rc < 0) {
+		release_region(asr_base, asr_length);
 		printk(KERN_ERR PFX "failed to register misc device\n");
 		return rc;
 	}
 
-	rc = asr_get_base_address();
-	if (rc) {
-		misc_deregister(&asr_miscdev);
-		return rc;
-	}
-
 	return 0;
 }
 
diff --git a/drivers/char/watchdog/machzwd.c b/drivers/char/watchdog/machzwd.c
index 76c7fa3..a0d2716 100644
--- a/drivers/char/watchdog/machzwd.c
+++ b/drivers/char/watchdog/machzwd.c
@@ -440,13 +440,6 @@ static int __init zf_init(void)
 	spin_lock_init(&zf_lock);
 	spin_lock_init(&zf_port_lock);
 
-	ret = misc_register(&zf_miscdev);
-	if (ret){
-		printk(KERN_ERR "can't misc_register on minor=%d\n",
-							WATCHDOG_MINOR);
-		goto out;
-	}
-
 	if(!request_region(ZF_IOBASE, 3, "MachZ ZFL WDT")){
 		printk(KERN_ERR "cannot reserve I/O ports at %d\n",
 							ZF_IOBASE);
@@ -461,16 +454,23 @@ static int __init zf_init(void)
 		goto no_reboot;
 	}
 
+	ret = misc_register(&zf_miscdev);
+	if (ret){
+		printk(KERN_ERR "can't misc_register on minor=%d\n",
+							WATCHDOG_MINOR);
+		goto no_misc;
+	}
+
 	zf_set_status(0);
 	zf_set_control(0);
 
 	return 0;
 
+no_misc:
+	unregister_reboot_notifier(&zf_notifier);
 no_reboot:
 	release_region(ZF_IOBASE, 3);
 no_region:
-	misc_deregister(&zf_miscdev);
-out:
 	return ret;
 }
 
diff --git a/drivers/char/watchdog/sbc8360.c b/drivers/char/watchdog/sbc8360.c
index 67ae426..285d852 100644
--- a/drivers/char/watchdog/sbc8360.c
+++ b/drivers/char/watchdog/sbc8360.c
@@ -333,18 +333,17 @@ static int __init sbc8360_init(void)
 	int res;
 	unsigned long int mseconds = 60000;
 
-	spin_lock_init(&sbc8360_lock);
-	res = misc_register(&sbc8360_miscdev);
-	if (res) {
-		printk(KERN_ERR PFX "failed to register misc device\n");
-		goto out_nomisc;
+	if (timeout < 0 || timeout > 63) {
+		printk(KERN_ERR PFX "Invalid timeout index (must be 0-63).\n");
+		res = -EINVAL;
+		goto out;
 	}
 
 	if (!request_region(SBC8360_ENABLE, 1, "SBC8360")) {
 		printk(KERN_ERR PFX "ENABLE method I/O %X is not available.\n",
 		       SBC8360_ENABLE);
 		res = -EIO;
-		goto out_noenablereg;
+		goto out;
 	}
 	if (!request_region(SBC8360_BASETIME, 1, "SBC8360")) {
 		printk(KERN_ERR PFX
@@ -360,10 +359,11 @@ static int __init sbc8360_init(void)
 		goto out_noreboot;
 	}
 
-	if (timeout < 0 || timeout > 63) {
-		printk(KERN_ERR PFX "Invalid timeout index (must be 0-63).\n");
-		res = -EINVAL;
-		goto out_noreboot;
+	spin_lock_init(&sbc8360_lock);
+	res = misc_register(&sbc8360_miscdev);
+	if (res) {
+		printk(KERN_ERR PFX "failed to register misc device\n");
+		goto out_nomisc;
 	}
 
 	wd_margin = wd_times[timeout][0];
@@ -383,13 +383,13 @@ static int __init sbc8360_init(void)
 
 	return 0;
 
+      out_nomisc:
+	unregister_reboot_notifier(&sbc8360_notifier);
       out_noreboot:
-	release_region(SBC8360_ENABLE, 1);
 	release_region(SBC8360_BASETIME, 1);
-      out_noenablereg:
       out_nobasetimereg:
-	misc_deregister(&sbc8360_miscdev);
-      out_nomisc:
+	release_region(SBC8360_ENABLE, 1);
+      out:
 	return res;
 }
 
diff --git a/drivers/char/watchdog/w83627hf_wdt.c b/drivers/char/watchdog/w83627hf_wdt.c
index 337ee42..b46e7f4 100644
--- a/drivers/char/watchdog/w83627hf_wdt.c
+++ b/drivers/char/watchdog/w83627hf_wdt.c
@@ -1,5 +1,8 @@
 /*
- *	w83627hf WDT driver
+ *	w83627hf/thf WDT driver
+ *
+ *	(c) Copyright 2007 Vlad Drukker <vlad@storewiz.com>
+ *		added support for W83627THF.
  *
  *	(c) Copyright 2003 Pádraig Brady <P@draigBrady.com>
  *
@@ -39,7 +42,7 @@
 #include <asm/uaccess.h>
 #include <asm/system.h>
 
-#define WATCHDOG_NAME "w83627hf WDT"
+#define WATCHDOG_NAME "w83627hf/thf WDT"
 #define PFX WATCHDOG_NAME ": "
 #define WATCHDOG_TIMEOUT 60		/* 60 sec default timeout */
 
@@ -50,7 +53,7 @@ static spinlock_t io_lock;
 /* You must set this - there is no sane way to probe for this board. */
 static int wdt_io = 0x2E;
 module_param(wdt_io, int, 0);
-MODULE_PARM_DESC(wdt_io, "w83627hf WDT io port (default 0x2E)");
+MODULE_PARM_DESC(wdt_io, "w83627hf/thf WDT io port (default 0x2E)");
 
 static int timeout = WATCHDOG_TIMEOUT;	/* in seconds */
 module_param(timeout, int, 0);
@@ -71,9 +74,19 @@ MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" _
 static void
 w83627hf_select_wd_register(void)
 {
+	unsigned char c;
 	outb_p(0x87, WDT_EFER); /* Enter extended function mode */
 	outb_p(0x87, WDT_EFER); /* Again according to manual */
 
+	outb(0x20, WDT_EFER); 	/* check chip version	*/
+	c = inb(WDT_EFDR);
+	if (c == 0x82) {	/* W83627THF 		*/
+		outb_p(0x2b, WDT_EFER); /* select GPIO3 */
+		c = ((inb_p(WDT_EFDR) & 0xf7) | 0x04); /* select WDT0 */
+		outb_p(0x2b, WDT_EFER);
+		outb_p(c, WDT_EFDR);	/* set GPIO3 to WDT0 */
+	}
+
 	outb_p(0x07, WDT_EFER); /* point to logical device number reg */
 	outb_p(0x08, WDT_EFDR); /* select logical device 8 (GPIO2) */
 	outb_p(0x30, WDT_EFER); /* select CR30 */
@@ -311,7 +324,7 @@ wdt_init(void)
 
 	spin_lock_init(&io_lock);
 
-	printk(KERN_INFO "WDT driver for the Winbond(TM) W83627HF Super I/O chip initialising.\n");
+	printk(KERN_INFO "WDT driver for the Winbond(TM) W83627HF/THF Super I/O chip initialising.\n");
 
 	if (wdt_set_heartbeat(timeout)) {
 		wdt_set_heartbeat(WATCHDOG_TIMEOUT);
@@ -367,5 +380,5 @@ module_exit(wdt_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Pádraig Brady <P@draigBrady.com>");
-MODULE_DESCRIPTION("w83627hf WDT driver");
+MODULE_DESCRIPTION("w83627hf/thf WDT driver");
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
