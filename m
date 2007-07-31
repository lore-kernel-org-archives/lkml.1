Return-Path: <linux-kernel-owner+w=401wt.eu-S1760584AbXGaTpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760584AbXGaTpl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 15:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759683AbXGaTp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 15:45:27 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:5012 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756129AbXGaTpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 15:45:15 -0400
Date: Tue, 31 Jul 2007 21:48:49 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: WATCHDOG] v2.6.23 patches 2
Message-ID: <20070731194849.GA9105@infomag.infomag.iguana.be>
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

 MAINTAINERS                          |    8 
 arch/powerpc/boot/dts/prpmc2800.dts  |    6 
 arch/powerpc/sysdev/mv64x60_dev.c    |   64 ++++
 arch/ppc/syslib/mv64x60.c            |   29 ++
 drivers/Makefile                     |    1 
 drivers/char/Makefile                |    1 
 drivers/char/watchdog/Kconfig        |  117 ++++++--
 drivers/char/watchdog/Makefile       |   43 ++-
 drivers/char/watchdog/bfin_wdt.c     |  490 +++++++++++++++++++++++++++++++++++
 drivers/char/watchdog/booke_wdt.c    |    2 
 drivers/char/watchdog/cpu5wdt.c      |    4 
 drivers/char/watchdog/davinci_wdt.c  |  281 ++++++++++++++++++++
 drivers/char/watchdog/iTCO_wdt.c     |   38 ++
 drivers/char/watchdog/machzwd.c      |    1 
 drivers/char/watchdog/mixcomwd.c     |    5 
 drivers/char/watchdog/mpc5200_wdt.c  |  286 ++++++++++++++++++++
 drivers/char/watchdog/mpc83xx_wdt.c  |    3 
 drivers/char/watchdog/mpc8xx_wdt.c   |    2 
 drivers/char/watchdog/mtx-1_wdt.c    |    1 
 drivers/char/watchdog/mv64x60_wdt.c  |  218 ++++++++++-----
 drivers/char/watchdog/omap_wdt.c     |    4 
 drivers/char/watchdog/s3c2410_wdt.c  |    6 
 drivers/char/watchdog/sa1100_wdt.c   |    3 
 drivers/char/watchdog/sbc60xxwdt.c   |    4 
 drivers/char/watchdog/sc1200wdt.c    |    4 
 drivers/char/watchdog/sc520_wdt.c    |    4 
 drivers/char/watchdog/w83627hf_wdt.c |   24 +
 include/asm-ppc/mv64x60.h            |    8 
 include/linux/mv643xx.h              |    8 
 29 files changed, 1509 insertions(+), 156 deletions(-)

with these Changes:

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Sun Jul 29 18:46:50 2007 +0000

    [WATCHDOG] Fix pcwd_init_module crash
    
    Fix for the problem detected by Ingo Molnar:
    enabling CONFIG_PCWATCHDOG=y crashes bzImage bootup.
    
    The reason for this can be found in drivers/makefile
    We first do:
    obj-y                           += char/
    and later we do:
    obj-y                           += base/ block/ misc/ mfd/ net/ media/
    
    So if we put a platform or isa or usb bus driver in char/watchdog
    (which is called from the Makefile in drivers/char/Makefile)
    then we didn't have the different device drivers initialized yet
    (they are in drivers/base and drivers/usb and ...)
    
    This fix makes sure that we compile the watchdog drivers after
    drivers/base, drivers/misc, drivers/pci and drivers/usb.
    We also do the compile after hwmon because in the future the
    watchdog temperature support will use the hwmon system.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Thu Jul 26 21:11:28 2007 +0000

    [WATCHDOG] ICH9 support for iTCO_wdt
    
    Add support for the ICH9 I/O chipsets to iTCO_wdt.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Thu Jul 26 20:43:50 2007 +0000

    [WATCHDOG] 631xESB/632xESB support for iTCO_wdt - add all LPC bridges
    
    Add all LPC bridges for the 631xESB/632xESB I/O chipset.
    The datasheet says:
    * Device Function = B0:D31:FO
    * Function Description = LPC interface
    * DEV ID = 267xh
    * Comment = 2670h-267Fh
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Sergey Kononenko <sergk@sergk.org.ua>
Date:   Thu Jul 26 17:28:35 2007 +0300

    [WATCHDOG] 631xESB/632xESB support for iTCO_wdt
    
    Add 631xESB/632xESB support to the iTCO_wdt driver.
    
    Signed-off-by: Sergey Kononenko <sergk@sergk.org.ua>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Tue Jul 24 21:55:06 2007 +0000

    [WATCHDOG] omap_wdt.c - default error for IOCTL is -ENOTTY
    
    The default value for an unknown ioctl call is -ENOTTY.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Tue Jul 24 21:38:37 2007 +0000

    [WATCHDOG] Return value of nonseekable_open
    
    Return the value of the nonseekable_open function and not 0.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Dale Farnsworth <dale@farnsworth.org>
Date:   Tue Jul 24 11:31:25 2007 -0700

    [WATCHDOG] mv64x60_wdt: Rework the timeout register manipulation
    
    Consolidate the timeout config register modification into a single
    function.  Also, use the enabled flag in the config register to
    determine whether the timer is enabled instead of a separately
    maintained flag, MV64x60_WDOG_FLAG_ENABLED.
    
    Add spinlock protection around enabling/disabling the watchdog timer.
    
    Signed-off-by: Dale Farnsworth <dale@farnsworth.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Dale Farnsworth <dale@farnsworth.org>
Date:   Tue Jul 24 11:19:47 2007 -0700

    [WATCHDOG] mv64x60_wdt: disable watchdog timer when driver is probed
    
    Make sure that we disable the watchdog at start-up.
    
    Signed-off-by: Dale Farnsworth <dale@farnsworth.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Dale Farnsworth <dale@farnsworth.org>
Date:   Tue Jul 24 11:18:14 2007 -0700

    [WATCHDOG] mv64x60_wdt: Support the WDIOF_MAGICCLOSE feature
    
    Disallow disabling of the watchdog timer unless a particular
    character ('V') was recently written to the watchdog device.
    
    Signed-off-by: Dale Farnsworth <dale@farnsworth.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Dale Farnsworth <dale@farnsworth.org>
Date:   Tue Jul 24 11:17:23 2007 -0700

    [WATCHDOG] mv64x60_wdt: Add a module parameter to change nowayout setting
    
    Also, use the WATCHDOG_NOWAYOUT macro, rather than #ifdefs,
    and use __module_get to prevent module unloading if WATCHDOG_NOWAYOUT
    is set.
    
    Signed-off-by: Dale Farnsworth <dale@farnsworth.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Dale Farnsworth <dale@farnsworth.org>
Date:   Tue Jul 24 11:16:29 2007 -0700

    [WATCHDOG] mv64x60_wdt: Add WDIOC_SETOPTIONS ioctl support
    
    Allow the watchdog timer to be enabled or disabled via the
    WDIOC_SETOPTIONS ioctl.
    
    Signed-off-by: Dale Farnsworth <dale@farnsworth.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Dale Farnsworth <dale@farnsworth.org>
Date:   Tue Jul 24 11:15:26 2007 -0700

    [WATCHDOG] mv64x60_wdt: Support for WDIOC_SETTIMEOUT ioctl
    
    Add the ability to modify the watchdog timer timeout interval.
    
    Signed-off-by: Dale Farnsworth <dale@farnsworth.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Dale Farnsworth <dale@farnsworth.org>
Date:   Tue Jul 24 11:14:21 2007 -0700

    [WATCHDOG] mv64x60_wdt: Fix WDIOC_GETTIMEOUT return value
    
    WDIOC_GETTIMEOUT returns seconds, not jiffies.
    
    Signed-off-by: Dale Farnsworth <dale@farnsworth.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Dale Farnsworth <dale@farnsworth.org>
Date:   Tue Jul 24 11:13:26 2007 -0700

    [WATCHDOG] mv64x60_wdt: Check return value of nonseekable_open
    
    Return the value of the nonseekable_open function and not 0.
    
    Signed-off-by: Dale Farnsworth <dale@farnsworth.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Dale Farnsworth <dale@farnsworth.org>
Date:   Tue Jul 24 11:12:24 2007 -0700

    [WATCHDOG] mv64x60_wdt: Add arch/powerpc platform support
    
    Add support for arch/powerpc, specifically for the prpmc2800 platform.
    
    Signed-off-by: Dale Farnsworth <dale@farnsworth.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Dale Farnsworth <dale@farnsworth.org>
Date:   Tue Jul 24 11:09:18 2007 -0700

    [WATCHDOG] mv64x60_wdt: Get register address from platform data
    
    Previously, the address of the watchdog timer registers was
    retrieved by calling a global function, mv64x60_get_bridge_vbase().
    That function doesn't exist in arch/powerpc.  Instead, we now get
    the register address from a platform data resource and ioremap
    the registers within the driver.
    
    Signed-off-by: Dale Farnsworth <dale@farnsworth.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Dale Farnsworth <dale@farnsworth.org>
Date:   Tue Jul 24 11:07:38 2007 -0700

    [WATCHDOG] mv64x60_wdt: set up platform_device in platform code
    
    The driver previously registered its platform device data in its own
    init function--that's bogus.  Move that code to platform-specific
    code in arch/ppc.  This is being done so that the platform code can
    decide at runtime whether to initialize this driver or not.
    
    Signed-off-by: Dale Farnsworth <dale@farnsworth.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Pádraig Brady <P@draigBrady.com>
Date:   Tue Jul 24 11:49:27 2007 +0100

    [WATCHDOG] ensure mouse and keyboard ignored in w83627hf_wdt
    
    1. Ensure that the mouse and keyboard do not ping the watchdog.
    This is the default operation of the w83627, but some BIOSes change this.
    
    2. Increase the max timeout from 63 seconds to 255 seconds
    as supported by the w83627 chip
    
    3. Comment that the watchdog supports the w83627hg version of the chip
    
    Signed-Off-By: Pádraig Brady <P@draigBrady.com>
    Tested-by: Tomas Hodek <tomas.hodek@volny.cz>
    Signed-Off-By: Wim Van Sebroeck <wim@iguana.be>

Author: Ben Dooks <ben-linux@fluff.org>
Date:   Tue Jul 24 13:28:01 2007 +0100

    [WATCHDOG] s3c2410_wdt: fixup after arch include moves
    
    Fixup the s3c2410 watchdog driver after moving some
    of the arch specific includes it has been relying on.
    
    Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Author: Andrew Morton <akpm@linux-foundation.org>
Date:   Tue Jul 24 00:07:27 2007 -0700

    [WATCHDOG] git-watchdog-typo
    From: Andrew Morton <akpm@linux-foundation.org>
    
    This driver isn't very coding-style friendly.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Fri Jul 20 20:13:43 2007 +0000

    [WATCHDOG] Clean-up Kconfig+Makefile
    
    Clean-up of the watchdog's Kconfig and makefile files.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Sat Jul 21 13:42:18 2007 +0000

    [WATCHDOG] WDIOC_GETSTATUS and WDIOC_GETBOOTSTATUS clean-up
    
    Add mandatory WDIOC_GETSTATUS and WDIOC_GETBOOTSTATUS ioctl's for
    drivers that don't have them yet.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Fri Jul 20 20:41:37 2007 +0000

    [WATCHDOG] VFS clean-up
    
    All watchdog device drivers are VFSs (Virtual File Systems).
    We thus return a nonseekable_open(inode, file) when we open the VFS.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Fri Jul 20 21:47:55 2007 +0000

    [WATCHDOG] davinci_wdt clean-up
    
    * Remove the redundant check for pwrite(), given that the open() routine
      already invokes nonseekable_open().
    * The WDIOF_CARDRESET flag can only be used when you can read this status
      via the WDIOC_GETSTATUS ioctl call.
    * Add the mandatory WDIOC_GETBOOTSTATUS ioctl call.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Fri Jul 20 21:22:58 2007 +0000

    [WATCHDOG] mpc5200_wdt clean-up
    
    * Add MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
    * Add mandatory WDIOC_GETSTATUS and WDIOC_GETBOOTSTATUS ioctl's.
    * If unknown ioctl is used we should return -ENOTTY.
    * All watchdog device drivers are VFSs (Virtual File Systems).
      We thus return a nonseekable_open(inode, file) when we open the VFS.
    * Make sure that /dev/watchdog can be opened by 1 parent
    * Add spin-locking to prevent that forked children can disturb
      each other's operations.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Vladimir Barinov <vbarinov@ru.mvista.com>
