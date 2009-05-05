Return-Path: <linux-kernel-owner+w=401wt.eu-S1758064AbZEEQTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758064AbZEEQTv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 12:19:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755510AbZEEQSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 12:18:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50001 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324AbZEEQSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 12:18:09 -0400
Message-Id: <20090505155437.331556171@chello.nl>
References: <20090505155020.309162852@chello.nl>
User-Agent: quilt/0.46-1
Date: Tue, 05 May 2009 17:50:26 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 6/7] perf_counter: inheritable sample counters
Content-Disposition: inline; filename=perf_counter-inherit.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Redirect the output to the parent counter and put in some sanity checks.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_counter.c |   32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -738,10 +738,18 @@ static void perf_counter_enable(struct p
 	spin_unlock_irq(&ctx->lock);
 }
 
-static void perf_counter_refresh(struct perf_counter *counter, int refresh)
+static int perf_counter_refresh(struct perf_counter *counter, int refresh)
 {
+	/*
+	 * not supported on inherited counters
+	 */
+	if (counter->hw_event.inherit)
+		return -EINVAL;
+
 	atomic_add(refresh, &counter->event_limit);
 	perf_counter_enable(counter);
+
+	return 0;
 }
 
 /*
@@ -1307,7 +1315,7 @@ static long perf_ioctl(struct file *file
 		perf_counter_disable_family(counter);
 		break;
 	case PERF_COUNTER_IOC_REFRESH:
-		perf_counter_refresh(counter, arg);
+		err = perf_counter_refresh(counter, arg);
 		break;
 	case PERF_COUNTER_IOC_RESET:
 		perf_counter_reset(counter);
@@ -1814,6 +1822,12 @@ static int perf_output_begin(struct perf
 	struct perf_mmap_data *data;
 	unsigned int offset, head;
 
+	/*
+	 * For inherited counters we send all the output towards the parent.
+	 */
+	if (counter->parent)
+		counter = counter->parent;
+
 	rcu_read_lock();
 	data = rcu_dereference(counter->data);
 	if (!data)
@@ -1995,6 +2009,9 @@ static void perf_counter_output(struct p
 	if (record_type & PERF_RECORD_ADDR)
 		perf_output_put(&handle, addr);
 
+	/*
+	 * XXX PERF_RECORD_GROUP vs inherited counters seems difficult.
+	 */
 	if (record_type & PERF_RECORD_GROUP) {
 		struct perf_counter *leader, *sub;
 		u64 nr = counter->nr_siblings;
@@ -2281,6 +2298,11 @@ int perf_counter_overflow(struct perf_co
 	int events = atomic_read(&counter->event_limit);
 	int ret = 0;
 
+	/*
+	 * XXX event_limit might not quite work as expected on inherited
+	 * counters
+	 */
+
 	counter->pending_kill = POLL_IN;
 	if (events && atomic_dec_and_test(&counter->event_limit)) {
 		ret = 1;
@@ -2801,6 +2823,12 @@ perf_counter_alloc(struct perf_counter_h
 
 	pmu = NULL;
 
+	/*
+	 * we currently do not support PERF_RECORD_GROUP on inherited counters
+	 */
+	if (hw_event->inherit && (hw_event->record_type & PERF_RECORD_GROUP))
+		goto done;
+
 	if (perf_event_raw(hw_event)) {
 		pmu = hw_perf_counter_init(counter);
 		goto done;

-- 

