Return-Path: <linux-kernel-owner+w=401wt.eu-S1756641AbZE2J2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641AbZE2J2k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 05:28:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754276AbZE2J2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 05:28:33 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38198 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081AbZE2J2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 05:28:32 -0400
Subject: Re: [PATCH] scheduler: introduce SCHED_RESET_ON_FORK scheduling
 policy flag, Second try
From: Peter Zijlstra <peterz@infradead.org>
To: Lennart Poettering <mzxreary@0pointer.de>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20090529083840.GA15516@omega>
References: <20090529083840.GA15516@omega>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 29 May 2009 11:28:35 +0200
Message-Id: <1243589315.23657.210.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-29 at 10:38 +0200, Lennart Poettering wrote:

> This patch introduces a new flag SCHED_RESET_ON_FORK which can be passed
> to the kernel via sched_setscheduler(), ORed in the policy parameter. If
> set this will make sure that when the process forks a) the scheduling
> priority is reset to DEFAULT_PRIO if it was higher and b) the scheduling
> policy is reset to SCHED_NORMAL if it was either SCHED_FIFO or SCHED_RR.

Maybe SCHED_OTHER_ON_FORK, or SCHED_DEFAULT_ON_FORK?

> Why have this?
> 
> Currently, if a process is real-time scheduled this will 'leak' to all
> its child processes. For security reasons it is often (always?) a good
> idea to make sure that if a process acquires RT scheduling this is
> confined to this process and only this process. More specifically this
> makes the per-process resource limit RLIMIT_RTTIME useful for security
> purposes, because it makes it impossible to use a fork bomb to
> circumvent the per-process RLIMIT_RTTIME accounting.
> 
> This feature is also useful for tools like 'renice' which can then
> change the nice level of a process without having this spill to all its
> child processes.
> 
> Why expose this via sched_setscheduler() and not other syscalls such as
> prctl() or sched_setparam()?
> 
> prctl() does not take a pid parameter. Due to that it would be
> impossible to modify this flag for other processes than the current one.

Yeah, same goes for rlimits, I think someone once proposed to allow
changing them in /proc/$pid/limits but I'm not sure what happened to
that proposal.

> The struct passed to sched_setparam() can unfortunately not be extended
> without breaking compatibility, since sched_setparam() lacks a size
> parameter.

Yeah, we're going to have to cross that bridge at some point through,
advanced scheduling policies really need more information. But yeah,
using the upper bits of the policy might work for this.

> How to use this from userspace? In your RT program simply replace this:
> 
>   sched_setscheduler(pid, SCHED_FIFO, &param);
> 
> by this:
> 
>   sched_setscheduler(pid, SCHED_FIFO|SCHED_RESET_ON_FORK, &param);
> 
> This current patch compiles but is not otherwise tested. For now, I am
> sending this primarily as a request for comments. So please, I'd love to
> hear your comments!

Seems reasonable, Ingo?

comments on the implementation below.

> Lennart
> ---
>  include/linux/sched.h |    4 ++++
>  kernel/sched.c        |   47 ++++++++++++++++++++++++++++++++++++++---------
>  2 files changed, 42 insertions(+), 9 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index b4c38bc..395ebc4 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -38,6 +38,8 @@
>  #define SCHED_BATCH		3
>  /* SCHED_ISO: reserved but not implemented yet */
>  #define SCHED_IDLE		5
> +/* Can be ORed in to make sure the process is reverted back to SCHED_NORMAL on fork */
> +#define SCHED_RESET_ON_FORK     0x40000000
>  
>  #ifdef __KERNEL__
>  
> @@ -1429,6 +1431,8 @@ struct task_struct {
>  	/* state flags for use by tracers */
>  	unsigned long trace;
>  #endif
> +	/* Revert to default priority/policy when forking */
> +	unsigned sched_reset_on_fork:1;
>  };

There seems to be a bit hole around in_execve, maybe add it there.
 
>  /* Future-safe accessor for struct task_struct's cpus_allowed. */
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 26efa47..2a2eb07 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -2529,12 +2529,26 @@ void sched_fork(struct task_struct *p, int clone_flags)
>  	set_task_cpu(p, cpu);
>  
>  	/*
> -	 * Make sure we do not leak PI boosting priority to the child:
> +	 * Revert to default priority/policy on fork if requested. Make sure we
> +	 * do not leak PI boosting priority to the child.
>  	 */
> -	p->prio = current->normal_prio;
> +	if (current->sched_reset_on_fork &&
> +			(p->policy == SCHED_FIFO || p->policy == SCHED_RR))
> +		p->policy = SCHED_NORMAL;
> +
> +	if (current->sched_reset_on_fork &&
> +			(current->normal_prio < DEFAULT_PRIO))
> +		p->prio = DEFAULT_PRIO;
> +	else
> +		p->prio = current->normal_prio;

This bit hurt my brain, what's wrong with:

	p->prio = current->normal_prio; /* don't leak boosted prio */
	if (current->sched_reset_on_fork) {
		p->policy = SCHED_NORMAL;
		p->prio = p->normal_prio = p->static_prio = DEFAULT_PRIO;
	}

>  	if (!rt_prio(p->prio))
>  		p->sched_class = &fair_sched_class;
>  
> +	/* We don't need the reset flag anymore after the fork. It has
> +	 * fulfilled its duty. */
> +	p->sched_reset_on_fork = 0;
> +
>  #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
>  	if (likely(sched_info_on()))
>  		memset(&p->sched_info, 0, sizeof(p->sched_info));

