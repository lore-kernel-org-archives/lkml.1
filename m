Return-Path: <linux-kernel-owner+w=401wt.eu-S1758364AbZIOTcE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758364AbZIOTcE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 15:32:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758273AbZIOTcC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 15:32:02 -0400
Received: from brick.kernel.dk ([93.163.65.50]:59106 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753035AbZIOTcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 15:32:01 -0400
Date: Tue, 15 Sep 2009 21:32:04 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: npiggin@suse.de
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/5] fs: fix bdi writeback use after free 1
Message-ID: <20090915193204.GU23126@kernel.dk>
References: <20090915191903.290006007@suse.de> <20090915192242.897829798@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090915192242.897829798@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16 2009, npiggin@suse.de wrote:
> By the time bdi_work_on_stack gets evaluated again in bdi_work_free, it
> cna already have been deallocated and used for something else in the
> !on stack case, giving a false positive in this test and causing corruption.

You are right, that is also buggy... Applied.

> 
> Signed-off-by: Nick Piggin <npiggin@suse.de>
> ---
>  fs/fs-writeback.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/fs/fs-writeback.c
> ===================================================================
> --- linux-2.6.orig/fs/fs-writeback.c
> +++ linux-2.6/fs/fs-writeback.c
> @@ -114,6 +114,7 @@ static void bdi_work_free(struct rcu_hea
>  static void wb_work_complete(struct bdi_work *work)
>  {
>  	const enum writeback_sync_modes sync_mode = work->sync_mode;
> +	int onstack = bdi_work_on_stack(work);
>  
>  	/*
>  	 * For allocated work, we can clear the done/seen bit right here.
> @@ -121,9 +122,9 @@ static void wb_work_complete(struct bdi_
>  	 * to after the RCU grace period, since the stack could be invalidated
>  	 * as soon as bdi_work_clear() has done the wakeup.
>  	 */
> -	if (!bdi_work_on_stack(work))
> +	if (!onstack)
>  		bdi_work_clear(work);
> -	if (sync_mode == WB_SYNC_NONE || bdi_work_on_stack(work))
> +	if (sync_mode == WB_SYNC_NONE || onstack)
>  		call_rcu(&work->rcu_head, bdi_work_free);
>  }
>  
> 
> 

-- 
Jens Axboe

