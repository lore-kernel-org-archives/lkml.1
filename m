Return-Path: <linux-kernel-owner+w=401wt.eu-S1756241AbXLFMyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241AbXLFMyx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 07:54:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755123AbXLFMo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 07:44:28 -0500
Received: from nic2.axis.se ([193.13.178.10]:45013 "EHLO krynn.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754769AbXLFMo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 07:44:26 -0500
From: Jesper Nilsson <jesper.nilsson@axis.com>
Message-Id: <3ec6c240b5590e4ea01bc800a48e54e8ccf9c3c9.1196848533.git.jesper.nilsson@axis.com>
In-Reply-To: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
References: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org
Date: Fri, 30 Nov 2007 17:54:12 +0100
Subject: [PATCH 40/47] Update CRISv32 kernel/head.S
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Shorten include paths for machine specific header files.
- Add magic for booting NAND flash.
- Change CONFIG_ETRAXFS_SIM to CONFIG_ETRAX_VCS_SIM.
- Use assembler macros for initializing hardware (clocks)
- Add stubs for SMP slave CPUs.
- Search for cramfs or jffs2 if no romfs found.
- Initialize l2cache.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 arch/cris/arch-v32/kernel/head.S |  202 +++++++++++++++++++++-----------------
 1 files changed, 114 insertions(+), 88 deletions(-)

diff --git a/arch/cris/arch-v32/kernel/head.S b/arch/cris/arch-v32/kernel/head.S
index 20bd80a..96ad000 100644
--- a/arch/cris/arch-v32/kernel/head.S
+++ b/arch/cris/arch-v32/kernel/head.S
@@ -4,22 +4,25 @@
  * Copyright (C) 2003, Axis Communications AB
  */
 
-
 #define ASSEMBLER_MACROS_ONLY
 
 /*
  * The macros found in mmu_defs_asm.h uses the ## concatenation operator, so
  * -traditional must not be used when assembling this file.
  */
-#include <asm/arch/hwregs/reg_rdwr.h>
-#include <asm/arch/hwregs/asm/mmu_defs_asm.h>
-#include <asm/arch/hwregs/asm/reg_map_asm.h>
-#include <asm/arch/hwregs/asm/config_defs_asm.h>
-#include <asm/arch/hwregs/asm/bif_core_defs_asm.h>
+#include <hwregs/reg_rdwr.h>
+#include <asm/arch/memmap.h>
+#include <hwregs/intr_vect.h>
+#include <hwregs/asm/mmu_defs_asm.h>
+#include <hwregs/asm/reg_map_asm.h>
+#include <asm/arch/mach/startup.inc>
 
 #define CRAMFS_MAGIC 0x28cd3d45
+#define JHEAD_MAGIC 0x1FF528A6
+#define JHEAD_SIZE 8
 #define RAM_INIT_MAGIC 0x56902387
 #define COMMAND_LINE_MAGIC 0x87109563
+#define NAND_BOOT_MAGIC 0x9a9db001
 
 	;; NOTE: R8 and R9 carry information from the decompressor (if the
 	;; kernel was compressed). They must not be used in the code below
@@ -30,12 +33,11 @@
 	.global romfs_start
 	.global romfs_length
 	.global romfs_in_flash
+	.global nand_boot
 	.global swapper_pg_dir
-	.global crisv32_nand_boot
-	.global crisv32_nand_cramfs_offset
 
 	;; Dummy section to make it bootable with current VCS simulator
-#ifdef CONFIG_ETRAXFS_SIM
+#ifdef CONFIG_ETRAX_VCS_SIM
 	.section ".boot", "ax"
 	ba tstart
 	nop
@@ -51,33 +53,13 @@ tstart:
 	;;
 	di
 
-	;; Start clocks for used blocks.
-	move.d REG_ADDR(config, regi_config, rw_clk_ctrl), $r1
-	move.d [$r1], $r0
-	or.d   REG_STATE(config, rw_clk_ctrl, cpu, yes) | \
-	       REG_STATE(config, rw_clk_ctrl, bif, yes) | \
-	       REG_STATE(config, rw_clk_ctrl, fix_io, yes), $r0
-	move.d $r0, [$r1]
-
-	;; Set up waitstates etc
-	move.d   REG_ADDR(bif_core, regi_bif_core, rw_grp1_cfg), $r0
-	move.d   CONFIG_ETRAX_MEM_GRP1_CONFIG, $r1
-	move.d   $r1, [$r0]
-	move.d   REG_ADDR(bif_core, regi_bif_core, rw_grp2_cfg), $r0
-	move.d   CONFIG_ETRAX_MEM_GRP2_CONFIG, $r1
-	move.d   $r1, [$r0]
-	move.d   REG_ADDR(bif_core, regi_bif_core, rw_grp3_cfg), $r0
-	move.d   CONFIG_ETRAX_MEM_GRP3_CONFIG, $r1
-	move.d   $r1, [$r0]
-	move.d   REG_ADDR(bif_core, regi_bif_core, rw_grp4_cfg), $r0
-	move.d   CONFIG_ETRAX_MEM_GRP4_CONFIG, $r1
-	move.d   $r1, [$r0]
-
-#ifdef CONFIG_ETRAXFS_SIM
-	;; Set up minimal flash waitstates
-	move.d 0, $r10
-	move.d REG_ADDR(bif_core, regi_bif_core, rw_grp1_cfg), $r11
-	move.d $r10, [$r11]
+	START_CLOCKS
+
+	SETUP_WAIT_STATES
+
+#ifdef CONFIG_SMP
+secondary_cpu_entry: /* Entry point for secondary CPUs */
+	di
 #endif
 
 	;; Setup and enable the MMU. Use same configuration for both the data
@@ -85,7 +67,7 @@ tstart:
 	;;
 	;; Note; 3 cycles is needed for a bank-select to take effect. Further;
 	;; bank 1 is the instruction MMU, bank 2 is the data MMU.
-#ifndef CONFIG_ETRAXFS_SIM
+#ifndef CONFIG_ETRAX_VCS_SIM
 	move.d	REG_FIELD(mmu, rw_mm_kbase_hi, base_e, 8)	\
 		| REG_FIELD(mmu, rw_mm_kbase_hi, base_c, 4)	\
 		| REG_FIELD(mmu, rw_mm_kbase_hi, base_b, 0xb), $r0
@@ -93,7 +75,7 @@ tstart:
 	;; Map the virtual DRAM to the RW eprom area at address 0.
 	;; Also map 0xa for the hook calls,
 	move.d	REG_FIELD(mmu, rw_mm_kbase_hi, base_e, 8)	\
-		| REG_FIELD(mmu, rw_mm_kbase_hi, base_c, 0)	\
+		| REG_FIELD(mmu, rw_mm_kbase_hi, base_c, 4)	\
 		| REG_FIELD(mmu, rw_mm_kbase_hi, base_b, 0xb)   \
 		| REG_FIELD(mmu, rw_mm_kbase_hi, base_a, 0xa), $r0
 #endif
@@ -104,7 +86,7 @@ tstart:
 
 	;; Enable certain page protections and setup linear mapping
 	;; for f,e,c,b,4,0.
-#ifndef CONFIG_ETRAXFS_SIM
+#ifndef CONFIG_ETRAX_VCS_SIM
 	move.d	REG_STATE(mmu, rw_mm_cfg, we, on)		\
 		| REG_STATE(mmu, rw_mm_cfg, acc, on)		\
 		| REG_STATE(mmu, rw_mm_cfg, ex, on)		\
@@ -183,17 +165,11 @@ tstart:
 	nop
 	nop
 	nop
-	move    $s10, $r0
+	move    $s12, $r0
 	cmpq    0, $r0
 	beq	master_cpu
 	nop
 slave_cpu:
-	; A slave waits for cpu_now_booting to be equal to CPU ID.
-	move.d	cpu_now_booting, $r1
-slave_wait:
-	cmp.d	[$r1], $r0
-	bne	slave_wait
-	nop
 	; Time to boot-up. Get stack location provided by master CPU.
 	move.d  smp_init_current_idle_thread, $r1
 	move.d  [$r1], $sp
@@ -203,9 +179,16 @@ slave_wait:
 	jsr	smp_callin
 	nop
 master_cpu:
+	/* Set up entry point for secondary CPUs. The boot ROM has set up
+	 * EBP at start of internal memory. The CPU will get there
+	 * later when we issue an IPI to them... */
+	move.d MEM_INTMEM_START + IPI_INTR_VECT * 4, $r0
+	move.d secondary_cpu_entry, $r1
+	move.d $r1, [$r0]
 #endif
-#ifndef CONFIG_ETRAXFS_SIM
-	;; Check if starting from DRAM or flash.
+#ifndef CONFIG_ETRAX_VCS_SIM
+	; Check if starting from DRAM (network->RAM boot or unpacked
+	; compressed kernel), or directly from flash.
 	lapcq	., $r0
 	and.d	0x7fffffff, $r0 ; Mask off the non-cache bit.
 	cmp.d	0x10000, $r0	; Arbitrary, something above this code.
@@ -232,12 +215,13 @@ _inflash:
 	beq	_dram_initialized
 	nop
 
-#include "../lib/dram_init.S"
+#include "../mach/dram_init.S"
 
 _dram_initialized:
 	;; Copy the text and data section to DRAM. This depends on that the
 	;; variables used below are correctly set up by the linker script.
 	;; The calculated value stored in R4 is used below.
+	;; Leave the cramfs file system (piggybacked after the kernel) in flash.
 	moveq	0, $r0		; Source.
 	move.d	text_start, $r1	; Destination.
 	move.d	__vmlinux_end, $r2
@@ -249,7 +233,7 @@ _dram_initialized:
 	blo	1b
 	nop
 
-	;; Keep CRAMFS in flash.
+	;; Check for cramfs.
 	moveq	0, $r0
 	move.d	romfs_length, $r1
 	move.d	$r0, [$r1]
@@ -258,6 +242,7 @@ _dram_initialized:
 	bne 1f
 	nop
 
+	;; Set length and start of cramfs, set romfs_in_flash flag
 	addoq	+4, $r4, $acr
 	move.d	[$acr], $r0
 	move.d	romfs_length, $r1
@@ -273,35 +258,32 @@ _dram_initialized:
 	nop
 
 _inram:
-	;; Check if booting from NAND flash (in that case we just remember the offset
-	;; into the flash where cramfs should be).
-	move.d	REG_ADDR(config, regi_config, r_bootsel), $r0
-	move.d	[$r0], $r0
-	and.d	REG_MASK(config, r_bootsel, boot_mode), $r0
-	cmp.d	REG_STATE(config, r_bootsel, boot_mode, nand), $r0
-	bne	move_cramfs
-	moveq	1,$r0
-	move.d	crisv32_nand_boot, $r1
-	move.d	$r0, [$r1]
-	move.d	crisv32_nand_cramfs_offset, $r1
-	move.d	$r9, [$r1]
+	;; Check if booting from NAND flash; if so, set appropriate flags
+	;; and move on.
+	cmp.d	NAND_BOOT_MAGIC, $r12
+	bne	move_cramfs	; not nand, jump
 	moveq	1, $r0
-	move.d	romfs_in_flash, $r1
+	move.d	nand_boot, $r1	; tell axisflashmap we're booting from NAND
 	move.d	$r0, [$r1]
-	jump	_start_it
+	moveq	0, $r0		; tell axisflashmap romfs is not in
+	move.d	romfs_in_flash, $r1 ; (directly accessed) flash
+	move.d	$r0, [$r1]
+	jump	_start_it	; continue with boot
 	nop
 
 move_cramfs:
-	;; Move the cramfs after BSS.
+	;; kernel is in DRAM.
+	;; Must figure out if there is a piggybacked rootfs image or not.
+	;; Set romfs_length to 0 => no rootfs image available by default.
 	moveq	0, $r0
 	move.d	romfs_length, $r1
 	move.d	$r0, [$r1]
 
-#ifndef CONFIG_ETRAXFS_SIM
+#ifndef CONFIG_ETRAX_VCS_SIM
 	;; The kernel could have been unpacked to DRAM by the loader, but
-	;; the cramfs image could still be inte the flash immediately
-	;; following the compressed kernel image. The loaded passes the address
-	;; of the bute succeeding the last compressed byte in the flash in
+	;; the cramfs image could still be in the flash immediately
+	;; following the compressed kernel image. The loader passes the address
+	;; of the byte succeeding the last compressed byte in the flash in
 	;; register R9 when starting the kernel.
 	cmp.d	0x0ffffff8, $r9
 	bhs	_no_romfs_in_flash ; R9 points outside the flash area.
@@ -310,11 +292,13 @@ move_cramfs:
 	ba _no_romfs_in_flash
 	nop
 #endif
+	;; cramfs rootfs might to be in flash. Check for it.
 	move.d	[$r9], $r0	; cramfs_super.magic
 	cmp.d	CRAMFS_MAGIC, $r0
 	bne	_no_romfs_in_flash
 	nop
 
+	;; found cramfs in flash. set address and size, and romfs_in_flash flag.
 	addoq	+4, $r9, $acr
 	move.d	[$acr], $r0
 	move.d	romfs_length, $r1
@@ -330,27 +314,43 @@ move_cramfs:
 	nop
 
 _no_romfs_in_flash:
-	;; Look for cramfs.
+	;; No romfs in flash, so look for cramfs, or jffs2 with jhead,
+	;; after kernel in RAM, as is the case with network->RAM boot.
+	;; For cramfs, partition starts with magic and length.
+	;; For jffs2, a jhead is prepended which contains with magic and length.
+	;; The jhead is not part of the jffs2 partition however.
 #ifndef CONFIG_ETRAXFS_SIM
 	move.d	__vmlinux_end, $r0
 #else
 	move.d	__end, $r0
 #endif
 	move.d	[$r0], $r1
-	cmp.d	CRAMFS_MAGIC, $r1
-	bne	2f
+	cmp.d	CRAMFS_MAGIC, $r1 ; cramfs magic?
+	beq	2f		  ; yes, jump
+	nop
+	cmp.d	JHEAD_MAGIC, $r1 ; jffs2 (jhead) magic?
+	bne	4f		; no, skip copy
+	nop
+	addq	4, $r0		; location of jffs2 size
+	move.d	[$r0+], $r2	; fetch jffs2 size -> r2
+				; r0 now points to start of jffs2
+	ba	3f
 	nop
+2:
+	addoq	+4, $r0, $acr	; location of cramfs size
+	move.d	[$acr], $r2	; fetch cramfs size -> r2
+				; r0 still points to start of cramfs
+3:
+	;; Now, move the root fs to after kernel's BSS
 
-	addoq	+4, $r0, $acr
-	move.d	[$acr], $r2
-	move.d	_end, $r1
+	move.d	_end, $r1	; start of cramfs -> r1
 	move.d	romfs_start, $r3
-	move.d	$r1, [$r3]
+	move.d	$r1, [$r3]	; store at romfs_start (for axisflashmap)
 	move.d	romfs_length, $r3
-	move.d	$r2, [$r3]
+	move.d	$r2, [$r3]	; store size at romfs_length
 
-#ifndef CONFIG_ETRAXFS_SIM
-	add.d	$r2, $r0
+#ifndef CONFIG_ETRAX_VCS_SIM
+	add.d	$r2, $r0	; copy from end and downwards
 	add.d	$r2, $r1
 
 	lsrq	1, $r2		; Size is in bytes, we copy words.
@@ -365,10 +365,17 @@ _no_romfs_in_flash:
 	nop
 #endif
 
-2:
+4:
+	;; BSS move done.
+	;; Clear romfs_in_flash flag, as we now know romfs is in DRAM
+	;; Also clear nand_boot flag; if we got here, we know we've not
+	;; booted from NAND flash.
 	moveq	0, $r0
 	move.d	romfs_in_flash, $r1
 	move.d	$r0, [$r1]
+	moveq	0, $r0
+	move.d	nand_boot, $r1
+	move.d	$r0, [$r1]
 
 	jump	_start_it	; Jump to cached code.
 	nop
@@ -384,8 +391,8 @@ _start_it:
 	move.d  cris_command_line, $r10
 	or.d	0x80000000, $r11 ; Make it virtual
 1:
-	move.b  [$r11+], $r12
-	move.b  $r12, [$r10+]
+	move.b  [$r11+], $r1
+	move.b  $r1, [$r10+]
 	subq	1, $r13
 	bne	1b
 	nop
@@ -401,7 +408,7 @@ no_command_line:
 	move.d	etrax_irv, $r1	; Set the exception base register and pointer.
 	move.d	$r0, [$r1]
 
-#ifndef CONFIG_ETRAXFS_SIM
+#ifndef CONFIG_ETRAX_VCS_SIM
 	;; Clear the BSS region from _bss_start to _end.
 	move.d	__bss_start, $r0
 	move.d	_end, $r1
@@ -411,7 +418,7 @@ no_command_line:
 	nop
 #endif
 
-#ifdef CONFIG_ETRAXFS_SIM
+#ifdef CONFIG_ETRAX_VCS_SIM
 	/* Set the watchdog timeout to something big. Will be removed when */
 	/* watchdog can be disabled with command line option */
 	move.d  0x7fffffff, $r10
@@ -423,25 +430,44 @@ no_command_line:
 	move.d __bss_start, $r0
 	movem [$r0], $r13
 
+#ifdef CONFIG_ETRAX_L2CACHE
+	jsr	l2cache_init
+	nop
+#endif
+
 	jump	start_kernel	; Jump to start_kernel() in init/main.c.
 	nop
 
 	.data
 etrax_irv:
 	.dword 0
+
+; Variables for communication with the Axis flash map driver (axisflashmap),
+; and for setting up memory in arch/cris/kernel/setup.c .
+
+; romfs_start is set to the start of the root file system, if it exists
+; in directly accessible memory (i.e. NOR Flash when booting from Flash,
+; or RAM when booting directly from a network-downloaded RAM image)
 romfs_start:
 	.dword 0
+
+; romfs_length is set to the size of the root file system image, if it exists
+; in directly accessible memory (see romfs_start). Otherwise it is set to 0.
 romfs_length:
 	.dword 0
+
+; romfs_in_flash is set to 1 if the root file system resides in directly
+; accessible flash memory (i.e. NOR flash). It is set to 0 for RAM boot
+; or NAND flash boot.
 romfs_in_flash:
 	.dword 0
-crisv32_nand_boot:
-	.dword 0
-crisv32_nand_cramfs_offset:
+
+; nand_boot is set to 1 when the kernel has been booted from NAND flash
+nand_boot:
 	.dword 0
 
 swapper_pg_dir = 0xc0002000
 
 	.section ".init.data", "aw"
 
-#include "../lib/hw_settings.S"
+#include "../mach/hw_settings.S"
-- 
1.5.3.6.970.gd25430

