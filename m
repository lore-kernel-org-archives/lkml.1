Return-Path: <linux-kernel-owner+w=401wt.eu-S1764362AbXLNDwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764362AbXLNDwT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 22:52:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756308AbXLNDwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 22:52:07 -0500
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:34156 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751436AbXLNDwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 22:52:06 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=RbiGoDN5mPbge0f1nJ+3Z/Mb2pj3zqGV+YMKGMCECKfdTR400+JwBUEoQY7tdaRakAogpvuk1o6RI88oMheACkA3RnHbeGuvzLhgb0wgJahbN9sieWnqAOMFo3Z/F/W4WrJn2S6GpmMtM6O6eDqRDmDzXBqX0zHdVVhng4Nqk4Q=  ;
X-YMail-OSG: 7iG5yBQVM1lJ_fn7FgTgfi3wh4SMIQLBqdJlimnPc79Hisfm
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 09/28] FS-Cache: Release page->private after failed readahead [try #2]
Date: Fri, 14 Dec 2007 14:51:56 +1100
User-Agent: KMail/1.9.5
Cc: viro@ftp.linux.org.uk, hch@infradead.org, Trond.Myklebust@netapp.com,
       sds@tycho.nsa.gov, casey@schaufler-ca.com, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org
References: <20071205193818.24617.79771.stgit@warthog.procyon.org.uk> <20071205193904.24617.94077.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071205193904.24617.94077.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712141451.56870.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 December 2007 06:39, David Howells wrote:
> The attached patch causes read_cache_pages() to release page-private data
> on a page for which add_to_page_cache() fails or the filler function fails.
> This permits pages with caching references associated with them to be
> cleaned up.
>
> The invalidatepage() address space op is called (indirectly) to do the
> honours.

This is pretty nasty. I would suggest either to have the function
return the number of pages that were added to pagecache, or just
open code it.

>
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
>
>  mm/readahead.c |   39 +++++++++++++++++++++++++++++++++++++--
>  1 files changed, 37 insertions(+), 2 deletions(-)
>
> diff --git a/mm/readahead.c b/mm/readahead.c
> index c9c50ca..75aa6b6 100644
> --- a/mm/readahead.c
> +++ b/mm/readahead.c
> @@ -44,6 +44,41 @@ EXPORT_SYMBOL_GPL(file_ra_state_init);
>
>  #define list_to_page(head) (list_entry((head)->prev, struct page, lru))
>
> +/*
> + * see if a page needs releasing upon read_cache_pages() failure
> + * - the caller of read_cache_pages() may have set PG_private before
> calling, + *   such as the NFS fs marking pages that are cached locally on
> disk, thus we + *   need to give the fs a chance to clean up in the event
> of an error + */
> +static void read_cache_pages_invalidate_page(struct address_space
> *mapping, +					     struct page *page)
> +{
> +	if (PagePrivate(page)) {
> +		if (TestSetPageLocked(page))
> +			BUG();
> +		page->mapping = mapping;
> +		do_invalidatepage(page, 0);
> +		page->mapping = NULL;
> +		unlock_page(page);
> +	}
> +	page_cache_release(page);
> +}
> +
> +/*
> + * release a list of pages, invalidating them first if need be
> + */
> +static void read_cache_pages_invalidate_pages(struct address_space
> *mapping, +					      struct list_head *pages)
> +{
> +	struct page *victim;
> +
> +	while (!list_empty(pages)) {
> +		victim = list_to_page(pages);
> +		list_del(&victim->lru);
> +		read_cache_pages_invalidate_page(mapping, victim);
> +	}
> +}
> +
>  /**
>   * read_cache_pages - populate an address space with some pages & start
> reads against them * @mapping: the address_space
> @@ -65,14 +100,14 @@ int read_cache_pages(struct address_space *mapping,
> struct list_head *pages, list_del(&page->lru);
>  		if (add_to_page_cache_lru(page, mapping,
>  					page->index, GFP_KERNEL)) {
> -			page_cache_release(page);
> +			read_cache_pages_invalidate_page(mapping, page);
>  			continue;
>  		}
>  		page_cache_release(page);
>
>  		ret = filler(data, page);
>  		if (unlikely(ret)) {
> -			put_pages_list(pages);
> +			read_cache_pages_invalidate_pages(mapping, pages);
>  			break;
>  		}
>  		task_io_account_read(PAGE_CACHE_SIZE);
>
