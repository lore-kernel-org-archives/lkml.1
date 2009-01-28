Return-Path: <linux-kernel-owner+w=401wt.eu-S1757896AbZA1Ugy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757896AbZA1Ugy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 15:36:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755489AbZA1U3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:29:40 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:32950 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755426AbZA1U3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:29:32 -0500
MBOX-Line: From nobody Tue Jan 27 19:12:50 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH A 02/10] OMAP: Fix sparse,
	checkpatch warnings in OMAP2/3 PRCM/PM code
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Cc: Paul Walmsley <paul@pwsan.com>, Tony Lindgren <tony@atomide.com>,
       linux-omap@vger.kernel.org
Date: Tue, 27 Jan 2009 19:12:50 -0700
Message-ID: <20090128021247.7244.10391.stgit@localhost.localdomain>
In-Reply-To: <20090128020447.7244.80496.stgit@localhost.localdomain>
References: <20090128020447.7244.80496.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix sparse & checkpatch warnings in OMAP2/3 PRCM & PM code.  This mostly
consists of:

- converting pointer comparisons to integers in form similar to
  (ptr == 0) to the standard idiom (!ptr)

- labeling a few non-static private functions as static

- adding prototypes for *_init() functions in the appropriate header
  files, and getting rid of the corresponding open-coded extern
  prototypes in other C files

- renaming the variable 'sclk' in mach-omap2/clock.c:omap2_get_apll_clkin
  to avoid shadowing an earlier declaration

Clean up checkpatch issues.  This mostly involves:

- converting some asm/ includes to linux/ includes

- cleaning up some whitespace

- getting rid of braces for conditionals with single following statements

Also take care of a few odds and ends, including:

- getting rid of unlikely() and likely() - none of this code is particularly
  fast-path code, so the performance impact seems slim; and some of those
  likely() and unlikely() indicators are probably not as accurate as the
  ARM's branch predictor

- removing some superfluous casts

linux-omap source commit is 347df59f5d20fdf905afbc26b1328b0e28a8a01b.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/clock.c                   |   61 ++++++++++++-------------
 arch/arm/mach-omap2/clock.h                   |    2 -
 arch/arm/mach-omap2/clock24xx.c               |   16 ++++---
 arch/arm/mach-omap2/pm.c                      |    2 -
 arch/arm/plat-omap/include/mach/clock.h       |    4 +-
 arch/arm/plat-omap/include/mach/powerdomain.h |    1 
 arch/arm/plat-omap/include/mach/prcm.h        |    5 +-
 arch/arm/plat-omap/include/mach/system.h      |    4 +-
 8 files changed, 49 insertions(+), 46 deletions(-)

diff --git a/arch/arm/mach-omap2/clock.c b/arch/arm/mach-omap2/clock.c
index ad721e0..c4b80a4 100644
--- a/arch/arm/mach-omap2/clock.c
+++ b/arch/arm/mach-omap2/clock.c
@@ -26,7 +26,6 @@
 
 #include <mach/clock.h>
 #include <mach/clockdomain.h>
-#include <mach/sram.h>
 #include <mach/cpu.h>
 #include <asm/div64.h>
 
@@ -190,11 +189,10 @@ int omap2_wait_clock_ready(void __iomem *reg, u32 mask, const char *name)
 	 * 24xx uses 0 to indicate not ready, and 1 to indicate ready.
 	 * 34xx reverses this, just to keep us on our toes
 	 */
