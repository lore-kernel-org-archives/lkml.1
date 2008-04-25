Return-Path: <linux-kernel-owner+w=401wt.eu-S1760306AbYDYLR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760306AbYDYLR0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 07:17:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751861AbYDYLRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 07:17:19 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:20188 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbYDYLRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 07:17:18 -0400
Message-ID: <4811BDBB.8010604@hp.com>
Date: Fri, 25 Apr 2008 07:17:15 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 0/3] Skip I/O merges when disabled
References: <480F8936.5030406@hp.com> <20080424070923.GQ12774@kernel.dk> <48107891.5000308@hp.com> <20080425083809.GG12774@kernel.dk>
In-Reply-To: <20080425083809.GG12774@kernel.dk>
Content-Type: multipart/mixed;
 boundary="------------010501070209050008010907"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010501070209050008010907
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

>>
>> I'll look into retaining the one-hit cache merge functionality, remove
>> the errant elv_rqhas_del code, and repost w/ the results from the other
>> tests I've run.
> 
> Also please do a check where you only disable the front merge logic, as
> that is the most expensive bit (and the least likely to occur). I would
> not be surprised if just removing the front merge bit would get you the
> majority of the gain already. I have in the past considered just getting
> rid of that bit, as it rarely triggers and it is a costly rbtree lookup
> for each IO. The back merge lookup+merge should be cheaper, it's just a
> hash lookup.
> 

I have the results from leaving in just the one-hit cache merge
attempts, and started a run leaving in both that and the back-merge
rq_hash checks. (The patch below basically undoes patch 3/3 - putting
back in the addition of rqs onto the hash list, and moves the nomerges
check below the back merge attempts.)

We /could/ change the tunable to a dial (or a mask) - enabling/disabling
specific merge attempts, but that seems a bit confusing/complex.

Jens: What do you think?

Alan

--------------010501070209050008010907
Content-Type: text/x-patch;
 name="0005-Enables-back-merge-checks-and-one-hit-cache-checks.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0005-Enables-back-merge-checks-and-one-hit-cache-checks.patc";
 filename*1="h"

>From eb158393a5fd2eec0582bbba8af588be7e08ef32 Mon Sep 17 00:00:00 2001
From: Alan D. Brunelle <alan.brunelle@hp.com>
Date: Fri, 25 Apr 2008 07:14:42 -0400
Subject: [PATCH] Enables back-merge checks (and one-hit cache checks) for merges

Undoes patch 3/3 -- puts rqs onto the rq_hash list -- and performs simple
hash list checks for back-merges only.

Signed-off-by: Alan D. Brunelle <alan.brunelle@hp.com>
---
 block/elevator.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/block/elevator.c b/block/elevator.c
index 557ee38..59be58d 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -488,9 +488,6 @@ int elv_merge(struct request_queue *q, struct request **req, struct bio *bio)
 		}
 	}
 
-	if (blk_queue_nomerges(q))
-		return ELEVATOR_NO_MERGE;
-
 	/*
 	 * See if our hash lookup can find a potential backmerge.
 	 */
@@ -500,6 +497,9 @@ int elv_merge(struct request_queue *q, struct request **req, struct bio *bio)
 		return ELEVATOR_BACK_MERGE;
 	}
 
+	if (blk_queue_nomerges(q))
+		return ELEVATOR_NO_MERGE;
+
 	if (e->ops->elevator_merge_fn)
 		return e->ops->elevator_merge_fn(q, req, bio);
 
@@ -604,7 +604,7 @@ void elv_insert(struct request_queue *q, struct request *rq, int where)
 		BUG_ON(!blk_fs_request(rq));
 		rq->cmd_flags |= REQ_SORTED;
 		q->nr_sorted++;
-		if (!blk_queue_nomerges(q) && rq_mergeable(rq)) {
+		if (rq_mergeable(rq)) {
 			elv_rqhash_add(q, rq);
 			if (!q->last_merge)
 				q->last_merge = rq;
-- 
1.5.2.5


--------------010501070209050008010907--
