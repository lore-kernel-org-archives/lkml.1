Return-Path: <linux-kernel-owner+w=401wt.eu-S1752987AbZJWVPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987AbZJWVPg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 17:15:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752224AbZJWVOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 17:14:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9622 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395AbZJWVOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 17:14:53 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: jens.axboe@oracle.com
Cc: czoccolo@gmail.com, linux-kernel@vger.kernel.org,
       Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH 2/4] cfq: merge cooperating cfq_queues
Date: Fri, 23 Oct 2009 17:14:50 -0400
Message-Id: <1256332492-24566-3-git-send-email-jmoyer@redhat.com>
In-Reply-To: <1256332492-24566-1-git-send-email-jmoyer@redhat.com>
References: <1256332492-24566-1-git-send-email-jmoyer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When cooperating cfq_queues are detected currently, they are allowed to
skip ahead in the scheduling order.  It is much more efficient to
automatically share the cfq_queue data structure between cooperating processes.
Performance of the read-test2 benchmark (which is written to emulate the
dump(8) utility) went from 12MB/s to 90MB/s on my SATA disk.  NFS servers
with multiple nfsd threads also saw performance increases.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
---
 block/cfq-iosched.c |   89 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 87 insertions(+), 2 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 78cc8ee..f0994ae 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -118,6 +118,8 @@ struct cfq_queue {
 	sector_t last_request_pos;
 
 	pid_t pid;
+
+	struct cfq_queue *new_cfqq;
 };
 
 /*
@@ -1047,6 +1049,12 @@ static struct cfq_queue *cfq_close_cooperator(struct cfq_data *cfqd,
 	if (!cfqq)
 		return NULL;
 
+	/*
+	 * It only makes sense to merge sync queues.
+	 */
+	if (!cfq_cfqq_sync(cfqq))
+		return NULL;
+
 	if (cfq_cfqq_coop(cfqq))
 		return NULL;
 
@@ -1168,6 +1176,43 @@ cfq_prio_to_maxrq(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 }
 
 /*
+ * Must be called with the queue_lock held.
+ */
+static int cfqq_process_refs(struct cfq_queue *cfqq)
+{
+	int process_refs, io_refs;
+
+	io_refs = cfqq->allocated[READ] + cfqq->allocated[WRITE];
+	process_refs = atomic_read(&cfqq->ref) - io_refs;
+	BUG_ON(process_refs < 0);
+	return process_refs;
+}
+
+static void cfq_setup_merge(struct cfq_queue *cfqq, struct cfq_queue *new_cfqq)
+{
+	int process_refs;
+	struct cfq_queue *__cfqq;
+
+	/* Avoid a circular list and skip interim queue merges */
+	while ((__cfqq = new_cfqq->new_cfqq)) {
+		if (__cfqq == cfqq)
+			return;
+		new_cfqq = __cfqq;
+	}
+
+	process_refs = cfqq_process_refs(cfqq);
+	/*
+	 * If the process for the cfqq has gone away, there is no
+	 * sense in merging the queues.
+	 */
+	if (process_refs == 0)
+		return;
+
+	cfqq->new_cfqq = new_cfqq;
+	atomic_add(process_refs, &new_cfqq->ref);
+}
+
+/*
  * Select a queue for service. If we have a current active queue,
  * check whether to continue servicing it, or retrieve and set a new one.
  */
@@ -1196,11 +1241,14 @@ static struct cfq_queue *cfq_select_queue(struct cfq_data *cfqd)
 	 * If another queue has a request waiting within our mean seek
 	 * distance, let it run.  The expire code will check for close
 	 * cooperators and put the close queue at the front of the service
-	 * tree.
+	 * tree.  If possible, merge the expiring queue with the new cfqq.
 	 */
 	new_cfqq = cfq_close_cooperator(cfqd, cfqq, 0);
-	if (new_cfqq)
+	if (new_cfqq) {
+		if (!cfqq->new_cfqq)
+			cfq_setup_merge(cfqq, new_cfqq);
 		goto expire;
+	}
 
 	/*
 	 * No requests pending. If the active queue still has requests in
@@ -1511,11 +1559,29 @@ static void cfq_free_io_context(struct io_context *ioc)
 
 static void cfq_exit_cfqq(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 {
+	struct cfq_queue *__cfqq, *next;
+
 	if (unlikely(cfqq == cfqd->active_queue)) {
 		__cfq_slice_expired(cfqd, cfqq, 0);
 		cfq_schedule_dispatch(cfqd);
 	}
 
+	/*
+	 * If this queue was scheduled to merge with another queue, be
+	 * sure to drop the reference taken on that queue (and others in
+	 * the merge chain).  See cfq_setup_merge and cfq_merge_cfqqs.
+	 */
+	__cfqq = cfqq->new_cfqq;
+	while (__cfqq) {
+		if (__cfqq == cfqq) {
+			WARN(1, "cfqq->new_cfqq loop detected\n");
+			break;
+		}
+		next = __cfqq->new_cfqq;
+		cfq_put_queue(__cfqq);
+		__cfqq = next;
+	}
+
 	cfq_put_queue(cfqq);
 }
 
@@ -2323,6 +2389,16 @@ static void cfq_put_request(struct request *rq)
 	}
 }
 
+static struct cfq_queue *
+cfq_merge_cfqqs(struct cfq_data *cfqd, struct cfq_io_context *cic,
+		struct cfq_queue *cfqq)
+{
+	cfq_log_cfqq(cfqd, cfqq, "merging with queue %p", cfqq->new_cfqq);
+	cic_set_cfqq(cic, cfqq->new_cfqq, 1);
+	cfq_put_queue(cfqq);
+	return cic_to_cfqq(cic, 1);
+}
+
 /*
  * Allocate cfq data structures associated with this request.
  */
@@ -2349,6 +2425,15 @@ cfq_set_request(struct request_queue *q, struct request *rq, gfp_t gfp_mask)
 	if (!cfqq || cfqq == &cfqd->oom_cfqq) {
 		cfqq = cfq_get_queue(cfqd, is_sync, cic->ioc, gfp_mask);
 		cic_set_cfqq(cic, cfqq, is_sync);
+	} else {
+		/*
+		 * Check to see if this queue is scheduled to merge with
+		 * another, closely cooperating queue.  The merging of
+		 * queues happens here as it must be done in process context.
+		 * The reference on new_cfqq was taken in merge_cfqqs.
+		 */
+		if (cfqq->new_cfqq)
+			cfqq = cfq_merge_cfqqs(cfqd, cic, cfqq);
 	}
 
 	cfqq->allocated[rw]++;
-- 
1.6.2.5

