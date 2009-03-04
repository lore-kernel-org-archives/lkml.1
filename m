Return-Path: <linux-kernel-owner+w=401wt.eu-S1757442AbZCDTEE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442AbZCDTEE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 14:04:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755717AbZCDTDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 14:03:53 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:38037 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755686AbZCDTDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 14:03:52 -0500
Message-ID: <49AED092.5080902@codemonkey.ws>
Date: Wed, 04 Mar 2009 13:03:46 -0600
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Nick Piggin <nickpiggin@yahoo.com.au>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] xen: core dom0 support
References: <1235786365-17744-1-git-send-email-jeremy@goop.org>	<20090227212812.26d02f34.akpm@linux-foundation.org>	<49A8DF28.4050301@goop.org>	<200902282309.07576.nickpiggin@yahoo.com.au> <49AB19E1.4050604@goop.org>
In-Reply-To: <49AB19E1.4050604@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:

> OK, fair point, its probably time for another Xen architecture refresher 
> post.
> 
> There are two big architectural differences between Xen and KVM:
> 
> Firstly, Xen has a separate hypervisor who's primary role is to context 
> switch between the guest domains (virtual machines).   The hypervisor is 
> relatively small and single purpose.  It doesn't, for example, contain 
> any device drivers or even much knowledge of things like pci buses and 
> their structure.  The domains themselves are more or less peers; some 
> are more privileged than others, but from Xen's perspective they are 
> more or less equivalent.  The first domain, dom0, is special because its 
> started by Xen itself, and has some inherent initial privileges; its 
> main job is to start other domains, and it also typically provides 
> virtualized/multiplexed device services to other domains via a 
> frontend/backend split driver structure.
> 
> KVM, on the other hand, builds all the hypervisor stuff into the kernel 
> itself, so you end up with a kernel which does all the normal kernel 
> stuff, and can run virtual machines by making them look like slightly 
> strange processes.
> 
> Because Xen is dedicated to just running virtual machines, its internal 
> architecture can be more heavily oriented towards that task, which 
> affects things from how its scheduler works, its use and multiplexing of 
> physical memory.  For example, Xen manages to use new hardware 
> virtualization features pretty quickly, partly because it doesn't need 
> to trade-off against normal kernel functions.  The clear distinction 
> between the privileged hypervisor and the rest of the domains makes the 
> security people happy as well.  Also, because Xen is small and fairly 
> self-contained, there's quite a few hardware vendors shipping it burned 
> into the firmware so that it really is the first thing to boot (many of 
> instant-on features that laptops have are based on Xen).  Both HP and 
> Dell, at least, are selling servers with Xen pre-installed in the firmware.

I think this is a bit misleading.  I think you can understand the true 
differences between Xen and KVM by s/hypervisor/Operating System/. 
Fundamentally, a hypervisor is just an operating system that provides a 
hardware-like interface to it's processes.

Today, the Xen operating system does not have that many features so it 
requires a special process (domain-0) to drive hardware.  It uses Linux 
for this and it happens that the Linux domain-0 has full access to all 
system resources so there is absolutely no isolation between Xen and 
domain-0.  The domain-0 guest is like a Linux userspace process with 
access to an old-style /dev/mem.

You can argue that in theory, one could build a small, decoupled 
domain-0, but you could also do this, in theory, with Linux and KVM.  It 
is not necessary to have all of your device drivers in your Linux 
kernel.  You could build an initramfs that passed all PCI devices 
through (via VT-d) to a single guest, and then provided and interface to 
allow that guest to create more guests.  This is essentially what dom0 
support is.

The real difference between KVM and Xen is that Xen is a separate 
Operating System dedicated to virtualization.  In many ways, it's a fork 
of Linux since it uses quite a lot of Linux code.

The argument for Xen as a separate OS is no different than the argument 
for a dedicated Real Time Operating System, a dedicated OS for embedded 
systems, or a dedicated OS for a very large system.

Having the distros ship Xen was a really odd thing from a Linux 
perspective.  It's as if Red Hat started shipping VXworks with a Linux 
emulation layer as Real Time Linux.

The arguments for dedicated OSes are well-known.  You can do a better 
scheduler for embedded/real-time/large systems.  You can do a better 
memory allocate for embedded/real-time/large systems.  These are the 
arguments that are made for Xen.

In theory, Xen, the hypervisor, could be merged with upstream Linux but 
there is certainly no parties interested in that currently.

My point is not to rail on Xen, but to point out that there isn't really 
a choice to be made here from a Linux perspective.  It's like saying do 
we really need FreeBSD and Linux, maybe those FreeBSD guys should just 
merge with Linux.  It's not going to happen.

