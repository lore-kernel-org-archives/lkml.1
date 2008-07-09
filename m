Return-Path: <linux-kernel-owner+w=401wt.eu-S1757189AbYGIMBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189AbYGIMBP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 08:01:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751961AbYGIMA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 08:00:59 -0400
Received: from sinclair.provo.novell.com ([137.65.248.137]:20264 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbYGIMA6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 08:00:58 -0400
Message-Id: <48746E8E.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Wed, 09 Jul 2008 05:53:50 -0600
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Nick Piggin" <nickpiggin@yahoo.com.au>
Cc: <mingo@elte.hu>, <rostedt@goodmis.org>, <peterz@infradead.org>,
       <npiggin@suse.de>, <linux-kernel@vger.kernel.org>,
       <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH 2/3] sched: terminate newidle balancing once at
	least one task has moved over
References: <20080627202444.3829.21595.stgit@lsg.lsg.lab.novell.com>
 <200807091809.52293.nickpiggin@yahoo.com.au>
 <48746084.BA47.005A.0@novell.com>
 <200807092117.01669.nickpiggin@yahoo.com.au>
In-Reply-To: <200807092117.01669.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On Wed, Jul 9, 2008 at  7:17 AM, in message
<200807092117.01669.nickpiggin@yahoo.com.au>, Nick Piggin
<nickpiggin@yahoo.com.au> wrote: 
> On Wednesday 09 July 2008 20:53, Gregory Haskins wrote:
>> >>> On Wed, Jul 9, 2008 at  4:09 AM, in message
>>
>> <200807091809.52293.nickpiggin@yahoo.com.au>, Nick Piggin
>>
>> <nickpiggin@yahoo.com.au> wrote:
>> > On Tuesday 08 July 2008 22:37, Gregory Haskins wrote:
>> >> >>> On Tue, Jul 8, 2008 at  1:00 AM, in message
>> >>
>> >> <200807081500.18245.nickpiggin@yahoo.com.au>, Nick Piggin
>> >>
>> >> <nickpiggin@yahoo.com.au> wrote:
>> >> > On Saturday 28 June 2008 06:29, Gregory Haskins wrote:
>> >> >> Inspired by Peter Zijlstra.
>> >> >>
>> >> >> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
>> >> >
>> >> > What happened to the feedback I sent about this?
>> >> >
>> >> > It is still nack from me.
>> >>
>> >> Ah yes.  Slipped through the cracks...sorry about that.
>> >>
>> >> What if we did "if (idle == CPU_NEWLY_IDLE && need_resched())" instead?
>> >
>> > Isn't that exactly the same thing
>>
>> Not quite.  The former version would break on *any* succesful enqueue (as a
>> result of a local move_task as well as a remote wake-up/migration).  The
>> latter version will only break on the the remote variety.  You were
>> concerned about stopping a move_task operation early because it would
>> reduce efficiency, and I do not entirely disagree. However, this really
>> only concerns the local type (which have now been removed).
>>
>> Remote preemptions should (IMO) always break immediately because it would
>> have been likely to invalidate the f_b_g() calculation anyway, and
>> low-latency requirements dictate its the right thing to do.
> 
> I thought this was about newidle balancing? Tasks are always going to
> be coming from remote runqueues, aren't they?

Yes, but you misunderstand me.  I am referring to "push" (remote moves to us) verses
"pull" (we move from remote).  During a move_task() we sometimes have to drop the
RQ lock in the double_lock balance.  This gives a remote CPU a chance to grab the lock
and potentially move tasks to us as part of either a migration operation, or a wake-up.

When this happens, several things should be noted:  1) it will change the load "landscape"
such that any previous computation in f_b_g() is potentially invalid.  2) The task that was
moved may be higher priority and therefore should not have to wait for move_tasks() to
finish moving some arbitrary number of lower-priority tasks (and note that "lower prio"
is a high-probability since NEWIDLE only does CFS tasks, and only RT tasks typically
migrate like this).

Therefore, IMO it doesnt make sense to continue moving more load.  Just stop and let the
scheduler sort it out.  At the very least it needs to recompute how much load to move.

> 
> 
>> > because any task will preempt the idle thread?
>>
>> During NEWIDLE this is a preempt-disabled section because we are still in
>> the middle of a schedule(). Therefore there will be no involuntary
>> preemption and that is why we are concerned with making sure we check for
>> voluntary preemption.  The move_tasks() will run to completion without this
>> patch.  With this patch it will break the operation if someone tries to
>> preempt us.
> 
> Firstly, won't the act of pulling tasks set the need_resched condition?

Hmm.. Indeed.   You are probably right about that and I need some other way to indicate
that a task was pushed to us over anything we might have pulled.

> 
> Secondly, even if it does what you say, what exactly would be the difference
> between blocking a newly moved task from running and blocking a newly woken
> task from running? Either way you introduce the same worst case latency
> condition.

Tasks that are pushed to us have a good chance to be RT (since RT is a heavy user of 
"push" methods, while CFS is mostly pull).  Conversely, tasks that are pulled to us by
newidle are guaranteed *not* to be RT (since newidle balancing will only pull CFS tasks).

Perhaps that is the answer: terminate on s/need_resched()/rq->rt.nr_running.  Its not
exactly scalable to an arbitrary arrangement of future sched_classes, but that could be
addresses when those sched_classes become available.

To be fair, I think this is what Peter was trying to do with his more elaborate version of
patches that I based this one on.

> 
> 
>> I'll keep an open mind but I am pretty sure this is something we should be
>> doing. As far as I can tell, there should be no downside with this second
>> version. 
> 
> I don't think it has really been thought through that well. So I'm still
> against it.
> 
>> As a compromise we could put an #ifdef CONFIG_PREEMPT around this 
>> new logic, but I don't think it is strictly necessary.
> 
> That's not very nice. It's reasonable to run with CONFIG_PREEMPT but not
> blindly want to trade latency for throughput.

How do you come to this conclusion?  Continuing to perform a move under these
circumstances (or at least, my intended circumstances) is against stale data and
could just as well hurt throughput as much as help it.  Since the move is
essentially arbitrary once this threshold is crossed, even the throughput will
become non-deterministic ;)

Regards,
-Greg


