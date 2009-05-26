Return-Path: <linux-kernel-owner+w=401wt.eu-S1757487AbZEZWXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487AbZEZWXn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 18:23:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758711AbZEZWWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 18:22:33 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:33565 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757987AbZEZWW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 18:22:27 -0400
MBOX-Line: From nobody Tue May 26 16:12:31 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH 04/10] OMAP3 clock/SDRC: program SDRC_MR register during SDRC
	clock change
To: linux-arm-kernel@lists.arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
       Paul Walmsley <paul@pwsan.com>
Date: Tue, 26 May 2009 16:12:31 -0600
Message-ID: <20090526221230.25381.60924.stgit@localhost.localdomain>
In-Reply-To: <20090526220517.25381.75976.stgit@localhost.localdomain>
References: <20090526220517.25381.75976.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Program the SDRC_MR_0 register as well during SDRC clock changes.
This register allows selection of the memory CAS latency.  Some SDRAM
chips, such as the Qimonda HYB18M512160AF6, have a lower CAS latency
at lower clock rates.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
---
 arch/arm/mach-omap2/clock34xx.c        |    4 ++--
 arch/arm/mach-omap2/sram34xx.S         |    8 +++++++-
 arch/arm/plat-omap/include/mach/sram.h |    4 ++--
 arch/arm/plat-omap/sram.c              |    6 +++---
 4 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mach-omap2/clock34xx.c b/arch/arm/mach-omap2/clock34xx.c
index 29d0f07..5d57047 100644
--- a/arch/arm/mach-omap2/clock34xx.c
+++ b/arch/arm/mach-omap2/clock34xx.c
@@ -768,9 +768,9 @@ static int omap3_core_dpll_m2_set_rate(struct clk *clk, unsigned long rate)
 	/* REVISIT: SRAM code doesn't support other M2 divisors yet */
 	WARN_ON(new_div != 1 && new_div != 2);
 
-	/* REVISIT: Add SDRC_MR changing to this code also */
 	omap3_configure_core_dpll(sp->rfr_ctrl, sp->actim_ctrla,
-				  sp->actim_ctrlb, new_div, unlock_dll, c);
+				  sp->actim_ctrlb, new_div, unlock_dll, c,
+				  sp->mr);
 
 	return 0;
 }
diff --git a/arch/arm/mach-omap2/sram34xx.S b/arch/arm/mach-omap2/sram34xx.S
index 8d4a88c..d13f1cc 100644
--- a/arch/arm/mach-omap2/sram34xx.S
+++ b/arch/arm/mach-omap2/sram34xx.S
@@ -44,12 +44,14 @@
  *      SDRC rates < 83MHz
  * r5 = number of MPU cycles to wait for SDRC to stabilize after
  *      reprogramming the SDRC when switching to a slower MPU speed
+ * r6 = SDRC_MR_0 register value
  *
  */
 ENTRY(omap3_sram_configure_core_dpll)
 	stmfd	sp!, {r1-r12, lr}	@ store regs to stack
 	ldr	r4, [sp, #52]		@ pull extra args off the stack
 	ldr	r5, [sp, #56]		@ load extra args from the stack
+	ldr	r6, [sp, #60]		@ load extra args from the stack
 	dsb				@ flush buffered writes to interconnect
 	cmp	r3, #0x2
 	blne	configure_sdrc
@@ -151,7 +153,9 @@ configure_sdrc:
 	str	r1, [r11]
 	ldr	r11, omap3_sdrc_actim_ctrlb
 	str	r2, [r11]
-	ldr	r2, [r11]		@ posted-write barrier for SDRC
+	ldr	r11, omap3_sdrc_mr_0
+	str	r6, [r11]
+	ldr	r6, [r11]		@ posted-write barrier for SDRC
 	bx	lr
 
 omap3_sdrc_power:
@@ -168,6 +172,8 @@ omap3_sdrc_actim_ctrla:
 	.word OMAP34XX_SDRC_REGADDR(SDRC_ACTIM_CTRL_A_0)
 omap3_sdrc_actim_ctrlb:
 	.word OMAP34XX_SDRC_REGADDR(SDRC_ACTIM_CTRL_B_0)
+omap3_sdrc_mr_0:
+	.word OMAP34XX_SDRC_REGADDR(SDRC_MR_0)
 omap3_sdrc_dlla_status:
 	.word OMAP34XX_SDRC_REGADDR(SDRC_DLLA_STATUS)
 omap3_sdrc_dlla_ctrl:
diff --git a/arch/arm/plat-omap/include/mach/sram.h b/arch/arm/plat-omap/include/mach/sram.h
index c32fa0a..4f87056 100644
--- a/arch/arm/plat-omap/include/mach/sram.h
+++ b/arch/arm/plat-omap/include/mach/sram.h
@@ -24,7 +24,7 @@ extern u32 omap2_set_prcm(u32 dpll_ctrl_val, u32 sdrc_rfr_val, int bypass);
 extern u32 omap3_configure_core_dpll(u32 sdrc_rfr_ctrl,
 				     u32 sdrc_actim_ctrla,
 				     u32 sdrc_actim_ctrlb, u32 m2,
-				     u32 unlock_dll, u32 f);
+				     u32 unlock_dll, u32 f, u32 sdrc_mr);
 
 /* Do not use these */
 extern void omap1_sram_reprogram_clock(u32 ckctl, u32 dpllctl);
@@ -62,7 +62,7 @@ extern unsigned long omap243x_sram_reprogram_sdrc_sz;
 extern u32 omap3_sram_configure_core_dpll(u32 sdrc_rfr_ctrl,
 					  u32 sdrc_actim_ctrla,
 					  u32 sdrc_actim_ctrlb, u32 m2,
-					  u32 unlock_dll, u32 f);
+					  u32 unlock_dll, u32 f, u32 sdrc_mr);
 extern unsigned long omap3_sram_configure_core_dpll_sz;
 
 #endif
diff --git a/arch/arm/plat-omap/sram.c b/arch/arm/plat-omap/sram.c
index ae3627a..81048b3 100644
--- a/arch/arm/plat-omap/sram.c
+++ b/arch/arm/plat-omap/sram.c
@@ -366,10 +366,10 @@ static u32 (*_omap3_sram_configure_core_dpll)(u32 sdrc_rfr_ctrl,
 					      u32 sdrc_actim_ctrla,
 					      u32 sdrc_actim_ctrlb,
 					      u32 m2, u32 unlock_dll,
-					      u32 f);
+					      u32 f, u32 sdrc_mr);
 u32 omap3_configure_core_dpll(u32 sdrc_rfr_ctrl, u32 sdrc_actim_ctrla,
 			      u32 sdrc_actim_ctrlb, u32 m2, u32 unlock_dll,
-			      u32 f)
+			      u32 f, u32 sdrc_mr)
 {
 	if (!_omap3_sram_configure_core_dpll)
 		omap_sram_error();
@@ -377,7 +377,7 @@ u32 omap3_configure_core_dpll(u32 sdrc_rfr_ctrl, u32 sdrc_actim_ctrla,
 	return _omap3_sram_configure_core_dpll(sdrc_rfr_ctrl,
 					       sdrc_actim_ctrla,
 					       sdrc_actim_ctrlb, m2,
-					       unlock_dll, f);
+					       unlock_dll, f, sdrc_mr);
 }
 
 /* REVISIT: Should this be same as omap34xx_sram_init() after off-idle? */


