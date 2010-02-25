Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473Ab0BYJx5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 04:53:57 -0500
Received: from mail-yx0-f182.google.com ([209.85.210.182]:52236 "EHLO
	mail-yx0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754083Ab0BYJxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 04:53:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uueZBiDKna9+tslXzlaGmbbD3IrhXy444baFOWb/XXW3Pv+GvZwOzY8Vs/D0Dig/Cc
         ukIdhwMk3E+voz/n0HLhmPXpwdmvIl4aWht2qWk/AAjpsjrWkWZblQB8lvbd2lmgOa8Y
         yKgFvrc8MV9+fsQTK9q5QH54LZhY2PVDMxYi0=
Date: Thu, 25 Feb 2010 01:53:49 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Samu Onkalo <samu.p.onkalo@nokia.com>, Tejun Heo <tj@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] workqueues: change cancel_work_sync() to clear
 work->data
Message-ID: <20100225095349.GB10823@core.coreip.homeip.net>
References: <20100224202031.GA26987@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100224202031.GA26987@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 24, 2010 at 09:20:31PM +0100, Oleg Nesterov wrote:
> In short: change cancel_work_sync(work) to mark this work as "never
> queued" upon return.
> 
> When cancel_work_sync(work) succeeds, we know that this work can't be
> queued or running, and since we own WORK_STRUCT_PENDING nobody can change
> the bits in work->data under us. This means we can also clear the "cwq"
> part along with _PENDING bit lockless before return, unless the work is
> queued nobody can assume get_wq_data() is stable even under cwq->lock.
> 
> This change can speedup the subsequent cancel/flush requests, and as
> Dmitry pointed out this simplifies the usage of work_struct's which
> can be queued on different workqueues. Consider this pseudo code from
> the input subsystem:
> 
> 	struct workqueue_struct *WQ;
> 	struct work_struct *WORK;
> 
> 	for (;;) {
> 		WQ = create_workqueue();
> 		...
> 		if (condition())
> 			queue_work(WQ, WORK);
> 		...
> 		cancel_work_sync(WORK);
> 		destroy_workqueue(WQ);
> 	}
> 
> If condition() returns T and then F, cancel_work_sync() will crash the
> kernel because WORK->data still points to the already destroyed workqueue.
> With this patch the code like above becomes correct.
> 

Very nice, thank you for making the change.

> Suggested-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
> 
>  kernel/workqueue.c |   12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> --- wq/kernel/workqueue.c~1_CANCEL_CLEAR_WQ	2010-02-24 20:43:32.000000000 +0100
> +++ wq/kernel/workqueue.c	2010-02-24 20:55:53.000000000 +0100
> @@ -229,6 +229,16 @@ static inline void set_wq_data(struct wo
>  	atomic_long_set(&work->data, new);
>  }
>  
> +/*
> + * Clear WORK_STRUCT_PENDING and the workqueue on which it was queued.
> + */
> +static inline void clear_wq_data(struct work_struct *work)
> +{
> +	unsigned long flags = *work_data_bits(work) &
> +				(1UL << WORK_STRUCT_STATIC);
> +	atomic_long_set(&work->data, flags);
> +}
> +
>  static inline
>  struct cpu_workqueue_struct *get_wq_data(struct work_struct *work)
>  {
> @@ -671,7 +681,7 @@ static int __cancel_work_timer(struct wo
>  		wait_on_work(work);
>  	} while (unlikely(ret < 0));
>  
> -	work_clear_pending(work);
> +	clear_wq_data(work);
>  	return ret;
>  }
>  
> 

-- 
Dmitry
