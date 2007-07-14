Return-Path: <linux-kernel-owner+w=401wt.eu-S1761987AbXGNS1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761987AbXGNS1x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 14:27:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759135AbXGNS1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 14:27:46 -0400
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:56557 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759173AbXGNS1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 14:27:45 -0400
Date: Sat, 14 Jul 2007 14:27:43 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC] Thread Migration Preemption - v2
Message-ID: <20070714182743.GE6975@Krystal>
References: <20070706060257.GA188@tv-sign.ru> <20070706142339.GA32754@Krystal> <20070706145634.GA198@tv-sign.ru> <20070711044915.GA4025@Krystal> <20070711163648.GA232@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070711163648.GA232@tv-sign.ru>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:24:25 up 7 days,  7:29,  2 users,  load average: 0.16, 0.10, 0.11
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov (oleg@tv-sign.ru) wrote:
> On 07/11, Mathieu Desnoyers wrote:
> > 
> > This patch adds the ability to protect critical sections from migration to
> > another CPU without disabling preemption.
> > 
> > This will be useful to minimize the amount of preemption disabling for the -rt
> > patch. It will help leveraging improvements brought by the local_t types in
> > asm/local.h (see Documentation/local_ops.txt). Note that the updates done to
> > variables protected by migrate_disable must be either atomic or protected from
> > concurrent updates done by other threads.
> > 
> > Typical use:
> > 
> > migrate_disable();
> > local_inc(&__get_cpu_var(&my_local_t_var));
> > migrate_enable();
> > 
> > Which will increment the variable atomically wrt the local CPU.
> 
> Well, I am not a maintainer, but I personally think this patch is too complex.
> 
> Mathieu, please use "diff -p", it is very difficult to read it. I am not sure
> I understand this patch correctly, I don't have a -git tree.
> 

man quilt... echo "QUILT_DIFF_OPTS="-p" > ~/.quiltrc. done. :) Thanks
for pointing this out, the next patches should include this.


> >  static int __migrate_task(struct task_struct *p, int src_cpu, int dest_cpu)
> >  {
> > @@ -4829,13 +4888,19 @@
> >  
> >  	double_rq_lock(rq_src, rq_dest);
> >  	/* Already moved. */
> > -	if (task_cpu(p) != src_cpu)
> > +	if (task_cpu(p) != src_cpu) {
> > +		ret = 1;
> >  		goto out;
> > +	}
> 
> This is a strange change. Why we return success when migration failed ?
> OK, I guess this is a special hack for the modified migration_thread()...
> 

Yes, I wanted to change __migrate_task so it returns true if, after it
has been called to migrate a task out of a source CPU, the task is
indeed now migrated out the this CPU.

It follows a comment already at the beginning of this function:

  * So we race with normal scheduler movements, but that's OK, as long
  * as the task is no longer on this CPU.

The comment at the beginning explains the new convention:

- * Returns non-zero if task was successfully migrated.
+ * Returns non-zero if task is on dest_cpu when this function ends.

Well.. my comment is not perfect. It should read:

- * Returns non-zero if task was successfully migrated.
+ * Returns non-zero if task is not on src_cpu when this function ends.

My assumption is that if migrate_task races with the scheduler movement
to move a task out of a CPU, it should return non-zero in every case
when the task has been migrated out of the src_cpu.


> >  	/* Affinity changed (again). */
> >  	if (!cpu_isset(dest_cpu, p->cpus_allowed))
> >  		goto out;
> >  
> >  	on_rq = p->se.on_rq;
> > +#ifdef CONFIG_PREEMPT
> > +	if (!on_rq && task_thread_info(p)->migrate_count)
> > +		goto out;
> > +#endif
> 
> This means that move_task_off_dead_cpu() will spin until the task will be scheduled
> on the dead CPU. Given that we hold tasklist_lock and irqs are disabled, this may
> never happen.
> 

Yes. My idea to fix this issue is the following:

If a thread has non zero migrate_count, we should still move it to a
different CPU upon hotplug cpu removal, even if this thread resists
migration. Care should be taken to send _all_ such threads to the _same_
CPU so they don't race for the per-cpu ressources. Does it make sense ?

We would have to keep the CPU affinity of the threads running on the
wrong CPU until they end their migrate disabled section, so that we can
put them back on their original CPU if it goes back online, otherwise we
could end up with concurrent per-cpu variables accesses.

(I'll wait for reply before coding a solution for this CPU HOTPLUG
related problem)

> (This patch adds a lot of #ifdef's, I think it could be simplified if you add
>  get_migrate_count() which is defined as 0 when !CONFIG_PREEMPT).

Sure. Added migrate_count() and task_migrate_count(task).

> 
> > @@ -4891,10 +4957,22 @@
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
> > +			set_tsk_thread_flag(req->task, TIF_NEED_MIGRATE);
> > +			spin_unlock_irq(&rq->lock);
> > +			wake_up_process(req->task);
> > +		} else
> > +			complete(&req->done);
> 
> I guess this is migration_thread(). The wake_up_process(req->task) looks strange,
> why? It can't help if the task waits for the event/mutex.
> 

Hrm, the idea was to wake up the thread that is in the migrate disabled
section, which is what I seem to do req->task points to the process we
try to migrate. We poke it like this until is ends its critical
section. At that moment, the thread will wake up the migration thread,
and only then do we let sched_migrate_task, which is waiting for
completion, finish.

> And this is racy. What if check_migrate() is in progress, and the task has already
> checked TIF_NEED_MIGRATE?
> 

The idea is to take the rq->lock to make sure the thread is not running
when we do this. Since the runqueue lock is released between the tests
in __migrate_task and this code, I should test again to see if it is
running. Currently, the migration thread retries actively if the thread
we are trying to migrate is in its critical section. The change I am
about to do does 2 things:

If the thread is on the runqueue, retry actively.
If the thread is not on the runqueue, set the NEED MIGRATE flag and go
to sleep, waiting for it to wake us up.

> Hm. We re-add "req" to rq->migration_queue. This means that migration_thread() will
> do a busy-wait loop. Not good and deadlockable, migration/X is SCHED_FIFO.

Yup. The comment above should hopefully fix it.

> And what if __migrate_task() failed because ->cpus_allowed was changed in between?
> 

Right, we should check for this. Will fix.

Thanks for the thorough review.

Mathieu

> Oleg.
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
