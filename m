Return-Path: <linux-kernel-owner+w=401wt.eu-S1764480AbZD3RAJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764480AbZD3RAJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:00:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763705AbZD3Q7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 12:59:55 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:18456 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758345AbZD3Q7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 12:59:55 -0400
Message-ID: <49F9D906.40300@hp.com>
Date: Thu, 30 Apr 2009 12:59:50 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <srostedt@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH] blktrace: correct remap names
References: <20090430133627.D217.A69D9226@jp.fujitsu.com> <49F9D82D.50901@hp.com>
In-Reply-To: <49F9D82D.50901@hp.com>
Content-Type: multipart/mixed;
 boundary="------------020203070809070804070902"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020203070809070804070902
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit



--------------020203070809070804070902
Content-Type: text/x-diff;
 name="0002-blktrace-correct-remap-names.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0002-blktrace-correct-remap-names.patch"

>From 28019f41f67ac64f0a8b12148c367d45d7279173 Mon Sep 17 00:00:00 2001
From: Alan D. Brunelle <alan.brunelle@hp.com>
Date: Thu, 30 Apr 2009 12:48:35 -0400
Subject: [PATCH] blktrace: correct remap names

This attempts to clarify names utilized during block I/O remap operations
(partition, volume manager). It correctly matches up the /from/ information for both device & sector. This takes in the concept from osaki Motohiro and extends it to include better naming for the "device_from" field.

Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Alan D. Brunelle <alan.brunelle@hp.com>
---
 include/linux/blktrace_api.h |    4 ++--
 include/trace/block.h        |    4 ++--
 kernel/trace/blktrace.c      |   21 +++++++++++----------
 3 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/include/linux/blktrace_api.h b/include/linux/blktrace_api.h
index d960889..da1a14e 100644
--- a/include/linux/blktrace_api.h
+++ b/include/linux/blktrace_api.h
@@ -116,9 +116,9 @@ struct blk_io_trace {
  * The remap event
  */
 struct blk_io_trace_remap {
-	__be32 device;
 	__be32 device_from;
-	__be64 sector;
+	__be32 device_to;
+	__be64 sector_from;
 };
 
 enum {
diff --git a/include/trace/block.h b/include/trace/block.h
index 8ac945b..5b12efa 100644
--- a/include/trace/block.h
+++ b/include/trace/block.h
@@ -70,7 +70,7 @@ DECLARE_TRACE(block_split,
 
 DECLARE_TRACE(block_remap,
 	TP_PROTO(struct request_queue *q, struct bio *bio, dev_t dev,
-		 sector_t to),
-	      TP_ARGS(q, bio, dev, to));
+		 sector_t from),
+	      TP_ARGS(q, bio, dev, from));
 
 #endif
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 6eaef3b..1492d50 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -817,7 +817,7 @@ static void blk_add_trace_split(struct request_queue *q, struct bio *bio,
  *
  **/
 static void blk_add_trace_remap(struct request_queue *q, struct bio *bio,
-				       dev_t dev, sector_t to)
+				       dev_t dev, sector_t from)
 {
 	struct blk_trace *bt = q->blk_trace;
 	struct blk_io_trace_remap r;
@@ -825,9 +825,9 @@ static void blk_add_trace_remap(struct request_queue *q, struct bio *bio,
 	if (likely(!bt))
 		return;
 
-	r.device = cpu_to_be32(dev);
-	r.device_from = cpu_to_be32(bio->bi_bdev->bd_dev);
-	r.sector = cpu_to_be64(to);
+	r.device_from = cpu_to_be32(dev);
+	r.device_to   = cpu_to_be32(bio->bi_bdev->bd_dev);
+	r.sector_from = cpu_to_be64(from);
 
 	__blk_add_trace(bt, bio->bi_sector, bio->bi_size, bio->bi_rw,
 			BLK_TA_REMAP, !bio_flagged(bio, BIO_UPTODATE),
@@ -997,11 +997,11 @@ static void get_pdu_remap(const struct trace_entry *ent,
 			  struct blk_io_trace_remap *r)
 {
 	const struct blk_io_trace_remap *__r = pdu_start(ent);
-	__u64 sector = __r->sector;
+	__u64 sector_from = __r->sector_from;
 
-	r->device = be32_to_cpu(__r->device);
 	r->device_from = be32_to_cpu(__r->device_from);
-	r->sector = be64_to_cpu(sector);
+	r->device_to   = be32_to_cpu(__r->device_to);
+	r->sector_from = be64_to_cpu(sector_from);
 }
 
 typedef int (blk_log_action_t) (struct trace_iterator *iter, const char *act);
@@ -1055,13 +1055,14 @@ static int blk_log_with_error(struct trace_seq *s,
 
 static int blk_log_remap(struct trace_seq *s, const struct trace_entry *ent)
 {
-	struct blk_io_trace_remap r = { .device = 0, };
+	struct blk_io_trace_remap r = { .device_from = 0, };
 
 	get_pdu_remap(ent, &r);
 	return trace_seq_printf(s, "%llu + %u <- (%d,%d) %llu\n",
 			       t_sector(ent),
-			       t_sec(ent), MAJOR(r.device), MINOR(r.device),
-			       (unsigned long long)r.sector);
+			       t_sec(ent), MAJOR(r.device_from),
+			       MINOR(r.device_from),
+			       (unsigned long long)r.sector_from);
 }
 
 static int blk_log_plug(struct trace_seq *s, const struct trace_entry *ent)
-- 
1.6.0.4


--------------020203070809070804070902--
