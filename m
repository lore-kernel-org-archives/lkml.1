Return-Path: <linux-kernel-owner+w=401wt.eu-S1764894AbXGNUZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764894AbXGNUZY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 16:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760256AbXGNUZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 16:25:12 -0400
Received: from tomts10.bellnexxia.net ([209.226.175.54]:50145 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760673AbXGNUZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 16:25:11 -0400
Date: Sat, 14 Jul 2007 16:25:09 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC] Thread Migration Preemption - v4
Message-ID: <20070714202509.GR6975@Krystal>
References: <20070706060257.GA188@tv-sign.ru> <20070706142339.GA32754@Krystal> <20070706145634.GA198@tv-sign.ru> <20070711044915.GA4025@Krystal> <20070711163648.GA232@tv-sign.ru> <20070714184237.GI6975@Krystal> <1184440451.5284.75.camel@lappy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1184440451.5284.75.camel@lappy>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:24:37 up 7 days, 10:29,  2 users,  load average: 0.15, 0.24, 0.26
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (a.p.zijlstra@chello.nl) wrote:
> Would have been nice if you'd CC'ed me :-/
> 
Sorry

> On Sat, 2007-07-14 at 14:42 -0400, Mathieu Desnoyers wrote:
> 
> > @@ -4891,10 +4948,42 @@ static int migration_thread(void *data)
> >  		list_del_init(head->next);
> >  
> >  		spin_unlock(&rq->lock);
> > -		__migrate_task(req->task, cpu, req->dest_cpu);
> > +		migrated = __migrate_task(req->task, cpu, req->dest_cpu);
> >  		local_irq_enable();
> > -
> > -		complete(&req->done);
> > +		if (!migrated) {
> > +			/*
> > +			 * If the process has not been migrated, let it run
> > +			 * until it reaches a migration_check() so it can
> > +			 * wake us up.
> > +			 */
> > +			spin_lock_irq(&rq->lock);
> > +			head = &rq->migration_queue;
> > +			list_add(&req->list, head);
> > +			if (req->task->se.on_rq
> > +					|| !task_migrate_count(req->task)) {
> > +				/*
> > +				 * The process is on the runqueue, it could
> > +				 * exit its critical section at any moment,
> > +				 * don't race with it and retry actively.
> > +				 * Also, if the thread is not on the runqueue
> > +				 * and has a zero migration count
> > +				 * (__migrate_task failed because cpus allowed
> > +				 * changed), just retry.
> > +				 */
> > +				spin_unlock_irq(&rq->lock);
> > +				continue;
> > +			}
> > +			set_tsk_thread_flag(req->task, TIF_NEED_MIGRATE);
> > +			set_current_state(TASK_INTERRUPTIBLE);
> > +			spin_unlock_irq(&rq->lock);
> > +			/*
> > +			 * Wait for the process currently in its critical
> > +			 * section.
> > +			 */
> > +			wake_up_process(req->task);
> > +			schedule();
> > +		} else
> > +			complete(&req->done);
> >  	}
> >  	__set_current_state(TASK_RUNNING);
> >  	return 0;
> 
> I'm not really liking this, this way we hold up all other migration
> requests.
> 

True. You approach of delayed migration helps on this.

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
