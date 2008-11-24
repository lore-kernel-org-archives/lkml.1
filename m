Return-Path: <linux-kernel-owner+w=401wt.eu-S1753406AbYKXNdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406AbYKXNdR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 08:33:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751205AbYKXNdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 08:33:00 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:7095 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbYKXNc6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 08:32:58 -0500
Message-Id: <492ABB4D.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Mon, 24 Nov 2008 13:33:49 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Alexander van Heukelum" <heukelum@mailshack.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andi Kleen" <andi@firstfloor.org>,
       "Cyrill Gorcunov" <gorcunov@gmail.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Glauber Costa" <gcosta@redhat.com>, "Matt Mackall" <mpm@selenic.com>,
       "LKML" <linux-kernel@vger.kernel.org>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86_64: get rid of the use of KPROBE_ENTRY /
	 KPROBE_END
References: <20081120153954.GA22511@elte.hu>
 <20081121154155.GA12999@mailshack.com>
 <20081121154318.GA13014@mailshack.com>
 <20081121154428.GB13014@mailshack.com> <20081121160629.GA24839@elte.hu>
 <20081123090828.GA31490@mailshack.com>
 <20081123091532.GA31515@mailshack.com> <492A7F39.76E4.0078.0@novell.com>
 <20081124102600.GA8335@mailshack.com> <492A9199.76E4.0078.0@novell.com>
 <20081124122428.GA8497@mailshack.com>
In-Reply-To: <20081124122428.GA8497@mailshack.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I like things being done this way (including the goal of doing away with
KPROBE_{ENTRY,END} altogether). Thanks a lot! Jan

>>> Alexander van Heukelum <heukelum@mailshack.com> 24.11.08 13:24 >>>
entry_64.S is the only user of KPROBE_ENTRY / KPROBE_END on
x86_64. This patch reorders entry_64.S and explicitly generates
a separate section for functions that need the protection. The
generated code before and after the patch is equal.

Implicitly changing sections in assembly files makes it more
difficult to follow why the assembler is doing certain things.
For example,

.p2align 5
KPROBE_ENTRY(...)

was not doing what you would expect. Other section changes
(__ex_table, .fixup, .init.rodata) are done explicitly already.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/kernel/entry_64.S |  444 ++++++++++++++++++++++----------------------
 1 files changed, 220 insertions(+), 224 deletions(-)

On Mon, Nov 24, 2008 at 10:35:53AM +0000, Jan Beulich wrote:
> [...]
> 
> >I'm getting a feeling we would be better off removing KPROBE_ENTRY and
> >KPROBE_END if favour of explicitly changing sections in the .S files?
> >And using the ENDPROC annotation for all procedures?
> 
> It got explicitly added a while back, so there must have been a reason to
> *not* do the section adjustments explicitly. And given the current discussion
> I'd also assume that more hiding of code in macros is the preferred route.
> 
> Jan

Hallo Jan Beulich,

Let's see if this catches on. On i386 there is also only one user
of KPROBES_ENTRY / KPROBES_END: entry_32.S. If we remove those
entries in a similar way, we can get rid of them tree-wide.

Greetings,
	Alexander


diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index f2d546e..38fcd05 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1002,7 +1002,7 @@ END(\sym)
 .endm
 
 .macro paranoidzeroentry sym do_sym
-KPROBE_ENTRY(\sym)
+ENTRY(\sym)
 	INTR_FRAME
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
 	pushq $-1		/* ORIG_RAX: no syscall to restart */
@@ -1015,11 +1015,11 @@ KPROBE_ENTRY(\sym)
 	call \do_sym
 	jmp paranoid_exit	/* %ebx: no swapgs flag */
 	CFI_ENDPROC
-KPROBE_END(\sym)
+END(\sym)
 .endm
 
 .macro paranoidzeroentry_ist sym do_sym ist
-KPROBE_ENTRY(\sym)
+ENTRY(\sym)
  	INTR_FRAME
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
 	pushq $-1		/* ORIG_RAX: no syscall to restart */
