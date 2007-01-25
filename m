Return-Path: <linux-kernel-owner+w=401wt.eu-S1752110AbXAYEVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110AbXAYEVV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 23:21:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752115AbXAYEVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 23:21:21 -0500
Received: from smtp.osdl.org ([65.172.181.24]:45856 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752110AbXAYEVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 23:21:19 -0500
Date: Wed, 24 Jan 2007 20:21:07 -0800
From: Andrew Morton <akpm@osdl.org>
To: Evgeniy Dushistov <dushistov@mail.ru>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 3/3] ufs: rellocation fix
Message-Id: <20070124202107.4788d802.akpm@osdl.org>
In-Reply-To: <20070122150751.GA11129@rain>
References: <20070122150751.GA11129@rain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Jan 2007 18:07:51 +0300
Evgeniy Dushistov <dushistov@mail.ru> wrote:

> In blocks reallocation function sometimes does not update some
> of buffer_head::b_blocknr, which may and cause data damage.
> 
> Signed-off-by: Evgeniy Dushistov <dushistov@mail.ru>
> 
> ---
> 
> Index: linux-2.6.20-rc5/fs/ufs/balloc.c
> ===================================================================
> --- linux-2.6.20-rc5.orig/fs/ufs/balloc.c
> +++ linux-2.6.20-rc5/fs/ufs/balloc.c
> @@ -231,10 +231,10 @@ static void ufs_change_blocknr(struct in
>  			       unsigned int count, unsigned int oldb,
>  			       unsigned int newb, struct page *locked_page)
>  {
> -	unsigned int blk_per_page = 1 << (PAGE_CACHE_SHIFT - inode->i_blkbits);
> -	struct address_space *mapping = inode->i_mapping;
> +	const unsigned mask = (1 << (PAGE_CACHE_SHIFT - inode->i_blkbits)) - 1;
> +	struct address_space * const mapping = inode->i_mapping;
>  	pgoff_t index, cur_index;
> -	unsigned int i, j;
> +	unsigned i, pos, j;
>  	struct page *page;
>  	struct buffer_head *head, *bh;
>  
> @@ -246,7 +246,7 @@ static void ufs_change_blocknr(struct in
>  
>  	cur_index = locked_page->index;
>  
> -	for (i = 0; i < count; i += blk_per_page) {
> +	for (i = 0; i < count; i = (i | mask) + 1) {

This is a funny looking thing.  As far as I can tell, this is a more
complicated way of doing the same thing as the old code did.

Am I missing something?


>  		index = (baseblk+i) >> (PAGE_CACHE_SHIFT - inode->i_blkbits);
>  
>  		if (likely(cur_index != index)) {
> @@ -256,21 +256,32 @@ static void ufs_change_blocknr(struct in
>  		} else
>  			page = locked_page;
>  
> -		j = i;
>  		head = page_buffers(page);
>  		bh = head;
> +		pos = i & mask;

And this is equivalent to

		pos = 0;

?

> +		for (j = 0; j < pos; ++j)
> +			bh = bh->b_this_page;
> +		j = 0;
>  		do {
> -			if (likely(bh->b_blocknr == j + oldb && j < count)) {
> -				unmap_underlying_metadata(bh->b_bdev,
> -							  bh->b_blocknr);
> -				bh->b_blocknr = newb + j++;
> -				mark_buffer_dirty(bh);
> +			if (buffer_mapped(bh)) {
> +				pos = bh->b_blocknr - oldb;
> +				if (pos < count) {
> +					UFSD(" change from %llu to %llu\n",
> +					     (unsigned long long)pos + odlb,
> +					     (unsigned long long)pos + newb);
> +					bh->b_blocknr = newb + pos;
> +					unmap_underlying_metadata(bh->b_bdev,
> +								  bh->b_blocknr);
> +					mark_buffer_dirty(bh);
> +					++j;
> +				}
>  			}
>  
>  			bh = bh->b_this_page;
>  		} while (bh != head);
>  
> -		set_page_dirty(page);
> +		if (j)
> +			set_page_dirty(page);
>  
>  		if (likely(cur_index != index))
>  			ufs_put_locked_page(page);
> @@ -418,14 +429,14 @@ unsigned ufs_new_fragments(struct inode 
>  	}
>  	result = ufs_alloc_fragments (inode, cgno, goal, request, err);
>  	if (result) {
> +		ufs_clear_frags(inode, result + oldcount, newcount - oldcount,
> +				locked_page != NULL);
>  		ufs_change_blocknr(inode, fragment - oldcount, oldcount, tmp,
>  				   result, locked_page);
>  
>  		*p = cpu_to_fs32(sb, result);
>  		*err = 0;
>  		UFS_I(inode)->i_lastfrag = max_t(u32, UFS_I(inode)->i_lastfrag, fragment + count);
> -		ufs_clear_frags(inode, result + oldcount, newcount - oldcount,
> -				locked_page != NULL);
>  		unlock_super(sb);
>  		if (newcount < request)
>  			ufs_free_fragments (inode, result + newcount, request - newcount);
> -- 
> /Evgeniy
