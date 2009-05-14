Return-Path: <linux-kernel-owner+w=401wt.eu-S1752468AbZENRgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468AbZENRgg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 13:36:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752789AbZENRgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 13:36:14 -0400
Received: from gw.goop.org ([64.81.55.164]:55149 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752566AbZENRgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 13:36:13 -0400
Message-ID: <4A0C568B.7070907@goop.org>
Date: Thu, 14 May 2009 10:36:11 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, "Xin, Xiaohui" <xiaohui.xin@intel.com>,
       "Li, Xin" <xin.li@intel.com>, "Nakajima, Jun" <jun.nakajima@intel.com>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: Performance overhead of paravirt_ops on native identified
References: <4A0B62F7.5030802@goop.org> <4A0B6F9C.4060405@zytor.com>
In-Reply-To: <4A0B6F9C.4060405@zytor.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> The other obvious option, it would seem to me, would be to eliminate the
> *inner* call/return pair, i.e. merging the _spin_lock setup code in with
> the internals of each available implementation (in the case above,
> __ticket_spin_lock).  This is effectively what happens on native.  The
> one problem with that is that every callsite now becomes a patching target.
>   

Yes, that's an option.  It has the downside of requiring changes to the 
common spinlock code in kernel/spinlock.c and linux/spinlock_api*.h.   
The amount of duplicated code is potentially quite large, but there 
aren't that many spinlock implementations.

Also, there's not much point in using pv spinlocks when all the 
instrumentation is on.  Lock contention metering, for example, never 
does a proper lock operation, but does a spin with repeated trylocks; we 
can't optimise that, so there's no point in trying.

So maybe if we can fast-path the fast-path to pv spinlocks, the problem 
is more tractable...

> That brings me to a somewhat half-arsed thought I have been walking
> around with for a while.
>
> Consider a paravirt -- or for that matter any other call which is
> runtime-static; this isn't just limited to paravirt -- function which
> looks to the C compiler just like any other external function -- no
> indirection.  We can point it by default to a function which is really
> just an indirect jump to the appropriate handler, that handles the
> prepatching case.  However, a linktime pass over vmlinux.o can find all
> the points where this function is called, and turn it into a list of
> patch sites(*).  The advantages are:
>
> 1. [minor] no additional nop padding due to indirect function calls.
> 2. [major] no need for a ton of wrapper macros manifest in the code.
>
> paravirt_ops that turn into pure inline code in the native case is
> obviously another ball of wax entirely; there inline assembly wrappers
> are simply unavoidable.
>   

We did consider something like this at the outset.  As I remember, there 
were a few concerns:

    * There was no relocation data available in the kernel.  I played
      around with ways to make it work, but they ended up being fairly
      complex and brittle, with a tendency (of course) to trigger
      binutils bugs.  Maybe that has changed.
    * We didn't really want to implement two separate mechanisms for the
      same thing.  Given that we wanted to inline things like
      cli/sti/pushf/popf, we needed to have something capable of full
      patching.  Having a separate mechanisms for patching calls is
      harder to justify.  Now that pvops is well settled, perhaps it
      makes sense to consider adding another more general patching
      mechanism to avoid the indirect calls (a dynamic linker, essentially).

I won't make any great claims about the beauty of the PV_CALL* gunk, but 
at the very least it is contained within paravirt.h.

> (*) if patching code on SMP was cheaper, we could actually do this
> lazily, and wouldn't have to store a list of patch sites.  I don't feel
> brave enough to go down that route.
>   

The problem that the tracepoints people were trying to solve was harder, 
where they wanted to replace an arbitrary set of instructions with some 
other arbitrary instructions (or a call) - that would need some kind SMP 
synchronization, both for general sanity and to keep the Intel rules happy.

In theory relinking a call should just be a single word write into the 
instruction, but I don't know if that gets into undefined territory or 
not.  On older P4 systems it would end up blowing away the trace cache 
on all cpus when you write to code like that, so you'd want to be sure 
that your references are getting resolved fairly quickly.  But its hard 
to see how patching the offset in a call instruction would end up 
calling something other than the old or new function.

    J
