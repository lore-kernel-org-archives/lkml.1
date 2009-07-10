Return-Path: <linux-kernel-owner+w=401wt.eu-S1754657AbZGJKll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657AbZGJKll (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 06:41:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754329AbZGJKlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 06:41:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:37741 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754244AbZGJKlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 06:41:14 -0400
Date: Fri, 10 Jul 2009 10:40:37 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter: Clean up global vs counter enable
Message-ID: <tip-984b838ce69c063a91b87550598ab7f3439dd94a@git.kernel.org>
Git-Commit-ID: 984b838ce69c063a91b87550598ab7f3439dd94a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 10 Jul 2009 10:40:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  984b838ce69c063a91b87550598ab7f3439dd94a
Gitweb:     http://git.kernel.org/tip/984b838ce69c063a91b87550598ab7f3439dd94a
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 10 Jul 2009 09:59:56 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 10 Jul 2009 10:28:29 +0200

perf_counter: Clean up global vs counter enable

Ingo noticed that both AMD and P6 call
x86_pmu_disable_counter() on *_pmu_enable_counter(). This is
because we rely on the side effect of that call to program
the event config but not touch the EN bit.

We change that for AMD by having enable_all() simply write
the full config in, and for P6 by explicitly coding it.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/perf_counter.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index c7cc6ea..bed1c4c 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -874,13 +874,13 @@ static void amd_pmu_enable_all(void)
 	barrier();
 
 	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
+		struct perf_counter *counter = cpuc->counters[idx];
 		u64 val;
 
 		if (!test_bit(idx, cpuc->active_mask))
 			continue;
-		rdmsrl(MSR_K7_EVNTSEL0 + idx, val);
-		if (val & ARCH_PERFMON_EVENTSEL0_ENABLE)
-			continue;
+
+		val = counter->hw.config;
 		val |= ARCH_PERFMON_EVENTSEL0_ENABLE;
 		wrmsrl(MSR_K7_EVNTSEL0 + idx, val);
 	}
@@ -1044,11 +1044,13 @@ intel_pmu_enable_fixed(struct hw_perf_counter *hwc, int __idx)
 static void p6_pmu_enable_counter(struct hw_perf_counter *hwc, int idx)
 {
 	struct cpu_hw_counters *cpuc = &__get_cpu_var(cpu_hw_counters);
+	u64 val;
 
+	val = hwc->config;
 	if (cpuc->enabled)
-		x86_pmu_enable_counter(hwc, idx);
-	else
-		x86_pmu_disable_counter(hwc, idx);
+		val |= ARCH_PERFMON_EVENTSEL0_ENABLE;
+
+	(void)checking_wrmsrl(hwc->config_base + idx, val);
 }
 
 
@@ -1068,8 +1070,6 @@ static void amd_pmu_enable_counter(struct hw_perf_counter *hwc, int idx)
 
 	if (cpuc->enabled)
 		x86_pmu_enable_counter(hwc, idx);
-	else
-		x86_pmu_disable_counter(hwc, idx);
 }
 
 static int
