Return-Path: <linux-kernel-owner+w=401wt.eu-S1755883AbYKEVTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883AbYKEVTo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 16:19:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751580AbYKEVTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 16:19:36 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:46094 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751390AbYKEVTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 16:19:36 -0500
Date: Wed, 5 Nov 2008 16:19:35 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jens Axboe <jens.axboe@oracle.com>
cc: Tejun Heo <tj@kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2 ver 2] Block: use round_jiffies_up()
In-Reply-To: <20081105191201.GO21867@kernel.dk>
Message-ID: <Pine.LNX.4.44L0.0811051618490.2187-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch (as1159b) changes the timeout routines in the block core to
use round_jiffies_up().  There's no point in rounding the timer
deadline down, since if it expires too early we will have to restart
it.

The patch also removes some unnecessary tests when a request is
removed from the queue's timer list.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Index: usb-2.6/block/blk-timeout.c
===================================================================
--- usb-2.6.orig/block/blk-timeout.c
+++ usb-2.6/block/blk-timeout.c
@@ -75,14 +75,7 @@ void blk_delete_timer(struct request *re
 {
 	struct request_queue *q = req->q;
 
-	/*
-	 * Nothing to detach
-	 */
-	if (!q->rq_timed_out_fn || !req->deadline)
-		return;
-
 	list_del_init(&req->timeout_list);
-
 	if (list_empty(&q->timeout_list))
 		del_timer(&q->timeout);
 }
@@ -142,7 +135,7 @@ void blk_rq_timed_out_timer(unsigned lon
 	}
 
 	if (next_set && !list_empty(&q->timeout_list))
-		mod_timer(&q->timeout, round_jiffies(next));
+		mod_timer(&q->timeout, round_jiffies_up(next));
 
 	spin_unlock_irqrestore(q->queue_lock, flags);
 }
@@ -198,17 +191,10 @@ void blk_add_timer(struct request *req)
 
 	/*
 	 * If the timer isn't already pending or this timeout is earlier
-	 * than an existing one, modify the timer. Round to next nearest
+	 * than an existing one, modify the timer. Round up to next nearest
 	 * second.
 	 */
-	expiry = round_jiffies(req->deadline);
-
-	/*
-	 * We use ->deadline == 0 to detect whether a timer was added or
-	 * not, so just increase to next jiffy for that specific case
-	 */
-	if (unlikely(!req->deadline))
-		req->deadline = 1;
+	expiry = round_jiffies_up(req->deadline);
 
 	if (!timer_pending(&q->timeout) ||
 	    time_before(expiry, q->timeout.expires))

