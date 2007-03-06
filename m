Return-Path: <linux-kernel-owner+w=401wt.eu-S934083AbXCFLPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934083AbXCFLPn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 06:15:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934084AbXCFLPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 06:15:43 -0500
Received: from brick.kernel.dk ([62.242.22.158]:5700 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934083AbXCFLPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 06:15:42 -0500
Date: Tue, 6 Mar 2007 12:14:44 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: =?iso-8859-1?Q?J=2EA=2E_Magall=F3n?= <jamagallon@ono.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc2-mm2
Message-ID: <20070306111444.GE20362@kernel.dk>
References: <20070306004408.d3f6434d.akpm@linux-foundation.org> <20070306100623.770b9dc9@werewolf-wl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070306100623.770b9dc9@werewolf-wl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06 2007, J.A. Magallón wrote:
> On Tue, 6 Mar 2007 00:44:08 -0800, Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > 
> > Temporarily at
> > 
> >   http://userweb.kernel.org/~akpm/2.6.21-rc2-mm2/
> > 
> 
> Does this include a fix for the NFS problem ?
> 
> BTW, I have in my kernel a patch like this below, isn't it needed ?
> Original thread:
> 
> http://marc.theaimsgroup.com/?l=linux-kernel&m=117189051227292&w=2
> 
> --- a/block/ll_rw_blk.c
> +++ b/block/ll_rw_blk.c
> @@ -2919,14 +2919,14 @@ static int __make_request(request_queue_
>  	 */
>  	blk_queue_bounce(q, &bio);
>  
> +	spin_lock_irq(q->queue_lock);
>  	/*
>  	 * Check if we can merge with the plugged list before grabbing
>  	 * any locks.
>  	 */
>  	if (!check_plug_merge(q, ioc, bio))
> -		goto out;
> +		goto out_unlock;
>  
> -	spin_lock_irq(q->queue_lock);
>  	el_ret = elv_merge(q, &req, bio);
>  	if (el_ret == ELEVATOR_BACK_MERGE) {
>  		if (bio_attempt_back_merge(q, req, bio)) {
> @@ -2984,7 +2984,6 @@ out_unlock:
>  		list_add_tail(&req->queuelist, &ioc->plugged_list);
>  	}
>  
> -out:
>  	return 0;
>  
>  end_io_eopnotsupp:

No it's not, plus andrew didn't include git-block in this release so
you'd have a hard time even applying it. The above patch would also
eliminate 50% of the win of per-process plugging, if you go and grab the
queue lock anyway.

-- 
Jens Axboe

