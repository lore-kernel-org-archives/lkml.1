Return-Path: <linux-kernel-owner+w=401wt.eu-S937000AbXHLPOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937000AbXHLPOh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 11:14:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936153AbXHLPJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 11:09:03 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:47613 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936222AbXHLPIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 11:08:54 -0400
Message-Id: <20070812150815.600419531@polymtl.ca>
References: <20070812150702.769065566@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sun, 12 Aug 2007 11:07:07 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Christoph Hellwig <hch@infradead.org>
Subject: [patch 5/8] Immediate Values - i386 Optimization
Content-Disposition: inline; filename=immediate-values-i386-optimization.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Sun, 12 Aug 2007 15:08:16 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

i386 optimization of the immediate values which uses a movl with code patching
to set/unset the value used to populate the register used as variable source.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Christoph Hellwig <hch@infradead.org>
---
 arch/i386/kernel/Makefile    |    1 
 arch/i386/kernel/immediate.c |  301 +++++++++++++++++++++++++++++++++++++++++++
 arch/i386/kernel/traps.c     |    8 -
 include/asm-i386/immediate.h |  137 +++++++++++++++++++
 4 files changed, 443 insertions(+), 4 deletions(-)

Index: linux-2.6-lttng/include/asm-i386/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-i386/immediate.h	2007-08-09 18:32:15.000000000 -0400
@@ -0,0 +1,137 @@
+#ifndef _ASM_I386_IMMEDIATE_H
+#define _ASM_I386_IMMEDIATE_H
+
+/*
+ * Immediate values. i386 architecture optimizations.
+ *
+ * (C) Copyright 2006 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ */
+
+struct module;
+
+struct __immediate {
+	long var;		/* Pointer to the identifier variable of the
+				 * immediate value
+				 */
+	long immediate;		/*
+				 * Pointer to the memory location of the
+				 * immediate value within the instruction.
+				 */
+	long size;		/* Type size. */
+};
+
+/**
+ * immediate_read - read immediate variable
+ * @var: pointer of type immediate_*_t
+ *
+ * Reads the value of @var.
+ * Optimized version of the immediate.
+ * Do not use in __init and __exit functions. Use _immediate_read() instead.
+ * Makes sure the 2 and 4 bytes update will be atomic by aligning the immediate
+ * value. 2 bytes (short) uses a 66H prefix. If size is bigger than 4 bytes,
+ * fall back on a memory read.
+ */
+#define immediate_read(var)						\
+	({								\
+		__typeof__((var)->value) value;				\
+		switch (sizeof(value)) {				\
+		case 1:							\
+			asm (	".section __immediate, \"a\", @progbits;\n\t" \
+					".long %1, (0f)+1, 1;\n\t"	\
+					".previous;\n\t"		\
+					"0:\n\t"			\
+					"mov %2,%0;\n\t"		\
+				: "=r" (value)				\
+				: "m" ((var)->value),			\
+				  "i" (0));				\
+			break;						\
+		case 2:							\
+			asm (	".section __immediate, \"a\", @progbits;\n\t" \
+					".long %1, (0f)+2, 2;\n\t"	\
+					".previous;\n\t"		\
+					"1:\n\t"			\
+					".align 2;\n\t"			\
+					"0:\n\t"			\
+					"mov %2,%0;\n\t"		\
+				: "=r" (value)				\
+				: "m" ((var)->value),			\
+				  "i" (0));				\
+			break;						\
+		case 4:							\
+			asm (	".section __immediate, \"a\", @progbits;\n\t" \
+					".long %1, (0f)+1, 4;\n\t"	\
+					".previous;\n\t"		\
+					"1:\n\t"			\
+					".org (1b)+(3-((1b)%%4)), 0x90;\n\t" \
+					"0:\n\t"			\
+					"mov %2,%0;\n\t"		\
+				: "=r" (value)				\
+				: "m" ((var)->value),			\
+				  "i" (0));				\
+			break;						\
+		default:value = (var)->value;				\
+			break;						\
+		};							\
+		value;							\
+	})
+
+
+/**
+ * immediate_set - set immediate variable (with locking)
+ * @var: pointer of type immediate_*_t
+ * @i: required value
+ *
+ * Sets the value of @var, taking the module_mutex if required by
+ * the architecture.
+ */
+#define immediate_set(var, i) \
+	(var)->value = (i); \
+	immediate_update(1);
+
+/**
+ * _immediate_set - set immediate variable (without locking)
+ * @var: pointer of type immediate_*_t
+ * @i: required value
+ *
+ * Sets the value of @var. Must be called with module_mutex held.
+ */
+#define _immediate_set(var, i) \
+	(var)->value = (i); \
+	immediate_update(0);
+
+/**
+ * immediate_set_early - set immediate variable at early boot
+ * @var: pointer of type immediate_*_t
+ * @i: required value
+ *
+ * Sets the value of @var. Should be used for early boot updates.
+ */
+#define immediate_set_early(var, i) \
+	(var)->value = (i); \
+	immediate_update_early();
+
+/**
+ * immediate_if - if () statement depending on an immediate value
+ * @var: pointer of type immediate_*_t
+ *
+ * Use as an if () statement depending on an immediate value.
+ * Do not use in __init and __exit functions. Use _immediate_if() instead.
+ * Branch depending on an immediate value. Could eventually be optimized further
+ * by improving gcc to give the ability to patch a jump instruction instead of
+ * the value it depends on.
+ */
+#define immediate_if(var)	if (unlikely(immediate_read(var)))
+
+/*
+ * Internal update functions.
+ */
+extern void immediate_update(int lock);
+extern void module_immediate_setup(struct module *mod);
+extern void immediate_update_early(void);
+extern int arch_immediate_update(const struct __immediate *immediate);
+extern void arch_immediate_update_early(const struct __immediate *immediate);
+
+#endif /* _ASM_I386_IMMEDIATE_H */
Index: linux-2.6-lttng/arch/i386/kernel/Makefile
===================================================================
--- linux-2.6-lttng.orig/arch/i386/kernel/Makefile	2007-08-09 18:31:43.000000000 -0400
+++ linux-2.6-lttng/arch/i386/kernel/Makefile	2007-08-09 18:32:15.000000000 -0400
@@ -36,6 +36,7 @@ obj-$(CONFIG_MODULES)		+= module.o
 obj-y				+= sysenter.o vsyscall.o
 obj-$(CONFIG_ACPI_SRAT) 	+= srat.o
 obj-$(CONFIG_EFI) 		+= efi.o efi_stub.o
