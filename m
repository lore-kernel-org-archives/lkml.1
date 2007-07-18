Return-Path: <linux-kernel-owner+w=401wt.eu-S934621AbXGRR3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934621AbXGRR3S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 13:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755391AbXGRR3D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 13:29:03 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:58565 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731AbXGRR3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 13:29:01 -0400
Subject: [PATCH (updated) 1/2] workqueue: debug flushing deadlocks with
	lockdep
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20070717125420.414566000@sipsolutions.net>
References: <20070717125316.755595000@sipsolutions.net>
	 <20070717125420.414566000@sipsolutions.net>
Content-Type: text/plain
Date: Wed, 18 Jul 2007 19:28:37 +0200
Message-Id: <1184779717.8125.5.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In the following scenario:

code path 1:
  my_function() -> lock(L1); ...; flush_workqueue(); ...

code path 2:
  run_workqueue() -> my_work() -> ...; lock(L1); ...

you can get a deadlock when my_work() is queued or running
but my_function() has acquired L1 already.

This patch adds a pseudo-lock to each workqueue to make lockdep
warn about this scenario.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Acked-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Ingo Molnar <mingo@elte.hu>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

---
This one applies against the current kernel, patch 2 still applies as-is.

 include/linux/workqueue.h |   20 +++++++++++++++++---
 kernel/workqueue.c        |   20 +++++++++++++++++---
 2 files changed, 34 insertions(+), 6 deletions(-)

--- wireless-dev.orig/kernel/workqueue.c	2007-07-18 14:25:20.792900849 +0200
+++ wireless-dev/kernel/workqueue.c	2007-07-18 14:25:50.462900849 +0200
@@ -32,6 +32,7 @@
 #include <linux/freezer.h>
 #include <linux/kallsyms.h>
 #include <linux/debug_locks.h>
+#include <linux/lockdep.h>
 
 /*
  * The per-CPU workqueue (if single thread, we always use the first
@@ -61,6 +62,9 @@ struct workqueue_struct {
 	const char *name;
 	int singlethread;
 	int freezeable;		/* Freeze threads during suspend */
+#ifdef CONFIG_LOCKDEP
+	struct lockdep_map lockdep_map;
+#endif
 };
 
 /* All the per-cpu workqueues on the system, for hotplug cpu to add/remove
@@ -257,7 +261,9 @@ static void run_workqueue(struct cpu_wor
 
 		BUG_ON(get_wq_data(work) != cwq);
 		work_clear_pending(work);
+		lock_acquire(&cwq->wq->lockdep_map, 0, 0, 0, 2, _THIS_IP_);
 		f(work);
+		lock_release(&cwq->wq->lockdep_map, 1, _THIS_IP_);
 
 		if (unlikely(in_atomic() || lockdep_depth(current) > 0)) {
 			printk(KERN_ERR "BUG: workqueue leaked lock or atomic: "
@@ -376,6 +382,8 @@ void fastcall flush_workqueue(struct wor
 	int cpu;
 
 	might_sleep();
+	lock_acquire(&wq->lockdep_map, 0, 0, 0, 2, _THIS_IP_);
+	lock_release(&wq->lockdep_map, 1, _THIS_IP_);
 	for_each_cpu_mask(cpu, *cpu_map)
 		flush_cpu_workqueue(per_cpu_ptr(wq->cpu_wq, cpu));
 }
@@ -695,8 +703,10 @@ static void start_workqueue_thread(struc
 	}
 }
 
-struct workqueue_struct *__create_workqueue(const char *name,
-					    int singlethread, int freezeable)
+struct workqueue_struct *__create_workqueue_key(const char *name,
+						int singlethread,
+						int freezeable,
+						struct lock_class_key *key)
 {
 	struct workqueue_struct *wq;
 	struct cpu_workqueue_struct *cwq;
@@ -713,6 +723,7 @@ struct workqueue_struct *__create_workqu
 	}
 
 	wq->name = name;
+	lockdep_init_map(&wq->lockdep_map, name, key, 0);
 	wq->singlethread = singlethread;
 	wq->freezeable = freezeable;
 	INIT_LIST_HEAD(&wq->list);
@@ -741,7 +752,7 @@ struct workqueue_struct *__create_workqu
 	}
 	return wq;
 }
-EXPORT_SYMBOL_GPL(__create_workqueue);
+EXPORT_SYMBOL_GPL(__create_workqueue_key);
 
 static void cleanup_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
 {
@@ -752,6 +763,9 @@ static void cleanup_workqueue_thread(str
 	if (cwq->thread == NULL)
 		return;
 
+	lock_acquire(&cwq->wq->lockdep_map, 0, 0, 0, 2, _THIS_IP_);
+	lock_release(&cwq->wq->lockdep_map, 1, _THIS_IP_);
+
 	flush_cpu_workqueue(cwq);
 	/*
 	 * If the caller is CPU_DEAD and cwq->worklist was not empty,
--- wireless-dev.orig/include/linux/workqueue.h	2007-07-18 14:25:20.852900849 +0200
+++ wireless-dev/include/linux/workqueue.h	2007-07-18 14:25:50.462900849 +0200
@@ -118,9 +118,23 @@ struct execute_work {
 	clear_bit(WORK_STRUCT_PENDING, work_data_bits(work))
 
 
-extern struct workqueue_struct *__create_workqueue(const char *name,
-						    int singlethread,
-						    int freezeable);
+extern struct workqueue_struct *
+__create_workqueue_key(const char *name, int singlethread,
+		       int freezeable, struct lock_class_key *key);
+
+#ifdef CONFIG_LOCKDEP
+#define __create_workqueue(name, singlethread, freezeable)	\
+({								\
+	static struct lock_class_key __key;			\
+								\
+	__create_workqueue_key((name), (singlethread),		\
+			       (freezeable), &__key);		\
+})
+#else
+#define __create_workqueue(name, singlethread, freezeable)	\
+	__create_workqueue_key((name), (singlethread), (freezeable), NULL)
+#endif
+
 #define create_workqueue(name) __create_workqueue((name), 0, 0)
 #define create_freezeable_workqueue(name) __create_workqueue((name), 1, 1)
 #define create_singlethread_workqueue(name) __create_workqueue((name), 1, 0)


