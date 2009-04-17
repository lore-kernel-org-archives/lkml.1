Return-Path: <linux-kernel-owner+w=401wt.eu-S1761628AbZDQOoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761628AbZDQOoU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 10:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761334AbZDQOnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 10:43:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:62583 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760998AbZDQOnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 10:43:33 -0400
Message-Id: <20090417144331.796749518@goodmis.org>
References: <20090417144055.857407604@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 17 Apr 2009 10:40:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2 2/5] tracing/events: add startup tests for events
Content-Disposition: inline; filename=0002-tracing-events-add-startup-tests-for-events.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

As events start to become popular, and the new way to add tracing
infrastructure into ftrace, it is important to catch any problems
that might happen with a mistake in the TRACE_EVENT macro.

This patch introduces a startup self test on the registered trace
events. Note, it can only do a generic test, any type of testing that
needs more involement is needed to be implemented by the tracepoint
creators.

The test goes down one by one enabling a trace point and running
some random tasks (random in the sense that I just made them up).
Those tasks are creating threads, grabbing mutexes and spinlocks
and using workqueues.

After testing each event individually, it does the same test after
enabling each system of trace points. Like sched, irq, lockdep.

Then finally it enables all tracepoints and performs the tasks again.
The output to the console on bootup will look like this when everything
works:

Running tests on trace events:
Testing event kfree_skb: OK
Testing event kmalloc: OK
Testing event kmem_cache_alloc: OK
Testing event kmalloc_node: OK
Testing event kmem_cache_alloc_node: OK
Testing event kfree: OK
Testing event kmem_cache_free: OK
Testing event irq_handler_exit: OK
Testing event irq_handler_entry: OK
Testing event softirq_entry: OK
Testing event softirq_exit: OK
Testing event lock_acquire: OK
Testing event lock_release: OK
Testing event sched_kthread_stop: OK
Testing event sched_kthread_stop_ret: OK
Testing event sched_wait_task: OK
Testing event sched_wakeup: OK
Testing event sched_wakeup_new: OK
Testing event sched_switch: OK
Testing event sched_migrate_task: OK
Testing event sched_process_free: OK
Testing event sched_process_exit: OK
Testing event sched_process_wait: OK
Testing event sched_process_fork: OK
Testing event sched_signal_send: OK
Running tests on trace event systems:
Testing event system skb: OK
Testing event system kmem: OK
Testing event system irq: OK
Testing event system lockdep: OK
Testing event system sched: OK
Running tests on all trace events:
Testing all events: OK

[ folded in:

  tracing: add #include <linux/delay.h> to fix build failure in test_work()

  This build failure occured on a few rare configs:

   kernel/trace/trace_events.c: In function ‘test_work’:
   kernel/trace/trace_events.c:975: error: implicit declaration of function ‘udelay’
   kernel/trace/trace_events.c:980: error: implicit declaration of function ‘msleep’

  delay.h is included in way too many other headers, hiding cases
  where new usage is added without header inclusion.

  Impact: build fix
  Signed-off-by: Ingo Molnar <mingo@elte.hu>
]

Impact: event tracer self testing
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events.c |  178 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 178 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 6591d83..f81d6ee 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -8,10 +8,14 @@
  *
  */
 
+#include <linux/workqueue.h>
+#include <linux/spinlock.h>
+#include <linux/kthread.h>
 #include <linux/debugfs.h>
 #include <linux/uaccess.h>
 #include <linux/module.h>
 #include <linux/ctype.h>
+#include <linux/delay.h>
 
 #include "trace_output.h"
 
@@ -920,3 +924,177 @@ static __init int event_trace_init(void)
 	return 0;
 }
 fs_initcall(event_trace_init);
