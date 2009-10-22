Return-Path: <linux-kernel-owner+w=401wt.eu-S1756718AbZJVQrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718AbZJVQrR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 12:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755595AbZJVQrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 12:47:16 -0400
Received: from nfitmail.nfit.au.dk ([130.225.31.129]:22503 "EHLO
	smtp.nfit.au.dk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755429AbZJVQrP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 12:47:15 -0400
From: Soeren Sandmann <sandmann@daimi.au.dk>
Subject: [PATCH 1/2 -tip] perf: Keep track of remaining time when enabling/disabling swevent hrtimers
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Date: 22 Oct 2009 18:47:19 +0200
Message-ID: <ye8fx9bml48.fsf@camel16.daimi.au.dk>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-NFIT-RelayAddr: 130.225.16.135
X-NFIT-Solido-Score: 0.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[I don't think this mail got through the first time]

Hi,

These patches against perf/core make the hrtimer based events work for
sysprof.

1/2: Don't restart the timer on every scheduler tick
2/2: If exclude_idle is set, don't report idle events

Thanks,                                                                         
Soren                                                                           


>From f3e9630ccee6c148ee9c5bc1632dfd0384969b2b Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?S=C3=B8ren=20Sandmann=20Pedersen?= <sandmann@redhat.com>
Date: Thu, 22 Oct 2009 09:51:35 -0400
Subject: [PATCH 1/2] perf: Keep track of remaining time when enabling/disabling swevent hrtimers
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Whenever a swevent is scheduled out, the hrtimer is canceled. When it
is scheduled back in, the timer is restarted. This happens every
scheduler tick, which means the timer never expired because it was
getting repeatedly restarted over and over with the same period.

To fix that, save the remaining time when disabling; when reenabling,
use that saved time as the period instead of the user-specified
sampling period.

Also, move the starting and stopping of the hrtimers to helper
functions instead of duplicating the code.

Signed-off-by: Søren Sandmann Pedersen <sandmann@redhat.com>
---
 include/linux/perf_event.h |    4 +-
 kernel/perf_event.c        |   64 +++++++++++++++++++++++++++++--------------
 2 files changed, 45 insertions(+), 23 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 2e6d95f..9e70126 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -471,8 +471,8 @@ struct hw_perf_event {
 			unsigned long	event_base;
 			int		idx;
 		};
-		union { /* software */
-			atomic64_t	count;
+		struct { /* software */
+			s64		remaining;
 			struct hrtimer	hrtimer;
 		};
 	};
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 9d0b5c6..b492c55 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -3969,6 +3969,43 @@ static enum hrtimer_restart perf_swevent_hrtimer(struct hrtimer *hrtimer)
 	return ret;
 }
 
+static void perf_swevent_start_hrtimer(struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+
+	hrtimer_init(&hwc->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	hwc->hrtimer.function = perf_swevent_hrtimer;
+	if (hwc->sample_period) {
+		u64 period;
+
+		if (hwc->remaining) {
+			if (hwc->remaining < 0)
+				period = 10000;
+			else
+				period = hwc->remaining;
+			hwc->remaining = 0;
+		}
+		else {
+			period = max_t(u64, 10000, hwc->sample_period);
+		}
+		__hrtimer_start_range_ns(&hwc->hrtimer,
+				ns_to_ktime(period), 0,
+				HRTIMER_MODE_REL, 0);
+	}
+}
+
+static void perf_swevent_cancel_hrtimer(struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+
+	if (hwc->sample_period) {
+		ktime_t remaining = hrtimer_get_remaining(&hwc->hrtimer);
+		hwc->remaining = ktime_to_ns(remaining);
+
+		hrtimer_cancel(&hwc->hrtimer);
+	}
+}
+
 /*
  * Software event: cpu wall time clock
  */
@@ -3991,22 +4028,14 @@ static int cpu_clock_perf_event_enable(struct perf_event *event)
 	int cpu = raw_smp_processor_id();
 
 	atomic64_set(&hwc->prev_count, cpu_clock(cpu));
-	hrtimer_init(&hwc->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
-	hwc->hrtimer.function = perf_swevent_hrtimer;
-	if (hwc->sample_period) {
-		u64 period = max_t(u64, 10000, hwc->sample_period);
-		__hrtimer_start_range_ns(&hwc->hrtimer,
-				ns_to_ktime(period), 0,
-				HRTIMER_MODE_REL, 0);
-	}
-
+	perf_swevent_start_hrtimer(event);
+	
 	return 0;
 }
 
 static void cpu_clock_perf_event_disable(struct perf_event *event)
 {
-	if (event->hw.sample_period)
-		hrtimer_cancel(&event->hw.hrtimer);
+	perf_swevent_cancel_hrtimer(event);
 	cpu_clock_perf_event_update(event);
 }
 
@@ -4043,22 +4072,15 @@ static int task_clock_perf_event_enable(struct perf_event *event)
 	now = event->ctx->time;
 
 	atomic64_set(&hwc->prev_count, now);
-	hrtimer_init(&hwc->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
-	hwc->hrtimer.function = perf_swevent_hrtimer;
-	if (hwc->sample_period) {
-		u64 period = max_t(u64, 10000, hwc->sample_period);
-		__hrtimer_start_range_ns(&hwc->hrtimer,
-				ns_to_ktime(period), 0,
-				HRTIMER_MODE_REL, 0);
-	}
+
+	perf_swevent_start_hrtimer(event);
 
 	return 0;
 }
 
 static void task_clock_perf_event_disable(struct perf_event *event)
 {
-	if (event->hw.sample_period)
-		hrtimer_cancel(&event->hw.hrtimer);
+	perf_swevent_cancel_hrtimer(event);
 	task_clock_perf_event_update(event, event->ctx->time);
 
 }
-- 
1.6.5.rc2

