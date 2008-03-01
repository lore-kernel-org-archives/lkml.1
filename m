Return-Path: <linux-kernel-owner+w=401wt.eu-S1762047AbYCAK0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762047AbYCAK0A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 05:26:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756633AbYCAKZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 05:25:25 -0500
Received: from www.tglx.de ([62.245.132.106]:44134 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756248AbYCAKZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 05:25:24 -0500
Message-Id: <20080301100325.632812903@linutronix.de>
References: <20080301100019.640027768@linutronix.de>
User-Agent: quilt/0.46-1
Date: Sat, 01 Mar 2008 10:25:00 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Greg KH <greg@kroah.com>
Subject: [patch 2/2] add timer specific object debugging code
Content-Disposition: inline; filename=timer-debugging.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add calls to the generic object debugging infrastructure and provide a
fixup function which allows to keep the system alive when recoverable
problems have been detected by the object debugging core code. Add a
selftest, which covers the two possible mistakes: free/init of an
active timer.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/debugobjects.h |    1 
 include/linux/timer.h        |   22 +++++++++++
 kernel/timer.c               |   85 +++++++++++++++++++++++++++++++++++++++++++
 lib/Kconfig.debug            |    7 +++
 lib/debugobjects.c           |   18 ++++++++-
 5 files changed, 131 insertions(+), 2 deletions(-)

Index: linux-2.6/include/linux/debugobjects.h
===================================================================
--- linux-2.6.orig/include/linux/debugobjects.h
+++ linux-2.6/include/linux/debugobjects.h
@@ -14,6 +14,7 @@ enum debug_obj_op {
 
 enum {
 	ODEBUG_TYPE_UNKNOWN,
+	ODEBUG_TYPE_TIMER,
 	ODEBUG_MAX_TYPES
 };
 
Index: linux-2.6/include/linux/timer.h
===================================================================
--- linux-2.6.orig/include/linux/timer.h
+++ linux-2.6/include/linux/timer.h
@@ -4,6 +4,7 @@
 #include <linux/list.h>
 #include <linux/ktime.h>
 #include <linux/stddef.h>
+#include <linux/debugobjects.h>
 
 struct tvec_base;
 
@@ -20,6 +21,9 @@ struct timer_list {
 	char start_comm[16];
 	int start_pid;
 #endif
+#ifdef CONFIG_DEBUG_OBJECT_TIMERS
+	struct debug_obj dobj;
+#endif
 };
 
 extern struct tvec_base boot_tvec_bases;
@@ -164,5 +168,23 @@ unsigned long __round_jiffies_relative(u
 unsigned long round_jiffies(unsigned long j);
 unsigned long round_jiffies_relative(unsigned long j);
 
+#ifdef CONFIG_DEBUG_OBJECT_TIMERS
+static inline void
+debug_timer_object_op(struct timer_list *timer, enum debug_obj_op mode)
+{
+	timer->dobj.type = ODEBUG_TYPE_TIMER;
+	debug_object_op(&timer->dobj, mode);
+}
+extern int timer_fixup_object(struct debug_obj *obj, enum debug_obj_op mode);
+extern int timer_debug_object_selftest(void);
+#else
+static inline void
+debug_timer_object_op(struct timer_list *timer, enum debug_obj_op mode)
+{
+}
+# define timer_fixup_object NULL
+static inline int timer_debug_object_selftest(void) { return 0; }
+#endif
+
 
 #endif
Index: linux-2.6/kernel/timer.c
===================================================================
--- linux-2.6.orig/kernel/timer.c
+++ linux-2.6/kernel/timer.c
@@ -320,6 +320,84 @@ static void timer_stats_account_timer(st
 static void timer_stats_account_timer(struct timer_list *timer) {}
 #endif
 
+#ifdef CONFIG_DEBUG_OBJECT_TIMERS
+
+static int timer_fixup_done __read_mostly;
+
+int timer_fixup_object(struct debug_obj *obj, enum debug_obj_op op)
+{
+	struct timer_list *timer = container_of(obj, struct timer_list, dobj);
+
+	switch (op) {
+	case ODEBUG_INIT:
+	case ODEBUG_FREE:
+		del_timer_sync(timer);
+		timer_fixup_done++;
+		return 0;
+	/*
+	 * These are fatal timer.c internal errors. No real way to
+	 * survive:
+	 */
+	case ODEBUG_ADD:
+	case ODEBUG_DEL:
+		return -1;
+	default:
+		return -1;
+	}
+}
+
+/*
+ * Test the two popular bugs:
+ *
+ * - reinit a timer which is enqueued
+ * - free a datastructure which contains an enqueued timer
+ */
+
+static void __init timer_debug_selftest_fn(unsigned long arg)
+{
+}
+
+int __init timer_debug_object_selftest(void)
+{
+	struct timer_list *timer;
+	int fixup_cnt = timer_fixup_done;
+
+	timer = kmalloc(sizeof(struct timer_list), GFP_KERNEL);
+	if (!timer)
+		return -ENOMEM;
+
+	setup_timer(timer, timer_debug_selftest_fn, 0);
+
+	timer->expires = jiffies + HZ;
+	add_timer(timer);
+
+	setup_timer(timer, timer_debug_selftest_fn, 0);
+	if (fixup_cnt == timer_fixup_done)
+		goto err;
+
+#ifdef CONFIG_DEBUG_OBJECTS_FREE
+	timer->expires = jiffies + HZ;
+	add_timer(timer);
+
+	fixup_cnt = timer_fixup_done;
+	kfree(timer);
+	timer = NULL;
+
+	if (fixup_cnt == timer_fixup_done)
+		goto err;
+#else
+	kfree(timer);
+#endif
+	return 0;
+
+err:
+	printk(KERN_ERR "TIMER: ODEBUG selftest failed\n");
+	kfree(timer);
+	return -1;
+}
+
+#endif
+
 /**
  * init_timer - initialize a timer.
  * @timer: the timer to be initialized
@@ -329,6 +407,8 @@ static void timer_stats_account_timer(st
  */
 void init_timer(struct timer_list *timer)
 {
+	debug_timer_object_op(timer, ODEBUG_INIT);
+
 	timer->entry.next = NULL;
 	timer->base = __raw_get_cpu_var(tvec_bases);
 #ifdef CONFIG_TIMER_STATS
@@ -351,6 +431,8 @@ static inline void detach_timer(struct t
 {
 	struct list_head *entry = &timer->entry;
 
+	debug_timer_object_op(timer, ODEBUG_DEL);
+
 	__list_del(entry->prev, entry->next);
 	if (clear_pending)
 		entry->next = NULL;
@@ -405,6 +487,8 @@ int __mod_timer(struct timer_list *timer
 		ret = 1;
 	}
 
+	debug_timer_object_op(timer, ODEBUG_ADD);
+
 	new_base = __get_cpu_var(tvec_bases);
 
 	if (base != new_base) {
@@ -450,6 +534,7 @@ void add_timer_on(struct timer_list *tim
 	BUG_ON(timer_pending(timer) || !timer->function);
 	spin_lock_irqsave(&base->lock, flags);
 	timer_set_base(timer, base);
+	debug_timer_object_op(timer, ODEBUG_ADD);
 	internal_add_timer(base, timer);
 	spin_unlock_irqrestore(&base->lock, flags);
 }
Index: linux-2.6/lib/Kconfig.debug
===================================================================
--- linux-2.6.orig/lib/Kconfig.debug
+++ linux-2.6/lib/Kconfig.debug
@@ -199,6 +199,13 @@ config DEBUG_OBJECT_FREE
 	 properly.  This can make kmalloc/kfree-intensive workloads
 	 much slower.
 
+config DEBUG_OBJECT_TIMERS
+	bool "Debug timer objects"
+       	depends on DEBUG_OBJECT_OPS
+       	help
+	  If you say Y here, additional code will be inserted into the
+	  timer routines to validate the timer operations.
+
 config DEBUG_SLAB
 	bool "Debug slab memory allocations"
 	depends on DEBUG_KERNEL && SLAB
Index: linux-2.6/lib/debugobjects.c
===================================================================
--- linux-2.6.orig/lib/debugobjects.c
+++ linux-2.6/lib/debugobjects.c
@@ -12,6 +12,7 @@
 #include <linux/debugfs.h>
 #include <linux/debugobjects.h>
 #include <linux/seq_file.h>
+#include <linux/timer.h>
 
 #define ODEBUG_HASH_SIZE	4096
 #define ODEBUG_HASH_MASK	(ODEBUG_HASH_SIZE - 1)
@@ -48,11 +49,13 @@ static struct odebug *object_get_hash(un
 }
 
 static const void * const debug_fixup[ODEBUG_MAX_TYPES] = {
+	[ODEBUG_TYPE_TIMER] = timer_fixup_object,
 };
 
 static const char * const obj_types[ODEBUG_MAX_TYPES] = {
 
 	[ODEBUG_TYPE_UNKNOWN] = "unknown type",
+	[ODEBUG_TYPE_TIMER] = "timer_list",
 };
 
 static void debug_print_object(struct debug_obj *obj, char *msg)
@@ -246,11 +249,22 @@ void __init debug_objects_init(void)
 
 int __init debug_objects_do_selftest(void)
 {
+	int res;
+
 	if (!debug_objects_enabled)
 		return 0;
 
 	debug_objects_init_debugfs();
-	printk(KERN_INFO "ODEBUG: Selftest pass\n");
-	return 0;
+
+	debug_objects_selftest = 1;
+
+	res = timer_debug_object_selftest();
+
+	debug_objects_selftest = 0;
+
+	if (!res)
+		printk(KERN_INFO "ODEBUG: Selftest pass\n");
+
+	return res;
 }
 __initcall(debug_objects_do_selftest);

-- 

