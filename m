Return-Path: <linux-kernel-owner+w=401wt.eu-S1760918AbYC0Nbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760918AbYC0Nbu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 09:31:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759181AbYC0NaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 09:30:24 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:45328 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757027AbYC0NaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 09:30:21 -0400
Message-Id: <20080327133013.943492855@polymtl.ca>
References: <20080327132057.449831367@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 27 Mar 2008 09:21:01 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch for 2.6.26 4/7] LTTng instrumentation kernel
Content-Disposition: inline; filename=lttng-instrumentation-kernel.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu, 27 Mar 2008 13:30:14 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Core kernel events.

*not* present in this patch because they are architecture specific :
- syscall entry/exit
- traps
- kernel thread creation

Added markers :

kernel_irq_entry
kernel_irq_exit
kernel_kthread_stop
kernel_kthread_stop_ret
kernel_module_free
kernel_module_load
kernel_printk
kernel_process_exit
kernel_process_fork
kernel_process_free
kernel_process_wait
kernel_sched_migrate_task
kernel_sched_schedule
kernel_sched_try_wakeup
kernel_sched_wait_task
kernel_sched_wakeup_new_task
kernel_send_signal
kernel_softirq_entry
kernel_softirq_exit
kernel_softirq_raise
kernel_tasklet_high_entry
kernel_tasklet_high_exit
kernel_tasklet_low_entry
kernel_tasklet_low_exit
kernel_timer_itimer_expired
kernel_timer_itimer_set
kernel_timer_set
kernel_timer_timeout
kernel_timer_update_time
kernel_vprintk
locking_hardirqs_off
locking_hardirqs_on
locking_lock_acquire
locking_lock_release
locking_softirqs_off
locking_softirqs_on

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 kernel/exit.c       |    7 +++++++
 kernel/fork.c       |    5 +++++
 kernel/irq/handle.c |    7 +++++++
 kernel/itimer.c     |   13 +++++++++++++
 kernel/kthread.c    |    5 +++++
 kernel/lockdep.c    |   20 ++++++++++++++++++++
 kernel/module.c     |    5 +++++
 kernel/printk.c     |   27 +++++++++++++++++++++++++++
 kernel/sched.c      |   12 ++++++++++++
 kernel/signal.c     |    3 +++
 kernel/softirq.c    |   23 +++++++++++++++++++++++
 kernel/timer.c      |   13 ++++++++++++-
 12 files changed, 139 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng/kernel/irq/handle.c
===================================================================
--- linux-2.6-lttng.orig/kernel/irq/handle.c	2008-03-27 07:40:09.000000000 -0400
+++ linux-2.6-lttng/kernel/irq/handle.c	2008-03-27 07:40:15.000000000 -0400
@@ -15,6 +15,7 @@
 #include <linux/random.h>
 #include <linux/interrupt.h>
 #include <linux/kernel_stat.h>
+#include <linux/marker.h>
 
 #include "internals.h"
 
