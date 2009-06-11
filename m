Return-Path: <linux-kernel-owner+w=401wt.eu-S1761370AbZFKAoM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761370AbZFKAoM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 20:44:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758339AbZFKAn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 20:43:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:59599 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757159AbZFKAn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 20:43:57 -0400
Date: Thu, 11 Jun 2009 00:43:24 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter: Accurate period data
Message-ID: <tip-9e350de37ac9607012fcf9c5314a28fbddf8f43c@git.kernel.org>
Git-Commit-ID: 9e350de37ac9607012fcf9c5314a28fbddf8f43c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 11 Jun 2009 00:43:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9e350de37ac9607012fcf9c5314a28fbddf8f43c
Gitweb:     http://git.kernel.org/tip/9e350de37ac9607012fcf9c5314a28fbddf8f43c
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 10 Jun 2009 21:34:59 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 11 Jun 2009 02:39:02 +0200

perf_counter: Accurate period data

We currently log hw.sample_period for PERF_SAMPLE_PERIOD, however this is
incorrect. When we adjust the period, it will only take effect the next
cycle but report it for the current cycle. So when we adjust the period
for every cycle, we're always wrong.

Solve this by keeping track of the last_period.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/powerpc/kernel/perf_counter.c |    9 ++++++---
 arch/x86/kernel/cpu/perf_counter.c |   15 ++++++++++++---
 include/linux/perf_counter.h       |    6 ++++--
 kernel/perf_counter.c              |    9 ++++++---
 4 files changed, 28 insertions(+), 11 deletions(-)

diff --git a/arch/powerpc/kernel/perf_counter.c b/arch/powerpc/kernel/perf_counter.c
index 5e0bf39..4990ce2 100644
--- a/arch/powerpc/kernel/perf_counter.c
+++ b/arch/powerpc/kernel/perf_counter.c
@@ -767,6 +767,7 @@ static void power_pmu_unthrottle(struct perf_counter *counter)
 	perf_disable();
 	power_pmu_read(counter);
 	left = counter->hw.sample_period;
+	counter->hw.last_period = left;
 	val = 0;
 	if (left < 0x80000000L)
 		val = 0x80000000L - left;
@@ -937,7 +938,8 @@ const struct pmu *hw_perf_counter_init(struct perf_counter *counter)
 
 	counter->hw.config = events[n];
 	counter->hw.counter_base = cflags[n];
-	atomic64_set(&counter->hw.period_left, counter->hw.sample_period);
+	counter->hw.last_period = counter->hw.sample_period;
+	atomic64_set(&counter->hw.period_left, counter->hw.last_period);
 
 	/*
 	 * See if we need to reserve the PMU.
@@ -1002,8 +1004,9 @@ static void record_and_restart(struct perf_counter *counter, long val,
 	 */
 	if (record) {
 		struct perf_sample_data data = {
-			.regs = regs,
-			.addr = 0,
+			.regs	= regs,
+			.addr	= 0,
+			.period	= counter->hw.last_period,
 		};
 
 		if (counter->attr.sample_type & PERF_SAMPLE_ADDR) {
diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 82a23d4..57ae1be 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -698,6 +698,7 @@ static int __hw_perf_counter_init(struct perf_counter *counter)
 
 	if (!hwc->sample_period) {
 		hwc->sample_period = x86_pmu.max_period;
+		hwc->last_period = hwc->sample_period;
 		atomic64_set(&hwc->period_left, hwc->sample_period);
 	}
 
@@ -880,12 +881,14 @@ x86_perf_counter_set_period(struct perf_counter *counter,
 	if (unlikely(left <= -period)) {
 		left = period;
 		atomic64_set(&hwc->period_left, left);
+		hwc->last_period = period;
 		ret = 1;
 	}
 
 	if (unlikely(left <= 0)) {
 		left += period;
 		atomic64_set(&hwc->period_left, left);
+		hwc->last_period = period;
 		ret = 1;
 	}
 	/*
@@ -1257,9 +1260,12 @@ static int amd_pmu_handle_irq(struct pt_regs *regs)
 		if (val & (1ULL << (x86_pmu.counter_bits - 1)))
 			continue;
 
-		/* counter overflow */
-		handled = 1;
-		inc_irq_stat(apic_perf_irqs);
+		/*
+		 * counter overflow
+		 */
+		handled		= 1;
+		data.period	= counter->hw.last_period;
+
 		if (!x86_perf_counter_set_period(counter, hwc, idx))
 			continue;
 
@@ -1267,6 +1273,9 @@ static int amd_pmu_handle_irq(struct pt_regs *regs)
 			amd_pmu_disable_counter(hwc, idx);
 	}
 
+	if (handled)
+		inc_irq_stat(apic_perf_irqs);
+
 	return handled;
 }
 
diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index d8c0eb4..5b96647 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -366,6 +366,7 @@ struct hw_perf_counter {
 	};
 	atomic64_t			prev_count;
 	u64				sample_period;
+	u64				last_period;
 	atomic64_t			period_left;
 	u64				interrupts;
 
@@ -606,8 +607,9 @@ extern int hw_perf_group_sched_in(struct perf_counter *group_leader,
 extern void perf_counter_update_userpage(struct perf_counter *counter);
 
 struct perf_sample_data {
-	struct pt_regs	*regs;
-	u64		addr;
+	struct pt_regs		*regs;
+	u64			addr;
+	u64			period;
 };
 
 extern int perf_counter_overflow(struct perf_counter *counter, int nmi,
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 4fe85e8..8b89b40 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -2495,7 +2495,7 @@ static void perf_counter_output(struct perf_counter *counter, int nmi,
 		perf_output_put(&handle, cpu_entry);
 
 	if (sample_type & PERF_SAMPLE_PERIOD)
-		perf_output_put(&handle, counter->hw.sample_period);
+		perf_output_put(&handle, data->period);
 
 	/*
 	 * XXX PERF_SAMPLE_GROUP vs inherited counters seems difficult.
@@ -3040,11 +3040,13 @@ static void perf_swcounter_set_period(struct perf_counter *counter)
 	if (unlikely(left <= -period)) {
 		left = period;
 		atomic64_set(&hwc->period_left, left);
+		hwc->last_period = period;
 	}
 
 	if (unlikely(left <= 0)) {
 		left += period;
 		atomic64_add(period, &hwc->period_left);
+		hwc->last_period = period;
 	}
 
 	atomic64_set(&hwc->prev_count, -left);
@@ -3086,8 +3088,9 @@ static void perf_swcounter_overflow(struct perf_counter *counter,
 				    int nmi, struct pt_regs *regs, u64 addr)
 {
 	struct perf_sample_data data = {
-		.regs = regs,
-		.addr = addr,
+		.regs	= regs,
+		.addr	= addr,
+		.period	= counter->hw.last_period,
 	};
 
 	perf_swcounter_update(counter);
