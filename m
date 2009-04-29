Return-Path: <linux-kernel-owner+w=401wt.eu-S1757808AbZD2Kxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757808AbZD2Kxs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 06:53:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755400AbZD2KvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 06:51:15 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:21218 "EHLO
	IE1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794AbZD2KvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 06:51:04 -0400
X-BigFish: VPS1(zzzz1202hzzz32i61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KIUZGS-02-18S-01
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 24/29] x86/perfcounters: implement the interrupt handler for AMD cpus
Date: Wed, 29 Apr 2009 12:47:21 +0200
Message-ID: <1241002046-8832-25-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1241002046-8832-1-git-send-email-robert.richter@amd.com>
References: <1241002046-8832-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 29 Apr 2009 10:50:49.0633 (UTC) FILETIME=[5BCAE110:01C9C8B8]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements the interrupt handler for AMD performance
counters. In difference to the Intel pmu, there is no single status
register and also there are no fixed counters. This makes the handler
very different and it is useful to make the handler vendor
specific. To check if a counter is overflowed the upper bit of the
counter is checked. Only counters where the active bit is set are
checked.

With this patch throttling is enabled for AMD performance counters.

This patch also reenables Linux performance counters on AMD cpus.

Signed-off-by: Robert Richter <robert.richter@amd.com>
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
-- 
1.6.1.3


