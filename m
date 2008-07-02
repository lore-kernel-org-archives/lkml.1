Return-Path: <linux-kernel-owner+w=401wt.eu-S1756051AbYGBIZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051AbYGBIZd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 04:25:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752345AbYGBIZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 04:25:16 -0400
Received: from brick.kernel.dk ([87.55.233.238]:29228 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752427AbYGBIZO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 04:25:14 -0400
Date: Wed, 2 Jul 2008 10:25:11 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 1/2] Avoid bio_endio recursion
Message-ID: <20080702082511.GF20055@kernel.dk>
References: <Pine.LNX.4.64.0806240118250.24220@engineering.redhat.com> <20080624080744.GL20851@kernel.dk> <Pine.LNX.4.64.0806241017390.23052@engineering.redhat.com> <20080625082421.GU20851@kernel.dk> <Pine.LNX.4.64.0806252008380.11130@engineering.redhat.com> <20080626070723.GL20851@kernel.dk> <Pine.LNX.4.64.0807020001290.9097@engineering.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0807020001290.9097@engineering.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02 2008, Mikulas Patocka wrote:
> >Right, that wont work of course. Completions are typically done through
> >a softirq, so it is not currently done with hard interrupts disabled.
> 
> I thought, from hardirq - that's what IDE is doing. And they are called 
> with interrupts disabled (maybe unless you specify unmaskirq, which is not 
> default). What block driver does completions with softirq? ... and why?

The key word is 'typically', the old IDE driver really isn't used very
much. The SCSI layer and eg cciss uses the block layer softirq
completions, so that is what 99% of the uses will be.

> >So it's a bit of a shame to impose this extra restriction, bio unrolling 
> >is necessarily a really short operation. We could reenable around the 
> >bi_end_io() call, but then we'd need to save and restore for each bio.
> 
> I found another weird thing --- why does local_irq_save() execute that 
> microcoded "cli" instruction even if interrupts are already disabled? That 
> could be definitely optimized.
> 
> And does local_irq_restore() need to execute even more costy "popf" when 
> it makes a transition from disabled to disabled state? What's 
> local_irq_restore semantics --- is it allowed to use local_irq_restore for 
> transition from interrupt-enabled state into interrupt-disabled state?

That's a question for the arch people. Probably nested _save and
_restore aren't optimized.

> 
> >Please make that
> >
> >       bio->bi_flags &= ~(1 << BIO_SEG_VALID);
> >       bio->bi_phys_segments = error;
> 
> OK, here is the updated patch:
> 
> Avoid recursion on bio_endio. bio_endio calls bio->bi_end_io which may in 
> turn
> call bio_endio again. When this recursion happens, put the new bio to the 
> queue
> and process it later, from the top-level bio_endio.

Thanks that looks good, I'll throw this into the testing mix and see
what happens.

>  void bio_pair_release(struct bio_pair *bp)
> Index: linux-2.6.26-rc8-devel/include/linux/bio.h
> ===================================================================
> --- linux-2.6.26-rc8-devel.orig/include/linux/bio.h	2008-07-02 
> 04:20:43.000000000 +0200
> +++ linux-2.6.26-rc8-devel/include/linux/bio.h	2008-07-02 
> 04:21:16.000000000 +0200
> @@ -86,6 +86,9 @@ struct bio {
> 
>  	/* Number of segments in this BIO after
>  	 * physical address coalescing is performed.
> +	 *
> +	 * When ending a bio request in bio_endio, this field is temporarily
> +	 * (ab)used to keep the error code.
>  	 */
>  	unsigned short		bi_phys_segments;

I'll drop this comment, we don't really need it. Users must use
bio_phys_segments() to retrieve the segment count anyway, in which case
the count is ALWAYS valid.

-- 
Jens Axboe

