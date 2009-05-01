Return-Path: <linux-kernel-owner+w=401wt.eu-S1757969AbZEAK1N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757969AbZEAK1N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 06:27:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756114AbZEAK0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 06:26:16 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45662 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329AbZEAK0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 06:26:14 -0400
Message-Id: <20090501102533.007821627@chello.nl>
References: <20090501102315.367605848@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 01 May 2009 12:23:16 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/4] perf_counter: fix race in perf_output_*
Content-Disposition: inline; filename=perf_counter-output-race.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When two (or more) contexts output to the same buffer, it is possible
to observe half written output.

Suppose we have CPU0 doing perf_counter_mmap(), CPU1 doing
perf_counter_overflow(). If CPU1 does a wakeup and exposes head to
user-space, then CPU2 can observe the data CPU0 is still writing.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_counter.h |    5 +
 kernel/perf_counter.c        |  130 +++++++++++++++++++++++++++++++++----------
 2 files changed, 105 insertions(+), 30 deletions(-)

Index: linux-2.6/include/linux/perf_counter.h
===================================================================
--- linux-2.6.orig/include/linux/perf_counter.h
+++ linux-2.6/include/linux/perf_counter.h
@@ -358,10 +358,13 @@ struct perf_mmap_data {
 	struct rcu_head			rcu_head;
 	int				nr_pages;	/* nr of data pages  */
 
-	atomic_t			wakeup;		/* POLL_ for wakeups */
+	atomic_t			poll;		/* POLL_ for wakeups */
 	atomic_t			head;		/* write position    */
 	atomic_t			events;		/* event limit       */
 
+	atomic_t			wakeup_head;	/* completed head    */
+	atomic_t			lock;		/* concurrent writes */
+
 	struct perf_counter_mmap_page   *user_page;
 	void 				*data_pages[0];
 };
Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -1279,14 +1279,12 @@ static unsigned int perf_poll(struct fil
 {
 	struct perf_counter *counter = file->private_data;
 	struct perf_mmap_data *data;
-	unsigned int events;
+	unsigned int events = POLL_HUP;
 
 	rcu_read_lock();
 	data = rcu_dereference(counter->data);
 	if (data)
-		events = atomic_xchg(&data->wakeup, 0);
-	else
-		events = POLL_HUP;
+		events = atomic_xchg(&data->poll, 0);
 	rcu_read_unlock();
 
 	poll_wait(file, &counter->waitq, wait);
@@ -1568,22 +1566,6 @@ static const struct file_operations perf
 
 void perf_counter_wakeup(struct perf_counter *counter)
 {
-	struct perf_mmap_data *data;
-
-	rcu_read_lock();
-	data = rcu_dereference(counter->data);
-	if (data) {
-		atomic_set(&data->wakeup, POLL_IN);
-		/*
-		 * Ensure all data writes are issued before updating the
-		 * user-space data head information. The matching rmb()
-		 * will be in userspace after reading this value.
-		 */
-		smp_wmb();
-		data->user_page->data_head = atomic_read(&data->head);
-	}
-	rcu_read_unlock();
-
 	wake_up_all(&counter->waitq);
 
 	if (counter->pending_kill) {
@@ -1721,10 +1703,14 @@ struct perf_output_handle {
 	int			wakeup;
 	int			nmi;
 	int			overflow;
+	int			locked;
+	unsigned long		flags;
 };
 
-static inline void __perf_output_wakeup(struct perf_output_handle *handle)
+static void perf_output_wakeup(struct perf_output_handle *handle)
 {
+	atomic_set(&handle->data->poll, POLL_IN);
+
 	if (handle->nmi) {
 		handle->counter->pending_wakeup = 1;
 		perf_pending_queue(&handle->counter->pending,
@@ -1733,6 +1719,86 @@ static inline void __perf_output_wakeup(
 		perf_counter_wakeup(handle->counter);
 }
 
+/*
+ * Curious locking construct.
+ *
+ * We need to ensure a later event doesn't publish a head when a former
+ * event isn't done writing. However since we need to deal with NMIs we
+ * cannot fully serialize things.
+ *
+ * What we do is serialize between CPUs so we only have to deal with NMI
+ * nesting on a single CPU.
+ *
+ * We only publish the head (and generate a wakeup) when the outer-most
+ * event completes.
+ */
+static void perf_output_lock(struct perf_output_handle *handle)
+{
+	struct perf_mmap_data *data = handle->data;
+	int cpu;
+
+	handle->locked = 0;
+
+	local_irq_save(handle->flags);
+	cpu = smp_processor_id();
+
+	if (in_nmi() && atomic_read(&data->lock) == cpu)
+		return;
+
+	while (atomic_cmpxchg(&data->lock, 0, cpu) != 0)
+		cpu_relax();
+
+	handle->locked = 1;
+}
+
+static void perf_output_unlock(struct perf_output_handle *handle)
+{
+	struct perf_mmap_data *data = handle->data;
+	int head, cpu;
+
+	if (handle->wakeup)
+		data->wakeup_head = data->head;
+
+	if (!handle->locked)
+		goto out;
+
+again:
+	/*
+	 * The xchg implies a full barrier that ensures all writes are done
+	 * before we publish the new head, matched by a rmb() in userspace when
+	 * reading this position.
+	 */
+	while ((head = atomic_xchg(&data->wakeup_head, 0))) {
+		data->user_page->data_head = head;
+		handle->wakeup = 1;
+	}
+
+	/*
+	 * NMI can happen here, which means we can miss a wakeup_head update.
+	 */
+
+	cpu = atomic_xchg(&data->lock, 0);
+	WARN_ON_ONCE(cpu != smp_processor_id());
+
+	/*
+	 * Therefore we have to validate we did not indeed do so.
+	 */
+	if (unlikely(atomic_read(&data->wakeup_head))) {
+		/*
+		 * Since we had it locked, we can lock it again.
+		 */
+		while (atomic_cmpxchg(&data->lock, 0, cpu) != 0)
+			cpu_relax();
+
+		goto again;
+	}
+
+	if (handle->wakeup)
+		perf_output_wakeup(handle);
+out:
+	local_irq_restore(handle->flags);
+}
+
 static int perf_output_begin(struct perf_output_handle *handle,
 			     struct perf_counter *counter, unsigned int size,
 			     int nmi, int overflow)
@@ -1745,6 +1811,7 @@ static int perf_output_begin(struct perf
 	if (!data)
 		goto out;
 
+	handle->data	 = data;
 	handle->counter	 = counter;
 	handle->nmi	 = nmi;
 	handle->overflow = overflow;
@@ -1752,12 +1819,13 @@ static int perf_output_begin(struct perf
 	if (!data->nr_pages)
 		goto fail;
 
+	perf_output_lock(handle);
+
 	do {
 		offset = head = atomic_read(&data->head);
 		head += size;
 	} while (atomic_cmpxchg(&data->head, offset, head) != offset);
 
-	handle->data	= data;
 	handle->offset	= offset;
 	handle->head	= head;
 	handle->wakeup	= (offset >> PAGE_SHIFT) != (head >> PAGE_SHIFT);
@@ -1765,7 +1833,7 @@ static int perf_output_begin(struct perf
 	return 0;
 
 fail:
-	__perf_output_wakeup(handle);
+	perf_output_wakeup(handle);
 out:
 	rcu_read_unlock();
 
@@ -1809,16 +1877,20 @@ static void perf_output_copy(struct perf
 
 static void perf_output_end(struct perf_output_handle *handle)
 {
-	int wakeup_events = handle->counter->hw_event.wakeup_events;
+	struct perf_counter *counter = handle->counter;
+	struct perf_mmap_data *data = handle->data;
+
+	int wakeup_events = counter->hw_event.wakeup_events;
 
 	if (handle->overflow && wakeup_events) {
-		int events = atomic_inc_return(&handle->data->events);
+		int events = atomic_inc_return(&data->events);
 		if (events >= wakeup_events) {
-			atomic_sub(wakeup_events, &handle->data->events);
-			__perf_output_wakeup(handle);
+			atomic_sub(wakeup_events, &data->events);
+			handle->wakeup = 1;
 		}
-	} else if (handle->wakeup)
-		__perf_output_wakeup(handle);
+	}
+
+	perf_output_unlock(handle);
 	rcu_read_unlock();
 }
 

-- 

