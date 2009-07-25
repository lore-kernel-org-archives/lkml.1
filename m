Return-Path: <linux-kernel-owner+w=401wt.eu-S1752091AbZGYQX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091AbZGYQX0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 12:23:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751966AbZGYQXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 12:23:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:38113 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbZGYQXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 12:23:24 -0400
Subject: Re: [RFC][PATCH 5/5] perfcounter: Add support for kernel hardware
 breakpoints
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
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
In-Reply-To: <20090725141918.GA5295@nowhere>
References: <1248109687-7808-1-git-send-email-fweisbec@gmail.com>
	 <1248109687-7808-6-git-send-email-fweisbec@gmail.com>
	 <1248354493.26273.2.camel@twins>
	 <c62985530907240702h2b2de14bw2f0d475f46067e4e@mail.gmail.com>
	 <1248445569.6987.74.camel@twins> <20090724174723.GA11985@nowhere>
	 <1248519416.5780.12.camel@laptop>  <20090725141918.GA5295@nowhere>
Content-Type: text/plain
Date: Sat, 25 Jul 2009 18:22:52 +0200
Message-Id: <1248538972.5780.25.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-07-25 at 16:19 +0200, Frederic Weisbecker wrote:

> > Ah, but that is sub-optimal, perf counters doesn't actually change the
> > state if both tasks have the same counter configuration. Yielding a
> > great performance benefit on scheduling intensive workloads. Poking at
> > these MSRs, esp. writing to them is very expensive.
> 
> 
> Ah ok.
> 
>  
> > So I would suggest not using that feature of the breakpoint API for the
> > perf counter integration.
> 
> 
> That would forbid some kinds of profiling (explanations below).
> 
> 
> > > However, this patchset only deals with kernel breakpoint for now (wide
> > > tracing).
> > 
> > Right, and that's all you would need for perf counter support, please
> > don't use whatever task state handling you have in place.
> 
> 
> I would actually propose to have a separate layer that manages
> the hardware registers <-> per thread virtual registers handling
> for things like breakpoint api and perfcounter.
> 
> I know a simple RR of registers is not that hard to write, but at
> least that can allow simultaneous use of perfcounter and other users
> of breakpoint API without having  two different versions of register
> management.

I simply cannot see how you would be able to multiplex userspace/debug
breakpoints. I'd utterly hate it if I'd missed a breakpoint simply
because someone else also wanted to make use of it.

I'd declare the system broken and useless.

Counters OTOH can be multiplexed because of their statistical nature,
you can simply scale them back up based on their time share.

Therefore you'll have to deal with hard reservations anyway.

Also, you don't need to a-priory reserve all breakpoints, you'll simply
need as many as the largest group (wrt breakpoints) has.

> > > This is already dealt from the hardware breakpoint API.
> > > We use only one breakpoint register for the user breakpoints, and the rest
> > > for kernel breakpoints. Also if no user breakpoint is registered, every
> > > registers can be used for kernek breakpoints.
> > 
> > This means that you can only ever allow 3 breakpoints into any one group
> > and have to ensure that no other user can come in when they're not in
> > active use -- the group is scheduled out.
> > That is, you have to reserve the max number of breakpoint in a group for
> > exclusive use by perf counters.
> 
> 
> Hmm, if we reserve all breakpoints registers for perfcounter exclusive use
> when it runs, that excludes any profiling of ptrace while doing a POKE_USR
> or gdb while using breakpoints.
> 
> That's why I think it would be better to make use of the hardware breakpoints
> from perfcounter using the bp API. Doing so allows concurrent users of bp while
> perf is using them. Then we have no restriction concerning the profiling of
> code that uses breakpoints.

Like said above, you cannot do this.

> Using a seperate hardware register <-> virtual register management layer
> would then solve the problem of two different ad hoc implementations to
> maintain and which impacts profiling performances.
> 
>  
> > Also, this 1 for userspace seems restrictive. I'd want to have all 4
> > from GDB if I'd knew my hardware was capable and I'd needed that many.
> 
> 
> Actually I've made a mistake, you can use several user breakpoints, as
> many as the number of hardware breakpoints, minus the number of kernel
> bp currently set.

Better :-)

