Return-Path: <linux-kernel-owner+w=401wt.eu-S1758391AbZEKSZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758391AbZEKSZc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 14:25:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755161AbZEKSZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 14:25:20 -0400
Received: from gw.goop.org ([64.81.55.164]:52097 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754989AbZEKSZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 14:25:20 -0400
Message-ID: <4A086D8C.3060404@goop.org>
Date: Mon, 11 May 2009 11:25:16 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 02/18] xen: hook io_apic read/write operations
References: <1241730883-4917-1-git-send-email-jeremy@goop.org> <1241730883-4917-3-git-send-email-jeremy@goop.org> <20090509084201.GF3656@elte.hu> <20090509084324.GA5158@elte.hu> <4A05A408.3020006@goop.org> <20090511111904.GK4648@elte.hu>
In-Reply-To: <20090511111904.GK4648@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>> Hm, every time you see this code, you always have this 
>> quasi-Pavlovian response.
>>     
>
> Yep, my reaction to ugly code is pretty predictable, and 
> (hopefully!) repeatable. So calling it Pavlovian is an implicit 
> (albeit, i suspect, unintended ;-) compliment.
>   

My frustration is that you've generally not replied, and so we haven't 
been able to discuss it.  Could you be more specific about what's 
triggering the reaction?  Is it that the change is happening at the 
io-apic level, or that its some explicit Xen code pasted in here rather 
than via an io_apic_ops?

>> You say "use an irqchip".  I say:
>>
>>    * We already use irqchip
>>    * but most of the interesting IO apic accesses (routing) are not
>>      done via the irqchip interface
>>    * so irqchip doesn't help
>>     
>
> I dont see the problem. All APIs within Linux are kept minimalistic 
> and are extended on the fly, on an on-demand basis.
>   

Sure, where it makes sense.  One wouldn't start extending an API in a 
completely different direction.  irq_chip currently only deals with 
"irqs"; what those irqs mean and connect to are not its business because 
that has all been set up elsewhere.  If you start adding interrupt 
routing, then it starts needing to know about devices, busses, etc.  I 
can't see how that makes much sense at all, particularly for an 
arch-independent interface.

>
> Well, my main task at this stage is to point out ugly code. I might 
> be able to do research for you and come up with a plan for you, but 
> that's really a courtesy in general and is not always possible for 
> maintainers. You might argue "of all possible solutions this is the 
> cleanest" but i havent seen you make that point.

I'd love to, but Plato isn't taking my calls so I can't check.

But I do think hooking the io-apic operations makes more sense than any 
other solution because we explicitly want all the other code above it.  
The *only* difference between a Xen io-apic and a native io-apic is that 
we need to access the registers with hypercalls rather than mmio.  Same 
registers, same meanings, same settings made at the same time.  So the 
io-apic accessors are at precisely the right level of abstraction for 
our needs; introducing something higher-level would be an abstraction 
impedance mismatch, and would be no better for it.

An io_apic_ops makes sense to me, if adding it would stop triggering 
your ugly-code detector.  But that's specifically what HPA objected to 
in this series...

    J
