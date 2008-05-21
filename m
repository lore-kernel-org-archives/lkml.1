Return-Path: <linux-kernel-owner+w=401wt.eu-S1758927AbYEUHTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758927AbYEUHTt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 03:19:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764313AbYEUHTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 03:19:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45277 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756134AbYEUHTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 03:19:34 -0400
Date: Wed, 21 May 2008 00:19:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] VFS: Pagecache usage optimization on pagesize !=
 blocksize environment
Message-Id: <20080521001930.202446eb.akpm@linux-foundation.org>
In-Reply-To: <6.0.0.20.2.20080513205758.03a7a6b0@172.19.0.2>
References: <6.0.0.20.2.20080513205758.03a7a6b0@172.19.0.2>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2008 15:52:04 +0900 Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp> wrote:

> Hi.
> 
> When we read some part of a file through pagecache, if there is a pagecache 
> of corresponding index but this page is not uptodate, read IO is issued and
> this page will be uptodate.
> I think this is good for pagesize == blocksize environment but there is room
> for improvement on pagesize != blocksize environment. Because in this case
> a page can have multiple buffers and even if a page is not uptodate, some buffers 
> can be uptodate. So I suggest that when all buffers which correspond to a part
> of a file that we want to read are uptodate, use this pagecache and copy data
> from this pagecache to user buffer even if a page is not uptodate. This can
> reduce read IO and improve system throughput.

I suppose that makes sense.

> I did a performance test using the sysbench.

That's not a terribly good benchmark, IMO.  It's too complex.

To work out the best-case for a change like this I'd suggest a
microbenchmark which does something such as seeking all around a file
doing single-byte reads.

Then one should think up a benchmark which demonstrates the worst-case,
such as reading one-byte-quantities from a file at offsets 0, 0x2000,
0x4000, 0x6000, ...  and then read more one-byte-quantities at offsets
0x1000, 0x3000, 0x5000, etc.  That would be a pretty cruel comparison,
but as one tosses in more such artificial worklaods, one is in a better
position to work out whether the change is an aggregate benefit.

The results from a great big lumped-together benchmark such as sysbench 
aren't a lot of use to us in predicting how effective this change will
be across all the workloads which the kernel implements.

> @@ -932,8 +932,16 @@ find_page:
>  					ra, filp, page,
>  					index, last_index - index);
>  		}
> -		if (!PageUptodate(page))
> -			goto page_not_up_to_date;
> +		if (!PageUptodate(page)) {
> +			if (inode->i_blkbits == PAGE_CACHE_SHIFT)
> +				goto page_not_up_to_date;
> +			if (TestSetPageLocked(page))
> +				goto page_not_up_to_date;
> +			if (!page_has_buffers(page) ||
> +			      !check_buffers_uptodate(offset, desc, page))

We shouldn't do this.

> +				goto page_not_up_to_date_locked;
> +			unlock_page(page);
> +		}

See, the code which you have here is assuming that if PagePrivate is
set, then the thing which is at page.private is a ring of buffer_heads.

But this code (do_generic_file_read) doesn't know that!  Take a look at
afs, nfs, perhaps other filesystems, grep for set_page_private().

Only the address_space implementation (ie: the filesystem) knows
whether page.private holds buffer_heads and only the
address_space_operations functions are allowed to call into library
functions which treat page.private as a buffer_head ring.

Now, your code _may_ not crash, because perhaps there is no filesystem
which puts something else into page.private which also uses
do_generic_file_read().  But it's still wrong.

I guess a suitable fix might be to implement the above using a new
address_space_operations callback:

	if (PagePrivate(page) && aops->is_partially_uptodate) {
		if (aops->is_partially_uptodate(page, desc, offset))
			<OK, we can copy the data>

then implement a generic_file_is_partially_uptodate() in fs/buffer.c
and wire that up in the filesystems.

Note that things like network filesystems can then implement this also.