@@ -1035,15 +1035,11 @@ KPROBE_ENTRY(\sym)
 	addq $EXCEPTION_STKSZ, per_cpu__init_tss + TSS_ist + (\ist - 1) * 8(%rbp)
 	jmp paranoid_exit	/* %ebx: no swapgs flag */
 	CFI_ENDPROC
-KPROBE_END(\sym)
+END(\sym)
 .endm
 
-.macro errorentry sym do_sym entry=0
-.if \entry
-KPROBE_ENTRY(\sym)
-.else
+.macro errorentry sym do_sym
 ENTRY(\sym)
-.endif
 	XCPT_FRAME
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
 	subq $15*8,%rsp
@@ -1056,20 +1052,12 @@ ENTRY(\sym)
 	call \do_sym
 	jmp error_exit			/* %ebx: no swapgs flag */
 	CFI_ENDPROC
-.if \entry
-KPROBE_END(\sym)
-.else
 END(\sym)
-.endif
 .endm
 
 	/* error code is on the stack already */
-.macro paranoiderrorentry sym do_sym entry=1
-.if \entry
-KPROBE_ENTRY(\sym)
-.else
+.macro paranoiderrorentry sym do_sym
 ENTRY(\sym)
-.endif
 	XCPT_FRAME
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
 	subq $15*8,%rsp
@@ -1083,166 +1071,23 @@ ENTRY(\sym)
 	call \do_sym
 	jmp paranoid_exit		/* %ebx: no swapgs flag */
 	CFI_ENDPROC
-.if \entry
-KPROBE_END(\sym)
-.else
 END(\sym)
-.endif
 .endm
 
 zeroentry divide_error do_divide_error
-paranoidzeroentry_ist debug do_debug DEBUG_STACK
-paranoidzeroentry_ist int3 do_int3 DEBUG_STACK
 zeroentry overflow do_overflow
 zeroentry bounds do_bounds
 zeroentry invalid_op do_invalid_op
 zeroentry device_not_available do_device_not_available
-paranoiderrorentry double_fault do_double_fault 0
+paranoiderrorentry double_fault do_double_fault
 zeroentry coprocessor_segment_overrun do_coprocessor_segment_overrun
 errorentry invalid_TSS do_invalid_TSS
 errorentry segment_not_present do_segment_not_present
-paranoiderrorentry stack_segment do_stack_segment
-errorentry general_protection do_general_protection 1
-errorentry page_fault do_page_fault 1
 zeroentry spurious_interrupt_bug do_spurious_interrupt_bug
 zeroentry coprocessor_error do_coprocessor_error
 errorentry alignment_check do_alignment_check
-#ifdef CONFIG_X86_MCE
-paranoidzeroentry machine_check do_machine_check
-#endif
 zeroentry simd_coprocessor_error do_simd_coprocessor_error
 
