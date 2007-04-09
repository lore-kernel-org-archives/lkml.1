Return-Path: <linux-kernel-owner+w=401wt.eu-S932078AbXDIVkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078AbXDIVkf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:40:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932074AbXDIVkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:40:18 -0400
Received: from nlpi015.sbcis.sbc.com ([207.115.36.44]:33940 "EHLO
	nlpi015.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966031AbXDIVcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:32:33 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Kai Svahn <kai.svahn@nokia.com>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 15/18] ARM: OMAP: Merge PM code from N800 tree
Date: Mon,  9 Apr 2007 17:30:58 -0400
Message-Id: <11761543144181-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <1176154311389-git-send-email-tony@atomide.com>
References: <1176154261668-git-send-email-tony@atomide.com> <11761542642563-git-send-email-tony@atomide.com> <11761542683139-git-send-email-tony@atomide.com> <11761542712251-git-send-email-tony@atomide.com> <11761542731458-git-send-email-tony@atomide.com> <1176154277435-git-send-email-tony@atomide.com> <11761542841909-git-send-email-tony@atomide.com> <1176154286590-git-send-email-tony@atomide.com> <11761542912185-git-send-email-tony@atomide.com> <1176154294883-git-send-email-tony@atomide.com> <11761542981742-git-send-email-tony@atomide.com> <1176154302614-git-send-email-tony@atomide.com> <11761543041751-git-send-email-tony@atomide.com> <1176154308509-git-send-email-tony@atomide.com> <1176154311389-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kai Svahn <kai.svahn@nokia.com>

This patch merges omap2 PM code from N800 tree.

Patch adds support for sleep while idle for omap2
and handy serial console debbugging code. It also
moves code from pm-domain.c to pm.c.

This code can be used as a base for developing
power management for all omap24xx boards.

Signed-off-by: Kai Svahn <kai.svahn@nokia.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>

Index: linux-2.6/arch/arm/mach-omap2/Makefile
===================================================================
--- linux-2.6.orig/arch/arm/mach-omap2/Makefile	2007-04-09 14:52:28.000000000 -0400
+++ linux-2.6/arch/arm/mach-omap2/Makefile	2007-04-09 15:17:39.000000000 -0400
@@ -9,7 +9,7 @@ obj-y := irq.o id.o io.o sram-fn.o memor
 obj-$(CONFIG_OMAP_MPU_TIMER)		+= timer-gp.o
 
 # Power Management
-obj-$(CONFIG_PM) += pm.o pm-domain.o sleep.o
+obj-$(CONFIG_PM) += pm.o sleep.o
 
 # Specific board support
 obj-$(CONFIG_MACH_OMAP_GENERIC)		+= board-generic.o
