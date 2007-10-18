Return-Path: <linux-kernel-owner+w=401wt.eu-S1765662AbXJRN4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765662AbXJRN4i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 09:56:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762654AbXJRN4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 09:56:08 -0400
Received: from brick.kernel.dk ([87.55.233.238]:10228 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762423AbXJRN4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 09:56:07 -0400
Date: Thu, 18 Oct 2007 15:55:28 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Benny Halevy <bhalevy@panasas.com>
Cc: David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu,
       linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       alan@lxorguk.ukuu.org.uk, tomof@acm.org
Subject: Re: [bug] ata subsystem related crash with latest -git
Message-ID: <20071018135526.GK5063@kernel.dk>
References: <20071018082145.GK5063@kernel.dk> <20071018.045505.106265100.davem@davemloft.net> <20071018115702.GW5063@kernel.dk> <20071018.050554.115911163.davem@davemloft.net> <20071018120950.GX5063@kernel.dk> <20071018121547.GY5063@kernel.dk> <20071018125840.GF5063@kernel.dk> <20071018133200.GH5063@kernel.dk> <47176483.8030103@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47176483.8030103@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18 2007, Benny Halevy wrote:
> On Oct. 18, 2007, 15:32 +0200, Jens Axboe <jens.axboe@oracle.com> wrote:
> >  static inline struct scatterlist *sg_next(struct scatterlist *sg)
> >  {
> > -	sg++;
> > -
> > -	if (unlikely(sg_is_chain(sg)))
> > +#ifdef CONFIG_DEBUG_SG
> > +	BUG_ON(sg->sg_magic != SG_MAGIC);
> > +#endif
> > +	if (sg_is_last(sg))
> > +		sg = NULL;
> > +	else if (sg_is_chain(sg))
> >  		sg = sg_chain_ptr(sg);
> > +	else
> > +		sg++;
> >  
> 
> Jens, again, please correct me if I'm wrong, but when sg points at the
> entry right before a chain entry this implementation of sg_next will
> return a pointer to the chain entry here, which I believe it must not.
> 
> >  	return sg;
> >  }
> > 
> 
> here's how I think sg_next should be implemented:
> 
>   */
>  static inline struct scatterlist *sg_next(struct scatterlist *sg)
>  {
> +#ifdef CONFIG_DEBUG_SG
> +	BUG_ON(sg->sg_magic != SG_MAGIC);
> +#endif
> +	if (sg_is_last(sg))
> +		return NULL;
> +
>  	sg++;
>  
>  	if (unlikely(sg_is_chain(sg)))
>  		sg = sg_chain_ptr(sg);
>  
>  	return sg;
>  }

Yep, thanks for catching that!

-- 
Jens Axboe

