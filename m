Return-Path: <linux-kernel-owner+w=401wt.eu-S1755427AbYAOQf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427AbYAOQf1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 11:35:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752059AbYAOQfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 11:35:18 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:42668 "EHLO
	viefep12-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751856AbYAOQfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 11:35:17 -0500
Subject: Re: [PATCH 2/2] Updating ctime and mtime at syncing
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Anton Salikhmetov <salikhmetov@gmail.com>
Cc: inux-mm@kvack.org, jakob@unthought.net, linux-kernel@vger.kernel.org,
       valdis.kletnieks@vt.edu, riel@redhat.com, ksm@42.dk,
       staubach@redhat.com, jesper.juhl@gmail.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       protasnb@gmail.com, miklos@szeredi.hu
In-Reply-To: <1200412978699-git-send-email-salikhmetov@gmail.com>
References: <12004129652397-git-send-email-salikhmetov@gmail.com>
	 <1200412978699-git-send-email-salikhmetov@gmail.com>
Content-Type: text/plain
Date: Tue, 15 Jan 2008 17:35:11 +0100
Message-Id: <1200414911.26045.32.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-01-15 at 19:02 +0300, Anton Salikhmetov wrote:

> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 3d3848f..53d0e34 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -997,35 +997,39 @@ int __set_page_dirty_no_writeback(struct page *page)
>   */
>  int __set_page_dirty_nobuffers(struct page *page)
>  {
> -	if (!TestSetPageDirty(page)) {
> -		struct address_space *mapping = page_mapping(page);
> -		struct address_space *mapping2;
> +	struct address_space *mapping = page_mapping(page);
> +	struct address_space *mapping2;
>  
> -		if (!mapping)
> -			return 1;
> +	if (!mapping)
> +		return 1;
>  
> -		write_lock_irq(&mapping->tree_lock);
> -		mapping2 = page_mapping(page);
> -		if (mapping2) { /* Race with truncate? */
> -			BUG_ON(mapping2 != mapping);
> -			WARN_ON_ONCE(!PagePrivate(page) && !PageUptodate(page));
> -			if (mapping_cap_account_dirty(mapping)) {
> -				__inc_zone_page_state(page, NR_FILE_DIRTY);
> -				__inc_bdi_stat(mapping->backing_dev_info,
> -						BDI_RECLAIMABLE);
> -				task_io_account_write(PAGE_CACHE_SIZE);
> -			}
> -			radix_tree_tag_set(&mapping->page_tree,
> -				page_index(page), PAGECACHE_TAG_DIRTY);
> -		}
> -		write_unlock_irq(&mapping->tree_lock);
> -		if (mapping->host) {
> -			/* !PageAnon && !swapper_space */
> -			__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
> +	mapping->mtime = CURRENT_TIME;
> +	set_bit(AS_MCTIME, &mapping->flags);

This seems vulnerable to the race we have against truncate, handled by
the mapping2 magic below. Do we care?

> +
> +	if (TestSetPageDirty(page))
> +		return 0;
> +
> +	write_lock_irq(&mapping->tree_lock);
> +	mapping2 = page_mapping(page);
> +	if (mapping2) {
> +		/* Race with truncate? */
> +		BUG_ON(mapping2 != mapping);
> +		WARN_ON_ONCE(!PagePrivate(page) && !PageUptodate(page));
> +		if (mapping_cap_account_dirty(mapping)) {
> +			__inc_zone_page_state(page, NR_FILE_DIRTY);
> +			__inc_bdi_stat(mapping->backing_dev_info,
> +					BDI_RECLAIMABLE);
> +			task_io_account_write(PAGE_CACHE_SIZE);
>  		}
> -		return 1;
> +		radix_tree_tag_set(&mapping->page_tree,
> +				page_index(page), PAGECACHE_TAG_DIRTY);
>  	}
> -	return 0;
> +	write_unlock_irq(&mapping->tree_lock);
> +
> +	if (mapping->host)
> +		__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
> +
> +	return 1;
>  }
>  EXPORT_SYMBOL(__set_page_dirty_nobuffers);
>  

