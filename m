Return-Path: <linux-kernel-owner+w=401wt.eu-S1759239AbYGFWHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759239AbYGFWHY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 18:07:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753644AbYGFWHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 18:07:10 -0400
Received: from smtp-out.google.com ([216.239.33.17]:5741 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081AbYGFWHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 18:07:06 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:references:user-agent:date:from:to:cc:
	subject:content-disposition;
	b=WRncvI9V9pUKRf34w7orblr9AGO2rNgU0XqLkbIbOCS3kC9QcPdw7vPxg8Mx/CrPS
	uDsizQzYSyCfVsdVNUNNA==
Message-Id: <20080706220612.217985000@elf.corp.google.com>
References: <20080706220551.136430000@elf.corp.google.com>
User-Agent: quilt/0.46-1
Date: Sun, 06 Jul 2008 15:05:52 -0700
From: ngupta@google.com
To: linux-kernel@vger.kernel.org
Cc: jens.axboe@oracle.com, akpm@linux-foundation.org
Subject: [PATCH] Priorities in Anticipatory I/O scheduler
Content-Disposition: inline; filename=mail.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Modifications to the Anticipatory I/O scheduler to add multiple priority
levels. It makes use of anticipation and batching in current
anticipatory scheduler to implement priorities.

- Minimizes the latency of highest priority level.
- Low priority requests wait for high priority requests.
- Higher priority request break any anticipating low priority request.
- If single priority level is used the scheduler behaves as an
  anticipatory scheduler. So no change for existing users.

With this change, it is possible for a latency sensitive job to coexist
with background job.

Other possible use of this patch is in context of I/O subsystem controller.
It can add another dimension to the parameters controlling a particular cgroup.
While we can easily divide b/w among existing croups, setting a bound on
latency is not a feasible solution. Hence in context of storage devices
bandwidth and priority can be two parameters controlling I/O.

In this patch I have added a new class IOPRIO_CLASS_LATENCY to differentiate
notion of absolute priority over existing uses of various time-slice based
priority classes in cfq. Though internally within anticipatory scheduler all
of them map to best-effort levels. Hence, one can also use various best-effort
priority levels.

Signed-off by: Naveen Gupta <ngupta@google.com>
---

Index: b/block/Kconfig.iosched
===================================================================
--- a/block/Kconfig.iosched
+++ b/block/Kconfig.iosched
@@ -21,6 +21,14 @@ config IOSCHED_AS
 	  deadline I/O scheduler, it can also be slower in some cases
 	  especially some database loads.
 
+config IOPRIO_AS_MAX
+	int "Number of valid i/o priority levels"
+	depends on IOSCHED_AS
+	default "4"
+	help
+	  This option controls number of priority levels in anticipatory
+	  I/O scheduler.
+
 config IOSCHED_DEADLINE
 	tristate "Deadline I/O scheduler"
 	default y
Index: b/block/as-iosched.c
===================================================================
--- a/block/as-iosched.c
+++ b/block/as-iosched.c
@@ -16,6 +16,8 @@
 #include <linux/compiler.h>
 #include <linux/rbtree.h>
 #include <linux/interrupt.h>
+#include <linux/ioprio.h>
+#include <linux/ctype.h>
 
 #define REQ_SYNC	1
 #define REQ_ASYNC	0
@@ -89,10 +91,14 @@ struct as_data {
 	/*
 	 * requests (as_rq s) are present on both sort_list and fifo_list
 	 */
-	struct rb_root sort_list[2];
-	struct list_head fifo_list[2];
+	struct {
+		struct rb_root sort_list[2];
+		struct list_head fifo_list[2];
+		struct request *next_rq[2];
+		unsigned long ioprio_wt;
+		unsigned long serviced;
+	} prio_q[IOPRIO_AS_MAX];
 
-	struct request *next_rq[2];	/* next in sort order */
 	sector_t last_sector[2];	/* last REQ_SYNC & REQ_ASYNC sectors */
 
 	unsigned long exit_prob;	/* probability a task will exit while
@@ -113,6 +119,7 @@ struct as_data {
 	int write_batch_count;		/* max # of reqs in a write batch */
 	int current_write_count;	/* how many requests left this batch */
 	int write_batch_idled;		/* has the write batch gone idle? */
+	unsigned short batch_ioprio;
 
 	enum anticipation_status antic_status;
 	unsigned long antic_start;	/* jiffies: when it started */
@@ -155,6 +162,8 @@ static struct completion *ioc_gone;
 static void as_move_to_dispatch(struct as_data *ad, struct request *rq);
 static void as_antic_stop(struct as_data *ad);
 
+static unsigned short as_mapped_priority(unsigned short ioprio);
+
 /*
  * IO Context helper functions
  */
@@ -246,16 +255,25 @@ static void as_put_io_context(struct req
 	put_io_context(RQ_IOC(rq));
 }
 
+static inline unsigned short rq_prio_level(struct request *rq)
+{
+	return IOPRIO_PRIO_DATA(as_mapped_priority(rq->ioprio));
+}
+
 /*
  * rb tree support functions
  */
-#define RQ_RB_ROOT(ad, rq)	(&(ad)->sort_list[rq_is_sync((rq))])
+static inline struct rb_root *rq_rb_root(struct as_data *ad,
+						struct request *rq)
+{
+	return (&(ad)->prio_q[rq_prio_level(rq)].sort_list[rq_is_sync(rq)]);
+}
 
 static void as_add_rq_rb(struct as_data *ad, struct request *rq)
 {
 	struct request *alias;
 
-	while ((unlikely(alias = elv_rb_add(RQ_RB_ROOT(ad, rq), rq)))) {
+	while ((unlikely(alias = elv_rb_add(rq_rb_root(ad, rq), rq)))) {
 		as_move_to_dispatch(ad, alias);
 		as_antic_stop(ad);
 	}
@@ -263,7 +281,14 @@ static void as_add_rq_rb(struct as_data 
 
 static inline void as_del_rq_rb(struct as_data *ad, struct request *rq)
 {
-	elv_rb_del(RQ_RB_ROOT(ad, rq), rq);
+	elv_rb_del(rq_rb_root(ad, rq), rq);
+}
+
+static inline struct request *ad_fifo_next(struct as_data *ad,
+						unsigned short ioprio,
+						int dir)
+{
+	return rq_entry_fifo(ad->prio_q[ioprio].fifo_list[dir].next);
 }
 
 /*
@@ -371,9 +396,7 @@ as_find_next_rq(struct as_data *ad, stru
 	if (rbnext)
 		next = rb_entry_rq(rbnext);
 	else {
-		const int data_dir = rq_is_sync(last);
-
-		rbnext = rb_first(&ad->sort_list[data_dir]);
+		rbnext = rb_first(rq_rb_root(ad, last));
 		if (rbnext && rbnext != &last->rb_node)
 			next = rb_entry_rq(rbnext);
 	}
@@ -626,6 +649,9 @@ static int as_close_req(struct as_data *
  * as_can_break_anticipation returns true if we have been anticipating this
  * request.
  *
+ * It also returns true if this request is a higher priority request than
+ * what we have been anticipating.
+ *
  * It also returns true if the process against which we are anticipating
  * submits a write - that's presumably an fsync, O_SYNC write, etc. We want to
  * dispatch it ASAP, because we know that application will not be submitting
@@ -639,6 +665,7 @@ static int as_can_break_anticipation(str
 {
 	struct io_context *ioc;
 	struct as_io_context *aic;
+	unsigned short cioprio, rioprio = 0;
 
 	ioc = ad->io_context;
 	BUG_ON(!ioc);
@@ -677,6 +704,42 @@ static int as_can_break_anticipation(str
 		return 1;
 	}
 
+	cioprio = as_mapped_priority(ioc->ioprio);
+	if (rq)
+		rioprio = as_mapped_priority(rq->ioprio);
+
+	if (rq && ioprio_best(cioprio, rioprio) != cioprio) {
+		/*
+		 * High priority request, if it has tokens break
+		 * anticipation.
+		 */
+		if ((ad->prio_q[rq_prio_level(rq)].serviced <
+			ad->prio_q[rq_prio_level(rq)].ioprio_wt)) {
+			spin_unlock(&ioc->lock);
+			return 1;
+		} else {
+			spin_unlock(&ioc->lock);
+			return 0;
+		}
+	}
+
+	if (rq && cioprio != rioprio &&
+			ioprio_best(cioprio, rioprio) == cioprio) {
+		/*
+		 * low priority request. do not anticipate unless
+		 * current has no tokens.
+		 */
+		unsigned short clevel = IOPRIO_PRIO_DATA(cioprio);
+		if ((ad->prio_q[clevel].serviced <
+				ad->prio_q[clevel].ioprio_wt)) {
+			spin_unlock(&ioc->lock);
+			return 0;
+		} else {
+			spin_unlock(&ioc->lock);
+			return 1;
+		}
+	}
+
 	if (rq && rq_is_sync(rq) && as_close_req(ad, aic, rq)) {
 		/*
 		 * Found a close request that is not one of ours.
@@ -772,7 +835,9 @@ static void as_update_rq(struct as_data 
 	const int data_dir = rq_is_sync(rq);
 
 	/* keep the next_rq cache up to date */
-	ad->next_rq[data_dir] = as_choose_req(ad, rq, ad->next_rq[data_dir]);
+	ad->prio_q[rq_prio_level(rq)].next_rq[data_dir] =
+		as_choose_req(ad, rq,
+			 ad->prio_q[rq_prio_level(rq)].next_rq[data_dir]);
 
 	/*
 	 * have we been anticipating this request?
@@ -894,8 +959,9 @@ static void as_remove_queued_request(str
 	 * Update the "next_rq" cache if we are about to remove its
 	 * entry
 	 */
-	if (ad->next_rq[data_dir] == rq)
-		ad->next_rq[data_dir] = as_find_next_rq(ad, rq);
+	if (ad->prio_q[rq_prio_level(rq)].next_rq[data_dir] == rq)
+		ad->prio_q[rq_prio_level(rq)].next_rq[data_dir] =
+						as_find_next_rq(ad, rq);
 
 	rq_fifo_clear(rq);
 	as_del_rq_rb(ad, rq);
@@ -909,7 +975,7 @@ static void as_remove_queued_request(str
  *
  * See as_antic_expired comment.
  */
-static int as_fifo_expired(struct as_data *ad, int adir)
+static int as_fifo_expired(struct as_data *ad, int adir, unsigned short ioprio)
 {
 	struct request *rq;
 	long delta_jif;
@@ -922,10 +988,10 @@ static int as_fifo_expired(struct as_dat
 
 	ad->last_check_fifo[adir] = jiffies;
 
-	if (list_empty(&ad->fifo_list[adir]))
+	if (list_empty(&ad->prio_q[ioprio].fifo_list[adir]))
 		return 0;
 
-	rq = rq_entry_fifo(ad->fifo_list[adir].next);
+	rq = rq_entry_fifo(ad->prio_q[ioprio].fifo_list[adir].next);
 
 	return time_after(jiffies, rq_fifo_time(rq));
 }
@@ -947,6 +1013,15 @@ static inline int as_batch_expired(struc
 		|| ad->current_write_count == 0;
 }
 
+static int as_has_request_at_priority(struct as_data *ad,
+					unsigned int priority)
+{
+	if (list_empty(&ad->prio_q[priority].fifo_list[REQ_SYNC]) &&
+	    list_empty(&ad->prio_q[priority].fifo_list[REQ_ASYNC]))
+		return 0;
+	return 1;
+}
+
 /*
  * move an entry to dispatch queue
  */
@@ -980,7 +1055,8 @@ static void as_move_to_dispatch(struct a
 	}
 	ad->ioc_finished = 0;
 
-	ad->next_rq[data_dir] = as_find_next_rq(ad, rq);
+	ad->prio_q[rq_prio_level(rq)].next_rq[data_dir] =
+						as_find_next_rq(ad, rq);
 
 	/*
 	 * take it off the sort and fifo list, add to dispatch queue
@@ -988,6 +1064,8 @@ static void as_move_to_dispatch(struct a
 	as_remove_queued_request(ad->q, rq);
 	WARN_ON(RQ_STATE(rq) != AS_RQ_QUEUED);
 
+	ad->prio_q[rq_prio_level(rq)].serviced++;
+
 	elv_dispatch_sort(ad->q, rq);
 
 	RQ_SET_STATE(rq, AS_RQ_DISPATCHED);
@@ -996,6 +1074,31 @@ static void as_move_to_dispatch(struct a
 	ad->nr_dispatched++;
 }
 
+static unsigned int select_priority_level(struct as_data *ad)
+{
+	unsigned int i, best_ioprio = 0, ioprio, found_alt = 0;
+
+	for (ioprio = 0; ioprio < IOPRIO_AS_MAX; ioprio++) {
+		if (!as_has_request_at_priority(ad, ioprio)) {
+			continue;
+		}
+		if (ad->prio_q[ioprio].serviced < ad->prio_q[ioprio].ioprio_wt)
+			return ioprio;
+		if (!found_alt) {
+			best_ioprio = ioprio;
+			found_alt = 1;
+		}
+	}
+
+	if (found_alt) {
+		ioprio = best_ioprio;
+		for (i = 0; i < IOPRIO_AS_MAX; i++)
+			ad->prio_q[i].serviced = 0;
+	}
+
+	return ioprio;
+}
+
 /*
  * as_dispatch_request selects the best request according to
  * read/write expire, batch expire, etc, and moves it to the dispatch
@@ -1004,9 +1107,10 @@ static void as_move_to_dispatch(struct a
 static int as_dispatch_request(struct request_queue *q, int force)
 {
 	struct as_data *ad = q->elevator->elevator_data;
-	const int reads = !list_empty(&ad->fifo_list[REQ_SYNC]);
-	const int writes = !list_empty(&ad->fifo_list[REQ_ASYNC]);
 	struct request *rq;
+	unsigned short ioprio;
+	int reads, writes;
+	int changed_ioprio;
 
 	if (unlikely(force)) {
 		/*
@@ -1022,21 +1126,32 @@ static int as_dispatch_request(struct re
 		ad->changed_batch = 0;
 		ad->new_batch = 0;
 
-		while (ad->next_rq[REQ_SYNC]) {
-			as_move_to_dispatch(ad, ad->next_rq[REQ_SYNC]);
-			dispatched++;
-		}
-		ad->last_check_fifo[REQ_SYNC] = jiffies;
-
-		while (ad->next_rq[REQ_ASYNC]) {
-			as_move_to_dispatch(ad, ad->next_rq[REQ_ASYNC]);
-			dispatched++;
+		for (ioprio = 0; ioprio < IOPRIO_AS_MAX; ioprio++) {
+			while (ad->prio_q[ioprio].next_rq[REQ_SYNC]) {
+				as_move_to_dispatch(ad,
+				    ad->prio_q[ioprio].next_rq[REQ_SYNC]);
+				dispatched++;
+			}
+			ad->last_check_fifo[REQ_SYNC] = jiffies;
+
+			while (ad->prio_q[ioprio].next_rq[REQ_ASYNC]) {
+				as_move_to_dispatch(ad,
+				    ad->prio_q[ioprio].next_rq[REQ_ASYNC]);
+				dispatched++;
+			}
+			ad->last_check_fifo[REQ_ASYNC] = jiffies;
 		}
-		ad->last_check_fifo[REQ_ASYNC] = jiffies;
 
 		return dispatched;
 	}
 
+	ioprio = select_priority_level(ad);
+	if (ioprio >= IOPRIO_AS_MAX)
+		return 0;
+
+	reads = !list_empty(&ad->prio_q[ioprio].fifo_list[REQ_SYNC]);
+	writes = !list_empty(&ad->prio_q[ioprio].fifo_list[REQ_ASYNC]);
+
 	/* Signal that the write batch was uncontended, so we can't time it */
 	if (ad->batch_data_dir == REQ_ASYNC && !reads) {
 		if (ad->current_write_count == 0 || !writes)
@@ -1049,14 +1164,16 @@ static int as_dispatch_request(struct re
 		|| ad->changed_batch)
 		return 0;
 
+	changed_ioprio = (ad->batch_ioprio != ioprio)?1:0;
+
 	if (!(reads && writes && as_batch_expired(ad))) {
 		/*
 		 * batch is still running or no reads or no writes
 		 */
-		rq = ad->next_rq[ad->batch_data_dir];
+		rq = ad->prio_q[ioprio].next_rq[ad->batch_data_dir];
 
 		if (ad->batch_data_dir == REQ_SYNC && ad->antic_expire) {
-			if (as_fifo_expired(ad, REQ_SYNC))
+			if (as_fifo_expired(ad, REQ_SYNC, ioprio))
 				goto fifo_expired;
 
 			if (as_can_anticipate(ad, rq)) {
@@ -1065,7 +1182,7 @@ static int as_dispatch_request(struct re
 			}
 		}
 
-		if (rq) {
+		if (!changed_ioprio && rq) {
 			/* we have a "next request" */
 			if (reads && !writes)
 				ad->current_batch_expires =
@@ -1080,9 +1197,10 @@ static int as_dispatch_request(struct re
 	 */
 
 	if (reads) {
-		BUG_ON(RB_EMPTY_ROOT(&ad->sort_list[REQ_SYNC]));
+		BUG_ON(RB_EMPTY_ROOT(&ad->prio_q[ioprio].sort_list[REQ_SYNC]));
 
-		if (writes && ad->batch_data_dir == REQ_SYNC)
+		if (!changed_ioprio && writes &&
+				 ad->batch_data_dir == REQ_SYNC)
 			/*
 			 * Last batch was a read, switch to writes
 			 */
@@ -1091,9 +1209,12 @@ static int as_dispatch_request(struct re
 		if (ad->batch_data_dir == REQ_ASYNC) {
 			WARN_ON(ad->new_batch);
 			ad->changed_batch = 1;
-		}
+		} else if (changed_ioprio)
+			ad->current_batch_expires =
+				jiffies + ad->batch_expire[REQ_SYNC];
+		ad->batch_ioprio = ioprio;
 		ad->batch_data_dir = REQ_SYNC;
-		rq = rq_entry_fifo(ad->fifo_list[REQ_SYNC].next);
+		rq = ad_fifo_next(ad, ioprio, REQ_SYNC);
 		ad->last_check_fifo[ad->batch_data_dir] = jiffies;
 		goto dispatch_request;
 	}
@@ -1104,7 +1225,7 @@ static int as_dispatch_request(struct re
 
 	if (writes) {
 dispatch_writes:
-		BUG_ON(RB_EMPTY_ROOT(&ad->sort_list[REQ_ASYNC]));
+		BUG_ON(RB_EMPTY_ROOT(&ad->prio_q[ioprio].sort_list[REQ_ASYNC]));
 
 		if (ad->batch_data_dir == REQ_SYNC) {
 			ad->changed_batch = 1;
@@ -1115,11 +1236,14 @@ dispatch_writes:
 			 * cause a change of batch before the read is finished.
 			 */
 			ad->new_batch = 0;
-		}
+		} else if (changed_ioprio)
+			ad->current_batch_expires = jiffies +
+						ad->batch_expire[REQ_ASYNC];
+		ad->batch_ioprio = ioprio;
 		ad->batch_data_dir = REQ_ASYNC;
 		ad->current_write_count = ad->write_batch_count;
 		ad->write_batch_idled = 0;
-		rq = rq_entry_fifo(ad->fifo_list[REQ_ASYNC].next);
+		rq = ad_fifo_next(ad, ioprio, REQ_ASYNC);
 		ad->last_check_fifo[REQ_ASYNC] = jiffies;
 		goto dispatch_request;
 	}
@@ -1132,9 +1256,9 @@ dispatch_request:
 	 * If a request has expired, service it.
 	 */
 
-	if (as_fifo_expired(ad, ad->batch_data_dir)) {
+	if (as_fifo_expired(ad, ad->batch_data_dir, ioprio)) {
 fifo_expired:
-		rq = rq_entry_fifo(ad->fifo_list[ad->batch_data_dir].next);
+		rq = ad_fifo_next(ad, ioprio, ad->batch_data_dir);
 	}
 
 	if (ad->changed_batch) {
@@ -1185,7 +1309,8 @@ static void as_add_request(struct reques
 	 * set expire time and add to fifo list
 	 */
 	rq_set_fifo_time(rq, jiffies + ad->fifo_expire[data_dir]);
-	list_add_tail(&rq->queuelist, &ad->fifo_list[data_dir]);
+	list_add_tail(&rq->queuelist,
+			&ad->prio_q[rq_prio_level(rq)].fifo_list[data_dir]);
 
 	as_update_rq(ad, rq); /* keep state machine up to date */
 	RQ_SET_STATE(rq, AS_RQ_QUEUED);
@@ -1216,9 +1341,39 @@ static void as_deactivate_request(struct
 static int as_queue_empty(struct request_queue *q)
 {
 	struct as_data *ad = q->elevator->elevator_data;
+	unsigned short ioprio;
 
-	return list_empty(&ad->fifo_list[REQ_ASYNC])
-		&& list_empty(&ad->fifo_list[REQ_SYNC]);
+	for (ioprio = 0; ioprio < IOPRIO_AS_MAX; ioprio++) {
+		if (as_has_request_at_priority(ad, ioprio))
+			return 0;
+	}
+	return 1;
+}
+
+static unsigned short as_mapped_priority(unsigned short ioprio)
+{
+	unsigned short class = IOPRIO_PRIO_CLASS(ioprio);
+	unsigned short data = IOPRIO_PRIO_DATA(ioprio);
+
+	if (class == IOPRIO_CLASS_BE)
+		return ((data < IOPRIO_AS_MAX)? ioprio:
+			IOPRIO_PRIO_VALUE(IOPRIO_CLASS_BE,
+						(IOPRIO_AS_MAX - 1)));
+	else if (class == IOPRIO_CLASS_LATENCY)
+		return ((data < IOPRIO_AS_MAX)?
+			IOPRIO_PRIO_VALUE(IOPRIO_CLASS_BE, data):
+			IOPRIO_PRIO_VALUE(IOPRIO_CLASS_BE,
+						(IOPRIO_AS_MAX - 1)));
+	else if (class == IOPRIO_CLASS_RT)
+		return IOPRIO_PRIO_VALUE(IOPRIO_CLASS_BE, 0);
+	else if (class == IOPRIO_CLASS_IDLE)
+		return IOPRIO_PRIO_VALUE(IOPRIO_CLASS_BE, (IOPRIO_AS_MAX - 1));
+	else if (class == IOPRIO_CLASS_NONE) {
+		return IOPRIO_AS_DEFAULT;
+	} else {
+		WARN_ON(1);
+		return IOPRIO_AS_DEFAULT;
+	}
 }
 
 static int
@@ -1227,11 +1382,15 @@ as_merge(struct request_queue *q, struct
 	struct as_data *ad = q->elevator->elevator_data;
 	sector_t rb_key = bio->bi_sector + bio_sectors(bio);
 	struct request *__rq;
+	unsigned short ioprio;
+
+	ioprio = IOPRIO_PRIO_DATA(as_mapped_priority(bio_prio(bio)));
 
 	/*
 	 * check for front merge
 	 */
-	__rq = elv_rb_find(&ad->sort_list[bio_data_dir(bio)], rb_key);
+	__rq = elv_rb_find(&ad->prio_q[ioprio].sort_list[bio_data_dir(bio)],
+								 rb_key);
 	if (__rq && elv_rq_merge_ok(__rq, bio)) {
 		*req = __rq;
 		return ELEVATOR_FRONT_MERGE;
@@ -1321,12 +1480,13 @@ static int as_may_queue(struct request_q
 static void as_exit_queue(elevator_t *e)
 {
 	struct as_data *ad = e->elevator_data;
+	int ioprio;
 
 	del_timer_sync(&ad->antic_timer);
 	kblockd_flush_work(&ad->antic_work);
 
-	BUG_ON(!list_empty(&ad->fifo_list[REQ_SYNC]));
-	BUG_ON(!list_empty(&ad->fifo_list[REQ_ASYNC]));
+	for (ioprio = 0; ioprio < IOPRIO_AS_MAX; ioprio++)
+		BUG_ON(as_has_request_at_priority(ad, ioprio));
 
 	put_io_context(ad->io_context);
 	kfree(ad);
@@ -1338,6 +1498,7 @@ static void as_exit_queue(elevator_t *e)
 static void *as_init_queue(struct request_queue *q)
 {
 	struct as_data *ad;
+	int i;
 
 	ad = kmalloc_node(sizeof(*ad), GFP_KERNEL | __GFP_ZERO, q->node);
 	if (!ad)
@@ -1351,10 +1512,20 @@ static void *as_init_queue(struct reques
 	init_timer(&ad->antic_timer);
 	INIT_WORK(&ad->antic_work, as_work_handler);
 
-	INIT_LIST_HEAD(&ad->fifo_list[REQ_SYNC]);
-	INIT_LIST_HEAD(&ad->fifo_list[REQ_ASYNC]);
-	ad->sort_list[REQ_SYNC] = RB_ROOT;
-	ad->sort_list[REQ_ASYNC] = RB_ROOT;
+	for (i = IOPRIO_AS_MAX - 1; i >= 0; i--) {
+		INIT_LIST_HEAD(&ad->prio_q[i].fifo_list[REQ_SYNC]);
+		INIT_LIST_HEAD(&ad->prio_q[i].fifo_list[REQ_ASYNC]);
+		ad->prio_q[i].sort_list[REQ_SYNC] = RB_ROOT;
+		ad->prio_q[i].sort_list[REQ_ASYNC] = RB_ROOT;
+		ad->prio_q[i].serviced = 0;
+		if (i == 0)
+			ad->prio_q[i].ioprio_wt = 100;
+		else if (i == 1)
+			ad->prio_q[i].ioprio_wt = 5;
+		else
+			ad->prio_q[i].ioprio_wt = 1;
+	}
+
 	ad->fifo_expire[REQ_SYNC] = default_read_expire;
 	ad->fifo_expire[REQ_ASYNC] = default_write_expire;
 	ad->antic_expire = default_antic_expire;
@@ -1405,6 +1576,56 @@ static ssize_t est_time_show(elevator_t 
 	return pos;
 }
 
+static ssize_t as_priority_weights_show(elevator_t *e, char *page)
+{
+	struct as_data *ad = e->elevator_data;
+	int i, pos = 0;
+
+	for (i = 0; i < IOPRIO_AS_MAX; i++)
+		pos += sprintf(page + pos, "%lu ", ad->prio_q[i].ioprio_wt);
+
+	pos += sprintf(page + pos, "\n");
+
+	return pos;
+}
+
+static ssize_t as_priority_weights_store(elevator_t *e, const char *page,
+							size_t count)
+{
+	struct as_data *ad = e->elevator_data;
+	char *prev_p, *p = (char *)page;
+	unsigned long val;
+	int i = 0, j, tcount = count;
+	unsigned long ioprio_wt[IOPRIO_AS_MAX];
+
+	while(tcount && i < IOPRIO_AS_MAX) {
+		prev_p = p;
+		/* Initial whitespace ignored by the next while loop. */
+		val = simple_strtoul(p, &p, 10);
+		tcount -= (p - prev_p);
+		/* Don't terminate on seeing whitespace. */
+		if ((p - prev_p) && (val == 0))
+			goto err;
+		while (tcount && isspace(*p)) {
+			p++;
+			tcount--;
+		}
+		/* If not whitespace and value > 0, it is valid input. */
+		if (val > 0)
+			ioprio_wt[i++] = val;
+		if (tcount && !isdigit(*p))
+			goto err;
+	}
+
+	if (i == IOPRIO_AS_MAX && !tcount)
+		for (j = 0; j < IOPRIO_AS_MAX; j++)
+			ad->prio_q[j].ioprio_wt = ioprio_wt[j];
+
+	return count;
+err:
+	return -EINVAL;
+}
+
 #define SHOW_FUNCTION(__FUNC, __VAR)				\
 static ssize_t __FUNC(elevator_t *e, char *page)		\
 {								\
@@ -1449,11 +1670,22 @@ static struct elv_fs_entry as_attrs[] = 
 	AS_ATTR(antic_expire),
 	AS_ATTR(read_batch_expire),
 	AS_ATTR(write_batch_expire),
+	AS_ATTR(priority_weights),
 	__ATTR_NULL
 };
 
+static int as_allow_merge(struct request_queue *q, struct request *rq,
+				struct bio *bio)
+{
+	if (as_mapped_priority(rq->ioprio) !=
+				as_mapped_priority(bio_prio(bio)))
+		return 0;
+	return 1;
+}
+
 static struct elevator_type iosched_as = {
 	.ops = {
+		.elevator_allow_merge_fn =	as_allow_merge,
 		.elevator_merge_fn = 		as_merge,
 		.elevator_merged_fn =		as_merged_request,
 		.elevator_merge_req_fn =	as_merged_requests,
Index: b/include/linux/bio.h
===================================================================
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -161,7 +161,6 @@ struct bio {
 #define bio_prio_valid(bio)	ioprio_valid(bio_prio(bio))
 
 #define bio_set_prio(bio, prio)		do {			\
-	WARN_ON(prio >= (1 << IOPRIO_BITS));			\
 	(bio)->bi_rw &= ((1UL << BIO_PRIO_SHIFT) - 1);		\
 	(bio)->bi_rw |= ((unsigned long) (prio) << BIO_PRIO_SHIFT);	\
 } while (0)
Index: b/include/linux/ioprio.h
===================================================================
--- a/include/linux/ioprio.h
+++ b/include/linux/ioprio.h
@@ -28,6 +28,7 @@ enum {
 	IOPRIO_CLASS_RT,
 	IOPRIO_CLASS_BE,
 	IOPRIO_CLASS_IDLE,
+	IOPRIO_CLASS_LATENCY,
 };
 
 /*
@@ -35,6 +36,10 @@ enum {
  */
 #define IOPRIO_BE_NR	(8)
 
+#define IOPRIO_AS_MAX  CONFIG_IOPRIO_AS_MAX
+
+#define IOPRIO_AS_DEFAULT      IOPRIO_PRIO_VALUE(IOPRIO_CLASS_BE, 2)
+
 enum {
 	IOPRIO_WHO_PROCESS = 1,
 	IOPRIO_WHO_PGRP,
Index: b/block/blk-core.c
===================================================================
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1477,6 +1477,10 @@ void submit_bio(int rw, struct bio *bio)
 
 	bio->bi_rw |= rw;
 
+	if (current->io_context)
+		bio_set_prio(bio, current->io_context->ioprio);
+
+
 	/*
 	 * If it's a regular read/write or a barrier with data attached,
 	 * go through the normal accounting stuff before submission.
Index: b/fs/ioprio.c
===================================================================
--- a/fs/ioprio.c
+++ b/fs/ioprio.c
@@ -180,6 +180,7 @@ int ioprio_best(unsigned short aprio, un
 	else
 		return aprio;
 }
+EXPORT_SYMBOL(ioprio_best);
 
 asmlinkage long sys_ioprio_get(int which, int who)
 {

-- 
