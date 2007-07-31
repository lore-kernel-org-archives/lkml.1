Return-Path: <linux-kernel-owner+w=401wt.eu-S940817AbXGaCXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940817AbXGaCXR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 22:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765145AbXGaCRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 22:17:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36050 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S940214AbXGaCRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 22:17:23 -0400
From: NeilBrown <neilb@suse.de>
To: linux-kernel@vger.kernel.org
Date: Tue, 31 Jul 2007 12:17:11 +1000
Message-Id: <1070731021711.25318@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Subject: [PATCH 016 of 35] Centralise setting for REQ_NOMERGE.
References: <20070731112539.22428.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Every error return from ll_{front,back}_merge_fn sets
REQ_NOMERGE.  So move this to after the call to these functions.
This is only a small saving here, but will help a future patch.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./block/ll_rw_blk.c |   43 +++++++++++++++++++------------------------
 1 file changed, 19 insertions(+), 24 deletions(-)

diff .prev/block/ll_rw_blk.c ./block/ll_rw_blk.c
--- .prev/block/ll_rw_blk.c	2007-07-31 11:21:00.000000000 +1000
+++ ./block/ll_rw_blk.c	2007-07-31 11:21:01.000000000 +1000
@@ -1373,12 +1373,8 @@ static inline int ll_new_mergeable(struc
 {
 
 	if (req->nr_phys_segments + nreq->nr_phys_segments
-	    > q->max_phys_segments) {
-		req->cmd_flags |= REQ_NOMERGE;
-		if (req == q->last_merge)
-			q->last_merge = NULL;
+	    > q->max_phys_segments)
 		return 0;
-	}
 
 	/*
 	 * A hw segment is just getting larger, bump just the phys
@@ -1395,12 +1391,8 @@ static inline int ll_new_hw_segment(stru
 
 	if (req->nr_hw_segments + nreq->nr_hw_segments > q->max_hw_segments
 	    || (req->nr_phys_segments + nreq->nr_phys_segments
-		> q->max_phys_segments)) {
-		req->cmd_flags |= REQ_NOMERGE;
-		if (req == q->last_merge)
-			q->last_merge = NULL;
+		> q->max_phys_segments))
 		return 0;
-	}
 
 	/*
 	 * This will form the start of a new hw segment.  Bump both
@@ -1422,12 +1414,9 @@ static int ll_back_merge_fn(struct reque
 	else
 		max_sectors = q->max_sectors;
 
-	if (req->nr_sectors + nreq->nr_sectors > max_sectors) {
-		req->cmd_flags |= REQ_NOMERGE;
-		if (req == q->last_merge)
-			q->last_merge = NULL;
+	if (req->nr_sectors + nreq->nr_sectors > max_sectors)
 		return 0;
-	}
+
 	len = req->hw_back_size + nreq->hw_front_size;
 	if (nreq->first_offset == 0 &&
 	    BIOVEC_VIRT_MERGEABLE(__BVEC_END(req->biotail),
@@ -1459,12 +1448,9 @@ static int ll_front_merge_fn(struct requ
 		max_sectors = q->max_sectors;
 
 
-	if (req->nr_sectors + nreq->nr_sectors > max_sectors) {
-		req->cmd_flags |= REQ_NOMERGE;
-		if (req == q->last_merge)
-			q->last_merge = NULL;
+	if (req->nr_sectors + nreq->nr_sectors > max_sectors)
 		return 0;
-	}
+
 	len = nreq->hw_back_size + req->hw_front_size;
 
 	if (BIOVEC_VIRT_MERGEABLE(__BVEC_END(nreq->biotail),
@@ -2347,9 +2333,10 @@ int blk_rq_append_bio(struct request_que
 
 	if (!rq->bio)
 		blk_rq_bio_prep(q, rq, bio);
-	else if (!ll_back_merge_fn(q, rq, &nreq))
+	else if (!ll_back_merge_fn(q, rq, &nreq)) {
+		rq->cmd_flags |= REQ_NOMERGE;
 		return -EINVAL;
-	else {
+	} else {
 		rq->biotail->bi_next = bio;
 		rq->biotail = bio;
 		rq->hw_back_size = nreq.hw_back_size;
@@ -2959,8 +2946,12 @@ static int __make_request(struct request
 		case ELEVATOR_BACK_MERGE:
 			BUG_ON(!rq_mergeable(req));
 
-			if (!ll_back_merge_fn(q, req, &nreq))
+			if (!ll_back_merge_fn(q, req, &nreq)) {
+				req->cmd_flags |= REQ_NOMERGE;
+				if (req == q->last_merge)
+					q->last_merge = NULL;
 				break;
+			}
 
 			blk_add_trace_bio(q, bio, BLK_TA_BACKMERGE);
 
@@ -2977,8 +2968,12 @@ static int __make_request(struct request
 		case ELEVATOR_FRONT_MERGE:
 			BUG_ON(!rq_mergeable(req));
 
-			if (!ll_front_merge_fn(q, req, &nreq))
+			if (!ll_front_merge_fn(q, req, &nreq)) {
+				req->cmd_flags |= REQ_NOMERGE;
+				if (req == q->last_merge)
+					q->last_merge = NULL;
 				break;
+			}
 
 			blk_add_trace_bio(q, bio, BLK_TA_FRONTMERGE);
 