KVM turns Linux into a hypervisor by adding virtualization support.  Xen 
is a separate hypervisor.

So the real discussion shouldn't be should KVM and Xen converge because 
it really doesn't make sense.  It's whether it makes sense for upstream 
Linux to support being a domain-0 guest under the Xen hypervisor.

Regards,

Anthony Liguori

> 
> The second big difference is the use of paravirtualization.  Xen can 
> securely virtualize a machine without needing any particular hardware 
> support.  Xen works well on any post-P6 or any ia64 machine, without 
> needing any virtualzation hardware support.  When Xen runs a kernel in 
> paravirtualized mode, it runs the kernel in an unprivileged processor 
> state.  The allows the hypervisor to vet all the guest kernel's 
> privileged operations, which are carried out are either via hypercalls 
> or by memory shared between each guest and Xen.
> 
> By contrast, KVM relies on at least VT/SVM (and whatever the ia64 equiv 
> is called) being available in the CPUs, and needs the most modern of 
> hardware to get the best performance.
> 
> Once important area of paravirtualization is that Xen guests directly 
> use the processor's pagetables; there is no shadow pagetable or use of 
> hardware pagetable nesting.  This means that a tlb miss is just a tlb 
> miss, and happens at full processor performance.  This is possible 
> because 1) pagetables are always read-only to the guest, and 2) the 
> guest is responsible for looking up in a table to map guest-local pfns 
> into machine-wide mfns before installing them in a pte.  Xen will check 
> that any new mapping or pagetable satisfies all the rules, by checking 
> that the writable reference count is 0, and that the domain owns (or has 
> been allowed access to) any mfn it tries to install in a pagetable.
> 
> The other interesting part of paravirtualization is the abstraction of 
> interrupts into event channels.  Each domain has a bit-array of 1024 
> bits which correspond to 1024 possible event channels.  An event channel 
> can have one of several sources, such as a timer virtual interrupt, an 
> inter-domain event, an inter-vcpu IPI, or mapped from a hardware 
> interrupt.  We end up mapping the event channels back to irqs and they 
> are delivered as normal interrupts as far as the rest of the kernel is 
> concerned.
> 
> The net result is that a paravirtualized Xen guest runs a very close to 
> full speed.  Workloads which modify live pagetables a lot take a bit of 
> a performance hit (since the pte updates have to trap to the hypervisor 
> for validation), but in general this is not a huge deal.  Hardware 
> support for nested pagetables is only just beginning to get close to 
> getting performance parity, but with different tradeoffs (pagetable 
> updates are cheap, but tlb misses are much more expensive, and hits 
> consume more tlb entries).
> 
> Xen can also make full use of whatever hardware virtualization features 
> are available when running an "hvm" domain.  This is typically how you'd 
> run Windows or other unmodified operating systems.
> 
> All of this is stuff that's necessary to support any PV Xen domain, and 
> has been in the kernel for a long time now.
> 
> 
> The additions I'm proposing now are those needed for a Xen domain to 
> control the physical hardware, in order to provide virtual device 
> support for other less-privileged domains.  These changes affect a few 
> areas:
> 
>    * interrupts: mapping a device interrupt into an event channel for
>      delivery to the domain with the device driver for that interrupt
>    * mappings: allowing direct hardware mapping of device memory into a
>      domain
>    * dma: making sure that hardware gets programmed with machine memory
>      address, nor virtual ones, and that pages are machine-contiguous
>      when expected
> 
> Interrupts require a few hooks into the x86 APIC code, but the end 
> result is that hardware interrupts are delivered via event channels, but 
> then they're mapped back to irqs and delivered normally (they even end 
> up with the same irq number as they'd usually have).
> 
> Device mappings are fairly easy to arrange.  I'm using a software pte 
> bit, _PAGE_IOMAP, to indicate that a mapping is a device mapping.  This 
> bit is set by things like ioremap() and remap_pfn_range, and the Xen mmu 
> code just uses the pfn in the pte as-is, rather than doing the normal 
> pfn->mfn translation.
> 
> DMA is handled via the normal DMA API, with some hooks to swiotlb to 
> make sure that the memory underlying its pools is really DMA-ready (ie, 
> is contiguous and low enough in machine memory).
> 
> The changes I'm proposing may look a bit strange from a purely x86 
> perspective, but they fit in relatively well because they're not all 
> that different from what other architectures require, and so the 
> kernel-wide infrastructure is mostly already in place.
> 
> 
> I hope that helps clarify what I'm trying to do here, and why Xen and 
> KVM do have distinct roles to play.
> 
>    J

