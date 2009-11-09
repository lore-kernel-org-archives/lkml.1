Return-Path: <linux-kernel-owner+w=401wt.eu-S1753745AbZKITfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745AbZKITfs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 14:35:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751411AbZKITfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 14:35:48 -0500
Received: from sinclair.provo.novell.com ([137.65.248.137]:3683 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbZKITfr convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-ghaskins@novell.com;5:1>);
	Mon, 9 Nov 2009 14:35:47 -0500
Message-Id: <4AF828C50200005A000585DB@sinclair.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Mon, 09 Nov 2009 12:35:49 -0700
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>, <Lucas.de.marchi@gmail.com>,
       "Steven Rostedt" <rostedt@goodmis.org>
Cc: "Peter Zijlstra" <peterz@infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [lucas.de.marchi@gmail.com: Bug when changing cpus_allowed
	 of RT tasks?]
References: <20091108121650.GB11372@elte.hu>
In-Reply-To: <20091108121650.GB11372@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lucas,

Ingo asked me to take a look at the problem you are reporting.  Is this a bug you are seeing in the
wild, or was this found by code-inspection?  I took a look, and it looks to me that the original code
is correct, but I will keep an open mind.

In the meantime, I will try to provide some details about what is going on here.  Comments inline.

>>> On 11/8/2009 at  7:16 AM, in message <20091108121650.GB11372@elte.hu>, Ingo
Molnar <mingo@elte.hu> wrote: 

> FYI. If you reply then please do so on-list.
> 
> Thanks,
> 
> 	Ingo
> 
> ----- Forwarded message from Lucas De Marchi <lucas.de.marchi@gmail.com> -----
> 
> Date: Mon, 26 Oct 2009 14:11:13 -0200
> From: Lucas De Marchi <lucas.de.marchi@gmail.com>
> To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
> Cc: linux-kernel@vger.kernel.org
> Subject: Bug when changing cpus_allowed of RT tasks?
> 
> I think there's a problem when balancing RT tasks: both find_lowest_rq_rt 
> and
> select_task_rq_rt check for p->rt.nr_cpus_allowed being greater than 1 to wake
> a task in another cpu:
> 
> 	static int select_task_rq_rt(struct task_struct *p, int sd_flag, int flags)
> 	{
> 		[...]
> 		if (unlikely(rt_task(rq->curr)) &&
> 		    (p->rt.nr_cpus_allowed > 1)) {
> 			int cpu = find_lowest_rq(p);
> 
> 			return (cpu == -1) ? task_cpu(p) : cpu;
> 		}
> 		[...]
> 	}

So the intent of this logic is to say "if the task is of type RT, and it can move, see if it can move
elsewhere".  Otherwise, we do not try to move it at all.

> 
> 	static int find_lowest_rq(struct task_struct *task)
> 	{
> 		struct sched_domain *sd;
> 		struct cpumask *lowest_mask = __get_cpu_var(local_cpu_mask);
> 		int this_cpu = smp_processor_id();
> 		int cpu      = task_cpu(task);
> 		cpumask_var_t domain_mask;
> 
> 		if (task->rt.nr_cpus_allowed == 1)
> 			return -1; /* No other targets possible */
> 		[...]
> 	}

And the intent here is to say if the task isn't allowed to move, to not try to compute another
location as task_cpu() is the only valid home.

> 
> 
> What happens if rt.nr_cpus_allowed continues to be 1, but the allowed cpu is
> not the one in which task is being woken up?

The one case that I can think of that would fall into this category is during a sched_setaffinity()?

If so, what happens is that we ultimately call set_cpus_allowed() -> set_cpus_allowed_ptr().  Inside
this function, the new mask is validated independent of the nr_cpus_allowed value and we will
migrate the task away if it is no longer on a valid core.

Are there other cases?

> Since set_cpus_allowed_rt just
> changed the mask and updated the value of nr_cpus_allowed_rt, as far as I 
> can
> see, it remains on same CPU even if the new mask does not allow.
> 
> A possible fix below, and in case it is right:
> 	Signed-off-by: Lucas De Marchi <lucas.de.marchi@gmail.com>
> 
>

Until further evidence is presented, I have to respectfully NAK the patch, as I do not think its doing the right thing
nor do I think the current code is actually broken.

I will keep an open mind, though, so if you think there is really a problem, lets discuss.
 
> 
> Lucas De Marchi
> 
> 
> --
> 
> diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
> index a4d790c..531c946 100644
> --- a/kernel/sched_rt.c
> +++ b/kernel/sched_rt.c
> @@ -962,8 +962,7 @@ static int select_task_rq_rt(struct task_struct
> *p, int sd_flag, int flags)
>  	 * that is just being woken and probably will have
>  	 * cold cache anyway.
>  	 */
> -	if (unlikely(rt_task(rq->curr)) &&
> -	    (p->rt.nr_cpus_allowed > 1)) {
> +	if (unlikely(rt_task(rq->curr))) {
>  		int cpu = find_lowest_rq(p);
> 
>  		return (cpu == -1) ? task_cpu(p) : cpu;
> @@ -1177,7 +1176,8 @@ static int find_lowest_rq(struct task_struct *task)
>  	int cpu      = task_cpu(task);
>  	cpumask_var_t domain_mask;
> 
> -	if (task->rt.nr_cpus_allowed == 1)
> +	if ((task->rt.nr_cpus_allowed == 1) &&
> +			likely(cpumask_test_cpu(cpu, &task->cpus_allowed)))
>  		return -1; /* No other targets possible */
> 
>  	if (!cpupri_find(&task_rq(task)->rd->cpupri, task, lowest_mask))
> 
> ----- End forwarded message -----


