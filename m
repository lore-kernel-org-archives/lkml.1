Return-Path: <linux-kernel-owner+w=401wt.eu-S1757422AbXKNBpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422AbXKNBpA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 20:45:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754710AbXKNBou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 20:44:50 -0500
Received: from tomts10.bellnexxia.net ([209.226.175.54]:51362 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754534AbXKNBot convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 20:44:49 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HADfhOUdMROHU/2dsb2JhbACBW45t
Date: Tue, 13 Nov 2007 20:44:45 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@muc.de>, Chuck Ebbert <cebbert@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [patch 5/8] Immediate Values - x86 Optimization (update 2)
Message-ID: <20071114014445.GB19901@Krystal>
References: <20071113192445.GA1463@Krystal> <4739FCA0.4040702@zytor.com> <20071113194550.GA4400@Krystal> <473A017D.2030501@zytor.com> <20071113204033.GB7450@Krystal> <473A166E.3070708@zytor.com> <20071113220227.GB9057@Krystal> <473A26A2.7090007@zytor.com> <20071114003409.GA18032@Krystal> <473A4909.1020609@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <473A4909.1020609@zytor.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 20:43:13 up 10 days,  6:48,  4 users,  load average: 1.87, 0.90,
	0.68
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Immediate Values - x86 Optimization

x86 optimization of the immediate values which uses a movl with code patching
to set/unset the value used to populate the register used as variable source.

Changelog:
- Use text_poke_early with cr0 WP save/restore to patch the bypass. We are doing
  non atomic writes to a code region only touched by us (nobody can execute it
  since we are protected by the immediate_mutex).
- Put immediate_set and _immediate_set in the architecture independent header.
- Use $0 instead of %2 with (0) operand.
- Add x86_64 support, ready for i386+x86_64 -> x86 merge.
- Use asm-x86/asm.h.

Ok, so the most flexible solution that I see, that should fit for both
i386 and x86_64 would be :
1 byte  : "=Q" : Any register accessible as rh: a, b, c, and d.
2, 4 bytes : "=R" : Legacy register—the eight integer registers available
                 on all i386 processors (a, b, c, d, si, di, bp, sp). 8
bytes : (only for x86_64)
          "=r" : A register operand is allowed provided that it is in a
                 general register.
That should make sure x86_64 won't try to use REX prefixed opcodes for
1, 2 and 4 bytes values.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Andi Kleen <ak@muc.de>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Chuck Ebbert <cebbert@redhat.com>
CC: Christoph Hellwig <hch@infradead.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>
---
 arch/x86/Kconfig.i386       |    3 
 arch/x86/Kconfig.x86_64     |    3 
 arch/x86/kernel/Makefile_32 |    1 
 arch/x86/kernel/Makefile_64 |    1 
 arch/x86/kernel/immediate.c |  330 ++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/traps_32.c  |   10 -
 include/asm-x86/immediate.h |  109 ++++++++++++++
 7 files changed, 453 insertions(+), 4 deletions(-)

Index: linux-2.6-lttng/arch/x86/kernel/Makefile_32
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kernel/Makefile_32	2007-11-13 17:06:16.000000000 -0500
+++ linux-2.6-lttng/arch/x86/kernel/Makefile_32	2007-11-13 20:12:34.000000000 -0500
@@ -34,6 +34,7 @@ obj-$(CONFIG_KPROBES)		+= kprobes_32.o
 obj-$(CONFIG_MODULES)		+= module_32.o
 obj-y				+= sysenter_32.o vsyscall_32.o
 obj-$(CONFIG_ACPI_SRAT) 	+= srat_32.o
+obj-$(CONFIG_IMMEDIATE)		+= immediate.o
 obj-$(CONFIG_EFI) 		+= efi_32.o efi_stub_32.o
 obj-$(CONFIG_DOUBLEFAULT) 	+= doublefault_32.o
 obj-$(CONFIG_VM86)		+= vm86_32.o
Index: linux-2.6-lttng/arch/x86/kernel/traps_32.c
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kernel/traps_32.c	2007-11-13 17:06:16.000000000 -0500
+++ linux-2.6-lttng/arch/x86/kernel/traps_32.c	2007-11-13 20:12:34.000000000 -0500
@@ -544,7 +544,7 @@ fastcall void do_##name(struct pt_regs *
 }
 
 DO_VM86_ERROR_INFO( 0, SIGFPE,  "divide error", divide_error, FPE_INTDIV, regs->eip)
