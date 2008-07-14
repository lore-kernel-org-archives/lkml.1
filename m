Return-Path: <linux-kernel-owner+w=401wt.eu-S1756774AbYGNTLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774AbYGNTLW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 15:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754442AbYGNTLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 15:11:15 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56428 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753260AbYGNTLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 15:11:14 -0400
Message-ID: <487BA4CF.6060905@firstfloor.org>
Date: Mon, 14 Jul 2008 21:11:11 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Avi Kivity <avi@qumranet.com>
Subject: Re: [git pull] core, x86: make LIST_POISON less deadly
References: <20080714144828.GA22666@elte.hu> <alpine.LFD.1.10.0807140758100.3305@woody.linux-foundation.org> <20080714151247.GA27145@elte.hu> <alpine.LFD.1.10.0807140856130.3305@woody.linux-foundation.org> <8763r8z570.fsf@basil.nowhere.org> <alpine.LFD.1.10.0807141139120.3305@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807141139120.3305@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Mon, 14 Jul 2008, Andi Kleen wrote:
>> The issue is that the kernel cannot detect it (short of running the
>> KVM x86 emulator on #GP, but surely you're not suggesting that), so it
>> cannot print something out.
> 
> Don't be silly. It prints out the oops message.
> 
> People who cannot see where that oops is, and cannot be bothered to look 
> at the register state aren't going to help _anyway_.

I've seen a lot of people who don't know too much assembler just work based
on the RIP. As in look it up in the source using addr2line or gdb and then try
to figure it out based on the source. Actually looking at the register contents
and how the instruction uses it is pretty arcane knowledge and usually
not even needed.  And with more and more kernel developers being
newbie friendly in this area is a good thing.

> 
> In fact, with the 0xdead... sequence, it's going to be *more* obvious than 
> with some almost-kernel 0xffffc.. address, even if it's not showing up in 
> the first line.

> In other words, your whole argument is pure and utter sh*t. The page fault 
> is _less_ readable than the GP fault.

How about if the page fault handler checks for the value and prints
a obvious string? It could do this reliably, unlike the "grep
all registers for poison on #GP" method that was earlier proposed.

>> That is why I suggested using a canonical address.
> 
> And I disagree. Violently. 
> 
> The whole and ONLY point of poisoning is to get the fault.
> 
> With the canonical address, you won't get it reliably, and when you do get 
> it, it's not obvious to decode.

I discussed this with Avi earlier and we were careful to put it into
one of the guaranteed to be unmapped holes. This should actually not
change if the CPU changes because it's defined by the kernel mapping.

If these holes ever change the poison would need to change too, but
otherwise I don't really see how it should be particularly unreliable.

Ok it might break if someone messes up the direct mapping, but if that
happens you typically don't even go through the oops handler completely
and won't see the message.

-Andi


