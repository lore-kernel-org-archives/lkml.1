Return-Path: <linux-kernel-owner+w=401wt.eu-S1753797AbZA1UeL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797AbZA1UeL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 15:34:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755348AbZA1U3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:29:23 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:32872 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755291AbZA1U3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:29:16 -0500
MBOX-Line: From nobody Wed Jan 28 12:27:37 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH E 03/14] OMAP2 SDRC: separate common OMAP2/3 code from
	OMAP2xxx code
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, Paul Walmsley <paul@pwsan.com>,
       Tony Lindgren <tony@atomide.com>
Date: Wed, 28 Jan 2009 12:27:37 -0700
Message-ID: <20090128192734.29333.40680.stgit@localhost.localdomain>
In-Reply-To: <20090128192551.29333.82943.stgit@localhost.localdomain>
References: <20090128192551.29333.82943.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separate SDRC code common to OMAP2/3 from mach-omap2/sdrc2xxx.c to
mach-omap2/sdrc.c.  Rename the OMAP2xxx-specific functions to use an
'omap2xxx' prefix rather than an 'omap2' prefix, and use "sdrc" in the
function names rather than "memory."  Mark several functions
as static that should not be used outside the sdrc2xxx.c file.

linux-omap source commit is bf1612b9d8d29379558500cd5de9ae0367c41fc4.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/Makefile             |    6 ++-
 arch/arm/mach-omap2/clock24xx.c          |   25 ++++++-----
 arch/arm/mach-omap2/io.c                 |    2 -
 arch/arm/mach-omap2/sdrc.c               |   57 ++++++++++++++++++++++++++
 arch/arm/mach-omap2/sdrc2xxx.c           |   67 +++++++-----------------------
 arch/arm/plat-omap/common.c              |    2 -
 arch/arm/plat-omap/include/mach/common.h |    2 -
 arch/arm/plat-omap/include/mach/sdrc.h   |   37 ++++++++++-------
 8 files changed, 116 insertions(+), 82 deletions(-)
 create mode 100644 arch/arm/mach-omap2/sdrc.c

diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index bb47d43..9717afc 100644
--- a/arch/arm/mach-omap2/Makefile
+++ b/arch/arm/mach-omap2/Makefile
@@ -3,7 +3,7 @@
 #
 
 # Common support
-obj-y := irq.o id.o io.o sdrc2xxx.o control.o prcm.o clock.o mux.o \
+obj-y := irq.o id.o io.o sdrc.o control.o prcm.o clock.o mux.o \
 		devices.o serial.o gpmc.o timer-gp.o powerdomain.o \
 		clockdomain.o
 
@@ -14,6 +14,10 @@ obj-$(CONFIG_ARCH_OMAP2420)		+= sram242x.o
 obj-$(CONFIG_ARCH_OMAP2430)		+= sram243x.o
 obj-$(CONFIG_ARCH_OMAP3)		+= sram34xx.o
 
+# SMS/SDRC
+obj-$(CONFIG_ARCH_OMAP2)		+= sdrc2xxx.o
+# obj-$(CONFIG_ARCH_OMAP3)		+= sdrc3xxx.o
+
 # Power Management
 ifeq ($(CONFIG_PM),y)
 obj-y					+= pm.o
diff --git a/arch/arm/mach-omap2/clock24xx.c b/arch/arm/mach-omap2/clock24xx.c
index a11ba09..640a2cb 100644
--- a/arch/arm/mach-omap2/clock24xx.c
+++ b/arch/arm/mach-omap2/clock24xx.c
@@ -34,7 +34,7 @@
 
 #include <asm/div64.h>
 
-#include <asm/arch/sdrc.h>
+#include <mach/sdrc.h>
 #include "clock.h"
 #include "clock24xx.h"
 #include "prm.h"
