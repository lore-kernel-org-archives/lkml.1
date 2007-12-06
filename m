Return-Path: <linux-kernel-owner+w=401wt.eu-S1754948AbXLFSgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948AbXLFSgm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 13:36:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbXLFSgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 13:36:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40305 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752017AbXLFSgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 13:36:31 -0500
Date: Thu, 6 Dec 2007 19:36:29 +0100 (CET)
From: Bernhard Kaindl <bk@suse.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Bernhard Kaindl <bkaindl@ffii.org>, linux-kernel@vger.kernel.org,
       linux1394-devel@lists.sourceforge.net
Subject: [feedback discussion] Early boot debugging via FireWire
 (ohci1394_dma=early)
In-Reply-To: <4755D757.7060002@s5r6.in-berlin.de>
Message-ID: <alpine.LNX.0.9999-openSUSE-1.0712061732280.21849@jbgna.fhfr.qr>
References: <200702101242.48467.ak@suse.de> <45CDCDCD.5000609@s5r6.in-berlin.de> <alpine.DEB.0.9999.0712040426100.3769@vic.ffii.org> <4755D186.20204@s5r6.in-berlin.de> <4755D612.1090103@s5r6.in-berlin.de> <4755D757.7060002@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this mail sums up some discussion about special code for early initialisation
of OHCI-1394 controllers to enable their use for remote debugging over FireWire
using physical DMA. The thread started on linux-kernel and Stefan Richter
asked to Cc also linux1394-devel for the review of ieee1394-related parts.

On Tue, 4 Dec 2007, Stefan Richter wrote:
> 
> PPS:  Today I had a brief look through your current sources.  Look good
> so far, except for a curious hunk which patches drivers/Makefile.  And I
> can't say anything to the x86 platform related and PCI related aspects
> of the driver.

Thanks, good catch. The I fixed that hunk now

ftp://ftp.suse.de/private/bk/firewire/kernel/ohci1394_dma_early-v2.diff

to read like this:

linux-2.6.24-rc4/drivers/Makefile:

  obj-$(CONFIG_ATA)		+= ata/
  obj-$(CONFIG_FUSION)		+= message/
  obj-$(CONFIG_FIREWIRE)		+= firewire/
-obj-$(CONFIG_IEEE1394)		+= ieee1394/
+obj-y				+= ieee1394/
  obj-$(CONFIG_UIO)		+= uio/
  obj-y				+= cdrom/
  obj-y				+= auxdisplay/

The reason for adding it was that drivers/ieee1394/init_ohci1394_dma.c
does not get compiled if CONFIG_IEEE1394 is not set, but it's not really
depeding on CONFIG_IEEE1394 being set.

The only effect this hunk has (and only when CONFIG_IEEE1394 is not set)
is that an empty object file is created in drivers/ieee1394 for linking
into vmlinux, but as it does not contain any code or data, it does not
change vmlinux at all.

If you do not approve that change, I'd have to add a "depends IEEE1394"
to the new config entry. I adopted way to have the early firewire debugging
option showing up all times, not only when CONFIG_IEEE1394 is set.

I tried to add "selects IEEE1394", but that causes IEEE1394 to be compiled
into the kernel even if you do not intend that, so I saw the hunk above as
the best way to deal with it.

==========================================================================

I'm commenting on suggestions made in the early part of this thread, it
can be found at http://lkml.org/lkml/2007/2/10/96 :

>   - The Kconfig option could go into the "Kernel hacking" submenu rather
>     than the IEEE 1394 submenu. (The driver source should stay in
>     drivers/ieee1394.)

done.

>   - Leave a note in the Kconfig help how it is typically used, i.e. what
>     is required on the remote terminal side, where to find firescope,
>     fireproxy etc. and assorted HOWTOs.

I have put that to Documentation/debugging-via-ohci1394.txt in the new patch.

>   - Indicate in the Kconfig help that only a 4GB address range is made
>     visible this way.

done.

Andi Kleen said that he would handle to patch-submission process:

> It's more related to arch code than firewire, so I thought i would
> handle it. But you can too if you want. It definitely needs much
> more review anyways.

To which Stefan Richter agreed:

> It's better you do it. I don't know anything about the specifics of
> early initialization. Just Cc linux1394-devel on submission so that we
> can have a look at the OHCI-1394 related bits.

doing that now, Stefan also remarked:

> Using linux1394-2.6.git could only be helpful if more code sharing
> between ohci1394.c and ohci1394_early.c would be desired. That's
> questionable though, given the rather small size of ohci1394_early.c.

Andi agreed:

> Ok. I'm sure you know more about 1394 than me so I guess it will be shared
> review.

Stefan then did a code review and came back with:

>   - Its functionality will be lost if there is a FireWire bus reset,
>     e.g. when something is plugged in or out.  To keep physical DMA
>     alive, an interrupt handler had to be installed which writes ~0
>     to OHCI1394_PhyReqFilter{Hi,Lo}Set.  Can interrupt handlers be
>     registered in an early setup stage?

We didn't go into this further, and while I have further ideas on that,
like polling for bus resets in the Oops and Panic handlers,
I now resorted to documenting that carefully as especially if the issue
to be debugged crashed the machine bady or one wants to run a kernel
debugger over firewire using physical DMA, interrupts would be disabled
anyways.

>   - There might be some register accesses in the setup which could be
>     omitted; I'd have to look this up.

Migth be possible. I didn't give this a major priority because at least
in this version, all code is tagged with __init, so everything is freed
after boot, and even if we keep the init routine, there is not a awful
lot to remove. When linked into vmlinux, I saw about 1k size increase
for the whole initialisation routine.

>   - Could be optimized to not use ohci1394.h::struct ti_ohci.

Indeed, but I didn't see it a big gain to have my own copy of it.
As nothing (except a fixmap per controller) is allocated permanently,
it wouldn't change the compiled code. In a future step, it may share
some source code with fw-ohci to make the source even smaller, the
source code which could be shared is about 84 lines, not very much.

>   - PCI_CLASS_FIREWIRE_OHCI can be replaced by
>     include/linux/pci_ids.h::PCI_CLASS_SERIAL_FIREWIRE_OHCI which
>     was newly added in 2.6.20-git#.

done.

>   - How about dropping support for configuring this as module, to
>     simplify the code?  Unless this would interfere with ohci1394; and
>     it probably would if there was an interrupt handler...

done, no interrupt handler.

>   - "depends on X86_64" is missing in Kconfig.

Added support for X86_32 too, so it has a depends X86 now. It uses a fixmap
currenlty which means that it's X86-only for now, for ppc see below.

>   - Maybe put it into arch/x86_64/drivers/ instead of drivers/ieee1394?

Ben replied to that:

> I'd like to have that on ppc as well, so I'd rather keep it in drivers/

He asked:
> > > Andi, also, how do you deal with iommu ? Not at all ? :-)
Andi:
> > Yes -- it's really early debugging hack mostly. It's reasonable to
> > let the iommu be disabled (or later a special bypass can be added for this)
Ben:
> Ok.

On support for PowerPC and other archtectures:

>> This will need some abstraction at least -- there are some early mapping hacks
>> that are x86 specific right now.
> Either abstraction or ifdef's .. we have ioremap working very early on
> ppc :-)

Either way would be fine with me. I'd like to put it this way:

Everyone is free to extend the code to execute also early on more archtectures,
and I could even look at that myself in January but not now as I'm on vacation
from next week on. I think that support for more architectures can be added
with incremental patches.

I'll submit the patch now in the formal way (next mail) for full review,
Bernhard
