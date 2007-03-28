Return-Path: <linux-kernel-owner+w=401wt.eu-S933798AbXC1XBG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933798AbXC1XBG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 19:01:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933699AbXC1XBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 19:01:06 -0400
Received: from mga01.intel.com ([192.55.52.88]:3418 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933798AbXC1XBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 19:01:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,342,1170662400"; 
   d="scan'208"; a="221109611:sNHT21096852"
Date: Wed, 28 Mar 2007 16:00:21 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       davej@codemonkey.org.uk, johnstul@us.ibm.com, mingo@elte.hu,
       tglx@linutronix.de, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] Add support for deferrable timers (respun-Mar28)
Message-ID: <20070328230021.GA29774@linux-os.sc.intel.com>
References: <200703212353.l2LNrNOj007453@shell0.pdx.osdl.net> <20070322140532.GA120@tv-sign.ru> <20070322151817.GA29840@linux-os.sc.intel.com> <20070322161355.GA160@tv-sign.ru> <20070327204344.GA21529@linux-os.sc.intel.com> <20070327211145.GB216@tv-sign.ru> <20070327215542.GA27408@linux-os.sc.intel.com> <20070327222227.GA279@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070327222227.GA279@tv-sign.ru>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Andrew,

Please drop the patch you included yesterday and two incremental patches and
use the patch below.

This patch is - yesterday's patch + Your tidy cleanup +
minor changes based on comments from Oleg and Andi. This is a lot
cleaner (and smaller) than earlier patches.

Thanks,
Venki


Introduce a new flag for timers - deferrable:
Timers that work normally when system is busy. But, will not cause CPU to
come out of idle (just to service this timer), when CPU is idle. Instead,
this timer will be serviced when CPU eventually wakes up with a subsequent
non-deferrable timer.

The main advantage of this is to avoid unnecessary timer interrupts when
CPU is idle. If the routine currently called by a timer can wait until next
event without any issues, this new timer can be used to setup timer event
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

Index: new/kernel/timer.c
===================================================================
--- new.orig/kernel/timer.c	2007-03-22 16:27:44.000000000 -0800
+++ new/kernel/timer.c	2007-03-28 10:05:38.000000000 -0800
@@ -74,7 +74,7 @@
 	tvec_t tv3;
 	tvec_t tv4;
 	tvec_t tv5;
-} ____cacheline_aligned_in_smp;
+} ____cacheline_aligned;
 
 typedef struct tvec_t_base_s tvec_base_t;
 
@@ -82,6 +82,37 @@
 EXPORT_SYMBOL(boot_tvec_bases);
 static DEFINE_PER_CPU(tvec_base_t *, tvec_bases) = &boot_tvec_bases;
 
+/*
+ * Note that all tvec_bases is 2 byte aligned and lower bit of
+ * base in timer_list is guaranteed to be zero. Use the LSB for
+ * the new flag to indicate whether the timer is deferrable
+ */
+#define TBASE_DEFERRABLE_FLAG		(0x1)
+
+/* Functions below help us manage 'deferrable' flag */
+static inline unsigned int tbase_get_deferrable(tvec_base_t *base)
+{
+	return ((unsigned int)(unsigned long)base & TBASE_DEFERRABLE_FLAG);
+}
+
+static inline tvec_base_t *tbase_get_base(tvec_base_t *base)
+{
+	return ((tvec_base_t *)((unsigned long)base & ~TBASE_DEFERRABLE_FLAG));
+}
+
+static inline void timer_set_deferrable(struct timer_list *timer)
+{
+	timer->base = ((tvec_base_t *)((unsigned long)(timer->base) |
+	                               TBASE_DEFERRABLE_FLAG));
+}
+
+static inline void
+timer_set_base(struct timer_list *timer, tvec_base_t *new_base)
+{
+	timer->base = (tvec_base_t *)((unsigned long)(new_base) |
+	                              tbase_get_deferrable(timer->base));
+}
+
 /**
  * __round_jiffies - function to round jiffies to a full second
  * @j: the time in (absolute) jiffies that should be rounded
@@ -295,6 +326,13 @@
 }
 EXPORT_SYMBOL(init_timer);
 
+void fastcall init_timer_deferrable(struct timer_list *timer)
+{
+	init_timer(timer);
+	timer_set_deferrable(timer);
+}
+EXPORT_SYMBOL(init_timer_deferrable);
+
 static inline void detach_timer(struct timer_list *timer,
 				int clear_pending)
 {
@@ -325,10 +363,11 @@
 	tvec_base_t *base;
 
 	for (;;) {
-		base = timer->base;
+		tvec_base_t *prelock_base = timer->base;
+		base = tbase_get_base(prelock_base);
 		if (likely(base != NULL)) {
 			spin_lock_irqsave(&base->lock, *flags);
-			if (likely(base == timer->base))
+			if (likely(prelock_base == timer->base))
 				return base;
 			/* The timer has migrated to another CPU */
 			spin_unlock_irqrestore(&base->lock, *flags);
