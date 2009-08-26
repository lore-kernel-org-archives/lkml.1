Return-Path: <linux-kernel-owner+w=401wt.eu-S1756696AbZHZLuD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696AbZHZLuD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 07:50:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756509AbZHZLuC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 07:50:02 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:42308 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756523AbZHZLuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 07:50:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=o059QXWfJVRFuv2E0S5PO/RWFqZ37a0XOWVUj5U6PZZLxzpwePO4uCkdPnuD/idTHc
         7MoVvoPAtf3AxEohXlI+fvLmlogCOaV8mNgubVEQdnPPA0kNXsX5JreIz73OQ9/o/c+T
         U0dLX2BR8O2/YnLTqyQ/dSD3eKErNBvRltEsc=
Date: Wed, 26 Aug 2009 13:49:57 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Patch 0/1] HW-BKPT: Allow per-cpu kernel-space Hardware
	Breakpoint requests
Message-ID: <20090826114954.GA6009@nowhere>
References: <20090817124641.GA13354@in.ibm.com> <20090819161119.GA3633@in.ibm.com> <20090819173259.GF4972@nowhere> <20090820172719.GA16499@in.ibm.com> <20090821142811.GF11098@elte.hu> <20090826033637.GB6245@nowhere> <20090826091642.GB7743@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090826091642.GB7743@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 26, 2009 at 11:16:42AM +0200, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > On Fri, Aug 21, 2009 at 04:28:11PM +0200, Ingo Molnar wrote:
> > > 
> > > * K.Prasad <prasad@linux.vnet.ibm.com> wrote:
> > > 
> > > > > Providing those would let us build a pmu struct on top of this 
> > > > > high level API, hopefully.
> > > 
> > > Note that there's a PMU struct already in 
> > > arch/x86/kernel/cpu/perf_counter.c. Could debug-register ops be 
> > > tacked on to it?
> > 
> > No, we don't need to build an arch level pmu since the BP api 
> > already handles the arch abstraction (or well, it is planned to).
> > 
> > Instead, what we need is a core pmu that relies on the BP api. 
> > Such pmu will be allocated dynamically while creating a hardware 
> > breakpoint counter.
> 
> i'm not convinced at all we need all that layering of 
> perfcounters->pmu->BP. Why not add BP support to the PMU abstraction 
> and be done with it?
> 
> That way we get hardware breakpoints via 'pinned, exclusive, per cpu 
> hw-breakpoint counters' for example and kernel/hw-breakpoint.c can 
> go away altogether.
> 
> kernel/perf_counter.c already handles scheduling, conflict 
> resolution, enumeration, syscall exposure and more.
> 
> Hm?


What you are suggesting is a complete refactoring of the breakpoint API
on top of pmus.

Well, that's possible and would factorize the scheduling, conflict and so
on. So that's theoretically a good point and I hope we'll come to such
centralization, that looks like my suggestion to Peter to share the
perfcounter layer that handles the scheduling of hardware registers.

But the pmu handling is currently not ready for that.
For now it's completely tied to perfcounter, the pmu handling must
become completely standalone wrt perfcounter because hardware
breakpoint shouldn't depend on perfcounter.
It couldn't even, because it is not only wanted for perfcounter but
currently used by ptrace (and perhaps some other various users) and
I can't imagine we need to open a perfcounter to use ptrace facilities.

That said, I really agree with the concept, we could then drop the
scheduling bindings for hardware breakpoints and use a centralized
thing for that which would be the pmu.

But:

- the PMUs handling is not ready for that as I explained above
- we still need the hardware breakpoint layer that decodes a breakpoint
  request (address, length of the memory target, number of registers
  limitation). This part is still a mandatory feature to build dynamic
  PMU based breakpoints.

Frederic.

