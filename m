Return-Path: <linux-kernel-owner+w=401wt.eu-S1753941AbZFBURO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941AbZFBURO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 16:17:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753256AbZFBUQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 16:16:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:59477 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754219AbZFBUQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 16:16:56 -0400
Date: Tue, 2 Jun 2009 20:16:16 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       eranian@googlemail.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, eranian@googlemail.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, mtosatti@redhat.com,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter: Rename various fields
Message-ID: <tip-b23f3325ed465f1bd914384884269af0d106778c@git.kernel.org>
Git-Commit-ID: b23f3325ed465f1bd914384884269af0d106778c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 02 Jun 2009 20:16:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b23f3325ed465f1bd914384884269af0d106778c
Gitweb:     http://git.kernel.org/tip/b23f3325ed465f1bd914384884269af0d106778c
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 2 Jun 2009 15:13:03 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 2 Jun 2009 21:45:30 +0200

perf_counter: Rename various fields

A few renames:

  s/irq_period/sample_period/
  s/irq_freq/sample_freq/
  s/PERF_RECORD_/PERF_SAMPLE_/
  s/record_type/sample_type/

And change both the new sample_type and read_format to u64.

Reported-by: Stephane Eranian <eranian@googlemail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/powerpc/kernel/perf_counter.c |   12 ++--
 arch/x86/kernel/cpu/perf_counter.c |    8 ++--
 include/linux/perf_counter.h       |   32 ++++++------
 kernel/perf_counter.c              |  104 ++++++++++++++++++------------------
 4 files changed, 78 insertions(+), 78 deletions(-)

diff --git a/arch/powerpc/kernel/perf_counter.c b/arch/powerpc/kernel/perf_counter.c
index f96d55f..c963332 100644
--- a/arch/powerpc/kernel/perf_counter.c
+++ b/arch/powerpc/kernel/perf_counter.c
@@ -535,7 +535,7 @@ void hw_perf_enable(void)
 			continue;
 		}
 		val = 0;
