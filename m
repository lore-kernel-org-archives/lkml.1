Return-Path: <linux-kernel-owner+w=401wt.eu-S1757553AbZCBIF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757553AbZCBIF1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 03:05:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755465AbZCBIFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 03:05:15 -0500
Received: from gw.goop.org ([64.81.55.164]:50359 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753998AbZCBIFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 03:05:14 -0500
Message-ID: <49AB9336.7010103@goop.org>
Date: Mon, 02 Mar 2009 00:05:10 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [PATCH] xen: core dom0 support
References: <1235786365-17744-1-git-send-email-jeremy@goop.org> <200902282309.07576.nickpiggin@yahoo.com.au> <49AB19E1.4050604@goop.org> <200903021737.24903.nickpiggin@yahoo.com.au>
In-Reply-To: <200903021737.24903.nickpiggin@yahoo.com.au>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
>> Those would be pertinent questions if I were suddenly popping up and
>> saying "hey, let's add Xen support to the kernel!"  But Xen support has
>> been in the kernel for well over a year now, and is widely used, enabled
>> in distros, etc.  The patches I'm proposing here are not a whole new
>> thing, they're part of the last 10% to fill out the kernel's support to
>> make it actually useful.
>>     
>
> As a guest, I guess it has been agreed that guest support for all
> different hypervisors is "a good thing". dom0 is more like a piece
> of the hypervisor itself, right?
>   

Hm, I wouldn't put it like that.  dom0 is no more part of the hypervisor 
than the hypervisor is part of dom0.  The hypervisor provides one set of 
services (domain isolation and multiplexing).  Domains with direct 
hardware access and drivers provide arbitration for virtualized device 
access.  They provide orthogonal sets of functionality which are both 
required to get a working system.

Also, the machinery needed to allow a kernel to operate as dom0 is more 
than that: it allows direct access to hardware in general.  An otherwise 
unprivileged domU can be given access to a specific PCI device via 
PCI-passthrough so that it can drive it directly.  This is often used 
for direct access to 3D hardware, or high-performance networking (esp 
with multi-context hardware that's designed for virtualization use).

>> Because Xen is dedicated to just running virtual machines, its internal
>> architecture can be more heavily oriented towards that task, which
>> affects things from how its scheduler works, its use and multiplexing of
>> physical memory.  For example, Xen manages to use new hardware
>> virtualization features pretty quickly, partly because it doesn't need
>> to trade-off against normal kernel functions.  The clear distinction
>> between the privileged hypervisor and the rest of the domains makes the
>> security people happy as well.  Also, because Xen is small and fairly
>> self-contained, there's quite a few hardware vendors shipping it burned
>> into the firmware so that it really is the first thing to boot (many of
>> instant-on features that laptops have are based on Xen).  Both HP and
>> Dell, at least, are selling servers with Xen pre-installed in the firmware.
>>     
>
> That would kind of seem like Xen has a better design to me, OTOH if it
> needs this dom0 for most device drivers and things, then how much
> difference is it really? Is KVM really disadvantaged by being a part of
> the kernel?
>   

Well, you can lump everything together in dom0 if you want, and that is 
a common way to run a Xen system.  But there's no reason you can't 
disaggregate drivers into their own domains, each with the 
responsibility for a particular device or set of devices (or indeed, any 
other service you want provided).  Xen can use hardware features like 
VT-d to really enforce the partitioning so that the domains can't 
program their hardware to touch anything except what they're allowed to 
touch, so nothing is trusted beyond its actual area of responsibility.  
It also means that killing off and restarting a driver domain is a 
fairly lightweight and straightforward operation because the state is 
isolated and self-contained; guests using a device have to be able to 
deal with a disconnect/reconnect anyway (for migration), so it doesn't 
affect them much.  Part of the reason there's a lot of academic interest 
in Xen is because it has the architectural flexibility to try out lots 
of different configurations.

I wouldn't say that KVM is necessarily disadvantaged by its design; its 
just a particular set of tradeoffs made up-front.  It loses Xen's 
flexibility, but the result is very familiar to Linux people.  A guest 
domain just looks like a qemu process that happens to run in a strange 
processor mode a lot of the time.  The qemu process provides virtual 
device access to its domain, and accesses the normal device drivers like 
any other usermode process would.  The domains are as isolated from each 
other as much as processes normally are, but they're all floating around 
in the same kernel; whether that provides enough isolation for whatever 
technical, billing, security, compliance/regulatory or other 
requirements you have is up to the user to judge.

>> Once important area of paravirtualization is that Xen guests directly
>> use the processor's pagetables; there is no shadow pagetable or use of
>> hardware pagetable nesting.  This means that a tlb miss is just a tlb
>> miss, and happens at full processor performance.  This is possible
>> because 1) pagetables are always read-only to the guest, and 2) the
>> guest is responsible for looking up in a table to map guest-local pfns
>> into machine-wide mfns before installing them in a pte.  Xen will check
>> that any new mapping or pagetable satisfies all the rules, by checking
>> that the writable reference count is 0, and that the domain owns (or has
>> been allowed access to) any mfn it tries to install in a pagetable.
>>     
>
> Xen's memory virtualization is pretty neat, I'll give it that. Is it
> faster than KVM on a modern CPU?

It really depends on the workload.  There's three cases to consider: 
software shadow pagetables, hardware nested pagetables, and Xen direct 
pagetables.  Even now, Xen's (highly optimised) shadow pagetable code 
generally out-performs modern nested pagetables, at least when running 
Windows (for which that code was most heavily tuned).  Shadow pagetables 
and nested pagetables will generally outperform direct pagetables when 
the workload does lots of pagetable updates compared to accesses.  (I 
don't know what the current state of kvm's shadow pagetable performance 
is, but it seems OK.)

But if you're mostly accessing the pagetable, direct pagetables still 
win.  On a tlb miss, it gets 4 memory accesses, whereas a nested 
pagetable tlb miss needs 24 memory accesses; and a nested tlb hit means 
that you have 24 tlb entries being tied up to service the hit, vs 4.  
(Though the chip vendors are fairly secretive about exactly how they 
structure their tlbs to deal with nested lookups, so I may be off 
here.)  (It also depends on whether you arrange to put the guest, host 
or both memory into large pages; doing so helps a lot.)

>  Would it be possible I wonder to make
> a MMU virtualization layer for CPUs without support, using Xen's page
> table protection methods, and have KVM use that? Or does that amount
> to putting a significant amount of Xen hypervisor into the kernel..?
>   

At one point Avi was considering doing it, but I don't think he ever 
made any real effort in that direction.  KVM is pretty wedded to having 
hardware support anyway, so there's not much point in removing it in 
this one area.

The Xen technique gets its performance from collapsing a level of 
indirection, but that has a cost in terms of flexibility; the hypervisor 
can't do as much mucking around behind the guest's back (for example, 
the guest sees real hardware memory addresses in the form of mfns, so 
Xen can't move pages around, at least not without some form of explicit 
synchronisation).

    J
