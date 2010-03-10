Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059Ab0CJNMm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 08:12:42 -0500
Received: from hera.kernel.org ([140.211.167.34]:59128 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755224Ab0CJNMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 08:12:39 -0500
Date: Wed, 10 Mar 2010 13:11:47 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       acme@infradead.org, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, acme@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20100304140100.240023029@chello.nl>
References: <20100304140100.240023029@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf, x86: Use unlocked bitops
Message-ID: <tip-34538ee77b39a12702e0f4c3ed9e8fa2dd5eb92c@git.kernel.org>
Git-Commit-ID: 34538ee77b39a12702e0f4c3ed9e8fa2dd5eb92c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 10 Mar 2010 13:11:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  34538ee77b39a12702e0f4c3ed9e8fa2dd5eb92c
Gitweb:     http://git.kernel.org/tip/34538ee77b39a12702e0f4c3ed9e8fa2dd5eb92c
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 2 Mar 2010 21:16:55 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 10 Mar 2010 13:22:29 +0100

perf, x86: Use unlocked bitops

There is no concurrency on these variables, so don't use LOCK'ed ops.

As to the intel_pmu_handle_irq() status bit clean, nobody uses that so
remove it all together.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: paulus@samba.org
Cc: eranian@google.com
Cc: robert.richter@amd.com
Cc: fweisbec@gmail.com
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
LKML-Reference: <20100304140100.240023029@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c       |    8 ++++----
 arch/x86/kernel/cpu/perf_event_amd.c   |    2 +-
 arch/x86/kernel/cpu/perf_event_intel.c |    1 -
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 2dd704f..01b1667 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -643,7 +643,7 @@ static int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
 		if (test_bit(hwc->idx, used_mask))
 			break;
 
-		set_bit(hwc->idx, used_mask);
+		__set_bit(hwc->idx, used_mask);
 		if (assign)
 			assign[i] = hwc->idx;
 	}
@@ -692,7 +692,7 @@ static int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
 			if (j == X86_PMC_IDX_MAX)
 				break;
 
-			set_bit(j, used_mask);
+			__set_bit(j, used_mask);
 
 			if (assign)
 				assign[i] = j;
@@ -842,7 +842,7 @@ void hw_perf_enable(void)
 			 * clear active_mask and events[] yet it preserves
 			 * idx
 			 */
-			set_bit(hwc->idx, cpuc->active_mask);
+			__set_bit(hwc->idx, cpuc->active_mask);
 			cpuc->events[hwc->idx] = event;
 
 			x86_pmu.enable(event);
@@ -1057,7 +1057,7 @@ static void x86_pmu_stop(struct perf_event *event)
 	 * Must be done before we disable, otherwise the nmi handler
 	 * could reenable again:
 	 */
-	clear_bit(idx, cpuc->active_mask);
+	__clear_bit(idx, cpuc->active_mask);
 	x86_pmu.disable(event);
 
 	/*
diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index 014528b..573458f 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -287,7 +287,7 @@ static struct amd_nb *amd_alloc_nb(int cpu, int nb_id)
 	 * initialize all possible NB constraints
 	 */
 	for (i = 0; i < x86_pmu.num_events; i++) {
-		set_bit(i, nb->event_constraints[i].idxmsk);
+		__set_bit(i, nb->event_constraints[i].idxmsk);
 		nb->event_constraints[i].weight = 1;
 	}
 	return nb;
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index a840948..d87421c 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -765,7 +765,6 @@ again:
 	for_each_set_bit(bit, (unsigned long *)&status, X86_PMC_IDX_MAX) {
 		struct perf_event *event = cpuc->events[bit];
 
-		clear_bit(bit, (unsigned long *) &status);
 		if (!test_bit(bit, cpuc->active_mask))
 			continue;
 
