Return-Path: <linux-kernel-owner+w=401wt.eu-S1753335AbZLAGnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335AbZLAGnA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 01:43:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752150AbZLAGm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 01:42:59 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:17402 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbZLAGm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 01:42:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KVgLWDoXwR8EE4SlUljiV7N7XTwDGhEcQeD3MoeIJhb4fiVrMmJgazcsAtjZ+T97d5
         Be1f05WkHUMIk27UEi7JxsfuzSZeNedZVTPK5WmL4ygdTF6LQ/tLujwWSaPjJ7J/16q8
         61qvPJoIjPMbH+RmvifFKYs2Hc8OcylzwA3tQ=
Date: Tue, 1 Dec 2009 07:43:05 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Jan Kiszka <jan.kiszka@web.de>,
       Jiri Slaby <jirislaby@gmail.com>, Avi Kivity <avi@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [GIT PULL v6] hw-breakpoints: Rewrite on top of perf events v6
Message-ID: <20091201064302.GB5063@nowhere>
References: <1257694141-5670-1-git-send-email-fweisbec@gmail.com> <20091124094421.GA3468@in.ibm.com> <20091124101342.GB5570@elte.hu> <20091124132127.GA5355@in.ibm.com> <20091126055903.GB5649@nowhere> <20091127190705.GB18408@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091127190705.GB18408@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 28, 2009 at 12:37:05AM +0530, K.Prasad wrote:
> I think the register_<> interfaces can become wrappers around functions
> that do the following:
> 
> - arch_validate(): Validate request by invoking an arch-dependant
>   routine. Proceed if returned valid.
> - arch-specific debugreg availability: Do something like
>   if (arch_hw_breakpoint_availabile())
> 	bp = perf_event_create_kernel_counter();


The current state is settled for Bp Api clients
(perf_event_create_kernel_counter()) and perf clients (perf syscall)
to have the same endpoint, which is the arch_validate() + reg reservation.
This is already what is done. It's just done at the pmu level.

I don't understand your point.


>   perf_event_create_kernel_counter()--->arch_install_hw_breakpoint();


But this is what is done, when perf_event_alloc() get the breakpoint
pmu.


> This way, all book-keeping related work (no. of pinned/flexible/per-cpu)
> will be moved to arch-specific files (will be helpful for PPC Book-E
> implementation having two types of debug registers). Every new
> architecture that intends to port to the new hw-breakpoint
> implementation must define their arch_validate(),
> arch_hw_breakpoint_available() and an arch_install_hw_breakpoint(),
> while the hw-breakpoint code will be flexible enough to extend itself to
> each of these archs.


We just need to move reserve_bp_slot() and release_bp_slot() in arch code
then.

But I would prefer to move more efforts in generalizing what can
generalized in the register reservation topic, and have the smallest
possible part in arch code.


> This implementation would be even superior (in terms of extensibility)
> to even the older hw-breakpoint layer implementation (despite it providing
> a working layer for x86 and PPC64).


The older breakpoint API was very tight to x86. It had a single linear
breakpoint refcounting that wasn't handling different natures of breakpoint
registers (different registers between instruction and data).
Neither was this linear refcounting handling the fact a single cpu could
share a single breakpoint register between hardware threads.

So, no I don't think it was providing a working layer for PPC64.

That said the current state of the constraints sucks :) as it is too much
tight to x86 too.

But I want to avoid the trap of moving all the constraint checks
to the arch. If possible, I would like to extract the arch specificity
only.
It's possible that in the case of PPC64, we want a totally different
constraint check, but what about other archs? Do they have very close
needs than x86 or another bunck of tricky constraints? In the former
case, I would prefer to have the current constraints defined as
__weak and let the tricky archs implement their own constraints.
That will only work if the _tricky_ arch are a minority of course.


> > > As pointed out in 20091111130207.GA5676@in.ibm.com and
> > > 20091112042502.GA3145@in.ibm.com, ptrace requests can a) lose register
> > > slots when modifying the breakpoint addresses and b) new implementation
> > > assumes that every DR7 write to be preceded by a write on DR0-DR3 which
> > > need not be true.
> > 
> > The a) case is going to be fixed.
> > But the b) situation must be reported as a user mistake (which is what is
> > done currently): -EINVAL, -EIO or whatever. Enabling a breakpoint without
> > having given an address is a userland bug.
> > 
> 
> b) need not be a user mistake always (except perhaps the first time). As I
> mentioned here 20091112042502.GA3145@in.ibm.com, DR7 enable/disable
> without a DR0-DR3 write can be done by the user through ptrace for
> optimising the number of write operations (and hence ptrace syscalls).


I really think this is a wrong workflow as the address register
is undefined.

I think this is a user bug. In the current upstream state, I guess
the addr debugreg are initialized to 0. So is this going to
set a breakpoint to 0?

I doubt there are much user app that rely on such buggy behaviour,
but I can probably support that by creating a temporary disabled
breakpoint in this case.


 
> Consider the following steps which is entirely valid (in mainline ptrace)
> but which would fail if assumed that a DR0-DR3 write precedes a DR7 write:
> i) Set address on DR0
> ii) Enable bits corresponding to DR0 in DR7
> iii) Disable DR0 bits in DR7
> iv) Re-enable DR0 bits in DR7


Agreed. I need to fix this. I thought you were talking about enabling
dr0 in dr7 without having ever set dr0.

Ok I'll fix this case.

Thanks.

