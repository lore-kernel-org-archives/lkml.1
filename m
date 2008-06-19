Return-Path: <linux-kernel-owner+w=401wt.eu-S1756675AbYFSK1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675AbYFSK1Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 06:27:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755178AbYFSK1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 06:27:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:35065 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014AbYFSK1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 06:27:13 -0400
Subject: Re: [ANNOUNCE] sched: schedtop utility
From: Peter Zijlstra <peterz@infradead.org>
To: Ankita Garg <ankita@in.ibm.com>
Cc: Gregory Haskins <ghaskins@novell.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, rostedt@goodmis.org,
       suresh.b.siddha@intel.com, aneesh.kumar@linux.vnet.ibm.com,
       dhaval@linux.vnet.ibm.com, vatsa@linux.vnet.ibm.com,
       David Bahi <DBahi@novell.com>
In-Reply-To: <20080605052008.GA7635@in.ibm.com>
References: <483545B4.BA47.005A.0@novell.com>
	 <20080602124822.GA15410@in.ibm.com>
	 <1212412051.6269.5.camel@lappy.programming.kicks-ass.net>
	 <20080605052008.GA7635@in.ibm.com>
Content-Type: text/plain
Date: Thu, 19 Jun 2008 12:27:14 +0200
Message-Id: <1213871234.10476.12.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-06-05 at 10:50 +0530, Ankita Garg wrote:

> Thanks Peter for the explanation...
>
> I agree with the above and that is the reason why I did not see weird
> values with cpu_time. But, run_delay still would suffer skews as the end
> points for delta could be taken on different cpus due to migration (more
> so on RT kernel due to the push-pull operations). With the below patch,
> I could not reproduce the issue I had seen earlier. After every dequeue,
> we take the delta and start wait measurements from zero when moved to a 
> different rq.

OK, so task delay delay accounting is broken because it doesn't take
migration into account.

What you've done is make it symmetric wrt enqueue, and account it like

  cpu0      cpu1

enqueue
 <wait-d1>
dequeue
            enqueue
             <wait-d2>
            run

Where you add both d1 and d2 to the run_delay,.. right?

This seems like a good fix, however it looks like the patch will break
compilation in !CONFIG_SCHEDSTATS && !CONFIG_TASK_DELAY_ACCT, of it
failing to provide a stub for sched_info_dequeue() in that case.


> Signed-off-by: Ankita Garg <ankita@in.ibm.com> 
> 
> Index: linux-2.6.24.4/kernel/sched.c
> ===================================================================
> --- linux-2.6.24.4.orig/kernel/sched.c	2008-06-03 14:14:07.000000000 +0530
> +++ linux-2.6.24.4/kernel/sched.c	2008-06-04 12:48:34.000000000 +0530
> @@ -948,6 +948,7 @@
>  
>  static void dequeue_task(struct rq *rq, struct task_struct *p, int sleep)
>  {
> +	sched_info_dequeued(p);
>  	p->sched_class->dequeue_task(rq, p, sleep);
>  	p->se.on_rq = 0;
>  }
> Index: linux-2.6.24.4/kernel/sched_stats.h
> ===================================================================
> --- linux-2.6.24.4.orig/kernel/sched_stats.h	2008-06-03 14:14:28.000000000 +0530
> +++ linux-2.6.24.4/kernel/sched_stats.h	2008-06-05 10:39:39.000000000 +0530
> @@ -113,6 +113,13 @@
>  	if (rq)
>  		rq->rq_sched_info.cpu_time += delta;
>  }
> +
> +static inline void
> +rq_sched_info_dequeued(struct rq *rq, unsigned long long delta)
> +{
> +	if (rq)
> +		rq->rq_sched_info.run_delay += delta;
> +}
>  # define schedstat_inc(rq, field)	do { (rq)->field++; } while (0)
>  # define schedstat_add(rq, field, amt)	do { (rq)->field += (amt); } while (0)
>  # define schedstat_set(var, val)	do { var = (val); } while (0)
> @@ -129,6 +136,11 @@
>  #endif
>  
>  #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
> +static inline void sched_info_reset_dequeued(struct task_struct *t)
> +{
> +	t->sched_info.last_queued = 0;
> +}
> +
>  /*
>   * Called when a process is dequeued from the active array and given
>   * the cpu.  We should note that with the exception of interactive
> @@ -138,15 +150,22 @@
>   * active queue, thus delaying tasks in the expired queue from running;
>   * see scheduler_tick()).
>   *
> - * This function is only called from sched_info_arrive(), rather than
> - * dequeue_task(). Even though a task may be queued and dequeued multiple
> - * times as it is shuffled about, we're really interested in knowing how
> - * long it was from the *first* time it was queued to the time that it
> - * finally hit a cpu.
> + * Though we are interested in knowing how long it was from the *first* time a
> + * task was queued to the time that it finally hit a cpu, we call this routine
> + * from dequeue_task() to account for possible rq->clock skew across cpus. The
> + * delta taken on each cpu would annul the skew.
>   */
>  static inline void sched_info_dequeued(struct task_struct *t)
>  {
> -	t->sched_info.last_queued = 0;
> +	unsigned long long now = task_rq(t)->clock, delta = 0;
> +
> +	if(unlikely(sched_info_on()))
> +		if(t->sched_info.last_queued)
> +				delta = now - t->sched_info.last_queued;
> +	sched_info_reset_dequeued(t);
> +	t->sched_info.run_delay += delta;
> +
> +	rq_sched_info_dequeued(task_rq(t), delta);
>  }
>  
>  /*
> @@ -160,7 +179,7 @@
>  
>  	if (t->sched_info.last_queued)
>  		delta = now - t->sched_info.last_queued;
> -	sched_info_dequeued(t);
> +	sched_info_reset_dequeued(t);
>  	t->sched_info.run_delay += delta;
>  	t->sched_info.last_arrival = now;
>  	t->sched_info.pcount++;
> 

