Return-Path: <linux-kernel-owner+w=401wt.eu-S1753637AbZA1U21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637AbZA1U21 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 15:28:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752102AbZA1U12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:27:28 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:60905 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbZA1U1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:27:24 -0500
MBOX-Line: From nobody Wed Jan 28 12:18:19 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH D 02/11] OMAP2/3 clock: clean up mach-omap2/clock.c
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, Paul Walmsley <paul@pwsan.com>,
       Tony Lindgren <tony@atomide.com>
Date: Wed, 28 Jan 2009 12:18:19 -0700
Message-ID: <20090128191816.16688.990.stgit@localhost.localdomain>
In-Reply-To: <20090128191638.16688.33452.stgit@localhost.localdomain>
References: <20090128191638.16688.33452.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch rolls up several cleanup patches.

1. Some unnecessarily verbose variable names are used in several clock.c
functions; clean these up per CodingStyle.

2. Remove omap2_get_clksel() and just use clk->clksel_reg and
clk->clksel_mask directly.

3. Get rid of void __iomem * usage in omap2_clksel_get_src_field.
Prepend the function name with an underscore to highlight that it is a
static function.

linux-omap source commits are 7fa95e007ea2f3c4d0ecd2779d809756e7775894,
af0ea23f1ee4a5bea3b026e38761b47089f9048a, and
91c0c979b47c44b08f80e4f8d4c990fb158d82c4.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/clock.c |   99 +++++++++++++++----------------------------
 1 files changed, 35 insertions(+), 64 deletions(-)

diff --git a/arch/arm/mach-omap2/clock.c b/arch/arm/mach-omap2/clock.c
index 9957813..185e1b7 100644
--- a/arch/arm/mach-omap2/clock.c
+++ b/arch/arm/mach-omap2/clock.c
@@ -357,7 +357,7 @@ static void omap2_clk_wait_ready(struct clk *clk)
  */
 static int _omap2_clk_enable(struct clk *clk)
 {
-	u32 regval32;
+	u32 v;
 
 	if (clk->flags & (ALWAYS_ENABLED | PARENT_CONTROLS_CLOCK))
 		return 0;
@@ -371,12 +371,12 @@ static int _omap2_clk_enable(struct clk *clk)
 		return 0; /* REVISIT: -EINVAL */
 	}
 
-	regval32 = __raw_readl(clk->enable_reg);
+	v = __raw_readl(clk->enable_reg);
 	if (clk->flags & INVERT_ENABLE)
-		regval32 &= ~(1 << clk->enable_bit);
+		v &= ~(1 << clk->enable_bit);
 	else
-		regval32 |= (1 << clk->enable_bit);
-	__raw_writel(regval32, clk->enable_reg);
+		v |= (1 << clk->enable_bit);
+	__raw_writel(v, clk->enable_reg);
 	wmb();
 
 	omap2_clk_wait_ready(clk);
@@ -387,7 +387,7 @@ static int _omap2_clk_enable(struct clk *clk)
 /* Disables clock without considering parent dependencies or use count */
 static void _omap2_clk_disable(struct clk *clk)
 {
-	u32 regval32;
+	u32 v;
 
 	if (clk->flags & (ALWAYS_ENABLED | PARENT_CONTROLS_CLOCK))
 		return;
@@ -407,12 +407,12 @@ static void _omap2_clk_disable(struct clk *clk)
 		return;
 	}
 
-	regval32 = __raw_readl(clk->enable_reg);
+	v = __raw_readl(clk->enable_reg);
 	if (clk->flags & INVERT_ENABLE)
-		regval32 |= (1 << clk->enable_bit);
+		v |= (1 << clk->enable_bit);
 	else
-		regval32 &= ~(1 << clk->enable_bit);
-	__raw_writel(regval32, clk->enable_reg);
+		v &= ~(1 << clk->enable_bit);
+	__raw_writel(v, clk->enable_reg);
 	wmb();
 }
 
