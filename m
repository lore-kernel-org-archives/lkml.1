Return-Path: <linux-kernel-owner+w=401wt.eu-S1758570AbZEESg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758570AbZEESg1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 14:36:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758009AbZEESfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 14:35:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:58345 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758018AbZEESfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 14:35:30 -0400
Date: Tue, 5 May 2009 18:34:45 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20090505155437.331556171@chello.nl>
References: <20090505155437.331556171@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: inheritable sample counters
Message-ID: <tip-2023b359214bbc5bad31571cf50d7fb83b535c0a@git.kernel.org>
Git-Commit-ID: 2023b359214bbc5bad31571cf50d7fb83b535c0a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 05 May 2009 18:34:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2023b359214bbc5bad31571cf50d7fb83b535c0a
Gitweb:     http://git.kernel.org/tip/2023b359214bbc5bad31571cf50d7fb83b535c0a
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 5 May 2009 17:50:26 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 5 May 2009 20:18:33 +0200

perf_counter: inheritable sample counters

Redirect the output to the parent counter and put in some sanity checks.

[ Impact: new perfcounter feature - inherited sampling counters ]

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
LKML-Reference: <20090505155437.331556171@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |   32 ++++++++++++++++++++++++++++++--
 1 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index c881afe..60e55f0 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -738,10 +738,18 @@ static void perf_counter_enable(struct perf_counter *counter)
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
@@ -1307,7 +1315,7 @@ static long perf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		perf_counter_disable_family(counter);
 		break;
 	case PERF_COUNTER_IOC_REFRESH:
-		perf_counter_refresh(counter, arg);
+		err = perf_counter_refresh(counter, arg);
 		break;
 	case PERF_COUNTER_IOC_RESET:
 		perf_counter_reset(counter);
@@ -1814,6 +1822,12 @@ static int perf_output_begin(struct perf_output_handle *handle,
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
@@ -1995,6 +2009,9 @@ static void perf_counter_output(struct perf_counter *counter,
 	if (record_type & PERF_RECORD_ADDR)
 		perf_output_put(&handle, addr);
 
+	/*
+	 * XXX PERF_RECORD_GROUP vs inherited counters seems difficult.
+	 */
 	if (record_type & PERF_RECORD_GROUP) {
 		struct perf_counter *leader, *sub;
 		u64 nr = counter->nr_siblings;
@@ -2281,6 +2298,11 @@ int perf_counter_overflow(struct perf_counter *counter,
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
@@ -2801,6 +2823,12 @@ perf_counter_alloc(struct perf_counter_hw_event *hw_event,
 
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
