Return-Path: <linux-kernel-owner+w=401wt.eu-S1755336AbZCPCa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336AbZCPCa1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 22:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752495AbZCPC3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 22:29:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:44275 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752027AbZCPC3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 22:29:14 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, bzolnier@gmail.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/17] block: merge blk_invoke_request_fn() into __blk_run_queue()
Date: Mon, 16 Mar 2009 11:28:47 +0900
Message-Id: <1237170540-19130-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1237170540-19130-1-git-send-email-tj@kernel.org>
References: <1237170540-19130-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 16 Mar 2009 02:29:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: merge two subtly different internal functions

__blk_run_queue wraps blk_invoke_request_fn() such that it
additionally removes plug and bails out early if the queue is empty.
Both extra operations have their own pending mechanisms and don't
cause any harm correctness-wise when they are done superflously.

The only user of blk_invoke_request_fn() being blk_start_queue(),
there isn't much reason to keep both functions around.  Merge
blk_invoke_request_fn() into __blk_run_queue() and make
blk_start_queue() use __blk_run_queue() instead.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-core.c |   35 ++++++++++++++---------------------
 1 files changed, 14 insertions(+), 21 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 7b63c9b..95dc76f 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -333,24 +333,6 @@ void blk_unplug(struct request_queue *q)
 }
 EXPORT_SYMBOL(blk_unplug);
 
-static void blk_invoke_request_fn(struct request_queue *q)
-{
-	if (unlikely(blk_queue_stopped(q)))
-		return;
-
-	/*
-	 * one level of recursion is ok and is much faster than kicking
-	 * the unplug handling
-	 */
-	if (!queue_flag_test_and_set(QUEUE_FLAG_REENTER, q)) {
-		q->request_fn(q);
-		queue_flag_clear(QUEUE_FLAG_REENTER, q);
-	} else {
-		queue_flag_set(QUEUE_FLAG_PLUGGED, q);
-		kblockd_schedule_work(q, &q->unplug_work);
-	}
-}
-
 /**
  * blk_start_queue - restart a previously stopped queue
  * @q:    The &struct request_queue in question
@@ -365,7 +347,7 @@ void blk_start_queue(struct request_queue *q)
 	WARN_ON(!irqs_disabled());
 
 	queue_flag_clear(QUEUE_FLAG_STOPPED, q);
-	blk_invoke_request_fn(q);
+	__blk_run_queue(q);
 }
 EXPORT_SYMBOL(blk_start_queue);
 
@@ -425,12 +407,23 @@ void __blk_run_queue(struct request_queue *q)
 {
 	blk_remove_plug(q);
 
+	if (unlikely(blk_queue_stopped(q)))
+		return;
+
+	if (elv_queue_empty(q))
+		return;
+
 	/*
 	 * Only recurse once to avoid overrunning the stack, let the unplug
 	 * handling reinvoke the handler shortly if we already got there.
 	 */
-	if (!elv_queue_empty(q))
-		blk_invoke_request_fn(q);
+	if (!queue_flag_test_and_set(QUEUE_FLAG_REENTER, q)) {
+		q->request_fn(q);
+		queue_flag_clear(QUEUE_FLAG_REENTER, q);
+	} else {
+		queue_flag_set(QUEUE_FLAG_PLUGGED, q);
+		kblockd_schedule_work(q, &q->unplug_work);
+	}
 }
 EXPORT_SYMBOL(__blk_run_queue);
 
-- 
1.6.0.2

