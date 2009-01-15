Return-Path: <linux-kernel-owner+w=401wt.eu-S936359AbZAOW4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936359AbZAOW4U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 17:56:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934002AbZAOWc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 17:32:29 -0500
Received: from kroah.org ([198.145.64.141]:56136 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S935499AbZAOWc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 17:32:27 -0500
Date: Thu, 15 Jan 2009 14:31:17 -0800
From: Greg KH <greg@kroah.com>
To: Nick Piggin <npiggin@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Nick Piggin <npiggin@suse.de>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [patch 68/85] fs: symlink write_begin allocation context fix
Message-ID: <20090115223117.GA30560@kroah.com>
References: <20090115215237.906089480@mini.kroah.org> <20090115220136.GQ17227@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090115220136.GQ17227@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2009 at 02:01:36PM -0800, Greg KH wrote:
> 2.6.27-stable review patch.  If anyone has any objections, please let us know.

Hm, I think I got the backport of this patch wrong in two place:

> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -2033,7 +2033,7 @@ int pagecache_write_begin(struct file *f
>  		struct inode *inode = mapping->host;
>  		struct page *page;
>  again:
> -		page = __grab_cache_page(mapping, index);
> +		page = grab_cache_page_write_begin(mapping, index, flags);

I think this shouldn't be "flags", but 0, right?

>  		*pagep = page;
>  		if (!page)
>  			return -ENOMEM;
> @@ -2197,19 +2197,24 @@ EXPORT_SYMBOL(generic_file_direct_write)
>   * Find or create a page at the given pagecache position. Return the locked
>   * page. This function is specifically for buffered writes.
>   */
> -struct page *__grab_cache_page(struct address_space *mapping, pgoff_t index)
> +struct page *grab_cache_page_write_begin(struct address_space *mapping,
> +					pgoff_t index, unsigned flags)
>  {
>  	int status;
>  	struct page *page;
> +	gfp_t gfp_notmask = 0;
> +	if (flags & AOP_FLAG_NOFS)
> +		gfp_notmask = __GFP_FS;
>  repeat:
>  	page = find_lock_page(mapping, index);
>  	if (likely(page))
>  		return page;
>  
> -	page = page_cache_alloc(mapping);
> +	page = __page_cache_alloc(mapping_gfp_mask(mapping) & ~gfp_notmask);
>  	if (!page)
>  		return NULL;
> -	status = add_to_page_cache_lru(page, mapping, index, GFP_KERNEL);
> +	status = add_to_page_cache_lru(page, mapping, index,
> +						GFP_KERNEL & ~gfp_notmask);
>  	if (unlikely(status)) {
>  		page_cache_release(page);
>  		if (status == -EEXIST)
> @@ -2218,7 +2223,7 @@ repeat:
>  	}
>  	return page;
>  }
> -EXPORT_SYMBOL(__grab_cache_page);
> +EXPORT_SYMBOL(grab_cache_page_write_begin);
>  
>  static ssize_t generic_perform_write_2copy(struct file *file,
>  				struct iov_iter *i, loff_t pos)
> @@ -2263,7 +2268,7 @@ static ssize_t generic_perform_write_2co
>  			break;
>  		}
>  
> -		page = __grab_cache_page(mapping, index);
> +		page = grab_cache_page_write_begin(mapping, index, GFP_KERNEL);

And this one?  Is GFP_KERNEL ok, or 0?

Nick, your thoughts?

greg "i'm no mm hacker" k-h
