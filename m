Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201Ab0BAIa3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 03:30:29 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58010 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751329Ab0BAIaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 03:30:25 -0500
Date: Mon, 1 Feb 2010 17:39:03 +1100
From: Nick Piggin <npiggin@suse.de>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Dave Chinner <david@fromorbit.com>,
       Christoph Lameter <clameter@sgi.com>, Rik van Riel <riel@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
       Miklos Szeredi <miklos@szeredi.hu>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickins <hugh@veritas.com>,
       linux-kernel@vger.kernel.org
Subject: Re: buffer heads: Support slab defrag
Message-ID: <20100201063903.GD9085@laptop>
References: <20100129204931.789743493@quilx.com>
 <20100129205003.813495196@quilx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100129205003.813495196@quilx.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 29, 2010 at 02:49:41PM -0600, Christoph Lameter wrote:
> Defragmentation support for buffer heads. We convert the references to
> buffers to struct page references and try to remove the buffers from
> those pages. If the pages are dirty then trigger writeout so that the
> buffer heads can be removed later.
> 
> Reviewed-by: Rik van Riel <riel@redhat.com>
> Signed-off-by: Christoph Lameter <clameter@sgi.com>
> Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
> 
> ---
>  fs/buffer.c |   99 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 99 insertions(+)
> 
> Index: slab-2.6/fs/buffer.c
> ===================================================================
> --- slab-2.6.orig/fs/buffer.c	2010-01-22 15:09:43.000000000 -0600
> +++ slab-2.6/fs/buffer.c	2010-01-22 16:17:27.000000000 -0600
> @@ -3352,6 +3352,104 @@ int bh_submit_read(struct buffer_head *b
>  }
>  EXPORT_SYMBOL(bh_submit_read);
>  
> +/*
> + * Writeback a page to clean the dirty state
> + */
> +static void trigger_write(struct page *page)
> +{
> +	struct address_space *mapping = page_mapping(page);
> +	int rc;
> +	struct writeback_control wbc = {
> +		.sync_mode = WB_SYNC_NONE,
> +		.nr_to_write = 1,
> +		.range_start = 0,
> +		.range_end = LLONG_MAX,
> +		.nonblocking = 1,
> +		.for_reclaim = 0
> +	};
> +
> +	if (!mapping->a_ops->writepage)
> +		/* No write method for the address space */
> +		return;
> +
> +	if (!clear_page_dirty_for_io(page))
> +		/* Someone else already triggered a write */
> +		return;
> +
> +	rc = mapping->a_ops->writepage(page, &wbc);
> +	if (rc < 0)
> +		/* I/O Error writing */
> +		return;
> +
> +	if (rc == AOP_WRITEPAGE_ACTIVATE)
> +		unlock_page(page);
> +}
> +
> +/*
> + * Get references on buffers.
> + *
> + * We obtain references on the page that uses the buffer. v[i] will point to
> + * the corresponding page after get_buffers() is through.
> + *
> + * We are safe from the underlying page being removed simply by doing
> + * a get_page_unless_zero. The buffer head removal may race at will.
> + * try_to_free_buffes will later take appropriate locks to remove the
> + * buffers if they are still there.
> + */
> +static void *get_buffers(struct kmem_cache *s, int nr, void **v)
> +{
> +	struct page *page;
> +	struct buffer_head *bh;
> +	int i, j;
> +	int n = 0;
> +
> +	for (i = 0; i < nr; i++) {
> +		bh = v[i];
> +		v[i] = NULL;
> +
> +		page = bh->b_page;
> +
> +		if (page && PagePrivate(page)) {
> +			for (j = 0; j < n; j++)
> +				if (page == v[j])
> +					continue;
> +		}
> +
> +		if (get_page_unless_zero(page))
> +			v[n++] = page;

This seems wrong to me. The page can have been reused at this
stage.

You technically can't re-check using page->private because that
can be anything and doesn't actually need to be a pointer. You
could re-check bh->b_page, provided that you ensure it is always
cleared before a page is detached, and the correct barriers are
in place.


> +	}
> +	return NULL;
> +}
> +
> +/*
> + * Despite its name: kick_buffers operates on a list of pointers to
> + * page structs that was set up by get_buffer().
> + */
> +static void kick_buffers(struct kmem_cache *s, int nr, void **v,
> +							void *private)
> +{
> +	struct page *page;
> +	int i;
> +
> +	for (i = 0; i < nr; i++) {
> +		page = v[i];
> +
> +		if (!page || PageWriteback(page))
> +			continue;
> +
> +		if (trylock_page(page)) {
> +			if (PageDirty(page))
> +				trigger_write(page);
> +			else {
> +				if (PagePrivate(page))
> +					try_to_free_buffers(page);
> +				unlock_page(page);

PagePrivate doesn't necessarily mean it has buffers. try_to_release_page
should be a better idea.

> +			}
> +		}
> +		put_page(page);
> +	}
> +}
> +
>  static void
>  init_buffer_head(void *data)
>  {
> @@ -3370,6 +3468,7 @@ void __init buffer_init(void)
>  				(SLAB_RECLAIM_ACCOUNT|SLAB_PANIC|
>  				SLAB_MEM_SPREAD),
>  				init_buffer_head);
> +	kmem_cache_setup_defrag(bh_cachep, get_buffers, kick_buffers);
>  
>  	/*
>  	 * Limit the bh occupancy to 10% of ZONE_NORMAL


Buffer heads and buffer head refcounting really stinks badly. Although
I can see the need for a medium term solution until fsblock / some
actual sane refcounting.

