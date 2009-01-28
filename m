Return-Path: <linux-kernel-owner+w=401wt.eu-S1758633AbZA1Ukm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758633AbZA1Ukm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 15:40:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755631AbZA1U35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:29:57 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:32928 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755381AbZA1U33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:29:29 -0500
MBOX-Line: From nobody Wed Jan 28 12:28:01 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH E 12/14] OMAP clock: unnecessary clock flag removal fiesta
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, Paul Walmsley <paul@pwsan.com>,
       Tony Lindgren <tony@atomide.com>
Date: Wed, 28 Jan 2009 12:28:01 -0700
Message-ID: <20090128192759.29333.76642.stgit@localhost.localdomain>
In-Reply-To: <20090128192551.29333.82943.stgit@localhost.localdomain>
References: <20090128192551.29333.82943.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes four unnecessary clock flags:

1. Now that clocks keep track of their children, the RATE_PROPAGATES flag
is no longer necessary.

2. The RATE_FIXED flag has no useful purpose.  Fixed rate clocks
should simply not implement the recalc, set_rate, set_parent, and
round_rate function pointers.

3. Nothing tests the clock flags for VIRTUAL_CLOCK, so it serves no
purpose.  Remove it.

4. The CONFIG_PARTICIPANT flags indicates to the clock rate and parent
changing functions that they should not be used on this clock.  Better
just to remove the clock function pointers that operate on those
clocks.  The name of the flag is just terrible: its meaning has almost
nothing to do with its name, and the use of the CONFIG_ prefix makes
it appear to be a Kconfig option.  Get rid of it.

linux-omap source commits are ed950086c69beaabd7179a13b9d2f6c6d0cbddc8,
563aab5521064eae3ece7f3f1f19a32cb5cece4a,
ab0f0e3e3625d5b9abaf37133478c69b4a193521, and
f438e7e9dcd837fd64109256fce82725f7887428.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap1/clock.c             |    3 
 arch/arm/mach-omap1/clock.h             |   44 +++---
 arch/arm/mach-omap2/clock.c             |   17 --
 arch/arm/mach-omap2/clock24xx.h         |   72 ++++------
 arch/arm/mach-omap2/clock34xx.h         |  217 +++++++++++--------------------
 arch/arm/plat-omap/include/mach/clock.h |    8 -
 6 files changed, 130 insertions(+), 231 deletions(-)

