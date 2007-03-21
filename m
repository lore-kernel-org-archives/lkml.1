Return-Path: <linux-kernel-owner+w=401wt.eu-S964868AbXCUUWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964868AbXCUUWo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 16:22:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964931AbXCUUWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 16:22:44 -0400
Received: from mga03.intel.com ([143.182.124.21]:26202 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964888AbXCUUWm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 16:22:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,309,1170662400"; 
   d="scan'208"; a="200302466:sNHT22130717"
Date: Wed, 21 Mar 2007 13:22:17 -0700
From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
       tglx@linutronix.de
Subject: [PATCH 1/2] Add support for deferrable timers
Message-ID: <20070321202217.GA29367@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Introduce a new flag for timers - 'deferrable timer'
Timers that work normally when system is busy. But, will not cause CPU to
come out of idle (just to service this timer), when CPU is idle. Instead,
this timer will be serviced when CPU eventually wakes up with a subsequent
non-deferrable timer or any other event.

The main advantage of this is to avoid unnecessary timer interrupts when
CPU is idle. If the routine currently called by a timer can wait until next
event without any issues, this new timer can be used while setting up timer
for that routine. This, with dynticks, allows CPUs to be lazy, allowing them
to stay in idle for extended period of time by reducing unnecesary wakeup and
thereby reducing the power consumption.

This patch:
Builds this new timer on top of existing timer infrastructure. It uses
last bit in 'base' pointer of timer_list structure to store this
deferrable timer flag. __next_timer_interrupt() function
skips over these deferrable timers when CPU looks for
next timer event for which it has to wake up.

This is exported by a new interface init_timer_deferrable() that can
be called in place of regular init_timer().

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
---

Modified version of the patches based on earlier attempts.
http://www.ussg.iu.edu/hypermail/linux/kernel/0703.2/0391.html

Also resolved the soft hangup issue that Dave pointed to in earlier version
of this patch.

Index: new/kernel/timer.c
===================================================================
--- new.orig/kernel/timer.c	2007-03-21 09:16:53.000000000 -0800
+++ new/kernel/timer.c	2007-03-21 09:18:02.000000000 -0800
@@ -74,7 +74,7 @@
 	tvec_t tv3;
 	tvec_t tv4;
 	tvec_t tv5;
-} ____cacheline_aligned_in_smp;
+} ____cacheline_aligned;
 
 typedef struct tvec_t_base_s tvec_base_t;
 
@@ -82,6 +82,46 @@
 EXPORT_SYMBOL(boot_tvec_bases);
 static DEFINE_PER_CPU(tvec_base_t *, tvec_bases) = &boot_tvec_bases;
 
+/*
+ * The lowest bit of base ptr in timer is used as a flag to indicate
+ * 'deferrable' nature of the timer. Functions below help us manage that flag.
+ */
+static inline struct tvec_t_base_s *tbase_get_base_ptr(
+	struct tvec_t_base_s *base)
+{
+	return ((struct tvec_t_base_s *)
+			((unsigned long)base & (~TBASE_DEFERRABLE_FLAG)));
+}
+
+static inline unsigned long tbase_get_deferrable_flag(
+	struct tvec_t_base_s *base)
+{
+	return ((unsigned long)base & TBASE_DEFERRABLE_FLAG);
+}
+
+static inline struct tvec_t_base_s *tbase_set_deferrable_flag(
+	struct tvec_t_base_s *base)
+{
+	return ((struct tvec_t_base_s *)
+			((unsigned long)base | TBASE_DEFERRABLE_FLAG));
+}
+
+static inline struct tvec_t_base_s *tbase_clear_deferrable_flag(
+	struct tvec_t_base_s *base)
+{
+	return ((struct tvec_t_base_s *)
+			((unsigned long)base & (~TBASE_DEFERRABLE_FLAG)));
+}
+
+static inline struct tvec_t_base_s *tbase_merge_deferrable_flag(
+	struct tvec_t_base_s *base, unsigned long flag)
+{
+	if (flag & TBASE_DEFERRABLE_FLAG)
+		return tbase_set_deferrable_flag(base);
+	else
+		return tbase_clear_deferrable_flag(base);
+}
+
 /**
  * __round_jiffies - function to round jiffies to a full second
  * @j: the time in (absolute) jiffies that should be rounded
@@ -295,6 +335,13 @@
 }
 EXPORT_SYMBOL(init_timer);
 
+void fastcall init_timer_deferrable(struct timer_list *timer)
+{
+	init_timer(timer);
+	timer->base = tbase_set_deferrable_flag(timer->base);
+}
+EXPORT_SYMBOL(init_timer_deferrable);
+
 static inline void detach_timer(struct timer_list *timer,
 				int clear_pending)
 {
@@ -325,7 +372,7 @@
 	tvec_base_t *base;
 
 	for (;;) {
-		base = timer->base;
+		base = tbase_get_base_ptr(timer->base);
 		if (likely(base != NULL)) {
 			spin_lock_irqsave(&base->lock, *flags);
 			if (likely(base == timer->base))
@@ -364,12 +411,15 @@
 		 * the timer is serialized wrt itself.
 		 */
 		if (likely(base->running_timer != timer)) {
+			unsigned long tflag;
+			tflag = tbase_get_deferrable_flag(timer->base);
 			/* See the comment in lock_timer_base() */
 			timer->base = NULL;
 			spin_unlock(&base->lock);
 			base = new_base;
 			spin_lock(&base->lock);
-			timer->base = base;
+			timer->base =
+				tbase_merge_deferrable_flag(new_base, tflag);
 		}
 	}
 
