Return-Path: <linux-kernel-owner+w=401wt.eu-S1753993AbZA1U3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993AbZA1U3A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 15:29:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752418AbZA1U1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:27:34 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:60923 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbZA1U10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:27:26 -0500
MBOX-Line: From nobody Wed Jan 28 12:18:25 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH D 04/11] OMAP3 clock: split mcbspX_src_fck from mcbspX_fck
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, Paul Walmsley <paul@pwsan.com>,
       Tony Lindgren <tony@atomide.com>
Date: Wed, 28 Jan 2009 12:18:25 -0700
Message-ID: <20090128191822.16688.73129.stgit@localhost.localdomain>
In-Reply-To: <20090128191638.16688.33452.stgit@localhost.localdomain>
References: <20090128191638.16688.33452.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

McBSP clock source control registers are located in the System Control
Module, not the PRCM.  However, the clock enable/disable registers are
in the CM.  Since the following patches require all registers in a
struct clk to be in only one of {CM, PRM, SCM}, we must split the
source clock selection into a separate struct clk from the clock
enable/disable control.

linux-omap source commit is b670a37e77372b66bfb22a1f8633d906b9bbc26c.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/clock34xx.h |   82 +++++++++++++++++++++++++++++++--------
 1 files changed, 66 insertions(+), 16 deletions(-)

diff --git a/arch/arm/mach-omap2/clock34xx.h b/arch/arm/mach-omap2/clock34xx.h
index 00ac92f..987fc4c 100644
--- a/arch/arm/mach-omap2/clock34xx.h
+++ b/arch/arm/mach-omap2/clock34xx.h
@@ -1473,12 +1473,10 @@ static const struct clksel mcbsp_15_clksel[] = {
 	{ .parent = NULL }
 };
 
