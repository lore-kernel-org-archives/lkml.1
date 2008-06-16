Return-Path: <linux-kernel-owner+w=401wt.eu-S1756018AbYFPO0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018AbYFPO0h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 10:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753660AbYFPO03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 10:26:29 -0400
Received: from sinclair.provo.novell.com ([137.65.248.137]:27816 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609AbYFPO02 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 10:26:28 -0400
Message-Id: <48563FDB.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Mon, 16 Jun 2008 08:26:35 -0600
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Steven Rostedt" <rostedt@goodmis.org>,
       "Thomas Gleixner" <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [sched-devel, patch-rfc] rework of "prioritize
	non-migratable tasks over migratable ones"
References: <1213138710.26530.51.camel@earth>
 <1213174382.31518.69.camel@twins>
 <b647ffbd0806110305p2be38608iadc1d2e91e3be57a@mail.gmail.com>
In-Reply-To: <b647ffbd0806110305p2be38608iadc1d2e91e3be57a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,
  Just catching up on mail.  I haven't had a chance to review your patch, so I am only responding to the comments in this thread.

>>> On Wed, Jun 11, 2008 at  6:05 AM, in message
<b647ffbd0806110305p2be38608iadc1d2e91e3be57a@mail.gmail.com>, "Dmitry
Adamushko" <dmitry.adamushko@gmail.com> wrote: 
> 2008/6/11 Peter Zijlstra <a.p.zijlstra@chello.nl>:
>> On Wed, 2008-06-11 at 00:58 +0200, Dmitry Adamushko wrote:
>>> Hi Gregory,
>>>
>>>
>>> regarding this commit: 45c01e824991b2dd0a332e19efc4901acb31209f
>>>
>>>
>>> I think we can do it simpler. Please take a look at the patch below.
>>>
>>> Instead of having 2 separate arrays (which is + ~800 bytes on x86_32 and 
> twice so on x86_64),
>>> let's add "exclusive" (the ones that are bound to this CPU) tasks to the 
> head of the queue
>>> and "shared" ones -- to the end.
>>>
>>> In case of a few newly woken up "exclusive" tasks, they are 'stacked' (not 
> queued as now), meaning that
>>> a task {i+1} is being placed in front of the previously woken up task {i}. 
> But I don't think that
>>> this behavior may cause any realistic problems.
>>
>> Doesn't this violate POSIX ?
>>
> 
> If so, then the idea of "prioritize non-migratable tasks over
> migratable ones" violates it, not just an artefact of this particular
> implementation.

This isn't entirely accurate though.  Your proposal does alter the behavior from the original patch.  In fact, I put in the xqueue/squeue concept specifically to *avoid* the condition that you are creating.  I think this was the point Peter was making.

However, to your point: I can agree that either implementation creates the possibility for creating strange scheduling artifacts.  And I think the point you are making is that once we have the artifact, whats another one? ;)


> 
> No matter which implementation is used, we have a situation when a
> woken-up single-CPU-bound task (let's call it 'p') can preempt a
> current task with effects as follows:
> 
> - 'current' is not guaranteed to get another CPU;

Right.  I admit this is one of the sticking points that has potential for creating artifacts.  [1] The downside is there is no real way to avoid this.  You can't atomically guarantee a position on another core until current has been preempted.  So its always going to be a best-effort assessment of the state of the system prior to the preemption.  Not ideal.

Fortunately, this is all w.r.t. equal prio tasks.  And as you state below, if this was an issue the designer should have placed the tasks at different prios.  This fact is what led me to ultimately feel somewhat comfortable with the concept.  [2] A related issue is the potential to have an unbounded task be ping-ponged around (ehem) unbounded. ;)

> 
> - there might have been other pending tasks (of equal prio) on this
> queue. As a result, 'p' starts running before them violating currently
> used (explicitly requested by POSIX?) round-robin behavior.

Yes, except your patch also allows other bound tasks to preempt each other, which adds an additional artifact that is not present in mine nor is it strictly necessary.  [3] You could probably work around this by having the enqueue_task_rt() seek out the first non-bound task position and insert there, instead of HEAD.  In fact I had contemplated doing exactly that, but then decided the memory/speed tradeoff with the xqueue/squeue was better.  I am not against going the other way if the memory cost of the xqueue is too great.

> 
> Anyway, the original (and my rework) algorithm is somewhat
> sub-optimal. It considers only "p->rt.nr_cpus_allowed == 1", while the
> ideal algorithm would behave as follows:
> 
> 1) we get a newly woken-up task on CPU_i;
> 
> 2) this task have a number (!= 1) of allowed CPUs (which is a sub-set
> of all) _but_ all of them are busy at the moment serving high prio
> tasks;

I don't understand the significance of the stipulation that its a "sub-set of all".  Can you elaborate?  Or did you mean to say "it *may* be a sub-set of all"?

> 
> 3) there are no other pending tasks on the queue (of equal prio) that
> are in the same condition as 'p' (that's they can't be migrated to
> other CPUs at the moment and to wait for CPU_i is the 'best' effort
> for them);

Note that this is already accounted for with xqueue/squeue, or with my proposed modifications [3] above

> 
> 4) 'current' is guaranteed to start running immediatelly on another
> CPU (apparently, its affinity allows CPUs that can be used neither by
> 'p', nor by tasks from (3) ), should we preempt it now.

As per [1], we unfortunately can never guarantee this.

> 
> 5) then let 'p' preempt 'current'.

I think everything except your (4) is achieved in my patch, and could be in yours with the slight modification proposed in [3].  So the real question is whether the lack of your point (4) or the issue I mentioned in [2] is acceptable or not.

> 
> We do cause some 'troubles' (in a way of 'cache' efficienty) for the
> 'current' but probably we win CPU-time-distribution-wise.

True, but this in essence is what load-balancing is all about.

> 
> Note, hard real-time tasks would not like to find themselves in the
> aforemnetioned situation. But then, one probably should have initially
> taken care of assigning different prios or better off, isolating
> dedicated CPUs for some tasks wrt how much CPU-time they
> consume/latency they expect.

Right.  The key is that bets are off when considering equal-prio tasks.  Wake-up order, etc, can create similar concerns.  That is what lets this concept be at least semi acceptable.

> 
> 
> All in all, I think that the initial implementation is sub-optimal

Ouch :)

> in
> any case and it's not worth introducing additional overhead (another
> priority queue array) to address this issue (which is kind of a corner
> case).
> 
> We may just consider dropping this idea completely.
> (my 0.02$)

And based on all this (and as I previously stated) I agree with your assessment that perhaps we should just drop this concept outright.

Regards,
-Greg