@@ -198,9 +198,9 @@ static int omap2_reprogram_dpllcore(struct clk *clk, unsigned long rate)
 	mult &= OMAP24XX_CORE_CLK_SRC_MASK;
 
 	if ((rate == (cur_rate / 2)) && (mult == 2)) {
-		omap2_reprogram_sdrc(CORE_CLK_SRC_DPLL, 1);
+		omap2xxx_sdrc_reprogram(CORE_CLK_SRC_DPLL, 1);
 	} else if ((rate == (cur_rate * 2)) && (mult == 1)) {
-		omap2_reprogram_sdrc(CORE_CLK_SRC_DPLL_X2, 1);
+		omap2xxx_sdrc_reprogram(CORE_CLK_SRC_DPLL_X2, 1);
 	} else if (rate != cur_rate) {
 		valid_rate = omap2_dpllcore_round_rate(rate);
 		if (valid_rate != rate)
@@ -240,15 +240,16 @@ static int omap2_reprogram_dpllcore(struct clk *clk, unsigned long rate)
 		if (rate == curr_prcm_set->xtal_speed)	/* If asking for 1-1 */
 			bypass = 1;
 
-		omap2_reprogram_sdrc(CORE_CLK_SRC_DPLL_X2, 1); /* For init_mem */
+		/* For omap2xxx_sdrc_init_params() */
+		omap2xxx_sdrc_reprogram(CORE_CLK_SRC_DPLL_X2, 1);
 
 		/* Force dll lock mode */
 		omap2_set_prcm(tmpset.cm_clksel1_pll, tmpset.base_sdrc_rfr,
 			       bypass);
 
 		/* Errata: ret dll entry state */
-		omap2_init_memory_params(omap2_dll_force_needed());
-		omap2_reprogram_sdrc(done_rate, 0);
+		omap2xxx_sdrc_init_params(omap2xxx_sdrc_dll_is_unlocked());
+		omap2xxx_sdrc_reprogram(done_rate, 0);
 	}
 	omap2_dpllcore_recalc(&dpll_ck);
 	ret = 0;
@@ -335,9 +336,9 @@ static int omap2_select_table_rate(struct clk *clk, unsigned long rate)
 	cur_rate = omap2xxx_clk_get_core_rate(&dpll_ck);
 
 	if (prcm->dpll_speed == cur_rate / 2) {
-		omap2_reprogram_sdrc(CORE_CLK_SRC_DPLL, 1);
+		omap2xxx_sdrc_reprogram(CORE_CLK_SRC_DPLL, 1);
 	} else if (prcm->dpll_speed == cur_rate * 2) {
-		omap2_reprogram_sdrc(CORE_CLK_SRC_DPLL_X2, 1);
+		omap2xxx_sdrc_reprogram(CORE_CLK_SRC_DPLL_X2, 1);
 	} else if (prcm->dpll_speed != cur_rate) {
 		local_irq_save(flags);
 
@@ -368,14 +369,14 @@ static int omap2_select_table_rate(struct clk *clk, unsigned long rate)
 			cm_write_mod_reg(prcm->cm_clksel_mdm,
 					 OMAP2430_MDM_MOD, CM_CLKSEL);
 
-		/* x2 to enter init_mem */
-		omap2_reprogram_sdrc(CORE_CLK_SRC_DPLL_X2, 1);
+		/* x2 to enter omap2xxx_sdrc_init_params() */
+		omap2xxx_sdrc_reprogram(CORE_CLK_SRC_DPLL_X2, 1);
 
 		omap2_set_prcm(prcm->cm_clksel1_pll, prcm->base_sdrc_rfr,
 			       bypass);
 
-		omap2_init_memory_params(omap2_dll_force_needed());
-		omap2_reprogram_sdrc(done_rate, 0);
+		omap2xxx_sdrc_init_params(omap2xxx_sdrc_dll_is_unlocked());
+		omap2xxx_sdrc_reprogram(done_rate, 0);
 
 		local_irq_restore(flags);
 	}
diff --git a/arch/arm/mach-omap2/io.c b/arch/arm/mach-omap2/io.c
index 2b5f28a..3c1de36 100644
--- a/arch/arm/mach-omap2/io.c
+++ b/arch/arm/mach-omap2/io.c
@@ -201,6 +201,6 @@ void __init omap2_init_common_hw(void)
 	pwrdm_init(powerdomains_omap);
 	clkdm_init(clockdomains_omap, clkdm_pwrdm_autodeps);
 	omap2_clk_init();
-	omap2_init_memory();
+	omap2_sdrc_init();
 	gpmc_init();
 }
