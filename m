Return-Path: <linux-kernel-owner+w=401wt.eu-S1755636AbZDIFik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636AbZDIFik (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 01:38:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755863AbZDIFhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 01:37:36 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58066
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754494AbZDIFhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 01:37:33 -0400
Date: Wed, 08 Apr 2009 22:37:23 -0700 (PDT)
Message-Id: <20090408.223723.228486159.davem@davemloft.net>
To: tj@kernel.org
CC: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/12]: sparc64: Move trap_block[] definitions into a new
 header file.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Later we're going to want to get at these definitions from
asm/percpu.h and that's not possible via cpudata.h because
of the set of dependencies the non-trap_block[] stuff has.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 arch/sparc/include/asm/cpudata_64.h |  197 +---------------------------------
 arch/sparc/include/asm/trap_block.h |  207 +++++++++++++++++++++++++++++++++++
 2 files changed, 208 insertions(+), 196 deletions(-)
 create mode 100644 arch/sparc/include/asm/trap_block.h

diff --git a/arch/sparc/include/asm/cpudata_64.h b/arch/sparc/include/asm/cpudata_64.h
index c58d87b..926397d 100644
--- a/arch/sparc/include/asm/cpudata_64.h
+++ b/arch/sparc/include/asm/cpudata_64.h
@@ -6,9 +6,6 @@
 #ifndef _SPARC64_CPUDATA_H
 #define _SPARC64_CPUDATA_H
 
-#include <asm/hypervisor.h>
-#include <asm/asi.h>
-
 #ifndef __ASSEMBLY__
 
 #include <linux/percpu.h>
@@ -38,202 +35,10 @@ DECLARE_PER_CPU(cpuinfo_sparc, __cpu_data);
 #define cpu_data(__cpu)		per_cpu(__cpu_data, (__cpu))
 #define local_cpu_data()	__get_cpu_var(__cpu_data)
 
-/* Trap handling code needs to get at a few critical values upon
- * trap entry and to process TSB misses.  These cannot be in the
- * per_cpu() area as we really need to lock them into the TLB and
- * thus make them part of the main kernel image.  As a result we
- * try to make this as small as possible.
- *
- * This is padded out and aligned to 64-bytes to avoid false sharing
- * on SMP.
- */
-
-/* If you modify the size of this structure, please update
- * TRAP_BLOCK_SZ_SHIFT below.
- */
-struct thread_info;
-struct trap_per_cpu {
-/* D-cache line 1: Basic thread information, cpu and device mondo queues */
-	struct thread_info	*thread;
-	unsigned long		pgd_paddr;
-	unsigned long		cpu_mondo_pa;
-	unsigned long		dev_mondo_pa;
-
-/* D-cache line 2: Error Mondo Queue and kernel buffer pointers */
-	unsigned long		resum_mondo_pa;
-	unsigned long		resum_kernel_buf_pa;
-	unsigned long		nonresum_mondo_pa;
-	unsigned long		nonresum_kernel_buf_pa;
-
-/* Dcache lines 3, 4, 5, and 6: Hypervisor Fault Status */
-	struct hv_fault_status	fault_info;
-
-/* Dcache line 7: Physical addresses of CPU send mondo block and CPU list.  */
-	unsigned long		cpu_mondo_block_pa;
-	unsigned long		cpu_list_pa;
-	unsigned long		tsb_huge;
-	unsigned long		tsb_huge_temp;
-
-/* Dcache line 8: IRQ work list, and keep trap_block a power-of-2 in size.  */
-	unsigned long		irq_worklist_pa;
-	unsigned int		cpu_mondo_qmask;
-	unsigned int		dev_mondo_qmask;
-	unsigned int		resum_qmask;
-	unsigned int		nonresum_qmask;
-	unsigned long		__unused;
-} __attribute__((aligned(64)));
-extern struct trap_per_cpu trap_block[NR_CPUS];
-extern void init_cur_cpu_trap(struct thread_info *);
-extern void setup_tba(void);
-extern int ncpus_probed;
 extern const struct seq_operations cpuinfo_op;
 
