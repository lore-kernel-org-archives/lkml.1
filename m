Return-Path: <linux-kernel-owner+w=401wt.eu-S1754214AbXK0Cj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214AbXK0Cj2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 21:39:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752407AbXK0CjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 21:39:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46298 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbXK0CjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 21:39:19 -0500
Message-ID: <474B8319.8000606@zytor.com>
Date: Mon, 26 Nov 2007 18:38:17 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ulrich Drepper <drepper@redhat.com>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       tglx@linutronix.de
Subject: Re: [PATCHv4 5/6] Allow setting O_NONBLOCK flag for new sockets
References: <200711200653.lAK6rE6B025891@devserv.devel.redhat.com> <20071119.235944.82120402.davem@davemloft.net> <474305A5.7070100@redhat.com> <474323CA.9030306@zytor.com> <alpine.LFD.0.9999.0711261003290.5869@woody.linux-foundation.org> <474B1C6D.6080405@zytor.com> <alpine.LFD.0.9999.0711261801390.5869@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.9999.0711261801390.5869@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
>> The 6-word limit is a red herring.  There is at least two ways to deal with it
>> (and this doesn't mean wiping the legacy stuff we already have):
>>
>> - Let each architecture pick a calling convention and redefine the
>> architecture-independent bits to take an arbitrary number of arguments.  This
>> is a one-time panarchitectural change.
> 
> Not applicable on x86-32.
> 
> The six-word limit is effectively a hardware limit there. Once it goes 
> past that limit, one of the words needs to be a pointer to extended 
> information that is fundamentally slower to access. Happily, only very 
> rare system calls do that (and none of them are of the simple variety 
> where we see a few cycles easily).
> 
> On other architectures, we could more easily just use more registers. But 
> x86-32 is still a big part (bulk) of what matters for most people.
> 

Well, x86-32 and x86-64 are surprisingly similar here, for very 
different reasons (x86-64 is because there are only seven clobbered 
registers that aren't destroyed by the syscall instruction itself.)

However, on both of these we could make the user-space side cheaper, by 
making sure that we don't have to do additional copies in user space. 
For both these architectures, anything more than 3 parameters (i386) or 
6 parameters (x86-64) will be already in memory on the stack, so if we 
can use that image as-is then we at least save the intra-user-space copy 
that goes along with it.

x86-64 requires some minor thought, since the obvious way of doing it 
(using arg register 6 to push in a pointer) would end up with a 
discontiguous frame.  One can do it with something like this, although 
it's not clear to me it is a win at all (the more obvious sequence using 
XCHG isn't usable since XCHG locks unconditionally):

	pop	%r10			# Return address
	push	%r9			# Argument 6
	movq	%rsp, %r11
	push	%r10
	movq	%rcx, %r10
	syscall
	cmpq	$-4095, %rax
	jae	...
	pop	%r10
	pop	%r9
	push	%r10
	retq

The number of registers do vary, obviously, with s390 being the smallest 
number (5).

> Immediately when you do anything but registers, it is much *much* more 
> costly. The "get_user()" and "copy_from_user()" stuff is not exactly slow, 
> but it's quite noticeable overhead for simple system calls. It gets worse 
> if this all is described by some indirect table setup.

True, of course, although we're talking here about different ways to 
pull arguments out of userspace memory; *definitely* agreed with that we 
don't want to have any additional indirection necessary.

	-hpa
