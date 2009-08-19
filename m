Return-Path: <linux-kernel-owner+w=401wt.eu-S1752440AbZHSRdF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440AbZHSRdF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 13:33:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752073AbZHSRdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 13:33:04 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:36173 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbZHSRdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 13:33:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BJJeAUQ54+F/6zWOHcKVsItyK416vbzGaRQKjPuy8RzY1swxtc1jUhwuPCcW5vr4AU
         Vp/LqRP8uaMaHg0Q//gc3yoT39YG1GdLNk9zbr9EFy6CKlN7GkGmKzbZgzTzqoxCmjHX
         18DtAlRbGelpsvTxNdw9HVQb0Hy1ApAiFkhNs=
Date: Wed, 19 Aug 2009 19:33:00 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Patch 0/1] HW-BKPT: Allow per-cpu kernel-space Hardware
	Breakpoint requests
Message-ID: <20090819173259.GF4972@nowhere>
References: <20090817124641.GA13354@in.ibm.com> <20090819161119.GA3633@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090819161119.GA3633@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 19, 2009 at 09:41:19PM +0530, K.Prasad wrote:
> On Mon, Aug 17, 2009 at 06:16:41PM +0530, K.Prasad wrote:
> > Hi All,
> > 	Please find a patch that enables kernel-space breakpoints to be
> > requested for a subset of the available CPUs in the system. This allows
> > per-CPU breakpoints and comes with the associated benefit of reduced
> > overhead during (un)registration.
> > 
> > This enhancement allows exploitation of hardware breakpoint registers by
> > 'perf' which produces a CPU-wise information.
> > 
> > Design changes
> > --------------
> > - Every breakpoint request 'consumes' the first available debug register
> >   (starting from HBP_NUM) in each CPU represented by 'cpumask' field in
> >   'struct hw_breakpoint'.
> > 
> > - 'hbp_kernel_pos' (that separates kernel-space breakpoints from the
> >   free/user-space breakpoints) now points to the maximum of debug
> >   registers consumed on any given CPU.
> >   -- 'hbp_kernel_pos' is decremented (one-at-a-time) to allow a new-slot
> >      for kernel-space requests iff all debug registers on the given CPU
> >      (from HBP_NUM - 1 to 'hbp_kernel_pos' are already consumed.
> >   -- 'hbp_kernel_pos' is incremented (one-at-a-time) to free a slot iff
> >      a removal request results in the release of a bkpt request that
> >      consumed maximum debug registers for kernel-space.
> > 
> > - Every removal request results in compaction of breakpoint registers
> >   (on a per-cpu basis) to occupy the vacant debug register.
> >  
> > The patch is based on commit b6c720b811aed0eeda89f277f13c1bd1bdf721fd of
> > -tip tree and has been tested to work fine on an x86 machine for both
> > cases (i.e. system-wide kernel breakpoints and bkpts for a subset of CPUs).
> > 
> > Please let me know your comments on the same.
> > 
> > Thanks,
> > K.Prasad
> > 
> 
> Hi Frederic,
> 	Do you find these patches, that provide the ability to restrict
> kernel-space breakpoints to any given subset of CPUs, to bring the
> requisite features for exploitation of hw-bkpt by 'perf tools'?
> 
> Also of interest would be the reduced overhead associated with
> (un)register_kernel_hw_breakpoint() operations (no IPI in case of
> single-CPU breakpoint request).
> 
> Thanks,
> K.Prasad
> 


Nice.
Yeah I just reviewed the patch and it looks good.

Now I guess we should meet two others requirements for a pmu
through this high level Api:

- only update the hardware registers when needed: while switching
  to another thread of a same group, the hardware register switching
  is wasteful.
  BTW, I wonder if we need a flag while creating a user bp that tells whether
  the bp is inherited through fork/clone calls.

- having a callback that quickly swap two breakpoints in order to support
  the hardware register multiplexing. I guess the pmu object would just need
  to call it when the multiplexing is decided.


Providing those would let us build a pmu struct on top of this high level API,
hopefully.

All that would be a benefit in both sides. It avoids us building a low level PMU
that reinvent the wheel, ie: the hardware breakpoints API handles a lot of things
both in arch and core sides (debug register setting tricks with dr7 and co,
cpu hotplug, kexec, etc...).
In the bp API it brings more power (register switching only if needed, per cpu
support, clone inheritance support, etc...)

And in the end we have a pmu (which unifies the control of this profiling
unit through a well established and known object for perfcounter) controlled by
a high level API that could also benefit to other debugging subsystems.

What do you think?
It would be also nice to have Peter's and Ingo opinion about it, to be sure
we are not going in the wrong direction.

Thanks.

