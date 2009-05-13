Return-Path: <linux-kernel-owner+w=401wt.eu-S1757989AbZEMAIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757989AbZEMAIk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 20:08:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757435AbZEMAHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 20:07:43 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:56394 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755632AbZEMAHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 20:07:39 -0400
MBOX-Line: From nobody Tue May 12 18:05:17 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH 03/10] OMAP3 clock: add interconnect barriers to CORE DPLL M2
	change
To: linux-arm-kernel@lists.arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
       Paul Walmsley <paul@pwsan.com>
Date: Tue, 12 May 2009 18:05:17 -0600
Message-ID: <20090513000516.10349.74452.stgit@localhost.localdomain>
In-Reply-To: <20090512235713.10349.49339.stgit@localhost.localdomain>
References: <20090512235713.10349.49339.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Where necessary, add interconnect barriers to force posted writes to
complete before continuing.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
---
 arch/arm/mach-omap2/sram34xx.S |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-omap2/sram34xx.S b/arch/arm/mach-omap2/sram34xx.S
index f4a356d..8d524f3 100644
--- a/arch/arm/mach-omap2/sram34xx.S
+++ b/arch/arm/mach-omap2/sram34xx.S
@@ -66,22 +66,23 @@ unlock_dll:
 	ldr	r4, omap3_sdrc_dlla_ctrl
 	ldr	r5, [r4]
 	orr	r5, r5, #0x4
-	str	r5, [r4]
+	str	r5, [r4]		@ (no OCP barrier needed)
 	bx	lr
 lock_dll:
 	ldr	r4, omap3_sdrc_dlla_ctrl
 	ldr	r5, [r4]
 	bic	r5, r5, #0x4
-	str	r5, [r4]
+	str	r5, [r4]		@ (no OCP barrier needed)
 	bx	lr
 sdram_in_selfrefresh:
 	ldr	r4, omap3_sdrc_power	@ read the SDRC_POWER register
 	ldr	r5, [r4]		@ read the contents of SDRC_POWER
 	orr 	r5, r5, #0x40		@ enable self refresh on idle req
 	str 	r5, [r4]		@ write back to SDRC_POWER register
+	ldr	r5, [r4]		@ posted-write barrier for SDRC
 	ldr	r4, omap3_cm_iclken1_core	@ read the CM_ICLKEN1_CORE reg
 	ldr	r5, [r4]
-	bic	r5, r5, #0x2		@ disable iclk bit for SRDC
+	bic	r5, r5, #0x2		@ disable iclk bit for SDRC
 	str 	r5, [r4]
 wait_sdrc_idle:
 	ldr 	r4, omap3_cm_idlest1_core
@@ -97,6 +98,7 @@ configure_core_dpll:
 	and	r5, r5, r6
 	orr	r5, r5, r3, lsl #0x1B	@ r3 contains the M2 val
 	str	r5, [r4]
+	ldr	r5, [r4]		@ posted-write barrier for CM
 	mov 	r5, #0x800		@ wait for the clock to stabilise
 	cmp	r3, #2
 	bne	wait_clk_stable
@@ -152,6 +154,7 @@ configure_sdrc:
 	str	r1, [r4]
 	ldr	r4, omap3_sdrc_actim_ctrlb
 	str	r2, [r4]
+	ldr	r2, [r4]		@ posted-write barrier for SDRC
 	bx	lr
 
 omap3_sdrc_power:


