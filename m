Return-Path: <linux-kernel-owner+w=401wt.eu-S1756867AbZEKJQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867AbZEKJQ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 05:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755530AbZEKJQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 05:16:16 -0400
Received: from brick.kernel.dk ([93.163.65.50]:56661 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753767AbZEKJQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 05:16:15 -0400
Date: Mon, 11 May 2009 11:16:15 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: tj@kernel.org, James.Bottomley@HansenPartnership.com, bharrosh@panasas.com,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] block: let blk_end_request_all handle bidi requests
Message-ID: <20090511091615.GQ4694@kernel.dk>
References: <1242032169-22422-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1242032169-22422-2-git-send-email-fujita.tomonori@lab.ntt.co.jp> <20090511090629.GO4694@kernel.dk> <20090511181242D.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090511181242D.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 11 2009, FUJITA Tomonori wrote:
> On Mon, 11 May 2009 11:06:30 +0200
> Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > On Mon, May 11 2009, FUJITA Tomonori wrote:
> > > blk_end_request_all() and __blk_end_request_all() should finish all
> > > bytes including bidi, by definition. That's what all bidi users need ,
> > > bidi requests must be complete as a whole (partial completion is
> > > impossible).
> > > 
> > > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > > ---
> > >  include/linux/blkdev.h |   12 ++++++++++--
> > >  1 files changed, 10 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> > > index 8919683..3b5c564 100644
> > > --- a/include/linux/blkdev.h
> > > +++ b/include/linux/blkdev.h
> > > @@ -911,8 +911,12 @@ static inline bool blk_end_request(struct request *rq, int error,
> > >  static inline void blk_end_request_all(struct request *rq, int error)
> > >  {
> > >  	bool pending;
> > > +	unsigned int bidi_bytes = 0;
> > >  
> > > -	pending = blk_end_request(rq, error, blk_rq_bytes(rq));
> > > +	if (unlikely(blk_bidi_rq(rq)))
> > > +		bidi_bytes = blk_rq_bytes(rq->next_rq);
> > > +
> > > +	pending = blk_end_bidi_request(rq, error, blk_rq_bytes(rq), bidi_bytes);
> > >  	BUG_ON(pending);
> > >  }
> > >  
> > > @@ -963,8 +967,12 @@ static inline bool __blk_end_request(struct request *rq, int error,
> > >  static inline void __blk_end_request_all(struct request *rq, int error)
> > >  {
> > >  	bool pending;
> > > +	unsigned int bidi_bytes = 0;
> > > +
> > > +	if (unlikely(blk_bidi_rq(rq)))
> > > +		bidi_bytes = blk_rq_bytes(rq->next_rq);
> > >  
> > > -	pending = __blk_end_request(rq, error, blk_rq_bytes(rq));
> > > +	pending = __blk_end_bidi_request(rq, error, blk_rq_bytes(rq), bidi_bytes);
> > >  	BUG_ON(pending);
> > >  }
> > 
> > Looks ok, perhaps we can next get rid of the bidi naming? It's all
> > pretty much folded into one anyway, using __blk_end_bidi_request() from
> > generic end-request handling looks confusing.
> 
> Yeah, agreed; the bidi name is confusing. I'll send another patch to
> clean up it on the top of this patchset soon.

Thanks!

-- 
Jens Axboe

