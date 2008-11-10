Return-Path: <linux-kernel-owner+w=401wt.eu-S1755148AbYKJMTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148AbYKJMTZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 07:19:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754690AbYKJMTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 07:19:14 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:47145 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754598AbYKJMTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 07:19:13 -0500
Date: Mon, 10 Nov 2008 13:09:59 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: request to revert libata-convert-to-block-tagging patches
Message-ID: <20081110120959.GC26778@kernel.dk>
References: <4917C449.2080504@kernel.org> <20081110120533.GB26778@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081110120533.GB26778@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10 2008, Jens Axboe wrote:
> > 2. blk-tag offsets allocation for non-sync requests.  I'm not confident
> > this is safe.  Till now, if there was only single command in flight for
> > the port, it was guaranteed that the qc gets tag zero whether the device
> > is NCQ capable or not.  qc allocation is tied tightly with hardware
> > command slot allocation and I don't think it's wise to change this
> > assumption.
> > 
> > #1 is easy to fix but #2 requires either adding a spinlock or two atomic
> > variables to struct blk_queue_tag to keep the current behavior while
> > guaranteeing that tags are used in order.  Also, there's delay between
> > libata marks a request complete and the request actually gets completed
> > and the tag is freed.  If another request gets issued inbetween, the tag
> > number can't be guaranteed.  This can be worked around by re-mapping tag
> > number in libata depending on command type but, well then, it's worse
> > than the original implementation.
> 
> Or we could just change the blk-tag.c logic to stop of
> find_first_zero_bit() returns >= some_value instead of starting at an
> offset? You don't need any extra locking for that.

Something like the below.

diff --git a/block/blk-tag.c b/block/blk-tag.c
index c0d419e..451e7ce 100644
--- a/block/blk-tag.c
+++ b/block/blk-tag.c
@@ -337,7 +337,7 @@ EXPORT_SYMBOL(blk_queue_end_tag);
 int blk_queue_start_tag(struct request_queue *q, struct request *rq)
 {
 	struct blk_queue_tag *bqt = q->queue_tags;
-	unsigned max_depth, offset;
+	unsigned max_depth;
 	int tag;
 
 	if (unlikely((rq->cmd_flags & REQ_QUEUED))) {
@@ -356,13 +356,11 @@ int blk_queue_start_tag(struct request_queue *q, struct request *rq)
 	 * to starve sync IO on behalf of flooding async IO.
 	 */
 	max_depth = bqt->max_depth;
-	if (rq_is_sync(rq))
-		offset = 0;
-	else
-		offset = max_depth >> 2;
+	if (!rq_is_sync(rq))
+		max_depth = 3 * max_depth / 4;
 
 	do {
-		tag = find_next_zero_bit(bqt->tag_map, max_depth, offset);
+		tag = find_first_zero_bit(bqt->tag_map, max_depth);
 		if (tag >= max_depth)
 			return 1;
 

-- 
Jens Axboe

