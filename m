Return-Path: <linux-kernel-owner+w=401wt.eu-S1756244AbYKDQQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244AbYKDQQA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 11:16:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755792AbYKDQPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 11:15:34 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:59381 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755661AbYKDQPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 11:15:33 -0500
Date: Tue, 4 Nov 2008 11:15:32 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jens Axboe <jens.axboe@oracle.com>
cc: Tejun Heo <tj@kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] Block: use round_jiffies_up()
Message-ID: <Pine.LNX.4.44L0.0811041114180.3614-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch (as1159) changes the timeout routines in the block core to
use round_jiffies_up().  There's no point in rounding the timer
deadline down, since if it expires too early we will have to restart
it.

The patch also removes a redundant test of q->rq_timed_out_fn, and it
sets req->deadline back to 0 when req is removed from the timer list
(to indicate the req is no longer being timed).

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Index: usb-2.6/block/blk-timeout.c
===================================================================
--- usb-2.6.orig/block/blk-timeout.c
+++ usb-2.6/block/blk-timeout.c
@@ -78,13 +78,14 @@ void blk_delete_timer(struct request *re
 	/*
 	 * Nothing to detach
 	 */
-	if (!q->rq_timed_out_fn || !req->deadline)
+	if (!req->deadline)
 		return;
 
 	list_del_init(&req->timeout_list);
 
 	if (list_empty(&q->timeout_list))
 		del_timer(&q->timeout);
+	req->deadline = 0;
 }
 
 static void blk_rq_timed_out(struct request *req)
@@ -142,7 +143,7 @@ void blk_rq_timed_out_timer(unsigned lon
 	}
 
 	if (next_set && !list_empty(&q->timeout_list))
-		mod_timer(&q->timeout, round_jiffies(next));
+		mod_timer(&q->timeout, round_jiffies_up(next));
 
 	spin_unlock_irqrestore(q->queue_lock, flags);
 }
@@ -201,7 +202,7 @@ void blk_add_timer(struct request *req)
 	 * than an existing one, modify the timer. Round to next nearest
 	 * second.
 	 */
-	expiry = round_jiffies(req->deadline);
+	expiry = round_jiffies_up(req->deadline);
 
 	/*
 	 * We use ->deadline == 0 to detect whether a timer was added or

