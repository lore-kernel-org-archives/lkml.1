Return-Path: <linux-kernel-owner+w=401wt.eu-S1754949AbZIOT33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949AbZIOT33 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 15:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752851AbZIOT32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 15:29:28 -0400
Received: from brick.kernel.dk ([93.163.65.50]:51386 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752019AbZIOT31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 15:29:27 -0400
Date: Tue, 15 Sep 2009 21:29:30 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: npiggin@suse.de
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 5/5] fs: fix bdi writeback use after free 2
Message-ID: <20090915192930.GQ23126@kernel.dk>
References: <20090915191903.290006007@suse.de> <20090915192243.247202587@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090915192243.247202587@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16 2009, npiggin@suse.de wrote:
> work can be gone after wb_clear_pending, so load the sb from it first.

This one is already moot, I fixed that in an earlier patch.

> 
> Signed-off-by: Nick Piggin <npiggin@suse.de>
> ---
>  fs/fs-writeback.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/fs/fs-writeback.c
> ===================================================================
> --- linux-2.6.orig/fs/fs-writeback.c
> +++ linux-2.6/fs/fs-writeback.c
> @@ -783,6 +783,7 @@ long wb_do_writeback(struct bdi_writebac
>  
>  	while ((work = get_next_work_item(bdi, wb)) != NULL) {
>  		enum writeback_sync_modes sync_mode;
> +		struct super_block *sb;
>  
>  		nr_pages = work->nr_pages;
>  
> @@ -794,6 +795,8 @@ long wb_do_writeback(struct bdi_writebac
>  		else
>  			sync_mode = work->sync_mode;
>  
> +		sb = work->sb;
> +
>  		/*
>  		 * If this isn't a data integrity operation, just notify
>  		 * that we have seen this work and we are now starting it.
> @@ -801,7 +804,7 @@ long wb_do_writeback(struct bdi_writebac
>  		if (sync_mode == WB_SYNC_NONE)
>  			wb_clear_pending(wb, work);
>  
> -		wrote += wb_writeback(wb, nr_pages, work->sb, sync_mode, 0);
> +		wrote += wb_writeback(wb, nr_pages, sb, sync_mode, 0);
>  
>  		/*
>  		 * This is a data integrity writeback, so only do the
> 
> 

-- 
Jens Axboe

