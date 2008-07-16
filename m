Return-Path: <linux-kernel-owner+w=401wt.eu-S1761064AbYGPPVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761064AbYGPPVv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 11:21:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760068AbYGPPTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 11:19:15 -0400
Received: from mho-01-bos.mailhop.org ([63.208.196.178]:61283 "EHLO
	mho-01-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759423AbYGPPTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 11:19:11 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18YGHPfgNNcATlf060QB/R8
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@lists.linux-foundation.org,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-omap@vger.kernel.org,
       Paul Walmsley <paul@pwsan.com>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 09/10] ARM: OMAP2: Clockdomain: Integrate OMAP3 clocks with clockdomain code
Date: Wed, 16 Jul 2008 18:19:14 +0300
Message-Id: <1216221555-18958-10-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.5.6.rc3.21.g8c6b5
In-Reply-To: <1216221555-18958-9-git-send-email-tony@atomide.com>
References: <1216221555-18958-1-git-send-email-tony@atomide.com>
 <1216221555-18958-2-git-send-email-tony@atomide.com>
 <1216221555-18958-3-git-send-email-tony@atomide.com>
 <1216221555-18958-4-git-send-email-tony@atomide.com>
 <1216221555-18958-5-git-send-email-tony@atomide.com>
 <1216221555-18958-6-git-send-email-tony@atomide.com>
 <1216221555-18958-7-git-send-email-tony@atomide.com>
 <1216221555-18958-8-git-send-email-tony@atomide.com>
 <1216221555-18958-9-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Walmsley <paul@pwsan.com>

This patch integrates the OMAP3 clock tree with the clockdomain code.
This patch:

- marks OMAP34xx clocks with their corresponding clockdomain.

- adds code to convert the clockdomain name to a clockdomain pointer in the
  struct clk during clk_register().

- modifies OMAP2 clock usecounting to call into the clockdomain code
  when clocks are enabled or disabled.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>

diff --git a/arch/arm/mach-omap2/clock.c b/arch/arm/mach-omap2/clock.c
index 15675bc..dd2e28e 100644
--- a/arch/arm/mach-omap2/clock.c
+++ b/arch/arm/mach-omap2/clock.c
@@ -62,10 +62,36 @@
 u8 cpu_mask;
 
 /*-------------------------------------------------------------------------
- * Omap2 specific clock functions
+ * OMAP2/3 specific clock functions
  *-------------------------------------------------------------------------*/
 
 /**
+ * omap2_init_clk_clkdm - look up a clockdomain name, store pointer in clk
+ * @clk: OMAP clock struct ptr to use
+ *
+ * Convert a clockdomain name stored in a struct clk 'clk' into a
+ * clockdomain pointer, and save it into the struct clk.  Intended to be
+ * called during clk_register().  No return value.
+ */
+void omap2_init_clk_clkdm(struct clk *clk)
+{
+	struct clockdomain *clkdm;
+
+	if (!clk->clkdm_name)
+		return;
+
+	clkdm = clkdm_lookup(clk->clkdm_name);
+	if (clkdm) {
+		pr_debug("clock: associated clk %s to clkdm %s\n",
+			 clk->name, clk->clkdm_name);
+		clk->clkdm = clkdm;
+	} else {
+		pr_debug("clock: could not associate clk %s to "
+			 "clkdm %s\n", clk->name, clk->clkdm_name);
+	}
+}
+
+/**
  * omap2_init_clksel_parent - set a clksel clk's parent field from the hardware
  * @clk: OMAP clock struct ptr to use
  *
@@ -308,6 +334,9 @@ void omap2_clk_disable(struct clk *clk)
 		_omap2_clk_disable(clk);
 		if (likely((u32)clk->parent))
 			omap2_clk_disable(clk->parent);
+		if (clk->clkdm)
+			omap2_clkdm_clk_disable(clk->clkdm, clk);
+
 	}
 }
 
@@ -324,11 +353,19 @@ int omap2_clk_enable(struct clk *clk)
 			return ret;
 		}
 
+		if (clk->clkdm)
+			omap2_clkdm_clk_enable(clk->clkdm, clk);
+
 		ret = _omap2_clk_enable(clk);
 
-		if (unlikely(ret != 0) && clk->parent) {
-			omap2_clk_disable(clk->parent);
-			clk->usecount--;
+		if (unlikely(ret != 0)) {
+			if (clk->clkdm)
+				omap2_clkdm_clk_disable(clk->clkdm, clk);
+
+			if (clk->parent) {
+				omap2_clk_disable(clk->parent);
+				clk->usecount--;
+			}
 		}
 	}
 
diff --git a/arch/arm/mach-omap2/clock.h b/arch/arm/mach-omap2/clock.h
index 3cd37cb..611d2ff 100644
--- a/arch/arm/mach-omap2/clock.h
+++ b/arch/arm/mach-omap2/clock.h
@@ -36,6 +36,7 @@ void omap2_clk_disable_unused(struct clk *clk);
 #endif
 
 void omap2_clksel_recalc(struct clk *clk);
+void omap2_init_clk_clkdm(struct clk *clk);
 void omap2_init_clksel_parent(struct clk *clk);
 u32 omap2_clksel_get_divisor(struct clk *clk);
 u32 omap2_clksel_round_rate_div(struct clk *clk, unsigned long target_rate,
diff --git a/arch/arm/mach-omap2/clock34xx.c b/arch/arm/mach-omap2/clock34xx.c
index b008d35..93cb52c 100644
--- a/arch/arm/mach-omap2/clock34xx.c
+++ b/arch/arm/mach-omap2/clock34xx.c
@@ -489,8 +489,10 @@ int __init omap2_clk_init(void)
 	for (clkp = onchip_34xx_clks;
 	     clkp < onchip_34xx_clks + ARRAY_SIZE(onchip_34xx_clks);
 	     clkp++) {
-		if ((*clkp)->flags & cpu_clkflg)
+		if ((*clkp)->flags & cpu_clkflg) {
 			clk_register(*clkp);
+			omap2_init_clk_clkdm(*clkp);
+		}
 	}
 
 	/* REVISIT: Not yet ready for OMAP3 */
