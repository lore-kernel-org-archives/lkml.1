Return-Path: <linux-kernel-owner+w=401wt.eu-S1757317AbXLFMxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317AbXLFMxU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 07:53:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754979AbXLFMoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 07:44:08 -0500
Received: from miranda.se.axis.com ([193.13.178.8]:53760 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120AbXLFMoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 07:44:05 -0500
From: Jesper Nilsson <jesper.nilsson@axis.com>
Message-Id: <35ac274d6b916c0e534e01d3dccd505b8f8318da.1196848533.git.jesper.nilsson@axis.com>
In-Reply-To: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
References: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org
Date: Fri, 30 Nov 2007 16:40:26 +0100
Subject: [PATCH 34/47] Update CRISv32 compressed head.S
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Fixes for NAND and NOR flash booting.
- Use assembler macros for common tasks (clocks, general io etc)
- Use (EtraxFS or Artpec-3) machine specific include for dram and hardware init.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 arch/cris/arch-v32/boot/compressed/head.S |  137 ++++++++--------------------
 1 files changed, 39 insertions(+), 98 deletions(-)

diff --git a/arch/cris/arch-v32/boot/compressed/head.S b/arch/cris/arch-v32/boot/compressed/head.S
index 34cea10..f86208c 100644
--- a/arch/cris/arch-v32/boot/compressed/head.S
+++ b/arch/cris/arch-v32/boot/compressed/head.S
@@ -2,13 +2,12 @@
  *  Code that sets up the DRAM registers, calls the
  *  decompressor to unpack the piggybacked kernel, and jumps.
  *
- *  Copyright (C) 1999 - 2003, Axis Communications AB
+ *  Copyright (C) 1999 - 2006, Axis Communications AB
  */
 
 #define ASSEMBLER_MACROS_ONLY
-#include <asm/arch/hwregs/asm/reg_map_asm.h>
-#include <asm/arch/hwregs/asm/gio_defs_asm.h>
-#include <asm/arch/hwregs/asm/config_defs_asm.h>
+#include <hwregs/asm/reg_map_asm.h>
+#include <asm/arch/mach/startup.inc>
 
 #define RAM_INIT_MAGIC 0x56902387
 #define COMMAND_LINE_MAGIC 0x87109563
@@ -22,114 +21,49 @@ start:
 	di
 
 	;; Start clocks for used blocks.
-	move.d REG_ADDR(config, regi_config, rw_clk_ctrl), $r1
-	move.d [$r1], $r0
-	or.d   REG_STATE(config, rw_clk_ctrl, cpu, yes) | \
-	       REG_STATE(config, rw_clk_ctrl, bif, yes) | \
-	       REG_STATE(config, rw_clk_ctrl, fix_io, yes), $r0
-	move.d $r0, [$r1]
-
-	;; If booting from NAND flash we first have to copy some
-	;; data from NAND flash to internal RAM to get the code
-	;; that initializes the SDRAM. Lets copy 20 KB. This
-	;; code executes at 0x38010000 if booting from NAND and
-	;; we are guaranted that at least 0x200 bytes are good so
-	;; lets start from there. The first 8192 bytes in the nand
-	;; flash is spliced with zeroes and is thus 16384 bytes.
-	move.d 0x38010200, $r10
-	move.d 0x14200, $r11	; Start offset in NAND flash 0x10200 + 16384
-	move.d 0x5000, $r12	; Length of copy
-
-	;; Before this code the tools add a partitiontable so the PC
-	;; has an offset from the linked address.
-offset1:
-	lapcq  ., $r13		; get PC
-	add.d	first_copy_complete-offset1, $r13
-
-#include "../../lib/nand_init.S"
-
-first_copy_complete:
-	;; Initialze the DRAM registers.
+	START_CLOCKS
+
+	;; Initialize the DRAM registers.
 	cmp.d	RAM_INIT_MAGIC, $r8	; Already initialized?
 	beq	dram_init_finished
 	nop
 
-#include "../../lib/dram_init.S"
+#include "../../mach/dram_init.S"
 
 dram_init_finished:
-	lapcq  ., $r13		; get PC
-	add.d	second_copy_complete-dram_init_finished, $r13
-
-	move.d REG_ADDR(config, regi_config, r_bootsel), $r0
-	move.d [$r0], $r0
-	and.d  REG_MASK(config, r_bootsel, boot_mode), $r0
-	cmp.d  REG_STATE(config, r_bootsel, boot_mode, nand), $r0
-	bne second_copy_complete ; No NAND boot
-	nop
-
-	;; Copy 2MB from NAND flash to SDRAM (at 2-4MB into the SDRAM)
-	move.d 0x40204000, $r10
-	move.d 0x8000, $r11
-	move.d 0x200000, $r12
-	ba copy_nand_to_ram
-	nop
-second_copy_complete:
-
-	;; Initiate the PA port.
-	move.d	CONFIG_ETRAX_DEF_GIO_PA_OUT, $r0
-	move.d	REG_ADDR(gio, regi_gio, rw_pa_dout), $r1
-	move.d	$r0, [$r1]
-
-	move.d	CONFIG_ETRAX_DEF_GIO_PA_OE, $r0
-	move.d	REG_ADDR(gio, regi_gio, rw_pa_oe), $r1
-	move.d	$r0, [$r1]
 
+	GIO_INIT
 	;; Setup the stack to a suitably high address.
 	;; We assume 8 MB is the minimum DRAM and put
 	;; the SP at the top for now.
 
 	move.d	0x40800000, $sp
 
-	;; Figure out where the compressed piggyback image is
-	;; in the flash (since we wont try to copy it to DRAM
-	;; before unpacking). It is at _edata, but in flash.
+	;; Figure out where the compressed piggyback image is.
+	;; It is either in [NOR] flash (we don't want to copy it
+	;; to DRAM before unpacking), or copied to DRAM
+	;; by the [NAND] flash boot loader.
+	;; The piggyback image is at _edata, but relative to where the
+	;; image is actually located in memory, not where it is linked
+	;; (the decompressor is linked at 0x40700000+ and runs there).
 	;; Use (_edata - herami) as offset to the current PC.
 
-	move.d REG_ADDR(config, regi_config, r_bootsel), $r0
-	move.d [$r0], $r0
-	and.d  REG_MASK(config, r_bootsel, boot_mode), $r0
-	cmp.d  REG_STATE(config, r_bootsel, boot_mode, nand), $r0
-	beq hereami2
-	nop
 hereami:
 	lapcq	., $r5		; get PC
 	and.d	0x7fffffff, $r5	; strip any non-cache bit
-	move.d	$r5, $r0	; save for later - flash address of 'herami'
+	move.d	$r5, $r0	; source address of 'herami'
 	add.d	_edata, $r5
 	sub.d	hereami, $r5	; r5 = flash address of '_edata'
 	move.d	hereami, $r1	; destination
-	ba 2f
-	nop
-hereami2:
-	lapcq	., $r5		; get PC
-	and.d	0x00ffffff, $r5	; strip any non-cache bit
-	move.d  $r5, $r6
-	or.d    0x40200000, $r6
-	move.d	$r6, $r0	; save for later - flash address of 'herami'
-	add.d	_edata, $r5
-	sub.d	hereami2, $r5	; r5 = flash address of '_edata'
-	add.d   0x40200000, $r5
-	move.d	hereami2, $r1	; destination
-2:
+
 	;; Copy text+data to DRAM
 
 	move.d	_edata, $r2	; end destination
-1:	move.w	[$r0+], $r3
-	move.w	$r3, [$r1+]
-	cmp.d	$r2, $r1
+1:	move.w	[$r0+], $r3	; from herami+ source
+	move.w	$r3, [$r1+]	; to hereami+ destination (linked address)
+	cmp.d	$r2, $r1	; finish when destination == _edata
 	bcs	1b
 	nop
-
 	move.d	input_data, $r0 ; for the decompressor
 	move.d	$r5, [$r0]	; for the decompressor
 
@@ -144,16 +78,24 @@ hereami2:
 	nop
 
 	;;  Save command line magic and address.
-	move.d	_cmd_line_magic, $r12
-	move.d  $r10, [$r12]
-	move.d	_cmd_line_addr, $r12
-	move.d  $r11, [$r12]
+	move.d	_cmd_line_magic, $r0
+	move.d  $r10, [$r0]
+	move.d	_cmd_line_addr, $r0
+	move.d  $r11, [$r0]
+
+	;;  Save boot source indicator
+	move.d	_boot_source, $r0
+	move.d	$r12, [$r0]
 
 	;; Do the decompression and save compressed size in _inptr
 
 	jsr	decompress_kernel
 	nop
 
+	;; Restore boot source indicator
+	move.d	_boot_source, $r12
+	move.d	[$r12], $r12
+
 	;; Restore command line magic and address.
 	move.d  _cmd_line_magic, $r10
 	move.d  [$r10], $r10
@@ -166,11 +108,10 @@ hereami2:
 	move.d	[$r0], $r9		; flash address of compressed kernel
 	move.d  inptr, $r0
 	add.d	[$r0], $r9		; size of compressed kernel
-	cmp.d   0x40200000, $r9
-	blo	enter_kernel
-	nop
-	sub.d   0x40200000, $r9
-	add.d   0x4000, $r9
+	cmp.d   0x40000000, $r9		; image in DRAM ?
+	blo	enter_kernel		; no, must be [NOR] flash, jump
+	nop				; delay slot
+	and.d   0x001fffff, $r9		; assume compressed kernel was < 2M
 
 enter_kernel:
 	;; Enter the decompressed kernel
@@ -186,7 +127,7 @@ _cmd_line_magic:
 	.dword 0
 _cmd_line_addr:
 	.dword 0
-is_nand_boot:
-	.dword  0
+_boot_source:
+	.dword 0
 
-#include "../../lib/hw_settings.S"
+#include "../../mach/hw_settings.S"
-- 
1.5.3.6.970.gd25430

