Return-Path: <linux-kernel-owner+w=401wt.eu-S1757974AbZIRTT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757974AbZIRTT5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 15:19:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752370AbZIRTTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 15:19:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:33358 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756517AbZIRTTp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 15:19:45 -0400
Date: Fri, 18 Sep 2009 19:19:07 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perfcounters/core] sched_clock: Make it NMI safe
Message-ID: <tip-def0a9b2573e00ab0b486cb5382625203ab4c4a6@git.kernel.org>
Git-Commit-ID: def0a9b2573e00ab0b486cb5382625203ab4c4a6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 18 Sep 2009 19:19:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  def0a9b2573e00ab0b486cb5382625203ab4c4a6
Gitweb:     http://git.kernel.org/tip/def0a9b2573e00ab0b486cb5382625203ab4c4a6
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 18 Sep 2009 20:14:01 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 18 Sep 2009 20:47:30 +0200

sched_clock: Make it NMI safe

Arjan complained about the suckyness of TSC on modern machines, and
asked if we could do something about that for PERF_SAMPLE_TIME.

Make cpu_clock() NMI safe by removing the spinlock and using
cmpxchg. This also makes it smaller and more robust.

Affects architectures that use HAVE_UNSTABLE_SCHED_CLOCK, i.e. IA64
and x86.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |    9 +--
 kernel/sched_clock.c  |  122 +++++++++++++++++++++---------------------------
 2 files changed, 56 insertions(+), 75 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 6944bd5..06d233a 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -2955,10 +2955,7 @@ void perf_prepare_sample(struct perf_event_header *header,
 	}
 
 	if (sample_type & PERF_SAMPLE_TIME) {
-		/*
-		 * Maybe do better on x86 and provide cpu_clock_nmi()
-		 */
-		data->time = sched_clock();
+		data->time = perf_clock();
 
 		header->size += sizeof(data->time);
 	}
@@ -3488,7 +3485,7 @@ static void perf_log_throttle(struct perf_counter *counter, int enable)
 			.misc = 0,
 			.size = sizeof(throttle_event),
 		},
-		.time		= sched_clock(),
+		.time		= perf_clock(),
 		.id		= primary_counter_id(counter),
 		.stream_id	= counter->id,
 	};
