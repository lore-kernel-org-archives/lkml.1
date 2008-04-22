Return-Path: <linux-kernel-owner+w=401wt.eu-S1756328AbYDVQiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328AbYDVQiR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 12:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753196AbYDVQiC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 12:38:02 -0400
Received: from sinclair.provo.novell.com ([137.65.248.137]:30915 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118AbYDVQiA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 12:38:00 -0400
Message-Id: <480DDC48.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Tue, 22 Apr 2008 10:38:32 -0600
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
Cc: <mingo@elte.hu>, <rostedt@goodmis.org>, <chinang.ma@intel.com>,
       <suresh.b.siddha@intel.com>, <arjan@linux.intel.com>,
       <willy@linux.intel.com>, <linux-kernel@vger.kernel.org>,
       <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH 1/2] sched: push rt tasks only if newly activated
	tasks have been added
References: <20080421180747.4560.67794.stgit@novell1.haskins.net>
 <20080421181015.4560.7658.stgit@novell1.haskins.net>
 <b647ffbd0804220830h6524e788n1467b027bc5bc4d2@mail.gmail.com>
In-Reply-To: <b647ffbd0804220830h6524e788n1467b027bc5bc4d2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

(Disclaimer: I am sick with a fever today, so hopefully I'm groking your email properly and not about to say something stupid ;)

>>> On Tue, Apr 22, 2008 at 11:30 AM, in message
<b647ffbd0804220830h6524e788n1467b027bc5bc4d2@mail.gmail.com>, "Dmitry
Adamushko" <dmitry.adamushko@gmail.com> wrote: 
> Hi Gregory,
> 
> 
> consider the following 2-cpu system: cpu0 and cpu1.
> 
> cpu0: is idle --> in such a state, it never pulls RT tasks on its own.
> 
> T0 and T1 are RT tasks
> 
> 
> square#0:
> 
> cpu1:  T0 is running
> 
> T1 is of the same prio as T0 (shouldn't really matter but to get the
> same result it would require altering the flow of events slightly)
> 
> T1's affinity allows it to be run only on cpu1.
> T0 can run on both.
> 
> try_to_wake_up() is called for T1.
> |
> --> select_task_rq_rt() => gives cpu1
> |
> --> task_wake_up_rt()
>    |
>    ---> push_rt_tasks() -> rq->rt.pushed = 1
> 
> now, neither T1 (due to its affinity), nor T0 (it's running) can be
> pushed away to cpu0.
> 
> [ btw., (1) I'd expect that this task_wake_up_rt() thing should be
> redundant, logically-wise... I'll check once more and comment later
> on.

They are both necessary, but the key is that the select_task_rq() is a best-effort route attempt, whereas the task_wake_up() routine is the authoritative router.  By doing the push after activation, it allowed us to utilize a very clever and significant optimization on the pull side that Steven came up with.  The details of the optimization escape me now, but I do remember it was substantial to the design.  Then later we put the select_task_rq() logic in (see git-id 318e0893) to further optimize the routing by finding a likely good home before the activation takes place (saving an activation/deactivation cycle), but it still needs the post-router to protect against race conditions since its just best-effort.

> (2) any example when (p->prio >= rq->rt.highest_prio) is not true in
> task_wake_up_rt() ?

Hmm...good catch.   Looks like it should be "p->prio >= rq->curr->prio" since we only need be concerned with pushing here if the task is not going to preempt current.  Do you agree Steven, or am I missing something? 


> ]
> 
> as a result, rq->rt.pushed == 1.
> 
> Now, post_schedule_rt() won't call push_rt_tasks().
> 
> T0 and T1 are both running for some time on cpu1 (possibly
> context-switching if they are both of SCHED_RR type).
> 
> Then they both block, _first_ T1 and then T0.
> 
> After some interval of time, they wake up (let's say they are
> periodic) in the following order: _first_ T0 and then T1.
> 
> rq->rt.pushed becomes 0 and here we are back to square#0. The whole
> story repeats again.
> 
> cpu0 is idle so it won't pull T0. Both T0 and T1 are competing for the
> same cpu. Not good.
> 
> am I missing smth?

No, I think you are indeed correct.  However, I would consider the root cause of the problem to have existed prior to the "pushed" flag, so perhaps we need to address this at a different level.  The case you present would have always been problematic for FIFO, and would have "worked" for RR eventually prior to the "pushed" patch.  But I dont know if I like relying on how it worked before to fix up the system.  At the very best, T1 would have experienced a latency equal to the remainder of T0's timeslice.

Rather, I think we need to address the preemptive behavior for the case where a migratory task is on the cpu and a non-migratory task tries to wake up.  If they are equal in numerical priority, perhaps we need to treat "non-migratory" as the tie breaker.  In this case, T1 would preempt T0 from cpu1, and then we would push T0 to cpu0.  I don't quite have all the details about how this would work thought through yet.  Perhaps I should wait until my fever lifts. ;)  Thoughts?

-Greg



