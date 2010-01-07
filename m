Return-Path: <linux-kernel-owner+w=401wt.eu-S1753330Ab0AGSb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab0AGSb2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 13:31:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751728Ab0AGSb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 13:31:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61085 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964Ab0AGSb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 13:31:26 -0500
Date: Thu, 7 Jan 2010 19:30:10 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       josh@joshtriplett.org, tglx@linutronix.de, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
	barrier
Message-ID: <20100107183010.GA14980@redhat.com>
References: <20100107044007.GA22863@Krystal> <1262852862.4049.78.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262852862.4049.78.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07, Peter Zijlstra wrote:
>
> On Wed, 2010-01-06 at 23:40 -0500, Mathieu Desnoyers wrote:
>
> http://marc.info/?t=126283939400002
>
> > Index: linux-2.6-lttng/kernel/sched.c
> > ===================================================================
> > --- linux-2.6-lttng.orig/kernel/sched.c	2010-01-06 22:11:32.000000000 -0500
> > +++ linux-2.6-lttng/kernel/sched.c	2010-01-06 23:20:42.000000000 -0500
> > @@ -10822,6 +10822,36 @@ struct cgroup_subsys cpuacct_subsys = {
> >  };
> >  #endif	/* CONFIG_CGROUP_CPUACCT */
> >
> > +/*
> > + * Execute a memory barrier on all CPUs on SMP systems.
> > + * Do not rely on implicit barriers in smp_call_function(), just in case they
> > + * are ever relaxed in the future.
> > + */
> > +static void membarrier_ipi(void *unused)
> > +{
> > +	smp_mb();
> > +}
> > +
>
> Also, there was some talk a while ago about IPIs implying memory
> barriers. Which I of course forgot all details about,.. at least sending
> one implies a wmb and receiving one an rmb, but it could be stronger,
> Oleg?

IIRC, it was decided that IPIs must imply mb(), but I am not sure
this is true on any arch/



However, even if IPI didn't imply mb(), I don't understand why it
is needed... After the quick reading of the original changelog in
http://marc.info/?l=linux-kernel&m=126283923115068

	Thread A                    Thread B
	prev mem accesses           prev mem accesses
	sys_membarrier()            barrier()
	follow mem accesses         follow mem accesses

sys_membarrier() should "insert" mb() on behalf of B "instead"
of barrier(), right? But, if we send IPI, B enters kernel mode
and returns to user-mode. Should this imply mb() in any case?

Oleg.

