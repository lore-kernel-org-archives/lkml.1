Return-Path: <linux-kernel-owner+w=401wt.eu-S1755675AbZA1UaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675AbZA1UaA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 15:30:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753832AbZA1U1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:27:47 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:60936 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171AbZA1U1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:27:31 -0500
MBOX-Line: From nobody Wed Jan 28 12:18:38 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH D 08/11] OMAP2/3 clock: use clk->prcm_mod for all struct clk
	register addressing
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, Paul Walmsley <paul@pwsan.com>,
       Tony Lindgren <tony@atomide.com>
Date: Wed, 28 Jan 2009 12:18:38 -0700
Message-ID: <20090128191836.16688.18761.stgit@localhost.localdomain>
In-Reply-To: <20090128191638.16688.33452.stgit@localhost.localdomain>
References: <20090128191638.16688.33452.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the clk->prcm_mod field for all register addresses in struct clk.
Remove all usage of the *_REGADDR() and *_OFFSET() macros from the
clock tree.  This eliminates a set of (__force void __iomem *) casts
and removes all of the OMAP2xxx register address rewriting.  Shrink
the width of the enable_reg/clksel_reg registers to 16 bits, saving 4
bytes per struct clk.

linux-omap source commit is 8607e3ad18003020969cc5c344453d37640c678c.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/clock.c             |   68 ++---
 arch/arm/mach-omap2/clock24xx.c         |   48 ----
 arch/arm/mach-omap2/clock24xx.h         |  324 ++++++++++++------------
 arch/arm/mach-omap2/clock34xx.c         |   27 +-
 arch/arm/mach-omap2/clock34xx.h         |  421 +++++++++++++++----------------
 arch/arm/mach-omap2/cm.h                |    3 
 arch/arm/plat-omap/common.c             |    1 
 arch/arm/plat-omap/include/mach/clock.h |   17 +
 8 files changed, 414 insertions(+), 495 deletions(-)

diff --git a/arch/arm/mach-omap2/clock.c b/arch/arm/mach-omap2/clock.c
index 1662d85..dff4eaa 100644
--- a/arch/arm/mach-omap2/clock.c
+++ b/arch/arm/mach-omap2/clock.c
@@ -203,7 +203,8 @@ void omap2_init_clksel_parent(struct clk *clk)
 	if (!clk->clksel)
 		return;
 
