Return-Path: <linux-kernel-owner+w=401wt.eu-S1756520AbYJPLsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756520AbYJPLsr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 07:48:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754191AbYJPLsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 07:48:39 -0400
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:48741 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754013AbYJPLsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 07:48:38 -0400
Date: Thu, 16 Oct 2008 17:18:30 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: a.p.zijlstra@chello.nl, ego@in.ibm.com, tglx@linutronix.de, mingo@elte.hu,
       andi@firstfloor.org, venkatesh.pallipadi@intel.com,
       vatsa@linux.vnet.ibm.com, arjan@infradead.org, arun@linux.vnet.ibm.com
Subject: [RFC PATCH 2/4] timers: new framework for identifying cpu-pinned
	timers
Message-ID: <20081016114830.GC7641@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
Mail-Followup-To: linux-kernel@vger.kernel.org,
	linux-pm@lists.linux-foundation.org, a.p.zijlstra@chello.nl,
	ego@in.ibm.com, tglx@linutronix.de, mingo@elte.hu,
	andi@firstfloor.org, venkatesh.pallipadi@intel.com,
	vatsa@linux.vnet.ibm.com, arjan@infradead.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch creates the necessary framework for identifying cpu-pinned
regular timers and hrtimers.

For regular timers a new flag called TBASE_PINNED_FLAG is created.
Since the last 3 bits of the tvec_base is guaranteed to be 0, and
since the last bit is being used to indicate deferrable timers, I'm
using the second last bit to indicate cpu-pinned regular timers.
The implementation of functions to manage the TBASE_PINNED_FLAG is
similar to those which manage the TBASE_DEFERRABLE_FLAG.

For hrtimers, there is no clear interface to queue a hrtimer as a
per-cpu hrtimer. But there are instances where, if an hrtimer is queued
on a particular cpu, it expects to run on the same cpu.
The hrtimer hrtick_timer is one such example.

So, in this regard, I've created a new interface called
hrtimer_start_pinned which can be used to queue cpu-pinned hrtimer.
In the hrtimer structure, there is a variable called *state* which
is used to indicate the state of a hrtimer - inactive, enqueued,
callback function running and callback pending. Currently, since only
5 bits are being used in the state variable, I've used the 6th bit
to represent the cpu-pinned state of the hrtimer


Signed-off-by: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
---
 include/linux/hrtimer.h |   17 ++++++++++++++---
 kernel/hrtimer.c        |   31 ++++++++++++++++++++++++++-----
 kernel/timer.c          |   30 +++++++++++++++++++++++++++---
 3 files changed, 67 insertions(+), 11 deletions(-)

Index: linux-2.6.27/kernel/timer.c
===================================================================
--- linux-2.6.27.orig/kernel/timer.c
+++ linux-2.6.27/kernel/timer.c
@@ -37,6 +37,7 @@
 #include <linux/delay.h>
 #include <linux/tick.h>
 #include <linux/kallsyms.h>
+#include <linux/timer.h>
 
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
@@ -87,8 +88,12 @@ static DEFINE_PER_CPU(struct tvec_base *
  * the new flag to indicate whether the timer is deferrable
  */
 #define TBASE_DEFERRABLE_FLAG		(0x1)
+#define TBASE_PINNED_FLAG               (0x2)
 
-/* Functions below help us manage 'deferrable' flag */
+/*
+ * Functions below help us manage
+ * 'deferrable' flag and 'cpu-pinned-timer' flag
+ */
 static inline unsigned int tbase_get_deferrable(struct tvec_base *base)
 {
 	return ((unsigned int)(unsigned long)base & TBASE_DEFERRABLE_FLAG);
@@ -96,7 +101,8 @@ static inline unsigned int tbase_get_def
 
 static inline struct tvec_base *tbase_get_base(struct tvec_base *base)
 {
-	return ((struct tvec_base *)((unsigned long)base & ~TBASE_DEFERRABLE_FLAG));
+	return (struct tvec_base *)((unsigned long)base &
+			~(TBASE_DEFERRABLE_FLAG | TBASE_PINNED_FLAG));
 }
 
 static inline void timer_set_deferrable(struct timer_list *timer)
@@ -105,11 +111,28 @@ static inline void timer_set_deferrable(
 				       TBASE_DEFERRABLE_FLAG));
 }
 
+static inline unsigned long tbase_get_pinned(struct tvec_base *base)
+{
+	return (unsigned long)base & TBASE_PINNED_FLAG;
+}
+
+static inline unsigned long tbase_get_flag_bits(struct timer_list *timer)
+{
+	return tbase_get_deferrable(timer->base) |
+				tbase_get_pinned(timer->base);
+}
+
 static inline void
 timer_set_base(struct timer_list *timer, struct tvec_base *new_base)
 {
 	timer->base = (struct tvec_base *)((unsigned long)(new_base) |
-				      tbase_get_deferrable(timer->base));
+					tbase_get_flag_bits(timer));
+}
+
+static inline void timer_set_pinned(struct timer_list *timer)
+{
+	timer->base = ((struct tvec_base *)((unsigned long)(timer->base) |
+				TBASE_PINNED_FLAG));
 }
 
 /**
@@ -579,6 +602,7 @@ void add_timer_on(struct timer_list *tim
 	struct tvec_base *base = per_cpu(tvec_bases, cpu);
 	unsigned long flags;
 
+	timer_set_pinned(timer);
 	timer_stats_timer_set_start_info(timer);
 	BUG_ON(timer_pending(timer) || !timer->function);
 	spin_lock_irqsave(&base->lock, flags);
Index: linux-2.6.27/kernel/hrtimer.c
===================================================================
--- linux-2.6.27.orig/kernel/hrtimer.c
+++ linux-2.6.27/kernel/hrtimer.c
@@ -191,6 +191,14 @@ struct hrtimer_clock_base *lock_hrtimer_
 }
 
 /*
+ * Function to check whether the timer is pinned to cpu or not.
+ */
+static inline int is_hrtimer_pinned(struct hrtimer *timer)
+{
+	return timer->state & HRTIMER_CPU_PINNED;
+}
+
+/*
  * Switch the timer base to the current CPU when possible.
  */
 static inline struct hrtimer_clock_base *
