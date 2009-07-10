Return-Path: <linux-kernel-owner+w=401wt.eu-S1754357AbZGJKl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357AbZGJKl1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 06:41:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754159AbZGJKlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 06:41:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:37721 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754001AbZGJKk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 06:40:58 -0400
Date: Fri, 10 Jul 2009 10:40:24 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter: Fix up P6 PMU details
Message-ID: <tip-9c74fb50867e8fb5f3be3be06716492c0f79309e@git.kernel.org>
Git-Commit-ID: 9c74fb50867e8fb5f3be3be06716492c0f79309e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 10 Jul 2009 10:40:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9c74fb50867e8fb5f3be3be06716492c0f79309e
Gitweb:     http://git.kernel.org/tip/9c74fb50867e8fb5f3be3be06716492c0f79309e
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 8 Jul 2009 10:21:41 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 10 Jul 2009 10:28:27 +0200

perf_counter: Fix up P6 PMU details

The P6 doesn't seem to support cache ref/hit/miss counts, so
we extend the generic hardware event codes to have 0 and -1
mean the same thing as for the generic cache events.

Furthermore, it turns out the 0 event does not count
(that is, its reported that on PPro it actually does count
something), therefore use a event configuration that's
specified not to count to disable the counters.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/perf_counter.c |   28 +++++++++++++++++++++++-----
 1 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 1910f39..c7cc6ea 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -84,6 +84,14 @@ static u64 p6_pmu_event_map(int event)
 	return p6_perfmon_event_map[event];
 }
 
+/*
+ * Counter setting that is specified not to count anything.
+ * We use this to effectively disable a counter.
+ *
+ * L2_RQSTS with 0 MESI unit mask.
+ */
+#define P6_NOP_COUNTER			0x0000002EULL
+
 static u64 p6_pmu_raw_event(u64 event)
 {
 #define P6_EVNTSEL_EVENT_MASK		0x000000FFULL
@@ -704,6 +712,7 @@ static int __hw_perf_counter_init(struct perf_counter *counter)
 {
 	struct perf_counter_attr *attr = &counter->attr;
 	struct hw_perf_counter *hwc = &counter->hw;
+	u64 config;
 	int err;
 
 	if (!x86_pmu_initialized())
@@ -756,10 +765,19 @@ static int __hw_perf_counter_init(struct perf_counter *counter)
 
 	if (attr->config >= x86_pmu.max_events)
 		return -EINVAL;
+
 	/*
 	 * The generic map:
 	 */
-	hwc->config |= x86_pmu.event_map(attr->config);
+	config = x86_pmu.event_map(attr->config);
+
+	if (config == 0)
+		return -ENOENT;
+
+	if (config == -1LL)
+		return -EINVAL;
+
+	hwc->config |= config;
 
 	return 0;
 }
@@ -767,7 +785,7 @@ static int __hw_perf_counter_init(struct perf_counter *counter)
 static void p6_pmu_disable_all(void)
 {
 	struct cpu_hw_counters *cpuc = &__get_cpu_var(cpu_hw_counters);
-	unsigned long val;
+	u64 val;
 
 	if (!cpuc->enabled)
 		return;
@@ -917,10 +935,10 @@ static inline void
 p6_pmu_disable_counter(struct hw_perf_counter *hwc, int idx)
 {
 	struct cpu_hw_counters *cpuc = &__get_cpu_var(cpu_hw_counters);
-	unsigned long val = ARCH_PERFMON_EVENTSEL0_ENABLE;
+	u64 val = P6_NOP_COUNTER;
 
-	if (!cpuc->enabled)
-		val = 0;
+	if (cpuc->enabled)
+		val |= ARCH_PERFMON_EVENTSEL0_ENABLE;
 
 	(void)checking_wrmsrl(hwc->config_base + idx, val);
 }
