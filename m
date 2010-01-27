Return-Path: <linux-kernel-owner+w=401wt.eu-S1754605Ab0A0Tck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab0A0Tck (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 14:32:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754456Ab0A0Tch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 14:32:37 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:44197 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340Ab0A0Tcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 14:32:36 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,5874"; a="32915981"
From: adharmap@codeaurora.org
To: linux-arm-kernel@lists.infradead.org
Cc: Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Yinghai Lu <yinghai@kernel.org>, Tony Lindgren <tony@atomide.com>,
       Santosh Shilimkar <santosh.shilimkar@ti.com>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Kalle Valo <kalle.valo@iki.fi>, Jean Pihet <jpihet@mvista.com>,
       Linus Walleij <linus.walleij@stericsson.com>,
       Colin Tuckley <colin.tuckley@arm.com>,
       Philby John <pjohn@in.mvista.com>,
       Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
       Alessandro Rubini <rubini@unipv.it>,
       Andrea Gallo <andrea.gallo@stericsson.com>,
       linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
       Abhijeet Dharmapurikar <adharmap@quicinc.com>
Subject: [RFC PATCH 5/5] gic: initialize interrupts as per argument
Date: Wed, 27 Jan 2010 11:32:29 -0800
Message-Id: <1264620749-24527-6-git-send-email-adharmap@codeaurora.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1264620749-24527-1-git-send-email-adharmap@codeaurora.org>
References: <1264620749-24527-1-git-send-email-adharmap@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abhijeet Dharmapurikar <adharmap@quicinc.com>

Initialize interrupts as per an argument passed instead of initializing
them as active level low triggered interrupts.

Signed-off-by: Abhijeet Dharmapurikar <adharmap@quicinc.com>
---
 Configuring level triggered interrupts as default may not be correct on
 some platforms, this changes the default behaviour of the gic_dist_init 
 function and also adds a flag to indicate whether the default should be level
 or edge.

 an argument. 
 arch/arm/common/gic.c                    |   25 ++++++++++++++++++-------
 arch/arm/include/asm/hardware/gic.h      |    3 ++-
 arch/arm/mach-omap2/board-4430sdp.c      |    3 ++-
 arch/arm/mach-realview/realview_eb.c     |   10 +++++++---
 arch/arm/mach-realview/realview_pb1176.c |    7 +++++--
 arch/arm/mach-realview/realview_pb11mp.c |    7 +++++--
 arch/arm/mach-realview/realview_pba8.c   |    4 +++-
 arch/arm/mach-realview/realview_pbx.c    |    5 +++--
 arch/arm/mach-ux500/cpu-u8500.c          |    2 +-
 9 files changed, 46 insertions(+), 20 deletions(-)

diff --git a/arch/arm/common/gic.c b/arch/arm/common/gic.c
index d47a1d7..1437f8e 100644
--- a/arch/arm/common/gic.c
+++ b/arch/arm/common/gic.c
@@ -236,10 +236,11 @@ void __init gic_cascade_irq(unsigned int gic_nr, unsigned int irq)
 /*
  * In case of multiple cascaded GICs, order calls to gic_dist_init with
  * ascending irq_start
+ * flags are checked to initialize the config registers to level or edge
  */
 
 void __init gic_dist_init(unsigned int gic_nr, void __iomem *base,
-			  unsigned int irq_start)
+			  unsigned int irq_start, unsigned int flags)
 {
 	unsigned int max_irq, i;
 	u32 cpumask = 1 << smp_processor_id();
@@ -269,11 +270,17 @@ void __init gic_dist_init(unsigned int gic_nr, void __iomem *base,
 	if (max_irq > max(1020, NR_IRQS))
 		max_irq = max(1020, NR_IRQS);
 
-	/*
-	 * Set all global interrupts to be level triggered, active low.
-	 */
-	for (i = 32; i < max_irq; i += 16)
-		writel(0, base + GIC_DIST_CONFIG + i * 4 / 16);
+	/* default to level trigger if nothing specified */
+	if ((flags & IRQ_TYPE_SENSE_MASK) == 0)
+		flags |= IRQ_TYPE_LEVEL_LOW;
+
+	if (flags & (IRQ_TYPE_LEVEL_HIGH|IRQ_TYPE_LEVEL_LOW)) {
+		for (i = 32; i < max_irq; i += 16)
+			writel(0, base + GIC_DIST_CONFIG + i * 4 / 16);
+	} else {
+		for (i = 16; i < max_irq; i += 16)
+			writel(0xFFFFFFFF, base + GIC_DIST_CONFIG + i * 4 / 16);
+	}
 
 	/*
 	 * Set all global interrupts to this CPU only.
@@ -293,13 +300,17 @@ void __init gic_dist_init(unsigned int gic_nr, void __iomem *base,
 	for (i = 0; i < max_irq; i += 32)
 		writel(0xffffffff, base + GIC_DIST_ENABLE_CLEAR + i * 4 / 32);
 
+
 	/*
 	 * Setup the Linux IRQ subsystem.
 	 */
 	for (i = irq_start; i < NR_IRQS && i < gic_data[gic_nr].irq_offset + max_irq; i++) {
 		set_irq_chip(i, &gic_chip);
 		set_irq_chip_data(i, &gic_data[gic_nr]);
-		set_irq_handler(i, handle_level_irq);
+		if (flags & (IRQ_TYPE_LEVEL_HIGH|IRQ_TYPE_LEVEL_LOW))
+			set_irq_handler(i, handle_level_irq);
+		else
+			set_irq_handler(i, handle_edge_irq);
 		set_irq_flags(i, IRQF_VALID | IRQF_PROBE);
 	}
 
diff --git a/arch/arm/include/asm/hardware/gic.h b/arch/arm/include/asm/hardware/gic.h
index 7f34333..7ebccdc 100644
--- a/arch/arm/include/asm/hardware/gic.h
+++ b/arch/arm/include/asm/hardware/gic.h
@@ -33,7 +33,8 @@
 #define GIC_DIST_SOFTINT		0xf00
 
 #ifndef __ASSEMBLY__
-void gic_dist_init(unsigned int gic_nr, void __iomem *base, unsigned int irq_start);
+void gic_dist_init(unsigned int gic_nr, void __iomem *base,
+			unsigned int irq_start, unsigned int flags);
 void gic_cpu_init(unsigned int gic_nr, void __iomem *base);
 void gic_cascade_irq(unsigned int gic_nr, unsigned int irq);
 void gic_raise_softirq(const struct cpumask *mask, unsigned int irq);
diff --git a/arch/arm/mach-omap2/board-4430sdp.c b/arch/arm/mach-omap2/board-4430sdp.c
index 0c6be6b..1f895e9 100644
--- a/arch/arm/mach-omap2/board-4430sdp.c
+++ b/arch/arm/mach-omap2/board-4430sdp.c
@@ -17,6 +17,7 @@
 #include <linux/platform_device.h>
 #include <linux/io.h>
 #include <linux/gpio.h>
+#include <linux/irq.h>
 
 #include <mach/hardware.h>
 #include <asm/mach-types.h>
@@ -57,7 +58,7 @@ static void __init gic_init_irq(void)
 	/* Static mapping, never released */
 	base = ioremap(OMAP44XX_GIC_DIST_BASE, SZ_4K);
 	BUG_ON(!base);
-	gic_dist_init(0, base, 29);
+	gic_dist_init(0, base, 29, IRQ_TYPE_LEVEL_LOW);
 
 	/* Static mapping, never released */
 	gic_cpu_base_addr = ioremap(OMAP44XX_GIC_CPU_BASE, SZ_512);
diff --git a/arch/arm/mach-realview/realview_eb.c b/arch/arm/mach-realview/realview_eb.c
index 7d857d3..cb119f9 100644
--- a/arch/arm/mach-realview/realview_eb.c
+++ b/arch/arm/mach-realview/realview_eb.c
@@ -26,6 +26,7 @@
 #include <linux/amba/pl061.h>
 #include <linux/amba/mmci.h>
 #include <linux/io.h>
+#include <linux/irq.h>
 
 #include <mach/hardware.h>
 #include <asm/irq.h>
@@ -308,19 +309,22 @@ static void __init gic_init_irq(void)
 
 		/* core tile GIC, primary */
 		gic_cpu_base_addr = __io_address(REALVIEW_EB11MP_GIC_CPU_BASE);
-		gic_dist_init(0, __io_address(REALVIEW_EB11MP_GIC_DIST_BASE), 29);
+		gic_dist_init(0, __io_address(REALVIEW_EB11MP_GIC_DIST_BASE),
+			29, IRQ_TYPE_LEVEL_LOW);
 		gic_cpu_init(0, gic_cpu_base_addr);
 
 #ifndef CONFIG_REALVIEW_EB_ARM11MP_REVB
 		/* board GIC, secondary */
-		gic_dist_init(1, __io_address(REALVIEW_EB_GIC_DIST_BASE), 64);
+		gic_dist_init(1, __io_address(REALVIEW_EB_GIC_DIST_BASE),
+			64, IRQ_TYPE_LEVEL_LOW);
 		gic_cpu_init(1, __io_address(REALVIEW_EB_GIC_CPU_BASE));
 		gic_cascade_irq(1, IRQ_EB11MP_EB_IRQ1);
 #endif
 	} else {
 		/* board GIC, primary */
 		gic_cpu_base_addr = __io_address(REALVIEW_EB_GIC_CPU_BASE);
-		gic_dist_init(0, __io_address(REALVIEW_EB_GIC_DIST_BASE), 29);
+		gic_dist_init(0, __io_address(REALVIEW_EB_GIC_DIST_BASE),
+			29, IRQ_TYPE_LEVEL_LOW);
 		gic_cpu_init(0, gic_cpu_base_addr);
 	}
 }