@@ -683,23 +683,6 @@ u32 omap2_divisor_to_clksel(struct clk *clk, u32 div)
 }
 
 /**
- * omap2_get_clksel - find clksel register addr & field mask for a clk
- * @clk: struct clk to use
- * @field_mask: ptr to u32 to store the register field mask
- *
- * Returns the address of the clksel register upon success or NULL on error.
- */
-static void __iomem *omap2_get_clksel(struct clk *clk, u32 *field_mask)
-{
-	if (!clk->clksel_reg || (clk->clksel_mask == 0))
-		return NULL;
-
-	*field_mask = clk->clksel_mask;
-
-	return clk->clksel_reg;
-}
-
-/**
  * omap2_clksel_get_divisor - get current divider applied to parent clock.
  * @clk: OMAP struct clk to use.
  *
@@ -707,41 +690,36 @@ static void __iomem *omap2_get_clksel(struct clk *clk, u32 *field_mask)
  */
 u32 omap2_clksel_get_divisor(struct clk *clk)
 {
-	u32 field_mask, field_val;
-	void __iomem *div_addr;
+	u32 v;
 
-	div_addr = omap2_get_clksel(clk, &field_mask);
-	if (!div_addr)
+	if (!clk->clksel_mask)
 		return 0;
 
-	field_val = __raw_readl(div_addr) & field_mask;
-	field_val >>= __ffs(field_mask);
+	v = __raw_readl(clk->clksel_reg) & clk->clksel_mask;
+	v >>= __ffs(clk->clksel_mask);
 
-	return omap2_clksel_to_divisor(clk, field_val);
+	return omap2_clksel_to_divisor(clk, v);
 }
 
 int omap2_clksel_set_rate(struct clk *clk, unsigned long rate)
 {
-	u32 field_mask, field_val, validrate, new_div = 0;
-	void __iomem *div_addr;
-	u32 v;
+	u32 v, field_val, validrate, new_div = 0;
 
-	validrate = omap2_clksel_round_rate_div(clk, rate, &new_div);
-	if (validrate != rate)
+	if (!clk->clksel_mask)
 		return -EINVAL;
 
-	div_addr = omap2_get_clksel(clk, &field_mask);
-	if (!div_addr)
+	validrate = omap2_clksel_round_rate_div(clk, rate, &new_div);
+	if (validrate != rate)
 		return -EINVAL;
 
 	field_val = omap2_divisor_to_clksel(clk, new_div);
 	if (field_val == ~0)
 		return -EINVAL;
 
-	v = __raw_readl(div_addr);
-	v &= ~field_mask;
-	v |= field_val << __ffs(field_mask);
-	__raw_writel(v, div_addr);
+	v = __raw_readl(clk->clksel_reg);
+	v &= ~clk->clksel_mask;
+	v |= field_val << __ffs(clk->clksel_mask);
+	__raw_writel(v, clk->clksel_reg);
 
 	wmb();
 
@@ -781,18 +759,14 @@ int omap2_clk_set_rate(struct clk *clk, unsigned long rate)
 
 /*
  * Converts encoded control register address into a full address
- * On error, *src_addr will be returned as 0.
+ * On error, the return value (parent_div) will be 0.
  */
-static u32 omap2_clksel_get_src_field(void __iomem **src_addr,
-				      struct clk *src_clk, u32 *field_mask,
-				      struct clk *clk, u32 *parent_div)
+static u32 _omap2_clksel_get_src_field(struct clk *src_clk, struct clk *clk,
+				       u32 *field_val)
 {
 	const struct clksel *clks;
 	const struct clksel_rate *clkr;
 
-	*parent_div = 0;
-	*src_addr = NULL;
-
 	clks = omap2_get_clksel_by_parent(clk, src_clk);
 	if (!clks)
 		return 0;
@@ -812,17 +786,14 @@ static u32 omap2_clksel_get_src_field(void __iomem **src_addr,
 	/* Should never happen.  Add a clksel mask to the struct clk. */
 	WARN_ON(clk->clksel_mask == 0);
 
-	*field_mask = clk->clksel_mask;
-	*src_addr = clk->clksel_reg;
-	*parent_div = clkr->div;
+	*field_val = clkr->val;
 
-	return clkr->val;
+	return clkr->div;
 }
 
 int omap2_clk_set_parent(struct clk *clk, struct clk *new_parent)
 {
-	void __iomem *src_addr;
-	u32 field_val, field_mask, reg_val, parent_div;
+	u32 field_val, v, parent_div;
 
 	if (clk->flags & CONFIG_PARTICIPANT)
 		return -EINVAL;
@@ -830,18 +801,18 @@ int omap2_clk_set_parent(struct clk *clk, struct clk *new_parent)
 	if (!clk->clksel)
 		return -EINVAL;
 
-	field_val = omap2_clksel_get_src_field(&src_addr, new_parent,
-					       &field_mask, clk, &parent_div);
-	if (!src_addr)
+	parent_div = _omap2_clksel_get_src_field(new_parent, clk, &field_val);
+	if (!parent_div)
 		return -EINVAL;
 
 	if (clk->usecount > 0)
 		_omap2_clk_disable(clk);
 
 	/* Set new source value (previous dividers if any in effect) */
-	reg_val = __raw_readl(src_addr) & ~field_mask;
-	reg_val |= (field_val << __ffs(field_mask));
-	__raw_writel(reg_val, src_addr);
+	v = __raw_readl(clk->clksel_reg);
+	v &= ~clk->clksel_mask;
+	v |= field_val << __ffs(clk->clksel_mask);
+	__raw_writel(v, clk->clksel_reg);
 	wmb();
 
 	if (clk->flags & DELAYED_APP && cpu_is_omap24xx()) {


