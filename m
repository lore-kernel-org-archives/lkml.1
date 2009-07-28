Return-Path: <linux-kernel-owner+w=401wt.eu-S1754730AbZG1QMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730AbZG1QMe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 12:12:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754548AbZG1QMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 12:12:34 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:35865 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754687AbZG1QMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 12:12:33 -0400
Date: Tue, 28 Jul 2009 21:42:19 +0530
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
Message-ID: <20090728161218.GA3526@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <1248109687-7808-6-git-send-email-fweisbec@gmail.com> <1248354493.26273.2.camel@twins> <c62985530907240702h2b2de14bw2f0d475f46067e4e@mail.gmail.com> <1248445569.6987.74.camel@twins> <20090724174723.GA11985@nowhere> <1248519416.5780.12.camel@laptop> <20090725141918.GA5295@nowhere> <1248538972.5780.25.camel@laptop> <20090725235702.GA5082@in.ibm.com> <1248684817.6987.1573.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248684817.6987.1573.camel@twins>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 27, 2009 at 10:53:37AM +0200, Peter Zijlstra wrote:
> On Sun, 2009-07-26 at 05:27 +0530, K.Prasad wrote:
> 
> > I don't claim to have understood the requirements of perf-counters
> > fully, but I sense the persistence of a few doubts about the register
> > allocation mechanism of the hw-breakpoints API...thought it might be
> > worthwhile to briefly explain.
> > 
> > A few notes about the same:
> > 
> > Kernel-space breakpoints: They are system-wide i.e. one kernel-space
> > breakpoint request consumes one debug register on 'all' CPUs of the
> > system.
> > User-space breakpoints: Requests are stored in per-thread data
> > structures. Written onto the debug register only when scheduled-into
> > the CPU, and are removed when another task using the debug registers is
> > scheduled onto the CPU.
> > Debug register allocation mechanism: register request succeeds only when
> > the availability of a debug register is guaranteed (for both user and
> > kernel space). Allocation on a first-come-first-serve basis, no
> > priorities for register requests and hence no pre-emption of requests.
> > 
> > In short the available debug registers are divided into:
> > 
> > # of debug registers = # of kernel-space requests + MAX(# of all
> > user-space requests) + freely available debug registers.
> > 
> > Thus on an x86 system with 4 debug registers, if there exists 1
> > kernel-space request it consumes one debug register on all CPUs in the
> > system. The remaining 3 debug registers can be consumed by user-space
> > i.e. upto 3 user-space requests per-thread.
> > 
> > There is no restriction on how many debug registers can be consumed by
> > the kernel- or user-space requests and it is entirely dependent on the
> > number of free registers available for use then.
> 
> Right, this is an utter miss-match for what perf counters would want.
> 

> Firstly, you seem to have this weird split of kernel/userspace
> breakpoints. Perf counters looks at things in a per-cpu fashion, so the
> all-cpus kernel breakpoint stuff is useless. Also, from perf counters'
> POV its perfectly reasonable to have a per-task kernel breakpoint.
> 

Although the existing implementation of hw-breakpoint API doesn't
support per-task kernel-space breakpoints, it isn't very difficult to
extend it to do so.

We could change the breakpoint infrastructure to something like this:

kernel-space breakpoints:
kernel-space addresses, system-wide i.e. on all CPUs, persist till explicit
unregistration, consume 1 debug register always.

New per-task breakpoints (i.e. modified user-space breakpoints):
accepts kernel- or user-space addresses, enabled per-task, consumes 1 debug
register (only when task is scheduled on the CPU), releases debug register
when yielding the CPU.

> Secondly, perf counters wants to schedule the per task breakpoints
> because we can optimize the context switch, saving lots of these MSR
> writes under some common scenarios.
> 

perf counters can continue to schedule per-task breakpoints -
enabling/disabling a breakpoint would require a call to the
'register'/'unregister' interface and since it is per-cpu it is
light-weight when compared to system-wide breakpoints (that require IPIs
for propagation).

The common breakpoints can be identified and exempted from yielding the
debug registers (i.e. from the unregister-->register cycle) in the
perf-counter code.

As a side note, I'm not sure if extra-polating (linearly?) the debug
register's "hit counter" value is a good idea. While a function may cause
several 'write' operations on a variable (say due to a loop statement) for
once, it may not exhibit similar behaviour throughout the time-slice of the
program's execution. Scaling the values may lead to incorrect results.

> Thirdly, we can multiplex perf counters beyond their hardware maximum,
> something you simply cannot do for a debug interface.
> 

I suppose that you are referring to the RR scheduling of breakpoints and
scaling of results? It can be achieved in the manner as explained above.

> Like I said, please use the raw per-cpu breakpoint interface for perf
> counters and connect that with the minimally required reservation you
> need to make your other thing work.
> 
> You simply cannot put perf-counter breakpoints on top of whatever virt
> layer you created going by what you say it is.
>

One of the design goals of the hw-breakpoint API is to provide a layer
of arbitration between various consumers of the physical debug register.
We should be able to extend the API to meet the demands of new users
with unique requirements (if not supported already), and the description
above broadly describe them for perf-counters.

If agreeable, I'll submit a patch that modifies the user-space
breakpoints into a per-task one. Frederic may want to base the
perf-counter integration code on the proposed interface.

Let me know what your thoughts on the same.

Thanks,
K.Prasad


