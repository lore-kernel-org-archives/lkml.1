Return-Path: <linux-kernel-owner+w=401wt.eu-S1753162AbXJWNo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162AbXJWNo0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 09:44:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751949AbXJWNoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 09:44:18 -0400
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:47914 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbXJWNoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 09:44:17 -0400
Date: Tue, 23 Oct 2007 09:43:54 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Paul Menage <menage@google.com>
cc: Paul Jackson <pj@sgi.com>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, mingo@elte.hu, dmitry.adamushko@gmail.com,
       ghaskins@novell.com, a.p.zijlstra@chello.nl
Subject: Re: [PATCH -v2 4/7] RT overloaded runqueues accounting
In-Reply-To: <6599ad830710222311x402c3d1agcc458742fb5e219c@mail.gmail.com>
Message-ID: <Pine.LNX.4.58.0710230844040.29506@gandalf.stny.rr.com>
References: <20071023025900.927578809@goodmis.org>  <20071023032916.651749224@goodmis.org>
  <20071022211709.7be79fea.pj@sgi.com> <6599ad830710222311x402c3d1agcc458742fb5e219c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--
On Mon, 22 Oct 2007, Paul Menage wrote:

> On 10/22/07, Paul Jackson <pj@sgi.com> wrote:
> > Steven wrote:
> > > +void cpuset_rt_set_overload(struct task_struct *tsk, int cpu)
> > > +{
> > > +     cpu_set(cpu, task_cs(tsk)->rt_overload);
> > > +}
> >
> > Question for Steven:
> >
> >   What locks are held when cpuset_rt_set_overload() is called?

Right now only the rq lock. I know it's not enough. This needs to be
fixed. These are called in the heart of the scheduler so...

> >
> > Questions for Paul Menage:
> >
> >   Does 'tsk' need to be locked for the above task_cs() call?
>
> Cgroups doesn't change the locking rules for accessing a cpuset from a
> task - you have to have one of:
>
> - task_lock(task)

I'm not sure of the lock nesting between task_lock(task) and rq->lock.
If this nesting doesn't yet exist, then I can add code to do the
task_lock.  But if the rq->lock is called within the task_lock somewhere,
then this can't be used.

>
> - callback_mutex

Can schedule, so it's definitely out.

>
> - be in an RCU section from the point when you call task_cs to the
> point when you stop using its result. (Additionally, in this case
> there's no guarantee that the task stays in this cpuset for the
> duration of the RCU section).

This may also be an option. Although with interrupts disabled for the
entire time the cpusets are used should keep RCU grace periods from moving
forward.

But let me give you two some background to what I'm trying to solve. And
then I'll get to where cpusets come in.

Currently the mainline vanilla kernel does not handle migrating RT tasks
well. And this problem also exists (but not as badly) in the -rt patch.
When a RT task is queued on a CPU that is running an even higher priority
RT task, it should be pushed off to another CPU that is running a lower
priority task. But this does not always happen and a RT task may take
several milliseconds before it gets a chance to run.

This latancy is not acceptible for RT tasks. So I added logic to push and
pull RT tasks to and from CPUS.  The push happens when a RT task wakes up
and can't preempt the RT task running on the same CPU, or when a lower RT
task is preempted by a higher one. The lower may be pushed to another CPU.

This alone is not enough to cover RT migration. We also need to pull RT
tasks to a CPU if that CPU is lowering its priority (a high priority RT
task has just went to sleep).

Idealy, and when CONFIG_CPUSETS is not defined, I keep track of all CPUS
that have more than one RT task queued to run on it.  This I call an RT
overload.  There's an RT overload bitmask that keeps track of the CPUS
that have more than one RT task queued.  When a CPU stops running a high
priority RT task, a search is made of all the CPUS that are in the RT
overload state to see if there exists a RT task that can migrate to the
CPU that is lowering its priority.

Ingo Molnar and Peter Zijlstra pointed out to me that this global cpumask
would kill performance on >64 CPU boxes due to cacheline bouncing. To
solve this issue, I placed the RT overload mask into the cpusets.

Ideally, the RT overload mask would keep track of all CPUS that have tasks
that can run on a given CPU. In-other-words, a cpuset from the point of
view of the CPU (or runqueue).  But this is overkill for the RT migration
code.  Large # CPU boxes probably don't have the RT balancing problems
that small # CPU boxes have, since the CPU resource is greater to run RT
tasks on.

Using cpusets seemed to be a nice place to add functionality to keep the
RT overload code from crippling large # CPU boxes.

The RT overload mask is bound to the CPU (runqueue) and not to the task.
But to get to the cpuset, I needed to go through the task. The task I used
was whatever was currently running on the given CPU, or sometimes the task
that was being pushed to a CPU.

Due to overlapping cpusets, there can be inconsistencies between the RT
overload mask and actual CPUS that are in the overload state. This is
tolerated, as the more CPUS you have, the less of a problem it should be
to have overloaded CPUS. Remember, the push task doesn't use the overload.
Only the pull does, and that happens when a push didn't succeed. With more
CPUS, pushes are more likely to succeed.

So the switch to use cpusets was to keep the RT balancing code from
hurting large SMP boxes than for actually being correct on those boxes.
The RT balance is much more important when the CPU resource is limited.
The cpusets were picked just because it seemed resonable that most of the
time a cpuset of one task on a runqueue would equal that of another task
on the same runqueue. But the code is "good enough" if that's not the
case.

My code can handle inconsistencies between the RT overload mask and actual
overloaded CPUS. So what I need to really protect with regards to cpusets
is from them disappearing and causing an oops.  Whether or not a task
comes and goes from a cpuset is not the important part.  The RT balance
code only uses the cpuset to determine what other RT tasks are out there
that can be brought to a given CPU.

Sorry for this long explanation, but I was hoping to get some advice from
those that have access to large SMP boxes, and have a vested interest that
enhancements to the scheduling does not hurt performance for those boxes.

Thoughts?

Thanks,

-- Steve
