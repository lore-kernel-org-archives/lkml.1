Return-Path: <linux-kernel-owner+w=401wt.eu-S1756844AbZDOXq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756844AbZDOXq5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 19:46:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753056AbZDOXqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 19:46:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:36575 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752855AbZDOXqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 19:46:45 -0400
Message-ID: <49E671D8.1090002@kernel.org>
Date: Thu, 16 Apr 2009 08:46:32 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, petkovbb@googlemail.com
Subject: [block #for-next] block: clear req->errors on bio completion only
 for fs requests
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 15 Apr 2009 23:46:36 +0000 (UTC)
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
Jens, can you please ack this patch?  With FUJITA's scsi_lib cleanup
and Borislav's patch to make ide not use preallocated data structures,
this is the only block bit which is necessary for ide cleanup
patchets.  If you're okay with it, I'd like to push this through
Bartlomiej's tree.

Thanks.

 block/blk-core.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

Index: block/block/blk-core.c
===================================================================
--- block.orig/block/blk-core.c
+++ block/block/blk-core.c
@@ -1739,10 +1739,14 @@ static int __end_that_request_first(stru
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
