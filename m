Return-Path: <linux-kernel-owner+w=401wt.eu-S1751028AbZELLcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751028AbZELLcr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 07:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758229AbZELLcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 07:32:36 -0400
Received: from sh.osrg.net ([192.16.179.4]:49847 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756994AbZELLcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 07:32:36 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: jens.axboe@oracle.com
Cc: tj@kernel.org, linux-kernel@vger.kernel.org, benh@kernel.crashing.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] swim3: use blk_end_request instead of blk_update_request
Date: Tue, 12 May 2009 20:29:47 +0900
Message-Id: <1242127787-29842-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1242127787-29842-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1242127787-29842-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 12 May 2009 20:31:34 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

swim3 is the only user of blk_update_request(). Let's use
blk_end_request instead of blk_update_request. swim3 doesn't need to
update a request manually. In addition, we can unexport
blk_update_request().

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/block/swim3.c |   23 +++++++++++++----------
 1 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/block/swim3.c b/drivers/block/swim3.c
index 116d169..0dd619a 100644
--- a/drivers/block/swim3.c
+++ b/drivers/block/swim3.c
@@ -726,18 +726,21 @@ static irqreturn_t swim3_interrupt(int irq, void *dev_id)
 		resid = ld_le16(&cp->res_count);
 		if (intr & ERROR_INTR) {
 			n = fs->scount - 1 - resid / 512;
-			if (n > 0) {
-				blk_update_request(fd_req, 0, n << 9);
+			if (blk_end_request(fd_req, 0, n << 9)) {
 				fs->req_sector += n;
-			}
-			if (fs->retries < 5) {
-				++fs->retries;
-				act(fs);
+
+				if (fs->retries < 5) {
+					++fs->retries;
+					act(fs);
+				} else {
+					printk("swim3: error %sing block %ld (err=%x)\n",
+					       rq_data_dir(fd_req) == WRITE? "writ": "read",
+					       (long)blk_rq_pos(fd_req), err);
+					blk_end_request_all(fd_req, -EIO);
+					fd_req = NULL;
+					fs->state = idle;
+				}
 			} else {
-				printk("swim3: error %sing block %ld (err=%x)\n",
-				       rq_data_dir(fd_req) == WRITE? "writ": "read",
-				       (long)blk_rq_pos(fd_req), err);
-				blk_end_request_all(fd_req, -EIO);
 				fd_req = NULL;
 				fs->state = idle;
 			}
-- 
1.6.0.6

