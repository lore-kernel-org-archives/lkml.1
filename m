Return-Path: <linux-kernel-owner+w=401wt.eu-S934870AbXKPUKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934870AbXKPUKp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 15:10:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934776AbXKPUGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 15:06:05 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:46742 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934768AbXKPUGB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 15:06:01 -0500
Message-Id: <20071116200514.380047811@polymtl.ca>
References: <20071116200238.740495156@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Fri, 16 Nov 2007 15:02:44 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, Andi Kleen <ak@muc.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Chuck Ebbert <cebbert@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [rfc-patch 6/9] Immediate Values - x86 Optimization
Content-Disposition: inline; filename=immediate-values-x86-optimization.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Fri, 16 Nov 2007 20:05:15 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

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

- Create the instruction in a discarded section to calculate its size. This is
  how we can align the beginning of the instruction on an address that will
  permit atomic modificatino of the immediate value without knowing the size of
  the opcode used by the compiler.
- Bugfix : 8 bytes 64 bits immediate value was declared as "4 bytes" in the
  immediate structure.
- Change the immediate.c update code to support variable length opcodes.

- Vastly simplified, using a busy looping IPI with interrupts disabled.
  Does not protect against NMI nor MCE.
- Pack the __immediate section. Use smallest types required for size (char).

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Andi Kleen <ak@muc.de>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Chuck Ebbert <cebbert@redhat.com>
CC: Christoph Hellwig <hch@infradead.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/x86/Kconfig            |    1 
 arch/x86/kernel/Makefile_32 |    1 
 arch/x86/kernel/Makefile_64 |    1 
 arch/x86/kernel/immediate.c |  153 ++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/traps_32.c  |   10 +-
 include/asm-x86/immediate.h |  110 +++++++++++++++++++++++++++++++
 6 files changed, 272 insertions(+), 4 deletions(-)

Index: linux-2.6-lttng/arch/x86/kernel/Makefile_32
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kernel/Makefile_32	2007-11-16 11:37:44.000000000 -0500
+++ linux-2.6-lttng/arch/x86/kernel/Makefile_32	2007-11-16 11:37:50.000000000 -0500
@@ -35,6 +35,7 @@ obj-$(CONFIG_KPROBES)		+= kprobes_32.o
 obj-$(CONFIG_MODULES)		+= module_32.o
 obj-y				+= sysenter_32.o vsyscall_32.o
 obj-$(CONFIG_ACPI_SRAT) 	+= srat_32.o
+obj-$(CONFIG_IMMEDIATE)		+= immediate.o
 obj-$(CONFIG_EFI) 		+= efi_32.o efi_stub_32.o
 obj-$(CONFIG_DOUBLEFAULT) 	+= doublefault_32.o
 obj-$(CONFIG_VM86)		+= vm86_32.o
