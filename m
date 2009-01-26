Return-Path: <linux-kernel-owner+w=401wt.eu-S1754614AbZAZXAJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614AbZAZXAJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 18:00:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303AbZAZW74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 17:59:56 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:38781 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbZAZW7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 17:59:55 -0500
Subject: [PATCH] timer: implement lockdep deadlock detection
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain
Date: Mon, 26 Jan 2009 23:59:46 +0100
Message-Id: <1233010786.4344.1.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This modifies the timer code in a way to allow lockdep to detect
deadlocks resulting from a lock being taken in the timer function
as well as around the del_timer_sync() call.

Validated with this module, otherwise bootup was clean.

--->%---
#include <linux/module.h>
#include <linux/timer.h>
#include <linux/spinlock.h>

static struct timer_list t;
static spinlock_t l;

MODULE_LICENSE("GPL");

void fn(unsigned long dummy)
{
	spin_lock_irq(&l);
	spin_unlock_irq(&l);
	printk(KERN_DEBUG "TEST\n");
}

static int i(void)
{
	spin_lock_init(&l);
	setup_timer(&t, fn, 0);
	mod_timer(&t, jiffies + HZ);
	return 0;
}
module_init(i);

static void e(void)
{
	spin_lock_irq(&l);
	del_timer_sync(&t);
	spin_unlock_irq(&l);
}
module_exit(e);
---%<---

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/linux/timer.h |   93 +++++++++++++++++++++++++++++++++++++++++---------
 kernel/timer.c        |   55 +++++++++++++++++++++++------
 2 files changed, 121 insertions(+), 27 deletions(-)

--- wireless-testing.orig/include/linux/timer.h	2009-01-26 22:57:40.000000000 +0100
+++ wireless-testing/include/linux/timer.h	2009-01-26 22:57:52.000000000 +0100
@@ -21,52 +21,115 @@ struct timer_list {
 	char start_comm[16];
 	int start_pid;
 #endif
+#ifdef CONFIG_LOCKDEP
+	struct lockdep_map lockdep_map;
+#endif
 };
 
 extern struct tvec_base boot_tvec_bases;
 
-#define TIMER_INITIALIZER(_function, _expires, _data) {		\
-		.entry = { .prev = TIMER_ENTRY_STATIC },	\
-		.function = (_function),			\
-		.expires = (_expires),				\
-		.data = (_data),				\
-		.base = &boot_tvec_bases,			\
+#ifdef CONFIG_LOCKDEP
+#define __TIMER_LOCKDEP_MAP_INITIALIZER(fn, name)		\
+	.lockdep_map = STATIC_LOCKDEP_MAP_INIT(name, fn),
+#else
+#define __TIMER_LOCKDEP_MAP_INITIALIZER(fn, name)
+#endif
+
+#define TIMER_INITIALIZER(_function, _expires, _data) {			\
+		.entry = { .prev = TIMER_ENTRY_STATIC },		\
+		.function = (_function),				\
+		.expires = (_expires),					\
+		.data = (_data),					\
+		.base = &boot_tvec_bases,				\
+		__TIMER_LOCKDEP_MAP_INITIALIZER((_function), #_function)\
 	}
 
 #define DEFINE_TIMER(_name, _function, _expires, _data)		\
 	struct timer_list _name =				\
 		TIMER_INITIALIZER(_function, _expires, _data)
 
