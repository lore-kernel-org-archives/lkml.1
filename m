Return-Path: <linux-kernel-owner+w=401wt.eu-S1757513AbZFRHmI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513AbZFRHmI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 03:42:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753120AbZFRHl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 03:41:56 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:47028 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752634AbZFRHly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 03:41:54 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAHuLOUpR937K/2dsb2JhbADBE5BoCIIvBoFLBQ
Date: Thu, 18 Jun 2009 09:41:52 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Mingarelli <thomas.mingarelli@hp.com>,
       "Denis V. Lunev" <den@openvz.org>
Subject: [WATCHDOG] v2.6.31-rc patches - Part 1: watchdog fixes, clean-up
	and changes
Message-ID: <20090618074152.GK32136@infomag.iguana.be>
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

 Documentation/watchdog/hpwdt.txt       |   84 +++++++++++++++++++++++++++++++
 drivers/watchdog/alim7101_wdt.c        |   15 ++++-
 drivers/watchdog/ar7_wdt.c             |    3 -
 drivers/watchdog/at91rm9200_wdt.c      |    3 -
 drivers/watchdog/at91sam9_wdt.c        |    3 -
 drivers/watchdog/bfin_wdt.c            |   14 +++--
 drivers/watchdog/cpwd.c                |    6 +-
 drivers/watchdog/davinci_wdt.c         |    6 +-
 drivers/watchdog/hpwdt.c               |   59 ++++++++++++++++------
 drivers/watchdog/iTCO_vendor_support.c |   88 +++++++++++++++++++++++++++++----
 drivers/watchdog/iTCO_wdt.c            |   36 +++++++------
 drivers/watchdog/indydog.c             |    4 -
 drivers/watchdog/it8712f_wdt.c         |    3 -
 drivers/watchdog/ks8695_wdt.c          |    4 -
 drivers/watchdog/machzwd.c             |    9 ++-
 drivers/watchdog/mpcore_wdt.c          |    7 +-
 drivers/watchdog/mtx-1_wdt.c           |    6 +-
 drivers/watchdog/pnx4008_wdt.c         |    6 +-
 drivers/watchdog/rdc321x_wdt.c         |    4 -
 drivers/watchdog/rm9k_wdt.c            |    6 +-
 drivers/watchdog/s3c2410_wdt.c         |   32 +++++-------
 drivers/watchdog/sb_wdog.c             |    9 +--
 drivers/watchdog/sbc60xxwdt.c          |    5 +
 drivers/watchdog/sbc8360.c             |    4 -
 drivers/watchdog/sbc_epx_c3.c          |   12 ++--
 drivers/watchdog/scx200_wdt.c          |    7 +-
 drivers/watchdog/shwdt.c               |    4 +
 drivers/watchdog/softdog.c             |    7 +-
 drivers/watchdog/w83697hf_wdt.c        |    3 -
 drivers/watchdog/wdrtas.c              |    7 --
 30 files changed, 335 insertions(+), 121 deletions(-)

with these Changes:

Author: Thomas Mingarelli <thomas.mingarelli@hp.com>
Date:   Thu Jun 4 19:50:45 2009 +0000

    [WATCHDOG] hpwdt: Add NMI sourcing
    
    Add NMI sourcing functionality (Can only be active if nmi_watchdog is
    inactive).
    
    Signed-off-by: Thomas Mingarelli <thomas.mingarelli@hp.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Mon Jun 8 17:41:51 2009 +0000

    [WATCHDOG] iTCO_wdt: Fix ICH7+ reboot issue.
    
    Bugzilla: 9868 & 10195.
    There seems to be a bug into the SMM code that handles TCO Timeout SMI.
    Andriy Gapon found that the code on his DG33TL system does the following:
    > The handler is quite simple - it tests value in TCO1_CNT against 0x800, i.e.
    > checks TCO_TMR_HLT. If the bit is set the handler goes into an infinite loop,
    > apparently to allow the second timeout and reboot. Otherwise it simply clears
    > TIMEOUT bit in TCO1_STS and that's it.
    > So the logic seems to be reversed, because it is hard to see how TIMEOUT can
    > get set to 1 and SMI generated when TCO_TMR_HLT is set (other than a
    > transitional effect).
    
    The only trick we have is to bypass the SMM code by turning of the generation
    of the SMI#. The trick can only be enabled by setting the vendorsupport module
    parameter to 911. This trick doesn't work well on laptop's.
    
    Note: this is a dirty hack. Please handle with care. The only real fix is that
    the bug in the SMM bios code get's fixed.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Denis V. Lunev <den@openvz.org>
