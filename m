Return-Path: <linux-kernel-owner+w=401wt.eu-S1760586AbZCXQHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760586AbZCXQHp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 12:07:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762132AbZCXQGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 12:06:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:41798 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755825AbZCXQGa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 12:06:30 -0400
From: Tejun Heo <tj@kernel.org>
To: bzolnier@gmail.com, linux-kernel@vger.kernel.org, axboe@kernel.dk,
       linux-ide@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/14] block: clear req->errors on bio completion only for fs requests
Date: Wed, 25 Mar 2009 01:06:03 +0900
Message-Id: <1237910776-10983-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1237910776-10983-1-git-send-email-tj@kernel.org>
References: <1237910776-10983-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 24 Mar 2009 16:06:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: subtle behavior change

For fs requests, rq is only carrier of bios and rq error status as a
whole doesn't mean much.  This is the reason why rq->errors is being
cleared on each partial completion of a request as on each partial
completion the error status is transferred to the respective bios.

For pc requests, rq->errors is used to carry error status to the
issuer and thus __end_that_request_first() doesn't clear it on such
cases.

The condition was fine till now as only fs and pc requests have used
bio and thus the bio completion path.  However, future changes will
unify data accesses to bio and all non fs users care about rq error
status.  Clear rq->errors on bio completion only for fs requests.

In general, the implicit clearing is a bit too subtle especially as
the meaning of rq->errors is completely dependent on low level
drivers.  Unifying / cleaning up rq->errors usage and letting llds
manage it would be better.  TODO comment added.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/blk-core.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 29bcfac..beb597d 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1735,10 +1735,14 @@ static int __end_that_request_first(struct request *req, int error,
 	trace_block_rq_complete(req->q, req);
 
 	/*
-	 * for a REQ_TYPE_BLOCK_PC request, we want to carry any eventual
-	 * sense key with us all the way through
+	 * For fs requests, rq is just carrier of independent bio's
+	 * and each partial completion should be handled separately.
+	 * Reset per-request error on each partial completion.
+	 *
+	 * TODO: tj: This is too subtle.  It would be better to let
+	 * low level drivers do what they see fit.
 	 */
-	if (!blk_pc_request(req))
+	if (blk_fs_request(req))
 		req->errors = 0;
 
 	if (error && (blk_fs_request(req) && !(req->cmd_flags & REQ_QUIET))) {
-- 
1.6.0.2

