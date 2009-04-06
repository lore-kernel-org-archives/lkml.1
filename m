Return-Path: <linux-kernel-owner+w=401wt.eu-S1756174AbZDFJrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174AbZDFJrf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 05:47:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753276AbZDFJon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 05:44:43 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34372 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755560AbZDFJog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 05:44:36 -0400
Message-Id: <20090406094517.634732847@chello.nl>
References: <20090406094458.977814421@chello.nl>
User-Agent: quilt/0.46-1
Date: Mon, 06 Apr 2009 11:45:02 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 04/15] perf_counter: generalize pending infrastructure
Content-Disposition: inline; filename=perf_counter-pending.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare the pending infrastructure to do more than wakeups.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_counter.h |    7 +++--
 kernel/perf_counter.c        |   53 +++++++++++++++++++++++++------------------
 2 files changed, 36 insertions(+), 24 deletions(-)

Index: linux-2.6/include/linux/perf_counter.h
===================================================================
--- linux-2.6.orig/include/linux/perf_counter.h
+++ linux-2.6/include/linux/perf_counter.h
@@ -320,8 +320,9 @@ struct perf_mmap_data {
 	void 				*data_pages[0];
 };
 
-struct perf_wakeup_entry {
-	struct perf_wakeup_entry *next;
+struct perf_pending_entry {
+	struct perf_pending_entry *next;
+	void (*func)(struct perf_pending_entry *);
 };
 
 /**
@@ -400,7 +401,7 @@ struct perf_counter {
 	wait_queue_head_t		waitq;
 	struct fasync_struct		*fasync;
 	/* optional: for NMIs */
-	struct perf_wakeup_entry	wakeup;
+	struct perf_pending_entry	pending;
 
 	void (*destroy)(struct perf_counter *);
 	struct rcu_head			rcu_head;
Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -1581,6 +1581,14 @@ void perf_counter_wakeup(struct perf_cou
 	kill_fasync(&counter->fasync, SIGIO, POLL_IN);
 }
 
+static void perf_pending_wakeup(struct perf_pending_entry *entry)
+{
+	struct perf_counter *counter = container_of(entry,
+			struct perf_counter, pending);
+
+	perf_counter_wakeup(counter);
+}
+
 /*
  * Pending wakeups
  *
@@ -1590,45 +1598,47 @@ void perf_counter_wakeup(struct perf_cou
  * single linked list and use cmpxchg() to add entries lockless.
  */
 
-#define PENDING_TAIL ((struct perf_wakeup_entry *)-1UL)
+#define PENDING_TAIL ((struct perf_pending_entry *)-1UL)
 
-static DEFINE_PER_CPU(struct perf_wakeup_entry *, perf_wakeup_head) = {
+static DEFINE_PER_CPU(struct perf_pending_entry *, perf_pending_head) = {
 	PENDING_TAIL,
 };
 
-static void perf_pending_queue(struct perf_counter *counter)
+static void perf_pending_queue(struct perf_pending_entry *entry,
+			       void (*func)(struct perf_pending_entry *))
 {
-	struct perf_wakeup_entry **head;
-	struct perf_wakeup_entry *prev, *next;
+	struct perf_pending_entry **head;
 
-	if (cmpxchg(&counter->wakeup.next, NULL, PENDING_TAIL) != NULL)
+	if (cmpxchg(&entry->next, NULL, PENDING_TAIL) != NULL)
 		return;
 
-	head = &get_cpu_var(perf_wakeup_head);
+	entry->func = func;
+
+	head = &get_cpu_var(perf_pending_head);
 
 	do {
-		prev = counter->wakeup.next = *head;
-		next = &counter->wakeup;
-	} while (cmpxchg(head, prev, next) != prev);
+		entry->next = *head;
+	} while (cmpxchg(head, entry->next, entry) != entry->next);
 
 	set_perf_counter_pending();
 
-	put_cpu_var(perf_wakeup_head);
+	put_cpu_var(perf_pending_head);
 }
 
 static int __perf_pending_run(void)
 {
-	struct perf_wakeup_entry *list;
+	struct perf_pending_entry *list;
 	int nr = 0;
 
-	list = xchg(&__get_cpu_var(perf_wakeup_head), PENDING_TAIL);
+	list = xchg(&__get_cpu_var(perf_pending_head), PENDING_TAIL);
 	while (list != PENDING_TAIL) {
-		struct perf_counter *counter = container_of(list,
-				struct perf_counter, wakeup);
+		void (*func)(struct perf_pending_entry *);
+		struct perf_pending_entry *entry = list;
 
 		list = list->next;
 
-		counter->wakeup.next = NULL;
+		func = entry->func;
+		entry->next = NULL;
 		/*
 		 * Ensure we observe the unqueue before we issue the wakeup,
 		 * so that we won't be waiting forever.
@@ -1636,7 +1646,7 @@ static int __perf_pending_run(void)
 		 */
 		smp_wmb();
 
-		perf_counter_wakeup(counter);
+		func(entry);
 		nr++;
 	}
 
@@ -1658,7 +1668,7 @@ static inline int perf_not_pending(struc
 	 * so that we do not miss the wakeup. -- see perf_pending_handle()
 	 */
 	smp_rmb();
-	return counter->wakeup.next == NULL;
+	return counter->pending.next == NULL;
 }
 
 static void perf_pending_sync(struct perf_counter *counter)
@@ -1695,9 +1705,10 @@ struct perf_output_handle {
 
 static inline void __perf_output_wakeup(struct perf_output_handle *handle)
 {
-	if (handle->nmi)
-		perf_pending_queue(handle->counter);
-	else
+	if (handle->nmi) {
+		perf_pending_queue(&handle->counter->pending,
+				   perf_pending_wakeup);
+	} else
 		perf_counter_wakeup(handle->counter);
 }
 

-- 

