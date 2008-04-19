Return-Path: <linux-kernel-owner+w=401wt.eu-S1761998AbYDSUwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761998AbYDSUwT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 16:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755817AbYDSUwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 16:52:08 -0400
Received: from www.tglx.de ([62.245.132.106]:56993 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755499AbYDSUwG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 16:52:06 -0400
Date: Sat, 19 Apr 2008 22:51:50 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT pull] (hr)timer updates feed from Andrew
Message-ID: <alpine.LFD.1.10.0804192247580.3261@apollo.tec.linutronix.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the (hr)timer updates which came via Andrew from:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/tglx/linux-2.6-hrt.git master

NB: John's time race window patch touches ia64/x86/ppc as those are
the affected architectures of the vsyscall race.

Thanks,

	tglx

---
Dave Young (1):
      jiffies: add time_is_after_jiffies and others which compare with jiffies

Dimitri Sivanich (1):
      hrtimer: reduce calls to hrtimer_get_softirq_time()

Glauber Costa (1):
      clockevents: fix typo in tick-broadcast.c

John Stultz (1):
      time: close small window for vsyscall time inconsistencies

Thomas Gleixner (1):
      hrtimer: optimize the softirq time optimization

 arch/ia64/kernel/time.c       |   19 +++++++++---
 arch/powerpc/kernel/time.c    |   23 +++++++++++----
 arch/x86/kernel/vsyscall_64.c |   18 +++++++++--
 include/linux/clocksource.h   |   10 ++++++
 include/linux/jiffies.h       |   16 ++++++++++
 kernel/hrtimer.c              |   63 ++++++++++++++++++++---------------------
 kernel/time/tick-broadcast.c  |    2 +-
 kernel/time/timekeeping.c     |    8 ++++-
 8 files changed, 110 insertions(+), 49 deletions(-)
diff --git a/arch/ia64/kernel/time.c b/arch/ia64/kernel/time.c
index 48e15a5..efd64b6 100644
--- a/arch/ia64/kernel/time.c
+++ b/arch/ia64/kernel/time.c
@@ -427,11 +427,22 @@ void update_vsyscall_tz(void)
 {
 }
 
-void update_vsyscall(struct timespec *wall, struct clocksource *c)
+/* update_vsyscall_lock/unlock:
+ *    methods for timekeeping core to block vsyscalls during update
+ */
+void update_vsyscall_lock(unsigned long *flags)
 {
-        unsigned long flags;
+	write_seqlock_irqsave(&fsyscall_gtod_data.lock, *flags);
+}
 
-        write_seqlock_irqsave(&fsyscall_gtod_data.lock, flags);
+void update_vsyscall_unlock(unsigned long *flags)
+{
+	write_sequnlock_irqrestore(&fsyscall_gtod_data.lock, *flags);
+}
+
+/* Assumes fsyscall_gtod_data.lock has been taken via update_vsyscall_lock() */
+void update_vsyscall(struct timespec *wall, struct clocksource *c)
+{
 
         /* copy fsyscall clock data */
         fsyscall_gtod_data.clk_mask = c->mask;
@@ -453,7 +464,5 @@ void update_vsyscall(struct timespec *wall, struct clocksource *c)
 		fsyscall_gtod_data.monotonic_time.tv_nsec -= NSEC_PER_SEC;
 		fsyscall_gtod_data.monotonic_time.tv_sec++;
 	}
-
-        write_sequnlock_irqrestore(&fsyscall_gtod_data.lock, flags);
 }
 
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 3b26fbd..c51d2f8 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -456,8 +456,6 @@ static inline void update_gtod(u64 new_tb_stamp, u64 new_stamp_xsec,
 	vdso_data->tb_to_xs = new_tb_to_xs;
 	vdso_data->wtom_clock_sec = wall_to_monotonic.tv_sec;
 	vdso_data->wtom_clock_nsec = wall_to_monotonic.tv_nsec;
-	smp_wmb();
-	++(vdso_data->tb_update_count);
 }
 
 #ifdef CONFIG_SMP
@@ -801,6 +799,23 @@ static cycle_t timebase_read(void)
 	return (cycle_t)get_tb();
 }
 
