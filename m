Return-Path: <linux-kernel-owner+w=401wt.eu-S1759207AbYGAOLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759207AbYGAOLf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 10:11:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757330AbYGAOLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 10:11:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:45434 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755186AbYGAOLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 10:11:24 -0400
Date: Tue, 1 Jul 2008 10:11:20 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
cc: Gregory Haskins <ghaskins@novell.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [sched-devel, patch-rfc] rework #2 of "prioritize non-migratable
 tasks over migratable ones"
In-Reply-To: <b647ffbd0807010632o64a61ab9le6039465cee85e9c@mail.gmail.com>
Message-ID: <Pine.LNX.4.58.0807011008001.26650@gandalf.stny.rr.com>
References: <b647ffbd0807010632o64a61ab9le6039465cee85e9c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 1 Jul 2008, Dmitry Adamushko wrote:

>
> ---
>
> --- sched_rt-old.c      2008-07-01 11:42:30.000000000 +0200
> +++ sched_rt.c  2008-07-01 15:00:55.000000000 +0200
> @@ -599,11 +599,7 @@ static void __enqueue_rt_entity(struct s
>         if (group_rq && (rt_rq_throttled(group_rq) ||
> !group_rq->rt_nr_running))                return;
>
> -       if (rt_se->nr_cpus_allowed == 1)
> -               list_add(&rt_se->run_list, queue);
> -       else
> -               list_add_tail(&rt_se->run_list, queue);
> -
> +       list_add_tail(&rt_se->run_list, queue);
>         __set_bit(rt_se_prio(rt_se), array->bitmap);
>
>         inc_rt_tasks(rt_se, rt_rq);
> @@ -689,31 +685,33 @@ static void dequeue_task_rt(struct rq *r
>   * followed by enqueue.
>   */
>  static
> -void requeue_rt_entity(struct rt_rq *rt_rq, struct sched_rt_entity *rt_se)
> +void requeue_rt_entity(struct rt_rq *rt_rq, struct sched_rt_entity
> *rt_se, int head)
>  {
> -       struct rt_prio_array *array = &rt_rq->active;
> -
>         if (on_rt_rq(rt_se)) {
> -               list_del_init(&rt_se->run_list);
> -               list_add_tail(&rt_se->run_list,
> -                             array->queue + rt_se_prio(rt_se));
> +               struct rt_prio_array *array = &rt_rq->active;
> +               struct list_head *queue = array->queue + rt_se_prio(rt_se);
> +
> +               if (head)
> +                       list_move(&rt_se->run_list, queue);
> +               else
> +                       list_move_tail(&rt_se->run_list, queue);
>         }
>  }
>
> -static void requeue_task_rt(struct rq *rq, struct task_struct *p)
> +static void requeue_task_rt(struct rq *rq, struct task_struct *p, int head)
>  {
>         struct sched_rt_entity *rt_se = &p->rt;
>         struct rt_rq *rt_rq;
>
>         for_each_sched_rt_entity(rt_se) {
>                 rt_rq = rt_rq_of_se(rt_se);
> -               requeue_rt_entity(rt_rq, rt_se);
> +               requeue_rt_entity(rt_rq, rt_se, head);
>         }
>  }
>
>  static void yield_task_rt(struct rq *rq)
>  {
> -       requeue_task_rt(rq, rq->curr);
> +       requeue_task_rt(rq, rq->curr, 0);
>  }
>
>  #ifdef CONFIG_SMP
> @@ -753,6 +751,29 @@ static int select_task_rq_rt(struct task
>          */
>         return task_cpu(p);
>  }
> +
> +static void check_preempt_equal_prio(struct rq *rq, struct task_struct *p)
> +{
> +       cpumask_t mask;
> +
> +       if (rq->curr.rt.nr_cpus_allowed == 1 || p->rt.nr_cpus_allowed == 1)
> +               return;

I can understand why we break out when current is bound to a single CPU,
but why do we break out when p is bound to a single CPU. Don't we want to
push curr off if we can find a CPU for it?

-- Steve

> +
> +       if (cpupri_find(&rq->rd->cpupri, p, &mask))
> +               return;
> +
> +       if (!cpupri_find(&rq->rd->cpupri, rq->curr, &mask))
> +               return;
> +
> +       /*
> +        * There appears to be other cpus that can accept
> +        * current and none to run 'p', so lets reschedule
> +        * to try and push current away:
> +        */
> +       requeue_task_rt(rq, p, 1);
> +       resched_task(rq->curr);
> +}
> +
>  #endif /* CONFIG_SMP */
>
