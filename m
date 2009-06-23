Return-Path: <linux-kernel-owner+w=401wt.eu-S1756817AbZFWHXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817AbZFWHXX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 03:23:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751682AbZFWHXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 03:23:14 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:1419 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751842AbZFWHXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 03:23:12 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAHgfQEpR9R03/2dsb2JhbADPBgmEAQU
Date: Tue, 23 Jun 2009 09:23:07 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ulrik Bech Hald <ubh@ti.com>,
       Tom Mingarelli <thomas.mingarelli@hp.com>
Subject: [WATCHDOG] v2.6.31-rc patches - Part 3: other fixes and changes
Message-ID: <20090623072307.GW32136@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
or if master.kernel.org hasn't synced up yet:
	master.kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git

This will update the following files:

 Documentation/watchdog/hpwdt.txt |   19 ++++--
 drivers/watchdog/Kconfig         |   18 +----
 drivers/watchdog/hpwdt.c         |   26 ++++++--
 drivers/watchdog/omap_wdt.c      |    7 ++
 drivers/watchdog/wdt_pci.c       |  122 +++++++++++++++++++--------------------
 5 files changed, 109 insertions(+), 83 deletions(-)

with these Changes:

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Fri Jun 19 09:32:57 2009 +0000

    [WATCHDOG] wdt_pci.c: remove #ifdef CONFIG_WDT_501_PCI
    
    Change the wdt_pci.c watchdog driver so that the code is the same for
    both the PCI-WDT500 as the PCI-WDT501 card. The selection of the card
    is now being done via the module parameter: 'type' instead of the
    config option CONFIG_WDT_501_PCI.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Tom Mingarelli <thomas.mingarelli@hp.com>
Date:   Thu Jun 18 23:28:57 2009 +0000

    [WATCHDOG] hpwdt: Add NMI priority option
    
    Add a priority option so that the user can choose if we do the NMI
    first or last.
    
    Signed-off-by: Thomas Mingarelli <thomas.mingarelli@hp.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Ulrik Bech Hald <ubh@ti.com>
Date:   Fri Jun 12 16:18:32 2009 -0500

    [WATCHDOG] OMAP fixes: enable clock in probe, trigger timer reload
    
    This patch contains two fixes:
    
    1)In omap_wdt_probe() the watchdog is reset and disabled. This
    requires register access and the clks needs to be enabled temporarily
    
    2)In omap_wdt_open() the timer register needs to be reloaded
    to trigger a new timer value (the default of 60s)
    
    Tested on OMAP34xx platform (Zoom1)
    
    Reviewed-by: Kevin Hilman <khilman@ti.deeprootsystems.com>
    Signed-off-by: Ulrik Bech Hald <ubh@ti.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/Documentation/watchdog/hpwdt.txt b/Documentation/watchdog/hpwdt.txt
index 127839e..9c24d5f 100644
--- a/Documentation/watchdog/hpwdt.txt
+++ b/Documentation/watchdog/hpwdt.txt
@@ -19,30 +19,41 @@ Last reviewed: 06/02/2009
  not be updated in a timely fashion and a hardware system reset (also known as
  an Automatic Server Recovery (ASR)) event will occur.
 
- The hpwdt driver also has three (3) module parameters. They are the following:
+ The hpwdt driver also has four (4) module parameters. They are the following:
 
  soft_margin - allows the user to set the watchdog timer value
  allow_kdump - allows the user to save off a kernel dump image after an NMI
  nowayout    - basic watchdog parameter that does not allow the timer to
                be restarted or an impending ASR to be escaped.
+ priority    - determines whether or not the hpwdt driver is first on the
+               die_notify list to handle NMIs or last. The default value
+               for this module parameter is 0 or LAST. If the user wants to
+               enable NMI sourcing then reload the hpwdt driver with
+               priority=1 (and boot with nmi_watchdog=0).
 
  NOTE: More information about watchdog drivers in general, including the ioctl
        interface to /dev/watchdog can be found in
        Documentation/watchdog/watchdog-api.txt and Documentation/IPMI.txt.
 
