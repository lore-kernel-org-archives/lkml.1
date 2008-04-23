Return-Path: <linux-kernel-owner+w=401wt.eu-S1755208AbYDWKyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208AbYDWKyV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 06:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751478AbYDWKyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 06:54:13 -0400
Received: from sinclair.provo.novell.com ([137.65.248.137]:46912 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbYDWKyM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 06:54:12 -0400
Message-Id: <480EDD2F.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Wed, 23 Apr 2008 04:54:39 -0600
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
Cc: <mingo@elte.hu>, "Steven Rostedt" <rostedt@goodmis.org>,
       <chinang.ma@intel.com>, <suresh.b.siddha@intel.com>,
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
 <480ED122.BA47.005A.0@novell.com>
 <b647ffbd0804230323s20d25697qcf80ca9996e143a7@mail.gmail.com>
In-Reply-To: <b647ffbd0804230323s20d25697qcf80ca9996e143a7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On Wed, Apr 23, 2008 at  6:23 AM, in message
<b647ffbd0804230323s20d25697qcf80ca9996e143a7@mail.gmail.com>, "Dmitry
Adamushko" <dmitry.adamushko@gmail.com> wrote: 
> 2008/4/23 Gregory Haskins <ghaskins@novell.com>:
>> [ ... ]
>>
>>  I think we can simplify this further.  We really only need to push here if 
> we are not going to reschedule anytime soon (probably white-space damaged):
>>
>>
>>  --- a/kernel/sched_rt.c
>>
>> +++ b/kernel/sched_rt.c
>>  @@ -1058,11 +1058,14 @@ static void post_schedule_rt(struct rq *rq)
>>         }
>>   }
>>
>>  -
>>  +/*
>>  + * If we are not running and we are not going to reschedule soon, we 
> should
>>  + * try to push tasks away now
>>  + */
>>
>>  static void task_wake_up_rt(struct rq *rq, struct task_struct *p)
>>   {
>>         if (!task_running(rq, p) &&
>>  -           (p->prio >= rq->rt.highest_prio) &&
>>  +           !test_tsk_thread_flag(rq->curr, TIF_NEED_RESCHED) &&
>>             rq->rt.overloaded)
>>                 push_rt_tasks(rq);
>>   }
> 
> 
> It's somewhat suboptimal as it doesn't guarantee that 'p' gets control next.

No it doesn't, but I don't see that as a requirement to work properly.  All we really need is to make sure push_rt_tasks() will be executed in the near future, and a reschedule will do that.  Perhaps I am missing something?

> 
> e.g. 2 tasks (T0 and T1) have been woken up before an actual
> re-schedule takes place. Even if T1 is of lower prio than T0,
> task_wake_up_rt() will see the NEED_RESCHED flag and bail out while it
> would make sense at this moment to push T1 off this cpu.

I think this is "ok".  IMO, we really want to prioritize the push operation from post_schedule() over task_wake_up() because it is the most accurate (since the scheduling decision would be atomic to the rq->lock).  This way we avoid pushing the wrong task away before the schedule has a chance to run.  I think your alg probably approximates this same accuracy, albeit in a more expensive way.  The one thing I can say is an advantage to your approach is that it potentially would migrate the task faster (though it shouldn't be by very much, since the resched is technically pending).  This argument is further compounded by the fact that you would have to subtract the extra overhead of running pick_next_task() et. al. from the gain of avoiding the wait for the reschedule, of course.  This would errode some of the lower-latency argument.

Hmmm...  Im not sure which I like better...simplicity is often nice IMO, but I think either could work.

> 
> 
> p.s. hope you are better today. get well! :-)

Thanks!  I am feeling much better today, though I don't think I am fully out of the woods yet.

> 



