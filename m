Return-Path: <linux-kernel-owner+w=401wt.eu-S1751993AbZD3EiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993AbZD3EiS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 00:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750950AbZD3EiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 00:38:05 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46992 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbZD3EiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 00:38:04 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <srostedt@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH] blktrace: swap arg name "from" and "to" of blk_add_trace_remap
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20090430133627.D217.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Thu, 30 Apr 2009 13:37:59 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Subject: [PATCH] blktrace: swap arg name "from" and "to" of blk_add_trace_remap

Impact: cleanup for improve readability

Currently, blk_add_trace_remap has following prototype.

static void blk_add_trace_remap(struct request_queue *q, struct bio *bio,
				       dev_t dev, sector_t from, sector_t to)

but caller pass "from" secter as 4th arg, "to" sector as 5th arg.

example,
--------------------------------------------------------
static inline void blk_partition_remap(struct bio *bio)
{
	struct block_device *bdev = bio->bi_bdev;

	if (bio_sectors(bio) && bdev != bdev->bd_contains) {
		struct hd_struct *p = bdev->bd_part;

		bio->bi_sector += p->start_sect;
		bio->bi_bdev = bdev->bd_contains;

		trace_block_remap(bdev_get_queue(bio->bi_bdev), bio,
				    bdev->bd_dev, bio->bi_sector,
				    bio->bi_sector - p->start_sect);
	}
}
--------------------------------------------------------

Oh my god, it's reverse order.
Fortunately, print logic reverse again. the twice reversing hide problem.

but, but...
It repeatedly confuse reviewer (include me!).
Then, swapping argment name is better.

this patch doesn't change any behavior and ABI.

Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 include/linux/blktrace_api.h |    2 +-
 kernel/trace/blktrace.c      |   17 ++++++++---------
 2 files changed, 9 insertions(+), 10 deletions(-)

Index: b/include/linux/blktrace_api.h
===================================================================
--- a/include/linux/blktrace_api.h	2009-04-30 13:17:56.000000000 +0900
+++ b/include/linux/blktrace_api.h	2009-04-30 13:18:12.000000000 +0900
@@ -118,7 +118,7 @@ struct blk_io_trace {
 struct blk_io_trace_remap {
 	__be32 device;
 	__be32 device_from;
-	__be64 sector;
+	__be64 sector_from;
 };
 
 enum {
Index: b/kernel/trace/blktrace.c
===================================================================
--- a/kernel/trace/blktrace.c	2009-04-30 13:18:09.000000000 +0900
+++ b/kernel/trace/blktrace.c	2009-04-30 13:18:12.000000000 +0900
@@ -839,7 +839,7 @@ static void blk_add_trace_split(struct r
  *
  **/
 static void blk_add_trace_remap(struct request_queue *q, struct bio *bio,
-				       dev_t dev, sector_t from, sector_t to)
+				       dev_t dev, sector_t to, sector_t from)
 {
 	struct blk_trace *bt = q->blk_trace;
 	struct blk_io_trace_remap r;
@@ -847,11 +847,11 @@ static void blk_add_trace_remap(struct r
 	if (likely(!bt))
 		return;
 
-	r.device = cpu_to_be32(dev);
+	r.device      = cpu_to_be32(dev);
 	r.device_from = cpu_to_be32(bio->bi_bdev->bd_dev);
-	r.sector = cpu_to_be64(to);
+	r.sector_from = cpu_to_be64(from);
 
-	__blk_add_trace(bt, from, bio->bi_size, bio->bi_rw, BLK_TA_REMAP,
+	__blk_add_trace(bt, to, bio->bi_size, bio->bi_rw, BLK_TA_REMAP,
 			!bio_flagged(bio, BIO_UPTODATE), sizeof(r), &r);
 }
 
@@ -1028,11 +1028,10 @@ static void get_pdu_remap(const struct t
 			  struct blk_io_trace_remap *r)
 {
 	const struct blk_io_trace_remap *__r = pdu_start(ent);
-	__u64 sector = __r->sector;
 
-	r->device = be32_to_cpu(__r->device);
-	r->device_from = be32_to_cpu(__r->device_from);
-	r->sector = be64_to_cpu(sector);
+	r->device	= be32_to_cpu(__r->device);
+	r->device_from	= be32_to_cpu(__r->device_from);
+	r->sector_from	= be64_to_cpu(__r->sector_from);
 }
 
 typedef int (blk_log_action_t) (struct trace_iterator *iter, const char *act);
@@ -1154,7 +1153,7 @@ static int blk_log_remap(struct trace_se
 	return trace_seq_printf(s, "%llu + %u <- (%d,%d) %llu\n",
 			       t_sector(ent),
 			       t_sec(ent), MAJOR(r.device), MINOR(r.device),
-			       (unsigned long long)r.sector);
+			       (unsigned long long)r.sector_from);
 }
 
 static int blk_log_plug(struct trace_seq *s, const struct trace_entry *ent)


