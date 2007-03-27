Return-Path: <linux-kernel-owner+w=401wt.eu-S932638AbXC0Uob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932638AbXC0Uob (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 16:44:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934204AbXC0Uoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 16:44:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:24049 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932638AbXC0Uo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 16:44:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,335,1170662400"; 
   d="scan'208"; a="217462103:sNHT3301583684"
Date: Tue, 27 Mar 2007 13:43:44 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       davej@codemonkey.org.uk, johnstul@us.ibm.com, mingo@elte.hu,
       tglx@linutronix.de
Subject: [PATCH] Add support for deferrable timers (respun)
Message-ID: <20070327204344.GA21529@linux-os.sc.intel.com>
References: <200703212353.l2LNrNOj007453@shell0.pdx.osdl.net> <20070322140532.GA120@tv-sign.ru> <20070322151817.GA29840@linux-os.sc.intel.com> <20070322161355.GA160@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070322161355.GA160@tv-sign.ru>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2007 at 07:13:55PM +0300, Oleg Nesterov wrote:
> 
> Perhaps we can do something like this,
> 
> 	struct deferrable_timer {
> 		struct timer_list timer;
> 		void (*real_function)(struct deferrable_timer *self);
> 	};
> 
> 	static void deferrable_timer_fn(unsigned long data)
> 	{
> 		struct deferrable_timer dtimer = (void*)data;
> 		dtimer->real_function(dtimer);
> 	}
> 
> 	void setup_deferrable_timer(struct deferrable_timer *dtimer,
> 				void (*function)(struct deferrable_timer *self))
> 	{
> 		setup_timer(&dtimer->timer, deferrable_timer_fn, dtimer);
> 		dtimer->real_function = function;
> 	}
> 
> Now next_timer_interrupt() can check "nte->function == deferrable_timer_fn"
> to detect a deferrable_timer. I can't say I like this idea very much, though.
> 
> However, it would be nice to avoid timer->base manipulation and minimize the
> changes in timer.c, if possible.
> 

I looked at the above option. It seems more complicated than the patch below,
mainly because now we have to have a new set of interfaces for this
deferrable_timer exported, which will include init_deferrable_timer,
setup_timer, mod_timer etc (in order to do it cleanly) and workqueue needs to
change as well to include this deferrable_timer.

So, that got me back to my original patch. I tried to reduce the amount of
changes and overhead and hopefully I have gooten it right this time.

Patch below.

Thanks,
Venki

---

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
+++ new/kernel/timer.c	2007-03-26 15:19:35.000000000 -0800
@@ -74,7 +74,7 @@
 	tvec_t tv3;
 	tvec_t tv4;
 	tvec_t tv5;
-} ____cacheline_aligned_in_smp;
+} ____cacheline_aligned;
 
 typedef struct tvec_t_base_s tvec_base_t;
 
@@ -82,6 +82,41 @@
 EXPORT_SYMBOL(boot_tvec_bases);
 static DEFINE_PER_CPU(tvec_base_t *, tvec_bases) = &boot_tvec_bases;
 
+/*
+ * The lowest bit of base ptr in timer is used as a flag to indicate
+ * 'deferrable' nature of the timer. Functions below help us manage that flag.
+ */
+static inline unsigned int tbase_get_deferrable(struct tvec_t_base_s *base)
+{
+	return ((unsigned int)base & TBASE_DEFERRABLE_FLAG);
+}
+
+static inline unsigned int timer_get_deferrable(struct timer_list *timer)
+{
+	return tbase_get_deferrable(timer->base);
+}
+
+static inline struct tvec_t_base_s *timer_get_base(struct timer_list *timer)
+{
+	return ((struct tvec_t_base_s *)((unsigned long)(timer->base) &
+	                                 ~TBASE_DEFERRABLE_FLAG));
+}
+
+static inline void timer_set_deferrable(struct timer_list *timer)
+{
+	timer->base = ((struct tvec_t_base_s *)((unsigned long)(timer->base) |
+	                                        TBASE_DEFERRABLE_FLAG));
+}
+
+/* new_base is guaranteed to have last bit not set, in all callers below */
+static inline void timer_set_base(struct timer_list *timer,
+					struct tvec_t_base_s *old_base,
+					struct tvec_t_base_s *new_base)
+{
+	timer->base = (struct tvec_t_base_s *)((unsigned long)(new_base) |
+	                                       tbase_get_deferrable(old_base));
+}
+
 /**
  * __round_jiffies - function to round jiffies to a full second
  * @j: the time in (absolute) jiffies that should be rounded
@@ -295,6 +330,13 @@
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
@@ -325,10 +367,11 @@
 	tvec_base_t *base;
 
 	for (;;) {
-		base = timer->base;
+		tvec_base_t *prelock_base = timer->base;
+		base = timer_get_base(timer);
 		if (likely(base != NULL)) {
 			spin_lock_irqsave(&base->lock, *flags);
-			if (likely(base == timer->base))
+			if (likely(prelock_base == timer->base))
 				return base;
 			/* The timer has migrated to another CPU */
 			spin_unlock_irqrestore(&base->lock, *flags);
@@ -364,12 +407,13 @@
 		 * the timer is serialized wrt itself.
 		 */
 		if (likely(base->running_timer != timer)) {
+			tvec_base_t *old_base = timer->base;
 			/* See the comment in lock_timer_base() */
 			timer->base = NULL;
 			spin_unlock(&base->lock);
 			base = new_base;
 			spin_lock(&base->lock);
-			timer->base = base;
+			timer_set_base(timer, old_base, base);
 		}
 	}
 
@@ -397,7 +441,7 @@
 	timer_stats_timer_set_start_info(timer);
   	BUG_ON(timer_pending(timer) || !timer->function);
 	spin_lock_irqsave(&base->lock, flags);
-	timer->base = base;
+	timer_set_base(timer, timer->base, base);
 	internal_add_timer(base, timer);
 	spin_unlock_irqrestore(&base->lock, flags);
 }
@@ -548,7 +592,7 @@
 	 * don't have to detach them individually.
 	 */
 	list_for_each_entry_safe(timer, tmp, &tv_list, entry) {
-		BUG_ON(timer->base != base);
+		BUG_ON(timer_get_base(timer) != base);
 		internal_add_timer(base, timer);
 	}
 
@@ -634,6 +678,9 @@
 	index = slot = timer_jiffies & TVR_MASK;
 	do {
 		list_for_each_entry(nte, base->tv1.vec + slot, entry) {
+ 			if (timer_get_deferrable(nte))
+ 				continue;
+ 
 			found = 1;
 			expires = nte->expires;
 			/* Look at the cascade bucket(s)? */
@@ -1602,6 +1649,13 @@
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
@@ -1643,7 +1697,7 @@
 	while (!list_empty(head)) {
 		timer = list_entry(head->next, struct timer_list, entry);
 		detach_timer(timer, 0);
-		timer->base = new_base;
+		timer_set_base(timer, timer->base, new_base);
 		internal_add_timer(new_base, timer);
 	}
 }
Index: new/include/linux/timer.h
===================================================================
--- new.orig/include/linux/timer.h	2007-03-22 16:27:44.000000000 -0800
+++ new/include/linux/timer.h	2007-03-23 10:08:17.000000000 -0800
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
+void fastcall init_timer_deferrable(struct timer_list *timer);
 
 static inline void setup_timer(struct timer_list * timer,
 				void (*function)(unsigned long),
