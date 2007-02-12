Return-Path: <linux-kernel-owner+w=401wt.eu-S964982AbXBLQ5I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964982AbXBLQ5I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 11:57:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964989AbXBLQvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 11:51:37 -0500
Received: from mx1.suse.de ([195.135.220.2]:47917 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964979AbXBLQvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 11:51:31 -0500
From: Andi Kleen <ak@suse.de>
References: <20070212551.664370000@suse.de>
In-Reply-To: <20070212551.664370000@suse.de>
To: "Jan Beulich" <jbeulich@novell.com>, Andi Kleen <ak@suse.de>,
       patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH x86 for review III] [3/29] i386: entry.S END/ENDPROC annotations
Message-Id: <20070212165122.CF44513F7A@wotan.suse.de>
Date: Mon, 12 Feb 2007 17:51:22 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "Jan Beulich" <jbeulich@novell.com>

Annotate i386/kernel/entry.S with END/ENDPROC to assist disassemblers and
other analysis tools.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/entry.S |   41 +++++++++++++++++++++++++++++++++++++----
 1 file changed, 37 insertions(+), 4 deletions(-)

Index: linux/arch/i386/kernel/entry.S
===================================================================
--- linux.orig/arch/i386/kernel/entry.S
+++ linux/arch/i386/kernel/entry.S
@@ -227,6 +227,7 @@ ENTRY(ret_from_fork)
 	CFI_ADJUST_CFA_OFFSET -4
 	jmp syscall_exit
 	CFI_ENDPROC
+END(ret_from_fork)
 
 /*
  * Return to user mode is not as complex as all this looks,
@@ -258,6 +259,7 @@ ENTRY(resume_userspace)
 					# int/exception return?
 	jne work_pending
 	jmp restore_all
+END(ret_from_exception)
 
 #ifdef CONFIG_PREEMPT
 ENTRY(resume_kernel)
@@ -272,6 +274,7 @@ need_resched:
 	jz restore_all
 	call preempt_schedule_irq
 	jmp need_resched
+END(resume_kernel)
 #endif
 	CFI_ENDPROC
 
@@ -359,6 +362,7 @@ sysenter_past_esp:
 	.align 4
 	.long 1b,2b
 .popsection
+ENDPROC(sysenter_entry)
 
 	# system call handler stub
 ENTRY(system_call)
@@ -459,6 +463,7 @@ ldt_ss:
 	CFI_ADJUST_CFA_OFFSET -8
 	jmp restore_nocheck
 	CFI_ENDPROC
+ENDPROC(system_call)
 
 	# perform work that needs to be done immediately before resumption
 	ALIGN
@@ -504,6 +509,7 @@ work_notifysig_v86:
 	xorl %edx, %edx
 	call do_notify_resume
 	jmp resume_userspace_sig
+END(work_pending)
 
 	# perform syscall exit tracing
 	ALIGN
@@ -519,6 +525,7 @@ syscall_trace_entry:
 	cmpl $(nr_syscalls), %eax
 	jnae syscall_call
 	jmp syscall_exit
+END(syscall_trace_entry)
 
 	# perform syscall exit tracing
 	ALIGN
@@ -532,6 +539,7 @@ syscall_exit_work:
 	movl $1, %edx
 	call do_syscall_trace
 	jmp resume_userspace
+END(syscall_exit_work)
 	CFI_ENDPROC
 
 	RING0_INT_FRAME			# can't unwind into user space anyway
@@ -542,10 +550,12 @@ syscall_fault:
 	GET_THREAD_INFO(%ebp)
 	movl $-EFAULT,PT_EAX(%esp)
 	jmp resume_userspace
+END(syscall_fault)
 
 syscall_badsys:
 	movl $-ENOSYS,PT_EAX(%esp)
 	jmp resume_userspace
+END(syscall_badsys)
 	CFI_ENDPROC
 
 #define FIXUP_ESPFIX_STACK \
@@ -581,9 +591,9 @@ syscall_badsys:
 ENTRY(interrupt)
 .text
 
-vector=0
 ENTRY(irq_entries_start)
 	RING0_INT_FRAME
+vector=0
 .rept NR_IRQS
 	ALIGN
  .if vector
@@ -592,11 +602,16 @@ ENTRY(irq_entries_start)
 1:	pushl $~(vector)
 	CFI_ADJUST_CFA_OFFSET 4
 	jmp common_interrupt
-.data
+ .previous
 	.long 1b
-.text
+ .text
 vector=vector+1
 .endr
+END(irq_entries_start)
+
+.previous
+END(interrupt)
+.previous
 
 /*
  * the CPU automatically disables interrupts when executing an IRQ vector,
@@ -609,6 +624,7 @@ common_interrupt:
 	movl %esp,%eax
 	call do_IRQ
 	jmp ret_from_intr
+ENDPROC(common_interrupt)
 	CFI_ENDPROC
 
 #define BUILD_INTERRUPT(name, nr)	\
@@ -621,7 +637,8 @@ ENTRY(name)				\
 	movl %esp,%eax;			\
 	call smp_/**/name;		\
 	jmp ret_from_intr;		\
