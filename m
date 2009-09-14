Return-Path: <linux-kernel-owner+w=401wt.eu-S933714AbZINUPI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933714AbZINUPI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:15:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933573AbZINUPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:15:04 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54145 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933626AbZINUI4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:08:56 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 52/72] Blackfin: punt dead cache locking code
Date: Mon, 14 Sep 2009 16:07:56 -0400
Message-Id: <1252958896-25150-53-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No one uses these functions, and some are duplicate of existing C code.  So
just punt the whole thing.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/Kconfig                   |    4 -
 arch/blackfin/include/asm/bfin-global.h |    5 -
 arch/blackfin/kernel/setup.c            |   51 -------
 arch/blackfin/mach-common/Makefile      |    1 -
 arch/blackfin/mach-common/lock.S        |  223 -------------------------------
 5 files changed, 0 insertions(+), 284 deletions(-)
 delete mode 100644 arch/blackfin/mach-common/lock.S

diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index 8d6b5ae..f20dc77 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -917,10 +917,6 @@ comment "Cache Support"
 config BFIN_ICACHE
 	bool "Enable ICACHE"
 	default y
-config BFIN_ICACHE_LOCK
-	bool "Enable Instruction Cache Locking"
-	depends on BFIN_ICACHE
-	default n
 config BFIN_EXTMEM_ICACHEABLE
 	bool "Enable ICACHE for external memory"
 	depends on BFIN_ICACHE
diff --git a/arch/blackfin/include/asm/bfin-global.h b/arch/blackfin/include/asm/bfin-global.h
index e6ecbe4..aef0594 100644
--- a/arch/blackfin/include/asm/bfin-global.h
+++ b/arch/blackfin/include/asm/bfin-global.h
@@ -99,11 +99,6 @@ extern unsigned long bfin_sic_iwr[];
 extern unsigned vr_wakeup;
 extern u16 _bfin_swrst; /* shadow for Software Reset Register (SWRST) */
 
-#ifdef CONFIG_BFIN_ICACHE_LOCK
-extern void cache_grab_lock(int way);
-extern void bfin_cache_lock(int way);
-#endif
-
 #endif
 
 #endif				/* _BLACKFIN_H_ */
diff --git a/arch/blackfin/kernel/setup.c b/arch/blackfin/kernel/setup.c
index f92fffc..ce02f98 100644
--- a/arch/blackfin/kernel/setup.c
+++ b/arch/blackfin/kernel/setup.c
@@ -1238,57 +1238,6 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 #ifdef __ARCH_SYNC_CORE_ICACHE
 	seq_printf(m, "SMP Icache Flushes\t: %lu\n\n", cpudata->icache_invld_count);
 #endif
-#ifdef CONFIG_BFIN_ICACHE_LOCK
-	switch ((cpudata->imemctl >> 3) & WAYALL_L) {
-	case WAY0_L:
-		seq_printf(m, "Way0 Locked-Down\n");
-		break;
-	case WAY1_L:
-		seq_printf(m, "Way1 Locked-Down\n");
-		break;
-	case WAY01_L:
-		seq_printf(m, "Way0,Way1 Locked-Down\n");
-		break;
-	case WAY2_L:
-		seq_printf(m, "Way2 Locked-Down\n");
-		break;
-	case WAY02_L:
-		seq_printf(m, "Way0,Way2 Locked-Down\n");
-		break;
-	case WAY12_L:
-		seq_printf(m, "Way1,Way2 Locked-Down\n");
-		break;
-	case WAY012_L:
-		seq_printf(m, "Way0,Way1 & Way2 Locked-Down\n");
-		break;
-	case WAY3_L:
-		seq_printf(m, "Way3 Locked-Down\n");
-		break;
-	case WAY03_L:
-		seq_printf(m, "Way0,Way3 Locked-Down\n");
-		break;
-	case WAY13_L:
-		seq_printf(m, "Way1,Way3 Locked-Down\n");
-		break;
-	case WAY013_L:
-		seq_printf(m, "Way 0,Way1,Way3 Locked-Down\n");
-		break;
-	case WAY32_L:
-		seq_printf(m, "Way3,Way2 Locked-Down\n");
-		break;
-	case WAY320_L:
-		seq_printf(m, "Way3,Way2,Way0 Locked-Down\n");
-		break;
-	case WAY321_L:
-		seq_printf(m, "Way3,Way2,Way1 Locked-Down\n");
-		break;
-	case WAYALL_L:
-		seq_printf(m, "All Ways are locked\n");
-		break;
-	default:
-		seq_printf(m, "No Ways are locked\n");
-	}
-#endif
 
 	if (cpu_num != num_possible_cpus() - 1)
 		return 0;
