Return-Path: <linux-kernel-owner+w=401wt.eu-S1751484AbZGYOT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484AbZGYOT2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 10:19:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750955AbZGYOT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 10:19:28 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:50866 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbZGYOT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 10:19:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=J2j2eC/23Mh1HqWQXAzyfdpjvNlm5PUmeC95ZQwgeu25SVPDvlJMP5Iw58Td/nfX0W
         XbCIg4+b3Ge2Cevx9ZX5AfcOtF95gsu1J04MZVzx2bfmajRO1Ysu0au+EQo6fFFJfx1/
         2W5N2S5fG5izzVOSJhMA+eDV8tF1W9dmRwgc8=
Date: Sat, 25 Jul 2009 16:19:22 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Anton Blanchard <anton@samba.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "K . Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH 5/5] perfcounter: Add support for kernel hardware
	breakpoints
Message-ID: <20090725141918.GA5295@nowhere>
References: <1248109687-7808-1-git-send-email-fweisbec@gmail.com> <1248109687-7808-6-git-send-email-fweisbec@gmail.com> <1248354493.26273.2.camel@twins> <c62985530907240702h2b2de14bw2f0d475f46067e4e@mail.gmail.com> <1248445569.6987.74.camel@twins> <20090724174723.GA11985@nowhere> <1248519416.5780.12.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1248519416.5780.12.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 25, 2009 at 12:56:56PM +0200, Peter Zijlstra wrote:
> On Fri, 2009-07-24 at 19:47 +0200, Frederic Weisbecker wrote:
> > On Fri, Jul 24, 2009 at 04:26:09PM +0200, Peter Zijlstra wrote:
> > > On Fri, 2009-07-24 at 16:02 +0200, Frédéric Weisbecker wrote:
> > > > 2009/7/23 Peter Zijlstra <a.p.zijlstra@chello.nl>:
> > > > > On Mon, 2009-07-20 at 13:08 -0400, Frederic Weisbecker wrote:
> > > > >> This adds the support for kernel hardware breakpoints in perfcounter.
> > > > >> It is added as a new type of software counter and can be defined by
> > > > >> using the counter number 5 and by passsing the address of the
> > > > >> breakpoint to set through the config attribute.
> > > > >
> > > > > Is there a limit to these hardware breakpoints? If so, the software
> > > > > counter model is not sufficient, since we assume we can always schedule
> > > > > all software counters. However if you were to add more counters than you
> > > > > have hardware breakpoints you're hosed.
> > > > >
> > > > >
> > > > 
> > > > Hmm, indeed. But this patch handles this case:
> > > > 
> > > > +static const struct pmu *bp_perf_counter_init(struct perf_counter *counter)
> > > > +{
> > > > +       if (hw_breakpoint_perf_init((unsigned long)counter->attr.config))
> > > > +               return NULL;
> > > > +
> > > > 
> > > > IIRC, hw_breakpoint_perf_init() calls register_kernel_breakpoint() which in turn
> > > > returns -ENOSPC if we haven't any breakpoint room left.
> > > > 
> > > > It seems we can only set 4 breakpoints simultaneously in x86, or
> > > > something close to that.
> > > 
> > > Ah, that's not the correct way of doing that. Suppose that you would
> > > register 4 breakpoint counter to one task, that would leave you unable
> > > to register a breakpoint counter on another task. Even though these
> > > breakpoints would never be scheduled simultaneously.
> > 
> > 
> > 
> > Ah, but the breakpoint API deals with that.
> > We have two types of breakpoints: the kernel bp and the user bp.
> > The kernel breakpoints are global points that don't deal with task
> > scheduling, virtual registers, etc...
> > 
> > But the user breakpoints (eg: used with ptrace) are dealt with virtual
> > debug registers in a way similar to perfcounter: each time we switch the
> > current task on a cpu, the hardware register states are stored in the
> > thread, and we load the virtual values into the hardware for the next
> > thread.
> 
> Ah, but that is sub-optimal, perf counters doesn't actually change the
> state if both tasks have the same counter configuration. Yielding a
> great performance benefit on scheduling intensive workloads. Poking at
> these MSRs, esp. writing to them is very expensive.


Ah ok.

 
> So I would suggest not using that feature of the breakpoint API for the
> perf counter integration.


That would forbid some kinds of profiling (explanations below).


> > However, this patchset only deals with kernel breakpoint for now (wide
> > tracing).
> 
> Right, and that's all you would need for perf counter support, please
> don't use whatever task state handling you have in place.


I would actually propose to have a separate layer that manages
the hardware registers <-> per thread virtual registers handling
for things like breakpoint api and perfcounter.

I know a simple RR of registers is not that hard to write, but at
least that can allow simultaneous use of perfcounter and other users
of breakpoint API without having  two different versions of register
management.


> > > Also, regular perf counters would multiplex counters when over-committed
> > > on a hardware resource, allowing you to create more such breakpoints
> > > than you have actual hardware slots.
> 
> > In the task level I talked above?
> 
> For either cpu or task level.
> 
> > > The way to do this is to create a breakpoint pmu which would simply fail
> > > the pmu->enable() method if there are insufficient hardware resources
> > > available.
> 
> > Now I wonder if the code that manages hardware debug breakpoint task switching
> > and the code from perfcounter could be factorized in one common thing.
> 
> Dunno, its really not that hard to RR a list of counters/breakpoint.
> 
> > > Also, your init routine, the above hw_breakpoint_perf_init(), will have
> > > to verify that when the counter is part of a group, this and all other
> > > hw breakpoint counters in that group can, now, but also in the future,
> > > be scheduled simultaneously.
> 
> > This is already dealt from the hardware breakpoint API.
> > We use only one breakpoint register for the user breakpoints, and the rest
> > for kernel breakpoints. Also if no user breakpoint is registered, every
> > registers can be used for kernek breakpoints.
> 
> This means that you can only ever allow 3 breakpoints into any one group
> and have to ensure that no other user can come in when they're not in
> active use -- the group is scheduled out.
> That is, you have to reserve the max number of breakpoint in a group for
> exclusive use by perf counters.


Hmm, if we reserve all breakpoints registers for perfcounter exclusive use
when it runs, that excludes any profiling of ptrace while doing a POKE_USR
or gdb while using breakpoints.

That's why I think it would be better to make use of the hardware breakpoints
from perfcounter using the bp API. Doing so allows concurrent users of bp while
perf is using them. Then we have no restriction concerning the profiling of
code that uses breakpoints.

Using a seperate hardware register <-> virtual register management layer
would then solve the problem of two different ad hoc implementations to
maintain and which impacts profiling performances.

 
> Also, this 1 for userspace seems restrictive. I'd want to have all 4
> from GDB if I'd knew my hardware was capable and I'd needed that many.


Actually I've made a mistake, you can use several user breakpoints, as
many as the number of hardware breakpoints, minus the number of kernel
bp currently set.


> 
> > > This means that there should be some arbitration towards other in-kernel
> > > hw breakpoint users, because if you allow all 4 hw breakpoints in a
> > > group and then let another hw breakpoint users have one, you can never
> > > schedule that group again.
> 
> > That's also why I think it's better to keep this virtual register management
> > from inside the breakpoint API, so that it can deal with perfcounter, ptrace,
> > etc... at the same.
> > 
> > What do you think?
> 
> I think not. I think the breakpoint API should not do task state, or at
> least have an interface without this.
> 
> Having two multiplexing layers on top of one another is inefficient and
> error prone.


And what do you think of the above idea?

Thanks.

