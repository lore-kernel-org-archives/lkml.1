Return-Path: <linux-kernel-owner+w=401wt.eu-S1757562AbZA1Ufn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757562AbZA1Ufn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 15:35:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753216AbZA1U3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:29:33 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:32935 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754041AbZA1U3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:29:30 -0500
MBOX-Line: From nobody Wed Jan 28 12:27:56 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH E 10/14] OMAP clock: support "dry run" rate and parent changes
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, Paul Walmsley <paul@pwsan.com>,
       Tony Lindgren <tony@atomide.com>
Date: Wed, 28 Jan 2009 12:27:56 -0700
Message-ID: <20090128192753.29333.56931.stgit@localhost.localdomain>
In-Reply-To: <20090128192551.29333.82943.stgit@localhost.localdomain>
References: <20090128192551.29333.82943.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For upcoming notifier support, modify the rate recalculation code to
take parent rate and rate storage parameters.  The goal here is to
allow the clock code to determine what the clock's rate would be after
a parent change or a rate change, without actually changing the
hardware registers.  This is used by the upcoming notifier patches to
pass a clock's current and planned rates to the notifier callbacks.

Also add a new clock flag, RECALC_ON_ENABLE, which causes the clock
framework code to recalculate the current clock's rate and propagate
down the tree after a clk_enable() or clk_disable().  This is used by
the OMAP3 DPLLs, which change rates when they enable or disable, unlike
most clocks.

linux-omap source commit is 33d000c99ee393fe2042f93e8422f94976d276ce.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap1/clock.c             |   74 +++++++++++++++++----
 arch/arm/mach-omap1/clock.h             |   16 +++--
 arch/arm/mach-omap2/clock.c             |   34 +++++++---
 arch/arm/mach-omap2/clock.h             |    8 +-
 arch/arm/mach-omap2/clock24xx.c         |  107 ++++++++++++++++++++++---------
 arch/arm/mach-omap2/clock24xx.h         |   13 ++--
 arch/arm/mach-omap2/clock34xx.c         |   38 ++++++++---
 arch/arm/mach-omap2/clock34xx.h         |   21 ++++--
 arch/arm/plat-omap/clock.c              |   59 ++++++++++++-----
 arch/arm/plat-omap/include/mach/clock.h |   15 +++-
 10 files changed, 277 insertions(+), 108 deletions(-)

diff --git a/arch/arm/mach-omap1/clock.c b/arch/arm/mach-omap1/clock.c
index ae2b304..f3cf6f8 100644
--- a/arch/arm/mach-omap1/clock.c
+++ b/arch/arm/mach-omap1/clock.c
@@ -34,27 +34,50 @@ __u32 arm_idlect1_mask;
  * Omap1 specific clock functions
  *-------------------------------------------------------------------------*/
 
-static void omap1_watchdog_recalc(struct clk * clk)
+static void omap1_watchdog_recalc(struct clk *clk, unsigned long parent_rate,
+				  u8 rate_storage)
 {
-	clk->rate = clk->parent->rate / 14;
+	unsigned long new_rate;
+
+	new_rate = parent_rate / 14;
+
+	if (rate_storage == CURRENT_RATE)
+		clk->rate = new_rate;
+	else if (rate_storage == TEMP_RATE)
+		clk->temp_rate = new_rate;
 }
 
-static void omap1_uart_recalc(struct clk * clk)
+static void omap1_uart_recalc(struct clk *clk, unsigned long parent_rate,
+			      u8 rate_storage)
 {
+	unsigned long new_rate;
 	unsigned int val = __raw_readl(clk->enable_reg);
+
 	if (val & clk->enable_bit)
-		clk->rate = 48000000;
+		new_rate = 48000000;
 	else
-		clk->rate = 12000000;
+		new_rate = 12000000;
+
+	if (rate_storage == CURRENT_RATE)
+		clk->rate = new_rate;
+	else if (rate_storage == TEMP_RATE)
+		clk->temp_rate = new_rate;
 }
 
-static void omap1_sossi_recalc(struct clk *clk)
+static void omap1_sossi_recalc(struct clk *clk, unsigned long parent_rate,
+			       u8 rate_storage)
 {
+	unsigned long new_rate;
 	u32 div = omap_readl(MOD_CONF_CTRL_1);
 
 	div = (div >> 17) & 0x7;
 	div++;
-	clk->rate = clk->parent->rate / div;
+	new_rate = clk->parent->rate / div;
+
+	if (rate_storage == CURRENT_RATE)
+		clk->rate = new_rate;
+	else if (rate_storage == TEMP_RATE)
+		clk->temp_rate = new_rate;
 }
 
 static int omap1_clk_enable_dsp_domain(struct clk *clk)
@@ -215,21 +238,32 @@ static int calc_dsor_exp(struct clk *clk, unsigned long rate)
 	return dsor_exp;
 }
 
