Return-Path: <linux-kernel-owner+w=401wt.eu-S1753565AbZGXRrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565AbZGXRrk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 13:47:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753504AbZGXRrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 13:47:39 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:19531 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249AbZGXRr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 13:47:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=ntXUMJrtBhtmO0VA9lW/FyzifSJ1edE5+EmNJ3lIfGrVnz5qze4R+h/+N+BfLgAts7
         6cYO3ncEmZ9bBMROEoHkW4B99XGQhAP9djLf1F0STnQRo0w3psZguJeMe01JZDd9Ap3C
         gD29pQ/DKs+DAuO1LABBdXdD8r+5CsN9nuFKk=
Date: Fri, 24 Jul 2009 19:47:25 +0200
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
Message-ID: <20090724174723.GA11985@nowhere>
References: <1248109687-7808-1-git-send-email-fweisbec@gmail.com> <1248109687-7808-6-git-send-email-fweisbec@gmail.com> <1248354493.26273.2.camel@twins> <c62985530907240702h2b2de14bw2f0d475f46067e4e@mail.gmail.com> <1248445569.6987.74.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1248445569.6987.74.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 24, 2009 at 04:26:09PM +0200, Peter Zijlstra wrote:
> On Fri, 2009-07-24 at 16:02 +0200, Frédéric Weisbecker wrote:
> > 2009/7/23 Peter Zijlstra <a.p.zijlstra@chello.nl>:
> > > On Mon, 2009-07-20 at 13:08 -0400, Frederic Weisbecker wrote:
> > >> This adds the support for kernel hardware breakpoints in perfcounter.
> > >> It is added as a new type of software counter and can be defined by
> > >> using the counter number 5 and by passsing the address of the
> > >> breakpoint to set through the config attribute.
> > >
> > > Is there a limit to these hardware breakpoints? If so, the software
> > > counter model is not sufficient, since we assume we can always schedule
> > > all software counters. However if you were to add more counters than you
> > > have hardware breakpoints you're hosed.
> > >
> > >
> > 
> > Hmm, indeed. But this patch handles this case:
> > 
> > +static const struct pmu *bp_perf_counter_init(struct perf_counter *counter)
> > +{
> > +       if (hw_breakpoint_perf_init((unsigned long)counter->attr.config))
> > +               return NULL;
> > +
> > 
> > IIRC, hw_breakpoint_perf_init() calls register_kernel_breakpoint() which in turn
> > returns -ENOSPC if we haven't any breakpoint room left.
> > 
> > It seems we can only set 4 breakpoints simultaneously in x86, or
> > something close to that.
> 
> Ah, that's not the correct way of doing that. Suppose that you would
> register 4 breakpoint counter to one task, that would leave you unable
> to register a breakpoint counter on another task. Even though these
> breakpoints would never be scheduled simultaneously.



Ah, but the breakpoint API deals with that.
We have two types of breakpoints: the kernel bp and the user bp.
The kernel breakpoints are global points that don't deal with task
scheduling, virtual registers, etc...

But the user breakpoints (eg: used with ptrace) are dealt with virtual
debug registers in a way similar to perfcounter: each time we switch the
current task on a cpu, the hardware register states are stored in the
thread, and we load the virtual values into the hardware for the next
thread.

However, this patchset only deals with kernel breakpoint for now (wide
tracing).

 
> Also, regular perf counters would multiplex counters when over-committed
> on a hardware resource, allowing you to create more such breakpoints
> than you have actual hardware slots.



In the task level I talked above?



> The way to do this is to create a breakpoint pmu which would simply fail
> the pmu->enable() method if there are insufficient hardware resources
> available.



Now I wonder if the code that manages hardware debug breakpoint task switching
and the code from perfcounter could be factorized in one common thing.


> Also, your init routine, the above hw_breakpoint_perf_init(), will have
> to verify that when the counter is part of a group, this and all other
> hw breakpoint counters in that group can, now, but also in the future,
> be scheduled simultaneously.


This is already dealt from the hardware breakpoint API.
We use only one breakpoint register for the user breakpoints, and the rest
for kernel breakpoints. Also if no user breakpoint is registered, every
registers can be used for kernek breakpoints.


> This means that there should be some arbitration towards other in-kernel
> hw breakpoint users, because if you allow all 4 hw breakpoints in a
> group and then let another hw breakpoint users have one, you can never
> schedule that group again.


That's also why I think it's better to keep this virtual register management
from inside the breakpoint API, so that it can deal with perfcounter, ptrace,
etc... at the same.

What do you think?


> 
> [ which raises a fun point, Paulus do we handle groups having multiple
>   'hardware' pmu's in? ]
> 
> Now, for the actual counter implementation you can probably re-use the
> swcounter code, but you also need a pmu implementation.
> 

