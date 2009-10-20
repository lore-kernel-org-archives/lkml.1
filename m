Return-Path: <linux-kernel-owner+w=401wt.eu-S1751609AbZJTSXJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609AbZJTSXJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 14:23:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751356AbZJTSXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 14:23:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42982 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072AbZJTSXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 14:23:07 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: jens.axboe@oracle.com
Cc: Linux Kernel Mailing <linux-kernel@vger.kernel.org>
Subject: [patch,rfc] cfq: merge cooperating cfq_queues
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 20 Oct 2009 14:23:05 -0400
Message-ID: <x49d44hx6uu.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a follow-up patch to the original close cooperator support for
CFQ.  The problem is that some programs (NFSd, dump(8), iscsi target
mode driver, qemu) interleave sequential I/Os between multiple threads
or processes.  The result is that there are large delays due to CFQs
idling logic that leads to very low throughput.  The original patch
addresses these problems by detecting close cooperators and allowing
them to jump ahead in the scheduling order.  This doesn't work 100% of
the time, unfortunately, and you can have some processes in the group
getting way ahead (LBA-wise) of the others, leading to a lot of seeks.

This patch addresses the problems in the current implementation by
merging cfq_queue's of close cooperators.  The results are encouraging:

read-test2 emulates the I/O patterns of dump(8).  The following results
are taken from 50 runs of patched, 16 runs of unpatched (I got impatient):

               Average   Std. Dev.
----------------------------------
Patched CFQ:   88.81773  0.9485
Vanilla CFQ:   12.62678  0.24535

Single streaming reader over NFS, results in MB/s are the average of 2
runs.

              |patched|
nfsd's|  cfq  |  cfq  | deadline
------+-------+-------+---------
  1   |  45   |  45   | 36
  2   |  57   |  60   | 60
  4   |  38   |  49   | 50
  8   |  34   |  40   | 49
  16  |  34   |  43   | 53

The next step will be to break apart the cfqq's when the I/O patterns
are no longer sequential.  This is not very important for dump(8), but
for NFSd, this could make a big difference.  The problem with sharing
the cfq_queue when the NFSd threads are no longer serving requests from
a single client is that instead of having 8 scheduling entities, NFSd
only gets one.  This could considerably hurt performance when serving
shares to multiple clients, though I don't have a test to show this yet.

So, please take this patch as an rfc, and any discussion on detecting
that I/O patterns are no longer sequential at the cfqq level (not the
cic, as multiple cic's now point to the same cfqq) would be helpful.

Cheers,
Jeff

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>


diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 069a610..dd28799 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -113,6 +113,8 @@ struct cfq_queue {
 	unsigned short ioprio_class, org_ioprio_class;
 
 	pid_t pid;
+
+	struct cfq_queue *new_cfqq;
 };
 
 /*
@@ -1049,6 +1051,12 @@ static struct cfq_queue *cfq_close_cooperator(struct cfq_data *cfqd,
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
 
@@ -1170,6 +1178,43 @@ cfq_prio_to_maxrq(struct cfq_data *cfqd, struct cfq_queue *cfqq)
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
+static void merge_cfqqs(struct cfq_queue *cfqq, struct cfq_queue *new_cfqq)
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
@@ -1198,11 +1243,14 @@ static struct cfq_queue *cfq_select_queue(struct cfq_data *cfqd)
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
+			merge_cfqqs(cfqq, new_cfqq);
 		goto expire;
+	}
 
 	/*
 	 * No requests pending. If the active queue still has requests in
@@ -1513,11 +1561,25 @@ static void cfq_free_io_context(struct io_context *ioc)
 
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
+	 * the merge chain).  See merge_cfqqs and cfq_set_request.
+	 */
+	__cfqq = cfqq->new_cfqq;
+	while (__cfqq) {
+		next = __cfqq->new_cfqq;
+		cfq_put_queue(__cfqq);
+		__cfqq = next;
+	}
+
 	cfq_put_queue(cfqq);
 }
 
@@ -2351,6 +2413,20 @@ cfq_set_request(struct request_queue *q, struct request *rq, gfp_t gfp_mask)
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
+		if (cfqq->new_cfqq) {
+			cfq_log_cfqq(cfqd, cfqq, "merging with queue %p",
+				     cfqq->new_cfqq);
+			cic_set_cfqq(cic, cfqq->new_cfqq, is_sync);
+			cfq_put_queue(cfqq);
+			cfqq = cic_to_cfqq(cic, is_sync);
+		}
 	}
 
 	cfqq->allocated[rw]++;
