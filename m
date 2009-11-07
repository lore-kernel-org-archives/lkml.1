Return-Path: <linux-kernel-owner+w=401wt.eu-S1753105AbZKGVhC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105AbZKGVhC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 16:37:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751702AbZKGVhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 16:37:00 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:38249 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbZKGVg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 16:36:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=xmf4ESCaMbxPNIy2wSYVTa7mjvIIST+Zo8xsSVfsupEFmA4puHkVdM8W/PA+EXkiTy
         gYueX5BsdIBnF+MfjdfLw2cQTWUgkeyKcIqY5ULmCS8rM51JXG8EwHvEcJIH7ttXBLNI
         0kaUcbM4wgrD5HI73C2Vze3AjtigT/sufYAb0=
From: Corrado Zoccolo <czoccolo@gmail.com>
To: "Linux-Kernel" <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH] cfq-iosched: fix next_rq computation
Date: Sat, 7 Nov 2009 22:37:01 +0100
User-Agent: KMail/1.11.4 (Linux/2.6.32cz; KDE/4.2.4; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911072237.01807.czoccolo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cfq has a bug in computation of next_rq, that affects transition
between multiple sequential request streams in a single queue
(e.g.: two sequential buffered writers of the same priority),
causing the alternation between the two streams for a transient period.

  8,0    1    18737     0.260400660  5312  D   W 141653311 + 256
  8,0    1    20839     0.273239461  5400  D   W 141653567 + 256
  8,0    1    20841     0.276343885  5394  D   W 142803919 + 256
  8,0    1    20843     0.279490878  5394  D   W 141668927 + 256
  8,0    1    20845     0.292459993  5400  D   W 142804175 + 256
  8,0    1    20847     0.295537247  5400  D   W 141668671 + 256
  8,0    1    20849     0.298656337  5400  D   W 142804431 + 256
  8,0    1    20851     0.311481148  5394  D   W 141668415 + 256
  8,0    1    20853     0.314421305  5394  D   W 142804687 + 256
  8,0    1    20855     0.318960112  5400  D   W 142804943 + 256

The fix makes sure that the next_rq is computed from the last
dispatched request, and not affected by merging.

  8,0    1    37776     4.305161306     0  D   W 141738087 + 256
  8,0    1    37778     4.308298091     0  D   W 141738343 + 256
  8,0    1    37780     4.312885190     0  D   W 141738599 + 256
  8,0    1    37782     4.315933291     0  D   W 141738855 + 256
  8,0    1    37784     4.319064459     0  D   W 141739111 + 256
  8,0    1    37786     4.331918431  5672  D   W 142803007 + 256
  8,0    1    37788     4.334930332  5672  D   W 142803263 + 256
  8,0    1    37790     4.337902723  5672  D   W 142803519 + 256
  8,0    1    37792     4.342359774  5672  D   W 142803775 + 256
  8,0    1    37794     4.345318286     0  D   W 142804031 + 256
---
 block/cfq-iosched.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 56cfd1b..f5a1de7 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -454,9 +454,9 @@ static inline bool cfq_slice_used(struct cfq_queue *cfqq)
  * behind the head is penalized and only allowed to a certain extent.
  */
 static struct request *
-cfq_choose_req(struct cfq_data *cfqd, struct request *rq1, struct request *rq2)
+cfq_choose_req(struct cfq_data *cfqd, struct request *rq1, struct request *rq2, sector_t last)
 {
-	sector_t last, s1, s2, d1 = 0, d2 = 0;
+	sector_t s1, s2, d1 = 0, d2 = 0;
 	unsigned long back_max;
 #define CFQ_RQ1_WRAP	0x01 /* request 1 wraps */
 #define CFQ_RQ2_WRAP	0x02 /* request 2 wraps */
@@ -479,8 +479,6 @@ cfq_choose_req(struct cfq_data *cfqd, struct request *rq1, struct request *rq2)
 	s1 = blk_rq_pos(rq1);
 	s2 = blk_rq_pos(rq2);
 
-	last = cfqd->last_position;
-
 	/*
 	 * by definition, 1KiB is 2 sectors
 	 */
@@ -595,7 +593,7 @@ cfq_find_next_rq(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 			next = rb_entry_rq(rbnext);
 	}
 
-	return cfq_choose_req(cfqd, next, prev);
+	return cfq_choose_req(cfqd, next, prev, blk_rq_pos(last));
 }
 
 static unsigned long cfq_slice_offset(struct cfq_data *cfqd,
@@ -843,7 +841,7 @@ static void cfq_add_rq_rb(struct request *rq)
 	 * check if this request is a better next-serve candidate
 	 */
 	prev = cfqq->next_rq;
-	cfqq->next_rq = cfq_choose_req(cfqd, cfqq->next_rq, rq);
+	cfqq->next_rq = cfq_choose_req(cfqd, cfqq->next_rq, rq, cfqd->last_position);
 
 	/*
 	 * adjust priority tree position, if ->next_rq changes
@@ -950,6 +948,7 @@ static void
 cfq_merged_requests(struct request_queue *q, struct request *rq,
 		    struct request *next)
 {
+	struct cfq_queue *cfqq = RQ_CFQQ(rq);
 	/*
 	 * reposition in fifo if next is older than rq
 	 */
@@ -959,6 +958,8 @@ cfq_merged_requests(struct request_queue *q, struct request *rq,
 		rq_set_fifo_time(rq, rq_fifo_time(next));
 	}
 
+	if (cfqq->next_rq == next)
+		cfqq->next_rq = rq;
 	cfq_remove_request(next);
 }
 
-- 
1.6.2.5

 

