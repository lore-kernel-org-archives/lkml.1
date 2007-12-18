Return-Path: <linux-kernel-owner+w=401wt.eu-S1752588AbXLRITT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588AbXLRITT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 03:19:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751733AbXLRITL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 03:19:11 -0500
Received: from mail.suse.de ([195.135.220.2]:45180 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751555AbXLRITK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 03:19:10 -0500
Date: Tue, 18 Dec 2007 09:19:07 +0100
From: Nick Piggin <npiggin@suse.de>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Andrew Morton <akpm@osdl.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/9] readahead: clean up and simplify the code for filemap page fault readahead
Message-ID: <20071218081907.GB32114@wotan.suse.de>
References: <20071216115927.986126305@mail.ustc.edu.cn> <20071216120417.748714367@mail.ustc.edu.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071216120417.748714367@mail.ustc.edu.cn>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 16, 2007 at 07:59:30PM +0800, Fengguang Wu wrote:

> @@ -1321,78 +1401,69 @@ int filemap_fault(struct vm_area_struct 
>  	struct address_space *mapping = file->f_mapping;
>  	struct file_ra_state *ra = &file->f_ra;
>  	struct inode *inode = mapping->host;
> +	pgoff_t offset = vmf->pgoff;
>  	struct page *page;
>  	unsigned long size;
> -	int did_readaround = 0;
>  	int ret = 0;
>  
>  	size = (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
>  	if (vmf->pgoff >= size)
>  		return VM_FAULT_SIGBUS;
>  
> -	/* If we don't want any read-ahead, don't bother */
> -	if (VM_RandomReadHint(vma))
> -		goto no_cached_page;
> -
>  	/*
> -	 * Do we have something in the page cache already?
> +	 * Do we have something in the page cache already that
> +	 * is unlocked and already up-to-date?
>  	 */
> -retry_find:
> -	page = find_lock_page(mapping, vmf->pgoff);
> -	/*
> -	 * For sequential accesses, we use the generic readahead logic.
> -	 */
> -	if (VM_SequentialReadHint(vma)) {
> -		if (!page) {
> -			page_cache_sync_readahead(mapping, ra, file,
> -							   vmf->pgoff, 1);
> -			page = find_lock_page(mapping, vmf->pgoff);
> -			if (!page)
> -				goto no_cached_page;
> -		}
> -		if (PageReadahead(page)) {
> -			page_cache_async_readahead(mapping, ra, file, page,
> -							   vmf->pgoff, 1);
> -		}
> -	}
> +	read_lock_irq(&mapping->tree_lock);
> +	page = radix_tree_lookup(&mapping->page_tree, offset);
> +	if (likely(page)) {
> +		int got_lock, uptodate;
> +		page_cache_get(page);
> +
> +		got_lock = !TestSetPageLocked(page);
> +		uptodate = PageUptodate(page);
> +		read_unlock_irq(&mapping->tree_lock);

If we could avoid open coding tree_lock here (and expanding its coverage
to PageUptodate), that would be nice. I don't think it gains us too much.
