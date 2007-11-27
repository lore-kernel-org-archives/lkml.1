Return-Path: <linux-kernel-owner+w=401wt.eu-S1757406AbXK0Fan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406AbXK0Fan (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 00:30:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751216AbXK0Faf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 00:30:35 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60016 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751034AbXK0Fae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 00:30:34 -0500
Date: Mon, 26 Nov 2007 21:29:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>, LKML <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] mmc: Add missing sg_init_table() call
Message-Id: <20071126212955.07f65b0d.akpm@linux-foundation.org>
In-Reply-To: <1195759971-19825-1-git-send-email-hskinnemoen@atmel.com>
References: <1195759971-19825-1-git-send-email-hskinnemoen@atmel.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Nov 2007 20:32:51 +0100 Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:

> mmc_init_queue only initializes the scatterlists with sg_init_table()
> when using a bounce buffer. This leads to a BUG() when CONFIG_DEBUG_SG
> is set.
> 

I assume that 2.6.23 is not afflicted in this way?

> ---
>  drivers/mmc/card/queue.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
> index 1b9c9b6..30cd13b 100644
> --- a/drivers/mmc/card/queue.c
> +++ b/drivers/mmc/card/queue.c
> @@ -180,12 +180,13 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card, spinlock_t *lock
>  		blk_queue_max_hw_segments(mq->queue, host->max_hw_segs);
>  		blk_queue_max_segment_size(mq->queue, host->max_seg_size);
>  
> -		mq->sg = kzalloc(sizeof(struct scatterlist) *
> +		mq->sg = kmalloc(sizeof(struct scatterlist) *
>  			host->max_phys_segs, GFP_KERNEL);
>  		if (!mq->sg) {
>  			ret = -ENOMEM;
>  			goto cleanup_queue;
>  		}
> +		sg_init_table(mq->sg, host->max_phys_segs);
>  	}
>  
>  	init_MUTEX(&mq->thread_sem);

Pierre, I can queue this up but if you merge it into your tree I shall drop
it and shall lose track of it.  So it's then all down to you to remember to
get the fix into 2.6.24.

(Except this particular bug looks like a post-2.6.23 regression, so I can cc
the Rafael which never forgets, so it will then get tracked all the way into
Linus's tree)

