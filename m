Return-Path: <linux-kernel-owner+w=401wt.eu-S1761524AbXHAQWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761524AbXHAQWA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 12:22:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754813AbXHAQVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 12:21:53 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:10200 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbXHAQVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 12:21:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=bpHkSi2p1OuWSI0qUvNOn0oFKwEvzmSd30JEe28zdEjDiBAHqonAhOLY9Qj/laxDYZobyb5bpYEjmELPSXLPQApz/TNw0b7dJ3nEXVPLMtcJlnrsva7ex6PeH0ougv+aLW12ESnU2slQxzCmtKAT/yU5nunPFdpyETglyFiSAVE=
Date: Thu, 2 Aug 2007 01:21:45 +0900
From: Tejun Heo <htejun@gmail.com>
To: NeilBrown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 019 of 35] Convert bio_for_each_segment to fill in a fresh bio_vec
Message-ID: <20070801162145.GH13674@htj.dyndns.org>
References: <20070731112539.22428.patches@notabene> <1070731021727.25362@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1070731021727.25362@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jul 31, 2007 at 12:17:27PM +1000, NeilBrown wrote:
> i.e. instread of providing a pointer to each bio_vec, it provides
> a copy of each bio_vec.
> 
> This allows a future patch to cause bio_for_each_segment to
> provide bio_vecs that are not in the bi_io_vec list, thus allowing
> for offsets and length restrictions.
> 
> We consequently remove the only call for bio_kmap_atomic,
> and so remove that function as well.
> Also remove bio_kmap_irq.  No-one uses it, and bvec_kmap_irq
> is a much more usable interface.

I think this patch can be split into two but it's no big deal.

> +struct bio_iterator {
> +	int i;
> +};
>  #define bio_for_each_segment(bvl, bio, i)				\
> -	for (bvl = bio_iovec_idx((bio), 0), i = 0;			\
> -	     i < (bio)->bi_vcnt;					\
> -	     bvl++, i++)
> +	for (i.i = 0, bvl = *bio_iovec_idx((bio), i.i);			\
> +	     i.i < (bio)->bi_vcnt;					\
> +	     i.i++, bvl = *bio_iovec_idx((bio), i.i))

How about something like...

struct bio_iterator {
	int i;
	struct bio_vec tmp_bvec;
	/* might put bio here too? */
};

#define bio_for_each_segment(bvl, bio, i)				\
	for (bvl = bio_iter_init(&i, bio); i.i < (bio)->bi_vcnt;	\
	     bvl = bio_iter_next(&i, bio))

[static inline] struct bio_vec *bio_iter_init(struct bio_iterator *i,
					      struct bio *bio)
{
	i->i = 0;

	if (no further restrictions)
		return bio_iovec_idx(bio, 0);
	else {
		i->tmp_bvec = *bio_iovec_idx(bio, 0);
		apply restriction;
		return &i->tmp_bvec;
	}
}

[static inline] struct bio_vec *bio_iter_next(struct bio_iterator *i,
					      struct bio *bio)
{
	i->i++;

	if (no further restriction)
		return bio_iovec_idx(bio, i->i);
	else {
		i->tmp_bvec = *bio_iovec_idx(bio, i->i);
		apply restriction;
		return &i->tmp_bvec;
	}
}

-- 
tejun
