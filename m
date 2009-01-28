Return-Path: <linux-kernel-owner+w=401wt.eu-S1757842AbZA1Unx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757842AbZA1Unx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 15:43:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754813AbZA1Uaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:30:46 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:33007 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754994AbZA1Uak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:30:40 -0500
MBOX-Line: From nobody Tue Jan 27 19:44:15 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH B 03/10] OMAP2/3 clockdomains: add CM, PRM,
	virt_opp_clkdm clockdomains
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, Paul Walmsley <paul@pwsan.com>,
       Tony Lindgren <tony@atomide.com>,
       Tomi Valkeinen <tomi.valkeinen@nokia.com>
Date: Tue, 27 Jan 2009 19:44:15 -0700
Message-ID: <20090128024411.27240.28757.stgit@localhost.localdomain>
In-Reply-To: <20090128024301.27240.39391.stgit@localhost.localdomain>
References: <20090128024301.27240.39391.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add clockdomains for the CM and PRM.  These replace "wkup_clkdm", a
placeholder clockdomain which does not exist on the hardware.  Add a
clockdomain for virtual OPP clocks, "virt_opp_clkdm".  Mark all clocks
in the clock tree with a valid clockdomain.

The following TI documents are used as reference:

OMAP2420 Multimedia Processor Silicon Revision 2.1.1, 2.2 TRM Version Q
OMAP34xx Multimedia Device Silicon Revision 3.0 Version I TRM
OMAP34xx Multimedia High Security (HS) Device Silicon Revision 3.0 Security
    Addendum Version B TRM

This patch includes an earlier fix to sys_clkout2's clockdomain by
Tomi Valkeinen <tomi.valkeinen@nokia.com>.

linux-omap source commits are a4061e5422dae1433264b40178f73dc6f1d6d748,
859207f04c6b64ee714a65a58ee629ddde91bfa8, and
f34f5bdd731fe828241d729fd465612a56d7e35f.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@nokia.com>
---
 arch/arm/mach-omap2/clock24xx.h               |   49 ++++++++++--------
 arch/arm/mach-omap2/clock34xx.h               |   70 ++++++++++++++++++-------
 arch/arm/mach-omap2/clockdomains.h            |   30 +++++++++--
 arch/arm/plat-omap/include/mach/powerdomain.h |    4 +
 4 files changed, 106 insertions(+), 47 deletions(-)

diff --git a/arch/arm/mach-omap2/clock24xx.h b/arch/arm/mach-omap2/clock24xx.h
index 68e3667..50c3e01 100644
--- a/arch/arm/mach-omap2/clock24xx.h
+++ b/arch/arm/mach-omap2/clock24xx.h
@@ -633,7 +633,7 @@ static struct clk func_32k_ck = {
 	.rate		= 32000,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				RATE_FIXED | ALWAYS_ENABLED | RATE_PROPAGATES,
-	.clkdm		= { .name = "wkup_clkdm" },
+	.clkdm		= { .name = "prm_clkdm" },
 	.recalc		= &propagate_rate,
 };
 
