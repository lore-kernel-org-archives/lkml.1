Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932753Ab0CKOn2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 09:43:28 -0500
Received: from hera.kernel.org ([140.211.167.34]:35597 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932675Ab0CKOnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 09:43:21 -0500
Date: Thu, 11 Mar 2010 14:41:18 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1268311069.5037.31.camel@laptop>
References: <1268311069.5037.31.camel@laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf, x86: Fix hw_perf_enable() event assignment
Message-ID: <tip-45e16a6834b6af098702e5ea6c9a40de42ff77d8@git.kernel.org>
Git-Commit-ID: 45e16a6834b6af098702e5ea6c9a40de42ff77d8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 11 Mar 2010 14:41:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  45e16a6834b6af098702e5ea6c9a40de42ff77d8
Gitweb:     http://git.kernel.org/tip/45e16a6834b6af098702e5ea6c9a40de42ff77d8
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 11 Mar 2010 13:40:30 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 11 Mar 2010 15:21:28 +0100

perf, x86: Fix hw_perf_enable() event assignment

What happens is that we schedule badly like:

<...>-1987  [019]   280.252808: x86_pmu_start: event-46/1300c0: idx: 0
<...>-1987  [019]   280.252811: x86_pmu_start: event-47/1300c0: idx: 1
<...>-1987  [019]   280.252812: x86_pmu_start: event-48/1300c0: idx: 2
<...>-1987  [019]   280.252813: x86_pmu_start: event-49/1300c0: idx: 3
<...>-1987  [019]   280.252814: x86_pmu_start: event-50/1300c0: idx: 32
<...>-1987  [019]   280.252825: x86_pmu_stop: event-46/1300c0: idx: 0
<...>-1987  [019]   280.252826: x86_pmu_stop: event-47/1300c0: idx: 1
<...>-1987  [019]   280.252827: x86_pmu_stop: event-48/1300c0: idx: 2
<...>-1987  [019]   280.252828: x86_pmu_stop: event-49/1300c0: idx: 3
<...>-1987  [019]   280.252829: x86_pmu_stop: event-50/1300c0: idx: 32
<...>-1987  [019]   280.252834: x86_pmu_start: event-47/1300c0: idx: 1
<...>-1987  [019]   280.252834: x86_pmu_start: event-48/1300c0: idx: 2
<...>-1987  [019]   280.252835: x86_pmu_start: event-49/1300c0: idx: 3
<...>-1987  [019]   280.252836: x86_pmu_start: event-50/1300c0: idx: 32
<...>-1987  [019]   280.252837: x86_pmu_start: event-51/1300c0: idx: 32 *FAIL*

This happens because we only iterate the n_running events in the first
pass, and reset their index to -1 if they don't match to force a
re-assignment.

Now, in our RR example, n_running == 0 because we fully unscheduled, so
event-50 will retain its idx==32, even though in scheduling it will have
gotten idx=0, and we don't trigger the re-assign path.

The easiest way to fix this is the below patch, which simply validates
the full assignment in the second pass.

Reported-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1268311069.5037.31.camel@laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c |   12 +++---------
 1 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index c6bde7d..5fb490c 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -811,7 +811,6 @@ void hw_perf_enable(void)
 		 * step2: reprogram moved events into new counters
 		 */
 		for (i = 0; i < n_running; i++) {
-
 			event = cpuc->event_list[i];
 			hwc = &event->hw;
 
@@ -826,21 +825,16 @@ void hw_perf_enable(void)
 				continue;
 
 			x86_pmu_stop(event);
-
-			hwc->idx = -1;
 		}
 
 		for (i = 0; i < cpuc->n_events; i++) {
-
 			event = cpuc->event_list[i];
 			hwc = &event->hw;
 
-			if (i < n_running &&
-			    match_prev_assignment(hwc, cpuc, i))
-				continue;
-
-			if (hwc->idx == -1)
+			if (!match_prev_assignment(hwc, cpuc, i))
 				x86_assign_hw_event(event, cpuc, i);
+			else if (i < n_running)
+				continue;
 
 			x86_pmu_start(event);
 		}
