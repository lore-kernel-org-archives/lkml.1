Return-Path: <linux-kernel-owner+w=401wt.eu-S1757160AbZBTM5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757160AbZBTM5w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 07:57:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752807AbZBTM5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 07:57:43 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:32870 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700AbZBTM5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 07:57:42 -0500
Date: Fri, 20 Feb 2009 18:27:25 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       a.p.zijlstra@chello.nl, ego@in.ibm.com, tglx@linutronix.de,
       mingo@elte.hu, andi@firstfloor.org, venkatesh.pallipadi@intel.com,
       vatsa@linux.vnet.ibm.com, arjan@infradead.org
Subject: [RFC PATCH 1/4] timers: framework to identify pinned timers.
Message-ID: <20090220125725.GA19762@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
Mail-Followup-To: linux-kernel@vger.kernel.org,
	linux-pm@lists.linux-foundation.org, a.p.zijlstra@chello.nl,
	ego@in.ibm.com, tglx@linutronix.de, mingo@elte.hu,
	andi@firstfloor.org, venkatesh.pallipadi@intel.com,
	vatsa@linux.vnet.ibm.com, arjan@infradead.org
References: <20090220125516.GB10232@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090220125516.GB10232@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arun R Bharadwaj <arun@linux.vnet.ibm.com> [2009-02-20 18:25:16]:

This patch creates a new framework for identifying cpu-pinned timers
and hrtimers.


This framework is needed because pinned timers are expected to fire on
the same CPU on which they are queued. So it is essential to identify
these and not migrate them, in case there are any.


For regular timers a new flag called TBASE_PINNED_FLAG is created.
Since the last 3 bits of the tvec_base is guaranteed to be 0, and
since the last bit is being used to indicate deferrable timers,
the second last bit is used to indicate cpu-pinned regular timers.
The implementation of functions to manage the TBASE_PINNED_FLAG is
similar to those which manage the TBASE_DEFERRABLE_FLAG.


For hrtimers, a new interface hrtimer_start_pinned() is created,
which can be used to queue cpu-pinned hrtimer.



Signed-off-by: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
---
 include/linux/hrtimer.h |   24 ++++++++++++++++++++----
 kernel/hrtimer.c        |   34 ++++++++++++++++++++++++++++------
 kernel/timer.c          |   30 +++++++++++++++++++++++++++---
 3 files changed, 75 insertions(+), 13 deletions(-)

Index: git-2.6/kernel/timer.c
===================================================================
--- git-2.6.orig/kernel/timer.c
+++ git-2.6/kernel/timer.c
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
+#define TBASE_PINNED_FLAG		(0x2)
 
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
 
 static unsigned long round_jiffies_common(unsigned long j, int cpu,
@@ -648,6 +671,7 @@ void add_timer_on(struct timer_list *tim
 	struct tvec_base *base = per_cpu(tvec_bases, cpu);
 	unsigned long flags;
 
+	timer_set_pinned(timer);
 	timer_stats_timer_set_start_info(timer);
 	BUG_ON(timer_pending(timer) || !timer->function);
 	spin_lock_irqsave(&base->lock, flags);
Index: git-2.6/include/linux/hrtimer.h
===================================================================
--- git-2.6.orig/include/linux/hrtimer.h
+++ git-2.6/include/linux/hrtimer.h
@@ -331,23 +331,39 @@ static inline void hrtimer_init_on_stack
 static inline void destroy_hrtimer_on_stack(struct hrtimer *timer) { }
 #endif
 
+#define HRTIMER_NOT_PINNED	0
+#define HRTIMER_PINNED		1
 /* Basic timer operations: */
 extern int hrtimer_start(struct hrtimer *timer, ktime_t tim,
 			 const enum hrtimer_mode mode);
+extern int hrtimer_start_pinned(struct hrtimer *timer, ktime_t tim,
+			const enum hrtimer_mode mode);
 extern int hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
-			unsigned long range_ns, const enum hrtimer_mode mode);
+	unsigned long range_ns, const enum hrtimer_mode mode, int pinned);
 extern int hrtimer_cancel(struct hrtimer *timer);
 extern int hrtimer_try_to_cancel(struct hrtimer *timer);
 
