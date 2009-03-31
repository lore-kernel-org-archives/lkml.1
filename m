Return-Path: <linux-kernel-owner+w=401wt.eu-S1762596AbZCaRT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762596AbZCaRT2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 13:19:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761169AbZCaRTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 13:19:04 -0400
Received: from brick.kernel.dk ([93.163.65.50]:59221 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759232AbZCaRTD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 13:19:03 -0400
Date: Tue, 31 Mar 2009 19:19:00 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ric Wheeler <rwheeler@redhat.com>,
       Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
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
Message-ID: <20090331171900.GU5178@kernel.dk>
References: <20090330201732.GB5178@kernel.dk> <alpine.LFD.2.00.0903301331320.4093@localhost.localdomain> <49D17CA2.5060105@redhat.com> <alpine.LFD.2.00.0903301931230.4093@localhost.localdomain> <49D1FB64.8000505@redhat.com> <alpine.LFD.2.00.0903310746460.4093@localhost.localdomain> <49D239A0.5080405@redhat.com> <alpine.LFD.2.00.0903310854570.4093@localhost.localdomain> <20090331164312.GP5178@kernel.dk> <alpine.LFD.2.00.0903310953310.4093@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0903310953310.4093@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 31 2009, Linus Torvalds wrote:
> 
> 
> On Tue, 31 Mar 2009, Jens Axboe wrote:
> > 
> > So here's a test patch that attempts to just ignore such a failure to
> > flush the caches.
> 
> I suspect you should not do it like this.
> 
> > diff --git a/fs/bio.c b/fs/bio.c
> > index a040cde..79e3cec 100644
> > --- a/fs/bio.c
> > +++ b/fs/bio.c
> > @@ -1380,7 +1380,17 @@ void bio_check_pages_dirty(struct bio *bio)
> >   **/
> >  void bio_endio(struct bio *bio, int error)
> >  {
> > -	if (error)
> > +	/*
> > +	 * Special case here - hide the -EOPNOTSUPP from the driver or
> > +	 * block layer, dump a warning the first time this happens so that
> > +	 * the admin knows that we may not provide the ordering guarantees
> > +	 * that are needed. Don't clear the uptodate bit.
> > +	 */
> > +	if (error == -EOPNOTSUPP && bio_barrier(bio)) {
> > +		set_bit(BIO_EOPNOTSUPP, &bio->bi_flags);
> > +		blk_queue_set_noflush(bio->bi_bdev);
> > +		error = 0;
> > +	} else if (error)
> 
> I suspect this part is just wrong.
> 
> I could easily imagine a driver that returns EOPNOTSUPP only for a certain 
> _kind_ of bio.
> 
> For example, if the drive doesn't support FUA, then you cannot do a 
> serialized IO operation, but you can still mostly do a serialized op 
> without any IO attached to it.

FUA we should be able to reliably detect, it's really the cache flush
operation itself that has caused headaches in the past. The -EOPNOTSUPP
really comes from the block layer, not from the device driver. That's
mainly due to the fact that we only send down the actual barrier, if the
driver already said it supported them. If they do fail them, we probably
need to pick up the -EIO bits and pieces and pretend it didn't happen as
well. So it definitely needs more looking into, auditing, and testing.
I'll do that tomorrow.

> IOW, the "empty flush" really _is_ special. An this check should not be in 
> the generic "bio_endio()" case, it should only be in the special 
> blkdev_issue_flush() case.
> 
> I think. No?

The empty flush is special and it is easy to fix that by itself. That
should probably be the first patch in the series. But the retry logic
and such for actual write barriers are the majority of the problems
involved with supporting barriers, and those I want to get rid of.

I think it'll be more clear when I post a real patch series with the
individual steps outlined.

-- 
Jens Axboe

