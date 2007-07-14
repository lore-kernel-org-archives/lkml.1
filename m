Return-Path: <linux-kernel-owner+w=401wt.eu-S1764284AbXGNT4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764284AbXGNT4h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 15:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760924AbXGNT43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 15:56:29 -0400
Received: from mail.screens.ru ([213.234.233.54]:46394 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754476AbXGNT43 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 15:56:29 -0400
Date: Sat, 14 Jul 2007 23:56:53 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC] Thread Migration Preemption - v2
Message-ID: <20070714195653.GB108@tv-sign.ru>
References: <20070706060257.GA188@tv-sign.ru> <20070706142339.GA32754@Krystal> <20070706145634.GA198@tv-sign.ru> <20070711044915.GA4025@Krystal> <20070711163648.GA232@tv-sign.ru> <20070714182743.GE6975@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070714182743.GE6975@Krystal>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14, Mathieu Desnoyers wrote:
>
> * Oleg Nesterov (oleg@tv-sign.ru) wrote:
> > >  	/* Affinity changed (again). */
> > >  	if (!cpu_isset(dest_cpu, p->cpus_allowed))
> > >  		goto out;
> > >  
> > >  	on_rq = p->se.on_rq;
> > > +#ifdef CONFIG_PREEMPT
> > > +	if (!on_rq && task_thread_info(p)->migrate_count)
> > > +		goto out;
> > > +#endif
> > 
> > This means that move_task_off_dead_cpu() will spin until the task will be scheduled
> > on the dead CPU. Given that we hold tasklist_lock and irqs are disabled, this may
> > never happen.
> > 
> 
> Yes. My idea to fix this issue is the following:
> 
> If a thread has non zero migrate_count, we should still move it to a
> different CPU upon hotplug cpu removal, even if this thread resists
> migration. Care should be taken to send _all_ such threads to the _same_
> CPU so they don't race for the per-cpu ressources. Does it make sense ?
> 
> We would have to keep the CPU affinity of the threads running on the
> wrong CPU until they end their migrate disabled section, so that we can
> put them back on their original CPU if it goes back online, otherwise we
> could end up with concurrent per-cpu variables accesses.

Well, this means that migrate_disable() doesn't guarantee a stable
smp_processor_id(), not good.

> > > @@ -4891,10 +4957,22 @@
> > >  		list_del_init(head->next);
> > >  
> > >  		spin_unlock(&rq->lock);
> > > -		__migrate_task(req->task, cpu, req->dest_cpu);
> > > +		migrated = __migrate_task(req->task, cpu, req->dest_cpu);
> > >  		local_irq_enable();
> > > -
> > > -		complete(&req->done);
> > > +		if (!migrated) {
> > > +			/*
> > > +			 * If the process has not been migrated, let it run
> > > +			 * until it reaches a migration_check() so it can
> > > +			 * wake us up.
> > > +			 */
> > > +			spin_lock_irq(&rq->lock);
> > > +			head = &rq->migration_queue;
> > > +			list_add(&req->list, head);
> > > +			set_tsk_thread_flag(req->task, TIF_NEED_MIGRATE);
> > > +			spin_unlock_irq(&rq->lock);
> > > +			wake_up_process(req->task);
> > > +		} else
> > > +			complete(&req->done);
> > 
> > I guess this is migration_thread(). The wake_up_process(req->task) looks strange,
> > why? It can't help if the task waits for the event/mutex.
> > 
> 
> Hrm, the idea was to wake up the thread that is in the migrate disabled
> section, which is what I seem to do req->task points to the process we
> try to migrate. We poke it like this until is ends its critical
> section.

But this can only waste CPU, nothing more, no? Suppose that req->thread
sleeps waiting for the mutex. You can wake it up, and it will call schedule()
again.

This can help if req->thread does something like schedule_timeout(), but
I don't think this is a common case.

Oleg.

