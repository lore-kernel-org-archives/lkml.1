Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927Ab0CJNMw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 08:12:52 -0500
Received: from hera.kernel.org ([140.211.167.34]:59134 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755842Ab0CJNMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 08:12:41 -0500
Date: Wed, 10 Mar 2010 13:12:04 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       acme@infradead.org, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, acme@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf, x86: Fix x86_pmu_start
Message-ID: <tip-c08053e627d23490a03431285b78b7a5b617fbad@git.kernel.org>
Git-Commit-ID: c08053e627d23490a03431285b78b7a5b617fbad
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 10 Mar 2010 13:12:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c08053e627d23490a03431285b78b7a5b617fbad
Gitweb:     http://git.kernel.org/tip/c08053e627d23490a03431285b78b7a5b617fbad
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Sat, 6 Mar 2010 13:19:24 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 10 Mar 2010 13:22:30 +0100

perf, x86: Fix x86_pmu_start

pmu::start should undo pmu::stop, make it so.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: paulus@samba.org
Cc: eranian@google.com
Cc: robert.richter@amd.com
Cc: fweisbec@gmail.com
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c |   23 ++++++++++-------------
 1 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 01b1667..9757b96 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -785,6 +785,7 @@ static inline int match_prev_assignment(struct hw_perf_event *hwc,
 		hwc->last_tag == cpuc->tags[i];
 }
 
+static int x86_pmu_start(struct perf_event *event);
 static void x86_pmu_stop(struct perf_event *event);
 
 void hw_perf_enable(void)
@@ -833,20 +834,10 @@ void hw_perf_enable(void)
 			event = cpuc->event_list[i];
 			hwc = &event->hw;
 
-			if (hwc->idx == -1) {
+			if (hwc->idx == -1)
 				x86_assign_hw_event(event, cpuc, i);
-				x86_perf_event_set_period(event);
-			}
-			/*
-			 * need to mark as active because x86_pmu_disable()
-			 * clear active_mask and events[] yet it preserves
-			 * idx
-			 */
-			__set_bit(hwc->idx, cpuc->active_mask);
-			cpuc->events[hwc->idx] = event;
 
-			x86_pmu.enable(event);
-			perf_event_update_userpage(event);
+			x86_pmu_start(event);
 		}
 		cpuc->n_added = 0;
 		perf_events_lapic_init();
@@ -975,11 +966,17 @@ static int x86_pmu_enable(struct perf_event *event)
 
 static int x86_pmu_start(struct perf_event *event)
 {
-	if (event->hw.idx == -1)
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	int idx = event->hw.idx;
+
+	if (idx == -1)
 		return -EAGAIN;
 
 	x86_perf_event_set_period(event);
+	cpuc->events[idx] = event;
+	__set_bit(idx, cpuc->active_mask);
 	x86_pmu.enable(event);
+	perf_event_update_userpage(event);
 
 	return 0;
 }
