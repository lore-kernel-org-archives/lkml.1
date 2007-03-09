Return-Path: <linux-kernel-owner+w=401wt.eu-S965777AbXCIIKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965777AbXCIIKi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 03:10:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752610AbXCIIKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 03:10:38 -0500
Received: from brick.kernel.dk ([62.242.22.158]:14006 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752048AbXCIIKh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 03:10:37 -0500
Date: Fri, 9 Mar 2007 09:09:10 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Hellwig <hch@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andrew Morton <akpm@osdl.org>,
       Andi Kleen <ak@muc.de>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/9] lguest: block device speedup
Message-ID: <20070309080909.GD7331@kernel.dk>
References: <1173409524.32234.67.camel@localhost.localdomain> <20070309075123.GC8798@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070309075123.GC8798@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09 2007, Christoph Hellwig wrote:
> On Fri, Mar 09, 2007 at 02:05:24PM +1100, Rusty Russell wrote:
> > diff -r fdc8cbc1fd61 drivers/block/lguest_blk.c
> > --- a/drivers/block/lguest_blk.c	Thu Mar 08 13:35:39 2007 +1100
> > +++ b/drivers/block/lguest_blk.c	Thu Mar 08 15:51:55 2007 +1100
> > @@ -45,6 +45,16 @@ struct blockdev
> >  	struct request *req;
> >  };
> >  
> > +/* Jens gave me this nice helper to end all chunks of a request. */
> > +static void end_entire_request(struct request *req, int uptodate)
> > +{
> > +	if (end_that_request_first(req, uptodate, req->hard_nr_sectors))
> > +		BUG();
> > +	add_disk_randomness(req->rq_disk);
> > +	blkdev_dequeue_request(req);
> > +	end_that_request_last(req, uptodate);
> > +}
> 
> I think we really want this in common code, ll_rw_blk.c should have:

Yeah I know, this is also what I wrote to Rusty when I reviewed this
code and made the suggestion. The kernel also needs a full sweep to get
rid of end_request() entirely, it's really a relic from ancient times.

-- 
Jens Axboe

