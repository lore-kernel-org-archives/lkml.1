Return-Path: <linux-kernel-owner+w=401wt.eu-S1754420AbYDWLVM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420AbYDWLVM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 07:21:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750973AbYDWLU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 07:20:58 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:33323 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbYDWLU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 07:20:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZjCw/CF5JP6QGl2z/IWSE5dNIM5vxVdQaVJCQmu97LExYjALCfLgMikKEJ4DDSLy1tkhgusvzEM+a5NcxY9sVzY36pcnQVFDP4yeWx43qj9HwsaUwAMeGfAp31b2y++8dR4ciCsoBbEJh6683oD8HBCD2YhBy1ZuF32VfZ95GFY=
Message-ID: <b647ffbd0804230420l7f74713ax16aa4801491ef6c1@mail.gmail.com>
Date: Wed, 23 Apr 2008 13:20:54 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Gregory Haskins" <ghaskins@novell.com>
Subject: Re: [PATCH 1/2] sched: push rt tasks only if newly activated tasks have been added
Cc: mingo@elte.hu, "Steven Rostedt" <rostedt@goodmis.org>,
       chinang.ma@intel.com, suresh.b.siddha@intel.com, arjan@linux.intel.com,
       willy@linux.intel.com, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
In-Reply-To: <480EDD2F.BA47.005A.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080421180747.4560.67794.stgit@novell1.haskins.net>
	 <20080421181015.4560.7658.stgit@novell1.haskins.net>
	 <b647ffbd0804220830h6524e788n1467b027bc5bc4d2@mail.gmail.com>
	 <Pine.LNX.4.58.0804221144410.21511@gandalf.stny.rr.com>
	 <b647ffbd0804230105u7966ed06wd4ed248f59132849@mail.gmail.com>
	 <b647ffbd0804230253i32f48fcgb5dc7cf5b55607ac@mail.gmail.com>
	 <480ED122.BA47.005A.0@novell.com>
	 <b647ffbd0804230323s20d25697qcf80ca9996e143a7@mail.gmail.com>
	 <480EDD2F.BA47.005A.0@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/4/23 Gregory Haskins <ghaskins@novell.com>:
> >>> On Wed, Apr 23, 2008 at  6:23 AM, in message
>  <b647ffbd0804230323s20d25697qcf80ca9996e143a7@mail.gmail.com>, "Dmitry
>
> Adamushko" <dmitry.adamushko@gmail.com> wrote:
>
> > 2008/4/23 Gregory Haskins <ghaskins@novell.com>:
>  >> [ ... ]
>  >>
>  >>  I think we can simplify this further.  We really only need to push here if
>  > we are not going to reschedule anytime soon (probably white-space damaged):
>  >>
>  >>
>  >>  --- a/kernel/sched_rt.c
>  >>
>  >> +++ b/kernel/sched_rt.c
>  >>  @@ -1058,11 +1058,14 @@ static void post_schedule_rt(struct rq *rq)
>  >>         }
>  >>   }
>  >>
>  >>  -
>  >>  +/*
>  >>  + * If we are not running and we are not going to reschedule soon, we
>  > should
>  >>  + * try to push tasks away now
>  >>  + */
>  >>
>  >>  static void task_wake_up_rt(struct rq *rq, struct task_struct *p)
>  >>   {
>  >>         if (!task_running(rq, p) &&
>  >>  -           (p->prio >= rq->rt.highest_prio) &&
>  >>  +           !test_tsk_thread_flag(rq->curr, TIF_NEED_RESCHED) &&
>  >>             rq->rt.overloaded)
>  >>                 push_rt_tasks(rq);
>  >>   }
>  >
>  >
>  > It's somewhat suboptimal as it doesn't guarantee that 'p' gets control next.
>
>  No it doesn't, but I don't see that as a requirement to work properly.  All we really need is to make sure push_rt_tasks() will be executed in the near future, and a reschedule will do that.  Perhaps I am missing something?

No, it's better indeed to delay push_rt_tasks() until
post_rt_schedule() when 'current' (that's a task to be preempted) is
also available for potential migration.

Not considering "current" (as it's running) in task_wake_up_rt()   is
a key of the problem which I illustrated in my first message.

I mean, we set rq->rt.pushed = 1 and that kind of means "nothing to be
push off here any more" but "current" was out of our consideration.

humm... a quick idea (should think more on it):

(1) select_task_rq_rt() + task_wake_up_rt() should consider only 'p'
(a newly woken up task) for pushing off a cpu;

i.e. task_wake_up_rt() calls push_rt_task(..., p) and _never_ sets up
rq->rt.pushed;

the main point where 'pushed' is done :
(2) post_schedule_rt()

here we call push_rt_tasks() and set up rq->rt.pushed to 1.

heh, I can be missing something important... need to verify different
scenarios wrt this algo.



>  > e.g. 2 tasks (T0 and T1) have been woken up before an actual
>  > re-schedule takes place. Even if T1 is of lower prio than T0,
>  > task_wake_up_rt() will see the NEED_RESCHED flag and bail out while it
>  > would make sense at this moment to push T1 off this cpu.
>
>  I think this is "ok".  IMO, we really want to prioritize the push operation from post_schedule() over task_wake_up() because it is the most accurate (since the scheduling decision would be atomic to the rq->lock).

Agreed. And as I noticed above, ex-current is also available for
migration policies at this point + the most eligible task has just got
control (and it's the only task that shouldn't be considered for
migration).


-- 
Best regards,
Dmitry Adamushko
