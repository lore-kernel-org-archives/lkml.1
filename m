Return-Path: <linux-kernel-owner+w=401wt.eu-S1752855AbZHCKnM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855AbZHCKnM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 06:43:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751807AbZHCKnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 06:43:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49405 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319AbZHCKnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 06:43:10 -0400
Date: Mon, 3 Aug 2009 12:43:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org
Subject: Re: NMI between switch_mm and switch_to
Message-ID: <20090803104303.GA18165@elte.hu>
References: <19054.33655.297932.261580@cargo.ozlabs.ibm.com> <1248767472.6987.2806.camel@twins> <20090803082922.GB12498@elte.hu> <19062.48341.397129.599184@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19062.48341.397129.599184@cargo.ozlabs.ibm.com>
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


* Paul Mackerras <paulus@samba.org> wrote:

> Ingo Molnar writes:
> 
> > * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > 
> > > On Tue, 2009-07-28 at 14:49 +1000, Paul Mackerras wrote:
> > >
> > > > Ben H. suggested there might be a problem if we get a PMU 
> > > > interrupt and try to do a stack trace of userspace in the 
> > > > interval between when we call switch_mm() from 
> > > > sched.c:context_switch() and when we call switch_to().  If we 
> > > > get an NMI in that interval and do a stack trace of userspace, 
> > > > we'll see the registers of the old task but when we peek at user 
> > > > addresses we'll see the memory image for the new task, so the 
> > > > stack trace we get will be completely bogus.
> > > > 
> > > > Is this in fact also a problem on x86, or is there some subtle 
> > > > reason why it can't happen there?
> > > 
> > > I can't spot one, maybe Ingo can when he's back :-)
> > > 
> > > So I think this is very good spotting from Ben.
> > 
> > Yeah.
> > 
> > > We could use preempt notifiers (or put in our own hooks) to 
> > > disable callchains during the context switch I suppose.
> > 
> > I think we should only disable user call-chains i think - the 
> > in-kernel call-chain is still reliable.
> > 
> > Also, i think we dont need preempt notifiers, we can use a simple 
> > check like this:
> > 
> > 	if (current->mm &&
> > 		cpu_isset(smp_processor_id(), &current->mm->cpu_vm_mask) {
> 
> On x86, do you clear the current processor's bit in cpu_vm_mask 
> when you switch the MMU away from a task?  We don't on powerpc, 
> which would render the above test incorrect.  (But then we don't 
> actually have the problem on powerpc since interrupts get 
> hard-disabled in switch_mm and stay hard-disabled until they get 
> soft-enabled.)

This is what x86 does in arch/x86/include/asm/mmu_context.h:

static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
			     struct task_struct *tsk)
{
	unsigned cpu = smp_processor_id();

	if (likely(prev != next)) {
		/* stop flush ipis for the previous mm */
		cpu_clear(cpu, prev->cpu_vm_mask);
#ifdef CONFIG_SMP
		percpu_write(cpu_tlbstate.state, TLBSTATE_OK);
		percpu_write(cpu_tlbstate.active_mm, next);
#endif
		cpu_set(cpu, next->cpu_vm_mask);

		/* Re-load page tables */
		load_cr3(next->pgd);

		/*
		 * load the LDT, if the LDT is different:
		 */
		if (unlikely(prev->context.ldt != next->context.ldt))
			load_LDT_nolock(&next->context);
	}
#ifdef CONFIG_SMP
	else {
		percpu_write(cpu_tlbstate.state, TLBSTATE_OK);
		BUG_ON(percpu_read(cpu_tlbstate.active_mm) != next);

		if (!cpu_test_and_set(cpu, next->cpu_vm_mask)) {
			/* We were in lazy tlb mode and leave_mm disabled
			 * tlb flush IPI delivery. We must reload CR3
			 * to make sure to use no freed page tables.
			 */
			load_cr3(next->pgd);
			load_LDT_nolock(&next->context);
		}
	}
#endif
}

which would suggest to me that cpu_vm_mask is precise.

	Ingo
