Return-Path: <linux-kernel-owner+w=401wt.eu-S1753110Ab0AJQDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110Ab0AJQDT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 11:03:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752316Ab0AJQDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 11:03:18 -0500
Received: from tomts16.bellnexxia.net ([209.226.175.4]:59677 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752079Ab0AJQDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 11:03:18 -0500
Date: Sun, 10 Jan 2010 11:03:14 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: paulmck@linux.vnet.ibm.com, Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       josh@joshtriplett.org, tglx@linutronix.de, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, laijs@cn.fujitsu.com, dipankar@in.ibm.com
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
	barrier
Message-ID: <20100110160314.GA10587@Krystal>
References: <20100109054215.GB9044@linux.vnet.ibm.com> <20100109192006.GA23672@Krystal> <1263078327.28171.3792.camel@gandalf.stny.rr.com> <1263079000.28171.3795.camel@gandalf.stny.rr.com> <20100110000318.GD9044@linux.vnet.ibm.com> <1263084099.2231.5.camel@frodo> <20100110014456.GG25790@Krystal> <1263089578.2231.22.camel@frodo> <20100110052508.GG9044@linux.vnet.ibm.com> <1263124209.28171.3798.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1263124209.28171.3798.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 10:54:41 up 25 days, 13 min,  5 users,  load average: 0.14, 0.11,
	0.09
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Sat, 2010-01-09 at 21:25 -0800, Paul E. McKenney wrote:
> > On Sat, Jan 09, 2010 at 09:12:58PM -0500, Steven Rostedt wrote:
> 
> > > >         < user space >
> > > > 
> > > >         < misses that CPU 2 is in rcu section >
> > > 
> > > 
> > > If the TLB flush misses that CPU 2 has a threaded task, and does not
> > > flush CPU 2s TLB, it can also risk the same type of crash.
> > 
> > But isn't the VM's locking helping us out in that case?
> > 
> > > >         [CPU 2's ->curr update now visible]
> > > > 
> > > >         [CPU 2's rcu_read_lock() store now visible]
> > > > 
> > > >         free(obj);
> > > > 
> > > >                                         use_object(obj); <=== crash!
> > > > 
> > > 
> > > Think about it. If you change a process mmap, say you updated a mmap of
> > > a file by flushing out one page and replacing it with another. If the
> > > above missed sending to CPU 2, then CPU 2 may still be accessing the old
> > > page of the file, and not the new one.
> > > 
> > > I think this may be the safe bet.
> > 
> > You might well be correct that we can access that bitmap locklessly,
> > but there are additional things (like the loading of the arch-specific
> > page-table register) that are likely to be helping in the VM case, but
> > not necessarily helping in this case.
> 
> 
> Then perhaps the sys_membarrier() should just do a flush_tlb()? That
> should guarantee the synchronization, right?
> 

The way I see it, TLB can be seen as read-only elements (a local
read-only cache) on the processors. Therefore, we don't care if they are
in a stale state while performing the cpumask update, because the fact
that we are executing switch_mm() means that these TLB entries are not
being used locally anyway and will be dropped shortly. So we have the
equivalent of a full memory barrier (load_cr3()) _after_ the cpumask
updates.

However, in sys_membarrier(), we also need to flush the write buffers
present on each processor running threads which belong to our current
process. Therefore, we would need, in addition, a smp_mb() before the
mm cpumask modification. For x86, cpumask_clear_cpu/cpumask_set_cpu
implies a LOCK-prefixed operation, and hence does not need any added
barrier, but this could be different for other architectures.

So, AFAIK, doing a flush_tlb() would not guarantee the kind of
synchronization we are looking for because an uncommitted write buffer
could still sit on the remote CPU when we return from sys_membarrier().

Thanks,

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
