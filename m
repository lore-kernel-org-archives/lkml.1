Return-Path: <linux-kernel-owner+w=401wt.eu-S1758671AbXJ3Jf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758671AbXJ3Jf6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 05:35:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758338AbXJ3Jeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 05:34:46 -0400
Received: from brick.kernel.dk ([87.55.233.238]:21395 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757995AbXJ3Jeo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 05:34:44 -0400
Date: Tue, 30 Oct 2007 10:32:13 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
       netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] [CRYPTO] tcrypt: Move sg_init_table out of timing
	loops
Message-ID: <20071030093213.GH4993@kernel.dk>
References: <20071026145905.GA13850@gondor.apana.org.au> <E1IlQfM-0003cO-00@gondolin.me.apana.org.au> <20071029201627.GD7499@kernel.dk> <4726FA01.2030002@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4726FA01.2030002@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30 2007, Boaz Harrosh wrote:
> On Mon, Oct 29 2007 at 22:16 +0200, Jens Axboe <jens.axboe@oracle.com> wrote:
> > On Fri, Oct 26 2007, Herbert Xu wrote:
> >> [CRYPTO] tcrypt: Move sg_init_table out of timing loops
> >>
> >> This patch moves the sg_init_table out of the timing loops for hash
> >> algorithms so that it doesn't impact on the speed test results.
> > 
> > Wouldn't it be better to just make sg_init_one() call sg_init_table?
> > 
> > diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
> > index 4571231..ccc55a6 100644
> > --- a/include/linux/scatterlist.h
> > +++ b/include/linux/scatterlist.h
> > @@ -202,28 +202,6 @@ static inline void __sg_mark_end(struct scatterlist *sg)
> >  }
> >  
> >  /**
> > - * sg_init_one - Initialize a single entry sg list
> > - * @sg:		 SG entry
> > - * @buf:	 Virtual address for IO
> > - * @buflen:	 IO length
> > - *
> > - * Notes:
> > - *   This should not be used on a single entry that is part of a larger
> > - *   table. Use sg_init_table() for that.
> > - *
> > - **/
> > -static inline void sg_init_one(struct scatterlist *sg, const void *buf,
> > -			       unsigned int buflen)
> > -{
> > -	memset(sg, 0, sizeof(*sg));
> > -#ifdef CONFIG_DEBUG_SG
> > -	sg->sg_magic = SG_MAGIC;
> > -#endif
> > -	sg_mark_end(sg, 1);
> > -	sg_set_buf(sg, buf, buflen);
> > -}
> > -
> > -/**
> >   * sg_init_table - Initialize SG table
> >   * @sgl:	   The SG table
> >   * @nents:	   Number of entries in table
> > @@ -247,6 +225,24 @@ static inline void sg_init_table(struct scatterlist *sgl, unsigned int nents)
> >  }
> >  
> >  /**
> > + * sg_init_one - Initialize a single entry sg list
> > + * @sg:		 SG entry
> > + * @buf:	 Virtual address for IO
> > + * @buflen:	 IO length
> > + *
> > + * Notes:
> > + *   This should not be used on a single entry that is part of a larger
> > + *   table. Use sg_init_table() for that.
> > + *
> > + **/
> > +static inline void sg_init_one(struct scatterlist *sg, const void *buf,
> > +			       unsigned int buflen)
> > +{
> > +	sg_init_table(sg, 1);
> > +	sg_set_buf(sg, buf, buflen);
> > +}
> > +
> > +/**
> >   * sg_phys - Return physical address of an sg entry
> >   * @sg:	     SG entry
> >   *
> > 
> Yes please submit this patch. scsi-ml is full of sg_init_one, specially
> on the error recovery path.

Will do.

-- 
Jens Axboe