Date:   Tue Jun 12 18:09:50 2007 +0400

    [WATCHDOG] davinci watchdog driver
    
    Add watchdog support for TI Davinci DM644x/DM646x processors.
    
    Signed-off-by: Vladimir Barinov <vbarinov@ru.mvista.com>
    Signed-off-by: Kevin Hilman <khilman@mvista.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Bryan Wu <bryan.wu@analog.com>
Date:   Sun Jul 15 02:50:02 2007 +0800

    [WATCHDOG] Blackfin on-chip watchdog driver
    
    This patch implements the driver necessary use the Analog Devices
    Blackfin processor's on-chip watchdog controller, supports
    BF53[123]/BF53[467]/BF54[2489]/BF561.
    
    Signed-off-by: Mike Frysinger <michael.frysinger@analog.com>
    Signed-off-by: Bryan Wu <bryan.wu@analog.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Domen Puncer <domen.puncer@telargo.com>
Date:   Mon Jun 18 08:17:57 2007 +0200

    [WATCHDOG] mpc5200 watchdog (GPT0)
    
    Driver for internal mpc5200 watchdog on general purpose timer 0.
    For IPB clock of 132 MHz the maximum timeout is about 32 seconds.
    
    Signed-off-by: Domen Puncer <domen.puncer@telargo.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/MAINTAINERS b/MAINTAINERS
index 01f222e..2ca352b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -771,6 +771,14 @@ L:	uclinux-dist-devel@blackfin.uclinux.org (subscribers-only)
 W:	http://blackfin.uclinux.org
 S:	Supported
 
+BLACKFIN WATCHDOG DRIVER
+P:	Mike Frysinger
+M:	michael.frysinger@analog.com
+M:	vapier.adi@gmail.com
+L:	uclinux-dist-devel@blackfin.uclinux.org (subscribers-only)
+W:	http://blackfin.uclinux.org
+S:	Supported
+
 BAYCOM/HDLCDRV DRIVERS FOR AX.25
 P:	Thomas Sailer
 M:	t.sailer@alumni.ethz.ch
diff --git a/arch/powerpc/boot/dts/prpmc2800.dts b/arch/powerpc/boot/dts/prpmc2800.dts
index 699d0df..5300b50 100644
--- a/arch/powerpc/boot/dts/prpmc2800.dts
+++ b/arch/powerpc/boot/dts/prpmc2800.dts
@@ -207,6 +207,12 @@
 			interrupt-parent = <&/mv64x60/pic>;
 		};
 
+		wdt@b410 {			/* watchdog timer */
+			compatible = "marvell,mv64x60-wdt";
+			reg = <b410 8>;
+			timeout = <a>;		/* wdt timeout in seconds */
+		};
+
 		i2c@c000 {
 			device_type = "i2c";
 			compatible = "marvell,mv64x60-i2c";
diff --git a/arch/powerpc/sysdev/mv64x60_dev.c b/arch/powerpc/sysdev/mv64x60_dev.c
index b618fa6..548a320 100644
--- a/arch/powerpc/sysdev/mv64x60_dev.c
+++ b/arch/powerpc/sysdev/mv64x60_dev.c
@@ -390,6 +390,61 @@ error:
 	return err;
 }
 
