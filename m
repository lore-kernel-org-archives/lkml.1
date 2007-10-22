Return-Path: <linux-kernel-owner+w=401wt.eu-S1754434AbXJVE63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434AbXJVE63 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 00:58:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751169AbXJVE6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 00:58:22 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:41573 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925AbXJVE6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 00:58:21 -0400
Date: Mon, 22 Oct 2007 10:28:18 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Rusty Russel <rusty@rustcorp.com.au>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Paul E McKenney <paulmck@us.ibm.com>
Subject: Re: [RFC PATCH 3/4] Replace per-subsystem mutexes with get_online_cpus
Message-ID: <20071022045818.GB7146@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20071016103308.GA9907@in.ibm.com> <20071016103637.GC16570@in.ibm.com> <20071021113917.GA80@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071021113917.GA80@tv-sign.ru>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 21, 2007 at 03:39:17PM +0400, Oleg Nesterov wrote:
> On 10/16, Gautham R Shenoy wrote:
> >
> > This patch converts the known per-subsystem cpu_hotplug mutexes to
> > get_online_cpus put_online_cpus.
> > It also eliminates the CPU_LOCK_ACQUIRE and CPU_LOCK_RELEASE hotplug
> > notification events.
> 
> Personally, I like the changes in workqueue.c very much, a couple of
> minor nits below.
> 
> > --- linux-2.6.23.orig/kernel/workqueue.c
> > +++ linux-2.6.23/kernel/workqueue.c
> > @@ -592,8 +592,6 @@ EXPORT_SYMBOL(schedule_delayed_work_on);
> >   * Returns zero on success.
> >   * Returns -ve errno on failure.
> >   *
> > - * Appears to be racy against CPU hotplug.
> > - *
> 
> see below,
> 
> >   * schedule_on_each_cpu() is very slow.
> >   */
> >  int schedule_on_each_cpu(work_func_t func)
> > @@ -605,7 +603,7 @@ int schedule_on_each_cpu(work_func_t fun
> >  	if (!works)
> >  		return -ENOMEM;
> >
> > -	preempt_disable();		/* CPU hotplug */
> > +	get_online_cpus();		/* CPU hotplug */
> >  	for_each_online_cpu(cpu) {
> >  		struct work_struct *work = per_cpu_ptr(works, cpu);
> >
> > @@ -613,7 +611,7 @@ int schedule_on_each_cpu(work_func_t fun
> >  		set_bit(WORK_STRUCT_PENDING, work_data_bits(work));
> >  		__queue_work(per_cpu_ptr(keventd_wq->cpu_wq, cpu), work);
> >  	}
> > -	preempt_enable();
> > +	put_online_cpus();
> >  	flush_workqueue(keventd_wq);
> 
> Still racy. To kill the race, please move flush_workqueue() up, before
> put_online_cpus().
> 
> > @@ -809,6 +809,7 @@ void destroy_workqueue(struct workqueue_
> >  	struct cpu_workqueue_struct *cwq;
> >  	int cpu;
> >
> > +	get_online_cpus();
> >  	mutex_lock(&workqueue_mutex);
> >  	list_del(&wq->list);
> >  	mutex_unlock(&workqueue_mutex);
> > @@ -817,6 +818,7 @@ void destroy_workqueue(struct workqueue_
> >  		cwq = per_cpu_ptr(wq->cpu_wq, cpu);
> >  		cleanup_workqueue_thread(cwq, cpu);
> >  	}
> > +	put_online_cpus();
> 
> Correct, but I'd suggest to do put_online_cpus() earlier, right after
> mutex_unlock(&workqueue_mutex).
> 
> > @@ -830,22 +832,17 @@ static int __devinit workqueue_cpu_callb
> >  	unsigned int cpu = (unsigned long)hcpu;
> >  	struct cpu_workqueue_struct *cwq;
> >  	struct workqueue_struct *wq;
> > +	int ret = NOTIFY_OK;
> >
> >  	action &= ~CPU_TASKS_FROZEN;
> >
> >  	switch (action) {
> > -	case CPU_LOCK_ACQUIRE:
> > -		mutex_lock(&workqueue_mutex);
> > -		return NOTIFY_OK;
> > -
> > -	case CPU_LOCK_RELEASE:
> > -		mutex_unlock(&workqueue_mutex);
> > -		return NOTIFY_OK;
> >
> 
> please remove this emtpy line
> 
> >  	case CPU_UP_PREPARE:
> >  		cpu_set(cpu, cpu_populated_map);
> >  	}
> >
> > +	mutex_lock(&workqueue_mutex);
> 
> We don't need workqueue_mutex here. With your patch workqueue_mutex protects
> list_head, nothing more. But all other callers (create/destroy) should take
> get_online_cpus() anyway. This means that we can convert workqueue_mutex to
> spinlock_t.

Thanks for the review! 
Will code these changes up in the next version and post them 
sometime soon.

> 
> Oleg.
> 

Thanks and Regards
gautham.
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
