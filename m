Return-Path: <linux-kernel-owner+w=401wt.eu-S1755443AbZDDGA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443AbZDDGA3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 02:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbZDDGAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 02:00:17 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:43860 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751573AbZDDGAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 02:00:15 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=CTJnhYxxRDArwtORzXtSGQfiCKlI3HJCy6uWLaN3LJbrqvzPFTL9HoX/68gZ83uPdYKnFDSmVSUJJFJB2pVSG5ydxhHONxsNuTQEKUGKqumcrRmI358tj9W7uGSc98bqcoLIgpO8cXX5tQx53WN5D/dN8pBlCVXVyXjqvWOkNKs=  ;
X-YMail-OSG: DIGjCr0VM1nuUgGXxgCqRAwCallU4VAZS2qQcbnW3evYw8naew23zN7FhxVzzWRRADN763tEeqID68ON1OacRg9qjM3Nn7fTuZ7T9dfwY3gKYsmRBzr22CJBCm8KWJpydqBY8zcllN0xJgwIex8DDHAUlx4Xc03.PfecpsBMcXZi6LxL_B3C6PgvmEb83t88Zt_rdlHMO9pTC3l.kxD6pF.CR910a9XoErdYNNUnAf0LvP72qa5mYGZWoWP4O7hZjFNQpuWfgSXz2SkdxWn7EYeJlYjaOrDpK_uepDAbawGgvF29oPHKf0D7Fxsc9uu0B.CfjPlPRSPVUu7cP1ttnd5AMJA-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 05/41] FS-Cache: Release page->private after failed readahead [ver #48]
Date: Sat, 4 Apr 2009 17:00:08 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: linux-kernel@vger.kernel.org, nfsv4@linux-nfs.org,
       linux-fsdevel@vger.kernel.org
References: <20090403155436.28714.23368.stgit@warthog.procyon.org.uk> <20090403155502.28714.31394.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090403155502.28714.31394.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200904041700.09248.nickpiggin@yahoo.com.au>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Again, what about prefixing patches with the subsystems they affect?
This would be mm: or fs:.

On Saturday 04 April 2009 02:55:02 David Howells wrote:
> The attached patch causes read_cache_pages() to release page-private data on a
> page for which add_to_page_cache() fails.  If the filler function fails, then
> the problematic page is left attached to the pagecache (with appropriate flags
> set, one presumes) and the remaining to-be-attached pages are invalidated and
> discarded.  This permits pages with caching references associated with them to
> be cleaned up.
> 
> The invalidatepage() address space op is called (indirectly) to do the honours.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> Acked-by: Steve Dickson <steved@redhat.com>
> Acked-by: Trond Myklebust <Trond.Myklebust@netapp.com>
> Acked-by: Rik van Riel <riel@redhat.com>
> Acked-by: Al Viro <viro@zeniv.linux.org.uk>
> Tested-by: Daire Byrne <Daire.Byrne@framestore.com>
> ---
> 
>  include/linux/page-flags.h |    2 +-
>  mm/readahead.c             |   39 +++++++++++++++++++++++++++++++++++++--
>  2 files changed, 38 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index 61df177..9d99e74 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -182,7 +182,7 @@ static inline int TestClearPage##uname(struct page *page) { return 0; }
>  
>  struct page;	/* forward declaration */
>  
> -TESTPAGEFLAG(Locked, locked)
> +TESTPAGEFLAG(Locked, locked) TESTSETFLAG(Locked, locked)
>  PAGEFLAG(Error, error)
>  PAGEFLAG(Referenced, referenced) TESTCLEARFLAG(Referenced, referenced)
>  PAGEFLAG(Dirty, dirty) TESTSCFLAG(Dirty, dirty) __CLEARPAGEFLAG(Dirty, dirty)
> diff --git a/mm/readahead.c b/mm/readahead.c
> index 9ce303d..6be9275 100644
> --- a/mm/readahead.c
> +++ b/mm/readahead.c
> @@ -31,6 +31,41 @@ EXPORT_SYMBOL_GPL(file_ra_state_init);
>  
>  #define list_to_page(head) (list_entry((head)->prev, struct page, lru))
>  
> +/*
> + * see if a page needs releasing upon read_cache_pages() failure
> + * - the caller of read_cache_pages() may have set PG_private before calling,
> + *   such as the NFS fs marking pages that are cached locally on disk, thus we
> + *   need to give the fs a chance to clean up in the event of an error
> + */
> +static void read_cache_pages_invalidate_page(struct address_space *mapping,
> +					     struct page *page)
> +{
> +	if (PagePrivate(page)) {
> +		if (!trylock_page(page))
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
> +static void read_cache_pages_invalidate_pages(struct address_space *mapping,
> +					      struct list_head *pages)
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
>   * read_cache_pages - populate an address space with some pages & start reads against them
>   * @mapping: the address_space
> @@ -52,14 +87,14 @@ int read_cache_pages(struct address_space *mapping, struct list_head *pages,
>  		list_del(&page->lru);
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

