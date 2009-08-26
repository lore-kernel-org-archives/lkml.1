Return-Path: <linux-kernel-owner+w=401wt.eu-S1752580AbZHZSCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580AbZHZSCw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 14:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbZHZSCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 14:02:51 -0400
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:37211 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564AbZHZSCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 14:02:50 -0400
Date: Wed, 26 Aug 2009 23:32:45 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Patch 0/1] HW-BKPT: Allow per-cpu kernel-space Hardware
	Breakpoint requests
Message-ID: <20090826180245.GA4438@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20090817124641.GA13354@in.ibm.com> <20090819161119.GA3633@in.ibm.com> <20090819173259.GF4972@nowhere> <20090820172719.GA16499@in.ibm.com> <20090821142811.GF11098@elte.hu> <20090826033637.GB6245@nowhere> <20090826091642.GB7743@elte.hu> <20090826114954.GA6009@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090826114954.GA6009@nowhere>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 26, 2009 at 01:49:57PM +0200, Frederic Weisbecker wrote:
> On Wed, Aug 26, 2009 at 11:16:42AM +0200, Ingo Molnar wrote:
> > 
> > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > 
> > > On Fri, Aug 21, 2009 at 04:28:11PM +0200, Ingo Molnar wrote:
> > > > 
> > > > * K.Prasad <prasad@linux.vnet.ibm.com> wrote:
> > > > 
> > > > > > Providing those would let us build a pmu struct on top of this 
> > > > > > high level API, hopefully.
> > > > 
> > > > Note that there's a PMU struct already in 
> > > > arch/x86/kernel/cpu/perf_counter.c. Could debug-register ops be 
> > > > tacked on to it?
> > > 
> > > No, we don't need to build an arch level pmu since the BP api 
> > > already handles the arch abstraction (or well, it is planned to).
> > > 
> > > Instead, what we need is a core pmu that relies on the BP api. 
> > > Such pmu will be allocated dynamically while creating a hardware 
> > > breakpoint counter.
> > 
> > i'm not convinced at all we need all that layering of 
> > perfcounters->pmu->BP. Why not add BP support to the PMU abstraction 
> > and be done with it?
> > 
> > That way we get hardware breakpoints via 'pinned, exclusive, per cpu 
> > hw-breakpoint counters' for example and kernel/hw-breakpoint.c can 
> > go away altogether.
> > 
> > kernel/perf_counter.c already handles scheduling, conflict 
> > resolution, enumeration, syscall exposure and more.
> > 
> > Hm?
> 
> 
> What you are suggesting is a complete refactoring of the breakpoint API
> on top of pmus.
> 
> Well, that's possible and would factorize the scheduling, conflict and so
> on. So that's theoretically a good point and I hope we'll come to such
> centralization, that looks like my suggestion to Peter to share the
> perfcounter layer that handles the scheduling of hardware registers.
> 
> But the pmu handling is currently not ready for that.

I am not sure if pmus can handle, (or want to handle) all the intricacies
involved with the hw-breakpoint layer and let the other in-kernel users of
hw-breakpoint such as ptrace and ftrace (at the moment) operate over it.

The hw-breakpoint infrastructure has now grown to address nearly all
requirements of perf-tools (barring the facility to schedule
over-committed breakpoint requests, and a pending enable/disable
feature) while its interoperability allows co-existence of other users.

Given that there are multiple users of hw-breakpoint and that it is a
contended resource (with diversity in breakpoint characteristics)
wouldn't it be best to leave its management in a layer well below all
its users (including perf/pmu)?

That, in my opinion, would help the hw-breakpoint infrastructure evolve
continuously to help the users exploit the debug registers better.

Thanks,
K.Prasad

