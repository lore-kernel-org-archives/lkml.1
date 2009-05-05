Return-Path: <linux-kernel-owner+w=401wt.eu-S1757238AbZEESe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757238AbZEESe7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 14:34:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754316AbZEESer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 14:34:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:58290 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752676AbZEESeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 14:34:46 -0400
Date: Tue, 5 May 2009 18:34:01 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20090505155436.925084300@chello.nl>
References: <20090505155436.925084300@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: uncouple data_head updates from wakeups
Message-ID: <tip-c66de4a5be7913247bd83d79168f8e4420c9cfbc@git.kernel.org>
Git-Commit-ID: c66de4a5be7913247bd83d79168f8e4420c9cfbc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 05 May 2009 18:34:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c66de4a5be7913247bd83d79168f8e4420c9cfbc
Gitweb:     http://git.kernel.org/tip/c66de4a5be7913247bd83d79168f8e4420c9cfbc
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 5 May 2009 17:50:22 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 5 May 2009 20:18:30 +0200

perf_counter: uncouple data_head updates from wakeups

Keep data_head up-to-date irrespective of notifications. This fixes
the case where you disable a counter and don't get a notification for
the last few pending events, and it also allows polling usage.

[ Impact: increase precision of perfcounter mmap-ed fields ]

Suggested-by: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <20090505155436.925084300@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |    4 +++-
 kernel/perf_counter.c        |   20 +++++++++-----------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index a356fa6..17b6310 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
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
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 5f86a11..ba5e921 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1696,7 +1696,6 @@ struct perf_output_handle {
 	struct perf_mmap_data	*data;
 	unsigned int		offset;
 	unsigned int		head;
-	int			wakeup;
 	int			nmi;
 	int			overflow;
 	int			locked;
@@ -1752,8 +1751,7 @@ static void perf_output_unlock(struct perf_output_handle *handle)
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
@@ -1824,7 +1820,9 @@ static int perf_output_begin(struct perf_output_handle *handle,
 
 	handle->offset	= offset;
 	handle->head	= head;
-	handle->wakeup	= (offset >> PAGE_SHIFT) != (head >> PAGE_SHIFT);
+
+	if ((offset >> PAGE_SHIFT) != (head >> PAGE_SHIFT))
+		atomic_set(&data->wakeup, 1);
 
 	return 0;
 
@@ -1882,7 +1880,7 @@ static void perf_output_end(struct perf_output_handle *handle)
 		int events = atomic_inc_return(&data->events);
 		if (events >= wakeup_events) {
 			atomic_sub(wakeup_events, &data->events);
-			handle->wakeup = 1;
+			atomic_set(&data->wakeup, 1);
 		}
 	}
 
