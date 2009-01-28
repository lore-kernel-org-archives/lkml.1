Return-Path: <linux-kernel-owner+w=401wt.eu-S1757410AbZA1Uew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410AbZA1Uew (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 15:34:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755382AbZA1U30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:29:26 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:32891 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037AbZA1U3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:29:22 -0500
MBOX-Line: From nobody Wed Jan 28 12:27:42 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH E 05/14] OMAP3 clock: add omap3_core_dpll_m2_set_rate()
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, Paul Walmsley <paul@pwsan.com>,
       Tony Lindgren <tony@atomide.com>
Date: Wed, 28 Jan 2009 12:27:42 -0700
Message-ID: <20090128192739.29333.84278.stgit@localhost.localdomain>
In-Reply-To: <20090128192551.29333.82943.stgit@localhost.localdomain>
References: <20090128192551.29333.82943.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the omap3_core_dpll_m2_set_rate() function to the OMAP3 clock code,
which calls into the SRAM function omap3_sram_configure_core_dpll() to
change the CORE DPLL M2 divider.  (SRAM code is necessary since rate changes
on clocks upstream from the SDRC can glitch SDRAM accesses.)

Use this function for the set_rate function pointer in the dpll3_m2_ck
struct clk.  With this function in place, PM/OPP code should be able to
alter SDRAM speed via code similar to:

      clk_set_rate(&dpll3_m2_ck, target_rate).

linux-omap source commit is 7f8b2b0f4fe52238c67d79dedcd2794dcef4dddd.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/clock34xx.c |   65 +++++++++++++++++++++++++++++++++++++++
 arch/arm/mach-omap2/clock34xx.h |    9 ++---
 2 files changed, 69 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-omap2/clock34xx.c b/arch/arm/mach-omap2/clock34xx.c
index 3dba9ca..2c655be 100644
--- a/arch/arm/mach-omap2/clock34xx.c
+++ b/arch/arm/mach-omap2/clock34xx.c
@@ -434,6 +434,71 @@ static int omap3_noncore_dpll_set_rate(struct clk *clk, unsigned long rate)
 	return 0;
 }
 
+
+/*
+ * CORE DPLL (DPLL3) rate programming functions
+ *
+ * These call into SRAM code to do the actual CM writes, since the SDRAM
+ * is clocked from DPLL3.
+ */
+
+/**
+ * omap3_core_dpll_m2_set_rate - set CORE DPLL M2 divider
+ * @clk: struct clk * of DPLL to set
+ * @rate: rounded target rate
+ *
+ * Program the DPLL M2 divider with the rounded target rate.  Returns
+ * -EINVAL upon error, or 0 upon success.
+ */
+static int omap3_core_dpll_m2_set_rate(struct clk *clk, unsigned long rate)
+{
+	u32 new_div = 0;
+	unsigned long validrate, sdrcrate;
+	struct omap_sdrc_params *sp;
+
+	if (!clk || !rate)
+		return -EINVAL;
+
+	if (clk != &dpll3_m2_ck)
+		return -EINVAL;
+
+	if (rate == clk->rate)
+		return 0;
+
+	validrate = omap2_clksel_round_rate_div(clk, rate, &new_div);
+	if (validrate != rate)
+		return -EINVAL;
+
+	sdrcrate = sdrc_ick.rate;
+	if (rate > clk->rate)
+		sdrcrate <<= ((rate / clk->rate) - 1);
+	else
+		sdrcrate >>= ((clk->rate / rate) - 1);
+
+	sp = omap2_sdrc_get_params(sdrcrate);
+	if (!sp)
+		return -EINVAL;
+
+	pr_info("clock: changing CORE DPLL rate from %lu to %lu\n", clk->rate,
+		validrate);
+	pr_info("clock: SDRC timing params used: %08x %08x %08x\n",
+		sp->rfr_ctrl, sp->actim_ctrla, sp->actim_ctrlb);
+
+	/* REVISIT: SRAM code doesn't support other M2 divisors yet */
+	WARN_ON(new_div != 1 && new_div != 2);
+
+	/* REVISIT: Add SDRC_MR changing to this code also */
+	local_irq_disable();
+	omap3_configure_core_dpll(sp->rfr_ctrl, sp->actim_ctrla,
+				  sp->actim_ctrlb, new_div);
+	local_irq_enable();
+
+	omap2_clksel_recalc(clk);
+
+	return 0;
+}
+
+
 /* DPLL autoidle read/set code */
 
 
diff --git a/arch/arm/mach-omap2/clock34xx.h b/arch/arm/mach-omap2/clock34xx.h
index 70a1532..5357507 100644
--- a/arch/arm/mach-omap2/clock34xx.h
+++ b/arch/arm/mach-omap2/clock34xx.h
@@ -35,6 +35,7 @@ static u32 omap3_dpll_autoidle_read(struct clk *clk);
 static int omap3_noncore_dpll_enable(struct clk *clk);
 static void omap3_noncore_dpll_disable(struct clk *clk);
 static int omap3_noncore_dpll_set_rate(struct clk *clk, unsigned long rate);
+static int omap3_core_dpll_m2_set_rate(struct clk *clk, unsigned long rate);
 
 /* Maximum DPLL multiplier, divider values for OMAP3 */
 #define OMAP3_MAX_DPLL_MULT		2048
@@ -499,11 +500,7 @@ static const struct clksel div31_dpll3m2_clksel[] = {
 	{ .parent = NULL }
 };
 
-/*
- * DPLL3 output M2
- * REVISIT: This DPLL output divider must be changed in SRAM, so until
- * that code is ready, this should remain a 'read-only' clksel clock.
- */
+/* DPLL3 output M2 - primary control point for CORE speed */
 static struct clk dpll3_m2_ck = {
 	.name		= "dpll3_m2_ck",
 	.parent		= &dpll3_ck,
@@ -515,6 +512,8 @@ static struct clk dpll3_m2_ck = {
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
 				PARENT_CONTROLS_CLOCK,
 	.clkdm		= { .name = "dpll3_clkdm" },
+	.round_rate	= &omap2_clksel_round_rate,
+	.set_rate	= &omap3_core_dpll_m2_set_rate,
 	.recalc		= &omap2_clksel_recalc,
 };
 


