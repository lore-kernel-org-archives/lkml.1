Return-Path: <linux-kernel-owner+w=401wt.eu-S1757500AbZA1UfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757500AbZA1UfQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 15:35:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755392AbZA1U32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:29:28 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:32899 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454AbZA1U3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:29:23 -0500
MBOX-Line: From nobody Wed Jan 28 12:27:51 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH E 08/14] OMAP clock: move rate recalc,
	propagation code up to plat-omap/clock.c
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, Paul Walmsley <paul@pwsan.com>,
       Tony Lindgren <tony@atomide.com>
Date: Wed, 28 Jan 2009 12:27:51 -0700
Message-ID: <20090128192748.29333.5856.stgit@localhost.localdomain>
In-Reply-To: <20090128192551.29333.82943.stgit@localhost.localdomain>
References: <20090128192551.29333.82943.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously the individual clock recalculation functions handled their
own rate recalculation.  This can be handled in the clk_set_rate(),
clk_set_parent(), and recalculate_root_clocks() functions in
plat-omap/clock.c.  Removes duplicate code and clarifies the role of the
recalc functions.

linux-omap source commit is b66c1baa9f8e60213457414976575e6265217a70.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap1/clock.c     |   14 --------------
 arch/arm/mach-omap2/clock.c     |   12 ------------
 arch/arm/mach-omap2/clock24xx.c |    6 ------
 arch/arm/mach-omap2/clock34xx.c |    9 ---------
 arch/arm/plat-omap/clock.c      |   34 +++++++++++++++++++++++++++-------
 5 files changed, 27 insertions(+), 48 deletions(-)

diff --git a/arch/arm/mach-omap1/clock.c b/arch/arm/mach-omap1/clock.c
index 4d0c444..ae2b304 100644
--- a/arch/arm/mach-omap1/clock.c
+++ b/arch/arm/mach-omap1/clock.c
@@ -225,9 +225,6 @@ static void omap1_ckctl_recalc(struct clk * clk)
 	if (unlikely(clk->rate == clk->parent->rate / dsor))
 		return; /* No change, quick exit */
 	clk->rate = clk->parent->rate / dsor;
-
-	if (unlikely(clk->flags & RATE_PROPAGATES))
-		propagate_rate(clk);
 }
 
 static void omap1_ckctl_recalc_dsp_domain(struct clk * clk)
@@ -248,9 +245,6 @@ static void omap1_ckctl_recalc_dsp_domain(struct clk * clk)
 	if (unlikely(clk->rate == clk->parent->rate / dsor))
 		return; /* No change, quick exit */
 	clk->rate = clk->parent->rate / dsor;
-
-	if (unlikely(clk->flags & RATE_PROPAGATES))
-		propagate_rate(clk);
 }
 
 /* MPU virtual clock functions */
@@ -314,9 +308,6 @@ static int omap1_clk_set_rate_dsp_domain(struct clk *clk, unsigned long rate)
 		ret = 0;
 	}
 
-	if (unlikely(ret == 0 && (clk->flags & RATE_PROPAGATES)))
-		propagate_rate(clk);
-
 	return ret;
 }
 
@@ -423,8 +414,6 @@ static int omap1_set_sossi_rate(struct clk *clk, unsigned long rate)
 	omap_writel(l, MOD_CONF_CTRL_1);
 
 	clk->rate = p_rate / (div + 1);
-	if (unlikely(clk->flags & RATE_PROPAGATES))
-		propagate_rate(clk);
 
 	return 0;
 }
@@ -583,9 +572,6 @@ static int omap1_clk_set_rate(struct clk *clk, unsigned long rate)
 		ret = 0;
 	}
 
-	if (unlikely(ret == 0 && (clk->flags & RATE_PROPAGATES)))
-		propagate_rate(clk);
-
 	return ret;
 }
 
