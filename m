Return-Path: <linux-kernel-owner+w=401wt.eu-S1759222AbYGPOTM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759222AbYGPOTM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 10:19:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756910AbYGPOS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 10:18:57 -0400
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:62698 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756768AbYGPOS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 10:18:56 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtUEAM+afUhMRKxB/2dsb2JhbACBWa8b
Date: Wed, 16 Jul 2008 10:18:52 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <peterz@infradead.org>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Frank Ch. Eigler" <fche@redhat.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [patch 06/17] LTTng instrumentation - scheduler
Message-ID: <20080716141852.GB24546@Krystal>
References: <20080715222604.331269462@polymtl.ca> <20080715222747.290133980@polymtl.ca> <1216197058.5232.17.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1216197058.5232.17.camel@twins>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:37:50 up 41 days, 18:18,  5 users,  load average: 0.55, 0.80,
	0.77
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Tue, 2008-07-15 at 18:26 -0400, Mathieu Desnoyers wrote:
> > plain text document attachment (lttng-instrumentation-scheduler.patch)
> > Instrument the scheduler activity (sched_switch, migration, wakeups, wait for a
> > task, signal delivery) and process/thread creation/destruction (fork, exit,
> > kthread stop). Actually, kthread creation is not instrumented in this patch
> > because it is architecture dependent. It allows to connect tracers such as
> > ftrace which detects scheduling latencies, good/bad scheduler decisions. Tools
> > like LTTng can export this scheduler information along with instrumentation of
> > the rest of the kernel activity to perform post-mortem analysis on the scheduler
> > activity.
> > 
> > About the performance impact of tracepoints (which is comparable to markers),
> > even without immediate values optimizations, tests done by Hideo Aoki on ia64
> > show no regression. His test case was using hackbench on a kernel where
> > scheduler instrumentation (about 5 events in code scheduler code) was added.
> > See the "Tracepoints" patch header for performance result detail.
> > 
> > Changelog :
> > - Change instrumentation location and parameter to match ftrace instrumentation,
> >   previously done with kernel markers.
> > 
> > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> > CC: 'Peter Zijlstra' <peterz@infradead.org>
> > CC: 'Steven Rostedt' <rostedt@goodmis.org>
> > CC: Thomas Gleixner <tglx@linutronix.de>
> > CC: Masami Hiramatsu <mhiramat@redhat.com>
> > CC: "Frank Ch. Eigler" <fche@redhat.com>
> > CC: 'Ingo Molnar' <mingo@elte.hu>
> > CC: 'Hideo AOKI' <haoki@redhat.com>
> > CC: Takashi Nishiie <t-nishiie@np.css.fujitsu.com>
> > CC: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
> > ---
> >  include/trace/sched.h |   45 +++++++++++++++++++++++++++++++++++++++++++++
> >  kernel/exit.c         |    6 ++++++
> >  kernel/fork.c         |    3 +++
> >  kernel/kthread.c      |    5 +++++
> >  kernel/sched.c        |   17 ++++++-----------
> >  kernel/signal.c       |    3 +++
> >  6 files changed, 68 insertions(+), 11 deletions(-)
> > 
> > Index: linux-2.6-lttng/kernel/kthread.c
> > ===================================================================
> > --- linux-2.6-lttng.orig/kernel/kthread.c	2008-07-15 14:51:49.000000000 -0400
> > +++ linux-2.6-lttng/kernel/kthread.c	2008-07-15 15:12:54.000000000 -0400
> > @@ -13,6 +13,7 @@
> >  #include <linux/file.h>
> >  #include <linux/module.h>
> >  #include <linux/mutex.h>
> > +#include <trace/sched.h>
> >  
> >  #define KTHREAD_NICE_LEVEL (-5)
> >  
> > @@ -187,6 +188,8 @@ int kthread_stop(struct task_struct *k)
> >  	/* It could exit after stop_info.k set, but before wake_up_process. */
> >  	get_task_struct(k);
> >  
> > +	trace_sched_kthread_stop(k);
> > +
> >  	/* Must init completion *before* thread sees kthread_stop_info.k */
> >  	init_completion(&kthread_stop_info.done);
> >  	smp_wmb();
> > @@ -202,6 +205,8 @@ int kthread_stop(struct task_struct *k)
> >  	ret = kthread_stop_info.err;
> >  	mutex_unlock(&kthread_stop_lock);
> >  
> > +	trace_sched_kthread_stop_ret(ret);
> > +
> >  	return ret;
> >  }
> >  EXPORT_SYMBOL(kthread_stop);
> 
> Why do we need two trace points in this function?
> 

