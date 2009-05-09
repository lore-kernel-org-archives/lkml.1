Return-Path: <linux-kernel-owner+w=401wt.eu-S1753244AbZEIPgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244AbZEIPgZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 11:36:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184AbZEIPgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 11:36:15 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:41792 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbZEIPgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 11:36:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:content-disposition:from:date:cc:mime-version
         :content-type:content-transfer-encoding:message-id;
        b=Fo6xEx2tBDpTu4nATBSIz6QHW/ZvngcWUYi5cO7pRMy+bps4yuTsjXCvUArsIGQAN3
         Ays2fyqsDM3peYS076wIdQScA0lxfN4XFdmqSKJMO4xZaF7Lv5qBjxYQADsFgbPlhhUw
         Ud6/n1m4+vNr5yGNJXIyu2eAO2VRdW+9jVU/4=
To: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 2/2] deadline-iosched: classify requets as sync/async
Content-Disposition: inline
From: Corrado Zoccolo <czoccolo@gmail.com>
Date: Sat, 9 May 2009 17:36:01 +0200
Cc: "Linux-Kernel" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200905091736.01451.czoccolo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the last patch of the series, and contains the changes
to classify requests in sync/async instead of read/write for deadline
assignment. 
Most changes are straightforward.
Few things to note:
* user space tunables change their name accordingly.
* deadline_dispatch_requests now selects requests to dispatch based
  on their belonging to sync vs async class. Batch extension rules
  are changed to allow a sync batch to be extended, even if async
  was selected due to async_starved (unless the deadline is expired).
* deadline_move_request becomes more complex, since now the next 
  request in disk order may not be suitable if of lower priority
  than the current batch. In order to keep it constant time
  complexity, we put a limit in the number of requests that can be
  skipped looking for one with the correct priority, and we allow for
  batch priority demotion in case the suitable request is not found.


Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>

---
diff --git a/block/deadline-iosched.c b/block/deadline-iosched.c
index 5713595..f8ca1a3 100644
--- a/block/deadline-iosched.c
+++ b/block/deadline-iosched.c
@@ -17,9 +17,9 @@
 /*
  * See Documentation/block/deadline-iosched.txt
  */
-static const int read_expire = HZ / 2;  /* max time before a read is submitted. */
-static const int write_expire = 5 * HZ; /* ditto for writes, these limits are SOFT! */
-static const int writes_starved = 2;    /* max times reads can starve a write */
+static const int sync_expire = HZ / 2;     /* max time before a sync operation is submitted. */
+static const int async_expire = 5 * HZ;    /* ditto for async operations, these limits are SOFT! */
+static const int async_starved = 2;        /* max times SYNC can starve ASYNC requests */
 static const int fifo_batch = 16;       /* # of sequential requests treated as one
 				     by the above parameters. For throughput. */
 
@@ -31,8 +31,8 @@ struct deadline_data {
 	/*
 	 * requests (deadline_rq s) are present on both sort_list and fifo_list
 	 */
-	struct rb_root sort_list[2];	
-	struct list_head fifo_list[2];
+	struct rb_root sort_list[2]; /* READ, WRITE */
+	struct list_head fifo_list[2]; /* 0=ASYNC, 1=SYNC */
 
 	/*
 	 * next in sort order.
@@ -46,8 +46,13 @@ struct deadline_data {
 	 */
 	int fifo_expire[2];
 	int fifo_batch;
-	int writes_starved;
+	int async_starved;
 	int front_merges;
+
+	/*
+	  current batch data & stats
+	 */
+	int cur_batch_prio;
 };
 
 static void deadline_move_request(struct deadline_data *, struct request *);
@@ -91,6 +96,12 @@ deadline_del_rq_rb(struct deadline_data *dd, struct request *rq)
 	elv_rb_del(deadline_rb_root(dd, rq), rq);
 }
 
+static int
+deadline_compute_req_priority(struct request *req)
+{
+	return !!rq_is_sync(req);
+}
+
 /*
  * add rq to rbtree and fifo
  */
@@ -105,7 +116,8 @@ deadline_add_request(struct request_queue *q, struct request *rq)
 	 * set request creation time and add to fifo list
 	 */
 	rq_set_fifo_time(rq, jiffies);
