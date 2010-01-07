Return-Path: <linux-kernel-owner+w=401wt.eu-S1751084Ab0AGRTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751084Ab0AGRTj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 12:19:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750785Ab0AGRTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 12:19:38 -0500
Received: from casper.infradead.org ([85.118.1.10]:58291 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782Ab0AGRTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 12:19:37 -0500
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
 barrier
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Josh Triplett <josh@joshtriplett.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       tglx@linutronix.de, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       laijs@cn.fujitsu.com, dipankar@in.ibm.com
In-Reply-To: <20100107165249.GE6764@linux.vnet.ibm.com>
References: <20100107044007.GA22863@Krystal>
	 <1262842854.28171.3710.camel@gandalf.stny.rr.com>
	 <20100107061955.GC25786@Krystal> <20100107063558.GC12939@feather>
	 <1262853855.4049.86.camel@laptop>
	 <20100107165249.GE6764@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Jan 2010 18:18:36 +0100
Message-ID: <1262884716.4049.103.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-07 at 08:52 -0800, Paul E. McKenney wrote:
> On Thu, Jan 07, 2010 at 09:44:15AM +0100, Peter Zijlstra wrote:
> > On Wed, 2010-01-06 at 22:35 -0800, Josh Triplett wrote:
> > > 
> > > The number of threads doesn't matter nearly as much as the number of
> > > threads typically running at a time compared to the number of
> > > processors.  Of course, we can't measure that as easily, but I don't
> > > know that your proposed heuristic would approximate it well.
> > 
> > Quite agreed, and not disturbing RT tasks is even more important.
> 
> OK, so I stand un-Reviewed-by twice in one morning.  ;-)
> 
> > A simple:
> > 
> >   for_each_cpu(cpu, current->mm->cpu_vm_mask) {
> >      if (cpu_curr(cpu)->mm == current->mm)
> >         smp_call_function_single(cpu, func, NULL, 1);
> >   }
> > 
> > seems far preferable over anything else, if you really want you can use
> > a cpumask to copy cpu_vm_mask in and unset bits and use the mask with
> > smp_call_function_any(), but that includes having to allocate the
> > cpumask, which might or might not be too expensive for Mathieu.
> 
> This would be vulnerable to the sys_membarrier() CPU seeing an old value
> of cpu_curr(cpu)->mm, and that other task seeing the old value of the
> pointer we are trying to RCU-destroy, right?

Right, so I was thinking that since you want a mb to be executed when
calling sys_membarrier(). If you observe a matching ->mm but the cpu has
since scheduled, we're good since it scheduled (but we'll still send the
IPI anyway), if we do not observe it because the task gets scheduled in
after we do the iteration we're still good because it scheduled.

As to needing to keep rcu_read_lock() around the iteration, for sure we
need that to ensure the remote task_struct reference we take is valid.

