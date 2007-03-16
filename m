Return-Path: <linux-kernel-owner+w=401wt.eu-S965978AbXCPWHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965978AbXCPWHs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 18:07:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965985AbXCPWHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 18:07:48 -0400
Received: from mga03.intel.com ([143.182.124.21]:16746 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965978AbXCPWHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 18:07:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,293,1170662400"; 
   d="scan'208"; a="197837429:sNHT19716802"
Date: Fri, 16 Mar 2007 15:07:35 -0700
From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
To: Andrew Morton <akpm@osdl.org>, Dave Jones <davej@redhat.com>,
       tglx@linutronix.de
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] Add not_critical_when_idle timer
Message-ID: <20070316220734.GA6109@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Introduce a new kind of timers - not_critical_when_idle timers:
Timers that work normally when system is busy. But, will not cause CPU to
come out of idle (just to service this timer), when CPU is idle. Instead,
this timer will be serviced when CPU eventually wakes up with a subsequent
critical_when_idle timer.

The main advantage of this is to avoid unnecessary timer interrupts when
CPU is idle. If the routine currently called by a timer can wait until next
event without any issues, this new timer can be used to setup timer event
for that routine. This, with dynticks, allows CPUs to be lazy, allowing them
to stay in idle for extended period of time by reducing unnecesary wakeup and
thereby reducing the power consumption.

This patch:
Builds this new timer on top of existing timer infrastructure. It uses
last bit in 'base' pointer of timer_list structure to store this
extra information about timer. __next_timer_interrupt() function
skips over these not_critical_when_idle timers when CPU looks for
next timer event for which it has to wake up.

This is exported by a new interface add_timer_with_hint() and also a new
parameter is added to existing add_timer_on() interface.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

Index: linux-2.6.20/kernel/timer.c
===================================================================
--- linux-2.6.20.orig/kernel/timer.c	2007-03-16 14:13:19.000000000 -0700
+++ linux-2.6.20/kernel/timer.c	2007-03-16 14:51:15.000000000 -0700
@@ -74,7 +74,7 @@
 	tvec_t tv3;
 	tvec_t tv4;
 	tvec_t tv5;
-} ____cacheline_aligned_in_smp;
+} ____cacheline_aligned;
 
 typedef struct tvec_t_base_s tvec_base_t;
 
@@ -325,7 +325,7 @@
 	tvec_base_t *base;
 
 	for (;;) {
-		base = timer->base;
+		base = TBASE_GET_BASE_PTR(timer->base);
 		if (likely(base != NULL)) {
 			spin_lock_irqsave(&base->lock, *flags);
 			if (likely(base == timer->base))
@@ -364,12 +364,15 @@
 		 * the timer is serialized wrt itself.
 		 */
 		if (likely(base->running_timer != timer)) {
+			unsigned long tflag;
+			tflag = TBASE_GET_DELAYED_ON_IDLE(timer->base);
 			/* See the comment in lock_timer_base() */
 			timer->base = NULL;
 			spin_unlock(&base->lock);
 			base = new_base;
 			spin_lock(&base->lock);
-			timer->base = base;
+			timer->base =
+				TBASE_MERGE_DELAYED_ON_IDLE(new_base, tflag);
 		}
 	}
 
@@ -386,10 +389,12 @@
  * add_timer_on - start a timer on a particular CPU
  * @timer: the timer to be added
  * @cpu: the CPU to start it on
+ * @not_critical_when_idle: 1 to indicate timer is not critical and
+ *                          can be delayed when CPU is idle
  *
  * This is not very scalable on SMP. Double adds are not possible.
  */
-void add_timer_on(struct timer_list *timer, int cpu)
+void add_timer_on(struct timer_list *timer, int cpu, int not_critical_when_idle)
 {
 	tvec_base_t *base = per_cpu(tvec_bases, cpu);
   	unsigned long flags;
@@ -397,7 +402,7 @@
 	timer_stats_timer_set_start_info(timer);
   	BUG_ON(timer_pending(timer) || !timer->function);
 	spin_lock_irqsave(&base->lock, flags);
-	timer->base = base;
+	timer->base = TBASE_MERGE_DELAYED_ON_IDLE(base, not_critical_when_idle);
 	internal_add_timer(base, timer);
 	spin_unlock_irqrestore(&base->lock, flags);
 }
@@ -548,7 +553,7 @@
 	 * don't have to detach them individually.
 	 */
 	list_for_each_entry_safe(timer, tmp, &tv_list, entry) {
-		BUG_ON(timer->base != base);
+		BUG_ON(TBASE_GET_BASE_PTR(timer->base) != base);
 		internal_add_timer(base, timer);
 	}
 
@@ -634,6 +639,9 @@
 	index = slot = timer_jiffies & TVR_MASK;
 	do {
 		list_for_each_entry(nte, base->tv1.vec + slot, entry) {
+ 			if (TBASE_GET_DELAYED_ON_IDLE(nte->base))
+ 				continue;
+ 
 			found = 1;
 			expires = nte->expires;
 			/* Look at the cascade bucket(s)? */
@@ -1602,6 +1610,13 @@
 						cpu_to_node(cpu));
 			if (!base)
 				return -ENOMEM;
+
+			/* Make sure that tvec_base is 2 byte aligned */
+			if (TBASE_GET_DELAYED_ON_IDLE(base)) {
+				WARN_ON(1);
+				kfree(base);
+				return -ENOMEM;
+			}
 			memset(base, 0, sizeof(*base));
 			per_cpu(tvec_bases, cpu) = base;
 		} else {
@@ -1641,9 +1656,11 @@
 	struct timer_list *timer;
 
 	while (!list_empty(head)) {
+		unsigned long tflag;
 		timer = list_entry(head->next, struct timer_list, entry);
+		tflag = TBASE_GET_DELAYED_ON_IDLE(timer->base);
+		timer->base = TBASE_MERGE_DELAYED_ON_IDLE(new_base, tflag);
 		detach_timer(timer, 0);
-		timer->base = new_base;
 		internal_add_timer(new_base, timer);
 	}
 }
Index: linux-2.6.20/include/linux/timer.h
===================================================================
--- linux-2.6.20.orig/include/linux/timer.h	2007-03-16 14:13:19.000000000 -0700
+++ linux-2.6.20/include/linux/timer.h	2007-03-16 14:47:28.000000000 -0700
@@ -8,6 +8,33 @@
 
 struct tvec_t_base_s;
 
+extern struct tvec_t_base_s boot_tvec_bases;
+/*
+ * Note that all tvec_bases is 2 byte aligned and lower bit of
+ * base in timer_list is guaranteed to be zero. Use the LSB for
+ * the new flag to indicate whether it is OK to skip timer callback
+ * when CPU is idle.
+ */
+#define TBASE_FLAG_DELAYED_ON_IDLE		(0x1)
+
+#define TBASE_GET_BASE_PTR(x)						\
+	((struct tvec_t_base_s *)((unsigned long)x &			\
+	                          (~TBASE_FLAG_DELAYED_ON_IDLE)))
+
+#define TBASE_GET_DELAYED_ON_IDLE(x)					\
+	((unsigned long)x & TBASE_FLAG_DELAYED_ON_IDLE)
+
+#define TBASE_SET_DELAYED_ON_IDLE(x)					\
+	((struct tvec_t_base_s *)((unsigned long)x |			\
+	                          TBASE_FLAG_DELAYED_ON_IDLE))
+
+#define TBASE_CLEAR_DELAYED_ON_IDLE(x)					\
+	((struct tvec_t_base_s *)((unsigned long)x &			\
+	                          (~TBASE_FLAG_DELAYED_ON_IDLE)))
+
+#define TBASE_MERGE_DELAYED_ON_IDLE(x,f)				\
+	((f) ? TBASE_SET_DELAYED_ON_IDLE(x) : TBASE_CLEAR_DELAYED_ON_IDLE(x))
+
 struct timer_list {
 	struct list_head entry;
 	unsigned long expires;
@@ -23,7 +50,6 @@
 #endif
 };
 
-extern struct tvec_t_base_s boot_tvec_bases;
 
 #define TIMER_INITIALIZER(_function, _expires, _data) {		\
 		.function = (_function),			\
@@ -62,7 +88,8 @@
 	return timer->entry.next != NULL;
 }
 
