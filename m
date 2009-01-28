Return-Path: <linux-kernel-owner+w=401wt.eu-S1760195AbZA1Url@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760195AbZA1Url (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 15:47:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756096AbZA1Ubz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:31:55 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:47766 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756271AbZA1Uby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:31:54 -0500
MBOX-Line: From nobody Wed Jan 28 12:08:20 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH C 04/13] OMAP3 clock: note the bypass source clock for DPLLs
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, Paul Walmsley <paul@pwsan.com>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Tony Lindgren <tony@atomide.com>
Date: Wed, 28 Jan 2009 12:08:20 -0700
Message-ID: <20090128190817.12092.97549.stgit@localhost.localdomain>
In-Reply-To: <20090128190724.12092.22239.stgit@localhost.localdomain>
References: <20090128190724.12092.22239.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most DPLLs use sys_clk as their bypass rate source.  But DPLL1 and DPLL2
use high-frequency bypass clocks dpll1_fclk and dpll2_fclk as their parents
during bypass.  Add a new struct dpll_data field to track the DPLL's bypass
source clock.

Kevin Hilman <khilman@deeprootsystems.com> helped catch this - thanks Kevin.

linux-omap source commit is 7d06c48dd63545c6d5ea71c80b9049b55c6dab6e.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Cc: Kevin Hilman <khilman@deeprootsystems.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/clock34xx.h         |    9 +++++++++
 arch/arm/plat-omap/include/mach/clock.h |    1 +
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/clock34xx.h b/arch/arm/mach-omap2/clock34xx.h
index 277b221..5d20075 100644
--- a/arch/arm/mach-omap2/clock34xx.h
+++ b/arch/arm/mach-omap2/clock34xx.h
@@ -48,6 +48,10 @@ static int omap3_noncore_dpll_set_rate(struct clk *clk, unsigned long rate);
  * DPLL5 supplies other peripheral clocks (USBHOST, USIM).
  */
 
+/* Forward declarations for DPLL bypass clocks */
+static struct clk dpll1_fck;
+static struct clk dpll2_fck;
+
 /* CM_CLKEN_PLL*.EN* bit values - not all are available for every DPLL */
 #define DPLL_LOW_POWER_STOP		0x1
 #define DPLL_LOW_POWER_BYPASS		0x5
@@ -304,6 +308,7 @@ static struct dpll_data dpll1_dd = {
 	.autoidle_mask	= OMAP3430_AUTO_MPU_DPLL_MASK,
 	.idlest_reg	= _OMAP34XX_CM_REGADDR(MPU_MOD, OMAP3430_CM_IDLEST_PLL),
 	.idlest_mask	= OMAP3430_ST_MPU_CLK_MASK,
+	.bypass_clk	= &dpll1_fck,
 	.max_multiplier = OMAP3_MAX_DPLL_MULT,
 	.max_divider	= OMAP3_MAX_DPLL_DIV,
 	.rate_tolerance = DEFAULT_DPLL_RATE_TOLERANCE
@@ -376,6 +381,7 @@ static struct dpll_data dpll2_dd = {
 	.autoidle_mask	= OMAP3430_AUTO_IVA2_DPLL_MASK,
 	.idlest_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_IVA2_MOD, OMAP3430_CM_IDLEST_PLL),
 	.idlest_mask	= OMAP3430_ST_IVA2_CLK_MASK,
+	.bypass_clk	= &dpll2_fck,
 	.max_multiplier = OMAP3_MAX_DPLL_MULT,
 	.max_divider	= OMAP3_MAX_DPLL_DIV,
 	.rate_tolerance = DEFAULT_DPLL_RATE_TOLERANCE
@@ -436,6 +442,7 @@ static struct dpll_data dpll3_dd = {
 	.autoidle_mask	= OMAP3430_AUTO_CORE_DPLL_MASK,
 	.idlest_reg	= _OMAP34XX_CM_REGADDR(PLL_MOD, CM_IDLEST),
 	.idlest_mask	= OMAP3430_ST_CORE_CLK_MASK,
+	.bypass_clk	= &sys_ck,
 	.max_multiplier = OMAP3_MAX_DPLL_MULT,
 	.max_divider	= OMAP3_MAX_DPLL_DIV,
 	.rate_tolerance = DEFAULT_DPLL_RATE_TOLERANCE
@@ -626,6 +633,7 @@ static struct dpll_data dpll4_dd = {
 	.autoidle_mask	= OMAP3430_AUTO_PERIPH_DPLL_MASK,
 	.idlest_reg	= _OMAP34XX_CM_REGADDR(PLL_MOD, CM_IDLEST),
 	.idlest_mask	= OMAP3430_ST_PERIPH_CLK_MASK,
+	.bypass_clk	= &sys_ck,
 	.max_multiplier = OMAP3_MAX_DPLL_MULT,
 	.max_divider	= OMAP3_MAX_DPLL_DIV,
 	.rate_tolerance = DEFAULT_DPLL_RATE_TOLERANCE
@@ -968,6 +976,7 @@ static struct dpll_data dpll5_dd = {
 	.autoidle_mask	= OMAP3430ES2_AUTO_PERIPH2_DPLL_MASK,
 	.idlest_reg	= _OMAP34XX_CM_REGADDR(PLL_MOD, CM_IDLEST2),
 	.idlest_mask	= OMAP3430ES2_ST_PERIPH2_CLK_MASK,
+	.bypass_clk	= &sys_ck,
 	.max_multiplier = OMAP3_MAX_DPLL_MULT,
 	.max_divider	= OMAP3_MAX_DPLL_DIV,
 	.rate_tolerance = DEFAULT_DPLL_RATE_TOLERANCE
diff --git a/arch/arm/plat-omap/include/mach/clock.h b/arch/arm/plat-omap/include/mach/clock.h
index 666f52b..0fb4271 100644
--- a/arch/arm/plat-omap/include/mach/clock.h
+++ b/arch/arm/plat-omap/include/mach/clock.h
@@ -43,6 +43,7 @@ struct dpll_data {
 	u32			max_tolerance;
 	void __iomem		*idlest_reg;
 	u32			idlest_mask;
+	struct clk		*bypass_clk;
 #  if defined(CONFIG_ARCH_OMAP3)
 	u32			freqsel_mask;
 	u8			modes;