Index: linux-2.6/arch/arm/mach-omap2/pm-domain.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-omap2/pm-domain.c	2007-04-05 15:33:53.000000000 -0400
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,299 +0,0 @@
-/*
- * linux/arch/arm/mach-omap2/pm-domain.c
- *
- * Power domain functions for OMAP2
- *
- * Copyright (C) 2006 Nokia Corporation
- * Tony Lindgren <tony@atomide.com>
- *
- * Some code based on earlier OMAP2 sample PM code
- * Copyright (C) 2005 Texas Instruments, Inc.
- * Richard Woodruff <r-woodruff2@ti.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/clk.h>
-
-#include <asm/io.h>
-
-#include "prcm-regs.h"
-
-/* Power domain offsets */
-#define PM_MPU_OFFSET			0x100
-#define PM_CORE_OFFSET			0x200
-#define PM_GFX_OFFSET			0x300
-#define PM_WKUP_OFFSET			0x400		/* Autoidle only */
-#define PM_PLL_OFFSET			0x500		/* Autoidle only */
-#define PM_DSP_OFFSET			0x800
-#define PM_MDM_OFFSET			0xc00
-
-/* Power domain wake-up dependency control register */
-#define PM_WKDEP_OFFSET			0xc8
-#define		EN_MDM			(1 << 5)
-#define		EN_WKUP			(1 << 4)
-#define		EN_GFX			(1 << 3)
-#define		EN_DSP			(1 << 2)
-#define		EN_MPU			(1 << 1)
-#define		EN_CORE			(1 << 0)
-
-/* Core power domain state transition control register */
-#define PM_PWSTCTRL_OFFSET		0xe0
-#define		FORCESTATE		(1 << 18)	/* Only for DSP & GFX */
-#define		MEM4RETSTATE		(1 << 6)
-#define		MEM3RETSTATE		(1 << 5)
-#define		MEM2RETSTATE		(1 << 4)
-#define		MEM1RETSTATE		(1 << 3)
-#define		LOGICRETSTATE		(1 << 2)	/* Logic is retained */
-#define		POWERSTATE_OFF		0x3
-#define		POWERSTATE_RETENTION	0x1
-#define		POWERSTATE_ON		0x0
-
-/* Power domain state register */
-#define PM_PWSTST_OFFSET		0xe4
-
-/* Hardware supervised state transition control register */
-#define CM_CLKSTCTRL_OFFSET		0x48
-#define		AUTOSTAT_MPU		(1 << 0)	/* MPU */
-#define		AUTOSTAT_DSS		(1 << 2)	/* Core */
-#define		AUTOSTAT_L4		(1 << 1)	/* Core */
-#define		AUTOSTAT_L3		(1 << 0)	/* Core */
-#define		AUTOSTAT_GFX		(1 << 0)	/* GFX */
-#define		AUTOSTAT_IVA		(1 << 8)	/* 2420 IVA in DSP domain */
-#define		AUTOSTAT_DSP		(1 << 0)	/* DSP */
-#define		AUTOSTAT_MDM		(1 << 0)	/* MDM */
-
-/* Automatic control of interface clock idling */
-#define CM_AUTOIDLE1_OFFSET		0x30
-#define CM_AUTOIDLE2_OFFSET		0x34		/* Core only */
-#define CM_AUTOIDLE3_OFFSET		0x38		/* Core only */
-#define CM_AUTOIDLE4_OFFSET		0x3c		/* Core only */
-#define		AUTO_54M(x)		(((x) & 0x3) << 6)
-#define		AUTO_96M(x)		(((x) & 0x3) << 2)
-#define		AUTO_DPLL(x)		(((x) & 0x3) << 0)
-#define		AUTO_STOPPED		0x3
-#define		AUTO_BYPASS_FAST	0x2		/* DPLL only */
-#define		AUTO_BYPASS_LOW_POWER	0x1		/* DPLL only */
-#define		AUTO_DISABLED		0x0
-
-/* Voltage control PRCM_VOLTCTRL bits */
-#define		AUTO_EXTVOLT		(1 << 15)
-#define		FORCE_EXTVOLT		(1 << 14)
-#define		SETOFF_LEVEL(x)		(((x) & 0x3) << 12)
-#define		MEMRETCTRL		(1 << 8)
-#define		SETRET_LEVEL(x)		(((x) & 0x3) << 6)
-#define		VOLT_LEVEL(x)		(((x) & 0x3) << 0)
-
-#define OMAP24XX_PRCM_VBASE	IO_ADDRESS(OMAP24XX_PRCM_BASE)
-#define prcm_readl(r)		__raw_readl(OMAP24XX_PRCM_VBASE + (r))
-#define prcm_writel(v, r)	__raw_writel((v), OMAP24XX_PRCM_VBASE + (r))
-
-static u32 pmdomain_get_wakeup_dependencies(int domain_offset)
-{
-	return prcm_readl(domain_offset + PM_WKDEP_OFFSET);
-}
-
-static void pmdomain_set_wakeup_dependencies(u32 state, int domain_offset)
-{
-	prcm_writel(state, domain_offset + PM_WKDEP_OFFSET);
-}
-
-static u32 pmdomain_get_powerstate(int domain_offset)
-{
-	return prcm_readl(domain_offset + PM_PWSTCTRL_OFFSET);
-}
-
-static void pmdomain_set_powerstate(u32 state, int domain_offset)
-{
-	prcm_writel(state, domain_offset + PM_PWSTCTRL_OFFSET);
-}
-
-static u32 pmdomain_get_clock_autocontrol(int domain_offset)
-{
-	return prcm_readl(domain_offset + CM_CLKSTCTRL_OFFSET);
-}
-
-static void pmdomain_set_clock_autocontrol(u32 state, int domain_offset)
-{
-	prcm_writel(state, domain_offset + CM_CLKSTCTRL_OFFSET);
-}
-
-static u32 pmdomain_get_clock_autoidle1(int domain_offset)
-{
-	return prcm_readl(domain_offset + CM_AUTOIDLE1_OFFSET);
-}
-
-/* Core domain only */
-static u32 pmdomain_get_clock_autoidle2(int domain_offset)
-{
-	return prcm_readl(domain_offset + CM_AUTOIDLE2_OFFSET);
-}
-
-/* Core domain only */
-static u32 pmdomain_get_clock_autoidle3(int domain_offset)
-{
-	return prcm_readl(domain_offset + CM_AUTOIDLE3_OFFSET);
-}
-
-/* Core domain only */
-static u32 pmdomain_get_clock_autoidle4(int domain_offset)
-{
-	return prcm_readl(domain_offset + CM_AUTOIDLE4_OFFSET);
-}
-
-static void pmdomain_set_clock_autoidle1(u32 state, int domain_offset)
-{
-	prcm_writel(state, CM_AUTOIDLE1_OFFSET + domain_offset);
-}
-
-/* Core domain only */
-static void pmdomain_set_clock_autoidle2(u32 state, int domain_offset)
-{
-	prcm_writel(state, CM_AUTOIDLE2_OFFSET + domain_offset);
-}
-
-/* Core domain only */
-static void pmdomain_set_clock_autoidle3(u32 state, int domain_offset)
-{
-	prcm_writel(state, CM_AUTOIDLE3_OFFSET + domain_offset);
-}
-
-/* Core domain only */
-static void pmdomain_set_clock_autoidle4(u32 state, int domain_offset)
-{
-	prcm_writel(state, CM_AUTOIDLE4_OFFSET + domain_offset);
-}
-
-/*
- * Configures power management domains to idle clocks automatically.
- */
-void pmdomain_set_autoidle(void)
-{
-	u32 val;
-
-	/* Set PLL auto stop for 54M, 96M & DPLL */
-	pmdomain_set_clock_autoidle1(AUTO_54M(AUTO_STOPPED) |
-				     AUTO_96M(AUTO_STOPPED) |
-				     AUTO_DPLL(AUTO_STOPPED), PM_PLL_OFFSET);
-
-	/* External clock input control
-	 * REVISIT: Should this be in clock framework?
-	 */
-	PRCM_CLKSRC_CTRL |= (0x3 << 3);
-
-	/* Configure number of 32KHz clock cycles for sys_clk */
-	PRCM_CLKSSETUP = 0x00ff;
-
-	/* Configure automatic voltage transition */
-	PRCM_VOLTSETUP = 0;
-	val = PRCM_VOLTCTRL;
-	val &= ~(SETOFF_LEVEL(0x3) | VOLT_LEVEL(0x3));
-	val |= SETOFF_LEVEL(1) | VOLT_LEVEL(1) | AUTO_EXTVOLT;
-	PRCM_VOLTCTRL = val;
-
-	/* Disable emulation tools functional clock */
-	PRCM_CLKEMUL_CTRL = 0x0;
-
-	/* Set core memory retention state */
-	val = pmdomain_get_powerstate(PM_CORE_OFFSET);
-	if (cpu_is_omap2420()) {
-		val &= ~(0x7 << 3);
-		val |= (MEM3RETSTATE | MEM2RETSTATE | MEM1RETSTATE);
-	} else {
-		val &= ~(0xf << 3);
-		val |= (MEM4RETSTATE | MEM3RETSTATE | MEM2RETSTATE |
-			MEM1RETSTATE);
-	}
-	pmdomain_set_powerstate(val, PM_CORE_OFFSET);
-
-	/* OCP interface smart idle. REVISIT: Enable autoidle bit0 ? */
-	val = SMS_SYSCONFIG;
-	val &= ~(0x3 << 3);
-	val |= (0x2 << 3) | (1 << 0);
-	SMS_SYSCONFIG |= val;
-
-	val = SDRC_SYSCONFIG;
-	val &= ~(0x3 << 3);
-	val |= (0x2 << 3);
-	SDRC_SYSCONFIG = val;
-
-	/* Configure L3 interface for smart idle.
-	 * REVISIT: Enable autoidle bit0 ?
-	 */
-	val = GPMC_SYSCONFIG;
-	val &= ~(0x3 << 3);
-	val |= (0x2 << 3) | (1 << 0);
-	GPMC_SYSCONFIG = val;
-
-	pmdomain_set_powerstate(LOGICRETSTATE | POWERSTATE_RETENTION,
-				PM_MPU_OFFSET);
-	pmdomain_set_powerstate(POWERSTATE_RETENTION, PM_CORE_OFFSET);
-	if (!cpu_is_omap2420())
-		pmdomain_set_powerstate(POWERSTATE_RETENTION, PM_MDM_OFFSET);
-
-	/* Assume suspend function has saved the state for DSP and GFX */
-	pmdomain_set_powerstate(FORCESTATE | POWERSTATE_OFF, PM_DSP_OFFSET);
-	pmdomain_set_powerstate(FORCESTATE | POWERSTATE_OFF, PM_GFX_OFFSET);
-
-#if 0
-	/* REVISIT: Internal USB needs special handling */
-	force_standby_usb();
-	if (cpu_is_omap2430())
-		force_hsmmc();
-	sdram_self_refresh_on_idle_req(1);
-#endif
-
-	/* Enable clock auto control for all domains.
-	 * Note that CORE domain includes also DSS, L4 & L3.
-	 */
-	pmdomain_set_clock_autocontrol(AUTOSTAT_MPU, PM_MPU_OFFSET);
-	pmdomain_set_clock_autocontrol(AUTOSTAT_GFX, PM_GFX_OFFSET);
-	pmdomain_set_clock_autocontrol(AUTOSTAT_DSS | AUTOSTAT_L4 | AUTOSTAT_L3,
-				       PM_CORE_OFFSET);
-	if (cpu_is_omap2420())
-		pmdomain_set_clock_autocontrol(AUTOSTAT_IVA | AUTOSTAT_DSP,
-					       PM_DSP_OFFSET);
-	else {
-		pmdomain_set_clock_autocontrol(AUTOSTAT_DSP, PM_DSP_OFFSET);
-		pmdomain_set_clock_autocontrol(AUTOSTAT_MDM, PM_MDM_OFFSET);
-	}
-
-	/* Enable clock autoidle for all domains */
-	pmdomain_set_clock_autoidle1(0x2, PM_DSP_OFFSET);
-	if (cpu_is_omap2420()) {
-		pmdomain_set_clock_autoidle1(0xfffffff9, PM_CORE_OFFSET);
-		pmdomain_set_clock_autoidle2(0x7, PM_CORE_OFFSET);
-		pmdomain_set_clock_autoidle1(0x3f, PM_WKUP_OFFSET);
-	} else {
-		pmdomain_set_clock_autoidle1(0xeafffff1, PM_CORE_OFFSET);
-		pmdomain_set_clock_autoidle2(0xfff, PM_CORE_OFFSET);
-		pmdomain_set_clock_autoidle1(0x7f, PM_WKUP_OFFSET);
-		pmdomain_set_clock_autoidle1(0x3, PM_MDM_OFFSET);
-	}
-	pmdomain_set_clock_autoidle3(0x7, PM_CORE_OFFSET);
-	pmdomain_set_clock_autoidle4(0x1f, PM_CORE_OFFSET);
-}
-
-/*
- * Initializes power domains by removing wake-up dependencies and powering
- * down DSP and GFX. Gets called from PM init. Note that DSP and IVA code
- * must re-enable DSP and GFX when used.
- */
-void __init pmdomain_init(void)
-{
-	/* Remove all domain wakeup dependencies */
-	pmdomain_set_wakeup_dependencies(EN_WKUP | EN_CORE, PM_MPU_OFFSET);
-	pmdomain_set_wakeup_dependencies(0, PM_DSP_OFFSET);
-	pmdomain_set_wakeup_dependencies(0, PM_GFX_OFFSET);
-	pmdomain_set_wakeup_dependencies(EN_WKUP | EN_MPU, PM_CORE_OFFSET);
-	if (cpu_is_omap2430())
-		pmdomain_set_wakeup_dependencies(0, PM_MDM_OFFSET);
-
-	/* Power down DSP and GFX */
-	pmdomain_set_powerstate(POWERSTATE_OFF | FORCESTATE, PM_DSP_OFFSET);
-	pmdomain_set_powerstate(POWERSTATE_OFF | FORCESTATE, PM_GFX_OFFSET);
-}
Index: linux-2.6/arch/arm/mach-omap2/pm.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-omap2/pm.c	2007-04-05 15:33:53.000000000 -0400
+++ linux-2.6/arch/arm/mach-omap2/pm.c	2007-04-09 15:18:58.000000000 -0400
@@ -3,11 +3,15 @@
  *
  * OMAP2 Power Management Routines
  *
+ * Copyright (C) 2005 Texas Instruments, Inc.
  * Copyright (C) 2006 Nokia Corporation
- * Tony Lindgren <tony@atomide.com>
  *
- * Copyright (C) 2005 Texas Instruments, Inc.
+ * Written by:
  * Richard Woodruff <r-woodruff2@ti.com>
+ * Tony Lindgren
+ * Juha Yrjola
+ * Amit Kucheria <amit.kucheria@nokia.com>
+ * Igor Stoppa <igor.stoppa@nokia.com>
  *
  * Based on pm.c for omap1
  *
@@ -24,6 +28,7 @@
 #include <linux/sysfs.h>
 #include <linux/module.h>
 #include <linux/delay.h>
+#include <linux/clk.h>
 
 #include <asm/io.h>
 #include <asm/irq.h>