diff --git a/arch/arm/mach-omap2/clock34xx.h b/arch/arm/mach-omap2/clock34xx.h
index 05757eb..e8f22c4 100644
--- a/arch/arm/mach-omap2/clock34xx.h
+++ b/arch/arm/mach-omap2/clock34xx.h
@@ -478,7 +478,7 @@ static struct clk dpll3_m2_ck = {
 };
 
 static const struct clksel core_ck_clksel[] = {
-	{ .parent = &sys_ck,      .rates = dpll_bypass_rates },
+	{ .parent = &sys_ck,	  .rates = dpll_bypass_rates },
 	{ .parent = &dpll3_m2_ck, .rates = dpll_locked_rates },
 	{ .parent = NULL }
 };
@@ -495,7 +495,7 @@ static struct clk core_ck = {
 };
 
 static const struct clksel dpll3_m2x2_ck_clksel[] = {
-	{ .parent = &sys_ck,      .rates = dpll_bypass_rates },
+	{ .parent = &sys_ck,	  .rates = dpll_bypass_rates },
 	{ .parent = &dpll3_x2_ck, .rates = dpll_locked_rates },
 	{ .parent = NULL }
 };
@@ -541,7 +541,7 @@ static struct clk dpll3_m3x2_ck = {
 };
 
 static const struct clksel emu_core_alwon_ck_clksel[] = {
-	{ .parent = &sys_ck,        .rates = dpll_bypass_rates },
+	{ .parent = &sys_ck,	    .rates = dpll_bypass_rates },
 	{ .parent = &dpll3_m3x2_ck, .rates = dpll_locked_rates },
 	{ .parent = NULL }
 };
@@ -633,7 +633,7 @@ static struct clk dpll4_m2x2_ck = {
 };
 
 static const struct clksel omap_96m_alwon_fck_clksel[] = {
-	{ .parent = &sys_ck,        .rates = dpll_bypass_rates },
+	{ .parent = &sys_ck,	    .rates = dpll_bypass_rates },
 	{ .parent = &dpll4_m2x2_ck, .rates = dpll_locked_rates },
 	{ .parent = NULL }
 };
@@ -659,7 +659,7 @@ static struct clk omap_96m_fck = {
 };
 
 static const struct clksel cm_96m_fck_clksel[] = {
-	{ .parent = &sys_ck,        .rates = dpll_bypass_rates },
+	{ .parent = &sys_ck,	    .rates = dpll_bypass_rates },
 	{ .parent = &dpll4_m2x2_ck, .rates = dpll_locked_rates },
 	{ .parent = NULL }
 };
@@ -701,7 +701,7 @@ static struct clk dpll4_m3x2_ck = {
 };
 
 static const struct clksel virt_omap_54m_fck_clksel[] = {
-	{ .parent = &sys_ck,        .rates = dpll_bypass_rates },
+	{ .parent = &sys_ck,	    .rates = dpll_bypass_rates },
 	{ .parent = &dpll4_m3x2_ck, .rates = dpll_locked_rates },
 	{ .parent = NULL }
 };
@@ -911,7 +911,7 @@ static struct clk dpll5_m2_ck = {
 };
 
 static const struct clksel omap_120m_fck_clksel[] = {
-	{ .parent = &sys_ck,      .rates = dpll_bypass_rates },
+	{ .parent = &sys_ck,	  .rates = dpll_bypass_rates },
 	{ .parent = &dpll5_m2_ck, .rates = dpll_locked_rates },
 	{ .parent = NULL }
 };
