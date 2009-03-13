Return-Path: <linux-kernel-owner+w=401wt.eu-S1759030AbZCMVVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759030AbZCMVVa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 17:21:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752966AbZCMVVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 17:21:21 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:50699 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751903AbZCMVVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 17:21:20 -0400
Date: Fri, 13 Mar 2009 17:21:18 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
cc: Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 02/11] x86 architecture implementation of Hardware
 Breakpoint interfaces
In-Reply-To: <20090313190113.GA15614@in.ibm.com>
Message-ID: <Pine.LNX.4.44L0.0903131702280.5149-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Mar 2009, K.Prasad wrote:

> Here's a summary of the intended changes to the patchset, which I hope
> to post early the following week. It tears down many features in the
> present submission (The write-up below is done without the benefit of
> actually having run into limitations while trying to chisel out code).
> 
> - Adopt a static allocation method for registers, say FCFS (and perhaps
>   botton-up for user-space allocations and the reverse for
>   kernel-space), although individual counters to do book-keeping should also
>   suffice.

You can't enforce bottom-up allocation for userspace breakpoint
requests.  In fact, you'll have to add a parameter indicating which
debug register is requested.  The ptrace interface will use this
parameter; the utrace interface won't care so it will specify something
like HW_BREAKPOINT_ANY_REGISTER.

You will have to add an array of HB_NUM counters, to keep track of how
many tasks are using each debug register.

> - Use an array of HB_NUM size for storing the breakpoint requests (and
>   not a linked-list implementation as done now).
> 
> - Define a HAVE_HW_BREAKPOINTS in arch/x86/Kconfig unconditionally, but
>   build kernel/hw_breakpoint.o, samples/hw_breakpoint/data_breakpoint.o
>   and kernel/trace/trace_ksym.o build conditionally if
>   HAVE_HW_BREAKPOINTS is declared. Declaring this flag will help
>   a)prevent build failures in other archs b)Prevent ftrace from showing
>   up availability of kernel symbol tracing even in unsupported archs.

This isn't quite right.  At the moment kernel/hw_breakpoint.c isn't
built at all; instead it is #included by the corresponding
arch-specific source file.  Of course, you could change that.

> - Simplify the switch_to_thread_hw_breakpoint() function (any help from
>   Alan Stern here would be gladly accepted).

Sure.  It will depend on how you implement the other changes.

> - Remove callbacks such as unregister/register.
> 
> - remove the code to implement prioritisation of requests

Remove the inline accessors.  They can be added back when they are 
needed.

Some architectures have arbitrary-length debug regions, not 
fixed-length 1, 2, 4, or 8 bytes.  We should give some thought to 
making the interface compatible with such things.

> - Add histogram support to include a 'hit counter' to the traced kernel
>   symbols.
> 
> - Address coding-style related comments.
> 
> Hope they are not in sync with the comments received thus far. Let me
> know if there are changes to be made.

Another change we need to change is the way DR6 is passed to the debug 
notifier chain.  Currently it is passed by value when do_debug() 
calls notify_die().  Instead we need to pass it by reference so that 
the notifier routines can change its value.  Each time a notifier 
routine handles a breakpoint event, the corresponding bit in DR6 should 
be turned off.

Alan Stern

