Return-Path: <linux-kernel-owner+w=401wt.eu-S1758356AbZA1U4H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758356AbZA1U4H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 15:56:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756800AbZA1UdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:33:23 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:47913 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756786AbZA1UdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:33:20 -0500
MBOX-Line: From nobody Wed Jan 28 12:08:44 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH C 12/13] OMAP3 clock: avoid invalid FREQSEL values during DPLL
	rate rounding
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, Paul Walmsley <paul@pwsan.com>,
       Peter de Schrijver <peter.de-schrijver@nokia.com>,
       Tony Lindgren <tony@atomide.com>
Date: Wed, 28 Jan 2009 12:08:44 -0700
Message-ID: <20090128190841.12092.9678.stgit@localhost.localdomain>
In-Reply-To: <20090128190724.12092.22239.stgit@localhost.localdomain>
References: <20090128190724.12092.22239.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DPLL FREQSEL jitter correction bits are set based on a table in
the 34xx TRM, Table 4-38, according to the DPLL's internal clock
frequency "Fint."  Several Fint frequency ranges are missing from this
table.  Previously, we allowed these Fint frequency ranges to be
selected in the rate rounding code, but did not change the FREQSEL bits.
Correspondence with the OMAP hardware team indicates that Fint values
not in the table should not be used.  So, prevent them from being
selected during DPLL rate rounding.  This removes warnings and also
can prevent the chip from locking up.

The first pass through the rate rounding code will update the DPLL max
and min dividers appropriately, so later rate rounding passes will run
faster than the first.

Peter de Schrijver <peter.de-schrijver@nokia.com> put up with several
test cycles of this patch - thanks Peter.

linux-omap source commit is f9c1b82f55b60fc39eaa6e7aa1fbe380c0ffe2e9.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Cc: Peter de Schrijver <peter.de-schrijver@nokia.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/clock.c             |   67 ++++++++++++++++++++++++++++++-
 arch/arm/mach-omap2/clock24xx.h         |    1 
 arch/arm/mach-omap2/clock34xx.h         |    5 ++
 arch/arm/plat-omap/include/mach/clock.h |    1 
 4 files changed, 72 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap2/clock.c b/arch/arm/mach-omap2/clock.c
index cd13972..e57694f 100644
--- a/arch/arm/mach-omap2/clock.c
+++ b/arch/arm/mach-omap2/clock.c
@@ -59,12 +59,68 @@
 #define DPLL_ROUNDING_VAL		((DPLL_SCALE_BASE / 2) * \
 					 (DPLL_SCALE_FACTOR / DPLL_SCALE_BASE))
 
+/* DPLL valid Fint frequency band limits - from 34xx TRM Section 4.7.6.2 */
+#define DPLL_FINT_BAND1_MIN		750000
+#define DPLL_FINT_BAND1_MAX		2100000
+#define DPLL_FINT_BAND2_MIN		7500000
+#define DPLL_FINT_BAND2_MAX		21000000
+
+/* _dpll_test_fint() return codes */
+#define DPLL_FINT_UNDERFLOW		-1
+#define DPLL_FINT_INVALID		-2
+
 u8 cpu_mask;
 
 /*-------------------------------------------------------------------------
  * OMAP2/3 specific clock functions
  *-------------------------------------------------------------------------*/
 
+/*
+ * _dpll_test_fint - test whether an Fint value is valid for the DPLL
+ * @clk: DPLL struct clk to test
+ * @n: divider value (N) to test
+ *
+ * Tests whether a particular divider @n will result in a valid DPLL
+ * internal clock frequency Fint. See the 34xx TRM 4.7.6.2 "DPLL Jitter
+ * Correction".  Returns 0 if OK, -1 if the enclosing loop can terminate
+ * (assuming that it is counting N upwards), or -2 if the enclosing loop
+ * should skip to the next iteration (again assuming N is increasing).
+ */
+static int _dpll_test_fint(struct clk *clk, u8 n)
+{
+	struct dpll_data *dd;
+	long fint;
+	int ret = 0;
+
+	dd = clk->dpll_data;
+
+	/* DPLL divider must result in a valid jitter correction val */
+	fint = clk->parent->rate / (n + 1);
+	if (fint < DPLL_FINT_BAND1_MIN) {
+
+		pr_debug("rejecting n=%d due to Fint failure, "
+			 "lowering max_divider\n", n);
+		dd->max_divider = n;
+		ret = DPLL_FINT_UNDERFLOW;
+
+	} else if (fint > DPLL_FINT_BAND1_MAX &&
+		   fint < DPLL_FINT_BAND2_MIN) {
+
+		pr_debug("rejecting n=%d due to Fint failure\n", n);
+		ret = DPLL_FINT_INVALID;
+
+	} else if (fint > DPLL_FINT_BAND2_MAX) {
+
+		pr_debug("rejecting n=%d due to Fint failure, "
+			 "boosting min_divider\n", n);
+		dd->min_divider = n;
+		ret = DPLL_FINT_INVALID;
+
+	}
+
+	return ret;
+}
+
 /**
  * omap2_init_clk_clkdm - look up a clockdomain name, store pointer in clk
  * @clk: OMAP clock struct ptr to use
@@ -940,7 +996,14 @@ long omap2_dpll_round_rate(struct clk *clk, unsigned long target_rate)
 
 	dd->last_rounded_rate = 0;
 
-	for (n = DPLL_MIN_DIVIDER; n <= dd->max_divider; n++) {
+	for (n = dd->min_divider; n <= dd->max_divider; n++) {
+
+		/* Is the (input clk, divider) pair valid for the DPLL? */
+		r = _dpll_test_fint(clk, n);
+		if (r == DPLL_FINT_UNDERFLOW)
+			break;
+		else if (r == DPLL_FINT_INVALID)
+			continue;
 
 		/* Compute the scaled DPLL multiplier, based on the divider */
 		m = scaled_rt_rp * n;
