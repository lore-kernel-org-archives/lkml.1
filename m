Return-Path: <linux-kernel-owner+w=401wt.eu-S966045AbXJSTUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966045AbXJSTUf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 15:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762340AbXJSTUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 15:20:24 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:63519 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761013AbXJSTUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 15:20:22 -0400
Date: Fri, 19 Oct 2007 15:19:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch 2/8] track highest prio queued on runqueue
Message-ID: <20071019191922.GA10404@goodmis.org>
References: <20071019184254.456160632@goodmis.org> <20071019184336.349767581@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071019184336.349767581@goodmis.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2007 at 02:42:56PM -0400, Steven Rostedt wrote:
> This patch adds accounting to each runqueue to keep track of the
> highest prio task queued on the run queue. We only care about
> RT tasks, so if the run queue does not contain any active RT tasks
> its priority will be considered MAX_RT_PRIO.
> 
> This information will be used for later patches.
> 

[...]

> @@ -972,6 +974,8 @@ static void activate_task(struct rq *rq,
>  
>  	enqueue_task(rq, p, wakeup);
>  	inc_nr_running(p, rq);
> +
> +	rq_prio_add_task(rq, p);
>  }
>  
>  /*
> @@ -984,6 +988,8 @@ static void deactivate_task(struct rq *r
>  
>  	dequeue_task(rq, p, sleep);
>  	dec_nr_running(p, rq);
> +
> +	rq_prio_remove_task(rq, p);
>  }
>  
>  /**
> @@ -6619,6 +6625,7 @@ void __init sched_init(void)
>  		rq->cpu = i;
>  		rq->migration_thread = NULL;
>  		INIT_LIST_HEAD(&rq->migration_queue);
> +		rq->highest_prio = MAX_RT_PRIO;
>  #endif
>  		atomic_set(&rq->nr_iowait, 0);
>  
> Index: linux-test.git/kernel/sched_rt.c
> ===================================================================
> --- linux-test.git.orig/kernel/sched_rt.c	2007-10-19 12:33:09.000000000 -0400
> +++ linux-test.git/kernel/sched_rt.c	2007-10-19 12:33:23.000000000 -0400
> @@ -110,6 +110,31 @@ static struct task_struct *pick_next_tas
>  	return next;
>  }
>  
> +#ifdef CONFIG_SMP
> +static inline void rq_prio_add_task(struct rq *rq, struct task_struct *p)
> +{
> +	if (unlikely(rt_task(p)) && p->prio < rq->highest_prio)
> +		rq->highest_prio = p->prio;
> +}
> +
> +static inline void rq_prio_remove_task(struct rq *rq, struct task_struct *p)
> +{
> +	struct rt_prio_array *array;
> +
> +	if (unlikely(rt_task(p))) {
> +		if (rq->rt_nr_running) {
> +			if (p->prio >= rq->highest_prio) {
> +				/* recalculate */
> +				array = &rq->rt.active;
> +				rq->highest_prio =
> +					sched_find_first_bit(array->bitmap);
> +			} /* otherwise leave rq->highest prio alone */
> +		} else
> +			rq->highest_prio = MAX_RT_PRIO;
> +	}
> +}
> +#endif /* CONFIG_SMP */
> +

Sorry, I forgot to test this on UP. Seems to be missing a 

#define rq_prio_remove_task(rq, p) do { } while(0)
#define rq_prio_add(rq, p) do { } while(0)

for the !CONFIG_SMP case.

Will fix.

-- Steve


