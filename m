Return-Path: <linux-kernel-owner+w=401wt.eu-S1752821AbYAWKLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbYAWKLx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 05:11:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751397AbYAWKLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 05:11:46 -0500
Received: from brick.kernel.dk ([87.55.233.238]:11579 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751302AbYAWKLp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 05:11:45 -0500
Date: Wed, 23 Jan 2008 11:11:42 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu
Subject: [PATCH] Make idle iopriority class safe for non-root
Message-ID: <20080123101142.GJ6258@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Currently you must be root to set idle io prio class on a process. This
is due to the fact that the idle class is implemented as a true idle
class, meaning that it will not make progress if someone else is
requesting disk access. Unfortunately this means that it opens DOS
opportunities by locking down file system resources, hence it is root
only at the moment.

This patch relaxes the idle class a little, by removing the truly idle
part (which entals a grace period with associated timer). The
modifications make the idle class as close to zero impact as can be done
while still guarenteeing progress. This means we can relax the root only
criteria as well.

Tested to work well, testers welcome!

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 8830893..df9e9be 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -26,9 +26,9 @@ static const int cfq_slice_async_rq = 2;
 static int cfq_slice_idle = HZ / 125;
 
 /*
- * grace period before allowing idle class to get disk access
+ * offset from end of service tree
  */
-#define CFQ_IDLE_GRACE		(HZ / 10)
+#define CFQ_IDLE_DELAY		(HZ / 5)
 
 /*
  * below this threshold, we consider thinktime immediate
@@ -98,8 +98,6 @@ struct cfq_data {
 	struct cfq_queue *async_cfqq[2][IOPRIO_BE_NR];
 	struct cfq_queue *async_idle_cfqq;
 
-	struct timer_list idle_class_timer;
-
 	sector_t last_position;
 	unsigned long last_end_request;
 
@@ -384,12 +382,15 @@ cfq_choose_req(struct cfq_data *cfqd, struct request *rq1, struct request *rq2)
 /*
  * The below is leftmost cache rbtree addon
  */
-static struct rb_node *cfq_rb_first(struct cfq_rb_root *root)
+static struct cfq_queue *cfq_rb_first(struct cfq_rb_root *root)
 {
 	if (!root->left)
 		root->left = rb_first(&root->rb);
 
-	return root->left;
+	if (root->left)
+		return rb_entry(root->left, struct cfq_queue, rb_node);
+
+	return NULL;
 }
 
 static void cfq_rb_erase(struct rb_node *n, struct cfq_rb_root *root)
@@ -448,10 +449,19 @@ static void cfq_service_tree_add(struct cfq_data *cfqd,
 {
 	struct rb_node **p = &cfqd->service_tree.rb.rb_node;
 	struct rb_node *parent = NULL;
+	struct cfq_queue *__cfqq;
 	unsigned long rb_key;
 	int left;
 
-	if (!add_front) {
+	if (cfq_class_idle(cfqq)) {
+		rb_key = CFQ_IDLE_DELAY;
+		parent = rb_last(&cfqd->service_tree.rb);
+		if (parent && parent != &cfqq->rb_node) {
+			__cfqq = rb_entry(parent, struct cfq_queue, rb_node);
+			rb_key += __cfqq->rb_key;
+		} else
+			rb_key += jiffies;
+	} else if (!add_front) {
 		rb_key = cfq_slice_offset(cfqd, cfqq) + jiffies;
 		rb_key += cfqq->slice_resid;
 		cfqq->slice_resid = 0;
@@ -470,7 +480,6 @@ static void cfq_service_tree_add(struct cfq_data *cfqd,
 
 	left = 1;
 	while (*p) {
-		struct cfq_queue *__cfqq;
 		struct rb_node **n;
 
 		parent = *p;
@@ -736,11 +745,6 @@ static inline void
 __cfq_set_active_queue(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 {
 	if (cfqq) {
-		/*
-		 * stop potential idle class queues waiting service
-		 */
-		del_timer(&cfqd->idle_class_timer);
-
 		cfqq->slice_end = 0;
 		cfq_clear_cfqq_must_alloc_slice(cfqq);
 		cfq_clear_cfqq_fifo_expire(cfqq);
@@ -789,47 +793,16 @@ static inline void cfq_slice_expired(struct cfq_data *cfqd, int timed_out)
 		__cfq_slice_expired(cfqd, cfqq, timed_out);
 }
 
-static int start_idle_class_timer(struct cfq_data *cfqd)
-{
-	unsigned long end = cfqd->last_end_request + CFQ_IDLE_GRACE;
-	unsigned long now = jiffies;
-
-	if (time_before(now, end) &&
-	    time_after_eq(now, cfqd->last_end_request)) {
-		mod_timer(&cfqd->idle_class_timer, end);
-		return 1;
-	}
-
-	return 0;
-}
-
 /*
  * Get next queue for service. Unless we have a queue preemption,
  * we'll simply select the first cfqq in the service tree.
  */
 static struct cfq_queue *cfq_get_next_queue(struct cfq_data *cfqd)
 {
-	struct cfq_queue *cfqq;
-	struct rb_node *n;
-
 	if (RB_EMPTY_ROOT(&cfqd->service_tree.rb))
 		return NULL;
 
-	n = cfq_rb_first(&cfqd->service_tree);
-	cfqq = rb_entry(n, struct cfq_queue, rb_node);
-
-	if (cfq_class_idle(cfqq)) {
-		/*
-		 * if we have idle queues and no rt or be queues had
-		 * pending requests, either allow immediate service if
-		 * the grace period has passed or arm the idle grace
-		 * timer
-		 */
-		if (start_idle_class_timer(cfqd))
-			cfqq = NULL;
-	}
-
-	return cfqq;
+	return cfq_rb_first(&cfqd->service_tree);
 }
 
 /*
@@ -1087,14 +1060,11 @@ static inline int __cfq_forced_dispatch_cfqq(struct cfq_queue *cfqq)
  */
 static int cfq_forced_dispatch(struct cfq_data *cfqd)
 {
+	struct cfq_queue *cfqq;
 	int dispatched = 0;
-	struct rb_node *n;
-
-	while ((n = cfq_rb_first(&cfqd->service_tree)) != NULL) {
-		struct cfq_queue *cfqq = rb_entry(n, struct cfq_queue, rb_node);
 
+	while ((cfqq = cfq_rb_first(&cfqd->service_tree)) != NULL)
 		dispatched += __cfq_forced_dispatch_cfqq(cfqq);
-	}
 
 	cfq_slice_expired(cfqd, 0);
 
@@ -1437,15 +1407,16 @@ retry:
 		atomic_set(&cfqq->ref, 0);
 		cfqq->cfqd = cfqd;
 
-		if (is_sync) {
-			cfq_mark_cfqq_idle_window(cfqq);
-			cfq_mark_cfqq_sync(cfqq);
-		}
-
 		cfq_mark_cfqq_prio_changed(cfqq);
 		cfq_mark_cfqq_queue_new(cfqq);
 
 		cfq_init_prio_data(cfqq, ioc);
+
+		if (is_sync) {
+			if (!cfq_class_idle(cfqq))
+				cfq_mark_cfqq_idle_window(cfqq);
+			cfq_mark_cfqq_sync(cfqq);
+		}
 	}
 
 	if (new_cfqq)
@@ -1697,7 +1668,10 @@ cfq_update_idle_window(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 {
 	int enable_idle;
 
-	if (!cfq_cfqq_sync(cfqq))
+	/*
+	 * Don't idle for async or idle io prio class
+	 */
+	if (!cfq_cfqq_sync(cfqq) || cfq_class_idle(cfqq))
 		return;
 
 	enable_idle = cfq_cfqq_idle_window(cfqq);
@@ -1876,7 +1850,7 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
 			cfq_set_prio_slice(cfqd, cfqq);
 			cfq_clear_cfqq_slice_new(cfqq);
 		}
-		if (cfq_slice_used(cfqq))
+		if (cfq_slice_used(cfqq) || cfq_class_idle(cfqq))
 			cfq_slice_expired(cfqd, 1);
 		else if (sync && RB_EMPTY_ROOT(&cfqq->sort_list))
 			cfq_arm_slice_timer(cfqd);
@@ -2080,29 +2054,9 @@ out_cont:
 	spin_unlock_irqrestore(cfqd->queue->queue_lock, flags);
 }
 
-/*
- * Timer running if an idle class queue is waiting for service
- */
-static void cfq_idle_class_timer(unsigned long data)
-{
-	struct cfq_data *cfqd = (struct cfq_data *) data;
-	unsigned long flags;
-
-	spin_lock_irqsave(cfqd->queue->queue_lock, flags);
-
-	/*
-	 * race with a non-idle queue, reset timer
-	 */
-	if (!start_idle_class_timer(cfqd))
-		cfq_schedule_dispatch(cfqd);
-
-	spin_unlock_irqrestore(cfqd->queue->queue_lock, flags);
-}
-
 static void cfq_shutdown_timer_wq(struct cfq_data *cfqd)
 {
 	del_timer_sync(&cfqd->idle_slice_timer);
-	del_timer_sync(&cfqd->idle_class_timer);
 	kblockd_flush_work(&cfqd->unplug_work);
 }
 
@@ -2167,10 +2121,6 @@ static void *cfq_init_queue(struct request_queue *q)
 	cfqd->idle_slice_timer.function = cfq_idle_slice_timer;
 	cfqd->idle_slice_timer.data = (unsigned long) cfqd;
 
-	init_timer(&cfqd->idle_class_timer);
-	cfqd->idle_class_timer.function = cfq_idle_class_timer;
-	cfqd->idle_class_timer.data = (unsigned long) cfqd;
-
 	INIT_WORK(&cfqd->unplug_work, cfq_kick_queue);
 
 	cfqd->last_end_request = jiffies;
diff --git a/fs/ioprio.c b/fs/ioprio.c
index 06b5d97..c4a1c3c 100644
--- a/fs/ioprio.c
+++ b/fs/ioprio.c
@@ -85,8 +85,6 @@ asmlinkage long sys_ioprio_set(int which, int who, int ioprio)
 
 			break;
 		case IOPRIO_CLASS_IDLE:
-			if (!capable(CAP_SYS_ADMIN))
-				return -EPERM;
 			break;
 		case IOPRIO_CLASS_NONE:
 			if (data)

-- 
Jens Axboe

