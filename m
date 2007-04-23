Return-Path: <linux-kernel-owner+w=401wt.eu-S1754399AbXDWWdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399AbXDWWdL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 18:33:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754406AbXDWWdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 18:33:10 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:41528 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754399AbXDWWdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 18:33:09 -0400
Date: Mon, 23 Apr 2007 15:33:07 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org, pj@sgi.com,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: Pagecache: find_or_create_page does not call a proper page
 allocator function
In-Reply-To: <20070423142919.5809e03f.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0704231503540.975@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0704231408530.691@schroedinger.engr.sgi.com>
 <20070423142919.5809e03f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Apr 2007, Andrew Morton wrote:

> There are few calls to page_cache_alloc().  Would it not be simpler to just
> add the additional argument to page_cache_alloc() (called "extra_gfp",
> please) and to update all callers?  And to remove page_cache_alloc_cold()
> and replace all it callers with page_cache_alloc(mapping, __GFP_COLD)?
> 
> The way we actually get rid of an API call instead of adding another one.

I am not quite sure about the ORing of the gfpmasks in
find_or_create_page. There is a conflict between the needs for the
allocation for the radix tree which has to be done with the specified 
mask and the allocation for the page in the mapping which has to be
done with the gfp mask from the mapping (?). What a mess.

Looking at the callers of find_or_create_page ..... They mostly
specify the mapping_gfp_mask except for

1. grow_dev_page which wants GFP_NOFS but there is no way to switch off 
the proper flags if we go through page_cache_alloc(). Sigh. The mask
is not usable since it does not switch on the mapping bits. It simply ORs 
the flags...

2. __page_symlink filters __GFP_FS from the mapping flags. Hmmm.. 
interesting. A way to fix it.

So if we fix grow_dev_page to use the mapping flags like in __page_symlink 
uses then we have the right flags for the tree lock alloc and the page 
allocation. We do not need to determine the flags again in find_or_create_page.

We have a bug here that needs fixing




Fix page allocation flags in grow_dev_page()

Grow dev page simply passes GFP_NOFS to find_or_create_page. This means the
allocation of radix tree nodes is done with GFP_NOFS and the allocation
of a new page is done using GFP_NOFS as well.

The mapping has a flags field that contains the necessary allocation flags for
the page cache allocation. These need to be consulted in order to get DMA
and HIGHMEM allocations etc right.

So fix grow_dev_page to do the same as __page_symlink calls. Retrieve the
mask from the mapping and then remove __GFP_FS.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 fs/buffer.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6.21-rc7/fs/buffer.c
===================================================================
--- linux-2.6.21-rc7.orig/fs/buffer.c	2007-04-23 15:29:18.000000000 -0700
+++ linux-2.6.21-rc7/fs/buffer.c	2007-04-23 15:29:43.000000000 -0700
@@ -988,7 +988,8 @@ grow_dev_page(struct block_device *bdev,
 	struct page *page;
 	struct buffer_head *bh;
 
-	page = find_or_create_page(inode->i_mapping, index, GFP_NOFS);
+	page = find_or_create_page(inode->i_mapping, index,
+		mapping_gfp_mask(inode->i_mapping) & ~__GFP_FS);
 	if (!page)
 		return NULL;
 




