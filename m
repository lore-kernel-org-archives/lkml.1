Return-Path: <linux-kernel-owner+w=401wt.eu-S1754203AbYFZHHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbYFZHHh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 03:07:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751409AbYFZHH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 03:07:27 -0400
Received: from brick.kernel.dk ([87.55.233.238]:20255 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750783AbYFZHH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 03:07:26 -0400
Date: Thu, 26 Jun 2008 09:07:24 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 1/2] Avoid bio_endio recursion
Message-ID: <20080626070723.GL20851@kernel.dk>
References: <Pine.LNX.4.64.0806240118250.24220@engineering.redhat.com> <20080624080744.GL20851@kernel.dk> <Pine.LNX.4.64.0806241017390.23052@engineering.redhat.com> <20080625082421.GU20851@kernel.dk> <Pine.LNX.4.64.0806252008380.11130@engineering.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0806252008380.11130@engineering.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25 2008, Mikulas Patocka wrote:
> On Wed, 25 Jun 2008, Jens Axboe wrote:
> 
> >On Tue, Jun 24 2008, Mikulas Patocka wrote:
> >>
> >>
> >>On Tue, 24 Jun 2008, Jens Axboe wrote:
> >>
> >>>On Tue, Jun 24 2008, Mikulas Patocka wrote:
> >>>>Hi
> >>>>
> >>>>bio_endio calls bi_end_io callback. In case of stacked devices (raid, 
> >>>>dm),
> >>>>bio_end_io may call bio_endio again, up to an unspecified length.
> >>>>
> >>>>The crash because of stack overflow was really observed on sparc64. And
> >>>>this recursion was one of the contributing factors (using 9 stack frames
> >>>>--- that is 1728 bytes).
> >>>
> >>>Looks good, I like the concept. Can you please make it a little less
> >>>goto driven, though? The next_bio and goto next_bio could just be a
> >>>while().
> >>>
> >>>--
> >>>Jens Axboe
> >>>
> >>
> >>Hi.
> >>
> >>This is the patch, slightly de-goto-ized. (it still contains one, I think
> >>that while (1) { ... break ... } is no better readable than goto).
> >
> >Sure, that looks better.
> >
> >>I found another problem in my previous patch, I forgot about the "error"
> >>variable (it would cause misbehavior for example if disk fails, submits an
> >>error and raid driver turns this failure into success). We need to save
> >>the error variable somewhere in the bio, there is no other place where it
> >>could be placed. I temporarily saved it to bi_idx, because it's unused at
> >>this place.
> >
> >I don't think bi_idx is a fantastic idea, I could easily imagine the
> >bi_end_io function wanting to do a segment loop on the bio. Use
> >bi_phys_segments instead (or bi_hw_segemnts, no difference), they should
> >only be used when queuing and building IO, not for completion purposes.
> >And put a big fat comment there explaining the overload. Plus they are
> >just a cache, so if you use either of those and at the same time clear
> >BIO_SEG_VALID in bi_flags, then it's guarenteed to be safe.
> 
> Here is new patch that uses bi_phys_segments.
> 
> >Also please put the per-cpu definition outside of bio_endio(). And I
> >don't think you need to disable interrupts, a plain preempt_disable() /
> >preempt_enable() should be enough.
> 
> Disabling interrupts is needed. If you disable only preempt, interrupt can 
> come at any point and add anything to the queue. You'd have to use local_t 
> and local_cmpxchg tricks then and the code would be much more ugly. I 
> found that the code is called with interrupts disabled most time, so it 
> doesn't matter if I disable them again.

Right, that wont work of course. Completions are typically done through
a softirq, so it is not currently done with hard interrupts disabled. So
it's a bit of a shame to impose this extra restriction, bio unrolling is
necessarily a really short operation. We could reenable around the
bi_end_io() call, but then we'd need to save and restore for each bio.

> 
> Mikulas
> 
> >-- 
> >Jens Axboe
> 
> Avoid recursion on bio_endio. bio_endio calls bio->bi_end_io which may in 
> turn
> call bio_endio again. When this recursion happens, put the new bio to the 
> queue
> and process it later, from the top-level bio_endio.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> ---
>  fs/bio.c            |   38 +++++++++++++++++++++++++++++++++++---
>  include/linux/bio.h |    3 +++
>  2 files changed, 38 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6.26-rc7-devel/fs/bio.c
> ===================================================================
> --- linux-2.6.26-rc7-devel.orig/fs/bio.c	2008-06-23 
> 13:49:45.000000000 +0200
> +++ linux-2.6.26-rc7-devel/fs/bio.c	2008-06-25 18:09:48.000000000 +0200
> @@ -1166,15 +1166,47 @@ void bio_check_pages_dirty(struct bio *b
>   *   bio unless they own it and thus know that it has an end_io
>   *   function.
>   **/
> +static DEFINE_PER_CPU(struct bio **, bio_end_queue) = { NULL };
> +
>  void bio_endio(struct bio *bio, int error)
>  {
> +	struct bio ***bio_end_queue_ptr;
> +	struct bio *bio_queue;
> +
> +	unsigned long flags;
> +
> +	bio->bi_phys_segments = error;

Please make that

        bio->bi_flags &= ~(1 << BIO_SEG_VALID);
        bio->bi_phys_segments = error;

as I mentioned, since then we have nothing to worry about. Otherwise
bio_phys_segments() could return a completely wrong count.

>  	if (error)
>  		clear_bit(BIO_UPTODATE, &bio->bi_flags);
>  	else if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
> -		error = -EIO;
> +		bio->bi_phys_segments = -EIO;
> +
> +	local_irq_save(flags);
> +	bio_end_queue_ptr = &__get_cpu_var(bio_end_queue);
> +
> +	if (*bio_end_queue_ptr) {
> +		**bio_end_queue_ptr = bio;
> +		*bio_end_queue_ptr = &bio->bi_next;
> +		bio->bi_next = NULL;
> +	} else {
> +		bio_queue = NULL;
> +		*bio_end_queue_ptr = &bio_queue;
> +
> +next_bio:
> +		if (bio->bi_end_io)
> +			bio->bi_end_io(bio, (short)bio->bi_phys_segments);
> +
> +		if (bio_queue) {
> +			bio = bio_queue;
> +			bio_queue = bio->bi_next;
> +			if (!bio_queue)
> +				*bio_end_queue_ptr = &bio_queue;
> +			goto next_bio;
> +		}
> +		*bio_end_queue_ptr = NULL;
> +	}
> 
> -	if (bio->bi_end_io)
> -		bio->bi_end_io(bio, error);
> +	local_irq_restore(flags);
>  }
> 
>  void bio_pair_release(struct bio_pair *bp)
> Index: linux-2.6.26-rc7-devel/include/linux/bio.h
> ===================================================================
> --- linux-2.6.26-rc7-devel.orig/include/linux/bio.h	2008-06-25 
> 18:06:59.000000000 +0200
> +++ linux-2.6.26-rc7-devel/include/linux/bio.h	2008-06-25 
> 18:08:08.000000000 +0200
> @@ -86,6 +86,9 @@ struct bio {
> 
>  	/* Number of segments in this BIO after
>  	 * physical address coalescing is performed.
> +	 *
> +	 * When ending a bio request in bio_endio, this field is temporarily
> +	 * (ab)used to keep the error code.
>  	 */
>  	unsigned short		bi_phys_segments;
> 

-- 
Jens Axboe

