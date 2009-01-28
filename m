Return-Path: <linux-kernel-owner+w=401wt.eu-S1754449AbZA1Ubr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449AbZA1Ubr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 15:31:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754158AbZA1U2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:28:05 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:60969 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950AbZA1U1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:27:37 -0500
MBOX-Line: From nobody Wed Jan 28 12:18:44 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH D 10/11] OMAP2/3 clock: clean up omap2_clk_wait_ready()
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, Paul Walmsley <paul@pwsan.com>,
       Tony Lindgren <tony@atomide.com>, Anand Gadiyar <gadiyar@ti.com>,
       Koen Kooi <k.kooi@student.utwente.nl>,
       Dirk Behme <dirk.behme@googlemail.com>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Richard Woodruff <r-woodruff2@ti.com>,
       Jouni =?utf-8?b?SMO2Z2FuZGVy?= <jouni.hogander@nokia.com>
Date: Wed, 28 Jan 2009 12:18:44 -0700
Message-ID: <20090128191841.16688.87791.stgit@localhost.localdomain>
In-Reply-To: <20090128191638.16688.33452.stgit@localhost.localdomain>
References: <20090128191638.16688.33452.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify omap2_clk_wait_ready() to use the new idlest_bit field in
struct clk, rather than a hunk of conditionals.

Others who have contributed to the patches in this rollup by reporting
bugs, testing, or reviewing include:
- Anand Gadiyar <gadiyar@ti.com>
- Koen Kooi <k.kooi@student.utwente.nl>
- Dirk Behme <dirk.behme@googlemail.com>
- Igor Stoppa <igor.stoppa@nokia.com>
- Richard Woodruff <r-woodruff2@ti.com>
- Jouni Högander <jouni.hogander@nokia.com>

More information can be found at the original source commits below.

linux-omap source commits are 999ccb505e4fa5720add74589fe747affcd7aa81,
f4c458db2b615037f7c1fd91d238f6420e7b8f77,
e2d8a430aab87fdc47b7f01de804e17b8960042d,
201fb6b950b41a798aa54ee78588ac68aed28a0a,
205f37af718984ec67444bccc888cd575531bce1,
0fe3bd3fb03ab35063b1d17070b24bfa007896c3,
3fa8636974ca1c04797781fb300c2e29ec18c3a8,
6f55ed7c13d655189da305207cf323041e4bcc4d, and
fd183f64d5325d727124d88c50b401a7da9c89c1.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Cc: Anand Gadiyar <gadiyar@ti.com>
Cc: Koen Kooi <k.kooi@student.utwente.nl>
Cc: Dirk Behme <dirk.behme@googlemail.com>
Cc: Igor Stoppa <igor.stoppa@nokia.com>
Cc: Richard Woodruff <r-woodruff2@ti.com>
Cc: Jouni Högander <jouni.hogander@nokia.com>
---
 arch/arm/mach-omap2/clock.c     |   93 ++++++++++++++++++++-------------------
 arch/arm/mach-omap2/clock.h     |    3 +
 arch/arm/mach-omap2/clock24xx.c |   10 ----
 3 files changed, 51 insertions(+), 55 deletions(-)

diff --git a/arch/arm/mach-omap2/clock.c b/arch/arm/mach-omap2/clock.c
index dff4eaa..0cd4761 100644
--- a/arch/arm/mach-omap2/clock.c
+++ b/arch/arm/mach-omap2/clock.c
@@ -70,6 +70,13 @@
 #define DPLL_FINT_UNDERFLOW		-1
 #define DPLL_FINT_INVALID		-2
 
+/* Bitmask to isolate the register type of clk.enable_reg */
+#define PRCM_REGTYPE_MASK		0xf0
+/* various CM register type options */
+#define CM_FCLKEN_REGTYPE		0x00
+#define CM_ICLKEN_REGTYPE		0x10
+#define CM_IDLEST_REGTYPE		0x20
+
 u8 cpu_mask;
 
 /*-------------------------------------------------------------------------
@@ -300,17 +307,18 @@ void omap2_fixed_divisor_recalc(struct clk *clk)
 
 /**
  * omap2_wait_clock_ready - wait for clock to enable
- * @reg: physical address of clock IDLEST register
+ * @prcm_mod: CM submodule offset from CM_BASE (e.g., "MPU_MOD")
+ * @reg_index: offset of CM register address from prcm_mod
  * @mask: value to mask against to determine if the clock is active
  * @name: name of the clock (for printk)
  *
  * Returns 1 if the clock enabled in time, or 0 if it failed to enable
  * in roughly MAX_CLOCK_ENABLE_WAIT microseconds.
  */
