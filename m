Return-Path: <linux-kernel-owner+w=401wt.eu-S1754977AbZFBURx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977AbZFBURx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 16:17:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754706AbZFBURN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 16:17:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:59498 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754628AbZFBURL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 16:17:11 -0400
Date: Tue, 2 Jun 2009 20:16:51 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       eranian@googlemail.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       eranian@googlemail.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter: Change data head from u32 to u64
Message-ID: <tip-8e3747c13c39246c7e46def7cf495d9d21d4c5f9@git.kernel.org>
Git-Commit-ID: 8e3747c13c39246c7e46def7cf495d9d21d4c5f9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 02 Jun 2009 20:16:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8e3747c13c39246c7e46def7cf495d9d21d4c5f9
Gitweb:     http://git.kernel.org/tip/8e3747c13c39246c7e46def7cf495d9d21d4c5f9
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 2 Jun 2009 16:16:02 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 2 Jun 2009 21:45:32 +0200

perf_counter: Change data head from u32 to u64

Since some people worried that 4G might not be a large enough
as an mmap data window, extend it to 64 bit for capable
platforms.

Reported-by: Stephane Eranian <eranian@googlemail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |    7 ++++---
 kernel/perf_counter.c        |   15 ++++++++-------
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index cef9931..c046f7d 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -212,7 +212,7 @@ struct perf_counter_mmap_page {
 	 * User-space reading this value should issue an rmb(), on SMP capable
 	 * platforms, after reading this value -- see perf_counter_wakeup().
 	 */
-	__u32   data_head;		/* head in the data section */
+	__u64   data_head;		/* head in the data section */
 };
 
 #define PERF_EVENT_MISC_CPUMODE_MASK	(3 << 0)
@@ -397,10 +397,11 @@ struct perf_mmap_data {
 	int				nr_locked;	/* nr pages mlocked  */
 
 	atomic_t			poll;		/* POLL_ for wakeups */
-	atomic_t			head;		/* write position    */
 	atomic_t			events;		/* event limit       */
 
-	atomic_t			done_head;	/* completed head    */
+	atomic_long_t			head;		/* write position    */
+	atomic_long_t			done_head;	/* completed head    */
+
 	atomic_t			lock;		/* concurrent writes */
 
 	atomic_t			wakeup;		/* needs a wakeup    */
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 5ecd998..3f11a2b 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -2067,8 +2067,8 @@ __weak struct perf_callchain_entry *perf_callchain(struct pt_regs *regs)
 struct perf_output_handle {
 	struct perf_counter	*counter;
 	struct perf_mmap_data	*data;
-	unsigned int		offset;
-	unsigned int		head;
+	unsigned long		head;
+	unsigned long		offset;
 	int			nmi;
 	int			overflow;
 	int			locked;
@@ -2122,7 +2122,8 @@ static void perf_output_lock(struct perf_output_handle *handle)
 static void perf_output_unlock(struct perf_output_handle *handle)
 {
 	struct perf_mmap_data *data = handle->data;
-	int head, cpu;
+	unsigned long head;
+	int cpu;
 
 	data->done_head = data->head;
 
@@ -2135,7 +2136,7 @@ again:
 	 * before we publish the new head, matched by a rmb() in userspace when
 	 * reading this position.
 	 */
-	while ((head = atomic_xchg(&data->done_head, 0)))
+	while ((head = atomic_long_xchg(&data->done_head, 0)))
 		data->user_page->data_head = head;
 
 	/*
@@ -2148,7 +2149,7 @@ again:
 	/*
 	 * Therefore we have to validate we did not indeed do so.
 	 */
-	if (unlikely(atomic_read(&data->done_head))) {
+	if (unlikely(atomic_long_read(&data->done_head))) {
 		/*
 		 * Since we had it locked, we can lock it again.
 		 */
@@ -2195,7 +2196,7 @@ static int perf_output_begin(struct perf_output_handle *handle,
 	do {
 		offset = head = atomic_read(&data->head);
 		head += size;
-	} while (atomic_cmpxchg(&data->head, offset, head) != offset);
+	} while (atomic_long_cmpxchg(&data->head, offset, head) != offset);
 
 	handle->offset	= offset;
 	handle->head	= head;
@@ -2246,7 +2247,7 @@ static void perf_output_copy(struct perf_output_handle *handle,
 	 * Check we didn't copy past our reservation window, taking the
 	 * possible unsigned int wrap into account.
 	 */
-	WARN_ON_ONCE(((int)(handle->head - handle->offset)) < 0);
+	WARN_ON_ONCE(((long)(handle->head - handle->offset)) < 0);
 }
 
 #define perf_output_put(handle, x) \