-static struct clk mcbsp5_fck = {
-	.name		= "mcbsp_fck",
+static struct clk mcbsp5_src_fck = {
+	.name		= "mcbsp_src_fck",
 	.id		= 5,
 	.init		= &omap2_init_clksel_parent,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
-	.enable_bit	= OMAP3430_EN_MCBSP5_SHIFT,
 	.clksel_reg	= OMAP343X_CTRL_REGADDR(OMAP343X_CONTROL_DEVCONF1),
 	.clksel_mask	= OMAP2_MCBSP5_CLKS_MASK,
 	.clksel		= mcbsp_15_clksel,
@@ -1487,12 +1485,21 @@ static struct clk mcbsp5_fck = {
 	.recalc		= &omap2_clksel_recalc,
 };
 
-static struct clk mcbsp1_fck = {
+static struct clk mcbsp5_fck = {
 	.name		= "mcbsp_fck",
+	.id		= 5,
+	.parent		= &mcbsp5_src_fck,
+	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_bit	= OMAP3430_EN_MCBSP5_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm		= { .name = "core_l4_clkdm" },
+	.recalc		= &followparent_recalc,
+};
+
+static struct clk mcbsp1_src_fck = {
+	.name		= "mcbsp_src_fck",
 	.id		= 1,
 	.init		= &omap2_init_clksel_parent,
-	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
-	.enable_bit	= OMAP3430_EN_MCBSP1_SHIFT,
 	.clksel_reg	= OMAP343X_CTRL_REGADDR(OMAP2_CONTROL_DEVCONF0),
 	.clksel_mask	= OMAP2_MCBSP1_CLKS_MASK,
 	.clksel		= mcbsp_15_clksel,
@@ -1501,6 +1508,17 @@ static struct clk mcbsp1_fck = {
 	.recalc		= &omap2_clksel_recalc,
 };
 
+static struct clk mcbsp1_fck = {
+	.name		= "mcbsp_fck",
+	.id		= 1,
+	.parent		= &mcbsp1_src_fck,
+	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_bit	= OMAP3430_EN_MCBSP1_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm		= { .name = "core_l4_clkdm" },
+	.recalc		= &followparent_recalc,
+};
+
 /* CORE_48M_FCK-derived clocks */
 
 static struct clk core_48m_fck = {
@@ -2773,14 +2791,35 @@ static const struct clksel mcbsp_234_clksel[] = {
 	{ .parent = NULL }
 };
 
+static struct clk mcbsp2_src_fck = {
+	.name		= "mcbsp_src_fck",
+	.id		= 2,
+	.init		= &omap2_init_clksel_parent,
+	.clksel_reg	= OMAP343X_CTRL_REGADDR(OMAP2_CONTROL_DEVCONF0),
+	.clksel_mask	= OMAP2_MCBSP2_CLKS_MASK,
+	.clksel		= mcbsp_234_clksel,
+	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm		= { .name = "per_clkdm" },
+	.recalc		= &omap2_clksel_recalc,
+};
+
 static struct clk mcbsp2_fck = {
 	.name		= "mcbsp_fck",
 	.id		= 2,
-	.init		= &omap2_init_clksel_parent,
+	.parent		= &mcbsp2_src_fck,
 	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_EN_MCBSP2_SHIFT,
-	.clksel_reg	= OMAP343X_CTRL_REGADDR(OMAP2_CONTROL_DEVCONF0),
-	.clksel_mask	= OMAP2_MCBSP2_CLKS_MASK,
+	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm		= { .name = "per_clkdm" },
+	.recalc		= &omap2_clksel_recalc,
+};
+
+static struct clk mcbsp3_src_fck = {
+	.name		= "mcbsp_src_fck",
+	.id		= 3,
+	.init		= &omap2_init_clksel_parent,
+	.clksel_reg	= OMAP343X_CTRL_REGADDR(OMAP343X_CONTROL_DEVCONF1),
+	.clksel_mask	= OMAP2_MCBSP3_CLKS_MASK,
 	.clksel		= mcbsp_234_clksel,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "per_clkdm" },
@@ -2790,11 +2829,20 @@ static struct clk mcbsp2_fck = {
 static struct clk mcbsp3_fck = {
 	.name		= "mcbsp_fck",
 	.id		= 3,
-	.init		= &omap2_init_clksel_parent,
+	.parent		= &mcbsp3_src_fck,
 	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_EN_MCBSP3_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm		= { .name = "per_clkdm" },
+	.recalc		= &omap2_clksel_recalc,
+};
+
+static struct clk mcbsp4_src_fck = {
+	.name		= "mcbsp_src_fck",
+	.id		= 4,
+	.init		= &omap2_init_clksel_parent,
 	.clksel_reg	= OMAP343X_CTRL_REGADDR(OMAP343X_CONTROL_DEVCONF1),
-	.clksel_mask	= OMAP2_MCBSP3_CLKS_MASK,
+	.clksel_mask	= OMAP2_MCBSP4_CLKS_MASK,
 	.clksel		= mcbsp_234_clksel,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "per_clkdm" },
@@ -2804,12 +2852,9 @@ static struct clk mcbsp3_fck = {
 static struct clk mcbsp4_fck = {
 	.name		= "mcbsp_fck",
 	.id		= 4,
-	.init		= &omap2_init_clksel_parent,
+	.parent		= &mcbsp4_src_fck,
 	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_EN_MCBSP4_SHIFT,
-	.clksel_reg	= OMAP343X_CTRL_REGADDR(OMAP343X_CONTROL_DEVCONF1),
-	.clksel_mask	= OMAP2_MCBSP4_CLKS_MASK,
-	.clksel		= mcbsp_234_clksel,
 	.flags		= CLOCK_IN_OMAP343X,
 	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
@@ -3091,7 +3136,9 @@ static struct clk *onchip_34xx_clks[] __initdata = {
 	&i2c3_fck,
 	&i2c2_fck,
 	&i2c1_fck,
+	&mcbsp5_src_fck,
 	&mcbsp5_fck,
+	&mcbsp1_src_fck,
 	&mcbsp1_fck,
 	&core_48m_fck,
 	&mcspi4_fck,
@@ -3207,8 +3254,11 @@ static struct clk *onchip_34xx_clks[] __initdata = {
 	&mcbsp2_ick,
 	&mcbsp3_ick,
 	&mcbsp4_ick,
+	&mcbsp2_src_fck,
 	&mcbsp2_fck,
+	&mcbsp3_src_fck,
 	&mcbsp3_fck,
+	&mcbsp4_src_fck,
 	&mcbsp4_fck,
 	&emu_src_ck,
 	&pclk_fck,


