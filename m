Return-Path: <linux-kernel-owner+w=401wt.eu-S1752510Ab0AGRzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510Ab0AGRzk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 12:55:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752429Ab0AGRzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 12:55:39 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:58250 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752367Ab0AGRzi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 12:55:38 -0500
Date: Thu, 7 Jan 2010 09:55:32 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Josh Triplett <josh@joshtriplett.org>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       tglx@linutronix.de, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       laijs@cn.fujitsu.com, dipankar@in.ibm.com
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
	barrier
Message-ID: <20100107175532.GH6764@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100107044007.GA22863@Krystal> <1262842854.28171.3710.camel@gandalf.stny.rr.com> <20100107061955.GC25786@Krystal> <20100107063558.GC12939@feather> <1262853855.4049.86.camel@laptop> <20100107165249.GE6764@linux.vnet.ibm.com> <1262884716.4049.103.camel@laptop> <20100107173118.GG6764@linux.vnet.ibm.com> <20100107174435.GC16027@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100107174435.GC16027@Krystal>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 07, 2010 at 12:44:35PM -0500, Mathieu Desnoyers wrote:
> * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > On Thu, Jan 07, 2010 at 06:18:36PM +0100, Peter Zijlstra wrote:
> > > On Thu, 2010-01-07 at 08:52 -0800, Paul E. McKenney wrote:
> > > > On Thu, Jan 07, 2010 at 09:44:15AM +0100, Peter Zijlstra wrote:
> > > > > On Wed, 2010-01-06 at 22:35 -0800, Josh Triplett wrote:
> > > > > > 
> > > > > > The number of threads doesn't matter nearly as much as the number of
> > > > > > threads typically running at a time compared to the number of
> > > > > > processors.  Of course, we can't measure that as easily, but I don't
> > > > > > know that your proposed heuristic would approximate it well.
> > > > > 
> > > > > Quite agreed, and not disturbing RT tasks is even more important.
> > > > 
> > > > OK, so I stand un-Reviewed-by twice in one morning.  ;-)
> > > > 
> > > > > A simple:
> > > > > 
> > > > >   for_each_cpu(cpu, current->mm->cpu_vm_mask) {
> > > > >      if (cpu_curr(cpu)->mm == current->mm)
> > > > >         smp_call_function_single(cpu, func, NULL, 1);
> > > > >   }
> > > > > 
> > > > > seems far preferable over anything else, if you really want you can use
> > > > > a cpumask to copy cpu_vm_mask in and unset bits and use the mask with
> > > > > smp_call_function_any(), but that includes having to allocate the
> > > > > cpumask, which might or might not be too expensive for Mathieu.
> > > > 
> > > > This would be vulnerable to the sys_membarrier() CPU seeing an old value
> > > > of cpu_curr(cpu)->mm, and that other task seeing the old value of the
> > > > pointer we are trying to RCU-destroy, right?
> > > 
> > > Right, so I was thinking that since you want a mb to be executed when
> > > calling sys_membarrier(). If you observe a matching ->mm but the cpu has
> > > since scheduled, we're good since it scheduled (but we'll still send the
> > > IPI anyway), if we do not observe it because the task gets scheduled in
> > > after we do the iteration we're still good because it scheduled.
> > 
> > Something like the following for sys_membarrier(), then?
> > 
> >   smp_mb();
> 
> This smp_mb() is redundant, as we issue it through the for_each_cpu loop
> on the local CPU already.

But we need to do the smp_mb() -before- checking the first cpu_curr(cpu)->mm.

> >   for_each_cpu(cpu, current->mm->cpu_vm_mask) {
> >      if (cpu_curr(cpu)->mm == current->mm)
> >         smp_call_function_single(cpu, func, NULL, 1);
> >   }
> > 
> > Then the code changing ->mm on the other CPU also needs to have a
> > full smp_mb() somewhere after the change to ->mm, but before starting
> > user-space execution.  Which it might well just due to overhead, but
> > we need to make sure that someone doesn't optimize us out of existence.
> 
> I believe we also need one between execution of the userspace task and
> change to ->mm. If we have these guarantees I think we are fine.

Agreed, in case an outgoing RCU read-side critical section does a store
into an RCU-protected data structure.  Unconventional, but definitely
permitted.

							Thanx, Paul

> Mathieu
> 
> > 
> > 							Thanx, Paul
> > 
> > > As to needing to keep rcu_read_lock() around the iteration, for sure we
> > > need that to ensure the remote task_struct reference we take is valid.
> > > 
> 
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
