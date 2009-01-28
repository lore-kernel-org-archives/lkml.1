Return-Path: <linux-kernel-owner+w=401wt.eu-S1758637AbZA1Ul7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758637AbZA1Ul7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 15:41:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754717AbZA1UaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:30:16 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:32995 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754543AbZA1UaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:30:11 -0500
MBOX-Line: From nobody Tue Jan 27 19:13:02 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH A 05/10] OMAP3 clock: fix 96MHz clocks
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Cc: Paul Walmsley <paul@pwsan.com>, Tony Lindgren <tony@atomide.com>,
       linux-omap@vger.kernel.org
Date: Tue, 27 Jan 2009 19:13:02 -0700
Message-ID: <20090128021257.7244.98901.stgit@localhost.localdomain>
In-Reply-To: <20090128020447.7244.80496.stgit@localhost.localdomain>
References: <20090128020447.7244.80496.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix some bugs in the OMAP3 clock tree pertaining to the 96MHz clocks.
The 96MHz portion of the clock tree should now have reasonable
fidelity to the 34xx TRM Rev I.

One remaining question mark: it's not clear exactly which 96MHz source
clock the USIM uses.  This patch sticks with the previous setting, which
seems reasonable.

linux-omap source commit is 15c706e8179ce238c3ba70a25846a36b73bd2359.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/clock34xx.h       |   60 +++++++++++++++++++++------------
 arch/arm/mach-omap2/cm-regbits-34xx.h |    8 +++-
 2 files changed, 44 insertions(+), 24 deletions(-)

diff --git a/arch/arm/mach-omap2/clock34xx.h b/arch/arm/mach-omap2/clock34xx.h
index 23b909d..f8c9885 100644
--- a/arch/arm/mach-omap2/clock34xx.h
+++ b/arch/arm/mach-omap2/clock34xx.h
@@ -646,6 +646,12 @@ static const struct clksel omap_96m_alwon_fck_clksel[] = {
 	{ .parent = NULL }
 };
 
