Return-Path: <linux-kernel-owner+w=401wt.eu-S1751972AbZDGJLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972AbZDGJLW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 05:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756058AbZDGJJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 05:09:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:47091 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756021AbZDGJJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 05:09:34 -0400
Date: Tue, 7 Apr 2009 09:08:48 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20090406094518.266679874@chello.nl>
References: <20090406094518.266679874@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: change event definition
Message-ID: <tip-4c9e25428ff46b968a30f1dfafdba550cb6e4141@git.kernel.org>
Git-Commit-ID: 4c9e25428ff46b968a30f1dfafdba550cb6e4141
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 07 Apr 2009 09:08:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4c9e25428ff46b968a30f1dfafdba550cb6e4141
Gitweb:     http://git.kernel.org/tip/4c9e25428ff46b968a30f1dfafdba550cb6e4141
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 6 Apr 2009 11:45:09 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 7 Apr 2009 10:48:59 +0200

perf_counter: change event definition

Currently the definition of an event is slightly ambiguous. We have
wakeup events, for poll() and SIGIO, which are either generated
when a record crosses a page boundary (hw_events.wakeup_events == 0),
or every wakeup_events new records.

Now a record can be either a counter overflow record, or a number of
different things, like the mmap PROT_EXEC region notifications.

Then there is the PERF_COUNTER_IOC_REFRESH event limit, which only
considers counter overflows.

This patch changes then wakeup_events and SIGIO notification to only
consider overflow events. Furthermore it changes the SIGIO notification
to report SIGHUP when the event limit is reached and the counter will
be disabled.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
LKML-Reference: <20090406094518.266679874@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |    1 +
 kernel/perf_counter.c        |   22 +++++++++++++++-------
 2 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 8122018..0f5a400 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -439,6 +439,7 @@ struct perf_counter {
 
 	/* delayed work for NMIs and such */
 	int				pending_wakeup;
+	int				pending_kill;
 	int				pending_disable;
 	struct perf_pending_entry	pending;
 
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index c05e103..8c8eaf0 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1596,7 +1596,11 @@ void perf_counter_wakeup(struct perf_counter *counter)
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
@@ -1741,7 +1746,7 @@ static inline void __perf_output_wakeup(struct perf_output_handle *handle)
 
 static int perf_output_begin(struct perf_output_handle *handle,
 			     struct perf_counter *counter, unsigned int size,
-			     int nmi)
+			     int nmi, int overflow)
 {
 	struct perf_mmap_data *data;
 	unsigned int offset, head;
@@ -1751,8 +1756,9 @@ static int perf_output_begin(struct perf_output_handle *handle,
 	if (!data)
 		goto out;
 
-	handle->counter	= counter;
-	handle->nmi	= nmi;
+	handle->counter	 = counter;
+	handle->nmi	 = nmi;
+	handle->overflow = overflow;
 
 	if (!data->nr_pages)
 		goto fail;
@@ -1816,7 +1822,7 @@ static void perf_output_end(struct perf_output_handle *handle)
 {
 	int wakeup_events = handle->counter->hw_event.wakeup_events;
 
-	if (wakeup_events) {
+	if (handle->overflow && wakeup_events) {
 		int events = atomic_inc_return(&handle->data->events);
 		if (events >= wakeup_events) {
 			atomic_sub(wakeup_events, &handle->data->events);
@@ -1891,7 +1897,7 @@ static void perf_counter_output(struct perf_counter *counter,
 		header.size += sizeof(u64);
 	}
 
-	ret = perf_output_begin(&handle, counter, header.size, nmi);
+	ret = perf_output_begin(&handle, counter, header.size, nmi, 1);
 	if (ret)
 		return;
 
@@ -1955,7 +1961,7 @@ static void perf_counter_mmap_output(struct perf_counter *counter,
 {
 	struct perf_output_handle handle;
 	int size = mmap_event->event.header.size;
-	int ret = perf_output_begin(&handle, counter, size, 0);
+	int ret = perf_output_begin(&handle, counter, size, 0, 0);
 
 	if (ret)
 		return;
@@ -2084,8 +2090,10 @@ int perf_counter_overflow(struct perf_counter *counter,
 	int events = atomic_read(&counter->event_limit);
 	int ret = 0;
 
+	counter->pending_kill = POLL_IN;
 	if (events && atomic_dec_and_test(&counter->event_limit)) {
 		ret = 1;
+		counter->pending_kill = POLL_HUP;
 		if (nmi) {
 			counter->pending_disable = 1;
 			perf_pending_queue(&counter->pending,
