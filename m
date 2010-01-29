Return-Path: <linux-kernel-owner+w=401wt.eu-S1756823Ab0A2JbE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823Ab0A2JbE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 04:31:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753546Ab0A2Ja6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 04:30:58 -0500
Received: from hera.kernel.org ([140.211.167.34]:57553 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756817Ab0A2Jaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 04:30:55 -0500
Date: Fri, 29 Jan 2010 09:30:09 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100127221122.057507285@chello.nl>
References: <20100127221122.057507285@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf_events, x86: Clean up hw_perf_*_all() implementation
Message-ID: <tip-1a6e21f791fe85b40a9ddbafe999ab8ccffc3f78@git.kernel.org>
Git-Commit-ID: 1a6e21f791fe85b40a9ddbafe999ab8ccffc3f78
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 29 Jan 2010 09:30:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1a6e21f791fe85b40a9ddbafe999ab8ccffc3f78
Gitweb:     http://git.kernel.org/tip/1a6e21f791fe85b40a9ddbafe999ab8ccffc3f78
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 27 Jan 2010 23:07:47 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 29 Jan 2010 09:01:47 +0100

perf_events, x86: Clean up hw_perf_*_all() implementation

Put the recursion avoidance code in the generic hook instead of
replicating it in each implementation.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <20100127221122.057507285@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c |   59 +++++++++-----------------------------
 1 files changed, 14 insertions(+), 45 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 951213a..cf10839 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1099,15 +1099,8 @@ static int __hw_perf_event_init(struct perf_event *event)
 
 static void p6_pmu_disable_all(void)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	u64 val;
 
-	if (!cpuc->enabled)
-		return;
-
-	cpuc->enabled = 0;
-	barrier();
-
 	/* p6 only has one enable register */
 	rdmsrl(MSR_P6_EVNTSEL0, val);
 	val &= ~ARCH_PERFMON_EVENTSEL0_ENABLE;
@@ -1118,12 +1111,6 @@ static void intel_pmu_disable_all(void)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
-	if (!cpuc->enabled)
-		return;
-
-	cpuc->enabled = 0;
-	barrier();
-
 	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0);
 
 	if (test_bit(X86_PMC_IDX_FIXED_BTS, cpuc->active_mask))
@@ -1135,17 +1122,6 @@ static void amd_pmu_disable_all(void)
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	int idx;
 
-	if (!cpuc->enabled)
-		return;
-
-	cpuc->enabled = 0;
-	/*
-	 * ensure we write the disable before we start disabling the
-	 * events proper, so that amd_pmu_enable_event() does the
-	 * right thing.
-	 */
-	barrier();
-
 	for (idx = 0; idx < x86_pmu.num_events; idx++) {
 		u64 val;
 
@@ -1166,23 +1142,20 @@ void hw_perf_disable(void)
 	if (!x86_pmu_initialized())
 		return;
 
-	if (cpuc->enabled)
-		cpuc->n_added = 0;
+	if (!cpuc->enabled)
+		return;
+
+	cpuc->n_added = 0;
+	cpuc->enabled = 0;
+	barrier();
 
 	x86_pmu.disable_all();
 }
 
 static void p6_pmu_enable_all(void)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	unsigned long val;
 
-	if (cpuc->enabled)
-		return;
-
-	cpuc->enabled = 1;
-	barrier();
-
 	/* p6 only has one enable register */
 	rdmsrl(MSR_P6_EVNTSEL0, val);
 	val |= ARCH_PERFMON_EVENTSEL0_ENABLE;
@@ -1193,12 +1166,6 @@ static void intel_pmu_enable_all(void)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
-	if (cpuc->enabled)
-		return;
-
-	cpuc->enabled = 1;
-	barrier();
-
 	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, x86_pmu.intel_ctrl);
 
 	if (test_bit(X86_PMC_IDX_FIXED_BTS, cpuc->active_mask)) {
@@ -1217,12 +1184,6 @@ static void amd_pmu_enable_all(void)
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	int idx;
 
-	if (cpuc->enabled)
-		return;
-
-	cpuc->enabled = 1;
-	barrier();
-
 	for (idx = 0; idx < x86_pmu.num_events; idx++) {
 		struct perf_event *event = cpuc->events[idx];
 		u64 val;
@@ -1417,6 +1378,10 @@ void hw_perf_enable(void)
 
 	if (!x86_pmu_initialized())
 		return;
+
+	if (cpuc->enabled)
+		return;
+
 	if (cpuc->n_added) {
 		/*
 		 * apply assignment obtained either from
@@ -1461,6 +1426,10 @@ void hw_perf_enable(void)
 		cpuc->n_added = 0;
 		perf_events_lapic_init();
 	}
+
+	cpuc->enabled = 1;
+	barrier();
+
 	x86_pmu.enable_all();
 }
 
