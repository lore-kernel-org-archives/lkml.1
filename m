Return-Path: <linux-kernel-owner+w=401wt.eu-S932190AbZJCNuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190AbZJCNuo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 09:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932171AbZJCNun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 09:50:43 -0400
Received: from brick.kernel.dk ([93.163.65.50]:42225 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932159AbZJCNum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 09:50:42 -0400
Date: Sat, 3 Oct 2009 15:50:46 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH] cfq: enable idle for seeky processes on rotational NCQ
	devices
Message-ID: <20091003135046.GD31616@kernel.dk>
References: <200910031057.41695.czoccolo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910031057.41695.czoccolo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 03 2009, Corrado Zoccolo wrote:
> Idle window is currently disabled for seeky processes on all NCQ devices.
> This is causing large latencies when seeky processes are competing with async writes,
> for rotational NCQ devices.
> 
> This patch, based on Vivek Goyal's original idea (http://lkml.org/lkml/2009/7/12/110),
> enables idle window for seeky processes on rotational NCQ devices.
> As for non-NCQ devices, a smaller idle window (2ms) is used
> for seeky processes compared to normal I/O (8ms).
> 
> RAIDs should be marked as non-rotational as well (and probably a better flag
> name should be devised), since they can carry multiple operations in parallel.
> 
> Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>
> ---
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index 1ca813b..7116f11 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -1951,10 +1951,12 @@ cfq_update_idle_window(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>  	enable_idle = old_idle = cfq_cfqq_idle_window(cfqq);
>  
>  	if (!atomic_read(&cic->ioc->nr_tasks) || !cfqd->cfq_slice_idle ||
> -	    (cfqd->hw_tag && CIC_SEEKY(cic)))
> +	    (blk_queue_nonrot(cfqd->queue) && cfqd->hw_tag && CIC_SEEKY(cic)))
>  		enable_idle = 0;
>  	else if (sample_valid(cic->ttime_samples)) {
> -		if (cic->ttime_mean > cfqd->cfq_slice_idle)
> +		unsigned idle_time = CIC_SEEKY(cic) ? CFQ_MIN_TT
> +			: cfqd->cfq_slice_idle;
> +		if (cic->ttime_mean > idle_time)
>  			enable_idle = 0;
>  		else
>  			enable_idle = 1;

Please don't use the ?: constructs, they are not very readable
(especially not with multi-lines).

Can you resend this on top of the current for-linus branch, it has a few
cfq patches that cause this not to apply anyway.

-- 
Jens Axboe

