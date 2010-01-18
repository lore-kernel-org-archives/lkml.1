Return-Path: <linux-kernel-owner+w=401wt.eu-S1755244Ab0ARAxN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244Ab0ARAxN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 19:53:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755251Ab0ARAxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 19:53:09 -0500
Received: from hera.kernel.org ([140.211.167.34]:54179 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755228Ab0ARAxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 19:53:00 -0500
From: Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 20/40] workqueue: implement per-cwq active work limit
Date: Mon, 18 Jan 2010 09:57:32 +0900
Message-Id: <1263776272-382-21-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1263776272-382-1-git-send-email-tj@kernel.org>
References: <1263776272-382-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 18 Jan 2010 00:52:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add cwq->nr_active, cwq->max_active and cwq->delayed_work.  nr_active
counts the number of active works per cwq.  A work is active if it's
flushable (colored) and is on cwq's worklist.  If nr_active reaches
max_active, new works are queued on cwq->delayed_work and activated
later as works on the cwq complete and decrement nr_active.

cwq->max_active can be specified via the new @max_active parameter to
__create_workqueue() and is set to 1 for all workqueues for now.  As
each cwq has only single worker now, this double queueing doesn't
cause any behavior difference visible to its users.

This will be used to reimplement freeze/thaw and implement shared
worker pool.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/workqueue.h |   18 +++++++++---------
 kernel/workqueue.c        |   39 +++++++++++++++++++++++++++++++++++++--
 2 files changed, 46 insertions(+), 11 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index a6650f1..974a232 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -216,11 +216,11 @@ enum {
 };
 
 extern struct workqueue_struct *
-__create_workqueue_key(const char *name, unsigned int flags,
+__create_workqueue_key(const char *name, unsigned int flags, int max_active,
 		       struct lock_class_key *key, const char *lock_name);
 
 #ifdef CONFIG_LOCKDEP
-#define __create_workqueue(name, flags)				\
+#define __create_workqueue(name, flags, max_active)		\
 ({								\
 	static struct lock_class_key __key;			\
 	const char *__lock_name;				\
@@ -230,20 +230,20 @@ __create_workqueue_key(const char *name, unsigned int flags,
 	else							\
 		__lock_name = #name;				\
 								\
-	__create_workqueue_key((name), (flags), &__key,		\
-			       __lock_name);			\
+	__create_workqueue_key((name), (flags), (max_active),	\
+				&__key, __lock_name);		\
 })
 #else
-#define __create_workqueue(name, flags)				\
-	__create_workqueue_key((name), (flags), NULL, NULL)
+#define __create_workqueue(name, flags, max_active)		\
+	__create_workqueue_key((name), (flags), (max_active), NULL, NULL)
 #endif
 
 #define create_workqueue(name)					\
-	__create_workqueue((name), 0)
+	__create_workqueue((name), 0, 1)
 #define create_freezeable_workqueue(name)			\
-	__create_workqueue((name), WQ_FREEZEABLE | WQ_SINGLE_THREAD)
+	__create_workqueue((name), WQ_FREEZEABLE | WQ_SINGLE_THREAD, 1)
 #define create_singlethread_workqueue(name)			\
-	__create_workqueue((name), WQ_SINGLE_THREAD)
+	__create_workqueue((name), WQ_SINGLE_THREAD, 1)
 
 extern void destroy_workqueue(struct workqueue_struct *wq);
 
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 2ac1624..0c9c01d 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -77,6 +77,9 @@ struct cpu_workqueue_struct {
 	int			flush_color;	/* L: flushing color */
 	int			nr_in_flight[WORK_NR_COLORS];
 						/* L: nr of in_flight works */
+	int			nr_active;	/* L: nr of active works */
+	int			max_active;	/* I: max active works */
+	struct list_head	delayed_works;	/* L: delayed works */
 };
 
 /*
@@ -314,14 +317,24 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 			 struct work_struct *work)
 {
 	struct cpu_workqueue_struct *cwq = target_cwq(cpu, wq);
+	struct list_head *worklist;
 	unsigned long flags;
 
 	debug_work_activate(work);
+
 	spin_lock_irqsave(&cwq->lock, flags);
 	BUG_ON(!list_empty(&work->entry));
+
 	cwq->nr_in_flight[cwq->work_color]++;
-	insert_work(cwq, work, &cwq->worklist,
-		    work_color_to_flags(cwq->work_color));
+
+	if (likely(cwq->nr_active < cwq->max_active)) {
+		cwq->nr_active++;
+		worklist = &cwq->worklist;
+	} else
+		worklist = &cwq->delayed_works;
+
+	insert_work(cwq, work, worklist, work_color_to_flags(cwq->work_color));
+
 	spin_unlock_irqrestore(&cwq->lock, flags);
 }
 
@@ -578,6 +591,15 @@ static void move_linked_works(struct work_struct *work, struct list_head *head,
 		*nextp = n;
 }
 
+static void cwq_activate_first_delayed(struct cpu_workqueue_struct *cwq)
+{
+	struct work_struct *work = list_first_entry(&cwq->delayed_works,
+						    struct work_struct, entry);
+
+	move_linked_works(work, &cwq->worklist, NULL);
+	cwq->nr_active++;
+}
+
 /**
  * cwq_dec_nr_in_flight - decrement cwq's nr_in_flight
  * @cwq: cwq of interest
@@ -596,6 +618,12 @@ static void cwq_dec_nr_in_flight(struct cpu_workqueue_struct *cwq, int color)
 		return;
 
 	cwq->nr_in_flight[color]--;
+	cwq->nr_active--;
+
+	/* one down, submit a delayed one */
+	if (!list_empty(&cwq->delayed_works) &&
+	    cwq->nr_active < cwq->max_active)
+		cwq_activate_first_delayed(cwq);
 
 	/* is flush in progress and are we at the flushing tip? */
 	if (likely(cwq->flush_color != color))
@@ -1456,6 +1484,7 @@ static void free_cwqs(struct cpu_workqueue_struct *cwqs)
 
 struct workqueue_struct *__create_workqueue_key(const char *name,
 						unsigned int flags,
+						int max_active,
 						struct lock_class_key *key,
 						const char *lock_name)
 {
@@ -1464,6 +1493,8 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
 	bool failed = false;
 	unsigned int cpu;
 
+	max_active = clamp_val(max_active, 1, INT_MAX);
+
 	wq = kzalloc(sizeof(*wq), GFP_KERNEL);
 	if (!wq)
 		goto err;
@@ -1495,8 +1526,10 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
 		cwq->cpu = cpu;
 		cwq->wq = wq;
 		cwq->flush_color = -1;
+		cwq->max_active = max_active;
 		spin_lock_init(&cwq->lock);
 		INIT_LIST_HEAD(&cwq->worklist);
+		INIT_LIST_HEAD(&cwq->delayed_works);
 		init_waitqueue_head(&cwq->more_work);
 
 		if (failed)
@@ -1556,6 +1589,8 @@ void destroy_workqueue(struct workqueue_struct *wq)
 
 		for (i = 0; i < WORK_NR_COLORS; i++)
 			BUG_ON(cwq->nr_in_flight[i]);
+		BUG_ON(cwq->nr_active);
+		BUG_ON(!list_empty(&cwq->delayed_works));
 	}
 
 	free_cwqs(wq->cpu_wq);
-- 
1.6.4.2

