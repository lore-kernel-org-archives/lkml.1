Return-Path: <linux-kernel-owner+w=401wt.eu-S932205AbZFOSw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932205AbZFOSw3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 14:52:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765244AbZFOSwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 14:52:12 -0400
Received: from tomts16.bellnexxia.net ([209.226.175.4]:65025 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765469AbZFOSwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 14:52:08 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AokFAJEvNkpMQWQl/2dsb2JhbACBT9V1gkKBSwU
Date: Mon, 15 Jun 2009 14:46:33 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
       hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       penberg@cs.helsinki.fi, vegard.nossum@gmail.com, efault@gmx.de,
       jeremy@goop.org, npiggin@suse.de, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: x86: Fix call-chain
	support to use NMI-safe methods
Message-ID: <20090615184633.GC6520@Krystal>
References: <tip-74193ef0ecab92535c8517f082f1f50504526c9b@git.kernel.org> <alpine.LFD.2.01.0906151007560.3305@localhost.localdomain> <20090615171845.GA7664@elte.hu> <alpine.LFD.2.01.0906151029160.3305@localhost.localdomain> <20090615180527.GB4201@Krystal> <alpine.LFD.2.01.0906151125320.6276@localhost.localdomain> <20090615183649.GA16999@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090615183649.GA16999@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:43:55 up 107 days, 15:10,  3 users,  load average: 1.22, 1.22,
	1.02
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > On Mon, 15 Jun 2009, Mathieu Desnoyers wrote:
> > > 
> > > Hrm, would it be possible to save the c2 register upon nmi 
> > > handler entry and restore it before iret instead ?
> > 
> > Yes, that would work as well, and be less subtle.
> > 
> > It still does have the same worries about CPU's not being all that 
> > happy about writing to %cr2 (we do it when restoring CPU state at 
> > resume time, but nobody has ever _cared_ before, so I don't know 
> > if it matters).
> 
> I think we can dodge the whole issue by asking whether the old 
> 1-year-old patch from Mathieu (repeated below - partially ported and 
> barely tested / not signed off) is an actual speedup in the normal 
> exception codepaths.
> 
> The gist of it is the replacement of iret with this open-coded 
> sequence:
> 
> +#define NATIVE_INTERRUPT_RETURN_NMI_SAFE	pushq %rax;		\
> +						movq %rsp, %rax;	\
> +						movq 24+8(%rax), %rsp;	\
> +						pushq 0+8(%rax);	\
> +						pushq 16+8(%rax);	\
> +						movq (%rax), %rax;	\
> +						popfq;			\
> +						ret
> 
> Whether popfq+ret is faster than iret is the question i think. 
> (beyond the question of 'how about all the weird stack exceptions 
> that are possible above')
> 
> If it's faster, this becomes a legit (albeit complex) 
> micro-optimization in a _very_ hot codepath.
> 
> If it's slower then it's a non-starter and we do the GUP solution.
> 
> Lets hope it's slower ;-)
> 

As I pointed out in my earlier email, and as I add :

- My patch only touched exceptions nested in NMI handlers
- You should not use the popf+ret to return to userspace. This could
  lead to interesting results like userspace running in ring 0. (read :
  bad things would happen).

So if you want to try making it the default to return from interrupts or
exceptions caught in kernel-mode, that might be interesting to see if it
speeds up the system compared to iret.

Mathieu

> 	Ingo
> 
> ----------->
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
> ---
>  arch/x86/include/asm/irqflags.h |   56 +++++++++++++++++++++++++++++++++++++++
>  arch/x86/kernel/dumpstack.c     |    2 +
>  arch/x86/kernel/entry_64.S      |   57 +++++++++++++++++++++++++++++++---------
>  include/linux/hardirq.h         |   16 +++++++----
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
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
