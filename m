Return-Path: <linux-kernel-owner+w=401wt.eu-S1753378AbZG2GhV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378AbZG2GhV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 02:37:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753022AbZG2GhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 02:37:20 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:48730 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622AbZG2GhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 02:37:19 -0400
Date: Wed, 29 Jul 2009 12:07:04 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Anton Blanchard <anton@samba.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH 5/5] perfcounter: Add support for kernel hardware
	breakpoints
Message-ID: <20090729063704.GA3297@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <c62985530907240702h2b2de14bw2f0d475f46067e4e@mail.gmail.com> <1248445569.6987.74.camel@twins> <20090724174723.GA11985@nowhere> <1248519416.5780.12.camel@laptop> <20090725141918.GA5295@nowhere> <1248538972.5780.25.camel@laptop> <20090725235702.GA5082@in.ibm.com> <1248684817.6987.1573.camel@twins> <20090728161218.GA3526@in.ibm.com> <1248799286.6987.3026.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248799286.6987.3026.camel@twins>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 28, 2009 at 06:41:26PM +0200, Peter Zijlstra wrote:
> On Tue, 2009-07-28 at 21:42 +0530, K.Prasad wrote:
> 
> > > Firstly, you seem to have this weird split of kernel/userspace
> > > breakpoints. Perf counters looks at things in a per-cpu fashion, so the
> > > all-cpus kernel breakpoint stuff is useless. Also, from perf counters'
> > > POV its perfectly reasonable to have a per-task kernel breakpoint.
> > > 
> > 
> > Although the existing implementation of hw-breakpoint API doesn't
> > support per-task kernel-space breakpoints, it isn't very difficult to
> > extend it to do so.
> > 
> > We could change the breakpoint infrastructure to something like this:
> > 
> > kernel-space breakpoints:
> > kernel-space addresses, system-wide i.e. on all CPUs, persist till explicit
> > unregistration, consume 1 debug register always.
> > 
> > New per-task breakpoints (i.e. modified user-space breakpoints):
> > accepts kernel- or user-space addresses, enabled per-task, consumes 1 debug
> > register (only when task is scheduled on the CPU), releases debug register
> > when yielding the CPU.
> 
> That still doesn't provide per-cpu breakpoints.
> 

Yes, it doesn't provide a per-cpu only implementation. One can obtain
the per-cpu data from the system-wide breakpoints by filtering it for a
given CPU (agreed, it will associated overhead).

A true per-cpu breakpoint implementation that co-exists with
system-wide and per-task breakpoints will be difficult. It might require
the re-introduction of some old features and a few new ones (like switching
between kernel and user-space breakpoints at syscall time) that were
rejected earlier by the community.

Also, the reason for a per-cpu only breakpoint (user and kernel-space)
isn't very obvious. While kernel variables can be read/written
throughout the system and user-space variables are per-task, the need
for obtaining per-cpu information isn't clear.

> > > Secondly, perf counters wants to schedule the per task breakpoints
> > > because we can optimize the context switch, saving lots of these MSR
> > > writes under some common scenarios.
> > > 
> > 
> > perf counters can continue to schedule per-task breakpoints -
> > enabling/disabling a breakpoint would require a call to the
> > 'register'/'unregister' interface and since it is per-cpu it is
> > light-weight when compared to system-wide breakpoints (that require IPIs
> > for propagation).
> > 
> > The common breakpoints can be identified and exempted from yielding the
> > debug registers (i.e. from the unregister-->register cycle) in the
> > perf-counter code.
> 
> If you want to implement it that way.. looking for duplicates is bound
> to result in something O(n^2), but with n=4 that's manageable.
> 
> Again, you seem to be missing per-cpu breakpoints.
> 
> > As a side note, I'm not sure if extra-polating (linearly?) the debug
> > register's "hit counter" value is a good idea. While a function may cause
> > several 'write' operations on a variable (say due to a loop statement) for
> > once, it may not exhibit similar behaviour throughout the time-slice of the
> > program's execution. Scaling the values may lead to incorrect results.
> 
> Sure, it won't be perfect, but if you assume the RR interval is
> decoupled from the task you can get statistically relevant information.
>
> > > Like I said, please use the raw per-cpu breakpoint interface for perf
> > > counters and connect that with the minimally required reservation you
> > > need to make your other thing work.
> > > 
> > > You simply cannot put perf-counter breakpoints on top of whatever virt
> > > layer you created going by what you say it is.
> > >
> > 
> > One of the design goals of the hw-breakpoint API is to provide a layer
> > of arbitration between various consumers of the physical debug register.
> > We should be able to extend the API to meet the demands of new users
> > with unique requirements (if not supported already), and the description
> > above broadly describe them for perf-counters.
> 
> Sure, but currently it does too much.
> 
> All you need for perf counter support is a per-cpu interface, no
> per-task, no system-wide.
> 
> But you want to mix that up with your per-task interface, which will
> complicate matters.
> 

This is a little confusing. I'm trying to understand which of the
questions below does perf-counter try to answer. i) and ii) is what I
thought would be, and asking iii) doesn't make much sense. What do you
think?

i) Tell me how many times kernel variable 'x' was updated when task 'a'
was scheduled
ii) Tell me how many times kernel variable 'x' was updated on the system
since I registered for the breakpoint
iii) Tell me how many times kernel variable 'x' was updated on CPU 'n'

Thanks,
K.Prasad

