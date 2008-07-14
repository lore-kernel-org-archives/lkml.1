Return-Path: <linux-kernel-owner+w=401wt.eu-S1756780AbYGNOuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780AbYGNOuw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 10:50:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754184AbYGNOun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 10:50:43 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:37650 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975AbYGNOum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 10:50:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=lZ1rX0StwS+jV5ViyMBkb28JwU3yM1nv+wSOh2PaoJGa8pQm/4QgWU9XtlwO0Ej7kg
         qAAy4YrICG3Qhh6MfKJe6NW8JYS8cMxQ43P379L5v0LGn5FNifJTE0rrSI0AQ99Gvgok
         ZRcbarS0RAtngFS0VEl7yWtGUiNVqs+TVD3I4=
Message-ID: <b647ffbd0807140750r54e5139aj7b25a28ef7ca247e@mail.gmail.com>
Date: Mon, 14 Jul 2008 16:50:41 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Gregory Haskins" <ghaskins@novell.com>
Subject: Re: [sched-devel, patch-rfc] rework #2 of "prioritize non-migratable tasks over migratable ones"
Cc: "Steven Rostedt" <rostedt@goodmis.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <1214947935.5658.11.camel@earth>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1214947935.5658.11.camel@earth>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/1 Dmitry Adamushko <dmitry.adamushko@gmail.com>:
>
> Finally, this new version compiles and boots (applied a minor compilation fix).
> Functionality is not yet fully tested though.
>
> It's on top of today's tip tree.
>
> Any objections to this approach?

[ ping ]

Gregory or anyone else, any feedback on this one?

TIA,


>
> ---
> From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
> Subject: prioritize non-migratable tasks over migratable ones in a generic way
>
> (1) handle in a generic way all cases when a newly woken-up task is
> not migratable (not just a corner case when "rt_se->nr_cpus_allowed ==
> 1")
>
> (2) if current is to be preempted, then make sure "p" will be picked
> up by pick_next_task_rt().
> i.e. move task's group at the head of its list as well.
>
> currently, it's not a case for the group-scheduling case as described
> here: http://www.ussg.iu.edu/hypermail/linux/kernel/0807.0/0134.html
>
>
> Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>
>
> ---
> diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
> index 7c96147..7bc73e8 100644
> --- a/kernel/sched_rt.c
> +++ b/kernel/sched_rt.c
> @@ -599,11 +599,7 @@ static void __enqueue_rt_entity(struct sched_rt_entity *rt_se)
>        if (group_rq && (rt_rq_throttled(group_rq) || !group_rq->rt_nr_running))
>                return;
>
> -       if (rt_se->nr_cpus_allowed == 1)
> -               list_add(&rt_se->run_list, queue);
> -       else
> -               list_add_tail(&rt_se->run_list, queue);
> -
> +       list_add_tail(&rt_se->run_list, queue);
>        __set_bit(rt_se_prio(rt_se), array->bitmap);
>
>        inc_rt_tasks(rt_se, rt_rq);
> @@ -689,31 +685,33 @@ static void dequeue_task_rt(struct rq *rq, struct task_struct *p, int sleep)
>  * followed by enqueue.
>  */
>  static
> -void requeue_rt_entity(struct rt_rq *rt_rq, struct sched_rt_entity *rt_se)
> +void requeue_rt_entity(struct rt_rq *rt_rq, struct sched_rt_entity *rt_se, int head)
>  {
> -       struct rt_prio_array *array = &rt_rq->active;
> -
>        if (on_rt_rq(rt_se)) {
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
>        }
>  }
>
> -static void requeue_task_rt(struct rq *rq, struct task_struct *p)
> +static void requeue_task_rt(struct rq *rq, struct task_struct *p, int head)
>  {
>        struct sched_rt_entity *rt_se = &p->rt;
>        struct rt_rq *rt_rq;
>
>        for_each_sched_rt_entity(rt_se) {
>                rt_rq = rt_rq_of_se(rt_se);
> -               requeue_rt_entity(rt_rq, rt_se);
> +               requeue_rt_entity(rt_rq, rt_se, head);
>        }
>  }
>
>  static void yield_task_rt(struct rq *rq)
>  {
> -       requeue_task_rt(rq, rq->curr);
> +       requeue_task_rt(rq, rq->curr, 0);
>  }
>
>  #ifdef CONFIG_SMP
> @@ -753,6 +751,30 @@ static int select_task_rq_rt(struct task_struct *p, int sync)
>         */
>        return task_cpu(p);
>  }
> +
> +static void check_preempt_equal_prio(struct rq *rq, struct task_struct *p)
> +{
> +       cpumask_t mask;
> +
> +       if (rq->curr->rt.nr_cpus_allowed == 1)
> +               return;
> +
> +       if (p->rt.nr_cpus_allowed != 1
> +           && cpupri_find(&rq->rd->cpupri, p, &mask))
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
>  /*
> @@ -778,18 +800,8 @@ static void check_preempt_curr_rt(struct rq *rq, struct task_struct *p)
>         * to move current somewhere else, making room for our non-migratable
>         * task.
>         */
> -       if((p->prio == rq->curr->prio)
> -          && p->rt.nr_cpus_allowed == 1
> -          && rq->curr->rt.nr_cpus_allowed != 1) {
> -               cpumask_t mask;
> -
> -               if (cpupri_find(&rq->rd->cpupri, rq->curr, &mask))
> -                       /*
> -                        * There appears to be other cpus that can accept
> -                        * current, so lets reschedule to try and push it away
> -                        */
> -                       resched_task(rq->curr);
> -       }
> +       if (p->prio == rq->curr->prio && !need_resched())
> +               check_preempt_equal_prio(rq, p);
>  #endif
>  }
>
> @@ -1415,7 +1427,7 @@ static void task_tick_rt(struct rq *rq, struct task_struct *p, int queued)
>         * on the queue:
>         */
>        if (p->rt.run_list.prev != p->rt.run_list.next) {
> -               requeue_task_rt(rq, p);
> +               requeue_task_rt(rq, p, 0);
>                set_tsk_need_resched(p);
>        }
>  }
>
> ---
>
>
> --Dmitry
>
>
>

-- 
Best regards,
Dmitry Adamushko