-	/*
- 	 * "Paranoid" exit path from exception stack.
-  	 * Paranoid because this is used by NMIs and cannot take
-	 * any kernel state for granted.
-	 * We don't do kernel preemption checks here, because only
-	 * NMI should be common and it does not enable IRQs and
-	 * cannot get reschedule ticks.
-	 *
-	 * "trace" is 0 for the NMI handler only, because irq-tracing
-	 * is fundamentally NMI-unsafe. (we cannot change the soft and
-	 * hard flags at once, atomically)
-	 */
-
-	/* ebx:	no swapgs flag */
-KPROBE_ENTRY(paranoid_exit)
-	INTR_FRAME
-	DISABLE_INTERRUPTS(CLBR_NONE)
-	TRACE_IRQS_OFF
-	testl %ebx,%ebx				/* swapgs needed? */
-	jnz paranoid_restore
-	testl $3,CS(%rsp)
-	jnz   paranoid_userspace
-paranoid_swapgs:
-	TRACE_IRQS_IRETQ 0
-	SWAPGS_UNSAFE_STACK
-paranoid_restore:
-	RESTORE_ALL 8
-	jmp irq_return
-paranoid_userspace:
-	GET_THREAD_INFO(%rcx)
-	movl TI_flags(%rcx),%ebx
-	andl $_TIF_WORK_MASK,%ebx
-	jz paranoid_swapgs
-	movq %rsp,%rdi			/* &pt_regs */
-	call sync_regs
-	movq %rax,%rsp			/* switch stack for scheduling */
-	testl $_TIF_NEED_RESCHED,%ebx
-	jnz paranoid_schedule
-	movl %ebx,%edx			/* arg3: thread flags */
-	TRACE_IRQS_ON
-	ENABLE_INTERRUPTS(CLBR_NONE)
-	xorl %esi,%esi 			/* arg2: oldset */
-	movq %rsp,%rdi 			/* arg1: &pt_regs */
-	call do_notify_resume
-	DISABLE_INTERRUPTS(CLBR_NONE)
-	TRACE_IRQS_OFF
-	jmp paranoid_userspace
-paranoid_schedule:
-	TRACE_IRQS_ON
-	ENABLE_INTERRUPTS(CLBR_ANY)
-	call schedule
-	DISABLE_INTERRUPTS(CLBR_ANY)
-	TRACE_IRQS_OFF
-	jmp paranoid_userspace
-	CFI_ENDPROC
-KPROBE_END(paranoid_exit)
-
-/*
- * Exception entry point. This expects an error code/orig_rax on the stack.
- * returns in "no swapgs flag" in %ebx.
- */
-KPROBE_ENTRY(error_entry)
-	XCPT_FRAME
-	CFI_ADJUST_CFA_OFFSET 15*8
-	/* oldrax contains error code */
-	cld
-	movq_cfi rdi, RDI+8
-	movq_cfi rsi, RSI+8
-	movq_cfi rdx, RDX+8
-	movq_cfi rcx, RCX+8
-	movq_cfi rax, RAX+8
-	movq_cfi  r8,  R8+8
-	movq_cfi  r9,  R9+8
-	movq_cfi r10, R10+8
-	movq_cfi r11, R11+8
-	movq_cfi rbx, RBX+8
-	movq_cfi rbp, RBP+8
-	movq_cfi r12, R12+8
-	movq_cfi r13, R13+8
-	movq_cfi r14, R14+8
-	movq_cfi r15, R15+8
-	xorl %ebx,%ebx
-	testl $3,CS+8(%rsp)
-	je error_kernelspace
-error_swapgs:
-	SWAPGS
-error_sti:
-	TRACE_IRQS_OFF
-	ret
-	CFI_ENDPROC
-
-/*
- * There are two places in the kernel that can potentially fault with
- * usergs. Handle them here. The exception handlers after iret run with
- * kernel gs again, so don't set the user space flag. B stepping K8s
- * sometimes report an truncated RIP for IRET exceptions returning to
- * compat mode. Check for these here too.
- */
-error_kernelspace:
-	incl %ebx
-	leaq irq_return(%rip),%rcx
-	cmpq %rcx,RIP+8(%rsp)
-	je error_swapgs
-	movl %ecx,%ecx	/* zero extend */
-	cmpq %rcx,RIP+8(%rsp)
-	je error_swapgs
-	cmpq $gs_change,RIP+8(%rsp)
-        je error_swapgs
-	jmp error_sti
-KPROBE_END(error_entry)
-
-
-/* ebx:	no swapgs flag (1: don't need swapgs, 0: need it) */
-KPROBE_ENTRY(error_exit)
-	DEFAULT_FRAME
-	movl %ebx,%eax
-	RESTORE_REST
-	DISABLE_INTERRUPTS(CLBR_NONE)
-	TRACE_IRQS_OFF
-	GET_THREAD_INFO(%rcx)
-	testl %eax,%eax
-	jne retint_kernel
-	LOCKDEP_SYS_EXIT_IRQ
-	movl TI_flags(%rcx),%edx
-	movl $_TIF_WORK_MASK,%edi
-	andl %edi,%edx
-	jnz retint_careful
-	jmp retint_swapgs
-	CFI_ENDPROC
-KPROBE_END(error_exit)
-
        /* Reload gs selector with exception handling */
        /* edi:  new selector */
 ENTRY(native_load_gs_index)