@@ -130,6 +131,10 @@ irqreturn_t handle_IRQ_event(unsigned in
 {
 	irqreturn_t ret, retval = IRQ_NONE;
 	unsigned int status = 0;
+	struct pt_regs *regs = get_irq_regs();
+
+	trace_mark(kernel_irq_entry, "irq_id %u kernel_mode %u", irq,
+		(regs)?(!user_mode(regs)):(1));
 
 	handle_dynamic_tick(action);
 
@@ -148,6 +153,8 @@ irqreturn_t handle_IRQ_event(unsigned in
 		add_interrupt_randomness(irq);
 	local_irq_disable();
 
+	trace_mark(kernel_irq_exit, MARK_NOARGS);
+
 	return retval;
 }
 
Index: linux-2.6-lttng/kernel/itimer.c
===================================================================
--- linux-2.6-lttng.orig/kernel/itimer.c	2008-03-27 07:40:09.000000000 -0400
+++ linux-2.6-lttng/kernel/itimer.c	2008-03-27 07:40:15.000000000 -0400
@@ -12,6 +12,7 @@
 #include <linux/time.h>
 #include <linux/posix-timers.h>
 #include <linux/hrtimer.h>
+#include <linux/marker.h>
 
 #include <asm/uaccess.h>
 
@@ -132,6 +133,9 @@ enum hrtimer_restart it_real_fn(struct h
 	struct signal_struct *sig =
 		container_of(timer, struct signal_struct, real_timer);
 
+	trace_mark(kernel_timer_itimer_expired, "pid %d",
+		pid_nr(sig->leader_pid));
+
 	kill_pid_info(SIGALRM, SEND_SIG_PRIV, sig->leader_pid);
 
 	return HRTIMER_NORESTART;
@@ -157,6 +161,15 @@ int do_setitimer(int which, struct itime
 	    !timeval_valid(&value->it_interval))
 		return -EINVAL;
 
+	trace_mark(kernel_timer_itimer_set,
+			"which %d interval_sec %ld interval_usec %ld "
+			"value_sec %ld value_usec %ld",
+			which,
+			value->it_interval.tv_sec,
+			value->it_interval.tv_usec,
+			value->it_value.tv_sec,
+			value->it_value.tv_usec);
+
 	switch (which) {
 	case ITIMER_REAL:
 again:
Index: linux-2.6-lttng/kernel/kthread.c
===================================================================
--- linux-2.6-lttng.orig/kernel/kthread.c	2008-03-27 07:40:09.000000000 -0400
+++ linux-2.6-lttng/kernel/kthread.c	2008-03-27 07:40:15.000000000 -0400
@@ -13,6 +13,7 @@
 #include <linux/file.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
+#include <linux/marker.h>
 #include <asm/semaphore.h>
 
 #define KTHREAD_NICE_LEVEL (-5)
@@ -205,6 +206,8 @@ int kthread_stop(struct task_struct *k)
 	/* It could exit after stop_info.k set, but before wake_up_process. */
 	get_task_struct(k);
 
+	trace_mark(kernel_kthread_stop, "pid %d", k->pid);
+
 	/* Must init completion *before* thread sees kthread_stop_info.k */
 	init_completion(&kthread_stop_info.done);
 	smp_wmb();
@@ -220,6 +223,8 @@ int kthread_stop(struct task_struct *k)
 	ret = kthread_stop_info.err;
 	mutex_unlock(&kthread_stop_lock);
 
+	trace_mark(kernel_kthread_stop_ret, "ret %d", ret);
+
 	return ret;
 }
 EXPORT_SYMBOL(kthread_stop);
Index: linux-2.6-lttng/kernel/lockdep.c
===================================================================
--- linux-2.6-lttng.orig/kernel/lockdep.c	2008-03-27 07:40:09.000000000 -0400
+++ linux-2.6-lttng/kernel/lockdep.c	2008-03-27 07:40:15.000000000 -0400
@@ -39,6 +39,7 @@
 #include <linux/irqflags.h>
 #include <linux/utsname.h>
 #include <linux/hash.h>
+#include <linux/marker.h>
 
 #include <asm/sections.h>
 
@@ -2018,6 +2019,9 @@ void trace_hardirqs_on(void)
 	struct task_struct *curr = current;
 	unsigned long ip;
 
+	_trace_mark(locking_hardirqs_on, "ip #p%lu",
+		(unsigned long) __builtin_return_address(0));
+
 	if (unlikely(!debug_locks || current->lockdep_recursion))
 		return;
 
@@ -2065,6 +2069,9 @@ void trace_hardirqs_off(void)
 {
 	struct task_struct *curr = current;
 
+	_trace_mark(locking_hardirqs_off, "ip #p%lu",
+		(unsigned long) __builtin_return_address(0));
+
 	if (unlikely(!debug_locks || current->lockdep_recursion))
 		return;
 
@@ -2092,6 +2099,9 @@ void trace_softirqs_on(unsigned long ip)
 {
 	struct task_struct *curr = current;
 
+	_trace_mark(locking_softirqs_on, "ip #p%lu",
+		(unsigned long) __builtin_return_address(0));
+
 	if (unlikely(!debug_locks))
 		return;
 
@@ -2126,6 +2136,9 @@ void trace_softirqs_off(unsigned long ip
 {
 	struct task_struct *curr = current;
 
+	_trace_mark(locking_softirqs_off, "ip #p%lu",
+		(unsigned long) __builtin_return_address(0));
+
 	if (unlikely(!debug_locks))
 		return;
 
@@ -2358,6 +2371,10 @@ static int __lock_acquire(struct lockdep
 	int chain_head = 0;
 	u64 chain_key;
 
+	_trace_mark(locking_lock_acquire,
+		"ip #p%lu subclass %u lock %p trylock %d",
+		ip, subclass, lock, trylock);
+
 	if (!prove_locking)
 		check = 1;
 
@@ -2631,6 +2648,9 @@ __lock_release(struct lockdep_map *lock,
 {
 	struct task_struct *curr = current;
 
+	_trace_mark(locking_lock_release, "ip #p%lu lock %p nested %d",
+		ip, lock, nested);
+
 	if (!check_unlock(curr, lock, ip))
 		return;
 
Index: linux-2.6-lttng/kernel/printk.c
===================================================================
--- linux-2.6-lttng.orig/kernel/printk.c	2008-03-27 07:40:09.000000000 -0400
+++ linux-2.6-lttng/kernel/printk.c	2008-03-27 07:40:15.000000000 -0400
@@ -32,6 +32,7 @@
 #include <linux/security.h>
 #include <linux/bootmem.h>
 #include <linux/syscalls.h>
+#include <linux/marker.h>
 
 #include <asm/uaccess.h>
 
@@ -607,6 +608,7 @@ asmlinkage int printk(const char *fmt, .
 	int r;
 
 	va_start(args, fmt);
+	trace_mark(kernel_printk, "ip %p", __builtin_return_address(0));
 	r = vprintk(fmt, args);
 	va_end(args);
 
@@ -671,6 +673,31 @@ asmlinkage int vprintk(const char *fmt, 
 	raw_local_irq_save(flags);
 	this_cpu = smp_processor_id();
 
+	if (printed_len > 0) {
+		unsigned int loglevel;
+		int mark_len;
+		char *mark_buf;
+		char saved_char;
+
+		if (printk_buf[0] == '<' && printk_buf[1] >= '0' &&
+		   printk_buf[1] <= '7' && printk_buf[2] == '>') {
+			loglevel = printk_buf[1] - '0';
+			mark_buf = &printk_buf[3];
+			mark_len = printed_len - 3;
+		} else {
+			loglevel = default_message_loglevel;
+			mark_buf = printk_buf;
+			mark_len = printed_len;
+		}
+		if (mark_buf[mark_len - 1] == '\n')
+			mark_len--;
+		saved_char = mark_buf[mark_len];
+		mark_buf[mark_len] = '\0';
+		_trace_mark(kernel_vprintk, "loglevel %c string %s ip %p",
+			loglevel, mark_buf, __builtin_return_address(0));
+		mark_buf[mark_len] = saved_char;
+	}
+
 	/*
 	 * Ouch, printk recursed into itself!
 	 */
Index: linux-2.6-lttng/kernel/sched.c
===================================================================
--- linux-2.6-lttng.orig/kernel/sched.c	2008-03-27 07:40:09.000000000 -0400
+++ linux-2.6-lttng/kernel/sched.c	2008-03-27 07:40:15.000000000 -0400
@@ -66,6 +66,7 @@
 #include <linux/unistd.h>
 #include <linux/pagemap.h>
 #include <linux/hrtimer.h>
+#include <linux/marker.h>
 
 #include <asm/tlb.h>
 #include <asm/irq_regs.h>
@@ -1563,6 +1564,8 @@ void wait_task_inactive(struct task_stru
 		 * just go back and repeat.
 		 */
 		rq = task_rq_lock(p, &flags);
+		trace_mark(kernel_sched_wait_task, "pid %d state %ld",
+			p->pid, p->state);
 		running = task_running(rq, p);
 		on_rq = p->se.on_rq;
 		task_rq_unlock(rq, &flags);
@@ -1841,6 +1844,8 @@ static int try_to_wake_up(struct task_st
 
 	smp_wmb();
 	rq = task_rq_lock(p, &flags);
+	trace_mark(kernel_sched_try_wakeup, "pid %d state %ld",
+		p->pid, p->state);
 	old_state = p->state;
 	if (!(old_state & state))
 		goto out;
@@ -2017,6 +2022,8 @@ void wake_up_new_task(struct task_struct
 	struct rq *rq;
 
 	rq = task_rq_lock(p, &flags);
+	trace_mark(kernel_sched_wakeup_new_task, "pid %d state %ld",
+		p->pid, p->state);
 	BUG_ON(p->state != TASK_RUNNING);
 	update_rq_clock(rq);
 
@@ -2204,6 +2211,9 @@ context_switch(struct rq *rq, struct tas
 	struct mm_struct *mm, *oldmm;
 
 	prepare_task_switch(rq, prev, next);
+	trace_mark(kernel_sched_schedule,
+		"prev_pid %d next_pid %d prev_state %ld",
+		prev->pid, next->pid, prev->state);
 	mm = next->mm;
 	oldmm = prev->active_mm;
 	/*
@@ -2436,6 +2446,8 @@ static void sched_migrate_task(struct ta
 	    || unlikely(cpu_is_offline(dest_cpu)))
 		goto out;
 
+	trace_mark(kernel_sched_migrate_task, "pid %d state %ld dest_cpu %d",
+		p->pid, p->state, dest_cpu);
 	/* force the process onto the specified CPU */
 	if (migrate_task(p, dest_cpu, &req)) {
 		/* Need to wait for migration thread (might exit: take ref). */
Index: linux-2.6-lttng/kernel/signal.c
===================================================================
--- linux-2.6-lttng.orig/kernel/signal.c	2008-03-27 07:40:09.000000000 -0400
+++ linux-2.6-lttng/kernel/signal.c	2008-03-27 07:40:15.000000000 -0400
@@ -26,6 +26,7 @@
 #include <linux/freezer.h>
 #include <linux/pid_namespace.h>
 #include <linux/nsproxy.h>
+#include <linux/marker.h>
 
 #include <asm/param.h>
 #include <asm/uaccess.h>
@@ -663,6 +664,8 @@ static int send_signal(int sig, struct s
 	struct sigqueue * q = NULL;
 	int ret = 0;
 
+	trace_mark(kernel_send_signal, "pid %d signal %d", t->pid, sig);
+
 	/*
 	 * Deliver the signal to listening signalfds. This must be called
 	 * with the sighand lock held.
Index: linux-2.6-lttng/kernel/softirq.c
===================================================================
--- linux-2.6-lttng.orig/kernel/softirq.c	2008-03-27 07:40:09.000000000 -0400
+++ linux-2.6-lttng/kernel/softirq.c	2008-03-27 07:40:15.000000000 -0400
@@ -21,6 +21,7 @@
 #include <linux/rcupdate.h>
 #include <linux/smp.h>
 #include <linux/tick.h>
+#include <linux/marker.h>
 
 #include <asm/irq.h>
 /*
@@ -231,7 +232,15 @@ restart:
 
 	do {
 		if (pending & 1) {
+			trace_mark(kernel_softirq_entry, "softirq_id %lu",
+				((unsigned long)h
+					- (unsigned long)softirq_vec)
+					/ sizeof(*h));
 			h->action(h);
+			trace_mark(kernel_softirq_exit, "softirq_id %lu",
+				((unsigned long)h
+					- (unsigned long)softirq_vec)
+					/ sizeof(*h));
 			rcu_bh_qsctr_inc(cpu);
 		}
 		h++;
@@ -323,6 +332,8 @@ void irq_exit(void)
  */
 inline void raise_softirq_irqoff(unsigned int nr)
 {
+	trace_mark(kernel_softirq_raise, "softirq_id %u", nr);
+
 	__raise_softirq_irqoff(nr);
 
 	/*
@@ -408,7 +419,13 @@ static void tasklet_action(struct softir
 			if (!atomic_read(&t->count)) {
 				if (!test_and_clear_bit(TASKLET_STATE_SCHED, &t->state))
 					BUG();
+				trace_mark(kernel_tasklet_low_entry,
+						"func %p data %lu",
+						t->func, t->data);
 				t->func(t->data);
+				trace_mark(kernel_tasklet_low_exit,
+						"func %p data %lu",
+						t->func, t->data);
 				tasklet_unlock(t);
 				continue;
 			}
@@ -441,7 +458,13 @@ static void tasklet_hi_action(struct sof
 			if (!atomic_read(&t->count)) {
 				if (!test_and_clear_bit(TASKLET_STATE_SCHED, &t->state))
 					BUG();
+				trace_mark(kernel_tasklet_high_entry,
+						"func %p data %lu",
+						t->func, t->data);
 				t->func(t->data);
+				trace_mark(kernel_tasklet_high_exit,
+						"func %p data %lu",
+						t->func, t->data);
 				tasklet_unlock(t);
 				continue;
 			}
Index: linux-2.6-lttng/kernel/timer.c
===================================================================
--- linux-2.6-lttng.orig/kernel/timer.c	2008-03-27 07:40:09.000000000 -0400
+++ linux-2.6-lttng/kernel/timer.c	2008-03-27 07:40:15.000000000 -0400
@@ -37,12 +37,14 @@
 #include <linux/delay.h>
 #include <linux/tick.h>
 #include <linux/kallsyms.h>
+#include <linux/marker.h>
 
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
 #include <asm/div64.h>
 #include <asm/timex.h>
 #include <asm/io.h>
+#include <asm/irq_regs.h>
 
 u64 jiffies_64 __cacheline_aligned_in_smp = INITIAL_JIFFIES;
 
@@ -288,6 +290,8 @@ static void internal_add_timer(struct tv
 		i = (expires >> (TVR_BITS + 3 * TVN_BITS)) & TVN_MASK;
 		vec = base->tv5.vec + i;
 	}
+	trace_mark(kernel_timer_set, "expires %lu function %p data %lu",
+		expires, timer->function, timer->data);
 	/*
 	 * Timers are FIFO:
 	 */
@@ -940,6 +944,11 @@ void do_timer(unsigned long ticks)
 {
 	jiffies_64 += ticks;
 	update_times(ticks);
+	trace_mark(kernel_timer_update_time,
+		"jiffies #8u%llu xtime_sec %ld xtime_nsec %ld "
+		"walltomonotonic_sec %ld walltomonotonic_nsec %ld",
+		(unsigned long long)jiffies_64, xtime.tv_sec, xtime.tv_nsec,
+		wall_to_monotonic.tv_sec, wall_to_monotonic.tv_nsec);
 }
 
 #ifdef __ARCH_WANT_SYS_ALARM
@@ -1021,7 +1030,9 @@ asmlinkage long sys_getegid(void)
 
 static void process_timeout(unsigned long __data)
 {
-	wake_up_process((struct task_struct *)__data);
+	struct task_struct *task = (struct task_struct *)__data;
+	trace_mark(kernel_timer_timeout, "pid %d", task->pid);
+	wake_up_process(task);
 }
 
 /**
Index: linux-2.6-lttng/kernel/exit.c
===================================================================
--- linux-2.6-lttng.orig/kernel/exit.c	2008-03-27 07:40:09.000000000 -0400
+++ linux-2.6-lttng/kernel/exit.c	2008-03-27 07:40:15.000000000 -0400
@@ -44,6 +44,7 @@
 #include <linux/resource.h>
 #include <linux/blkdev.h>
 #include <linux/task_io_accounting_ops.h>
+#include <linux/marker.h>
 
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
@@ -137,6 +138,8 @@ static void __exit_signal(struct task_st
 
 static void delayed_put_task_struct(struct rcu_head *rhp)
 {
+	trace_mark(kernel_process_free, "pid %d",
+		container_of(rhp, struct task_struct, rcu)->pid);
 	put_task_struct(container_of(rhp, struct task_struct, rcu));
 }
 
@@ -966,6 +969,8 @@ NORET_TYPE void do_exit(long code)
 
 	if (group_dead)
 		acct_process();
+	trace_mark(kernel_process_exit, "pid %d", tsk->pid);
+
 	exit_sem(tsk);
 	__exit_files(tsk);
 	__exit_fs(tsk);
@@ -1450,6 +1455,8 @@ static long do_wait(enum pid_type type, 
 	struct task_struct *tsk;
 	int flag, retval;
 
+	trace_mark(kernel_process_wait, "pid %d", pid_nr(pid));
+
 	add_wait_queue(&current->signal->wait_chldexit,&wait);
 repeat:
 	/* If there is nothing that can match our critier just get out */
Index: linux-2.6-lttng/kernel/fork.c
===================================================================
--- linux-2.6-lttng.orig/kernel/fork.c	2008-03-27 07:40:09.000000000 -0400
+++ linux-2.6-lttng/kernel/fork.c	2008-03-27 07:40:15.000000000 -0400
@@ -53,6 +53,7 @@
 #include <linux/tty.h>
 #include <linux/proc_fs.h>
 #include <linux/blkdev.h>
+#include <linux/marker.h>
 
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
@@ -1488,6 +1489,10 @@ long do_fork(unsigned long clone_flags,
 	if (!IS_ERR(p)) {
 		struct completion vfork;
 
+		trace_mark(kernel_process_fork,
+			"parent_pid %d child_pid %d child_tgid %d",
+			current->pid, p->pid, p->tgid);
+
 		nr = task_pid_vnr(p);
 
 		if (clone_flags & CLONE_PARENT_SETTID)
Index: linux-2.6-lttng/kernel/module.c
===================================================================
--- linux-2.6-lttng.orig/kernel/module.c	2008-03-27 07:40:09.000000000 -0400
+++ linux-2.6-lttng/kernel/module.c	2008-03-27 07:40:15.000000000 -0400
@@ -47,6 +47,7 @@
 #include <asm/cacheflush.h>
 #include <linux/license.h>
 #include <asm/sections.h>
+#include <linux/marker.h>
 
 #if 0
 #define DEBUGP printk
@@ -1332,6 +1333,8 @@ static int __unlink_module(void *_mod)
 /* Free a module, remove from lists, etc (must hold module_mutex). */
 static void free_module(struct module *mod)
 {
+	trace_mark(kernel_module_free, "name %s", mod->name);
+
 	/* Delete from various lists */
 	stop_machine_run(__unlink_module, mod, NR_CPUS);
 	remove_notes_attrs(mod);
@@ -2104,6 +2107,8 @@ static struct module *load_module(void _
 	/* Get rid of temporary copy */
 	vfree(hdr);
 
+	trace_mark(kernel_module_load, "name %s", mod->name);
+
 	/* Done! */
 	return mod;
 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
