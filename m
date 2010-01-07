Return-Path: <linux-kernel-owner+w=401wt.eu-S1753396Ab0AGSjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab0AGSjx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 13:39:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752022Ab0AGSjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 13:39:52 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:44183 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751681Ab0AGSjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 13:39:52 -0500
Date: Thu, 7 Jan 2010 10:39:46 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, josh@joshtriplett.org, tglx@linutronix.de,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       laijs@cn.fujitsu.com, dipankar@in.ibm.com
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
	barrier
Message-ID: <20100107183946.GL6764@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100107044007.GA22863@Krystal> <1262852862.4049.78.camel@laptop> <20100107183010.GA14980@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100107183010.GA14980@redhat.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 07, 2010 at 07:30:10PM +0100, Oleg Nesterov wrote:
> On 01/07, Peter Zijlstra wrote:
> >
> > On Wed, 2010-01-06 at 23:40 -0500, Mathieu Desnoyers wrote:
> >
> > http://marc.info/?t=126283939400002
> >
> > > Index: linux-2.6-lttng/kernel/sched.c
> > > ===================================================================
> > > --- linux-2.6-lttng.orig/kernel/sched.c	2010-01-06 22:11:32.000000000 -0500
> > > +++ linux-2.6-lttng/kernel/sched.c	2010-01-06 23:20:42.000000000 -0500
> > > @@ -10822,6 +10822,36 @@ struct cgroup_subsys cpuacct_subsys = {
> > >  };
> > >  #endif	/* CONFIG_CGROUP_CPUACCT */
> > >
> > > +/*
> > > + * Execute a memory barrier on all CPUs on SMP systems.
> > > + * Do not rely on implicit barriers in smp_call_function(), just in case they
> > > + * are ever relaxed in the future.
> > > + */
> > > +static void membarrier_ipi(void *unused)
> > > +{
> > > +	smp_mb();
> > > +}
> > > +
> >
> > Also, there was some talk a while ago about IPIs implying memory
> > barriers. Which I of course forgot all details about,.. at least sending
> > one implies a wmb and receiving one an rmb, but it could be stronger,
> > Oleg?
> 
> IIRC, it was decided that IPIs must imply mb(), but I am not sure
> this is true on any arch/
> 
> 
> 
> However, even if IPI didn't imply mb(), I don't understand why it
> is needed... After the quick reading of the original changelog in
> http://marc.info/?l=linux-kernel&m=126283923115068
> 
> 	Thread A                    Thread B
> 	prev mem accesses           prev mem accesses
> 	sys_membarrier()            barrier()
> 	follow mem accesses         follow mem accesses
> 
> sys_membarrier() should "insert" mb() on behalf of B "instead"
> of barrier(), right? But, if we send IPI, B enters kernel mode
> and returns to user-mode. Should this imply mb() in any case?

Hello, Oleg,

The issue is with some suggested optimizations that would avoid sending
the IPI to CPUs that are not running threads in the same process as the
thread executing the sys_membarrier().  Some forms of these optimizations
sample ->mm without locking, and the question is whether this is safe.

							Thanx, Paul
