Return-Path: <linux-kernel-owner+w=401wt.eu-S1758138AbYGIPsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758138AbYGIPsR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 11:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754732AbYGIPsD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 11:48:03 -0400
Received: from tomts16.bellnexxia.net ([209.226.175.4]:58479 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754228AbYGIPsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 11:48:01 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApwEAHN4dEhMQWVt/2dsb2JhbACBW49Yny0
Date: Wed, 9 Jul 2008 11:47:53 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Message-ID: <20080709154753.GA9899@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bcc: 
Subject: Re: [patch 05/15] LTTng instrumentation - scheduler (repost)
Reply-To: 
In-Reply-To: <20080709153434.GA9186@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:46:04 up 34 days, 20:27,  4 users,  load average: 2.95, 2.43,
	2.46

Hi Peter,

I noticed that my tracepoints are not exactly at the same location as
the trace_mark you have added for ftrace and that I do not pass the "rq"
parameter.  Should I change my patch to follow what you have in
linux-next ?

Mathieu

* Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> There were 2 rejects when I ported the patch to linux-next. Sorry. Here
> is a repost.
> 
> 
> Instrument the scheduler activity (sched_switch, migration, wakeups, wait for a
> task, signal delivery) and process/thread creation/destruction (fork, exit,
> kthread stop). Actually, kthread creation is not instrumented in this patch
> because it is architecture dependent. It allows to connect tracers such as
> ftrace which detects scheduling latencies, good/bad scheduler decisions. Tools
> like LTTng can export this scheduler information along with instrumentation of
> the rest of the kernel activity to perform post-mortem analysis on the scheduler
> activity.
> 
> About the performance impact of tracepoints (which is comparable to markers),
> even without immediate values optimizations, tests done by Hideo Aoki on ia64
> show no regression. His test case was using hackbench on a kernel where
> scheduler instrumentation (about 5 events in code scheduler code) was added.
> See the "Tracepoints" patch header for performance result detail.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> CC: 'Peter Zijlstra' <peterz@infradead.org>
> CC: 'Steven Rostedt' <rostedt@goodmis.org>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Masami Hiramatsu <mhiramat@redhat.com>
> CC: "Frank Ch. Eigler" <fche@redhat.com>
> CC: 'Ingo Molnar' <mingo@elte.hu>
> CC: 'Hideo AOKI' <haoki@redhat.com>
> CC: Takashi Nishiie <t-nishiie@np.css.fujitsu.com>
> CC: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
> ---
>  kernel/exit.c        |    6 ++++++
>  kernel/fork.c        |    3 +++
>  kernel/kthread.c     |    5 +++++
>  kernel/sched-trace.h |   43 +++++++++++++++++++++++++++++++++++++++++++
>  kernel/sched.c       |   11 ++++++-----
>  kernel/signal.c      |    3 +++
>  6 files changed, 66 insertions(+), 5 deletions(-)
> 
> Index: linux-2.6-lttng/kernel/kthread.c
> ===================================================================
> --- linux-2.6-lttng.orig/kernel/kthread.c	2008-07-09 11:27:01.000000000 -0400
> +++ linux-2.6-lttng/kernel/kthread.c	2008-07-09 11:27:08.000000000 -0400
> @@ -13,6 +13,7 @@
>  #include <linux/file.h>
>  #include <linux/module.h>
>  #include <linux/mutex.h>
> +#include "sched-trace.h"
>  
>  #define KTHREAD_NICE_LEVEL (-5)
>  
> @@ -187,6 +188,8 @@ int kthread_stop(struct task_struct *k)
>  	/* It could exit after stop_info.k set, but before wake_up_process. */
>  	get_task_struct(k);
>  
> +	trace_sched_kthread_stop(k);
> +
>  	/* Must init completion *before* thread sees kthread_stop_info.k */
>  	init_completion(&kthread_stop_info.done);
>  	smp_wmb();
> @@ -202,6 +205,8 @@ int kthread_stop(struct task_struct *k)
>  	ret = kthread_stop_info.err;
>  	mutex_unlock(&kthread_stop_lock);
>  
> +	trace_sched_kthread_stop_ret(ret);
> +
>  	return ret;
>  }
>  EXPORT_SYMBOL(kthread_stop);
> Index: linux-2.6-lttng/kernel/sched.c
> ===================================================================
> --- linux-2.6-lttng.orig/kernel/sched.c	2008-07-09 11:27:01.000000000 -0400
> +++ linux-2.6-lttng/kernel/sched.c	2008-07-09 11:27:56.000000000 -0400
> @@ -71,6 +71,7 @@
>  #include <linux/debugfs.h>
>  #include <linux/ctype.h>
>  #include <linux/ftrace.h>
> +#include "sched-trace.h"
>  
>  #include <asm/tlb.h>
>  #include <asm/irq_regs.h>
> @@ -1987,6 +1988,7 @@ void wait_task_inactive(struct task_stru
>  		 * just go back and repeat.
>  		 */
>  		rq = task_rq_lock(p, &flags);
> +		trace_sched_wait_task(p);
>  		running = task_running(rq, p);
>  		on_rq = p->se.on_rq;
>  		task_rq_unlock(rq, &flags);
> @@ -2275,6 +2277,7 @@ static int try_to_wake_up(struct task_st
>  
>  	smp_wmb();
>  	rq = task_rq_lock(p, &flags);
> +	trace_sched_try_wakeup(p);
>  	old_state = p->state;
>  	if (!(old_state & state))
>  		goto out;
> @@ -2457,6 +2460,7 @@ void wake_up_new_task(struct task_struct
>  	struct rq *rq;
>  
>  	rq = task_rq_lock(p, &flags);
> +	trace_sched_wakeup_new_task(p);
>  	BUG_ON(p->state != TASK_RUNNING);
>  	update_rq_clock(rq);
>  
> @@ -2647,11 +2651,7 @@ context_switch(struct rq *rq, struct tas
>  	struct mm_struct *mm, *oldmm;
>  
>  	prepare_task_switch(rq, prev, next);
> -	trace_mark(kernel_sched_schedule,
> -		"prev_pid %d next_pid %d prev_state %ld "
> -		"## rq %p prev %p next %p",
> -		prev->pid, next->pid, prev->state,
> -		rq, prev, next);
> +	trace_sched_switch(prev, next);
>  	mm = next->mm;
>  	oldmm = prev->active_mm;
>  	/*
> @@ -2884,6 +2884,7 @@ static void sched_migrate_task(struct ta
>  	    || unlikely(cpu_is_offline(dest_cpu)))
>  		goto out;
>  
> +	trace_sched_migrate_task(p, dest_cpu);
>  	/* force the process onto the specified CPU */
>  	if (migrate_task(p, dest_cpu, &req)) {
>  		/* Need to wait for migration thread (might exit: take ref). */
> Index: linux-2.6-lttng/kernel/exit.c
> ===================================================================
> --- linux-2.6-lttng.orig/kernel/exit.c	2008-07-09 11:27:01.000000000 -0400
> +++ linux-2.6-lttng/kernel/exit.c	2008-07-09 11:27:08.000000000 -0400
> @@ -46,6 +46,7 @@
>  #include <linux/resource.h>
>  #include <linux/blkdev.h>
>  #include <linux/task_io_accounting_ops.h>
> +#include "sched-trace.h"
>  
>  #include <asm/uaccess.h>
>  #include <asm/unistd.h>
> @@ -149,6 +150,7 @@ static void __exit_signal(struct task_st
>  
>  static void delayed_put_task_struct(struct rcu_head *rhp)
>  {
> +	trace_sched_process_free(container_of(rhp, struct task_struct, rcu));
>  	put_task_struct(container_of(rhp, struct task_struct, rcu));
>  }
>  
> @@ -1040,6 +1042,8 @@ NORET_TYPE void do_exit(long code)
>  
>  	if (group_dead)
>  		acct_process();
> +	trace_sched_process_exit(tsk);
> +
>  	exit_sem(tsk);
>  	exit_files(tsk);
>  	exit_fs(tsk);
> @@ -1524,6 +1528,8 @@ static long do_wait(enum pid_type type, 
>  	struct task_struct *tsk;
>  	int flag, retval;
>  
> +	trace_sched_process_wait(pid);
> +
>  	add_wait_queue(&current->signal->wait_chldexit,&wait);
>  repeat:
>  	/* If there is nothing that can match our critier just get out */
> Index: linux-2.6-lttng/kernel/fork.c
> ===================================================================
> --- linux-2.6-lttng.orig/kernel/fork.c	2008-07-09 11:27:01.000000000 -0400
> +++ linux-2.6-lttng/kernel/fork.c	2008-07-09 11:27:08.000000000 -0400
> @@ -56,6 +56,7 @@
>  #include <linux/proc_fs.h>
>  #include <linux/blkdev.h>
>  #include <linux/magic.h>
> +#include "sched-trace.h"
>  
>  #include <asm/pgtable.h>
>  #include <asm/pgalloc.h>
> @@ -1362,6 +1363,8 @@ long do_fork(unsigned long clone_flags,
>  	if (!IS_ERR(p)) {
>  		struct completion vfork;
>  
> +		trace_sched_process_fork(current, p);
> +
>  		nr = task_pid_vnr(p);
>  
>  		if (clone_flags & CLONE_PARENT_SETTID)
> Index: linux-2.6-lttng/kernel/signal.c
> ===================================================================
> --- linux-2.6-lttng.orig/kernel/signal.c	2008-07-09 11:25:24.000000000 -0400
> +++ linux-2.6-lttng/kernel/signal.c	2008-07-09 11:27:08.000000000 -0400
> @@ -26,6 +26,7 @@
>  #include <linux/freezer.h>
>  #include <linux/pid_namespace.h>
>  #include <linux/nsproxy.h>
> +#include "sched-trace.h"
>  
>  #include <asm/param.h>
>  #include <asm/uaccess.h>
> @@ -807,6 +808,8 @@ static int send_signal(int sig, struct s
>  	struct sigpending *pending;
>  	struct sigqueue *q;
>  
> +	trace_sched_signal_send(sig, t);
> +
>  	assert_spin_locked(&t->sighand->siglock);
>  	if (!prepare_signal(sig, t))
>  		return 0;
> Index: linux-2.6-lttng/kernel/sched-trace.h
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6-lttng/kernel/sched-trace.h	2008-07-09 11:27:08.000000000 -0400
> @@ -0,0 +1,43 @@
> +#ifndef _SCHED_TRACE_H
> +#define _SCHED_TRACE_H
> +
> +#include <linux/tracepoint.h>
> +
> +DEFINE_TRACE(sched_kthread_stop,
> +	TPPROTO(struct task_struct *t),
> +	TPARGS(t));
> +DEFINE_TRACE(sched_kthread_stop_ret,
> +	TPPROTO(int ret),
> +	TPARGS(ret));
> +DEFINE_TRACE(sched_wait_task,
> +	TPPROTO(struct task_struct *p),
> +	TPARGS(p));
> +DEFINE_TRACE(sched_try_wakeup,
> +	TPPROTO(struct task_struct *p),
> +	TPARGS(p));
> +DEFINE_TRACE(sched_wakeup_new_task,
> +	TPPROTO(struct task_struct *p),
> +	TPARGS(p));
> +DEFINE_TRACE(sched_switch,
> +	TPPROTO(struct task_struct *prev, struct task_struct *next),
> +	TPARGS(prev, next));
> +DEFINE_TRACE(sched_migrate_task,
> +	TPPROTO(struct task_struct *p, int dest_cpu),
> +	TPARGS(p, dest_cpu));
> +DEFINE_TRACE(sched_process_free,
> +	TPPROTO(struct task_struct *p),
> +	TPARGS(p));
> +DEFINE_TRACE(sched_process_exit,
> +	TPPROTO(struct task_struct *p),
> +	TPARGS(p));
> +DEFINE_TRACE(sched_process_wait,
> +	TPPROTO(struct pid *pid),
> +	TPARGS(pid));
> +DEFINE_TRACE(sched_process_fork,
> +	TPPROTO(struct task_struct *parent, struct task_struct *child),
> +	TPARGS(parent, child));
> +DEFINE_TRACE(sched_signal_send,
> +	TPPROTO(int sig, struct task_struct *p),
> +	TPARGS(sig, p));
> +
> +#endif
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
