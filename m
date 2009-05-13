Return-Path: <linux-kernel-owner+w=401wt.eu-S1758265AbZEMAJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758265AbZEMAJl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 20:09:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757697AbZEMAHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 20:07:46 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:56413 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757376AbZEMAHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 20:07:42 -0400
MBOX-Line: From nobody Tue May 12 18:05:22 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH 07/10] OMAP3 clock: only unlock SDRC DLL if SDRC clk < 83MHz
To: linux-arm-kernel@lists.arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
       Paul Walmsley <paul@pwsan.com>
Date: Tue, 12 May 2009 18:05:22 -0600
Message-ID: <20090513000521.10349.91810.stgit@localhost.localdomain>
In-Reply-To: <20090512235713.10349.49339.stgit@localhost.localdomain>
References: <20090512235713.10349.49339.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the 34xx TRM Rev. K section 11.2.4.4.11.1 "Purpose of the
DLL/CDL Module," the SDRC delay-locked-loop can be locked at any SDRC
clock frequency from 83MHz to 166MHz.  CDP code unconditionally
unlocked the DLL whenever shifting to a lower SDRC speed, but this
seems unnecessary and error-prone, as the DLL is no longer able to
compensate for process, voltage, and temperature variations.  Instead,
only unlock the DLL when the SDRC clock rate would be less than 83MHz.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
---
 arch/arm/mach-omap2/clock34xx.c        |   10 +++++++++-
 arch/arm/mach-omap2/sram34xx.S         |   13 +++++++------
 arch/arm/plat-omap/include/mach/sram.h |    6 ++++--
 arch/arm/plat-omap/sram.c              |    7 ++++---
 4 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/arch/arm/mach-omap2/clock34xx.c b/arch/arm/mach-omap2/clock34xx.c
index 0a14dca..811360a 100644
--- a/arch/arm/mach-omap2/clock34xx.c
+++ b/arch/arm/mach-omap2/clock34xx.c
@@ -281,6 +281,8 @@ static struct omap_clk omap34xx_clks[] = {
 
 #define MAX_DPLL_WAIT_TRIES		1000000
 
+#define MIN_SDRC_DLL_LOCK_FREQ		83000000
+
 /**
  * omap3_dpll_recalc - recalculate DPLL rate
  * @clk: DPLL struct clk
@@ -703,6 +705,7 @@ static int omap3_dpll4_set_rate(struct clk *clk, unsigned long rate)
 static int omap3_core_dpll_m2_set_rate(struct clk *clk, unsigned long rate)
 {
 	u32 new_div = 0;
+	u32 unlock_dll = 0;
 	unsigned long validrate, sdrcrate;
 	struct omap_sdrc_params *sp;
 
@@ -729,6 +732,11 @@ static int omap3_core_dpll_m2_set_rate(struct clk *clk, unsigned long rate)
 	if (!sp)
 		return -EINVAL;
 
+	if (sdrcrate < MIN_SDRC_DLL_LOCK_FREQ) {
+		pr_debug("clock: will unlock SDRC DLL\n");
+		unlock_dll = 1;
+	}
+
 	pr_info("clock: changing CORE DPLL rate from %lu to %lu\n", clk->rate,
 		validrate);
 	pr_info("clock: SDRC timing params used: %08x %08x %08x\n",
@@ -739,7 +747,7 @@ static int omap3_core_dpll_m2_set_rate(struct clk *clk, unsigned long rate)
 
 	/* REVISIT: Add SDRC_MR changing to this code also */
 	omap3_configure_core_dpll(sp->rfr_ctrl, sp->actim_ctrla,
-				  sp->actim_ctrlb, new_div);
+				  sp->actim_ctrlb, new_div, unlock_dll);
 
 	return 0;
 }
