Return-Path: <linux-kernel-owner+w=401wt.eu-S1759688AbZC3TSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759688AbZC3TSd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 15:18:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759605AbZC3TRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 15:17:38 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:53589 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759589AbZC3TRf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 15:17:35 -0400
Message-ID: <49D11A8D.1090600@garzik.org>
Date: Mon, 30 Mar 2009 15:16:29 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       =?ISO-8859-1?Q?Fernan?= =?ISO-8859-1?Q?do_Luis_V=E1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>,
       Christoph Hellwig <hch@infradead.org>, Theodore Tso <tytso@mit.edu>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       chris.mason@oracle.com, david@fromorbit.com, tj@kernel.org
Subject: Re: [PATCH 1/7] block: Add block_flush_device()
References: <20090329082507.GA4242@infradead.org> <49D01F94.6000101@oss.ntt.co.jp> <49D02328.7060108@oss.ntt.co.jp> <49D0258A.9020306@garzik.org> <49D03377.1040909@oss.ntt.co.jp> <49D0B535.2010106@oss.ntt.co.jp> <49D0B687.1030407@oss.ntt.co.jp> <alpine.LFD.2.00.0903301028400.3948@localhost.localdomain> <20090330175544.GX5178@kernel.dk> <alpine.LFD.2.00.0903301120200.3948@localhost.localdomain> <20090330185414.GZ5178@kernel.dk>
In-Reply-To: <20090330185414.GZ5178@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Mon, Mar 30 2009, Linus Torvalds wrote:
>>
>> On Mon, 30 Mar 2009, Jens Axboe wrote:
>>> The problem is that we may not know upfront, so it sort-of has to be
>>> this trial approach where the first barrier issued will notice and fail
>>> with -EOPNOTSUPP.
>> Well, absolutely. Except I don't think you shoul use ENOTSUPP, you should 
>> just set a bit in the "struct request_queue", and then return 0.
>>
>> IOW, something like this
>>
>> 	--- a/block/blk-barrier.c
>> 	+++ b/block/blk-barrier.c
>> 	@@ -318,6 +318,9 @@ int blkdev_issue_flush(struct block_device *bdev, sector_t *error_sector)
>> 	 	if (!q)
>> 	 		return -ENXIO;
>> 	 
>> 	+	if (is_queue_noflush(q))
>> 	+		return 0;
>> 	+
>> 	 	bio = bio_alloc(GFP_KERNEL, 0);
>> 	 	if (!bio)
>> 	 		return -ENOMEM;
>> 	@@ -339,7 +342,7 @@ int blkdev_issue_flush(struct block_device *bdev, sector_t *error_sector)
>> 	 
>> 	 	ret = 0;
>> 	 	if (bio_flagged(bio, BIO_EOPNOTSUPP))
>> 	-		ret = -EOPNOTSUPP;
>> 	+		set_queue_noflush(q);
>> 	 	else if (!bio_flagged(bio, BIO_UPTODATE))
>> 	 		ret = -EIO;
>> 	 
>>
>> which just returns 0 if we don't support flushing on that queue.
>>
>> (Obviously incomplete patch, which is why I also intentionally 
>> whitespace-broke it).
>>
>>> Sure, we could cache this value, but it's pretty
>>> pointless since the filesystem will stop sending barriers in this case.
>> Well no, it won't. Or rather, it will have to have such a stupid 
>> per-filesystem flag, for no good reason.
> 
> Sorry, I just don't see much point to doing it this way instead. So now
> the fs will have to check a queue bit after it has issued the flush, how
> is that any better than having the 'error' returned directly?

AFAICS, the aim is simply to return zero rather than EOPNOTSUPP, for the 
not-supported case, rather than burdening all callers with such checks.

Which is quite reasonable for Fernando's patch -- the direct call fsync 
case.

But that leaves open the possibility that some people really do want the 
EOPNOTSUPP return value, I guess?  Do existing callers need that?


>>> For blkdev_issue_flush() it may not be very interesting, since there's
>>> not much we can do about that. Just seems like very bad style to NOT
>>> return an error in such a case. You can assume that ordering is fine,
>>> but it definitely wont be in all case (eg devices that have write back
>>> caching on by default and don't support flush).
>> So?
>>
>> The thing is, you can't _do_ anything about it. So what's the point in 
>> returning an error? The caller cannot possibly care - because there is 
>> nothing the caller can really do.
> 
> Not for blkdev_issue_flush(), all they can do is report about the
> device. And even that would be a vague "Your data may or may not be
> safe, we don't know".
> 
>> Sure, the device may or may not re-order things, but since the caller 
>> can't know, and can't really do a thing about it _anyway_, you're just 
>> better off not even confusing anybody.
> 
> I'd call that a pretty reckless approach to data integrity, honestly.
> You HAVE to issue an error in this case. Then the user/admin can at least
> check up on the device stack in question, and determine whether this is
> an issue or not. That goes for both blkdev_issue_flush() and the actual
> barrier write. And perhaps the cached value is then of some use, since
> you then know when to warn (bit not already set) and you can keep the
> warning in blkdev_issue_flush() instead of putting it in every call
> site.

Indeed -- if the drive tells us it failed the cache flush, it seems 
self-evident that we should be passing that failure back to userspace 
where possible.

And as the patches show, it is definitely possible to return a FLUSH 
CACHE error back to an fsync(2) caller [though, yes, I certainly 
recognize fsync is not the only generator of these requests].

	Jeff



