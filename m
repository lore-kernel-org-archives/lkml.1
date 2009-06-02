Return-Path: <linux-kernel-owner+w=401wt.eu-S1755468AbZFBUSM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468AbZFBUSM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 16:18:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754740AbZFBURP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 16:17:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:59501 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754643AbZFBURL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 16:17:11 -0400
Date: Tue, 2 Jun 2009 20:16:39 GMT
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
Subject: [tip:perfcounters/core] perf_counter: x86: Emulate longer sample periods
Message-ID: <tip-e4abb5d4f7ddabc1fc7c392cf0a10d8e5868c9ca@git.kernel.org>
Git-Commit-ID: e4abb5d4f7ddabc1fc7c392cf0a10d8e5868c9ca
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 02 Jun 2009 20:16:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e4abb5d4f7ddabc1fc7c392cf0a10d8e5868c9ca
Gitweb:     http://git.kernel.org/tip/e4abb5d4f7ddabc1fc7c392cf0a10d8e5868c9ca
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 2 Jun 2009 16:08:20 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 2 Jun 2009 21:45:31 +0200

perf_counter: x86: Emulate longer sample periods

Do as Power already does, emulate sample periods up to 2^63-1 by
composing them of smaller values limited by hardware capabilities.
Only once we wrap the software period do we generate an overflow
event.

Just 10 lines of new code.

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
 arch/x86/kernel/cpu/perf_counter.c |   31 ++++++++++++++++++++++---------
 1 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 9e144fb..904571b 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -287,8 +287,7 @@ static int __hw_perf_counter_init(struct perf_counter *counter)
 	if (!hwc->sample_period)
 		hwc->sample_period = x86_pmu.max_period;
 
-	atomic64_set(&hwc->period_left,
-			min(x86_pmu.max_period, hwc->sample_period));
+	atomic64_set(&hwc->period_left, hwc->sample_period);
 
 	/*
 	 * Raw event type provide the config in the event structure
@@ -451,13 +450,13 @@ static DEFINE_PER_CPU(u64, prev_left[X86_PMC_IDX_MAX]);
  * Set the next IRQ period, based on the hwc->period_left value.
  * To be called with the counter disabled in hw:
  */
-static void
+static int
 x86_perf_counter_set_period(struct perf_counter *counter,
 			     struct hw_perf_counter *hwc, int idx)
 {
 	s64 left = atomic64_read(&hwc->period_left);
-	s64 period = min(x86_pmu.max_period, hwc->sample_period);
-	int err;
+	s64 period = hwc->sample_period;
+	int err, ret = 0;
 
 	/*
 	 * If we are way outside a reasoable range then just skip forward:
@@ -465,11 +464,13 @@ x86_perf_counter_set_period(struct perf_counter *counter,
 	if (unlikely(left <= -period)) {
 		left = period;
 		atomic64_set(&hwc->period_left, left);
+		ret = 1;
 	}
 
 	if (unlikely(left <= 0)) {
 		left += period;
 		atomic64_set(&hwc->period_left, left);
+		ret = 1;
 	}
 	/*
 	 * Quirk: certain CPUs dont like it if just 1 event is left:
@@ -477,6 +478,9 @@ x86_perf_counter_set_period(struct perf_counter *counter,
 	if (unlikely(left < 2))
 		left = 2;
 
+	if (left > x86_pmu.max_period)
+		left = x86_pmu.max_period;
+
 	per_cpu(prev_left[idx], smp_processor_id()) = left;
 
 	/*
@@ -487,6 +491,8 @@ x86_perf_counter_set_period(struct perf_counter *counter,
 
 	err = checking_wrmsrl(hwc->counter_base + idx,
 			     (u64)(-left) & x86_pmu.counter_mask);
+
+	return ret;
 }
 
 static inline void
@@ -706,16 +712,19 @@ static void x86_pmu_disable(struct perf_counter *counter)
  * Save and restart an expired counter. Called by NMI contexts,
  * so it has to be careful about preempting normal counter ops:
  */
-static void intel_pmu_save_and_restart(struct perf_counter *counter)
+static int intel_pmu_save_and_restart(struct perf_counter *counter)
 {
 	struct hw_perf_counter *hwc = &counter->hw;
 	int idx = hwc->idx;
+	int ret;
 
 	x86_perf_counter_update(counter, hwc, idx);
-	x86_perf_counter_set_period(counter, hwc, idx);
+	ret = x86_perf_counter_set_period(counter, hwc, idx);
 
 	if (counter->state == PERF_COUNTER_STATE_ACTIVE)
 		intel_pmu_enable_counter(hwc, idx);
+
+	return ret;
 }
 
 static void intel_pmu_reset(void)
@@ -782,7 +791,9 @@ again:
 		if (!test_bit(bit, cpuc->active_mask))
 			continue;
 
-		intel_pmu_save_and_restart(counter);
+		if (!intel_pmu_save_and_restart(counter))
+			continue;
+
 		if (perf_counter_overflow(counter, nmi, regs, 0))
 			intel_pmu_disable_counter(&counter->hw, bit);
 	}
@@ -824,9 +835,11 @@ static int amd_pmu_handle_irq(struct pt_regs *regs, int nmi)
 			continue;
 
 		/* counter overflow */
-		x86_perf_counter_set_period(counter, hwc, idx);
 		handled = 1;
 		inc_irq_stat(apic_perf_irqs);
+		if (!x86_perf_counter_set_period(counter, hwc, idx))
+			continue;
+
 		if (perf_counter_overflow(counter, nmi, regs, 0))
 			amd_pmu_disable_counter(hwc, idx);
 	}
