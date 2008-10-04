Return-Path: <linux-kernel-owner+w=401wt.eu-S1754166AbYJDQeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166AbYJDQeR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 12:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753998AbYJDQd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 12:33:57 -0400
Received: from tomts22.bellnexxia.net ([209.226.175.184]:51173 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753934AbYJDQdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 12:33:54 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqAEAIMx50hMQWq+/2dsb2JhbACBcbc6gWg
Date: Sat, 4 Oct 2008 12:33:48 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 0/3] ring-buffer: less locking and only disable
	preemption
Message-ID: <20081004163348.GA23593@Krystal>
References: <20081004060057.660306328@goodmis.org> <20081004084002.GE27624@elte.hu> <alpine.DEB.1.10.0810041015330.4551@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0810041015330.4551@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:13:40 up 121 days, 20:54,  8 users,  load average: 0.32, 0.25,
	0.19
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> [ Added Arjan to CC regarding the last statements ]
> 
> On Sat, 4 Oct 2008, Ingo Molnar wrote:
> > 
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > > These patches need to be put through the ringer. Could you add them to 
> > > your ring-buffer branch, so we can test them out before putting them 
> > > into your master branch.
> > 
> > hey, in fact your latest iteration already tested out so well on a wide 
> > range of boxes that I've merged it all into tip/tracing/core already.
> 
> Great to hear!
> 
> > 
> > I'll reuse tip/tracing/ring-buffer for these latest 3 patches (merge it 
> > up to tip/tracing/core and add these three patches) but it's a delta, 
> > i.e. the whole ring-buffer approach is ready for prime time i think.
> > 
> > Hm, do we do deallocation of the buffers already when we switch tracers?
> 
> Not yet, but that is one of the trivial changes. I spent too much time
> on these more complex changes to get around to it.
> 
> > 
> > > The following patches bring the ring buffer closer to a lockless 
> > > solution. They move the locking only to the actual moving the 
> > > tail/write pointer from one page to the next. Interrupts are now 
> > > enabled during most of the writes.
> > 
> > very nice direction!
> 
> Thanks!
> 
> > 
> > > A lot of the locking protection is still within the ftrace 
> > > infrastructure. The last patch takes some of that away.
> > > 
> > > The function tracer cannot be reentrant just due to the nature that it 
> > > traces everything, and can cause recursion issues.
> > 
> > Correct, and that's by far the yuckiest aspect of it. And there's 
> > another aspect: NMIs. We've still got the tip/tracing/nmisafe angle with 
> > these commits:
> > 
> >  d979781: ftrace: mark lapic_wd_event() notrace
> >  c2c27ba: ftrace: ignore functions that cannot be kprobe-ed
> >  431e946: ftrace: do not trace NMI contexts
> >  1eda930: x86, tracing, nmisafe: fix threadinfo_ -> TI_ rename fallout
> >  84c2ca9: sched: sched_clock() improvement: use in_nmi()
> >  0d84b78: x86 NMI-safe INT3 and Page Fault
> >  a04464b: x86_64 page fault NMI-safe
> >  b335389: Change avr32 active count bit
> >  a581cbd: Change Alpha active count bit
> >  eca0999: Stringify support commas
> > 
> > but I'm not yet fully convinced about the NMI angle, the practical cross 
> > section to random low level x86 code is wider than any sched_clock() 
> > impact for example. We might be best off avoiding it: force-disable the 
> > NMI watchdog when we trace?
> 
> Since we still have the locking in the ring buffer, it is still not NMI 
> safe. But once we remove all locking, then the tracer is fine.
> 
> BUT!
> 
> The dynamic function tracer is another issue. The problem with NMIs has 
> nothing to do with locking, or corrupting the buffers. It has to do with 
> the dynamic code modification.  Whenever we modify code, we must guarantee 
> that it will not be executed on another CPU.
> 
> Kstop_machine serves this purpose rather well. We can modify code without 
> worrying it will be executed on another CPU, except for NMIs. The problem 
> now comes where an NMI can come in and execute the code being modified. 
> That's why I put in all the notrace, lines. But it gets difficult because 
> of nmi_notifier can call all over the kernel.  Perhaps, we can simply 
> disable the nmi-notifier when we are doing the kstop_machine call?
> 

