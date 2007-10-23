Return-Path: <linux-kernel-owner+w=401wt.eu-S1754035AbXJWBRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035AbXJWBRV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 21:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753228AbXJWBRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 21:17:12 -0400
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:38305 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790AbXJWBRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 21:17:10 -0400
Date: Mon, 22 Oct 2007 21:16:10 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch 6/8] pull RT tasks
In-Reply-To: <b647ffbd0710221534h7c3e7da8g3311c39c10cb341c@mail.gmail.com>
Message-ID: <Pine.LNX.4.58.0710222107140.19457@gandalf.stny.rr.com>
References: <20071019184254.456160632@goodmis.org>  <20071019184336.983272715@goodmis.org>
  <b647ffbd0710210459y6116e85ek3d6feba6ec98231@mail.gmail.com> 
 <1193061928.1912.26.camel@localhost.localdomain>
 <b647ffbd0710221534h7c3e7da8g3311c39c10cb341c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--
On Tue, 23 Oct 2007, Dmitry Adamushko wrote:

> Hi Steven,
>
> agreed with your comments in the previous message. Indeed, I missed some points.
>
> > On wakeup, we can wake up several RT tasks (as my test case does) and if
> > we only push one task, then the other tasks may not migrate over to the
> > other run queues. I logged this happening in my tests.
>
> I guess, what may happen is that while we are running push_rt_tasks()
> on CPU-k (say, as a result on try_to_wake_up(task_1))
> and as this_rq->lock may get released (in double_lock_balance()) , we
> may get in a 'race'
> with try_to_wake_up(task_2) from (another) CPU-m.
> It places a woken up task on the same run-queue (for which
> push_rt_task() is already running on CPU-k) and, actually, run
> push_rt_task() for the same rq again!
>
> So it may happen that both task_1 and task_2 will be pushed from the same CPU...
>
> Do you see an error in my description? (it's a late hour so I can miss
> something again ... sure, otherwise I'm almost perfect :-/ ) Can it
> correlate with what you have observed in your tests?
>
> Otherwise, there is 1:1 relation : push_rt_task() is called for every
> new (single) task activated by try_to_wake_up() and for a preempted
> task... so it's not like a few tasks are placed on the run-queue and
> then push_rt_tasks() is called once.
>
> btw., if this scenario may take place... maybe it would make sense to
> have something like RTLB_INPROGRESS/PENDING and to avoid competing
> push_rt_tasks() calls for the same 'rq' from different CPUs?
> (although, there can be some disadvantages here as well. e.g. we would
> likely need to remove 'max 3 tasks at once' limit and get,
> theoretically, unbounded time spent in push_rt_tasks() on a single
> CPU).

I think I see what you're saying now. That we really should do the push on
wakeup, since only the one rt task that is woken up will be able to be
pushed.

My code may seem a bit aggressive, but from logging, I see that we seldom
push more than one task. But if we don't go ahead and push more than one,
the rt-migrate-test will sometimes fail.  There's funny cases when we need
to push more than one. I can't remember exactly what they were, but
sometimes because of races between the pushes and pulls where one will
miss the fact that an RT process is being queued while its searching to
pull a task, but the push will catch it. Or vice versa.

The max tries is just a paranoid case where I don't want heavy scheduling
to cause an unbounded trying to push or pull tasks. According to the
logging while running the rt-migrate-tests, the loop there repeated
approximately 1 in 20, and iterated twice 1 in 100 and hit the third loop
twice in all my tests (over a 1000 iterations being logged). But logging
slows it down and modifies the results itself, and perhaps I'll add
statistics soon.

I'm about to post a second batch of patches.

Thanks,

-- Steve

