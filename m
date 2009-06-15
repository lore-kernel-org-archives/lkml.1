Return-Path: <linux-kernel-owner+w=401wt.eu-S1764856AbZFORms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764856AbZFORms (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 13:42:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758315AbZFORmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 13:42:40 -0400
Received: from tomts22-srv.bellnexxia.net ([209.226.175.184]:43686 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751320AbZFORmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 13:42:39 -0400
X-Greylist: delayed 5253 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Jun 2009 13:42:38 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AokFAHMeNkpMQWQl/2dsb2JhbACBT9UlgkKBSwU
Date: Mon, 15 Jun 2009 13:42:23 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       penberg@cs.helsinki.fi, torvalds@linux-foundation.org,
       vegard.nossum@gmail.com, efault@gmx.de, jeremy@goop.org,
       npiggin@suse.de, tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: x86: Fix call-chain
	support to use NMI-safe methods
Message-ID: <20090615174223.GA4201@Krystal>
References: <tip-74193ef0ecab92535c8517f082f1f50504526c9b@git.kernel.org> <20090615161459.GA1280@Krystal> <20090615170556.GA25760@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090615170556.GA25760@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:24:52 up 107 days, 13:51,  3 users,  load average: 0.09, 0.24,
	0.41
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > * tip-bot for Peter Zijlstra (a.p.zijlstra@chello.nl) wrote:
> > > Commit-ID:  74193ef0ecab92535c8517f082f1f50504526c9b
> > > Gitweb:     http://git.kernel.org/tip/74193ef0ecab92535c8517f082f1f50504526c9b
> > > Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > AuthorDate: Mon, 15 Jun 2009 13:07:24 +0200
> > > Committer:  Ingo Molnar <mingo@elte.hu>
> > > CommitDate: Mon, 15 Jun 2009 15:57:53 +0200
> > > 
> > > perf_counter: x86: Fix call-chain support to use NMI-safe methods
> > > 
> > > __copy_from_user_inatomic() isn't NMI safe in that it can trigger
> > > the page fault handler which is another trap and its return path
> > > invokes IRET which will also close the NMI context.
> > > 
> > > Therefore use a GUP based approach to copy the stack frames over.
> > > 
> > > We tried an alternative solution as well: we used a forward ported
> > > version of Mathieu Desnoyers's "NMI safe INT3 and Page Fault" patch
> > > that modifies the exception return path to use an open-coded IRET with
> > > explicit stack unrolling and TF checking.
> > > 
> > > This didnt work as it interacted with faulting user-space instructions,
> > > causing them not to restart properly, which corrupts user-space
> > > registers.
> > > 
> > > Solving that would probably involve disassembling those instructions
> > > and backtracing the RIP. But even without that, the code was deemed
> > > rather complex to the already non-trivial x86 entry assembly code,
> > > so instead we went for this GUP based method that does a
> > > software-walk of the pagetables.
> > > 
> > 
> > Hrm, I'm probably missing something. Normally, you should test for 
> > "in_nmi()" upon return from exception, and only in these cases go 
> > for the open-coded IRET with stack unrolling and ret. I really 
> > don't see how you end up messing up the page fault return to 
> > userspace path, as it's impossible to have in_nmi() set.
> 
> here's the (heavily modified) version of your patch that i used.
> 
> 	Ingo
> 
> -------------------->
> Subject: x86 NMI-safe INT3 and Page Fault
> From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> Date: Mon, 12 May 2008 21:21:07 +0200
> 
> Implements an alternative iret with popf and return so trap and exception
> handlers can return to the NMI handler without issuing iret. iret would cause
> NMIs to be reenabled prematurely. x86_32 uses popf and far return. x86_64 has to
> copy the return instruction pointer to the top of the previous stack, issue a
> popf, loads the previous esp and issue a near return (ret).
> 
> It allows placing immediate values (and therefore optimized trace_marks) in NMI
> code since returning from a breakpoint would be valid. Accessing vmalloc'd
> memory, which allows executing module code or accessing vmapped or vmalloc'd
> areas from NMI context, would also be valid. This is very useful to tracers like
> LTTng.
> 
> This patch makes all faults, traps and exception safe to be called from NMI
> context *except* single-stepping, which requires iret to restore the TF (trap
> flag) and jump to the return address in a single instruction. Sorry, no kprobes
> support in NMI handlers because of this limitation.  We cannot single-step an
> NMI handler, because iret must set the TF flag and return back to the
> instruction to single-step in a single instruction. This cannot be emulated with
> popf/lret, because lret would be single-stepped. It does not apply to immediate
> values because they do not use single-stepping. This code detects if the TF
> flag is set and uses the iret path for single-stepping, even if it reactivates
> NMIs prematurely.
> 
> Test to detect if nested under a NMI handler is only done upon the return from
> trap/exception to kernel, which is not frequent. Other return paths (return from
> trap/exception to userspace, return from interrupt) keep the exact same behavior
> (no slowdown).
> 
> Depends on :
> change-alpha-active-count-bit.patch
> change-avr32-active-count-bit.patch
> 
> TODO : test with lguest, xen, kvm.
> 
> ** This patch depends on the "Stringify support commas" patchset **
> ** Also depends on fix-x86_64-page-fault-scheduler-race patch **
> 
> tested on x86_32 (tests implemented in a separate patch) :
> - instrumented the return path to export the EIP, CS and EFLAGS values when
>   taken so we know the return path code has been executed.
> - trace_mark, using immediate values, with 10ms delay with the breakpoint
>   activated. Runs well through the return path.
> - tested vmalloc faults in NMI handler by placing a non-optimized marker in the
>   NMI handler (so no breakpoint is executed) and connecting a probe which
>   touches every pages of a 20MB vmalloc'd buffer. It executes trough the return
>   path without problem.
> - Tested with and without preemption
> 
> tested on x86_64
> - instrumented the return path to export the EIP, CS and EFLAGS values when
>   taken so we know the return path code has been executed.
> - trace_mark, using immediate values, with 10ms delay with the breakpoint
>   activated. Runs well through the return path.
> 
> To test on x86_64 :
> - Test without preemption
> - Test vmalloc faults
> - Test on Intel 64 bits CPUs. (AMD64 was fine)
> 
> Changelog since v1 :
> - x86_64 fixes.
> Changelog since v2 :
> - fix paravirt build
> Changelog since v3 :
> - Include modifications suggested by Jeremy
> Changelog since v4 :
> - including hardirq.h in entry_32/64.S is a bad idea (non ifndef'd C code),
>   define HARDNMI_MASK in the .S files directly.
> Changelog since v5 :
> - Add HARDNMI_MASK to irq_count() and make die() more verbose for NMIs.
> Changelog since v7 :
> - Implement paravirtualized nmi_return.
> Changelog since v8 :
> - refreshed the patch for asm-offsets. Those were left out of v8.
> - now depends on "Stringify support commas" patch.
> Changelog since v9 :
> - Only test the nmi nested preempt count flag upon return from exceptions, not
>   on return from interrupts. Only the kernel return path has this test.
> - Add Xen, VMI, lguest support. Use their iret pavavirt ops in lieu of
>   nmi_return.
> 
> -- Ported to sched-devel.git
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> CC: akpm@osdl.org
> CC: mingo@elte.hu
> CC: "H. Peter Anvin" <hpa@zytor.com>
> CC: Jeremy Fitzhardinge <jeremy@goop.org>
> CC: Steven Rostedt <rostedt@goodmis.org>
> CC: "Frank Ch. Eigler" <fche@redhat.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  arch/x86/include/asm/irqflags.h |   56 +++++++++++++++++++++++++++++++++++++++
>  arch/x86/kernel/dumpstack.c     |    2 +
>  arch/x86/kernel/entry_32.S      |   30 +++++++++++++++++++++
>  arch/x86/kernel/entry_64.S      |   57 +++++++++++++++++++++++++++++++---------
>  include/linux/hardirq.h         |   16 +++++++----
>  5 files changed, 144 insertions(+), 17 deletions(-)
> 
> Index: linux/arch/x86/include/asm/irqflags.h
> ===================================================================
> --- linux.orig/arch/x86/include/asm/irqflags.h
> +++ linux/arch/x86/include/asm/irqflags.h
> @@ -51,6 +51,61 @@ static inline void native_halt(void)
>  
>  #endif
>  
> +#ifdef CONFIG_X86_64
> +/*
> + * Only returns from a trap or exception to a NMI context (intra-privilege
> + * level near return) to the same SS and CS segments. Should be used
> + * upon trap or exception return when nested over a NMI context so no iret is
> + * issued. It takes care of modifying the eflags, rsp and returning to the
> + * previous function.
> + *
> + * The stack, at that point, looks like :
> + *
> + * 0(rsp)  RIP
> + * 8(rsp)  CS
> + * 16(rsp) EFLAGS
> + * 24(rsp) RSP
> + * 32(rsp) SS
> + *
> + * Upon execution :
> + * Copy EIP to the top of the return stack
> + * Update top of return stack address
> + * Pop eflags into the eflags register
> + * Make the return stack current
> + * Near return (popping the return address from the return stack)
> + */
> +#define NATIVE_INTERRUPT_RETURN_NMI_SAFE	pushq %rax;		\
> +						movq %rsp, %rax;	\
> +						movq 24+8(%rax), %rsp;	\
> +						pushq 0+8(%rax);	\
> +						pushq 16+8(%rax);	\
> +						movq (%rax), %rax;	\
> +						popfq;			\
> +						ret
> +#else
> +/*
> + * Protected mode only, no V8086. Implies that protected mode must
> + * be entered before NMIs or MCEs are enabled. Only returns from a trap or
> + * exception to a NMI context (intra-privilege level far return). Should be used
> + * upon trap or exception return when nested over a NMI context so no iret is
> + * issued.
> + *
> + * The stack, at that point, looks like :
> + *
> + * 0(esp) EIP
> + * 4(esp) CS
> + * 8(esp) EFLAGS
> + *
> + * Upon execution :
> + * Copy the stack eflags to top of stack
> + * Pop eflags into the eflags register
> + * Far return: pop EIP and CS into their register, and additionally pop EFLAGS.
> + */
> +#define NATIVE_INTERRUPT_RETURN_NMI_SAFE	pushl 8(%esp);	\
> +						popfl;		\
> +						lret $4
> +#endif
> +
>  #ifdef CONFIG_PARAVIRT
>  #include <asm/paravirt.h>
>  #else
> @@ -109,6 +164,7 @@ static inline unsigned long __raw_local_
>  
>  #define ENABLE_INTERRUPTS(x)	sti
>  #define DISABLE_INTERRUPTS(x)	cli
> +#define INTERRUPT_RETURN_NMI_SAFE	NATIVE_INTERRUPT_RETURN_NMI_SAFE
>  
>  #ifdef CONFIG_X86_64
>  #define SWAPGS	swapgs
> Index: linux/arch/x86/kernel/dumpstack.c
> ===================================================================
> --- linux.orig/arch/x86/kernel/dumpstack.c
> +++ linux/arch/x86/kernel/dumpstack.c
> @@ -237,6 +237,8 @@ void __kprobes oops_end(unsigned long fl
>  
>  	if (!signr)
>  		return;
> +	if (in_nmi())
> +		panic("Fatal exception in non-maskable interrupt");
>  	if (in_interrupt())
>  		panic("Fatal exception in interrupt");
>  	if (panic_on_oops)
> Index: linux/arch/x86/kernel/entry_32.S
> ===================================================================
> --- linux.orig/arch/x86/kernel/entry_32.S
> +++ linux/arch/x86/kernel/entry_32.S
> @@ -80,6 +80,8 @@
>  
>  #define nr_syscalls ((syscall_table_size)/4)
>  
> +#define HARDNMI_MASK 0x40000000
> +

This is called "NMI_MASK" in 2.6.30. Did you test the x86_64 or x86_32
portion of this patch ? 64-bits seems ok, but not 32.

>  #ifdef CONFIG_PREEMPT
>  #define preempt_stop(clobbers)	DISABLE_INTERRUPTS(clobbers); TRACE_IRQS_OFF
>  #else
> @@ -344,8 +346,32 @@ END(ret_from_fork)
>  	# userspace resumption stub bypassing syscall exit tracing
>  	ALIGN
>  	RING0_PTREGS_FRAME
> +
>  ret_from_exception:
>  	preempt_stop(CLBR_ANY)
> +	GET_THREAD_INFO(%ebp)
> +	movl PT_EFLAGS(%esp), %eax	# mix EFLAGS and CS
> +	movb PT_CS(%esp), %al
> +	andl $(X86_EFLAGS_VM | SEGMENT_RPL_MASK), %eax
> +	cmpl $USER_RPL, %eax
> +	jae resume_userspace	# returning to v8086 or userspace
> +	testl $HARDNMI_MASK,TI_preempt_count(%ebp)

"NMI_MASK"

> +	jz resume_kernel		/* Not nested over NMI ? */
> +	testw $X86_EFLAGS_TF, PT_EFLAGS(%esp)

Hrm, I'm wondering if this test is not problematic for page faults.
Basically, this test is there to deal with "single-stepping" in the nmi
handler (it would not be "safe", but at least would not hang the
system). So if page faults are raising the X86_EFLAGS_TF EFLAG, we
definitely want to change this code. I am not sure about that, but it
would be worth checking.

It's all I can spot for now, but if you have popf/ret firing to return
to userspace instructions, there is clearly something fishy there.

Mathieu

> +	jnz resume_kernel		/*
> +					 * If single-stepping an NMI handler,
> +					 * use the normal iret path instead of
> +					 * the popf/lret because lret would be
> +					 * single-stepped. It should not
> +					 * happen : it will reactivate NMIs
> +					 * prematurely.
> +					 */
> +	TRACE_IRQS_IRET
> +	RESTORE_REGS
> +	addl $4, %esp			# skip orig_eax/error_code
> +	CFI_ADJUST_CFA_OFFSET -4
> +	INTERRUPT_RETURN_NMI_SAFE
> +
>  ret_from_intr:
>  	GET_THREAD_INFO(%ebp)
>  check_userspace:
> @@ -851,6 +877,10 @@ ENTRY(native_iret)
>  .previous
>  END(native_iret)
>  
> +ENTRY(native_nmi_return)
> +	NATIVE_INTERRUPT_RETURN_NMI_SAFE # Should we deal with popf exception ?
> +END(native_nmi_return)
> +
>  ENTRY(native_irq_enable_sysexit)
>  	sti
>  	sysexit
> Index: linux/arch/x86/kernel/entry_64.S
> ===================================================================
> --- linux.orig/arch/x86/kernel/entry_64.S
> +++ linux/arch/x86/kernel/entry_64.S
> @@ -53,6 +53,7 @@
>  #include <asm/paravirt.h>
>  #include <asm/ftrace.h>
>  #include <asm/percpu.h>
> +#include <linux/hardirq.h>
>  
>  /* Avoid __ASSEMBLER__'ifying <linux/audit.h> just for this.  */
>  #include <linux/elf-em.h>
> @@ -875,6 +876,9 @@ ENTRY(native_iret)
>  	.section __ex_table,"a"
>  	.quad native_iret, bad_iret
>  	.previous
> +
> +ENTRY(native_nmi_return)
> +	NATIVE_INTERRUPT_RETURN_NMI_SAFE
>  #endif
>  
>  	.section .fixup,"ax"
> @@ -929,6 +933,23 @@ retint_signal:
>  	GET_THREAD_INFO(%rcx)
>  	jmp retint_with_reschedule
>  
> +	/* Returning to kernel space from exception. */
> +	/* rcx:	 threadinfo. interrupts off. */
> +ENTRY(retexc_kernel)
> +	testl $NMI_MASK, TI_preempt_count(%rcx)
> +	jz retint_kernel		/* Not nested over NMI ? */
> +	testw $X86_EFLAGS_TF, EFLAGS-ARGOFFSET(%rsp)	/* trap flag? */
> +	jnz retint_kernel		/*
> +					 * If single-stepping an NMI handler,
> +					 * use the normal iret path instead of
> +					 * the popf/lret because lret would be
> +					 * single-stepped. It should not
> +					 * happen : it will reactivate NMIs
> +					 * prematurely.
> +					 */
> +	RESTORE_ARGS 0, 8, 0
> +	INTERRUPT_RETURN_NMI_SAFE
> +
>  #ifdef CONFIG_PREEMPT
>  	/* Returning to kernel space. Check if we need preemption */
>  	/* rcx:	 threadinfo. interrupts off. */
> @@ -1407,34 +1428,46 @@ ENTRY(paranoid_exit)
>  	INTR_FRAME
>  	DISABLE_INTERRUPTS(CLBR_NONE)
>  	TRACE_IRQS_OFF
> -	testl %ebx,%ebx				/* swapgs needed? */
> +	testl %ebx, %ebx			/* swapgs needed? */
>  	jnz paranoid_restore
> -	testl $3,CS(%rsp)
> +
> +	testl $3, CS(%rsp)
>  	jnz   paranoid_userspace
> +
>  paranoid_swapgs:
>  	TRACE_IRQS_IRETQ 0
>  	SWAPGS_UNSAFE_STACK
>  	RESTORE_ALL 8
>  	jmp irq_return
> -paranoid_restore:
> +paranoid_restore_no_nmi:
>  	TRACE_IRQS_IRETQ 0
>  	RESTORE_ALL 8
>  	jmp irq_return
> +paranoid_restore:
> +	GET_THREAD_INFO(%rcx)
> +	testl $NMI_MASK, TI_preempt_count(%rcx)
> +	jz paranoid_restore_no_nmi		/* Nested over NMI ? */
> +
> +	testw $X86_EFLAGS_TF, EFLAGS-0(%rsp)	/* trap flag? */
> +	jnz paranoid_restore_no_nmi
> +	RESTORE_ALL 8
> +	INTERRUPT_RETURN_NMI_SAFE
> +
>  paranoid_userspace:
>  	GET_THREAD_INFO(%rcx)
> -	movl TI_flags(%rcx),%ebx
> -	andl $_TIF_WORK_MASK,%ebx
> +	movl TI_flags(%rcx), %ebx
> +	andl $_TIF_WORK_MASK, %ebx
>  	jz paranoid_swapgs
> -	movq %rsp,%rdi			/* &pt_regs */
> +	movq %rsp, %rdi				/* &pt_regs */
>  	call sync_regs
> -	movq %rax,%rsp			/* switch stack for scheduling */
> -	testl $_TIF_NEED_RESCHED,%ebx
> +	movq %rax, %rsp				/* switch stack for scheduling */
> +	testl $_TIF_NEED_RESCHED, %ebx
>  	jnz paranoid_schedule
> -	movl %ebx,%edx			/* arg3: thread flags */
> +	movl %ebx, %edx				/* arg3: thread flags */
>  	TRACE_IRQS_ON
>  	ENABLE_INTERRUPTS(CLBR_NONE)
> -	xorl %esi,%esi 			/* arg2: oldset */
> -	movq %rsp,%rdi 			/* arg1: &pt_regs */
> +	xorl %esi, %esi				/* arg2: oldset */
> +	movq %rsp, %rdi				/* arg1: &pt_regs */
>  	call do_notify_resume
>  	DISABLE_INTERRUPTS(CLBR_NONE)
>  	TRACE_IRQS_OFF
> @@ -1513,7 +1546,7 @@ ENTRY(error_exit)
>  	TRACE_IRQS_OFF
>  	GET_THREAD_INFO(%rcx)
>  	testl %eax,%eax
> -	jne retint_kernel
> +	jne  retexc_kernel
>  	LOCKDEP_SYS_EXIT_IRQ
>  	movl TI_flags(%rcx),%edx
>  	movl $_TIF_WORK_MASK,%edi
> Index: linux/include/linux/hardirq.h
> ===================================================================
> --- linux.orig/include/linux/hardirq.h
> +++ linux/include/linux/hardirq.h
> @@ -1,12 +1,14 @@
>  #ifndef LINUX_HARDIRQ_H
>  #define LINUX_HARDIRQ_H
>  
> +#ifndef __ASSEMBLY__
>  #include <linux/preempt.h>
>  #include <linux/smp_lock.h>
>  #include <linux/lockdep.h>
>  #include <linux/ftrace_irq.h>
>  #include <asm/hardirq.h>
>  #include <asm/system.h>
> +#endif
>  
>  /*
>   * We put the hardirq and softirq counter into the preemption
> @@ -50,17 +52,17 @@
>  #define HARDIRQ_SHIFT	(SOFTIRQ_SHIFT + SOFTIRQ_BITS)
>  #define NMI_SHIFT	(HARDIRQ_SHIFT + HARDIRQ_BITS)
>  
> -#define __IRQ_MASK(x)	((1UL << (x))-1)
> +#define __IRQ_MASK(x)	((1 << (x))-1)
>  
>  #define PREEMPT_MASK	(__IRQ_MASK(PREEMPT_BITS) << PREEMPT_SHIFT)
>  #define SOFTIRQ_MASK	(__IRQ_MASK(SOFTIRQ_BITS) << SOFTIRQ_SHIFT)
>  #define HARDIRQ_MASK	(__IRQ_MASK(HARDIRQ_BITS) << HARDIRQ_SHIFT)
>  #define NMI_MASK	(__IRQ_MASK(NMI_BITS)     << NMI_SHIFT)
>  
> -#define PREEMPT_OFFSET	(1UL << PREEMPT_SHIFT)
> -#define SOFTIRQ_OFFSET	(1UL << SOFTIRQ_SHIFT)
> -#define HARDIRQ_OFFSET	(1UL << HARDIRQ_SHIFT)
> -#define NMI_OFFSET	(1UL << NMI_SHIFT)
> +#define PREEMPT_OFFSET	(1 << PREEMPT_SHIFT)
> +#define SOFTIRQ_OFFSET	(1 << SOFTIRQ_SHIFT)
> +#define HARDIRQ_OFFSET	(1 << HARDIRQ_SHIFT)
> +#define NMI_OFFSET	(1 << NMI_SHIFT)
>  
>  #if PREEMPT_ACTIVE < (1 << (NMI_SHIFT + NMI_BITS))
>  #error PREEMPT_ACTIVE is too low!
> @@ -116,6 +118,8 @@
>  # define IRQ_EXIT_OFFSET HARDIRQ_OFFSET
>  #endif
>  
> +#ifndef __ASSEMBLY__
> +
>  #if defined(CONFIG_SMP) || defined(CONFIG_GENERIC_HARDIRQS)
>  extern void synchronize_irq(unsigned int irq);
>  #else
> @@ -195,4 +199,6 @@ extern void irq_exit(void);
>  		ftrace_nmi_exit();				\
>  	} while (0)
>  
> +#endif /* !__ASSEMBLY__ */
> +
>  #endif /* LINUX_HARDIRQ_H */

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
