Return-Path: <linux-kernel-owner+w=401wt.eu-S1760484AbXJYLyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760484AbXJYLyo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 07:54:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756375AbXJYLyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 07:54:35 -0400
Received: from ozlabs.org ([203.10.76.45]:57147 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756036AbXJYLye convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 07:54:34 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 09/10] Change table chaining layout
Date: Thu, 25 Oct 2007 21:54:44 +1000
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Boaz Harrosh <bharrosh@panasas.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>, mingo@elte.hu
References: <1193076664-13652-10-git-send-email-jens.axboe@oracle.com> <200710251840.02157.rusty@rustcorp.com.au> <20071025091140.GK5053@kernel.dk>
In-Reply-To: <20071025091140.GK5053@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200710252154.45542.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 October 2007 19:11:40 Jens Axboe wrote:
> On Thu, Oct 25 2007, Rusty Russell wrote:
> > What irritates me more is that scatterlists aren't quite generically
> > useful. The virtio code wants to join a scatterlist created by
> > blk_rq_map_sg() with two others, yet it won't work because sg_chain()
> > doesn't remove the end marker from the first entry.
>
> That's a minor nit for your special purpose, we/you can change that.

Well currently sg_chain() only joins "incomplete" (ie. unterminated) sg 
chains.  That works great for you, but it feels more like a special purpose 
to me.

> > If this patch weren't already included, I'd be strongly arguing for the
> > bio idea: I find the chained sg code tricksy and ugly (sorry Jens).
>
> What is the bio idea? A bio works in essentially the same way, the only
> difference is having a specific next pointer. It's still just a linked
> lists of arbitrarily sized sg tables (the bio_vec arrays).

It was suggested by analogy earlier in this thread, to use a two-level 
structure.

In this case I would have first renamed struct scatterlist to struct 
scatterelem.  Then struct scatterlist looks like:

	struct scatterlist {
		unsigned int num;
		struct scatterelem elems[0];
	};

We'd want a nice macro to declare them for the stack case:

#define DEFINE_SCATTERLIST(name, elems)		\
	struct {				\
		struct scatterlist sg;		\
		struct scatterelem elems[num];	\
	} name

Now we've tied the number and array together, we can introduce:

struct sg_multilist
{
	unsigned int num_scatterlists;
	struct scatterlist *sg_array[0];
};

And, of course, a common way to represent a one-sglist array:

#define DEFINE_SG_MULTI(name, num)			\
	struct {					\
		struct sg_multilist ml;			\
		struct scatterlist *sg_array;		\
		struct scatterlist sg;			\
		struct scatterelem elems[num];		\
	} name = { .ml = { 1 }, .sg_array = &name.sg }

Now simply replace all the places which expect a "struct scatterlist" 
with "struct sg_multilist" and we're done.

Using dangling structures is not as neat as using pointers, but it's very 
efficient.

> > @@ -778,7 +778,7 @@ struct scatterlist *scsi_alloc_sgtable(struct
> > scsi_cmnd *cmd, gfp_t gfp_mask) * ended up doing another loop.
> >  		 */
> >  		if (prev)
> > -			sg_chain(prev, SCSI_MAX_SG_SEGMENTS, sgl);
> > +			sg_chain(prev, SCSI_MAX_SG_SEGMENTS-1, sgl);
>
> What's this bit for?

I changed the sg_chain() function not to take one off the argument.  It made 
more sense when I wrote the virtblk code (here it's natural, since the num 
elements used + 1 == size of array).

> > -     prv[prv_nents - 1].page_link = (unsigned long) sgl | 0x01;
> > +     if (prv_nents > 0)
> > +             prv[prv_nents - 1].page_link &= ~0x02UL;
> > +     prv[prv_nents].page_link = (unsigned long) sgl | 0x01;
> >  }
> We definitely should clear any other markers, that makes sense.

Agreed, and it was the use of "prv_nents - 2" in that code which made me think 
the arg should be "num used" not "one past the num used".

Cheers,
Rusty.