@@ -642,7 +642,7 @@ static struct clk osc_ck = {		/* (*12, *13, 19.2, *26, 38.4)MHz */
 	.name		= "osc_ck",
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				RATE_PROPAGATES,
-	.clkdm		= { .name = "wkup_clkdm" },
+	.clkdm		= { .name = "prm_clkdm" },
 	.enable		= &omap2_enable_osc_ck,
 	.disable	= &omap2_disable_osc_ck,
 	.recalc		= &omap2_osc_clk_recalc,
@@ -654,7 +654,7 @@ static struct clk sys_ck = {		/* (*12, *13, 19.2, 26, 38.4)MHz */
 	.parent		= &osc_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				ALWAYS_ENABLED | RATE_PROPAGATES,
-	.clkdm		= { .name = "wkup_clkdm" },
+	.clkdm		= { .name = "prm_clkdm" },
 	.recalc		= &omap2_sys_clk_recalc,
 };
 
@@ -663,7 +663,7 @@ static struct clk alt_ck = {		/* Typical 54M or 48M, may not exist */
 	.rate		= 54000000,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				RATE_FIXED | ALWAYS_ENABLED | RATE_PROPAGATES,
-	.clkdm		= { .name = "wkup_clkdm" },
+	.clkdm		= { .name = "prm_clkdm" },
 	.recalc		= &propagate_rate,
 };
 
@@ -695,7 +695,7 @@ static struct clk dpll_ck = {
 	.dpll_data	= &dpll_dd,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				RATE_PROPAGATES | ALWAYS_ENABLED,
-	.clkdm		= { .name = "wkup_clkdm" },
+	.clkdm		= { .name = "prm_clkdm" },
 	.recalc		= &omap2_dpllcore_recalc,
 	.set_rate	= &omap2_reprogram_dpllcore,
 };
@@ -706,7 +706,7 @@ static struct clk apll96_ck = {
 	.rate		= 96000000,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				RATE_FIXED | RATE_PROPAGATES | ENABLE_ON_INIT,
-	.clkdm		= { .name = "wkup_clkdm" },
+	.clkdm		= { .name = "prm_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(PLL_MOD, CM_CLKEN),
 	.enable_bit	= OMAP24XX_EN_96M_PLL_SHIFT,
 	.enable		= &omap2_clk_fixed_enable,
@@ -720,7 +720,7 @@ static struct clk apll54_ck = {
 	.rate		= 54000000,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				RATE_FIXED | RATE_PROPAGATES | ENABLE_ON_INIT,
-	.clkdm		= { .name = "wkup_clkdm" },
+	.clkdm		= { .name = "prm_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(PLL_MOD, CM_CLKEN),
 	.enable_bit	= OMAP24XX_EN_54M_PLL_SHIFT,
 	.enable		= &omap2_clk_fixed_enable,
@@ -755,7 +755,7 @@ static struct clk func_54m_ck = {
 	.parent		= &apll54_ck,	/* can also be alt_clk */
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				RATE_PROPAGATES | PARENT_CONTROLS_CLOCK,
-	.clkdm		= { .name = "wkup_clkdm" },
+	.clkdm		= { .name = "cm_clkdm" },
 	.init		= &omap2_init_clksel_parent,
 	.clksel_reg	= _CM_REG_OFFSET(PLL_MOD, CM_CLKSEL1),
 	.clksel_mask	= OMAP24XX_54M_SOURCE,
@@ -768,7 +768,7 @@ static struct clk core_ck = {
 	.parent		= &dpll_ck,		/* can also be 32k */
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				ALWAYS_ENABLED | RATE_PROPAGATES,
-	.clkdm		= { .name = "wkup_clkdm" },
+	.clkdm		= { .name = "cm_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -795,7 +795,7 @@ static struct clk func_96m_ck = {
 	.parent		= &apll96_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				RATE_PROPAGATES | PARENT_CONTROLS_CLOCK,
-	.clkdm		= { .name = "wkup_clkdm" },
+	.clkdm		= { .name = "cm_clkdm" },
 	.init		= &omap2_init_clksel_parent,
 	.clksel_reg	= _CM_REG_OFFSET(PLL_MOD, CM_CLKSEL1),
 	.clksel_mask	= OMAP2430_96M_SOURCE,
@@ -828,7 +828,7 @@ static struct clk func_48m_ck = {
 	.parent		= &apll96_ck,	 /* 96M or Alt */
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				RATE_PROPAGATES | PARENT_CONTROLS_CLOCK,
-	.clkdm		= { .name = "wkup_clkdm" },
+	.clkdm		= { .name = "cm_clkdm" },
 	.init		= &omap2_init_clksel_parent,
 	.clksel_reg	= _CM_REG_OFFSET(PLL_MOD, CM_CLKSEL1),
 	.clksel_mask	= OMAP24XX_48M_SOURCE,
@@ -844,15 +844,16 @@ static struct clk func_12m_ck = {
 	.fixed_div	= 4,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				RATE_PROPAGATES | PARENT_CONTROLS_CLOCK,
-	.clkdm		= { .name = "wkup_clkdm" },
+	.clkdm		= { .name = "cm_clkdm" },
 	.recalc		= &omap2_fixed_divisor_recalc,
 };
 
 /* Secure timer, only available in secure mode */
 static struct clk wdt1_osc_ck = {
-	.name		= "ck_wdt1_osc",
+	.name		= "wdt1_osc_ck",
 	.parent		= &osc_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.clkdm		= { .name = "prm_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -897,7 +898,7 @@ static struct clk sys_clkout_src = {
 	.parent		= &func_54m_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				RATE_PROPAGATES | OFFSET_GR_MOD,
-	.clkdm		= { .name = "wkup_clkdm" },
+	.clkdm		= { .name = "prm_clkdm" },
 	.enable_reg	= _GR_MOD_OFFSET(OMAP24XX_PRCM_CLKOUT_CTRL_OFFSET),
 	.enable_bit	= OMAP24XX_CLKOUT_EN_SHIFT,
 	.init		= &omap2_init_clksel_parent,
@@ -928,7 +929,7 @@ static struct clk sys_clkout = {
 	.parent		= &sys_clkout_src,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				PARENT_CONTROLS_CLOCK | OFFSET_GR_MOD,
-	.clkdm		= { .name = "wkup_clkdm" },
+	.clkdm		= { .name = "prm_clkdm" },
 	.clksel_reg	= _GR_MOD_OFFSET(OMAP24XX_PRCM_CLKOUT_CTRL_OFFSET),
 	.clksel_mask	= OMAP24XX_CLKOUT_DIV_MASK,
 	.clksel		= sys_clkout_clksel,
@@ -942,7 +943,7 @@ static struct clk sys_clkout2_src = {
 	.name		= "sys_clkout2_src",
 	.parent		= &func_54m_ck,
 	.flags		= CLOCK_IN_OMAP242X | RATE_PROPAGATES | OFFSET_GR_MOD,
-	.clkdm		= { .name = "wkup_clkdm" },
+	.clkdm		= { .name = "cm_clkdm" },
 	.enable_reg	= _GR_MOD_OFFSET(OMAP24XX_PRCM_CLKOUT_CTRL_OFFSET),
 	.enable_bit	= OMAP2420_CLKOUT2_EN_SHIFT,
 	.init		= &omap2_init_clksel_parent,
@@ -965,7 +966,7 @@ static struct clk sys_clkout2 = {
 	.parent		= &sys_clkout2_src,
 	.flags		= CLOCK_IN_OMAP242X | PARENT_CONTROLS_CLOCK |
 				OFFSET_GR_MOD,
-	.clkdm		= { .name = "wkup_clkdm" },
+	.clkdm		= { .name = "cm_clkdm" },
 	.clksel_reg	= _GR_MOD_OFFSET(OMAP24XX_PRCM_CLKOUT_CTRL_OFFSET),
 	.clksel_mask	= OMAP2420_CLKOUT2_DIV_MASK,
 	.clksel		= sys_clkout2_clksel,
@@ -978,7 +979,7 @@ static struct clk emul_ck = {
 	.name		= "emul_ck",
 	.parent		= &func_54m_ck,
 	.flags		= CLOCK_IN_OMAP242X | OFFSET_GR_MOD,
-	.clkdm		= { .name = "wkup_clkdm" },
+	.clkdm		= { .name = "cm_clkdm" },
 	.enable_reg	= _GR_MOD_OFFSET(OMAP24XX_PRCM_CLKEMUL_CTRL_OFFSET),
 	.enable_bit	= OMAP24XX_EMULATION_EN_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2077,27 +2078,29 @@ static struct clk gpios_fck = {
 	.name		= "gpios_fck",
 	.parent		= &func_32k_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.clkdm		= { .name = "wkup_clkdm" },
+	.clkdm		= { .name = "prm_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(WKUP_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP24XX_EN_GPIOS_SHIFT,
 	.recalc		= &followparent_recalc,
 };
 
+/* aka WDT2 - REVISIT: we should split wu_l4_iclk from l4_ck */
 static struct clk mpu_wdt_ick = {
 	.name		= "mpu_wdt_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.clkdm		= { .name = "core_l4_clkdm" },
+	.clkdm		= { .name = "prm_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(WKUP_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP24XX_EN_MPU_WDT_SHIFT,
 	.recalc		= &followparent_recalc,
 };
 
+/* aka WDT2 */
 static struct clk mpu_wdt_fck = {
 	.name		= "mpu_wdt_fck",
 	.parent		= &func_32k_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.clkdm		= { .name = "wkup_clkdm" },
+	.clkdm		= { .name = "prm_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(WKUP_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP24XX_EN_MPU_WDT_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2114,11 +2117,12 @@ static struct clk sync_32k_ick = {
 	.recalc		= &followparent_recalc,
 };
 
+/* REVISIT: parent is really wu_l4_iclk */
 static struct clk wdt1_ick = {
 	.name		= "wdt1_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.clkdm		= { .name = "core_l4_clkdm" },
+	.clkdm		= { .name = "prm_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(WKUP_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP24XX_EN_WDT1_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2652,6 +2656,7 @@ static struct clk virt_prcm_set = {
 	.name		= "virt_prcm_set",
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				VIRTUAL_CLOCK | ALWAYS_ENABLED | DELAYED_APP,
+	.clkdm		= { .name = "virt_opp_clkdm" },
 	.parent		= &mpu_ck,	/* Indexed by mpu speed, no parent */
 	.recalc		= &omap2_table_mpu_recalc,	/* sets are keyed on mpu rate */
 	.set_rate	= &omap2_select_table_rate,
diff --git a/arch/arm/mach-omap2/clock34xx.h b/arch/arm/mach-omap2/clock34xx.h
index 147a8b2..ca432e0 100644
--- a/arch/arm/mach-omap2/clock34xx.h
+++ b/arch/arm/mach-omap2/clock34xx.h
@@ -70,6 +70,7 @@ static struct clk omap_32k_fck = {
 	.rate		= 32768,
 	.flags		= CLOCK_IN_OMAP343X | RATE_FIXED | RATE_PROPAGATES |
 				ALWAYS_ENABLED,
+	.clkdm		= { .name = "prm_clkdm" },
 	.recalc		= &propagate_rate,
 };
 
@@ -78,6 +79,7 @@ static struct clk secure_32k_fck = {
 	.rate		= 32768,
 	.flags		= CLOCK_IN_OMAP343X | RATE_FIXED | RATE_PROPAGATES |
 				ALWAYS_ENABLED,
+	.clkdm		= { .name = "prm_clkdm" },
 	.recalc		= &propagate_rate,
 };
 
@@ -87,6 +89,7 @@ static struct clk virt_12m_ck = {
 	.rate		= 12000000,
 	.flags		= CLOCK_IN_OMAP343X | RATE_FIXED | RATE_PROPAGATES |
 				ALWAYS_ENABLED,
+	.clkdm		= { .name = "prm_clkdm" },
 	.recalc		= &propagate_rate,
 };
 
@@ -95,6 +98,7 @@ static struct clk virt_13m_ck = {
 	.rate		= 13000000,
 	.flags		= CLOCK_IN_OMAP343X | RATE_FIXED | RATE_PROPAGATES |
 				ALWAYS_ENABLED,
+	.clkdm		= { .name = "prm_clkdm" },
 	.recalc		= &propagate_rate,
 };
 
@@ -103,6 +107,7 @@ static struct clk virt_16_8m_ck = {
 	.rate		= 16800000,
 	.flags		= CLOCK_IN_OMAP3430ES2 | RATE_FIXED | RATE_PROPAGATES |
 				ALWAYS_ENABLED,
+	.clkdm		= { .name = "prm_clkdm" },
 	.recalc		= &propagate_rate,
 };
 
@@ -111,6 +116,7 @@ static struct clk virt_19_2m_ck = {
 	.rate		= 19200000,
 	.flags		= CLOCK_IN_OMAP343X | RATE_FIXED | RATE_PROPAGATES |
 				ALWAYS_ENABLED,
+	.clkdm		= { .name = "prm_clkdm" },
 	.recalc		= &propagate_rate,
 };
 
@@ -119,6 +125,7 @@ static struct clk virt_26m_ck = {
 	.rate		= 26000000,
 	.flags		= CLOCK_IN_OMAP343X | RATE_FIXED | RATE_PROPAGATES |
 				ALWAYS_ENABLED,
+	.clkdm		= { .name = "prm_clkdm" },
 	.recalc		= &propagate_rate,
 };
 
@@ -127,6 +134,7 @@ static struct clk virt_38_4m_ck = {
 	.rate		= 38400000,
 	.flags		= CLOCK_IN_OMAP343X | RATE_FIXED | RATE_PROPAGATES |
 				ALWAYS_ENABLED,
+	.clkdm		= { .name = "prm_clkdm" },
 	.recalc		= &propagate_rate,
 };
 
@@ -181,6 +189,7 @@ static struct clk osc_sys_ck = {
 	/* REVISIT: deal with autoextclkmode? */
 	.flags		= CLOCK_IN_OMAP343X | RATE_FIXED | RATE_PROPAGATES |
 				ALWAYS_ENABLED,
+	.clkdm		= { .name = "prm_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -205,19 +214,26 @@ static struct clk sys_ck = {
 	.clksel_mask	= OMAP_SYSCLKDIV_MASK,
 	.clksel		= sys_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | ALWAYS_ENABLED,
+	.clkdm		= { .name = "prm_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
 
 static struct clk sys_altclk = {
 	.name		= "sys_altclk",
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | ALWAYS_ENABLED,
+	.clkdm		= { .name = "cm_clkdm" },
 	.recalc		= &propagate_rate,
 };
 
-/* Optional external clock input for some McBSPs */
+/*
+ * Optional external clock input for some McBSPs
+ * Apparently this is not really in prm_clkdm, but rather is fed into
+ * both CORE and PER separately.
+ */
 static struct clk mcbsp_clks = {
 	.name		= "mcbsp_clks",
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | ALWAYS_ENABLED,
+	.clkdm		= { .name = "prm_clkdm" },
 	.recalc		= &propagate_rate,
 };
 
@@ -229,6 +245,7 @@ static struct clk sys_clkout1 = {
 	.enable_reg	= OMAP3430_PRM_CLKOUT_CTRL,
 	.enable_bit	= OMAP3430_CLKOUT_EN_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm		= { .name = "prm_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -509,6 +526,7 @@ static struct clk core_ck = {
 	.clksel		= core_ck_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
 				PARENT_CONTROLS_CLOCK,
+	.clkdm		= { .name = "cm_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -673,6 +691,7 @@ static struct clk omap_96m_alwon_fck = {
 	.clksel		= omap_96m_alwon_fck_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
 				PARENT_CONTROLS_CLOCK,
+	.clkdm		= { .name = "prm_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -681,6 +700,7 @@ static struct clk cm_96m_fck = {
 	.parent		= &omap_96m_alwon_fck,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
 				PARENT_CONTROLS_CLOCK,
+	.clkdm		= { .name = "cm_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -709,6 +729,7 @@ static struct clk omap_96m_fck = {
 	.clksel		= omap_96m_fck_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
 				PARENT_CONTROLS_CLOCK,
+	.clkdm		= { .name = "cm_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -751,6 +772,7 @@ static struct clk virt_omap_54m_fck = {
 	.clksel		= virt_omap_54m_fck_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
 				PARENT_CONTROLS_CLOCK,
+	.clkdm		= { .name = "cm_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -778,6 +800,7 @@ static struct clk omap_54m_fck = {
 	.clksel		= omap_54m_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
 				PARENT_CONTROLS_CLOCK,
+	.clkdm		= { .name = "cm_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -805,6 +828,7 @@ static struct clk omap_48m_fck = {
 	.clksel		= omap_48m_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
 				PARENT_CONTROLS_CLOCK,
+	.clkdm		= { .name = "cm_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -814,6 +838,7 @@ static struct clk omap_12m_fck = {
 	.fixed_div	= 4,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
 				PARENT_CONTROLS_CLOCK,
+	.clkdm		= { .name = "cm_clkdm" },
 	.recalc		= &omap2_fixed_divisor_recalc,
 };
 
@@ -1007,6 +1032,7 @@ static struct clk clkout2_src_ck = {
 	.clksel_mask	= OMAP3430_CLKOUT2SOURCE_MASK,
 	.clksel		= clkout2_src_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES,
+	.clkdm		= { .name = "cm_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -1031,6 +1057,7 @@ static struct clk sys_clkout2 = {
 	.clksel_mask	= OMAP3430_CLKOUT2_DIV_MASK,
 	.clksel		= sys_clkout2_clksel,
 	.flags		= CLOCK_IN_OMAP343X | PARENT_CONTROLS_CLOCK,
+	.clkdm		= { .name = "cm_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -1041,6 +1068,7 @@ static struct clk corex2_fck = {
 	.parent		= &dpll3_m2x2_ck,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
 				PARENT_CONTROLS_CLOCK,
+	.clkdm		= { .name = "cm_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -1051,10 +1079,6 @@ static const struct clksel div2_core_clksel[] = {
 	{ .parent = NULL }
 };
 
-/*
- * REVISIT: Are these in DPLL power domain or CM power domain? docs
- * may be inconsistent here?
- */
 static struct clk dpll1_fck = {
 	.name		= "dpll1_fck",
 	.parent		= &core_ck,
@@ -1064,6 +1088,7 @@ static struct clk dpll1_fck = {
 	.clksel		= div2_core_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
 				PARENT_CONTROLS_CLOCK,
+	.clkdm		= { .name = "cm_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -1139,6 +1164,7 @@ static struct clk dpll2_fck = {
 	.clksel		= div2_core_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
 				PARENT_CONTROLS_CLOCK,
+	.clkdm		= { .name = "cm_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -1217,6 +1243,7 @@ static struct clk rm_ick = {
 	.clksel_mask	= OMAP3430_CLKSEL_RM_MASK,
 	.clksel		= div2_l4_clksel,
 	.flags		= CLOCK_IN_OMAP343X | PARENT_CONTROLS_CLOCK,
+	.clkdm		= { .name = "cm_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -1380,6 +1407,7 @@ static struct clk cpefuse_fck = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, OMAP3430ES2_CM_FCLKEN3),
 	.enable_bit	= OMAP3430ES2_EN_CPEFUSE_SHIFT,
 	.flags		= CLOCK_IN_OMAP3430ES2,
+	.clkdm		= { .name = "cm_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -2138,7 +2166,7 @@ static struct clk dss_tv_fck = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_DSS_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_EN_TV_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm		= { .name = "dss_clkdm" },
+	.clkdm		= { .name = "dss_clkdm" }, /* XXX: in cm_clkdm? */
 	.recalc		= &followparent_recalc,
 };
 
@@ -2292,6 +2320,7 @@ static struct clk usim_fck = {
 	.clksel_mask	= OMAP3430ES2_CLKSEL_USIMOCP_MASK,
 	.clksel		= usim_clksel,
 	.flags		= CLOCK_IN_OMAP3430ES2,
+	.clkdm		= { .name = "prm_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -2305,7 +2334,7 @@ static struct clk gpt1_fck = {
 	.clksel_mask	= OMAP3430_CLKSEL_GPT1_MASK,
 	.clksel		= omap343x_gpt_clksel,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm		= { .name = "wkup_clkdm" },
+	.clkdm		= { .name = "prm_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -2314,7 +2343,7 @@ static struct clk wkup_32k_fck = {
 	.init		= &omap2_init_clk_clkdm,
 	.parent		= &omap_32k_fck,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | ALWAYS_ENABLED,
-	.clkdm		= { .name = "wkup_clkdm" },
+	.clkdm		= { .name = "prm_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -2324,7 +2353,7 @@ static struct clk gpio1_dbck = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(WKUP_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_EN_GPIO1_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm		= { .name = "wkup_clkdm" },
+	.clkdm		= { .name = "prm_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -2334,7 +2363,7 @@ static struct clk wdt2_fck = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(WKUP_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_EN_WDT2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm		= { .name = "wkup_clkdm" },
+	.clkdm		= { .name = "prm_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -2342,7 +2371,7 @@ static struct clk wkup_l4_ick = {
 	.name		= "wkup_l4_ick",
 	.parent		= &sys_ck,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | ALWAYS_ENABLED,
-	.clkdm		= { .name = "wkup_clkdm" },
+	.clkdm		= { .name = "prm_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -2354,7 +2383,7 @@ static struct clk usim_ick = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(WKUP_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430ES2_EN_USIMOCP_SHIFT,
 	.flags		= CLOCK_IN_OMAP3430ES2,
-	.clkdm		= { .name = "wkup_clkdm" },
+	.clkdm		= { .name = "prm_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -2364,7 +2393,7 @@ static struct clk wdt2_ick = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(WKUP_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_WDT2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm		= { .name = "wkup_clkdm" },
+	.clkdm		= { .name = "prm_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -2374,7 +2403,7 @@ static struct clk wdt1_ick = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(WKUP_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_WDT1_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm		= { .name = "wkup_clkdm" },
+	.clkdm		= { .name = "prm_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -2384,7 +2413,7 @@ static struct clk gpio1_ick = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(WKUP_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_GPIO1_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm		= { .name = "wkup_clkdm" },
+	.clkdm		= { .name = "prm_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -2394,18 +2423,17 @@ static struct clk omap_32ksync_ick = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(WKUP_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_32KSYNC_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm		= { .name = "wkup_clkdm" },
+	.clkdm		= { .name = "prm_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
-/* XXX This clock no longer exists in 3430 TRM rev F */
 static struct clk gpt12_ick = {
 	.name		= "gpt12_ick",
 	.parent		= &wkup_l4_ick,
 	.enable_reg	= _OMAP34XX_CM_REGADDR(WKUP_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_GPT12_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm		= { .name = "wkup_clkdm" },
+	.clkdm		= { .name = "prm_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -2415,7 +2443,7 @@ static struct clk gpt1_ick = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(WKUP_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_GPT1_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm		= { .name = "wkup_clkdm" },
+	.clkdm		= { .name = "prm_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -3019,6 +3047,7 @@ static struct clk sr1_fck = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(WKUP_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_EN_SR1_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES,
+	.clkdm		= { .name = "prm_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -3029,6 +3058,7 @@ static struct clk sr2_fck = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(WKUP_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_EN_SR2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES,
+	.clkdm		= { .name = "prm_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -3047,6 +3077,7 @@ static struct clk gpt12_fck = {
 	.name		= "gpt12_fck",
 	.parent		= &secure_32k_fck,
 	.flags		= CLOCK_IN_OMAP343X | ALWAYS_ENABLED,
+	.clkdm		= { .name = "prm_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -3054,6 +3085,7 @@ static struct clk wdt1_fck = {
 	.name		= "wdt1_fck",
 	.parent		= &secure_32k_fck,
 	.flags		= CLOCK_IN_OMAP343X | ALWAYS_ENABLED,
+	.clkdm		= { .name = "prm_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
diff --git a/arch/arm/mach-omap2/clockdomains.h b/arch/arm/mach-omap2/clockdomains.h
index e17c369..e8320ee 100644
--- a/arch/arm/mach-omap2/clockdomains.h
+++ b/arch/arm/mach-omap2/clockdomains.h
@@ -14,15 +14,35 @@
 
 /*
  * OMAP2/3-common clockdomains
+ *
+ * Even though the 2420 has a single PRCM module from the
+ * interconnect's perspective, internally it does appear to have
+ * separate PRM and CM clockdomains.  The usual test case is
+ * sys_clkout/sys_clkout2.
  */
 
-/* This is an implicit clockdomain - it is never defined as such in TRM */
-static struct clockdomain wkup_clkdm = {
-	.name		= "wkup_clkdm",
+static struct clockdomain prm_clkdm = {
+	.name		= "prm_clkdm",
 	.pwrdm		= { .name = "wkup_pwrdm" },
 	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP24XX | CHIP_IS_OMAP3430),
 };
 
+static struct clockdomain cm_clkdm = {
+	.name		= "cm_clkdm",
+	.pwrdm		= { .name = "core_pwrdm" },
+	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP24XX | CHIP_IS_OMAP3430),
+};
+
+/*
+ * virt_opp_clkdm is intended solely for use with virtual OPP clocks,
+ * e.g., virt_prcm_set, until OPP handling is rationalized.
+ */
+static struct clockdomain virt_opp_clkdm = {
+	.name		= "virt_opp_clkdm",
+	.pwrdm		= { .name = "wkup_pwrdm" },
+	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP24XX),
+};
+
 /*
  * 2420-only clockdomains
  */
@@ -265,7 +285,9 @@ static struct clkdm_pwrdm_autodep clkdm_pwrdm_autodeps[] = {
 
 static struct clockdomain *clockdomains_omap[] = {
 
-	&wkup_clkdm,
+	&cm_clkdm,
+	&prm_clkdm,
+	&virt_opp_clkdm,
 
 #ifdef CONFIG_ARCH_OMAP2420
 	&mpu_2420_clkdm,
diff --git a/arch/arm/plat-omap/include/mach/powerdomain.h b/arch/arm/plat-omap/include/mach/powerdomain.h
index 4948cb7..69c9e67 100644
--- a/arch/arm/plat-omap/include/mach/powerdomain.h
+++ b/arch/arm/plat-omap/include/mach/powerdomain.h
@@ -50,9 +50,9 @@
 
 /*
  * Maximum number of clockdomains that can be associated with a powerdomain.
- * CORE powerdomain is probably the worst case.
+ * CORE powerdomain on OMAP3 is the worst case
  */
-#define PWRDM_MAX_CLKDMS	3
+#define PWRDM_MAX_CLKDMS	4
 
 /* XXX A completely arbitrary number. What is reasonable here? */
 #define PWRDM_TRANSITION_BAILOUT 100000