@@ -1362,61 +1207,6 @@ ENTRY(kernel_execve)
 	CFI_ENDPROC
 END(kernel_execve)
 
-	/* runs on exception stack */
-KPROBE_ENTRY(nmi)
-	INTR_FRAME
-	PARAVIRT_ADJUST_EXCEPTION_FRAME
-	pushq_cfi $-1
-	subq $15*8, %rsp
-	CFI_ADJUST_CFA_OFFSET 15*8
-	call save_paranoid
-	DEFAULT_FRAME 0
-	/* paranoidentry do_nmi, 0; without TRACE_IRQS_OFF */
-	movq %rsp,%rdi
-	movq $-1,%rsi
-	call do_nmi
-#ifdef CONFIG_TRACE_IRQFLAGS
-	/* paranoidexit; without TRACE_IRQS_OFF */
-	/* ebx:	no swapgs flag */
-	DISABLE_INTERRUPTS(CLBR_NONE)
-	testl %ebx,%ebx				/* swapgs needed? */
-	jnz nmi_restore
-	testl $3,CS(%rsp)
-	jnz nmi_userspace
-nmi_swapgs:
-	SWAPGS_UNSAFE_STACK
-nmi_restore:
-	RESTORE_ALL 8
-	jmp irq_return
-nmi_userspace:
-	GET_THREAD_INFO(%rcx)
-	movl TI_flags(%rcx),%ebx
-	andl $_TIF_WORK_MASK,%ebx
-	jz nmi_swapgs
-	movq %rsp,%rdi			/* &pt_regs */
-	call sync_regs
-	movq %rax,%rsp			/* switch stack for scheduling */
-	testl $_TIF_NEED_RESCHED,%ebx
-	jnz nmi_schedule
-	movl %ebx,%edx			/* arg3: thread flags */
-	ENABLE_INTERRUPTS(CLBR_NONE)
-	xorl %esi,%esi 			/* arg2: oldset */
-	movq %rsp,%rdi 			/* arg1: &pt_regs */
-	call do_notify_resume
-	DISABLE_INTERRUPTS(CLBR_NONE)
-	jmp nmi_userspace
-nmi_schedule:
-	ENABLE_INTERRUPTS(CLBR_ANY)
-	call schedule
-	DISABLE_INTERRUPTS(CLBR_ANY)
-	jmp nmi_userspace
-	CFI_ENDPROC
-#else
-	jmp paranoid_exit
- 	CFI_ENDPROC
-#endif
-KPROBE_END(nmi)
-
 /* Call softirq on interrupt stack. Interrupts are off. */
 ENTRY(call_softirq)
 	CFI_STARTPROC
@@ -1437,13 +1227,6 @@ ENTRY(call_softirq)
 	CFI_ENDPROC
 END(call_softirq)
 
-KPROBE_ENTRY(ignore_sysret)
-	CFI_STARTPROC
-	mov $-ENOSYS,%eax
-	sysret
-	CFI_ENDPROC
-KPROBE_END(ignore_sysret)
-
 #ifdef CONFIG_XEN
 zeroentry xen_hypervisor_callback xen_do_hypervisor_callback
 
@@ -1540,3 +1323,216 @@ ENTRY(xen_failsafe_callback)
 END(xen_failsafe_callback)
 
 #endif /* CONFIG_XEN */
