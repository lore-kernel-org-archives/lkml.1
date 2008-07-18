Return-Path: <linux-kernel-owner+w=401wt.eu-S1757187AbYGRKw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187AbYGRKw3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 06:52:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754208AbYGRKwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 06:52:21 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47307 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324AbYGRKwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 06:52:20 -0400
Message-ID: <488075E1.7070306@firstfloor.org>
Date: Fri, 18 Jul 2008 12:52:17 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, systemtap@sourceware.org,
       jbeulich@novell.com, arjan <arjan@infradead.org>
Subject: Re: [RFC] systemtap: begin the process of using proper kernel APIs
 (part1: use kprobe symbol_name/offset instead of address)
References: <1216146802.3312.95.camel@localhost.localdomain>	 <87ej5rsgk4.fsf@basil.nowhere.org> <1216373009.5232.130.camel@twins>	 <488070F1.9030903@firstfloor.org> <1216377897.28405.6.camel@twins>
In-Reply-To: <1216377897.28405.6.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Fri, 2008-07-18 at 12:31 +0200, Andi Kleen wrote:
> 
>>> But while the x86 might not be perfect, its fairly ok these days. Its
>>> not the utter piece of shite x86_64 had for a long time 
>> Not sure what you're referring to with this. AFAIK the x86-64 unwinder
>> for a normal frame pointer less kernel was not any worse (or better)
>> than a i386 kernel without frame pointers.
> 
> I hardly ever compile a kernel without frame pointers, as debugability
> is top priority for me, so I'm afraid I'm not sure how bad it gets
> without.
> 
> But it used to be that x86_64 was crap even with frame pointers, and
> without it it was just random gibberish - Arjan fixed that up somewhere
> around .25 iirc.

Well yes it was designed for dwarf2 unwinding and Linus' revert of that
wrecked it. Also even the frame pointer walker was in the dwarf2
code, so with that removed it fell back to a somewhat dumb unwinder.

AFAIK most of the assembler code still doesn't set up frame pointers,
so you'll likely still run into problems.

> 
>> - today's traces
>>> mostly make sense.
>> If you enable frame pointers? Making your complete kernel slower?
>> Generating much worse code on i386 by wasting >20% of its available
>> registers?  Getting pipeline stalls on each function call/exit on many CPUs?
>>
>> Right now unfortunately there are a few rogue CONFIGs who select that
>> so more and more kernels have, but I found that always distateful because
>> enabling frame pointers has such a large impact on all kernel code, especially
>> on the register starved i386.
>>
>> I still think the right solution eventually is to have a dwarf2 unwinder
>> by default for i386/x86-64 and get rid of all these nasty "select
>> FRAME_POINTER"s which have unfortunately sneaked in.
> 
> No argument on i386 vs frame pointers, fortunately I hardly ever build a
> 32bit kernel these days, 32bit hardware is disappearing fast here :-) 

It hurts even on 64bit, e.g. the pipe line stall issue is there which
can be a significant part of a function call cost of a small function
of which the kernel has plenty (that was the major reason why the x86-64
ABI discouraged frame pointers BTW and encouraged unwinding). Given several
modern cores have special hardware to avoid that, but there's still a lot of the
older cores around and even on the modern cores it's not free.

Also it's ~10% of the registers there. And it has some other impact.

> As to merging the dwarf unwinder, I have no particular objection to
> getting that merged as I'm rather ignorant on these matters - but from
> reading emails around the last merge attempt, Linus had some strong
> opinions on the matter.
> 
> Have those been resolved since?

I added some checks back then to satisfy Linus. Also the dwarf2 unwinder
is shipping successfully for some time both in systemtap and in opensuse 11.0,
[although that one unfortunately fell victim to one of the rogue select
FRAME_POINTERs, sigh!] so there shouldn't be much teething problems left.

-Andi

