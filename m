Return-Path: <linux-kernel-owner+w=401wt.eu-S1754264AbYJLXpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264AbYJLXpm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 19:45:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754328AbYJLXpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 19:45:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:53701 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048AbYJLXpR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 19:45:17 -0400
Date: Sun, 12 Oct 2008 19:44:27 -0400
From: Arjan van de Ven <arjan@infradead.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: [PATCH] fastboot: Introduce an asynchronous function call mechanism
Message-ID: <20081012194427.2e21c22e@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

after the discussion on fastboot I came up with the following patch
(this was all done at 35000 feet so if it's h0rked .. I'll claim lack of oxygen)

I'll also reply to this email with 2 users of the new infrastructure just to show how it'd be used.



>From c5fd398d7210bcdc726dc813523d8b4c58481553 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sun, 12 Oct 2008 15:27:22 -0400
Subject: [PATCH] fastboot: Introduce an asynchronous function call mechanism

During the system boot there are many things that take a long time
and also can be done asynchronous; this patch introduces a call_async()
function that implements a pool of threads to execute the asynchronous
calls.

The calls are divided into pools, and within a pool the calls are processed
in order; this is done to preserve stable device numbers.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 include/linux/workqueue.h |   16 +++
 init/main.c               |    4 +-
 kernel/Makefile           |    2 +-
 kernel/asynccall.c        |  224 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 244 insertions(+), 2 deletions(-)
 create mode 100644 kernel/asynccall.c

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 5c158c4..8122aff 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -238,4 +238,20 @@ void cancel_rearming_delayed_work(struct delayed_work *work)
 	cancel_delayed_work_sync(work);
 }
 
+
+
+/* async call infrastructure */
+extern void init_async_calls(void);
+extern void end_async_calls(void);
+extern void call_async(int pool_number, int argc, ...);
+
+#define ASYNC_POOL_SCSI	 0	/* for everything using the scsi device space */
+#define ASYNC_POOL_IDE	 1	/* for everything using the ide device space */
+#define ASYNC_POOL_USB	 2	/* for everything using the usb device space */
+#define ASYNC_POOL_MISC	 4	/* for everything using the misc device space */
+#define ASYNC_POOL_SOUND 5	/* for everything using the ALSA device space */
+#define ASYNC_POOL_AGP   6	/* for everything using the AGP device space */
+#define ASYNC_MAX_POOL	 7
+
+
 #endif
diff --git a/init/main.c b/init/main.c
index 3820323..b3ebf60 100644
--- a/init/main.c
+++ b/init/main.c
@@ -691,7 +691,7 @@ asmlinkage void __init start_kernel(void)
 	rest_init();
 }
 
-static int initcall_debug;
+int initcall_debug;
 
 static int __init initcall_debug_setup(char *str)
 {
@@ -769,10 +769,12 @@ static void __init do_basic_setup(void)
 	rcu_init_sched(); /* needed by module_init stage. */
 	/* drivers will send hotplug events */
 	init_workqueues();
+	init_async_calls();
 	usermodehelper_init();
 	driver_init();
 	init_irq_proc();
 	do_initcalls();
+	end_async_calls();
 }
 
 static void __init do_pre_smp_initcalls(void)
diff --git a/kernel/Makefile b/kernel/Makefile
index 4e1d7df..8e0aae9 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -9,7 +9,7 @@ obj-y     = sched.o fork.o exec_domain.o panic.o printk.o \
 	    rcupdate.o extable.o params.o posix-timers.o \
 	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
 	    hrtimer.o rwsem.o nsproxy.o srcu.o semaphore.o \
-	    notifier.o ksysfs.o pm_qos_params.o sched_clock.o
+	    notifier.o ksysfs.o pm_qos_params.o sched_clock.o asynccall.o
 
 CFLAGS_REMOVE_sched.o = -mno-spe
 
