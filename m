Return-Path: <linux-kernel-owner+w=401wt.eu-S1758529AbYBAULU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758529AbYBAULU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 15:11:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755342AbYBAULN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 15:11:13 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:10485 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755139AbYBAULM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 15:11:12 -0500
Message-ID: <47A37CD7.6040103@hp.com>
Date: Fri, 01 Feb 2008 15:11:03 -0500
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] Moved UNPLUG traces to match 1-to-1 with PLUG traces
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Currently, with DM (and probably MD) we can receive streams of multiple
PLUG and/or UNPLUG traces on the lower devices:

  8,32   1   910438    25.383725302 12843  P   N [mkfs.ext2]
  8,32   1   911627    25.385613612 12843  P   N [mkfs.ext2]
  8,32   1   911819    25.385931255 12843  P   N [mkfs.ext2]
  8,32   1   913176    25.388396840 12843  P   N [mkfs.ext2]
  8,32   1   914170    25.391634524 12843  P   N [mkfs.ext2]
  8,32   1   915239    25.393325078 12843  P   N [mkfs.ext2]
  8,32   1   915473    25.397930230     0 UT   N [swapper] 18
  8,32   1   915474    25.397936145    32  U   N [kblockd/1] 18
  8,32   1   915497    25.594446953 12843  P   N [mkfs.ext2]
  8,32   1   916806    25.596543309 12843  P   N [mkfs.ext2]
  8,32   1   918351    25.599276485 12843  P   N [mkfs.ext2]
  8,32   1   918377    25.599313544 12843  U   N [mkfs.ext2] 9

The PLUG traces are "protected" by the test-and-clear functionality
in blk_plug_device, however the UNPLUG traces has no such protection.
And in the case where MD or DM were involved, the upper level dev as
well as the lower level devs would both go through blk_unplug which
would generate extra UNPLUGS.

With the proposed change, I only see a good one-to-one mapping of PLUG
and UNPLUG traces on the underlying devices. However, we no longer see
the UNPLUG traces on the MD or DM devices, which one could argue makes
sense because (a) those devices don't have request queues managed by
the block layer, and thus (b) they never had any notion of having been
plugged. (So we saw UNPLUG traces on devices that never had PLUG traces.)

A similar stream with the new patch:

  8,32   1   882908    24.179721271  7539  P   N [mkfs.ext2]
  8,32   1   884121    24.182232467  7539  U   N [mkfs.ext2] 10
  8,32   1   884129    24.182305789  7539  P   N [mkfs.ext2]
  8,32   1   885478    24.184748842  7539  U   N [mkfs.ext2] 14
  8,32   1   885487    24.184791013  7539  P   N [mkfs.ext2]
  8,32   1   886336    24.186479185  7539  U   N [mkfs.ext2] 15
  8,32   1   886343    24.186516024  7539  P   N [mkfs.ext2]
  8,32   1   886414    24.186637771  7539  U   N [mkfs.ext2] 14
  8,32   1   886420    24.186649173  7539  P   N [mkfs.ext2]
  8,32   1   886726    24.193329121     0 UT   N [swapper] 15
  8,32   1   886727    24.193336428    32  U   N [kblockd/1] 15
  8,32   1   886748    24.354771821  7539  P   N [mkfs.ext2]
  8,32   1   888081    24.357279380  7539  U   N [mkfs.ext2] 4
  8,32   1   888090    24.357323899  7539  P   N [mkfs.ext2]
  8,32   1   888934    24.358969886  7539  U   N [mkfs.ext2] 5
  8,32   1   888942    24.359019161  7539  P   N [mkfs.ext2]
  8,32   1   890147    24.361314613  7539  U   N [mkfs.ext2] 8

The proposed patch was tested with a 2.6.22-based kernel, and
compile tested with a 2.6.24-based tree from 31 January 2008
(85004cc367abc000aa36c0d0e270ab609a68b0cb).

Signed-off-by: Alan D. Brunelle <alan.brunelle@hp.com>
---
 block/blk-core.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 8ff9944..1d148b5 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -218,6 +218,9 @@ int blk_remove_plug(struct request_queue *q)
 	if (!test_and_clear_bit(QUEUE_FLAG_PLUGGED, &q->queue_flags))
 		return 0;
 
+	blk_add_trace_pdu_int(q, BLK_TA_UNPLUG_IO, NULL,
+				q->rq.count[READ] + q->rq.count[WRITE]);
+
 	del_timer(&q->unplug_timer);
 	return 1;
 }
@@ -271,9 +274,6 @@ void blk_unplug_work(struct work_struct *work)
 	struct request_queue *q =
 		container_of(work, struct request_queue, unplug_work);
 
-	blk_add_trace_pdu_int(q, BLK_TA_UNPLUG_IO, NULL,
-				q->rq.count[READ] + q->rq.count[WRITE]);
-
 	q->unplug_fn(q);
 }
 
@@ -292,12 +292,8 @@ void blk_unplug(struct request_queue *q)
 	/*
 	 * devices don't necessarily have an ->unplug_fn defined
 	 */
-	if (q->unplug_fn) {
-		blk_add_trace_pdu_int(q, BLK_TA_UNPLUG_IO, NULL,
-					q->rq.count[READ] + q->rq.count[WRITE]);
-
+	if (q->unplug_fn)
 		q->unplug_fn(q);
-	}
 }
 EXPORT_SYMBOL(blk_unplug);
 
-- 
1.5.2.5


