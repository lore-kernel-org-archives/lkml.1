Return-Path: <linux-kernel-owner+w=401wt.eu-S1756883AbYGDX4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883AbYGDX4w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 19:56:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753580AbYGDXzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 19:55:17 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:42511 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752571AbYGDXzL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 19:55:11 -0400
Message-Id: <20080704235428.377708471@polymtl.ca>
References: <20080704235207.147809973@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Fri, 04 Jul 2008 19:52:17 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Alexander Viro <viro@zeniv.linux.org.uk>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: [RFC patch 10/12] LTTng instrumentation kernel tracepoint probes
Content-Disposition: inline; filename=lttng-instrumentation-kernel-tracepoints-probes.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Fri,  4 Jul 2008 23:54:28 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a module which declares kernel tracepoint probes, using markers.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Alexander Viro <viro@zeniv.linux.org.uk>
CC: 'Peter Zijlstra' <peterz@infradead.org>
CC: "Frank Ch. Eigler" <fche@redhat.com>
CC: 'Ingo Molnar' <mingo@elte.hu>
CC: 'Hideo AOKI' <haoki@redhat.com>
CC: Takashi Nishiie <t-nishiie@np.css.fujitsu.com>
CC: 'Steven Rostedt' <rostedt@goodmis.org>
CC: Masami Hiramatsu <mhiramat@redhat.com>
---
 kernel/Makefile       |    1 
 kernel/kernel-trace.c |  345 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 346 insertions(+)

Index: linux-2.6-lttng/kernel/Makefile
===================================================================
--- linux-2.6-lttng.orig/kernel/Makefile	2008-07-04 16:09:41.000000000 -0400
+++ linux-2.6-lttng/kernel/Makefile	2008-07-04 16:10:10.000000000 -0400
@@ -69,6 +69,7 @@ obj-$(CONFIG_TASK_DELAY_ACCT) += delayac
 obj-$(CONFIG_TASKSTATS) += taskstats.o tsacct.o
 obj-$(CONFIG_MARKERS) += marker.o
 obj-$(CONFIG_TRACEPOINTS) += tracepoint.o
+obj-$(CONFIG_TRACEPROBES) += kernel-trace.o
 obj-$(CONFIG_LATENCYTOP) += latencytop.o
 
 ifneq ($(CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER),y)
