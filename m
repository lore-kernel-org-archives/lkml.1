Return-Path: <linux-kernel-owner+w=401wt.eu-S1754766Ab0AMGHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab0AMGHd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 01:07:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752499Ab0AMGHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 01:07:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33723 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859Ab0AMGHa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 01:07:30 -0500
Date: Wed, 13 Jan 2010 17:07:34 +1100
From: Nick Piggin <npiggin@suse.de>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] vfs: Fix vmtruncate() regression
Message-ID: <20100113060734.GC3901@nick>
References: <876378jxhx.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <876378jxhx.fsf@devron.myhome.or.jp>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 12, 2010 at 03:40:42AM +0900, OGAWA Hirofumi wrote:
> Hi,
> 
> Could you review this one?
> 
> 
> 
> If __block_prepare_write() was failed in block_write_begin(), the
> allocated blocks can be outside of ->i_size.
> 
> But new truncate_pagecache() in vmtuncate() does nothing if new < old.
> It means the above usage is not working anymore.
> 
> So, this patch fixes it by removing "new < old" check. It would need
> more cleanup/change. But, now -rc and truncate working is in progress,
> so, this tried to fix it minimum change.
> 
> Cc: stable@kernel.org
> Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

Hmm, truncate_pagecache() is for truncating the mm/vm part of the
pagecache. vmtruncate should still call inode->i_op->truncate() to
trim blocks if required.

However I'd say we do still need to ensure do_invalidatepage is
called for the page, for private metadata. So yes I think your patch
looks good.

Acked-by: Nick Piggin <npiggin@suse.de>

Please apply to mainline and 2.6.32.

> ---
> 
>  mm/truncate.c |   28 +++++++++++++---------------
>  1 file changed, 13 insertions(+), 15 deletions(-)
> 
> diff -puN mm/truncate.c~truncate_pagecache-fix mm/truncate.c
> --- linux-2.6/mm/truncate.c~truncate_pagecache-fix	2010-01-12 02:41:27.000000000 +0900
> +++ linux-2.6-hirofumi/mm/truncate.c	2010-01-12 02:42:53.000000000 +0900
> @@ -522,22 +522,20 @@ EXPORT_SYMBOL_GPL(invalidate_inode_pages
>   */
>  void truncate_pagecache(struct inode *inode, loff_t old, loff_t new)
>  {
> -	if (new < old) {
> -		struct address_space *mapping = inode->i_mapping;
> +	struct address_space *mapping = inode->i_mapping;
>  
> -		/*
> -		 * unmap_mapping_range is called twice, first simply for
> -		 * efficiency so that truncate_inode_pages does fewer
> -		 * single-page unmaps.  However after this first call, and
> -		 * before truncate_inode_pages finishes, it is possible for
> -		 * private pages to be COWed, which remain after
> -		 * truncate_inode_pages finishes, hence the second
> -		 * unmap_mapping_range call must be made for correctness.
> -		 */
> -		unmap_mapping_range(mapping, new + PAGE_SIZE - 1, 0, 1);
> -		truncate_inode_pages(mapping, new);
> -		unmap_mapping_range(mapping, new + PAGE_SIZE - 1, 0, 1);
> -	}
> +	/*
> +	 * unmap_mapping_range is called twice, first simply for
> +	 * efficiency so that truncate_inode_pages does fewer
> +	 * single-page unmaps.  However after this first call, and
> +	 * before truncate_inode_pages finishes, it is possible for
> +	 * private pages to be COWed, which remain after
> +	 * truncate_inode_pages finishes, hence the second
> +	 * unmap_mapping_range call must be made for correctness.
> +	 */
> +	unmap_mapping_range(mapping, new + PAGE_SIZE - 1, 0, 1);
> +	truncate_inode_pages(mapping, new);
> +	unmap_mapping_range(mapping, new + PAGE_SIZE - 1, 0, 1);
>  }
>  EXPORT_SYMBOL(truncate_pagecache);
>  
> _
> 
> -- 
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
