Return-Path: <linux-kernel-owner+w=401wt.eu-S1754790AbZBCNSf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790AbZBCNSf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 08:18:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751523AbZBCNS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 08:18:26 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52305 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbZBCNSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 08:18:25 -0500
Date: Tue, 3 Feb 2009 13:18:14 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Paul Walmsley <paul@pwsan.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH E 08/14] OMAP clock: move rate recalc, propagation code up to plat-omap/clock.c
Message-ID: <20090203131814.GA9840@n2100.arm.linux.org.uk>
References: <20090128192551.29333.82943.stgit@localhost.localdomain> <20090128192748.29333.5856.stgit@localhost.localdomain> <20090129174153.GH18233@n2100.arm.linux.org.uk> <alpine.DEB.2.00.0901300135560.26985@utopia.booyaka.com> <alpine.DEB.2.00.0902012355320.888@utopia.booyaka.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0902012355320.888@utopia.booyaka.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 02, 2009 at 12:13:02AM -0700, Paul Walmsley wrote:
> Based on a comparison of E 08 with the three omap-clks1 commits you 
> mentioned above, here are some differences that would merit further 
> attention.  Some of these you've mentioned in subsequent E-mails.
> 
> If you use your patches, I would suggest making the following changes:
> 
> 1. "remove unnecessary calls to propagate_rate()" should keep the 
> propagate_rate(&ck_dpll1) call in omap1_select_table_rate(), since this 
> function is only used by struct clk virtual_clk_mpu.  virtual_clk_mpu is 
> farther away from the root of the clock tree than struct clk ck_dpll1.

Yes, that's the bug I was talking about in previous mails.  Hence the
follow up questions on why this clock exists.

> 2. In plat-omap2/clock.c, clk_set_rate() and clk_set_parent() should call 
> propagate_rate() after recalc.

If you look at "[ARM] omap: move clock propagation into core omap clock code"
you'll see this is already done after the respective methods are called.
However, in that patch it doesn't call the recalc method; that's a
separate change (see below).

> 3. Several internal calls to *_recalc() functions can be dropped - 
> specifically, in omap2_reprogram_dpllcore(), omap2_select_table_rate(), 
> omap3_noncore_dpll_set_rate(), and omap3_core_dpll_m2_set_rate().

That's what I extracted from and merged as E8:

2d0c7f5596e021f7065511b433d16dd081915a24
diff --git a/arch/arm/mach-omap2/clock24xx.c b/arch/arm/mach-omap2/clock24xx.c
index 2ce8c02..4564ae3 100644
--- a/arch/arm/mach-omap2/clock24xx.c
+++ b/arch/arm/mach-omap2/clock24xx.c
@@ -441,7 +441,6 @@ static int omap2_reprogram_dpllcore(struct clk *clk, unsigned long rate)
 		omap2xxx_sdrc_init_params(omap2xxx_sdrc_dll_is_unlocked());
 		omap2xxx_sdrc_reprogram(done_rate, 0);
 	}
-	omap2_dpllcore_recalc(&dpll_ck);
 	ret = 0;
 
 dpll_exit:
@@ -570,7 +569,6 @@ static int omap2_select_table_rate(struct clk *clk, unsigned long rate)
 
 		local_irq_restore(flags);
 	}
-	omap2_dpllcore_recalc(&dpll_ck);
 
 	return 0;
 }
diff --git a/arch/arm/mach-omap2/clock34xx.c b/arch/arm/mach-omap2/clock34xx.c
index 06a81fe..75eb254 100644
--- a/arch/arm/mach-omap2/clock34xx.c
+++ b/arch/arm/mach-omap2/clock34xx.c
@@ -614,8 +614,6 @@ static int omap3_noncore_dpll_set_rate(struct clk *clk, unsigned long rate)
 	omap3_noncore_dpll_program(clk, dd->last_rounded_m, dd->last_rounded_n,
 				   freqsel);
 
-	omap3_dpll_recalc(clk);
-
 	return 0;
 }
 
@@ -693,8 +691,6 @@ static int omap3_core_dpll_m2_set_rate(struct clk *clk, unsigned long rate)
 				  sp->actim_ctrlb, new_div);
 	local_irq_enable();
 
-	omap2_clksel_recalc(clk);
-
 	return 0;
 }
 
diff --git a/arch/arm/plat-omap/clock.c b/arch/arm/plat-omap/clock.c
index 794849b..a166e2a 100644
--- a/arch/arm/plat-omap/clock.c
+++ b/arch/arm/plat-omap/clock.c
@@ -140,8 +140,12 @@ int clk_set_rate(struct clk *clk, unsigned long rate)
 	spin_lock_irqsave(&clockfw_lock, flags);
 	if (arch_clock->clk_set_rate)
 		ret = arch_clock->clk_set_rate(clk, rate);
-	if (ret == 0 && (clk->flags & RATE_PROPAGATES))
-		propagate_rate(clk);
+	if (ret == 0) {
+		if (clk->recalc)
+			clk->recalc(clk);
+		if (clk->flags & RATE_PROPAGATES)
+			propagate_rate(clk);
+	}
 	spin_unlock_irqrestore(&clockfw_lock, flags);
 
 	return ret;
@@ -159,8 +163,12 @@ int clk_set_parent(struct clk *clk, struct clk *parent)
 	spin_lock_irqsave(&clockfw_lock, flags);
 	if (arch_clock->clk_set_parent)
 		ret = arch_clock->clk_set_parent(clk, parent);
-	if (ret == 0 && (clk->flags & RATE_PROPAGATES))
-		propagate_rate(clk);
+	if (ret == 0) {
+		if (clk->recalc)
+			clk->recalc(clk);
+		if (clk->flags & RATE_PROPAGATES)
+			propagate_rate(clk);
+	}
 	spin_unlock_irqrestore(&clockfw_lock, flags);
 
 	return ret;
@@ -211,7 +219,7 @@ void propagate_rate(struct clk * tclk)
 	list_for_each_entry(clkp, &clocks, node) {
 		if (likely(clkp->parent != tclk))
 			continue;
-		if (likely((u32)clkp->recalc)) {
+		if (clkp->recalc) {
 			unsigned long old_rate = clkp->rate;
 			clkp->recalc(clkp);
 			if (clkp->rate != old_rate &&