-extern void add_timer_on(struct timer_list *timer, int cpu);
+extern void add_timer_on(struct timer_list *timer, int cpu,
+                         int not_critical_when_idle);
 extern int del_timer(struct timer_list * timer);
 extern int __mod_timer(struct timer_list *timer, unsigned long expires);
 extern int mod_timer(struct timer_list *timer, unsigned long expires);
@@ -144,6 +171,16 @@
 static inline void add_timer(struct timer_list *timer)
 {
 	BUG_ON(timer_pending(timer));
+	timer->base = TBASE_CLEAR_DELAYED_ON_IDLE(timer->base);
+	__mod_timer(timer, timer->expires);
+}
+
+static inline void add_timer_with_hint(struct timer_list *timer,
+                                       int not_critical_when_idle)
+{
+	BUG_ON(timer_pending(timer));
+	timer->base = TBASE_MERGE_DELAYED_ON_IDLE(timer->base,
+	                                          not_critical_when_idle);
 	__mod_timer(timer, timer->expires);
 }
 
Index: linux-2.6.20/arch/powerpc/platforms/chrp/setup.c
===================================================================
--- linux-2.6.20.orig/arch/powerpc/platforms/chrp/setup.c	2007-03-16 14:13:19.000000000 -0700
+++ linux-2.6.20/arch/powerpc/platforms/chrp/setup.c	2007-03-16 14:47:28.000000000 -0700
@@ -565,7 +565,7 @@
 			timer = &per_cpu(heartbeat_timer, cpu);
 			setup_timer(timer, chrp_event_scan, 0);
 			timer->expires = jiffies + offset;
-			add_timer_on(timer, cpu);
+			add_timer_on(timer, cpu, 0);
 			offset += interval;
 		}
 		printk("RTAS Event Scan Rate: %u (%lu jiffies)\n",
Index: linux-2.6.20/kernel/workqueue.c
===================================================================
--- linux-2.6.20.orig/kernel/workqueue.c	2007-03-16 14:13:19.000000000 -0700
+++ linux-2.6.20/kernel/workqueue.c	2007-03-16 14:51:00.000000000 -0700
@@ -290,7 +290,7 @@
 		timer->expires = jiffies + delay;
 		timer->data = (unsigned long)dwork;
 		timer->function = delayed_work_timer_fn;
-		add_timer_on(timer, cpu);
+		add_timer_on(timer, cpu, 0);
 		ret = 1;
 	}
 	return ret;
