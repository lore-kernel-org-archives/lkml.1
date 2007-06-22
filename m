Return-Path: <linux-kernel-owner+w=401wt.eu-S1752084AbXFVEFI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084AbXFVEFI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 00:05:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751524AbXFVEEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 00:04:11 -0400
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:52511 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbXFVEEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 00:04:09 -0400
Message-Id: <20070622040137.255664480@goodmis.org>
References: <20070622040014.234651401@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 22 Jun 2007 00:00:19 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com,
       kuznet@ms2.inr.ac.ru
Subject: [RFC PATCH 5/6] Move tasklet.h to tasklet_softirq.h
Content-Disposition: inline; filename=move-tasklet_h-to-tasklet_softirq_h.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Getting ready for the two versions of tasklet implementations,
we move tasklet.h to tasklet_softirq.h and just include it in
tasklet.h.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-2.6-test/include/linux/tasklet.h
===================================================================
--- linux-2.6-test.orig/include/linux/tasklet.h
+++ linux-2.6-test/include/linux/tasklet.h
@@ -1,125 +1,6 @@
 #ifndef _LINUX_TASKLET_H
 #define _LINUX_TASKLET_H
 
-/* Tasklets --- multithreaded analogue of BHs.
+#include <linux/tasklet_softirq.h>
 
-   Main feature differing them of generic softirqs: tasklet
-   is running only on one CPU simultaneously.
-
-   Main feature differing them of BHs: different tasklets
-   may be run simultaneously on different CPUs.
-
-   Properties:
-   * If tasklet_schedule() is called, then tasklet is guaranteed
-     to be executed on some cpu at least once after this.
-   * If the tasklet is already scheduled, but its excecution is still not
-     started, it will be executed only once.
-   * If this tasklet is already running on another CPU (or schedule is called
-     from tasklet itself), it is rescheduled for later.
-   * Tasklet is strictly serialized wrt itself, but not
-     wrt another tasklets. If client needs some intertask synchronization,
-     he makes it with spinlocks.
- */
-
-struct tasklet_struct
-{
-	struct tasklet_struct *next;
-	unsigned long state;
-	atomic_t count;
-	void (*func)(unsigned long);
-	unsigned long data;
-};
-
-#define DECLARE_TASKLET(name, func, data) \
-struct tasklet_struct name = { NULL, 0, ATOMIC_INIT(0), func, data }
-
-#define DECLARE_TASKLET_DISABLED(name, func, data) \
-struct tasklet_struct name = { NULL, 0, ATOMIC_INIT(1), func, data }
-
-
-enum
-{
-	TASKLET_STATE_SCHED,	/* Tasklet is scheduled for execution */
-	TASKLET_STATE_RUN	/* Tasklet is running (SMP only) */
-};
-
-#ifdef CONFIG_SMP
-static inline int tasklet_trylock(struct tasklet_struct *t)
-{
-	return !test_and_set_bit(TASKLET_STATE_RUN, &(t)->state);
-}
-
-static inline void tasklet_unlock(struct tasklet_struct *t)
-{
-	smp_mb__before_clear_bit(); 
-	clear_bit(TASKLET_STATE_RUN, &(t)->state);
-}
-
-static inline void tasklet_unlock_wait(struct tasklet_struct *t)
-{
-	while (test_bit(TASKLET_STATE_RUN, &(t)->state)) { barrier(); }
-}
-#else
-#define tasklet_trylock(t) 1
-#define tasklet_unlock_wait(t) do { } while (0)
-#define tasklet_unlock(t) do { } while (0)
 #endif