- The NMI sourcing capability is disabled when the driver discovers that the
- nmi_watchdog is turned on (nmi_watchdog = 1). This is due to the inability to
+ The priority parameter was introduced due to other kernel software that relied
+ on handling NMIs (like oprofile). Keeping hpwdt's priority at 0 (or LAST)
+ enables the users of NMIs for non critical events to be work as expected.
+
+ The NMI sourcing capability is disabled by default due to the inability to
  distinguish between "NMI Watchdog Ticks" and "HW generated NMI events" in the
  Linux kernel. What this means is that the hpwdt nmi handler code is called
  each time the NMI signal fires off. This could amount to several thousands of
  NMIs in a matter of seconds. If a user sees the Linux kernel's "dazed and
  confused" message in the logs or if the system gets into a hung state, then
- the user should reboot with nmi_watchdog=0.
+ the hpwdt driver can be reloaded with the "priority" module parameter set
+ (priority=1).
 
  1. If the kernel has not been booted with nmi_watchdog turned off then
     edit /boot/grub/menu.lst and place the nmi_watchdog=0 at the end of the
     currently booting kernel line.
  2. reboot the sever
+ 3. Once the system comes up perform a rmmod hpwdt
+ 4. insmod /lib/modules/`uname -r`/kernel/drivers/char/watchdog/hpwdt.ko priority=1
 
  Now, the hpwdt can successfully receive and source the NMI and provide a log
  message that details the reason for the NMI (as determined by the HP BIOS).
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index e8d45b6..b1ccc04 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -1007,24 +1007,16 @@ config WDTPCI
 	---help---
 	  If you have a PCI-WDT500/501 watchdog board, say Y here, otherwise N.
 
-	  To compile this driver as a module, choose M here: the
-	  module will be called wdt_pci.
-
-config WDT_501_PCI
-	bool "PCI-WDT501 features"
-	depends on WDTPCI
-	help
-	  Saying Y here and creating a character special file /dev/temperature
-	  with major number 10 and minor number 131 ("man mknod") will give
-	  you a thermometer inside your computer: reading from
-	  /dev/temperature yields one byte, the temperature in degrees
-	  Fahrenheit. This works only if you have a PCI-WDT501 watchdog board
-	  installed.
+	  If you have a PCI-WDT501 watchdog board then you can enable the
+	  temperature sensor by setting the type parameter to 501.
 
 	  If you want to enable the Fan Tachometer on the PCI-WDT501, then you
 	  can do this via the tachometer parameter. Only do this if you have a
 	  fan tachometer actually set up.
 
+	  To compile this driver as a module, choose M here: the
+	  module will be called wdt_pci.
+
 #
 # USB-based Watchdog Cards
 #
diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index c0b9169..a6c5674 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -120,7 +120,8 @@ static int nowayout = WATCHDOG_NOWAYOUT;
 static char expect_release;
 static unsigned long hpwdt_is_open;
 static unsigned int allow_kdump;
-static int hpwdt_nmi_sourcing;
+static unsigned int hpwdt_nmi_sourcing;
+static unsigned int priority;		/* hpwdt at end of die_notify list */
 
 static void __iomem *pci_mem_addr;		/* the PCI-memory address */
 static unsigned long __iomem *hpwdt_timer_reg;
