Return-Path: <linux-kernel-owner+w=401wt.eu-S1758965AbZEZWXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758965AbZEZWXz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 18:23:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758726AbZEZWWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 18:22:35 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:33579 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758584AbZEZWW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 18:22:29 -0400
MBOX-Line: From nobody Tue May 26 16:12:32 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH 05/10] OMAP3 SRAM: add more comments on the SRAM code
To: linux-arm-kernel@lists.arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
       Paul Walmsley <paul@pwsan.com>
Date: Tue, 26 May 2009 16:12:32 -0600
Message-ID: <20090526221231.25381.64174.stgit@localhost.localdomain>
In-Reply-To: <20090526220517.25381.75976.stgit@localhost.localdomain>
References: <20090526220517.25381.75976.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up comments and copyrights on the CORE DPLL3 M2 divider change code.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
---
 arch/arm/mach-omap2/sram34xx.S |   45 +++++++++++++++++++++-------------------
 1 files changed, 24 insertions(+), 21 deletions(-)

diff --git a/arch/arm/mach-omap2/sram34xx.S b/arch/arm/mach-omap2/sram34xx.S
index d13f1cc..37a1e1f 100644
--- a/arch/arm/mach-omap2/sram34xx.S
+++ b/arch/arm/mach-omap2/sram34xx.S
@@ -3,13 +3,12 @@
  *
  * Omap3 specific functions that need to be run in internal SRAM
  *
- * (C) Copyright 2007
- * Texas Instruments Inc.
- * Rajendra Nayak <rnayak@ti.com>
+ * Copyright (C) 2004, 2007, 2008 Texas Instruments, Inc.
+ * Copyright (C) 2008 Nokia Corporation
  *
- * (C) Copyright 2004
- * Texas Instruments, <www.ti.com>
+ * Rajendra Nayak <rnayak@ti.com>
  * Richard Woodruff <r-woodruff2@ti.com>
+ * Paul Walmsley
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License as
@@ -38,13 +37,16 @@
 	.text
 
 /*
- * Change frequency of core dpll
- * r0 = sdrc_rfr_ctrl r1 = sdrc_actim_ctrla r2 = sdrc_actim_ctrlb r3 = M2
- * r4 = Unlock SDRC DLL? (1 = yes, 0 = no) -- only unlock DLL for
+ * omap3_sram_configure_core_dpll - change DPLL3 M2 divider
+ * r0 = new SDRC_RFR_CTRL register contents
+ * r1 = new SDRC_ACTIM_CTRLA register contents
+ * r2 = new SDRC_ACTIM_CTRLB register contents
+ * r3 = new M2 divider setting (only 1 and 2 supported right now)
+ * r4 = unlock SDRC DLL? (1 = yes, 0 = no).  Only unlock DLL for
  *      SDRC rates < 83MHz
  * r5 = number of MPU cycles to wait for SDRC to stabilize after
  *      reprogramming the SDRC when switching to a slower MPU speed
- * r6 = SDRC_MR_0 register value
+ * r6 = new SDRC_MR_0 register value
  *
  */
 ENTRY(omap3_sram_configure_core_dpll)
@@ -53,22 +55,22 @@ ENTRY(omap3_sram_configure_core_dpll)
 	ldr	r5, [sp, #56]		@ load extra args from the stack
 	ldr	r6, [sp, #60]		@ load extra args from the stack
 	dsb				@ flush buffered writes to interconnect
-	cmp	r3, #0x2
-	blne	configure_sdrc
-	cmp	r4, #0x1
+	cmp	r3, #0x2		@ if increasing SDRC clk rate,
+	blne	configure_sdrc		@ program the SDRC regs early (for RFR)
+	cmp	r4, #0x1		@ set the intended DLL state
 	bleq	unlock_dll
 	blne	lock_dll
-	bl	sdram_in_selfrefresh	@ put the SDRAM in self refresh
-	bl 	configure_core_dpll
-	bl	enable_sdrc
-	cmp	r4, #0x1
+	bl	sdram_in_selfrefresh	@ put SDRAM in self refresh, idle SDRC
+	bl 	configure_core_dpll	@ change the DPLL3 M2 divider
+	bl	enable_sdrc		@ take SDRC out of idle
+	cmp	r4, #0x1		@ wait for DLL status to change
 	bleq	wait_dll_unlock
 	blne	wait_dll_lock
-	cmp	r3, #0x1
-	beq	return_to_sdram
-	bl	configure_sdrc
-	mov	r12, r5			@ if slowing, wait for SDRC to stabilize
-	bl	wait_clk_stable
+	cmp	r3, #0x1		@ if increasing SDRC clk rate,
+	beq	return_to_sdram		@ return to SDRAM code, otherwise,
+	bl	configure_sdrc		@ reprogram SDRC regs now
+	mov	r12, r5
+	bl	wait_clk_stable		@ wait for SDRC to stabilize
 return_to_sdram:
 	isb				@ prevent speculative exec past here
 	mov 	r0, #0 			@ return value
@@ -93,6 +95,7 @@ sdram_in_selfrefresh:
 	bic 	r12, r12, #0x4		@ clear PWDENA
 	str 	r12, [r11]		@ write back to SDRC_POWER register
 	ldr	r12, [r11]		@ posted-write barrier for SDRC
+idle_sdrc:
 	ldr	r11, omap3_cm_iclken1_core	@ read the CM_ICLKEN1_CORE reg
 	ldr	r12, [r11]
 	bic	r12, r12, #0x2		@ disable iclk bit for SDRC


