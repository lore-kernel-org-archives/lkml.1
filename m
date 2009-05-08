Return-Path: <linux-kernel-owner+w=401wt.eu-S1763203AbZEHC7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763203AbZEHC7s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 22:59:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758563AbZEHC4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 22:56:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:36246 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760809AbZEHC4d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 22:56:33 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, rusty@rustcorp.com.au,
       James.Bottomley@HansenPartnership.com, mike.miller@hp.com,
       donari75@gmail.com, paul.clements@steeleye.com, tim@cyberelk.net,
       Geert.Uytterhoeven@sonycom.com, davem@davemloft.net,
       Laurent@lvivier.info, jgarzik@pobox.com, jeremy@xensource.com,
       grant.likely@secretlab.ca, adrian@mcmen.demon.co.uk,
       sfr@canb.auug.org.au, bzolnier@gmail.com, petkovbb@googlemail.com,
       sshtylyov@ru.mvista.com, oakad@yahoo.com, drzeus@drzeus.cx,
       dwmw2@infradead.org, Markus.Lidel@shadowconnect.com, wein@de.ibm.com,
       schwidefsky@de.ibm.com, zaitcev@redhat.com,
       fujita.tomonori@lab.ntt.co.jp, axboe@kernel.dk
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 08/18] paride: dequeue in-flight request
Date: Fri,  8 May 2009 11:54:06 +0900
Message-Id: <1241751256-17435-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1241751256-17435-1-git-send-email-tj@kernel.org>
References: <1241751256-17435-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 08 May 2009 02:54:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pd/pf/pcd have track in-flight request by pd/pf/pcd_req.  They can be
converted to dequeueing model by updating fetching and completion
paths.  Convert them.

Note that removal of elv_next_request() call from pf_next_buf()
doesn't make any functional difference.  The path is traveled only
during partial completion of a request and elv_next_request() call
must return the same request anyway.

[ Impact: dequeue in-flight request ]

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Tim Waugh <tim@cyberelk.net>
---
 drivers/block/paride/pcd.c |   18 ++++++++++++------
 drivers/block/paride/pd.c  |   14 +++++++++-----
 drivers/block/paride/pf.c  |   14 +++++++-------
 3 files changed, 28 insertions(+), 18 deletions(-)

diff --git a/drivers/block/paride/pcd.c b/drivers/block/paride/pcd.c
index 2d5dc0a..425f815 100644
--- a/drivers/block/paride/pcd.c
+++ b/drivers/block/paride/pcd.c
@@ -719,9 +719,12 @@ static void do_pcd_request(struct request_queue * q)
 	if (pcd_busy)
 		return;
 	while (1) {
-		pcd_req = elv_next_request(q);
-		if (!pcd_req)
-			return;
+		if (!pcd_req) {
+			pcd_req = elv_next_request(q);
+			if (!pcd_req)
+				return;
+			blkdev_dequeue_request(pcd_req);
+		}
 
 		if (rq_data_dir(pcd_req) == READ) {
 			struct pcd_unit *cd = pcd_req->rq_disk->private_data;
@@ -734,8 +737,10 @@ static void do_pcd_request(struct request_queue * q)
 			pcd_busy = 1;
 			ps_set_intr(do_pcd_read, NULL, 0, nice);
 			return;
-		} else
-			__blk_end_request_cur(pcd_req, -EIO);
+		} else {
+			__blk_end_request_all(pcd_req, -EIO);
+			pcd_req = NULL;
+		}
 	}
 }
 
@@ -744,7 +749,8 @@ static inline void next_request(int err)
 	unsigned long saved_flags;
 
 	spin_lock_irqsave(&pcd_lock, saved_flags);
-	__blk_end_request_cur(pcd_req, err);
+	if (!__blk_end_request_cur(pcd_req, err))
+		pcd_req = NULL;
 	pcd_busy = 0;
 	do_pcd_request(pcd_queue);
 	spin_unlock_irqrestore(&pcd_lock, saved_flags);
diff --git a/drivers/block/paride/pd.c b/drivers/block/paride/pd.c
index 9ec5d4a..d2ca3f5 100644
--- a/drivers/block/paride/pd.c
+++ b/drivers/block/paride/pd.c
@@ -410,11 +410,14 @@ static void run_fsm(void)
 				pd_claimed = 0;
 				phase = NULL;
 				spin_lock_irqsave(&pd_lock, saved_flags);
-				__blk_end_request_cur(pd_req,
-						      res == Ok ? 0 : -EIO);
-				pd_req = elv_next_request(pd_queue);
-				if (!pd_req)
-					stop = 1;
+				if (!__blk_end_request_cur(pd_req,
+						res == Ok ? 0 : -EIO)) {
+					pd_req = elv_next_request(pd_queue);
+					if (!pd_req)
+						stop = 1;
+					else
+						blkdev_dequeue_request(pd_req);
+				}
 				spin_unlock_irqrestore(&pd_lock, saved_flags);
 				if (stop)
 					return;
@@ -706,6 +709,7 @@ static void do_pd_request(struct request_queue * q)
 	pd_req = elv_next_request(q);
 	if (!pd_req)
 		return;
+	blkdev_dequeue_request(pd_req);
 
 	schedule_fsm();
 }
diff --git a/drivers/block/paride/pf.c b/drivers/block/paride/pf.c
index e88c889..d6f7bd8 100644
--- a/drivers/block/paride/pf.c
+++ b/drivers/block/paride/pf.c
@@ -752,10 +752,8 @@ static struct request_queue *pf_queue;
 
 static void pf_end_request(int err)
 {
-	if (pf_req) {
-		__blk_end_request_cur(pf_req, err);
+	if (pf_req && !__blk_end_request_cur(pf_req, err))
 		pf_req = NULL;
-	}
 }
 
 static void do_pf_request(struct request_queue * q)
@@ -763,9 +761,12 @@ static void do_pf_request(struct request_queue * q)
 	if (pf_busy)
 		return;
 repeat:
-	pf_req = elv_next_request(q);
-	if (!pf_req)
-		return;
+	if (!pf_req) {
+		pf_req = elv_next_request(q);
+		if (!pf_req)
+			return;
+		blkdev_dequeue_request(pf_req);
+	}
 
 	pf_current = pf_req->rq_disk->private_data;
 	pf_block = blk_rq_pos(pf_req);
@@ -806,7 +807,6 @@ static int pf_next_buf(void)
 	if (!pf_count) {
 		spin_lock_irqsave(&pf_spin_lock, saved_flags);
 		pf_end_request(0);
-		pf_req = elv_next_request(pf_queue);
 		spin_unlock_irqrestore(&pf_spin_lock, saved_flags);
 		if (!pf_req)
 			return 1;
-- 
1.6.0.2

