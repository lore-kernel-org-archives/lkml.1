Return-Path: <linux-kernel-owner+w=401wt.eu-S1757789AbZA1Ugc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757789AbZA1Ugc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 15:36:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752514AbZA1U3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:29:37 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:32947 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755420AbZA1U3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:29:31 -0500
MBOX-Line: From nobody Tue Jan 27 19:12:47 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH A 01/10] OMAP2/3: Add non-CORE DPLL rate set code and M,
	N programming
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Cc: Paul Walmsley <paul@pwsan.com>, Tony Lindgren <tony@atomide.com>,
       linux-omap@vger.kernel.org
Date: Tue, 27 Jan 2009 19:12:47 -0700
Message-ID: <20090128021243.7244.6362.stgit@localhost.localdomain>
In-Reply-To: <20090128020447.7244.80496.stgit@localhost.localdomain>
References: <20090128020447.7244.80496.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add non-CORE DPLL rate set code and M,N programming for OMAP3.
Connect it to OMAP34xx DPLLs 1, 2, 4, 5 via the clock framework.

You may see some warnings on rate sets from the freqsel code.  The
table that TI presented in the 3430 TRM Rev F does not cover Fint <
750000, which definitely occurs in practice.  However, the lack of this
freqsel case does not appear to impair the DPLL rate change.

linux-omap source commit is 689fe67c6d1ad8f52f7f7b139a3274b79bf3e784.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/clock34xx.c         |  141 +++++++++++++++++++++++++++++++
 arch/arm/mach-omap2/clock34xx.h         |   10 ++
 arch/arm/plat-omap/include/mach/clock.h |    1 
 3 files changed, 151 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/clock34xx.c b/arch/arm/mach-omap2/clock34xx.c
index 31bb701..b6fe2c9 100644
--- a/arch/arm/mach-omap2/clock34xx.c
+++ b/arch/arm/mach-omap2/clock34xx.c
@@ -104,6 +104,42 @@ static int _omap3_wait_dpll_status(struct clk *clk, u8 state)
 	return ret;
 }
 
