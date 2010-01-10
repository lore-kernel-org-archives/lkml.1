Return-Path: <linux-kernel-owner+w=401wt.eu-S1751402Ab0AJFZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751402Ab0AJFZK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 00:25:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751117Ab0AJFZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 00:25:09 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:46873 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152Ab0AJFZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 00:25:08 -0500
Date: Sat, 9 Jan 2010 21:25:08 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, josh@joshtriplett.org, tglx@linutronix.de,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
	barrier
Message-ID: <20100110052508.GG9044@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100109012128.GF6816@linux.vnet.ibm.com> <20100109023842.GA1696@Krystal> <20100109054215.GB9044@linux.vnet.ibm.com> <20100109192006.GA23672@Krystal> <1263078327.28171.3792.camel@gandalf.stny.rr.com> <1263079000.28171.3795.camel@gandalf.stny.rr.com> <20100110000318.GD9044@linux.vnet.ibm.com> <1263084099.2231.5.camel@frodo> <20100110014456.GG25790@Krystal> <1263089578.2231.22.camel@frodo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263089578.2231.22.camel@frodo>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 09, 2010 at 09:12:58PM -0500, Steven Rostedt wrote:
> On Sat, 2010-01-09 at 20:44 -0500, Mathieu Desnoyers wrote:
> 
> > > So what if we have a linear decrease in performance with the number of
> > > threads on the write side?
> > 
> > Hrm, looking at arch/x86/include/asm/mmu_context.h
> > 
> > switch_mm(), which is basically called each time the scheduler needs to
> > change the current task, does a
> > 
> > cpumask_clear_cpu(cpu, mm_cpumask(prev));
> > 
> > and
> > 
> > cpumask_set_cpu(cpu, mm_cpumask(next));
> > 
> > which precise goal is to stop the flush ipis for the previous mm. The
> > 100$ question is : why do we have to confirm that the thread is indeed
> > on the runqueue (taking locks and everything) when we could simply just
> > bluntly use the mm_cpumask for our own IPIs ?
> 
> I was just looking at that code, and was thinking the same thing ;-)
> 
> > cpumask_clear_cpu and cpumask_set_cpu translate into clear_bit/set_bit.
> > cpumask_next does a find_next_bit on the cpumask.
> > 
> > clear_bit/set_bit are atomic and not reordered on x86. PowerPC also uses
> > ll/sc loops in bitops.h, so I think it should be pretty safe to assume
> > that mm_cpumask is, by design, made to be used as cpumask to send a
> > broadcast IPI to all CPUs which run threads belonging to a given
> > process.
> > 
> > So, how about just using mm_cpumask(current) for the broadcast ? Then we
> > don't even need to allocate our own cpumask neither.
> > 
> > Or am I missing something ? I just sounds too simple.
> 
> I think we can use it. If for some reason it does not satisfy what you
> need then I also think the TLB flushing is also broken.
> 
> IIRC, (Paul help me out on this), what Paul said earlier, we are trying
> to protect against this scenario:
> 
> (from Paul's email:)
> 
> 
> > 
> >         CPU 1                           CPU 2
> >      -----------                    -------------
> > 
> >         <user space>                    <kernel space, switching to task>
> > 
> >                                         ->curr updated
> > 
> >                                         <long code path, maybe mb?>
> > 
> >                                         <user space>
> > 
> >                                         rcu_read_lock(); [load only]
> > 
> >                                         obj = list->next
> > 
> >         list_del(obj)
> > 
> >         sys_membarrier();
> >         < kernel space >
> > 
> >         if (task_rq(task)->curr != task)
> >         < but load to obj reordered before store to ->curr >
> > 
> >         < user space >
> > 
> >         < misses that CPU 2 is in rcu section >
> 
> 
> If the TLB flush misses that CPU 2 has a threaded task, and does not
> flush CPU 2s TLB, it can also risk the same type of crash.

But isn't the VM's locking helping us out in that case?

> >         [CPU 2's ->curr update now visible]
> > 
> >         [CPU 2's rcu_read_lock() store now visible]
> > 
> >         free(obj);
> > 
> >                                         use_object(obj); <=== crash!
> > 
> 
> Think about it. If you change a process mmap, say you updated a mmap of
> a file by flushing out one page and replacing it with another. If the
> above missed sending to CPU 2, then CPU 2 may still be accessing the old
> page of the file, and not the new one.
> 
> I think this may be the safe bet.

You might well be correct that we can access that bitmap locklessly,
but there are additional things (like the loading of the arch-specific
page-table register) that are likely to be helping in the VM case, but
not necessarily helping in this case.

							Thanx, Paul