@@ -690,7 +698,12 @@ static inline int hrtimer_enqueue_reprog
 			 */
 			list_add_tail(&timer->cb_entry,
 				      &base->cpu_base->cb_pending);
-			timer->state = HRTIMER_STATE_PENDING;
+			/*
+			 * The hrtimer can be in pending state as well as be
+			 * pinned to a cpu.
+			 */
+			timer->state = HRTIMER_STATE_PENDING |
+					is_hrtimer_pinned(timer);
 			return 1;
 		default:
 			BUG();
@@ -999,7 +1012,7 @@ hrtimer_start(struct hrtimer *timer, kti
 	 * list. We can not raise the softirq with base lock held due
 	 * to a possible deadlock with runqueue lock.
 	 */
-	raise = timer->state == HRTIMER_STATE_PENDING;
+	raise = (get_hrtimer_state(timer) == HRTIMER_STATE_PENDING);
 
 	/*
 	 * We use preempt_disable to prevent this task from migrating after
@@ -1018,6 +1031,14 @@ hrtimer_start(struct hrtimer *timer, kti
 }
 EXPORT_SYMBOL_GPL(hrtimer_start);
 
+int hrtimer_start_pinned(struct hrtimer *timer,
+		ktime_t tim, const enum hrtimer_mode mode)
+{
+	timer->state = timer->state | HRTIMER_CPU_PINNED;
+	return hrtimer_start(timer, tim, mode);
+}
+EXPORT_SYMBOL_GPL(hrtimer_start_pinned);
+
 /**
  * hrtimer_try_to_cancel - try to deactivate a timer
  * @timer:	hrtimer to stop
@@ -1267,7 +1288,7 @@ static void __run_hrtimer(struct hrtimer
 	 * function anyway.
 	 */
 	if (restart != HRTIMER_NORESTART) {
-		BUG_ON(timer->state != HRTIMER_STATE_CALLBACK);
+		BUG_ON(get_hrtimer_state(timer)	!= HRTIMER_STATE_CALLBACK);
 		enqueue_hrtimer(timer, base, 0);
 	}
 	timer->state &= ~HRTIMER_STATE_CALLBACK;
@@ -1639,8 +1660,8 @@ static int migrate_hrtimer_list(struct h
 		 * in the migration state, we need to do that
 		 * otherwise we end up with a stale timer.
 		 */
-		if (timer->state == HRTIMER_STATE_MIGRATE) {
-			timer->state = HRTIMER_STATE_PENDING;
+		if (get_hrtimer_state(timer) == HRTIMER_STATE_MIGRATE) {
+			timer->state |= HRTIMER_STATE_PENDING;
 			list_add_tail(&timer->cb_entry,
 				      &new_base->cpu_base->cb_pending);
 			raise = 1;
Index: linux-2.6.27/include/linux/hrtimer.h
===================================================================
--- linux-2.6.27.orig/include/linux/hrtimer.h
+++ linux-2.6.27/include/linux/hrtimer.h
@@ -74,7 +74,6 @@ enum hrtimer_cb_mode {
  * 0x01		enqueued into rbtree
  * 0x02		callback function running
  * 0x04		callback pending (high resolution mode)
- *
  * Special cases:
  * 0x03		callback function running and enqueued
  *		(was requeued on another CPU)
@@ -97,6 +96,7 @@ enum hrtimer_cb_mode {
 #define HRTIMER_STATE_CALLBACK	0x02
 #define HRTIMER_STATE_PENDING	0x04
 #define HRTIMER_STATE_MIGRATE	0x08
+#define HRTIMER_CPU_PINNED	0X16
 
 /**
  * struct hrtimer - the basic hrtimer structure
@@ -294,6 +294,8 @@ static inline void destroy_hrtimer_on_st
 /* Basic timer operations: */
 extern int hrtimer_start(struct hrtimer *timer, ktime_t tim,
 			 const enum hrtimer_mode mode);
+extern int hrtimer_start_pinned(struct hrtimer *timer, ktime_t tim,
+			const enum hrtimer_mode mode);
 extern int hrtimer_cancel(struct hrtimer *timer);
 extern int hrtimer_try_to_cancel(struct hrtimer *timer);
 
@@ -309,12 +311,21 @@ extern int hrtimer_get_res(const clockid
 extern ktime_t hrtimer_get_next_event(void);
 
 /*
+ * Helper function which masks the HRTIMER_CPU_PINNED flag and returns
+ * the state value without the overload.
+ */
+static inline long get_hrtimer_state(struct hrtimer *hrtimer)
+{
+	return hrtimer->state & ~HRTIMER_CPU_PINNED;
+}
+
+/*
  * A timer is active, when it is enqueued into the rbtree or the callback
  * function is running.
  */
-static inline int hrtimer_active(const struct hrtimer *timer)
+static inline int hrtimer_active(struct hrtimer *timer)
 {
-	return timer->state != HRTIMER_STATE_INACTIVE;
+	return get_hrtimer_state(timer)	!= HRTIMER_STATE_INACTIVE;
 }
 
 /*
