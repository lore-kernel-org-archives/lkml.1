Return-Path: <linux-kernel-owner+w=401wt.eu-S1756372AbYEWQOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372AbYEWQOb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 12:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751200AbYEWQOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 12:14:22 -0400
Received: from gw.goop.org ([64.81.55.164]:35977 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696AbYEWQOV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 12:14:21 -0400
Message-ID: <4836ED3B.4050808@goop.org>
Date: Fri, 23 May 2008 17:13:47 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org, Pekka Paalanen <pq@iki.fi>
Subject: Re: [PATCH] kmemcheck: SMP support
References: <20080523141759.GA1833@damson.getinternet.no>	 <20080523150622.GA9782@elte.hu> <19f34abd0805230830o3af93956h8152de3f6e350a09@mail.gmail.com>
In-Reply-To: <19f34abd0805230830o3af93956h8152de3f6e350a09@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum wrote:
> On Fri, May 23, 2008 at 5:06 PM, Ingo Molnar <mingo@elte.hu> wrote:
>   
>> Vegard, wanna have a look at introducing per CPU kernel pagetables? I
>> tried that once in the past and it wasnt too horrible. (the patches are
>> gone though) We could do it before bringing other CPUs online, i.e. much
>> of the really yucky boot time pagetable juggling phase would be over
>> already. Hm?
>>     
>
> Ingo.
>
> It really doesn't matter how easy it was for you.
>
> You're one of the x86 maintainers.
>
> And I think you're forgetting how hard these things are for a newbie.
> I don't even know which one comes first of pmds and puds.
>
> Per-cpu page tables sounds about on the same scale of as, say,
> rewriting the VM or some other major subsystem. Epic!
>   

No, I don't think it would really be all that bad, if you just make the 
kernel parts of the pagetable percpu;  userspace might be a bit 
trickier.  But kernel mappings change sufficiently rarely that keeping 
them all in sync isn't a huge problem.

If your requirement is that you want to be able to set page permissions 
on kernel mappings on a per-cpu basis, then it might be easiest to do it 
on-demand.  Start off with a single shared pagetable, and when you want 
to make a per-cpu page protection change, clone the pagetable from the 
root down to the page you're changing and then do your update.

There's certainly enough hooking places in which you could implement it 
without much effect on the core kernel code.

> I'm glad to hear from you, though.
>
> Pekka suggested that per-cpu page tables might help NUMA systems too.
> Does that sound right to you? Would anybody else benefit from having
> per-CPU page tables? If not, I have a hard time believing it will ever
> get merged.
>
> (Oh. mmio-trace might. But that's also a hacking tool and doesn't really count.)
>   

I'd need to think about it a bit, but its possible that 64-bit Xen might 
be able to take advantage of it.  Yeah, it could be useful.

    J