@@ -365,11 +404,11 @@
 		 */
 		if (likely(base->running_timer != timer)) {
 			/* See the comment in lock_timer_base() */
-			timer->base = NULL;
+			timer_set_base(timer, NULL);
 			spin_unlock(&base->lock);
 			base = new_base;
 			spin_lock(&base->lock);
-			timer->base = base;
+			timer_set_base(timer, base);
 		}
 	}
 
@@ -397,7 +436,7 @@
 	timer_stats_timer_set_start_info(timer);
   	BUG_ON(timer_pending(timer) || !timer->function);
 	spin_lock_irqsave(&base->lock, flags);
-	timer->base = base;
+	timer_set_base(timer, base);
 	internal_add_timer(base, timer);
 	spin_unlock_irqrestore(&base->lock, flags);
 }
@@ -548,7 +587,7 @@
 	 * don't have to detach them individually.
 	 */
 	list_for_each_entry_safe(timer, tmp, &tv_list, entry) {
-		BUG_ON(timer->base != base);
+		BUG_ON(tbase_get_base(timer->base) != base);
 		internal_add_timer(base, timer);
 	}
 
@@ -634,6 +673,9 @@
 	index = slot = timer_jiffies & TVR_MASK;
 	do {
 		list_for_each_entry(nte, base->tv1.vec + slot, entry) {
+ 			if (tbase_get_deferrable(nte->base))
+ 				continue;
+ 
 			found = 1;
 			expires = nte->expires;
 			/* Look at the cascade bucket(s)? */
@@ -1602,6 +1644,13 @@
 						cpu_to_node(cpu));
 			if (!base)
 				return -ENOMEM;
+
+			/* Make sure that tvec_base is 2 byte aligned */
+			if (tbase_get_deferrable(base)) {
+				WARN_ON(1);
+				kfree(base);
+				return -ENOMEM;
+			}
 			memset(base, 0, sizeof(*base));
 			per_cpu(tvec_bases, cpu) = base;
 		} else {
@@ -1643,7 +1692,7 @@
 	while (!list_empty(head)) {
 		timer = list_entry(head->next, struct timer_list, entry);
 		detach_timer(timer, 0);
-		timer->base = new_base;
+		timer_set_base(timer, new_base);
 		internal_add_timer(new_base, timer);
 	}
 }
Index: new/include/linux/timer.h
===================================================================
--- new.orig/include/linux/timer.h	2007-03-22 16:27:44.000000000 -0800
+++ new/include/linux/timer.h	2007-03-28 10:03:14.000000000 -0800
@@ -37,6 +37,7 @@
 		TIMER_INITIALIZER(_function, _expires, _data)
 
 void fastcall init_timer(struct timer_list * timer);
+void fastcall init_timer_deferrable(struct timer_list *timer);
 
 static inline void setup_timer(struct timer_list * timer,
 				void (*function)(unsigned long),
