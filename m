Return-Path: <linux-kernel-owner+w=401wt.eu-S1756792AbZFWLzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792AbZFWLzm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 07:55:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754822AbZFWLz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 07:55:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49796 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756330AbZFWLz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 07:55:27 -0400
Date: Tue, 23 Jun 2009 13:55:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: kerneloops.org report for the week of June 14 2009
Message-ID: <20090623115510.GC9497@elte.hu>
References: <20090614173331.18f01123@infradead.org> <alpine.LFD.2.00.0906231201430.2767@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0906231201430.2767@localhost.localdomain>
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


* Thomas Gleixner <tglx@linutronix.de> wrote:

> On Sun, 14 Jun 2009, Arjan van de Ven wrote:
> > Rank 3: getnstimeofday (warning)
> > 	Reported 309 times (2446 total reports)
> > 	[suspend resume] getnstimeofday() is called before timekeeping is
>         resumed
> 
> > Rank 6: hres_timers_resume (warning)
> > 	Reported 188 times (1024 total reports)
> > 	[suspend resume] hres_timers_resume() is incorrectly called with
> >       interrupts on
> 
> Both have the same root cause. Something enables interrupts in the 
> early resume path. IIRC, there was a culprit identified recently. 
> Rafael ?

This can be debugged automatically today, using lockdep, by using a 
'helper lock':

  static DEFINE_PER_CPU(struct lockdep_map, helper_lock);

Then mark the lock irq-safe by doing something like:

static void mark_lock_irqsafe(void)
{
	unsigned long flags;
	int cpu;

	local_irq_save(flags);
	irq_enter(0);

	for_each_online_cpu(cpu) {
		lock_acquire(&per_cpu(helper_lock, cpu), 0, 0, 0, 0, NULL, 0);
		lock_release(&per_cpu(helper_lock, cpu), 0, 0, 0, 0, NULL, 0);
	}

	irq_exit(0);
	local_irq_restore(flags);
}

Then, the resume path, when it disables irqs, you can disallow 
irq-enable via:

	local_irq_disable();
	lock_acquire(&__get_cpu_var(helper_lock), 0, 0, 0, 0, NULL, 0);
	...
	<extensive suspend or resume codepaths, callbacks> 
	...
	lock_release(&__get_cpu_var(helper_lock), 0, 0, 0, 0, NULL, 0);
	local_irq_enable();

And lockdep will warn if any function inbetween enables IRQs, by 
emitting a splat about incorrectly enabled hardirqs. It will warn 
about the specific place and will emit a relevant backtrace, - not 
just the handler in general.

This should work just fine with current lockdep facilities.

Rafael?

	Ingo
