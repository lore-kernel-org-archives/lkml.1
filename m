Return-Path: <linux-kernel-owner+w=401wt.eu-S1753582AbZKLRKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582AbZKLRKk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 12:10:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753342AbZKLRKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 12:10:39 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:49944 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305AbZKLRKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 12:10:39 -0500
Subject: Re: -next: Nov 12 - kernel BUG at kernel/sched.c:7359!
From: Peter Zijlstra <peterz@infradead.org>
To: Sachin Sant <sachinp@in.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Gautham R Shenoy <ego@in.ibm.com>
In-Reply-To: <1258028831.4039.152.camel@laptop>
References: <20091112195101.63263490.sfr@canb.auug.org.au>
	 <4AFBF73B.5040500@in.ibm.com> <1258027820.4039.129.camel@laptop>
	 <4AFBFE3D.80507@in.ibm.com>  <1258028831.4039.152.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 Nov 2009 18:10:31 +0100
Message-ID: <1258045831.4039.736.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-12 at 13:27 +0100, Peter Zijlstra wrote:
> On Thu, 2009-11-12 at 17:53 +0530, Sachin Sant wrote:
> > > How reproducable is this?
> > >   
> > I was able to recreate this once out of three tries.
> > 
> > When i was able to recreate this bug, the box had been
> > running for a while and i had executed series of tests
> > (kernbench, hackbench, hugetlbfs) before cpu_hotplug.
> 
> OK good, its easier to test patches when the thing is relatively easy to
> reproduce. I'll send you something to test once I've got a handle on it.

OK.. so on hotplug we do:

  cpu_down
   set_cpu_active(false)
   _cpu_down
    notify(CPU_DOWN_PREPARE)
    stop_machine(take_cpu_down)
     __cpu_disable()
      set_cpu_online(false);
     notify(CPU_DYING)
   __cpu_die()      /* note no more stop_machine */
   notify(CPU_DEAD)

Then on the scheduler hotplug notifier (migration_call), we mostly deal
with CPU_DEAD, where we do:

	case CPU_DEAD:
	case CPU_DEAD_FROZEN:
		cpuset_lock(); /* around calls to cpuset_cpus_allowed_lock() */
		migrate_live_tasks(cpu);

		rq = cpu_rq(cpu);
		kthread_stop(rq->migration_thread);
		put_task_struct(rq->migration_thread);
		rq->migration_thread = NULL;

		/* Idle task back to normal (off runqueue, low prio) */

		spin_lock_irq(&rq->lock);
		update_rq_clock(rq);
		deactivate_task(rq, rq->idle, 0);
		rq->idle->static_prio = MAX_PRIO;
		__setscheduler(rq, rq->idle, SCHED_NORMAL, 0);
		rq->idle->sched_class = &idle_sched_class;
		migrate_dead_tasks(cpu);
		spin_unlock_irq(&rq->lock);

		cpuset_unlock();

Where migrate_list_tasks() basically iterates the full task list, and
for each task where task_cpu() == dead_cpu invokes __migrate_task() to
move it to an online cpu.

Furthermore, the sched_domain notifier (update_sched_domains), will on
CPU_DEAD rebuild the sched_domain tree.

Now, I think this all can race against try_to_wake_up() when
select_task_rq_fair() hits the old sched_domain tree, because it only
overlays the sched_domain masks against p->cpus_allowed, without regard
for cpu_online_mask.

It could therefore return an offline cpu and move a task onto it after
migrate_live_tasks() and before migrate_dead_tasks().

The trivial solution that comes to mind is something like this:

diff --git a/kernel/sched.c b/kernel/sched.c
index 1f2e99d..15dcb41 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2376,7 +2376,11 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state,
 	p->state = TASK_WAKING;
 	task_rq_unlock(rq, &flags);
 
+again:
 	cpu = p->sched_class->select_task_rq(p, SD_BALANCE_WAKE, wake_flags);
+	if (!cpu_active(cpu))
+		goto again;
+
 	if (cpu != orig_cpu) {
 		local_irq_save(flags);
 		rq = cpu_rq(cpu);


However, Mike ran into a similar problem and we tried something similar
and that deadlocked for him -- something which I can see happen when we
do this from an interrupt on the machine running the CPU_DEAD notifier
and the update_sched_domains() notifier will be run after the
migration_call() notifier.

So what we need to do is make the whole of select_task_rq_fair()
cpu_online/active_mask aware, or give up and simply punt:

diff --git a/kernel/sched.c b/kernel/sched.c
index 1f2e99d..62df61c 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2377,6 +2377,9 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state,
 	task_rq_unlock(rq, &flags);
 
 	cpu = p->sched_class->select_task_rq(p, SD_BALANCE_WAKE, wake_flags);
+	if (!cpu_active(cpu))
+		cpu = cpumask_any_and(&p->cpus_allowed, cpu_active_mask);
+
 	if (cpu != orig_cpu) {
 		local_irq_save(flags);
 		rq = cpu_rq(cpu);


Something I think Mike also tried and didn't deadlock for him..

Sachin, Mike, could you try the above snippet and verify if it does
indeed solve your respective issues?

/me prays it does, because otherwise I'm fresh out of clue...

