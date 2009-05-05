Return-Path: <linux-kernel-owner+w=401wt.eu-S1757039AbZEEQSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757039AbZEEQSu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 12:18:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754334AbZEEQSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 12:18:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:39833 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975AbZEEQSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 12:18:06 -0400
Message-Id: <20090505155436.925084300@chello.nl>
References: <20090505155020.309162852@chello.nl>
User-Agent: quilt/0.46-1
Date: Tue, 05 May 2009 17:50:22 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/7] perf_counter: uncouple data_head updates from wakeups
Content-Disposition: inline; filename=perf_counter-uncouple-data_head-from-wakeup.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keep data_head up-to-date irrespective of notifications, this fixes
the case where you disable a counter and don't get a notification for
the last few pending events, and also allows polling usage.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_counter.h |    4 +++-
 kernel/perf_counter.c        |   20 +++++++++-----------
 2 files changed, 12 insertions(+), 12 deletions(-)

Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -1696,7 +1696,6 @@ struct perf_output_handle {
 	struct perf_mmap_data	*data;
 	unsigned int		offset;
 	unsigned int		head;
-	int			wakeup;
 	int			nmi;
 	int			overflow;
 	int			locked;
@@ -1752,8 +1751,7 @@ static void perf_output_unlock(struct pe
 	struct perf_mmap_data *data = handle->data;
 	int head, cpu;
 
-	if (handle->wakeup)
-		data->wakeup_head = data->head;
+	data->done_head = data->head;
 
 	if (!handle->locked)
 		goto out;
@@ -1764,13 +1762,11 @@ again:
 	 * before we publish the new head, matched by a rmb() in userspace when
 	 * reading this position.
 	 */
-	while ((head = atomic_xchg(&data->wakeup_head, 0))) {
+	while ((head = atomic_xchg(&data->done_head, 0)))
 		data->user_page->data_head = head;
-		handle->wakeup = 1;
-	}
 
 	/*
-	 * NMI can happen here, which means we can miss a wakeup_head update.
+	 * NMI can happen here, which means we can miss a done_head update.
 	 */
 
 	cpu = atomic_xchg(&data->lock, 0);
@@ -1779,7 +1775,7 @@ again:
 	/*
 	 * Therefore we have to validate we did not indeed do so.
 	 */
-	if (unlikely(atomic_read(&data->wakeup_head))) {
+	if (unlikely(atomic_read(&data->done_head))) {
 		/*
 		 * Since we had it locked, we can lock it again.
 		 */
@@ -1789,7 +1785,7 @@ again:
 		goto again;
 	}
 
-	if (handle->wakeup)
+	if (atomic_xchg(&data->wakeup, 0))
 		perf_output_wakeup(handle);
 out:
 	local_irq_restore(handle->flags);
@@ -1824,7 +1820,9 @@ static int perf_output_begin(struct perf
 
 	handle->offset	= offset;
 	handle->head	= head;
-	handle->wakeup	= (offset >> PAGE_SHIFT) != (head >> PAGE_SHIFT);
+
+	if ((offset >> PAGE_SHIFT) != (head >> PAGE_SHIFT))
+		atomic_set(&data->wakeup, 1);
 
 	return 0;
 
@@ -1882,7 +1880,7 @@ static void perf_output_end(struct perf_
 		int events = atomic_inc_return(&data->events);
 		if (events >= wakeup_events) {
 			atomic_sub(wakeup_events, &data->events);
-			handle->wakeup = 1;
+			atomic_set(&data->wakeup, 1);
 		}
 	}
 
Index: linux-2.6/include/linux/perf_counter.h
===================================================================
--- linux-2.6.orig/include/linux/perf_counter.h
+++ linux-2.6/include/linux/perf_counter.h
@@ -362,9 +362,11 @@ struct perf_mmap_data {
 	atomic_t			head;		/* write position    */
 	atomic_t			events;		/* event limit       */
 
-	atomic_t			wakeup_head;	/* completed head    */
+	atomic_t			done_head;	/* completed head    */
 	atomic_t			lock;		/* concurrent writes */
 
+	atomic_t			wakeup;		/* needs a wakeup    */
+
 	struct perf_counter_mmap_page   *user_page;
 	void 				*data_pages[0];
 };

-- 

