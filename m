Return-Path: <linux-kernel-owner+w=401wt.eu-S933728AbZFOSSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933728AbZFOSSw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 14:18:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759540AbZFOSSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 14:18:44 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53857 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754156AbZFOSSn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 14:18:43 -0400
Date: Mon, 15 Jun 2009 20:18:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       penberg@cs.helsinki.fi, torvalds@linux-foundation.org,
       vegard.nossum@gmail.com, efault@gmx.de, jeremy@goop.org,
       npiggin@suse.de, tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: x86: Fix call-chain
	support to use NMI-safe methods
Message-ID: <20090615181807.GB11248@elte.hu>
References: <tip-74193ef0ecab92535c8517f082f1f50504526c9b@git.kernel.org> <20090615161459.GA1280@Krystal> <20090615170556.GA25760@elte.hu> <20090615174223.GA4201@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090615174223.GA4201@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> * Ingo Molnar (mingo@elte.hu) wrote:
> > 
> > * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> > 
> > > * tip-bot for Peter Zijlstra (a.p.zijlstra@chello.nl) wrote:
> > > > Commit-ID:  74193ef0ecab92535c8517f082f1f50504526c9b
> > > > Gitweb:     http://git.kernel.org/tip/74193ef0ecab92535c8517f082f1f50504526c9b
> > > > Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > > AuthorDate: Mon, 15 Jun 2009 13:07:24 +0200
> > > > Committer:  Ingo Molnar <mingo@elte.hu>
> > > > CommitDate: Mon, 15 Jun 2009 15:57:53 +0200
> > > > 
> > > > perf_counter: x86: Fix call-chain support to use NMI-safe methods
> > > > 
> > > > __copy_from_user_inatomic() isn't NMI safe in that it can trigger
> > > > the page fault handler which is another trap and its return path
> > > > invokes IRET which will also close the NMI context.
> > > > 
> > > > Therefore use a GUP based approach to copy the stack frames over.
> > > > 
> > > > We tried an alternative solution as well: we used a forward ported
> > > > version of Mathieu Desnoyers's "NMI safe INT3 and Page Fault" patch
> > > > that modifies the exception return path to use an open-coded IRET with
> > > > explicit stack unrolling and TF checking.
> > > > 
> > > > This didnt work as it interacted with faulting user-space instructions,
> > > > causing them not to restart properly, which corrupts user-space
> > > > registers.
> > > > 
> > > > Solving that would probably involve disassembling those instructions
> > > > and backtracing the RIP. But even without that, the code was deemed
> > > > rather complex to the already non-trivial x86 entry assembly code,
> > > > so instead we went for this GUP based method that does a
> > > > software-walk of the pagetables.
> > > > 
> > > 
> > > Hrm, I'm probably missing something. Normally, you should test for 
> > > "in_nmi()" upon return from exception, and only in these cases go 
> > > for the open-coded IRET with stack unrolling and ret. I really 
> > > don't see how you end up messing up the page fault return to 
> > > userspace path, as it's impossible to have in_nmi() set.
> > 
> > here's the (heavily modified) version of your patch that i used.
> > 
> > 	Ingo
> > 
> > -------------------->
> > Subject: x86 NMI-safe INT3 and Page Fault
> > From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> > Date: Mon, 12 May 2008 21:21:07 +0200
> > 
> > Implements an alternative iret with popf and return so trap and exception
> > handlers can return to the NMI handler without issuing iret. iret would cause
> > NMIs to be reenabled prematurely. x86_32 uses popf and far return. x86_64 has to
> > copy the return instruction pointer to the top of the previous stack, issue a
> > popf, loads the previous esp and issue a near return (ret).
> > 
> > It allows placing immediate values (and therefore optimized trace_marks) in NMI
> > code since returning from a breakpoint would be valid. Accessing vmalloc'd
> > memory, which allows executing module code or accessing vmapped or vmalloc'd
> > areas from NMI context, would also be valid. This is very useful to tracers like
> > LTTng.
> > 
> > This patch makes all faults, traps and exception safe to be called from NMI
> > context *except* single-stepping, which requires iret to restore the TF (trap
> > flag) and jump to the return address in a single instruction. Sorry, no kprobes
> > support in NMI handlers because of this limitation.  We cannot single-step an
> > NMI handler, because iret must set the TF flag and return back to the
> > instruction to single-step in a single instruction. This cannot be emulated with
> > popf/lret, because lret would be single-stepped. It does not apply to immediate
> > values because they do not use single-stepping. This code detects if the TF
> > flag is set and uses the iret path for single-stepping, even if it reactivates
> > NMIs prematurely.
> > 
> > Test to detect if nested under a NMI handler is only done upon the return from
> > trap/exception to kernel, which is not frequent. Other return paths (return from
> > trap/exception to userspace, return from interrupt) keep the exact same behavior
> > (no slowdown).
> > 
> > Depends on :
> > change-alpha-active-count-bit.patch
> > change-avr32-active-count-bit.patch
> > 
> > TODO : test with lguest, xen, kvm.
> > 
> > ** This patch depends on the "Stringify support commas" patchset **
> > ** Also depends on fix-x86_64-page-fault-scheduler-race patch **
> > 
> > tested on x86_32 (tests implemented in a separate patch) :
> > - instrumented the return path to export the EIP, CS and EFLAGS values when
> >   taken so we know the return path code has been executed.
> > - trace_mark, using immediate values, with 10ms delay with the breakpoint
> >   activated. Runs well through the return path.
> > - tested vmalloc faults in NMI handler by placing a non-optimized marker in the
> >   NMI handler (so no breakpoint is executed) and connecting a probe which
> >   touches every pages of a 20MB vmalloc'd buffer. It executes trough the return
> >   path without problem.
> > - Tested with and without preemption
> > 
> > tested on x86_64
> > - instrumented the return path to export the EIP, CS and EFLAGS values when
> >   taken so we know the return path code has been executed.
> > - trace_mark, using immediate values, with 10ms delay with the breakpoint
> >   activated. Runs well through the return path.
> > 
> > To test on x86_64 :
> > - Test without preemption
> > - Test vmalloc faults
> > - Test on Intel 64 bits CPUs. (AMD64 was fine)
> > 
> > Changelog since v1 :
> > - x86_64 fixes.
> > Changelog since v2 :
> > - fix paravirt build
> > Changelog since v3 :
> > - Include modifications suggested by Jeremy
> > Changelog since v4 :
> > - including hardirq.h in entry_32/64.S is a bad idea (non ifndef'd C code),
> >   define HARDNMI_MASK in the .S files directly.
> > Changelog since v5 :
> > - Add HARDNMI_MASK to irq_count() and make die() more verbose for NMIs.
> > Changelog since v7 :
> > - Implement paravirtualized nmi_return.
> > Changelog since v8 :
> > - refreshed the patch for asm-offsets. Those were left out of v8.
> > - now depends on "Stringify support commas" patch.
> > Changelog since v9 :
> > - Only test the nmi nested preempt count flag upon return from exceptions, not
> >   on return from interrupts. Only the kernel return path has this test.
> > - Add Xen, VMI, lguest support. Use their iret pavavirt ops in lieu of
> >   nmi_return.
> > 
> > -- Ported to sched-devel.git
> > 
> > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> > CC: akpm@osdl.org
> > CC: mingo@elte.hu
> > CC: "H. Peter Anvin" <hpa@zytor.com>
> > CC: Jeremy Fitzhardinge <jeremy@goop.org>
> > CC: Steven Rostedt <rostedt@goodmis.org>
> > CC: "Frank Ch. Eigler" <fche@redhat.com>
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > ---
> >  arch/x86/include/asm/irqflags.h |   56 +++++++++++++++++++++++++++++++++++++++
> >  arch/x86/kernel/dumpstack.c     |    2 +
> >  arch/x86/kernel/entry_32.S      |   30 +++++++++++++++++++++
> >  arch/x86/kernel/entry_64.S      |   57 +++++++++++++++++++++++++++++++---------
> >  include/linux/hardirq.h         |   16 +++++++----
> >  5 files changed, 144 insertions(+), 17 deletions(-)
> > 
> > Index: linux/arch/x86/include/asm/irqflags.h
> > ===================================================================
> > --- linux.orig/arch/x86/include/asm/irqflags.h
> > +++ linux/arch/x86/include/asm/irqflags.h
> > @@ -51,6 +51,61 @@ static inline void native_halt(void)
> >  
> >  #endif
> >  
> > +#ifdef CONFIG_X86_64
> > +/*
> > + * Only returns from a trap or exception to a NMI context (intra-privilege
> > + * level near return) to the same SS and CS segments. Should be used
> > + * upon trap or exception return when nested over a NMI context so no iret is
> > + * issued. It takes care of modifying the eflags, rsp and returning to the
> > + * previous function.
> > + *
> > + * The stack, at that point, looks like :
> > + *
> > + * 0(rsp)  RIP
> > + * 8(rsp)  CS
> > + * 16(rsp) EFLAGS
> > + * 24(rsp) RSP
> > + * 32(rsp) SS
> > + *
> > + * Upon execution :
> > + * Copy EIP to the top of the return stack
> > + * Update top of return stack address
> > + * Pop eflags into the eflags register
> > + * Make the return stack current
> > + * Near return (popping the return address from the return stack)
> > + */
> > +#define NATIVE_INTERRUPT_RETURN_NMI_SAFE	pushq %rax;		\
> > +						movq %rsp, %rax;	\
> > +						movq 24+8(%rax), %rsp;	\
> > +						pushq 0+8(%rax);	\
> > +						pushq 16+8(%rax);	\
> > +						movq (%rax), %rax;	\
> > +						popfq;			\
> > +						ret
> > +#else
> > +/*
> > + * Protected mode only, no V8086. Implies that protected mode must
> > + * be entered before NMIs or MCEs are enabled. Only returns from a trap or
> > + * exception to a NMI context (intra-privilege level far return). Should be used
> > + * upon trap or exception return when nested over a NMI context so no iret is
> > + * issued.
> > + *
> > + * The stack, at that point, looks like :
> > + *
> > + * 0(esp) EIP
> > + * 4(esp) CS
> > + * 8(esp) EFLAGS
> > + *
> > + * Upon execution :
> > + * Copy the stack eflags to top of stack
> > + * Pop eflags into the eflags register
> > + * Far return: pop EIP and CS into their register, and additionally pop EFLAGS.
> > + */
> > +#define NATIVE_INTERRUPT_RETURN_NMI_SAFE	pushl 8(%esp);	\
> > +						popfl;		\
> > +						lret $4
> > +#endif
> > +
> >  #ifdef CONFIG_PARAVIRT
> >  #include <asm/paravirt.h>
> >  #else
> > @@ -109,6 +164,7 @@ static inline unsigned long __raw_local_
> >  
> >  #define ENABLE_INTERRUPTS(x)	sti
> >  #define DISABLE_INTERRUPTS(x)	cli
> > +#define INTERRUPT_RETURN_NMI_SAFE	NATIVE_INTERRUPT_RETURN_NMI_SAFE
> >  
> >  #ifdef CONFIG_X86_64
> >  #define SWAPGS	swapgs
> > Index: linux/arch/x86/kernel/dumpstack.c
> > ===================================================================
> > --- linux.orig/arch/x86/kernel/dumpstack.c
> > +++ linux/arch/x86/kernel/dumpstack.c
> > @@ -237,6 +237,8 @@ void __kprobes oops_end(unsigned long fl
> >  
> >  	if (!signr)
> >  		return;
> > +	if (in_nmi())
> > +		panic("Fatal exception in non-maskable interrupt");
> >  	if (in_interrupt())
> >  		panic("Fatal exception in interrupt");
> >  	if (panic_on_oops)
> > Index: linux/arch/x86/kernel/entry_32.S
> > ===================================================================
> > --- linux.orig/arch/x86/kernel/entry_32.S
> > +++ linux/arch/x86/kernel/entry_32.S
> > @@ -80,6 +80,8 @@
> >  
> >  #define nr_syscalls ((syscall_table_size)/4)
> >  
> > +#define HARDNMI_MASK 0x40000000
> > +
> 
> This is called "NMI_MASK" in 2.6.30. Did you test the x86_64 or 
> x86_32 portion of this patch ? 64-bits seems ok, but not 32.

i only tested the 64-bit side, and fixed up NMI_MASK only on that 
side (as you can see it from the patch). This was a partial port of 
your patch.

> It's all I can spot for now, but if you have popf/ret firing to 
> return to userspace instructions, there is clearly something fishy 
> there.

I think Linus's observation about cr2 corruption explains all the 
symptoms i saw.

And it all stabilized and started behaving under load once we 
switched to Peter's fast-GUP based soft-pte-lookup method.

	Ingo