Date:   Fri Jun 5 15:13:08 2009 +0400

    [WATCHDOG] iTCO_wdt: fix memory corruption when RCBA is disabled by hardware
    
    According to 9.1.33 on p.343 of ICH8.pdf RCBA can be disabled by
    hardware if bit 0 of RCBA register is not set.
    
    Perform correct check for this to prevent memory corruption under
    some virtual machines where this feature is disabled.
    
    Signed-off-by: Denis V. Lunev <den@openvz.org>
    CC: Vasily Averin <vvs@openvz.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Mon May 11 18:33:00 2009 +0000

    [WATCHDOG] Correct WDIOF_MAGICCLOSE flag
    
    Make sure that when the WDIOF_MAGICCLOSE flag is set we also
    support the magic-close feature...
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Tue Apr 14 20:30:55 2009 +0000

    [WATCHDOG] move platform probe and remove function to devinit and devexit
    
    A pointer to probe and remove functions is passed to the core via
    platform_driver_register and so the function must not disappear when the
    .init sections are discarded.  Otherwise (if also having HOTPLUG=y)
    unbinding and binding a device to the driver via sysfs will result in an
    oops as does a device being registered late.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Tue Apr 14 20:20:07 2009 +0000

    [WATCHDOG] Some more general cleanup
    
    Clean-up the watchdog drivers so that checkpatch.pl get's happy...
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Tue Apr 14 20:20:07 2009 +0000

    [WATCHDOG] iTCO_wdt: Cleanup code
    
    Clean-up the iTCO_wdt code so that checkpatch.pl get's happy...
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/Documentation/watchdog/hpwdt.txt b/Documentation/watchdog/hpwdt.txt
new file mode 100644
index 0000000..127839e
--- /dev/null
+++ b/Documentation/watchdog/hpwdt.txt
@@ -0,0 +1,84 @@
+Last reviewed: 06/02/2009
+
+                     HP iLO2 NMI Watchdog Driver
+              NMI sourcing for iLO2 based ProLiant Servers
+                     Documentation and Driver by
+              Thomas Mingarelli <thomas.mingarelli@hp.com>
+
+ The HP iLO2 NMI Watchdog driver is a kernel module that provides basic
+ watchdog functionality and the added benefit of NMI sourcing. Both the
+ watchdog functionality and the NMI sourcing capability need to be enabled
+ by the user. Remember that the two modes are not dependant on one another.
+ A user can have the NMI sourcing without the watchdog timer and vice-versa.
+
+ Watchdog functionality is enabled like any other common watchdog driver. That
+ is, an application needs to be started that kicks off the watchdog timer. A
+ basic application exists in the Documentation/watchdog/src directory called
+ watchdog-test.c. Simply compile the C file and kick it off. If the system
+ gets into a bad state and hangs, the HP ProLiant iLO 2 timer register will
+ not be updated in a timely fashion and a hardware system reset (also known as
+ an Automatic Server Recovery (ASR)) event will occur.
+
+ The hpwdt driver also has three (3) module parameters. They are the following:
+
+ soft_margin - allows the user to set the watchdog timer value
+ allow_kdump - allows the user to save off a kernel dump image after an NMI
+ nowayout    - basic watchdog parameter that does not allow the timer to
+               be restarted or an impending ASR to be escaped.
+
+ NOTE: More information about watchdog drivers in general, including the ioctl
+       interface to /dev/watchdog can be found in
+       Documentation/watchdog/watchdog-api.txt and Documentation/IPMI.txt.
+
+ The NMI sourcing capability is disabled when the driver discovers that the
+ nmi_watchdog is turned on (nmi_watchdog = 1). This is due to the inability to
+ distinguish between "NMI Watchdog Ticks" and "HW generated NMI events" in the
+ Linux kernel. What this means is that the hpwdt nmi handler code is called
+ each time the NMI signal fires off. This could amount to several thousands of
+ NMIs in a matter of seconds. If a user sees the Linux kernel's "dazed and
+ confused" message in the logs or if the system gets into a hung state, then
+ the user should reboot with nmi_watchdog=0.
+
+ 1. If the kernel has not been booted with nmi_watchdog turned off then
+    edit /boot/grub/menu.lst and place the nmi_watchdog=0 at the end of the
+    currently booting kernel line.
+ 2. reboot the sever
+
+ Now, the hpwdt can successfully receive and source the NMI and provide a log
+ message that details the reason for the NMI (as determined by the HP BIOS).
+
+ Below is a list of NMIs the HP BIOS understands along with the associated
+ code (reason):
+
+	No source found                00h
+
+	Uncorrectable Memory Error     01h
+
+	ASR NMI                        1Bh
+
+	PCI Parity Error               20h
+
+	NMI Button Press               27h
+
+	SB_BUS_NMI                     28h
+
+	ILO Doorbell NMI               29h
+
+	ILO IOP NMI                    2Ah
+
+	ILO Watchdog NMI               2Bh
+
+	Proc Throt NMI                 2Ch
+
+	Front Side Bus NMI             2Dh
+
+	PCI Express Error              2Fh
+
+	DMA controller NMI             30h
+
+	Hypertransport/CSI Error       31h
+
+
+
+ -- Tom Mingarelli
+    (thomas.mingarelli@hp.com)
diff --git a/drivers/watchdog/alim7101_wdt.c b/drivers/watchdog/alim7101_wdt.c
index 90f98df..f90afdb 100644
--- a/drivers/watchdog/alim7101_wdt.c
+++ b/drivers/watchdog/alim7101_wdt.c
@@ -322,7 +322,8 @@ static int wdt_notify_sys(struct notifier_block *this,
 		 * watchdog on reboot with no heartbeat
 		 */
 		wdt_change(WDT_ENABLE);
-		printk(KERN_INFO PFX "Watchdog timer is now enabled with no heartbeat - should reboot in ~1 second.\n");
+		printk(KERN_INFO PFX "Watchdog timer is now enabled "
+			"with no heartbeat - should reboot in ~1 second.\n");
 	}
 	return NOTIFY_DONE;
 }
@@ -374,12 +375,17 @@ static int __init alim7101_wdt_init(void)
 	pci_dev_put(ali1543_south);
 	if ((tmp & 0x1e) == 0x00) {
 		if (!use_gpio) {
-			printk(KERN_INFO PFX "Detected old alim7101 revision 'a1d'.  If this is a cobalt board, set the 'use_gpio' module parameter.\n");
+			printk(KERN_INFO PFX
+				"Detected old alim7101 revision 'a1d'.  "
+				"If this is a cobalt board, set the 'use_gpio' "
+				"module parameter.\n");
 			goto err_out;
 		}
 		nowayout = 1;
 	} else if ((tmp & 0x1e) != 0x12 && (tmp & 0x1e) != 0x00) {
-		printk(KERN_INFO PFX "ALi 1543 South-Bridge does not have the correct revision number (???1001?) - WDT not set\n");
+		printk(KERN_INFO PFX
+			"ALi 1543 South-Bridge does not have the correct "
+			"revision number (???1001?) - WDT not set\n");
 		goto err_out;
 	}
 
@@ -409,7 +415,8 @@ static int __init alim7101_wdt_init(void)
 	if (nowayout)
 		__module_get(THIS_MODULE);
 