+/*
+ * Create mv64x60_wdt platform devices
+ */
+static int __init mv64x60_wdt_device_setup(struct device_node *np, int id)
+{
+	struct resource r;
+	struct platform_device *pdev;
+	struct mv64x60_wdt_pdata pdata;
+	const unsigned int *prop;
+	int err;
+
+	err = of_address_to_resource(np, 0, &r);
+	if (err)
+		return err;
+
+	memset(&pdata, 0, sizeof(pdata));
+
+	prop = of_get_property(np, "timeout", NULL);
+	if (!prop)
+		return -ENODEV;
+	pdata.timeout = *prop;
+
+	np = of_get_parent(np);
+	if (!np)
+		return -ENODEV;
+
+	prop = of_get_property(np, "clock-frequency", NULL);
+	of_node_put(np);
+	if (!prop)
+		return -ENODEV;
+	pdata.bus_clk = *prop / 1000000; /* wdt driver wants freq in MHz */
+
+	pdev = platform_device_alloc(MV64x60_WDT_NAME, id);
+	if (!pdev)
+		return -ENOMEM;
+
+	err = platform_device_add_resources(pdev, &r, 1);
+	if (err)
+		goto error;
+
+	err = platform_device_add_data(pdev, &pdata, sizeof(pdata));
+	if (err)
+		goto error;
+
+	err = platform_device_add(pdev);
+	if (err)
+		goto error;
+
+	return 0;
+
+error:
+	platform_device_put(pdev);
+	return err;
+}
+
 static int __init mv64x60_device_setup(void)
 {
 	struct device_node *np = NULL;
@@ -414,6 +469,15 @@ static int __init mv64x60_device_setup(void)
 		if ((err = mv64x60_i2c_device_setup(np, id)))
 			goto error;
 
+	/* support up to one watchdog timer */
+	np = of_find_compatible_node(np, NULL, "marvell,mv64x60-wdt");
+	if (np) {
+		if ((err = mv64x60_wdt_device_setup(np, id)))
+			goto error;
+		of_node_put(np);
+	}
+
+
 	return 0;
 
 error:
diff --git a/arch/ppc/syslib/mv64x60.c b/arch/ppc/syslib/mv64x60.c
index d212b1c..2744b8a 100644
--- a/arch/ppc/syslib/mv64x60.c
+++ b/arch/ppc/syslib/mv64x60.c
@@ -441,6 +441,32 @@ static struct platform_device i2c_device = {
 };
 #endif
 
+#ifdef CONFIG_WATCHDOG
+static struct mv64x60_wdt_pdata mv64x60_wdt_pdata = {
+	.timeout		= 10,  /* default watchdog expiry in seconds */
+	.bus_clk		= 133, /* default bus clock in MHz */
+};
+
+static struct resource mv64x60_wdt_resources[] = {
+	[0] = {
+		.name	= "mv64x60 wdt base",
+		.start	= MV64x60_WDT_WDC,
+		.end	= MV64x60_WDT_WDC + 8 - 1, /* two 32-bit registers */
+		.flags	= IORESOURCE_MEM,
+	},
+};
+
+static struct platform_device wdt_device = {
+	.name		= MV64x60_WDT_NAME,
+	.id		= 0,
+	.num_resources	= ARRAY_SIZE(mv64x60_wdt_resources),
+	.resource	= mv64x60_wdt_resources,
+	.dev = {
+		.platform_data = &mv64x60_wdt_pdata,
+	},
+};
+#endif
+
 #if defined(CONFIG_SYSFS) && !defined(CONFIG_GT64260)
 static struct mv64xxx_pdata mv64xxx_pdata = {
 	.hs_reg_valid	= 0,
@@ -476,6 +502,9 @@ static struct platform_device *mv64x60_pd_devs[] __initdata = {
 #ifdef	CONFIG_I2C_MV64XXX
 	&i2c_device,
 #endif
+#ifdef	CONFIG_MV64X60_WDT
+	&wdt_device,
+#endif
 #if defined(CONFIG_SYSFS) && !defined(CONFIG_GT64260)
 	&mv64xxx_device,
 #endif
diff --git a/drivers/Makefile b/drivers/Makefile
index a9e4c5f..f0878b2 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -66,6 +66,7 @@ obj-y				+= i2c/
 obj-$(CONFIG_W1)		+= w1/
 obj-$(CONFIG_POWER_SUPPLY)	+= power/
 obj-$(CONFIG_HWMON)		+= hwmon/
+obj-$(CONFIG_WATCHDOG)		+= char/watchdog/
 obj-$(CONFIG_PHONE)		+= telephony/
 obj-$(CONFIG_MD)		+= md/
 obj-$(CONFIG_BT)		+= bluetooth/
diff --git a/drivers/char/Makefile b/drivers/char/Makefile
index 8fecaf4..2bc3a55 100644
--- a/drivers/char/Makefile
+++ b/drivers/char/Makefile
@@ -97,7 +97,6 @@ obj-$(CONFIG_GPIO_VR41XX)	+= vr41xx_giu.o
 obj-$(CONFIG_GPIO_TB0219)	+= tb0219.o
 obj-$(CONFIG_TELCLOCK)		+= tlclk.o
 
-obj-$(CONFIG_WATCHDOG)		+= watchdog/
 obj-$(CONFIG_MWAVE)		+= mwave/
 obj-$(CONFIG_AGP)		+= agp/
 obj-$(CONFIG_DRM)		+= drm/
diff --git a/drivers/char/watchdog/Kconfig b/drivers/char/watchdog/Kconfig
index 16fb231..37bddc1 100644
--- a/drivers/char/watchdog/Kconfig
+++ b/drivers/char/watchdog/Kconfig
@@ -55,6 +55,8 @@ config SOFT_WATCHDOG
 	  To compile this driver as a module, choose M here: the
 	  module will be called softdog.
 
+# ALPHA Architecture
+
 # ARM Architecture
 
 config AT91RM9200_WATCHDOG
@@ -189,7 +191,7 @@ config PNX4008_WATCHDOG
 
 config IOP_WATCHDOG
 	tristate "IOP Watchdog"
-	depends on WATCHDOG && PLAT_IOP
+	depends on PLAT_IOP
 	select WATCHDOG_NOWAYOUT if (ARCH_IOP32X || ARCH_IOP33X)
 	help
 	  Say Y here if to include support for the watchdog timer
@@ -203,15 +205,48 @@ config IOP_WATCHDOG
 	  operating as an Root Complex and/or Central Resource, the PCI-X
 	  and/or PCIe busses will also be reset.  THIS IS A VERY BIG HAMMER.
 
+config DAVINCI_WATCHDOG
+	tristate "DaVinci watchdog"
+	depends on ARCH_DAVINCI
+	help
+	  Say Y here if to include support for the watchdog timer
+	  in the DaVinci DM644x/DM646x processors.
+	  To compile this driver as a module, choose M here: the
+	  module will be called davinci_wdt.
+
+	  NOTE: once enabled, this timer cannot be disabled.
+	  Say N if you are unsure.
+
+# ARM26 Architecture
+
 # AVR32 Architecture
 
 config AT32AP700X_WDT
 	tristate "AT32AP700x watchdog"
-	depends on WATCHDOG && CPU_AT32AP7000
+	depends on CPU_AT32AP7000
 	help
 	  Watchdog timer embedded into AT32AP700x devices. This will reboot
 	  your system when the timeout is reached.
 
+# BLACKFIN Architecture
+
+config BFIN_WDT
+	tristate "Blackfin On-Chip Watchdog Timer"
+	depends on BLACKFIN
+	---help---
+	  If you say yes here you will get support for the Blackfin On-Chip
+	  Watchdog Timer. If you have one of these processors and wish to
+	  have watchdog support enabled, say Y, otherwise say N.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called bfin_wdt.
+
+# CRIS Architecture
+
+# FRV Architecture
+
+# H8300 Architecture
+
 # X86 (i386 + ia64 + x86_64) Architecture
 
 config ACQUIRE_WDT
@@ -540,37 +575,11 @@ config SBC_EPX_C3_WATCHDOG
 	  To compile this driver as a module, choose M here: the
 	  module will be called sbc_epx_c3.
 
-# PowerPC Architecture
+# M32R Architecture
 
-config 8xx_WDT
-	tristate "MPC8xx Watchdog Timer"
-	depends on 8xx
+# M68K Architecture
 
-config 83xx_WDT
-	tristate "MPC83xx Watchdog Timer"
-	depends on PPC_83xx
-
-config MV64X60_WDT
-	tristate "MV64X60 (Marvell Discovery) Watchdog Timer"
-	depends on MV64X60
-
-config BOOKE_WDT
-	bool "PowerPC Book-E Watchdog Timer"
-	depends on BOOKE || 4xx
-	---help---
-	  Please see Documentation/watchdog/watchdog-api.txt for
-	  more information.
-
-# PPC64 Architecture
-
-config WATCHDOG_RTAS
-	tristate "RTAS watchdog"
-	depends on PPC_RTAS
-	help
-	  This driver adds watchdog support for the RTAS watchdog.
-
-	  To compile this driver as a module, choose M here. The module
-	  will be called wdrtas.
+# M68KNOMMU Architecture
 
 # MIPS Architecture
 
@@ -600,6 +609,44 @@ config WDT_RM9K_GPI
 	  To compile this driver as a module, choose M here: the
 	  module will be called rm9k_wdt.
 
+# PARISC Architecture
+
+# POWERPC Architecture
+
+config MPC5200_WDT
+	tristate "MPC5200 Watchdog Timer"
+	depends on PPC_MPC52xx
+
+config 8xx_WDT
+	tristate "MPC8xx Watchdog Timer"
+	depends on 8xx
+
+config 83xx_WDT
+	tristate "MPC83xx Watchdog Timer"
+	depends on PPC_83xx
+
+config MV64X60_WDT
+	tristate "MV64X60 (Marvell Discovery) Watchdog Timer"
+	depends on MV64X60
+
+config BOOKE_WDT
+	bool "PowerPC Book-E Watchdog Timer"
+	depends on BOOKE || 4xx
+	---help---
+	  Please see Documentation/watchdog/watchdog-api.txt for
+	  more information.
+
+# PPC64 Architecture
+
+config WATCHDOG_RTAS
+	tristate "RTAS watchdog"
+	depends on PPC_RTAS
+	help
+	  This driver adds watchdog support for the RTAS watchdog.
+
+	  To compile this driver as a module, choose M here. The module
+	  will be called wdrtas.
+
 # S390 Architecture
 
 config ZVM_WATCHDOG
@@ -614,7 +661,7 @@ config ZVM_WATCHDOG
 	  To compile this driver as a module, choose M here. The module
 	  will be called vmwatchdog.
 
-# SUPERH Architecture
+# SUPERH (sh + sh64) Architecture
 
 config SH_WDT
 	tristate "SuperH Watchdog"
@@ -641,6 +688,8 @@ config SH_WDT_MMAP
 	  If you say Y here, user applications will be able to mmap the
 	  WDT/CPG registers.
 
+# SPARC Architecture
+
 # SPARC64 Architecture
 
 config WATCHDOG_CP1XXX
@@ -665,6 +714,10 @@ config WATCHDOG_RIO
 	  machines.  The watchdog timeout period is normally one minute but
 	  can be changed with a boot-time parameter.
 
+# V850 Architecture
+
+# XTENSA Architecture
+
 #
 # ISA-based Watchdog Cards
 #
diff --git a/drivers/char/watchdog/Makefile b/drivers/char/watchdog/Makefile
index bdb9d5e..389f8b1 100644
--- a/drivers/char/watchdog/Makefile
+++ b/drivers/char/watchdog/Makefile
@@ -22,6 +22,8 @@ obj-$(CONFIG_WDTPCI) += wdt_pci.o
 # USB-based Watchdog Cards
 obj-$(CONFIG_USBPCWATCHDOG) += pcwd_usb.o
 
+# ALPHA Architecture
+
 # ARM Architecture
 obj-$(CONFIG_AT91RM9200_WATCHDOG) += at91rm9200_wdt.o
 obj-$(CONFIG_OMAP_WATCHDOG) += omap_wdt.o
@@ -36,10 +38,22 @@ obj-$(CONFIG_MPCORE_WATCHDOG) += mpcore_wdt.o
 obj-$(CONFIG_EP93XX_WATCHDOG) += ep93xx_wdt.o
 obj-$(CONFIG_PNX4008_WATCHDOG) += pnx4008_wdt.o
 obj-$(CONFIG_IOP_WATCHDOG) += iop_wdt.o
+obj-$(CONFIG_DAVINCI_WATCHDOG) += davinci_wdt.o
+
+# ARM26 Architecture
 
 # AVR32 Architecture
 obj-$(CONFIG_AT32AP700X_WDT) += at32ap700x_wdt.o
 
+# BLACKFIN Architecture
+obj-$(CONFIG_BFIN_WDT) += bfin_wdt.o
+
+# CRIS Architecture
+
+# FRV Architecture
+
+# H8300 Architecture
+
 # X86 (i386 + ia64 + x86_64) Architecture
 obj-$(CONFIG_ACQUIRE_WDT) += acquirewdt.o
 obj-$(CONFIG_ADVANTECH_WDT) += advantechwdt.o
@@ -66,8 +80,22 @@ obj-$(CONFIG_W83977F_WDT) += w83977f_wdt.o
 obj-$(CONFIG_MACHZ_WDT) += machzwd.o
 obj-$(CONFIG_SBC_EPX_C3_WATCHDOG) += sbc_epx_c3.o
 
-# PowerPC Architecture
+# M32R Architecture
+
+# M68K Architecture
+
+# M68KNOMMU Architecture
+
+# MIPS Architecture
+obj-$(CONFIG_INDYDOG) += indydog.o
+obj-$(CONFIG_WDT_MTX1)	+= mtx-1_wdt.o
+obj-$(CONFIG_WDT_RM9K_GPI) += rm9k_wdt.o
+
+# PARISC Architecture
+
+# POWERPC Architecture
 obj-$(CONFIG_8xx_WDT) += mpc8xx_wdt.o
+obj-$(CONFIG_MPC5200_WDT) += mpc5200_wdt.o
 obj-$(CONFIG_83xx_WDT) += mpc83xx_wdt.o
 obj-$(CONFIG_MV64X60_WDT) += mv64x60_wdt.o
 obj-$(CONFIG_BOOKE_WDT) += booke_wdt.o
@@ -75,17 +103,18 @@ obj-$(CONFIG_BOOKE_WDT) += booke_wdt.o
 # PPC64 Architecture
 obj-$(CONFIG_WATCHDOG_RTAS) += wdrtas.o
 
-# MIPS Architecture
-obj-$(CONFIG_INDYDOG) += indydog.o
-obj-$(CONFIG_WDT_MTX1)	+= mtx-1_wdt.o
-obj-$(CONFIG_WDT_RM9K_GPI) += rm9k_wdt.o
-
 # S390 Architecture
 
-# SUPERH Architecture
+# SUPERH (sh + sh64) Architecture
 obj-$(CONFIG_SH_WDT) += shwdt.o
 
+# SPARC Architecture
+
 # SPARC64 Architecture
 
+# V850 Architecture
+
+# XTENSA Architecture
+
 # Architecture Independant
 obj-$(CONFIG_SOFT_WATCHDOG) += softdog.o
diff --git a/drivers/char/watchdog/bfin_wdt.c b/drivers/char/watchdog/bfin_wdt.c
new file mode 100644
index 0000000..309d279
--- /dev/null
+++ b/drivers/char/watchdog/bfin_wdt.c
@@ -0,0 +1,490 @@
+/*
+ * Blackfin On-Chip Watchdog Driver
+ *  Supports BF53[123]/BF53[467]/BF54[2489]/BF561
+ *
+ * Originally based on softdog.c
+ * Copyright 2006-2007 Analog Devices Inc.
+ * Copyright 2006-2007 Michele d'Amico
+ * Copyright 1996 Alan Cox <alan@redhat.com>
+ *
+ * Enter bugs at http://blackfin.uclinux.org/
+ *
+ * Licensed under the GPL-2 or later.
+ */
+
+#include <linux/platform_device.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/types.h>
+#include <linux/timer.h>
+#include <linux/miscdevice.h>
+#include <linux/watchdog.h>
+#include <linux/fs.h>
+#include <linux/notifier.h>
+#include <linux/reboot.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <asm/blackfin.h>
+#include <asm/uaccess.h>
+
+#define stamp(fmt, args...) pr_debug("%s:%i: " fmt "\n", __func__, __LINE__, ## args)
+#define stampit() stamp("here i am")
+
+#define WATCHDOG_NAME "bfin-wdt"
+#define PFX WATCHDOG_NAME ": "
+
+/* The BF561 has two watchdogs (one per core), but since Linux
+ * only runs on core A, we'll just work with that one.
+ */
+#ifdef BF561_FAMILY
+# define bfin_read_WDOG_CTL()    bfin_read_WDOGA_CTL()
+# define bfin_read_WDOG_CNT()    bfin_read_WDOGA_CNT()
+# define bfin_read_WDOG_STAT()   bfin_read_WDOGA_STAT()
+# define bfin_write_WDOG_CTL(x)  bfin_write_WDOGA_CTL(x)
+# define bfin_write_WDOG_CNT(x)  bfin_write_WDOGA_CNT(x)
+# define bfin_write_WDOG_STAT(x) bfin_write_WDOGA_STAT(x)
+#endif
+
+/* Bit in SWRST that indicates boot caused by watchdog */
+#define SWRST_RESET_WDOG 0x4000
+
+/* Bit in WDOG_CTL that indicates watchdog has expired (WDR0) */
+#define WDOG_EXPIRED 0x8000
+
+/* Masks for WDEV field in WDOG_CTL register */
+#define ICTL_RESET   0x0
+#define ICTL_NMI     0x2
+#define ICTL_GPI     0x4
+#define ICTL_NONE    0x6
+#define ICTL_MASK    0x6
+
+/* Masks for WDEN field in WDOG_CTL register */
+#define WDEN_MASK    0x0FF0
+#define WDEN_ENABLE  0x0000
+#define WDEN_DISABLE 0x0AD0
+
+/* some defaults */
+#define WATCHDOG_TIMEOUT 20
+
+static unsigned int timeout = WATCHDOG_TIMEOUT;
+static int nowayout = WATCHDOG_NOWAYOUT;
+static struct watchdog_info bfin_wdt_info;
+static unsigned long open_check;
+static char expect_close;
+static spinlock_t bfin_wdt_spinlock = SPIN_LOCK_UNLOCKED;
+
+/**
+ *	bfin_wdt_keepalive - Keep the Userspace Watchdog Alive
+ *
+ * 	The Userspace watchdog got a KeepAlive: schedule the next timeout.
+ */
+static int bfin_wdt_keepalive(void)
+{
+	stampit();
+	bfin_write_WDOG_STAT(0);
+	return 0;
+}
+
+/**
+ *	bfin_wdt_stop - Stop the Watchdog
+ *
+ *	Stops the on-chip watchdog.
+ */
+static int bfin_wdt_stop(void)
+{
+	stampit();
+	bfin_write_WDOG_CTL(WDEN_DISABLE);
+	return 0;
+}
+
+/**
+ *	bfin_wdt_start - Start the Watchdog
+ *
+ *	Starts the on-chip watchdog.  Automatically loads WDOG_CNT
+ *	into WDOG_STAT for us.
+ */
+static int bfin_wdt_start(void)
+{
+	stampit();
+	bfin_write_WDOG_CTL(WDEN_ENABLE | ICTL_RESET);
+	return 0;
+}
+
+/**
+ *	bfin_wdt_running - Check Watchdog status
+ *
+ *	See if the watchdog is running.
+ */
+static int bfin_wdt_running(void)
+{
+	stampit();
+	return ((bfin_read_WDOG_CTL() & WDEN_MASK) != WDEN_DISABLE);
+}
+
+/**
+ *	bfin_wdt_set_timeout - Set the Userspace Watchdog timeout
+ *	@t: new timeout value (in seconds)
+ *
+ *	Translate the specified timeout in seconds into System Clock
+ *	terms which is what the on-chip Watchdog requires.
+ */
+static int bfin_wdt_set_timeout(unsigned long t)
+{
+	u32 cnt;
+	unsigned long flags;
+
+	stampit();
+
+	cnt = t * get_sclk();
+	if (cnt < get_sclk()) {
+		printk(KERN_WARNING PFX "timeout value is too large\n");
+		return -EINVAL;
+	}
+
+	spin_lock_irqsave(&bfin_wdt_spinlock, flags);
+	{
+		int run = bfin_wdt_running();
+		bfin_wdt_stop();
+		bfin_write_WDOG_CNT(cnt);
+		if (run) bfin_wdt_start();
+	}
+	spin_unlock_irqrestore(&bfin_wdt_spinlock, flags);
+
+	timeout = t;
+
+	return 0;
+}
+
+/**
+ *	bfin_wdt_open - Open the Device
+ *	@inode: inode of device
+ *	@file: file handle of device
+ *
+ *	Watchdog device is opened and started.
+ */
+static int bfin_wdt_open(struct inode *inode, struct file *file)
+{
+	stampit();
+
+	if (test_and_set_bit(0, &open_check))
+		return -EBUSY;
+
+	if (nowayout)
+		__module_get(THIS_MODULE);
+
+	bfin_wdt_keepalive();
+	bfin_wdt_start();
+
+	return nonseekable_open(inode, file);
+}
+
+/**
+ *	bfin_wdt_close - Close the Device
+ *	@inode: inode of device
+ *	@file: file handle of device
+ *
+ *	Watchdog device is closed and stopped.
+ */
+static int bfin_wdt_release(struct inode *inode, struct file *file)
+{
+	stampit();
+
+	if (expect_close == 42) {
+		bfin_wdt_stop();
+	} else {
+		printk(KERN_CRIT PFX "Unexpected close, not stopping watchdog!\n");
+		bfin_wdt_keepalive();
+	}
+
+	expect_close = 0;
+	clear_bit(0, &open_check);
+
+	return 0;
+}
+
+/**
+ *	bfin_wdt_write - Write to Device
+ *	@file: file handle of device
+ *	@buf: buffer to write
+ *	@count: length of buffer
+ *	@ppos: offset
+ *
+ *	Pings the watchdog on write.
+ */
+static ssize_t bfin_wdt_write(struct file *file, const char __user *data,
+                              size_t len, loff_t *ppos)
+{
+	stampit();
+
+	if (len) {
+		if (!nowayout) {
+			size_t i;
+
+			/* In case it was set long ago */
+			expect_close = 0;
+
+			for (i = 0; i != len; i++) {
+				char c;
+				if (get_user(c, data + i))
+					return -EFAULT;
+				if (c == 'V')
+					expect_close = 42;
+			}
+		}
+		bfin_wdt_keepalive();
+	}
+
+	return len;
+}
+
+/**
+ *	bfin_wdt_ioctl - Query Device
+ *	@inode: inode of device
+ *	@file: file handle of device
+ *	@cmd: watchdog command
+ *	@arg: argument
+ *
+ *	Query basic information from the device or ping it, as outlined by the
+ *	watchdog API.
+ */
+static int bfin_wdt_ioctl(struct inode *inode, struct file *file,
+                          unsigned int cmd, unsigned long arg)
+{
+	void __user *argp = (void __user *)arg;
+	int __user *p = argp;
+
+	stampit();
+
+	switch (cmd) {
+		default:
+			return -ENOTTY;
+
+		case WDIOC_GETSUPPORT:
+			if (copy_to_user(argp, &bfin_wdt_info, sizeof(bfin_wdt_info)))
+				return -EFAULT;
+			else
+				return 0;
+
+		case WDIOC_GETSTATUS:
+		case WDIOC_GETBOOTSTATUS:
+			return put_user(!!(_bfin_swrst & SWRST_RESET_WDOG), p);
+
+		case WDIOC_KEEPALIVE:
+			bfin_wdt_keepalive();
+			return 0;
+
+		case WDIOC_SETTIMEOUT: {
+			int new_timeout;
+
+			if (get_user(new_timeout, p))
+				return -EFAULT;
+
+			if (bfin_wdt_set_timeout(new_timeout))
+				return -EINVAL;
+		}
+			/* Fall */
+		case WDIOC_GETTIMEOUT:
+			return put_user(timeout, p);
+
+		case WDIOC_SETOPTIONS: {
+			unsigned long flags;
+			int options, ret = -EINVAL;
+
+			if (get_user(options, p))
+				return -EFAULT;
+
+			spin_lock_irqsave(&bfin_wdt_spinlock, flags);
+
+			if (options & WDIOS_DISABLECARD) {
+				bfin_wdt_stop();
+				ret = 0;
+			}
+
+			if (options & WDIOS_ENABLECARD) {
+				bfin_wdt_start();
+				ret = 0;
+			}
+
+			spin_unlock_irqrestore(&bfin_wdt_spinlock, flags);
+
+			return ret;
+		}
+	}
+}
+
+/**
+ *	bfin_wdt_notify_sys - Notifier Handler
+ *	@this: notifier block
+ *	@code: notifier event
+ *	@unused: unused
+ *
+ *	Handles specific events, such as turning off the watchdog during a
+ *	shutdown event.
+ */
+static int bfin_wdt_notify_sys(struct notifier_block *this, unsigned long code,
+                               void *unused)
+{
+	stampit();
+
+	if (code == SYS_DOWN || code == SYS_HALT)
+		bfin_wdt_stop();
+
+	return NOTIFY_DONE;
+}
+
+#ifdef CONFIG_PM
+static int state_before_suspend;
+
+/**
+ *	bfin_wdt_suspend - suspend the watchdog
+ *	@pdev: device being suspended
+ *	@state: requested suspend state
+ *
+ *	Remember if the watchdog was running and stop it.
+ *	TODO: is this even right?  Doesn't seem to be any
+ *	      standard in the watchdog world ...
+ */
+static int bfin_wdt_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	stampit();
+
+	state_before_suspend = bfin_wdt_running();
+	bfin_wdt_stop();
+
+	return 0;
+}
+
+/**
+ *	bfin_wdt_resume - resume the watchdog
+ *	@pdev: device being resumed
+ *
+ *	If the watchdog was running, turn it back on.
+ */
+static int bfin_wdt_resume(struct platform_device *pdev)
+{
+	stampit();
+
+	if (state_before_suspend) {
+		bfin_wdt_set_timeout(timeout);
+		bfin_wdt_start();
+	}
+
+	return 0;
+}
+#else
+# define bfin_wdt_suspend NULL
+# define bfin_wdt_resume NULL
+#endif
+
+static struct platform_device bfin_wdt_device = {
+	.name          = WATCHDOG_NAME,
+	.id            = -1,
+};
+
+static struct platform_driver bfin_wdt_driver = {
+	.driver    = {
+		.name  = WATCHDOG_NAME,
+		.owner = THIS_MODULE,
+	},
+	.suspend   = bfin_wdt_suspend,
+	.resume    = bfin_wdt_resume,
+};
+
+static struct file_operations bfin_wdt_fops = {
+	.owner    = THIS_MODULE,
+	.llseek   = no_llseek,
+	.write    = bfin_wdt_write,
+	.ioctl    = bfin_wdt_ioctl,
+	.open     = bfin_wdt_open,
+	.release  = bfin_wdt_release,
+};
+
+static struct miscdevice bfin_wdt_miscdev = {
+	.minor    = WATCHDOG_MINOR,
+	.name     = "watchdog",
+	.fops     = &bfin_wdt_fops,
+};
+
+static struct watchdog_info bfin_wdt_info = {
+	.identity = "Blackfin Watchdog",
+	.options  = WDIOF_SETTIMEOUT |
+	            WDIOF_KEEPALIVEPING |
+	            WDIOF_MAGICCLOSE,
+};
+
+static struct notifier_block bfin_wdt_notifier = {
+	.notifier_call = bfin_wdt_notify_sys,
+};
+
+/**
+ *	bfin_wdt_init - Initialize module
+ *
+ *	Registers the device and notifier handler. Actual device
+ *	initialization is handled by bfin_wdt_open().
+ */
+static int __init bfin_wdt_init(void)
+{
+	int ret;
+
+	stampit();
+
+	/* Check that the timeout value is within range */
+	if (bfin_wdt_set_timeout(timeout))
+		return -EINVAL;
+
+	/* Since this is an on-chip device and needs no board-specific
+	 * resources, we'll handle all the platform device stuff here.
+	 */
+	ret = platform_device_register(&bfin_wdt_device);
+	if (ret)
+		return ret;
+
+	ret = platform_driver_probe(&bfin_wdt_driver, NULL);
+	if (ret)
+		return ret;
+
+	ret = register_reboot_notifier(&bfin_wdt_notifier);
+	if (ret) {
+		printk(KERN_ERR PFX "cannot register reboot notifier (err=%d)\n", ret);
+		return ret;
+	}
+
+	ret = misc_register(&bfin_wdt_miscdev);
+	if (ret) {
+		printk(KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
+		       WATCHDOG_MINOR, ret);
+		unregister_reboot_notifier(&bfin_wdt_notifier);
+		return ret;
+	}
+
+	printk(KERN_INFO PFX "initialized: timeout=%d sec (nowayout=%d)\n",
+	       timeout, nowayout);
+
+	return 0;
+}
+
+/**
+ *	bfin_wdt_exit - Deinitialize module
+ *
+ *	Unregisters the device and notifier handler. Actual device
+ *	deinitialization is handled by bfin_wdt_close().
+ */
+static void __exit bfin_wdt_exit(void)
+{
+	misc_deregister(&bfin_wdt_miscdev);
+	unregister_reboot_notifier(&bfin_wdt_notifier);
+}
+
+module_init(bfin_wdt_init);
+module_exit(bfin_wdt_exit);
+
+MODULE_AUTHOR("Michele d'Amico, Mike Frysinger <vapier@gentoo.org>");
+MODULE_DESCRIPTION("Blackfin Watchdog Device Driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
+
+module_param(timeout, uint, 0);
+MODULE_PARM_DESC(timeout, "Watchdog timeout in seconds. (1<=timeout<=((2^32)/SCLK), default=" __MODULE_STRING(WATCHDOG_TIMEOUT) ")");
+
+module_param(nowayout, int, 0);
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
diff --git a/drivers/char/watchdog/booke_wdt.c b/drivers/char/watchdog/booke_wdt.c
index 0f5c77d..d362f5b 100644
--- a/drivers/char/watchdog/booke_wdt.c
+++ b/drivers/char/watchdog/booke_wdt.c
@@ -144,7 +144,7 @@ static int booke_wdt_open (struct inode *inode, struct file *file)
 				booke_wdt_period);
 	}
 
-	return 0;
+	return nonseekable_open(inode, file);
 }
 
 static const struct file_operations booke_wdt_fops = {
diff --git a/drivers/char/watchdog/cpu5wdt.c b/drivers/char/watchdog/cpu5wdt.c
index d0d45a8..5941ca6 100644
--- a/drivers/char/watchdog/cpu5wdt.c
+++ b/drivers/char/watchdog/cpu5wdt.c
@@ -162,6 +162,10 @@ static int cpu5wdt_ioctl(struct inode *inode, struct file *file, unsigned int cm
 			if ( copy_to_user(argp, &value, sizeof(int)) )
 				return -EFAULT;
 			break;
+		case WDIOC_GETBOOTSTATUS:
+			if ( copy_to_user(argp, &value, sizeof(int)) )
+				return -EFAULT;
+			break;
 		case WDIOC_GETSUPPORT:
 			if ( copy_to_user(argp, &ident, sizeof(ident)) )
 				return -EFAULT;
diff --git a/drivers/char/watchdog/davinci_wdt.c b/drivers/char/watchdog/davinci_wdt.c
new file mode 100644
index 0000000..19db530
--- /dev/null
+++ b/drivers/char/watchdog/davinci_wdt.c
@@ -0,0 +1,281 @@
+/*
+ * drivers/char/watchdog/davinci_wdt.c
+ *
+ * Watchdog driver for DaVinci DM644x/DM646x processors
+ *
+ * Copyright (C) 2006 Texas Instruments.
+ *
+ * 2007 (c) MontaVista Software, Inc. This file is licensed under
+ * the terms of the GNU General Public License version 2. This program
+ * is licensed "as is" without any warranty of any kind, whether express
+ * or implied.
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
+#include <linux/bitops.h>
+#include <linux/platform_device.h>
+#include <linux/spinlock.h>
+
+#include <asm/hardware.h>
+#include <asm/uaccess.h>
+#include <asm/io.h>
+
+#define MODULE_NAME "DAVINCI-WDT: "
+
+#define DEFAULT_HEARTBEAT 60
+#define MAX_HEARTBEAT     600	/* really the max margin is 264/27MHz*/
+
+/* Timer register set definition */
+#define PID12	(0x0)
+#define EMUMGT	(0x4)
+#define TIM12	(0x10)
+#define TIM34	(0x14)
+#define PRD12	(0x18)
+#define PRD34	(0x1C)
+#define TCR	(0x20)
+#define TGCR	(0x24)
+#define WDTCR	(0x28)
+
+/* TCR bit definitions */
+#define ENAMODE12_DISABLED	(0 << 6)
+#define ENAMODE12_ONESHOT	(1 << 6)
+#define ENAMODE12_PERIODIC	(2 << 6)
+
+/* TGCR bit definitions */
+#define TIM12RS_UNRESET		(1 << 0)
+#define TIM34RS_UNRESET		(1 << 1)
+#define TIMMODE_64BIT_WDOG      (2 << 2)
+
+/* WDTCR bit definitions */
+#define WDEN			(1 << 14)
+#define WDFLAG			(1 << 15)
+#define WDKEY_SEQ0		(0xa5c6 << 16)
+#define WDKEY_SEQ1		(0xda7e << 16)
+
+static int heartbeat = DEFAULT_HEARTBEAT;
+
+static spinlock_t io_lock;
+static unsigned long wdt_status;
+#define WDT_IN_USE        0
+#define WDT_OK_TO_CLOSE   1
+#define WDT_REGION_INITED 2
+#define WDT_DEVICE_INITED 3
+
+static struct resource	*wdt_mem;
+static void __iomem	*wdt_base;
+
+static void wdt_service(void)
+{
+	spin_lock(&io_lock);
+
+	/* put watchdog in service state */
+	davinci_writel(WDKEY_SEQ0, wdt_base + WDTCR);
+	/* put watchdog in active state */
+	davinci_writel(WDKEY_SEQ1, wdt_base + WDTCR);
+
+	spin_unlock(&io_lock);
+}
+
+static void wdt_enable(void)
+{
+	u32 tgcr;
+	u32 timer_margin;
+
+	spin_lock(&io_lock);
+
+	/* disable, internal clock source */
+	davinci_writel(0, wdt_base + TCR);
+	/* reset timer, set mode to 64-bit watchdog, and unreset */
+	davinci_writel(0, wdt_base + TGCR);
+	tgcr = TIMMODE_64BIT_WDOG | TIM12RS_UNRESET | TIM34RS_UNRESET;
+	davinci_writel(tgcr, wdt_base + TGCR);
+	/* clear counter regs */
+	davinci_writel(0, wdt_base + TIM12);
+	davinci_writel(0, wdt_base + TIM34);
+	/* set timeout period */
+	timer_margin = (((u64)heartbeat * CLOCK_TICK_RATE) & 0xffffffff);
+	davinci_writel(timer_margin, wdt_base + PRD12);
+	timer_margin = (((u64)heartbeat * CLOCK_TICK_RATE) >> 32);
+	davinci_writel(timer_margin, wdt_base + PRD34);
+	/* enable run continuously */
+	davinci_writel(ENAMODE12_PERIODIC, wdt_base + TCR);
+	/* Once the WDT is in pre-active state write to
+	 * TIM12, TIM34, PRD12, PRD34, TCR, TGCR, WDTCR are
+	 * write protected (except for the WDKEY field)
+	 */
+	/* put watchdog in pre-active state */
+	davinci_writel(WDKEY_SEQ0 | WDEN, wdt_base + WDTCR);
+	/* put watchdog in active state */
+	davinci_writel(WDKEY_SEQ1 | WDEN, wdt_base + WDTCR);
+
+	spin_unlock(&io_lock);
+}
+
+static int davinci_wdt_open(struct inode *inode, struct file *file)
+{
+	if (test_and_set_bit(WDT_IN_USE, &wdt_status))
+		return -EBUSY;
+
+	wdt_enable();
+
+	return nonseekable_open(inode, file);
+}
+
+static ssize_t
+davinci_wdt_write(struct file *file, const char *data, size_t len,
+		  loff_t *ppos)
+{
+	if (len)
+		wdt_service();
+
+	return len;
+}
+
+static struct watchdog_info ident = {
+	.options = WDIOF_KEEPALIVEPING,
+	.identity = "DaVinci Watchdog",
+};
+
+static int
+davinci_wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
+		  unsigned long arg)
+{
+	int ret = -ENOTTY;
+
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		ret = copy_to_user((struct watchdog_info *)arg, &ident,
+				   sizeof(ident)) ? -EFAULT : 0;
+		break;
+
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		ret = put_user(0, (int *)arg);
+		break;
+
+	case WDIOC_GETTIMEOUT:
+		ret = put_user(heartbeat, (int *)arg);
+		break;
+
+	case WDIOC_KEEPALIVE:
+		wdt_service();
+		ret = 0;
+		break;
+	}
+	return ret;
+}
+
+static int davinci_wdt_release(struct inode *inode, struct file *file)
+{
+	wdt_service();
+	clear_bit(WDT_IN_USE, &wdt_status);
+
+	return 0;
+}
+
+static const struct file_operations davinci_wdt_fops = {
+	.owner = THIS_MODULE,
+	.llseek = no_llseek,
+	.write = davinci_wdt_write,
+	.ioctl = davinci_wdt_ioctl,
+	.open = davinci_wdt_open,
+	.release = davinci_wdt_release,
+};
+
+static struct miscdevice davinci_wdt_miscdev = {
+	.minor = WATCHDOG_MINOR,
+	.name = "watchdog",
+	.fops = &davinci_wdt_fops,
+};
+
+static int davinci_wdt_probe(struct platform_device *pdev)
+{
+	int ret = 0, size;
+	struct resource *res;
+
+	spin_lock_init(&io_lock);
+
+	if (heartbeat < 1 || heartbeat > MAX_HEARTBEAT)
+		heartbeat = DEFAULT_HEARTBEAT;
+
+	printk(KERN_INFO MODULE_NAME
+		"DaVinci Watchdog Timer: heartbeat %d sec\n", heartbeat);
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (res == NULL) {
+		printk(KERN_INFO MODULE_NAME
+			"failed to get memory region resource\n");
+		return -ENOENT;
+	}
+
+	size = res->end - res->start + 1;
+	wdt_mem = request_mem_region(res->start, size, pdev->name);
+
+	if (wdt_mem == NULL) {
+		printk(KERN_INFO MODULE_NAME "failed to get memory region\n");
+		return -ENOENT;
+	}
+	wdt_base = (void __iomem *)(res->start);
+
+	ret = misc_register(&davinci_wdt_miscdev);
+	if (ret < 0) {
+		printk(KERN_ERR MODULE_NAME "cannot register misc device\n");
+		release_resource(wdt_mem);
+		kfree(wdt_mem);
+	} else {
+		set_bit(WDT_DEVICE_INITED, &wdt_status);
+	}
+
+	return ret;
+}
+
+static int davinci_wdt_remove(struct platform_device *pdev)
+{
+	misc_deregister(&davinci_wdt_miscdev);
+	if (wdt_mem) {
+		release_resource(wdt_mem);
+		kfree(wdt_mem);
+		wdt_mem = NULL;
+	}
+	return 0;
+}
+
+static struct platform_driver platform_wdt_driver = {
+	.driver = {
+		.name = "watchdog",
+	},
+	.probe = davinci_wdt_probe,
+	.remove = davinci_wdt_remove,
+};
+
+static int __init davinci_wdt_init(void)
+{
+	return platform_driver_register(&platform_wdt_driver);
+}
+
+static void __exit davinci_wdt_exit(void)
+{
+	return platform_driver_unregister(&platform_wdt_driver);
+}
+
+module_init(davinci_wdt_init);
+module_exit(davinci_wdt_exit);
+
+MODULE_AUTHOR("Texas Instruments");
+MODULE_DESCRIPTION("DaVinci Watchdog Driver");
+
+module_param(heartbeat, int, 0);
+MODULE_PARM_DESC(heartbeat,
+		 "Watchdog heartbeat period in seconds from 1 to "
+		 __MODULE_STRING(MAX_HEARTBEAT) ", default "
+		 __MODULE_STRING(DEFAULT_HEARTBEAT));
+
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
diff --git a/drivers/char/watchdog/iTCO_wdt.c b/drivers/char/watchdog/iTCO_wdt.c
index eac4f9b..cd5a565 100644
--- a/drivers/char/watchdog/iTCO_wdt.c
+++ b/drivers/char/watchdog/iTCO_wdt.c
@@ -39,7 +39,12 @@
  *	82801HR  (ICH8R)     : document number 313056-002, 313057-004,
  *	82801HH  (ICH8DH)    : document number 313056-002, 313057-004,
  *	82801HO  (ICH8DO)    : document number 313056-002, 313057-004,
