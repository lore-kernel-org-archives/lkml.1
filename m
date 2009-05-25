Return-Path: <linux-kernel-owner+w=401wt.eu-S1753547AbZEYGyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547AbZEYGyn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 02:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751830AbZEYGyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 02:54:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37543 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242AbZEYGyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 02:54:35 -0400
Date: Mon, 25 May 2009 08:54:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: Optimize context switch
	between identical inherited contexts
Message-ID: <20090525065417.GA9665@elte.hu>
References: <18966.10666.517218.332164@cargo.ozlabs.ibm.com> <tip-564c2b210add41df9a3a5aaa365c1d97cff6110d@git.kernel.org> <20090524113315.GA16151@elte.hu> <18970.14391.357197.638009@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18970.14391.357197.638009@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Paul Mackerras <paulus@samba.org> wrote:

> Ingo Molnar writes:
> 
> > * tip-bot for Paul Mackerras <paulus@samba.org> wrote:
> > 
> > > @@ -885,6 +934,16 @@ void perf_counter_task_sched_out(struct task_struct *task, int cpu)
> > >  
> > >  	regs = task_pt_regs(task);
> > >  	perf_swcounter_event(PERF_COUNT_CONTEXT_SWITCHES, 1, 1, regs, 0);
> > > +
> > > +	next_ctx = next->perf_counter_ctxp;
> > > +	if (next_ctx && context_equiv(ctx, next_ctx)) {
> > > +		task->perf_counter_ctxp = next_ctx;
> > > +		next->perf_counter_ctxp = ctx;
> > > +		ctx->task = next;
> > > +		next_ctx->task = task;
> > > +		return;
> > > +	}
> > 
> > there's one complication that this trick is causing - the migration 
> > counter relies on ctx->task to get per task migration stats:
> > 
> >  static inline u64 get_cpu_migrations(struct perf_counter *counter)
> >  {
> >         struct task_struct *curr = counter->ctx->task;
> > 
> >         if (curr)
> >                 return curr->se.nr_migrations;
> >         return cpu_nr_migrations(smp_processor_id());
> >  }
> > 
> > as ctx->task is now jumping (while we keep the context), the 
> > migration stats are out of whack.
> 
> How did you notice this?  The overall sum over all children should 
> still be correct, though some individual children's counters could 
> go negative, so the result of a read on the counter when some 
> children have exited and others haven't could look a bit strange.  
> Reading the counter after all children have exited should be fine, 
> though.

i've noticed a few weirdnesses and then added a debug check and 
noticed the negative delta values.

> One of the effects of optimizing the context switch is that in 
> general, reading the value of an inheritable counter when some 
> children have exited but some are still running might produce 
> results that include some of the activity of the still-running 
> children and might not include all of the activity of the children 
> that have exited.  If that's a concern then we need to implement 
> the "sync child counters" ioctl that has been suggested.
> 
> As for the migration counter, it is the only software counter that 
> is still using the "old" approach, i.e. it doesn't generate 
> interrupts and it uses the counter->prev_state field (which I hope 
> to eliminate one day).  It's also the only software counter which 
> counts events that happen while the task is not scheduled in.  The 
> cleanest thing would be to rewrite the migration counter code to 
> have a callin from the scheduler when migrations happen.

I'll check with the debug check removed again. If the end result is 
OK then i dont think we need to worry much about this, at this 
stage.

	Ingo
