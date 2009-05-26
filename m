Return-Path: <linux-kernel-owner+w=401wt.eu-S1753863AbZEZEEB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863AbZEZEEB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 00:04:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751141AbZEZEDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 00:03:53 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61308 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750822AbZEZEDw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 00:03:52 -0400
Message-ID: <4A1B6A7C.3030504@cn.fujitsu.com>
Date: Tue, 26 May 2009 12:05:16 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, "Theodore Ts'o" <tytso@mit.edu>,
       Steven Whitehouse <swhiteho@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jeff Moyer <jmoyer@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 2/2] tracing/events: convert block trace points to TRACE_EVENT()
References: <4A1B6A2F.2040703@cn.fujitsu.com>
In-Reply-To: <4A1B6A2F.2040703@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TRACE_EVENT is a more generic way to define tracepoints. Doing so adds
these new capabilities to this tracepoint:

  - zero-copy and per-cpu splice() tracing
  - binary tracing without printf overhead
  - structured logging records exposed under /debug/tracing/events
  - trace events embedded in function tracer output and other plugins
  - user-defined, per tracepoint filter expressions
  ...

Cons:

  - no dev_t info for the output of plug, unplug_timer and unplug_io events.
    no dev_t info for getrq and sleeprq events if bio == NULL.
    no dev_t info for rq_abort,...,rq_requeue events if rq->rq_disk == NULL.

    This is mainly because we can't get the deivce from a request queue.
    But this may change in the future.

  - A packet command is converted to a string in TP_assign, not TP_print.
    While blktrace do the convertion just before output.

    Since pc requests should be rather rare, this seems not a big issue.

  - In blktrace, an event can have 2 different print formats, but a TRACE_EVENT
    has a unique format, which means we have some unused data in a trace entry.

    This is minimized by using __string() instead of __array().


Following are some comparisons between TRACE_EVENT and blktrace:

plug:
  kjournald-480   [000]   303.084981: block_plug: [kjournald]
  kjournald-480   [000]   303.084981:   8,0    P   N [kjournald]

unplug_io:
  kblockd/0-118   [000]   300.052973: block_unplug_io: [kblockd/0] 1
  kblockd/0-118   [000]   300.052974:   8,0    U   N [kblockd/0] 1

remap:
  kjournald-480   [000]   303.085042: block_remap: 8,0 W 102736992 + 8 <- (8,8) 33384
  kjournald-480   [000]   303.085043:   8,0    A   W 102736992 + 8 <- (8,8) 33384

bio_backmerge:
  kjournald-480   [000]   303.085086: block_bio_backmerge: 8,0 W 102737032 + 8 [kjournald]
  kjournald-480   [000]   303.085086:   8,0    M   W 102737032 + 8 [kjournald]

getrq:
  kjournald-480   [000]   303.084974: block_getrq: 8,0 W 102736984 + 8 [kjournald]
  kjournald-480   [000]   303.084975:   8,0    G   W 102736984 + 8 [kjournald]

  bash-2066  [001]  1072.953770:   8,0    G   N [bash]
  bash-2066  [001]  1072.953773: block_getrq: 0,0 N 0 + 0 [bash]

rq_complete:
  konsole-2065  [001]   300.053184: block_rq_complete: 8,0 W () 103669040 + 16 [0]
  konsole-2065  [001]   300.053191:   8,0    C   W 103669040 + 16 [0]

  ksoftirqd/1-7   [001]  1072.953811:   8,0    C   N (5a 00 08 00 00 00 00 00 24 00) [0]
  ksoftirqd/1-7   [001]  1072.953813: block_rq_complete: 0,0 N (5a 00 08 00 00 00 00 00 24 00) 0 + 0 [0]

rq_insert:
  kjournald-480   [000]   303.084985: block_rq_insert: 8,0 W 0 () 102736984 + 8 [kjournald]
  kjournald-480   [000]   303.084986:   8,0    I   W 102736984 + 8 [kjournald]


Changelog from v1:

- use __string() instead of __array() to minimize the memory required
  to store hex dump of rq->cmd().

- support large pc requests.

- add missing blk_fill_rwbs_rq() in block_rq_requeue TRACE_EVENT.

