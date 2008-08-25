Return-Path: <linux-kernel-owner+w=401wt.eu-S1756031AbYHYRhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031AbYHYRhj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 13:37:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754362AbYHYRhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 13:37:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60782 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754190AbYHYRhP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 13:37:15 -0400
Date: Mon, 25 Aug 2008 19:37:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [git pull] scheduler fixes
Message-ID: <20080825173704.GA6732@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

This has a fix from Peter that is fresh (from earlier today) but i'm 
pushing it because it would be nice to have it in -rc5 and it looks 
fairly safe as well.

Thanks,

	Ingo

------------------>
Peter Zijlstra (1):
      sched_clock: fix cpu_clock()


 kernel/sched_clock.c |   84 ++++++++++++++++++++-----------------------------
 1 files changed, 34 insertions(+), 50 deletions(-)

diff --git a/kernel/sched_clock.c b/kernel/sched_clock.c
index 204991a..e8ab096 100644
--- a/kernel/sched_clock.c
+++ b/kernel/sched_clock.c
@@ -12,19 +12,17 @@
  *
  * Create a semi stable clock from a mixture of other events, including:
  *  - gtod
- *  - jiffies
  *  - sched_clock()
  *  - explicit idle events
  *
  * We use gtod as base and the unstable clock deltas. The deltas are filtered,
- * making it monotonic and keeping it within an expected window.  This window
- * is set up using jiffies.
+ * making it monotonic and keeping it within an expected window.
  *
  * Furthermore, explicit sleep and wakeup hooks allow us to account for time
  * that is otherwise invisible (TSC gets stopped).
  *
  * The clock: sched_clock_cpu() is monotonic per cpu, and should be somewhat
- * consistent between cpus (never more than 1 jiffies difference).
+ * consistent between cpus (never more than 2 jiffies difference).
  */
 #include <linux/sched.h>
 #include <linux/percpu.h>
@@ -54,7 +52,6 @@ struct sched_clock_data {
 	 */
 	raw_spinlock_t		lock;
 
-	unsigned long		tick_jiffies;
 	u64			tick_raw;
 	u64			tick_gtod;
 	u64			clock;
@@ -75,14 +72,12 @@ static inline struct sched_clock_data *cpu_sdc(int cpu)
 void sched_clock_init(void)
 {
 	u64 ktime_now = ktime_to_ns(ktime_get());
-	unsigned long now_jiffies = jiffies;
 	int cpu;
 
 	for_each_possible_cpu(cpu) {
 		struct sched_clock_data *scd = cpu_sdc(cpu);
 
 		scd->lock = (raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
-		scd->tick_jiffies = now_jiffies;
 		scd->tick_raw = 0;
 		scd->tick_gtod = ktime_now;
 		scd->clock = ktime_now;
@@ -92,46 +87,51 @@ void sched_clock_init(void)
 }
 
 /*
+ * min,max except they take wrapping into account
+ */
+
+static inline u64 wrap_min(u64 x, u64 y)
+{
+	return (s64)(x - y) < 0 ? x : y;
+}
+
+static inline u64 wrap_max(u64 x, u64 y)
+{
+	return (s64)(x - y) > 0 ? x : y;
+}
+
+/*
  * update the percpu scd from the raw @now value
  *
  *  - filter out backward motion
- *  - use jiffies to generate a min,max window to clip the raw values
+ *  - use the GTOD tick value to create a window to filter crazy TSC values
  */
 static u64 __update_sched_clock(struct sched_clock_data *scd, u64 now)
 {
-	unsigned long now_jiffies = jiffies;
-	long delta_jiffies = now_jiffies - scd->tick_jiffies;
-	u64 clock = scd->clock;
-	u64 min_clock, max_clock;
 	s64 delta = now - scd->tick_raw;
+	u64 clock, min_clock, max_clock;
 
 	WARN_ON_ONCE(!irqs_disabled());
-	min_clock = scd->tick_gtod + delta_jiffies * TICK_NSEC;
 
-	if (unlikely(delta < 0)) {
-		clock++;
-		goto out;
-	}
+	if (unlikely(delta < 0))
+		delta = 0;
 
-	max_clock = min_clock + TICK_NSEC;
+	/*
+	 * scd->clock = clamp(scd->tick_gtod + delta,
+	 * 		      max(scd->tick_gtod, scd->clock),
+	 * 		      scd->tick_gtod + TICK_NSEC);
+	 */
 
-	if (unlikely(clock + delta > max_clock)) {
-		if (clock < max_clock)
-			clock = max_clock;
-		else
-			clock++;
-	} else {
-		clock += delta;
-	}
+	clock = scd->tick_gtod + delta;
+	min_clock = wrap_max(scd->tick_gtod, scd->clock);
+	max_clock = scd->tick_gtod + TICK_NSEC;
 
- out:
-	if (unlikely(clock < min_clock))
-		clock = min_clock;
+	clock = wrap_max(clock, min_clock);
+	clock = wrap_min(clock, max_clock);
 
-	scd->tick_jiffies = now_jiffies;
 	scd->clock = clock;
 
-	return clock;
+	return scd->clock;
 }
 
 static void lock_double_clock(struct sched_clock_data *data1,
@@ -171,7 +171,7 @@ u64 sched_clock_cpu(int cpu)
 		 * larger time as the latest time for both
 		 * runqueues. (this creates monotonic movement)
 		 */
-		if (likely(remote_clock < this_clock)) {
+		if (likely((s64)(remote_clock - this_clock) < 0)) {
 			clock = this_clock;
 			scd->clock = clock;
 		} else {
@@ -207,14 +207,9 @@ void sched_clock_tick(void)
 	now = sched_clock();
 
 	__raw_spin_lock(&scd->lock);
-	__update_sched_clock(scd, now);
-	/*
-	 * update tick_gtod after __update_sched_clock() because that will
-	 * already observe 1 new jiffy; adding a new tick_gtod to that would
-	 * increase the clock 2 jiffies.
-	 */
 	scd->tick_raw = now;
 	scd->tick_gtod = now_gtod;
+	__update_sched_clock(scd, now);
 	__raw_spin_unlock(&scd->lock);
 }
 
@@ -232,18 +227,7 @@ EXPORT_SYMBOL_GPL(sched_clock_idle_sleep_event);
  */
 void sched_clock_idle_wakeup_event(u64 delta_ns)
 {
-	struct sched_clock_data *scd = this_scd();
-
-	/*
-	 * Override the previous timestamp and ignore all
-	 * sched_clock() deltas that occured while we idled,
-	 * and use the PM-provided delta_ns to advance the
-	 * rq clock:
-	 */
-	__raw_spin_lock(&scd->lock);
-	scd->clock += delta_ns;
-	__raw_spin_unlock(&scd->lock);
-
+	sched_clock_tick();
 	touch_softlockup_watchdog();
 }
 EXPORT_SYMBOL_GPL(sched_clock_idle_wakeup_event);
