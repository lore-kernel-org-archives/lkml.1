Return-Path: <linux-kernel-owner+w=401wt.eu-S1753912AbXLEKOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912AbXLEKOo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 05:14:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751628AbXLEKOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 05:14:37 -0500
Received: from ns2.suse.de ([195.135.220.15]:37105 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344AbXLEKOg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 05:14:36 -0500
Date: Wed, 5 Dec 2007 11:14:34 +0100
From: Nick Piggin <npiggin@suse.de>
To: Aaron Carroll <aaronc@gelato.unsw.edu.au>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       Peter Chubb <peterc@gelato.unsw.edu.au>
Subject: Re: [PATCH] as-iosched: fix write batch start point
Message-ID: <20071205101434.GE1114@wotan.suse.de>
References: <4756784B.40607@gelato.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4756784B.40607@gelato.unsw.edu.au>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2007 at 09:07:07PM +1100, Aaron Carroll wrote:
> New write batches currently start from where the last one completed.
> We have no idea where the head is after switching batches, so this
> makes little sense.  Instead, start the next batch from the request
> with the earliest deadline in the hope that we avoid a deadline
> expiry later on.
> 
> Signed-off-by: Aaron Carroll <aaronc@gelato.unsw.edu.au>

I think this seems reasonable. What's deadline doing in this case?
They should probably be kept in synch where possible...

Acked-by: Nick Piggin <npiggin@suse.de>

> ---
>  block/as-iosched.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/block/as-iosched.c b/block/as-iosched.c
> index 4513fc5..555cd6b 100644
> --- a/block/as-iosched.c
> +++ b/block/as-iosched.c
> @@ -1097,7 +1097,8 @@ dispatch_writes:
>  		ad->batch_data_dir = REQ_ASYNC;
>  		ad->current_write_count = ad->write_batch_count;
>  		ad->write_batch_idled = 0;
> -		rq = ad->next_rq[ad->batch_data_dir];
> +		rq = rq_entry_fifo(ad->fifo_list[REQ_ASYNC].next);
> +		ad->last_check_fifo[REQ_ASYNC] = jiffies;
>  		goto dispatch_request;
>  	}
>  
> -- 
