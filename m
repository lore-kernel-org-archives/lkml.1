Return-Path: <linux-kernel-owner+w=401wt.eu-S1758938AbXK0ATa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758938AbXK0ATa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 19:19:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758258AbXK0AQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 19:16:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50757 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758661AbXK0AQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 19:16:14 -0500
Message-ID: <474B6179.4040508@zytor.com>
Date: Mon, 26 Nov 2007 16:14:49 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ulrich Drepper <drepper@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de
Subject: Re: [PATCHv4 5/6] Allow setting O_NONBLOCK flag for new sockets
References: <200711200653.lAK6rE6B025891@devserv.devel.redhat.com> <20071119.235944.82120402.davem@davemloft.net> <474305A5.7070100@redhat.com> <474323CA.9030306@zytor.com> <alpine.LFD.0.9999.0711261003290.5869@woody.linux-foundation.org> <474B1C6D.6080405@zytor.com> <474B55F5.1050706@redhat.com>
In-Reply-To: <474B55F5.1050706@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> H. Peter Anvin wrote:
>> The 6-word limit is a red herring.  There is at least two ways to deal
>> with it (and this doesn't mean wiping the legacy stuff we already have):
>>
>> - Let each architecture pick a calling convention and redefine the
>> architecture-independent bits to take an arbitrary number of arguments.
>>  This is a one-time panarchitectural change.
>> [...]
> 
> Just think beyond wishful thinking for a moment.  What does it take to
> come up with something completely new and grand?
> 
> Let's start at the basic: you need to signal that the new syscall
> calling convention is used.  Since the syscall entry code is limited (at
> least the likes of syscall/sysenter, it would be easy enough to use int
> $0x81 in addition to int $0x80) you would have to extend the use of the
> syscall number while keeping binary compatibility.  This means
> additional costs for every single syscall.

No.

I already said I'm not looking at changing the calling convention for 
existing syscalls.  I don't think that makes sense.  (The only realistic 
exception to that is that if we really want a small number (16 or less) 
of flags fully orthogonal to the system call table, I guess it might 
make sense to stuff those in the high bits of the system call register. 
  However, I am a bit concerned about the auditability of that.)

> Once you're past that, how do you implement the expandable syscall
> parameter count?  There are two ways:
> 
> - - pass to the real sys_* implementations the number of provided syscall
> parameters and have each function figure out what this means
> 
> - - dynamically construct a call to the sys_* functions where the syscall
> magic adds an appropriate number of parameters filled with zeros.  This
> is quite complicated and, more importantly, it requires that you have
> code/data somewhere which specifies how many parameters each of the
> sys_* function actually requires.  The actual sys_* code and the data
> has to be kept in sync at all times.  A maintenance nightmare.

Hardly so, as evidenced by the fact that we have successfully done so 
for 15 years already; a number of Linux architectures require this 
information for the existing system calls.

> The handling of syscalls with many parameters should not at all be a
> driver of this design at all.  Syscalls shouldn't be that complicated, I
> completely agree with ingo.

You *ARE* introducing additional syscall parameters, regardless if 
you're admitting it or not.  It's exactly what you're doing, and by 
making those parameters hidden, all we're accomplishing is:

- a penalty any time those parameters have to be invoked,
- a good possibility that all the combinations are not audited.

> I'm perfectly willing to give you the benefit of doubt, show us a design
> for what you're proposing which is not slower than the current code,
> doesn't impact existing code, and solves the problem in a nice and clean
> way.  I cannot really see it now but I might miss something.  The
> sys_indirect approach ain't pretty but it does it jobs, doesn't impact
> performance, and is expandable in direction we *know* we will want to go
> very soon.

We have a ton of examples in the kernel already for both dealing with 
additional parameters and (somewhat fewer examples, but sys_pselect is a 
good one) too many parameters: in all cases, we invoke a wrapper 
function that sets up the parameters and then invokes the "true" syscall 
function.  Right now we're generating those manually, which appears to 
work okay simply because the amount of work it takes is small compared 
to the amount of work it takes to write the code for a proper syscall. 
(That doesn't mean it is the ideal model, of course.)  We *could* 
generate them automatically if we wanted to, with either of the models I 
mentioned -- the code I have in klibc to generate syscall stubs should 
be relatively easily modifiable to do this, although it's probably 
overkill for this job.

In this case we do minimal thunking of parameters for the legacy 
entrypoints, and for the current entrypoints we do the guaranteed 
minimum amount of work.

	-hpa