@@ -3540,7 +3537,7 @@ static int __perf_counter_overflow(struct perf_counter *counter, int nmi,
 	}
 
 	if (counter->attr.freq) {
-		u64 now = sched_clock();
+		u64 now = perf_clock();
 		s64 delta = now - hwc->freq_stamp;
 
 		hwc->freq_stamp = now;
diff --git a/kernel/sched_clock.c b/kernel/sched_clock.c
index e1d16c9..ac2e1dc 100644
--- a/kernel/sched_clock.c
+++ b/kernel/sched_clock.c
@@ -48,13 +48,6 @@ static __read_mostly int sched_clock_running;
 __read_mostly int sched_clock_stable;
 
 struct sched_clock_data {
-	/*
-	 * Raw spinlock - this is a special case: this might be called
-	 * from within instrumentation code so we dont want to do any
-	 * instrumentation ourselves.
-	 */
-	raw_spinlock_t		lock;
-
 	u64			tick_raw;
 	u64			tick_gtod;
 	u64			clock;
@@ -80,7 +73,6 @@ void sched_clock_init(void)
 	for_each_possible_cpu(cpu) {
 		struct sched_clock_data *scd = cpu_sdc(cpu);
 
-		scd->lock = (raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
 		scd->tick_raw = 0;
 		scd->tick_gtod = ktime_now;
 		scd->clock = ktime_now;
@@ -109,14 +101,19 @@ static inline u64 wrap_max(u64 x, u64 y)
  *  - filter out backward motion
  *  - use the GTOD tick value to create a window to filter crazy TSC values
  */
-static u64 __update_sched_clock(struct sched_clock_data *scd, u64 now)
+static u64 sched_clock_local(struct sched_clock_data *scd)
 {
-	s64 delta = now - scd->tick_raw;
-	u64 clock, min_clock, max_clock;
+	u64 now, clock, old_clock, min_clock, max_clock;
+	s64 delta;
 
+again:
+	now = sched_clock();
+	delta = now - scd->tick_raw;
 	if (unlikely(delta < 0))
 		delta = 0;
 
+	old_clock = scd->clock;
+
 	/*
 	 * scd->clock = clamp(scd->tick_gtod + delta,
 	 *		      max(scd->tick_gtod, scd->clock),
@@ -124,84 +121,73 @@ static u64 __update_sched_clock(struct sched_clock_data *scd, u64 now)
 	 */
 
 	clock = scd->tick_gtod + delta;
-	min_clock = wrap_max(scd->tick_gtod, scd->clock);
-	max_clock = wrap_max(scd->clock, scd->tick_gtod + TICK_NSEC);
+	min_clock = wrap_max(scd->tick_gtod, old_clock);
+	max_clock = wrap_max(old_clock, scd->tick_gtod + TICK_NSEC);
 
 	clock = wrap_max(clock, min_clock);
 	clock = wrap_min(clock, max_clock);
 
-	scd->clock = clock;
+	if (cmpxchg(&scd->clock, old_clock, clock) != old_clock)
+		goto again;
 
-	return scd->clock;
+	return clock;
 }
 
-static void lock_double_clock(struct sched_clock_data *data1,
-				struct sched_clock_data *data2)
+static u64 sched_clock_remote(struct sched_clock_data *scd)
 {
-	if (data1 < data2) {
-		__raw_spin_lock(&data1->lock);
-		__raw_spin_lock(&data2->lock);
+	struct sched_clock_data *my_scd = this_scd();
+	u64 this_clock, remote_clock;
+	u64 *ptr, old_val, val;
+
+	sched_clock_local(my_scd);
+again:
+	this_clock = my_scd->clock;
+	remote_clock = scd->clock;
+
+	/*
+	 * Use the opportunity that we have both locks
+	 * taken to couple the two clocks: we take the
+	 * larger time as the latest time for both
+	 * runqueues. (this creates monotonic movement)
+	 */
+	if (likely((s64)(remote_clock - this_clock) < 0)) {
+		ptr = &scd->clock;
+		old_val = remote_clock;
+		val = this_clock;
 	} else {
-		__raw_spin_lock(&data2->lock);
-		__raw_spin_lock(&data1->lock);
+		/*
+		 * Should be rare, but possible:
+		 */
+		ptr = &my_scd->clock;
+		old_val = this_clock;
+		val = remote_clock;
 	}
+
+	if (cmpxchg(ptr, old_val, val) != old_val)
+		goto again;
+
+	return val;
 }
 
 u64 sched_clock_cpu(int cpu)
 {
-	u64 now, clock, this_clock, remote_clock;
 	struct sched_clock_data *scd;
+	u64 clock;
+
+	WARN_ON_ONCE(!irqs_disabled());
 
 	if (sched_clock_stable)
 		return sched_clock();
 
-	scd = cpu_sdc(cpu);
-
-	/*
-	 * Normally this is not called in NMI context - but if it is,
-	 * trying to do any locking here is totally lethal.
-	 */
-	if (unlikely(in_nmi()))
-		return scd->clock;
-
 	if (unlikely(!sched_clock_running))
 		return 0ull;
 
-	WARN_ON_ONCE(!irqs_disabled());
-	now = sched_clock();
-
-	if (cpu != raw_smp_processor_id()) {
-		struct sched_clock_data *my_scd = this_scd();
-
-		lock_double_clock(scd, my_scd);
-
-		this_clock = __update_sched_clock(my_scd, now);
-		remote_clock = scd->clock;
-
-		/*
-		 * Use the opportunity that we have both locks
-		 * taken to couple the two clocks: we take the
-		 * larger time as the latest time for both
-		 * runqueues. (this creates monotonic movement)
-		 */
-		if (likely((s64)(remote_clock - this_clock) < 0)) {
-			clock = this_clock;
-			scd->clock = clock;
-		} else {
-			/*
-			 * Should be rare, but possible:
-			 */
-			clock = remote_clock;
-			my_scd->clock = remote_clock;
-		}
-
-		__raw_spin_unlock(&my_scd->lock);
-	} else {
-		__raw_spin_lock(&scd->lock);
-		clock = __update_sched_clock(scd, now);
-	}
+	scd = cpu_sdc(cpu);
 
-	__raw_spin_unlock(&scd->lock);
+	if (cpu != smp_processor_id())
+		clock = sched_clock_remote(scd);
+	else
+		clock = sched_clock_local(scd);
 
 	return clock;
 }
@@ -223,11 +209,9 @@ void sched_clock_tick(void)
 	now_gtod = ktime_to_ns(ktime_get());
 	now = sched_clock();
 
-	__raw_spin_lock(&scd->lock);
 	scd->tick_raw = now;
 	scd->tick_gtod = now_gtod;
-	__update_sched_clock(scd, now);
-	__raw_spin_unlock(&scd->lock);
+	sched_clock_local(scd);
 }
 
 /*
