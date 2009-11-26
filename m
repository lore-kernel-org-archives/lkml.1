Return-Path: <linux-kernel-owner+w=401wt.eu-S1760036AbZKZIo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760036AbZKZIo2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 03:44:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759968AbZKZIoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 03:44:25 -0500
Received: from hera.kernel.org ([140.211.167.34]:58736 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932697AbZKZIoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 03:44:21 -0500
Date: Thu, 26 Nov 2009 08:43:45 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       lizf@cn.fujitsu.com, jens.axboe@oracle.com, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, jens.axboe@oracle.com, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4B0E28E6.7060609@cn.fujitsu.com>
References: <4B0E28E6.7060609@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing: Convert some block events to DEFINE_EVENT
Message-ID: <tip-77ca1e0294f25fc26053ba14353e703158acef26@git.kernel.org>
Git-Commit-ID: 77ca1e0294f25fc26053ba14353e703158acef26
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  77ca1e0294f25fc26053ba14353e703158acef26
Gitweb:     http://git.kernel.org/tip/77ca1e0294f25fc26053ba14353e703158acef26
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Thu, 26 Nov 2009 15:06:14 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 26 Nov 2009 09:14:04 +0100

tracing: Convert some block events to DEFINE_EVENT

use DECLARE_EVENT_CLASS to remove duplicate code:

   text    data     bss     dec     hex filename
  53570    3284     184   57038    dece block/blk-core.o.old
  43702    3284     144   47130    b81a block/blk-core.o

12 events are converted:

  block_rq: block_rq_insert, block_rq_issue
  block_rq_with_error: block_rq_{abort, requeue, complete}
  block_bio: block_bio_{backmerge, frontmerge, queue}
  block_get_rq: block_getrq, block_sleeprq
  block_unplug: block_unplug_timer, block_unplug_io

No change in functionality.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <4B0E28E6.7060609@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/trace/events/block.h |  202 +++++++++---------------------------------
 1 files changed, 42 insertions(+), 160 deletions(-)

diff --git a/include/trace/events/block.h b/include/trace/events/block.h
index 00405b5..5fb7273 100644
--- a/include/trace/events/block.h
+++ b/include/trace/events/block.h
@@ -8,7 +8,7 @@
 #include <linux/blkdev.h>
 #include <linux/tracepoint.h>
 
-TRACE_EVENT(block_rq_abort,
+DECLARE_EVENT_CLASS(block_rq_with_error,
 
 	TP_PROTO(struct request_queue *q, struct request *rq),
 
@@ -40,41 +40,28 @@ TRACE_EVENT(block_rq_abort,
 		  __entry->nr_sector, __entry->errors)
 );
 
-TRACE_EVENT(block_rq_insert,
+DEFINE_EVENT(block_rq_with_error, block_rq_abort,
 
 	TP_PROTO(struct request_queue *q, struct request *rq),
 
-	TP_ARGS(q, rq),
+	TP_ARGS(q, rq)
+);
 
-	TP_STRUCT__entry(
-		__field(  dev_t,	dev			)
-		__field(  sector_t,	sector			)
-		__field(  unsigned int,	nr_sector		)
-		__field(  unsigned int,	bytes			)
-		__array(  char,		rwbs,	6		)
-		__array(  char,         comm,   TASK_COMM_LEN   )
-		__dynamic_array( char,	cmd,	blk_cmd_buf_len(rq)	)
-	),
+DEFINE_EVENT(block_rq_with_error, block_rq_requeue,
 
-	TP_fast_assign(
-		__entry->dev	   = rq->rq_disk ? disk_devt(rq->rq_disk) : 0;
-		__entry->sector    = blk_pc_request(rq) ? 0 : blk_rq_pos(rq);
-		__entry->nr_sector = blk_pc_request(rq) ? 0 : blk_rq_sectors(rq);
-		__entry->bytes     = blk_pc_request(rq) ? blk_rq_bytes(rq) : 0;
+	TP_PROTO(struct request_queue *q, struct request *rq),
 
-		blk_fill_rwbs_rq(__entry->rwbs, rq);
-		blk_dump_cmd(__get_str(cmd), rq);
-		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
-	),
+	TP_ARGS(q, rq)
+);
 
-	TP_printk("%d,%d %s %u (%s) %llu + %u [%s]",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->rwbs, __entry->bytes, __get_str(cmd),
-		  (unsigned long long)__entry->sector,
-		  __entry->nr_sector, __entry->comm)
+DEFINE_EVENT(block_rq_with_error, block_rq_complete,
+
+	TP_PROTO(struct request_queue *q, struct request *rq),
+
+	TP_ARGS(q, rq)
 );
 
-TRACE_EVENT(block_rq_issue,
+DECLARE_EVENT_CLASS(block_rq,
 
 	TP_PROTO(struct request_queue *q, struct request *rq),
 
@@ -86,7 +73,7 @@ TRACE_EVENT(block_rq_issue,
 		__field(  unsigned int,	nr_sector		)
 		__field(  unsigned int,	bytes			)
 		__array(  char,		rwbs,	6		)
-		__array(  char,		comm,   TASK_COMM_LEN   )
+		__array(  char,         comm,   TASK_COMM_LEN   )
 		__dynamic_array( char,	cmd,	blk_cmd_buf_len(rq)	)
 	),
 
@@ -108,68 +95,18 @@ TRACE_EVENT(block_rq_issue,
 		  __entry->nr_sector, __entry->comm)
 );
 
-TRACE_EVENT(block_rq_requeue,
+DEFINE_EVENT(block_rq, block_rq_insert,
 
 	TP_PROTO(struct request_queue *q, struct request *rq),
 
-	TP_ARGS(q, rq),
-
-	TP_STRUCT__entry(
-		__field(  dev_t,	dev			)
-		__field(  sector_t,	sector			)
-		__field(  unsigned int,	nr_sector		)
-		__field(  int,		errors			)
-		__array(  char,		rwbs,	6		)
-		__dynamic_array( char,	cmd,	blk_cmd_buf_len(rq)	)
-	),
-
-	TP_fast_assign(
-		__entry->dev	   = rq->rq_disk ? disk_devt(rq->rq_disk) : 0;
-		__entry->sector    = blk_pc_request(rq) ? 0 : blk_rq_pos(rq);
-		__entry->nr_sector = blk_pc_request(rq) ? 0 : blk_rq_sectors(rq);
-		__entry->errors	   = rq->errors;
-
-		blk_fill_rwbs_rq(__entry->rwbs, rq);
-		blk_dump_cmd(__get_str(cmd), rq);
-	),
-
-	TP_printk("%d,%d %s (%s) %llu + %u [%d]",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->rwbs, __get_str(cmd),
-		  (unsigned long long)__entry->sector,
-		  __entry->nr_sector, __entry->errors)
+	TP_ARGS(q, rq)
 );
 
-TRACE_EVENT(block_rq_complete,
+DEFINE_EVENT(block_rq, block_rq_issue,
 
 	TP_PROTO(struct request_queue *q, struct request *rq),
 
-	TP_ARGS(q, rq),
-
-	TP_STRUCT__entry(
-		__field(  dev_t,	dev			)
-		__field(  sector_t,	sector			)
-		__field(  unsigned int,	nr_sector		)
-		__field(  int,		errors			)
-		__array(  char,		rwbs,	6		)
-		__dynamic_array( char,	cmd,	blk_cmd_buf_len(rq)	)
-	),
-
-	TP_fast_assign(
-		__entry->dev	   = rq->rq_disk ? disk_devt(rq->rq_disk) : 0;
-		__entry->sector    = blk_pc_request(rq) ? 0 : blk_rq_pos(rq);
-		__entry->nr_sector = blk_pc_request(rq) ? 0 : blk_rq_sectors(rq);
-		__entry->errors    = rq->errors;
-
-		blk_fill_rwbs_rq(__entry->rwbs, rq);
-		blk_dump_cmd(__get_str(cmd), rq);
-	),
-
-	TP_printk("%d,%d %s (%s) %llu + %u [%d]",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->rwbs, __get_str(cmd),
-		  (unsigned long long)__entry->sector,
-		  __entry->nr_sector, __entry->errors)
+	TP_ARGS(q, rq)
 );
 
 TRACE_EVENT(block_bio_bounce,
@@ -228,7 +165,7 @@ TRACE_EVENT(block_bio_complete,
 		  __entry->nr_sector, __entry->error)
 );
 
-TRACE_EVENT(block_bio_backmerge,
+DECLARE_EVENT_CLASS(block_bio,
 
 	TP_PROTO(struct request_queue *q, struct bio *bio),
 
@@ -256,63 +193,28 @@ TRACE_EVENT(block_bio_backmerge,
 		  __entry->nr_sector, __entry->comm)
 );
 
-TRACE_EVENT(block_bio_frontmerge,
+DEFINE_EVENT(block_bio, block_bio_backmerge,
 
 	TP_PROTO(struct request_queue *q, struct bio *bio),
 
-	TP_ARGS(q, bio),
-
-	TP_STRUCT__entry(
-		__field( dev_t,		dev			)
-		__field( sector_t,	sector			)
-		__field( unsigned,	nr_sector		)
-		__array( char,		rwbs,	6		)
-		__array( char,		comm,	TASK_COMM_LEN	)
-	),
-
-	TP_fast_assign(
-		__entry->dev		= bio->bi_bdev->bd_dev;
-		__entry->sector		= bio->bi_sector;
-		__entry->nr_sector	= bio->bi_size >> 9;
-		blk_fill_rwbs(__entry->rwbs, bio->bi_rw, bio->bi_size);
-		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
-	),
-
-	TP_printk("%d,%d %s %llu + %u [%s]",
-		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,
-		  (unsigned long long)__entry->sector,
-		  __entry->nr_sector, __entry->comm)
+	TP_ARGS(q, bio)
 );
 
-TRACE_EVENT(block_bio_queue,
+DEFINE_EVENT(block_bio, block_bio_frontmerge,
 
 	TP_PROTO(struct request_queue *q, struct bio *bio),
 
-	TP_ARGS(q, bio),
+	TP_ARGS(q, bio)
+);
 
-	TP_STRUCT__entry(
-		__field( dev_t,		dev			)
-		__field( sector_t,	sector			)
-		__field( unsigned int,	nr_sector		)
-		__array( char,		rwbs,	6		)
-		__array( char,		comm,	TASK_COMM_LEN	)
-	),
+DEFINE_EVENT(block_bio, block_bio_queue,
 
-	TP_fast_assign(
-		__entry->dev		= bio->bi_bdev->bd_dev;
-		__entry->sector		= bio->bi_sector;
-		__entry->nr_sector	= bio->bi_size >> 9;
-		blk_fill_rwbs(__entry->rwbs, bio->bi_rw, bio->bi_size);
-		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
-	),
+	TP_PROTO(struct request_queue *q, struct bio *bio),
 
-	TP_printk("%d,%d %s %llu + %u [%s]",
-		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,
-		  (unsigned long long)__entry->sector,
-		  __entry->nr_sector, __entry->comm)
+	TP_ARGS(q, bio)
 );
 
-TRACE_EVENT(block_getrq,
+DECLARE_EVENT_CLASS(block_get_rq,
 
 	TP_PROTO(struct request_queue *q, struct bio *bio, int rw),
 
@@ -341,33 +243,18 @@ TRACE_EVENT(block_getrq,
 		  __entry->nr_sector, __entry->comm)
 );
 
-TRACE_EVENT(block_sleeprq,
+DEFINE_EVENT(block_get_rq, block_getrq,
 
 	TP_PROTO(struct request_queue *q, struct bio *bio, int rw),
 
-	TP_ARGS(q, bio, rw),
+	TP_ARGS(q, bio, rw)
+);
 
-	TP_STRUCT__entry(
-		__field( dev_t,		dev			)
-		__field( sector_t,	sector			)
-		__field( unsigned int,	nr_sector		)
-		__array( char,		rwbs,	6		)
-		__array( char,		comm,	TASK_COMM_LEN	)
-	),
+DEFINE_EVENT(block_get_rq, block_sleeprq,
 
-	TP_fast_assign(
-		__entry->dev		= bio ? bio->bi_bdev->bd_dev : 0;
-		__entry->sector		= bio ? bio->bi_sector : 0;
-		__entry->nr_sector	= bio ? bio->bi_size >> 9 : 0;
-		blk_fill_rwbs(__entry->rwbs,
-			    bio ? bio->bi_rw : 0, __entry->nr_sector);
-		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
-	),
+	TP_PROTO(struct request_queue *q, struct bio *bio, int rw),
 
-	TP_printk("%d,%d %s %llu + %u [%s]",
-		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,
-		  (unsigned long long)__entry->sector,
-		  __entry->nr_sector, __entry->comm)
+	TP_ARGS(q, bio, rw)
 );
 
 TRACE_EVENT(block_plug,
@@ -387,7 +274,7 @@ TRACE_EVENT(block_plug,
 	TP_printk("[%s]", __entry->comm)
 );
 
-TRACE_EVENT(block_unplug_timer,
+DECLARE_EVENT_CLASS(block_unplug,
 
 	TP_PROTO(struct request_queue *q),
 
@@ -406,23 +293,18 @@ TRACE_EVENT(block_unplug_timer,
 	TP_printk("[%s] %d", __entry->comm, __entry->nr_rq)
 );
 
-TRACE_EVENT(block_unplug_io,
+DEFINE_EVENT(block_unplug, block_unplug_timer,
 
 	TP_PROTO(struct request_queue *q),
 
-	TP_ARGS(q),
+	TP_ARGS(q)
+);
 
-	TP_STRUCT__entry(
-		__field( int,		nr_rq			)
-		__array( char,		comm,	TASK_COMM_LEN	)
-	),
+DEFINE_EVENT(block_unplug, block_unplug_io,
 
-	TP_fast_assign(
-		__entry->nr_rq	= q->rq.count[READ] + q->rq.count[WRITE];
-		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
-	),
+	TP_PROTO(struct request_queue *q),
 
-	TP_printk("[%s] %d", __entry->comm, __entry->nr_rq)
+	TP_ARGS(q)
 );
 
 TRACE_EVENT(block_split,