@@ -393,11 +443,13 @@
 {
 	tvec_base_t *base = per_cpu(tvec_bases, cpu);
   	unsigned long flags;
+	unsigned long tflag;
 
 	timer_stats_timer_set_start_info(timer);
   	BUG_ON(timer_pending(timer) || !timer->function);
 	spin_lock_irqsave(&base->lock, flags);
-	timer->base = base;
+	tflag = tbase_get_deferrable_flag(timer->base);
+	timer->base = tbase_merge_deferrable_flag(base, tflag);
 	internal_add_timer(base, timer);
 	spin_unlock_irqrestore(&base->lock, flags);
 }
@@ -524,6 +576,8 @@
  */
 int del_timer_sync(struct timer_list *timer)
 {
+	/* Force change the timer flag to be non-deferrable */
+	timer->base = tbase_clear_deferrable_flag(timer->base);
 	for (;;) {
 		int ret = try_to_del_timer_sync(timer);
 		if (ret >= 0)
@@ -548,7 +602,7 @@
 	 * don't have to detach them individually.
 	 */
 	list_for_each_entry_safe(timer, tmp, &tv_list, entry) {
-		BUG_ON(timer->base != base);
+		BUG_ON(tbase_get_base_ptr(timer->base) != base);
 		internal_add_timer(base, timer);
 	}
 
@@ -634,6 +688,9 @@
 	index = slot = timer_jiffies & TVR_MASK;
 	do {
 		list_for_each_entry(nte, base->tv1.vec + slot, entry) {
+ 			if (tbase_get_deferrable_flag(nte->base))
+ 				continue;
+ 
 			found = 1;
 			expires = nte->expires;
 			/* Look at the cascade bucket(s)? */
@@ -1602,6 +1659,13 @@
 						cpu_to_node(cpu));
 			if (!base)
 				return -ENOMEM;
+
+			/* Make sure that tvec_base is 2 byte aligned */
+			if (tbase_get_deferrable_flag(base)) {
+				WARN_ON(1);
+				kfree(base);
+				return -ENOMEM;
+			}
 			memset(base, 0, sizeof(*base));
 			per_cpu(tvec_bases, cpu) = base;
 		} else {
@@ -1641,9 +1705,11 @@
 	struct timer_list *timer;
 
 	while (!list_empty(head)) {
+		unsigned long tflag;
 		timer = list_entry(head->next, struct timer_list, entry);
+		tflag = tbase_get_deferrable_flag(timer->base);
 		detach_timer(timer, 0);
-		timer->base = new_base;
+		timer->base = tbase_merge_deferrable_flag(new_base, tflag);
 		internal_add_timer(new_base, timer);
 	}
 }
Index: new/include/linux/timer.h
===================================================================
--- new.orig/include/linux/timer.h	2007-03-21 09:16:53.000000000 -0800
+++ new/include/linux/timer.h	2007-03-21 09:17:16.000000000 -0800
@@ -8,6 +8,14 @@
 
 struct tvec_t_base_s;
 
+extern struct tvec_t_base_s boot_tvec_bases;
+/*
+ * Note that all tvec_bases is 2 byte aligned and lower bit of
+ * base in timer_list is guaranteed to be zero. Use the LSB for
+ * the new flag to indicate whether the timer is deferrable
+ */
+#define TBASE_DEFERRABLE_FLAG		(0x1)
+
 struct timer_list {
 	struct list_head entry;
 	unsigned long expires;
@@ -37,6 +45,7 @@
 		TIMER_INITIALIZER(_function, _expires, _data)
 
 void fastcall init_timer(struct timer_list * timer);
+void fastcall init_timer_deferrable(struct timer_list * timer);
 
 static inline void setup_timer(struct timer_list * timer,
 				void (*function)(unsigned long),
