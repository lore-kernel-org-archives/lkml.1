Return-Path: <linux-kernel-owner+w=401wt.eu-S1758925AbZIPMyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758925AbZIPMyA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 08:54:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753040AbZIPMx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 08:53:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42473 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752891AbZIPMx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 08:53:57 -0400
Date: Wed, 16 Sep 2009 14:53:59 +0200
From: Jan Kara <jack@suse.cz>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, hch@infradead.org, tytso@mit.edu,
       akpm@linux-foundation.org, jack@suse.cz, trond.myklebust@fys.uio.no
Subject: Re: [PATCH 04/11] writeback: make wb_writeback() take an argument
	structure
Message-ID: <20090916125359.GE26030@duck.suse.cz>
References: <1253038617-30204-1-git-send-email-jens.axboe@oracle.com> <1253038617-30204-5-git-send-email-jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253038617-30204-5-git-send-email-jens.axboe@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 15-09-09 20:16:50, Jens Axboe wrote:
> We need to be able to pass in range_cyclic as well, so instead
> of growing yet another argument, split the arguments into a
> struct wb_writeback_args structure that we can use internally.
> Also makes it easier to just copy all members to an on-stack
> struct, since we can't access work after clearing the pending
> bit.
> 
> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> ---
>  fs/fs-writeback.c |   97 +++++++++++++++++++++++++++++++----------------------
>  1 files changed, 57 insertions(+), 40 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 783ed44..1dd11d1 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -35,6 +35,17 @@
>  int nr_pdflush_threads;
>  
>  /*
> + * Passed into wb_writeback(), essentially a subset of writeback_control
> + */
> +struct wb_writeback_args {
> +	long nr_pages;
> +	struct super_block *sb;
> +	enum writeback_sync_modes sync_mode;
> +	int for_kupdate;
> +	int range_cyclic;
> +};
  You can save a few bytes by using bit-fields for for_kupdate and
range_cyclic fields the same way as is done in wbc.

> @@ -69,9 +78,10 @@ static inline void bdi_work_init(struct bdi_work *work,
>  				 struct writeback_control *wbc)
>  {
>  	INIT_RCU_HEAD(&work->rcu_head);
> -	work->sb = wbc->sb;
> -	work->nr_pages = wbc->nr_to_write;
> -	work->sync_mode = wbc->sync_mode;
> +	work->args.sb = wbc->sb;
> +	work->args.nr_pages = wbc->nr_to_write;
> +	work->args.sync_mode = wbc->sync_mode;
> +	work->args.range_cyclic = wbc->range_cyclic;
>  	work->state = WS_USED;
>  }
  We don't pass for_kupdate here. But probably that's fine since noone else
should set it. But maybe we should at least initialize it?

> @@ -673,29 +682,35 @@ static long wb_writeback(struct bdi_writeback *wb, long nr_pages,
>  		oldest_jif = jiffies -
>  				msecs_to_jiffies(dirty_expire_interval * 10);
>  	}
> +	if (!wbc.range_cyclic) {
> +		wbc.range_start = 0;
> +		wbc.range_end = LLONG_MAX;
> +	}
>  
>  	for (;;) {
> -		/*
> -		 * Don't flush anything for non-integrity writeback where
> -		 * no nr_pages was given
> -		 */
> -		if (!for_kupdate && nr_pages <= 0 && sync_mode == WB_SYNC_NONE)
> -			break;
> +		if (!args->for_kupdate && args->nr_pages <= 0) {
> +			/*
> +			 * Don't flush anything for non-integrity writeback
> +			 * where no nr_pages was given
> +			 */
> +			if (args->sync_mode == WB_SYNC_NONE)
> +				break;
>  
> -		/*
> -		 * If no specific pages were given and this is just a
> -		 * periodic background writeout and we are below the
> -		 * background dirty threshold, don't do anything
> -		 */
> -		if (for_kupdate && nr_pages <= 0 && !over_bground_thresh())
> -			break;
> +			/*
> +			 * If no specific pages were given and this is just a
> +			 * periodic background writeout and we are below the
> +			 * background dirty threshold, don't do anything
> +			 */
> +			if (!over_bground_thresh())
> +				break;
> +		}
  This chunk actually changes the behavior since previously the second
condition had for_kupdate and not !for_kupdate. But revisiting this code,
the pdflush-style writeback still doesn't work how it used to. Merging
kupdate-style and pdflush-style writeback isn't that easy.
  For the first one we want to flush only the expired inodes, but we should
guarantee we really flush them.
  For the second one we want to flush as much data as possible and don't
really care about which inodes we flush. We only have to work until we hit
the background threshold.
  So probably check_old_data_flush() has to issue a kupdate-style writeback
like it does now and then it should loop submitting normal WB_SYNC_NONE
writeback until we get below background threshold. In theory, we could use
the look in wb_writeback() like we try now but that would mean we have to
pass another flag, whether this is a pdflush style writeback or not.
  
>  		wbc.more_io = 0;
>  		wbc.encountered_congestion = 0;
>  		wbc.nr_to_write = MAX_WRITEBACK_PAGES;
>  		wbc.pages_skipped = 0;
>  		writeback_inodes_wb(wb, &wbc);
> -		nr_pages -= MAX_WRITEBACK_PAGES - wbc.nr_to_write;
> +		args->nr_pages -= MAX_WRITEBACK_PAGES - wbc.nr_to_write;
>  		wrote += MAX_WRITEBACK_PAGES - wbc.nr_to_write;
>  
>  		/*
> @@ -749,8 +764,14 @@ static long wb_check_old_data_flush(struct bdi_writeback *wb)
>  			global_page_state(NR_UNSTABLE_NFS) +
>  			(inodes_stat.nr_inodes - inodes_stat.nr_unused);
>  
> -	if (nr_pages)
> -		return wb_writeback(wb, nr_pages, NULL, WB_SYNC_NONE, 1);
> +	if (nr_pages) {
> +		struct wb_writeback_args args = {
> +			.nr_pages	= nr_pages,
> +			.sync_mode	= WB_SYNC_NONE,
> +		};
  We should set for_kupdate here.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
