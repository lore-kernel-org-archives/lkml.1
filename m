Return-Path: <linux-kernel-owner+w=401wt.eu-S1758917AbZEZWXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758917AbZEZWXU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 18:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758387AbZEZWWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 18:22:30 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:33549 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758683AbZEZWWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 18:22:25 -0400
MBOX-Line: From nobody Tue May 26 16:12:29 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH 02/10] OMAP3 clock: initialize SDRC timings at kernel start
To: linux-arm-kernel@lists.arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
       Paul Walmsley <paul@pwsan.com>
Date: Tue, 26 May 2009 16:12:29 -0600
Message-ID: <20090526221228.25381.29813.stgit@localhost.localdomain>
In-Reply-To: <20090526220517.25381.75976.stgit@localhost.localdomain>
References: <20090526220517.25381.75976.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On the OMAP3, initialize SDRC timings when the kernel boots.  This ensures
that the kernel is running with known, optimized SDRC timings, rather than
whatever was configured by the bootloader.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
---
 arch/arm/mach-omap2/clock34xx.c |    3 ---
 arch/arm/mach-omap2/io.c        |   38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-omap2/clock34xx.c b/arch/arm/mach-omap2/clock34xx.c
index 62092f2..a62e326 100644
--- a/arch/arm/mach-omap2/clock34xx.c
+++ b/arch/arm/mach-omap2/clock34xx.c
@@ -715,9 +715,6 @@ static int omap3_core_dpll_m2_set_rate(struct clk *clk, unsigned long rate)
 	if (clk != &dpll3_m2_ck)
 		return -EINVAL;
 
-	if (rate == clk->rate)
-		return 0;
-
 	validrate = omap2_clksel_round_rate_div(clk, rate, &new_div);
 	if (validrate != rate)
 		return -EINVAL;
diff --git a/arch/arm/mach-omap2/io.c b/arch/arm/mach-omap2/io.c
index 916fcd3..2756f49 100644
--- a/arch/arm/mach-omap2/io.c
+++ b/arch/arm/mach-omap2/io.c
@@ -19,6 +19,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/io.h>
+#include <linux/clk.h>
 
 #include <asm/tlb.h>
 
@@ -195,6 +196,40 @@ void __init omap2_map_common_io(void)
 	omapfb_reserve_sdram();
 }
 
+/*
+ * omap2_init_reprogram_sdrc - reprogram SDRC timing parameters
+ *
+ * Sets the CORE DPLL3 M2 divider to the same value that it's at
+ * currently.  This has the effect of setting the SDRC SDRAM AC timing
+ * registers to the values currently defined by the kernel.  Currently
+ * only defined for OMAP3; will return 0 if called on OMAP2.  Returns
+ * -EINVAL if the dpll3_m2_ck cannot be found, 0 if called on OMAP2,
+ * or passes along the return value of clk_set_rate().
+ */
+static int __init _omap2_init_reprogram_sdrc(void)
+{
+	struct clk *dpll3_m2_ck;
+	int v = -EINVAL;
+	long rate;
+
+	if (!cpu_is_omap34xx())
+		return 0;
+
+	dpll3_m2_ck = clk_get(NULL, "dpll3_m2_ck");
+	if (!dpll3_m2_ck)
+		return -EINVAL;
+
+	rate = clk_get_rate(dpll3_m2_ck);
+	pr_info("Reprogramming SDRC clock to %ld Hz\n", rate);
+	v = clk_set_rate(dpll3_m2_ck, rate);
+	if (v)
+		pr_err("dpll3_m2_clk rate change failed: %d\n", v);
+
+	clk_put(dpll3_m2_ck);
+
+	return v;
+}
+
 void __init omap2_init_common_hw(struct omap_sdrc_params *sp)
 {
 	omap2_mux_init();
@@ -202,5 +237,8 @@ void __init omap2_init_common_hw(struct omap_sdrc_params *sp)
 	clkdm_init(clockdomains_omap, clkdm_pwrdm_autodeps);
 	omap2_clk_init();
 	omap2_sdrc_init(sp);
+
+	_omap2_init_reprogram_sdrc();
+
 	gpmc_init();
 }


