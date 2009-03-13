Return-Path: <linux-kernel-owner+w=401wt.eu-S1758778AbZCMQLJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758778AbZCMQLJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 12:11:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758068AbZCMQKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 12:10:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:41496 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757942AbZCMQKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 12:10:34 -0400
Date: Fri, 13 Mar 2009 16:09:43 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1236959027.22447.149.camel@twins>
References: <1236959027.22447.149.camel@twins>
Subject: [tip:perfcounters/core] perf_counter: fix hrtimer sampling
Message-ID: <tip-a27cdc586523eec54717c8c56ff079b3869770d2@git.kernel.org>
Git-Commit-ID: a27cdc586523eec54717c8c56ff079b3869770d2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 13 Mar 2009 16:09:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a27cdc586523eec54717c8c56ff079b3869770d2
Gitweb:     http://git.kernel.org/tip/a27cdc586523eec54717c8c56ff079b3869770d2
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 13 Mar 2009 16:43:47 +0100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 13 Mar 2009 16:59:00 +0100

perf_counter: fix hrtimer sampling

Impact: fix deadlock with perfstat

Fix for the perfstat fubar..

We cannot unconditionally call hrtimer_cancel() without ever having done
hrtimer_init() on the thing.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1236959027.22447.149.camel@twins>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 8d6ecfa..d6cc222 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1571,9 +1571,9 @@ static int cpu_clock_perf_counter_enable(struct perf_counter *counter)
 	int cpu = raw_smp_processor_id();
 
 	atomic64_set(&hwc->prev_count, cpu_clock(cpu));
+	hrtimer_init(&hwc->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	hwc->hrtimer.function = perf_swcounter_hrtimer;
 	if (hwc->irq_period) {
-		hrtimer_init(&hwc->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
-		hwc->hrtimer.function = perf_swcounter_hrtimer;
 		__hrtimer_start_range_ns(&hwc->hrtimer,
 				ns_to_ktime(hwc->irq_period), 0,
 				HRTIMER_MODE_REL, 0);
@@ -1635,9 +1635,9 @@ static int task_clock_perf_counter_enable(struct perf_counter *counter)
 	struct hw_perf_counter *hwc = &counter->hw;
 
 	atomic64_set(&hwc->prev_count, task_clock_perf_counter_val(counter, 0));
+	hrtimer_init(&hwc->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	hwc->hrtimer.function = perf_swcounter_hrtimer;
 	if (hwc->irq_period) {
-		hrtimer_init(&hwc->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
-		hwc->hrtimer.function = perf_swcounter_hrtimer;
 		__hrtimer_start_range_ns(&hwc->hrtimer,
 				ns_to_ktime(hwc->irq_period), 0,
 				HRTIMER_MODE_REL, 0);
