Return-Path: <linux-kernel-owner+w=401wt.eu-S1761594AbYDNXFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761594AbYDNXFo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 19:05:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752639AbYDNXFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 19:05:35 -0400
Received: from tomts16.bellnexxia.net ([209.226.175.4]:65307 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752447AbYDNXFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 19:05:34 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Al0FAHOAA0hMQWoK/2dsb2JhbACBXqlugh4
Date: Mon, 14 Apr 2008 19:05:30 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Andi Kleen <andi@firstfloor.org>, akpm@osdl.org, mingo@elte.hu,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Frank Ch. Eigler" <fche@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC PATCH] x86 NMI-safe INT3 and Page Fault (v2)
Message-ID: <20080414230530.GB16061@Krystal>
References: <20080414230344.GA16061@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080414230344.GA16061@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 19:04:33 up 45 days, 19:15,  6 users,  load average: 1.09, 1.85,
	1.18
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(CCing lkml)

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

TODO : support paravirt ops.
TODO : test alpha and avr32 active count modification

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

tested on x86_64 AMD64
- instrumented the return path to export the EIP, CS and EFLAGS values when
  taken so we know the return path code has been executed.
- trace_mark, using immediate values, with 10ms delay with the breakpoint
  activated. Runs well through the return path.

To test on x86_64 :
- Test without preemption
- Test vmalloc faults
- Test on Intel 64 bits CPUs.

"This way lies madness. Don't go there."
- Andi

Changelog since v1 :
- x86_64 fixes.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Andi Kleen <andi@firstfloor.org>
CC: akpm@osdl.org
CC: mingo@elte.hu
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: "Frank Ch. Eigler" <fche@redhat.com>
---
 arch/x86/kernel/entry_32.S      |   25 +++++++++++++++-
 arch/x86/kernel/entry_64.S      |   31 ++++++++++++++++++++
 include/asm-alpha/thread_info.h |    2 -
 include/asm-avr32/thread_info.h |    2 -
 include/asm-x86/irqflags.h      |   61 ++++++++++++++++++++++++++++++++++++++++
 include/linux/hardirq.h         |   24 ++++++++++++++-
 6 files changed, 140 insertions(+), 5 deletions(-)

Index: linux-2.6-lttng/include/linux/hardirq.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/hardirq.h	2008-04-10 15:56:41.000000000 -0400
+++ linux-2.6-lttng/include/linux/hardirq.h	2008-04-10 16:02:06.000000000 -0400
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
@@ -63,6 +69,7 @@
 #define hardirq_count()	(preempt_count() & HARDIRQ_MASK)
 #define softirq_count()	(preempt_count() & SOFTIRQ_MASK)
 #define irq_count()	(preempt_count() & (HARDIRQ_MASK | SOFTIRQ_MASK))
+#define hardnmi_count()	(preempt_count() & HARDNMI_MASK)
 
 /*
  * Are we doing bottom half or hardware interrupt processing?
@@ -71,6 +78,7 @@
 #define in_irq()		(hardirq_count())
 #define in_softirq()		(softirq_count())
 #define in_interrupt()		(irq_count())
+#define in_nmi()		(hardnmi_count())
 
 /*
  * Are we running in atomic context?  WARNING: this macro cannot
@@ -159,7 +167,19 @@ extern void irq_enter(void);
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
--- linux-2.6-lttng.orig/arch/x86/kernel/entry_32.S	2008-04-10 16:02:04.000000000 -0400
+++ linux-2.6-lttng/arch/x86/kernel/entry_32.S	2008-04-11 07:52:36.000000000 -0400
@@ -79,7 +79,6 @@ VM_MASK		= 0x00020000
 #define preempt_stop(clobbers)	DISABLE_INTERRUPTS(clobbers); TRACE_IRQS_OFF
 #else
 #define preempt_stop(clobbers)
-#define resume_kernel		restore_nocheck
 #endif
 
 .macro TRACE_IRQS_IRET
@@ -265,6 +264,8 @@ END(ret_from_exception)
 #ifdef CONFIG_PREEMPT
 ENTRY(resume_kernel)
 	DISABLE_INTERRUPTS(CLBR_ANY)
+	testl $0x40000000,TI_preempt_count(%ebp)	# nested over NMI ?
+	jnz return_to_nmi
 	cmpl $0,TI_preempt_count(%ebp)	# non-zero preempt_count ?
 	jnz restore_nocheck
 need_resched:
@@ -276,6 +277,12 @@ need_resched:
 	call preempt_schedule_irq
 	jmp need_resched
 END(resume_kernel)
+#else
+ENTRY(resume_kernel)
+	testl $0x40000000,TI_preempt_count(%ebp)	# nested over NMI ?
+	jnz return_to_nmi
+	jmp restore_nocheck
+END(resume_kernel)
 #endif
 	CFI_ENDPROC
 
@@ -411,6 +418,22 @@ restore_nocheck_notrace:
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
Index: linux-2.6-lttng/arch/x86/kernel/entry_64.S
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kernel/entry_64.S	2008-04-10 16:02:05.000000000 -0400
+++ linux-2.6-lttng/arch/x86/kernel/entry_64.S	2008-04-11 07:52:36.000000000 -0400
@@ -593,12 +593,27 @@ retint_restore_args:	/* return to kernel
 	 * The iretq could re-enable interrupts:
 	 */
 	TRACE_IRQS_IRETQ
+	testl $0x40000000,threadinfo_preempt_count(%rcx) /* Nested over NMI ? */
+	jnz return_to_nmi
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
+	bt $8,EFLAGS-ARGOFFSET(%rsp)	/* trap flag? */
+	jc restore_args
+	RESTORE_ARGS 0,8,0
+	INTERRUPT_RETURN_NMI_SAFE
+
 	.section __ex_table, "a"
 	.quad irq_return, bad_iret
 	.previous
@@ -814,6 +829,10 @@ END(spurious_interrupt)
 	.macro paranoidexit trace=1
 	/* ebx:	no swapgs flag */
 paranoid_exit\trace:
+	GET_THREAD_INFO(%rcx)
+	testl $0x40000000,threadinfo_preempt_count(%rcx) /* Nested over NMI ? */
+	jnz paranoid_return_to_nmi\trace
+paranoid_exit_no_nmi\trace:
 	testl %ebx,%ebx				/* swapgs needed? */
 	jnz paranoid_restore\trace
 	testl $3,CS(%rsp)
@@ -826,6 +845,18 @@ paranoid_swapgs\trace:
 paranoid_restore\trace:
 	RESTORE_ALL 8
 	jmp irq_return
+paranoid_return_to_nmi\trace:		/*
+					 * If single-stepping an NMI handler,
+					 * use the normal iret path instead of
+					 * the popf/lret because lret would be
+					 * single-stepped. It should not
+					 * happen : it will reactivate NMIs
+					 * prematurely.
+					 */
+	bt $8,EFLAGS-0(%rsp)		/* trap flag? */
+	jc paranoid_exit_no_nmi\trace
+	RESTORE_ALL 8
+	INTERRUPT_RETURN_NMI_SAFE
 paranoid_userspace\trace:
 	GET_THREAD_INFO(%rcx)
 	movl threadinfo_flags(%rcx),%ebx
Index: linux-2.6-lttng/include/asm-x86/irqflags.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-x86/irqflags.h	2008-04-10 15:56:41.000000000 -0400
+++ linux-2.6-lttng/include/asm-x86/irqflags.h	2008-04-11 07:58:59.000000000 -0400
@@ -138,12 +138,73 @@ static inline unsigned long __raw_local_
 
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
+					pushq %rbx;		\
+					movq 40(%rsp), %rax;	\
+					movq 16(%rsp), %rbx;	\
+					subq $8, %rax;		\
+					movq %rbx, (%rax);	\
+					movq %rax, 40(%rsp);	\
+					popq %rbx;		\
+					popq %rax;		\
+					addq $16, %rsp;		\
+					popfq;			\
+					movq (%rsp), %rsp;	\
+					ret;			\
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
+					.byte 0xCA;	\
+					.word 4;
+
 #define ENABLE_INTERRUPTS_SYSCALL_RET	sti; sysexit
 #define GET_CR0_INTO_EAX		movl %cr0, %eax
 #endif
Index: linux-2.6-lttng/include/asm-alpha/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-alpha/thread_info.h	2008-04-10 16:02:04.000000000 -0400
+++ linux-2.6-lttng/include/asm-alpha/thread_info.h	2008-04-10 16:02:06.000000000 -0400
@@ -57,7 +57,7 @@ register struct thread_info *__current_t
 
 #endif /* __ASSEMBLY__ */
 
-#define PREEMPT_ACTIVE		0x40000000
+#define PREEMPT_ACTIVE		0x10000000
 
 /*
  * Thread information flags:
Index: linux-2.6-lttng/include/asm-avr32/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-avr32/thread_info.h	2008-04-10 16:02:04.000000000 -0400
+++ linux-2.6-lttng/include/asm-avr32/thread_info.h	2008-04-10 16:02:06.000000000 -0400
@@ -70,7 +70,7 @@ static inline struct thread_info *curren
 
 #endif /* !__ASSEMBLY__ */
 
-#define PREEMPT_ACTIVE		0x40000000
+#define PREEMPT_ACTIVE		0x10000000
 
 /*
  * Thread information flags

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
