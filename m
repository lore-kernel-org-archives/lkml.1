Return-Path: <linux-kernel-owner+w=401wt.eu-S1759159AbZA1Umv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759159AbZA1Umv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 15:42:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752006AbZA1Ua3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:30:29 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:32997 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754694AbZA1UaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:30:14 -0500
MBOX-Line: From nobody Tue Jan 27 19:13:16 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH A 09/10] OMAP2/3: Remove OMAP_PRM_REGADDR, OMAP_CM_REGADDR
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Cc: Tony Lindgren <tony@atomide.com>, Paul Walmsley <paul@pwsan.com>,
       linux-omap@vger.kernel.org
Date: Tue, 27 Jan 2009 19:13:16 -0700
Message-ID: <20090128021312.7244.2415.stgit@localhost.localdomain>
In-Reply-To: <20090128020447.7244.80496.stgit@localhost.localdomain>
References: <20090128020447.7244.80496.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

Remove OMAP_PRM_REGADDR and OMAP_CM_REGADDR.  Use
prm_read/write_mod_reg() or cm_read/write_mod_reg() instead.  For
assembly, use OMAPXXXX_PRM_REGADDR or OMAPXXXX_CM_REGADDR macros.

linux-omap source commits are 158e5d7128ed806b5b4eec0839e73727fa7a1f8a and
84029a1dee973d8037e67d4cd02acb833f6b9b97.

Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Paul Walmsley <paul@pwsan.com>
---
 arch/arm/mach-omap2/clock.c              |   22 +-
 arch/arm/mach-omap2/clock24xx.c          |   87 ++++--
 arch/arm/mach-omap2/clock24xx.h          |  322 ++++++++++++-----------
 arch/arm/mach-omap2/clock34xx.h          |  420 +++++++++++++++---------------
 arch/arm/mach-omap2/cm-regbits-34xx.h    |    7 +
 arch/arm/mach-omap2/cm.h                 |   17 -
 arch/arm/mach-omap2/memory.c             |    3 
 arch/arm/mach-omap2/prm-regbits-34xx.h   |    9 +
 arch/arm/mach-omap2/prm.h                |  166 +++++-------
 arch/arm/mach-omap2/sram242x.S           |    5 
 arch/arm/mach-omap2/sram243x.S           |    5 
 arch/arm/plat-omap/common.c              |    1 
 arch/arm/plat-omap/include/mach/clock.h  |    3 
 arch/arm/plat-omap/include/mach/common.h |    5 
 14 files changed, 570 insertions(+), 502 deletions(-)

diff --git a/arch/arm/mach-omap2/clock.c b/arch/arm/mach-omap2/clock.c
index c4b80a4..55c5d67 100644
--- a/arch/arm/mach-omap2/clock.c
+++ b/arch/arm/mach-omap2/clock.c
@@ -27,6 +27,7 @@
 #include <mach/clock.h>
 #include <mach/clockdomain.h>
 #include <mach/cpu.h>
+#include <mach/prcm.h>
 #include <asm/div64.h>
 
 #include "memory.h"
@@ -247,9 +248,9 @@ static void omap2_clk_wait_ready(struct clk *clk)
 	/* REVISIT: What are the appropriate exclusions for 34XX? */
 	/* OMAP3: ignore DSS-mod clocks */
 	if (cpu_is_omap34xx() &&
-	    (((u32)reg & ~0xff) == (u32)OMAP_CM_REGADDR(OMAP3430_DSS_MOD, 0) ||
-	     ((((u32)reg & ~0xff) == (u32)OMAP_CM_REGADDR(CORE_MOD, 0)) &&
-	     clk->enable_bit == OMAP3430_EN_SSI_SHIFT)))
+	    (((u32)reg & ~0xff) == cm_read_mod_reg(OMAP3430_DSS_MOD, 0) ||
+	     ((((u32)reg & ~0xff) == cm_read_mod_reg(CORE_MOD, 0)) &&
+	      clk->enable_bit == OMAP3430_EN_SSI_SHIFT)))
 		return;
 
 	/* Check if both functional and interface clocks
@@ -632,8 +633,9 @@ u32 omap2_clksel_get_divisor(struct clk *clk)
 
 int omap2_clksel_set_rate(struct clk *clk, unsigned long rate)
 {
-	u32 field_mask, field_val, reg_val, validrate, new_div = 0;
+	u32 field_mask, field_val, validrate, new_div = 0;
 	void __iomem *div_addr;
+	u32 v;
 
 	validrate = omap2_clksel_round_rate_div(clk, rate, &new_div);
 	if (validrate != rate)
@@ -647,10 +649,11 @@ int omap2_clksel_set_rate(struct clk *clk, unsigned long rate)
 	if (field_val == ~0)
 		return -EINVAL;
 
-	reg_val = __raw_readl(div_addr);
-	reg_val &= ~field_mask;
-	reg_val |= (field_val << __ffs(field_mask));
-	__raw_writel(reg_val, div_addr);
+	v = __raw_readl(div_addr);
+	v &= ~field_mask;
+	v |= field_val << __ffs(field_mask);
+	__raw_writel(v, div_addr);
+
 	wmb();
 
 	clk->rate = clk->parent->rate / new_div;
@@ -753,7 +756,8 @@ int omap2_clk_set_parent(struct clk *clk, struct clk *new_parent)
 	wmb();
 
 	if (clk->flags & DELAYED_APP && cpu_is_omap24xx()) {
-		__raw_writel(OMAP24XX_VALID_CONFIG, OMAP24XX_PRCM_CLKCFG_CTRL);
+		prm_write_mod_reg(OMAP24XX_VALID_CONFIG,
+			OMAP24XX_GR_MOD, OMAP24XX_PRCM_CLKCFG_CTRL_OFFSET);
 		wmb();
 	}
 
diff --git a/arch/arm/mach-omap2/clock24xx.c b/arch/arm/mach-omap2/clock24xx.c
index 59b1fb2..133c36f 100644
--- a/arch/arm/mach-omap2/clock24xx.c
+++ b/arch/arm/mach-omap2/clock24xx.c
@@ -28,8 +28,10 @@
 #include <linux/cpufreq.h>
 #include <linux/bitops.h>
 
+#include <mach/common.h>
 #include <mach/clock.h>
 #include <mach/sram.h>
+
 #include <asm/div64.h>
 
 #include "memory.h"
@@ -76,42 +78,23 @@ static u32 omap2_get_dpll_rate_24xx(struct clk *tclk)
 
 static int omap2_enable_osc_ck(struct clk *clk)
 {
-	u32 pcc;
-
-	pcc = __raw_readl(OMAP24XX_PRCM_CLKSRC_CTRL);
-
-	__raw_writel(pcc & ~OMAP_AUTOEXTCLKMODE_MASK,
-		      OMAP24XX_PRCM_CLKSRC_CTRL);
+	prm_rmw_mod_reg_bits(OMAP_AUTOEXTCLKMODE_MASK, 0,
+			OMAP24XX_GR_MOD, OMAP24XX_PRCM_CLKSRC_CTRL_OFFSET);
 
 	return 0;
 }
 
 static void omap2_disable_osc_ck(struct clk *clk)
 {
-	u32 pcc;
-
-	pcc = __raw_readl(OMAP24XX_PRCM_CLKSRC_CTRL);
-
-	__raw_writel(pcc | OMAP_AUTOEXTCLKMODE_MASK,
-		      OMAP24XX_PRCM_CLKSRC_CTRL);
-}
-
-#ifdef OLD_CK
-/* Recalculate SYST_CLK */
-static void omap2_sys_clk_recalc(struct clk * clk)
-{
-	u32 div = PRCM_CLKSRC_CTRL;
-	div &= (1 << 7) | (1 << 6);	/* Test if ext clk divided by 1 or 2 */
-	div >>= clk->rate_offset;
-	clk->rate = (clk->parent->rate / div);
-	propagate_rate(clk);
+	prm_rmw_mod_reg_bits(OMAP_AUTOEXTCLKMODE_MASK, OMAP_AUTOEXTCLKMODE_MASK,
+			OMAP24XX_GR_MOD, OMAP24XX_PRCM_CLKSRC_CTRL_OFFSET);
 }
