Return-Path: <linux-kernel-owner+w=401wt.eu-S1754200AbZEYGSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200AbZEYGSw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 02:18:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751527AbZEYGSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 02:18:45 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:38691 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742AbZEYGSo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 02:18:44 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18970.14391.357197.638009@cargo.ozlabs.ibm.com>
Date: Mon, 25 May 2009 16:18:31 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: Optimize context switch
	between identical inherited contexts
In-Reply-To: <20090524113315.GA16151@elte.hu>
References: <18966.10666.517218.332164@cargo.ozlabs.ibm.com>
	<tip-564c2b210add41df9a3a5aaa365c1d97cff6110d@git.kernel.org>
	<20090524113315.GA16151@elte.hu>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> * tip-bot for Paul Mackerras <paulus@samba.org> wrote:
> 
> > @@ -885,6 +934,16 @@ void perf_counter_task_sched_out(struct task_struct *task, int cpu)
> >  
> >  	regs = task_pt_regs(task);
> >  	perf_swcounter_event(PERF_COUNT_CONTEXT_SWITCHES, 1, 1, regs, 0);
> > +
> > +	next_ctx = next->perf_counter_ctxp;
> > +	if (next_ctx && context_equiv(ctx, next_ctx)) {
> > +		task->perf_counter_ctxp = next_ctx;
> > +		next->perf_counter_ctxp = ctx;
> > +		ctx->task = next;
> > +		next_ctx->task = task;
> > +		return;
> > +	}
> 
> there's one complication that this trick is causing - the migration 
> counter relies on ctx->task to get per task migration stats:
> 
>  static inline u64 get_cpu_migrations(struct perf_counter *counter)
>  {
>         struct task_struct *curr = counter->ctx->task;
> 
>         if (curr)
>                 return curr->se.nr_migrations;
>         return cpu_nr_migrations(smp_processor_id());
>  }
> 
> as ctx->task is now jumping (while we keep the context), the 
> migration stats are out of whack.

How did you notice this?  The overall sum over all children should
still be correct, though some individual children's counters could go
negative, so the result of a read on the counter when some children
have exited and others haven't could look a bit strange.  Reading the
counter after all children have exited should be fine, though.

One of the effects of optimizing the context switch is that in
general, reading the value of an inheritable counter when some
children have exited but some are still running might produce results
that include some of the activity of the still-running children and
might not include all of the activity of the children that have
exited.  If that's a concern then we need to implement the "sync child
counters" ioctl that has been suggested.

As for the migration counter, it is the only software counter that is
still using the "old" approach, i.e. it doesn't generate interrupts
and it uses the counter->prev_state field (which I hope to
eliminate one day).  It's also the only software counter which counts
events that happen while the task is not scheduled in.  The cleanest
thing would be to rewrite the migration counter code to have a callin
from the scheduler when migrations happen.

Paul.
