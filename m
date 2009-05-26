Return-Path: <linux-kernel-owner+w=401wt.eu-S1758941AbZEZWXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758941AbZEZWXb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 18:23:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758709AbZEZWWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 18:22:32 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:33556 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758280AbZEZWW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 18:22:26 -0400
MBOX-Line: From nobody Tue May 26 16:12:30 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH 03/10] OMAP3 clock: add a short delay when lowering CORE clk
	rate
To: linux-arm-kernel@lists.arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
       Paul Walmsley <paul@pwsan.com>
Date: Tue, 26 May 2009 16:12:30 -0600
Message-ID: <20090526221229.25381.7079.stgit@localhost.localdomain>
In-Reply-To: <20090526220517.25381.75976.stgit@localhost.localdomain>
References: <20090526220517.25381.75976.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When changing the SDRAM clock from 166MHz to 83MHz via the CORE DPLL M2
divider, add a short delay before returning to SDRAM to allow the SDRC
time to stabilize.  Without this delay, the system is prone to random
panics upon re-entering SDRAM.

This time delay varies based on MPU frequency.  At 500MHz MPU frequency at
room temperature, 64 loops seems to work okay; so add another 32 loops for
environmental and process variation.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
---
 arch/arm/mach-omap2/clock34xx.c        |   30 ++++++++++++++++++++++++++++--
 arch/arm/mach-omap2/sram34xx.S         |   20 +++++++++-----------
 arch/arm/plat-omap/include/mach/sram.h |    4 ++--
 arch/arm/plat-omap/sram.c              |    8 +++++---
 4 files changed, 44 insertions(+), 18 deletions(-)

diff --git a/arch/arm/mach-omap2/clock34xx.c b/arch/arm/mach-omap2/clock34xx.c
index a62e326..29d0f07 100644
--- a/arch/arm/mach-omap2/clock34xx.c
+++ b/arch/arm/mach-omap2/clock34xx.c
@@ -283,6 +283,20 @@ static struct omap_clk omap34xx_clks[] = {
 
 #define MIN_SDRC_DLL_LOCK_FREQ		83000000
 
+#define CYCLES_PER_MHZ			1000000
+
+/* Scale factor for fixed-point arith in omap3_core_dpll_m2_set_rate() */
+#define SDRC_MPURATE_SCALE		8
+
+/* 2^SDRC_MPURATE_BASE_SHIFT: MPU MHz that SDRC_MPURATE_LOOPS is defined for */
+#define SDRC_MPURATE_BASE_SHIFT		9
+
+/*
+ * SDRC_MPURATE_LOOPS: Number of MPU loops to execute at
+ * 2^MPURATE_BASE_SHIFT MHz for SDRC to stabilize
+ */
+#define SDRC_MPURATE_LOOPS		96
+
 /**
  * omap3_dpll_recalc - recalculate DPLL rate
  * @clk: DPLL struct clk
@@ -706,7 +720,8 @@ static int omap3_core_dpll_m2_set_rate(struct clk *clk, unsigned long rate)
 {
 	u32 new_div = 0;
 	u32 unlock_dll = 0;
-	unsigned long validrate, sdrcrate;
+	u32 c;
+	unsigned long validrate, sdrcrate, mpurate;
 	struct omap_sdrc_params *sp;
 
 	if (!clk || !rate)
@@ -734,6 +749,17 @@ static int omap3_core_dpll_m2_set_rate(struct clk *clk, unsigned long rate)
 		unlock_dll = 1;
 	}
 
+	/*
+	 * XXX This only needs to be done when the CPU frequency changes
+	 */
+	mpurate = arm_fck.rate / CYCLES_PER_MHZ;
+	c = (mpurate << SDRC_MPURATE_SCALE) >> SDRC_MPURATE_BASE_SHIFT;
+	c += 1;  /* for safety */
+	c *= SDRC_MPURATE_LOOPS;
+	c >>= SDRC_MPURATE_SCALE;
+	if (c == 0)
+		c = 1;
+
 	pr_debug("clock: changing CORE DPLL rate from %lu to %lu\n", clk->rate,
 		 validrate);
 	pr_debug("clock: SDRC timing params used: %08x %08x %08x\n",
@@ -744,7 +770,7 @@ static int omap3_core_dpll_m2_set_rate(struct clk *clk, unsigned long rate)
 
 	/* REVISIT: Add SDRC_MR changing to this code also */
 	omap3_configure_core_dpll(sp->rfr_ctrl, sp->actim_ctrla,
-				  sp->actim_ctrlb, new_div, unlock_dll);
+				  sp->actim_ctrlb, new_div, unlock_dll, c);
 
 	return 0;
 }
