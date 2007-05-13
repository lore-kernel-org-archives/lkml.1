Return-Path: <linux-kernel-owner+w=401wt.eu-S1760219AbXEMUIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760219AbXEMUIw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 16:08:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757069AbXEMUIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 16:08:45 -0400
Received: from mail.screens.ru ([213.234.233.54]:59854 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756071AbXEMUIo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 16:08:44 -0400
Date: Mon, 14 May 2007 00:08:45 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Alex Dubov <oakad@yahoo.com>, Pierre Ossman <drzeus@drzeus.cx>
Subject: Re: 2.6.22-rc1: Broken suspend on SMP with tifm
Message-ID: <20070513200845.GA3078@tv-sign.ru>
References: <200705132132.08546.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705132132.08546.rjw@sisk.pl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13, Rafael J. Wysocki wrote:
> 
> The suspend/hibernation is broken on SMP due to:
> 
> commit 3540af8ffddcdbc7573451ac0b5cd57a2eaf8af5
> tifm: replace per-adapter kthread with freezeable workqueue
> 
> Well, it looks like freezable worqueues still deadlock with CPU hotplug
> when worker threads are frozen.

Ugh. I thought we deprecated create_freezeable_workqueue(), exactly
because suspend was changed to call _cpu_down() after freeze().

It is not that "looks like freezable worqueues still deadlock", it
is "of course, freezable worqueues deadlocks" on CPU_DEAD.

The ->freezeable is still here just because of incoming "cpu-hotplug
using freezer" rework.

No?

> --- linux-2.6.22-rc1.orig/kernel/workqueue.c
> +++ linux-2.6.22-rc1/kernel/workqueue.c
> @@ -799,9 +799,7 @@ static int __devinit workqueue_cpu_callb
>  	struct cpu_workqueue_struct *cwq;
>  	struct workqueue_struct *wq;
>  
> -	action &= ~CPU_TASKS_FROZEN;
> -
> -	switch (action) {
> +	switch (action & ~CPU_TASKS_FROZEN) {

Confused. How can we see, say CPU_UP_PREPARE_FROZEN, if we cleared
CPU_TASKS_FROZEN bit?

>  	case CPU_LOCK_ACQUIRE:
>  		mutex_lock(&workqueue_mutex);
>  		return NOTIFY_OK;
> @@ -819,20 +817,29 @@ static int __devinit workqueue_cpu_callb
>  
>  		switch (action) {
>  		case CPU_UP_PREPARE:
> +		case CPU_UP_PREPARE_FROZEN:
>  			if (!create_workqueue_thread(cwq, cpu))
>  				break;
>  			printk(KERN_ERR "workqueue for %i failed\n", cpu);
>  			return NOTIFY_BAD;
>  
>  		case CPU_ONLINE:
> +		case CPU_ONLINE_FROZEN:
>  			start_workqueue_thread(cwq, cpu);
>  			break;
>  
>  		case CPU_UP_CANCELED:
> +		case CPU_UP_CANCELED_FROZEN:
>  			start_workqueue_thread(cwq, -1);
>  		case CPU_DEAD:
>  			cleanup_workqueue_thread(cwq, cpu);
>  			break;
> +
> +		case CPU_DEAD_FROZEN:
> +			if (wq->freezeable)
> +				thaw_process(cwq->thread);
> +			cleanup_workqueue_thread(cwq, cpu);
> +			break;
>  		}
>  	}

Minor, but can't we do

		...
		case CPU_UP_CANCELED:
		case CPU_UP_CANCELED_FROZEN:
			start_workqueue_thread(cwq, -1);
		case CPU_DEAD_FROZEN:
			if (wq->freezeable)
				// we can't see PF_FROZEN if it was CPU_UP_CANCELED
				thaw_process(cwq->thread);
		case CPU_DEAD:
			cleanup_workqueue_thread(cwq, cpu);
			break;

?

Oleg.

