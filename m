Return-Path: <linux-kernel-owner+w=401wt.eu-S1759319AbZEYHig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759319AbZEYHig (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 03:38:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755497AbZEYHe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 03:34:26 -0400
Received: from brick.kernel.dk ([93.163.65.50]:38668 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752222AbZEYHbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 03:31:13 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 07/13] block: avoid indirect calls to enter cfq io scheduler
Date: Mon, 25 May 2009 09:30:56 +0200
Message-Id: <1243236668-3398-14-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.3.rc0.1.gf800
In-Reply-To: <1243236668-3398-1-git-send-email-jens.axboe@oracle.com>
References: <1243236668-3398-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They can be expensive, since CPUs generally do not branch predict
well for them.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 block/Kconfig.iosched |    4 +
 block/cfq-iosched.c   |   36 +++++------
 block/cfq-iosched.h   |   23 +++++++
 block/elevator.c      |   33 +++++-----
 block/elevator.h      |  162 +++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 223 insertions(+), 35 deletions(-)
 create mode 100644 block/cfq-iosched.h
 create mode 100644 block/elevator.h

diff --git a/block/Kconfig.iosched b/block/Kconfig.iosched
index 7e803fc..9abb717 100644
--- a/block/Kconfig.iosched
+++ b/block/Kconfig.iosched
@@ -40,6 +40,10 @@ config IOSCHED_CFQ
 	  working environment, suitable for desktop systems.
 	  This is the default I/O scheduler.
 
+config IOSCHED_CFQ_BUILTIN
+	bool
+	default y if IOSCHED_CFQ=y
+
 choice
 	prompt "Default I/O scheduler"
 	default DEFAULT_CFQ
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index a55a9bd..faa006a 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -13,6 +13,8 @@
 #include <linux/ioprio.h>
 #include <linux/blktrace_api.h>
 
+#include "cfq-iosched.h"
+
 /*
  * tunables
  */
@@ -271,7 +273,7 @@ static inline void cfq_schedule_dispatch(struct cfq_data *cfqd)
 	}
 }
 
-static int cfq_queue_empty(struct request_queue *q)
+int cfq_queue_empty(struct request_queue *q)
 {
 	struct cfq_data *cfqd = q->elevator->elevator_data;
 
@@ -752,7 +754,7 @@ cfq_find_rq_fmerge(struct cfq_data *cfqd, struct bio *bio)
 	return NULL;
 }
 
-static void cfq_activate_request(struct request_queue *q, struct request *rq)
+void cfq_activate_request(struct request_queue *q, struct request *rq)
 {
 	struct cfq_data *cfqd = q->elevator->elevator_data;
 
@@ -763,7 +765,7 @@ static void cfq_activate_request(struct request_queue *q, struct request *rq)
 	cfqd->last_position = rq->hard_sector + rq->hard_nr_sectors;
 }
 
-static void cfq_deactivate_request(struct request_queue *q, struct request *rq)
+void cfq_deactivate_request(struct request_queue *q, struct request *rq)
 {
 	struct cfq_data *cfqd = q->elevator->elevator_data;
 
@@ -790,8 +792,7 @@ static void cfq_remove_request(struct request *rq)
 	}
 }
 
