Return-Path: <linux-kernel-owner+w=401wt.eu-S1757474AbZDWMan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474AbZDWMan (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 08:30:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754759AbZDWM12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 08:27:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:38569 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755185AbZDWM1Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 08:27:24 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, joerg@dorchain.net,
       geert@linux-m68k.org, donari75@gmail.com, davem@davemloft.net,
       jdike@linux.intel.com, benh@kernel.crashing.org, Laurent@lvivier.info
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 09/12] swim3: clean up request completion paths
Date: Thu, 23 Apr 2009 21:25:50 +0900
Message-Id: <1240489553-15724-10-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1240489553-15724-1-git-send-email-tj@kernel.org>
References: <1240489553-15724-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 23 Apr 2009 12:26:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

swim3 curiously tries to update request parameters before calling
__blk_end_request() when __blk_end_request() will do it anyway, and it
updates request for partial completion manually instead of using
blk_update_request().  Also, it does some spurious checks on rq such
as testing whether rq->sector is negative or current_nr_sectors is
zero right after fetching.

Drop unnecessary stuff and use standard block layer mechanisms.

[ Impact: cleanup ]

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 drivers/block/swim3.c |   31 +++++--------------------------
 1 files changed, 5 insertions(+), 26 deletions(-)

diff --git a/drivers/block/swim3.c b/drivers/block/swim3.c
index 5904f7b..4248559 100644
--- a/drivers/block/swim3.c
+++ b/drivers/block/swim3.c
@@ -319,14 +319,10 @@ static void start_request(struct floppy_state *fs)
 		       req->errors, req->current_nr_sectors);
 #endif
 
-		if (req->sector < 0 || req->sector >= fs->total_secs) {
+		if (req->sector >= fs->total_secs) {
 			__blk_end_request_cur(req, -EIO);
 			continue;
 		}
-		if (req->current_nr_sectors == 0) {
-			__blk_end_request_cur(req, 0);
-			continue;
-		}
 		if (fs->ejected) {
 			__blk_end_request_cur(req, -EIO);
 			continue;
@@ -593,8 +589,6 @@ static void xfer_timeout(unsigned long data)
 	struct floppy_state *fs = (struct floppy_state *) data;
 	struct swim3 __iomem *sw = fs->swim3;
 	struct dbdma_regs __iomem *dr = fs->dma;
-	struct dbdma_cmd *cp = fs->dma_cmd;
-	unsigned long s;
 	int n;
 
 	fs->timeout_pending = 0;
@@ -605,14 +599,6 @@ static void xfer_timeout(unsigned long data)
 	out_8(&sw->intr_enable, 0);
 	out_8(&sw->control_bic, WRITE_SECTORS | DO_ACTION);
 	out_8(&sw->select, RELAX);
-	if (rq_data_dir(fd_req) == WRITE)
-		++cp;
-	if (ld_le16(&cp->xfer_status) != 0)
-		s = fs->scount - ((ld_le16(&cp->res_count) + 511) >> 9);
-	else
-		s = 0;
-	fd_req->sector += s;
-	fd_req->current_nr_sectors -= s;
 	printk(KERN_ERR "swim3: timeout %sing sector %ld\n",
 	       (rq_data_dir(fd_req)==WRITE? "writ": "read"), (long)fd_req->sector);
 	__blk_end_request_cur(fd_req, -EIO);
@@ -719,9 +705,7 @@ static irqreturn_t swim3_interrupt(int irq, void *dev_id)
 		if (intr & ERROR_INTR) {
 			n = fs->scount - 1 - resid / 512;
 			if (n > 0) {
-				fd_req->sector += n;
-				fd_req->current_nr_sectors -= n;
-				fd_req->buffer += n * 512;
+				blk_update_request(fd_req, 0, n << 9);
 				fs->req_sector += n;
 			}
 			if (fs->retries < 5) {
@@ -745,13 +729,7 @@ static irqreturn_t swim3_interrupt(int irq, void *dev_id)
 				start_request(fs);
 				break;
 			}
-			fd_req->sector += fs->scount;
-			fd_req->current_nr_sectors -= fs->scount;
-			fd_req->buffer += fs->scount * 512;
-			if (fd_req->current_nr_sectors <= 0) {
-				__blk_end_request_cur(fd_req, 0);
-				fs->state = idle;
-			} else {
+			if (__blk_end_request(fd_req, 0, fs->scount << 9)) {
 				fs->req_sector += fs->scount;
 				if (fs->req_sector > fs->secpertrack) {
 					fs->req_sector -= fs->secpertrack;
@@ -761,7 +739,8 @@ static irqreturn_t swim3_interrupt(int irq, void *dev_id)
 					}
 				}
 				act(fs);
-			}
+			} else
+				fs->state = idle;
 		}
 		if (fs->state == idle)
 			start_request(fs);
-- 
1.6.0.2

