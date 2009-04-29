Return-Path: <linux-kernel-owner+w=401wt.eu-S1759098AbZD2MLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759098AbZD2MLs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 08:11:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755951AbZD2MLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 08:11:36 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:52450 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755937AbZD2MLf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 08:11:35 -0400
Message-ID: <49F843BC.7020902@garzik.org>
Date: Wed, 29 Apr 2009 08:10:36 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>, rdreier@cisco.com,
       hpa@zytor.com, tglx@linutronix.de, h.mitake@gmail.com,
       rpjday@crashcourse.ca, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Remove readq()/writeq() on 32-bit
References: <49EE37AF.4020507@zytor.com> <20090421.173123.191021055.davem@davemloft.net> <adak55438gp.fsf_-_@cisco.com> <20090428.221228.217954247.davem@davemloft.net> <20090429115654.GC11586@elte.hu>
In-Reply-To: <20090429115654.GC11586@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> (Linus Cc:-ed)
> 
> * David Miller <davem@davemloft.net> wrote:
> 
>> From: Roland Dreier <rdreier@cisco.com>
>> Date: Tue, 28 Apr 2009 12:05:10 -0700
>>
>>> As discussed in <http://lkml.org/lkml/2009/4/19/164> and follow-ups,
>>> readq()/writeq() for 32-bit x86 are implemented as two readl()/writel()
>>> operations.  This is not atomic (in the sense that another MMIO
>>> operation from another CPU or thread can be done in the middle of the
>>> two read/writes), and may not access the two halves of the register in
>>> the correct order to work with hardware.
>>>
>>> Rather than silently providing a 32-bit fallback that leaves a
>>> possibility for strange driver bugs, it's better to provide readq()
>>> and writeq() only for 64-bit architectures, and have a compile failure
>>> on 32-bit architectures that forces driver authors to think about what
>>> the correct solution is.
>>>
>>> This essentially reverts 2c5643b1 ("x86: provide readq()/writeq() on
>>> 32-bit too") and follow-on commits.  If in the future someone wants to
>>> provide a generic solution for all 32-bit architectures, that's great,
>>> but there's not much point in providing (arguably broken)
>>> implementations for only one architecture, since any portable driver
>>> will have to implement fallbacks for other architectures anyway.
>>>
>>> Signed-off-by: Roland Dreier <rolandd@cisco.com>
>> Acked-by: David S. Miller <davem@davemloft.net>
> [...]
>>> We never seemed to reach closure on this.  I would strongly 
>>> suggest merging something like this, and then if someone has a 
>>> grand plan to unify all fallbacks, we can add that when it shows 
>>> up.  As it stands, the x86-32 situation is not progress towards 
>>> that grand unified plans, and does nothing that I can tell 
>>> beyond setting a trap for drivers.
> 
> I still have no particularly strong opinion on this - other the 
> reluctance i expressed already in the previous threads. My arguments 
> are not reflected (and not addressed) in the changelog AFAICS, so 
> let me repeat them here:

I do.


> What caused 2c5643b1 was that right now we have ugly per driver
> #defines and inlines for readq/writeq. See:
> 
>   git grep 'define.*readq' drivers/
> 
> for a rough estimation of what the current practices are. The 32-bit 
> wrapper we added 6 months ago is the obvious implementation on x86 
> and that it matches existing wrappers.

This is the key...


> So my (slight) preference would be to keep the default generic 
> implementation and not make any atomicity guarantees - we never made 
> any.

Agreed.

This removal patch is completely pointless, because it moves us 
backwards to the point where we had a bunch of drivers defining it.

Why is that any better?

"Forcing driver writers to think" translates in the real world to each 
hardware vendor putting the common "#define readq" into their driver.

At least the networking drivers I messed with (until 11/2008) were 
always fine with a non-atomic readq.

The x86 kernel 32-bit implementation of readq/writeq is the code that 
every hardware vendor otherwise would re-create, when doing a Linux driver.

	Jeff



