Return-Path: <linux-kernel-owner+w=401wt.eu-S1756831Ab0A2Jag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831Ab0A2Jag (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 04:30:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756787Ab0A2JaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 04:30:09 -0500
Received: from hera.kernel.org ([140.211.167.34]:57515 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756806Ab0A2JaF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 04:30:05 -0500
Date: Fri, 29 Jan 2010 09:29:37 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf_event: x86: Deduplicate the disable code
Message-ID: <tip-2e8418736dff9c6fdadb2f87dcc2087cebf32167@git.kernel.org>
Git-Commit-ID: 2e8418736dff9c6fdadb2f87dcc2087cebf32167
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 29 Jan 2010 09:29:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2e8418736dff9c6fdadb2f87dcc2087cebf32167
Gitweb:     http://git.kernel.org/tip/2e8418736dff9c6fdadb2f87dcc2087cebf32167
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 25 Jan 2010 15:58:43 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 29 Jan 2010 09:01:45 +0100

perf_event: x86: Deduplicate the disable code

Share the meat of the x86_pmu_disable() code with hw_perf_enable().

Also remove the barrier() from that code, since I could not convince
myself we actually need it.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c |   29 +++++++++++++----------------
 1 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index fdbe248..07fa0c2 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1401,6 +1401,8 @@ static inline void x86_assign_hw_event(struct perf_event *event,
 	}
 }
 
+static void __x86_pmu_disable(struct perf_event *event, struct cpu_hw_events *cpuc);
+
 void hw_perf_enable(void)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
@@ -1426,13 +1428,7 @@ void hw_perf_enable(void)
 			if (hwc->idx == -1 || hwc->idx == cpuc->assign[i])
 				continue;
 
-			x86_pmu.disable(hwc, hwc->idx);
-
-			clear_bit(hwc->idx, cpuc->active_mask);
-			barrier();
-			cpuc->events[hwc->idx] = NULL;
-
-			x86_perf_event_update(event, hwc, hwc->idx);
+			__x86_pmu_disable(event, cpuc);
 
 			hwc->idx = -1;
 		}
@@ -1822,11 +1818,10 @@ static void intel_pmu_drain_bts_buffer(struct cpu_hw_events *cpuc)
 	event->pending_kill = POLL_IN;
 }
 
-static void x86_pmu_disable(struct perf_event *event)
+static void __x86_pmu_disable(struct perf_event *event, struct cpu_hw_events *cpuc)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
-	int i, idx = hwc->idx;
+	int idx = hwc->idx;
 
 	/*
 	 * Must be done before we disable, otherwise the nmi handler
@@ -1836,12 +1831,6 @@ static void x86_pmu_disable(struct perf_event *event)
 	x86_pmu.disable(hwc, idx);
 
 	/*
-	 * Make sure the cleared pointer becomes visible before we
-	 * (potentially) free the event:
-	 */
-	barrier();
-
-	/*
 	 * Drain the remaining delta count out of a event
 	 * that we are disabling:
 	 */
@@ -1852,6 +1841,14 @@ static void x86_pmu_disable(struct perf_event *event)
 		intel_pmu_drain_bts_buffer(cpuc);
 
 	cpuc->events[idx] = NULL;
+}
+
+static void x86_pmu_disable(struct perf_event *event)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	int i;
+
+	__x86_pmu_disable(event, cpuc);
 
 	for (i = 0; i < cpuc->n_events; i++) {
 		if (event == cpuc->event_list[i]) {
