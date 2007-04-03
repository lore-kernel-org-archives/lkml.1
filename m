Return-Path: <linux-kernel-owner+w=401wt.eu-S965854AbXDCNvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965854AbXDCNvw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 09:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965907AbXDCNvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 09:51:52 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:33102 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965854AbXDCNvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 09:51:51 -0400
Date: Tue, 3 Apr 2007 19:29:19 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Gautham R Shenoy <ego@in.ibm.com>, akpm@linux-foundation.org,
       paulmck@us.ibm.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       mingo@elte.hu, dipankar@in.ibm.com, dino@in.ibm.com,
       masami.hiramatsu.pt@hitachi.com
Subject: Re: [PATCH 7/8] Clean up workqueue.c with respect to the freezer based cpu-hotplug
Message-ID: <20070403135919.GB32444@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070402053457.GA9076@in.ibm.com> <20070402054206.GG12962@in.ibm.com> <20070403114729.GA776@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070403114729.GA776@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03, 2007 at 03:47:29PM +0400, Oleg Nesterov wrote:
> I still think that wait_to_die + bind_cpu is unneeded complication.
> Why can't we do the following:
> 
> 	static int worker_thread(void *__cwq)
> 	{
> 		...
> 
> 		for (;;) {
> 			try_to_freeze();
> 
> 			prepare_to_wait(&cwq->more_work, &wait, TASK_INTERRUPTIBLE);
> 			if (!kthread_should_stop() && list_empty(&cwq->worklist))
> 				schedule();
> 			finish_wait(&cwq->more_work, &wait);
> 
> 			if (kthread_should_stop(cwq))
> 				break;
> 
> 			run_workqueue(cwq);
> 		}
> 
> 		return 0;
> 	}
> 
> ?

cleanup_workqueue_thread (in Gautham's patches) does this:

	thaw_process()
	kthread_stop()

There is a chance that after thaw_process() [but before we have posted
the kthread_stop], worker thread can come out of the refrigerator and start
running run_workqueue() - that will simply prolong the subsequent
kthread_stop() and the system freeze time.

We could do what you are suggesting if the thaw_process() part was
integrated into kthread_stop() code [basically thaw_process after
setting the kthread_stop_info.k flag].

> >  void fastcall flush_workqueue(struct workqueue_struct *wq)
> >  {
> > -	const cpumask_t *cpu_map = wq_cpu_map(wq);
> >  	int cpu;
> >
> >  	might_sleep();
> > -	for_each_cpu_mask(cpu, *cpu_map)
> > +	for_each_online_cpu(cpu)
> >  		flush_cpu_workqueue(per_cpu_ptr(wq->cpu_wq, cpu));
> >  }
> 
> Hm... I can't understand this change. I believe it is wrong.

Why?

> > -		for_each_possible_cpu(cpu) {
> > +		for_each_online_cpu(cpu) {
> 
> This is wrong. CPU_UP_PREPARE doesn't call init_cpu_workqueue().
> Easy to fix, but I personally think is is better to initialize
> the whole cpu_possible_map.

I tend to agree yes.

> >  static void cleanup_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)

[snip]

> > -	if (alive) {
> >  		thaw_process(cwq->thread);
> > -		wait_for_completion(&barr.done);
> > -
> > -		while (unlikely(cwq->status != CWQ_STOPPED))
> > -			cpu_relax();
> > -		/*
> > -		 * Wait until cwq->thread unlocks cwq->lock,
> > -		 * it won't touch *cwq after that.
> > -		 */
> > -		smp_rmb();
> > +		kthread_stop(cwq->thread);
> >  		cwq->thread = NULL;
> > -		spin_unlock_wait(&cwq->lock);
> >  	}
> >  }
> 
> Deadlockable. Suppose that the freezing is in progress, cwq->thread is not
> frozen yet. cleanup_workqueue_thread() calls thaw_process(cwq->thread),
> then cwq->thread() goes to refrigerator, kthread_stop() blocks forever.

Good catch! Can cleanup_workqueue_thread take some mutex to serialize
with freezer here (say freezer_mutex)?

Or better, since this seems to be a general problem for anyone who wants to do a
kthread_stop, how abt modifying kthread_stop like below:

kthread_stop(p)
{
	int old_exempt_flags;

	task_lock(p);
	old_exempt_flags = p->flags;
	p->flags |= PFE_ALL;	/* Exempt 'p' from being frozen? */
	task_unlock(p);

	kthread_stop_info.k = p;
	thaw_process(p);

	wait_for_completion();

}

Marking 'p' as exempt shouldn't be a problem because freezer would wait
on the thread doing kthread_stop() anyway before declaring system as
frozen.

> > +static void take_over_work(struct workqueue_struct *wq, unsigned int cpu)
> > +{
> > +	struct cpu_workqueue_struct *cwq = per_cpu_ptr(wq->cpu_wq, cpu);
> > +	struct list_head list;
> > +	struct work_struct *work;
> > +
> > +	spin_lock_irq(&cwq->lock);
> 
> This CPU is dead (or cancelled), we don't need cwq->lock.

yeah ..


> 
> >  static int __devinit workqueue_cpu_callback(struct notifier_block *nfb,
> >  						unsigned long action,
> >  						void *hcpu)
> > @@ -782,11 +768,6 @@ static int __devinit workqueue_cpu_callb
> >  	struct cpu_workqueue_struct *cwq;
> >  	struct workqueue_struct *wq;
> >
> > -	switch (action) {
> > -	case CPU_UP_PREPARE:
> > -		cpu_set(cpu, cpu_populated_map);
> > -	}
> > -
> >  	mutex_lock(&workqueue_mutex);
> >  	list_for_each_entry(wq, &workqueues, list) {
> >  		cwq = per_cpu_ptr(wq->cpu_wq, cpu);
> > @@ -799,6 +780,7 @@ static int __devinit workqueue_cpu_callb
> >  			return NOTIFY_BAD;
> >
> >  		case CPU_ONLINE:
> > +			kthread_bind(cwq->thread, cpu);
> >  			wake_up_process(cwq->thread);
> >  			break;
> >
> > @@ -806,6 +788,7 @@ static int __devinit workqueue_cpu_callb
> >  			if (cwq->thread)
> >  				wake_up_process(cwq->thread);
> >  		case CPU_DEAD:
> > +			take_over_work(wq, cpu);
> >  			cleanup_workqueue_thread(cwq, cpu);
> >  			break;
> >  		}
> 
> This means that the work_struct on single_threaded wq can't use any of
> 
> 	__create_workqueue()
> 	destroy_workqueue()
> 	flush_workqueue()
> 	cancel_work_sync()

The workqueue_mutex() should serialize these with workqueue_cpu_callback() to 
an extent, but  ..

> , they are all racy wrt workqueue_cpu_callback(), and we don't freeze
> single_threaded workqueues. This is bad.
> 
> Probaly we should:
> 
> 	- freeze all workqueues, even the single_threaded ones.

Yes I agree, we should target freezing everybody here. It feels much
safer that way!

The only dependency I have seen is stop_machine() called after processes
are frozen. It needs the services of a workqueue to create kthreads. We
need to atleast exempt that worker thread from being frozen. Hopefully
the list of such non-freezable singlethreaded workqueues will be tiny
enough for us to audit time-to-time.

> 	- helper_init() explicitely does __create_workqueue(FE_ALL).
> 	  this means that we should never use the functions above
> 	  with this workqueue.

Ok you seem to have covered what I went out to say above! 

Thx for your review so far ..

-- 
Regards,
vatsa