@@ -36,27 +41,610 @@
 #include <asm/arch/clock.h>
 #include <asm/arch/sram.h>
 #include <asm/arch/pm.h>
+#include <asm/arch/mux.h>
+#include <asm/arch/dma.h>
+#include <asm/arch/board.h>
+
+#define PRCM_BASE		0x48008000
+#define PRCM_REVISION		0x000
+#define PRCM_SYSCONFIG		0x010
+#define PRCM_IRQSTATUS_MPU	0x018
+#define PRCM_IRQENABLE_MPU	0x01c
+#define PRCM_VOLTCTRL		0x050
+#define		AUTO_EXTVOLT	(1 << 15)
+#define		FORCE_EXTVOLT	(1 << 14)
+#define		SETOFF_LEVEL(x)	(((x) & 0x3) << 12)
+#define		MEMRETCTRL	(1 << 8)
+#define		SETRET_LEVEL(x)	(((x) & 0x3) << 6)
+#define		VOLT_LEVEL(x)	(((x) & 0x3) << 0)
+#define PRCM_CLKSRC_CTRL	0x060
+#define PRCM_CLKOUT_CTRL	0x070
+#define PRCM_CLKEMUL_CTRL	0x078
+#define PRCM_CLKCFG_CTRL	0x080
+#define PRCM_VOLTSETUP		0x090
+#define PRCM_CLKSSETUP		0x094
+
+
+#define CM_CLKSEL_MPU		0x140
+#define CM_CLKSTCTRL_MPU	0x148
+#define		AUTOSTAT_MPU	(1 << 0)
+#define PM_WKDEP_MPU		0x1c8
+#define 	EN_WKUP		(1 << 4)
+#define 	EN_GFX		(1 << 3)
+#define 	EN_DSP		(1 << 2)
+#define 	EN_MPU		(1 << 1)
+#define 	EN_CORE		(1 << 0)
+#define PM_PWSTCTRL_MPU		0x1e0
+#define PM_PWSTST_MPU		0x1e4
+
+
+#define CM_FCLKEN1_CORE		0x200
+#define CM_FCLKEN2_CORE		0x204
+#define CM_ICLKEN1_CORE		0x210
+#define CM_ICLKEN2_CORE		0x214
+#define CM_ICLKEN4_CORE		0x21c
+#define CM_IDLEST1_CORE		0x220
+#define CM_IDLEST2_CORE		0x224
+#define CM_AUTOIDLE1_CORE	0x230
+#define CM_AUTOIDLE2_CORE	0x234
+#define CM_AUTOIDLE3_CORE	0x238
+#define CM_AUTOIDLE4_CORE	0x23c
+#define CM_CLKSEL1_CORE		0x240
+#define CM_CLKSEL2_CORE		0x244
+#define CM_CLKSTCTRL_CORE	0x248
+#define		AUTOSTAT_DSS	(1 << 2)
+#define		AUTOSTAT_L4	(1 << 1)
+#define		AUTOSTAT_L3	(1 << 0)
+#define PM_WKEN1_CORE		0x2a0
+#define PM_WKEN2_CORE		0x2a4
+#define PM_WKST1_CORE		0x2b0
+#define PM_WKST2_CORE		0x2b4
+#define PM_WKDEP_CORE		0x2c8
+#define PM_PWSTCTRL_CORE	0x2e0
+#define PM_PWSTST_CORE		0x2e4
+
+
+#define CM_CLKSTCTRL_GFX	0x348
+#define		AUTOSTAT_GFX	(1 << 0)
+#define PM_WKDEP_GFX    	0x3c8
+#define PM_PWSTCTRL_GFX		0x3e0
+
+
+#define CM_FCLKEN_WKUP		0x400
+#define CM_ICLKEN_WKUP		0x410
+#define CM_AUTOIDLE_WKUP	0x430
+#define PM_WKEN_WKUP		0x4a0
+#define 	EN_GPIOS	(1 << 2)
+#define 	EN_GPT1		(1 << 0)
+#define PM_WKST_WKUP		0x4b0
+
+
+#define CM_CLKEN_PLL		0x500
+#define CM_IDLEST_CKGEN		0x520
+#define CM_AUTOIDLE_PLL		0x530
+#define CM_CLKSEL1_PLL		0x540
+#define CM_CLKSEL2_PLL		0x544
+
+
+#define CM_FCLKEN_DSP		0x800
+#define CM_ICLKEN_DSP		0x810
+#define CM_IDLEST_DSP		0x820
+#define CM_AUTOIDLE_DSP		0x830
+#define CM_CLKSEL_DSP		0x840
+#define CM_CLKSTCTRL_DSP	0x848
+#define		AUTOSTAT_IVA	(1 << 8)
+#define		AUTOSTAT_DSP	(1 << 0)
+#define RM_RSTCTRL_DSP		0x850
+#define RM_RSTST_DSP		0x858
+#define PM_WKDEP_DSP		0x8c8
+#define PM_PWSTCTRL_DSP		0x8e0
+#define PM_PWSTST_DSP		0x8e4
 
-#include "prcm-regs.h"
-
-static struct clk *vclk;
 static void (*omap2_sram_idle)(void);
-static void (*omap2_sram_suspend)(int dllctrl, int cpu_rev);
+static void (*omap2_sram_suspend)(int dllctrl);
 static void (*saved_idle)(void);
 
