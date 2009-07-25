Return-Path: <linux-kernel-owner+w=401wt.eu-S1752908AbZGYX5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908AbZGYX5Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 19:57:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752558AbZGYX5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 19:57:15 -0400
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:54703 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856AbZGYX5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 19:57:15 -0400
Date: Sun, 26 Jul 2009 05:27:02 +0530
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
Message-ID: <20090725235702.GA5082@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <1248109687-7808-1-git-send-email-fweisbec@gmail.com> <1248109687-7808-6-git-send-email-fweisbec@gmail.com> <1248354493.26273.2.camel@twins> <c62985530907240702h2b2de14bw2f0d475f46067e4e@mail.gmail.com> <1248445569.6987.74.camel@twins> <20090724174723.GA11985@nowhere> <1248519416.5780.12.camel@laptop> <20090725141918.GA5295@nowhere> <1248538972.5780.25.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248538972.5780.25.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 25, 2009 at 06:22:52PM +0200, Peter Zijlstra wrote:
> On Sat, 2009-07-25 at 16:19 +0200, Frederic Weisbecker wrote:
> 
> > > Ah, but that is sub-optimal, perf counters doesn't actually change the
> > > state if both tasks have the same counter configuration. Yielding a
> > > great performance benefit on scheduling intensive workloads. Poking at
> > > these MSRs, esp. writing to them is very expensive.
> > 
> > 
> > Ah ok.
> > 
> >  
> > > So I would suggest not using that feature of the breakpoint API for the
> > > perf counter integration.
> > 
> > 
> > That would forbid some kinds of profiling (explanations below).
> > 
> > 
> > > > However, this patchset only deals with kernel breakpoint for now (wide
> > > > tracing).
> > > 
> > > Right, and that's all you would need for perf counter support, please
> > > don't use whatever task state handling you have in place.
> > 
> > 
> > I would actually propose to have a separate layer that manages
> > the hardware registers <-> per thread virtual registers handling
> > for things like breakpoint api and perfcounter.
> > 
> > I know a simple RR of registers is not that hard to write, but at
> > least that can allow simultaneous use of perfcounter and other users
> > of breakpoint API without having  two different versions of register
> > management.
> 
> I simply cannot see how you would be able to multiplex userspace/debug
> breakpoints. I'd utterly hate it if I'd missed a breakpoint simply
> because someone else also wanted to make use of it.
> 
> I'd declare the system broken and useless.
> 
> Counters OTOH can be multiplexed because of their statistical nature,
> you can simply scale them back up based on their time share.
> 
> Therefore you'll have to deal with hard reservations anyway.
> 

I don't claim to have understood the requirements of perf-counters
fully, but I sense the persistence of a few doubts about the register
allocation mechanism of the hw-breakpoints API...thought it might be
worthwhile to briefly explain.

A few notes about the same:

Kernel-space breakpoints: They are system-wide i.e. one kernel-space
breakpoint request consumes one debug register on 'all' CPUs of the
system.
User-space breakpoints: Requests are stored in per-thread data
structures. Written onto the debug register only when scheduled-into
the CPU, and are removed when another task using the debug registers is
scheduled onto the CPU.
Debug register allocation mechanism: register request succeeds only when
the availability of a debug register is guaranteed (for both user and
kernel space). Allocation on a first-come-first-serve basis, no
priorities for register requests and hence no pre-emption of requests.

In short the available debug registers are divided into:

# of debug registers = # of kernel-space requests + MAX(# of all
user-space requests) + freely available debug registers.

Thus on an x86 system with 4 debug registers, if there exists 1
kernel-space request it consumes one debug register on all CPUs in the
system. The remaining 3 debug registers can be consumed by user-space
i.e. upto 3 user-space requests per-thread.

There is no restriction on how many debug registers can be consumed by
the kernel- or user-space requests and it is entirely dependent on the
number of free registers available for use then.

Thanks,
K.Prasad

