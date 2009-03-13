Return-Path: <linux-kernel-owner+w=401wt.eu-S1758130AbZCMPoI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758130AbZCMPoI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 11:44:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753630AbZCMPny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 11:43:54 -0400
Received: from viefep16-int.chello.at ([62.179.121.36]:5118 "EHLO
	viefep16-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231AbZCMPnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 11:43:53 -0400
X-SourceIP: 213.93.53.227
Subject: [PATCH 10.5/11] perf_counter: fix hrtimer sampling
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu
Cc: paulus@samba.org, tglx@linutronix.de, linux-kernel@vger.kernel.org
In-Reply-To: <20090313112301.862384083@chello.nl>
References: <20090313112125.886730125@chello.nl>
	 <20090313112301.862384083@chello.nl>
Content-Type: text/plain
Date: Fri, 13 Mar 2009 16:43:47 +0100
Message-Id: <1236959027.22447.149.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix for the perfstat fubar..

We cannot unconditionally call hrtimer_cancel() without ever having done
hrtimer_init() on the thing.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -1565,9 +1565,9 @@ static int cpu_clock_perf_counter_enable
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
@@ -1629,9 +1629,9 @@ static int task_clock_perf_counter_enabl
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


