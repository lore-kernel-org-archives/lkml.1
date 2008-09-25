Return-Path: <linux-kernel-owner+w=401wt.eu-S1754248AbYIYIj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248AbYIYIj7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 04:39:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752525AbYIYIju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 04:39:50 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45694 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444AbYIYIjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 04:39:48 -0400
Date: Thu, 25 Sep 2008 17:45:13 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Nick Piggin <npiggin@suse.de>
Cc: keith.packard@intel.com, eric@anholt.net, hugh@veritas.com,
       hch@infradead.org, airlied@linux.ie, jbarnes@virtuousgeek.org,
       thomas@tungstengraphics.com, dri-devel@lists.sourceforge.net,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] mm: pageable memory allocator (for DRM-GEM?)
Message-Id: <20080925174513.fd44bc08.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080923091017.GB29718@wotan.suse.de>
References: <20080923091017.GB29718@wotan.suse.de>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Sep 2008 11:10:17 +0200
Nick Piggin <npiggin@suse.de> wrote:

> +void *pageable_vmap_object(pgobj_t *object, unsigned long start, unsigned long end)
> +{
> +	struct file *filp = (struct file *)object;
> +	struct address_space *mapping = filp->f_dentry->d_inode->i_mapping;
> +	unsigned int offset = start & ~PAGE_CACHE_MASK;
> +	pgoff_t first, last, i;
> +	struct page **pages;
> +	int nr;
> +	void *ret;
> +
> +	BUG_ON(start >= end);
> +
> +	first = start / PAGE_SIZE;
> +	last = DIV_ROUND_UP(end, PAGE_SIZE);
> +	nr = last - first;
> +
> +#ifndef CONFIG_HIGHMEM
> +	if (nr == 1) {
> +		struct page *page;
> +
> +		rcu_read_lock();
> +		page = radix_tree_lookup(&mapping->page_tree, first);
> +		rcu_read_unlock();
> +		BUG_ON(!page);
> +		BUG_ON(page_count(page) < 2);
> +
> +		ret = page_address(page);
> +
> +		goto out;
> +	}
> +#endif
> +
> +	pages = kmalloc(sizeof(struct page *) * nr, GFP_KERNEL);
> +	if (!pages)
> +		return NULL;
> +
> +	for (i = first; i < last; i++) {
> +		struct page *page;
> +
> +		rcu_read_lock();
> +		page = radix_tree_lookup(&mapping->page_tree, i);
> +		rcu_read_unlock();
> +		BUG_ON(!page);
> +		BUG_ON(page_count(page) < 2);
> +
> +		pages[i] = page;
> +	}
> +
> +	ret = vmap(pages, nr, VM_MAP, PAGE_KERNEL);
> +	kfree(pages);
> +	if (!ret)
> +		return NULL;
> +
> +out:
> +	return ret + offset;
> +}
> +
> +void pageable_vunmap_object(pgobj_t *object, void *ptr, unsigned long start, unsigned long end)
> +{
> +#ifndef CONFIG_HIGHMEM
> +	pgoff_t first, last;
> +	int nr;
> +
> +	BUG_ON(start >= end);
> +
> +	first = start / PAGE_SIZE;
> +	last = DIV_ROUND_UP(end, PAGE_SIZE);
> +	nr = last - first;
> +	if (nr == 1)
> +		return;
> +#endif
> +
> +	vunmap((void *)((unsigned long)ptr & PAGE_CACHE_MASK));
> +}
> +

Some questions..

 - could you use GFP_HIGHUSER rather than GFP_HIGHUSER_MOVABLE ?
   I think setting mapping_gfp_mask() (address_space->flags) to appropriate
   value is enough.

 - Can we mlock pages while it's vmapped ? (or Reserve and remove from LRU)
   Then, new split-lru can ignore these pages while there are mapped. over-killing ?

 - Doesn't we need to increase page->mapcount ?

 - memory resource contorller should account these pages ?
   (Maybe this is question to myself....)

Thanks,
-Kame

