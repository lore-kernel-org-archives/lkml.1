Return-Path: <linux-kernel-owner+w=401wt.eu-S1761496AbXJXSRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761496AbXJXSRl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 14:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757007AbXJXSRa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 14:17:30 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:39480 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756430AbXJXSR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 14:17:28 -0400
Date: Wed, 24 Oct 2007 23:15:53 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Rusty Russel <rusty@rustcorp.com.au>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC PATCH 4/5] Remove CPU_DEAD/CPU_UP_CANCELLED handling from
	workqueue.c
Message-ID: <20071024174553.GA8663@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20071024052931.GA22722@in.ibm.com> <20071024053716.GD27074@in.ibm.com> <20071024133818.GA82@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071024133818.GA82@tv-sign.ru>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2007 at 05:38:18PM +0400, Oleg Nesterov wrote:
> On 10/24, Gautham R Shenoy wrote:
> >
> 
> (reordered)
> 
> > With get_online_cpus()/put_online_cpus(), we can eliminate
> > the workqueue_mutex and reintroduce the workqueue_lock,
> > which is a spinlock which serializes the accesses to the 
> > workqueues list.
> 
> This change is obviously good, can't it go into the previous patch?

It can. Will repost.

> 
> Because,
> 
> > Solution is not to cleanup the worker thread. Instead let it remain
> > even after the cpu goes offline. Since no one can queue any work
> > on an offlined cpu, this thread will be forever sleeping, untill
> > someone onlines the cpu.
> 
> I still think this patch is questionable. Please look at my previous
> response http://marc.info/?l=linux-kernel&m=119262203729543
> 
> In short: with this patch it is not possible to guarantee that work->fun()
> will run on the correct CPU.
> 
> >  static void cleanup_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
> >  {
> >  	/*
> > -	 * Our caller is either destroy_workqueue() or CPU_DEAD,
> > -	 * workqueue_mutex protects cwq->thread
> > +	 * Our caller is destroy_workqueue().  So warn on a double
> > +	 * destroy.
> >  	 */
> > -	if (cwq->thread == NULL)
> > +	if (cwq->thread == NULL) {
> > +		WARN_ON(1);
> 
> Looks wrong. It is possible that cwq->thread == NULL, because currently we
> never "shrink" cpu_populated_map.
> 
> > cleanup_workqueue_thread() in the CPU_DEAD and CPU_UP_CANCELLED path
> > will cause a deadlock if the worker thread is executing a work item
> > which is blocked on get_online_cpus(). This will lead to a irrecoverable
> > hang.
> 
> Yes. But there is nothing new. Currently, work->func() can't share the locks
> with cpu_down's patch. Not only only it can't take workqueue_mutex, it can't
> take any other lock which could be taken by notifier callbacks, etc.
> 
> Can't we ignore this problem, at least for now? I believe we need intrusive
> changes to solve this problem correctly. Perhaps I am wrong, of course, but
> I don't see a simple solution.

I think you're right. Even with this patch, we obviously can deadlock
if one of the cpu_notifiers (say slab) calls flush_workqueue or
wait_on_work from say CPU_DOWN_PREPARE, and the work in question 
is blocked on get_online_cpus(). 


> 
> Another option. Note that get_online_cpus() does more than just pinning
> cpu maps, actually it blocks hotplug entirely. Now let's look at
> schedule_on_each_cpu(), for example. It doesn't need to block hotplug,
> it only needs a stable cpu_online_map.
> 
> Suppose for a moment that _cpu_down() does cpu_hotplug_done() earlier,
> right after __cpu_die(cpu) which removes CPU from the map (yes, this
> is wrong, I know). Now, we don't need to change workqueue_cpu_callback(),
> work->func() can use get_online_cpus() without fear of deadlock.
> 
> So, can't we introduce 2 nested rw locks? The first one blocks cpu hotplug
> (like get_online_cpus does currently), the second one just pins cpu maps.
> I think most users needs only this, not more.
> 

Well, rw locks/sems cannot recurse. However, refcount model supports
recursion naturally. Hence the implementation.

If the threads need a safe access to the cpu_online_map and they don't
sleep in that critical section, we can use preempt_disable()/preempt_enable()
which will block the stop_machine_run() and thus cpu_disable(). 
I think it would be a good idea to provide wrapper API's which 
will make the code easier to read. Also, I need to check if __cpu_up()
can be called using stop_machine_run(). 

However, if the subsystem changes it local variables depending on the
cpu-state , i.e CPU_DOWN_PREPARE, CPU_OFFLINE, etc then it would 
require synchronization with it's cpu-notifier. As of now, we have 
the per-subsystem cpu-hotplug mutexes providing this by blocking
the cpu-hotplug operation. get_online_cpus() is a substitute 
for this. And the case where a thread can block or can be preempted
while it is operating in the cpu-hotplug critical section.

> What do you think?

IIRC, the two-nesting rw lock implementation has been tried once before
around a year ago. But it didn't solve the problems due to threads
taking these rwlocks recursively. 

> 
> (Gautham, I apologize in advance, can't be responsive till weekend).
> 
> Oleg.
> 

Thanks for the review.

Regards
gautham.
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