-void init_timer(struct timer_list *timer);
-void init_timer_deferrable(struct timer_list *timer);
+void init_timer_key(struct timer_list *timer,
+		    const char *name,
+		    struct lock_class_key *key);
+void init_timer_deferrable_key(struct timer_list *timer,
+			       const char *name,
+			       struct lock_class_key *key);
+
+#ifdef CONFIG_LOCKDEP
+#define init_timer(timer)						\
+	do {								\
+		static struct lock_class_key __key;			\
+		init_timer_key((timer), #timer, &__key);		\
+	} while (0)
+#define init_timer_deferrable(timer)					\
+	do {								\
+		static struct lock_class_key __key;			\
+		init_timer_deferrable_key((timer), #timer, &__key);	\
+	} while (0)
+#define init_timer_on_stack(timer)					\
+	do {								\
+		static struct lock_class_key __key;			\
+		init_timer_on_stack_key((timer), #timer, &__key);	\
+	} while (0)
+#define setup_timer(timer, fn, data)					\
+	do {								\
+		static struct lock_class_key __key;			\
+		setup_timer_key((timer), #timer, &__key, (fn), (data));\
+	} while (0)
+#define setup_timer_on_stack(timer, fn, data)				\
+	do {								\
+		static struct lock_class_key __key;			\
+		setup_timer_on_stack_key((timer), #timer, &__key,	\
+					 (fn), (data));			\
+	} while (0)
+#else
+#define init_timer(timer)\
+	init_timer_key((timer), NULL, NULL)
+#define init_timer_deferrable(timer)\
+	init_timer_deferrable_key((timer), NULL, NULL)
+#define init_timer_on_stack(timer)\
+	init_timer_on_stack_key((timer)), NULL, NULL)
+#define setup_timer(timer, fn, data)\
+	setup_timer_key((timer), NULL, NULL, (fn), (data))
+#define setup_timer_on_stack(timer, fn, data)\
+	setup_timer_on_stack_key((timer), NULL, NULL, (fn), (data))
+#endif
 
 #ifdef CONFIG_DEBUG_OBJECTS_TIMERS
-extern void init_timer_on_stack(struct timer_list *timer);
+extern void init_timer_on_stack_key(struct timer_list *timer,
+				    const char *name,
+				    struct lock_class_key *key);
 extern void destroy_timer_on_stack(struct timer_list *timer);
 #else
 static inline void destroy_timer_on_stack(struct timer_list *timer) { }
-static inline void init_timer_on_stack(struct timer_list *timer)
+static inline void init_timer_on_stack_key(struct timer_list *timer,
+					   const char *name,
+					   struct lock_class_key *key)
 {
-	init_timer(timer);
+	init_timer_key(timer, name, key);
 }
 #endif
 
-static inline void setup_timer(struct timer_list * timer,
+static inline void setup_timer_key(struct timer_list * timer,
+				const char *name,
+				struct lock_class_key *key,
 				void (*function)(unsigned long),
 				unsigned long data)
 {
 	timer->function = function;
 	timer->data = data;
-	init_timer(timer);
+	init_timer_key(timer, name, key);
 }
 
-static inline void setup_timer_on_stack(struct timer_list *timer,
+static inline void setup_timer_on_stack_key(struct timer_list *timer,
+					const char *name,
+					struct lock_class_key *key,
 					void (*function)(unsigned long),
 					unsigned long data)
 {
 	timer->function = function;
 	timer->data = data;
-	init_timer_on_stack(timer);
+	init_timer_on_stack_key(timer, name, key);
 }
 
 /**
--- wireless-testing.orig/kernel/timer.c	2009-01-26 22:57:40.000000000 +0100
+++ wireless-testing/kernel/timer.c	2009-01-26 23:37:33.000000000 +0100
@@ -491,14 +491,18 @@ static inline void debug_timer_free(stru
 	debug_object_free(timer, &timer_debug_descr);
 }
 
-static void __init_timer(struct timer_list *timer);
-
-void init_timer_on_stack(struct timer_list *timer)
+static void __init_timer(struct timer_list *timer,
+			 const char *name,
+			 struct lock_class_key *key);
+
+void init_timer_on_stack_key(struct timer_list *timer,
+			     const char *name,
+			     struct lock_class_key *key)
 {
 	debug_object_init_on_stack(timer, &timer_debug_descr);
-	__init_timer(timer);
+	__init_timer(timer, name, key);
 }
-EXPORT_SYMBOL_GPL(init_timer_on_stack);
+EXPORT_SYMBOL_GPL(init_timer_on_stack_key);
 
 void destroy_timer_on_stack(struct timer_list *timer)
 {
@@ -512,7 +516,9 @@ static inline void debug_timer_activate(
 static inline void debug_timer_deactivate(struct timer_list *timer) { }
 #endif
 
-static void __init_timer(struct timer_list *timer)
+static void __init_timer(struct timer_list *timer,
+			 const char *name,
+			 struct lock_class_key *key)
 {
 	timer->entry.next = NULL;
 	timer->base = __raw_get_cpu_var(tvec_bases);
@@ -521,6 +527,7 @@ static void __init_timer(struct timer_li
 	timer->start_pid = -1;
 	memset(timer->start_comm, 0, TASK_COMM_LEN);
 #endif
+	lockdep_init_map(&timer->lockdep_map, name, key, 0);
 }
 
 /**
@@ -530,19 +537,23 @@ static void __init_timer(struct timer_li
  * init_timer() must be done to a timer prior calling *any* of the
  * other timer functions.
  */
-void init_timer(struct timer_list *timer)
+void init_timer_key(struct timer_list *timer,
+		    const char *name,
+		    struct lock_class_key *key)
 {
 	debug_timer_init(timer);
-	__init_timer(timer);
+	__init_timer(timer, name, key);
 }
-EXPORT_SYMBOL(init_timer);
+EXPORT_SYMBOL(init_timer_key);
 
-void init_timer_deferrable(struct timer_list *timer)
+void init_timer_deferrable_key(struct timer_list *timer,
+			       const char *name,
+			       struct lock_class_key *key)
 {
-	init_timer(timer);
+	init_timer_key(timer, name, key);
 	timer_set_deferrable(timer);
 }
-EXPORT_SYMBOL(init_timer_deferrable);
+EXPORT_SYMBOL(init_timer_deferrable_key);
 
 static inline void detach_timer(struct timer_list *timer,
 				int clear_pending)
@@ -789,6 +800,15 @@ EXPORT_SYMBOL(try_to_del_timer_sync);
  */
 int del_timer_sync(struct timer_list *timer)
 {
+#ifdef CONFIG_LOCKDEP
+	unsigned long flags;
+
+	local_irq_save(flags);
+	lock_map_acquire(&timer->lockdep_map);
+	lock_map_release(&timer->lockdep_map);
+	local_irq_restore(flags);
+#endif
+
 	for (;;) {
 		int ret = try_to_del_timer_sync(timer);
 		if (ret >= 0)
@@ -861,10 +881,21 @@ static inline void __run_timers(struct t
 
 			set_running_timer(base, timer);
 			detach_timer(timer, 1);
+
 			spin_unlock_irq(&base->lock);
 			{
 				int preempt_count = preempt_count();
+
+				/* Couple the lock chain with the lock chain at
+				 * del_timer_sync by acquiring the lock_map around
+				 * the fn() call here and in del_timer_sync.
+				 */
+				lock_map_acquire(&timer->lockdep_map);
+
 				fn(data);
+
+				lock_map_release(&timer->lockdep_map);
+
 				if (preempt_count != preempt_count()) {
 					printk(KERN_ERR "huh, entered %p "
 					       "with preempt_count %08x, exited"


