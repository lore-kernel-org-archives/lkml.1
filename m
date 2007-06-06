Return-Path: <linux-kernel-owner+w=401wt.eu-S1758636AbXFFILI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758636AbXFFILI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 04:11:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753251AbXFFIKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 04:10:55 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:12831 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983AbXFFIKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 04:10:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=ZoCs7+Zr+RuPb7kXk7gkeGDnGWVoWk/H9o+OtZgdq2EecZJEYX/gjXGR/28qSui2UPwegOAsVYZBgJB3wAm3L8ZBRw1jcILqO5PqxHJyMPmQJW1iFdGbuDgC9P/PPfMCD9tUrl+mkKjAbHk3AKxdux1zJhGdtSzFpdp6K/Liwhw=
Date: Wed, 6 Jun 2007 17:10:48 +0900
From: Tejun Heo <htejun@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] block: drop unnecessary bvec rewinding from flush_dry_bio_endio
Message-ID: <20070606081048.GB29122@htj.dyndns.org>
References: <18015.48604.807900.388675@notabene.brown> <20070601131406.GX32105@kernel.dk> <466132F7.3060602@gmail.com> <20070602143631.GC32105@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070602143631.GC32105@kernel.dk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Barrier bios are completed twice - once after the barrier write itself
is done and again after the whole sequence is complete.
flush_dry_bio_endio() is for the first completion.  It doesn't really
complete the bio.  It rewinds bvec and resets bio so that it can be
completed again when the whole barrier sequence is complete.

The bvec rewinding code has the following problems.

1. The rewinding code is wrong because filesystems may pass bvec with
   non zero bv_offset.

2. The block layer doesn't guarantee anything about the state of
   bvec array on request completion.  bv_offset and len are updated
   iff __end_that_request_first() completes the bvec partially.

Because of #2, #1 doesn't really matter (nobody cares whether bvec is
re-wound correctly or not) but then again by not doing unwinding at
all, we'll always give back the same bvec to the caller as full bvec
completion doesn't alter bvecs and the final completion is always full
completion.

Drop unnecessary rewinding code.

This is spotted by Neil Brown.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Neil Brown <neilb@suse.de>
---
Jens, as this is not a critical fix.  I think it would be better to
put this in -mm till .23 window is open.

Thanks.

 block/ll_rw_blk.c |    9 ---------
 1 file changed, 9 deletions(-)

diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index 6b5173a..8e19dee 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -518,8 +518,6 @@ int blk_do_ordered(request_queue_t *q, struct request **rqp)
 static int flush_dry_bio_endio(struct bio *bio, unsigned int bytes, int error)
 {
 	request_queue_t *q = bio->bi_private;
-	struct bio_vec *bvec;
-	int i;
 
 	/*
 	 * This is dry run, restore bio_sector and size.  We'll finish
@@ -531,13 +529,6 @@ static int flush_dry_bio_endio(struct bio *bio, unsigned int bytes, int error)
 	if (bio->bi_size)
 		return 1;
 
-	/* Rewind bvec's */
-	bio->bi_idx = 0;
-	bio_for_each_segment(bvec, bio, i) {
-		bvec->bv_len += bvec->bv_offset;
-		bvec->bv_offset = 0;
-	}
-
 	/* Reset bio */
 	set_bit(BIO_UPTODATE, &bio->bi_flags);
 	bio->bi_size = q->bi_size;
