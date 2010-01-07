Return-Path: <linux-kernel-owner+w=401wt.eu-S1753303Ab0AGQqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303Ab0AGQqn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 11:46:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753223Ab0AGQqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 11:46:42 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:56458 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753193Ab0AGQqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 11:46:40 -0500
Date: Thu, 7 Jan 2010 08:46:36 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
	barrier
Message-ID: <20100107164636.GC6764@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100107044007.GA22863@Krystal> <20100107052851.GA12419@feather> <20100107060439.GB25786@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100107060439.GB25786@Krystal>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 07, 2010 at 01:04:39AM -0500, Mathieu Desnoyers wrote:
> * Josh Triplett (josh@joshtriplett.org) wrote:
> > On Wed, Jan 06, 2010 at 11:40:07PM -0500, Mathieu Desnoyers wrote:

[ . . . ]

> > - Have you tested what happens if a process does "while(1)
> >   membarrier();"?  By running on every CPU, including those not owned by
> >   the current process, this has the potential to make DoS easier,
> >   particularly on systems with many CPUs.  That gets even worse if a
> >   process forks multiple threads running that same loop.  Also consider
> >   that executing an IPI will do work even on a CPU currently running a
> >   real-time task.
> 
> Just tried it with a 10,000,000 iterations loop.
> 
> The thread doing the system call loop takes 2.0% of user time, 98% of
> system time. All other cpus are nearly 100.0% idle. Just to give a bit
> more info about my test setup, I also have a thread sitting on a CPU
> busy-waiting for the loop to complete. This thread takes 97.7% user
> time (but it really is just there to make sure we are indeed doing the
> IPIs, not skipping it through the thread_group_empty(current) test). If
> I remove this thread, the execution time of the test program shrinks
> from 32 seconds down to 1.9 seconds. So yes, the IPI is actually
> executed in the first place, because removing the extra thread
> accelerates the loop tremendously. I used a 8-core Xeon to test.

So a singled-threaded DoS attack can give you a 17-to-1 slowdown on
other processors.

Does this get worse if more than one CPU is in a tight loop doing
sys_membarrier()?  Or is there some other limit on IPI rate?

> > - Rather than groveling through runqueues, could you somehow remotely
> >   check the value of current?  In theory, a race in doing so wouldn't
> >   matter; finding something other than the current process should mean
> >   you don't need to do a barrier, and finding the current process means
> >   you might need to do a barrier.
> 
> Well, the thing is that sending an IPI to all processors can be done
> very efficiently on a lot of architectures because it uses an IPI
> broadcast. If we have to select a few processors to which we send the
> signal individually, I fear that the solution will scale poorly on
> systems where cpus are densely used by threads belonging to the current
> process.
> 
> So if we go down the route of sending an IPI broadcast as I did, then
> the performance improvement of skipping the smp_mb() for some CPU seems
> insignificant compared to the IPI. In addition, it would require to add
> some preparation code and exchange cache-lines (containing the process
> ID), which would actually slow down the non-parallel portion of the
> system call (to accelerate the parallelizable portion on only some of
> the CPUs).
> 
> So I don't think this would buy us anything. However, if we would have a
> per-process count of the number of threads in the thread group, then
> we could switch to a per-cpu IPI rather than broadcast if we detect that
> we have much fewer threads than CPUs.

My concern would be that we see an old value of the remote CPU's current,
and incorrectly fail to send an IPI.  Then that CPU might have picked
up a reference to the thing that we are trying to free up, which is just
not going to be good!

> > - Part of me thinks this ought to become slightly more general, and just
> >   deliver a signal that the receiving thread could handle as it likes.
> >   However, that would certainly prove more expensive than this, and I
> >   don't know that the generality would buy anything.
> 
> A general scheme would have to call every threads, even those which are
> not running. In the case of this system call, this is a particular case
> where we can forget about non-running threads, because the memory
> barrier is implied by the scheduler activity that brought them offline.
> So I really don't see how we can use this IPI scheme for other things
> that this kind of synchronization.

						Thanx, Paul

> > - Could you somehow register reader threads with the kernel, in a way
> >   that makes them easy to detect remotely?
> 
> There are two ways I figure out we could do this. One would imply adding
> extra shared data between kernel and userspace (which I'd like to avoid,
> to keep coupling low). The other alternative would be to add per
> task_struct information about this, and new system calls. The added per
> task_struct information would use up cache lines (which are very
> important, especially in the task_struct) and the added system call at
> rcu_read_lock/unlock() would simply kill performance.
> 
> Thanks,
> 
> Mathieu
> 
> > 
> > 
> > - Josh Triplett
> 
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