-	list_add_tail(&rq->queuelist, &dd->fifo_list[rq_data_dir(rq)]);
+	list_add_tail(&rq->queuelist,
+		      &dd->fifo_list[deadline_compute_req_priority(rq)]);
 }
 
 /*
@@ -202,7 +214,24 @@ deadline_move_to_dispatch(struct deadline_data *dd, struct request *rq)
 static void
 deadline_move_request(struct deadline_data *dd, struct request *rq)
 {
-	dd->next_rq = deadline_next_request(rq);
+	int max_search = dd->fifo_batch;
+
+	dd->next_rq = rq;
+	/* try to get requests of at least the same priority (or above)
+	   and same direction as current one */
+	while (max_search-- &&
+	       (dd->next_rq = deadline_next_request(dd->next_rq)) &&
+	       dd->cur_batch_prio > deadline_compute_req_priority(dd->next_rq))
+		;
+
+	if (!max_search || !dd->next_rq) {
+		/* did not get a next of suitable priority, demote batch to
+		   lower, and continue in disk order */
+		dd->next_rq = deadline_next_request(rq);
+		if (dd->next_rq)
+			dd->cur_batch_prio =
+				deadline_compute_req_priority(dd->next_rq);
+	}
 
 	/*
 	 * take it off the sort and fifo list, move
@@ -212,17 +241,17 @@ deadline_move_request(struct deadline_data *dd, struct request *rq)
 }
 
 /*
- * deadline_check_fifo returns 0 if there are no expired requests on the fifo,
- * 1 otherwise. Requires !list_empty(&dd->fifo_list[data_dir])
+ * deadline_check_fifo returns 0 if there are no expired requests on the fifo
+ * for given priority, 1 otherwise. Requires !list_empty(&dd->fifo_list[prio])
  */
