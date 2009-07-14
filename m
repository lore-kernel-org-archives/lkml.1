Return-Path: <linux-kernel-owner+w=401wt.eu-S1755184AbZGNP4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184AbZGNP4o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 11:56:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754800AbZGNP4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 11:56:43 -0400
Received: from www.tglx.de ([62.245.132.106]:60345 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752599AbZGNP4m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 11:56:42 -0400
Date: Tue, 14 Jul 2009 17:56:02 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] timer fixes for 2.6.31
Message-ID: <alpine.LFD.2.00.0907141755210.2777@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-fixes-for-linus

Thanks,

	tglx

------------------>
Heiko Carstens (1):
      timer stats: fix quick check optimization

Thomas Gleixner (2):
      hrtimer: migration: do not check expiry time on current CPU
      hrtimer: Fix migration expiry check


 include/linux/clockchips.h |    9 ----
 include/linux/hrtimer.h    |    2 +-
 kernel/hrtimer.c           |  110 +++++++++++++++++++++++++------------------
 kernel/time/clockevents.c  |   11 ----
 4 files changed, 65 insertions(+), 67 deletions(-)

diff --git a/include/linux/clockchips.h b/include/linux/clockchips.h
index 20a100f..3a1dbba 100644
--- a/include/linux/clockchips.h
+++ b/include/linux/clockchips.h
@@ -143,12 +143,3 @@ extern void clockevents_notify(unsigned long reason, void *arg);
 #endif
 
 #endif
