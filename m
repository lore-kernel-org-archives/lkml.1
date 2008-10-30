Return-Path: <linux-kernel-owner+w=401wt.eu-S1753673AbYJ3DUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673AbYJ3DUI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 23:20:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752860AbYJ3DTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 23:19:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:42447 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752345AbYJ3DTv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 23:19:51 -0400
Message-ID: <490927CD.2010205@kernel.org>
Date: Thu, 30 Oct 2008 12:19:41 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: [PATCH] block: add timer on blkdev_dequeue_request() not elv_next_request()
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 30 Oct 2008 03:19:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Block queue supports two usage models - one where block driver peeks
at the front of queue using elv_next_request(), processes it and
finishes it and the other where block driver peeks at the front of
queue, dequeue the request using blkdev_dequeue_request() and finishes
it.  The latter is more flexible as it allows the driver to process
multiple commands concurrently.

These two inconsistent usage models affect the block layer
implementation confusing.  For some, elv_next_request() is considered
the issue point while others consider blkdev_dequeue_request() the
issue point.

Till now the inconsistency mostly affect only accounting, so it didn't
really break anything seriously; however, with block layer timeout,
this inconsistency hits hard.  Block layer considers
elv_next_request() the issue point and adds timer but SCSI layer
thinks it was just peeking and when the request can't process the
command right away, it's just left there without further processing.
This makes the request dangling on the timer list and, when the timer
goes off, the request which the SCSI layer and below think is still on
the block queue ends up in the EH queue, causing various problems - EH
hang (failed count goes over busy count and EH never wakes up),
WARN_ON() and oopses as low level driver trying to handle the unknown
command, etc. depending on the timing.

As SCSI midlayer is the only user of block layer timer at the moment,
moving blk_add_timer() to elv_dequeue_request() fixes the problem;
however, this two usage models definitely need to be cleaned up in the
future.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/elevator.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Index: work/block/elevator.c
===================================================================
--- work.orig/block/elevator.c
+++ work/block/elevator.c
@@ -773,12 +773,6 @@ struct request *elv_next_request(struct
 			 */
 			rq->cmd_flags |= REQ_STARTED;
 			blk_add_trace_rq(q, rq, BLK_TA_ISSUE);
-
-			/*
-			 * We are now handing the request to the hardware,
-			 * add the timeout handler
-			 */
-			blk_add_timer(rq);
 		}
 
 		if (!q->boundary_rq || q->boundary_rq == rq) {
@@ -850,6 +844,12 @@ void elv_dequeue_request(struct request_
 	 */
 	if (blk_account_rq(rq))
 		q->in_flight++;
+
+	/*
+	 * We are now handing the request to the hardware, add the
+	 * timeout handler.
+	 */
+	blk_add_timer(rq);
 }
 EXPORT_SYMBOL(elv_dequeue_request);
 
