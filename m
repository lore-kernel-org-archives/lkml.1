Return-Path: <linux-kernel-owner+w=401wt.eu-S1755502AbZDGJIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502AbZDGJIZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 05:08:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755003AbZDGJIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 05:08:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:46970 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752722AbZDGJH6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 05:07:58 -0400
Date: Tue, 7 Apr 2009 09:07:25 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20090406094517.634732847@chello.nl>
References: <20090406094517.634732847@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: generalize pending infrastructure
Message-ID: <tip-671dec5daf3b3c43c5777be282f00120a44cf37f@git.kernel.org>
Git-Commit-ID: 671dec5daf3b3c43c5777be282f00120a44cf37f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 07 Apr 2009 09:07:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  671dec5daf3b3c43c5777be282f00120a44cf37f
Gitweb:     http://git.kernel.org/tip/671dec5daf3b3c43c5777be282f00120a44cf37f
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 6 Apr 2009 11:45:02 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 7 Apr 2009 10:48:55 +0200

perf_counter: generalize pending infrastructure

Prepare the pending infrastructure to do more than wakeups.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
LKML-Reference: <20090406094517.634732847@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |    7 +++--
 kernel/perf_counter.c        |   53 +++++++++++++++++++++++++----------------
 2 files changed, 36 insertions(+), 24 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 8d5d11b..977fb15 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -321,8 +321,9 @@ struct perf_mmap_data {
 	void 				*data_pages[0];
 };
 
-struct perf_wakeup_entry {
-	struct perf_wakeup_entry *next;
+struct perf_pending_entry {
+	struct perf_pending_entry *next;
+	void (*func)(struct perf_pending_entry *);
 };
 
 /**
@@ -401,7 +402,7 @@ struct perf_counter {
 	wait_queue_head_t		waitq;
 	struct fasync_struct		*fasync;
 	/* optional: for NMIs */
-	struct perf_wakeup_entry	wakeup;
+	struct perf_pending_entry	pending;
 
 	void (*destroy)(struct perf_counter *);
 	struct rcu_head			rcu_head;
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index c58cc64..0a2ade2 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1581,6 +1581,14 @@ void perf_counter_wakeup(struct perf_counter *counter)
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
@@ -1590,45 +1598,47 @@ void perf_counter_wakeup(struct perf_counter *counter)
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
 
@@ -1658,7 +1668,7 @@ static inline int perf_not_pending(struct perf_counter *counter)
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
 
