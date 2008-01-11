Return-Path: <linux-kernel-owner+w=401wt.eu-S1762862AbYAKVwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762862AbYAKVwT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 16:52:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761712AbYAKVux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 16:50:53 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55581 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761674AbYAKVuw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 16:50:52 -0500
Date: Fri, 11 Jan 2008 16:50:47 -0500 (EST)
Message-Id: <20080111.165047.90117387.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com
Subject: [PATCH 2/3] block: change elevator to use blk-end-request
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts elevator to use __blk_end_request() directly
so that end_{queued|dequeued}_request() can be removed.
Related 'uptodate' arguments is converted to 'error'.

__blk_end_request() takes care of dequeueing request like below:

	if (!list_empty(&rq->queuelist))
		blkdev_dequeue_request(rq);

In the case of elv_next_request(), blkdev_dequeue_request() has not
been done and the queuelist isn't empty.
So __blk_end_request() calls blkdev_dequeue_request() and
the behavior of elv_next_request() doesn't change.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 block/elevator.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

Index: 2.6.24-rc7/block/elevator.c
===================================================================
--- 2.6.24-rc7.orig/block/elevator.c
+++ 2.6.24-rc7/block/elevator.c
@@ -717,7 +717,7 @@ struct request *elv_next_request(struct 
 		 * not ever see it.
 		 */
 		if (blk_empty_barrier(rq)) {
-			end_queued_request(rq, 1);
+			__blk_end_request(rq, 0, blk_rq_bytes(rq));
 			continue;
 		}
 		if (!(rq->cmd_flags & REQ_STARTED)) {
@@ -760,7 +760,7 @@ struct request *elv_next_request(struct 
 			break;
 		} else if (ret == BLKPREP_KILL) {
 			rq->cmd_flags |= REQ_QUIET;
-			end_queued_request(rq, 0);
+			__blk_end_request(rq, -EIO, blk_rq_bytes(rq));
 		} else {
 			printk(KERN_ERR "%s: bad return=%d\n", __FUNCTION__,
 								ret);
