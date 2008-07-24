Return-Path: <linux-kernel-owner+w=401wt.eu-S1758275AbYGXPJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758275AbYGXPJg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 11:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757928AbYGXPJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 11:09:06 -0400
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:46812 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757893AbYGXPJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 11:09:03 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=H9d+1ekyfeeElqEAVB/4KOEoOm3klyoqWnFCciVdTtHGP2oAsFLHA8wbNb7B8fA8wXTkLAgJ8i6GcIHOjldNuKjniVYQ56sTiwdhMHj2Fa57sy2vrEIHld32sPPjsD6MWMAThQZprZE7qvHobROUl9Nr1kHwoha+aFX/wmTr8ek=  ;
X-YMail-OSG: v0kaVCYVM1n0ty.xI7JZbXpfTDH.oxW9zLFrzBNC2blUye8xLIeD9exT5uWkZLcuNLBD2RNkC29QUD6ErkdhoFfeqbiPek.5Krcyh6_alh3sIFTC5ZdnC7Foq5AyGCqZY7A-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Subject: Re: [PATCH] fix task dirty balancing
Date: Fri, 25 Jul 2008 01:08:50 +1000
User-Agent: KMail/1.9.5
Cc: a.p.zijlstra@chello.nl, kamezawa.hiroyu@jp.fujitsu.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org
References: <200807101723.36713.nickpiggin@yahoo.com.au> <20080724002706.008305A56@siro.lan>
In-Reply-To: <20080724002706.008305A56@siro.lan>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807250108.50824.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday 24 July 2008 10:27, YAMAMOTO Takashi wrote:

> ok, i removed the cleanup part because i don't want to participate in
> this kind of discussion.
> is the following patch ok for you? 

Thanks, it looks good. I don't think we need to export task_dirty_inc,
as buffer.c cannot be built as a module. But otherwise,

Acked-by: Nick Piggin <npiggin@suse.de>

It would be nice to get this into 2.6.27.


> YAMAMOTO Takashi
>
>
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
> @@ -1167,6 +1167,7 @@ extern int filemap_fault(struct vm_area_struct *,
> struct vm_fault *);
>
>  /* mm/page-writeback.c */
>  int write_one_page(struct page *page, int wait);
> +void task_dirty_inc(struct task_struct *tsk);
>
>  /* readahead.c */
>  #define VM_MAX_READAHEAD	128	/* kbytes */
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 29b1d1e..382f742 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -176,10 +176,11 @@ void bdi_writeout_inc(struct backing_dev_info *bdi)
>  }
>  EXPORT_SYMBOL_GPL(bdi_writeout_inc);
>
> -static inline void task_dirty_inc(struct task_struct *tsk)
> +void task_dirty_inc(struct task_struct *tsk)
>  {
>  	prop_inc_single(&vm_dirties, &tsk->dirties);
>  }
> +EXPORT_SYMBOL_GPL(task_dirty_inc);
>
>  /*
>   * Obtain an accurate fraction of the BDI's portion.
> @@ -1074,8 +1075,13 @@ int __set_page_dirty_no_writeback(struct page *page)
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
> @@ -1100,9 +1106,11 @@ int __set_page_dirty_nobuffers(struct page *page)
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
> @@ -1122,7 +1130,7 @@ EXPORT_SYMBOL(redirty_page_for_writepage);
>   * If the mapping doesn't provide a set_page_dirty a_op, then
>   * just fall through and assume that it wants buffer_heads.
>   */
> -static int __set_page_dirty(struct page *page)
> +int set_page_dirty(struct page *page)
>  {
>  	struct address_space *mapping = page_mapping(page);
>
> @@ -1140,14 +1148,6 @@ static int __set_page_dirty(struct page *page)
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
