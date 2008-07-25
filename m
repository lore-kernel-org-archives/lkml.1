Return-Path: <linux-kernel-owner+w=401wt.eu-S1756145AbYGYJ57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145AbYGYJ57 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 05:57:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753533AbYGYJ5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 05:57:50 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:35347 "EHLO
	viefep12-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751220AbYGYJ5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 05:57:49 -0400
X-SourceIP: 62.163.52.83
Subject: Re: [PATCH] fix task dirty balancing
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: nickpiggin@yahoo.com.au, kamezawa.hiroyu@jp.fujitsu.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <20080725080454.C76EB5A53@siro.lan>
References: <200807250108.50824.nickpiggin@yahoo.com.au>
	 <20080725080454.C76EB5A53@siro.lan>
Content-Type: text/plain
Date: Fri, 25 Jul 2008 11:57:52 +0200
Message-Id: <1216979872.7257.361.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-07-25 at 17:04 +0900, YAMAMOTO Takashi wrote:

> Signed-off-by: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
> ---
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 4ffb5bb..3a89d58 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -708,27 +708,29 @@ EXPORT_SYMBOL(mark_buffer_dirty_inode);
>  static int __set_page_dirty(struct page *page,
>  		struct address_space *mapping, int warn)
>  {
> -	if (unlikely(!mapping))
> -		return !TestSetPageDirty(page);
>  
>  	if (TestSetPageDirty(page))
>  		return 0;
>  
> -	spin_lock_irq(&mapping->tree_lock);
> -	if (page->mapping) {	/* Race with truncate? */
> -		WARN_ON_ONCE(warn && !PageUptodate(page));
> +	if (likely(mapping)) {
> +		spin_lock_irq(&mapping->tree_lock);
> +		if (page->mapping) {	/* Race with truncate? */
> +			WARN_ON_ONCE(warn && !PageUptodate(page));
>  
> -		if (mapping_cap_account_dirty(mapping)) {
> -			__inc_zone_page_state(page, NR_FILE_DIRTY);
> -			__inc_bdi_stat(mapping->backing_dev_info,
> -					BDI_RECLAIMABLE);
> -			task_io_account_write(PAGE_CACHE_SIZE);
> +			if (mapping_cap_account_dirty(mapping)) {
> +				__inc_zone_page_state(page, NR_FILE_DIRTY);
> +				__inc_bdi_stat(mapping->backing_dev_info,
> +						BDI_RECLAIMABLE);
> +				task_io_account_write(PAGE_CACHE_SIZE);
> +			}
> +			radix_tree_tag_set(&mapping->page_tree,
> +					page_index(page), PAGECACHE_TAG_DIRTY);
>  		}
> -		radix_tree_tag_set(&mapping->page_tree,
> -				page_index(page), PAGECACHE_TAG_DIRTY);
> +		spin_unlock_irq(&mapping->tree_lock);
> +		__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
>  	}
> -	spin_unlock_irq(&mapping->tree_lock);
> -	__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
> +
> +	task_dirty_inc(current);
>  
>  	return 1;
>  }
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index a4eeb3c..33fd91a 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1167,6 +1167,7 @@ extern int filemap_fault(struct vm_area_struct *, struct vm_fault *);
>  
>  /* mm/page-writeback.c */
>  int write_one_page(struct page *page, int wait);
> +void task_dirty_inc(struct task_struct *tsk);
>  
>  /* readahead.c */
>  #define VM_MAX_READAHEAD	128	/* kbytes */
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 29b1d1e..e710481 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -176,7 +176,7 @@ void bdi_writeout_inc(struct backing_dev_info *bdi)
>  }
>  EXPORT_SYMBOL_GPL(bdi_writeout_inc);
>  
> -static inline void task_dirty_inc(struct task_struct *tsk)
> +void task_dirty_inc(struct task_struct *tsk)
>  {
>  	prop_inc_single(&vm_dirties, &tsk->dirties);
>  }
> @@ -1074,8 +1074,13 @@ int __set_page_dirty_no_writeback(struct page *page)
>   */
>  int __set_page_dirty_nobuffers(struct page *page)
>  {
> -	if (!TestSetPageDirty(page)) {
> -		struct address_space *mapping = page_mapping(page);
> +	struct address_space *mapping;
> +
> +	if (TestSetPageDirty(page))
> +		return 0;
> +
> +	mapping = page_mapping(page);
> +	if (likely(mapping)) {
>  		struct address_space *mapping2;
>  
>  		if (!mapping)

This results in funny code..

> @@ -1100,9 +1105,11 @@ int __set_page_dirty_nobuffers(struct page *page)
>  			/* !PageAnon && !swapper_space */
>  			__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
>  		}
> -		return 1;
>  	}
> -	return 0;
> +
> +	task_dirty_inc(current);
> +
> +	return 1;
>  }
>  EXPORT_SYMBOL(__set_page_dirty_nobuffers);
>  
> @@ -1122,7 +1129,7 @@ EXPORT_SYMBOL(redirty_page_for_writepage);
>   * If the mapping doesn't provide a set_page_dirty a_op, then
>   * just fall through and assume that it wants buffer_heads.
>   */
> -static int __set_page_dirty(struct page *page)
> +int set_page_dirty(struct page *page)
>  {
>  	struct address_space *mapping = page_mapping(page);
>  
> @@ -1140,14 +1147,6 @@ static int __set_page_dirty(struct page *page)
>  	}
>  	return 0;
>  }
> -
> -int set_page_dirty(struct page *page)
> -{
> -	int ret = __set_page_dirty(page);
> -	if (ret)
> -		task_dirty_inc(current);
> -	return ret;
> -}
>  EXPORT_SYMBOL(set_page_dirty);
>  
>  /*

