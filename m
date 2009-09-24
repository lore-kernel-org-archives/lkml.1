Return-Path: <linux-kernel-owner+w=401wt.eu-S1753112AbZIXQBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112AbZIXQBV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 12:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbZIXQBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 12:01:20 -0400
Received: from tomts43.bellnexxia.net ([209.226.175.110]:33959 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751319AbZIXQBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 12:01:19 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqIEAEcuu0pMROOX/2dsb2JhbACBUtV1gi2BbgWBWA
Date: Thu, 24 Sep 2009 12:01:18 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <peterz@infradead.org>, anil.s.keshavamurthy@intel.com,
       Jason Yeh <jason.yeh@amd.com>, Robert Richter <robert.richter@amd.com>
Cc: Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Frank Ch. Eigler" <fche@redhat.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: [RFC patch] Immediate Values - x86 Optimization NMI and MCE support
Message-ID: <20090924160118.GA28846@Krystal>
References: <20090924132626.485545323@polymtl.ca> <20090924133400.830759403@polymtl.ca> <1253803872.18939.28.camel@laptop> <20090924150333.GA26389@Krystal> <1253804779.18939.38.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1253804779.18939.38.camel@laptop>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 11:52:22 up 37 days,  2:41,  2 users,  load average: 0.32, 0.45,
	0.49
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo: this patch is for RFC only. Do not merge.]

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Thu, 2009-09-24 at 11:03 -0400, Mathieu Desnoyers wrote:
> > * Peter Zijlstra (peterz@infradead.org) wrote:
> > > On Thu, 2009-09-24 at 09:26 -0400, Mathieu Desnoyers wrote:
> > > > plain text document attachment (tracepoints-immediate-values.patch)
> > > > Use immediate values in tracepoints.
> > > 
> > > I might have missed it, but did both the Intel and AMD cpu folks clear
> > > the SMP code rewrite bits?
> > > 
> > 
> > SMP handling is performed with stop_machine() in this patchset. Nothing
> > fancy here.
> > 
> > I've got other patches, not included in this patchset, which implements
> > nmi-safe code modification, based on a scheme using breakpoints and
> > IPIs, inspired from djprobes. That one might be worth clearing with
> > intel/amd devs before merging.
> > 
> > However, doing code patching within stop_machine() is pretty safe, given
> > all other CPUs are busy-looping with interrupts off while this happens.
> > Ftrace already does this.
> 
> Agreed, I missed this relied on stopmachine. No problem then.
> 
> It would be good to reduce reliance on stopmachine, so it would be good
> to get some CPU folks looking at your alternative implementation.
> 
> Thanks!
> 

Sure, here is the patch applying on top of the immediate values
patchset. It implements the breakpoint-based instruction patching
scheme. I just provide this one for review. There is a following patch
which makes the immediate values infrastructure use this arch-specific
file, which I'll leave out for now.

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
CC: Andi Kleen <andi@firstfloor.org>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Chuck Ebbert <cebbert@redhat.com>
CC: Christoph Hellwig <hch@infradead.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: anil.s.keshavamurthy@intel.com
CC: Jason Yeh <jason.yeh@amd.com>
CC: Robert Richter <robert.richter@amd.com>
---
 arch/x86/include/asm/immediate.h |   48 +++++
 arch/x86/kernel/Makefile         |    1 
 arch/x86/kernel/immediate.c      |  319 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 362 insertions(+), 6 deletions(-)

Index: linux.trees.git/arch/x86/include/asm/immediate.h
===================================================================
--- linux.trees.git.orig/arch/x86/include/asm/immediate.h	2009-09-24 09:20:37.000000000 -0400
+++ linux.trees.git/arch/x86/include/asm/immediate.h	2009-09-24 11:07:10.000000000 -0400
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
Index: linux.trees.git/arch/x86/kernel/Makefile
===================================================================
--- linux.trees.git.orig/arch/x86/kernel/Makefile	2009-09-24 10:55:49.000000000 -0400
+++ linux.trees.git/arch/x86/kernel/Makefile	2009-09-24 11:07:32.000000000 -0400
@@ -79,6 +79,7 @@ obj-$(CONFIG_KEXEC)		+= relocate_kernel_
 obj-$(CONFIG_CRASH_DUMP)	+= crash_dump_$(BITS).o
 obj-$(CONFIG_KPROBES)		+= kprobes.o
 obj-$(CONFIG_MODULES)		+= module.o
+obj-$(USE_IMMEDIATE)		+= immediate.o
 obj-$(CONFIG_EFI) 		+= efi.o efi_$(BITS).o efi_stub_$(BITS).o
 obj-$(CONFIG_DOUBLEFAULT) 	+= doublefault_32.o
 obj-$(CONFIG_KGDB)		+= kgdb.o
Index: linux.trees.git/arch/x86/kernel/immediate.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux.trees.git/arch/x86/kernel/immediate.c	2009-09-24 11:13:22.000000000 -0400
@@ -0,0 +1,319 @@
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
+ * Quoting "Intel Core 2 Duo Processor for IntelCentrino Duo Processor
+ * Technology Specification Update" (AH33)
+ *
+ * "The act of one processor, or system bus master, writing data into a
+ * currently executing code segment of a second processor with the intent of
+ * having the second processor execute that data as code is called
+ * cross-modifying code (XMC). XMC that does not force the second processor to
+ * execute a synchronizing instruction, prior to execution of the new code, is
+ * called unsynchronized XMC. Software using unsynchronized XMC to modify the
+ * instruction byte stream of a processor can see unexpected or unpredictable
+ * execution behavior from the processor that is executing the modified code."
+ *
+ * This code turns what would otherwise be an unsynchronized XMC into a
+ * synchronized XMC by making sure a synchronizing instruction (either iret
+ * returning from the breakpoint, cpuid from sync_core(), or mfence) is executed
+ * by any CPU before it executes the modified instruction.
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
+ * execute a mfence, to make sure that even when the breakpoint is removed,
+ * no cpu could possibly still have the out-of-date copy of the instruction,
+ * modify the now unused 2nd byte of the instruction, and then put back the
+ * original 1st byte of the instruction.
+ *
+ * It has exactly the same intent as the algorithm proposed by Intel, but
+ * it has less side-effects, scales better and supports NMI, SMI and MCE.
+ *
+ * The algorithm used to update instructions with breakpoint and IPI is inspired
+ * from the djprobe project. Credits to Masami Hiramatsu <mhiramat@redhat.com>.
+ *
+ * Copyright 2009 - Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
+ * Distributed under GPLv2.
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
+	/*
+	 * Read new instructions before continuing and stop speculative
+	 * execution.
+	 */
+	smp_mb();	
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
+		smp_wmb();
+		/*
+		 * Execute smp_rmb() and serializing instruction on each CPU.
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
+		smp_wmb();
+		/*
+		 * Execute smp_mb() on each CPU.
+		 */
+		ret = on_each_cpu(imv_synchronize_core, NULL, 1);
+		BUG_ON(ret != 0);
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
