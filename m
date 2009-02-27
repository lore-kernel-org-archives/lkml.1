Return-Path: <linux-kernel-owner+w=401wt.eu-S1756806AbZB0JCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806AbZB0JCp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 04:02:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756096AbZB0JB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 04:01:28 -0500
Received: from rv-out-0506.google.com ([209.85.198.225]:56027 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263AbZB0JB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 04:01:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=gJs07kKGNcDWDbtNe69+9KvrajhA9KzL9Sqm+R8eV3ChwhAfheozmnQw1n6r14HsJT
         8hPgvWyv6aXcP1Uefpvps+6gvTC7KyeZnprOMwc8vYPbj5/MEWMaODYeJDvRT2bLhxlG
         P4oJY9uvGXcW4kfIaa39vBU0p+sT3Kna2MlbU=
Subject: [PATCH 3/4] zedtrace: use block tracepoints
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 27 Feb 2009 03:01:01 -0600
Message-Id: <1235725261.8512.89.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the block tracepoints.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>

---
 kernel/trace/trace_binary/Makefile    |    2 +-
 kernel/trace/trace_binary/zed.c       |    7 +
 kernel/trace/trace_binary/zed.h       |   18 ++
 kernel/trace/trace_binary/zed_block.c |  516 +++++++++++++++++++++++++++++++++
 kernel/trace/trace_binary/zed_block.h |  172 +++++++++++
 5 files changed, 714 insertions(+), 1 deletions(-)
 create mode 100644 kernel/trace/trace_binary/zed_block.c
 create mode 100644 kernel/trace/trace_binary/zed_block.h

diff --git a/kernel/trace/trace_binary/Makefile b/kernel/trace/trace_binary/Makefile
index 26b3c8e..89fceba 100644
--- a/kernel/trace/trace_binary/Makefile
+++ b/kernel/trace/trace_binary/Makefile
@@ -1,3 +1,3 @@
 obj-$(CONFIG_ZEDTRACE) += zedtrace.o
 
-zedtrace-objs := zed.o zed_filter.o zed_sched.o
+zedtrace-objs := zed.o zed_filter.o zed_sched.o zed_block.o
diff --git a/kernel/trace/trace_binary/zed.c b/kernel/trace/trace_binary/zed.c
index 13d301e..5fb61dc 100644
--- a/kernel/trace/trace_binary/zed.c
+++ b/kernel/trace/trace_binary/zed.c
@@ -24,6 +24,7 @@
 #include <linux/vmalloc.h>
 #include <linux/debugfs.h>
 #include <trace/sched.h>
+#include <trace/block.h>
 #include "zed.h"
 #include "zed_filter.h"
 
@@ -987,6 +988,10 @@ static int zed_enable_tracepoints(void)
 		printk(KERN_ERR "Couldn't register sched tracepoints.\n");
 		goto fail;
 	}
+	if (zed_enable_block_tracepoints()) {
+		printk(KERN_ERR "Couldn't register block tracepoints.\n");
+		goto fail;
+	}
 	return 0;
 fail:
 	return -1;
@@ -995,11 +1000,13 @@ fail:
 static void zed_disable_tracepoints(void)
 {
 	zed_disable_sched_tracepoints();
+	zed_disable_block_tracepoints();
 }
 
 static void zed_init_subsystems(void)
 {
 	zed_sched_init();
+	zed_block_init();
 }
 
 /**
diff --git a/kernel/trace/trace_binary/zed.h b/kernel/trace/trace_binary/zed.h
index 56a6295..7f86f3b 100644
--- a/kernel/trace/trace_binary/zed.h
+++ b/kernel/trace/trace_binary/zed.h
@@ -56,8 +56,26 @@
 	EVENT(sched, process_wait_trace) sep \
 	EVENT(sched, process_fork_trace) sep \
 	EVENT(sched, signal_send_trace) sep \
+	EVENT(block, rq_abort_trace) sep \
+	EVENT(block, rq_insert_trace) sep \
+	EVENT(block, rq_issue_trace) sep \
+	EVENT(block, rq_requeue_trace) sep \
+	EVENT(block, rq_complete_trace) sep \
+	EVENT(block, bio_bounce_trace) sep \
+	EVENT(block, bio_complete_trace) sep \
+	EVENT(block, bio_backmerge_trace) sep \
+	EVENT(block, bio_frontmerge_trace) sep \
+	EVENT(block, bio_queue_trace) sep \
+	EVENT(block, getrq_trace) sep \
+	EVENT(block, sleeprq_trace) sep	\
+	EVENT(block, plug_trace) sep \
+	EVENT(block, unplug_io_trace) sep \
+	EVENT(block, unplug_timer_trace) sep \
+	EVENT(block, split_trace) sep \
+	EVENT(block, remap_trace) sep \
 
 #include "zed_sched.h"
+#include "zed_block.h"
 
 /* magic or'ed with version, last byte of magic should be 00 */
 #define ZED_TRACE_MAGIC		0x26F82100