+/* update_vsyscall_lock/unlock:
+ *    methods for timekeeping core to block vsyscalls during update
+ */
+void update_vsyscall_lock(unsigned long *flags)
+{
+	/* Make userspace gettimeofday spin until we're done. */
+	++vdso_data->tb_update_count;
+	smp_mb();
+}
+
+void update_vsyscall_unlock(unsigned long *flags)
+{
+	smp_wmb();
+	++(vdso_data->tb_update_count);
+}
+
+/* Assumes update_vsyscall_lock() has been called */
 void update_vsyscall(struct timespec *wall_time, struct clocksource *clock)
 {
 	u64 t2x, stamp_xsec;
@@ -808,10 +823,6 @@ void update_vsyscall(struct timespec *wall_time, struct clocksource *clock)
 	if (clock != &clocksource_timebase)
 		return;
 
-	/* Make userspace gettimeofday spin until we're done. */
-	++vdso_data->tb_update_count;
-	smp_mb();
-
 	/* XXX this assumes clock->shift == 22 */
 	/* 4611686018 ~= 2^(20+64-22) / 1e9 */
 	t2x = (u64) clock->mult * 4611686018ULL;
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index edff4c9..8a2eb77 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -69,11 +69,22 @@ void update_vsyscall_tz(void)
 	write_sequnlock_irqrestore(&vsyscall_gtod_data.lock, flags);
 }
 
-void update_vsyscall(struct timespec *wall_time, struct clocksource *clock)
+/* update_vsyscall_lock/unlock:
+ *    methods for timekeeping core to block vsyscalls during update
+ */
+void update_vsyscall_lock(unsigned long *flags)
 {
-	unsigned long flags;
+	write_seqlock_irqsave(&vsyscall_gtod_data.lock, *flags);
+}
 
-	write_seqlock_irqsave(&vsyscall_gtod_data.lock, flags);
+void update_vsyscall_unlock(unsigned long *flags)
+{
+	write_sequnlock_irqrestore(&vsyscall_gtod_data.lock, *flags);
+}
+
+/* Assumes vsyscall_gtod_data.lock has been taken via update_vsyscall_lock() */
+void update_vsyscall(struct timespec *wall_time, struct clocksource *clock)
+{
 	/* copy vsyscall data */
 	vsyscall_gtod_data.clock.vread = clock->vread;
 	vsyscall_gtod_data.clock.cycle_last = clock->cycle_last;
@@ -83,7 +94,6 @@ void update_vsyscall(struct timespec *wall_time, struct clocksource *clock)
 	vsyscall_gtod_data.wall_time_sec = wall_time->tv_sec;
 	vsyscall_gtod_data.wall_time_nsec = wall_time->tv_nsec;
 	vsyscall_gtod_data.wall_to_monotonic = wall_to_monotonic;
-	write_sequnlock_irqrestore(&vsyscall_gtod_data.lock, flags);
 }
 
 /* RED-PEN may want to readd seq locking, but then the variable should be
diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 3509447..3677ef7 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -222,9 +222,19 @@ extern void clocksource_change_rating(struct clocksource *cs, int rating);
 extern void clocksource_resume(void);
 
 #ifdef CONFIG_GENERIC_TIME_VSYSCALL
+void update_vsyscall_lock(unsigned long *flags);
+void update_vsyscall_unlock(unsigned long *flags);
 extern void update_vsyscall(struct timespec *ts, struct clocksource *c);
 extern void update_vsyscall_tz(void);
 #else
+static inline void update_vsyscall_lock(unsigned long *flags)
+{
+}
+
+static inline void update_vsyscall_unlock(unsigned long *flags)
+{
+}
+
 static inline void update_vsyscall(struct timespec *ts, struct clocksource *c)
 {
 }
diff --git a/include/linux/jiffies.h b/include/linux/jiffies.h
index e0b5b68..e377e34 100644
--- a/include/linux/jiffies.h
+++ b/include/linux/jiffies.h
@@ -135,6 +135,22 @@ static inline u64 get_jiffies_64(void)
 #define time_before_eq64(a,b)	time_after_eq64(b,a)
 
 /*
+ * These four macros compare jiffies and 'a' for convenience.
+ */
+
+/* time_is_before_jiffies(a) return true if a is before jiffies */
+#define time_is_before_jiffies(a) time_after(jiffies, a)
+
+/* time_is_after_jiffies(a) return true if a is after jiffies */
+#define time_is_after_jiffies(a) time_before(jiffies, a)
+
+/* time_is_before_eq_jiffies(a) return true if a is before or equal to jiffies*/
+#define time_is_before_eq_jiffies(a) time_after_eq(jiffies, a)
+
+/* time_is_after_eq_jiffies(a) return true if a is after or equal to jiffies*/
+#define time_is_after_eq_jiffies(a) time_before_eq(jiffies, a)
+
+/*
  * Have the 32 bit jiffies value wrap 5 minutes after boot
  * so jiffies wrap bugs show up earlier.
  */
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index c642ef7..f78777a 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1238,51 +1238,50 @@ void hrtimer_run_pending(void)
 /*
  * Called from hardirq context every jiffy
  */