+obj-$(CONFIG_IMMEDIATE)		+= immediate.o
 obj-$(CONFIG_DOUBLEFAULT) 	+= doublefault.o
 obj-$(CONFIG_KGDB)		+= kgdb.o kgdb-jmp.o
 obj-$(CONFIG_VM86)		+= vm86.o
Index: linux-2.6-lttng/arch/i386/kernel/immediate.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/arch/i386/kernel/immediate.c	2007-08-10 13:46:40.000000000 -0400
@@ -0,0 +1,301 @@
+/*
+ * Immediate Value - i386 architecture specific code.
+ *
+ * Rationale
+ *
+ * Required because of :
+ * - Erratum 49 fix for Intel PIII.
+ * - Still present on newer processors : Intel Core 2 Duo Processor for Intel
+ *   Centrino Duo Processor Technology Specification Update, AH33.
+ *   Unsynchronized Cross-Modifying Code Operations Can Cause Unexpected
+ *   Instruction Execution Results.
+ *
+ * Permits immediate value modification by XMC with correct serialization.
+ *
+ * Reentrant for NMI and trap handler instrumentation. Permits XMC to a
+ * location that has preemption enabled because it involves no temporary or
+ * reused data structure.
+ *
+ * Quoting Richard J Moore, source of the information motivating this
+ * implementation which differs from the one proposed by Intel which is not
+ * suitable for kernel context (does not support NMI and would require disabling
+ * interrupts on every CPU for a long period) :
+ *
+ * "There is another issue to consider when looking into using probes other
+ * then int3:
+ *
+ * Intel erratum 54 - Unsynchronized Cross-modifying code - refers to the
+ * practice of modifying code on one processor where another has prefetched
+ * the unmodified version of the code. Intel states that unpredictable general
+ * protection faults may result if a synchronizing instruction (iret, int,
+ * int3, cpuid, etc ) is not executed on the second processor before it
+ * executes the pre-fetched out-of-date copy of the instruction.
+ *
+ * When we became aware of this I had a long discussion with Intel's
+ * microarchitecture guys. It turns out that the reason for this erratum
+ * (which incidentally Intel does not intend to fix) is because the trace
+ * cache - the stream of micorops resulting from instruction interpretation -
+ * cannot guaranteed to be valid. Reading between the lines I assume this
+ * issue arises because of optimization done in the trace cache, where it is
+ * no longer possible to identify the original instruction boundaries. If the
+ * CPU discoverers that the trace cache has been invalidated because of
+ * unsynchronized cross-modification then instruction execution will be
+ * aborted with a GPF. Further discussion with Intel revealed that replacing
+ * the first opcode byte with an int3 would not be subject to this erratum.
+ *
+ * So, is cmpxchg reliable? One has to guarantee more than mere atomicity."
+ *
+ * Overall design
+ *
+ * The algorithm proposed by Intel applies not so well in kernel context: it
+ * would imply disabling interrupts and looping on every CPUs while modifying
+ * the code and would not support instrumentation of code called from interrupt
+ * sources that cannot be disabled.
+ *
+ * Therefore, we use a different algorithm to respect Intel's erratum (see the
+ * quoted discussion above). We make sure that no CPU sees an out-of-date copy
+ * of a pre-fetched instruction by 1 - using a breakpoint, which skips the
+ * instruction that is going to be modified, 2 - issuing an IPI to every CPU to
+ * execute a sync_core(), to make sure that even when the breakpoint is removed,
+ * no cpu could possibly still have the out-of-date copy of the instruction,
+ * modify the now unused 2nd byte of the instruction, and then put back the
+ * original 1st byte of the instruction.
+ *
+ * It has exactly the same intent as the algorithm proposed by Intel, but
+ * it has less side-effects, scales better and supports NMI, SMI and MCE.
+ *
+ * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
+ */
+
+#include <linux/notifier.h>
+#include <linux/preempt.h>
+#include <linux/smp.h>
+#include <linux/notifier.h>
+#include <linux/module.h>
+#include <linux/immediate.h>
+#include <linux/kdebug.h>
+#include <linux/rcupdate.h>
+#include <linux/kprobes.h>
+
+#include <asm/cacheflush.h>
+
+#define BREAKPOINT_INSTRUCTION  0xcc
+#define BREAKPOINT_INS_LEN	1
+#define NOP_INSTRUCTION		0x90
+#define NR_NOPS			8
+
+static long target_after_int3;		/* EIP of the target after the int3 */
+static long bypass_eip;			/* EIP of the bypass. */
+static long bypass_after_int3;		/* EIP after the end-of-bypass int3 */
+static long after_immediate;		/*
+					 * EIP where to resume after the
+					 * single-stepping.
+					 */
+
+/*
+ * Size of the movl instruction (without the immediate value) in bytes.
+ * The 2 bytes load immediate has a 66H prefix, which makes the opcode 2 bytes
+ * wide.
+ */
+static inline size_t _immediate_get_insn_size(long size)
+{
+	switch (size) {
+		case 1: return 1;
+		case 2: return 2;
+		case 4: return 1;
+		default: BUG();
+	};
+}
+
+/*
+ * Internal bypass used during value update. The bypass is skipped by the
+ * function in which it is inserted.
+ * No need to be aligned because we exclude readers from the site during
+ * update.
+ * Layout is:
+ * nop nop nop nop nop nop nop nop int3
+ * The nops are the target replaced by the instruction to single-step.
+ */
+static inline void _immediate_bypass(long *bypassaddr, long *breaknextaddr)
+{
+		asm volatile (	"jmp 2f;\n\t"
+				"0:\n\t"
+				".space 8, 0x90;\n\t"
+				"1:\n\t"
+				"int3;\n\t"
+				"2:\n\t"
+				"movl $(0b),%0;\n\t"
+				"movl $((1b)+1),%1;\n\t"
+				: "=r" (*bypassaddr),
+				  "=r" (*breaknextaddr) : );
+}
+
+static void immediate_synchronize_core(void *info)
+{
+	sync_core();	/* use cpuid to stop speculative execution */
+}
+
+/*
+ * The eip value points right after the breakpoint instruction, in the second
+ * byte of the movl.
+ * Disable preemption in the bypass to make sure no thread will be preempted in
+ * it. We can then use synchronize_sched() to make sure every bypass users have
+ * ended.
+ */
+static int immediate_notifier(struct notifier_block *nb,
+	unsigned long val, void *data)
+{
+	enum die_val die_val = (enum die_val) val;
+	struct die_args *args = data;
+
+	if (!args->regs || user_mode_vm(args->regs))
+		return NOTIFY_DONE;
+
+	if (die_val == DIE_INT3) {
+		if (args->regs->eip == target_after_int3) {
+			preempt_disable();
+			args->regs->eip = bypass_eip;
+			return NOTIFY_STOP;
+		} else if (args->regs->eip == bypass_after_int3) {
+			args->regs->eip = after_immediate;
+			preempt_enable();
+			return NOTIFY_STOP;
+		}
+	}
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block immediate_notify = {
+	.notifier_call = immediate_notifier,
+	.priority = 0x7fffffff,	/* we need to be notified first */
+};
+
+
+/**
+ * arch_immediate_update - update one immediate value
+ * @immediate: pointer of type const struct __immediate to update
+ *
+ * Update one immediate value. Must be called with immediate_mutex held.
+ */
+__kprobes int arch_immediate_update(const struct __immediate *immediate)
+{
+	int ret;
+	size_t insn_size = _immediate_get_insn_size(immediate->size);
+	long insn = immediate->immediate - insn_size;
+	long bypass_immediate;
+
+#ifdef CONFIG_KPROBES
+	/*
+	 * Fail if a kprobe has been set on this instruction.
+	 * (TODO: we could eventually do better and modify all the (possibly
+	 * nested) kprobes for this site if kprobes had an API for this.
+	 */
+	if (unlikely(*(unsigned char*)insn == BREAKPOINT_INSTRUCTION)) {
+		printk(KERN_WARNING "Immediate value in conflict with kprobe. "
+				    "Variable at %p, "
+				    "instruction at %p, size %lu\n",
+				    (void*)immediate->immediate,
+				    (void*)immediate->var, immediate->size);
+		return -EBUSY;
+	}
+#endif
+
+	/*
+	 * If the variable and the instruction have the same value, there is
+	 * nothing to do.
+	 */
+	switch (immediate->size) {
+		case 1:	if (*(uint8_t*)immediate->immediate
+					== *(uint8_t*)immediate->var)
+				return 0;
+			break;
+		case 2:	if (*(uint16_t*)immediate->immediate
+					== *(uint16_t*)immediate->var)
+				return 0;
+			break;
+		case 4:	if (*(uint32_t*)immediate->immediate
+					== *(uint32_t*)immediate->var)
+				return 0;
+			break;
+		default:return -EINVAL;
+	}
+
+	_immediate_bypass(&bypass_eip, &bypass_after_int3);
+
+	after_immediate = immediate->immediate + immediate->size;
+
+	kernel_text_mark_rw((unsigned long)bypass_eip, NR_NOPS);
+	memcpy(bypass_eip, (void*)insn, insn_size + immediate->size);
+	/*
+	 * Fill the rest with nops.
+	 */
+	memset((void*)((unsigned long)bypass_eip + insn_size + immediate->size),
+		NOP_INSTRUCTION,
+		NR_NOPS - immediate->size - insn_size);
+	kernel_text_unmark((unsigned long)bypass_eip, NR_NOPS);
+
+	kernel_text_mark_rw((unsigned long)insn, insn_size + immediate->size);
+	target_after_int3 = insn + BREAKPOINT_INS_LEN;
+	/* register_die_notifier has memory barriers */
+	register_die_notifier(&immediate_notify);
+	/* The breakpoint will single-step the bypass */
+	*(char*)insn = BREAKPOINT_INSTRUCTION;
+	wmb();
+	/*
+	 * Execute serializing instruction on each CPU.
+	 * Acts as a memory barrier.
+	 */
+	ret = on_each_cpu(immediate_synchronize_core, NULL, 1, 1);
+	BUG_ON(ret != 0);
+
+	memcpy((void*)(insn + insn_size), (void*)immediate->var,
+			immediate->size);
+	wmb();
+	*(char*)insn = *(char*)bypass_eip;
+	kernel_text_unmark((unsigned long)insn, insn_size + immediate->size);
+		/*
+		 * Wait for all int3 handlers to end
+		 * (interrupts are disabled in int3).
+		 * This CPU is clearly not in a int3 handler,
+		 * because int3 handler is not preemptible and
+		 * there cannot be any more int3 handler called
+		 * for this site, because we placed the original
+		 * instruction back.
+		 * synchronize_sched has memory barriers.
+		 */
+	synchronize_sched();
+	unregister_die_notifier(&immediate_notify);
+	/* unregister_die_notifier has memory barriers */
+	return 0;
+}
+
+/**
+ * arch_immediate_update_early - update one immediate value at boot time
+ * @immediate: pointer of type const struct __immediate to update
+ *
+ * Update one immediate value at boot time.
+ */
+void __init arch_immediate_update_early(const struct __immediate *immediate)
+{
+	/*
+	 * If the variable and the instruction have the same value, there is
+	 * nothing to do.
+	 */
+	switch (immediate->size) {
+		case 1:	if (*(uint8_t*)immediate->immediate
+					== *(uint8_t*)immediate->var)
+				return;
+			break;
+		case 2:	if (*(uint16_t*)immediate->immediate
+					== *(uint16_t*)immediate->var)
+				return;
+			break;
+		case 4:	if (*(uint32_t*)immediate->immediate
+					== *(uint32_t*)immediate->var)
+				return;
+			break;
+		default:return;
+	}
+	memcpy((void*)immediate->immediate, (void*)immediate->var,
+			immediate->size);
+}
Index: linux-2.6-lttng/arch/i386/kernel/traps.c
===================================================================
--- linux-2.6-lttng.orig/arch/i386/kernel/traps.c	2007-08-09 18:31:43.000000000 -0400
+++ linux-2.6-lttng/arch/i386/kernel/traps.c	2007-08-10 13:46:54.000000000 -0400
@@ -564,7 +564,7 @@ fastcall void do_##name(struct pt_regs *
 }
 
 DO_VM86_ERROR_INFO( 0, SIGFPE,  "divide error", divide_error, FPE_INTDIV, regs->eip)
-#ifndef CONFIG_KPROBES
+#if !defined(CONFIG_KPROBES) && !defined(CONFIG_IMMEDIATE)
 DO_VM86_ERROR( 3, SIGTRAP, "int3", int3)
 #endif
 DO_VM86_ERROR( 4, SIGSEGV, "overflow", overflow)
@@ -799,14 +799,14 @@ void restart_nmi(void)
 	acpi_nmi_enable();
 }
 
-#ifdef CONFIG_KPROBES
+#if defined(CONFIG_KPROBES) || defined(CONFIG_IMMEDIATE)
 fastcall void __kprobes do_int3(struct pt_regs *regs, long error_code)
 {
 	if (notify_die(DIE_INT3, "int3", regs, error_code, 3, SIGTRAP)
 			== NOTIFY_STOP)
 		return;
-	/* This is an interrupt gate, because kprobes wants interrupts
-	disabled.  Normal trap handlers don't. */
+	/* This is an interrupt gate, because kprobes and immediate values wants
+	 * interrupts disabled. Normal trap handlers don't. */
 	restore_interrupts(regs);
 	do_trap(3, SIGTRAP, "int3", 1, regs, error_code, NULL);
 }

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