- *	6300ESB  (6300ESB)   : document number 300641-003
+ *	82801IB  (ICH9)      : document number 316972-001, 316973-001,
+ *	82801IR  (ICH9R)     : document number 316972-001, 316973-001,
+ *	82801IH  (ICH9DH)    : document number 316972-001, 316973-001,
+ *	6300ESB  (6300ESB)   : document number 300641-003, 300884-010,
+ *	631xESB  (631xESB)   : document number 313082-001, 313075-005,
+ *	632xESB  (632xESB)   : document number 313082-001, 313075-005
  */
 
 /*
@@ -48,8 +53,8 @@
 
 /* Module and version information */
 #define DRV_NAME        "iTCO_wdt"
-#define DRV_VERSION     "1.01"
-#define DRV_RELDATE     "21-Jan-2007"
+#define DRV_VERSION     "1.02"
+#define DRV_RELDATE     "26-Jul-2007"
 #define PFX		DRV_NAME ": "
 
 /* Includes */
@@ -92,6 +97,10 @@ enum iTCO_chipsets {
 	TCO_ICH8,	/* ICH8 & ICH8R */
 	TCO_ICH8DH,	/* ICH8DH */
 	TCO_ICH8DO,	/* ICH8DO */
+	TCO_ICH9,	/* ICH9 */
+	TCO_ICH9R,	/* ICH9R */
+	TCO_ICH9DH,	/* ICH9DH */
+	TCO_631XESB,	/* 631xESB/632xESB */
 };
 
 static struct {
@@ -118,6 +127,10 @@ static struct {
 	{"ICH8 or ICH8R", 2},
 	{"ICH8DH", 2},
 	{"ICH8DO", 2},
+	{"ICH9", 2},
+	{"ICH9R", 2},
+	{"ICH9DH", 2},
+	{"631xESB/632xESB", 2},
 	{NULL,0}
 };
 
@@ -148,6 +161,25 @@ static struct pci_device_id iTCO_wdt_pci_tbl[] = {
 	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH8_0,	PCI_ANY_ID, PCI_ANY_ID, 0, 0, TCO_ICH8    },
 	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH8_2,	PCI_ANY_ID, PCI_ANY_ID, 0, 0, TCO_ICH8DH  },
 	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH8_3,	PCI_ANY_ID, PCI_ANY_ID, 0, 0, TCO_ICH8DO  },
