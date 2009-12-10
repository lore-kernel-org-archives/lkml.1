Return-Path: <linux-kernel-owner+w=401wt.eu-S1759356AbZLJBXC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759356AbZLJBXC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 20:23:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759342AbZLJBW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 20:22:57 -0500
Received: from hera.kernel.org ([140.211.167.34]:45984 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759293AbZLJBW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 20:22:56 -0500
Message-ID: <4B204DA7.5040404@kernel.org>
Date: Thu, 10 Dec 2009 10:23:51 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       lkml <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>
Subject: [GIT PULL] workqueue changes for 2.6.33-rc1
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Please full from the following git tree.  This is a tree I set up for
concurrency managed workqueue changes but currently only contains
Thomas's debug object patch which makes work_struct lifetime related
bugs easy to track.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-linus

It merges into the current master without conflict.

Thanks.
----
Thomas Gleixner (1):
      workqueue: Add debugobjects support

 arch/x86/kernel/smpboot.c |    4 +-
 include/linux/workqueue.h |   38 +++++++++----
 kernel/workqueue.c        |  131 +++++++++++++++++++++++++++++++++++++++++++-
 lib/Kconfig.debug         |    8 +++
 4 files changed, 166 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 565ebc6..ba43dfe 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -687,7 +687,7 @@ static int __cpuinit do_boot_cpu(int apicid, int cpu)
 		.done	= COMPLETION_INITIALIZER_ONSTACK(c_idle.done),
 	};
 
-	INIT_WORK(&c_idle.work, do_fork_idle);
+	INIT_WORK_ON_STACK(&c_idle.work, do_fork_idle);
 
 	alternatives_smp_switch(1);
 
@@ -713,6 +713,7 @@ static int __cpuinit do_boot_cpu(int apicid, int cpu)
 
 	if (IS_ERR(c_idle.idle)) {
 		printk("failed fork for CPU %d\n", cpu);
+		destroy_work_on_stack(&c_idle.work);
 		return PTR_ERR(c_idle.idle);
 	}
 
@@ -831,6 +832,7 @@ do_rest:
 		smpboot_restore_warm_reset_vector();
 	}
 
+	destroy_work_on_stack(&c_idle.work);
 	return boot_error;
 }
 
diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index cf24c20..9466e86 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -25,6 +25,7 @@ typedef void (*work_func_t)(struct work_struct *work);
 struct work_struct {
 	atomic_long_t data;
 #define WORK_STRUCT_PENDING 0		/* T if work item pending execution */
+#define WORK_STRUCT_STATIC  1		/* static initializer (debugobjects) */
 #define WORK_STRUCT_FLAG_MASK (3UL)
 #define WORK_STRUCT_WQ_DATA_MASK (~WORK_STRUCT_FLAG_MASK)
 	struct list_head entry;
@@ -35,6 +36,7 @@ struct work_struct {
 };
 
 #define WORK_DATA_INIT()	ATOMIC_LONG_INIT(0)
+#define WORK_DATA_STATIC_INIT()	ATOMIC_LONG_INIT(2)
 
 struct delayed_work {
 	struct work_struct work;
@@ -63,7 +65,7 @@ struct execute_work {
 #endif
 
 #define __WORK_INITIALIZER(n, f) {				\
-	.data = WORK_DATA_INIT(),				\
+	.data = WORK_DATA_STATIC_INIT(),			\
 	.entry	= { &(n).entry, &(n).entry },			\
 	.func = (f),						\
 	__WORK_INIT_LOCKDEP_MAP(#n, &(n))			\
@@ -91,6 +93,14 @@ struct execute_work {
 #define PREPARE_DELAYED_WORK(_work, _func)			\
 	PREPARE_WORK(&(_work)->work, (_func))
 
+#ifdef CONFIG_DEBUG_OBJECTS_WORK
+extern void __init_work(struct work_struct *work, int onstack);
+extern void destroy_work_on_stack(struct work_struct *work);
+#else
+static inline void __init_work(struct work_struct *work, int onstack) { }
+static inline void destroy_work_on_stack(struct work_struct *work) { }
+#endif
+
 /*
  * initialize all of a work item in one go
  *
@@ -99,24 +109,36 @@ struct execute_work {
  * to generate better code.
  */
 #ifdef CONFIG_LOCKDEP
-#define INIT_WORK(_work, _func)						\
+#define __INIT_WORK(_work, _func, _onstack)				\
 	do {								\
 		static struct lock_class_key __key;			\
 									\
+		__init_work((_work), _onstack);				\
 		(_work)->data = (atomic_long_t) WORK_DATA_INIT();	\
 		lockdep_init_map(&(_work)->lockdep_map, #_work, &__key, 0);\
 		INIT_LIST_HEAD(&(_work)->entry);			\
 		PREPARE_WORK((_work), (_func));				\
 	} while (0)
 #else
-#define INIT_WORK(_work, _func)						\
+#define __INIT_WORK(_work, _func, _onstack)				\
 	do {								\
+		__init_work((_work), _onstack);				\
 		(_work)->data = (atomic_long_t) WORK_DATA_INIT();	\
 		INIT_LIST_HEAD(&(_work)->entry);			\
 		PREPARE_WORK((_work), (_func));				\
 	} while (0)
 #endif
 
+#define INIT_WORK(_work, _func)					\
+	do {							\
+		__INIT_WORK((_work), (_func), 0);		\
+	} while (0)
+
+#define INIT_WORK_ON_STACK(_work, _func)			\
+	do {							\
+		__INIT_WORK((_work), (_func), 1);		\
+	} while (0)
+
 #define INIT_DELAYED_WORK(_work, _func)				\
 	do {							\
 		INIT_WORK(&(_work)->work, (_func));		\
@@ -125,22 +147,16 @@ struct execute_work {
 
 #define INIT_DELAYED_WORK_ON_STACK(_work, _func)		\
 	do {							\
-		INIT_WORK(&(_work)->work, (_func));		\
+		INIT_WORK_ON_STACK(&(_work)->work, (_func));	\
 		init_timer_on_stack(&(_work)->timer);		\
 	} while (0)
 
-#define INIT_DELAYED_WORK_DEFERRABLE(_work, _func)			\
+#define INIT_DELAYED_WORK_DEFERRABLE(_work, _func)		\
 	do {							\
 		INIT_WORK(&(_work)->work, (_func));		\
 		init_timer_deferrable(&(_work)->timer);		\
 	} while (0)
 
-#define INIT_DELAYED_WORK_ON_STACK(_work, _func)		\
-	do {							\
-		INIT_WORK(&(_work)->work, (_func));		\
-		init_timer_on_stack(&(_work)->timer);		\
-	} while (0)
-
 /**
  * work_pending - Find out whether a work item is currently pending
  * @work: The work item in question
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 1232814..ddad63f 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -68,6 +68,116 @@ struct workqueue_struct {
 #endif
 };
 
+#ifdef CONFIG_DEBUG_OBJECTS_WORK
+
+static struct debug_obj_descr work_debug_descr;
+
+/*
+ * fixup_init is called when:
+ * - an active object is initialized
+ */
+static int work_fixup_init(void *addr, enum debug_obj_state state)
+{
+	struct work_struct *work = addr;
+
+	switch (state) {
+	case ODEBUG_STATE_ACTIVE:
+		cancel_work_sync(work);
+		debug_object_init(work, &work_debug_descr);
+		return 1;
+	default:
+		return 0;
+	}
+}
+
+/*
+ * fixup_activate is called when:
+ * - an active object is activated
+ * - an unknown object is activated (might be a statically initialized object)
+ */
+static int work_fixup_activate(void *addr, enum debug_obj_state state)
+{
+	struct work_struct *work = addr;
+
+	switch (state) {
+
+	case ODEBUG_STATE_NOTAVAILABLE:
+		/*
+		 * This is not really a fixup. The work struct was
+		 * statically initialized. We just make sure that it
+		 * is tracked in the object tracker.
+		 */
+		if (test_bit(WORK_STRUCT_STATIC, work_data_bits(work))) {
+			debug_object_init(work, &work_debug_descr);
+			debug_object_activate(work, &work_debug_descr);
+			return 0;
+		}
+		WARN_ON_ONCE(1);
+		return 0;
+
+	case ODEBUG_STATE_ACTIVE:
+		WARN_ON(1);
+
+	default:
+		return 0;
+	}
+}
+
+/*
+ * fixup_free is called when:
+ * - an active object is freed
+ */
+static int work_fixup_free(void *addr, enum debug_obj_state state)
+{
+	struct work_struct *work = addr;
+
+	switch (state) {
+	case ODEBUG_STATE_ACTIVE:
+		cancel_work_sync(work);
+		debug_object_free(work, &work_debug_descr);
+		return 1;
+	default:
+		return 0;
+	}
+}
+
+static struct debug_obj_descr work_debug_descr = {
+	.name		= "work_struct",
+	.fixup_init	= work_fixup_init,
+	.fixup_activate	= work_fixup_activate,
+	.fixup_free	= work_fixup_free,
+};
+
+static inline void debug_work_activate(struct work_struct *work)
+{
+	debug_object_activate(work, &work_debug_descr);
+}
+
+static inline void debug_work_deactivate(struct work_struct *work)
+{
+	debug_object_deactivate(work, &work_debug_descr);
+}
+
+void __init_work(struct work_struct *work, int onstack)
+{
+	if (onstack)
+		debug_object_init_on_stack(work, &work_debug_descr);
+	else
+		debug_object_init(work, &work_debug_descr);
+}
+EXPORT_SYMBOL_GPL(__init_work);
+
+void destroy_work_on_stack(struct work_struct *work)
+{
+	debug_object_free(work, &work_debug_descr);
+}
+EXPORT_SYMBOL_GPL(destroy_work_on_stack);
+
+#else
+static inline void debug_work_activate(struct work_struct *work) { }
+static inline void debug_work_deactivate(struct work_struct *work) { }
+#endif
+
 /* Serializes the accesses to the list of workqueues. */
 static DEFINE_SPINLOCK(workqueue_lock);
 static LIST_HEAD(workqueues);
@@ -145,6 +255,7 @@ static void __queue_work(struct cpu_workqueue_struct *cwq,
 {
 	unsigned long flags;
 
+	debug_work_activate(work);
 	spin_lock_irqsave(&cwq->lock, flags);
 	insert_work(cwq, work, &cwq->worklist);
 	spin_unlock_irqrestore(&cwq->lock, flags);
@@ -280,6 +391,7 @@ static void run_workqueue(struct cpu_workqueue_struct *cwq)
 		struct lockdep_map lockdep_map = work->lockdep_map;
 #endif
 		trace_workqueue_execution(cwq->thread, work);
+		debug_work_deactivate(work);
 		cwq->current_work = work;
 		list_del_init(cwq->worklist.next);
 		spin_unlock_irq(&cwq->lock);
@@ -350,11 +462,18 @@ static void wq_barrier_func(struct work_struct *work)
 static void insert_wq_barrier(struct cpu_workqueue_struct *cwq,
 			struct wq_barrier *barr, struct list_head *head)
 {
-	INIT_WORK(&barr->work, wq_barrier_func);
+	/*
+	 * debugobject calls are safe here even with cwq->lock locked
+	 * as we know for sure that this will not trigger any of the
+	 * checks and call back into the fixup functions where we
+	 * might deadlock.
+	 */
+	INIT_WORK_ON_STACK(&barr->work, wq_barrier_func);
 	__set_bit(WORK_STRUCT_PENDING, work_data_bits(&barr->work));
 
 	init_completion(&barr->done);
 
+	debug_work_activate(&barr->work);
 	insert_work(cwq, &barr->work, head);
 }
 
@@ -372,8 +491,10 @@ static int flush_cpu_workqueue(struct cpu_workqueue_struct *cwq)
 	}
 	spin_unlock_irq(&cwq->lock);
 
-	if (active)
+	if (active) {
 		wait_for_completion(&barr.done);
+		destroy_work_on_stack(&barr.work);
+	}
 
 	return active;
 }
@@ -451,6 +572,7 @@ out:
 		return 0;
 
 	wait_for_completion(&barr.done);
+	destroy_work_on_stack(&barr.work);
 	return 1;
 }
 EXPORT_SYMBOL_GPL(flush_work);
@@ -485,6 +607,7 @@ static int try_to_grab_pending(struct work_struct *work)
 		 */
 		smp_rmb();
 		if (cwq == get_wq_data(work)) {
+			debug_work_deactivate(work);
 			list_del_init(&work->entry);
 			ret = 1;
 		}
@@ -507,8 +630,10 @@ static void wait_on_cpu_work(struct cpu_workqueue_struct *cwq,
 	}
 	spin_unlock_irq(&cwq->lock);
 
-	if (unlikely(running))
+	if (unlikely(running)) {
 		wait_for_completion(&barr.done);
+		destroy_work_on_stack(&barr.work);
+	}
 }
 
 static void wait_on_work(struct work_struct *work)
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 234ceb1..c91f051 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -298,6 +298,14 @@ config DEBUG_OBJECTS_TIMERS
 	  timer routines to track the life time of timer objects and
 	  validate the timer operations.
 
+config DEBUG_OBJECTS_WORK
+	bool "Debug work objects"
+	depends on DEBUG_OBJECTS
+	help
+	  If you say Y here, additional code will be inserted into the
+	  work queue routines to track the life time of work objects and
+	  validate the work operations.
+
 config DEBUG_OBJECTS_ENABLE_DEFAULT
 	int "debug_objects bootup default value (0-1)"
         range 0 1
