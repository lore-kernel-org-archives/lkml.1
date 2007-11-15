Return-Path: <linux-kernel-owner+w=401wt.eu-S933533AbXKOXbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933533AbXKOXbQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 18:31:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762053AbXKOXap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 18:30:45 -0500
Received: from sitemail2.everyone.net ([216.200.145.36]:58088 "EHLO
	omta18.mta.everyone.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756389AbXKOXan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 18:30:43 -0500
X-Eon-Dm: dm02
X-Eon-Sig: AQEbFf9HPNaiRrdQUQIAAAAD,2c17a9a7787af44d34f5765350b78010
Message-ID: <473CD6A1.6050008@us.ibm.com>
Date: Thu, 15 Nov 2007 15:30:41 -0800
From: Mike Mason <mmlnx@us.ibm.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 4/7] LTTng instrumentation kernel
References: <20071113193349.214098508@polymtl.ca> <20071113194024.837009055@polymtl.ca>
In-Reply-To: <20071113194024.837009055@polymtl.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses _trace_mark in lockdep.c and printk.c.  I assume they should be trace_mark (no '_' prefix).

Mike Mason


Mathieu Desnoyers wrote:

Core kernel events.

*not* present in this patch because they are architecture specific :
- syscall entry/exit
- traps
- kernel thread creation

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 include/linux/module.h |    1 +
 kernel/exit.c          |    5 +++++
 kernel/fork.c          |    4 ++++
 kernel/irq/handle.c    |    6 ++++++
 kernel/itimer.c        |   11 +++++++++++
 kernel/kthread.c       |    4 ++++
 kernel/lockdep.c       |   19 +++++++++++++++++++
 kernel/module.c        |   25 +++++++++++++++++++++++++
 kernel/printk.c        |   26 ++++++++++++++++++++++++++
 kernel/sched.c         |   11 +++++++++++
 kernel/signal.c        |    2 ++
 kernel/softirq.c       |   22 ++++++++++++++++++++++
 kernel/timer.c         |   12 +++++++++++-
 13 files changed, 147 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng/kernel/irq/handle.c