+	{ PCI_VENDOR_ID_INTEL, 0x2918,	PCI_ANY_ID, PCI_ANY_ID, 0, 0, TCO_ICH9    },
+	{ PCI_VENDOR_ID_INTEL, 0x2916,	PCI_ANY_ID, PCI_ANY_ID, 0, 0, TCO_ICH9R    },
+	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH9_2,	PCI_ANY_ID, PCI_ANY_ID, 0, 0, TCO_ICH9DH    },
+	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ESB2_0,	PCI_ANY_ID, PCI_ANY_ID, 0, 0, TCO_631XESB },
+	{ PCI_VENDOR_ID_INTEL, 0x2671,	PCI_ANY_ID, PCI_ANY_ID, 0, 0, TCO_631XESB },
+	{ PCI_VENDOR_ID_INTEL, 0x2672,	PCI_ANY_ID, PCI_ANY_ID, 0, 0, TCO_631XESB },
+	{ PCI_VENDOR_ID_INTEL, 0x2673,	PCI_ANY_ID, PCI_ANY_ID, 0, 0, TCO_631XESB },
+	{ PCI_VENDOR_ID_INTEL, 0x2674,	PCI_ANY_ID, PCI_ANY_ID, 0, 0, TCO_631XESB },
+	{ PCI_VENDOR_ID_INTEL, 0x2675,	PCI_ANY_ID, PCI_ANY_ID, 0, 0, TCO_631XESB },
+	{ PCI_VENDOR_ID_INTEL, 0x2676,	PCI_ANY_ID, PCI_ANY_ID, 0, 0, TCO_631XESB },
+	{ PCI_VENDOR_ID_INTEL, 0x2677,	PCI_ANY_ID, PCI_ANY_ID, 0, 0, TCO_631XESB },
+	{ PCI_VENDOR_ID_INTEL, 0x2678,	PCI_ANY_ID, PCI_ANY_ID, 0, 0, TCO_631XESB },
+	{ PCI_VENDOR_ID_INTEL, 0x2679,	PCI_ANY_ID, PCI_ANY_ID, 0, 0, TCO_631XESB },
+	{ PCI_VENDOR_ID_INTEL, 0x267a,	PCI_ANY_ID, PCI_ANY_ID, 0, 0, TCO_631XESB },
+	{ PCI_VENDOR_ID_INTEL, 0x267b,	PCI_ANY_ID, PCI_ANY_ID, 0, 0, TCO_631XESB },
+	{ PCI_VENDOR_ID_INTEL, 0x267c,	PCI_ANY_ID, PCI_ANY_ID, 0, 0, TCO_631XESB },
+	{ PCI_VENDOR_ID_INTEL, 0x267d,	PCI_ANY_ID, PCI_ANY_ID, 0, 0, TCO_631XESB },
+	{ PCI_VENDOR_ID_INTEL, 0x267e,	PCI_ANY_ID, PCI_ANY_ID, 0, 0, TCO_631XESB },
+	{ PCI_VENDOR_ID_INTEL, 0x267f,	PCI_ANY_ID, PCI_ANY_ID, 0, 0, TCO_631XESB },
 	{ 0, },			/* End of list */
 };
 MODULE_DEVICE_TABLE (pci, iTCO_wdt_pci_tbl);
diff --git a/drivers/char/watchdog/machzwd.c b/drivers/char/watchdog/machzwd.c
index a0d2716..6d35bb1 100644
--- a/drivers/char/watchdog/machzwd.c
+++ b/drivers/char/watchdog/machzwd.c
@@ -321,6 +321,7 @@ static int zf_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 		break;
 
 	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
 		return put_user(0, p);
 
 	case WDIOC_KEEPALIVE:
