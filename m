Return-Path: <linux-kernel-owner+w=401wt.eu-S1755405AbZAGRRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405AbZAGRRw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 12:17:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbZAGRRn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 12:17:43 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53155 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750713AbZAGRRn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 12:17:43 -0500
Date: Wed, 7 Jan 2009 18:17:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexey Zaytsev <alexey.zaytsev@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: linux-next: Tree for December 11
Message-ID: <20090107171730.GA21799@elte.hu>
References: <20081211200459.14d18d7a.sfr@canb.auug.org.au> <f19298770812110440s7e3781eex4a16b961ad6847b2@mail.gmail.com> <f19298770812140634j434bf6a6gd883688f00dac45e@mail.gmail.com> <f19298770901070830q71cc7604nf55e1d5b70a22f37@mail.gmail.com> <alpine.LFD.2.00.0901070840240.3057@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0901070840240.3057@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, 7 Jan 2009, Alexey Zaytsev wrote:
> >
> > Almost a month later, the warning is still there, and now also in 
> > Linus' git. Am I the only one who sees it?
> 
> Possibly. But that may be because most people don't have DEBUG_PREEMPT.

hm, i never saw this warning and i run tons of different kernels (on 
different hw with different build environments) so if this was a more 
generic BKL init problem i'd expect to have seen it one way or another.

But i think the bug that Alexey is seeing is genuine:

> > [    0.004150] WARNING: at kernel/sched.c:4435 sub_preempt_count+0xae/0xc0()
> > [    0.004247] Hardware name: HP Compaq nx7300 (GB848ES#ACB)
> > [    0.004342] Modules linked in:
> > [    0.004477] Pid: 0, comm: swapper Not tainted 2.6.28-06859-gede6f5a #179
> > [    0.004575] Call Trace:
> > [    0.004672]  [<c012fbe6>] warn_slowpath+0x86/0xa0
> > [    0.004770]  [<c014e99b>] ? tick_check_oneshot_change+0x4b/0x100
> > [    0.004868]  [<c046dc00>] ? _spin_unlock_irq+0x10/0x30
> > [    0.004963]  [<c047045e>] sub_preempt_count+0xae/0xc0
> > [    0.005060]  [<c0134787>] _local_bh_enable+0x27/0xa0
> 
> Hmm. _local_bh_enable() would make the preempt_count go negative or fall 
> below 1 (with kernel lock held).
> 
> > [    0.005155]  [<c0134ac7>] __do_softirq+0xf7/0x150
> > [    0.005250]  [<c01349d0>] ? __do_softirq+0x0/0x150
> > [    0.005345]  <IRQ>  [<c014ec2e>] ? tick_nohz_update_jiffies+0xe/0x50
> > [    0.005488]  [<c013494f>] ? irq_exit+0x7f/0x90
> > [    0.005584]  [<c0104f23>] ? do_IRQ+0xa3/0x120
> > [    0.005678]  [<c01038a7>] ? common_interrupt+0x27/0x2c
> > [    0.005773]  [<c013007b>] ? try_acquire_console_sem+0x1b/0x30
> > [    0.005872]  [<c05f7378>] ? check_bugs+0xb8/0xe0
> > [    0.005967]  [<c05ef98a>] ? start_kernel+0x25a/0x2f0
> 
> .. and it happens early on, when we take an interrupt in check_bugs.
> 
> Are we ready to enable interrupts there? Maybe the page fault we took 
> (on purpose) enabled interrupts and we now take the irq much too early.
> 
> Or maybe the initial kernel lock didn't set preempt_count to 1.
> 
> Ingo, any ideas?

i dont think it's a BKL problem - i think something in linux-next which 
went upstream recently leaked a preempt count.

What is weird is that we have detection for softirq preemption leaks:

                        if (unlikely(prev_count != preempt_count())) {
                                printk(KERN_ERR "huh, entered softirq %td %p"
                                       "with preempt_count %08x,"
                                       " exited with %08x?\n", h - softirq_vec,
                                       h->action, prev_count, preempt_count());
                                preempt_count() = prev_count;

And this did not appear to have triggered for Alexey. So this probably 
cannot be a softirq handler leak, nor an initcall handler leak.

The only possibility seems to be for this to be a preempt leak in hardirq 
handler - i.e. locking inbalance by some driver. It did not get detected 
there (because the preempt count was kept elevated by the BKL and by the 
softirq handler), but when the softirq got released. The stack has some 
hardirq signs, but no specific blame for which driver might be 
responsible.

This would be a candidate for bisection i suspect, barring any better, 
more specific ideas (like a specific timeframe for when this hit upstream, 
or a better stacktrace of the hardirq context that triggered this softirq 
instance).

	Ingo
