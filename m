Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933052Ab0CKPgH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 10:36:07 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:53821 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932198Ab0CKPgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 10:36:05 -0500
Subject: Re: Q: select_fallback_rq() && cpuset_lock()
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20100311145248.GA12907@redhat.com>
References: <20100309180615.GA11681@redhat.com>
	 <1268239242.5279.46.camel@twins> <20100310173018.GA1294@redhat.com>
	 <1268244075.5279.53.camel@twins> <20100310183259.GA23648@redhat.com>
	 <20100311145248.GA12907@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Mar 2010 16:35:59 +0100
Message-ID: <1268321759.5037.113.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-11 at 15:52 +0100, Oleg Nesterov wrote:
> On 03/10, Oleg Nesterov wrote:
> >
> > On 03/10, Peter Zijlstra wrote:
> > >
> > > Right, so if you refresh these patches, I'll feed them to mingo and they
> > > should eventually end up in -linus, how's that? :-)
> >
> > Great. Will redo/resend tomorrow ;)
> 
> That was a great plan, but it doesn't work.
> 
> With the recent changes we have even more problems with
> cpuset_cpus_allowed_locked(). Not only it misses cpuset_lock() (which
> doesn't work anyway and must die imho), it is very wrong to even call
> this function from try_to_wakeup() - this can deadlock.
> 
> Because task_cs() is protected by task_lock() which is not irq-safe,
> and cpuset_cpus_allowed_locked() takes this lock.

You're right, and lockdep doesn't normally warn about that because
nobody really hits this path :/

> We need more changes in cpuset.c. Btw, select_fallback_rq() takes
> rcu_read_lock around cpuset_cpus_allowed_locked(). Why? I must have
> missed something, but afaics this buys nothing.

for task_cs() iirc.

> From the previous email:
> 
> 	On 03/10, Peter Zijlstra wrote:
> 	>
> 	> On Wed, 2010-03-10 at 18:30 +0100, Oleg Nesterov wrote:
> 	> > On 03/10, Peter Zijlstra wrote:
> 	> > >
> 	> > > I guess the quick fix is to really bail and always use cpu_online_mask
> 	> > > in select_fallback_rq().
> 	> >
> 	> > Yes, but this breaks cpusets.
> 	>
> 	> Arguably, so, but you can also argue that binding a task to a cpu and
> 	> then unplugging that cpu without first fixing up the affinity is a 'you
> 	> get to keep both pieces' situation.
> 
> Well yes, but still it was supposed the kernel should handle this case
> correctly, the task shouldn't escape its cpuset.
> 
> However, currently I don't see another option. I think we should fix the
> possible deadlocks and kill cpuset_lock/cpuset_cpus_allowed_locked first,
> then try to fix cpusets.
> 
> See the trivial (uncompiled) patch below. It just states a fact
> cpuset_cpus_allowed() logic is broken.
> 
> How can we fix this later? Perhaps we can change
> cpuset_track_online_cpus(CPU_DEAD) to scan all affected cpusets and
> fixup the tasks with the wrong ->cpus_allowed == cpu_possible_mask.

Problem is, we can't really fix up tasks, wakeup must be able to find a
suitable cpu.

> At first glance this should work in try_to_wake_up(p) case, we can't
> race with cpuset_change_cpumask()/etc because of TASK_WAKING logic.

Well, cs->cpus_possible can still go funny on us.

> But I am not sure how can we fix move_task_off_dead_cpu(). I think
> __migrate_task_irq() itself is fine, but if select_fallback_rq() is
> called from move_task_off_dead_cpu() nothing protects ->cpus_allowed.

It has that retry loop in case the migration fails, right?

> We can race with cpusets, or even with the plain set_cpus_allowed().
> Probably nothing really bad can happen, if the resulting cpumask
> doesn't have online cpus due to the racing memcpys, we should retry
> after __migrate_task_irq() fails. Or we can take cpu_rq(cpu)-lock
> around cpumask_copy(p->cpus_allowed, cpu_possible_mask).

It does the retry thing.

> sched_exec() seems fine, the task is current and running,
> "No more Mr. Nice Guy." case is not possible.
> 
> What do you think?
> 
> Btw, I think there is a small bug in set_cpus_allowed_ptr(),
> wake_up_process(rq->migration_thread) can hit NULL, we should do
> wake_up_process(mt).

Agreed.

> @@ -2289,10 +2289,9 @@ static int select_fallback_rq(int cpu, s
>  
>  	/* No more Mr. Nice Guy. */
>  	if (dest_cpu >= nr_cpu_ids) {
> -		rcu_read_lock();
> -		cpuset_cpus_allowed_locked(p, &p->cpus_allowed);
> -		rcu_read_unlock();
> -		dest_cpu = cpumask_any_and(cpu_active_mask, &p->cpus_allowed);
> +		// XXX: take cpu_rq(cpu)->lock ???
> +		cpumask_copy(&p->cpus_allowed, cpu_possible_mask);
> +		dest_cpu = cpumask_any(cpu_active_mask);


Right, this seems safe.

