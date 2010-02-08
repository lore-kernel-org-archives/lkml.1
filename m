Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674Ab0BHQOw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 11:14:52 -0500
Received: from smtp-out.google.com ([216.239.33.17]:57422 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890Ab0BHQOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 11:14:50 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:from:date:to:reply-to:cc:subject:x-system-of-record;
	b=a/J54n7HtcejwpFIIzpW2gfqS5otlOUh4KeHHTlttkeWeS0fOsUxIYsMl0Qxn7JNX
	5faMVh7NWhvUG942uRqCg==
Message-ID: <4b703875.0a04d00a.7896.ffffb824@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Mon, 8 Feb 2010 17:06:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       fweisbec@gmail.com, robert.richter@amd.com, perfmon2-devel@lists.sf.net,
       eranian@gmail.com, eranian@google.com
Subject: [RFC][PATCH] perf_events: added new start/stop PMU callbacks
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
	
	Note this patch does not provide support for non-X86 PMU. This needs
	to be added.

	Signed-off-by: Stephane Eranian <eranian@google.com>
--

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index a920f17..ea023cb 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1801,6 +1801,18 @@ static int x86_pmu_enable(struct perf_event *event)
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
+
+	return 0;
+}
+
 static void x86_pmu_unthrottle(struct perf_event *event)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
@@ -1949,12 +1961,19 @@ static void __x86_pmu_disable(struct perf_event *event, struct cpu_hw_events *cp
 	cpuc->events[idx] = NULL;
 }
 
+static void x86_pmu_stop(struct perf_event *event)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+
+	__x86_pmu_disable(event, cpuc);
+}
+
 static void x86_pmu_disable(struct perf_event *event)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	int i;
 
-	__x86_pmu_disable(event, cpuc);
+	x86_pmu_stop(event);
 
 	for (i = 0; i < cpuc->n_events; i++) {
 		if (event == cpuc->event_list[i]) {
@@ -1972,6 +1991,7 @@ static void x86_pmu_disable(struct perf_event *event)
 	perf_event_update_userpage(event);
 }
 
+
 /*
  * Save and restart an expired event. Called by NMI contexts,
  * so it has to be careful about preempting normal event ops:
@@ -2667,6 +2687,8 @@ static inline void x86_pmu_read(struct perf_event *event)
 static const struct pmu pmu = {
 	.enable		= x86_pmu_enable,
 	.disable	= x86_pmu_disable,
+	.start		= x86_pmu_start,
+	.stop		= x86_pmu_stop,
 	.read		= x86_pmu_read,
 	.unthrottle	= x86_pmu_unthrottle,
 };
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 14cf4b5..3bb9d1f 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -511,6 +511,8 @@ struct perf_event;
 struct pmu {
 	int (*enable)			(struct perf_event *event);
 	void (*disable)			(struct perf_event *event);
+	int (*start)			(struct perf_event *event);
+	void (*stop)			(struct perf_event *event);
 	void (*read)			(struct perf_event *event);
 	void (*unthrottle)		(struct perf_event *event);
 };
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index ab8a312..654dfb5 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1513,9 +1513,9 @@ static void perf_adjust_period(struct perf_event *event, u64 nsec, u64 count)
 
 	if (atomic64_read(&hwc->period_left) > 8*sample_period) {
 		perf_disable();
-		event->pmu->disable(event);
+		event->pmu->stop(event);
 		atomic64_set(&hwc->period_left, 0);
-		event->pmu->enable(event);
+		event->pmu->start(event);
 		perf_enable();
 	}
 }
