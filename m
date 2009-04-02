Return-Path: <linux-kernel-owner+w=401wt.eu-S934959AbZDBJOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934959AbZDBJOS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 05:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761765AbZDBJMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 05:12:55 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59143 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757192AbZDBJMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 05:12:51 -0400
Message-Id: <20090402091319.323309784@chello.nl>
References: <20090402091158.291810516@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 02 Apr 2009 11:12:01 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 3/6] perf_counter: per event wakeups
Content-Disposition: inline; filename=perf_counter-event-wakeup.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By request, provide a way to request a wakeup every 'n' events instead
of every page of output.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_counter.h |    3 ++-
 kernel/perf_counter.c        |   10 +++++++++-
 2 files changed, 11 insertions(+), 2 deletions(-)

Index: linux-2.6/include/linux/perf_counter.h
===================================================================
--- linux-2.6.orig/include/linux/perf_counter.h
+++ linux-2.6/include/linux/perf_counter.h
@@ -146,7 +146,7 @@ struct perf_counter_hw_event {
 				__reserved_1   : 52;
 
 	__u32			extra_config_len;
-	__u32			__reserved_4;
+	__u32			wakeup_events;	/* wakeup every n events */
 
 	/*
 	 * Singleshot signal information.
@@ -327,6 +327,7 @@ struct perf_mmap_data {
 	int				nr_pages;
 	atomic_t			wakeup;
 	atomic_t			head;
+	atomic_t			events;
 	struct perf_counter_mmap_page   *user_page;
 	void 				*data_pages[0];
 };
Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -1760,7 +1760,15 @@ static void perf_output_copy(struct perf
 
 static void perf_output_end(struct perf_output_handle *handle)
 {
-	if (handle->wakeup)
+	int wakeup_events = handle->counter->hw_event.wakeup_events;
+
+	if (wakeup_events) {
+		int events = atomic_inc_return(&handle->data->events);
+		if (events >= wakeup_events) {
+			atomic_sub(wakeup_events, &handle->data->events);
+			__perf_output_wakeup(handle);
+		}
+	} else if (handle->wakeup)
 		__perf_output_wakeup(handle);
 	rcu_read_unlock();
 }

-- 

