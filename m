Return-Path: <linux-kernel-owner+w=401wt.eu-S1752075AbZDFQPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075AbZDFQPN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 12:15:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758850AbZDFQOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 12:14:33 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:44071 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758583AbZDFQOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 12:14:31 -0400
Date: Mon, 6 Apr 2009 21:43:57 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: a.p.zijlstra@chello.nl, ego@in.ibm.com, tglx@linutronix.de, mingo@elte.hu,
       andi@firstfloor.org, venkatesh.pallipadi@intel.com,
       vatsa@linux.vnet.ibm.com, arjan@infradead.org, vaidy@linux.vnet.ibm.com,
       arun@linux.vnet.ibm.com
Subject: [v5 PATCH 1/4] timers: Framework for identifying pinned timers
Message-ID: <20090406161357.GB15269@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch creates a new framework for identifying cpu-pinned timers
and hrtimers.


This framework is needed because pinned timers are expected to fire on
the same CPU on which they are queued. So it is essential to identify
these and not migrate them, in case there are any.

For regular timers, the currently existing add_timer_on() can be used
queue pinned timers and subsequently mod_timer_pinned() can be used
to modify the 'expires' field.

For hrtimers, a new interface hrtimer_start_pinned() is created,
which can be used to queue cpu-pinned hrtimer.


Signed-off-by: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
---
 include/linux/hrtimer.h |   24 ++++++++++++++++++++----
 include/linux/timer.h   |    3 +++
 kernel/hrtimer.c        |   34 ++++++++++++++++++++++++++++------
 kernel/timer.c          |   31 +++++++++++++++++++++++++++----
 4 files changed, 78 insertions(+), 14 deletions(-)

Index: linux.trees.git/include/linux/hrtimer.h
===================================================================
--- linux.trees.git.orig/include/linux/hrtimer.h
+++ linux.trees.git/include/linux/hrtimer.h
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
Index: linux.trees.git/kernel/hrtimer.c
===================================================================
--- linux.trees.git.orig/kernel/hrtimer.c
+++ linux.trees.git/kernel/hrtimer.c
@@ -193,7 +193,8 @@ struct hrtimer_clock_base *lock_hrtimer_
  * Switch the timer base to the current CPU when possible.
  */
 static inline struct hrtimer_clock_base *
-switch_hrtimer_base(struct hrtimer *timer, struct hrtimer_clock_base *base)
+switch_hrtimer_base(struct hrtimer *timer, struct hrtimer_clock_base *base,
+	int pinned)
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
+	const enum hrtimer_mode mode, int pinned)
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
Index: linux.trees.git/include/linux/timer.h
===================================================================
--- linux.trees.git.orig/include/linux/timer.h
+++ linux.trees.git/include/linux/timer.h
@@ -163,7 +163,10 @@ extern void add_timer_on(struct timer_li
 extern int del_timer(struct timer_list * timer);
 extern int mod_timer(struct timer_list *timer, unsigned long expires);
 extern int mod_timer_pending(struct timer_list *timer, unsigned long expires);
+extern int mod_timer_pinned(struct timer_list *timer, unsigned long expires);
 
+#define TIMER_NOT_PINNED	0
+#define TIMER_PINNED		1
 /*
  * The jiffies value which is added to now, when there is no timer
  * in the timer wheel:
Index: linux.trees.git/kernel/timer.c
===================================================================
--- linux.trees.git.orig/kernel/timer.c
+++ linux.trees.git/kernel/timer.c
@@ -601,7 +601,8 @@ static struct tvec_base *lock_timer_base
 }
 
 static inline int
-__mod_timer(struct timer_list *timer, unsigned long expires, bool pending_only)
+__mod_timer(struct timer_list *timer, unsigned long expires,
+						bool pending_only, int pinned)
 {
 	struct tvec_base *base, *new_base;
 	unsigned long flags;
@@ -665,7 +666,7 @@ out_unlock:
  */
 int mod_timer_pending(struct timer_list *timer, unsigned long expires)
 {
-	return __mod_timer(timer, expires, true);
+	return __mod_timer(timer, expires, true, TIMER_NOT_PINNED);
 }
 EXPORT_SYMBOL(mod_timer_pending);
 
@@ -699,11 +700,33 @@ int mod_timer(struct timer_list *timer, 
 	if (timer->expires == expires && timer_pending(timer))
 		return 1;
 
-	return __mod_timer(timer, expires, false);
+	return __mod_timer(timer, expires, false, TIMER_NOT_PINNED);
 }
 EXPORT_SYMBOL(mod_timer);
 
 /**
+ * mod_timer_pinned - modify a timer's timeout
+ * @timer: the timer to be modified
+ * @expires: new timeout in jiffies
+ *
+ * mod_timer_pinned() is a way to update the expire field of an
+ * active timer (if the timer is inactive it will be activated)
+ * and not allow the timer to be migrated to a different CPU.
+ *
+ * mod_timer_pinned(timer, expires) is equivalent to:
+ *
+ *     del_timer(timer); timer->expires = expires; add_timer(timer);
+ */
+int mod_timer_pinned(struct timer_list *timer, unsigned long expires)
+{
+	if (timer->expires == expires && timer_pending(timer))
+		return 1;
+
+	return __mod_timer(timer, expires, false, TIMER_PINNED);
+}
+EXPORT_SYMBOL(mod_timer_pinned);
+
+/**
  * add_timer - start a timer
  * @timer: the timer to be added
  *
@@ -1350,7 +1373,7 @@ signed long __sched schedule_timeout(sig
 	expire = timeout + jiffies;
 
 	setup_timer_on_stack(&timer, process_timeout, (unsigned long)current);
-	__mod_timer(&timer, expire, false);
+	__mod_timer(&timer, expire, false, TIMER_NOT_PINNED);
 	schedule();
 	del_singleshot_timer_sync(&timer);
 

