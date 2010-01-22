Return-Path: <linux-kernel-owner+w=401wt.eu-S1753723Ab0AVKyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723Ab0AVKyd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 05:54:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753190Ab0AVKyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 05:54:32 -0500
Received: from hera.kernel.org ([140.211.167.34]:55266 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753327Ab0AVKyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 05:54:31 -0500
Message-ID: <4B598522.7030708@kernel.org>
Date: Fri, 22 Jan 2010 19:59:46 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, avi@redhat.com,
       johannes@sipsolutions.net, andi@firstfloor.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: [PATCH] async: use workqueue for worker pool
References: <1263776272-382-1-git-send-email-tj@kernel.org>	<1263776272-382-33-git-send-email-tj@kernel.org>	<20100117220130.214d56f1@linux.intel.com>	<4B5420A3.3080200@kernel.org>	<20100118072523.2683cd59@linux.intel.com>	<4B55038D.3070106@kernel.org>	<4B550384.8030103@linux.intel.com>	<4B5565BE.4050406@kernel.org>	<20100119063718.3f1f39cc@linux.intel.com>	<4B564C23.1030708@kernel.org>	<4B564ECC.9080707@linux.intel.com>	<4B566590.5030804@kernel.org> <20100119220303.6767a553@linux.intel.com> <4B56BDBB.9060200@kernel.org>
In-Reply-To: <4B56BDBB.9060200@kernel.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 22 Jan 2010 10:53:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace private worker pool with system_long_wq.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Arjan van de Ven <arjan@infradead.org>
---
Alright, here's the patch to just convert the worker pool.  Boots fine
here.

Thanks.

 kernel/async.c |  140 ++++++++-------------------------------------------------
 1 file changed, 21 insertions(+), 119 deletions(-)

Index: work/kernel/async.c
===================================================================
--- work.orig/kernel/async.c
+++ work/kernel/async.c
@@ -49,39 +49,31 @@ asynchronous and synchronous parts of th
 */
 
 #include <linux/async.h>
-#include <linux/bug.h>
 #include <linux/module.h>
 #include <linux/wait.h>
 #include <linux/sched.h>
-#include <linux/init.h>
-#include <linux/kthread.h>
-#include <linux/delay.h>
 #include <asm/atomic.h>
 
 static async_cookie_t next_cookie = 1;
 
-#define MAX_THREADS	256
 #define MAX_WORK	32768
 
 static LIST_HEAD(async_pending);
 static LIST_HEAD(async_running);
 static DEFINE_SPINLOCK(async_lock);
 
-static int async_enabled = 0;
-
 struct async_entry {
-	struct list_head list;
-	async_cookie_t   cookie;
-	async_func_ptr	 *func;
-	void             *data;
-	struct list_head *running;
+	struct list_head	list;
+	struct work_struct	work;
+	async_cookie_t		cookie;
+	async_func_ptr		*func;
+	void			*data;
+	struct list_head	*running;
 };
 
 static DECLARE_WAIT_QUEUE_HEAD(async_done);
-static DECLARE_WAIT_QUEUE_HEAD(async_new);
 
 static atomic_t entry_count;
-static atomic_t thread_count;
 
 extern int initcall_debug;
 
@@ -116,27 +108,23 @@ static async_cookie_t  lowest_in_progres
 	spin_unlock_irqrestore(&async_lock, flags);
 	return ret;
 }
+
 /*
  * pick the first pending entry and run it
  */
-static void run_one_entry(void)
+static void async_run_entry_fn(struct work_struct *work)
 {
+	struct async_entry *entry =
+		container_of(work, struct async_entry, work);
 	unsigned long flags;
-	struct async_entry *entry;
 	ktime_t calltime, delta, rettime;
 
-	/* 1) pick one task from the pending queue */
-
+	/* 1) move self to the running queue */
 	spin_lock_irqsave(&async_lock, flags);
-	if (list_empty(&async_pending))
-		goto out;
-	entry = list_first_entry(&async_pending, struct async_entry, list);
-
-	/* 2) move it to the running queue */
 	list_move_tail(&entry->list, entry->running);
 	spin_unlock_irqrestore(&async_lock, flags);
 
-	/* 3) run it (and print duration)*/
+	/* 2) run (and print duration) */
 	if (initcall_debug && system_state == SYSTEM_BOOTING) {
 		printk("calling  %lli_%pF @ %i\n", (long long)entry->cookie,
 			entry->func, task_pid_nr(current));
@@ -152,31 +140,25 @@ static void run_one_entry(void)
 			(long long)ktime_to_ns(delta) >> 10);
 	}
 
-	/* 4) remove it from the running queue */
+	/* 3) remove self from the running queue */
 	spin_lock_irqsave(&async_lock, flags);
 	list_del(&entry->list);
 
-	/* 5) free the entry  */
+	/* 4) free the entry */
 	kfree(entry);
 	atomic_dec(&entry_count);
 
 	spin_unlock_irqrestore(&async_lock, flags);
 
-	/* 6) wake up any waiters. */
+	/* 5) wake up any waiters */
 	wake_up(&async_done);
-	return;
-
-out:
-	spin_unlock_irqrestore(&async_lock, flags);
 }
 
-
 static async_cookie_t __async_schedule(async_func_ptr *ptr, void *data, struct list_head *running)
 {
 	struct async_entry *entry;
 	unsigned long flags;
 	async_cookie_t newcookie;
-	
 
 	/* allow irq-off callers */
 	entry = kzalloc(sizeof(struct async_entry), GFP_ATOMIC);
@@ -185,7 +167,7 @@ static async_cookie_t __async_schedule(a
 	 * If we're out of memory or if there's too much work
 	 * pending already, we execute synchronously.
 	 */
-	if (!async_enabled || !entry || atomic_read(&entry_count) > MAX_WORK) {
+	if (!entry || atomic_read(&entry_count) > MAX_WORK) {
 		kfree(entry);
 		spin_lock_irqsave(&async_lock, flags);
 		newcookie = next_cookie++;
@@ -195,6 +177,7 @@ static async_cookie_t __async_schedule(a
 		ptr(data, newcookie);
 		return newcookie;
 	}
+	INIT_WORK(&entry->work, async_run_entry_fn);
 	entry->func = ptr;
 	entry->data = data;
 	entry->running = running;
@@ -204,7 +187,10 @@ static async_cookie_t __async_schedule(a
 	list_add_tail(&entry->list, &async_pending);
 	atomic_inc(&entry_count);
 	spin_unlock_irqrestore(&async_lock, flags);
-	wake_up(&async_new);
+
+	/* schedule for execution */
+	queue_work(system_long_wq, &entry->work);
+
 	return newcookie;
 }
 
@@ -311,87 +297,3 @@ void async_synchronize_cookie(async_cook
 	async_synchronize_cookie_domain(cookie, &async_running);
 }
 EXPORT_SYMBOL_GPL(async_synchronize_cookie);
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
