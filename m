Return-Path: <linux-kernel-owner+w=401wt.eu-S1754581AbZEFMe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581AbZEFMe6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 08:34:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759198AbZEFMek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 08:34:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:54635 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759623AbZEFMei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 08:34:38 -0400
Date: Wed, 6 May 2009 12:33:42 GMT
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
In-Reply-To: <49FF517C.7000503@hp.com>
References: <49FF517C.7000503@hp.com>
Subject: [tip:tracing/core] blktrace: from-sector redundant in trace_block_remap
Message-ID: <tip-22a7c31a9659deaddafbbcec6562d44141e84474@git.kernel.org>
Git-Commit-ID: 22a7c31a9659deaddafbbcec6562d44141e84474
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 06 May 2009 12:33:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  22a7c31a9659deaddafbbcec6562d44141e84474
Gitweb:     http://git.kernel.org/tip/22a7c31a9659deaddafbbcec6562d44141e84474
Author:     Alan D. Brunelle <Alan.Brunelle@hp.com>
AuthorDate: Mon, 4 May 2009 16:35:08 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 6 May 2009 14:13:01 +0200

blktrace: from-sector redundant in trace_block_remap

Remove redundant from-sector parameter: it's /always/ the bio's sector
passed in.

[ Impact: cleanup ]

Signed-off-by: Alan D. Brunelle <alan.brunelle@hp.com>
Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <49FF517C.7000503@hp.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 block/blk-core.c        |    5 ++---
 drivers/md/dm.c         |    3 +--
 include/trace/block.h   |    4 ++--
 kernel/trace/blktrace.c |    8 ++++----
 4 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 07ab754..a5f747a 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1275,7 +1275,7 @@ static inline void blk_partition_remap(struct bio *bio)
 		bio->bi_bdev = bdev->bd_contains;
 
 		trace_block_remap(bdev_get_queue(bio->bi_bdev), bio,
-				    bdev->bd_dev, bio->bi_sector,
+				    bdev->bd_dev,
 				    bio->bi_sector - p->start_sect);
 	}
 }
@@ -1444,8 +1444,7 @@ static inline void __generic_make_request(struct bio *bio)
 			goto end_io;
 
 		if (old_sector != -1)
-			trace_block_remap(q, bio, old_dev, bio->bi_sector,
-					    old_sector);
+			trace_block_remap(q, bio, old_dev, old_sector);
 
 		trace_block_bio_queue(q, bio);
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 8a994be..b01514a 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -657,8 +657,7 @@ static void __map_bio(struct dm_target *ti, struct bio *clone,
 		/* the bio has been remapped so dispatch it */
 
 		trace_block_remap(bdev_get_queue(clone->bi_bdev), clone,
-				    tio->io->bio->bi_bdev->bd_dev,
-				    clone->bi_sector, sector);
+				    tio->io->bio->bi_bdev->bd_dev, sector);
 
 		generic_make_request(clone);
 	} else if (r < 0 || r == DM_MAPIO_REQUEUE) {
diff --git a/include/trace/block.h b/include/trace/block.h
index 87f6456..8ac945b 100644
--- a/include/trace/block.h
+++ b/include/trace/block.h
@@ -70,7 +70,7 @@ DECLARE_TRACE(block_split,
 
 DECLARE_TRACE(block_remap,
 	TP_PROTO(struct request_queue *q, struct bio *bio, dev_t dev,
-		 sector_t to, sector_t from),
-	      TP_ARGS(q, bio, dev, to, from));
+		 sector_t to),
+	      TP_ARGS(q, bio, dev, to));
 
 #endif
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index f8d46d6..e099f8c 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -830,7 +830,6 @@ static void blk_add_trace_split(struct request_queue *q, struct bio *bio,
  * @q:		queue the io is for
  * @bio:	the source bio
  * @dev:	target device
- * @to:		target sector
  * @from:	source sector
  *
  * Description:
@@ -839,7 +838,7 @@ static void blk_add_trace_split(struct request_queue *q, struct bio *bio,
  *
  **/
 static void blk_add_trace_remap(struct request_queue *q, struct bio *bio,
-				       dev_t dev, sector_t to, sector_t from)
+				       dev_t dev, sector_t from)
 {
 	struct blk_trace *bt = q->blk_trace;
 	struct blk_io_trace_remap r;
@@ -851,8 +850,9 @@ static void blk_add_trace_remap(struct request_queue *q, struct bio *bio,
 	r.device_to   = cpu_to_be32(bio->bi_bdev->bd_dev);
 	r.sector_from = cpu_to_be64(from);
 
-	__blk_add_trace(bt, from, bio->bi_size, bio->bi_rw, BLK_TA_REMAP,
-			!bio_flagged(bio, BIO_UPTODATE), sizeof(r), &r);
+	__blk_add_trace(bt, bio->bi_sector, bio->bi_size, bio->bi_rw,
+			BLK_TA_REMAP, !bio_flagged(bio, BIO_UPTODATE),
+			sizeof(r), &r);
 }
 
 /**
