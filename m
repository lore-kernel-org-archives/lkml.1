Return-Path: <linux-kernel-owner+w=401wt.eu-S1764677AbZAPMRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764677AbZAPMRU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 07:17:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752434AbZAPMRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 07:17:05 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35991 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835AbZAPMRD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 07:17:03 -0500
Date: Fri, 16 Jan 2009 13:16:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH] perf_counter: Add counter enable/disable ioctls
Message-ID: <20090116121651.GF20082@elte.hu>
References: <18800.25726.604410.232889@cargo.ozlabs.ibm.com> <20090116110703.GA18165@elte.hu> <18800.30380.277025.456930@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18800.30380.277025.456930@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0885]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Mackerras <paulus@samba.org> wrote:

> Ingo Molnar writes:
> 
> > Okay - please let me know when i can pull it - the extension of counter 
> > ops to the 'family' looks nice and desirable.
> 
> Thanks - I'll try to do some basic testing this weekend.  I won't get
> a chance to do any extensive testing for the next two weeks because
> I'll be on vacation.
> 
> > I'm wondering, should it also extend to all members of a group perhaps - 
> > or should that be separate ioctls?
> > 
> > It makes sense to individually enable/disable a single counter within a 
> > group - including the group leader. So i guess we need 3 variants:
> > 
> >  - disable/enable single counter
> >  - disable/enable group
> >  - disable/enable family
> > 
> > We might as well just offer a single variant initially: 'disable/enable 
> > everything that can be iterated from that counter', and provide more 
> > specialized variants only once the specific need arises?
> 
> Well, each member of a group has its own family.  I don't see any need
> to enable/disable the top-level (parent) counter separately from its
> children, but as you say, if the need arises we can add that.
> 
> We can enable/disable individual subsidiary group members (and their
> families) since we have an fd for each member.  We would only need
> separate 'single counter' and 'group' ioctls for the group leader, and
> once again we could add that if the need arises.
> 
> Currently the ioctls on the group leader disable/enable the whole group.  
> I'm not sure that enabling/disabling individual counters in the group 
> will really be all that useful, but I put it in for subsidiary counters 
> since it falls out pretty easily and naturally in the code.  If users 
> want to disable/enable each counter in a group individually, they could 
> add an extra dummy counter (say a cpu_clock counter) to be the group 
> leader and then just mostly ignore it.
> 
> So I think that boils down to saying that what I have implemented is the 
> single variant that you propose in your last quoted paragraph above. :)

Okay :-) I missed the detail that it iterates down groups as well, if done 
on the leader.

> > > I have to admit to a small element of cargo-cult programming in 
> > > __perf_counter_enable and __perf_counter_disable: I put calls to 
> > > curr_rq_lock_irq_save/restore in there because I was following the 
> > > model of __perf_install_in_context, but I don't know what they do 
> > > (beyond disabling/restoring interrupts) or why they are needed.  
> > > What are they there for?
> > 
> > That's an ugly detail: we can only observe and update the current task 
> > clock with the runqueue lock held. So right now the counter ops are 
> > structured so that we first take the rq lock (which implies irq 
> > disable as well), and then all sw counters can assume that the rq lock 
> > is held.
> 
> OK.  Is there any advantage of the task_clock over the cpu_clock? Could 
> we get rid of task_clock (and therefore remove the curr_rq_lock_* calls) 
> and just use the cpu_clock?

the cpu_clock() uses the rq lock just as much - it's the same basic 
scheduler time they are using.

We could drop the rq clock, but i found that the timec output gets a bit 
ugly that way, if used with multiple sw counters.

Instead of getting neat output like:

 $ timec -e -2,-2,-2,-2 ls

 [...]

  Performance counter stats for 'ls':

       2.830582  task clock ticks     (msecs)

       2.830582  task clock ticks     (msecs)
       2.830582  task clock ticks     (msecs)
       2.830582  task clock ticks     (msecs)
       2.830582  task clock ticks     (msecs)

  Wall-clock time elapsed:    46.353323 msecs

We get something like (mockup, from memory):

  Performance counter stats for 'ls':

       2.830431  task clock ticks     (msecs)

       2.830582  task clock ticks     (msecs)
       2.830613  task clock ticks     (msecs)
       2.830781  task clock ticks     (msecs)
       2.831100  task clock ticks     (msecs)

  Wall-clock time elapsed:    46.353323 msecs

As each individual counter is sampled differently.

But i'd like to drop the rq lock in any case - it's not really needed from 
a scheduling POV. Maybe we could take the current sched time once, save it 
and reuse that in the sw counters (instead of each sw counter taking that 
time individuall)?

> Also, since we know we're only taking differences between readings on 
> the same cpu, could we use sched_clock() instead of cpu_clock() to 
> reduce overhead?  (We certainly could on powerpc, since we have 
> synchronized timebase registers, but I know you don't have that luxury 
> on x86. :)

there's an evil plan behind my use of cpu_clock() / sum_exec_runtime: that 
way if the scheduler folks break those metrics the performance analysis 
folks immediately notify us of our stupidity ;-) It's also the metrics 
that 'top' and 'time' use - so it's a bit more natural to use - these 
things should work together and break together. The scheduler's deadline 
logic also uses this metric so there's synergy.

I think if we do the time-sampling approach i suggested above the locking 
and overhead problem disappears and we can just use cpu_clock() or 
sum_exec_runtime once, and use it from the sw counter(s)?

	Ingo
