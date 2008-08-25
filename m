Return-Path: <linux-kernel-owner+w=401wt.eu-S1755748AbYHYNeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748AbYHYNeg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 09:34:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753834AbYHYNe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 09:34:27 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:54546 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753602AbYHYNe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 09:34:26 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Bernhard Walle <bwalle@suse.de>, Vivek Goyal <vgoyal@redhat.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <1219617897-9870-1-git-send-email-yhlu.kernel@gmail.com>
	<m14p59ztz1.fsf@frodo.ebiederm.org> <20080825071709.GB26048@elte.hu>
Date: Mon, 25 Aug 2008 06:30:02 -0700
In-Reply-To: <20080825071709.GB26048@elte.hu> (Ingo Molnar's message of "Mon,
	25 Aug 2008 09:17:09 +0200")
Message-ID: <m1r68dmdd1.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Ingo Molnar <mingo@elte.hu>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4997]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] x86: only put e820 ram entries in resource tree
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> * Eric W. Biederman <ebiederm@xmission.com> wrote:
>
>> Yinghai Lu <yhlu.kernel@gmail.com> writes:
>> 
>> > may need user to have new kexec tools that could create e820 table
>> > from /sys/firmware/memmap instead of /proc/iomem for second kernel
>> 
>> Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
>> 
>> /proc/iomem is mostly about io resources which you have just removed. 
>> It is totally the wrong thing to only register RAM resource!
>
> see the RFC commit below for more details - about the problem and 
> various solutions we are thinking about. The core problem is that the 
> problem was hard to find and hard to debug - it took the exception 
> debugging effort of David Witbrodt to track it down.
>
> So we are trying structural fixes to improve the situation. Just 
> reverting the e820 changes breaks other things and is not the real fix 
> anyway: the real fix is to increase communication between PC platform 
> devices/drivers and the PCI code. DMI driven quirks are too limited as 
> well - more such systems are suspected.
>  
> For now we've got the patch below from Yinghai - which hooks directly 
> into the x86 PCI discovery and reallocation code. While that's already 
> better than the initial DMI quirk, i think the real fix should go one 
> level higher, to the resource manager.
>
> i'd rather see the e820 reserved entries show up there (losing system 
> setup information is almost always a bad idea - and the e820 map is 
> central enough to be one of the more reliable BIOS-provided data 
> structures), but with a different resource property: a 'sticky' resource 
> bit which would cause overlapping PCI devices that already have their 
> BAR programmed stay there. We already have a certain amount of support 
> for 'container' resources (bridge resources for example).

Agreed.  And that is why I NAK'd YH's first patch which just yanked
all of the reserved entries out of the resource map.

This really does need to get up to how we deal with resources
and the resource manager.

> That would automatically protect any hpet (or, in theory, ioapic) 
> platform devices from the PCI code's currently blind resource 
> reprogramming logic. These platform devices are not PCI enumerated so we 
> cannot just make the platform drivers themselves be PCI drivers, and 
> they are special in many regards. (often they are not PCI devices at 
> all)

> Note that this is only about the (BIOS provided) e820 map. The core 
> problem is, inserting e820 map reserved entries as 'real' resources can 
> break real devices.

The core problem is seeing the e820 reservation as a conflict, not inserting
the resources themselves.

The question:  How do we deal more gracefully with BIOS bugs.
The problem:  We don't have full system information so we have to guess and
perform other magic to make the system work.

I bet if the HPET driver knew we had changed it's bar it would have worked
but of course that won't work in general.

One of the other problems we have seen in this area if memory serves is
that BIOS reserved regions can don't always split on the same boundaries
as real hardware.

The last time this class of problem came up we added insert_resource
to the resource allocator.  It seems either we are not using it properly
or it is an insufficient fix.

Hmm.

Why does pci_find_parent_resource fail?

