Return-Path: <linux-kernel-owner+w=401wt.eu-S1763379AbYBLOho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763379AbYBLOho (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 09:37:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763311AbYBLOhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 09:37:33 -0500
Received: from mail.windriver.com ([147.11.1.11]:47568 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761776AbYBLOhc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 09:37:32 -0500
Message-ID: <47B1AEC3.2080402@windriver.com>
Date: Tue, 12 Feb 2008 08:35:47 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] kgdb-light -v10
References: <20080211015321.GA27376@one.firstfloor.org> <y0mhcgf4ig1.fsf@ton.toronto.redhat.com> <20080211162141.GA31434@elte.hu> <20080211171039.GA20446@one.firstfloor.org> <20080211230335.GA16102@elte.hu> <20080212100327.GA30873@one.firstfloor.org> <20080212112747.GA1569@elte.hu> <20080212121903.GA419@one.firstfloor.org> <20080212123839.GA15360@elte.hu> <47B19F67.5050105@windriver.com> <20080212143949.GA2258@one.firstfloor.org>
In-Reply-To: <20080212143949.GA2258@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Feb 2008 14:35:24.0660 (UTC) FILETIME=[80F35340:01C86D84]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> We might be best served to add a comment to explain the purpose of
>> kgdb_arch_pc() and put it in the optional implementation function
>> headers in include/linux/kgdb.h
>>
>> On some archs certain exceptions do not report the address that the
>> exception occurred at when you call instruction_pointer(). This optional
>> function allows for an arch to perform a "fixup" to get the address the
>> exception actually occurred at.
> 
> Shouldn't that be handled in the remote gdb?

No this is a kgdb integrity check.

Basically when you reach this chunk of code it is before the hand off
to the source debugger.  We cannot continue because there was a
breakpoint in a part of the system kgdb was using while doing its
normal work.  The reality is that KGDB is not self contained.  It
relies on some external I/O methods, atomic page fault handling and
some other pieces.  If you take an exception there, the kgdb integrity
check absolutely needs to fail.

It was the source of some great pain for folks who tried to use kgdb
for more than an inspection tool.  There are some parts of the system
you cannot debug.


> 
>> Kgdb requires the actual exception address so a sanity check can be
>> performed to make sure kgdb did not hit an exception while in a chunk of
>> code kgdb requires for its functionality. If you hit one of these
> 
> That was for the old longjmp checks, but that code is long gone isn't it
> and replacement with standard __ex_table handling.

This has nothing to do with the long jump

> 
>> conditions kgdb makes its best attempt to try to "patch the wound"
>> inflicted by shooting yourself but at least you get notified vs a silent
>> hang :-)
> 
> In what cases is that still needed?
> 

This is a totally stupid test case but it should illustrate the problem.

- connect to kgdb
- place a break point at kgdb_disable_hw_debug()
- continue
- Now try to break in again

You will see the kgdb integrity check fail because you put a
breakpoint in a place that kgdb actually needs to perform its work.
In this case kgdb will clean up the exception and restore operation
and you will be ok.  The kgdboc has a much smaller swath of code that
you cannot debug vs something like kgdboe where there are lot more
places you cannot debug due to the amount of code to services the
ethernet device, irq sync etc...

This check is absolutely required to help prevent silent death via
dumb breakpoints or stepping around in random places (which is ill
advised anyway).

Jason.