diff --git a/arch/arm/mach-omap2/sram34xx.S b/arch/arm/mach-omap2/sram34xx.S
index 84781a6..8d4a88c 100644
--- a/arch/arm/mach-omap2/sram34xx.S
+++ b/arch/arm/mach-omap2/sram34xx.S
@@ -42,10 +42,14 @@
  * r0 = sdrc_rfr_ctrl r1 = sdrc_actim_ctrla r2 = sdrc_actim_ctrlb r3 = M2
  * r4 = Unlock SDRC DLL? (1 = yes, 0 = no) -- only unlock DLL for
  *      SDRC rates < 83MHz
+ * r5 = number of MPU cycles to wait for SDRC to stabilize after
+ *      reprogramming the SDRC when switching to a slower MPU speed
+ *
  */
 ENTRY(omap3_sram_configure_core_dpll)
 	stmfd	sp!, {r1-r12, lr}	@ store regs to stack
 	ldr	r4, [sp, #52]		@ pull extra args off the stack
+	ldr	r5, [sp, #56]		@ load extra args from the stack
 	dsb				@ flush buffered writes to interconnect
 	cmp	r3, #0x2
 	blne	configure_sdrc
@@ -59,7 +63,11 @@ ENTRY(omap3_sram_configure_core_dpll)
 	bleq	wait_dll_unlock
 	blne	wait_dll_lock
 	cmp	r3, #0x1
-	blne	configure_sdrc
+	beq	return_to_sdram
+	bl	configure_sdrc
+	mov	r12, r5			@ if slowing, wait for SDRC to stabilize
+	bl	wait_clk_stable
+return_to_sdram:
 	isb				@ prevent speculative exec past here
 	mov 	r0, #0 			@ return value
 	ldmfd	sp!, {r1-r12, pc}	@ restore regs and return
@@ -106,16 +114,6 @@ configure_core_dpll:
 wait_clk_stable:
 	subs 	r12, r12, #1
 	bne	wait_clk_stable
-	nop
-	nop
-	nop
-	nop
-	nop
-	nop
-	nop
-	nop
-	nop
-	nop
 	bx	lr
 enable_sdrc:
 	ldr 	r11, omap3_cm_iclken1_core
diff --git a/arch/arm/plat-omap/include/mach/sram.h b/arch/arm/plat-omap/include/mach/sram.h
index dca7c16..c32fa0a 100644
--- a/arch/arm/plat-omap/include/mach/sram.h
+++ b/arch/arm/plat-omap/include/mach/sram.h
@@ -24,7 +24,7 @@ extern u32 omap2_set_prcm(u32 dpll_ctrl_val, u32 sdrc_rfr_val, int bypass);
 extern u32 omap3_configure_core_dpll(u32 sdrc_rfr_ctrl,
 				     u32 sdrc_actim_ctrla,
 				     u32 sdrc_actim_ctrlb, u32 m2,
-				     u32 unlock_dll);
+				     u32 unlock_dll, u32 f);
 
 /* Do not use these */
 extern void omap1_sram_reprogram_clock(u32 ckctl, u32 dpllctl);
@@ -62,7 +62,7 @@ extern unsigned long omap243x_sram_reprogram_sdrc_sz;
 extern u32 omap3_sram_configure_core_dpll(u32 sdrc_rfr_ctrl,
 					  u32 sdrc_actim_ctrla,
 					  u32 sdrc_actim_ctrlb, u32 m2,
-					  u32 unlock_dll);
+					  u32 unlock_dll, u32 f);
 extern unsigned long omap3_sram_configure_core_dpll_sz;
 
 #endif
diff --git a/arch/arm/plat-omap/sram.c b/arch/arm/plat-omap/sram.c
index 876f5a7..ae3627a 100644
--- a/arch/arm/plat-omap/sram.c
+++ b/arch/arm/plat-omap/sram.c
@@ -365,9 +365,11 @@ static inline int omap243x_sram_init(void)
 static u32 (*_omap3_sram_configure_core_dpll)(u32 sdrc_rfr_ctrl,
 					      u32 sdrc_actim_ctrla,
 					      u32 sdrc_actim_ctrlb,
-					      u32 m2, u32 unlock_dll);
+					      u32 m2, u32 unlock_dll,
+					      u32 f);
 u32 omap3_configure_core_dpll(u32 sdrc_rfr_ctrl, u32 sdrc_actim_ctrla,
-			      u32 sdrc_actim_ctrlb, u32 m2, u32 unlock_dll)
+			      u32 sdrc_actim_ctrlb, u32 m2, u32 unlock_dll,
+			      u32 f)
 {
 	if (!_omap3_sram_configure_core_dpll)
 		omap_sram_error();
@@ -375,7 +377,7 @@ u32 omap3_configure_core_dpll(u32 sdrc_rfr_ctrl, u32 sdrc_actim_ctrla,
 	return _omap3_sram_configure_core_dpll(sdrc_rfr_ctrl,
 					       sdrc_actim_ctrla,
 					       sdrc_actim_ctrlb, m2,
-					       unlock_dll);
+					       unlock_dll, f);
 }
 
 /* REVISIT: Should this be same as omap34xx_sram_init() after off-idle? */


