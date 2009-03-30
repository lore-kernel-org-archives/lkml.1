Return-Path: <linux-kernel-owner+w=401wt.eu-S1753744AbZC3Mgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744AbZC3Mgf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 08:36:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753585AbZC3MgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 08:36:22 -0400
Received: from brick.kernel.dk ([93.163.65.50]:49509 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753512AbZC3MgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 08:36:21 -0400
Date: Mon, 30 Mar 2009 14:36:18 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
Cc: Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       chris.mason@oracle.com, david@fromorbit.com, tj@kernel.org
Subject: Re: [PATCH 5/7] vfs: Add  wbcflush sysfs knob to disable storage
	device  writeback cache flushes
Message-ID: <20090330123618.GS5178@kernel.dk>
References: <20090325212923.GA5620@havoc.gtf.org> <20090326032445.GA16999@havoc.gtf.org> <20090327205046.GA2036@havoc.gtf.org> <20090329082507.GA4242@infradead.org> <49D01F94.6000101@oss.ntt.co.jp> <49D02328.7060108@oss.ntt.co.jp> <49D0258A.9020306@garzik.org> <49D03377.1040909@oss.ntt.co.jp> <49D0B535.2010106@oss.ntt.co.jp> <49D0B978.5030107@oss.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49D0B978.5030107@oss.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30 2009, Fernando Luis Vázquez Cao wrote:
> Add a sysfs knob to disable storage device writeback cache flushes.
>
> Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
> ---
>
> diff -urNp linux-2.6.29-orig/block/blk-barrier.c linux-2.6.29/block/blk-barrier.c
> --- linux-2.6.29-orig/block/blk-barrier.c	2009-03-24 08:12:14.000000000 +0900
> +++ linux-2.6.29/block/blk-barrier.c	2009-03-30 17:08:28.000000000 +0900
> @@ -318,6 +318,9 @@ int blkdev_issue_flush(struct block_devi
>  	if (!q)
>  		return -ENXIO;
>
> +	if (blk_queue_nowbcflush(q))
> +		return -EOPNOTSUPP;
> +
>  	bio = bio_alloc(GFP_KERNEL, 0);
>  	if (!bio)
>  		return -ENOMEM;
> diff -urNp linux-2.6.29-orig/block/blk-core.c linux-2.6.29/block/blk-core.c
> --- linux-2.6.29-orig/block/blk-core.c	2009-03-24 08:12:14.000000000 +0900
> +++ linux-2.6.29/block/blk-core.c	2009-03-30 17:08:28.000000000 +0900
> @@ -1452,7 +1452,8 @@ static inline void __generic_make_reques
>  			goto end_io;
>  		}
>  		if (bio_barrier(bio) && bio_has_data(bio) &&
> -		    (q->next_ordered == QUEUE_ORDERED_NONE)) {
> +		    (blk_queue_nowbcflush(q) ||
> +		     q->next_ordered == QUEUE_ORDERED_NONE)) {
>  			err = -EOPNOTSUPP;
>  			goto end_io;
>  		}

This (and the above hunk) should be changed. -EOPNOTSUPP means the
target does not support barriers, that is a different thing to flushes
not being needed. A file system issuing a barrier and getting
-EOPNOTSUPP back will disable barriers, since it now thinks that
ordering cannot be guaranteed.

A more appropriate change would be to successfully complete a flush
without actually sending it down to the device if blk_queue_nowbcflush()
is true. Then blkdev_issue_flush() would just work as well. It also
needs to take stacking into account, or stacked drivers will have to
propagate the settings up the stack. If you allow simply the barrier to
be passed down, you get that for free.

> +static struct queue_sysfs_entry queue_wbcflush_entry = {
> +	.attr = {.name = "wbcflush", .mode = S_IRUGO | S_IWUSR },
> +	.show = queue_wbcflush_show,
> +	.store = queue_wbcflush_store,
> +};
> +

Naming is also pretty bad, perhaps something like "honor_cache_flush"
would be better, or perhaps "cache_flush_needed". At least something
that is more descriptive of this setting actually controls, wbcflush
does not do that.

-- 
Jens Axboe

