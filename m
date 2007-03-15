Return-Path: <linux-kernel-owner+w=401wt.eu-S1752778AbXCOJof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778AbXCOJof (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 05:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933459AbXCOJof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 05:44:35 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:38793 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752778AbXCOJoe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 05:44:34 -0400
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Filesystems <linux-fsdevel@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mark Fasheh <mark.fasheh@oracle.com>
Subject: Re: [patch 2/5] fs: introduce new aops and infrastructure
References: <20070314112529.13798.35417.sendpatchset@linux.site>
	<20070314112540.13798.97719.sendpatchset@linux.site>
From: Dmitriy Monakhov <dmonakhov@sw.ru>
Date: Thu, 15 Mar 2007 12:44:37 +0300
In-Reply-To: <20070314112540.13798.97719.sendpatchset@linux.site> (Nick Piggin's message of "Wed, 14 Mar 2007 14:38:22 +0100 (CET)")
Message-ID: <87bqiuzvqy.fsf@sw.ru>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <npiggin@suse.de> writes:

> Index: linux-2.6/fs/splice.c
> ===================================================================
> --- linux-2.6.orig/fs/splice.c
> +++ linux-2.6/fs/splice.c
> @@ -559,7 +559,7 @@ static int pipe_to_file(struct pipe_inod
>  	struct address_space *mapping = file->f_mapping;
>  	unsigned int offset, this_len;
>  	struct page *page;
> -	pgoff_t index;
> +	void *fsdata;
>  	int ret;
>  
>  	/*
> @@ -569,13 +569,13 @@ static int pipe_to_file(struct pipe_inod
>  	if (unlikely(ret))
>  		return ret;
>  
> -	index = sd->pos >> PAGE_CACHE_SHIFT;
>  	offset = sd->pos & ~PAGE_CACHE_MASK;
>  
>  	this_len = sd->len;
>  	if (this_len + offset > PAGE_CACHE_SIZE)
>  		this_len = PAGE_CACHE_SIZE - offset;
>  
> +#if 0
>  	/*
>  	 * Reuse buf page, if SPLICE_F_MOVE is set and we are doing a full
>  	 * page.
> @@ -587,86 +587,11 @@ static int pipe_to_file(struct pipe_inod
>  		 * locked on successful return.
>  		 */
>  		if (buf->ops->steal(pipe, buf))
> -			goto find_page;
> +#endif
One more note. It's looks like you just disabled all fancy zero copy logic.
Off corse this is just rfc patchset.
But i think where is fundamental problem with it:
 Previous logic was following:
  1)splice code responsible for: stealing(if possible) and loking the page
  2)prepare_write() code responsible for: do fs speciffic stuff

 But with new write_begin() logic  all steps (grubbing, locking, preparing)
 happened internaly inside write_begin() witch doesn't even know about what
 kind of data will be copied between write_begin/write_end.
 So fancy zero copy logic is impossible :(
I think this can be solved somehow, but i dont know yet, how can this be done
without implementing it inside begin_write().

>  
> -		page = buf->page;
> -		if (add_to_page_cache(page, mapping, index, GFP_KERNEL)) {
> -			unlock_page(page);
> -			goto find_page;
> -		}
> -
> -		page_cache_get(page);
> -
> -		if (!(buf->flags & PIPE_BUF_FLAG_LRU))
> -			lru_cache_add(page);
> -	} else {
> -find_page:
> -		page = find_lock_page(mapping, index);
> -		if (!page) {
> -			ret = -ENOMEM;
> -			page = page_cache_alloc_cold(mapping);
> -			if (unlikely(!page))
> -				goto out_ret;
> -
> -			/*
> -			 * This will also lock the page
> -			 */
> -			ret = add_to_page_cache_lru(page, mapping, index,
> -						    GFP_KERNEL);
> -			if (unlikely(ret))
> -				goto out;
> -		}
> -
> -		/*
> -		 * We get here with the page locked. If the page is also
> -		 * uptodate, we don't need to do more. If it isn't, we
> -		 * may need to bring it in if we are not going to overwrite
> -		 * the full page.
> -		 */
> -		if (!PageUptodate(page)) {
> -			if (this_len < PAGE_CACHE_SIZE) {
> -				ret = mapping->a_ops->readpage(file, page);
> -				if (unlikely(ret))
> -					goto out;
> -
> -				lock_page(page);
> -
> -				if (!PageUptodate(page)) {
> -					/*
> -					 * Page got invalidated, repeat.
> -					 */
> -					if (!page->mapping) {
> -						unlock_page(page);
> -						page_cache_release(page);
> -						goto find_page;
> -					}
> -					ret = -EIO;
> -					goto out;
> -				}
> -			} else
> -				SetPageUptodate(page);
> -		}
> -	}
> -
> -	ret = mapping->a_ops->prepare_write(file, page, offset, offset+this_len);
> -	if (unlikely(ret)) {
> -		loff_t isize = i_size_read(mapping->host);
> -
> -		if (ret != AOP_TRUNCATED_PAGE)
> -			unlock_page(page);
> -		page_cache_release(page);
> -		if (ret == AOP_TRUNCATED_PAGE)
> -			goto find_page;
> -
> -		/*
> -		 * prepare_write() may have instantiated a few blocks
> -		 * outside i_size.  Trim these off again.
> -		 */
> -		if (sd->pos + this_len > isize)
> -			vmtruncate(mapping->host, isize);
> -
> -		goto out_ret;
> -	}
> +	ret = pagecache_write_begin(file, mapping, sd->pos, sd->len, 0, &page, &fsdata);
> +	if (unlikely(ret))
> +		goto out;
>  
>  	if (buf->page != page) {
>  		/*
> @@ -676,28 +601,13 @@ find_page:
>  		char *dst = kmap_atomic(page, KM_USER1);
>  
>  		memcpy(dst + offset, src + buf->offset, this_len);
> -		flush_dcache_page(page);
>  		kunmap_atomic(dst, KM_USER1);
>  		buf->ops->unmap(pipe, buf, src);
>  	}
>  
> -	ret = mapping->a_ops->commit_write(file, page, offset, offset+this_len);
> -	if (!ret) {
> -		/*
> -		 * Return the number of bytes written and mark page as
> -		 * accessed, we are now done!
> -		 */
> -		ret = this_len;
> -		mark_page_accessed(page);
> -		balance_dirty_pages_ratelimited(mapping);
> -	} else if (ret == AOP_TRUNCATED_PAGE) {
> -		page_cache_release(page);
> -		goto find_page;
> -	}
> +	ret = pagecache_write_end(file, mapping, sd->pos, sd->len, sd->len, page, fsdata);
> +
>  out:
> -	page_cache_release(page);
> -	unlock_page(page);
> -out_ret:
>  	return ret;
>  }
>  