-
-extern void FASTCALL(__tasklet_schedule(struct tasklet_struct *t));
-
-static inline void tasklet_schedule(struct tasklet_struct *t)
-{
-	if (!test_and_set_bit(TASKLET_STATE_SCHED, &t->state))
-		__tasklet_schedule(t);
-}
-
-extern void FASTCALL(__tasklet_hi_schedule(struct tasklet_struct *t));
-
-static inline void tasklet_hi_schedule(struct tasklet_struct *t)
-{
-	if (!test_and_set_bit(TASKLET_STATE_SCHED, &t->state))
-		__tasklet_hi_schedule(t);
-}
-
-
-static inline void tasklet_disable_nosync(struct tasklet_struct *t)
-{
-	atomic_inc(&t->count);
-	smp_mb__after_atomic_inc();
-}
-
-static inline void tasklet_disable(struct tasklet_struct *t)
-{
-	tasklet_disable_nosync(t);
-	tasklet_unlock_wait(t);
-	smp_mb();
-}
-
-static inline void tasklet_enable(struct tasklet_struct *t)
-{
-	smp_mb__before_atomic_dec();
-	atomic_dec(&t->count);
-}
-
-static inline void tasklet_hi_enable(struct tasklet_struct *t)
-{
-	smp_mb__before_atomic_dec();
-	atomic_dec(&t->count);
-}
-
-static inline int tasklet_is_scheduled(struct tasklet_struct *t)
-{
-	return test_bit(TASKLET_STATE_SCHED, &t->state);
-}
-
-extern void tasklet_kill(struct tasklet_struct *t);
-extern void tasklet_kill_immediate(struct tasklet_struct *t, unsigned int cpu);
-extern void tasklet_init(struct tasklet_struct *t,
-			 void (*func)(unsigned long), unsigned long data);
-
-#ifdef CONFIG_HOTPLUG_CPU
-void takeover_tasklets(unsigned int cpu);
-#endif /* CONFIG_HOTPLUG_CPU */
-
-#endif /* _LINUX_TASKLET_H */
-
Index: linux-2.6-test/include/linux/tasklet_softirq.h
===================================================================
--- /dev/null
+++ linux-2.6-test/include/linux/tasklet_softirq.h
@@ -0,0 +1,129 @@
+#ifndef _LINUX_TASKLET_SOFTIRQ_H
+#define _LINUX_TASKLET_SOFTIRQ_H
+
+#ifndef _LINUX_TASKLET_H
+# error "Do not include this header directly! use linux/tasklet.h"
+#endif
+
+/* Tasklets --- multithreaded analogue of BHs.
+
+   Main feature differing them of generic softirqs: tasklet
+   is running only on one CPU simultaneously.
+
+   Main feature differing them of BHs: different tasklets
+   may be run simultaneously on different CPUs.
+
+   Properties:
+   * If tasklet_schedule() is called, then tasklet is guaranteed
+     to be executed on some cpu at least once after this.
+   * If the tasklet is already scheduled, but its excecution is still not
+     started, it will be executed only once.
+   * If this tasklet is already running on another CPU (or schedule is called
+     from tasklet itself), it is rescheduled for later.
+   * Tasklet is strictly serialized wrt itself, but not
+     wrt another tasklets. If client needs some intertask synchronization,
+     he makes it with spinlocks.
+ */
+
+struct tasklet_struct
+{
+	struct tasklet_struct *next;
+	unsigned long state;
+	atomic_t count;
+	void (*func)(unsigned long);
+	unsigned long data;
+};
+
+#define DECLARE_TASKLET(name, func, data) \
+struct tasklet_struct name = { NULL, 0, ATOMIC_INIT(0), func, data }
+
+#define DECLARE_TASKLET_DISABLED(name, func, data) \
+struct tasklet_struct name = { NULL, 0, ATOMIC_INIT(1), func, data }
+
+
+enum
+{
+	TASKLET_STATE_SCHED,	/* Tasklet is scheduled for execution */
+	TASKLET_STATE_RUN	/* Tasklet is running (SMP only) */
+};
+
+#ifdef CONFIG_SMP
+static inline int tasklet_trylock(struct tasklet_struct *t)
+{
+	return !test_and_set_bit(TASKLET_STATE_RUN, &(t)->state);
+}
+
+static inline void tasklet_unlock(struct tasklet_struct *t)
+{
+	smp_mb__before_clear_bit(); 
+	clear_bit(TASKLET_STATE_RUN, &(t)->state);
+}
+
+static inline void tasklet_unlock_wait(struct tasklet_struct *t)
+{
+	while (test_bit(TASKLET_STATE_RUN, &(t)->state)) { barrier(); }
+}
+#else
+#define tasklet_trylock(t) 1
+#define tasklet_unlock_wait(t) do { } while (0)
+#define tasklet_unlock(t) do { } while (0)
+#endif
+
+extern void FASTCALL(__tasklet_schedule(struct tasklet_struct *t));
+
+static inline void tasklet_schedule(struct tasklet_struct *t)
+{
+	if (!test_and_set_bit(TASKLET_STATE_SCHED, &t->state))
+		__tasklet_schedule(t);
+}
+
+extern void FASTCALL(__tasklet_hi_schedule(struct tasklet_struct *t));
+
+static inline void tasklet_hi_schedule(struct tasklet_struct *t)
+{
+	if (!test_and_set_bit(TASKLET_STATE_SCHED, &t->state))
+		__tasklet_hi_schedule(t);
+}
+
+
+static inline void tasklet_disable_nosync(struct tasklet_struct *t)
+{
+	atomic_inc(&t->count);
+	smp_mb__after_atomic_inc();
+}
+
+static inline void tasklet_disable(struct tasklet_struct *t)
+{
+	tasklet_disable_nosync(t);
+	tasklet_unlock_wait(t);
+	smp_mb();
+}
+
+static inline void tasklet_enable(struct tasklet_struct *t)
+{
+	smp_mb__before_atomic_dec();
+	atomic_dec(&t->count);
+}
+
+static inline void tasklet_hi_enable(struct tasklet_struct *t)
+{
+	smp_mb__before_atomic_dec();
+	atomic_dec(&t->count);
+}
+
+static inline int tasklet_is_scheduled(struct tasklet_struct *t)
+{
+	return test_bit(TASKLET_STATE_SCHED, &t->state);
+}
+
+extern void tasklet_kill(struct tasklet_struct *t);
+extern void tasklet_kill_immediate(struct tasklet_struct *t, unsigned int cpu);
+extern void tasklet_init(struct tasklet_struct *t,
+			 void (*func)(unsigned long), unsigned long data);
+
+#ifdef CONFIG_HOTPLUG_CPU
+void takeover_tasklets(unsigned int cpu);
+#endif /* CONFIG_HOTPLUG_CPU */
+
+#endif /* _LINUX_TASKLET_H */
+

-- 
