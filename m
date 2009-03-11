Return-Path: <linux-kernel-owner+w=401wt.eu-S1753745AbZCKRli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745AbZCKRli (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 13:41:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbZCKRl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 13:41:29 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:41532 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbZCKRl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 13:41:28 -0400
Date: Wed, 11 Mar 2009 23:11:15 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [patch 02/11] x86 architecture implementation of Hardware
	Breakpoint interfaces
Message-ID: <20090311174115.GD9547@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20090311121220.GI2282@elte.hu> <Pine.LNX.4.44L0.0903111151580.2692-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0903111151580.2692-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 12:32:19PM -0400, Alan Stern wrote:
> On Wed, 11 Mar 2009, Ingo Molnar wrote:
> 
> > > > Not if what we do what the previous code did: reloaded the full 
> > > > array unconditionally. (it's just 4 entries)
> > > 
> > > But that array still has to be set up somehow.  It is private 
> > > to the task; the only logical place to set it up is when the 
> > > CPU switches to that task.
> > > 
> > > In the old code, it wasn't possible for task B or the kernel 
> > > to affect the contents of task A's debug registers.  With 
> > > hw-breakpoints it _is_ possible, because the balance between 
> > > debug registers allocated to kernel breakpoints and debug 
> > > registers allocated to userspace breakpoints can change.  
> > > That's why the additional complexity is needed.
> > 
> > Yes - but we dont really need any scheduler complexity for this.
> > 
> > An IPI is enough to reload debug registers in an affected task 
> > (and calculate the real debug register layout) - and the next 
> > context switches will pick up changes automatically.
> > 
> > Am i missing anything? I'm trying to find the design that has 
> > the minimal possible complexity. (without killing any necessary 
> > features)
> 
> I think you _are_ missing something, though it's not clear what.
> 
> "and the next context switches will pick up changes automatically" --
> that may not be entirely right.  Yes, the next context switch will pick
> up the changes to DR1-4, but it won't necessarily pick up the changes
> to DR7.  However the details depend very much on how debug registers
> are allocated; with no priorities or evictions much of the complexity
> will disappear anyway.
> 
> > For an un-shareable resource like this (and this is really a 
> > rare case [and we shouldnt even consider switching between user 
> > and kernel debug registers at system call time]), the best 
> > approach is to have a rigid reservation mechanism with clear, 
> > hard, early failures in the overcommit case.
> > 
> > Silently breaking a user-space debugging sessions just because 
> > the admin has a debug register based system-wide profiling 
> > running, is pretty much the worst usage model. It does not give 
> > user-space any idea about what happened - the breakpoints just 
> > "dont work".
> > 
> > So i'd suggest a really simple scheme (depicted for x86 bug 
> > applicable on other architectures too):
> > 
> >  - we have a system-wide resource of 4 debug registers.
> > 
> >  - kernel-side can allocate debug registers system-wide (it 
> >    takes effect on all CPUs, at once), up to 4 of them. The 5th 
> >    allocation will fail.
> > 
> >  - user-side uses the ptrace APIs - and if it runs into the 
> >    limit, ptrace should return a failure.
> 
> Roland, of course, is all in favor of making hw-breakpoints compatible 
> with utrace.  The API should be flexible enough to encompass both 
> legacy ptrace and utrace.
> 
> > There's the following special case: the kernel reserves a debug 
> > register when there's tasks in the system that already have 
> > reserved all debug registers. I.e. the constraint was not known 
> > when the user-space session started, and the kernel violates it 
> > afterwards.
> 
> Right.  Or the kernel tries to allocate 2 debug registers when 
> userspace has already allocated 3, and so on...
> 
> > There's a couple of choices here, with various scales of 
> > conflict resolution:
> > 
> >  1- silently override the user-space breakpoint
> > 
> >  2- notify the user-space task via a signal - SIGXCPU or so.
> > 
> >  3- reject the kernel-space allocation with a sufficiently 
> >     informative log message: "task 123 already uses 4 debug 
> >     registers, cannot allocate more kernel breakpoints" - 
> >     leaving the resolution of the conflict to the admin.
> 
> We can't necessarily assign a particular task to the debug registers 
> already in use.  There might be more than one task using them.  But of 
> course we can always just say that they are already in use, and if 
> necessary there could be a /proc interface with more information.
> 
> Besides, we have to be able to reject kernel breakpoint requests in any
> case ("the 5th allocation will fail").
> 
> > #1 isnt particularly good because it brings back a
> >    'silentfailure' mode.
> 
> Agreed.
> 
> > #2 might be too brutal: starting something innocous-looking
> >    might kill a debug session. OTOH user-space debuggers could 
> >    catch the signal and inform the user.
> > 
> > #3 is probably the most informative (and hence probably the
> >    best) variant. It also leaves policy of how to resolve the 
> >    conflict to the admin.
> 
> AFAICS, #3 really is "first come, first served".  What do you mean by 
> "policy of how to resolve the conflict"?  It sounds like there are no 
> policy choices involved; whoever requests the debug register first will 
> get it.
>

With FCFS or an allocation mechanism without the (un)installed()
callbacks we'd lose the ability to record requests and service them
later when registers become availabile.

Say when (un)installed() callbacks are implemented for the proposed
ftrace-plugin to trace kernel symbols, they can automatically stop/start
tracing as and when registers become (un)available. This can be helpful when
we wish to profile memory access over a kernel variable for a long duration
(where small loss of tracing data can be tolerated), while the system would
permit simultaneous user-space access (say a GDB session using 'hbreak').

Are we fine with disallowing such usage, which if done will let the requester
of the breakpoint register 'poll' periodically to check availability.

Thanks,
K.Prasad

