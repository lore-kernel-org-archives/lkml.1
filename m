Return-Path: <linux-kernel-owner+w=401wt.eu-S1759468AbZD2K7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759468AbZD2K7t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 06:59:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756461AbZD2Kvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 06:51:37 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:11554
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754507AbZD2KvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 06:51:04 -0400
X-BigFish: VPS3(zzzz1202hzzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KIUZGR-01-7AG-01
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 26/29] x86/perfcounters: introduce max_period variable
Date: Wed, 29 Apr 2009 12:47:23 +0200
Message-ID: <1241002046-8832-27-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1241002046-8832-1-git-send-email-robert.richter@amd.com>
References: <1241002046-8832-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 29 Apr 2009 10:50:49.0555 (UTC) FILETIME=[5BBEFA30:01C9C8B8]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In x86 pmus the allowed counter period to programm differs. This
introduces a max_period value and allows the generic implementation
for all models to check the max period.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_counter.c |   20 ++++++++++++--------
 1 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index a8a53ab..4b8715b 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -54,6 +54,7 @@ struct x86_pmu {
 	int		num_counters_fixed;
 	int		counter_bits;
 	u64		counter_mask;
+	u64		max_period;
 };
 
 static struct x86_pmu x86_pmu __read_mostly;
@@ -279,14 +280,8 @@ static int __hw_perf_counter_init(struct perf_counter *counter)
 		hwc->nmi = 1;
 
 	hwc->irq_period		= hw_event->irq_period;
-	/*
-	 * Intel PMCs cannot be accessed sanely above 32 bit width,
-	 * so we install an artificial 1<<31 period regardless of
-	 * the generic counter period:
-	 */
-	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL)
-		if ((s64)hwc->irq_period <= 0 || hwc->irq_period > 0x7FFFFFFF)
-			hwc->irq_period = 0x7FFFFFFF;
+	if ((s64)hwc->irq_period <= 0 || hwc->irq_period > x86_pmu.max_period)
+		hwc->irq_period = x86_pmu.max_period;
 
 	atomic64_set(&hwc->period_left, hwc->irq_period);
 
@@ -910,6 +905,12 @@ static struct x86_pmu intel_pmu = {
 	.event_map		= intel_pmu_event_map,
 	.raw_event		= intel_pmu_raw_event,
 	.max_events		= ARRAY_SIZE(intel_perfmon_event_map),
+	/*
+	 * Intel PMCs cannot be accessed sanely above 32 bit width,
+	 * so we install an artificial 1<<31 period regardless of
+	 * the generic counter period:
+	 */
+	.max_period		= (1ULL << 31) - 1,
 };
 
 static struct x86_pmu amd_pmu = {
@@ -927,6 +928,8 @@ static struct x86_pmu amd_pmu = {
 	.num_counters		= 4,
 	.counter_bits		= 48,
 	.counter_mask		= (1ULL << 48) - 1,
+	/* use highest bit to detect overflow */
+	.max_period		= (1ULL << 47) - 1,
 };
 
 static int intel_pmu_init(void)
@@ -999,6 +1002,7 @@ void __init init_hw_perf_counters(void)
 	perf_max_counters = x86_pmu.num_counters;
 
 	pr_info("... value mask:      %016Lx\n", x86_pmu.counter_mask);
+	pr_info("... max period:      %016Lx\n", x86_pmu.max_period);
 
 	if (x86_pmu.num_counters_fixed > X86_PMC_MAX_FIXED) {
 		x86_pmu.num_counters_fixed = X86_PMC_MAX_FIXED;
-- 
1.6.1.3


