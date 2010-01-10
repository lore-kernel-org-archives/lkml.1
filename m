Return-Path: <linux-kernel-owner+w=401wt.eu-S1752416Ab0AJSY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416Ab0AJSY1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 13:24:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011Ab0AJSY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 13:24:26 -0500
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:54405 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751993Ab0AJSYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 13:24:25 -0500
Date: Sun, 10 Jan 2010 13:24:23 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       josh@joshtriplett.org, tglx@linutronix.de, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, laijs@cn.fujitsu.com, dipankar@in.ibm.com
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
	barrier
Message-ID: <20100110182423.GA22821@Krystal>
References: <20100109192006.GA23672@Krystal> <1263078327.28171.3792.camel@gandalf.stny.rr.com> <1263079000.28171.3795.camel@gandalf.stny.rr.com> <20100110000318.GD9044@linux.vnet.ibm.com> <1263084099.2231.5.camel@frodo> <20100110014456.GG25790@Krystal> <1263089578.2231.22.camel@frodo> <20100110052508.GG9044@linux.vnet.ibm.com> <1263124209.28171.3798.camel@gandalf.stny.rr.com> <20100110174512.GH9044@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20100110174512.GH9044@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 13:18:11 up 25 days,  2:36,  4 users,  load average: 0.31, 0.16,
	0.11
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> On Sun, Jan 10, 2010 at 06:50:09AM -0500, Steven Rostedt wrote:
> > On Sat, 2010-01-09 at 21:25 -0800, Paul E. McKenney wrote:
> > > On Sat, Jan 09, 2010 at 09:12:58PM -0500, Steven Rostedt wrote:
> > 
> > > > >         < user space >
> > > > > 
> > > > >         < misses that CPU 2 is in rcu section >
> > > > 
> > > > 
> > > > If the TLB flush misses that CPU 2 has a threaded task, and does not
> > > > flush CPU 2s TLB, it can also risk the same type of crash.
> > > 
> > > But isn't the VM's locking helping us out in that case?
> > > 
> > > > >         [CPU 2's ->curr update now visible]
> > > > > 
> > > > >         [CPU 2's rcu_read_lock() store now visible]
> > > > > 
> > > > >         free(obj);
> > > > > 
> > > > >                                         use_object(obj); <=== crash!
> > > > > 
> > > > 
> > > > Think about it. If you change a process mmap, say you updated a mmap of
> > > > a file by flushing out one page and replacing it with another. If the
> > > > above missed sending to CPU 2, then CPU 2 may still be accessing the old
> > > > page of the file, and not the new one.
> > > > 
> > > > I think this may be the safe bet.
> > > 
> > > You might well be correct that we can access that bitmap locklessly,
> > > but there are additional things (like the loading of the arch-specific
> > > page-table register) that are likely to be helping in the VM case, but
> > > not necessarily helping in this case.
> > 
> > Then perhaps the sys_membarrier() should just do a flush_tlb()? That
> > should guarantee the synchronization, right?
> 
> Isn't just grabbing the runqueue locks a bit more straightforward and
> more clearly correct?  Again, this is the URCU slowpath, so it is hard
> to get too excited about a 15% performance penalty.
> 

Even when taking the spinlocks, efficient iteration on active threads is
done with for_each_cpu(cpu, mm_cpumask(current->mm)), which depends on
the same cpumask, and thus requires the same memory barriers around the
updates.

We could switch to an inefficient iteration on all online CPUs instead,
and check read runqueue ->mm with the spinlock held. Is that what you
propose ? This will cause reading of large amounts of runqueue
information, especially on large systems running few threads. The other
way around is to iterate on all the process threads: in this case, small
systems running many threads will have to read information about many
inactive threads, which is not much better.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
