Return-Path: <linux-kernel-owner+w=401wt.eu-S1754541AbZEIPfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541AbZEIPfd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 11:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751736AbZEIPfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 11:35:24 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:36283 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbZEIPfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 11:35:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:content-disposition:from:cc:date:mime-version
         :content-type:content-transfer-encoding:message-id;
        b=TeAC9S0BAHqBn2cJz9u3RYbWxtGNS7m0BJjg5FV9Sdr+1mhCC8nB2w00NVeIDbsaEA
         KORtjDF3s0ssNXJkZvtN7dUZlHCM4HATrYhRQ+c+/PUgVvL9az7KqJHgxo49IBwe8PFn
         wKmYnnsuH71mgJESLbeOPpzp//c2X37sfGJZk=
To: "Jens Axboe" <jens.axboe@oracle.com>
Subject: [PATCH 1/2] deadline-iosched: code cleanup, preparation for sync/async patch
Content-Disposition: inline
From: Corrado Zoccolo <czoccolo@gmail.com>
Cc: "Linux-Kernel" <linux-kernel@vger.kernel.org>
Date: Sat, 9 May 2009 17:35:14 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200905091735.15235.czoccolo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is the first patch of the series, and contains code cleanup
needed before changing read/write to sync/async.
No behavioral change is introduced by this patch.

Code cleanups:
* A single next_rq is sufficient.
* we store fifo insertion time on request, and compute deadline on the
  fly, to handle fifo_expire changes better (fifos remain sorted)
* remove unused field
* deadline_latter_request becomes deadline_next_request.

Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>

---
diff --git a/block/deadline-iosched.c b/block/deadline-iosched.c
index c4d991d..5713595 100644
--- a/block/deadline-iosched.c
+++ b/block/deadline-iosched.c
@@ -35,11 +35,10 @@ struct deadline_data {
 	struct list_head fifo_list[2];
 
 	/*
-	 * next in sort order. read, write or both are NULL
+	 * next in sort order.
 	 */
-	struct request *next_rq[2];
+	struct request *next_rq;
 	unsigned int batching;		/* number of sequential requests made */
-	sector_t last_sector;		/* head position */
 	unsigned int starved;		/* times reads have starved writes */
 
 	/*
@@ -63,7 +62,7 @@ deadline_rb_root(struct deadline_data *dd, struct request *rq)
  * get the request after `rq' in sector-sorted order
  */
 static inline struct request *
-deadline_latter_request(struct request *rq)
+deadline_next_request(struct request *rq)
 {
 	struct rb_node *node = rb_next(&rq->rb_node);
 
@@ -86,10 +85,8 @@ deadline_add_rq_rb(struct deadline_data *dd, struct request *rq)
 static inline void
 deadline_del_rq_rb(struct deadline_data *dd, struct request *rq)
 {
-	const int data_dir = rq_data_dir(rq);
-
-	if (dd->next_rq[data_dir] == rq)
-		dd->next_rq[data_dir] = deadline_latter_request(rq);
+	if (dd->next_rq == rq)
+		dd->next_rq = deadline_next_request(rq);
 
 	elv_rb_del(deadline_rb_root(dd, rq), rq);
 }
@@ -101,15 +98,14 @@ static void
 deadline_add_request(struct request_queue *q, struct request *rq)
 {
 	struct deadline_data *dd = q->elevator->elevator_data;
-	const int data_dir = rq_data_dir(rq);
 
 	deadline_add_rq_rb(dd, rq);
 
 	/*
-	 * set expire time and add to fifo list
+	 * set request creation time and add to fifo list
 	 */
-	rq_set_fifo_time(rq, jiffies + dd->fifo_expire[data_dir]);
-	list_add_tail(&rq->queuelist, &dd->fifo_list[data_dir]);
+	rq_set_fifo_time(rq, jiffies);
+	list_add_tail(&rq->queuelist, &dd->fifo_list[rq_data_dir(rq)]);
 }
 
 /*
@@ -206,13 +202,7 @@ deadline_move_to_dispatch(struct deadline_data *dd, struct request *rq)
 static void
 deadline_move_request(struct deadline_data *dd, struct request *rq)
 {
-	const int data_dir = rq_data_dir(rq);
-
-	dd->next_rq[READ] = NULL;
-	dd->next_rq[WRITE] = NULL;
-	dd->next_rq[data_dir] = deadline_latter_request(rq);
-
-	dd->last_sector = rq_end_sector(rq);
+	dd->next_rq = deadline_next_request(rq);
 
 	/*
 	 * take it off the sort and fifo list, move
@@ -227,15 +217,13 @@ deadline_move_request(struct deadline_data *dd, struct request *rq)
  */
 static inline int deadline_check_fifo(struct deadline_data *dd, int ddir)
 {
-	struct request *rq = rq_entry_fifo(dd->fifo_list[ddir].next);
-
+	BUG_ON(list_empty(&dd->fifo_list[ddir]));
 	/*
-	 * rq is expired!
+	 * deadline is expired!
 	 */
-	if (time_after(jiffies, rq_fifo_time(rq)))
-		return 1;
-
-	return 0;
+	return time_after(jiffies, dd->fifo_expire[ddir] +
+			  rq_fifo_time(rq_entry_fifo(dd->fifo_list[ddir].next))
+			  );
 }
 
 /*
@@ -247,20 +235,13 @@ static int deadline_dispatch_requests(struct request_queue *q, int force)
 	struct deadline_data *dd = q->elevator->elevator_data;
 	const int reads = !list_empty(&dd->fifo_list[READ]);
 	const int writes = !list_empty(&dd->fifo_list[WRITE]);
-	struct request *rq;
+	struct request *rq = dd->next_rq;
 	int data_dir;
 
-	/*
-	 * batches are currently reads XOR writes
-	 */
-	if (dd->next_rq[WRITE])
-		rq = dd->next_rq[WRITE];
-	else
-		rq = dd->next_rq[READ];
-
-	if (rq && dd->batching < dd->fifo_batch)
+	if (rq && dd->batching < dd->fifo_batch) {
 		/* we have a next request are still entitled to batch */
 		goto dispatch_request;
+	}
 
 	/*
 	 * at this point we are not running a batch. select the appropriate
@@ -299,7 +280,9 @@ dispatch_find_request:
 	/*
 	 * we are not running a batch, find best request for selected data_dir
 	 */
-	if (deadline_check_fifo(dd, data_dir) || !dd->next_rq[data_dir]) {
+	if (!dd->next_rq
+	    || rq_data_dir(dd->next_rq) != data_dir
+	    || deadline_check_fifo(dd, data_dir)) {
 		/*
 		 * A deadline has expired, the last request was in the other
 		 * direction, or we have run out of higher-sectored requests.
@@ -311,7 +294,7 @@ dispatch_find_request:
 		 * The last req was the same dir and we have a next request in
 		 * sort order. No expired requests so continue on from here.
 		 */
-		rq = dd->next_rq[data_dir];
+		rq = dd->next_rq;
 	}
 
 	dd->batching = 0;
