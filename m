Return-Path: <linux-kernel-owner+w=401wt.eu-S1762046AbYCUU21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762046AbYCUU21 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 16:28:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761586AbYCUU1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 16:27:07 -0400
Received: from www.tglx.de ([62.245.132.106]:60850 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761542AbYCUU1E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 16:27:04 -0400
Message-Id: <20080321200321.770268236@linutronix.de>
References: <20080321200300.310393657@linutronix.de>
User-Agent: quilt/0.46-1
Date: Fri, 21 Mar 2008 20:26:32 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Greg KH <greg@kroah.com>, Randy Dunlap <randy.dunlap@oracle.com>
Subject: [patch 5/5] add hrtimer specific debugobjects code
Content-Disposition: inline; filename=hrtimer-debugging.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hrtimers have now dynamic users in the network code. Put them under
debugobjects surveillance as well.
 
Add calls to the generic object debugging infrastructure and provide
fixup functions which allow to keep the system alive when recoverable
problems have been detected by the object debugging core code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/hrtimer.h |   15 ++++
 kernel/futex.c          |   13 +++
 kernel/hrtimer.c        |  176 ++++++++++++++++++++++++++++++++++++++++++------
 3 files changed, 182 insertions(+), 22 deletions(-)

Index: linux-2.6/include/linux/hrtimer.h
===================================================================
--- linux-2.6.orig/include/linux/hrtimer.h
+++ linux-2.6/include/linux/hrtimer.h
@@ -268,6 +268,21 @@ extern ktime_t ktime_get_real(void);
 extern void hrtimer_init(struct hrtimer *timer, clockid_t which_clock,
 			 enum hrtimer_mode mode);
 
+#ifdef CONFIG_DEBUG_OBJECTS_TIMERS
+extern void hrtimer_init_on_stack(struct hrtimer *timer, clockid_t which_clock,
+				  enum hrtimer_mode mode);
+
+extern void destroy_hrtimer_on_stack(struct hrtimer *timer);
+#else
+static inline void hrtimer_init_on_stack(struct hrtimer *timer,
+					 clockid_t which_clock,
+					 enum hrtimer_mode mode)
+{
+	hrtimer_init(timer, which_clock, mode);
+}
+static inline void destroy_hrtimer_on_stack(struct hrtimer *timer) { }
+#endif
+
 /* Basic timer operations: */
 extern int hrtimer_start(struct hrtimer *timer, ktime_t tim,
 			 const enum hrtimer_mode mode);
Index: linux-2.6/kernel/futex.c
===================================================================
--- linux-2.6.orig/kernel/futex.c
+++ linux-2.6/kernel/futex.c
@@ -1266,7 +1266,7 @@ static int futex_wait(u32 __user *uaddr,
 		if (!abs_time)
 			schedule();
 		else {
-			hrtimer_init(&t.timer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
+			hrtimer_init_on_stack(&t.timer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
 			hrtimer_init_sleeper(&t, current);
 			t.timer.expires = *abs_time;
 
@@ -1286,6 +1286,8 @@ static int futex_wait(u32 __user *uaddr,
 
 			/* Flag if a timeout occured */
 			rem = (t.task == NULL);
+
+			destroy_hrtimer_on_stack(&t.timer);
 		}
 	}
 	__set_current_state(TASK_RUNNING);
@@ -1367,7 +1369,8 @@ static int futex_lock_pi(u32 __user *uad
 
 	if (time) {
 		to = &timeout;
-		hrtimer_init(&to->timer, CLOCK_REALTIME, HRTIMER_MODE_ABS);
+		hrtimer_init_on_stack(&to->timer, CLOCK_REALTIME,
+				      HRTIMER_MODE_ABS);
 		hrtimer_init_sleeper(to, current);
 		to->timer.expires = *time;
 	}
@@ -1581,6 +1584,8 @@ static int futex_lock_pi(u32 __user *uad
 	unqueue_me_pi(&q);
 	futex_unlock_mm(fshared);
 
+	if (to)
+		destroy_hrtimer_on_stack(&to->timer);
 	return ret != -EINTR ? ret : -ERESTARTNOINTR;
 
  out_unlock_release_sem:
@@ -1588,6 +1593,8 @@ static int futex_lock_pi(u32 __user *uad
 
  out_release_sem:
 	futex_unlock_mm(fshared);
+	if (to)
+		destroy_hrtimer_on_stack(&to->timer);
 	return ret;
 
  uaddr_faulted:
@@ -1615,6 +1622,8 @@ static int futex_lock_pi(u32 __user *uad
 	if (!ret && (uval != -EFAULT))
 		goto retry;
 
+	if (to)
+		destroy_hrtimer_on_stack(&to->timer);
 	return ret;
 }
 
Index: linux-2.6/kernel/hrtimer.c
===================================================================
--- linux-2.6.orig/kernel/hrtimer.c
+++ linux-2.6/kernel/hrtimer.c
@@ -43,6 +43,7 @@
 #include <linux/tick.h>
 #include <linux/seq_file.h>
 #include <linux/err.h>
+#include <linux/debugobjects.h>
 
 #include <asm/uaccess.h>
 
@@ -342,6 +343,115 @@ ktime_t ktime_add_safe(const ktime_t lhs
 	return res;
 }
 
+#ifdef CONFIG_DEBUG_OBJECTS_TIMERS
+
+static struct debug_obj_descr hrtimer_debug_descr;
+
+/*
+ * fixup_init is called when:
+ * - an active object is initialized
+ */
+static int hrtimer_fixup_init(void *addr, enum debug_obj_state state)
+{
+	struct hrtimer *timer = addr;
+
+	switch (state) {
+	case ODEBUG_STATE_ACTIVE:
+		hrtimer_cancel(timer);
+		debug_object_init(timer, &hrtimer_debug_descr);
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
+static int hrtimer_fixup_activate(void *addr, enum debug_obj_state state)
+{
+	switch (state) {
+
+	case ODEBUG_STATE_NOTAVAILABLE:
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
+static int hrtimer_fixup_free(void *addr, enum debug_obj_state state)
+{
+	struct hrtimer *timer = addr;
+
+	switch (state) {
+	case ODEBUG_STATE_ACTIVE:
+		hrtimer_cancel(timer);
+		debug_object_free(timer, &hrtimer_debug_descr);
+		return 1;
+	default:
+		return 0;
+	}
+}
+
+static struct debug_obj_descr hrtimer_debug_descr = {
+	.name		= "hrtimer",
+	.fixup_init	= hrtimer_fixup_init,
+	.fixup_activate	= hrtimer_fixup_activate,
+	.fixup_free	= hrtimer_fixup_free,
+};
+
+static inline void debug_hrtimer_init(struct hrtimer *timer)
+{
+	debug_object_init(timer, &hrtimer_debug_descr);
+}
+
+static inline void debug_hrtimer_activate(struct hrtimer *timer)
+{
+	debug_object_activate(timer, &hrtimer_debug_descr);
+}
+
+static inline void debug_hrtimer_deactivate(struct hrtimer *timer)
+{
+	debug_object_deactivate(timer, &hrtimer_debug_descr);
+}
+
+static inline void debug_hrtimer_free(struct hrtimer *timer)
+{
+	debug_object_free(timer, &hrtimer_debug_descr);
+}
+
+static void __hrtimer_init(struct hrtimer *timer, clockid_t clock_id,
+			   enum hrtimer_mode mode);
+
+void hrtimer_init_on_stack(struct hrtimer *timer, clockid_t clock_id,
+			   enum hrtimer_mode mode)
+{
+	debug_object_init_on_stack(timer, &hrtimer_debug_descr);
+	__hrtimer_init(timer, clock_id, mode);
+}
+
+void destroy_hrtimer_on_stack(struct hrtimer *timer)
+{
+	debug_object_free(timer, &hrtimer_debug_descr);
+}
+
+#else
+static inline void debug_hrtimer_init(struct hrtimer *timer) { }
+static inline void debug_hrtimer_activate(struct hrtimer *timer) { }
+static inline void debug_hrtimer_deactivate(struct hrtimer *timer) { }
+#endif
+
 /*
  * Check, whether the timer is on the callback pending list
  */
@@ -567,6 +677,7 @@ static inline int hrtimer_enqueue_reprog
 		/* Timer is expired, act upon the callback mode */
 		switch(timer->cb_mode) {
 		case HRTIMER_CB_IRQSAFE_NO_RESTART:
+			debug_hrtimer_deactivate(timer);
 			/*
 			 * We can call the callback from here. No restart
 			 * happens, so no danger of recursion
@@ -581,6 +692,7 @@ static inline int hrtimer_enqueue_reprog
 			 * the tick timer in the softirq ! The calling site
 			 * takes care of this.
 			 */
+			debug_hrtimer_deactivate(timer);
 			return 1;
 		case HRTIMER_CB_IRQSAFE:
 		case HRTIMER_CB_SOFTIRQ:
@@ -730,6 +842,8 @@ static void enqueue_hrtimer(struct hrtim
 	struct hrtimer *entry;
 	int leftmost = 1;
 
+	debug_hrtimer_activate(timer);
+
 	/*
 	 * Find the right place in the rbtree:
 	 */
@@ -826,6 +940,7 @@ remove_hrtimer(struct hrtimer *timer, st
 		 * reprogramming happens in the interrupt handler. This is a
 		 * rare case and less expensive than a smp call.
 		 */
+		debug_hrtimer_deactivate(timer);
 		timer_stats_hrtimer_clear_start_info(timer);
 		reprogram = base->cpu_base == &__get_cpu_var(hrtimer_bases);
 		__remove_hrtimer(timer, base, HRTIMER_STATE_INACTIVE,
@@ -873,6 +988,7 @@ hrtimer_start(struct hrtimer *timer, kti
 		tim = ktime_add_safe(tim, base->resolution);
 #endif
 	}
+
 	timer->expires = tim;
 
 	timer_stats_hrtimer_set_start_info(timer);
@@ -996,14 +1112,8 @@ ktime_t hrtimer_get_next_event(void)
 }
 #endif
 
-/**
- * hrtimer_init - initialize a timer to the given clock
- * @timer:	the timer to be initialized
- * @clock_id:	the clock to be used
- * @mode:	timer mode abs/rel
- */
-void hrtimer_init(struct hrtimer *timer, clockid_t clock_id,
-		  enum hrtimer_mode mode)
+static void __hrtimer_init(struct hrtimer *timer, clockid_t clock_id,
+			   enum hrtimer_mode mode)
 {
 	struct hrtimer_cpu_base *cpu_base;
 
@@ -1024,6 +1134,19 @@ void hrtimer_init(struct hrtimer *timer,
 	memset(timer->start_comm, 0, TASK_COMM_LEN);
 #endif
 }
+
+/**
+ * hrtimer_init - initialize a timer to the given clock
+ * @timer:	the timer to be initialized
+ * @clock_id:	the clock to be used
+ * @mode:	timer mode abs/rel
+ */
+void hrtimer_init(struct hrtimer *timer, clockid_t clock_id,
+		  enum hrtimer_mode mode)
+{
+	debug_hrtimer_init(timer);
+	__hrtimer_init(timer, clock_id, mode);
+}
 EXPORT_SYMBOL_GPL(hrtimer_init);
 
 /**
@@ -1057,6 +1180,7 @@ static void run_hrtimer_pending(struct h
 		timer = list_entry(cpu_base->cb_pending.next,
 				   struct hrtimer, cb_entry);
 
+		debug_hrtimer_deactivate(timer);
 		timer_stats_account_hrtimer(timer);
 
 		fn = timer->function;
@@ -1094,6 +1218,7 @@ static void __run_hrtimer(struct hrtimer
 	enum hrtimer_restart (*fn)(struct hrtimer *);
 	int restart;
 
+	debug_hrtimer_deactivate(timer);
 	__remove_hrtimer(timer, base, HRTIMER_STATE_CALLBACK, 0);
 	timer_stats_account_hrtimer(timer);
 
@@ -1353,22 +1478,26 @@ long __sched hrtimer_nanosleep_restart(s
 {
 	struct hrtimer_sleeper t;
 	struct timespec __user  *rmtp;
+	int ret = 0;
 
-	hrtimer_init(&t.timer, restart->arg0, HRTIMER_MODE_ABS);
+	hrtimer_init_on_stack(&t.timer, restart->arg0, HRTIMER_MODE_ABS);
 	t.timer.expires.tv64 = ((u64)restart->arg3 << 32) | (u64) restart->arg2;
 
 	if (do_nanosleep(&t, HRTIMER_MODE_ABS))
-		return 0;
+		goto out;
 
 	rmtp = (struct timespec __user *)restart->arg1;
 	if (rmtp) {
-		int ret = update_rmtp(&t.timer, rmtp);
+		ret = update_rmtp(&t.timer, rmtp);
 		if (ret <= 0)
-			return ret;
+			goto out;
 	}
 
 	/* The other values in restart are already filled in */
-	return -ERESTART_RESTARTBLOCK;
+	ret = -ERESTART_RESTARTBLOCK;
+out:
+	destroy_hrtimer_on_stack(&t.timer);
+	return ret;
 }
 
 long hrtimer_nanosleep(struct timespec *rqtp, struct timespec __user *rmtp,
@@ -1376,20 +1505,23 @@ long hrtimer_nanosleep(struct timespec *
 {
 	struct restart_block *restart;
 	struct hrtimer_sleeper t;
+	int ret = 0;
 
-	hrtimer_init(&t.timer, clockid, mode);
+	hrtimer_init_on_stack(&t.timer, clockid, mode);
 	t.timer.expires = timespec_to_ktime(*rqtp);
 	if (do_nanosleep(&t, mode))
-		return 0;
+		goto out;
 
 	/* Absolute timers do not update the rmtp value and restart: */
-	if (mode == HRTIMER_MODE_ABS)
-		return -ERESTARTNOHAND;
+	if (mode == HRTIMER_MODE_ABS) {
+		ret = -ERESTARTNOHAND;
+		goto out;
+	}
 
 	if (rmtp) {
-		int ret = update_rmtp(&t.timer, rmtp);
+		ret = update_rmtp(&t.timer, rmtp);
 		if (ret <= 0)
-			return ret;
+			goto out;
 	}
 
 	restart = &current_thread_info()->restart_block;
@@ -1399,7 +1531,10 @@ long hrtimer_nanosleep(struct timespec *
 	restart->arg2 = t.timer.expires.tv64 & 0xFFFFFFFF;
 	restart->arg3 = t.timer.expires.tv64 >> 32;
 
-	return -ERESTART_RESTARTBLOCK;
+	ret = -ERESTART_RESTARTBLOCK;
+out:
+	destroy_hrtimer_on_stack(&t.timer);
+	return ret;
 }
 
 asmlinkage long
@@ -1445,6 +1580,7 @@ static void migrate_hrtimer_list(struct 
 	while ((node = rb_first(&old_base->active))) {
 		timer = rb_entry(node, struct hrtimer, node);
 		BUG_ON(hrtimer_callback_running(timer));
+		debug_hrtimer_deactivate(timer);
 		__remove_hrtimer(timer, old_base, HRTIMER_STATE_INACTIVE, 0);
 		timer->base = new_base;
 		/*

-- 