Eric
> 	Ingo
>
> ---------------->
>>From 1521c6b7a96e8d79c424216d9118859a017a4e9e Mon Sep 17 00:00:00 2001
> From: Yinghai Lu <yhlu.kernel@gmail.com>
> Date: Sun, 24 Aug 2008 21:41:28 -0700
> Subject: [PATCH] x86: fix HPET regression in 2.6.26 versus 2.6.25, check hpet
> against BAR v2
>
> David Witbrodt tracked down (and bisected) a bootup hang on his system
> to the following problem: a BIOS bug made the hpet device visible as a
> generic PCI device. If e820 reserved entries happen to be registered
> first in the resource tree [which v2.6.26 started doing - to fix other
> bugs], then the PCI code will reallocate that device's BAR to some other
> address - breaking timer IRQs and hanging the system.
>
> ( Normally hpet devices are hidden by the BIOS from the OS's PCI discovery
>   via chipset magic. Sometimes the hpet is not a PCI device at all. )
>
> Solve this fundamental fragility by making the non-PCI platform driver
> insert resources into the resource tree even if it overlaps the e820
> reserved entry, to keep the resource manager from updating the BAR.
>
> NOTE: this is an RFC for now, there might be other, better approaches
>       as well:
>
>  - introduce a new resource type that is 'sticky': it would keep BARs
>    that are embedded in it from being reallocated.
>
> or
>
>  - update the hpet_address from the PCI code. This is risky though: these
>    PCI devices are often non-generic and might break if we change their
>    BAR.
>
> or
>
>  - do not insert e820 reserved entries at all. This would have
>    disadvantages as well: if there's some special non-RAM ACPI or SMM
>    area known to the system and enumerated in the e820 map, we must not
>    allow the PCI code from possibly allocating a resource into that
>    region.
>
> [ mingo@elte.hu: cleanups ]
>
> Bisected-by: David Witbrodt <dawitbro@sbcglobal.net>
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> Tested-by: David Witbrodt <dawitbro@sbcglobal.net>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/pci/i386.c |   44 ++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 44 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
> index 5807d1b..57be547 100644
> --- a/arch/x86/pci/i386.c
> +++ b/arch/x86/pci/i386.c
> @@ -28,6 +28,7 @@
>  #include <linux/kernel.h>
>  #include <linux/pci.h>
>  #include <linux/init.h>
> +#include <linux/hpet.h>
>  #include <linux/ioport.h>
>  #include <linux/errno.h>
>  #include <linux/bootmem.h>
> @@ -78,6 +79,47 @@ pcibios_align_resource(void *data, struct resource *res,
>  EXPORT_SYMBOL(pcibios_align_resource);
>  
>  /*
> + * Make sure we protect magic platform devices such as hpet,
> + * even if they show up in PCI discovery. (which should really
> + * not happen, but it does on some broken BIOSen)
> + */
> +static int check_platform(struct pci_dev *dev, struct resource *res)
> +{
> +	unsigned long base;
> +	unsigned long size;
> +
> +	base = res->start;
> +	size = (res->start == 0 && res->end == res->start) ? 0 :
> +		 (res->end - res->start + 1);
> +
> +	if (!base || !size)
> +		return 0;
> +
> +#ifdef CONFIG_HPET_TIMER
> +	/* for hpet */
> +	if (base == hpet_address && (res->flags & IORESOURCE_MEM)) {
> +		struct resource *root = NULL;
> +
> +		WARN("BAR has HPET at %08lx-%08lx\n", base, base + size - 1);
> +		/*
> +		 * forcibly insert it into the
> +		 * resource tree
> +		 */
> +		if (res->flags & IORESOURCE_MEM)
> +			root = &iomem_resource;
> +		else if (res->flags & IORESOURCE_IO)
> +			root = &ioport_resource;
> +
> +		if (root)
> +			insert_resource(root, res);
> +		return 1;
> +	}
> +#endif
> +
> +	return 0;
> +}
> +
> +/*
>   *  Handle resources of PCI devices.  If the world were perfect, we could
>   *  just allocate all the resource regions and do nothing more.  It isn't.
>   *  On the other hand, we cannot just re-allocate all devices, as it would
> @@ -171,6 +213,8 @@ static void __init pcibios_allocate_resources(int pass)
>  					r->flags, disabled, pass);
>  				pr = pci_find_parent_resource(dev, r);
>  				if (!pr || request_resource(pr, r) < 0) {
> +					if (check_platform(dev, r))
> +						continue;
>  					dev_err(&dev->dev, "BAR %d: can't "
>  						"allocate resource\n", idx);
>  					/* We'll assign a new address later */
