Return-Path: <linux-kernel-owner+w=401wt.eu-S1755483Ab0ARAzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483Ab0ARAzk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 19:55:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753515Ab0ARAy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 19:54:58 -0500
Received: from hera.kernel.org ([140.211.167.34]:54497 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755419Ab0ARAyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 19:54:10 -0500
From: Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
Cc: Tejun Heo <tj@kernel.org>, Arjan van de Ven <arjan@infradead.org>
Subject: [PATCH 32/40] async: introduce workqueue based alternative implementation
Date: Mon, 18 Jan 2010 09:57:44 +0900
Message-Id: <1263776272-382-33-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1263776272-382-1-git-send-email-tj@kernel.org>
References: <1263776272-382-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 18 Jan 2010 00:52:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that cmwq can handle high concurrency, there's no reason to
implement separate thread pool for async.  Introduce alternative
implementation based on workqueue.

The new implementation uses two workqueues - async_wq and
async_ordered_wq.  The former multithreaded and the latter
singlethreaded.  async_call() schedules unordered asynchronous
excution on async_wq.  async_call_ordered() schedules ordered excution
on async_ordered_wq.  Functions scheduled using the ordered variant
are guaranteed to be excecuted only after all async excutions
scheduled previously have finished.

This patch doesn't convert any existing user.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Arjan van de Ven <arjan@infradead.org>
---
 drivers/base/core.c    |    1 +
 drivers/base/dd.c      |    1 +
 include/linux/async.h  |    6 ++
 init/do_mounts.c       |    1 +
 init/main.c            |    1 +
 kernel/async.c         |  147 ++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/irq/autoprobe.c |    1 +
 kernel/module.c        |    2 +
 8 files changed, 160 insertions(+), 0 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 2820257..14774c9 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1744,4 +1744,5 @@ void device_shutdown(void)
 		}
 	}
 	async_synchronize_full();
+	async_barrier();
 }
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index ee95c76..5c9c923 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -179,6 +179,7 @@ void wait_for_device_probe(void)
 	/* wait for the known devices to complete their probing */
 	wait_event(probe_waitqueue, atomic_read(&probe_count) == 0);
 	async_synchronize_full();
+	async_barrier();
 }
 EXPORT_SYMBOL_GPL(wait_for_device_probe);
 
diff --git a/include/linux/async.h b/include/linux/async.h
index 68a9530..49658dc 100644
--- a/include/linux/async.h
+++ b/include/linux/async.h
@@ -12,6 +12,7 @@
 
 #include <linux/types.h>
 #include <linux/list.h>
+#include <linux/workqueue.h>
 
 typedef u64 async_cookie_t;
 typedef void (async_func_ptr) (void *data, async_cookie_t cookie);
@@ -25,3 +26,8 @@ extern void async_synchronize_cookie(async_cookie_t cookie);
 extern void async_synchronize_cookie_domain(async_cookie_t cookie,
 					    struct list_head *list);
 
+typedef void (*async_func_t)(void *data);
+
+extern bool async_call(async_func_t func, void *data);
+extern bool async_call_ordered(async_func_t func, void *data);
+extern void async_barrier(void);
diff --git a/init/do_mounts.c b/init/do_mounts.c
index bb008d0..608ac17 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -406,6 +406,7 @@ void __init prepare_namespace(void)
 			(ROOT_DEV = name_to_dev_t(saved_root_name)) == 0)
 			msleep(100);
 		async_synchronize_full();
+		async_barrier();
 	}
 
 	is_floppy = MAJOR(ROOT_DEV) == FLOPPY_MAJOR;
diff --git a/init/main.c b/init/main.c
index adb09f8..e35dfdd 100644
--- a/init/main.c
+++ b/init/main.c
@@ -802,6 +802,7 @@ static noinline int init_post(void)
 {
 	/* need to finish all async __init code before freeing the memory */
 	async_synchronize_full();
+	async_barrier();
 	free_initmem();
 	unlock_kernel();
 	mark_rodata_ro();
diff --git a/kernel/async.c b/kernel/async.c
index 27235f5..4cd52bc 100644
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -395,3 +395,150 @@ static int __init async_init(void)
 }
 
 core_initcall(async_init);
