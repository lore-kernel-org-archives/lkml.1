Return-Path: <linux-kernel-owner+w=401wt.eu-S1762224AbXGQM7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762224AbXGQM7b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 08:59:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752289AbXGQM66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 08:58:58 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:56774 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbXGQM64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 08:58:56 -0400
Message-Id: <20070717125420.958582000@sipsolutions.net>
References: <20070717125316.755595000@sipsolutions.net>
User-Agent: quilt/0.46-1
Date: Tue, 17 Jul 2007 14:53:18 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH (resend) 2/2] workqueue: debug work related deadlocks with
	lockdep
Content-Disposition: inline; filename=workqueue-debug-2.patch
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In the following scenario:

code path 1:
  my_function() -> lock(L1); ...; cancel_work_sync(my_work)
  [or cancel_rearming_delayed_work(my_work)]

code path 2:
  run_workqueue() -> my_work.f() -> ...; lock(L1); ...

you can get a deadlock if my_work.f() is running but my_function()
has acquired L1 already. This patch adds a pseudo-lock to each
struct work_struct to make lockdep warn about this scenario.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Acked-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Ingo Molnar <mingo@elte.hu>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

---
 include/linux/lockdep.h   |    8 ++++++++
 include/linux/workqueue.h |   29 +++++++++++++++++++++++++++++
 kernel/workqueue.c        |   16 ++++++++++++++++
 3 files changed, 53 insertions(+)

--- linux-2.6-git.orig/include/linux/workqueue.h	2007-07-05 13:01:33.978155045 +0200
+++ linux-2.6-git/include/linux/workqueue.h	2007-07-05 13:07:40.969155045 +0200
@@ -8,6 +8,7 @@
 #include <linux/timer.h>
 #include <linux/linkage.h>
 #include <linux/bitops.h>
+#include <linux/lockdep.h>
 #include <asm/atomic.h>
 
 struct workqueue_struct;
@@ -28,6 +29,9 @@ struct work_struct {
 #define WORK_STRUCT_WQ_DATA_MASK (~WORK_STRUCT_FLAG_MASK)
 	struct list_head entry;
 	work_func_t func;
+#ifdef CONFIG_LOCKDEP
+	struct lockdep_map lockdep_map;
+#endif
 };
 
 #define WORK_DATA_INIT()	ATOMIC_LONG_INIT(0)
@@ -41,10 +45,23 @@ struct execute_work {
 	struct work_struct work;
 };
 
+#ifdef CONFIG_LOCKDEP
+/*
+ * NB: because we have to copy the lockdep_map, setting _key
+ * here is required, otherwise it could get initialised to the
+ * copy of the lockdep_map!
+ */
+#define __WORK_INIT_LOCKDEP_MAP(n, k) \
+	.lockdep_map = STATIC_LOCKDEP_MAP_INIT(n, k),
+#else
+#define __WORK_INIT_LOCKDEP_MAP(n, k)
+#endif
+
 #define __WORK_INITIALIZER(n, f) {				\
 	.data = WORK_DATA_INIT(),				\
 	.entry	= { &(n).entry, &(n).entry },			\
 	.func = (f),						\
+	__WORK_INIT_LOCKDEP_MAP(#n, &(n))			\
 	}
 
 #define __DELAYED_WORK_INITIALIZER(n, f) {			\
@@ -76,12 +93,24 @@ struct execute_work {
  * assignment of the work data initializer allows the compiler
  * to generate better code.
  */
+#ifdef CONFIG_LOCKDEP
 #define INIT_WORK(_work, _func)						\
 	do {								\
+		static struct lock_class_key __key;			\
+									\
 		(_work)->data = (atomic_long_t) WORK_DATA_INIT();	\
+		lockdep_init_map(&(_work)->lockdep_map, #_work, &__key, 0);\
 		INIT_LIST_HEAD(&(_work)->entry);			\
 		PREPARE_WORK((_work), (_func));				\
 	} while (0)
+#else
+#define INIT_WORK(_work, _func)						\
+	do {								\
+		(_work)->data = (atomic_long_t) WORK_DATA_INIT();	\
+		INIT_LIST_HEAD(&(_work)->entry);			\
+		PREPARE_WORK((_work), (_func));				\
+	} while (0)
+#endif
 
 #define INIT_DELAYED_WORK(_work, _func)				\
 	do {							\
--- linux-2.6-git.orig/kernel/workqueue.c	2007-07-05 13:01:55.728155045 +0200
+++ linux-2.6-git/kernel/workqueue.c	2007-07-05 13:03:40.882155045 +0200
@@ -254,6 +254,17 @@ static void run_workqueue(struct cpu_wor
 		struct work_struct *work = list_entry(cwq->worklist.next,
 						struct work_struct, entry);
 		work_func_t f = work->func;
+#ifdef CONFIG_LOCKDEP
+		/*
+		 * It is permissible to free the struct work_struct
+		 * from inside the function that is called from it,
+		 * this we need to take into account for lockdep too.
+		 * To avoid bogus "held lock freed" warnings as well
+		 * as problems when looking into work->lockdep_map,
+		 * make a copy and use that here.
+		 */
+		struct lockdep_map lockdep_map = work->lockdep_map;
+#endif
 
 		cwq->current_work = work;
 		list_del_init(cwq->worklist.next);
@@ -262,7 +273,9 @@ static void run_workqueue(struct cpu_wor
 		BUG_ON(get_wq_data(work) != cwq);
 		work_clear_pending(work);
 		lock_acquire(&cwq->wq->lockdep_map, 0, 0, 0, 2, _THIS_IP_);
+		lock_acquire(&lockdep_map, 0, 0, 0, 2, _THIS_IP_);
 		f(work);
+		lock_release(&lockdep_map, 1, _THIS_IP_);
 		lock_release(&cwq->wq->lockdep_map, 1, _THIS_IP_);
 
 		if (unlikely(in_atomic() || lockdep_depth(current) > 0)) {
@@ -454,6 +467,9 @@ static void wait_on_work(struct work_str
 
 	might_sleep();
 
+	lock_acquire(&work->lockdep_map, 0, 0, 0, 2, _THIS_IP_);
+	lock_release(&work->lockdep_map, 1, _THIS_IP_);
+
 	cwq = get_wq_data(work);
 	if (!cwq)
 		return;
--- linux-2.6-git.orig/include/linux/lockdep.h	2007-07-05 13:01:34.043155045 +0200
+++ linux-2.6-git/include/linux/lockdep.h	2007-07-05 13:03:40.901155045 +0200
@@ -223,6 +223,14 @@ extern void lockdep_init_map(struct lock
 				 (lock)->dep_map.key, sub)
 
 /*
+ * To initialize a lockdep_map statically use this macro.
+ * Note that _name must not be NULL.
+ */
+#define STATIC_LOCKDEP_MAP_INIT(_name, _key) \
+	{ .name = (_name), .key = (void *)(_key), }
+
+
+/*
  * Acquire a lock.
  *
  * Values for "read":

-- 

-- 

