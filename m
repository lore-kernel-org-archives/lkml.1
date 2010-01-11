Return-Path: <linux-kernel-owner+w=401wt.eu-S1752335Ab0AKBRH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335Ab0AKBRH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 20:17:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243Ab0AKBRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 20:17:05 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:46968 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095Ab0AKBRD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 20:17:03 -0500
Date: Sun, 10 Jan 2010 17:17:05 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       josh@joshtriplett.org, tglx@linutronix.de, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, laijs@cn.fujitsu.com, dipankar@in.ibm.com
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
	barrier
Message-ID: <20100111011705.GJ9044@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1263078327.28171.3792.camel@gandalf.stny.rr.com> <1263079000.28171.3795.camel@gandalf.stny.rr.com> <20100110000318.GD9044@linux.vnet.ibm.com> <1263084099.2231.5.camel@frodo> <20100110014456.GG25790@Krystal> <1263089578.2231.22.camel@frodo> <20100110052508.GG9044@linux.vnet.ibm.com> <1263124209.28171.3798.camel@gandalf.stny.rr.com> <20100110174512.GH9044@linux.vnet.ibm.com> <20100110182423.GA22821@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100110182423.GA22821@Krystal>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 10, 2010 at 01:24:23PM -0500, Mathieu Desnoyers wrote:
> * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > On Sun, Jan 10, 2010 at 06:50:09AM -0500, Steven Rostedt wrote:
> > > On Sat, 2010-01-09 at 21:25 -0800, Paul E. McKenney wrote:
> > > > On Sat, Jan 09, 2010 at 09:12:58PM -0500, Steven Rostedt wrote:
> > > 
> > > > > >         < user space >
> > > > > > 
> > > > > >         < misses that CPU 2 is in rcu section >
> > > > > 
> > > > > 
> > > > > If the TLB flush misses that CPU 2 has a threaded task, and does not
> > > > > flush CPU 2s TLB, it can also risk the same type of crash.
> > > > 
> > > > But isn't the VM's locking helping us out in that case?
> > > > 
> > > > > >         [CPU 2's ->curr update now visible]
> > > > > > 
> > > > > >         [CPU 2's rcu_read_lock() store now visible]
> > > > > > 
> > > > > >         free(obj);
> > > > > > 
> > > > > >                                         use_object(obj); <=== crash!
> > > > > > 
> > > > > 
> > > > > Think about it. If you change a process mmap, say you updated a mmap of
> > > > > a file by flushing out one page and replacing it with another. If the
> > > > > above missed sending to CPU 2, then CPU 2 may still be accessing the old
> > > > > page of the file, and not the new one.
> > > > > 
> > > > > I think this may be the safe bet.
> > > > 
> > > > You might well be correct that we can access that bitmap locklessly,
> > > > but there are additional things (like the loading of the arch-specific
> > > > page-table register) that are likely to be helping in the VM case, but
> > > > not necessarily helping in this case.
> > > 
> > > Then perhaps the sys_membarrier() should just do a flush_tlb()? That
> > > should guarantee the synchronization, right?
> > 
> > Isn't just grabbing the runqueue locks a bit more straightforward and
> > more clearly correct?  Again, this is the URCU slowpath, so it is hard
> > to get too excited about a 15% performance penalty.
> 
> Even when taking the spinlocks, efficient iteration on active threads is
> done with for_each_cpu(cpu, mm_cpumask(current->mm)), which depends on
> the same cpumask, and thus requires the same memory barriers around the
> updates.

Ouch!!!  Good point and good catch!!!

> We could switch to an inefficient iteration on all online CPUs instead,
> and check read runqueue ->mm with the spinlock held. Is that what you
> propose ? This will cause reading of large amounts of runqueue
> information, especially on large systems running few threads. The other
> way around is to iterate on all the process threads: in this case, small
> systems running many threads will have to read information about many
> inactive threads, which is not much better.

I am not all that worried about exactly what we do as long as it is
pretty obviously correct.  We can then improve performance when and as
the need arises.  We might need to use any of the strategies you
propose, or perhaps even choose among them depending on the number of
threads in the process, the number of CPUs, and so forth.  (I hope not,
but...)

My guess is that an obviously correct approach would work well for a
slowpath.  If someone later runs into performance problems, we can fix
them with the added knowledge of what they are trying to do.

							Thanx, Paul

							Thanx, Paul