-#ifndef CONFIG_KPROBES
+#if !defined(CONFIG_KPROBES) && !defined(CONFIG_IMMEDIATE)
 DO_VM86_ERROR( 3, SIGTRAP, "int3", int3)
 #endif
 DO_VM86_ERROR( 4, SIGSEGV, "overflow", overflow)
@@ -786,7 +786,7 @@ void restart_nmi(void)
 	acpi_nmi_enable();
 }
 
-#ifdef CONFIG_KPROBES
+#if defined(CONFIG_KPROBES) || defined(CONFIG_IMMEDIATE)
 fastcall void __kprobes do_int3(struct pt_regs *regs, long error_code)
 {
 	trace_hardirqs_fixup();
@@ -794,8 +794,10 @@ fastcall void __kprobes do_int3(struct p
 	if (notify_die(DIE_INT3, "int3", regs, error_code, 3, SIGTRAP)
 			== NOTIFY_STOP)
 		return;
-	/* This is an interrupt gate, because kprobes wants interrupts
-	disabled.  Normal trap handlers don't. */
+	/*
+	 * This is an interrupt gate, because kprobes and immediate values wants
+	 * interrupts disabled.  Normal trap handlers don't.
+	 */
 	restore_interrupts(regs);
 	do_trap(3, SIGTRAP, "int3", 1, regs, error_code, NULL);
 }
Index: linux-2.6-lttng/include/asm-x86/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-x86/immediate.h	2007-11-13 20:16:05.000000000 -0500
@@ -0,0 +1,109 @@
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
+#include <asm/asm.h>
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
+} __attribute__ ((aligned(sizeof(long))));
+
+/**
+ * immediate_read - read immediate variable
+ * @name: immediate value name
+ *
+ * Reads the value of @name.
+ * Optimized version of the immediate.
+ * Do not use in __init and __exit functions. Use _immediate_read() instead.
+ * Makes sure the 2 and 4 bytes update will be atomic by aligning the immediate
+ * value. 2 bytes (short) uses a 66H prefix. If size is bigger than 4 bytes,
+ * fall back on a memory read.
+ * The 64 bits load immediates produced by gas have a 2 bytes opcode.
+ * Make sure to populate the initial static 64 bits opcode with a value
+ * what will generate an instruction with 2 bytes opcode and 8 bytes immediate
+ * value.
+ * A solution that should fit for both i386 and x86_64 would be :
+ * 1 byte  : "=Q" : Any register accessible as rh: a, b, c, and d.
+ * 2, 4 bytes : "=R" : Legacy register—the eight integer registers available
+ *               on all i386 processors (a, b, c, d, si, di, bp, sp).
+ * 8 bytes : (only for x86_64)
+ *              "=r" : A register operand is allowed provided that it is in a
+ *              general register.
+ * That should make sure x86_64 won't try to use REX prefixed opcodes for
+ * 1, 2 and 4 bytes values.
+ */
+#define immediate_read(name)						\
+	({								\
+		__typeof__(name##__immediate) value;			\
+		switch (sizeof(value)) {				\
+		case 1:							\
+			asm(".section __immediate,\"a\",@progbits\n\t"	\
+					_ASM_PTR "%c1, (0f)+1, 1\n\t"	\
+					".previous\n\t"			\
+					"0:\n\t"			\
+					"mov $0,%0\n\t"			\
+				: "=Q" (value)				\
+				: "i" (&name##__immediate));		\
+			break;						\
+		case 2:							\
+			asm(".section __immediate,\"a\",@progbits\n\t"	\
+					_ASM_PTR "%c1, (0f)+2, 2\n\t"	\
+					".previous\n\t"			\
+					"1:\n\t"			\
+					".align 2\n\t"			\
+					"0:\n\t"			\
+					"mov $0,%0\n\t"			\
+				: "=R" (value)				\
+				: "i" (&name##__immediate));		\
+			break;						\
+		case 4:							\
+			asm(".section __immediate,\"a\",@progbits\n\t"	\
+					_ASM_PTR "%c1, (0f)+1, 4\n\t"	\
+					".previous\n\t"			\
+					"1:\n\t"			\
+					".org . + 3 - (. & 3), 0x90\n\t" \
+					"0:\n\t"			\
+					"mov $0,%0\n\t"			\
+				: "=R" (value)				\
+				: "i" (&name##__immediate));		\
+			break;						\
+		case 8:							\
+			if (sizeof(long) < 8) {				\
+				value = name##__immediate;		\
+				break;					\
+			}						\
+			asm(".section __immediate,\"a\",@progbits\n\t"	\
+					_ASM_PTR "%c1, (0f)+1, 4\n\t"	\
+					".previous\n\t"			\
+					"1:\n\t"			\
+					".org . + 6 - (. & 7), 0x90\n\t" \
+					"0:\n\t"			\
+					"mov $0xFEFEFEFE01010101,%0\n\t" \
+				: "=r" (value)				\
+				: "i" (&name##__immediate));		\
+			break;						\
+		default:value = name##__immediate;			\
+			break;						\
+		};							\
+		value;							\
+	})
+
+extern int arch_immediate_update(const struct __immediate *immediate);
+extern void arch_immediate_update_early(const struct __immediate *immediate);
+
+#endif /* _ASM_I386_IMMEDIATE_H */
Index: linux-2.6-lttng/arch/x86/kernel/immediate.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/arch/x86/kernel/immediate.c	2007-11-13 20:12:34.000000000 -0500
@@ -0,0 +1,330 @@
+/*
+ * Immediate Value - x86 architecture specific code.
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
+ * cache - the stream of micro-ops resulting from instruction interpretation -
+ * cannot be guaranteed to be valid. Reading between the lines I assume this
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
+#define NR_NOPS			10
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
+	case 1: return 1;
+	case 2: return 2;
+	case 4: return 1;
+#ifdef CONFIG_X86_64
+	case 8: return 2;
+#endif
+	default: BUG();
+	};
+}
+
+/*
+ * Internal bypass used during value update. The bypass is skipped by the
+ * function in which it is inserted.
+ * No need to be aligned because we exclude readers from the site during
+ * update.
+ * Layout is:
+ * (10x nop) int3
+ * (maximum size is 2 bytes opcode + 8 bytes immediate value for long on x86_64)
+ * The nops are the target replaced by the instruction to single-step.
+ */
+static inline void _immediate_bypass(long *bypassaddr, long *breaknextaddr)
+{
+		asm volatile("jmp 2f;\n\t"
+				"0:\n\t"
+				".space 10, 0x90;\n\t"
+				"1:\n\t"
+				"int3;\n\t"
+				"2:\n\t"
+				"mov $(0b),%0;\n\t"
+				"mov $((1b)+1),%1;\n\t"
+				: "=r" (*bypassaddr),
+				  "=r" (*breaknextaddr));
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
+		if (instruction_pointer(args->regs) == target_after_int3) {
+			preempt_disable();
+			instruction_pointer(args->regs) = bypass_eip;
+			return NOTIFY_STOP;
+		} else if (instruction_pointer(args->regs)
+				== bypass_after_int3) {
+			instruction_pointer(args->regs) = after_immediate;
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
+	long len;
+	unsigned long cr0;
+
+#ifdef CONFIG_KPROBES
+	/*
+	 * Fail if a kprobe has been set on this instruction.
+	 * (TODO: we could eventually do better and modify all the (possibly
+	 * nested) kprobes for this site if kprobes had an API for this.
+	 */
+	if (unlikely(*(unsigned char *)insn == BREAKPOINT_INSTRUCTION)) {
+		printk(KERN_WARNING "Immediate value in conflict with kprobe. "
+				    "Variable at %p, "
+				    "instruction at %p, size %lu\n",
+				    (void *)immediate->immediate,
+				    (void *)immediate->var, immediate->size);
+		return -EBUSY;
+	}
+#endif
+
+	/*
+	 * If the variable and the instruction have the same value, there is
+	 * nothing to do.
+	 */
+	switch (immediate->size) {
+	case 1:	if (*(uint8_t *)immediate->immediate
+				== *(uint8_t *)immediate->var)
+			return 0;
+		break;
+	case 2:	if (*(uint16_t *)immediate->immediate
+				== *(uint16_t *)immediate->var)
+			return 0;
+		break;
+	case 4:	if (*(uint32_t *)immediate->immediate
+				== *(uint32_t *)immediate->var)
+			return 0;
+		break;
+#ifdef CONFIG_X86_64
+	case 8:	if (*(uint64_t *)immediate->immediate
+				== *(uint64_t *)immediate->var)
+			return 0;
+		break;
+#endif
+	default:return -EINVAL;
+	}
+
+	_immediate_bypass(&bypass_eip, &bypass_after_int3);
+
+	after_immediate = immediate->immediate + immediate->size;
+
+	/*
+	 * Using the _early variants because nobody is executing the
+	 * bypass code while we patch it. It is protected by the
+	 * immediate_mutex. Since we modify the instructions non atomically (for
+	 * nops), we have to use the _early variant.
+	 * We must however deal with the WP flag in cr0 by ourself.
+	 */
+	kernel_wp_save(cr0);
+	text_poke_early((void *)bypass_eip, (void *)insn,
+			insn_size + immediate->size);
+	/*
+	 * Fill the rest with nops.
+	 */
+	len = NR_NOPS - immediate->size - insn_size;
+	add_nops((void *)(bypass_eip + insn_size + immediate->size), len);
+	kernel_wp_restore(cr0);
+
+	target_after_int3 = insn + BREAKPOINT_INS_LEN;
+	/* register_die_notifier has memory barriers */
+	register_die_notifier(&immediate_notify);
+	/* The breakpoint will single-step the bypass */
+	text_poke((void *)insn,
+		INIT_ARRAY(unsigned char, BREAKPOINT_INSTRUCTION, 1), 1);
+	/*
+	 * Make sure the breakpoint is set before we continue (visible to other
+	 * CPUs and interrupts).
+	 */
+	wmb();
+	/*
+	 * Execute serializing instruction on each CPU.
+	 */
+	ret = on_each_cpu(immediate_synchronize_core, NULL, 1, 1);
+	BUG_ON(ret != 0);
+
+	text_poke((void *)(insn + insn_size), (void *)immediate->var,
+			immediate->size);
+	/*
+	 * Make sure the value can be seen from other CPUs and interrupts.
+	 */
+	wmb();
+	text_poke((void *)insn, (unsigned char *)bypass_eip, 1);
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
+void arch_immediate_update_early(const struct __immediate *immediate)
+{
+	/*
+	 * If the variable and the instruction have the same value, there is
+	 * nothing to do.
+	 */
+	switch (immediate->size) {
+	case 1:	if (*(uint8_t *)immediate->immediate
+				== *(uint8_t *)immediate->var)
+			return;
+		break;
+	case 2:	if (*(uint16_t *)immediate->immediate
+				== *(uint16_t *)immediate->var)
+			return;
+		break;
+	case 4:	if (*(uint32_t *)immediate->immediate
+				== *(uint32_t *)immediate->var)
+			return;
+		break;
+#ifdef CONFIG_X86_64
+	case 8:	if (*(uint64_t *)immediate->immediate
+				== *(uint64_t *)immediate->var)
+			return;
+		break;
+#endif
+	default:return;
+	}
+	memcpy((void *)immediate->immediate, (void *)immediate->var,
+			immediate->size);
+}
Index: linux-2.6-lttng/arch/x86/kernel/Makefile_64
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kernel/Makefile_64	2007-11-13 17:06:16.000000000 -0500
+++ linux-2.6-lttng/arch/x86/kernel/Makefile_64	2007-11-13 20:12:34.000000000 -0500
@@ -33,6 +33,7 @@ obj-$(CONFIG_X86_PM_TIMER)	+= pmtimer_64
 obj-$(CONFIG_X86_VSMP)		+= vsmp_64.o
 obj-$(CONFIG_K8_NB)		+= k8.o
 obj-$(CONFIG_AUDIT)		+= audit_64.o
+obj-$(CONFIG_IMMEDIATE)		+= immediate.o
 
 obj-$(CONFIG_MODULES)		+= module_64.o
 obj-$(CONFIG_PCI)		+= early-quirks.o
Index: linux-2.6-lttng/arch/x86/Kconfig.i386
===================================================================
--- linux-2.6-lttng.orig/arch/x86/Kconfig.i386	2007-11-13 17:06:16.000000000 -0500
+++ linux-2.6-lttng/arch/x86/Kconfig.i386	2007-11-13 20:12:34.000000000 -0500
@@ -97,6 +97,9 @@ config ARCH_SUPPORTS_OPROFILE
 config ARCH_SUPPORTS_KPROBES
 	def_bool y
 
+config ARCH_SUPPORTS_IMMEDIATE
+	def_bool y
+
 source "init/Kconfig"
 
 menu "Processor type and features"
Index: linux-2.6-lttng/arch/x86/Kconfig.x86_64
===================================================================
--- linux-2.6-lttng.orig/arch/x86/Kconfig.x86_64	2007-11-13 17:06:16.000000000 -0500
+++ linux-2.6-lttng/arch/x86/Kconfig.x86_64	2007-11-13 20:12:34.000000000 -0500
@@ -139,6 +139,9 @@ config ARCH_SUPPORTS_OPROFILE
 config ARCH_SUPPORTS_KPROBES
 	def_bool y
 
+config ARCH_SUPPORTS_IMMEDIATE
+	def_bool y
+
 source "init/Kconfig"
 
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
