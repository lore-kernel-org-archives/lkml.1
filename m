Return-Path: <linux-kernel-owner+w=401wt.eu-S1756879AbZLWUap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879AbZLWUap (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 15:30:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752623AbZLWUao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 15:30:44 -0500
Received: from mga11.intel.com ([192.55.52.93]:40710 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751979AbZLWUao (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 15:30:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,444,1257148800"; 
   d="scan'208";a="525852685"
Subject: Re: [Fdutils] DMA cache consistency bug introduced in 2.6.28
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "markh@compro.net" <markh@compro.net>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "dmarkh@cfl.rr.com" <dmarkh@cfl.rr.com>, Alain Knaff <alain@knaff.lu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "fdutils@fdutils.linux.lu" <fdutils@fdutils.linux.lu>,
       "Li, Shaohua" <shaohua.li@intel.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4B3270FE.5090607@compro.net>
References: <alpine.LFD.2.00.0912220922250.31313@localhost.localdomain>
	 <4B310879.9050701@compro.net>
	 <1261525076.16916.4.camel@localhost.localdomain>
	 <4B3162BC.9000508@cfl.rr.com> <4B3214EC.6020308@compro.net>
	 <6598A4E21F1DB24D80BF72956484F59802EFD1C6@orsmsx001.amr.corp.intel.com>
	 <4B32386B.2060509@compro.net>
	 <alpine.LFD.2.00.0912230828230.6879@localhost.localdomain>
	 <87bphpd4rt.fsf@basil.nowhere.org> <4B32565E.6000501@compro.net>
	 <20091223191806.GA3336@linux-os.sc.intel.com> <4B3270FE.5090607@compro.net>
Content-Type: text/plain
Date: Wed, 23 Dec 2009 12:30:43 -0800
Message-Id: <1261600243.16916.56.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-23 at 11:35 -0800, Mark Hounschell wrote:
> On 12/23/2009 02:18 PM, Pallipadi, Venkatesh wrote:
> > On Wed, Dec 23, 2009 at 09:41:50AM -0800, Mark Hounschell wrote:
> >> On 12/23/2009 11:38 AM, Andi Kleen wrote:
> >>> Linus Torvalds <torvalds@linux-foundation.org> writes:
> >>>
> >>>> It's not using the lapic for CPU0. 
> >>>>
> >>>> Using the HPET as a per-cpu timer is some crazy sh*t, since it's pretty 
> >>>> expensive to reprogram (compared to the local apic). And having different 
> >>>> timers for different CPU's is just odd.
> >>>>
> >>>> The fact that the timer subsystem can do this and it all (mostly) works at 
> >>>> all is nice and impressive, but doesn't make it any less crazy ;)
> >>>
> >>> I suspect it's a system where the APIC timer stops in deeper idle
> >>> states and it supports them. In this case CPU #0 does timer broadcasts
> >>> when needed to wake the other CPUs up from deep C, but for that it has
> >>> to run with HPET. At least the other ones can still enjoy the LAPIC
> >>> timer.
> >>>
> >>> This might suggest that Mark's floppy controller doesn't like
> >>> deep C? Mark, did you try booting with processor.max_cstate=1
> >>> and HPET enabled?
> >>
> >> I just did and /proc/interrupts looks the same and the floppy still does
> >> not format.
> >>
> > 
> > Can you try this one line patch either on .28 or .32 (with /proc/interrupts
> > output).
> > This disables hpet2 and lapic timer should then be used on CPU 0. If things
> > work with this test patch, we will know that the failure is somehow related
> > to HPET usage in MSI mode.
> > 
> > Thanks,
> > Venki
> > 
> > Reduce the rating of percpu hpet timer
> > 
> > Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> > ---
> >  arch/x86/kernel/hpet.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
> > index cafb1c6..f89d17a 100644
> > --- a/arch/x86/kernel/hpet.c
> > +++ b/arch/x86/kernel/hpet.c
> > @@ -480,7 +480,7 @@ static void init_one_hpet_msi_clockevent(struct hpet_dev *hdev, int cpu)
> >  	hpet_setup_irq(hdev);
> >  	evt->irq = hdev->irq;
> >  
> > -	evt->rating = 110;
> > +	evt->rating = 40;
> >  	evt->features = CLOCK_EVT_FEAT_ONESHOT;
> >  	if (hdev->flags & HPET_DEV_PERI_CAP)
> >  		evt->features |= CLOCK_EVT_FEAT_PERIODIC;
> 
> That made it work. Used 2.6.32.2
> 
> cat /proc/interrupts
>            CPU0       CPU1       CPU2       CPU3
>   0:         82          0          0          1   IO-APIC-edge      timer
>   1:          0          0          0         67   IO-APIC-edge      i8042
>   3:          0          0          0          6   IO-APIC-edge
>   4:          0          0          0          4   IO-APIC-edge
>   6:          0          0          0          4   IO-APIC-edge      floppy
>   8:          0          0          0          8   IO-APIC-edge      rtc0
>   9:          0          0          0          0   IO-APIC-fasteoi   acpi
>  12:          0          0         10       1519   IO-APIC-edge      i8042
>  14:          0          0         39      10995   IO-APIC-edge
> pata_atiixp
>  15:          0          0          3        391   IO-APIC-edge
> pata_atiixp
>  16:          0          0          2        606   IO-APIC-fasteoi
> aic79xx, ohci_hcd:usb3, ohci_hcd:usb4, HDA Intel, Digi DBX2, ni-pci-gpib
>  17:          0          0          0          3   IO-APIC-fasteoi
> ehci_hcd:usb1, parport0, ni-pci-gpib
>  18:          0          0         10       2168   IO-APIC-fasteoi
> ohci_hcd:usb5, ohci_hcd:usb6, ohci_hcd:usb7, Digi DBX2, nvidia
>  19:          0          0          0        130   IO-APIC-fasteoi
> aic7xxx, ehci_hcd:usb2, ttySLG0, eth1
>  22:          0          0          8       1151   IO-APIC-fasteoi   ahci
>  24:          0          0          0          0  HPET_MSI-edge      hpet2
>  29:          0          0          0         48   PCI-MSI-edge
> sky2@pci:0000:04:00.0
> NMI:          0          0          0          0   Non-maskable interrupts
> LOC:      34842      30177      29672      29632   Local timer interrupts
> SPU:          0          0          0          0   Spurious interrupts
> PMI:          0          0          0          0   Performance monitoring
> interrupts
> PND:          0          0          0          0   Performance pending work
> RES:      17501      20449      16670      11224   Rescheduling interrupts
> CAL:      10554       2336       1102       1071   Function call interrupts
> TLB:        364        562        753        468   TLB shootdowns
> ERR:          0
> MIS:          0
> 
> 
> # fdformat /dev/fd0u1440
> Double-sided, 80 tracks, 18 sec/track. Total capacity 1440 kB.
> Formatting ... done
> Verifying ... done

Hmmm.. Thats very interesting indeed.

That clearly says that HPET MSI interrupts somehow is causing some
caching side effect in the chipset that results in this floppy dma
failure.

Here's is what we have until now.
IRQ 0 is based on HPET legacy interrupt and HPET device is also capable
of MSI on this platform. So we also have a percpu hpet (hpet2 tied to
CPU0). percpu hpet was added to avoid the usage of IRQ0+LAPIC broadcast
in cases where LAPIC timer will stop working in deep C-state. As we have
only one HPET channel free for percpu HPET, we only have hpet2 tied to
CPU 0 and other CPUs still have to go through IRQ0+LAPIC broadcast with
deep C-state.

One problem here is that percpu hpet should only get used when LAPIC
cannot be used (that is when CPU enters deep C-state). Using hpet2 in
place of LAPIC timer even when deep C-state is not supported is not
right in terms of performance. We need some changes here to fix that
[Problem 1].

But, that still does not explain why we are seeing this problem in the
first place. I mean, using hpet2 is not optimal, but should not have
functionality issues like this. Even fixing [Problem 1] above, we may
see this problem on some other platform that supports deep C-state and
so has hpet2 enabled for a valid reason.

Also, I am not sure whether the problem also happens if legacy HPET
interrupts are used during run time in place of LAPIC timer (May be
worth to try this with a simple test patch, let me think about it). In
this case, legacy HPET interrupt rightly goes quiet after boot, giving
priority to LAPIC timer.

With hpet MSI interrupts, we do a write followed by read of HPET
memmapped register to set a HPET channel timeout + read of global HPET
timer. This happens on every timer interrupt on CPU 0. And we also have
MSI interrupt being delivered to CPU 0. I cannot think of any reason why
this can break dma. We can probably try adding some dummy HPET read
after dma write, to see if that flushes things properly.

Thanks,
Venki

