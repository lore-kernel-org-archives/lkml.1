Return-Path: <linux-kernel-owner+w=401wt.eu-S1759693AbZCMTBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759693AbZCMTBf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 15:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755233AbZCMTB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 15:01:27 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:50989 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755012AbZCMTB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 15:01:26 -0400
Date: Sat, 14 Mar 2009 00:31:13 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alan Stern <stern@rowland.harvard.edu>, Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 02/11] x86 architecture implementation of Hardware
	Breakpoint interfaces
Message-ID: <20090313190113.GA15614@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20090313034301.GE11355@elte.hu> <Pine.LNX.4.44L0.0903130959400.2898-100000@iolanthe.rowland.org> <20090313141304.GB12591@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090313141304.GB12591@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 13, 2009 at 03:13:04PM +0100, Ingo Molnar wrote:
> 
> * Alan Stern <stern@rowland.harvard.edu> wrote:
> 
> > On Fri, 13 Mar 2009, Ingo Molnar wrote:
> > 
> > > The core issue being discussed is the debug register 
> > > allocation and scheduling model though, and you have not 
> > > directly commented on that.
> > > 
> > > My argument in a nutshell is that a bottom-up for user + 
> > > top-down for kernel use static allocator with no dynamic 
> > > scheduling will get us most of the benefits with a tenth of 
> > > the complexity.
> > 
> > Take this even farther: We shouldn't restrict userspace to 
> > bottom-up register allocation.  With very little additional 
> > effort we can virtualize the debug registers; then userspace 
> > can allocate them in whatever order it wants and still end up 
> > using the physical registers in bottom-up order (or top-down, 
> > which is the order used by the current patches).
> > 
> > After all, there's nothing to prevent programs other than gdb 
> > from using ptrace, and there's no guarantee that gdb will 
> > continue to allocate registers in increasing order.
> 
> If in ~10 years of its existence no such usage arose so i dont 
> think it will magically appear now.
> 
> The thing is, kernel-side use of debug registers is a borderline 
> item whose impact we should minimalize as much as possible. 
> Linus in the past expressed that it is fine to not have _any_ 
> management of user versus kernel debug registers. So we want to 
> approach this from the minimalistic side. I offered such a very 
> minimal design that is trivial in terms of correctness and 
> impact.
> 
> We can still get this simple allocation model into .30 if we 
> dont waste time arguing about unnecessarily. If someone runs 
> into limitations the model can be extended.
> 
> 	Ingo

Here's a summary of the intended changes to the patchset, which I hope
to post early the following week. It tears down many features in the
present submission (The write-up below is done without the benefit of
actually having run into limitations while trying to chisel out code).

- Adopt a static allocation method for registers, say FCFS (and perhaps
  botton-up for user-space allocations and the reverse for
  kernel-space), although individual counters to do book-keeping should also
  suffice.

- Use an array of HB_NUM size for storing the breakpoint requests (and
  not a linked-list implementation as done now).

- Define a HAVE_HW_BREAKPOINTS in arch/x86/Kconfig unconditionally, but
  build kernel/hw_breakpoint.o, samples/hw_breakpoint/data_breakpoint.o
  and kernel/trace/trace_ksym.o build conditionally if
  HAVE_HW_BREAKPOINTS is declared. Declaring this flag will help
  a)prevent build failures in other archs b)Prevent ftrace from showing
  up availability of kernel symbol tracing even in unsupported archs.

- Simplify the switch_to_thread_hw_breakpoint() function (any help from
  Alan Stern here would be gladly accepted).

- Remove callbacks such as unregister/register.

- remove the code to implement prioritisation of requests

- Add histogram support to include a 'hit counter' to the traced kernel
  symbols.

- Address coding-style related comments.

Hope they are not in sync with the comments received thus far. Let me
know if there are changes to be made.

Thanks,
K.Prasad