diff --git a/arch/arm/mach-omap2/clock.c b/arch/arm/mach-omap2/clock.c
index d4d2e7b..4a72535 100644
--- a/arch/arm/mach-omap2/clock.c
+++ b/arch/arm/mach-omap2/clock.c
@@ -300,9 +300,6 @@ void omap2_fixed_divisor_recalc(struct clk *clk)
 	WARN_ON(!clk->fixed_div);
 
 	clk->rate = clk->parent->rate / clk->fixed_div;
-
-	if (clk->flags & RATE_PROPAGATES)
-		propagate_rate(clk);
 }
 
 /**
@@ -504,9 +501,6 @@ void omap2_clksel_recalc(struct clk *clk)
 	clk->rate = clk->parent->rate / div;
 
 	pr_debug("clock: new clock rate is %ld (div %d)\n", clk->rate, div);
-
-	if (clk->flags & RATE_PROPAGATES)
-		propagate_rate(clk);
 }
 
 /**
@@ -777,9 +771,6 @@ int omap2_clk_set_rate(struct clk *clk, unsigned long rate)
 	if (clk->set_rate)
 		ret = clk->set_rate(clk, rate);
 
-	if (ret == 0 && (clk->flags & RATE_PROPAGATES))
-		propagate_rate(clk);
-
 	return ret;
 }
 
@@ -861,9 +852,6 @@ int omap2_clk_set_parent(struct clk *clk, struct clk *new_parent)
 	pr_debug("clock: set parent of %s to %s (new rate %ld)\n",
 		 clk->name, clk->parent->name, clk->rate);
 
-	if (clk->flags & RATE_PROPAGATES)
-		propagate_rate(clk);
-
 	return 0;
 }
 
diff --git a/arch/arm/mach-omap2/clock24xx.c b/arch/arm/mach-omap2/clock24xx.c
index 3727a73..57cd85b 100644
--- a/arch/arm/mach-omap2/clock24xx.c
+++ b/arch/arm/mach-omap2/clock24xx.c
@@ -179,8 +179,6 @@ static long omap2_dpllcore_round_rate(unsigned long target_rate)
 static void omap2_dpllcore_recalc(struct clk *clk)
 {
 	clk->rate = omap2xxx_clk_get_core_rate(clk);
-
-	propagate_rate(clk);
 }
 
 static int omap2_reprogram_dpllcore(struct clk *clk, unsigned long rate)
@@ -251,7 +249,6 @@ static int omap2_reprogram_dpllcore(struct clk *clk, unsigned long rate)
 		omap2xxx_sdrc_init_params(omap2xxx_sdrc_dll_is_unlocked());
 		omap2xxx_sdrc_reprogram(done_rate, 0);
 	}
-	omap2_dpllcore_recalc(&dpll_ck);
 	ret = 0;
 
 dpll_exit:
@@ -380,7 +377,6 @@ static int omap2_select_table_rate(struct clk *clk, unsigned long rate)
 
 		local_irq_restore(flags);
 	}
-	omap2_dpllcore_recalc(&dpll_ck);
 
 	return 0;
 }
@@ -470,13 +466,11 @@ static u32 omap2_get_sysclkdiv(void)
 static void omap2_osc_clk_recalc(struct clk *clk)
 {
 	clk->rate = omap2_get_apll_clkin() * omap2_get_sysclkdiv();
-	propagate_rate(clk);
 }
 
 static void omap2_sys_clk_recalc(struct clk *clk)
 {
 	clk->rate = clk->parent->rate / omap2_get_sysclkdiv();
-	propagate_rate(clk);
 }
 
 /*
diff --git a/arch/arm/mach-omap2/clock34xx.c b/arch/arm/mach-omap2/clock34xx.c
index 738a029..22cbcce 100644
--- a/arch/arm/mach-omap2/clock34xx.c
+++ b/arch/arm/mach-omap2/clock34xx.c
@@ -54,8 +54,6 @@
 static void omap3_dpll_recalc(struct clk *clk)
 {
 	clk->rate = omap2_get_dpll_rate(clk);
-
-	propagate_rate(clk);
 }
 
 /* _omap3_dpll_write_clken - write clken_bits arg to a DPLL's enable bits */
