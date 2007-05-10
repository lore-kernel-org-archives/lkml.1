Return-Path: <linux-kernel-owner+w=401wt.eu-S1760142AbXEJKmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760142AbXEJKmy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 06:42:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754992AbXEJKmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 06:42:47 -0400
Received: from brick.kernel.dk ([80.160.20.94]:5975 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754794AbXEJKmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 06:42:46 -0400
Date: Thu, 10 May 2007 12:42:17 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/13] Add sg helpers for iterating over a scatterlist  table
Message-ID: <20070510104216.GK4629@kernel.dk>
References: <11787925152319-git-send-email-jens.axboe@oracle.com> <11787925152357-git-send-email-jens.axboe@oracle.com> <20070510033956.9eebe437.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070510033956.9eebe437.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10 2007, Andrew Morton wrote:
> On Thu, 10 May 2007 12:21:44 +0200 Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > First step to being able to change the scatterlist setup without
> > having to modify drivers (a lot :-)
> > 
> > Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> > ---
> >  include/linux/scatterlist.h |    9 +++++++++
> >  1 files changed, 9 insertions(+), 0 deletions(-)
> > 
> > diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
> > index 4efbd9c..c5bffde 100644
> > --- a/include/linux/scatterlist.h
> > +++ b/include/linux/scatterlist.h
> > @@ -20,4 +20,13 @@ static inline void sg_init_one(struct scatterlist *sg, const void *buf,
> >  	sg_set_buf(sg, buf, buflen);
> >  }
> >  
> > +#define sg_next(sg)		((sg) + 1)
> > +#define sg_last(sg, nents)	(&(sg[nents - 1]))
> 
> Looks a bit underparenthesised.
> 
> > +/*
> > + * Loop over each sg element, following the pointer to a new list if necessary
> > + */
> > +#define for_each_sg(sglist, sg, nr, __i)	\
> > +	for (__i = 0, sg = (sglist); __i < nr; __i++, sg = sg_next(sg))
> > +
> 
> So does this.

Yeah I know, both of these are fixed up when the chain support is added
(patch 07). So I didn't bother fixing these up, but I will make a note
of it for the first round.

> I don't see how it "follows the pointer to a new list".  All it's doing is
> iterating across an array?

It doesn't, this first patch just allows you to convert drivers to
using for_each_sg() to loop over sg elements. Then you can later
introduce sg chaining behind their back, they don't have to know about
that.

Patch 07 is the one that enables sg chaining for x86 and includes the
generic bits for linux/scatterlist.h.

-- 
Jens Axboe

