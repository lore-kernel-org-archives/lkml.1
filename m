Return-Path: <linux-kernel-owner+w=401wt.eu-S933126AbXJORqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933126AbXJORqn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 13:46:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763419AbXJORqD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 13:46:03 -0400
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:49557 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933047AbXJORqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 13:46:00 -0400
Date: Mon, 15 Oct 2007 13:45:32 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Gregory Haskins <ghaskins@novell.com>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/7] RT: Wrap the RQ notion of priority to make it
 conditional
In-Reply-To: <20071013001543.7444.6025.stgit@novell1.haskins.net>
Message-ID: <Pine.LNX.4.58.0710151343300.26495@gandalf.stny.rr.com>
References: <20071013001052.7444.8363.stgit@novell1.haskins.net>
 <20071013001543.7444.6025.stgit@novell1.haskins.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



--

On Fri, 12 Oct 2007, Gregory Haskins wrote:

> A little cleanup to avoid #ifdef proliferation later in the series
>
> Signed-off-by: Gregory Haskins <ghaskins@novell.com>

NACK

> ---
>
>  kernel/sched.c |   23 ++++++++++++++++++++---
>  1 files changed, 20 insertions(+), 3 deletions(-)
>
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 0a1ad0e..c9afc8a 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -255,6 +255,10 @@ struct cfs_rq {
>  #endif
>  };
>
> +#if defined(CONFIG_PREEMPT_RT) && defined(CONFIG_SMP)
> +#define  ENABLE_RQ_PRIORITY   /* Steve wants this conditional on PREEMPT_RT */

Yes, I do want it conditional. But only because we want to test it first,
so the condition is really temporary. I agree with Peter that this should
be for non PREEMPT_RT as well, and I'll work on a patch for upstream.

But these defines setting defines is just ugly.

-- Steve


> +#endif /* CONFIG_PREEMPT_RT */
> +
>  /* Real-Time classes' related field in a runqueue: */
>  struct rt_rq {
>  	struct rt_prio_array active;
> @@ -304,6 +308,9 @@ struct rq {
>  #ifdef CONFIG_PREEMPT_RT
>  	unsigned long rt_nr_running;
>  	unsigned long rt_nr_uninterruptible;
> +#endif
> +
> +#ifdef ENABLE_RQ_PRIORITY
>  	int curr_prio;
>  #endif
>
> @@ -365,6 +372,16 @@ struct rq {
>  static DEFINE_PER_CPU_SHARED_ALIGNED(struct rq, runqueues);
>  static DEFINE_MUTEX(sched_hotcpu_mutex);
>
> +#ifdef ENABLE_RQ_PRIORITY
> +static inline void set_rq_prio(struct rq *rq, int prio)
> +{
> +	rq->curr_prio = prio;
> +}
> +
> +#else
> +#define set_rq_prio(rq, prio) do { } while(0)
> +#endif
> +
>  static inline void check_preempt_curr(struct rq *rq, struct task_struct *p)
>  {
>  	rq->curr->sched_class->check_preempt_curr(rq, p);
> @@ -2331,9 +2348,9 @@ static inline void finish_task_switch(struct rq *rq, struct task_struct *prev)
>  	 */
>  	prev_state = prev->state;
>  	_finish_arch_switch(prev);
> -#if defined(CONFIG_PREEMPT_RT) && defined(CONFIG_SMP)
> -	rq->curr_prio = current->prio;
> -#endif
> +
> +	set_rq_prio(rq, current->prio);
> +
>  	finish_lock_switch(rq, prev);
>  #if defined(CONFIG_PREEMPT_RT) && defined(CONFIG_SMP)
>  	/*
>
>
>
