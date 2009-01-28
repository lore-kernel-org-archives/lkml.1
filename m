Return-Path: <linux-kernel-owner+w=401wt.eu-S1756183AbZA1Une@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183AbZA1Une (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 15:43:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754755AbZA1Uao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:30:44 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:33006 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755852AbZA1Uai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:30:38 -0500
MBOX-Line: From nobody Tue Jan 27 19:44:08 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH B 01/10] OMAP2/3 clock: combine clkdm,
	clkdm_name into union in struct clk
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, Paul Walmsley <paul@pwsan.com>,
       Tony Lindgren <tony@atomide.com>
Date: Tue, 27 Jan 2009 19:44:08 -0700
Message-ID: <20090128024401.27240.68328.stgit@localhost.localdomain>
In-Reply-To: <20090128024301.27240.39391.stgit@localhost.localdomain>
References: <20090128024301.27240.39391.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct clk contains a struct clockdomain *clkdm and const char
*clkdm_name.  The clkdm_name is only used at initialization to look up
the appropriate clkdm pointer.  Combining these into a union saves
about 850 bytes on 3430SDP.  This patch should not cause any change in
kernel function.

Boot-tested on 3430SDP ES2; compile-tested with n800_defconfig.

linux-omap source commit is 0e5194e1a84c219bebbb78f305b7a8eabc4a3656.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/clock.c             |   22 +--
 arch/arm/mach-omap2/clock24xx.h         |  264 ++++++++++++++++---------------
 arch/arm/mach-omap2/clock34xx.h         |  256 +++++++++++++++---------------
 arch/arm/plat-omap/include/mach/clock.h |    6 -
 4 files changed, 275 insertions(+), 273 deletions(-)

diff --git a/arch/arm/mach-omap2/clock.c b/arch/arm/mach-omap2/clock.c
index 55c5d67..7aa09f5 100644
--- a/arch/arm/mach-omap2/clock.c
+++ b/arch/arm/mach-omap2/clock.c
@@ -77,17 +77,17 @@ void omap2_init_clk_clkdm(struct clk *clk)
 {
 	struct clockdomain *clkdm;
 
-	if (!clk->clkdm_name)
+	if (!clk->clkdm.name)
 		return;
 
-	clkdm = clkdm_lookup(clk->clkdm_name);
+	clkdm = clkdm_lookup(clk->clkdm.name);
 	if (clkdm) {
 		pr_debug("clock: associated clk %s to clkdm %s\n",
-			 clk->name, clk->clkdm_name);
-		clk->clkdm = clkdm;
+			 clk->name, clk->clkdm.name);
+		clk->clkdm.ptr = clkdm;
 	} else {
 		pr_debug("clock: could not associate clk %s to "
-			 "clkdm %s\n", clk->name, clk->clkdm_name);
+			 "clkdm %s\n", clk->name, clk->clkdm.name);
 	}
 }
 
@@ -333,8 +333,8 @@ void omap2_clk_disable(struct clk *clk)
 		_omap2_clk_disable(clk);
 		if (clk->parent)
 			omap2_clk_disable(clk->parent);
-		if (clk->clkdm)
-			omap2_clkdm_clk_disable(clk->clkdm, clk);
+		if (clk->clkdm.ptr)
+			omap2_clkdm_clk_disable(clk->clkdm.ptr, clk);
 
 	}
 }
@@ -352,14 +352,14 @@ int omap2_clk_enable(struct clk *clk)
 			return ret;
 		}
 
