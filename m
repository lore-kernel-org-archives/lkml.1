Return-Path: <linux-kernel-owner+w=401wt.eu-S934278AbZLFSF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934278AbZLFSF4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 13:05:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934224AbZLFSFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 13:05:45 -0500
Received: from www.tglx.de ([62.245.132.106]:33318 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934231AbZLFSEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 13:04:04 -0500
Message-Id: <20091206111958.106929418@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sun, 06 Dec 2009 18:03:44 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Linux-Arch <linux-arch@vger.kernel.org>
Subject: [patch 21/23] hrtimers: Convert to raw_spinlocks
References: <20091206110944.492100233@linutronix.de>
Content-Disposition: inline; filename=timers-convert-to-core-locks.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/hrtimer.h   |    2 -
 kernel/hrtimer.c          |   50 +++++++++++++++++++++++-----------------------
 kernel/time/timer_list.c  |    6 ++---
 kernel/time/timer_stats.c |   14 ++++++------
 4 files changed, 36 insertions(+), 36 deletions(-)

Index: linux-2.6-tip/include/linux/hrtimer.h
===================================================================
--- linux-2.6-tip.orig/include/linux/hrtimer.h
+++ linux-2.6-tip/include/linux/hrtimer.h
@@ -168,7 +168,7 @@ struct hrtimer_clock_base {
  * @nr_events:		Total number of timer interrupt events
  */
 struct hrtimer_cpu_base {
-	spinlock_t			lock;
+	raw_spinlock_t			lock;
 	struct hrtimer_clock_base	clock_base[HRTIMER_MAX_CLOCK_BASES];
 #ifdef CONFIG_HIGH_RES_TIMERS
 	ktime_t				expires_next;
Index: linux-2.6-tip/kernel/hrtimer.c
===================================================================
--- linux-2.6-tip.orig/kernel/hrtimer.c
+++ linux-2.6-tip/kernel/hrtimer.c
@@ -127,11 +127,11 @@ struct hrtimer_clock_base *lock_hrtimer_
 	for (;;) {
 		base = timer->base;
 		if (likely(base != NULL)) {
-			spin_lock_irqsave(&base->cpu_base->lock, *flags);
+			raw_spin_lock_irqsave(&base->cpu_base->lock, *flags);
 			if (likely(base == timer->base))
 				return base;
 			/* The timer has migrated to another CPU: */
-			spin_unlock_irqrestore(&base->cpu_base->lock, *flags);
+			raw_spin_unlock_irqrestore(&base->cpu_base->lock, *flags);
 		}
 		cpu_relax();
 	}
@@ -208,13 +208,13 @@ again:
 
 		/* See the comment in lock_timer_base() */
 		timer->base = NULL;
-		spin_unlock(&base->cpu_base->lock);
-		spin_lock(&new_base->cpu_base->lock);
+		raw_spin_unlock(&base->cpu_base->lock);
+		raw_spin_lock(&new_base->cpu_base->lock);
 
 		if (cpu != this_cpu && hrtimer_check_target(timer, new_base)) {
 			cpu = this_cpu;
-			spin_unlock(&new_base->cpu_base->lock);
-			spin_lock(&base->cpu_base->lock);
+			raw_spin_unlock(&new_base->cpu_base->lock);
+			raw_spin_lock(&base->cpu_base->lock);
 			timer->base = base;
 			goto again;
 		}
@@ -230,7 +230,7 @@ lock_hrtimer_base(const struct hrtimer *
 {
 	struct hrtimer_clock_base *base = timer->base;
 
-	spin_lock_irqsave(&base->cpu_base->lock, *flags);
+	raw_spin_lock_irqsave(&base->cpu_base->lock, *flags);
 
 	return base;
 }
@@ -619,12 +619,12 @@ static void retrigger_next_event(void *a
 	base = &__get_cpu_var(hrtimer_bases);
 
 	/* Adjust CLOCK_REALTIME offset */
-	spin_lock(&base->lock);
+	raw_spin_lock(&base->lock);
 	base->clock_base[CLOCK_REALTIME].offset =
 		timespec_to_ktime(realtime_offset);
 
 	hrtimer_force_reprogram(base, 0);
-	spin_unlock(&base->lock);
+	raw_spin_unlock(&base->lock);
 }
 
 /*
@@ -685,9 +685,9 @@ static inline int hrtimer_enqueue_reprog
 {
 	if (base->cpu_base->hres_active && hrtimer_reprogram(timer, base)) {
 		if (wakeup) {
-			spin_unlock(&base->cpu_base->lock);
+			raw_spin_unlock(&base->cpu_base->lock);
 			raise_softirq_irqoff(HRTIMER_SOFTIRQ);
-			spin_lock(&base->cpu_base->lock);
+			raw_spin_lock(&base->cpu_base->lock);
 		} else
 			__raise_softirq_irqoff(HRTIMER_SOFTIRQ);
 
@@ -765,7 +765,7 @@ void __timer_stats_hrtimer_set_start_inf
 static inline
 void unlock_hrtimer_base(const struct hrtimer *timer, unsigned long *flags)
 {
-	spin_unlock_irqrestore(&timer->base->cpu_base->lock, *flags);
+	raw_spin_unlock_irqrestore(&timer->base->cpu_base->lock, *flags);
 }
 
 /**
@@ -1098,7 +1098,7 @@ ktime_t hrtimer_get_next_event(void)
 	unsigned long flags;
 	int i;
 
-	spin_lock_irqsave(&cpu_base->lock, flags);
+	raw_spin_lock_irqsave(&cpu_base->lock, flags);
 
 	if (!hrtimer_hres_active()) {
 		for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++, base++) {
@@ -1115,7 +1115,7 @@ ktime_t hrtimer_get_next_event(void)
 		}
 	}
 
-	spin_unlock_irqrestore(&cpu_base->lock, flags);
+	raw_spin_unlock_irqrestore(&cpu_base->lock, flags);
 
 	if (mindelta.tv64 < 0)
 		mindelta.tv64 = 0;
@@ -1197,11 +1197,11 @@ static void __run_hrtimer(struct hrtimer
 	 * they get migrated to another cpu, therefore its safe to unlock
 	 * the timer base.
 	 */
-	spin_unlock(&cpu_base->lock);
+	raw_spin_unlock(&cpu_base->lock);
 	trace_hrtimer_expire_entry(timer, now);
 	restart = fn(timer);
 	trace_hrtimer_expire_exit(timer);
-	spin_lock(&cpu_base->lock);
+	raw_spin_lock(&cpu_base->lock);
 
 	/*
 	 * Note: We clear the CALLBACK bit after enqueue_hrtimer and
@@ -1265,7 +1265,7 @@ void hrtimer_interrupt(struct clock_even
 
 	expires_next.tv64 = KTIME_MAX;
 
-	spin_lock(&cpu_base->lock);
+	raw_spin_lock(&cpu_base->lock);
 	/*
 	 * We set expires_next to KTIME_MAX here with cpu_base->lock
 	 * held to prevent that a timer is enqueued in our queue via
@@ -1321,7 +1321,7 @@ void hrtimer_interrupt(struct clock_even
 	 * against it.
 	 */
 	cpu_base->expires_next = expires_next;
-	spin_unlock(&cpu_base->lock);
+	raw_spin_unlock(&cpu_base->lock);
 
 	/* Reprogramming necessary ? */
 	if (expires_next.tv64 != KTIME_MAX) {
@@ -1423,7 +1423,7 @@ void hrtimer_run_queues(void)
 			gettime = 0;
 		}
 
-		spin_lock(&cpu_base->lock);
+		raw_spin_lock(&cpu_base->lock);
 
 		while ((node = base->first)) {
 			struct hrtimer *timer;
@@ -1435,7 +1435,7 @@ void hrtimer_run_queues(void)
 
 			__run_hrtimer(timer, &base->softirq_time);
 		}
-		spin_unlock(&cpu_base->lock);
+		raw_spin_unlock(&cpu_base->lock);
 	}
 }
 
@@ -1591,7 +1591,7 @@ static void __cpuinit init_hrtimers_cpu(
 	struct hrtimer_cpu_base *cpu_base = &per_cpu(hrtimer_bases, cpu);
 	int i;
 
-	spin_lock_init(&cpu_base->lock);
+	raw_spin_lock_init(&cpu_base->lock);
 
 	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++)
 		cpu_base->clock_base[i].cpu_base = cpu_base;
@@ -1649,16 +1649,16 @@ static void migrate_hrtimers(int scpu)
 	 * The caller is globally serialized and nobody else
 	 * takes two locks at once, deadlock is not possible.
 	 */
-	spin_lock(&new_base->lock);
-	spin_lock_nested(&old_base->lock, SINGLE_DEPTH_NESTING);
+	raw_spin_lock(&new_base->lock);
+	raw_spin_lock_nested(&old_base->lock, SINGLE_DEPTH_NESTING);
 
 	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++) {
 		migrate_hrtimer_list(&old_base->clock_base[i],
 				     &new_base->clock_base[i]);
 	}
 
-	spin_unlock(&old_base->lock);
-	spin_unlock(&new_base->lock);
+	raw_spin_unlock(&old_base->lock);
+	raw_spin_unlock(&new_base->lock);
 
 	/* Check, if we got expired work to do */
 	__hrtimer_peek_ahead_timers();
Index: linux-2.6-tip/kernel/time/timer_list.c
===================================================================
--- linux-2.6-tip.orig/kernel/time/timer_list.c
+++ linux-2.6-tip/kernel/time/timer_list.c
@@ -84,7 +84,7 @@ print_active_timers(struct seq_file *m, 
 
 next_one:
 	i = 0;
-	spin_lock_irqsave(&base->cpu_base->lock, flags);
+	raw_spin_lock_irqsave(&base->cpu_base->lock, flags);
 
 	curr = base->first;
 	/*
@@ -100,13 +100,13 @@ next_one:
 
 		timer = rb_entry(curr, struct hrtimer, node);
 		tmp = *timer;
-		spin_unlock_irqrestore(&base->cpu_base->lock, flags);
+		raw_spin_unlock_irqrestore(&base->cpu_base->lock, flags);
 
 		print_timer(m, timer, &tmp, i, now);
 		next++;
 		goto next_one;
 	}
-	spin_unlock_irqrestore(&base->cpu_base->lock, flags);
+	raw_spin_unlock_irqrestore(&base->cpu_base->lock, flags);
 }
 
 static void
Index: linux-2.6-tip/kernel/time/timer_stats.c
===================================================================
--- linux-2.6-tip.orig/kernel/time/timer_stats.c
+++ linux-2.6-tip/kernel/time/timer_stats.c
@@ -86,7 +86,7 @@ static DEFINE_SPINLOCK(table_lock);
 /*
  * Per-CPU lookup locks for fast hash lookup:
  */
-static DEFINE_PER_CPU(spinlock_t, lookup_lock);
+static DEFINE_PER_CPU(raw_spinlock_t, lookup_lock);
 
 /*
  * Mutex to serialize state changes with show-stats activities:
@@ -238,7 +238,7 @@ void timer_stats_update_stats(void *time
 	/*
 	 * It doesnt matter which lock we take:
 	 */
-	spinlock_t *lock;
+	raw_spinlock_t *lock;
 	struct entry *entry, input;
 	unsigned long flags;
 
@@ -253,7 +253,7 @@ void timer_stats_update_stats(void *time
 	input.pid = pid;
 	input.timer_flag = timer_flag;
 
-	spin_lock_irqsave(lock, flags);
+	raw_spin_lock_irqsave(lock, flags);
 	if (!timer_stats_active)
 		goto out_unlock;
 
@@ -264,7 +264,7 @@ void timer_stats_update_stats(void *time
 		atomic_inc(&overflow_count);
 
  out_unlock:
-	spin_unlock_irqrestore(lock, flags);
+	raw_spin_unlock_irqrestore(lock, flags);
 }
 
 static void print_name_offset(struct seq_file *m, unsigned long addr)
@@ -348,9 +348,9 @@ static void sync_access(void)
 	int cpu;
 
 	for_each_online_cpu(cpu) {
-		spin_lock_irqsave(&per_cpu(lookup_lock, cpu), flags);
+		raw_spin_lock_irqsave(&per_cpu(lookup_lock, cpu), flags);
 		/* nothing */
-		spin_unlock_irqrestore(&per_cpu(lookup_lock, cpu), flags);
+		raw_spin_unlock_irqrestore(&per_cpu(lookup_lock, cpu), flags);
 	}
 }
 
@@ -408,7 +408,7 @@ void __init init_timer_stats(void)
 	int cpu;
 
 	for_each_possible_cpu(cpu)
-		spin_lock_init(&per_cpu(lookup_lock, cpu));
+		raw_spin_lock_init(&per_cpu(lookup_lock, cpu));
 }
 
 static int __init init_tstats_procfs(void)


