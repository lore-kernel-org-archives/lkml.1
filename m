Return-Path: <linux-kernel-owner+w=401wt.eu-S1754546Ab0A0NRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546Ab0A0NRi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 08:17:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754430Ab0A0NRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 08:17:36 -0500
Received: from hera.kernel.org ([140.211.167.34]:60543 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754228Ab0A0NRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 08:17:31 -0500
Date: Wed, 27 Jan 2010 13:16:44 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, stable@kernel.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, stable@kernel.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Reimplement frequency driven sampling
Message-ID: <tip-abd50713944c8ea9e0af5b7bffa0aacae21cc91a@git.kernel.org>
Git-Commit-ID: abd50713944c8ea9e0af5b7bffa0aacae21cc91a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 27 Jan 2010 13:16:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  abd50713944c8ea9e0af5b7bffa0aacae21cc91a
Gitweb:     http://git.kernel.org/tip/abd50713944c8ea9e0af5b7bffa0aacae21cc91a
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 26 Jan 2010 18:50:16 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 27 Jan 2010 08:39:33 +0100

perf: Reimplement frequency driven sampling

There was a bug in the old period code that caused intel_pmu_enable_all()
or native_write_msr_safe() to show up quite high in the profiles.

In staring at that code it made my head hurt, so I rewrote it in a
hopefully simpler fashion. Its now fully symetric between tick and
overflow driven adjustments and uses less data to boot.

The only complication is that it basically wants to do a u128 division.
The code approximates that in a rather simple truncate until it fits
fashion, taking care to balance the terms while truncating.

This version does not generate that sampling artefact.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Cc: <stable@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/perf_event.h |    5 +-
 kernel/perf_event.c        |  132 ++++++++++++++++++++++++++++++-------------
 2 files changed, 94 insertions(+), 43 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index c6f812e..72b2615 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -498,9 +498,8 @@ struct hw_perf_event {
 	atomic64_t			period_left;
 	u64				interrupts;
 
-	u64				freq_count;
-	u64				freq_interrupts;
-	u64				freq_stamp;
+	u64				freq_time_stamp;
+	u64				freq_count_stamp;
 #endif
 };
 
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index edc46b9..251fb95 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1423,14 +1423,83 @@ void perf_event_task_sched_in(struct task_struct *task)
 
 static void perf_log_throttle(struct perf_event *event, int enable);
 
-static void perf_adjust_period(struct perf_event *event, u64 events)
+static u64 perf_calculate_period(struct perf_event *event, u64 nsec, u64 count)
+{
+	u64 frequency = event->attr.sample_freq;
+	u64 sec = NSEC_PER_SEC;
+	u64 divisor, dividend;
+
+	int count_fls, nsec_fls, frequency_fls, sec_fls;
+
+	count_fls = fls64(count);
+	nsec_fls = fls64(nsec);
+	frequency_fls = fls64(frequency);
+	sec_fls = 30;
+
+	/*
+	 * We got @count in @nsec, with a target of sample_freq HZ
+	 * the target period becomes:
+	 *
+	 *             @count * 10^9
+	 * period = -------------------
+	 *          @nsec * sample_freq
+	 *
+	 */
+
+	/*
+	 * Reduce accuracy by one bit such that @a and @b converge
+	 * to a similar magnitude.
+	 */
+#define REDUCE_FLS(a, b) 		\
+do {					\
+	if (a##_fls > b##_fls) {	\
+		a >>= 1;		\
+		a##_fls--;		\
+	} else {			\
+		b >>= 1;		\
+		b##_fls--;		\
+	}				\
+} while (0)
+
+	/*
+	 * Reduce accuracy until either term fits in a u64, then proceed with
+	 * the other, so that finally we can do a u64/u64 division.
+	 */
+	while (count_fls + sec_fls > 64 && nsec_fls + frequency_fls > 64) {
+		REDUCE_FLS(nsec, frequency);
+		REDUCE_FLS(sec, count);
+	}
+
+	if (count_fls + sec_fls > 64) {
+		divisor = nsec * frequency;
+
+		while (count_fls + sec_fls > 64) {
+			REDUCE_FLS(count, sec);
+			divisor >>= 1;
+		}
+
+		dividend = count * sec;
+	} else {
+		dividend = count * sec;
+
+		while (nsec_fls + frequency_fls > 64) {
+			REDUCE_FLS(nsec, frequency);
+			dividend >>= 1;
+		}
+
+		divisor = nsec * frequency;
+	}
+
+	return div64_u64(dividend, divisor);
+}
+
+static void perf_adjust_period(struct perf_event *event, u64 nsec, u64 count)
 {
 	struct hw_perf_event *hwc = &event->hw;
 	u64 period, sample_period;
 	s64 delta;
 
-	events *= hwc->sample_period;
-	period = div64_u64(events, event->attr.sample_freq);
+	period = perf_calculate_period(event, nsec, count);
 
 	delta = (s64)(period - hwc->sample_period);
 	delta = (delta + 7) / 8; /* low pass filter */
@@ -1441,13 +1510,22 @@ static void perf_adjust_period(struct perf_event *event, u64 events)
 		sample_period = 1;
 
 	hwc->sample_period = sample_period;
+
+	if (atomic64_read(&hwc->period_left) > 8*sample_period) {
+		perf_disable();
+		event->pmu->disable(event);
+		atomic64_set(&hwc->period_left, 0);
+		event->pmu->enable(event);
+		perf_enable();
+	}
 }
 
 static void perf_ctx_adjust_freq(struct perf_event_context *ctx)
 {
 	struct perf_event *event;
 	struct hw_perf_event *hwc;
-	u64 interrupts, freq;
+	u64 interrupts, now;
+	s64 delta;
 
 	raw_spin_lock(&ctx->lock);
 	list_for_each_entry_rcu(event, &ctx->event_list, event_entry) {
@@ -1468,44 +1546,18 @@ static void perf_ctx_adjust_freq(struct perf_event_context *ctx)
 		if (interrupts == MAX_INTERRUPTS) {
 			perf_log_throttle(event, 1);
 			event->pmu->unthrottle(event);
-			interrupts = 2*sysctl_perf_event_sample_rate/HZ;
 		}
 
 		if (!event->attr.freq || !event->attr.sample_freq)
 			continue;
 
-		/*
-		 * if the specified freq < HZ then we need to skip ticks
-		 */
-		if (event->attr.sample_freq < HZ) {
-			freq = event->attr.sample_freq;
-
-			hwc->freq_count += freq;
-			hwc->freq_interrupts += interrupts;
-
-			if (hwc->freq_count < HZ)
-				continue;
-
-			interrupts = hwc->freq_interrupts;
-			hwc->freq_interrupts = 0;
-			hwc->freq_count -= HZ;
-		} else
-			freq = HZ;
-
-		perf_adjust_period(event, freq * interrupts);
+		event->pmu->read(event);
+		now = atomic64_read(&event->count);
+		delta = now - hwc->freq_count_stamp;
+		hwc->freq_count_stamp = now;
 
-		/*
-		 * In order to avoid being stalled by an (accidental) huge
-		 * sample period, force reset the sample period if we didn't
-		 * get any events in this freq period.
-		 */
-		if (!interrupts) {
-			perf_disable();
-			event->pmu->disable(event);
-			atomic64_set(&hwc->period_left, 0);
-			event->pmu->enable(event);
-			perf_enable();
-		}
+		if (delta > 0)
+			perf_adjust_period(event, TICK_NSEC, delta);
 	}
 	raw_spin_unlock(&ctx->lock);
 }
@@ -3768,12 +3820,12 @@ static int __perf_event_overflow(struct perf_event *event, int nmi,
 
 	if (event->attr.freq) {
 		u64 now = perf_clock();
-		s64 delta = now - hwc->freq_stamp;
+		s64 delta = now - hwc->freq_time_stamp;
 
-		hwc->freq_stamp = now;
+		hwc->freq_time_stamp = now;
 
-		if (delta > 0 && delta < TICK_NSEC)
-			perf_adjust_period(event, NSEC_PER_SEC / (int)delta);
+		if (delta > 0 && delta < 2*TICK_NSEC)
+			perf_adjust_period(event, delta, hwc->last_period);
 	}
 
 	/*
