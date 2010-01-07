Return-Path: <linux-kernel-owner+w=401wt.eu-S1751784Ab0AGRgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784Ab0AGRgr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 12:36:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751076Ab0AGRgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 12:36:47 -0500
Received: from tomts20.bellnexxia.net ([209.226.175.74]:59011 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750786Ab0AGRgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 12:36:46 -0500
Date: Thu, 7 Jan 2010 12:36:44 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <peterz@infradead.org>
Cc: paulmck@linux.vnet.ibm.com, Josh Triplett <josh@joshtriplett.org>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       tglx@linutronix.de, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       laijs@cn.fujitsu.com, dipankar@in.ibm.com
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
	barrier
Message-ID: <20100107173644.GB16027@Krystal>
References: <20100107044007.GA22863@Krystal> <1262842854.28171.3710.camel@gandalf.stny.rr.com> <20100107061955.GC25786@Krystal> <20100107063558.GC12939@feather> <1262853855.4049.86.camel@laptop> <20100107165249.GE6764@linux.vnet.ibm.com> <1262884716.4049.103.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1262884716.4049.103.camel@laptop>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 12:25:38 up 22 days,  1:44,  5 users,  load average: 0.42, 0.16,
	0.11
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Thu, 2010-01-07 at 08:52 -0800, Paul E. McKenney wrote:
> > On Thu, Jan 07, 2010 at 09:44:15AM +0100, Peter Zijlstra wrote:
> > > On Wed, 2010-01-06 at 22:35 -0800, Josh Triplett wrote:
> > > > 
> > > > The number of threads doesn't matter nearly as much as the number of
> > > > threads typically running at a time compared to the number of
> > > > processors.  Of course, we can't measure that as easily, but I don't
> > > > know that your proposed heuristic would approximate it well.
> > > 
> > > Quite agreed, and not disturbing RT tasks is even more important.
> > 
> > OK, so I stand un-Reviewed-by twice in one morning.  ;-)
> > 
> > > A simple:
> > > 
> > >   for_each_cpu(cpu, current->mm->cpu_vm_mask) {
> > >      if (cpu_curr(cpu)->mm == current->mm)
> > >         smp_call_function_single(cpu, func, NULL, 1);
> > >   }
> > > 
> > > seems far preferable over anything else, if you really want you can use
> > > a cpumask to copy cpu_vm_mask in and unset bits and use the mask with
> > > smp_call_function_any(), but that includes having to allocate the
> > > cpumask, which might or might not be too expensive for Mathieu.
> > 
> > This would be vulnerable to the sys_membarrier() CPU seeing an old value
> > of cpu_curr(cpu)->mm, and that other task seeing the old value of the
> > pointer we are trying to RCU-destroy, right?
> 
> Right, so I was thinking that since you want a mb to be executed when
> calling sys_membarrier(). If you observe a matching ->mm but the cpu has
> since scheduled, we're good since it scheduled (but we'll still send the
> IPI anyway), if we do not observe it because the task gets scheduled in
> after we do the iteration we're still good because it scheduled.

This deals with the case where the remote thread is being scheduled out.

As I understand it, if the thread is currently being scheduled in
exactly while we read cpu_curr(cpu)->mm, this means that we are
executing concurrently with the scheduler code. I expect that the
scheduler will issue a smp_mb() before leaving the cpu to the newcoming
thread, am I correct ? If this is correct, then we can assume that
reading any value of cpu_curr(cpu)->mm that does not match that of our
own process means that the value is either:

- corresponding to a thread belonging to another process (no ipi
  needed).
- corresponding to any thread, being scheduled in/out -> no IPI needed,
  but it does not hurt to send one. In this case, it does not matter if
  the racy read even returns pure garbage, as it's really a "don't
  care".

Even if the read would return garbage for some weird reason (piecewise
read maybe ?), that does not hurt, because the IPI is just "not needed"
at that point, since we rely on the concurrently executing scheduler to
issue the smp_mb().

> 
> As to needing to keep rcu_read_lock() around the iteration, for sure we
> need that to ensure the remote task_struct reference we take is valid.
> 

Indeed,

Thanks,

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
