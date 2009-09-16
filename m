Return-Path: <linux-kernel-owner+w=401wt.eu-S1758675AbZIPMI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758675AbZIPMI1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 08:08:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756068AbZIPMIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 08:08:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40928 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756044AbZIPMIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 08:08:24 -0400
Date: Wed, 16 Sep 2009 14:08:27 +0200
From: Jan Kara <jack@suse.cz>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, hch@infradead.org, tytso@mit.edu,
       akpm@linux-foundation.org, jack@suse.cz, trond.myklebust@fys.uio.no
Subject: Re: [PATCH 03/11] writeback: merely wakeup flusher thread if work
	allocation fails for WB_SYNC_NONE
Message-ID: <20090916120827.GC26030@duck.suse.cz>
References: <1253038617-30204-1-git-send-email-jens.axboe@oracle.com> <1253038617-30204-4-git-send-email-jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253038617-30204-4-git-send-email-jens.axboe@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 15-09-09 20:16:49, Jens Axboe wrote:
> From: Christoph Hellwig <hch@infradead.org>
> 
> Since it's an opportunistic writeback and not a data integrity action,
> don't punt to blocking writeback. Just wakeup the thread and it will
> flush old data.
> 
> Signed-off-by: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
  Looks good. Acked-by: Jan Kara <jack@suse.cz>

									Honza
> ---
>  fs/fs-writeback.c |   46 ++++++++++++++--------------------------------
>  1 files changed, 14 insertions(+), 32 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 628235c..783ed44 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -75,13 +75,6 @@ static inline void bdi_work_init(struct bdi_work *work,
>  	work->state = WS_USED;
>  }
>  
> -static inline void bdi_work_init_on_stack(struct bdi_work *work,
> -					  struct writeback_control *wbc)
> -{
> -	bdi_work_init(work, wbc);
> -	work->state |= WS_ONSTACK;
> -}
> -
>  /**
>   * writeback_in_progress - determine whether there is writeback in progress
>   * @bdi: the device's backing_dev_info structure.
> @@ -207,34 +200,23 @@ static struct bdi_work *bdi_alloc_work(struct writeback_control *wbc)
>  
>  void bdi_start_writeback(struct writeback_control *wbc)
>  {
> -	const bool must_wait = wbc->sync_mode == WB_SYNC_ALL;
> -	struct bdi_work work_stack, *work = NULL;
> -
> -	if (!must_wait)
> -		work = bdi_alloc_work(wbc);
> +	/*
> +	 * WB_SYNC_NONE is opportunistic writeback. If this allocation fails,
> +	 * bdi_queue_work() will wake up the thread and flush old data. This
> +	 * should ensure some amount of progress in freeing memory.
> +	 */
> +	if (wbc->sync_mode != WB_SYNC_ALL) {
> +		struct bdi_work *w = bdi_alloc_work(wbc);
>  
> -	if (!work) {
> -		work = &work_stack;
> -		bdi_work_init_on_stack(work, wbc);
> -	}
> +		bdi_queue_work(wbc->bdi, w);
> +	} else {
> +		struct bdi_work work;
>  
> -	bdi_queue_work(wbc->bdi, work);
> +		bdi_work_init(&work, wbc);
> +		work.state |= WS_ONSTACK;
>  
> -	/*
> -	 * If the sync mode is WB_SYNC_ALL, block waiting for the work to
> -	 * complete. If not, we only need to wait for the work to be started,
> -	 * if we allocated it on-stack. We use the same mechanism, if the
> -	 * wait bit is set in the bdi_work struct, then threads will not
> -	 * clear pending until after they are done.
> -	 *
> -	 * Note that work == &work_stack if must_wait is true, so we don't
> -	 * need to do call_rcu() here ever, since the completion path will
> -	 * have done that for us.
> -	 */
> -	if (must_wait || work == &work_stack) {
> -		bdi_wait_on_work_clear(work);
> -		if (work != &work_stack)
> -			call_rcu(&work->rcu_head, bdi_work_free);
> +		bdi_queue_work(wbc->bdi, &work);
> +		bdi_wait_on_work_clear(&work);
>  	}
>  }
>  
> -- 
> 1.6.4.1.207.g68ea
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
