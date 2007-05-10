Return-Path: <linux-kernel-owner+w=401wt.eu-S1759475AbXEJLYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759475AbXEJLYc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 07:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754809AbXEJLYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 07:24:25 -0400
Received: from brick.kernel.dk ([80.160.20.94]:22249 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753201AbXEJLYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 07:24:25 -0400
Date: Thu, 10 May 2007 13:23:55 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Benny Halevy <bhalevy@panasas.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/13] i386 sg: add support for chaining scatterlists
Message-ID: <20070510112355.GQ4629@kernel.dk>
References: <11787925152319-git-send-email-jens.axboe@oracle.com> <11787925162760-git-send-email-jens.axboe@oracle.com> <4642FB1B.80702@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4642FB1B.80702@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10 2007, Benny Halevy wrote:
> Jens Axboe wrote:
> > +#define sg_is_chain(sg)		((unsigned long) (sg)->page & 0x01)
> > +#define sg_chain_ptr(sg)	\
> > +	((struct scatterlist *) ((unsigned long) (sg)->page & ~0x01))
> > +
> > +/*
> > + * We overload the meaning of ->page for sg chaining. If the LSB is
> > + * set, the page member contains a pointer to the next sgtable.
> > + */
> > +static inline struct scatterlist *sg_next(struct scatterlist *sg)
> > +{
> > +	if (sg_is_chain(sg))
> > +		return sg_chain_ptr(sg);
> > +
> > +	return sg + 1;
> > +}
> 
> Jens, should sg_next ever return the sg containing the chain link?
> If sg points at the entry right before the link entry, don't we
> want to skip it?
> 
> E.g.:
> 
> static inline struct scatterlist *sg_next(struct scatterlist *sg)
> {
> 	struct scatterlist *next;
> 
> 	/* just in case, shouldn't really ever be here */
> 	if (sg_is_chain(sg))
> 		return sg_chain_ptr(sg);
> 
> 	next = sg + 1;
> 
> 	if (sg_is_chain(next))
> 		return sg_chain_ptr(next);
> 
> 	return next;
> }

You are right, I got that mixed up, I changed the setup to overloading
->page right before posting it. So:

static inline struct scatterlist *sg_next(struct scatterlist *sg)
{
        sg++;

        if (unlikely(sg_is_chain(sg)))
                sg = sg_chain_ptr(sg);

        return sg;
}

-- 
Jens Axboe