Index: linux-2.6-lttng/arch/x86/kernel/traps_32.c
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kernel/traps_32.c	2007-11-16 11:37:44.000000000 -0500
+++ linux-2.6-lttng/arch/x86/kernel/traps_32.c	2007-11-16 12:31:23.000000000 -0500
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
+++ linux-2.6-lttng/include/asm-x86/immediate.h	2007-11-16 12:08:45.000000000 -0500
@@ -0,0 +1,110 @@
+#ifndef _ASM_X86_IMMEDIATE_H
+#define _ASM_X86_IMMEDIATE_H
+
+/*
+ * Immediate values. x86 architecture optimizations.
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
+	unsigned long var;	/* Pointer to the identifier variable of the
+				 * immediate value
+				 */
+	unsigned long immediate;/*
+				 * Pointer to the memory location of the
+				 * immediate value within the instruction.
+				 */
+	unsigned char size;	/* Type size. */
+} __attribute__ ((packed));
+
+/**
+ * immediate_read - read immediate variable
+ * @name: immediate value name
+ *
+ * Reads the value of @name.
+ * Optimized version of the immediate.
+ * Do not use in __init and __exit functions. Use _immediate_read() instead.
+ * If size is bigger than the architecture long size, fall back on a memory
+ * read.
+ *
+ * Make sure to populate the initial static 64 bits opcode with a value
+ * what will generate an instruction with 8 bytes immediate value (not the REX.W
+ * prefixed one that loads a sign extended 32 bits immediate value in a r64
+ * register).
+ *
+ * Create the instruction in a discarded section to calculate its size. This is
+ * how we can align the beginning of the instruction on an address that will
+ * permit atomic modification of the immediate value without knowing the size of
+ * the opcode used by the compiler. The operand size is known in advance.
+ */
+#define immediate_read(name)						\
+	({								\
+		__typeof__(name##__immediate) value;			\
+		switch (sizeof(value)) {				\
+		case 1:							\
+			asm(".section __immediate,\"a\",@progbits\n\t"	\
+				_ASM_PTR "%c1, (3f)-%c2\n\t"		\
+				".byte %c2\n\t"				\
+				".previous\n\t"				\
+				"2:\n\t"				\
+				"mov $0,%0\n\t"				\
+				"3:\n\t"				\
+				: "=q" (value)				\
+				: "i" (&name##__immediate),		\
+				  "i" (sizeof(value)));			\
+			break;						\
+		case 2:							\
+		case 4:							\
+			asm(".section __discard,\"\",@progbits\n\t"	\
+				"1:\n\t"				\
+				"mov $0,%0\n\t"				\
+				"2:\n\t"				\
+				".previous\n\t"				\
+				".section __immediate,\"a\",@progbits\n\t" \
+				_ASM_PTR "%c1, (3f)-%c2\n\t"		\
+				".byte %c2\n\t"				\
+				".previous\n\t"				\
+				".org . + ((-.-(2b-1b)) & (%c2-1)), 0x90\n\t" \
+				"mov $0,%0\n\t"				\
+				"3:\n\t"				\
+				: "=r" (value)				\
+				: "i" (&name##__immediate),		\
+				  "i" (sizeof(value)));			\
+			break;						\
+		case 8:							\
+			if (sizeof(long) < 8) {				\
+				value = name##__immediate;		\
+				break;					\
+			}						\
+			asm(".section __discard,\"\",@progbits\n\t"	\
+				"1:\n\t"				\
+				"mov $0xFEFEFEFE01010101,%0\n\t" 	\
+				"2:\n\t"				\
+				".previous\n\t"				\
+				".section __immediate,\"a\",@progbits\n\t" \
+				_ASM_PTR "%c1, (3f)-%c2\n\t"		\
+				".byte %c2\n\t"				\
+				".previous\n\t"				\
+				".org . + ((-.-(2b-1b)) & (%c2-1)), 0x90\n\t" \
+				"mov $0xFEFEFEFE01010101,%0\n\t" 	\
+				"3:\n\t"				\
+				: "=r" (value)				\
+				: "i" (&name##__immediate),		\
+				  "i" (sizeof(value)));			\
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
+#endif /* _ASM_X86_IMMEDIATE_H */
Index: linux-2.6-lttng/arch/x86/kernel/immediate.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/arch/x86/kernel/immediate.c	2007-11-16 12:08:45.000000000 -0500
@@ -0,0 +1,153 @@
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
+ * Non reentrant for NMI and trap handler instrumentation.
+ *
+ * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
+ */
+
+#include <linux/preempt.h>
+#include <linux/smp.h>
+#include <linux/notifier.h>
+#include <linux/module.h>
+#include <linux/immediate.h>
+#include <linux/cpu.h>
+
+static atomic_t wait_sync;
+
+static void ipi_busy_loop(void *arg)
+{
+	long value = (long)arg;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	atomic_dec(&wait_sync);
+	do {
+		/* Make sure the wait_sync gets re-read */
+		smp_mb();
+	} while (atomic_read(&wait_sync) > value);
+	atomic_dec(&wait_sync);
+	do {
+		/* Make sure the wait_sync gets re-read */
+		smp_mb();
+	} while (atomic_read(&wait_sync) > 0);
+	/*
+	 * Issuing a synchronizing instruction must be done on each CPU before
+	 * reenabling interrupts after modifying an instruction. Required by
+	 * Intel's errata.
+	 */
+	sync_core();
+	local_irq_restore(flags);
+}
+
+/**
+ * arch_immediate_update - update one immediate value
+ * @immediate: pointer of type const struct __immediate to update
+ *
+ * Update one immediate value. Must be called with immediate_mutex held.
+ * It makes sure all CPUs are not executing the modified code by having them
+ * busy looping with interrupts disabled.
+ * It does _not_ protect against NMI and MCE (could be a problem with Intel's
+ * errata if we use immediate values in their code path).
+ */
+int arch_immediate_update(const struct __immediate *immediate)
+{
+	unsigned long flags;
+	long online_cpus;
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
+	lock_cpu_hotplug();
+	online_cpus = num_online_cpus();
+	atomic_set(&wait_sync, 2 * online_cpus);
+	smp_call_function(ipi_busy_loop, (void *)online_cpus, 1, 0);
+	local_irq_save(flags);
+	atomic_dec(&wait_sync);
+	do {
+		/* Make sure the wait_sync gets re-read */
+		smp_mb();
+	} while (atomic_read(&wait_sync) > online_cpus);
+	text_poke((void *)immediate->immediate, (void *)immediate->var,
+			immediate->size);
+	/*
+	 * Make sure the modified instruction is seen by all CPUs before we
+	 * continue (visible to other CPUs and local interrupts).
+	 */
+	wmb();
+	atomic_dec(&wait_sync);
+	local_irq_restore(flags);
+	unlock_cpu_hotplug();
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
--- linux-2.6-lttng.orig/arch/x86/kernel/Makefile_64	2007-11-16 11:37:44.000000000 -0500
+++ linux-2.6-lttng/arch/x86/kernel/Makefile_64	2007-11-16 11:37:50.000000000 -0500
@@ -35,6 +35,7 @@ obj-$(CONFIG_X86_PM_TIMER)	+= pmtimer_64
 obj-$(CONFIG_X86_VSMP)		+= vsmp_64.o
 obj-$(CONFIG_K8_NB)		+= k8.o
 obj-$(CONFIG_AUDIT)		+= audit_64.o
+obj-$(CONFIG_IMMEDIATE)		+= immediate.o
 
 obj-$(CONFIG_MODULES)		+= module_64.o
 obj-$(CONFIG_PCI)		+= early-quirks.o
Index: linux-2.6-lttng/arch/x86/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/x86/Kconfig	2007-11-16 11:37:44.000000000 -0500
+++ linux-2.6-lttng/arch/x86/Kconfig	2007-11-16 12:31:21.000000000 -0500
@@ -21,6 +21,7 @@ config X86
 	default y
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
+	select HAVE_IMMEDIATE
 
 config GENERIC_TIME
 	bool

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
