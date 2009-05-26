Return-Path: <linux-kernel-owner+w=401wt.eu-S1759360AbZEZWYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759360AbZEZWYz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 18:24:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758765AbZEZWWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 18:22:42 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:33605 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758636AbZEZWWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 18:22:35 -0400
MBOX-Line: From nobody Tue May 26 16:12:34 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH 07/10] OMAP3: Add support for DPLL3 divisor values higher than
	2
To: linux-arm-kernel@lists.arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
       Tero Kristo <tero.kristo@nokia.com>
Date: Tue, 26 May 2009 16:12:34 -0600
Message-ID: <20090526221233.25381.29831.stgit@localhost.localdomain>
In-Reply-To: <20090526220517.25381.75976.stgit@localhost.localdomain>
References: <20090526220517.25381.75976.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tero Kristo <tero.kristo@nokia.com>

Previously only 1 and 2 was supported. This is needed for DVFS VDD2 control.

Signed-off-by: Tero Kristo <tero.kristo@nokia.com>
---
 arch/arm/mach-omap2/clock34xx.c        |    9 +++------
 arch/arm/mach-omap2/sram34xx.S         |    8 +++++---
 arch/arm/plat-omap/include/mach/sram.h |    6 ++++--
 arch/arm/plat-omap/sram.c              |    6 +++---
 4 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/arch/arm/mach-omap2/clock34xx.c b/arch/arm/mach-omap2/clock34xx.c
index 5d57047..718a557 100644
--- a/arch/arm/mach-omap2/clock34xx.c
+++ b/arch/arm/mach-omap2/clock34xx.c
@@ -736,9 +736,9 @@ static int omap3_core_dpll_m2_set_rate(struct clk *clk, unsigned long rate)
 
 	sdrcrate = sdrc_ick.rate;
 	if (rate > clk->rate)
-		sdrcrate <<= ((rate / clk->rate) - 1);
+		sdrcrate <<= ((rate / clk->rate) >> 1);
 	else
-		sdrcrate >>= ((clk->rate / rate) - 1);
+		sdrcrate >>= ((clk->rate / rate) >> 1);
 
 	sp = omap2_sdrc_get_params(sdrcrate);
 	if (!sp)
@@ -765,12 +765,9 @@ static int omap3_core_dpll_m2_set_rate(struct clk *clk, unsigned long rate)
 	pr_debug("clock: SDRC timing params used: %08x %08x %08x\n",
 		 sp->rfr_ctrl, sp->actim_ctrla, sp->actim_ctrlb);
 
-	/* REVISIT: SRAM code doesn't support other M2 divisors yet */
-	WARN_ON(new_div != 1 && new_div != 2);
-
 	omap3_configure_core_dpll(sp->rfr_ctrl, sp->actim_ctrla,
 				  sp->actim_ctrlb, new_div, unlock_dll, c,
-				  sp->mr);
+				  sp->mr, rate > clk->rate);
 
 	return 0;
 }
diff --git a/arch/arm/mach-omap2/sram34xx.S b/arch/arm/mach-omap2/sram34xx.S
index 16eb4ef..487fa86 100644
--- a/arch/arm/mach-omap2/sram34xx.S
+++ b/arch/arm/mach-omap2/sram34xx.S
@@ -70,6 +70,7 @@
  * r5 = number of MPU cycles to wait for SDRC to stabilize after
  *      reprogramming the SDRC when switching to a slower MPU speed
  * r6 = new SDRC_MR_0 register value
+ * r7 = increasing SDRC rate? (1 = yes, 0 = no)
  *
  */
 ENTRY(omap3_sram_configure_core_dpll)
