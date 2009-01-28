Return-Path: <linux-kernel-owner+w=401wt.eu-S1754092AbZA1U3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092AbZA1U3g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 15:29:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753181AbZA1U1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:27:37 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:60927 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbZA1U12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:27:28 -0500
MBOX-Line: From nobody Wed Jan 28 12:18:28 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH D 05/11] OMAP2 clock: add clk.prcm_mod field;
	annotate OMAP2xxx clocks
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, Paul Walmsley <paul@pwsan.com>,
       Tony Lindgren <tony@atomide.com>
Date: Wed, 28 Jan 2009 12:18:28 -0700
Message-ID: <20090128191825.16688.31133.stgit@localhost.localdomain>
In-Reply-To: <20090128191638.16688.33452.stgit@localhost.localdomain>
References: <20090128191638.16688.33452.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a "prcm_mod" field to the struct clk in OMAP2/3, and annotate each
OMAP2xxx real hardware clock controlled by the PRCM with the PRCM
module offset.  (A subsequent patch will annotate OMAP3 clocks.)

Add flags for this field that allow the registers to
be marked as existing in the PRM, CM, or System Control Module.

A subsequent patch will use this to simplify register addressing in the
struct clk.

linux-omap source commit is 754cdc4a81159bbe1387a4dd701b6b50acc51ba3.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/clock24xx.h         |  128 +++++++++++++++++++++++++++++++
 arch/arm/plat-omap/include/mach/clock.h |    8 ++
 2 files changed, 136 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/clock24xx.h b/arch/arm/mach-omap2/clock24xx.h