-		if (clk->clkdm)
-			omap2_clkdm_clk_enable(clk->clkdm, clk);
+		if (clk->clkdm.ptr)
+			omap2_clkdm_clk_enable(clk->clkdm.ptr, clk);
 
 		ret = _omap2_clk_enable(clk);
 
 		if (ret != 0) {
-			if (clk->clkdm)
-				omap2_clkdm_clk_disable(clk->clkdm, clk);
+			if (clk->clkdm.ptr)
+				omap2_clkdm_clk_disable(clk->clkdm.ptr, clk);
 
 			if (clk->parent) {
 				omap2_clk_disable(clk->parent);
diff --git a/arch/arm/mach-omap2/clock24xx.h b/arch/arm/mach-omap2/clock24xx.h
index 2bf16ee..68e3667 100644
--- a/arch/arm/mach-omap2/clock24xx.h
+++ b/arch/arm/mach-omap2/clock24xx.h
@@ -633,7 +633,7 @@ static struct clk func_32k_ck = {
 	.rate		= 32000,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				RATE_FIXED | ALWAYS_ENABLED | RATE_PROPAGATES,
-	.clkdm_name	= "wkup_clkdm",
+	.clkdm		= { .name = "wkup_clkdm" },
 	.recalc		= &propagate_rate,
 };
 
@@ -642,7 +642,7 @@ static struct clk osc_ck = {		/* (*12, *13, 19.2, *26, 38.4)MHz */
 	.name		= "osc_ck",
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				RATE_PROPAGATES,
-	.clkdm_name	= "wkup_clkdm",
+	.clkdm		= { .name = "wkup_clkdm" },
 	.enable		= &omap2_enable_osc_ck,
 	.disable	= &omap2_disable_osc_ck,
 	.recalc		= &omap2_osc_clk_recalc,
@@ -654,7 +654,7 @@ static struct clk sys_ck = {		/* (*12, *13, 19.2, 26, 38.4)MHz */
 	.parent		= &osc_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				ALWAYS_ENABLED | RATE_PROPAGATES,
-	.clkdm_name	= "wkup_clkdm",
+	.clkdm		= { .name = "wkup_clkdm" },
 	.recalc		= &omap2_sys_clk_recalc,
 };
 
@@ -663,7 +663,7 @@ static struct clk alt_ck = {		/* Typical 54M or 48M, may not exist */
 	.rate		= 54000000,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				RATE_FIXED | ALWAYS_ENABLED | RATE_PROPAGATES,
-	.clkdm_name	= "wkup_clkdm",
+	.clkdm		= { .name = "wkup_clkdm" },
 	.recalc		= &propagate_rate,
 };
 
@@ -695,7 +695,7 @@ static struct clk dpll_ck = {
 	.dpll_data	= &dpll_dd,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				RATE_PROPAGATES | ALWAYS_ENABLED,
-	.clkdm_name	= "wkup_clkdm",
+	.clkdm		= { .name = "wkup_clkdm" },
 	.recalc		= &omap2_dpllcore_recalc,
 	.set_rate	= &omap2_reprogram_dpllcore,
 };
@@ -706,7 +706,7 @@ static struct clk apll96_ck = {
 	.rate		= 96000000,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				RATE_FIXED | RATE_PROPAGATES | ENABLE_ON_INIT,
-	.clkdm_name	= "wkup_clkdm",
+	.clkdm		= { .name = "wkup_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(PLL_MOD, CM_CLKEN),
 	.enable_bit	= OMAP24XX_EN_96M_PLL_SHIFT,
 	.enable		= &omap2_clk_fixed_enable,
@@ -720,7 +720,7 @@ static struct clk apll54_ck = {
 	.rate		= 54000000,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				RATE_FIXED | RATE_PROPAGATES | ENABLE_ON_INIT,
-	.clkdm_name	= "wkup_clkdm",
+	.clkdm		= { .name = "wkup_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(PLL_MOD, CM_CLKEN),
 	.enable_bit	= OMAP24XX_EN_54M_PLL_SHIFT,
 	.enable		= &omap2_clk_fixed_enable,
@@ -755,7 +755,7 @@ static struct clk func_54m_ck = {
 	.parent		= &apll54_ck,	/* can also be alt_clk */
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				RATE_PROPAGATES | PARENT_CONTROLS_CLOCK,
-	.clkdm_name	= "wkup_clkdm",
+	.clkdm		= { .name = "wkup_clkdm" },
 	.init		= &omap2_init_clksel_parent,
 	.clksel_reg	= _CM_REG_OFFSET(PLL_MOD, CM_CLKSEL1),
 	.clksel_mask	= OMAP24XX_54M_SOURCE,
@@ -768,7 +768,7 @@ static struct clk core_ck = {
 	.parent		= &dpll_ck,		/* can also be 32k */
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				ALWAYS_ENABLED | RATE_PROPAGATES,
-	.clkdm_name	= "wkup_clkdm",
+	.clkdm		= { .name = "wkup_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -795,7 +795,7 @@ static struct clk func_96m_ck = {
 	.parent		= &apll96_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				RATE_PROPAGATES | PARENT_CONTROLS_CLOCK,
-	.clkdm_name	= "wkup_clkdm",
+	.clkdm		= { .name = "wkup_clkdm" },
 	.init		= &omap2_init_clksel_parent,
 	.clksel_reg	= _CM_REG_OFFSET(PLL_MOD, CM_CLKSEL1),
 	.clksel_mask	= OMAP2430_96M_SOURCE,
@@ -828,7 +828,7 @@ static struct clk func_48m_ck = {
 	.parent		= &apll96_ck,	 /* 96M or Alt */
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				RATE_PROPAGATES | PARENT_CONTROLS_CLOCK,
-	.clkdm_name	= "wkup_clkdm",
+	.clkdm		= { .name = "wkup_clkdm" },
 	.init		= &omap2_init_clksel_parent,
 	.clksel_reg	= _CM_REG_OFFSET(PLL_MOD, CM_CLKSEL1),
 	.clksel_mask	= OMAP24XX_48M_SOURCE,
@@ -844,7 +844,7 @@ static struct clk func_12m_ck = {
 	.fixed_div	= 4,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				RATE_PROPAGATES | PARENT_CONTROLS_CLOCK,
-	.clkdm_name	= "wkup_clkdm",
+	.clkdm		= { .name = "wkup_clkdm" },
 	.recalc		= &omap2_fixed_divisor_recalc,
 };
 
@@ -897,7 +897,7 @@ static struct clk sys_clkout_src = {
 	.parent		= &func_54m_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				RATE_PROPAGATES | OFFSET_GR_MOD,
-	.clkdm_name	= "wkup_clkdm",
+	.clkdm		= { .name = "wkup_clkdm" },
 	.enable_reg	= _GR_MOD_OFFSET(OMAP24XX_PRCM_CLKOUT_CTRL_OFFSET),
 	.enable_bit	= OMAP24XX_CLKOUT_EN_SHIFT,
 	.init		= &omap2_init_clksel_parent,
@@ -928,7 +928,7 @@ static struct clk sys_clkout = {
 	.parent		= &sys_clkout_src,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				PARENT_CONTROLS_CLOCK | OFFSET_GR_MOD,
-	.clkdm_name	= "wkup_clkdm",
+	.clkdm		= { .name = "wkup_clkdm" },
 	.clksel_reg	= _GR_MOD_OFFSET(OMAP24XX_PRCM_CLKOUT_CTRL_OFFSET),
 	.clksel_mask	= OMAP24XX_CLKOUT_DIV_MASK,
 	.clksel		= sys_clkout_clksel,
@@ -942,7 +942,7 @@ static struct clk sys_clkout2_src = {
 	.name		= "sys_clkout2_src",
 	.parent		= &func_54m_ck,
 	.flags		= CLOCK_IN_OMAP242X | RATE_PROPAGATES | OFFSET_GR_MOD,
-	.clkdm_name	= "wkup_clkdm",
+	.clkdm		= { .name = "wkup_clkdm" },
 	.enable_reg	= _GR_MOD_OFFSET(OMAP24XX_PRCM_CLKOUT_CTRL_OFFSET),
 	.enable_bit	= OMAP2420_CLKOUT2_EN_SHIFT,
 	.init		= &omap2_init_clksel_parent,
@@ -965,7 +965,7 @@ static struct clk sys_clkout2 = {
 	.parent		= &sys_clkout2_src,
 	.flags		= CLOCK_IN_OMAP242X | PARENT_CONTROLS_CLOCK |
 				OFFSET_GR_MOD,
-	.clkdm_name	= "wkup_clkdm",
+	.clkdm		= { .name = "wkup_clkdm" },
 	.clksel_reg	= _GR_MOD_OFFSET(OMAP24XX_PRCM_CLKOUT_CTRL_OFFSET),
 	.clksel_mask	= OMAP2420_CLKOUT2_DIV_MASK,
 	.clksel		= sys_clkout2_clksel,
@@ -978,7 +978,7 @@ static struct clk emul_ck = {
 	.name		= "emul_ck",
 	.parent		= &func_54m_ck,
 	.flags		= CLOCK_IN_OMAP242X | OFFSET_GR_MOD,
-	.clkdm_name	= "wkup_clkdm",
+	.clkdm		= { .name = "wkup_clkdm" },
 	.enable_reg	= _GR_MOD_OFFSET(OMAP24XX_PRCM_CLKEMUL_CTRL_OFFSET),
 	.enable_bit	= OMAP24XX_EMULATION_EN_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -1015,7 +1015,7 @@ static struct clk mpu_ck = {	/* Control cpu */
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				ALWAYS_ENABLED | DELAYED_APP |
 				CONFIG_PARTICIPANT | RATE_PROPAGATES,
-	.clkdm_name	= "mpu_clkdm",
+	.clkdm		= { .name = "mpu_clkdm" },
 	.init		= &omap2_init_clksel_parent,
 	.clksel_reg	= _CM_REG_OFFSET(MPU_MOD, CM_CLKSEL),
 	.clksel_mask	= OMAP24XX_CLKSEL_MPU_MASK,
@@ -1057,7 +1057,7 @@ static struct clk dsp_fck = {
 	.parent		= &core_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X | DELAYED_APP |
 				CONFIG_PARTICIPANT | RATE_PROPAGATES,
-	.clkdm_name	= "dsp_clkdm",
+	.clkdm		= { .name = "dsp_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(OMAP24XX_DSP_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP24XX_CM_FCLKEN_DSP_EN_DSP_SHIFT,
 	.clksel_reg	= _CM_REG_OFFSET(OMAP24XX_DSP_MOD, CM_CLKSEL),
@@ -1123,7 +1123,7 @@ static struct clk iva1_ifck = {
 	.parent		= &core_ck,
 	.flags		= CLOCK_IN_OMAP242X | CONFIG_PARTICIPANT |
 				RATE_PROPAGATES | DELAYED_APP,
-	.clkdm_name	= "iva1_clkdm",
+	.clkdm		= { .name = "iva1_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(OMAP24XX_DSP_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP2420_EN_IVA_COP_SHIFT,
 	.clksel_reg	= _CM_REG_OFFSET(OMAP24XX_DSP_MOD, CM_CLKSEL),
@@ -1139,7 +1139,7 @@ static struct clk iva1_mpu_int_ifck = {
 	.name		= "iva1_mpu_int_ifck",
 	.parent		= &iva1_ifck,
 	.flags		= CLOCK_IN_OMAP242X,
-	.clkdm_name	= "iva1_clkdm",
+	.clkdm		= { .name = "iva1_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(OMAP24XX_DSP_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP2420_EN_IVA_MPU_SHIFT,
 	.fixed_div	= 2,
@@ -1187,7 +1187,7 @@ static struct clk core_l3_ck = {	/* Used for ick and fck, interconnect */
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				ALWAYS_ENABLED | DELAYED_APP |
 				CONFIG_PARTICIPANT | RATE_PROPAGATES,
-	.clkdm_name	= "core_l3_clkdm",
+	.clkdm		= { .name = "core_l3_clkdm" },
 	.clksel_reg	= _CM_REG_OFFSET(CORE_MOD, CM_CLKSEL1),
 	.clksel_mask	= OMAP24XX_CLKSEL_L3_MASK,
 	.clksel		= core_l3_clksel,
@@ -1215,7 +1215,7 @@ static struct clk usb_l4_ick = {	/* FS-USB interface clock */
 	.parent		= &core_l3_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				DELAYED_APP | CONFIG_PARTICIPANT,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN2),
 	.enable_bit	= OMAP24XX_EN_USB_SHIFT,
 	.clksel_reg	= _CM_REG_OFFSET(CORE_MOD, CM_CLKSEL1),
@@ -1249,7 +1249,7 @@ static struct clk l4_ck = {		/* used both as an ick and fck */
 	.parent		= &core_l3_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				ALWAYS_ENABLED | DELAYED_APP | RATE_PROPAGATES,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.clksel_reg	= _CM_REG_OFFSET(CORE_MOD, CM_CLKSEL1),
 	.clksel_mask	= OMAP24XX_CLKSEL_L4_MASK,
 	.clksel		= l4_clksel,
@@ -1287,7 +1287,7 @@ static struct clk ssi_ssr_sst_fck = {
 	.parent		= &core_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				DELAYED_APP,
-	.clkdm_name	= "core_l3_clkdm",
+	.clkdm		= { .name = "core_l3_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_FCLKEN2),
 	.enable_bit	= OMAP24XX_EN_SSI_SHIFT,
 	.clksel_reg	= _CM_REG_OFFSET(CORE_MOD, CM_CLKSEL1),
@@ -1305,7 +1305,7 @@ static struct clk ssi_ssr_sst_fck = {
 static struct clk ssi_l4_ick = {
 	.name		= "ssi_l4_ick",
 	.parent		= &l4_ck,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN2),
 	.enable_bit	= OMAP24XX_EN_SSI_SHIFT,
@@ -1336,7 +1336,7 @@ static struct clk gfx_3d_fck = {
 	.name		= "gfx_3d_fck",
 	.parent		= &core_l3_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.clkdm_name	= "gfx_clkdm",
+	.clkdm		= { .name = "gfx_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(GFX_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP24XX_EN_3D_SHIFT,
 	.clksel_reg	= _CM_REG_OFFSET(GFX_MOD, CM_CLKSEL),
@@ -1351,7 +1351,7 @@ static struct clk gfx_2d_fck = {
 	.name		= "gfx_2d_fck",
 	.parent		= &core_l3_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.clkdm_name	= "gfx_clkdm",
+	.clkdm		= { .name = "gfx_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(GFX_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP24XX_EN_2D_SHIFT,
 	.clksel_reg	= _CM_REG_OFFSET(GFX_MOD, CM_CLKSEL),
@@ -1366,7 +1366,7 @@ static struct clk gfx_ick = {
 	.name		= "gfx_ick",		/* From l3 */
 	.parent		= &core_l3_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.clkdm_name	= "gfx_clkdm",
+	.clkdm		= { .name = "gfx_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(GFX_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP_EN_GFX_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -1396,7 +1396,7 @@ static struct clk mdm_ick = {		/* used both as a ick and fck */
 	.name		= "mdm_ick",
 	.parent		= &core_ck,
 	.flags		= CLOCK_IN_OMAP243X | DELAYED_APP | CONFIG_PARTICIPANT,
-	.clkdm_name	= "mdm_clkdm",
+	.clkdm		= { .name = "mdm_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(OMAP2430_MDM_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP2430_CM_ICLKEN_MDM_EN_MDM_SHIFT,
 	.clksel_reg	= _CM_REG_OFFSET(OMAP2430_MDM_MOD, CM_CLKSEL),
@@ -1411,7 +1411,7 @@ static struct clk mdm_osc_ck = {
 	.name		= "mdm_osc_ck",
 	.parent		= &osc_ck,
 	.flags		= CLOCK_IN_OMAP243X,
-	.clkdm_name	= "mdm_clkdm",
+	.clkdm		= { .name = "mdm_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(OMAP2430_MDM_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP2430_EN_OSC_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -1456,7 +1456,7 @@ static struct clk dss_ick = {		/* Enables both L3,L4 ICLK's */
 	.name		= "dss_ick",
 	.parent		= &l4_ck,	/* really both l3 and l4 */
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.clkdm_name	= "dss_clkdm",
+	.clkdm		= { .name = "dss_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP24XX_EN_DSS1_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -1467,7 +1467,7 @@ static struct clk dss1_fck = {
 	.parent		= &core_ck,		/* Core or sys */
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				DELAYED_APP,
-	.clkdm_name	= "dss_clkdm",
+	.clkdm		= { .name = "dss_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_DSS1_SHIFT,
 	.init		= &omap2_init_clksel_parent,
@@ -1500,7 +1500,7 @@ static struct clk dss2_fck = {		/* Alt clk used in power management */
 	.parent		= &sys_ck,		/* fixed at sys_ck or 48MHz */
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				DELAYED_APP,
-	.clkdm_name	= "dss_clkdm",
+	.clkdm		= { .name = "dss_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_DSS2_SHIFT,
 	.init		= &omap2_init_clksel_parent,
@@ -1514,7 +1514,7 @@ static struct clk dss_54m_fck = {	/* Alt clk used in power management */
 	.name		= "dss_54m_fck",	/* 54m tv clk */
 	.parent		= &func_54m_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.clkdm_name	= "dss_clkdm",
+	.clkdm		= { .name = "dss_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_TV_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -1542,7 +1542,7 @@ static struct clk gpt1_ick = {
 	.name		= "gpt1_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(WKUP_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP24XX_EN_GPT1_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -1552,7 +1552,7 @@ static struct clk gpt1_fck = {
 	.name		= "gpt1_fck",
 	.parent		= &func_32k_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(WKUP_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP24XX_EN_GPT1_SHIFT,
 	.init		= &omap2_init_clksel_parent,
@@ -1568,7 +1568,7 @@ static struct clk gpt2_ick = {
 	.name		= "gpt2_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP24XX_EN_GPT2_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -1578,7 +1578,7 @@ static struct clk gpt2_fck = {
 	.name		= "gpt2_fck",
 	.parent		= &func_32k_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_GPT2_SHIFT,
 	.init		= &omap2_init_clksel_parent,
@@ -1592,7 +1592,7 @@ static struct clk gpt3_ick = {
 	.name		= "gpt3_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP24XX_EN_GPT3_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -1602,7 +1602,7 @@ static struct clk gpt3_fck = {
 	.name		= "gpt3_fck",
 	.parent		= &func_32k_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_GPT3_SHIFT,
 	.init		= &omap2_init_clksel_parent,
@@ -1616,7 +1616,7 @@ static struct clk gpt4_ick = {
 	.name		= "gpt4_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP24XX_EN_GPT4_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -1626,7 +1626,7 @@ static struct clk gpt4_fck = {
 	.name		= "gpt4_fck",
 	.parent		= &func_32k_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_GPT4_SHIFT,
 	.init		= &omap2_init_clksel_parent,
@@ -1640,7 +1640,7 @@ static struct clk gpt5_ick = {
 	.name		= "gpt5_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP24XX_EN_GPT5_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -1650,7 +1650,7 @@ static struct clk gpt5_fck = {
 	.name		= "gpt5_fck",
 	.parent		= &func_32k_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_GPT5_SHIFT,
 	.init		= &omap2_init_clksel_parent,
@@ -1664,7 +1664,7 @@ static struct clk gpt6_ick = {
 	.name		= "gpt6_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP24XX_EN_GPT6_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -1674,7 +1674,7 @@ static struct clk gpt6_fck = {
 	.name		= "gpt6_fck",
 	.parent		= &func_32k_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_GPT6_SHIFT,
 	.init		= &omap2_init_clksel_parent,
@@ -1697,7 +1697,7 @@ static struct clk gpt7_fck = {
 	.name		= "gpt7_fck",
 	.parent		= &func_32k_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_GPT7_SHIFT,
 	.init		= &omap2_init_clksel_parent,
@@ -1711,7 +1711,7 @@ static struct clk gpt8_ick = {
 	.name		= "gpt8_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP24XX_EN_GPT8_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -1721,7 +1721,7 @@ static struct clk gpt8_fck = {
 	.name		= "gpt8_fck",
 	.parent		= &func_32k_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_GPT8_SHIFT,
 	.init		= &omap2_init_clksel_parent,
@@ -1735,7 +1735,7 @@ static struct clk gpt9_ick = {
 	.name		= "gpt9_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP24XX_EN_GPT9_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -1745,7 +1745,7 @@ static struct clk gpt9_fck = {
 	.name		= "gpt9_fck",
 	.parent		= &func_32k_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_GPT9_SHIFT,
 	.init		= &omap2_init_clksel_parent,
@@ -1759,7 +1759,7 @@ static struct clk gpt10_ick = {
 	.name		= "gpt10_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP24XX_EN_GPT10_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -1769,7 +1769,7 @@ static struct clk gpt10_fck = {
 	.name		= "gpt10_fck",
 	.parent		= &func_32k_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_GPT10_SHIFT,
 	.init		= &omap2_init_clksel_parent,
@@ -1783,7 +1783,7 @@ static struct clk gpt11_ick = {
 	.name		= "gpt11_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP24XX_EN_GPT11_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -1793,7 +1793,7 @@ static struct clk gpt11_fck = {
 	.name		= "gpt11_fck",
 	.parent		= &func_32k_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_GPT11_SHIFT,
 	.init		= &omap2_init_clksel_parent,
@@ -1807,7 +1807,7 @@ static struct clk gpt12_ick = {
 	.name		= "gpt12_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP24XX_EN_GPT12_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -1817,7 +1817,7 @@ static struct clk gpt12_fck = {
 	.name		= "gpt12_fck",
 	.parent		= &func_32k_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_GPT12_SHIFT,
 	.init		= &omap2_init_clksel_parent,
@@ -1832,7 +1832,7 @@ static struct clk mcbsp1_ick = {
 	.id		= 1,
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP24XX_EN_MCBSP1_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -1843,7 +1843,7 @@ static struct clk mcbsp1_fck = {
 	.id		= 1,
 	.parent		= &func_96m_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_MCBSP1_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -1854,7 +1854,7 @@ static struct clk mcbsp2_ick = {
 	.id		= 2,
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP24XX_EN_MCBSP2_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -1865,7 +1865,7 @@ static struct clk mcbsp2_fck = {
 	.id		= 2,
 	.parent		= &func_96m_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_MCBSP2_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -1876,7 +1876,7 @@ static struct clk mcbsp3_ick = {
 	.id		= 3,
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN2),
 	.enable_bit	= OMAP2430_EN_MCBSP3_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -1887,7 +1887,7 @@ static struct clk mcbsp3_fck = {
 	.id		= 3,
 	.parent		= &func_96m_ck,
 	.flags		= CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_FCLKEN2),
 	.enable_bit	= OMAP2430_EN_MCBSP3_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -1898,7 +1898,7 @@ static struct clk mcbsp4_ick = {
 	.id		= 4,
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN2),
 	.enable_bit	= OMAP2430_EN_MCBSP4_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -1909,7 +1909,7 @@ static struct clk mcbsp4_fck = {
 	.id		= 4,
 	.parent		= &func_96m_ck,
 	.flags		= CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_FCLKEN2),
 	.enable_bit	= OMAP2430_EN_MCBSP4_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -1920,7 +1920,7 @@ static struct clk mcbsp5_ick = {
 	.id		= 5,
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN2),
 	.enable_bit	= OMAP2430_EN_MCBSP5_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -1931,7 +1931,7 @@ static struct clk mcbsp5_fck = {
 	.id		= 5,
 	.parent		= &func_96m_ck,
 	.flags		= CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_FCLKEN2),
 	.enable_bit	= OMAP2430_EN_MCBSP5_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -1941,7 +1941,7 @@ static struct clk mcspi1_ick = {
 	.name		= "mcspi_ick",
 	.id		= 1,
 	.parent		= &l4_ck,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP24XX_EN_MCSPI1_SHIFT,
@@ -1953,7 +1953,7 @@ static struct clk mcspi1_fck = {
 	.id		= 1,
 	.parent		= &func_48m_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_MCSPI1_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -1964,7 +1964,7 @@ static struct clk mcspi2_ick = {
 	.id		= 2,
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP24XX_EN_MCSPI2_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -1975,7 +1975,7 @@ static struct clk mcspi2_fck = {
 	.id		= 2,
 	.parent		= &func_48m_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_MCSPI2_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -1986,7 +1986,7 @@ static struct clk mcspi3_ick = {
 	.id		= 3,
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN2),
 	.enable_bit	= OMAP2430_EN_MCSPI3_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -1997,7 +1997,7 @@ static struct clk mcspi3_fck = {
 	.id		= 3,
 	.parent		= &func_48m_ck,
 	.flags		= CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_FCLKEN2),
 	.enable_bit	= OMAP2430_EN_MCSPI3_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2007,7 +2007,7 @@ static struct clk uart1_ick = {
 	.name		= "uart1_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP24XX_EN_UART1_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2017,7 +2017,7 @@ static struct clk uart1_fck = {
 	.name		= "uart1_fck",
 	.parent		= &func_48m_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_UART1_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2027,7 +2027,7 @@ static struct clk uart2_ick = {
 	.name		= "uart2_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP24XX_EN_UART2_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2037,7 +2037,7 @@ static struct clk uart2_fck = {
 	.name		= "uart2_fck",
 	.parent		= &func_48m_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_UART2_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2047,7 +2047,7 @@ static struct clk uart3_ick = {
 	.name		= "uart3_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN2),
 	.enable_bit	= OMAP24XX_EN_UART3_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2057,7 +2057,7 @@ static struct clk uart3_fck = {
 	.name		= "uart3_fck",
 	.parent		= &func_48m_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_FCLKEN2),
 	.enable_bit	= OMAP24XX_EN_UART3_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2067,7 +2067,7 @@ static struct clk gpios_ick = {
 	.name		= "gpios_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(WKUP_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP24XX_EN_GPIOS_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2077,7 +2077,7 @@ static struct clk gpios_fck = {
 	.name		= "gpios_fck",
 	.parent		= &func_32k_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.clkdm_name	= "wkup_clkdm",
+	.clkdm		= { .name = "wkup_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(WKUP_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP24XX_EN_GPIOS_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2087,7 +2087,7 @@ static struct clk mpu_wdt_ick = {
 	.name		= "mpu_wdt_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(WKUP_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP24XX_EN_MPU_WDT_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2097,7 +2097,7 @@ static struct clk mpu_wdt_fck = {
 	.name		= "mpu_wdt_fck",
 	.parent		= &func_32k_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.clkdm_name	= "wkup_clkdm",
+	.clkdm		= { .name = "wkup_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(WKUP_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP24XX_EN_MPU_WDT_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2108,7 +2108,7 @@ static struct clk sync_32k_ick = {
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				ENABLE_ON_INIT,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(WKUP_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP24XX_EN_32KSYNC_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2118,7 +2118,7 @@ static struct clk wdt1_ick = {
 	.name		= "wdt1_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(WKUP_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP24XX_EN_WDT1_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2129,7 +2129,7 @@ static struct clk omapctrl_ick = {
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				ENABLE_ON_INIT,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(WKUP_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP24XX_EN_OMAPCTRL_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2139,7 +2139,7 @@ static struct clk icr_ick = {
 	.name		= "icr_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(WKUP_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP2430_EN_ICR_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2149,7 +2149,7 @@ static struct clk cam_ick = {
 	.name		= "cam_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP24XX_EN_CAM_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2164,7 +2164,7 @@ static struct clk cam_fck = {
 	.name		= "cam_fck",
 	.parent		= &func_96m_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l3_clkdm",
+	.clkdm		= { .name = "core_l3_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_CAM_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2174,7 +2174,7 @@ static struct clk mailboxes_ick = {
 	.name		= "mailboxes_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP24XX_EN_MAILBOXES_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2184,7 +2184,7 @@ static struct clk wdt4_ick = {
 	.name		= "wdt4_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP24XX_EN_WDT4_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2194,7 +2194,7 @@ static struct clk wdt4_fck = {
 	.name		= "wdt4_fck",
 	.parent		= &func_32k_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_WDT4_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2204,7 +2204,7 @@ static struct clk wdt3_ick = {
 	.name		= "wdt3_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP2420_EN_WDT3_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2214,7 +2214,7 @@ static struct clk wdt3_fck = {
 	.name		= "wdt3_fck",
 	.parent		= &func_32k_ck,
 	.flags		= CLOCK_IN_OMAP242X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP2420_EN_WDT3_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2224,7 +2224,7 @@ static struct clk mspro_ick = {
 	.name		= "mspro_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP24XX_EN_MSPRO_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2234,7 +2234,7 @@ static struct clk mspro_fck = {
 	.name		= "mspro_fck",
 	.parent		= &func_96m_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_MSPRO_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2244,7 +2244,7 @@ static struct clk mmc_ick = {
 	.name		= "mmc_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP2420_EN_MMC_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2254,7 +2254,7 @@ static struct clk mmc_fck = {
 	.name		= "mmc_fck",
 	.parent		= &func_96m_ck,
 	.flags		= CLOCK_IN_OMAP242X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP2420_EN_MMC_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2264,7 +2264,7 @@ static struct clk fac_ick = {
 	.name		= "fac_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP24XX_EN_FAC_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2274,7 +2274,7 @@ static struct clk fac_fck = {
 	.name		= "fac_fck",
 	.parent		= &func_12m_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_FAC_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2284,7 +2284,7 @@ static struct clk eac_ick = {
 	.name		= "eac_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP2420_EN_EAC_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2294,7 +2294,7 @@ static struct clk eac_fck = {
 	.name		= "eac_fck",
 	.parent		= &func_96m_ck,
 	.flags		= CLOCK_IN_OMAP242X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP2420_EN_EAC_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2304,7 +2304,7 @@ static struct clk hdq_ick = {
 	.name		= "hdq_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP24XX_EN_HDQ_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2314,7 +2314,7 @@ static struct clk hdq_fck = {
 	.name		= "hdq_fck",
 	.parent		= &func_12m_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_HDQ_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2325,7 +2325,7 @@ static struct clk i2c2_ick = {
 	.id		= 2,
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP2420_EN_I2C2_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2336,7 +2336,7 @@ static struct clk i2c2_fck = {
 	.id		= 2,
 	.parent		= &func_12m_ck,
 	.flags		= CLOCK_IN_OMAP242X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP2420_EN_I2C2_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2347,7 +2347,7 @@ static struct clk i2chs2_fck = {
 	.id		= 2,
 	.parent		= &func_96m_ck,
 	.flags		= CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_FCLKEN2),
 	.enable_bit	= OMAP2430_EN_I2CHS2_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2358,7 +2358,7 @@ static struct clk i2c1_ick = {
 	.id		= 1,
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP2420_EN_I2C1_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2369,7 +2369,7 @@ static struct clk i2c1_fck = {
 	.id		= 1,
 	.parent		= &func_12m_ck,
 	.flags		= CLOCK_IN_OMAP242X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP2420_EN_I2C1_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2380,7 +2380,7 @@ static struct clk i2chs1_fck = {
 	.id		= 1,
 	.parent		= &func_96m_ck,
 	.flags		= CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_FCLKEN2),
 	.enable_bit	= OMAP2430_EN_I2CHS1_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2391,7 +2391,7 @@ static struct clk gpmc_fck = {
 	.parent		= &core_l3_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				ENABLE_ON_INIT,
-	.clkdm_name	= "core_l3_clkdm",
+	.clkdm		= { .name = "core_l3_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -2399,7 +2399,7 @@ static struct clk sdma_fck = {
 	.name		= "sdma_fck",
 	.parent		= &core_l3_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l3_clkdm",
+	.clkdm		= { .name = "core_l3_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -2407,7 +2407,7 @@ static struct clk sdma_ick = {
 	.name		= "sdma_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l3_clkdm",
+	.clkdm		= { .name = "core_l3_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -2415,7 +2415,7 @@ static struct clk vlynq_ick = {
 	.name		= "vlynq_ick",
 	.parent		= &core_l3_ck,
 	.flags		= CLOCK_IN_OMAP242X,
-	.clkdm_name	= "core_l3_clkdm",
+	.clkdm		= { .name = "core_l3_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP2420_EN_VLYNQ_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2450,7 +2450,7 @@ static struct clk vlynq_fck = {
 	.name		= "vlynq_fck",
 	.parent		= &func_96m_ck,
 	.flags		= CLOCK_IN_OMAP242X | DELAYED_APP,
-	.clkdm_name	= "core_l3_clkdm",
+	.clkdm		= { .name = "core_l3_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP2420_EN_VLYNQ_SHIFT,
 	.init		= &omap2_init_clksel_parent,
@@ -2466,7 +2466,7 @@ static struct clk sdrc_ick = {
 	.name		= "sdrc_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP243X | ENABLE_ON_INIT,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN3),
 	.enable_bit	= OMAP2430_EN_SDRC_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2476,7 +2476,7 @@ static struct clk des_ick = {
 	.name		= "des_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP243X | CLOCK_IN_OMAP242X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_ICLKEN4),
 	.enable_bit	= OMAP24XX_EN_DES_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2486,7 +2486,7 @@ static struct clk sha_ick = {
 	.name		= "sha_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP243X | CLOCK_IN_OMAP242X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_ICLKEN4),
 	.enable_bit	= OMAP24XX_EN_SHA_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2496,7 +2496,7 @@ static struct clk rng_ick = {
 	.name		= "rng_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP243X | CLOCK_IN_OMAP242X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_ICLKEN4),
 	.enable_bit	= OMAP24XX_EN_RNG_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2506,7 +2506,7 @@ static struct clk aes_ick = {
 	.name		= "aes_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP243X | CLOCK_IN_OMAP242X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_ICLKEN4),
 	.enable_bit	= OMAP24XX_EN_AES_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2516,7 +2516,7 @@ static struct clk pka_ick = {
 	.name		= "pka_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP243X | CLOCK_IN_OMAP242X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_ICLKEN4),
 	.enable_bit	= OMAP24XX_EN_PKA_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2526,7 +2526,7 @@ static struct clk usb_fck = {
 	.name		= "usb_fck",
 	.parent		= &func_48m_ck,
 	.flags		= CLOCK_IN_OMAP243X | CLOCK_IN_OMAP242X,
-	.clkdm_name	= "core_l3_clkdm",
+	.clkdm		= { .name = "core_l3_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_FCLKEN2),
 	.enable_bit	= OMAP24XX_EN_USB_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2536,7 +2536,7 @@ static struct clk usbhs_ick = {
 	.name		= "usbhs_ick",
 	.parent		= &core_l3_ck,
 	.flags		= CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l3_clkdm",
+	.clkdm		= { .name = "core_l3_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN2),
 	.enable_bit	= OMAP2430_EN_USBHS_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2546,7 +2546,7 @@ static struct clk mmchs1_ick = {
 	.name		= "mmchs_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN2),
 	.enable_bit	= OMAP2430_EN_MMCHS1_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2556,7 +2556,7 @@ static struct clk mmchs1_fck = {
 	.name		= "mmchs_fck",
 	.parent		= &func_96m_ck,
 	.flags		= CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l3_clkdm",
+	.clkdm		= { .name = "core_l3_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_FCLKEN2),
 	.enable_bit	= OMAP2430_EN_MMCHS1_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2567,7 +2567,7 @@ static struct clk mmchs2_ick = {
 	.id		= 1,
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN2),
 	.enable_bit	= OMAP2430_EN_MMCHS2_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2587,7 +2587,7 @@ static struct clk gpio5_ick = {
 	.name		= "gpio5_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN2),
 	.enable_bit	= OMAP2430_EN_GPIO5_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2597,7 +2597,7 @@ static struct clk gpio5_fck = {
 	.name		= "gpio5_fck",
 	.parent		= &func_32k_ck,
 	.flags		= CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_FCLKEN2),
 	.enable_bit	= OMAP2430_EN_GPIO5_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2607,7 +2607,7 @@ static struct clk mdm_intc_ick = {
 	.name		= "mdm_intc_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN2),
 	.enable_bit	= OMAP2430_EN_MDM_INTC_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2617,7 +2617,7 @@ static struct clk mmchsdb1_fck = {
 	.name		= "mmchsdb_fck",
 	.parent		= &func_32k_ck,
 	.flags		= CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_FCLKEN2),
 	.enable_bit	= OMAP2430_EN_MMCHSDB1_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2628,7 +2628,7 @@ static struct clk mmchsdb2_fck = {
 	.id		= 1,
 	.parent		= &func_32k_ck,
 	.flags		= CLOCK_IN_OMAP243X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_FCLKEN2),
 	.enable_bit	= OMAP2430_EN_MMCHSDB2_SHIFT,
 	.recalc		= &followparent_recalc,
diff --git a/arch/arm/mach-omap2/clock34xx.h b/arch/arm/mach-omap2/clock34xx.h
index 419b09f..147a8b2 100644
--- a/arch/arm/mach-omap2/clock34xx.h
+++ b/arch/arm/mach-omap2/clock34xx.h
@@ -1088,7 +1088,7 @@ static struct clk mpu_ck = {
 	.clksel		= mpu_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
 				PARENT_CONTROLS_CLOCK,
-	.clkdm_name	= "mpu_clkdm",
+	.clkdm		= { .name = "mpu_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -1166,7 +1166,7 @@ static struct clk iva2_ck = {
 	.clksel_mask	= OMAP3430_ST_IVA2_CLK_MASK,
 	.clksel		= iva2_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES,
-	.clkdm_name	= "iva2_clkdm",
+	.clkdm		= { .name = "iva2_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -1181,7 +1181,7 @@ static struct clk l3_ick = {
 	.clksel		= div2_core_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
 				PARENT_CONTROLS_CLOCK,
-	.clkdm_name	= "core_l3_clkdm",
+	.clkdm		= { .name = "core_l3_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -1199,7 +1199,7 @@ static struct clk l4_ick = {
 	.clksel		= div2_l3_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
 				PARENT_CONTROLS_CLOCK,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 
 };
@@ -1249,7 +1249,7 @@ static struct clk gfx_l3_fck = {
 	.clksel		= gfx_l3_clksel,
 	.flags		= CLOCK_IN_OMAP3430ES1 | RATE_PROPAGATES |
 				PARENT_CONTROLS_CLOCK,
-	.clkdm_name	= "gfx_3430es1_clkdm",
+	.clkdm		= { .name = "gfx_3430es1_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -1257,7 +1257,7 @@ static struct clk gfx_l3_ick = {
 	.name		= "gfx_l3_ick",
 	.parent		= &gfx_l3_ck,
 	.flags		= CLOCK_IN_OMAP3430ES1 | PARENT_CONTROLS_CLOCK,
-	.clkdm_name	= "gfx_3430es1_clkdm",
+	.clkdm		= { .name = "gfx_3430es1_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -1268,7 +1268,7 @@ static struct clk gfx_cg1_ck = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(GFX_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430ES1_EN_2D_SHIFT,
 	.flags		= CLOCK_IN_OMAP3430ES1,
-	.clkdm_name	= "gfx_3430es1_clkdm",
+	.clkdm		= { .name = "gfx_3430es1_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -1279,7 +1279,7 @@ static struct clk gfx_cg2_ck = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(GFX_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430ES1_EN_3D_SHIFT,
 	.flags		= CLOCK_IN_OMAP3430ES1,
-	.clkdm_name	= "gfx_3430es1_clkdm",
+	.clkdm		= { .name = "gfx_3430es1_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -1312,7 +1312,7 @@ static struct clk sgx_fck = {
 	.clksel_mask	= OMAP3430ES2_CLKSEL_SGX_MASK,
 	.clksel		= sgx_clksel,
 	.flags		= CLOCK_IN_OMAP3430ES2,
-	.clkdm_name	= "sgx_clkdm",
+	.clkdm		= { .name = "sgx_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -1323,7 +1323,7 @@ static struct clk sgx_ick = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430ES2_SGX_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430ES2_CM_ICLKEN_SGX_EN_SGX_SHIFT,
 	.flags		= CLOCK_IN_OMAP3430ES2,
-	.clkdm_name	= "sgx_clkdm",
+	.clkdm		= { .name = "sgx_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -1336,7 +1336,7 @@ static struct clk d2d_26m_fck = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP3430ES1_EN_D2D_SHIFT,
 	.flags		= CLOCK_IN_OMAP3430ES1,
-	.clkdm_name	= "d2d_clkdm",
+	.clkdm		= { .name = "d2d_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -1356,7 +1356,7 @@ static struct clk gpt10_fck = {
 	.clksel_mask	= OMAP3430_CLKSEL_GPT10_MASK,
 	.clksel		= omap343x_gpt_clksel,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -1370,7 +1370,7 @@ static struct clk gpt11_fck = {
 	.clksel_mask	= OMAP3430_CLKSEL_GPT11_MASK,
 	.clksel		= omap343x_gpt_clksel,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -1408,7 +1408,7 @@ static struct clk core_96m_fck = {
 	.parent		= &omap_96m_fck,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
 				PARENT_CONTROLS_CLOCK,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -1419,7 +1419,7 @@ static struct clk mmchs3_fck = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP3430ES2_EN_MMC3_SHIFT,
 	.flags		= CLOCK_IN_OMAP3430ES2,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -1430,7 +1430,7 @@ static struct clk mmchs2_fck = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP3430_EN_MMC2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -1440,7 +1440,7 @@ static struct clk mspro_fck = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP3430_EN_MSPRO_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -1450,7 +1450,7 @@ static struct clk mmchs1_fck = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP3430_EN_MMC1_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -1461,7 +1461,7 @@ static struct clk i2c3_fck = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP3430_EN_I2C3_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -1472,7 +1472,7 @@ static struct clk i2c2_fck = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP3430_EN_I2C2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -1483,7 +1483,7 @@ static struct clk i2c1_fck = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP3430_EN_I2C1_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -1517,7 +1517,7 @@ static struct clk mcbsp5_fck = {
 	.clksel_mask	= OMAP2_MCBSP5_CLKS_MASK,
 	.clksel		= mcbsp_15_clksel,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -1531,7 +1531,7 @@ static struct clk mcbsp1_fck = {
 	.clksel_mask	= OMAP2_MCBSP1_CLKS_MASK,
 	.clksel		= mcbsp_15_clksel,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -1542,7 +1542,7 @@ static struct clk core_48m_fck = {
 	.parent		= &omap_48m_fck,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
 				PARENT_CONTROLS_CLOCK,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -1620,7 +1620,7 @@ static struct clk core_12m_fck = {
 	.parent		= &omap_12m_fck,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
 				PARENT_CONTROLS_CLOCK,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -1659,7 +1659,7 @@ static struct clk ssi_ssr_fck = {
 	.clksel_mask	= OMAP3430_CLKSEL_SSI_MASK,
 	.clksel		= ssi_ssr_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -1685,7 +1685,7 @@ static struct clk core_l3_ick = {
 	.init		= &omap2_init_clk_clkdm,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
 				PARENT_CONTROLS_CLOCK,
-	.clkdm_name	= "core_l3_clkdm",
+	.clkdm		= { .name = "core_l3_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -1695,7 +1695,7 @@ static struct clk hsotgusb_ick = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_HSOTGUSB_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "core_l3_clkdm",
+	.clkdm		= { .name = "core_l3_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -1705,7 +1705,7 @@ static struct clk sdrc_ick = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_SDRC_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X | ENABLE_ON_INIT,
-	.clkdm_name	= "core_l3_clkdm",
+	.clkdm		= { .name = "core_l3_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -1714,7 +1714,7 @@ static struct clk gpmc_fck = {
 	.parent		= &core_l3_ick,
 	.flags		= CLOCK_IN_OMAP343X | PARENT_CONTROLS_CLOCK |
 				ENABLE_ON_INIT,
-	.clkdm_name	= "core_l3_clkdm",
+	.clkdm		= { .name = "core_l3_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -1745,7 +1745,7 @@ static struct clk core_l4_ick = {
 	.init		= &omap2_init_clk_clkdm,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
 				PARENT_CONTROLS_CLOCK,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -1755,7 +1755,7 @@ static struct clk usbtll_ick = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN3),
 	.enable_bit	= OMAP3430ES2_EN_USBTLL_SHIFT,
 	.flags		= CLOCK_IN_OMAP3430ES2,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -1766,7 +1766,7 @@ static struct clk mmchs3_ick = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430ES2_EN_MMC3_SHIFT,
 	.flags		= CLOCK_IN_OMAP3430ES2,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -1777,7 +1777,7 @@ static struct clk icr_ick = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_ICR_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -1787,7 +1787,7 @@ static struct clk aes2_ick = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_AES2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -1797,7 +1797,7 @@ static struct clk sha12_ick = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_SHA12_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -1807,7 +1807,7 @@ static struct clk des2_ick = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_DES2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -1818,7 +1818,7 @@ static struct clk mmchs2_ick = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_MMC2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -1828,7 +1828,7 @@ static struct clk mmchs1_ick = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_MMC1_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -1838,7 +1838,7 @@ static struct clk mspro_ick = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_MSPRO_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -1848,7 +1848,7 @@ static struct clk hdq_ick = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_HDQ_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -1859,7 +1859,7 @@ static struct clk mcspi4_ick = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_MCSPI4_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -1870,7 +1870,7 @@ static struct clk mcspi3_ick = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_MCSPI3_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -1881,7 +1881,7 @@ static struct clk mcspi2_ick = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_MCSPI2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -1892,7 +1892,7 @@ static struct clk mcspi1_ick = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_MCSPI1_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -1903,7 +1903,7 @@ static struct clk i2c3_ick = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_I2C3_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -1914,7 +1914,7 @@ static struct clk i2c2_ick = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_I2C2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -1925,7 +1925,7 @@ static struct clk i2c1_ick = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_I2C1_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -1935,7 +1935,7 @@ static struct clk uart2_ick = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_UART2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -1945,7 +1945,7 @@ static struct clk uart1_ick = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_UART1_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -1955,7 +1955,7 @@ static struct clk gpt11_ick = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_GPT11_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -1965,7 +1965,7 @@ static struct clk gpt10_ick = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_GPT10_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -1976,7 +1976,7 @@ static struct clk mcbsp5_ick = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_MCBSP5_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -1987,7 +1987,7 @@ static struct clk mcbsp1_ick = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_MCBSP1_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -1997,7 +1997,7 @@ static struct clk fac_ick = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430ES1_EN_FAC_SHIFT,
 	.flags		= CLOCK_IN_OMAP3430ES1,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -2007,7 +2007,7 @@ static struct clk mailboxes_ick = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_MAILBOXES_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -2027,7 +2027,7 @@ static struct clk ssi_l4_ick = {
 	.parent		= &l4_ick,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
 				PARENT_CONTROLS_CLOCK,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -2037,7 +2037,7 @@ static struct clk ssi_ick = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_SSI_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -2127,7 +2127,7 @@ static struct clk dss1_alwon_fck = {
 	.clksel_mask	= OMAP3430_ST_PERIPH_CLK_MASK,
 	.clksel		= dss1_alwon_fck_clksel,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "dss_clkdm",
+	.clkdm		= { .name = "dss_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -2138,7 +2138,7 @@ static struct clk dss_tv_fck = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_DSS_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_EN_TV_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "dss_clkdm",
+	.clkdm		= { .name = "dss_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -2149,7 +2149,7 @@ static struct clk dss_96m_fck = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_DSS_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_EN_TV_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "dss_clkdm",
+	.clkdm		= { .name = "dss_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -2160,7 +2160,7 @@ static struct clk dss2_alwon_fck = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_DSS_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_EN_DSS2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "dss_clkdm",
+	.clkdm		= { .name = "dss_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -2172,7 +2172,7 @@ static struct clk dss_ick = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_DSS_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_CM_ICLKEN_DSS_EN_DSS_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "dss_clkdm",
+	.clkdm		= { .name = "dss_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -2194,7 +2194,7 @@ static struct clk cam_mclk = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_CAM_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_EN_CAM_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "cam_clkdm",
+	.clkdm		= { .name = "cam_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -2206,7 +2206,7 @@ static struct clk cam_ick = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_CAM_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_CAM_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "cam_clkdm",
+	.clkdm		= { .name = "cam_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -2217,7 +2217,7 @@ static struct clk csi2_96m_fck = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_CAM_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_EN_CSI2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "cam_clkdm",
+	.clkdm		= { .name = "cam_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -2230,7 +2230,7 @@ static struct clk usbhost_120m_fck = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430ES2_USBHOST_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430ES2_EN_USBHOST2_SHIFT,
 	.flags		= CLOCK_IN_OMAP3430ES2,
-	.clkdm_name	= "usbhost_clkdm",
+	.clkdm		= { .name = "usbhost_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -2241,7 +2241,7 @@ static struct clk usbhost_48m_fck = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430ES2_USBHOST_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430ES2_EN_USBHOST1_SHIFT,
 	.flags		= CLOCK_IN_OMAP3430ES2,
-	.clkdm_name	= "usbhost_clkdm",
+	.clkdm		= { .name = "usbhost_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -2253,7 +2253,7 @@ static struct clk usbhost_ick = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430ES2_USBHOST_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430ES2_EN_USBHOST_SHIFT,
 	.flags		= CLOCK_IN_OMAP3430ES2,
-	.clkdm_name	= "usbhost_clkdm",
+	.clkdm		= { .name = "usbhost_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -2305,7 +2305,7 @@ static struct clk gpt1_fck = {
 	.clksel_mask	= OMAP3430_CLKSEL_GPT1_MASK,
 	.clksel		= omap343x_gpt_clksel,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "wkup_clkdm",
+	.clkdm		= { .name = "wkup_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -2314,7 +2314,7 @@ static struct clk wkup_32k_fck = {
 	.init		= &omap2_init_clk_clkdm,
 	.parent		= &omap_32k_fck,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | ALWAYS_ENABLED,
-	.clkdm_name	= "wkup_clkdm",
+	.clkdm		= { .name = "wkup_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -2324,7 +2324,7 @@ static struct clk gpio1_dbck = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(WKUP_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_EN_GPIO1_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "wkup_clkdm",
+	.clkdm		= { .name = "wkup_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -2334,7 +2334,7 @@ static struct clk wdt2_fck = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(WKUP_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_EN_WDT2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "wkup_clkdm",
+	.clkdm		= { .name = "wkup_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -2342,7 +2342,7 @@ static struct clk wkup_l4_ick = {
 	.name		= "wkup_l4_ick",
 	.parent		= &sys_ck,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | ALWAYS_ENABLED,
-	.clkdm_name	= "wkup_clkdm",
+	.clkdm		= { .name = "wkup_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -2354,7 +2354,7 @@ static struct clk usim_ick = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(WKUP_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430ES2_EN_USIMOCP_SHIFT,
 	.flags		= CLOCK_IN_OMAP3430ES2,
-	.clkdm_name	= "wkup_clkdm",
+	.clkdm		= { .name = "wkup_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -2364,7 +2364,7 @@ static struct clk wdt2_ick = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(WKUP_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_WDT2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "wkup_clkdm",
+	.clkdm		= { .name = "wkup_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -2374,7 +2374,7 @@ static struct clk wdt1_ick = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(WKUP_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_WDT1_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "wkup_clkdm",
+	.clkdm		= { .name = "wkup_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -2384,7 +2384,7 @@ static struct clk gpio1_ick = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(WKUP_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_GPIO1_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "wkup_clkdm",
+	.clkdm		= { .name = "wkup_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -2394,7 +2394,7 @@ static struct clk omap_32ksync_ick = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(WKUP_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_32KSYNC_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "wkup_clkdm",
+	.clkdm		= { .name = "wkup_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -2405,7 +2405,7 @@ static struct clk gpt12_ick = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(WKUP_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_GPT12_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "wkup_clkdm",
+	.clkdm		= { .name = "wkup_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -2415,7 +2415,7 @@ static struct clk gpt1_ick = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(WKUP_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_GPT1_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "wkup_clkdm",
+	.clkdm		= { .name = "wkup_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -2429,7 +2429,7 @@ static struct clk per_96m_fck = {
 	.init		= &omap2_init_clk_clkdm,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
 				PARENT_CONTROLS_CLOCK,
-	.clkdm_name	= "per_clkdm",
+	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -2439,7 +2439,7 @@ static struct clk per_48m_fck = {
 	.init		= &omap2_init_clk_clkdm,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
 				PARENT_CONTROLS_CLOCK,
-	.clkdm_name	= "per_clkdm",
+	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -2449,7 +2449,7 @@ static struct clk uart3_fck = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_EN_UART3_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "per_clkdm",
+	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -2462,7 +2462,7 @@ static struct clk gpt2_fck = {
 	.clksel_mask	= OMAP3430_CLKSEL_GPT2_MASK,
 	.clksel		= omap343x_gpt_clksel,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "per_clkdm",
+	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -2475,7 +2475,7 @@ static struct clk gpt3_fck = {
 	.clksel_mask	= OMAP3430_CLKSEL_GPT3_MASK,
 	.clksel		= omap343x_gpt_clksel,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "per_clkdm",
+	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -2488,7 +2488,7 @@ static struct clk gpt4_fck = {
 	.clksel_mask	= OMAP3430_CLKSEL_GPT4_MASK,
 	.clksel		= omap343x_gpt_clksel,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "per_clkdm",
+	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -2501,7 +2501,7 @@ static struct clk gpt5_fck = {
 	.clksel_mask	= OMAP3430_CLKSEL_GPT5_MASK,
 	.clksel		= omap343x_gpt_clksel,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "per_clkdm",
+	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -2514,7 +2514,7 @@ static struct clk gpt6_fck = {
 	.clksel_mask	= OMAP3430_CLKSEL_GPT6_MASK,
 	.clksel		= omap343x_gpt_clksel,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "per_clkdm",
+	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -2527,7 +2527,7 @@ static struct clk gpt7_fck = {
 	.clksel_mask	= OMAP3430_CLKSEL_GPT7_MASK,
 	.clksel		= omap343x_gpt_clksel,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "per_clkdm",
+	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -2540,7 +2540,7 @@ static struct clk gpt8_fck = {
 	.clksel_mask	= OMAP3430_CLKSEL_GPT8_MASK,
 	.clksel		= omap343x_gpt_clksel,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "per_clkdm",
+	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -2553,14 +2553,14 @@ static struct clk gpt9_fck = {
 	.clksel_mask	= OMAP3430_CLKSEL_GPT9_MASK,
 	.clksel		= omap343x_gpt_clksel,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "per_clkdm",
+	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
 
 static struct clk per_32k_alwon_fck = {
 	.name		= "per_32k_alwon_fck",
 	.parent		= &omap_32k_fck,
-	.clkdm_name	= "per_clkdm",
+	.clkdm		= { .name = "per_clkdm" },
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | ALWAYS_ENABLED,
 	.recalc		= &followparent_recalc,
 };
@@ -2571,7 +2571,7 @@ static struct clk gpio6_dbck = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_EN_GPIO6_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "per_clkdm",
+	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -2581,7 +2581,7 @@ static struct clk gpio5_dbck = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_EN_GPIO5_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "per_clkdm",
+	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -2591,7 +2591,7 @@ static struct clk gpio4_dbck = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_EN_GPIO4_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "per_clkdm",
+	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -2601,7 +2601,7 @@ static struct clk gpio3_dbck = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_EN_GPIO3_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "per_clkdm",
+	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -2611,7 +2611,7 @@ static struct clk gpio2_dbck = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_EN_GPIO2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "per_clkdm",
+	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -2621,7 +2621,7 @@ static struct clk wdt3_fck = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_EN_WDT3_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "per_clkdm",
+	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -2630,7 +2630,7 @@ static struct clk per_l4_ick = {
 	.parent		= &l4_ick,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
 				PARENT_CONTROLS_CLOCK,
-	.clkdm_name	= "per_clkdm",
+	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -2640,7 +2640,7 @@ static struct clk gpio6_ick = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_GPIO6_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "per_clkdm",
+	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -2650,7 +2650,7 @@ static struct clk gpio5_ick = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_GPIO5_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "per_clkdm",
+	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -2660,7 +2660,7 @@ static struct clk gpio4_ick = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_GPIO4_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "per_clkdm",
+	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -2670,7 +2670,7 @@ static struct clk gpio3_ick = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_GPIO3_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "per_clkdm",
+	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -2680,7 +2680,7 @@ static struct clk gpio2_ick = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_GPIO2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "per_clkdm",
+	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -2690,7 +2690,7 @@ static struct clk wdt3_ick = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_WDT3_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "per_clkdm",
+	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -2700,7 +2700,7 @@ static struct clk uart3_ick = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_UART3_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "per_clkdm",
+	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -2710,7 +2710,7 @@ static struct clk gpt9_ick = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_GPT9_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "per_clkdm",
+	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -2720,7 +2720,7 @@ static struct clk gpt8_ick = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_GPT8_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "per_clkdm",
+	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -2730,7 +2730,7 @@ static struct clk gpt7_ick = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_GPT7_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "per_clkdm",
+	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -2740,7 +2740,7 @@ static struct clk gpt6_ick = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_GPT6_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "per_clkdm",
+	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -2750,7 +2750,7 @@ static struct clk gpt5_ick = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_GPT5_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "per_clkdm",
+	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -2760,7 +2760,7 @@ static struct clk gpt4_ick = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_GPT4_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "per_clkdm",
+	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -2770,7 +2770,7 @@ static struct clk gpt3_ick = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_GPT3_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "per_clkdm",
+	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -2780,7 +2780,7 @@ static struct clk gpt2_ick = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_GPT2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "per_clkdm",
+	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -2791,7 +2791,7 @@ static struct clk mcbsp2_ick = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_MCBSP2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "per_clkdm",
+	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -2802,7 +2802,7 @@ static struct clk mcbsp3_ick = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_MCBSP3_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "per_clkdm",
+	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -2813,7 +2813,7 @@ static struct clk mcbsp4_ick = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_MCBSP4_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "per_clkdm",
+	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -2833,7 +2833,7 @@ static struct clk mcbsp2_fck = {
 	.clksel_mask	= OMAP2_MCBSP2_CLKS_MASK,
 	.clksel		= mcbsp_234_clksel,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "per_clkdm",
+	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -2847,7 +2847,7 @@ static struct clk mcbsp3_fck = {
 	.clksel_mask	= OMAP2_MCBSP3_CLKS_MASK,
 	.clksel		= mcbsp_234_clksel,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "per_clkdm",
+	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -2861,7 +2861,7 @@ static struct clk mcbsp4_fck = {
 	.clksel_mask	= OMAP2_MCBSP4_CLKS_MASK,
 	.clksel		= mcbsp_234_clksel,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "per_clkdm",
+	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -2909,7 +2909,7 @@ static struct clk emu_src_ck = {
 	.clksel_mask	= OMAP3430_MUX_CTRL_MASK,
 	.clksel		= emu_src_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | ALWAYS_ENABLED,
-	.clkdm_name	= "emu_clkdm",
+	.clkdm		= { .name = "emu_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -2933,7 +2933,7 @@ static struct clk pclk_fck = {
 	.clksel_mask	= OMAP3430_CLKSEL_PCLK_MASK,
 	.clksel		= pclk_emu_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | ALWAYS_ENABLED,
-	.clkdm_name	= "emu_clkdm",
+	.clkdm		= { .name = "emu_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -2956,7 +2956,7 @@ static struct clk pclkx2_fck = {
 	.clksel_mask	= OMAP3430_CLKSEL_PCLKX2_MASK,
 	.clksel		= pclkx2_emu_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | ALWAYS_ENABLED,
-	.clkdm_name	= "emu_clkdm",
+	.clkdm		= { .name = "emu_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -2972,7 +2972,7 @@ static struct clk atclk_fck = {
 	.clksel_mask	= OMAP3430_CLKSEL_ATCLK_MASK,
 	.clksel		= atclk_emu_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | ALWAYS_ENABLED,
-	.clkdm_name	= "emu_clkdm",
+	.clkdm		= { .name = "emu_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -2983,7 +2983,7 @@ static struct clk traceclk_src_fck = {
 	.clksel_mask	= OMAP3430_TRACE_MUX_CTRL_MASK,
 	.clksel		= emu_src_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | ALWAYS_ENABLED,
-	.clkdm_name	= "emu_clkdm",
+	.clkdm		= { .name = "emu_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -3006,7 +3006,7 @@ static struct clk traceclk_fck = {
 	.clksel_mask	= OMAP3430_CLKSEL_TRACECLK_MASK,
 	.clksel		= traceclk_clksel,
 	.flags		= CLOCK_IN_OMAP343X | ALWAYS_ENABLED,
-	.clkdm_name	= "emu_clkdm",
+	.clkdm		= { .name = "emu_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -3036,7 +3036,7 @@ static struct clk sr_l4_ick = {
 	.name		= "sr_l4_ick",
 	.parent		= &l4_ick,
 	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "core_l4_clkdm",
+	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
diff --git a/arch/arm/plat-omap/include/mach/clock.h b/arch/arm/plat-omap/include/mach/clock.h
index d78d3a7..c6762e9 100644
--- a/arch/arm/plat-omap/include/mach/clock.h
+++ b/arch/arm/plat-omap/include/mach/clock.h
@@ -81,8 +81,10 @@ struct clk {
 	u32			clksel_mask;
 	const struct clksel	*clksel;
 	struct dpll_data	*dpll_data;
-	const char		*clkdm_name;
-	struct clockdomain	*clkdm;
+	union {
+		const char		*name;
+		struct clockdomain	*ptr;
+	} clkdm;
 #else
 	__u8			rate_offset;
 	__u8			src_offset;


