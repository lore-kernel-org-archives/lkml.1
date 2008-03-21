Return-Path: <linux-kernel-owner+w=401wt.eu-S1757905AbYCUU11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757905AbYCUU11 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 16:27:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761492AbYCUU07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 16:26:59 -0400
Received: from www.tglx.de ([62.245.132.106]:60835 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761438AbYCUU04 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 16:26:56 -0400
Message-Id: <20080321200321.731058197@linutronix.de>
References: <20080321200300.310393657@linutronix.de>
User-Agent: quilt/0.46-1
Date: Fri, 21 Mar 2008 20:26:28 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Greg KH <greg@kroah.com>, Randy Dunlap <randy.dunlap@oracle.com>
Subject: [patch 4/5] debugobjects: add timer specific object debugging code
Content-Disposition: inline; filename=timer-debugging.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add calls to the generic object debugging infrastructure and provide
fixup functions which allow to keep the system alive when recoverable
problems have been detected by the object debugging core code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/parport/ieee1284.c |    4 -
 fs/aio.c                   |    5 -
 include/linux/poison.h     |    7 ++
 include/linux/timer.h      |   23 ++++++
 kernel/timer.c             |  153 ++++++++++++++++++++++++++++++++++++++++++---
 lib/Kconfig.debug          |    8 ++
 6 files changed, 187 insertions(+), 13 deletions(-)

Index: linux-2.6/drivers/parport/ieee1284.c
===================================================================
--- linux-2.6.orig/drivers/parport/ieee1284.c
+++ linux-2.6/drivers/parport/ieee1284.c
@@ -76,7 +76,7 @@ int parport_wait_event (struct parport *
 		   semaphore. */
 		return 1;
 
-	init_timer (&timer);
+	init_timer_on_stack(&timer);
 	timer.expires = jiffies + timeout;
 	timer.function = timeout_waiting_on_port;
 	port_from_cookie[port->number % PARPORT_MAX] = port;
@@ -88,6 +88,8 @@ int parport_wait_event (struct parport *
 		/* Timed out. */
 		ret = 1;
 
+	destroy_timer_on_stack(&timer);
+
 	return ret;
 }
 
Index: linux-2.6/fs/aio.c
===================================================================
--- linux-2.6.orig/fs/aio.c
+++ linux-2.6/fs/aio.c
@@ -1069,9 +1069,7 @@ static void timeout_func(unsigned long d
 
 static inline void init_timeout(struct aio_timeout *to)
 {
-	init_timer(&to->timer);
-	to->timer.data = (unsigned long)to;
-	to->timer.function = timeout_func;
+	setup_timer_on_stack(&to->timer, timeout_func, (unsigned long) to);
 	to->timed_out = 0;
 	to->p = current;
 }
@@ -1201,6 +1199,7 @@ retry:
 	if (timeout)
 		clear_timeout(&to);
 out:
+	destroy_timer_on_stack(&to.timer);
 	return i ? i : ret;
 }
 
Index: linux-2.6/include/linux/poison.h
===================================================================
--- linux-2.6.orig/include/linux/poison.h
+++ linux-2.6/include/linux/poison.h
@@ -10,6 +10,13 @@
 #define LIST_POISON1  ((void *) 0x00100100)
 #define LIST_POISON2  ((void *) 0x00200200)
 
+/********** include/linux/timer.h **********/
+/*
+ * Magic number "tsta" to indicate a static timer initializer
+ * for the object debugging code.
+ */
+#define TIMER_ENTRY_STATIC	((void *) 0x74737461)
+
 /********** mm/slab.c **********/
 /*
  * Magic nums for obj red zoning.
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
 
@@ -25,6 +26,7 @@ struct timer_list {
 extern struct tvec_base boot_tvec_bases;
 
 #define TIMER_INITIALIZER(_function, _expires, _data) {		\
+		.entry = { .prev = TIMER_ENTRY_STATIC },	\
 		.function = (_function),			\
 		.expires = (_expires),				\
 		.data = (_data),				\
@@ -38,6 +40,17 @@ extern struct tvec_base boot_tvec_bases;
 void init_timer(struct timer_list *timer);
 void init_timer_deferrable(struct timer_list *timer);
 
+#ifdef CONFIG_DEBUG_OBJECTS_TIMERS
+extern void init_timer_on_stack(struct timer_list *timer);
+extern void destroy_timer_on_stack(struct timer_list *timer);
+#else
+static inline void destroy_timer_on_stack(struct timer_list *timer) { }
+static inline void init_timer_on_stack(struct timer_list *timer)
+{
+	init_timer(timer);
+}
+#endif
+
 static inline void setup_timer(struct timer_list * timer,
 				void (*function)(unsigned long),
 				unsigned long data)
@@ -47,6 +60,15 @@ static inline void setup_timer(struct ti
 	init_timer(timer);
 }
 
+static inline void setup_timer_on_stack(struct timer_list *timer,
+					void (*function)(unsigned long),
+					unsigned long data)
+{
+	timer->function = function;
+	timer->data = data;
+	init_timer_on_stack(timer);
+}
+
 /**
  * timer_pending - is a timer pending?
  * @timer: the timer in question
@@ -164,5 +186,4 @@ unsigned long __round_jiffies_relative(u
 unsigned long round_jiffies(unsigned long j);
 unsigned long round_jiffies_relative(unsigned long j);
 
-
 #endif
Index: linux-2.6/kernel/timer.c
===================================================================
--- linux-2.6.orig/kernel/timer.c
+++ linux-2.6/kernel/timer.c
@@ -320,14 +320,130 @@ static void timer_stats_account_timer(st
 static void timer_stats_account_timer(struct timer_list *timer) {}
 #endif
 
-/**
- * init_timer - initialize a timer.
- * @timer: the timer to be initialized
- *
- * init_timer() must be done to a timer prior calling *any* of the
- * other timer functions.
+#ifdef CONFIG_DEBUG_OBJECTS_TIMERS
+
+static struct debug_obj_descr timer_debug_descr;
+
+/*
+ * fixup_init is called when:
+ * - an active object is initialized
  */
-void init_timer(struct timer_list *timer)
+static int timer_fixup_init(void *addr, enum debug_obj_state state)
+{
+	struct timer_list *timer = addr;
+
+	switch (state) {
+	case ODEBUG_STATE_ACTIVE:
+		del_timer_sync(timer);
+		debug_object_init(timer, &timer_debug_descr);
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
+static int timer_fixup_activate(void *addr, enum debug_obj_state state)
+{
+	struct timer_list *timer = addr;
+
+	switch (state) {
+
+	case ODEBUG_STATE_NOTAVAILABLE:
+		/*
+		 * This is not really a fixup. The timer was
+		 * statically initialized. We just make sure that it
+		 * is tracked in the object tracker.
+		 */
+		if (timer->entry.next == NULL &&
+		    timer->entry.prev == TIMER_ENTRY_STATIC) {
+			debug_object_init(timer, &timer_debug_descr);
+			debug_object_activate(timer, &timer_debug_descr);
+			return 0;
+		} else {
+			WARN_ON_ONCE(1);
+		}
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
+static int timer_fixup_free(void *addr, enum debug_obj_state state)
+{
+	struct timer_list *timer = addr;
+
+	switch (state) {
+	case ODEBUG_STATE_ACTIVE:
+		del_timer_sync(timer);
+		debug_object_free(timer, &timer_debug_descr);
+		return 1;
+	default:
+		return 0;
+	}
+}
+
+static struct debug_obj_descr timer_debug_descr = {
+	.name		= "timer_list",
+	.fixup_init	= timer_fixup_init,
+	.fixup_activate	= timer_fixup_activate,
+	.fixup_free	= timer_fixup_free,
+};
+
+static inline void debug_timer_init(struct timer_list *timer)
+{
+	debug_object_init(timer, &timer_debug_descr);
+}
+
+static inline void debug_timer_activate(struct timer_list *timer)
+{
+	debug_object_activate(timer, &timer_debug_descr);
+}
+
+static inline void debug_timer_deactivate(struct timer_list *timer)
+{
+	debug_object_deactivate(timer, &timer_debug_descr);
+}
+
+static inline void debug_timer_free(struct timer_list *timer)
+{
+	debug_object_free(timer, &timer_debug_descr);
+}
+
+static void __init_timer(struct timer_list *timer);
+
+void init_timer_on_stack(struct timer_list *timer)
+{
+	debug_object_init_on_stack(timer, &timer_debug_descr);
+	__init_timer(timer);
+}
+EXPORT_SYMBOL_GPL(init_timer_on_stack);
+
+void destroy_timer_on_stack(struct timer_list *timer)
+{
+	debug_object_free(timer, &timer_debug_descr);
+}
+EXPORT_SYMBOL_GPL(destroy_timer_on_stack);
+
+#else
+static inline void debug_timer_init(struct timer_list *timer) { }
+static inline void debug_timer_activate(struct timer_list *timer) { }
+static inline void debug_timer_deactivate(struct timer_list *timer) { }
+#endif
+
+static void __init_timer(struct timer_list *timer)
 {
 	timer->entry.next = NULL;
 	timer->base = __raw_get_cpu_var(tvec_bases);
@@ -337,6 +453,19 @@ void init_timer(struct timer_list *timer
 	memset(timer->start_comm, 0, TASK_COMM_LEN);
 #endif
 }
+
+/**
+ * init_timer - initialize a timer.
+ * @timer: the timer to be initialized
+ *
+ * init_timer() must be done to a timer prior calling *any* of the
+ * other timer functions.
+ */
+void init_timer(struct timer_list *timer)
+{
+	debug_timer_init(timer);
+	__init_timer(timer);
+}
 EXPORT_SYMBOL(init_timer);
 
 void init_timer_deferrable(struct timer_list *timer)
@@ -351,6 +480,8 @@ static inline void detach_timer(struct t
 {
 	struct list_head *entry = &timer->entry;
 
+	debug_timer_deactivate(timer);
+
 	__list_del(entry->prev, entry->next);
 	if (clear_pending)
 		entry->next = NULL;
@@ -405,6 +536,8 @@ int __mod_timer(struct timer_list *timer
 		ret = 1;
 	}
 
+	debug_timer_activate(timer);
+
 	new_base = __get_cpu_var(tvec_bases);
 
 	if (base != new_base) {
@@ -450,6 +583,7 @@ void add_timer_on(struct timer_list *tim
 	BUG_ON(timer_pending(timer) || !timer->function);
 	spin_lock_irqsave(&base->lock, flags);
 	timer_set_base(timer, base);
+	debug_timer_activate(timer);
 	internal_add_timer(base, timer);
 	spin_unlock_irqrestore(&base->lock, flags);
 }
@@ -1078,11 +1212,14 @@ signed long __sched schedule_timeout(sig
 
 	expire = timeout + jiffies;
 
-	setup_timer(&timer, process_timeout, (unsigned long)current);
+	setup_timer_on_stack(&timer, process_timeout, (unsigned long)current);
 	__mod_timer(&timer, expire);
 	schedule();
 	del_singleshot_timer_sync(&timer);
 
+	/* Remove the timer from the object tracker */
+	destroy_timer_on_stack(&timer);
+
 	timeout = expire - jiffies;
 
  out:
Index: linux-2.6/lib/Kconfig.debug
===================================================================
--- linux-2.6.orig/lib/Kconfig.debug
+++ linux-2.6/lib/Kconfig.debug
@@ -206,6 +206,14 @@ config DEBUG_OBJECTS_FREE
 	  properly. This can make kmalloc/kfree-intensive workloads
 	  much slower.
 
+config DEBUG_OBJECTS_TIMERS
+	bool "Debug timer objects"
+	depends on DEBUG_OBJECTS
+	help
+	  If you say Y here, additional code will be inserted into the
+	  timer routines to track the life time of timer objects and
+	  validate the timer operations.
+
 config DEBUG_SLAB
 	bool "Debug slab memory allocations"
 	depends on DEBUG_KERNEL && SLAB

-- 

