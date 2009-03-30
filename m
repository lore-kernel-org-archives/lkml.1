Return-Path: <linux-kernel-owner+w=401wt.eu-S1760046AbZC3T3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760046AbZC3T3m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 15:29:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753252AbZC3T30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 15:29:26 -0400
Received: from rcsinet13.oracle.com ([148.87.113.125]:22801 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758271AbZC3T3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 15:29:25 -0400
Subject: Re: [PATCH 1/7] block: Add block_flush_device()
From: Chris Mason <chris.mason@oracle.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>,
       Christoph Hellwig <hch@infradead.org>, Theodore Tso <tytso@mit.edu>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       david@fromorbit.com, tj@kernel.org
In-Reply-To: <49D11A8D.1090600@garzik.org>
References: <20090329082507.GA4242@infradead.org>
	 <49D01F94.6000101@oss.ntt.co.jp> <49D02328.7060108@oss.ntt.co.jp>
	 <49D0258A.9020306@garzik.org> <49D03377.1040909@oss.ntt.co.jp>
	 <49D0B535.2010106@oss.ntt.co.jp> <49D0B687.1030407@oss.ntt.co.jp>
	 <alpine.LFD.2.00.0903301028400.3948@localhost.localdomain>
	 <20090330175544.GX5178@kernel.dk>
	 <alpine.LFD.2.00.0903301120200.3948@localhost.localdomain>
	 <20090330185414.GZ5178@kernel.dk>  <49D11A8D.1090600@garzik.org>
Content-Type: text/plain
Date: Mon, 30 Mar 2009 15:24:03 -0400
Message-Id: <1238441043.20607.16.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt704.oracle.com [141.146.40.82]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.49D11C5C.02F1:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-30 at 15:16 -0400, Jeff Garzik wrote:
> Jens Axboe wrote:
> > On Mon, Mar 30 2009, Linus Torvalds wrote:
> >>
> >> On Mon, 30 Mar 2009, Jens Axboe wrote:
> >>> The problem is that we may not know upfront, so it sort-of has to be
> >>> this trial approach where the first barrier issued will notice and fail
> >>> with -EOPNOTSUPP.
> >> Well, absolutely. Except I don't think you shoul use ENOTSUPP, you should 
> >> just set a bit in the "struct request_queue", and then return 0.
> >>
> >> IOW, something like this
> >>
> >> 	--- a/block/blk-barrier.c
> >> 	+++ b/block/blk-barrier.c
> >> 	@@ -318,6 +318,9 @@ int blkdev_issue_flush(struct block_device *bdev, sector_t *error_sector)
> >> 	 	if (!q)
> >> 	 		return -ENXIO;
> >> 	 
> >> 	+	if (is_queue_noflush(q))
> >> 	+		return 0;
> >> 	+
> >> 	 	bio = bio_alloc(GFP_KERNEL, 0);
> >> 	 	if (!bio)
> >> 	 		return -ENOMEM;
> >> 	@@ -339,7 +342,7 @@ int blkdev_issue_flush(struct block_device *bdev, sector_t *error_sector)
> >> 	 
> >> 	 	ret = 0;
> >> 	 	if (bio_flagged(bio, BIO_EOPNOTSUPP))
> >> 	-		ret = -EOPNOTSUPP;
> >> 	+		set_queue_noflush(q);
> >> 	 	else if (!bio_flagged(bio, BIO_UPTODATE))
> >> 	 		ret = -EIO;
> >> 	 
> >>
> >> which just returns 0 if we don't support flushing on that queue.
> >>
> >> (Obviously incomplete patch, which is why I also intentionally 
> >> whitespace-broke it).
> >>
> >>> Sure, we could cache this value, but it's pretty
> >>> pointless since the filesystem will stop sending barriers in this case.
> >> Well no, it won't. Or rather, it will have to have such a stupid 
> >> per-filesystem flag, for no good reason.
> > 
> > Sorry, I just don't see much point to doing it this way instead. So now
> > the fs will have to check a queue bit after it has issued the flush, how
> > is that any better than having the 'error' returned directly?
> 
> AFAICS, the aim is simply to return zero rather than EOPNOTSUPP, for the 
> not-supported case, rather than burdening all callers with such checks.
> 
> Which is quite reasonable for Fernando's patch -- the direct call fsync 
> case.
> 
> But that leaves open the possibility that some people really do want the 
> EOPNOTSUPP return value, I guess?  Do existing callers need that?
> 

As far as I know, reiserfs is the only one actively using it to choose
different code.  It moves a single wait_on_buffer when barriers are on,
which I took out once to simplify the code.  Ric saw it in some
benchmark numbers and I put it back in.

Given that it was a long time ago, I don't have a problem with changing
it to work like all the other filesystems.

-chris


