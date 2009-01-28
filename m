Return-Path: <linux-kernel-owner+w=401wt.eu-S1761417AbZA1Uwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761417AbZA1Uwl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 15:52:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756506AbZA1UcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:32:14 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:47795 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756470AbZA1UcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:32:11 -0500
MBOX-Line: From nobody Wed Jan 28 12:35:12 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH F 05/12] OMAP clock: add OMAP chip family-specific
	clk_register() option
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, Paul Walmsley <paul@pwsan.com>,
       Tony Lindgren <tony@atomide.com>
Date: Wed, 28 Jan 2009 12:35:12 -0700
Message-ID: <20090128193509.2396.32243.stgit@localhost.localdomain>
In-Reply-To: <20090128193326.2396.9437.stgit@localhost.localdomain>
References: <20090128193326.2396.9437.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a mechanism for OMAP chip family (e.g., OMAP1, 2, 3) clock
code to define a clk_register function via struct clk_functions.  This
is currently only used for OMAP2/3, to handle clock->clockdomain
registration.

linux-omap source commit is 12081fce83c10221ccd1b282e3e2fbe56f742e21.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/clock.c             |    6 ++++++
 arch/arm/mach-omap2/clock.h             |    1 +
 arch/arm/mach-omap2/clock24xx.c         |    3 +--
 arch/arm/mach-omap2/clock34xx.c         |    5 ++---
 arch/arm/plat-omap/clock.c              |   11 ++++++++++-
 arch/arm/plat-omap/include/mach/clock.h |    1 +
 6 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-omap2/clock.c b/arch/arm/mach-omap2/clock.c
index bbc6e7d..c93a5aa 100644
--- a/arch/arm/mach-omap2/clock.c
+++ b/arch/arm/mach-omap2/clock.c
@@ -1087,3 +1087,9 @@ void omap2_clk_disable_unused(struct clk *clk)
 		_omap2_clk_disable(clk);
 }
 #endif
+
+int omap2_clk_register(struct clk *clk)
+{
+	omap2_init_clk_clkdm(clk);
+	return 0;
+}
diff --git a/arch/arm/mach-omap2/clock.h b/arch/arm/mach-omap2/clock.h
index a026ec9..f4d489f 100644
--- a/arch/arm/mach-omap2/clock.h
+++ b/arch/arm/mach-omap2/clock.h
@@ -37,6 +37,7 @@
 #define OMAP3XXX_EN_DPLL_LOCKED			0x7
 
 int omap2_clk_init(void);
+int omap2_clk_register(struct clk *clk);
 int omap2_clk_enable(struct clk *clk);
 void omap2_clk_disable(struct clk *clk);
 long omap2_clk_round_rate(struct clk *clk, unsigned long rate);
diff --git a/arch/arm/mach-omap2/clock24xx.c b/arch/arm/mach-omap2/clock24xx.c
index cd9fa0d..c24c937 100644
--- a/arch/arm/mach-omap2/clock24xx.c
+++ b/arch/arm/mach-omap2/clock24xx.c
@@ -451,6 +451,7 @@ void omap2_clk_init_cpufreq_table(struct cpufreq_frequency_table **table)
 #endif
 
 static struct clk_functions omap2_clk_functions = {
+	.clk_register		= omap2_clk_register,
 	.clk_enable		= omap2_clk_enable,
 	.clk_disable		= omap2_clk_disable,
 	.clk_round_rate		= omap2_clk_round_rate,
@@ -579,13 +580,11 @@ int __init omap2_clk_init(void)
 
 		if ((*clkp)->flags & CLOCK_IN_OMAP242X && cpu_is_omap2420()) {
 			clk_register(*clkp);
-			omap2_init_clk_clkdm(*clkp);
 			continue;
 		}
 
 		if ((*clkp)->flags & CLOCK_IN_OMAP243X && cpu_is_omap2430()) {
 			clk_register(*clkp);
-			omap2_init_clk_clkdm(*clkp);
 			continue;
 		}
 	}
diff --git a/arch/arm/mach-omap2/clock34xx.c b/arch/arm/mach-omap2/clock34xx.c
index 917664d..824144e 100644
--- a/arch/arm/mach-omap2/clock34xx.c
+++ b/arch/arm/mach-omap2/clock34xx.c
@@ -633,6 +633,7 @@ static void omap3_clkoutx2_recalc(struct clk *clk, unsigned long parent_rate,
 #if defined(CONFIG_ARCH_OMAP3)
 
 static struct clk_functions omap2_clk_functions = {
+	.clk_register		= omap2_clk_register,
 	.clk_enable		= omap2_clk_enable,
 	.clk_disable		= omap2_clk_disable,
 	.clk_round_rate		= omap2_clk_round_rate,
@@ -729,10 +730,8 @@ int __init omap2_clk_init(void)
 	for (clkp = onchip_34xx_clks;
 	     clkp < onchip_34xx_clks + ARRAY_SIZE(onchip_34xx_clks);
 	     clkp++) {
-		if ((*clkp)->flags & cpu_clkflg) {
+		if ((*clkp)->flags & cpu_clkflg)
 			clk_register(*clkp);
-			omap2_init_clk_clkdm(*clkp);
-		}
 	}
 
 	/* REVISIT: Not yet ready for OMAP3 */
diff --git a/arch/arm/plat-omap/clock.c b/arch/arm/plat-omap/clock.c
index f4a89c5..c1fad02 100644
--- a/arch/arm/plat-omap/clock.c
+++ b/arch/arm/plat-omap/clock.c
@@ -439,10 +439,17 @@ void recalculate_root_clocks(void)
 
 int clk_register(struct clk *clk)
 {
+	int ret;
+
 	if (clk == NULL || IS_ERR(clk))
 		return -EINVAL;
 
 	mutex_lock(&clocks_mutex);
+	if (arch_clock->clk_register) {
+		ret = arch_clock->clk_register(clk);
+		if (ret)
+			goto cr_out;
+	}
 	list_add(&clk->node, &clocks);
 	if (!clk->children.next)
 		INIT_LIST_HEAD(&clk->children);
@@ -450,9 +457,11 @@ int clk_register(struct clk *clk)
 		omap_clk_add_child(clk->parent, clk);
 	if (clk->init)
 		clk->init(clk);
+	ret = 0;
+cr_out:
 	mutex_unlock(&clocks_mutex);
 
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL(clk_register);
 
diff --git a/arch/arm/plat-omap/include/mach/clock.h b/arch/arm/plat-omap/include/mach/clock.h
index 2a30268..db57b71 100644
--- a/arch/arm/plat-omap/include/mach/clock.h
+++ b/arch/arm/plat-omap/include/mach/clock.h
@@ -117,6 +117,7 @@ struct clk {
 struct cpufreq_frequency_table;
 
 struct clk_functions {
+	int		(*clk_register)(struct clk *clk);
 	int		(*clk_enable)(struct clk *clk);
 	void		(*clk_disable)(struct clk *clk);
 	long		(*clk_round_rate)(struct clk *clk, unsigned long rate);


