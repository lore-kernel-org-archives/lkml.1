Return-Path: <linux-kernel-owner+w=401wt.eu-S1755470Ab0ARAya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470Ab0ARAya (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 19:54:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755435Ab0ARAyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 19:54:20 -0500
Received: from hera.kernel.org ([140.211.167.34]:54511 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755402Ab0ARAyQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 19:54:16 -0500
From: Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
Cc: Tejun Heo <tj@kernel.org>, Arjan van de Ven <arjan@infradead.org>
Subject: [PATCH 34/40] async: kill original implementation
Date: Mon, 18 Jan 2010 09:57:46 +0900
Message-Id: <1263776272-382-35-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1263776272-382-1-git-send-email-tj@kernel.org>
References: <1263776272-382-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 18 Jan 2010 00:52:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original implementation doesn't have any user now.  Kill it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Arjan van de Ven <arjan@infradead.org>
---
 drivers/base/core.c    |    1 -
 drivers/base/dd.c      |    1 -
 include/linux/async.h  |   13 --
 init/do_mounts.c       |    1 -
 init/main.c            |    1 -
 kernel/async.c         |  366 +-----------------------------------------------
 kernel/irq/autoprobe.c |    1 -
 kernel/module.c        |    2 -
 8 files changed, 3 insertions(+), 383 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 14774c9..20dbf59 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1743,6 +1743,5 @@ void device_shutdown(void)
 			dev->driver->shutdown(dev);
 		}
 	}
-	async_synchronize_full();
 	async_barrier();
 }
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 5c9c923..8c187db 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -178,7 +178,6 @@ void wait_for_device_probe(void)
 {
 	/* wait for the known devices to complete their probing */
 	wait_event(probe_waitqueue, atomic_read(&probe_count) == 0);
-	async_synchronize_full();
 	async_barrier();
 }
 EXPORT_SYMBOL_GPL(wait_for_device_probe);
diff --git a/include/linux/async.h b/include/linux/async.h
index 49658dc..da9eee7 100644
--- a/include/linux/async.h
+++ b/include/linux/async.h
@@ -11,21 +11,8 @@
  */
 
 #include <linux/types.h>
-#include <linux/list.h>
 #include <linux/workqueue.h>
 
-typedef u64 async_cookie_t;
-typedef void (async_func_ptr) (void *data, async_cookie_t cookie);
-
-extern async_cookie_t async_schedule(async_func_ptr *ptr, void *data);
-extern async_cookie_t async_schedule_domain(async_func_ptr *ptr, void *data,
-					    struct list_head *list);
-extern void async_synchronize_full(void);
-extern void async_synchronize_full_domain(struct list_head *list);
-extern void async_synchronize_cookie(async_cookie_t cookie);
-extern void async_synchronize_cookie_domain(async_cookie_t cookie,
-					    struct list_head *list);
-
 typedef void (*async_func_t)(void *data);
 
 extern bool async_call(async_func_t func, void *data);
diff --git a/init/do_mounts.c b/init/do_mounts.c
index 608ac17..f84f552 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -405,7 +405,6 @@ void __init prepare_namespace(void)
 		while (driver_probe_done() != 0 ||
 			(ROOT_DEV = name_to_dev_t(saved_root_name)) == 0)
 			msleep(100);
-		async_synchronize_full();
 		async_barrier();
 	}
 