-extern void __init pmdomain_init(void);
-extern void pmdomain_set_autoidle(void);
+static u32 prcm_base = IO_ADDRESS(PRCM_BASE);
+
+static inline void prcm_write_reg(int idx, u32 val)
+{
+	__raw_writel(val, prcm_base + idx);
+}
+
+static inline u32 prcm_read_reg(int idx)
+{
+	return __raw_readl(prcm_base + idx);
+}
+
+static u32 omap2_read_32k_sync_counter(void)
+{
+        return omap_readl(0x48004010);
+}
+
+#ifdef CONFIG_PM_DEBUG
+int omap2_pm_debug = 0;
+
+static int serial_console_clock_disabled;
+static int serial_console_uart;
+static unsigned int serial_console_next_disable;
+
+static struct clk *console_iclk, *console_fclk;
+
+static void serial_console_kick(void)
+{
+	serial_console_next_disable = omap2_read_32k_sync_counter();
+	/* Keep the clocks on for 4 secs */
+	serial_console_next_disable += 4 * 32768;
+}
+
+static void serial_wait_tx(void)
+{
+	static const unsigned long uart_bases[3] = {
+		0x4806a000, 0x4806c000, 0x4806e000
+	};
+	unsigned long lsr_reg;
+	int looped = 0;
+
+	/* Wait for TX FIFO and THR to get empty */
+	lsr_reg = IO_ADDRESS(uart_bases[serial_console_uart - 1] + (5 << 2));
+	while ((__raw_readb(lsr_reg) & 0x60) != 0x60)
+		looped = 1;
+	if (looped)
+		serial_console_kick();
+}
+
+static void serial_console_fclk_mask(u32 *f1, u32 *f2)
+{
+	switch (serial_console_uart)  {
+	case 1:
+		*f1 &= ~(1 << 21);
+		break;
+	case 2:
+		*f1 &= ~(1 << 22);
+		break;
+	case 3:
+		*f2 &= ~(1 << 2);
+		break;
+	}
+}
+
+static void serial_console_sleep(int enable)
+{
+	if (console_iclk == NULL || console_fclk == NULL)
+		return;
+
+	if (enable) {
+		BUG_ON(serial_console_clock_disabled);
+		if (clk_get_usecount(console_fclk) == 0)
+			return;
+		if ((int) serial_console_next_disable - (int) omap2_read_32k_sync_counter() >= 0)
+			return;
+		serial_wait_tx();
+		clk_disable(console_iclk);
+		clk_disable(console_fclk);
+		serial_console_clock_disabled = 1;
+	} else {
+		int serial_wakeup = 0;
+		u32 l;
+
+		switch (serial_console_uart)  {
+		case 1:
+			l = prcm_read_reg(PM_WKST1_CORE);
+			if (l & (1 << 21))
+				serial_wakeup = 1;
+			break;
+		case 2:
+			l = prcm_read_reg(PM_WKST1_CORE);
+			if (l & (1 << 22))
+				serial_wakeup = 1;
+			break;
+		case 3:
+			l = prcm_read_reg(PM_WKST2_CORE);
+			if (l & (1 << 2))
+				serial_wakeup = 1;
+			break;
+		}
+		if (serial_wakeup)
+			serial_console_kick();
+		if (!serial_console_clock_disabled)
+			return;
+		clk_enable(console_iclk);
+		clk_enable(console_fclk);
+		serial_console_clock_disabled = 0;
+	}
+}
+
+static void pm_init_serial_console(void)
+{
+	const struct omap_serial_console_config *conf;
+	char name[16];
+	u32 l;
+
+	conf = omap_get_config(OMAP_TAG_SERIAL_CONSOLE,
+			       struct omap_serial_console_config);
+	if (conf == NULL)
+		return;
+	if (conf->console_uart > 3 || conf->console_uart < 1)
+		return;
+	serial_console_uart = conf->console_uart;
+	sprintf(name, "uart%d_fck", conf->console_uart);
+	console_fclk = clk_get(NULL, name);
+	if (IS_ERR(console_fclk))
+		console_fclk = NULL;
+	name[6] = 'i';
+	console_iclk = clk_get(NULL, name);
+	if (IS_ERR(console_fclk))
+		console_iclk = NULL;
+	if (console_fclk == NULL || console_iclk == NULL) {
+		serial_console_uart = 0;
+		return;
+	}
+	switch (serial_console_uart) {
+	case 1:
+		l = prcm_read_reg(PM_WKEN1_CORE);
+		l |= 1 << 21;
+		prcm_write_reg(PM_WKEN1_CORE, l);
+		break;
+	case 2:
+		l = prcm_read_reg(PM_WKEN1_CORE);
+		l |= 1 << 22;
+		prcm_write_reg(PM_WKEN1_CORE, l);
+		break;
+	case 3:
+		l = prcm_read_reg(PM_WKEN2_CORE);
+		l |= 1 << 2;
+		prcm_write_reg(PM_WKEN2_CORE, l);
+		break;
+	}
+}
+
+#define DUMP_REG(reg) \
+	regs[reg_count].name = #reg; \
+	regs[reg_count++].val = prcm_read_reg(reg)
+#define DUMP_INTC_REG(reg, off) \
+	regs[reg_count].name = #reg; \
+	regs[reg_count++].val = __raw_readl(IO_ADDRESS(0x480fe000 + (off)))
+
+static void omap2_pm_dump(int mode, int resume, unsigned int us)
+{
+	struct reg {
+		const char *name;
+		u32 val;
+	} regs[32];
+	int reg_count = 0, i;
+	const char *s1 = NULL, *s2 = NULL;
+
+	if (!resume) {
+#if 0
+		/* MPU */
+		DUMP_REG(PRCM_IRQENABLE_MPU);
+		DUMP_REG(CM_CLKSTCTRL_MPU);
+		DUMP_REG(PM_PWSTCTRL_MPU);
+		DUMP_REG(PM_PWSTST_MPU);
+		DUMP_REG(PM_WKDEP_MPU);
+#endif
+#if 0
+		/* INTC */
+		DUMP_INTC_REG(INTC_MIR0, 0x0084);
+		DUMP_INTC_REG(INTC_MIR1, 0x00a4);
+		DUMP_INTC_REG(INTC_MIR2, 0x00c4);
+#endif
+#if 0
+		DUMP_REG(CM_FCLKEN1_CORE);
+		DUMP_REG(CM_FCLKEN2_CORE);
+		DUMP_REG(CM_FCLKEN_WKUP);
+		DUMP_REG(CM_ICLKEN1_CORE);
+		DUMP_REG(CM_ICLKEN2_CORE);
+		DUMP_REG(CM_ICLKEN_WKUP);
+		DUMP_REG(CM_CLKEN_PLL);
+		DUMP_REG(PRCM_CLKEMUL_CTRL);
+		DUMP_REG(CM_AUTOIDLE_PLL);
+		DUMP_REG(PM_PWSTST_CORE);
+		DUMP_REG(PRCM_CLKSRC_CTRL);
+#endif
+#if 0
+		/* DSP */
+		DUMP_REG(CM_FCLKEN_DSP);
+		DUMP_REG(CM_ICLKEN_DSP);
+		DUMP_REG(CM_IDLEST_DSP);
+		DUMP_REG(CM_AUTOIDLE_DSP);
+		DUMP_REG(CM_CLKSEL_DSP);
+		DUMP_REG(CM_CLKSTCTRL_DSP);
+		DUMP_REG(RM_RSTCTRL_DSP);
+		DUMP_REG(RM_RSTST_DSP);
+		DUMP_REG(PM_PWSTCTRL_DSP);
+		DUMP_REG(PM_PWSTST_DSP);
+#endif
+	} else {
+		DUMP_REG(PM_WKST1_CORE);
+		DUMP_REG(PM_WKST2_CORE);
+		DUMP_REG(PM_WKST_WKUP);
+		DUMP_REG(PRCM_IRQSTATUS_MPU);
+#if 1
+		DUMP_INTC_REG(INTC_PENDING_IRQ0, 0x0098);
+		DUMP_INTC_REG(INTC_PENDING_IRQ1, 0x00b8);
+		DUMP_INTC_REG(INTC_PENDING_IRQ2, 0x00d8);
+#endif
+	}
+
+	switch (mode) {
+	case 0:
+		s1 = "full";
+		s2 = "retention";
+		break;
+	case 1:
+		s1 = "MPU";
+		s2 = "retention";
+		break;
+	case 2:
+		s1 = "MPU";
+		s2 = "idle";
+		break;
+	}
+
+	if (!resume)
+#if defined(CONFIG_NO_IDLE_HZ) || defined(CONFIG_NO_HZ)
+		printk("--- Going to %s %s (next timer after %u ms)\n", s1, s2,
+		       jiffies_to_msecs(next_timer_interrupt() - jiffies));
+#else
+		printk("--- Going to %s %s\n", s1, s2);
+#endif
+	else
+		printk("--- Woke up (slept for %u.%03u ms)\n", us / 1000, us % 1000);
+	for (i = 0; i < reg_count; i++)
+		printk("%-20s: 0x%08x\n", regs[i].name, regs[i].val);
+}
+
+#else
+static inline void serial_console_sleep(int enable) {}
+static inline void pm_init_serial_console(void) {}
+static inline void omap2_pm_dump(int mode, int resume, unsigned int us) {}
+static inline void serial_console_fclk_mask(u32 *f1, u32 *f2) {}
+
+#define omap2_pm_debug 0
+
+#endif
+
+static unsigned short enable_dyn_sleep = 0; /* disabled till drivers are fixed */
+
+static ssize_t omap_pm_sleep_while_idle_show(struct subsystem * subsys, char *buf)
+{
+	return sprintf(buf, "%hu\n", enable_dyn_sleep);
+}
+
+static ssize_t omap_pm_sleep_while_idle_store(struct subsystem * subsys,
+					      const char * buf,
+					      size_t n)
+{
+	unsigned short value;
+	if (sscanf(buf, "%hu", &value) != 1 ||
+	    (value != 0 && value != 1)) {
+		printk(KERN_ERR "idle_sleep_store: Invalid value\n");
+		return -EINVAL;
+	}
+	enable_dyn_sleep = value;
+	return n;
+}
 
-static unsigned int omap24xx_sleep_save[OMAP24XX_SLEEP_SAVE_SIZE];
+static struct subsys_attribute sleep_while_idle_attr = {
+	.attr   = {
+		.name = __stringify(sleep_while_idle),
+		.mode = 0644,
+	},
+	.show   = omap_pm_sleep_while_idle_show,
+	.store  = omap_pm_sleep_while_idle_store,
+};
+
+static struct clk *osc_ck, *emul_ck;
+
+#define CONTROL_DEVCONF		__REG32(0x48000274)
+#define SDRC_DLLA_CTRL		__REG32(0x68009060)
+
+static int omap2_fclks_active(void)
+{
+	u32 f1, f2;
+
+	f1 = prcm_read_reg(CM_FCLKEN1_CORE);
+	f2 = prcm_read_reg(CM_FCLKEN2_CORE);
+	serial_console_fclk_mask(&f1, &f2);
+	if (f1 | f2)
+		return 1;
+	return 0;
+}
+
+static int omap2_irq_pending(void)
+{
+	u32 pending_reg = IO_ADDRESS(0x480fe098);
+	int i;
+
+	for (i = 0; i < 4; i++) {
+		if (__raw_readl(pending_reg))
+			return 1;
+		pending_reg += 0x20;
+	}
+	return 0;
+}
+
+static atomic_t sleep_block = ATOMIC_INIT(0);
+
+void omap2_block_sleep(void)
+{
+	atomic_inc(&sleep_block);
+}
+
+void omap2_allow_sleep(void)
+{
+	int i;
+
+	i = atomic_dec_return(&sleep_block);
+	BUG_ON(i < 0);
+}
 