-extern unsigned long real_hard_smp_processor_id(void);
-
-struct cpuid_patch_entry {
-	unsigned int	addr;
-	unsigned int	cheetah_safari[4];
-	unsigned int	cheetah_jbus[4];
-	unsigned int	starfire[4];
-	unsigned int	sun4v[4];
-};
-extern struct cpuid_patch_entry __cpuid_patch, __cpuid_patch_end;
-
-struct sun4v_1insn_patch_entry {
-	unsigned int	addr;
-	unsigned int	insn;
-};
-extern struct sun4v_1insn_patch_entry __sun4v_1insn_patch,
-	__sun4v_1insn_patch_end;
-
-struct sun4v_2insn_patch_entry {
-	unsigned int	addr;
-	unsigned int	insns[2];
-};
-extern struct sun4v_2insn_patch_entry __sun4v_2insn_patch,
-	__sun4v_2insn_patch_end;
-
 #endif /* !(__ASSEMBLY__) */
 
-#define TRAP_PER_CPU_THREAD		0x00
-#define TRAP_PER_CPU_PGD_PADDR		0x08
-#define TRAP_PER_CPU_CPU_MONDO_PA	0x10
-#define TRAP_PER_CPU_DEV_MONDO_PA	0x18
-#define TRAP_PER_CPU_RESUM_MONDO_PA	0x20
-#define TRAP_PER_CPU_RESUM_KBUF_PA	0x28
-#define TRAP_PER_CPU_NONRESUM_MONDO_PA	0x30
-#define TRAP_PER_CPU_NONRESUM_KBUF_PA	0x38
-#define TRAP_PER_CPU_FAULT_INFO		0x40
-#define TRAP_PER_CPU_CPU_MONDO_BLOCK_PA	0xc0
-#define TRAP_PER_CPU_CPU_LIST_PA	0xc8
-#define TRAP_PER_CPU_TSB_HUGE		0xd0
-#define TRAP_PER_CPU_TSB_HUGE_TEMP	0xd8
-#define TRAP_PER_CPU_IRQ_WORKLIST_PA	0xe0
-#define TRAP_PER_CPU_CPU_MONDO_QMASK	0xe8
-#define TRAP_PER_CPU_DEV_MONDO_QMASK	0xec
-#define TRAP_PER_CPU_RESUM_QMASK	0xf0
-#define TRAP_PER_CPU_NONRESUM_QMASK	0xf4
-
-#define TRAP_BLOCK_SZ_SHIFT		8
-
-#include <asm/scratchpad.h>
-
-#define __GET_CPUID(REG)				\
-	/* Spitfire implementation (default). */	\
-661:	ldxa		[%g0] ASI_UPA_CONFIG, REG;	\
-	srlx		REG, 17, REG;			\
-	 and		REG, 0x1f, REG;			\
-	nop;						\
-	.section	.cpuid_patch, "ax";		\
-	/* Instruction location. */			\
-	.word		661b;				\
-	/* Cheetah Safari implementation. */		\
-	ldxa		[%g0] ASI_SAFARI_CONFIG, REG;	\
-	srlx		REG, 17, REG;			\
-	and		REG, 0x3ff, REG;		\
-	nop;						\
-	/* Cheetah JBUS implementation. */		\
-	ldxa		[%g0] ASI_JBUS_CONFIG, REG;	\
-	srlx		REG, 17, REG;			\
-	and		REG, 0x1f, REG;			\
-	nop;						\
-	/* Starfire implementation. */			\
-	sethi		%hi(0x1fff40000d0 >> 9), REG;	\
-	sllx		REG, 9, REG;			\
-	or		REG, 0xd0, REG;			\
-	lduwa		[REG] ASI_PHYS_BYPASS_EC_E, REG;\
-	/* sun4v implementation. */			\
-	mov		SCRATCHPAD_CPUID, REG;		\
-	ldxa		[REG] ASI_SCRATCHPAD, REG;	\
-	nop;						\
-	nop;						\
-	.previous;
-
-#ifdef CONFIG_SMP
-
-#define TRAP_LOAD_TRAP_BLOCK(DEST, TMP)		\
-	__GET_CPUID(TMP)			\
-	sethi	%hi(trap_block), DEST;		\
-	sllx	TMP, TRAP_BLOCK_SZ_SHIFT, TMP;	\
-	or	DEST, %lo(trap_block), DEST;	\
-	add	DEST, TMP, DEST;		\
-
-/* Clobbers TMP, current address space PGD phys address into DEST.  */
-#define TRAP_LOAD_PGD_PHYS(DEST, TMP)		\
-	TRAP_LOAD_TRAP_BLOCK(DEST, TMP)		\
-	ldx	[DEST + TRAP_PER_CPU_PGD_PADDR], DEST;
-
-/* Clobbers TMP, loads local processor's IRQ work area into DEST.  */
-#define TRAP_LOAD_IRQ_WORK_PA(DEST, TMP)	\
-	TRAP_LOAD_TRAP_BLOCK(DEST, TMP)		\
-	add	DEST, TRAP_PER_CPU_IRQ_WORKLIST_PA, DEST;
-
-/* Clobbers TMP, loads DEST with current thread info pointer.  */
-#define TRAP_LOAD_THREAD_REG(DEST, TMP)		\
-	TRAP_LOAD_TRAP_BLOCK(DEST, TMP)		\
-	ldx	[DEST + TRAP_PER_CPU_THREAD], DEST;
-
-/* Given the current thread info pointer in THR, load the per-cpu
- * area base of the current processor into DEST.  REG1, REG2, and REG3 are
- * clobbered.
- *
- * You absolutely cannot use DEST as a temporary in this code.  The
- * reason is that traps can happen during execution, and return from
- * trap will load the fully resolved DEST per-cpu base.  This can corrupt
- * the calculations done by the macro mid-stream.
- */
-#define LOAD_PER_CPU_BASE(DEST, THR, REG1, REG2, REG3)	\
-	lduh	[THR + TI_CPU], REG1;			\
-	sethi	%hi(__per_cpu_shift), REG3;		\
-	sethi	%hi(__per_cpu_base), REG2;		\
-	ldx	[REG3 + %lo(__per_cpu_shift)], REG3;	\
-	ldx	[REG2 + %lo(__per_cpu_base)], REG2;	\
-	sllx	REG1, REG3, REG3;			\
-	add	REG3, REG2, DEST;
-
-#else
-
-#define TRAP_LOAD_TRAP_BLOCK(DEST, TMP)		\
-	sethi	%hi(trap_block), DEST;		\
-	or	DEST, %lo(trap_block), DEST;	\
-
-/* Uniprocessor versions, we know the cpuid is zero.  */
-#define TRAP_LOAD_PGD_PHYS(DEST, TMP)		\
-	TRAP_LOAD_TRAP_BLOCK(DEST, TMP)		\
-	ldx	[DEST + TRAP_PER_CPU_PGD_PADDR], DEST;
-
-/* Clobbers TMP, loads local processor's IRQ work area into DEST.  */
-#define TRAP_LOAD_IRQ_WORK_PA(DEST, TMP)	\
-	TRAP_LOAD_TRAP_BLOCK(DEST, TMP)		\
-	add	DEST, TRAP_PER_CPU_IRQ_WORKLIST_PA, DEST;
-
-#define TRAP_LOAD_THREAD_REG(DEST, TMP)		\
-	TRAP_LOAD_TRAP_BLOCK(DEST, TMP)		\
-	ldx	[DEST + TRAP_PER_CPU_THREAD], DEST;
-
-/* No per-cpu areas on uniprocessor, so no need to load DEST.  */
-#define LOAD_PER_CPU_BASE(DEST, THR, REG1, REG2, REG3)
-
-#endif /* !(CONFIG_SMP) */
+#include <asm/trap_block.h>
 
 #endif /* _SPARC64_CPUDATA_H */
