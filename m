Return-Path: <linux-kernel-owner+w=401wt.eu-S1754570AbZFCKBL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570AbZFCKBL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 06:01:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751985AbZFCKA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 06:00:59 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33588 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbZFCKA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 06:00:58 -0400
Date: Wed, 3 Jun 2009 12:00:59 +0200
From: Jan Kara <jack@suse.cz>
To: Mike Waychison <mikew@google.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, david@fromorbit.com,
       fengguang.wu@intel.com, nickpiggin@yahoo.com.au
Subject: Re: [PATCH] Remove __invalidate_mapping_pages variant
Message-ID: <20090603100059.GB12570@atrey.karlin.mff.cuni.cz>
References: <20090602221804.16461.15918.stgit@crlf.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090602221804.16461.15918.stgit@crlf.mtv.corp.google.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Remove __invalidate_mapping_pages atomic variant now that its sole caller can
> sleep (fixed in eccb95cee4f0d56faa46ef22fb94dd4a3578d3eb).
> 
> This fixes softlockups that can occur while in the drop_caches path.
> 
> Signed-off-by: Mike Waychison <mikew@google.com>
  Looks fine. Acked-by: Jan Kara <jack@suse.cz>

									Honza
> ---
> 
>  fs/drop_caches.c   |    2 +-
>  include/linux/fs.h |    3 ---
>  mm/truncate.c      |   39 ++++++++++++++++-----------------------
>  3 files changed, 17 insertions(+), 27 deletions(-)
> 
> diff --git a/fs/drop_caches.c b/fs/drop_caches.c
> index b6a719a..a2edb79 100644
> --- a/fs/drop_caches.c
> +++ b/fs/drop_caches.c
> @@ -24,7 +24,7 @@ static void drop_pagecache_sb(struct super_block *sb)
>  			continue;
>  		__iget(inode);
>  		spin_unlock(&inode_lock);
> -		__invalidate_mapping_pages(inode->i_mapping, 0, -1, true);
> +		invalidate_mapping_pages(inode->i_mapping, 0, -1);
>  		iput(toput_inode);
>  		toput_inode = inode;
>  		spin_lock(&inode_lock);
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 3b534e5..131dc03 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2043,9 +2043,6 @@ extern int __invalidate_device(struct block_device *);
>  extern int invalidate_partition(struct gendisk *, int);
>  #endif
>  extern int invalidate_inodes(struct super_block *);
> -unsigned long __invalidate_mapping_pages(struct address_space *mapping,
> -					pgoff_t start, pgoff_t end,
> -					bool be_atomic);
>  unsigned long invalidate_mapping_pages(struct address_space *mapping,
>  					pgoff_t start, pgoff_t end);
>  
> diff --git a/mm/truncate.c b/mm/truncate.c
> index 12e1579..ccc3ecf 100644
> --- a/mm/truncate.c
> +++ b/mm/truncate.c
> @@ -267,8 +267,21 @@ void truncate_inode_pages(struct address_space *mapping, loff_t lstart)
>  }
>  EXPORT_SYMBOL(truncate_inode_pages);
>  
> -unsigned long __invalidate_mapping_pages(struct address_space *mapping,
> -				pgoff_t start, pgoff_t end, bool be_atomic)
> +/**
> + * invalidate_mapping_pages - Invalidate all the unlocked pages of one inode
> + * @mapping: the address_space which holds the pages to invalidate
> + * @start: the offset 'from' which to invalidate
> + * @end: the offset 'to' which to invalidate (inclusive)
> + *
> + * This function only removes the unlocked pages, if you want to
> + * remove all the pages of one inode, you must call truncate_inode_pages.
> + *
> + * invalidate_mapping_pages() will not block on IO activity. It will not
> + * invalidate pages which are dirty, locked, under writeback or mapped into
> + * pagetables.
> + */
> +unsigned long invalidate_mapping_pages(struct address_space *mapping,
> +				       pgoff_t start, pgoff_t end)
>  {
>  	struct pagevec pvec;
>  	pgoff_t next = start;
> @@ -309,30 +322,10 @@ unlock:
>  				break;
>  		}
>  		pagevec_release(&pvec);
> -		if (likely(!be_atomic))
> -			cond_resched();
> +		cond_resched();
>  	}
>  	return ret;
>  }
> -
> -/**
> - * invalidate_mapping_pages - Invalidate all the unlocked pages of one inode
> - * @mapping: the address_space which holds the pages to invalidate
> - * @start: the offset 'from' which to invalidate
> - * @end: the offset 'to' which to invalidate (inclusive)
> - *
> - * This function only removes the unlocked pages, if you want to
> - * remove all the pages of one inode, you must call truncate_inode_pages.
> - *
> - * invalidate_mapping_pages() will not block on IO activity. It will not
> - * invalidate pages which are dirty, locked, under writeback or mapped into
> - * pagetables.
> - */
> -unsigned long invalidate_mapping_pages(struct address_space *mapping,
> -				pgoff_t start, pgoff_t end)
> -{
> -	return __invalidate_mapping_pages(mapping, start, end, false);
> -}
>  EXPORT_SYMBOL(invalidate_mapping_pages);
>  
>  /*
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