-	r = __raw_readl(clk->clksel_reg) & clk->clksel_mask;
+	r = _omap2_clk_read_reg(clk->clksel_reg, clk);
+	r &= clk->clksel_mask;
 	r >>= __ffs(clk->clksel_mask);
 
 	for (clks = clk->clksel; clks->parent && !found; clks++) {
@@ -254,10 +255,9 @@ u32 omap2_get_dpll_rate(struct clk *clk)
 		return 0;
 
 	/* Return bypass rate if DPLL is bypassed */
-	v = __raw_readl(dd->control_reg);
+	v = cm_read_mod_reg(clk->prcm_mod, dd->control_reg);
 	v &= dd->enable_mask;
 	v >>= __ffs(dd->enable_mask);
-
 	if (cpu_is_omap24xx()) {
 
 		if (v == OMAP2XXX_EN_DPLL_LPBYPASS ||
@@ -272,7 +272,7 @@ u32 omap2_get_dpll_rate(struct clk *clk)
 
 	}
 
-	v = __raw_readl(dd->mult_div1_reg);
+	v = cm_read_mod_reg(clk->prcm_mod, dd->mult_div1_reg);
 	dpll_mult = v & dd->mult_mask;
 	dpll_mult >>= __ffs(dd->mult_mask);
 	dpll_div = v & dd->div1_mask;
@@ -345,7 +345,8 @@ int omap2_wait_clock_ready(void __iomem *reg, u32 mask, const char *name)
  */
 static void omap2_clk_wait_ready(struct clk *clk)
 {
-	void __iomem *reg, *other_reg, *st_reg;
+	void __iomem *other_reg, *st_reg;
+	u16 reg;
 	u32 bit;
 
 	/*
@@ -353,18 +354,18 @@ static void omap2_clk_wait_ready(struct clk *clk)
 	 * it and pull it into struct clk itself somehow.
 	 */
 	reg = clk->enable_reg;
-	if ((((u32)reg & 0xff) >= CM_FCLKEN1) &&
-	    (((u32)reg & 0xff) <= OMAP24XX_CM_FCLKEN2))
-		other_reg = (void __iomem *)(((u32)reg & ~0xf0) | 0x10); /* CM_ICLKEN* */
-	else if ((((u32)reg & 0xff) >= CM_ICLKEN1) &&
-		 (((u32)reg & 0xff) <= OMAP24XX_CM_ICLKEN4))
-		other_reg = (void __iomem *)(((u32)reg & ~0xf0) | 0x00); /* CM_FCLKEN* */
+	if (((reg & 0xff) >= CM_FCLKEN1) &&
+	    ((reg & 0xff) <= OMAP24XX_CM_FCLKEN2))
+		other_reg = (void __iomem *)((reg & ~0xf0) | 0x10); /* CM_ICLKEN* */
+	else if (((reg & 0xff) >= CM_ICLKEN1) &&
+		 ((reg & 0xff) <= OMAP24XX_CM_ICLKEN4))
+		other_reg = (void __iomem *)((reg & ~0xf0) | 0x00); /* CM_FCLKEN* */
 	else
 		return;
 
 	/* REVISIT: What are the appropriate exclusions for 34XX? */
 	/* No check for DSS or cam clocks */
-	if (cpu_is_omap24xx() && ((u32)reg & 0x0f) == 0) { /* CM_{F,I}CLKEN1 */
+	if (cpu_is_omap24xx() && (reg & 0x0f) == 0) { /* CM_{F,I}CLKEN1 */
 		if (clk->enable_bit == OMAP24XX_EN_DSS2_SHIFT ||
 		    clk->enable_bit == OMAP24XX_EN_DSS1_SHIFT ||
 		    clk->enable_bit == OMAP24XX_EN_CAM_SHIFT)
@@ -374,8 +375,8 @@ static void omap2_clk_wait_ready(struct clk *clk)
 	/* REVISIT: What are the appropriate exclusions for 34XX? */
 	/* OMAP3: ignore DSS-mod clocks */
 	if (cpu_is_omap34xx() &&
-	    (((u32)reg & ~0xff) == cm_read_mod_reg(OMAP3430_DSS_MOD, 0) ||
-	     ((((u32)reg & ~0xff) == cm_read_mod_reg(CORE_MOD, 0)) &&
+	    ((reg & ~0xff) == cm_read_mod_reg(OMAP3430_DSS_MOD, 0) ||
+	     (((reg & ~0xff) == cm_read_mod_reg(CORE_MOD, 0)) &&
 	      clk->enable_bit == OMAP3430_EN_SSI_SHIFT)))
 		return;
 
@@ -402,18 +403,12 @@ static int _omap2_clk_enable(struct clk *clk)
 	if (clk->enable)
 		return clk->enable(clk);
 
-	if (!clk->enable_reg) {
-		printk(KERN_ERR "clock.c: Enable for %s without enable code\n",
-		       clk->name);
-		return 0; /* REVISIT: -EINVAL */
-	}
-
-	v = __raw_readl(clk->enable_reg);
+	v = _omap2_clk_read_reg(clk->enable_reg, clk);
 	if (clk->flags & INVERT_ENABLE)
 		v &= ~(1 << clk->enable_bit);
 	else
 		v |= (1 << clk->enable_bit);
-	__raw_writel(v, clk->enable_reg);
+	_omap2_clk_write_reg(v, clk->enable_reg, clk);
 	wmb();
 
 	omap2_clk_wait_ready(clk);
@@ -434,22 +429,12 @@ static void _omap2_clk_disable(struct clk *clk)
 		return;
 	}
 
-	if (!clk->enable_reg) {
-		/*
-		 * 'Independent' here refers to a clock which is not
-		 * controlled by its parent.
-		 */
-		printk(KERN_ERR "clock: clk_disable called on independent "
-		       "clock %s which has no enable_reg\n", clk->name);
-		return;
-	}
-
-	v = __raw_readl(clk->enable_reg);
+	v = _omap2_clk_read_reg(clk->enable_reg, clk);
 	if (clk->flags & INVERT_ENABLE)
 		v |= (1 << clk->enable_bit);
 	else
 		v &= ~(1 << clk->enable_bit);
-	__raw_writel(v, clk->enable_reg);
+	_omap2_clk_write_reg(v, clk->enable_reg, clk);
 	wmb();
 }
 
@@ -732,7 +717,8 @@ u32 omap2_clksel_get_divisor(struct clk *clk)
 	if (!clk->clksel_mask)
 		return 0;
 
-	v = __raw_readl(clk->clksel_reg) & clk->clksel_mask;
+	v = _omap2_clk_read_reg(clk->clksel_reg, clk);
+	v &= clk->clksel_mask;
 	v >>= __ffs(clk->clksel_mask);
 
 	return omap2_clksel_to_divisor(clk, v);
@@ -747,16 +733,16 @@ int omap2_clksel_set_rate(struct clk *clk, unsigned long rate)
 
 	validrate = omap2_clksel_round_rate_div(clk, rate, &new_div);
 	if (validrate != rate)
-		return -EINVAL;
+	       return -EINVAL;
 
 	field_val = omap2_divisor_to_clksel(clk, new_div);
 	if (field_val == ~0)
 		return -EINVAL;
 
-	v = __raw_readl(clk->clksel_reg);
+	v = _omap2_clk_read_reg(clk->clksel_reg, clk);
 	v &= ~clk->clksel_mask;
 	v |= field_val << __ffs(clk->clksel_mask);
-	__raw_writel(v, clk->clksel_reg);
+	_omap2_clk_write_reg(v, clk->clksel_reg, clk);
 
 	wmb();
 
@@ -846,10 +832,10 @@ int omap2_clk_set_parent(struct clk *clk, struct clk *new_parent)
 		_omap2_clk_disable(clk);
 
 	/* Set new source value (previous dividers if any in effect) */
-	v = __raw_readl(clk->clksel_reg);
+	v = _omap2_clk_read_reg(clk->clksel_reg, clk);
 	v &= ~clk->clksel_mask;
 	v |= field_val << __ffs(clk->clksel_mask);
-	__raw_writel(v, clk->clksel_reg);
+	_omap2_clk_write_reg(v, clk->clksel_reg, clk);
 	wmb();
 
 	if (clk->flags & DELAYED_APP && cpu_is_omap24xx()) {
@@ -1084,7 +1070,7 @@ void omap2_clk_disable_unused(struct clk *clk)
 
 	v = (clk->flags & INVERT_ENABLE) ? (1 << clk->enable_bit) : 0;
 
-	regval32 = __raw_readl(clk->enable_reg);
+	regval32 = _omap2_clk_read_reg(clk->enable_reg, clk);
 	if ((regval32 & (1 << clk->enable_bit)) == v)
 		return;
 
diff --git a/arch/arm/mach-omap2/clock24xx.c b/arch/arm/mach-omap2/clock24xx.c
index 2398711..2047c06 100644
--- a/arch/arm/mach-omap2/clock24xx.c
+++ b/arch/arm/mach-omap2/clock24xx.c
@@ -223,7 +223,8 @@ static int omap2_reprogram_dpllcore(struct clk *clk, unsigned long rate)
 		if (!dd)
 			goto dpll_exit;
 
-		tmpset.cm_clksel1_pll = __raw_readl(dd->mult_div1_reg);
+		tmpset.cm_clksel1_pll = cm_read_mod_reg(clk->prcm_mod,
+							dd->mult_div1_reg);
 		tmpset.cm_clksel1_pll &= ~(dd->mult_mask |
 					   dd->div1_mask);
 		div = ((curr_prcm_set->xtal_speed / 1000000) - 1);
@@ -522,39 +523,6 @@ static int __init omap2_clk_arch_init(void)
 }
 arch_initcall(omap2_clk_arch_init);
 
-static u32 prm_base;
-static u32 cm_base;
-
-/*
- * Since we share clock data for 242x and 243x, we need to rewrite some
- * some register base offsets. Assume offset is at prm_base if flagged,
- * else assume it's cm_base.
- */
-static inline void omap2_clk_check_reg(u32 flags, void __iomem **reg)
-{
-	u32 tmp = (__force u32)*reg;
-
-	if ((tmp >> 24) != 0)
-		return;
-
-	if (flags & OFFSET_GR_MOD)
-		tmp += prm_base;
-	else
-		tmp += cm_base;
-
-	*reg = (__force void __iomem *)tmp;
-}
-
-void __init omap2_clk_rewrite_base(struct clk *clk)
-{
-	omap2_clk_check_reg(clk->flags, &clk->clksel_reg);
-	omap2_clk_check_reg(clk->flags, &clk->enable_reg);
-	if (clk->dpll_data) {
-		omap2_clk_check_reg(0, &clk->dpll_data->mult_div1_reg);
-		omap2_clk_check_reg(0, &clk->dpll_data->control_reg);
-	}
-}
-
 int __init omap2_clk_init(void)
 {
 	struct prcm_config *prcm;
@@ -566,12 +534,6 @@ int __init omap2_clk_init(void)
 	else if (cpu_is_omap2430())
 		cpu_mask = RATE_IN_243X;
 
-	for (clkp = onchip_24xx_clks;
-	     clkp < onchip_24xx_clks + ARRAY_SIZE(onchip_24xx_clks);
-	     clkp++) {
-			omap2_clk_rewrite_base(*clkp);
-	}
-
 	clk_init(&omap2_clk_functions);
 
 	omap2_osc_clk_recalc(&osc_ck);
@@ -625,9 +587,3 @@ int __init omap2_clk_init(void)
 
 	return 0;
 }
-
-void __init omap2_set_globals_clock24xx(struct omap_globals *omap2_globals)
-{
-	prm_base = (__force u32)omap2_globals->prm;
-	cm_base = (__force u32)omap2_globals->cm;
-}
diff --git a/arch/arm/mach-omap2/clock24xx.h b/arch/arm/mach-omap2/clock24xx.h
index 7150a3f..178f46d 100644
--- a/arch/arm/mach-omap2/clock24xx.h
+++ b/arch/arm/mach-omap2/clock24xx.h
@@ -600,13 +600,6 @@ static struct prcm_config rate_table[] = {
 	{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
 };
 
-/*
- * Since 2420 and 2430 have different cm_base, we use offsets only here.
- * Clock code will rewrite the register address as needed.
- */
-#define _CM_REG_OFFSET(module, reg)	((void __iomem *)(module) + (reg))
-#define _GR_MOD_OFFSET(reg)	((void __iomem *)(OMAP24XX_GR_MOD + (reg)))
-
 /*-------------------------------------------------------------------------
  * 24xx clock tree.
  *
@@ -677,10 +670,10 @@ static struct clk alt_ck = {		/* Typical 54M or 48M, may not exist */
  */
 
 static struct dpll_data dpll_dd = {
-	.mult_div1_reg		= _CM_REG_OFFSET(PLL_MOD, CM_CLKSEL1),
+	.mult_div1_reg		= CM_CLKSEL1,
 	.mult_mask		= OMAP24XX_DPLL_MULT_MASK,
 	.div1_mask		= OMAP24XX_DPLL_DIV_MASK,
-	.control_reg		= _CM_REG_OFFSET(PLL_MOD, CM_CLKEN),
+	.control_reg		= CM_CLKEN,
 	.enable_mask		= OMAP24XX_EN_DPLL_MASK,
 	.max_multiplier		= 1024,
 	.min_divider		= 1,
@@ -712,7 +705,7 @@ static struct clk apll96_ck = {
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				RATE_FIXED | RATE_PROPAGATES | ENABLE_ON_INIT,
 	.clkdm		= { .name = "prm_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(PLL_MOD, CM_CLKEN),
+	.enable_reg	= CM_CLKEN,
 	.enable_bit	= OMAP24XX_EN_96M_PLL_SHIFT,
 	.enable		= &omap2_clk_fixed_enable,
 	.disable	= &omap2_clk_fixed_disable,
@@ -727,7 +720,7 @@ static struct clk apll54_ck = {
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				RATE_FIXED | RATE_PROPAGATES | ENABLE_ON_INIT,
 	.clkdm		= { .name = "prm_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(PLL_MOD, CM_CLKEN),
+	.enable_reg	= CM_CLKEN,
 	.enable_bit	= OMAP24XX_EN_54M_PLL_SHIFT,
 	.enable		= &omap2_clk_fixed_enable,
 	.disable	= &omap2_clk_fixed_disable,
@@ -764,7 +757,7 @@ static struct clk func_54m_ck = {
 				RATE_PROPAGATES | PARENT_CONTROLS_CLOCK,
 	.clkdm		= { .name = "cm_clkdm" },
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= _CM_REG_OFFSET(PLL_MOD, CM_CLKSEL1),
+	.clksel_reg	= CM_CLKSEL1,
 	.clksel_mask	= OMAP24XX_54M_SOURCE,
 	.clksel		= func_54m_clksel,
 	.recalc		= &omap2_clksel_recalc,
@@ -805,7 +798,7 @@ static struct clk func_96m_ck = {
 				RATE_PROPAGATES | PARENT_CONTROLS_CLOCK,
 	.clkdm		= { .name = "cm_clkdm" },
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= _CM_REG_OFFSET(PLL_MOD, CM_CLKSEL1),
+	.clksel_reg	= CM_CLKSEL1,
 	.clksel_mask	= OMAP2430_96M_SOURCE,
 	.clksel		= func_96m_clksel,
 	.recalc		= &omap2_clksel_recalc,
@@ -839,7 +832,7 @@ static struct clk func_48m_ck = {
 				RATE_PROPAGATES | PARENT_CONTROLS_CLOCK,
 	.clkdm		= { .name = "cm_clkdm" },
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= _CM_REG_OFFSET(PLL_MOD, CM_CLKSEL1),
+	.clksel_reg	= CM_CLKSEL1,
 	.clksel_mask	= OMAP24XX_48M_SOURCE,
 	.clksel		= func_48m_clksel,
 	.recalc		= &omap2_clksel_recalc,
@@ -907,12 +900,12 @@ static struct clk sys_clkout_src = {
 	.parent		= &func_54m_ck,
 	.prcm_mod	= OMAP24XX_GR_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
-				RATE_PROPAGATES | OFFSET_GR_MOD,
+				RATE_PROPAGATES,
 	.clkdm		= { .name = "prm_clkdm" },
-	.enable_reg	= _GR_MOD_OFFSET(OMAP24XX_PRCM_CLKOUT_CTRL_OFFSET),
+	.enable_reg	= OMAP24XX_PRCM_CLKOUT_CTRL_OFFSET,
 	.enable_bit	= OMAP24XX_CLKOUT_EN_SHIFT,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= _GR_MOD_OFFSET(OMAP24XX_PRCM_CLKOUT_CTRL_OFFSET),
+	.clksel_reg	= OMAP24XX_PRCM_CLKOUT_CTRL_OFFSET,
 	.clksel_mask	= OMAP24XX_CLKOUT_SOURCE_MASK,
 	.clksel		= common_clkout_src_clksel,
 	.recalc		= &omap2_clksel_recalc,
@@ -939,9 +932,9 @@ static struct clk sys_clkout = {
 	.parent		= &sys_clkout_src,
 	.prcm_mod	= OMAP24XX_GR_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
-				PARENT_CONTROLS_CLOCK | OFFSET_GR_MOD,
+				PARENT_CONTROLS_CLOCK,
 	.clkdm		= { .name = "prm_clkdm" },
-	.clksel_reg	= _GR_MOD_OFFSET(OMAP24XX_PRCM_CLKOUT_CTRL_OFFSET),
+	.clksel_reg	= OMAP24XX_PRCM_CLKOUT_CTRL_OFFSET,
 	.clksel_mask	= OMAP24XX_CLKOUT_DIV_MASK,
 	.clksel		= sys_clkout_clksel,
 	.recalc		= &omap2_clksel_recalc,
@@ -954,12 +947,12 @@ static struct clk sys_clkout2_src = {
 	.name		= "sys_clkout2_src",
 	.parent		= &func_54m_ck,
 	.prcm_mod	= OMAP24XX_GR_MOD,
-	.flags		= CLOCK_IN_OMAP242X | RATE_PROPAGATES | OFFSET_GR_MOD,
+	.flags		= CLOCK_IN_OMAP242X | RATE_PROPAGATES,
 	.clkdm		= { .name = "cm_clkdm" },
-	.enable_reg	= _GR_MOD_OFFSET(OMAP24XX_PRCM_CLKOUT_CTRL_OFFSET),
+	.enable_reg	= OMAP24XX_PRCM_CLKOUT_CTRL_OFFSET,
 	.enable_bit	= OMAP2420_CLKOUT2_EN_SHIFT,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= _GR_MOD_OFFSET(OMAP24XX_PRCM_CLKOUT_CTRL_OFFSET),
+	.clksel_reg	= OMAP24XX_PRCM_CLKOUT_CTRL_OFFSET,
 	.clksel_mask	= OMAP2420_CLKOUT2_SOURCE_MASK,
 	.clksel		= common_clkout_src_clksel,
 	.recalc		= &omap2_clksel_recalc,
@@ -977,10 +970,9 @@ static struct clk sys_clkout2 = {
 	.name		= "sys_clkout2",
 	.parent		= &sys_clkout2_src,
 	.prcm_mod	= OMAP24XX_GR_MOD,
-	.flags		= CLOCK_IN_OMAP242X | PARENT_CONTROLS_CLOCK |
-				OFFSET_GR_MOD,
+	.flags		= CLOCK_IN_OMAP242X | PARENT_CONTROLS_CLOCK,
 	.clkdm		= { .name = "cm_clkdm" },
-	.clksel_reg	= _GR_MOD_OFFSET(OMAP24XX_PRCM_CLKOUT_CTRL_OFFSET),
+	.clksel_reg	= OMAP24XX_PRCM_CLKOUT_CTRL_OFFSET,
 	.clksel_mask	= OMAP2420_CLKOUT2_DIV_MASK,
 	.clksel		= sys_clkout2_clksel,
 	.recalc		= &omap2_clksel_recalc,
@@ -992,9 +984,9 @@ static struct clk emul_ck = {
 	.name		= "emul_ck",
 	.parent		= &func_54m_ck,
 	.prcm_mod	= OMAP24XX_GR_MOD,
-	.flags		= CLOCK_IN_OMAP242X | OFFSET_GR_MOD,
+	.flags		= CLOCK_IN_OMAP242X,
 	.clkdm		= { .name = "cm_clkdm" },
-	.enable_reg	= _GR_MOD_OFFSET(OMAP24XX_PRCM_CLKEMUL_CTRL_OFFSET),
+	.enable_reg	= OMAP24XX_PRCM_CLKEMUL_CTRL_OFFSET,
 	.enable_bit	= OMAP24XX_EMULATION_EN_SHIFT,
 	.recalc		= &followparent_recalc,
 
@@ -1033,7 +1025,7 @@ static struct clk mpu_ck = {	/* Control cpu */
 				CONFIG_PARTICIPANT | RATE_PROPAGATES,
 	.clkdm		= { .name = "mpu_clkdm" },
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= _CM_REG_OFFSET(MPU_MOD, CM_CLKSEL),
+	.clksel_reg	= CM_CLKSEL,
 	.clksel_mask	= OMAP24XX_CLKSEL_MPU_MASK,
 	.clksel		= mpu_clksel,
 	.recalc		= &omap2_clksel_recalc,
@@ -1075,9 +1067,9 @@ static struct clk dsp_fck = {
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X | DELAYED_APP |
 				CONFIG_PARTICIPANT | RATE_PROPAGATES,
 	.clkdm		= { .name = "dsp_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(OMAP24XX_DSP_MOD, CM_FCLKEN),
+	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP24XX_CM_FCLKEN_DSP_EN_DSP_SHIFT,
-	.clksel_reg	= _CM_REG_OFFSET(OMAP24XX_DSP_MOD, CM_CLKSEL),
+	.clksel_reg	= CM_CLKSEL,
 	.clksel_mask	= OMAP24XX_CLKSEL_DSP_MASK,
 	.clksel		= dsp_fck_clksel,
 	.recalc		= &omap2_clksel_recalc,
@@ -1106,7 +1098,7 @@ static struct clk dsp_irate_ick = {
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X | DELAYED_APP |
 				CONFIG_PARTICIPANT | PARENT_CONTROLS_CLOCK,
 	.clkdm		= { .name = "dsp_clkdm" },
-	.clksel_reg	= _CM_REG_OFFSET(OMAP24XX_DSP_MOD, CM_CLKSEL),
+	.clksel_reg	= CM_CLKSEL,
 	.clksel_mask	= OMAP24XX_CLKSEL_DSP_IF_MASK,
 	.clksel		= dsp_irate_ick_clksel,
 	.recalc		= &omap2_clksel_recalc,
@@ -1121,7 +1113,7 @@ static struct clk dsp_ick = {
 	.prcm_mod	= OMAP24XX_DSP_MOD,
 	.flags		= CLOCK_IN_OMAP242X | DELAYED_APP | CONFIG_PARTICIPANT,
 	.clkdm		= { .name = "dsp_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(OMAP24XX_DSP_MOD, CM_ICLKEN),
+	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP2420_EN_DSP_IPI_SHIFT,	      /* for ipi */
 };
 
@@ -1132,7 +1124,7 @@ static struct clk iva2_1_ick = {
 	.prcm_mod	= OMAP24XX_DSP_MOD,
 	.flags		= CLOCK_IN_OMAP243X | DELAYED_APP | CONFIG_PARTICIPANT,
 	.clkdm		= { .name = "dsp_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(OMAP24XX_DSP_MOD, CM_FCLKEN),
+	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP24XX_CM_FCLKEN_DSP_EN_DSP_SHIFT,
 };
 
@@ -1148,9 +1140,9 @@ static struct clk iva1_ifck = {
 	.flags		= CLOCK_IN_OMAP242X | CONFIG_PARTICIPANT |
 				RATE_PROPAGATES | DELAYED_APP,
 	.clkdm		= { .name = "iva1_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(OMAP24XX_DSP_MOD, CM_FCLKEN),
+	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP2420_EN_IVA_COP_SHIFT,
-	.clksel_reg	= _CM_REG_OFFSET(OMAP24XX_DSP_MOD, CM_CLKSEL),
+	.clksel_reg	= CM_CLKSEL,
 	.clksel_mask	= OMAP2420_CLKSEL_IVA_MASK,
 	.clksel		= dsp_fck_clksel,
 	.recalc		= &omap2_clksel_recalc,
@@ -1165,7 +1157,7 @@ static struct clk iva1_mpu_int_ifck = {
 	.prcm_mod	= OMAP24XX_DSP_MOD,
 	.flags		= CLOCK_IN_OMAP242X,
 	.clkdm		= { .name = "iva1_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(OMAP24XX_DSP_MOD, CM_FCLKEN),
+	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP2420_EN_IVA_MPU_SHIFT,
 	.fixed_div	= 2,
 	.recalc		= &omap2_fixed_divisor_recalc,
@@ -1214,7 +1206,7 @@ static struct clk core_l3_ck = {	/* Used for ick and fck, interconnect */
 				ALWAYS_ENABLED | DELAYED_APP |
 				CONFIG_PARTICIPANT | RATE_PROPAGATES,
 	.clkdm		= { .name = "core_l3_clkdm" },
-	.clksel_reg	= _CM_REG_OFFSET(CORE_MOD, CM_CLKSEL1),
+	.clksel_reg	= CM_CLKSEL1,
 	.clksel_mask	= OMAP24XX_CLKSEL_L3_MASK,
 	.clksel		= core_l3_clksel,
 	.recalc		= &omap2_clksel_recalc,
@@ -1243,9 +1235,9 @@ static struct clk usb_l4_ick = {	/* FS-USB interface clock */
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				DELAYED_APP | CONFIG_PARTICIPANT,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN2),
+	.enable_reg	= CM_ICLKEN2,
 	.enable_bit	= OMAP24XX_EN_USB_SHIFT,
-	.clksel_reg	= _CM_REG_OFFSET(CORE_MOD, CM_CLKSEL1),
+	.clksel_reg	= CM_CLKSEL1,
 	.clksel_mask	= OMAP24XX_CLKSEL_USB_MASK,
 	.clksel		= usb_l4_ick_clksel,
 	.recalc		= &omap2_clksel_recalc,
@@ -1278,7 +1270,7 @@ static struct clk l4_ck = {		/* used both as an ick and fck */
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				ALWAYS_ENABLED | DELAYED_APP | RATE_PROPAGATES,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.clksel_reg	= _CM_REG_OFFSET(CORE_MOD, CM_CLKSEL1),
+	.clksel_reg	= CM_CLKSEL1,
 	.clksel_mask	= OMAP24XX_CLKSEL_L4_MASK,
 	.clksel		= l4_clksel,
 	.recalc		= &omap2_clksel_recalc,
@@ -1317,9 +1309,9 @@ static struct clk ssi_ssr_sst_fck = {
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				DELAYED_APP,
 	.clkdm		= { .name = "core_l3_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_FCLKEN2),
+	.enable_reg	= OMAP24XX_CM_FCLKEN2,
 	.enable_bit	= OMAP24XX_EN_SSI_SHIFT,
-	.clksel_reg	= _CM_REG_OFFSET(CORE_MOD, CM_CLKSEL1),
+	.clksel_reg	= CM_CLKSEL1,
 	.clksel_mask	= OMAP24XX_CLKSEL_SSI_MASK,
 	.clksel		= ssi_ssr_sst_fck_clksel,
 	.recalc		= &omap2_clksel_recalc,
@@ -1337,7 +1329,7 @@ static struct clk ssi_l4_ick = {
 	.prcm_mod	= CORE_MOD,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN2),
+	.enable_reg	= CM_ICLKEN2,
 	.enable_bit	= OMAP24XX_EN_SSI_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -1368,9 +1360,9 @@ static struct clk gfx_3d_fck = {
 	.prcm_mod	= GFX_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "gfx_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(GFX_MOD, CM_FCLKEN),
+	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP24XX_EN_3D_SHIFT,
-	.clksel_reg	= _CM_REG_OFFSET(GFX_MOD, CM_CLKSEL),
+	.clksel_reg	= CM_CLKSEL,
 	.clksel_mask	= OMAP_CLKSEL_GFX_MASK,
 	.clksel		= gfx_fck_clksel,
 	.recalc		= &omap2_clksel_recalc,
@@ -1384,9 +1376,9 @@ static struct clk gfx_2d_fck = {
 	.prcm_mod	= GFX_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "gfx_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(GFX_MOD, CM_FCLKEN),
+	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP24XX_EN_2D_SHIFT,
-	.clksel_reg	= _CM_REG_OFFSET(GFX_MOD, CM_CLKSEL),
+	.clksel_reg	= CM_CLKSEL,
 	.clksel_mask	= OMAP_CLKSEL_GFX_MASK,
 	.clksel		= gfx_fck_clksel,
 	.recalc		= &omap2_clksel_recalc,
@@ -1400,7 +1392,7 @@ static struct clk gfx_ick = {
 	.prcm_mod	= GFX_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "gfx_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(GFX_MOD, CM_ICLKEN),
+	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP_EN_GFX_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -1431,9 +1423,9 @@ static struct clk mdm_ick = {		/* used both as a ick and fck */
 	.prcm_mod	= OMAP2430_MDM_MOD,
 	.flags		= CLOCK_IN_OMAP243X | DELAYED_APP | CONFIG_PARTICIPANT,
 	.clkdm		= { .name = "mdm_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(OMAP2430_MDM_MOD, CM_ICLKEN),
+	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP2430_CM_ICLKEN_MDM_EN_MDM_SHIFT,
-	.clksel_reg	= _CM_REG_OFFSET(OMAP2430_MDM_MOD, CM_CLKSEL),
+	.clksel_reg	= CM_CLKSEL,
 	.clksel_mask	= OMAP2430_CLKSEL_MDM_MASK,
 	.clksel		= mdm_ick_clksel,
 	.recalc		= &omap2_clksel_recalc,
@@ -1447,7 +1439,7 @@ static struct clk mdm_osc_ck = {
 	.prcm_mod	= OMAP2430_MDM_MOD,
 	.flags		= CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "mdm_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(OMAP2430_MDM_MOD, CM_FCLKEN),
+	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP2430_EN_OSC_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -1493,7 +1485,7 @@ static struct clk dss_ick = {		/* Enables both L3,L4 ICLK's */
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "dss_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP24XX_EN_DSS1_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -1505,10 +1497,10 @@ static struct clk dss1_fck = {
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				DELAYED_APP,
 	.clkdm		= { .name = "dss_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP24XX_EN_DSS1_SHIFT,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= _CM_REG_OFFSET(CORE_MOD, CM_CLKSEL1),
+	.clksel_reg	= CM_CLKSEL1,
 	.clksel_mask	= OMAP24XX_CLKSEL_DSS1_MASK,
 	.clksel		= dss1_fck_clksel,
 	.recalc		= &omap2_clksel_recalc,
@@ -1539,10 +1531,10 @@ static struct clk dss2_fck = {		/* Alt clk used in power management */
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				DELAYED_APP,
 	.clkdm		= { .name = "dss_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP24XX_EN_DSS2_SHIFT,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= _CM_REG_OFFSET(CORE_MOD, CM_CLKSEL1),
+	.clksel_reg	= CM_CLKSEL1,
 	.clksel_mask	= OMAP24XX_CLKSEL_DSS2_MASK,
 	.clksel		= dss2_fck_clksel,
 	.recalc		= &followparent_recalc,
@@ -1554,7 +1546,7 @@ static struct clk dss_54m_fck = {	/* Alt clk used in power management */
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "dss_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP24XX_EN_TV_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -1583,7 +1575,7 @@ static struct clk gpt1_ick = {
 	.prcm_mod	= WKUP_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(WKUP_MOD, CM_ICLKEN),
+	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP24XX_EN_GPT1_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -1594,10 +1586,10 @@ static struct clk gpt1_fck = {
 	.prcm_mod	= WKUP_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(WKUP_MOD, CM_FCLKEN),
+	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP24XX_EN_GPT1_SHIFT,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= _CM_REG_OFFSET(WKUP_MOD, CM_CLKSEL1),
+	.clksel_reg	= CM_CLKSEL1,
 	.clksel_mask	= OMAP24XX_CLKSEL_GPT1_MASK,
 	.clksel		= omap24xx_gpt_clksel,
 	.recalc		= &omap2_clksel_recalc,
@@ -1611,7 +1603,7 @@ static struct clk gpt2_ick = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP24XX_EN_GPT2_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -1622,10 +1614,10 @@ static struct clk gpt2_fck = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP24XX_EN_GPT2_SHIFT,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= _CM_REG_OFFSET(CORE_MOD, CM_CLKSEL2),
+	.clksel_reg	= CM_CLKSEL2,
 	.clksel_mask	= OMAP24XX_CLKSEL_GPT2_MASK,
 	.clksel		= omap24xx_gpt_clksel,
 	.recalc		= &omap2_clksel_recalc,
@@ -1637,7 +1629,7 @@ static struct clk gpt3_ick = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP24XX_EN_GPT3_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -1648,10 +1640,10 @@ static struct clk gpt3_fck = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP24XX_EN_GPT3_SHIFT,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= _CM_REG_OFFSET(CORE_MOD, CM_CLKSEL2),
+	.clksel_reg	= CM_CLKSEL2,
 	.clksel_mask	= OMAP24XX_CLKSEL_GPT3_MASK,
 	.clksel		= omap24xx_gpt_clksel,
 	.recalc		= &omap2_clksel_recalc,
@@ -1663,7 +1655,7 @@ static struct clk gpt4_ick = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP24XX_EN_GPT4_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -1674,10 +1666,10 @@ static struct clk gpt4_fck = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP24XX_EN_GPT4_SHIFT,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= _CM_REG_OFFSET(CORE_MOD, CM_CLKSEL2),
+	.clksel_reg	= CM_CLKSEL2,
 	.clksel_mask	= OMAP24XX_CLKSEL_GPT4_MASK,
 	.clksel		= omap24xx_gpt_clksel,
 	.recalc		= &omap2_clksel_recalc,
@@ -1689,7 +1681,7 @@ static struct clk gpt5_ick = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP24XX_EN_GPT5_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -1700,10 +1692,10 @@ static struct clk gpt5_fck = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP24XX_EN_GPT5_SHIFT,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= _CM_REG_OFFSET(CORE_MOD, CM_CLKSEL2),
+	.clksel_reg	= CM_CLKSEL2,
 	.clksel_mask	= OMAP24XX_CLKSEL_GPT5_MASK,
 	.clksel		= omap24xx_gpt_clksel,
 	.recalc		= &omap2_clksel_recalc,
@@ -1715,7 +1707,7 @@ static struct clk gpt6_ick = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP24XX_EN_GPT6_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -1726,10 +1718,10 @@ static struct clk gpt6_fck = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP24XX_EN_GPT6_SHIFT,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= _CM_REG_OFFSET(CORE_MOD, CM_CLKSEL2),
+	.clksel_reg	= CM_CLKSEL2,
 	.clksel_mask	= OMAP24XX_CLKSEL_GPT6_MASK,
 	.clksel		= omap24xx_gpt_clksel,
 	.recalc		= &omap2_clksel_recalc,
@@ -1741,7 +1733,7 @@ static struct clk gpt7_ick = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP24XX_EN_GPT7_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -1752,10 +1744,10 @@ static struct clk gpt7_fck = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP24XX_EN_GPT7_SHIFT,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= _CM_REG_OFFSET(CORE_MOD, CM_CLKSEL2),
+	.clksel_reg	= CM_CLKSEL2,
 	.clksel_mask	= OMAP24XX_CLKSEL_GPT7_MASK,
 	.clksel		= omap24xx_gpt_clksel,
 	.recalc		= &omap2_clksel_recalc,
@@ -1767,7 +1759,7 @@ static struct clk gpt8_ick = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP24XX_EN_GPT8_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -1778,10 +1770,10 @@ static struct clk gpt8_fck = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP24XX_EN_GPT8_SHIFT,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= _CM_REG_OFFSET(CORE_MOD, CM_CLKSEL2),
+	.clksel_reg	= CM_CLKSEL2,
 	.clksel_mask	= OMAP24XX_CLKSEL_GPT8_MASK,
 	.clksel		= omap24xx_gpt_clksel,
 	.recalc		= &omap2_clksel_recalc,
@@ -1793,7 +1785,7 @@ static struct clk gpt9_ick = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP24XX_EN_GPT9_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -1804,10 +1796,10 @@ static struct clk gpt9_fck = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP24XX_EN_GPT9_SHIFT,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= _CM_REG_OFFSET(CORE_MOD, CM_CLKSEL2),
+	.clksel_reg	= CM_CLKSEL2,
 	.clksel_mask	= OMAP24XX_CLKSEL_GPT9_MASK,
 	.clksel		= omap24xx_gpt_clksel,
 	.recalc		= &omap2_clksel_recalc,
@@ -1819,7 +1811,7 @@ static struct clk gpt10_ick = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP24XX_EN_GPT10_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -1830,10 +1822,10 @@ static struct clk gpt10_fck = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP24XX_EN_GPT10_SHIFT,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= _CM_REG_OFFSET(CORE_MOD, CM_CLKSEL2),
+	.clksel_reg	= CM_CLKSEL2,
 	.clksel_mask	= OMAP24XX_CLKSEL_GPT10_MASK,
 	.clksel		= omap24xx_gpt_clksel,
 	.recalc		= &omap2_clksel_recalc,
@@ -1845,7 +1837,7 @@ static struct clk gpt11_ick = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP24XX_EN_GPT11_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -1856,10 +1848,10 @@ static struct clk gpt11_fck = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP24XX_EN_GPT11_SHIFT,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= _CM_REG_OFFSET(CORE_MOD, CM_CLKSEL2),
+	.clksel_reg	= CM_CLKSEL2,
 	.clksel_mask	= OMAP24XX_CLKSEL_GPT11_MASK,
 	.clksel		= omap24xx_gpt_clksel,
 	.recalc		= &omap2_clksel_recalc,
@@ -1871,7 +1863,7 @@ static struct clk gpt12_ick = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP24XX_EN_GPT12_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -1882,10 +1874,10 @@ static struct clk gpt12_fck = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP24XX_EN_GPT12_SHIFT,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= _CM_REG_OFFSET(CORE_MOD, CM_CLKSEL2),
+	.clksel_reg	= CM_CLKSEL2,
 	.clksel_mask	= OMAP24XX_CLKSEL_GPT12_MASK,
 	.clksel		= omap24xx_gpt_clksel,
 	.recalc		= &omap2_clksel_recalc,
@@ -1898,7 +1890,7 @@ static struct clk mcbsp1_ick = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP24XX_EN_MCBSP1_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -1910,7 +1902,7 @@ static struct clk mcbsp1_fck = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP24XX_EN_MCBSP1_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -1922,7 +1914,7 @@ static struct clk mcbsp2_ick = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP24XX_EN_MCBSP2_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -1934,7 +1926,7 @@ static struct clk mcbsp2_fck = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP24XX_EN_MCBSP2_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -1946,7 +1938,7 @@ static struct clk mcbsp3_ick = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN2),
+	.enable_reg	= CM_ICLKEN2,
 	.enable_bit	= OMAP2430_EN_MCBSP3_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -1958,7 +1950,7 @@ static struct clk mcbsp3_fck = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_FCLKEN2),
+	.enable_reg	= OMAP24XX_CM_FCLKEN2,
 	.enable_bit	= OMAP2430_EN_MCBSP3_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -1970,7 +1962,7 @@ static struct clk mcbsp4_ick = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN2),
+	.enable_reg	= CM_ICLKEN2,
 	.enable_bit	= OMAP2430_EN_MCBSP4_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -1982,7 +1974,7 @@ static struct clk mcbsp4_fck = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_FCLKEN2),
+	.enable_reg	= OMAP24XX_CM_FCLKEN2,
 	.enable_bit	= OMAP2430_EN_MCBSP4_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -1994,7 +1986,7 @@ static struct clk mcbsp5_ick = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN2),
+	.enable_reg	= CM_ICLKEN2,
 	.enable_bit	= OMAP2430_EN_MCBSP5_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2006,7 +1998,7 @@ static struct clk mcbsp5_fck = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_FCLKEN2),
+	.enable_reg	= OMAP24XX_CM_FCLKEN2,
 	.enable_bit	= OMAP2430_EN_MCBSP5_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2018,7 +2010,7 @@ static struct clk mcspi1_ick = {
 	.prcm_mod	= CORE_MOD,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP24XX_EN_MCSPI1_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2030,7 +2022,7 @@ static struct clk mcspi1_fck = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP24XX_EN_MCSPI1_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2042,7 +2034,7 @@ static struct clk mcspi2_ick = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP24XX_EN_MCSPI2_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2054,7 +2046,7 @@ static struct clk mcspi2_fck = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP24XX_EN_MCSPI2_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2066,7 +2058,7 @@ static struct clk mcspi3_ick = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN2),
+	.enable_reg	= CM_ICLKEN2,
 	.enable_bit	= OMAP2430_EN_MCSPI3_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2078,7 +2070,7 @@ static struct clk mcspi3_fck = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_FCLKEN2),
+	.enable_reg	= OMAP24XX_CM_FCLKEN2,
 	.enable_bit	= OMAP2430_EN_MCSPI3_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2089,7 +2081,7 @@ static struct clk uart1_ick = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP24XX_EN_UART1_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2100,7 +2092,7 @@ static struct clk uart1_fck = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP24XX_EN_UART1_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2111,7 +2103,7 @@ static struct clk uart2_ick = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP24XX_EN_UART2_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2122,7 +2114,7 @@ static struct clk uart2_fck = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP24XX_EN_UART2_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2133,7 +2125,7 @@ static struct clk uart3_ick = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN2),
+	.enable_reg	= CM_ICLKEN2,
 	.enable_bit	= OMAP24XX_EN_UART3_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2144,7 +2136,7 @@ static struct clk uart3_fck = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_FCLKEN2),
+	.enable_reg	= OMAP24XX_CM_FCLKEN2,
 	.enable_bit	= OMAP24XX_EN_UART3_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2155,7 +2147,7 @@ static struct clk gpios_ick = {
 	.prcm_mod	= WKUP_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(WKUP_MOD, CM_ICLKEN),
+	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP24XX_EN_GPIOS_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2166,7 +2158,7 @@ static struct clk gpios_fck = {
 	.prcm_mod	= WKUP_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "prm_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(WKUP_MOD, CM_FCLKEN),
+	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP24XX_EN_GPIOS_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2178,7 +2170,7 @@ static struct clk mpu_wdt_ick = {
 	.prcm_mod	= WKUP_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "prm_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(WKUP_MOD, CM_ICLKEN),
+	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP24XX_EN_MPU_WDT_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2190,7 +2182,7 @@ static struct clk mpu_wdt_fck = {
 	.prcm_mod	= WKUP_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "prm_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(WKUP_MOD, CM_FCLKEN),
+	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP24XX_EN_MPU_WDT_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2202,7 +2194,7 @@ static struct clk sync_32k_ick = {
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				ENABLE_ON_INIT,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(WKUP_MOD, CM_ICLKEN),
+	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP24XX_EN_32KSYNC_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2214,7 +2206,7 @@ static struct clk wdt1_ick = {
 	.prcm_mod	= WKUP_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "prm_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(WKUP_MOD, CM_ICLKEN),
+	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP24XX_EN_WDT1_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2226,7 +2218,7 @@ static struct clk omapctrl_ick = {
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				ENABLE_ON_INIT,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(WKUP_MOD, CM_ICLKEN),
+	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP24XX_EN_OMAPCTRL_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2237,7 +2229,7 @@ static struct clk icr_ick = {
 	.prcm_mod	= WKUP_MOD,
 	.flags		= CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(WKUP_MOD, CM_ICLKEN),
+	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP2430_EN_ICR_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2248,7 +2240,7 @@ static struct clk cam_ick = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP24XX_EN_CAM_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2264,7 +2256,7 @@ static struct clk cam_fck = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l3_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP24XX_EN_CAM_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2275,7 +2267,7 @@ static struct clk mailboxes_ick = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP24XX_EN_MAILBOXES_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2286,7 +2278,7 @@ static struct clk wdt4_ick = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP24XX_EN_WDT4_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2297,7 +2289,7 @@ static struct clk wdt4_fck = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP24XX_EN_WDT4_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2308,7 +2300,7 @@ static struct clk wdt3_ick = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP2420_EN_WDT3_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2319,7 +2311,7 @@ static struct clk wdt3_fck = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP2420_EN_WDT3_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2330,7 +2322,7 @@ static struct clk mspro_ick = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP24XX_EN_MSPRO_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2341,7 +2333,7 @@ static struct clk mspro_fck = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP24XX_EN_MSPRO_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2352,7 +2344,7 @@ static struct clk mmc_ick = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP2420_EN_MMC_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2363,7 +2355,7 @@ static struct clk mmc_fck = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP2420_EN_MMC_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2374,7 +2366,7 @@ static struct clk fac_ick = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP24XX_EN_FAC_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2385,7 +2377,7 @@ static struct clk fac_fck = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP24XX_EN_FAC_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2396,7 +2388,7 @@ static struct clk eac_ick = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP2420_EN_EAC_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2407,7 +2399,7 @@ static struct clk eac_fck = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP2420_EN_EAC_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2418,7 +2410,7 @@ static struct clk hdq_ick = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP24XX_EN_HDQ_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2429,7 +2421,7 @@ static struct clk hdq_fck = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP24XX_EN_HDQ_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2441,7 +2433,7 @@ static struct clk i2c2_ick = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP2420_EN_I2C2_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2453,7 +2445,7 @@ static struct clk i2c2_fck = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP2420_EN_I2C2_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2465,7 +2457,7 @@ static struct clk i2chs2_fck = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_FCLKEN2),
+	.enable_reg	= OMAP24XX_CM_FCLKEN2,
 	.enable_bit	= OMAP2430_EN_I2CHS2_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2477,7 +2469,7 @@ static struct clk i2c1_ick = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP2420_EN_I2C1_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2489,7 +2481,7 @@ static struct clk i2c1_fck = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP2420_EN_I2C1_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2501,7 +2493,7 @@ static struct clk i2chs1_fck = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_FCLKEN2),
+	.enable_reg	= OMAP24XX_CM_FCLKEN2,
 	.enable_bit	= OMAP2430_EN_I2CHS1_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2537,7 +2529,7 @@ static struct clk vlynq_ick = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X,
 	.clkdm		= { .name = "core_l3_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP2420_EN_VLYNQ_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2573,10 +2565,10 @@ static struct clk vlynq_fck = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | DELAYED_APP,
 	.clkdm		= { .name = "core_l3_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP2420_EN_VLYNQ_SHIFT,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= _CM_REG_OFFSET(CORE_MOD, CM_CLKSEL1),
+	.clksel_reg	= CM_CLKSEL1,
 	.clksel_mask	= OMAP2420_CLKSEL_VLYNQ_MASK,
 	.clksel		= vlynq_fck_clksel,
 	.recalc		= &omap2_clksel_recalc,
@@ -2590,7 +2582,7 @@ static struct clk sdrc_ick = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP243X | ENABLE_ON_INIT,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN3),
+	.enable_reg	= CM_ICLKEN3,
 	.enable_bit	= OMAP2430_EN_SDRC_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2601,7 +2593,7 @@ static struct clk des_ick = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP243X | CLOCK_IN_OMAP242X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_ICLKEN4),
+	.enable_reg	= OMAP24XX_CM_ICLKEN4,
 	.enable_bit	= OMAP24XX_EN_DES_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2612,7 +2604,7 @@ static struct clk sha_ick = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP243X | CLOCK_IN_OMAP242X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_ICLKEN4),
+	.enable_reg	= OMAP24XX_CM_ICLKEN4,
 	.enable_bit	= OMAP24XX_EN_SHA_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2623,7 +2615,7 @@ static struct clk rng_ick = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP243X | CLOCK_IN_OMAP242X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_ICLKEN4),
+	.enable_reg	= OMAP24XX_CM_ICLKEN4,
 	.enable_bit	= OMAP24XX_EN_RNG_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2634,7 +2626,7 @@ static struct clk aes_ick = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP243X | CLOCK_IN_OMAP242X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_ICLKEN4),
+	.enable_reg	= OMAP24XX_CM_ICLKEN4,
 	.enable_bit	= OMAP24XX_EN_AES_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2645,7 +2637,7 @@ static struct clk pka_ick = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP243X | CLOCK_IN_OMAP242X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_ICLKEN4),
+	.enable_reg	= OMAP24XX_CM_ICLKEN4,
 	.enable_bit	= OMAP24XX_EN_PKA_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2656,7 +2648,7 @@ static struct clk usb_fck = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP243X | CLOCK_IN_OMAP242X,
 	.clkdm		= { .name = "core_l3_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_FCLKEN2),
+	.enable_reg	= OMAP24XX_CM_FCLKEN2,
 	.enable_bit	= OMAP24XX_EN_USB_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2667,7 +2659,7 @@ static struct clk usbhs_ick = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l3_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN2),
+	.enable_reg	= CM_ICLKEN2,
 	.enable_bit	= OMAP2430_EN_USBHS_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2678,7 +2670,7 @@ static struct clk mmchs1_ick = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN2),
+	.enable_reg	= CM_ICLKEN2,
 	.enable_bit	= OMAP2430_EN_MMCHS1_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2689,7 +2681,7 @@ static struct clk mmchs1_fck = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l3_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_FCLKEN2),
+	.enable_reg	= OMAP24XX_CM_FCLKEN2,
 	.enable_bit	= OMAP2430_EN_MMCHS1_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2701,7 +2693,7 @@ static struct clk mmchs2_ick = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN2),
+	.enable_reg	= CM_ICLKEN2,
 	.enable_bit	= OMAP2430_EN_MMCHS2_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2713,7 +2705,7 @@ static struct clk mmchs2_fck = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_FCLKEN2),
+	.enable_reg	= OMAP24XX_CM_FCLKEN2,
 	.enable_bit	= OMAP2430_EN_MMCHS2_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2724,7 +2716,7 @@ static struct clk gpio5_ick = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN2),
+	.enable_reg	= CM_ICLKEN2,
 	.enable_bit	= OMAP2430_EN_GPIO5_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2735,7 +2727,7 @@ static struct clk gpio5_fck = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_FCLKEN2),
+	.enable_reg	= OMAP24XX_CM_FCLKEN2,
 	.enable_bit	= OMAP2430_EN_GPIO5_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2746,7 +2738,7 @@ static struct clk mdm_intc_ick = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN2),
+	.enable_reg	= CM_ICLKEN2,
 	.enable_bit	= OMAP2430_EN_MDM_INTC_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2757,7 +2749,7 @@ static struct clk mmchsdb1_fck = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_FCLKEN2),
+	.enable_reg	= OMAP24XX_CM_FCLKEN2,
 	.enable_bit	= OMAP2430_EN_MMCHSDB1_SHIFT,
 	.recalc		= &followparent_recalc,
 };
@@ -2769,7 +2761,7 @@ static struct clk mmchsdb2_fck = {
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_FCLKEN2),
+	.enable_reg	= OMAP24XX_CM_FCLKEN2,
 	.enable_bit	= OMAP2430_EN_MMCHSDB2_SHIFT,
 	.recalc		= &followparent_recalc,
 };
diff --git a/arch/arm/mach-omap2/clock34xx.c b/arch/arm/mach-omap2/clock34xx.c
index 0c8d88e..c3c8537 100644
--- a/arch/arm/mach-omap2/clock34xx.c
+++ b/arch/arm/mach-omap2/clock34xx.c
@@ -66,10 +66,10 @@ static void _omap3_dpll_write_clken(struct clk *clk, u8 clken_bits)
 
 	dd = clk->dpll_data;
 
-	v = __raw_readl(dd->control_reg);
+	v = cm_read_mod_reg(clk->prcm_mod, dd->control_reg);
 	v &= ~dd->enable_mask;
 	v |= clken_bits << __ffs(dd->enable_mask);
-	__raw_writel(v, dd->control_reg);
+	cm_write_mod_reg(v, clk->prcm_mod, dd->control_reg);
 }
 
 /* _omap3_wait_dpll_status: wait for a DPLL to enter a specific state */
@@ -83,7 +83,8 @@ static int _omap3_wait_dpll_status(struct clk *clk, u8 state)
 
 	state <<= __ffs(dd->idlest_mask);
 
-	while (((__raw_readl(dd->idlest_reg) & dd->idlest_mask) != state) &&
+	while (((cm_read_mod_reg(clk->prcm_mod, dd->idlest_reg)
+		 & dd->idlest_mask) != state) &&
 	       i < MAX_DPLL_WAIT_TRIES) {
 		i++;
 		udelay(1);
@@ -348,17 +349,17 @@ static int omap3_noncore_dpll_program(struct clk *clk, u16 m, u8 n, u16 freqsel)
 	_omap3_noncore_dpll_bypass(clk);
 
 	/* Set jitter correction */
-	v = __raw_readl(dd->control_reg);
+	v = cm_read_mod_reg(clk->prcm_mod, dd->control_reg);
 	v &= ~dd->freqsel_mask;
 	v |= freqsel << __ffs(dd->freqsel_mask);
-	__raw_writel(v, dd->control_reg);
+	cm_write_mod_reg(v, clk->prcm_mod, dd->control_reg);
 
 	/* Set DPLL multiplier, divider */
-	v = __raw_readl(dd->mult_div1_reg);
+	v = cm_read_mod_reg(clk->prcm_mod, dd->mult_div1_reg);
 	v &= ~(dd->mult_mask | dd->div1_mask);
 	v |= m << __ffs(dd->mult_mask);
 	v |= (n - 1) << __ffs(dd->div1_mask);
-	__raw_writel(v, dd->mult_div1_reg);
+	cm_write_mod_reg(v, clk->prcm_mod, dd->mult_div1_reg);
 
 	/* We let the clock framework set the other output dividers later */
 
@@ -454,7 +455,7 @@ static u32 omap3_dpll_autoidle_read(struct clk *clk)
 
 	dd = clk->dpll_data;
 
-	v = __raw_readl(dd->autoidle_reg);
+	v = cm_read_mod_reg(clk->prcm_mod, dd->autoidle_reg);
 	v &= dd->autoidle_mask;
 	v >>= __ffs(dd->autoidle_mask);
 
@@ -485,10 +486,10 @@ static void omap3_dpll_allow_idle(struct clk *clk)
 	 * by writing 0x5 instead of 0x1.  Add some mechanism to
 	 * optionally enter this mode.
 	 */
-	v = __raw_readl(dd->autoidle_reg);
+	v = cm_read_mod_reg(clk->prcm_mod, dd->autoidle_reg);
 	v &= ~dd->autoidle_mask;
 	v |= DPLL_AUTOIDLE_LOW_POWER_STOP << __ffs(dd->autoidle_mask);
-	__raw_writel(v, dd->autoidle_reg);
+	cm_write_mod_reg(v, clk->prcm_mod, dd->autoidle_reg);
 }
 
 /**
@@ -507,10 +508,10 @@ static void omap3_dpll_deny_idle(struct clk *clk)
 
 	dd = clk->dpll_data;
 
-	v = __raw_readl(dd->autoidle_reg);
+	v = cm_read_mod_reg(clk->prcm_mod, dd->autoidle_reg);
 	v &= ~dd->autoidle_mask;
 	v |= DPLL_AUTOIDLE_DISABLE << __ffs(dd->autoidle_mask);
-	__raw_writel(v, dd->autoidle_reg);
+	cm_write_mod_reg(v, clk->prcm_mod, dd->autoidle_reg);
 }
 
 /* Clock control for DPLL outputs */
@@ -540,7 +541,7 @@ static void omap3_clkoutx2_recalc(struct clk *clk)
 
 	WARN_ON(!dd->enable_mask);
 
-	v = __raw_readl(dd->control_reg) & dd->enable_mask;
+	v = cm_read_mod_reg(pclk->prcm_mod, dd->control_reg) & dd->enable_mask;
 	v >>= __ffs(dd->enable_mask);
 	if (v != OMAP3XXX_EN_DPLL_LOCKED)
 		clk->rate = clk->parent->rate;
diff --git a/arch/arm/mach-omap2/clock34xx.h b/arch/arm/mach-omap2/clock34xx.h
index e0cb6c3..aef5049 100644
--- a/arch/arm/mach-omap2/clock34xx.h
+++ b/arch/arm/mach-omap2/clock34xx.h
@@ -57,15 +57,6 @@ static struct clk dpll2_fck;
 #define DPLL_LOW_POWER_BYPASS		0x5
 #define DPLL_LOCKED			0x7
 
-#define OMAP3430_PRM_CLKSRC_CTRL					\
-	OMAP34XX_PRM_REGADDR(OMAP3430_GR_MOD, 0x0070)
-
-#define OMAP3430_PRM_CLKSEL						\
-	OMAP34XX_PRM_REGADDR(OMAP3430_CCR_MOD, OMAP3_PRM_CLKSEL_OFFSET)
-
-#define OMAP3430_PRM_CLKOUT_CTRL					\
-	OMAP34XX_PRM_REGADDR(OMAP3430_CCR_MOD, OMAP3_PRM_CLKOUT_CTRL_OFFSET)
-
 /* PRM CLOCKS */
 
 /* According to timer32k.c, this is a 32768Hz clock, not a 32000Hz clock. */
@@ -188,7 +179,7 @@ static struct clk osc_sys_ck = {
 	.name		= "osc_sys_ck",
 	.prcm_mod	= OMAP3430_CCR_MOD | CLK_REG_IN_PRM,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= OMAP3430_PRM_CLKSEL,
+	.clksel_reg	= OMAP3_PRM_CLKSEL_OFFSET,
 	.clksel_mask	= OMAP3430_SYS_CLKIN_SEL_MASK,
 	.clksel		= osc_sys_clksel,
 	/* REVISIT: deal with autoextclkmode? */
@@ -216,7 +207,7 @@ static struct clk sys_ck = {
 	.parent		= &osc_sys_ck,
 	.prcm_mod	= OMAP3430_GR_MOD | CLK_REG_IN_PRM,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= OMAP3430_PRM_CLKSRC_CTRL,
+	.clksel_reg	= OMAP3_PRM_CLKSRC_CTRL_OFFSET,
 	.clksel_mask	= OMAP_SYSCLKDIV_MASK,
 	.clksel		= sys_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | ALWAYS_ENABLED,
@@ -249,7 +240,7 @@ static struct clk sys_clkout1 = {
 	.name		= "sys_clkout1",
 	.parent		= &osc_sys_ck,
 	.prcm_mod	= OMAP3430_CCR_MOD | CLK_REG_IN_PRM,
-	.enable_reg	= OMAP3430_PRM_CLKOUT_CTRL,
+	.enable_reg	= OMAP3_PRM_CLKOUT_CTRL_OFFSET,
 	.enable_bit	= OMAP3430_CLKOUT_EN_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "prm_clkdm" },
@@ -280,26 +271,23 @@ static const struct clksel_rate div16_dpll_rates[] = {
 	{ .div = 0 }
 };
 
-#define _OMAP34XX_CM_REGADDR(module, reg)				\
-	((__force void __iomem *)(OMAP34XX_CM_REGADDR((module), (reg))))
-
 /* DPLL1 */
 /* MPU clock source */
 /* Type: DPLL */
 static struct dpll_data dpll1_dd = {
-	.mult_div1_reg	= _OMAP34XX_CM_REGADDR(MPU_MOD, OMAP3430_CM_CLKSEL1_PLL),
+	.mult_div1_reg	= OMAP3430_CM_CLKSEL1_PLL,
 	.mult_mask	= OMAP3430_MPU_DPLL_MULT_MASK,
 	.div1_mask	= OMAP3430_MPU_DPLL_DIV_MASK,
 	.freqsel_mask	= OMAP3430_MPU_DPLL_FREQSEL_MASK,
-	.control_reg	= _OMAP34XX_CM_REGADDR(MPU_MOD, OMAP3430_CM_CLKEN_PLL),
+	.control_reg	= OMAP3430_CM_CLKEN_PLL,
 	.enable_mask	= OMAP3430_EN_MPU_DPLL_MASK,
 	.modes		= (1 << DPLL_LOW_POWER_BYPASS) | (1 << DPLL_LOCKED),
 	.auto_recal_bit	= OMAP3430_EN_MPU_DPLL_DRIFTGUARD_SHIFT,
 	.recal_en_bit	= OMAP3430_MPU_DPLL_RECAL_EN_SHIFT,
 	.recal_st_bit	= OMAP3430_MPU_DPLL_ST_SHIFT,
-	.autoidle_reg	= _OMAP34XX_CM_REGADDR(MPU_MOD, OMAP3430_CM_AUTOIDLE_PLL),
+	.autoidle_reg	= OMAP3430_CM_AUTOIDLE_PLL,
 	.autoidle_mask	= OMAP3430_AUTO_MPU_DPLL_MASK,
-	.idlest_reg	= _OMAP34XX_CM_REGADDR(MPU_MOD, OMAP3430_CM_IDLEST_PLL),
+	.idlest_reg	= OMAP3430_CM_IDLEST_PLL,
 	.idlest_mask	= OMAP3430_ST_MPU_CLK_MASK,
 	.bypass_clk	= &dpll1_fck,
 	.max_multiplier = OMAP3_MAX_DPLL_MULT,
@@ -348,7 +336,7 @@ static struct clk dpll1_x2m2_ck = {
 	.parent		= &dpll1_x2_ck,
 	.prcm_mod	= MPU_MOD,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= _OMAP34XX_CM_REGADDR(MPU_MOD, OMAP3430_CM_CLKSEL2_PLL),
+	.clksel_reg	= OMAP3430_CM_CLKSEL2_PLL,
 	.clksel_mask	= OMAP3430_MPU_DPLL_CLKOUT_DIV_MASK,
 	.clksel		= div16_dpll1_x2m2_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
@@ -362,20 +350,20 @@ static struct clk dpll1_x2m2_ck = {
 /* Type: DPLL */
 
 static struct dpll_data dpll2_dd = {
-	.mult_div1_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_IVA2_MOD, OMAP3430_CM_CLKSEL1_PLL),
+	.mult_div1_reg	= OMAP3430_CM_CLKSEL1_PLL,
 	.mult_mask	= OMAP3430_IVA2_DPLL_MULT_MASK,
 	.div1_mask	= OMAP3430_IVA2_DPLL_DIV_MASK,
 	.freqsel_mask	= OMAP3430_IVA2_DPLL_FREQSEL_MASK,
-	.control_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_IVA2_MOD, OMAP3430_CM_CLKEN_PLL),
+	.control_reg	= OMAP3430_CM_CLKEN_PLL,
 	.enable_mask	= OMAP3430_EN_IVA2_DPLL_MASK,
 	.modes		= (1 << DPLL_LOW_POWER_STOP) | (1 << DPLL_LOCKED) |
 				(1 << DPLL_LOW_POWER_BYPASS),
 	.auto_recal_bit	= OMAP3430_EN_IVA2_DPLL_DRIFTGUARD_SHIFT,
 	.recal_en_bit	= OMAP3430_PRM_IRQENABLE_MPU_IVA2_DPLL_RECAL_EN_SHIFT,
 	.recal_st_bit	= OMAP3430_PRM_IRQSTATUS_MPU_IVA2_DPLL_ST_SHIFT,
-	.autoidle_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_IVA2_MOD, OMAP3430_CM_AUTOIDLE_PLL),
+	.autoidle_reg	= OMAP3430_CM_AUTOIDLE_PLL,
 	.autoidle_mask	= OMAP3430_AUTO_IVA2_DPLL_MASK,
-	.idlest_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_IVA2_MOD, OMAP3430_CM_IDLEST_PLL),
+	.idlest_reg	= OMAP3430_CM_IDLEST_PLL,
 	.idlest_mask	= OMAP3430_ST_IVA2_CLK_MASK,
 	.bypass_clk	= &dpll2_fck,
 	.max_multiplier = OMAP3_MAX_DPLL_MULT,
@@ -412,8 +400,7 @@ static struct clk dpll2_m2_ck = {
 	.parent		= &dpll2_ck,
 	.prcm_mod	= OMAP3430_IVA2_MOD,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_IVA2_MOD,
-					  OMAP3430_CM_CLKSEL2_PLL),
+	.clksel_reg	= OMAP3430_CM_CLKSEL2_PLL,
 	.clksel_mask	= OMAP3430_IVA2_DPLL_CLKOUT_DIV_MASK,
 	.clksel		= div16_dpll2_m2x2_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
@@ -428,18 +415,18 @@ static struct clk dpll2_m2_ck = {
  * REVISIT: Also supports fast relock bypass - not included below
  */
 static struct dpll_data dpll3_dd = {
-	.mult_div1_reg	= _OMAP34XX_CM_REGADDR(PLL_MOD, CM_CLKSEL1),
+	.mult_div1_reg	= CM_CLKSEL1,
 	.mult_mask	= OMAP3430_CORE_DPLL_MULT_MASK,
 	.div1_mask	= OMAP3430_CORE_DPLL_DIV_MASK,
 	.freqsel_mask	= OMAP3430_CORE_DPLL_FREQSEL_MASK,
-	.control_reg	= _OMAP34XX_CM_REGADDR(PLL_MOD, CM_CLKEN),
+	.control_reg	= CM_CLKEN,
 	.enable_mask	= OMAP3430_EN_CORE_DPLL_MASK,
 	.auto_recal_bit	= OMAP3430_EN_CORE_DPLL_DRIFTGUARD_SHIFT,
 	.recal_en_bit	= OMAP3430_CORE_DPLL_RECAL_EN_SHIFT,
 	.recal_st_bit	= OMAP3430_CORE_DPLL_ST_SHIFT,
-	.autoidle_reg	= _OMAP34XX_CM_REGADDR(PLL_MOD, CM_AUTOIDLE),
+	.autoidle_reg	= CM_AUTOIDLE,
 	.autoidle_mask	= OMAP3430_AUTO_CORE_DPLL_MASK,
-	.idlest_reg	= _OMAP34XX_CM_REGADDR(PLL_MOD, CM_IDLEST),
+	.idlest_reg	= CM_IDLEST,
 	.idlest_mask	= OMAP3430_ST_CORE_CLK_MASK,
 	.bypass_clk	= &sys_ck,
 	.max_multiplier = OMAP3_MAX_DPLL_MULT,
@@ -522,7 +509,7 @@ static struct clk dpll3_m2_ck = {
 	.parent		= &dpll3_ck,
 	.prcm_mod	= PLL_MOD,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= _OMAP34XX_CM_REGADDR(PLL_MOD, CM_CLKSEL1),
+	.clksel_reg	= CM_CLKSEL1,
 	.clksel_mask	= OMAP3430_CORE_DPLL_CLKOUT_DIV_MASK,
 	.clksel		= div31_dpll3m2_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
@@ -561,7 +548,7 @@ static struct clk dpll3_m3_ck = {
 	.parent		= &dpll3_ck,
 	.prcm_mod	= OMAP3430_EMU_MOD,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_EMU_MOD, CM_CLKSEL1),
+	.clksel_reg	= CM_CLKSEL1,
 	.clksel_mask	= OMAP3430_DIV_DPLL3_MASK,
 	.clksel		= div16_dpll3_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
@@ -575,7 +562,7 @@ static struct clk dpll3_m3x2_ck = {
 	.name		= "dpll3_m3x2_ck",
 	.parent		= &dpll3_m3_ck,
 	.prcm_mod	= PLL_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(PLL_MOD, CM_CLKEN),
+	.enable_reg	= CM_CLKEN,
 	.enable_bit	= OMAP3430_PWRDN_EMU_CORE_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | INVERT_ENABLE,
 	.clkdm		= { .name = "dpll3_clkdm" },
@@ -595,19 +582,19 @@ static struct clk emu_core_alwon_ck = {
 /* Supplies 96MHz, 54Mhz TV DAC, DSS fclk, CAM sensor clock, emul trace clk */
 /* Type: DPLL */
 static struct dpll_data dpll4_dd = {
-	.mult_div1_reg	= _OMAP34XX_CM_REGADDR(PLL_MOD, CM_CLKSEL2),
+	.mult_div1_reg	= CM_CLKSEL2,
 	.mult_mask	= OMAP3430_PERIPH_DPLL_MULT_MASK,
 	.div1_mask	= OMAP3430_PERIPH_DPLL_DIV_MASK,
 	.freqsel_mask	= OMAP3430_PERIPH_DPLL_FREQSEL_MASK,
-	.control_reg	= _OMAP34XX_CM_REGADDR(PLL_MOD, CM_CLKEN),
+	.control_reg	= CM_CLKEN,
 	.enable_mask	= OMAP3430_EN_PERIPH_DPLL_MASK,
 	.modes		= (1 << DPLL_LOW_POWER_STOP) | (1 << DPLL_LOCKED),
 	.auto_recal_bit	= OMAP3430_EN_PERIPH_DPLL_DRIFTGUARD_SHIFT,
 	.recal_en_bit	= OMAP3430_PERIPH_DPLL_RECAL_EN_SHIFT,
 	.recal_st_bit	= OMAP3430_PERIPH_DPLL_ST_SHIFT,
-	.autoidle_reg	= _OMAP34XX_CM_REGADDR(PLL_MOD, CM_AUTOIDLE),
+	.autoidle_reg	= CM_AUTOIDLE,
 	.autoidle_mask	= OMAP3430_AUTO_PERIPH_DPLL_MASK,
-	.idlest_reg	= _OMAP34XX_CM_REGADDR(PLL_MOD, CM_IDLEST),
+	.idlest_reg	= CM_IDLEST,
 	.idlest_mask	= OMAP3430_ST_PERIPH_CLK_MASK,
 	.bypass_clk	= &sys_ck,
 	.max_multiplier = OMAP3_MAX_DPLL_MULT,
@@ -655,7 +642,7 @@ static struct clk dpll4_m2_ck = {
 	.parent		= &dpll4_ck,
 	.prcm_mod	= PLL_MOD,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= _OMAP34XX_CM_REGADDR(PLL_MOD, OMAP3430_CM_CLKSEL3),
+	.clksel_reg	= OMAP3430_CM_CLKSEL3,
 	.clksel_mask	= OMAP3430_DIV_96M_MASK,
 	.clksel		= div16_dpll4_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
@@ -669,7 +656,7 @@ static struct clk dpll4_m2x2_ck = {
 	.name		= "dpll4_m2x2_ck",
 	.parent		= &dpll4_m2_ck,
 	.prcm_mod	= PLL_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(PLL_MOD, CM_CLKEN),
+	.enable_reg	= CM_CLKEN,
 	.enable_bit	= OMAP3430_PWRDN_96M_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | INVERT_ENABLE,
 	.clkdm		= { .name = "dpll4_clkdm" },
@@ -721,7 +708,7 @@ static struct clk omap_96m_fck = {
 	.parent		= &sys_ck,
 	.prcm_mod	= PLL_MOD,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= _OMAP34XX_CM_REGADDR(PLL_MOD, CM_CLKSEL1),
+	.clksel_reg	= CM_CLKSEL1,
 	.clksel_mask	= OMAP3430_SOURCE_96M_MASK,
 	.clksel		= omap_96m_fck_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
@@ -736,7 +723,7 @@ static struct clk dpll4_m3_ck = {
 	.parent		= &dpll4_ck,
 	.prcm_mod	= OMAP3430_DSS_MOD,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_DSS_MOD, CM_CLKSEL),
+	.clksel_reg	= CM_CLKSEL,
 	.clksel_mask	= OMAP3430_CLKSEL_TV_MASK,
 	.clksel		= div16_dpll4_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
@@ -751,7 +738,7 @@ static struct clk dpll4_m3x2_ck = {
 	.parent		= &dpll4_m3_ck,
 	.prcm_mod	= PLL_MOD,
 	.init		= &omap2_init_clksel_parent,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(PLL_MOD, CM_CLKEN),
+	.enable_reg	= CM_CLKEN,
 	.enable_bit	= OMAP3430_PWRDN_TV_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | INVERT_ENABLE,
 	.clkdm		= { .name = "dpll4_clkdm" },
@@ -778,7 +765,7 @@ static struct clk omap_54m_fck = {
 	.name		= "omap_54m_fck",
 	.prcm_mod	= PLL_MOD,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= _OMAP34XX_CM_REGADDR(PLL_MOD, CM_CLKSEL1),
+	.clksel_reg	= CM_CLKSEL1,
 	.clksel_mask	= OMAP3430_SOURCE_54M_MASK,
 	.clksel		= omap_54m_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
@@ -807,7 +794,7 @@ static struct clk omap_48m_fck = {
 	.name		= "omap_48m_fck",
 	.prcm_mod	= PLL_MOD,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= _OMAP34XX_CM_REGADDR(PLL_MOD, CM_CLKSEL1),
+	.clksel_reg	= CM_CLKSEL1,
 	.clksel_mask	= OMAP3430_SOURCE_48M_MASK,
 	.clksel		= omap_48m_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
@@ -832,7 +819,7 @@ static struct clk dpll4_m4_ck = {
 	.parent		= &dpll4_ck,
 	.prcm_mod	= OMAP3430_DSS_MOD,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_DSS_MOD, CM_CLKSEL),
+	.clksel_reg	= CM_CLKSEL,
 	.clksel_mask	= OMAP3430_CLKSEL_DSS1_MASK,
 	.clksel		= div16_dpll4_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
@@ -848,8 +835,8 @@ static struct clk dpll4_m4x2_ck = {
 	.name		= "dpll4_m4x2_ck",
 	.parent		= &dpll4_m4_ck,
 	.prcm_mod	= PLL_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(PLL_MOD, CM_CLKEN),
-	.enable_bit	= OMAP3430_PWRDN_CAM_SHIFT,
+	.enable_reg	= CM_CLKEN,
+	.enable_bit	= OMAP3430_PWRDN_DSS1_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | INVERT_ENABLE,
 	.clkdm		= { .name = "dpll4_clkdm" },
 	.recalc		= &omap3_clkoutx2_recalc,
@@ -861,7 +848,7 @@ static struct clk dpll4_m5_ck = {
 	.parent		= &dpll4_ck,
 	.prcm_mod	= OMAP3430_CAM_MOD,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_CAM_MOD, CM_CLKSEL),
+	.clksel_reg	= CM_CLKSEL,
 	.clksel_mask	= OMAP3430_CLKSEL_CAM_MASK,
 	.clksel		= div16_dpll4_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
@@ -875,7 +862,7 @@ static struct clk dpll4_m5x2_ck = {
 	.name		= "dpll4_m5x2_ck",
 	.parent		= &dpll4_m5_ck,
 	.prcm_mod	= PLL_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(PLL_MOD, CM_CLKEN),
+	.enable_reg	= CM_CLKEN,
 	.enable_bit	= OMAP3430_PWRDN_CAM_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | INVERT_ENABLE,
 	.clkdm		= { .name = "dpll4_clkdm" },
@@ -888,7 +875,7 @@ static struct clk dpll4_m6_ck = {
 	.parent		= &dpll4_ck,
 	.prcm_mod	= OMAP3430_EMU_MOD,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_EMU_MOD, CM_CLKSEL1),
+	.clksel_reg	= CM_CLKSEL1,
 	.clksel_mask	= OMAP3430_DIV_DPLL4_MASK,
 	.clksel		= div16_dpll4_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
@@ -903,7 +890,7 @@ static struct clk dpll4_m6x2_ck = {
 	.parent		= &dpll4_m6_ck,
 	.prcm_mod	= PLL_MOD,
 	.init		= &omap2_init_clksel_parent,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(PLL_MOD, CM_CLKEN),
+	.enable_reg	= CM_CLKEN,
 	.enable_bit	= OMAP3430_PWRDN_EMU_PERIPH_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | INVERT_ENABLE,
 	.clkdm		= { .name = "dpll4_clkdm" },
@@ -924,19 +911,19 @@ static struct clk emu_per_alwon_ck = {
 /* Type: DPLL */
 /* 3430ES2 only */
 static struct dpll_data dpll5_dd = {
-	.mult_div1_reg	= _OMAP34XX_CM_REGADDR(PLL_MOD, OMAP3430ES2_CM_CLKSEL4),
+	.mult_div1_reg	= OMAP3430ES2_CM_CLKSEL4,
 	.mult_mask	= OMAP3430ES2_PERIPH2_DPLL_MULT_MASK,
 	.div1_mask	= OMAP3430ES2_PERIPH2_DPLL_DIV_MASK,
 	.freqsel_mask	= OMAP3430ES2_PERIPH2_DPLL_FREQSEL_MASK,
-	.control_reg	= _OMAP34XX_CM_REGADDR(PLL_MOD, OMAP3430ES2_CM_CLKEN2),
+	.control_reg	= OMAP3430ES2_CM_CLKEN2,
 	.enable_mask	= OMAP3430ES2_EN_PERIPH2_DPLL_MASK,
 	.modes		= (1 << DPLL_LOW_POWER_STOP) | (1 << DPLL_LOCKED),
 	.auto_recal_bit	= OMAP3430ES2_EN_PERIPH2_DPLL_DRIFTGUARD_SHIFT,
 	.recal_en_bit	= OMAP3430ES2_SND_PERIPH_DPLL_RECAL_EN_SHIFT,
 	.recal_st_bit	= OMAP3430ES2_SND_PERIPH_DPLL_ST_SHIFT,
-	.autoidle_reg	= _OMAP34XX_CM_REGADDR(PLL_MOD, OMAP3430ES2_CM_AUTOIDLE2_PLL),
+	.autoidle_reg	= OMAP3430ES2_CM_AUTOIDLE2_PLL,
 	.autoidle_mask	= OMAP3430ES2_AUTO_PERIPH2_DPLL_MASK,
-	.idlest_reg	= _OMAP34XX_CM_REGADDR(PLL_MOD, CM_IDLEST2),
+	.idlest_reg	= CM_IDLEST2,
 	.idlest_mask	= OMAP3430ES2_ST_PERIPH2_CLK_MASK,
 	.bypass_clk	= &sys_ck,
 	.max_multiplier = OMAP3_MAX_DPLL_MULT,
@@ -969,7 +956,7 @@ static struct clk dpll5_m2_ck = {
 	.parent		= &dpll5_ck,
 	.prcm_mod	= PLL_MOD,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= _OMAP34XX_CM_REGADDR(PLL_MOD, OMAP3430ES2_CM_CLKSEL5),
+	.clksel_reg	= OMAP3430ES2_CM_CLKSEL5,
 	.clksel_mask	= OMAP3430ES2_DIV_120M_MASK,
 	.clksel		= div16_dpll5_clksel,
 	.flags		= CLOCK_IN_OMAP3430ES2 | RATE_PROPAGATES |
@@ -1012,9 +999,9 @@ static struct clk clkout2_src_ck = {
 	.name		= "clkout2_src_ck",
 	.prcm_mod	= OMAP3430_CCR_MOD,
 	.init		= &omap2_init_clksel_parent,
-	.enable_reg	= (__force void __iomem *)OMAP3430_CM_CLKOUT_CTRL,
+	.enable_reg	= OMAP3430_CM_CLKOUT_CTRL_OFFSET,
 	.enable_bit	= OMAP3430_CLKOUT2_EN_SHIFT,
-	.clksel_reg	= (__force void __iomem *)OMAP3430_CM_CLKOUT_CTRL,
+	.clksel_reg	= OMAP3430_CM_CLKOUT_CTRL_OFFSET,
 	.clksel_mask	= OMAP3430_CLKOUT2SOURCE_MASK,
 	.clksel		= clkout2_src_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES,
@@ -1040,7 +1027,7 @@ static struct clk sys_clkout2 = {
 	.name		= "sys_clkout2",
 	.prcm_mod	= OMAP3430_CCR_MOD,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= (__force void __iomem *)OMAP3430_CM_CLKOUT_CTRL,
+	.clksel_reg	= OMAP3430_CM_CLKOUT_CTRL_OFFSET,
 	.clksel_mask	= OMAP3430_CLKOUT2_DIV_MASK,
 	.clksel		= sys_clkout2_clksel,
 	.flags		= CLOCK_IN_OMAP343X | PARENT_CONTROLS_CLOCK,
@@ -1078,7 +1065,7 @@ static struct clk dpll1_fck = {
 	.parent		= &core_ck,
 	.prcm_mod	= MPU_MOD,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= _OMAP34XX_CM_REGADDR(MPU_MOD, OMAP3430_CM_CLKSEL1_PLL),
+	.clksel_reg	= OMAP3430_CM_CLKSEL1_PLL,
 	.clksel_mask	= OMAP3430_MPU_CLK_SRC_MASK,
 	.clksel		= div4_core_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
@@ -1113,7 +1100,7 @@ static struct clk arm_fck = {
 	.parent		= &mpu_ck,
 	.prcm_mod	= MPU_MOD,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= _OMAP34XX_CM_REGADDR(MPU_MOD, OMAP3430_CM_IDLEST_PLL),
+	.clksel_reg	= OMAP3430_CM_IDLEST_PLL,
 	.clksel_mask	= OMAP3430_ST_MPU_CLK_MASK,
 	.clksel		= arm_fck_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
@@ -1142,7 +1129,7 @@ static struct clk dpll2_fck = {
 	.parent		= &core_ck,
 	.prcm_mod	= OMAP3430_IVA2_MOD,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_IVA2_MOD, OMAP3430_CM_CLKSEL1_PLL),
+	.clksel_reg	= OMAP3430_CM_CLKSEL1_PLL,
 	.clksel_mask	= OMAP3430_IVA2_CLK_SRC_MASK,
 	.clksel		= div4_core_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
@@ -1156,7 +1143,7 @@ static struct clk iva2_ck = {
 	.parent		= &dpll2_m2_ck,
 	.prcm_mod	= OMAP3430_IVA2_MOD,
 	.init		= &omap2_init_clksel_parent,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_IVA2_MOD, CM_FCLKEN),
+	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP3430_CM_FCLKEN_IVA2_EN_IVA2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES,
 	.clkdm		= { .name = "iva2_clkdm" },
@@ -1175,7 +1162,7 @@ static struct clk l3_ick = {
 	.parent		= &core_ck,
 	.prcm_mod	= CORE_MOD,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_CLKSEL),
+	.clksel_reg	= CM_CLKSEL,
 	.clksel_mask	= OMAP3430_CLKSEL_L3_MASK,
 	.clksel		= div2_core_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
@@ -1194,7 +1181,7 @@ static struct clk l4_ick = {
 	.parent		= &l3_ick,
 	.prcm_mod	= CORE_MOD,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_CLKSEL),
+	.clksel_reg	= CM_CLKSEL,
 	.clksel_mask	= OMAP3430_CLKSEL_L4_MASK,
 	.clksel		= div2_l3_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
@@ -1214,7 +1201,7 @@ static struct clk rm_ick = {
 	.parent		= &l4_ick,
 	.prcm_mod	= WKUP_MOD,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= _OMAP34XX_CM_REGADDR(WKUP_MOD, CM_CLKSEL),
+	.clksel_reg	= CM_CLKSEL,
 	.clksel_mask	= OMAP3430_CLKSEL_RM_MASK,
 	.clksel		= div2_l4_clksel,
 	.flags		= CLOCK_IN_OMAP343X | PARENT_CONTROLS_CLOCK,
@@ -1237,7 +1224,7 @@ static struct clk gfx_l3_ck = {
 	.parent		= &l3_ick,
 	.prcm_mod	= GFX_MOD,
 	.init		= &omap2_init_clksel_parent,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(GFX_MOD, CM_ICLKEN),
+	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP_EN_GFX_SHIFT,
 	.flags		= CLOCK_IN_OMAP3430ES1,
 	.clkdm		= { .name = "gfx_3430es1_clkdm" },
@@ -1249,7 +1236,7 @@ static struct clk gfx_l3_fck = {
 	.parent		= &gfx_l3_ck,
 	.prcm_mod	= GFX_MOD,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= _OMAP34XX_CM_REGADDR(GFX_MOD, CM_CLKSEL),
+	.clksel_reg	= CM_CLKSEL,
 	.clksel_mask	= OMAP_CLKSEL_GFX_MASK,
 	.clksel		= gfx_l3_clksel,
 	.flags		= CLOCK_IN_OMAP3430ES1 | RATE_PROPAGATES |
@@ -1270,7 +1257,7 @@ static struct clk gfx_cg1_ck = {
 	.name		= "gfx_cg1_ck",
 	.parent		= &gfx_l3_fck, /* REVISIT: correct? */
 	.prcm_mod	= GFX_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(GFX_MOD, CM_FCLKEN),
+	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP3430ES1_EN_2D_SHIFT,
 	.flags		= CLOCK_IN_OMAP3430ES1,
 	.clkdm		= { .name = "gfx_3430es1_clkdm" },
@@ -1281,7 +1268,7 @@ static struct clk gfx_cg2_ck = {
 	.name		= "gfx_cg2_ck",
 	.parent		= &gfx_l3_fck, /* REVISIT: correct? */
 	.prcm_mod	= GFX_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(GFX_MOD, CM_FCLKEN),
+	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP3430ES1_EN_3D_SHIFT,
 	.flags		= CLOCK_IN_OMAP3430ES1,
 	.clkdm		= { .name = "gfx_3430es1_clkdm" },
@@ -1312,9 +1299,9 @@ static struct clk sgx_fck = {
 	.name		= "sgx_fck",
 	.init		= &omap2_init_clksel_parent,
 	.prcm_mod	= OMAP3430ES2_SGX_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430ES2_SGX_MOD, CM_FCLKEN),
+	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP3430ES2_CM_FCLKEN_SGX_EN_SGX_SHIFT,
-	.clksel_reg	= _OMAP34XX_CM_REGADDR(OMAP3430ES2_SGX_MOD, CM_CLKSEL),
+	.clksel_reg	= CM_CLKSEL,
 	.clksel_mask	= OMAP3430ES2_CLKSEL_SGX_MASK,
 	.clksel		= sgx_clksel,
 	.flags		= CLOCK_IN_OMAP3430ES2,
@@ -1326,7 +1313,7 @@ static struct clk sgx_ick = {
 	.name		= "sgx_ick",
 	.parent		= &l3_ick,
 	.prcm_mod	= OMAP3430ES2_SGX_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430ES2_SGX_MOD, CM_ICLKEN),
+	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP3430ES2_CM_ICLKEN_SGX_EN_SGX_SHIFT,
 	.flags		= CLOCK_IN_OMAP3430ES2,
 	.clkdm		= { .name = "sgx_clkdm" },
@@ -1339,7 +1326,7 @@ static struct clk d2d_26m_fck = {
 	.name		= "d2d_26m_fck",
 	.parent		= &sys_ck,
 	.prcm_mod	= CORE_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP3430ES1_EN_D2D_SHIFT,
 	.flags		= CLOCK_IN_OMAP3430ES1,
 	.clkdm		= { .name = "d2d_clkdm" },
@@ -1357,9 +1344,9 @@ static struct clk gpt10_fck = {
 	.parent		= &sys_ck,
 	.prcm_mod	= CORE_MOD,
 	.init		= &omap2_init_clksel_parent,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP3430_EN_GPT10_SHIFT,
-	.clksel_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_CLKSEL),
+	.clksel_reg	= CM_CLKSEL,
 	.clksel_mask	= OMAP3430_CLKSEL_GPT10_MASK,
 	.clksel		= omap343x_gpt_clksel,
 	.flags		= CLOCK_IN_OMAP343X,
@@ -1372,9 +1359,9 @@ static struct clk gpt11_fck = {
 	.parent		= &sys_ck,
 	.prcm_mod	= CORE_MOD,
 	.init		= &omap2_init_clksel_parent,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP3430_EN_GPT11_SHIFT,
-	.clksel_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_CLKSEL),
+	.clksel_reg	= CM_CLKSEL,
 	.clksel_mask	= OMAP3430_CLKSEL_GPT11_MASK,
 	.clksel		= omap343x_gpt_clksel,
 	.flags		= CLOCK_IN_OMAP343X,
@@ -1386,7 +1373,7 @@ static struct clk cpefuse_fck = {
 	.name		= "cpefuse_fck",
 	.parent		= &sys_ck,
 	.prcm_mod	= CORE_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, OMAP3430ES2_CM_FCLKEN3),
+	.enable_reg	= OMAP3430ES2_CM_FCLKEN3,
 	.enable_bit	= OMAP3430ES2_EN_CPEFUSE_SHIFT,
 	.flags		= CLOCK_IN_OMAP3430ES2,
 	.clkdm		= { .name = "cm_clkdm" },
@@ -1397,7 +1384,7 @@ static struct clk ts_fck = {
 	.name		= "ts_fck",
 	.parent		= &omap_32k_fck,
 	.prcm_mod	= CORE_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, OMAP3430ES2_CM_FCLKEN3),
+	.enable_reg	= OMAP3430ES2_CM_FCLKEN3,
 	.enable_bit	= OMAP3430ES2_EN_TS_SHIFT,
 	.flags		= CLOCK_IN_OMAP3430ES2,
 	.clkdm		= { .name = "core_l4_clkdm" },
@@ -1408,7 +1395,7 @@ static struct clk usbtll_fck = {
 	.name		= "usbtll_fck",
 	.parent		= &dpll5_m2_ck,
 	.prcm_mod	= CORE_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, OMAP3430ES2_CM_FCLKEN3),
+	.enable_reg	= OMAP3430ES2_CM_FCLKEN3,
 	.enable_bit	= OMAP3430ES2_EN_USBTLL_SHIFT,
 	.flags		= CLOCK_IN_OMAP3430ES2,
 	.clkdm		= { .name = "core_l4_clkdm" },
@@ -1431,7 +1418,7 @@ static struct clk mmchs3_fck = {
 	.id		= 2,
 	.parent		= &core_96m_fck,
 	.prcm_mod	= CORE_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP3430ES2_EN_MMC3_SHIFT,
 	.flags		= CLOCK_IN_OMAP3430ES2,
 	.clkdm		= { .name = "core_l4_clkdm" },
@@ -1443,7 +1430,7 @@ static struct clk mmchs2_fck = {
 	.id		= 1,
 	.parent		= &core_96m_fck,
 	.prcm_mod	= CORE_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP3430_EN_MMC2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "core_l4_clkdm" },
@@ -1454,7 +1441,7 @@ static struct clk mspro_fck = {
 	.name		= "mspro_fck",
 	.parent		= &core_96m_fck,
 	.prcm_mod	= CORE_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP3430_EN_MSPRO_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "core_l4_clkdm" },
@@ -1465,7 +1452,7 @@ static struct clk mmchs1_fck = {
 	.name		= "mmchs_fck",
 	.parent		= &core_96m_fck,
 	.prcm_mod	= CORE_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP3430_EN_MMC1_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "core_l4_clkdm" },
@@ -1477,7 +1464,7 @@ static struct clk i2c3_fck = {
 	.id		= 3,
 	.parent		= &core_96m_fck,
 	.prcm_mod	= CORE_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP3430_EN_I2C3_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "core_l4_clkdm" },
@@ -1489,7 +1476,7 @@ static struct clk i2c2_fck = {
 	.id		= 2,
 	.parent		= &core_96m_fck,
 	.prcm_mod	= CORE_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP3430_EN_I2C2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "core_l4_clkdm" },
@@ -1501,7 +1488,7 @@ static struct clk i2c1_fck = {
 	.id		= 1,
 	.parent		= &core_96m_fck,
 	.prcm_mod	= CORE_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP3430_EN_I2C1_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "core_l4_clkdm" },
@@ -1533,7 +1520,7 @@ static struct clk mcbsp5_src_fck = {
 	.id		= 5,
 	.prcm_mod	= CLK_REG_IN_SCM,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= OMAP343X_CTRL_REGADDR(OMAP343X_CONTROL_DEVCONF1),
+	.clksel_reg	= OMAP343X_CONTROL_DEVCONF1,
 	.clksel_mask	= OMAP2_MCBSP5_CLKS_MASK,
 	.clksel		= mcbsp_15_clksel,
 	.flags		= CLOCK_IN_OMAP343X,
@@ -1546,7 +1533,7 @@ static struct clk mcbsp5_fck = {
 	.id		= 5,
 	.parent		= &mcbsp5_src_fck,
 	.prcm_mod	= CORE_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP3430_EN_MCBSP5_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "core_l4_clkdm" },
@@ -1558,7 +1545,7 @@ static struct clk mcbsp1_src_fck = {
 	.id		= 1,
 	.prcm_mod	= CLK_REG_IN_SCM,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= OMAP343X_CTRL_REGADDR(OMAP2_CONTROL_DEVCONF0),
+	.clksel_reg	= OMAP2_CONTROL_DEVCONF0,
 	.clksel_mask	= OMAP2_MCBSP1_CLKS_MASK,
 	.clksel		= mcbsp_15_clksel,
 	.flags		= CLOCK_IN_OMAP343X,
@@ -1571,7 +1558,7 @@ static struct clk mcbsp1_fck = {
 	.id		= 1,
 	.parent		= &mcbsp1_src_fck,
 	.prcm_mod	= CORE_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP3430_EN_MCBSP1_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "core_l4_clkdm" },
@@ -1594,7 +1581,7 @@ static struct clk mcspi4_fck = {
 	.id		= 4,
 	.parent		= &core_48m_fck,
 	.prcm_mod	= CORE_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP3430_EN_MCSPI4_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "core_l4_clkdm" },
@@ -1606,7 +1593,7 @@ static struct clk mcspi3_fck = {
 	.id		= 3,
 	.parent		= &core_48m_fck,
 	.prcm_mod	= CORE_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP3430_EN_MCSPI3_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "core_l4_clkdm" },
@@ -1618,7 +1605,7 @@ static struct clk mcspi2_fck = {
 	.id		= 2,
 	.parent		= &core_48m_fck,
 	.prcm_mod	= CORE_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP3430_EN_MCSPI2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "core_l4_clkdm" },
@@ -1630,7 +1617,7 @@ static struct clk mcspi1_fck = {
 	.id		= 1,
 	.parent		= &core_48m_fck,
 	.prcm_mod	= CORE_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP3430_EN_MCSPI1_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "core_l4_clkdm" },
@@ -1641,7 +1628,7 @@ static struct clk uart2_fck = {
 	.name		= "uart2_fck",
 	.parent		= &core_48m_fck,
 	.prcm_mod	= CORE_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP3430_EN_UART2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "core_l4_clkdm" },
@@ -1652,7 +1639,7 @@ static struct clk uart1_fck = {
 	.name		= "uart1_fck",
 	.parent		= &core_48m_fck,
 	.prcm_mod	= CORE_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP3430_EN_UART1_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "core_l4_clkdm" },
@@ -1663,7 +1650,7 @@ static struct clk fshostusb_fck = {
 	.name		= "fshostusb_fck",
 	.parent		= &core_48m_fck,
 	.prcm_mod	= CORE_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP3430ES1_EN_FSHOSTUSB_SHIFT,
 	.flags		= CLOCK_IN_OMAP3430ES1,
 	.clkdm		= { .name = "core_l4_clkdm" },
@@ -1685,7 +1672,7 @@ static struct clk hdq_fck = {
 	.name		= "hdq_fck",
 	.parent		= &core_12m_fck,
 	.prcm_mod	= CORE_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP3430_EN_HDQ_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "core_l4_clkdm" },
@@ -1713,9 +1700,9 @@ static struct clk ssi_ssr_fck = {
 	.name		= "ssi_ssr_fck",
 	.init		= &omap2_init_clksel_parent,
 	.prcm_mod	= CORE_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP3430_EN_SSI_SHIFT,
-	.clksel_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_CLKSEL),
+	.clksel_reg	= CM_CLKSEL,
 	.clksel_mask	= OMAP3430_CLKSEL_SSI_MASK,
 	.clksel		= ssi_ssr_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES,
@@ -1753,7 +1740,7 @@ static struct clk hsotgusb_ick = {
 	.name		= "hsotgusb_ick",
 	.parent		= &core_l3_ick,
 	.prcm_mod	= CORE_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP3430_EN_HSOTGUSB_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "core_l3_clkdm" },
@@ -1764,7 +1751,7 @@ static struct clk sdrc_ick = {
 	.name		= "sdrc_ick",
 	.parent		= &core_l3_ick,
 	.prcm_mod	= CORE_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP3430_EN_SDRC_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X | ENABLE_ON_INIT,
 	.clkdm		= { .name = "core_l3_clkdm" },
@@ -1795,7 +1782,7 @@ static struct clk pka_ick = {
 	.name		= "pka_ick",
 	.parent		= &security_l3_ick,
 	.prcm_mod	= CORE_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN2),
+	.enable_reg	= CM_ICLKEN2,
 	.enable_bit	= OMAP3430_EN_PKA_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "core_l3_clkdm" },
@@ -1817,7 +1804,7 @@ static struct clk usbtll_ick = {
 	.name		= "usbtll_ick",
 	.parent		= &core_l4_ick,
 	.prcm_mod	= CORE_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN3),
+	.enable_reg	= CM_ICLKEN3,
 	.enable_bit	= OMAP3430ES2_EN_USBTLL_SHIFT,
 	.flags		= CLOCK_IN_OMAP3430ES2,
 	.clkdm		= { .name = "core_l4_clkdm" },
@@ -1829,7 +1816,7 @@ static struct clk mmchs3_ick = {
 	.id		= 2,
 	.parent		= &core_l4_ick,
 	.prcm_mod	= CORE_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP3430ES2_EN_MMC3_SHIFT,
 	.flags		= CLOCK_IN_OMAP3430ES2,
 	.clkdm		= { .name = "core_l4_clkdm" },
@@ -1841,7 +1828,7 @@ static struct clk icr_ick = {
 	.name		= "icr_ick",
 	.parent		= &core_l4_ick,
 	.prcm_mod	= CORE_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP3430_EN_ICR_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "core_l4_clkdm" },
@@ -1852,7 +1839,7 @@ static struct clk aes2_ick = {
 	.name		= "aes2_ick",
 	.parent		= &core_l4_ick,
 	.prcm_mod	= CORE_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP3430_EN_AES2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "core_l4_clkdm" },
@@ -1863,7 +1850,7 @@ static struct clk sha12_ick = {
 	.name		= "sha12_ick",
 	.parent		= &core_l4_ick,
 	.prcm_mod	= CORE_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP3430_EN_SHA12_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "core_l4_clkdm" },
@@ -1874,7 +1861,7 @@ static struct clk des2_ick = {
 	.name		= "des2_ick",
 	.parent		= &core_l4_ick,
 	.prcm_mod	= CORE_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP3430_EN_DES2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "core_l4_clkdm" },
@@ -1886,7 +1873,7 @@ static struct clk mmchs2_ick = {
 	.id		= 1,
 	.parent		= &core_l4_ick,
 	.prcm_mod	= CORE_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP3430_EN_MMC2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "core_l4_clkdm" },
@@ -1897,7 +1884,7 @@ static struct clk mmchs1_ick = {
 	.name		= "mmchs_ick",
 	.parent		= &core_l4_ick,
 	.prcm_mod	= CORE_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP3430_EN_MMC1_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "core_l4_clkdm" },
@@ -1908,7 +1895,7 @@ static struct clk mspro_ick = {
 	.name		= "mspro_ick",
 	.parent		= &core_l4_ick,
 	.prcm_mod	= CORE_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP3430_EN_MSPRO_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "core_l4_clkdm" },
@@ -1919,7 +1906,7 @@ static struct clk hdq_ick = {
 	.name		= "hdq_ick",
 	.parent		= &core_l4_ick,
 	.prcm_mod	= CORE_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP3430_EN_HDQ_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "core_l4_clkdm" },
@@ -1931,7 +1918,7 @@ static struct clk mcspi4_ick = {
 	.id		= 4,
 	.parent		= &core_l4_ick,
 	.prcm_mod	= CORE_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP3430_EN_MCSPI4_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "core_l4_clkdm" },
@@ -1943,7 +1930,7 @@ static struct clk mcspi3_ick = {
 	.id		= 3,
 	.parent		= &core_l4_ick,
 	.prcm_mod	= CORE_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP3430_EN_MCSPI3_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "core_l4_clkdm" },
@@ -1955,7 +1942,7 @@ static struct clk mcspi2_ick = {
 	.id		= 2,
 	.parent		= &core_l4_ick,
 	.prcm_mod	= CORE_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP3430_EN_MCSPI2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "core_l4_clkdm" },
@@ -1967,7 +1954,7 @@ static struct clk mcspi1_ick = {
 	.id		= 1,
 	.parent		= &core_l4_ick,
 	.prcm_mod	= CORE_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP3430_EN_MCSPI1_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "core_l4_clkdm" },
@@ -1979,7 +1966,7 @@ static struct clk i2c3_ick = {
 	.id		= 3,
 	.parent		= &core_l4_ick,
 	.prcm_mod	= CORE_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP3430_EN_I2C3_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "core_l4_clkdm" },
@@ -1991,7 +1978,7 @@ static struct clk i2c2_ick = {
 	.id		= 2,
 	.parent		= &core_l4_ick,
 	.prcm_mod	= CORE_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP3430_EN_I2C2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "core_l4_clkdm" },
@@ -2003,7 +1990,7 @@ static struct clk i2c1_ick = {
 	.id		= 1,
 	.parent		= &core_l4_ick,
 	.prcm_mod	= CORE_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP3430_EN_I2C1_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "core_l4_clkdm" },
@@ -2014,7 +2001,7 @@ static struct clk uart2_ick = {
 	.name		= "uart2_ick",
 	.parent		= &core_l4_ick,
 	.prcm_mod	= CORE_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP3430_EN_UART2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "core_l4_clkdm" },
@@ -2025,7 +2012,7 @@ static struct clk uart1_ick = {
 	.name		= "uart1_ick",
 	.parent		= &core_l4_ick,
 	.prcm_mod	= CORE_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP3430_EN_UART1_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "core_l4_clkdm" },
@@ -2036,7 +2023,7 @@ static struct clk gpt11_ick = {
 	.name		= "gpt11_ick",
 	.parent		= &core_l4_ick,
 	.prcm_mod	= CORE_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP3430_EN_GPT11_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "core_l4_clkdm" },
@@ -2047,7 +2034,7 @@ static struct clk gpt10_ick = {
 	.name		= "gpt10_ick",
 	.parent		= &core_l4_ick,
 	.prcm_mod	= CORE_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP3430_EN_GPT10_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "core_l4_clkdm" },
@@ -2059,7 +2046,7 @@ static struct clk mcbsp5_ick = {
 	.id		= 5,
 	.parent		= &core_l4_ick,
 	.prcm_mod	= CORE_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP3430_EN_MCBSP5_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "core_l4_clkdm" },
@@ -2071,7 +2058,7 @@ static struct clk mcbsp1_ick = {
 	.id		= 1,
 	.parent		= &core_l4_ick,
 	.prcm_mod	= CORE_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP3430_EN_MCBSP1_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "core_l4_clkdm" },
@@ -2082,7 +2069,7 @@ static struct clk fac_ick = {
 	.name		= "fac_ick",
 	.parent		= &core_l4_ick,
 	.prcm_mod	= CORE_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP3430ES1_EN_FAC_SHIFT,
 	.flags		= CLOCK_IN_OMAP3430ES1,
 	.clkdm		= { .name = "core_l4_clkdm" },
@@ -2093,7 +2080,7 @@ static struct clk mailboxes_ick = {
 	.name		= "mailboxes_ick",
 	.parent		= &core_l4_ick,
 	.prcm_mod	= CORE_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP3430_EN_MAILBOXES_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "core_l4_clkdm" },
@@ -2104,7 +2091,7 @@ static struct clk omapctrl_ick = {
 	.name		= "omapctrl_ick",
 	.parent		= &core_l4_ick,
 	.prcm_mod	= CORE_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP3430_EN_OMAPCTRL_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X | ENABLE_ON_INIT,
 	.clkdm		= { .name = "core_l4_clkdm" },
@@ -2126,7 +2113,7 @@ static struct clk ssi_ick = {
 	.name		= "ssi_ick",
 	.parent		= &ssi_l4_ick,
 	.prcm_mod	= CORE_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP3430_EN_SSI_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "core_l4_clkdm" },
@@ -2146,9 +2133,9 @@ static struct clk usb_l4_ick = {
 	.parent		= &l4_ick,
 	.prcm_mod	= CORE_MOD,
 	.init		= &omap2_init_clksel_parent,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
+	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP3430ES1_EN_FSHOSTUSB_SHIFT,
-	.clksel_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_CLKSEL),
+	.clksel_reg	= CM_CLKSEL,
 	.clksel_mask	= OMAP3430ES1_CLKSEL_FSHOSTUSB_MASK,
 	.clksel		= usb_l4_clksel,
 	.flags		= CLOCK_IN_OMAP3430ES1,
@@ -2173,7 +2160,7 @@ static struct clk aes1_ick = {
 	.name		= "aes1_ick",
 	.parent		= &security_l4_ick2,
 	.prcm_mod	= CORE_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN2),
+	.enable_reg	= CM_ICLKEN2,
 	.enable_bit	= OMAP3430_EN_AES1_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "core_l4_clkdm" },
@@ -2184,7 +2171,7 @@ static struct clk rng_ick = {
 	.name		= "rng_ick",
 	.parent		= &security_l4_ick2,
 	.prcm_mod	= CORE_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN2),
+	.enable_reg	= CM_ICLKEN2,
 	.enable_bit	= OMAP3430_EN_RNG_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "core_l4_clkdm" },
@@ -2195,7 +2182,7 @@ static struct clk sha11_ick = {
 	.name		= "sha11_ick",
 	.parent		= &security_l4_ick2,
 	.prcm_mod	= CORE_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN2),
+	.enable_reg	= CM_ICLKEN2,
 	.enable_bit	= OMAP3430_EN_SHA11_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "core_l4_clkdm" },
@@ -2206,7 +2193,7 @@ static struct clk des1_ick = {
 	.name		= "des1_ick",
 	.parent		= &security_l4_ick2,
 	.prcm_mod	= CORE_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN2),
+	.enable_reg	= CM_ICLKEN2,
 	.enable_bit	= OMAP3430_EN_DES1_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "core_l4_clkdm" },
@@ -2218,7 +2205,7 @@ static struct clk dss1_alwon_fck = {
 	.name		= "dss1_alwon_fck",
 	.parent		= &dpll4_m4x2_ck,
 	.prcm_mod	= OMAP3430_DSS_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_DSS_MOD, CM_FCLKEN),
+	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP3430_EN_DSS1_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "dss_clkdm" },
@@ -2229,7 +2216,7 @@ static struct clk dss_tv_fck = {
 	.name		= "dss_tv_fck",
 	.parent		= &omap_54m_fck,
 	.prcm_mod	= OMAP3430_DSS_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_DSS_MOD, CM_FCLKEN),
+	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP3430_EN_TV_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "dss_clkdm" }, /* XXX: in cm_clkdm? */
@@ -2240,7 +2227,7 @@ static struct clk dss_96m_fck = {
 	.name		= "dss_96m_fck",
 	.parent		= &omap_96m_fck,
 	.prcm_mod	= OMAP3430_DSS_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_DSS_MOD, CM_FCLKEN),
+	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP3430_EN_TV_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "dss_clkdm" },
@@ -2251,7 +2238,7 @@ static struct clk dss2_alwon_fck = {
 	.name		= "dss2_alwon_fck",
 	.parent		= &sys_ck,
 	.prcm_mod	= OMAP3430_DSS_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_DSS_MOD, CM_FCLKEN),
+	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP3430_EN_DSS2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "dss_clkdm" },
@@ -2263,7 +2250,7 @@ static struct clk dss_ick = {
 	.name		= "dss_ick",
 	.parent		= &l4_ick,
 	.prcm_mod	= OMAP3430_DSS_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_DSS_MOD, CM_ICLKEN),
+	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP3430_CM_ICLKEN_DSS_EN_DSS_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "dss_clkdm" },
@@ -2276,7 +2263,7 @@ static struct clk cam_mclk = {
 	.name		= "cam_mclk",
 	.parent		= &dpll4_m5x2_ck,
 	.prcm_mod	= OMAP3430_CAM_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_CAM_MOD, CM_FCLKEN),
+	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP3430_EN_CAM_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "cam_clkdm" },
@@ -2288,7 +2275,7 @@ static struct clk cam_ick = {
 	.name		= "cam_ick",
 	.parent		= &l4_ick,
 	.prcm_mod	= OMAP3430_CAM_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_CAM_MOD, CM_ICLKEN),
+	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP3430_EN_CAM_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "cam_clkdm" },
@@ -2299,7 +2286,7 @@ static struct clk csi2_96m_fck = {
 	.name		= "csi2_96m_fck",
 	.parent		= &core_96m_fck,
 	.prcm_mod	= OMAP3430_CAM_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_CAM_MOD, CM_FCLKEN),
+	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP3430_EN_CSI2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "cam_clkdm" },
@@ -2312,7 +2299,7 @@ static struct clk usbhost_120m_fck = {
 	.name		= "usbhost_120m_fck",
 	.parent		= &dpll5_m2_ck,
 	.prcm_mod	= OMAP3430ES2_USBHOST_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430ES2_USBHOST_MOD, CM_FCLKEN),
+	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP3430ES2_EN_USBHOST2_SHIFT,
 	.flags		= CLOCK_IN_OMAP3430ES2,
 	.clkdm		= { .name = "usbhost_clkdm" },
@@ -2323,7 +2310,7 @@ static struct clk usbhost_48m_fck = {
 	.name		= "usbhost_48m_fck",
 	.parent		= &omap_48m_fck,
 	.prcm_mod	= OMAP3430ES2_USBHOST_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430ES2_USBHOST_MOD, CM_FCLKEN),
+	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP3430ES2_EN_USBHOST1_SHIFT,
 	.flags		= CLOCK_IN_OMAP3430ES2,
 	.clkdm		= { .name = "usbhost_clkdm" },
@@ -2335,7 +2322,7 @@ static struct clk usbhost_ick = {
 	.name		= "usbhost_ick",
 	.parent		= &l4_ick,
 	.prcm_mod	= OMAP3430ES2_USBHOST_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430ES2_USBHOST_MOD, CM_ICLKEN),
+	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP3430ES2_EN_USBHOST_SHIFT,
 	.flags		= CLOCK_IN_OMAP3430ES2,
 	.clkdm		= { .name = "usbhost_clkdm" },
@@ -2372,9 +2359,9 @@ static struct clk usim_fck = {
 	.name		= "usim_fck",
 	.prcm_mod	= WKUP_MOD,
 	.init		= &omap2_init_clksel_parent,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(WKUP_MOD, CM_FCLKEN),
+	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP3430ES2_EN_USIMOCP_SHIFT,
-	.clksel_reg	= _OMAP34XX_CM_REGADDR(WKUP_MOD, CM_CLKSEL),
+	.clksel_reg	= CM_CLKSEL,
 	.clksel_mask	= OMAP3430ES2_CLKSEL_USIMOCP_MASK,
 	.clksel		= usim_clksel,
 	.flags		= CLOCK_IN_OMAP3430ES2,
@@ -2387,9 +2374,9 @@ static struct clk gpt1_fck = {
 	.name		= "gpt1_fck",
 	.prcm_mod	= WKUP_MOD,
 	.init		= &omap2_init_clksel_parent,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(WKUP_MOD, CM_FCLKEN),
+	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP3430_EN_GPT1_SHIFT,
-	.clksel_reg	= _OMAP34XX_CM_REGADDR(WKUP_MOD, CM_CLKSEL),
+	.clksel_reg	= CM_CLKSEL,
 	.clksel_mask	= OMAP3430_CLKSEL_GPT1_MASK,
 	.clksel		= omap343x_gpt_clksel,
 	.flags		= CLOCK_IN_OMAP343X,
@@ -2409,7 +2396,7 @@ static struct clk gpio1_dbck = {
 	.name		= "gpio1_dbck",
 	.parent		= &wkup_32k_fck,
 	.prcm_mod	= WKUP_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(WKUP_MOD, CM_FCLKEN),
+	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP3430_EN_GPIO1_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "prm_clkdm" },
@@ -2420,7 +2407,7 @@ static struct clk wdt2_fck = {
 	.name		= "wdt2_fck",
 	.parent		= &wkup_32k_fck,
 	.prcm_mod	= WKUP_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(WKUP_MOD, CM_FCLKEN),
+	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP3430_EN_WDT2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "prm_clkdm" },
@@ -2441,7 +2428,7 @@ static struct clk usim_ick = {
 	.name		= "usim_ick",
 	.parent		= &wkup_l4_ick,
 	.prcm_mod	= WKUP_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(WKUP_MOD, CM_ICLKEN),
+	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP3430ES2_EN_USIMOCP_SHIFT,
 	.flags		= CLOCK_IN_OMAP3430ES2,
 	.clkdm		= { .name = "prm_clkdm" },
@@ -2452,7 +2439,7 @@ static struct clk wdt2_ick = {
 	.name		= "wdt2_ick",
 	.parent		= &wkup_l4_ick,
 	.prcm_mod	= WKUP_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(WKUP_MOD, CM_ICLKEN),
+	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP3430_EN_WDT2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "prm_clkdm" },
@@ -2463,7 +2450,7 @@ static struct clk wdt1_ick = {
 	.name		= "wdt1_ick",
 	.parent		= &wkup_l4_ick,
 	.prcm_mod	= WKUP_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(WKUP_MOD, CM_ICLKEN),
+	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP3430_EN_WDT1_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "prm_clkdm" },
@@ -2474,7 +2461,7 @@ static struct clk gpio1_ick = {
 	.name		= "gpio1_ick",
 	.parent		= &wkup_l4_ick,
 	.prcm_mod	= WKUP_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(WKUP_MOD, CM_ICLKEN),
+	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP3430_EN_GPIO1_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "prm_clkdm" },
@@ -2485,7 +2472,7 @@ static struct clk omap_32ksync_ick = {
 	.name		= "omap_32ksync_ick",
 	.parent		= &wkup_l4_ick,
 	.prcm_mod	= WKUP_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(WKUP_MOD, CM_ICLKEN),
+	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP3430_EN_32KSYNC_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "prm_clkdm" },
@@ -2496,7 +2483,7 @@ static struct clk gpt12_ick = {
 	.name		= "gpt12_ick",
 	.parent		= &wkup_l4_ick,
 	.prcm_mod	= WKUP_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(WKUP_MOD, CM_ICLKEN),
+	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP3430_EN_GPT12_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "prm_clkdm" },
@@ -2507,7 +2494,7 @@ static struct clk gpt1_ick = {
 	.name		= "gpt1_ick",
 	.parent		= &wkup_l4_ick,
 	.prcm_mod	= WKUP_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(WKUP_MOD, CM_ICLKEN),
+	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP3430_EN_GPT1_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "prm_clkdm" },
@@ -2540,7 +2527,7 @@ static struct clk uart3_fck = {
 	.name		= "uart3_fck",
 	.parent		= &per_48m_fck,
 	.prcm_mod	= OMAP3430_PER_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
+	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP3430_EN_UART3_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "per_clkdm" },
@@ -2551,9 +2538,9 @@ static struct clk gpt2_fck = {
 	.name		= "gpt2_fck",
 	.prcm_mod	= OMAP3430_PER_MOD,
 	.init		= &omap2_init_clksel_parent,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
+	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP3430_EN_GPT2_SHIFT,
-	.clksel_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_CLKSEL),
+	.clksel_reg	= CM_CLKSEL,
 	.clksel_mask	= OMAP3430_CLKSEL_GPT2_MASK,
 	.clksel		= omap343x_gpt_clksel,
 	.flags		= CLOCK_IN_OMAP343X,
@@ -2565,9 +2552,9 @@ static struct clk gpt3_fck = {
 	.name		= "gpt3_fck",
 	.prcm_mod	= OMAP3430_PER_MOD,
 	.init		= &omap2_init_clksel_parent,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
+	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP3430_EN_GPT3_SHIFT,
-	.clksel_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_CLKSEL),
+	.clksel_reg	= CM_CLKSEL,
 	.clksel_mask	= OMAP3430_CLKSEL_GPT3_MASK,
 	.clksel		= omap343x_gpt_clksel,
 	.flags		= CLOCK_IN_OMAP343X,
@@ -2579,9 +2566,9 @@ static struct clk gpt4_fck = {
 	.name		= "gpt4_fck",
 	.prcm_mod	= OMAP3430_PER_MOD,
 	.init		= &omap2_init_clksel_parent,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
+	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP3430_EN_GPT4_SHIFT,
-	.clksel_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_CLKSEL),
+	.clksel_reg	= CM_CLKSEL,
 	.clksel_mask	= OMAP3430_CLKSEL_GPT4_MASK,
 	.clksel		= omap343x_gpt_clksel,
 	.flags		= CLOCK_IN_OMAP343X,
@@ -2593,9 +2580,9 @@ static struct clk gpt5_fck = {
 	.name		= "gpt5_fck",
 	.prcm_mod	= OMAP3430_PER_MOD,
 	.init		= &omap2_init_clksel_parent,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
+	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP3430_EN_GPT5_SHIFT,
-	.clksel_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_CLKSEL),
+	.clksel_reg	= CM_CLKSEL,
 	.clksel_mask	= OMAP3430_CLKSEL_GPT5_MASK,
 	.clksel		= omap343x_gpt_clksel,
 	.flags		= CLOCK_IN_OMAP343X,
@@ -2607,9 +2594,9 @@ static struct clk gpt6_fck = {
 	.name		= "gpt6_fck",
 	.prcm_mod	= OMAP3430_PER_MOD,
 	.init		= &omap2_init_clksel_parent,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
+	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP3430_EN_GPT6_SHIFT,
-	.clksel_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_CLKSEL),
+	.clksel_reg	= CM_CLKSEL,
 	.clksel_mask	= OMAP3430_CLKSEL_GPT6_MASK,
 	.clksel		= omap343x_gpt_clksel,
 	.flags		= CLOCK_IN_OMAP343X,
@@ -2621,9 +2608,9 @@ static struct clk gpt7_fck = {
 	.name		= "gpt7_fck",
 	.prcm_mod	= OMAP3430_PER_MOD,
 	.init		= &omap2_init_clksel_parent,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
+	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP3430_EN_GPT7_SHIFT,
-	.clksel_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_CLKSEL),
+	.clksel_reg	= CM_CLKSEL,
 	.clksel_mask	= OMAP3430_CLKSEL_GPT7_MASK,
 	.clksel		= omap343x_gpt_clksel,
 	.flags		= CLOCK_IN_OMAP343X,
@@ -2635,9 +2622,9 @@ static struct clk gpt8_fck = {
 	.name		= "gpt8_fck",
 	.prcm_mod	= OMAP3430_PER_MOD,
 	.init		= &omap2_init_clksel_parent,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
+	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP3430_EN_GPT8_SHIFT,
-	.clksel_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_CLKSEL),
+	.clksel_reg	= CM_CLKSEL,
 	.clksel_mask	= OMAP3430_CLKSEL_GPT8_MASK,
 	.clksel		= omap343x_gpt_clksel,
 	.flags		= CLOCK_IN_OMAP343X,
@@ -2649,9 +2636,9 @@ static struct clk gpt9_fck = {
 	.name		= "gpt9_fck",
 	.prcm_mod	= OMAP3430_PER_MOD,
 	.init		= &omap2_init_clksel_parent,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
+	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP3430_EN_GPT9_SHIFT,
-	.clksel_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_CLKSEL),
+	.clksel_reg	= CM_CLKSEL,
 	.clksel_mask	= OMAP3430_CLKSEL_GPT9_MASK,
 	.clksel		= omap343x_gpt_clksel,
 	.flags		= CLOCK_IN_OMAP343X,
@@ -2671,7 +2658,7 @@ static struct clk gpio6_dbck = {
 	.name		= "gpio6_dbck",
 	.parent		= &per_32k_alwon_fck,
 	.prcm_mod	= OMAP3430_PER_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
+	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP3430_EN_GPIO6_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "per_clkdm" },
@@ -2682,7 +2669,7 @@ static struct clk gpio5_dbck = {
 	.name		= "gpio5_dbck",
 	.parent		= &per_32k_alwon_fck,
 	.prcm_mod	= OMAP3430_PER_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
+	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP3430_EN_GPIO5_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "per_clkdm" },
@@ -2693,7 +2680,7 @@ static struct clk gpio4_dbck = {
 	.name		= "gpio4_dbck",
 	.parent		= &per_32k_alwon_fck,
 	.prcm_mod	= OMAP3430_PER_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
+	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP3430_EN_GPIO4_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "per_clkdm" },
@@ -2704,7 +2691,7 @@ static struct clk gpio3_dbck = {
 	.name		= "gpio3_dbck",
 	.parent		= &per_32k_alwon_fck,
 	.prcm_mod	= OMAP3430_PER_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
+	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP3430_EN_GPIO3_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "per_clkdm" },
@@ -2715,7 +2702,7 @@ static struct clk gpio2_dbck = {
 	.name		= "gpio2_dbck",
 	.parent		= &per_32k_alwon_fck,
 	.prcm_mod	= OMAP3430_PER_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
+	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP3430_EN_GPIO2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "per_clkdm" },
@@ -2726,7 +2713,7 @@ static struct clk wdt3_fck = {
 	.name		= "wdt3_fck",
 	.parent		= &per_32k_alwon_fck,
 	.prcm_mod	= OMAP3430_PER_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
+	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP3430_EN_WDT3_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "per_clkdm" },
@@ -2746,7 +2733,7 @@ static struct clk gpio6_ick = {
 	.name		= "gpio6_ick",
 	.parent		= &per_l4_ick,
 	.prcm_mod	= OMAP3430_PER_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
+	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP3430_EN_GPIO6_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "per_clkdm" },
@@ -2757,7 +2744,7 @@ static struct clk gpio5_ick = {
 	.name		= "gpio5_ick",
 	.parent		= &per_l4_ick,
 	.prcm_mod	= OMAP3430_PER_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
+	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP3430_EN_GPIO5_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "per_clkdm" },
@@ -2768,7 +2755,7 @@ static struct clk gpio4_ick = {
 	.name		= "gpio4_ick",
 	.parent		= &per_l4_ick,
 	.prcm_mod	= OMAP3430_PER_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
+	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP3430_EN_GPIO4_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "per_clkdm" },
@@ -2779,7 +2766,7 @@ static struct clk gpio3_ick = {
 	.name		= "gpio3_ick",
 	.parent		= &per_l4_ick,
 	.prcm_mod	= OMAP3430_PER_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
+	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP3430_EN_GPIO3_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "per_clkdm" },
@@ -2790,7 +2777,7 @@ static struct clk gpio2_ick = {
 	.name		= "gpio2_ick",
 	.parent		= &per_l4_ick,
 	.prcm_mod	= OMAP3430_PER_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
+	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP3430_EN_GPIO2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "per_clkdm" },
@@ -2801,7 +2788,7 @@ static struct clk wdt3_ick = {
 	.name		= "wdt3_ick",
 	.parent		= &per_l4_ick,
 	.prcm_mod	= OMAP3430_PER_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
+	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP3430_EN_WDT3_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "per_clkdm" },
@@ -2812,7 +2799,7 @@ static struct clk uart3_ick = {
 	.name		= "uart3_ick",
 	.parent		= &per_l4_ick,
 	.prcm_mod	= OMAP3430_PER_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
+	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP3430_EN_UART3_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "per_clkdm" },
@@ -2823,7 +2810,7 @@ static struct clk gpt9_ick = {
 	.name		= "gpt9_ick",
 	.parent		= &per_l4_ick,
 	.prcm_mod	= OMAP3430_PER_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
+	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP3430_EN_GPT9_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "per_clkdm" },
@@ -2834,7 +2821,7 @@ static struct clk gpt8_ick = {
 	.name		= "gpt8_ick",
 	.parent		= &per_l4_ick,
 	.prcm_mod	= OMAP3430_PER_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
+	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP3430_EN_GPT8_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "per_clkdm" },
@@ -2845,7 +2832,7 @@ static struct clk gpt7_ick = {
 	.name		= "gpt7_ick",
 	.parent		= &per_l4_ick,
 	.prcm_mod	= OMAP3430_PER_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
+	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP3430_EN_GPT7_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "per_clkdm" },
@@ -2856,7 +2843,7 @@ static struct clk gpt6_ick = {
 	.name		= "gpt6_ick",
 	.parent		= &per_l4_ick,
 	.prcm_mod	= OMAP3430_PER_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
+	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP3430_EN_GPT6_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "per_clkdm" },
@@ -2867,7 +2854,7 @@ static struct clk gpt5_ick = {
 	.name		= "gpt5_ick",
 	.parent		= &per_l4_ick,
 	.prcm_mod	= OMAP3430_PER_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
+	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP3430_EN_GPT5_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "per_clkdm" },
@@ -2878,7 +2865,7 @@ static struct clk gpt4_ick = {
 	.name		= "gpt4_ick",
 	.parent		= &per_l4_ick,
 	.prcm_mod	= OMAP3430_PER_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
+	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP3430_EN_GPT4_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "per_clkdm" },
@@ -2889,7 +2876,7 @@ static struct clk gpt3_ick = {
 	.name		= "gpt3_ick",
 	.parent		= &per_l4_ick,
 	.prcm_mod	= OMAP3430_PER_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
+	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP3430_EN_GPT3_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "per_clkdm" },
@@ -2900,7 +2887,7 @@ static struct clk gpt2_ick = {
 	.name		= "gpt2_ick",
 	.parent		= &per_l4_ick,
 	.prcm_mod	= OMAP3430_PER_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
+	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP3430_EN_GPT2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "per_clkdm" },
@@ -2912,7 +2899,7 @@ static struct clk mcbsp2_ick = {
 	.id		= 2,
 	.parent		= &per_l4_ick,
 	.prcm_mod	= OMAP3430_PER_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
+	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP3430_EN_MCBSP2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "per_clkdm" },
@@ -2924,7 +2911,7 @@ static struct clk mcbsp3_ick = {
 	.id		= 3,
 	.parent		= &per_l4_ick,
 	.prcm_mod	= OMAP3430_PER_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
+	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP3430_EN_MCBSP3_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "per_clkdm" },
@@ -2936,7 +2923,7 @@ static struct clk mcbsp4_ick = {
 	.id		= 4,
 	.parent		= &per_l4_ick,
 	.prcm_mod	= OMAP3430_PER_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
+	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP3430_EN_MCBSP4_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "per_clkdm" },
@@ -2954,7 +2941,7 @@ static struct clk mcbsp2_src_fck = {
 	.id		= 2,
 	.prcm_mod	= CLK_REG_IN_SCM,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= OMAP343X_CTRL_REGADDR(OMAP2_CONTROL_DEVCONF0),
+	.clksel_reg	= OMAP2_CONTROL_DEVCONF0,
 	.clksel_mask	= OMAP2_MCBSP2_CLKS_MASK,
 	.clksel		= mcbsp_234_clksel,
 	.flags		= CLOCK_IN_OMAP343X,
@@ -2967,7 +2954,7 @@ static struct clk mcbsp2_fck = {
 	.id		= 2,
 	.parent		= &mcbsp2_src_fck,
 	.prcm_mod	= OMAP3430_PER_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
+	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP3430_EN_MCBSP2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "per_clkdm" },
@@ -2979,7 +2966,7 @@ static struct clk mcbsp3_src_fck = {
 	.id		= 3,
 	.prcm_mod	= CLK_REG_IN_SCM,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= OMAP343X_CTRL_REGADDR(OMAP343X_CONTROL_DEVCONF1),
+	.clksel_reg	= OMAP343X_CONTROL_DEVCONF1,
 	.clksel_mask	= OMAP2_MCBSP3_CLKS_MASK,
 	.clksel		= mcbsp_234_clksel,
 	.flags		= CLOCK_IN_OMAP343X,
@@ -2992,7 +2979,7 @@ static struct clk mcbsp3_fck = {
 	.id		= 3,
 	.parent		= &mcbsp3_src_fck,
 	.prcm_mod	= OMAP3430_PER_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
+	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP3430_EN_MCBSP3_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "per_clkdm" },
@@ -3004,7 +2991,7 @@ static struct clk mcbsp4_src_fck = {
 	.id		= 4,
 	.prcm_mod	= CLK_REG_IN_SCM,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= OMAP343X_CTRL_REGADDR(OMAP343X_CONTROL_DEVCONF1),
+	.clksel_reg	= OMAP343X_CONTROL_DEVCONF1,
 	.clksel_mask	= OMAP2_MCBSP4_CLKS_MASK,
 	.clksel		= mcbsp_234_clksel,
 	.flags		= CLOCK_IN_OMAP343X,
@@ -3017,7 +3004,7 @@ static struct clk mcbsp4_fck = {
 	.id		= 4,
 	.parent		= &mcbsp4_src_fck,
 	.prcm_mod	= OMAP3430_PER_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
+	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP3430_EN_MCBSP4_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "per_clkdm" },
@@ -3065,7 +3052,7 @@ static struct clk emu_src_ck = {
 	.name		= "emu_src_ck",
 	.prcm_mod	= OMAP3430_EMU_MOD,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_EMU_MOD, CM_CLKSEL1),
+	.clksel_reg	= CM_CLKSEL1,
 	.clksel_mask	= OMAP3430_MUX_CTRL_MASK,
 	.clksel		= emu_src_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | ALWAYS_ENABLED,
@@ -3090,7 +3077,7 @@ static struct clk pclk_fck = {
 	.name		= "pclk_fck",
 	.prcm_mod	= OMAP3430_EMU_MOD,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_EMU_MOD, CM_CLKSEL1),
+	.clksel_reg	= CM_CLKSEL1,
 	.clksel_mask	= OMAP3430_CLKSEL_PCLK_MASK,
 	.clksel		= pclk_emu_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | ALWAYS_ENABLED,
@@ -3114,7 +3101,7 @@ static struct clk pclkx2_fck = {
 	.name		= "pclkx2_fck",
 	.prcm_mod	= OMAP3430_EMU_MOD,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_EMU_MOD, CM_CLKSEL1),
+	.clksel_reg	= CM_CLKSEL1,
 	.clksel_mask	= OMAP3430_CLKSEL_PCLKX2_MASK,
 	.clksel		= pclkx2_emu_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | ALWAYS_ENABLED,
@@ -3131,7 +3118,7 @@ static struct clk atclk_fck = {
 	.name		= "atclk_fck",
 	.prcm_mod	= OMAP3430_EMU_MOD,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_EMU_MOD, CM_CLKSEL1),
+	.clksel_reg	= CM_CLKSEL1,
 	.clksel_mask	= OMAP3430_CLKSEL_ATCLK_MASK,
 	.clksel		= atclk_emu_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | ALWAYS_ENABLED,
@@ -3143,7 +3130,7 @@ static struct clk traceclk_src_fck = {
 	.name		= "traceclk_src_fck",
 	.prcm_mod	= OMAP3430_EMU_MOD,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_EMU_MOD, CM_CLKSEL1),
+	.clksel_reg	= CM_CLKSEL1,
 	.clksel_mask	= OMAP3430_TRACE_MUX_CTRL_MASK,
 	.clksel		= emu_src_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | ALWAYS_ENABLED,
@@ -3167,7 +3154,7 @@ static struct clk traceclk_fck = {
 	.name		= "traceclk_fck",
 	.prcm_mod	= OMAP3430_EMU_MOD,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_EMU_MOD, CM_CLKSEL1),
+	.clksel_reg	= CM_CLKSEL1,
 	.clksel_mask	= OMAP3430_CLKSEL_TRACECLK_MASK,
 	.clksel		= traceclk_clksel,
 	.flags		= CLOCK_IN_OMAP343X | ALWAYS_ENABLED,
@@ -3182,7 +3169,7 @@ static struct clk sr1_fck = {
 	.name		= "sr1_fck",
 	.parent		= &sys_ck,
 	.prcm_mod	= WKUP_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(WKUP_MOD, CM_FCLKEN),
+	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP3430_EN_SR1_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES,
 	.clkdm		= { .name = "prm_clkdm" },
@@ -3194,7 +3181,7 @@ static struct clk sr2_fck = {
 	.name		= "sr2_fck",
 	.parent		= &sys_ck,
 	.prcm_mod	= WKUP_MOD,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(WKUP_MOD, CM_FCLKEN),
+	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP3430_EN_SR2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES,
 	.clkdm		= { .name = "prm_clkdm" },
diff --git a/arch/arm/mach-omap2/cm.h b/arch/arm/mach-omap2/cm.h
index bacadcb..7750bec 100644
--- a/arch/arm/mach-omap2/cm.h
+++ b/arch/arm/mach-omap2/cm.h
@@ -33,8 +33,7 @@
 #define OMAP3430_CM_SYSCONFIG		OMAP34XX_CM_REGADDR(OCP_MOD, 0x0010)
 #define OMAP3430_CM_POLCTRL		OMAP34XX_CM_REGADDR(OCP_MOD, 0x009c)
 
-#define OMAP3430_CM_CLKOUT_CTRL						\
-				OMAP34XX_CM_REGADDR(OMAP3430_CCR_MOD, 0x0070)
+#define OMAP3430_CM_CLKOUT_CTRL_OFFSET			0x0070
 
 /*
  * Module specific CM registers from CM_BASE + domain offset
diff --git a/arch/arm/plat-omap/common.c b/arch/arm/plat-omap/common.c
index 314b145..0843b88 100644
--- a/arch/arm/plat-omap/common.c
+++ b/arch/arm/plat-omap/common.c
@@ -252,7 +252,6 @@ static void __init __omap2_set_globals(void)
 	omap2_set_globals_memory(omap2_globals);
 	omap2_set_globals_control(omap2_globals);
 	omap2_set_globals_prcm(omap2_globals);
-	omap2_set_globals_clock24xx(omap2_globals);
 }
 
 #endif
diff --git a/arch/arm/plat-omap/include/mach/clock.h b/arch/arm/plat-omap/include/mach/clock.h
index 22db786..847b122 100644
--- a/arch/arm/plat-omap/include/mach/clock.h
+++ b/arch/arm/plat-omap/include/mach/clock.h
@@ -31,7 +31,7 @@ struct clksel {
 };
 
 struct dpll_data {
-	void __iomem		*mult_div1_reg;
+	u16			mult_div1_reg;
 	u32			mult_mask;
 	u32			div1_mask;
 	u16			last_rounded_m;
@@ -43,17 +43,17 @@ struct dpll_data {
 	u8			max_divider;
 	u32			max_tolerance;
 	struct clk		*bypass_clk;
-	void __iomem		*control_reg;
+	u16			control_reg;
 	u32			enable_mask;
 #  if defined(CONFIG_ARCH_OMAP3)
-	void __iomem		*idlest_reg;
+	u16			idlest_reg;
 	u32			idlest_mask;
 	u32			freqsel_mask;
 	u8			modes;
 	u8			auto_recal_bit;
 	u8			recal_en_bit;
 	u8			recal_st_bit;
-	void __iomem		*autoidle_reg;
+	u16			autoidle_reg;
 	u32			autoidle_mask;
 #  endif
 };
@@ -68,7 +68,7 @@ struct clk {
 	struct clk		*parent;
 	unsigned long		rate;
 	__u32			flags;
-	void __iomem		*enable_reg;
+	u16			enable_reg;
 	__u8			enable_bit;
 	__s8			usecount;
 	void			(*recalc)(struct clk *);
@@ -79,7 +79,7 @@ struct clk {
 	void			(*disable)(struct clk *);
 #if defined(CONFIG_ARCH_OMAP2) || defined(CONFIG_ARCH_OMAP3)
 	u8			fixed_div;
-	void __iomem		*clksel_reg;
+	u16			clksel_reg;
 	u32			clksel_mask;
 	const struct clksel	*clksel;
 	struct dpll_data	*dpll_data;
@@ -143,9 +143,8 @@ extern void clk_init_cpufreq_table(struct cpufreq_frequency_table **table);
 #define DELAYED_APP		(1 << 9)	/* Delay application of clock */
 #define CONFIG_PARTICIPANT	(1 << 10)	/* Fundamental clock */
 #define ENABLE_ON_INIT		(1 << 11)	/* Enable upon framework init */
-#define INVERT_ENABLE           (1 << 12)       /* 0 enables, 1 disables */
-#define OFFSET_GR_MOD		(1 << 13)	/* 24xx GR_MOD reg as offset */
-/* bits 14-20 are currently free */
+#define INVERT_ENABLE		(1 << 12)	/* 0 enables, 1 disables */
+/* bits 13-20 are currently free */
 #define CLOCK_IN_OMAP310	(1 << 21)
 #define CLOCK_IN_OMAP730	(1 << 22)
 #define CLOCK_IN_OMAP1510	(1 << 23)


