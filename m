Return-Path: <linux-kernel-owner+w=401wt.eu-S1756165AbZDFJpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165AbZDFJpm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 05:45:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755477AbZDFJoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 05:44:38 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34356 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755001AbZDFJof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 05:44:35 -0400
Message-Id: <20090406094518.266679874@chello.nl>
References: <20090406094458.977814421@chello.nl>
User-Agent: quilt/0.46-1
Date: Mon, 06 Apr 2009 11:45:09 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 11/15] perf_counter: change event defenition
Content-Disposition: inline; filename=perf_counter-event-def.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the definition of an event is slightly ambiguous. We have
wakeup events, for poll() and SIGIO, which are either generated
when a record crosses a page boundary (hw_events.wakeup_events == 0),
or every wakeup_events new records.

Now a record can be either an counter overflow record, or a number of
different things, like the mmap PROT_EXEC region notifications.

Then there is the PERF_COUNTER_IOC_REFRESH event limit, which only
considers counter overflows.

This patch changes then wakeup_events and SIGIO notification to only
consider overflow events. Furthermore it changes the SIGIO notification
to report SIGHUP when the event limit is reached and the counter will
be disabled.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_counter.h |    1 +
 kernel/perf_counter.c        |   22 +++++++++++++++-------
 2 files changed, 16 insertions(+), 7 deletions(-)

Index: linux-2.6/include/linux/perf_counter.h
===================================================================
--- linux-2.6.orig/include/linux/perf_counter.h
+++ linux-2.6/include/linux/perf_counter.h
@@ -439,6 +439,7 @@ struct perf_counter {
 
 	/* delayed work for NMIs and such */
 	int				pending_wakeup;
+	int				pending_kill;
 	int				pending_disable;
 	struct perf_pending_entry	pending;
 
Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -1596,7 +1596,11 @@ void perf_counter_wakeup(struct perf_cou
 	rcu_read_unlock();
 
 	wake_up_all(&counter->waitq);
-	kill_fasync(&counter->fasync, SIGIO, POLL_IN);
+
+	if (counter->pending_kill) {
+		kill_fasync(&counter->fasync, SIGIO, counter->pending_kill);
+		counter->pending_kill = 0;
+	}
 }
 
 /*
@@ -1727,6 +1731,7 @@ struct perf_output_handle {
 	unsigned int		head;
 	int			wakeup;
 	int			nmi;
+	int			overflow;
 };
 
 static inline void __perf_output_wakeup(struct perf_output_handle *handle)
@@ -1741,7 +1746,7 @@ static inline void __perf_output_wakeup(
 
 static int perf_output_begin(struct perf_output_handle *handle,
 			     struct perf_counter *counter, unsigned int size,
-			     int nmi)
+			     int nmi, int overflow)
 {
 	struct perf_mmap_data *data;
 	unsigned int offset, head;
@@ -1751,8 +1756,9 @@ static int perf_output_begin(struct perf
 	if (!data)
 		goto out;
 
-	handle->counter	= counter;
-	handle->nmi	= nmi;
+	handle->counter	 = counter;
+	handle->nmi	 = nmi;
+	handle->overflow = overflow;
 
 	if (!data->nr_pages)
 		goto fail;
@@ -1816,7 +1822,7 @@ static void perf_output_end(struct perf_
 {
 	int wakeup_events = handle->counter->hw_event.wakeup_events;
 
-	if (wakeup_events) {
+	if (handle->overflow && wakeup_events) {
 		int events = atomic_inc_return(&handle->data->events);
 		if (events >= wakeup_events) {
 			atomic_sub(wakeup_events, &handle->data->events);
@@ -1891,7 +1897,7 @@ static void perf_counter_output(struct p
 		header.size += sizeof(u64);
 	}
 
-	ret = perf_output_begin(&handle, counter, header.size, nmi);
+	ret = perf_output_begin(&handle, counter, header.size, nmi, 1);
 	if (ret)
 		return;
 
@@ -1955,7 +1961,7 @@ static void perf_counter_mmap_output(str
 {
 	struct perf_output_handle handle;
 	int size = mmap_event->event.header.size;
-	int ret = perf_output_begin(&handle, counter, size, 0);
+	int ret = perf_output_begin(&handle, counter, size, 0, 0);
 
 	if (ret)
 		return;
@@ -2084,8 +2090,10 @@ int perf_counter_overflow(struct perf_co
 	int events = atomic_read(&counter->event_limit);
 	int ret = 0;
 
+	counter->pending_kill = POLL_IN;
 	if (events && atomic_dec_and_test(&counter->event_limit)) {
 		ret = 1;
+		counter->pending_kill = POLL_HUP;
 		if (nmi) {
 			counter->pending_disable = 1;
 			perf_pending_queue(&counter->pending,

-- 