- some cleanups.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 block/blk-core.c             |   16 +-
 block/elevator.c             |    8 +-
 drivers/md/dm.c              |    5 +-
 fs/bio.c                     |    3 +-
 include/linux/blktrace_api.h |   13 ++
 include/trace/block.h        |   76 -------
 include/trace/events/block.h |  483 ++++++++++++++++++++++++++++++++++++++++++
 kernel/trace/Makefile        |    5 +-
 kernel/trace/blktrace.c      |   78 +++++++-
 mm/bounce.c                  |    5 +-
 10 files changed, 588 insertions(+), 104 deletions(-)
 delete mode 100644 include/trace/block.h
 create mode 100644 include/trace/events/block.h

diff --git a/block/blk-core.c b/block/blk-core.c
index 1306de9..9475bf9 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -28,22 +28,14 @@
 #include <linux/task_io_accounting_ops.h>
 #include <linux/blktrace_api.h>
 #include <linux/fault-inject.h>
-#include <trace/block.h>
+
+#define CREATE_TRACE_POINTS
+#include <trace/events/block.h>
 
 #include "blk.h"
 
-DEFINE_TRACE(block_plug);
-DEFINE_TRACE(block_unplug_io);
-DEFINE_TRACE(block_unplug_timer);
-DEFINE_TRACE(block_getrq);
-DEFINE_TRACE(block_sleeprq);
-DEFINE_TRACE(block_rq_requeue);
-DEFINE_TRACE(block_bio_backmerge);
-DEFINE_TRACE(block_bio_frontmerge);
-DEFINE_TRACE(block_bio_queue);
-DEFINE_TRACE(block_rq_complete);
-DEFINE_TRACE(block_remap);	/* Also used in drivers/md/dm.c */
 EXPORT_TRACEPOINT_SYMBOL_GPL(block_remap);
+EXPORT_TRACEPOINT_SYMBOL_GPL(block_bio_complete);
 
 static int __make_request(struct request_queue *q, struct bio *bio);
 
diff --git a/block/elevator.c b/block/elevator.c
index 7073a90..e220f0c 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -33,17 +33,16 @@
 #include <linux/compiler.h>
 #include <linux/delay.h>
 #include <linux/blktrace_api.h>
-#include <trace/block.h>
 #include <linux/hash.h>
 #include <linux/uaccess.h>
 
+#include <trace/events/block.h>
+
 #include "blk.h"
 
 static DEFINE_SPINLOCK(elv_list_lock);
 static LIST_HEAD(elv_list);
 
-DEFINE_TRACE(block_rq_abort);
-
 /*
  * Merge hash stuff.
  */
@@ -55,9 +54,6 @@ static const int elv_hash_shift = 6;
 #define rq_hash_key(rq)		((rq)->sector + (rq)->nr_sectors)
 #define ELV_ON_HASH(rq)		(!hlist_unhashed(&(rq)->hash))
 
-DEFINE_TRACE(block_rq_insert);
-DEFINE_TRACE(block_rq_issue);
-
 /*
  * Query io scheduler to see if the current process issuing bio may be
  * merged with rq.
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index e2ee4a7..3fd8b1e 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -20,7 +20,8 @@
 #include <linux/idr.h>
 #include <linux/hdreg.h>
 #include <linux/blktrace_api.h>
-#include <trace/block.h>
+
+#include <trace/events/block.h>
 
 #define DM_MSG_PREFIX "core"
 
@@ -53,8 +54,6 @@ struct dm_target_io {
 	union map_info info;
 };
 
-DEFINE_TRACE(block_bio_complete);
-
 /*
  * For request-based dm.
  * One of these is allocated per request.
diff --git a/fs/bio.c b/fs/bio.c
index 9871164..740699c 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -26,10 +26,9 @@
 #include <linux/mempool.h>
 #include <linux/workqueue.h>
 #include <linux/blktrace_api.h>
-#include <trace/block.h>
 #include <scsi/sg.h>		/* for struct sg_iovec */
 
-DEFINE_TRACE(block_split);
+#include <trace/events/block.h>
 
 /*
  * Test patch to inline a certain number of bi_io_vec's inside the bio
diff --git a/include/linux/blktrace_api.h b/include/linux/blktrace_api.h
index 82b4636..a103c67 100644
--- a/include/linux/blktrace_api.h
+++ b/include/linux/blktrace_api.h
@@ -218,5 +218,18 @@ static inline int blk_trace_init_sysfs(struct device *dev)
 
 #endif /* CONFIG_BLK_DEV_IO_TRACE */
 
