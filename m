Return-Path: <linux-kernel-owner+w=401wt.eu-S1759709AbXGXSHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759709AbXGXSHs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 14:07:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753272AbXGXSHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 14:07:41 -0400
Received: from xyzzy.farnsworth.org ([65.39.95.219]:1814 "HELO farnsworth.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753198AbXGXSHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 14:07:40 -0400
From: "Dale Farnsworth" <dale@farnsworth.org>
Date: Tue, 24 Jul 2007 11:07:38 -0700
To: Wim Van Sebroeck <wim@iguana.be>, linux-kernel@vger.kernel.org
Subject: [PATCH 01/11] mv64x60_wdt: set up platform_device in platform code
Message-ID: <20070724180738.GA27445@xyzzy.farnsworth.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The driver previously registered its platform device data in its own
init function--that's bogus.  Move that code to platform-specific
code in arch/ppc.  This is being done so that the platform code can
decide at runtime whether to initialize this driver or not.

Signed-off-by: Dale Farnsworth <dale@farnsworth.org>
---
 arch/ppc/syslib/mv64x60.c           |   29 ++++++++++++++++++++++++++
 drivers/char/watchdog/mv64x60_wdt.c |   26 -----------------------
 include/asm-ppc/mv64x60.h           |    2 -
 3 files changed, 31 insertions(+), 26 deletions(-)

Index: linux-2.6-powerpc-wdt/arch/ppc/syslib/mv64x60.c
===================================================================
--- linux-2.6-powerpc-wdt.orig/arch/ppc/syslib/mv64x60.c	2007-07-20 00:49:16.000000000 +0000
+++ linux-2.6-powerpc-wdt/arch/ppc/syslib/mv64x60.c	2007-07-20 00:52:19.000000000 +0000
@@ -440,6 +440,32 @@ static struct platform_device i2c_device
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
@@ -475,6 +501,9 @@ static struct platform_device *mv64x60_p
 #ifdef	CONFIG_I2C_MV64XXX
 	&i2c_device,
 #endif
+#ifdef	CONFIG_MV64X60_WDT
+	&wdt_device,
+#endif
 #if defined(CONFIG_SYSFS) && !defined(CONFIG_GT64260)
 	&mv64xxx_device,
 #endif
Index: linux-2.6-powerpc-wdt/drivers/char/watchdog/mv64x60_wdt.c
===================================================================
--- linux-2.6-powerpc-wdt.orig/drivers/char/watchdog/mv64x60_wdt.c	2007-07-20 00:49:16.000000000 +0000
+++ linux-2.6-powerpc-wdt/drivers/char/watchdog/mv64x60_wdt.c	2007-07-20 00:49:18.000000000 +0000
@@ -219,40 +219,16 @@ static struct platform_driver mv64x60_wd
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
Index: linux-2.6-powerpc-wdt/include/asm-ppc/mv64x60.h
===================================================================
--- linux-2.6-powerpc-wdt.orig/include/asm-ppc/mv64x60.h	2007-07-20 00:49:16.000000000 +0000
+++ linux-2.6-powerpc-wdt/include/asm-ppc/mv64x60.h	2007-07-20 00:49:18.000000000 +0000
@@ -121,7 +121,7 @@ extern spinlock_t mv64x60_lock;
 #define	MV64x60_64BIT_WIN_COUNT			24
 
 /* Watchdog Platform Device, Driver Data */
-#define	MV64x60_WDT_NAME			"wdt"
+#define	MV64x60_WDT_NAME			"mv64x60_wdt"
 
 struct mv64x60_wdt_pdata {
 	int	timeout;	/* watchdog expiry in seconds, default 10 */
