Return-Path: <linux-kernel-owner+w=401wt.eu-S1756590AbXKSSdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590AbXKSSdo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 13:33:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751665AbXKSSde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 13:33:34 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:42876 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751009AbXKSSdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 13:33:31 -0500
Date: Mon, 19 Nov 2007 19:33:58 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, tglx@linutronix.de
Subject: kernel/timer.c cleanups
Message-ID: <20071119183358.GA20607@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Would something like this be acceptable? I believe it is way too
infected with hungarian notation... Who is the person to send it to?
 
							Pavel

diff --git a/include/linux/timer.h b/include/linux/timer.h
index 78cf899..de0e713 100644
--- a/include/linux/timer.h
+++ b/include/linux/timer.h
@@ -5,7 +5,7 @@ #include <linux/list.h>
 #include <linux/ktime.h>
 #include <linux/stddef.h>
 
-struct tvec_t_base_s;
+struct tvec_base;
 
 struct timer_list {
 	struct list_head entry;
@@ -14,7 +14,7 @@ struct timer_list {
 	void (*function)(unsigned long);
 	unsigned long data;
 
-	struct tvec_t_base_s *base;
+	struct tvec_base *base;
 #ifdef CONFIG_TIMER_STATS
 	void *start_site;
 	char start_comm[16];
@@ -22,7 +22,7 @@ #ifdef CONFIG_TIMER_STATS
 #endif
 };
 
-extern struct tvec_t_base_s boot_tvec_bases;
+extern struct tvec_base boot_tvec_bases;
 
 #define TIMER_INITIALIZER(_function, _expires, _data) {		\
 		.function = (_function),			\
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 1c0a7b8..6fa66f7 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -295,7 +295,7 @@ #endif
 			/* Check, if the timer was already in the past */
 			if (hrtimer_active(&ts->sched_timer))
 				goto out;
-		} else if(!tick_program_event(expires, 0))
+		} else if (!tick_program_event(expires, 0))
 				goto out;
 		/*
 		 * We are past the event already. So we crossed a
@@ -506,7 +506,7 @@ #endif /* NO_HZ */
  */
 #ifdef CONFIG_HIGH_RES_TIMERS
 /*
- * We rearm the timer until we get disabled by the idle code
+ * We rearm the timer until we get disabled by the idle code.
  * Called with interrupts disabled and timer->base->cpu_base->lock held.
  */
 static enum hrtimer_restart tick_sched_timer(struct hrtimer *timer)
diff --git a/kernel/timer.c b/kernel/timer.c
index a05817c..adaa5d0 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -58,59 +58,57 @@ #define TVR_SIZE (1 << TVR_BITS)
 #define TVN_MASK (TVN_SIZE - 1)
 #define TVR_MASK (TVR_SIZE - 1)
 
-typedef struct tvec_s {
+struct tvec {
 	struct list_head vec[TVN_SIZE];
-} tvec_t;
+};
 
-typedef struct tvec_root_s {
+struct tvec_root {
 	struct list_head vec[TVR_SIZE];
-} tvec_root_t;
+};
 
