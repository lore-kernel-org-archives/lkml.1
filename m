Return-Path: <linux-kernel-owner+w=401wt.eu-S1760419AbYDTAeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760419AbYDTAeT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 20:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753360AbYDTAeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 20:34:07 -0400
Received: from tomts43.bellnexxia.net ([209.226.175.110]:51860 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753320AbYDTAeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 20:34:04 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmcFAN4rCkhMROPA/2dsb2JhbACBXag8
Date: Sat, 19 Apr 2008 20:33:58 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu, akpm@osdl.org,
       "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org
Subject: [RFC PATCH] x86 NMI-safe INT3 and Page Fault (v8)
Message-ID: <20080420003358.GA8505@Krystal>
References: <20080417164116.GB23351@Krystal> <48087217.50305@goop.org> <20080419212937.GA2831@Krystal> <480A6DD4.8050702@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <480A6DD4.8050702@goop.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 20:31:49 up 50 days, 20:42,  5 users,  load average: 0.42, 0.26,
	0.15
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86 NMI-safe INT3 and Page Fault

Implements an alternative iret with popf and return so trap and exception
handlers can return to the NMI handler without issuing iret. iret would cause
NMIs to be reenabled prematurely. x86_32 uses popf and far return. x86_64 has to
copy the return instruction pointer to the top of the previous stack, issue a
popf, loads the previous esp and issue a near return (ret).

It allows placing immediate values (and therefore optimized trace_marks) in NMI
code since returning from a breakpoint would be valid. Accessing vmalloc'd
memory, which allows executing module code or accessing vmapped or vmalloc'd
areas from NMI context, would also be valid. This is very useful to tracers like
LTTng.

This patch makes all faults, traps and exception safe to be called from NMI
context *except* single-stepping, which requires iret to restore the TF (trap
flag) and jump to the return address in a single instruction. Sorry, no kprobes
support in NMI handlers because of this limitation.  We cannot single-step an
NMI handler, because iret must set the TF flag and return back to the
instruction to single-step in a single instruction. This cannot be emulated with
popf/lret, because lret would be single-stepped. It does not apply to immediate
values because they do not use single-stepping. This code detects if the TF
flag is set and uses the iret path for single-stepping, even if it reactivates
NMIs prematurely.

alpha and avr32 use the active count bit 31. This patch moves them to 28.

TODO : test alpha and avr32 active count modification
TODO : test with lguest, xen, kvm.

tested on x86_32 (tests implemented in a separate patch) :
- instrumented the return path to export the EIP, CS and EFLAGS values when
  taken so we know the return path code has been executed.
- trace_mark, using immediate values, with 10ms delay with the breakpoint
  activated. Runs well through the return path.
- tested vmalloc faults in NMI handler by placing a non-optimized marker in the
  NMI handler (so no breakpoint is executed) and connecting a probe which
  touches every pages of a 20MB vmalloc'd buffer. It executes trough the return
  path without problem.
- Tested with and without preemption

tested on x86_64
- instrumented the return path to export the EIP, CS and EFLAGS values when
  taken so we know the return path code has been executed.
- trace_mark, using immediate values, with 10ms delay with the breakpoint
  activated. Runs well through the return path.

To test on x86_64 :
- Test without preemption
- Test vmalloc faults
- Test on Intel 64 bits CPUs.

Changelog since v1 :
- x86_64 fixes.
Changelog since v2 :
- fix paravirt build
Changelog since v3 :
- Include modifications suggested by Jeremy
Changelog since v4 :
- including hardirq.h in entry_32/64.S is a bad idea (non ifndef'd C code),
  define HARDNMI_MASK in the .S files directly.
Changelog since v5 :
- Add HARDNMI_MASK to irq_count() and make die() more verbose for NMIs.
Changelog since v7 :
- Implement paravirtualized nmi_return.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: akpm@osdl.org
CC: mingo@elte.hu
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: "Frank Ch. Eigler" <fche@redhat.com>
---
 arch/x86/kernel/entry_32.S          |   33 +++++++++++++++++-
 arch/x86/kernel/entry_64.S          |   32 ++++++++++++++++++
 arch/x86/kernel/paravirt.c          |    3 +
 arch/x86/kernel/paravirt_patch_32.c |    4 ++
 arch/x86/kernel/paravirt_patch_64.c |    3 +
 arch/x86/kernel/traps_32.c          |    3 +
 arch/x86/kernel/traps_64.c          |    4 ++
 include/asm-alpha/thread_info.h     |    2 -
 include/asm-avr32/thread_info.h     |    2 -
 include/asm-x86/irqflags.h          |   55 +++++++++++++++++++++++++++++++
 include/asm-x86/paravirt.h          |   63 +++++++++++++++++++++++++++++++++++-
 include/linux/hardirq.h             |   27 +++++++++++++--
 12 files changed, 223 insertions(+), 8 deletions(-)

Index: linux-2.6-lttng/include/linux/hardirq.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/hardirq.h	2008-04-19 12:00:39.000000000 -0400
+++ linux-2.6-lttng/include/linux/hardirq.h	2008-04-19 12:00:41.000000000 -0400
@@ -22,10 +22,13 @@
  * PREEMPT_MASK: 0x000000ff
  * SOFTIRQ_MASK: 0x0000ff00
  * HARDIRQ_MASK: 0x0fff0000
+ * HARDNMI_MASK: 0x40000000
  */
 #define PREEMPT_BITS	8
 #define SOFTIRQ_BITS	8
 
+#define HARDNMI_BITS	1
+
 #ifndef HARDIRQ_BITS
 #define HARDIRQ_BITS	12
 
@@ -45,16 +48,19 @@
 #define PREEMPT_SHIFT	0
 #define SOFTIRQ_SHIFT	(PREEMPT_SHIFT + PREEMPT_BITS)
 #define HARDIRQ_SHIFT	(SOFTIRQ_SHIFT + SOFTIRQ_BITS)
+#define HARDNMI_SHIFT	(30)
 
 #define __IRQ_MASK(x)	((1UL << (x))-1)
 
 #define PREEMPT_MASK	(__IRQ_MASK(PREEMPT_BITS) << PREEMPT_SHIFT)
 #define SOFTIRQ_MASK	(__IRQ_MASK(SOFTIRQ_BITS) << SOFTIRQ_SHIFT)
 #define HARDIRQ_MASK	(__IRQ_MASK(HARDIRQ_BITS) << HARDIRQ_SHIFT)
+#define HARDNMI_MASK	(__IRQ_MASK(HARDNMI_BITS) << HARDNMI_SHIFT)
 
 #define PREEMPT_OFFSET	(1UL << PREEMPT_SHIFT)
 #define SOFTIRQ_OFFSET	(1UL << SOFTIRQ_SHIFT)
 #define HARDIRQ_OFFSET	(1UL << HARDIRQ_SHIFT)
+#define HARDNMI_OFFSET	(1UL << HARDNMI_SHIFT)
 
 #if PREEMPT_ACTIVE < (1 << (HARDIRQ_SHIFT + HARDIRQ_BITS))
 #error PREEMPT_ACTIVE is too low!
@@ -62,7 +68,9 @@
 
 #define hardirq_count()	(preempt_count() & HARDIRQ_MASK)
 #define softirq_count()	(preempt_count() & SOFTIRQ_MASK)
-#define irq_count()	(preempt_count() & (HARDIRQ_MASK | SOFTIRQ_MASK))
+#define irq_count() \
+	(preempt_count() & (HARDNMI_MASK | HARDIRQ_MASK | SOFTIRQ_MASK))
+#define hardnmi_count()	(preempt_count() & HARDNMI_MASK)
 
 /*
  * Are we doing bottom half or hardware interrupt processing?
@@ -71,6 +79,7 @@
 #define in_irq()		(hardirq_count())
 #define in_softirq()		(softirq_count())
 #define in_interrupt()		(irq_count())
+#define in_nmi()		(hardnmi_count())
 
 /*
  * Are we running in atomic context?  WARNING: this macro cannot
@@ -159,7 +168,19 @@ extern void irq_enter(void);
  */
 extern void irq_exit(void);
 
-#define nmi_enter()		do { lockdep_off(); __irq_enter(); } while (0)
-#define nmi_exit()		do { __irq_exit(); lockdep_on(); } while (0)
+#define nmi_enter()					\
+	do {						\
+		lockdep_off();				\
+		BUG_ON(hardnmi_count());		\
+		add_preempt_count(HARDNMI_OFFSET);	\
+		__irq_enter();				\
+	} while (0)
+
+#define nmi_exit()					\
+	do {						\
+		__irq_exit();				\
+		sub_preempt_count(HARDNMI_OFFSET);	\
+		lockdep_on();				\
+	} while (0)
 
 #endif /* LINUX_HARDIRQ_H */
Index: linux-2.6-lttng/arch/x86/kernel/entry_32.S
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kernel/entry_32.S	2008-04-19 12:00:40.000000000 -0400
+++ linux-2.6-lttng/arch/x86/kernel/entry_32.S	2008-04-19 19:02:23.000000000 -0400
@@ -75,11 +75,12 @@ DF_MASK		= 0x00000400 
 NT_MASK		= 0x00004000
 VM_MASK		= 0x00020000
 
+#define HARDNMI_MASK 0x40000000
+
 #ifdef CONFIG_PREEMPT
 #define preempt_stop(clobbers)	DISABLE_INTERRUPTS(clobbers); TRACE_IRQS_OFF
 #else
 #define preempt_stop(clobbers)
-#define resume_kernel		restore_nocheck
 #endif
 
 .macro TRACE_IRQS_IRET
@@ -265,6 +266,8 @@ END(ret_from_exception)
 #ifdef CONFIG_PREEMPT
 ENTRY(resume_kernel)
 	DISABLE_INTERRUPTS(CLBR_ANY)
+	testl $HARDNMI_MASK,TI_preempt_count(%ebp)	# nested over NMI ?
+	jnz return_to_nmi
 	cmpl $0,TI_preempt_count(%ebp)	# non-zero preempt_count ?
 	jnz restore_nocheck
 need_resched:
@@ -276,6 +279,12 @@ need_resched:
 	call preempt_schedule_irq
 	jmp need_resched
 END(resume_kernel)
+#else
+ENTRY(resume_kernel)
+	testl $HARDNMI_MASK,TI_preempt_count(%ebp)	# nested over NMI ?
+	jnz return_to_nmi
+	jmp restore_nocheck
+END(resume_kernel)
 #endif
 	CFI_ENDPROC
 
@@ -411,6 +420,22 @@ restore_nocheck_notrace:
 	CFI_ADJUST_CFA_OFFSET -4
 irq_return:
 	INTERRUPT_RETURN
+return_to_nmi:
+	testl $X86_EFLAGS_TF, PT_EFLAGS(%esp)
+	jnz restore_nocheck		/*
+					 * If single-stepping an NMI handler,
+					 * use the normal iret path instead of
+					 * the popf/lret because lret would be
+					 * single-stepped. It should not
+					 * happen : it will reactivate NMIs
+					 * prematurely.
+					 */
+	TRACE_IRQS_IRET
+	RESTORE_REGS
+	addl $4, %esp			# skip orig_eax/error_code
+	CFI_ADJUST_CFA_OFFSET -4
+	INTERRUPT_RETURN_NMI_SAFE
+
 .section .fixup,"ax"
 iret_exc:
 	pushl $0			# no error code
@@ -879,6 +904,10 @@ ENTRY(native_iret)
 .previous
 END(native_iret)
 
+ENTRY(native_nmi_return)
+	NATIVE_INTERRUPT_RETURN_NMI_SAFE # Should we deal with popf exception ?
+END(native_nmi_return)
+
 ENTRY(native_irq_enable_syscall_ret)
 	sti
 	sysexit
@@ -1050,7 +1079,7 @@ ENTRY(xen_hypervisor_callback)
 ENDPROC(xen_hypervisor_callback)
 
 # Hypervisor uses this for application faults while it executes.
-# We get here for two reasons:
+# We get here for three reasons:
 #  1. Fault while reloading DS, ES, FS or GS
 #  2. Fault while executing IRET
 # Category 1 we fix up by reattempting the load, and zeroing the segment
Index: linux-2.6-lttng/arch/x86/kernel/entry_64.S
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kernel/entry_64.S	2008-04-19 12:00:40.000000000 -0400
+++ linux-2.6-lttng/arch/x86/kernel/entry_64.S	2008-04-19 19:05:58.000000000 -0400
@@ -54,6 +54,8 @@
 
 	.code64
 
+#define HARDNMI_MASK 0x40000000
+
 #ifndef CONFIG_PREEMPT
 #define retint_kernel retint_restore_args
 #endif	
@@ -581,12 +583,27 @@ retint_restore_args:	/* return to kernel
 	 * The iretq could re-enable interrupts:
 	 */
 	TRACE_IRQS_IRETQ
+	testl $HARDNMI_MASK,threadinfo_preempt_count(%rcx)
+	jnz return_to_nmi		/* Nested over NMI ? */
 restore_args:
 	RESTORE_ARGS 0,8,0
 
 irq_return:
 	INTERRUPT_RETURN
 
+return_to_nmi:				/*
+					 * If single-stepping an NMI handler,
+					 * use the normal iret path instead of
+					 * the popf/lret because lret would be
+					 * single-stepped. It should not
+					 * happen : it will reactivate NMIs
+					 * prematurely.
+					 */
+	testw $X86_EFLAGS_TF,EFLAGS-ARGOFFSET(%rsp)	/* trap flag? */
+	jnz restore_args
+	RESTORE_ARGS 0,8,0
+	INTERRUPT_RETURN_NMI_SAFE
+
 	.section __ex_table, "a"
 	.quad irq_return, bad_iret
 	.previous
@@ -598,6 +615,12 @@ ENTRY(native_iret)
 	.section __ex_table,"a"
 	.quad native_iret, bad_iret
 	.previous
+
+ENTRY(native_nmi_return)
+	NATIVE_INTERRUPT_RETURN_NMI_SAFE
+#endif
+
+
 #endif
 
 	.section .fixup,"ax"
@@ -802,6 +825,10 @@ END(spurious_interrupt)
 	.macro paranoidexit trace=1
 	/* ebx:	no swapgs flag */
 paranoid_exit\trace:
+	GET_THREAD_INFO(%rcx)
+	testl $HARDNMI_MASK,threadinfo_preempt_count(%rcx)
+	jnz paranoid_return_to_nmi\trace	/* Nested over NMI ? */
+paranoid_exit_no_nmi\trace:
 	testl %ebx,%ebx				/* swapgs needed? */
 	jnz paranoid_restore\trace
 	testl $3,CS(%rsp)
@@ -814,6 +841,11 @@ paranoid_swapgs\trace:
 paranoid_restore\trace:
 	RESTORE_ALL 8
 	jmp irq_return
+paranoid_return_to_nmi\trace:
+	testw $X86_EFLAGS_TF,EFLAGS-0(%rsp)	/* trap flag? */
+	jnz paranoid_exit_no_nmi\trace
+	RESTORE_ALL 8
+	INTERRUPT_RETURN_NMI_SAFE
 paranoid_userspace\trace:
 	GET_THREAD_INFO(%rcx)
 	movl threadinfo_flags(%rcx),%ebx
Index: linux-2.6-lttng/include/asm-x86/irqflags.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-x86/irqflags.h	2008-04-19 12:00:39.000000000 -0400
+++ linux-2.6-lttng/include/asm-x86/irqflags.h	2008-04-19 17:25:24.000000000 -0400
@@ -138,12 +138,67 @@ static inline unsigned long __raw_local_
 
 #ifdef CONFIG_X86_64
 #define INTERRUPT_RETURN	iretq
+
+/*
+ * Only returns from a trap or exception to a NMI context (intra-privilege
+ * level near return) to the same SS and CS segments. Should be used
+ * upon trap or exception return when nested over a NMI context so no iret is
+ * issued. It takes care of modifying the eflags, rsp and returning to the
+ * previous function.
+ *
+ * The stack, at that point, looks like :
+ *
+ * 0(rsp)  RIP
+ * 8(rsp)  CS
+ * 16(rsp) EFLAGS
+ * 24(rsp) RSP
+ * 32(rsp) SS
+ *
+ * Upon execution :
+ * Copy EIP to the top of the return stack
+ * Update top of return stack address
+ * Pop eflags into the eflags register
+ * Make the return stack current
+ * Near return (popping the return address from the return stack)
+ */
+#define INTERRUPT_RETURN_NMI_SAFE	pushq %rax;		\
+					movq %rsp, %rax;	\
+					movq 24+8(%rax), %rsp;	\
+					pushq 0+8(%rax);	\
+					pushq 16+8(%rax);	\
+					movq (%rax), %rax;	\
+					popfq;			\
+					ret
+
 #define ENABLE_INTERRUPTS_SYSCALL_RET			\
 			movq	%gs:pda_oldrsp, %rsp;	\
 			swapgs;				\
 			sysretq;
 #else
 #define INTERRUPT_RETURN		iret
+
+/*
+ * Protected mode only, no V8086. Implies that protected mode must
+ * be entered before NMIs or MCEs are enabled. Only returns from a trap or
+ * exception to a NMI context (intra-privilege level far return). Should be used
+ * upon trap or exception return when nested over a NMI context so no iret is
+ * issued.
+ *
+ * The stack, at that point, looks like :
+ *
+ * 0(esp) EIP
+ * 4(esp) CS
+ * 8(esp) EFLAGS
+ *
+ * Upon execution :
+ * Copy the stack eflags to top of stack
+ * Pop eflags into the eflags register
+ * Far return: pop EIP and CS into their register, and additionally pop EFLAGS.
+ */
+#define INTERRUPT_RETURN_NMI_SAFE	pushl 8(%esp);	\
+					popfl;		\
+					lret $4
+
 #define ENABLE_INTERRUPTS_SYSCALL_RET	sti; sysexit
 #define GET_CR0_INTO_EAX		movl %cr0, %eax
 #endif
Index: linux-2.6-lttng/include/asm-alpha/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-alpha/thread_info.h	2008-04-19 12:00:39.000000000 -0400
+++ linux-2.6-lttng/include/asm-alpha/thread_info.h	2008-04-19 18:22:52.000000000 -0400
@@ -57,7 +57,7 @@ register struct thread_info *__current_t
 
 #endif /* __ASSEMBLY__ */
 
-#define PREEMPT_ACTIVE		0x40000000
+#define PREEMPT_ACTIVE		0x10000000
 
 /*
  * Thread information flags:
Index: linux-2.6-lttng/include/asm-avr32/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-avr32/thread_info.h	2008-04-19 12:00:39.000000000 -0400
+++ linux-2.6-lttng/include/asm-avr32/thread_info.h	2008-04-19 18:22:52.000000000 -0400
@@ -70,7 +70,7 @@ static inline struct thread_info *curren
 
 #endif /* !__ASSEMBLY__ */
 
-#define PREEMPT_ACTIVE		0x40000000
+#define PREEMPT_ACTIVE		0x10000000
 
 /*
  * Thread information flags
Index: linux-2.6-lttng/include/asm-x86/paravirt.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-x86/paravirt.h	2008-04-19 12:00:39.000000000 -0400
+++ linux-2.6-lttng/include/asm-x86/paravirt.h	2008-04-19 19:10:43.000000000 -0400
@@ -141,9 +141,10 @@ struct pv_cpu_ops {
 	u64 (*read_pmc)(int counter);
 	unsigned long long (*read_tscp)(unsigned int *aux);
 
-	/* These two are jmp to, not actually called. */
+	/* These three are jmp to, not actually called. */
 	void (*irq_enable_syscall_ret)(void);
 	void (*iret)(void);
+	void (*nmi_return)(void);
 
 	void (*swapgs)(void);
 
@@ -1358,6 +1359,10 @@ static inline unsigned long __raw_local_
 	PARA_SITE(PARA_PATCH(pv_cpu_ops, PV_CPU_iret), CLBR_NONE,	\
 		  jmp *%cs:pv_cpu_ops+PV_CPU_iret)
 
+#define INTERRUPT_RETURN_NMI_SAFE					\
+	PARA_SITE(PARA_PATCH(pv_cpu_ops, PV_CPU_nmi_return), CLBR_NONE,	\
+		  jmp *%cs:pv_cpu_ops+PV_CPU_nmi_return)
+
 #define DISABLE_INTERRUPTS(clobbers)					\
 	PARA_SITE(PARA_PATCH(pv_irq_ops, PV_IRQ_irq_disable), clobbers, \
 		  PV_SAVE_REGS;			\
@@ -1397,5 +1402,61 @@ static inline unsigned long __raw_local_
 #endif
 
 #endif /* __ASSEMBLY__ */
+
+#ifdef CONFIG_X86_64
+/*
+ * Only returns from a trap or exception to a NMI context (intra-privilege
+ * level near return) to the same SS and CS segments. Should be used
+ * upon trap or exception return when nested over a NMI context so no iret is
+ * issued. It takes care of modifying the eflags, rsp and returning to the
+ * previous function.
+ *
+ * The stack, at that point, looks like :
+ *
+ * 0(rsp)  RIP
+ * 8(rsp)  CS
+ * 16(rsp) EFLAGS
+ * 24(rsp) RSP
+ * 32(rsp) SS
+ *
+ * Upon execution :
+ * Copy EIP to the top of the return stack
+ * Update top of return stack address
+ * Pop eflags into the eflags register
+ * Make the return stack current
+ * Near return (popping the return address from the return stack)
+ */
+#define NATIVE_INTERRUPT_RETURN_NMI_SAFE	pushq %rax;		\
+						movq %rsp, %rax;	\
+						movq 24+8(%rax), %rsp;	\
+						pushq 0+8(%rax);	\
+						pushq 16+8(%rax);	\
+						movq (%rax), %rax;	\
+						popfq;			\
+						ret
+#else
+/*
+ * Protected mode only, no V8086. Implies that protected mode must
+ * be entered before NMIs or MCEs are enabled. Only returns from a trap or
+ * exception to a NMI context (intra-privilege level far return). Should be used
+ * upon trap or exception return when nested over a NMI context so no iret is
+ * issued.
+ *
+ * The stack, at that point, looks like :
+ *
+ * 0(esp) EIP
+ * 4(esp) CS
+ * 8(esp) EFLAGS
+ *
+ * Upon execution :
+ * Copy the stack eflags to top of stack
+ * Pop eflags into the eflags register
+ * Far return: pop EIP and CS into their register, and additionally pop EFLAGS.
+ */
+#define NATIVE_INTERRUPT_RETURN_NMI_SAFE	pushl 8(%esp);	\
+						popfl;		\
+						lret $4
+#endif
+
 #endif /* CONFIG_PARAVIRT */
 #endif	/* __ASM_PARAVIRT_H */
Index: linux-2.6-lttng/arch/x86/kernel/traps_32.c
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kernel/traps_32.c	2008-04-19 12:00:40.000000000 -0400
+++ linux-2.6-lttng/arch/x86/kernel/traps_32.c	2008-04-19 18:22:53.000000000 -0400
@@ -464,6 +464,9 @@ void die(const char * str, struct pt_reg
 	if (kexec_should_crash(current))
 		crash_kexec(regs);
 
+	if (in_nmi())
+		panic("Fatal exception in non-maskable interrupt");
+
 	if (in_interrupt())
 		panic("Fatal exception in interrupt");
 
Index: linux-2.6-lttng/arch/x86/kernel/traps_64.c
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kernel/traps_64.c	2008-04-19 12:00:40.000000000 -0400
+++ linux-2.6-lttng/arch/x86/kernel/traps_64.c	2008-04-19 18:22:49.000000000 -0400
@@ -553,6 +553,10 @@ void __kprobes oops_end(unsigned long fl
 		oops_exit();
 		return;
 	}
+	if (in_nmi())
+		panic("Fatal exception in non-maskable interrupt");
+	if (in_interrupt())
+		panic("Fatal exception in interrupt");
 	if (panic_on_oops)
 		panic("Fatal exception");
 	oops_exit();
Index: linux-2.6-lttng/arch/x86/kernel/paravirt.c
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kernel/paravirt.c	2008-04-19 18:27:21.000000000 -0400
+++ linux-2.6-lttng/arch/x86/kernel/paravirt.c	2008-04-19 18:28:50.000000000 -0400
@@ -139,6 +139,7 @@ unsigned paravirt_patch_default(u8 type,
 		/* If the operation is a nop, then nop the callsite */
 		ret = paravirt_patch_nop();
 	else if (type == PARAVIRT_PATCH(pv_cpu_ops.iret) ||
+		 type == PARAVIRT_PATCH(pv_cpu_ops.nmi_return) ||
 		 type == PARAVIRT_PATCH(pv_cpu_ops.irq_enable_syscall_ret))
 		/* If operation requires a jmp, then jmp */
 		ret = paravirt_patch_jmp(insnbuf, opfunc, addr, len);
@@ -190,6 +191,7 @@ static void native_flush_tlb_single(unsi
 
 /* These are in entry.S */
 extern void native_iret(void);
+extern void native_nmi_return(void);
 extern void native_irq_enable_syscall_ret(void);
 
 static int __init print_banner(void)
@@ -344,6 +346,7 @@ struct pv_cpu_ops pv_cpu_ops = {
 
 	.irq_enable_syscall_ret = native_irq_enable_syscall_ret,
 	.iret = native_iret,
+	.nmi_return = native_nmi_return,
 	.swapgs = native_swapgs,
 
 	.set_iopl_mask = native_set_iopl_mask,
Index: linux-2.6-lttng/arch/x86/kernel/paravirt_patch_32.c
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kernel/paravirt_patch_32.c	2008-04-19 18:29:04.000000000 -0400
+++ linux-2.6-lttng/arch/x86/kernel/paravirt_patch_32.c	2008-04-19 19:15:32.000000000 -0400
@@ -1,3 +1,4 @@
+#include <linux/stringify.h>
 #include <asm/paravirt.h>
 
 DEF_NATIVE(pv_irq_ops, irq_disable, "cli");
@@ -5,6 +6,8 @@ DEF_NATIVE(pv_irq_ops, irq_enable, "sti"
 DEF_NATIVE(pv_irq_ops, restore_fl, "push %eax; popf");
 DEF_NATIVE(pv_irq_ops, save_fl, "pushf; pop %eax");
 DEF_NATIVE(pv_cpu_ops, iret, "iret");
+DEF_NATIVE(pv_cpu_ops, nmi_return,
+	__stringify(NATIVE_INTERRUPT_RETURN_NMI_SAFE));
 DEF_NATIVE(pv_cpu_ops, irq_enable_syscall_ret, "sti; sysexit");
 DEF_NATIVE(pv_mmu_ops, read_cr2, "mov %cr2, %eax");
 DEF_NATIVE(pv_mmu_ops, write_cr3, "mov %eax, %cr3");
@@ -29,6 +32,7 @@ unsigned native_patch(u8 type, u16 clobb
 		PATCH_SITE(pv_irq_ops, restore_fl);
 		PATCH_SITE(pv_irq_ops, save_fl);
 		PATCH_SITE(pv_cpu_ops, iret);
+		PATCH_SITE(pv_cpu_ops, nmi_return);
 		PATCH_SITE(pv_cpu_ops, irq_enable_syscall_ret);
 		PATCH_SITE(pv_mmu_ops, read_cr2);
 		PATCH_SITE(pv_mmu_ops, read_cr3);
Index: linux-2.6-lttng/arch/x86/kernel/paravirt_patch_64.c
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kernel/paravirt_patch_64.c	2008-04-19 18:58:28.000000000 -0400
+++ linux-2.6-lttng/arch/x86/kernel/paravirt_patch_64.c	2008-04-19 19:15:23.000000000 -0400
@@ -7,6 +7,8 @@ DEF_NATIVE(pv_irq_ops, irq_enable, "sti"
 DEF_NATIVE(pv_irq_ops, restore_fl, "pushq %rdi; popfq");
 DEF_NATIVE(pv_irq_ops, save_fl, "pushfq; popq %rax");
 DEF_NATIVE(pv_cpu_ops, iret, "iretq");
+DEF_NATIVE(pv_cpu_ops, nmi_return,
+	__stringify(NATIVE_INTERRUPT_RETURN_NMI_SAFE));
 DEF_NATIVE(pv_mmu_ops, read_cr2, "movq %cr2, %rax");
 DEF_NATIVE(pv_mmu_ops, read_cr3, "movq %cr3, %rax");
 DEF_NATIVE(pv_mmu_ops, write_cr3, "movq %rdi, %cr3");
@@ -35,6 +37,7 @@ unsigned native_patch(u8 type, u16 clobb
 		PATCH_SITE(pv_irq_ops, irq_enable);
 		PATCH_SITE(pv_irq_ops, irq_disable);
 		PATCH_SITE(pv_cpu_ops, iret);
+		PATCH_SITE(pv_cpu_ops, nmi_return);
 		PATCH_SITE(pv_cpu_ops, irq_enable_syscall_ret);
 		PATCH_SITE(pv_cpu_ops, swapgs);
 		PATCH_SITE(pv_mmu_ops, read_cr2);

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