-
-#ifdef CONFIG_GENERIC_CLOCKEVENTS
-extern ktime_t clockevents_get_next_event(int cpu);
-#else
-static inline ktime_t clockevents_get_next_event(int cpu)
-{
-	return (ktime_t) { .tv64 = KTIME_MAX };
-}
-#endif
diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 54648e6..4759917 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -448,7 +448,7 @@ extern void timer_stats_update_stats(void *timer, pid_t pid, void *startf,
 
 static inline void timer_stats_account_hrtimer(struct hrtimer *timer)
 {
-	if (likely(!timer->start_pid))
+	if (likely(!timer->start_site))
 		return;
 	timer_stats_update_stats(timer, timer->start_pid, timer->start_site,
 				 timer->function, timer->start_comm, 0);
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 9002958..49da79a 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -191,6 +191,46 @@ struct hrtimer_clock_base *lock_hrtimer_base(const struct hrtimer *timer,
 	}
 }
 
+
+/*
+ * Get the preferred target CPU for NOHZ
+ */
+static int hrtimer_get_target(int this_cpu, int pinned)
+{
+#ifdef CONFIG_NO_HZ
+	if (!pinned && get_sysctl_timer_migration() && idle_cpu(this_cpu)) {
+		int preferred_cpu = get_nohz_load_balancer();
+
+		if (preferred_cpu >= 0)
+			return preferred_cpu;
+	}
+#endif
+	return this_cpu;
+}
+
+/*
+ * With HIGHRES=y we do not migrate the timer when it is expiring
+ * before the next event on the target cpu because we cannot reprogram
+ * the target cpu hardware and we would cause it to fire late.
+ *
+ * Called with cpu_base->lock of target cpu held.
+ */
+static int
+hrtimer_check_target(struct hrtimer *timer, struct hrtimer_clock_base *new_base)
+{
+#ifdef CONFIG_HIGH_RES_TIMERS
+	ktime_t expires;
+
+	if (!new_base->cpu_base->hres_active)
+		return 0;
+
+	expires = ktime_sub(hrtimer_get_expires(timer), new_base->offset);
+	return expires.tv64 <= new_base->cpu_base->expires_next.tv64;
+#else
+	return 0;
+#endif
+}
+
 /*
  * Switch the timer base to the current CPU when possible.
  */
@@ -200,16 +240,8 @@ switch_hrtimer_base(struct hrtimer *timer, struct hrtimer_clock_base *base,
 {
 	struct hrtimer_clock_base *new_base;
 	struct hrtimer_cpu_base *new_cpu_base;
-	int cpu, preferred_cpu = -1;
-
-	cpu = smp_processor_id();
-#if defined(CONFIG_NO_HZ) && defined(CONFIG_SMP)
-	if (!pinned && get_sysctl_timer_migration() && idle_cpu(cpu)) {
-		preferred_cpu = get_nohz_load_balancer();
-		if (preferred_cpu >= 0)
-			cpu = preferred_cpu;
-	}
-#endif
+	int this_cpu = smp_processor_id();
+	int cpu = hrtimer_get_target(this_cpu, pinned);
 
 again:
 	new_cpu_base = &per_cpu(hrtimer_bases, cpu);
@@ -217,7 +249,7 @@ again:
 
 	if (base != new_base) {
 		/*
-		 * We are trying to schedule the timer on the local CPU.
+		 * We are trying to move timer to new_base.
 		 * However we can't change timer's base while it is running,
 		 * so we keep it on the same CPU. No hassle vs. reprogramming
 		 * the event source in the high resolution case. The softirq
@@ -233,38 +265,12 @@ again:
 		spin_unlock(&base->cpu_base->lock);
 		spin_lock(&new_base->cpu_base->lock);
 
-		/* Optimized away for NOHZ=n SMP=n */
-		if (cpu == preferred_cpu) {
-			/* Calculate clock monotonic expiry time */
-#ifdef CONFIG_HIGH_RES_TIMERS
-			ktime_t expires = ktime_sub(hrtimer_get_expires(timer),
-							new_base->offset);
-#else
-			ktime_t expires = hrtimer_get_expires(timer);
-#endif
-
-			/*
-			 * Get the next event on target cpu from the
-			 * clock events layer.
-			 * This covers the highres=off nohz=on case as well.
-			 */
-			ktime_t next = clockevents_get_next_event(cpu);
-
-			ktime_t delta = ktime_sub(expires, next);
-
-			/*
-			 * We do not migrate the timer when it is expiring
-			 * before the next event on the target cpu because
-			 * we cannot reprogram the target cpu hardware and
-			 * we would cause it to fire late.
-			 */
-			if (delta.tv64 < 0) {
-				cpu = smp_processor_id();
-				spin_unlock(&new_base->cpu_base->lock);
-				spin_lock(&base->cpu_base->lock);
-				timer->base = base;
-				goto again;
-			}
+		if (cpu != this_cpu && hrtimer_check_target(timer, new_base)) {
+			cpu = this_cpu;
+			spin_unlock(&new_base->cpu_base->lock);
+			spin_lock(&base->cpu_base->lock);
+			timer->base = base;
+			goto again;
 		}
 		timer->base = new_base;
 	}
@@ -1276,14 +1282,22 @@ void hrtimer_interrupt(struct clock_event_device *dev)
 
 	expires_next.tv64 = KTIME_MAX;
 
+	spin_lock(&cpu_base->lock);
+	/*
+	 * We set expires_next to KTIME_MAX here with cpu_base->lock
+	 * held to prevent that a timer is enqueued in our queue via
+	 * the migration code. This does not affect enqueueing of
+	 * timers which run their callback and need to be requeued on
+	 * this CPU.
+	 */
+	cpu_base->expires_next.tv64 = KTIME_MAX;
+
 	base = cpu_base->clock_base;
 
 	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++) {
 		ktime_t basenow;
 		struct rb_node *node;
 
-		spin_lock(&cpu_base->lock);
-
 		basenow = ktime_add(now, base->offset);
 
 		while ((node = base->first)) {
@@ -1316,11 +1330,15 @@ void hrtimer_interrupt(struct clock_event_device *dev)
 
 			__run_hrtimer(timer);
 		}
-		spin_unlock(&cpu_base->lock);
 		base++;
 	}
 
+	/*
+	 * Store the new expiry value so the migration code can verify
+	 * against it.
+	 */
 	cpu_base->expires_next = expires_next;
+	spin_unlock(&cpu_base->lock);
 
 	/* Reprogramming necessary ? */
 	if (expires_next.tv64 != KTIME_MAX) {
diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index 1ad6dd4..a6dcd67 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -254,15 +254,4 @@ void clockevents_notify(unsigned long reason, void *arg)
 	spin_unlock(&clockevents_lock);
 }
 EXPORT_SYMBOL_GPL(clockevents_notify);
-
-ktime_t clockevents_get_next_event(int cpu)
-{
-	struct tick_device *td;
-	struct clock_event_device *dev;
-
-	td = &per_cpu(tick_cpu_device, cpu);
-	dev = td->evtdev;
-
-	return dev->next_event;
-}
 #endif
