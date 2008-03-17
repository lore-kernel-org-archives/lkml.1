Return-Path: <linux-kernel-owner+w=401wt.eu-S1756204AbYCQT02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204AbYCQT02 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 15:26:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754808AbYCQT0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 15:26:21 -0400
Received: from brick.kernel.dk ([87.55.233.238]:9819 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752292AbYCQT0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 15:26:20 -0400
Date: Mon, 17 Mar 2008 20:26:15 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: linux-kernel@vger.kernel.org, npiggin@suse.de, dgc@sgi.com
Subject: Re: [Patch (block.git) 2/2] Ensure single IPI generation for SMP call  single
Message-ID: <20080317192615.GI17940@kernel.dk>
References: <47DE9E3F.7010600@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47DE9E3F.7010600@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17 2008, Alan D. Brunelle wrote:
> diff --git a/kernel/smp.c b/kernel/smp.c
> index 7232e1c..f7ec401 100644
> --- a/kernel/smp.c
> +++ b/kernel/smp.c
> @@ -23,28 +23,34 @@ void __cpuinit generic_init_call_single_data(void)
>  
>  void generic_smp_call_function_single_interrupt(void)
>  {
> -	struct call_single_queue *q;
>  	unsigned long flags;
>  	LIST_HEAD(list);
> +	struct call_single_queue *q = &__get_cpu_var(call_single_queue);
>  
> -	q = &__get_cpu_var(call_single_queue);
>  	spin_lock_irqsave(&q->lock, flags);
> -	list_replace_init(&q->list, &list);
> -	spin_unlock_irqrestore(&q->lock, flags);
> +	while (!list_empty(&q->list)) {
> +		list_replace_init(&q->list, &list);
> +		spin_unlock_irqrestore(&q->lock, flags);
>  
> -	while (!list_empty(&list)) {
> -		struct call_single_data *data;
> +		do {
> +			struct call_single_data *data;
>  
> -		data = list_entry(list.next, struct call_single_data, list);
> -		list_del(&data->list);
> +			data = list_entry(list.next, struct call_single_data,
> +						list);
> +			list_del(&data->list);
>  
> -		data->func(data->info);
> -		if (data->flags & CSD_FLAG_WAIT) {
> -			smp_wmb();
> -			data->flags = 0;
> -		} else if (data->flags & CSD_FLAG_ALLOC)
> -			kfree(data);
> +			data->func(data->info);
> +			if (data->flags & CSD_FLAG_WAIT) {
> +				smp_wmb();
> +				data->flags = 0;
> +			} else if (data->flags & CSD_FLAG_ALLOC)
> +				kfree(data);
> +		} while (!list_empty(&list));
> +
> +		spin_lock_irqsave(&q->lock, flags);
>  	}
> +	q->activated = 0;
> +	spin_unlock_irqrestore(&q->lock, flags);
>  }

I agree with doing it this way, re-checking and doing another run (or
more). However I think we can improve it a bit so we don't always have
to grab the dst lock at least twice - it should be safe enough to
include the lock only inside the first loop, doing an smp_mb() before
the list_empty() check and again at the bottom before looping around and
doing the list_empty() check again.

I've rolled a new patch series here:

http://git.kernel.dk/?p=linux-2.6-block.git;a=shortlog;h=io-cpu-affinity

(or just pull the io-cpu-affinity branch), it also includes a bunch of
other cleanups like porting the faster smp_call_function() to ia64 and
powerpc as well. So the kernel/smp.c generic helpers have grown a bit,
while the arch bits are smaller.

I'm curious if it now boots on ia64, since I killed the hack to manually
call the __init manually there. If you could check, I would appreciate
it ;-)

I've built all 4 supported archs and they compile and link fine, but
nothing has been booted yet.

-- 
Jens Axboe

