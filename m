Return-Path: <linux-kernel-owner+w=401wt.eu-S1754912AbZIMBuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912AbZIMBuk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 21:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754767AbZIMBuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 21:50:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:59659 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754520AbZIMBuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 21:50:21 -0400
Message-Id: <20090913015023.021281495@goodmis.org>
References: <20090913014906.407896305@goodmis.org>
User-Agent: quilt/0.46-1
Date: Sat, 12 Sep 2009 21:49:07 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Thomas Gleixner <tglx@linutronix.de>,
       Carsten Emde <Carsten.Emde@osadl.org>, Carsten Emde <C.Emde@osadl.org>
Subject: [PATCH 1/3] tracing: prevent NULL pointer dereference in ftrace_raw_event_block_bio_bounce
Content-Disposition: inline; filename=0001-tracing-prevent-NULL-pointer-dereference-in-ftrace_r.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Carsten Emde <Carsten.Emde@osadl.org>

Booting 2.6.31 and executing
   echo 1 >/sys/kernel/debug/tracing/events/enable
leads to
BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<c032a583>] ftrace_raw_event_block_bio_bounce+0x4b/0xb9

Apparently,
   bio = bio_map_user(q, NULL, uaddr, len, reading, gfp_mask);
is called in block/blk-map.c:58 where bio->bi_bdev in set to NULL and
still is NULL when an attempt is made to evaluate bio->bi_bdev->bd_dev
in include/trace/events/block.h:189.

The tracepoint should ensure bio->bi_bdev is not dereferenced, if NULL.

Signed-off-by: Carsten Emde <C.Emde@osadl.org>
LKML-Reference: <4AAAC9B1.9060505@osadl.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/events/block.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/include/trace/events/block.h b/include/trace/events/block.h
index 9a74b46..d86af94 100644
--- a/include/trace/events/block.h
+++ b/include/trace/events/block.h
@@ -171,6 +171,7 @@ TRACE_EVENT(block_rq_complete,
 		  (unsigned long long)__entry->sector,
 		  __entry->nr_sector, __entry->errors)
 );
+
 TRACE_EVENT(block_bio_bounce,
 
 	TP_PROTO(struct request_queue *q, struct bio *bio),
@@ -186,7 +187,8 @@ TRACE_EVENT(block_bio_bounce,
 	),
 
 	TP_fast_assign(
-		__entry->dev		= bio->bi_bdev->bd_dev;
+		__entry->dev		= bio->bi_bdev ?
+					  bio->bi_bdev->bd_dev : 0;
 		__entry->sector		= bio->bi_sector;
 		__entry->nr_sector	= bio->bi_size >> 9;
 		blk_fill_rwbs(__entry->rwbs, bio->bi_rw, bio->bi_size);
-- 
1.6.3.3

-- 
