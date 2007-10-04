Return-Path: <linux-kernel-owner+w=401wt.eu-S1760802AbXJDQlH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760802AbXJDQlH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 12:41:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759093AbXJDQkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 12:40:55 -0400
Received: from brick.kernel.dk ([87.55.233.238]:2612 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759071AbXJDQkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 12:40:55 -0400
Date: Thu, 4 Oct 2007 18:42:25 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Pierre Ossman <drzeus@drzeus.cx>
Cc: Don Mullis <dwm@meer.net>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc8-mm2: OOPS in mmc on boot
Message-ID: <20071004164225.GF5711@kernel.dk>
References: <1191478262.21598.5.camel@dmullis-laptop> <20071003231659.f41df5ed.akpm@linux-foundation.org> <20071004072515.GC5236@kernel.dk> <1191514780.30871.1.camel@dmullis-laptop> <20071004183555.3e0ed9eb@poseidon.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071004183555.3e0ed9eb@poseidon.drzeus.cx>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04 2007, Pierre Ossman wrote:
> On Thu, 04 Oct 2007 09:19:40 -0700
> Don Mullis <dwm@meer.net> wrote:
> 
> > This patch fixes the boot.
> > 
> 
> Fantastic. Then will try to get this upstream then.

I already put it in the sgchain drivers part. If you could please ack
it, that would be nice :-). I have a bunch of driver
updates/work-arounds there.

> > > It looks like missing init of the sg list in mmc, does this work?
> > > 
> 
> Jens, is this zeroing needed for each invocation, or really just once
> to get the list in a known state?

Once should actually be enough, so you could move it to init as well.
Don, care to verify with the below patch as well?

> Also, is chaining already upstream so Linus should have this for 2.6.23?

No, it's for 2.6.24.

diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
index b0abc7d..a5d0354 100644
--- a/drivers/mmc/card/queue.c
+++ b/drivers/mmc/card/queue.c
@@ -153,14 +153,14 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card, spinlock_t *lock
 			blk_queue_max_hw_segments(mq->queue, bouncesz / 512);
 			blk_queue_max_segment_size(mq->queue, bouncesz);
 
-			mq->sg = kmalloc(sizeof(struct scatterlist),
+			mq->sg = kzalloc(sizeof(struct scatterlist),
 				GFP_KERNEL);
 			if (!mq->sg) {
 				ret = -ENOMEM;
 				goto cleanup_queue;
 			}
 
-			mq->bounce_sg = kmalloc(sizeof(struct scatterlist) *
+			mq->bounce_sg = kzalloc(sizeof(struct scatterlist) *
 				bouncesz / 512, GFP_KERNEL);
 			if (!mq->bounce_sg) {
 				ret = -ENOMEM;
@@ -177,7 +177,7 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card, spinlock_t *lock
 		blk_queue_max_hw_segments(mq->queue, host->max_hw_segs);
 		blk_queue_max_segment_size(mq->queue, host->max_seg_size);
 
-		mq->sg = kmalloc(sizeof(struct scatterlist) *
+		mq->sg = kzalloc(sizeof(struct scatterlist) *
 			host->max_phys_segs, GFP_KERNEL);
 		if (!mq->sg) {
 			ret = -ENOMEM;

-- 
Jens Axboe

