Return-Path: <linux-kernel-owner+w=401wt.eu-S1752647AbXJVN4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647AbXJVN4p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 09:56:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751483AbXJVN4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 09:56:38 -0400
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:55876 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbXJVN4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 09:56:37 -0400
Subject: Re: [patch 6/8] pull RT tasks
From: Steven Rostedt <rostedt@goodmis.org>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <b647ffbd0710210235tf487bb3x1ffe73161fe0c9f7@mail.gmail.com>
References: <20071019184254.456160632@goodmis.org>
	 <20071019184336.983272715@goodmis.org>
	 <b647ffbd0710210235tf487bb3x1ffe73161fe0c9f7@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 22 Oct 2007 09:55:38 -0400
Message-Id: <1193061338.1912.17.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Dmitry,

On Sun, 2007-10-21 at 11:35 +0200, Dmitry Adamushko wrote:
> Hi Steven,
> 
> > When a pull RT is initiated, all overloaded runqueues are examined for
> > a RT task that is higher in prio than the highest prio task queued on the
> > target runqueue. If another runqueue holds a RT task that is of higher
> > prio than the highest prio task on the target runqueue is found it is pulled
> > to the target runqueue.
> 
> I think, 2 things should be accomplished here :
> 
> (1) be sure to pull the _highest_ prio task ;
> 
> i.e. the _highest_ prio task amongst all runnable (but not running) RT
> tasks across all the run-queues which is capable of running on
> this_cpu ;
> 
> (2) don't pull more than 1 task at once.

I've thought about this, and played a little. The problem we have is
that we don't take locks when searching each run queue. So by the time
you got the "highest rq" to pull from, it may no longer be the highest.
So what do we do in that case? search again?

If we are lucky and pull the highest first, then we will not pull
another one. Since we are not comparing the rq prio to current, but to
the highest task on the current rq.  So once we pull a high prio task,
we only pull another one if we find a even higher prio task.

Yes, it's a little inefficient, and can cause shuffling of task around.
But these tasks haven't actually run yet, so it isn't too much harm. But
the benefit is that when we finish, we have the highest task that can
run on the runqueue.

> 
> that said, just pull the highest prio task and run it.
> 
> ---
> 
> why (2)? Just to avoid situations when tasks are being pulled/pushed
> back and forth between run-queues.
> 
> Let's say we have 4 cpu system:
> 
> 0:  task(10) , task(92)
> 1:  task(10), task(91)
> 2:  task(10), task(90)
> 3:  task(10)
> 
> when task(10) on cpu#3 is inactive, we pull task(92), task(91),
> task(90) and then run task(90)... in the mean time, some of cpu[0..2]
> becomes inactive and pull task(91) and task(92) back and run them...
> that may repeat again and again depending on when/how long task(10)
> run on their corresponding cpus...

I'm not sure that's too much of an issue, since we are just switch tasks
on lists. As long has they haven't run yet, then it shouldn't be too
much harm. We do have a little bit of cache hits in the queues
themselves, but alternatives to fix this would probably cause the same
effects.

> 
> so it seems to me that the more optimal behavior would be "don't pull
> more than you can run at the moment -- that's 1".
> 
> to this goal, something like find_lock_highest_rq() would be necessary.

The problem is that we have too many races to find the highest rq at the
moment. But by pulling the highest at the time, we should end up with
what we want.

> 
> and I guess, {get,put}_task_struct() should be used in pull_rt_task()
> for the 'next' in a similar way as it's done in push_rt_task() .

No, we don't need to do the get task on pull. With push, we start with a
task and we want to push it somewhere. On the double_lock_balance, we
might lose our rq lock. Which means that next could have been put on
another run queue, run to completion, and then exited destroying the
task. We still reference that task after the double_lock_balance, and if
it is not active anymore, we finish the push.

With the pull, we are focusing on the run queue. If we had to release
the rq lock on double_lock_balance, we just pick the highest "next" on
the current run queue (which could have changed) and take the current
task on the src rq, which also could have changed. If the current task
on the src rq is higher in priority we move it over to the dst rq. So no
get/put_task_struct is needed.

-- Steve


