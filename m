Return-Path: <linux-kernel-owner+w=401wt.eu-S1755898AbYJXJqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898AbYJXJqV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 05:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752125AbYJXJqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 05:46:12 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:54315 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbYJXJqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 05:46:10 -0400
Subject: [PATCH 2/2] timer: implement lockdep deadlock detection
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1224790541.6002.53.camel@johannes.berg>
References: <1224790541.6002.53.camel@johannes.berg>
Content-Type: text/plain
Date: Thu, 23 Oct 2008 21:46:02 +0200
Message-Id: <1224791162.6002.67.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This modifies the timer code in a way to allow lockdep to detect
deadlocks resulting from a lock being taken in the timer function
as well as around the del_timer_sync() call.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/linux/timer.h |   93 +++++++++++++++++++++++++++++++++++++++++---------
 kernel/timer.c        |   40 +++++++++++++++------
 2 files changed, 106 insertions(+), 27 deletions(-)

--- wireless-testing.orig/include/linux/timer.h	2008-10-23 21:06:23.948352811 +0200
+++ wireless-testing/include/linux/timer.h	2008-10-23 21:30:06.468674841 +0200
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
--- wireless-testing.orig/kernel/timer.c	2008-10-23 21:06:23.993350111 +0200
+++ wireless-testing/kernel/timer.c	2008-10-23 21:08:10.172098297 +0200
@@ -422,14 +422,18 @@ static inline void debug_timer_free(stru
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
@@ -443,7 +447,9 @@ static inline void debug_timer_activate(
 static inline void debug_timer_deactivate(struct timer_list *timer) { }
 #endif
 
-static void __init_timer(struct timer_list *timer)
+static void __init_timer(struct timer_list *timer,
+			 const char *name,
+			 struct lock_class_key *key)
 {
 	timer->entry.next = NULL;
 	timer->base = __raw_get_cpu_var(tvec_bases);
@@ -452,6 +458,7 @@ static void __init_timer(struct timer_li
 	timer->start_pid = -1;
 	memset(timer->start_comm, 0, TASK_COMM_LEN);
 #endif
+	lockdep_init_map(&timer->lockdep_map, name, key, 0);
 }
 
 /**
@@ -461,19 +468,23 @@ static void __init_timer(struct timer_li
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
@@ -720,6 +731,9 @@ EXPORT_SYMBOL(try_to_del_timer_sync);
  */
 int del_timer_sync(struct timer_list *timer)
 {
+	lock_map_acquire_noirq(&timer->lockdep_map);
+	lock_map_release(&timer->lockdep_map);
+
 	for (;;) {
 		int ret = try_to_del_timer_sync(timer);
 		if (ret >= 0)
@@ -795,7 +809,9 @@ static inline void __run_timers(struct t
 			spin_unlock_irq(&base->lock);
 			{
 				int preempt_count = preempt_count();
+				lock_map_acquire_noirq(&timer->lockdep_map);
 				fn(data);
+				lock_map_release(&timer->lockdep_map);
 				if (preempt_count != preempt_count()) {
 					printk(KERN_ERR "huh, entered %p "
 					       "with preempt_count %08x, exited"


