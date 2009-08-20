Return-Path: <linux-kernel-owner+w=401wt.eu-S1755089AbZHTR1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089AbZHTR1a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 13:27:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755041AbZHTR13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 13:27:29 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:37358 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618AbZHTR12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 13:27:28 -0400
Date: Thu, 20 Aug 2009 22:57:19 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Patch 0/1] HW-BKPT: Allow per-cpu kernel-space Hardware
	Breakpoint requests
Message-ID: <20090820172719.GA16499@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20090817124641.GA13354@in.ibm.com> <20090819161119.GA3633@in.ibm.com> <20090819173259.GF4972@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090819173259.GF4972@nowhere>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 19, 2009 at 07:33:00PM +0200, Frederic Weisbecker wrote:
> On Wed, Aug 19, 2009 at 09:41:19PM +0530, K.Prasad wrote:
> > On Mon, Aug 17, 2009 at 06:16:41PM +0530, K.Prasad wrote:
> > > Hi All,
> > > 	Please find a patch that enables kernel-space breakpoints to be
> > > requested for a subset of the available CPUs in the system. This allows
> > > per-CPU breakpoints and comes with the associated benefit of reduced
> > > overhead during (un)registration.
> > > 
> > > This enhancement allows exploitation of hardware breakpoint registers by
> > > 'perf' which produces a CPU-wise information.
> > > 
[edited]
> > 
> > Hi Frederic,
> > 	Do you find these patches, that provide the ability to restrict
> > kernel-space breakpoints to any given subset of CPUs, to bring the
> > requisite features for exploitation of hw-bkpt by 'perf tools'?
> > 
> > Also of interest would be the reduced overhead associated with
> > (un)register_kernel_hw_breakpoint() operations (no IPI in case of
> > single-CPU breakpoint request).
> > 
> > Thanks,
> > K.Prasad
> > 
> 
> 
> Nice.
> Yeah I just reviewed the patch and it looks good.
> 
> Now I guess we should meet two others requirements for a pmu
> through this high level Api:
> 
> - only update the hardware registers when needed: while switching
>   to another thread of a same group, the hardware register switching
>   is wasteful.
>   BTW, I wonder if we need a flag while creating a user bp that tells whether
>   the bp is inherited through fork/clone calls.
> 

So this means avoiding a re-write of addresses into debug registers when
they don't change. It is indeed desirable and would help if the same
breakpoint is used across, say, many/all threads of a process.

However I'd believe that the time taken for this is miniscule compared
to the overhead involved during context switch. Perhaps consider this
requirement a later time?

> - having a callback that quickly swap two breakpoints in order to support
>   the hardware register multiplexing. I guess the pmu object would just need
>   to call it when the multiplexing is decided.
> 
> 

Are you suggesting something like a modify_kernel_hw_breakpoint() that
can quickly change a breakpoint address/characteristics?

That's quite doable...it requires a quick validation through
arch_validate_hwbkpt_settings() and the requisite IPIs (depending on
what the new cpumask is).

I will send a patch to that effect soon.

> Providing those would let us build a pmu struct on top of this high level API,
> hopefully.
> 
> All that would be a benefit in both sides. It avoids us building a low level PMU
> that reinvent the wheel, ie: the hardware breakpoints API handles a lot of things
> both in arch and core sides (debug register setting tricks with dr7 and co,
> cpu hotplug, kexec, etc...).
> In the bp API it brings more power (register switching only if needed, per cpu
> support, clone inheritance support, etc...)
> 
> And in the end we have a pmu (which unifies the control of this profiling
> unit through a well established and known object for perfcounter) controlled by
> a high level API that could also benefit to other debugging subsystems.
> 
> What do you think?
> It would be also nice to have Peter's and Ingo opinion about it, to be sure
> we are not going in the wrong direction.
> 

Indeed, it will be nice to know from Ingo and Peter that we are heading
right.

Thanks,
K.Prasad

