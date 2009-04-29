Return-Path: <linux-kernel-owner+w=401wt.eu-S1760434AbZD2NNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760434AbZD2NNm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 09:13:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759390AbZD2NIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 09:08:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:44704 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759375AbZD2NI3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 09:08:29 -0400
Date: Wed, 29 Apr 2009 13:07:51 GMT
From: tip-bot for Robert Richter <robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, robert.richter@amd.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, robert.richter@amd.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1241002046-8832-25-git-send-email-robert.richter@amd.com>
References: <1241002046-8832-25-git-send-email-robert.richter@amd.com>
Subject: [tip:perfcounters/core] perf_counter, x86: implement the interrupt handler for AMD cpus
Message-ID: <tip-a29aa8a7ff93e4196d558036928597e68337dd8d@git.kernel.org>
Git-Commit-ID: a29aa8a7ff93e4196d558036928597e68337dd8d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 29 Apr 2009 13:07:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a29aa8a7ff93e4196d558036928597e68337dd8d
Gitweb:     http://git.kernel.org/tip/a29aa8a7ff93e4196d558036928597e68337dd8d
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Wed, 29 Apr 2009 12:47:21 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 29 Apr 2009 14:51:12 +0200

perf_counter, x86: implement the interrupt handler for AMD cpus

This patch implements the interrupt handler for AMD performance
counters. In difference to the Intel pmu, there is no single status
register and also there are no fixed counters. This makes the handler
very different and it is useful to make the handler vendor
specific. To check if a counter is overflowed the upper bit of the
counter is checked. Only counters where the active bit is set are
checked.

With this patch throttling is enabled for AMD performance counters.

This patch also reenables Linux performance counters on AMD cpus.

[ Impact: re-enable perfcounters on AMD CPUs ]

Signed-off-by: Robert Richter <robert.richter@amd.com>
Cc: Paul Mackerras <paulus@samba.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1241002046-8832-25-git-send-email-robert.richter@amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/perf_counter.c |   45 +++++++++++++++++++++++++++++------
 1 files changed, 37 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 2d3681b..f4d59d4 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -240,10 +240,6 @@ static int __hw_perf_counter_init(struct perf_counter *counter)
 	struct hw_perf_counter *hwc = &counter->hw;
 	int err;
 
-	/* disable temporarily */
-	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD)
-		return -ENOSYS;
-
 	if (!x86_pmu_initialized())
 		return -ENODEV;
 
@@ -773,7 +769,43 @@ out:
 	return ret;
 }
 
-static int amd_pmu_handle_irq(struct pt_regs *regs, int nmi) { return 0; }
+static int amd_pmu_handle_irq(struct pt_regs *regs, int nmi)
+{
+	int cpu = smp_processor_id();
+	struct cpu_hw_counters *cpuc = &per_cpu(cpu_hw_counters, cpu);
+	u64 val;
+	int handled = 0;
+	struct perf_counter *counter;
+	struct hw_perf_counter *hwc;
+	int idx;
+
+	++cpuc->interrupts;
+	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
+		if (!test_bit(idx, cpuc->active))
+			continue;
+		counter = cpuc->counters[idx];
+		hwc = &counter->hw;
+		x86_perf_counter_update(counter, hwc, idx);
+		val = atomic64_read(&hwc->prev_count);
+		if (val & (1ULL << (x86_pmu.counter_bits - 1)))
+			continue;
+		/* counter overflow */
+		x86_perf_counter_set_period(counter, hwc, idx);
+		handled = 1;
+		inc_irq_stat(apic_perf_irqs);
+		if (perf_counter_overflow(counter, nmi, regs, 0))
+			amd_pmu_disable_counter(hwc, idx);
+		else if (cpuc->interrupts >= PERFMON_MAX_INTERRUPTS)
+			/*
+			 * do not reenable when throttled, but reload
+			 * the register
+			 */
+			amd_pmu_disable_counter(hwc, idx);
+		else if (counter->state == PERF_COUNTER_STATE_ACTIVE)
+			amd_pmu_enable_counter(hwc, idx);
+	}
+	return handled;
+}
 
 void perf_counter_unthrottle(void)
 {
@@ -782,9 +814,6 @@ void perf_counter_unthrottle(void)
 	if (!x86_pmu_initialized())
 		return;
 
-	if (!cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON))
-		return;
-
 	cpuc = &__get_cpu_var(cpu_hw_counters);
 	if (cpuc->interrupts >= PERFMON_MAX_INTERRUPTS) {
 		if (printk_ratelimit())
