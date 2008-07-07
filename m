Return-Path: <linux-kernel-owner+w=401wt.eu-S1754213AbYGGQjE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213AbYGGQjE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 12:39:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755494AbYGGQiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 12:38:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41066 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756006AbYGGQis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 12:38:48 -0400
Message-ID: <48724626.4080505@redhat.com>
Date: Mon, 07 Jul 2008 12:36:54 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>
Subject: Re: [RFC patch 04/12] LTTng instrumentation kernel
References: <20080704235207.147809973@polymtl.ca> <20080704235425.294187583@polymtl.ca>
In-Reply-To: <20080704235425.294187583@polymtl.ca>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> Core kernel events.
> 
> *not* present in this patch because they are architecture specific :
> - syscall entry/exit
> - traps
> - kernel thread creation
> 
> Added markers :
> 
> kernel_irq_entry
> kernel_irq_exit
> kernel_kthread_stop
> kernel_kthread_stop_ret
> kernel_module_free
> kernel_module_load
> kernel_printk
> kernel_process_exit
> kernel_process_fork
> kernel_process_free
> kernel_process_wait
> kernel_sched_migrate_task
> kernel_sched_schedule
> kernel_sched_try_wakeup
> kernel_sched_wait_task
> kernel_sched_wakeup_new_task
> kernel_send_signal
> kernel_softirq_entry
> kernel_softirq_exit
> kernel_softirq_raise
> kernel_tasklet_high_entry
> kernel_tasklet_high_exit
> kernel_tasklet_low_entry
> kernel_tasklet_low_exit
> kernel_timer_itimer_expired
> kernel_timer_itimer_set
> kernel_timer_set
> kernel_timer_timeout
> kernel_timer_update_time
> kernel_vprintk

Hi Mathieu,
I think this patch covers too many subsystems someone to give you ack.
I know these essential events are very important for tracers,
but it is hard to ack it for each subsystem developer.

I think you need to split it into a series of patches, for example,

irq tracepoints:
> kernel_irq_entry
> kernel_irq_exit
> kernel_softirq_entry
> kernel_softirq_exit
> kernel_softirq_raise
> kernel_tasklet_high_entry
> kernel_tasklet_high_exit
> kernel_tasklet_low_entry
> kernel_tasklet_low_exit

scheduler tracepoints:
> kernel_kthread_stop
> kernel_kthread_stop_ret
> kernel_sched_migrate_task
> kernel_sched_schedule
> kernel_sched_try_wakeup
> kernel_sched_wait_task
> kernel_sched_wakeup_new_task
> kernel_process_exit
> kernel_process_fork
> kernel_process_free
> kernel_process_wait
> kernel_send_signal

timer tracepoints:
> kernel_timer_itimer_expired
> kernel_timer_itimer_set
> kernel_timer_set
> kernel_timer_timeout
> kernel_timer_update_time

misc tracepoints:
> kernel_module_free
> kernel_module_load
> kernel_printk
> kernel_vprintk

On the other hand, if you do that, you'd better use DEFINE_TRACE()
in each subsystem's header, instead of kernel-trace.h.

Thank you,

> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> CC: 'Peter Zijlstra' <peterz@infradead.org>
> CC: "Frank Ch. Eigler" <fche@redhat.com>
> CC: 'Ingo Molnar' <mingo@elte.hu>
> CC: 'Hideo AOKI' <haoki@redhat.com>
> CC: Takashi Nishiie <t-nishiie@np.css.fujitsu.com>
> CC: 'Steven Rostedt' <rostedt@goodmis.org>
> CC: Masami Hiramatsu <mhiramat@redhat.com>
> ---
>  kernel/exit.c         |    6 ++
>  kernel/fork.c         |    3 +
>  kernel/irq/handle.c   |    6 ++
>  kernel/itimer.c       |    5 ++
>  kernel/kernel-trace.h |  106 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  kernel/kthread.c      |    5 ++
>  kernel/module.c       |    5 ++
>  kernel/printk.c       |    5 ++
>  kernel/sched.c        |    6 ++
>  kernel/signal.c       |    3 +
>  kernel/softirq.c      |    8 +++
>  kernel/timer.c        |    8 +++
>  12 files changed, 165 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6-lttng/kernel/irq/handle.c
> ===================================================================
> --- linux-2.6-lttng.orig/kernel/irq/handle.c	2008-07-04 16:59:29.000000000 -0400
> +++ linux-2.6-lttng/kernel/irq/handle.c	2008-07-04 17:38:16.000000000 -0400
> @@ -15,6 +15,7 @@
>  #include <linux/random.h>
>  #include <linux/interrupt.h>
>  #include <linux/kernel_stat.h>
> +#include "../kernel-trace.h"
>  
>  #include "internals.h"
>  
> @@ -130,6 +131,9 @@ irqreturn_t handle_IRQ_event(unsigned in
>  {
>  	irqreturn_t ret, retval = IRQ_NONE;
>  	unsigned int status = 0;
> +	struct pt_regs *regs = get_irq_regs();
> +
> +	trace_kernel_irq_entry(irq, regs);
>  
>  	handle_dynamic_tick(action);
>  
> @@ -148,6 +152,8 @@ irqreturn_t handle_IRQ_event(unsigned in
>  		add_interrupt_randomness(irq);
>  	local_irq_disable();
>  
> +	trace_kernel_irq_exit();
> +
>  	return retval;
>  }
>  
> Index: linux-2.6-lttng/kernel/itimer.c
> ===================================================================
> --- linux-2.6-lttng.orig/kernel/itimer.c	2008-07-04 16:59:29.000000000 -0400
> +++ linux-2.6-lttng/kernel/itimer.c	2008-07-04 17:38:16.000000000 -0400
> @@ -12,6 +12,7 @@
>  #include <linux/time.h>
>  #include <linux/posix-timers.h>
>  #include <linux/hrtimer.h>
> +#include "kernel-trace.h"
>  
>  #include <asm/uaccess.h>
>  
> @@ -132,6 +133,8 @@ enum hrtimer_restart it_real_fn(struct h
>  	struct signal_struct *sig =
>  		container_of(timer, struct signal_struct, real_timer);
>  
> +	trace_kernel_timer_itimer_expired(sig);
> +
>  	kill_pid_info(SIGALRM, SEND_SIG_PRIV, sig->leader_pid);
>  
>  	return HRTIMER_NORESTART;
> @@ -157,6 +160,8 @@ int do_setitimer(int which, struct itime
>  	    !timeval_valid(&value->it_interval))
>  		return -EINVAL;
>  
> +	trace_kernel_timer_itimer_set(which, value);
> +
>  	switch (which) {
>  	case ITIMER_REAL:
>  again:
> Index: linux-2.6-lttng/kernel/kthread.c
> ===================================================================
> --- linux-2.6-lttng.orig/kernel/kthread.c	2008-07-04 16:59:29.000000000 -0400
> +++ linux-2.6-lttng/kernel/kthread.c	2008-07-04 17:38:16.000000000 -0400
> @@ -13,6 +13,7 @@
>  #include <linux/file.h>
>  #include <linux/module.h>
>  #include <linux/mutex.h>
> +#include "kernel-trace.h"
>  
>  #define KTHREAD_NICE_LEVEL (-5)
>  
> @@ -205,6 +206,8 @@ int kthread_stop(struct task_struct *k)
>  	/* It could exit after stop_info.k set, but before wake_up_process. */
>  	get_task_struct(k);
>  
> +	trace_kernel_kthread_stop(k);
> +
>  	/* Must init completion *before* thread sees kthread_stop_info.k */
>  	init_completion(&kthread_stop_info.done);
>  	smp_wmb();
> @@ -220,6 +223,8 @@ int kthread_stop(struct task_struct *k)
>  	ret = kthread_stop_info.err;
>  	mutex_unlock(&kthread_stop_lock);
>  
> +	trace_kernel_kthread_stop_ret(ret);
> +
>  	return ret;
>  }
>  EXPORT_SYMBOL(kthread_stop);
> Index: linux-2.6-lttng/kernel/printk.c
> ===================================================================
> --- linux-2.6-lttng.orig/kernel/printk.c	2008-07-04 16:59:29.000000000 -0400
> +++ linux-2.6-lttng/kernel/printk.c	2008-07-04 17:38:16.000000000 -0400
> @@ -32,6 +32,7 @@
>  #include <linux/security.h>
>  #include <linux/bootmem.h>
>  #include <linux/syscalls.h>
> +#include "kernel-trace.h"
>  
>  #include <asm/uaccess.h>
>  
> @@ -610,6 +611,7 @@ asmlinkage int printk(const char *fmt, .
>  	int r;
>  
>  	va_start(args, fmt);
> +	trace_kernel_printk(__builtin_return_address(0));
>  	r = vprintk(fmt, args);
>  	va_end(args);
>  
> @@ -687,6 +689,9 @@ asmlinkage int vprintk(const char *fmt, 
>  	raw_local_irq_save(flags);
>  	this_cpu = smp_processor_id();
>  
> +	trace_kernel_vprintk(__builtin_return_address(0),
> +		printk_buf, printed_len);
> +
>  	/*
>  	 * Ouch, printk recursed into itself!
>  	 */
> Index: linux-2.6-lttng/kernel/sched.c
> ===================================================================
> --- linux-2.6-lttng.orig/kernel/sched.c	2008-07-04 16:59:29.000000000 -0400
> +++ linux-2.6-lttng/kernel/sched.c	2008-07-04 17:38:16.000000000 -0400
> @@ -70,6 +70,7 @@
>  #include <linux/bootmem.h>
>  #include <linux/debugfs.h>
>  #include <linux/ctype.h>
> +#include "kernel-trace.h"
>  
>  #include <asm/tlb.h>
>  #include <asm/irq_regs.h>
> @@ -1806,6 +1807,7 @@ void wait_task_inactive(struct task_stru
>  		 * just go back and repeat.
>  		 */
>  		rq = task_rq_lock(p, &flags);
> +		trace_kernel_sched_wait_task(p);
>  		running = task_running(rq, p);
>  		on_rq = p->se.on_rq;
>  		task_rq_unlock(rq, &flags);
> @@ -2087,6 +2089,7 @@ static int try_to_wake_up(struct task_st
>  
>  	smp_wmb();
>  	rq = task_rq_lock(p, &flags);
> +	trace_kernel_sched_try_wakeup(p);
>  	old_state = p->state;
>  	if (!(old_state & state))
>  		goto out;
> @@ -2264,6 +2267,7 @@ void wake_up_new_task(struct task_struct
>  	struct rq *rq;
>  
>  	rq = task_rq_lock(p, &flags);
> +	trace_kernel_sched_wakeup_new_task(p);
>  	BUG_ON(p->state != TASK_RUNNING);
>  	update_rq_clock(rq);
>  
> @@ -2451,6 +2455,7 @@ context_switch(struct rq *rq, struct tas
>  	struct mm_struct *mm, *oldmm;
>  
>  	prepare_task_switch(rq, prev, next);
> +	trace_kernel_sched_schedule(prev, next);
>  	mm = next->mm;
>  	oldmm = prev->active_mm;
>  	/*
> @@ -2683,6 +2688,7 @@ static void sched_migrate_task(struct ta
>  	    || unlikely(cpu_is_offline(dest_cpu)))
>  		goto out;
>  
> +	trace_kernel_sched_migrate_task(p, dest_cpu);
>  	/* force the process onto the specified CPU */
>  	if (migrate_task(p, dest_cpu, &req)) {
>  		/* Need to wait for migration thread (might exit: take ref). */
> Index: linux-2.6-lttng/kernel/signal.c
> ===================================================================
> --- linux-2.6-lttng.orig/kernel/signal.c	2008-07-04 16:59:29.000000000 -0400
> +++ linux-2.6-lttng/kernel/signal.c	2008-07-04 17:38:16.000000000 -0400
> @@ -26,6 +26,7 @@
>  #include <linux/freezer.h>
>  #include <linux/pid_namespace.h>
>  #include <linux/nsproxy.h>
> +#include "kernel-trace.h"
>  
>  #include <asm/param.h>
>  #include <asm/uaccess.h>
> @@ -807,6 +808,8 @@ static int send_signal(int sig, struct s
>  	struct sigpending *pending;
>  	struct sigqueue *q;
>  
> +	trace_kernel_signal_send(sig, t);
> +
>  	assert_spin_locked(&t->sighand->siglock);
>  	if (!prepare_signal(sig, t))
>  		return 0;
> Index: linux-2.6-lttng/kernel/softirq.c
> ===================================================================
> --- linux-2.6-lttng.orig/kernel/softirq.c	2008-07-04 16:59:29.000000000 -0400
> +++ linux-2.6-lttng/kernel/softirq.c	2008-07-04 17:38:16.000000000 -0400
> @@ -21,6 +21,7 @@
>  #include <linux/rcupdate.h>
>  #include <linux/smp.h>
>  #include <linux/tick.h>
> +#include "kernel-trace.h"
>  
>  #include <asm/irq.h>
>  /*
> @@ -231,7 +232,9 @@ restart:
>  
>  	do {
>  		if (pending & 1) {
> +			trace_kernel_softirq_entry(h, softirq_vec);
>  			h->action(h);
> +			trace_kernel_softirq_exit(h, softirq_vec);
>  			rcu_bh_qsctr_inc(cpu);
>  		}
>  		h++;
> @@ -323,6 +326,7 @@ void irq_exit(void)
>   */
>  inline void raise_softirq_irqoff(unsigned int nr)
>  {
> +	trace_kernel_softirq_raise(nr);
>  	__raise_softirq_irqoff(nr);
>  
>  	/*
> @@ -412,7 +416,9 @@ static void tasklet_action(struct softir
>  			if (!atomic_read(&t->count)) {
>  				if (!test_and_clear_bit(TASKLET_STATE_SCHED, &t->state))
>  					BUG();
> +				trace_kernel_tasklet_low_entry(t);
>  				t->func(t->data);
> +				trace_kernel_tasklet_low_exit(t);
>  				tasklet_unlock(t);
>  				continue;
>  			}
> @@ -447,7 +453,9 @@ static void tasklet_hi_action(struct sof
>  			if (!atomic_read(&t->count)) {
>  				if (!test_and_clear_bit(TASKLET_STATE_SCHED, &t->state))
>  					BUG();
> +				trace_kernel_tasklet_high_entry(t);
>  				t->func(t->data);
> +				trace_kernel_tasklet_high_exit(t);
>  				tasklet_unlock(t);
>  				continue;
>  			}
> Index: linux-2.6-lttng/kernel/timer.c
> ===================================================================
> --- linux-2.6-lttng.orig/kernel/timer.c	2008-07-04 16:59:29.000000000 -0400
> +++ linux-2.6-lttng/kernel/timer.c	2008-07-04 17:38:16.000000000 -0400
> @@ -37,12 +37,14 @@
>  #include <linux/delay.h>
>  #include <linux/tick.h>
>  #include <linux/kallsyms.h>
> +#include "kernel-trace.h"
>  
>  #include <asm/uaccess.h>
>  #include <asm/unistd.h>
>  #include <asm/div64.h>
>  #include <asm/timex.h>
>  #include <asm/io.h>
> +#include <asm/irq_regs.h>
>  
>  u64 jiffies_64 __cacheline_aligned_in_smp = INITIAL_JIFFIES;
>  
> @@ -288,6 +290,7 @@ static void internal_add_timer(struct tv
>  		i = (expires >> (TVR_BITS + 3 * TVN_BITS)) & TVN_MASK;
>  		vec = base->tv5.vec + i;
>  	}
> +	trace_kernel_timer_set(timer);
>  	/*
>  	 * Timers are FIFO:
>  	 */
> @@ -1074,6 +1077,7 @@ void do_timer(unsigned long ticks)
>  {
>  	jiffies_64 += ticks;
>  	update_times(ticks);
> +	trace_kernel_timer_update_time();
>  }
>  
>  #ifdef __ARCH_WANT_SYS_ALARM
> @@ -1155,7 +1159,9 @@ asmlinkage long sys_getegid(void)
>  
>  static void process_timeout(unsigned long __data)
>  {
> -	wake_up_process((struct task_struct *)__data);
> +	struct task_struct *task = (struct task_struct *)__data;
> +	trace_kernel_timer_timeout(task);
> +	wake_up_process(task);
>  }
>  
>  /**
> Index: linux-2.6-lttng/kernel/exit.c
> ===================================================================
> --- linux-2.6-lttng.orig/kernel/exit.c	2008-07-04 16:59:29.000000000 -0400
> +++ linux-2.6-lttng/kernel/exit.c	2008-07-04 17:38:16.000000000 -0400
> @@ -45,6 +45,7 @@
>  #include <linux/resource.h>
>  #include <linux/blkdev.h>
>  #include <linux/task_io_accounting_ops.h>
> +#include "kernel-trace.h"
>  
>  #include <asm/uaccess.h>
>  #include <asm/unistd.h>
> @@ -148,6 +149,7 @@ static void __exit_signal(struct task_st
>  
>  static void delayed_put_task_struct(struct rcu_head *rhp)
>  {
> +	trace_kernel_process_free(container_of(rhp, struct task_struct, rcu));
>  	put_task_struct(container_of(rhp, struct task_struct, rcu));
>  }
>  
> @@ -1042,6 +1044,8 @@ NORET_TYPE void do_exit(long code)
>  
>  	if (group_dead)
>  		acct_process();
> +	trace_kernel_process_exit(tsk);
> +
>  	exit_sem(tsk);
>  	exit_files(tsk);
>  	exit_fs(tsk);
> @@ -1526,6 +1530,8 @@ static long do_wait(enum pid_type type, 
>  	struct task_struct *tsk;
>  	int flag, retval;
>  
> +	trace_kernel_process_wait(pid);
> +
>  	add_wait_queue(&current->signal->wait_chldexit,&wait);
>  repeat:
>  	/* If there is nothing that can match our critier just get out */
> Index: linux-2.6-lttng/kernel/fork.c
> ===================================================================
> --- linux-2.6-lttng.orig/kernel/fork.c	2008-07-04 16:59:29.000000000 -0400
> +++ linux-2.6-lttng/kernel/fork.c	2008-07-04 17:38:16.000000000 -0400
> @@ -54,6 +54,7 @@
>  #include <linux/tty.h>
>  #include <linux/proc_fs.h>
>  #include <linux/blkdev.h>
> +#include "kernel-trace.h"
>  
>  #include <asm/pgtable.h>
>  #include <asm/pgalloc.h>
> @@ -1356,6 +1357,8 @@ long do_fork(unsigned long clone_flags,
>  	if (!IS_ERR(p)) {
>  		struct completion vfork;
>  
> +		trace_kernel_process_fork(current, p);
> +
>  		nr = task_pid_vnr(p);
>  
>  		if (clone_flags & CLONE_PARENT_SETTID)
> Index: linux-2.6-lttng/kernel/module.c
> ===================================================================
> --- linux-2.6-lttng.orig/kernel/module.c	2008-07-04 16:59:29.000000000 -0400
> +++ linux-2.6-lttng/kernel/module.c	2008-07-04 17:38:16.000000000 -0400
> @@ -47,6 +47,7 @@
>  #include <linux/license.h>
>  #include <asm/sections.h>
>  #include <linux/tracepoint.h>
> +#include "kernel-trace.h"
>  
>  #if 0
>  #define DEBUGP printk
> @@ -1386,6 +1387,8 @@ static int __unlink_module(void *_mod)
>  /* Free a module, remove from lists, etc (must hold module_mutex). */
>  static void free_module(struct module *mod)
>  {
> +	trace_kernel_module_free(mod);
> +
>  	/* Delete from various lists */
>  	stop_machine_run(__unlink_module, mod, NR_CPUS);
>  	remove_notes_attrs(mod);
> @@ -2176,6 +2179,8 @@ static struct module *load_module(void _
>  	/* Get rid of temporary copy */
>  	vfree(hdr);
>  
> +	trace_kernel_module_load(mod);
> +
>  	/* Done! */
>  	return mod;
>  
> Index: linux-2.6-lttng/kernel/kernel-trace.h
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6-lttng/kernel/kernel-trace.h	2008-07-04 17:38:16.000000000 -0400
> @@ -0,0 +1,106 @@
> +#ifndef _KERNEL_TRACE_H
> +#define _KERNEL_TRACE_H
> +
> +#include <linux/kdebug.h>
> +#include <linux/interrupt.h>
> +#include <linux/tracepoint.h>
> +
> +DEFINE_TRACE(kernel_irq_entry,
> +	TPPROTO(unsigned int id, struct pt_regs *regs),
> +	TPARGS(id, regs));
> +DEFINE_TRACE(kernel_irq_exit,
> +	TPPROTO(void),
> +	TPARGS());
> +DEFINE_TRACE(kernel_timer_itimer_expired,
> +	TPPROTO(struct signal_struct *sig),
> +	TPARGS(sig));
> +DEFINE_TRACE(kernel_timer_itimer_set,
> +	TPPROTO(int which, struct itimerval *value),
> +	TPARGS(which, value));
> +DEFINE_TRACE(kernel_kthread_stop,
> +	TPPROTO(struct task_struct *t),
> +	TPARGS(t));
> +DEFINE_TRACE(kernel_kthread_stop_ret,
> +	TPPROTO(int ret),
> +	TPARGS(ret));
> +DEFINE_TRACE(kernel_printk,
> +	TPPROTO(void *retaddr),
> +	TPARGS(retaddr));
> +DEFINE_TRACE(kernel_vprintk,
> +	TPPROTO(void *retaddr, char *buf, int len),
> +	TPARGS(retaddr, buf, len));
> +
> +/*
> + * Scheduler trace points.
> + */
> +DEFINE_TRACE(kernel_sched_wait_task,
> +	TPPROTO(struct task_struct *p),
> +	TPARGS(p));
> +DEFINE_TRACE(kernel_sched_try_wakeup,
> +	TPPROTO(struct task_struct *p),
> +	TPARGS(p));
> +DEFINE_TRACE(kernel_sched_wakeup_new_task,
> +	TPPROTO(struct task_struct *p),
> +	TPARGS(p));
> +DEFINE_TRACE(kernel_sched_schedule,
> +	TPPROTO(struct task_struct *prev, struct task_struct *next),
> +	TPARGS(prev, next));
> +DEFINE_TRACE(kernel_sched_migrate_task,
> +	TPPROTO(struct task_struct *p, int dest_cpu),
> +	TPARGS(p, dest_cpu));
> +
> +DEFINE_TRACE(kernel_signal_send,
> +	TPPROTO(int sig, struct task_struct *p),
> +	TPARGS(sig, p));
> +DEFINE_TRACE(kernel_softirq_entry,
> +	TPPROTO(struct softirq_action *h, struct softirq_action *softirq_vec),
> +	TPARGS(h, softirq_vec));
> +DEFINE_TRACE(kernel_softirq_exit,
> +	TPPROTO(struct softirq_action *h, struct softirq_action *softirq_vec),
> +	TPARGS(h, softirq_vec));
> +DEFINE_TRACE(kernel_softirq_raise,
> +	TPPROTO(unsigned int nr),
> +	TPARGS(nr));
> +DEFINE_TRACE(kernel_tasklet_low_entry,
> +	TPPROTO(struct tasklet_struct *t),
> +	TPARGS(t));
> +DEFINE_TRACE(kernel_tasklet_low_exit,
> +	TPPROTO(struct tasklet_struct *t),
> +	TPARGS(t));
> +DEFINE_TRACE(kernel_tasklet_high_entry,
> +	TPPROTO(struct tasklet_struct *t),
> +	TPARGS(t));
> +DEFINE_TRACE(kernel_tasklet_high_exit,
> +	TPPROTO(struct tasklet_struct *t),
> +	TPARGS(t));
> +DEFINE_TRACE(kernel_timer_set,
> +	TPPROTO(struct timer_list *timer),
> +	TPARGS(timer));
> +/*
> + * xtime_lock is taken when kernel_timer_update_time tracepoint is reached.
> + */
> +DEFINE_TRACE(kernel_timer_update_time,
> +	TPPROTO(void),
> +	TPARGS());
> +DEFINE_TRACE(kernel_timer_timeout,
> +	TPPROTO(struct task_struct *p),
> +	TPARGS(p));
> +DEFINE_TRACE(kernel_process_free,
> +	TPPROTO(struct task_struct *p),
> +	TPARGS(p));
> +DEFINE_TRACE(kernel_process_exit,
> +	TPPROTO(struct task_struct *p),
> +	TPARGS(p));
> +DEFINE_TRACE(kernel_process_wait,
> +	TPPROTO(struct pid *pid),
> +	TPARGS(pid));
> +DEFINE_TRACE(kernel_process_fork,
> +	TPPROTO(struct task_struct *parent, struct task_struct *child),
> +	TPARGS(parent, child));
> +DEFINE_TRACE(kernel_module_free,
> +	TPPROTO(struct module *mod),
> +	TPARGS(mod));
> +DEFINE_TRACE(kernel_module_load,
> +	TPPROTO(struct module *mod),
> +	TPARGS(mod));
> +#endif
> 

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com