+#ifdef CONFIG_EVENT_TRACING
+
+static inline int blk_cmd_buf_len(struct request *rq)
+{
+	return blk_pc_request(rq) ? rq->cmd_len : 1;
+}
+
+extern void blk_dump_cmd(char *buf, struct request *rq);
+extern void blk_fill_rwbs(char *rwbs, u32 rw, int bytes);
+extern void blk_fill_rwbs_rq(char *rwbs, struct request *rq);
+
+#endif /* CONFIG_EVENT_TRACING */
+
 #endif /* __KERNEL__ */
 #endif
diff --git a/include/trace/block.h b/include/trace/block.h
deleted file mode 100644
index 5b12efa..0000000
--- a/include/trace/block.h
+++ /dev/null
@@ -1,76 +0,0 @@
-#ifndef _TRACE_BLOCK_H
-#define _TRACE_BLOCK_H
-
-#include <linux/blkdev.h>
-#include <linux/tracepoint.h>
-
-DECLARE_TRACE(block_rq_abort,
-	TP_PROTO(struct request_queue *q, struct request *rq),
-	      TP_ARGS(q, rq));
-
-DECLARE_TRACE(block_rq_insert,
-	TP_PROTO(struct request_queue *q, struct request *rq),
-	      TP_ARGS(q, rq));
-
-DECLARE_TRACE(block_rq_issue,
-	TP_PROTO(struct request_queue *q, struct request *rq),
-	      TP_ARGS(q, rq));
-
-DECLARE_TRACE(block_rq_requeue,
-	TP_PROTO(struct request_queue *q, struct request *rq),
-	      TP_ARGS(q, rq));
-
-DECLARE_TRACE(block_rq_complete,
-	TP_PROTO(struct request_queue *q, struct request *rq),
-	      TP_ARGS(q, rq));
-
-DECLARE_TRACE(block_bio_bounce,
-	TP_PROTO(struct request_queue *q, struct bio *bio),
-	      TP_ARGS(q, bio));
-
-DECLARE_TRACE(block_bio_complete,
-	TP_PROTO(struct request_queue *q, struct bio *bio),
-	      TP_ARGS(q, bio));
-
-DECLARE_TRACE(block_bio_backmerge,
-	TP_PROTO(struct request_queue *q, struct bio *bio),
-	      TP_ARGS(q, bio));
-
-DECLARE_TRACE(block_bio_frontmerge,
-	TP_PROTO(struct request_queue *q, struct bio *bio),
-	      TP_ARGS(q, bio));
-
-DECLARE_TRACE(block_bio_queue,
-	TP_PROTO(struct request_queue *q, struct bio *bio),
-	      TP_ARGS(q, bio));
-
-DECLARE_TRACE(block_getrq,
-	TP_PROTO(struct request_queue *q, struct bio *bio, int rw),
-	      TP_ARGS(q, bio, rw));
-
-DECLARE_TRACE(block_sleeprq,
-	TP_PROTO(struct request_queue *q, struct bio *bio, int rw),
-	      TP_ARGS(q, bio, rw));
-
-DECLARE_TRACE(block_plug,
-	TP_PROTO(struct request_queue *q),
-	      TP_ARGS(q));
-
-DECLARE_TRACE(block_unplug_timer,
-	TP_PROTO(struct request_queue *q),
-	      TP_ARGS(q));
-
-DECLARE_TRACE(block_unplug_io,
-	TP_PROTO(struct request_queue *q),
-	      TP_ARGS(q));
-
-DECLARE_TRACE(block_split,
-	TP_PROTO(struct request_queue *q, struct bio *bio, unsigned int pdu),
-	      TP_ARGS(q, bio, pdu));
-
-DECLARE_TRACE(block_remap,
-	TP_PROTO(struct request_queue *q, struct bio *bio, dev_t dev,
-		 sector_t from),
-	      TP_ARGS(q, bio, dev, from));
-
-#endif
diff --git a/include/trace/events/block.h b/include/trace/events/block.h
new file mode 100644
index 0000000..a709805
--- /dev/null
+++ b/include/trace/events/block.h
@@ -0,0 +1,483 @@
+#if !defined(_TRACE_BLOCK_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_BLOCK_H
+
+#include <linux/blktrace_api.h>
+#include <linux/blkdev.h>
+#include <linux/tracepoint.h>
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM block
+
+TRACE_EVENT(block_rq_abort,
+
+	TP_PROTO(struct request_queue *q, struct request *rq),
+
+	TP_ARGS(q, rq),
+
+	TP_STRUCT__entry(
+		__field(  dev_t,	dev			)
+		__field(  sector_t,	sector			)
+		__field(  unsigned int,	nr_sector		)
+		__field(  int,		errors			)
+		__array(  char,		rwbs,	6		)
+		__string( cmd,		blk_cmd_buf_len(rq)	)
+	),
+
+	TP_fast_assign(
+		__entry->dev	   = rq->rq_disk ? disk_devt(rq->rq_disk) : 0;
+		__entry->sector    = blk_pc_request(rq) ? 0 : rq->hard_sector;
+		__entry->nr_sector = blk_pc_request(rq) ?
+						0 : rq->hard_nr_sectors;
+		__entry->errors    = rq->errors;
+
+		blk_fill_rwbs_rq(__entry->rwbs, rq);
+		blk_dump_cmd(__fetch_str(cmd), rq);
+	),
+
+	TP_printk("%d,%d %s (%s) %llu + %u [%d]",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->rwbs, __get_str(cmd),
+		  __entry->sector, __entry->nr_sector, __entry->errors)
+);
+
+TRACE_EVENT(block_rq_insert,
+
+	TP_PROTO(struct request_queue *q, struct request *rq),
+
+	TP_ARGS(q, rq),
+
+	TP_STRUCT__entry(
+		__field(  dev_t,	dev			)
+		__field(  sector_t,	sector			)
+		__field(  unsigned int,	nr_sector		)
+		__field(  unsigned int,	bytes			)
+		__array(  char,		rwbs,	6		)
+		__array(  char,         comm,   TASK_COMM_LEN   )
+		__string( cmd,		blk_cmd_buf_len(rq)	)
+	),
+
+	TP_fast_assign(
+		__entry->dev	   = rq->rq_disk ? disk_devt(rq->rq_disk) : 0;
+		__entry->sector    = blk_pc_request(rq) ? 0 : rq->hard_sector;
+		__entry->nr_sector = blk_pc_request(rq) ?
+						0 : rq->hard_nr_sectors;
+		__entry->bytes     = blk_pc_request(rq) ? rq->data_len : 0;
+
+		blk_fill_rwbs_rq(__entry->rwbs, rq);
+		blk_dump_cmd(__fetch_str(cmd), rq);
+		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+	),
+
+	TP_printk("%d,%d %s %u (%s) %llu + %u [%s]",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->rwbs, __entry->bytes, __get_str(cmd),
+		  __entry->sector, __entry->nr_sector, __entry->comm)
+);
+
+TRACE_EVENT(block_rq_issue,
+
+	TP_PROTO(struct request_queue *q, struct request *rq),
+
+	TP_ARGS(q, rq),
+
+	TP_STRUCT__entry(
+		__field(  dev_t,	dev			)
+		__field(  sector_t,	sector			)
+		__field(  unsigned int,	nr_sector		)
+		__field(  unsigned int,	bytes			)
+		__array(  char,		rwbs,	6		)
+		__array(  char,		comm,   TASK_COMM_LEN   )
+		__string( cmd,		blk_cmd_buf_len(rq)	)
+	),
+
+	TP_fast_assign(
+		__entry->dev	   = rq->rq_disk ? disk_devt(rq->rq_disk) : 0;
+		__entry->sector    = blk_pc_request(rq) ? 0 : rq->hard_sector;
+		__entry->nr_sector = blk_pc_request(rq) ?
+						0 : rq->hard_nr_sectors;
+		__entry->bytes     = blk_pc_request(rq) ? rq->data_len : 0;
+
+		blk_fill_rwbs_rq(__entry->rwbs, rq);
+		blk_dump_cmd(__fetch_str(cmd), rq);
+		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+	),
+
+	TP_printk("%d,%d %s %u (%s) %llu + %u [%s]",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->rwbs, __entry->bytes, __get_str(cmd),
+		  __entry->sector, __entry->nr_sector, __entry->comm)
+);
+
+TRACE_EVENT(block_rq_requeue,
+
+	TP_PROTO(struct request_queue *q, struct request *rq),
+
+	TP_ARGS(q, rq),
+
+	TP_STRUCT__entry(
+		__field(  dev_t,	dev			)
+		__field(  sector_t,	sector			)
+		__field(  unsigned int,	nr_sector		)
+		__field(  int,		errors			)
+		__array(  char,		rwbs,	6		)
+		__string( cmd,		blk_cmd_buf_len(rq)	)
+	),
+
+	TP_fast_assign(
+		__entry->dev	   = rq->rq_disk ? disk_devt(rq->rq_disk) : 0;
+		__entry->sector    = blk_pc_request(rq) ? 0 : rq->hard_sector;
+		__entry->nr_sector = blk_pc_request(rq) ?
+						0 : rq->hard_nr_sectors;
+		__entry->errors	   = rq->errors;
+
+		blk_fill_rwbs_rq(__entry->rwbs, rq);
+		blk_dump_cmd(__fetch_str(cmd), rq);
+	),
+
+	TP_printk("%d,%d %s (%s) %llu + %u [%d]",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->rwbs, __get_str(cmd),
+		  __entry->sector, __entry->nr_sector, __entry->errors)
+);
+
+TRACE_EVENT(block_rq_complete,
+
+	TP_PROTO(struct request_queue *q, struct request *rq),
+
+	TP_ARGS(q, rq),
+
+	TP_STRUCT__entry(
+		__field(  dev_t,	dev			)
+		__field(  sector_t,	sector			)
+		__field(  unsigned int,	nr_sector		)
+		__field(  int,		errors			)
+		__array(  char,		rwbs,	6		)
+		__string( cmd,		blk_cmd_buf_len(rq)	)
+	),
+
+	TP_fast_assign(
+		__entry->dev	   = rq->rq_disk ? disk_devt(rq->rq_disk) : 0;
+		__entry->sector    = blk_pc_request(rq) ? 0 : rq->hard_sector;
+		__entry->nr_sector = blk_pc_request(rq) ?
+						0 : rq->hard_nr_sectors;
+		__entry->errors    = rq->errors;
+
+		blk_fill_rwbs_rq(__entry->rwbs, rq);
+		blk_dump_cmd(__fetch_str(cmd), rq);
+	),
+
+	TP_printk("%d,%d %s (%s) %llu + %u [%d]",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->rwbs, __get_str(cmd),
+		  __entry->sector, __entry->nr_sector, __entry->errors)
+);
+TRACE_EVENT(block_bio_bounce,
+
+	TP_PROTO(struct request_queue *q, struct bio *bio),
+
+	TP_ARGS(q, bio),
+
+	TP_STRUCT__entry(
+		__field( dev_t,		dev			)
+		__field( sector_t,	sector			)
+		__field( unsigned int,	nr_sector		)
+		__array( char,		rwbs,	6		)
+		__array( char,		comm,	TASK_COMM_LEN	)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= bio->bi_bdev->bd_dev;
+		__entry->sector		= bio->bi_sector;
+		__entry->nr_sector	= bio->bi_size >> 9;
+		blk_fill_rwbs(__entry->rwbs, bio->bi_rw, bio->bi_size);
+		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+	),
+
+	TP_printk("%d,%d %s %llu + %u [%s]",
+		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,
+		  __entry->sector, __entry->nr_sector, __entry->comm)
+);
+
+TRACE_EVENT(block_bio_complete,
+
+	TP_PROTO(struct request_queue *q, struct bio *bio),
+
+	TP_ARGS(q, bio),
+
+	TP_STRUCT__entry(
+		__field( dev_t,		dev		)
+		__field( sector_t,	sector		)
+		__field( unsigned,	nr_sector	)
+		__field( int,		error		)
+		__array( char,		rwbs,	6	)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= bio->bi_bdev->bd_dev;
+		__entry->sector		= bio->bi_sector;
+		__entry->nr_sector	= bio->bi_size >> 9;
+		blk_fill_rwbs(__entry->rwbs, bio->bi_rw, bio->bi_size);
+	),
+
+	TP_printk("%d,%d %s %llu + %u [%d]",
+		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,
+		  __entry->sector, __entry->nr_sector, __entry->error)
+);
+
+TRACE_EVENT(block_bio_backmerge,
+
+	TP_PROTO(struct request_queue *q, struct bio *bio),
+
+	TP_ARGS(q, bio),
+
+	TP_STRUCT__entry(
+		__field( dev_t,		dev			)
+		__field( sector_t,	sector			)
+		__field( unsigned int,	nr_sector		)
+		__array( char,		rwbs,	6		)
+		__array( char,		comm,	TASK_COMM_LEN	)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= bio->bi_bdev->bd_dev;
+		__entry->sector		= bio->bi_sector;
+		__entry->nr_sector	= bio->bi_size >> 9;
+		blk_fill_rwbs(__entry->rwbs, bio->bi_rw, bio->bi_size);
+		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+	),
+
+	TP_printk("%d,%d %s %llu + %u [%s]",
+		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,
+		  __entry->sector, __entry->nr_sector, __entry->comm)
+);
+
+TRACE_EVENT(block_bio_frontmerge,
+
+	TP_PROTO(struct request_queue *q, struct bio *bio),
+
+	TP_ARGS(q, bio),
+
+	TP_STRUCT__entry(
+		__field( dev_t,		dev			)
+		__field( sector_t,	sector			)
+		__field( unsigned,	nr_sector		)
+		__array( char,		rwbs,	6		)
+		__array( char,		comm,	TASK_COMM_LEN	)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= bio->bi_bdev->bd_dev;
+		__entry->sector		= bio->bi_sector;
+		__entry->nr_sector	= bio->bi_size >> 9;
+		blk_fill_rwbs(__entry->rwbs, bio->bi_rw, bio->bi_size);
+		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+	),
+
+	TP_printk("%d,%d %s %llu + %u [%s]",
+		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,
+		  __entry->sector, __entry->nr_sector, __entry->comm)
+);
+
+TRACE_EVENT(block_bio_queue,
+
+	TP_PROTO(struct request_queue *q, struct bio *bio),
+
+	TP_ARGS(q, bio),
+
+	TP_STRUCT__entry(
+		__field( dev_t,		dev			)
+		__field( sector_t,	sector			)
+		__field( unsigned int,	nr_sector		)
+		__array( char,		rwbs,	6		)
+		__array( char,		comm,	TASK_COMM_LEN	)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= bio->bi_bdev->bd_dev;
+		__entry->sector		= bio->bi_sector;
+		__entry->nr_sector	= bio->bi_size >> 9;
+		blk_fill_rwbs(__entry->rwbs, bio->bi_rw, bio->bi_size);
+		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+	),
+
+	TP_printk("%d,%d %s %llu + %u [%s]",
+		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,
+		  __entry->sector, __entry->nr_sector, __entry->comm)
+);
+
+TRACE_EVENT(block_getrq,
+
+	TP_PROTO(struct request_queue *q, struct bio *bio, int rw),
+
+	TP_ARGS(q, bio, rw),
+
+	TP_STRUCT__entry(
+		__field( dev_t,		dev			)
+		__field( sector_t,	sector			)
+		__field( unsigned int,	nr_sector		)
+		__array( char,		rwbs,	6		)
+		__array( char,		comm,	TASK_COMM_LEN	)
+        ),
+
+	TP_fast_assign(
+		__entry->dev		= bio ? bio->bi_bdev->bd_dev : 0;
+		__entry->sector		= bio ? bio->bi_sector : 0;
+		__entry->nr_sector	= bio ? bio->bi_size >> 9 : 0;
+		blk_fill_rwbs(__entry->rwbs,
+			      bio ? bio->bi_rw : 0, __entry->nr_sector);
+		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+        ),
+
+	TP_printk("%d,%d %s %llu + %u [%s]",
+		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,
+		  __entry->sector, __entry->nr_sector, __entry->comm)
+);
+
+TRACE_EVENT(block_sleeprq,
+
+	TP_PROTO(struct request_queue *q, struct bio *bio, int rw),
+
+	TP_ARGS(q, bio, rw),
+
+	TP_STRUCT__entry(
+		__field( dev_t,		dev			)
+		__field( sector_t,	sector			)
+		__field( unsigned int,	nr_sector		)
+		__array( char,		rwbs,	6		)
+		__array( char,		comm,	TASK_COMM_LEN	)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= bio ? bio->bi_bdev->bd_dev : 0;
+		__entry->sector		= bio ? bio->bi_sector : 0;
+		__entry->nr_sector	= bio ? bio->bi_size >> 9 : 0;
+		blk_fill_rwbs(__entry->rwbs,
+			    bio ? bio->bi_rw : 0, __entry->nr_sector);
+		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+	),
+
+	TP_printk("%d,%d %s %llu + %u [%s]",
+		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,
+		  __entry->sector, __entry->nr_sector, __entry->comm)
+);
+
+TRACE_EVENT(block_plug,
+
+	TP_PROTO(struct request_queue *q),
+
+	TP_ARGS(q),
+
+	TP_STRUCT__entry(
+		__array( char,		comm,	TASK_COMM_LEN	)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+	),
+
+	TP_printk("[%s]", __entry->comm)
+);
+
+TRACE_EVENT(block_unplug_timer,
+
+	TP_PROTO(struct request_queue *q),
+
+	TP_ARGS(q),
+
+	TP_STRUCT__entry(
+		__field( int,		nr_rq			)
+		__array( char,		comm,	TASK_COMM_LEN	)
+	),
+
+	TP_fast_assign(
+		__entry->nr_rq	= q->rq.count[READ] + q->rq.count[WRITE];
+		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+	),
+
+	TP_printk("[%s] %d", __entry->comm, __entry->nr_rq)
+);
+
+TRACE_EVENT(block_unplug_io,
+
+	TP_PROTO(struct request_queue *q),
+
+	TP_ARGS(q),
+
+	TP_STRUCT__entry(
+		__field( int,		nr_rq			)
+		__array( char,		comm,	TASK_COMM_LEN	)
+	),
+
+	TP_fast_assign(
+		__entry->nr_rq	= q->rq.count[READ] + q->rq.count[WRITE];
+		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+	),
+
+	TP_printk("[%s] %d", __entry->comm, __entry->nr_rq)
+);
+
+TRACE_EVENT(block_split,
+
+	TP_PROTO(struct request_queue *q, struct bio *bio,
+		 unsigned int new_sector),
+
+	TP_ARGS(q, bio, new_sector),
+
+	TP_STRUCT__entry(
+		__field( dev_t,		dev				)
+		__field( sector_t,	sector				)
+		__field( sector_t,	new_sector			)
+		__array( char,		rwbs,		6		)
+		__array( char,		comm,		TASK_COMM_LEN	)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= bio->bi_bdev->bd_dev;
+		__entry->sector		= bio->bi_sector;
+		__entry->new_sector	= new_sector;
+		blk_fill_rwbs(__entry->rwbs, bio->bi_rw, bio->bi_size);
+		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+	),
+
+	TP_printk("%d,%d %s %llu / %llu [%s]",
+		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,
+		  __entry->sector, __entry->new_sector, __entry->comm)
+);
+
+TRACE_EVENT(block_remap,
+
+	TP_PROTO(struct request_queue *q, struct bio *bio, dev_t dev,
+		 sector_t from),
+
+	TP_ARGS(q, bio, dev, from),
+
+	TP_STRUCT__entry(
+		__field( dev_t,		dev		)
+		__field( sector_t,	sector		)
+		__field( unsigned int,	nr_sector	)
+		__field( dev_t,		old_dev		)
+		__field( sector_t,	old_sector	)
+		__array( char,		rwbs,	6	)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= bio->bi_bdev->bd_dev;
+		__entry->sector		= bio->bi_sector;
+		__entry->nr_sector	= bio->bi_size >> 9;
+		__entry->old_dev	= dev;
+		__entry->old_sector	= from;
+		blk_fill_rwbs(__entry->rwbs, bio->bi_rw, bio->bi_size);
+	),
+
+	TP_printk("%d,%d %s %llu + %u <- (%d,%d) %llu",
+		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,
+		  __entry->sector, __entry->nr_sector,
+		  MAJOR(__entry->old_dev), MINOR(__entry->old_dev),
+		  __entry->old_sector)
+);
+
+#endif /* _TRACE_BLOCK_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
+
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 848e5ce..e452519 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -45,7 +45,10 @@ obj-$(CONFIG_HW_BRANCH_TRACER) += trace_hw_branches.o
 obj-$(CONFIG_POWER_TRACER) += trace_power.o
 obj-$(CONFIG_KMEMTRACE) += kmemtrace.o
 obj-$(CONFIG_WORKQUEUE_TRACER) += trace_workqueue.o