-#endif	/* OLD_CK */
 
 /* Enable an APLL if off */
 static int omap2_clk_fixed_enable(struct clk *clk)
 {
 	u32 cval, apll_mask;
+	void __iomem *idlest;
 
 	apll_mask = EN_APLL_LOCKED << clk->enable_bit;
 
@@ -129,8 +112,14 @@ static int omap2_clk_fixed_enable(struct clk *clk)
 	else if (clk == &apll54_ck)
 		cval = OMAP24XX_ST_54M_APLL;
 
-	omap2_wait_clock_ready(OMAP_CM_REGADDR(PLL_MOD, CM_IDLEST), cval,
-			    clk->name);
+	if (cpu_is_omap242x())
+		idlest = (__force void __iomem *)OMAP2420_CM_REGADDR(PLL_MOD,
+								CM_IDLEST);
+	else
+		idlest = (__force void __iomem *)OMAP2430_CM_REGADDR(PLL_MOD,
+								CM_IDLEST);
+
+	omap2_wait_clock_ready(idlest, cval, clk->name);
 
 	/*
 	 * REVISIT: Should we return an error code if omap2_wait_clock_ready()
@@ -420,7 +409,8 @@ static u32 omap2_get_sysclkdiv(void)
 {
 	u32 div;
 
-	div = __raw_readl(OMAP24XX_PRCM_CLKSRC_CTRL);
+	div = prm_read_mod_reg(OMAP24XX_GR_MOD,
+				OMAP24XX_PRCM_CLKSRC_CTRL_OFFSET);
 	div &= OMAP_SYSCLKDIV_MASK;
 	div >>= OMAP_SYSCLKDIV_SHIFT;
 
@@ -476,6 +466,37 @@ static int __init omap2_clk_arch_init(void)
 }
 arch_initcall(omap2_clk_arch_init);
 
+static u32 prm_base;
+static u32 cm_base;
+
+/*
+ * Since we share clock data for 242x and 243x, we need to rewrite some
+ * some register base offsets. Assume offset is at prm_base if flagged,
+ * else assume it's cm_base.
+ */
+static inline void omap2_clk_check_reg(u32 flags, void __iomem **reg)
+{
+	u32 tmp = (__force u32)*reg;
+
+	if ((tmp >> 24) != 0)
+		return;
+
+	if (flags & OFFSET_GR_MOD)
+		tmp += prm_base;
+	else
+		tmp += cm_base;
+
+	*reg = (__force void __iomem *)tmp;
+}
+
+void __init omap2_clk_rewrite_base(struct clk *clk)
+{
+	omap2_clk_check_reg(clk->flags, &clk->clksel_reg);
+	omap2_clk_check_reg(clk->flags, &clk->enable_reg);
+	if (clk->dpll_data)
+		omap2_clk_check_reg(0, &clk->dpll_data->mult_div1_reg);
+}
+
 int __init omap2_clk_init(void)
 {
 	struct prcm_config *prcm;
@@ -487,6 +508,12 @@ int __init omap2_clk_init(void)
 	else if (cpu_is_omap2430())
 		cpu_mask = RATE_IN_243X;
 
+	for (clkp = onchip_24xx_clks;
+	     clkp < onchip_24xx_clks + ARRAY_SIZE(onchip_24xx_clks);
+	     clkp++) {
+			omap2_clk_rewrite_base(*clkp);
+	}
+
 	clk_init(&omap2_clk_functions);
 
 	omap2_osc_clk_recalc(&osc_ck);
@@ -538,3 +565,9 @@ int __init omap2_clk_init(void)
 
 	return 0;
 }
+
+void __init omap2_set_globals_clock24xx(struct omap_globals *omap2_globals)
+{
+	prm_base = (__force u32)omap2_globals->prm;
+	cm_base = (__force u32)omap2_globals->cm;
+}
diff --git a/arch/arm/mach-omap2/clock24xx.h b/arch/arm/mach-omap2/clock24xx.h
index f8bed57..2bf16ee 100644
--- a/arch/arm/mach-omap2/clock24xx.h
+++ b/arch/arm/mach-omap2/clock24xx.h
@@ -600,6 +600,13 @@ static struct prcm_config rate_table[] = {
 	{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
 };
 
+/*
+ * Since 2420 and 2430 have different cm_base, we use offsets only here.
+ * Clock code will rewrite the register address as needed.
+ */
+#define _CM_REG_OFFSET(module, reg)	((void __iomem *)(module) + (reg))
+#define _GR_MOD_OFFSET(reg)	((void __iomem *)(OMAP24XX_GR_MOD + (reg)))
+
 /*-------------------------------------------------------------------------
  * 24xx clock tree.
  *
@@ -670,7 +677,7 @@ static struct clk alt_ck = {		/* Typical 54M or 48M, may not exist */
  */
 
 static struct dpll_data dpll_dd = {
-	.mult_div1_reg		= OMAP_CM_REGADDR(PLL_MOD, CM_CLKSEL1),
+	.mult_div1_reg		= _CM_REG_OFFSET(PLL_MOD, CM_CLKSEL1),
 	.mult_mask		= OMAP24XX_DPLL_MULT_MASK,
 	.div1_mask		= OMAP24XX_DPLL_DIV_MASK,
 	.max_multiplier		= 1024,
@@ -700,7 +707,7 @@ static struct clk apll96_ck = {
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				RATE_FIXED | RATE_PROPAGATES | ENABLE_ON_INIT,
 	.clkdm_name	= "wkup_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(PLL_MOD, CM_CLKEN),
+	.enable_reg	= _CM_REG_OFFSET(PLL_MOD, CM_CLKEN),
 	.enable_bit	= OMAP24XX_EN_96M_PLL_SHIFT,
 	.enable		= &omap2_clk_fixed_enable,
 	.disable	= &omap2_clk_fixed_disable,
@@ -714,7 +721,7 @@ static struct clk apll54_ck = {
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				RATE_FIXED | RATE_PROPAGATES | ENABLE_ON_INIT,
 	.clkdm_name	= "wkup_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(PLL_MOD, CM_CLKEN),
+	.enable_reg	= _CM_REG_OFFSET(PLL_MOD, CM_CLKEN),
 	.enable_bit	= OMAP24XX_EN_54M_PLL_SHIFT,
 	.enable		= &omap2_clk_fixed_enable,
 	.disable	= &omap2_clk_fixed_disable,
@@ -750,7 +757,7 @@ static struct clk func_54m_ck = {
 				RATE_PROPAGATES | PARENT_CONTROLS_CLOCK,
 	.clkdm_name	= "wkup_clkdm",
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= OMAP_CM_REGADDR(PLL_MOD, CM_CLKSEL1),
+	.clksel_reg	= _CM_REG_OFFSET(PLL_MOD, CM_CLKSEL1),
 	.clksel_mask	= OMAP24XX_54M_SOURCE,
 	.clksel		= func_54m_clksel,
 	.recalc		= &omap2_clksel_recalc,
@@ -790,7 +797,7 @@ static struct clk func_96m_ck = {
 				RATE_PROPAGATES | PARENT_CONTROLS_CLOCK,
 	.clkdm_name	= "wkup_clkdm",
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= OMAP_CM_REGADDR(PLL_MOD, CM_CLKSEL1),
+	.clksel_reg	= _CM_REG_OFFSET(PLL_MOD, CM_CLKSEL1),
 	.clksel_mask	= OMAP2430_96M_SOURCE,
 	.clksel		= func_96m_clksel,
 	.recalc		= &omap2_clksel_recalc,
@@ -823,7 +830,7 @@ static struct clk func_48m_ck = {
 				RATE_PROPAGATES | PARENT_CONTROLS_CLOCK,
 	.clkdm_name	= "wkup_clkdm",
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= OMAP_CM_REGADDR(PLL_MOD, CM_CLKSEL1),
+	.clksel_reg	= _CM_REG_OFFSET(PLL_MOD, CM_CLKSEL1),
 	.clksel_mask	= OMAP24XX_48M_SOURCE,
 	.clksel		= func_48m_clksel,
 	.recalc		= &omap2_clksel_recalc,
@@ -889,12 +896,12 @@ static struct clk sys_clkout_src = {
 	.name		= "sys_clkout_src",
 	.parent		= &func_54m_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
-				RATE_PROPAGATES,
+				RATE_PROPAGATES | OFFSET_GR_MOD,
 	.clkdm_name	= "wkup_clkdm",
-	.enable_reg	= OMAP24XX_PRCM_CLKOUT_CTRL,
+	.enable_reg	= _GR_MOD_OFFSET(OMAP24XX_PRCM_CLKOUT_CTRL_OFFSET),
 	.enable_bit	= OMAP24XX_CLKOUT_EN_SHIFT,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= OMAP24XX_PRCM_CLKOUT_CTRL,
+	.clksel_reg	= _GR_MOD_OFFSET(OMAP24XX_PRCM_CLKOUT_CTRL_OFFSET),
 	.clksel_mask	= OMAP24XX_CLKOUT_SOURCE_MASK,
 	.clksel		= common_clkout_src_clksel,
 	.recalc		= &omap2_clksel_recalc,
@@ -920,9 +927,9 @@ static struct clk sys_clkout = {
 	.name		= "sys_clkout",
 	.parent		= &sys_clkout_src,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
-				PARENT_CONTROLS_CLOCK,
+				PARENT_CONTROLS_CLOCK | OFFSET_GR_MOD,
 	.clkdm_name	= "wkup_clkdm",
-	.clksel_reg	= OMAP24XX_PRCM_CLKOUT_CTRL,
+	.clksel_reg	= _GR_MOD_OFFSET(OMAP24XX_PRCM_CLKOUT_CTRL_OFFSET),
 	.clksel_mask	= OMAP24XX_CLKOUT_DIV_MASK,
 	.clksel		= sys_clkout_clksel,
 	.recalc		= &omap2_clksel_recalc,
@@ -934,12 +941,12 @@ static struct clk sys_clkout = {
 static struct clk sys_clkout2_src = {
 	.name		= "sys_clkout2_src",
 	.parent		= &func_54m_ck,
-	.flags		= CLOCK_IN_OMAP242X | RATE_PROPAGATES,
+	.flags		= CLOCK_IN_OMAP242X | RATE_PROPAGATES | OFFSET_GR_MOD,
 	.clkdm_name	= "wkup_clkdm",
-	.enable_reg	= OMAP24XX_PRCM_CLKOUT_CTRL,
+	.enable_reg	= _GR_MOD_OFFSET(OMAP24XX_PRCM_CLKOUT_CTRL_OFFSET),
 	.enable_bit	= OMAP2420_CLKOUT2_EN_SHIFT,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= OMAP24XX_PRCM_CLKOUT_CTRL,
+	.clksel_reg	= _GR_MOD_OFFSET(OMAP24XX_PRCM_CLKOUT_CTRL_OFFSET),
 	.clksel_mask	= OMAP2420_CLKOUT2_SOURCE_MASK,
 	.clksel		= common_clkout_src_clksel,
 	.recalc		= &omap2_clksel_recalc,
@@ -956,9 +963,10 @@ static const struct clksel sys_clkout2_clksel[] = {
 static struct clk sys_clkout2 = {
 	.name		= "sys_clkout2",
 	.parent		= &sys_clkout2_src,
-	.flags		= CLOCK_IN_OMAP242X | PARENT_CONTROLS_CLOCK,
+	.flags		= CLOCK_IN_OMAP242X | PARENT_CONTROLS_CLOCK |
+				OFFSET_GR_MOD,
 	.clkdm_name	= "wkup_clkdm",
-	.clksel_reg	= OMAP24XX_PRCM_CLKOUT_CTRL,
+	.clksel_reg	= _GR_MOD_OFFSET(OMAP24XX_PRCM_CLKOUT_CTRL_OFFSET),
 	.clksel_mask	= OMAP2420_CLKOUT2_DIV_MASK,
 	.clksel		= sys_clkout2_clksel,
 	.recalc		= &omap2_clksel_recalc,
@@ -969,9 +977,9 @@ static struct clk sys_clkout2 = {
 static struct clk emul_ck = {
 	.name		= "emul_ck",
 	.parent		= &func_54m_ck,
-	.flags		= CLOCK_IN_OMAP242X,
+	.flags		= CLOCK_IN_OMAP242X | OFFSET_GR_MOD,
 	.clkdm_name	= "wkup_clkdm",
-	.enable_reg	= OMAP24XX_PRCM_CLKEMUL_CTRL,
+	.enable_reg	= _GR_MOD_OFFSET(OMAP24XX_PRCM_CLKEMUL_CTRL_OFFSET),
 	.enable_bit	= OMAP24XX_EMULATION_EN_SHIFT,
 	.recalc		= &followparent_recalc,
 
@@ -1009,7 +1017,7 @@ static struct clk mpu_ck = {	/* Control cpu */
 				CONFIG_PARTICIPANT | RATE_PROPAGATES,
 	.clkdm_name	= "mpu_clkdm",
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= OMAP_CM_REGADDR(MPU_MOD, CM_CLKSEL),
+	.clksel_reg	= _CM_REG_OFFSET(MPU_MOD, CM_CLKSEL),
 	.clksel_mask	= OMAP24XX_CLKSEL_MPU_MASK,
 	.clksel		= mpu_clksel,
 	.recalc		= &omap2_clksel_recalc,
@@ -1050,9 +1058,9 @@ static struct clk dsp_fck = {
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X | DELAYED_APP |
 				CONFIG_PARTICIPANT | RATE_PROPAGATES,
 	.clkdm_name	= "dsp_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(OMAP24XX_DSP_MOD, CM_FCLKEN),
+	.enable_reg	= _CM_REG_OFFSET(OMAP24XX_DSP_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP24XX_CM_FCLKEN_DSP_EN_DSP_SHIFT,
-	.clksel_reg	= OMAP_CM_REGADDR(OMAP24XX_DSP_MOD, CM_CLKSEL),
+	.clksel_reg	= _CM_REG_OFFSET(OMAP24XX_DSP_MOD, CM_CLKSEL),
 	.clksel_mask	= OMAP24XX_CLKSEL_DSP_MASK,
 	.clksel		= dsp_fck_clksel,
 	.recalc		= &omap2_clksel_recalc,
@@ -1079,7 +1087,7 @@ static struct clk dsp_irate_ick = {
 	.parent		= &dsp_fck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X | DELAYED_APP |
 				CONFIG_PARTICIPANT | PARENT_CONTROLS_CLOCK,
-	.clksel_reg	= OMAP_CM_REGADDR(OMAP24XX_DSP_MOD, CM_CLKSEL),
+	.clksel_reg	= _CM_REG_OFFSET(OMAP24XX_DSP_MOD, CM_CLKSEL),
 	.clksel_mask	= OMAP24XX_CLKSEL_DSP_IF_MASK,
 	.clksel		= dsp_irate_ick_clksel,
 	.recalc		= &omap2_clksel_recalc,
@@ -1092,7 +1100,7 @@ static struct clk dsp_ick = {
 	.name		= "dsp_ick",	 /* apparently ipi and isp */
 	.parent		= &dsp_irate_ick,
 	.flags		= CLOCK_IN_OMAP242X | DELAYED_APP | CONFIG_PARTICIPANT,
-	.enable_reg	= OMAP_CM_REGADDR(OMAP24XX_DSP_MOD, CM_ICLKEN),
+	.enable_reg	= _CM_REG_OFFSET(OMAP24XX_DSP_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP2420_EN_DSP_IPI_SHIFT,	      /* for ipi */
 };
 
@@ -1101,7 +1109,7 @@ static struct clk iva2_1_ick = {
 	.name		= "iva2_1_ick",
 	.parent		= &dsp_irate_ick,
 	.flags		= CLOCK_IN_OMAP243X | DELAYED_APP | CONFIG_PARTICIPANT,
-	.enable_reg	= OMAP_CM_REGADDR(OMAP24XX_DSP_MOD, CM_FCLKEN),
+	.enable_reg	= _CM_REG_OFFSET(OMAP24XX_DSP_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP24XX_CM_FCLKEN_DSP_EN_DSP_SHIFT,
 };
 
@@ -1116,9 +1124,9 @@ static struct clk iva1_ifck = {
 	.flags		= CLOCK_IN_OMAP242X | CONFIG_PARTICIPANT |
 				RATE_PROPAGATES | DELAYED_APP,
 	.clkdm_name	= "iva1_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(OMAP24XX_DSP_MOD, CM_FCLKEN),
+	.enable_reg	= _CM_REG_OFFSET(OMAP24XX_DSP_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP2420_EN_IVA_COP_SHIFT,
-	.clksel_reg	= OMAP_CM_REGADDR(OMAP24XX_DSP_MOD, CM_CLKSEL),
+	.clksel_reg	= _CM_REG_OFFSET(OMAP24XX_DSP_MOD, CM_CLKSEL),
 	.clksel_mask	= OMAP2420_CLKSEL_IVA_MASK,
 	.clksel		= dsp_fck_clksel,
 	.recalc		= &omap2_clksel_recalc,
@@ -1132,7 +1140,7 @@ static struct clk iva1_mpu_int_ifck = {
 	.parent		= &iva1_ifck,
 	.flags		= CLOCK_IN_OMAP242X,
 	.clkdm_name	= "iva1_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(OMAP24XX_DSP_MOD, CM_FCLKEN),
+	.enable_reg	= _CM_REG_OFFSET(OMAP24XX_DSP_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP2420_EN_IVA_MPU_SHIFT,
 	.fixed_div	= 2,
 	.recalc		= &omap2_fixed_divisor_recalc,
@@ -1180,7 +1188,7 @@ static struct clk core_l3_ck = {	/* Used for ick and fck, interconnect */
 				ALWAYS_ENABLED | DELAYED_APP |
 				CONFIG_PARTICIPANT | RATE_PROPAGATES,
 	.clkdm_name	= "core_l3_clkdm",
-	.clksel_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_CLKSEL1),
+	.clksel_reg	= _CM_REG_OFFSET(CORE_MOD, CM_CLKSEL1),
 	.clksel_mask	= OMAP24XX_CLKSEL_L3_MASK,
 	.clksel		= core_l3_clksel,
 	.recalc		= &omap2_clksel_recalc,
@@ -1208,9 +1216,9 @@ static struct clk usb_l4_ick = {	/* FS-USB interface clock */
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				DELAYED_APP | CONFIG_PARTICIPANT,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN2),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN2),
 	.enable_bit	= OMAP24XX_EN_USB_SHIFT,
-	.clksel_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_CLKSEL1),
+	.clksel_reg	= _CM_REG_OFFSET(CORE_MOD, CM_CLKSEL1),
 	.clksel_mask	= OMAP24XX_CLKSEL_USB_MASK,
 	.clksel		= usb_l4_ick_clksel,
 	.recalc		= &omap2_clksel_recalc,
@@ -1242,7 +1250,7 @@ static struct clk l4_ck = {		/* used both as an ick and fck */
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				ALWAYS_ENABLED | DELAYED_APP | RATE_PROPAGATES,
 	.clkdm_name	= "core_l4_clkdm",
-	.clksel_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_CLKSEL1),
+	.clksel_reg	= _CM_REG_OFFSET(CORE_MOD, CM_CLKSEL1),
 	.clksel_mask	= OMAP24XX_CLKSEL_L4_MASK,
 	.clksel		= l4_clksel,
 	.recalc		= &omap2_clksel_recalc,
@@ -1280,9 +1288,9 @@ static struct clk ssi_ssr_sst_fck = {
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				DELAYED_APP,
 	.clkdm_name	= "core_l3_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, OMAP24XX_CM_FCLKEN2),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_FCLKEN2),
 	.enable_bit	= OMAP24XX_EN_SSI_SHIFT,
-	.clksel_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_CLKSEL1),
+	.clksel_reg	= _CM_REG_OFFSET(CORE_MOD, CM_CLKSEL1),
 	.clksel_mask	= OMAP24XX_CLKSEL_SSI_MASK,
 	.clksel		= ssi_ssr_sst_fck_clksel,
 	.recalc		= &omap2_clksel_recalc,
@@ -1299,7 +1307,7 @@ static struct clk ssi_l4_ick = {
 	.parent		= &l4_ck,
 	.clkdm_name	= "core_l4_clkdm",
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN2),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN2),
 	.enable_bit	= OMAP24XX_EN_SSI_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -1329,9 +1337,9 @@ static struct clk gfx_3d_fck = {
 	.parent		= &core_l3_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm_name	= "gfx_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(GFX_MOD, CM_FCLKEN),
+	.enable_reg	= _CM_REG_OFFSET(GFX_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP24XX_EN_3D_SHIFT,
-	.clksel_reg	= OMAP_CM_REGADDR(GFX_MOD, CM_CLKSEL),
+	.clksel_reg	= _CM_REG_OFFSET(GFX_MOD, CM_CLKSEL),
 	.clksel_mask	= OMAP_CLKSEL_GFX_MASK,
 	.clksel		= gfx_fck_clksel,
 	.recalc		= &omap2_clksel_recalc,
@@ -1344,9 +1352,9 @@ static struct clk gfx_2d_fck = {
 	.parent		= &core_l3_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm_name	= "gfx_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(GFX_MOD, CM_FCLKEN),
+	.enable_reg	= _CM_REG_OFFSET(GFX_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP24XX_EN_2D_SHIFT,
-	.clksel_reg	= OMAP_CM_REGADDR(GFX_MOD, CM_CLKSEL),
+	.clksel_reg	= _CM_REG_OFFSET(GFX_MOD, CM_CLKSEL),
 	.clksel_mask	= OMAP_CLKSEL_GFX_MASK,
 	.clksel		= gfx_fck_clksel,
 	.recalc		= &omap2_clksel_recalc,
@@ -1359,7 +1367,7 @@ static struct clk gfx_ick = {
 	.parent		= &core_l3_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm_name	= "gfx_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(GFX_MOD, CM_ICLKEN),
+	.enable_reg	= _CM_REG_OFFSET(GFX_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP_EN_GFX_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -1389,9 +1397,9 @@ static struct clk mdm_ick = {		/* used both as a ick and fck */
 	.parent		= &core_ck,
 	.flags		= CLOCK_IN_OMAP243X | DELAYED_APP | CONFIG_PARTICIPANT,
 	.clkdm_name	= "mdm_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(OMAP2430_MDM_MOD, CM_ICLKEN),
+	.enable_reg	= _CM_REG_OFFSET(OMAP2430_MDM_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP2430_CM_ICLKEN_MDM_EN_MDM_SHIFT,
-	.clksel_reg	= OMAP_CM_REGADDR(OMAP2430_MDM_MOD, CM_CLKSEL),
+	.clksel_reg	= _CM_REG_OFFSET(OMAP2430_MDM_MOD, CM_CLKSEL),
 	.clksel_mask	= OMAP2430_CLKSEL_MDM_MASK,
 	.clksel		= mdm_ick_clksel,
 	.recalc		= &omap2_clksel_recalc,
@@ -1404,7 +1412,7 @@ static struct clk mdm_osc_ck = {
 	.parent		= &osc_ck,
 	.flags		= CLOCK_IN_OMAP243X,
 	.clkdm_name	= "mdm_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(OMAP2430_MDM_MOD, CM_FCLKEN),
+	.enable_reg	= _CM_REG_OFFSET(OMAP2430_MDM_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP2430_EN_OSC_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -1449,7 +1457,7 @@ static struct clk dss_ick = {		/* Enables both L3,L4 ICLK's */
 	.parent		= &l4_ck,	/* really both l3 and l4 */
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm_name	= "dss_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP24XX_EN_DSS1_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -1460,10 +1468,10 @@ static struct clk dss1_fck = {
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				DELAYED_APP,
 	.clkdm_name	= "dss_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_DSS1_SHIFT,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_CLKSEL1),
+	.clksel_reg	= _CM_REG_OFFSET(CORE_MOD, CM_CLKSEL1),
 	.clksel_mask	= OMAP24XX_CLKSEL_DSS1_MASK,
 	.clksel		= dss1_fck_clksel,
 	.recalc		= &omap2_clksel_recalc,
@@ -1493,10 +1501,10 @@ static struct clk dss2_fck = {		/* Alt clk used in power management */
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				DELAYED_APP,
 	.clkdm_name	= "dss_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_DSS2_SHIFT,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_CLKSEL1),
+	.clksel_reg	= _CM_REG_OFFSET(CORE_MOD, CM_CLKSEL1),
 	.clksel_mask	= OMAP24XX_CLKSEL_DSS2_MASK,
 	.clksel		= dss2_fck_clksel,
 	.recalc		= &followparent_recalc,
@@ -1507,7 +1515,7 @@ static struct clk dss_54m_fck = {	/* Alt clk used in power management */
 	.parent		= &func_54m_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm_name	= "dss_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_TV_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -1535,7 +1543,7 @@ static struct clk gpt1_ick = {
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(WKUP_MOD, CM_ICLKEN),
+	.enable_reg	= _CM_REG_OFFSET(WKUP_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP24XX_EN_GPT1_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -1545,10 +1553,10 @@ static struct clk gpt1_fck = {
 	.parent		= &func_32k_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(WKUP_MOD, CM_FCLKEN),
+	.enable_reg	= _CM_REG_OFFSET(WKUP_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP24XX_EN_GPT1_SHIFT,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= OMAP_CM_REGADDR(WKUP_MOD, CM_CLKSEL1),
+	.clksel_reg	= _CM_REG_OFFSET(WKUP_MOD, CM_CLKSEL1),
 	.clksel_mask	= OMAP24XX_CLKSEL_GPT1_MASK,
 	.clksel		= omap24xx_gpt_clksel,
 	.recalc		= &omap2_clksel_recalc,
@@ -1561,7 +1569,7 @@ static struct clk gpt2_ick = {
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP24XX_EN_GPT2_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -1571,10 +1579,10 @@ static struct clk gpt2_fck = {
 	.parent		= &func_32k_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_GPT2_SHIFT,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_CLKSEL2),
+	.clksel_reg	= _CM_REG_OFFSET(CORE_MOD, CM_CLKSEL2),
 	.clksel_mask	= OMAP24XX_CLKSEL_GPT2_MASK,
 	.clksel		= omap24xx_gpt_clksel,
 	.recalc		= &omap2_clksel_recalc,
@@ -1585,7 +1593,7 @@ static struct clk gpt3_ick = {
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP24XX_EN_GPT3_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -1595,10 +1603,10 @@ static struct clk gpt3_fck = {
 	.parent		= &func_32k_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_GPT3_SHIFT,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_CLKSEL2),
+	.clksel_reg	= _CM_REG_OFFSET(CORE_MOD, CM_CLKSEL2),
 	.clksel_mask	= OMAP24XX_CLKSEL_GPT3_MASK,
 	.clksel		= omap24xx_gpt_clksel,
 	.recalc		= &omap2_clksel_recalc,
@@ -1609,7 +1617,7 @@ static struct clk gpt4_ick = {
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP24XX_EN_GPT4_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -1619,10 +1627,10 @@ static struct clk gpt4_fck = {
 	.parent		= &func_32k_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_GPT4_SHIFT,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_CLKSEL2),
+	.clksel_reg	= _CM_REG_OFFSET(CORE_MOD, CM_CLKSEL2),
 	.clksel_mask	= OMAP24XX_CLKSEL_GPT4_MASK,
 	.clksel		= omap24xx_gpt_clksel,
 	.recalc		= &omap2_clksel_recalc,
@@ -1633,7 +1641,7 @@ static struct clk gpt5_ick = {
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP24XX_EN_GPT5_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -1643,10 +1651,10 @@ static struct clk gpt5_fck = {
 	.parent		= &func_32k_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_GPT5_SHIFT,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_CLKSEL2),
+	.clksel_reg	= _CM_REG_OFFSET(CORE_MOD, CM_CLKSEL2),
 	.clksel_mask	= OMAP24XX_CLKSEL_GPT5_MASK,
 	.clksel		= omap24xx_gpt_clksel,
 	.recalc		= &omap2_clksel_recalc,
@@ -1657,7 +1665,7 @@ static struct clk gpt6_ick = {
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP24XX_EN_GPT6_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -1667,10 +1675,10 @@ static struct clk gpt6_fck = {
 	.parent		= &func_32k_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_GPT6_SHIFT,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_CLKSEL2),
+	.clksel_reg	= _CM_REG_OFFSET(CORE_MOD, CM_CLKSEL2),
 	.clksel_mask	= OMAP24XX_CLKSEL_GPT6_MASK,
 	.clksel		= omap24xx_gpt_clksel,
 	.recalc		= &omap2_clksel_recalc,
@@ -1680,7 +1688,7 @@ static struct clk gpt7_ick = {
 	.name		= "gpt7_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP24XX_EN_GPT7_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -1690,10 +1698,10 @@ static struct clk gpt7_fck = {
 	.parent		= &func_32k_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_GPT7_SHIFT,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_CLKSEL2),
+	.clksel_reg	= _CM_REG_OFFSET(CORE_MOD, CM_CLKSEL2),
 	.clksel_mask	= OMAP24XX_CLKSEL_GPT7_MASK,
 	.clksel		= omap24xx_gpt_clksel,
 	.recalc		= &omap2_clksel_recalc,
@@ -1704,7 +1712,7 @@ static struct clk gpt8_ick = {
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP24XX_EN_GPT8_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -1714,10 +1722,10 @@ static struct clk gpt8_fck = {
 	.parent		= &func_32k_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_GPT8_SHIFT,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_CLKSEL2),
+	.clksel_reg	= _CM_REG_OFFSET(CORE_MOD, CM_CLKSEL2),
 	.clksel_mask	= OMAP24XX_CLKSEL_GPT8_MASK,
 	.clksel		= omap24xx_gpt_clksel,
 	.recalc		= &omap2_clksel_recalc,
@@ -1728,7 +1736,7 @@ static struct clk gpt9_ick = {
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP24XX_EN_GPT9_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -1738,10 +1746,10 @@ static struct clk gpt9_fck = {
 	.parent		= &func_32k_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_GPT9_SHIFT,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_CLKSEL2),
+	.clksel_reg	= _CM_REG_OFFSET(CORE_MOD, CM_CLKSEL2),
 	.clksel_mask	= OMAP24XX_CLKSEL_GPT9_MASK,
 	.clksel		= omap24xx_gpt_clksel,
 	.recalc		= &omap2_clksel_recalc,
@@ -1752,7 +1760,7 @@ static struct clk gpt10_ick = {
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP24XX_EN_GPT10_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -1762,10 +1770,10 @@ static struct clk gpt10_fck = {
 	.parent		= &func_32k_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_GPT10_SHIFT,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_CLKSEL2),
+	.clksel_reg	= _CM_REG_OFFSET(CORE_MOD, CM_CLKSEL2),
 	.clksel_mask	= OMAP24XX_CLKSEL_GPT10_MASK,
 	.clksel		= omap24xx_gpt_clksel,
 	.recalc		= &omap2_clksel_recalc,
@@ -1776,7 +1784,7 @@ static struct clk gpt11_ick = {
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP24XX_EN_GPT11_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -1786,10 +1794,10 @@ static struct clk gpt11_fck = {
 	.parent		= &func_32k_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_GPT11_SHIFT,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_CLKSEL2),
+	.clksel_reg	= _CM_REG_OFFSET(CORE_MOD, CM_CLKSEL2),
 	.clksel_mask	= OMAP24XX_CLKSEL_GPT11_MASK,
 	.clksel		= omap24xx_gpt_clksel,
 	.recalc		= &omap2_clksel_recalc,
@@ -1800,7 +1808,7 @@ static struct clk gpt12_ick = {
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP24XX_EN_GPT12_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -1810,10 +1818,10 @@ static struct clk gpt12_fck = {
 	.parent		= &func_32k_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_GPT12_SHIFT,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_CLKSEL2),
+	.clksel_reg	= _CM_REG_OFFSET(CORE_MOD, CM_CLKSEL2),
 	.clksel_mask	= OMAP24XX_CLKSEL_GPT12_MASK,
 	.clksel		= omap24xx_gpt_clksel,
 	.recalc		= &omap2_clksel_recalc,
@@ -1825,7 +1833,7 @@ static struct clk mcbsp1_ick = {
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP24XX_EN_MCBSP1_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -1836,7 +1844,7 @@ static struct clk mcbsp1_fck = {
 	.parent		= &func_96m_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_MCBSP1_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -1847,7 +1855,7 @@ static struct clk mcbsp2_ick = {
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP24XX_EN_MCBSP2_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -1858,7 +1866,7 @@ static struct clk mcbsp2_fck = {
 	.parent		= &func_96m_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_MCBSP2_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -1869,7 +1877,7 @@ static struct clk mcbsp3_ick = {
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN2),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN2),
 	.enable_bit	= OMAP2430_EN_MCBSP3_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -1880,7 +1888,7 @@ static struct clk mcbsp3_fck = {
 	.parent		= &func_96m_ck,
 	.flags		= CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, OMAP24XX_CM_FCLKEN2),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_FCLKEN2),
 	.enable_bit	= OMAP2430_EN_MCBSP3_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -1891,7 +1899,7 @@ static struct clk mcbsp4_ick = {
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN2),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN2),
 	.enable_bit	= OMAP2430_EN_MCBSP4_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -1902,7 +1910,7 @@ static struct clk mcbsp4_fck = {
 	.parent		= &func_96m_ck,
 	.flags		= CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, OMAP24XX_CM_FCLKEN2),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_FCLKEN2),
 	.enable_bit	= OMAP2430_EN_MCBSP4_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -1913,7 +1921,7 @@ static struct clk mcbsp5_ick = {
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN2),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN2),
 	.enable_bit	= OMAP2430_EN_MCBSP5_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -1924,7 +1932,7 @@ static struct clk mcbsp5_fck = {
 	.parent		= &func_96m_ck,
 	.flags		= CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, OMAP24XX_CM_FCLKEN2),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_FCLKEN2),
 	.enable_bit	= OMAP2430_EN_MCBSP5_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -1935,7 +1943,7 @@ static struct clk mcspi1_ick = {
 	.parent		= &l4_ck,
 	.clkdm_name	= "core_l4_clkdm",
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP24XX_EN_MCSPI1_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -1946,7 +1954,7 @@ static struct clk mcspi1_fck = {
 	.parent		= &func_48m_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_MCSPI1_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -1957,7 +1965,7 @@ static struct clk mcspi2_ick = {
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP24XX_EN_MCSPI2_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -1968,7 +1976,7 @@ static struct clk mcspi2_fck = {
 	.parent		= &func_48m_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_MCSPI2_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -1979,7 +1987,7 @@ static struct clk mcspi3_ick = {
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN2),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN2),
 	.enable_bit	= OMAP2430_EN_MCSPI3_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -1990,7 +1998,7 @@ static struct clk mcspi3_fck = {
 	.parent		= &func_48m_ck,
 	.flags		= CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, OMAP24XX_CM_FCLKEN2),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_FCLKEN2),
 	.enable_bit	= OMAP2430_EN_MCSPI3_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2000,7 +2008,7 @@ static struct clk uart1_ick = {
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP24XX_EN_UART1_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2010,7 +2018,7 @@ static struct clk uart1_fck = {
 	.parent		= &func_48m_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_UART1_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2020,7 +2028,7 @@ static struct clk uart2_ick = {
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP24XX_EN_UART2_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2030,7 +2038,7 @@ static struct clk uart2_fck = {
 	.parent		= &func_48m_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_UART2_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2040,7 +2048,7 @@ static struct clk uart3_ick = {
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN2),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN2),
 	.enable_bit	= OMAP24XX_EN_UART3_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2050,7 +2058,7 @@ static struct clk uart3_fck = {
 	.parent		= &func_48m_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, OMAP24XX_CM_FCLKEN2),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_FCLKEN2),
 	.enable_bit	= OMAP24XX_EN_UART3_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2060,7 +2068,7 @@ static struct clk gpios_ick = {
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(WKUP_MOD, CM_ICLKEN),
+	.enable_reg	= _CM_REG_OFFSET(WKUP_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP24XX_EN_GPIOS_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2070,7 +2078,7 @@ static struct clk gpios_fck = {
 	.parent		= &func_32k_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm_name	= "wkup_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(WKUP_MOD, CM_FCLKEN),
+	.enable_reg	= _CM_REG_OFFSET(WKUP_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP24XX_EN_GPIOS_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2080,7 +2088,7 @@ static struct clk mpu_wdt_ick = {
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(WKUP_MOD, CM_ICLKEN),
+	.enable_reg	= _CM_REG_OFFSET(WKUP_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP24XX_EN_MPU_WDT_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2090,7 +2098,7 @@ static struct clk mpu_wdt_fck = {
 	.parent		= &func_32k_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm_name	= "wkup_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(WKUP_MOD, CM_FCLKEN),
+	.enable_reg	= _CM_REG_OFFSET(WKUP_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP24XX_EN_MPU_WDT_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2101,7 +2109,7 @@ static struct clk sync_32k_ick = {
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				ENABLE_ON_INIT,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(WKUP_MOD, CM_ICLKEN),
+	.enable_reg	= _CM_REG_OFFSET(WKUP_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP24XX_EN_32KSYNC_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2111,7 +2119,7 @@ static struct clk wdt1_ick = {
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(WKUP_MOD, CM_ICLKEN),
+	.enable_reg	= _CM_REG_OFFSET(WKUP_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP24XX_EN_WDT1_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2122,7 +2130,7 @@ static struct clk omapctrl_ick = {
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				ENABLE_ON_INIT,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(WKUP_MOD, CM_ICLKEN),
+	.enable_reg	= _CM_REG_OFFSET(WKUP_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP24XX_EN_OMAPCTRL_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2132,7 +2140,7 @@ static struct clk icr_ick = {
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(WKUP_MOD, CM_ICLKEN),
+	.enable_reg	= _CM_REG_OFFSET(WKUP_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP2430_EN_ICR_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2142,7 +2150,7 @@ static struct clk cam_ick = {
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP24XX_EN_CAM_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2157,7 +2165,7 @@ static struct clk cam_fck = {
 	.parent		= &func_96m_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l3_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_CAM_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2167,7 +2175,7 @@ static struct clk mailboxes_ick = {
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP24XX_EN_MAILBOXES_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2177,7 +2185,7 @@ static struct clk wdt4_ick = {
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP24XX_EN_WDT4_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2187,7 +2195,7 @@ static struct clk wdt4_fck = {
 	.parent		= &func_32k_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_WDT4_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2197,7 +2205,7 @@ static struct clk wdt3_ick = {
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP2420_EN_WDT3_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2207,7 +2215,7 @@ static struct clk wdt3_fck = {
 	.parent		= &func_32k_ck,
 	.flags		= CLOCK_IN_OMAP242X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP2420_EN_WDT3_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2217,7 +2225,7 @@ static struct clk mspro_ick = {
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP24XX_EN_MSPRO_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2227,7 +2235,7 @@ static struct clk mspro_fck = {
 	.parent		= &func_96m_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_MSPRO_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2237,7 +2245,7 @@ static struct clk mmc_ick = {
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP2420_EN_MMC_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2247,7 +2255,7 @@ static struct clk mmc_fck = {
 	.parent		= &func_96m_ck,
 	.flags		= CLOCK_IN_OMAP242X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP2420_EN_MMC_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2257,7 +2265,7 @@ static struct clk fac_ick = {
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP24XX_EN_FAC_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2267,7 +2275,7 @@ static struct clk fac_fck = {
 	.parent		= &func_12m_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_FAC_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2277,7 +2285,7 @@ static struct clk eac_ick = {
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP2420_EN_EAC_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2287,7 +2295,7 @@ static struct clk eac_fck = {
 	.parent		= &func_96m_ck,
 	.flags		= CLOCK_IN_OMAP242X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP2420_EN_EAC_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2297,7 +2305,7 @@ static struct clk hdq_ick = {
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP24XX_EN_HDQ_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2307,7 +2315,7 @@ static struct clk hdq_fck = {
 	.parent		= &func_12m_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_HDQ_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2318,7 +2326,7 @@ static struct clk i2c2_ick = {
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP2420_EN_I2C2_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2329,7 +2337,7 @@ static struct clk i2c2_fck = {
 	.parent		= &func_12m_ck,
 	.flags		= CLOCK_IN_OMAP242X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP2420_EN_I2C2_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2340,7 +2348,7 @@ static struct clk i2chs2_fck = {
 	.parent		= &func_96m_ck,
 	.flags		= CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, OMAP24XX_CM_FCLKEN2),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_FCLKEN2),
 	.enable_bit	= OMAP2430_EN_I2CHS2_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2351,7 +2359,7 @@ static struct clk i2c1_ick = {
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP2420_EN_I2C1_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2362,7 +2370,7 @@ static struct clk i2c1_fck = {
 	.parent		= &func_12m_ck,
 	.flags		= CLOCK_IN_OMAP242X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP2420_EN_I2C1_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2373,7 +2381,7 @@ static struct clk i2chs1_fck = {
 	.parent		= &func_96m_ck,
 	.flags		= CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, OMAP24XX_CM_FCLKEN2),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_FCLKEN2),
 	.enable_bit	= OMAP2430_EN_I2CHS1_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2408,7 +2416,7 @@ static struct clk vlynq_ick = {
 	.parent		= &core_l3_ck,
 	.flags		= CLOCK_IN_OMAP242X,
 	.clkdm_name	= "core_l3_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP2420_EN_VLYNQ_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2443,10 +2451,10 @@ static struct clk vlynq_fck = {
 	.parent		= &func_96m_ck,
 	.flags		= CLOCK_IN_OMAP242X | DELAYED_APP,
 	.clkdm_name	= "core_l3_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP2420_EN_VLYNQ_SHIFT,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_CLKSEL1),
+	.clksel_reg	= _CM_REG_OFFSET(CORE_MOD, CM_CLKSEL1),
 	.clksel_mask	= OMAP2420_CLKSEL_VLYNQ_MASK,
 	.clksel		= vlynq_fck_clksel,
 	.recalc		= &omap2_clksel_recalc,
@@ -2459,7 +2467,7 @@ static struct clk sdrc_ick = {
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP243X | ENABLE_ON_INIT,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN3),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN3),
 	.enable_bit	= OMAP2430_EN_SDRC_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2469,7 +2477,7 @@ static struct clk des_ick = {
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP243X | CLOCK_IN_OMAP242X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, OMAP24XX_CM_ICLKEN4),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_ICLKEN4),
 	.enable_bit	= OMAP24XX_EN_DES_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2479,7 +2487,7 @@ static struct clk sha_ick = {
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP243X | CLOCK_IN_OMAP242X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, OMAP24XX_CM_ICLKEN4),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_ICLKEN4),
 	.enable_bit	= OMAP24XX_EN_SHA_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2489,7 +2497,7 @@ static struct clk rng_ick = {
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP243X | CLOCK_IN_OMAP242X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, OMAP24XX_CM_ICLKEN4),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_ICLKEN4),
 	.enable_bit	= OMAP24XX_EN_RNG_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2499,7 +2507,7 @@ static struct clk aes_ick = {
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP243X | CLOCK_IN_OMAP242X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, OMAP24XX_CM_ICLKEN4),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_ICLKEN4),
 	.enable_bit	= OMAP24XX_EN_AES_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2509,7 +2517,7 @@ static struct clk pka_ick = {
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP243X | CLOCK_IN_OMAP242X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, OMAP24XX_CM_ICLKEN4),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_ICLKEN4),
 	.enable_bit	= OMAP24XX_EN_PKA_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2519,7 +2527,7 @@ static struct clk usb_fck = {
 	.parent		= &func_48m_ck,
 	.flags		= CLOCK_IN_OMAP243X | CLOCK_IN_OMAP242X,
 	.clkdm_name	= "core_l3_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, OMAP24XX_CM_FCLKEN2),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_FCLKEN2),
 	.enable_bit	= OMAP24XX_EN_USB_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2529,7 +2537,7 @@ static struct clk usbhs_ick = {
 	.parent		= &core_l3_ck,
 	.flags		= CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l3_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN2),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN2),
 	.enable_bit	= OMAP2430_EN_USBHS_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2539,7 +2547,7 @@ static struct clk mmchs1_ick = {
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN2),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN2),
 	.enable_bit	= OMAP2430_EN_MMCHS1_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2549,7 +2557,7 @@ static struct clk mmchs1_fck = {
 	.parent		= &func_96m_ck,
 	.flags		= CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l3_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, OMAP24XX_CM_FCLKEN2),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_FCLKEN2),
 	.enable_bit	= OMAP2430_EN_MMCHS1_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2560,7 +2568,7 @@ static struct clk mmchs2_ick = {
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN2),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN2),
 	.enable_bit	= OMAP2430_EN_MMCHS2_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2570,7 +2578,7 @@ static struct clk mmchs2_fck = {
 	.id		= 1,
 	.parent		= &func_96m_ck,
 	.flags		= CLOCK_IN_OMAP243X,
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, OMAP24XX_CM_FCLKEN2),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_FCLKEN2),
 	.enable_bit	= OMAP2430_EN_MMCHS2_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2580,7 +2588,7 @@ static struct clk gpio5_ick = {
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN2),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN2),
 	.enable_bit	= OMAP2430_EN_GPIO5_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2590,7 +2598,7 @@ static struct clk gpio5_fck = {
 	.parent		= &func_32k_ck,
 	.flags		= CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, OMAP24XX_CM_FCLKEN2),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_FCLKEN2),
 	.enable_bit	= OMAP2430_EN_GPIO5_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2600,7 +2608,7 @@ static struct clk mdm_intc_ick = {
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN2),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN2),
 	.enable_bit	= OMAP2430_EN_MDM_INTC_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2610,7 +2618,7 @@ static struct clk mmchsdb1_fck = {
 	.parent		= &func_32k_ck,
 	.flags		= CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, OMAP24XX_CM_FCLKEN2),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_FCLKEN2),
 	.enable_bit	= OMAP2430_EN_MMCHSDB1_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2621,7 +2629,7 @@ static struct clk mmchsdb2_fck = {
 	.parent		= &func_32k_ck,
 	.flags		= CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, OMAP24XX_CM_FCLKEN2),
+	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_FCLKEN2),
 	.enable_bit	= OMAP2430_EN_MMCHSDB2_SHIFT,
 	.recalc		= &followparent_recalc,
 };
diff --git a/arch/arm/mach-omap2/clock34xx.h b/arch/arm/mach-omap2/clock34xx.h
index a01d8d9..419b09f 100644
--- a/arch/arm/mach-omap2/clock34xx.h
+++ b/arch/arm/mach-omap2/clock34xx.h
@@ -53,6 +53,15 @@ static int omap3_noncore_dpll_set_rate(struct clk *clk, unsigned long rate);
 #define DPLL_LOW_POWER_BYPASS		0x5
 #define DPLL_LOCKED			0x7
 
+#define OMAP3430_PRM_CLKSRC_CTRL					\
+	OMAP34XX_PRM_REGADDR(OMAP3430_GR_MOD, 0x0070)
+
+#define OMAP3430_PRM_CLKSEL						\
+	OMAP34XX_PRM_REGADDR(OMAP3430_CCR_MOD, OMAP3_PRM_CLKSEL_OFFSET)
+
+#define OMAP3430_PRM_CLKOUT_CTRL					\
+	OMAP34XX_PRM_REGADDR(OMAP3430_CCR_MOD, OMAP3_PRM_CLKOUT_CTRL_OFFSET)
+
 /* PRM CLOCKS */
 
 /* According to timer32k.c, this is a 32768Hz clock, not a 32000Hz clock. */
@@ -257,23 +266,26 @@ static const struct clksel_rate div16_dpll_rates[] = {
 	{ .div = 0 }
 };
 
+#define _OMAP34XX_CM_REGADDR(module, reg)				\
+	((__force void __iomem *)(OMAP34XX_CM_REGADDR((module), (reg))))
+
 /* DPLL1 */
 /* MPU clock source */
 /* Type: DPLL */
 static struct dpll_data dpll1_dd = {
-	.mult_div1_reg	= OMAP_CM_REGADDR(MPU_MOD, OMAP3430_CM_CLKSEL1_PLL),
+	.mult_div1_reg	= _OMAP34XX_CM_REGADDR(MPU_MOD, OMAP3430_CM_CLKSEL1_PLL),
 	.mult_mask	= OMAP3430_MPU_DPLL_MULT_MASK,
 	.div1_mask	= OMAP3430_MPU_DPLL_DIV_MASK,
 	.freqsel_mask	= OMAP3430_MPU_DPLL_FREQSEL_MASK,
-	.control_reg	= OMAP_CM_REGADDR(MPU_MOD, OMAP3430_CM_CLKEN_PLL),
+	.control_reg	= _OMAP34XX_CM_REGADDR(MPU_MOD, OMAP3430_CM_CLKEN_PLL),
 	.enable_mask	= OMAP3430_EN_MPU_DPLL_MASK,
 	.modes		= (1 << DPLL_LOW_POWER_BYPASS) | (1 << DPLL_LOCKED),
 	.auto_recal_bit	= OMAP3430_EN_MPU_DPLL_DRIFTGUARD_SHIFT,
 	.recal_en_bit	= OMAP3430_MPU_DPLL_RECAL_EN_SHIFT,
 	.recal_st_bit	= OMAP3430_MPU_DPLL_ST_SHIFT,
-	.autoidle_reg	= OMAP_CM_REGADDR(MPU_MOD, OMAP3430_CM_AUTOIDLE_PLL),
+	.autoidle_reg	= _OMAP34XX_CM_REGADDR(MPU_MOD, OMAP3430_CM_AUTOIDLE_PLL),
 	.autoidle_mask	= OMAP3430_AUTO_MPU_DPLL_MASK,
-	.idlest_reg	= OMAP_CM_REGADDR(MPU_MOD, OMAP3430_CM_IDLEST_PLL),
+	.idlest_reg	= _OMAP34XX_CM_REGADDR(MPU_MOD, OMAP3430_CM_IDLEST_PLL),
 	.idlest_bit	= OMAP3430_ST_MPU_CLK_SHIFT,
 	.max_multiplier = OMAP3_MAX_DPLL_MULT,
 	.max_divider	= OMAP3_MAX_DPLL_DIV,
@@ -316,7 +328,7 @@ static struct clk dpll1_x2m2_ck = {
 	.name		= "dpll1_x2m2_ck",
 	.parent		= &dpll1_x2_ck,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= OMAP_CM_REGADDR(MPU_MOD, OMAP3430_CM_CLKSEL2_PLL),
+	.clksel_reg	= _OMAP34XX_CM_REGADDR(MPU_MOD, OMAP3430_CM_CLKSEL2_PLL),
 	.clksel_mask	= OMAP3430_MPU_DPLL_CLKOUT_DIV_MASK,
 	.clksel		= div16_dpll1_x2m2_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
@@ -329,20 +341,20 @@ static struct clk dpll1_x2m2_ck = {
 /* Type: DPLL */
 
 static struct dpll_data dpll2_dd = {
-	.mult_div1_reg	= OMAP_CM_REGADDR(OMAP3430_IVA2_MOD, OMAP3430_CM_CLKSEL1_PLL),
+	.mult_div1_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_IVA2_MOD, OMAP3430_CM_CLKSEL1_PLL),
 	.mult_mask	= OMAP3430_IVA2_DPLL_MULT_MASK,
 	.div1_mask	= OMAP3430_IVA2_DPLL_DIV_MASK,
 	.freqsel_mask	= OMAP3430_IVA2_DPLL_FREQSEL_MASK,
-	.control_reg	= OMAP_CM_REGADDR(OMAP3430_IVA2_MOD, OMAP3430_CM_CLKEN_PLL),
+	.control_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_IVA2_MOD, OMAP3430_CM_CLKEN_PLL),
 	.enable_mask	= OMAP3430_EN_IVA2_DPLL_MASK,
 	.modes		= (1 << DPLL_LOW_POWER_STOP) | (1 << DPLL_LOCKED) |
 				(1 << DPLL_LOW_POWER_BYPASS),
 	.auto_recal_bit	= OMAP3430_EN_IVA2_DPLL_DRIFTGUARD_SHIFT,
 	.recal_en_bit	= OMAP3430_PRM_IRQENABLE_MPU_IVA2_DPLL_RECAL_EN_SHIFT,
 	.recal_st_bit	= OMAP3430_PRM_IRQSTATUS_MPU_IVA2_DPLL_ST_SHIFT,
-	.autoidle_reg	= OMAP_CM_REGADDR(OMAP3430_IVA2_MOD, OMAP3430_CM_AUTOIDLE_PLL),
+	.autoidle_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_IVA2_MOD, OMAP3430_CM_AUTOIDLE_PLL),
 	.autoidle_mask	= OMAP3430_AUTO_IVA2_DPLL_MASK,
-	.idlest_reg	= OMAP_CM_REGADDR(OMAP3430_IVA2_MOD, OMAP3430_CM_IDLEST_PLL),
+	.idlest_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_IVA2_MOD, OMAP3430_CM_IDLEST_PLL),
 	.idlest_bit	= OMAP3430_ST_IVA2_CLK_SHIFT,
 	.max_multiplier = OMAP3_MAX_DPLL_MULT,
 	.max_divider	= OMAP3_MAX_DPLL_DIV,
@@ -374,7 +386,7 @@ static struct clk dpll2_m2_ck = {
 	.name		= "dpll2_m2_ck",
 	.parent		= &dpll2_ck,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= OMAP_CM_REGADDR(OMAP3430_IVA2_MOD,
+	.clksel_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_IVA2_MOD,
 					  OMAP3430_CM_CLKSEL2_PLL),
 	.clksel_mask	= OMAP3430_IVA2_DPLL_CLKOUT_DIV_MASK,
 	.clksel		= div16_dpll2_m2x2_clksel,
@@ -389,16 +401,16 @@ static struct clk dpll2_m2_ck = {
  * REVISIT: Also supports fast relock bypass - not included below
  */
 static struct dpll_data dpll3_dd = {
-	.mult_div1_reg	= OMAP_CM_REGADDR(PLL_MOD, CM_CLKSEL1),
+	.mult_div1_reg	= _OMAP34XX_CM_REGADDR(PLL_MOD, CM_CLKSEL1),
 	.mult_mask	= OMAP3430_CORE_DPLL_MULT_MASK,
 	.div1_mask	= OMAP3430_CORE_DPLL_DIV_MASK,
 	.freqsel_mask	= OMAP3430_CORE_DPLL_FREQSEL_MASK,
-	.control_reg	= OMAP_CM_REGADDR(PLL_MOD, CM_CLKEN),
+	.control_reg	= _OMAP34XX_CM_REGADDR(PLL_MOD, CM_CLKEN),
 	.enable_mask	= OMAP3430_EN_CORE_DPLL_MASK,
 	.auto_recal_bit	= OMAP3430_EN_CORE_DPLL_DRIFTGUARD_SHIFT,
 	.recal_en_bit	= OMAP3430_CORE_DPLL_RECAL_EN_SHIFT,
 	.recal_st_bit	= OMAP3430_CORE_DPLL_ST_SHIFT,
-	.autoidle_reg	= OMAP_CM_REGADDR(PLL_MOD, CM_AUTOIDLE),
+	.autoidle_reg	= _OMAP34XX_CM_REGADDR(PLL_MOD, CM_AUTOIDLE),
 	.autoidle_mask	= OMAP3430_AUTO_CORE_DPLL_MASK,
 	.max_multiplier = OMAP3_MAX_DPLL_MULT,
 	.max_divider	= OMAP3_MAX_DPLL_DIV,
@@ -475,7 +487,7 @@ static struct clk dpll3_m2_ck = {
 	.name		= "dpll3_m2_ck",
 	.parent		= &dpll3_ck,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= OMAP_CM_REGADDR(PLL_MOD, CM_CLKSEL1),
+	.clksel_reg	= _OMAP34XX_CM_REGADDR(PLL_MOD, CM_CLKSEL1),
 	.clksel_mask	= OMAP3430_CORE_DPLL_CLKOUT_DIV_MASK,
 	.clksel		= div31_dpll3m2_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
@@ -492,7 +504,7 @@ static const struct clksel core_ck_clksel[] = {
 static struct clk core_ck = {
 	.name		= "core_ck",
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= OMAP_CM_REGADDR(PLL_MOD, CM_IDLEST),
+	.clksel_reg	= _OMAP34XX_CM_REGADDR(PLL_MOD, CM_IDLEST),
 	.clksel_mask	= OMAP3430_ST_CORE_CLK_MASK,
 	.clksel		= core_ck_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
@@ -509,7 +521,7 @@ static const struct clksel dpll3_m2x2_ck_clksel[] = {
 static struct clk dpll3_m2x2_ck = {
 	.name		= "dpll3_m2x2_ck",
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= OMAP_CM_REGADDR(PLL_MOD, CM_IDLEST),
+	.clksel_reg	= _OMAP34XX_CM_REGADDR(PLL_MOD, CM_IDLEST),
 	.clksel_mask	= OMAP3430_ST_CORE_CLK_MASK,
 	.clksel		= dpll3_m2x2_ck_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
@@ -528,7 +540,7 @@ static struct clk dpll3_m3_ck = {
 	.name		= "dpll3_m3_ck",
 	.parent		= &dpll3_ck,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= OMAP_CM_REGADDR(OMAP3430_EMU_MOD, CM_CLKSEL1),
+	.clksel_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_EMU_MOD, CM_CLKSEL1),
 	.clksel_mask	= OMAP3430_DIV_DPLL3_MASK,
 	.clksel		= div16_dpll3_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
@@ -540,7 +552,7 @@ static struct clk dpll3_m3_ck = {
 static struct clk dpll3_m3x2_ck = {
 	.name		= "dpll3_m3x2_ck",
 	.parent		= &dpll3_m3_ck,
-	.enable_reg	= OMAP_CM_REGADDR(PLL_MOD, CM_CLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(PLL_MOD, CM_CLKEN),
 	.enable_bit	= OMAP3430_PWRDN_EMU_CORE_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | INVERT_ENABLE,
 	.recalc		= &omap3_clkoutx2_recalc,
@@ -556,7 +568,7 @@ static struct clk emu_core_alwon_ck = {
 	.name		= "emu_core_alwon_ck",
 	.parent		= &dpll3_m3x2_ck,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= OMAP_CM_REGADDR(PLL_MOD, CM_IDLEST),
+	.clksel_reg	= _OMAP34XX_CM_REGADDR(PLL_MOD, CM_IDLEST),
 	.clksel_mask	= OMAP3430_ST_CORE_CLK_MASK,
 	.clksel		= emu_core_alwon_ck_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
@@ -568,19 +580,19 @@ static struct clk emu_core_alwon_ck = {
 /* Supplies 96MHz, 54Mhz TV DAC, DSS fclk, CAM sensor clock, emul trace clk */
 /* Type: DPLL */
 static struct dpll_data dpll4_dd = {
-	.mult_div1_reg	= OMAP_CM_REGADDR(PLL_MOD, CM_CLKSEL2),
+	.mult_div1_reg	= _OMAP34XX_CM_REGADDR(PLL_MOD, CM_CLKSEL2),
 	.mult_mask	= OMAP3430_PERIPH_DPLL_MULT_MASK,
 	.div1_mask	= OMAP3430_PERIPH_DPLL_DIV_MASK,
 	.freqsel_mask	= OMAP3430_PERIPH_DPLL_FREQSEL_MASK,
-	.control_reg	= OMAP_CM_REGADDR(PLL_MOD, CM_CLKEN),
+	.control_reg	= _OMAP34XX_CM_REGADDR(PLL_MOD, CM_CLKEN),
 	.enable_mask	= OMAP3430_EN_PERIPH_DPLL_MASK,
 	.modes		= (1 << DPLL_LOW_POWER_STOP) | (1 << DPLL_LOCKED),
 	.auto_recal_bit	= OMAP3430_EN_PERIPH_DPLL_DRIFTGUARD_SHIFT,
 	.recal_en_bit	= OMAP3430_PERIPH_DPLL_RECAL_EN_SHIFT,
 	.recal_st_bit	= OMAP3430_PERIPH_DPLL_ST_SHIFT,
-	.autoidle_reg	= OMAP_CM_REGADDR(PLL_MOD, CM_AUTOIDLE),
+	.autoidle_reg	= _OMAP34XX_CM_REGADDR(PLL_MOD, CM_AUTOIDLE),
 	.autoidle_mask	= OMAP3430_AUTO_PERIPH_DPLL_MASK,
-	.idlest_reg	= OMAP_CM_REGADDR(PLL_MOD, CM_IDLEST),
+	.idlest_reg	= _OMAP34XX_CM_REGADDR(PLL_MOD, CM_IDLEST),
 	.idlest_bit	= OMAP3430_ST_PERIPH_CLK_SHIFT,
 	.max_multiplier = OMAP3_MAX_DPLL_MULT,
 	.max_divider	= OMAP3_MAX_DPLL_DIV,
@@ -622,7 +634,7 @@ static struct clk dpll4_m2_ck = {
 	.name		= "dpll4_m2_ck",
 	.parent		= &dpll4_ck,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= OMAP_CM_REGADDR(PLL_MOD, OMAP3430_CM_CLKSEL3),
+	.clksel_reg	= _OMAP34XX_CM_REGADDR(PLL_MOD, OMAP3430_CM_CLKSEL3),
 	.clksel_mask	= OMAP3430_DIV_96M_MASK,
 	.clksel		= div16_dpll4_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
@@ -634,7 +646,7 @@ static struct clk dpll4_m2_ck = {
 static struct clk dpll4_m2x2_ck = {
 	.name		= "dpll4_m2x2_ck",
 	.parent		= &dpll4_m2_ck,
-	.enable_reg	= OMAP_CM_REGADDR(PLL_MOD, CM_CLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(PLL_MOD, CM_CLKEN),
 	.enable_bit	= OMAP3430_PWRDN_96M_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | INVERT_ENABLE,
 	.recalc		= &omap3_clkoutx2_recalc,
@@ -656,7 +668,7 @@ static struct clk omap_96m_alwon_fck = {
 	.name		= "omap_96m_alwon_fck",
 	.parent		= &dpll4_m2x2_ck,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= OMAP_CM_REGADDR(PLL_MOD, CM_IDLEST),
+	.clksel_reg	= _OMAP34XX_CM_REGADDR(PLL_MOD, CM_IDLEST),
 	.clksel_mask	= OMAP3430_ST_PERIPH_CLK_MASK,
 	.clksel		= omap_96m_alwon_fck_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
@@ -692,7 +704,7 @@ static struct clk omap_96m_fck = {
 	.name		= "omap_96m_fck",
 	.parent		= &sys_ck,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= OMAP_CM_REGADDR(PLL_MOD, CM_CLKSEL1),
+	.clksel_reg	= _OMAP34XX_CM_REGADDR(PLL_MOD, CM_CLKSEL1),
 	.clksel_mask	= OMAP3430_SOURCE_96M_MASK,
 	.clksel		= omap_96m_fck_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
@@ -705,7 +717,7 @@ static struct clk dpll4_m3_ck = {
 	.name		= "dpll4_m3_ck",
 	.parent		= &dpll4_ck,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= OMAP_CM_REGADDR(OMAP3430_DSS_MOD, CM_CLKSEL),
+	.clksel_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_DSS_MOD, CM_CLKSEL),
 	.clksel_mask	= OMAP3430_CLKSEL_TV_MASK,
 	.clksel		= div16_dpll4_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
@@ -718,7 +730,7 @@ static struct clk dpll4_m3x2_ck = {
 	.name		= "dpll4_m3x2_ck",
 	.parent		= &dpll4_m3_ck,
 	.init		= &omap2_init_clksel_parent,
-	.enable_reg	= OMAP_CM_REGADDR(PLL_MOD, CM_CLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(PLL_MOD, CM_CLKEN),
 	.enable_bit	= OMAP3430_PWRDN_TV_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | INVERT_ENABLE,
 	.recalc		= &omap3_clkoutx2_recalc,
@@ -734,7 +746,7 @@ static struct clk virt_omap_54m_fck = {
 	.name		= "virt_omap_54m_fck",
 	.parent		= &dpll4_m3x2_ck,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= OMAP_CM_REGADDR(PLL_MOD, CM_IDLEST),
+	.clksel_reg	= _OMAP34XX_CM_REGADDR(PLL_MOD, CM_IDLEST),
 	.clksel_mask	= OMAP3430_ST_PERIPH_CLK_MASK,
 	.clksel		= virt_omap_54m_fck_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
@@ -761,7 +773,7 @@ static const struct clksel omap_54m_clksel[] = {
 static struct clk omap_54m_fck = {
 	.name		= "omap_54m_fck",
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= OMAP_CM_REGADDR(PLL_MOD, CM_CLKSEL1),
+	.clksel_reg	= _OMAP34XX_CM_REGADDR(PLL_MOD, CM_CLKSEL1),
 	.clksel_mask	= OMAP3430_SOURCE_54M_MASK,
 	.clksel		= omap_54m_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
@@ -788,7 +800,7 @@ static const struct clksel omap_48m_clksel[] = {
 static struct clk omap_48m_fck = {
 	.name		= "omap_48m_fck",
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= OMAP_CM_REGADDR(PLL_MOD, CM_CLKSEL1),
+	.clksel_reg	= _OMAP34XX_CM_REGADDR(PLL_MOD, CM_CLKSEL1),
 	.clksel_mask	= OMAP3430_SOURCE_48M_MASK,
 	.clksel		= omap_48m_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
@@ -810,7 +822,7 @@ static struct clk dpll4_m4_ck = {
 	.name		= "dpll4_m4_ck",
 	.parent		= &dpll4_ck,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= OMAP_CM_REGADDR(OMAP3430_DSS_MOD, CM_CLKSEL),
+	.clksel_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_DSS_MOD, CM_CLKSEL),
 	.clksel_mask	= OMAP3430_CLKSEL_DSS1_MASK,
 	.clksel		= div16_dpll4_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
@@ -824,7 +836,7 @@ static struct clk dpll4_m4_ck = {
 static struct clk dpll4_m4x2_ck = {
 	.name		= "dpll4_m4x2_ck",
 	.parent		= &dpll4_m4_ck,
-	.enable_reg	= OMAP_CM_REGADDR(PLL_MOD, CM_CLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(PLL_MOD, CM_CLKEN),
 	.enable_bit	= OMAP3430_PWRDN_CAM_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | INVERT_ENABLE,
 	.recalc		= &omap3_clkoutx2_recalc,
@@ -835,7 +847,7 @@ static struct clk dpll4_m5_ck = {
 	.name		= "dpll4_m5_ck",
 	.parent		= &dpll4_ck,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= OMAP_CM_REGADDR(OMAP3430_CAM_MOD, CM_CLKSEL),
+	.clksel_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_CAM_MOD, CM_CLKSEL),
 	.clksel_mask	= OMAP3430_CLKSEL_CAM_MASK,
 	.clksel		= div16_dpll4_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
@@ -847,7 +859,7 @@ static struct clk dpll4_m5_ck = {
 static struct clk dpll4_m5x2_ck = {
 	.name		= "dpll4_m5x2_ck",
 	.parent		= &dpll4_m5_ck,
-	.enable_reg	= OMAP_CM_REGADDR(PLL_MOD, CM_CLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(PLL_MOD, CM_CLKEN),
 	.enable_bit	= OMAP3430_PWRDN_CAM_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | INVERT_ENABLE,
 	.recalc		= &omap3_clkoutx2_recalc,
@@ -858,7 +870,7 @@ static struct clk dpll4_m6_ck = {
 	.name		= "dpll4_m6_ck",
 	.parent		= &dpll4_ck,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= OMAP_CM_REGADDR(OMAP3430_EMU_MOD, CM_CLKSEL1),
+	.clksel_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_EMU_MOD, CM_CLKSEL1),
 	.clksel_mask	= OMAP3430_DIV_DPLL4_MASK,
 	.clksel		= div16_dpll4_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
@@ -871,7 +883,7 @@ static struct clk dpll4_m6x2_ck = {
 	.name		= "dpll4_m6x2_ck",
 	.parent		= &dpll4_m6_ck,
 	.init		= &omap2_init_clksel_parent,
-	.enable_reg	= OMAP_CM_REGADDR(PLL_MOD, CM_CLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(PLL_MOD, CM_CLKEN),
 	.enable_bit	= OMAP3430_PWRDN_EMU_PERIPH_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | INVERT_ENABLE,
 	.recalc		= &omap3_clkoutx2_recalc,
@@ -890,19 +902,19 @@ static struct clk emu_per_alwon_ck = {
 /* Type: DPLL */
 /* 3430ES2 only */
 static struct dpll_data dpll5_dd = {
-	.mult_div1_reg	= OMAP_CM_REGADDR(PLL_MOD, OMAP3430ES2_CM_CLKSEL4),
+	.mult_div1_reg	= _OMAP34XX_CM_REGADDR(PLL_MOD, OMAP3430ES2_CM_CLKSEL4),
 	.mult_mask	= OMAP3430ES2_PERIPH2_DPLL_MULT_MASK,
 	.div1_mask	= OMAP3430ES2_PERIPH2_DPLL_DIV_MASK,
 	.freqsel_mask	= OMAP3430ES2_PERIPH2_DPLL_FREQSEL_MASK,
-	.control_reg	= OMAP_CM_REGADDR(PLL_MOD, OMAP3430ES2_CM_CLKEN2),
+	.control_reg	= _OMAP34XX_CM_REGADDR(PLL_MOD, OMAP3430ES2_CM_CLKEN2),
 	.enable_mask	= OMAP3430ES2_EN_PERIPH2_DPLL_MASK,
 	.modes		= (1 << DPLL_LOW_POWER_STOP) | (1 << DPLL_LOCKED),
 	.auto_recal_bit	= OMAP3430ES2_EN_PERIPH2_DPLL_DRIFTGUARD_SHIFT,
 	.recal_en_bit	= OMAP3430ES2_SND_PERIPH_DPLL_RECAL_EN_SHIFT,
 	.recal_st_bit	= OMAP3430ES2_SND_PERIPH_DPLL_ST_SHIFT,
-	.autoidle_reg	= OMAP_CM_REGADDR(PLL_MOD, OMAP3430ES2_CM_AUTOIDLE2_PLL),
+	.autoidle_reg	= _OMAP34XX_CM_REGADDR(PLL_MOD, OMAP3430ES2_CM_AUTOIDLE2_PLL),
 	.autoidle_mask	= OMAP3430ES2_AUTO_PERIPH2_DPLL_MASK,
-	.idlest_reg	= OMAP_CM_REGADDR(PLL_MOD, CM_IDLEST2),
+	.idlest_reg	= _OMAP34XX_CM_REGADDR(PLL_MOD, CM_IDLEST2),
 	.idlest_bit	= OMAP3430ES2_ST_PERIPH2_CLK_SHIFT,
 	.max_multiplier = OMAP3_MAX_DPLL_MULT,
 	.max_divider	= OMAP3_MAX_DPLL_DIV,
@@ -930,7 +942,7 @@ static struct clk dpll5_m2_ck = {
 	.name		= "dpll5_m2_ck",
 	.parent		= &dpll5_ck,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= OMAP_CM_REGADDR(PLL_MOD, OMAP3430ES2_CM_CLKSEL5),
+	.clksel_reg	= _OMAP34XX_CM_REGADDR(PLL_MOD, OMAP3430ES2_CM_CLKSEL5),
 	.clksel_mask	= OMAP3430ES2_DIV_120M_MASK,
 	.clksel		= div16_dpll5_clksel,
 	.flags		= CLOCK_IN_OMAP3430ES2 | RATE_PROPAGATES |
@@ -948,7 +960,7 @@ static struct clk omap_120m_fck = {
 	.name		= "omap_120m_fck",
 	.parent		= &dpll5_m2_ck,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= OMAP_CM_REGADDR(PLL_MOD, CM_IDLEST2),
+	.clksel_reg	= _OMAP34XX_CM_REGADDR(PLL_MOD, CM_IDLEST2),
 	.clksel_mask	= OMAP3430ES2_ST_PERIPH2_CLK_MASK,
 	.clksel		= omap_120m_fck_clksel,
 	.flags		= CLOCK_IN_OMAP3430ES2 | RATE_PROPAGATES |
@@ -989,9 +1001,9 @@ static const struct clksel clkout2_src_clksel[] = {
 static struct clk clkout2_src_ck = {
 	.name		= "clkout2_src_ck",
 	.init		= &omap2_init_clksel_parent,
-	.enable_reg	= OMAP3430_CM_CLKOUT_CTRL,
+	.enable_reg	= (__force void __iomem *)OMAP3430_CM_CLKOUT_CTRL,
 	.enable_bit	= OMAP3430_CLKOUT2_EN_SHIFT,
-	.clksel_reg	= OMAP3430_CM_CLKOUT_CTRL,
+	.clksel_reg	= (__force void __iomem *)OMAP3430_CM_CLKOUT_CTRL,
 	.clksel_mask	= OMAP3430_CLKOUT2SOURCE_MASK,
 	.clksel		= clkout2_src_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES,
@@ -1015,7 +1027,7 @@ static const struct clksel sys_clkout2_clksel[] = {
 static struct clk sys_clkout2 = {
 	.name		= "sys_clkout2",
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= OMAP3430_CM_CLKOUT_CTRL,
+	.clksel_reg	= (__force void __iomem *)OMAP3430_CM_CLKOUT_CTRL,
 	.clksel_mask	= OMAP3430_CLKOUT2_DIV_MASK,
 	.clksel		= sys_clkout2_clksel,
 	.flags		= CLOCK_IN_OMAP343X | PARENT_CONTROLS_CLOCK,
@@ -1047,7 +1059,7 @@ static struct clk dpll1_fck = {
 	.name		= "dpll1_fck",
 	.parent		= &core_ck,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= OMAP_CM_REGADDR(MPU_MOD, OMAP3430_CM_CLKSEL1_PLL),
+	.clksel_reg	= _OMAP34XX_CM_REGADDR(MPU_MOD, OMAP3430_CM_CLKSEL1_PLL),
 	.clksel_mask	= OMAP3430_MPU_CLK_SRC_MASK,
 	.clksel		= div2_core_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
@@ -1071,7 +1083,7 @@ static struct clk mpu_ck = {
 	.name		= "mpu_ck",
 	.parent		= &dpll1_x2m2_ck,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= OMAP_CM_REGADDR(MPU_MOD, OMAP3430_CM_IDLEST_PLL),
+	.clksel_reg	= _OMAP34XX_CM_REGADDR(MPU_MOD, OMAP3430_CM_IDLEST_PLL),
 	.clksel_mask	= OMAP3430_ST_MPU_CLK_MASK,
 	.clksel		= mpu_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
@@ -1096,7 +1108,7 @@ static struct clk arm_fck = {
 	.name		= "arm_fck",
 	.parent		= &mpu_ck,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= OMAP_CM_REGADDR(MPU_MOD, OMAP3430_CM_IDLEST_PLL),
+	.clksel_reg	= _OMAP34XX_CM_REGADDR(MPU_MOD, OMAP3430_CM_IDLEST_PLL),
 	.clksel_mask	= OMAP3430_ST_MPU_CLK_MASK,
 	.clksel		= arm_fck_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
@@ -1122,7 +1134,7 @@ static struct clk dpll2_fck = {
 	.name		= "dpll2_fck",
 	.parent		= &core_ck,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= OMAP_CM_REGADDR(OMAP3430_IVA2_MOD, OMAP3430_CM_CLKSEL1_PLL),
+	.clksel_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_IVA2_MOD, OMAP3430_CM_CLKSEL1_PLL),
 	.clksel_mask	= OMAP3430_IVA2_CLK_SRC_MASK,
 	.clksel		= div2_core_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
@@ -1147,9 +1159,9 @@ static struct clk iva2_ck = {
 	.name		= "iva2_ck",
 	.parent		= &dpll2_m2_ck,
 	.init		= &omap2_init_clksel_parent,
-	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_IVA2_MOD, CM_FCLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_IVA2_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_CM_FCLKEN_IVA2_EN_IVA2_SHIFT,
-	.clksel_reg	= OMAP_CM_REGADDR(OMAP3430_IVA2_MOD,
+	.clksel_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_IVA2_MOD,
 					  OMAP3430_CM_IDLEST_PLL),
 	.clksel_mask	= OMAP3430_ST_IVA2_CLK_MASK,
 	.clksel		= iva2_clksel,
@@ -1164,7 +1176,7 @@ static struct clk l3_ick = {
 	.name		= "l3_ick",
 	.parent		= &core_ck,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_CLKSEL),
+	.clksel_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_CLKSEL),
 	.clksel_mask	= OMAP3430_CLKSEL_L3_MASK,
 	.clksel		= div2_core_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
@@ -1182,7 +1194,7 @@ static struct clk l4_ick = {
 	.name		= "l4_ick",
 	.parent		= &l3_ick,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_CLKSEL),
+	.clksel_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_CLKSEL),
 	.clksel_mask	= OMAP3430_CLKSEL_L4_MASK,
 	.clksel		= div2_l3_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
@@ -1201,7 +1213,7 @@ static struct clk rm_ick = {
 	.name		= "rm_ick",
 	.parent		= &l4_ick,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= OMAP_CM_REGADDR(WKUP_MOD, CM_CLKSEL),
+	.clksel_reg	= _OMAP34XX_CM_REGADDR(WKUP_MOD, CM_CLKSEL),
 	.clksel_mask	= OMAP3430_CLKSEL_RM_MASK,
 	.clksel		= div2_l4_clksel,
 	.flags		= CLOCK_IN_OMAP343X | PARENT_CONTROLS_CLOCK,
@@ -1222,7 +1234,7 @@ static struct clk gfx_l3_ck = {
 	.name		= "gfx_l3_ck",
 	.parent		= &l3_ick,
 	.init		= &omap2_init_clksel_parent,
-	.enable_reg	= OMAP_CM_REGADDR(GFX_MOD, CM_ICLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(GFX_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP_EN_GFX_SHIFT,
 	.flags		= CLOCK_IN_OMAP3430ES1,
 	.recalc		= &followparent_recalc,
@@ -1232,7 +1244,7 @@ static struct clk gfx_l3_fck = {
 	.name		= "gfx_l3_fck",
 	.parent		= &gfx_l3_ck,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= OMAP_CM_REGADDR(GFX_MOD, CM_CLKSEL),
+	.clksel_reg	= _OMAP34XX_CM_REGADDR(GFX_MOD, CM_CLKSEL),
 	.clksel_mask	= OMAP_CLKSEL_GFX_MASK,
 	.clksel		= gfx_l3_clksel,
 	.flags		= CLOCK_IN_OMAP3430ES1 | RATE_PROPAGATES |
@@ -1253,7 +1265,7 @@ static struct clk gfx_cg1_ck = {
 	.name		= "gfx_cg1_ck",
 	.parent		= &gfx_l3_fck, /* REVISIT: correct? */
 	.init		= &omap2_init_clk_clkdm,
-	.enable_reg	= OMAP_CM_REGADDR(GFX_MOD, CM_FCLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(GFX_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430ES1_EN_2D_SHIFT,
 	.flags		= CLOCK_IN_OMAP3430ES1,
 	.clkdm_name	= "gfx_3430es1_clkdm",
@@ -1264,7 +1276,7 @@ static struct clk gfx_cg2_ck = {
 	.name		= "gfx_cg2_ck",
 	.parent		= &gfx_l3_fck, /* REVISIT: correct? */
 	.init		= &omap2_init_clk_clkdm,
-	.enable_reg	= OMAP_CM_REGADDR(GFX_MOD, CM_FCLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(GFX_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430ES1_EN_3D_SHIFT,
 	.flags		= CLOCK_IN_OMAP3430ES1,
 	.clkdm_name	= "gfx_3430es1_clkdm",
@@ -1294,9 +1306,9 @@ static const struct clksel sgx_clksel[] = {
 static struct clk sgx_fck = {
 	.name		= "sgx_fck",
 	.init		= &omap2_init_clksel_parent,
-	.enable_reg	= OMAP_CM_REGADDR(OMAP3430ES2_SGX_MOD, CM_FCLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430ES2_SGX_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430ES2_CM_FCLKEN_SGX_EN_SGX_SHIFT,
-	.clksel_reg	= OMAP_CM_REGADDR(OMAP3430ES2_SGX_MOD, CM_CLKSEL),
+	.clksel_reg	= _OMAP34XX_CM_REGADDR(OMAP3430ES2_SGX_MOD, CM_CLKSEL),
 	.clksel_mask	= OMAP3430ES2_CLKSEL_SGX_MASK,
 	.clksel		= sgx_clksel,
 	.flags		= CLOCK_IN_OMAP3430ES2,
@@ -1308,7 +1320,7 @@ static struct clk sgx_ick = {
 	.name		= "sgx_ick",
 	.parent		= &l3_ick,
 	.init		= &omap2_init_clk_clkdm,
-	.enable_reg	= OMAP_CM_REGADDR(OMAP3430ES2_SGX_MOD, CM_ICLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430ES2_SGX_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430ES2_CM_ICLKEN_SGX_EN_SGX_SHIFT,
 	.flags		= CLOCK_IN_OMAP3430ES2,
 	.clkdm_name	= "sgx_clkdm",
@@ -1321,7 +1333,7 @@ static struct clk d2d_26m_fck = {
 	.name		= "d2d_26m_fck",
 	.parent		= &sys_ck,
 	.init		= &omap2_init_clk_clkdm,
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP3430ES1_EN_D2D_SHIFT,
 	.flags		= CLOCK_IN_OMAP3430ES1,
 	.clkdm_name	= "d2d_clkdm",
@@ -1338,9 +1350,9 @@ static struct clk gpt10_fck = {
 	.name		= "gpt10_fck",
 	.parent		= &sys_ck,
 	.init		= &omap2_init_clksel_parent,
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP3430_EN_GPT10_SHIFT,
-	.clksel_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_CLKSEL),
+	.clksel_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_CLKSEL),
 	.clksel_mask	= OMAP3430_CLKSEL_GPT10_MASK,
 	.clksel		= omap343x_gpt_clksel,
 	.flags		= CLOCK_IN_OMAP343X,
@@ -1352,9 +1364,9 @@ static struct clk gpt11_fck = {
 	.name		= "gpt11_fck",
 	.parent		= &sys_ck,
 	.init		= &omap2_init_clksel_parent,
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP3430_EN_GPT11_SHIFT,
-	.clksel_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_CLKSEL),
+	.clksel_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_CLKSEL),
 	.clksel_mask	= OMAP3430_CLKSEL_GPT11_MASK,
 	.clksel		= omap343x_gpt_clksel,
 	.flags		= CLOCK_IN_OMAP343X,
@@ -1365,7 +1377,7 @@ static struct clk gpt11_fck = {
 static struct clk cpefuse_fck = {
 	.name		= "cpefuse_fck",
 	.parent		= &sys_ck,
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, OMAP3430ES2_CM_FCLKEN3),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, OMAP3430ES2_CM_FCLKEN3),
 	.enable_bit	= OMAP3430ES2_EN_CPEFUSE_SHIFT,
 	.flags		= CLOCK_IN_OMAP3430ES2,
 	.recalc		= &followparent_recalc,
@@ -1374,7 +1386,7 @@ static struct clk cpefuse_fck = {
 static struct clk ts_fck = {
 	.name		= "ts_fck",
 	.parent		= &omap_32k_fck,
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, OMAP3430ES2_CM_FCLKEN3),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, OMAP3430ES2_CM_FCLKEN3),
 	.enable_bit	= OMAP3430ES2_EN_TS_SHIFT,
 	.flags		= CLOCK_IN_OMAP3430ES2,
 	.recalc		= &followparent_recalc,
@@ -1383,7 +1395,7 @@ static struct clk ts_fck = {
 static struct clk usbtll_fck = {
 	.name		= "usbtll_fck",
 	.parent		= &omap_120m_fck,
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, OMAP3430ES2_CM_FCLKEN3),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, OMAP3430ES2_CM_FCLKEN3),
 	.enable_bit	= OMAP3430ES2_EN_USBTLL_SHIFT,
 	.flags		= CLOCK_IN_OMAP3430ES2,
 	.recalc		= &followparent_recalc,
@@ -1404,7 +1416,7 @@ static struct clk mmchs3_fck = {
 	.name		= "mmchs_fck",
 	.id		= 2,
 	.parent		= &core_96m_fck,
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP3430ES2_EN_MMC3_SHIFT,
 	.flags		= CLOCK_IN_OMAP3430ES2,
 	.clkdm_name	= "core_l4_clkdm",
@@ -1415,7 +1427,7 @@ static struct clk mmchs2_fck = {
 	.name		= "mmchs_fck",
 	.id		= 1,
 	.parent		= &core_96m_fck,
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP3430_EN_MMC2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm_name	= "core_l4_clkdm",
@@ -1425,7 +1437,7 @@ static struct clk mmchs2_fck = {
 static struct clk mspro_fck = {
 	.name		= "mspro_fck",
 	.parent		= &core_96m_fck,
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP3430_EN_MSPRO_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm_name	= "core_l4_clkdm",
@@ -1435,7 +1447,7 @@ static struct clk mspro_fck = {
 static struct clk mmchs1_fck = {
 	.name		= "mmchs_fck",
 	.parent		= &core_96m_fck,
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP3430_EN_MMC1_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm_name	= "core_l4_clkdm",
@@ -1446,7 +1458,7 @@ static struct clk i2c3_fck = {
 	.name		= "i2c_fck",
 	.id		= 3,
 	.parent		= &core_96m_fck,
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP3430_EN_I2C3_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm_name	= "core_l4_clkdm",
@@ -1457,7 +1469,7 @@ static struct clk i2c2_fck = {
 	.name		= "i2c_fck",
 	.id		= 2,
 	.parent		= &core_96m_fck,
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP3430_EN_I2C2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm_name	= "core_l4_clkdm",
@@ -1468,7 +1480,7 @@ static struct clk i2c1_fck = {
 	.name		= "i2c_fck",
 	.id		= 1,
 	.parent		= &core_96m_fck,
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP3430_EN_I2C1_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm_name	= "core_l4_clkdm",
@@ -1499,7 +1511,7 @@ static struct clk mcbsp5_fck = {
 	.name		= "mcbsp_fck",
 	.id		= 5,
 	.init		= &omap2_init_clksel_parent,
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP3430_EN_MCBSP5_SHIFT,
 	.clksel_reg	= OMAP343X_CTRL_REGADDR(OMAP343X_CONTROL_DEVCONF1),
 	.clksel_mask	= OMAP2_MCBSP5_CLKS_MASK,
@@ -1513,7 +1525,7 @@ static struct clk mcbsp1_fck = {
 	.name		= "mcbsp_fck",
 	.id		= 1,
 	.init		= &omap2_init_clksel_parent,
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP3430_EN_MCBSP1_SHIFT,
 	.clksel_reg	= OMAP343X_CTRL_REGADDR(OMAP2_CONTROL_DEVCONF0),
 	.clksel_mask	= OMAP2_MCBSP1_CLKS_MASK,
@@ -1538,7 +1550,7 @@ static struct clk mcspi4_fck = {
 	.name		= "mcspi_fck",
 	.id		= 4,
 	.parent		= &core_48m_fck,
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP3430_EN_MCSPI4_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.recalc		= &followparent_recalc,
@@ -1548,7 +1560,7 @@ static struct clk mcspi3_fck = {
 	.name		= "mcspi_fck",
 	.id		= 3,
 	.parent		= &core_48m_fck,
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP3430_EN_MCSPI3_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.recalc		= &followparent_recalc,
@@ -1558,7 +1570,7 @@ static struct clk mcspi2_fck = {
 	.name		= "mcspi_fck",
 	.id		= 2,
 	.parent		= &core_48m_fck,
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP3430_EN_MCSPI2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.recalc		= &followparent_recalc,
@@ -1568,7 +1580,7 @@ static struct clk mcspi1_fck = {
 	.name		= "mcspi_fck",
 	.id		= 1,
 	.parent		= &core_48m_fck,
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP3430_EN_MCSPI1_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.recalc		= &followparent_recalc,
@@ -1577,7 +1589,7 @@ static struct clk mcspi1_fck = {
 static struct clk uart2_fck = {
 	.name		= "uart2_fck",
 	.parent		= &core_48m_fck,
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP3430_EN_UART2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.recalc		= &followparent_recalc,
@@ -1586,7 +1598,7 @@ static struct clk uart2_fck = {
 static struct clk uart1_fck = {
 	.name		= "uart1_fck",
 	.parent		= &core_48m_fck,
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP3430_EN_UART1_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.recalc		= &followparent_recalc,
@@ -1595,7 +1607,7 @@ static struct clk uart1_fck = {
 static struct clk fshostusb_fck = {
 	.name		= "fshostusb_fck",
 	.parent		= &core_48m_fck,
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP3430ES1_EN_FSHOSTUSB_SHIFT,
 	.flags		= CLOCK_IN_OMAP3430ES1,
 	.recalc		= &followparent_recalc,
@@ -1615,7 +1627,7 @@ static struct clk core_12m_fck = {
 static struct clk hdq_fck = {
 	.name		= "hdq_fck",
 	.parent		= &core_12m_fck,
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP3430_EN_HDQ_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.recalc		= &followparent_recalc,
@@ -1641,9 +1653,9 @@ static const struct clksel ssi_ssr_clksel[] = {
 static struct clk ssi_ssr_fck = {
 	.name		= "ssi_ssr_fck",
 	.init		= &omap2_init_clksel_parent,
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP3430_EN_SSI_SHIFT,
-	.clksel_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_CLKSEL),
+	.clksel_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_CLKSEL),
 	.clksel_mask	= OMAP3430_CLKSEL_SSI_MASK,
 	.clksel		= ssi_ssr_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES,
@@ -1680,7 +1692,7 @@ static struct clk core_l3_ick = {
 static struct clk hsotgusb_ick = {
 	.name		= "hsotgusb_ick",
 	.parent		= &core_l3_ick,
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_HSOTGUSB_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm_name	= "core_l3_clkdm",
@@ -1690,7 +1702,7 @@ static struct clk hsotgusb_ick = {
 static struct clk sdrc_ick = {
 	.name		= "sdrc_ick",
 	.parent		= &core_l3_ick,
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_SDRC_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X | ENABLE_ON_INIT,
 	.clkdm_name	= "core_l3_clkdm",
@@ -1719,7 +1731,7 @@ static struct clk security_l3_ick = {
 static struct clk pka_ick = {
 	.name		= "pka_ick",
 	.parent		= &security_l3_ick,
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN2),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN2),
 	.enable_bit	= OMAP3430_EN_PKA_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.recalc		= &followparent_recalc,
@@ -1740,7 +1752,7 @@ static struct clk core_l4_ick = {
 static struct clk usbtll_ick = {
 	.name		= "usbtll_ick",
 	.parent		= &core_l4_ick,
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN3),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN3),
 	.enable_bit	= OMAP3430ES2_EN_USBTLL_SHIFT,
 	.flags		= CLOCK_IN_OMAP3430ES2,
 	.clkdm_name	= "core_l4_clkdm",
@@ -1751,7 +1763,7 @@ static struct clk mmchs3_ick = {
 	.name		= "mmchs_ick",
 	.id		= 2,
 	.parent		= &core_l4_ick,
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430ES2_EN_MMC3_SHIFT,
 	.flags		= CLOCK_IN_OMAP3430ES2,
 	.clkdm_name	= "core_l4_clkdm",
@@ -1762,7 +1774,7 @@ static struct clk mmchs3_ick = {
 static struct clk icr_ick = {
 	.name		= "icr_ick",
 	.parent		= &core_l4_ick,
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_ICR_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm_name	= "core_l4_clkdm",
@@ -1772,7 +1784,7 @@ static struct clk icr_ick = {
 static struct clk aes2_ick = {
 	.name		= "aes2_ick",
 	.parent		= &core_l4_ick,
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_AES2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm_name	= "core_l4_clkdm",
@@ -1782,7 +1794,7 @@ static struct clk aes2_ick = {
 static struct clk sha12_ick = {
 	.name		= "sha12_ick",
 	.parent		= &core_l4_ick,
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_SHA12_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm_name	= "core_l4_clkdm",
@@ -1792,7 +1804,7 @@ static struct clk sha12_ick = {
 static struct clk des2_ick = {
 	.name		= "des2_ick",
 	.parent		= &core_l4_ick,
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_DES2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm_name	= "core_l4_clkdm",
@@ -1803,7 +1815,7 @@ static struct clk mmchs2_ick = {
 	.name		= "mmchs_ick",
 	.id		= 1,
 	.parent		= &core_l4_ick,
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_MMC2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm_name	= "core_l4_clkdm",
@@ -1813,7 +1825,7 @@ static struct clk mmchs2_ick = {
 static struct clk mmchs1_ick = {
 	.name		= "mmchs_ick",
 	.parent		= &core_l4_ick,
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_MMC1_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm_name	= "core_l4_clkdm",
@@ -1823,7 +1835,7 @@ static struct clk mmchs1_ick = {
 static struct clk mspro_ick = {
 	.name		= "mspro_ick",
 	.parent		= &core_l4_ick,
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_MSPRO_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm_name	= "core_l4_clkdm",
@@ -1833,7 +1845,7 @@ static struct clk mspro_ick = {
 static struct clk hdq_ick = {
 	.name		= "hdq_ick",
 	.parent		= &core_l4_ick,
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_HDQ_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm_name	= "core_l4_clkdm",
@@ -1844,7 +1856,7 @@ static struct clk mcspi4_ick = {
 	.name		= "mcspi_ick",
 	.id		= 4,
 	.parent		= &core_l4_ick,
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_MCSPI4_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm_name	= "core_l4_clkdm",
@@ -1855,7 +1867,7 @@ static struct clk mcspi3_ick = {
 	.name		= "mcspi_ick",
 	.id		= 3,
 	.parent		= &core_l4_ick,
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_MCSPI3_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm_name	= "core_l4_clkdm",
@@ -1866,7 +1878,7 @@ static struct clk mcspi2_ick = {
 	.name		= "mcspi_ick",
 	.id		= 2,
 	.parent		= &core_l4_ick,
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_MCSPI2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm_name	= "core_l4_clkdm",
@@ -1877,7 +1889,7 @@ static struct clk mcspi1_ick = {
 	.name		= "mcspi_ick",
 	.id		= 1,
 	.parent		= &core_l4_ick,
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_MCSPI1_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm_name	= "core_l4_clkdm",
@@ -1888,7 +1900,7 @@ static struct clk i2c3_ick = {
 	.name		= "i2c_ick",
 	.id		= 3,
 	.parent		= &core_l4_ick,
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_I2C3_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm_name	= "core_l4_clkdm",
@@ -1899,7 +1911,7 @@ static struct clk i2c2_ick = {
 	.name		= "i2c_ick",
 	.id		= 2,
 	.parent		= &core_l4_ick,
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_I2C2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm_name	= "core_l4_clkdm",
@@ -1910,7 +1922,7 @@ static struct clk i2c1_ick = {
 	.name		= "i2c_ick",
 	.id		= 1,
 	.parent		= &core_l4_ick,
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_I2C1_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm_name	= "core_l4_clkdm",
@@ -1920,7 +1932,7 @@ static struct clk i2c1_ick = {
 static struct clk uart2_ick = {
 	.name		= "uart2_ick",
 	.parent		= &core_l4_ick,
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_UART2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm_name	= "core_l4_clkdm",
@@ -1930,7 +1942,7 @@ static struct clk uart2_ick = {
 static struct clk uart1_ick = {
 	.name		= "uart1_ick",
 	.parent		= &core_l4_ick,
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_UART1_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm_name	= "core_l4_clkdm",
@@ -1940,7 +1952,7 @@ static struct clk uart1_ick = {
 static struct clk gpt11_ick = {
 	.name		= "gpt11_ick",
 	.parent		= &core_l4_ick,
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_GPT11_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm_name	= "core_l4_clkdm",
@@ -1950,7 +1962,7 @@ static struct clk gpt11_ick = {
 static struct clk gpt10_ick = {
 	.name		= "gpt10_ick",
 	.parent		= &core_l4_ick,
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_GPT10_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm_name	= "core_l4_clkdm",
@@ -1961,7 +1973,7 @@ static struct clk mcbsp5_ick = {
 	.name		= "mcbsp_ick",
 	.id		= 5,
 	.parent		= &core_l4_ick,
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_MCBSP5_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm_name	= "core_l4_clkdm",
@@ -1972,7 +1984,7 @@ static struct clk mcbsp1_ick = {
 	.name		= "mcbsp_ick",
 	.id		= 1,
 	.parent		= &core_l4_ick,
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_MCBSP1_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm_name	= "core_l4_clkdm",
@@ -1982,7 +1994,7 @@ static struct clk mcbsp1_ick = {
 static struct clk fac_ick = {
 	.name		= "fac_ick",
 	.parent		= &core_l4_ick,
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430ES1_EN_FAC_SHIFT,
 	.flags		= CLOCK_IN_OMAP3430ES1,
 	.clkdm_name	= "core_l4_clkdm",
@@ -1992,7 +2004,7 @@ static struct clk fac_ick = {
 static struct clk mailboxes_ick = {
 	.name		= "mailboxes_ick",
 	.parent		= &core_l4_ick,
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_MAILBOXES_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm_name	= "core_l4_clkdm",
@@ -2002,7 +2014,7 @@ static struct clk mailboxes_ick = {
 static struct clk omapctrl_ick = {
 	.name		= "omapctrl_ick",
 	.parent		= &core_l4_ick,
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_OMAPCTRL_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X | ENABLE_ON_INIT,
 	.recalc		= &followparent_recalc,
@@ -2022,7 +2034,7 @@ static struct clk ssi_l4_ick = {
 static struct clk ssi_ick = {
 	.name		= "ssi_ick",
 	.parent		= &ssi_l4_ick,
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_SSI_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm_name	= "core_l4_clkdm",
@@ -2041,9 +2053,9 @@ static struct clk usb_l4_ick = {
 	.name		= "usb_l4_ick",
 	.parent		= &l4_ick,
 	.init		= &omap2_init_clksel_parent,
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430ES1_EN_FSHOSTUSB_SHIFT,
-	.clksel_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_CLKSEL),
+	.clksel_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_CLKSEL),
 	.clksel_mask	= OMAP3430ES1_CLKSEL_FSHOSTUSB_MASK,
 	.clksel		= usb_l4_clksel,
 	.flags		= CLOCK_IN_OMAP3430ES1,
@@ -2065,7 +2077,7 @@ static struct clk security_l4_ick2 = {
 static struct clk aes1_ick = {
 	.name		= "aes1_ick",
 	.parent		= &security_l4_ick2,
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN2),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN2),
 	.enable_bit	= OMAP3430_EN_AES1_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.recalc		= &followparent_recalc,
@@ -2074,7 +2086,7 @@ static struct clk aes1_ick = {
 static struct clk rng_ick = {
 	.name		= "rng_ick",
 	.parent		= &security_l4_ick2,
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN2),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN2),
 	.enable_bit	= OMAP3430_EN_RNG_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.recalc		= &followparent_recalc,
@@ -2083,7 +2095,7 @@ static struct clk rng_ick = {
 static struct clk sha11_ick = {
 	.name		= "sha11_ick",
 	.parent		= &security_l4_ick2,
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN2),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN2),
 	.enable_bit	= OMAP3430_EN_SHA11_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.recalc		= &followparent_recalc,
@@ -2092,7 +2104,7 @@ static struct clk sha11_ick = {
 static struct clk des1_ick = {
 	.name		= "des1_ick",
 	.parent		= &security_l4_ick2,
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN2),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN2),
 	.enable_bit	= OMAP3430_EN_DES1_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.recalc		= &followparent_recalc,
@@ -2109,9 +2121,9 @@ static struct clk dss1_alwon_fck = {
 	.name		= "dss1_alwon_fck",
 	.parent		= &dpll4_m4x2_ck,
 	.init		= &omap2_init_clksel_parent,
-	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_DSS_MOD, CM_FCLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_DSS_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_EN_DSS1_SHIFT,
-	.clksel_reg	= OMAP_CM_REGADDR(PLL_MOD, CM_IDLEST),
+	.clksel_reg	= _OMAP34XX_CM_REGADDR(PLL_MOD, CM_IDLEST),
 	.clksel_mask	= OMAP3430_ST_PERIPH_CLK_MASK,
 	.clksel		= dss1_alwon_fck_clksel,
 	.flags		= CLOCK_IN_OMAP343X,
@@ -2123,7 +2135,7 @@ static struct clk dss_tv_fck = {
 	.name		= "dss_tv_fck",
 	.parent		= &omap_54m_fck,
 	.init		= &omap2_init_clk_clkdm,
-	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_DSS_MOD, CM_FCLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_DSS_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_EN_TV_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm_name	= "dss_clkdm",
@@ -2134,7 +2146,7 @@ static struct clk dss_96m_fck = {
 	.name		= "dss_96m_fck",
 	.parent		= &omap_96m_fck,
 	.init		= &omap2_init_clk_clkdm,
-	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_DSS_MOD, CM_FCLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_DSS_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_EN_TV_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm_name	= "dss_clkdm",
@@ -2145,7 +2157,7 @@ static struct clk dss2_alwon_fck = {
 	.name		= "dss2_alwon_fck",
 	.parent		= &sys_ck,
 	.init		= &omap2_init_clk_clkdm,
-	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_DSS_MOD, CM_FCLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_DSS_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_EN_DSS2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm_name	= "dss_clkdm",
@@ -2157,7 +2169,7 @@ static struct clk dss_ick = {
 	.name		= "dss_ick",
 	.parent		= &l4_ick,
 	.init		= &omap2_init_clk_clkdm,
-	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_DSS_MOD, CM_ICLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_DSS_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_CM_ICLKEN_DSS_EN_DSS_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm_name	= "dss_clkdm",
@@ -2176,10 +2188,10 @@ static struct clk cam_mclk = {
 	.name		= "cam_mclk",
 	.parent		= &dpll4_m5x2_ck,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= OMAP_CM_REGADDR(PLL_MOD, CM_IDLEST),
+	.clksel_reg	= _OMAP34XX_CM_REGADDR(PLL_MOD, CM_IDLEST),
 	.clksel_mask	= OMAP3430_ST_PERIPH_CLK_MASK,
 	.clksel		= cam_mclk_clksel,
-	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_CAM_MOD, CM_FCLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_CAM_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_EN_CAM_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm_name	= "cam_clkdm",
@@ -2191,7 +2203,7 @@ static struct clk cam_ick = {
 	.name		= "cam_ick",
 	.parent		= &l4_ick,
 	.init		= &omap2_init_clk_clkdm,
-	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_CAM_MOD, CM_ICLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_CAM_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_CAM_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm_name	= "cam_clkdm",
@@ -2202,7 +2214,7 @@ static struct clk csi2_96m_fck = {
 	.name		= "csi2_96m_fck",
 	.parent		= &core_96m_fck,
 	.init		= &omap2_init_clk_clkdm,
-	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_CAM_MOD, CM_FCLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_CAM_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_EN_CSI2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm_name	= "cam_clkdm",
@@ -2215,7 +2227,7 @@ static struct clk usbhost_120m_fck = {
 	.name		= "usbhost_120m_fck",
 	.parent		= &omap_120m_fck,
 	.init		= &omap2_init_clk_clkdm,
-	.enable_reg	= OMAP_CM_REGADDR(OMAP3430ES2_USBHOST_MOD, CM_FCLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430ES2_USBHOST_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430ES2_EN_USBHOST2_SHIFT,
 	.flags		= CLOCK_IN_OMAP3430ES2,
 	.clkdm_name	= "usbhost_clkdm",
@@ -2226,7 +2238,7 @@ static struct clk usbhost_48m_fck = {
 	.name		= "usbhost_48m_fck",
 	.parent		= &omap_48m_fck,
 	.init		= &omap2_init_clk_clkdm,
-	.enable_reg	= OMAP_CM_REGADDR(OMAP3430ES2_USBHOST_MOD, CM_FCLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430ES2_USBHOST_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430ES2_EN_USBHOST1_SHIFT,
 	.flags		= CLOCK_IN_OMAP3430ES2,
 	.clkdm_name	= "usbhost_clkdm",
@@ -2238,7 +2250,7 @@ static struct clk usbhost_ick = {
 	.name		= "usbhost_ick",
 	.parent		= &l4_ick,
 	.init		= &omap2_init_clk_clkdm,
-	.enable_reg	= OMAP_CM_REGADDR(OMAP3430ES2_USBHOST_MOD, CM_ICLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430ES2_USBHOST_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430ES2_EN_USBHOST_SHIFT,
 	.flags		= CLOCK_IN_OMAP3430ES2,
 	.clkdm_name	= "usbhost_clkdm",
@@ -2274,9 +2286,9 @@ static const struct clksel usim_clksel[] = {
 static struct clk usim_fck = {
 	.name		= "usim_fck",
 	.init		= &omap2_init_clksel_parent,
-	.enable_reg	= OMAP_CM_REGADDR(WKUP_MOD, CM_FCLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(WKUP_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430ES2_EN_USIMOCP_SHIFT,
-	.clksel_reg	= OMAP_CM_REGADDR(WKUP_MOD, CM_CLKSEL),
+	.clksel_reg	= _OMAP34XX_CM_REGADDR(WKUP_MOD, CM_CLKSEL),
 	.clksel_mask	= OMAP3430ES2_CLKSEL_USIMOCP_MASK,
 	.clksel		= usim_clksel,
 	.flags		= CLOCK_IN_OMAP3430ES2,
@@ -2287,9 +2299,9 @@ static struct clk usim_fck = {
 static struct clk gpt1_fck = {
 	.name		= "gpt1_fck",
 	.init		= &omap2_init_clksel_parent,
-	.enable_reg	= OMAP_CM_REGADDR(WKUP_MOD, CM_FCLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(WKUP_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_EN_GPT1_SHIFT,
-	.clksel_reg	= OMAP_CM_REGADDR(WKUP_MOD, CM_CLKSEL),
+	.clksel_reg	= _OMAP34XX_CM_REGADDR(WKUP_MOD, CM_CLKSEL),
 	.clksel_mask	= OMAP3430_CLKSEL_GPT1_MASK,
 	.clksel		= omap343x_gpt_clksel,
 	.flags		= CLOCK_IN_OMAP343X,
@@ -2309,7 +2321,7 @@ static struct clk wkup_32k_fck = {
 static struct clk gpio1_dbck = {
 	.name		= "gpio1_dbck",
 	.parent		= &wkup_32k_fck,
-	.enable_reg	= OMAP_CM_REGADDR(WKUP_MOD, CM_FCLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(WKUP_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_EN_GPIO1_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm_name	= "wkup_clkdm",
@@ -2319,7 +2331,7 @@ static struct clk gpio1_dbck = {
 static struct clk wdt2_fck = {
 	.name		= "wdt2_fck",
 	.parent		= &wkup_32k_fck,
-	.enable_reg	= OMAP_CM_REGADDR(WKUP_MOD, CM_FCLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(WKUP_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_EN_WDT2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm_name	= "wkup_clkdm",
@@ -2339,7 +2351,7 @@ static struct clk wkup_l4_ick = {
 static struct clk usim_ick = {
 	.name		= "usim_ick",
 	.parent		= &wkup_l4_ick,
-	.enable_reg	= OMAP_CM_REGADDR(WKUP_MOD, CM_ICLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(WKUP_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430ES2_EN_USIMOCP_SHIFT,
 	.flags		= CLOCK_IN_OMAP3430ES2,
 	.clkdm_name	= "wkup_clkdm",
@@ -2349,7 +2361,7 @@ static struct clk usim_ick = {
 static struct clk wdt2_ick = {
 	.name		= "wdt2_ick",
 	.parent		= &wkup_l4_ick,
-	.enable_reg	= OMAP_CM_REGADDR(WKUP_MOD, CM_ICLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(WKUP_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_WDT2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm_name	= "wkup_clkdm",
@@ -2359,7 +2371,7 @@ static struct clk wdt2_ick = {
 static struct clk wdt1_ick = {
 	.name		= "wdt1_ick",
 	.parent		= &wkup_l4_ick,
-	.enable_reg	= OMAP_CM_REGADDR(WKUP_MOD, CM_ICLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(WKUP_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_WDT1_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm_name	= "wkup_clkdm",
@@ -2369,7 +2381,7 @@ static struct clk wdt1_ick = {
 static struct clk gpio1_ick = {
 	.name		= "gpio1_ick",
 	.parent		= &wkup_l4_ick,
-	.enable_reg	= OMAP_CM_REGADDR(WKUP_MOD, CM_ICLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(WKUP_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_GPIO1_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm_name	= "wkup_clkdm",
@@ -2379,7 +2391,7 @@ static struct clk gpio1_ick = {
 static struct clk omap_32ksync_ick = {
 	.name		= "omap_32ksync_ick",
 	.parent		= &wkup_l4_ick,
-	.enable_reg	= OMAP_CM_REGADDR(WKUP_MOD, CM_ICLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(WKUP_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_32KSYNC_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm_name	= "wkup_clkdm",
@@ -2390,7 +2402,7 @@ static struct clk omap_32ksync_ick = {
 static struct clk gpt12_ick = {
 	.name		= "gpt12_ick",
 	.parent		= &wkup_l4_ick,
-	.enable_reg	= OMAP_CM_REGADDR(WKUP_MOD, CM_ICLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(WKUP_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_GPT12_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm_name	= "wkup_clkdm",
@@ -2400,7 +2412,7 @@ static struct clk gpt12_ick = {
 static struct clk gpt1_ick = {
 	.name		= "gpt1_ick",
 	.parent		= &wkup_l4_ick,
-	.enable_reg	= OMAP_CM_REGADDR(WKUP_MOD, CM_ICLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(WKUP_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_GPT1_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm_name	= "wkup_clkdm",
@@ -2434,7 +2446,7 @@ static struct clk per_48m_fck = {
 static struct clk uart3_fck = {
 	.name		= "uart3_fck",
 	.parent		= &per_48m_fck,
-	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_EN_UART3_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm_name	= "per_clkdm",
@@ -2444,9 +2456,9 @@ static struct clk uart3_fck = {
 static struct clk gpt2_fck = {
 	.name		= "gpt2_fck",
 	.init		= &omap2_init_clksel_parent,
-	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_EN_GPT2_SHIFT,
-	.clksel_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_CLKSEL),
+	.clksel_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_CLKSEL),
 	.clksel_mask	= OMAP3430_CLKSEL_GPT2_MASK,
 	.clksel		= omap343x_gpt_clksel,
 	.flags		= CLOCK_IN_OMAP343X,
@@ -2457,9 +2469,9 @@ static struct clk gpt2_fck = {
 static struct clk gpt3_fck = {
 	.name		= "gpt3_fck",
 	.init		= &omap2_init_clksel_parent,
-	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_EN_GPT3_SHIFT,
-	.clksel_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_CLKSEL),
+	.clksel_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_CLKSEL),
 	.clksel_mask	= OMAP3430_CLKSEL_GPT3_MASK,
 	.clksel		= omap343x_gpt_clksel,
 	.flags		= CLOCK_IN_OMAP343X,
@@ -2470,9 +2482,9 @@ static struct clk gpt3_fck = {
 static struct clk gpt4_fck = {
 	.name		= "gpt4_fck",
 	.init		= &omap2_init_clksel_parent,
-	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_EN_GPT4_SHIFT,
-	.clksel_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_CLKSEL),
+	.clksel_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_CLKSEL),
 	.clksel_mask	= OMAP3430_CLKSEL_GPT4_MASK,
 	.clksel		= omap343x_gpt_clksel,
 	.flags		= CLOCK_IN_OMAP343X,
@@ -2483,9 +2495,9 @@ static struct clk gpt4_fck = {
 static struct clk gpt5_fck = {
 	.name		= "gpt5_fck",
 	.init		= &omap2_init_clksel_parent,
-	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_EN_GPT5_SHIFT,
-	.clksel_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_CLKSEL),
+	.clksel_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_CLKSEL),
 	.clksel_mask	= OMAP3430_CLKSEL_GPT5_MASK,
 	.clksel		= omap343x_gpt_clksel,
 	.flags		= CLOCK_IN_OMAP343X,
@@ -2496,9 +2508,9 @@ static struct clk gpt5_fck = {
 static struct clk gpt6_fck = {
 	.name		= "gpt6_fck",
 	.init		= &omap2_init_clksel_parent,
-	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_EN_GPT6_SHIFT,
-	.clksel_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_CLKSEL),
+	.clksel_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_CLKSEL),
 	.clksel_mask	= OMAP3430_CLKSEL_GPT6_MASK,
 	.clksel		= omap343x_gpt_clksel,
 	.flags		= CLOCK_IN_OMAP343X,
@@ -2509,9 +2521,9 @@ static struct clk gpt6_fck = {
 static struct clk gpt7_fck = {
 	.name		= "gpt7_fck",
 	.init		= &omap2_init_clksel_parent,
-	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_EN_GPT7_SHIFT,
-	.clksel_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_CLKSEL),
+	.clksel_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_CLKSEL),
 	.clksel_mask	= OMAP3430_CLKSEL_GPT7_MASK,
 	.clksel		= omap343x_gpt_clksel,
 	.flags		= CLOCK_IN_OMAP343X,
@@ -2522,9 +2534,9 @@ static struct clk gpt7_fck = {
 static struct clk gpt8_fck = {
 	.name		= "gpt8_fck",
 	.init		= &omap2_init_clksel_parent,
-	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_EN_GPT8_SHIFT,
-	.clksel_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_CLKSEL),
+	.clksel_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_CLKSEL),
 	.clksel_mask	= OMAP3430_CLKSEL_GPT8_MASK,
 	.clksel		= omap343x_gpt_clksel,
 	.flags		= CLOCK_IN_OMAP343X,
@@ -2535,9 +2547,9 @@ static struct clk gpt8_fck = {
 static struct clk gpt9_fck = {
 	.name		= "gpt9_fck",
 	.init		= &omap2_init_clksel_parent,
-	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_EN_GPT9_SHIFT,
-	.clksel_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_CLKSEL),
+	.clksel_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_CLKSEL),
 	.clksel_mask	= OMAP3430_CLKSEL_GPT9_MASK,
 	.clksel		= omap343x_gpt_clksel,
 	.flags		= CLOCK_IN_OMAP343X,
@@ -2556,7 +2568,7 @@ static struct clk per_32k_alwon_fck = {
 static struct clk gpio6_dbck = {
 	.name		= "gpio6_dbck",
 	.parent		= &per_32k_alwon_fck,
-	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_EN_GPIO6_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm_name	= "per_clkdm",
@@ -2566,7 +2578,7 @@ static struct clk gpio6_dbck = {
 static struct clk gpio5_dbck = {
 	.name		= "gpio5_dbck",
 	.parent		= &per_32k_alwon_fck,
-	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_EN_GPIO5_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm_name	= "per_clkdm",
@@ -2576,7 +2588,7 @@ static struct clk gpio5_dbck = {
 static struct clk gpio4_dbck = {
 	.name		= "gpio4_dbck",
 	.parent		= &per_32k_alwon_fck,
-	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_EN_GPIO4_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm_name	= "per_clkdm",
@@ -2586,7 +2598,7 @@ static struct clk gpio4_dbck = {
 static struct clk gpio3_dbck = {
 	.name		= "gpio3_dbck",
 	.parent		= &per_32k_alwon_fck,
-	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_EN_GPIO3_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm_name	= "per_clkdm",
@@ -2596,7 +2608,7 @@ static struct clk gpio3_dbck = {
 static struct clk gpio2_dbck = {
 	.name		= "gpio2_dbck",
 	.parent		= &per_32k_alwon_fck,
-	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_EN_GPIO2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm_name	= "per_clkdm",
@@ -2606,7 +2618,7 @@ static struct clk gpio2_dbck = {
 static struct clk wdt3_fck = {
 	.name		= "wdt3_fck",
 	.parent		= &per_32k_alwon_fck,
-	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_EN_WDT3_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm_name	= "per_clkdm",
@@ -2625,7 +2637,7 @@ static struct clk per_l4_ick = {
 static struct clk gpio6_ick = {
 	.name		= "gpio6_ick",
 	.parent		= &per_l4_ick,
-	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_GPIO6_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm_name	= "per_clkdm",
@@ -2635,7 +2647,7 @@ static struct clk gpio6_ick = {
 static struct clk gpio5_ick = {
 	.name		= "gpio5_ick",
 	.parent		= &per_l4_ick,
-	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_GPIO5_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm_name	= "per_clkdm",
@@ -2645,7 +2657,7 @@ static struct clk gpio5_ick = {
 static struct clk gpio4_ick = {
 	.name		= "gpio4_ick",
 	.parent		= &per_l4_ick,
-	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_GPIO4_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm_name	= "per_clkdm",
@@ -2655,7 +2667,7 @@ static struct clk gpio4_ick = {
 static struct clk gpio3_ick = {
 	.name		= "gpio3_ick",
 	.parent		= &per_l4_ick,
-	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_GPIO3_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm_name	= "per_clkdm",
@@ -2665,7 +2677,7 @@ static struct clk gpio3_ick = {
 static struct clk gpio2_ick = {
 	.name		= "gpio2_ick",
 	.parent		= &per_l4_ick,
-	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_GPIO2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm_name	= "per_clkdm",
@@ -2675,7 +2687,7 @@ static struct clk gpio2_ick = {
 static struct clk wdt3_ick = {
 	.name		= "wdt3_ick",
 	.parent		= &per_l4_ick,
-	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_WDT3_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm_name	= "per_clkdm",
@@ -2685,7 +2697,7 @@ static struct clk wdt3_ick = {
 static struct clk uart3_ick = {
 	.name		= "uart3_ick",
 	.parent		= &per_l4_ick,
-	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_UART3_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm_name	= "per_clkdm",
@@ -2695,7 +2707,7 @@ static struct clk uart3_ick = {
 static struct clk gpt9_ick = {
 	.name		= "gpt9_ick",
 	.parent		= &per_l4_ick,
-	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_GPT9_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm_name	= "per_clkdm",
@@ -2705,7 +2717,7 @@ static struct clk gpt9_ick = {
 static struct clk gpt8_ick = {
 	.name		= "gpt8_ick",
 	.parent		= &per_l4_ick,
-	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_GPT8_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm_name	= "per_clkdm",
@@ -2715,7 +2727,7 @@ static struct clk gpt8_ick = {
 static struct clk gpt7_ick = {
 	.name		= "gpt7_ick",
 	.parent		= &per_l4_ick,
-	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_GPT7_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm_name	= "per_clkdm",
@@ -2725,7 +2737,7 @@ static struct clk gpt7_ick = {
 static struct clk gpt6_ick = {
 	.name		= "gpt6_ick",
 	.parent		= &per_l4_ick,
-	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_GPT6_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm_name	= "per_clkdm",
@@ -2735,7 +2747,7 @@ static struct clk gpt6_ick = {
 static struct clk gpt5_ick = {
 	.name		= "gpt5_ick",
 	.parent		= &per_l4_ick,
-	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_GPT5_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm_name	= "per_clkdm",
@@ -2745,7 +2757,7 @@ static struct clk gpt5_ick = {
 static struct clk gpt4_ick = {
 	.name		= "gpt4_ick",
 	.parent		= &per_l4_ick,
-	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_GPT4_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm_name	= "per_clkdm",
@@ -2755,7 +2767,7 @@ static struct clk gpt4_ick = {
 static struct clk gpt3_ick = {
 	.name		= "gpt3_ick",
 	.parent		= &per_l4_ick,
-	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_GPT3_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm_name	= "per_clkdm",
@@ -2765,7 +2777,7 @@ static struct clk gpt3_ick = {
 static struct clk gpt2_ick = {
 	.name		= "gpt2_ick",
 	.parent		= &per_l4_ick,
-	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_GPT2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm_name	= "per_clkdm",
@@ -2776,7 +2788,7 @@ static struct clk mcbsp2_ick = {
 	.name		= "mcbsp_ick",
 	.id		= 2,
 	.parent		= &per_l4_ick,
-	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_MCBSP2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm_name	= "per_clkdm",
@@ -2787,7 +2799,7 @@ static struct clk mcbsp3_ick = {
 	.name		= "mcbsp_ick",
 	.id		= 3,
 	.parent		= &per_l4_ick,
-	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_MCBSP3_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm_name	= "per_clkdm",
@@ -2798,7 +2810,7 @@ static struct clk mcbsp4_ick = {
 	.name		= "mcbsp_ick",
 	.id		= 4,
 	.parent		= &per_l4_ick,
-	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_MCBSP4_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm_name	= "per_clkdm",
@@ -2815,7 +2827,7 @@ static struct clk mcbsp2_fck = {
 	.name		= "mcbsp_fck",
 	.id		= 2,
 	.init		= &omap2_init_clksel_parent,
-	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_EN_MCBSP2_SHIFT,
 	.clksel_reg	= OMAP343X_CTRL_REGADDR(OMAP2_CONTROL_DEVCONF0),
 	.clksel_mask	= OMAP2_MCBSP2_CLKS_MASK,
@@ -2829,7 +2841,7 @@ static struct clk mcbsp3_fck = {
 	.name		= "mcbsp_fck",
 	.id		= 3,
 	.init		= &omap2_init_clksel_parent,
-	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_EN_MCBSP3_SHIFT,
 	.clksel_reg	= OMAP343X_CTRL_REGADDR(OMAP343X_CONTROL_DEVCONF1),
 	.clksel_mask	= OMAP2_MCBSP3_CLKS_MASK,
@@ -2843,7 +2855,7 @@ static struct clk mcbsp4_fck = {
 	.name		= "mcbsp_fck",
 	.id		= 4,
 	.init		= &omap2_init_clksel_parent,
-	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_EN_MCBSP4_SHIFT,
 	.clksel_reg	= OMAP343X_CTRL_REGADDR(OMAP343X_CONTROL_DEVCONF1),
 	.clksel_mask	= OMAP2_MCBSP4_CLKS_MASK,
@@ -2893,7 +2905,7 @@ static const struct clksel emu_src_clksel[] = {
 static struct clk emu_src_ck = {
 	.name		= "emu_src_ck",
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= OMAP_CM_REGADDR(OMAP3430_EMU_MOD, CM_CLKSEL1),
+	.clksel_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_EMU_MOD, CM_CLKSEL1),
 	.clksel_mask	= OMAP3430_MUX_CTRL_MASK,
 	.clksel		= emu_src_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | ALWAYS_ENABLED,
@@ -2917,7 +2929,7 @@ static const struct clksel pclk_emu_clksel[] = {
 static struct clk pclk_fck = {
 	.name		= "pclk_fck",
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= OMAP_CM_REGADDR(OMAP3430_EMU_MOD, CM_CLKSEL1),
+	.clksel_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_EMU_MOD, CM_CLKSEL1),
 	.clksel_mask	= OMAP3430_CLKSEL_PCLK_MASK,
 	.clksel		= pclk_emu_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | ALWAYS_ENABLED,
@@ -2940,7 +2952,7 @@ static const struct clksel pclkx2_emu_clksel[] = {
 static struct clk pclkx2_fck = {
 	.name		= "pclkx2_fck",
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= OMAP_CM_REGADDR(OMAP3430_EMU_MOD, CM_CLKSEL1),
+	.clksel_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_EMU_MOD, CM_CLKSEL1),
 	.clksel_mask	= OMAP3430_CLKSEL_PCLKX2_MASK,
 	.clksel		= pclkx2_emu_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | ALWAYS_ENABLED,
@@ -2956,7 +2968,7 @@ static const struct clksel atclk_emu_clksel[] = {
 static struct clk atclk_fck = {
 	.name		= "atclk_fck",
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= OMAP_CM_REGADDR(OMAP3430_EMU_MOD, CM_CLKSEL1),
+	.clksel_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_EMU_MOD, CM_CLKSEL1),
 	.clksel_mask	= OMAP3430_CLKSEL_ATCLK_MASK,
 	.clksel		= atclk_emu_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | ALWAYS_ENABLED,
@@ -2967,7 +2979,7 @@ static struct clk atclk_fck = {
 static struct clk traceclk_src_fck = {
 	.name		= "traceclk_src_fck",
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= OMAP_CM_REGADDR(OMAP3430_EMU_MOD, CM_CLKSEL1),
+	.clksel_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_EMU_MOD, CM_CLKSEL1),
 	.clksel_mask	= OMAP3430_TRACE_MUX_CTRL_MASK,
 	.clksel		= emu_src_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | ALWAYS_ENABLED,
@@ -2990,7 +3002,7 @@ static const struct clksel traceclk_clksel[] = {
 static struct clk traceclk_fck = {
 	.name		= "traceclk_fck",
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= OMAP_CM_REGADDR(OMAP3430_EMU_MOD, CM_CLKSEL1),
+	.clksel_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_EMU_MOD, CM_CLKSEL1),
 	.clksel_mask	= OMAP3430_CLKSEL_TRACECLK_MASK,
 	.clksel		= traceclk_clksel,
 	.flags		= CLOCK_IN_OMAP343X | ALWAYS_ENABLED,
@@ -3004,7 +3016,7 @@ static struct clk traceclk_fck = {
 static struct clk sr1_fck = {
 	.name		= "sr1_fck",
 	.parent		= &sys_ck,
-	.enable_reg	= OMAP_CM_REGADDR(WKUP_MOD, CM_FCLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(WKUP_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_EN_SR1_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES,
 	.recalc		= &followparent_recalc,
@@ -3014,7 +3026,7 @@ static struct clk sr1_fck = {
 static struct clk sr2_fck = {
 	.name		= "sr2_fck",
 	.parent		= &sys_ck,
-	.enable_reg	= OMAP_CM_REGADDR(WKUP_MOD, CM_FCLKEN),
+	.enable_reg	= _OMAP34XX_CM_REGADDR(WKUP_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_EN_SR2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES,
 	.recalc		= &followparent_recalc,
diff --git a/arch/arm/mach-omap2/cm-regbits-34xx.h b/arch/arm/mach-omap2/cm-regbits-34xx.h
index aaf68a5..844356c 100644
--- a/arch/arm/mach-omap2/cm-regbits-34xx.h
+++ b/arch/arm/mach-omap2/cm-regbits-34xx.h
@@ -208,6 +208,10 @@
 #define OMAP3430ES2_ST_USBTLL_MASK			(1 << 2)
 
 /* CM_AUTOIDLE1_CORE */
+#define OMAP3430ES2_AUTO_MMC3				(1 << 30)
+#define OMAP3430ES2_AUTO_MMC3_SHIFT			30
+#define OMAP3430ES2_AUTO_ICR				(1 << 29)
+#define OMAP3430ES2_AUTO_ICR_SHIFT			29
 #define OMAP3430_AUTO_AES2				(1 << 28)
 #define OMAP3430_AUTO_AES2_SHIFT			28
 #define OMAP3430_AUTO_SHA12				(1 << 27)
@@ -276,6 +280,9 @@
 #define OMAP3430_AUTO_DES1_SHIFT			0
 
 /* CM_AUTOIDLE3_CORE */
+#define	OMAP3430ES2_AUTO_USBHOST			(1 << 0)
+#define	OMAP3430ES2_AUTO_USBHOST_SHIFT			0
+#define	OMAP3430ES2_AUTO_USBTLL				(1 << 2)
 #define OMAP3430ES2_AUTO_USBTLL_SHIFT			2
 #define OMAP3430ES2_AUTO_USBTLL_MASK			(1 << 2)
 
diff --git a/arch/arm/mach-omap2/cm.h b/arch/arm/mach-omap2/cm.h
index 65fdf78..bacadcb 100644
--- a/arch/arm/mach-omap2/cm.h
+++ b/arch/arm/mach-omap2/cm.h
@@ -16,29 +16,25 @@
 
 #include "prcm-common.h"
 
-#ifndef __ASSEMBLER__
-#define OMAP_CM_REGADDR(module, reg)					\
-			IO_ADDRESS(OMAP2_CM_BASE + (module) + (reg))
-#else
 #define OMAP2420_CM_REGADDR(module, reg)				\
 			IO_ADDRESS(OMAP2420_CM_BASE + (module) + (reg))
 #define OMAP2430_CM_REGADDR(module, reg)				\
 			IO_ADDRESS(OMAP2430_CM_BASE + (module) + (reg))
 #define OMAP34XX_CM_REGADDR(module, reg)				\
 			IO_ADDRESS(OMAP3430_CM_BASE + (module) + (reg))
-#endif
 
 /*
  * Architecture-specific global CM registers
- * Use cm_{read,write}_reg() with these registers.
+ * Use __raw_{read,write}l() with these registers.
  * These registers appear once per CM module.
  */
 
-#define OMAP3430_CM_REVISION		OMAP_CM_REGADDR(OCP_MOD, 0x0000)
-#define OMAP3430_CM_SYSCONFIG		OMAP_CM_REGADDR(OCP_MOD, 0x0010)
-#define OMAP3430_CM_POLCTRL		OMAP_CM_REGADDR(OCP_MOD, 0x009c)
+#define OMAP3430_CM_REVISION		OMAP34XX_CM_REGADDR(OCP_MOD, 0x0000)
+#define OMAP3430_CM_SYSCONFIG		OMAP34XX_CM_REGADDR(OCP_MOD, 0x0010)
+#define OMAP3430_CM_POLCTRL		OMAP34XX_CM_REGADDR(OCP_MOD, 0x009c)
 
-#define OMAP3430_CM_CLKOUT_CTRL		OMAP_CM_REGADDR(OMAP3430_CCR_MOD, 0x0070)
+#define OMAP3430_CM_CLKOUT_CTRL						\
+				OMAP34XX_CM_REGADDR(OMAP3430_CCR_MOD, 0x0070)
 
 /*
  * Module specific CM registers from CM_BASE + domain offset
@@ -67,7 +63,6 @@
 #define CM_CLKSEL2					0x0044
 #define CM_CLKSTCTRL					0x0048
 
-
 /* Architecture-specific registers */
 
 #define OMAP24XX_CM_FCLKEN2				0x0004
diff --git a/arch/arm/mach-omap2/memory.c b/arch/arm/mach-omap2/memory.c
index 882c702..b7669c8 100644
--- a/arch/arm/mach-omap2/memory.c
+++ b/arch/arm/mach-omap2/memory.c
@@ -93,7 +93,8 @@ u32 omap2_reprogram_sdrc(u32 level, u32 force)
 	m_type = omap2_memory_get_type();
 
 	local_irq_save(flags);
-	__raw_writel(0xffff, OMAP24XX_PRCM_VOLTSETUP);
+	prm_write_mod_reg(0xffff, OMAP24XX_GR_MOD,
+					OMAP24XX_PRCM_VOLTSETUP_OFFSET);
 	omap2_sram_reprogram_sdrc(level, dll_ctrl, m_type);
 	curr_perf_level = level;
 	local_irq_restore(flags);
diff --git a/arch/arm/mach-omap2/prm-regbits-34xx.h b/arch/arm/mach-omap2/prm-regbits-34xx.h
index 5b5ecfe..c6a7940 100644
--- a/arch/arm/mach-omap2/prm-regbits-34xx.h
+++ b/arch/arm/mach-omap2/prm-regbits-34xx.h
@@ -366,6 +366,7 @@
 
 /* PM_WKEN_WKUP specific bits */
 #define OMAP3430_EN_IO					(1 << 8)
+#define OMAP3430_EN_GPIO1				(1 << 3)
 
 /* PM_MPUGRPSEL_WKUP specific bits */
 
@@ -452,6 +453,14 @@
 #define OMAP3430_CMDRA0_MASK				(0xff << 0)
 
 /* PRM_VC_CMD_VAL_0 specific bits */
+#define OMAP3430_VC_CMD_ON_SHIFT			24
+#define OMAP3430_VC_CMD_ON_MASK				(0xFF << 24)
+#define OMAP3430_VC_CMD_ONLP_SHIFT			16
+#define OMAP3430_VC_CMD_ONLP_MASK			(0xFF << 16)
+#define OMAP3430_VC_CMD_RET_SHIFT			8
+#define OMAP3430_VC_CMD_RET_MASK			(0xFF << 8)
+#define OMAP3430_VC_CMD_OFF_SHIFT			0
+#define OMAP3430_VC_CMD_OFF_MASK			(0xFF << 0)
 
 /* PRM_VC_CMD_VAL_1 specific bits */
 
diff --git a/arch/arm/mach-omap2/prm.h b/arch/arm/mach-omap2/prm.h
index e4dc4b1..f7dac2e 100644
--- a/arch/arm/mach-omap2/prm.h
+++ b/arch/arm/mach-omap2/prm.h
@@ -4,8 +4,8 @@
 /*
  * OMAP2/3 Power/Reset Management (PRM) register definitions
  *
- * Copyright (C) 2007 Texas Instruments, Inc.
- * Copyright (C) 2007 Nokia Corporation
+ * Copyright (C) 2007-2008 Texas Instruments, Inc.
+ * Copyright (C) 2007-2008 Nokia Corporation
  *
  * Written by Paul Walmsley
  *
@@ -16,21 +16,16 @@
 
 #include "prcm-common.h"
 
-#ifndef __ASSEMBLER__
-#define OMAP_PRM_REGADDR(module, reg)					\
-			IO_ADDRESS(OMAP2_PRM_BASE + (module) + (reg))
-#else
 #define OMAP2420_PRM_REGADDR(module, reg)				\
 			IO_ADDRESS(OMAP2420_PRM_BASE + (module) + (reg))
 #define OMAP2430_PRM_REGADDR(module, reg)				\
 			IO_ADDRESS(OMAP2430_PRM_BASE + (module) + (reg))
 #define OMAP34XX_PRM_REGADDR(module, reg)				\
 			IO_ADDRESS(OMAP3430_PRM_BASE + (module) + (reg))
-#endif
 
 /*
  * Architecture-specific global PRM registers
- * Use __raw_{read,write}l() with these registers.
+ * Use prm_{read,write}_mod_reg() with these registers.
  *
  * With a few exceptions, these are the register names beginning with
  * PRCM_* on 24xx, and PRM_* on 34xx.  (The exceptions are the
@@ -38,80 +33,66 @@
  *
  */
 
-/* Global 24xx registers in GR_MOD (Same as OCP_MOD for 24xx) */
+/* 24xx register offsets in OCP_MOD */
+#define OMAP24XX_PRCM_REVISION_OFFSET		0x0000
+#define OMAP24XX_PRCM_SYSCONFIG_OFFSET		0x0010
+#define OMAP24XX_PRCM_IRQSTATUS_MPU_OFFSET	0x0018
+#define OMAP24XX_PRCM_IRQENABLE_MPU_OFFSET	0x001c
+
+/* 24xx register offsets in OMAP24XX_GR_MOD (Same as OCP_MOD for 24xx) */
 #define OMAP24XX_PRCM_VOLTCTRL_OFFSET		0x0050
+#define OMAP24XX_PRCM_VOLTST_OFFSET		0x0054
+#define OMAP24XX_PRCM_CLKSRC_CTRL_OFFSET	0x0060
+#define OMAP24XX_PRCM_CLKOUT_CTRL_OFFSET	0x0070
+#define OMAP24XX_PRCM_CLKEMUL_CTRL_OFFSET	0x0078
 #define OMAP24XX_PRCM_CLKCFG_CTRL_OFFSET	0x0080
-
-/* 242x GR_MOD registers, use these only for assembly code */
-#define OMAP242X_PRCM_VOLTCTRL		OMAP2420_PRM_REGADDR(OMAP24XX_GR_MOD,	\
-						OMAP24XX_PRCM_VOLTCTRL_OFFSET)
-#define OMAP242X_PRCM_CLKCFG_CTRL	OMAP2420_PRM_REGADDR(OMAP24XX_GR_MOD,	\
-						OMAP24XX_PRCM_CLKCFG_CTRL_OFFSET)
-
-/* 243x GR_MOD registers, use these only for assembly code */
-#define OMAP243X_PRCM_VOLTCTRL		OMAP2430_PRM_REGADDR(OMAP24XX_GR_MOD,	\
-						OMAP24XX_PRCM_VOLTCTRL_OFFSET)
-#define OMAP243X_PRCM_CLKCFG_CTRL	OMAP2430_PRM_REGADDR(OMAP24XX_GR_MOD,	\
-						OMAP24XX_PRCM_CLKCFG_CTRL_OFFSET)
-
-/* These will disappear */
-#define OMAP24XX_PRCM_REVISION		OMAP_PRM_REGADDR(OCP_MOD, 0x0000)
-#define OMAP24XX_PRCM_SYSCONFIG		OMAP_PRM_REGADDR(OCP_MOD, 0x0010)
-
-#define OMAP24XX_PRCM_IRQSTATUS_MPU	OMAP_PRM_REGADDR(OCP_MOD, 0x0018)
-#define OMAP24XX_PRCM_IRQENABLE_MPU	OMAP_PRM_REGADDR(OCP_MOD, 0x001c)
-
-#define OMAP24XX_PRCM_VOLTST		OMAP_PRM_REGADDR(OCP_MOD, 0x0054)
-#define OMAP24XX_PRCM_CLKSRC_CTRL	OMAP_PRM_REGADDR(OCP_MOD, 0x0060)
-#define OMAP24XX_PRCM_CLKOUT_CTRL	OMAP_PRM_REGADDR(OCP_MOD, 0x0070)
-#define OMAP24XX_PRCM_CLKEMUL_CTRL	OMAP_PRM_REGADDR(OCP_MOD, 0x0078)
-#define OMAP24XX_PRCM_CLKCFG_CTRL	OMAP_PRM_REGADDR(OCP_MOD, 0x0080)
-#define OMAP24XX_PRCM_CLKCFG_STATUS	OMAP_PRM_REGADDR(OCP_MOD, 0x0084)
-#define OMAP24XX_PRCM_VOLTSETUP		OMAP_PRM_REGADDR(OCP_MOD, 0x0090)
-#define OMAP24XX_PRCM_CLKSSETUP		OMAP_PRM_REGADDR(OCP_MOD, 0x0094)
-#define OMAP24XX_PRCM_POLCTRL		OMAP_PRM_REGADDR(OCP_MOD, 0x0098)
-
-#define OMAP3430_PRM_REVISION		OMAP_PRM_REGADDR(OCP_MOD, 0x0004)
-#define OMAP3430_PRM_SYSCONFIG		OMAP_PRM_REGADDR(OCP_MOD, 0x0014)
-
-#define OMAP3430_PRM_IRQSTATUS_MPU	OMAP_PRM_REGADDR(OCP_MOD, 0x0018)
-#define OMAP3430_PRM_IRQENABLE_MPU	OMAP_PRM_REGADDR(OCP_MOD, 0x001c)
-
-
-#define OMAP3430_PRM_VC_SMPS_SA		OMAP_PRM_REGADDR(OMAP3430_GR_MOD, 0x0020)
-#define OMAP3430_PRM_VC_SMPS_VOL_RA	OMAP_PRM_REGADDR(OMAP3430_GR_MOD, 0x0024)
-#define OMAP3430_PRM_VC_SMPS_CMD_RA	OMAP_PRM_REGADDR(OMAP3430_GR_MOD, 0x0028)
-#define OMAP3430_PRM_VC_CMD_VAL_0	OMAP_PRM_REGADDR(OMAP3430_GR_MOD, 0x002c)
-#define OMAP3430_PRM_VC_CMD_VAL_1	OMAP_PRM_REGADDR(OMAP3430_GR_MOD, 0x0030)
-#define OMAP3430_PRM_VC_CH_CONF		OMAP_PRM_REGADDR(OMAP3430_GR_MOD, 0x0034)
-#define OMAP3430_PRM_VC_I2C_CFG		OMAP_PRM_REGADDR(OMAP3430_GR_MOD, 0x0038)
-#define OMAP3430_PRM_VC_BYPASS_VAL	OMAP_PRM_REGADDR(OMAP3430_GR_MOD, 0x003c)
-#define OMAP3430_PRM_RSTCTRL		OMAP_PRM_REGADDR(OMAP3430_GR_MOD, 0x0050)
-#define OMAP3430_PRM_RSTTIME		OMAP_PRM_REGADDR(OMAP3430_GR_MOD, 0x0054)
-#define OMAP3430_PRM_RSTST		OMAP_PRM_REGADDR(OMAP3430_GR_MOD, 0x0058)
-#define OMAP3430_PRM_VOLTCTRL		OMAP_PRM_REGADDR(OMAP3430_GR_MOD, 0x0060)
-#define OMAP3430_PRM_SRAM_PCHARGE	OMAP_PRM_REGADDR(OMAP3430_GR_MOD, 0x0064)
-#define OMAP3430_PRM_CLKSRC_CTRL	OMAP_PRM_REGADDR(OMAP3430_GR_MOD, 0x0070)
-#define OMAP3430_PRM_VOLTSETUP1		OMAP_PRM_REGADDR(OMAP3430_GR_MOD, 0x0090)
-#define OMAP3430_PRM_VOLTOFFSET		OMAP_PRM_REGADDR(OMAP3430_GR_MOD, 0x0094)
-#define OMAP3430_PRM_CLKSETUP		OMAP_PRM_REGADDR(OMAP3430_GR_MOD, 0x0098)
-#define OMAP3430_PRM_POLCTRL		OMAP_PRM_REGADDR(OMAP3430_GR_MOD, 0x009c)
-#define OMAP3430_PRM_VOLTSETUP2		OMAP_PRM_REGADDR(OMAP3430_GR_MOD, 0x00a0)
-#define OMAP3430_PRM_VP1_CONFIG		OMAP_PRM_REGADDR(OMAP3430_GR_MOD, 0x00b0)
-#define OMAP3430_PRM_VP1_VSTEPMIN	OMAP_PRM_REGADDR(OMAP3430_GR_MOD, 0x00b4)
-#define OMAP3430_PRM_VP1_VSTEPMAX	OMAP_PRM_REGADDR(OMAP3430_GR_MOD, 0x00b8)
-#define OMAP3430_PRM_VP1_VLIMITTO	OMAP_PRM_REGADDR(OMAP3430_GR_MOD, 0x00bc)
-#define OMAP3430_PRM_VP1_VOLTAGE	OMAP_PRM_REGADDR(OMAP3430_GR_MOD, 0x00c0)
-#define OMAP3430_PRM_VP1_STATUS		OMAP_PRM_REGADDR(OMAP3430_GR_MOD, 0x00c4)
-#define OMAP3430_PRM_VP2_CONFIG		OMAP_PRM_REGADDR(OMAP3430_GR_MOD, 0x00d0)
-#define OMAP3430_PRM_VP2_VSTEPMIN	OMAP_PRM_REGADDR(OMAP3430_GR_MOD, 0x00d4)
-#define OMAP3430_PRM_VP2_VSTEPMAX	OMAP_PRM_REGADDR(OMAP3430_GR_MOD, 0x00d8)
-#define OMAP3430_PRM_VP2_VLIMITTO	OMAP_PRM_REGADDR(OMAP3430_GR_MOD, 0x00dc)
-#define OMAP3430_PRM_VP2_VOLTAGE	OMAP_PRM_REGADDR(OMAP3430_GR_MOD, 0x00e0)
-#define OMAP3430_PRM_VP2_STATUS		OMAP_PRM_REGADDR(OMAP3430_GR_MOD, 0x00e4)
-
-#define OMAP3430_PRM_CLKSEL		OMAP_PRM_REGADDR(OMAP3430_CCR_MOD, 0x0040)
-#define OMAP3430_PRM_CLKOUT_CTRL	OMAP_PRM_REGADDR(OMAP3430_CCR_MOD, 0x0070)
+#define OMAP24XX_PRCM_CLKCFG_STATUS_OFFSET	0x0084
+#define OMAP24XX_PRCM_VOLTSETUP_OFFSET		0x0090
+#define OMAP24XX_PRCM_CLKSSETUP_OFFSET		0x0094
+#define OMAP24XX_PRCM_POLCTRL_OFFSET		0x0098
+
+/* 34xx register offsets in OCP_MOD */
+#define OMAP3430_PRM_REVISION_OFFSET		0x0004
+#define OMAP3430_PRM_SYSCONFIG_OFFSET		0x0014
+#define OMAP3430_PRM_IRQSTATUS_MPU_OFFSET	0x0018
+#define OMAP3430_PRM_IRQENABLE_MPU_OFFSET	0x001c
+
+/* 34xx register offsets in GR_MOD */
+#define OMAP3_PRM_VC_SMPS_SA_OFFSET		0x0020
+#define OMAP3_PRM_VC_SMPS_VOL_RA_OFFSET		0x0024
+#define OMAP3_PRM_VC_SMPS_CMD_RA_OFFSET		0x0028
+#define OMAP3_PRM_VC_CMD_VAL_0_OFFSET		0x002c
+#define OMAP3_PRM_VC_CMD_VAL_1_OFFSET		0x0030
+#define OMAP3_PRM_VC_CH_CONF_OFFSET		0x0034
+#define OMAP3_PRM_VC_I2C_CFG_OFFSET		0x0038
+#define OMAP3_PRM_VC_BYPASS_VAL_OFFSET		0x003c
+#define OMAP3_PRM_RSTCTRL_OFFSET		0x0050
+#define OMAP3_PRM_RSTTIME_OFFSET		0x0054
+#define OMAP3_PRM_RSTST_OFFSET			0x0058
+#define OMAP3_PRM_VOLTCTRL_OFFSET		0x0060
+#define OMAP3_PRM_SRAM_PCHARGE_OFFSET		0x0064
+#define OMAP3_PRM_CLKSRC_CTRL_OFFSET		0x0070
+#define OMAP3_PRM_VOLTSETUP1_OFFSET		0x0090
+#define OMAP3_PRM_VOLTOFFSET_OFFSET		0x0094
+#define OMAP3_PRM_CLKSETUP_OFFSET		0x0098
+#define OMAP3_PRM_POLCTRL_OFFSET		0x009c
+#define OMAP3_PRM_VOLTSETUP2_OFFSET		0x00a0
+#define OMAP3_PRM_VP1_CONFIG_OFFSET		0x00b0
+#define OMAP3_PRM_VP1_VSTEPMIN_OFFSET		0x00b4
+#define OMAP3_PRM_VP1_VSTEPMAX_OFFSET		0x00b8
+#define OMAP3_PRM_VP1_VLIMITTO_OFFSET		0x00bc
+#define OMAP3_PRM_VP1_VOLTAGE_OFFSET		0x00c0
+#define OMAP3_PRM_VP1_STATUS_OFFSET		0x00c4
+#define OMAP3_PRM_VP2_CONFIG_OFFSET		0x00d0
+#define OMAP3_PRM_VP2_VSTEPMIN_OFFSET		0x00d4
+#define OMAP3_PRM_VP2_VSTEPMAX_OFFSET		0x00d8
+#define OMAP3_PRM_VP2_VLIMITTO_OFFSET		0x00dc
+#define OMAP3_PRM_VP2_VOLTAGE_OFFSET		0x00e0
+#define OMAP3_PRM_VP2_STATUS_OFFSET		0x00e4
+
+/* 34xx register offsets in CCR_MOD */
+#define OMAP3_PRM_CLKSEL_OFFSET			0x0040
+#define OMAP3_PRM_CLKOUT_CTRL_OFFSET		0x0070
 
 /*
  * Module specific PRM registers from PRM_BASE + domain offset
@@ -141,6 +122,19 @@
 #define PM_PWSTCTRL					0x00e0
 #define PM_PWSTST					0x00e4
 
+/* Omap2 specific registers */
+#define OMAP24XX_PM_WKEN2				0x00a4
+#define OMAP24XX_PM_WKST2				0x00b4
+
+#define OMAP24XX_PRCM_IRQSTATUS_DSP			0x00f0	/* IVA mod */
+#define OMAP24XX_PRCM_IRQENABLE_DSP			0x00f4	/* IVA mod */
+#define OMAP24XX_PRCM_IRQSTATUS_IVA			0x00f8
+#define OMAP24XX_PRCM_IRQENABLE_IVA			0x00fc
+
+/* Omap3 specific registers */
+#define OMAP3430ES2_PM_WKEN3				0x00f0
+#define OMAP3430ES2_PM_WKST3				0x00b8
+
 #define OMAP3430_PM_MPUGRPSEL				0x00a4
 #define OMAP3430_PM_MPUGRPSEL1				OMAP3430_PM_MPUGRPSEL
 
@@ -152,17 +146,6 @@
 #define OMAP3430_PRM_IRQSTATUS_IVA2			0x00f8
 #define OMAP3430_PRM_IRQENABLE_IVA2			0x00fc
 
-
-/* Architecture-specific registers */
-
-#define OMAP24XX_PM_WKEN2				0x00a4
-#define OMAP24XX_PM_WKST2				0x00b4
-
-#define OMAP24XX_PRCM_IRQSTATUS_DSP			0x00f0	/* IVA mod */
-#define OMAP24XX_PRCM_IRQENABLE_DSP			0x00f4	/* IVA mod */
-#define OMAP24XX_PRCM_IRQSTATUS_IVA			0x00f8
-#define OMAP24XX_PRCM_IRQENABLE_IVA			0x00fc
-
 #ifndef __ASSEMBLER__
 
 /* Power/reset management domain register get/set */
@@ -228,7 +211,6 @@ static inline u32 prm_clear_mod_reg_bits(u32 bits, s16 module, s16 idx)
 #define OMAP_RSTTIME1_SHIFT				0
 #define OMAP_RSTTIME1_MASK				(0xff << 0)
 
-
 /* PRM_RSTCTRL */
 /* Named RM_RSTCTRL_WKUP on the 24xx */
 /* 2420 calls RST_DPLL3 'RST_DPLL' */
diff --git a/arch/arm/mach-omap2/sram242x.S b/arch/arm/mach-omap2/sram242x.S
index af4bd34..a2086c3 100644
--- a/arch/arm/mach-omap2/sram242x.S
+++ b/arch/arm/mach-omap2/sram242x.S
@@ -31,6 +31,11 @@
 #include "cm.h"
 #include "sdrc.h"
 
+#define OMAP242X_PRCM_VOLTCTRL		OMAP2420_PRM_REGADDR(OMAP24XX_GR_MOD,	\
+						OMAP24XX_PRCM_VOLTCTRL_OFFSET)
+#define OMAP242X_PRCM_CLKCFG_CTRL	OMAP2420_PRM_REGADDR(OMAP24XX_GR_MOD,	\
+						OMAP24XX_PRCM_CLKCFG_CTRL_OFFSET)
+
 	.text
 
 ENTRY(omap242x_sram_ddr_init)
diff --git a/arch/arm/mach-omap2/sram243x.S b/arch/arm/mach-omap2/sram243x.S
index 84363e2..7946a5f 100644
--- a/arch/arm/mach-omap2/sram243x.S
+++ b/arch/arm/mach-omap2/sram243x.S
@@ -31,6 +31,11 @@
 #include "cm.h"
 #include "sdrc.h"
 
+#define OMAP243X_PRCM_VOLTCTRL		OMAP2430_PRM_REGADDR(OMAP24XX_GR_MOD,	\
+						OMAP24XX_PRCM_VOLTCTRL_OFFSET)
+#define OMAP243X_PRCM_CLKCFG_CTRL	OMAP2430_PRM_REGADDR(OMAP24XX_GR_MOD,	\
+						OMAP24XX_PRCM_CLKCFG_CTRL_OFFSET)
+
 	.text
 
 ENTRY(omap243x_sram_ddr_init)
diff --git a/arch/arm/plat-omap/common.c b/arch/arm/plat-omap/common.c
index 0843b88..314b145 100644
--- a/arch/arm/plat-omap/common.c
+++ b/arch/arm/plat-omap/common.c
@@ -252,6 +252,7 @@ static void __init __omap2_set_globals(void)
 	omap2_set_globals_memory(omap2_globals);
 	omap2_set_globals_control(omap2_globals);
 	omap2_set_globals_prcm(omap2_globals);
+	omap2_set_globals_clock24xx(omap2_globals);
 }
 
 #endif
diff --git a/arch/arm/plat-omap/include/mach/clock.h b/arch/arm/plat-omap/include/mach/clock.h
index 5f37735..e32937b 100644
--- a/arch/arm/plat-omap/include/mach/clock.h
+++ b/arch/arm/plat-omap/include/mach/clock.h
@@ -136,7 +136,8 @@ extern void clk_enable_init_clocks(void);
 #define CONFIG_PARTICIPANT	(1 << 10)	/* Fundamental clock */
 #define ENABLE_ON_INIT		(1 << 11)	/* Enable upon framework init */
 #define INVERT_ENABLE           (1 << 12)       /* 0 enables, 1 disables */
-/* bits 13-20 are currently free */
+#define OFFSET_GR_MOD		(1 << 13)	/* 24xx GR_MOD reg as offset */
+/* bits 14-20 are currently free */
 #define CLOCK_IN_OMAP310	(1 << 21)
 #define CLOCK_IN_OMAP730	(1 << 22)
 #define CLOCK_IN_OMAP1510	(1 << 23)
diff --git a/arch/arm/plat-omap/include/mach/common.h b/arch/arm/plat-omap/include/mach/common.h
index ef70e2b..4ddb661 100644
--- a/arch/arm/plat-omap/include/mach/common.h
+++ b/arch/arm/plat-omap/include/mach/common.h
@@ -68,5 +68,10 @@ void omap2_set_globals_tap(struct omap_globals *);
 void omap2_set_globals_memory(struct omap_globals *);
 void omap2_set_globals_control(struct omap_globals *);
 void omap2_set_globals_prcm(struct omap_globals *);
+#ifdef CONFIG_ARCH_OMAP24XX
+void omap2_set_globals_clock24xx(struct omap_globals *);
+#else
+#define omap2_set_globals_clock24xx(x)	do { } while (0)
+#endif
 
 #endif /* __ARCH_ARM_MACH_OMAP_COMMON_H */


