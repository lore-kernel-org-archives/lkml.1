Return-Path: <linux-kernel-owner+w=401wt.eu-S1761408AbYDWKDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761408AbYDWKDj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 06:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760924AbYDWKCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 06:02:46 -0400
Received: from sinclair.provo.novell.com ([137.65.248.137]:46368 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760906AbYDWKCp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 06:02:45 -0400
Message-Id: <480ED122.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Wed, 23 Apr 2008 04:03:14 -0600
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>,
       "Steven Rostedt" <rostedt@goodmis.org>
Cc: <mingo@elte.hu>, <chinang.ma@intel.com>, <suresh.b.siddha@intel.com>,
       <arjan@linux.intel.com>, <willy@linux.intel.com>,
       <linux-kernel@vger.kernel.org>, <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH 1/2] sched: push rt tasks only if newly activated
	tasks have been added
References: <20080421180747.4560.67794.stgit@novell1.haskins.net>
 <20080421181015.4560.7658.stgit@novell1.haskins.net>
 <b647ffbd0804220830h6524e788n1467b027bc5bc4d2@mail.gmail.com>
 <Pine.LNX.4.58.0804221144410.21511@gandalf.stny.rr.com>
 <b647ffbd0804230105u7966ed06wd4ed248f59132849@mail.gmail.com>
 <b647ffbd0804230253i32f48fcgb5dc7cf5b55607ac@mail.gmail.com>
In-Reply-To: <b647ffbd0804230253i32f48fcgb5dc7cf5b55607ac@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On Wed, Apr 23, 2008 at  5:53 AM, in message
<b647ffbd0804230253i32f48fcgb5dc7cf5b55607ac@mail.gmail.com>, "Dmitry
Adamushko" <dmitry.adamushko@gmail.com> wrote: 
> 2008/4/23 Dmitry Adamushko <dmitry.adamushko@gmail.com>:
>> Hi Steven,
>>
>>  > [ ... ]
>>
>> >  > square#0:
>>  >  >
>>  >  > cpu1:  T0 is running
>>  >  >
>>  >  > T1 is of the same prio as T0 (shouldn't really matter but to get the
>>  >  > same result it would require altering the flow of events slightly)
>>  >  >
>>  >  > T1's affinity allows it to be run only on cpu1.
>>  >  > T0 can run on both.
>>  >  >
>>  >  > try_to_wake_up() is called for T1.
>>  >  > |
>>  >  > --> select_task_rq_rt() => gives cpu1
>>  >  > |
>>  >  > --> task_wake_up_rt()
>>  >  >    |
>>  >  >    ---> push_rt_tasks() -> rq->rt.pushed = 1
>>  >  >
>>  >  > now, neither T1 (due to its affinity), nor T0 (it's running) can be
>>  >  > pushed away to cpu0.
>>  >
>>  >  Ah, this may be what you are talking about. T0 was running, but because
>>  >  T1 has its affinity set to cpu1 it wont cause a push. When T0 schedules
>>  >  away to give T1 its cpu time, T0 wont push away because of the pushed
>>  >  flag.
>>  >
>>  >  Hmm, interesting. Of course my response is "Don't use SCHED_RR! It's
>>  >  evil!" ;-)
>>
>>  It's not just SCHED_RR ;-) They both can be of SCHED_FIFO.
>>
>>  T1 _preempts_ T0 and again
>>
>>
>>   --> task_wake_up_rt()
>>   |
>>   ---> push_rt_tasks() -> rq->rt.pushed = 1
>>
>>  and T0 won't be pushed away to cpu0 by post_schedule_rt().
>>
>>  As Gregory has pointed out, at the very least it's a test in
>>  task_wake_up_rt() which is wrong.
>>
>>  push_rt_tasks() should not be called when 'p' (a newly woken up task)
>>  is the next one to run.
>>
>>  IOW, it should be (p->prio < rq->curr->prio) instead of (p->prio >=
>>  rq->rt.highest_prio).
> 
> No, this argument is wrong indeed.
> 
> Something like this:
> (white-spaces are broken)
> 
> --- sched_rt-prev.c     2008-04-23 11:26:39.000000000 +0200
> +++ sched_rt.c  2008-04-23 11:36:20.000000000 +0200
> @@ -1121,9 +1121,13 @@ static void post_schedule_rt(struct rq *
> 
>  static void task_wake_up_rt(struct rq *rq, struct task_struct *p)
>  {
> -       if (!task_running(rq, p) &&
> -           (p->prio >= rq->rt.highest_prio) &&
> -           rq->rt.overloaded)
> +       /*
> +        * Consider pushing 'p' off to other CPUS only
> +        * if it's not the next task to run on this CPU.
> +        */
> +       if (rq->rt.overloaded &&
> +           p->prio > rq->rt.highest_prio &&
> +           pick_rt_task(rq, p, -1))
>                 push_rt_tasks(rq);
>  }
> 
> 
> or even this (although, it's a bit heavier)
> 
> --- sched_rt-prev.c     2008-04-23 11:26:39.000000000 +0200
> +++ sched_rt.c  2008-04-23 11:49:03.000000000 +0200
> @@ -1118,12 +1118,22 @@ static void post_schedule_rt(struct rq *
>         }
>  }
> 
>  static void task_wake_up_rt(struct rq *rq, struct task_struct *p)
>  {
> -       if (!task_running(rq, p) &&
> -           (p->prio >= rq->rt.highest_prio) &&
> -           rq->rt.overloaded)
> +       if (!rq->rt.overloaded)
> +               return;
> +
> +       /*
> +        * Consider pushing 'p' off to other CPUS only
> +        * if it's not the next task to run on this CPU.
> +        * i.e. it's not a single task with the highest prio
> +        * on the queue.
> +        */
> +       if (p->prio == rq->rt.highest_prio &&
> +           p->rt.run_list.prev == p->rt.run_list.next)
> +               return;
> +
> +       if (pick_rt_task(rq, p, -1))
>                 push_rt_tasks(rq);
>  }
> 


I think we can simplify this further.  We really only need to push here if we are not going to reschedule anytime soon (probably white-space damaged):


--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1058,11 +1058,14 @@ static void post_schedule_rt(struct rq *rq)
        }
 }

-
+/*
+ * If we are not running and we are not going to reschedule soon, we should
+ * try to push tasks away now
+ */
 static void task_wake_up_rt(struct rq *rq, struct task_struct *p)
 {
        if (!task_running(rq, p) &&
-           (p->prio >= rq->rt.highest_prio) &&
+           !test_tsk_thread_flag(rq->curr, TIF_NEED_RESCHED) &&
            rq->rt.overloaded)
                push_rt_tasks(rq);
 }