@@ -974,7 +1037,7 @@ long omap2_dpll_round_rate(struct clk *clk, unsigned long target_rate)
 			pr_debug("clock: found new least error %d\n", min_e);
 
 			/* We found good settings -- bail out now */
-			if (min_e <= clk->dpll_data->rate_tolerance)
+			if (min_e <= dd->rate_tolerance)
 				break;
 		}
 	}
diff --git a/arch/arm/mach-omap2/clock24xx.h b/arch/arm/mach-omap2/clock24xx.h
index f6177e3..8de312a 100644
--- a/arch/arm/mach-omap2/clock24xx.h
+++ b/arch/arm/mach-omap2/clock24xx.h
@@ -683,6 +683,7 @@ static struct dpll_data dpll_dd = {
 	.control_reg		= _CM_REG_OFFSET(PLL_MOD, CM_CLKEN),
 	.enable_mask		= OMAP24XX_EN_DPLL_MASK,
 	.max_multiplier		= 1024,
+	.min_divider		= 1,
 	.max_divider		= 16,
 	.rate_tolerance		= DEFAULT_DPLL_RATE_TOLERANCE
 };
diff --git a/arch/arm/mach-omap2/clock34xx.h b/arch/arm/mach-omap2/clock34xx.h
index 0c50a2d..00ac92f 100644
--- a/arch/arm/mach-omap2/clock34xx.h
+++ b/arch/arm/mach-omap2/clock34xx.h
@@ -300,6 +300,7 @@ static struct dpll_data dpll1_dd = {
 	.idlest_mask	= OMAP3430_ST_MPU_CLK_MASK,
 	.bypass_clk	= &dpll1_fck,
 	.max_multiplier = OMAP3_MAX_DPLL_MULT,
+	.min_divider	= 1,
 	.max_divider	= OMAP3_MAX_DPLL_DIV,
 	.rate_tolerance = DEFAULT_DPLL_RATE_TOLERANCE
 };
@@ -373,6 +374,7 @@ static struct dpll_data dpll2_dd = {
 	.idlest_mask	= OMAP3430_ST_IVA2_CLK_MASK,
 	.bypass_clk	= &dpll2_fck,
 	.max_multiplier = OMAP3_MAX_DPLL_MULT,
+	.min_divider	= 1,
 	.max_divider	= OMAP3_MAX_DPLL_DIV,
 	.rate_tolerance = DEFAULT_DPLL_RATE_TOLERANCE
 };
@@ -434,6 +436,7 @@ static struct dpll_data dpll3_dd = {
 	.idlest_mask	= OMAP3430_ST_CORE_CLK_MASK,
 	.bypass_clk	= &sys_ck,
 	.max_multiplier = OMAP3_MAX_DPLL_MULT,
+	.min_divider	= 1,
 	.max_divider	= OMAP3_MAX_DPLL_DIV,
 	.rate_tolerance = DEFAULT_DPLL_RATE_TOLERANCE
 };
@@ -597,6 +600,7 @@ static struct dpll_data dpll4_dd = {
 	.idlest_mask	= OMAP3430_ST_PERIPH_CLK_MASK,
 	.bypass_clk	= &sys_ck,
 	.max_multiplier = OMAP3_MAX_DPLL_MULT,
+	.min_divider	= 1,
 	.max_divider	= OMAP3_MAX_DPLL_DIV,
 	.rate_tolerance = DEFAULT_DPLL_RATE_TOLERANCE
 };
@@ -911,6 +915,7 @@ static struct dpll_data dpll5_dd = {
 	.idlest_mask	= OMAP3430ES2_ST_PERIPH2_CLK_MASK,
 	.bypass_clk	= &sys_ck,
 	.max_multiplier = OMAP3_MAX_DPLL_MULT,
+	.min_divider	= 1,
 	.max_divider	= OMAP3_MAX_DPLL_DIV,
 	.rate_tolerance = DEFAULT_DPLL_RATE_TOLERANCE
 };
diff --git a/arch/arm/plat-omap/include/mach/clock.h b/arch/arm/plat-omap/include/mach/clock.h
index 73676ee..f6adf39 100644
--- a/arch/arm/plat-omap/include/mach/clock.h
+++ b/arch/arm/plat-omap/include/mach/clock.h
@@ -39,6 +39,7 @@ struct dpll_data {
 	unsigned long		last_rounded_rate;
 	unsigned int		rate_tolerance;
 	u16			max_multiplier;
+	u8			min_divider;
 	u8			max_divider;
 	u32			max_tolerance;
 	struct clk		*bypass_clk;