-	printk(KERN_INFO PFX "WDT driver for ALi M7101 initialised. timeout=%d sec (nowayout=%d)\n",
+	printk(KERN_INFO PFX "WDT driver for ALi M7101 initialised. "
+					"timeout=%d sec (nowayout=%d)\n",
 		timeout, nowayout);
 	return 0;
 
diff --git a/drivers/watchdog/ar7_wdt.c b/drivers/watchdog/ar7_wdt.c
index 55dcbfe..3fe9742 100644
--- a/drivers/watchdog/ar7_wdt.c
+++ b/drivers/watchdog/ar7_wdt.c
@@ -246,7 +246,8 @@ static long ar7_wdt_ioctl(struct file *file,
 	static struct watchdog_info ident = {
 		.identity = LONGNAME,
 		.firmware_version = 1,
-		.options = (WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING),
+		.options = (WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING |
+						WDIOF_MAGICCLOSE),
 	};
 	int new_margin;
 
diff --git a/drivers/watchdog/at91rm9200_wdt.c b/drivers/watchdog/at91rm9200_wdt.c
index 29e52c2..b185daf 100644
--- a/drivers/watchdog/at91rm9200_wdt.c
+++ b/drivers/watchdog/at91rm9200_wdt.c
@@ -268,7 +268,8 @@ static int __init at91_wdt_init(void)
 	   if not reset to the default */
 	if (at91_wdt_settimeout(wdt_time)) {
 		at91_wdt_settimeout(WDT_DEFAULT_TIME);
-		pr_info("at91_wdt: wdt_time value must be 1 <= wdt_time <= 256, using %d\n", wdt_time);
+		pr_info("at91_wdt: wdt_time value must be 1 <= wdt_time <= 256"
+						", using %d\n", wdt_time);
 	}
 
 	return platform_driver_register(&at91wdt_driver);
diff --git a/drivers/watchdog/at91sam9_wdt.c b/drivers/watchdog/at91sam9_wdt.c
index 435b057..eac2602 100644
--- a/drivers/watchdog/at91sam9_wdt.c
+++ b/drivers/watchdog/at91sam9_wdt.c
@@ -156,7 +156,8 @@ static int at91_wdt_settimeout(unsigned int timeout)
 
 static const struct watchdog_info at91_wdt_info = {
 	.identity	= DRV_NAME,
-	.options	= WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
+	.options	= WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING |
+						WDIOF_MAGICCLOSE,
 };
 
 /*
diff --git a/drivers/watchdog/bfin_wdt.c b/drivers/watchdog/bfin_wdt.c
index 067a57c..c7b3f9d 100644
--- a/drivers/watchdog/bfin_wdt.c
+++ b/drivers/watchdog/bfin_wdt.c
@@ -27,10 +27,15 @@
 #include <linux/uaccess.h>
 #include <asm/blackfin.h>
 
-#define stamp(fmt, args...) pr_debug("%s:%i: " fmt "\n", __func__, __LINE__, ## args)
+#define stamp(fmt, args...) \
+	pr_debug("%s:%i: " fmt "\n", __func__, __LINE__, ## args)
 #define stampit() stamp("here i am")
-#define pr_devinit(fmt, args...) ({ static const __devinitconst char __fmt[] = fmt; printk(__fmt, ## args); })
-#define pr_init(fmt, args...) ({ static const __initconst char __fmt[] = fmt; printk(__fmt, ## args); })
+#define pr_devinit(fmt, args...) \
+	({ static const __devinitconst char __fmt[] = fmt; \
+	printk(__fmt, ## args); })
+#define pr_init(fmt, args...) \
+	({ static const __initconst char __fmt[] = fmt; \
+	printk(__fmt, ## args); })
 
 #define WATCHDOG_NAME "bfin-wdt"
 #define PFX WATCHDOG_NAME ": "
@@ -476,7 +481,8 @@ static int __init bfin_wdt_init(void)
 		return ret;
 	}
 
-	bfin_wdt_device = platform_device_register_simple(WATCHDOG_NAME, -1, NULL, 0);
+	bfin_wdt_device = platform_device_register_simple(WATCHDOG_NAME,
+								-1, NULL, 0);
 	if (IS_ERR(bfin_wdt_device)) {
 		pr_init(KERN_ERR PFX "unable to register device\n");
 		platform_driver_unregister(&bfin_wdt_driver);
diff --git a/drivers/watchdog/cpwd.c b/drivers/watchdog/cpwd.c
index 41070e4..081f295 100644
--- a/drivers/watchdog/cpwd.c
+++ b/drivers/watchdog/cpwd.c
@@ -154,9 +154,9 @@ static struct cpwd *cpwd_device;
 
 static struct timer_list cpwd_timer;
 
-static int wd0_timeout = 0;
-static int wd1_timeout = 0;
-static int wd2_timeout = 0;
+static int wd0_timeout;
+static int wd1_timeout;
+static int wd2_timeout;
 
 module_param(wd0_timeout, int, 0);
 MODULE_PARM_DESC(wd0_timeout, "Default watchdog0 timeout in 1/10secs");
diff --git a/drivers/watchdog/davinci_wdt.c b/drivers/watchdog/davinci_wdt.c
index c51d0b0..83e22e7 100644
--- a/drivers/watchdog/davinci_wdt.c
+++ b/drivers/watchdog/davinci_wdt.c
@@ -193,7 +193,7 @@ static struct miscdevice davinci_wdt_miscdev = {
 	.fops = &davinci_wdt_fops,
 };
 
-static int davinci_wdt_probe(struct platform_device *pdev)
+static int __devinit davinci_wdt_probe(struct platform_device *pdev)
 {
 	int ret = 0, size;
 	struct resource *res;
@@ -237,7 +237,7 @@ static int davinci_wdt_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int davinci_wdt_remove(struct platform_device *pdev)
+static int __devexit davinci_wdt_remove(struct platform_device *pdev)
 {
 	misc_deregister(&davinci_wdt_miscdev);
 	if (wdt_mem) {
@@ -254,7 +254,7 @@ static struct platform_driver platform_wdt_driver = {
 		.owner	= THIS_MODULE,
 	},
 	.probe = davinci_wdt_probe,
-	.remove = davinci_wdt_remove,
+	.remove = __devexit_p(davinci_wdt_remove),
 };
 
 static int __init davinci_wdt_init(void)
diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index 3137361..c0b9169 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -19,6 +19,7 @@
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/irq.h>
+#include <linux/nmi.h>
 #include <linux/kernel.h>
 #include <linux/miscdevice.h>
 #include <linux/mm.h>
@@ -47,7 +48,7 @@
 #define PCI_BIOS32_PARAGRAPH_LEN	16
 #define PCI_ROM_BASE1			0x000F0000
 #define ROM_SIZE			0x10000
-#define HPWDT_VERSION			"1.01"
+#define HPWDT_VERSION			"1.1.1"
 
 struct bios32_service_dir {
 	u32 signature;
@@ -119,6 +120,7 @@ static int nowayout = WATCHDOG_NOWAYOUT;
 static char expect_release;
 static unsigned long hpwdt_is_open;
 static unsigned int allow_kdump;
+static int hpwdt_nmi_sourcing;
 
 static void __iomem *pci_mem_addr;		/* the PCI-memory address */
 static unsigned long __iomem *hpwdt_timer_reg;
@@ -468,21 +470,22 @@ static int hpwdt_pretimeout(struct notifier_block *nb, unsigned long ulReason,
 	if (ulReason != DIE_NMI && ulReason != DIE_NMI_IPI)
 		return NOTIFY_OK;
 
-	spin_lock_irqsave(&rom_lock, rom_pl);
-	if (!die_nmi_called)
-		asminline_call(&cmn_regs, cru_rom_addr);
-	die_nmi_called = 1;
-	spin_unlock_irqrestore(&rom_lock, rom_pl);
-	if (cmn_regs.u1.ral == 0) {
-		printk(KERN_WARNING "hpwdt: An NMI occurred, "
-			"but unable to determine source.\n");
-	} else {
-		if (allow_kdump)
-			hpwdt_stop();
-		panic("An NMI occurred, please see the Integrated "
-			"Management Log for details.\n");
+	if (hpwdt_nmi_sourcing) {
+		spin_lock_irqsave(&rom_lock, rom_pl);
+		if (!die_nmi_called)
+			asminline_call(&cmn_regs, cru_rom_addr);
+		die_nmi_called = 1;
+		spin_unlock_irqrestore(&rom_lock, rom_pl);
+		if (cmn_regs.u1.ral == 0) {
+			printk(KERN_WARNING "hpwdt: An NMI occurred, "
+				"but unable to determine source.\n");
+		} else {
+			if (allow_kdump)
+				hpwdt_stop();
+			panic("An NMI occurred, please see the Integrated "
+				"Management Log for details.\n");
+		}
 	}
-
 	return NOTIFY_OK;
 }
 
@@ -627,12 +630,38 @@ static struct notifier_block die_notifier = {
  *	Init & Exit
  */
 
+#ifdef ARCH_HAS_NMI_WATCHDOG
+static void __devinit hpwdt_check_nmi_sourcing(struct pci_dev *dev)
+{
+	/*
+	 * If nmi_watchdog is turned off then we can turn on
+	 * our nmi sourcing capability.
+	 */
+	if (!nmi_watchdog_active())
+		hpwdt_nmi_sourcing = 1;
+	else
+		dev_warn(&dev->dev, "NMI sourcing is disabled. To enable this "
+			"functionality you must reboot with nmi_watchdog=0.\n");
+}
+#else
+static void __devinit hpwdt_check_nmi_sourcing(struct pci_dev *dev)
+{
+	dev_warn(&dev->dev, "NMI sourcing is disabled. "
+		"Your kernel does not support a NMI Watchdog.\n");
+}
+#endif
+
 static int __devinit hpwdt_init_one(struct pci_dev *dev,
 					const struct pci_device_id *ent)
 {
 	int retval;
 
 	/*
+	 * Check if we can do NMI sourcing or not
+	 */
+	hpwdt_check_nmi_sourcing(dev);
+
+	/*
 	 * First let's find out if we are on an iLO2 server. We will
 	 * not run on a legacy ASM box.
 	 * So we only support the G5 ProLiant servers and higher.
diff --git a/drivers/watchdog/iTCO_vendor_support.c b/drivers/watchdog/iTCO_vendor_support.c
index d3c0f6d..5133bca 100644
--- a/drivers/watchdog/iTCO_vendor_support.c
+++ b/drivers/watchdog/iTCO_vendor_support.c
@@ -19,7 +19,7 @@
 
 /* Module and version information */
 #define DRV_NAME	"iTCO_vendor_support"
-#define DRV_VERSION	"1.03"
+#define DRV_VERSION	"1.04"
 #define PFX		DRV_NAME ": "
 
 /* Includes */
@@ -35,20 +35,23 @@
 #include "iTCO_vendor.h"
 
 /* iTCO defines */
-#define	SMI_EN		acpibase + 0x30	/* SMI Control and Enable Register */
-#define	TCOBASE		acpibase + 0x60	/* TCO base address */
-#define	TCO1_STS	TCOBASE + 0x04	/* TCO1 Status Register */
+#define	SMI_EN		(acpibase + 0x30) /* SMI Control and Enable Register */
+#define	TCOBASE		(acpibase + 0x60) /* TCO base address */
+#define	TCO1_STS	(TCOBASE + 0x04)  /* TCO1 Status Register */
 
 /* List of vendor support modes */
 /* SuperMicro Pentium 3 Era 370SSE+-OEM1/P3TSSE */
 #define SUPERMICRO_OLD_BOARD	1
 /* SuperMicro Pentium 4 / Xeon 4 / EMT64T Era Systems */
 #define SUPERMICRO_NEW_BOARD	2
+/* Broken BIOS */
+#define BROKEN_BIOS		911
 
 static int vendorsupport;
 module_param(vendorsupport, int, 0);
 MODULE_PARM_DESC(vendorsupport, "iTCO vendor specific support mode, default="
-			"0 (none), 1=SuperMicro Pent3, 2=SuperMicro Pent4+");
+			"0 (none), 1=SuperMicro Pent3, 2=SuperMicro Pent4+, "
+							"911=Broken SMI BIOS");
 
 /*
  *	Vendor Specific Support
@@ -243,25 +246,92 @@ static void supermicro_new_pre_set_heartbeat(unsigned int heartbeat)
 }
 
 /*
+ *	Vendor Support: 911
+ *	Board: Some Intel ICHx based motherboards
+ *	iTCO chipset: ICH7+
+ *
+ *	Some Intel motherboards have a broken BIOS implementation: i.e.
+ *	the SMI handler clear's the TIMEOUT bit in the TC01_STS register
+ *	and does not reload the time. Thus the TCO watchdog does not reboot
+ *	the system.
+ *
+ *	These are the conclusions of Andriy Gapon <avg@icyb.net.ua> after
+ *	debugging: the SMI handler is quite simple - it tests value in
+ *	TCO1_CNT against 0x800, i.e. checks TCO_TMR_HLT. If the bit is set
+ *	the handler goes into an infinite loop, apparently to allow the
+ *	second timeout and reboot. Otherwise it simply clears TIMEOUT bit
+ *	in TCO1_STS and that's it.
+ *	So the logic seems to be reversed, because it is hard to see how
+ *	TIMEOUT can get set to 1 and SMI generated when TCO_TMR_HLT is set
+ *	(other than a transitional effect).
+ *
+ *	The only fix found to get the motherboard(s) to reboot is to put
+ *	the glb_smi_en bit to 0. This is a dirty hack that bypasses the
+ *	broken code by disabling Global SMI.
+ *
+ *	WARNING: globally disabling SMI could possibly lead to dramatic
+ *	problems, especially on laptops! I.e. various ACPI things where
+ *	SMI is used for communication between OS and firmware.
+ *
+ *	Don't use this fix if you don't need to!!!
+ */
+
+static void broken_bios_start(unsigned long acpibase)
+{
+	unsigned long val32;
+
+	val32 = inl(SMI_EN);
+	/* Bit 13: TCO_EN     -> 0 = Disables TCO logic generating an SMI#
+	   Bit  0: GBL_SMI_EN -> 0 = No SMI# will be generated by ICH. */
+	val32 &= 0xffffdffe;
+	outl(val32, SMI_EN);
+}
+
+static void broken_bios_stop(unsigned long acpibase)
+{
+	unsigned long val32;
+
+	val32 = inl(SMI_EN);
+	/* Bit 13: TCO_EN     -> 1 = Enables TCO logic generating an SMI#
+	   Bit  0: GBL_SMI_EN -> 1 = Turn global SMI on again. */
+	val32 |= 0x00002001;
+	outl(val32, SMI_EN);
+}
+
+/*
  *	Generic Support Functions
  */
 
 void iTCO_vendor_pre_start(unsigned long acpibase,
 			   unsigned int heartbeat)
 {
-	if (vendorsupport == SUPERMICRO_OLD_BOARD)
+	switch (vendorsupport) {
+	case SUPERMICRO_OLD_BOARD:
 		supermicro_old_pre_start(acpibase);
-	else if (vendorsupport == SUPERMICRO_NEW_BOARD)
+		break;
+	case SUPERMICRO_NEW_BOARD:
 		supermicro_new_pre_start(heartbeat);
+		break;
+	case BROKEN_BIOS:
+		broken_bios_start(acpibase);
+		break;
+	}
 }
 EXPORT_SYMBOL(iTCO_vendor_pre_start);
 
 void iTCO_vendor_pre_stop(unsigned long acpibase)
 {
-	if (vendorsupport == SUPERMICRO_OLD_BOARD)
+	switch (vendorsupport) {
+	case SUPERMICRO_OLD_BOARD:
 		supermicro_old_pre_stop(acpibase);
-	else if (vendorsupport == SUPERMICRO_NEW_BOARD)
+		break;
+	case SUPERMICRO_NEW_BOARD:
 		supermicro_new_pre_stop();
+		break;
+	case BROKEN_BIOS:
+		broken_bios_stop(acpibase);
+		break;
+	}
 }
 EXPORT_SYMBOL(iTCO_vendor_pre_stop);
 
diff --git a/drivers/watchdog/iTCO_wdt.c b/drivers/watchdog/iTCO_wdt.c
index 648250b..6a51edd 100644
--- a/drivers/watchdog/iTCO_wdt.c
+++ b/drivers/watchdog/iTCO_wdt.c
@@ -236,19 +236,19 @@ MODULE_DEVICE_TABLE(pci, iTCO_wdt_pci_tbl);
 
 /* Address definitions for the TCO */
 /* TCO base address */
-#define TCOBASE		iTCO_wdt_private.ACPIBASE + 0x60
+#define TCOBASE		(iTCO_wdt_private.ACPIBASE + 0x60)
 /* SMI Control and Enable Register */
-#define SMI_EN		iTCO_wdt_private.ACPIBASE + 0x30
-
-#define TCO_RLD		TCOBASE + 0x00	/* TCO Timer Reload and Curr. Value */
-#define TCOv1_TMR	TCOBASE + 0x01	/* TCOv1 Timer Initial Value	*/
-#define TCO_DAT_IN	TCOBASE + 0x02	/* TCO Data In Register		*/
-#define TCO_DAT_OUT	TCOBASE + 0x03	/* TCO Data Out Register	*/
-#define TCO1_STS	TCOBASE + 0x04	/* TCO1 Status Register		*/
-#define TCO2_STS	TCOBASE + 0x06	/* TCO2 Status Register		*/
-#define TCO1_CNT	TCOBASE + 0x08	/* TCO1 Control Register	*/
-#define TCO2_CNT	TCOBASE + 0x0a	/* TCO2 Control Register	*/
-#define TCOv2_TMR	TCOBASE + 0x12	/* TCOv2 Timer Initial Value	*/
+#define SMI_EN		(iTCO_wdt_private.ACPIBASE + 0x30)
+
+#define TCO_RLD		(TCOBASE + 0x00) /* TCO Timer Reload and Curr. Value */
+#define TCOv1_TMR	(TCOBASE + 0x01) /* TCOv1 Timer Initial Value	*/
+#define TCO_DAT_IN	(TCOBASE + 0x02) /* TCO Data In Register	*/
+#define TCO_DAT_OUT	(TCOBASE + 0x03) /* TCO Data Out Register	*/
+#define TCO1_STS	(TCOBASE + 0x04) /* TCO1 Status Register	*/
+#define TCO2_STS	(TCOBASE + 0x06) /* TCO2 Status Register	*/
+#define TCO1_CNT	(TCOBASE + 0x08) /* TCO1 Control Register	*/
+#define TCO2_CNT	(TCOBASE + 0x0a) /* TCO2 Control Register	*/
+#define TCOv2_TMR	(TCOBASE + 0x12) /* TCOv2 Timer Initial Value	*/
 
 /* internal variables */
 static unsigned long is_active;
@@ -666,6 +666,11 @@ static int __devinit iTCO_wdt_init(struct pci_dev *pdev,
 	   GCS = RCBA + ICH6_GCS(0x3410). */
 	if (iTCO_wdt_private.iTCO_version == 2) {
 		pci_read_config_dword(pdev, 0xf0, &base_address);
+		if ((base_address & 1) == 0) {
+			printk(KERN_ERR PFX "RCBA is disabled by harddware\n");
+			ret = -ENODEV;
+			goto out;
+		}
 		RCBA = base_address & 0xffffc000;
 		iTCO_wdt_private.gcs = ioremap((RCBA + 0x3410), 4);
 	}
@@ -675,7 +680,7 @@ static int __devinit iTCO_wdt_init(struct pci_dev *pdev,
 		printk(KERN_ERR PFX "failed to reset NO_REBOOT flag, "
 					"reboot disabled by hardware\n");
 		ret = -ENODEV;	/* Cannot reset NO_REBOOT bit */
-		goto out;
+		goto out_unmap;
 	}
 
 	/* Set the NO_REBOOT bit to prevent later reboots, just for sure */
@@ -686,7 +691,7 @@ static int __devinit iTCO_wdt_init(struct pci_dev *pdev,
 		printk(KERN_ERR PFX
 			"I/O address 0x%04lx already in use\n", SMI_EN);
 		ret = -EIO;
-		goto out;
+		goto out_unmap;
 	}
 	/* Bit 13: TCO_EN -> 0 = Disables TCO logic generating an SMI# */
 	val32 = inl(SMI_EN);
@@ -742,9 +747,10 @@ unreg_region:
 	release_region(TCOBASE, 0x20);
 unreg_smi_en:
 	release_region(SMI_EN, 4);
-out:
+out_unmap:
 	if (iTCO_wdt_private.iTCO_version == 2)
 		iounmap(iTCO_wdt_private.gcs);
+out:
 	pci_dev_put(iTCO_wdt_private.pdev);
 	iTCO_wdt_private.ACPIBASE = 0;
 	return ret;
diff --git a/drivers/watchdog/indydog.c b/drivers/watchdog/indydog.c
index 0f761db..bea8a12 100644
--- a/drivers/watchdog/indydog.c
+++ b/drivers/watchdog/indydog.c
@@ -83,7 +83,6 @@ static int indydog_open(struct inode *inode, struct file *file)
 	indydog_start();
 	indydog_ping();
 
-	indydog_alive = 1;
 	printk(KERN_INFO "Started watchdog timer.\n");
 
 	return nonseekable_open(inode, file);
@@ -113,8 +112,7 @@ static long indydog_ioctl(struct file *file, unsigned int cmd,
 {
 	int options, retval = -EINVAL;
 	static struct watchdog_info ident = {
-		.options		= WDIOF_KEEPALIVEPING |
-					  WDIOF_MAGICCLOSE,
+		.options		= WDIOF_KEEPALIVEPING,
 		.firmware_version	= 0,
 		.identity		= "Hardware Watchdog for SGI IP22",
 	};
diff --git a/drivers/watchdog/it8712f_wdt.c b/drivers/watchdog/it8712f_wdt.c
index 2270ee0..daed48d 100644
--- a/drivers/watchdog/it8712f_wdt.c
+++ b/drivers/watchdog/it8712f_wdt.c
@@ -239,7 +239,8 @@ static long it8712f_wdt_ioctl(struct file *file, unsigned int cmd,
 	static struct watchdog_info ident = {
 		.identity = "IT8712F Watchdog",
 		.firmware_version = 1,
-		.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
+		.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING |
+						WDIOF_MAGICCLOSE,
 	};
 	int value;
 
diff --git a/drivers/watchdog/ks8695_wdt.c b/drivers/watchdog/ks8695_wdt.c
index ae38321..00b03eb 100644
--- a/drivers/watchdog/ks8695_wdt.c
+++ b/drivers/watchdog/ks8695_wdt.c
@@ -293,8 +293,8 @@ static int __init ks8695_wdt_init(void)
 	   if not reset to the default */
 	if (ks8695_wdt_settimeout(wdt_time)) {
 		ks8695_wdt_settimeout(WDT_DEFAULT_TIME);
-		pr_info("ks8695_wdt: wdt_time value must be 1 <= wdt_time <= %i, using %d\n",
-							wdt_time, WDT_MAX_TIME);
+		pr_info("ks8695_wdt: wdt_time value must be 1 <= wdt_time <= %i"
+					", using %d\n", wdt_time, WDT_MAX_TIME);
 	}
 	return platform_driver_register(&ks8695wdt_driver);
 }
diff --git a/drivers/watchdog/machzwd.c b/drivers/watchdog/machzwd.c
index 2dfc275..b6b3f59 100644
--- a/drivers/watchdog/machzwd.c
+++ b/drivers/watchdog/machzwd.c
@@ -118,7 +118,8 @@ static struct watchdog_info zf_info = {
  */
 static int action;
 module_param(action, int, 0);
-MODULE_PARM_DESC(action, "after watchdog resets, generate: 0 = RESET(*)  1 = SMI  2 = NMI  3 = SCI");
+MODULE_PARM_DESC(action, "after watchdog resets, generate: "
+				"0 = RESET(*)  1 = SMI  2 = NMI  3 = SCI");
 
 static void zf_ping(unsigned long data);
 
@@ -142,7 +143,8 @@ static unsigned long next_heartbeat;
 #ifndef ZF_DEBUG
 #	define dprintk(format, args...)
 #else
-#	define dprintk(format, args...) printk(KERN_DEBUG PFX ":%s:%d: " format, __func__, __LINE__ , ## args)
+#	define dprintk(format, args...) printk(KERN_DEBUG PFX
+				":%s:%d: " format, __func__, __LINE__ , ## args)
 #endif
 
 
@@ -340,7 +342,8 @@ static int zf_close(struct inode *inode, struct file *file)
 		zf_timer_off();
 	else {
 		del_timer(&zf_timer);
-		printk(KERN_ERR PFX ": device file closed unexpectedly. Will not stop the WDT!\n");
+		printk(KERN_ERR PFX ": device file closed unexpectedly. "
+						"Will not stop the WDT!\n");
 	}
 	clear_bit(0, &zf_is_open);
 	zf_expect_close = 0;
diff --git a/drivers/watchdog/mpcore_wdt.c b/drivers/watchdog/mpcore_wdt.c
index 1512ab8..83fa34b 100644
--- a/drivers/watchdog/mpcore_wdt.c
+++ b/drivers/watchdog/mpcore_wdt.c
@@ -61,7 +61,9 @@ MODULE_PARM_DESC(nowayout,
 #define ONLY_TESTING	0
 static int mpcore_noboot = ONLY_TESTING;
 module_param(mpcore_noboot, int, 0);
-MODULE_PARM_DESC(mpcore_noboot, "MPcore watchdog action, set to 1 to ignore reboots, 0 to reboot (default=" __MODULE_STRING(ONLY_TESTING) ")");
+MODULE_PARM_DESC(mpcore_noboot, "MPcore watchdog action, "
+	"set to 1 to ignore reboots, 0 to reboot (default="
+					__MODULE_STRING(ONLY_TESTING) ")");
 
 /*
  *	This is the interrupt handler.  Note that we only use this
@@ -416,7 +418,8 @@ static struct platform_driver mpcore_wdt_driver = {
 	},
 };
 
-static char banner[] __initdata = KERN_INFO "MPcore Watchdog Timer: 0.1. mpcore_noboot=%d mpcore_margin=%d sec (nowayout= %d)\n";
+static char banner[] __initdata = KERN_INFO "MPcore Watchdog Timer: 0.1. "
+		"mpcore_noboot=%d mpcore_margin=%d sec (nowayout= %d)\n";
 
 static int __init mpcore_wdt_init(void)
 {
diff --git a/drivers/watchdog/mtx-1_wdt.c b/drivers/watchdog/mtx-1_wdt.c
index 539b6f6..08e8a6a 100644
--- a/drivers/watchdog/mtx-1_wdt.c
+++ b/drivers/watchdog/mtx-1_wdt.c
@@ -206,7 +206,7 @@ static struct miscdevice mtx1_wdt_misc = {
 };
 
 
-static int mtx1_wdt_probe(struct platform_device *pdev)
+static int __devinit mtx1_wdt_probe(struct platform_device *pdev)
 {
 	int ret;
 
@@ -229,7 +229,7 @@ static int mtx1_wdt_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int mtx1_wdt_remove(struct platform_device *pdev)
+static int __devexit mtx1_wdt_remove(struct platform_device *pdev)
 {
 	/* FIXME: do we need to lock this test ? */
 	if (mtx1_wdt_device.queue) {
@@ -242,7 +242,7 @@ static int mtx1_wdt_remove(struct platform_device *pdev)
 
 static struct platform_driver mtx1_wdt = {
 	.probe = mtx1_wdt_probe,
-	.remove = mtx1_wdt_remove,
+	.remove = __devexit_p(mtx1_wdt_remove),
 	.driver.name = "mtx1-wdt",
 	.driver.owner = THIS_MODULE,
 };
diff --git a/drivers/watchdog/pnx4008_wdt.c b/drivers/watchdog/pnx4008_wdt.c
index 6413519..f24d041 100644
--- a/drivers/watchdog/pnx4008_wdt.c
+++ b/drivers/watchdog/pnx4008_wdt.c
@@ -246,7 +246,7 @@ static struct miscdevice pnx4008_wdt_miscdev = {
 	.fops = &pnx4008_wdt_fops,
 };
 
-static int pnx4008_wdt_probe(struct platform_device *pdev)
+static int __devinit pnx4008_wdt_probe(struct platform_device *pdev)
 {
 	int ret = 0, size;
 	struct resource *res;
@@ -299,7 +299,7 @@ out:
 	return ret;
 }
 
-static int pnx4008_wdt_remove(struct platform_device *pdev)
+static int __devexit pnx4008_wdt_remove(struct platform_device *pdev)
 {
 	misc_deregister(&pnx4008_wdt_miscdev);
 	if (wdt_clk) {
@@ -321,7 +321,7 @@ static struct platform_driver platform_wdt_driver = {
 		.owner	= THIS_MODULE,
 	},
 	.probe = pnx4008_wdt_probe,
-	.remove = pnx4008_wdt_remove,
+	.remove = __devexit_p(pnx4008_wdt_remove),
 };
 
 static int __init pnx4008_wdt_init(void)
diff --git a/drivers/watchdog/rdc321x_wdt.c b/drivers/watchdog/rdc321x_wdt.c
index 36e221b..4976bfd 100644
--- a/drivers/watchdog/rdc321x_wdt.c
+++ b/drivers/watchdog/rdc321x_wdt.c
@@ -245,7 +245,7 @@ static int __devinit rdc321x_wdt_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int rdc321x_wdt_remove(struct platform_device *pdev)
+static int __devexit rdc321x_wdt_remove(struct platform_device *pdev)
 {
 	if (rdc321x_wdt_device.queue) {
 		rdc321x_wdt_device.queue = 0;
@@ -259,7 +259,7 @@ static int rdc321x_wdt_remove(struct platform_device *pdev)
 
 static struct platform_driver rdc321x_wdt_driver = {
 	.probe = rdc321x_wdt_probe,
-	.remove = rdc321x_wdt_remove,
+	.remove = __devexit_p(rdc321x_wdt_remove),
 	.driver = {
 		.owner = THIS_MODULE,
 		.name = "rdc321x-wdt",
diff --git a/drivers/watchdog/rm9k_wdt.c b/drivers/watchdog/rm9k_wdt.c
index cce1982..2e44426 100644
--- a/drivers/watchdog/rm9k_wdt.c
+++ b/drivers/watchdog/rm9k_wdt.c
@@ -345,8 +345,8 @@ static const struct resource *wdt_gpi_get_resource(struct platform_device *pdv,
 	return platform_get_resource_byname(pdv, type, buf);
 }
 
-/* No hotplugging on the platform bus - use __init */
-static int __init wdt_gpi_probe(struct platform_device *pdv)
+/* No hotplugging on the platform bus - use __devinit */
+static int __devinit wdt_gpi_probe(struct platform_device *pdv)
 {
 	int res;
 	const struct resource
@@ -373,7 +373,7 @@ static int __init wdt_gpi_probe(struct platform_device *pdv)
 	return res;
 }
 
-static int __exit wdt_gpi_remove(struct platform_device *dev)
+static int __devexit wdt_gpi_remove(struct platform_device *dev)
 {
 	int res;
 
diff --git a/drivers/watchdog/s3c2410_wdt.c b/drivers/watchdog/s3c2410_wdt.c
index e31925e..b57ac6b 100644
--- a/drivers/watchdog/s3c2410_wdt.c
+++ b/drivers/watchdog/s3c2410_wdt.c
@@ -68,15 +68,10 @@ MODULE_PARM_DESC(tmr_atboot,
 			__MODULE_STRING(CONFIG_S3C2410_WATCHDOG_ATBOOT));
 MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default="
 			__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
-MODULE_PARM_DESC(soft_noboot, "Watchdog action, set to 1 to ignore reboots, 0 to reboot (default depends on ONLY_TESTING)");
+MODULE_PARM_DESC(soft_noboot, "Watchdog action, set to 1 to ignore reboots, "
+			"0 to reboot (default depends on ONLY_TESTING)");
 MODULE_PARM_DESC(debug, "Watchdog debug, set to >1 for debug, (default 0)");
 
-
-typedef enum close_state {
-	CLOSE_STATE_NOT,
-	CLOSE_STATE_ALLOW = 0x4021
-} close_state_t;
-
 static unsigned long open_lock;
 static struct device    *wdt_dev;	/* platform device attached to */
 static struct resource	*wdt_mem;
@@ -84,7 +79,7 @@ static struct resource	*wdt_irq;
 static struct clk	*wdt_clock;
 static void __iomem	*wdt_base;
 static unsigned int	 wdt_count;
-static close_state_t	 allow_close;
+static char		 expect_close;
 static DEFINE_SPINLOCK(wdt_lock);
 
 /* watchdog control routines */
@@ -211,7 +206,7 @@ static int s3c2410wdt_open(struct inode *inode, struct file *file)
 	if (nowayout)
 		__module_get(THIS_MODULE);
 
-	allow_close = CLOSE_STATE_NOT;
+	expect_close = 0;
 
 	/* start the timer */
 	s3c2410wdt_start();
@@ -225,13 +220,13 @@ static int s3c2410wdt_release(struct inode *inode, struct file *file)
 	 * 	Lock it in if it's a module and we set nowayout
 	 */
 
-	if (allow_close == CLOSE_STATE_ALLOW)
+	if (expect_close == 42)
 		s3c2410wdt_stop();
 	else {
 		dev_err(wdt_dev, "Unexpected close, not stopping watchdog\n");
 		s3c2410wdt_keepalive();
 	}
-	allow_close = CLOSE_STATE_NOT;
+	expect_close = 0;
 	clear_bit(0, &open_lock);
 	return 0;
 }
@@ -247,7 +242,7 @@ static ssize_t s3c2410wdt_write(struct file *file, const char __user *data,
 			size_t i;
 
 			/* In case it was set long ago */
-			allow_close = CLOSE_STATE_NOT;
+			expect_close = 0;
 
 			for (i = 0; i != len; i++) {
 				char c;
@@ -255,7 +250,7 @@ static ssize_t s3c2410wdt_write(struct file *file, const char __user *data,
 				if (get_user(c, data + i))
 					return -EFAULT;
 				if (c == 'V')
-					allow_close = CLOSE_STATE_ALLOW;
+					expect_close = 42;
 			}
 		}
 		s3c2410wdt_keepalive();
@@ -263,7 +258,7 @@ static ssize_t s3c2410wdt_write(struct file *file, const char __user *data,
 	return len;
 }
 
-#define OPTIONS WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING | WDIOF_MAGICCLOSE
+#define OPTIONS (WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING | WDIOF_MAGICCLOSE)
 
 static const struct watchdog_info s3c2410_wdt_ident = {
 	.options          =     OPTIONS,
@@ -331,7 +326,7 @@ static irqreturn_t s3c2410wdt_irq(int irqno, void *param)
 }
 /* device interface */
 
-static int s3c2410wdt_probe(struct platform_device *pdev)
+static int __devinit s3c2410wdt_probe(struct platform_device *pdev)
 {
 	struct resource *res;
 	struct device *dev;
@@ -404,7 +399,8 @@ static int s3c2410wdt_probe(struct platform_device *pdev)
 			   "tmr_margin value out of range, default %d used\n",
 			       CONFIG_S3C2410_WATCHDOG_DEFAULT_TIME);
 		else
-			dev_info(dev, "default timer value is out of range, cannot start\n");
+			dev_info(dev, "default timer value is out of range, "
+							"cannot start\n");
 	}
 
 	ret = misc_register(&s3c2410wdt_miscdev);
@@ -453,7 +449,7 @@ static int s3c2410wdt_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int s3c2410wdt_remove(struct platform_device *dev)
+static int __devexit s3c2410wdt_remove(struct platform_device *dev)
 {
 	release_resource(wdt_mem);
 	kfree(wdt_mem);
@@ -515,7 +511,7 @@ static int s3c2410wdt_resume(struct platform_device *dev)
 
 static struct platform_driver s3c2410wdt_driver = {
 	.probe		= s3c2410wdt_probe,
-	.remove		= s3c2410wdt_remove,
+	.remove		= __devexit_p(s3c2410wdt_remove),
 	.shutdown	= s3c2410wdt_shutdown,
 	.suspend	= s3c2410wdt_suspend,
 	.resume		= s3c2410wdt_resume,
diff --git a/drivers/watchdog/sb_wdog.c b/drivers/watchdog/sb_wdog.c
index 38f5831..9748eed 100644
--- a/drivers/watchdog/sb_wdog.c
+++ b/drivers/watchdog/sb_wdog.c
@@ -93,7 +93,7 @@ static int expect_close;
 
 static const struct watchdog_info ident = {
 	.options	= WDIOF_CARDRESET | WDIOF_SETTIMEOUT |
-						WDIOF_KEEPALIVEPING,
+					WDIOF_KEEPALIVEPING | WDIOF_MAGICCLOSE,
 	.identity	= "SiByte Watchdog",
 };
 
@@ -269,9 +269,10 @@ irqreturn_t sbwdog_interrupt(int irq, void *addr)
 	 * if it's the second watchdog timer, it's for those users
 	 */
 	if (wd_cfg_reg == user_dog)
-		printk(KERN_CRIT
-			"%s in danger of initiating system reset in %ld.%01ld seconds\n",
-			ident.identity, wd_init / 1000000, (wd_init / 100000) % 10);
+		printk(KERN_CRIT "%s in danger of initiating system reset "
+			"in %ld.%01ld seconds\n",
+			ident.identity,
+			wd_init / 1000000, (wd_init / 100000) % 10);
 	else
 		cfg |= 1;
 
diff --git a/drivers/watchdog/sbc60xxwdt.c b/drivers/watchdog/sbc60xxwdt.c
index d1c390c..626d0e8 100644
--- a/drivers/watchdog/sbc60xxwdt.c
+++ b/drivers/watchdog/sbc60xxwdt.c
@@ -372,8 +372,9 @@ static int __init sbc60xxwdt_init(void)
 						wdt_miscdev.minor, rc);
 		goto err_out_reboot;
 	}
-	printk(KERN_INFO PFX "WDT driver for 60XX single board computer initialised. timeout=%d sec (nowayout=%d)\n",
-		timeout, nowayout);
+	printk(KERN_INFO PFX
+		"WDT driver for 60XX single board computer initialised. "
+		"timeout=%d sec (nowayout=%d)\n", timeout, nowayout);
 
 	return 0;
 
diff --git a/drivers/watchdog/sbc8360.c b/drivers/watchdog/sbc8360.c
index b6e6799..68e2e2d 100644
--- a/drivers/watchdog/sbc8360.c
+++ b/drivers/watchdog/sbc8360.c
@@ -280,8 +280,8 @@ static int sbc8360_close(struct inode *inode, struct file *file)
 	if (expect_close == 42)
 		sbc8360_stop();
 	else
-		printk(KERN_CRIT PFX
-			"SBC8360 device closed unexpectedly.  SBC8360 will not stop!\n");
+		printk(KERN_CRIT PFX "SBC8360 device closed unexpectedly.  "
+						"SBC8360 will not stop!\n");
 
 	clear_bit(0, &sbc8360_is_open);
 	expect_close = 0;
diff --git a/drivers/watchdog/sbc_epx_c3.c b/drivers/watchdog/sbc_epx_c3.c
index e467ddc..28f1214 100644
--- a/drivers/watchdog/sbc_epx_c3.c
+++ b/drivers/watchdog/sbc_epx_c3.c
@@ -107,8 +107,7 @@ static long epx_c3_ioctl(struct file *file, unsigned int cmd,
 	int options, retval = -EINVAL;
 	int __user *argp = (void __user *)arg;
 	static const struct watchdog_info ident = {
-		.options		= WDIOF_KEEPALIVEPING |
-					  WDIOF_MAGICCLOSE,
+		.options		= WDIOF_KEEPALIVEPING,
 		.firmware_version	= 0,
 		.identity		= "Winsystems EPX-C3 H/W Watchdog",
 	};
@@ -174,8 +173,8 @@ static struct notifier_block epx_c3_notifier = {
 	.notifier_call = epx_c3_notify_sys,
 };
 
-static const char banner[] __initdata =
-    KERN_INFO PFX "Hardware Watchdog Timer for Winsystems EPX-C3 SBC: 0.1\n";
+static const char banner[] __initdata = KERN_INFO PFX
+	"Hardware Watchdog Timer for Winsystems EPX-C3 SBC: 0.1\n";
 
 static int __init watchdog_init(void)
 {
@@ -219,6 +218,9 @@ module_init(watchdog_init);
 module_exit(watchdog_exit);
 
 MODULE_AUTHOR("Calin A. Culianu <calin@ajvar.org>");
-MODULE_DESCRIPTION("Hardware Watchdog Device for Winsystems EPX-C3 SBC.  Note that there is no way to probe for this device -- so only use it if you are *sure* you are runnning on this specific SBC system from Winsystems!  It writes to IO ports 0x1ee and 0x1ef!");
+MODULE_DESCRIPTION("Hardware Watchdog Device for Winsystems EPX-C3 SBC.  "
+	"Note that there is no way to probe for this device -- "
+	"so only use it if you are *sure* you are runnning on this specific "
+	"SBC system from Winsystems!  It writes to IO ports 0x1ee and 0x1ef!");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
diff --git a/drivers/watchdog/scx200_wdt.c b/drivers/watchdog/scx200_wdt.c
index 9e19a10..e67b76c 100644
--- a/drivers/watchdog/scx200_wdt.c
+++ b/drivers/watchdog/scx200_wdt.c
@@ -108,7 +108,9 @@ static int scx200_wdt_open(struct inode *inode, struct file *file)
 static int scx200_wdt_release(struct inode *inode, struct file *file)
 {
 	if (expect_close != 42)
-		printk(KERN_WARNING NAME ": watchdog device closed unexpectedly, will not disable the watchdog timer\n");
+		printk(KERN_WARNING NAME
+			": watchdog device closed unexpectedly, "
+			"will not disable the watchdog timer\n");
 	else if (!nowayout)
 		scx200_wdt_disable();
 	expect_close = 0;
@@ -163,7 +165,8 @@ static long scx200_wdt_ioctl(struct file *file, unsigned int cmd,
 	static const struct watchdog_info ident = {
 		.identity = "NatSemi SCx200 Watchdog",
 		.firmware_version = 1,
-		.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
+		.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING |
+						WDIOF_MAGICCLOSE,
 	};
 	int new_margin;
 
diff --git a/drivers/watchdog/shwdt.c b/drivers/watchdog/shwdt.c
index cdc7138..a03f84e 100644
--- a/drivers/watchdog/shwdt.c
+++ b/drivers/watchdog/shwdt.c
@@ -494,7 +494,9 @@ MODULE_LICENSE("GPL");
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
 
 module_param(clock_division_ratio, int, 0);
-MODULE_PARM_DESC(clock_division_ratio, "Clock division ratio. Valid ranges are from 0x5 (1.31ms) to 0x7 (5.25ms). (default=" __MODULE_STRING(clock_division_ratio) ")");
+MODULE_PARM_DESC(clock_division_ratio,
+	"Clock division ratio. Valid ranges are from 0x5 (1.31ms) "
+	"to 0x7 (5.25ms). (default=" __MODULE_STRING(clock_division_ratio) ")");
 
 module_param(heartbeat, int, 0);
 MODULE_PARM_DESC(heartbeat,
diff --git a/drivers/watchdog/softdog.c b/drivers/watchdog/softdog.c
index ebcc9ce..833f49f 100644
--- a/drivers/watchdog/softdog.c
+++ b/drivers/watchdog/softdog.c
@@ -71,7 +71,9 @@ static int soft_noboot = 0;
 #endif  /* ONLY_TESTING */
 
 module_param(soft_noboot, int, 0);
-MODULE_PARM_DESC(soft_noboot, "Softdog action, set to 1 to ignore reboots, 0 to reboot (default depends on ONLY_TESTING)");
+MODULE_PARM_DESC(soft_noboot,
+	"Softdog action, set to 1 to ignore reboots, 0 to reboot "
+					"(default depends on ONLY_TESTING)");
 
 /*
  *	Our timer
@@ -264,7 +266,8 @@ static struct notifier_block softdog_notifier = {
 	.notifier_call	= softdog_notify_sys,
 };
 
-static char banner[] __initdata = KERN_INFO "Software Watchdog Timer: 0.07 initialized. soft_noboot=%d soft_margin=%d sec (nowayout= %d)\n";
+static char banner[] __initdata = KERN_INFO "Software Watchdog Timer: 0.07 "
+	"initialized. soft_noboot=%d soft_margin=%d sec (nowayout= %d)\n";
 
 static int __init watchdog_init(void)
 {
diff --git a/drivers/watchdog/w83697hf_wdt.c b/drivers/watchdog/w83697hf_wdt.c
index a9c7f35..af08972 100644
--- a/drivers/watchdog/w83697hf_wdt.c
+++ b/drivers/watchdog/w83697hf_wdt.c
@@ -413,7 +413,8 @@ static int __init wdt_init(void)
 	w83697hf_init();
 	if (early_disable) {
 		if (wdt_running())
-			printk(KERN_WARNING PFX "Stopping previously enabled watchdog until userland kicks in\n");
+			printk(KERN_WARNING PFX "Stopping previously enabled "
+					"watchdog until userland kicks in\n");
 		wdt_disable();
 	}
 
diff --git a/drivers/watchdog/wdrtas.c b/drivers/watchdog/wdrtas.c
index a38fa49..a4fe7a3 100644
--- a/drivers/watchdog/wdrtas.c
+++ b/drivers/watchdog/wdrtas.c
@@ -49,12 +49,7 @@ MODULE_LICENSE("GPL");
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
 MODULE_ALIAS_MISCDEV(TEMP_MINOR);
 
-#ifdef CONFIG_WATCHDOG_NOWAYOUT
-static int wdrtas_nowayout = 1;
-#else
-static int wdrtas_nowayout = 0;
-#endif
-
+static int wdrtas_nowayout = WATCHDOG_NOWAYOUT;
 static atomic_t wdrtas_miscdev_open = ATOMIC_INIT(0);
 static char wdrtas_expect_close;
 
