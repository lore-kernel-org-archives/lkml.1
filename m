Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915Ab0CJNLe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 08:11:34 -0500
Received: from hera.kernel.org ([140.211.167.34]:59038 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755224Ab0CJNLa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 08:11:30 -0500
Date: Wed, 10 Mar 2010 13:10:56 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       acme@infradead.org, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, acme@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20100304140100.006500906@chello.nl>
References: <20100304140100.006500906@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf, x86: Remove superfluous arguments to x86_perf_event_set_period()
Message-ID: <tip-07088edb88164c2a2406cd2d9a7be19d8515214b@git.kernel.org>
Git-Commit-ID: 07088edb88164c2a2406cd2d9a7be19d8515214b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 10 Mar 2010 13:10:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  07088edb88164c2a2406cd2d9a7be19d8515214b
Gitweb:     http://git.kernel.org/tip/07088edb88164c2a2406cd2d9a7be19d8515214b
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 2 Mar 2010 20:16:01 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 10 Mar 2010 13:22:27 +0100

perf, x86: Remove superfluous arguments to x86_perf_event_set_period()

The second and third argument to x86_perf_event_set_period() are
superfluous since they are simple expressions of the first argument.
Hence remove them.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: paulus@samba.org
Cc: eranian@google.com
Cc: robert.richter@amd.com
Cc: fweisbec@gmail.com
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
LKML-Reference: <20100304140100.006500906@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c       |   15 +++++++--------
 arch/x86/kernel/cpu/perf_event_intel.c |    2 +-
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 585d560..fcf1788 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -170,8 +170,7 @@ static DEFINE_PER_CPU(struct cpu_hw_events, cpu_hw_events) = {
 	.enabled = 1,
 };
 
-static int x86_perf_event_set_period(struct perf_event *event,
-			     struct hw_perf_event *hwc, int idx);
+static int x86_perf_event_set_period(struct perf_event *event);
 
 /*
  * Generalized hw caching related hw_event table, filled
@@ -835,7 +834,7 @@ void hw_perf_enable(void)
 
 			if (hwc->idx == -1) {
 				x86_assign_hw_event(event, cpuc, i);
-				x86_perf_event_set_period(event, hwc, hwc->idx);
+				x86_perf_event_set_period(event);
 			}
 			/*
 			 * need to mark as active because x86_pmu_disable()
@@ -876,12 +875,12 @@ static DEFINE_PER_CPU(u64 [X86_PMC_IDX_MAX], pmc_prev_left);
  * To be called with the event disabled in hw:
  */
 static int
-x86_perf_event_set_period(struct perf_event *event,
-			     struct hw_perf_event *hwc, int idx)
+x86_perf_event_set_period(struct perf_event *event)
 {
+	struct hw_perf_event *hwc = &event->hw;
 	s64 left = atomic64_read(&hwc->period_left);
 	s64 period = hwc->sample_period;
-	int err, ret = 0;
+	int err, ret = 0, idx = hwc->idx;
 
 	if (idx == X86_PMC_IDX_FIXED_BTS)
 		return 0;
@@ -979,7 +978,7 @@ static int x86_pmu_start(struct perf_event *event)
 	if (hwc->idx == -1)
 		return -EAGAIN;
 
-	x86_perf_event_set_period(event, hwc, hwc->idx);
+	x86_perf_event_set_period(event);
 	x86_pmu.enable(hwc, hwc->idx);
 
 	return 0;
@@ -1123,7 +1122,7 @@ static int x86_pmu_handle_irq(struct pt_regs *regs)
 		handled		= 1;
 		data.period	= event->hw.last_period;
 
-		if (!x86_perf_event_set_period(event, hwc, idx))
+		if (!x86_perf_event_set_period(event))
 			continue;
 
 		if (perf_event_overflow(event, 1, &data, regs))
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index c582449..6dbdf91 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -699,7 +699,7 @@ static int intel_pmu_save_and_restart(struct perf_event *event)
 	int ret;
 
 	x86_perf_event_update(event, hwc, idx);
-	ret = x86_perf_event_set_period(event, hwc, idx);
+	ret = x86_perf_event_set_period(event);
 
 	return ret;
 }
