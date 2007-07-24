Return-Path: <linux-kernel-owner+w=401wt.eu-S1761312AbXGXSMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761312AbXGXSMd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 14:12:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755340AbXGXSM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 14:12:26 -0400
Received: from xyzzy.farnsworth.org ([65.39.95.219]:1843 "HELO farnsworth.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753340AbXGXSMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 14:12:25 -0400
From: "Dale Farnsworth" <dale@farnsworth.org>
Date: Tue, 24 Jul 2007 11:12:24 -0700
To: Wim Van Sebroeck <wim@iguana.be>, linux-kernel@vger.kernel.org
Subject: [PATCH 03/11] mv64x60_wdt: Add arch/powerpc platform support
Message-ID: <20070724181224.GC27445@xyzzy.farnsworth.org>
References: <20070724180738.GA27445@xyzzy.farnsworth.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070724180738.GA27445@xyzzy.farnsworth.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for arch/powerpc, specifically for  the prpmc2800 platform.

Signed-off-by: Dale Farnsworth <dale@farnsworth.org>
---
 arch/powerpc/boot/dts/prpmc2800.dts |    6 ++
 arch/powerpc/sysdev/mv64x60_dev.c   |   64 ++++++++++++++++++++++++++
 drivers/char/watchdog/mv64x60_wdt.c |    2 
 include/asm-ppc/mv64x60.h           |    8 ---
 include/linux/mv643xx.h             |    8 +++
 5 files changed, 79 insertions(+), 9 deletions(-)

Index: linux-2.6-powerpc-wdt/arch/powerpc/boot/dts/prpmc2800.dts
===================================================================
--- linux-2.6-powerpc-wdt.orig/arch/powerpc/boot/dts/prpmc2800.dts	2007-07-20 16:41:08.000000000 +0000
+++ linux-2.6-powerpc-wdt/arch/powerpc/boot/dts/prpmc2800.dts	2007-07-20 16:42:09.000000000 +0000
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
Index: linux-2.6-powerpc-wdt/arch/powerpc/sysdev/mv64x60_dev.c
===================================================================
--- linux-2.6-powerpc-wdt.orig/arch/powerpc/sysdev/mv64x60_dev.c	2007-07-20 16:41:08.000000000 +0000
+++ linux-2.6-powerpc-wdt/arch/powerpc/sysdev/mv64x60_dev.c	2007-07-20 16:45:26.000000000 +0000
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
@@ -414,6 +469,15 @@ static int __init mv64x60_device_setup(v
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
Index: linux-2.6-powerpc-wdt/drivers/char/watchdog/mv64x60_wdt.c
===================================================================
--- linux-2.6-powerpc-wdt.orig/drivers/char/watchdog/mv64x60_wdt.c	2007-07-20 16:41:37.000000000 +0000
+++ linux-2.6-powerpc-wdt/drivers/char/watchdog/mv64x60_wdt.c	2007-07-20 16:48:00.000000000 +0000
@@ -23,7 +23,7 @@
 #include <linux/watchdog.h>
 #include <linux/platform_device.h>
 
-#include <asm/mv64x60.h>
+#include <linux/mv643xx.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
 
Index: linux-2.6-powerpc-wdt/include/asm-ppc/mv64x60.h
===================================================================
--- linux-2.6-powerpc-wdt.orig/include/asm-ppc/mv64x60.h	2007-07-20 16:41:11.000000000 +0000
+++ linux-2.6-powerpc-wdt/include/asm-ppc/mv64x60.h	2007-07-20 16:42:09.000000000 +0000
@@ -120,14 +120,6 @@ extern spinlock_t mv64x60_lock;
 
 #define	MV64x60_64BIT_WIN_COUNT			24
 
-/* Watchdog Platform Device, Driver Data */
-#define	MV64x60_WDT_NAME			"mv64x60_wdt"
-
-struct mv64x60_wdt_pdata {
-	int	timeout;	/* watchdog expiry in seconds, default 10 */
-	int	bus_clk;	/* bus clock in MHz, default 133 */
-};
-
 /*
  * Define a structure that's used to pass in config information to the
  * core routines.
Index: linux-2.6-powerpc-wdt/include/linux/mv643xx.h
===================================================================
--- linux-2.6-powerpc-wdt.orig/include/linux/mv643xx.h	2007-07-20 16:41:08.000000000 +0000
+++ linux-2.6-powerpc-wdt/include/linux/mv643xx.h	2007-07-20 16:42:09.000000000 +0000
@@ -1306,4 +1306,12 @@ struct mv643xx_eth_platform_data {
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

