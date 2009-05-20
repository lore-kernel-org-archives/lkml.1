Return-Path: <linux-kernel-owner+w=401wt.eu-S1755819AbZETK0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819AbZETK0y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 06:26:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756243AbZETK0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 06:26:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:40898 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756747AbZETK0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 06:26:39 -0400
Message-Id: <20090520102553.388185031@chello.nl>
References: <20090520102118.377477360@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 20 May 2009 12:21:21 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       John Kacur <jkacur@redhat.com>
Subject: [PATCH 3/4] perf_counter: optimize disable of time based sw counters
Content-Disposition: inline; filename=perf_counter-opt-swcounter-disable-hrtimer.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we call hrtimer_cancel() unconditionally on disable of time based
software counters. Avoid when possible.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_counter.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -2716,7 +2716,8 @@ static int cpu_clock_perf_counter_enable
 
 static void cpu_clock_perf_counter_disable(struct perf_counter *counter)
 {
-	hrtimer_cancel(&counter->hw.hrtimer);
+	if (counter->hw.irq_period)
+		hrtimer_cancel(&counter->hw.hrtimer);
 	cpu_clock_perf_counter_update(counter);
 }
 
@@ -2767,7 +2768,8 @@ static int task_clock_perf_counter_enabl
 
 static void task_clock_perf_counter_disable(struct perf_counter *counter)
 {
-	hrtimer_cancel(&counter->hw.hrtimer);
+	if (counter->hw.irq_period)
+		hrtimer_cancel(&counter->hw.hrtimer);
 	task_clock_perf_counter_update(counter, counter->ctx->time);
 
 }

-- 

