Return-Path: <linux-kernel-owner+w=401wt.eu-S1758089AbZEMAI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758089AbZEMAI5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 20:08:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757149AbZEMAHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 20:07:44 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:56406 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756807AbZEMAHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 20:07:41 -0400
MBOX-Line: From nobody Tue May 12 18:05:18 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH 04/10] OMAP3 SRAM: clear the SDRC PWRENA bit during SDRC
	frequency change
To: linux-arm-kernel@lists.arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
       Paul Walmsley <paul@pwsan.com>
Date: Tue, 12 May 2009 18:05:18 -0600
Message-ID: <20090513000517.10349.22865.stgit@localhost.localdomain>
In-Reply-To: <20090512235713.10349.49339.stgit@localhost.localdomain>
References: <20090512235713.10349.49339.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clear the SDRC_POWER.PWRENA bit before putting the SDRAM into self-refresh
mode.  This prevents the SDRC from attempting to power off the SDRAM,
which can cause the system to hang.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
---
 arch/arm/mach-omap2/sram34xx.S |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-omap2/sram34xx.S b/arch/arm/mach-omap2/sram34xx.S
index 8d524f3..9a45415 100644
--- a/arch/arm/mach-omap2/sram34xx.S
+++ b/arch/arm/mach-omap2/sram34xx.S
@@ -77,7 +77,9 @@ lock_dll:
 sdram_in_selfrefresh:
 	ldr	r4, omap3_sdrc_power	@ read the SDRC_POWER register
 	ldr	r5, [r4]		@ read the contents of SDRC_POWER
+	mov	r9, r5			@ keep a copy of SDRC_POWER bits
 	orr 	r5, r5, #0x40		@ enable self refresh on idle req
+	bic 	r5, r5, #0x4		@ clear PWDENA
 	str 	r5, [r4]		@ write back to SDRC_POWER register
 	ldr	r5, [r4]		@ posted-write barrier for SDRC
 	ldr	r4, omap3_cm_iclken1_core	@ read the CM_ICLKEN1_CORE reg
@@ -128,10 +130,9 @@ wait_sdrc_idle1:
 	and 	r5, r5, #0x2
 	cmp	r5, #0
 	bne	wait_sdrc_idle1
+restore_sdrc_power_val:
 	ldr	r4, omap3_sdrc_power
-	ldr	r5, [r4]
-	bic 	r5, r5, #0x40
-	str 	r5, [r4]
+	str	r9, [r4]		@ restore SDRC_POWER, no barrier needed
 	bx	lr
 wait_dll_lock:
 	ldr	r4, omap3_sdrc_dlla_status