diff --git a/init/main.c b/init/main.c
index e35dfdd..04c67fe 100644
--- a/init/main.c
+++ b/init/main.c
@@ -801,7 +801,6 @@ static noinline int init_post(void)
 	__releases(kernel_lock)
 {
 	/* need to finish all async __init code before freeing the memory */
-	async_synchronize_full();
 	async_barrier();
 	free_initmem();
 	unlock_kernel();
diff --git a/kernel/async.c b/kernel/async.c
index 4cd52bc..ddc2499 100644
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -13,8 +13,6 @@
 
 /*
 
-Goals and Theory of Operation
-
 The primary goal of this feature is to reduce the kernel boot time,
 by doing various independent hardware delays and discovery operations
 decoupled and not strictly serialized.
@@ -25,377 +23,19 @@ asynchronously, out of order, while these operations still
 have their externally visible parts happen sequentially and in-order.
 (not unlike how out-of-order CPUs retire their instructions in order)
 
-Key to the asynchronous function call implementation is the concept of
-a "sequence cookie" (which, although it has an abstracted type, can be
-thought of as a monotonically incrementing number).
-
-The async core will assign each scheduled event such a sequence cookie and
-pass this to the called functions.
-
-The asynchronously called function should before doing a globally visible
-operation, such as registering device numbers, call the
-async_synchronize_cookie() function and pass in its own cookie. The
-async_synchronize_cookie() function will make sure that all asynchronous
-operations that were scheduled prior to the operation corresponding with the
-cookie have completed.
-
-Subsystem/driver initialization code that scheduled asynchronous probe
-functions, but which shares global resources with other drivers/subsystems
-that do not use the asynchronous call feature, need to do a full
-synchronization with the async_synchronize_full() function, before returning
-from their init function. This is to maintain strict ordering between the
-asynchronous and synchronous parts of the kernel.
+Parts can be executed in parallel should be scheduled via async_call()
+while parts which need to be executed sequentially to implement
+in-order appearance via async_call_ordered().
 
 */
 
 #include <linux/async.h>
-#include <linux/bug.h>
 #include <linux/module.h>
-#include <linux/wait.h>
 #include <linux/sched.h>
-#include <linux/init.h>
-#include <linux/kthread.h>
 #include <linux/delay.h>
-#include <asm/atomic.h>
-
-static async_cookie_t next_cookie = 1;
-
-#define MAX_THREADS	256
-#define MAX_WORK	32768
-
-static LIST_HEAD(async_pending);
-static LIST_HEAD(async_running);
-static DEFINE_SPINLOCK(async_lock);
-
-static int async_enabled = 0;
-
-struct async_entry {
-	struct list_head list;
-	async_cookie_t   cookie;
-	async_func_ptr	 *func;
-	void             *data;
-	struct list_head *running;
-};
-
-static DECLARE_WAIT_QUEUE_HEAD(async_done);
-static DECLARE_WAIT_QUEUE_HEAD(async_new);
-
-static atomic_t entry_count;
-static atomic_t thread_count;
 
 extern int initcall_debug;
 
-
-/*
- * MUST be called with the lock held!
- */
-static async_cookie_t  __lowest_in_progress(struct list_head *running)
-{
-	struct async_entry *entry;
-
-	if (!list_empty(running)) {
-		entry = list_first_entry(running,
-			struct async_entry, list);
-		return entry->cookie;
-	}
-
-	list_for_each_entry(entry, &async_pending, list)
-		if (entry->running == running)
-			return entry->cookie;
-
-	return next_cookie;	/* "infinity" value */
-}
-
-static async_cookie_t  lowest_in_progress(struct list_head *running)
-{
-	unsigned long flags;
-	async_cookie_t ret;
-
-	spin_lock_irqsave(&async_lock, flags);
-	ret = __lowest_in_progress(running);
-	spin_unlock_irqrestore(&async_lock, flags);
-	return ret;
-}
-/*
- * pick the first pending entry and run it
- */
-static void run_one_entry(void)
-{
-	unsigned long flags;
-	struct async_entry *entry;
-	ktime_t calltime, delta, rettime;
-
-	/* 1) pick one task from the pending queue */
-
-	spin_lock_irqsave(&async_lock, flags);
-	if (list_empty(&async_pending))
-		goto out;
-	entry = list_first_entry(&async_pending, struct async_entry, list);
-
-	/* 2) move it to the running queue */
-	list_move_tail(&entry->list, entry->running);
-	spin_unlock_irqrestore(&async_lock, flags);
-
-	/* 3) run it (and print duration)*/
-	if (initcall_debug && system_state == SYSTEM_BOOTING) {
-		printk("calling  %lli_%pF @ %i\n", (long long)entry->cookie,
-			entry->func, task_pid_nr(current));
-		calltime = ktime_get();
-	}
-	entry->func(entry->data, entry->cookie);
-	if (initcall_debug && system_state == SYSTEM_BOOTING) {
-		rettime = ktime_get();
-		delta = ktime_sub(rettime, calltime);
-		printk("initcall %lli_%pF returned 0 after %lld usecs\n",
-			(long long)entry->cookie,
-			entry->func,
-			(long long)ktime_to_ns(delta) >> 10);
-	}
-
-	/* 4) remove it from the running queue */
-	spin_lock_irqsave(&async_lock, flags);
-	list_del(&entry->list);
-
-	/* 5) free the entry  */
-	kfree(entry);
-	atomic_dec(&entry_count);
-
-	spin_unlock_irqrestore(&async_lock, flags);
-
-	/* 6) wake up any waiters. */
-	wake_up(&async_done);
-	return;
-
-out:
-	spin_unlock_irqrestore(&async_lock, flags);
-}
-
-
-static async_cookie_t __async_schedule(async_func_ptr *ptr, void *data, struct list_head *running)
-{
-	struct async_entry *entry;
-	unsigned long flags;
-	async_cookie_t newcookie;
-	
-
-	/* allow irq-off callers */
-	entry = kzalloc(sizeof(struct async_entry), GFP_ATOMIC);
-
-	/*
-	 * If we're out of memory or if there's too much work
-	 * pending already, we execute synchronously.
-	 */
-	if (!async_enabled || !entry || atomic_read(&entry_count) > MAX_WORK) {
-		kfree(entry);
-		spin_lock_irqsave(&async_lock, flags);
-		newcookie = next_cookie++;
-		spin_unlock_irqrestore(&async_lock, flags);
-
-		/* low on memory.. run synchronously */
-		ptr(data, newcookie);
-		return newcookie;
-	}
-	entry->func = ptr;
-	entry->data = data;
-	entry->running = running;
-
-	spin_lock_irqsave(&async_lock, flags);
-	newcookie = entry->cookie = next_cookie++;
-	list_add_tail(&entry->list, &async_pending);
-	atomic_inc(&entry_count);
-	spin_unlock_irqrestore(&async_lock, flags);
-	wake_up(&async_new);
-	return newcookie;
-}
-
-/**
- * async_schedule - schedule a function for asynchronous execution
- * @ptr: function to execute asynchronously
- * @data: data pointer to pass to the function
- *
- * Returns an async_cookie_t that may be used for checkpointing later.
- * Note: This function may be called from atomic or non-atomic contexts.
- */
-async_cookie_t async_schedule(async_func_ptr *ptr, void *data)
-{
-	return __async_schedule(ptr, data, &async_running);
-}
-EXPORT_SYMBOL_GPL(async_schedule);
-
-/**
- * async_schedule_domain - schedule a function for asynchronous execution within a certain domain
- * @ptr: function to execute asynchronously
- * @data: data pointer to pass to the function
- * @running: running list for the domain
- *
- * Returns an async_cookie_t that may be used for checkpointing later.
- * @running may be used in the async_synchronize_*_domain() functions
- * to wait within a certain synchronization domain rather than globally.
- * A synchronization domain is specified via the running queue @running to use.
- * Note: This function may be called from atomic or non-atomic contexts.
- */
-async_cookie_t async_schedule_domain(async_func_ptr *ptr, void *data,
-				     struct list_head *running)
-{
-	return __async_schedule(ptr, data, running);
-}
-EXPORT_SYMBOL_GPL(async_schedule_domain);
-
-/**
- * async_synchronize_full - synchronize all asynchronous function calls
- *
- * This function waits until all asynchronous function calls have been done.
- */
-void async_synchronize_full(void)
-{
-	do {
-		async_synchronize_cookie(next_cookie);
-	} while (!list_empty(&async_running) || !list_empty(&async_pending));
-}
-EXPORT_SYMBOL_GPL(async_synchronize_full);
-
-/**
- * async_synchronize_full_domain - synchronize all asynchronous function within a certain domain
- * @list: running list to synchronize on
- *
- * This function waits until all asynchronous function calls for the
- * synchronization domain specified by the running list @list have been done.
- */
-void async_synchronize_full_domain(struct list_head *list)
-{
-	async_synchronize_cookie_domain(next_cookie, list);
-}
-EXPORT_SYMBOL_GPL(async_synchronize_full_domain);
-
-/**
- * async_synchronize_cookie_domain - synchronize asynchronous function calls within a certain domain with cookie checkpointing
- * @cookie: async_cookie_t to use as checkpoint
- * @running: running list to synchronize on
- *
- * This function waits until all asynchronous function calls for the
- * synchronization domain specified by the running list @list submitted
- * prior to @cookie have been done.
- */
-void async_synchronize_cookie_domain(async_cookie_t cookie,
-				     struct list_head *running)
-{
-	ktime_t starttime, delta, endtime;
-
-	if (initcall_debug && system_state == SYSTEM_BOOTING) {
-		printk("async_waiting @ %i\n", task_pid_nr(current));
-		starttime = ktime_get();
-	}
-
-	wait_event(async_done, lowest_in_progress(running) >= cookie);
-
-	if (initcall_debug && system_state == SYSTEM_BOOTING) {
-		endtime = ktime_get();
-		delta = ktime_sub(endtime, starttime);
-
-		printk("async_continuing @ %i after %lli usec\n",
-			task_pid_nr(current),
-			(long long)ktime_to_ns(delta) >> 10);
-	}
-}
-EXPORT_SYMBOL_GPL(async_synchronize_cookie_domain);
-
-/**
- * async_synchronize_cookie - synchronize asynchronous function calls with cookie checkpointing
- * @cookie: async_cookie_t to use as checkpoint
- *
- * This function waits until all asynchronous function calls prior to @cookie
- * have been done.
- */
-void async_synchronize_cookie(async_cookie_t cookie)
-{
-	async_synchronize_cookie_domain(cookie, &async_running);
-}
-EXPORT_SYMBOL_GPL(async_synchronize_cookie);
-
-
-static int async_thread(void *unused)
-{
-	DECLARE_WAITQUEUE(wq, current);
-	add_wait_queue(&async_new, &wq);
-
-	while (!kthread_should_stop()) {
-		int ret = HZ;
-		set_current_state(TASK_INTERRUPTIBLE);
-		/*
-		 * check the list head without lock.. false positives
-		 * are dealt with inside run_one_entry() while holding
-		 * the lock.
-		 */
-		rmb();
-		if (!list_empty(&async_pending))
-			run_one_entry();
-		else
-			ret = schedule_timeout(HZ);
-
-		if (ret == 0) {
-			/*
-			 * we timed out, this means we as thread are redundant.
-			 * we sign off and die, but we to avoid any races there
-			 * is a last-straw check to see if work snuck in.
-			 */
-			atomic_dec(&thread_count);
-			wmb(); /* manager must see our departure first */
-			if (list_empty(&async_pending))
-				break;
-			/*
-			 * woops work came in between us timing out and us
-			 * signing off; we need to stay alive and keep working.
-			 */
-			atomic_inc(&thread_count);
-		}
-	}
-	remove_wait_queue(&async_new, &wq);
-
-	return 0;
-}
-
-static int async_manager_thread(void *unused)
-{
-	DECLARE_WAITQUEUE(wq, current);
-	add_wait_queue(&async_new, &wq);
-
-	while (!kthread_should_stop()) {
-		int tc, ec;
-
-		set_current_state(TASK_INTERRUPTIBLE);
-
-		tc = atomic_read(&thread_count);
-		rmb();
-		ec = atomic_read(&entry_count);
-
-		while (tc < ec && tc < MAX_THREADS) {
-			if (IS_ERR(kthread_run(async_thread, NULL, "async/%i",
-					       tc))) {
-				msleep(100);
-				continue;
-			}
-			atomic_inc(&thread_count);
-			tc++;
-		}
-
-		schedule();
-	}
-	remove_wait_queue(&async_new, &wq);
-
-	return 0;
-}
-
-static int __init async_init(void)
-{
-	async_enabled =
-		!IS_ERR(kthread_run(async_manager_thread, NULL, "async/mgr"));
-
-	WARN_ON(!async_enabled);
-	return 0;
-}
-
-core_initcall(async_init);
-
 struct async_ent {
 	struct work_struct	work;
 	async_func_t		func;
diff --git a/kernel/irq/autoprobe.c b/kernel/irq/autoprobe.c
index 39188cd..9d7f375 100644
--- a/kernel/irq/autoprobe.c
+++ b/kernel/irq/autoprobe.c
@@ -38,7 +38,6 @@ unsigned long probe_irq_on(void)
 	/*
 	 * quiesce the kernel, or at least the asynchronous portion
 	 */
-	async_synchronize_full();
 	async_barrier();
 	mutex_lock(&probing_active);
 	/*
diff --git a/kernel/module.c b/kernel/module.c
index 623a9b6..21c4c17 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -716,7 +716,6 @@ SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
 		mod->exit();
 	blocking_notifier_call_chain(&module_notify_list,
 				     MODULE_STATE_GOING, mod);
-	async_synchronize_full();
 	async_barrier();
 	mutex_lock(&module_mutex);
 	/* Store the name of the last unloaded module for diagnostic purposes */
@@ -2494,7 +2493,6 @@ SYSCALL_DEFINE3(init_module, void __user *, umod,
 				     MODULE_STATE_LIVE, mod);
 
 	/* We need to finish all async code before the module init sequence is done */
-	async_synchronize_full();
 	async_barrier();
 
 	mutex_lock(&module_mutex);
-- 
1.6.4.2

