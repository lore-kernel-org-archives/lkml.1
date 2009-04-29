Return-Path: <linux-kernel-owner+w=401wt.eu-S1757297AbZD2K5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297AbZD2K5q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 06:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756051AbZD2Kvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 06:51:31 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:21631 "EHLO
	IE1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755729AbZD2KvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 06:51:14 -0400
X-BigFish: VPS10(z1039ozzz1202hzzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KIUZGT-04-0X7-01
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 19/29] x86/perfcounters: generic use of cpuc->active
Date: Wed, 29 Apr 2009 12:47:16 +0200
Message-ID: <1241002046-8832-20-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1241002046-8832-1-git-send-email-robert.richter@amd.com>
References: <1241002046-8832-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 29 Apr 2009 10:50:49.0539 (UTC) FILETIME=[5BBC8930:01C9C8B8]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpuc->active will now be used to indicate an enabled counter which
implies also valid pointers of cpuc->counters[]. In contrast,
cpuc->used only locks the counter, but it can be still uninitialized.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_counter.c |   20 +++++++++-----------
 1 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 9ec51a6..f7fd4a3 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -424,7 +424,6 @@ static void amd_pmu_enable_counter(int idx, u64 config)
 {
 	struct cpu_hw_counters *cpuc = &__get_cpu_var(cpu_hw_counters);
 
-	set_bit(idx, cpuc->active);
 	if (cpuc->enabled)
 		config |= ARCH_PERFMON_EVENTSEL0_ENABLE;
 
@@ -446,9 +445,6 @@ static void intel_pmu_disable_counter(int idx, u64 config)
 
 static void amd_pmu_disable_counter(int idx, u64 config)
 {
-	struct cpu_hw_counters *cpuc = &__get_cpu_var(cpu_hw_counters);
-
-	clear_bit(idx, cpuc->active);
 	wrmsrl(MSR_K7_EVNTSEL0 + idx, config);
 
 }
@@ -633,10 +629,7 @@ try_generic:
 	__x86_pmu_disable(counter, hwc, idx);
 
 	cpuc->counters[idx] = counter;
-	/*
-	 * Make it visible before enabling the hw:
-	 */
-	barrier();
+	set_bit(idx, cpuc->active);
 
 	x86_perf_counter_set_period(counter, hwc, idx);
 	__x86_pmu_enable(counter, hwc, idx);
@@ -700,10 +693,13 @@ static void x86_pmu_disable(struct perf_counter *counter)
 	struct hw_perf_counter *hwc = &counter->hw;
 	unsigned int idx = hwc->idx;
 
+	/*
+	 * Must be done before we disable, otherwise the nmi handler
+	 * could reenable again:
+	 */
+	clear_bit(idx, cpuc->active);
 	__x86_pmu_disable(counter, hwc, idx);
 
-	clear_bit(idx, cpuc->used);
-	cpuc->counters[idx] = NULL;
 	/*
 	 * Make sure the cleared pointer becomes visible before we
 	 * (potentially) free the counter:
@@ -715,6 +711,8 @@ static void x86_pmu_disable(struct perf_counter *counter)
 	 * that we are disabling:
 	 */
 	x86_perf_counter_update(counter, hwc, idx);
+	cpuc->counters[idx] = NULL;
+	clear_bit(idx, cpuc->used);
 }
 
 /*
@@ -763,7 +761,7 @@ again:
 		struct perf_counter *counter = cpuc->counters[bit];
 
 		clear_bit(bit, (unsigned long *) &status);
-		if (!counter)
+		if (!test_bit(bit, cpuc->active))
 			continue;
 
 		intel_pmu_save_and_restart(counter);
-- 
1.6.1.3


