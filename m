Return-Path: <linux-kernel-owner+w=401wt.eu-S1761285AbZA1Uv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761285AbZA1Uv5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 15:51:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756590AbZA1Ucf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:32:35 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:47891 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754726AbZA1Uca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:32:30 -0500
MBOX-Line: From nobody Wed Jan 28 12:08:14 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH C 02/13] OMAP3 clock: DPLL{1,2}_FCLK clksel can divide by 4
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, Paul Walmsley <paul@pwsan.com>,
       Tony Lindgren <tony@atomide.com>
Date: Wed, 28 Jan 2009 12:08:14 -0700
Message-ID: <20090128190811.12092.98984.stgit@localhost.localdomain>
In-Reply-To: <20090128190724.12092.22239.stgit@localhost.localdomain>
References: <20090128190724.12092.22239.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OMAP34xx ES2 TRM Delta G to H states that the divider for DPLL1_FCLK and
DPLL2_FCLK can divide by 4 in addition to dividing by 1 and 2. Encode this
into the OMAP3 clock framework.

linux-omap source commit is 050684c18f2ea0b08fdd5233a0cd3c7f96e00a0e.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/clock34xx.h |   20 ++++++++++++++++----
 1 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-omap2/clock34xx.h b/arch/arm/mach-omap2/clock34xx.h
index 781da12..9d123c6 100644
--- a/arch/arm/mach-omap2/clock34xx.h
+++ b/arch/arm/mach-omap2/clock34xx.h
@@ -1102,8 +1102,15 @@ static struct clk corex2_fck = {
 
 /* DPLL power domain clock controls */
 
-static const struct clksel div2_core_clksel[] = {
-	{ .parent = &core_ck, .rates = div2_rates },
+static const struct clksel_rate div4_rates[] = {
+	{ .div = 1, .val = 1, .flags = RATE_IN_343X | DEFAULT_RATE },
+	{ .div = 2, .val = 2, .flags = RATE_IN_343X },
+	{ .div = 4, .val = 4, .flags = RATE_IN_343X },
+	{ .div = 0 }
+};
+
+static const struct clksel div4_core_clksel[] = {
+	{ .parent = &core_ck, .rates = div4_rates },
 	{ .parent = NULL }
 };
 
@@ -1113,7 +1120,7 @@ static struct clk dpll1_fck = {
 	.init		= &omap2_init_clksel_parent,
 	.clksel_reg	= _OMAP34XX_CM_REGADDR(MPU_MOD, OMAP3430_CM_CLKSEL1_PLL),
 	.clksel_mask	= OMAP3430_MPU_CLK_SRC_MASK,
-	.clksel		= div2_core_clksel,
+	.clksel		= div4_core_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
 				PARENT_CONTROLS_CLOCK,
 	.clkdm		= { .name = "cm_clkdm" },
@@ -1191,7 +1198,7 @@ static struct clk dpll2_fck = {
 	.init		= &omap2_init_clksel_parent,
 	.clksel_reg	= _OMAP34XX_CM_REGADDR(OMAP3430_IVA2_MOD, OMAP3430_CM_CLKSEL1_PLL),
 	.clksel_mask	= OMAP3430_IVA2_CLK_SRC_MASK,
-	.clksel		= div2_core_clksel,
+	.clksel		= div4_core_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
 				PARENT_CONTROLS_CLOCK,
 	.clkdm		= { .name = "cm_clkdm" },
@@ -1228,6 +1235,11 @@ static struct clk iva2_ck = {
 
 /* Common interface clocks */
 
+static const struct clksel div2_core_clksel[] = {
+	{ .parent = &core_ck, .rates = div2_rates },
+	{ .parent = NULL }
+};
+
 static struct clk l3_ick = {
 	.name		= "l3_ick",
 	.parent		= &core_ck,


