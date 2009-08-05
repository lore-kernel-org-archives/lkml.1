Return-Path: <linux-kernel-owner+w=401wt.eu-S934262AbZHEMiD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934262AbZHEMiD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 08:38:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933610AbZHEMiC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 08:38:02 -0400
Received: from mga14.intel.com ([143.182.124.37]:50581 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933564AbZHEMiB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 08:38:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,328,1246863600"; 
   d="scan'208";a="172530828"
Date: Wed, 5 Aug 2009 20:37:49 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Andi Kleen <andi@firstfloor.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "hidehiro.kawai.ez@hitachi.com" <hidehiro.kawai.ez@hitachi.com>
Subject: Re: [PATCH] [11/19] HWPOISON: Refactor truncate to allow direct
	truncating of page v2
Message-ID: <20090805123749.GA9443@localhost>
References: <200908051136.682859934@firstfloor.org> <20090805093638.D3754B15D8@basil.firstfloor.org> <20090805102008.GB17190@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090805102008.GB17190@wotan.suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 05, 2009 at 06:20:08PM +0800, Nick Piggin wrote:
> On Wed, Aug 05, 2009 at 11:36:38AM +0200, Andi Kleen wrote:
> > 
> > From: Nick Piggin <npiggin@suse.de>
> > 
> > Extract out truncate_inode_page() out of the truncate path so that
> > it can be used by memory-failure.c
> > 
> > [AK: description, headers, fix typos]
> > v2: Some white space changes from Fengguang Wu 
> > 
> > Signed-off-by: Andi Kleen <ak@linux.intel.com>
> > 
> > ---
> >  include/linux/mm.h |    2 ++
> >  mm/truncate.c      |   29 +++++++++++++++--------------
> >  2 files changed, 17 insertions(+), 14 deletions(-)
> > 
> > Index: linux/mm/truncate.c
> > ===================================================================
> > --- linux.orig/mm/truncate.c
> > +++ linux/mm/truncate.c
> > @@ -93,11 +93,11 @@ EXPORT_SYMBOL(cancel_dirty_page);
> >   * its lock, b) when a concurrent invalidate_mapping_pages got there first and
> >   * c) when tmpfs swizzles a page between a tmpfs inode and swapper_space.
> >   */
> > -static void
> > +static int
> >  truncate_complete_page(struct address_space *mapping, struct page *page)
> >  {
> >  	if (page->mapping != mapping)
> > -		return;
> > +		return -EIO;
> 
> Hmm, at this point, the page must have been removed from pagecache,
> so I don't know if you need to pass an error back?

Me think so too. When called from hwpoison, the page count and lock
have both be taken, so at least _in this case_,

        (page->mapping != mapping)

can be equally written as

        (page->mapping == NULL)

But anyway, the return value is now ignored in upper layer :)

Thanks,
Fengguang

>   
> >  	if (page_has_private(page))
> >  		do_invalidatepage(page, 0);
> > @@ -108,6 +108,7 @@ truncate_complete_page(struct address_sp
> >  	remove_from_page_cache(page);
> >  	ClearPageMappedToDisk(page);
> >  	page_cache_release(page);	/* pagecache ref */
> > +	return 0;
> >  }
> >  
> >  /*
> > @@ -135,6 +136,16 @@ invalidate_complete_page(struct address_
> >  	return ret;
> >  }
> >  
> > +int truncate_inode_page(struct address_space *mapping, struct page *page)
> > +{
> > +	if (page_mapped(page)) {
> > +		unmap_mapping_range(mapping,
> > +				   (loff_t)page->index << PAGE_CACHE_SHIFT,
> > +				   PAGE_CACHE_SIZE, 0);
> > +	}
> > +	return truncate_complete_page(mapping, page);
> > +}
> > +
> >  /**
> >   * truncate_inode_pages - truncate range of pages specified by start & end byte offsets
> >   * @mapping: mapping to truncate
> > @@ -196,12 +207,7 @@ void truncate_inode_pages_range(struct a
> >  				unlock_page(page);
> >  				continue;
> >  			}
> > -			if (page_mapped(page)) {
> > -				unmap_mapping_range(mapping,
> > -				  (loff_t)page_index<<PAGE_CACHE_SHIFT,
> > -				  PAGE_CACHE_SIZE, 0);
> > -			}
> > -			truncate_complete_page(mapping, page);
> > +			truncate_inode_page(mapping, page);
> >  			unlock_page(page);
> >  		}
> >  		pagevec_release(&pvec);
> > @@ -238,15 +244,10 @@ void truncate_inode_pages_range(struct a
> >  				break;
> >  			lock_page(page);
> >  			wait_on_page_writeback(page);
> > -			if (page_mapped(page)) {
> > -				unmap_mapping_range(mapping,
> > -				  (loff_t)page->index<<PAGE_CACHE_SHIFT,
> > -				  PAGE_CACHE_SIZE, 0);
> > -			}
> > +			truncate_inode_page(mapping, page);
> >  			if (page->index > next)
> >  				next = page->index;
> >  			next++;
> > -			truncate_complete_page(mapping, page);
> >  			unlock_page(page);
> >  		}
> >  		pagevec_release(&pvec);
> > Index: linux/include/linux/mm.h
> > ===================================================================
> > --- linux.orig/include/linux/mm.h
> > +++ linux/include/linux/mm.h
> > @@ -809,6 +809,8 @@ static inline void unmap_shared_mapping_
> >  extern int vmtruncate(struct inode * inode, loff_t offset);
> >  extern int vmtruncate_range(struct inode * inode, loff_t offset, loff_t end);
> >  
> > +int truncate_inode_page(struct address_space *mapping, struct page *page);
> > +
> >  #ifdef CONFIG_MMU
> >  extern int handle_mm_fault(struct mm_struct *mm, struct vm_area_struct *vma,
> >  			unsigned long address, unsigned int flags);
