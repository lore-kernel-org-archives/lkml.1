Return-Path: <linux-kernel-owner+w=401wt.eu-S1759728AbZIQSIN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759728AbZIQSIN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 14:08:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759037AbZIQSII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 14:08:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:44932 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758979AbZIQSIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 14:08:04 -0400
Date: Thu, 17 Sep 2009 18:07:35 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perfcounters/core] perf_counter: Allow for a wakeup watermark
Message-ID: <tip-0c733e0676f27fa325f6ba42f4035db8523abc90@git.kernel.org>
Git-Commit-ID: 0c733e0676f27fa325f6ba42f4035db8523abc90
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 17 Sep 2009 18:07:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0c733e0676f27fa325f6ba42f4035db8523abc90
Gitweb:     http://git.kernel.org/tip/0c733e0676f27fa325f6ba42f4035db8523abc90
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 17 Sep 2009 19:01:10 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 17 Sep 2009 20:02:46 +0200

perf_counter: Allow for a wakeup watermark

Currently we wake the mmap() consumer once every PAGE_SIZE of data
and/or once event wakeup_events when specified.

For high speed sampling this results in too many wakeups wrt. the
buffer size, hence change this.

We move the default wakeup limit to 1/4-th the buffer size, and
provide for means to manually specify this limit.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |   10 ++++++++--
 kernel/perf_counter.c        |   32 +++++++++++++++++++-------------
 2 files changed, 27 insertions(+), 15 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 972f90d..6c1ef72 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -199,10 +199,14 @@ struct perf_counter_attr {
 				inherit_stat   :  1, /* per task counts       */
 				enable_on_exec :  1, /* next exec enables     */
 				task           :  1, /* trace fork/exit       */
+				watermark      :  1, /* wakeup_watermark      */
 
-				__reserved_1   : 50;
+				__reserved_1   : 49;
 
-	__u32			wakeup_events;	/* wakeup every n events */
+	union {
+		__u32		wakeup_events;	  /* wakeup every n events */
+		__u32		wakeup_watermark; /* bytes before wakeup   */
+	};
 	__u32			__reserved_2;
 
 	__u64			__reserved_3;
@@ -521,6 +525,8 @@ struct perf_mmap_data {
 	atomic_t			wakeup;		/* needs a wakeup    */
 	atomic_t			lost;		/* nr records lost   */
 
+	long				watermark;	/* wakeup watermark  */
+
 	struct perf_counter_mmap_page   *user_page;
 	void				*data_pages[0];
 };
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index fe0d1ad..29b73b6 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -2176,6 +2176,13 @@ static int perf_mmap_data_alloc(struct perf_counter *counter, int nr_pages)
 	data->nr_pages = nr_pages;
 	atomic_set(&data->lock, -1);
 
+	if (counter->attr.watermark) {
+		data->watermark = min_t(long, PAGE_SIZE * nr_pages,
+				      counter->attr.wakeup_watermark);
+	}
+	if (!data->watermark)
+		data->watermark = max(PAGE_SIZE, PAGE_SIZE * nr_pages / 4);
+
 	rcu_assign_pointer(counter->data, data);
 
 	return 0;
@@ -2517,23 +2524,15 @@ struct perf_output_handle {
 	unsigned long		flags;
 };
 
-static bool perf_output_space(struct perf_mmap_data *data,
-			      unsigned int offset, unsigned int head)
+static bool perf_output_space(struct perf_mmap_data *data, unsigned long tail,
+			      unsigned long offset, unsigned long head)
 {
-	unsigned long tail;
 	unsigned long mask;
 
 	if (!data->writable)
 		return true;
 
 	mask = (data->nr_pages << PAGE_SHIFT) - 1;
-	/*
-	 * Userspace could choose to issue a mb() before updating the tail
-	 * pointer. So that all reads will be completed before the write is
-	 * issued.
-	 */
-	tail = ACCESS_ONCE(data->user_page->data_tail);
-	smp_rmb();
 
 	offset = (offset - tail) & mask;
 	head   = (head   - tail) & mask;
@@ -2679,7 +2678,7 @@ static int perf_output_begin(struct perf_output_handle *handle,
 {
 	struct perf_counter *output_counter;
 	struct perf_mmap_data *data;
-	unsigned int offset, head;
+	unsigned long tail, offset, head;
 	int have_lost;
 	struct {
 		struct perf_event_header header;
@@ -2717,16 +2716,23 @@ static int perf_output_begin(struct perf_output_handle *handle,
 	perf_output_lock(handle);
 
 	do {
+		/*
+		 * Userspace could choose to issue a mb() before updating the
+		 * tail pointer. So that all reads will be completed before the
+		 * write is issued.
+		 */
+		tail = ACCESS_ONCE(data->user_page->data_tail);
+		smp_rmb();
 		offset = head = atomic_long_read(&data->head);
 		head += size;
-		if (unlikely(!perf_output_space(data, offset, head)))
+		if (unlikely(!perf_output_space(data, tail, offset, head)))
 			goto fail;
 	} while (atomic_long_cmpxchg(&data->head, offset, head) != offset);
 
 	handle->offset	= offset;
 	handle->head	= head;
 
-	if ((offset >> PAGE_SHIFT) != (head >> PAGE_SHIFT))
+	if (head - tail > data->watermark)
 		atomic_set(&data->wakeup, 1);
 
 	if (have_lost) {
