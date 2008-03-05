Return-Path: <linux-kernel-owner+w=401wt.eu-S1757877AbYCEUOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757877AbYCEUOu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 15:14:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755913AbYCEUOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 15:14:37 -0500
Received: from www.tglx.de ([62.245.132.106]:44391 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068AbYCEUOg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 15:14:36 -0500
Date: Wed, 5 Mar 2008 21:14:07 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 5/5] debugobjects: add timer specific object debugging
 code
In-Reply-To: <20080305155117.606673820@linutronix.de>
Message-ID: <alpine.LFD.1.00.0803052055200.3099@apollo.tec.linutronix.de>
References: <20080305154829.185609547@linutronix.de> <20080305155117.606673820@linutronix.de>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Mar 2008, Thomas Gleixner wrote:

Oops. Being exited about the working infrastructure let me forget to
make it compile with the timer debug code disabled.

Updated patch below.

Thanks,
	tglx

--------------->

Subject: debugobjects: add timer specific object debugging code
From: Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 26 Feb 2008 09:28:37 +0100

Add calls to the generic object debugging infrastructure and provide
fixup functions which allow to keep the system alive when recoverable
problems have been detected by the object debugging core code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/poison.h |    7 +++
 include/linux/timer.h  |    3 -
 kernel/timer.c         |  110 +++++++++++++++++++++++++++++++++++++++++++++++++
 lib/Kconfig.debug      |    8 +++
 4 files changed, 127 insertions(+), 1 deletion(-)

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
@@ -164,5 +166,4 @@ unsigned long __round_jiffies_relative(u
 unsigned long round_jiffies(unsigned long j);
 unsigned long round_jiffies_relative(unsigned long j);
 
-
 #endif
Index: linux-2.6/kernel/timer.c
===================================================================
--- linux-2.6.orig/kernel/timer.c
+++ linux-2.6/kernel/timer.c
@@ -320,6 +320,109 @@ static void timer_stats_account_timer(st
 static void timer_stats_account_timer(struct timer_list *timer) {}
 #endif
 
+#ifdef CONFIG_DEBUG_OBJECTS_TIMERS
+
+static struct debug_obj_descr timer_debug_descr;
+
+/*
+ * fixup_init is called when:
+ * - an active object is initialized
+ */
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
+#else
+static inline void debug_timer_init(struct timer_list *timer) { }
+static inline void debug_timer_activate(struct timer_list *timer) { }
+static inline void debug_timer_deactivate(struct timer_list *timer) { }
+#endif
+
 /**
  * init_timer - initialize a timer.
  * @timer: the timer to be initialized
@@ -329,6 +432,8 @@ static void timer_stats_account_timer(st
  */
 void init_timer(struct timer_list *timer)
 {
+	debug_timer_init(timer);
+
 	timer->entry.next = NULL;
 	timer->base = __raw_get_cpu_var(tvec_bases);
 #ifdef CONFIG_TIMER_STATS
@@ -351,6 +456,8 @@ static inline void detach_timer(struct t
 {
 	struct list_head *entry = &timer->entry;
 
+	debug_timer_deactivate(timer);
+
 	__list_del(entry->prev, entry->next);
 	if (clear_pending)
 		entry->next = NULL;
@@ -405,6 +512,8 @@ int __mod_timer(struct timer_list *timer
 		ret = 1;
 	}
 
+	debug_timer_activate(timer);
+
 	new_base = __get_cpu_var(tvec_bases);
 
 	if (base != new_base) {
@@ -450,6 +559,7 @@ void add_timer_on(struct timer_list *tim
 	BUG_ON(timer_pending(timer) || !timer->function);
 	spin_lock_irqsave(&base->lock, flags);
 	timer_set_base(timer, base);
+	debug_timer_activate(timer);
 	internal_add_timer(base, timer);
 	spin_unlock_irqrestore(&base->lock, flags);
 }
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
