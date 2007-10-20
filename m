Return-Path: <linux-kernel-owner+w=401wt.eu-S1765725AbXJTSOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765725AbXJTSOq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 14:14:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764541AbXJTSOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 14:14:35 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:51095 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764286AbXJTSOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 14:14:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Y6v2SNP9X6Lm5/phfe54tyU/zNHS+EXlxxqpD6rSe08gTQZjgKkVXNQlwFqxkz3nZ2Buu377zPF8OFekDwaW6LH5QgSjjZitf5lSgNWFyHoGbgt3nXMKWBn++FTud7CqabQhrDviVK5x0TnibK7RGKOS1BZze/4+r4eFuGvtHVk=
Message-ID: <b647ffbd0710201114g7fb37652r1e28dddbc7e879f4@mail.gmail.com>
Date: Sat, 20 Oct 2007 20:14:29 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [patch 2/8] track highest prio queued on runqueue
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Gregory Haskins" <ghaskins@novell.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
In-Reply-To: <20071019184336.349767581@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071019184254.456160632@goodmis.org>
	 <20071019184336.349767581@goodmis.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/10/2007, Steven Rostedt <rostedt@goodmis.org> wrote:
> [ ... ]
>
===================================================================
> --- linux-test.git.orig/kernel/sched.c  2007-10-19 12:33:09.000000000 -0400
> +++ linux-test.git/kernel/sched.c       2007-10-19 12:34:32.000000000 -0400
> @@ -324,6 +324,8 @@ struct rq {
>         int push_cpu;
>         /* cpu of this runqueue: */
>         int cpu;
> +       /* highest queued rt task prio */
> +       int highest_prio;

again, could it be moved to 'struct rt_rq' ?
(so we want to cache it as we don't want to trash more per-cpu bytes
calling smth like
if (!rt_nr_running) sched_find_first_bit() from other CPUs)


> @@ -972,6 +974,8 @@ static void activate_task(struct rq *rq,
>
>         enqueue_task(rq, p, wakeup);
>         inc_nr_running(p, rq);
> +
> +       rq_prio_add_task(rq, p);
>  }
>
>  /*
> @@ -984,6 +988,8 @@ static void deactivate_task(struct rq *r
>
>         dequeue_task(rq, p, sleep);
>         dec_nr_running(p, rq);
> +
> +       rq_prio_remove_task(rq, p);
>  }

{enqueue,dequeue}_task_rt() would be more appropriate places.


> +static inline void rq_prio_add_task(struct rq *rq, struct task_struct *p)
> +{
> +       if (unlikely(rt_task(p)) && p->prio < rq->highest_prio)
> +               rq->highest_prio = p->prio;
> +}
> +
> +static inline void rq_prio_remove_task(struct rq *rq, struct task_struct *p)
> +{
> +       struct rt_prio_array *array;
> +
> +       if (unlikely(rt_task(p))) {
> +               if (rq->rt_nr_running) {
> +                       if (p->prio >= rq->highest_prio) {
> +                               /* recalculate */
> +                               array = &rq->rt.active;
> +                               rq->highest_prio =
> +                                       sched_find_first_bit(array->bitmap);
> +                       } /* otherwise leave rq->highest prio alone */
> +               } else
> +                       rq->highest_prio = MAX_RT_PRIO;
> +       }
> +}
> +#endif /* CONFIG_SMP */
> +

(just a few thoughts)

we call sched_find_first_bit() in pick_next_task_rt() in the case when
rt_nr_running != 0.

So if we can tolerate the 'latency' of updating the 'highest_prio' ==
the interval of time between deactivate_task() and pick_next_task() in
schedule() then rq_prio_remove_task() would just need to do a single
thing:

/* No more RT tasks: */
if (!rt_nr_running)
        highest_prio = MAX_RT_PRIO;

and then,

static struct task_struct *pick_next_task_rt(struct rq *rq)
{
        struct rt_prio_array *array = &rq->rt.active;
        struct task_struct *next;
        struct list_head *queue;
        int idx;

-        idx = sched_find_first_bit(array->bitmap);
+       rq->highest_prio = idx = sched_find_first_bit(array->bitmap);

[ ... ]

additionally, if we can tolerate the 'latency' (of updating
highest_prio) == the worst case scheduling latency, then
rq_prio_add_task() is not necessary at all.


-- 
Best regards,
Dmitry Adamushko
