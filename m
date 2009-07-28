Return-Path: <linux-kernel-owner+w=401wt.eu-S1753012AbZG1BD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012AbZG1BD5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 21:03:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752952AbZG1BD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 21:03:56 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:53153 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922AbZG1BDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 21:03:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=js1EWxEl2Tx7Oz4Gq7nawtaxoYk1dPA4sHyDOypn0RVpeWYPh5nWxbXTi65DeiVCN3
         dQOU9fDoKfLsSRwmgTeCRz4Ee6zw3s+tciJLPH/di3Lkg+s6z+9Pdvwj3hYeMSGFD5op
         cE8JXHEHvGUbzfNb9seuz3DyDCNAZPUPOVRsc=
Date: Tue, 28 Jul 2009 03:03:50 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: prasad@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
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
Message-ID: <20090728010349.GB5147@nowhere>
References: <1248109687-7808-6-git-send-email-fweisbec@gmail.com> <1248354493.26273.2.camel@twins> <c62985530907240702h2b2de14bw2f0d475f46067e4e@mail.gmail.com> <1248445569.6987.74.camel@twins> <20090724174723.GA11985@nowhere> <1248519416.5780.12.camel@laptop> <20090725141918.GA5295@nowhere> <1248538972.5780.25.camel@laptop> <20090725235702.GA5082@in.ibm.com> <1248684817.6987.1573.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248684817.6987.1573.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


Hmm, indeed. The breakpoint api lacks these services for perf counter,
although targetting specific cpus seems a (somewhat) trivial add-on to me on the
bp API.

Also I forgot the kernel-only profiling things.

 
> Secondly, perf counters wants to schedule the per task breakpoints
> because we can optimize the context switch, saving lots of these MSR
> writes under some common scenarios.


Ok with that.
But if you have an efficient pmu scheduling, it may be still interesting
to make it a seperate core entity. The bp API may find some profit in it.

The breakpoint registers also require specific treatments with several registers
magic, all organized inside the arch API which also cares about cpu hotplug and
kexec things.


> Thirdly, we can multiplex perf counters beyond their hardware maximum,
> something you simply cannot do for a debug interface.


Again, I'm stuck in what you mean by multiplexing here :-)


> Like I said, please use the raw per-cpu breakpoint interface for perf
> counters and connect that with the minimally required reservation you
> need to make your other thing work.
>
> You simply cannot put perf-counter breakpoints on top of whatever virt
> layer you created going by what you say it is.


Well, indeed it seems perfcounter handles the counters to cover very specific
needs, uncovered by the debug API we have.
I guess we can create a struct pmu for the breakpoints and plug it with
some low level add-on in the breakpoint API.

