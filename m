Return-Path: <linux-kernel-owner+w=401wt.eu-S1756248AbZBWQE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248AbZBWQE1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 11:04:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754070AbZBWQES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 11:04:18 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52748 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754797AbZBWQER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 11:04:17 -0500
Date: Mon, 23 Feb 2009 16:03:49 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Woodruff, Richard" <r-woodruff2@ti.com>
Cc: Paul Walmsley <paul@pwsan.com>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH E 11/14] OMAP clock: track child clocks
Message-ID: <20090223160349.GB27688@n2100.arm.linux.org.uk>
References: <20090128192551.29333.82943.stgit@localhost.localdomain> <20090128192756.29333.41541.stgit@localhost.localdomain> <20090129151401.GC18233@n2100.arm.linux.org.uk> <20090129220608.GJ18233@n2100.arm.linux.org.uk> <20090219121932.GL6407@n2100.arm.linux.org.uk> <13B9B4C6EF24D648824FF11BE896716203772C3680@dlee02.ent.ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13B9B4C6EF24D648824FF11BE896716203772C3680@dlee02.ent.ti.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 19, 2009 at 06:50:52PM -0600, Woodruff, Richard wrote:
> The historic usage of this has been against single use leaf clocks (1st instance of gptimer).  When it was used it did:
>         clk_get()
>         clk_set_parent()
>         clk_enable()
> 
> This usage was ok for that. Use on a disabled clock is needed.
> 
> If there are multiple users on the clock or it is enabled there are problems.

It sounds to me like clk_set_parent() needs this then to prevent enabled
clocks being reparented.  By doing so, we no longer need to disable/enable
the clock within the OMAP2/3 set_parent function since we are now
guaranteed that the clock will be disabled.

Ack?

diff --git a/arch/arm/mach-omap2/clock.c b/arch/arm/mach-omap2/clock.c
index 40cb65b..f49bce9 100644
--- a/arch/arm/mach-omap2/clock.c
+++ b/arch/arm/mach-omap2/clock.c
@@ -807,9 +807,6 @@ int omap2_clk_set_parent(struct clk *clk, struct clk *new_parent)
 	if (!parent_div)
 		return -EINVAL;
 
-	if (clk->usecount > 0)
-		_omap2_clk_disable(clk);
-
 	/* Set new source value (previous dividers if any in effect) */
 	v = __raw_readl(clk->clksel_reg);
 	v &= ~clk->clksel_mask;
@@ -819,9 +816,6 @@ int omap2_clk_set_parent(struct clk *clk, struct clk *new_parent)
 
 	_omap2xxx_clk_commit(clk);
 
-	if (clk->usecount > 0)
-		_omap2_clk_enable(clk);
-
 	clk_reparent(clk, new_parent);
 
 	/* CLKSEL clocks follow their parents' rates, divided by a divisor */
diff --git a/arch/arm/plat-omap/clock.c b/arch/arm/plat-omap/clock.c
index 08baa18..b2d9e1f 100644
--- a/arch/arm/plat-omap/clock.c
+++ b/arch/arm/plat-omap/clock.c
@@ -144,12 +144,14 @@ int clk_set_parent(struct clk *clk, struct clk *parent)
 		return ret;
 
 	spin_lock_irqsave(&clockfw_lock, flags);
-	if (arch_clock->clk_set_parent)
-		ret = arch_clock->clk_set_parent(clk, parent);
-	if (ret == 0) {
-		if (clk->recalc)
-			clk->rate = clk->recalc(clk);
-		propagate_rate(clk);
+	if (clk->usecount == 0) {
+		if (arch_clock->clk_set_parent)
+			ret = arch_clock->clk_set_parent(clk, parent);
+		if (ret == 0) {
+			if (clk->recalc)
+				clk->rate = clk->recalc(clk);
+			propagate_rate(clk);
+		}
 	}
 	spin_unlock_irqrestore(&clockfw_lock, flags);
 
