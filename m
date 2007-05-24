Return-Path: <linux-kernel-owner+w=401wt.eu-S1753198AbXEXUik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbXEXUik (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 16:38:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750841AbXEXUid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 16:38:33 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:33630 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750818AbXEXUic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 16:38:32 -0400
Date: Thu, 24 May 2007 13:38:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] AFS: Add a function to excise a rejected write from
 the pagecache
Message-Id: <20070524133821.3ee9c9f3.akpm@linux-foundation.org>
In-Reply-To: <20070523191524.24135.2609.stgit@warthog.cambridge.redhat.com>
References: <20070523191518.24135.81257.stgit@warthog.cambridge.redhat.com>
	<20070523191524.24135.2609.stgit@warthog.cambridge.redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2007 20:15:24 +0100
David Howells <dhowells@redhat.com> wrote:

> Add a function - cancel_rejected_write() - to excise a rejected write from the
> pagecache.  This function is related to the truncation family of routines.  It
> permits the pages modified by a network filesystem client (such as AFS) to be
> excised and discarded from the pagecache if the attempt to write them back to
> the server fails.

Could you please flesh this out a bit, from a higher level?

As in: what does it mean for a server to "reject" a write?  What's actually
going on here?  Why does the server do this?  I assume that the application
will see a short write or an EIO or something?

How does this interact with MAP_SHARED?

Do we expect that any other networked filesystem would want to do this? 
(and if not, why not?) Or do they already attempt to do it in some other
fashion?

> The dirty and writeback states of the afflicted pages are cancelled and the
> pages themselves are detached for recycling.  All PTEs referring to those
> pages are removed.
> 
> Note that the locking is tricky as it's very easy to deadlock against
> truncate() and other routines once the pages have been unlocked as part of the
> writeback process.  To this end, the PG_error flag is set, then the
> PG_writeback flag is cleared, and only *then* can lock_page() be called.

hm.

> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  include/linux/mm.h |    5 ++-
>  mm/truncate.c      |   83 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 86 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index e4183c6..73688d4 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1086,12 +1086,13 @@ extern int do_munmap(struct mm_struct *, unsigned long, size_t);
>  
>  extern unsigned long do_brk(unsigned long, unsigned long);
>  
> -/* filemap.c */
> -extern unsigned long page_unuse(struct page *);
> +/* truncate.c */
>  extern void truncate_inode_pages(struct address_space *, loff_t);
>  extern void truncate_inode_pages_range(struct address_space *,
>  				       loff_t lstart, loff_t lend);
> +extern void cancel_rejected_write(struct address_space *, pgoff_t, pgoff_t);
>  
> +/* filemap.c */
>  /* generic vm_area_ops exported for stackable file systems */
>  extern struct page *filemap_nopage(struct vm_area_struct *, unsigned long, int *);
>  extern int filemap_populate(struct vm_area_struct *, unsigned long,
> diff --git a/mm/truncate.c b/mm/truncate.c
> index 4fbe1a2..f742096 100644
> --- a/mm/truncate.c
> +++ b/mm/truncate.c
> @@ -443,3 +443,86 @@ int invalidate_inode_pages2(struct address_space *mapping)
>  	return invalidate_inode_pages2_range(mapping, 0, -1);
>  }
>  EXPORT_SYMBOL_GPL(invalidate_inode_pages2);
> +
> +/*
> + * Cancel that part of a rejected write that affects a particular page
> + */
> +static void cancel_rejected_page(struct address_space *mapping,
> +				 struct page *page, pgoff_t *_next)
> +{
> +	if (!TestSetPageError(page)) {
> +		/* can't lock the page until we've cleared PG_writeback lest we
> +		 * deadlock with truncate (amongst other things) */
> +		end_page_writeback(page);
> +		if (page->mapping == mapping) {
> +			lock_page(page);
> +			if (page->mapping == mapping) {
> +				truncate_complete_page(mapping, page);
> +				*_next = page->index + 1;
> +			}
> +			unlock_page(page);
> +		}
> +	} else if (PageWriteback(page) || PageDirty(page)) {
> +		BUG();
> +	}
> +}

Why can't we just run the end_page_writeback() unconditionally? 
PG_writeback _must_ be set here, and it is the caller who set PG_writeback,
so this thread of control "owns" that flag.

Also, are you really really sure that there is no way in which PG_writeback
can get itself set again after the end_page_writeback()?  I'd have thought
that we should be doing a wait_on_page_writeback() after the lock_page()
there.  Remember, other filesystems might want to be calling this, so we
shouldn't be designing around AFS implementation specifics.

> +/**
> + * cancel_rejected_write - Cancel a write on a contiguous set of pages
> + * @mapping: mapping affected
> + * @start: first page in set
> + * @end: last page in set
> + *
> + * Cancel a write of a contiguous set of pages when the writeback was rejected
> + * by the target medium or server.
> + *
> + * The pages in question are detached and discarded from the pagecache, and the
> + * writeback and dirty states are cleared prior to invalidation.  The caller
> + * must make sure that all the pages in the range are present in the pagecache,
> + * and the caller must hold PG_writeback on each of them.  NOTE! All the pages
> + * are locked and unlocked as part of this process, so the caller must take
> + * care to avoid deadlock.
> + *
> + * The PTEs pointing to those pages are also cleared, leading to the PTEs being
> + * reset when new pages are allocated and the contents reloaded.
> + */
> +void cancel_rejected_write(struct address_space *mapping,
> +			   pgoff_t start, pgoff_t end)
> +{
> +	struct pagevec pvec;
> +	pgoff_t n;
> +	int i;
> +
> +	BUG_ON(mapping->nrpages < end - start + 1);
> +
> +	/* dispose of any PTEs pointing to the affected pages */
> +	unmap_mapping_range(mapping,
> +			    (loff_t)start << PAGE_CACHE_SHIFT,
> +			    (loff_t)(end - start + 1) << PAGE_CACHE_SHIFT,
> +			    0);
> +
> +	pagevec_init(&pvec, 0);
> +	do {
> +		cond_resched();
> +		n = end - start + 1;
> +		if (n > PAGEVEC_SIZE)
> +			n = PAGEVEC_SIZE;
> +		n = pagevec_lookup(&pvec, mapping, start, n);
> +		for (i = 0; i < n; i++) {
> +			struct page *page = pvec.pages[i];
> +
> +			if (page->index < start || page->index > end)
> +				continue;
> +			start++;
> +			cancel_rejected_page(mapping, page, &start);
> +		}
> +		pagevec_release(&pvec);
> +	} while (start - 1 < end);
> +
> +	/* dispose of any new PTEs pointing to the affected pages */
> +	unmap_mapping_range(mapping,
> +			    (loff_t)start << PAGE_CACHE_SHIFT,
> +			    (loff_t)(end - start + 1) << PAGE_CACHE_SHIFT,
> +			    0);
> +}
> +EXPORT_SYMBOL_GPL(cancel_rejected_write);

hm, is the pte-unmapping here completely solid?  Are there any race windows
in which a faulter can end up owning, say, an anonymous page?  We've had
heaps of problems with that sort of thing in generic_file_direct_IO() and I
don't expect it's this easy.