-	if (cpu_mask & (RATE_IN_242X | RATE_IN_243X)) {
+	if (cpu_mask & (RATE_IN_242X | RATE_IN_243X))
 		ena = mask;
-	} else if (cpu_mask & RATE_IN_343X) {
+	else if (cpu_mask & RATE_IN_343X)
 		ena = 0;
-	}
 
 	/* Wait for lock */
 	while (((__raw_readl(reg) & mask) != ena) &&
@@ -267,7 +265,7 @@ static void omap2_clk_wait_ready(struct clk *clk)
 /* Enables clock without considering parent dependencies or use count
  * REVISIT: Maybe change this to use clk->enable like on omap1?
  */
-int _omap2_clk_enable(struct clk *clk)
+static int _omap2_clk_enable(struct clk *clk)
 {
 	u32 regval32;
 
@@ -277,7 +275,7 @@ int _omap2_clk_enable(struct clk *clk)
 	if (clk->enable)
 		return clk->enable(clk);
 
-	if (unlikely(clk->enable_reg == NULL)) {
+	if (!clk->enable_reg) {
 		printk(KERN_ERR "clock.c: Enable for %s without enable code\n",
 		       clk->name);
 		return 0; /* REVISIT: -EINVAL */
@@ -297,7 +295,7 @@ int _omap2_clk_enable(struct clk *clk)
 }
 
 /* Disables clock without considering parent dependencies or use count */
-void _omap2_clk_disable(struct clk *clk)
+static void _omap2_clk_disable(struct clk *clk)
 {
 	u32 regval32;
 
@@ -309,7 +307,7 @@ void _omap2_clk_disable(struct clk *clk)
 		return;
 	}
 
-	if (clk->enable_reg == NULL) {
+	if (!clk->enable_reg) {
 		/*
 		 * 'Independent' here refers to a clock which is not
 		 * controlled by its parent.
@@ -332,7 +330,7 @@ void omap2_clk_disable(struct clk *clk)
 {
 	if (clk->usecount > 0 && !(--clk->usecount)) {
 		_omap2_clk_disable(clk);
-		if (likely((u32)clk->parent))
+		if (clk->parent)
 			omap2_clk_disable(clk->parent);
 		if (clk->clkdm)
 			omap2_clkdm_clk_disable(clk->clkdm, clk);
@@ -345,10 +343,10 @@ int omap2_clk_enable(struct clk *clk)
 	int ret = 0;
 
 	if (clk->usecount++ == 0) {
-		if (likely((u32)clk->parent))
+		if (clk->parent)
 			ret = omap2_clk_enable(clk->parent);
 
-		if (unlikely(ret != 0)) {
+		if (ret != 0) {
 			clk->usecount--;
 			return ret;
 		}
@@ -358,7 +356,7 @@ int omap2_clk_enable(struct clk *clk)
 
 		ret = _omap2_clk_enable(clk);
 
-		if (unlikely(ret != 0)) {
+		if (ret != 0) {
 			if (clk->clkdm)
 				omap2_clkdm_clk_disable(clk->clkdm, clk);
 
@@ -386,13 +384,13 @@ void omap2_clksel_recalc(struct clk *clk)
 	if (div == 0)
 		return;
 
-	if (unlikely(clk->rate == clk->parent->rate / div))
+	if (clk->rate == (clk->parent->rate / div))
 		return;
 	clk->rate = clk->parent->rate / div;
 
 	pr_debug("clock: new clock rate is %ld (div %d)\n", clk->rate, div);
 
-	if (unlikely(clk->flags & RATE_PROPAGATES))
+	if (clk->flags & RATE_PROPAGATES)
 		propagate_rate(clk);
 }
 
@@ -405,8 +403,8 @@ void omap2_clksel_recalc(struct clk *clk)
  * the element associated with the supplied parent clock address.
  * Returns a pointer to the struct clksel on success or NULL on error.
  */
-const struct clksel *omap2_get_clksel_by_parent(struct clk *clk,
-						struct clk *src_clk)
+static const struct clksel *omap2_get_clksel_by_parent(struct clk *clk,
+						       struct clk *src_clk)
 {
 	const struct clksel *clks;
 
@@ -455,7 +453,7 @@ u32 omap2_clksel_round_rate_div(struct clk *clk, unsigned long target_rate,
 	*new_div = 1;
 
 	clks = omap2_get_clksel_by_parent(clk, clk->parent);
-	if (clks == NULL)
+	if (!clks)
 		return ~0;
 
 	for (clkr = clks->rates; clkr->div; clkr++) {
@@ -514,7 +512,7 @@ long omap2_clksel_round_rate(struct clk *clk, unsigned long target_rate)
 /* Given a clock and a rate apply a clock specific rounding function */
 long omap2_clk_round_rate(struct clk *clk, unsigned long rate)
 {
-	if (clk->round_rate != NULL)
+	if (clk->round_rate)
 		return clk->round_rate(clk, rate);
 
 	if (clk->flags & RATE_FIXED)
@@ -540,7 +538,7 @@ u32 omap2_clksel_to_divisor(struct clk *clk, u32 field_val)
 	const struct clksel_rate *clkr;
 
 	clks = omap2_get_clksel_by_parent(clk, clk->parent);
-	if (clks == NULL)
+	if (!clks)
 		return 0;
 
 	for (clkr = clks->rates; clkr->div; clkr++) {
@@ -576,7 +574,7 @@ u32 omap2_divisor_to_clksel(struct clk *clk, u32 div)
 	WARN_ON(div == 0);
 
 	clks = omap2_get_clksel_by_parent(clk, clk->parent);
-	if (clks == NULL)
+	if (!clks)
 		return 0;
 
 	for (clkr = clks->rates; clkr->div; clkr++) {
@@ -601,9 +599,9 @@ u32 omap2_divisor_to_clksel(struct clk *clk, u32 div)
  *
  * Returns the address of the clksel register upon success or NULL on error.
  */
-void __iomem *omap2_get_clksel(struct clk *clk, u32 *field_mask)
+static void __iomem *omap2_get_clksel(struct clk *clk, u32 *field_mask)
 {
-	if (unlikely((clk->clksel_reg == NULL) || (clk->clksel_mask == NULL)))
+	if (!clk->clksel_reg || (clk->clksel_mask == 0))
 		return NULL;
 
 	*field_mask = clk->clksel_mask;
@@ -623,7 +621,7 @@ u32 omap2_clksel_get_divisor(struct clk *clk)
 	void __iomem *div_addr;
 
 	div_addr = omap2_get_clksel(clk, &field_mask);
-	if (div_addr == NULL)
+	if (!div_addr)
 		return 0;
 
 	field_val = __raw_readl(div_addr) & field_mask;
@@ -642,7 +640,7 @@ int omap2_clksel_set_rate(struct clk *clk, unsigned long rate)
 		return -EINVAL;
 
 	div_addr = omap2_get_clksel(clk, &field_mask);
-	if (div_addr == NULL)
+	if (!div_addr)
 		return -EINVAL;
 
 	field_val = omap2_divisor_to_clksel(clk, new_div);
@@ -680,10 +678,10 @@ int omap2_clk_set_rate(struct clk *clk, unsigned long rate)
 		return -EINVAL;
 
 	/* dpll_ck, core_ck, virt_prcm_set; plus all clksel clocks */
-	if (clk->set_rate != NULL)
+	if (clk->set_rate)
 		ret = clk->set_rate(clk, rate);
 
-	if (unlikely(ret == 0 && (clk->flags & RATE_PROPAGATES)))
+	if (ret == 0 && (clk->flags & RATE_PROPAGATES))
 		propagate_rate(clk);
 
 	return ret;
@@ -704,7 +702,7 @@ static u32 omap2_clksel_get_src_field(void __iomem **src_addr,
 	*src_addr = NULL;
 
 	clks = omap2_get_clksel_by_parent(clk, src_clk);
-	if (clks == NULL)
+	if (!clks)
 		return 0;
 
 	for (clkr = clks->rates; clkr->div; clkr++) {
@@ -734,7 +732,7 @@ int omap2_clk_set_parent(struct clk *clk, struct clk *new_parent)
 	void __iomem *src_addr;
 	u32 field_val, field_mask, reg_val, parent_div;
 
-	if (unlikely(clk->flags & CONFIG_PARTICIPANT))
+	if (clk->flags & CONFIG_PARTICIPANT)
 		return -EINVAL;
 
 	if (!clk->clksel)
@@ -742,7 +740,7 @@ int omap2_clk_set_parent(struct clk *clk, struct clk *new_parent)
 
 	field_val = omap2_clksel_get_src_field(&src_addr, new_parent,
 					       &field_mask, clk, &parent_div);
-	if (src_addr == NULL)
+	if (!src_addr)
 		return -EINVAL;
 
 	if (clk->usecount > 0)
@@ -773,7 +771,7 @@ int omap2_clk_set_parent(struct clk *clk, struct clk *new_parent)
 	pr_debug("clock: set parent of %s to %s (new rate %ld)\n",
 		 clk->name, clk->parent->name, clk->rate);
 
-	if (unlikely(clk->flags & RATE_PROPAGATES))
+	if (clk->flags & RATE_PROPAGATES)
 		propagate_rate(clk);
 
 	return 0;
@@ -805,7 +803,8 @@ int omap2_dpll_set_rate_tolerance(struct clk *clk, unsigned int tolerance)
 	return 0;
 }
 
-static unsigned long _dpll_compute_new_rate(unsigned long parent_rate, unsigned int m, unsigned int n)
+static unsigned long _dpll_compute_new_rate(unsigned long parent_rate,
+					    unsigned int m, unsigned int n)
 {
 	unsigned long long num;
 
diff --git a/arch/arm/mach-omap2/clock.h b/arch/arm/mach-omap2/clock.h
index 1fb330e..3fa2e26 100644
--- a/arch/arm/mach-omap2/clock.h
+++ b/arch/arm/mach-omap2/clock.h
@@ -27,7 +27,7 @@ void omap2_clk_disable(struct clk *clk);
 long omap2_clk_round_rate(struct clk *clk, unsigned long rate);
 int omap2_clk_set_rate(struct clk *clk, unsigned long rate);
 int omap2_clk_set_parent(struct clk *clk, struct clk *new_parent);
-int omap2_dpll_rate_tolerance_set(struct clk *clk, unsigned int tolerance);
+int omap2_dpll_set_rate_tolerance(struct clk *clk, unsigned int tolerance);
 long omap2_dpll_round_rate(struct clk *clk, unsigned long target_rate);
 
 #ifdef CONFIG_OMAP_RESET_CLOCKS
diff --git a/arch/arm/mach-omap2/clock24xx.c b/arch/arm/mach-omap2/clock24xx.c
index d382eb0..59b1fb2 100644
--- a/arch/arm/mach-omap2/clock24xx.c
+++ b/arch/arm/mach-omap2/clock24xx.c
@@ -153,7 +153,7 @@ static void omap2_clk_fixed_disable(struct clk *clk)
  * Uses the current prcm set to tell if a rate is valid.
  * You can go slower, but not faster within a given rate set.
  */
-long omap2_dpllcore_round_rate(unsigned long target_rate)
+static long omap2_dpllcore_round_rate(unsigned long target_rate)
 {
 	u32 high, low, core_clk_src;
 
@@ -366,7 +366,9 @@ static int omap2_select_table_rate(struct clk *clk, unsigned long rate)
 
 		/* Major subsystem dividers */
 		tmp = cm_read_mod_reg(CORE_MOD, CM_CLKSEL1) & OMAP24XX_CLKSEL_DSS2_MASK;
-		cm_write_mod_reg(prcm->cm_clksel1_core | tmp, CORE_MOD, CM_CLKSEL1);
+		cm_write_mod_reg(prcm->cm_clksel1_core | tmp, CORE_MOD,
+				 CM_CLKSEL1);
+
 		if (cpu_is_omap2430())
 			cm_write_mod_reg(prcm->cm_clksel_mdm,
 					 OMAP2430_MDM_MOD, CM_CLKSEL);
@@ -398,20 +400,20 @@ static struct clk_functions omap2_clk_functions = {
 
 static u32 omap2_get_apll_clkin(void)
 {
-	u32 aplls, sclk = 0;
+	u32 aplls, srate = 0;
 
 	aplls = cm_read_mod_reg(PLL_MOD, CM_CLKSEL1);
 	aplls &= OMAP24XX_APLLS_CLKIN_MASK;
 	aplls >>= OMAP24XX_APLLS_CLKIN_SHIFT;
 
 	if (aplls == APLLS_CLKIN_19_2MHZ)
-		sclk = 19200000;
+		srate = 19200000;
 	else if (aplls == APLLS_CLKIN_13MHZ)
-		sclk = 13000000;
+		srate = 13000000;
 	else if (aplls == APLLS_CLKIN_12MHZ)
-		sclk = 12000000;
+		srate = 12000000;
 
-	return sclk;
+	return srate;
 }
 
 static u32 omap2_get_sysclkdiv(void)
diff --git a/arch/arm/mach-omap2/pm.c b/arch/arm/mach-omap2/pm.c
index 55361c1..ea8ceae 100644
--- a/arch/arm/mach-omap2/pm.c
+++ b/arch/arm/mach-omap2/pm.c
@@ -103,7 +103,7 @@ static struct platform_suspend_ops omap_pm_ops = {
 	.valid		= suspend_valid_only_mem,
 };
 
-int __init omap2_pm_init(void)
+static int __init omap2_pm_init(void)
 {
 	return 0;
 }
diff --git a/arch/arm/plat-omap/include/mach/clock.h b/arch/arm/plat-omap/include/mach/clock.h
index 85a88ad..5f37735 100644
--- a/arch/arm/plat-omap/include/mach/clock.h
+++ b/arch/arm/plat-omap/include/mach/clock.h
@@ -111,12 +111,12 @@ struct clk_functions {
 
 extern unsigned int mpurate;
 
-extern int clk_init(struct clk_functions * custom_clocks);
+extern int clk_init(struct clk_functions *custom_clocks);
 extern int clk_register(struct clk *clk);
 extern void clk_unregister(struct clk *clk);
 extern void propagate_rate(struct clk *clk);
 extern void recalculate_root_clocks(void);
-extern void followparent_recalc(struct clk * clk);
+extern void followparent_recalc(struct clk *clk);
 extern void clk_allow_idle(struct clk *clk);
 extern void clk_deny_idle(struct clk *clk);
 extern int clk_get_usecount(struct clk *clk);
diff --git a/arch/arm/plat-omap/include/mach/powerdomain.h b/arch/arm/plat-omap/include/mach/powerdomain.h
index 2806a9c..4948cb7 100644
--- a/arch/arm/plat-omap/include/mach/powerdomain.h
+++ b/arch/arm/plat-omap/include/mach/powerdomain.h
@@ -145,6 +145,7 @@ int pwrdm_get_mem_bank_count(struct powerdomain *pwrdm);
 
 int pwrdm_set_next_pwrst(struct powerdomain *pwrdm, u8 pwrst);
 int pwrdm_read_next_pwrst(struct powerdomain *pwrdm);
+int pwrdm_read_pwrst(struct powerdomain *pwrdm);
 int pwrdm_read_prev_pwrst(struct powerdomain *pwrdm);
 int pwrdm_clear_all_prev_pwrst(struct powerdomain *pwrdm);
 
diff --git a/arch/arm/plat-omap/include/mach/prcm.h b/arch/arm/plat-omap/include/mach/prcm.h
index 56eba0f..24ac3c7 100644
--- a/arch/arm/plat-omap/include/mach/prcm.h
+++ b/arch/arm/plat-omap/include/mach/prcm.h
@@ -20,10 +20,11 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  */
 
-#ifndef __ASM_ARM_ARCH_DPM_PRCM_H
-#define __ASM_ARM_ARCH_DPM_PRCM_H
+#ifndef __ASM_ARM_ARCH_OMAP_PRCM_H
+#define __ASM_ARM_ARCH_OMAP_PRCM_H
 
 u32 omap_prcm_get_reset_sources(void);
+void omap_prcm_arch_reset(char mode);
 
 #endif
 
diff --git a/arch/arm/plat-omap/include/mach/system.h b/arch/arm/plat-omap/include/mach/system.h
index 06923f2..e9b9563 100644
--- a/arch/arm/plat-omap/include/mach/system.h
+++ b/arch/arm/plat-omap/include/mach/system.h
@@ -9,12 +9,12 @@
 #include <asm/mach-types.h>
 #include <mach/hardware.h>
 
+#include <mach/prcm.h>
+
 #ifndef CONFIG_MACH_VOICEBLUE
 #define voiceblue_reset()		do {} while (0)
 #endif
 
-extern void omap_prcm_arch_reset(char mode);
-
 static inline void arch_idle(void)
 {
 	cpu_do_idle();