diff --git a/arch/arm/mach-realview/realview_pb1176.c b/arch/arm/mach-realview/realview_pb1176.c
index 44392e5..1e218f2 100644
--- a/arch/arm/mach-realview/realview_pb1176.c
+++ b/arch/arm/mach-realview/realview_pb1176.c
@@ -26,6 +26,7 @@
 #include <linux/amba/pl061.h>
 #include <linux/amba/mmci.h>
 #include <linux/io.h>
+#include <linux/irq.h>
 
 #include <mach/hardware.h>
 #include <asm/irq.h>
@@ -267,11 +268,13 @@ static void __init gic_init_irq(void)
 {
 	/* ARM1176 DevChip GIC, primary */
 	gic_cpu_base_addr = __io_address(REALVIEW_DC1176_GIC_CPU_BASE);
-	gic_dist_init(0, __io_address(REALVIEW_DC1176_GIC_DIST_BASE), IRQ_DC1176_GIC_START);
+	gic_dist_init(0, __io_address(REALVIEW_DC1176_GIC_DIST_BASE),
+		IRQ_DC1176_GIC_START, IRQ_TYPE_LEVEL_LOW);
 	gic_cpu_init(0, gic_cpu_base_addr);
 
 	/* board GIC, secondary */
-	gic_dist_init(1, __io_address(REALVIEW_PB1176_GIC_DIST_BASE), IRQ_PB1176_GIC_START);
+	gic_dist_init(1, __io_address(REALVIEW_PB1176_GIC_DIST_BASE),
+		IRQ_PB1176_GIC_START, IRQ_TYPE_LEVEL_LOW);
 	gic_cpu_init(1, __io_address(REALVIEW_PB1176_GIC_CPU_BASE));
 	gic_cascade_irq(1, IRQ_DC1176_PB_IRQ1);
 }