-void omap2_pm_idle(void)
+static void omap2_enter_full_retention(void)
+{
+	u32 sleep_time = 0;
+
+	/* There is 1 reference hold for all children of the oscillator
+	 * clock, the following will remove it. If no one else uses the
+	 * oscillator itself it will be disabled if/when we enter retention
+	 * mode.
+	 */
+	clk_disable(osc_ck);
+
+	/* Clear old wake-up events */
+	prcm_write_reg(PM_WKST1_CORE, 0xffffffff);
+	prcm_write_reg(PM_WKST2_CORE, 0xffffffff);
+	prcm_write_reg(PM_WKST_WKUP, 0xffffffff);
+
+	/* Try to enter retention */
+	prcm_write_reg(PM_PWSTCTRL_MPU, (0x01 << 0) | (1 << 2));
+
+	/* Workaround to kill USB */
+	CONTROL_DEVCONF |= 0x00008000;
+
+	omap2_gpio_prepare_for_retention();
+
+	if (omap2_pm_debug) {
+		omap2_pm_dump(0, 0, 0);
+		sleep_time = omap2_read_32k_sync_counter();
+	}
+
+	/* One last check for pending IRQs to avoid extra latency due
+	 * to sleeping unnecessarily. */
+	if (omap2_irq_pending())
+		goto no_sleep;
+
+	serial_console_sleep(1);
+	/* Jump to SRAM suspend code */
+	omap2_sram_suspend(SDRC_DLLA_CTRL);
+no_sleep:
+	serial_console_sleep(0);
+
+	if (omap2_pm_debug) {
+		unsigned long long tmp;
+		u32 resume_time;
+
+		resume_time = omap2_read_32k_sync_counter();
+		tmp = resume_time - sleep_time;
+		tmp *= 1000000;
+		omap2_pm_dump(0, 1, tmp / 32768);
+	}
+	omap2_gpio_resume_after_retention();
+
+	clk_enable(osc_ck);
+
+}
+
+static int omap2_i2c_active(void)
+{
+	u32 l;
+
+	l = prcm_read_reg(CM_FCLKEN1_CORE);
+	return l & ((1 << 19) | (1 << 20));
+}
+
+static int sti_console_enabled;
+
+static int omap2_allow_mpu_retention(void)
+{
+	u32 l;
+
+	if (atomic_read(&sleep_block))
+		return 0;
+
+	/* Check for UART2, UART1, McSPI2, McSPI1 and DSS1. */
+	l = prcm_read_reg(CM_FCLKEN1_CORE);
+	if (l & 0x04660001)
+		return 0;
+	/* Check for UART3. */
+	l = prcm_read_reg(CM_FCLKEN2_CORE);
+	if (l & (1 << 2))
+		return 0;
+	if (sti_console_enabled)
+		return 0;
+
+	return 1;
+}
+
+static void omap2_enter_mpu_retention(void)
+{
+	u32 sleep_time = 0;
+	int only_idle = 0;
+
+	/* Putting MPU into the WFI state while a transfer is active
+	 * seems to cause the I2C block to timeout. Why? Good question. */
+	if (omap2_i2c_active())
+		return;
+
+	/* The peripherals seem not to be able to wake up the MPU when
+	 * it is in retention mode. */
+	if (omap2_allow_mpu_retention()) {
+		prcm_write_reg(PM_WKST1_CORE, 0xffffffff);
+		prcm_write_reg(PM_WKST2_CORE, 0xffffffff);
+		prcm_write_reg(PM_WKST_WKUP, 0xffffffff);
+
+		/* Try to enter MPU retention */
+		prcm_write_reg(PM_PWSTCTRL_MPU, (0x01 << 0) | (1 << 2));
+	} else {
+		/* Block MPU retention */
+		prcm_write_reg(PM_PWSTCTRL_MPU, 1 << 2);
+		only_idle = 1;
+	}
+
+	if (omap2_pm_debug) {
+		omap2_pm_dump(only_idle ? 2 : 1, 0, 0);
+		sleep_time = omap2_read_32k_sync_counter();
+	}
+
+	omap2_sram_idle();
+
+	if (omap2_pm_debug) {
+		unsigned long long tmp;
+		u32 resume_time;
+
+		resume_time = omap2_read_32k_sync_counter();
+		tmp = resume_time - sleep_time;
+		tmp *= 1000000;
+		omap2_pm_dump(only_idle ? 2 : 1, 1, tmp / 32768);
+	}
+}
+
+static int omap2_can_sleep(void)
+{
+	if (!enable_dyn_sleep)
+		return 0;
+	if (omap2_fclks_active())
+		return 0;
+	if (atomic_read(&sleep_block) > 0)
+		return 0;
+	if (clk_get_usecount(osc_ck) > 1)
+		return 0;
+	if (omap_dma_running())
+		return 0;
+
+	return 1;
+}
+
+static void omap2_pm_idle(void)
 {
 	local_irq_disable();
 	local_fiq_disable();
-	if (need_resched()) {
-		local_fiq_enable();
-		local_irq_enable();
-		return;
+
+	if (!omap2_can_sleep()) {
+		/* timer_dyn_reprogram() takes about 100-200 us to complete.
+		 * In some contexts (e.g. when waiting for a GPMC-SDRAM DMA
+		 * transfer to complete), the increased latency is too much.
+		 *
+		 * omap2_block_sleep() and omap2_allow_sleep() can be used
+		 * to indicate this.
+		 */
+		if (atomic_read(&sleep_block) == 0) {
+			timer_dyn_reprogram();
+			if (omap2_irq_pending())
+				goto out;
+		}
+		omap2_enter_mpu_retention();
+		goto out;
 	}
 
 	/*
@@ -66,7 +654,12 @@ void omap2_pm_idle(void)
 	 */
 	timer_dyn_reprogram();
 
-	omap2_sram_idle();
+	if (omap2_irq_pending())
+		goto out;
+
+	omap2_enter_full_retention();
+
+out:
 	local_fiq_enable();
 	local_irq_enable();
 }
@@ -79,15 +672,12 @@ static int omap2_pm_prepare(suspend_stat
 	saved_idle = pm_idle;
 	pm_idle = NULL;
 
-	switch (state)
-	{
+	switch (state) {
 	case PM_SUSPEND_STANDBY:
 	case PM_SUSPEND_MEM:
 		break;
-
 	case PM_SUSPEND_DISK:
 		return -ENOTSUPP;
-
 	default:
 		return -EINVAL;
 	}
@@ -95,250 +685,21 @@ static int omap2_pm_prepare(suspend_stat
 	return error;
 }
 
-#define INT0_WAKE_MASK	(OMAP_IRQ_BIT(INT_24XX_GPIO_BANK1) |	\
-			OMAP_IRQ_BIT(INT_24XX_GPIO_BANK2) |	\
-			OMAP_IRQ_BIT(INT_24XX_GPIO_BANK3))
-
-#define INT1_WAKE_MASK	(OMAP_IRQ_BIT(INT_24XX_GPIO_BANK4))
-
-#define INT2_WAKE_MASK	(OMAP_IRQ_BIT(INT_24XX_UART1_IRQ) |	\
-			OMAP_IRQ_BIT(INT_24XX_UART2_IRQ) |	\
-			OMAP_IRQ_BIT(INT_24XX_UART3_IRQ))
-
-#define preg(reg)	printk("%s\t(0x%p):\t0x%08x\n", #reg, &reg, reg);
-
-static void omap2_pm_debug(char * desc)
-{
-	printk("%s:\n", desc);
-
-	preg(CM_CLKSTCTRL_MPU);
-	preg(CM_CLKSTCTRL_CORE);
-	preg(CM_CLKSTCTRL_GFX);
-	preg(CM_CLKSTCTRL_DSP);
-	preg(CM_CLKSTCTRL_MDM);
-
-	preg(PM_PWSTCTRL_MPU);
-	preg(PM_PWSTCTRL_CORE);
-	preg(PM_PWSTCTRL_GFX);
-	preg(PM_PWSTCTRL_DSP);
-	preg(PM_PWSTCTRL_MDM);
-
-	preg(PM_PWSTST_MPU);
-	preg(PM_PWSTST_CORE);
-	preg(PM_PWSTST_GFX);
-	preg(PM_PWSTST_DSP);
-	preg(PM_PWSTST_MDM);
-
-	preg(CM_AUTOIDLE1_CORE);
-	preg(CM_AUTOIDLE2_CORE);
-	preg(CM_AUTOIDLE3_CORE);
-	preg(CM_AUTOIDLE4_CORE);
-	preg(CM_AUTOIDLE_WKUP);
-	preg(CM_AUTOIDLE_PLL);
-	preg(CM_AUTOIDLE_DSP);
-	preg(CM_AUTOIDLE_MDM);
-
-	preg(CM_ICLKEN1_CORE);
-	preg(CM_ICLKEN2_CORE);
-	preg(CM_ICLKEN3_CORE);
-	preg(CM_ICLKEN4_CORE);
-	preg(CM_ICLKEN_GFX);
-	preg(CM_ICLKEN_WKUP);
-	preg(CM_ICLKEN_DSP);
-	preg(CM_ICLKEN_MDM);
-
-	preg(CM_IDLEST1_CORE);
-	preg(CM_IDLEST2_CORE);
-	preg(CM_IDLEST3_CORE);
-	preg(CM_IDLEST4_CORE);
-	preg(CM_IDLEST_GFX);
-	preg(CM_IDLEST_WKUP);
-	preg(CM_IDLEST_CKGEN);
-	preg(CM_IDLEST_DSP);
-	preg(CM_IDLEST_MDM);
-
-	preg(RM_RSTST_MPU);
-	preg(RM_RSTST_GFX);
-	preg(RM_RSTST_WKUP);
-	preg(RM_RSTST_DSP);
-	preg(RM_RSTST_MDM);
-
-	preg(PM_WKDEP_MPU);
-	preg(PM_WKDEP_CORE);
-	preg(PM_WKDEP_GFX);
-	preg(PM_WKDEP_DSP);
-	preg(PM_WKDEP_MDM);
-
-	preg(CM_FCLKEN_WKUP);
-	preg(CM_ICLKEN_WKUP);
-	preg(CM_IDLEST_WKUP);
-	preg(CM_AUTOIDLE_WKUP);
-	preg(CM_CLKSEL_WKUP);
-
-	preg(PM_WKEN_WKUP);
-	preg(PM_WKST_WKUP);
-}
-
-static inline void omap2_pm_save_registers(void)
-{
-	/* Save interrupt registers */
-	OMAP24XX_SAVE(INTC_MIR0);
-	OMAP24XX_SAVE(INTC_MIR1);
-	OMAP24XX_SAVE(INTC_MIR2);
-
-	/* Save power control registers */
-	OMAP24XX_SAVE(CM_CLKSTCTRL_MPU);
-	OMAP24XX_SAVE(CM_CLKSTCTRL_CORE);
-	OMAP24XX_SAVE(CM_CLKSTCTRL_GFX);
-	OMAP24XX_SAVE(CM_CLKSTCTRL_DSP);
-	OMAP24XX_SAVE(CM_CLKSTCTRL_MDM);
-
-	/* Save power state registers */
-	OMAP24XX_SAVE(PM_PWSTCTRL_MPU);
-	OMAP24XX_SAVE(PM_PWSTCTRL_CORE);
-	OMAP24XX_SAVE(PM_PWSTCTRL_GFX);
-	OMAP24XX_SAVE(PM_PWSTCTRL_DSP);
-	OMAP24XX_SAVE(PM_PWSTCTRL_MDM);
-
-	/* Save autoidle registers */
-	OMAP24XX_SAVE(CM_AUTOIDLE1_CORE);
-	OMAP24XX_SAVE(CM_AUTOIDLE2_CORE);
-	OMAP24XX_SAVE(CM_AUTOIDLE3_CORE);
-	OMAP24XX_SAVE(CM_AUTOIDLE4_CORE);
-	OMAP24XX_SAVE(CM_AUTOIDLE_WKUP);
-	OMAP24XX_SAVE(CM_AUTOIDLE_PLL);
-	OMAP24XX_SAVE(CM_AUTOIDLE_DSP);
-	OMAP24XX_SAVE(CM_AUTOIDLE_MDM);
-
-	/* Save idle state registers */
-	OMAP24XX_SAVE(CM_IDLEST1_CORE);
-	OMAP24XX_SAVE(CM_IDLEST2_CORE);
-	OMAP24XX_SAVE(CM_IDLEST3_CORE);
-	OMAP24XX_SAVE(CM_IDLEST4_CORE);
-	OMAP24XX_SAVE(CM_IDLEST_GFX);
-	OMAP24XX_SAVE(CM_IDLEST_WKUP);
-	OMAP24XX_SAVE(CM_IDLEST_CKGEN);
-	OMAP24XX_SAVE(CM_IDLEST_DSP);
-	OMAP24XX_SAVE(CM_IDLEST_MDM);
-
-	/* Save clock registers */
-	OMAP24XX_SAVE(CM_FCLKEN1_CORE);
-	OMAP24XX_SAVE(CM_FCLKEN2_CORE);
-	OMAP24XX_SAVE(CM_ICLKEN1_CORE);
-	OMAP24XX_SAVE(CM_ICLKEN2_CORE);
-	OMAP24XX_SAVE(CM_ICLKEN3_CORE);
-	OMAP24XX_SAVE(CM_ICLKEN4_CORE);
-}
-
-static inline void omap2_pm_restore_registers(void)
-{
-	/* Restore clock state registers */
-	OMAP24XX_RESTORE(CM_CLKSTCTRL_MPU);
-	OMAP24XX_RESTORE(CM_CLKSTCTRL_CORE);
-	OMAP24XX_RESTORE(CM_CLKSTCTRL_GFX);
-	OMAP24XX_RESTORE(CM_CLKSTCTRL_DSP);
-	OMAP24XX_RESTORE(CM_CLKSTCTRL_MDM);
-
-	/* Restore power state registers */
-	OMAP24XX_RESTORE(PM_PWSTCTRL_MPU);
-	OMAP24XX_RESTORE(PM_PWSTCTRL_CORE);
-	OMAP24XX_RESTORE(PM_PWSTCTRL_GFX);
-	OMAP24XX_RESTORE(PM_PWSTCTRL_DSP);
-	OMAP24XX_RESTORE(PM_PWSTCTRL_MDM);
-
-	/* Restore idle state registers */
-	OMAP24XX_RESTORE(CM_IDLEST1_CORE);
-	OMAP24XX_RESTORE(CM_IDLEST2_CORE);
-	OMAP24XX_RESTORE(CM_IDLEST3_CORE);
-	OMAP24XX_RESTORE(CM_IDLEST4_CORE);
-	OMAP24XX_RESTORE(CM_IDLEST_GFX);
-	OMAP24XX_RESTORE(CM_IDLEST_WKUP);
-	OMAP24XX_RESTORE(CM_IDLEST_CKGEN);
-	OMAP24XX_RESTORE(CM_IDLEST_DSP);
-	OMAP24XX_RESTORE(CM_IDLEST_MDM);
-
-	/* Restore autoidle registers */
-	OMAP24XX_RESTORE(CM_AUTOIDLE1_CORE);
-	OMAP24XX_RESTORE(CM_AUTOIDLE2_CORE);
-	OMAP24XX_RESTORE(CM_AUTOIDLE3_CORE);
-	OMAP24XX_RESTORE(CM_AUTOIDLE4_CORE);
-	OMAP24XX_RESTORE(CM_AUTOIDLE_WKUP);
-	OMAP24XX_RESTORE(CM_AUTOIDLE_PLL);
-	OMAP24XX_RESTORE(CM_AUTOIDLE_DSP);
-	OMAP24XX_RESTORE(CM_AUTOIDLE_MDM);
-
-	/* Restore clock registers */
-	OMAP24XX_RESTORE(CM_FCLKEN1_CORE);
-	OMAP24XX_RESTORE(CM_FCLKEN2_CORE);
-	OMAP24XX_RESTORE(CM_ICLKEN1_CORE);
-	OMAP24XX_RESTORE(CM_ICLKEN2_CORE);
-	OMAP24XX_RESTORE(CM_ICLKEN3_CORE);
-	OMAP24XX_RESTORE(CM_ICLKEN4_CORE);
-
-	/* REVISIT: Clear interrupts here */
-
-	/* Restore interrupt registers */
-	OMAP24XX_RESTORE(INTC_MIR0);
-	OMAP24XX_RESTORE(INTC_MIR1);
-	OMAP24XX_RESTORE(INTC_MIR2);
-}
-
 static int omap2_pm_suspend(void)
 {
-	int processor_type = 0;
-
-	/* REVISIT: 0x21 or 0x26? */
-	if (cpu_is_omap2420())
-		processor_type = 0x21;
-
-	if (!processor_type)
-		return -ENOTSUPP;
-
-	local_irq_disable();
-	local_fiq_disable();
-
-	omap2_pm_save_registers();
-
-	/* Disable interrupts except for the wake events */
-	INTC_MIR_SET0 = 0xffffffff & ~INT0_WAKE_MASK;
-	INTC_MIR_SET1 = 0xffffffff & ~INT1_WAKE_MASK;
-	INTC_MIR_SET2 = 0xffffffff & ~INT2_WAKE_MASK;
-
-	pmdomain_set_autoidle();
-
-	/* Clear old wake-up events */
-	PM_WKST1_CORE = 0;
-	PM_WKST2_CORE = 0;
-	PM_WKST_WKUP = 0;
-
-	/* Enable wake-up events */
-	PM_WKEN1_CORE = (1 << 22) | (1 << 21);	/* UART1 & 2 */
-	PM_WKEN2_CORE = (1 << 2);		/* UART3 */
-	PM_WKEN_WKUP = (1 << 2) | (1 << 0);	/* GPIO & GPT1 */
-
-	/* Disable clocks except for CM_ICLKEN2_CORE. It gets disabled
-	 * in the SRAM suspend code */
-	CM_FCLKEN1_CORE = 0;
-	CM_FCLKEN2_CORE = 0;
-	CM_ICLKEN1_CORE = 0;
-	CM_ICLKEN3_CORE = 0;
-	CM_ICLKEN4_CORE = 0;
+	u32 wken_wkup, mir1;
 
-	omap2_pm_debug("Status before suspend");
+	wken_wkup = prcm_read_reg(PM_WKEN_WKUP);
+	prcm_write_reg(PM_WKEN_WKUP, wken_wkup & ~EN_GPT1);
 
-	/* Must wait for serial buffers to clear */
-	mdelay(200);
+	/* Mask GPT1 */
+	mir1 = omap_readl(0x480fe0a4);
+	omap_writel(1 << 5, 0x480fe0ac);
 
-	/* Jump to SRAM suspend code
-	 * REVISIT: When is this SDRC_DLLB_CTRL?
-	 */
-	omap2_sram_suspend(SDRC_DLLA_CTRL, processor_type);
-
-	/* Back from sleep */
-	omap2_pm_restore_registers();
+	omap2_enter_full_retention();
 
-	local_fiq_enable();
-	local_irq_enable();
+	omap_writel(mir1, 0x480fe0a4);
+	prcm_write_reg(PM_WKEN_WKUP, wken_wkup);
 
 	return 0;
 }
@@ -347,8 +708,7 @@ static int omap2_pm_enter(suspend_state_
 {
 	int ret = 0;
 
-	switch (state)
-	{
+	switch (state) {
 	case PM_SUSPEND_STANDBY:
 	case PM_SUSPEND_MEM:
 		ret = omap2_pm_suspend();
@@ -376,16 +736,100 @@ static struct pm_ops omap_pm_ops = {
 	.finish		= omap2_pm_finish,
 };
 
+static void __init prcm_setup_regs(void)
+{
+	u32 l;
+
+	/* Enable autoidle */
+	prcm_write_reg(PRCM_SYSCONFIG, 1 << 0);
+
+	/* Set all domain wakeup dependencies */
+	prcm_write_reg(PM_WKDEP_MPU, EN_WKUP);
+	prcm_write_reg(PM_WKDEP_DSP, 0);
+	prcm_write_reg(PM_WKDEP_GFX, 0);
+
+	l = prcm_read_reg(PM_PWSTCTRL_CORE);
+	/* Enable retention for all memory blocks */
+	l |= (1 << 3) | (1 << 4) | (1 << 5);
+	/* Set power state to RETENTION */
+	l &= ~0x03;
+	l |= 0x01 << 0;
+	prcm_write_reg(PM_PWSTCTRL_CORE, l);
+
+	prcm_write_reg(PM_PWSTCTRL_MPU, (0x01 << 0) | (1 << 2));
+
+	/* Power down DSP and GFX */
+	prcm_write_reg(PM_PWSTCTRL_DSP, (1 << 18) | 0x03);
+	prcm_write_reg(PM_PWSTCTRL_GFX, (1 << 18) | 0x03);
+
+	/* Enable clock auto control for all domains */
+	prcm_write_reg(CM_CLKSTCTRL_MPU, AUTOSTAT_MPU);
+	prcm_write_reg(CM_CLKSTCTRL_CORE, AUTOSTAT_DSS | AUTOSTAT_L4 | AUTOSTAT_L3);
+	prcm_write_reg(CM_CLKSTCTRL_GFX, AUTOSTAT_GFX);
+	prcm_write_reg(CM_CLKSTCTRL_DSP, AUTOSTAT_IVA | AUTOSTAT_DSP);
+
+	/* Enable clock autoidle for all domains */
+	prcm_write_reg(CM_AUTOIDLE1_CORE, 0xfffffff9);
+	prcm_write_reg(CM_AUTOIDLE2_CORE, 0x07);
+	prcm_write_reg(CM_AUTOIDLE3_CORE, 0x07);
+	prcm_write_reg(CM_AUTOIDLE4_CORE, 0x1f);
+
+	prcm_write_reg(CM_AUTOIDLE_DSP, 0x02);
+
+	/* Put DPLL and both APLLs into autoidle mode */
+	prcm_write_reg(CM_AUTOIDLE_PLL, (0x03 << 0) | (0x03 << 2) | (0x03 << 6));
+
+	prcm_write_reg(CM_AUTOIDLE_WKUP, 0x3f);
+
+	/* REVISIT: Configure number of 32 kHz clock cycles for sys_clk
+	 * stabilisation */
+	prcm_write_reg(PRCM_CLKSSETUP, 15);
+
+	/* Configure automatic voltage transition */
+	prcm_write_reg(PRCM_VOLTSETUP, 2);
+	l = AUTO_EXTVOLT | SETOFF_LEVEL(1) | MEMRETCTRL | \
+		SETRET_LEVEL(1) | VOLT_LEVEL(0);
+	prcm_write_reg(PRCM_VOLTCTRL, l);
+
+	/* Enable wake-up events */
+	prcm_write_reg(PM_WKEN_WKUP, EN_GPIOS | EN_GPT1);
+}
+
 int __init omap2_pm_init(void)
 {
-	printk("Power Management for TI OMAP.\n");
+	u32 l;
+
+	printk(KERN_INFO "Power Management for OMAP2 initializing\n");
+	l = prcm_read_reg(PRCM_REVISION);
+	printk(KERN_INFO "PRCM revision %d.%d\n", (l >> 4) & 0x0f, l & 0x0f);
+
+	osc_ck = clk_get(NULL, "osc_ck");
+	if (IS_ERR(osc_ck)) {
+		printk(KERN_ERR "could not get osc_ck\n");
+		return -ENODEV;
+	}
 
-	vclk = clk_get(NULL, "virt_prcm_set");
-	if (IS_ERR(vclk)) {
-		printk(KERN_ERR "Could not get PM vclk\n");
+	emul_ck = clk_get(NULL, "emul_ck");
+	if (IS_ERR(emul_ck)) {
+		printk(KERN_ERR "could not get emul_ck\n");
+		clk_put(osc_ck);
 		return -ENODEV;
 	}
 
+	prcm_setup_regs();
+
+	pm_init_serial_console();
+
+	/* Hack to prevent MPU retention when STI console is enabled. */
+	{
+		const struct omap_sti_console_config *sti;
+
+		sti = omap_get_config(OMAP_TAG_STI_CONSOLE,
+				      struct omap_sti_console_config);
+		if (sti != NULL && sti->enable)
+			sti_console_enabled = 1;
+	}
+
 	/*
 	 * We copy the assembler sleep/wakeup routines to SRAM.
 	 * These routines need to be in SRAM as that's the only
@@ -393,16 +837,17 @@ int __init omap2_pm_init(void)
 	 */
 	omap2_sram_idle = omap_sram_push(omap24xx_idle_loop_suspend,
 					 omap24xx_idle_loop_suspend_sz);
-
 	omap2_sram_suspend = omap_sram_push(omap24xx_cpu_suspend,
 					    omap24xx_cpu_suspend_sz);
 
 	pm_set_ops(&omap_pm_ops);
 	pm_idle = omap2_pm_idle;
 
-	pmdomain_init();
+	l = subsys_create_file(&power_subsys, &sleep_while_idle_attr);
+	if (l)
+		printk(KERN_ERR "subsys_create_file failed: %d\n", l);
 
 	return 0;
 }
 
-__initcall(omap2_pm_init);
+late_initcall(omap2_pm_init);
Index: linux-2.6/arch/arm/mach-omap2/sleep.S
===================================================================
--- linux-2.6.orig/arch/arm/mach-omap2/sleep.S	2007-04-05 15:33:53.000000000 -0400
+++ linux-2.6/arch/arm/mach-omap2/sleep.S	2007-04-09 15:17:39.000000000 -0400
@@ -5,6 +5,10 @@
  * Texas Instruments, <www.ti.com>
  * Richard Woodruff <r-woodruff2@ti.com>
  *
+ * (C) Copyright 2006 Nokia Corporation
+ * Fixed idle loop sleep
+ * Igor Stoppa <igor.stoppa@nokia.com>
+ *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License as
  * published by the Free Software Foundation; either version 2 of
@@ -26,14 +30,6 @@
 #include <asm/arch/io.h>
 #include <asm/arch/pm.h>
 
-#define A_32KSYNC_CR_V		IO_ADDRESS(OMAP_TIMER32K_BASE+0x10)
-#define A_PRCM_VOLTCTRL_V	IO_ADDRESS(OMAP24XX_PRCM_BASE+0x50)
-#define A_PRCM_CLKCFG_CTRL_V	IO_ADDRESS(OMAP24XX_PRCM_BASE+0x80)
-#define A_CM_CLKEN_PLL_V	IO_ADDRESS(OMAP24XX_PRCM_BASE+0x500)
-#define A_CM_IDLEST_CKGEN_V	IO_ADDRESS(OMAP24XX_PRCM_BASE+0x520)
-#define A_CM_CLKSEL1_PLL_V	IO_ADDRESS(OMAP24XX_PRCM_BASE+0x540)
-#define A_CM_CLKSEL2_PLL_V	IO_ADDRESS(OMAP24XX_PRCM_BASE+0x544)
-
 #define A_SDRC_DLLA_CTRL_V	IO_ADDRESS(OMAP24XX_SDRC_BASE+0x60)
 #define	A_SDRC_POWER_V		IO_ADDRESS(OMAP24XX_SDRC_BASE+0x70)
 #define A_SDRC_RFR_CTRL_V	IO_ADDRESS(OMAP24XX_SDRC_BASE+0xA4)
@@ -53,7 +49,7 @@
  */
 ENTRY(omap24xx_idle_loop_suspend)
 	stmfd	sp!, {r0, lr}		@ save registers on stack
-	mov	r0, #0			@ clear for mcr setup
+	mov	r0, #0x0		@ clear for mrc call
 	mcr	p15, 0, r0, c7, c0, 4	@ wait for interrupt
 	ldmfd	sp!, {r0, pc}		@ restore regs and return
 
@@ -67,9 +63,6 @@ ENTRY(omap24xx_idle_loop_suspend_sz)
  *
  * Input:
  * R0 :	DLL ctrl value pre-Sleep
- * R1 : Processor+Revision
- *	2420: 0x21 = 242xES1, 0x26 = 242xES2.2
- *	2430: 0x31 = 2430ES1, 0x32 = 2430ES2
  *
  * The if the DPLL is going to AutoIdle. It seems like the DPLL may be back on
  * when we get called, but the DLL probably isn't.  We will wait a bit more in
@@ -129,14 +122,8 @@ A_SDRC_POWER:
 	.word A_SDRC_POWER_V
 A_SDRC0:
 	.word A_SDRC0_V
-A_CM_CLKSEL2_PLL_S:
-	.word A_CM_CLKSEL2_PLL_V
-A_CM_CLKEN_PLL:
-	.word A_CM_CLKEN_PLL_V
 A_SDRC_DLLA_CTRL_S:
 	.word A_SDRC_DLLA_CTRL_V
-A_SDRC_MANUAL_S:
-	.word A_SDRC_MANUAL_V
 
 ENTRY(omap24xx_cpu_suspend_sz)
 	.word	. - omap24xx_cpu_suspend
Index: linux-2.6/include/asm-arm/arch-omap/pm.h
===================================================================
--- linux-2.6.orig/include/asm-arm/arch-omap/pm.h	2007-04-05 15:33:53.000000000 -0400
+++ linux-2.6/include/asm-arm/arch-omap/pm.h	2007-04-09 15:17:39.000000000 -0400
@@ -1,5 +1,5 @@
 /*
- * linux/include/asm-arm/arch-omap/pm.h
+ * linux/include/asm/arch-omap/pm.h
  *
  * Header file for OMAP Power Management Routines
  *
@@ -115,6 +115,8 @@
 
 #include <linux/clk.h>
 
+extern struct subsystem power_subsys;
+
 extern void prevent_idle_sleep(void);
 extern void allow_idle_sleep(void);
 
@@ -132,6 +134,8 @@ void clk_deny_idle(struct clk *clk);
 
 extern void omap_pm_idle(void);
 extern void omap_pm_suspend(void);
+extern void omap2_block_sleep(void);
+extern void omap2_allow_sleep(void);
 extern void omap730_cpu_suspend(unsigned short, unsigned short);
 extern void omap1510_cpu_suspend(unsigned short, unsigned short);
 extern void omap1610_cpu_suspend(unsigned short, unsigned short);
@@ -181,10 +185,6 @@ extern void omap_serial_wake_trigger(int
 #define MPUI1610_RESTORE(x) omap_writel((mpui1610_sleep_save[MPUI1610_SLEEP_SAVE_##x]), (x))
 #define MPUI1610_SHOW(x) mpui1610_sleep_save[MPUI1610_SLEEP_SAVE_##x]
 
-#define OMAP24XX_SAVE(x) omap24xx_sleep_save[OMAP24XX_SLEEP_SAVE_##x] = x
-#define OMAP24XX_RESTORE(x) x = omap24xx_sleep_save[OMAP24XX_SLEEP_SAVE_##x]
-#define OMAP24XX_SHOW(x) omap24xx_sleep_save[OMAP24XX_SLEEP_SAVE_##x]
-
 /*
  * List of global OMAP registers to preserve.
  * More ones like CP and general purpose register values are preserved
@@ -294,63 +294,5 @@ enum mpui1610_save_state {
 #endif
 };
 
-enum omap24xx_save_state {
-	OMAP24XX_SLEEP_SAVE_START = 0,
-	OMAP24XX_SLEEP_SAVE_INTC_MIR0,
-	OMAP24XX_SLEEP_SAVE_INTC_MIR1,
-	OMAP24XX_SLEEP_SAVE_INTC_MIR2,
-
-	OMAP24XX_SLEEP_SAVE_CM_CLKSTCTRL_MPU,
-	OMAP24XX_SLEEP_SAVE_CM_CLKSTCTRL_CORE,
-	OMAP24XX_SLEEP_SAVE_CM_CLKSTCTRL_GFX,
-	OMAP24XX_SLEEP_SAVE_CM_CLKSTCTRL_DSP,
-	OMAP24XX_SLEEP_SAVE_CM_CLKSTCTRL_MDM,
-
-	OMAP24XX_SLEEP_SAVE_PM_PWSTCTRL_MPU,
-	OMAP24XX_SLEEP_SAVE_PM_PWSTCTRL_CORE,
-	OMAP24XX_SLEEP_SAVE_PM_PWSTCTRL_GFX,
-	OMAP24XX_SLEEP_SAVE_PM_PWSTCTRL_DSP,
-	OMAP24XX_SLEEP_SAVE_PM_PWSTCTRL_MDM,
-
-	OMAP24XX_SLEEP_SAVE_CM_IDLEST1_CORE,
-	OMAP24XX_SLEEP_SAVE_CM_IDLEST2_CORE,
-	OMAP24XX_SLEEP_SAVE_CM_IDLEST3_CORE,
-	OMAP24XX_SLEEP_SAVE_CM_IDLEST4_CORE,
-	OMAP24XX_SLEEP_SAVE_CM_IDLEST_GFX,
-	OMAP24XX_SLEEP_SAVE_CM_IDLEST_WKUP,
-	OMAP24XX_SLEEP_SAVE_CM_IDLEST_CKGEN,
-	OMAP24XX_SLEEP_SAVE_CM_IDLEST_DSP,
-	OMAP24XX_SLEEP_SAVE_CM_IDLEST_MDM,
-
-	OMAP24XX_SLEEP_SAVE_CM_AUTOIDLE1_CORE,
-	OMAP24XX_SLEEP_SAVE_CM_AUTOIDLE2_CORE,
-	OMAP24XX_SLEEP_SAVE_CM_AUTOIDLE3_CORE,
-	OMAP24XX_SLEEP_SAVE_CM_AUTOIDLE4_CORE,
-	OMAP24XX_SLEEP_SAVE_CM_AUTOIDLE_WKUP,
-	OMAP24XX_SLEEP_SAVE_CM_AUTOIDLE_PLL,
-	OMAP24XX_SLEEP_SAVE_CM_AUTOIDLE_DSP,
-	OMAP24XX_SLEEP_SAVE_CM_AUTOIDLE_MDM,
-
-	OMAP24XX_SLEEP_SAVE_CM_FCLKEN1_CORE,
-	OMAP24XX_SLEEP_SAVE_CM_FCLKEN2_CORE,
-	OMAP24XX_SLEEP_SAVE_CM_ICLKEN1_CORE,
-	OMAP24XX_SLEEP_SAVE_CM_ICLKEN2_CORE,
-	OMAP24XX_SLEEP_SAVE_CM_ICLKEN3_CORE,
-	OMAP24XX_SLEEP_SAVE_CM_ICLKEN4_CORE,
-	OMAP24XX_SLEEP_SAVE_GPIO1_IRQENABLE1,
-	OMAP24XX_SLEEP_SAVE_GPIO2_IRQENABLE1,
-	OMAP24XX_SLEEP_SAVE_GPIO3_IRQENABLE1,
-	OMAP24XX_SLEEP_SAVE_GPIO4_IRQENABLE1,
-	OMAP24XX_SLEEP_SAVE_GPIO3_OE,
-	OMAP24XX_SLEEP_SAVE_GPIO4_OE,
-	OMAP24XX_SLEEP_SAVE_GPIO3_RISINGDETECT,
-	OMAP24XX_SLEEP_SAVE_GPIO3_FALLINGDETECT,
-	OMAP24XX_SLEEP_SAVE_CONTROL_PADCONF_SPI1_NCS2,
-	OMAP24XX_SLEEP_SAVE_CONTROL_PADCONF_MCBSP1_DX,
-	OMAP24XX_SLEEP_SAVE_CONTROL_PADCONF_SSI1_FLAG_TX,
-	OMAP24XX_SLEEP_SAVE_CONTROL_PADCONF_SYS_NIRQW0,
-	OMAP24XX_SLEEP_SAVE_SIZE
-};
-
 #endif /* ASSEMBLER */
 #endif /* __ASM_ARCH_OMAP_PM_H */
Index: linux-2.6/include/asm-arm/arch-omap/gpio.h
===================================================================
--- linux-2.6.orig/include/asm-arm/arch-omap/gpio.h	2007-04-05 15:33:53.000000000 -0400
+++ linux-2.6/include/asm-arm/arch-omap/gpio.h	2007-04-09 15:17:39.000000000 -0400
@@ -75,6 +75,8 @@ extern void omap_free_gpio(int gpio);
 extern void omap_set_gpio_direction(int gpio, int is_input);
 extern void omap_set_gpio_dataout(int gpio, int enable);
 extern int omap_get_gpio_datain(int gpio);
+extern void omap2_gpio_prepare_for_retention(void);
+extern void omap2_gpio_resume_after_retention(void);
 
 /*-------------------------------------------------------------------------*/
 