@@ -623,7 +624,7 @@ static struct miscdevice hpwdt_miscdev = {
 
 static struct notifier_block die_notifier = {
 	.notifier_call = hpwdt_pretimeout,
-	.priority = 0x7FFFFFFF,
+	.priority = 0,
 };
 
 /*
@@ -641,7 +642,8 @@ static void __devinit hpwdt_check_nmi_sourcing(struct pci_dev *dev)
 		hpwdt_nmi_sourcing = 1;
 	else
 		dev_warn(&dev->dev, "NMI sourcing is disabled. To enable this "
-			"functionality you must reboot with nmi_watchdog=0.\n");
+			"functionality you must reboot with nmi_watchdog=0 "
+			"and load the hpwdt driver with priority=1.\n");
 }
 #else
 static void __devinit hpwdt_check_nmi_sourcing(struct pci_dev *dev)
@@ -714,6 +716,14 @@ static int __devinit hpwdt_init_one(struct pci_dev *dev,
 	cmn_regs.u1.rah = 0x0D;
 	cmn_regs.u1.ral = 0x02;
 
+	/*
+	 * If the priority is set to 1, then we will be put first on the
+	 * die notify list to handle a critical NMI. The default is to
+	 * be last so other users of the NMI signal can function.
+	 */
+	if (priority)
+		die_notifier.priority = 0x7FFFFFFF;
+
 	retval = register_die_notifier(&die_notifier);
 	if (retval != 0) {
 		dev_warn(&dev->dev,
@@ -733,9 +743,11 @@ static int __devinit hpwdt_init_one(struct pci_dev *dev,
 	printk(KERN_INFO
 		"hp Watchdog Timer Driver: %s"
 		", timer margin: %d seconds (nowayout=%d)"
-		", allow kernel dump: %s (default = 0/OFF).\n",
+		", allow kernel dump: %s (default = 0/OFF)"
+		", priority: %s (default = 0/LAST).\n",
 		HPWDT_VERSION, soft_margin, nowayout,
-		(allow_kdump == 0) ? "OFF" : "ON");
+		(allow_kdump == 0) ? "OFF" : "ON",
+		(priority == 0) ? "LAST" : "FIRST");
 
 	return 0;
 
@@ -798,5 +810,9 @@ module_param(nowayout, int, 0);
 MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default="
 		__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
+module_param(priority, int, 0);
+MODULE_PARM_DESC(priority, "The hpwdt driver handles NMIs first or last"
+		" (default = 0/Last)\n");
+
 module_init(hpwdt_init);
 module_exit(hpwdt_cleanup);
diff --git a/drivers/watchdog/omap_wdt.c b/drivers/watchdog/omap_wdt.c
index f271385..3ed571a 100644
--- a/drivers/watchdog/omap_wdt.c
+++ b/drivers/watchdog/omap_wdt.c
@@ -159,6 +159,7 @@ static int omap_wdt_open(struct inode *inode, struct file *file)
 	file->private_data = (void *) wdev;
 
 	omap_wdt_set_timeout(wdev);
+	omap_wdt_ping(wdev); /* trigger loading of new timeout value */
 	omap_wdt_enable(wdev);
 
 	return nonseekable_open(inode, file);
@@ -313,6 +314,9 @@ static int __devinit omap_wdt_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, wdev);
 
+	clk_enable(wdev->ick);
+	clk_enable(wdev->fck);
+
 	omap_wdt_disable(wdev);
 	omap_wdt_adjust_timeout(timer_margin);
 
@@ -332,6 +336,9 @@ static int __devinit omap_wdt_probe(struct platform_device *pdev)
 	/* autogate OCP interface clock */
 	__raw_writel(0x01, wdev->base + OMAP_WATCHDOG_SYS_CONFIG);
 
+	clk_disable(wdev->ick);
+	clk_disable(wdev->fck);
+
 	omap_wdt_dev = pdev;
 
 	return 0;
diff --git a/drivers/watchdog/wdt_pci.c b/drivers/watchdog/wdt_pci.c
index c45839a..7a1bdc7 100644
--- a/drivers/watchdog/wdt_pci.c
+++ b/drivers/watchdog/wdt_pci.c
@@ -2,7 +2,7 @@
  *	Industrial Computer Source PCI-WDT500/501 driver
  *
  *	(c) Copyright 1996-1997 Alan Cox <alan@lxorguk.ukuu.org.uk>,
- *						 All Rights Reserved.
+ *						All Rights Reserved.
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
@@ -99,14 +99,16 @@ MODULE_PARM_DESC(nowayout,
 		"Watchdog cannot be stopped once started (default="
 				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
-#ifdef CONFIG_WDT_501_PCI
 /* Support for the Fan Tachometer on the PCI-WDT501 */
 static int tachometer;
-
 module_param(tachometer, int, 0);
 MODULE_PARM_DESC(tachometer,
-	"PCI-WDT501 Fan Tachometer support (0=disable, default=0)");
-#endif /* CONFIG_WDT_501_PCI */
+		"PCI-WDT501 Fan Tachometer support (0=disable, default=0)");
+
+static int type = 500;
+module_param(type, int, 0);
+MODULE_PARM_DESC(type,
+		"PCI-WDT501 Card type (500 or 501 , default=500)");
 
 /*
  *	Programming support
@@ -266,22 +268,21 @@ static int wdtpci_get_status(int *status)
 		*status |= WDIOF_EXTERN1;
 	if (new_status & WDC_SR_ISII1)
 		*status |= WDIOF_EXTERN2;
-#ifdef CONFIG_WDT_501_PCI
-	if (!(new_status & WDC_SR_TGOOD))
-		*status |= WDIOF_OVERHEAT;
-	if (!(new_status & WDC_SR_PSUOVER))
-		*status |= WDIOF_POWEROVER;
-	if (!(new_status & WDC_SR_PSUUNDR))
-		*status |= WDIOF_POWERUNDER;
-	if (tachometer) {
-		if (!(new_status & WDC_SR_FANGOOD))
-			*status |= WDIOF_FANFAULT;
+	if (type == 501) {
+		if (!(new_status & WDC_SR_TGOOD))
+			*status |= WDIOF_OVERHEAT;
+		if (!(new_status & WDC_SR_PSUOVER))
+			*status |= WDIOF_POWEROVER;
+		if (!(new_status & WDC_SR_PSUUNDR))
+			*status |= WDIOF_POWERUNDER;
+		if (tachometer) {
+			if (!(new_status & WDC_SR_FANGOOD))
+				*status |= WDIOF_FANFAULT;
+		}
 	}
-#endif /* CONFIG_WDT_501_PCI */
 	return 0;
 }
 
-#ifdef CONFIG_WDT_501_PCI
 /**
  *	wdtpci_get_temperature:
  *
@@ -300,7 +301,6 @@ static int wdtpci_get_temperature(int *temperature)
 	*temperature = (c * 11 / 15) + 7;
 	return 0;
 }
-#endif /* CONFIG_WDT_501_PCI */
 
 /**
  *	wdtpci_interrupt:
@@ -327,22 +327,22 @@ static irqreturn_t wdtpci_interrupt(int irq, void *dev_id)
 
 	printk(KERN_CRIT PFX "status %d\n", status);
 
-#ifdef CONFIG_WDT_501_PCI
-	if (!(status & WDC_SR_TGOOD)) {
-		u8 alarm = inb(WDT_RT);
-		printk(KERN_CRIT PFX "Overheat alarm.(%d)\n", alarm);
-		udelay(8);
-	}
-	if (!(status & WDC_SR_PSUOVER))
-		printk(KERN_CRIT PFX "PSU over voltage.\n");
-	if (!(status & WDC_SR_PSUUNDR))
-		printk(KERN_CRIT PFX "PSU under voltage.\n");
-	if (tachometer) {
-		if (!(status & WDC_SR_FANGOOD))
-			printk(KERN_CRIT PFX "Possible fan fault.\n");
+	if (type == 501) {
+		if (!(status & WDC_SR_TGOOD)) {
+			printk(KERN_CRIT PFX "Overheat alarm.(%d)\n",
+								inb(WDT_RT));
+			udelay(8);
+		}
+		if (!(status & WDC_SR_PSUOVER))
+			printk(KERN_CRIT PFX "PSU over voltage.\n");
+		if (!(status & WDC_SR_PSUUNDR))
+			printk(KERN_CRIT PFX "PSU under voltage.\n");
+		if (tachometer) {
+			if (!(status & WDC_SR_FANGOOD))
+				printk(KERN_CRIT PFX "Possible fan fault.\n");
+		}
 	}
-#endif /* CONFIG_WDT_501_PCI */
-	if (!(status&WDC_SR_WCCR)) {
+	if (!(status & WDC_SR_WCCR)) {
 #ifdef SOFTWARE_REBOOT
 #ifdef ONLY_TESTING
 		printk(KERN_CRIT PFX "Would Reboot.\n");
@@ -371,12 +371,13 @@ static irqreturn_t wdtpci_interrupt(int irq, void *dev_id)
  */
 
 static ssize_t wdtpci_write(struct file *file, const char __user *buf,
-					size_t count, loff_t *ppos)
+						size_t count, loff_t *ppos)
 {
 	if (count) {
 		if (!nowayout) {
 			size_t i;
 
+			/* In case it was set long ago */
 			expect_close = 0;
 
 			for (i = 0; i != count; i++) {
@@ -406,10 +407,10 @@ static ssize_t wdtpci_write(struct file *file, const char __user *buf,
 static long wdtpci_ioctl(struct file *file, unsigned int cmd,
 							unsigned long arg)
 {
-	int new_heartbeat;
-	int status;
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
+	int new_heartbeat;
+	int status;
 
 	static struct watchdog_info ident = {
 		.options =		WDIOF_SETTIMEOUT|
@@ -421,11 +422,12 @@ static long wdtpci_ioctl(struct file *file, unsigned int cmd,
 
 	/* Add options according to the card we have */
 	ident.options |= (WDIOF_EXTERN1|WDIOF_EXTERN2);
-#ifdef CONFIG_WDT_501_PCI
-	ident.options |= (WDIOF_OVERHEAT|WDIOF_POWERUNDER|WDIOF_POWEROVER);
-	if (tachometer)
-		ident.options |= WDIOF_FANFAULT;
-#endif /* CONFIG_WDT_501_PCI */
+	if (type == 501) {
+		ident.options |= (WDIOF_OVERHEAT|WDIOF_POWERUNDER|
+							WDIOF_POWEROVER);
+		if (tachometer)
+			ident.options |= WDIOF_FANFAULT;
+	}
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
@@ -503,7 +505,6 @@ static int wdtpci_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-#ifdef CONFIG_WDT_501_PCI
 /**
  *	wdtpci_temp_read:
  *	@file: file handle to the watchdog board
@@ -554,7 +555,6 @@ static int wdtpci_temp_release(struct inode *inode, struct file *file)
 {
 	return 0;
 }
-#endif /* CONFIG_WDT_501_PCI */
 
 /**
  *	notify_sys:
@@ -596,7 +596,6 @@ static struct miscdevice wdtpci_miscdev = {
 	.fops	= &wdtpci_fops,
 };
 
-#ifdef CONFIG_WDT_501_PCI
 static const struct file_operations wdtpci_temp_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
@@ -610,7 +609,6 @@ static struct miscdevice temp_miscdev = {
 	.name	= "temperature",
 	.fops	= &wdtpci_temp_fops,
 };
-#endif /* CONFIG_WDT_501_PCI */
 
 /*
  *	The WDT card needs to learn about soft shutdowns in order to
@@ -633,6 +631,11 @@ static int __devinit wdtpci_init_one(struct pci_dev *dev,
 		return -ENODEV;
 	}
 
+	if (type != 500 && type != 501) {
+		printk(KERN_ERR PFX "unknown card type '%d'.\n", type);
+		return -ENODEV;
+	}
+
 	if (pci_enable_device(dev)) {
 		printk(KERN_ERR PFX "Not possible to enable PCI Device\n");
 		return -ENODEV;
@@ -678,15 +681,15 @@ static int __devinit wdtpci_init_one(struct pci_dev *dev,
 		goto out_irq;
 	}
 
-#ifdef CONFIG_WDT_501_PCI
-	ret = misc_register(&temp_miscdev);
-	if (ret) {
-		printk(KERN_ERR PFX
+	if (type == 501) {
+		ret = misc_register(&temp_miscdev);
+		if (ret) {
+			printk(KERN_ERR PFX
 			"cannot register miscdev on minor=%d (err=%d)\n",
-					TEMP_MINOR, ret);
-		goto out_rbt;
+							TEMP_MINOR, ret);
+			goto out_rbt;
+		}
 	}
-#endif /* CONFIG_WDT_501_PCI */
 
 	ret = misc_register(&wdtpci_miscdev);
 	if (ret) {
@@ -698,20 +701,18 @@ static int __devinit wdtpci_init_one(struct pci_dev *dev,
 
 	printk(KERN_INFO PFX "initialized. heartbeat=%d sec (nowayout=%d)\n",
 		heartbeat, nowayout);
-#ifdef CONFIG_WDT_501_PCI
-	printk(KERN_INFO "wdt: Fan Tachometer is %s\n",
+	if (type == 501)
+		printk(KERN_INFO "wdt: Fan Tachometer is %s\n",
 				(tachometer ? "Enabled" : "Disabled"));
-#endif /* CONFIG_WDT_501_PCI */
 
 	ret = 0;
 out:
 	return ret;
 
 out_misc:
-#ifdef CONFIG_WDT_501_PCI
-	misc_deregister(&temp_miscdev);
+	if (type == 501)
+		misc_deregister(&temp_miscdev);
 out_rbt:
-#endif /* CONFIG_WDT_501_PCI */
 	unregister_reboot_notifier(&wdtpci_notifier);
 out_irq:
 	free_irq(irq, &wdtpci_miscdev);
@@ -728,9 +729,8 @@ static void __devexit wdtpci_remove_one(struct pci_dev *pdev)
 	/* here we assume only one device will ever have
 	 * been picked up and registered by probe function */
 	misc_deregister(&wdtpci_miscdev);
-#ifdef CONFIG_WDT_501_PCI
-	misc_deregister(&temp_miscdev);
-#endif /* CONFIG_WDT_501_PCI */
+	if (type == 501)
+		misc_deregister(&temp_miscdev);
 	unregister_reboot_notifier(&wdtpci_notifier);
 	free_irq(irq, &wdtpci_miscdev);
 	release_region(io, 16);
