Return-Path: <linux-kernel-owner+w=401wt.eu-S932348AbXBPNzI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932348AbXBPNzI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 08:55:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932349AbXBPNzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 08:55:07 -0500
Received: from mail.screens.ru ([213.234.233.54]:49866 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932348AbXBPNzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 08:55:06 -0500
Date: Fri, 16 Feb 2007 16:55:02 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] unify queue_delayed_work and queue_delayed_work_on fix
Message-ID: <20070216135502.GA83@tv-sign.ru>
References: <20070215051408.a7fb7d81.akpm@linux-foundation.org> <25269175172137025681@wsc.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25269175172137025681@wsc.cz>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16, Jiri Slaby wrote:
> 
> unify queue_delayed_work and queue_delayed_work_on fix
> 
> Since cwq->wq is unset for other than singlethread_cpu when singlethread
> workqueue was created, an oops occurs during bootup.

And I thought I tested this...

>                                                       Fix it by setting
> correct private value for workqueue.

Thanks!!!

> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> 
> ---
> commit 7bc281be5811f9b1dd01c25eaf492f4765737fd0
> tree 7795008066bb89e7489384cde95e63260602d5af
> parent 61c2024a2dd044e32747542cfbf4b22251df3bc2
> author Jiri Slaby <jirislaby@gmail.com> Fri, 16 Feb 2007 00:49:15 +0100
> committer Jiri Slaby <jirislaby@gmail.com> Fri, 16 Feb 2007 00:49:15 +0100
> 
>  kernel/workqueue.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index f2089bf..af5e597 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -210,7 +210,8 @@ int queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
>  
>  		/* This stores cwq for the moment, for the timer_fn */
>  		set_wq_data(work,
> -			per_cpu_ptr(wq->cpu_wq, raw_smp_processor_id()));
> +			per_cpu_ptr(wq->cpu_wq, wq->singlethread ?
> +				singlethread_cpu : raw_smp_processor_id()));
>  		timer->expires = jiffies + delay;
>  		timer->data = (unsigned long)dwork;
>  		timer->function = delayed_work_timer_fn;

