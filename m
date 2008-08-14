Return-Path: <linux-kernel-owner+w=401wt.eu-S1758539AbYHNJDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758539AbYHNJDt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 05:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758247AbYHNJDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 05:03:36 -0400
Received: from lemon.ertos.nicta.com.au ([203.143.174.143]:40744 "EHLO
	lemon.gelato.unsw.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758206AbYHNJDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 05:03:34 -0400
X-Greylist: delayed 2982 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Aug 2008 05:03:34 EDT
From: Aaron Carroll <aaronc@gelato.unsw.edu.au>
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] deadline-iosched: non-functional fixes
Date: Thu, 14 Aug 2008 18:17:14 +1000
Message-Id: <1218701835-17327-3-git-send-email-aaronc@gelato.unsw.edu.au>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218701835-17327-1-git-send-email-aaronc@gelato.unsw.edu.au>
References: <1218701835-17327-1-git-send-email-aaronc@gelato.unsw.edu.au>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 203.143.161.65
X-SA-Exim-Mail-From: aaronc@gelato.unsw.edu.au
X-SA-Exim-Scanned: No (on lemon.gelato.unsw.edu.au); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 * convert goto to simpler while loop;
 * use rq_end_sector() instead of computing manually;
 * fix false comments;
 * remove spurious whitespace;
 * convert rq_rb_root macro to an inline function.

Signed-off-by: Aaron Carroll <aaronc@gelato.unsw.edu.au>
---
 block/deadline-iosched.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/block/deadline-iosched.c b/block/deadline-iosched.c
index 07b80e4..fd31117 100644
--- a/block/deadline-iosched.c
+++ b/block/deadline-iosched.c
@@ -33,7 +33,7 @@ struct deadline_data {
 	 */
 	struct rb_root sort_list[2];	
 	struct list_head fifo_list[2];
-	
+
 	/*
 	 * next in sort order. read, write or both are NULL
 	 */
@@ -53,7 +53,11 @@ struct deadline_data {
 
 static void deadline_move_request(struct deadline_data *, struct request *);
 
-#define RQ_RB_ROOT(dd, rq)	(&(dd)->sort_list[rq_data_dir((rq))])
+static inline struct rb_root *
+deadline_rb_root(struct deadline_data *dd, struct request *rq)
+{
+	return &dd->sort_list[rq_data_dir(rq)];
+}
 
 /*
  * get the request after `rq' in sector-sorted order
@@ -72,15 +76,11 @@ deadline_latter_request(struct request *rq)
 static void
 deadline_add_rq_rb(struct deadline_data *dd, struct request *rq)
 {
-	struct rb_root *root = RQ_RB_ROOT(dd, rq);
+	struct rb_root *root = deadline_rb_root(dd, rq);
 	struct request *__alias;
 
-retry:
-	__alias = elv_rb_add(root, rq);
-	if (unlikely(__alias)) {
+	while (unlikely(__alias = elv_rb_add(root, rq)))
 		deadline_move_request(dd, __alias);
-		goto retry;
-	}
 }
 
 static inline void
@@ -91,7 +91,7 @@ deadline_del_rq_rb(struct deadline_data *dd, struct request *rq)
 	if (dd->next_rq[data_dir] == rq)
 		dd->next_rq[data_dir] = deadline_latter_request(rq);
 
-	elv_rb_del(RQ_RB_ROOT(dd, rq), rq);
+	elv_rb_del(deadline_rb_root(dd, rq), rq);
 }
 
 /*
@@ -106,7 +106,7 @@ deadline_add_request(struct request_queue *q, struct request *rq)
 	deadline_add_rq_rb(dd, rq);
 
 	/*
-	 * set expire time (only used for reads) and add to fifo list
+	 * set expire time and add to fifo list
 	 */
 	rq_set_fifo_time(rq, jiffies + dd->fifo_expire[data_dir]);
 	list_add_tail(&rq->queuelist, &dd->fifo_list[data_dir]);
@@ -162,7 +162,7 @@ static void deadline_merged_request(struct request_queue *q,
 	 * if the merge was a front merge, we need to reposition request
 	 */
 	if (type == ELEVATOR_FRONT_MERGE) {
-		elv_rb_del(RQ_RB_ROOT(dd, req), req);
+		elv_rb_del(deadline_rb_root(dd, req), req);
 		deadline_add_rq_rb(dd, req);
 	}
 }
@@ -212,7 +212,7 @@ deadline_move_request(struct deadline_data *dd, struct request *rq)
 	dd->next_rq[WRITE] = NULL;
 	dd->next_rq[data_dir] = deadline_latter_request(rq);
 
-	dd->last_sector = rq->sector + rq->nr_sectors;
+	dd->last_sector = rq_end_sector(rq);
 
 	/*
 	 * take it off the sort and fifo list, move
@@ -222,7 +222,7 @@ deadline_move_request(struct deadline_data *dd, struct request *rq)
 }
 
 /*
- * deadline_check_fifo returns 0 if there are no expired reads on the fifo,
+ * deadline_check_fifo returns 0 if there are no expired requests on the fifo,
  * 1 otherwise. Requires !list_empty(&dd->fifo_list[data_dir])
  */
 static inline int deadline_check_fifo(struct deadline_data *dd, int ddir)
-- 
1.5.4.5

