Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933214Ab0CKQU6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 11:20:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53763 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933204Ab0CKQU4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 11:20:56 -0500
Date: Thu, 11 Mar 2010 17:19:09 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: Q: select_fallback_rq() && cpuset_lock()
Message-ID: <20100311161909.GA16008@redhat.com>
References: <20100309180615.GA11681@redhat.com> <1268239242.5279.46.camel@twins> <20100310173018.GA1294@redhat.com> <1268244075.5279.53.camel@twins> <20100310183259.GA23648@redhat.com> <20100311145248.GA12907@redhat.com> <1268321759.5037.113.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268321759.5037.113.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11, Peter Zijlstra wrote:
>
> On Thu, 2010-03-11 at 15:52 +0100, Oleg Nesterov wrote:
>
> > Btw, select_fallback_rq() takes
> > rcu_read_lock around cpuset_cpus_allowed_locked(). Why? I must have
> > missed something, but afaics this buys nothing.
>
> for task_cs() iirc.

it should be stable under task_lock()... Never mind.

> > How can we fix this later? Perhaps we can change
> > cpuset_track_online_cpus(CPU_DEAD) to scan all affected cpusets and
> > fixup the tasks with the wrong ->cpus_allowed == cpu_possible_mask.
>
> Problem is, we can't really fix up tasks, wakeup must be able to find a
> suitable cpu.

Yes sure. I meant, wakeup()->select_fallback_rq() sets cpus_allowed =
cpu_possible_map as we discussed. Then cpuset_track_online_cpus(CPU_DEAD)
fixes the affected tasks.

> > At first glance this should work in try_to_wake_up(p) case, we can't
> > race with cpuset_change_cpumask()/etc because of TASK_WAKING logic.
>
> Well, cs->cpus_possible can still go funny on us.

What do you mean? Afaics, cpusets always uses set_cpus_allowed() to
change task->cpus_allowed.

> > But I am not sure how can we fix move_task_off_dead_cpu(). I think
> > __migrate_task_irq() itself is fine, but if select_fallback_rq() is
> > called from move_task_off_dead_cpu() nothing protects ->cpus_allowed.
>
> It has that retry loop in case the migration fails, right?
>
> > We can race with cpusets, or even with the plain set_cpus_allowed().
> > Probably nothing really bad can happen, if the resulting cpumask
> > doesn't have online cpus due to the racing memcpys, we should retry
> > after __migrate_task_irq() fails. Or we can take cpu_rq(cpu)-lock
> > around cpumask_copy(p->cpus_allowed, cpu_possible_mask).
>
> It does the retry thing.

Yes, I mentioned retry logic too. But it can't always help, even without
cpusets.

Suppose a task T is bound to the dead CPU, and move_task_off_dead_cpu()
races with set_cpus_allowed(new_mask). I think it is fine if T gets
either new_mask or cpu_possible_map in ->cpus_allowed. But, it can get
a "random" mix if 2 memcpy() run in parallel. And it is possible that
__migrate_task_irq() will not fail if dest_cpu falls into resulting mask.

> > @@ -2289,10 +2289,9 @@ static int select_fallback_rq(int cpu, s
> >
> >  	/* No more Mr. Nice Guy. */
> >  	if (dest_cpu >= nr_cpu_ids) {
> > -		rcu_read_lock();
> > -		cpuset_cpus_allowed_locked(p, &p->cpus_allowed);
> > -		rcu_read_unlock();
> > -		dest_cpu = cpumask_any_and(cpu_active_mask, &p->cpus_allowed);
> > +		// XXX: take cpu_rq(cpu)->lock ???
> > +		cpumask_copy(&p->cpus_allowed, cpu_possible_mask);
> > +		dest_cpu = cpumask_any(cpu_active_mask);
>
>
> Right, this seems safe.

OK, I'll try to read this code a bit more and then send this patch.

Oleg.

