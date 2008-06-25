Return-Path: <linux-kernel-owner+w=401wt.eu-S1756747AbYFYLtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747AbYFYLtU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 07:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754361AbYFYLtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 07:49:11 -0400
Received: from gw.goop.org ([64.81.55.164]:36579 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753753AbYFYLtK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 07:49:10 -0400
Message-ID: <4862301B.9020109@goop.org>
Date: Wed, 25 Jun 2008 07:46:35 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       xen-devel <xen-devel@lists.xensource.com>,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>,
       Vegard Nossum <vegard.nossum@gmail.com>, Nick Piggin <npiggin@suse.de>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, Avi Kivity <avi@qumranet.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 00 of 36] x86/paravirt: groundwork for 64-bit Xen	support
References: <patchbomb.1214367536@localhost> <20080625084253.GA11524@elte.hu>
In-Reply-To: <20080625084253.GA11524@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>> "paravirt/x86_64: move __PAGE_OFFSET to leave a space for hypervisor"
>>
>> This moves __PAGE_OFFSET up by 16 GDT slots, from 0xffff810000000000 
>> to 0xffff880000000000.  I have no general justification for this: the 
>> specific reason is that Xen claims the first 16 kernel GDT slots for 
>> itself, and we must move up the mapping to make room.  In the process 
>> I parameterised the compile-time construction of the initial 
>> pagetables in head_64.S to cope with it.
>>     
>
> This reduces native kernel max memory support from around 127 TB to 
> around 120 TB. We also limit the Xen hypervisor to ~7 TB of physical 
> memory - is that wise in the long run? Sure, current CPUs support 40 
> physical bits [1 TB] for now so it's all theoretical at this moment.
>
> my guess is that CPU makers will first extend the physical lines all the 
> way up to 46-47 bits before they are willing to touch the logical model 
> and extend the virtual space beyond 48 bits (47 bits of that available 
> to kernel-space in practice - i.e. 128 TB).
>
> So eventually, in a few years, we'll feel some sort of crunch when the # 
> of physical lines approaches the # of logical bits - just like when 
> 32-bit felt a crunch when physical lines went to 31 and beyond.
>   

There's no inherent reason why Xen itself needs to be able to have all 
memory mapped at once.  32-bit Xen doesn't and can survive quite 
happily.  It's certainly nice to be able to access anything directly, 
but it's just a performance optimisation.  In practice, the guest 
generally has almost everything interesting mapped anyway, and Xen 
maintains a recursive mapping of the pagetable to make its access to the 
pagetable very efficient, so it's only when a hypercall is doing 
something to an unmapped page that there's an issue.

The main limitation the hole-size imposes is the max size of the machine 
to physical map.  That uses 8bytes/page, and reserves 256GB of space for 
it, meaning that the current limit is 2^47 bytes - but there's another 
256GB of reserved and unused space next to it, so that could be easily 
extended to 2^48 if that really becomes an issue.

> That should be fine too - and probably useful for 64-bit kmemcheck 
> support as well.
>
> To further increase the symmetry between 64-bit and 32-bit, could you 
> please also activate the mem=nopentium switch on 64-bit to allow the 
> forcing of a non-PSE native 64-bit bootup? (Obviously not a good idea 
> normally, as it wastes 0.1% of RAM and increases PTE related CPU cache 
> footprint and TLB overhead, but it is useful for debugging.)
>   

OK.  Though it might be an idea to add "nopse" and start deprecating 
nopentium.

> a few other risk areas:
>
> - the vmalloc-sync changes. Are you absolutely sure that it does not
>   matter for performance?
>   

Oh, I didn't mean to include that one.  I think it's probably safe (from 
both the performance and correctness stands), but it's not necessary for 
64-bit Xen.

> - "The 32-bit early_ioremap will work equally well for 64-bit, so just
>    use it." Famous last words ;-)
>
> Anyway, that's all theory - i'll try out your patchset in -tip to see 
> what breaks in practice ;-)
>   

Yep, thanks,

    J
