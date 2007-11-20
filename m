Return-Path: <linux-kernel-owner+w=401wt.eu-S1760862AbXKTTPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760862AbXKTTPS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 14:15:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753524AbXKTTPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 14:15:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46375 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbXKTTPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 14:15:05 -0500
Message-ID: <474331B7.6020802@zytor.com>
Date: Tue, 20 Nov 2007 11:12:55 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Zach Brown <zach.brown@oracle.com>
CC: Ulrich Drepper <drepper@redhat.com>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       tglx@linutronix.de, torvalds@linux-foundation.org
Subject: Re: [PATCHv4 5/6] Allow setting O_NONBLOCK flag for new sockets
References: <200711200653.lAK6rE6B025891@devserv.devel.redhat.com> <20071119.235944.82120402.davem@davemloft.net> <474305A5.7070100@redhat.com> <474323CA.9030306@zytor.com> <47432666.6070503@oracle.com>
In-Reply-To: <47432666.6070503@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zach Brown wrote:
>> That's only because you're being, deliberately or accidentally, vague
>> about what your actual (as opposed to imagined) requirements are.
> 
> Maybe I can help by summarizing how syslets fit in to this.
> 
> Currently the syslet patches add a single submission call which includes
> an argument which is a structure which duplicates the system call ABI.
> The submission syscall in the kernel does some syslet specific work
> which amounts to verifying state and storing it in the task_struct.  It
> then has to unpack the system call arguments from this submission
> syscall argument and call the specified system call.
> 
> Every architecture will need helpers, then, on either side.  They'll
> need to pack their arguments into the struct and then unpack and call in
> the kernel.  The PPC64 guys have already expressed concern about this.
> 
> It's, in effect, adding the syslet arguments to every single system call.
> 
> So, instead of duplicating the system call ABI in the argument to a
> syslet submission syscall, we could pass the syslet arguments via this
> indirect parameters convention.  This, hopefully, will reduce complexity
> by reducing the number of places that we have to muck around with the
> sycall ABI.
> 
> That's the high level summary, anyway.  I'm working on the simplest
> expression of this mechanism at the moment.  We'll have code to argue
> about before the silly thanksgiving break, I hope.
> 

It seems that you're doing the same thing in both cases, except you're 
now extending it to include other random functionality, which means 
other things than syslets are suddenly affected.

syslets are arguably a little bit different, since what you're 
effectively doing there is running a miniature interpreted language in 
kernel space.  A higher startup overhead should be acceptable, since 
you're amortizing it over a larger number of calls.  Extending that 
mechanism suddenly means you HAVE to use that interpreted language 
message mechanism to access certain system calls, which really does not 
seem like a good thing neither for performance nor for encouraging sane 
design of interfaces.

Everyone who designs a multiplexer have good reasons for the expediency 
that it provides, but it really isn't a good thing in the long term. 
The reason I mentioned MS-DOS is that MS-DOS has tons of multiplexers, 
sometimes three levels deep.  Furthermore, it doesn't have any kind of 
uniformity to its system calls calling convention.  The end result is 
hand-crafted stubs and wrappers, on both sides of the interface.

	-hpa