+
+#ifdef CONFIG_FTRACE_STARTUP_TEST
+
+static DEFINE_SPINLOCK(test_spinlock);
+static DEFINE_SPINLOCK(test_spinlock_irq);
+static DEFINE_MUTEX(test_mutex);
+
+static __init void test_work(struct work_struct *dummy)
+{
+	spin_lock(&test_spinlock);
+	spin_lock_irq(&test_spinlock_irq);
+	udelay(1);
+	spin_unlock_irq(&test_spinlock_irq);
+	spin_unlock(&test_spinlock);
+
+	mutex_lock(&test_mutex);
+	msleep(1);
+	mutex_unlock(&test_mutex);
+}
+
+static __init int event_test_thread(void *unused)
+{
+	void *test_malloc;
+
+	test_malloc = kmalloc(1234, GFP_KERNEL);
+	if (!test_malloc)
+		pr_info("failed to kmalloc\n");
+
+	schedule_on_each_cpu(test_work);
+
+	kfree(test_malloc);
+
+	set_current_state(TASK_INTERRUPTIBLE);
+	while (!kthread_should_stop())
+		schedule();
+
+	return 0;
+}
+
+/*
+ * Do various things that may trigger events.
+ */
+static __init void event_test_stuff(void)
+{
+	struct task_struct *test_thread;
+
+	test_thread = kthread_run(event_test_thread, NULL, "test-events");
+	msleep(1);
+	kthread_stop(test_thread);
+}
+
+/*
+ * For every trace event defined, we will test each trace point separately,
+ * and then by groups, and finally all trace points.
+ */
+static __init int event_trace_self_tests(void)
+{
+	struct ftrace_event_call *call;
+	struct event_subsystem *system;
+	char *sysname;
+	int ret;
+
+	pr_info("Running tests on trace events:\n");
+
+	list_for_each_entry(call, &ftrace_events, list) {
+
+		/* Only test those that have a regfunc */
+		if (!call->regfunc)
+			continue;
+
+		pr_info("Testing event %s: ", call->name);
+
+		/*
+		 * If an event is already enabled, someone is using
+		 * it and the self test should not be on.
+		 */
+		if (call->enabled) {
+			pr_warning("Enabled event during self test!\n");
+			WARN_ON_ONCE(1);
+			continue;
+		}
+
+		call->enabled = 1;
+		call->regfunc();
+
+		event_test_stuff();
+
+		call->unregfunc();
+		call->enabled = 0;
+
+		pr_cont("OK\n");
+	}
+
+	/* Now test at the sub system level */
+
+	pr_info("Running tests on trace event systems:\n");
+
+	list_for_each_entry(system, &event_subsystems, list) {
+
+		/* the ftrace system is special, skip it */
+		if (strcmp(system->name, "ftrace") == 0)
+			continue;
+
+		pr_info("Testing event system %s: ", system->name);
+
+		/* ftrace_set_clr_event can modify the name passed in. */
+		sysname = kstrdup(system->name, GFP_KERNEL);
+		if (WARN_ON(!sysname)) {
+			pr_warning("Can't allocate memory, giving up!\n");
+			return 0;
+		}
+		ret = ftrace_set_clr_event(sysname, 1);
+		kfree(sysname);
+		if (WARN_ON_ONCE(ret)) {
+			pr_warning("error enabling system %s\n",
+				   system->name);
+			continue;
+		}
+
+		event_test_stuff();
+
+		sysname = kstrdup(system->name, GFP_KERNEL);
+		if (WARN_ON(!sysname)) {
+			pr_warning("Can't allocate memory, giving up!\n");
+			return 0;
+		}
+		ret = ftrace_set_clr_event(sysname, 0);
+		kfree(sysname);
+
+		if (WARN_ON_ONCE(ret))
+			pr_warning("error disabling system %s\n",
+				   system->name);
+
+		pr_cont("OK\n");
+	}
+
+	/* Test with all events enabled */
+
+	pr_info("Running tests on all trace events:\n");
+	pr_info("Testing all events: ");
+
+	sysname = kmalloc(4, GFP_KERNEL);
+	if (WARN_ON(!sysname)) {
+		pr_warning("Can't allocate memory, giving up!\n");
+		return 0;
+	}
+	memcpy(sysname, "*:*", 4);
+	ret = ftrace_set_clr_event(sysname, 1);
+	if (WARN_ON_ONCE(ret)) {
+		kfree(sysname);
+		pr_warning("error enabling all events\n");
+		return 0;
+	}
+
+	event_test_stuff();
+
+	/* reset sysname */
+	memcpy(sysname, "*:*", 4);
+	ret = ftrace_set_clr_event(sysname, 0);
+	kfree(sysname);
+
+	if (WARN_ON_ONCE(ret)) {
+		pr_warning("error disabling all events\n");
+		return 0;
+	}
+
+	pr_cont("OK\n");
+
+	return 0;
+}
+
+late_initcall(event_trace_self_tests);
+
+#endif
-- 
1.6.2.1

-- 