diff --git a/drivers/char/watchdog/mixcomwd.c b/drivers/char/watchdog/mixcomwd.c
index db2ccb8..1adf1d5 100644
--- a/drivers/char/watchdog/mixcomwd.c
+++ b/drivers/char/watchdog/mixcomwd.c
@@ -215,6 +215,11 @@ static int mixcomwd_ioctl(struct inode *inode, struct file *file,
 				return -EFAULT;
 			}
 			break;
+		case WDIOC_GETBOOTSTATUS:
+			if (copy_to_user(p, &status, sizeof(int))) {
+				return -EFAULT;
+			}
+			break;
 		case WDIOC_GETSUPPORT:
 			if (copy_to_user(argp, &ident, sizeof(ident))) {
 				return -EFAULT;
diff --git a/drivers/char/watchdog/mpc5200_wdt.c b/drivers/char/watchdog/mpc5200_wdt.c
new file mode 100644
index 0000000..564143d
--- /dev/null
+++ b/drivers/char/watchdog/mpc5200_wdt.c
@@ -0,0 +1,286 @@
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/miscdevice.h>
+#include <linux/watchdog.h>
+#include <linux/io.h>
+#include <linux/spinlock.h>
+#include <asm/of_platform.h>
+#include <asm/uaccess.h>
+#include <asm/mpc52xx.h>
+
+
+#define GPT_MODE_WDT		(1<<15)
+#define GPT_MODE_CE		(1<<12)
+#define GPT_MODE_MS_TIMER	(0x4)
+
+
+struct mpc5200_wdt {
+	unsigned count;	/* timer ticks before watchdog kicks in */
+	long ipb_freq;
+	struct miscdevice miscdev;
+	struct resource mem;
+	struct mpc52xx_gpt __iomem *regs;
+	spinlock_t io_lock;
+};
+
+/* is_active stores wether or not the /dev/watchdog device is opened */
+static unsigned long is_active;
+
+/* misc devices don't provide a way, to get back to 'dev' or 'miscdev' from
+ * file operations, which sucks. But there can be max 1 watchdog anyway, so...
+ */
+static struct mpc5200_wdt *wdt_global;
+
+
+/* helper to calculate timeout in timer counts */
+static void mpc5200_wdt_set_timeout(struct mpc5200_wdt *wdt, int timeout)
+{
+	/* use biggest prescaler of 64k */
+	wdt->count = (wdt->ipb_freq + 0xffff) / 0x10000 * timeout;
+
+	if (wdt->count > 0xffff)
+		wdt->count = 0xffff;
+}
+/* return timeout in seconds (calculated from timer count) */
+static int mpc5200_wdt_get_timeout(struct mpc5200_wdt *wdt)
+{
+	return wdt->count * 0x10000 / wdt->ipb_freq;
+}
+
+
+/* watchdog operations */
+static int mpc5200_wdt_start(struct mpc5200_wdt *wdt)
+{
+	spin_lock(&wdt->io_lock);
+	/* disable */
+	out_be32(&wdt->regs->mode, 0);
+	/* set timeout, with maximum prescaler */
+	out_be32(&wdt->regs->count, 0x0 | wdt->count);
+	/* enable watchdog */
+	out_be32(&wdt->regs->mode, GPT_MODE_CE | GPT_MODE_WDT | GPT_MODE_MS_TIMER);
+	spin_unlock(&wdt->io_lock);
+
+	return 0;
+}
+static int mpc5200_wdt_ping(struct mpc5200_wdt *wdt)
+{
+	spin_lock(&wdt->io_lock);
+	/* writing A5 to OCPW resets the watchdog */
+	out_be32(&wdt->regs->mode, 0xA5000000 | (0xffffff & in_be32(&wdt->regs->mode)));
+	spin_unlock(&wdt->io_lock);
+	return 0;
+}
+static int mpc5200_wdt_stop(struct mpc5200_wdt *wdt)
+{
+	spin_lock(&wdt->io_lock);
+	/* disable */
+	out_be32(&wdt->regs->mode, 0);
+	spin_unlock(&wdt->io_lock);
+	return 0;
+}
+
+
+/* file operations */
+static ssize_t mpc5200_wdt_write(struct file *file, const char *data,
+		size_t len, loff_t *ppos)
+{
+	struct mpc5200_wdt *wdt = file->private_data;
+	mpc5200_wdt_ping(wdt);
+	return 0;
+}
+static struct watchdog_info mpc5200_wdt_info = {
+	.options	= WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
+	.identity	= "mpc5200 watchdog on GPT0",
+};
+static int mpc5200_wdt_ioctl(struct inode *inode, struct file *file,
+		unsigned int cmd, unsigned long arg)
+{
+	struct mpc5200_wdt *wdt = file->private_data;
+	int __user *data = (int __user *)arg;
+	int timeout;
+	int ret = 0;
+
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		ret = copy_to_user(data, &mpc5200_wdt_info,
+			sizeof(mpc5200_wdt_info));
+		if (ret)
+			ret = -EFAULT;
+		break;
+
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		ret = put_user(0, data);
+		break;
+
+	case WDIOC_KEEPALIVE:
+		mpc5200_wdt_ping(wdt);
+		break;
+
+	case WDIOC_SETTIMEOUT:
+		ret = get_user(timeout, data);
+		if (ret)
+			break;
+		mpc5200_wdt_set_timeout(wdt, timeout);
+		mpc5200_wdt_start(wdt);
+		/* fall through and return the timeout */
+
+	case WDIOC_GETTIMEOUT:
+		timeout = mpc5200_wdt_get_timeout(wdt);
+		ret = put_user(timeout, data);
+		break;
+
+	default:
+		ret = -ENOTTY;
+	}
+	return ret;
+}
+static int mpc5200_wdt_open(struct inode *inode, struct file *file)
+{
+	/* /dev/watchdog can only be opened once */
+	if (test_and_set_bit(0, &is_active))
+		return -EBUSY;
+
+	/* Set and activate the watchdog */
+	mpc5200_wdt_set_timeout(wdt_global, 30);
+	mpc5200_wdt_start(wdt_global);
+	file->private_data = wdt_global;
+	return nonseekable_open(inode, file);
+}
+static int mpc5200_wdt_release(struct inode *inode, struct file *file)
+{
+#if WATCHDOG_NOWAYOUT == 0
+	struct mpc5200_wdt *wdt = file->private_data;
+	mpc5200_wdt_stop(wdt);
+	wdt->count = 0;		/* == disabled */
+#endif
+	clear_bit(0, &is_active);
+	return 0;
+}
+
+static struct file_operations mpc5200_wdt_fops = {
+	.owner	= THIS_MODULE,
+	.write	= mpc5200_wdt_write,
+	.ioctl	= mpc5200_wdt_ioctl,
+	.open	= mpc5200_wdt_open,
+	.release = mpc5200_wdt_release,
+};
+
+/* module operations */
+static int mpc5200_wdt_probe(struct of_device *op, const struct of_device_id *match)
+{
+	struct mpc5200_wdt *wdt;
+	int err;
+	const void *has_wdt;
+	int size;
+
+	has_wdt = of_get_property(op->node, "has-wdt", NULL);
+	if (!has_wdt)
+		return -ENODEV;
+
+	wdt = kzalloc(sizeof(*wdt), GFP_KERNEL);
+	if (!wdt)
+		return -ENOMEM;
+
+	wdt->ipb_freq = mpc52xx_find_ipb_freq(op->node);
+
+	err = of_address_to_resource(op->node, 0, &wdt->mem);
+	if (err)
+		goto out_free;
+	size = wdt->mem.end - wdt->mem.start + 1;
+	if (!request_mem_region(wdt->mem.start, size, "mpc5200_wdt")) {
+		err = -ENODEV;
+		goto out_free;
+	}
+	wdt->regs = ioremap(wdt->mem.start, size);
+	if (!wdt->regs) {
+		err = -ENODEV;
+		goto out_release;
+	}
+
+	dev_set_drvdata(&op->dev, wdt);
+	spin_lock_init(&wdt->io_lock);
+
+	wdt->miscdev = (struct miscdevice) {
+		.minor	= WATCHDOG_MINOR,
+		.name	= "watchdog",
+		.fops	= &mpc5200_wdt_fops,
+		.parent = &op->dev,
+	};
+	wdt_global = wdt;
+	err = misc_register(&wdt->miscdev);
+	if (!err)
+		return 0;
+
+	iounmap(wdt->regs);
+ out_release:
+	release_mem_region(wdt->mem.start, size);
+ out_free:
+	kfree(wdt);
+	return err;
+}
+
+static int mpc5200_wdt_remove(struct of_device *op)
+{
+	struct mpc5200_wdt *wdt = dev_get_drvdata(&op->dev);
+
+	mpc5200_wdt_stop(wdt);
+	misc_deregister(&wdt->miscdev);
+	iounmap(wdt->regs);
+	release_mem_region(wdt->mem.start, wdt->mem.end - wdt->mem.start + 1);
+	kfree(wdt);
+
+	return 0;
+}
+static int mpc5200_wdt_suspend(struct of_device *op, pm_message_t state)
+{
+	struct mpc5200_wdt *wdt = dev_get_drvdata(&op->dev);
+	mpc5200_wdt_stop(wdt);
+	return 0;
+}
+static int mpc5200_wdt_resume(struct of_device *op)
+{
+	struct mpc5200_wdt *wdt = dev_get_drvdata(&op->dev);
+	if (wdt->count)
+		mpc5200_wdt_start(wdt);
+	return 0;
+}
+static int mpc5200_wdt_shutdown(struct of_device *op)
+{
+	struct mpc5200_wdt *wdt = dev_get_drvdata(&op->dev);
+	mpc5200_wdt_stop(wdt);
+	return 0;
+}
+
+static struct of_device_id mpc5200_wdt_match[] = {
+	{ .compatible = "mpc5200-gpt", },
+	{},
+};
+static struct of_platform_driver mpc5200_wdt_driver = {
+	.owner		= THIS_MODULE,
+	.name		= "mpc5200-gpt-wdt",
+	.match_table	= mpc5200_wdt_match,
+	.probe		= mpc5200_wdt_probe,
+	.remove		= mpc5200_wdt_remove,
+	.suspend	= mpc5200_wdt_suspend,
+	.resume		= mpc5200_wdt_resume,
+	.shutdown	= mpc5200_wdt_shutdown,
+};
+
+
+static int __init mpc5200_wdt_init(void)
+{
+	return of_register_platform_driver(&mpc5200_wdt_driver);
+}
+
+static void __exit mpc5200_wdt_exit(void)
+{
+	of_unregister_platform_driver(&mpc5200_wdt_driver);
+}
+
+module_init(mpc5200_wdt_init);
+module_exit(mpc5200_wdt_exit);
+
+MODULE_AUTHOR("Domen Puncer <domen.puncer@telargo.com>");
+MODULE_LICENSE("Dual BSD/GPL");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
diff --git a/drivers/char/watchdog/mpc83xx_wdt.c b/drivers/char/watchdog/mpc83xx_wdt.c
index 18ca752..a0bf95f 100644
--- a/drivers/char/watchdog/mpc83xx_wdt.c
+++ b/drivers/char/watchdog/mpc83xx_wdt.c
@@ -119,6 +119,9 @@ static int mpc83xx_wdt_ioctl(struct inode *inode, struct file *file,
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
 		return copy_to_user(argp, &ident, sizeof(ident)) ? -EFAULT : 0;
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, p);
 	case WDIOC_KEEPALIVE:
 		mpc83xx_wdt_keepalive();
 		return 0;
diff --git a/drivers/char/watchdog/mpc8xx_wdt.c b/drivers/char/watchdog/mpc8xx_wdt.c
index 8aaed10..85b5734 100644
--- a/drivers/char/watchdog/mpc8xx_wdt.c
+++ b/drivers/char/watchdog/mpc8xx_wdt.c
@@ -57,7 +57,7 @@ static int mpc8xx_wdt_open(struct inode *inode, struct file *file)
 	m8xx_wdt_reset();
 	mpc8xx_wdt_handler_disable();
 
-	return 0;
+	return nonseekable_open(inode, file);
 }
 
 static int mpc8xx_wdt_release(struct inode *inode, struct file *file)