diff --git a/kernel/trace/trace_binary/zed_block.c b/kernel/trace/trace_binary/zed_block.c
new file mode 100644
index 0000000..669d777
--- /dev/null
+++ b/kernel/trace/trace_binary/zed_block.c
@@ -0,0 +1,516 @@
+/*
+ * zedtrace "block" subsys event definitions
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright (C) 2008-2009 - Tom Zanussi (tzanussi@gmail.com)
+ */
+
+#include <linux/module.h>
+#include <linux/list.h>
+#include <linux/jhash.h>
+#include <linux/vmalloc.h>
+#include <linux/debugfs.h>
+#include <trace/sched.h>
+#include <trace/block.h>
+#include "zed.h"
+
+#include <linux/kernel.h>
+#include <linux/blkdev.h>
+#include <linux/blktrace_api.h>
+
+EVENTS(EXTERN_TRACE_FLAG, SEMICOLON);
+
+/*
+ * The current block tracepoints are pretty useless for anything but
+ * blktrace, so we need to get some stuff from blktrace.c to make them
+ * minimally useful.
+ */
+
+static int blk_rw(struct request *rq)
+{
+	int rw = rq->cmd_flags & 0x03;
+
+	if (blk_discard_rq(rq))
+		rw |= (1 << BIO_RW_DISCARD);
+
+	return rw;
+}
+
+/*
+ * Data direction bit lookup
+ */
+static u32 ddir_act[2] __read_mostly = { BLK_TC_ACT(BLK_TC_READ),
+					 BLK_TC_ACT(BLK_TC_WRITE) };
+
+/* The ilog2() calls fall out because they're constant */
+#define MASK_TC_BIT(rw, __name) ((rw & (1 << BIO_RW_ ## __name)) << \
+	  (ilog2(BLK_TC_ ## __name) + BLK_TC_SHIFT - BIO_RW_ ## __name))
+
+static int blk_what(struct request *rq, int rw, u32 what)
+{
+	if (blk_pc_request(rq))
+		what |= BLK_TC_ACT(BLK_TC_PC);
+	else
+		what |= BLK_TC_ACT(BLK_TC_FS);
+
+	what |= ddir_act[rw & WRITE];
+	what |= MASK_TC_BIT(rw, BARRIER);
+	what |= MASK_TC_BIT(rw, SYNCIO);
+	what |= MASK_TC_BIT(rw, AHEAD);
+	what |= MASK_TC_BIT(rw, META);
+	what |= MASK_TC_BIT(rw, DISCARD);
+
+	return what;
+}
+
+ZED_TRACEPOINT_ENTER_VAR(block_rq_abort,
+	     TPPROTO(struct request_queue *q, struct request *rq))
+{
+	int rw = blk_rw(rq);
+	u32 what = blk_what(rq, rw, BLK_TA_ABORT);
+	int pdu_len = 0;
+
+	if (blk_pc_request(rq))
+		pdu_len = sizeof(rq->cmd);
+
+	ZED_RESERVE_VAR(block_rq_abort, pdu_len);
+
+	if (rq->rq_disk)
+		zed_event->dev = disk_devt(rq->rq_disk);
+	else
+		zed_event->dev = 0;
+	zed_event->what = what;
+	zed_event->rw = rw;
+	zed_event->errors = rq->errors;
+	if (blk_pc_request(rq)) {
+		zed_event->sector = 0;
+		zed_event->bytes = rq->data_len;
+		zed_event->pdu_len = pdu_len;
+		memcpy(zed_event->pdu, rq->cmd, pdu_len);
+	} else {
+		zed_event->sector = rq->hard_sector;
+		zed_event->bytes = rq->hard_nr_sectors << 9;
+		zed_event->pdu_len = 0;
+	}
+}
+ZED_TRACEPOINT_EXIT(block_rq_abort)
+
+ZED_TRACEPOINT_ENTER_VAR(block_rq_insert,
+	     TPPROTO(struct request_queue *q, struct request *rq))
+{
+	int rw = blk_rw(rq);
+	u32 what = blk_what(rq, rw, BLK_TA_INSERT);
+	int pdu_len = 0;
+
+	if (blk_pc_request(rq))
+		pdu_len = sizeof(rq->cmd);
+
+	ZED_RESERVE_VAR(block_rq_insert, pdu_len);
+
+	if (rq->rq_disk)
+		zed_event->dev = disk_devt(rq->rq_disk);
+	else
+		zed_event->dev = 0;
+	zed_event->what = what;
+	zed_event->rw = rw;
+	zed_event->errors = rq->errors;
+	if (blk_pc_request(rq)) {
+		zed_event->sector = 0;
+		zed_event->bytes = rq->data_len;
+		zed_event->pdu_len = pdu_len;
+		memcpy(zed_event->pdu, rq->cmd, pdu_len);
+	} else {
+		zed_event->sector = rq->hard_sector;
+		zed_event->bytes = rq->hard_nr_sectors << 9;
+		zed_event->pdu_len = 0;
+	}
+}
+ZED_TRACEPOINT_EXIT(block_rq_insert)
+
+ZED_TRACEPOINT_ENTER_VAR(block_rq_issue,
+	     TPPROTO(struct request_queue *q, struct request *rq))
+{
+	int rw = blk_rw(rq);
+	u32 what = blk_what(rq, rw, BLK_TA_ISSUE);
+	int pdu_len = 0;
+
+	if (blk_pc_request(rq))
+		pdu_len = sizeof(rq->cmd);
+
+	ZED_RESERVE_VAR(block_rq_issue, pdu_len);
+
+	if (rq->rq_disk)
+		zed_event->dev = disk_devt(rq->rq_disk);
+	else
+		zed_event->dev = 0;
+	zed_event->what = what;
+	zed_event->rw = rw;
+	zed_event->errors = rq->errors;
+	if (blk_pc_request(rq)) {
+		zed_event->sector = 0;
+		zed_event->bytes = rq->data_len;
+		zed_event->pdu_len = pdu_len;
+		memcpy(zed_event->pdu, rq->cmd, pdu_len);
+	} else {
+		zed_event->sector = rq->hard_sector;
+		zed_event->bytes = rq->hard_nr_sectors << 9;
+		zed_event->pdu_len = 0;
+	}
+}
+ZED_TRACEPOINT_EXIT(block_rq_issue)
+
+ZED_TRACEPOINT_ENTER_VAR(block_rq_requeue,
+	     TPPROTO(struct request_queue *q, struct request *rq))
+{
+	int rw = blk_rw(rq);
+	u32 what = blk_what(rq, rw, BLK_TA_REQUEUE);
+	int pdu_len = 0;
+
+	if (blk_pc_request(rq))
+		pdu_len = sizeof(rq->cmd);
+
+	ZED_RESERVE_VAR(block_rq_requeue, pdu_len);
+
+	if (rq->rq_disk)
+		zed_event->dev = disk_devt(rq->rq_disk);
+	else
+		zed_event->dev = 0;
+	zed_event->what = what;
+	zed_event->rw = rw;
+	zed_event->errors = rq->errors;
+	if (blk_pc_request(rq)) {
+		zed_event->sector = 0;
+		zed_event->bytes = rq->data_len;
+		zed_event->pdu_len = pdu_len;
+		memcpy(zed_event->pdu, rq->cmd, pdu_len);
+	} else {
+		zed_event->sector = rq->hard_sector;
+		zed_event->bytes = rq->hard_nr_sectors << 9;
+		zed_event->pdu_len = 0;
+	}
+}
+ZED_TRACEPOINT_EXIT(block_rq_requeue)
+
+ZED_TRACEPOINT_ENTER_VAR(block_rq_complete,
+	     TPPROTO(struct request_queue *q, struct request *rq))
+{
+	int rw = blk_rw(rq);
+	u32 what = blk_what(rq, rw, BLK_TA_COMPLETE);
+	int pdu_len = 0;
+
+	if (blk_pc_request(rq))
+		pdu_len = sizeof(rq->cmd);
+
+	ZED_RESERVE_VAR(block_rq_complete, pdu_len);
+
+	if (rq->rq_disk)
+		zed_event->dev = disk_devt(rq->rq_disk);
+	else
+		zed_event->dev = 0;
+	zed_event->what = what;
+	zed_event->rw = rw;
+	zed_event->errors = rq->errors;
+	if (blk_pc_request(rq)) {
+		zed_event->sector = 0;
+		zed_event->bytes = rq->data_len;
+		zed_event->pdu_len = pdu_len;
+		memcpy(zed_event->pdu, rq->cmd, pdu_len);
+	} else {
+		zed_event->sector = rq->hard_sector;
+		zed_event->bytes = rq->hard_nr_sectors << 9;
+		zed_event->pdu_len = 0;
+	}
+}
+ZED_TRACEPOINT_EXIT(block_rq_complete)
+
+ZED_TRACEPOINT_ENTER(block_bio_bounce,
+	     TPPROTO(struct request_queue *q, struct bio *bio))
+{
+	zed_event->dev = q->backing_dev_info.dev->devt;
+	zed_event->what = BLK_TA_BOUNCE;
+	zed_event->rw = bio->bi_rw;
+	zed_event->errors = !bio_flagged(bio, BIO_UPTODATE);
+	zed_event->sector = bio->bi_sector;
+	zed_event->bytes = bio->bi_size;
+}
+ZED_TRACEPOINT_EXIT(block_bio_bounce)
+
+ZED_TRACEPOINT_ENTER(block_bio_complete,
+	     TPPROTO(struct request_queue *q, struct bio *bio))
+{
+	zed_event->dev = q->backing_dev_info.dev->devt;
+	zed_event->what = BLK_TA_COMPLETE;
+	zed_event->rw = bio->bi_rw;
+	zed_event->errors = !bio_flagged(bio, BIO_UPTODATE);
+	zed_event->sector = bio->bi_sector;
+	zed_event->bytes = bio->bi_size;
+}
+ZED_TRACEPOINT_EXIT(block_bio_complete)
+
+ZED_TRACEPOINT_ENTER(block_bio_backmerge,
+	     TPPROTO(struct request_queue *q, struct bio *bio))
+{
+	zed_event->dev = q->backing_dev_info.dev->devt;
+	zed_event->what = BLK_TA_BACKMERGE;
+	zed_event->rw = bio->bi_rw;
+	zed_event->errors = !bio_flagged(bio, BIO_UPTODATE);
+	zed_event->sector = bio->bi_sector;
+	zed_event->bytes = bio->bi_size;
+}
+ZED_TRACEPOINT_EXIT(block_bio_backmerge)
+
+ZED_TRACEPOINT_ENTER(block_bio_frontmerge,
+	     TPPROTO(struct request_queue *q, struct bio *bio))
+{
+	zed_event->dev = q->backing_dev_info.dev->devt;
+	zed_event->what = BLK_TA_FRONTMERGE;
+	zed_event->rw = bio->bi_rw;
+	zed_event->errors = !bio_flagged(bio, BIO_UPTODATE);
+	zed_event->sector = bio->bi_sector;
+	zed_event->bytes = bio->bi_size;
+}
+ZED_TRACEPOINT_EXIT(block_bio_frontmerge)
+
+ZED_TRACEPOINT_ENTER(block_bio_queue,
+	     TPPROTO(struct request_queue *q, struct bio *bio))
+{
+	zed_event->dev = q->backing_dev_info.dev->devt;
+	zed_event->what = BLK_TA_QUEUE;
+	zed_event->rw = bio->bi_rw;
+	zed_event->errors = !bio_flagged(bio, BIO_UPTODATE);
+	zed_event->sector = bio->bi_sector;
+	zed_event->bytes = bio->bi_size;
+}
+ZED_TRACEPOINT_EXIT(block_bio_queue)
+
+ZED_TRACEPOINT_ENTER(block_getrq,
+	     TPPROTO(struct request_queue *q, struct bio *bio, int rw))
+{
+	zed_event->dev = q->backing_dev_info.dev->devt;
+	zed_event->what = BLK_TA_GETRQ;
+	if (bio) {
+		zed_event->rw = bio->bi_rw;
+		zed_event->errors = !bio_flagged(bio, BIO_UPTODATE);
+		zed_event->sector = bio->bi_sector;
+		zed_event->bytes = bio->bi_size;
+	} else {
+		zed_event->rw = rw;
+		zed_event->errors = 0;
+		zed_event->sector = 0;
+		zed_event->bytes = 0;
+	}
+}
+ZED_TRACEPOINT_EXIT(block_getrq)
+
+ZED_TRACEPOINT_ENTER(block_sleeprq,
+	     TPPROTO(struct request_queue *q, struct bio *bio, int rw))
+{
+	zed_event->dev = q->backing_dev_info.dev->devt;
+	zed_event->what = BLK_TA_SLEEPRQ;
+	if (bio) {
+		zed_event->rw = bio->bi_rw;
+		zed_event->errors = !bio_flagged(bio, BIO_UPTODATE);
+		zed_event->sector = bio->bi_sector;
+		zed_event->bytes = bio->bi_size;
+	} else {
+		zed_event->rw = rw;
+		zed_event->errors = 0;
+		zed_event->sector = 0;
+		zed_event->bytes = 0;
+	}
+}
+ZED_TRACEPOINT_EXIT(block_sleeprq)
+
+ZED_TRACEPOINT_ENTER(block_plug,
+	     TPPROTO(struct request_queue *q))
+{
+	zed_event->dev = q->backing_dev_info.dev->devt;
+	zed_event->what = BLK_TA_PLUG;
+}
+ZED_TRACEPOINT_EXIT(block_plug)
+
+ZED_TRACEPOINT_ENTER_VAR(block_unplug_io,
+	     TPPROTO(struct request_queue *q))
+{
+	unsigned int pdu = q->rq.count[READ] + q->rq.count[WRITE];
+	__be64 rpdu = cpu_to_be64(pdu);
+
+	ZED_RESERVE_VAR(block_unplug_io, sizeof(rpdu));
+
+	zed_event->dev = q->backing_dev_info.dev->devt;
+	zed_event->what = BLK_TA_UNPLUG_IO;
+	zed_event->pdu_len = sizeof(rpdu);
+	memcpy(zed_event->pdu, &rpdu, sizeof(rpdu));
+}
+ZED_TRACEPOINT_EXIT(block_unplug_io)
+
+ZED_TRACEPOINT_ENTER_VAR(block_unplug_timer,
+	     TPPROTO(struct request_queue *q))
+{
+	unsigned int pdu = q->rq.count[READ] + q->rq.count[WRITE];
+	__be64 rpdu = cpu_to_be64(pdu);
+
+	ZED_RESERVE_VAR(block_unplug_timer, sizeof(rpdu));
+
+	zed_event->dev = q->backing_dev_info.dev->devt;
+	zed_event->what = BLK_TA_UNPLUG_TIMER;
+	zed_event->pdu_len = sizeof(rpdu);
+	memcpy(zed_event->pdu, &rpdu, sizeof(rpdu));
+}
+ZED_TRACEPOINT_EXIT(block_unplug_timer)
+
+ZED_TRACEPOINT_ENTER_VAR(block_split,
+	 TPPROTO(struct request_queue *q, struct bio *bio, unsigned int pdu))
+{
+	__be64 rpdu = cpu_to_be64(pdu);
+
+	ZED_RESERVE_VAR(block_split, sizeof(rpdu));
+
+	zed_event->dev = q->backing_dev_info.dev->devt;
+	zed_event->what = BLK_TA_SPLIT;
+	zed_event->rw = bio->bi_rw;
+	zed_event->errors = !bio_flagged(bio, BIO_UPTODATE);
+	zed_event->sector = bio->bi_sector;
+	zed_event->bytes = bio->bi_size;
+	zed_event->pdu_len = sizeof(rpdu);
+	memcpy(zed_event->pdu, &rpdu, sizeof(rpdu));
+}
+ZED_TRACEPOINT_EXIT(block_split)
+
+ZED_TRACEPOINT_ENTER_VAR(block_remap,
+	 TPPROTO(struct request_queue *q, struct bio *bio, dev_t dev,
+		sector_t from, sector_t to))
+{
+	struct blk_io_trace_remap r;
+
+	r.device = cpu_to_be32(dev);
+	r.device_from = cpu_to_be32(bio->bi_bdev->bd_dev);
+	r.sector = cpu_to_be64(to);
+
+	ZED_RESERVE_VAR(block_remap, sizeof(r));
+
+	zed_event->dev = dev;
+	zed_event->what = BLK_TA_REMAP;
+	zed_event->rw = bio->bi_rw;
+	zed_event->errors = !bio_flagged(bio, BIO_UPTODATE);
+	zed_event->sector = from;
+	zed_event->bytes = bio->bi_size;
+	zed_event->pdu_len = sizeof(r);
+	memcpy(zed_event->pdu, &r, sizeof(r));
+}
+ZED_TRACEPOINT_EXIT(block_remap)
+
+int zed_enable_block_tracepoints(void)
+{
+	if (register_trace_block_rq_abort(block_rq_abort_tracepoint)) {
+		printk(KERN_ERR "Couldn't register block_rq_abort tracepoint.\n");
+		goto fail;
+	}
+	if (register_trace_block_rq_insert(block_rq_insert_tracepoint)) {
+		printk(KERN_ERR "Couldn't register block_rq_insert tracepoint.\n");
+		goto fail;
+	}
+	if (register_trace_block_rq_issue(block_rq_issue_tracepoint)) {
+		printk(KERN_ERR "Couldn't register block_rq_issue tracepoint.\n");
+		goto fail;
+	}
+	if (register_trace_block_rq_requeue(block_rq_requeue_tracepoint)) {
+		printk(KERN_ERR "Couldn't register block_rq_requeue tracepoint.\n");
+		goto fail;
+	}
+	if (register_trace_block_rq_complete(block_rq_complete_tracepoint)) {
+		printk(KERN_ERR "Couldn't register block_rq_complete tracepoint.\n");
+		goto fail;
+	}
+	if (register_trace_block_bio_bounce(block_bio_bounce_tracepoint)) {
+		printk(KERN_ERR "Couldn't register block_bio_bounce tracepoint.\n");
+		goto fail;
+	}
+	if (register_trace_block_bio_complete(block_bio_complete_tracepoint)) {
+		printk(KERN_ERR "Couldn't register block_bio_complete tracepoint.\n");
+		goto fail;
+	}
+	if (register_trace_block_bio_backmerge(block_bio_backmerge_tracepoint)) {
+		printk(KERN_ERR "Couldn't register block_bio_backmerge tracepoint.\n");
+		goto fail;
+	}
+	if (register_trace_block_bio_frontmerge(block_bio_frontmerge_tracepoint)) {
+		printk(KERN_ERR "Couldn't register block_bio_frontmerge tracepoint.\n");
+		goto fail;
+	}
+	if (register_trace_block_bio_queue(block_bio_queue_tracepoint)) {
+		printk(KERN_ERR "Couldn't register block_bio_queue tracepoint.\n");
+		goto fail;
+	}
+	if (register_trace_block_getrq(block_getrq_tracepoint)) {
+		printk(KERN_ERR "Couldn't register block_getrq tracepoint.\n");
+		goto fail;
+	}
+	if (register_trace_block_sleeprq(block_sleeprq_tracepoint)) {
+		printk(KERN_ERR "Couldn't register block_sleeprq tracepoint.\n");
+		goto fail;
+	}
+	if (register_trace_block_plug(block_plug_tracepoint)) {
+		printk(KERN_ERR "Couldn't register block_plug tracepoint.\n");
+		goto fail;
+	}
+	if (register_trace_block_unplug_io(block_unplug_io_tracepoint)) {
+		printk(KERN_ERR "Couldn't register block_unplug_io tracepoint.\n");
+		goto fail;
+	}
+	if (register_trace_block_unplug_timer(block_unplug_timer_tracepoint)) {
+		printk(KERN_ERR "Couldn't register block_unplug_timer tracepoint.\n");
+		goto fail;
+	}
+	if (register_trace_block_split(block_split_tracepoint)) {
+		printk(KERN_ERR "Couldn't register block_split tracepoint.\n");
+		goto fail;
+	}
+	if (register_trace_block_remap(block_remap_tracepoint)) {
+		printk(KERN_ERR "Couldn't register block_remap tracepoint.\n");
+		goto fail;
+	}
+	return 0;
+fail:
+	return -1;
+}
+
+void zed_disable_block_tracepoints(void)
+{
+	unregister_trace_block_rq_abort(block_rq_abort_tracepoint);
+	unregister_trace_block_rq_insert(block_rq_insert_tracepoint);
+	unregister_trace_block_rq_issue(block_rq_issue_tracepoint);
+	unregister_trace_block_rq_requeue(block_rq_requeue_tracepoint);
+	unregister_trace_block_rq_complete(block_rq_complete_tracepoint);
+	unregister_trace_block_bio_bounce(block_bio_bounce_tracepoint);
+	unregister_trace_block_bio_complete(block_bio_complete_tracepoint);
+	unregister_trace_block_bio_backmerge(block_bio_backmerge_tracepoint);
+	unregister_trace_block_bio_frontmerge(block_bio_frontmerge_tracepoint);
+	unregister_trace_block_bio_queue(block_bio_queue_tracepoint);
+	unregister_trace_block_getrq(block_getrq_tracepoint);
+	unregister_trace_block_sleeprq(block_sleeprq_tracepoint);
+	unregister_trace_block_plug(block_plug_tracepoint);
+	unregister_trace_block_unplug_io(block_unplug_io_tracepoint);
+	unregister_trace_block_unplug_timer(block_unplug_timer_tracepoint);
+	unregister_trace_block_split(block_split_tracepoint);
+	unregister_trace_block_remap(block_remap_tracepoint);
+}
+
+void zed_block_init(void)
+{
+}
+
+
diff --git a/kernel/trace/trace_binary/zed_block.h b/kernel/trace/trace_binary/zed_block.h
new file mode 100644
index 0000000..37c83b7
--- /dev/null
+++ b/kernel/trace/trace_binary/zed_block.h
@@ -0,0 +1,172 @@
+/*
+ * zedtrace "block" subsys event declarations
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright (C) 2008-2009 Tom Zanussi <tzanussi@gmail.com>
+ */
+
+#ifndef _ZED_BLOCK_H
+#define _ZED_BLOCK_H
+
+/* convention: name[0] of u8 = var data, name[0] of char = string */
+
+#define block_rq_abort_trace_fields(subsys, event_name, FIELD)	\
+	FIELD(subsys, event_name, dev, dev_t)	\
+	FIELD(subsys, event_name, what, u32)	\
+	FIELD(subsys, event_name, rw, int)	\
+	FIELD(subsys, event_name, errors, int)	\
+	FIELD(subsys, event_name, sector, sector_t)	\
+	FIELD(subsys, event_name, bytes, int)	\
+	FIELD(subsys, event_name, pdu_len, int)	\
+	FIELD(subsys, event_name, pdu[0], u8)	\
+
+#define block_rq_insert_trace_fields(subsys, event_name, FIELD)	\
+	FIELD(subsys, event_name, dev, dev_t)	\
+	FIELD(subsys, event_name, what, u32)	\
+	FIELD(subsys, event_name, rw, int)	\
+	FIELD(subsys, event_name, errors, int)	\
+	FIELD(subsys, event_name, sector, sector_t)	\
+	FIELD(subsys, event_name, bytes, int)	\
+	FIELD(subsys, event_name, pdu_len, int)	\
+	FIELD(subsys, event_name, pdu[0], u8)	\
+
+#define block_rq_issue_trace_fields(subsys, event_name, FIELD)	\
+	FIELD(subsys, event_name, dev, dev_t)	\
+	FIELD(subsys, event_name, what, u32)	\
+	FIELD(subsys, event_name, rw, int)	\
+	FIELD(subsys, event_name, errors, int)	\
+	FIELD(subsys, event_name, sector, sector_t)	\
+	FIELD(subsys, event_name, bytes, int)	\
+	FIELD(subsys, event_name, pdu_len, int)	\
+	FIELD(subsys, event_name, pdu[0], u8)	\
+
+#define block_rq_requeue_trace_fields(subsys, event_name, FIELD)	\
+	FIELD(subsys, event_name, dev, dev_t)	\
+	FIELD(subsys, event_name, what, u32)	\
+	FIELD(subsys, event_name, rw, int)	\
+	FIELD(subsys, event_name, errors, int)	\
+	FIELD(subsys, event_name, sector, sector_t)	\
+	FIELD(subsys, event_name, bytes, int)	\
+	FIELD(subsys, event_name, pdu_len, int)	\
+	FIELD(subsys, event_name, pdu[0], u8)	\
+
+#define block_rq_complete_trace_fields(subsys, event_name, FIELD)	\
+	FIELD(subsys, event_name, dev, dev_t)	\
+	FIELD(subsys, event_name, what, u32)	\
+	FIELD(subsys, event_name, rw, int)	\
+	FIELD(subsys, event_name, errors, int)	\
+	FIELD(subsys, event_name, sector, sector_t)	\
+	FIELD(subsys, event_name, bytes, int)	\
+	FIELD(subsys, event_name, pdu_len, int)	\
+	FIELD(subsys, event_name, pdu[0], u8)	\
+
+#define block_bio_bounce_trace_fields(subsys, event_name, FIELD)	\
+	FIELD(subsys, event_name, dev, dev_t)	\
+	FIELD(subsys, event_name, what, u32)	\
+	FIELD(subsys, event_name, rw, int)	\
+	FIELD(subsys, event_name, errors, int)	\
+	FIELD(subsys, event_name, sector, sector_t)	\
+	FIELD(subsys, event_name, bytes, int)	\
+
+#define block_bio_complete_trace_fields(subsys, event_name, FIELD)	\
+	FIELD(subsys, event_name, dev, dev_t)			\
+	FIELD(subsys, event_name, what, u32)	\
+	FIELD(subsys, event_name, rw, int)	\
+	FIELD(subsys, event_name, errors, int)	\
+	FIELD(subsys, event_name, sector, sector_t)	\
+	FIELD(subsys, event_name, bytes, int)	\
+
+#define block_bio_backmerge_trace_fields(subsys, event_name, FIELD)	\
+	FIELD(subsys, event_name, dev, dev_t)	\
+	FIELD(subsys, event_name, what, u32)	\
+	FIELD(subsys, event_name, rw, int)	\
+	FIELD(subsys, event_name, errors, int)	\
+	FIELD(subsys, event_name, sector, sector_t)	\
+	FIELD(subsys, event_name, bytes, int)	\
+
+#define block_bio_frontmerge_trace_fields(subsys, event_name, FIELD)	\
+	FIELD(subsys, event_name, dev, dev_t)	\
+	FIELD(subsys, event_name, what, u32)	\
+	FIELD(subsys, event_name, rw, int)	\
+	FIELD(subsys, event_name, errors, int)	\
+	FIELD(subsys, event_name, sector, sector_t)	\
+	FIELD(subsys, event_name, bytes, int)	\
+
+#define block_bio_queue_trace_fields(subsys, event_name, FIELD)	\
+	FIELD(subsys, event_name, dev, dev_t)	\
+	FIELD(subsys, event_name, what, u32)	\
+	FIELD(subsys, event_name, rw, int)	\
+	FIELD(subsys, event_name, errors, int)	\
+	FIELD(subsys, event_name, sector, sector_t)	\
+	FIELD(subsys, event_name, bytes, int)	\
+
+#define block_getrq_trace_fields(subsys, event_name, FIELD)	\
+	FIELD(subsys, event_name, dev, dev_t)	\
+	FIELD(subsys, event_name, what, u32)	\
+	FIELD(subsys, event_name, rw, int)	\
+	FIELD(subsys, event_name, errors, int)	\
+	FIELD(subsys, event_name, sector, sector_t)	\
+	FIELD(subsys, event_name, bytes, int)	\
+
+#define block_sleeprq_trace_fields(subsys, event_name, FIELD)	\
+	FIELD(subsys, event_name, dev, dev_t)	\
+	FIELD(subsys, event_name, what, u32)	\
+	FIELD(subsys, event_name, rw, int)	\
+	FIELD(subsys, event_name, errors, int)	\
+	FIELD(subsys, event_name, sector, sector_t)	\
+	FIELD(subsys, event_name, bytes, int)	\
+
+#define block_plug_trace_fields(subsys, event_name, FIELD)	\
+	FIELD(subsys, event_name, dev, dev_t)	\
+	FIELD(subsys, event_name, what, u32)			\
+
+#define block_unplug_io_trace_fields(subsys, event_name, FIELD)	\
+	FIELD(subsys, event_name, dev, dev_t)	\
+	FIELD(subsys, event_name, what, u32)	\
+	FIELD(subsys, event_name, pdu_len, int)	\
+	FIELD(subsys, event_name, pdu[0], u8)	\
+
+#define block_unplug_timer_trace_fields(subsys, event_name, FIELD)	\
+	FIELD(subsys, event_name, dev, dev_t)	\
+	FIELD(subsys, event_name, what, u32)	\
+	FIELD(subsys, event_name, pdu_len, int)	\
+	FIELD(subsys, event_name, pdu[0], u8)	\
+
+#define block_split_trace_fields(subsys, event_name, FIELD)	\
+	FIELD(subsys, event_name, dev, dev_t)			\
+	FIELD(subsys, event_name, what, u32)			\
+	FIELD(subsys, event_name, rw, int)			\
+	FIELD(subsys, event_name, errors, int)			\
+	FIELD(subsys, event_name, sector, sector_t)		\
+	FIELD(subsys, event_name, bytes, int)			\
+	FIELD(subsys, event_name, pdu_len, int)			\
+	FIELD(subsys, event_name, pdu[0], u8)			\
+
+#define block_remap_trace_fields(subsys, event_name, FIELD)	\
+	FIELD(subsys, event_name, dev, dev_t)			\
+	FIELD(subsys, event_name, what, u32)			\
+	FIELD(subsys, event_name, rw, int)			\
+	FIELD(subsys, event_name, errors, int)			\
+	FIELD(subsys, event_name, sector, sector_t)		\
+	FIELD(subsys, event_name, bytes, int)			\
+	FIELD(subsys, event_name, pdu_len, int)			\
+	FIELD(subsys, event_name, pdu[0], u8)			\
+
+extern void zed_block_init(void);
+extern int zed_enable_block_tracepoints(void);
+extern void zed_disable_block_tracepoints(void);
+
+#endif /* _ZED_BLOCK_H */
-- 
1.5.6.3



