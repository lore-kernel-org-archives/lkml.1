Return-Path: <linux-kernel-owner+w=401wt.eu-S1758318AbZCYFZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758318AbZCYFZA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 01:25:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752662AbZCYFYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 01:24:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:60866 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512AbZCYFYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 01:24:50 -0400
Date: Wed, 25 Mar 2009 01:24:47 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: linux-kernel@vger.kernel.org
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 3/5] sched: remove unlikely in pre_schedule_rt
In-Reply-To: <20090325052023.387662292@goodmis.org>
Message-ID: <alpine.DEB.2.00.0903250124080.5675@gandalf.stny.rr.com>
References: <20090325051920.406564281@goodmis.org> <20090325052023.387662292@goodmis.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 25 Mar 2009, Steven Rostedt wrote:

> From: Steven Rostedt <rostedt@goodmis.org>
> 
> Impact: clean up
> 
> The annotated branch profiler shows that the unlikely used by
> pre_schedule_rt is always incorrect. This makes sense because in
> sched.c we have:
> 
> 	if (prev->sched_class->pre_schedule)
> 		prev->sched_class->pre_schedule(rq, prev);
> 
> And we are saying that prev is unlikely to be an rt task. This looks
> more like a likely candidate to me.

I forgot to add the profiler output:

 correct incorrect  %        Function                  File              Line
 ------- ---------  -        --------                  ----              ----
       0     2248 100 pre_schedule_rt                sched_rt.c           1263
 

-- Steve

> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  kernel/sched_rt.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
> index bac1061..537af77 100644
> --- a/kernel/sched_rt.c
> +++ b/kernel/sched_rt.c
> @@ -1260,7 +1260,7 @@ static int pull_rt_task(struct rq *this_rq)
>  static void pre_schedule_rt(struct rq *rq, struct task_struct *prev)
>  {
>  	/* Try to pull RT tasks here if we lower this rq's prio */
> -	if (unlikely(rt_task(prev)) && rq->rt.highest_prio > prev->prio)
> +	if (rt_task(prev) && rq->rt.highest_prio > prev->prio)
>  		pull_rt_task(rq);
>  }
>  
> -- 
> 1.6.2
> 
> -- 
> 
