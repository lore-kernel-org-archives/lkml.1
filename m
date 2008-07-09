Return-Path: <linux-kernel-owner+w=401wt.eu-S1756681AbYGIHmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681AbYGIHmV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 03:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755606AbYGIHl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 03:41:58 -0400
Received: from smtp111.mail.mud.yahoo.com ([209.191.84.64]:22880 "HELO
	smtp111.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755569AbYGIHl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 03:41:57 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=V0yZI86Am/YN5Lkj1eGt/6Ze/b5m9oSwjqthUfhbr1zI9eof8HzXVYGYRpd0KWW6N24lm9496qkGRgGQJVXKHT0fVOfhrxaaKdIy7Nmci+y88FyTyYHY94wkGUFlql9hMTYr23xOn7Lu3R3T8S5QzK8PmtAj41ysAdPM+G6xIFk=  ;
X-YMail-OSG: nSQxn3UVM1kkAZTrCCge6jxU23_gUeZVrK9dnK9iSlt80P_c4vNILE.vGkRD1sDCzGF4jTnzUuN6HrQaJjMT78JYD8Db7UIBLGIKFGB63Fm92x4riZmsw4z2AG04Sml4TlE-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Subject: Re: [PATCH] fix task dirty balancing
Date: Wed, 9 Jul 2008 17:41:24 +1000
User-Agent: KMail/1.9.5
Cc: a.p.zijlstra@chello.nl, kamezawa.hiroyu@jp.fujitsu.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org
References: <1215250202.6320.10.camel@lappy.programming.kicks-ass.net> <20080708233841.AAECF5A1C@siro.lan>
In-Reply-To: <20080708233841.AAECF5A1C@siro.lan>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807091741.25447.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 July 2008 09:38, YAMAMOTO Takashi wrote:
> hi,
>
> > Please beat me to cleaning up this stuff - otherwise I'll have to look
> > at it when I get back from holidays.
>
> how about the following?

Quite good, however I would like to keep the buffers warning if it isn't
too difficult (it has already caught one or two real bugs). Also, we should
split out the bugfix from the cleanup. But yes overall I think the result
looks quite nice.


> YAMAMOTO Takashi
>
>
> Signed-off-by: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
> ---
>
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 4ffb5bb..1bc833d 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -699,41 +699,6 @@ void mark_buffer_dirty_inode(struct buffer_head *bh,
> struct inode *inode) EXPORT_SYMBOL(mark_buffer_dirty_inode);
>
>  /*
> - * Mark the page dirty, and set it dirty in the radix tree, and mark the
> inode - * dirty.
> - *
> - * If warn is true, then emit a warning if the page is not uptodate and
> has - * not been truncated.
> - */
> -static int __set_page_dirty(struct page *page,
> -		struct address_space *mapping, int warn)
> -{
> -	if (unlikely(!mapping))
> -		return !TestSetPageDirty(page);
> -
> -	if (TestSetPageDirty(page))
> -		return 0;
> -
> -	spin_lock_irq(&mapping->tree_lock);
> -	if (page->mapping) {	/* Race with truncate? */
> -		WARN_ON_ONCE(warn && !PageUptodate(page));
> -
> -		if (mapping_cap_account_dirty(mapping)) {
> -			__inc_zone_page_state(page, NR_FILE_DIRTY);
> -			__inc_bdi_stat(mapping->backing_dev_info,
> -					BDI_RECLAIMABLE);
> -			task_io_account_write(PAGE_CACHE_SIZE);
> -		}
> -		radix_tree_tag_set(&mapping->page_tree,
> -				page_index(page), PAGECACHE_TAG_DIRTY);
> -	}
> -	spin_unlock_irq(&mapping->tree_lock);
> -	__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
> -
> -	return 1;
> -}
> -
> -/*
>   * Add a page to the dirty page list.
>   *
>   * It is a sad fact of life that this function is called from several
> places @@ -762,22 +727,21 @@ int __set_page_dirty_buffers(struct page
> *page) {
>  	struct address_space *mapping = page_mapping(page);
>
> -	if (unlikely(!mapping))
> -		return !TestSetPageDirty(page);
> -
> -	spin_lock(&mapping->private_lock);
> -	if (page_has_buffers(page)) {
> -		struct buffer_head *head = page_buffers(page);
> -		struct buffer_head *bh = head;
> +	if (likely(mapping)) {
> +		spin_lock(&mapping->private_lock);
> +		if (page_has_buffers(page)) {
> +			struct buffer_head *head = page_buffers(page);
> +			struct buffer_head *bh = head;
>
> -		do {
> -			set_buffer_dirty(bh);
> -			bh = bh->b_this_page;
> -		} while (bh != head);
> +			do {
> +				set_buffer_dirty(bh);
> +				bh = bh->b_this_page;
> +			} while (bh != head);
> +		}
> +		spin_unlock(&mapping->private_lock);
>  	}
> -	spin_unlock(&mapping->private_lock);
>
> -	return __set_page_dirty(page, mapping, 1);
> +	return __set_page_dirty_nobuffers(page);
>  }
>  EXPORT_SYMBOL(__set_page_dirty_buffers);
>
> @@ -1220,7 +1184,7 @@ void mark_buffer_dirty(struct buffer_head *bh)
>  	}
>
>  	if (!test_set_buffer_dirty(bh))
> -		__set_page_dirty(bh->b_page, page_mapping(bh->b_page), 0);
> +		__set_page_dirty_nobuffers(bh->b_page);
>  }
>
>  /*
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 29b1d1e..e6fa69e 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -176,7 +176,7 @@ void bdi_writeout_inc(struct backing_dev_info *bdi)
>  }
>  EXPORT_SYMBOL_GPL(bdi_writeout_inc);
>
> -static inline void task_dirty_inc(struct task_struct *tsk)
> +static void task_dirty_inc(struct task_struct *tsk)
>  {
>  	prop_inc_single(&vm_dirties, &tsk->dirties);
>  }
> @@ -1074,12 +1074,14 @@ int __set_page_dirty_no_writeback(struct page
> *page) */
>  int __set_page_dirty_nobuffers(struct page *page)
>  {
> -	if (!TestSetPageDirty(page)) {
> -		struct address_space *mapping = page_mapping(page);
> -		struct address_space *mapping2;
> +	struct address_space *mapping;
>
> -		if (!mapping)
> -			return 1;
> +	if (TestSetPageDirty(page))
> +		return 0;
> +
> +	mapping = page_mapping(page);
> +	if (likely(mapping)) {
> +		struct address_space *mapping2;
>
>  		spin_lock_irq(&mapping->tree_lock);
>  		mapping2 = page_mapping(page);
> @@ -1100,9 +1102,11 @@ int __set_page_dirty_nobuffers(struct page *page)
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
> @@ -1122,7 +1126,7 @@ EXPORT_SYMBOL(redirty_page_for_writepage);
>   * If the mapping doesn't provide a set_page_dirty a_op, then
>   * just fall through and assume that it wants buffer_heads.
>   */
> -static int __set_page_dirty(struct page *page)
> +int set_page_dirty(struct page *page)
>  {
>  	struct address_space *mapping = page_mapping(page);
>
> @@ -1140,14 +1144,6 @@ static int __set_page_dirty(struct page *page)
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