@@ -429,8 +427,6 @@ static int omap3_noncore_dpll_set_rate(struct clk *clk, unsigned long rate)
 
 	}
 
-	omap3_dpll_recalc(clk);
-
 	return 0;
 }
 
@@ -493,8 +489,6 @@ static int omap3_core_dpll_m2_set_rate(struct clk *clk, unsigned long rate)
 				  sp->actim_ctrlb, new_div);
 	local_irq_enable();
 
-	omap2_clksel_recalc(clk);
-
 	return 0;
 }
 
@@ -612,9 +606,6 @@ static void omap3_clkoutx2_recalc(struct clk *clk)
 		clk->rate = clk->parent->rate;
 	else
 		clk->rate = clk->parent->rate * 2;
-
-	if (clk->flags & RATE_PROPAGATES)
-		propagate_rate(clk);
 }
 
 /* Common clock code */
diff --git a/arch/arm/plat-omap/clock.c b/arch/arm/plat-omap/clock.c
index be6aab9..c60548a 100644
--- a/arch/arm/plat-omap/clock.c
+++ b/arch/arm/plat-omap/clock.c
@@ -183,8 +183,16 @@ int clk_set_rate(struct clk *clk, unsigned long rate)
 		return ret;
 
 	spin_lock_irqsave(&clockfw_lock, flags);
-	if (arch_clock->clk_set_rate)
+
+	if (arch_clock->clk_set_rate) {
 		ret = arch_clock->clk_set_rate(clk, rate);
+		if (ret == 0) {
+			(*clk->recalc)(clk);
+			if (clk->flags & RATE_PROPAGATES)
+				propagate_rate(clk);
+		}
+	}
+
 	spin_unlock_irqrestore(&clockfw_lock, flags);
 
 	return ret;
@@ -200,8 +208,16 @@ int clk_set_parent(struct clk *clk, struct clk *parent)
 		return ret;
 
 	spin_lock_irqsave(&clockfw_lock, flags);
-	if (arch_clock->clk_set_parent)
-		ret =  arch_clock->clk_set_parent(clk, parent);
+
+	if (arch_clock->clk_set_parent) {
+		ret = arch_clock->clk_set_parent(clk, parent);
+		if (ret == 0) {
+			(*clk->recalc)(clk);
+			if (clk->flags & RATE_PROPAGATES)
+				propagate_rate(clk);
+		}
+	}
+
 	spin_unlock_irqrestore(&clockfw_lock, flags);
 
 	return ret;
@@ -256,8 +272,6 @@ void followparent_recalc(struct clk *clk)
 		return;
 
 	clk->rate = clk->parent->rate;
-	if (unlikely(clk->flags & RATE_PROPAGATES))
-		propagate_rate(clk);
 }
 
 /* Propagate rate to children */
@@ -271,8 +285,11 @@ void propagate_rate(struct clk * tclk)
 	list_for_each_entry(clkp, &clocks, node) {
 		if (likely(clkp->parent != tclk))
 			continue;
-		if (likely((u32)clkp->recalc))
+		if (likely((u32)clkp->recalc)) {
 			clkp->recalc(clkp);
+			if (clkp->flags & RATE_PROPAGATES)
+				propagate_rate(clkp);
+		}
 	}
 }
 
@@ -288,8 +305,11 @@ void recalculate_root_clocks(void)
 	struct clk *clkp;
 
 	list_for_each_entry(clkp, &clocks, node) {
-		if (unlikely(!clkp->parent) && likely((u32)clkp->recalc))
+		if (unlikely(!clkp->parent) && likely((u32)clkp->recalc)) {
 			clkp->recalc(clkp);
+			if (clkp->flags & RATE_PROPAGATES)
+				propagate_rate(clkp);
+		}
 	}
 }
 


