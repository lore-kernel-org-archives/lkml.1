Return-Path: <linux-kernel-owner+w=401wt.eu-S1760850AbXKTX1K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760850AbXKTX1K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 18:27:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756673AbXKTX0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 18:26:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58301 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579AbXKTX0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 18:26:53 -0500
Message-ID: <47436D07.2070203@zytor.com>
Date: Tue, 20 Nov 2007 15:25:59 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Zach Brown <zach.brown@oracle.com>, Ulrich Drepper <drepper@redhat.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, tglx@linutronix.de,
       torvalds@linux-foundation.org
Subject: Re: [PATCHv4 5/6] Allow setting O_NONBLOCK flag for new sockets
References: <200711200653.lAK6rE6B025891@devserv.devel.redhat.com> <20071119.235944.82120402.davem@davemloft.net> <474305A5.7070100@redhat.com> <474323CA.9030306@zytor.com> <47432666.6070503@oracle.com> <474331B7.6020802@zytor.com> <20071120222227.GH24156@elte.hu>
In-Reply-To: <20071120222227.GH24156@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> do you suggest that extending the system call calling convention to 
> include an arbitrary number of parameters will solve all these API needs 
> we have at the moment?
> 
> if yes, then a one-shot syslet/async call would in essence be:
> 
> 	syslet_arg1 ... N, syscall_arg 1 ... M
> 
> the same is true for the indirect stuff, we in essence nest syscalls 
> inside another syscall:
> 
> 	sys_indirect arg1 ... N, syscall arg 1 ... M
> 
> this all assumes an arbitrarily extendable syscall ABI, which can take 
> N+M parameters. Right?
> 
> i'm not entirely sure we really want to do this. Nested syscalls would 
> have to unpack the arguments and repack them into a kernel-internal call 
> format anyway. So there's no performance upside - in fact i can only see 
> additional complications.

Forget about indirection for the moment.  Let's first look at the need 
of plain system calls.

> Why not just pin down the current ABI that there's 6 syscall parameters 
> _and not more_?

Because we have already violated it.  There are system calls that need 
more than 6 arguments: we need *a* convention.  Worse, we're not 
actually talking 6 *arguments*, we're talking 6 *words*; on 32-bit 
platforms a single argument can occupy two words.

Uli talks about the need to adding additional system calls with 
parameters, and suggests "back-dooring" them via the sys_indirect interface.

pselect introduced the convention that to take more than 6 arguments, 
the 6th argument register contains a pointer into a user-space memory 
area which contains the real arguments 6 and above.  This is a simple 
convention, which can be trivially executed as a rule set.  Furthermore, 
*with some care* it can be mapped 1:1 onto the C calling convention by 
system-call-generic code, as opposed to needing system-call-specific 
stubs to marshall parameters.

Now, if you execute that asynchronously, you of course need to make sure 
that userspace doesn't clobber those additional arguments, so you would 
have to save them away or otherwise restrict userspace from reclaiming this.

** This is the situation as it stands today, and any solution needs to 
take this into account. **

> It's totally sensible, and indirection has some minimal 
> costs anyway, so copying the nested syscall parameters is a non-issue. 
> This is not ad-hoc and when i wrote syslets i actually profiled the 
> performance a variable-length calling convention and decided _against_ 
> it. Nothing beats the performance of a straight fixd-length copy of 6x4 
> (or 6x8) bytes.
> 
> The memory access cost argument you mentioned is largely irrelevant and 
> inapposite here, this is all passed in on the stack which is well-cached 
> in the L1 cache.

What I'm objecting to, strongly, is the use of this syslets-style 
indirection for unrelated purposes, such as modifying the behaviour of 
existing system calls.  The sys_indirect call, as far as I understand 
it, basically is a way to inject commands into a separate 
hyper-lightweight thread of kernel execution.  That's fine so far.

However, proposing that we should have system calls (call a spade a 
spade) which can ONLY be accessed via this indirection interface is bad 
interface design at best and something much stronger at worst.  What we 
have done in the past when we want to add new parameters to a system 
call is that we assign it a new system call number, and point the old 
system call number to a thunk which sets the new parameters to specific 
default values and then tailcalls the new system call.  This is a very 
straightforward thing to do, and imposes any costs at all only on users 
of the legacy system call number -- and then they are only a handful of 
instructions.

	-hpa