diff --git a/kernel/asynccall.c b/kernel/asynccall.c
new file mode 100644
index 0000000..1eb5930
--- /dev/null
+++ b/kernel/asynccall.c
@@ -0,0 +1,224 @@
+/*
+ * asynccall.c: Simple asynchronous function call mechanism
+ *
+ * Note: If you want to schedule some delayed work, this is not
+ * the place to look. You want to look in workqueue.c instead.
+ *
+ * callqueue's are aimed at running certain portions of the boot
+ * process asynchronous and not more than that. During regular
+ * kernel boot, these asynchronous calls are actually executed
+ * synchronously (for now).
+ *
+ * For those who wonder why async calls don't use work queues,
+ * the answer is that the object lifecycle rules of work queues
+ * don't work well for the async call purpose.
+ *
+ * (C) Copyright 2008 Intel Corporation
+ * Author: Arjan van de Ven <arjan@linux.intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#include <linux/list.h>
+#include <linux/workqueue.h>
+#include <linux/wait.h>
+#include <linux/hrtimer.h>
+#include <linux/slab.h>
+#include <linux/kthread.h>
+#include <linux/module.h>
+#include <linux/spinlock.h>
+
+#include <stdarg.h>
+
+static int async_active = 0;
+
+typedef int (*async_func_t_0)(void);
+typedef int (*async_func_t_1)(void *);
+typedef int (*async_func_t_2)(void *, void *);
+typedef int (*async_func_t_3)(void *, void *, void *);
+typedef int (*async_func_t_4)(void *, void *, void *, void *);
+
+
+struct async_item {
+	struct list_head list;
+
+	async_func_t_0 	func;
+	int		argument_count;
+	void		*arg1;
+	void		*arg2;
+	void		*arg3;
+	void		*arg4;
+};
+
+
+static struct list_head list_pool[ASYNC_MAX_POOL + 1];
+static struct task_struct * thread_pool[ASYNC_MAX_POOL + 1];
+static wait_queue_head_t waitqueue_pool[ASYNC_MAX_POOL + 1];
+static int pool_count[ASYNC_MAX_POOL + 1];
+
+static spinlock_t pool_lock;
+
+extern int initcall_debug;
+
+static void do_async_item(struct async_item *item)
+{
+	ktime_t t0, t1, delta;
+	int result;
+	async_func_t_0 fn0 = item->func;
+	async_func_t_1 fn1 = (async_func_t_1)item->func;
+	async_func_t_2 fn2 = (async_func_t_2)item->func;
+	async_func_t_3 fn3 = (async_func_t_3)item->func;
+	async_func_t_4 fn4 = (async_func_t_4)item->func;
+
+	if (initcall_debug) {
+		printk("calling  %pF @ %i\n", item->func,
+			task_pid_nr(current));
+		t0 = ktime_get();
+	}
+
+	switch (item->argument_count) {
+	case 0:
+		result = fn0();
+		break;
+	case 1:
+		result = fn1(item->arg1);
+		break;
+	case 2:
+		result = fn2(item->arg1, item->arg2);
+		break;
+	case 3:
+		result = fn3(item->arg1, item->arg2, item->arg3);
+		break;
+	case 4:
+		result = fn4(item->arg1, item->arg2, item->arg3, item->arg4);
+		break;
+	default:
+		result = 0;
+		WARN_ON(1);
+	}
+	if (initcall_debug) {
+		t1 = ktime_get();
+		delta = ktime_sub(t1, t0);
+
+		printk("asynccall %pF returned %d after %Ld msecs\n",
+			item->func, result,
+			(unsigned long long) delta.tv64 >> 20);
+	}
+}
+
+
+static int async_thread(void *data)
+{
+	int pool = (unsigned long) data;
+
+	DECLARE_WAITQUEUE(wq, current);
+
+	add_wait_queue(&waitqueue_pool[pool], &wq);
+
+	while (!kthread_should_stop()) {
+		struct async_item *item = NULL;
+
+		spin_lock(&pool_lock);
+		set_current_state(TASK_INTERRUPTIBLE);
+		if (!list_empty(&list_pool[pool])) {
+			item = list_first_entry(&list_pool[pool], struct async_item, list);
+			list_del(&item->list);
+			pool_count[pool]--;
+		}
+		spin_unlock(&pool_lock);
+
+		if (!item) {
+			schedule();
+			continue;
+		}
+		__set_current_state(TASK_RUNNING);
+		do_async_item(item);
+		kfree(item);
+		wake_up(&waitqueue_pool[pool]);
+	}
+	return 0;
+}
+
+
+void init_async_calls(void)
+{
+	unsigned long i;
+	spin_lock_init(&pool_lock);
+	for (i = 0; i <= ASYNC_MAX_POOL; i++) {
+		INIT_LIST_HEAD(&list_pool[i]);
+		init_waitqueue_head(&waitqueue_pool[i]);
+		thread_pool[i] = kthread_run(&async_thread, (void *)i, "kasyncd/%li", i);
+	}
+	async_active = 1;
+}
+
+
+void call_async(int pool_number, int argc, ...)
+{
+	struct async_item *item;
+	va_list ap;
+
+	if (argc > 4 || argc < 0) {
+		WARN(1, KERN_ERR "Too many arguments to async function! Skipping...\n");
+		return;
+	}
+
+	item = kmalloc(sizeof(struct async_item), GFP_ATOMIC);
+	item->argument_count = argc;
+	va_start(ap, argc);
+	item->func = va_arg(ap, async_func_t_0);
+	if (argc > 0)
+		item->arg1 = va_arg(ap, void *);
+	if (argc > 1)
+		item->arg2 = va_arg(ap, void *);
+	if (argc > 2)
+		item->arg3 = va_arg(ap, void *);
+	if (argc > 4)
+		item->arg3 = va_arg(ap, void *);
+	va_end(ap);
+
+	/* If we're not yet or no longer active, just process the work item in place */
+	if (!async_active) {
+		do_async_item(item);
+		kfree(item);
+		return;
+	}
+	spin_lock(&pool_lock);
+	pool_count[pool_number]++;
+	list_add_tail(&item->list, &list_pool[pool_number]);
+	wake_up(&waitqueue_pool[pool_number]);
+	spin_unlock(&pool_lock);
+}
+EXPORT_SYMBOL_GPL(call_async);
+
+static void wait_until_done(int pool)
+{
+	wait_event(waitqueue_pool[pool], pool_count[pool] == 0);
+}
+
+/**
+ * end_async_calls - Shut down the async call subsystem
+ * 
+ */
+void end_async_calls(void)
+{
+	int i;
+
+	if (!async_active)
+		return;
+
+	async_active = 0;
+	/* 
+	 * make sure all CPUs see the "no more queueing" before we empty the queue
+	 */
+	wmb(); 
+
+	for (i = 0; i <= ASYNC_MAX_POOL; i++)
+		wait_until_done(i);
+
+	for (i = 0; i <= ASYNC_MAX_POOL; i++)
+		kthread_stop(thread_pool[i]);
+}
-- 
1.5.5.1


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