-static void omap1_ckctl_recalc(struct clk * clk)
+static void omap1_ckctl_recalc(struct clk *clk, unsigned long parent_rate,
+			       u8 rate_storage)
 {
 	int dsor;
+	unsigned long new_rate;
 
 	/* Calculate divisor encoded as 2-bit exponent */
 	dsor = 1 << (3 & (omap_readw(ARM_CKCTL) >> clk->rate_offset));
 
-	if (unlikely(clk->rate == clk->parent->rate / dsor))
+	new_rate = parent_rate / dsor;
+
+	if (unlikely(clk->rate == new_rate))
 		return; /* No change, quick exit */
-	clk->rate = clk->parent->rate / dsor;
+
+	if (rate_storage == CURRENT_RATE)
+		clk->rate = new_rate;
+	else if (rate_storage == TEMP_RATE)
+		clk->temp_rate = new_rate;
 }
 
-static void omap1_ckctl_recalc_dsp_domain(struct clk * clk)
+static void omap1_ckctl_recalc_dsp_domain(struct clk *clk,
+					  unsigned long parent_rate,
+					  u8 rate_storage)
 {
 	int dsor;
+	unsigned long new_rate;
 
 	/* Calculate divisor encoded as 2-bit exponent
 	 *
@@ -242,9 +276,15 @@ static void omap1_ckctl_recalc_dsp_domain(struct clk * clk)
 	dsor = 1 << (3 & (__raw_readw(DSP_CKCTL) >> clk->rate_offset));
 	omap1_clk_disable(&api_ck.clk);
 
-	if (unlikely(clk->rate == clk->parent->rate / dsor))
+	new_rate = parent_rate / dsor;
+
+	if (unlikely(clk->rate == new_rate))
 		return; /* No change, quick exit */
-	clk->rate = clk->parent->rate / dsor;
+
+	if (rate_storage == CURRENT_RATE)
+		clk->rate = new_rate;
+	else if (rate_storage == TEMP_RATE)
+		clk->temp_rate = new_rate;
 }
 
 /* MPU virtual clock functions */
@@ -283,7 +323,7 @@ static int omap1_select_table_rate(struct clk * clk, unsigned long rate)
 		omap_sram_reprogram_clock(ptr->dpllctl_val, ptr->ckctl_val);
 
 	ck_dpll1.rate = ptr->pll_rate;
-	propagate_rate(&ck_dpll1);
+	propagate_rate(&ck_dpll1, CURRENT_RATE);
 	return 0;
 }
 
@@ -724,7 +764,7 @@ int __init omap1_clk_init(void)
 			}
 		}
 	}
-	propagate_rate(&ck_dpll1);
+	propagate_rate(&ck_dpll1, CURRENT_RATE);
 #else
 	/* Find the highest supported frequency and enable it */
 	if (omap1_select_table_rate(&virtual_ck_mpu, ~0)) {
@@ -733,11 +773,11 @@ int __init omap1_clk_init(void)
 		omap_writew(0x2290, DPLL_CTL);
 		omap_writew(cpu_is_omap730() ? 0x3005 : 0x1005, ARM_CKCTL);
 		ck_dpll1.rate = 60000000;
-		propagate_rate(&ck_dpll1);
+		propagate_rate(&ck_dpll1, CURRENT_RATE);
 	}
 #endif
 	/* Cache rates for clocks connected to ck_ref (not dpll1) */
