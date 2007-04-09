Return-Path: <linux-kernel-owner+w=401wt.eu-S965934AbXDIV12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965934AbXDIV12 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:27:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030259AbXDIV0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:26:53 -0400
Received: from nlpi015.sbcis.sbc.com ([207.115.36.44]:29201 "EHLO
	nlpi015.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965949AbXDIV0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:26:07 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Imre Deak <imre.deak@solidboot.com>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 3/6] ARM: OMAP: add SoSSI clock
Date: Mon,  9 Apr 2007 17:25:41 -0400
Message-Id: <11761539553166-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11761539511877-git-send-email-tony@atomide.com>
References: <1176153944991-git-send-email-tony@atomide.com> <1176153948771-git-send-email-tony@atomide.com> <11761539511877-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Imre Deak <imre.deak@solidboot.com>

This is needed, so that disabling the SoSSI clock during idle can
be prevented.

Signed-off-by: Imre Deak <imre.deak@solidboot.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap1/clock.c |   34 ++++++++++++++++++++++++++++++++++
 arch/arm/mach-omap1/clock.h |   21 +++++++++++++++++++--
 2 files changed, 53 insertions(+), 2 deletions(-)

--- a/arch/arm/mach-omap1/clock.c
+++ b/arch/arm/mach-omap1/clock.c
@@ -49,6 +49,15 @@ static void omap1_uart_recalc(struct clk * clk)
 		clk->rate = 12000000;
 }
 
+static void omap1_sossi_recalc(struct clk *clk)
+{
+	u32 div = omap_readl(MOD_CONF_CTRL_1);
+
+	div = (div >> 17) & 0x7;
+	div++;
+	clk->rate = clk->parent->rate / div;
+}
+
 static int omap1_clk_enable_dsp_domain(struct clk *clk)
 {
 	int retval;
@@ -396,6 +405,31 @@ static int omap1_set_ext_clk_rate(struct clk * clk, unsigned long rate)
 	return 0;
 }
 
+static int omap1_set_sossi_rate(struct clk *clk, unsigned long rate)
+{
+	u32 l;
+	int div;
+	unsigned long p_rate;
+
+	p_rate = clk->parent->rate;
+	/* Round towards slower frequency */
+	div = (p_rate + rate - 1) / rate;
+	div--;
+	if (div < 0 || div > 7)
+		return -EINVAL;
+
+	l = omap_readl(MOD_CONF_CTRL_1);
+	l &= ~(7 << 17);
+	l |= div << 17;
+	omap_writel(l, MOD_CONF_CTRL_1);
+
+	clk->rate = p_rate / (div + 1);
+	if (unlikely(clk->flags & RATE_PROPAGATES))
+		propagate_rate(clk);
+
+	return 0;
+}
+
 static long omap1_round_ext_clk_rate(struct clk * clk, unsigned long rate)
 {
 	return 96000000 / calc_ext_dsor(rate);
--- a/arch/arm/mach-omap1/clock.h
+++ b/arch/arm/mach-omap1/clock.h
@@ -17,6 +17,8 @@ static int omap1_clk_enable_generic(struct clk * clk);
 static void omap1_clk_disable_generic(struct clk * clk);
 static void omap1_ckctl_recalc(struct clk * clk);
 static void omap1_watchdog_recalc(struct clk * clk);
+static int omap1_set_sossi_rate(struct clk *clk, unsigned long rate);
+static void omap1_sossi_recalc(struct clk *clk);
 static void omap1_ckctl_recalc_dsp_domain(struct clk * clk);
 static int omap1_clk_enable_dsp_domain(struct clk * clk);
 static int omap1_clk_set_rate_dsp_domain(struct clk * clk, unsigned long rate);
@@ -168,9 +170,10 @@ static struct clk ck_dpll1 = {
 
 static struct arm_idlect1_clk ck_dpll1out = {
 	.clk = {
-	       	.name		= "ck_dpll1out",
+		.name		= "ck_dpll1out",
 		.parent		= &ck_dpll1,
-		.flags		= CLOCK_IN_OMAP16XX | CLOCK_IDLE_CONTROL,
+		.flags		= CLOCK_IN_OMAP16XX | CLOCK_IDLE_CONTROL |
+				  ENABLE_REG_32BIT | RATE_PROPAGATES,
 		.enable_reg	= (void __iomem *)ARM_IDLECT2,
 		.enable_bit	= EN_CKOUT_ARM,
 		.recalc		= &followparent_recalc,
@@ -180,6 +183,19 @@ static struct arm_idlect1_clk ck_dpll1out = {
 	.idlect_shift	= 12,
 };
 
+static struct clk sossi_ck = {
+	.name		= "ck_sossi",
+	.parent		= &ck_dpll1out.clk,
+	.flags		= CLOCK_IN_OMAP16XX | CLOCK_NO_IDLE_PARENT |
+			  ENABLE_REG_32BIT,
+	.enable_reg	= (void __iomem *)MOD_CONF_CTRL_1,
+	.enable_bit	= 16,
+	.recalc		= &omap1_sossi_recalc,
+	.set_rate	= &omap1_set_sossi_rate,
+	.enable		= &omap1_clk_enable_generic,
+	.disable	= &omap1_clk_disable_generic,
+};
+
 static struct clk arm_ck = {
 	.name		= "arm_ck",
 	.parent		= &ck_dpll1,
@@ -760,6 +776,7 @@ static struct clk * onchip_clks[] = {
 	&ck_dpll1,
 	/* CK_GEN1 clocks */
 	&ck_dpll1out.clk,
+	&sossi_ck,
 	&arm_ck,
 	&armper_ck.clk,
 	&arm_gpio_ck,
-- 
1.4.4.2

