Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769Ab0CGTMr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 14:12:47 -0500
Received: from mga10.intel.com ([192.55.52.92]:52296 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751997Ab0CGTMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 14:12:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,598,1262592000"; 
   d="scan'208";a="778721828"
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH] async: Manage execution domains
Date: Sun,  7 Mar 2010 19:12:29 +0000
Message-Id: <1267989149-10825-1-git-send-email-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 1.7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently execution domains do not interact well with full synchronisation
requests. If the sync request is performed before the async task has
begun, then the manager will never schedule() and so busy-wait forever
on a UP box. By reorganising the tasks into both a per-domain and global
list, we can either wait on a single execution domain or globally over
all tasks, as intended.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Arjan van de Ven <arjan@linux.intel.com>
---
 kernel/async.c |  150 ++++++++++++++++++++++++++++++++------------------------
 1 files changed, 86 insertions(+), 64 deletions(-)

diff --git a/kernel/async.c b/kernel/async.c
index 27235f5..93bea2a 100644
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -71,10 +71,10 @@ static int async_enabled = 0;
 
 struct async_entry {
 	struct list_head list;
+	struct list_head domain;
 	async_cookie_t   cookie;
 	async_func_ptr	 *func;
 	void             *data;
-	struct list_head *running;
 };
 
 static DECLARE_WAIT_QUEUE_HEAD(async_done);
@@ -85,37 +85,66 @@ static atomic_t thread_count;
 
 extern int initcall_debug;
 
-
 /*
  * MUST be called with the lock held!
  */