+/*
+ * DPLL4 generates DPLL4_M2X2_CLK which is then routed into the PRM as
+ * PRM_96M_ALWON_(F)CLK.  Two clocks then emerge from the PRM:
+ * 96M_ALWON_FCLK (called "omap_96m_alwon_fck" below) and
+ * CM_96K_(F)CLK.
+ */
 static struct clk omap_96m_alwon_fck = {
 	.name		= "omap_96m_alwon_fck",
 	.parent		= &dpll4_m2x2_ck,
@@ -654,31 +660,41 @@ static struct clk omap_96m_alwon_fck = {
 	.clksel_mask	= OMAP3430_ST_PERIPH_CLK_MASK,
 	.clksel		= omap_96m_alwon_fck_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
-				 PARENT_CONTROLS_CLOCK,
+				PARENT_CONTROLS_CLOCK,
 	.recalc		= &omap2_clksel_recalc,
 };
 
-static struct clk omap_96m_fck = {
-	.name		= "omap_96m_fck",
+static struct clk cm_96m_fck = {
+	.name		= "cm_96m_fck",
 	.parent		= &omap_96m_alwon_fck,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
 				PARENT_CONTROLS_CLOCK,
 	.recalc		= &followparent_recalc,
 };
 
-static const struct clksel cm_96m_fck_clksel[] = {
-	{ .parent = &sys_ck,	    .rates = dpll_bypass_rates },
-	{ .parent = &dpll4_m2x2_ck, .rates = dpll_locked_rates },
+static const struct clksel_rate omap_96m_dpll_rates[] = {
+	{ .div = 1, .val = 0, .flags = RATE_IN_343X | DEFAULT_RATE },
+	{ .div = 0 }
+};
+
+static const struct clksel_rate omap_96m_sys_rates[] = {
+	{ .div = 1, .val = 1, .flags = RATE_IN_343X | DEFAULT_RATE },
+	{ .div = 0 }
+};
+
+static const struct clksel omap_96m_fck_clksel[] = {
+	{ .parent = &cm_96m_fck, .rates = omap_96m_dpll_rates },
+	{ .parent = &sys_ck,	 .rates = omap_96m_sys_rates },
 	{ .parent = NULL }
 };
 
-static struct clk cm_96m_fck = {
-	.name		= "cm_96m_fck",
-	.parent		= &dpll4_m2x2_ck,
+static struct clk omap_96m_fck = {
+	.name		= "omap_96m_fck",
+	.parent		= &sys_ck,
 	.init		= &omap2_init_clksel_parent,
-	.clksel_reg	= OMAP_CM_REGADDR(PLL_MOD, CM_IDLEST),
-	.clksel_mask	= OMAP3430_ST_PERIPH_CLK_MASK,
-	.clksel		= cm_96m_fck_clksel,
+	.clksel_reg	= OMAP_CM_REGADDR(PLL_MOD, CM_CLKSEL1),
+	.clksel_mask	= OMAP3430_SOURCE_96M_MASK,
+	.clksel		= omap_96m_fck_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
 				PARENT_CONTROLS_CLOCK,
 	.recalc		= &omap2_clksel_recalc,
@@ -746,14 +762,14 @@ static struct clk omap_54m_fck = {
 	.name		= "omap_54m_fck",
 	.init		= &omap2_init_clksel_parent,
 	.clksel_reg	= OMAP_CM_REGADDR(PLL_MOD, CM_CLKSEL1),
-	.clksel_mask	= OMAP3430_SOURCE_54M,
+	.clksel_mask	= OMAP3430_SOURCE_54M_MASK,
 	.clksel		= omap_54m_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
 				PARENT_CONTROLS_CLOCK,
 	.recalc		= &omap2_clksel_recalc,
 };
 
-static const struct clksel_rate omap_48m_96md2_rates[] = {
+static const struct clksel_rate omap_48m_cm96m_rates[] = {
 	{ .div = 2, .val = 0, .flags = RATE_IN_343X | DEFAULT_RATE },
 	{ .div = 0 }
 };
@@ -764,7 +780,7 @@ static const struct clksel_rate omap_48m_alt_rates[] = {
 };
 
 static const struct clksel omap_48m_clksel[] = {
-	{ .parent = &cm_96m_fck, .rates = omap_48m_96md2_rates },
+	{ .parent = &cm_96m_fck, .rates = omap_48m_cm96m_rates },
 	{ .parent = &sys_altclk, .rates = omap_48m_alt_rates },
 	{ .parent = NULL }
 };
@@ -773,7 +789,7 @@ static struct clk omap_48m_fck = {
 	.name		= "omap_48m_fck",
 	.init		= &omap2_init_clksel_parent,
 	.clksel_reg	= OMAP_CM_REGADDR(PLL_MOD, CM_CLKSEL1),
-	.clksel_mask	= OMAP3430_SOURCE_48M,
+	.clksel_mask	= OMAP3430_SOURCE_48M_MASK,
 	.clksel		= omap_48m_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
 				PARENT_CONTROLS_CLOCK,
@@ -961,10 +977,10 @@ static const struct clksel_rate clkout2_src_54m_rates[] = {
 };
 
 static const struct clksel clkout2_src_clksel[] = {
-	{ .parent = &core_ck,		  .rates = clkout2_src_core_rates },
-	{ .parent = &sys_ck,		  .rates = clkout2_src_sys_rates },
-	{ .parent = &omap_96m_alwon_fck,  .rates = clkout2_src_96m_rates },
-	{ .parent = &omap_54m_fck,	  .rates = clkout2_src_54m_rates },
+	{ .parent = &core_ck,		.rates = clkout2_src_core_rates },
+	{ .parent = &sys_ck,		.rates = clkout2_src_sys_rates },
+	{ .parent = &cm_96m_fck,	.rates = clkout2_src_96m_rates },
+	{ .parent = &omap_54m_fck,	.rates = clkout2_src_54m_rates },
 	{ .parent = NULL }
 };
 
@@ -2777,8 +2793,8 @@ static struct clk mcbsp4_ick = {
 };
 
 static const struct clksel mcbsp_234_clksel[] = {
-	{ .parent = &per_96m_fck, .rates = common_mcbsp_96m_rates },
-	{ .parent = &mcbsp_clks,  .rates = common_mcbsp_mcbsp_rates },
+	{ .parent = &core_96m_fck, .rates = common_mcbsp_96m_rates },
+	{ .parent = &mcbsp_clks,   .rates = common_mcbsp_mcbsp_rates },
 	{ .parent = NULL }
 };
 
diff --git a/arch/arm/mach-omap2/cm-regbits-34xx.h b/arch/arm/mach-omap2/cm-regbits-34xx.h
index 219f5c8..a46f93c 100644
--- a/arch/arm/mach-omap2/cm-regbits-34xx.h
+++ b/arch/arm/mach-omap2/cm-regbits-34xx.h
@@ -449,8 +449,12 @@
 #define OMAP3430_CORE_DPLL_MULT_MASK			(0x7ff << 16)
 #define OMAP3430_CORE_DPLL_DIV_SHIFT			8
 #define OMAP3430_CORE_DPLL_DIV_MASK			(0x7f << 8)
-#define OMAP3430_SOURCE_54M				(1 << 5)
-#define OMAP3430_SOURCE_48M				(1 << 3)
+#define OMAP3430_SOURCE_96M_SHIFT			6
+#define OMAP3430_SOURCE_96M_MASK			(1 << 6)
+#define OMAP3430_SOURCE_54M_SHIFT			5
+#define OMAP3430_SOURCE_54M_MASK			(1 << 5)
+#define OMAP3430_SOURCE_48M_SHIFT			3
+#define OMAP3430_SOURCE_48M_MASK			(1 << 3)
 
 /* CM_CLKSEL2_PLL */
 #define OMAP3430_PERIPH_DPLL_MULT_SHIFT			8


