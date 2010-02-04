Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758172Ab0BDJ6L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 04:58:11 -0500
Received: from hera.kernel.org ([140.211.167.34]:60189 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758160Ab0BDJ6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 04:58:04 -0500
Date: Thu, 4 Feb 2010 09:57:28 GMT
From: tip-bot for Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       eranian@google.com, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4b66dc67.0b38560a.1635.ffffae18@mx.google.com>
References: <4b66dc67.0b38560a.1635.ffffae18@mx.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf_events, x86: Fix bug in hw_perf_enable()
Message-ID: <tip-447a194b393f32699607fd99617a40abd6a95114@git.kernel.org>
Git-Commit-ID: 447a194b393f32699607fd99617a40abd6a95114
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 04 Feb 2010 09:57:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  447a194b393f32699607fd99617a40abd6a95114
Gitweb:     http://git.kernel.org/tip/447a194b393f32699607fd99617a40abd6a95114
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Mon, 1 Feb 2010 14:50:01 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 4 Feb 2010 09:59:50 +0100

perf_events, x86: Fix bug in hw_perf_enable()

We cannot assume that because hwc->idx == assign[i], we can avoid
reprogramming the counter in hw_perf_enable().

The event may have been scheduled out and another event may have been
programmed into this counter. Thus, we need a more robust way of
verifying if the counter still contains config/data related to an event.

This patch adds a generation number to each counter on each cpu. Using
this mechanism we can verify reliabilty whether the content of a counter
corresponds to an event.

Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <4b66dc67.0b38560a.1635.ffffae18@mx.google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c |   34 ++++++++++++++++++++++++++++------
 include/linux/perf_event.h       |    2 ++
 2 files changed, 30 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 96cfc1a..a920f17 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -90,6 +90,7 @@ struct cpu_hw_events {
 	int			n_events;
 	int			n_added;
 	int			assign[X86_PMC_IDX_MAX]; /* event to counter assignment */
+	u64			tags[X86_PMC_IDX_MAX];
 	struct perf_event	*event_list[X86_PMC_IDX_MAX]; /* in enabled order */
 };
 
@@ -1142,6 +1143,8 @@ static int __hw_perf_event_init(struct perf_event *event)
 	hwc->config = ARCH_PERFMON_EVENTSEL_INT;
 
 	hwc->idx = -1;
+	hwc->last_cpu = -1;
+	hwc->last_tag = ~0ULL;
 
 	/*
 	 * Count user and OS events unless requested not to.
@@ -1457,11 +1460,14 @@ static int collect_events(struct cpu_hw_events *cpuc, struct perf_event *leader,
 	return n;
 }
 
-
 static inline void x86_assign_hw_event(struct perf_event *event,
-				struct hw_perf_event *hwc, int idx)
+				struct cpu_hw_events *cpuc, int i)
 {
-	hwc->idx = idx;
+	struct hw_perf_event *hwc = &event->hw;
+
+	hwc->idx = cpuc->assign[i];
+	hwc->last_cpu = smp_processor_id();
+	hwc->last_tag = ++cpuc->tags[i];
 
 	if (hwc->idx == X86_PMC_IDX_FIXED_BTS) {
 		hwc->config_base = 0;
@@ -1480,6 +1486,15 @@ static inline void x86_assign_hw_event(struct perf_event *event,
 	}
 }
 
+static inline int match_prev_assignment(struct hw_perf_event *hwc,
+					struct cpu_hw_events *cpuc,
+					int i)
+{
+	return hwc->idx == cpuc->assign[i] &&
+		hwc->last_cpu == smp_processor_id() &&
+		hwc->last_tag == cpuc->tags[i];
+}
+
 static void __x86_pmu_disable(struct perf_event *event, struct cpu_hw_events *cpuc);
 
 void hw_perf_enable(void)
@@ -1508,7 +1523,14 @@ void hw_perf_enable(void)
 			event = cpuc->event_list[i];
 			hwc = &event->hw;
 
-			if (hwc->idx == -1 || hwc->idx == cpuc->assign[i])
+			/*
+			 * we can avoid reprogramming counter if:
+			 * - assigned same counter as last time
+			 * - running on same CPU as last time
+			 * - no other event has used the counter since
+			 */
+			if (hwc->idx == -1 ||
+			    match_prev_assignment(hwc, cpuc, i))
 				continue;
 
 			__x86_pmu_disable(event, cpuc);
@@ -1522,12 +1544,12 @@ void hw_perf_enable(void)
 			hwc = &event->hw;
 
 			if (hwc->idx == -1) {
-				x86_assign_hw_event(event, hwc, cpuc->assign[i]);
+				x86_assign_hw_event(event, cpuc, i);
 				x86_perf_event_set_period(event, hwc, hwc->idx);
 			}
 			/*
 			 * need to mark as active because x86_pmu_disable()
-			 * clear active_mask and eventsp[] yet it preserves
+			 * clear active_mask and events[] yet it preserves
 			 * idx
 			 */
 			set_bit(hwc->idx, cpuc->active_mask);
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 556b0f4..071a7db 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -478,9 +478,11 @@ struct hw_perf_event {
 	union {
 		struct { /* hardware */
 			u64		config;
+			u64		last_tag;
 			unsigned long	config_base;
 			unsigned long	event_base;
 			int		idx;
+			int		last_cpu;
 		};
 		struct { /* software */
 			s64		remaining;
