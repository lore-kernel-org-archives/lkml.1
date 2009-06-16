Return-Path: <linux-kernel-owner+w=401wt.eu-S1760037AbZFPQsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760037AbZFPQsS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 12:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755761AbZFPQsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 12:48:10 -0400
Received: from tango.0pointer.de ([85.214.72.216]:50183 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754141AbZFPQsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 12:48:09 -0400
Date: Tue, 16 Jun 2009 18:47:42 +0200
From: Lennart Poettering <mzxreary@0pointer.de>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scheduler: introduce SCHED_RESET_ON_FORK scheduling
	policy flag, fourth try
Message-ID: <20090616164742.GA21385@tango.0pointer.de>
References: <20090615152714.GA29092@tango.0pointer.de> <1245143108.6038.10.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245143108.6038.10.camel@marge.simson.net>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16.06.09 11:05, Mike Galbraith (efault@gmx.de) wrote:

> I think it's cleaner to keep reset_on_fork functionality separate.
> Thoughts on the below?

Looks good to me!

Lennart

> Make SCHED_RESET_ON_FORK to DTRT for reniced tasks, and make the sched_fork()
> SCHED_RESET_ON_FORK bits a self-contained unlikely code block.
> 
> Signed-off-by: Mike Galbraith <efault@gmx.de>
> 
>  kernel/sched.c |   39 +++++++++++++++++++++++----------------
>  1 files changed, 23 insertions(+), 16 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 80636ed..cb6bbc6 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -2613,28 +2613,35 @@ void sched_fork(struct task_struct *p, int clone_flags)
>  	set_task_cpu(p, cpu);
>  
>  	/*
> -	 * Revert to default priority/policy on fork if requested. Make sure we
> -	 * do not leak PI boosting priority to the child.
> +	 * Make sure we do not leak PI boosting priority to the child.
>  	 */
> -	if (current->sched_reset_on_fork &&
> -			(p->policy == SCHED_FIFO || p->policy == SCHED_RR))
> -		p->policy = SCHED_NORMAL;
> +	p->prio = current->normal_prio;
>  
> -	if (current->sched_reset_on_fork &&
> -			(current->normal_prio < DEFAULT_PRIO))
> -		p->prio = DEFAULT_PRIO;
> -	else
> -		p->prio = current->normal_prio;
> +	/*
> +	 * Revert to default priority/policy on fork if requested.
> +	 */
> +	if (unlikely(p->sched_reset_on_fork)) {
> +		if (p->policy == SCHED_FIFO || p->policy == SCHED_RR)
> +			p->policy = SCHED_NORMAL;
> +
> +		if (p->normal_prio < DEFAULT_PRIO)
> +			p->prio = DEFAULT_PRIO;
> +
> +		if (PRIO_TO_NICE(p->static_prio) < 0) {
> +			p->static_prio = NICE_TO_PRIO(0);
> +			set_load_weight(p);
> +		}
> +
> +		/*
> +		 * We don't need the reset flag anymore after the fork. It has
> +		 * fulfilled its duty:
> +		 */
> +		p->sched_reset_on_fork = 0;
> +	}
>  
>  	if (!rt_prio(p->prio))
>  		p->sched_class = &fair_sched_class;
>  
> -	/*
> -	 * We don't need the reset flag anymore after the fork. It has
> -	 * fulfilled its duty:
> -	 */
> -	p->sched_reset_on_fork = 0;
> -
>  #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
>  	if (likely(sched_info_on()))
>  		memset(&p->sched_info, 0, sizeof(p->sched_info));
> 


Lennart

-- 
Lennart Poettering                        Red Hat, Inc.
lennart [at] poettering [dot] net
http://0pointer.net/lennart/           GnuPG 0x1A015CC4