===================================================================
--- linux-2.6-lttng.orig/kernel/irq/handle.c	2007-11-13 09:25:27.000000000 -0500
+++ linux-2.6-lttng/kernel/irq/handle.c	2007-11-13 09:49:33.000000000 -0500
@@ -130,6 +130,10 @@ irqreturn_t handle_IRQ_event(unsigned in
 {
 	irqreturn_t ret, retval = IRQ_NONE;
 	unsigned int status = 0;
+	struct pt_regs *regs = get_irq_regs();
+
+	trace_mark(kernel_irq_entry, "irq_id %u kernel_mode %u", irq,
+		(regs)?(!user_mode(regs)):(1));

 	handle_dynamic_tick(action);

@@ -148,6 +152,8 @@ irqreturn_t handle_IRQ_event(unsigned in
 		add_interrupt_randomness(irq);
 	local_irq_disable();

+	trace_mark(kernel_irq_exit, MARK_NOARGS);
+
 	return retval;
 }

Index: linux-2.6-lttng/kernel/itimer.c
===================================================================
--- linux-2.6-lttng.orig/kernel/itimer.c	2007-11-13 09:25:27.000000000 -0500
+++ linux-2.6-lttng/kernel/itimer.c	2007-11-13 09:49:33.000000000 -0500
@@ -132,6 +132,8 @@ enum hrtimer_restart it_real_fn(struct h
 	struct signal_struct *sig =
 		container_of(timer, struct signal_struct, real_timer);

+	trace_mark(kernel_timer_itimer_expired, "pid %d", sig->tsk->pid);
+
 	send_group_sig_info(SIGALRM, SEND_SIG_PRIV, sig->tsk);

 	return HRTIMER_NORESTART;
@@ -157,6 +159,15 @@ int do_setitimer(int which, struct itime
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
--- linux-2.6-lttng.orig/kernel/kthread.c	2007-11-13 09:25:27.000000000 -0500
+++ linux-2.6-lttng/kernel/kthread.c	2007-11-13 09:49:33.000000000 -0500
@@ -195,6 +195,8 @@ int kthread_stop(struct task_struct *k)
 	/* It could exit after stop_info.k set, but before wake_up_process. */
 	get_task_struct(k);

+	trace_mark(kernel_kthread_stop, "pid %d", k->pid);
+
 	/* Must init completion *before* thread sees kthread_stop_info.k */
 	init_completion(&kthread_stop_info.done);
 	smp_wmb();
@@ -210,6 +212,8 @@ int kthread_stop(struct task_struct *k)
 	ret = kthread_stop_info.err;
 	mutex_unlock(&kthread_stop_lock);

+	trace_mark(kernel_kthread_stop_ret, "ret %d", ret);
+
 	return ret;
 }
 EXPORT_SYMBOL(kthread_stop);
Index: linux-2.6-lttng/kernel/lockdep.c
===================================================================
--- linux-2.6-lttng.orig/kernel/lockdep.c	2007-11-13 09:25:27.000000000 -0500
+++ linux-2.6-lttng/kernel/lockdep.c	2007-11-13 09:49:33.000000000 -0500
@@ -2014,6 +2014,9 @@ void trace_hardirqs_on(void)
 	struct task_struct *curr = current;
 	unsigned long ip;

+	_trace_mark(locking_hardirqs_on, "ip #p%lu",
+		(unsigned long) __builtin_return_address(0));
+
 	if (unlikely(!debug_locks || current->lockdep_recursion))
 		return;

@@ -2061,6 +2064,9 @@ void trace_hardirqs_off(void)
 {
 	struct task_struct *curr = current;

+	_trace_mark(locking_hardirqs_off, "ip #p%lu",
+		(unsigned long) __builtin_return_address(0));
+
 	if (unlikely(!debug_locks || current->lockdep_recursion))
 		return;

@@ -2088,6 +2094,9 @@ void trace_softirqs_on(unsigned long ip)
 {
 	struct task_struct *curr = current;

+	_trace_mark(locking_softirqs_on, "ip #p%lu",
+		(unsigned long) __builtin_return_address(0));
+
 	if (unlikely(!debug_locks))
 		return;

@@ -2122,6 +2131,9 @@ void trace_softirqs_off(unsigned long ip
 {
 	struct task_struct *curr = current;

+	_trace_mark(locking_softirqs_off, "ip #p%lu",
+		(unsigned long) __builtin_return_address(0));
+
 	if (unlikely(!debug_locks))
 		return;

@@ -2358,6 +2370,10 @@ static int __lock_acquire(struct lockdep
 	int chain_head = 0;
 	u64 chain_key;

+	_trace_mark(locking_lock_acquire,
+		"ip #p%lu subclass %u lock %p trylock %d",
+		ip, subclass, lock, trylock);
+
 	if (!prove_locking)
 		check = 1;

@@ -2631,6 +2647,9 @@ __lock_release(struct lockdep_map *lock,
 {
 	struct task_struct *curr = current;

+	_trace_mark(locking_lock_release, "ip #p%lu lock %p nested %d",
+		ip, lock, nested);
+
 	if (!check_unlock(curr, lock, ip))
 		return;

Index: linux-2.6-lttng/kernel/printk.c
===================================================================
--- linux-2.6-lttng.orig/kernel/printk.c	2007-11-13 09:25:27.000000000 -0500
+++ linux-2.6-lttng/kernel/printk.c	2007-11-13 09:49:33.000000000 -0500
@@ -619,6 +619,7 @@ asmlinkage int printk(const char *fmt, .
 	int r;

 	va_start(args, fmt);
+	trace_mark(kernel_printk, "ip %p", __builtin_return_address(0));
 	r = vprintk(fmt, args);
 	va_end(args);

@@ -653,6 +654,31 @@ asmlinkage int vprintk(const char *fmt, 
 	/* Emit the output into the temporary buffer */
 	printed_len = vscnprintf(printk_buf, sizeof(printk_buf), fmt, args);

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
 	 * Copy the output into log_buf.  If the caller didn't provide
 	 * appropriate log level tags, we insert them here
Index: linux-2.6-lttng/kernel/sched.c
===================================================================
--- linux-2.6-lttng.orig/kernel/sched.c	2007-11-13 09:25:27.000000000 -0500
+++ linux-2.6-lttng/kernel/sched.c	2007-11-13 09:49:33.000000000 -0500
@@ -1161,6 +1161,8 @@ void wait_task_inactive(struct task_stru
 		 * just go back and repeat.
 		 */
 		rq = task_rq_lock(p, &flags);
+		trace_mark(kernel_sched_wait_task, "pid %d state %ld",
+			p->pid, p->state);
 		running = task_running(rq, p);
 		on_rq = p->se.on_rq;
 		task_rq_unlock(rq, &flags);
@@ -1495,6 +1497,8 @@ static int try_to_wake_up(struct task_st
 #endif

 	rq = task_rq_lock(p, &flags);
+	trace_mark(kernel_sched_try_wakeup, "pid %d state %ld",
+		p->pid, p->state);
 	old_state = p->state;
 	if (!(old_state & state))
 		goto out;
@@ -1733,6 +1737,8 @@ void fastcall wake_up_new_task(struct ta
 	struct rq *rq;

 	rq = task_rq_lock(p, &flags);
+	trace_mark(kernel_sched_wakeup_new_task, "pid %d state %ld",
+		p->pid, p->state);
 	BUG_ON(p->state != TASK_RUNNING);
 	update_rq_clock(rq);

@@ -1911,6 +1917,9 @@ context_switch(struct rq *rq, struct tas
 	struct mm_struct *mm, *oldmm;

 	prepare_task_switch(rq, prev, next);
+	trace_mark(kernel_sched_schedule,
+		"prev_pid %d next_pid %d prev_state %ld",
+		prev->pid, next->pid, prev->state);
 	mm = next->mm;
 	oldmm = prev->active_mm;
 	/*
@@ -2139,6 +2148,8 @@ static void sched_migrate_task(struct ta
 	    || unlikely(cpu_is_offline(dest_cpu)))
 		goto out;

+	trace_mark(kernel_sched_migrate_task, "pid %d state %ld dest_cpu %d",
+		p->pid, p->state, dest_cpu);
 	/* force the process onto the specified CPU */
 	if (migrate_task(p, dest_cpu, &req)) {
 		/* Need to wait for migration thread (might exit: take ref). */
Index: linux-2.6-lttng/kernel/signal.c
===================================================================
--- linux-2.6-lttng.orig/kernel/signal.c	2007-11-13 09:25:27.000000000 -0500
+++ linux-2.6-lttng/kernel/signal.c	2007-11-13 09:49:33.000000000 -0500
@@ -663,6 +663,8 @@ static int send_signal(int sig, struct s
 	struct sigqueue * q = NULL;
 	int ret = 0;

+	trace_mark(kernel_send_signal, "pid %d signal %d", t->pid, sig);
+
 	/*
 	 * Deliver the signal to listening signalfds. This must be called
 	 * with the sighand lock held.
Index: linux-2.6-lttng/kernel/softirq.c
===================================================================
--- linux-2.6-lttng.orig/kernel/softirq.c	2007-11-13 09:25:27.000000000 -0500
+++ linux-2.6-lttng/kernel/softirq.c	2007-11-13 09:49:33.000000000 -0500
@@ -229,7 +229,15 @@ restart:

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
@@ -315,6 +323,8 @@ void irq_exit(void)
  */
 inline fastcall void raise_softirq_irqoff(unsigned int nr)
 {
+	trace_mark(kernel_softirq_raise, "softirq %u", nr);
+
 	__raise_softirq_irqoff(nr);

 	/*
@@ -400,7 +410,13 @@ static void tasklet_action(struct softir
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
@@ -433,7 +449,13 @@ static void tasklet_hi_action(struct sof
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
--- linux-2.6-lttng.orig/kernel/timer.c	2007-11-13 09:25:27.000000000 -0500
+++ linux-2.6-lttng/kernel/timer.c	2007-11-13 09:49:33.000000000 -0500
@@ -43,6 +43,7 @@
 #include <asm/div64.h>
 #include <asm/timex.h>
 #include <asm/io.h>
+#include <asm/irq_regs.h>

 u64 jiffies_64 __cacheline_aligned_in_smp = INITIAL_JIFFIES;

@@ -290,6 +291,8 @@ static void internal_add_timer(tvec_base
 		i = (expires >> (TVR_BITS + 3 * TVN_BITS)) & TVN_MASK;
 		vec = base->tv5.vec + i;
 	}
+	trace_mark(kernel_timer_set, "expires %lu function %p data %lu",
+		expires, timer->function, timer->data);
 	/*
 	 * Timers are FIFO:
 	 */
@@ -931,6 +934,11 @@ void do_timer(unsigned long ticks)
 {
 	jiffies_64 += ticks;
 	update_times(ticks);
+	trace_mark(kernel_timer_update_time,
+		"jiffies #8u%llu xtime_sec %ld xtime_nsec %ld "
+		"walltomonotonic_sec %ld walltomonotonic_nsec %ld",
+		jiffies_64, xtime.tv_sec, xtime.tv_nsec,
+		wall_to_monotonic.tv_sec, wall_to_monotonic.tv_nsec);
 }

 #ifdef __ARCH_WANT_SYS_ALARM
@@ -1012,7 +1020,9 @@ asmlinkage long sys_getegid(void)

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
--- linux-2.6-lttng.orig/kernel/exit.c	2007-11-13 09:25:27.000000000 -0500
+++ linux-2.6-lttng/kernel/exit.c	2007-11-13 09:49:33.000000000 -0500
@@ -177,6 +177,7 @@ repeat:

 	write_unlock_irq(&tasklist_lock);
 	release_thread(p);
+	trace_mark(kernel_process_free, "pid %d", p->pid);
 	call_rcu(&p->rcu, delayed_put_task_struct);

 	p = leader;
@@ -994,6 +995,8 @@ fastcall NORET_TYPE void do_exit(long co

 	if (group_dead)
 		acct_process();
+	trace_mark(kernel_process_exit, "pid %d", tsk->pid);
+
 	exit_sem(tsk);
 	__exit_files(tsk);
 	__exit_fs(tsk);
@@ -1539,6 +1542,8 @@ static long do_wait(pid_t pid, int optio
 	int flag, retval;
 	int allowed, denied;

+	trace_mark(kernel_process_wait, "pid %d", pid);
+
 	add_wait_queue(&current->signal->wait_chldexit,&wait);
 repeat:
 	/*
Index: linux-2.6-lttng/kernel/fork.c
===================================================================
--- linux-2.6-lttng.orig/kernel/fork.c	2007-11-13 09:25:27.000000000 -0500
+++ linux-2.6-lttng/kernel/fork.c	2007-11-13 09:49:33.000000000 -0500
@@ -1435,6 +1435,10 @@ long do_fork(unsigned long clone_flags,
 	if (!IS_ERR(p)) {
 		struct completion vfork;

+		trace_mark(kernel_process_fork,
+			"parent_pid %d child_pid %d child_tgid %d",
+			current->pid, p->pid, p->tgid);
+
 		/*
 		 * this is enough to call pid_nr_ns here, but this if
 		 * improves optimisation of regular fork()
Index: linux-2.6-lttng/include/linux/module.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/module.h	2007-11-13 09:48:41.000000000 -0500
+++ linux-2.6-lttng/include/linux/module.h	2007-11-13 09:49:33.000000000 -0500
@@ -466,6 +466,7 @@ int register_module_notifier(struct noti
 int unregister_module_notifier(struct notifier_block * nb);

 extern void print_modules(void);
+extern void list_modules(void *call_data);

 extern void module_update_markers(void);

Index: linux-2.6-lttng/kernel/module.c
===================================================================
--- linux-2.6-lttng.orig/kernel/module.c	2007-11-13 09:49:16.000000000 -0500
+++ linux-2.6-lttng/kernel/module.c	2007-11-13 09:49:33.000000000 -0500
@@ -1294,6 +1294,8 @@ static int __unlink_module(void *_mod)
 /* Free a module, remove from lists, etc (must hold module_mutex). */
 static void free_module(struct module *mod)
 {
+	trace_mark(kernel_module_free, "name %s", mod->name);
+
 	/* Delete from various lists */
 	stop_machine_run(__unlink_module, mod, NR_CPUS);
 	remove_notes_attrs(mod);
@@ -2063,6 +2065,8 @@ static struct module *load_module(void _
 	/* Get rid of temporary copy */
 	vfree(hdr);

+	trace_mark(kernel_module_load, "name %s", mod->name);
+
 	/* Done! */
 	return mod;

@@ -2426,6 +2430,27 @@ const struct seq_operations modules_op =
 	.show	= m_show
 };

+void list_modules(void *call_data)
+{
+	/* Enumerate loaded modules */
+	struct list_head	*i;
+	struct module		*mod;
+	unsigned long refcount = 0;
+
+	mutex_lock(&module_mutex);
+	list_for_each(i, &modules) {
+		mod = list_entry(i, struct module, list);
+#ifdef CONFIG_MODULE_UNLOAD
+		refcount = local_read(&mod->ref[0].count);
+#endif
+		__trace_mark(0, list_module, call_data,
+				"name %s state %d refcount %lu",
+				mod->name, mod->state, refcount);
+	}
+	mutex_unlock(&module_mutex);
+}
+EXPORT_SYMBOL_GPL(list_modules);
+
 /* Given an address, look for it in the module exception tables. */
 const struct exception_table_entry *search_module_extables(unsigned long addr)
 {

-- Mathieu Desnoyers Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F BA06 3F25 A8FE 3BAE 9A68 - To unsubscribe from this list: send the line "unsubscribe linux-kernel" in the body of a message to majordomo@vger.kernel.org More majordomo info at http://vger.kernel.org/majordomo-info.html Please read the FAQ at http://www.tux.org/lkml/ 