Or use this code, based on a temporary breakpoint, to do the code
patching (part of the -lttng tree). It does not require stop_machine at
all and is nmi safe.

Mathieu


Immediate Values - x86 Optimization NMI and MCE support

x86 optimization of the immediate values which uses a movl with code patching
to set/unset the value used to populate the register used as variable source.
It uses a breakpoint to bypass the instruction being changed, which lessens the
interrupt latency of the operation and protects against NMIs and MCE.

- More reentrant immediate value : uses a breakpoint. Needs to know the
  instruction's first byte. This is why we keep the "instruction size"
  variable, so we can support the REX prefixed instructions too.

Changelog:
- Change the immediate.c update code to support variable length opcodes.
- Use text_poke_early with cr0 WP save/restore to patch the bypass. We are doing
  non atomic writes to a code region only touched by us (nobody can execute it
  since we are protected by the imv_mutex).
- Add x86_64 support, ready for i386+x86_64 -> x86 merge.
- Use asm-x86/asm.h.
- Change the immediate.c update code to support variable length opcodes.
- Use imv_* instead of immediate_*.
- Use kernel_wp_disable/enable instead of save/restore.
- Fix 1 byte immediate value so it declares its instruction size.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Andi Kleen <ak@muc.de>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Chuck Ebbert <cebbert@redhat.com>
CC: Christoph Hellwig <hch@infradead.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
---
 arch/x86/kernel/Makefile    |    1 
 arch/x86/kernel/immediate.c |  291 ++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/traps_32.c  |    8 -
 include/asm-x86/immediate.h |   48 ++++++-
 4 files changed, 338 insertions(+), 10 deletions(-)

Index: linux-2.6-lttng/include/asm-x86/immediate.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-x86/immediate.h	2008-08-06 01:32:23.000000000 -0400
+++ linux-2.6-lttng/include/asm-x86/immediate.h	2008-08-06 02:35:56.000000000 -0400
@@ -12,6 +12,18 @@
 
 #include <asm/asm.h>
 
