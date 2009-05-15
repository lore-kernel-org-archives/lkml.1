Return-Path: <linux-kernel-owner+w=401wt.eu-S1762054AbZEOIqH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762054AbZEOIqH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 04:46:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760765AbZEOInk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 04:43:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:57189 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760212AbZEOIni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 04:43:38 -0400
Date: Fri, 15 May 2009 08:43:15 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter: x86: Fix up the amd NMI/INT throttle
Message-ID: <tip-962bf7a66edca4d36a730a38ff8410a67f560e40@git.kernel.org>
Git-Commit-ID: 962bf7a66edca4d36a730a38ff8410a67f560e40
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 15 May 2009 08:43:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  962bf7a66edca4d36a730a38ff8410a67f560e40
Gitweb:     http://git.kernel.org/tip/962bf7a66edca4d36a730a38ff8410a67f560e40
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 13 May 2009 13:21:36 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 15 May 2009 09:47:01 +0200

perf_counter: x86: Fix up the amd NMI/INT throttle

perf_counter_unthrottle() restores throttle_ctrl, buts its never set.
Also, we fail to disable all counters when throttling.

[ Impact: fix rare stuck perf-counters when they are throttled ]

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/perf_counter.c |   38 ++++++++++++++++++++++++-----------
 1 files changed, 26 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index c19e927..7601c01 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -334,6 +334,8 @@ static u64 amd_pmu_save_disable_all(void)
 	 * right thing.
 	 */
 	barrier();
+	if (!enabled)
+		goto out;
 
 	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
 		u64 val;
@@ -347,6 +349,7 @@ static u64 amd_pmu_save_disable_all(void)
 		wrmsrl(MSR_K7_EVNTSEL0 + idx, val);
 	}
 
+out:
 	return enabled;
 }
 
@@ -787,32 +790,43 @@ static int amd_pmu_handle_irq(struct pt_regs *regs, int nmi)
 	int handled = 0;
 	struct perf_counter *counter;
 	struct hw_perf_counter *hwc;
-	int idx;
+	int idx, throttle = 0;
+
+	cpuc->throttle_ctrl = cpuc->enabled;
+	cpuc->enabled = 0;
+	barrier();
+
+	if (cpuc->throttle_ctrl) {
+		if (++cpuc->interrupts >= PERFMON_MAX_INTERRUPTS)
+			throttle = 1;
+	}
 
-	++cpuc->interrupts;
 	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
+		int disable = 0;
+
 		if (!test_bit(idx, cpuc->active_mask))
 			continue;
+
 		counter = cpuc->counters[idx];
 		hwc = &counter->hw;
 		val = x86_perf_counter_update(counter, hwc, idx);
 		if (val & (1ULL << (x86_pmu.counter_bits - 1)))
-			continue;
+			goto next;
+
 		/* counter overflow */
 		x86_perf_counter_set_period(counter, hwc, idx);
 		handled = 1;
 		inc_irq_stat(apic_perf_irqs);
-		if (perf_counter_overflow(counter, nmi, regs, 0))
-			amd_pmu_disable_counter(hwc, idx);
-		else if (cpuc->interrupts >= PERFMON_MAX_INTERRUPTS)
-			/*
-			 * do not reenable when throttled, but reload
-			 * the register
-			 */
+		disable = perf_counter_overflow(counter, nmi, regs, 0);
+
+next:
+		if (disable || throttle)
 			amd_pmu_disable_counter(hwc, idx);
-		else if (counter->state == PERF_COUNTER_STATE_ACTIVE)
-			amd_pmu_enable_counter(hwc, idx);
 	}
+
+	if (cpuc->throttle_ctrl && !throttle)
+		cpuc->enabled = 1;
+
 	return handled;
 }
 
