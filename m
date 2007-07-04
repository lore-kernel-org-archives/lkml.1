Return-Path: <linux-kernel-owner+w=401wt.eu-S1758620AbXGEIfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758620AbXGEIfA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 04:35:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757401AbXGEIew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 04:34:52 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:41883 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757329AbXGEIeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 04:34:50 -0400
Subject: [PATCH] debug workqueue flushing deadlocks with lockdep
From: Johannes Berg <johannes@sipsolutions.net>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@tv-sign.ru>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Sattler <tsattler@gmx.de>
Content-Type: text/plain
Date: Wed, 04 Jul 2007 21:34:28 +0200
Message-Id: <1183577668.9662.11.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a fake lock to each workqueue in order to debug things
where you have something like

  my_function() -> lock(); ...; flush_workqueue(); ...
vs
  run_workqueue() -> my_work() -> ...; lock(); ...

which can obviously deadlock if my_work is scheduled when my_function()
is invoked (but hasn't locked yet.)

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
This should be uncontroversial but doesn't add any debugging
for the cancel_*_work() API.

 include/linux/workqueue.h |   20 +++++++++++++++++---
 kernel/workqueue.c        |   19 ++++++++++++++++---
 2 files changed, 33 insertions(+), 6 deletions(-)

--- linux-2.6-git.orig/kernel/workqueue.c	2007-07-04 18:55:19.009991984 +0200
+++ linux-2.6-git/kernel/workqueue.c	2007-07-04 21:29:59.412544144 +0200
@@ -61,6 +61,9 @@ struct workqueue_struct {
 	const char *name;
 	int singlethread;
 	int freezeable;		/* Freeze threads during suspend */
+#ifdef CONFIG_LOCKDEP
+	struct lockdep_map lockdep_map;
+#endif
 };
 
 /* All the per-cpu workqueues on the system, for hotplug cpu to add/remove
@@ -257,7 +260,9 @@ static void run_workqueue(struct cpu_wor
 
 		BUG_ON(get_wq_data(work) != cwq);
 		work_clear_pending(work);
+		lock_acquire(&cwq->wq->lockdep_map, 0, 0, 0, 2, _THIS_IP_);
 		f(work);
+		lock_release(&cwq->wq->lockdep_map, 1, _THIS_IP_);
 
 		if (unlikely(in_atomic() || lockdep_depth(current) > 0)) {
 			printk(KERN_ERR "BUG: workqueue leaked lock or atomic: "
@@ -376,6 +381,8 @@ void fastcall flush_workqueue(struct wor
 	int cpu;
 
 	might_sleep();
+	lock_acquire(&wq->lockdep_map, 0, 0, 0, 2, _THIS_IP_);
+	lock_release(&wq->lockdep_map, 1, _THIS_IP_);
 	for_each_cpu_mask(cpu, *cpu_map)
 		flush_cpu_workqueue(per_cpu_ptr(wq->cpu_wq, cpu));
 }
@@ -682,8 +689,10 @@ static void start_workqueue_thread(struc
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
@@ -700,6 +709,7 @@ struct workqueue_struct *__create_workqu
 	}
 
 	wq->name = name;
+	lockdep_init_map(&wq->lockdep_map, name, key, 0);
 	wq->singlethread = singlethread;
 	wq->freezeable = freezeable;
 	INIT_LIST_HEAD(&wq->list);
@@ -728,7 +738,7 @@ struct workqueue_struct *__create_workqu
 	}
 	return wq;
 }
-EXPORT_SYMBOL_GPL(__create_workqueue);
+EXPORT_SYMBOL_GPL(__create_workqueue_key);
 
 static void cleanup_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
 {
@@ -739,6 +749,9 @@ static void cleanup_workqueue_thread(str
 	if (cwq->thread == NULL)
 		return;
 
+	lock_acquire(&cwq->wq->lockdep_map, 0, 0, 0, 2, _THIS_IP_);
+	lock_release(&cwq->wq->lockdep_map, 1, _THIS_IP_);
+
 	/*
 	 * If the caller is CPU_DEAD the single flush_cpu_workqueue()
 	 * is not enough, a concurrent flush_workqueue() can insert a
--- linux-2.6-git.orig/include/linux/workqueue.h	2007-07-04 18:55:19.045991984 +0200
+++ linux-2.6-git/include/linux/workqueue.h	2007-07-04 21:29:59.357544144 +0200
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


