Return-Path: <linux-kernel-owner+w=401wt.eu-S932997AbXBLFds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932997AbXBLFds (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 00:33:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933001AbXBLFds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 00:33:48 -0500
Received: from brick.kernel.dk ([62.242.22.158]:24429 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932997AbXBLFdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 00:33:47 -0500
Date: Mon, 12 Feb 2007 06:33:56 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.osdl.org>
Subject: Re: [PATCH 7/8] lguest: trivial guest block driver
Message-ID: <20070212053356.GC3999@kernel.dk>
References: <1171251894.10409.26.camel@localhost.localdomain> <1171251965.10409.28.camel@localhost.localdomain> <1171252113.10409.30.camel@localhost.localdomain> <1171252219.10409.33.camel@localhost.localdomain> <1171252321.10409.36.camel@localhost.localdomain> <1171252405.10409.39.camel@localhost.localdomain> <1171252474.10409.42.camel@localhost.localdomain> <20070212044339.GJ3685@kernel.dk> <1171258034.10409.54.camel@localhost.localdomain> <20070212053204.GB3999@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070212053204.GB3999@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 12 2007, Jens Axboe wrote:
> On Mon, Feb 12 2007, Rusty Russell wrote:
> > On Mon, 2007-02-12 at 05:43 +0100, Jens Axboe wrote:
> > > On Mon, Feb 12 2007, Rusty Russell wrote:
> > > > +	end_request(bd->req, bd->lb_page->result == 1);
> > >
> > > You are using the old-style end request handling. So while I generally
> > > discourage use of end_request(), you seem to have a bigger problem here:
> > 
> > > > +	rq_for_each_bio(bio, req) {
> > > > +		struct bio_vec *bvec;
> > > > +		bio_for_each_segment(bvec, bio, idx) {
> > > > +			BUG_ON(i == LGUEST_MAX_DMA_SECTIONS);
> > > > +			BUG_ON(!bvec->bv_len);
> > > > +			dma->addr[i] = page_to_phys(bvec->bv_page)
> > > > +				+ bvec->bv_offset;
> > > > +			dma->len[i] = bvec->bv_len;
> > > > +			len += bvec->bv_len;
> > > > +			i++;
> > > > +		}
> > > > +	}
> > > > +	if (i < LGUEST_MAX_DMA_SECTIONS)
> > > > +		dma->len[i] = 0;
> > > > +	return len;
> > > > +}
> > > 
> > > Here you map the entire request (lets call that segment A..Z), but
> > > end_request() only completes the first chunk of the request. So
> > > elv_next_request() will retrieve the same request again, and you'll then
> > > map B..Z and repeat that transfer. So unless I'm missing some other part
> > > here (just read it over quickly), you are re-doing large parts of a
> > > merged request several times.
> > > 
> > > So: don't use end_request(). Add some driver helper that does:
> > > 
> > > static void lgb_end_request(struct blockdev *bd)
> > > {
> > >         int uptodate = bd->lb_page->result == 1;
> > >         struct request *rq = bd->req;
> > > 
> > >         end_that_request_first(rq, uptodate, req->hard_nr_sectors);
> > >         add_disk_randomness(rq->rq_disk);
> > >         blkdev_dequeue_request(rq);
> > >         end_that_request_last(rq, uptodate);
> > > }
> > > 
> > > We could probably even make that a block layer helper, I'm sure others
> > > could be cleaned up with that as well. You want to use that helper in
> > > do_lgb_request() as well.
> > 
> > I'm confused.  That code looks like end_request:
> > 
> > void end_request(struct request *req, int uptodate)
> > {
> > 	if (!end_that_request_first(req, uptodate, req->hard_cur_sectors)) {
> > 		add_disk_randomness(req->rq_disk);
> > 		blkdev_dequeue_request(req);
> > 		end_that_request_last(req, uptodate);
> > 	}
> > }
> 
> Note hard_cur_sectors vs hard_nr_sectors. The former refers to the first
> segment sector count, the latter to the total sector count in the
> request. Hence the difference!

Also, that is why my example code doesn't check the
end_that_request_first() return value, it must be 0 or it would be
buggy. Alternatively,

        if (end_that_request_first(rq, uptodate, rq->hard_nr_sectors))
                BUG()

would make that more clear. Or just a nice little comment. Anyway, if
you fixup lguest I'll add a kernel helper that we can switch it to once
merged.

-- 
Jens Axboe