-		if (counter->hw.irq_period) {
+		if (counter->hw.sample_period) {
 			left = atomic64_read(&counter->hw.period_left);
 			if (left < 0x80000000L)
 				val = 0x80000000L - left;
@@ -749,12 +749,12 @@ static void power_pmu_unthrottle(struct perf_counter *counter)
 	s64 val, left;
 	unsigned long flags;
 
-	if (!counter->hw.idx || !counter->hw.irq_period)
+	if (!counter->hw.idx || !counter->hw.sample_period)
 		return;
 	local_irq_save(flags);
 	perf_disable();
 	power_pmu_read(counter);
-	left = counter->hw.irq_period;
+	left = counter->hw.sample_period;
 	val = 0;
 	if (left < 0x80000000L)
 		val = 0x80000000L - left;
@@ -789,7 +789,7 @@ static int can_go_on_limited_pmc(struct perf_counter *counter, u64 ev,
 	if (counter->hw_event.exclude_user
 	    || counter->hw_event.exclude_kernel
 	    || counter->hw_event.exclude_hv
-	    || counter->hw_event.irq_period)
+	    || counter->hw_event.sample_period)
 		return 0;
 
 	if (ppmu->limited_pmc_event(ev))
@@ -925,7 +925,7 @@ const struct pmu *hw_perf_counter_init(struct perf_counter *counter)
 
 	counter->hw.config = events[n];
 	counter->hw.counter_base = cflags[n];
-	atomic64_set(&counter->hw.period_left, counter->hw.irq_period);
+	atomic64_set(&counter->hw.period_left, counter->hw.sample_period);
 
 	/*
 	 * See if we need to reserve the PMU.
@@ -958,7 +958,7 @@ const struct pmu *hw_perf_counter_init(struct perf_counter *counter)
 static void record_and_restart(struct perf_counter *counter, long val,
 			       struct pt_regs *regs, int nmi)
 {
-	u64 period = counter->hw.irq_period;
+	u64 period = counter->hw.sample_period;
 	s64 prev, delta, left;
 	int record = 0;
 	u64 addr, mmcra, sdsync;
diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 316b0c9..ec06aa5 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -290,11 +290,11 @@ static int __hw_perf_counter_init(struct perf_counter *counter)
 	hwc->nmi	= 1;
 	hw_event->nmi	= 1;
 
-	if (!hwc->irq_period)
-		hwc->irq_period = x86_pmu.max_period;
+	if (!hwc->sample_period)
+		hwc->sample_period = x86_pmu.max_period;
 
 	atomic64_set(&hwc->period_left,
-			min(x86_pmu.max_period, hwc->irq_period));
+			min(x86_pmu.max_period, hwc->sample_period));
 
 	/*
 	 * Raw event type provide the config in the event structure
@@ -462,7 +462,7 @@ x86_perf_counter_set_period(struct perf_counter *counter,
 			     struct hw_perf_counter *hwc, int idx)
 {
 	s64 left = atomic64_read(&hwc->period_left);
-	s64 period = min(x86_pmu.max_period, hwc->irq_period);
+	s64 period = min(x86_pmu.max_period, hwc->sample_period);
 	int err;
 
 	/*
diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 4845a21..1fcd3cc 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -94,18 +94,18 @@ enum sw_event_ids {
 #define PERF_COUNTER_EVENT_MASK		__PERF_COUNTER_MASK(EVENT)
 
 /*
- * Bits that can be set in hw_event.record_type to request information
+ * Bits that can be set in hw_event.sample_type to request information
  * in the overflow packets.
  */
-enum perf_counter_record_format {
-	PERF_RECORD_IP			= 1U << 0,
-	PERF_RECORD_TID			= 1U << 1,
-	PERF_RECORD_TIME		= 1U << 2,
-	PERF_RECORD_ADDR		= 1U << 3,
-	PERF_RECORD_GROUP		= 1U << 4,
-	PERF_RECORD_CALLCHAIN		= 1U << 5,
-	PERF_RECORD_CONFIG		= 1U << 6,
-	PERF_RECORD_CPU			= 1U << 7,
+enum perf_counter_sample_format {
+	PERF_SAMPLE_IP			= 1U << 0,
+	PERF_SAMPLE_TID			= 1U << 1,
+	PERF_SAMPLE_TIME		= 1U << 2,
+	PERF_SAMPLE_ADDR		= 1U << 3,
+	PERF_SAMPLE_GROUP		= 1U << 4,
+	PERF_SAMPLE_CALLCHAIN		= 1U << 5,
+	PERF_SAMPLE_CONFIG		= 1U << 6,
+	PERF_SAMPLE_CPU			= 1U << 7,
 };
 
 /*
@@ -132,12 +132,12 @@ struct perf_counter_hw_event {
 	__u64			config;
 
 	union {
-		__u64		irq_period;
-		__u64		irq_freq;
+		__u64		sample_period;
+		__u64		sample_freq;
 	};
 
-	__u32			record_type;
-	__u32			read_format;
+	__u64			sample_type;
+	__u64			read_format;
 
 	__u64			disabled       :  1, /* off by default        */
 				nmi	       :  1, /* NMI sampling          */
@@ -262,7 +262,7 @@ enum perf_event_type {
 	 * struct {
 	 *	struct perf_event_header	header;
 	 *	u64				time;
-	 *	u64				irq_period;
+	 *	u64				sample_period;
 	 * };
 	 */
 	PERF_EVENT_PERIOD		= 4,
@@ -363,7 +363,7 @@ struct hw_perf_counter {
 		};
 	};
 	atomic64_t			prev_count;
-	u64				irq_period;
+	u64				sample_period;
 	atomic64_t			period_left;
 	u64				interrupts;
 #endif
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 978ecfc..5ecd998 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1186,7 +1186,7 @@ static void perf_log_period(struct perf_counter *counter, u64 period);
 static void perf_adjust_freq(struct perf_counter_context *ctx)
 {
 	struct perf_counter *counter;
-	u64 interrupts, irq_period;
+	u64 interrupts, sample_period;
 	u64 events, period;
 	s64 delta;
 
@@ -1204,23 +1204,23 @@ static void perf_adjust_freq(struct perf_counter_context *ctx)
 			interrupts = 2*sysctl_perf_counter_limit/HZ;
 		}
 
-		if (!counter->hw_event.freq || !counter->hw_event.irq_freq)
+		if (!counter->hw_event.freq || !counter->hw_event.sample_freq)
 			continue;
 
-		events = HZ * interrupts * counter->hw.irq_period;
-		period = div64_u64(events, counter->hw_event.irq_freq);
+		events = HZ * interrupts * counter->hw.sample_period;
+		period = div64_u64(events, counter->hw_event.sample_freq);
 
-		delta = (s64)(1 + period - counter->hw.irq_period);
+		delta = (s64)(1 + period - counter->hw.sample_period);
 		delta >>= 1;
 
-		irq_period = counter->hw.irq_period + delta;
+		sample_period = counter->hw.sample_period + delta;
 
-		if (!irq_period)
-			irq_period = 1;
+		if (!sample_period)
+			sample_period = 1;
 
-		perf_log_period(counter, irq_period);
+		perf_log_period(counter, sample_period);
 
-		counter->hw.irq_period = irq_period;
+		counter->hw.sample_period = sample_period;
 	}
 	spin_unlock(&ctx->lock);
 }
@@ -2297,7 +2297,7 @@ static void perf_counter_output(struct perf_counter *counter,
 				int nmi, struct pt_regs *regs, u64 addr)
 {
 	int ret;
-	u64 record_type = counter->hw_event.record_type;
+	u64 sample_type = counter->hw_event.sample_type;
 	struct perf_output_handle handle;
 	struct perf_event_header header;
 	u64 ip;
@@ -2321,61 +2321,61 @@ static void perf_counter_output(struct perf_counter *counter,
 	header.misc = PERF_EVENT_MISC_OVERFLOW;
 	header.misc |= perf_misc_flags(regs);
 
-	if (record_type & PERF_RECORD_IP) {
+	if (sample_type & PERF_SAMPLE_IP) {
 		ip = perf_instruction_pointer(regs);
-		header.type |= PERF_RECORD_IP;
+		header.type |= PERF_SAMPLE_IP;
 		header.size += sizeof(ip);
 	}
 
-	if (record_type & PERF_RECORD_TID) {
+	if (sample_type & PERF_SAMPLE_TID) {
 		/* namespace issues */
 		tid_entry.pid = perf_counter_pid(counter, current);
 		tid_entry.tid = perf_counter_tid(counter, current);
 
-		header.type |= PERF_RECORD_TID;
+		header.type |= PERF_SAMPLE_TID;
 		header.size += sizeof(tid_entry);
 	}
 
-	if (record_type & PERF_RECORD_TIME) {
+	if (sample_type & PERF_SAMPLE_TIME) {
 		/*
 		 * Maybe do better on x86 and provide cpu_clock_nmi()
 		 */
 		time = sched_clock();
 
-		header.type |= PERF_RECORD_TIME;
+		header.type |= PERF_SAMPLE_TIME;
 		header.size += sizeof(u64);
 	}
 
-	if (record_type & PERF_RECORD_ADDR) {
-		header.type |= PERF_RECORD_ADDR;
+	if (sample_type & PERF_SAMPLE_ADDR) {
+		header.type |= PERF_SAMPLE_ADDR;
 		header.size += sizeof(u64);
 	}
 
-	if (record_type & PERF_RECORD_CONFIG) {
-		header.type |= PERF_RECORD_CONFIG;
+	if (sample_type & PERF_SAMPLE_CONFIG) {
+		header.type |= PERF_SAMPLE_CONFIG;
 		header.size += sizeof(u64);
 	}
 
-	if (record_type & PERF_RECORD_CPU) {
-		header.type |= PERF_RECORD_CPU;
+	if (sample_type & PERF_SAMPLE_CPU) {
+		header.type |= PERF_SAMPLE_CPU;
 		header.size += sizeof(cpu_entry);
 
 		cpu_entry.cpu = raw_smp_processor_id();
 	}
 
-	if (record_type & PERF_RECORD_GROUP) {
-		header.type |= PERF_RECORD_GROUP;
+	if (sample_type & PERF_SAMPLE_GROUP) {
+		header.type |= PERF_SAMPLE_GROUP;
 		header.size += sizeof(u64) +
 			counter->nr_siblings * sizeof(group_entry);
 	}
 
-	if (record_type & PERF_RECORD_CALLCHAIN) {
+	if (sample_type & PERF_SAMPLE_CALLCHAIN) {
 		callchain = perf_callchain(regs);
 
 		if (callchain) {
 			callchain_size = (1 + callchain->nr) * sizeof(u64);
 
-			header.type |= PERF_RECORD_CALLCHAIN;
+			header.type |= PERF_SAMPLE_CALLCHAIN;
 			header.size += callchain_size;
 		}
 	}
@@ -2386,28 +2386,28 @@ static void perf_counter_output(struct perf_counter *counter,
 
 	perf_output_put(&handle, header);
 
-	if (record_type & PERF_RECORD_IP)
+	if (sample_type & PERF_SAMPLE_IP)
 		perf_output_put(&handle, ip);
 
-	if (record_type & PERF_RECORD_TID)
+	if (sample_type & PERF_SAMPLE_TID)
 		perf_output_put(&handle, tid_entry);
 
-	if (record_type & PERF_RECORD_TIME)
+	if (sample_type & PERF_SAMPLE_TIME)
 		perf_output_put(&handle, time);
 
-	if (record_type & PERF_RECORD_ADDR)
+	if (sample_type & PERF_SAMPLE_ADDR)
 		perf_output_put(&handle, addr);
 
-	if (record_type & PERF_RECORD_CONFIG)
+	if (sample_type & PERF_SAMPLE_CONFIG)
 		perf_output_put(&handle, counter->hw_event.config);
 
-	if (record_type & PERF_RECORD_CPU)
+	if (sample_type & PERF_SAMPLE_CPU)
 		perf_output_put(&handle, cpu_entry);
 
 	/*
-	 * XXX PERF_RECORD_GROUP vs inherited counters seems difficult.
+	 * XXX PERF_SAMPLE_GROUP vs inherited counters seems difficult.
 	 */
-	if (record_type & PERF_RECORD_GROUP) {
+	if (sample_type & PERF_SAMPLE_GROUP) {
 		struct perf_counter *leader, *sub;
 		u64 nr = counter->nr_siblings;
 
@@ -2702,7 +2702,7 @@ void perf_counter_munmap(unsigned long addr, unsigned long len,
 }
 
 /*
- * Log irq_period changes so that analyzing tools can re-normalize the
+ * Log sample_period changes so that analyzing tools can re-normalize the
  * event flow.
  */
 
@@ -2725,7 +2725,7 @@ static void perf_log_period(struct perf_counter *counter, u64 period)
 		.period = period,
 	};
 
-	if (counter->hw.irq_period == period)
+	if (counter->hw.sample_period == period)
 		return;
 
 	ret = perf_output_begin(&handle, counter, sizeof(freq_event), 0, 0);
@@ -2834,7 +2834,7 @@ static void perf_swcounter_set_period(struct perf_counter *counter)
 {
 	struct hw_perf_counter *hwc = &counter->hw;
 	s64 left = atomic64_read(&hwc->period_left);
-	s64 period = hwc->irq_period;
+	s64 period = hwc->sample_period;
 
 	if (unlikely(left <= -period)) {
 		left = period;
@@ -2874,7 +2874,7 @@ static enum hrtimer_restart perf_swcounter_hrtimer(struct hrtimer *hrtimer)
 			ret = HRTIMER_NORESTART;
 	}
 
-	period = max_t(u64, 10000, counter->hw.irq_period);
+	period = max_t(u64, 10000, counter->hw.sample_period);
 	hrtimer_forward_now(hrtimer, ns_to_ktime(period));
 
 	return ret;
@@ -2959,7 +2959,7 @@ static void perf_swcounter_add(struct perf_counter *counter, u64 nr,
 {
 	int neg = atomic64_add_negative(nr, &counter->hw.count);
 
-	if (counter->hw.irq_period && !neg && regs)
+	if (counter->hw.sample_period && !neg && regs)
 		perf_swcounter_overflow(counter, nmi, regs, addr);
 }
 
@@ -3080,8 +3080,8 @@ static int cpu_clock_perf_counter_enable(struct perf_counter *counter)
 	atomic64_set(&hwc->prev_count, cpu_clock(cpu));
 	hrtimer_init(&hwc->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	hwc->hrtimer.function = perf_swcounter_hrtimer;
-	if (hwc->irq_period) {
-		u64 period = max_t(u64, 10000, hwc->irq_period);
+	if (hwc->sample_period) {
+		u64 period = max_t(u64, 10000, hwc->sample_period);
 		__hrtimer_start_range_ns(&hwc->hrtimer,
 				ns_to_ktime(period), 0,
 				HRTIMER_MODE_REL, 0);
@@ -3092,7 +3092,7 @@ static int cpu_clock_perf_counter_enable(struct perf_counter *counter)
 
 static void cpu_clock_perf_counter_disable(struct perf_counter *counter)
 {
-	if (counter->hw.irq_period)
+	if (counter->hw.sample_period)
 		hrtimer_cancel(&counter->hw.hrtimer);
 	cpu_clock_perf_counter_update(counter);
 }
@@ -3132,8 +3132,8 @@ static int task_clock_perf_counter_enable(struct perf_counter *counter)
 	atomic64_set(&hwc->prev_count, now);
 	hrtimer_init(&hwc->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	hwc->hrtimer.function = perf_swcounter_hrtimer;
-	if (hwc->irq_period) {
-		u64 period = max_t(u64, 10000, hwc->irq_period);
+	if (hwc->sample_period) {
+		u64 period = max_t(u64, 10000, hwc->sample_period);
 		__hrtimer_start_range_ns(&hwc->hrtimer,
 				ns_to_ktime(period), 0,
 				HRTIMER_MODE_REL, 0);
@@ -3144,7 +3144,7 @@ static int task_clock_perf_counter_enable(struct perf_counter *counter)
 
 static void task_clock_perf_counter_disable(struct perf_counter *counter)
 {
-	if (counter->hw.irq_period)
+	if (counter->hw.sample_period)
 		hrtimer_cancel(&counter->hw.hrtimer);
 	task_clock_perf_counter_update(counter, counter->ctx->time);
 
@@ -3223,7 +3223,7 @@ static const struct pmu *tp_perf_counter_init(struct perf_counter *counter)
 		return NULL;
 
 	counter->destroy = tp_perf_counter_destroy;
-	counter->hw.irq_period = counter->hw_event.irq_period;
+	counter->hw.sample_period = counter->hw_event.sample_period;
 
 	return &perf_ops_generic;
 }
@@ -3323,15 +3323,15 @@ perf_counter_alloc(struct perf_counter_hw_event *hw_event,
 	pmu = NULL;
 
 	hwc = &counter->hw;
-	if (hw_event->freq && hw_event->irq_freq)
-		hwc->irq_period = div64_u64(TICK_NSEC, hw_event->irq_freq);
+	if (hw_event->freq && hw_event->sample_freq)
+		hwc->sample_period = div64_u64(TICK_NSEC, hw_event->sample_freq);
 	else
-		hwc->irq_period = hw_event->irq_period;
+		hwc->sample_period = hw_event->sample_period;
 
 	/*
-	 * we currently do not support PERF_RECORD_GROUP on inherited counters
+	 * we currently do not support PERF_SAMPLE_GROUP on inherited counters
 	 */
-	if (hw_event->inherit && (hw_event->record_type & PERF_RECORD_GROUP))
+	if (hw_event->inherit && (hw_event->sample_type & PERF_SAMPLE_GROUP))
 		goto done;
 
 	if (perf_event_raw(hw_event)) {