Index: linux-2.6-lttng/kernel/kernel-trace.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/kernel/kernel-trace.c	2008-07-04 16:58:32.000000000 -0400
@@ -0,0 +1,345 @@
+/*
+ * kernel/kernel-trace.c
+ *
+ * kernel tracepoint probes.
+ */
+
+#include <linux/module.h>
+#include "kernel-trace.h"
+
+static void probe_kernel_irq_entry(unsigned int id, struct pt_regs *regs)
+{
+	trace_mark(kernel_irq_entry, "irq_id %u kernel_mode %u", id,
+		(regs)?(!user_mode(regs)):(1));
+}
+
+static void probe_kernel_irq_exit(void)
+{
+	trace_mark(kernel_irq_exit, MARK_NOARGS);
+}
+
+static void probe_kernel_timer_itimer_expired(struct signal_struct *sig)
+{
+	trace_mark(kernel_timer_itimer_expired, "pid %d",
+		pid_nr(sig->leader_pid));
+}
+
+static void probe_kernel_timer_itimer_set(int which, struct itimerval *value)
+{
+	trace_mark(kernel_timer_itimer_set,
+		"which %d interval_sec %ld interval_usec %ld "
+		"value_sec %ld value_usec %ld",
+		which,
+		value->it_interval.tv_sec,
+		value->it_interval.tv_usec,
+		value->it_value.tv_sec,
+		value->it_value.tv_usec);
+}
+
+static void probe_kernel_kthread_stop(struct task_struct *t)
+{
+	trace_mark(kernel_kthread_stop, "pid %d", t->pid);
+}
+
+static void probe_kernel_kthread_stop_ret(int ret)
+{
+	trace_mark(kernel_kthread_stop_ret, "ret %d", ret);
+}
+
+static void probe_kernel_printk(void *retaddr)
+{
+	trace_mark(kernel_printk, "ip %p", retaddr);
+}
+
+static void probe_kernel_vprintk(void *retaddr, char *buf, int len)
+{
+	if (len > 0) {
+		unsigned int loglevel;
+		int mark_len;
+		char *mark_buf;
+		char saved_char;
+
+		if (buf[0] == '<' && buf[1] >= '0' &&
+		   buf[1] <= '7' && buf[2] == '>') {
+			loglevel = buf[1] - '0';
+			mark_buf = &buf[3];
+			mark_len = len - 3;
+		} else {
+			loglevel = default_message_loglevel;
+			mark_buf = buf;
+			mark_len = len;
+		}
+		if (mark_buf[mark_len - 1] == '\n')
+			mark_len--;
+		saved_char = mark_buf[mark_len];
+		mark_buf[mark_len] = '\0';
+		trace_mark(kernel_vprintk, "loglevel %c string %s ip %p",
+			loglevel, mark_buf, retaddr);
+		mark_buf[mark_len] = saved_char;
+	}
+}
+
+static void probe_kernel_sched_wait_task(struct task_struct *p)
+{
+	trace_mark(kernel_sched_wait_task, "pid %d state %ld",
+		p->pid, p->state);
+}
+
+static void probe_kernel_sched_try_wakeup(struct task_struct *p)
+{
+	trace_mark(kernel_sched_try_wakeup, "pid %d state %ld",
+		p->pid, p->state);
+}
+
+static void probe_kernel_sched_wakeup_new_task(struct task_struct *p)
+{
+	trace_mark(kernel_sched_wakeup_new_task, "pid %d state %ld",
+		p->pid, p->state);
+}
+
+static void probe_kernel_sched_schedule(struct task_struct *prev,
+		struct task_struct *next)
+{
+	trace_mark(kernel_sched_schedule,
+		"prev_pid %d next_pid %d prev_state %ld",
+		prev->pid, next->pid, prev->state);
+}
+
+static void probe_kernel_sched_migrate_task(struct task_struct *p, int dest_cpu)
+{
+	trace_mark(kernel_sched_migrate_task, "pid %d state %ld dest_cpu %d",
+		p->pid, p->state, dest_cpu);
+}
+
+static void probe_kernel_signal_send(int sig, struct task_struct *p)
+{
+	trace_mark(kernel_send_signal, "pid %d signal %d", p->pid, sig);
+}
+
+static void probe_kernel_softirq_entry(struct softirq_action *h,
+	struct softirq_action *softirq_vec)
+{
+	trace_mark(kernel_softirq_entry, "softirq_id %lu",
+		((unsigned long)h - (unsigned long)softirq_vec) / sizeof(*h));
+}
+
+static void probe_kernel_softirq_exit(struct softirq_action *h,
+	struct softirq_action *softirq_vec)
+{
+	trace_mark(kernel_softirq_exit, "softirq_id %lu",
+		((unsigned long)h - (unsigned long)softirq_vec) / sizeof(*h));
+}
+
+static void probe_kernel_softirq_raise(unsigned int nr)
+{
+	trace_mark(kernel_softirq_raise, "softirq_id %u", nr);
+}
+
+static void probe_kernel_tasklet_low_entry(struct tasklet_struct *t)
+{
+	trace_mark(kernel_tasklet_low_entry, "func %p data %lu",
+		t->func, t->data);
+}
+
+static void probe_kernel_tasklet_low_exit(struct tasklet_struct *t)
+{
+	trace_mark(kernel_tasklet_low_exit, "func %p data %lu",
+		t->func, t->data);
+}
+
+static void probe_kernel_tasklet_high_entry(struct tasklet_struct *t)
+{
+	trace_mark(kernel_tasklet_high_entry, "func %p data %lu",
+		t->func, t->data);
+}
+
+static void probe_kernel_tasklet_high_exit(struct tasklet_struct *t)
+{
+	trace_mark(kernel_tasklet_high_exit, "func %p data %lu",
+		t->func, t->data);
+}
+
+static void probe_kernel_timer_set(struct timer_list *timer)
+{
+	trace_mark(kernel_timer_set, "expires %lu function %p data %lu",
+		timer->expires, timer->function, timer->data);
+}
+
+static void probe_kernel_timer_update_time(void)
+{
+	trace_mark(kernel_timer_update_time,
+		"jiffies #8u%llu xtime_sec %ld xtime_nsec %ld "
+		"walltomonotonic_sec %ld walltomonotonic_nsec %ld",
+		(unsigned long long)jiffies_64, xtime.tv_sec, xtime.tv_nsec,
+		wall_to_monotonic.tv_sec, wall_to_monotonic.tv_nsec);
+}
+
+static void probe_kernel_timer_timeout(struct task_struct *p)
+{
+	trace_mark(kernel_timer_timeout, "pid %d", p->pid);
+}
+
+static void probe_kernel_process_free(struct task_struct *p)
+{
+	trace_mark(kernel_process_free, "pid %d", p->pid);
+}
+
+static void probe_kernel_process_exit(struct task_struct *p)
+{
+	trace_mark(kernel_process_exit, "pid %d", p->pid);
+}
+
+static void probe_kernel_process_wait(struct pid *pid)
+{
+	trace_mark(kernel_process_wait, "pid %d", pid_nr(pid));
+}
+
+static void probe_kernel_process_fork(struct task_struct *parent,
+		struct task_struct *child)
+{
+	trace_mark(kernel_process_fork,
+		"parent_pid %d child_pid %d child_tgid %d",
+		parent->pid, child->pid, child->tgid);
+}
+
+static void probe_kernel_module_free(struct module *mod)
+{
+	trace_mark(kernel_module_free, "name %s", mod->name);
+}
+
+static void probe_kernel_module_load(struct module *mod)
+{
+	trace_mark(kernel_module_load, "name %s", mod->name);
+}
+
+int __init kernel_trace_init(void)
+{
+	int ret;
+
+	ret = register_trace_kernel_irq_entry(probe_kernel_irq_entry);
+	WARN_ON(ret);
+	ret = register_trace_kernel_irq_exit(probe_kernel_irq_exit);
+	WARN_ON(ret);
+	ret = register_trace_kernel_timer_itimer_expired(
+		probe_kernel_timer_itimer_expired);
+	WARN_ON(ret);
+	ret = register_trace_kernel_timer_itimer_set(
+		probe_kernel_timer_itimer_set);
+	WARN_ON(ret);
+	ret = register_trace_kernel_kthread_stop(probe_kernel_kthread_stop);
+	WARN_ON(ret);
+	ret = register_trace_kernel_kthread_stop_ret(
+		probe_kernel_kthread_stop_ret);
+	WARN_ON(ret);
+	ret = register_trace_kernel_printk(probe_kernel_printk);
+	WARN_ON(ret);
+	ret = register_trace_kernel_vprintk(probe_kernel_vprintk);
+	WARN_ON(ret);
+	ret = register_trace_kernel_sched_wait_task(
+		probe_kernel_sched_wait_task);
+	WARN_ON(ret);
+	ret = register_trace_kernel_sched_try_wakeup(
+		probe_kernel_sched_try_wakeup);
+	WARN_ON(ret);
+	ret = register_trace_kernel_sched_wakeup_new_task(
+		probe_kernel_sched_wakeup_new_task);
+	WARN_ON(ret);
+	ret = register_trace_kernel_sched_schedule(
+		probe_kernel_sched_schedule);
+	WARN_ON(ret);
+	ret = register_trace_kernel_sched_migrate_task(
+		probe_kernel_sched_migrate_task);
+	WARN_ON(ret);
+	ret = register_trace_kernel_signal_send(probe_kernel_signal_send);
+	WARN_ON(ret);
+	ret = register_trace_kernel_softirq_entry(probe_kernel_softirq_entry);
+	WARN_ON(ret);
+	ret = register_trace_kernel_softirq_exit(probe_kernel_softirq_exit);
+	WARN_ON(ret);
+	ret = register_trace_kernel_softirq_raise(probe_kernel_softirq_raise);
+	WARN_ON(ret);
+	ret = register_trace_kernel_tasklet_low_entry(
+		probe_kernel_tasklet_low_entry);
+	WARN_ON(ret);
+	ret = register_trace_kernel_tasklet_low_exit(
+		probe_kernel_tasklet_low_exit);
+	WARN_ON(ret);
+	ret = register_trace_kernel_tasklet_high_entry(
+		probe_kernel_tasklet_high_entry);
+	WARN_ON(ret);
+	ret = register_trace_kernel_tasklet_high_exit(
+		probe_kernel_tasklet_high_exit);
+	WARN_ON(ret);
+	ret = register_trace_kernel_timer_set(probe_kernel_timer_set);
+	WARN_ON(ret);
+	ret = register_trace_kernel_timer_update_time(
+		probe_kernel_timer_update_time);
+	WARN_ON(ret);
+	ret = register_trace_kernel_timer_timeout(probe_kernel_timer_timeout);
+	WARN_ON(ret);
+	ret = register_trace_kernel_process_free(probe_kernel_process_free);
+	WARN_ON(ret);
+	ret = register_trace_kernel_process_exit(probe_kernel_process_exit);
+	WARN_ON(ret);
+	ret = register_trace_kernel_process_wait(probe_kernel_process_wait);
+	WARN_ON(ret);
+	ret = register_trace_kernel_process_fork(probe_kernel_process_fork);
+	WARN_ON(ret);
+	ret = register_trace_kernel_module_free(probe_kernel_module_free);
+	WARN_ON(ret);
+	ret = register_trace_kernel_module_load(probe_kernel_module_load);
+	WARN_ON(ret);
+
+	return 0;
+}
+
+module_init(kernel_trace_init);
+
+void __exit kernel_trace_exit(void)
+{
+	unregister_trace_kernel_module_load(probe_kernel_module_load);
+	unregister_trace_kernel_module_free(probe_kernel_module_free);
+	unregister_trace_kernel_process_fork(probe_kernel_process_fork);
+	unregister_trace_kernel_process_wait(probe_kernel_process_wait);
+	unregister_trace_kernel_process_exit(probe_kernel_process_exit);
+	unregister_trace_kernel_process_free(probe_kernel_process_free);
+	unregister_trace_kernel_timer_timeout(probe_kernel_timer_timeout);
+	unregister_trace_kernel_timer_update_time(
+		probe_kernel_timer_update_time);
+	unregister_trace_kernel_timer_set(probe_kernel_timer_set);
+	unregister_trace_kernel_tasklet_high_exit(
+		probe_kernel_tasklet_high_exit);
+	unregister_trace_kernel_tasklet_high_entry(
+		probe_kernel_tasklet_high_entry);
+	unregister_trace_kernel_tasklet_low_exit(
+		probe_kernel_tasklet_low_exit);
+	unregister_trace_kernel_tasklet_low_entry(
+		probe_kernel_tasklet_low_entry);
+	unregister_trace_kernel_softirq_raise(probe_kernel_softirq_raise);
+	unregister_trace_kernel_softirq_exit(probe_kernel_softirq_exit);
+	unregister_trace_kernel_softirq_entry(probe_kernel_softirq_entry);
+	unregister_trace_kernel_signal_send(probe_kernel_signal_send);
+	unregister_trace_kernel_sched_migrate_task(
+		probe_kernel_sched_migrate_task);
+	unregister_trace_kernel_sched_schedule(probe_kernel_sched_schedule);
+	unregister_trace_kernel_sched_wakeup_new_task(
+		probe_kernel_sched_wakeup_new_task);
+	unregister_trace_kernel_sched_try_wakeup(
+		probe_kernel_sched_try_wakeup);
+	unregister_trace_kernel_sched_wait_task(probe_kernel_sched_wait_task);
+	unregister_trace_kernel_vprintk(probe_kernel_vprintk);
+	unregister_trace_kernel_printk(probe_kernel_printk);
+	unregister_trace_kernel_kthread_stop_ret(probe_kernel_kthread_stop_ret);
+	unregister_trace_kernel_kthread_stop(probe_kernel_kthread_stop);
+	unregister_trace_kernel_timer_itimer_set(probe_kernel_timer_itimer_set);
+	unregister_trace_kernel_timer_itimer_expired(
+		probe_kernel_timer_itimer_expired);
+	unregister_trace_kernel_irq_exit(probe_kernel_irq_exit);
+	unregister_trace_kernel_irq_entry(probe_kernel_irq_entry);
+}
+
+module_exit(kernel_trace_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Mathieu Desnoyers");
+MODULE_DESCRIPTION("kernel Tracepoint Probes");

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