+/* From 3430 TRM ES2 4.7.6.2 */
+static u16 _omap3_dpll_compute_freqsel(struct clk *clk, u8 n)
+{
+	unsigned long fint;
+	u16 f = 0;
+
+	fint = clk->parent->rate / (n + 1);
+
+	pr_debug("clock: fint is %lu\n", fint);
+
+	if (fint >= 750000 && fint <= 1000000)
+		f = 0x3;
+	else if (fint > 1000000 && fint <= 1250000)
+		f = 0x4;
+	else if (fint > 1250000 && fint <= 1500000)
+		f = 0x5;
+	else if (fint > 1500000 && fint <= 1750000)
+		f = 0x6;
+	else if (fint > 1750000 && fint <= 2100000)
+		f = 0x7;
+	else if (fint > 7500000 && fint <= 10000000)
+		f = 0xB;
+	else if (fint > 10000000 && fint <= 12500000)
+		f = 0xC;
+	else if (fint > 12500000 && fint <= 15000000)
+		f = 0xD;
+	else if (fint > 15000000 && fint <= 17500000)
+		f = 0xE;
+	else if (fint > 17500000 && fint <= 21000000)
+		f = 0xF;
+	else
+		pr_debug("clock: unknown freqsel setting for %d\n", n);
+
+	return f;
+}
+
 /* Non-CORE DPLL (e.g., DPLLs that do not control SDRC) clock functions */
 
 /*
@@ -240,7 +276,7 @@ static int omap3_noncore_dpll_enable(struct clk *clk)
 	if (clk == &dpll3_ck)
 		return -EINVAL;
 
-	if (clk->parent->rate == clk_get_rate(clk))
+	if (clk->parent->rate == omap2_get_dpll_rate(clk))
 		r = _omap3_noncore_dpll_bypass(clk);
 	else
 		r = _omap3_noncore_dpll_lock(clk);
@@ -270,6 +306,109 @@ static void omap3_noncore_dpll_disable(struct clk *clk)
 	_omap3_noncore_dpll_stop(clk);
 }
 
+
+/* Non-CORE DPLL rate set code */
+
+/*
+ * omap3_noncore_dpll_program - set non-core DPLL M,N values directly
+ * @clk: struct clk * of DPLL to set
+ * @m: DPLL multiplier to set
+ * @n: DPLL divider to set
+ * @freqsel: FREQSEL value to set
+ *
+ * Program the DPLL with the supplied M, N values, and wait for the DPLL to
+ * lock..  Returns -EINVAL upon error, or 0 upon success.
+ */
+static int omap3_noncore_dpll_program(struct clk *clk, u16 m, u8 n, u16 freqsel)
+{
+	struct dpll_data *dd;
+	u32 v;
+
+	if (!clk)
+		return -EINVAL;
+
+	dd = clk->dpll_data;
+	if (!dd)
+		return -EINVAL;
+
+	/*
+	 * According to the 12-5 CDP code from TI, "Limitation 2.5"
+	 * on 3430ES1 prevents us from changing DPLL multipliers or dividers
+	 * on DPLL4.
+	 */
+	if (omap_rev() == OMAP3430_REV_ES1_0 &&
+	    !strcmp("dpll4_ck", clk->name)) {
+		printk(KERN_ERR "clock: DPLL4 cannot change rate due to "
+		       "silicon 'Limitation 2.5' on 3430ES1.\n");
+		return -EINVAL;
+	}
+
+	/* 3430 ES2 TRM: 4.7.6.9 DPLL Programming Sequence */
+	_omap3_noncore_dpll_bypass(clk);
+
+	v = __raw_readl(dd->mult_div1_reg);
+	v &= ~(dd->mult_mask | dd->div1_mask);
+
+	/* Set mult (M), div1 (N), freqsel */
+	v |= m << __ffs(dd->mult_mask);
+	v |= n << __ffs(dd->div1_mask);
+	v |= freqsel << __ffs(dd->freqsel_mask);
+
+	__raw_writel(v, dd->mult_div1_reg);
+
+	/* We let the clock framework set the other output dividers later */
+
+	/* REVISIT: Set ramp-up delay? */
+
+	_omap3_noncore_dpll_lock(clk);
+
+	return 0;
+}
+
+/**
+ * omap3_noncore_dpll_set_rate - set non-core DPLL rate
+ * @clk: struct clk * of DPLL to set
+ * @rate: rounded target rate
+ *
+ * Program the DPLL with the rounded target rate.  Returns -EINVAL upon
+ * error, or 0 upon success.
+ */
+static int omap3_noncore_dpll_set_rate(struct clk *clk, unsigned long rate)
+{
+	u16 freqsel;
+	struct dpll_data *dd;
+
+	if (!clk || !rate)
+		return -EINVAL;
+
+	dd = clk->dpll_data;
+	if (!dd)
+		return -EINVAL;
+
+	if (rate == omap2_get_dpll_rate(clk))
+		return 0;
+
+	if (dd->last_rounded_rate != rate)
+		omap2_dpll_round_rate(clk, rate);
+
+	if (dd->last_rounded_rate == 0)
+		return -EINVAL;
+
+	freqsel = _omap3_dpll_compute_freqsel(clk, dd->last_rounded_n);
+	if (!freqsel)
+		WARN_ON(1);
+
+	omap3_noncore_dpll_program(clk, dd->last_rounded_m, dd->last_rounded_n,
+				   freqsel);
+
+	omap3_dpll_recalc(clk);
+
+	return 0;
+}
+
+/* DPLL autoidle read/set code */
+
+
 /**
  * omap3_dpll_autoidle_read - read a DPLL's autoidle bits
  * @clk: struct clk * of the DPLL to read
diff --git a/arch/arm/mach-omap2/clock34xx.h b/arch/arm/mach-omap2/clock34xx.h
index a826094..877b274 100644
--- a/arch/arm/mach-omap2/clock34xx.h
+++ b/arch/arm/mach-omap2/clock34xx.h
@@ -34,6 +34,7 @@ static void omap3_dpll_deny_idle(struct clk *clk);
 static u32 omap3_dpll_autoidle_read(struct clk *clk);
 static int omap3_noncore_dpll_enable(struct clk *clk);
 static void omap3_noncore_dpll_disable(struct clk *clk);
+static int omap3_noncore_dpll_set_rate(struct clk *clk, unsigned long rate);
 
 /* Maximum DPLL multiplier, divider values for OMAP3 */
 #define OMAP3_MAX_DPLL_MULT		2048