-int omap2_wait_clock_ready(void __iomem *reg, u32 mask, const char *name)
+int omap2_wait_clock_ready(s16 prcm_mod, u16 reg_index, u32 mask,
+			   const char *name)
 {
-	int i = 0;
-	int ena = 0;
+	int i = 0, ena = 0;
 
 	/*
 	 * 24xx uses 0 to indicate not ready, and 1 to indicate ready.
@@ -322,7 +330,7 @@ int omap2_wait_clock_ready(void __iomem *reg, u32 mask, const char *name)
 		ena = 0;
 
 	/* Wait for lock */
-	while (((__raw_readl(reg) & mask) != ena) &&
+	while (((cm_read_mod_reg(prcm_mod, reg_index) & mask) != ena) &&
 	       (i++ < MAX_CLOCK_ENABLE_WAIT)) {
 		udelay(1);
 	}
@@ -333,61 +341,56 @@ int omap2_wait_clock_ready(void __iomem *reg, u32 mask, const char *name)
 		printk(KERN_ERR "Clock %s didn't enable in %d tries\n",
 		       name, MAX_CLOCK_ENABLE_WAIT);
 
-
 	return (i < MAX_CLOCK_ENABLE_WAIT) ? 1 : 0;
 };
 
 
 /*
- * Note: We don't need special code here for INVERT_ENABLE
- * for the time being since INVERT_ENABLE only applies to clocks enabled by
- * CM_CLKEN_PLL
+ * omap2_clk_wait_ready - wait for a OMAP module to come out of target idle
+ * @clk: struct clk * recently enabled to indicate the module to test
+ *
+ * Wait for an OMAP module with a target idle state bit to come out of
+ * idle once both its interface clock and primary functional clock are
+ * both enabled.  Any register read or write to the device before it
+ * returns from idle will cause an abort.  Not all modules have target
+ * idle state bits (for example, DSS and CAM on OMAP24xx); so we don't
+ * wait for those.  No return value.
+ *
+ * We don't need special code here for INVERT_ENABLE for the time
+ * being since INVERT_ENABLE only applies to clocks enabled by
+ * CM_CLKEN_PLL.
+ *
+ * REVISIT: This function is misnamed: it should be something like
+ * "omap2_module_wait_ready", and in the long-term, it does not belong
+ * in the clock framework. It also shouldn't be doing register
+ * arithmetic to determine the companion clock.
  */
 static void omap2_clk_wait_ready(struct clk *clk)
 {
-	void __iomem *other_reg, *st_reg;
-	u16 reg;
-	u32 bit;
+	u16 other_reg, idlest_reg;
+	u32 other_bit;
 
-	/*
-	 * REVISIT: This code is pretty ugly.  It would be nice to generalize
-	 * it and pull it into struct clk itself somehow.
-	 */
-	reg = clk->enable_reg;
-	if (((reg & 0xff) >= CM_FCLKEN1) &&
-	    ((reg & 0xff) <= OMAP24XX_CM_FCLKEN2))
-		other_reg = (void __iomem *)((reg & ~0xf0) | 0x10); /* CM_ICLKEN* */
-	else if (((reg & 0xff) >= CM_ICLKEN1) &&
-		 ((reg & 0xff) <= OMAP24XX_CM_ICLKEN4))
-		other_reg = (void __iomem *)((reg & ~0xf0) | 0x00); /* CM_FCLKEN* */
-	else
+	if (!(clk->flags & WAIT_READY))
 		return;
 
-	/* REVISIT: What are the appropriate exclusions for 34XX? */
-	/* No check for DSS or cam clocks */
-	if (cpu_is_omap24xx() && (reg & 0x0f) == 0) { /* CM_{F,I}CLKEN1 */
-		if (clk->enable_bit == OMAP24XX_EN_DSS2_SHIFT ||
-		    clk->enable_bit == OMAP24XX_EN_DSS1_SHIFT ||
-		    clk->enable_bit == OMAP24XX_EN_CAM_SHIFT)
-			return;
-	}
+	/* If we are enabling an iclk, also test the fclk; and vice versa */
+	other_bit = 1 << clk->enable_bit;
+	other_reg = clk->enable_reg & ~PRCM_REGTYPE_MASK;
 
-	/* REVISIT: What are the appropriate exclusions for 34XX? */
-	/* OMAP3: ignore DSS-mod clocks */
-	if (cpu_is_omap34xx() &&
-	    ((reg & ~0xff) == cm_read_mod_reg(OMAP3430_DSS_MOD, 0) ||
-	     (((reg & ~0xff) == cm_read_mod_reg(CORE_MOD, 0)) &&
-	      clk->enable_bit == OMAP3430_EN_SSI_SHIFT)))
-		return;
+	if (clk->enable_reg & CM_ICLKEN_REGTYPE)
+		other_reg |= CM_FCLKEN_REGTYPE;
+	else
+		other_reg |= CM_ICLKEN_REGTYPE;
 
-	/* Check if both functional and interface clocks
-	 * are running. */
-	bit = 1 << clk->enable_bit;
-	if (!(__raw_readl(other_reg) & bit))
+	/* Ensure functional and interface clocks are running. */
+	if (!(cm_read_mod_reg(clk->prcm_mod, other_reg) & other_bit))
 		return;
-	st_reg = (void __iomem *)(((u32)other_reg & ~0xf0) | 0x20); /* CM_IDLEST* */
 
-	omap2_wait_clock_ready(st_reg, bit, clk->name);
+	idlest_reg = other_reg & ~PRCM_REGTYPE_MASK;
+	idlest_reg |= CM_IDLEST_REGTYPE;
+
+	omap2_wait_clock_ready(clk->prcm_mod, idlest_reg, 1 << clk->idlest_bit,
+			       clk->name);
 }
 
 /* Enables clock without considering parent dependencies or use count
diff --git a/arch/arm/mach-omap2/clock.h b/arch/arm/mach-omap2/clock.h
index 4dbd582..faff95e 100644
--- a/arch/arm/mach-omap2/clock.h
+++ b/arch/arm/mach-omap2/clock.h
@@ -64,7 +64,8 @@ void omap2_fixed_divisor_recalc(struct clk *clk);
 long omap2_clksel_round_rate(struct clk *clk, unsigned long target_rate);
 int omap2_clksel_set_rate(struct clk *clk, unsigned long rate);
 u32 omap2_get_dpll_rate(struct clk *clk);
-int omap2_wait_clock_ready(void __iomem *reg, u32 cval, const char *name);
+int omap2_wait_clock_ready(s16 prcm_mod, u16 idlest_reg, u32 cval,
+			   const char *name);
 void omap2_clk_prepare_for_reboot(void);
 
 extern u8 cpu_mask;
diff --git a/arch/arm/mach-omap2/clock24xx.c b/arch/arm/mach-omap2/clock24xx.c
index 2047c06..e66287f 100644
--- a/arch/arm/mach-omap2/clock24xx.c
+++ b/arch/arm/mach-omap2/clock24xx.c
@@ -107,7 +107,6 @@ static void omap2_disable_osc_ck(struct clk *clk)
 static int omap2_clk_fixed_enable(struct clk *clk)
 {
 	u32 cval, apll_mask;
-	void __iomem *idlest;
 
 	apll_mask = EN_APLL_LOCKED << clk->enable_bit;
 
@@ -125,14 +124,7 @@ static int omap2_clk_fixed_enable(struct clk *clk)
 	else if (clk == &apll54_ck)
 		cval = OMAP24XX_ST_54M_APLL;
 
-	if (cpu_is_omap242x())
-		idlest = (__force void __iomem *)OMAP2420_CM_REGADDR(PLL_MOD,
-								CM_IDLEST);
-	else
-		idlest = (__force void __iomem *)OMAP2430_CM_REGADDR(PLL_MOD,
-								CM_IDLEST);
-
-	omap2_wait_clock_ready(idlest, cval, clk->name);
+	omap2_wait_clock_ready(PLL_MOD, CM_IDLEST, cval, clk->name);
 
 	/*
 	 * REVISIT: Should we return an error code if omap2_wait_clock_ready()


