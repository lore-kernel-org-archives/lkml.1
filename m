Return-Path: <linux-kernel-owner+w=401wt.eu-S1756415AbZFAXmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756415AbZFAXmw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 19:42:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753456AbZFAXmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 19:42:45 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:43356 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076AbZFAXmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 19:42:45 -0400
Message-ID: <4A246772.1090304@ct.jp.nec.com>
Date: Tue, 02 Jun 2009 08:42:42 +0900
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-kernel@vger.kernel.org, "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
       k-ueda@ct.jp.nec.com
Subject: [PATCH block#for-2.6.31] block: fix a possible oops on elv_abort_queue()
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

I found one more mis-conversion to the 'request is always dequeued
when completing' model in elv_abort_queue() during code inspection.
Although I haven't hit any problem caused by this mis-conversion yet
and just done compile/boot test, please apply if you have no problem.


Request must be dequeued when it completes.
However, elv_abort_queue() completes requests without dequeueing.
This will cause oops in the __blk_end_request_all().
This patch fixes the oops.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 block/elevator.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux-2.6-block/block/elevator.c
===================================================================
--- linux-2.6-block.orig/block/elevator.c
+++ linux-2.6-block/block/elevator.c
@@ -813,6 +813,11 @@ void elv_abort_queue(struct request_queu
 		rq = list_entry_rq(q->queue_head.next);
 		rq->cmd_flags |= REQ_QUIET;
 		trace_block_rq_abort(q, rq);
+		/*
+		 * Mark this request as started so we don't trigger
+		 * any debug logic in the end I/O path.
+		 */
+		blk_start_request(rq);
 		__blk_end_request_all(rq, -EIO);
 	}
 }
