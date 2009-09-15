Return-Path: <linux-kernel-owner+w=401wt.eu-S1758329AbZIOTay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758329AbZIOTay (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 15:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753782AbZIOTax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 15:30:53 -0400
Received: from brick.kernel.dk ([93.163.65.50]:51398 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752950AbZIOTax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 15:30:53 -0400
Date: Tue, 15 Sep 2009 21:30:56 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: npiggin@suse.de
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 4/5] fs: fix possible bdi writeback refcounting problem
Message-ID: <20090915193055.GR23126@kernel.dk>
References: <20090915191903.290006007@suse.de> <20090915192243.099602430@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090915192243.099602430@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16 2009, npiggin@suse.de wrote:
> wb_clear_pending AFAIKS should not be called after the item has been
> put on the list, except by the worker threads. It could lead to the
> situation where the refcount is decremented below 0 and cause lots of
> problems.

Good point!

> Presumably the !wb_has_dirty_io case is not a common one, so it can
> be discovered when the thread wakes up to check?

It's checked earlier as well, so I see no problem in killing the check
there.

> 
> Also add a comment in bdi_work_clear.
> 
> Signed-off-by: Nick Piggin <npiggin@suse.de>
> ---
>  fs/fs-writeback.c |   10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> Index: linux-2.6/fs/fs-writeback.c
> ===================================================================
> --- linux-2.6.orig/fs/fs-writeback.c
> +++ linux-2.6/fs/fs-writeback.c
> @@ -98,6 +98,11 @@ static void bdi_work_clear(struct bdi_wo
>  {
>  	clear_bit(WS_USED_B, &work->state);
>  	smp_mb__after_clear_bit();
> +	/*
> +	 * work can have disappeared at this point. bit waitq functions
> +	 * should be able to tolerate this, provided bdi_sched_wait does
> +	 * not dereference it's pointer argument.
> +	 */
>  	wake_up_bit(&work->state, WS_USED_B);
>  }
>  
> @@ -172,10 +177,7 @@ static void bdi_queue_work(struct backin
>  		 * thread always. As a safety precaution, it'll flush out
>  		 * everything
>  		 */
> -		if (!wb_has_dirty_io(wb)) {
> -			if (work)
> -				wb_clear_pending(wb, work);
> -		} else if (wb->task)
> +		if (wb->task)
>  			wake_up_process(wb->task);
>  	}
>  }
> 
> 

-- 
Jens Axboe

