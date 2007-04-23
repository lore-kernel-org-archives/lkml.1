Return-Path: <linux-kernel-owner+w=401wt.eu-S1754271AbXDWV3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271AbXDWV3e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 17:29:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754272AbXDWV3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 17:29:34 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59580 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754268AbXDWV3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 17:29:33 -0400
Date: Mon, 23 Apr 2007 14:29:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org, pj@sgi.com,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: Pagecache: find_or_create_page does not call a proper page
 allocator function
Message-Id: <20070423142919.5809e03f.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0704231408530.691@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0704231408530.691@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Apr 2007 14:11:57 -0700 (PDT)
Christoph Lameter <clameter@sgi.com> wrote:

> The find_or_create function calls alloc_page with a local gfp mask instead
> of using page_cache_alloc. This means that the page allocation will not
> obey cpuset memory spreading and page allocation will not properly use the
> gfp flags in the address space. Highmem is not set correctly.
> 
> It turns out that there is no function to allocate a page for the page cache
> with a gfp mask. So we create one ORing the context gfp flags with the gfp flags
> from the mapping.
> 
> Signed-off-by: Christoph Lameter <clameter@sgi.com>
> 
> ---
>  include/linux/pagemap.h |   10 ++++++++--
>  mm/filemap.c            |    3 ++-
>  2 files changed, 10 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6.21-rc7/include/linux/pagemap.h
> ===================================================================
> --- linux-2.6.21-rc7.orig/include/linux/pagemap.h	2007-04-23 13:52:20.000000000 -0700
> +++ linux-2.6.21-rc7/include/linux/pagemap.h	2007-04-23 14:01:09.000000000 -0700
> @@ -60,14 +60,20 @@ static inline struct page *__page_cache_
>  }
>  #endif
>  
> +static inline struct page *page_cache_alloc_mask(struct address_space *x,
> +			gfp_t gfp)
> +{
> +	return __page_cache_alloc(mapping_gfp_mask(x) | gfp);
> +}

Usually we use the term "mask" to imply an AND function, not an OR
function.

There are few calls to page_cache_alloc().  Would it not be simpler to just
add the additional argument to page_cache_alloc() (called "extra_gfp",
please) and to update all callers?  And to remove page_cache_alloc_cold()
and replace all it callers with page_cache_alloc(mapping, __GFP_COLD)?

The way we actually get rid of an API call instead of adding another one.

