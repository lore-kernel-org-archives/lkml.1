Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361Ab0BINAx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 08:00:53 -0500
Received: from casper.infradead.org ([85.118.1.10]:33083 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561Ab0BINAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 08:00:51 -0500
Subject: Re: [RFC][PATCH] perf_events: added new start/stop PMU callbacks
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       davem@davemloft.net, fweisbec@gmail.com, robert.richter@amd.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
In-Reply-To: <bd4cb8901002080921p311e29fbmcdf0841b0af558a@mail.gmail.com>
References: <4b703875.0a04d00a.7896.ffffb824@mx.google.com>
	 <1265646612.11509.13.camel@laptop>
	 <bd4cb8901002080921p311e29fbmcdf0841b0af558a@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Feb 2010 14:00:38 +0100
Message-ID: <1265720438.11509.241.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-08 at 18:21 +0100, Stephane Eranian wrote:
> 
> Not sure why it's easier. It saves memory for sure, but that problem
> is independent of the issue I was trying to address.

You're right, the thing I had overlooked is that delaying that release
will mess up the constraints for new events.

OK, lets go with this, we can do all other architectures by doing a
fallback to enable/disable, because for everything except the new AMD
code that is still correct. If at some time in the future start/stop
becomes something that will be called frequently, architectures can
provide optimized versions that by-pass the constraint checking (the
current use is rare).

---
Subject: perf_events: Add new start/stop PMU callbacks
From: Stephane Eranian <eranian@google.com>
Date: Mon, 8 Feb 2010 17:06:01 +0200

In certain situations, the kernel may need to stop and start the
same event rapidly. The current PMU callbacks do not distinguish
between stop and release  (i.e., stop + free the resource). Thus,
a counter may be released, then it will be immediately re-acquired.
Event scheduling will again take place with no guarantee to assign
the same counter. On some processors, this may event yield to failure
to assign the event back due to competion between cores.

This patch is adding a new pair of callback to stop and restart a
counter without actually release the underlying counter resource.
On stop, the counter is stopped, its values saved and that's it.
On start, the value is reloaded and counter is restarted (on x86,
actual restart is delayed until perf_enable()).

Signed-off-by: Stephane Eranian <eranian@google.com>
[ added fallback to ->enable/->disable for all other PMUs 
  fixed x86_pmu_start() to call x86_pmu.enable() 
  merged __x86_pmu_disable into x86_pmu_stop() ]
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <4b703875.0a04d00a.7896.ffffb824@mx.google.com>
---
 arch/x86/kernel/cpu/perf_event.c |   24 ++++++++++++++++++++----
 include/linux/perf_event.h       |    2 ++
 kernel/perf_event.c              |   20 ++++++++++++++++++--
 3 files changed, 40 insertions(+), 6 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
@@ -1495,7 +1495,7 @@ static inline int match_prev_assignment(
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
@@ -1801,6 +1801,19 @@ static int x86_pmu_enable(struct perf_ev
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
@@ -1924,8 +1937,9 @@ static void intel_pmu_drain_bts_buffer(s
 	event->pending_kill = POLL_IN;
 }
 
-static void __x86_pmu_disable(struct perf_event *event, struct cpu_hw_events *cpuc)
+static void x86_pmu_stop(struct perf_event *event)
 {
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
 	int idx = hwc->idx;
 
@@ -1954,7 +1968,7 @@ static void x86_pmu_disable(struct perf_
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	int i;
 
-	__x86_pmu_disable(event, cpuc);
+	x86_pmu_stop(event);
 
 	for (i = 0; i < cpuc->n_events; i++) {
 		if (event == cpuc->event_list[i]) {
@@ -2667,6 +2681,8 @@ static inline void x86_pmu_read(struct p
 static const struct pmu pmu = {
 	.enable		= x86_pmu_enable,
 	.disable	= x86_pmu_disable,
+	.start		= x86_pmu_start,
+	.stop		= x86_pmu_stop,
 	.read		= x86_pmu_read,
 	.unthrottle	= x86_pmu_unthrottle,
 };
Index: linux-2.6/include/linux/perf_event.h
===================================================================
--- linux-2.6.orig/include/linux/perf_event.h
+++ linux-2.6/include/linux/perf_event.h
@@ -511,6 +511,8 @@ struct perf_event;
 struct pmu {
 	int (*enable)			(struct perf_event *event);
 	void (*disable)			(struct perf_event *event);
+	int (*start)			(struct perf_event *event);
+	void (*stop)			(struct perf_event *event);
 	void (*read)			(struct perf_event *event);
 	void (*unthrottle)		(struct perf_event *event);
 };
Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
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
@@ -1513,9 +1529,9 @@ static void perf_adjust_period(struct pe
 
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