As of my understanding, if we look at the complete function :

int kthread_stop(struct task_struct *k)
{
        int ret;

        mutex_lock(&kthread_stop_lock);

        /* It could exit after stop_info.k set, but before wake_up_process. */
        get_task_struct(k);

        trace_sched_kthread_stop(k);

        /* Must init completion *before* thread sees kthread_stop_info.k */
        init_completion(&kthread_stop_info.done);
        smp_wmb();

        /* Now set kthread_should_stop() to true, and wake it up. */
        kthread_stop_info.k = k;
        wake_up_process(k);
        put_task_struct(k);

--> starting from this point, k can be freed by the thread being stopped
and exiting. Therefore, if we want an identifier about the thread about
to stop, we have to instrument before this point.

        /* Once it dies, reset stop ptr, gather result and we're done. */
        wait_for_completion(&kthread_stop_info.done);
        kthread_stop_info.k = NULL;
        ret = kthread_stop_info.err;
        mutex_unlock(&kthread_stop_lock);

        trace_sched_kthread_stop_ret(ret);

---> the success of this operation is only known after "ret" is
assigned. So this is why I couldn't find one tracepoint to have both
valid "k" and "ret" at the same time.

        return ret;
}


> > Index: linux-2.6-lttng/kernel/sched.c
> > ===================================================================
> > --- linux-2.6-lttng.orig/kernel/sched.c	2008-07-15 14:51:50.000000000 -0400
> > +++ linux-2.6-lttng/kernel/sched.c	2008-07-15 15:13:49.000000000 -0400
> > @@ -71,6 +71,7 @@
> >  #include <linux/debugfs.h>
> >  #include <linux/ctype.h>
> >  #include <linux/ftrace.h>
> > +#include <trace/sched.h>
> >  
> >  #include <asm/tlb.h>
> >  #include <asm/irq_regs.h>
> > @@ -1987,6 +1988,7 @@ void wait_task_inactive(struct task_stru
> >  		 * just go back and repeat.
> >  		 */
> >  		rq = task_rq_lock(p, &flags);
> > +		trace_sched_wait_task(rq, p);
> >  		running = task_running(rq, p);
> >  		on_rq = p->se.on_rq;
> >  		task_rq_unlock(rq, &flags);
> > @@ -2337,9 +2339,7 @@ out_activate:
> >  	success = 1;
> >  
> >  out_running:
> > -	trace_mark(kernel_sched_wakeup,
> > -		"pid %d state %ld ## rq %p task %p rq->curr %p",
> > -		p->pid, p->state, rq, p, rq->curr);
> > +	trace_sched_wakeup(rq, p);
> >  	check_preempt_curr(rq, p);
> >  
> >  	p->state = TASK_RUNNING;
> > @@ -2472,9 +2472,7 @@ void wake_up_new_task(struct task_struct
> >  		p->sched_class->task_new(rq, p);
> >  		inc_nr_running(rq);
> >  	}
> > -	trace_mark(kernel_sched_wakeup_new,
> > -		"pid %d state %ld ## rq %p task %p rq->curr %p",
> > -		p->pid, p->state, rq, p, rq->curr);
> > +	trace_sched_wakeup_new(rq, p);
> >  	check_preempt_curr(rq, p);
> >  #ifdef CONFIG_SMP
> >  	if (p->sched_class->task_wake_up)
> > @@ -2647,11 +2645,7 @@ context_switch(struct rq *rq, struct tas
> >  	struct mm_struct *mm, *oldmm;
> >  
> >  	prepare_task_switch(rq, prev, next);
> > -	trace_mark(kernel_sched_schedule,
> > -		"prev_pid %d next_pid %d prev_state %ld "
> > -		"## rq %p prev %p next %p",
> > -		prev->pid, next->pid, prev->state,
> > -		rq, prev, next);
> > +	trace_sched_switch(rq, prev, next);
> >  	mm = next->mm;
> >  	oldmm = prev->active_mm;
> >  	/*
> > @@ -2884,6 +2878,7 @@ static void sched_migrate_task(struct ta
> >  	    || unlikely(cpu_is_offline(dest_cpu)))
> >  		goto out;
> >  
> > +	trace_sched_migrate_task(rq, p, dest_cpu);
> >  	/* force the process onto the specified CPU */
> >  	if (migrate_task(p, dest_cpu, &req)) {
> >  		/* Need to wait for migration thread (might exit: take ref). */
> > Index: linux-2.6-lttng/kernel/exit.c
> > ===================================================================
> > --- linux-2.6-lttng.orig/kernel/exit.c	2008-07-15 14:51:49.000000000 -0400
> > +++ linux-2.6-lttng/kernel/exit.c	2008-07-15 15:12:54.000000000 -0400
> > @@ -46,6 +46,7 @@
> >  #include <linux/resource.h>
> >  #include <linux/blkdev.h>
> >  #include <linux/task_io_accounting_ops.h>
> > +#include <trace/sched.h>
> >  
> >  #include <asm/uaccess.h>
> >  #include <asm/unistd.h>
> > @@ -149,6 +150,7 @@ static void __exit_signal(struct task_st
> >  
> >  static void delayed_put_task_struct(struct rcu_head *rhp)
> >  {
> > +	trace_sched_process_free(container_of(rhp, struct task_struct, rcu));
> >  	put_task_struct(container_of(rhp, struct task_struct, rcu));
> >  }
> 
> It might make sense to write it like:
> 
> static void delayed_put_task_struct(struct rcu_head *rhp)
> {
> 	struct task_struct *tsk = container_of(rhp, struct task_struct, rcu);
> 
> 	trace_sched_process_free(tsk);
> 	put_task_struct(tsk);
> }
> 

Yep, will fix.

> > @@ -1040,6 +1042,8 @@ NORET_TYPE void do_exit(long code)
> >  
> >  	if (group_dead)
> >  		acct_process();
> > +	trace_sched_process_exit(tsk);
> > +
> >  	exit_sem(tsk);
> >  	exit_files(tsk);
> >  	exit_fs(tsk);
> > @@ -1524,6 +1528,8 @@ static long do_wait(enum pid_type type, 
> >  	struct task_struct *tsk;
> >  	int flag, retval;
> >  
> > +	trace_sched_process_wait(pid);
> > +
> >  	add_wait_queue(&current->signal->wait_chldexit,&wait);
> >  repeat:
> >  	/* If there is nothing that can match our critier just get out */
> > Index: linux-2.6-lttng/kernel/fork.c
> > ===================================================================
> > --- linux-2.6-lttng.orig/kernel/fork.c	2008-07-15 14:51:49.000000000 -0400
> > +++ linux-2.6-lttng/kernel/fork.c	2008-07-15 15:14:23.000000000 -0400
> > @@ -56,6 +56,7 @@
> >  #include <linux/proc_fs.h>
> >  #include <linux/blkdev.h>
> >  #include <linux/magic.h>
> > +#include <trace/sched.h>
> >  
> >  #include <asm/pgtable.h>
> >  #include <asm/pgalloc.h>
> > @@ -1362,6 +1363,8 @@ long do_fork(unsigned long clone_flags,
> >  	if (!IS_ERR(p)) {
> >  		struct completion vfork;
> >  
> > +		trace_sched_process_fork(current, p);
> > +
> >  		nr = task_pid_vnr(p);
> >  
> >  		if (clone_flags & CLONE_PARENT_SETTID)
> > Index: linux-2.6-lttng/kernel/signal.c
> > ===================================================================
> > --- linux-2.6-lttng.orig/kernel/signal.c	2008-07-15 14:49:14.000000000 -0400
> > +++ linux-2.6-lttng/kernel/signal.c	2008-07-15 15:12:54.000000000 -0400
> > @@ -26,6 +26,7 @@
> >  #include <linux/freezer.h>
> >  #include <linux/pid_namespace.h>
> >  #include <linux/nsproxy.h>
> > +#include <trace/sched.h>
> >  
> >  #include <asm/param.h>
> >  #include <asm/uaccess.h>
> > @@ -807,6 +808,8 @@ static int send_signal(int sig, struct s
> >  	struct sigpending *pending;
> >  	struct sigqueue *q;
> >  
> > +	trace_sched_signal_send(sig, t);
> > +
> >  	assert_spin_locked(&t->sighand->siglock);
> >  	if (!prepare_signal(sig, t))
> >  		return 0;
> 
> Would it make sense to also put a trace point on receiveing a signal?
> 
> /me utterly clueless about the whole signal stuff.
> 

When the signal is sent, it is added to the pending signal list of the
target process. Unless the process blocks the signal, its TIF_SIGPENDING
thread flag is set and the process (actually, all threads in the
process) is then woken up. If signals are blocked by that process, it
will set its own TIF_SIGPENDING flag when it unblocks the signals.
recalc_sigpending() as well as a few other code paths) set/clear the
thread flag TIF_SIGPENDING which controls delivery of signals on
interrupt, trap and syscall return paths to userspace.

When TIF_SIGPENDING is set, do_signal(regs) is called. It is
architecture specific (I'm currently looking at x86_32). It delivers the
signal by calling the arch-specific handle_signal().

So I think that handle_signal() could be an interesting function to
instrument within each architecture to know exactly when the signal
stack is setup. However, since we are currently discussing
architecture-independent instrumentation, instrumenting all

  set_tsk_thread_flag(p, TIF_SIGPENDING);

statements would be good to learn whenever the signal is being seen by
the target process.

Since this thread flag is set at 3 locations in signal.c, putting a
wrapper around set_tsk_thread_flag(t, TIF_SIGPENDING); and inserting a
tracepoint with each call could make sense.

But we can also decide that knowing when a signal is sent is enough,
and that by simply inserting the correct architecture-specific
instrumentation we learn when the signal is delivered...

Mathieu

> > Index: linux-2.6-lttng/include/trace/sched.h
> > ===================================================================
> > --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> > +++ linux-2.6-lttng/include/trace/sched.h	2008-07-15 15:12:54.000000000 -0400
> > @@ -0,0 +1,45 @@
> > +#ifndef _TRACE_SCHED_H
> > +#define _TRACE_SCHED_H
> > +
> > +#include <linux/sched.h>
> > +#include <linux/tracepoint.h>
> > +
> > +DEFINE_TRACE(sched_kthread_stop,
> > +	TPPROTO(struct task_struct *t),
> > +	TPARGS(t));
> > +DEFINE_TRACE(sched_kthread_stop_ret,
> > +	TPPROTO(int ret),
> > +	TPARGS(ret));
> > +DEFINE_TRACE(sched_wait_task,
> > +	TPPROTO(struct rq *rq, struct task_struct *p),
> > +	TPARGS(rq, p));
> > +DEFINE_TRACE(sched_wakeup,
> > +	TPPROTO(struct rq *rq, struct task_struct *p),
> > +	TPARGS(rq, p));
> > +DEFINE_TRACE(sched_wakeup_new,
> > +	TPPROTO(struct rq *rq, struct task_struct *p),
> > +	TPARGS(rq, p));
> > +DEFINE_TRACE(sched_switch,
> > +	TPPROTO(struct rq *rq, struct task_struct *prev,
> > +		struct task_struct *next),
> > +	TPARGS(rq, prev, next));
> > +DEFINE_TRACE(sched_migrate_task,
> > +	TPPROTO(struct rq *rq, struct task_struct *p, int dest_cpu),
> > +	TPARGS(rq, p, dest_cpu));
> > +DEFINE_TRACE(sched_process_free,
> > +	TPPROTO(struct task_struct *p),
> > +	TPARGS(p));
> > +DEFINE_TRACE(sched_process_exit,
> > +	TPPROTO(struct task_struct *p),
> > +	TPARGS(p));
> > +DEFINE_TRACE(sched_process_wait,
> > +	TPPROTO(struct pid *pid),
> > +	TPARGS(pid));
> > +DEFINE_TRACE(sched_process_fork,
> > +	TPPROTO(struct task_struct *parent, struct task_struct *child),
> > +	TPARGS(parent, child));
> > +DEFINE_TRACE(sched_signal_send,
> > +	TPPROTO(int sig, struct task_struct *p),
> > +	TPARGS(sig, p));
> > +
> > +#endif
> > 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
