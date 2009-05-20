Return-Path: <linux-kernel-owner+w=401wt.eu-S1756990AbZETK1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756990AbZETK1X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 06:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756601AbZETK0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 06:26:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46305 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756854AbZETK0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 06:26:49 -0400
Message-Id: <20090520102553.298769743@chello.nl>
References: <20090520102118.377477360@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 20 May 2009 12:21:20 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       John Kacur <jkacur@redhat.com>
Subject: [PATCH 2/4] perf_counter: log irq_period changes
Content-Disposition: inline; filename=perf_counter-freq-notification.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the dynamic irq_period code, log whenever we change the period so that
analyzing code can normalize the event flow.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_counter.h |    8 ++++++++
 kernel/perf_counter.c        |   40 +++++++++++++++++++++++++++++++++++++++-
 2 files changed, 47 insertions(+), 1 deletion(-)

Index: linux-2.6/include/linux/perf_counter.h
===================================================================
--- linux-2.6.orig/include/linux/perf_counter.h
+++ linux-2.6/include/linux/perf_counter.h
@@ -258,6 +258,14 @@ enum perf_event_type {
 	PERF_EVENT_COMM			= 3,
 
 	/*
+	 * struct {
+	 * 	struct perf_event_header	header;
+	 * 	u64				irq_period;
+	 * };
+	 */
+	PERF_EVENT_PERIOD		= 4,
+
+	/*
 	 * When header.misc & PERF_EVENT_MISC_OVERFLOW the event_type field
 	 * will be PERF_RECORD_*
 	 *
Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -1046,7 +1046,9 @@ int perf_counter_task_enable(void)
 	return 0;
 }
 
-void perf_adjust_freq(struct perf_counter_context *ctx)
+static void perf_log_period(struct perf_counter *counter, u64 period);
+
+static void perf_adjust_freq(struct perf_counter_context *ctx)
 {
 	struct perf_counter *counter;
 	u64 irq_period;
@@ -1072,6 +1074,8 @@ void perf_adjust_freq(struct perf_counte
 		if (!irq_period)
 			irq_period = 1;
 
+		perf_log_period(counter, irq_period);
+
 		counter->hw.irq_period = irq_period;
 		counter->hw.interrupts = 0;
 	}
@@ -2407,6 +2411,40 @@ void perf_counter_munmap(unsigned long a
 }
 
 /*
+ *
+ */
+
+static void perf_log_period(struct perf_counter *counter, u64 period)
+{
+	struct perf_output_handle handle;
+	int ret;
+
+	struct {
+		struct perf_event_header	header;
+		u64				time;
+		u64				period;
+	} freq_event = {
+		.header = {
+			.type = PERF_EVENT_PERIOD,
+			.misc = 0,
+			.size = sizeof(freq_event),
+		},
+		.time = sched_clock(),
+		.period = period,
+	};
+
+	if (counter->hw.irq_period == period)
+		return;
+
+	ret = perf_output_begin(&handle, counter, sizeof(freq_event), 0, 0);
+	if (ret)
+		return;
+
+	perf_output_put(&handle, freq_event);
+	perf_output_end(&handle);
+}
+
+/*
  * Generic counter overflow handling.
  */
 

-- 