diff --git a/arch/sparc/include/asm/trap_block.h b/arch/sparc/include/asm/trap_block.h
new file mode 100644
index 0000000..68fd9ee
--- /dev/null
+++ b/arch/sparc/include/asm/trap_block.h
@@ -0,0 +1,207 @@
+#ifndef _SPARC_TRAP_BLOCK_H
+#define _SPARC_TRAP_BLOCK_H
+
+#include <asm/hypervisor.h>
+#include <asm/asi.h>
+
+#ifndef __ASSEMBLY__
+
+/* Trap handling code needs to get at a few critical values upon
+ * trap entry and to process TSB misses.  These cannot be in the
+ * per_cpu() area as we really need to lock them into the TLB and
+ * thus make them part of the main kernel image.  As a result we
+ * try to make this as small as possible.
+ *
+ * This is padded out and aligned to 64-bytes to avoid false sharing
+ * on SMP.
+ */
+
+/* If you modify the size of this structure, please update
+ * TRAP_BLOCK_SZ_SHIFT below.
+ */
+struct thread_info;
+struct trap_per_cpu {
+/* D-cache line 1: Basic thread information, cpu and device mondo queues */
+	struct thread_info	*thread;
+	unsigned long		pgd_paddr;
+	unsigned long		cpu_mondo_pa;
+	unsigned long		dev_mondo_pa;
+
+/* D-cache line 2: Error Mondo Queue and kernel buffer pointers */
+	unsigned long		resum_mondo_pa;
+	unsigned long		resum_kernel_buf_pa;
+	unsigned long		nonresum_mondo_pa;
+	unsigned long		nonresum_kernel_buf_pa;
+
+/* Dcache lines 3, 4, 5, and 6: Hypervisor Fault Status */
+	struct hv_fault_status	fault_info;
+
+/* Dcache line 7: Physical addresses of CPU send mondo block and CPU list.  */
+	unsigned long		cpu_mondo_block_pa;
+	unsigned long		cpu_list_pa;
+	unsigned long		tsb_huge;
+	unsigned long		tsb_huge_temp;
+
+/* Dcache line 8: IRQ work list, and keep trap_block a power-of-2 in size.  */
+	unsigned long		irq_worklist_pa;
+	unsigned int		cpu_mondo_qmask;
+	unsigned int		dev_mondo_qmask;
+	unsigned int		resum_qmask;
+	unsigned int		nonresum_qmask;
+	unsigned long		__unused;
+} __attribute__((aligned(64)));
+extern struct trap_per_cpu trap_block[NR_CPUS];
+extern void init_cur_cpu_trap(struct thread_info *);
+extern void setup_tba(void);
+extern int ncpus_probed;
+
+extern unsigned long real_hard_smp_processor_id(void);
+
+struct cpuid_patch_entry {
+	unsigned int	addr;
+	unsigned int	cheetah_safari[4];
+	unsigned int	cheetah_jbus[4];
+	unsigned int	starfire[4];
+	unsigned int	sun4v[4];
+};
+extern struct cpuid_patch_entry __cpuid_patch, __cpuid_patch_end;
+
+struct sun4v_1insn_patch_entry {
+	unsigned int	addr;
+	unsigned int	insn;
+};
+extern struct sun4v_1insn_patch_entry __sun4v_1insn_patch,
+	__sun4v_1insn_patch_end;
+
+struct sun4v_2insn_patch_entry {
+	unsigned int	addr;
+	unsigned int	insns[2];
+};
+extern struct sun4v_2insn_patch_entry __sun4v_2insn_patch,
+	__sun4v_2insn_patch_end;
+
+
+#endif /* !(__ASSEMBLY__) */
+
+#define TRAP_PER_CPU_THREAD		0x00
+#define TRAP_PER_CPU_PGD_PADDR		0x08
+#define TRAP_PER_CPU_CPU_MONDO_PA	0x10
+#define TRAP_PER_CPU_DEV_MONDO_PA	0x18
+#define TRAP_PER_CPU_RESUM_MONDO_PA	0x20
+#define TRAP_PER_CPU_RESUM_KBUF_PA	0x28
+#define TRAP_PER_CPU_NONRESUM_MONDO_PA	0x30
+#define TRAP_PER_CPU_NONRESUM_KBUF_PA	0x38
+#define TRAP_PER_CPU_FAULT_INFO		0x40
+#define TRAP_PER_CPU_CPU_MONDO_BLOCK_PA	0xc0
+#define TRAP_PER_CPU_CPU_LIST_PA	0xc8
+#define TRAP_PER_CPU_TSB_HUGE		0xd0
+#define TRAP_PER_CPU_TSB_HUGE_TEMP	0xd8
+#define TRAP_PER_CPU_IRQ_WORKLIST_PA	0xe0
+#define TRAP_PER_CPU_CPU_MONDO_QMASK	0xe8
+#define TRAP_PER_CPU_DEV_MONDO_QMASK	0xec
+#define TRAP_PER_CPU_RESUM_QMASK	0xf0
+#define TRAP_PER_CPU_NONRESUM_QMASK	0xf4
+
+#define TRAP_BLOCK_SZ_SHIFT		8
+
+#include <asm/scratchpad.h>
+
+#define __GET_CPUID(REG)				\
+	/* Spitfire implementation (default). */	\
+661:	ldxa		[%g0] ASI_UPA_CONFIG, REG;	\
+	srlx		REG, 17, REG;			\
+	 and		REG, 0x1f, REG;			\
+	nop;						\
+	.section	.cpuid_patch, "ax";		\
+	/* Instruction location. */			\
+	.word		661b;				\
+	/* Cheetah Safari implementation. */		\
+	ldxa		[%g0] ASI_SAFARI_CONFIG, REG;	\
+	srlx		REG, 17, REG;			\
+	and		REG, 0x3ff, REG;		\
+	nop;						\
+	/* Cheetah JBUS implementation. */		\
+	ldxa		[%g0] ASI_JBUS_CONFIG, REG;	\
+	srlx		REG, 17, REG;			\
+	and		REG, 0x1f, REG;			\
+	nop;						\
+	/* Starfire implementation. */			\
+	sethi		%hi(0x1fff40000d0 >> 9), REG;	\
+	sllx		REG, 9, REG;			\
+	or		REG, 0xd0, REG;			\
+	lduwa		[REG] ASI_PHYS_BYPASS_EC_E, REG;\
+	/* sun4v implementation. */			\
+	mov		SCRATCHPAD_CPUID, REG;		\
+	ldxa		[REG] ASI_SCRATCHPAD, REG;	\
+	nop;						\
+	nop;						\
+	.previous;
+
+#ifdef CONFIG_SMP
+
+#define TRAP_LOAD_TRAP_BLOCK(DEST, TMP)		\
+	__GET_CPUID(TMP)			\
+	sethi	%hi(trap_block), DEST;		\
+	sllx	TMP, TRAP_BLOCK_SZ_SHIFT, TMP;	\
+	or	DEST, %lo(trap_block), DEST;	\
+	add	DEST, TMP, DEST;		\
+
+/* Clobbers TMP, current address space PGD phys address into DEST.  */
+#define TRAP_LOAD_PGD_PHYS(DEST, TMP)		\
+	TRAP_LOAD_TRAP_BLOCK(DEST, TMP)		\
+	ldx	[DEST + TRAP_PER_CPU_PGD_PADDR], DEST;
+
+/* Clobbers TMP, loads local processor's IRQ work area into DEST.  */
+#define TRAP_LOAD_IRQ_WORK_PA(DEST, TMP)	\
+	TRAP_LOAD_TRAP_BLOCK(DEST, TMP)		\
+	add	DEST, TRAP_PER_CPU_IRQ_WORKLIST_PA, DEST;
+
+/* Clobbers TMP, loads DEST with current thread info pointer.  */
+#define TRAP_LOAD_THREAD_REG(DEST, TMP)		\
+	TRAP_LOAD_TRAP_BLOCK(DEST, TMP)		\
+	ldx	[DEST + TRAP_PER_CPU_THREAD], DEST;
+
+/* Given the current thread info pointer in THR, load the per-cpu
+ * area base of the current processor into DEST.  REG1, REG2, and REG3 are
+ * clobbered.
+ *
+ * You absolutely cannot use DEST as a temporary in this code.  The
+ * reason is that traps can happen during execution, and return from
+ * trap will load the fully resolved DEST per-cpu base.  This can corrupt
+ * the calculations done by the macro mid-stream.
+ */
+#define LOAD_PER_CPU_BASE(DEST, THR, REG1, REG2, REG3)	\
+	lduh	[THR + TI_CPU], REG1;			\
+	sethi	%hi(__per_cpu_shift), REG3;		\
+	sethi	%hi(__per_cpu_base), REG2;		\
+	ldx	[REG3 + %lo(__per_cpu_shift)], REG3;	\
+	ldx	[REG2 + %lo(__per_cpu_base)], REG2;	\
+	sllx	REG1, REG3, REG3;			\
+	add	REG3, REG2, DEST;
+
+#else
+
+#define TRAP_LOAD_TRAP_BLOCK(DEST, TMP)		\
+	sethi	%hi(trap_block), DEST;		\
+	or	DEST, %lo(trap_block), DEST;	\
+
+/* Uniprocessor versions, we know the cpuid is zero.  */
+#define TRAP_LOAD_PGD_PHYS(DEST, TMP)		\
+	TRAP_LOAD_TRAP_BLOCK(DEST, TMP)		\
+	ldx	[DEST + TRAP_PER_CPU_PGD_PADDR], DEST;
+
+/* Clobbers TMP, loads local processor's IRQ work area into DEST.  */
+#define TRAP_LOAD_IRQ_WORK_PA(DEST, TMP)	\
+	TRAP_LOAD_TRAP_BLOCK(DEST, TMP)		\
+	add	DEST, TRAP_PER_CPU_IRQ_WORKLIST_PA, DEST;
+
+#define TRAP_LOAD_THREAD_REG(DEST, TMP)		\
+	TRAP_LOAD_TRAP_BLOCK(DEST, TMP)		\
+	ldx	[DEST + TRAP_PER_CPU_THREAD], DEST;
+
+/* No per-cpu areas on uniprocessor, so no need to load DEST.  */
+#define LOAD_PER_CPU_BASE(DEST, THR, REG1, REG2, REG3)
+
+#endif /* !(CONFIG_SMP) */
+
+#endif /* _SPARC_TRAP_BLOCK_H */
-- 
1.6.2.2

