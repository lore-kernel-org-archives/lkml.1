Return-Path: <linux-kernel-owner+w=401wt.eu-S964789AbXBNWAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964789AbXBNWAy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 17:00:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964791AbXBNWAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 17:00:54 -0500
Received: from smtp.osdl.org ([65.172.181.24]:48110 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964789AbXBNWAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 17:00:53 -0500
Date: Wed, 14 Feb 2007 14:00:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] VM: invalidate_inode_pages2_range() shouldn't fail
 on page dirty...
Message-Id: <20070214140050.a0d182c9.akpm@linux-foundation.org>
In-Reply-To: <20070213074338.24191.28711.stgit@heimdal.trondhjem.org>
References: <20070213074335.24191.51525.stgit@heimdal.trondhjem.org>
	<20070213074338.24191.28711.stgit@heimdal.trondhjem.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Feb 2007 23:43:38 -0800
Trond Myklebust <Trond.Myklebust@netapp.com> wrote:

> From: Trond Myklebust <Trond.Myklebust@netapp.com>
> 
> invalidate_inode_pages2() should not try to fix races between direct_IO and
> mmap(). It should only be trying to clear out pages that were dirty before
> the direct_IO write (see generic_file_direct_IO()).
> Skipping dirty pages should therefore not result in an error.
> 

This change worries me.  It's a very bad situation if we leave dirty
pagecache sitting over a piece of the file which is about to be either read
or written via direct-IO.  As far as the application is concerned, it
pretty much guarantees impending data corruption and I do think we need to
tell the application the bad news and not just pretend that things are all
OK.

What problem are we trying to fix here?


> ---
> 
>  mm/truncate.c |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/truncate.c b/mm/truncate.c
> index 0f4b6d1..c3ff820 100644
> --- a/mm/truncate.c
> +++ b/mm/truncate.c
> @@ -318,6 +318,8 @@ EXPORT_SYMBOL(invalidate_mapping_pages);
>   * invalidation guarantees, and cannot afford to leave pages behind because
>   * shrink_list() has a temp ref on them, or because they're transiently sitting
>   * in the lru_cache_add() pagevecs.
> + * Note: this function just skips pages that are dirty without flagging
> + * an error.
>   */
>  static int
>  invalidate_complete_page2(struct address_space *mapping, struct page *page)
> @@ -330,7 +332,7 @@ invalidate_complete_page2(struct address
>  
>  	write_lock_irq(&mapping->tree_lock);
>  	if (PageDirty(page))
> -		goto failed;
> +		goto dirty;
>  
>  	BUG_ON(PagePrivate(page));
>  	__remove_from_page_cache(page);
> @@ -338,9 +340,9 @@ invalidate_complete_page2(struct address
>  	ClearPageUptodate(page);
>  	page_cache_release(page);	/* pagecache ref */
>  	return 1;
> -failed:
> +dirty:
>  	write_unlock_irq(&mapping->tree_lock);
> -	return 0;
> +	return 1;
>  }
>  
>  static int do_launder_page(struct address_space *mapping, struct page *page)
