Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933539Ab0BZKZw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 05:25:52 -0500
Received: from hera.kernel.org ([140.211.167.34]:34386 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933406Ab0BZKZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 05:25:45 -0500
Date: Fri, 26 Feb 2010 10:25:06 GMT
From: tip-bot for Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4b703875.0a04d00a.7896.ffffb824@mx.google.com>
References: <4b703875.0a04d00a.7896.ffffb824@mx.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf_events: Add new start/stop PMU callbacks
Message-ID: <tip-d76a0812ac4139ceb54daab3cc70e1bd8bd9d43a@git.kernel.org>
Git-Commit-ID: d76a0812ac4139ceb54daab3cc70e1bd8bd9d43a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Feb 2010 10:25:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d76a0812ac4139ceb54daab3cc70e1bd8bd9d43a
Gitweb:     http://git.kernel.org/tip/d76a0812ac4139ceb54daab3cc70e1bd8bd9d43a
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Mon, 8 Feb 2010 17:06:01 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 26 Feb 2010 10:56:53 +0100

perf_events: Add new start/stop PMU callbacks

In certain situations, the kernel may need to stop and start the same
event rapidly. The current PMU callbacks do not distinguish between stop
and release (i.e., stop + free the resource). Thus, a counter may be
released, then it will be immediately re-acquired. Event scheduling will
again take place with no guarantee to assign the same counter. On some
processors, this may event yield to failure to assign the event back due
to competion between cores.

This patch is adding a new pair of callback to stop and restart a counter
without actually release the underlying counter resource. On stop, the
counter is stopped, its values saved and that's it. On start, the value
is reloaded and counter is restarted (on x86, actual restart is delayed
until perf_enable()).

Signed-off-by: Stephane Eranian <eranian@google.com>
[ added fallback to ->enable/->disable for all other PMUs
  fixed x86_pmu_start() to call x86_pmu.enable()
  merged __x86_pmu_disable into x86_pmu_stop() ]
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <4b703875.0a04d00a.7896.ffffb824@mx.google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c |   24 ++++++++++++++++++++----
 include/linux/perf_event.h       |    2 ++
 kernel/perf_event.c              |   20 ++++++++++++++++++--
 3 files changed, 40 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index a920f17..9173ea9 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1495,7 +1495,7 @@ static inline int match_prev_assignment(struct hw_perf_event *hwc,
 		hwc->last_tag == cpuc->tags[i];
 }
 
-static void __x86_pmu_disable(struct perf_event *event, struct cpu_hw_events *cpuc);
+static void x86_pmu_stop(struct perf_event *event);
 
 void hw_perf_enable(void)
 {
@@ -1533,7 +1533,7 @@ void hw_perf_enable(void)
 			    match_prev_assignment(hwc, cpuc, i))
 				continue;
 
-			__x86_pmu_disable(event, cpuc);
+			x86_pmu_stop(event);
 
 			hwc->idx = -1;
 		}
@@ -1801,6 +1801,19 @@ static int x86_pmu_enable(struct perf_event *event)
 	return 0;
 }
 
+static int x86_pmu_start(struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+
+	if (hwc->idx == -1)
+		return -EAGAIN;
+
+	x86_perf_event_set_period(event, hwc, hwc->idx);
+	x86_pmu.enable(hwc, hwc->idx);
+
+	return 0;
+}
+
 static void x86_pmu_unthrottle(struct perf_event *event)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
@@ -1924,8 +1937,9 @@ static void intel_pmu_drain_bts_buffer(struct cpu_hw_events *cpuc)
 	event->pending_kill = POLL_IN;
 }
 
-static void __x86_pmu_disable(struct perf_event *event, struct cpu_hw_events *cpuc)
+static void x86_pmu_stop(struct perf_event *event)
 {
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
 	int idx = hwc->idx;
 
@@ -1954,7 +1968,7 @@ static void x86_pmu_disable(struct perf_event *event)
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	int i;
 
-	__x86_pmu_disable(event, cpuc);
+	x86_pmu_stop(event);
 
 	for (i = 0; i < cpuc->n_events; i++) {
 		if (event == cpuc->event_list[i]) {
@@ -2667,6 +2681,8 @@ static inline void x86_pmu_read(struct perf_event *event)
 static const struct pmu pmu = {
 	.enable		= x86_pmu_enable,
 	.disable	= x86_pmu_disable,
+	.start		= x86_pmu_start,
+	.stop		= x86_pmu_stop,
 	.read		= x86_pmu_read,
 	.unthrottle	= x86_pmu_unthrottle,
 };
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 071a7db..b08dfda 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -513,6 +513,8 @@ struct perf_event;
 struct pmu {
 	int (*enable)			(struct perf_event *event);
 	void (*disable)			(struct perf_event *event);
+	int (*start)			(struct perf_event *event);
+	void (*stop)			(struct perf_event *event);
 	void (*read)			(struct perf_event *event);
 	void (*unthrottle)		(struct perf_event *event);
 };
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 5a69abb..74c6002 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1493,6 +1493,22 @@ do {					\
 	return div64_u64(dividend, divisor);
 }
 
+static void perf_event_stop(struct perf_event *event)
+{
+	if (!event->pmu->stop)
+		return event->pmu->disable(event);
+
+	return event->pmu->stop(event);
+}
+
+static int perf_event_start(struct perf_event *event)
+{
+	if (!event->pmu->start)
+		return event->pmu->enable(event);
+
+	return event->pmu->start(event);
+}
+
 static void perf_adjust_period(struct perf_event *event, u64 nsec, u64 count)
 {
 	struct hw_perf_event *hwc = &event->hw;
@@ -1513,9 +1529,9 @@ static void perf_adjust_period(struct perf_event *event, u64 nsec, u64 count)
 
 	if (atomic64_read(&hwc->period_left) > 8*sample_period) {
 		perf_disable();
-		event->pmu->disable(event);
+		perf_event_stop(event);
 		atomic64_set(&hwc->period_left, 0);
-		event->pmu->enable(event);
+		perf_event_start(event);
 		perf_enable();
 	}
 }
