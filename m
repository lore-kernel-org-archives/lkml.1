Return-Path: <linux-kernel-owner+w=401wt.eu-S1753872AbZAFVGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872AbZAFVGa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 16:06:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751324AbZAFVGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 16:06:20 -0500
Received: from casper.infradead.org ([85.118.1.10]:33033 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbZAFVGT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 16:06:19 -0500
Date: Tue, 6 Jan 2009 13:07:33 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, linux-fs@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: [PATCH 1/2] async: allow for multiple independent synchronization
 domains
Message-ID: <20090106130733.751fe2c3@infradead.org>
In-Reply-To: <20090106130628.59d63bee@infradead.org>
References: <20090106130628.59d63bee@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 6353d3c8c9e11127961c2f366abc8ea0c7cb0e92 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Tue, 6 Jan 2009 07:19:33 -0800
Subject: [PATCH] async: allow for multiple independent synchronization domains

for a wider use of async function calls it's nice to have multiple
domains for synchronization, for example, in the VFS world each superblock
would be its own domain.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 include/linux/async.h |    4 ++++
 kernel/async.c        |   49 +++++++++++++++++++++++++++++++++++--------------
 2 files changed, 39 insertions(+), 14 deletions(-)

diff --git a/include/linux/async.h b/include/linux/async.h
index 678d4fd..6f0a3ba 100644
--- a/include/linux/async.h
+++ b/include/linux/async.h
@@ -11,11 +11,15 @@
  */
 
 #include <linux/types.h>
+#include <linux/list.h>
 
 typedef u64 async_cookie_t;
 typedef void (async_func_ptr) (void *data, async_cookie_t cookie);
 
 extern async_cookie_t async_schedule(async_func_ptr *ptr, void *data);
+extern async_cookie_t async_schedule_special(async_func_ptr *ptr, void *data, struct list_head *list);
 extern void async_synchronize_full(void);
+extern void async_synchronize_full_special(struct list_head *list);
 extern void async_synchronize_cookie(async_cookie_t cookie);
+extern void async_synchronize_cookie_special(async_cookie_t cookie, struct list_head *list);
 
diff --git a/kernel/async.c b/kernel/async.c
index 8ecebf5..652804b 100644
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -57,7 +57,6 @@ asynchronous and synchronous parts of the kernel.
 #include <asm/atomic.h>
 
 static async_cookie_t next_cookie = 1;
-static async_cookie_t lowest_in_progress = 1;
 
 
 static LIST_HEAD(async_pending);
@@ -69,6 +68,7 @@ struct async_entry {
 	async_cookie_t   cookie;
 	async_func_ptr	 *func;
 	void             *data;
+	struct list_head *running;
 };
 
 static DECLARE_WAIT_QUEUE_HEAD(async_done);
@@ -83,20 +83,20 @@ extern int initcall_debug;
 /*
  * MUST be called with the lock held!
  */
-static void __recalc_lowest_in_progress(void)
+static async_cookie_t  __lowest_in_progress(struct list_head *running)
 {
 	struct async_entry *entry;
 	if (!list_empty(&async_pending)) {
 		entry = list_first_entry(&async_pending,
 			struct async_entry, list);
-		lowest_in_progress = entry->cookie;
-	} else if (!list_empty(&async_running)) {
-		entry = list_first_entry(&async_running,
+		return entry->cookie;
+	} else if (!list_empty(running)) {
+		entry = list_first_entry(running,
 			struct async_entry, list);
-		lowest_in_progress = entry->cookie;
+		return entry->cookie;
 	} else {
 		/* nothing in progress... next_cookie is "infinity" */
-		lowest_in_progress = next_cookie;
+		return next_cookie;
 	}
 
 }
@@ -142,12 +142,9 @@ static void run_one_entry(void)
 	kfree(entry);
 	atomic_dec(&entry_count);
 
-	/* 6) update the lowest_in_progress value */
-	__recalc_lowest_in_progress();
-
 	spin_unlock_irqrestore(&async_lock, flags);
 
-	/* 7) wake up any waiters. */
+	/* 6) wake up any waiters. */
 	wake_up(&async_done);
 	return;
 
@@ -156,7 +153,7 @@ out:
 }
 
 
-async_cookie_t async_schedule(async_func_ptr *ptr, void *data)
+static async_cookie_t __async_schedule(async_func_ptr *ptr, void *data, struct list_head *running)
 {
 	struct async_entry *entry;
 	unsigned long flags;
@@ -176,6 +173,7 @@ async_cookie_t async_schedule(async_func_ptr *ptr, void *data)
 	}
 	entry->func = ptr;
 	entry->data = data;
+	entry->running = running;
 
 	spin_lock_irqsave(&async_lock, flags);
 	newcookie = entry->cookie = next_cookie++;
@@ -185,15 +183,32 @@ async_cookie_t async_schedule(async_func_ptr *ptr, void *data)
 	wake_up(&async_new);
 	return newcookie;
 }
+
+async_cookie_t async_schedule(async_func_ptr *ptr, void *data)
+{
+	return __async_schedule(ptr, data, &async_pending);
+}
 EXPORT_SYMBOL_GPL(async_schedule);
 
+async_cookie_t async_schedule_special(async_func_ptr *ptr, void *data, struct list_head *running)
+{
+	return __async_schedule(ptr, data, running);
+}
+EXPORT_SYMBOL_GPL(async_schedule_special);
+
 void async_synchronize_full(void)
 {
 	async_synchronize_cookie(next_cookie);
 }
 EXPORT_SYMBOL_GPL(async_synchronize_full);
 
-void async_synchronize_cookie(async_cookie_t cookie)
+void async_synchronize_full_special(struct list_head *list)
+{
+	async_synchronize_cookie_special(next_cookie, list);
+}
+EXPORT_SYMBOL_GPL(async_synchronize_full_special);
+
+void async_synchronize_cookie_special(async_cookie_t cookie, struct list_head *running)
 {
 	ktime_t starttime, delta, endtime;
 
@@ -202,7 +217,7 @@ void async_synchronize_cookie(async_cookie_t cookie)
 		starttime = ktime_get();
 	}
 
-	wait_event(async_done, lowest_in_progress >= cookie);
+	wait_event(async_done, __lowest_in_progress(running) >= cookie);
 
 	if (initcall_debug) {
 		endtime = ktime_get();
@@ -212,6 +227,12 @@ void async_synchronize_cookie(async_cookie_t cookie)
 			task_pid_nr(current), ktime_to_ns(delta) >> 10);
 	}
 }
+EXPORT_SYMBOL_GPL(async_synchronize_cookie_special);
+
+void async_synchronize_cookie(async_cookie_t cookie)
+{
+	async_synchronize_cookie_special(cookie, &async_running);
+}
 EXPORT_SYMBOL_GPL(async_synchronize_cookie);
 
 
-- 
1.5.5.1



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