diff --git a/arch/arm/mach-omap2/sram34xx.S b/arch/arm/mach-omap2/sram34xx.S
index 35131e5..c080c82 100644
--- a/arch/arm/mach-omap2/sram34xx.S
+++ b/arch/arm/mach-omap2/sram34xx.S
@@ -40,22 +40,23 @@
 /*
  * Change frequency of core dpll
  * r0 = sdrc_rfr_ctrl r1 = sdrc_actim_ctrla r2 = sdrc_actim_ctrlb r3 = M2
+ * r4 = Unlock SDRC DLL? (1 = yes, 0 = no) -- only unlock DLL for
+ *      SDRC rates < 83MHz
  */
 ENTRY(omap3_sram_configure_core_dpll)
 	stmfd	sp!, {r1-r12, lr}	@ store regs to stack
+	ldr	r4, [sp, #52]		@ pull extra args off the stack
 	dsb				@ flush buffered writes to interconnect
 	cmp	r3, #0x2
 	blne	configure_sdrc
-	cmp	r3, #0x2
+	cmp	r4, #0x1
+	bleq	unlock_dll
 	blne	lock_dll
-	cmp	r3, #0x1
-	blne	unlock_dll
 	bl	sdram_in_selfrefresh	@ put the SDRAM in self refresh
 	bl 	configure_core_dpll
 	bl	enable_sdrc
-	cmp	r3, #0x1
-	blne	wait_dll_unlock
-	cmp	r3, #0x2
+	cmp	r4, #0x1
+	bleq	wait_dll_unlock
 	blne	wait_dll_lock
 	cmp	r3, #0x1
 	blne	configure_sdrc
diff --git a/arch/arm/plat-omap/include/mach/sram.h b/arch/arm/plat-omap/include/mach/sram.h
index ab35d62..dca7c16 100644
--- a/arch/arm/plat-omap/include/mach/sram.h
+++ b/arch/arm/plat-omap/include/mach/sram.h
@@ -23,7 +23,8 @@ extern u32 omap2_set_prcm(u32 dpll_ctrl_val, u32 sdrc_rfr_val, int bypass);
 
 extern u32 omap3_configure_core_dpll(u32 sdrc_rfr_ctrl,
 				     u32 sdrc_actim_ctrla,
-				     u32 sdrc_actim_ctrlb, u32 m2);
+				     u32 sdrc_actim_ctrlb, u32 m2,
+				     u32 unlock_dll);
 
 /* Do not use these */
 extern void omap1_sram_reprogram_clock(u32 ckctl, u32 dpllctl);
@@ -60,7 +61,8 @@ extern unsigned long omap243x_sram_reprogram_sdrc_sz;
 
 extern u32 omap3_sram_configure_core_dpll(u32 sdrc_rfr_ctrl,
 					  u32 sdrc_actim_ctrla,
-					  u32 sdrc_actim_ctrlb, u32 m2);
+					  u32 sdrc_actim_ctrlb, u32 m2,
+					  u32 unlock_dll);
 extern unsigned long omap3_sram_configure_core_dpll_sz;
 
 #endif
diff --git a/arch/arm/plat-omap/sram.c b/arch/arm/plat-omap/sram.c
index 3835338..876f5a7 100644
--- a/arch/arm/plat-omap/sram.c
+++ b/arch/arm/plat-omap/sram.c
@@ -365,16 +365,17 @@ static inline int omap243x_sram_init(void)
 static u32 (*_omap3_sram_configure_core_dpll)(u32 sdrc_rfr_ctrl,
 					      u32 sdrc_actim_ctrla,
 					      u32 sdrc_actim_ctrlb,
-					      u32 m2);
+					      u32 m2, u32 unlock_dll);
 u32 omap3_configure_core_dpll(u32 sdrc_rfr_ctrl, u32 sdrc_actim_ctrla,
-			      u32 sdrc_actim_ctrlb, u32 m2)
+			      u32 sdrc_actim_ctrlb, u32 m2, u32 unlock_dll)
 {
 	if (!_omap3_sram_configure_core_dpll)
 		omap_sram_error();
 
 	return _omap3_sram_configure_core_dpll(sdrc_rfr_ctrl,
 					       sdrc_actim_ctrla,
-					       sdrc_actim_ctrlb, m2);
+					       sdrc_actim_ctrlb, m2,
+					       unlock_dll);
 }
 
 /* REVISIT: Should this be same as omap34xx_sram_init() after off-idle? */