index 8de312a..7150a3f 100644
--- a/arch/arm/mach-omap2/clock24xx.h
+++ b/arch/arm/mach-omap2/clock24xx.h
@@ -695,6 +695,7 @@ static struct dpll_data dpll_dd = {
 static struct clk dpll_ck = {
 	.name		= "dpll_ck",
 	.parent		= &sys_ck,		/* Can be func_32k also */
+	.prcm_mod	= PLL_MOD,
 	.dpll_data	= &dpll_dd,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				RATE_PROPAGATES | ALWAYS_ENABLED,
@@ -706,6 +707,7 @@ static struct clk dpll_ck = {
 static struct clk apll96_ck = {
 	.name		= "apll96_ck",
 	.parent		= &sys_ck,
+	.prcm_mod	= PLL_MOD,
 	.rate		= 96000000,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				RATE_FIXED | RATE_PROPAGATES | ENABLE_ON_INIT,
@@ -720,6 +722,7 @@ static struct clk apll96_ck = {
 static struct clk apll54_ck = {
 	.name		= "apll54_ck",
 	.parent		= &sys_ck,
+	.prcm_mod	= PLL_MOD,
 	.rate		= 54000000,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				RATE_FIXED | RATE_PROPAGATES | ENABLE_ON_INIT,
@@ -756,6 +759,7 @@ static const struct clksel func_54m_clksel[] = {
 static struct clk func_54m_ck = {
 	.name		= "func_54m_ck",
 	.parent		= &apll54_ck,	/* can also be alt_clk */
+	.prcm_mod	= PLL_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				RATE_PROPAGATES | PARENT_CONTROLS_CLOCK,
 	.clkdm		= { .name = "cm_clkdm" },
@@ -796,6 +800,7 @@ static const struct clksel func_96m_clksel[] = {
 static struct clk func_96m_ck = {
 	.name		= "func_96m_ck",
 	.parent		= &apll96_ck,
+	.prcm_mod	= PLL_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				RATE_PROPAGATES | PARENT_CONTROLS_CLOCK,
 	.clkdm		= { .name = "cm_clkdm" },
@@ -829,6 +834,7 @@ static const struct clksel func_48m_clksel[] = {
 static struct clk func_48m_ck = {
 	.name		= "func_48m_ck",
 	.parent		= &apll96_ck,	 /* 96M or Alt */
+	.prcm_mod	= PLL_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				RATE_PROPAGATES | PARENT_CONTROLS_CLOCK,
 	.clkdm		= { .name = "cm_clkdm" },
@@ -899,6 +905,7 @@ static const struct clksel common_clkout_src_clksel[] = {
 static struct clk sys_clkout_src = {
 	.name		= "sys_clkout_src",
 	.parent		= &func_54m_ck,
+	.prcm_mod	= OMAP24XX_GR_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				RATE_PROPAGATES | OFFSET_GR_MOD,
 	.clkdm		= { .name = "prm_clkdm" },
@@ -930,6 +937,7 @@ static const struct clksel sys_clkout_clksel[] = {
 static struct clk sys_clkout = {
 	.name		= "sys_clkout",
 	.parent		= &sys_clkout_src,
+	.prcm_mod	= OMAP24XX_GR_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				PARENT_CONTROLS_CLOCK | OFFSET_GR_MOD,
 	.clkdm		= { .name = "prm_clkdm" },
@@ -945,6 +953,7 @@ static struct clk sys_clkout = {
 static struct clk sys_clkout2_src = {
 	.name		= "sys_clkout2_src",
 	.parent		= &func_54m_ck,
+	.prcm_mod	= OMAP24XX_GR_MOD,
 	.flags		= CLOCK_IN_OMAP242X | RATE_PROPAGATES | OFFSET_GR_MOD,
 	.clkdm		= { .name = "cm_clkdm" },
 	.enable_reg	= _GR_MOD_OFFSET(OMAP24XX_PRCM_CLKOUT_CTRL_OFFSET),
@@ -967,6 +976,7 @@ static const struct clksel sys_clkout2_clksel[] = {
 static struct clk sys_clkout2 = {
 	.name		= "sys_clkout2",
 	.parent		= &sys_clkout2_src,
+	.prcm_mod	= OMAP24XX_GR_MOD,
 	.flags		= CLOCK_IN_OMAP242X | PARENT_CONTROLS_CLOCK |
 				OFFSET_GR_MOD,
 	.clkdm		= { .name = "cm_clkdm" },
@@ -981,6 +991,7 @@ static struct clk sys_clkout2 = {
 static struct clk emul_ck = {
 	.name		= "emul_ck",
 	.parent		= &func_54m_ck,
+	.prcm_mod	= OMAP24XX_GR_MOD,
 	.flags		= CLOCK_IN_OMAP242X | OFFSET_GR_MOD,
 	.clkdm		= { .name = "cm_clkdm" },
 	.enable_reg	= _GR_MOD_OFFSET(OMAP24XX_PRCM_CLKEMUL_CTRL_OFFSET),
@@ -1016,6 +1027,7 @@ static const struct clksel mpu_clksel[] = {
 static struct clk mpu_ck = {	/* Control cpu */
 	.name		= "mpu_ck",
 	.parent		= &core_ck,
+	.prcm_mod	= MPU_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				ALWAYS_ENABLED | DELAYED_APP |
 				CONFIG_PARTICIPANT | RATE_PROPAGATES,
@@ -1059,6 +1071,7 @@ static const struct clksel dsp_fck_clksel[] = {
 static struct clk dsp_fck = {
 	.name		= "dsp_fck",
 	.parent		= &core_ck,
+	.prcm_mod	= OMAP24XX_DSP_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X | DELAYED_APP |
 				CONFIG_PARTICIPANT | RATE_PROPAGATES,
 	.clkdm		= { .name = "dsp_clkdm" },
@@ -1089,6 +1102,7 @@ static const struct clksel dsp_irate_ick_clksel[] = {
 static struct clk dsp_irate_ick = {
 	.name		= "dsp_irate_ick",
 	.parent		= &dsp_fck,
+	.prcm_mod	= OMAP24XX_DSP_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X | DELAYED_APP |
 				CONFIG_PARTICIPANT | PARENT_CONTROLS_CLOCK,
 	.clkdm		= { .name = "dsp_clkdm" },
@@ -1104,6 +1118,7 @@ static struct clk dsp_irate_ick = {
 static struct clk dsp_ick = {
 	.name		= "dsp_ick",	 /* apparently ipi and isp */
 	.parent		= &dsp_irate_ick,
+	.prcm_mod	= OMAP24XX_DSP_MOD,
 	.flags		= CLOCK_IN_OMAP242X | DELAYED_APP | CONFIG_PARTICIPANT,
 	.clkdm		= { .name = "dsp_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(OMAP24XX_DSP_MOD, CM_ICLKEN),
@@ -1114,6 +1129,7 @@ static struct clk dsp_ick = {
 static struct clk iva2_1_ick = {
 	.name		= "iva2_1_ick",
 	.parent		= &dsp_irate_ick,
+	.prcm_mod	= OMAP24XX_DSP_MOD,
 	.flags		= CLOCK_IN_OMAP243X | DELAYED_APP | CONFIG_PARTICIPANT,
 	.clkdm		= { .name = "dsp_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(OMAP24XX_DSP_MOD, CM_FCLKEN),
@@ -1128,6 +1144,7 @@ static struct clk iva2_1_ick = {
 static struct clk iva1_ifck = {
 	.name		= "iva1_ifck",
 	.parent		= &core_ck,
+	.prcm_mod	= OMAP24XX_DSP_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CONFIG_PARTICIPANT |
 				RATE_PROPAGATES | DELAYED_APP,
 	.clkdm		= { .name = "iva1_clkdm" },
@@ -1145,6 +1162,7 @@ static struct clk iva1_ifck = {
 static struct clk iva1_mpu_int_ifck = {
 	.name		= "iva1_mpu_int_ifck",
 	.parent		= &iva1_ifck,
+	.prcm_mod	= OMAP24XX_DSP_MOD,
 	.flags		= CLOCK_IN_OMAP242X,
 	.clkdm		= { .name = "iva1_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(OMAP24XX_DSP_MOD, CM_FCLKEN),
@@ -1191,6 +1209,7 @@ static const struct clksel core_l3_clksel[] = {
 static struct clk core_l3_ck = {	/* Used for ick and fck, interconnect */
 	.name		= "core_l3_ck",
 	.parent		= &core_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				ALWAYS_ENABLED | DELAYED_APP |
 				CONFIG_PARTICIPANT | RATE_PROPAGATES,
@@ -1220,6 +1239,7 @@ static const struct clksel usb_l4_ick_clksel[] = {
 static struct clk usb_l4_ick = {	/* FS-USB interface clock */
 	.name		= "usb_l4_ick",
 	.parent		= &core_l3_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				DELAYED_APP | CONFIG_PARTICIPANT,
 	.clkdm		= { .name = "core_l4_clkdm" },
@@ -1254,6 +1274,7 @@ static const struct clksel l4_clksel[] = {
 static struct clk l4_ck = {		/* used both as an ick and fck */
 	.name		= "l4_ck",
 	.parent		= &core_l3_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				ALWAYS_ENABLED | DELAYED_APP | RATE_PROPAGATES,
 	.clkdm		= { .name = "core_l4_clkdm" },
@@ -1292,6 +1313,7 @@ static const struct clksel ssi_ssr_sst_fck_clksel[] = {
 static struct clk ssi_ssr_sst_fck = {
 	.name		= "ssi_fck",
 	.parent		= &core_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				DELAYED_APP,
 	.clkdm		= { .name = "core_l3_clkdm" },
@@ -1312,6 +1334,7 @@ static struct clk ssi_ssr_sst_fck = {
 static struct clk ssi_l4_ick = {
 	.name		= "ssi_l4_ick",
 	.parent		= &l4_ck,
+	.prcm_mod	= CORE_MOD,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN2),
@@ -1342,6 +1365,7 @@ static const struct clksel gfx_fck_clksel[] = {
 static struct clk gfx_3d_fck = {
 	.name		= "gfx_3d_fck",
 	.parent		= &core_l3_ck,
+	.prcm_mod	= GFX_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "gfx_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(GFX_MOD, CM_FCLKEN),
@@ -1357,6 +1381,7 @@ static struct clk gfx_3d_fck = {
 static struct clk gfx_2d_fck = {
 	.name		= "gfx_2d_fck",
 	.parent		= &core_l3_ck,
+	.prcm_mod	= GFX_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "gfx_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(GFX_MOD, CM_FCLKEN),
@@ -1372,6 +1397,7 @@ static struct clk gfx_2d_fck = {
 static struct clk gfx_ick = {
 	.name		= "gfx_ick",		/* From l3 */
 	.parent		= &core_l3_ck,
+	.prcm_mod	= GFX_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "gfx_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(GFX_MOD, CM_ICLKEN),
@@ -1402,6 +1428,7 @@ static const struct clksel mdm_ick_clksel[] = {
 static struct clk mdm_ick = {		/* used both as a ick and fck */
 	.name		= "mdm_ick",
 	.parent		= &core_ck,
+	.prcm_mod	= OMAP2430_MDM_MOD,
 	.flags		= CLOCK_IN_OMAP243X | DELAYED_APP | CONFIG_PARTICIPANT,
 	.clkdm		= { .name = "mdm_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(OMAP2430_MDM_MOD, CM_ICLKEN),
@@ -1417,6 +1444,7 @@ static struct clk mdm_ick = {		/* used both as a ick and fck */
 static struct clk mdm_osc_ck = {
 	.name		= "mdm_osc_ck",
 	.parent		= &osc_ck,
+	.prcm_mod	= OMAP2430_MDM_MOD,
 	.flags		= CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "mdm_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(OMAP2430_MDM_MOD, CM_FCLKEN),
@@ -1462,6 +1490,7 @@ static const struct clksel dss1_fck_clksel[] = {
 static struct clk dss_ick = {		/* Enables both L3,L4 ICLK's */
 	.name		= "dss_ick",
 	.parent		= &l4_ck,	/* really both l3 and l4 */
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "dss_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
@@ -1472,6 +1501,7 @@ static struct clk dss_ick = {		/* Enables both L3,L4 ICLK's */
 static struct clk dss1_fck = {
 	.name		= "dss1_fck",
 	.parent		= &core_ck,		/* Core or sys */
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				DELAYED_APP,
 	.clkdm		= { .name = "dss_clkdm" },
@@ -1505,6 +1535,7 @@ static const struct clksel dss2_fck_clksel[] = {
 static struct clk dss2_fck = {		/* Alt clk used in power management */
 	.name		= "dss2_fck",
 	.parent		= &sys_ck,		/* fixed at sys_ck or 48MHz */
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				DELAYED_APP,
 	.clkdm		= { .name = "dss_clkdm" },
@@ -1520,6 +1551,7 @@ static struct clk dss2_fck = {		/* Alt clk used in power management */
 static struct clk dss_54m_fck = {	/* Alt clk used in power management */
 	.name		= "dss_54m_fck",	/* 54m tv clk */
 	.parent		= &func_54m_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "dss_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
@@ -1548,6 +1580,7 @@ static const struct clksel omap24xx_gpt_clksel[] = {
 static struct clk gpt1_ick = {
 	.name		= "gpt1_ick",
 	.parent		= &l4_ck,
+	.prcm_mod	= WKUP_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(WKUP_MOD, CM_ICLKEN),
@@ -1558,6 +1591,7 @@ static struct clk gpt1_ick = {
 static struct clk gpt1_fck = {
 	.name		= "gpt1_fck",
 	.parent		= &func_32k_ck,
+	.prcm_mod	= WKUP_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(WKUP_MOD, CM_FCLKEN),
@@ -1574,6 +1608,7 @@ static struct clk gpt1_fck = {
 static struct clk gpt2_ick = {
 	.name		= "gpt2_ick",
 	.parent		= &l4_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
@@ -1584,6 +1619,7 @@ static struct clk gpt2_ick = {
 static struct clk gpt2_fck = {
 	.name		= "gpt2_fck",
 	.parent		= &func_32k_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
@@ -1598,6 +1634,7 @@ static struct clk gpt2_fck = {
 static struct clk gpt3_ick = {
 	.name		= "gpt3_ick",
 	.parent		= &l4_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
@@ -1608,6 +1645,7 @@ static struct clk gpt3_ick = {
 static struct clk gpt3_fck = {
 	.name		= "gpt3_fck",
 	.parent		= &func_32k_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
@@ -1622,6 +1660,7 @@ static struct clk gpt3_fck = {
 static struct clk gpt4_ick = {
 	.name		= "gpt4_ick",
 	.parent		= &l4_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
@@ -1632,6 +1671,7 @@ static struct clk gpt4_ick = {
 static struct clk gpt4_fck = {
 	.name		= "gpt4_fck",
 	.parent		= &func_32k_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
@@ -1646,6 +1686,7 @@ static struct clk gpt4_fck = {
 static struct clk gpt5_ick = {
 	.name		= "gpt5_ick",
 	.parent		= &l4_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
@@ -1656,6 +1697,7 @@ static struct clk gpt5_ick = {
 static struct clk gpt5_fck = {
 	.name		= "gpt5_fck",
 	.parent		= &func_32k_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
@@ -1670,6 +1712,7 @@ static struct clk gpt5_fck = {
 static struct clk gpt6_ick = {
 	.name		= "gpt6_ick",
 	.parent		= &l4_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
@@ -1680,6 +1723,7 @@ static struct clk gpt6_ick = {
 static struct clk gpt6_fck = {
 	.name		= "gpt6_fck",
 	.parent		= &func_32k_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
@@ -1694,6 +1738,7 @@ static struct clk gpt6_fck = {
 static struct clk gpt7_ick = {
 	.name		= "gpt7_ick",
 	.parent		= &l4_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
@@ -1704,6 +1749,7 @@ static struct clk gpt7_ick = {
 static struct clk gpt7_fck = {
 	.name		= "gpt7_fck",
 	.parent		= &func_32k_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
@@ -1718,6 +1764,7 @@ static struct clk gpt7_fck = {
 static struct clk gpt8_ick = {
 	.name		= "gpt8_ick",
 	.parent		= &l4_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
@@ -1728,6 +1775,7 @@ static struct clk gpt8_ick = {
 static struct clk gpt8_fck = {
 	.name		= "gpt8_fck",
 	.parent		= &func_32k_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
@@ -1742,6 +1790,7 @@ static struct clk gpt8_fck = {
 static struct clk gpt9_ick = {
 	.name		= "gpt9_ick",
 	.parent		= &l4_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
@@ -1752,6 +1801,7 @@ static struct clk gpt9_ick = {
 static struct clk gpt9_fck = {
 	.name		= "gpt9_fck",
 	.parent		= &func_32k_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
@@ -1766,6 +1816,7 @@ static struct clk gpt9_fck = {
 static struct clk gpt10_ick = {
 	.name		= "gpt10_ick",
 	.parent		= &l4_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
@@ -1776,6 +1827,7 @@ static struct clk gpt10_ick = {
 static struct clk gpt10_fck = {
 	.name		= "gpt10_fck",
 	.parent		= &func_32k_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
@@ -1790,6 +1842,7 @@ static struct clk gpt10_fck = {
 static struct clk gpt11_ick = {
 	.name		= "gpt11_ick",
 	.parent		= &l4_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
@@ -1800,6 +1853,7 @@ static struct clk gpt11_ick = {
 static struct clk gpt11_fck = {
 	.name		= "gpt11_fck",
 	.parent		= &func_32k_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
@@ -1814,6 +1868,7 @@ static struct clk gpt11_fck = {
 static struct clk gpt12_ick = {
 	.name		= "gpt12_ick",
 	.parent		= &l4_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
@@ -1824,6 +1879,7 @@ static struct clk gpt12_ick = {
 static struct clk gpt12_fck = {
 	.name		= "gpt12_fck",
 	.parent		= &func_32k_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
@@ -1839,6 +1895,7 @@ static struct clk mcbsp1_ick = {
 	.name		= "mcbsp_ick",
 	.id		= 1,
 	.parent		= &l4_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
@@ -1850,6 +1907,7 @@ static struct clk mcbsp1_fck = {
 	.name		= "mcbsp_fck",
 	.id		= 1,
 	.parent		= &func_96m_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
@@ -1861,6 +1919,7 @@ static struct clk mcbsp2_ick = {
 	.name		= "mcbsp_ick",
 	.id		= 2,
 	.parent		= &l4_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
@@ -1872,6 +1931,7 @@ static struct clk mcbsp2_fck = {
 	.name		= "mcbsp_fck",
 	.id		= 2,
 	.parent		= &func_96m_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
@@ -1883,6 +1943,7 @@ static struct clk mcbsp3_ick = {
 	.name		= "mcbsp_ick",
 	.id		= 3,
 	.parent		= &l4_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN2),
@@ -1894,6 +1955,7 @@ static struct clk mcbsp3_fck = {
 	.name		= "mcbsp_fck",
 	.id		= 3,
 	.parent		= &func_96m_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_FCLKEN2),
@@ -1905,6 +1967,7 @@ static struct clk mcbsp4_ick = {
 	.name		= "mcbsp_ick",
 	.id		= 4,
 	.parent		= &l4_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN2),
@@ -1916,6 +1979,7 @@ static struct clk mcbsp4_fck = {
 	.name		= "mcbsp_fck",
 	.id		= 4,
 	.parent		= &func_96m_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_FCLKEN2),
@@ -1927,6 +1991,7 @@ static struct clk mcbsp5_ick = {
 	.name		= "mcbsp_ick",
 	.id		= 5,
 	.parent		= &l4_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN2),
@@ -1938,6 +2003,7 @@ static struct clk mcbsp5_fck = {
 	.name		= "mcbsp_fck",
 	.id		= 5,
 	.parent		= &func_96m_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_FCLKEN2),
@@ -1949,6 +2015,7 @@ static struct clk mcspi1_ick = {
 	.name		= "mcspi_ick",
 	.id		= 1,
 	.parent		= &l4_ck,
+	.prcm_mod	= CORE_MOD,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
@@ -1960,6 +2027,7 @@ static struct clk mcspi1_fck = {
 	.name		= "mcspi_fck",
 	.id		= 1,
 	.parent		= &func_48m_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
@@ -1971,6 +2039,7 @@ static struct clk mcspi2_ick = {
 	.name		= "mcspi_ick",
 	.id		= 2,
 	.parent		= &l4_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
@@ -1982,6 +2051,7 @@ static struct clk mcspi2_fck = {
 	.name		= "mcspi_fck",
 	.id		= 2,
 	.parent		= &func_48m_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
@@ -1993,6 +2063,7 @@ static struct clk mcspi3_ick = {
 	.name		= "mcspi_ick",
 	.id		= 3,
 	.parent		= &l4_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN2),
@@ -2004,6 +2075,7 @@ static struct clk mcspi3_fck = {
 	.name		= "mcspi_fck",
 	.id		= 3,
 	.parent		= &func_48m_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_FCLKEN2),
@@ -2014,6 +2086,7 @@ static struct clk mcspi3_fck = {
 static struct clk uart1_ick = {
 	.name		= "uart1_ick",
 	.parent		= &l4_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
@@ -2024,6 +2097,7 @@ static struct clk uart1_ick = {
 static struct clk uart1_fck = {
 	.name		= "uart1_fck",
 	.parent		= &func_48m_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
@@ -2034,6 +2108,7 @@ static struct clk uart1_fck = {
 static struct clk uart2_ick = {
 	.name		= "uart2_ick",
 	.parent		= &l4_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
@@ -2044,6 +2119,7 @@ static struct clk uart2_ick = {
 static struct clk uart2_fck = {
 	.name		= "uart2_fck",
 	.parent		= &func_48m_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
@@ -2054,6 +2130,7 @@ static struct clk uart2_fck = {
 static struct clk uart3_ick = {
 	.name		= "uart3_ick",
 	.parent		= &l4_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN2),
@@ -2064,6 +2141,7 @@ static struct clk uart3_ick = {
 static struct clk uart3_fck = {
 	.name		= "uart3_fck",
 	.parent		= &func_48m_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_FCLKEN2),
@@ -2074,6 +2152,7 @@ static struct clk uart3_fck = {
 static struct clk gpios_ick = {
 	.name		= "gpios_ick",
 	.parent		= &l4_ck,
+	.prcm_mod	= WKUP_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(WKUP_MOD, CM_ICLKEN),
@@ -2084,6 +2163,7 @@ static struct clk gpios_ick = {
 static struct clk gpios_fck = {
 	.name		= "gpios_fck",
 	.parent		= &func_32k_ck,
+	.prcm_mod	= WKUP_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "prm_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(WKUP_MOD, CM_FCLKEN),
@@ -2095,6 +2175,7 @@ static struct clk gpios_fck = {
 static struct clk mpu_wdt_ick = {
 	.name		= "mpu_wdt_ick",
 	.parent		= &l4_ck,
+	.prcm_mod	= WKUP_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "prm_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(WKUP_MOD, CM_ICLKEN),
@@ -2106,6 +2187,7 @@ static struct clk mpu_wdt_ick = {
 static struct clk mpu_wdt_fck = {
 	.name		= "mpu_wdt_fck",
 	.parent		= &func_32k_ck,
+	.prcm_mod	= WKUP_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "prm_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(WKUP_MOD, CM_FCLKEN),
@@ -2116,6 +2198,7 @@ static struct clk mpu_wdt_fck = {
 static struct clk sync_32k_ick = {
 	.name		= "sync_32k_ick",
 	.parent		= &l4_ck,
+	.prcm_mod	= WKUP_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				ENABLE_ON_INIT,
 	.clkdm		= { .name = "core_l4_clkdm" },
@@ -2128,6 +2211,7 @@ static struct clk sync_32k_ick = {
 static struct clk wdt1_ick = {
 	.name		= "wdt1_ick",
 	.parent		= &l4_ck,
+	.prcm_mod	= WKUP_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "prm_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(WKUP_MOD, CM_ICLKEN),
@@ -2138,6 +2222,7 @@ static struct clk wdt1_ick = {
 static struct clk omapctrl_ick = {
 	.name		= "omapctrl_ick",
 	.parent		= &l4_ck,
+	.prcm_mod	= WKUP_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				ENABLE_ON_INIT,
 	.clkdm		= { .name = "core_l4_clkdm" },
@@ -2149,6 +2234,7 @@ static struct clk omapctrl_ick = {
 static struct clk icr_ick = {
 	.name		= "icr_ick",
 	.parent		= &l4_ck,
+	.prcm_mod	= WKUP_MOD,
 	.flags		= CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(WKUP_MOD, CM_ICLKEN),
@@ -2159,6 +2245,7 @@ static struct clk icr_ick = {
 static struct clk cam_ick = {
 	.name		= "cam_ick",
 	.parent		= &l4_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
@@ -2174,6 +2261,7 @@ static struct clk cam_ick = {
 static struct clk cam_fck = {
 	.name		= "cam_fck",
 	.parent		= &func_96m_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l3_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
@@ -2184,6 +2272,7 @@ static struct clk cam_fck = {
 static struct clk mailboxes_ick = {
 	.name		= "mailboxes_ick",
 	.parent		= &l4_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
@@ -2194,6 +2283,7 @@ static struct clk mailboxes_ick = {
 static struct clk wdt4_ick = {
 	.name		= "wdt4_ick",
 	.parent		= &l4_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
@@ -2204,6 +2294,7 @@ static struct clk wdt4_ick = {
 static struct clk wdt4_fck = {
 	.name		= "wdt4_fck",
 	.parent		= &func_32k_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
@@ -2214,6 +2305,7 @@ static struct clk wdt4_fck = {
 static struct clk wdt3_ick = {
 	.name		= "wdt3_ick",
 	.parent		= &l4_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
@@ -2224,6 +2316,7 @@ static struct clk wdt3_ick = {
 static struct clk wdt3_fck = {
 	.name		= "wdt3_fck",
 	.parent		= &func_32k_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
@@ -2234,6 +2327,7 @@ static struct clk wdt3_fck = {
 static struct clk mspro_ick = {
 	.name		= "mspro_ick",
 	.parent		= &l4_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
@@ -2244,6 +2338,7 @@ static struct clk mspro_ick = {
 static struct clk mspro_fck = {
 	.name		= "mspro_fck",
 	.parent		= &func_96m_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
@@ -2254,6 +2349,7 @@ static struct clk mspro_fck = {
 static struct clk mmc_ick = {
 	.name		= "mmc_ick",
 	.parent		= &l4_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
@@ -2264,6 +2360,7 @@ static struct clk mmc_ick = {
 static struct clk mmc_fck = {
 	.name		= "mmc_fck",
 	.parent		= &func_96m_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
@@ -2274,6 +2371,7 @@ static struct clk mmc_fck = {
 static struct clk fac_ick = {
 	.name		= "fac_ick",
 	.parent		= &l4_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
@@ -2284,6 +2382,7 @@ static struct clk fac_ick = {
 static struct clk fac_fck = {
 	.name		= "fac_fck",
 	.parent		= &func_12m_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
@@ -2294,6 +2393,7 @@ static struct clk fac_fck = {
 static struct clk eac_ick = {
 	.name		= "eac_ick",
 	.parent		= &l4_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
@@ -2304,6 +2404,7 @@ static struct clk eac_ick = {
 static struct clk eac_fck = {
 	.name		= "eac_fck",
 	.parent		= &func_96m_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
@@ -2314,6 +2415,7 @@ static struct clk eac_fck = {
 static struct clk hdq_ick = {
 	.name		= "hdq_ick",
 	.parent		= &l4_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
@@ -2324,6 +2426,7 @@ static struct clk hdq_ick = {
 static struct clk hdq_fck = {
 	.name		= "hdq_fck",
 	.parent		= &func_12m_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
@@ -2335,6 +2438,7 @@ static struct clk i2c2_ick = {
 	.name		= "i2c_ick",
 	.id		= 2,
 	.parent		= &l4_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
@@ -2346,6 +2450,7 @@ static struct clk i2c2_fck = {
 	.name		= "i2c_fck",
 	.id		= 2,
 	.parent		= &func_12m_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
@@ -2357,6 +2462,7 @@ static struct clk i2chs2_fck = {
 	.name		= "i2c_fck",
 	.id		= 2,
 	.parent		= &func_96m_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_FCLKEN2),
@@ -2368,6 +2474,7 @@ static struct clk i2c1_ick = {
 	.name		= "i2c_ick",
 	.id		= 1,
 	.parent		= &l4_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
@@ -2379,6 +2486,7 @@ static struct clk i2c1_fck = {
 	.name		= "i2c_fck",
 	.id		= 1,
 	.parent		= &func_12m_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
@@ -2390,6 +2498,7 @@ static struct clk i2chs1_fck = {
 	.name		= "i2c_fck",
 	.id		= 1,
 	.parent		= &func_96m_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_FCLKEN2),
@@ -2425,6 +2534,7 @@ static struct clk sdma_ick = {
 static struct clk vlynq_ick = {
 	.name		= "vlynq_ick",
 	.parent		= &core_l3_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X,
 	.clkdm		= { .name = "core_l3_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN1),
@@ -2460,6 +2570,7 @@ static const struct clksel vlynq_fck_clksel[] = {
 static struct clk vlynq_fck = {
 	.name		= "vlynq_fck",
 	.parent		= &func_96m_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | DELAYED_APP,
 	.clkdm		= { .name = "core_l3_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_FCLKEN1),
@@ -2476,6 +2587,7 @@ static struct clk vlynq_fck = {
 static struct clk sdrc_ick = {
 	.name		= "sdrc_ick",
 	.parent		= &l4_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP243X | ENABLE_ON_INIT,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN3),
@@ -2486,6 +2598,7 @@ static struct clk sdrc_ick = {
 static struct clk des_ick = {
 	.name		= "des_ick",
 	.parent		= &l4_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP243X | CLOCK_IN_OMAP242X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_ICLKEN4),
@@ -2496,6 +2609,7 @@ static struct clk des_ick = {
 static struct clk sha_ick = {
 	.name		= "sha_ick",
 	.parent		= &l4_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP243X | CLOCK_IN_OMAP242X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_ICLKEN4),
@@ -2506,6 +2620,7 @@ static struct clk sha_ick = {
 static struct clk rng_ick = {
 	.name		= "rng_ick",
 	.parent		= &l4_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP243X | CLOCK_IN_OMAP242X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_ICLKEN4),
@@ -2516,6 +2631,7 @@ static struct clk rng_ick = {
 static struct clk aes_ick = {
 	.name		= "aes_ick",
 	.parent		= &l4_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP243X | CLOCK_IN_OMAP242X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_ICLKEN4),
@@ -2526,6 +2642,7 @@ static struct clk aes_ick = {
 static struct clk pka_ick = {
 	.name		= "pka_ick",
 	.parent		= &l4_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP243X | CLOCK_IN_OMAP242X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_ICLKEN4),
@@ -2536,6 +2653,7 @@ static struct clk pka_ick = {
 static struct clk usb_fck = {
 	.name		= "usb_fck",
 	.parent		= &func_48m_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP243X | CLOCK_IN_OMAP242X,
 	.clkdm		= { .name = "core_l3_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_FCLKEN2),
@@ -2546,6 +2664,7 @@ static struct clk usb_fck = {
 static struct clk usbhs_ick = {
 	.name		= "usbhs_ick",
 	.parent		= &core_l3_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l3_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN2),
@@ -2556,6 +2675,7 @@ static struct clk usbhs_ick = {
 static struct clk mmchs1_ick = {
 	.name		= "mmchs_ick",
 	.parent		= &l4_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN2),
@@ -2566,6 +2686,7 @@ static struct clk mmchs1_ick = {
 static struct clk mmchs1_fck = {
 	.name		= "mmchs_fck",
 	.parent		= &func_96m_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l3_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_FCLKEN2),
@@ -2577,6 +2698,7 @@ static struct clk mmchs2_ick = {
 	.name		= "mmchs_ick",
 	.id		= 1,
 	.parent		= &l4_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN2),
@@ -2588,6 +2710,7 @@ static struct clk mmchs2_fck = {
 	.name		= "mmchs_fck",
 	.id		= 1,
 	.parent		= &func_96m_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_FCLKEN2),
@@ -2598,6 +2721,7 @@ static struct clk mmchs2_fck = {
 static struct clk gpio5_ick = {
 	.name		= "gpio5_ick",
 	.parent		= &l4_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN2),
@@ -2608,6 +2732,7 @@ static struct clk gpio5_ick = {
 static struct clk gpio5_fck = {
 	.name		= "gpio5_fck",
 	.parent		= &func_32k_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_FCLKEN2),
@@ -2618,6 +2743,7 @@ static struct clk gpio5_fck = {
 static struct clk mdm_intc_ick = {
 	.name		= "mdm_intc_ick",
 	.parent		= &l4_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, CM_ICLKEN2),
@@ -2628,6 +2754,7 @@ static struct clk mdm_intc_ick = {
 static struct clk mmchsdb1_fck = {
 	.name		= "mmchsdb_fck",
 	.parent		= &func_32k_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_FCLKEN2),
@@ -2639,6 +2766,7 @@ static struct clk mmchsdb2_fck = {
 	.name		= "mmchsdb_fck",
 	.id		= 1,
 	.parent		= &func_32k_ck,
+	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP243X,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= _CM_REG_OFFSET(CORE_MOD, OMAP24XX_CM_FCLKEN2),
diff --git a/arch/arm/plat-omap/include/mach/clock.h b/arch/arm/plat-omap/include/mach/clock.h
index f6adf39..22db786 100644
--- a/arch/arm/plat-omap/include/mach/clock.h
+++ b/arch/arm/plat-omap/include/mach/clock.h
@@ -87,6 +87,7 @@ struct clk {
 		const char		*name;
 		struct clockdomain	*ptr;
 	} clkdm;
+	s16			prcm_mod;
 #else
 	__u8			rate_offset;
 	__u8			src_offset;
@@ -165,5 +166,12 @@ extern void clk_init_cpufreq_table(struct cpufreq_frequency_table **table);
 
 #define RATE_IN_24XX		(RATE_IN_242X | RATE_IN_243X)
 
+/*
+ * clk.prcm_mod flags (possible since only the top byte in clk.prcm_mod
+ * is significant)
+ */
+#define PRCM_MOD_ADDR_MASK	0xff00
+#define CLK_REG_IN_PRM		(1 << 0)
+#define CLK_REG_IN_SCM		(1 << 1)
 
 #endif


