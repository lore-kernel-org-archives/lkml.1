Return-Path: <linux-kernel-owner+w=401wt.eu-S1758078AbZD2NO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758078AbZD2NO0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 09:14:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758178AbZD2NIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 09:08:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:44725 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759481AbZD2NIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 09:08:47 -0400
Date: Wed, 29 Apr 2009 13:08:13 GMT
From: tip-bot for Robert Richter <robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, robert.richter@amd.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, robert.richter@amd.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1241002046-8832-27-git-send-email-robert.richter@amd.com>
References: <1241002046-8832-27-git-send-email-robert.richter@amd.com>
Subject: [tip:perfcounters/core] perf_counter, x86: introduce max_period variable
Message-ID: <tip-c619b8ffb1cec6a431687a35695dc6fd292a79e6@git.kernel.org>
Git-Commit-ID: c619b8ffb1cec6a431687a35695dc6fd292a79e6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 29 Apr 2009 13:08:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c619b8ffb1cec6a431687a35695dc6fd292a79e6
Gitweb:     http://git.kernel.org/tip/c619b8ffb1cec6a431687a35695dc6fd292a79e6
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Wed, 29 Apr 2009 12:47:23 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 29 Apr 2009 14:51:13 +0200

perf_counter, x86: introduce max_period variable

In x86 pmus the allowed counter period to programm differs. This
introduces a max_period value and allows the generic implementation
for all models to check the max period.

[ Impact: generalize code ]

Signed-off-by: Robert Richter <robert.richter@amd.com>
Cc: Paul Mackerras <paulus@samba.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1241002046-8832-27-git-send-email-robert.richter@amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