-obj-$(CONFIG_BLK_DEV_IO_TRACE)	+= blktrace.o
+obj-$(CONFIG_BLK_DEV_IO_TRACE) += blktrace.o
+ifeq ($(CONFIG_BLOCK),y)
+obj-$(CONFIG_EVENT_TRACING) += blktrace.o
+endif
 obj-$(CONFIG_EVENT_TRACING) += trace_events.o
 obj-$(CONFIG_EVENT_TRACING) += trace_export.o
 obj-$(CONFIG_FTRACE_SYSCALLS) += trace_syscalls.o
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index e3abf55..7bd6a98 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -23,10 +23,14 @@
 #include <linux/mutex.h>
 #include <linux/debugfs.h>
 #include <linux/time.h>
-#include <trace/block.h>
 #include <linux/uaccess.h>
+
+#include <trace/events/block.h>
+
 #include "trace_output.h"
 
+#ifdef CONFIG_BLK_DEV_IO_TRACE
+
 static unsigned int blktrace_seq __read_mostly = 1;
 
 static struct trace_array *blk_tr;
@@ -1658,3 +1662,75 @@ int blk_trace_init_sysfs(struct device *dev)
 	return sysfs_create_group(&dev->kobj, &blk_trace_attr_group);
 }
 
+#endif /* CONFIG_BLK_DEV_IO_TRACE */
+
+#ifdef CONFIG_EVENT_TRACING
+
+void blk_dump_cmd(char *buf, struct request *rq)
+{
+	int i, end;
+	int len = rq->cmd_len;
+	unsigned char *cmd = rq->cmd;
+
+	if (!blk_pc_request(rq)) {
+		buf[0] = '\0';
+		return;
+	}
+
+	for (end = len - 1; end >= 0; end--)
+		if (cmd[end])
+			break;
+	end++;
+
+	for (i = 0; i < len; i++) {
+		buf += sprintf(buf, "%s%02x", i == 0 ? "" : " ", cmd[i]);
+		if (i == end && end != len - 1) {
+			sprintf(buf, " ..");
+			break;
+		}
+	}
+}
+
+void blk_fill_rwbs(char *rwbs, u32 rw, int bytes)
+{
+	int i = 0;
+
+	if (rw & WRITE)
+		rwbs[i++] = 'W';
+	else if (rw & 1 << BIO_RW_DISCARD)
+		rwbs[i++] = 'D';
+	else if (bytes)
+		rwbs[i++] = 'R';
+	else
+		rwbs[i++] = 'N';
+
+	if (rw & 1 << BIO_RW_AHEAD)
+		rwbs[i++] = 'A';
+	if (rw & 1 << BIO_RW_BARRIER)
+		rwbs[i++] = 'B';
+	if (rw & 1 << BIO_RW_SYNCIO)
+		rwbs[i++] = 'S';
+	if (rw & 1 << BIO_RW_META)
+		rwbs[i++] = 'M';
+
+	rwbs[i] = '\0';
+}
+
+void blk_fill_rwbs_rq(char *rwbs, struct request *rq)
+{
+	int rw = rq->cmd_flags & 0x03;
+	int bytes;
+
+	if (blk_discard_rq(rq))
+		rw |= (1 << BIO_RW_DISCARD);
+
+	if (blk_pc_request(rq))
+		bytes = rq->data_len;
+	else
+		bytes = rq->hard_nr_sectors << 9;
+
+	blk_fill_rwbs(rwbs, rw, bytes);
+}
+
+#endif /* CONFIG_EVENT_TRACING */
+
diff --git a/mm/bounce.c b/mm/bounce.c
index e590272..65f5e17 100644
--- a/mm/bounce.c
+++ b/mm/bounce.c
@@ -14,16 +14,15 @@
 #include <linux/hash.h>
 #include <linux/highmem.h>
 #include <linux/blktrace_api.h>
-#include <trace/block.h>
 #include <asm/tlbflush.h>
 
+#include <trace/events/block.h>
+
 #define POOL_SIZE	64
 #define ISA_POOL_SIZE	16
 
 static mempool_t *page_pool, *isa_page_pool;
 
-DEFINE_TRACE(block_bio_bounce);
-
 #ifdef CONFIG_HIGHMEM
 static __init int init_emergency_pool(void)
 {
-- 
1.5.4.rc3


