Return-Path: <linux-kernel-owner+w=401wt.eu-S933032AbZKXOdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933032AbZKXOdk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 09:33:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932981AbZKXOdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 09:33:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16829 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932973AbZKXOdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 09:33:39 -0500
Date: Tue, 24 Nov 2009 09:33:40 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 3/4] cfq-iosched: idling on deep seeky sync queues
Message-ID: <20091124143340.GA9595@redhat.com>
References: <200911241449.20715.czoccolo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911241449.20715.czoccolo@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 02:49:20PM +0100, Corrado Zoccolo wrote:
> Seeky sync queues with large depth can gain unfairly big share of disk
> time, at the expense of other seeky queues. This patch ensures that
> idling will be enabled for queues with I/O depth at least 4, and small
> think time. The decision to enable idling is sticky, until an idle
> window times out without seeing a new request.
> 
> The reasoning behind the decision is that, if an application is using
> large I/O depth, it is already optimized to make full utilization of
> the hardware, and therefore we reserve a slice of exclusive use for it.
> 
> Reported-by: Vivek Goyal <vgoyal@redhat.com>
> Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>
> ---
>  block/cfq-iosched.c |   13 ++++++++++++-
>  1 files changed, 12 insertions(+), 1 deletions(-)
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index 2a304f4..373e80f 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -260,6 +260,7 @@ enum cfqq_state_flags {
>  	CFQ_CFQQ_FLAG_slice_new,	/* no requests dispatched in slice */
>  	CFQ_CFQQ_FLAG_sync,		/* synchronous queue */
>  	CFQ_CFQQ_FLAG_coop,		/* cfqq is shared */
> +	CFQ_CFQQ_FLAG_deep,		/* sync cfqq experienced large depth */
>  };
>  
>  #define CFQ_CFQQ_FNS(name)						\
> @@ -286,6 +287,7 @@ CFQ_CFQQ_FNS(prio_changed);
>  CFQ_CFQQ_FNS(slice_new);
>  CFQ_CFQQ_FNS(sync);
>  CFQ_CFQQ_FNS(coop);
> +CFQ_CFQQ_FNS(deep);
>  #undef CFQ_CFQQ_FNS
>  
>  #define cfq_log_cfqq(cfqd, cfqq, fmt, args...)	\
> @@ -2359,8 +2361,12 @@ cfq_update_idle_window(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>  
>  	enable_idle = old_idle = cfq_cfqq_idle_window(cfqq);
>  
> +	if (cfqq->queued[0] + cfqq->queued[1] >= 4)
> +		cfq_mark_cfqq_deep(cfqq);
> +
>  	if (!atomic_read(&cic->ioc->nr_tasks) || !cfqd->cfq_slice_idle ||
> -	    (sample_valid(cfqq->seek_samples) && CFQQ_SEEKY(cfqq)))
> +	    (!cfq_cfqq_deep(cfqq) && sample_valid(cfqq->seek_samples)
> +	     && CFQQ_SEEKY(cfqq)))
>  		enable_idle = 0;
>  	else if (sample_valid(cic->ttime_samples)) {
>  		if (cic->ttime_mean > cfqd->cfq_slice_idle)
> @@ -2858,6 +2864,11 @@ static void cfq_idle_slice_timer(unsigned long data)
>  		 */
>  		if (!RB_EMPTY_ROOT(&cfqq->sort_list))
>  			goto out_kick;
> +
> +		/*
> +		 * Queue depth flag is reset only when the idle didn't succeed
> +		 */
> +		cfq_clear_cfqq_deep(cfqq);
>  	}

Hi Corrado,

Thinking more about it. This clearing of flag when idle expires might
create issues with queues which sent down requests with a burst initially
forcing to set "deep" flag and then fall back to low depth. In that case,
enable_idle will continue to be 1 and we will be driving queue depth as 1.

This is a theoritical explanation looking at the patch. I don't know if
in real life we have workloads who do this frequently. At least for my
testing, this patch did make sure we don't switch between workload type
of queue very frequently.

May be keeping a track of average queue depth of a seeky process might
help here like thinktime. If average queue depth is less over a period of
time, we move the queue to sync-noidle group to achieve better throughput
overall and if average queue depth is high, make is sync-idle.

Currently we seem to be taking queue depth into account only for enabling
the flag. We don't want too frequent switching of "deep" flag, so some
kind of slow moving average might help.

Thanks
Vivek
