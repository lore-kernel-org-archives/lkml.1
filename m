Return-Path: <linux-kernel-owner+w=401wt.eu-S1756556AbXEQUjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556AbXEQUjR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 16:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754732AbXEQUjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 16:39:08 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49949 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754315AbXEQUjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 16:39:07 -0400
Date: Thu, 17 May 2007 16:39:03 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Roland McGrath <roland@redhat.com>
cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] hwbkpt: Hardware breakpoints (was Kwatch)
In-Reply-To: <20070513103951.413A11F8516@magilla.localdomain>
Message-ID: <Pine.LNX.4.44L0.0705171606480.6623-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 May 2007, Roland McGrath wrote:

> You may need some memory barriers around the switching/restart stuff.
> In fact, I think it would be better not to delve into reinventing the
> low-level bits there at all.  Instead use read_seqcount_retry there
> (linux/seqlock.h).  Using that read_seqcount_begin's value as the
> number to compare in thbi would also give a 32-bit sequence number.

I took a look at seqlock.h.  It turns out not to be a good match for my 
requirements; the header file specifically says that it won't work with 
data that contains pointers.  But changing over to regular 32-bit 
sequence numbers was straightforward.

The "switching"/"restart" stuff doesn't need memory barriers because
all the communication is between two routines on the same CPU.  Nor are 
memory barriers needed in the rest of the code for the kernel 
breakpoint updates; the IPI mechanism already provides its own.

However there is one oddball case which does seem to require a memory
barrier: when a new CPU comes online (either for the first time or
during return from hibernation).  There's a hook to load the initial
debug register values, and it runs in an atomic context so I can't
grab the mutex.  The hook is called in two places:

	arch/i386/power/cpu.c: fix_processor_context(), and
	arch/i386/kernel/smpboot.c: start_secondary().

A memory barrier is necessary to avoid chaos if another CPU should
happen to update the kernel breakpoint settings at the same time.  If
you can suggest a way around it, please do.

> It looks to me like there is quite a lot to be shared.  Of course the
> code can refer to constants like HB_NUM, they just have to be defined
> per machine.  The dr7 stuff can all be a couple of simple arch_foo
> hooks, which will be empty on other machines.  All of the list-managing
> logic, the prio stuff, etc., would be bad to copy.
> 
> The two flavors could probably be accomodated cleanly with an
> HB_TYPES_NUM macro that's 1 on x86 and 2 on ia64, and is used in loops
> around some of the calls.  I'm not suggesting you try to figure out
> that code structure ahead of time.  But I don't think it will be a big
> barrier to code sharing.

Okay, if I don't worry about machines with two sets of code & data
debug registers (HB_TYPES_NUM = 2) then yes, quite a lot of the code is
sharable.  There will be a few arch-specific hooks to:

	Store the values into the debug registers;

	Take care of the DR7 calculations;

	Do address limit verification (see whether a pointer
	lies in user space or kernel space).

Nothing more seems to be needed.  Then there will be unsharable code, 
including:

	Dumping the debug registers while creating an aout-type
	core image;

	All the legacy ptrace stuff;

	The notify-handler itself.

Does all that sound about right?  

> I also want to get this machine-independent code sharing going for
> real.  I'd like to have powerpc working as the non-x86 demonstration
> before we declare things in good shape.  I don't expect you to write
> any powerpc support, but I hope I can get you to do the arch code
> separation to make the way for it.  If you'll take a crack at it, I'll
> fill in and test the powerpc bits and I think we'll get something very
> satisfactory ironed out pretty fast.  

How should this be arranged so that it can build okay on all platforms,
even ones where the low-level support code hasn't been written?  Maybe 
an arch-dependent CONFIG_HW_BREAKPOINT option?

Alan Stern

