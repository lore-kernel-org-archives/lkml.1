Return-Path: <linux-kernel-owner+w=401wt.eu-S1752722AbZINNdI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722AbZINNdI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 09:33:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752090AbZINNdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 09:33:07 -0400
Received: from cantor.suse.de ([195.135.220.2]:47251 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751571AbZINNdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 09:33:05 -0400
Date: Mon, 14 Sep 2009 15:33:07 +0200
From: Jan Kara <jack@suse.cz>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, hch@infradead.org, tytso@mit.edu,
       akpm@linux-foundation.org, jack@suse.cz, trond.myklebust@fys.uio.no
Subject: Re: [PATCH 6/7] writeback: separate starting of sync vs
	opportunistic writeback
Message-ID: <20090914133307.GJ24075@duck.suse.cz>
References: <1252920994-11141-1-git-send-email-jens.axboe@oracle.com> <1252920994-11141-7-git-send-email-jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252920994-11141-7-git-send-email-jens.axboe@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 14-09-09 11:36:33, Jens Axboe wrote:
> bdi_start_writeback() is currently split into two paths, one for
> WB_SYNC_NONE and one for WB_SYNC_ALL. Add bdi_sync_writeback()
> for WB_SYNC_ALL writeback and let bdi_start_writeback() handle
> only WB_SYNC_NONE.
  What I don't like about this patch is that if somebody sets up
writeback_control with WB_SYNC_ALL mode set and then submits it to disk via
bdi_start_writeback() it will just silently convert his writeback to an
asynchronous one.
  So I'd maybe leave setting of sync_mode to the caller and just WARN_ON if
it does not match the purpose of the function...

									Honza

> 
> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> ---
>  fs/fs-writeback.c   |   51 ++++++++++++++++++++++++++++++++++-----------------
>  mm/page-writeback.c |    1 -
>  2 files changed, 34 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 5cd8b3b..64ca471 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -204,24 +204,42 @@ static void bdi_alloc_queue_work(struct backing_dev_info *bdi,
>  	}
>  }
>  
> -void bdi_start_writeback(struct writeback_control *wbc)
> +/**
> + * bdi_sync_writeback - start and wait for writeback
> + * @wbc: writeback parameters
> + *
> + * Description:
> + *   This does WB_SYNC_ALL data integrity writeback and waits for the
> + *   IO to complete. Callers must hold the sb s_umount semaphore for
> + *   reading, to avoid having the super disappear before we are done.
> + */
> +static void bdi_sync_writeback(struct writeback_control *wbc)
>  {
> -	/*
> -	 * WB_SYNC_NONE is opportunistic writeback. If this allocation fails,
> -	 * bdi_queue_work() will wake up the thread and flush old data. This
> -	 * should ensure some amount of progress in freeing memory.
> -	 */
> -	if (wbc->sync_mode != WB_SYNC_ALL)
> -		bdi_alloc_queue_work(wbc->bdi, wbc);
> -	else {
> -		struct bdi_work work;
> +	struct bdi_work work;
>  
> -		bdi_work_init(&work, wbc);
> -		work.state |= WS_ONSTACK;
> +	wbc->sync_mode = WB_SYNC_ALL;
>  
> -		bdi_queue_work(wbc->bdi, &work);
> -		bdi_wait_on_work_clear(&work);
> -	}
> +	bdi_work_init(&work, wbc);
> +	work.state |= WS_ONSTACK;
> +
> +	bdi_queue_work(wbc->bdi, &work);
> +	bdi_wait_on_work_clear(&work);
> +}
> +
> +/**
> + * bdi_start_writeback - start writeback
> + * @wbc: writeback parameters
> + *
> + * Description:
> + *   This does WB_SYNC_NONE opportunistic writeback. The IO is only
> + *   started when this function returns, we make no guarentees on
> + *   completion. Caller need not hold sb s_umount semaphore.
> + *
> + */
> +void bdi_start_writeback(struct writeback_control *wbc)
> +{
> +	wbc->sync_mode = WB_SYNC_NONE;
> +	bdi_alloc_queue_work(wbc->bdi, wbc);
>  }
>  
>  /*
> @@ -1119,14 +1137,13 @@ long sync_inodes_sb(struct super_block *sb)
>  	struct writeback_control wbc = {
>  		.sb		= sb,
>  		.bdi		= sb->s_bdi,
> -		.sync_mode	= WB_SYNC_ALL,
>  		.range_start	= 0,
>  		.range_end	= LLONG_MAX,
>  	};
>  	long nr_to_write = LONG_MAX; /* doesn't actually matter */
>  
>  	wbc.nr_to_write = nr_to_write;
> -	bdi_start_writeback(&wbc);
> +	bdi_sync_writeback(&wbc);
>  	wait_sb_inodes(&wbc);
>  	return nr_to_write - wbc.nr_to_write;
>  }
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index a5f0f76..f61f0cc 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -585,7 +585,6 @@ static void balance_dirty_pages(struct address_space *mapping)
>  					  > background_thresh))) {
>  		struct writeback_control wbc = {
>  			.bdi		= bdi,
> -			.sync_mode	= WB_SYNC_NONE,
>  			.nr_to_write	= nr_writeback,
>  		};
>  
> -- 
> 1.6.4.1.207.g68ea
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
