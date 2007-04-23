Return-Path: <linux-kernel-owner+w=401wt.eu-S1754423AbXDWWnI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423AbXDWWnI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 18:43:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754428AbXDWWnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 18:43:08 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55699 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754423AbXDWWnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 18:43:07 -0400
Date: Mon, 23 Apr 2007 15:42:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org, pj@sgi.com,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: Pagecache: find_or_create_page does not call a proper page
 allocator function
Message-Id: <20070423154224.15ebf8f7.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0704231503540.975@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0704231408530.691@schroedinger.engr.sgi.com>
	<20070423142919.5809e03f.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704231503540.975@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Apr 2007 15:33:07 -0700 (PDT)
Christoph Lameter <clameter@sgi.com> wrote:

> Grow dev page simply passes GFP_NOFS to find_or_create_page. This means the
> allocation of radix tree nodes is done with GFP_NOFS and the allocation
> of a new page is done using GFP_NOFS as well.
> 
> The mapping has a flags field that contains the necessary allocation flags for
> the page cache allocation. These need to be consulted in order to get DMA
> and HIGHMEM allocations etc right.
> 
> So fix grow_dev_page to do the same as __page_symlink calls. Retrieve the
> mask from the mapping and then remove __GFP_FS.
> 
> Signed-off-by: Christoph Lameter <clameter@sgi.com>
> 
> ---
>  fs/buffer.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6.21-rc7/fs/buffer.c
> ===================================================================
> --- linux-2.6.21-rc7.orig/fs/buffer.c	2007-04-23 15:29:18.000000000 -0700
> +++ linux-2.6.21-rc7/fs/buffer.c	2007-04-23 15:29:43.000000000 -0700
> @@ -988,7 +988,8 @@ grow_dev_page(struct block_device *bdev,
>  	struct page *page;
>  	struct buffer_head *bh;
>  
> -	page = find_or_create_page(inode->i_mapping, index, GFP_NOFS);
> +	page = find_or_create_page(inode->i_mapping, index,
> +		mapping_gfp_mask(inode->i_mapping) & ~__GFP_FS);
>  	if (!page)
>  		return NULL;

OK.  I hope.  the mapping_gfp_mask() here will have come from bdget()'s
mapping_set_gfp_mask(&inode->i_data, GFP_USER);  If anyone is accidentally
setting __GFP_HIGHMEM on a blockdev address_space we'll cause ghastly
explosions.  Albeit ones which were well-deserved.

We'll see how it goes.