diff --git a/arch/arm/mach-omap2/sdrc.c b/arch/arm/mach-omap2/sdrc.c
new file mode 100644
index 0000000..24b54d5
--- /dev/null
+++ b/arch/arm/mach-omap2/sdrc.c
@@ -0,0 +1,57 @@
+/*
+ * SMS/SDRC (SDRAM controller) common code for OMAP2/3
+ *
+ * Copyright (C) 2005, 2008 Texas Instruments Inc.
+ * Copyright (C) 2005, 2008 Nokia Corporation
+ *
+ * Tony Lindgren <tony@atomide.com>
+ * Paul Walmsley
+ * Richard Woodruff <r-woodruff2@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/list.h>
+#include <linux/errno.h>
+#include <linux/delay.h>
+#include <linux/clk.h>
+#include <linux/io.h>
+
+#include <mach/common.h>
+#include <mach/clock.h>
+#include <mach/sram.h>
+
+#include "prm.h"
+
+#include <mach/sdrc.h>
+#include "sdrc.h"
+
+void __iomem *omap2_sdrc_base;
+void __iomem *omap2_sms_base;
+
+void __init omap2_set_globals_sdrc(struct omap_globals *omap2_globals)
+{
+	omap2_sdrc_base = omap2_globals->sdrc;
+	omap2_sms_base = omap2_globals->sms;
+}
+
+/* turn on smart idle modes for SDRAM scheduler and controller */
+void __init omap2_sdrc_init(void)
+{
+	u32 l;
+
+	l = sms_read_reg(SMS_SYSCONFIG);
+	l &= ~(0x3 << 3);
+	l |= (0x2 << 3);
+	sms_write_reg(l, SMS_SYSCONFIG);
+
+	l = sdrc_read_reg(SDRC_SYSCONFIG);
+	l &= ~(0x3 << 3);
+	l |= (0x2 << 3);
+	sdrc_write_reg(l, SDRC_SYSCONFIG);
+}
diff --git a/arch/arm/mach-omap2/sdrc2xxx.c b/arch/arm/mach-omap2/sdrc2xxx.c
index c636228..130e7b7 100644
--- a/arch/arm/mach-omap2/sdrc2xxx.c
+++ b/arch/arm/mach-omap2/sdrc2xxx.c
@@ -3,11 +3,12 @@
  *
  * SDRAM timing related functions for OMAP2xxx
  *
- * Copyright (C) 2005 Texas Instruments Inc.
- * Richard Woodruff <r-woodruff2@ti.com>
+ * Copyright (C) 2005, 2008 Texas Instruments Inc.
+ * Copyright (C) 2005, 2008 Nokia Corporation
  *
- * Copyright (C) 2005 Nokia Corporation
  * Tony Lindgren <tony@atomide.com>
+ * Paul Walmsley
+ * Richard Woodruff <r-woodruff2@ti.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -41,23 +42,20 @@
 #define M_LOCK		1
 
 
-void __iomem *omap2_sdrc_base;
-void __iomem *omap2_sms_base;
-
 static struct memory_timings mem_timings;
 static u32 curr_perf_level = CORE_CLK_SRC_DPLL_X2;
 
-u32 omap2_memory_get_slow_dll_ctrl(void)
+static u32 omap2xxx_sdrc_get_slow_dll_ctrl(void)
 {
 	return mem_timings.slow_dll_ctrl;
 }
 
-u32 omap2_memory_get_fast_dll_ctrl(void)
+static u32 omap2xxx_sdrc_get_fast_dll_ctrl(void)
 {
 	return mem_timings.fast_dll_ctrl;
 }
 
-u32 omap2_memory_get_type(void)
+static u32 omap2xxx_sdrc_get_type(void)
 {
 	return mem_timings.m_type;
 }
@@ -66,7 +64,7 @@ u32 omap2_memory_get_type(void)
  * Check the DLL lock state, and return tue if running in unlock mode.
  * This is needed to compensate for the shifted DLL value in unlock mode.
  */
