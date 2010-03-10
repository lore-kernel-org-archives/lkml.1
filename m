Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898Ab0CJNMF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 08:12:05 -0500
Received: from hera.kernel.org ([140.211.167.34]:59081 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755032Ab0CJNMA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 08:12:00 -0500
Date: Wed, 10 Mar 2010 13:11:14 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       acme@infradead.org, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, acme@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20100304140100.089468871@chello.nl>
References: <20100304140100.089468871@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf, x86: Remove superfluous arguments to x86_perf_event_update()
Message-ID: <tip-cc2ad4ba8792b9d4ff893ae3b845d2c5a6206fc9@git.kernel.org>
Git-Commit-ID: cc2ad4ba8792b9d4ff893ae3b845d2c5a6206fc9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 10 Mar 2010 13:11:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cc2ad4ba8792b9d4ff893ae3b845d2c5a6206fc9
Gitweb:     http://git.kernel.org/tip/cc2ad4ba8792b9d4ff893ae3b845d2c5a6206fc9
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 2 Mar 2010 20:18:39 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 10 Mar 2010 13:22:27 +0100

perf, x86: Remove superfluous arguments to x86_perf_event_update()

The second and third argument to x86_perf_event_update() are superfluous
since they are simple expressions of the first argument. Hence remove
them.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: paulus@samba.org
Cc: eranian@google.com
Cc: robert.richter@amd.com
Cc: fweisbec@gmail.com
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
LKML-Reference: <20100304140100.089468871@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c       |   11 ++++++-----
 arch/x86/kernel/cpu/perf_event_intel.c |   10 ++--------
 2 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index fcf1788..086127b 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -193,11 +193,12 @@ static u64 __read_mostly hw_cache_event_ids
  * Returns the delta events processed.
  */
 static u64
-x86_perf_event_update(struct perf_event *event,
-			struct hw_perf_event *hwc, int idx)
+x86_perf_event_update(struct perf_event *event)
 {
+	struct hw_perf_event *hwc = &event->hw;
 	int shift = 64 - x86_pmu.event_bits;
 	u64 prev_raw_count, new_raw_count;
+	int idx = hwc->idx;
 	s64 delta;
 
 	if (idx == X86_PMC_IDX_FIXED_BTS)
@@ -1064,7 +1065,7 @@ static void x86_pmu_stop(struct perf_event *event)
 	 * Drain the remaining delta count out of a event
 	 * that we are disabling:
 	 */
-	x86_perf_event_update(event, hwc, idx);
+	x86_perf_event_update(event);
 
 	cpuc->events[idx] = NULL;
 }
@@ -1112,7 +1113,7 @@ static int x86_pmu_handle_irq(struct pt_regs *regs)
 		event = cpuc->events[idx];
 		hwc = &event->hw;
 
-		val = x86_perf_event_update(event, hwc, idx);
+		val = x86_perf_event_update(event);
 		if (val & (1ULL << (x86_pmu.event_bits - 1)))
 			continue;
 
@@ -1458,7 +1459,7 @@ void __init init_hw_perf_events(void)
 
 static inline void x86_pmu_read(struct perf_event *event)
 {
-	x86_perf_event_update(event, &event->hw, event->hw.idx);
+	x86_perf_event_update(event);
 }
 
 static const struct pmu pmu = {
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 6dbdf91..a4c9f16 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -694,14 +694,8 @@ static void intel_pmu_enable_event(struct hw_perf_event *hwc, int idx)
  */
 static int intel_pmu_save_and_restart(struct perf_event *event)
 {
-	struct hw_perf_event *hwc = &event->hw;
-	int idx = hwc->idx;
-	int ret;
-
-	x86_perf_event_update(event, hwc, idx);
-	ret = x86_perf_event_set_period(event);
-
-	return ret;
+	x86_perf_event_update(event);
+	return x86_perf_event_set_period(event);
 }
 
 static void intel_pmu_reset(void)
