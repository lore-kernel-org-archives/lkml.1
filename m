Return-Path: <linux-kernel-owner+w=401wt.eu-S935226AbZDBJPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935226AbZDBJPL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 05:15:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763526AbZDBJM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 05:12:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:57844 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757319AbZDBJMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 05:12:53 -0400
Message-Id: <20090402091319.257773792@chello.nl>
References: <20090402091158.291810516@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 02 Apr 2009 11:12:00 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/6] RFC perf_counter: singleshot support
Content-Disposition: inline; filename=perf_counter-singleshot.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By request, provide a way for counters to disable themselves and signal
at the first counter overflow.

This isn't complete, we really want pending work to be done ASAP after
queueing it. My preferred method would be a self-IPI, that would ensure
we run the code in a usable context right after the current (IRQ-off,
NMI) context is done.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/powerpc/kernel/perf_counter.c |    2 
 arch/x86/kernel/cpu/perf_counter.c |    2 
 include/linux/perf_counter.h       |   21 +++++---
 kernel/perf_counter.c              |   94 ++++++++++++++++++++++++++++---------
 4 files changed, 89 insertions(+), 30 deletions(-)

Index: linux-2.6/arch/powerpc/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/perf_counter.c
+++ linux-2.6/arch/powerpc/kernel/perf_counter.c
@@ -732,7 +732,7 @@ static void record_and_restart(struct pe
 	 * Finally record data if requested.
 	 */
 	if (record)
-		perf_counter_output(counter, 1, regs);
+		perf_counter_overflow(counter, 1, regs);
 }
 
 /*
Index: linux-2.6/arch/x86/kernel/cpu/perf_counter.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_counter.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_counter.c
@@ -800,7 +800,7 @@ again:
 			continue;
 
 		perf_save_and_restart(counter);
-		perf_counter_output(counter, nmi, regs);
+		perf_counter_overflow(counter, nmi, regs);
 	}
 
 	hw_perf_ack_status(ack);
Index: linux-2.6/include/linux/perf_counter.h
===================================================================
--- linux-2.6.orig/include/linux/perf_counter.h
+++ linux-2.6/include/linux/perf_counter.h
@@ -141,13 +141,19 @@ struct perf_counter_hw_event {
 				exclude_idle   :  1, /* don't count when idle */
 				mmap           :  1, /* include mmap data     */
 				munmap         :  1, /* include munmap data   */
+				singleshot     :  1, /* singleshot overflow   */
 
-				__reserved_1   : 53;
+				__reserved_1   : 52;
 
 	__u32			extra_config_len;
 	__u32			__reserved_4;
 
-	__u64			__reserved_2;
+	/*
+	 * Singleshot signal information.
+	 */
+	__u32			signal_nr;
+	__u32			signal_tid;
+
 	__u64			__reserved_3;
 };
 
@@ -325,8 +331,9 @@ struct perf_mmap_data {
 	void 				*data_pages[0];
 };
 
-struct perf_wakeup_entry {
-	struct perf_wakeup_entry *next;
+struct perf_pending_entry {
+	struct perf_pending_entry *next;
+	void (*func)(struct perf_pending_entry *);
 };
 
 /**
@@ -404,7 +411,7 @@ struct perf_counter {
 	/* poll related */
 	wait_queue_head_t		waitq;
 	/* optional: for NMIs */
-	struct perf_wakeup_entry	wakeup;
+	struct perf_pending_entry	pending;
 
 	void (*destroy)(struct perf_counter *);
 	struct rcu_head			rcu_head;
@@ -493,8 +500,8 @@ extern int hw_perf_group_sched_in(struct
 	       struct perf_counter_context *ctx, int cpu);
 extern void perf_counter_update_userpage(struct perf_counter *counter);
 
-extern void perf_counter_output(struct perf_counter *counter,
-				int nmi, struct pt_regs *regs);
+extern void perf_counter_overflow(struct perf_counter *counter,
+				  int nmi, struct pt_regs *regs);
 /*
  * Return 1 for a software counter, 0 for a hardware counter
  */
Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -1563,6 +1563,14 @@ void perf_counter_wakeup(struct perf_cou
 	wake_up_all(&counter->waitq);
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
@@ -1572,45 +1580,47 @@ void perf_counter_wakeup(struct perf_cou
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
+		entry->next = NULL;
+		func = entry->func;
 		/*
 		 * Ensure we observe the unqueue before we issue the wakeup,
 		 * so that we won't be waiting forever.
@@ -1618,7 +1628,7 @@ static int __perf_pending_run(void)
 		 */
 		smp_wmb();
 
-		perf_counter_wakeup(counter);
+		func(entry);
 		nr++;
 	}
 
@@ -1640,7 +1650,7 @@ static inline int perf_not_pending(struc
 	 * so that we do not miss the wakeup. -- see perf_pending_handle()
 	 */
 	smp_rmb();
-	return counter->wakeup.next == NULL;
+	return counter->pending.next == NULL;
 }
 
 static void perf_pending_sync(struct perf_counter *counter)
@@ -1679,9 +1689,10 @@ struct perf_output_handle {
 
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
 
@@ -1999,6 +2010,47 @@ void perf_counter_munmap(unsigned long a
 }
 
 /*
+ * Generic counter overflow handling.
+ */
+
+void perf_counter_singleshot(struct perf_counter *counter)
+{
+	struct pid *pid;
+
+	perf_counter_disable(counter);
+
+	rcu_read_lock();
+	pid = find_vpid(counter->hw_event.signal_tid);
+	if (pid)
+		kill_pid(pid, counter->hw_event.signal_nr, 1);
+	rcu_read_unlock();
+}
+
+void perf_pending_singleshot(struct perf_pending_entry *entry)
+{
+	struct perf_counter *counter = container_of(entry,
+			struct perf_counter, pending);
+
+	perf_counter_singleshot(counter);
+}
+
+void perf_counter_overflow(struct perf_counter *counter,
+			   int nmi, struct pt_regs *regs)
+{
+	if (counter->hw_event.singleshot) {
+		if (nmi) {
+			perf_pending_queue(&counter->pending,
+					   perf_pending_singleshot);
+		} else
+			perf_counter_singleshot(counter);
+
+		return;
+	}
+
+	perf_counter_output(counter, nmi, regs);
+}
+
+/*
  * Generic software counter infrastructure
  */
 

-- 

