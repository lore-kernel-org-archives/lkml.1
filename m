Return-Path: <linux-kernel-owner+w=401wt.eu-S1754207AbZCDPqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbZCDPqA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 10:46:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752336AbZCDPpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 10:45:52 -0500
Received: from casper.infradead.org ([85.118.1.10]:50102 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbZCDPpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 10:45:51 -0500
Subject: [RFC][PATCH] tracing: block events
From: Peter Zijlstra <peterz@infradead.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       "jens.axboe" <jens.axboe@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>,
       Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 04 Mar 2009 16:45:29 +0100
Message-Id: <1236181529.5330.7912.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: tracing: block events
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Wed Mar 04 15:09:43 CET 2009

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/trace/block.h             |   69 --------------
 include/trace/block_event_types.h |  177 ++++++++++++++++++++++++++++++++++++++
 include/trace/trace_event_types.h |    1 
 include/trace/trace_events.h      |    1 
 4 files changed, 180 insertions(+), 68 deletions(-)

Index: linux-2.6/include/trace/block.h
===================================================================
--- linux-2.6.orig/include/trace/block.h
+++ linux-2.6/include/trace/block.h
@@ -4,73 +4,6 @@
 #include <linux/blkdev.h>
 #include <linux/tracepoint.h>
 
-DECLARE_TRACE(block_rq_abort,
-	TPPROTO(struct request_queue *q, struct request *rq),
-		TPARGS(q, rq));
-
-DECLARE_TRACE(block_rq_insert,
-	TPPROTO(struct request_queue *q, struct request *rq),
-		TPARGS(q, rq));
-
-DECLARE_TRACE(block_rq_issue,
-	TPPROTO(struct request_queue *q, struct request *rq),
-		TPARGS(q, rq));
-
-DECLARE_TRACE(block_rq_requeue,
-	TPPROTO(struct request_queue *q, struct request *rq),
-		TPARGS(q, rq));
-
-DECLARE_TRACE(block_rq_complete,
-	TPPROTO(struct request_queue *q, struct request *rq),
-		TPARGS(q, rq));
-
-DECLARE_TRACE(block_bio_bounce,
-	TPPROTO(struct request_queue *q, struct bio *bio),
-		TPARGS(q, bio));
-
-DECLARE_TRACE(block_bio_complete,
-	TPPROTO(struct request_queue *q, struct bio *bio),
-		TPARGS(q, bio));
-
-DECLARE_TRACE(block_bio_backmerge,
-	TPPROTO(struct request_queue *q, struct bio *bio),
-		TPARGS(q, bio));
-
-DECLARE_TRACE(block_bio_frontmerge,
-	TPPROTO(struct request_queue *q, struct bio *bio),
-		TPARGS(q, bio));
-
-DECLARE_TRACE(block_bio_queue,
-	TPPROTO(struct request_queue *q, struct bio *bio),
-		TPARGS(q, bio));
-
-DECLARE_TRACE(block_getrq,
-	TPPROTO(struct request_queue *q, struct bio *bio, int rw),
-		TPARGS(q, bio, rw));
-
-DECLARE_TRACE(block_sleeprq,
-	TPPROTO(struct request_queue *q, struct bio *bio, int rw),
-		TPARGS(q, bio, rw));
-
-DECLARE_TRACE(block_plug,
-	TPPROTO(struct request_queue *q),
-		TPARGS(q));
-
-DECLARE_TRACE(block_unplug_timer,
-	TPPROTO(struct request_queue *q),
-		TPARGS(q));
-
-DECLARE_TRACE(block_unplug_io,
-	TPPROTO(struct request_queue *q),
-		TPARGS(q));
-
-DECLARE_TRACE(block_split,
-	TPPROTO(struct request_queue *q, struct bio *bio, unsigned int pdu),
-		TPARGS(q, bio, pdu));
-
-DECLARE_TRACE(block_remap,
-	TPPROTO(struct request_queue *q, struct bio *bio, dev_t dev,
-		sector_t from, sector_t to),
-		TPARGS(q, bio, dev, from, to));
+#include <trace/block_event_types.h>
 
 #endif
Index: linux-2.6/include/trace/block_event_types.h
===================================================================
--- /dev/null
+++ linux-2.6/include/trace/block_event_types.h
@@ -0,0 +1,177 @@
+
+#ifndef TRACE_EVENT_FORMAT
+# error Do not include this file directly.
+# error Unless you know what you are doing.
+#endif
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM block
+
+#ifdef CONFIG_BLK_DEV_IO_TRACE
+#define Q_DEV(q) (q->bt ? q->bt->dev : 0)
+#else
+#define Q_DEV(q) 0
+#endif
+
+TRACE_FORMAT(block_rq_abort,
+	TPPROTO(struct request_queue *q, struct request *rq),
+	TPARGS(q, rq),
+	TPFMT("%d:%d %c %llu + %u",
+		MAJOR(Q_DEV(q)), MINOR(Q_DEV(q)),
+		rq->cmd_flags & __REQ_RW ? 'W' : 'R',
+		blk_pc_request(rq) ? 0 : rq->hard_sector,
+		blk_pc_request(rq) ? rq->data_len : rq->hard_nr_sectors << 9)
+	);
+
+TRACE_FORMAT(block_rq_insert,
+	TPPROTO(struct request_queue *q, struct request *rq),
+	TPARGS(q, rq),
+	TPFMT("%d:%d %c %llu + %u",
+		MAJOR(Q_DEV(q)), MINOR(Q_DEV(q)),
+		rq->cmd_flags & __REQ_RW ? 'W' : 'R',
+		blk_pc_request(rq) ? 0 : rq->hard_sector,
+		blk_pc_request(rq) ? rq->data_len : rq->hard_nr_sectors << 9)
+	);
+
+TRACE_FORMAT(block_rq_issue,
+	TPPROTO(struct request_queue *q, struct request *rq),
+	TPARGS(q, rq),
+	TPFMT("%d:%d %c %llu + %u",
+		MAJOR(Q_DEV(q)), MINOR(Q_DEV(q)),
+		rq->cmd_flags & __REQ_RW ? 'W' : 'R',
+		blk_pc_request(rq) ? 0 : rq->hard_sector,
+		blk_pc_request(rq) ? rq->data_len : rq->hard_nr_sectors << 9)
+	);
+
+TRACE_FORMAT(block_rq_requeue,
+	TPPROTO(struct request_queue *q, struct request *rq),
+	TPARGS(q, rq),
+	TPFMT("%d:%d %c %llu + %u [%d]",
+		MAJOR(Q_DEV(q)), MINOR(Q_DEV(q)),
+		rq->cmd_flags & __REQ_RW ? 'W' : 'R',
+		blk_pc_request(rq) ? 0 : rq->hard_sector,
+		blk_pc_request(rq) ? rq->data_len : rq->hard_nr_sectors << 9,
+		rq->errors)
+	);
+
+TRACE_FORMAT(block_rq_complete,
+	TPPROTO(struct request_queue *q, struct request *rq),
+	TPARGS(q, rq),
+	TPFMT("%d:%d %c %llu + %u [%d]",
+		MAJOR(Q_DEV(q)), MINOR(Q_DEV(q)),
+		rq->cmd_flags & __REQ_RW ? 'W' : 'R',
+		blk_pc_request(rq) ? 0 : rq->hard_sector,
+		blk_pc_request(rq) ? rq->data_len : rq->hard_nr_sectors << 9,
+		rq->errors)
+	);
+
+TRACE_FORMAT(block_bio_bounce,
+	TPPROTO(struct request_queue *q, struct bio *bio),
+	TPARGS(q, bio),
+	TPFMT("%d:%d %c %llu + %u",
+		MAJOR(Q_DEV(q)), MINOR(Q_DEV(q)),
+		bio->bi_rw & WRITE ? 'W' : 'R',
+		bio->bi_sector, bio->bi_size)
+	);
+
+TRACE_FORMAT(block_bio_complete,
+	TPPROTO(struct request_queue *q, struct bio *bio),
+	TPARGS(q, bio),
+	TPFMT("%d:%d %c %llu + %u [%d]",
+		MAJOR(Q_DEV(q)), MINOR(Q_DEV(q)),
+		bio->bi_rw & WRITE ? 'W' : 'R',
+		bio->bi_sector, bio->bi_size,
+		!bio_flagged(bio, BIO_UPTODATE))
+	);
+
+TRACE_FORMAT(block_bio_backmerge,
+	TPPROTO(struct request_queue *q, struct bio *bio),
+	TPARGS(q, bio),
+	TPFMT("%d:%d %c %llu + %u",
+		MAJOR(Q_DEV(q)), MINOR(Q_DEV(q)),
+		bio->bi_rw & WRITE ? 'W' : 'R',
+		bio->bi_sector, bio->bi_size)
+	);
+
+TRACE_FORMAT(block_bio_frontmerge,
+	TPPROTO(struct request_queue *q, struct bio *bio),
+	TPARGS(q, bio),
+	TPFMT("%d:%d %c %llu + %u",
+		MAJOR(Q_DEV(q)), MINOR(Q_DEV(q)),
+		bio->bi_rw & WRITE ? 'W' : 'R',
+		bio->bi_sector, bio->bi_size)
+	);
+
+TRACE_FORMAT(block_bio_queue,
+	TPPROTO(struct request_queue *q, struct bio *bio),
+	TPARGS(q, bio),
+	TPFMT("%d:%d %c %llu + %u",
+		MAJOR(Q_DEV(q)), MINOR(Q_DEV(q)),
+		bio->bi_rw & WRITE ? 'W' : 'R',
+		bio->bi_sector, bio->bi_size)
+	);
+
+TRACE_FORMAT(block_getrq,
+	TPPROTO(struct request_queue *q, struct bio *bio, int rw),
+	TPARGS(q, bio, rw),
+	TPFMT("%d:%d %c %llu + %u",
+		MAJOR(Q_DEV(q)), MINOR(Q_DEV(q)),
+		(bio ? (bio->bi_rw & WRITE) : rw) ? 'W' : 'R',
+		bio ? bio->bi_sector : 0,
+		bio ? bio->bi_size : 0)
+	);
+
+TRACE_FORMAT(block_sleeprq,
+	TPPROTO(struct request_queue *q, struct bio *bio, int rw),
+	TPARGS(q, bio, rw),
+	TPFMT("%d:%d %c %llu + %u",
+		MAJOR(Q_DEV(q)), MINOR(Q_DEV(q)),
+		(bio ? (bio->bi_rw & WRITE) : rw) ? 'W' : 'R',
+		bio ? bio->bi_sector : 0,
+		bio ? bio->bi_size : 0)
+	);
+
+TRACE_FORMAT(block_plug,
+	TPPROTO(struct request_queue *q),
+	TPARGS(q),
+	TPFMT("%d:%d",
+		MAJOR(Q_DEV(q)), MINOR(Q_DEV(q)))
+	);
+
+TRACE_FORMAT(block_unplug_timer,
+	TPPROTO(struct request_queue *q),
+	TPARGS(q),
+	TPFMT("%d:%d",
+		MAJOR(Q_DEV(q)), MINOR(Q_DEV(q)))
+	);
+
+TRACE_FORMAT(block_unplug_io,
+	TPPROTO(struct request_queue *q),
+	TPARGS(q),
+	TPFMT("%d:%d",
+		MAJOR(Q_DEV(q)), MINOR(Q_DEV(q)))
+	);
+
+TRACE_FORMAT(block_split,
+	TPPROTO(struct request_queue *q, struct bio *bio, unsigned int pdu),
+	TPARGS(q, bio, pdu),
+	TPFMT("%d:%d %c %llu + %u",
+		MAJOR(Q_DEV(q)), MINOR(Q_DEV(q)),
+		bio->bi_rw & WRITE ? 'W' : 'R',
+		bio->bi_sector, bio->bi_size)
+	); /* FIXME add pdu info */
+
+TRACE_FORMAT(block_remap,
+	TPPROTO(struct request_queue *q, struct bio *bio, dev_t dev,
+		sector_t from, sector_t to),
+	TPARGS(q, bio, dev, from, to),
+	TPFMT("%d:%d %c %llu + %u -> (%d:%d) %llu",
+		MAJOR(Q_DEV(q)), MINOR(Q_DEV(q)),
+		bio->bi_rw & WRITE ? 'W' : 'R',
+		from, bio->bi_size,
+		MAJOR(dev), MINOR(dev), to)
+	);
+
+#undef Q_DEV
+
+#undef TRACE_SYSTEM
Index: linux-2.6/include/trace/trace_event_types.h
===================================================================
--- linux-2.6.orig/include/trace/trace_event_types.h
+++ linux-2.6/include/trace/trace_event_types.h
@@ -3,3 +3,4 @@
 #include <trace/sched_event_types.h>
 #include <trace/irq_event_types.h>
 #include <trace/lockdep_event_types.h>
+#include <trace/block_event_types.h>
Index: linux-2.6/include/trace/trace_events.h
===================================================================
--- linux-2.6.orig/include/trace/trace_events.h
+++ linux-2.6/include/trace/trace_events.h
@@ -3,3 +3,4 @@
 #include <trace/sched.h>
 #include <trace/irq.h>
 #include <trace/lockdep.h>
+#include <trace/block.h>


