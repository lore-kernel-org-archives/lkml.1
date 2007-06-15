Return-Path: <linux-kernel-owner+w=401wt.eu-S1756599AbXFOBiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599AbXFOBiK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 21:38:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752014AbXFOBh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 21:37:58 -0400
Received: from ns1.suse.de ([195.135.220.2]:46494 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751491AbXFOBh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 21:37:57 -0400
Date: Fri, 15 Jun 2007 03:37:56 +0200
From: Nick Piggin <npiggin@suse.de>
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Vladimir Saveliev <vs@namesys.com>, linux-kernel@vger.kernel.org,
       reiserfs-dev@namesys.com
Subject: Re: [-mm patch] fs/reiserfs/: cleanups
Message-ID: <20070615013756.GC29085@wotan.suse.de>
References: <20070606220313.8f7c1fab.akpm@linux-foundation.org> <20070614221628.GB3588@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070614221628.GB3588@stusta.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2007 at 12:16:28AM +0200, Adrian Bunk wrote:
> This patch contains the following cleanups:
> - remove the following no longer used functions:
>   - bitmap.c: reiserfs_claim_blocks_to_be_allocated()
>   - bitmap.c: reiserfs_release_claimed_blocks()
>   - bitmap.c: reiserfs_can_fit_pages()
> - make the following functions static:
>   - inode.c: restart_transaction()
>   - journal.c: reiserfs_async_progress_wait()

If Vladimir acks this one then it's obviously fine by me.

 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
> 
> ---
> 
>  fs/reiserfs/bitmap.c        |   57 ------------------------------------
>  fs/reiserfs/inode.c         |    4 +-
>  fs/reiserfs/journal.c       |    3 +
>  include/linux/reiserfs_fs.h |    7 ----
>  4 files changed, 4 insertions(+), 67 deletions(-)
> 
> --- linux-2.6.22-rc4-mm2/include/linux/reiserfs_fs.h.old	2007-06-14 02:08:17.000000000 +0200
> +++ linux-2.6.22-rc4-mm2/include/linux/reiserfs_fs.h	2007-06-14 02:11:20.000000000 +0200
> @@ -1701,8 +1701,6 @@
>  	return th->t_blocks_allocated - th->t_blocks_logged;
>  }
>  
> -int reiserfs_async_progress_wait(struct super_block *s);
> -
>  struct reiserfs_transaction_handle *reiserfs_persistent_transaction(struct
>  								    super_block
>  								    *,
> @@ -1857,8 +1855,6 @@
>  #define GET_BLOCK_NO_IMUX     8	/* i_mutex is not held, don't preallocate */
>  #define GET_BLOCK_NO_DANGLE   16	/* don't leave any transactions running */
>  
> -int restart_transaction(struct reiserfs_transaction_handle *th,
> -			struct inode *inode, struct treepath *path);
>  void reiserfs_read_locked_inode(struct inode *inode,
>  				struct reiserfs_iget_args *args);
>  int reiserfs_find_actor(struct inode *inode, void *p);
> @@ -2135,9 +2131,6 @@
>  			       struct inode *inode);
>  void reiserfs_discard_all_prealloc(struct reiserfs_transaction_handle *th);
>  #endif
> -void reiserfs_claim_blocks_to_be_allocated(struct super_block *sb, int blocks);
> -void reiserfs_release_claimed_blocks(struct super_block *sb, int blocks);
> -int reiserfs_can_fit_pages(struct super_block *sb);
>  
>  /* hashes.c */
>  __u32 keyed_hash(const signed char *msg, int len);
> --- linux-2.6.22-rc4-mm2/fs/reiserfs/bitmap.c.old	2007-06-14 02:08:45.000000000 +0200
> +++ linux-2.6.22-rc4-mm2/fs/reiserfs/bitmap.c	2007-06-14 02:09:59.000000000 +0200
> @@ -1201,63 +1201,6 @@
>  	return ret;
>  }
>  
> -/* These 2 functions are here to provide blocks reservation to the rest of kernel */
> -/* Reserve @blocks amount of blocks in fs pointed by @sb. Caller must make sure
> -   there are actually this much blocks on the FS available */
> -void reiserfs_claim_blocks_to_be_allocated(struct super_block *sb,	/* super block of
> -									   filesystem where
> -									   blocks should be
> -									   reserved */
> -					   int blocks	/* How much to reserve */
> -    )
> -{
> -
> -	/* Fast case, if reservation is zero - exit immediately. */
> -	if (!blocks)
> -		return;
> -
> -	spin_lock(&REISERFS_SB(sb)->bitmap_lock);
> -	REISERFS_SB(sb)->reserved_blocks += blocks;
> -	spin_unlock(&REISERFS_SB(sb)->bitmap_lock);
> -}
> -
> -/* Unreserve @blocks amount of blocks in fs pointed by @sb */
> -void reiserfs_release_claimed_blocks(struct super_block *sb,	/* super block of
> -								   filesystem where
> -								   blocks should be
> -								   reserved */
> -				     int blocks	/* How much to unreserve */
> -    )
> -{
> -
> -	/* Fast case, if unreservation is zero - exit immediately. */
> -	if (!blocks)
> -		return;
> -
> -	spin_lock(&REISERFS_SB(sb)->bitmap_lock);
> -	REISERFS_SB(sb)->reserved_blocks -= blocks;
> -	spin_unlock(&REISERFS_SB(sb)->bitmap_lock);
> -	RFALSE(REISERFS_SB(sb)->reserved_blocks < 0,
> -	       "amount of blocks reserved became zero?");
> -}
> -
> -/* This function estimates how much pages we will be able to write to FS
> -   used for reiserfs_file_write() purposes for now. */
> -int reiserfs_can_fit_pages(struct super_block *sb	/* superblock of filesystem
> -							   to estimate space */ )
> -{
> -	int space;
> -
> -	spin_lock(&REISERFS_SB(sb)->bitmap_lock);
> -	space =
> -	    (SB_FREE_BLOCKS(sb) -
> -	     REISERFS_SB(sb)->reserved_blocks) >> (PAGE_CACHE_SHIFT -
> -						   sb->s_blocksize_bits);
> -	spin_unlock(&REISERFS_SB(sb)->bitmap_lock);
> -
> -	return space > 0 ? space : 0;
> -}
> -
>  void reiserfs_cache_bitmap_metadata(struct super_block *sb,
>                                      struct buffer_head *bh,
>                                      struct reiserfs_bitmap_info *info)
> --- linux-2.6.22-rc4-mm2/fs/reiserfs/inode.c.old	2007-06-14 02:10:35.000000000 +0200
> +++ linux-2.6.22-rc4-mm2/fs/reiserfs/inode.c	2007-06-14 02:10:59.000000000 +0200
> @@ -208,8 +208,8 @@
>  	return 0;
>  }
>  
> -/*static*/ int restart_transaction(struct reiserfs_transaction_handle *th,
> -				   struct inode *inode, struct treepath *path)
> +static int restart_transaction(struct reiserfs_transaction_handle *th,
> +			       struct inode *inode, struct treepath *path)
>  {
>  	struct super_block *s = th->t_super;
>  	int len = th->t_blocks_allocated;
> --- linux-2.6.22-rc4-mm2/fs/reiserfs/journal.c.old	2007-06-14 02:11:29.000000000 +0200
> +++ linux-2.6.22-rc4-mm2/fs/reiserfs/journal.c	2007-06-14 02:11:40.000000000 +0200
> @@ -966,7 +966,8 @@
>  	}
>  	return 0;
>  }
> -int reiserfs_async_progress_wait(struct super_block *s)
> +
> +static int reiserfs_async_progress_wait(struct super_block *s)
>  {
>  	DEFINE_WAIT(wait);
>  	struct reiserfs_journal *j = SB_JOURNAL(s);