diff --git a/arch/blackfin/mach-common/Makefile b/arch/blackfin/mach-common/Makefile
index dd8b2dc..814cb48 100644
--- a/arch/blackfin/mach-common/Makefile
+++ b/arch/blackfin/mach-common/Makefile
@@ -6,7 +6,6 @@ obj-y := \
 	cache.o cache-c.o entry.o head.o \
 	interrupt.o arch_checks.o ints-priority.o
 
-obj-$(CONFIG_BFIN_ICACHE_LOCK) += lock.o
 obj-$(CONFIG_PM)          += pm.o dpmc_modes.o
 obj-$(CONFIG_CPU_FREQ)    += cpufreq.o
 obj-$(CONFIG_CPU_VOLTAGE) += dpmc.o
diff --git a/arch/blackfin/mach-common/lock.S b/arch/blackfin/mach-common/lock.S
deleted file mode 100644
index 6c5f5f0..0000000
--- a/arch/blackfin/mach-common/lock.S
+++ /dev/null
@@ -1,223 +0,0 @@
-/*
- * File:         arch/blackfin/mach-common/lock.S
- * Based on:
- * Author:       LG Soft India
- *
- * Created:      ?
- * Description:  kernel locks
- *
- * Modified:
- *               Copyright 2004-2006 Analog Devices Inc.
- *
- * Bugs:         Enter bugs at http://blackfin.uclinux.org/
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, see the file COPYING, or write
- * to the Free Software Foundation, Inc.,
- * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-
-#include <linux/linkage.h>
-#include <asm/blackfin.h>
-
-.text
-
-/* When you come here, it is assumed that
- * R0 - Which way to be locked
- */
-
-ENTRY(_cache_grab_lock)
-
-	[--SP]=( R7:0,P5:0 );
-
-	P1.H = HI(IMEM_CONTROL);
-	P1.L = LO(IMEM_CONTROL);
-	P5.H = HI(ICPLB_ADDR0);
-	P5.L = LO(ICPLB_ADDR0);
-	P4.H = HI(ICPLB_DATA0);
-	P4.L = LO(ICPLB_DATA0);
-	R7 = R0;
-
-	/* If the code of interest already resides in the cache
-	 * invalidate the entire cache itself.
-	 * invalidate_entire_icache;
-	 */
-
-	SP += -12;
-	[--SP] = RETS;
-	CALL _invalidate_entire_icache;
-	RETS = [SP++];
-	SP += 12;
-
-	/* Disable the Interrupts*/
-
-	CLI R3;
-
-.LLOCK_WAY:
-
-	/* Way0 - 0xFFA133E0
-	 * Way1 - 0xFFA137E0
-	 * Way2 - 0xFFA13BE0	Total Way Size = 4K
-	 * Way3 - 0xFFA13FE0
-	 */
-
-	/* Procedure Ex. -Set the locks for other ways by setting ILOC[3:1]
-	 * Only Way0 of the instruction cache can now be
-	 * replaced by a new code
-	 */
-
-	R5 = R7;
-	CC = BITTST(R7,0);
-	IF CC JUMP .LCLEAR1;
-	R7 = 0;
-	BITSET(R7,0);
-	JUMP .LDONE1;
-
-.LCLEAR1:
-	R7 = 0;
-	BITCLR(R7,0);
-.LDONE1:	R4 = R7 << 3;
-	R7 = [P1];
-	R7 = R7 | R4;
-	SSYNC;		/* SSYNC required writing to IMEM_CONTROL. */
-	.align 8;
-	[P1] = R7;
-	SSYNC;
-
-	R7 = R5;
-	CC = BITTST(R7,1);
-	IF CC JUMP .LCLEAR2;
-	R7 = 0;
-	BITSET(R7,1);
-	JUMP .LDONE2;
-
-.LCLEAR2:
-	R7 = 0;
-	BITCLR(R7,1);
-.LDONE2:	R4 = R7 << 3;
-	R7 = [P1];
-	R7 = R7 | R4;
-	SSYNC;		/* SSYNC required writing to IMEM_CONTROL. */
-	.align 8;
-	[P1] = R7;
-	SSYNC;
-
-	R7 = R5;
-	CC = BITTST(R7,2);
-	IF CC JUMP .LCLEAR3;
-	R7 = 0;
-	BITSET(R7,2);
-	JUMP .LDONE3;
-.LCLEAR3:
-	R7 = 0;
-	BITCLR(R7,2);
-.LDONE3:	R4 = R7 << 3;
-	R7 = [P1];
-	R7 = R7 | R4;
-	SSYNC;		/* SSYNC required writing to IMEM_CONTROL. */
-	.align 8;
-	[P1] = R7;
-	SSYNC;
-
-
-	R7 = R5;
-	CC = BITTST(R7,3);
-	IF CC JUMP .LCLEAR4;
-	R7 = 0;
-	BITSET(R7,3);
-	JUMP .LDONE4;
-.LCLEAR4:
-	R7 = 0;
-	BITCLR(R7,3);
-.LDONE4:	R4 = R7 << 3;
-	R7 = [P1];
-	R7 = R7 | R4;
-	SSYNC;		/* SSYNC required writing to IMEM_CONTROL. */
-	.align 8;
-	[P1] = R7;
-	SSYNC;
-
-	STI R3;
-
-	( R7:0,P5:0 ) = [SP++];
-
-	RTS;
-ENDPROC(_cache_grab_lock)
-
-/* After the execution of critical code, the code is now locked into
- * the cache way. Now we need to set ILOC.
- *
- * R0 - Which way to be locked
- */
-
-ENTRY(_bfin_cache_lock)
-
-	[--SP]=( R7:0,P5:0 );
-
-	P1.H = HI(IMEM_CONTROL);
-	P1.L = LO(IMEM_CONTROL);
-
-	/* Disable the Interrupts*/
-	CLI R3;
-
-	R7 = [P1];
-	R2 = ~(0x78) (X);	/* mask out ILOC */
-	R7 = R7 & R2;
-	R0 = R0 << 3;
-	R7 = R0 | R7;
-	SSYNC;		/* SSYNC required writing to IMEM_CONTROL. */
-	.align 8;
-	[P1] = R7;
-	SSYNC;
-	/* Renable the Interrupts */
-	STI R3;
-
-	( R7:0,P5:0 ) = [SP++];
-	RTS;
-ENDPROC(_bfin_cache_lock)
-
-/* Invalidate the Entire Instruction cache by
- * disabling IMC bit
- */
-ENTRY(_invalidate_entire_icache)
-	[--SP] = ( R7:5);
-
-	P0.L = LO(IMEM_CONTROL);
-	P0.H = HI(IMEM_CONTROL);
-	R7 = [P0];
-
-	/* Clear the IMC bit , All valid bits in the instruction
-	 * cache are set to the invalid state
-	 */
-	BITCLR(R7,IMC_P);
-	CLI R6;
-	SSYNC;		/* SSYNC required before invalidating cache. */
-	.align 8;
-	[P0] = R7;
-	SSYNC;
-	STI R6;
-
-	/* Configures the instruction cache agian */
-	R6 = (IMC | ENICPLB);
-	R7 = R7 | R6;
-
-	CLI R6;
-	SSYNC;		/* SSYNC required before writing to IMEM_CONTROL. */
-	.align 8;
-	[P0] = R7;
-	SSYNC;
-	STI R6;
-
-	( R7:5) = [SP++];
-	RTS;
-ENDPROC(_invalidate_entire_icache)
-- 
1.6.4.2