diff --git a/arch/arm/mach-realview/realview_pb11mp.c b/arch/arm/mach-realview/realview_pb11mp.c
index 3e02731..2d45f9f 100644
--- a/arch/arm/mach-realview/realview_pb11mp.c
+++ b/arch/arm/mach-realview/realview_pb11mp.c
@@ -26,6 +26,7 @@
 #include <linux/amba/pl061.h>
 #include <linux/amba/mmci.h>
 #include <linux/io.h>
+#include <linux/irq.h>
 
 #include <mach/hardware.h>
 #include <asm/irq.h>
@@ -273,11 +274,13 @@ static void __init gic_init_irq(void)
 
 	/* ARM11MPCore test chip GIC, primary */
 	gic_cpu_base_addr = __io_address(REALVIEW_TC11MP_GIC_CPU_BASE);
-	gic_dist_init(0, __io_address(REALVIEW_TC11MP_GIC_DIST_BASE), 29);
+	gic_dist_init(0, __io_address(REALVIEW_TC11MP_GIC_DIST_BASE),
+		 29, IRQ_TYPE_LEVEL_LOW);
 	gic_cpu_init(0, gic_cpu_base_addr);
 
 	/* board GIC, secondary */
-	gic_dist_init(1, __io_address(REALVIEW_PB11MP_GIC_DIST_BASE), IRQ_PB11MP_GIC_START);
+	gic_dist_init(1, __io_address(REALVIEW_PB11MP_GIC_DIST_BASE),
+		IRQ_PB11MP_GIC_START, IRQ_TYPE_LEVEL_LOW);
 	gic_cpu_init(1, __io_address(REALVIEW_PB11MP_GIC_CPU_BASE));
 	gic_cascade_irq(1, IRQ_TC11MP_PB_IRQ1);
 }
