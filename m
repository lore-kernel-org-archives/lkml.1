Return-Path: <linux-kernel-owner+w=401wt.eu-S1758451AbYDXUjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758451AbYDXUjd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 16:39:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753816AbYDXUjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 16:39:07 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:40770 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643AbYDXUjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 16:39:05 -0400
Message-ID: <4810EFE3.3070607@hp.com>
Date: Thu, 24 Apr 2008 16:38:59 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 0/3] Skip I/O merges when disabled
References: <480F8936.5030406@hp.com> <20080424070923.GQ12774@kernel.dk>
In-Reply-To: <20080424070923.GQ12774@kernel.dk>
Content-Type: multipart/mixed;
 boundary="------------000309010004070708030806"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000309010004070708030806
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Jens Axboe wrote:
> 
> The functionality is fine with me, merging is obviously a non-zero
> amount of cycles spent on IO and if you know it's in vain, may as well
> turn it off. One suggestion, though - if you add this as a performance
> rather than functionality change, I would suggest keeping the one-hit
> cache merge as that is essentially free. Better than free actually,
> since if you hit that merge point you'll be spending way less cycles
> than allocating+setting up a new request.
> 

With the patch below we retain the one-hit cache functionality. On a few
by-hand runs I'm seeing not much movement in the numbers (goodness). I'm
going to do a full 25 by 10-minute set of runs, and if things look OK,
I'll submit a new patch stream tomorrow.

Cheers,
Alan




--------------000309010004070708030806
Content-Type: text/x-patch;
 name="0004-Move-merge-skip-until-after-the-one-hit-check.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0004-Move-merge-skip-until-after-the-one-hit-check.patch"

>From afee0469c6dfc297cc81e38178193aaf0bd3b539 Mon Sep 17 00:00:00 2001
From: Alan D. Brunelle <alan.brunelle@hp.com>
Date: Thu, 24 Apr 2008 16:36:19 -0400
Subject: [PATCH] Move merge skip until after the one-hit check

This undoes patch 2/3, and moves the code to elv_merge after the one-hit
cache check.

Signed-off-by: Alan D. Brunelle <alan.brunelle@hp.com>
---
 block/blk-core.c |    2 +-
 block/elevator.c |    3 +++
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 54a2d8b..2a438a9 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1115,7 +1115,7 @@ static int __make_request(struct request_queue *q, struct bio *bio)
 
 	spin_lock_irq(q->queue_lock);
 
-	if (blk_queue_nomerges(q) || unlikely(barrier) || elv_queue_empty(q))
+	if (unlikely(barrier) || elv_queue_empty(q))
 		goto get_rq;
 
 	el_ret = elv_merge(q, &req, bio);
diff --git a/block/elevator.c b/block/elevator.c
index 2a5e4be..557ee38 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -488,6 +488,9 @@ int elv_merge(struct request_queue *q, struct request **req, struct bio *bio)
 		}
 	}
 
+	if (blk_queue_nomerges(q))
+		return ELEVATOR_NO_MERGE;
+
 	/*
 	 * See if our hash lookup can find a potential backmerge.
 	 */
-- 
1.5.2.5


--------------000309010004070708030806--
