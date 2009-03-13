Return-Path: <linux-kernel-owner+w=401wt.eu-S1758927AbZCML1D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758927AbZCML1D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 07:27:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755043AbZCMLXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 07:23:50 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46695 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069AbZCMLXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 07:23:48 -0400
Message-Id: <20090313112301.954634079@chello.nl>
References: <20090313112125.886730125@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 13 Mar 2009 12:21:36 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, paulus@samba.org, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 11/11] perf_counter: add an event_list
Content-Disposition: inline; filename=perf_swcounter_rcu.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed that the counter_list only includes top-level counters, thus
perf_swcounter_event() will miss sw-counters in groups.

Since perf_swcounter_event() also wants an RCU safe list, create a new
event_list that includes all counters and uses RCU list ops and use call_rcu
to free the counter structure.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_counter.h |    4 ++++
 kernel/perf_counter.c        |   30 +++++++++++++++++++-----------
 2 files changed, 23 insertions(+), 11 deletions(-)

Index: linux-2.6/include/linux/perf_counter.h
===================================================================
--- linux-2.6.orig/include/linux/perf_counter.h
+++ linux-2.6/include/linux/perf_counter.h
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
Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -22,6 +22,7 @@
 #include <linux/perf_counter.h>
 #include <linux/mm.h>
 #include <linux/vmstat.h>
+#include <linux/rculist.h>
 
 /*
  * Each CPU has a list of per CPU counters:
@@ -72,6 +73,8 @@ list_add_counter(struct perf_counter *co
 		list_add_tail(&counter->list_entry, &ctx->counter_list);
 	else
 		list_add_tail(&counter->list_entry, &group_leader->sibling_list);
+
+	list_add_rcu(&counter->event_entry, &ctx->event_list);
 }
 
 static void
@@ -80,6 +83,7 @@ list_del_counter(struct perf_counter *co
 	struct perf_counter *sibling, *tmp;
 
 	list_del_init(&counter->list_entry);
+	list_del_rcu(&counter->event_entry);
 
 	/*
 	 * If this was a group counter with sibling counters then
@@ -1134,6 +1138,14 @@ static struct perf_counter_context *find
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
@@ -1152,7 +1164,7 @@ static int perf_release(struct inode *in
 	mutex_unlock(&counter->mutex);
 	mutex_unlock(&ctx->mutex);
 
-	kfree(counter);
+	call_rcu(&counter->rcu_head, free_counter_rcu);
 	put_context(ctx);
 
 	return 0;
@@ -1490,22 +1502,16 @@ static void perf_swcounter_ctx_event(str
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
@@ -1843,6 +1849,7 @@ perf_counter_alloc(struct perf_counter_h
 
 	mutex_init(&counter->mutex);
 	INIT_LIST_HEAD(&counter->list_entry);
+	INIT_LIST_HEAD(&counter->event_entry);
 	INIT_LIST_HEAD(&counter->sibling_list);
 	init_waitqueue_head(&counter->waitq);
 
@@ -1989,6 +1996,7 @@ __perf_counter_init_context(struct perf_
 	spin_lock_init(&ctx->lock);
 	mutex_init(&ctx->mutex);
 	INIT_LIST_HEAD(&ctx->counter_list);
+	INIT_LIST_HEAD(&ctx->event_list);
 	ctx->task = task;
 }
 

-- 