-	propagate_rate(&ck_ref);
+	propagate_rate(&ck_ref, CURRENT_RATE);
 	printk(KERN_INFO "Clocking rate (xtal/DPLL1/MPU): "
 		"%ld.%01ld/%ld.%01ld/%ld.%01ld MHz\n",
 	       ck_ref.rate / 1000000, (ck_ref.rate / 100000) % 10,
diff --git a/arch/arm/mach-omap1/clock.h b/arch/arm/mach-omap1/clock.h
index 43f6ce8..df94ad6 100644
--- a/arch/arm/mach-omap1/clock.h
+++ b/arch/arm/mach-omap1/clock.h
@@ -15,16 +15,22 @@
 
 static int omap1_clk_enable_generic(struct clk * clk);
 static void omap1_clk_disable_generic(struct clk * clk);
-static void omap1_ckctl_recalc(struct clk * clk);
-static void omap1_watchdog_recalc(struct clk * clk);
+static void omap1_ckctl_recalc(struct clk *clk, unsigned long parent_rate,
+			       u8 rate_storage);
+static void omap1_watchdog_recalc(struct clk *clk, unsigned long parent_rate,
+				  u8 rate_storage);
 static int omap1_set_sossi_rate(struct clk *clk, unsigned long rate);
-static void omap1_sossi_recalc(struct clk *clk);
-static void omap1_ckctl_recalc_dsp_domain(struct clk * clk);
+static void omap1_sossi_recalc(struct clk *clk, unsigned long parent_rate,
+			       u8 rate_storage);
+static void omap1_ckctl_recalc_dsp_domain(struct clk *clk,
+					  unsigned long parent_rate,
+					  u8 rate_storage);
 static int omap1_clk_enable_dsp_domain(struct clk * clk);
 static int omap1_clk_set_rate_dsp_domain(struct clk * clk, unsigned long rate);
 static void omap1_clk_disable_dsp_domain(struct clk * clk);
 static int omap1_set_uart_rate(struct clk * clk, unsigned long rate);
-static void omap1_uart_recalc(struct clk * clk);
+static void omap1_uart_recalc(struct clk *clk, unsigned long parent_rate,
+			      u8 rate_storage);
 static int omap1_clk_enable_uart_functional(struct clk * clk);
 static void omap1_clk_disable_uart_functional(struct clk * clk);
 static int omap1_set_ext_clk_rate(struct clk * clk, unsigned long rate);
diff --git a/arch/arm/mach-omap2/clock.c b/arch/arm/mach-omap2/clock.c
index 4a72535..0c00706 100644
--- a/arch/arm/mach-omap2/clock.c
+++ b/arch/arm/mach-omap2/clock.c
@@ -240,6 +240,7 @@ void omap2_init_clksel_parent(struct clk *clk)
 /**
  * omap2_get_dpll_rate - returns the current DPLL CLKOUT rate
  * @clk: struct clk * of a DPLL
+ * @parent_rate: rate of the parent of the DPLL clock
  *
  * DPLLs can be locked or bypassed - basically, enabled or disabled.
  * When locked, the DPLL output depends on the M and N values.  When
@@ -251,7 +252,7 @@ void omap2_init_clksel_parent(struct clk *clk)
  * locked, or the appropriate bypass rate if the DPLL is bypassed, or 0
  * if the clock @clk is not a DPLL.
  */
-u32 omap2_get_dpll_rate(struct clk *clk)
+u32 omap2_get_dpll_rate(struct clk *clk, unsigned long parent_rate)
 {
 	long long dpll_clk;
 	u32 dpll_mult, dpll_div, v;
@@ -269,7 +270,7 @@ u32 omap2_get_dpll_rate(struct clk *clk)
 
 		if (v == OMAP2XXX_EN_DPLL_LPBYPASS ||
 		    v == OMAP2XXX_EN_DPLL_FRBYPASS)
-			return clk->parent->rate;
+			return parent_rate;
 
 	} else if (cpu_is_omap34xx()) {
 
@@ -285,7 +286,7 @@ u32 omap2_get_dpll_rate(struct clk *clk)
 	dpll_div = v & dd->div1_mask;
 	dpll_div >>= __ffs(dd->div1_mask);
 
-	dpll_clk = (long long)clk->parent->rate * dpll_mult;
+	dpll_clk = (long long)parent_rate * dpll_mult;
 	do_div(dpll_clk, dpll_div + 1);
 
 	return dpll_clk;
@@ -295,11 +296,19 @@ u32 omap2_get_dpll_rate(struct clk *clk)
  * Used for clocks that have the same value as the parent clock,
  * divided by some factor
  */
-void omap2_fixed_divisor_recalc(struct clk *clk)
+void omap2_fixed_divisor_recalc(struct clk *clk, unsigned long parent_rate,
+				u8 rate_storage)
 {
-	WARN_ON(!clk->fixed_div);
+	unsigned long rate;
 
-	clk->rate = clk->parent->rate / clk->fixed_div;
+	WARN_ON(!clk->fixed_div); /* XXX move this to init */
+
+	rate = parent_rate / clk->fixed_div;
+
+	if (rate_storage == CURRENT_RATE)
+		clk->rate = rate;
+	else if (rate_storage == TEMP_RATE)
+		clk->temp_rate = rate;
 }
 
 /**
@@ -486,9 +495,11 @@ int omap2_clk_enable(struct clk *clk)
  * Used for clocks that are part of CLKSEL_xyz governed clocks.
  * REVISIT: Maybe change to use clk->enable() functions like on omap1?
  */
-void omap2_clksel_recalc(struct clk *clk)
+void omap2_clksel_recalc(struct clk *clk, unsigned long parent_rate,
+			 u8 rate_storage)
 {
 	u32 div = 0;
+	unsigned long rate;
 
 	pr_debug("clock: recalc'ing clksel clk %s\n", clk->name);
 
@@ -496,9 +507,12 @@ void omap2_clksel_recalc(struct clk *clk)
 	if (div == 0)
 		return;
 
-	if (clk->rate == (clk->parent->rate / div))
-		return;
-	clk->rate = clk->parent->rate / div;
+	rate = parent_rate / div;
+
+	if (rate_storage == CURRENT_RATE)
+		clk->rate = rate;
+	else if (rate_storage == TEMP_RATE)
+		clk->temp_rate = rate;
 
 	pr_debug("clock: new clock rate is %ld (div %d)\n", clk->rate, div);
 }
diff --git a/arch/arm/mach-omap2/clock.h b/arch/arm/mach-omap2/clock.h
index faff95e..a026ec9 100644
--- a/arch/arm/mach-omap2/clock.h
+++ b/arch/arm/mach-omap2/clock.h
@@ -52,7 +52,8 @@ void omap2_clk_disable_unused(struct clk *clk);
 #define omap2_clk_disable_unused	NULL
 #endif
 
-void omap2_clksel_recalc(struct clk *clk);
+void omap2_clksel_recalc(struct clk *clk, unsigned long new_parent_rate,
+			 u8 rate_storage);
 void omap2_init_clk_clkdm(struct clk *clk);
 void omap2_init_clksel_parent(struct clk *clk);
 u32 omap2_clksel_get_divisor(struct clk *clk);
@@ -60,10 +61,11 @@ u32 omap2_clksel_round_rate_div(struct clk *clk, unsigned long target_rate,
 				u32 *new_div);
 u32 omap2_clksel_to_divisor(struct clk *clk, u32 field_val);
 u32 omap2_divisor_to_clksel(struct clk *clk, u32 div);
-void omap2_fixed_divisor_recalc(struct clk *clk);
+void omap2_fixed_divisor_recalc(struct clk *clk, unsigned long new_parent_rate,
+				u8 rate_storage);
 long omap2_clksel_round_rate(struct clk *clk, unsigned long target_rate);
 int omap2_clksel_set_rate(struct clk *clk, unsigned long rate);
-u32 omap2_get_dpll_rate(struct clk *clk);
+u32 omap2_get_dpll_rate(struct clk *clk, unsigned long parent_rate);
 int omap2_wait_clock_ready(s16 prcm_mod, u16 idlest_reg, u32 cval,
 			   const char *name);
 void omap2_clk_prepare_for_reboot(void);
diff --git a/arch/arm/mach-omap2/clock24xx.c b/arch/arm/mach-omap2/clock24xx.c
index 57cd85b..cd9fa0d 100644
--- a/arch/arm/mach-omap2/clock24xx.c
+++ b/arch/arm/mach-omap2/clock24xx.c
@@ -64,6 +64,7 @@ static struct clk *sclk;
 /**
  * omap2xxx_clk_get_core_rate - return the CORE_CLK rate
  * @clk: pointer to the combined dpll_ck + core_ck (currently "dpll_ck")
+ * @parent_rate: rate of the parent of the dpll_ck
  *
  * Returns the CORE_CLK rate.  CORE_CLK can have one of three rate
  * sources on OMAP2xxx: the DPLL CLKOUT rate, DPLL CLKOUTX2, or 32KHz
@@ -71,12 +72,13 @@ static struct clk *sclk;
  * struct clk *dpll_ck, which is a composite clock of dpll_ck and
  * core_ck.
  */
-static u32 omap2xxx_clk_get_core_rate(struct clk *clk)
+static u32 omap2xxx_clk_get_core_rate(struct clk *clk,
+				      unsigned long parent_rate)
 {
 	long long core_clk;
 	u32 v;
 
-	core_clk = omap2_get_dpll_rate(clk);
+	core_clk = omap2_get_dpll_rate(clk, parent_rate);
 
 	v = cm_read_mod_reg(PLL_MOD, CM_CLKSEL2);
 	v &= OMAP24XX_CORE_CLK_SRC_MASK;
@@ -89,6 +91,30 @@ static u32 omap2xxx_clk_get_core_rate(struct clk *clk)
 	return core_clk;
 }
 
+static unsigned long omap2xxx_clk_find_oppset_by_mpurate(unsigned long mpu_speed,
+							 struct prcm_config **prcm)
+{
+	unsigned long found_speed = 0;
+	struct prcm_config *p;
+
+	p = *prcm;
+
+	for (p = rate_table; p->mpu_speed; p++) {
+		if (!(p->flags & cpu_mask))
+			continue;
+
+		if (p->xtal_speed != sys_ck.rate)
+			continue;
+
+		if (p->mpu_speed <= mpu_speed) {
+			found_speed = p->mpu_speed;
+			break;
+		}
+	}
+
+	return found_speed;
+}
+
 static int omap2_enable_osc_ck(struct clk *clk)
 {
 	prm_rmw_mod_reg_bits(OMAP_AUTOEXTCLKMODE_MASK, 0,
@@ -176,9 +202,17 @@ static long omap2_dpllcore_round_rate(unsigned long target_rate)
 
 }
 
-static void omap2_dpllcore_recalc(struct clk *clk)
+static void omap2_dpllcore_recalc(struct clk *clk, unsigned long parent_rate,
+				  u8 rate_storage)
 {
-	clk->rate = omap2xxx_clk_get_core_rate(clk);
+	unsigned long rate;
+
+	rate = omap2xxx_clk_get_core_rate(clk, parent_rate);
+
+	if (rate_storage == CURRENT_RATE)
+		clk->rate = rate;
+	else if (rate_storage == TEMP_RATE)
+		clk->temp_rate = rate;
 }
 
 static int omap2_reprogram_dpllcore(struct clk *clk, unsigned long rate)
@@ -191,7 +225,7 @@ static int omap2_reprogram_dpllcore(struct clk *clk, unsigned long rate)
 	int ret = -EINVAL;
 
 	local_irq_save(flags);
-	cur_rate = omap2xxx_clk_get_core_rate(&dpll_ck);
+	cur_rate = omap2xxx_clk_get_core_rate(&dpll_ck, dpll_ck.parent->rate);
 	mult = cm_read_mod_reg(PLL_MOD, CM_CLKSEL2);
 	mult &= OMAP24XX_CORE_CLK_SRC_MASK;
 
@@ -262,9 +296,18 @@ dpll_exit:
  *
  * Set virt_prcm_set's rate to the mpu_speed field of the current PRCM set.
  */
-static void omap2_table_mpu_recalc(struct clk *clk)
+static void omap2_table_mpu_recalc(struct clk *clk, unsigned long parent_rate,
+				   u8 rate_storage)
 {
-	clk->rate = curr_prcm_set->mpu_speed;
+	struct prcm_config *prcm;
+	unsigned long mpurate;
+
+	mpurate = omap2xxx_clk_find_oppset_by_mpurate(parent_rate, &prcm);
+
+	if (rate_storage == CURRENT_RATE)
+		clk->rate = mpurate;
+	else if (rate_storage == TEMP_RATE)
+		clk->temp_rate = mpurate;
 }
 
 /*
@@ -304,25 +347,12 @@ static int omap2_select_table_rate(struct clk *clk, unsigned long rate)
 {
 	u32 cur_rate, done_rate, bypass = 0, tmp;
 	struct prcm_config *prcm;
-	unsigned long found_speed = 0;
-	unsigned long flags;
+	unsigned long flags, found_speed;
 
 	if (clk != &virt_prcm_set)
 		return -EINVAL;
 
-	for (prcm = rate_table; prcm->mpu_speed; prcm++) {
-		if (!(prcm->flags & cpu_mask))
-			continue;
-
-		if (prcm->xtal_speed != sys_ck.rate)
-			continue;
-
-		if (prcm->mpu_speed <= rate) {
-			found_speed = prcm->mpu_speed;
-			break;
-		}
-	}
-
+	found_speed = omap2xxx_clk_find_oppset_by_mpurate(rate, &prcm);
 	if (!found_speed) {
 		printk(KERN_INFO "Could not set MPU rate to %luMHz\n",
 		       rate / 1000000);
@@ -330,7 +360,7 @@ static int omap2_select_table_rate(struct clk *clk, unsigned long rate)
 	}
 
 	curr_prcm_set = prcm;
-	cur_rate = omap2xxx_clk_get_core_rate(&dpll_ck);
+	cur_rate = omap2xxx_clk_get_core_rate(&dpll_ck, dpll_ck.parent->rate);
 
 	if (prcm->dpll_speed == cur_rate / 2) {
 		omap2xxx_sdrc_reprogram(CORE_CLK_SRC_DPLL, 1);
@@ -463,14 +493,31 @@ static u32 omap2_get_sysclkdiv(void)
 	return div;
 }
 
-static void omap2_osc_clk_recalc(struct clk *clk)
+static void omap2_osc_clk_recalc(struct clk *clk, unsigned long parent_rate,
+				 u8 rate_storage)
 {
-	clk->rate = omap2_get_apll_clkin() * omap2_get_sysclkdiv();
+	unsigned long rate;
+
+	/* XXX osc_ck on 2xxx currently is parentless */
+	rate = omap2_get_apll_clkin() * omap2_get_sysclkdiv();
+
+	if (rate_storage == CURRENT_RATE)
+		clk->rate = rate;
+	else if (rate_storage == TEMP_RATE)
+		clk->temp_rate = rate;
 }
 
-static void omap2_sys_clk_recalc(struct clk *clk)
+static void omap2_sys_clk_recalc(struct clk *clk, unsigned long parent_rate,
+				 u8 rate_storage)
 {
-	clk->rate = clk->parent->rate / omap2_get_sysclkdiv();
+	unsigned long rate;
+
+	rate = parent_rate / omap2_get_sysclkdiv();
+
+	if (rate_storage == CURRENT_RATE)
+		clk->rate = rate;
+	else if (rate_storage == TEMP_RATE)
+		clk->temp_rate = rate;
 }
 
 /*
@@ -523,8 +570,8 @@ int __init omap2_clk_init(void)
 
 	clk_init(&omap2_clk_functions);
 
-	omap2_osc_clk_recalc(&osc_ck);
-	omap2_sys_clk_recalc(&sys_ck);
+	omap2_osc_clk_recalc(&osc_ck, 0, CURRENT_RATE);
+	omap2_sys_clk_recalc(&sys_ck, sys_ck.parent->rate, CURRENT_RATE);
 
 	for (clkp = onchip_24xx_clks;
 	     clkp < onchip_24xx_clks + ARRAY_SIZE(onchip_24xx_clks);
@@ -544,7 +591,7 @@ int __init omap2_clk_init(void)
 	}
 
 	/* Check the MPU rate set by bootloader */
-	clkrate = omap2xxx_clk_get_core_rate(&dpll_ck);
+	clkrate = omap2xxx_clk_get_core_rate(&dpll_ck, dpll_ck.parent->rate);
 	for (prcm = rate_table; prcm->mpu_speed; prcm++) {
 		if (!(prcm->flags & cpu_mask))
 			continue;
diff --git a/arch/arm/mach-omap2/clock24xx.h b/arch/arm/mach-omap2/clock24xx.h
index 30f3c57..cd9feda 100644
--- a/arch/arm/mach-omap2/clock24xx.h
+++ b/arch/arm/mach-omap2/clock24xx.h
@@ -24,13 +24,16 @@
 #include "cm-regbits-24xx.h"
 #include "sdrc.h"
 
-static void omap2_table_mpu_recalc(struct clk *clk);
+static void omap2_table_mpu_recalc(struct clk *clk, unsigned long parent_rate,
+				   u8 rate_storage);
 static int omap2_select_table_rate(struct clk *clk, unsigned long rate);
 static long omap2_round_to_table_rate(struct clk *clk, unsigned long rate);
-static void omap2_sys_clk_recalc(struct clk *clk);
-static void omap2_osc_clk_recalc(struct clk *clk);
-static void omap2_sys_clk_recalc(struct clk *clk);
-static void omap2_dpllcore_recalc(struct clk *clk);
+static void omap2_sys_clk_recalc(struct clk *clk, unsigned long parent_rate,
+				 u8 rate_storage);
+static void omap2_osc_clk_recalc(struct clk *clk, unsigned long parent_rate,
+				 u8 rate_storage);
+static void omap2_dpllcore_recalc(struct clk *clk, unsigned long parent_rate,
+				 u8 rate_storage);
 static int omap2_clk_fixed_enable(struct clk *clk);
 static void omap2_clk_fixed_disable(struct clk *clk);
 static int omap2_enable_osc_ck(struct clk *clk);
diff --git a/arch/arm/mach-omap2/clock34xx.c b/arch/arm/mach-omap2/clock34xx.c
index 22cbcce..917664d 100644
--- a/arch/arm/mach-omap2/clock34xx.c
+++ b/arch/arm/mach-omap2/clock34xx.c
@@ -48,12 +48,22 @@
 /**
  * omap3_dpll_recalc - recalculate DPLL rate
  * @clk: DPLL struct clk
+ * @parent_rate: rate of the DPLL's parent clock
+ * @rate_storage: flag indicating whether current or temporary rate is changing
  *
  * Recalculate and propagate the DPLL rate.
  */
-static void omap3_dpll_recalc(struct clk *clk)
+static void omap3_dpll_recalc(struct clk *clk, unsigned long parent_rate,
+			      u8 rate_storage)
 {
-	clk->rate = omap2_get_dpll_rate(clk);
+	unsigned long rate;
+
+	rate = omap2_get_dpll_rate(clk, parent_rate);
+
+	if (rate_storage == CURRENT_RATE)
+		clk->rate = rate;
+	else if (rate_storage == TEMP_RATE)
+		clk->temp_rate = rate;
 }
 
 /* _omap3_dpll_write_clken - write clken_bits arg to a DPLL's enable bits */
@@ -278,9 +288,6 @@ static int omap3_noncore_dpll_enable(struct clk *clk)
 	else
 		r = _omap3_noncore_dpll_lock(clk);
 
-	if (!r)
-		clk->rate = omap2_get_dpll_rate(clk);
-
 	return r;
 }
 
@@ -392,7 +399,7 @@ static int omap3_noncore_dpll_set_rate(struct clk *clk, unsigned long rate)
 	if (!dd)
 		return -EINVAL;
 
-	if (rate == omap2_get_dpll_rate(clk))
+	if (rate == omap2_get_dpll_rate(clk, clk->parent->rate))
 		return 0;
 
 	if (dd->bypass_clk->rate == rate &&
@@ -578,14 +585,18 @@ static void omap3_dpll_deny_idle(struct clk *clk)
 /**
  * omap3_clkoutx2_recalc - recalculate DPLL X2 output virtual clock rate
  * @clk: DPLL output struct clk
+ * @parent_rate: rate of the parent clock of @clk
+ * @rate_storage: flag indicating whether current or temporary rate is changing
  *
  * Using parent clock DPLL data, look up DPLL state.  If locked, set our
  * rate to the dpll_clk * 2; otherwise, just use dpll_clk.
  */
-static void omap3_clkoutx2_recalc(struct clk *clk)
+static void omap3_clkoutx2_recalc(struct clk *clk, unsigned long parent_rate,
+				  u8 rate_storage)
 {
 	const struct dpll_data *dd;
 	u32 v;
+	unsigned long rate;
 	struct clk *pclk;
 
 	/* Walk up the parents of clk, looking for a DPLL */
@@ -600,12 +611,17 @@ static void omap3_clkoutx2_recalc(struct clk *clk)
 
 	WARN_ON(!dd->enable_mask);
 
+	rate = parent_rate;
+
 	v = cm_read_mod_reg(pclk->prcm_mod, dd->control_reg) & dd->enable_mask;
 	v >>= __ffs(dd->enable_mask);
-	if (v != OMAP3XXX_EN_DPLL_LOCKED)
-		clk->rate = clk->parent->rate;
-	else
-		clk->rate = clk->parent->rate * 2;
+	if (v == OMAP3XXX_EN_DPLL_LOCKED)
+		rate *= 2;
+
+	if (rate_storage == CURRENT_RATE)
+		clk->rate = rate;
+	else if (rate_storage == TEMP_RATE)
+		clk->temp_rate = rate;
 }
 
 /* Common clock code */
diff --git a/arch/arm/mach-omap2/clock34xx.h b/arch/arm/mach-omap2/clock34xx.h
index 66cbe0c..283c386 100644
--- a/arch/arm/mach-omap2/clock34xx.h
+++ b/arch/arm/mach-omap2/clock34xx.h
@@ -27,8 +27,10 @@
 #include "prm.h"
 #include "prm-regbits-34xx.h"
 
-static void omap3_dpll_recalc(struct clk *clk);
-static void omap3_clkoutx2_recalc(struct clk *clk);
+static void omap3_dpll_recalc(struct clk *clk, unsigned long parent_rate,
+			      u8 rate_storage);
+static void omap3_clkoutx2_recalc(struct clk *clk, unsigned long parent_rate,
+			      u8 rate_storage);
 static void omap3_dpll_allow_idle(struct clk *clk);
 static void omap3_dpll_deny_idle(struct clk *clk);
 static u32 omap3_dpll_autoidle_read(struct clk *clk);
@@ -292,7 +294,8 @@ static struct clk dpll1_ck = {
 	.parent		= &sys_ck,
 	.prcm_mod	= MPU_MOD,
 	.dpll_data	= &dpll1_dd,
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | ALWAYS_ENABLED,
+	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
+			  ALWAYS_ENABLED | RECALC_ON_ENABLE,
 	.round_rate	= &omap2_dpll_round_rate,
 	.set_rate	= &omap3_noncore_dpll_set_rate,
 	.clkdm		= { .name = "dpll1_clkdm" },
@@ -368,7 +371,8 @@ static struct clk dpll2_ck = {
 	.parent		= &sys_ck,
 	.prcm_mod	= OMAP3430_IVA2_MOD,
 	.dpll_data	= &dpll2_dd,
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES,
+	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
+			  RECALC_ON_ENABLE,
 	.enable		= &omap3_noncore_dpll_enable,
 	.disable	= &omap3_noncore_dpll_disable,
 	.round_rate	= &omap2_dpll_round_rate,
@@ -431,7 +435,8 @@ static struct clk dpll3_ck = {
 	.parent		= &sys_ck,
 	.prcm_mod	= PLL_MOD,
 	.dpll_data	= &dpll3_dd,
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | ALWAYS_ENABLED,
+	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
+			  ALWAYS_ENABLED | RECALC_ON_ENABLE,
 	.round_rate	= &omap2_dpll_round_rate,
 	.clkdm		= { .name = "dpll3_clkdm" },
 	.recalc		= &omap3_dpll_recalc,
@@ -597,7 +602,8 @@ static struct clk dpll4_ck = {
 	.parent		= &sys_ck,
 	.prcm_mod	= PLL_MOD,
 	.dpll_data	= &dpll4_dd,
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES,
+	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
+			  RECALC_ON_ENABLE,
 	.enable		= &omap3_noncore_dpll_enable,
 	.disable	= &omap3_noncore_dpll_disable,
 	.round_rate	= &omap2_dpll_round_rate,
@@ -926,7 +932,8 @@ static struct clk dpll5_ck = {
 	.parent		= &sys_ck,
 	.prcm_mod	= PLL_MOD,
 	.dpll_data	= &dpll5_dd,
-	.flags		= CLOCK_IN_OMAP3430ES2 | RATE_PROPAGATES,
+	.flags		= CLOCK_IN_OMAP3430ES2 | RATE_PROPAGATES |
+			  RECALC_ON_ENABLE,
 	.enable		= &omap3_noncore_dpll_enable,
 	.disable	= &omap3_noncore_dpll_disable,
 	.round_rate	= &omap2_dpll_round_rate,
diff --git a/arch/arm/plat-omap/clock.c b/arch/arm/plat-omap/clock.c
index 4cf1145..7a7547d 100644
--- a/arch/arm/plat-omap/clock.c
+++ b/arch/arm/plat-omap/clock.c
@@ -83,8 +83,17 @@ int clk_enable(struct clk *clk)
 		return -EINVAL;
 
 	spin_lock_irqsave(&clockfw_lock, flags);
-	if (arch_clock->clk_enable)
+	if (arch_clock->clk_enable) {
 		ret = arch_clock->clk_enable(clk);
+		if (ret == 0 && clk->flags & RECALC_ON_ENABLE) {
+			if (clk->recalc)
+				(*clk->recalc)(clk, clk->parent->rate,
+					       CURRENT_RATE);
+			if (clk->flags & RATE_PROPAGATES)
+				propagate_rate(clk, CURRENT_RATE);
+		}
+	}
+
 	spin_unlock_irqrestore(&clockfw_lock, flags);
 
 	return ret;
@@ -106,8 +115,16 @@ void clk_disable(struct clk *clk)
 		goto out;
 	}
 
-	if (arch_clock->clk_disable)
+	if (arch_clock->clk_disable) {
 		arch_clock->clk_disable(clk);
+		if (clk->flags & RECALC_ON_ENABLE) {
+			if (clk->recalc)
+				(*clk->recalc)(clk, clk->parent->rate,
+					       CURRENT_RATE);
+			if (clk->flags & RATE_PROPAGATES)
+				propagate_rate(clk, CURRENT_RATE);
+		}
+	}
 
 out:
 	spin_unlock_irqrestore(&clockfw_lock, flags);
@@ -188,9 +205,10 @@ int clk_set_rate(struct clk *clk, unsigned long rate)
 		ret = arch_clock->clk_set_rate(clk, rate);
 		if (ret == 0) {
 			if (clk->recalc)
-				(*clk->recalc)(clk);
+				(*clk->recalc)(clk, clk->parent->rate,
+					       CURRENT_RATE);
 			if (clk->flags & RATE_PROPAGATES)
-				propagate_rate(clk);
+				propagate_rate(clk, CURRENT_RATE);
 		}
 	}
 
@@ -214,9 +232,10 @@ int clk_set_parent(struct clk *clk, struct clk *parent)
 		ret = arch_clock->clk_set_parent(clk, parent);
 		if (ret == 0) {
 			if (clk->recalc)
-				(*clk->recalc)(clk);
+				(*clk->recalc)(clk, clk->parent->rate,
+					       CURRENT_RATE);
 			if (clk->flags & RATE_PROPAGATES)
-				propagate_rate(clk);
+				propagate_rate(clk, CURRENT_RATE);
 		}
 	}
 
@@ -268,18 +287,20 @@ static int __init omap_clk_setup(char *str)
 __setup("mpurate=", omap_clk_setup);
 
 /* Used for clocks that always have same value as the parent clock */
-void followparent_recalc(struct clk *clk)
+void followparent_recalc(struct clk *clk, unsigned long new_parent_rate,
+			 u8 rate_storage)
 {
-	if (clk == NULL || IS_ERR(clk))
-		return;
-
-	clk->rate = clk->parent->rate;
+	if (rate_storage == CURRENT_RATE)
+		clk->rate = new_parent_rate;
+	else if (rate_storage == TEMP_RATE)
+		clk->temp_rate = new_parent_rate;
 }
 
 /* Propagate rate to children */
-void propagate_rate(struct clk * tclk)
+void propagate_rate(struct clk *tclk, u8 rate_storage)
 {
 	struct clk *clkp;
+	unsigned long parent_rate = 0;
 
 	if (tclk == NULL || IS_ERR(tclk))
 		return;
@@ -287,10 +308,16 @@ void propagate_rate(struct clk * tclk)
 	list_for_each_entry(clkp, &clocks, node) {
 		if (likely(clkp->parent != tclk))
 			continue;
+
+		if (rate_storage == CURRENT_RATE)
+			parent_rate = tclk->rate;
+		else if (rate_storage == TEMP_RATE)
+			parent_rate = tclk->temp_rate;
+
 		if (clkp->recalc)
-			clkp->recalc(clkp);
+			clkp->recalc(clkp, parent_rate, rate_storage);
 		if (clkp->flags & RATE_PROPAGATES)
-			propagate_rate(clkp);
+			propagate_rate(clkp, rate_storage);
 	}
 }
 
@@ -308,9 +335,9 @@ void recalculate_root_clocks(void)
 	list_for_each_entry(clkp, &clocks, node) {
 		if (unlikely(!clkp->parent)) {
 			if (clkp->recalc)
-				clkp->recalc(clkp);
+				clkp->recalc(clkp, 0, CURRENT_RATE);
 			if (clkp->flags & RATE_PROPAGATES)
-				propagate_rate(clkp);
+				propagate_rate(clkp, CURRENT_RATE);
 		}
 	}
 }
diff --git a/arch/arm/plat-omap/include/mach/clock.h b/arch/arm/plat-omap/include/mach/clock.h
index e793616..9b1d1f8 100644
--- a/arch/arm/plat-omap/include/mach/clock.h
+++ b/arch/arm/plat-omap/include/mach/clock.h
@@ -67,12 +67,13 @@ struct clk {
 	int			id;
 	struct clk		*parent;
 	unsigned long		rate;
+	unsigned long		temp_rate;
 	__u32			flags;
 	u32			enable_reg;
 	__u8			enable_bit;
 	__s8			usecount;
 	u8			idlest_bit;
-	void			(*recalc)(struct clk *);
+	void			(*recalc)(struct clk *, unsigned long, u8);
 	int			(*set_rate)(struct clk *, unsigned long);
 	long			(*round_rate)(struct clk *, unsigned long);
 	void			(*init)(struct clk *);
@@ -120,9 +121,10 @@ extern unsigned int mpurate;
 extern int clk_init(struct clk_functions *custom_clocks);
 extern int clk_register(struct clk *clk);
 extern void clk_unregister(struct clk *clk);
-extern void propagate_rate(struct clk *clk);
+extern void propagate_rate(struct clk *clk, u8 rate_storage);
 extern void recalculate_root_clocks(void);
-extern void followparent_recalc(struct clk *clk);
+extern void followparent_recalc(struct clk *clk, unsigned long parent_rate,
+				u8 rate_storage);
 extern void clk_allow_idle(struct clk *clk);
 extern void clk_deny_idle(struct clk *clk);
 extern int clk_get_usecount(struct clk *clk);
@@ -146,7 +148,8 @@ extern void clk_init_cpufreq_table(struct cpufreq_frequency_table **table);
 #define ENABLE_ON_INIT		(1 << 11)	/* Enable upon framework init */
 #define INVERT_ENABLE		(1 << 12)	/* 0 enables, 1 disables */
 #define WAIT_READY		(1 << 13)	/* wait for dev to leave idle */
-/* bits 14-20 are currently free */
+#define RECALC_ON_ENABLE	(1 << 14)	/* recalc/prop on ena/disa */
+/* bits 15-20 are currently free */
 #define CLOCK_IN_OMAP310	(1 << 21)
 #define CLOCK_IN_OMAP730	(1 << 22)
 #define CLOCK_IN_OMAP1510	(1 << 23)
@@ -167,6 +170,10 @@ extern void clk_init_cpufreq_table(struct cpufreq_frequency_table **table);
 
 #define RATE_IN_24XX		(RATE_IN_242X | RATE_IN_243X)
 
+/* rate_storage parameter flags */
+#define CURRENT_RATE		0
+#define TEMP_RATE		1
+
 /*
  * clk.prcm_mod flags (possible since only the top byte in clk.prcm_mod
  * is significant)


