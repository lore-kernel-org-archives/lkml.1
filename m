Return-Path: <linux-kernel-owner+w=401wt.eu-S1756884AbXLFMvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884AbXLFMvj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 07:51:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754087AbXLFMnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 07:43:51 -0500
Received: from miranda.se.axis.com ([193.13.178.8]:53756 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754778AbXLFMnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 07:43:50 -0500
From: Jesper Nilsson <jesper.nilsson@axis.com>
Message-Id: <6999cf069539a388b1010d98fee14e27c8977021.1196848533.git.jesper.nilsson@axis.com>
In-Reply-To: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
References: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org
Date: Fri, 30 Nov 2007 17:20:00 +0100
Subject: [PATCH 36/47] Update CRISv32 boot/rescue/head.S code.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Add ifdef for ETRAX_AXISFLASHMAP to avoid compiling file unless it is set.
- Use assembler macros for setting up clocks.
- Don't copy image, just jump to it (only works for NOR flash)

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 arch/cris/arch-v32/boot/rescue/head.S |   42 +++++++++++---------------------
 1 files changed, 15 insertions(+), 27 deletions(-)

diff --git a/arch/cris/arch-v32/boot/rescue/head.S b/arch/cris/arch-v32/boot/rescue/head.S
index 8cdb401..5f846b7 100644
--- a/arch/cris/arch-v32/boot/rescue/head.S
+++ b/arch/cris/arch-v32/boot/rescue/head.S
@@ -1,38 +1,26 @@
-/* $Id: head.S,v 1.4 2004/11/01 16:10:28 starvik Exp $
+/*
+ * Just get started by jumping to CONFIG_ETRAX_PTABLE_SECTOR to start
+ * kernel decompressor.
+ *
+ * In practice, this only works for NOR flash (or some convoluted RAM boot)
+ * and hence is not really useful for Artpec-3, so it's Etrax FS / NOR only.
  *
- * This used to be the rescue code but now that is handled by the
- * RedBoot based RFL instead. Nothing to see here, move along.
  */
 
-#include <asm/arch/hwregs/reg_map_asm.h>
-#include <asm/arch/hwregs/config_defs_asm.h>
+#include <mach/startup.inc>
 
-	.text
+#ifdef CONFIG_ETRAX_AXISFLASHMAP
 
-	;; Start clocks for used blocks.
-	move.d REG_ADDR(config, regi_config, rw_clk_ctrl), $r1
-	move.d [$r1], $r0
-	or.d   REG_STATE(config, rw_clk_ctrl, cpu, yes) | \
-	       REG_STATE(config, rw_clk_ctrl, bif, yes) | \
-	       REG_STATE(config, rw_clk_ctrl, fix_io, yes), $r0
-	move.d $r0, [$r1]
+;; Code
 
-	;; Copy 68KB NAND flash to Internal RAM (if NAND boot)
-	move.d 0x38004000, $r10
-	move.d 0x8000, $r11
-	move.d 0x11000, $r12
-	move.d copy_complete, $r13
-	and.d  0x000fffff, $r13
-	or.d   0x38000000, $r13
+	.text
+start:
 
-#include "../../lib/nand_init.S"
+	;; Start clocks for used blocks.
+	START_CLOCKS
 
-	;; No NAND found
 	move.d	CONFIG_ETRAX_PTABLE_SECTOR, $r10
-	jump	$r10 ; Jump to decompresser
+	jump	$r10			; Jump to decompressor
 	nop
 
-copy_complete:
-	move.d	0x38000000 + CONFIG_ETRAX_PTABLE_SECTOR, $r10
-	jump	$r10 ; Jump to decompresser
-	nop
+#endif
-- 
1.5.3.6.970.gd25430

