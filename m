Return-Path: <linux-kernel-owner+w=401wt.eu-S1752109AbXDCP7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109AbXDCP7d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 11:59:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753501AbXDCP7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 11:59:33 -0400
Received: from mail.screens.ru ([213.234.233.54]:41864 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752109AbXDCP7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 11:59:32 -0400
Date: Tue, 3 Apr 2007 19:03:36 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>, akpm@linux-foundation.org,
       paulmck@us.ibm.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       mingo@elte.hu, dipankar@in.ibm.com, dino@in.ibm.com,
       masami.hiramatsu.pt@hitachi.com
Subject: Re: [PATCH 7/8] Clean up workqueue.c with respect to the freezer based cpu-hotplug
Message-ID: <20070403150336.GA850@tv-sign.ru>
References: <20070402053457.GA9076@in.ibm.com> <20070402054206.GG12962@in.ibm.com> <20070403114729.GA776@tv-sign.ru> <20070403135919.GB32444@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070403135919.GB32444@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03, Srivatsa Vaddagiri wrote:
>
> On Tue, Apr 03, 2007 at 03:47:29PM +0400, Oleg Nesterov wrote:
> > 
> > 		for (;;) {
> > 			try_to_freeze();
> > 
> > 			prepare_to_wait(&cwq->more_work, &wait, TASK_INTERRUPTIBLE);
> > 			if (!kthread_should_stop() && list_empty(&cwq->worklist))
> > 				schedule();
> > 			finish_wait(&cwq->more_work, &wait);
> > 
> > 			if (kthread_should_stop(cwq))
> > 				break;
> > 
> > 			run_workqueue(cwq);
> > 		}
> 
> cleanup_workqueue_thread (in Gautham's patches) does this:
> 
> 	thaw_process()
> 	kthread_stop()

Yes, thanks.

> We could do what you are suggesting if the thaw_process() part was
> integrated into kthread_stop() code [basically thaw_process after
> setting the kthread_stop_info.k flag].

I think it would be nice to do. I believe we can cleanup ksoftirqd()
and migration_thread() as well (kill wait_to_die: loop). Probably it
is better to introduce a new helper for that, kthread_thaw_stop() or
something.

> > >  void fastcall flush_workqueue(struct workqueue_struct *wq)
> > >  {
> > > -	const cpumask_t *cpu_map = wq_cpu_map(wq);
> > >  	int cpu;
> > >
> > >  	might_sleep();
> > > -	for_each_cpu_mask(cpu, *cpu_map)
> > > +	for_each_online_cpu(cpu)
> > >  		flush_cpu_workqueue(per_cpu_ptr(wq->cpu_wq, cpu));
> > >  }
> > 
> > Hm... I can't understand this change. I believe it is wrong.
> 
> Why?

What if is_single_threaded(wq) == true? In that case we should call
flush_cpu_workqueue(cpu) only if cpu == singlethread_cpu, otherwise
this is unneeded and wrong, because per_cpu_ptr(wq->cpu_wq, cpu) was
not initialized.

> > > +		kthread_stop(cwq->thread);
> > >  		cwq->thread = NULL;
> > > -		spin_unlock_wait(&cwq->lock);
> > >  	}
> > >  }
> > 
> > Deadlockable. Suppose that the freezing is in progress, cwq->thread is not
> > frozen yet. cleanup_workqueue_thread() calls thaw_process(cwq->thread),
> > then cwq->thread() goes to refrigerator, kthread_stop() blocks forever.
> 
> Good catch! Can cleanup_workqueue_thread take some mutex to serialize
> with freezer here (say freezer_mutex)?
> 
> Or better, since this seems to be a general problem for anyone who wants to do a
> kthread_stop, how abt modifying kthread_stop like below:
> 
> kthread_stop(p)
> {
> 	int old_exempt_flags;
> 
> 	task_lock(p);
> 	old_exempt_flags = p->flags;
> 	p->flags |= PFE_ALL;	/* Exempt 'p' from being frozen? */

I agree, we should mark this thread as non-freezable, but we can't modify
p->flags, this is racy. "current" owns its ->flags and it is not atomic.
Note that thaw_process() checks frozen(p) when it clears PF_FROZEN.

Actually, we should do this before destroy_workqueue() calls flush_workqueue().
Otherwise flush_cpu_workqueue() can hang forever in a similar manner.

Needs more thinking, I guess.

> > This means that the work_struct on single_threaded wq can't use any of
> > 
> > 	__create_workqueue()
> > 	destroy_workqueue()
> > 	flush_workqueue()
> > 	cancel_work_sync()
> 
> The workqueue_mutex() should serialize these with workqueue_cpu_callback() to 
> an extent, but  ..

No, no, workqueue_mutex can't help. Just for example: CPU_UP_PREPARE completes
and drops workqueue_mutex. __create_workqueue(wq) doesn't see the new cpu, it
is not on cpu_online_map, so it doesn't create cwq->thread. CPU_ONLINE oopses.

> Yes I agree, we should target freezing everybody here. It feels much
> safer that way!

Good!

Oleg.

