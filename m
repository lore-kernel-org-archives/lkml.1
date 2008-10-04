Return-Path: <linux-kernel-owner+w=401wt.eu-S1752684AbYJDHqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684AbYJDHqh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 03:46:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbYJDHq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 03:46:27 -0400
Received: from note.orchestra.cse.unsw.EDU.AU ([129.94.242.24]:39413 "EHLO
	note.orchestra.cse.unsw.EDU.AU" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751836AbYJDHq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 03:46:26 -0400
From: Aaron Carroll <aaronc@gelato.unsw.edu.au>
To: david@fromorbit.com
Date: Sat, 04 Oct 2008 17:45:00 +1000
Message-ID: <48E71EFC.7040403@gelato.unsw.edu.au>
User-Agent: Thunderbird 2.0.0.14 (X11/20080618)
MIME-Version: 1.0
CC: Bodo Eggert <7eggert@gmx.de>, Jens Axboe <jens.axboe@oracle.com>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Give kjournald a IOPRIO_CLASS_RT io priority
References: <bimJN-4cO-5@gated-at.bofh.it> <biosl-6bq-9@gated-at.bofh.it> <biqkw-aK-3@gated-at.bofh.it> <birgx-1pQ-9@gated-at.bofh.it> <bisPe-3xx-9@gated-at.bofh.it> <bisYW-3HQ-13@gated-at.bofh.it> <E1KlQ9s-0003Oh-Cz@be1.7eggert.dyndns.org> <20081002233426.GG30001@disturbed>
In-Reply-To: <20081002233426.GG30001@disturbed>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner wrote:
> On Thu, Oct 02, 2008 at 05:32:04PM +0200, Bodo Eggert wrote:
>> Sounds like you need a priority class besides sync and async.
> 
> There's BIO_META now as well, which I was testing at the same time
> as RT priority. Marking all the metadata I/O as BIO_META did help,
> but once again I never got to determining if that was a result of
> the different tagging or the priority increase.

What exactly do you want META to mean?  Strict prioritisation over
all other non-META requests, or just more frequent and/or larger
dispatches?  Should META requests be sorted?

> However, given that only CFQ understand BIO_META, I suspect that
> changing the way XFS uses BIO_SYNC to be a combination of BIO_META
> and BIO_SYNC would cause significant regressions on other
> schedulers.....

That shouldn't be a problem.  noop doesn't care about any of that stuff,
and deadline doesn't care about BIO_SYNC (more on that below).  If the
bios that use META are a subset of those that currently use SYNC, then
we can temporarily change AS to treat META and SYNC equally.  Only CFQ
would change in behaviour.

So deadline should probably support BIO_SYNC... below is a patch to do
that.  It doesn't have much of an effect on postmark or compilebench on
a single spindle, but I'm guessing that's not the workload or hardware
that is expected to benefit.


---

Subject: [PATCH] deadline-iosched: support SYNC bio/request flag

Support sync/async requests in deadline rather than read/write, as is
done in AS and CFQ.

Signed-off-by: Aaron Carroll <aaronc@gelato.unsw.edu.au>
---
 block/deadline-iosched.c |   63 ++++++++++++++++++++++++---------------------
 1 files changed, 34 insertions(+), 29 deletions(-)

diff --git a/block/deadline-iosched.c b/block/deadline-iosched.c
index 342448c..b2cfd47 100644
--- a/block/deadline-iosched.c
+++ b/block/deadline-iosched.c
@@ -23,6 +23,11 @@ static const int writes_starved = 2;    /* max times reads can starve a write */
 static const int fifo_batch = 16;       /* # of sequential requests treated as one
 				     by the above parameters. For throughput. */
 
+enum {
+	REQ_ASYNC,
+	REQ_SYNC,
+};
+
 struct deadline_data {
 	/*
 	 * run time data
@@ -53,7 +58,7 @@ struct deadline_data {
 
 static void deadline_move_request(struct deadline_data *, struct request *);
 
-#define RQ_RB_ROOT(dd, rq)	(&(dd)->sort_list[rq_data_dir((rq))])
+#define RQ_RB_ROOT(dd, rq)	(&(dd)->sort_list[rq_is_sync((rq))])
 
 /*
  * get the request after `rq' in sector-sorted order
@@ -86,7 +91,7 @@ retry:
 static inline void
 deadline_del_rq_rb(struct deadline_data *dd, struct request *rq)
 {
-	const int data_dir = rq_data_dir(rq);
+	const int data_dir = rq_is_sync(rq);
 
 	if (dd->next_rq[data_dir] == rq)
 		dd->next_rq[data_dir] = deadline_latter_request(rq);
@@ -101,7 +106,7 @@ static void
 deadline_add_request(struct request_queue *q, struct request *rq)
 {
 	struct deadline_data *dd = q->elevator->elevator_data;
-	const int data_dir = rq_data_dir(rq);
+	const int data_dir = rq_is_sync(rq);
 
 	deadline_add_rq_rb(dd, rq);
 
@@ -206,10 +211,10 @@ deadline_move_to_dispatch(struct deadline_data *dd, struct request *rq)
 static void
 deadline_move_request(struct deadline_data *dd, struct request *rq)
 {
-	const int data_dir = rq_data_dir(rq);
+	const int data_dir = rq_is_sync(rq);
 
-	dd->next_rq[READ] = NULL;
-	dd->next_rq[WRITE] = NULL;
+	dd->next_rq[REQ_SYNC] = NULL;
+	dd->next_rq[REQ_ASYNC] = NULL;
 	dd->next_rq[data_dir] = deadline_latter_request(rq);
 
 	dd->last_sector = rq->sector + rq->nr_sectors;
@@ -245,18 +250,18 @@ static inline int deadline_check_fifo(struct deadline_data *dd, int ddir)
 static int deadline_dispatch_requests(struct request_queue *q, int force)
 {
 	struct deadline_data *dd = q->elevator->elevator_data;
-	const int reads = !list_empty(&dd->fifo_list[READ]);
-	const int writes = !list_empty(&dd->fifo_list[WRITE]);
+	const int reads = !list_empty(&dd->fifo_list[REQ_SYNC]);
+	const int writes = !list_empty(&dd->fifo_list[REQ_ASYNC]);
 	struct request *rq;
 	int data_dir;
 
 	/*
 	 * batches are currently reads XOR writes
 	 */
-	if (dd->next_rq[WRITE])
-		rq = dd->next_rq[WRITE];
+	if (dd->next_rq[REQ_ASYNC])
+		rq = dd->next_rq[REQ_ASYNC];
 	else
-		rq = dd->next_rq[READ];
+		rq = dd->next_rq[REQ_SYNC];
 
 	if (rq) {
 		/* we have a "next request" */
@@ -276,12 +281,12 @@ static int deadline_dispatch_requests(struct request_queue *q, int force)
 	 */
 
 	if (reads) {
-		BUG_ON(RB_EMPTY_ROOT(&dd->sort_list[READ]));
+		BUG_ON(RB_EMPTY_ROOT(&dd->sort_list[REQ_SYNC]));
 
 		if (writes && (dd->starved++ >= dd->writes_starved))
 			goto dispatch_writes;
 
-		data_dir = READ;
+		data_dir = REQ_SYNC;
 
 		goto dispatch_find_request;
 	}
@@ -292,11 +297,11 @@ static int deadline_dispatch_requests(struct request_queue *q, int force)
 
 	if (writes) {
 dispatch_writes:
-		BUG_ON(RB_EMPTY_ROOT(&dd->sort_list[WRITE]));
+		BUG_ON(RB_EMPTY_ROOT(&dd->sort_list[REQ_ASYNC]));
 
 		dd->starved = 0;
 
-		data_dir = WRITE;
+		data_dir = REQ_ASYNC;
 
 		goto dispatch_find_request;
 	}
@@ -338,16 +343,16 @@ static int deadline_queue_empty(struct request_queue *q)
 {
 	struct deadline_data *dd = q->elevator->elevator_data;
 
-	return list_empty(&dd->fifo_list[WRITE])
-		&& list_empty(&dd->fifo_list[READ]);
+	return list_empty(&dd->fifo_list[REQ_ASYNC])
+		&& list_empty(&dd->fifo_list[REQ_SYNC]);
 }
 
 static void deadline_exit_queue(elevator_t *e)
 {
 	struct deadline_data *dd = e->elevator_data;
 
-	BUG_ON(!list_empty(&dd->fifo_list[READ]));
-	BUG_ON(!list_empty(&dd->fifo_list[WRITE]));
+	BUG_ON(!list_empty(&dd->fifo_list[REQ_SYNC]));
+	BUG_ON(!list_empty(&dd->fifo_list[REQ_ASYNC]));
 
 	kfree(dd);
 }
@@ -363,12 +368,12 @@ static void *deadline_init_queue(struct request_queue *q)
 	if (!dd)
 		return NULL;
 
-	INIT_LIST_HEAD(&dd->fifo_list[READ]);
-	INIT_LIST_HEAD(&dd->fifo_list[WRITE]);
-	dd->sort_list[READ] = RB_ROOT;
-	dd->sort_list[WRITE] = RB_ROOT;
-	dd->fifo_expire[READ] = read_expire;
-	dd->fifo_expire[WRITE] = write_expire;
+	INIT_LIST_HEAD(&dd->fifo_list[REQ_SYNC]);
+	INIT_LIST_HEAD(&dd->fifo_list[REQ_ASYNC]);
+	dd->sort_list[REQ_SYNC] = RB_ROOT;
+	dd->sort_list[REQ_ASYNC] = RB_ROOT;
+	dd->fifo_expire[REQ_SYNC] = read_expire;
+	dd->fifo_expire[REQ_ASYNC] = write_expire;
 	dd->writes_starved = writes_starved;
 	dd->front_merges = 1;
 	dd->fifo_batch = fifo_batch;
@@ -403,8 +408,8 @@ static ssize_t __FUNC(elevator_t *e, char *page)			\
 		__data = jiffies_to_msecs(__data);			\
 	return deadline_var_show(__data, (page));			\
 }
-SHOW_FUNCTION(deadline_read_expire_show, dd->fifo_expire[READ], 1);
-SHOW_FUNCTION(deadline_write_expire_show, dd->fifo_expire[WRITE], 1);
+SHOW_FUNCTION(deadline_read_expire_show, dd->fifo_expire[REQ_SYNC], 1);
+SHOW_FUNCTION(deadline_write_expire_show, dd->fifo_expire[REQ_ASYNC], 1);
 SHOW_FUNCTION(deadline_writes_starved_show, dd->writes_starved, 0);
 SHOW_FUNCTION(deadline_front_merges_show, dd->front_merges, 0);
 SHOW_FUNCTION(deadline_fifo_batch_show, dd->fifo_batch, 0);
@@ -426,8 +431,8 @@ static ssize_t __FUNC(elevator_t *e, const char *page, size_t count)	\
 		*(__PTR) = __data;					\
 	return ret;							\
 }
-STORE_FUNCTION(deadline_read_expire_store, &dd->fifo_expire[READ], 0, INT_MAX, 1);
-STORE_FUNCTION(deadline_write_expire_store, &dd->fifo_expire[WRITE], 0, INT_MAX, 1);
+STORE_FUNCTION(deadline_read_expire_store, &dd->fifo_expire[REQ_SYNC], 0, INT_MAX, 1);
+STORE_FUNCTION(deadline_write_expire_store, &dd->fifo_expire[REQ_ASYNC], 0, INT_MAX, 1);
 STORE_FUNCTION(deadline_writes_starved_store, &dd->writes_starved, INT_MIN, INT_MAX, 0);
 STORE_FUNCTION(deadline_front_merges_store, &dd->front_merges, 0, 1, 0);
 STORE_FUNCTION(deadline_fifo_batch_store, &dd->fifo_batch, 0, INT_MAX, 0);
-- 
1.6.0.2
