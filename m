Return-Path: <linux-kernel-owner+w=401wt.eu-S1759483AbZCMNKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759483AbZCMNKj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 09:10:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758290AbZCMNIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 09:08:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:36757 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756140AbZCMNIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 09:08:19 -0400
Date: Fri, 13 Mar 2009 13:07:37 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090313112301.954634079@chello.nl>
References: <20090313112301.954634079@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: add an event_list
Message-ID: <tip-93c988346b8ea871d90317e6740003e3144348d4@git.kernel.org>
Git-Commit-ID: 93c988346b8ea871d90317e6740003e3144348d4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 13 Mar 2009 13:07:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  93c988346b8ea871d90317e6740003e3144348d4
Gitweb:     http://git.kernel.org/tip/93c988346b8ea871d90317e6740003e3144348d4
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 13 Mar 2009 12:21:36 +0100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 13 Mar 2009 14:02:46 +0100

perf_counter: add an event_list

I noticed that the counter_list only includes top-level counters, thus
perf_swcounter_event() will miss sw-counters in groups.

Since perf_swcounter_event() also wants an RCU safe list, create a new
event_list that includes all counters and uses RCU list ops and use call_rcu
to free the counter structure.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20090313112301.954634079@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |    4 ++++
 kernel/perf_counter.c        |   30 +++++++++++++++++++-----------
 2 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index dfb4c7c..08c11a6 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -187,6 +187,7 @@ struct file;
 struct perf_counter {
 #ifdef CONFIG_PERF_COUNTERS
 	struct list_head		list_entry;
+	struct list_head		event_entry;
 	struct list_head		sibling_list;
 	struct perf_counter		*group_leader;
 	const struct hw_perf_counter_ops *hw_ops;
@@ -220,6 +221,8 @@ struct perf_counter {
 	struct perf_data		*irqdata;
 	struct perf_data		*usrdata;
 	struct perf_data		data[2];
+
+	struct rcu_head			rcu_head;
 #endif
 };
 
@@ -243,6 +246,7 @@ struct perf_counter_context {
 	struct mutex		mutex;
 
 	struct list_head	counter_list;
+	struct list_head	event_list;
 	int			nr_counters;
 	int			nr_active;
 	int			is_active;
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index f9330d5..8d6ecfa 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -22,6 +22,7 @@
 #include <linux/perf_counter.h>
 #include <linux/mm.h>
 #include <linux/vmstat.h>
+#include <linux/rculist.h>
 
 /*
  * Each CPU has a list of per CPU counters:
@@ -72,6 +73,8 @@ list_add_counter(struct perf_counter *counter, struct perf_counter_context *ctx)
 		list_add_tail(&counter->list_entry, &ctx->counter_list);
 	else
 		list_add_tail(&counter->list_entry, &group_leader->sibling_list);
+
+	list_add_rcu(&counter->event_entry, &ctx->event_list);
 }
 
 static void
@@ -80,6 +83,7 @@ list_del_counter(struct perf_counter *counter, struct perf_counter_context *ctx)
 	struct perf_counter *sibling, *tmp;
 
 	list_del_init(&counter->list_entry);
+	list_del_rcu(&counter->event_entry);
 
 	/*
 	 * If this was a group counter with sibling counters then
@@ -1133,6 +1137,14 @@ static struct perf_counter_context *find_get_context(pid_t pid, int cpu)
 	return ctx;
 }
 
+static void free_counter_rcu(struct rcu_head *head)
+{
+	struct perf_counter *counter;
+
+	counter = container_of(head, struct perf_counter, rcu_head);
+	kfree(counter);
+}
+
 /*
  * Called when the last reference to the file is gone.
  */
@@ -1151,7 +1163,7 @@ static int perf_release(struct inode *inode, struct file *file)
 	mutex_unlock(&counter->mutex);
 	mutex_unlock(&ctx->mutex);
 
-	kfree(counter);
+	call_rcu(&counter->rcu_head, free_counter_rcu);
 	put_context(ctx);
 
 	return 0;
@@ -1491,22 +1503,16 @@ static void perf_swcounter_ctx_event(struct perf_counter_context *ctx,
 				     int nmi, struct pt_regs *regs)
 {
 	struct perf_counter *counter;
-	unsigned long flags;
 
-	if (list_empty(&ctx->counter_list))
+	if (list_empty(&ctx->event_list))
 		return;
 
-	spin_lock_irqsave(&ctx->lock, flags);
-
-	/*
-	 * XXX: make counter_list RCU safe
-	 */
-	list_for_each_entry(counter, &ctx->counter_list, list_entry) {
+	rcu_read_lock();
+	list_for_each_entry_rcu(counter, &ctx->event_list, event_entry) {
 		if (perf_swcounter_match(counter, event, regs))
 			perf_swcounter_add(counter, nr, nmi, regs);
 	}
-
-	spin_unlock_irqrestore(&ctx->lock, flags);
+	rcu_read_unlock();
 }
 
 void perf_swcounter_event(enum hw_event_types event, u64 nr,
@@ -1846,6 +1852,7 @@ perf_counter_alloc(struct perf_counter_hw_event *hw_event,
 
 	mutex_init(&counter->mutex);
 	INIT_LIST_HEAD(&counter->list_entry);
+	INIT_LIST_HEAD(&counter->event_entry);
 	INIT_LIST_HEAD(&counter->sibling_list);
 	init_waitqueue_head(&counter->waitq);
 
@@ -1992,6 +1999,7 @@ __perf_counter_init_context(struct perf_counter_context *ctx,
 	spin_lock_init(&ctx->lock);
 	mutex_init(&ctx->mutex);
 	INIT_LIST_HEAD(&ctx->counter_list);
+	INIT_LIST_HEAD(&ctx->event_list);
 	ctx->task = task;
 }
 
