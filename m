Return-Path: <linux-kernel-owner+w=401wt.eu-S1752818AbZCPCcD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818AbZCPCcD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 22:32:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752097AbZCPC3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 22:29:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:44302 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752339AbZCPC3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 22:29:19 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, bzolnier@gmail.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 08/17] block: clean up misc stuff after block layer timeout conversion
Date: Mon, 16 Mar 2009 11:28:51 +0900
Message-Id: <1237170540-19130-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1237170540-19130-1-git-send-email-tj@kernel.org>
References: <1237170540-19130-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 16 Mar 2009 02:29:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

* In blk_rq_timed_out_timer(), else { if } to else if

* In blk_add_timer(), simplify if/else block

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-timeout.c |   22 +++++++++-------------
 1 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/block/blk-timeout.c b/block/blk-timeout.c
index bbbdc4b..0bc3961 100644
--- a/block/blk-timeout.c
+++ b/block/blk-timeout.c
@@ -122,10 +122,8 @@ void blk_rq_timed_out_timer(unsigned long data)
 			if (blk_mark_rq_complete(rq))
 				continue;
 			blk_rq_timed_out(rq);
-		} else {
-			if (!next || time_after(next, rq->deadline))
-				next = rq->deadline;
-		}
+		} else if (!next || time_after(next, rq->deadline))
+			next = rq->deadline;
 	}
 
 	/*
@@ -176,16 +174,14 @@ void blk_add_timer(struct request *req)
 	BUG_ON(!list_empty(&req->timeout_list));
 	BUG_ON(test_bit(REQ_ATOM_COMPLETE, &req->atomic_flags));
 
-	if (req->timeout)
-		req->deadline = jiffies + req->timeout;
-	else {
-		req->deadline = jiffies + q->rq_timeout;
-		/*
-		 * Some LLDs, like scsi, peek at the timeout to prevent
-		 * a command from being retried forever.
-		 */
+	/*
+	 * Some LLDs, like scsi, peek at the timeout to prevent a
+	 * command from being retried forever.
+	 */
+	if (!req->timeout)
 		req->timeout = q->rq_timeout;
-	}
+
+	req->deadline = jiffies + req->timeout;
 	list_add_tail(&req->timeout_list, &q->timeout_list);
 
 	/*
-- 
1.6.0.2

