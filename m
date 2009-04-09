Return-Path: <linux-kernel-owner+w=401wt.eu-S1762009AbZDIFjK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762009AbZDIFjK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 01:39:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760330AbZDIFhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 01:37:46 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58069
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753952AbZDIFho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 01:37:44 -0400
Date: Wed, 08 Apr 2009 22:37:35 -0700 (PDT)
Message-Id: <20090408.223735.11213840.davem@davemloft.net>
To: tj@kernel.org
CC: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/12]: sparc64: Store per-cpu offset in trap_block[]
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Surprisingly this actually makes LOAD_PER_CPU_BASE() a little
more efficient.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 arch/sparc/include/asm/percpu_64.h  |    6 +++---
 arch/sparc/include/asm/trap_block.h |   14 +++++++-------
 arch/sparc/kernel/head_64.S         |   22 ----------------------
 arch/sparc/kernel/smp_64.c          |   18 +++++++-----------
 arch/sparc/kernel/traps_64.c        |    5 ++++-
 5 files changed, 21 insertions(+), 44 deletions(-)

diff --git a/arch/sparc/include/asm/percpu_64.h b/arch/sparc/include/asm/percpu_64.h
index bee6459..c0ab102 100644
--- a/arch/sparc/include/asm/percpu_64.h
+++ b/arch/sparc/include/asm/percpu_64.h
@@ -7,12 +7,12 @@ register unsigned long __local_per_cpu_offset asm("g5");
 
 #ifdef CONFIG_SMP
 
+#include <asm/trap_block.h>
+
 extern void real_setup_per_cpu_areas(void);
 
-extern unsigned long __per_cpu_base;
-extern unsigned long __per_cpu_shift;
 #define __per_cpu_offset(__cpu) \
-	(__per_cpu_base + ((unsigned long)(__cpu) << __per_cpu_shift))
+	(trap_block[(__cpu)].__per_cpu_base)
 #define per_cpu_offset(x) (__per_cpu_offset(x))
 
 #define __my_cpu_offset __local_per_cpu_offset
diff --git a/arch/sparc/include/asm/trap_block.h b/arch/sparc/include/asm/trap_block.h
index 68fd9ee..7e26b2d 100644
--- a/arch/sparc/include/asm/trap_block.h
+++ b/arch/sparc/include/asm/trap_block.h
@@ -48,7 +48,7 @@ struct trap_per_cpu {
 	unsigned int		dev_mondo_qmask;
 	unsigned int		resum_qmask;
 	unsigned int		nonresum_qmask;
-	unsigned long		__unused;
+	unsigned long		__per_cpu_base;
 } __attribute__((aligned(64)));
 extern struct trap_per_cpu trap_block[NR_CPUS];
 extern void init_cur_cpu_trap(struct thread_info *);
@@ -101,6 +101,7 @@ extern struct sun4v_2insn_patch_entry __sun4v_2insn_patch,
 #define TRAP_PER_CPU_DEV_MONDO_QMASK	0xec
 #define TRAP_PER_CPU_RESUM_QMASK	0xf0
 #define TRAP_PER_CPU_NONRESUM_QMASK	0xf4
+#define TRAP_PER_CPU_PER_CPU_BASE	0xf8
 
 #define TRAP_BLOCK_SZ_SHIFT		8
 
@@ -172,12 +173,11 @@ extern struct sun4v_2insn_patch_entry __sun4v_2insn_patch,
  */
 #define LOAD_PER_CPU_BASE(DEST, THR, REG1, REG2, REG3)	\
 	lduh	[THR + TI_CPU], REG1;			\
-	sethi	%hi(__per_cpu_shift), REG3;		\
-	sethi	%hi(__per_cpu_base), REG2;		\
-	ldx	[REG3 + %lo(__per_cpu_shift)], REG3;	\
-	ldx	[REG2 + %lo(__per_cpu_base)], REG2;	\
-	sllx	REG1, REG3, REG3;			\
-	add	REG3, REG2, DEST;
+	sethi	%hi(trap_block), REG2;			\
+	sllx	REG1, TRAP_BLOCK_SZ_SHIFT, REG1;	\
+	or	REG2, %lo(trap_block), REG2;		\
+	add	REG2, REG1, REG2;			\
+	ldx	[REG2 + TRAP_PER_CPU_PER_CPU_BASE], DEST;
 
 #else
 