+struct __imv {
+	unsigned long var;	/* Pointer to the identifier variable of the
+				 * immediate value
+				 */
+	unsigned long imv;	/*
+				 * Pointer to the memory location of the
+				 * immediate value within the instruction.
+				 */
+	unsigned char size;	/* Type size. */
+	unsigned char insn_size;/* Instruction size. */
+} __attribute__ ((packed));
+
 /**
  * imv_read - read immediate variable
  * @name: immediate value name
@@ -26,6 +38,11 @@
  * what will generate an instruction with 8 bytes immediate value (not the REX.W
  * prefixed one that loads a sign extended 32 bits immediate value in a r64
  * register).
+ *
+ * Create the instruction in a discarded section to calculate its size. This is
+ * how we can align the beginning of the instruction on an address that will
+ * permit atomic modification of the immediate value without knowing the size of
+ * the opcode used by the compiler. The operand size is known in advance.
  */
 #define imv_read(name)							\
 	({								\
@@ -33,9 +50,14 @@
 		BUILD_BUG_ON(sizeof(value) > 8);			\
 		switch (sizeof(value)) {				\
 		case 1:							\
-			asm(".section __imv,\"aw\",@progbits\n\t"	\
+			asm(".section __discard,\"\",@progbits\n\t"	\
+				"1:\n\t"				\
+				"mov $0,%0\n\t"				\
+				"2:\n\t"				\
+				".previous\n\t"				\
+				".section __imv,\"aw\",@progbits\n\t"	\
 				_ASM_PTR "%c1, (3f)-%c2\n\t"		\
-				".byte %c2\n\t"				\
+				".byte %c2, (2b-1b)\n\t"		\
 				".previous\n\t"				\
 				"mov $0,%0\n\t"				\
 				"3:\n\t"				\
@@ -45,10 +67,16 @@
 			break;						\
 		case 2:							\
 		case 4:							\
-			asm(".section __imv,\"aw\",@progbits\n\t"	\
+			asm(".section __discard,\"\",@progbits\n\t"	\
+				"1:\n\t"				\
+				"mov $0,%0\n\t"				\
+				"2:\n\t"				\
+				".previous\n\t"				\
+				".section __imv,\"aw\",@progbits\n\t"	\
 				_ASM_PTR "%c1, (3f)-%c2\n\t"		\
-				".byte %c2\n\t"				\
+				".byte %c2, (2b-1b)\n\t"		\
 				".previous\n\t"				\
+				".org . + ((-.-(2b-1b)) & (%c2-1)), 0x90\n\t" \
 				"mov $0,%0\n\t"				\
 				"3:\n\t"				\
 				: "=r" (value)				\
@@ -60,10 +88,16 @@
 				value = name##__imv;			\
 				break;					\
 			}						\
-			asm(".section __imv,\"aw\",@progbits\n\t"	\
+			asm(".section __discard,\"\",@progbits\n\t"	\
+				"1:\n\t"				\
+				"mov $0xFEFEFEFE01010101,%0\n\t"	\
+				"2:\n\t"				\
+				".previous\n\t"				\
+				".section __imv,\"aw\",@progbits\n\t"	\
 				_ASM_PTR "%c1, (3f)-%c2\n\t"		\
-				".byte %c2\n\t"				\
+				".byte %c2, (2b-1b)\n\t"		\
 				".previous\n\t"				\
+				".org . + ((-.-(2b-1b)) & (%c2-1)), 0x90\n\t" \
 				"mov $0xFEFEFEFE01010101,%0\n\t" 	\
 				"3:\n\t"				\
 				: "=r" (value)				\
@@ -74,4 +108,6 @@
 		value;							\
 	})
 
+extern int arch_imv_update(const struct __imv *imv, int early);
+
 #endif /* _ASM_X86_IMMEDIATE_H */
Index: linux-2.6-lttng/arch/x86/kernel/traps_32.c
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kernel/traps_32.c	2008-08-06 00:44:22.000000000 -0400
+++ linux-2.6-lttng/arch/x86/kernel/traps_32.c	2008-08-06 02:35:57.000000000 -0400
@@ -576,7 +576,7 @@ void do_##name(struct pt_regs *regs, lon
 }
 
 DO_VM86_ERROR_INFO(0, SIGFPE, "divide error", divide_error, FPE_INTDIV, regs->ip)
-#ifndef CONFIG_KPROBES
+#if !defined(CONFIG_KPROBES) && !defined(CONFIG_IMMEDIATE)
 DO_VM86_ERROR(3, SIGTRAP, "int3", int3)
 #endif
 DO_VM86_ERROR(4, SIGSEGV, "overflow", overflow)
@@ -850,7 +850,7 @@ void restart_nmi(void)
 	acpi_nmi_enable();
 }
 
-#ifdef CONFIG_KPROBES
+#if defined(CONFIG_KPROBES) || defined(CONFIG_IMMEDIATE)
 void __kprobes do_int3(struct pt_regs *regs, long error_code)
 {
 	trace_hardirqs_fixup();
@@ -859,8 +859,8 @@ void __kprobes do_int3(struct pt_regs *r
 			== NOTIFY_STOP)
 		return;
 	/*
-	 * This is an interrupt gate, because kprobes wants interrupts
-	 * disabled. Normal trap handlers don't.
+	 * This is an interrupt gate, because kprobes and immediate values wants
+	 * interrupts disabled. Normal trap handlers don't.
 	 */
 	restore_interrupts(regs);
 
Index: linux-2.6-lttng/arch/x86/kernel/Makefile
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kernel/Makefile	2008-08-06 00:41:34.000000000 -0400
+++ linux-2.6-lttng/arch/x86/kernel/Makefile	2008-08-06 02:35:57.000000000 -0400
@@ -73,6 +73,7 @@ obj-$(CONFIG_X86_SUMMIT_NUMA)	+= summit_
 obj-y				+= vsmp_64.o
 obj-$(CONFIG_KPROBES)		+= kprobes.o
 obj-$(CONFIG_MODULES)		+= module_$(BITS).o
+obj-$(CONFIG_IMMEDIATE)		+= immediate.o
 obj-$(CONFIG_EFI) 		+= efi.o efi_$(BITS).o efi_stub_$(BITS).o
 obj-$(CONFIG_DOUBLEFAULT) 	+= doublefault_32.o
 obj-$(CONFIG_KGDB)		+= kgdb.o
Index: linux-2.6-lttng/arch/x86/kernel/immediate.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/arch/x86/kernel/immediate.c	2008-08-06 02:36:33.000000000 -0400
@@ -0,0 +1,291 @@
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
+#include <linux/preempt.h>
+#include <linux/smp.h>
+#include <linux/notifier.h>
+#include <linux/module.h>
+#include <linux/immediate.h>
+#include <linux/kdebug.h>
+#include <linux/rcupdate.h>
+#include <linux/kprobes.h>
+#include <linux/io.h>
+
+#include <asm/cacheflush.h>
+
+#define BREAKPOINT_INSTRUCTION  0xcc
+#define BREAKPOINT_INS_LEN	1
+#define NR_NOPS			10
+
+static unsigned long target_after_int3;	/* EIP of the target after the int3 */
+static unsigned long bypass_eip;	/* EIP of the bypass. */
+static unsigned long bypass_after_int3;	/* EIP after the end-of-bypass int3 */
+static unsigned long after_imv;	/*
+					 * EIP where to resume after the
+					 * single-stepping.
+					 */
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
+ * Align on 16 bytes to make sure the nops fit within a single page so remapping
+ * it can be done easily.
+ */
+static inline void _imv_bypass(unsigned long *bypassaddr,
+	unsigned long *breaknextaddr)
+{
+		asm volatile("jmp 2f;\n\t"
+				".align 16;\n\t"
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
+static void imv_synchronize_core(void *info)
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
+static int imv_notifier(struct notifier_block *nb,
+	unsigned long val, void *data)
+{
+	enum die_val die_val = (enum die_val) val;
+	struct die_args *args = data;
+
+	if (!args->regs || user_mode_vm(args->regs))
+		return NOTIFY_DONE;
+
+	if (die_val == DIE_INT3) {
+		if (args->regs->ip == target_after_int3) {
+			preempt_disable();
+			args->regs->ip = bypass_eip;
+			return NOTIFY_STOP;
+		} else if (args->regs->ip == bypass_after_int3) {
+			args->regs->ip = after_imv;
+			preempt_enable();
+			return NOTIFY_STOP;
+		}
+	}
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block imv_notify = {
+	.notifier_call = imv_notifier,
+	.priority = 0x7fffffff,	/* we need to be notified first */
+};
+
+/**
+ * arch_imv_update - update one immediate value
+ * @imv: pointer of type const struct __imv to update
+ * @early: early boot (1) or normal (0)
+ *
+ * Update one immediate value. Must be called with imv_mutex held.
+ */
+__kprobes int arch_imv_update(const struct __imv *imv, int early)
+{
+	int ret;
+	unsigned char opcode_size = imv->insn_size - imv->size;
+	unsigned long insn = imv->imv - opcode_size;
+	unsigned long len;
+	char *vaddr;
+	struct page *pages[1];
+
+#ifdef CONFIG_KPROBES
+	/*
+	 * Fail if a kprobe has been set on this instruction.
+	 * (TODO: we could eventually do better and modify all the (possibly
+	 * nested) kprobes for this site if kprobes had an API for this.
+	 */
+	if (unlikely(!early
+			&& *(unsigned char *)insn == BREAKPOINT_INSTRUCTION)) {
+		printk(KERN_WARNING "Immediate value in conflict with kprobe. "
+				    "Variable at %p, "
+				    "instruction at %p, size %hu\n",
+				    (void *)imv->imv,
+				    (void *)imv->var, imv->size);
+		return -EBUSY;
+	}
+#endif
+
+	/*
+	 * If the variable and the instruction have the same value, there is
+	 * nothing to do.
+	 */
+	switch (imv->size) {
+	case 1:	if (*(uint8_t *)imv->imv
+				== *(uint8_t *)imv->var)
+			return 0;
+		break;
+	case 2:	if (*(uint16_t *)imv->imv
+				== *(uint16_t *)imv->var)
+			return 0;
+		break;
+	case 4:	if (*(uint32_t *)imv->imv
+				== *(uint32_t *)imv->var)
+			return 0;
+		break;
+#ifdef CONFIG_X86_64
+	case 8:	if (*(uint64_t *)imv->imv
+				== *(uint64_t *)imv->var)
+			return 0;
+		break;
+#endif
+	default:return -EINVAL;
+	}
+
+	if (!early) {
+		/* bypass is 10 bytes long for x86_64 long */
+		WARN_ON(imv->insn_size > 10);
+		_imv_bypass(&bypass_eip, &bypass_after_int3);
+
+		after_imv = imv->imv + imv->size;
+
+		/*
+		 * Using the _early variants because nobody is executing the
+		 * bypass code while we patch it. It is protected by the
+		 * imv_mutex. Since we modify the instructions non atomically
+		 * (for nops), we have to use the _early variant.
+		 * We must however deal with RO pages.
+		 * Use a single page : 10 bytes are aligned on 16 bytes
+		 * boundaries.
+		 */
+		pages[0] = virt_to_page((void *)bypass_eip);
+		vaddr = vmap(pages, 1, VM_MAP, PAGE_KERNEL);
+		BUG_ON(!vaddr);
+		text_poke_early(&vaddr[bypass_eip & ~PAGE_MASK],
+			(void *)insn, imv->insn_size);
+		/*
+		 * Fill the rest with nops.
+		 */
+		len = NR_NOPS - imv->insn_size;
+		add_nops((void *)
+			&vaddr[(bypass_eip & ~PAGE_MASK) + imv->insn_size],
+			len);
+		vunmap(vaddr);
+
+		target_after_int3 = insn + BREAKPOINT_INS_LEN;
+		/* register_die_notifier has memory barriers */
+		register_die_notifier(&imv_notify);
+		/* The breakpoint will single-step the bypass */
+		text_poke((void *)insn,
+			((unsigned char[]){BREAKPOINT_INSTRUCTION}), 1);
+		/*
+		 * Make sure the breakpoint is set before we continue (visible
+		 * to other CPUs and interrupts).
+		 */
+		wmb();
+		/*
+		 * Execute serializing instruction on each CPU.
+		 */
+		ret = on_each_cpu(imv_synchronize_core, NULL, 1);
+		BUG_ON(ret != 0);
+
+		text_poke((void *)(insn + opcode_size), (void *)imv->var,
+				imv->size);
+		/*
+		 * Make sure the value can be seen from other CPUs and
+		 * interrupts.
+		 */
+		wmb();
+		text_poke((void *)insn, (unsigned char *)bypass_eip, 1);
+		/*
+		 * Wait for all int3 handlers to end (interrupts are disabled in
+		 * int3). This CPU is clearly not in a int3 handler, because
+		 * int3 handler is not preemptible and there cannot be any more
+		 * int3 handler called for this site, because we placed the
+		 * original instruction back.  synchronize_sched has memory
+		 * barriers.
+		 */
+		synchronize_sched();
+		unregister_die_notifier(&imv_notify);
+		/* unregister_die_notifier has memory barriers */
+	} else
+		text_poke_early((void *)imv->imv, (void *)imv->var,
+			imv->size);
+	return 0;
+}


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
