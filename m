Return-Path: <linux-kernel-owner+w=401wt.eu-S1762916AbXGXSJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762916AbXGXSJ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 14:09:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756840AbXGXSJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 14:09:20 -0400
Received: from xyzzy.farnsworth.org ([65.39.95.219]:1829 "HELO farnsworth.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753198AbXGXSJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 14:09:19 -0400
From: "Dale Farnsworth" <dale@farnsworth.org>
Date: Tue, 24 Jul 2007 11:09:18 -0700
To: Wim Van Sebroeck <wim@iguana.be>, linux-kernel@vger.kernel.org
Subject: [PATCH 02/11] mv64x60_wdt: Get register address from platform data
Message-ID: <20070724180917.GB27445@xyzzy.farnsworth.org>
References: <20070724180738.GA27445@xyzzy.farnsworth.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070724180738.GA27445@xyzzy.farnsworth.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Previously, the address of the watchdog timer registers was
retrieved by calling a global function, mv64x60_get_bridge_vbase().
That function doesn't exist in arch/powerpc.  Instead, we now get
the register address from a platform data resource and ioremap
the registers within the driver.

Signed-off-by: Dale Farnsworth <dale@farnsworth.org>
---
 drivers/char/watchdog/mv64x60_wdt.c |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

Index: linux-2.6-powerpc-wdt/drivers/char/watchdog/mv64x60_wdt.c
===================================================================
--- linux-2.6-powerpc-wdt.orig/drivers/char/watchdog/mv64x60_wdt.c	2007-07-18 23:12:48.000000000 +0000
+++ linux-2.6-powerpc-wdt/drivers/char/watchdog/mv64x60_wdt.c	2007-07-19 00:05:37.000000000 +0000
@@ -27,6 +27,8 @@
 #include <asm/uaccess.h>
 #include <asm/io.h>
 
+#define MV64x60_WDT_WDC_OFFSET	0
+
 /* MV64x60 WDC (config) register access definitions */
 #define MV64x60_WDC_CTL1_MASK	(3 << 24)
 #define MV64x60_WDC_CTL1(val)	((val & 3) << 24)
@@ -39,7 +41,7 @@
 
 static unsigned long wdt_flags;
 static int wdt_status;
-static void __iomem *mv64x60_regs;
+static void __iomem *mv64x60_wdt_regs;
 static int mv64x60_wdt_timeout;
 
 static void mv64x60_wdt_reg_write(u32 val)
@@ -47,10 +49,10 @@ static void mv64x60_wdt_reg_write(u32 va
 	/* Allow write only to CTL1 / CTL2 fields, retaining values in
 	 * other fields.
 	 */
-	u32 data = readl(mv64x60_regs + MV64x60_WDT_WDC);
+	u32 data = readl(mv64x60_wdt_regs + MV64x60_WDT_WDC_OFFSET);
 	data &= ~(MV64x60_WDC_CTL1_MASK | MV64x60_WDC_CTL2_MASK);
 	data |= val;
-	writel(data, mv64x60_regs + MV64x60_WDT_WDC);
+	writel(data, mv64x60_wdt_regs + MV64x60_WDT_WDC_OFFSET);
 }
 
 static void mv64x60_wdt_service(void)
@@ -185,6 +187,7 @@ static int __devinit mv64x60_wdt_probe(s
 {
 	struct mv64x60_wdt_pdata *pdata = dev->dev.platform_data;
 	int bus_clk = 133;
+	struct resource *r;
 
 	mv64x60_wdt_timeout = 10;
 	if (pdata) {
@@ -192,10 +195,16 @@ static int __devinit mv64x60_wdt_probe(s
 		bus_clk = pdata->bus_clk;
 	}
 
-	mv64x60_regs = mv64x60_get_bridge_vbase();
+	r = platform_get_resource(dev, IORESOURCE_MEM, 0);
+	if (!r)
+		return -ENODEV;
+
+	mv64x60_wdt_regs = ioremap(r->start, r->end - r->start + 1);
+	if (mv64x60_wdt_regs == NULL)
+		return -ENOMEM;
 
 	writel((mv64x60_wdt_timeout * (bus_clk * 1000000)) >> 8,
-	       mv64x60_regs + MV64x60_WDT_WDC);
+	       mv64x60_wdt_regs + MV64x60_WDT_WDC_OFFSET);
 
 	return misc_register(&mv64x60_wdt_miscdev);
 }
@@ -207,6 +216,8 @@ static int __devexit mv64x60_wdt_remove(
 	mv64x60_wdt_service();
 	mv64x60_wdt_handler_disable();
 
+	iounmap(mv64x60_wdt_regs);
+
 	return 0;
 }
 