diff --git a/drivers/char/watchdog/mtx-1_wdt.c b/drivers/char/watchdog/mtx-1_wdt.c
index 419ab44..dcfd401 100644
--- a/drivers/char/watchdog/mtx-1_wdt.c
+++ b/drivers/char/watchdog/mtx-1_wdt.c
@@ -143,6 +143,7 @@ static int mtx1_wdt_ioctl(struct inode *inode, struct file *file, unsigned int c
 			mtx1_wdt_reset();
 			break;
 		case WDIOC_GETSTATUS:
+		case WDIOC_GETBOOTSTATUS:
 			if ( copy_to_user(argp, &value, sizeof(int)) )
 				return -EFAULT;
 			break;
diff --git a/drivers/char/watchdog/mv64x60_wdt.c b/drivers/char/watchdog/mv64x60_wdt.c
index b887cdb..0365c31 100644
--- a/drivers/char/watchdog/mv64x60_wdt.c
+++ b/drivers/char/watchdog/mv64x60_wdt.c
@@ -23,61 +23,101 @@
 #include <linux/watchdog.h>
 #include <linux/platform_device.h>
 
-#include <asm/mv64x60.h>
+#include <linux/mv643xx.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
 
-/* MV64x60 WDC (config) register access definitions */
-#define MV64x60_WDC_CTL1_MASK	(3 << 24)
-#define MV64x60_WDC_CTL1(val)	((val & 3) << 24)
-#define MV64x60_WDC_CTL2_MASK	(3 << 26)
-#define MV64x60_WDC_CTL2(val)	((val & 3) << 26)
+#define MV64x60_WDT_WDC_OFFSET	0
+
+/*
+ * The watchdog configuration register contains a pair of 2-bit fields,
+ *   1.  a reload field, bits 27-26, which triggers a reload of
+ *       the countdown register, and
+ *   2.  an enable field, bits 25-24, which toggles between
+ *       enabling and disabling the watchdog timer.
+ * Bit 31 is a read-only field which indicates whether the
+ * watchdog timer is currently enabled.
+ *
+ * The low 24 bits contain the timer reload value.
+ */
+#define MV64x60_WDC_ENABLE_SHIFT	24
+#define MV64x60_WDC_SERVICE_SHIFT	26
+#define MV64x60_WDC_ENABLED_SHIFT	31
+
+#define MV64x60_WDC_ENABLED_TRUE	1
+#define MV64x60_WDC_ENABLED_FALSE	0
 
 /* Flags bits */
 #define MV64x60_WDOG_FLAG_OPENED	0
-#define MV64x60_WDOG_FLAG_ENABLED	1
 
 static unsigned long wdt_flags;
 static int wdt_status;
-static void __iomem *mv64x60_regs;
+static void __iomem *mv64x60_wdt_regs;
 static int mv64x60_wdt_timeout;
+static int mv64x60_wdt_count;
+static unsigned int bus_clk;
+static char expect_close;
+static DEFINE_SPINLOCK(mv64x60_wdt_spinlock);
+
+static int nowayout = WATCHDOG_NOWAYOUT;
+module_param(nowayout, int, 0);
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
-static void mv64x60_wdt_reg_write(u32 val)
+static int mv64x60_wdt_toggle_wdc(int enabled_predicate, int field_shift)
 {
-	/* Allow write only to CTL1 / CTL2 fields, retaining values in
-	 * other fields.
-	 */
-	u32 data = readl(mv64x60_regs + MV64x60_WDT_WDC);
-	data &= ~(MV64x60_WDC_CTL1_MASK | MV64x60_WDC_CTL2_MASK);
-	data |= val;
-	writel(data, mv64x60_regs + MV64x60_WDT_WDC);
+	u32 data;
+	u32 enabled;
+	int ret = 0;
+
+	spin_lock(&mv64x60_wdt_spinlock);
+	data = readl(mv64x60_wdt_regs + MV64x60_WDT_WDC_OFFSET);
+	enabled = (data >> MV64x60_WDC_ENABLED_SHIFT) & 1;
+
+	/* only toggle the requested field if enabled state matches predicate */
+	if ((enabled ^ enabled_predicate) == 0) {
+		/* We write a 1, then a 2 -- to the appropriate field */
+		data = (1 << field_shift) | mv64x60_wdt_count;
+		writel(data, mv64x60_wdt_regs + MV64x60_WDT_WDC_OFFSET);
+
+		data = (2 << field_shift) | mv64x60_wdt_count;
+		writel(data, mv64x60_wdt_regs + MV64x60_WDT_WDC_OFFSET);
+		ret = 1;
+	}
+	spin_unlock(&mv64x60_wdt_spinlock);
+
+	return ret;
 }
 
 static void mv64x60_wdt_service(void)
 {
-	/* Write 01 followed by 10 to CTL2 */
-	mv64x60_wdt_reg_write(MV64x60_WDC_CTL2(0x01));
-	mv64x60_wdt_reg_write(MV64x60_WDC_CTL2(0x02));
+	mv64x60_wdt_toggle_wdc(MV64x60_WDC_ENABLED_TRUE,
+			       MV64x60_WDC_SERVICE_SHIFT);
+}
+
+static void mv64x60_wdt_handler_enable(void)
+{
+	if (mv64x60_wdt_toggle_wdc(MV64x60_WDC_ENABLED_FALSE,
+				   MV64x60_WDC_ENABLE_SHIFT)) {
+		mv64x60_wdt_service();
+		printk(KERN_NOTICE "mv64x60_wdt: watchdog activated\n");
+	}
 }
 
 static void mv64x60_wdt_handler_disable(void)
 {
-	if (test_and_clear_bit(MV64x60_WDOG_FLAG_ENABLED, &wdt_flags)) {
-		/* Write 01 followed by 10 to CTL1 */
-		mv64x60_wdt_reg_write(MV64x60_WDC_CTL1(0x01));
-		mv64x60_wdt_reg_write(MV64x60_WDC_CTL1(0x02));
+	if (mv64x60_wdt_toggle_wdc(MV64x60_WDC_ENABLED_TRUE,
+				   MV64x60_WDC_ENABLE_SHIFT))
 		printk(KERN_NOTICE "mv64x60_wdt: watchdog deactivated\n");
-	}
 }
 
-static void mv64x60_wdt_handler_enable(void)
+static void mv64x60_wdt_set_timeout(unsigned int timeout)
 {
-	if (!test_and_set_bit(MV64x60_WDOG_FLAG_ENABLED, &wdt_flags)) {
-		/* Write 01 followed by 10 to CTL1 */
-		mv64x60_wdt_reg_write(MV64x60_WDC_CTL1(0x01));
-		mv64x60_wdt_reg_write(MV64x60_WDC_CTL1(0x02));
-		printk(KERN_NOTICE "mv64x60_wdt: watchdog activated\n");
-	}
+	/* maximum bus cycle count is 0xFFFFFFFF */
+	if (timeout > 0xFFFFFFFF / bus_clk)
+		timeout = 0xFFFFFFFF / bus_clk;
+
+	mv64x60_wdt_count = timeout * bus_clk >> 8;
+	mv64x60_wdt_timeout = timeout;
 }
 
 static int mv64x60_wdt_open(struct inode *inode, struct file *file)
@@ -85,21 +125,24 @@ static int mv64x60_wdt_open(struct inode *inode, struct file *file)
 	if (test_and_set_bit(MV64x60_WDOG_FLAG_OPENED, &wdt_flags))
 		return -EBUSY;
 
-	mv64x60_wdt_service();
-	mv64x60_wdt_handler_enable();
+	if (nowayout)
+		__module_get(THIS_MODULE);
 
-	nonseekable_open(inode, file);
+	mv64x60_wdt_handler_enable();
 
-	return 0;
+	return nonseekable_open(inode, file);
 }
 
 static int mv64x60_wdt_release(struct inode *inode, struct file *file)
 {
-	mv64x60_wdt_service();
-
-#if !defined(CONFIG_WATCHDOG_NOWAYOUT)
-	mv64x60_wdt_handler_disable();
-#endif
+	if (expect_close == 42)
+		mv64x60_wdt_handler_disable();
+	else {
+		printk(KERN_CRIT
+		       "mv64x60_wdt: unexpected close, not stopping timer!\n");
+		mv64x60_wdt_service();
+	}
+	expect_close = 0;
 
 	clear_bit(MV64x60_WDOG_FLAG_OPENED, &wdt_flags);
 
@@ -109,8 +152,22 @@ static int mv64x60_wdt_release(struct inode *inode, struct file *file)
 static ssize_t mv64x60_wdt_write(struct file *file, const char __user *data,
 				 size_t len, loff_t * ppos)
 {
-	if (len)
+	if (len) {
+		if (!nowayout) {
+			size_t i;
+
+			expect_close = 0;
+
+			for (i = 0; i != len; i++) {
+				char c;
+				if(get_user(c, data + i))
+					return -EFAULT;
+				if (c == 'V')
+					expect_close = 42;
+			}
+		}
 		mv64x60_wdt_service();
+	}
 
 	return len;
 }
@@ -119,9 +176,12 @@ static int mv64x60_wdt_ioctl(struct inode *inode, struct file *file,
 			     unsigned int cmd, unsigned long arg)
 {
 	int timeout;
+	int options;
 	void __user *argp = (void __user *)arg;
 	static struct watchdog_info info = {
-		.options = WDIOF_KEEPALIVEPING,
+		.options =	WDIOF_SETTIMEOUT	|
+				WDIOF_MAGICCLOSE	|
+				WDIOF_KEEPALIVEPING,
 		.firmware_version = 0,
 		.identity = "MV64x60 watchdog",
 	};
@@ -143,7 +203,15 @@ static int mv64x60_wdt_ioctl(struct inode *inode, struct file *file,
 		return -EOPNOTSUPP;
 
 	case WDIOC_SETOPTIONS:
-		return -EOPNOTSUPP;
+		if (get_user(options, (int __user *)argp))
+			return -EFAULT;
+
+		if (options & WDIOS_DISABLECARD)
+			mv64x60_wdt_handler_disable();
+
+		if (options & WDIOS_ENABLECARD)
+			mv64x60_wdt_handler_enable();
+		break;
 
 	case WDIOC_KEEPALIVE:
 		mv64x60_wdt_service();
@@ -151,11 +219,13 @@ static int mv64x60_wdt_ioctl(struct inode *inode, struct file *file,
 		break;
 
 	case WDIOC_SETTIMEOUT:
-		return -EOPNOTSUPP;
+		if (get_user(timeout, (int __user *)argp))
+			return -EFAULT;
+		mv64x60_wdt_set_timeout(timeout);
+		/* Fall through */
 
 	case WDIOC_GETTIMEOUT:
-		timeout = mv64x60_wdt_timeout * HZ;
-		if (put_user(timeout, (int __user *)argp))
+		if (put_user(mv64x60_wdt_timeout, (int __user *)argp))
 			return -EFAULT;
 		break;
 
@@ -184,18 +254,33 @@ static struct miscdevice mv64x60_wdt_miscdev = {
 static int __devinit mv64x60_wdt_probe(struct platform_device *dev)
 {
 	struct mv64x60_wdt_pdata *pdata = dev->dev.platform_data;
-	int bus_clk = 133;
+	struct resource *r;
+	int timeout = 10;
 
-	mv64x60_wdt_timeout = 10;
+	bus_clk = 133;			/* in MHz */
 	if (pdata) {
-		mv64x60_wdt_timeout = pdata->timeout;
+		timeout = pdata->timeout;
 		bus_clk = pdata->bus_clk;
 	}
 
-	mv64x60_regs = mv64x60_get_bridge_vbase();
+	/* Since bus_clk is truncated MHz, actual frequency could be
+	 * up to 1MHz higher.  Round up, since it's better to time out
+	 * too late than too soon.
+	 */
+	bus_clk++;
+	bus_clk *= 1000000;		/* convert to Hz */
+
+	r = platform_get_resource(dev, IORESOURCE_MEM, 0);
+	if (!r)
+		return -ENODEV;
 
-	writel((mv64x60_wdt_timeout * (bus_clk * 1000000)) >> 8,
-	       mv64x60_regs + MV64x60_WDT_WDC);
+	mv64x60_wdt_regs = ioremap(r->start, r->end - r->start + 1);
+	if (mv64x60_wdt_regs == NULL)
+		return -ENOMEM;
+
+	mv64x60_wdt_set_timeout(timeout);
+
+	mv64x60_wdt_handler_disable();	/* in case timer was already running */
 
 	return misc_register(&mv64x60_wdt_miscdev);
 }
@@ -204,9 +289,10 @@ static int __devexit mv64x60_wdt_remove(struct platform_device *dev)
 {
 	misc_deregister(&mv64x60_wdt_miscdev);
 
-	mv64x60_wdt_service();
 	mv64x60_wdt_handler_disable();
 
+	iounmap(mv64x60_wdt_regs);
+
 	return 0;
 }
 
@@ -219,40 +305,16 @@ static struct platform_driver mv64x60_wdt_driver = {
 	},
 };
 
-static struct platform_device *mv64x60_wdt_dev;
-
 static int __init mv64x60_wdt_init(void)
 {
-	int ret;
-
 	printk(KERN_INFO "MV64x60 watchdog driver\n");
 
-	mv64x60_wdt_dev = platform_device_alloc(MV64x60_WDT_NAME, -1);
-	if (!mv64x60_wdt_dev) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	ret = platform_device_add(mv64x60_wdt_dev);
-	if (ret) {
-		platform_device_put(mv64x60_wdt_dev);
-		goto out;
-	}
-
-	ret = platform_driver_register(&mv64x60_wdt_driver);
-	if (ret) {
-		platform_device_unregister(mv64x60_wdt_dev);
-		goto out;
-	}
-
- out:
-	return ret;
+	return platform_driver_register(&mv64x60_wdt_driver);
 }
 
 static void __exit mv64x60_wdt_exit(void)
 {
 	platform_driver_unregister(&mv64x60_wdt_driver);
-	platform_device_unregister(mv64x60_wdt_dev);
 }
 
 module_init(mv64x60_wdt_init);
diff --git a/drivers/char/watchdog/omap_wdt.c b/drivers/char/watchdog/omap_wdt.c
index b36fa8d..719b066 100644
--- a/drivers/char/watchdog/omap_wdt.c
+++ b/drivers/char/watchdog/omap_wdt.c
@@ -142,7 +142,7 @@ static int omap_wdt_open(struct inode *inode, struct file *file)
 
 	omap_wdt_set_timeout();
 	omap_wdt_enable();
-	return 0;
+	return nonseekable_open(inode, file);
 }
 
 static int omap_wdt_release(struct inode *inode, struct file *file)
@@ -197,7 +197,7 @@ omap_wdt_ioctl(struct inode *inode, struct file *file,
 
 	switch (cmd) {
 	default:
-		return -ENOIOCTLCMD;
+		return -ENOTTY;
 	case WDIOC_GETSUPPORT:
 		return copy_to_user((struct watchdog_info __user *)arg, &ident,
 				sizeof(ident));
diff --git a/drivers/char/watchdog/s3c2410_wdt.c b/drivers/char/watchdog/s3c2410_wdt.c
index 50430bc..5d1c15f 100644
--- a/drivers/char/watchdog/s3c2410_wdt.c
+++ b/drivers/char/watchdog/s3c2410_wdt.c
@@ -52,10 +52,10 @@
 
 #include <asm/arch/map.h>
 
-#undef S3C24XX_VA_WATCHDOG
-#define S3C24XX_VA_WATCHDOG (0)
+#undef S3C_VA_WATCHDOG
+#define S3C_VA_WATCHDOG (0)
 
-#include <asm/arch/regs-watchdog.h>
+#include <asm/plat-s3c/regs-watchdog.h>
 
 #define PFX "s3c2410-wdt: "
 
diff --git a/drivers/char/watchdog/sa1100_wdt.c b/drivers/char/watchdog/sa1100_wdt.c
index 33c1137..3475f47 100644
--- a/drivers/char/watchdog/sa1100_wdt.c
+++ b/drivers/char/watchdog/sa1100_wdt.c
@@ -45,7 +45,6 @@ static int boot_status;
  */
 static int sa1100dog_open(struct inode *inode, struct file *file)
 {
-	nonseekable_open(inode, file);
 	if (test_and_set_bit(1,&sa1100wdt_users))
 		return -EBUSY;
 
@@ -54,7 +53,7 @@ static int sa1100dog_open(struct inode *inode, struct file *file)
 	OSSR = OSSR_M3;
 	OWER = OWER_WME;
 	OIER |= OIER_E3;
-	return 0;
+	return nonseekable_open(inode, file);
 }
 
 /*
diff --git a/drivers/char/watchdog/sbc60xxwdt.c b/drivers/char/watchdog/sbc60xxwdt.c
index b628203..e4f3cb6 100644
--- a/drivers/char/watchdog/sbc60xxwdt.c
+++ b/drivers/char/watchdog/sbc60xxwdt.c
@@ -191,8 +191,6 @@ static ssize_t fop_write(struct file * file, const char __user * buf, size_t cou
 
 static int fop_open(struct inode * inode, struct file * file)
 {
-	nonseekable_open(inode, file);
-
 	/* Just in case we're already talking to someone... */
 	if(test_and_set_bit(0, &wdt_is_open))
 		return -EBUSY;
@@ -202,7 +200,7 @@ static int fop_open(struct inode * inode, struct file * file)
 
 	/* Good, fire up the show */
 	wdt_startup();
-	return 0;
+	return nonseekable_open(inode, file);
 }
 
 static int fop_close(struct inode * inode, struct file * file)
diff --git a/drivers/char/watchdog/sc1200wdt.c b/drivers/char/watchdog/sc1200wdt.c
index 2f7ba7a..9670d47 100644
--- a/drivers/char/watchdog/sc1200wdt.c
+++ b/drivers/char/watchdog/sc1200wdt.c
@@ -150,8 +150,6 @@ static inline int sc1200wdt_status(void)
 
 static int sc1200wdt_open(struct inode *inode, struct file *file)
 {
-	nonseekable_open(inode, file);
-
 	/* allow one at a time */
 	if (down_trylock(&open_sem))
 		return -EBUSY;
@@ -162,7 +160,7 @@ static int sc1200wdt_open(struct inode *inode, struct file *file)
 	sc1200wdt_start();
 	printk(KERN_INFO PFX "Watchdog enabled, timeout = %d min(s)", timeout);
 
-	return 0;
+	return nonseekable_open(inode, file);
 }
 
 
diff --git a/drivers/char/watchdog/sc520_wdt.c b/drivers/char/watchdog/sc520_wdt.c
index 2676a43..e8594c6 100644
--- a/drivers/char/watchdog/sc520_wdt.c
+++ b/drivers/char/watchdog/sc520_wdt.c
@@ -248,8 +248,6 @@ static ssize_t fop_write(struct file * file, const char __user * buf, size_t cou
 
 static int fop_open(struct inode * inode, struct file * file)
 {
-	nonseekable_open(inode, file);
-
 	/* Just in case we're already talking to someone... */
 	if(test_and_set_bit(0, &wdt_is_open))
 		return -EBUSY;
@@ -258,7 +256,7 @@ static int fop_open(struct inode * inode, struct file * file)
 
 	/* Good, fire up the show */
 	wdt_startup();
-	return 0;
+	return nonseekable_open(inode, file);
 }
 
 static int fop_close(struct inode * inode, struct file * file)
diff --git a/drivers/char/watchdog/w83627hf_wdt.c b/drivers/char/watchdog/w83627hf_wdt.c
index b46e7f4..df33b3b 100644
--- a/drivers/char/watchdog/w83627hf_wdt.c
+++ b/drivers/char/watchdog/w83627hf_wdt.c
@@ -4,7 +4,7 @@
  *	(c) Copyright 2007 Vlad Drukker <vlad@storewiz.com>
  *		added support for W83627THF.
  *
- *	(c) Copyright 2003 Pádraig Brady <P@draigBrady.com>
+ *	(c) Copyright 2003,2007 Pádraig Brady <P@draigBrady.com>
  *
  *	Based on advantechwdt.c which is based on wdt.c.
  *	Original copyright messages:
@@ -42,7 +42,7 @@
 #include <asm/uaccess.h>
 #include <asm/system.h>
 
-#define WATCHDOG_NAME "w83627hf/thf WDT"
+#define WATCHDOG_NAME "w83627hf/thf/hg WDT"
 #define PFX WATCHDOG_NAME ": "
 #define WATCHDOG_TIMEOUT 60		/* 60 sec default timeout */
 
@@ -57,7 +57,7 @@ MODULE_PARM_DESC(wdt_io, "w83627hf/thf WDT io port (default 0x2E)");
 
 static int timeout = WATCHDOG_TIMEOUT;	/* in seconds */
 module_param(timeout, int, 0);
-MODULE_PARM_DESC(timeout, "Watchdog timeout in seconds. 1<= timeout <=63, default=" __MODULE_STRING(WATCHDOG_TIMEOUT) ".");
+MODULE_PARM_DESC(timeout, "Watchdog timeout in seconds. 1<= timeout <=255, default=" __MODULE_STRING(WATCHDOG_TIMEOUT) ".");
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
@@ -78,9 +78,9 @@ w83627hf_select_wd_register(void)
 	outb_p(0x87, WDT_EFER); /* Enter extended function mode */
 	outb_p(0x87, WDT_EFER); /* Again according to manual */
 
-	outb(0x20, WDT_EFER); 	/* check chip version	*/
+	outb(0x20, WDT_EFER);	/* check chip version	*/
 	c = inb(WDT_EFDR);
-	if (c == 0x82) {	/* W83627THF 		*/
+	if (c == 0x82) {	/* W83627THF		*/
 		outb_p(0x2b, WDT_EFER); /* select GPIO3 */
 		c = ((inb_p(WDT_EFDR) & 0xf7) | 0x04); /* select WDT0 */
 		outb_p(0x2b, WDT_EFER);
@@ -114,11 +114,17 @@ w83627hf_init(void)
 		printk (KERN_INFO PFX "Watchdog already running. Resetting timeout to %d sec\n", timeout);
 		outb_p(timeout, WDT_EFDR);    /* Write back to CRF6 */
 	}
+
 	outb_p(0xF5, WDT_EFER); /* Select CRF5 */
 	t=inb_p(WDT_EFDR);      /* read CRF5 */
 	t&=~0x0C;               /* set second mode & disable keyboard turning off watchdog */
 	outb_p(t, WDT_EFDR);    /* Write back to CRF5 */
 
+	outb_p(0xF7, WDT_EFER); /* Select CRF7 */
+	t=inb_p(WDT_EFDR);      /* read CRF7 */
+	t&=~0xC0;               /* disable keyboard & mouse turning off watchdog */
+	outb_p(t, WDT_EFDR);    /* Write back to CRF7 */
+
 	w83627hf_unselect_wd_register();
 }
 
@@ -126,7 +132,7 @@ static void
 wdt_ctrl(int timeout)
 {
 	spin_lock(&io_lock);
-	
+
 	w83627hf_select_wd_register();
 
 	outb_p(0xF6, WDT_EFER);    /* Select CRF6 */
@@ -154,7 +160,7 @@ wdt_disable(void)
 static int
 wdt_set_heartbeat(int t)
 {
-	if ((t < 1) || (t > 63))
+	if ((t < 1) || (t > 255))
 		return -EINVAL;
 
 	timeout = t;
@@ -324,11 +330,11 @@ wdt_init(void)
 
 	spin_lock_init(&io_lock);
 
-	printk(KERN_INFO "WDT driver for the Winbond(TM) W83627HF/THF Super I/O chip initialising.\n");
+	printk(KERN_INFO "WDT driver for the Winbond(TM) W83627HF/THF/HG Super I/O chip initialising.\n");
 
 	if (wdt_set_heartbeat(timeout)) {
 		wdt_set_heartbeat(WATCHDOG_TIMEOUT);
-		printk (KERN_INFO PFX "timeout value must be 1<=timeout<=63, using %d\n",
+		printk (KERN_INFO PFX "timeout value must be 1<=timeout<=255, using %d\n",
 			WATCHDOG_TIMEOUT);
 	}
 
diff --git a/include/asm-ppc/mv64x60.h b/include/asm-ppc/mv64x60.h
index db3776f..2963d6a 100644
--- a/include/asm-ppc/mv64x60.h
+++ b/include/asm-ppc/mv64x60.h
@@ -120,14 +120,6 @@ extern spinlock_t mv64x60_lock;
 
 #define	MV64x60_64BIT_WIN_COUNT			24
 
-/* Watchdog Platform Device, Driver Data */
-#define	MV64x60_WDT_NAME			"wdt"
-
-struct mv64x60_wdt_pdata {
-	int	timeout;	/* watchdog expiry in seconds, default 10 */
-	int	bus_clk;	/* bus clock in MHz, default 133 */
-};
-
 /*
  * Define a structure that's used to pass in config information to the
  * core routines.
diff --git a/include/linux/mv643xx.h b/include/linux/mv643xx.h
index b021b3a..9c80490 100644
--- a/include/linux/mv643xx.h
+++ b/include/linux/mv643xx.h
@@ -1302,4 +1302,12 @@ struct mv643xx_eth_platform_data {
 	u8		mac_addr[6];	/* mac address if non-zero*/
 };
 
+/* Watchdog Platform Device, Driver Data */
+#define	MV64x60_WDT_NAME			"mv64x60_wdt"
+
+struct mv64x60_wdt_pdata {
+	int	timeout;	/* watchdog expiry in seconds, default 10 */
+	int	bus_clk;	/* bus clock in MHz, default 133 */
+};
+
 #endif /* __ASM_MV643XX_H */
