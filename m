Return-Path: <linux-kernel-owner+w=401wt.eu-S1757267Ab0ANWcK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267Ab0ANWcK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 17:32:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757166Ab0ANWcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 17:32:06 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52162 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754697Ab0ANWcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 17:32:03 -0500
Date: Thu, 14 Jan 2010 14:30:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Al Viro <viro@zeniv.linux.org.uk>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [PATCH] vfs: Fix vmtruncate() regression
Message-Id: <20100114143044.cc65be51.akpm@linux-foundation.org>
In-Reply-To: <877hrmcicu.fsf@devron.myhome.or.jp>
References: <876378jxhx.fsf@devron.myhome.or.jp>
	<20100113060734.GC3901@nick>
	<87r5pucin4.fsf@devron.myhome.or.jp>
	<877hrmcicu.fsf@devron.myhome.or.jp>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jan 2010 21:14:09 +0900
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> wrote:

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
> Acked-by: Nick Piggin <npiggin@suse.de>
> Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> ---
> 
>  mm/truncate.c |   28 +++++++++++++---------------
>  1 file changed, 13 insertions(+), 15 deletions(-)
> 
> diff -puN mm/truncate.c~truncate_pagecache-fix mm/truncate.c
> --- linux-2.6/mm/truncate.c~truncate_pagecache-fix	2010-01-12 05:43:06.000000000 +0900
> +++ linux-2.6-hirofumi/mm/truncate.c	2010-01-12 05:43:06.000000000 +0900
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

The fix was applied to 2.6.33-rcX
(cedabed49b39b4319bccc059a63344b6232b619c), appears to be needed in
2.6.32.x but no cc:stable's are present?

