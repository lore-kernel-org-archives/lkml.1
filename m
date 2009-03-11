Return-Path: <linux-kernel-owner+w=401wt.eu-S1756235AbZCKMNK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235AbZCKMNK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 08:13:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755457AbZCKMMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 08:12:54 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52590 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756182AbZCKMMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 08:12:52 -0400
Date: Wed, 11 Mar 2009 13:12:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: prasad@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [patch 02/11] x86 architecture implementation of Hardware
	Breakpoint interfaces
Message-ID: <20090311121220.GI2282@elte.hu>
References: <20090310172605.GA28767@elte.hu> <Pine.LNX.4.44L0.0903101620390.4325-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0903101620390.4325-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Stern <stern@rowland.harvard.edu> wrote:

> On Tue, 10 Mar 2009, Ingo Molnar wrote:
> 
> > > More generally, it's there because kernel & userspace 
> > > breakpoints can be installed and uninstalled while a task is 
> > > running -- and yes, this is partially because breakpoints are 
> > > prioritized.  (Although it's worth pointing out that even your 
> > > suggestion of always prioritizing kernel breakpoints above 
> > > userspace breakpoints would have the same effect.)  However 
> > > the fact that the breakpoints are stored in a list rather than 
> > > an array doesn't seem to be relevant.
> > > 
> > > > A list needs to be maintained and when updated it's 
> > > > reloaded.
> > > 
> > > The same is true of an array.
> > 
> > Not if what we do what the previous code did: reloaded the full 
> > array unconditionally. (it's just 4 entries)
> 
> But that array still has to be set up somehow.  It is private 
> to the task; the only logical place to set it up is when the 
> CPU switches to that task.
> 
> In the old code, it wasn't possible for task B or the kernel 
> to affect the contents of task A's debug registers.  With 
> hw-breakpoints it _is_ possible, because the balance between 
> debug registers allocated to kernel breakpoints and debug 
> registers allocated to userspace breakpoints can change.  
> That's why the additional complexity is needed.

Yes - but we dont really need any scheduler complexity for this.

An IPI is enough to reload debug registers in an affected task 
(and calculate the real debug register layout) - and the next 
context switches will pick up changes automatically.

Am i missing anything? I'm trying to find the design that has 
the minimal possible complexity. (without killing any necessary 
features)

> > > Yes, kernel breakpoints have to be kept separate from 
> > > userspace breakpoints.  But even if you focus just on 
> > > userspace breakpoints, you still need to use a list 
> > > because debuggers can try to register an arbitrarily large 
> > > number of breakpoints.
> > 
> > That 'arbitrarily large number of breakpoints' worries me. 
> > It's a pretty broken concept for a 4-items resource that 
> > cannot be time-shared and hence cannot be overcommitted.
> 
> Suppose we never allow callers to register more breakpoints 
> than will fit in the CPU's registers.  Do we then use a simple 
> first-come first-served algorithm, with no prioritization?  If 
> we do prioritize some breakpoint registrations more highly 
> than others, how do we inform callers that their breakpoint 
> has been kicked out by one of higher priority?  And how do we 
> let them know when the higher-priority breakpoint has been 
> unregistered, so they can try again?

For an un-shareable resource like this (and this is really a 
rare case [and we shouldnt even consider switching between user 
and kernel debug registers at system call time]), the best 
approach is to have a rigid reservation mechanism with clear, 
hard, early failures in the overcommit case.

Silently breaking a user-space debugging sessions just because 
the admin has a debug register based system-wide profiling 
running, is pretty much the worst usage model. It does not give 
user-space any idea about what happened - the breakpoints just 
"dont work".

So i'd suggest a really simple scheme (depicted for x86 bug 
applicable on other architectures too):

 - we have a system-wide resource of 4 debug registers.

 - kernel-side can allocate debug registers system-wide (it 
   takes effect on all CPUs, at once), up to 4 of them. The 5th 
   allocation will fail.

 - user-side uses the ptrace APIs - and if it runs into the 
   limit, ptrace should return a failure.

There's the following special case: the kernel reserves a debug 
register when there's tasks in the system that already have 
reserved all debug registers. I.e. the constraint was not known 
when the user-space session started, and the kernel violates it 
afterwards.

There's a couple of choices here, with various scales of 
conflict resolution:

 1- silently override the user-space breakpoint

 2- notify the user-space task via a signal - SIGXCPU or so.

 3- reject the kernel-space allocation with a sufficiently 
    informative log message: "task 123 already uses 4 debug 
    registers, cannot allocate more kernel breakpoints" - 
    leaving the resolution of the conflict to the admin.

#1 isnt particularly good because it brings back a
   'silentfailure' mode.

#2 might be too brutal: starting something innocous-looking
   might kill a debug session. OTOH user-space debuggers could 
   catch the signal and inform the user.

#3 is probably the most informative (and hence probably the
   best) variant. It also leaves policy of how to resolve the 
   conflict to the admin.

> > Seems to me that much of the complexity of this patchset:
> > 
> >  28 files changed, 2439 insertions(+), 199 deletions(-)
> > 
> > Could be eliminated via a very simple exclusive reservation 
> > mechanism.
> 
> Can it really be as simple as all that?

Would be nice to have it simple. Reluctance regarding this 
patchset is mostly rooted in that diffstat above.

The changes it does in the x86 architecture code are nice 
generalizations and cleanups. Both the scheduler, task 
startup/exit and ptrace bits look pretty sane in terms of 
factoring out debug register details. But the breakpoint 
management looks very complex.

	Ingo