-struct tvec_t_base_s {
+struct tvec_base {
 	spinlock_t lock;
 	struct timer_list *running_timer;
 	unsigned long timer_jiffies;
-	tvec_root_t tv1;
-	tvec_t tv2;
-	tvec_t tv3;
-	tvec_t tv4;
-	tvec_t tv5;
+	struct tvec_root tv1;
+	struct tvec tv2;
+	struct tvec tv3;
+	struct tvec tv4;
+	struct tvec tv5;
 } ____cacheline_aligned;
 
-typedef struct tvec_t_base_s tvec_base_t;
-
-tvec_base_t boot_tvec_bases;
-EXPORT_SYMBOL(boot_tvec_bases);
-static DEFINE_PER_CPU(tvec_base_t *, tvec_bases) = &boot_tvec_bases;
+struct tvec_base boot_tvec_bases;
+EXPORT_SYMBOL(boot_tvec_bases);		/* exported, but whey they do get definition? */
+static DEFINE_PER_CPU(struct tvec_base *, tvec_bases) = &boot_tvec_bases;
 
 /*
- * Note that all tvec_bases is 2 byte aligned and lower bit of
+ * Note that all tvec_bases are 2 byte aligned and lower bit of
  * base in timer_list is guaranteed to be zero. Use the LSB for
  * the new flag to indicate whether the timer is deferrable
  */
 #define TBASE_DEFERRABLE_FLAG		(0x1)
 
 /* Functions below help us manage 'deferrable' flag */
-static inline unsigned int tbase_get_deferrable(tvec_base_t *base)
+static inline unsigned int tbase_get_deferrable(struct tvec_base *base)
 {
 	return ((unsigned int)(unsigned long)base & TBASE_DEFERRABLE_FLAG);
 }
 
-static inline tvec_base_t *tbase_get_base(tvec_base_t *base)
+static inline struct tvec_base *tbase_get_base(struct tvec_base *base)
 {
-	return ((tvec_base_t *)((unsigned long)base & ~TBASE_DEFERRABLE_FLAG));
+	return ((struct tvec_base *)((unsigned long)base & ~TBASE_DEFERRABLE_FLAG));
 }
 
 static inline void timer_set_deferrable(struct timer_list *timer)
 {
-	timer->base = ((tvec_base_t *)((unsigned long)(timer->base) |
+	timer->base = ((struct tvec_base *)((unsigned long)(timer->base) |
 				       TBASE_DEFERRABLE_FLAG));
 }
 
 static inline void
-timer_set_base(struct timer_list *timer, tvec_base_t *new_base)
+timer_set_base(struct timer_list *timer, struct tvec_base *new_base)
 {
-	timer->base = (tvec_base_t *)((unsigned long)(new_base) |
+	timer->base = (struct tvec_base *)((unsigned long)(new_base) |
 				      tbase_get_deferrable(timer->base));
 }
 
@@ -246,7 +244,7 @@ unsigned long round_jiffies_relative(uns
 EXPORT_SYMBOL_GPL(round_jiffies_relative);
 
 
-static inline void set_running_timer(tvec_base_t *base,
+static inline void set_running_timer(struct tvec_base *base,
 					struct timer_list *timer)
 {
 #ifdef CONFIG_SMP
@@ -254,7 +252,7 @@ #ifdef CONFIG_SMP
 #endif
 }
 
-static void internal_add_timer(tvec_base_t *base, struct timer_list *timer)
+static void internal_add_timer(struct tvec_base *base, struct timer_list *timer)
 {
 	unsigned long expires = timer->expires;
 	unsigned long idx = expires - base->timer_jiffies;
@@ -371,14 +369,14 @@ static inline void detach_timer(struct t
  * possible to set timer->base = NULL and drop the lock: the timer remains
  * locked.
  */
-static tvec_base_t *lock_timer_base(struct timer_list *timer,
+static struct tvec_base *lock_timer_base(struct timer_list *timer,
 					unsigned long *flags)
 	__acquires(timer->base->lock)
 {
-	tvec_base_t *base;
+	struct tvec_base *base;
 
 	for (;;) {
-		tvec_base_t *prelock_base = timer->base;
+		struct tvec_base *prelock_base = timer->base;
 		base = tbase_get_base(prelock_base);
 		if (likely(base != NULL)) {
 			spin_lock_irqsave(&base->lock, *flags);
@@ -393,7 +391,7 @@ static tvec_base_t *lock_timer_base(stru
 
 int __mod_timer(struct timer_list *timer, unsigned long expires)
 {
-	tvec_base_t *base, *new_base;
+	struct tvec_base *base, *new_base;
 	unsigned long flags;
 	int ret = 0;
 
@@ -445,7 +443,7 @@ EXPORT_SYMBOL(__mod_timer);
  */
 void add_timer_on(struct timer_list *timer, int cpu)
 {
-	tvec_base_t *base = per_cpu(tvec_bases, cpu);
+	struct tvec_base *base = per_cpu(tvec_bases, cpu);
 	unsigned long flags;
 
 	timer_stats_timer_set_start_info(timer);
@@ -508,7 +506,7 @@ EXPORT_SYMBOL(mod_timer);
  */
 int del_timer(struct timer_list *timer)
 {
-	tvec_base_t *base;
+	struct tvec_base *base;
 	unsigned long flags;
 	int ret = 0;
 
@@ -539,7 +537,7 @@ #ifdef CONFIG_SMP
  */
 int try_to_del_timer_sync(struct timer_list *timer)
 {
-	tvec_base_t *base;
+	struct tvec_base *base;
 	unsigned long flags;
 	int ret = -1;
 
@@ -591,7 +589,7 @@ int del_timer_sync(struct timer_list *ti
 EXPORT_SYMBOL(del_timer_sync);
 #endif
 
-static int cascade(tvec_base_t *base, tvec_t *tv, int index)
+static int cascade(struct tvec_base *base, struct tvec *tv, int index)
 {
 	/* cascade all the timers from tv up one level */
 	struct timer_list *timer, *tmp;
@@ -620,7 +618,7 @@ #define INDEX(N) ((base->timer_jiffies >
  * This function cascades all vectors and executes all expired timer
  * vectors.
  */
-static inline void __run_timers(tvec_base_t *base)
+static inline void __run_timers(struct tvec_base *base)
 {
 	struct timer_list *timer;
 
@@ -678,13 +676,13 @@ #if defined(CONFIG_NO_IDLE_HZ) || define
  * is used on S/390 to stop all activity when a cpus is idle.
  * This functions needs to be called disabled.
  */
-static unsigned long __next_timer_interrupt(tvec_base_t *base)
+static unsigned long __next_timer_interrupt(struct tvec_base *base)
 {
 	unsigned long timer_jiffies = base->timer_jiffies;
 	unsigned long expires = timer_jiffies + NEXT_TIMER_MAX_DELTA;
 	int index, slot, array, found = 0;
 	struct timer_list *nte;
-	tvec_t *varray[4];
+	struct tvec *varray[4];
 
 	/* Look for timer events in tv1. */
 	index = slot = timer_jiffies & TVR_MASK;
@@ -716,7 +714,7 @@ cascade:
 	varray[3] = &base->tv5;
 
 	for (array = 0; array < 4; array++) {
-		tvec_t *varp = varray[array];
+		struct tvec *varp = varray[array];
 
 		index = slot = timer_jiffies & TVN_MASK;
 		do {
@@ -795,7 +793,7 @@ static unsigned long cmp_next_hrtimer_ev
  */
 unsigned long get_next_timer_interrupt(unsigned long now)
 {
-	tvec_base_t *base = __get_cpu_var(tvec_bases);
+	struct tvec_base *base = __get_cpu_var(tvec_bases);
 	unsigned long expires;
 
 	spin_lock(&base->lock);
@@ -894,7 +892,7 @@ static inline void calc_load(unsigned lo
  */
 static void run_timer_softirq(struct softirq_action *h)
 {
-	tvec_base_t *base = __get_cpu_var(tvec_bases);
+	struct tvec_base *base = __get_cpu_var(tvec_bases);
 
 	hrtimer_run_queues();
 
@@ -1222,7 +1220,7 @@ static struct lock_class_key base_lock_k
 static int __devinit init_timers_cpu(int cpu)
 {
 	int j;
-	tvec_base_t *base;
+	struct tvec_base *base;
 	static char __devinitdata tvec_base_done[NR_CPUS];
 
 	if (!tvec_base_done[cpu]) {
@@ -1277,7 +1275,7 @@ static int __devinit init_timers_cpu(int
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
-static void migrate_timer_list(tvec_base_t *new_base, struct list_head *head)
+static void migrate_timer_list(struct tvec_base *new_base, struct list_head *head)
 {
 	struct timer_list *timer;
 
@@ -1291,8 +1289,8 @@ static void migrate_timer_list(tvec_base
 
 static void __devinit migrate_timers(int cpu)
 {
-	tvec_base_t *old_base;
-	tvec_base_t *new_base;
+	struct tvec_base *old_base;
+	struct tvec_base *new_base;
 	int i;
 
 	BUG_ON(cpu_online(cpu));

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
