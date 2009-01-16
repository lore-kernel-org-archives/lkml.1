Return-Path: <linux-kernel-owner+w=401wt.eu-S1756959AbZAPIbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756959AbZAPIbm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 03:31:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757155AbZAPI15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 03:27:57 -0500
Received: from smtp.nokia.com ([192.100.122.230]:29313 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761871AbZAPI1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 03:27:55 -0500
From: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Subject: [PATCH 02/10] omap mailbox: add initial omap3 support
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-omap@vger.kernel.org
Date: Fri, 16 Jan 2009 10:27:11 +0200
Message-ID: <20090116082711.17571.38818.stgit@oreo.research.nokia.com>
In-Reply-To: <20090116081919.17571.34378.stgit@oreo.research.nokia.com>
References: <20090116081919.17571.34378.stgit@oreo.research.nokia.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jan 2009 08:27:13.0011 (UTC) FILETIME=[3B567430:01C977B4]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
---

 arch/arm/mach-omap2/devices.c              |   36 ++++++++++++----
 arch/arm/mach-omap2/mailbox.c              |   65 +++++++++++++++++-----------
 arch/arm/plat-omap/Kconfig                 |    8 +++
 arch/arm/plat-omap/include/mach/omap34xx.h |    1 
 4 files changed, 77 insertions(+), 33 deletions(-)

diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
index 9d7216f..05baccd 100644
--- a/arch/arm/mach-omap2/devices.c
+++ b/arch/arm/mach-omap2/devices.c
@@ -28,13 +28,14 @@
 #include <mach/eac.h>
 #include <mach/mmc.h>
 
-#if defined(CONFIG_OMAP_DSP) || defined(CONFIG_OMAP_DSP_MODULE)
-#define OMAP2_MBOX_BASE		IO_ADDRESS(OMAP24XX_MAILBOX_BASE)
+#if defined(CONFIG_OMAP_MBOX_FWK) || defined(CONFIG_OMAP_MBOX_FWK_MODULE)
 
-static struct resource mbox_resources[] = {
+#define MBOX_REG_SIZE	0x120
+
+static struct resource omap2_mbox_resources[] = {
 	{
-		.start		= OMAP2_MBOX_BASE,
-		.end		= OMAP2_MBOX_BASE + 0x11f,
+		.start		= OMAP24XX_MAILBOX_BASE,
+		.end		= OMAP24XX_MAILBOX_BASE + MBOX_REG_SIZE - 1,
 		.flags		= IORESOURCE_MEM,
 	},
 	{
@@ -47,20 +48,39 @@ static struct resource mbox_resources[] = {
 	},
 };
 
+static struct resource omap3_mbox_resources[] = {
+	{
+		.start		= OMAP34XX_MAILBOX_BASE,
+		.end		= OMAP34XX_MAILBOX_BASE + MBOX_REG_SIZE - 1,
+		.flags		= IORESOURCE_MEM,
+	},
+	{
+		.start		= INT_24XX_MAIL_U0_MPU,
+		.flags		= IORESOURCE_IRQ,
+	},
+};
+
 static struct platform_device mbox_device = {
 	.name		= "mailbox",
 	.id		= -1,
-	.num_resources	= ARRAY_SIZE(mbox_resources),
-	.resource	= mbox_resources,
 };
 
 static inline void omap_init_mbox(void)
 {
+	if (cpu_is_omap2420()) {
+		mbox_device.num_resources = ARRAY_SIZE(omap2_mbox_resources);
+		mbox_device.resource = omap2_mbox_resources;
+	} else if (cpu_is_omap3430()) {
+		mbox_device.num_resources = ARRAY_SIZE(omap3_mbox_resources);
+		mbox_device.resource = omap3_mbox_resources;
+	} else {
+		return;
+	}
 	platform_device_register(&mbox_device);
 }
 #else
 static inline void omap_init_mbox(void) { }
-#endif
+#endif /* CONFIG_OMAP_MBOX_FWK */
 
 #if defined(CONFIG_OMAP_STI)
 
diff --git a/arch/arm/mach-omap2/mailbox.c b/arch/arm/mach-omap2/mailbox.c
index 0609e2d..3176bb7 100644
--- a/arch/arm/mach-omap2/mailbox.c
+++ b/arch/arm/mach-omap2/mailbox.c
@@ -30,7 +30,7 @@
 #define MAILBOX_IRQ_NEWMSG(u)		(1 << (2 * (u)))
 #define MAILBOX_IRQ_NOTFULL(u)		(1 << (2 * (u) + 1))
 
-static unsigned long mbox_base;
+static void __iomem *mbox_base;
 
 struct omap_mbox2_fifo {
 	unsigned long msg;
@@ -52,14 +52,14 @@ static struct clk *mbox_ick_handle;
 static void omap2_mbox_enable_irq(struct omap_mbox *mbox,
 				  omap_mbox_type_t irq);
 
-static inline unsigned int mbox_read_reg(unsigned int reg)
+static inline unsigned int mbox_read_reg(size_t ofs)
 {
-	return __raw_readl(mbox_base + reg);
+	return __raw_readl(mbox_base + ofs);
 }
 
-static inline void mbox_write_reg(unsigned int val, unsigned int reg)
+static inline void mbox_write_reg(u32 val, size_t ofs)
 {
-	__raw_writel(val, mbox_base + reg);
+	__raw_writel(val, mbox_base + ofs);
 }
 
 /* Mailbox H/W preparations */
@@ -208,7 +208,7 @@ struct omap_mbox mbox_dsp_info = {
 };
 EXPORT_SYMBOL(mbox_dsp_info);
 
-/* IVA */
+#if defined(CONFIG_ARCH_OMAP2420) /* IVA */
 static struct omap_mbox2_priv omap2_mbox_iva_priv = {
 	.tx_fifo = {
 		.msg		= MAILBOX_MESSAGE(2),
@@ -229,17 +229,12 @@ static struct omap_mbox mbox_iva_info = {
 	.ops	= &omap2_mbox_ops,
 	.priv	= &omap2_mbox_iva_priv,
 };
+#endif
 
 static int __init omap2_mbox_probe(struct platform_device *pdev)
 {
 	struct resource *res;
-	int ret = 0;
-
-	if (pdev->num_resources != 3) {
-		dev_err(&pdev->dev, "invalid number of resources: %d\n",
-			pdev->num_resources);
-		return -ENODEV;
-	}
+	int ret;
 
 	/* MBOX base */
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
@@ -247,34 +242,54 @@ static int __init omap2_mbox_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "invalid mem resource\n");
 		return -ENODEV;
 	}
-	mbox_base = res->start;
+	mbox_base = ioremap(res->start, res->end - res->start);
+	if (!mbox_base)
+		return -ENOMEM;
 
-	/* DSP IRQ */
+	/* DSP or IVA2 IRQ */
 	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (unlikely(!res)) {
 		dev_err(&pdev->dev, "invalid irq resource\n");
-		return -ENODEV;
+		ret = -ENODEV;
+		goto err_dsp;
 	}
 	mbox_dsp_info.irq = res->start;
 
 	ret = omap_mbox_register(&mbox_dsp_info);
-
-	/* IVA IRQ */
-	res = platform_get_resource(pdev, IORESOURCE_IRQ, 1);
-	if (unlikely(!res)) {
-		dev_err(&pdev->dev, "invalid irq resource\n");
-		return -ENODEV;
+	if (ret)
+		goto err_dsp;
+
+#if defined(CONFIG_ARCH_OMAP2420) /* IVA */
+	if (cpu_is_omap2420()) {
+		/* IVA IRQ */
+		res = platform_get_resource(pdev, IORESOURCE_IRQ, 1);
+		if (unlikely(!res)) {
+			dev_err(&pdev->dev, "invalid irq resource\n");
+			ret = -ENODEV;
+			goto err_iva1;
+		}
+		mbox_iva_info.irq = res->start;
+		ret = omap_mbox_register(&mbox_iva_info);
+		if (ret)
+			goto err_iva1;
 	}
-	mbox_iva_info.irq = res->start;
-
-	ret = omap_mbox_register(&mbox_iva_info);
+#endif
+	return 0;
 
+err_iva1:
+	omap_mbox_unregister(&mbox_dsp_info);
+err_dsp:
+	iounmap(mbox_base);
 	return ret;
 }
 
 static int omap2_mbox_remove(struct platform_device *pdev)
 {
+#if defined(CONFIG_ARCH_OMAP2420)
+	omap_mbox_unregister(&mbox_iva_info);
+#endif
 	omap_mbox_unregister(&mbox_dsp_info);
+	iounmap(mbox_base);
 	return 0;
 }
 
diff --git a/arch/arm/plat-omap/Kconfig b/arch/arm/plat-omap/Kconfig
index 46d3b0b..6b1d506 100644
--- a/arch/arm/plat-omap/Kconfig
+++ b/arch/arm/plat-omap/Kconfig
@@ -104,6 +104,14 @@ config OMAP_MCBSP
 	  Say Y here if you want support for the OMAP Multichannel
 	  Buffered Serial Port.
 
+config OMAP_MBOX_FWK
+	tristate "Mailbox framework support"
+	depends on ARCH_OMAP
+	default n
+	help
+	  Say Y here if you want to use OMAP Mailbox framework support for
+	  DSP, IVA1.0 and IVA2 in OMAP1/2/3.
+
 choice
         prompt "System timer"
 	default OMAP_MPU_TIMER
diff --git a/arch/arm/plat-omap/include/mach/omap34xx.h b/arch/arm/plat-omap/include/mach/omap34xx.h
index 8e0479f..89173f1 100644
--- a/arch/arm/plat-omap/include/mach/omap34xx.h
+++ b/arch/arm/plat-omap/include/mach/omap34xx.h
@@ -61,6 +61,7 @@
 #define OMAP2_CM_BASE			OMAP3430_CM_BASE
 #define OMAP2_PRM_BASE			OMAP3430_PRM_BASE
 #define OMAP2_VA_IC_BASE		IO_ADDRESS(OMAP34XX_IC_BASE)
+#define OMAP34XX_MAILBOX_BASE		(L4_34XX_BASE + 0x94000)
 
 #endif
 