-	CFI_ENDPROC
+	CFI_ENDPROC;			\
+ENDPROC(name)
 
 /* The include is where all of the SMP etc. interrupts come from */
 #include "entry_arch.h"
@@ -697,6 +714,7 @@ ENTRY(coprocessor_error)
 	CFI_ADJUST_CFA_OFFSET 4
 	jmp error_code
 	CFI_ENDPROC
+END(coprocessor_error)
 
 ENTRY(simd_coprocessor_error)
 	RING0_INT_FRAME
@@ -706,6 +724,7 @@ ENTRY(simd_coprocessor_error)
 	CFI_ADJUST_CFA_OFFSET 4
 	jmp error_code
 	CFI_ENDPROC
+END(simd_coprocessor_error)
 
 ENTRY(device_not_available)
 	RING0_INT_FRAME
@@ -726,6 +745,7 @@ device_not_available_emulate:
 	CFI_ADJUST_CFA_OFFSET -4
 	jmp ret_from_exception
 	CFI_ENDPROC
+END(device_not_available)
 
 /*
  * Debug traps and NMI can happen at the one SYSENTER instruction
@@ -869,10 +889,12 @@ ENTRY(native_iret)
 	.align 4
 	.long 1b,iret_exc
 .previous
+END(native_iret)
 
 ENTRY(native_irq_enable_sysexit)
 	sti
 	sysexit
+END(native_irq_enable_sysexit)
 #endif
 
 KPROBE_ENTRY(int3)
@@ -895,6 +917,7 @@ ENTRY(overflow)
 	CFI_ADJUST_CFA_OFFSET 4
 	jmp error_code
 	CFI_ENDPROC
+END(overflow)
 
 ENTRY(bounds)
 	RING0_INT_FRAME
@@ -904,6 +927,7 @@ ENTRY(bounds)
 	CFI_ADJUST_CFA_OFFSET 4
 	jmp error_code
 	CFI_ENDPROC
+END(bounds)
 
 ENTRY(invalid_op)
 	RING0_INT_FRAME
@@ -913,6 +937,7 @@ ENTRY(invalid_op)
 	CFI_ADJUST_CFA_OFFSET 4
 	jmp error_code
 	CFI_ENDPROC
+END(invalid_op)
 
 ENTRY(coprocessor_segment_overrun)
 	RING0_INT_FRAME
@@ -922,6 +947,7 @@ ENTRY(coprocessor_segment_overrun)
 	CFI_ADJUST_CFA_OFFSET 4
 	jmp error_code
 	CFI_ENDPROC
+END(coprocessor_segment_overrun)
 
 ENTRY(invalid_TSS)
 	RING0_EC_FRAME
@@ -929,6 +955,7 @@ ENTRY(invalid_TSS)
 	CFI_ADJUST_CFA_OFFSET 4
 	jmp error_code
 	CFI_ENDPROC
+END(invalid_TSS)
 
 ENTRY(segment_not_present)
 	RING0_EC_FRAME
@@ -936,6 +963,7 @@ ENTRY(segment_not_present)
 	CFI_ADJUST_CFA_OFFSET 4
 	jmp error_code
 	CFI_ENDPROC
+END(segment_not_present)
 
 ENTRY(stack_segment)
 	RING0_EC_FRAME
@@ -943,6 +971,7 @@ ENTRY(stack_segment)
 	CFI_ADJUST_CFA_OFFSET 4
 	jmp error_code
 	CFI_ENDPROC
+END(stack_segment)
 
 KPROBE_ENTRY(general_protection)
 	RING0_EC_FRAME
@@ -958,6 +987,7 @@ ENTRY(alignment_check)
 	CFI_ADJUST_CFA_OFFSET 4
 	jmp error_code
 	CFI_ENDPROC
+END(alignment_check)
 
 ENTRY(divide_error)
 	RING0_INT_FRAME
@@ -967,6 +997,7 @@ ENTRY(divide_error)
 	CFI_ADJUST_CFA_OFFSET 4
 	jmp error_code
 	CFI_ENDPROC
+END(divide_error)
 
 #ifdef CONFIG_X86_MCE
 ENTRY(machine_check)
@@ -977,6 +1008,7 @@ ENTRY(machine_check)
 	CFI_ADJUST_CFA_OFFSET 4
 	jmp error_code
 	CFI_ENDPROC
+END(machine_check)
 #endif
 
 ENTRY(spurious_interrupt_bug)
@@ -987,6 +1019,7 @@ ENTRY(spurious_interrupt_bug)
 	CFI_ADJUST_CFA_OFFSET 4
 	jmp error_code
 	CFI_ENDPROC
+END(spurious_interrupt_bug)
 
 ENTRY(kernel_thread_helper)
 	pushl $0		# fake return address for unwinder
