Return-Path: <linux-kernel-owner+w=401wt.eu-S1760868AbZA1Uuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760868AbZA1Uuf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 15:50:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755097AbZA1UcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:32:24 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:47856 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756516AbZA1UcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:32:20 -0500
MBOX-Line: From nobody Wed Jan 28 12:35:31 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH F 11/12] OMAP2/3 clock: don't tinker with hardirqs when they
	are supposed to be disabled
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, Paul Walmsley <paul@pwsan.com>,
       Tony Lindgren <tony@atomide.com>
Date: Wed, 28 Jan 2009 12:35:31 -0700
Message-ID: <20090128193528.2396.10870.stgit@localhost.localdomain>
In-Reply-To: <20090128193326.2396.9437.stgit@localhost.localdomain>
References: <20090128193326.2396.9437.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clock rate change code executes inside a spinlock with hardirqs
disabled.  The only code that should be messing around with the
hardirq state should be the plat-omap/clock.c code.  In the
omap2_reprogram_dpllcore() case, this probably just wastes cycles, but
in the omap3_core_dpll_m2_set_rate() case, this is a nasty bug.

linux-omap source commit is b9b6208dadb5e0d8b290900a3ffa911673ca97ed.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/clock24xx.c |   12 +++---------
 arch/arm/mach-omap2/clock34xx.c |    2 --
 2 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/arch/arm/mach-omap2/clock24xx.c b/arch/arm/mach-omap2/clock24xx.c
index c24c937..1947ffa 100644
--- a/arch/arm/mach-omap2/clock24xx.c
+++ b/arch/arm/mach-omap2/clock24xx.c
@@ -221,10 +221,7 @@ static int omap2_reprogram_dpllcore(struct clk *clk, unsigned long rate)
 	u32 bypass = 0;
 	struct prcm_config tmpset;
 	const struct dpll_data *dd;
-	unsigned long flags;
-	int ret = -EINVAL;
 
-	local_irq_save(flags);
 	cur_rate = omap2xxx_clk_get_core_rate(&dpll_ck, dpll_ck.parent->rate);
 	mult = cm_read_mod_reg(PLL_MOD, CM_CLKSEL2);
 	mult &= OMAP24XX_CORE_CLK_SRC_MASK;
@@ -236,7 +233,7 @@ static int omap2_reprogram_dpllcore(struct clk *clk, unsigned long rate)
 	} else if (rate != cur_rate) {
 		valid_rate = omap2_dpllcore_round_rate(rate);
 		if (valid_rate != rate)
-			goto dpll_exit;
+			return -EINVAL;
 
 		if (mult == 1)
 			low = curr_prcm_set->dpll_speed;
@@ -245,7 +242,7 @@ static int omap2_reprogram_dpllcore(struct clk *clk, unsigned long rate)
 
 		dd = clk->dpll_data;
 		if (!dd)
-			goto dpll_exit;
+			return -EINVAL;
 
 		tmpset.cm_clksel1_pll = cm_read_mod_reg(clk->prcm_mod,
 							dd->mult_div1_reg);
@@ -283,11 +280,8 @@ static int omap2_reprogram_dpllcore(struct clk *clk, unsigned long rate)
 		omap2xxx_sdrc_init_params(omap2xxx_sdrc_dll_is_unlocked());
 		omap2xxx_sdrc_reprogram(done_rate, 0);
 	}
-	ret = 0;
 
-dpll_exit:
-	local_irq_restore(flags);
-	return(ret);
+	return 0;
 }
 
 /**
diff --git a/arch/arm/mach-omap2/clock34xx.c b/arch/arm/mach-omap2/clock34xx.c
index 824144e..f7ac5c1 100644
--- a/arch/arm/mach-omap2/clock34xx.c
+++ b/arch/arm/mach-omap2/clock34xx.c
@@ -491,10 +491,8 @@ static int omap3_core_dpll_m2_set_rate(struct clk *clk, unsigned long rate)
 	WARN_ON(new_div != 1 && new_div != 2);
 
 	/* REVISIT: Add SDRC_MR changing to this code also */
-	local_irq_disable();
 	omap3_configure_core_dpll(sp->rfr_ctrl, sp->actim_ctrla,
 				  sp->actim_ctrlb, new_div);
-	local_irq_enable();
 
 	return 0;
 }