@@ -919,13 +919,13 @@ static const struct clksel omap_120m_fck_clksel[] = {
 static struct clk omap_120m_fck = {
 	.name		= "omap_120m_fck",
 	.parent		= &dpll5_m2_ck,
-	.init           = &omap2_init_clksel_parent,
-	.clksel_reg     = OMAP_CM_REGADDR(PLL_MOD, CM_IDLEST2),
-	.clksel_mask    = OMAP3430ES2_ST_PERIPH2_CLK_MASK,
-	.clksel         = omap_120m_fck_clksel,
+	.init		= &omap2_init_clksel_parent,
+	.clksel_reg	= OMAP_CM_REGADDR(PLL_MOD, CM_IDLEST2),
+	.clksel_mask	= OMAP3430ES2_ST_PERIPH2_CLK_MASK,
+	.clksel		= omap_120m_fck_clksel,
 	.flags		= CLOCK_IN_OMAP3430ES2 | RATE_PROPAGATES |
 				PARENT_CONTROLS_CLOCK,
-	.recalc         = &omap2_clksel_recalc,
+	.recalc		= &omap2_clksel_recalc,
 };
 
 /* CM EXTERNAL CLOCK OUTPUTS */
@@ -1034,7 +1034,7 @@ static struct clk dpll1_fck = {
  * called 'dpll1_fck'
  */
 static const struct clksel mpu_clksel[] = {
-	{ .parent = &dpll1_fck,     .rates = dpll_bypass_rates },
+	{ .parent = &dpll1_fck,	    .rates = dpll_bypass_rates },
 	{ .parent = &dpll1_x2m2_ck, .rates = dpll_locked_rates },
 	{ .parent = NULL }
 };
@@ -1048,6 +1048,7 @@ static struct clk mpu_ck = {
 	.clksel		= mpu_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
 				PARENT_CONTROLS_CLOCK,
+	.clkdm_name	= "mpu_clkdm",
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -1075,6 +1076,8 @@ static struct clk arm_fck = {
 	.recalc		= &omap2_clksel_recalc,
 };
 
+/* XXX What about neon_clkdm ? */
+
 /*
  * REVISIT: This clock is never specifically defined in the 3430 TRM,
  * although it is referenced - so this is a guess
@@ -1107,7 +1110,7 @@ static struct clk dpll2_fck = {
  */
 
 static const struct clksel iva2_clksel[] = {
-	{ .parent = &dpll2_fck,   .rates = dpll_bypass_rates },
+	{ .parent = &dpll2_fck,	  .rates = dpll_bypass_rates },
 	{ .parent = &dpll2_m2_ck, .rates = dpll_locked_rates },
 	{ .parent = NULL }
 };
@@ -1123,6 +1126,7 @@ static struct clk iva2_ck = {
 	.clksel_mask	= OMAP3430_ST_IVA2_CLK_MASK,
 	.clksel		= iva2_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES,
+	.clkdm_name	= "iva2_clkdm",
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -1137,6 +1141,7 @@ static struct clk l3_ick = {
 	.clksel		= div2_core_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
 				PARENT_CONTROLS_CLOCK,
+	.clkdm_name	= "core_l3_clkdm",
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -1154,6 +1159,7 @@ static struct clk l4_ick = {
 	.clksel		= div2_l3_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
 				PARENT_CONTROLS_CLOCK,
+	.clkdm_name	= "core_l4_clkdm",
 	.recalc		= &omap2_clksel_recalc,
 
 };
@@ -1193,33 +1199,40 @@ static struct clk gfx_l3_fck = {
 	.clksel_mask	= OMAP_CLKSEL_GFX_MASK,
 	.clksel		= gfx_l3_clksel,
 	.flags		= CLOCK_IN_OMAP3430ES1 | RATE_PROPAGATES,
+	.clkdm_name	= "gfx_3430es1_clkdm",
 	.recalc		= &omap2_clksel_recalc,
 };
 
 static struct clk gfx_l3_ick = {
 	.name		= "gfx_l3_ick",
 	.parent		= &l3_ick,
+	.init		= &omap2_init_clk_clkdm,
 	.enable_reg	= OMAP_CM_REGADDR(GFX_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP_EN_GFX_SHIFT,
 	.flags		= CLOCK_IN_OMAP3430ES1,
+	.clkdm_name	= "gfx_3430es1_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
 static struct clk gfx_cg1_ck = {
 	.name		= "gfx_cg1_ck",
 	.parent		= &gfx_l3_fck, /* REVISIT: correct? */
+	.init		= &omap2_init_clk_clkdm,
 	.enable_reg	= OMAP_CM_REGADDR(GFX_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430ES1_EN_2D_SHIFT,
 	.flags		= CLOCK_IN_OMAP3430ES1,
+	.clkdm_name	= "gfx_3430es1_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
 static struct clk gfx_cg2_ck = {
 	.name		= "gfx_cg2_ck",
 	.parent		= &gfx_l3_fck, /* REVISIT: correct? */
+	.init		= &omap2_init_clk_clkdm,
 	.enable_reg	= OMAP_CM_REGADDR(GFX_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430ES1_EN_3D_SHIFT,
 	.flags		= CLOCK_IN_OMAP3430ES1,
+	.clkdm_name	= "gfx_3430es1_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -1252,15 +1265,18 @@ static struct clk sgx_fck = {
 	.clksel_mask	= OMAP3430ES2_CLKSEL_SGX_MASK,
 	.clksel		= sgx_clksel,
 	.flags		= CLOCK_IN_OMAP3430ES2,
+	.clkdm_name	= "sgx_clkdm",
 	.recalc		= &omap2_clksel_recalc,
 };
 
 static struct clk sgx_ick = {
 	.name		= "sgx_ick",
 	.parent		= &l3_ick,
+	.init		= &omap2_init_clk_clkdm,
 	.enable_reg	= OMAP_CM_REGADDR(OMAP3430ES2_SGX_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430ES2_EN_SGX_SHIFT,
 	.flags		= CLOCK_IN_OMAP3430ES2,
+	.clkdm_name	= "sgx_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -1269,9 +1285,11 @@ static struct clk sgx_ick = {
 static struct clk d2d_26m_fck = {
 	.name		= "d2d_26m_fck",
 	.parent		= &sys_ck,
+	.init		= &omap2_init_clk_clkdm,
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP3430ES1_EN_D2D_SHIFT,
 	.flags		= CLOCK_IN_OMAP3430ES1,
+	.clkdm_name	= "d2d_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -1291,6 +1309,7 @@ static struct clk gpt10_fck = {
 	.clksel_mask	= OMAP3430_CLKSEL_GPT10_MASK,
 	.clksel		= omap343x_gpt_clksel,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "core_l4_clkdm",
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -1304,6 +1323,7 @@ static struct clk gpt11_fck = {
 	.clksel_mask	= OMAP3430_CLKSEL_GPT11_MASK,
 	.clksel		= omap343x_gpt_clksel,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "core_l4_clkdm",
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -1341,6 +1361,7 @@ static struct clk core_96m_fck = {
 	.parent		= &omap_96m_fck,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
 				PARENT_CONTROLS_CLOCK,
+	.clkdm_name	= "core_l4_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -1351,6 +1372,7 @@ static struct clk mmchs3_fck = {
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP3430ES2_EN_MMC3_SHIFT,
 	.flags		= CLOCK_IN_OMAP3430ES2,
+	.clkdm_name	= "core_l4_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -1361,6 +1383,7 @@ static struct clk mmchs2_fck = {
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP3430_EN_MMC2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "core_l4_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -1370,6 +1393,7 @@ static struct clk mspro_fck = {
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP3430_EN_MSPRO_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "core_l4_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -1380,6 +1404,7 @@ static struct clk mmchs1_fck = {
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP3430_EN_MMC1_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "core_l4_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -1390,16 +1415,18 @@ static struct clk i2c3_fck = {
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP3430_EN_I2C3_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "core_l4_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
 static struct clk i2c2_fck = {
 	.name		= "i2c_fck",
-	.id 		= 2,
+	.id		= 2,
 	.parent		= &core_96m_fck,
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP3430_EN_I2C2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "core_l4_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -1410,6 +1437,7 @@ static struct clk i2c1_fck = {
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP3430_EN_I2C1_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "core_l4_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -1443,6 +1471,7 @@ static struct clk mcbsp5_fck = {
 	.clksel_mask	= OMAP2_MCBSP5_CLKS_MASK,
 	.clksel		= mcbsp_15_clksel,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "core_l4_clkdm",
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -1456,6 +1485,7 @@ static struct clk mcbsp1_fck = {
 	.clksel_mask	= OMAP2_MCBSP1_CLKS_MASK,
 	.clksel		= mcbsp_15_clksel,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "core_l4_clkdm",
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -1466,6 +1496,7 @@ static struct clk core_48m_fck = {
 	.parent		= &omap_48m_fck,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
 				PARENT_CONTROLS_CLOCK,
+	.clkdm_name	= "core_l4_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -1543,6 +1574,7 @@ static struct clk core_12m_fck = {
 	.parent		= &omap_12m_fck,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
 				PARENT_CONTROLS_CLOCK,
+	.clkdm_name	= "core_l4_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -1581,6 +1613,7 @@ static struct clk ssi_ssr_fck = {
 	.clksel_mask	= OMAP3430_CLKSEL_SSI_MASK,
 	.clksel		= ssi_ssr_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES,
+	.clkdm_name	= "core_l4_clkdm",
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -1596,11 +1629,17 @@ static struct clk ssi_sst_fck = {
 
 /* CORE_L3_ICK based clocks */
 
+/*
+ * XXX must add clk_enable/clk_disable for these if standard code won't
+ * handle it
+ */
 static struct clk core_l3_ick = {
 	.name		= "core_l3_ick",
 	.parent		= &l3_ick,
+	.init		= &omap2_init_clk_clkdm,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
 				PARENT_CONTROLS_CLOCK,
+	.clkdm_name	= "core_l3_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -1610,6 +1649,7 @@ static struct clk hsotgusb_ick = {
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_HSOTGUSB_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "core_l3_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -1619,6 +1659,7 @@ static struct clk sdrc_ick = {
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_SDRC_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X | ENABLE_ON_INIT,
+	.clkdm_name	= "core_l3_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -1627,6 +1668,7 @@ static struct clk gpmc_fck = {
 	.parent		= &core_l3_ick,
 	.flags		= CLOCK_IN_OMAP343X | PARENT_CONTROLS_CLOCK |
 				ENABLE_ON_INIT,
+	.clkdm_name	= "core_l3_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -1654,8 +1696,10 @@ static struct clk pka_ick = {
 static struct clk core_l4_ick = {
 	.name		= "core_l4_ick",
 	.parent		= &l4_ick,
+	.init		= &omap2_init_clk_clkdm,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
 				PARENT_CONTROLS_CLOCK,
+	.clkdm_name	= "core_l4_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -1665,6 +1709,7 @@ static struct clk usbtll_ick = {
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN3),
 	.enable_bit	= OMAP3430ES2_EN_USBTLL_SHIFT,
 	.flags		= CLOCK_IN_OMAP3430ES2,
+	.clkdm_name	= "core_l4_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -1675,6 +1720,7 @@ static struct clk mmchs3_ick = {
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430ES2_EN_MMC3_SHIFT,
 	.flags		= CLOCK_IN_OMAP3430ES2,
+	.clkdm_name	= "core_l4_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -1685,6 +1731,7 @@ static struct clk icr_ick = {
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_ICR_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "core_l4_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -1694,6 +1741,7 @@ static struct clk aes2_ick = {
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_AES2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "core_l4_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -1703,6 +1751,7 @@ static struct clk sha12_ick = {
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_SHA12_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "core_l4_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -1712,6 +1761,7 @@ static struct clk des2_ick = {
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_DES2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "core_l4_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -1722,6 +1772,7 @@ static struct clk mmchs2_ick = {
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_MMC2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "core_l4_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -1732,6 +1783,7 @@ static struct clk mmchs1_ick = {
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_MMC1_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "core_l4_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -1741,6 +1793,7 @@ static struct clk mspro_ick = {
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_MSPRO_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "core_l4_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -1750,6 +1803,7 @@ static struct clk hdq_ick = {
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_HDQ_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "core_l4_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -1760,6 +1814,7 @@ static struct clk mcspi4_ick = {
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_MCSPI4_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "core_l4_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -1770,6 +1825,7 @@ static struct clk mcspi3_ick = {
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_MCSPI3_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "core_l4_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -1780,6 +1836,7 @@ static struct clk mcspi2_ick = {
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_MCSPI2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "core_l4_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -1790,6 +1847,7 @@ static struct clk mcspi1_ick = {
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_MCSPI1_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "core_l4_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -1800,6 +1858,7 @@ static struct clk i2c3_ick = {
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_I2C3_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "core_l4_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -1810,6 +1869,7 @@ static struct clk i2c2_ick = {
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_I2C2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "core_l4_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -1820,6 +1880,7 @@ static struct clk i2c1_ick = {
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_I2C1_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "core_l4_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -1829,6 +1890,7 @@ static struct clk uart2_ick = {
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_UART2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "core_l4_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -1838,6 +1900,7 @@ static struct clk uart1_ick = {
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_UART1_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "core_l4_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -1847,6 +1910,7 @@ static struct clk gpt11_ick = {
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_GPT11_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "core_l4_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -1856,6 +1920,7 @@ static struct clk gpt10_ick = {
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_GPT10_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "core_l4_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -1866,6 +1931,7 @@ static struct clk mcbsp5_ick = {
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_MCBSP5_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "core_l4_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -1876,6 +1942,7 @@ static struct clk mcbsp1_ick = {
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_MCBSP1_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "core_l4_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -1885,6 +1952,7 @@ static struct clk fac_ick = {
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430ES1_EN_FAC_SHIFT,
 	.flags		= CLOCK_IN_OMAP3430ES1,
+	.clkdm_name	= "core_l4_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -1894,6 +1962,7 @@ static struct clk mailboxes_ick = {
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_MAILBOXES_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "core_l4_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -1913,6 +1982,7 @@ static struct clk ssi_l4_ick = {
 	.parent		= &l4_ick,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
 				PARENT_CONTROLS_CLOCK,
+	.clkdm_name	= "core_l4_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -1922,6 +1992,7 @@ static struct clk ssi_ick = {
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_SSI_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "core_l4_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -1996,7 +2067,7 @@ static struct clk des1_ick = {
 
 /* DSS */
 static const struct clksel dss1_alwon_fck_clksel[] = {
-	{ .parent = &sys_ck,        .rates = dpll_bypass_rates },
+	{ .parent = &sys_ck,	    .rates = dpll_bypass_rates },
 	{ .parent = &dpll4_m4x2_ck, .rates = dpll_locked_rates },
 	{ .parent = NULL }
 };
@@ -2011,33 +2082,40 @@ static struct clk dss1_alwon_fck = {
 	.clksel_mask	= OMAP3430_ST_PERIPH_CLK_MASK,
 	.clksel		= dss1_alwon_fck_clksel,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "dss_clkdm",
 	.recalc		= &omap2_clksel_recalc,
 };
 
 static struct clk dss_tv_fck = {
 	.name		= "dss_tv_fck",
 	.parent		= &omap_54m_fck,
+	.init		= &omap2_init_clk_clkdm,
 	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_DSS_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_EN_TV_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "dss_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
 static struct clk dss_96m_fck = {
 	.name		= "dss_96m_fck",
 	.parent		= &omap_96m_fck,
+	.init		= &omap2_init_clk_clkdm,
 	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_DSS_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_EN_TV_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "dss_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
 static struct clk dss2_alwon_fck = {
 	.name		= "dss2_alwon_fck",
 	.parent		= &sys_ck,
+	.init		= &omap2_init_clk_clkdm,
 	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_DSS_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_EN_DSS2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "dss_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -2045,16 +2123,18 @@ static struct clk dss_ick = {
 	/* Handles both L3 and L4 clocks */
 	.name		= "dss_ick",
 	.parent		= &l4_ick,
+	.init		= &omap2_init_clk_clkdm,
 	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_DSS_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_CM_ICLKEN_DSS_EN_DSS_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "dss_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
 /* CAM */
 
 static const struct clksel cam_mclk_clksel[] = {
-	{ .parent = &sys_ck,        .rates = dpll_bypass_rates },
+	{ .parent = &sys_ck,	    .rates = dpll_bypass_rates },
 	{ .parent = &dpll4_m5x2_ck, .rates = dpll_locked_rates },
 	{ .parent = NULL }
 };
@@ -2069,24 +2149,29 @@ static struct clk cam_mclk = {
 	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_CAM_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_EN_CAM_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "cam_clkdm",
 	.recalc		= &omap2_clksel_recalc,
 };
 
 static struct clk cam_l3_ick = {
 	.name		= "cam_l3_ick",
 	.parent		= &l3_ick,
+	.init		= &omap2_init_clk_clkdm,
 	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_CAM_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_CAM_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "cam_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
 static struct clk cam_l4_ick = {
 	.name		= "cam_l4_ick",
 	.parent		= &l4_ick,
+	.init		= &omap2_init_clk_clkdm,
 	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_CAM_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_CAM_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "cam_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -2095,45 +2180,55 @@ static struct clk cam_l4_ick = {
 static struct clk usbhost_120m_fck = {
 	.name		= "usbhost_120m_fck",
 	.parent		= &omap_120m_fck,
+	.init		= &omap2_init_clk_clkdm,
 	.enable_reg	= OMAP_CM_REGADDR(OMAP3430ES2_USBHOST_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430ES2_EN_USBHOST2_SHIFT,
 	.flags		= CLOCK_IN_OMAP3430ES2,
+	.clkdm_name	= "usbhost_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
 static struct clk usbhost_48m_fck = {
 	.name		= "usbhost_48m_fck",
 	.parent		= &omap_48m_fck,
+	.init		= &omap2_init_clk_clkdm,
 	.enable_reg	= OMAP_CM_REGADDR(OMAP3430ES2_USBHOST_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430ES2_EN_USBHOST1_SHIFT,
 	.flags		= CLOCK_IN_OMAP3430ES2,
+	.clkdm_name	= "usbhost_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
 static struct clk usbhost_l3_ick = {
 	.name		= "usbhost_l3_ick",
 	.parent		= &l3_ick,
+	.init		= &omap2_init_clk_clkdm,
 	.enable_reg	= OMAP_CM_REGADDR(OMAP3430ES2_USBHOST_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430ES2_EN_USBHOST_SHIFT,
 	.flags		= CLOCK_IN_OMAP3430ES2,
+	.clkdm_name	= "usbhost_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
 static struct clk usbhost_l4_ick = {
 	.name		= "usbhost_l4_ick",
 	.parent		= &l4_ick,
+	.init		= &omap2_init_clk_clkdm,
 	.enable_reg	= OMAP_CM_REGADDR(OMAP3430ES2_USBHOST_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430ES2_EN_USBHOST_SHIFT,
 	.flags		= CLOCK_IN_OMAP3430ES2,
+	.clkdm_name	= "usbhost_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
 static struct clk usbhost_sar_fck = {
 	.name		= "usbhost_sar_fck",
 	.parent		= &osc_sys_ck,
+	.init		= &omap2_init_clk_clkdm,
 	.enable_reg	= OMAP_PRM_REGADDR(OMAP3430ES2_USBHOST_MOD, PM_PWSTCTRL),
 	.enable_bit	= OMAP3430ES2_SAVEANDRESTORE_SHIFT,
 	.flags		= CLOCK_IN_OMAP3430ES2,
+	.clkdm_name	= "usbhost_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -2175,6 +2270,7 @@ static struct clk usim_fck = {
 	.recalc		= &omap2_clksel_recalc,
 };
 
+/* XXX should gpt1's clksel have wkup_32k_fck as the 32k opt? */
 static struct clk gpt1_fck = {
 	.name		= "gpt1_fck",
 	.init		= &omap2_init_clksel_parent,
@@ -2184,13 +2280,16 @@ static struct clk gpt1_fck = {
 	.clksel_mask	= OMAP3430_CLKSEL_GPT1_MASK,
 	.clksel		= omap343x_gpt_clksel,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "wkup_clkdm",
 	.recalc		= &omap2_clksel_recalc,
 };
 
 static struct clk wkup_32k_fck = {
 	.name		= "wkup_32k_fck",
+	.init		= &omap2_init_clk_clkdm,
 	.parent		= &omap_32k_fck,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | ALWAYS_ENABLED,
+	.clkdm_name	= "wkup_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -2200,6 +2299,7 @@ static struct clk gpio1_fck = {
 	.enable_reg	= OMAP_CM_REGADDR(WKUP_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_EN_GPIO1_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "wkup_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -2209,6 +2309,7 @@ static struct clk wdt2_fck = {
 	.enable_reg	= OMAP_CM_REGADDR(WKUP_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_EN_WDT2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "wkup_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -2216,6 +2317,7 @@ static struct clk wkup_l4_ick = {
 	.name		= "wkup_l4_ick",
 	.parent		= &sys_ck,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | ALWAYS_ENABLED,
+	.clkdm_name	= "wkup_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -2227,6 +2329,7 @@ static struct clk usim_ick = {
 	.enable_reg	= OMAP_CM_REGADDR(WKUP_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430ES2_EN_USIMOCP_SHIFT,
 	.flags		= CLOCK_IN_OMAP3430ES2,
+	.clkdm_name	= "wkup_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -2236,6 +2339,7 @@ static struct clk wdt2_ick = {
 	.enable_reg	= OMAP_CM_REGADDR(WKUP_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_WDT2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "wkup_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -2245,6 +2349,7 @@ static struct clk wdt1_ick = {
 	.enable_reg	= OMAP_CM_REGADDR(WKUP_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_WDT1_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "wkup_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -2254,6 +2359,7 @@ static struct clk gpio1_ick = {
 	.enable_reg	= OMAP_CM_REGADDR(WKUP_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_GPIO1_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "wkup_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -2263,15 +2369,18 @@ static struct clk omap_32ksync_ick = {
 	.enable_reg	= OMAP_CM_REGADDR(WKUP_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_32KSYNC_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "wkup_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
+/* XXX This clock no longer exists in 3430 TRM rev F */
 static struct clk gpt12_ick = {
 	.name		= "gpt12_ick",
 	.parent		= &wkup_l4_ick,
 	.enable_reg	= OMAP_CM_REGADDR(WKUP_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_GPT12_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "wkup_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -2281,6 +2390,7 @@ static struct clk gpt1_ick = {
 	.enable_reg	= OMAP_CM_REGADDR(WKUP_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_GPT1_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "wkup_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -2291,16 +2401,20 @@ static struct clk gpt1_ick = {
 static struct clk per_96m_fck = {
 	.name		= "per_96m_fck",
 	.parent		= &omap_96m_alwon_fck,
+	.init		= &omap2_init_clk_clkdm,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
 				PARENT_CONTROLS_CLOCK,
+	.clkdm_name	= "per_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
 static struct clk per_48m_fck = {
 	.name		= "per_48m_fck",
 	.parent		= &omap_48m_fck,
+	.init		= &omap2_init_clk_clkdm,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
 				PARENT_CONTROLS_CLOCK,
+	.clkdm_name	= "per_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -2310,6 +2424,7 @@ static struct clk uart3_fck = {
 	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_EN_UART3_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "per_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -2322,6 +2437,7 @@ static struct clk gpt2_fck = {
 	.clksel_mask	= OMAP3430_CLKSEL_GPT2_MASK,
 	.clksel		= omap343x_gpt_clksel,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "per_clkdm",
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -2334,6 +2450,7 @@ static struct clk gpt3_fck = {
 	.clksel_mask	= OMAP3430_CLKSEL_GPT3_MASK,
 	.clksel		= omap343x_gpt_clksel,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "per_clkdm",
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -2346,6 +2463,7 @@ static struct clk gpt4_fck = {
 	.clksel_mask	= OMAP3430_CLKSEL_GPT4_MASK,
 	.clksel		= omap343x_gpt_clksel,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "per_clkdm",
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -2358,6 +2476,7 @@ static struct clk gpt5_fck = {
 	.clksel_mask	= OMAP3430_CLKSEL_GPT5_MASK,
 	.clksel		= omap343x_gpt_clksel,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "per_clkdm",
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -2370,6 +2489,7 @@ static struct clk gpt6_fck = {
 	.clksel_mask	= OMAP3430_CLKSEL_GPT6_MASK,
 	.clksel		= omap343x_gpt_clksel,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "per_clkdm",
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -2382,6 +2502,7 @@ static struct clk gpt7_fck = {
 	.clksel_mask	= OMAP3430_CLKSEL_GPT7_MASK,
 	.clksel		= omap343x_gpt_clksel,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "per_clkdm",
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -2394,6 +2515,7 @@ static struct clk gpt8_fck = {
 	.clksel_mask	= OMAP3430_CLKSEL_GPT8_MASK,
 	.clksel		= omap343x_gpt_clksel,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "per_clkdm",
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -2406,12 +2528,14 @@ static struct clk gpt9_fck = {
 	.clksel_mask	= OMAP3430_CLKSEL_GPT9_MASK,
 	.clksel		= omap343x_gpt_clksel,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "per_clkdm",
 	.recalc		= &omap2_clksel_recalc,
 };
 
 static struct clk per_32k_alwon_fck = {
 	.name		= "per_32k_alwon_fck",
 	.parent		= &omap_32k_fck,
+	.clkdm_name	= "per_clkdm",
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | ALWAYS_ENABLED,
 	.recalc		= &followparent_recalc,
 };
@@ -2422,6 +2546,7 @@ static struct clk gpio6_fck = {
 	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_EN_GPIO6_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "per_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -2431,6 +2556,7 @@ static struct clk gpio5_fck = {
 	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_EN_GPIO5_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "per_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -2440,6 +2566,7 @@ static struct clk gpio4_fck = {
 	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_EN_GPIO4_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "per_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -2449,6 +2576,7 @@ static struct clk gpio3_fck = {
 	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_EN_GPIO3_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "per_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -2458,6 +2586,7 @@ static struct clk gpio2_fck = {
 	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_EN_GPIO2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "per_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -2467,6 +2596,7 @@ static struct clk wdt3_fck = {
 	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_EN_WDT3_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "per_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -2475,6 +2605,7 @@ static struct clk per_l4_ick = {
 	.parent		= &l4_ick,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
 				PARENT_CONTROLS_CLOCK,
+	.clkdm_name	= "per_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -2484,6 +2615,7 @@ static struct clk gpio6_ick = {
 	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_GPIO6_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "per_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -2493,6 +2625,7 @@ static struct clk gpio5_ick = {
 	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_GPIO5_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "per_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -2502,6 +2635,7 @@ static struct clk gpio4_ick = {
 	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_GPIO4_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "per_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -2511,6 +2645,7 @@ static struct clk gpio3_ick = {
 	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_GPIO3_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "per_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -2520,6 +2655,7 @@ static struct clk gpio2_ick = {
 	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_GPIO2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "per_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -2529,6 +2665,7 @@ static struct clk wdt3_ick = {
 	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_WDT3_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "per_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -2538,6 +2675,7 @@ static struct clk uart3_ick = {
 	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_UART3_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "per_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -2547,6 +2685,7 @@ static struct clk gpt9_ick = {
 	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_GPT9_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "per_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -2556,6 +2695,7 @@ static struct clk gpt8_ick = {
 	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_GPT8_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "per_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -2565,6 +2705,7 @@ static struct clk gpt7_ick = {
 	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_GPT7_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "per_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -2574,6 +2715,7 @@ static struct clk gpt6_ick = {
 	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_GPT6_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "per_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -2583,6 +2725,7 @@ static struct clk gpt5_ick = {
 	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_GPT5_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "per_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -2592,6 +2735,7 @@ static struct clk gpt4_ick = {
 	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_GPT4_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "per_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -2601,6 +2745,7 @@ static struct clk gpt3_ick = {
 	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_GPT3_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "per_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -2610,6 +2755,7 @@ static struct clk gpt2_ick = {
 	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_GPT2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "per_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -2620,6 +2766,7 @@ static struct clk mcbsp2_ick = {
 	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_MCBSP2_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "per_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -2630,6 +2777,7 @@ static struct clk mcbsp3_ick = {
 	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_MCBSP3_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "per_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -2640,12 +2788,13 @@ static struct clk mcbsp4_ick = {
 	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP3430_EN_MCBSP4_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "per_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
 static const struct clksel mcbsp_234_clksel[] = {
 	{ .parent = &per_96m_fck, .rates = common_mcbsp_96m_rates },
-	{ .parent = &mcbsp_clks,   .rates = common_mcbsp_mcbsp_rates },
+	{ .parent = &mcbsp_clks,  .rates = common_mcbsp_mcbsp_rates },
 	{ .parent = NULL }
 };
 
@@ -2659,6 +2808,7 @@ static struct clk mcbsp2_fck = {
 	.clksel_mask	= OMAP2_MCBSP2_CLKS_MASK,
 	.clksel		= mcbsp_234_clksel,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "per_clkdm",
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -2672,6 +2822,7 @@ static struct clk mcbsp3_fck = {
 	.clksel_mask	= OMAP2_MCBSP3_CLKS_MASK,
 	.clksel		= mcbsp_234_clksel,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "per_clkdm",
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -2685,6 +2836,7 @@ static struct clk mcbsp4_fck = {
 	.clksel_mask	= OMAP2_MCBSP4_CLKS_MASK,
 	.clksel		= mcbsp_234_clksel,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "per_clkdm",
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -2732,6 +2884,7 @@ static struct clk emu_src_ck = {
 	.clksel_mask	= OMAP3430_MUX_CTRL_MASK,
 	.clksel		= emu_src_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | ALWAYS_ENABLED,
+	.clkdm_name	= "emu_clkdm",
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -2755,6 +2908,7 @@ static struct clk pclk_fck = {
 	.clksel_mask	= OMAP3430_CLKSEL_PCLK_MASK,
 	.clksel		= pclk_emu_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | ALWAYS_ENABLED,
+	.clkdm_name	= "emu_clkdm",
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -2777,6 +2931,7 @@ static struct clk pclkx2_fck = {
 	.clksel_mask	= OMAP3430_CLKSEL_PCLKX2_MASK,
 	.clksel		= pclkx2_emu_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | ALWAYS_ENABLED,
+	.clkdm_name	= "emu_clkdm",
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -2792,6 +2947,7 @@ static struct clk atclk_fck = {
 	.clksel_mask	= OMAP3430_CLKSEL_ATCLK_MASK,
 	.clksel		= atclk_emu_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | ALWAYS_ENABLED,
+	.clkdm_name	= "emu_clkdm",
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -2802,6 +2958,7 @@ static struct clk traceclk_src_fck = {
 	.clksel_mask	= OMAP3430_TRACE_MUX_CTRL_MASK,
 	.clksel		= emu_src_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | ALWAYS_ENABLED,
+	.clkdm_name	= "emu_clkdm",
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -2824,6 +2981,7 @@ static struct clk traceclk_fck = {
 	.clksel_mask	= OMAP3430_CLKSEL_TRACECLK_MASK,
 	.clksel		= traceclk_clksel,
 	.flags		= CLOCK_IN_OMAP343X | ALWAYS_ENABLED,
+	.clkdm_name	= "emu_clkdm",
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -2853,11 +3011,13 @@ static struct clk sr_l4_ick = {
 	.name		= "sr_l4_ick",
 	.parent		= &l4_ick,
 	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "core_l4_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
 /* SECURE_32K_FCK clocks */
 
+/* XXX This clock no longer exists in 3430 TRM rev F */
 static struct clk gpt12_fck = {
 	.name		= "gpt12_fck",
 	.parent		= &secure_32k_fck,
diff --git a/arch/arm/mach-omap2/clockdomains.h b/arch/arm/mach-omap2/clockdomains.h
index adbc170..b5d3244 100644
--- a/arch/arm/mach-omap2/clockdomains.h
+++ b/arch/arm/mach-omap2/clockdomains.h
@@ -168,12 +168,19 @@ static struct clockdomain sgx_clkdm = {
 	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP3430ES2),
 };
 
+/*
+ * The die-to-die clockdomain was documented in the 34xx ES1 TRM, but
+ * then that information was removed from the 34xx ES2+ TRM.  It is
+ * unclear whether the core is still there, but the clockdomain logic
+ * is there, and must be programmed to an appropriate state if the
+ * CORE clockdomain is to become inactive.
+ */
 static struct clockdomain d2d_clkdm = {
 	.name		= "d2d_clkdm",
 	.pwrdm_name	= "core_pwrdm",
 	.flags		= CLKDM_CAN_HWSUP,
 	.clktrctrl_mask = OMAP3430ES1_CLKTRCTRL_D2D_MASK,
-	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP3430ES1),
+	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP3430),
 };
 
 static struct clockdomain core_l3_34xx_clkdm = {
diff --git a/include/asm-arm/arch-omap/clock.h b/include/asm-arm/arch-omap/clock.h
index 4c7b351..f40253d 100644
--- a/include/asm-arm/arch-omap/clock.h
+++ b/include/asm-arm/arch-omap/clock.h
@@ -13,6 +13,8 @@
 #ifndef __ARCH_ARM_OMAP_CLOCK_H
 #define __ARCH_ARM_OMAP_CLOCK_H
 
+#include <asm/arch/clockdomain.h>
+
 struct module;
 struct clk;
 
@@ -79,6 +81,8 @@ struct clk {
 	u32			clksel_mask;
 	const struct clksel	*clksel;
 	struct dpll_data	*dpll_data;
+	const char              *clkdm_name;
+	struct clockdomain      *clkdm;
 #else
 	__u8			rate_offset;
 	__u8			src_offset;
