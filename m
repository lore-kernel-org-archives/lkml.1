Return-Path: <linux-kernel-owner+w=401wt.eu-S1762271AbXGFOXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762271AbXGFOXx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 10:23:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753319AbXGFOXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 10:23:46 -0400
Received: from tomts13.bellnexxia.net ([209.226.175.34]:34045 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753180AbXGFOXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 10:23:45 -0400
Date: Fri, 6 Jul 2007 10:23:39 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Thread Migration Preemption
Message-ID: <20070706142339.GA32754@Krystal>
References: <20070706060257.GA188@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070706060257.GA188@tv-sign.ru>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:52:01 up 5 days,  8:34,  2 users,  load average: 0.30, 0.30, 0.19
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov (oleg@tv-sign.ru) wrote:
> Mathieu Desnoyers wrote:
> >
> > This patch adds the ability to protect critical sections from migration to
> > another CPU without disabling preemption.
> >
> > Typical use:
> >
> > migration_disable();
> > local_inc(&__get_cpu_var(&my_local_t_var));
> > migration_enable();
> >
> > --- linux-2.6-lttng.orig/kernel/sched.c	2007-07-05 16:28:15.000000000 -0400
> > +++ linux-2.6-lttng/kernel/sched.c	2007-07-05 16:53:24.000000000 -0400
> > @@ -1996,6 +1996,7 @@
> >  	 * 1) running (obviously), or
> >  	 * 2) cannot be migrated to this CPU due to cpus_allowed, or
> >  	 * 3) are cache-hot on their current CPU.
> > +	 * 4) migration preemption is non 0 for this non running task.
> >  	 */
> >  	if (!cpu_isset(this_cpu, p->cpus_allowed))
> >  		return 0;
> > @@ -2003,6 +2004,8 @@
> >
> >  	if (task_running(rq, p))
> >  		return 0;
> > +	if (task_thread_info(p)->migration_count)
> > +		return 0;
> 

Hi Oleg,

> Question: This means that the task could be preempted, but can't sleep, yes?
> 

No exactly. This means that the task can be preempted, and can therefore
sleep, but we do not allow this sleeping task to be migrated to a
different CPU.

> Because try_to_wake_up() can change ->cpu. Shouldn't might_sleep() check
> ->migration_count then? Or we can change try_to_wake_up().
> 

If we look at try_to_wake_up, it seems to take the new_cpu from
task_cpu(), which comes from the thread info ->cpu, updated by
set_task_cpu(). The *_move_tasks seems to be responsible for calling
can_migrate_task() to see if, in a deferred way, the migration_thread
can use set_task_cpu() to change the task's cpu.

move_task_off_dead_cpu() does not seem to respect this though: it could
potentially move away a process while it is in a critical section by
forcing a __migrate_task. I guess I should put a test in __migrate_task
also so move_task_off_dead_cpu() can try to repeat the migration.

> What if the task does copy_process() under migration_disable() ? Child
> gets a copy of ->migration_count.
> 

Right. Neighter does copy_process set the preemption count. It seems to
be dealt by sched_fork() when the thread is first scheduled in to make
sure that the preempt count is 1. I guess is would be safer to set the
migration count to 0 there too. (or set it to one if we ever decide to
make it the kernel default).

> Also, cpu_down() still can migrate this task to another CPU.
> 

Yes, just noted this earlier. I first thought it was using
can_migrate_task(), but it does not seem so.

Thanks,

Mathieu

> Oleg.
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
