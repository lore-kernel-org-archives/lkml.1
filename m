Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab0BANvq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 08:51:46 -0500
Received: from smtp-out.google.com ([216.239.44.51]:61589 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023Ab0BANvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 08:51:45 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:from:date:to:reply-to:cc:subject:x-system-of-record;
	b=h1rZtfdYLp/ybzo5TWlDZEKGjp/KEblYrg9Q1Cqh/tKWIOpIRuTg8D7J5AC9Nezgh
	Ey36TzFk8LSjZjZnN8/pg==
Message-ID: <4b66dc67.0b38560a.1635.ffffae18@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Mon, 1 Feb 2010 14:50:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       fweisbec@gmail.com, robert.richter@amd.com, perfmon2-devel@lists.sf.net,
       eranian@gmail.com, eranian@google.com
Subject: [PATCH]  perf_events: fix bug in hw_perf_enable()
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	We cannot assume that because hwc->idx == assign[i], we
	can avoid reprogramming the counter in hw_perf_enable().

	The event may have been scheduled out and another event
	may have been programmed into this counter. Thus, we need
	a more robust way of verifying if the counter still
	contains config/data related to an event.

	This patch adds a generation number to each counter on each
	cpu. Using this mechanism we can verify reliabilty whether the
	content of a counter corresponds to an event.

	Signed-off-by: Stephane Eranian <eranian@google.com>
--
 arch/x86/kernel/cpu/perf_event.c |   38 ++++++++++++++++++++++++++++++--------
 include/linux/perf_event.h       |    2 ++
 2 files changed, 32 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 1846ead..c87bf1e 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -90,6 +90,7 @@ struct cpu_hw_events {
 	int			n_events;
 	int			n_added;
 	int			assign[X86_PMC_IDX_MAX]; /* event to counter assignment */
+	u64			tags[X86_PMC_IDX_MAX];
 	struct perf_event	*event_list[X86_PMC_IDX_MAX]; /* in enabled order */
 };
 
@@ -1128,6 +1129,8 @@ static int __hw_perf_event_init(struct perf_event *event)
 	hwc->config = ARCH_PERFMON_EVENTSEL_INT;
 
 	hwc->idx = -1;
+	hwc->last_cpu = -1;
+	hwc->last_tag = ~0ULL;
 
 	/*
 	 * Count user and OS events unless requested not to.
@@ -1443,11 +1446,14 @@ static int collect_events(struct cpu_hw_events *cpuc, struct perf_event *leader,
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
@@ -1466,6 +1472,15 @@ static inline void x86_assign_hw_event(struct perf_event *event,
 	}
 }
 
+static inline int match_prev_assignment(struct hw_perf_event *hwc,
+					struct cpu_hw_events *cpuc,
+					int i)
+{
+	return hwc->idx == cpuc->assign[i]
+	 && hwc->last_cpu == smp_processor_id()
+	 && hwc->last_tag == cpuc->tags[i];
+}
+
 static void __x86_pmu_disable(struct perf_event *event, struct cpu_hw_events *cpuc);
 
 void hw_perf_enable(void)
@@ -1494,8 +1509,15 @@ void hw_perf_enable(void)
 			event = cpuc->event_list[i];
 			hwc = &event->hw;
 
-			if (hwc->idx == -1 || hwc->idx == cpuc->assign[i])
-				continue;
+			/*
+			 * we can avoid reprogramming counter if:
+			 * - assigned same counter as last time
+			 * - running on same CPU as last time
+			 * - no other event has used the counter since
+			 */
+			if (hwc->idx == -1
+			    || match_prev_assignment(hwc, cpuc, i))
+                                continue;
 
 			__x86_pmu_disable(event, cpuc);
 
@@ -1508,12 +1530,12 @@ void hw_perf_enable(void)
 			hwc = &event->hw;
 
 			if (hwc->idx == -1) {
-				x86_assign_hw_event(event, hwc, cpuc->assign[i]);
-				x86_perf_event_set_period(event, hwc, hwc->idx);
+				x86_assign_hw_event(event, cpuc, i);
+ 				x86_perf_event_set_period(event, hwc, hwc->idx);
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
