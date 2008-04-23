Return-Path: <linux-kernel-owner+w=401wt.eu-S1761057AbYDWKCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761057AbYDWKCz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 06:02:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756614AbYDWJxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 05:53:50 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:23719 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755276AbYDWJxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 05:53:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pH3U7QFpHrDiTQIuu24uKvCBhu6l/x9a5yEkPQ/vjILA7AJULW6k5v932hwVe4CWBlapdBh2izrPLM6n6jgAAtbm92r4OBuyJkcGAQPf76dKFjT3IGZB0vBI+A4wrCIs7/fhCSw0fGUBNy0ervwo/d5oHrUnKCNi7AjCmBEsWvU=
Message-ID: <b647ffbd0804230253i32f48fcgb5dc7cf5b55607ac@mail.gmail.com>
Date: Wed, 23 Apr 2008 11:53:47 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH 1/2] sched: push rt tasks only if newly activated tasks have been added
Cc: "Gregory Haskins" <ghaskins@novell.com>, mingo@elte.hu,
       suresh.b.siddha@intel.com, chinang.ma@intel.com, arjan@linux.intel.com,
       willy@linux.intel.com, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
In-Reply-To: <b647ffbd0804230105u7966ed06wd4ed248f59132849@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080421180747.4560.67794.stgit@novell1.haskins.net>
	 <20080421181015.4560.7658.stgit@novell1.haskins.net>
	 <b647ffbd0804220830h6524e788n1467b027bc5bc4d2@mail.gmail.com>
	 <Pine.LNX.4.58.0804221144410.21511@gandalf.stny.rr.com>
	 <b647ffbd0804230105u7966ed06wd4ed248f59132849@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/4/23 Dmitry Adamushko <dmitry.adamushko@gmail.com>:
> Hi Steven,
>
>  > [ ... ]
>
> >  > square#0:
>  >  >
>  >  > cpu1:  T0 is running
>  >  >
>  >  > T1 is of the same prio as T0 (shouldn't really matter but to get the
>  >  > same result it would require altering the flow of events slightly)
>  >  >
>  >  > T1's affinity allows it to be run only on cpu1.
>  >  > T0 can run on both.
>  >  >
>  >  > try_to_wake_up() is called for T1.
>  >  > |
>  >  > --> select_task_rq_rt() => gives cpu1
>  >  > |
>  >  > --> task_wake_up_rt()
>  >  >    |
>  >  >    ---> push_rt_tasks() -> rq->rt.pushed = 1
>  >  >
>  >  > now, neither T1 (due to its affinity), nor T0 (it's running) can be
>  >  > pushed away to cpu0.
>  >
>  >  Ah, this may be what you are talking about. T0 was running, but because
>  >  T1 has its affinity set to cpu1 it wont cause a push. When T0 schedules
>  >  away to give T1 its cpu time, T0 wont push away because of the pushed
>  >  flag.
>  >
>  >  Hmm, interesting. Of course my response is "Don't use SCHED_RR! It's
>  >  evil!" ;-)
>
>  It's not just SCHED_RR ;-) They both can be of SCHED_FIFO.
>
>  T1 _preempts_ T0 and again
>
>
>   --> task_wake_up_rt()
>   |
>   ---> push_rt_tasks() -> rq->rt.pushed = 1
>
>  and T0 won't be pushed away to cpu0 by post_schedule_rt().
>
>  As Gregory has pointed out, at the very least it's a test in
>  task_wake_up_rt() which is wrong.
>
>  push_rt_tasks() should not be called when 'p' (a newly woken up task)
>  is the next one to run.
>
>  IOW, it should be (p->prio < rq->curr->prio) instead of (p->prio >=
>  rq->rt.highest_prio).

No, this argument is wrong indeed.

Something like this:
(white-spaces are broken)

--- sched_rt-prev.c     2008-04-23 11:26:39.000000000 +0200
+++ sched_rt.c  2008-04-23 11:36:20.000000000 +0200
@@ -1121,9 +1121,13 @@ static void post_schedule_rt(struct rq *

 static void task_wake_up_rt(struct rq *rq, struct task_struct *p)
 {
-       if (!task_running(rq, p) &&
-           (p->prio >= rq->rt.highest_prio) &&
-           rq->rt.overloaded)
+       /*
+        * Consider pushing 'p' off to other CPUS only
+        * if it's not the next task to run on this CPU.
+        */
+       if (rq->rt.overloaded &&
+           p->prio > rq->rt.highest_prio &&
+           pick_rt_task(rq, p, -1))
                push_rt_tasks(rq);
 }


or even this (although, it's a bit heavier)

--- sched_rt-prev.c     2008-04-23 11:26:39.000000000 +0200
+++ sched_rt.c  2008-04-23 11:49:03.000000000 +0200
@@ -1118,12 +1118,22 @@ static void post_schedule_rt(struct rq *
        }
 }

 static void task_wake_up_rt(struct rq *rq, struct task_struct *p)
 {
-       if (!task_running(rq, p) &&
-           (p->prio >= rq->rt.highest_prio) &&
-           rq->rt.overloaded)
+       if (!rq->rt.overloaded)
+               return;
+
+       /*
+        * Consider pushing 'p' off to other CPUS only
+        * if it's not the next task to run on this CPU.
+        * i.e. it's not a single task with the highest prio
+        * on the queue.
+        */
+       if (p->prio == rq->rt.highest_prio &&
+           p->rt.run_list.prev == p->rt.run_list.next)
+               return;
+
+       if (pick_rt_task(rq, p, -1))
                push_rt_tasks(rq);
 }


-- 
Best regards,
Dmitry Adamushko
