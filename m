Return-Path: <linux-kernel-owner+w=401wt.eu-S965975AbXIKTK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965975AbXIKTK1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 15:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764506AbXIKTE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 15:04:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48255 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763402AbXIKTEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 15:04:53 -0400
Date: Tue, 11 Sep 2007 15:04:34 -0400 (EDT)
Message-Id: <20070911.150434.109053539.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       mike.miller@hp.com, grant.likely@secretlab.ca
Cc: dm-devel@redhat.com, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com
Subject: [PATCH 24/27] blk_end_request: changing cpqarray (take 2)
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 3.3 on Emacs 21.3 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts cpqarray to use blk_end_request().

cpqarray is a little bit different from "normal" drivers.
cpqarray directly calls bio_endio() and disk_stat_add()
when completing request.  But those can be replaced with
__end_that_request_first().
After the replacement, request completion procedures of
those drivers become like the following:
    o end_that_request_first()
    o add_disk_randomness()
    o end_that_request_last()
This can be converted to blk_end_request() by following
the rule (b) mentioned in the patch subject
"[PATCH 01/27] blk_end_request: add new request completion interface".

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/block/cpqarray.c |   28 ++--------------------------
 1 files changed, 2 insertions(+), 26 deletions(-)

diff -rupN 23-cciss-caller-change/drivers/block/cpqarray.c 24-cpqarray-caller-change/drivers/block/cpqarray.c
--- 23-cciss-caller-change/drivers/block/cpqarray.c	2007-08-27 21:32:35.000000000 -0400
+++ 24-cpqarray-caller-change/drivers/block/cpqarray.c	2007-09-10 18:17:03.000000000 -0400
@@ -166,7 +166,6 @@ static void start_io(ctlr_info_t *h);
 
 static inline void addQ(cmdlist_t **Qptr, cmdlist_t *c);
 static inline cmdlist_t *removeQ(cmdlist_t **Qptr, cmdlist_t *c);
-static inline void complete_buffers(struct bio *bio, int ok);
 static inline void complete_command(cmdlist_t *cmd, int timeout);
 
 static irqreturn_t do_ida_intr(int irq, void *dev_id);
@@ -978,20 +977,6 @@ static void start_io(ctlr_info_t *h)
 	}
 }
 
-static inline void complete_buffers(struct bio *bio, int ok)
-{
-	struct bio *xbh;
-	while(bio) {
-		int nr_sectors = bio_sectors(bio);
-
-		xbh = bio->bi_next;
-		bio->bi_next = NULL;
-		
-		bio_endio(bio, nr_sectors << 9, ok ? 0 : -EIO);
-
-		bio = xbh;
-	}
-}
 /*
  * Mark all buffers that cmd was responsible for
  */
@@ -1029,18 +1014,9 @@ static inline void complete_command(cmdl
                 pci_unmap_page(hba[cmd->ctlr]->pci_dev, cmd->req.sg[i].addr,
 				cmd->req.sg[i].size, ddir);
 
-	complete_buffers(rq->bio, ok);
-
-	if (blk_fs_request(rq)) {
-		const int rw = rq_data_dir(rq);
-
-		disk_stat_add(rq->rq_disk, sectors[rw], rq->nr_sectors);
-	}
-
-	add_disk_randomness(rq->rq_disk);
-
 	DBGPX(printk("Done with %p\n", rq););
-	end_that_request_last(rq, ok ? 1 : -EIO);
+	if (__blk_end_request(rq, ok, blk_rq_size(rq)))
+		BUG();
 }
 
 /*