+
+/*
+ * Some functions should be protected against kprobes
+ */
+	.pushsection .kprobes.text, "ax"
+
+paranoidzeroentry_ist debug do_debug DEBUG_STACK
+paranoidzeroentry_ist int3 do_int3 DEBUG_STACK
+paranoiderrorentry stack_segment do_stack_segment
+errorentry general_protection do_general_protection
+errorentry page_fault do_page_fault
+#ifdef CONFIG_X86_MCE
+paranoidzeroentry machine_check do_machine_check
+#endif
+
+	/*
+ 	 * "Paranoid" exit path from exception stack.
+  	 * Paranoid because this is used by NMIs and cannot take
+	 * any kernel state for granted.
+	 * We don't do kernel preemption checks here, because only
+	 * NMI should be common and it does not enable IRQs and
+	 * cannot get reschedule ticks.
+	 *
+	 * "trace" is 0 for the NMI handler only, because irq-tracing
+	 * is fundamentally NMI-unsafe. (we cannot change the soft and
+	 * hard flags at once, atomically)
+	 */
+
+	/* ebx:	no swapgs flag */
+ENTRY(paranoid_exit)
+	INTR_FRAME
+	DISABLE_INTERRUPTS(CLBR_NONE)
+	TRACE_IRQS_OFF
+	testl %ebx,%ebx				/* swapgs needed? */
+	jnz paranoid_restore
+	testl $3,CS(%rsp)
+	jnz   paranoid_userspace
+paranoid_swapgs:
+	TRACE_IRQS_IRETQ 0
+	SWAPGS_UNSAFE_STACK
+paranoid_restore:
+	RESTORE_ALL 8
+	jmp irq_return
+paranoid_userspace:
+	GET_THREAD_INFO(%rcx)
+	movl TI_flags(%rcx),%ebx
+	andl $_TIF_WORK_MASK,%ebx
+	jz paranoid_swapgs
+	movq %rsp,%rdi			/* &pt_regs */
+	call sync_regs
+	movq %rax,%rsp			/* switch stack for scheduling */
+	testl $_TIF_NEED_RESCHED,%ebx
+	jnz paranoid_schedule
+	movl %ebx,%edx			/* arg3: thread flags */
+	TRACE_IRQS_ON
+	ENABLE_INTERRUPTS(CLBR_NONE)
+	xorl %esi,%esi 			/* arg2: oldset */
+	movq %rsp,%rdi 			/* arg1: &pt_regs */
+	call do_notify_resume
+	DISABLE_INTERRUPTS(CLBR_NONE)
+	TRACE_IRQS_OFF
+	jmp paranoid_userspace
+paranoid_schedule:
+	TRACE_IRQS_ON
+	ENABLE_INTERRUPTS(CLBR_ANY)
+	call schedule
+	DISABLE_INTERRUPTS(CLBR_ANY)
+	TRACE_IRQS_OFF
+	jmp paranoid_userspace
+	CFI_ENDPROC
+END(paranoid_exit)
+
+/*
+ * Exception entry point. This expects an error code/orig_rax on the stack.
+ * returns in "no swapgs flag" in %ebx.
+ */
+ENTRY(error_entry)
+	XCPT_FRAME
+	CFI_ADJUST_CFA_OFFSET 15*8
+	/* oldrax contains error code */
+	cld
+	movq_cfi rdi, RDI+8
+	movq_cfi rsi, RSI+8
+	movq_cfi rdx, RDX+8
+	movq_cfi rcx, RCX+8
+	movq_cfi rax, RAX+8
+	movq_cfi  r8,  R8+8
+	movq_cfi  r9,  R9+8
+	movq_cfi r10, R10+8
+	movq_cfi r11, R11+8
+	movq_cfi rbx, RBX+8
+	movq_cfi rbp, RBP+8
+	movq_cfi r12, R12+8
+	movq_cfi r13, R13+8
+	movq_cfi r14, R14+8
+	movq_cfi r15, R15+8
+	xorl %ebx,%ebx
+	testl $3,CS+8(%rsp)
+	je error_kernelspace
+error_swapgs:
+	SWAPGS
+error_sti:
+	TRACE_IRQS_OFF
+	ret
+	CFI_ENDPROC
+
+/*
+ * There are two places in the kernel that can potentially fault with
+ * usergs. Handle them here. The exception handlers after iret run with
+ * kernel gs again, so don't set the user space flag. B stepping K8s
+ * sometimes report an truncated RIP for IRET exceptions returning to
+ * compat mode. Check for these here too.
+ */
+error_kernelspace:
+	incl %ebx
+	leaq irq_return(%rip),%rcx
+	cmpq %rcx,RIP+8(%rsp)
+	je error_swapgs
+	movl %ecx,%ecx	/* zero extend */
+	cmpq %rcx,RIP+8(%rsp)
+	je error_swapgs
+	cmpq $gs_change,RIP+8(%rsp)
+        je error_swapgs
+	jmp error_sti
+END(error_entry)
+
+
+/* ebx:	no swapgs flag (1: don't need swapgs, 0: need it) */
+ENTRY(error_exit)
+	DEFAULT_FRAME
+	movl %ebx,%eax
+	RESTORE_REST
+	DISABLE_INTERRUPTS(CLBR_NONE)
+	TRACE_IRQS_OFF
+	GET_THREAD_INFO(%rcx)
+	testl %eax,%eax
+	jne retint_kernel
+	LOCKDEP_SYS_EXIT_IRQ
+	movl TI_flags(%rcx),%edx
+	movl $_TIF_WORK_MASK,%edi
+	andl %edi,%edx
+	jnz retint_careful
+	jmp retint_swapgs
+	CFI_ENDPROC
+END(error_exit)
+
+
+	/* runs on exception stack */
+ENTRY(nmi)
+	INTR_FRAME
+	PARAVIRT_ADJUST_EXCEPTION_FRAME
+	pushq_cfi $-1
+	subq $15*8, %rsp
+	CFI_ADJUST_CFA_OFFSET 15*8
+	call save_paranoid
+	DEFAULT_FRAME 0
+	/* paranoidentry do_nmi, 0; without TRACE_IRQS_OFF */
+	movq %rsp,%rdi
+	movq $-1,%rsi
+	call do_nmi
+#ifdef CONFIG_TRACE_IRQFLAGS
+	/* paranoidexit; without TRACE_IRQS_OFF */
+	/* ebx:	no swapgs flag */
+	DISABLE_INTERRUPTS(CLBR_NONE)
+	testl %ebx,%ebx				/* swapgs needed? */
+	jnz nmi_restore
+	testl $3,CS(%rsp)
+	jnz nmi_userspace
+nmi_swapgs:
+	SWAPGS_UNSAFE_STACK
+nmi_restore:
+	RESTORE_ALL 8
+	jmp irq_return
+nmi_userspace:
+	GET_THREAD_INFO(%rcx)
+	movl TI_flags(%rcx),%ebx
+	andl $_TIF_WORK_MASK,%ebx
+	jz nmi_swapgs
+	movq %rsp,%rdi			/* &pt_regs */
+	call sync_regs
+	movq %rax,%rsp			/* switch stack for scheduling */
+	testl $_TIF_NEED_RESCHED,%ebx
+	jnz nmi_schedule
+	movl %ebx,%edx			/* arg3: thread flags */
+	ENABLE_INTERRUPTS(CLBR_NONE)
+	xorl %esi,%esi 			/* arg2: oldset */
+	movq %rsp,%rdi 			/* arg1: &pt_regs */
+	call do_notify_resume
+	DISABLE_INTERRUPTS(CLBR_NONE)
+	jmp nmi_userspace
+nmi_schedule:
+	ENABLE_INTERRUPTS(CLBR_ANY)
+	call schedule
+	DISABLE_INTERRUPTS(CLBR_ANY)
+	jmp nmi_userspace
+	CFI_ENDPROC
+#else
+	jmp paranoid_exit
+ 	CFI_ENDPROC
+#endif
+END(nmi)
+
+ENTRY(ignore_sysret)
+	CFI_STARTPROC
+	mov $-ENOSYS,%eax
+	sysret
+	CFI_ENDPROC
+END(ignore_sysret)
+
+/*
+ * End of kprobes section
+ */
+	.popsection
-- 
1.5.4.3

