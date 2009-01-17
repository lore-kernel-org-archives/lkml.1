Return-Path: <linux-kernel-owner+w=401wt.eu-S1764833AbZAQQ1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764833AbZAQQ1S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 11:27:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754272AbZAQQ1D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 11:27:03 -0500
Received: from tomts13.bellnexxia.net ([209.226.175.34]:50387 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754108AbZAQQ1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 11:27:00 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArcEAECQcUlMQWt2/2dsb2JhbACBbMpChXM
Date: Sat, 17 Jan 2009 11:26:57 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jens Axboe <axboe@kernel.dk>, Andrea Arcangeli <andrea@suse.de>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca
Subject: [RFC PATCH] block: Fix bio merge induced high I/O latency
Message-ID: <20090117162657.GA31965@Krystal>
References: <20090117004439.GA11492@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090117004439.GA11492@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:23:00 up 16 days, 16:21,  3 users,  load average: 0.07, 0.40,
	0.47
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A long standing I/O regression (since 2.6.18, still there today) has hit
Slashdot recently :
http://bugzilla.kernel.org/show_bug.cgi?id=12309
http://it.slashdot.org/article.pl?sid=09/01/15/049201

I've taken a trace reproducing the wrong behavior on my machine and I
think it's getting us somewhere.

LTTng 0.83, kernel 2.6.28
Machine : Intel Xeon E5405 dual quad-core, 16GB ram
(just created a new block-trace.c LTTng probe which is not released yet.
It basically replaces blktrace)


echo 3 > /proc/sys/vm/drop_caches

lttctl -C -w /tmp/trace -o channel.mm.bufnum=8 -o channel.block.bufnum=64 trace

dd if=/dev/zero of=/tmp/newfile bs=1M count=1M
cp -ax music /tmp   (copying 1.1GB of mp3)

ls  (takes 15 seconds to get the directory listing !)

lttctl -D trace

I looked at the trace (especially at the ls surroundings), and bash is
waiting for a few seconds for I/O in the exec system call (to exec ls).

While this happens, we have dd doing lots and lots of bio_queue. There
is a bio_backmerge after each bio_queue event. This is reasonable,
because dd is writing to a contiguous file.

However, I wonder if this is not the actual problem. We have dd which
has the head request in the elevator request queue. It is progressing
steadily by plugging/unplugging the device periodically and gets its
work done. However, because requests are being dequeued at the same
rate others are being merged, I suspect it stays at the top of the queue
and does not let the other unrelated requests run.

There is a test in the blk-merge.c which makes sure that merged requests
do not get bigger than a certain size. However, if the request is
steadily dequeued, I think this test is not doing anything.


This patch implements a basic test to make sure we never merge more than 128
requests into the same request if it is the "last_merge" request. I have not
been able to trigger the problem again with the fix applied. It might not be in
a perfect state : there may be better solutions to the problem, but I think it
helps pointing out where the culprit lays.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Jens Axboe <axboe@kernel.dk>
CC: Andrea Arcangeli <andrea@suse.de>
CC: akpm@linux-foundation.org
CC: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>
---
 block/blk-merge.c      |   12 +++++++++---
 block/elevator.c       |   31 ++++++++++++++++++++++++++++---
 include/linux/blkdev.h |    1 +
 3 files changed, 38 insertions(+), 6 deletions(-)

Index: linux-2.6-lttng/include/linux/blkdev.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/blkdev.h	2009-01-17 09:49:54.000000000 -0500
+++ linux-2.6-lttng/include/linux/blkdev.h	2009-01-17 09:50:29.000000000 -0500
@@ -313,6 +313,7 @@ struct request_queue
 	 */
 	struct list_head	queue_head;
 	struct request		*last_merge;
+	int			nr_cached_merge;
 	elevator_t		*elevator;
 
 	/*
Index: linux-2.6-lttng/block/elevator.c
===================================================================
--- linux-2.6-lttng.orig/block/elevator.c	2009-01-17 09:49:54.000000000 -0500
+++ linux-2.6-lttng/block/elevator.c	2009-01-17 11:07:12.000000000 -0500
@@ -255,6 +255,7 @@ int elevator_init(struct request_queue *
 
 	INIT_LIST_HEAD(&q->queue_head);
 	q->last_merge = NULL;
+	q->nr_cached_merge = 0;
 	q->end_sector = 0;
 	q->boundary_rq = NULL;
 
@@ -438,8 +439,10 @@ void elv_dispatch_sort(struct request_qu
 	struct list_head *entry;
 	int stop_flags;
 
-	if (q->last_merge == rq)
+	if (q->last_merge == rq) {
 		q->last_merge = NULL;
+		q->nr_cached_merge = 0;
+	}
 
 	elv_rqhash_del(q, rq);
 
@@ -478,8 +481,10 @@ EXPORT_SYMBOL(elv_dispatch_sort);
  */
 void elv_dispatch_add_tail(struct request_queue *q, struct request *rq)
 {
-	if (q->last_merge == rq)
+	if (q->last_merge == rq) {
 		q->last_merge = NULL;
+		q->nr_cached_merge = 0;
+	}
 
 	elv_rqhash_del(q, rq);
 
@@ -498,6 +503,16 @@ int elv_merge(struct request_queue *q, s
 	int ret;
 
 	/*
+	 * Make sure we don't starve other requests by merging too many cached
+	 * requests together.
+	 */
+	if (q->nr_cached_merge >= BLKDEV_MAX_RQ) {
+		q->last_merge = NULL;
+		q->nr_cached_merge = 0;
+		return ELEVATOR_NO_MERGE;
+	}
+
+	/*
 	 * First try one-hit cache.
 	 */
 	if (q->last_merge) {
@@ -536,6 +551,10 @@ void elv_merged_request(struct request_q
 	if (type == ELEVATOR_BACK_MERGE)
 		elv_rqhash_reposition(q, rq);
 
+	if (q->last_merge != rq)
+		q->nr_cached_merge = 0;
+	else
+		q->nr_cached_merge++;
 	q->last_merge = rq;
 }
 
@@ -551,6 +570,10 @@ void elv_merge_requests(struct request_q
 	elv_rqhash_del(q, next);
 
 	q->nr_sorted--;
+	if (q->last_merge != rq)
+		q->nr_cached_merge = 0;
+	else
+		q->nr_cached_merge++;
 	q->last_merge = rq;
 }
 
@@ -626,8 +649,10 @@ void elv_insert(struct request_queue *q,
 		q->nr_sorted++;
 		if (rq_mergeable(rq)) {
 			elv_rqhash_add(q, rq);
-			if (!q->last_merge)
+			if (!q->last_merge) {
+				q->nr_cached_merge = 1;
 				q->last_merge = rq;
+			}
 		}
 
 		/*
Index: linux-2.6-lttng/block/blk-merge.c
===================================================================
--- linux-2.6-lttng.orig/block/blk-merge.c	2009-01-17 09:49:54.000000000 -0500
+++ linux-2.6-lttng/block/blk-merge.c	2009-01-17 09:50:29.000000000 -0500
@@ -231,8 +231,10 @@ static inline int ll_new_hw_segment(stru
 	if (req->nr_phys_segments + nr_phys_segs > q->max_hw_segments
 	    || req->nr_phys_segments + nr_phys_segs > q->max_phys_segments) {
 		req->cmd_flags |= REQ_NOMERGE;
-		if (req == q->last_merge)
+		if (req == q->last_merge) {
 			q->last_merge = NULL;
+			q->nr_cached_merge = 0;
+		}
 		return 0;
 	}
 
@@ -256,8 +258,10 @@ int ll_back_merge_fn(struct request_queu
 
 	if (req->nr_sectors + bio_sectors(bio) > max_sectors) {
 		req->cmd_flags |= REQ_NOMERGE;
-		if (req == q->last_merge)
+		if (req == q->last_merge) {
 			q->last_merge = NULL;
+			q->nr_cached_merge = 0;
+		}
 		return 0;
 	}
 	if (!bio_flagged(req->biotail, BIO_SEG_VALID))
@@ -281,8 +285,10 @@ int ll_front_merge_fn(struct request_que
 
 	if (req->nr_sectors + bio_sectors(bio) > max_sectors) {
 		req->cmd_flags |= REQ_NOMERGE;
-		if (req == q->last_merge)
+		if (req == q->last_merge) {
 			q->last_merge = NULL;
+			q->nr_cached_merge = 0;
+		}
 		return 0;
 	}
 	if (!bio_flagged(bio, BIO_SEG_VALID))

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
