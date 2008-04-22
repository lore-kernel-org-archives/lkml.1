Return-Path: <linux-kernel-owner+w=401wt.eu-S1763799AbYDVPvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763799AbYDVPvr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 11:51:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754599AbYDVPvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 11:51:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:37438 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753757AbYDVPvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 11:51:38 -0400
Date: Tue, 22 Apr 2008 11:51:35 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
cc: Gregory Haskins <ghaskins@novell.com>, mingo@elte.hu,
       suresh.b.siddha@intel.com, chinang.ma@intel.com, arjan@linux.intel.com,
       willy@linux.intel.com, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: Re: [PATCH 1/2] sched: push rt tasks only if newly activated tasks
 have been added
In-Reply-To: <b647ffbd0804220830h6524e788n1467b027bc5bc4d2@mail.gmail.com>
Message-ID: <Pine.LNX.4.58.0804221144410.21511@gandalf.stny.rr.com>
References: <20080421180747.4560.67794.stgit@novell1.haskins.net> 
 <20080421181015.4560.7658.stgit@novell1.haskins.net>
 <b647ffbd0804220830h6524e788n1467b027bc5bc4d2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Dmitry,

Did you see this behaviour or is this an analysis of the code?

On Tue, 22 Apr 2008, Dmitry Adamushko wrote:
>
> consider the following 2-cpu system: cpu0 and cpu1.
>
> cpu0: is idle --> in such a state, it never pulls RT tasks on its own.
>
> T0 and T1 are RT tasks

This is the important part. How did cpu0 get to "is idle --> in such a
state, it never pulls RT tasks on its own" ? And then have cpu1 have T0
and T1 running.

When ever a cpu goes to idle, it should definitely try to do a RT pull
before going idle. When a


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

Ah, this may be what you are talking about. T0 was running, but because
T1 has its affinity set to cpu1 it wont cause a push. When T0 schedules
away to give T1 its cpu time, T0 wont push away because of the pushed
flag.

Hmm, interesting. Of course my response is "Don't use SCHED_RR! It's
evil!" ;-)

Perhaps we need logic to reset the push flag when a sched RR task is
scheduled out to give way for another SCHED_RR task. This should fix this
scenario. Unless I'm missing something else.

-- Steve

> [ btw., (1) I'd expect that this task_wake_up_rt() thing should be
> redundant, logically-wise... I'll check once more and comment later
> on.
> (2) any example when (p->prio >= rq->rt.highest_prio) is not true in
> task_wake_up_rt() ?
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
>
>
> --
> Best regards,
> Dmitry Adamushko
>