@@ -77,9 +78,10 @@ ENTRY(omap3_sram_configure_core_dpll)
 	ldr	r4, [sp, #52]		@ pull extra args off the stack
 	ldr	r5, [sp, #56]		@ load extra args from the stack
 	ldr	r6, [sp, #60]		@ load extra args from the stack
+	ldr	r7, [sp, #64]		@ load extra args from the stack
 	dsb				@ flush buffered writes to interconnect
-	cmp	r3, #0x2		@ if increasing SDRC clk rate,
-	blne	configure_sdrc		@ program the SDRC regs early (for RFR)
+	cmp	r7, #1			@ if increasing SDRC clk rate,
+	bleq	configure_sdrc		@ program the SDRC regs early (for RFR)
 	cmp	r4, #SDRC_UNLOCK_DLL	@ set the intended DLL state
 	bleq	unlock_dll
 	blne	lock_dll
@@ -89,7 +91,7 @@ ENTRY(omap3_sram_configure_core_dpll)
 	cmp	r4, #SDRC_UNLOCK_DLL	@ wait for DLL status to change
 	bleq	wait_dll_unlock
 	blne	wait_dll_lock
-	cmp	r3, #0x1		@ if increasing SDRC clk rate,
+	cmp	r7, #1			@ if increasing SDRC clk rate,
 	beq	return_to_sdram		@ return to SDRAM code, otherwise,
 	bl	configure_sdrc		@ reprogram SDRC regs now
 	mov	r12, r5
diff --git a/arch/arm/plat-omap/include/mach/sram.h b/arch/arm/plat-omap/include/mach/sram.h
index 4f87056..4d53cc5 100644
--- a/arch/arm/plat-omap/include/mach/sram.h
+++ b/arch/arm/plat-omap/include/mach/sram.h
@@ -24,7 +24,8 @@ extern u32 omap2_set_prcm(u32 dpll_ctrl_val, u32 sdrc_rfr_val, int bypass);
 extern u32 omap3_configure_core_dpll(u32 sdrc_rfr_ctrl,
 				     u32 sdrc_actim_ctrla,
 				     u32 sdrc_actim_ctrlb, u32 m2,
-				     u32 unlock_dll, u32 f, u32 sdrc_mr);
+				     u32 unlock_dll, u32 f, u32 sdrc_mr,
+				     u32 inc);
 
 /* Do not use these */
 extern void omap1_sram_reprogram_clock(u32 ckctl, u32 dpllctl);
@@ -62,7 +63,8 @@ extern unsigned long omap243x_sram_reprogram_sdrc_sz;
 extern u32 omap3_sram_configure_core_dpll(u32 sdrc_rfr_ctrl,
 					  u32 sdrc_actim_ctrla,
 					  u32 sdrc_actim_ctrlb, u32 m2,
-					  u32 unlock_dll, u32 f, u32 sdrc_mr);
+					  u32 unlock_dll, u32 f, u32 sdrc_mr,
+					  u32 inc);
 extern unsigned long omap3_sram_configure_core_dpll_sz;
 
 #endif
diff --git a/arch/arm/plat-omap/sram.c b/arch/arm/plat-omap/sram.c
index 81048b3..8ee6cc9 100644
--- a/arch/arm/plat-omap/sram.c
+++ b/arch/arm/plat-omap/sram.c
@@ -366,10 +366,10 @@ static u32 (*_omap3_sram_configure_core_dpll)(u32 sdrc_rfr_ctrl,
 					      u32 sdrc_actim_ctrla,
 					      u32 sdrc_actim_ctrlb,
 					      u32 m2, u32 unlock_dll,
-					      u32 f, u32 sdrc_mr);
+					      u32 f, u32 sdrc_mr, u32 inc);
 u32 omap3_configure_core_dpll(u32 sdrc_rfr_ctrl, u32 sdrc_actim_ctrla,
 			      u32 sdrc_actim_ctrlb, u32 m2, u32 unlock_dll,
-			      u32 f, u32 sdrc_mr)
+			      u32 f, u32 sdrc_mr, u32 inc)
 {
 	if (!_omap3_sram_configure_core_dpll)
 		omap_sram_error();
@@ -377,7 +377,7 @@ u32 omap3_configure_core_dpll(u32 sdrc_rfr_ctrl, u32 sdrc_actim_ctrla,
 	return _omap3_sram_configure_core_dpll(sdrc_rfr_ctrl,
 					       sdrc_actim_ctrla,
 					       sdrc_actim_ctrlb, m2,
-					       unlock_dll, f, sdrc_mr);
+					       unlock_dll, f, sdrc_mr, inc);
 }
 
 /* REVISIT: Should this be same as omap34xx_sram_init() after off-idle? */


