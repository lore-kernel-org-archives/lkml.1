Return-Path: <linux-kernel-owner+w=401wt.eu-S1754274AbXDXRLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274AbXDXRLs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 13:11:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754284AbXDXRLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 13:11:48 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34614 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754274AbXDXRLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 13:11:47 -0400
Date: Tue, 24 Apr 2007 10:11:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: Christoph Lameter <clameter@sgi.com>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org, pj@sgi.com
Subject: Re: Pagecache: find_or_create_page does not call a proper page
 allocator function
Message-Id: <20070424101116.1cb7512e.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0704241339460.26223@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0704231408530.691@schroedinger.engr.sgi.com>
	<20070423142919.5809e03f.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704231503540.975@schroedinger.engr.sgi.com>
	<20070423154224.15ebf8f7.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704241339460.26223@blonde.wat.veritas.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2007 14:09:33 +0100 (BST) Hugh Dickins <hugh@veritas.com> wrote:

> On Mon, 23 Apr 2007, Andrew Morton wrote:
> > 
> > OK.  I hope.  the mapping_gfp_mask() here will have come from bdget()'s
> > mapping_set_gfp_mask(&inode->i_data, GFP_USER);  If anyone is accidentally
> > setting __GFP_HIGHMEM on a blockdev address_space we'll cause ghastly
> > explosions.  Albeit ones which were well-deserved.
> 
> I've not yet looked at the patch under discussion, but this remark
> prompts me...  a couple of days ago I got very worried by the various
> hard-wired GFP_HIGHUSER allocations in mm/migrate.c and mm/mempolicy.c,
> and wondered how those would work out if someone has a blockdev mmap'ed.
> 
> I tried to test it out before sending a patch, but found no problem at
> all: maybe I was too timid (fearing to corrupt my whole system), maybe 
> I've forgotten how that stuff works and wasn't doing the right thing
> to reproduce it (I was mmap'ing /dev/sdb1 readonly, at the same time
> as having it mounted as ext2 - when I forced migration to random pages,
> then cp'ed /dev/zero to reuse the old pages, I was expecting ext2 to
> get very upset with its metadata; mmap'ing while mounted isn't very
> realistic, but my earlier sequence hadn't shown any problem either,
> so I thought the cache got invalidated in between).

Yipes.

> Here's the patch I'd suggest adding if you believe there really is
> a problem there: it's far from ideal (I can imagine mapping_gfp_mask
> being used to enforce other restrictions, but the __GFP_HIGHMEM issue
> seems to be the only one in practice; and it would be a shame to
> restrict all the architectures which have no concept of HIGHMEM).
> If there's no such problem, sorry for wasting your time.

Yes, I believe there is such a problem.  We ignore the fact that the
blockdev address_space doesn't implement ->migratepage and we cheerily
call fallback_migrate_page(), which does the wrong thing.

> (If vma->vm_file is non-NULL, we can be sure vma->vm_file->f_mapping
> is non-NULL, can't we?  Some common code assumes that, some does not:
> I've avoided cargo-cult safety below, but don't let me make it unsafe.)
> 
> 
> Is there a problem with page migration to HIGHMEM, if pages were
> mapped from a GFP_USER block device?  I failed to demonstrate any
> problem, but here's a quick fix if needed.
> 
> Signed-off-by: Hugh Dickins <hugh@veritas.com>
> 
> --- 2.6.21-rc7/include/linux/migrate.h	2007-03-07 13:08:59.000000000 +0000
> +++ linux/include/linux/migrate.h	2007-04-24 13:18:31.000000000 +0100
> @@ -2,6 +2,7 @@
>  #define _LINUX_MIGRATE_H
>  
>  #include <linux/mm.h>
> +#include <linux/pagemap.h>
>  
>  typedef struct page *new_page_t(struct page *, unsigned long private, int **);
>  
> @@ -10,6 +11,13 @@ static inline int vma_migratable(struct 
>  {
>  	if (vma->vm_flags & (VM_IO|VM_HUGETLB|VM_PFNMAP|VM_RESERVED))
>  		return 0;
> +#ifdef CONFIG_HIGHMEM
> +	if (vma->vm_file) {
> +		struct address_space *mapping = vma->vm_file->f_mapping;
> +		if (!(mapping_gfp_mask(mapping) & __GFP_HIGHMEM))
> +			return 0;
> +	}
> +#endif
>  	return 1;
>  }

>From my reading it would be pretty simple to teach unmap_and_move() to pass
mapping_gfp_mask(page_mapping(page)) down into (*get_new_page)() to get the
correct type of page.

