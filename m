Return-Path: <linux-kernel-owner+w=401wt.eu-S1753989AbZFBX15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989AbZFBX15 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 19:27:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752528AbZFBX1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 19:27:50 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44599 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544AbZFBX1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 19:27:49 -0400
Date: Wed, 3 Jun 2009 01:34:57 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andi Kleen <andi@firstfloor.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch][v2] swap: virtual swap readahead
Message-ID: <20090602233457.GY1065@one.firstfloor.org>
References: <20090602223738.GA15475@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090602223738.GA15475@cmpxchg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 03, 2009 at 12:37:39AM +0200, Johannes Weiner wrote:
> + *
> + * Caller must hold down_read on the vma->vm_mm if vma is not NULL.
> + */
> +struct page *swapin_readahead(swp_entry_t entry, gfp_t gfp_mask,
> +			struct vm_area_struct *vma, unsigned long addr)
> +{
> +	unsigned long start, pos, end;
> +	unsigned long pmin, pmax;
> +	int cluster, window;
> +
> +	if (!vma || !vma->vm_mm)	/* XXX: shmem case */
> +		return swapin_readahead_phys(entry, gfp_mask, vma, addr);
> +
> +	cluster = 1 << page_cluster;
> +	window = cluster << PAGE_SHIFT;
> +
> +	/* Physical range to read from */
> +	pmin = swp_offset(entry) & ~(cluster - 1);

Is cluster really properly sign extended on 64bit? Looks a little
dubious. long from the start would be safer

> +
> +	/* Virtual range to read from */
> +	start = addr & ~(window - 1);

Same.

> +		pgd = pgd_offset(vma->vm_mm, pos);
> +		if (!pgd_present(*pgd))
> +			continue;
> +		pud = pud_offset(pgd, pos);
> +		if (!pud_present(*pud))
> +			continue;
> +		pmd = pmd_offset(pud, pos);
> +		if (!pmd_present(*pmd))
> +			continue;
> +		pte = pte_offset_map_lock(vma->vm_mm, pmd, pos, &ptl);

You could be more efficient here by using the standard mm/* nested loop
pattern that avoids relookup of everything in each iteration. I suppose
it would mainly make a difference with 32bit highpte where mapping a pte
can be somewhat costly. And you would take less locks this way.

> +		page = read_swap_cache_async(swp, gfp_mask, vma, pos);
> +		if (!page)
> +			continue;

That's out of memory, break would be better here because prefetch
while oom is usually harmful.

> +		page_cache_release(page);
> +	}
> +	lru_add_drain();	/* Push any new pages onto the LRU now */
> +	return read_swap_cache_async(entry, gfp_mask, vma, addr);

Shouldn't that page be already handled in the loop earlier? Why doing that
again? It would be better to remember it from there.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
