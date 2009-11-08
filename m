Return-Path: <linux-kernel-owner+w=401wt.eu-S1754796AbZKHRcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796AbZKHRcQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 12:32:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754631AbZKHRcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 12:32:16 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:45096 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750AbZKHRcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 12:32:15 -0500
Date: Sun, 8 Nov 2009 23:02:05 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Jan Kiszka <jan.kiszka@web.de>,
       Jiri Slaby <jirislaby@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Avi Kivity <avi@redhat.com>, Paul Mackerras <paulus@samba.org>,
       Mike Galbraith <efault@gmx.de>, Masami Hiramatsu <mhiramat@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 4/6] hw-breakpoints: Rewrite the hw-breakpoints layer
	on top of perf events
Message-ID: <20091108173205.GC4465@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <1257275474-5285-1-git-send-email-fweisbec@gmail.com> <1257275474-5285-5-git-send-email-fweisbec@gmail.com> <20091105153404.GB3229@in.ibm.com> <20091105210652.GF4877@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091105210652.GF4877@nowhere>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 05, 2009 at 10:06:55PM +0100, Frederic Weisbecker wrote:
> On Thu, Nov 05, 2009 at 09:04:04PM +0530, K.Prasad wrote:
> > On Tue, Nov 03, 2009 at 08:11:12PM +0100, Frederic Weisbecker wrote:
> > > +/*
> > > + * Kernel breakpoints are not associated with any particular thread.
> > > + */
> > > +extern struct perf_event *
> > > +register_wide_hw_breakpoint_cpu(unsigned long addr,
> > > +				int len,
> > > +				int type,
> > > +				perf_callback_t triggered,
> > > +				int cpu,
> > 
> > Can't it be cpumask_t instead of int cpu? Given that per-cpu breakpoints
> > will be implemented, it should be very different to implement them for a
> > subset of cpus too.
> 
> I can't figure out any usecase where we want to only bind to,
> say, cpu 1 and 3 or any kind of such strange combination.
> 
> Either we want a wide breakpoint, or we want to profile
> a single cpu, but I don't imagine we need a middle case.
 
When we originally had this discussion on LKML, one of the use-cases
cited was http://lkml.org/lkml/2009/7/29/243. I can't see why such
need should be restricted to a given CPU only, rather than a subset of
CPUs (say 'x' is a variable normally read/written-to in the interrupt
path, and if the said interrupt is has a cpu affinity to a subset of
cpus only).

Although in the normal case, this feature could be implemented later, in
case of breakpoints we accept that as input from the user (and hence
part of the well-defined interface), so it is better to design it for
a subset of CPUs from start. The logic isn't very different and given that
there are plenty of helper routines in cpumask.h the implementation is easy too.

> 
> > > -static DEFINE_SPINLOCK(hw_breakpoint_lock);
> > 
> > Wouldn't you want to hold this lock while checking for system-wide
> > availability of debug registers (during rollbacks) to avoid contenders
> > from checking for the same simultaneously?
> 
> 
> If we want to lock such path, we probably more likely want a mutex.
> Registering a breakpoint is not a fastpath and also perf does
> some sleepable things while creating a counter.
> 
> The check to register constraints, which is part of this path,
> is itself a mutex.
> 
> But we'll probably need something NMI safe in the future so
> that it can be used without any problem by kgdb.
> 

I suspect that it will be required for cpu-hotplug handler, where
previously load_debug_registers() was called from a softirq context.

> 
> > <snipped>
> > 
> > > -int register_kernel_hw_breakpoint(struct hw_breakpoint *bp)
> > > +struct perf_event **
> > > +register_wide_hw_breakpoint(unsigned long addr,
> > > +			    int len,
> > > +			    int type,
> > > +			    perf_callback_t triggered,
> > > +			    bool active)
> > >  {
> > > -	int rc;
> > > +	struct perf_event **cpu_events, **pevent, *bp;
> > > +	long err;
> > > +	int cpu;
> > > +
> > > +	cpu_events = alloc_percpu(typeof(*cpu_events));
> > > +	if (!cpu_events)
> > > +		return ERR_PTR(-ENOMEM);
> > > 
> > > -	rc = arch_validate_hwbkpt_settings(bp, NULL);
> > > -	if (rc)
> > > -		return rc;
> > > +	for_each_possible_cpu(cpu) {
> > > +		pevent = per_cpu_ptr(cpu_events, cpu);
> > > +		bp = register_kernel_hw_breakpoint_cpu(addr, len, type,
> > > +					triggered, cpu, active);
> > > 
> > 
> > I'm assuming that there'd be an implementation for system-wide
> > perf-events (and hence breakpoints) in the forthcoming version(s) of
> > this patchset.
> 
> 
> If that becomes a necessary feature, then yeah.
> 
> 

Apart from the several benefits of having system-wide perf-events,
implementing them in the first iteration itself will
help us fully realise the cost of perf-events + hw-breakpoint
integration! When implemented, perf-events will also be ready to
accomodate future users (apart from bp and perf-top) having a
need for system-wide counter.

Thanks,
K.Prasad

