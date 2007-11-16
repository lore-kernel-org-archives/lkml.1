Return-Path: <linux-kernel-owner+w=401wt.eu-S932484AbXKPOIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932484AbXKPOIw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 09:08:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758209AbXKPOIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 09:08:42 -0500
Received: from tomts40.bellnexxia.net ([209.226.175.97]:39477 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752320AbXKPOIl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 09:08:41 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAMMzPUdMROHU/2dsb2JhbACBX457
Date: Fri, 16 Nov 2007 09:03:35 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@muc.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 5/8] Immediate Values - x86 Optimization (simplified)
Message-ID: <20071116140334.GA14930@Krystal>
References: <20071113185800.436425570@polymtl.ca> <200711151545.19359.rusty@rustcorp.com.au> <20071115053751.GB26338@Krystal> <200711152206.07519.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <200711152206.07519.rusty@rustcorp.com.au>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 08:59:26 up 12 days, 19:04,  4 users,  load average: 1.79, 1.27,
	0.74
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Rusty Russell (rusty@rustcorp.com.au) wrote:
> On Thursday 15 November 2007 16:37:51 Mathieu Desnoyers wrote:
> > * Rusty Russell (rusty@rustcorp.com.au) wrote:
> > > On Thursday 15 November 2007 15:06:10 Mathieu Desnoyers wrote:
> > > > A - the NMI or MCE code calls any external kernel code (printk,
> > > >   notify_die, spin_lock/unlock, die_nmi, lapic_wd_event (perfctr code,
> > > >   calls printk too for debugging)...
> > >
> > > Sure, but as I pointed out previously, such calls are already best
> > > effort. You can do very little safely from do_nmi(), and calling printk
> > > isn't one of them,
> >
> > yes and no.. do_nmi uses the "bust spinlocks" exactly for this. So this
> > is ok by design.
> 
> Yeah, in the "machine is dying" case, we do make best effort to get the 
> message out.  Worrying about a GPF on the off chance we happen to be 
> modifying an immediate in that case seems crazy.
> 
> > > nor is grabbing a spinlock (well, actually you could as long as it's
> > > *only* used by NMI handlers.  See any of those?).
> >
> > Yup, see arch/x86/kernel/nmi_64.c : nmi_watchdog_tick()
> >
> > It defines a spinlock to "Serialise the printks". I guess it's good to
> > protect against other nmi watchdogs running on other CPUs concurrently,
> > I guess.
> 
> So that when it's printing a backtrace from an NMI.
> 
> > > > Therefore, if one decides to use the immediate values to
> > > > leave dormant spinlock instrumentation in the kernel, I wouldn't want
> > > > it to have undesirable side-effects (GPF) when the instrumentation is
> > > > being enabled, as rare as it could be.
> > >
> > > It's overengineered, since it's less likely than deadlock already.
> >
> > So should we put a warning telling "enabling tracing or profiling on a
> > production system that also uses NMI watchdog could potentially cause a
> > crash"
> 
> Or, "if your system is crashing, this may make it worse".
> 
> > arch/x86/kernel/immediate.o : 2.4K
> >
> > let's compare..
> >
> > kernel/stop_machine.o : 3.9K
> >
> > so I think that code size is not an issue there, especially since the
> > immediate values are not meant to be deployed on embedded systems.
> 
> stop_machine is necessary (although it could use simplification, patches 
> pending).
> 
> > Yup, looping in IPIs with interrupts disabled should do the job there.
> > It's just awful for interrupt latency on large SMP systems :(
> 
> Yet you could have implemented it in the time it took us to have this 
> conversation.
> 
> Just because code is clever doesn't mean it should go in.  There are enough 
> things in the kernel which have to be complex that we should always be on the 
> lookout for things which can be made simpler.
> 
> Cheers,
> Rusty.

Ok, let's start with a simple version then. I'll plan to resubmit the
more sophisticated one when I submit a patch to make my markers use the
immediate values.

Here it is, for a first round of review :


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

- Create the instruction in a discarded section to calculate its size. This is
  how we can align the beginning of the instruction on an address that will
  permit atomic modificatino of the immediate value without knowing the size of
  the opcode used by the compiler.
- Bugfix : 8 bytes 64 bits immediate value was declared as "4 bytes" in the
  immediate structure.
- Change the immediate.c update code to support variable length opcodes.

- Vastly simplified, using a busy looping IPI with interrupts disabled.
  Does not protect against NMI nor MCE.

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
 arch/x86/kernel/immediate.c |  143 ++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/traps_32.c  |   10 +--
 include/asm-x86/immediate.h |  107 ++++++++++++++++++++++++++++++++
 6 files changed, 259 insertions(+), 4 deletions(-)

Index: linux-2.6-lttng/arch/x86/kernel/Makefile_32
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kernel/Makefile_32	2007-11-15 23:25:57.000000000 -0500
+++ linux-2.6-lttng/arch/x86/kernel/Makefile_32	2007-11-15 23:26:14.000000000 -0500
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
--- linux-2.6-lttng.orig/arch/x86/kernel/traps_32.c	2007-11-15 23:25:57.000000000 -0500
+++ linux-2.6-lttng/arch/x86/kernel/traps_32.c	2007-11-16 08:55:45.000000000 -0500
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
+++ linux-2.6-lttng/include/asm-x86/immediate.h	2007-11-16 08:55:49.000000000 -0500
@@ -0,0 +1,107 @@
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
+ * permit atomic modificatino of the immediate value without knowing the size of
+ * the opcode used by the compiler. The operand size is known in advance.
+ */
+#define immediate_read(name)						\
+	({								\
+		__typeof__(name##__immediate) value;			\
+		switch (sizeof(value)) {				\
+		case 1:							\
+			asm(".section __immediate,\"a\",@progbits\n\t"	\
+				_ASM_PTR "%c1, (3f)-%c2, %c2\n\t"	\
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
+				_ASM_PTR "%c1, (3f)-%c2, %c2\n\t"	\
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
+				_ASM_PTR "%c1, (3f)-%c2, %c2\n\t"	\
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
+++ linux-2.6-lttng/arch/x86/kernel/immediate.c	2007-11-16 08:56:22.000000000 -0500
@@ -0,0 +1,143 @@
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
+		smp_mb();
+	} while (atomic_read(&wait_sync) > value);
+	atomic_dec(&wait_sync);
+	do {
+		smp_mb();
+	} while (atomic_read(&wait_sync) > 0);
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
+		smp_mb();
+	} while (atomic_read(&wait_sync) > online_cpus);
+	memcpy((void *)immediate->immediate, (void *)immediate->var,
+			immediate->size);
+	sync_core();
+	wmb();
+	atomic_dec(&wait_sync);
+	smp_mb();
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
--- linux-2.6-lttng.orig/arch/x86/kernel/Makefile_64	2007-11-15 23:25:57.000000000 -0500
+++ linux-2.6-lttng/arch/x86/kernel/Makefile_64	2007-11-15 23:26:14.000000000 -0500
@@ -35,6 +35,7 @@ obj-$(CONFIG_X86_PM_TIMER)	+= pmtimer_64
 obj-$(CONFIG_X86_VSMP)		+= vsmp_64.o
 obj-$(CONFIG_K8_NB)		+= k8.o
 obj-$(CONFIG_AUDIT)		+= audit_64.o
+obj-$(CONFIG_IMMEDIATE)		+= immediate.o
 
 obj-$(CONFIG_MODULES)		+= module_64.o
 obj-$(CONFIG_PCI)		+= early-quirks.o
Index: linux-2.6-lttng/arch/x86/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/x86/Kconfig	2007-11-15 23:26:13.000000000 -0500
+++ linux-2.6-lttng/arch/x86/Kconfig	2007-11-16 08:55:43.000000000 -0500
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