-static inline void run_hrtimer_queue(struct hrtimer_cpu_base *cpu_base,
-				     int index)
+void hrtimer_run_queues(void)
 {
 	struct rb_node *node;
-	struct hrtimer_clock_base *base = &cpu_base->clock_base[index];
+	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
+	struct hrtimer_clock_base *base;
+	int index, gettime = 1;
 
-	if (!base->first)
+	if (hrtimer_hres_active())
 		return;
 
-	if (base->get_softirq_time)
-		base->softirq_time = base->get_softirq_time();
-
-	spin_lock(&cpu_base->lock);
+	for (index = 0; index < HRTIMER_MAX_CLOCK_BASES; index++) {
+		base = &cpu_base->clock_base[index];
 
-	while ((node = base->first)) {
-		struct hrtimer *timer;
-
-		timer = rb_entry(node, struct hrtimer, node);
-		if (base->softirq_time.tv64 <= timer->expires.tv64)
-			break;
-
-		if (timer->cb_mode == HRTIMER_CB_SOFTIRQ) {
-			__remove_hrtimer(timer, base, HRTIMER_STATE_PENDING, 0);
-			list_add_tail(&timer->cb_entry,
-					&base->cpu_base->cb_pending);
+		if (!base->first)
 			continue;
+
+		if (base->get_softirq_time)
+			base->softirq_time = base->get_softirq_time();
+		else if (gettime) {
+			hrtimer_get_softirq_time(cpu_base);
+			gettime = 0;
 		}
 
-		__run_hrtimer(timer);
-	}
-	spin_unlock(&cpu_base->lock);
-}
+		spin_lock(&cpu_base->lock);
 
-void hrtimer_run_queues(void)
-{
-	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
-	int i;
+		while ((node = base->first)) {
+			struct hrtimer *timer;
 
-	if (hrtimer_hres_active())
-		return;
+			timer = rb_entry(node, struct hrtimer, node);
+			if (base->softirq_time.tv64 <= timer->expires.tv64)
+				break;
 
-	hrtimer_get_softirq_time(cpu_base);
+			if (timer->cb_mode == HRTIMER_CB_SOFTIRQ) {
+				__remove_hrtimer(timer, base,
+					HRTIMER_STATE_PENDING, 0);
+				list_add_tail(&timer->cb_entry,
+					&base->cpu_base->cb_pending);
+				continue;
+			}
 
-	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++)
-		run_hrtimer_queue(cpu_base, i);
+			__run_hrtimer(timer);
+		}
+		spin_unlock(&cpu_base->lock);
+	}
 }
 
 /*
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index fdfa0c7..57a1f02 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -262,7 +262,7 @@ out:
 void tick_broadcast_on_off(unsigned long reason, int *oncpu)
 {
 	if (!cpu_isset(*oncpu, cpu_online_map))
-		printk(KERN_ERR "tick-braodcast: ignoring broadcast for "
+		printk(KERN_ERR "tick-broadcast: ignoring broadcast for "
 		       "offline CPU #%d\n", *oncpu);
 	else
 		smp_call_function_single(*oncpu, tick_do_broadcast_on_off,
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index a3fa587..47ca292 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -129,7 +129,7 @@ EXPORT_SYMBOL(do_gettimeofday);
  */
 int do_settimeofday(struct timespec *tv)
 {
-	unsigned long flags;
+	unsigned long flags, vflags;
 	time_t wtm_sec, sec = tv->tv_sec;
 	long wtm_nsec, nsec = tv->tv_nsec;
 
@@ -137,6 +137,7 @@ int do_settimeofday(struct timespec *tv)
 		return -EINVAL;
 
 	write_seqlock_irqsave(&xtime_lock, flags);
+	update_vsyscall_lock(&vflags);
 
 	nsec -= __get_nsec_offset();
 
@@ -152,6 +153,7 @@ int do_settimeofday(struct timespec *tv)
 
 	update_vsyscall(&xtime, clock);
 
+	update_vsyscall_unlock(&vflags);
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 
 	/* signal hrtimers about time change */
@@ -442,12 +444,15 @@ static void clocksource_adjust(s64 offset)
  */
 void update_wall_time(void)
 {
+	unsigned long flags;
 	cycle_t offset;
 
 	/* Make sure we're fully resumed: */
 	if (unlikely(timekeeping_suspended))
 		return;
 
+	/* grab the vsyscall lock to block vsyscalls during update */
+	update_vsyscall_lock(&flags);
 #ifdef CONFIG_GENERIC_TIME
 	offset = (clocksource_read(clock) - clock->cycle_last) & clock->mask;
 #else
@@ -487,6 +492,7 @@ void update_wall_time(void)
 	/* check to see if there is a new clocksource to use */
 	change_clocksource();
 	update_vsyscall(&xtime, clock);
+	update_vsyscall_unlock(&flags);
 }
 
 /**
