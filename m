Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368Ab0BCFQ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 00:16:57 -0500
Received: from adelie.canonical.com ([91.189.90.139]:34041 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099Ab0BCFQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 00:16:54 -0500
From: Amit Kucheria <amit.kucheria@canonical.com>
To: List Linux Kernel <linux-kernel@vger.kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
       s.hauer@pengutronix.de, valentin.longchamp@epfl.ch, daniel@caiaq.de,
       grant.likely@secretlab.ca, Dinh.Nguyen@freescale.com,
       r.herring@freescale.com, bryan.wu@canonical.com
Subject: [PATCHv2 04/11] mxc: changes to common plat-mxc code to add support for i.MX5
Date: Tue,  2 Feb 2010 21:16:26 -0800
Message-Id: <ec63e5978fd5ac5d308ede5916e648ba925818eb.1265173480.git.amit.kucheria@canonical.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <ccc89dd7a6035abf5a78680404a2b30b9e025353.1265173480.git.amit.kucheria@canonical.com>
References: <cover.1265173246.git.amit.kucheria@verdurent.com>
 <0511204199ab83aed2340e70a4639500c0528dab.1265173480.git.amit.kucheria@canonical.com>
 <9fa7a3c70c46a1f776c6520051481cff6525ef02.1265173480.git.amit.kucheria@canonical.com>
 <ccc89dd7a6035abf5a78680404a2b30b9e025353.1265173480.git.amit.kucheria@canonical.com>
In-Reply-To: <cover.1265173480.git.amit.kucheria@canonical.com>
References: <cover.1265173480.git.amit.kucheria@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes separted to help in the review process

Signed-off-by: Amit Kucheria <amit.kucheria@canonical.com>
---
 arch/arm/plat-mxc/include/mach/common.h      |    4 +++
 arch/arm/plat-mxc/include/mach/debug-macro.S |    9 +++++++
 arch/arm/plat-mxc/include/mach/entry-macro.S |   34 +++++++++++++++++++++++++-
 arch/arm/plat-mxc/include/mach/hardware.h    |    4 +++
 arch/arm/plat-mxc/include/mach/irqs.h        |    9 ++++++-
 arch/arm/plat-mxc/include/mach/memory.h      |    3 ++
 arch/arm/plat-mxc/include/mach/mxc.h         |   13 ++++++++++
 arch/arm/plat-mxc/include/mach/timex.h       |    2 +
 arch/arm/plat-mxc/time.c                     |    6 ++--
 9 files changed, 79 insertions(+), 5 deletions(-)

diff --git a/arch/arm/plat-mxc/include/mach/common.h b/arch/arm/plat-mxc/include/mach/common.h
index 286cb9b..5250a3f 100644
--- a/arch/arm/plat-mxc/include/mach/common.h
+++ b/arch/arm/plat-mxc/include/mach/common.h
@@ -20,8 +20,10 @@ extern void mx25_map_io(void);
 extern void mx27_map_io(void);
 extern void mx31_map_io(void);
 extern void mx35_map_io(void);
+extern void mx51_map_io(void);
 extern void mxc91231_map_io(void);
 extern void mxc_init_irq(void __iomem *);
+extern void tzic_init_irq(void __iomem *);
 extern void mx1_init_irq(void);
 extern void mx21_init_irq(void);
 extern void mx25_init_irq(void);
@@ -36,6 +38,8 @@ extern int mx25_clocks_init(unsigned long fref);
 extern int mx27_clocks_init(unsigned long fref);
 extern int mx31_clocks_init(unsigned long fref);
 extern int mx35_clocks_init(void);
+extern int mx51_clocks_init(unsigned long ckil, unsigned long osc,
+			unsigned long ckih1, unsigned long ckih2);
 extern int mxc91231_clocks_init(unsigned long fref);
 extern int mxc_register_gpios(void);
 extern int mxc_register_device(struct platform_device *pdev, void *data);
diff --git a/arch/arm/plat-mxc/include/mach/debug-macro.S b/arch/arm/plat-mxc/include/mach/debug-macro.S
index 15b2b14..9fe7300 100644
--- a/arch/arm/plat-mxc/include/mach/debug-macro.S
+++ b/arch/arm/plat-mxc/include/mach/debug-macro.S
@@ -44,6 +44,15 @@
 #define UART_VADDR	AIPS1_IO_ADDRESS(UART1_BASE_ADDR)
 #endif
 
+#ifdef CONFIG_ARCH_MX5
+#ifdef UART_PADDR
+#error "CONFIG_DEBUG_LL is incompatible with multiple archs"
+#endif
+#include <mach/mx51.h>
+#define UART_PADDR	UART1_BASE_ADDR
+#define UART_VADDR	AIPS1_IO_ADDRESS(UART1_BASE_ADDR)
+#endif
+
 #ifdef CONFIG_ARCH_MXC91231
 #ifdef UART_PADDR
 #error "CONFIG_DEBUG_LL is incompatible with multiple archs"
diff --git a/arch/arm/plat-mxc/include/mach/entry-macro.S b/arch/arm/plat-mxc/include/mach/entry-macro.S
index 7cf290e..aeb0869 100644
--- a/arch/arm/plat-mxc/include/mach/entry-macro.S
+++ b/arch/arm/plat-mxc/include/mach/entry-macro.S
@@ -1,6 +1,6 @@
 /*
  *  Copyright (C) 2007 Lennert Buytenhek <buytenh@wantstofly.org>
- *  Copyright 2004-2007 Freescale Semiconductor, Inc. All Rights Reserved.
+ *  Copyright 2004-2009 Freescale Semiconductor, Inc. All Rights Reserved.
  */
 
 /*
@@ -18,11 +18,16 @@
 	.endm
 
 	.macro  get_irqnr_preamble, base, tmp
+#ifndef CONFIG_MXC_TZIC
 	ldr	\base, =avic_base
 	ldr	\base, [\base]
 #ifdef CONFIG_MXC_IRQ_PRIOR
 	ldr	r4, [\base, #AVIC_NIMASK]
 #endif
+#elif defined CONFIG_MXC_TZIC
+	ldr	\base, =tzic_base
+	ldr	\base, [\base]
+#endif /* CONFIG_MXC_TZIC */
 	.endm
 
 	.macro  arch_ret_to_user, tmp1, tmp2
@@ -32,6 +37,7 @@
 	@ and returns its number in irqnr
 	@ and returns if an interrupt occured in irqstat
 	.macro	get_irqnr_and_base, irqnr, irqstat, base, tmp
+#ifndef CONFIG_MXC_TZIC
 	@ Load offset & priority of the highest priority
 	@ interrupt pending from AVIC_NIVECSR
 	ldr	\irqstat, [\base, #0x40]
@@ -45,6 +51,32 @@
 	strne	\tmp, [\base, #AVIC_NIMASK]
 	streq	r4, [\base, #AVIC_NIMASK]
 #endif
+#elif defined CONFIG_MXC_TZIC
+	@ Load offset & priority of the highest priority
+	@ interrupt pending.
+	@ 0xD80 is HIPND0 register
+	mov     \irqnr, #0
+	mov     \irqstat, #0x0D80
+1000:
+	ldr     \tmp,   [\irqstat, \base]
+	cmp     \tmp, #0
+	bne     1001f
+	addeq   \irqnr, \irqnr, #32
+	addeq   \irqstat, \irqstat, #4
+	cmp     \irqnr, #128
+	blo     1000b
+	b       2001f
+1001:	mov     \irqstat, #1
+1002:	tst     \tmp, \irqstat
+	bne     2002f
+	movs    \tmp, \tmp, lsr #1
+	addne   \irqnr, \irqnr, #1
+	bne     1002b
+2001:
+	mov  \irqnr, #0
+2002:
+	movs \irqnr, \irqnr
+#endif
 	.endm
 
 	@ irq priority table (not used)
diff --git a/arch/arm/plat-mxc/include/mach/hardware.h b/arch/arm/plat-mxc/include/mach/hardware.h
index 78db754..55ebe88 100644
--- a/arch/arm/plat-mxc/include/mach/hardware.h
+++ b/arch/arm/plat-mxc/include/mach/hardware.h
@@ -22,6 +22,10 @@
 
 #include <asm/sizes.h>
 
+#ifdef CONFIG_ARCH_MX5
+#include <mach/mx51.h>
+#endif
+
 #ifdef CONFIG_ARCH_MX3
 #include <mach/mx3x.h>
 #include <mach/mx31.h>
diff --git a/arch/arm/plat-mxc/include/mach/irqs.h b/arch/arm/plat-mxc/include/mach/irqs.h
index ead9d59..24c066e 100644
--- a/arch/arm/plat-mxc/include/mach/irqs.h
+++ b/arch/arm/plat-mxc/include/mach/irqs.h
@@ -12,9 +12,13 @@
 #define __ASM_ARCH_MXC_IRQS_H__
 
 /*
- * So far all i.MX SoCs have 64 internal interrupts
+ * SoCs with TZIC interrupt controller have 128 IRQs, those with AVIC have 64
  */
+#ifdef CONFIG_MXC_TZIC
+#define MXC_INTERNAL_IRQS	128
+#else
 #define MXC_INTERNAL_IRQS	64
+#endif
 
 #define MXC_GPIO_IRQ_START	MXC_INTERNAL_IRQS
 
@@ -26,6 +30,8 @@
 #define MXC_GPIO_IRQS		(32 * 3)
 #elif defined CONFIG_ARCH_MX25
 #define MXC_GPIO_IRQS		(32 * 4)
+#elif defined CONFIG_ARCH_MX5
+#define MXC_GPIO_IRQS		(32 * 4)
 #elif defined CONFIG_ARCH_MXC91231
 #define MXC_GPIO_IRQS		(32 * 4)
 #endif
@@ -46,6 +52,7 @@
 #else
 #define MX3_IPU_IRQS 0
 #endif
+/* REVISIT: Add IPU irqs on IMX51 */
 
 #define NR_IRQS			(MXC_IPU_IRQ_START + MX3_IPU_IRQS)
 
diff --git a/arch/arm/plat-mxc/include/mach/memory.h b/arch/arm/plat-mxc/include/mach/memory.h
index d3afafd..e46626e 100644
--- a/arch/arm/plat-mxc/include/mach/memory.h
+++ b/arch/arm/plat-mxc/include/mach/memory.h
@@ -27,6 +27,9 @@
 #elif defined CONFIG_ARCH_MXC91231
 #define PHYS_OFFSET		UL(0x90000000)
 #endif
+#ifdef CONFIG_ARCH_MX5
+#define PHYS_OFFSET             UL(0x90000000)
+#endif
 
 #if defined(CONFIG_MX1_VIDEO)
 /*
diff --git a/arch/arm/plat-mxc/include/mach/mxc.h b/arch/arm/plat-mxc/include/mach/mxc.h
index 5199053..555e5f8 100644
--- a/arch/arm/plat-mxc/include/mach/mxc.h
+++ b/arch/arm/plat-mxc/include/mach/mxc.h
@@ -30,6 +30,7 @@
 #define MXC_CPU_MX27		27
 #define MXC_CPU_MX31		31
 #define MXC_CPU_MX35		35
+#define MXC_CPU_MX51		51
 #define MXC_CPU_MXC91231	91231
 
 #ifndef __ASSEMBLY__
@@ -108,6 +109,18 @@ extern unsigned int __mxc_cpu_type;
 # define cpu_is_mx35()		(0)
 #endif
 
+#ifdef CONFIG_ARCH_MX5
+# ifdef mxc_cpu_type
+#  undef mxc_cpu_type
+#  define mxc_cpu_type __mxc_cpu_type
+# else
+#  define mxc_cpu_type MXC_CPU_MX51
+# endif
+# define cpu_is_mx51()		(mxc_cpu_type == MXC_CPU_MX51)
+#else
+# define cpu_is_mx51()		(0)
+#endif
+
 #ifdef CONFIG_ARCH_MXC91231
 # ifdef mxc_cpu_type
 #  undef mxc_cpu_type
diff --git a/arch/arm/plat-mxc/include/mach/timex.h b/arch/arm/plat-mxc/include/mach/timex.h
index 527a6c2..024416e 100644
--- a/arch/arm/plat-mxc/include/mach/timex.h
+++ b/arch/arm/plat-mxc/include/mach/timex.h
@@ -28,6 +28,8 @@
 #define CLOCK_TICK_RATE		16625000
 #elif defined CONFIG_ARCH_MX25
 #define CLOCK_TICK_RATE		16000000
+#elif defined CONFIG_ARCH_MX5
+#define CLOCK_TICK_RATE		8000000
 #elif defined CONFIG_ARCH_MXC91231
 #define CLOCK_TICK_RATE		13000000
 #endif
diff --git a/arch/arm/plat-mxc/time.c b/arch/arm/plat-mxc/time.c
index 7d6499e..2ba8b29 100644
--- a/arch/arm/plat-mxc/time.c
+++ b/arch/arm/plat-mxc/time.c
@@ -32,7 +32,7 @@
 
 /* defines common for all i.MX */
 #define MXC_TCTL		0x00
-#define MXC_TCTL_TEN		(1 << 0)
+#define MXC_TCTL_TEN		(1 << 0) /* Enable module */
 #define MXC_TPRER		0x04
 
 /* MX1, MX21, MX27 */
@@ -48,7 +48,7 @@
 #define MX2_TSTAT_COMP		(1 << 0)
 
 /* MX31, MX35, MX25, MXC91231 */
-#define MX3_TCTL_WAITEN		(1 << 3)
+#define MX3_TCTL_WAITEN		(1 << 3) /* Wait enable mode */
 #define MX3_TCTL_CLK_IPG	(1 << 6)
 #define MX3_TCTL_FRR		(1 << 9)
 #define MX3_IR			0x0c
@@ -58,7 +58,7 @@
 #define MX3_TCMP		0x10
 
 #define timer_is_v1()	(cpu_is_mx1() || cpu_is_mx27())
-#define timer_is_v2()	(cpu_is_mx3() || cpu_is_mx25())
+#define timer_is_v2()	(cpu_is_mx3() || cpu_is_mx25() || cpu_is_mx51())
 
 static struct clock_event_device clockevent_mxc;
 static enum clock_event_mode clockevent_mode = CLOCK_EVT_MODE_UNUSED;
-- 
1.6.3.3