@@ -263,6 +264,7 @@ static struct dpll_data dpll1_dd = {
 	.mult_div1_reg	= OMAP_CM_REGADDR(MPU_MOD, OMAP3430_CM_CLKSEL1_PLL),
 	.mult_mask	= OMAP3430_MPU_DPLL_MULT_MASK,
 	.div1_mask	= OMAP3430_MPU_DPLL_DIV_MASK,
+	.freqsel_mask	= OMAP3430_MPU_DPLL_FREQSEL_MASK,
 	.control_reg	= OMAP_CM_REGADDR(MPU_MOD, OMAP3430_CM_CLKEN_PLL),
 	.enable_mask	= OMAP3430_EN_MPU_DPLL_MASK,
 	.modes		= (1 << DPLL_LOW_POWER_BYPASS) | (1 << DPLL_LOCKED),
@@ -284,6 +286,7 @@ static struct clk dpll1_ck = {
 	.dpll_data	= &dpll1_dd,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | ALWAYS_ENABLED,
 	.round_rate	= &omap2_dpll_round_rate,
+	.set_rate	= &omap3_noncore_dpll_set_rate,
 	.recalc		= &omap3_dpll_recalc,
 };
 
@@ -329,6 +332,7 @@ static struct dpll_data dpll2_dd = {
 	.mult_div1_reg	= OMAP_CM_REGADDR(OMAP3430_IVA2_MOD, OMAP3430_CM_CLKSEL1_PLL),
 	.mult_mask	= OMAP3430_IVA2_DPLL_MULT_MASK,
 	.div1_mask	= OMAP3430_IVA2_DPLL_DIV_MASK,
+	.freqsel_mask	= OMAP3430_IVA2_DPLL_FREQSEL_MASK,
 	.control_reg	= OMAP_CM_REGADDR(OMAP3430_IVA2_MOD, OMAP3430_CM_CLKEN_PLL),
 	.enable_mask	= OMAP3430_EN_IVA2_DPLL_MASK,
 	.modes		= (1 << DPLL_LOW_POWER_STOP) | (1 << DPLL_LOCKED) |
@@ -353,6 +357,7 @@ static struct clk dpll2_ck = {
 	.enable		= &omap3_noncore_dpll_enable,
 	.disable	= &omap3_noncore_dpll_disable,
 	.round_rate	= &omap2_dpll_round_rate,
+	.set_rate	= &omap3_noncore_dpll_set_rate,
 	.recalc		= &omap3_dpll_recalc,
 };
 
@@ -387,6 +392,7 @@ static struct dpll_data dpll3_dd = {
 	.mult_div1_reg	= OMAP_CM_REGADDR(PLL_MOD, CM_CLKSEL1),
 	.mult_mask	= OMAP3430_CORE_DPLL_MULT_MASK,
 	.div1_mask	= OMAP3430_CORE_DPLL_DIV_MASK,
+	.freqsel_mask	= OMAP3430_CORE_DPLL_FREQSEL_MASK,
 	.control_reg	= OMAP_CM_REGADDR(PLL_MOD, CM_CLKEN),
 	.enable_mask	= OMAP3430_EN_CORE_DPLL_MASK,
 	.auto_recal_bit	= OMAP3430_EN_CORE_DPLL_DRIFTGUARD_SHIFT,
@@ -565,6 +571,7 @@ static struct dpll_data dpll4_dd = {
 	.mult_div1_reg	= OMAP_CM_REGADDR(PLL_MOD, CM_CLKSEL2),
 	.mult_mask	= OMAP3430_PERIPH_DPLL_MULT_MASK,
 	.div1_mask	= OMAP3430_PERIPH_DPLL_DIV_MASK,
+	.freqsel_mask	= OMAP3430_PERIPH_DPLL_FREQSEL_MASK,
 	.control_reg	= OMAP_CM_REGADDR(PLL_MOD, CM_CLKEN),
 	.enable_mask	= OMAP3430_EN_PERIPH_DPLL_MASK,
 	.modes		= (1 << DPLL_LOW_POWER_STOP) | (1 << DPLL_LOCKED),
@@ -588,6 +595,7 @@ static struct clk dpll4_ck = {
 	.enable		= &omap3_noncore_dpll_enable,
 	.disable	= &omap3_noncore_dpll_disable,
 	.round_rate	= &omap2_dpll_round_rate,
+	.set_rate	= &omap3_noncore_dpll_set_rate,
 	.recalc		= &omap3_dpll_recalc,
 };
 
@@ -867,6 +875,7 @@ static struct dpll_data dpll5_dd = {
 	.mult_div1_reg	= OMAP_CM_REGADDR(PLL_MOD, OMAP3430ES2_CM_CLKSEL4),
 	.mult_mask	= OMAP3430ES2_PERIPH2_DPLL_MULT_MASK,
 	.div1_mask	= OMAP3430ES2_PERIPH2_DPLL_DIV_MASK,
+	.freqsel_mask	= OMAP3430ES2_PERIPH2_DPLL_FREQSEL_MASK,
 	.control_reg	= OMAP_CM_REGADDR(PLL_MOD, OMAP3430ES2_CM_CLKEN2),
 	.enable_mask	= OMAP3430ES2_EN_PERIPH2_DPLL_MASK,
 	.modes		= (1 << DPLL_LOW_POWER_STOP) | (1 << DPLL_LOCKED),
@@ -890,6 +899,7 @@ static struct clk dpll5_ck = {
 	.enable		= &omap3_noncore_dpll_enable,
 	.disable	= &omap3_noncore_dpll_disable,
 	.round_rate	= &omap2_dpll_round_rate,
+	.set_rate	= &omap3_noncore_dpll_set_rate,
 	.recalc		= &omap3_dpll_recalc,
 };
 
diff --git a/arch/arm/plat-omap/include/mach/clock.h b/arch/arm/plat-omap/include/mach/clock.h
index 7192985..85a88ad 100644
--- a/arch/arm/plat-omap/include/mach/clock.h
+++ b/arch/arm/plat-omap/include/mach/clock.h
@@ -42,6 +42,7 @@ struct dpll_data {
 	u8			max_divider;
 	u32			max_tolerance;
 #  if defined(CONFIG_ARCH_OMAP3)
+	u32			freqsel_mask;
 	u8			modes;
 	void __iomem		*control_reg;
 	u32			enable_mask;


