Return-Path: <linux-kernel-owner+w=401wt.eu-S1760877AbXE2JLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760877AbXE2JLi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 05:11:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750968AbXE2JLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 05:11:30 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:35697 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750707AbXE2JLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 05:11:30 -0400
Date: Tue, 29 May 2007 11:11:25 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Tejun Heo <htejun@gmail.com>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] Update Documentation/block/barrier.txt
Message-ID: <Pine.LNX.4.62.0705291107250.7698@pademelon.sonytel.be>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Documentation/block/barrier.txt is not in sync with the actual code:
  - blk_queue_ordered() no longer has a gfp_mask parameter
  - blk_queue_ordered_locked() no longer exists
  - sd_prepare_flush() looks slightly different

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 Documentation/block/barrier.txt |   16 +++-------------
 1 files changed, 3 insertions(+), 13 deletions(-)

--- a/Documentation/block/barrier.txt
+++ b/Documentation/block/barrier.txt
@@ -82,23 +82,12 @@ including draining and flushing.
 typedef void (prepare_flush_fn)(request_queue_t *q, struct request *rq);
 
 int blk_queue_ordered(request_queue_t *q, unsigned ordered,
-		      prepare_flush_fn *prepare_flush_fn,
-		      unsigned gfp_mask);
-
-int blk_queue_ordered_locked(request_queue_t *q, unsigned ordered,
-			     prepare_flush_fn *prepare_flush_fn,
-			     unsigned gfp_mask);
-
-The only difference between the two functions is whether or not the
-caller is holding q->queue_lock on entry.  The latter expects the
-caller is holding the lock.
+		      prepare_flush_fn *prepare_flush_fn);
 
 @q			: the queue in question
 @ordered		: the ordered mode the driver/device supports
 @prepare_flush_fn	: this function should prepare @rq such that it
 			  flushes cache to physical medium when executed
-@gfp_mask		: gfp_mask used when allocating data structures
-			  for ordered processing
 
 For example, SCSI disk driver's prepare_flush_fn looks like the
 following.
@@ -106,9 +95,10 @@ following.
 static void sd_prepare_flush(request_queue_t *q, struct request *rq)
 {
 	memset(rq->cmd, 0, sizeof(rq->cmd));
-	rq->flags |= REQ_BLOCK_PC;
+	rq->cmd_type = REQ_TYPE_BLOCK_PC;
 	rq->timeout = SD_TIMEOUT;
 	rq->cmd[0] = SYNCHRONIZE_CACHE;
+	rq->cmd_len = 10;
 }
 
 The following seven ordered modes are supported.  The following table

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- Sony Network and Software Technology Center Europe (NSCE)
Geert.Uytterhoeven@sonycom.com ------- The Corporate Village, Da Vincilaan 7-D1
Voice +32-2-7008453 Fax +32-2-7008622 ---------------- B-1935 Zaventem, Belgium