-u32 omap2_dll_force_needed(void)
+u32 omap2xxx_sdrc_dll_is_unlocked(void)
 {
 	/* dlla and dllb are a set */
 	u32 dll_state = sdrc_read_reg(SDRC_DLLA_CTRL);
@@ -81,8 +79,10 @@ u32 omap2_dll_force_needed(void)
  * 'level' is the value to store to CM_CLKSEL2_PLL.CORE_CLK_SRC.
  * Practical values are CORE_CLK_SRC_DPLL (for CORE_CLK = DPLL_CLK) or
  * CORE_CLK_SRC_DPLL_X2 (for CORE_CLK = * DPLL_CLK * 2)
+ *
+ * Used by the clock framework during CORE DPLL changes
  */
-u32 omap2_reprogram_sdrc(u32 level, u32 force)
+u32 omap2xxx_sdrc_reprogram(u32 level, u32 force)
 {
 	u32 dll_ctrl, m_type;
 	u32 prev = curr_perf_level;
@@ -92,13 +92,13 @@ u32 omap2_reprogram_sdrc(u32 level, u32 force)
 		return prev;
 
 	if (level == CORE_CLK_SRC_DPLL)
-		dll_ctrl = omap2_memory_get_slow_dll_ctrl();
+		dll_ctrl = omap2xxx_sdrc_get_slow_dll_ctrl();
 	else if (level == CORE_CLK_SRC_DPLL_X2)
-		dll_ctrl = omap2_memory_get_fast_dll_ctrl();
+		dll_ctrl = omap2xxx_sdrc_get_fast_dll_ctrl();
 	else
 		return prev;
 
-	m_type = omap2_memory_get_type();
+	m_type = omap2xxx_sdrc_get_type();
 
 	local_irq_save(flags);
 	prm_write_mod_reg(0xffff, OMAP24XX_GR_MOD,
@@ -110,18 +110,8 @@ u32 omap2_reprogram_sdrc(u32 level, u32 force)
 	return prev;
 }
 
-#if !defined(CONFIG_ARCH_OMAP2)
-void omap2_sram_ddr_init(u32 *slow_dll_ctrl, u32 fast_dll_ctrl,
-				u32 base_cs, u32 force_unlock)
-{
-}
-void omap2_sram_reprogram_sdrc(u32 perf_level, u32 dll_val,
-				      u32 mem_type)
-{
-}
-#endif
-
-void omap2_init_memory_params(u32 force_lock_to_unlock_mode)
+/* Used by the clock framework during CORE DPLL changes */
+void omap2xxx_sdrc_init_params(u32 force_lock_to_unlock_mode)
 {
 	unsigned long dll_cnt;
 	u32 fast_dll = 0;
@@ -174,28 +164,3 @@ void omap2_init_memory_params(u32 force_lock_to_unlock_mode)
 	/* 90 degree phase for anything below 133Mhz + disable DLL filter */
 	mem_timings.slow_dll_ctrl |= ((1 << 1) | (3 << 8));
 }
-
-void __init omap2_set_globals_memory(struct omap_globals *omap2_globals)
-{
-	omap2_sdrc_base = omap2_globals->sdrc;
-	omap2_sms_base = omap2_globals->sms;
-}
-
-/* turn on smart idle modes for SDRAM scheduler and controller */
-void __init omap2_init_memory(void)
-{
-	u32 l;
-
-	if (!cpu_is_omap2420())
-		return;
-
-	l = sms_read_reg(SMS_SYSCONFIG);
-	l &= ~(0x3 << 3);
-	l |= (0x2 << 3);
-	sms_write_reg(l, SMS_SYSCONFIG);
-
-	l = sdrc_read_reg(SDRC_SYSCONFIG);
-	l &= ~(0x3 << 3);
-	l |= (0x2 << 3);
-	sdrc_write_reg(l, SDRC_SYSCONFIG);
-}
diff --git a/arch/arm/plat-omap/common.c b/arch/arm/plat-omap/common.c
index 0843b88..187239c 100644
--- a/arch/arm/plat-omap/common.c
+++ b/arch/arm/plat-omap/common.c
@@ -249,7 +249,7 @@ static struct omap_globals *omap2_globals;
 static void __init __omap2_set_globals(void)
 {
 	omap2_set_globals_tap(omap2_globals);
-	omap2_set_globals_memory(omap2_globals);
+	omap2_set_globals_sdrc(omap2_globals);
 	omap2_set_globals_control(omap2_globals);
 	omap2_set_globals_prcm(omap2_globals);
 }
diff --git a/arch/arm/plat-omap/include/mach/common.h b/arch/arm/plat-omap/include/mach/common.h
index 4ddb661..5f46249 100644
--- a/arch/arm/plat-omap/include/mach/common.h
+++ b/arch/arm/plat-omap/include/mach/common.h
@@ -65,7 +65,7 @@ void omap2_set_globals_343x(void);
 
 /* These get called from omap2_set_globals_xxxx(), do not call these */
 void omap2_set_globals_tap(struct omap_globals *);
-void omap2_set_globals_memory(struct omap_globals *);
+void omap2_set_globals_sdrc(struct omap_globals *);
 void omap2_set_globals_control(struct omap_globals *);
 void omap2_set_globals_prcm(struct omap_globals *);
 #ifdef CONFIG_ARCH_OMAP24XX
diff --git a/arch/arm/plat-omap/include/mach/sdrc.h b/arch/arm/plat-omap/include/mach/sdrc.h
index c905b52..8e0740e 100644
--- a/arch/arm/plat-omap/include/mach/sdrc.h
+++ b/arch/arm/plat-omap/include/mach/sdrc.h
@@ -4,10 +4,12 @@
 /*
  * OMAP2/3 SDRC/SMS register definitions
  *
- * Copyright (C) 2007 Texas Instruments, Inc.
- * Copyright (C) 2007 Nokia Corporation
+ * Copyright (C) 2007-2008 Texas Instruments, Inc.
+ * Copyright (C) 2007-2008 Nokia Corporation
  *
- * Written by Paul Walmsley
+ * Tony Lindgren
+ * Paul Walmsley
+ * Richard Woodruff
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -64,18 +66,25 @@
  * SMS register access
  */
 
-
-#define OMAP242X_SMS_REGADDR(reg)	IO_ADDRESS(OMAP2420_SMS_BASE + reg)
-#define OMAP243X_SMS_REGADDR(reg)	IO_ADDRESS(OMAP243X_SMS_BASE + reg)
-#define OMAP343X_SMS_REGADDR(reg)	IO_ADDRESS(OMAP343X_SMS_BASE + reg)
+#define OMAP242X_SMS_REGADDR(reg)					\
+			(void __iomem *)IO_ADDRESS(OMAP2420_SMS_BASE + reg)
+#define OMAP243X_SMS_REGADDR(reg)					\
+			(void __iomem *)IO_ADDRESS(OMAP243X_SMS_BASE + reg)
+#define OMAP343X_SMS_REGADDR(reg)					\
+			(void __iomem *)IO_ADDRESS(OMAP343X_SMS_BASE + reg)
 
 /* SMS register offsets - read/write with sms_{read,write}_reg() */
 
 #define SMS_SYSCONFIG		0x010
 /* REVISIT: fill in other SMS registers here */
 
+
 #ifndef __ASSEMBLER__
 
+void __init omap2_sdrc_init(void);
+
+#ifdef CONFIG_ARCH_OMAP2
+
 struct memory_timings {
 	u32 m_type;		/* ddr = 1, sdr = 0 */
 	u32 dll_mode;		/* use lock mode = 1, unlock mode = 0 */
@@ -84,15 +93,13 @@ struct memory_timings {
 	u32 base_cs;		/* base chip select to use for calculations */
 };
 
-extern void omap2_init_memory_params(u32 force_lock_to_unlock_mode);
-extern u32 omap2_memory_get_slow_dll_ctrl(void);
-extern u32 omap2_memory_get_fast_dll_ctrl(void);
-extern u32 omap2_memory_get_type(void);
-u32 omap2_dll_force_needed(void);
-u32 omap2_reprogram_sdrc(u32 level, u32 force);
-void __init omap2_init_memory(void);
+extern void omap2xxx_sdrc_init_params(u32 force_lock_to_unlock_mode);
 
-#endif
+u32 omap2xxx_sdrc_dll_is_unlocked(void);
+u32 omap2xxx_sdrc_reprogram(u32 level, u32 force);
+
+#endif  /* CONFIG_ARCH_OMAP2 */
 
+#endif  /* __ASSEMBLER__ */
 
 #endif


