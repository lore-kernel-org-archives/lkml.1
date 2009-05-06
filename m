Return-Path: <linux-kernel-owner+w=401wt.eu-S1759295AbZEFMen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759295AbZEFMen (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 08:34:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752355AbZEFMec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 08:34:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:54630 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752455AbZEFMeb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 08:34:31 -0400
Date: Wed, 6 May 2009 12:33:31 GMT
From: "tip-bot for Alan D. Brunelle" <Alan.Brunelle@hp.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, lizf@cn.fujitsu.com, alan.brunelle@hp.com,
       jens.axboe@oracle.com, Alan.Brunelle@hp.com, tglx@linutronix.de,
       kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com, alan.brunelle@hp.com,
       Alan.Brunelle@hp.com, jens.axboe@oracle.com, tglx@linutronix.de,
       kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu
In-Reply-To: <49FF4FAE.3000301@hp.com>
References: <49FF4FAE.3000301@hp.com>
Subject: [tip:tracing/core] blktrace: correct remap names
Message-ID: <tip-a42aaa3bbce85ac487ad4fad5db99e8e91b7aac1@git.kernel.org>
Git-Commit-ID: a42aaa3bbce85ac487ad4fad5db99e8e91b7aac1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 06 May 2009 12:33:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a42aaa3bbce85ac487ad4fad5db99e8e91b7aac1
Gitweb:     http://git.kernel.org/tip/a42aaa3bbce85ac487ad4fad5db99e8e91b7aac1
Author:     Alan D. Brunelle <Alan.Brunelle@hp.com>
AuthorDate: Mon, 4 May 2009 16:27:26 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 6 May 2009 14:13:00 +0200

blktrace: correct remap names

This attempts to clarify names utilized during block I/O remap
operations (partition, volume manager). It correctly matches up the
/from/ information for both device & sector. This takes in the concept
from Kosaki Motohiro and extends it to include better naming for the
"device_from" field.

[ Impact: cleanup ]

Signed-off-by: Alan D. Brunelle <alan.brunelle@hp.com>
Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <49FF4FAE.3000301@hp.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/blktrace_api.h |    4 ++--
 include/trace/block.h        |    4 ++--
 kernel/trace/blktrace.c      |   24 ++++++++++++------------
 3 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/include/linux/blktrace_api.h b/include/linux/blktrace_api.h
index 62763c9..82b4636 100644
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
index 25b7068..87f6456 100644
--- a/include/trace/block.h
+++ b/include/trace/block.h
@@ -70,7 +70,7 @@ DECLARE_TRACE(block_split,
 
 DECLARE_TRACE(block_remap,
 	TP_PROTO(struct request_queue *q, struct bio *bio, dev_t dev,
-		 sector_t from, sector_t to),
-	      TP_ARGS(q, bio, dev, from, to));
+		 sector_t to, sector_t from),
+	      TP_ARGS(q, bio, dev, to, from));
 
 #endif
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index c32062b..f8d46d6 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -830,8 +830,8 @@ static void blk_add_trace_split(struct request_queue *q, struct bio *bio,
  * @q:		queue the io is for
  * @bio:	the source bio
  * @dev:	target device
- * @from:	source sector
  * @to:		target sector
+ * @from:	source sector
  *
  * Description:
  *     Device mapper or raid target sometimes need to split a bio because
@@ -839,7 +839,7 @@ static void blk_add_trace_split(struct request_queue *q, struct bio *bio,
  *
  **/
 static void blk_add_trace_remap(struct request_queue *q, struct bio *bio,
-				       dev_t dev, sector_t from, sector_t to)
+				       dev_t dev, sector_t to, sector_t from)
 {
 	struct blk_trace *bt = q->blk_trace;
 	struct blk_io_trace_remap r;
@@ -847,9 +847,9 @@ static void blk_add_trace_remap(struct request_queue *q, struct bio *bio,
 	if (likely(!bt))
 		return;
 
-	r.device = cpu_to_be32(dev);
-	r.device_from = cpu_to_be32(bio->bi_bdev->bd_dev);
-	r.sector = cpu_to_be64(to);
+	r.device_from = cpu_to_be32(dev);
+	r.device_to   = cpu_to_be32(bio->bi_bdev->bd_dev);
+	r.sector_from = cpu_to_be64(from);
 
 	__blk_add_trace(bt, from, bio->bi_size, bio->bi_rw, BLK_TA_REMAP,
 			!bio_flagged(bio, BIO_UPTODATE), sizeof(r), &r);
@@ -1028,11 +1028,11 @@ static void get_pdu_remap(const struct trace_entry *ent,
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
@@ -1148,13 +1148,13 @@ static int blk_log_with_error(struct trace_seq *s,
 
 static int blk_log_remap(struct trace_seq *s, const struct trace_entry *ent)
 {
-	struct blk_io_trace_remap r = { .device = 0, };
+	struct blk_io_trace_remap r = { .device_from = 0, };
 
 	get_pdu_remap(ent, &r);
 	return trace_seq_printf(s, "%llu + %u <- (%d,%d) %llu\n",
-			       t_sector(ent),
-			       t_sec(ent), MAJOR(r.device), MINOR(r.device),
-			       (unsigned long long)r.sector);
+				t_sector(ent), t_sec(ent),
+				MAJOR(r.device_from), MINOR(r.device_from),
+				(unsigned long long)r.sector_from);
 }
 
 static int blk_log_plug(struct trace_seq *s, const struct trace_entry *ent)