+
+struct async_ent {
+	struct work_struct	work;
+	async_func_t		func;
+	void			*data;
+	bool			ordered;
+};
+
+static struct workqueue_struct *async_wq;
+static struct workqueue_struct *async_ordered_wq;
+
+static void async_work_func(struct work_struct *work)
+{
+	struct async_ent *ent = container_of(work, struct async_ent, work);
+	ktime_t calltime, delta, rettime;
+
+	if (initcall_debug && system_state == SYSTEM_BOOTING) {
+		printk("calling  %pF @ %i\n",
+		       ent->func, task_pid_nr(current));
+		calltime = ktime_get();
+	}
+
+	if (ent->ordered)
+		flush_workqueue(async_wq);
+
+	ent->func(ent->data);
+
+	if (initcall_debug && system_state == SYSTEM_BOOTING) {
+		rettime = ktime_get();
+		delta = ktime_sub(rettime, calltime);
+		printk("initcall %pF returned 0 after %lld usecs\n",
+		       ent->func, (long long)ktime_to_ns(delta) >> 10);
+	}
+}
+
+static bool __async_call(async_func_t func, void *data, bool ordered)
+{
+	struct async_ent *ent;
+
+	ent = kzalloc(sizeof(struct async_ent), GFP_ATOMIC);
+	if (!ent) {
+		kfree(ent);
+		if (ordered) {
+			flush_workqueue(async_wq);
+			flush_workqueue(async_ordered_wq);
+		}
+		func(data);
+		return false;
+	}
+
+	ent->func = func;
+	ent->data = data;
+	ent->ordered = ordered;
+	/*
+	 * Use separate INIT_WORK for sync and async so that they end
+	 * up with different lockdep keys.
+	 */
+	if (ordered) {
+		INIT_WORK(&ent->work, async_work_func);
+		queue_work(async_ordered_wq, &ent->work);
+	} else {
+		INIT_WORK(&ent->work, async_work_func);
+		queue_work(async_wq, &ent->work);
+	}
+	return true;
+}
+
+/**
+ * async_call - schedule a function for asynchronous execution
+ * @func: function to execute asynchronously
+ * @data: data pointer to pass to the function
+ *
+ * Schedule @func(@data) for asynchronous execution.  The function
+ * might be called directly if memory allocation fails.
+ *
+ * CONTEXT:
+ * Don't care but keep in mind that @func may be executed directly.
+ *
+ * RETURNS:
+ * %true if async execution is scheduled, %false if executed locally.
+ */
+bool async_call(async_func_t func, void *data)
+{
+	return __async_call(func, data, false);
+}
+EXPORT_SYMBOL_GPL(async_call);
+
+/**
+ * async_call_ordered - schedule ordered asynchronous execution
+ * @func: function to execute asynchronously
+ * @data: data pointer to pass to the function
+ *
+ * Schedule @func(data) for ordered asynchronous excution.  It will be
+ * executed only after all async functions scheduled upto this point
+ * have finished.
+ *
+ * CONTEXT:
+ * Might sleep.
+ *
+ * RETURNS:
+ * %true if async execution is scheduled, %false if executed locally.
+ */
+bool async_call_ordered(async_func_t func, void *data)
+{
+	might_sleep();
+	return __async_call(func, data, true);
+}
+EXPORT_SYMBOL_GPL(async_call_ordered);
+
+/**
+ * async_barrier - asynchronous execution barrier
+ *
+ * Wait till all currently scheduled async executions are finished.
+ *
+ * CONTEXT:
+ * Might sleep.
+ */
+void async_barrier(void)
+{
+	ktime_t starttime, delta, endtime;
+
+	if (initcall_debug && system_state == SYSTEM_BOOTING) {
+		printk("async_waiting @ %i\n", task_pid_nr(current));
+		starttime = ktime_get();
+	}
+
+	flush_workqueue(async_wq);
+	flush_workqueue(async_ordered_wq);
+
+	if (initcall_debug && system_state == SYSTEM_BOOTING) {
+		endtime = ktime_get();
+		delta = ktime_sub(endtime, starttime);
+		printk("async_continuing @ %i after %lli usec\n",
+		       task_pid_nr(current),
+		       (long long)ktime_to_ns(delta) >> 10);
+	}
+}
+EXPORT_SYMBOL_GPL(async_barrier);
+
+static int __init init_async(void)
+{
+	async_wq = __create_workqueue("async", 0, WQ_MAX_ACTIVE);
+	async_ordered_wq = create_singlethread_workqueue("async_ordered");
+	BUG_ON(!async_wq || !async_ordered_wq);
+	return 0;
+}
+core_initcall(init_async);
diff --git a/kernel/irq/autoprobe.c b/kernel/irq/autoprobe.c
index 2295a31..39188cd 100644
--- a/kernel/irq/autoprobe.c
+++ b/kernel/irq/autoprobe.c
@@ -39,6 +39,7 @@ unsigned long probe_irq_on(void)
 	 * quiesce the kernel, or at least the asynchronous portion
 	 */
 	async_synchronize_full();
+	async_barrier();
 	mutex_lock(&probing_active);
 	/*
 	 * something may have generated an irq long ago and we want to
diff --git a/kernel/module.c b/kernel/module.c
index f82386b..623a9b6 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -717,6 +717,7 @@ SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
 	blocking_notifier_call_chain(&module_notify_list,
 				     MODULE_STATE_GOING, mod);
 	async_synchronize_full();
+	async_barrier();
 	mutex_lock(&module_mutex);
 	/* Store the name of the last unloaded module for diagnostic purposes */
 	strlcpy(last_unloaded_module, mod->name, sizeof(last_unloaded_module));
@@ -2494,6 +2495,7 @@ SYSCALL_DEFINE3(init_module, void __user *, umod,
 
 	/* We need to finish all async code before the module init sequence is done */
 	async_synchronize_full();
+	async_barrier();
 
 	mutex_lock(&module_mutex);
 	/* Drop initial reference. */
-- 
1.6.4.2