-static async_cookie_t  __lowest_in_progress(struct list_head *running)
+static async_cookie_t __lowest_in_progress(struct list_head *domain)
 {
-	struct async_entry *entry;
-
-	if (!list_empty(running)) {
-		entry = list_first_entry(running,
-			struct async_entry, list);
-		return entry->cookie;
+	if (domain == NULL) {
+		if (!list_empty(&async_running))
+			return list_first_entry(&async_running,
+						 struct async_entry,
+						 list)->cookie;
+		if (!list_empty(&async_pending))
+			return list_first_entry(&async_pending,
+						 struct async_entry,
+						 list)->cookie;
+	} else {
+		if (!list_empty(domain))
+			return list_first_entry(domain,
+						struct async_entry,
+						domain)->cookie;
 	}
 
-	list_for_each_entry(entry, &async_pending, list)
-		if (entry->running == running)
-			return entry->cookie;
-
 	return next_cookie;	/* "infinity" value */
 }
 
-static async_cookie_t  lowest_in_progress(struct list_head *running)
+static async_cookie_t lowest_in_progress(struct list_head *domain)
 {
 	unsigned long flags;
 	async_cookie_t ret;
 
 	spin_lock_irqsave(&async_lock, flags);
-	ret = __lowest_in_progress(running);
+	ret = __lowest_in_progress(domain);
 	spin_unlock_irqrestore(&async_lock, flags);
+
 	return ret;
 }
+
+static void do_initcall(async_func_ptr *func, void *data, async_cookie_t cookie)
+{
+	ktime_t calltime;
+
+	if (initcall_debug && system_state == SYSTEM_BOOTING) {
+		printk("calling  %lli_%pF @ %i\n",
+		       (long long)cookie,
+		       func,
+		       task_pid_nr(current));
+		calltime = ktime_get();
+	}
+
+	func(data, cookie);
+
+	if (initcall_debug && system_state == SYSTEM_BOOTING) {
+		ktime_t rettime = ktime_get();
+		ktime_t delta = ktime_sub(rettime, calltime);
+		printk("initcall %lli_%pF returned 0 after %lld usecs\n",
+			(long long)cookie,
+			func,
+			(long long)ktime_to_ns(delta) >> 10);
+	}
+}
+
 /*
  * pick the first pending entry and run it
  */
@@ -123,45 +152,31 @@ static void run_one_entry(void)
 {
 	unsigned long flags;
 	struct async_entry *entry;
-	ktime_t calltime, delta, rettime;
 
 	/* 1) pick one task from the pending queue */
-
 	spin_lock_irqsave(&async_lock, flags);
 	if (list_empty(&async_pending))
 		goto out;
 	entry = list_first_entry(&async_pending, struct async_entry, list);
 
 	/* 2) move it to the running queue */
-	list_move_tail(&entry->list, entry->running);
+	list_move_tail(&entry->list, &async_running);
 	spin_unlock_irqrestore(&async_lock, flags);
 
 	/* 3) run it (and print duration)*/
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
+	do_initcall(entry->func, entry->data, entry->cookie);
 
 	/* 4) remove it from the running queue */
 	spin_lock_irqsave(&async_lock, flags);
 	list_del(&entry->list);
+	if (!list_empty(&entry->domain))
+		list_del(&entry->domain);
+	spin_unlock_irqrestore(&async_lock, flags);
 
 	/* 5) free the entry  */
 	kfree(entry);
 	atomic_dec(&entry_count);
 
-	spin_unlock_irqrestore(&async_lock, flags);
-
 	/* 6) wake up any waiters. */
 	wake_up(&async_done);
 	return;
@@ -170,40 +185,48 @@ out:
 	spin_unlock_irqrestore(&async_lock, flags);
 }
 
-
-static async_cookie_t __async_schedule(async_func_ptr *ptr, void *data, struct list_head *running)
+static async_cookie_t __async_schedule(async_func_ptr *ptr, void *data, struct list_head *domain)
 {
-	struct async_entry *entry;
+	struct async_entry *entry = NULL;
 	unsigned long flags;
 	async_cookie_t newcookie;
-	
 
 	/* allow irq-off callers */
-	entry = kzalloc(sizeof(struct async_entry), GFP_ATOMIC);
+	if (async_enabled && atomic_read(&entry_count) <= MAX_WORK)
+		entry = kmalloc(sizeof(struct async_entry), GFP_ATOMIC);
 
 	/*
 	 * If we're out of memory or if there's too much work
 	 * pending already, we execute synchronously.
 	 */
-	if (!async_enabled || !entry || atomic_read(&entry_count) > MAX_WORK) {
-		kfree(entry);
+	if (!entry) {
 		spin_lock_irqsave(&async_lock, flags);
 		newcookie = next_cookie++;
 		spin_unlock_irqrestore(&async_lock, flags);
 
 		/* low on memory.. run synchronously */
-		ptr(data, newcookie);
+		do_initcall(ptr, data, newcookie);
 		return newcookie;
 	}
+
 	entry->func = ptr;
 	entry->data = data;
-	entry->running = running;
+	INIT_LIST_HEAD(&entry->domain);
 
 	spin_lock_irqsave(&async_lock, flags);
 	newcookie = entry->cookie = next_cookie++;
 	list_add_tail(&entry->list, &async_pending);
-	atomic_inc(&entry_count);
+	if (domain)
+		list_add_tail(&entry->domain, domain);
 	spin_unlock_irqrestore(&async_lock, flags);
+
+	if (initcall_debug && system_state == SYSTEM_BOOTING) {
+		printk("async_queuing %lli_%pF \n",
+		       (long long)newcookie,
+		       ptr);
+	}
+
+	atomic_inc(&entry_count);
 	wake_up(&async_new);
 	return newcookie;
 }
@@ -218,7 +241,7 @@ static async_cookie_t __async_schedule(async_func_ptr *ptr, void *data, struct l
  */
 async_cookie_t async_schedule(async_func_ptr *ptr, void *data)
 {
-	return __async_schedule(ptr, data, &async_running);
+	return __async_schedule(ptr, data, NULL);
 }
 EXPORT_SYMBOL_GPL(async_schedule);
 
@@ -226,18 +249,18 @@ EXPORT_SYMBOL_GPL(async_schedule);
  * async_schedule_domain - schedule a function for asynchronous execution within a certain domain
  * @ptr: function to execute asynchronously
  * @data: data pointer to pass to the function
- * @running: running list for the domain
+ * @domain: synchronization domain
  *
  * Returns an async_cookie_t that may be used for checkpointing later.
- * @running may be used in the async_synchronize_*_domain() functions
+ * @domain may be used in the async_synchronize_*_domain() functions
  * to wait within a certain synchronization domain rather than globally.
- * A synchronization domain is specified via the running queue @running to use.
+ * A synchronization domain is specified via the @domain to use.
  * Note: This function may be called from atomic or non-atomic contexts.
  */
 async_cookie_t async_schedule_domain(async_func_ptr *ptr, void *data,
-				     struct list_head *running)
+				     struct list_head *domain)
 {
-	return __async_schedule(ptr, data, running);
+	return __async_schedule(ptr, data, domain);
 }
 EXPORT_SYMBOL_GPL(async_schedule_domain);
 
@@ -248,45 +271,44 @@ EXPORT_SYMBOL_GPL(async_schedule_domain);
  */
 void async_synchronize_full(void)
 {
-	do {
+	while (atomic_read(&entry_count))
 		async_synchronize_cookie(next_cookie);
-	} while (!list_empty(&async_running) || !list_empty(&async_pending));
 }
 EXPORT_SYMBOL_GPL(async_synchronize_full);
 
 /**
  * async_synchronize_full_domain - synchronize all asynchronous function within a certain domain
- * @list: running list to synchronize on
+ * @domain: synchronization domain
  *
  * This function waits until all asynchronous function calls for the
- * synchronization domain specified by the running list @list have been done.
+ * synchronization domain specified by @domain have been done.
  */
-void async_synchronize_full_domain(struct list_head *list)
+void async_synchronize_full_domain(struct list_head *domain)
 {
-	async_synchronize_cookie_domain(next_cookie, list);
+	async_synchronize_cookie_domain(next_cookie, domain);
 }
 EXPORT_SYMBOL_GPL(async_synchronize_full_domain);
 
 /**
  * async_synchronize_cookie_domain - synchronize asynchronous function calls within a certain domain with cookie checkpointing
  * @cookie: async_cookie_t to use as checkpoint
- * @running: running list to synchronize on
+ * @domain: synchronization domain
  *
  * This function waits until all asynchronous function calls for the
- * synchronization domain specified by the running list @list submitted
- * prior to @cookie have been done.
+ * synchronization domain specified by @domain submitted prior to @cookie
+ * have been done.
  */
 void async_synchronize_cookie_domain(async_cookie_t cookie,
-				     struct list_head *running)
+				     struct list_head *domain)
 {
 	ktime_t starttime, delta, endtime;
 
 	if (initcall_debug && system_state == SYSTEM_BOOTING) {
-		printk("async_waiting @ %i\n", task_pid_nr(current));
+		printk("async_waiting @ %i for %lli\n", task_pid_nr(current), cookie);
 		starttime = ktime_get();
 	}
 
-	wait_event(async_done, lowest_in_progress(running) >= cookie);
+	wait_event(async_done, lowest_in_progress(domain) >= cookie);
 
 	if (initcall_debug && system_state == SYSTEM_BOOTING) {
 		endtime = ktime_get();
@@ -308,7 +330,7 @@ EXPORT_SYMBOL_GPL(async_synchronize_cookie_domain);
  */
 void async_synchronize_cookie(async_cookie_t cookie)
 {
-	async_synchronize_cookie_domain(cookie, &async_running);
+	async_synchronize_cookie_domain(cookie, NULL);
 }
 EXPORT_SYMBOL_GPL(async_synchronize_cookie);
 
@@ -343,7 +365,7 @@ static int async_thread(void *unused)
 			if (list_empty(&async_pending))
 				break;
 			/*
-			 * woops work came in between us timing out and us
+			 * whoops work came in between us timing out and us
 			 * signing off; we need to stay alive and keep working.
 			 */
 			atomic_inc(&thread_count);
-- 
1.7.0