diff --git a/arch/arm/mach-omap1/clock.c b/arch/arm/mach-omap1/clock.c
index f3cf6f8..af48050 100644
--- a/arch/arm/mach-omap1/clock.c
+++ b/arch/arm/mach-omap1/clock.c
@@ -570,9 +570,6 @@ static long omap1_clk_round_rate(struct clk *clk, unsigned long rate)
 {
 	int dsor_exp;
 
-	if (clk->flags & RATE_FIXED)
-		return clk->rate;
-
 	if (clk->flags & RATE_CKCTL) {
 		dsor_exp = calc_dsor_exp(clk, rate);
 		if (dsor_exp < 0)
diff --git a/arch/arm/mach-omap1/clock.h b/arch/arm/mach-omap1/clock.h
index df94ad6..5ba55a0 100644
--- a/arch/arm/mach-omap1/clock.h
+++ b/arch/arm/mach-omap1/clock.h
@@ -169,7 +169,7 @@ static struct clk ck_dpll1 = {
 	.name		= "ck_dpll1",
 	.parent		= &ck_ref,
 	.flags		= CLOCK_IN_OMAP1510 | CLOCK_IN_OMAP16XX |
-			  CLOCK_IN_OMAP310 | RATE_PROPAGATES | ALWAYS_ENABLED,
+			  CLOCK_IN_OMAP310 | ALWAYS_ENABLED,
 	.enable		= &omap1_clk_enable_generic,
 	.disable	= &omap1_clk_disable_generic,
 };
@@ -179,7 +179,7 @@ static struct arm_idlect1_clk ck_dpll1out = {
 		.name		= "ck_dpll1out",
 		.parent		= &ck_dpll1,
 		.flags		= CLOCK_IN_OMAP16XX | CLOCK_IDLE_CONTROL |
-				  ENABLE_REG_32BIT | RATE_PROPAGATES,
+				  ENABLE_REG_32BIT,
 		.enable_reg	= OMAP1_IO_ADDRESS(ARM_IDLECT2),
 		.enable_bit	= EN_CKOUT_ARM,
 		.recalc		= &followparent_recalc,
@@ -206,8 +206,7 @@ static struct clk arm_ck = {
 	.name		= "arm_ck",
 	.parent		= &ck_dpll1,
 	.flags		= CLOCK_IN_OMAP1510 | CLOCK_IN_OMAP16XX |
-			  CLOCK_IN_OMAP310 | RATE_CKCTL | RATE_PROPAGATES |
-			  ALWAYS_ENABLED,
+			  CLOCK_IN_OMAP310 | RATE_CKCTL | ALWAYS_ENABLED,
 	.rate_offset	= CKCTL_ARMDIV_OFFSET,
 	.recalc		= &omap1_ckctl_recalc,
 	.enable		= &omap1_clk_enable_generic,
@@ -368,7 +367,7 @@ static struct arm_idlect1_clk tc_ck = {
 		.parent		= &ck_dpll1,
 		.flags		= CLOCK_IN_OMAP1510 | CLOCK_IN_OMAP16XX |
 				  CLOCK_IN_OMAP730 | CLOCK_IN_OMAP310 |
-				  RATE_CKCTL | RATE_PROPAGATES |
+				  RATE_CKCTL |
 				  ALWAYS_ENABLED | CLOCK_IDLE_CONTROL,
 		.rate_offset	= CKCTL_TCDIV_OFFSET,
 		.recalc		= &omap1_ckctl_recalc,
@@ -555,8 +554,8 @@ static struct uart_clk uart1_16xx = {
 		/* Direct from ULPD, no real parent */
 		.parent		= &armper_ck.clk,
 		.rate		= 48000000,
-		.flags		= CLOCK_IN_OMAP16XX | RATE_FIXED |
-				  ENABLE_REG_32BIT | CLOCK_NO_IDLE_PARENT,
+		.flags		= CLOCK_IN_OMAP16XX | ENABLE_REG_32BIT |
+				  CLOCK_NO_IDLE_PARENT,
 		.enable_reg	= OMAP1_IO_ADDRESS(MOD_CONF_CTRL_0),
 		.enable_bit	= 29,
 		.enable		= &omap1_clk_enable_uart_functional,
@@ -603,8 +602,8 @@ static struct uart_clk uart3_16xx = {
 		/* Direct from ULPD, no real parent */
 		.parent		= &armper_ck.clk,
 		.rate		= 48000000,
-		.flags		= CLOCK_IN_OMAP16XX | RATE_FIXED |
-				  ENABLE_REG_32BIT | CLOCK_NO_IDLE_PARENT,
+		.flags		= CLOCK_IN_OMAP16XX | ENABLE_REG_32BIT |
+				  CLOCK_NO_IDLE_PARENT,
 		.enable_reg	= OMAP1_IO_ADDRESS(MOD_CONF_CTRL_0),
 		.enable_bit	= 31,
 		.enable		= &omap1_clk_enable_uart_functional,
@@ -618,7 +617,7 @@ static struct clk usb_clko = {	/* 6 MHz output on W4_USB_CLKO */
 	/* Direct from ULPD, no parent */
 	.rate		= 6000000,
 	.flags		= CLOCK_IN_OMAP1510 | CLOCK_IN_OMAP16XX |
-			  CLOCK_IN_OMAP310 | RATE_FIXED | ENABLE_REG_32BIT,
+			  CLOCK_IN_OMAP310 | ENABLE_REG_32BIT,
 	.enable_reg	= OMAP1_IO_ADDRESS(ULPD_CLOCK_CTRL),
 	.enable_bit	= USB_MCLK_EN_BIT,
 	.enable		= &omap1_clk_enable_generic,
@@ -630,7 +629,7 @@ static struct clk usb_hhc_ck1510 = {
 	/* Direct from ULPD, no parent */
 	.rate		= 48000000, /* Actually 2 clocks, 12MHz and 48MHz */
 	.flags		= CLOCK_IN_OMAP1510 | CLOCK_IN_OMAP310 |
-			  RATE_FIXED | ENABLE_REG_32BIT,
+			  ENABLE_REG_32BIT,
 	.enable_reg	= OMAP1_IO_ADDRESS(MOD_CONF_CTRL_0),
 	.enable_bit	= USB_HOST_HHC_UHOST_EN,
 	.enable		= &omap1_clk_enable_generic,
@@ -642,8 +641,7 @@ static struct clk usb_hhc_ck16xx = {
 	/* Direct from ULPD, no parent */
 	.rate		= 48000000,
 	/* OTG_SYSCON_2.OTG_PADEN == 0 (not 1510-compatible) */
-	.flags		= CLOCK_IN_OMAP16XX |
-			  RATE_FIXED | ENABLE_REG_32BIT,
+	.flags		= CLOCK_IN_OMAP16XX | ENABLE_REG_32BIT,
 	.enable_reg	= OMAP1_IO_ADDRESS(OTG_BASE + 0x08), /* OTG_SYSCON_2 */
 	.enable_bit	= 8 /* UHOST_EN */,
 	.enable		= &omap1_clk_enable_generic,
@@ -654,7 +652,7 @@ static struct clk usb_dc_ck = {
 	.name		= "usb_dc_ck",
 	/* Direct from ULPD, no parent */
 	.rate		= 48000000,
-	.flags		= CLOCK_IN_OMAP16XX | RATE_FIXED,
+	.flags		= CLOCK_IN_OMAP16XX,
 	.enable_reg	= OMAP1_IO_ADDRESS(SOFT_REQ_REG),
 	.enable_bit	= 4,
 	.enable		= &omap1_clk_enable_generic,
@@ -665,7 +663,7 @@ static struct clk mclk_1510 = {
 	.name		= "mclk",
 	/* Direct from ULPD, no parent. May be enabled by ext hardware. */
 	.rate		= 12000000,
-	.flags		= CLOCK_IN_OMAP1510 | CLOCK_IN_OMAP310 | RATE_FIXED,
+	.flags		= CLOCK_IN_OMAP1510 | CLOCK_IN_OMAP310,
 	.enable_reg	= OMAP1_IO_ADDRESS(SOFT_REQ_REG),
 	.enable_bit	= 6,
 	.enable		= &omap1_clk_enable_generic,
@@ -689,7 +687,7 @@ static struct clk bclk_1510 = {
 	.name		= "bclk",
 	/* Direct from ULPD, no parent. May be enabled by ext hardware. */
 	.rate		= 12000000,
-	.flags		= CLOCK_IN_OMAP1510 | CLOCK_IN_OMAP310 | RATE_FIXED,
+	.flags		= CLOCK_IN_OMAP1510 | CLOCK_IN_OMAP310,
 	.enable		= &omap1_clk_enable_generic,
 	.disable	= &omap1_clk_disable_generic,
 };
@@ -713,7 +711,7 @@ static struct clk mmc1_ck = {
 	.parent		= &armper_ck.clk,
 	.rate		= 48000000,
 	.flags		= CLOCK_IN_OMAP1510 | CLOCK_IN_OMAP16XX |
-			  CLOCK_IN_OMAP310 | RATE_FIXED | ENABLE_REG_32BIT |
+			  CLOCK_IN_OMAP310 | ENABLE_REG_32BIT |
 			  CLOCK_NO_IDLE_PARENT,
 	.enable_reg	= OMAP1_IO_ADDRESS(MOD_CONF_CTRL_0),
 	.enable_bit	= 23,
@@ -727,8 +725,8 @@ static struct clk mmc2_ck = {
 	/* Functional clock is direct from ULPD, interface clock is ARMPER */
 	.parent		= &armper_ck.clk,
 	.rate		= 48000000,
-	.flags		= CLOCK_IN_OMAP16XX |
-			  RATE_FIXED | ENABLE_REG_32BIT | CLOCK_NO_IDLE_PARENT,
+	.flags		= CLOCK_IN_OMAP16XX | ENABLE_REG_32BIT |
+			  CLOCK_NO_IDLE_PARENT,
 	.enable_reg	= OMAP1_IO_ADDRESS(MOD_CONF_CTRL_0),
 	.enable_bit	= 20,
 	.enable		= &omap1_clk_enable_generic,
@@ -738,7 +736,7 @@ static struct clk mmc2_ck = {
 static struct clk virtual_ck_mpu = {
 	.name		= "mpu",
 	.flags		= CLOCK_IN_OMAP1510 | CLOCK_IN_OMAP16XX |
-			  CLOCK_IN_OMAP310 | VIRTUAL_CLOCK | ALWAYS_ENABLED,
+			  CLOCK_IN_OMAP310 | ALWAYS_ENABLED,
 	.parent		= &arm_ck, /* Is smarter alias for */
 	.recalc		= &followparent_recalc,
 	.set_rate	= &omap1_select_table_rate,
@@ -753,8 +751,7 @@ static struct clk i2c_fck = {
 	.name		= "i2c_fck",
 	.id		= 1,
 	.flags		= CLOCK_IN_OMAP310 | CLOCK_IN_OMAP1510 | CLOCK_IN_OMAP16XX |
-			  VIRTUAL_CLOCK | CLOCK_NO_IDLE_PARENT |
-			  ALWAYS_ENABLED,
+			  CLOCK_NO_IDLE_PARENT | ALWAYS_ENABLED,
 	.parent		= &armxor_ck.clk,
 	.recalc		= &followparent_recalc,
 	.enable		= &omap1_clk_enable_generic,
@@ -764,8 +761,7 @@ static struct clk i2c_fck = {
 static struct clk i2c_ick = {
 	.name		= "i2c_ick",
 	.id		= 1,
-	.flags		= CLOCK_IN_OMAP16XX |
-			  VIRTUAL_CLOCK | CLOCK_NO_IDLE_PARENT |
+	.flags		= CLOCK_IN_OMAP16XX | CLOCK_NO_IDLE_PARENT |
 			  ALWAYS_ENABLED,
 	.parent		= &armper_ck.clk,
 	.recalc		= &followparent_recalc,
diff --git a/arch/arm/mach-omap2/clock.c b/arch/arm/mach-omap2/clock.c
index 6ca67cb..07b6232 100644
--- a/arch/arm/mach-omap2/clock.c
+++ b/arch/arm/mach-omap2/clock.c
@@ -561,8 +561,6 @@ static const struct clksel *omap2_get_clksel_by_parent(struct clk *clk,
  *
  * Finds 'best' divider value in an array based on the source and target
  * rates.  The divider array must be sorted with smallest divider first.
- * Note that this will not work for clocks which are part of CONFIG_PARTICIPANT,
- * they are only settable as part of virtual_prcm set.
  *
  * Returns the rounded clock rate or returns 0xffffffff on error.
  */
@@ -623,8 +621,6 @@ u32 omap2_clksel_round_rate_div(struct clk *clk, unsigned long target_rate,
  * Compatibility wrapper for OMAP clock framework
  * Finds best target rate based on the source clock and possible dividers.
  * rates. The divider array must be sorted with smallest divider first.
- * Note that this will not work for clocks which are part of CONFIG_PARTICIPANT,
- * they are only settable as part of virtual_prcm set.
  *
  * Returns the rounded clock rate or returns 0xffffffff on error.
  */
@@ -642,10 +638,6 @@ long omap2_clk_round_rate(struct clk *clk, unsigned long rate)
 	if (clk->round_rate)
 		return clk->round_rate(clk, rate);
 
-	if (clk->flags & RATE_FIXED)
-		printk(KERN_ERR "clock: generic omap2_clk_round_rate called "
-		       "on fixed-rate clock %s\n", clk->name);
-
 	return clk->rate;
 }
 
@@ -780,12 +772,6 @@ int omap2_clk_set_rate(struct clk *clk, unsigned long rate)
 
 	pr_debug("clock: set_rate for clock %s to rate %ld\n", clk->name, rate);
 
-	/* CONFIG_PARTICIPANT clocks are changed only in sets via the
-	   rate table mechanism, driven by mpu_speed  */
-	if (clk->flags & CONFIG_PARTICIPANT)
-		return -EINVAL;
-
-	/* dpll_ck, core_ck, virt_prcm_set; plus all clksel clocks */
 	if (clk->set_rate)
 		ret = clk->set_rate(clk, rate);
 
@@ -830,9 +816,6 @@ int omap2_clk_set_parent(struct clk *clk, struct clk *new_parent)
 {
 	u32 field_val, v, parent_div;
 
-	if (clk->flags & CONFIG_PARTICIPANT)
-		return -EINVAL;
-
 	if (!clk->clksel)
 		return -EINVAL;
 
diff --git a/arch/arm/mach-omap2/clock24xx.h b/arch/arm/mach-omap2/clock24xx.h
index cd9feda..2b7b473 100644
--- a/arch/arm/mach-omap2/clock24xx.h
+++ b/arch/arm/mach-omap2/clock24xx.h
@@ -628,15 +628,14 @@ static struct clk func_32k_ck = {
 	.name		= "func_32k_ck",
 	.rate		= 32000,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
-				RATE_FIXED | ALWAYS_ENABLED | RATE_PROPAGATES,
+				ALWAYS_ENABLED,
 	.clkdm		= { .name = "prm_clkdm" },
 };
 
 /* Typical 12/13MHz in standalone mode, will be 26Mhz in chassis mode */
 static struct clk osc_ck = {		/* (*12, *13, 19.2, *26, 38.4)MHz */
 	.name		= "osc_ck",
-	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
-				RATE_PROPAGATES,
+	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "prm_clkdm" },
 	.enable		= &omap2_enable_osc_ck,
 	.disable	= &omap2_disable_osc_ck,
@@ -648,7 +647,7 @@ static struct clk sys_ck = {		/* (*12, *13, 19.2, 26, 38.4)MHz */
 	.name		= "sys_ck",		/* ~ ref_clk also */
 	.parent		= &osc_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
-				ALWAYS_ENABLED | RATE_PROPAGATES,
+				ALWAYS_ENABLED,
 	.clkdm		= { .name = "prm_clkdm" },
 	.recalc		= &omap2_sys_clk_recalc,
 };
@@ -657,7 +656,7 @@ static struct clk alt_ck = {		/* Typical 54M or 48M, may not exist */
 	.name		= "alt_ck",
 	.rate		= 54000000,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
-				RATE_FIXED | ALWAYS_ENABLED | RATE_PROPAGATES,
+				ALWAYS_ENABLED,
 	.clkdm		= { .name = "prm_clkdm" },
 };
 
@@ -692,7 +691,7 @@ static struct clk dpll_ck = {
 	.prcm_mod	= PLL_MOD,
 	.dpll_data	= &dpll_dd,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
-				RATE_PROPAGATES | ALWAYS_ENABLED,
+				ALWAYS_ENABLED,
 	.clkdm		= { .name = "prm_clkdm" },
 	.recalc		= &omap2_dpllcore_recalc,
 	.set_rate	= &omap2_reprogram_dpllcore,
@@ -704,7 +703,7 @@ static struct clk apll96_ck = {
 	.prcm_mod	= PLL_MOD,
 	.rate		= 96000000,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
-				RATE_FIXED | RATE_PROPAGATES | ENABLE_ON_INIT,
+				ENABLE_ON_INIT,
 	.clkdm		= { .name = "prm_clkdm" },
 	.enable_reg	= CM_CLKEN,
 	.enable_bit	= OMAP24XX_EN_96M_PLL_SHIFT,
@@ -718,7 +717,7 @@ static struct clk apll54_ck = {
 	.prcm_mod	= PLL_MOD,
 	.rate		= 54000000,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
-				RATE_FIXED | RATE_PROPAGATES | ENABLE_ON_INIT,
+				ENABLE_ON_INIT,
 	.clkdm		= { .name = "prm_clkdm" },
 	.enable_reg	= CM_CLKEN,
 	.enable_bit	= OMAP24XX_EN_54M_PLL_SHIFT,
@@ -753,7 +752,7 @@ static struct clk func_54m_ck = {
 	.parent		= &apll54_ck,	/* can also be alt_clk */
 	.prcm_mod	= PLL_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
-				RATE_PROPAGATES | PARENT_CONTROLS_CLOCK,
+				PARENT_CONTROLS_CLOCK,
 	.clkdm		= { .name = "cm_clkdm" },
 	.init		= &omap2_init_clksel_parent,
 	.clksel_reg	= CM_CLKSEL1,
@@ -766,7 +765,7 @@ static struct clk core_ck = {
 	.name		= "core_ck",
 	.parent		= &dpll_ck,		/* can also be 32k */
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
-				ALWAYS_ENABLED | RATE_PROPAGATES,
+				ALWAYS_ENABLED,
 	.clkdm		= { .name = "cm_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -794,7 +793,7 @@ static struct clk func_96m_ck = {
 	.parent		= &apll96_ck,
 	.prcm_mod	= PLL_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
-				RATE_PROPAGATES | PARENT_CONTROLS_CLOCK,
+				PARENT_CONTROLS_CLOCK,
 	.clkdm		= { .name = "cm_clkdm" },
 	.init		= &omap2_init_clksel_parent,
 	.clksel_reg	= CM_CLKSEL1,
@@ -828,7 +827,7 @@ static struct clk func_48m_ck = {
 	.parent		= &apll96_ck,	 /* 96M or Alt */
 	.prcm_mod	= PLL_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
-				RATE_PROPAGATES | PARENT_CONTROLS_CLOCK,
+				PARENT_CONTROLS_CLOCK,
 	.clkdm		= { .name = "cm_clkdm" },
 	.init		= &omap2_init_clksel_parent,
 	.clksel_reg	= CM_CLKSEL1,
@@ -844,7 +843,7 @@ static struct clk func_12m_ck = {
 	.parent		= &func_48m_ck,
 	.fixed_div	= 4,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
-				RATE_PROPAGATES | PARENT_CONTROLS_CLOCK,
+				PARENT_CONTROLS_CLOCK,
 	.clkdm		= { .name = "cm_clkdm" },
 	.recalc		= &omap2_fixed_divisor_recalc,
 };
@@ -898,8 +897,7 @@ static struct clk sys_clkout_src = {
 	.name		= "sys_clkout_src",
 	.parent		= &func_54m_ck,
 	.prcm_mod	= OMAP24XX_GR_MOD,
-	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
-				RATE_PROPAGATES,
+	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "prm_clkdm" },
 	.enable_reg	= OMAP24XX_PRCM_CLKOUT_CTRL_OFFSET,
 	.enable_bit	= OMAP24XX_CLKOUT_EN_SHIFT,
@@ -946,7 +944,7 @@ static struct clk sys_clkout2_src = {
 	.name		= "sys_clkout2_src",
 	.parent		= &func_54m_ck,
 	.prcm_mod	= OMAP24XX_GR_MOD,
-	.flags		= CLOCK_IN_OMAP242X | RATE_PROPAGATES,
+	.flags		= CLOCK_IN_OMAP242X,
 	.clkdm		= { .name = "cm_clkdm" },
 	.enable_reg	= OMAP24XX_PRCM_CLKOUT_CTRL_OFFSET,
 	.enable_bit	= OMAP2420_CLKOUT2_EN_SHIFT,
@@ -1020,16 +1018,13 @@ static struct clk mpu_ck = {	/* Control cpu */
 	.parent		= &core_ck,
 	.prcm_mod	= MPU_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
-				ALWAYS_ENABLED | DELAYED_APP |
-				CONFIG_PARTICIPANT | RATE_PROPAGATES,
+				ALWAYS_ENABLED | DELAYED_APP,
 	.clkdm		= { .name = "mpu_clkdm" },
 	.init		= &omap2_init_clksel_parent,
 	.clksel_reg	= CM_CLKSEL,
 	.clksel_mask	= OMAP24XX_CLKSEL_MPU_MASK,
 	.clksel		= mpu_clksel,
 	.recalc		= &omap2_clksel_recalc,
-	.round_rate	= &omap2_clksel_round_rate,
-	.set_rate	= &omap2_clksel_set_rate
 };
 
 /*
@@ -1063,8 +1058,7 @@ static struct clk dsp_fck = {
 	.name		= "dsp_fck",
 	.parent		= &core_ck,
 	.prcm_mod	= OMAP24XX_DSP_MOD,
-	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X | DELAYED_APP |
-				CONFIG_PARTICIPANT | RATE_PROPAGATES,
+	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X | DELAYED_APP,
 	.clkdm		= { .name = "dsp_clkdm" },
 	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP24XX_CM_FCLKEN_DSP_EN_DSP_SHIFT,
@@ -1072,8 +1066,6 @@ static struct clk dsp_fck = {
 	.clksel_mask	= OMAP24XX_CLKSEL_DSP_MASK,
 	.clksel		= dsp_fck_clksel,
 	.recalc		= &omap2_clksel_recalc,
-	.round_rate	= &omap2_clksel_round_rate,
-	.set_rate	= &omap2_clksel_set_rate
 };
 
 /* DSP interface clock */
@@ -1095,14 +1087,12 @@ static struct clk dsp_irate_ick = {
 	.parent		= &dsp_fck,
 	.prcm_mod	= OMAP24XX_DSP_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X | DELAYED_APP |
-				CONFIG_PARTICIPANT | PARENT_CONTROLS_CLOCK,
+				PARENT_CONTROLS_CLOCK,
 	.clkdm		= { .name = "dsp_clkdm" },
 	.clksel_reg	= CM_CLKSEL,
 	.clksel_mask	= OMAP24XX_CLKSEL_DSP_IF_MASK,
 	.clksel		= dsp_irate_ick_clksel,
 	.recalc		= &omap2_clksel_recalc,
-	.round_rate	= &omap2_clksel_round_rate,
-	.set_rate	= &omap2_clksel_set_rate
 };
 
 /* 2420 only */
@@ -1110,7 +1100,7 @@ static struct clk dsp_ick = {
 	.name		= "dsp_ick",	 /* apparently ipi and isp */
 	.parent		= &dsp_irate_ick,
 	.prcm_mod	= OMAP24XX_DSP_MOD,
-	.flags		= CLOCK_IN_OMAP242X | DELAYED_APP | CONFIG_PARTICIPANT,
+	.flags		= CLOCK_IN_OMAP242X | DELAYED_APP,
 	.clkdm		= { .name = "dsp_clkdm" },
 	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP2420_EN_DSP_IPI_SHIFT,	      /* for ipi */
@@ -1121,7 +1111,7 @@ static struct clk iva2_1_ick = {
 	.name		= "iva2_1_ick",
 	.parent		= &dsp_irate_ick,
 	.prcm_mod	= OMAP24XX_DSP_MOD,
-	.flags		= CLOCK_IN_OMAP243X | DELAYED_APP | CONFIG_PARTICIPANT,
+	.flags		= CLOCK_IN_OMAP243X | DELAYED_APP,
 	.clkdm		= { .name = "dsp_clkdm" },
 	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP24XX_CM_FCLKEN_DSP_EN_DSP_SHIFT,
@@ -1136,8 +1126,7 @@ static struct clk iva1_ifck = {
 	.name		= "iva1_ifck",
 	.parent		= &core_ck,
 	.prcm_mod	= OMAP24XX_DSP_MOD,
-	.flags		= CLOCK_IN_OMAP242X | CONFIG_PARTICIPANT |
-				RATE_PROPAGATES | DELAYED_APP,
+	.flags		= CLOCK_IN_OMAP242X | DELAYED_APP,
 	.clkdm		= { .name = "iva1_clkdm" },
 	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP2420_EN_IVA_COP_SHIFT,
@@ -1202,15 +1191,12 @@ static struct clk core_l3_ck = {	/* Used for ick and fck, interconnect */
 	.parent		= &core_ck,
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
-				ALWAYS_ENABLED | DELAYED_APP |
-				CONFIG_PARTICIPANT | RATE_PROPAGATES,
+				ALWAYS_ENABLED | DELAYED_APP,
 	.clkdm		= { .name = "core_l3_clkdm" },
 	.clksel_reg	= CM_CLKSEL1,
 	.clksel_mask	= OMAP24XX_CLKSEL_L3_MASK,
 	.clksel		= core_l3_clksel,
 	.recalc		= &omap2_clksel_recalc,
-	.round_rate	= &omap2_clksel_round_rate,
-	.set_rate	= &omap2_clksel_set_rate
 };
 
 /* usb_l4_ick */
@@ -1231,8 +1217,8 @@ static struct clk usb_l4_ick = {	/* FS-USB interface clock */
 	.name		= "usb_l4_ick",
 	.parent		= &core_l3_ck,
 	.prcm_mod	= CORE_MOD,
-	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
-				DELAYED_APP | CONFIG_PARTICIPANT | WAIT_READY,
+	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X | WAIT_READY |
+				DELAYED_APP,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= CM_ICLKEN2,
 	.enable_bit	= OMAP24XX_EN_USB_SHIFT,
@@ -1241,8 +1227,6 @@ static struct clk usb_l4_ick = {	/* FS-USB interface clock */
 	.clksel_mask	= OMAP24XX_CLKSEL_USB_MASK,
 	.clksel		= usb_l4_ick_clksel,
 	.recalc		= &omap2_clksel_recalc,
-	.round_rate	= &omap2_clksel_round_rate,
-	.set_rate	= &omap2_clksel_set_rate
 };
 
 /*
@@ -1268,7 +1252,7 @@ static struct clk l4_ck = {		/* used both as an ick and fck */
 	.parent		= &core_l3_ck,
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
-				ALWAYS_ENABLED | DELAYED_APP | RATE_PROPAGATES,
+				ALWAYS_ENABLED | DELAYED_APP,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.clksel_reg	= CM_CLKSEL1,
 	.clksel_mask	= OMAP24XX_CLKSEL_L4_MASK,
@@ -1348,7 +1332,7 @@ static struct clk ssi_l4_ick = {
  * divided value of fclk.
  *
  */
-/* XXX REVISIT: GFX clock is part of CONFIG_PARTICIPANT, no? doublecheck. */
+/* XXX REVISIT: GFX clock is part of the table rate set also? doublecheck. */
 
 /* This clksel struct is shared between gfx_3d_fck and gfx_2d_fck */
 static const struct clksel gfx_fck_clksel[] = {
@@ -1423,7 +1407,7 @@ static struct clk mdm_ick = {		/* used both as a ick and fck */
 	.name		= "mdm_ick",
 	.parent		= &core_ck,
 	.prcm_mod	= OMAP2430_MDM_MOD,
-	.flags		= CLOCK_IN_OMAP243X | DELAYED_APP | CONFIG_PARTICIPANT,
+	.flags		= CLOCK_IN_OMAP243X | DELAYED_APP,
 	.clkdm		= { .name = "mdm_clkdm" },
 	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP2430_CM_ICLKEN_MDM_EN_MDM_SHIFT,
@@ -1431,8 +1415,6 @@ static struct clk mdm_ick = {		/* used both as a ick and fck */
 	.clksel_mask	= OMAP2430_CLKSEL_MDM_MASK,
 	.clksel		= mdm_ick_clksel,
 	.recalc		= &omap2_clksel_recalc,
-	.round_rate	= &omap2_clksel_round_rate,
-	.set_rate	= &omap2_clksel_set_rate
 };
 
 static struct clk mdm_osc_ck = {
@@ -2848,7 +2830,7 @@ static struct clk mmchsdb2_fck = {
 static struct clk virt_prcm_set = {
 	.name		= "virt_prcm_set",
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
-				VIRTUAL_CLOCK | ALWAYS_ENABLED | DELAYED_APP,
+				ALWAYS_ENABLED | DELAYED_APP,
 	.clkdm		= { .name = "virt_opp_clkdm" },
 	.parent		= &mpu_ck,	/* Indexed by mpu speed, no parent */
 	.recalc		= &omap2_table_mpu_recalc,	/* sets are keyed on mpu rate */
diff --git a/arch/arm/mach-omap2/clock34xx.h b/arch/arm/mach-omap2/clock34xx.h
index 283c386..179ea17 100644
--- a/arch/arm/mach-omap2/clock34xx.h
+++ b/arch/arm/mach-omap2/clock34xx.h
@@ -66,16 +66,14 @@ static struct clk dpll2_fck;
 static struct clk omap_32k_fck = {
 	.name		= "omap_32k_fck",
 	.rate		= 32768,
-	.flags		= CLOCK_IN_OMAP343X | RATE_FIXED | RATE_PROPAGATES |
-				ALWAYS_ENABLED,
+	.flags		= CLOCK_IN_OMAP343X | ALWAYS_ENABLED,
 	.clkdm		= { .name = "prm_clkdm" },
 };
 
 static struct clk secure_32k_fck = {
 	.name		= "secure_32k_fck",
 	.rate		= 32768,
-	.flags		= CLOCK_IN_OMAP343X | RATE_FIXED | RATE_PROPAGATES |
-				ALWAYS_ENABLED,
+	.flags		= CLOCK_IN_OMAP343X | ALWAYS_ENABLED,
 	.clkdm		= { .name = "prm_clkdm" },
 };
 
@@ -83,48 +81,42 @@ static struct clk secure_32k_fck = {
 static struct clk virt_12m_ck = {
 	.name		= "virt_12m_ck",
 	.rate		= 12000000,
-	.flags		= CLOCK_IN_OMAP343X | RATE_FIXED | RATE_PROPAGATES |
-				ALWAYS_ENABLED,
+	.flags		= CLOCK_IN_OMAP343X | ALWAYS_ENABLED,
 	.clkdm		= { .name = "prm_clkdm" },
 };
 
 static struct clk virt_13m_ck = {
 	.name		= "virt_13m_ck",
 	.rate		= 13000000,
-	.flags		= CLOCK_IN_OMAP343X | RATE_FIXED | RATE_PROPAGATES |
-				ALWAYS_ENABLED,
+	.flags		= CLOCK_IN_OMAP343X | ALWAYS_ENABLED,
 	.clkdm		= { .name = "prm_clkdm" },
 };
 
 static struct clk virt_16_8m_ck = {
 	.name		= "virt_16_8m_ck",
 	.rate		= 16800000,
-	.flags		= CLOCK_IN_OMAP3430ES2 | RATE_FIXED | RATE_PROPAGATES |
-				ALWAYS_ENABLED,
+	.flags		= CLOCK_IN_OMAP3430ES2 | ALWAYS_ENABLED,
 	.clkdm		= { .name = "prm_clkdm" },
 };
 
 static struct clk virt_19_2m_ck = {
 	.name		= "virt_19_2m_ck",
 	.rate		= 19200000,
-	.flags		= CLOCK_IN_OMAP343X | RATE_FIXED | RATE_PROPAGATES |
-				ALWAYS_ENABLED,
+	.flags		= CLOCK_IN_OMAP343X | ALWAYS_ENABLED,
 	.clkdm		= { .name = "prm_clkdm" },
 };
 
 static struct clk virt_26m_ck = {
 	.name		= "virt_26m_ck",
 	.rate		= 26000000,
-	.flags		= CLOCK_IN_OMAP343X | RATE_FIXED | RATE_PROPAGATES |
-				ALWAYS_ENABLED,
+	.flags		= CLOCK_IN_OMAP343X | ALWAYS_ENABLED,
 	.clkdm		= { .name = "prm_clkdm" },
 };
 
 static struct clk virt_38_4m_ck = {
 	.name		= "virt_38_4m_ck",
 	.rate		= 38400000,
-	.flags		= CLOCK_IN_OMAP343X | RATE_FIXED | RATE_PROPAGATES |
-				ALWAYS_ENABLED,
+	.flags		= CLOCK_IN_OMAP343X | ALWAYS_ENABLED,
 	.clkdm		= { .name = "prm_clkdm" },
 };
 
@@ -178,8 +170,7 @@ static struct clk osc_sys_ck = {
 	.clksel_mask	= OMAP3430_SYS_CLKIN_SEL_MASK,
 	.clksel		= osc_sys_clksel,
 	/* REVISIT: deal with autoextclkmode? */
-	.flags		= CLOCK_IN_OMAP343X | RATE_FIXED | RATE_PROPAGATES |
-				ALWAYS_ENABLED,
+	.flags		= CLOCK_IN_OMAP343X | ALWAYS_ENABLED,
 	.clkdm		= { .name = "prm_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
@@ -205,14 +196,14 @@ static struct clk sys_ck = {
 	.clksel_reg	= OMAP3_PRM_CLKSRC_CTRL_OFFSET,
 	.clksel_mask	= OMAP_SYSCLKDIV_MASK,
 	.clksel		= sys_clksel,
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | ALWAYS_ENABLED,
+	.flags		= CLOCK_IN_OMAP343X | ALWAYS_ENABLED,
 	.clkdm		= { .name = "prm_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
 
 static struct clk sys_altclk = {
 	.name		= "sys_altclk",
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | ALWAYS_ENABLED,
+	.flags		= CLOCK_IN_OMAP343X | ALWAYS_ENABLED,
 	.clkdm		= { .name = "cm_clkdm" },
 };
 
@@ -223,7 +214,7 @@ static struct clk sys_altclk = {
  */
 static struct clk mcbsp_clks = {
 	.name		= "mcbsp_clks",
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | ALWAYS_ENABLED,
+	.flags		= CLOCK_IN_OMAP343X | ALWAYS_ENABLED,
 	.clkdm		= { .name = "prm_clkdm" },
 };
 
@@ -294,8 +285,7 @@ static struct clk dpll1_ck = {
 	.parent		= &sys_ck,
 	.prcm_mod	= MPU_MOD,
 	.dpll_data	= &dpll1_dd,
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
-			  ALWAYS_ENABLED | RECALC_ON_ENABLE,
+	.flags		= CLOCK_IN_OMAP343X | ALWAYS_ENABLED | RECALC_ON_ENABLE,
 	.round_rate	= &omap2_dpll_round_rate,
 	.set_rate	= &omap3_noncore_dpll_set_rate,
 	.clkdm		= { .name = "dpll1_clkdm" },
@@ -309,8 +299,7 @@ static struct clk dpll1_ck = {
 static struct clk dpll1_x2_ck = {
 	.name		= "dpll1_x2_ck",
 	.parent		= &dpll1_ck,
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
-				PARENT_CONTROLS_CLOCK,
+	.flags		= CLOCK_IN_OMAP343X | PARENT_CONTROLS_CLOCK,
 	.clkdm		= { .name = "dpll1_clkdm" },
 	.recalc		= &omap3_clkoutx2_recalc,
 };
@@ -333,8 +322,7 @@ static struct clk dpll1_x2m2_ck = {
 	.clksel_reg	= OMAP3430_CM_CLKSEL2_PLL,
 	.clksel_mask	= OMAP3430_MPU_DPLL_CLKOUT_DIV_MASK,
 	.clksel		= div16_dpll1_x2m2_clksel,
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
-				PARENT_CONTROLS_CLOCK,
+	.flags		= CLOCK_IN_OMAP343X | PARENT_CONTROLS_CLOCK,
 	.clkdm		= { .name = "dpll1_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
@@ -371,8 +359,7 @@ static struct clk dpll2_ck = {
 	.parent		= &sys_ck,
 	.prcm_mod	= OMAP3430_IVA2_MOD,
 	.dpll_data	= &dpll2_dd,
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
-			  RECALC_ON_ENABLE,
+	.flags		= CLOCK_IN_OMAP343X | RECALC_ON_ENABLE,
 	.enable		= &omap3_noncore_dpll_enable,
 	.disable	= &omap3_noncore_dpll_disable,
 	.round_rate	= &omap2_dpll_round_rate,
@@ -398,8 +385,7 @@ static struct clk dpll2_m2_ck = {
 	.clksel_reg	= OMAP3430_CM_CLKSEL2_PLL,
 	.clksel_mask	= OMAP3430_IVA2_DPLL_CLKOUT_DIV_MASK,
 	.clksel		= div16_dpll2_m2x2_clksel,
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
-				PARENT_CONTROLS_CLOCK,
+	.flags		= CLOCK_IN_OMAP343X | PARENT_CONTROLS_CLOCK,
 	.clkdm		= { .name = "dpll2_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
@@ -435,8 +421,7 @@ static struct clk dpll3_ck = {
 	.parent		= &sys_ck,
 	.prcm_mod	= PLL_MOD,
 	.dpll_data	= &dpll3_dd,
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
-			  ALWAYS_ENABLED | RECALC_ON_ENABLE,
+	.flags		= CLOCK_IN_OMAP343X | ALWAYS_ENABLED | RECALC_ON_ENABLE,
 	.round_rate	= &omap2_dpll_round_rate,
 	.clkdm		= { .name = "dpll3_clkdm" },
 	.recalc		= &omap3_dpll_recalc,
@@ -449,8 +434,7 @@ static struct clk dpll3_ck = {
 static struct clk dpll3_x2_ck = {
 	.name		= "dpll3_x2_ck",
 	.parent		= &dpll3_ck,
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
-				PARENT_CONTROLS_CLOCK,
+	.flags		= CLOCK_IN_OMAP343X | PARENT_CONTROLS_CLOCK,
 	.clkdm		= { .name = "dpll3_clkdm" },
 	.recalc		= &omap3_clkoutx2_recalc,
 };
@@ -504,8 +488,7 @@ static struct clk dpll3_m2_ck = {
 	.clksel_reg	= CM_CLKSEL1,
 	.clksel_mask	= OMAP3430_CORE_DPLL_CLKOUT_DIV_MASK,
 	.clksel		= div31_dpll3m2_clksel,
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
-				PARENT_CONTROLS_CLOCK,
+	.flags		= CLOCK_IN_OMAP343X | PARENT_CONTROLS_CLOCK,
 	.clkdm		= { .name = "dpll3_clkdm" },
 	.round_rate	= &omap2_clksel_round_rate,
 	.set_rate	= &omap3_core_dpll_m2_set_rate,
@@ -515,8 +498,7 @@ static struct clk dpll3_m2_ck = {
 static struct clk core_ck = {
 	.name		= "core_ck",
 	.parent		= &dpll3_m2_ck,
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
-				PARENT_CONTROLS_CLOCK,
+	.flags		= CLOCK_IN_OMAP343X | PARENT_CONTROLS_CLOCK,
 	.clkdm		= { .name = "cm_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -524,8 +506,7 @@ static struct clk core_ck = {
 static struct clk dpll3_m2x2_ck = {
 	.name		= "dpll3_m2x2_ck",
 	.parent		= &dpll3_x2_ck,
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
-				PARENT_CONTROLS_CLOCK,
+	.flags		= CLOCK_IN_OMAP343X | PARENT_CONTROLS_CLOCK,
 	.clkdm		= { .name = "dpll3_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -545,8 +526,7 @@ static struct clk dpll3_m3_ck = {
 	.clksel_reg	= CM_CLKSEL1,
 	.clksel_mask	= OMAP3430_DIV_DPLL3_MASK,
 	.clksel		= div16_dpll3_clksel,
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
-				PARENT_CONTROLS_CLOCK,
+	.flags		= CLOCK_IN_OMAP343X | PARENT_CONTROLS_CLOCK,
 	.clkdm		= { .name = "dpll3_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
@@ -558,7 +538,7 @@ static struct clk dpll3_m3x2_ck = {
 	.prcm_mod	= PLL_MOD,
 	.enable_reg	= CM_CLKEN,
 	.enable_bit	= OMAP3430_PWRDN_EMU_CORE_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | INVERT_ENABLE,
+	.flags		= CLOCK_IN_OMAP343X | INVERT_ENABLE,
 	.clkdm		= { .name = "dpll3_clkdm" },
 	.recalc		= &omap3_clkoutx2_recalc,
 };
@@ -566,8 +546,7 @@ static struct clk dpll3_m3x2_ck = {
 static struct clk emu_core_alwon_ck = {
 	.name		= "emu_core_alwon_ck",
 	.parent		= &dpll3_m3x2_ck,
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
-				PARENT_CONTROLS_CLOCK,
+	.flags		= CLOCK_IN_OMAP343X | PARENT_CONTROLS_CLOCK,
 	.clkdm		= { .name = "dpll3_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -602,8 +581,7 @@ static struct clk dpll4_ck = {
 	.parent		= &sys_ck,
 	.prcm_mod	= PLL_MOD,
 	.dpll_data	= &dpll4_dd,
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
-			  RECALC_ON_ENABLE,
+	.flags		= CLOCK_IN_OMAP343X | RECALC_ON_ENABLE,
 	.enable		= &omap3_noncore_dpll_enable,
 	.disable	= &omap3_noncore_dpll_disable,
 	.round_rate	= &omap2_dpll_round_rate,
@@ -620,8 +598,7 @@ static struct clk dpll4_ck = {
 static struct clk dpll4_x2_ck = {
 	.name		= "dpll4_x2_ck",
 	.parent		= &dpll4_ck,
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
-				PARENT_CONTROLS_CLOCK,
+	.flags		= CLOCK_IN_OMAP343X | PARENT_CONTROLS_CLOCK,
 	.clkdm		= { .name = "dpll4_clkdm" },
 	.recalc		= &omap3_clkoutx2_recalc,
 };
@@ -640,8 +617,7 @@ static struct clk dpll4_m2_ck = {
 	.clksel_reg	= OMAP3430_CM_CLKSEL3,
 	.clksel_mask	= OMAP3430_DIV_96M_MASK,
 	.clksel		= div16_dpll4_clksel,
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
-				PARENT_CONTROLS_CLOCK,
+	.flags		= CLOCK_IN_OMAP343X | PARENT_CONTROLS_CLOCK,
 	.clkdm		= { .name = "dpll4_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
@@ -653,7 +629,7 @@ static struct clk dpll4_m2x2_ck = {
 	.prcm_mod	= PLL_MOD,
 	.enable_reg	= CM_CLKEN,
 	.enable_bit	= OMAP3430_PWRDN_96M_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | INVERT_ENABLE,
+	.flags		= CLOCK_IN_OMAP343X | INVERT_ENABLE,
 	.clkdm		= { .name = "dpll4_clkdm" },
 	.recalc		= &omap3_clkoutx2_recalc,
 };
@@ -667,8 +643,7 @@ static struct clk dpll4_m2x2_ck = {
 static struct clk omap_96m_alwon_fck = {
 	.name		= "omap_96m_alwon_fck",
 	.parent		= &dpll4_m2x2_ck,
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
-				PARENT_CONTROLS_CLOCK,
+	.flags		= CLOCK_IN_OMAP343X | PARENT_CONTROLS_CLOCK,
 	.clkdm		= { .name = "prm_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -676,8 +651,7 @@ static struct clk omap_96m_alwon_fck = {
 static struct clk cm_96m_fck = {
 	.name		= "cm_96m_fck",
 	.parent		= &omap_96m_alwon_fck,
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
-				PARENT_CONTROLS_CLOCK,
+	.flags		= CLOCK_IN_OMAP343X | PARENT_CONTROLS_CLOCK,
 	.clkdm		= { .name = "cm_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -706,8 +680,7 @@ static struct clk omap_96m_fck = {
 	.clksel_reg	= CM_CLKSEL1,
 	.clksel_mask	= OMAP3430_SOURCE_96M_MASK,
 	.clksel		= omap_96m_fck_clksel,
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
-				PARENT_CONTROLS_CLOCK,
+	.flags		= CLOCK_IN_OMAP343X | PARENT_CONTROLS_CLOCK,
 	.clkdm		= { .name = "cm_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
@@ -721,8 +694,7 @@ static struct clk dpll4_m3_ck = {
 	.clksel_reg	= CM_CLKSEL,
 	.clksel_mask	= OMAP3430_CLKSEL_TV_MASK,
 	.clksel		= div16_dpll4_clksel,
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
-				PARENT_CONTROLS_CLOCK,
+	.flags		= CLOCK_IN_OMAP343X | PARENT_CONTROLS_CLOCK,
 	.clkdm		= { .name = "dpll4_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
@@ -735,7 +707,7 @@ static struct clk dpll4_m3x2_ck = {
 	.init		= &omap2_init_clksel_parent,
 	.enable_reg	= CM_CLKEN,
 	.enable_bit	= OMAP3430_PWRDN_TV_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | INVERT_ENABLE,
+	.flags		= CLOCK_IN_OMAP343X | INVERT_ENABLE,
 	.clkdm		= { .name = "dpll4_clkdm" },
 	.recalc		= &omap3_clkoutx2_recalc,
 };
@@ -763,8 +735,7 @@ static struct clk omap_54m_fck = {
 	.clksel_reg	= CM_CLKSEL1,
 	.clksel_mask	= OMAP3430_SOURCE_54M_MASK,
 	.clksel		= omap_54m_clksel,
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
-				PARENT_CONTROLS_CLOCK,
+	.flags		= CLOCK_IN_OMAP343X | PARENT_CONTROLS_CLOCK,
 	.clkdm		= { .name = "cm_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
@@ -792,8 +763,7 @@ static struct clk omap_48m_fck = {
 	.clksel_reg	= CM_CLKSEL1,
 	.clksel_mask	= OMAP3430_SOURCE_48M_MASK,
 	.clksel		= omap_48m_clksel,
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
-				PARENT_CONTROLS_CLOCK,
+	.flags		= CLOCK_IN_OMAP343X | PARENT_CONTROLS_CLOCK,
 	.clkdm		= { .name = "cm_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
@@ -802,8 +772,7 @@ static struct clk omap_12m_fck = {
 	.name		= "omap_12m_fck",
 	.parent		= &omap_48m_fck,
 	.fixed_div	= 4,
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
-				PARENT_CONTROLS_CLOCK,
+	.flags		= CLOCK_IN_OMAP343X | PARENT_CONTROLS_CLOCK,
 	.clkdm		= { .name = "cm_clkdm" },
 	.recalc		= &omap2_fixed_divisor_recalc,
 };
@@ -817,8 +786,7 @@ static struct clk dpll4_m4_ck = {
 	.clksel_reg	= CM_CLKSEL,
 	.clksel_mask	= OMAP3430_CLKSEL_DSS1_MASK,
 	.clksel		= div16_dpll4_clksel,
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
-				PARENT_CONTROLS_CLOCK,
+	.flags		= CLOCK_IN_OMAP343X | PARENT_CONTROLS_CLOCK,
 	.clkdm		= { .name = "dpll4_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 	.set_rate	= &omap2_clksel_set_rate,
@@ -832,7 +800,7 @@ static struct clk dpll4_m4x2_ck = {
 	.prcm_mod	= PLL_MOD,
 	.enable_reg	= CM_CLKEN,
 	.enable_bit	= OMAP3430_PWRDN_DSS1_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | INVERT_ENABLE,
+	.flags		= CLOCK_IN_OMAP343X | INVERT_ENABLE,
 	.clkdm		= { .name = "dpll4_clkdm" },
 	.recalc		= &omap3_clkoutx2_recalc,
 };
@@ -846,8 +814,7 @@ static struct clk dpll4_m5_ck = {
 	.clksel_reg	= CM_CLKSEL,
 	.clksel_mask	= OMAP3430_CLKSEL_CAM_MASK,
 	.clksel		= div16_dpll4_clksel,
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
-				PARENT_CONTROLS_CLOCK,
+	.flags		= CLOCK_IN_OMAP343X | PARENT_CONTROLS_CLOCK,
 	.clkdm		= { .name = "dpll4_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
@@ -859,7 +826,7 @@ static struct clk dpll4_m5x2_ck = {
 	.prcm_mod	= PLL_MOD,
 	.enable_reg	= CM_CLKEN,
 	.enable_bit	= OMAP3430_PWRDN_CAM_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | INVERT_ENABLE,
+	.flags		= CLOCK_IN_OMAP343X | INVERT_ENABLE,
 	.clkdm		= { .name = "dpll4_clkdm" },
 	.recalc		= &omap3_clkoutx2_recalc,
 };
@@ -873,8 +840,7 @@ static struct clk dpll4_m6_ck = {
 	.clksel_reg	= CM_CLKSEL1,
 	.clksel_mask	= OMAP3430_DIV_DPLL4_MASK,
 	.clksel		= div16_dpll4_clksel,
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
-				PARENT_CONTROLS_CLOCK,
+	.flags		= CLOCK_IN_OMAP343X | PARENT_CONTROLS_CLOCK,
 	.clkdm		= { .name = "dpll4_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
@@ -887,7 +853,7 @@ static struct clk dpll4_m6x2_ck = {
 	.init		= &omap2_init_clksel_parent,
 	.enable_reg	= CM_CLKEN,
 	.enable_bit	= OMAP3430_PWRDN_EMU_PERIPH_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | INVERT_ENABLE,
+	.flags		= CLOCK_IN_OMAP343X | INVERT_ENABLE,
 	.clkdm		= { .name = "dpll4_clkdm" },
 	.recalc		= &omap3_clkoutx2_recalc,
 };
@@ -895,8 +861,7 @@ static struct clk dpll4_m6x2_ck = {
 static struct clk emu_per_alwon_ck = {
 	.name		= "emu_per_alwon_ck",
 	.parent		= &dpll4_m6x2_ck,
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
-				PARENT_CONTROLS_CLOCK,
+	.flags		= CLOCK_IN_OMAP343X | PARENT_CONTROLS_CLOCK,
 	.clkdm		= { .name = "dpll4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -932,8 +897,7 @@ static struct clk dpll5_ck = {
 	.parent		= &sys_ck,
 	.prcm_mod	= PLL_MOD,
 	.dpll_data	= &dpll5_dd,
-	.flags		= CLOCK_IN_OMAP3430ES2 | RATE_PROPAGATES |
-			  RECALC_ON_ENABLE,
+	.flags		= CLOCK_IN_OMAP3430ES2 | RECALC_ON_ENABLE,
 	.enable		= &omap3_noncore_dpll_enable,
 	.disable	= &omap3_noncore_dpll_disable,
 	.round_rate	= &omap2_dpll_round_rate,
@@ -955,8 +919,7 @@ static struct clk dpll5_m2_ck = {
 	.clksel_reg	= OMAP3430ES2_CM_CLKSEL5,
 	.clksel_mask	= OMAP3430ES2_DIV_120M_MASK,
 	.clksel		= div16_dpll5_clksel,
-	.flags		= CLOCK_IN_OMAP3430ES2 | RATE_PROPAGATES |
-				PARENT_CONTROLS_CLOCK,
+	.flags		= CLOCK_IN_OMAP3430ES2 | PARENT_CONTROLS_CLOCK,
 	.clkdm		= { .name = "dpll5_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
@@ -1000,7 +963,7 @@ static struct clk clkout2_src_ck = {
 	.clksel_reg	= OMAP3430_CM_CLKOUT_CTRL_OFFSET,
 	.clksel_mask	= OMAP3430_CLKOUT2SOURCE_MASK,
 	.clksel		= clkout2_src_clksel,
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES,
+	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "cm_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
@@ -1036,8 +999,7 @@ static struct clk sys_clkout2 = {
 static struct clk corex2_fck = {
 	.name		= "corex2_fck",
 	.parent		= &dpll3_m2x2_ck,
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
-				PARENT_CONTROLS_CLOCK,
+	.flags		= CLOCK_IN_OMAP343X | PARENT_CONTROLS_CLOCK,
 	.clkdm		= { .name = "cm_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -1064,8 +1026,7 @@ static struct clk dpll1_fck = {
 	.clksel_reg	= OMAP3430_CM_CLKSEL1_PLL,
 	.clksel_mask	= OMAP3430_MPU_CLK_SRC_MASK,
 	.clksel		= div4_core_clksel,
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
-				PARENT_CONTROLS_CLOCK,
+	.flags		= CLOCK_IN_OMAP343X | PARENT_CONTROLS_CLOCK,
 	.clkdm		= { .name = "cm_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
@@ -1073,8 +1034,7 @@ static struct clk dpll1_fck = {
 static struct clk mpu_ck = {
 	.name		= "mpu_ck",
 	.parent		= &dpll1_x2m2_ck,
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
-				PARENT_CONTROLS_CLOCK,
+	.flags		= CLOCK_IN_OMAP343X | PARENT_CONTROLS_CLOCK,
 	.clkdm		= { .name = "mpu_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -1099,8 +1059,7 @@ static struct clk arm_fck = {
 	.clksel_reg	= OMAP3430_CM_IDLEST_PLL,
 	.clksel_mask	= OMAP3430_ST_MPU_CLK_MASK,
 	.clksel		= arm_fck_clksel,
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
-				PARENT_CONTROLS_CLOCK,
+	.flags		= CLOCK_IN_OMAP343X | PARENT_CONTROLS_CLOCK,
 	.clkdm		= { .name = "mpu_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
@@ -1114,8 +1073,7 @@ static struct clk arm_fck = {
 static struct clk emu_mpu_alwon_ck = {
 	.name		= "emu_mpu_alwon_ck",
 	.parent		= &mpu_ck,
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
-				PARENT_CONTROLS_CLOCK,
+	.flags		= CLOCK_IN_OMAP343X | PARENT_CONTROLS_CLOCK,
 	.clkdm		= { .name = "mpu_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -1128,8 +1086,7 @@ static struct clk dpll2_fck = {
 	.clksel_reg	= OMAP3430_CM_CLKSEL1_PLL,
 	.clksel_mask	= OMAP3430_IVA2_CLK_SRC_MASK,
 	.clksel		= div4_core_clksel,
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
-				PARENT_CONTROLS_CLOCK,
+	.flags		= CLOCK_IN_OMAP343X | PARENT_CONTROLS_CLOCK,
 	.clkdm		= { .name = "cm_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
@@ -1141,7 +1098,7 @@ static struct clk iva2_ck = {
 	.init		= &omap2_init_clksel_parent,
 	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP3430_CM_FCLKEN_IVA2_EN_IVA2_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES,
+	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "iva2_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -1161,8 +1118,7 @@ static struct clk l3_ick = {
 	.clksel_reg	= CM_CLKSEL,
 	.clksel_mask	= OMAP3430_CLKSEL_L3_MASK,
 	.clksel		= div2_core_clksel,
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
-				PARENT_CONTROLS_CLOCK,
+	.flags		= CLOCK_IN_OMAP343X | PARENT_CONTROLS_CLOCK,
 	.clkdm		= { .name = "core_l3_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
@@ -1180,8 +1136,7 @@ static struct clk l4_ick = {
 	.clksel_reg	= CM_CLKSEL,
 	.clksel_mask	= OMAP3430_CLKSEL_L4_MASK,
 	.clksel		= div2_l3_clksel,
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
-				PARENT_CONTROLS_CLOCK,
+	.flags		= CLOCK_IN_OMAP343X | PARENT_CONTROLS_CLOCK,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 
@@ -1235,8 +1190,7 @@ static struct clk gfx_l3_fck = {
 	.clksel_reg	= CM_CLKSEL,
 	.clksel_mask	= OMAP_CLKSEL_GFX_MASK,
 	.clksel		= gfx_l3_clksel,
-	.flags		= CLOCK_IN_OMAP3430ES1 | RATE_PROPAGATES |
-				PARENT_CONTROLS_CLOCK,
+	.flags		= CLOCK_IN_OMAP3430ES1 | PARENT_CONTROLS_CLOCK,
 	.clkdm		= { .name = "gfx_3430es1_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
@@ -1407,8 +1361,7 @@ static struct clk usbtll_fck = {
 static struct clk core_96m_fck = {
 	.name		= "core_96m_fck",
 	.parent		= &omap_96m_fck,
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
-				PARENT_CONTROLS_CLOCK,
+	.flags		= CLOCK_IN_OMAP343X | PARENT_CONTROLS_CLOCK,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -1579,8 +1532,7 @@ static struct clk mcbsp1_fck = {
 static struct clk core_48m_fck = {
 	.name		= "core_48m_fck",
 	.parent		= &omap_48m_fck,
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
-				PARENT_CONTROLS_CLOCK,
+	.flags		= CLOCK_IN_OMAP343X | PARENT_CONTROLS_CLOCK,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -1679,8 +1631,7 @@ static struct clk fshostusb_fck = {
 static struct clk core_12m_fck = {
 	.name		= "core_12m_fck",
 	.parent		= &omap_12m_fck,
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
-				PARENT_CONTROLS_CLOCK,
+	.flags		= CLOCK_IN_OMAP343X | PARENT_CONTROLS_CLOCK,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -1723,7 +1674,7 @@ static struct clk ssi_ssr_fck_3430es1 = {
 	.clksel_reg	= CM_CLKSEL,
 	.clksel_mask	= OMAP3430_CLKSEL_SSI_MASK,
 	.clksel		= ssi_ssr_clksel,
-	.flags		= CLOCK_IN_OMAP3430ES1 | RATE_PROPAGATES,
+	.flags		= CLOCK_IN_OMAP3430ES1,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
@@ -1738,7 +1689,7 @@ static struct clk ssi_ssr_fck_3430es2 = {
 	.clksel_reg	= CM_CLKSEL,
 	.clksel_mask	= OMAP3430_CLKSEL_SSI_MASK,
 	.clksel		= ssi_ssr_clksel,
-	.flags		= CLOCK_IN_OMAP3430ES2 | RATE_PROPAGATES | WAIT_READY,
+	.flags		= CLOCK_IN_OMAP3430ES2 | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
@@ -1773,8 +1724,7 @@ static struct clk ssi_sst_fck_3430es2 = {
 static struct clk core_l3_ick = {
 	.name		= "core_l3_ick",
 	.parent		= &l3_ick,
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
-				PARENT_CONTROLS_CLOCK,
+	.flags		= CLOCK_IN_OMAP343X | PARENT_CONTROLS_CLOCK,
 	.clkdm		= { .name = "core_l3_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -1828,8 +1778,7 @@ static struct clk gpmc_fck = {
 static struct clk security_l3_ick = {
 	.name		= "security_l3_ick",
 	.parent		= &l3_ick,
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
-				PARENT_CONTROLS_CLOCK,
+	.flags		= CLOCK_IN_OMAP343X | PARENT_CONTROLS_CLOCK,
 	.clkdm		= { .name = "core_l3_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -1851,8 +1800,7 @@ static struct clk pka_ick = {
 static struct clk core_l4_ick = {
 	.name		= "core_l4_ick",
 	.parent		= &l4_ick,
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
-				PARENT_CONTROLS_CLOCK,
+	.flags		= CLOCK_IN_OMAP343X | PARENT_CONTROLS_CLOCK,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -2186,8 +2134,7 @@ static struct clk omapctrl_ick = {
 static struct clk ssi_l4_ick = {
 	.name		= "ssi_l4_ick",
 	.parent		= &l4_ick,
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
-				PARENT_CONTROLS_CLOCK,
+	.flags		= CLOCK_IN_OMAP343X | PARENT_CONTROLS_CLOCK,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -2247,8 +2194,7 @@ static struct clk usb_l4_ick = {
 static struct clk security_l4_ick2 = {
 	.name		= "security_l4_ick2",
 	.parent		= &l4_ick,
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
-				PARENT_CONTROLS_CLOCK,
+	.flags		= CLOCK_IN_OMAP343X | PARENT_CONTROLS_CLOCK,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -2518,7 +2464,7 @@ static struct clk gpt1_fck = {
 static struct clk wkup_32k_fck = {
 	.name		= "wkup_32k_fck",
 	.parent		= &omap_32k_fck,
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | ALWAYS_ENABLED,
+	.flags		= CLOCK_IN_OMAP343X | ALWAYS_ENABLED,
 	.clkdm		= { .name = "prm_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -2550,7 +2496,7 @@ static struct clk wdt2_fck = {
 static struct clk wkup_l4_ick = {
 	.name		= "wkup_l4_ick",
 	.parent		= &sys_ck,
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | ALWAYS_ENABLED,
+	.flags		= CLOCK_IN_OMAP343X | ALWAYS_ENABLED,
 	.clkdm		= { .name = "prm_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -2646,8 +2592,7 @@ static struct clk gpt1_ick = {
 static struct clk per_96m_fck = {
 	.name		= "per_96m_fck",
 	.parent		= &omap_96m_alwon_fck,
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
-				PARENT_CONTROLS_CLOCK,
+	.flags		= CLOCK_IN_OMAP343X | PARENT_CONTROLS_CLOCK,
 	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -2655,8 +2600,7 @@ static struct clk per_96m_fck = {
 static struct clk per_48m_fck = {
 	.name		= "per_48m_fck",
 	.parent		= &omap_48m_fck,
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
-				PARENT_CONTROLS_CLOCK,
+	.flags		= CLOCK_IN_OMAP343X | PARENT_CONTROLS_CLOCK,
 	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -2797,7 +2741,7 @@ static struct clk per_32k_alwon_fck = {
 	.name		= "per_32k_alwon_fck",
 	.parent		= &omap_32k_fck,
 	.clkdm		= { .name = "per_clkdm" },
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | ALWAYS_ENABLED,
+	.flags		= CLOCK_IN_OMAP343X | ALWAYS_ENABLED,
 	.recalc		= &followparent_recalc,
 };
 
@@ -2876,8 +2820,7 @@ static struct clk wdt3_fck = {
 static struct clk per_l4_ick = {
 	.name		= "per_l4_ick",
 	.parent		= &l4_ick,
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
-				PARENT_CONTROLS_CLOCK,
+	.flags		= CLOCK_IN_OMAP343X | PARENT_CONTROLS_CLOCK,
 	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -3229,7 +3172,7 @@ static struct clk emu_src_ck = {
 	.clksel_reg	= CM_CLKSEL1,
 	.clksel_mask	= OMAP3430_MUX_CTRL_MASK,
 	.clksel		= emu_src_clksel,
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | ALWAYS_ENABLED,
+	.flags		= CLOCK_IN_OMAP343X | ALWAYS_ENABLED,
 	.clkdm		= { .name = "emu_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
@@ -3254,7 +3197,7 @@ static struct clk pclk_fck = {
 	.clksel_reg	= CM_CLKSEL1,
 	.clksel_mask	= OMAP3430_CLKSEL_PCLK_MASK,
 	.clksel		= pclk_emu_clksel,
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | ALWAYS_ENABLED,
+	.flags		= CLOCK_IN_OMAP343X | ALWAYS_ENABLED,
 	.clkdm		= { .name = "emu_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
@@ -3278,7 +3221,7 @@ static struct clk pclkx2_fck = {
 	.clksel_reg	= CM_CLKSEL1,
 	.clksel_mask	= OMAP3430_CLKSEL_PCLKX2_MASK,
 	.clksel		= pclkx2_emu_clksel,
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | ALWAYS_ENABLED,
+	.flags		= CLOCK_IN_OMAP343X | ALWAYS_ENABLED,
 	.clkdm		= { .name = "emu_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
@@ -3295,7 +3238,7 @@ static struct clk atclk_fck = {
 	.clksel_reg	= CM_CLKSEL1,
 	.clksel_mask	= OMAP3430_CLKSEL_ATCLK_MASK,
 	.clksel		= atclk_emu_clksel,
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | ALWAYS_ENABLED,
+	.flags		= CLOCK_IN_OMAP343X | ALWAYS_ENABLED,
 	.clkdm		= { .name = "emu_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
@@ -3307,7 +3250,7 @@ static struct clk traceclk_src_fck = {
 	.clksel_reg	= CM_CLKSEL1,
 	.clksel_mask	= OMAP3430_TRACE_MUX_CTRL_MASK,
 	.clksel		= emu_src_clksel,
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | ALWAYS_ENABLED,
+	.flags		= CLOCK_IN_OMAP343X | ALWAYS_ENABLED,
 	.clkdm		= { .name = "emu_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
@@ -3346,7 +3289,7 @@ static struct clk sr1_fck = {
 	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP3430_EN_SR1_SHIFT,
 	.idlest_bit	= OMAP3430_ST_SR1_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | WAIT_READY,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "prm_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -3359,7 +3302,7 @@ static struct clk sr2_fck = {
 	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP3430_EN_SR2_SHIFT,
 	.idlest_bit	= OMAP3430_ST_SR2_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | WAIT_READY,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "prm_clkdm" },
 	.recalc		= &followparent_recalc,
 };
diff --git a/arch/arm/plat-omap/include/mach/clock.h b/arch/arm/plat-omap/include/mach/clock.h
index 358bf9e..a039832 100644
--- a/arch/arm/plat-omap/include/mach/clock.h
+++ b/arch/arm/plat-omap/include/mach/clock.h
@@ -153,16 +153,14 @@ void omap_clk_del_child(struct clk *clk, struct clk *clk2);
 
 /* Clock flags */
 #define RATE_CKCTL		(1 << 0)	/* Main fixed ratio clocks */
-#define RATE_FIXED		(1 << 1)	/* Fixed clock rate */
-#define RATE_PROPAGATES		(1 << 2)	/* Program children too */
-#define VIRTUAL_CLOCK		(1 << 3)	/* Composite clock from table */
+/* bits 1-3 are currently free */
 #define ALWAYS_ENABLED		(1 << 4)	/* Clock cannot be disabled */
 #define ENABLE_REG_32BIT	(1 << 5)	/* Use 32-bit access */
-
+/* bit 6 is currently free */
 #define CLOCK_IDLE_CONTROL	(1 << 7)
 #define CLOCK_NO_IDLE_PARENT	(1 << 8)
 #define DELAYED_APP		(1 << 9)	/* Delay application of clock */
-#define CONFIG_PARTICIPANT	(1 << 10)	/* Fundamental clock */
+/* bit 10 is currently free */
 #define ENABLE_ON_INIT		(1 << 11)	/* Enable upon framework init */
 #define INVERT_ENABLE		(1 << 12)	/* 0 enables, 1 disables */
 #define WAIT_READY		(1 << 13)	/* wait for dev to leave idle */


