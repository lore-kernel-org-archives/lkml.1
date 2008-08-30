Return-Path: <linux-kernel-owner+w=401wt.eu-S1756176AbYH3TjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176AbYH3TjN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 15:39:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752887AbYH3Ti5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 15:38:57 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:33490 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552AbYH3Ti4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 15:38:56 -0400
Date: Sat, 30 Aug 2008 12:38:52 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, cl@linux-foundation.org, mingo@elte.hu,
       akpm@linux-foundation.org, manfred@colorfullife.com,
       dipankar@in.ibm.com, josht@linux.vnet.ibm.com, schamp@sgi.com,
       niv@us.ibm.com, dvhltc@us.ibm.com, ego@in.ibm.com, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH, RFC, tip/core/rcu] v3 scalable classic RCU
	implementation
Message-ID: <20080830193852.GJ7107@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080821234318.GA1754@linux.vnet.ibm.com> <20080825000738.GA24339@linux.vnet.ibm.com> <20080830004935.GA28548@linux.vnet.ibm.com> <1220088780.8426.1.camel@twins> <20080830141001.GD7107@linux.vnet.ibm.com> <1220110858.14894.46.camel@lappy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220110858.14894.46.camel@lappy.programming.kicks-ass.net>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 30, 2008 at 05:40:58PM +0200, Peter Zijlstra wrote:
> On Sat, 2008-08-30 at 07:10 -0700, Paul E. McKenney wrote:
> > On Sat, Aug 30, 2008 at 11:33:00AM +0200, Peter Zijlstra wrote:
> > > On Fri, 2008-08-29 at 17:49 -0700, Paul E. McKenney wrote:
> > > 
> > > > Some shortcomings:
> > > > 
> > > > o	Entering and leaving dynticks idle mode is a quiescent state,
> > > > 	but the current patch doesn't take advantage of this (noted
> > > > 	by Manfred).  It appears that it should be possible to make
> > > > 	nmi_enter() and nmi_exit() provide an in_nmi(), which would make
> > > > 	it possible for rcu_irq_enter() and rcu_irq_exit() to figure
> > > > 	out whether it is safe to tell RCU about the quiescent state --
> > > > 	and also greatly simplify the code.
> > > 
> > > Already done and available in the -tip tree, curtesy of Mathieu.
> > 
> > Very cool!!!  I see one of his patches at http://lkml.org/lkml/2008/4/17/342,
> > but how do I find out which branch of -tip this is on?  (I am learning
> > git, but it is a slow process...)
> > 
> > This would also simplify preemptable RCU's dyntick interface, removing
> > the need for proofs.
> 
> Not sure - my git-foo isn't good enough either :-(
> 
> All I can offer is that its available in tip/master (the collective
> merge of all of tip's branches) as commit:
> 0d84b78a606f1562532cd576ee8733caf5a4aed3, which I found using
> git-annotate include/linux/hardirq.h

That works -- thank you!!!

						Thanx, Paul

> How to find from which particular topic branch it came from, I too am
> clueless.
> 
> ---
> commit 0d84b78a606f1562532cd576ee8733caf5a4aed3
> Author: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> Date:   Mon May 12 21:21:07 2008 +0200
> 
>     x86 NMI-safe INT3 and Page Fault
>     
>     Implements an alternative iret with popf and return so trap and exception
>     handlers can return to the NMI handler without issuing iret. iret would cause
>     NMIs to be reenabled prematurely. x86_32 uses popf and far return. x86_64 has to
>     copy the return instruction pointer to the top of the previous stack, issue a
>     popf, loads the previous esp and issue a near return (ret).
>     
>     It allows placing immediate values (and therefore optimized trace_marks) in NMI
>     code since returning from a breakpoint would be valid. Accessing vmalloc'd
>     memory, which allows executing module code or accessing vmapped or vmalloc'd
>     areas from NMI context, would also be valid. This is very useful to tracers like
>     LTTng.
>     
>     This patch makes all faults, traps and exception safe to be called from NMI
>     context *except* single-stepping, which requires iret to restore the TF (trap
>     flag) and jump to the return address in a single instruction. Sorry, no kprobes
>     support in NMI handlers because of this limitation.  We cannot single-step an
>     NMI handler, because iret must set the TF flag and return back to the
>     instruction to single-step in a single instruction. This cannot be emulated with
>     popf/lret, because lret would be single-stepped. It does not apply to immediate
>     values because they do not use single-stepping. This code detects if the TF
>     flag is set and uses the iret path for single-stepping, even if it reactivates
>     NMIs prematurely.
>     
>     Test to detect if nested under a NMI handler is only done upon the return from
>     trap/exception to kernel, which is not frequent. Other return paths (return from
>     trap/exception to userspace, return from interrupt) keep the exact same behavior
>     (no slowdown).
>     
>     Depends on :
>     change-alpha-active-count-bit.patch
>     change-avr32-active-count-bit.patch
>     
>     TODO : test with lguest, xen, kvm.
>     
>     ** This patch depends on the "Stringify support commas" patchset **
>     ** Also depends on fix-x86_64-page-fault-scheduler-race patch **
>     
>     tested on x86_32 (tests implemented in a separate patch) :
>     - instrumented the return path to export the EIP, CS and EFLAGS values when
>       taken so we know the return path code has been executed.
>     - trace_mark, using immediate values, with 10ms delay with the breakpoint
>       activated. Runs well through the return path.
>     - tested vmalloc faults in NMI handler by placing a non-optimized marker in the
>       NMI handler (so no breakpoint is executed) and connecting a probe which
>       touches every pages of a 20MB vmalloc'd buffer. It executes trough the return
>       path without problem.
>     - Tested with and without preemption
>     
>     tested on x86_64
>     - instrumented the return path to export the EIP, CS and EFLAGS values when
>       taken so we know the return path code has been executed.
>     - trace_mark, using immediate values, with 10ms delay with the breakpoint
>       activated. Runs well through the return path.
>     
>     To test on x86_64 :
>     - Test without preemption
>     - Test vmalloc faults
>     - Test on Intel 64 bits CPUs. (AMD64 was fine)
>     
>     Changelog since v1 :
>     - x86_64 fixes.
>     Changelog since v2 :
>     - fix paravirt build
>     Changelog since v3 :
>     - Include modifications suggested by Jeremy
>     Changelog since v4 :
>     - including hardirq.h in entry_32/64.S is a bad idea (non ifndef'd C code),
>       define HARDNMI_MASK in the .S files directly.
>     Changelog since v5 :
>     - Add HARDNMI_MASK to irq_count() and make die() more verbose for NMIs.
>     Changelog since v7 :
>     - Implement paravirtualized nmi_return.
>     Changelog since v8 :
>     - refreshed the patch for asm-offsets. Those were left out of v8.
>     - now depends on "Stringify support commas" patch.
>     Changelog since v9 :
>     - Only test the nmi nested preempt count flag upon return from exceptions, not
>       on return from interrupts. Only the kernel return path has this test.
>     - Add Xen, VMI, lguest support. Use their iret pavavirt ops in lieu of
>       nmi_return.
>     
>     -- Ported to sched-devel.git
>     
>     Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
>     CC: akpm@osdl.org
>     CC: mingo@elte.hu
>     CC: "H. Peter Anvin" <hpa@zytor.com>
>     CC: Jeremy Fitzhardinge <jeremy@goop.org>
>     CC: Steven Rostedt <rostedt@goodmis.org>
>     CC: "Frank Ch. Eigler" <fche@redhat.com>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
>     Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 
> diff --git a/arch/x86/kernel/asm-offsets_32.c b/arch/x86/kernel/asm-offsets_32.c
> index 9258808..73474e0 100644
> --- a/arch/x86/kernel/asm-offsets_32.c
> +++ b/arch/x86/kernel/asm-offsets_32.c
> @@ -111,6 +111,7 @@ void foo(void)
>  	OFFSET(PV_IRQ_irq_disable, pv_irq_ops, irq_disable);
>  	OFFSET(PV_IRQ_irq_enable, pv_irq_ops, irq_enable);
>  	OFFSET(PV_CPU_iret, pv_cpu_ops, iret);
> +	OFFSET(PV_CPU_nmi_return, pv_cpu_ops, nmi_return);
>  	OFFSET(PV_CPU_irq_enable_syscall_ret, pv_cpu_ops, irq_enable_syscall_ret);
>  	OFFSET(PV_CPU_read_cr0, pv_cpu_ops, read_cr0);
>  #endif
> diff --git a/arch/x86/kernel/asm-offsets_64.c b/arch/x86/kernel/asm-offsets_64.c
> index f126c05..a5bbec3 100644
> --- a/arch/x86/kernel/asm-offsets_64.c
> +++ b/arch/x86/kernel/asm-offsets_64.c
> @@ -62,6 +62,7 @@ int main(void)
>  	OFFSET(PV_IRQ_irq_disable, pv_irq_ops, irq_disable);
>  	OFFSET(PV_IRQ_irq_enable, pv_irq_ops, irq_enable);
>  	OFFSET(PV_CPU_iret, pv_cpu_ops, iret);
> +	OFFSET(PV_CPU_nmi_return, pv_cpu_ops, nmi_return);
>  	OFFSET(PV_CPU_irq_enable_syscall_ret, pv_cpu_ops, irq_enable_syscall_ret);
>  	OFFSET(PV_CPU_swapgs, pv_cpu_ops, swapgs);
>  	OFFSET(PV_MMU_read_cr2, pv_mmu_ops, read_cr2);
> diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
> index e6517ce..2d88211 100644
> --- a/arch/x86/kernel/entry_32.S
> +++ b/arch/x86/kernel/entry_32.S
> @@ -68,6 +68,8 @@
> 
>  #define nr_syscalls ((syscall_table_size)/4)
> 
> +#define HARDNMI_MASK 0x40000000
> +
>  #ifdef CONFIG_PREEMPT
>  #define preempt_stop(clobbers)	DISABLE_INTERRUPTS(clobbers); TRACE_IRQS_OFF
>  #else
> @@ -232,8 +234,32 @@ END(ret_from_fork)
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
> +	jz resume_kernel		/* Not nested over NMI ? */
> +	testw $X86_EFLAGS_TF, PT_EFLAGS(%esp)
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
> @@ -873,6 +899,10 @@ ENTRY(native_iret)
>  .previous
>  END(native_iret)
> 
> +ENTRY(native_nmi_return)
> +	NATIVE_INTERRUPT_RETURN_NMI_SAFE # Should we deal with popf exception ?
> +END(native_nmi_return)
> +
>  ENTRY(native_irq_enable_syscall_ret)
>  	sti
>  	sysexit
> diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> index fe25e5f..5f8edc7 100644
> --- a/arch/x86/kernel/entry_64.S
> +++ b/arch/x86/kernel/entry_64.S
> @@ -156,6 +156,8 @@ END(mcount)
>  #endif /* CONFIG_DYNAMIC_FTRACE */
>  #endif /* CONFIG_FTRACE */
> 
> +#define HARDNMI_MASK 0x40000000
> +
>  #ifndef CONFIG_PREEMPT
>  #define retint_kernel retint_restore_args
>  #endif	
> @@ -698,6 +700,9 @@ ENTRY(native_iret)
>  	.section __ex_table,"a"
>  	.quad native_iret, bad_iret
>  	.previous
> +
> +ENTRY(native_nmi_return)
> +	NATIVE_INTERRUPT_RETURN_NMI_SAFE
>  #endif
> 
>  	.section .fixup,"ax"
> @@ -753,6 +758,23 @@ retint_signal:
>  	GET_THREAD_INFO(%rcx)
>  	jmp retint_check
> 
> +	/* Returning to kernel space from exception. */
> +	/* rcx:	 threadinfo. interrupts off. */
> +ENTRY(retexc_kernel)
> +	testl $HARDNMI_MASK,threadinfo_preempt_count(%rcx)
> +	jz retint_kernel		/* Not nested over NMI ? */
> +	testw $X86_EFLAGS_TF,EFLAGS-ARGOFFSET(%rsp)	/* trap flag? */
> +	jnz retint_kernel		/*
> +					 * If single-stepping an NMI handler,
> +					 * use the normal iret path instead of
> +					 * the popf/lret because lret would be
> +					 * single-stepped. It should not
> +					 * happen : it will reactivate NMIs
> +					 * prematurely.
> +					 */
> +	RESTORE_ARGS 0,8,0
> +	INTERRUPT_RETURN_NMI_SAFE
> +
>  #ifdef CONFIG_PREEMPT
>  	/* Returning to kernel space. Check if we need preemption */
>  	/* rcx:	 threadinfo. interrupts off. */
> @@ -911,9 +933,17 @@ paranoid_swapgs\trace:
>  	TRACE_IRQS_IRETQ 0
>  	.endif
>  	SWAPGS_UNSAFE_STACK
> -paranoid_restore\trace:
> +paranoid_restore_no_nmi\trace:
>  	RESTORE_ALL 8
>  	jmp irq_return
> +paranoid_restore\trace:
> +	GET_THREAD_INFO(%rcx)
> +	testl $HARDNMI_MASK,threadinfo_preempt_count(%rcx)
> +	jz paranoid_restore_no_nmi\trace	/* Nested over NMI ? */
> +	testw $X86_EFLAGS_TF,EFLAGS-0(%rsp)	/* trap flag? */
> +	jnz paranoid_restore_no_nmi\trace
> +	RESTORE_ALL 8
> +	INTERRUPT_RETURN_NMI_SAFE
>  paranoid_userspace\trace:
>  	GET_THREAD_INFO(%rcx)
>  	movl threadinfo_flags(%rcx),%ebx
> @@ -1012,7 +1042,7 @@ error_exit:
>  	TRACE_IRQS_OFF
>  	GET_THREAD_INFO(%rcx)	
>  	testl %eax,%eax
> -	jne  retint_kernel
> +	jne  retexc_kernel
>  	LOCKDEP_SYS_EXIT_IRQ
>  	movl  threadinfo_flags(%rcx),%edx
>  	movl  $_TIF_WORK_MASK,%edi
> diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
> index 74f0c5e..bb174a8 100644
> --- a/arch/x86/kernel/paravirt.c
> +++ b/arch/x86/kernel/paravirt.c
> @@ -139,6 +139,7 @@ unsigned paravirt_patch_default(u8 type, u16 clobbers, void *insnbuf,
>  		/* If the operation is a nop, then nop the callsite */
>  		ret = paravirt_patch_nop();
>  	else if (type == PARAVIRT_PATCH(pv_cpu_ops.iret) ||
> +		 type == PARAVIRT_PATCH(pv_cpu_ops.nmi_return) ||
>  		 type == PARAVIRT_PATCH(pv_cpu_ops.irq_enable_syscall_ret))
>  		/* If operation requires a jmp, then jmp */
>  		ret = paravirt_patch_jmp(insnbuf, opfunc, addr, len);
> @@ -190,6 +191,7 @@ static void native_flush_tlb_single(unsigned long addr)
> 
>  /* These are in entry.S */
>  extern void native_iret(void);
> +extern void native_nmi_return(void);
>  extern void native_irq_enable_syscall_ret(void);
> 
>  static int __init print_banner(void)
> @@ -328,6 +330,7 @@ struct pv_cpu_ops pv_cpu_ops = {
> 
>  	.irq_enable_syscall_ret = native_irq_enable_syscall_ret,
>  	.iret = native_iret,
> +	.nmi_return = native_nmi_return,
>  	.swapgs = native_swapgs,
> 
>  	.set_iopl_mask = native_set_iopl_mask,
> diff --git a/arch/x86/kernel/paravirt_patch_32.c b/arch/x86/kernel/paravirt_patch_32.c
> index 82fc5fc..8ed31c7 100644
> --- a/arch/x86/kernel/paravirt_patch_32.c
> +++ b/arch/x86/kernel/paravirt_patch_32.c
> @@ -1,10 +1,13 @@
> -#include <asm/paravirt.h>
> +#include <linux/stringify.h>
> +#include <linux/irqflags.h>
> 
>  DEF_NATIVE(pv_irq_ops, irq_disable, "cli");
>  DEF_NATIVE(pv_irq_ops, irq_enable, "sti");
>  DEF_NATIVE(pv_irq_ops, restore_fl, "push %eax; popf");
>  DEF_NATIVE(pv_irq_ops, save_fl, "pushf; pop %eax");
>  DEF_NATIVE(pv_cpu_ops, iret, "iret");
> +DEF_NATIVE(pv_cpu_ops, nmi_return,
> +	__stringify(NATIVE_INTERRUPT_RETURN_NMI_SAFE));
>  DEF_NATIVE(pv_cpu_ops, irq_enable_syscall_ret, "sti; sysexit");
>  DEF_NATIVE(pv_mmu_ops, read_cr2, "mov %cr2, %eax");
>  DEF_NATIVE(pv_mmu_ops, write_cr3, "mov %eax, %cr3");
> @@ -29,6 +32,7 @@ unsigned native_patch(u8 type, u16 clobbers, void *ibuf,
>  		PATCH_SITE(pv_irq_ops, restore_fl);
>  		PATCH_SITE(pv_irq_ops, save_fl);
>  		PATCH_SITE(pv_cpu_ops, iret);
> +		PATCH_SITE(pv_cpu_ops, nmi_return);
>  		PATCH_SITE(pv_cpu_ops, irq_enable_syscall_ret);
>  		PATCH_SITE(pv_mmu_ops, read_cr2);
>  		PATCH_SITE(pv_mmu_ops, read_cr3);
> diff --git a/arch/x86/kernel/paravirt_patch_64.c b/arch/x86/kernel/paravirt_patch_64.c
> index 7d904e1..56eccea 100644
> --- a/arch/x86/kernel/paravirt_patch_64.c
> +++ b/arch/x86/kernel/paravirt_patch_64.c
> @@ -1,12 +1,15 @@
> +#include <linux/irqflags.h>
> +#include <linux/stringify.h>
>  #include <asm/paravirt.h>
>  #include <asm/asm-offsets.h>
> -#include <linux/stringify.h>
> 
>  DEF_NATIVE(pv_irq_ops, irq_disable, "cli");
>  DEF_NATIVE(pv_irq_ops, irq_enable, "sti");
>  DEF_NATIVE(pv_irq_ops, restore_fl, "pushq %rdi; popfq");
>  DEF_NATIVE(pv_irq_ops, save_fl, "pushfq; popq %rax");
>  DEF_NATIVE(pv_cpu_ops, iret, "iretq");
> +DEF_NATIVE(pv_cpu_ops, nmi_return,
> +	__stringify(NATIVE_INTERRUPT_RETURN_NMI_SAFE));
>  DEF_NATIVE(pv_mmu_ops, read_cr2, "movq %cr2, %rax");
>  DEF_NATIVE(pv_mmu_ops, read_cr3, "movq %cr3, %rax");
>  DEF_NATIVE(pv_mmu_ops, write_cr3, "movq %rdi, %cr3");
> @@ -35,6 +38,7 @@ unsigned native_patch(u8 type, u16 clobbers, void *ibuf,
>  		PATCH_SITE(pv_irq_ops, irq_enable);
>  		PATCH_SITE(pv_irq_ops, irq_disable);
>  		PATCH_SITE(pv_cpu_ops, iret);
> +		PATCH_SITE(pv_cpu_ops, nmi_return);
>  		PATCH_SITE(pv_cpu_ops, irq_enable_syscall_ret);
>  		PATCH_SITE(pv_cpu_ops, swapgs);
>  		PATCH_SITE(pv_mmu_ops, read_cr2);
> diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
> index bde6f63..f3a59cd 100644
> --- a/arch/x86/kernel/traps_32.c
> +++ b/arch/x86/kernel/traps_32.c
> @@ -475,6 +475,9 @@ void die(const char *str, struct pt_regs *regs, long err)
>  	if (kexec_should_crash(current))
>  		crash_kexec(regs);
> 
> +	if (in_nmi())
> +		panic("Fatal exception in non-maskable interrupt");
> +
>  	if (in_interrupt())
>  		panic("Fatal exception in interrupt");
> 
> diff --git a/arch/x86/kernel/traps_64.c b/arch/x86/kernel/traps_64.c
> index adff76e..3dacb75 100644
> --- a/arch/x86/kernel/traps_64.c
> +++ b/arch/x86/kernel/traps_64.c
> @@ -555,6 +555,10 @@ void __kprobes oops_end(unsigned long flags, struct pt_regs *regs, int signr)
>  		oops_exit();
>  		return;
>  	}
> +	if (in_nmi())
> +		panic("Fatal exception in non-maskable interrupt");
> +	if (in_interrupt())
> +		panic("Fatal exception in interrupt");
>  	if (panic_on_oops)
>  		panic("Fatal exception");
>  	oops_exit();
> diff --git a/arch/x86/kernel/vmi_32.c b/arch/x86/kernel/vmi_32.c
> index 956f389..01d687d 100644
> --- a/arch/x86/kernel/vmi_32.c
> +++ b/arch/x86/kernel/vmi_32.c
> @@ -151,6 +151,8 @@ static unsigned vmi_patch(u8 type, u16 clobbers, void *insns,
>  					      insns, ip);
>  		case PARAVIRT_PATCH(pv_cpu_ops.iret):
>  			return patch_internal(VMI_CALL_IRET, len, insns, ip);
> +		case PARAVIRT_PATCH(pv_cpu_ops.nmi_return):
> +			return patch_internal(VMI_CALL_IRET, len, insns, ip);
>  		case PARAVIRT_PATCH(pv_cpu_ops.irq_enable_syscall_ret):
>  			return patch_internal(VMI_CALL_SYSEXIT, len, insns, ip);
>  		default:
> diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
> index af65b2d..f5cbb74 100644
> --- a/arch/x86/lguest/boot.c
> +++ b/arch/x86/lguest/boot.c
> @@ -958,6 +958,7 @@ __init void lguest_init(void)
>  	pv_cpu_ops.cpuid = lguest_cpuid;
>  	pv_cpu_ops.load_idt = lguest_load_idt;
>  	pv_cpu_ops.iret = lguest_iret;
> +	pv_cpu_ops.nmi_return = lguest_iret;
>  	pv_cpu_ops.load_sp0 = lguest_load_sp0;
>  	pv_cpu_ops.load_tr_desc = lguest_load_tr_desc;
>  	pv_cpu_ops.set_ldt = lguest_set_ldt;
> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> index c8a56e4..33272ce 100644
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -1008,6 +1008,7 @@ static const struct pv_cpu_ops xen_cpu_ops __initdata = {
>  	.read_pmc = native_read_pmc,
> 
>  	.iret = xen_iret,
> +	.nmi_return = xen_iret,
>  	.irq_enable_syscall_ret = xen_sysexit,
> 
>  	.load_tr_desc = paravirt_nop,
> diff --git a/include/asm-x86/irqflags.h b/include/asm-x86/irqflags.h
> index 24d71b1..c3009fd 100644
> --- a/include/asm-x86/irqflags.h
> +++ b/include/asm-x86/irqflags.h
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
> @@ -109,6 +164,7 @@ static inline unsigned long __raw_local_irq_save(void)
> 
>  #define ENABLE_INTERRUPTS(x)	sti
>  #define DISABLE_INTERRUPTS(x)	cli
> +#define INTERRUPT_RETURN_NMI_SAFE	NATIVE_INTERRUPT_RETURN_NMI_SAFE
> 
>  #ifdef CONFIG_X86_64
>  #define INTERRUPT_RETURN	iretq
> diff --git a/include/asm-x86/paravirt.h b/include/asm-x86/paravirt.h
> index 0f13b94..d5087e0 100644
> --- a/include/asm-x86/paravirt.h
> +++ b/include/asm-x86/paravirt.h
> @@ -141,9 +141,10 @@ struct pv_cpu_ops {
>  	u64 (*read_pmc)(int counter);
>  	unsigned long long (*read_tscp)(unsigned int *aux);
> 
> -	/* These two are jmp to, not actually called. */
> +	/* These three are jmp to, not actually called. */
>  	void (*irq_enable_syscall_ret)(void);
>  	void (*iret)(void);
> +	void (*nmi_return)(void);
> 
>  	void (*swapgs)(void);
> 
> @@ -1385,6 +1386,10 @@ static inline unsigned long __raw_local_irq_save(void)
>  	PARA_SITE(PARA_PATCH(pv_cpu_ops, PV_CPU_iret), CLBR_NONE,	\
>  		  jmp *%cs:pv_cpu_ops+PV_CPU_iret)
> 
> +#define INTERRUPT_RETURN_NMI_SAFE					\
> +	PARA_SITE(PARA_PATCH(pv_cpu_ops, PV_CPU_nmi_return), CLBR_NONE,	\
> +		  jmp *%cs:pv_cpu_ops+PV_CPU_nmi_return)
> +
>  #define DISABLE_INTERRUPTS(clobbers)					\
>  	PARA_SITE(PARA_PATCH(pv_irq_ops, PV_IRQ_irq_disable), clobbers, \
>  		  PV_SAVE_REGS;			\
> diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
> index 181006c..b39f49d 100644
> --- a/include/linux/hardirq.h
> +++ b/include/linux/hardirq.h
> @@ -22,10 +22,13 @@
>   * PREEMPT_MASK: 0x000000ff
>   * SOFTIRQ_MASK: 0x0000ff00
>   * HARDIRQ_MASK: 0x0fff0000
> + * HARDNMI_MASK: 0x40000000
>   */
>  #define PREEMPT_BITS	8
>  #define SOFTIRQ_BITS	8
> 
> +#define HARDNMI_BITS	1
> +
>  #ifndef HARDIRQ_BITS
>  #define HARDIRQ_BITS	12
> 
> @@ -45,16 +48,19 @@
>  #define PREEMPT_SHIFT	0
>  #define SOFTIRQ_SHIFT	(PREEMPT_SHIFT + PREEMPT_BITS)
>  #define HARDIRQ_SHIFT	(SOFTIRQ_SHIFT + SOFTIRQ_BITS)
> +#define HARDNMI_SHIFT	(30)
> 
>  #define __IRQ_MASK(x)	((1UL << (x))-1)
> 
>  #define PREEMPT_MASK	(__IRQ_MASK(PREEMPT_BITS) << PREEMPT_SHIFT)
>  #define SOFTIRQ_MASK	(__IRQ_MASK(SOFTIRQ_BITS) << SOFTIRQ_SHIFT)
>  #define HARDIRQ_MASK	(__IRQ_MASK(HARDIRQ_BITS) << HARDIRQ_SHIFT)
> +#define HARDNMI_MASK	(__IRQ_MASK(HARDNMI_BITS) << HARDNMI_SHIFT)
> 
>  #define PREEMPT_OFFSET	(1UL << PREEMPT_SHIFT)
>  #define SOFTIRQ_OFFSET	(1UL << SOFTIRQ_SHIFT)
>  #define HARDIRQ_OFFSET	(1UL << HARDIRQ_SHIFT)
> +#define HARDNMI_OFFSET	(1UL << HARDNMI_SHIFT)
> 
>  #if PREEMPT_ACTIVE < (1 << (HARDIRQ_SHIFT + HARDIRQ_BITS))
>  #error PREEMPT_ACTIVE is too low!
> @@ -62,7 +68,9 @@
> 
>  #define hardirq_count()	(preempt_count() & HARDIRQ_MASK)
>  #define softirq_count()	(preempt_count() & SOFTIRQ_MASK)
> -#define irq_count()	(preempt_count() & (HARDIRQ_MASK | SOFTIRQ_MASK))
> +#define irq_count() \
> +	(preempt_count() & (HARDNMI_MASK | HARDIRQ_MASK | SOFTIRQ_MASK))
> +#define hardnmi_count()	(preempt_count() & HARDNMI_MASK)
> 
>  /*
>   * Are we doing bottom half or hardware interrupt processing?
> @@ -71,6 +79,7 @@
>  #define in_irq()		(hardirq_count())
>  #define in_softirq()		(softirq_count())
>  #define in_interrupt()		(irq_count())
> +#define in_nmi()		(hardnmi_count())
> 
>  #if defined(CONFIG_PREEMPT)
>  # define PREEMPT_INATOMIC_BASE kernel_locked()
> @@ -161,7 +170,19 @@ extern void irq_enter(void);
>   */
>  extern void irq_exit(void);
> 
> -#define nmi_enter()		do { lockdep_off(); __irq_enter(); } while (0)
> -#define nmi_exit()		do { __irq_exit(); lockdep_on(); } while (0)
> +#define nmi_enter()					\
> +	do {						\
> +		lockdep_off();				\
> +		BUG_ON(hardnmi_count());		\
> +		add_preempt_count(HARDNMI_OFFSET);	\
> +		__irq_enter();				\
> +	} while (0)
> +
> +#define nmi_exit()					\
> +	do {						\
> +		__irq_exit();				\
> +		sub_preempt_count(HARDNMI_OFFSET);	\
> +		lockdep_on();				\
> +	} while (0)
> 
>  #endif /* LINUX_HARDIRQ_H */
> 
> 