diff --git a/arch/arm/mach-realview/realview_pba8.c b/arch/arm/mach-realview/realview_pba8.c
index fe4e25c..efdebcf 100644
--- a/arch/arm/mach-realview/realview_pba8.c
+++ b/arch/arm/mach-realview/realview_pba8.c
@@ -26,6 +26,7 @@
 #include <linux/amba/pl061.h>
 #include <linux/amba/mmci.h>
 #include <linux/io.h>
+#include <linux/irq.h>
 
 #include <asm/irq.h>
 #include <asm/leds.h>
@@ -254,7 +255,8 @@ static void __init gic_init_irq(void)
 {
 	/* ARM PB-A8 on-board GIC */
 	gic_cpu_base_addr = __io_address(REALVIEW_PBA8_GIC_CPU_BASE);
-	gic_dist_init(0, __io_address(REALVIEW_PBA8_GIC_DIST_BASE), IRQ_PBA8_GIC_START);
+	gic_dist_init(0, __io_address(REALVIEW_PBA8_GIC_DIST_BASE),
+		IRQ_PBA8_GIC_START, IRQ_TYPE_LEVEL_LOW);
 	gic_cpu_init(0, __io_address(REALVIEW_PBA8_GIC_CPU_BASE));
 }
 
diff --git a/arch/arm/mach-realview/realview_pbx.c b/arch/arm/mach-realview/realview_pbx.c
index a21a4b3..f1aa686 100644
--- a/arch/arm/mach-realview/realview_pbx.c
+++ b/arch/arm/mach-realview/realview_pbx.c
@@ -25,6 +25,7 @@
 #include <linux/amba/pl061.h>
 #include <linux/amba/mmci.h>
 #include <linux/io.h>
+#include <linux/irq.h>
 
 #include <asm/irq.h>
 #include <asm/leds.h>
@@ -276,12 +277,12 @@ static void __init gic_init_irq(void)
 	if (core_tile_pbx11mp() || core_tile_pbxa9mp()) {
 		gic_cpu_base_addr = __io_address(REALVIEW_PBX_TILE_GIC_CPU_BASE);
 		gic_dist_init(0, __io_address(REALVIEW_PBX_TILE_GIC_DIST_BASE),
-			      29);
+			      29, IRQ_TYPE_LEVEL_LOW);
 		gic_cpu_init(0, __io_address(REALVIEW_PBX_TILE_GIC_CPU_BASE));
 	} else {
 		gic_cpu_base_addr = __io_address(REALVIEW_PBX_GIC_CPU_BASE);
 		gic_dist_init(0, __io_address(REALVIEW_PBX_GIC_DIST_BASE),
-			      IRQ_PBX_GIC_START);
+			      IRQ_PBX_GIC_START, IRQ_TYPE_LEVEL_LOW);
 		gic_cpu_init(0, __io_address(REALVIEW_PBX_GIC_CPU_BASE));
 	}
 }
diff --git a/arch/arm/mach-ux500/cpu-u8500.c b/arch/arm/mach-ux500/cpu-u8500.c
index 5f05e58..68028fe 100644
--- a/arch/arm/mach-ux500/cpu-u8500.c
+++ b/arch/arm/mach-ux500/cpu-u8500.c
@@ -48,7 +48,7 @@ void __init u8500_map_io(void)
 
 void __init u8500_init_irq(void)
 {
-	gic_dist_init(0, __io_address(U8500_GIC_DIST_BASE), 29);
+	gic_dist_init(0, __io_address(U8500_GIC_DIST_BASE), 29, IRQ_TYPE_LEVEL_LOW);
 	gic_cpu_init(0, __io_address(U8500_GIC_CPU_BASE));
 }
 
-- 
1.5.6.3

