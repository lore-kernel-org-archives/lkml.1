Return-Path: <linux-kernel-owner+w=401wt.eu-S1763162AbXGFOzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763162AbXGFOzo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 10:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762270AbXGFOzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 10:55:35 -0400
Received: from mail.screens.ru ([213.234.233.54]:55284 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754743AbXGFOzf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 10:55:35 -0400
Date: Fri, 6 Jul 2007 18:56:34 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Thread Migration Preemption
Message-ID: <20070706145634.GA198@tv-sign.ru>
References: <20070706060257.GA188@tv-sign.ru> <20070706142339.GA32754@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070706142339.GA32754@Krystal>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06, Mathieu Desnoyers wrote:
>
> * Oleg Nesterov (oleg@tv-sign.ru) wrote:
> > Mathieu Desnoyers wrote:
> > >
> > > This patch adds the ability to protect critical sections from migration to
> > > another CPU without disabling preemption.
> > >
> > > Typical use:
> > >
> > > migration_disable();
> > > local_inc(&__get_cpu_var(&my_local_t_var));
> > > migration_enable();
> > >
> > > --- linux-2.6-lttng.orig/kernel/sched.c	2007-07-05 16:28:15.000000000 -0400
> > > +++ linux-2.6-lttng/kernel/sched.c	2007-07-05 16:53:24.000000000 -0400
> > > @@ -1996,6 +1996,7 @@
> > >  	 * 1) running (obviously), or
> > >  	 * 2) cannot be migrated to this CPU due to cpus_allowed, or
> > >  	 * 3) are cache-hot on their current CPU.
> > > +	 * 4) migration preemption is non 0 for this non running task.
> > >  	 */
> > >  	if (!cpu_isset(this_cpu, p->cpus_allowed))
> > >  		return 0;
> > > @@ -2003,6 +2004,8 @@
> > >
> > >  	if (task_running(rq, p))
> > >  		return 0;
> > > +	if (task_thread_info(p)->migration_count)
> > > +		return 0;
> > 
> 
> Hi Oleg,
> 
> > Question: This means that the task could be preempted, but can't sleep, yes?
> > 
> 
> No exactly. This means that the task can be preempted, and can therefore
> sleep, but we do not allow this sleeping task to be migrated to a
> different CPU.
> 
> > Because try_to_wake_up() can change ->cpu. Shouldn't might_sleep() check
> > ->migration_count then? Or we can change try_to_wake_up().
> > 
> 
> If we look at try_to_wake_up, it seems to take the new_cpu from
> task_cpu(), which comes from the thread info ->cpu, updated by
> set_task_cpu(). The *_move_tasks seems to be responsible for calling
> can_migrate_task() to see if, in a deferred way, the migration_thread
> can use set_task_cpu() to change the task's cpu.

Hmm. Perhaps I missed something, perhaps you... Or we both :)

try_to_wake_up() can choose new_cpu which differs from initial ->cpu.
Then it does set_task_cpu() which just sets ->cpu, it doesn't check
can_migrate_task(). This means that the task could be waken on another
CPU, even if it sleeps under migration_disable().


Btw, I think you should also fix debug_smp_processor_id(), it won't
like  migration_disable() + __get_cpu_var().

Oleg.

