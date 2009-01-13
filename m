Return-Path: <linux-kernel-owner+w=401wt.eu-S1755424AbZAMKqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424AbZAMKqx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 05:46:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751312AbZAMKqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 05:46:42 -0500
Received: from brick.kernel.dk ([93.163.65.50]:20977 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242AbZAMKqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 05:46:42 -0500
Date: Tue, 13 Jan 2009 11:45:24 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Tejun Heo <tj@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
Subject: Re: new barrier warnings in 2.6.29-rc1
Message-ID: <20090113104522.GP30821@kernel.dk>
References: <20090112154634.GA15730@lst.de> <496C0915.6000107@kernel.org> <20090113084229.GL30821@kernel.dk> <496C6FBA.2090709@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496C6FBA.2090709@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13 2009, Tejun Heo wrote:
> Hello, Jens.
> 
> Jens Axboe wrote:
> > On Tue, Jan 13 2009, Tejun Heo wrote:
> >> I think the right thing to do is setting REQ_QUIET on the trial
> >> barrier request.
> > 
> > It would surely work, but XFS doesn't really have a way to do that. Then
> > we would have to add a bio quiet flag and inherit that.
> > 
> > I kind of liked the old behaviour. What about something like the below?
> > 
> > diff --git a/block/blk-core.c b/block/blk-core.c
> > index a824e49..eddba4a 100644
> > --- a/block/blk-core.c
> > +++ b/block/blk-core.c
> > @@ -1448,6 +1448,11 @@ static inline void __generic_make_request(struct bio *bio)
> >  			err = -EOPNOTSUPP;
> >  			goto end_io;
> >  		}
> > +		if (bio_barrier(bio) && bio_has_data(bio) &&
> > +		    (q->next_ordered == QUEUE_ORDERED_NONE)) {
> > +			err = -EOPNOTSUPP;
> > +			goto end_io;
> > +		}
> >  
> >  		ret = q->make_request_fn(q, bio);
> >  	} while (ret);
> 
> I have no objection against it.  I kind of like having single test
> point but it's a corner case anyway so no biggie.

I agree, but it's a lot better than having to fiddle around with every
spot that wants to do a barrier probe. I'll merge it up for 2.6.29.
Christoph, can you double check that it gets rid of your warning and
still catches the barrier disable?

-- 
Jens Axboe

