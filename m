Return-Path: <linux-kernel-owner+w=401wt.eu-S932653AbZIDGx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932653AbZIDGx6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 02:53:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756638AbZIDGx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 02:53:56 -0400
Received: from brick.kernel.dk ([93.163.65.50]:54588 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756606AbZIDGxz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 02:53:55 -0400
Date: Fri, 4 Sep 2009 08:53:57 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, tytso@mit.edu,
       akpm@linux-foundation.org, jack@suse.cz
Subject: Re: [PATCH 2/8] writeback: move dirty inodes from super_block to
	backing_dev_info
Message-ID: <20090904065357.GP18599@kernel.dk>
References: <1251880967-1136-1-git-send-email-jens.axboe@oracle.com> <1251880967-1136-3-git-send-email-jens.axboe@oracle.com> <20090904025609.GC3658@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090904025609.GC3658@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 03 2009, Christoph Hellwig wrote:
> Clean bdi_start_writeback up a bit:
> 
> 
> Index: linux-2.6/fs/fs-writeback.c
> ===================================================================
> --- linux-2.6.orig/fs/fs-writeback.c	2009-09-03 23:50:12.880832607 -0300
> +++ linux-2.6/fs/fs-writeback.c	2009-09-03 23:54:42.372832985 -0300
> @@ -70,13 +70,6 @@ static inline void bdi_work_init(struct 
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
> @@ -207,35 +200,26 @@ static struct bdi_work *bdi_alloc_work(s
>  
>  void bdi_start_writeback(struct writeback_control *wbc)
>  {
> -	const bool must_wait = wbc->sync_mode == WB_SYNC_ALL;
> -	struct bdi_work work_stack, *work = NULL;
> -
> -	if (!must_wait)
> -		work = bdi_alloc_work(wbc);
> +	struct bdi_work work;
>  
> -	if (!work) {
> -		work = &work_stack;
> -		bdi_work_init_on_stack(work, wbc);
> +	if (wbc->sync_mode != WB_SYNC_ALL) {
> +		struct bdi_work *w = bdi_alloc_work(wbc);
> +		if (w) {
> +			bdi_queue_work(wbc->bdi, w);
> +			return;
> +		}
>  	}
>  
> -	bdi_queue_work(wbc->bdi, work);
> +	bdi_work_init(&work, wbc);
> +	work.state |= WS_ONSTACK;
> +	bdi_queue_work(wbc->bdi, &work);
>  
>  	/*
>  	 * If the sync mode is WB_SYNC_ALL, block waiting for the work to
> -	 * complete. If not, we only need to wait for the work to be started,
> -	 * if we allocated it on-stack. We use the same mechanism, if the
> -	 * wait bit is set in the bdi_work struct, then threads will not
> -	 * clear pending until after they are done.
> -	 *
> -	 * Note that work == &work_stack if must_wait is true, so we don't
> -	 * need to do call_rcu() here ever, since the completion path will
> -	 * have done that for us.
> +	 * complete.
>  	 */
> -	if (must_wait || work == &work_stack) {
> -		bdi_wait_on_work_clear(work);
> -		if (work != &work_stack)
> -			call_rcu(&work->rcu_head, bdi_work_free);
> -	}
> +	if (wbc->sync_mode == WB_SYNC_ALL)
> +		bdi_wait_on_work_clear(&work);
>  }

That doesn't work, you have to wait for on-stack work. So either we just
punt and not do anything for WB_SYNC_NONE if the allocation fails, or we
punt to stack and do the wait. Since it's a cleaning action and
allocation fails, falling back to the stack and waiting seems like the
most appropriate choice.

-- 
Jens Axboe