diff --git a/arch/sparc/kernel/head_64.S b/arch/sparc/kernel/head_64.S
index 3a1b7bf..619b4b7 100644
--- a/arch/sparc/kernel/head_64.S
+++ b/arch/sparc/kernel/head_64.S
@@ -641,28 +641,6 @@ tlb_fixup_done:
 	/* Not reached... */
 
 1:
-	/* If we boot on a non-zero cpu, all of the per-cpu
-	 * variable references we make before setting up the
-	 * per-cpu areas will use a bogus offset.  Put a
-	 * compensating factor into __per_cpu_base to handle
-	 * this cleanly.
-	 *
-	 * What the per-cpu code calculates is:
-	 *
-	 *	__per_cpu_base + (cpu << __per_cpu_shift)
-	 *
-	 * These two variables are zero initially, so to
-	 * make it all cancel out to zero we need to put
-	 * "0 - (cpu << 0)" into __per_cpu_base so that the
-	 * above formula evaluates to zero.
-	 *
-	 * We cannot even perform a printk() until this stuff
-	 * is setup as that calls cpu_clock() which uses
-	 * per-cpu variables.
-	 */
-	sub	%g0, %o0, %o1
-	sethi	%hi(__per_cpu_base), %o2
-	stx	%o1, [%o2 + %lo(__per_cpu_base)]
 #else
 	mov	0, %o0
 #endif
diff --git a/arch/sparc/kernel/smp_64.c b/arch/sparc/kernel/smp_64.c
index 662fea2..022e5e0 100644
--- a/arch/sparc/kernel/smp_64.c
+++ b/arch/sparc/kernel/smp_64.c
@@ -1371,23 +1371,17 @@ void smp_send_stop(void)
 {
 }
 
-unsigned long __per_cpu_base __read_mostly;
-unsigned long __per_cpu_shift __read_mostly;
-
-EXPORT_SYMBOL(__per_cpu_base);
-EXPORT_SYMBOL(__per_cpu_shift);
-
 void __init real_setup_per_cpu_areas(void)
 {
-	unsigned long paddr, goal, size, i;
+	unsigned long base, shift, paddr, goal, size, i;
 	char *ptr;
 
 	/* Copy section for each CPU (we discard the original) */
 	goal = PERCPU_ENOUGH_ROOM;
 
-	__per_cpu_shift = PAGE_SHIFT;
+	shift = PAGE_SHIFT;
 	for (size = PAGE_SIZE; size < goal; size <<= 1UL)
-		__per_cpu_shift++;
+		shift++;
 
 	paddr = lmb_alloc(size * NR_CPUS, PAGE_SIZE);
 	if (!paddr) {
@@ -1396,10 +1390,12 @@ void __init real_setup_per_cpu_areas(void)
 	}
 
 	ptr = __va(paddr);
-	__per_cpu_base = ptr - __per_cpu_start;
+	base = ptr - __per_cpu_start;
 
-	for (i = 0; i < NR_CPUS; i++, ptr += size)
+	for (i = 0; i < NR_CPUS; i++, ptr += size) {
+		__per_cpu_offset(i) = base + (i * size);
 		memcpy(ptr, __per_cpu_start, __per_cpu_end - __per_cpu_start);
+	}
 
 	/* Setup %g5 for the boot cpu.  */
 	__local_per_cpu_offset = __per_cpu_offset(smp_processor_id());
diff --git a/arch/sparc/kernel/traps_64.c b/arch/sparc/kernel/traps_64.c
index d809c4e..d073aab 100644
--- a/arch/sparc/kernel/traps_64.c
+++ b/arch/sparc/kernel/traps_64.c
@@ -2509,6 +2509,7 @@ void do_getpsr(struct pt_regs *regs)
 }
 
 struct trap_per_cpu trap_block[NR_CPUS];
+EXPORT_SYMBOL(trap_block);
 
 /* This can get invoked before sched_init() so play it super safe
  * and use hard_smp_processor_id().
@@ -2592,7 +2593,9 @@ void __init trap_init(void)
 	    (TRAP_PER_CPU_RESUM_QMASK !=
 	     offsetof(struct trap_per_cpu, resum_qmask)) ||
 	    (TRAP_PER_CPU_NONRESUM_QMASK !=
-	     offsetof(struct trap_per_cpu, nonresum_qmask)))
+	     offsetof(struct trap_per_cpu, nonresum_qmask)) ||
+	    (TRAP_PER_CPU_PER_CPU_BASE !=
+	     offsetof(struct trap_per_cpu, __per_cpu_base)))
 		trap_per_cpu_offsets_are_bolixed_dave();
 
 	if ((TSB_CONFIG_TSB !=
-- 
1.6.2.2

