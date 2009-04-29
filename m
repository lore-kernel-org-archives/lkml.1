Return-Path: <linux-kernel-owner+w=401wt.eu-S1760016AbZD2NLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760016AbZD2NLU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 09:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757823AbZD2NHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 09:07:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:44641 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758973AbZD2NHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 09:07:37 -0400
Date: Wed, 29 Apr 2009 13:06:55 GMT
From: tip-bot for Robert Richter <robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, robert.richter@amd.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, robert.richter@amd.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1241002046-8832-20-git-send-email-robert.richter@amd.com>
References: <1241002046-8832-20-git-send-email-robert.richter@amd.com>
Subject: [tip:perfcounters/core] perf_counter, x86: generic use of cpuc->active
Message-ID: <tip-095342389e2ed8deed07b3076f990260ce3c7c9f@git.kernel.org>
Git-Commit-ID: 095342389e2ed8deed07b3076f990260ce3c7c9f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 29 Apr 2009 13:06:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  095342389e2ed8deed07b3076f990260ce3c7c9f
Gitweb:     http://git.kernel.org/tip/095342389e2ed8deed07b3076f990260ce3c7c9f
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Wed, 29 Apr 2009 12:47:16 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 29 Apr 2009 14:51:10 +0200

perf_counter, x86: generic use of cpuc->active

cpuc->active will now be used to indicate an enabled counter which
implies also valid pointers of cpuc->counters[]. In contrast,
cpuc->used only locks the counter, but it can be still uninitialized.

[ Impact: refactor and generalize code ]

Signed-off-by: Robert Richter <robert.richter@amd.com>
Cc: Paul Mackerras <paulus@samba.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1241002046-8832-20-git-send-email-robert.richter@amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