-static inline int deadline_check_fifo(struct deadline_data *dd, int ddir)
+static inline int deadline_check_fifo(struct deadline_data *dd, unsigned prio)
 {
-	BUG_ON(list_empty(&dd->fifo_list[ddir]));
+	BUG_ON(list_empty(&dd->fifo_list[prio]));
 	/*
 	 * deadline is expired!
 	 */
-	return time_after(jiffies, dd->fifo_expire[ddir] +
-			  rq_fifo_time(rq_entry_fifo(dd->fifo_list[ddir].next))
+	return time_after(jiffies, dd->fifo_expire[prio] +
+			  rq_fifo_time(rq_entry_fifo(dd->fifo_list[prio].next))
 			  );
 }
 
@@ -233,10 +262,10 @@ static inline int deadline_check_fifo(struct deadline_data *dd, int ddir)
 static int deadline_dispatch_requests(struct request_queue *q, int force)
 {
 	struct deadline_data *dd = q->elevator->elevator_data;
-	const int reads = !list_empty(&dd->fifo_list[READ]);
-	const int writes = !list_empty(&dd->fifo_list[WRITE]);
+	const int sync_reqs = !list_empty(&dd->fifo_list[1]);
+	const int async_reqs = !list_empty(&dd->fifo_list[0]);
 	struct request *rq = dd->next_rq;
-	int data_dir;
+	int request_prio = dd->cur_batch_prio;
 
 	if (rq && dd->batching < dd->fifo_batch) {
 		/* we have a next request are still entitled to batch */
@@ -248,14 +277,10 @@ static int deadline_dispatch_requests(struct request_queue *q, int force)
 	 * data direction (read / write)
 	 */
 
-	if (reads) {
-		BUG_ON(RB_EMPTY_ROOT(&dd->sort_list[READ]));
-
-		if (writes && (dd->starved++ >= dd->writes_starved))
-			goto dispatch_writes;
-
-		data_dir = READ;
-
+	if (sync_reqs) {
+		if (async_reqs && (dd->starved++ >= dd->async_starved))
+			goto dispatch_async;
+		request_prio = 1;
 		goto dispatch_find_request;
 	}
 
@@ -263,14 +288,10 @@ static int deadline_dispatch_requests(struct request_queue *q, int force)
 	 * there are either no reads or writes have been starved
 	 */
 
-	if (writes) {
-dispatch_writes:
-		BUG_ON(RB_EMPTY_ROOT(&dd->sort_list[WRITE]));
-
+	if (async_reqs) {
+dispatch_async:
 		dd->starved = 0;
-
-		data_dir = WRITE;
-
+		request_prio = 0;
 		goto dispatch_find_request;
 	}
 
@@ -278,25 +299,28 @@ dispatch_writes:
 
 dispatch_find_request:
 	/*
-	 * we are not running a batch, find best request for selected data_dir
+	 * we are not running a batch:
+	 * find best request for selected request_prio
 	 */
 	if (!dd->next_rq
-	    || rq_data_dir(dd->next_rq) != data_dir
-	    || deadline_check_fifo(dd, data_dir)) {
+	    || dd->cur_batch_prio < request_prio
+	    || deadline_check_fifo(dd, request_prio)) {
 		/*
-		 * A deadline has expired, the last request was in the other
-		 * direction, or we have run out of higher-sectored requests.
+		 * A deadline expired, the previous batch had a lower priority,
+		 * or we have run out of higher-sectored requests.
 		 * Start again from the request with the earliest expiry time.
 		 */
-		rq = rq_entry_fifo(dd->fifo_list[data_dir].next);
+		rq = rq_entry_fifo(dd->fifo_list[request_prio].next);
 	} else {
 		/*
-		 * The last req was the same dir and we have a next request in
-		 * sort order. No expired requests so continue on from here.
+		 * The last batch was same or higher priority and we have a
+		 * next request in sort order. No expired requests so continue
+		 * on from here.
 		 */
 		rq = dd->next_rq;
 	}
 
+	dd->cur_batch_prio = request_prio;
 	dd->batching = 0;
 
 dispatch_request:
@@ -313,16 +337,16 @@ static int deadline_queue_empty(struct request_queue *q)
 {
 	struct deadline_data *dd = q->elevator->elevator_data;
 
-	return list_empty(&dd->fifo_list[WRITE])
-		&& list_empty(&dd->fifo_list[READ]);
+	return list_empty(&dd->fifo_list[0])
+		&& list_empty(&dd->fifo_list[1]);
 }
 
 static void deadline_exit_queue(struct elevator_queue *e)
 {
 	struct deadline_data *dd = e->elevator_data;
 
-	BUG_ON(!list_empty(&dd->fifo_list[READ]));
-	BUG_ON(!list_empty(&dd->fifo_list[WRITE]));
+	BUG_ON(!list_empty(&dd->fifo_list[0]));
+	BUG_ON(!list_empty(&dd->fifo_list[1]));
 
 	kfree(dd);
 }
@@ -338,13 +362,13 @@ static void *deadline_init_queue(struct request_queue *q)
 	if (!dd)
 		return NULL;
 
-	INIT_LIST_HEAD(&dd->fifo_list[READ]);
-	INIT_LIST_HEAD(&dd->fifo_list[WRITE]);
+	INIT_LIST_HEAD(&dd->fifo_list[0]);
+	INIT_LIST_HEAD(&dd->fifo_list[1]);
 	dd->sort_list[READ] = RB_ROOT;
 	dd->sort_list[WRITE] = RB_ROOT;
-	dd->fifo_expire[READ] = read_expire;
-	dd->fifo_expire[WRITE] = write_expire;
-	dd->writes_starved = writes_starved;
+	dd->fifo_expire[0] = async_expire;
+	dd->fifo_expire[1] = sync_expire;
+	dd->async_starved = async_starved;
 	dd->front_merges = 1;
 	dd->fifo_batch = fifo_batch;
 	return dd;
@@ -378,9 +402,9 @@ static ssize_t __FUNC(struct elevator_queue *e, char *page)		\
 		__data = jiffies_to_msecs(__data);			\
 	return deadline_var_show(__data, (page));			\
 }
-SHOW_FUNCTION(deadline_read_expire_show, dd->fifo_expire[READ], 1);
-SHOW_FUNCTION(deadline_write_expire_show, dd->fifo_expire[WRITE], 1);
-SHOW_FUNCTION(deadline_writes_starved_show, dd->writes_starved, 0);
+SHOW_FUNCTION(deadline_async_expire_show, dd->fifo_expire[0], 1);
+SHOW_FUNCTION(deadline_sync_expire_show, dd->fifo_expire[1], 1);
+SHOW_FUNCTION(deadline_async_starved_show, dd->async_starved, 0);
 SHOW_FUNCTION(deadline_front_merges_show, dd->front_merges, 0);
 SHOW_FUNCTION(deadline_fifo_batch_show, dd->fifo_batch, 0);
 #undef SHOW_FUNCTION
@@ -401,9 +425,9 @@ static ssize_t __FUNC(struct elevator_queue *e, const char *page, size_t count)
 		*(__PTR) = __data;					\
 	return ret;							\
 }
-STORE_FUNCTION(deadline_read_expire_store, &dd->fifo_expire[READ], 0, INT_MAX, 1);
-STORE_FUNCTION(deadline_write_expire_store, &dd->fifo_expire[WRITE], 0, INT_MAX, 1);
-STORE_FUNCTION(deadline_writes_starved_store, &dd->writes_starved, INT_MIN, INT_MAX, 0);
+STORE_FUNCTION(deadline_async_expire_store, &dd->fifo_expire[0], 0, INT_MAX, 1);
+STORE_FUNCTION(deadline_sync_expire_store, &dd->fifo_expire[1], 0, INT_MAX, 1);
+STORE_FUNCTION(deadline_async_starved_store, &dd->async_starved, INT_MIN, INT_MAX, 0);
 STORE_FUNCTION(deadline_front_merges_store, &dd->front_merges, 0, 1, 0);
 STORE_FUNCTION(deadline_fifo_batch_store, &dd->fifo_batch, 0, INT_MAX, 0);
 #undef STORE_FUNCTION
@@ -413,9 +437,9 @@ STORE_FUNCTION(deadline_fifo_batch_store, &dd->fifo_batch, 0, INT_MAX, 0);
 				      deadline_##name##_store)
 
 static struct elv_fs_entry deadline_attrs[] = {
-	DD_ATTR(read_expire),
-	DD_ATTR(write_expire),
-	DD_ATTR(writes_starved),
+	DD_ATTR(async_expire),
+	DD_ATTR(sync_expire),
+	DD_ATTR(async_starved),
 	DD_ATTR(front_merges),
 	DD_ATTR(fifo_batch),
 	__ATTR_NULL
