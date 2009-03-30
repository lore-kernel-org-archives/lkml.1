Return-Path: <linux-kernel-owner+w=401wt.eu-S1757180AbZC3Ska@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757180AbZC3Ska (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 14:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752824AbZC3SkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 14:40:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35775 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752165AbZC3SkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 14:40:12 -0400
Date: Mon, 30 Mar 2009 11:27:22 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jens Axboe <jens.axboe@oracle.com>
cc: =?ISO-8859-15?Q?Fernando_Luis_V=E1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>,
       Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@infradead.org>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       chris.mason@oracle.com, david@fromorbit.com, tj@kernel.org
Subject: Re: [PATCH 1/7] block: Add block_flush_device()
In-Reply-To: <20090330175544.GX5178@kernel.dk>
Message-ID: <alpine.LFD.2.00.0903301120200.3948@localhost.localdomain>
References: <20090326032445.GA16999@havoc.gtf.org> <20090327205046.GA2036@havoc.gtf.org> <20090329082507.GA4242@infradead.org> <49D01F94.6000101@oss.ntt.co.jp> <49D02328.7060108@oss.ntt.co.jp> <49D0258A.9020306@garzik.org> <49D03377.1040909@oss.ntt.co.jp>
 <49D0B535.2010106@oss.ntt.co.jp> <49D0B687.1030407@oss.ntt.co.jp> <alpine.LFD.2.00.0903301028400.3948@localhost.localdomain> <20090330175544.GX5178@kernel.dk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 30 Mar 2009, Jens Axboe wrote:
> 
> The problem is that we may not know upfront, so it sort-of has to be
> this trial approach where the first barrier issued will notice and fail
> with -EOPNOTSUPP.

Well, absolutely. Except I don't think you shoul use ENOTSUPP, you should 
just set a bit in the "struct request_queue", and then return 0.

IOW, something like this

	--- a/block/blk-barrier.c
	+++ b/block/blk-barrier.c
	@@ -318,6 +318,9 @@ int blkdev_issue_flush(struct block_device *bdev, sector_t *error_sector)
	 	if (!q)
	 		return -ENXIO;
	 
	+	if (is_queue_noflush(q))
	+		return 0;
	+
	 	bio = bio_alloc(GFP_KERNEL, 0);
	 	if (!bio)
	 		return -ENOMEM;
	@@ -339,7 +342,7 @@ int blkdev_issue_flush(struct block_device *bdev, sector_t *error_sector)
	 
	 	ret = 0;
	 	if (bio_flagged(bio, BIO_EOPNOTSUPP))
	-		ret = -EOPNOTSUPP;
	+		set_queue_noflush(q);
	 	else if (!bio_flagged(bio, BIO_UPTODATE))
	 		ret = -EIO;
	 

which just returns 0 if we don't support flushing on that queue.

(Obviously incomplete patch, which is why I also intentionally 
whitespace-broke it).

> Sure, we could cache this value, but it's pretty
> pointless since the filesystem will stop sending barriers in this case.

Well no, it won't. Or rather, it will have to have such a stupid 
per-filesystem flag, for no good reason.

> For blkdev_issue_flush() it may not be very interesting, since there's
> not much we can do about that. Just seems like very bad style to NOT
> return an error in such a case. You can assume that ordering is fine,
> but it definitely wont be in all case (eg devices that have write back
> caching on by default and don't support flush).

So?

The thing is, you can't _do_ anything about it. So what's the point in 
returning an error? The caller cannot possibly care - because there is 
nothing the caller can really do.

Sure, the device may or may not re-order things, but since the caller 
can't know, and can't really do a thing about it _anyway_, you're just 
better off not even confusing anybody.

		Linus