-static int cfq_merge(struct request_queue *q, struct request **req,
-		     struct bio *bio)
+int cfq_merge(struct request_queue *q, struct request **req, struct bio *bio)
 {
 	struct cfq_data *cfqd = q->elevator->elevator_data;
 	struct request *__rq;
@@ -805,8 +806,7 @@ static int cfq_merge(struct request_queue *q, struct request **req,
 	return ELEVATOR_NO_MERGE;
 }
 
-static void cfq_merged_request(struct request_queue *q, struct request *req,
-			       int type)
+void cfq_merged_request(struct request_queue *q, struct request *req, int type)
 {
 	if (type == ELEVATOR_FRONT_MERGE) {
 		struct cfq_queue *cfqq = RQ_CFQQ(req);
@@ -815,9 +815,8 @@ static void cfq_merged_request(struct request_queue *q, struct request *req,
 	}
 }
 
-static void
-cfq_merged_requests(struct request_queue *q, struct request *rq,
-		    struct request *next)
+void cfq_merged_requests(struct request_queue *q, struct request *rq,
+			 struct request *next)
 {
 	/*
 	 * reposition in fifo if next is older than rq
@@ -829,8 +828,8 @@ cfq_merged_requests(struct request_queue *q, struct request *rq,
 	cfq_remove_request(next);
 }
 
-static int cfq_allow_merge(struct request_queue *q, struct request *rq,
-			   struct bio *bio)
+int cfq_allow_merge(struct request_queue *q, struct request *rq,
+		    struct bio *bio)
 {
 	struct cfq_data *cfqd = q->elevator->elevator_data;
 	struct cfq_io_context *cic;
@@ -1291,7 +1290,7 @@ static void cfq_dispatch_request(struct cfq_data *cfqd, struct cfq_queue *cfqq)
  * Find the cfqq that we need to service and move a request from that to the
  * dispatch list
  */
-static int cfq_dispatch_requests(struct request_queue *q, int force)
+int cfq_dispatch_requests(struct request_queue *q, int force)
 {
 	struct cfq_data *cfqd = q->elevator->elevator_data;
 	struct cfq_queue *cfqq;
@@ -2104,7 +2103,7 @@ cfq_rq_enqueued(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	}
 }
 
-static void cfq_insert_request(struct request_queue *q, struct request *rq)
+void cfq_insert_request(struct request_queue *q, struct request *rq)
 {
 	struct cfq_data *cfqd = q->elevator->elevator_data;
 	struct cfq_queue *cfqq = RQ_CFQQ(rq);
@@ -2144,7 +2143,7 @@ static void cfq_update_hw_tag(struct cfq_data *cfqd)
 	cfqd->rq_in_driver_peak = 0;
 }
 
-static void cfq_completed_request(struct request_queue *q, struct request *rq)
+void cfq_completed_request(struct request_queue *q, struct request *rq)
 {
 	struct cfq_queue *cfqq = RQ_CFQQ(rq);
 	struct cfq_data *cfqd = cfqq->cfqd;
@@ -2236,7 +2235,7 @@ static inline int __cfq_may_queue(struct cfq_queue *cfqq)
 	return ELV_MQUEUE_MAY;
 }
 
-static int cfq_may_queue(struct request_queue *q, int rw)
+int cfq_may_queue(struct request_queue *q, int rw)
 {
 	struct cfq_data *cfqd = q->elevator->elevator_data;
 	struct task_struct *tsk = current;
@@ -2267,7 +2266,7 @@ static int cfq_may_queue(struct request_queue *q, int rw)
 /*
  * queue lock held here
  */
-static void cfq_put_request(struct request *rq)
+void cfq_put_request(struct request *rq)
 {
 	struct cfq_queue *cfqq = RQ_CFQQ(rq);
 
@@ -2289,8 +2288,7 @@ static void cfq_put_request(struct request *rq)
 /*
  * Allocate cfq data structures associated with this request.
  */
-static int
-cfq_set_request(struct request_queue *q, struct request *rq, gfp_t gfp_mask)
+int cfq_set_request(struct request_queue *q, struct request *rq, gfp_t gfp_mask)
 {
 	struct cfq_data *cfqd = q->elevator->elevator_data;
 	struct cfq_io_context *cic;
diff --git a/block/cfq-iosched.h b/block/cfq-iosched.h
new file mode 100644
index 0000000..71fcd21
--- /dev/null
+++ b/block/cfq-iosched.h
@@ -0,0 +1,23 @@
+#ifndef CFQ_IOSCHED_H
+#define CFQ_IOSCHED_H
+
+struct request_queue;
+struct bio;
+struct request;
+
+int cfq_merge(struct request_queue *, struct request **, struct bio *);
+void cfq_merged_request(struct request_queue *, struct request *, int);
+void cfq_merged_requests(struct request_queue *, struct request *,
+			 struct request *);
+int cfq_allow_merge(struct request_queue *, struct request *, struct bio *);
+int cfq_dispatch_requests(struct request_queue *, int);
+void cfq_insert_request(struct request_queue *, struct request *);
+void cfq_activate_request(struct request_queue *, struct request *);
+void cfq_deactivate_request(struct request_queue *, struct request *);
+int cfq_queue_empty(struct request_queue *);
+void cfq_completed_request(struct request_queue *, struct request *);
+int cfq_set_request(struct request_queue *, struct request *, gfp_t);
+void cfq_put_request(struct request *);
+int cfq_may_queue(struct request_queue *, int);
+
+#endif
diff --git a/block/elevator.c b/block/elevator.c
index fdb0675..c7143fb 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -38,6 +38,7 @@
 #include <linux/uaccess.h>
 
 #include "blk.h"
+#include "elevator.h"
 
 static DEFINE_SPINLOCK(elv_list_lock);
 static LIST_HEAD(elv_list);
@@ -67,7 +68,7 @@ static int elv_iosched_allow_merge(struct request *rq, struct bio *bio)
 	struct request_queue *q = rq->q;
 
 	if (q->elv_ops.elevator_allow_merge_fn)
-		return q->elv_ops.elevator_allow_merge_fn(q, rq, bio);
+		return elv_call_allow_merge_fn(q, rq, bio);
 
 	return 1;
 }
@@ -313,13 +314,13 @@ EXPORT_SYMBOL(elevator_exit);
 static void elv_activate_rq(struct request_queue *q, struct request *rq)
 {
 	if (q->elv_ops.elevator_activate_req_fn)
-		q->elv_ops.elevator_activate_req_fn(q, rq);
+		elv_call_activate_req_fn(q, rq);
 }
 
 static void elv_deactivate_rq(struct request_queue *q, struct request *rq)
 {
 	if (q->elv_ops.elevator_deactivate_req_fn)
-		q->elv_ops.elevator_deactivate_req_fn(q, rq);
+		elv_call_deactivate_req_fn(q, rq);
 }
 
 static inline void __elv_rqhash_del(struct request *rq)
@@ -518,7 +519,7 @@ int elv_merge(struct request_queue *q, struct request **req, struct bio *bio)
 	}
 
 	if (q->elv_ops.elevator_merge_fn)
-		return q->elv_ops.elevator_merge_fn(q, req, bio);
+		return elv_call_merge_fn(q, req, bio);
 
 	return ELEVATOR_NO_MERGE;
 }
@@ -526,7 +527,7 @@ int elv_merge(struct request_queue *q, struct request **req, struct bio *bio)
 void elv_merged_request(struct request_queue *q, struct request *rq, int type)
 {
 	if (q->elv_ops.elevator_merged_fn)
-		q->elv_ops.elevator_merged_fn(q, rq, type);
+		elv_call_merged_fn(q, rq, type);
 
 	if (type == ELEVATOR_BACK_MERGE)
 		elv_rqhash_reposition(q, rq);
@@ -538,7 +539,7 @@ void elv_merge_requests(struct request_queue *q, struct request *rq,
 			     struct request *next)
 {
 	if (q->elv_ops.elevator_merge_req_fn)
-		q->elv_ops.elevator_merge_req_fn(q, rq, next);
+		elv_call_merge_req_fn(q, rq, next);
 
 	elv_rqhash_reposition(q, rq);
 	elv_rqhash_del(q, next);
@@ -568,7 +569,7 @@ void elv_drain_elevator(struct request_queue *q)
 {
 	static int printed;
 
-	while (q->elv_ops.elevator_dispatch_fn(q, 1))
+	while (elv_call_dispatch_fn(q, 1))
 		;
 
 	if (q->nr_sorted == 0)
@@ -655,7 +656,7 @@ void elv_insert(struct request_queue *q, struct request *rq, int where)
 		 * rq cannot be accessed after calling
 		 * elevator_add_req_fn.
 		 */
-		q->elv_ops.elevator_add_req_fn(q, rq);
+		elv_call_add_req_fn(q, rq);
 		break;
 
 	case ELEVATOR_INSERT_REQUEUE:
@@ -763,7 +764,7 @@ static inline struct request *__elv_next_request(struct request_queue *q)
 				return rq;
 		}
 
-		if (!q->elv_ops.elevator_dispatch_fn(q, 0))
+		if (!elv_call_dispatch_fn(q, 0))
 			return NULL;
 	}
 }
@@ -869,7 +870,7 @@ int elv_queue_empty(struct request_queue *q)
 		return 0;
 
 	if (q->elv_ops.elevator_queue_empty_fn)
-		return q->elv_ops.elevator_queue_empty_fn(q);
+		return elv_call_queue_empty_fn(q);
 
 	return 1;
 }
@@ -878,7 +879,7 @@ EXPORT_SYMBOL(elv_queue_empty);
 struct request *elv_latter_request(struct request_queue *q, struct request *rq)
 {
 	if (q->elv_ops.elevator_latter_req_fn)
-		return q->elv_ops.elevator_latter_req_fn(q, rq);
+		return elv_call_latter_req_fn(q, rq);
 
 	return NULL;
 }
@@ -886,7 +887,7 @@ struct request *elv_latter_request(struct request_queue *q, struct request *rq)
 struct request *elv_former_request(struct request_queue *q, struct request *rq)
 {
 	if (q->elv_ops.elevator_former_req_fn)
-		return q->elv_ops.elevator_former_req_fn(q, rq);
+		return elv_call_former_req_fn(q, rq);
 
 	return NULL;
 }
@@ -894,7 +895,7 @@ struct request *elv_former_request(struct request_queue *q, struct request *rq)
 int elv_set_request(struct request_queue *q, struct request *rq, gfp_t gfp_mask)
 {
 	if (q->elv_ops.elevator_set_req_fn)
-		return q->elv_ops.elevator_set_req_fn(q, rq, gfp_mask);
+		return elv_call_set_req_fn(q, rq, gfp_mask);
 
 	rq->elevator_private = NULL;
 	return 0;
@@ -903,13 +904,13 @@ int elv_set_request(struct request_queue *q, struct request *rq, gfp_t gfp_mask)
 void elv_put_request(struct request_queue *q, struct request *rq)
 {
 	if (q->elv_ops.elevator_put_req_fn)
-		q->elv_ops.elevator_put_req_fn(rq);
+		elv_call_put_req_fn(q, rq);
 }
 
 int elv_may_queue(struct request_queue *q, int rw)
 {
 	if (q->elv_ops.elevator_may_queue_fn)
-		return q->elv_ops.elevator_may_queue_fn(q, rw);
+		return elv_call_may_queue_fn(q, rw);
 
 	return ELV_MQUEUE_MAY;
 }
@@ -935,7 +936,7 @@ void elv_completed_request(struct request_queue *q, struct request *rq)
 	if (blk_account_rq(rq)) {
 		q->in_flight--;
 		if (blk_sorted_rq(rq) && q->elv_ops.elevator_completed_req_fn)
-			q->elv_ops.elevator_completed_req_fn(q, rq);
+			elv_call_completed_req_fn(q, rq);
 	}
 
 	/*
diff --git a/block/elevator.h b/block/elevator.h
new file mode 100644
index 0000000..d8b5f0c
--- /dev/null
+++ b/block/elevator.h
@@ -0,0 +1,162 @@
+#ifndef ELV_INTERN_H
+#define ELV_INTERN_H
+
+#include <linux/blkdev.h>
+#include <linux/elevator.h>
+
+#include "cfq-iosched.h"
+
+static inline int elv_call_allow_merge_fn(struct request_queue *q,
+					  struct request *rq, struct bio *bio)
+{
+#if defined(CONFIG_IOSCHED_CFQ_BUILTIN)
+	if (q->elv_ops.elevator_allow_merge_fn == cfq_allow_merge)
+		return cfq_allow_merge(q, rq, bio);
+#endif
+	return q->elv_ops.elevator_allow_merge_fn(q, rq, bio);
+}
+
+static inline void elv_call_activate_req_fn(struct request_queue *q,
+					    struct request *rq)
+{
+#if defined(CONFIG_IOSCHED_CFQ_BUILTIN)
+	if (q->elv_ops.elevator_activate_req_fn == cfq_activate_request)
+		cfq_activate_request(q, rq);
+	else
+#endif
+		q->elv_ops.elevator_activate_req_fn(q, rq);
+}
+
+static inline void elv_call_deactivate_req_fn(struct request_queue *q,
+					      struct request *rq)
+{
+#if defined(CONFIG_IOSCHED_CFQ_BUILTIN)
+	if (q->elv_ops.elevator_deactivate_req_fn == cfq_deactivate_request)
+		cfq_deactivate_request(q, rq);
+	else
+#endif
+	q->elv_ops.elevator_deactivate_req_fn(q, rq);
+}
+
+static inline int elv_call_merge_fn(struct request_queue *q,
+				    struct request **rq, struct bio *bio)
+{
+#if defined(CONFIG_IOSCHED_CFQ_BUILTIN)
+	if (q->elv_ops.elevator_merge_fn == cfq_merge)
+		return cfq_merge(q, rq, bio);
+#endif
+	return q->elv_ops.elevator_merge_fn(q, rq, bio);
+}
+
+static inline void elv_call_merged_fn(struct request_queue *q,
+				      struct request *rq, int type)
+{
+#if defined(CONFIG_IOSCHED_CFQ_BUILTIN)
+	if (q->elv_ops.elevator_merged_fn == cfq_merged_request)
+		cfq_merged_request(q, rq, type);
+	else
+#endif
+		q->elv_ops.elevator_merged_fn(q, rq, type);
+}
+
+static inline void elv_call_merge_req_fn(struct request_queue *q,
+					 struct request *rq,
+					 struct request *next)
+{
+#if defined(CONFIG_IOSCHED_CFQ_BUILTIN)
+	if (q->elv_ops.elevator_merge_req_fn == cfq_merged_requests)
+		cfq_merged_requests(q, rq, next);
+	else
+#endif
+		q->elv_ops.elevator_merge_req_fn(q, rq, next);
+}
+
+static inline int elv_call_dispatch_fn(struct request_queue *q, int force)
+{
+#if defined(CONFIG_IOSCHED_CFQ_BUILTIN)
+	if (q->elv_ops.elevator_dispatch_fn == cfq_dispatch_requests)
+		return cfq_dispatch_requests(q, force);
+#endif
+	return q->elv_ops.elevator_dispatch_fn(q, force);
+
+}
+
+static inline void elv_call_add_req_fn(struct request_queue *q,
+				       struct request *rq)
+{
+#if defined(CONFIG_IOSCHED_CFQ_BUILTIN)
+	if (q->elv_ops.elevator_add_req_fn == cfq_insert_request)
+		cfq_insert_request(q, rq);
+	else
+#endif
+		q->elv_ops.elevator_add_req_fn(q, rq);
+}
+
+static inline int elv_call_queue_empty_fn(struct request_queue *q)
+{
+#if defined(CONFIG_IOSCHED_CFQ_BUILTIN)
+	if (q->elv_ops.elevator_queue_empty_fn == cfq_queue_empty)
+		return cfq_queue_empty(q);
+#endif
+	return q->elv_ops.elevator_queue_empty_fn(q);
+}
+
+static inline struct request *
+elv_call_former_req_fn(struct request_queue *q, struct request *rq)
+{
+	if (q->elv_ops.elevator_former_req_fn == elv_rb_former_request)
+		return elv_rb_former_request(q, rq);
+
+	return q->elv_ops.elevator_former_req_fn(q, rq);
+}
+
+static inline struct request *
+elv_call_latter_req_fn(struct request_queue *q, struct request *rq)
+{
+	if (q->elv_ops.elevator_latter_req_fn == elv_rb_latter_request)
+		return elv_rb_latter_request(q, rq);
+
+	return q->elv_ops.elevator_latter_req_fn(q, rq);
+}
+
+static int
+elv_call_set_req_fn(struct request_queue *q, struct request *rq, gfp_t gfp_mask)
+{
+#if defined(CONFIG_IOSCHED_CFQ_BUILTIN)
+	if (q->elv_ops.elevator_set_req_fn == cfq_set_request)
+		return cfq_set_request(q, rq, gfp_mask);
+#endif
+	return q->elv_ops.elevator_set_req_fn(q, rq, gfp_mask);
+}
+
+static void elv_call_put_req_fn(struct request_queue *q, struct request *rq)
+{
+#if defined(CONFIG_IOSCHED_CFQ_BUILTIN)
+	if (q->elv_ops.elevator_put_req_fn == cfq_put_request)
+		cfq_put_request(rq);
+	else
+#endif
+		q->elv_ops.elevator_put_req_fn(rq);
+}
+
+static int elv_call_may_queue_fn(struct request_queue *q, int rw)
+{
+#if defined(CONFIG_IOSCHED_CFQ_BUILTIN)
+	if (q->elv_ops.elevator_may_queue_fn == cfq_may_queue)
+		return cfq_may_queue(q, rw);
+#endif
+	return q->elv_ops.elevator_may_queue_fn(q, rw);
+}
+
+static void
+elv_call_completed_req_fn(struct request_queue *q, struct request *rq)
+{
+#if defined(CONFIG_IOSCHED_CFQ_BUILTIN)
+	if (q->elv_ops.elevator_completed_req_fn == cfq_completed_request)
+		cfq_completed_request(q, rq);
+	else
+#endif
+		q->elv_ops.elevator_completed_req_fn(q, rq);
+}
+
+#endif
-- 
1.6.3.rc0.1.gf800