-static inline int hrtimer_start_expires(struct hrtimer *timer,
-						enum hrtimer_mode mode)
+static inline int __hrtimer_start_expires(struct hrtimer *timer,
+					enum hrtimer_mode mode, int pinned)
 {
 	unsigned long delta;
 	ktime_t soft, hard;
 	soft = hrtimer_get_softexpires(timer);
 	hard = hrtimer_get_expires(timer);
 	delta = ktime_to_ns(ktime_sub(hard, soft));
-	return hrtimer_start_range_ns(timer, soft, delta, mode);
+	return hrtimer_start_range_ns(timer, soft, delta, mode, pinned);
+}
+
+static inline int hrtimer_start_expires(struct hrtimer *timer,
+						enum hrtimer_mode mode)
+{
+	return __hrtimer_start_expires(timer, mode, HRTIMER_NOT_PINNED);
+}
+
+static inline int hrtimer_start_expires_pinned(struct hrtimer *timer,
+						enum hrtimer_mode mode)
+{
+	return __hrtimer_start_expires(timer, mode, HRTIMER_PINNED);
 }
 
 static inline int hrtimer_restart(struct hrtimer *timer)
Index: git-2.6/kernel/hrtimer.c
===================================================================
--- git-2.6.orig/kernel/hrtimer.c
+++ git-2.6/kernel/hrtimer.c
@@ -193,7 +193,8 @@ struct hrtimer_clock_base *lock_hrtimer_
  * Switch the timer base to the current CPU when possible.
  */
 static inline struct hrtimer_clock_base *
-switch_hrtimer_base(struct hrtimer *timer, struct hrtimer_clock_base *base)
+switch_hrtimer_base(struct hrtimer *timer, struct hrtimer_clock_base *base,
+int pinned)
 {
 	struct hrtimer_clock_base *new_base;
 	struct hrtimer_cpu_base *new_cpu_base;
@@ -897,9 +898,8 @@ remove_hrtimer(struct hrtimer *timer, st
  *  0 on success
  *  1 when the timer was active
  */
-int
-hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim, unsigned long delta_ns,
-			const enum hrtimer_mode mode)
+int hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
+	unsigned long delta_ns, const enum hrtimer_mode mode, int pinned)
 {
 	struct hrtimer_clock_base *base, *new_base;
 	unsigned long flags;
@@ -911,7 +911,7 @@ hrtimer_start_range_ns(struct hrtimer *t
 	ret = remove_hrtimer(timer, base);
 
 	/* Switch the timer base, if necessary: */
-	new_base = switch_hrtimer_base(timer, base);
+	new_base = switch_hrtimer_base(timer, base, pinned);
 
 	if (mode == HRTIMER_MODE_REL) {
 		tim = ktime_add_safe(tim, new_base->get_time());
@@ -948,6 +948,12 @@ hrtimer_start_range_ns(struct hrtimer *t
 }
 EXPORT_SYMBOL_GPL(hrtimer_start_range_ns);
 
+int __hrtimer_start(struct hrtimer *timer, ktime_t tim,
+const enum hrtimer_mode mode, int pinned)
+{
+	return hrtimer_start_range_ns(timer, tim, 0, mode, pinned);
+}
+
 /**
  * hrtimer_start - (re)start an hrtimer on the current CPU
  * @timer:	the timer to be added
@@ -961,10 +967,26 @@ EXPORT_SYMBOL_GPL(hrtimer_start_range_ns
 int
 hrtimer_start(struct hrtimer *timer, ktime_t tim, const enum hrtimer_mode mode)
 {
-	return hrtimer_start_range_ns(timer, tim, 0, mode);
+	return __hrtimer_start(timer, tim, mode, HRTIMER_NOT_PINNED);
 }
 EXPORT_SYMBOL_GPL(hrtimer_start);
 
+/**
+ * hrtimer_start_pinned - start a CPU-pinned hrtimer
+ * @timer:      the timer to be added
+ * @tim:        expiry time
+ * @mode:       expiry mode: absolute (HRTIMER_ABS) or relative (HRTIMER_REL)
+ *
+ * Returns:
+ *  0 on success
+ *  1 when the timer was active
+ */
+int hrtimer_start_pinned(struct hrtimer *timer,
+	ktime_t tim, const enum hrtimer_mode mode)
+{
+	return __hrtimer_start(timer, tim, mode, HRTIMER_PINNED);
+}
+EXPORT_SYMBOL_GPL(hrtimer_start_pinned);
 
 /**
  * hrtimer_try_to_cancel - try to deactivate a timer
