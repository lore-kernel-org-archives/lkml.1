Return-Path: <linux-kernel-owner+w=401wt.eu-S1753895AbZBVVzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895AbZBVVzo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 16:55:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751834AbZBVVzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 16:55:35 -0500
Received: from juliette.telenet-ops.be ([195.130.137.74]:37068 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbZBVVze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 16:55:34 -0500
Date: Sun, 22 Feb 2009 22:55:29 +0100
From: Kristof Provost <Kristof@sigsegv.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: sylver.bruneau@googlemail.com, wim@iguana.be
Subject: [PATCH] Make orion5x_wdt aware of runtime-determined timer tick
	rate
Message-ID: <20090222215528.GA6543@nereid>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; x-action=pgp-signed
Content-Disposition: inline
X-PGP-Fingerprint: 6B6E 5EED 8ECF FAE7 1F61  7458 5046 7D0E 11B0 0EE8
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Make orion5x_wdt aware of runtime-determined timer tick rate

orion5x_wdt no longer compiled after the changes in 
ebe35aff883496c07248df82c8576c3b6e84bbbe. The tick rate define (ORION5X_TCLK) 
was removed in favor of a runtime detection. This value is now passed to the
watchdog timer.

Signed-off-by: Kristof Provost <kristof@sigsegv.be>
- ---

diff --git a/arch/arm/mach-orion5x/common.c b/arch/arm/mach-orion5x/common.c
index 0a62337..b15bf78 100644
- --- a/arch/arm/mach-orion5x/common.c
+++ b/arch/arm/mach-orion5x/common.c
@@ -32,6 +32,7 @@
 #include <plat/mv_xor.h>
 #include <plat/orion_nand.h>
 #include <plat/time.h>
+#include <plat/wdt.h>
 #include "common.h"
 
 /*****************************************************************************
@@ -427,6 +428,21 @@ void __init orion5x_uart1_init(void)
 	platform_device_register(&orion5x_uart1);
 }
 
+static struct orion5x_wdt_platform_data orion5x_wdt_data = {
+	.tclk = 0,
+};
+
+static struct platform_device orion5x_wdt = {
+	.name = "orion5x_wdt",
+	.dev  = {
+		.platform_data = &orion5x_wdt_data,
+	},
+};
+
+void __init orion5x_wdt_init(void)
+{
+	platform_device_register(&orion5x_wdt);
+}
 
 /*****************************************************************************
  * XOR engine
@@ -610,6 +626,7 @@ void __init orion5x_init(void)
 	orion5x_spi_plat_data.tclk = orion5x_tclk;
 	orion5x_uart0_data[0].uartclk = orion5x_tclk;
 	orion5x_uart1_data[0].uartclk = orion5x_tclk;
+	orion5x_wdt_data.tclk = orion5x_tclk;
 
 	/*
 	 * Setup Orion address map
diff --git a/arch/arm/mach-orion5x/common.h b/arch/arm/mach-orion5x/common.h
index 798b9a5..9628b81 100644
- --- a/arch/arm/mach-orion5x/common.h
+++ b/arch/arm/mach-orion5x/common.h
@@ -36,6 +36,7 @@ void orion5x_sata_init(struct mv_sata_platform_data *sata_data);
 void orion5x_spi_init(void);
 void orion5x_uart0_init(void);
 void orion5x_uart1_init(void);
+void orion5x_wdt_init(void);
 void orion5x_xor_init(void);
 
 /*
diff --git a/arch/arm/mach-orion5x/include/mach/hardware.h b/arch/arm/mach-orion5x/include/mach/hardware.h
index e51aaf4..8125184 100644
- --- a/arch/arm/mach-orion5x/include/mach/hardware.h
+++ b/arch/arm/mach-orion5x/include/mach/hardware.h
@@ -17,5 +17,8 @@
 #define PCIBIOS_MIN_MEM		0x01000000
 #define PCIMEM_BASE		ORION5X_PCIE_MEM_PHYS_BASE
 
+struct orion_wdt_data {
+	int tclk;
+};
 
 #endif
diff --git a/arch/arm/mach-orion5x/ts78xx-setup.c b/arch/arm/mach-orion5x/ts78xx-setup.c
index 1368e9f..38a06b4 100644
- --- a/arch/arm/mach-orion5x/ts78xx-setup.c
+++ b/arch/arm/mach-orion5x/ts78xx-setup.c
@@ -255,6 +255,7 @@ static void __init ts78xx_init(void)
 	orion5x_sata_init(&ts78xx_sata_data);
 	orion5x_uart0_init();
 	orion5x_uart1_init();
+	orion5x_wdt_init();
 	orion5x_xor_init();
 
 	orion5x_setup_dev_boot_win(TS78XX_NOR_BOOT_BASE,
diff --git a/arch/arm/plat-orion/include/plat/wdt.h b/arch/arm/plat-orion/include/plat/wdt.h
new file mode 100644
index 0000000..1f407d0
- --- /dev/null
+++ b/arch/arm/plat-orion/include/plat/wdt.h
@@ -0,0 +1,14 @@
+/*
+ * arch/arm/plat-orion/include/plat/wdt.h
+ *
+ * Marvell watchdog platform device data definition file.
+ */
+
+#ifndef __PLAT_WDT_H
+#define __PLAT_WDT_H
+
+struct orion5x_wdt_platform_data {
+	int tclk;
+};
+
+#endif
diff --git a/drivers/watchdog/orion5x_wdt.c b/drivers/watchdog/orion5x_wdt.c
index 14a339f..dedfe9b 100644
- --- a/drivers/watchdog/orion5x_wdt.c
+++ b/drivers/watchdog/orion5x_wdt.c
@@ -16,11 +16,13 @@
 #include <linux/kernel.h>
 #include <linux/fs.h>
 #include <linux/miscdevice.h>
+#include <linux/platform_device.h>
 #include <linux/watchdog.h>
 #include <linux/init.h>
 #include <linux/uaccess.h>
 #include <linux/io.h>
 #include <linux/spinlock.h>
+#include <plat/wdt.h>
 
 /*
  * Watchdog timer block registers.
@@ -29,12 +31,13 @@
 #define  WDT_EN			0x0010
 #define WDT_VAL			(TIMER_VIRT_BASE + 0x0024)
 
- -#define WDT_MAX_DURATION	(0xffffffff / ORION5X_TCLK)
 #define WDT_IN_USE		0
 #define WDT_OK_TO_CLOSE		1
 
+struct orion5x_wdt_platform_data *orion5x_wdt_data;
+
 static int nowayout = WATCHDOG_NOWAYOUT;
- -static int heartbeat =  WDT_MAX_DURATION;	/* (seconds) */
+static int heartbeat;
 static unsigned long wdt_status;
 static spinlock_t wdt_lock;
 
@@ -45,7 +48,7 @@ static void wdt_enable(void)
 	spin_lock(&wdt_lock);
 
 	/* Set watchdog duration */
- -	writel(ORION5X_TCLK * heartbeat, WDT_VAL);
+	writel(orion5x_wdt_data->tclk * heartbeat, WDT_VAL);
 
 	/* Clear watchdog timer interrupt */
 	reg = readl(BRIDGE_CAUSE);
@@ -87,7 +90,7 @@ static void wdt_disable(void)
 static int orion5x_wdt_get_timeleft(int *time_left)
 {
 	spin_lock(&wdt_lock);
- -	*time_left = readl(WDT_VAL) / ORION5X_TCLK;
+	*time_left = readl(WDT_VAL) / orion5x_wdt_data->tclk;
 	spin_unlock(&wdt_lock);
 	return 0;
 }
@@ -157,7 +160,7 @@ static long orion5x_wdt_ioctl(struct file *file, unsigned int cmd,
 		if (ret)
 			break;
 
- -		if (time <= 0 || time > WDT_MAX_DURATION) {
+		if (time <= 0 || time * orion5x_wdt_data->tclk > 0xffffffff) {
 			ret = -EINVAL;
 			break;
 		}
@@ -193,7 +196,6 @@ static int orion5x_wdt_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
- -
 static const struct file_operations orion5x_wdt_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
@@ -205,15 +207,21 @@ static const struct file_operations orion5x_wdt_fops = {
 
 static struct miscdevice orion5x_wdt_miscdev = {
 	.minor		= WATCHDOG_MINOR,
- -	.name		= "watchdog",
+	.name		= "orion5x_wdt",
 	.fops		= &orion5x_wdt_fops,
 };
 
- -static int __init orion5x_wdt_init(void)
+static int __init orion5x_wdt_probe(struct platform_device *pdev)
 {
 	int ret;
 
+	orion5x_wdt_data = pdev->dev.platform_data;
+
+	if (!orion5x_wdt_data)
+		return -ENODEV;
+
 	spin_lock_init(&wdt_lock);
+	heartbeat = 0xffffffff / orion5x_wdt_data->tclk;
 
 	ret = misc_register(&orion5x_wdt_miscdev);
 	if (ret == 0)
@@ -223,9 +231,27 @@ static int __init orion5x_wdt_init(void)
 	return ret;
 }
 
+static int __devexit orion5x_wdt_remove(struct platform_device *pdev)
+{
+	return misc_deregister(&orion5x_wdt_miscdev);
+}
+
+static struct platform_driver orion5x_wdt_driver = {
+	.remove = __devexit_p(orion5x_wdt_remove),
+	.driver = {
+		.name = "orion5x_wdt",
+		.owner = THIS_MODULE,
+	},
+};
+
+static int __init orion5x_wdt_init(void)
+{
+	return platform_driver_probe(&orion5x_wdt_driver, orion5x_wdt_probe);
+}
+
 static void __exit orion5x_wdt_exit(void)
 {
- -	misc_deregister(&orion5x_wdt_miscdev);
+	platform_driver_unregister(&orion5x_wdt_driver);
 }
 
 module_init(orion5x_wdt_init);
@@ -235,8 +261,7 @@ MODULE_AUTHOR("Sylver Bruneau <sylver.bruneau@googlemail.com>");
 MODULE_DESCRIPTION("Orion5x Processor Watchdog");
 
 module_param(heartbeat, int, 0);
- -MODULE_PARM_DESC(heartbeat, "Watchdog heartbeat in seconds (default is "
- -					__MODULE_STRING(WDT_MAX_DURATION) ")");
+MODULE_PARM_DESC(heartbeat, "Watchdog heartbeat in seconds.");
 
 module_param(nowayout, int, 0);
 MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started");
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkmhyc4ACgkQUEZ9DhGwDugw/gCfch/duWplcIbi0GcqdxMaugvl
rPQAn1pTQrX9gEx6Tp3ARlZkO50G/0hA
=8oe5
-----END PGP SIGNATURE-----
