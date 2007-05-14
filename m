Return-Path: <linux-kernel-owner+w=401wt.eu-S1757971AbXENVW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757971AbXENVW6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 17:22:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753012AbXENVWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 17:22:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45244 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751559AbXENVWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 17:22:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: Freezeable workqueues [Was: 2.6.22-rc1: Broken suspend on SMP with tifm]
Date: Mon, 14 May 2007 23:27:35 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Alex Dubov <oakad@yahoo.com>, Pierre Ossman <drzeus@drzeus.cx>,
       Pavel Machek <pavel@ucw.cz>, Gautham R Shenoy <ego@in.ibm.com>
References: <200705132132.08546.rjw@sisk.pl> <200705140757.33746.rjw@sisk.pl> <20070514165429.GA83@tv-sign.ru>
In-Reply-To: <20070514165429.GA83@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705142327.37021.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 14 May 2007 18:55, Oleg Nesterov wrote:
> Long. Please read.
> 
> On 05/14, Rafael J. Wysocki wrote:
> >
> > I think I have solved this particular problem without any locking:
> 
> Rafael, I am afraid we are making too much noise, and this may confuse Alex
> and Andrew.
> 
> First, we should decide how to fix the bug we have in 2.6.22. I prefer a simple
> "make freezeable workqueues singlethread" I sent. It was acked by Alex, it is
> simple, and it is also good because tifm doesn't need multithreaded wq anyway.

Yes, I've already agreed with that.

> I'll comment the patch you sent below, but for a start....
> 
> -------------------------------------------------------------------------------
> Guys, let's have a plan !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
> 
> I do not understand what's going on. With or without recent changes in workqueue.c
> multithreaded freezeable workqueues were broken by other changes in suspend.
> 
> It was decided we don't need them, they should go away. We even had a patch
> which removed freezeable workqueues (multithreaded or not) completely. But it
> conflicted with other changes in -mm, so it was deleted, and then forgotten.
> 
> I never understood why do we need freezeable workqueues. Is they needed to
> synchronize with suspend? In that case, shouldn't we have some form of
> notification wich allows the driver to cancel the work which should not run
> at suspend time?

To make the long story short, we see some suspend-related problems that may
be attributed to workqueues used by XFS, but not directly, AFAICS.  That's why
we tried to introduce the freezability of workqueues, but I think that wasn't a
good idea.

> OK, so you think we should re-introduce them.

I just think we *might* introduce them, if there are some users.  Obviously we
have one user right now, but he only needs a singlethread workqueue, so your
small patch is the right thing to do for 2.6.22.

> What about incoming CPU-hotplug changes? The goal was - again! - remove the
> "singlethread" parameter, make them all freezeable, and freeze all processes
> to handle CPU_DEAD. In that case we don't have any problems, we can
> re-introduce take_over_work() without migrate_sequence this patch adds.
> 
> So.
> 	- Do we need freezeable workqueues ?

Well, we have at least one case in which they appear to be useful.

> 	- Do we need multithreaded freezeable workqueues ?

Not right now, if ever.

> 	- Do we need them for 2.6.22 ?

Certainly not.

> 	- Should we wait for CPU-hotplug changes, or we should
> 	  re-introduce them right now ?

We don't need to reintroduce freezable multithreaded workqueues right now.

> > --- linux-2.6.22-rc1.orig/kernel/workqueue.c
> > +++ linux-2.6.22-rc1/kernel/workqueue.c
> > @@ -62,6 +62,9 @@ struct workqueue_struct {
> >  	const char *name;
> >  	int singlethread;
> >  	int freezeable;		/* Freeze threads during suspend */
> > +	atomic_t work_sw;	/* Used to indicate that some work has been
> > +				 * moved from one CPU to another
> > +				 */
> >  };
> 
> "work_sw" should not be atomic, and since the race is _very_ unlikely it
> could be global. We had such a thing, it was called "migrate_sequence" and
> it was removed.
> 
> It didn't work, but it _can_ work now because we have cpu_populated_map.
> However, this needs more thinking, because it breaks cancel_work_sync()
> in a very subtle way.
> 
> > +static void take_over_work(struct workqueue_struct *wq, unsigned int cpu)
> > +{
> > +	struct cpu_workqueue_struct *cwq = per_cpu_ptr(wq->cpu_wq, cpu);
> > +	struct list_head list;
> > +	struct work_struct *work;
> > +
> > +	spin_lock_irq(&cwq->lock);
> > +	list_replace_init(&cwq->worklist, &list);
> > +
> > +	if (!list_empty(&list)) {
> > +		/*
> > +		 * Tell flush_workqueue() that it should repeat the loop over
> > +		 * CPUs
> > +		 */
> > +		atomic_inc(&wq->work_sw);
> > +		while (!list_empty(&list)) {
> > +			printk("Taking work for %s\n", wq->name);
> > +			work = list_entry(list.next, struct work_struct, entry);
> > +			list_del(&work->entry);
> > +			__queue_work(per_cpu_ptr(wq->cpu_wq,
> > +					smp_processor_id()), work);
> > +		}
> > +	}
> > +	spin_unlock_irq(&cwq->lock);
> > +}
> > +
> 
> Suppose that we have some pending WORK1 on CPU 0 which needs some LOCK.
> 
> We take this LOCK and call cancel_work_sync(WORK2) which is running on CPU 1.
> cancel_work_sync() inserts a barrier after WORK2 and waits for completion.
> 
> WORK2->func() completes.
> 
> freezer comes. cwq->thread notices TIF_FREEZE and goes to refrigerator before
> executing that barrier.
> 
> CPU_DEAD_FROZEN(cpu == 1) moves that barrier to CPU 0.
> 
> thaw_processes().
> 
> DEADLOCK.
> 
> We hold the LOCK and sleep waiting for the completion of that barrier.
> But there is WORK1 on queue which runs first, and needs this LOCK to
> complete.

Yeah, I need to learn more.

> > @@ -819,20 +860,31 @@ static int __devinit workqueue_cpu_callb
> >
> > +		case CPU_DEAD_FROZEN:
> > +			if (wq->freezeable) {
> > +				take_over_work(wq, cpu);
> > +				thaw_process(cwq->thread);
> > +			}
> > +			cleanup_workqueue_thread(cwq, cpu);
> > +			break;
> 
> If we have take_over_work() we should use it for any workqueue,
> freezeable or not. Otherwise this is just a mess, imho.

OK

> Rafael, this is tricky. Probably we can fix this, but this needs more
> changes. I can _try_ to do this, but not now (unless we think we need
> freezeable workqueues for 2.6.22).
> 
> I have other clenaups for workqueues, but I'd prefer to do nothing
> except bugfixes right now. A lot of non-reviewed intrusive changes
> were merged. They all need testing.

Sure, you're obviously right.

Sorry for the confusion I made.

Greetings,
Rafael
