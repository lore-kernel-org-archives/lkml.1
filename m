Return-Path: <linux-kernel-owner+w=401wt.eu-S1759246AbYLDWlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759246AbYLDWlx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 17:41:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753554AbYLDWlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 17:41:45 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:53292 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752776AbYLDWlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 17:41:44 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Regression from 2.6.26: Hibernation (possibly suspend) broken on Toshiba R500 (bisected)
Date: Thu, 4 Dec 2008 23:40:58 +0100
User-Agent: KMail/1.9.9
Cc: Frans Pop <elendil@planet.nl>, Greg KH <greg@kroah.com>,
       Ingo Molnar <mingo@elte.hu>, jbarnes@virtuousgeek.org, lenb@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tiwai@suse.de,
       Andrew Morton <akpm@linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <200812041229.45443.elendil@planet.nl> <alpine.LFD.2.00.0812040754020.3256@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0812040754020.3256@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812042340.58694.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 4 of December 2008, Linus Torvalds wrote:
> 
> On Thu, 4 Dec 2008, Frans Pop wrote:
> 
> > On Wednesday 03 December 2008, Linus Torvalds wrote:
> > > Well, I think that what _would_ be generally correct, and actually
> > > pretty simple, is a rather different approach: just not sizing things
> > > behind a transparent bridge AT ALL, since it really shouldn't matter.
> > 
> > I've given your patch a try and the few resumes from STR I've done were 
> > all successful. That's not 100% conclusive yet, but a nice start.
> > Some info from logs etc. below.
> 
> Ok, but I thought you had a hard time reproducing this _anyway_, even with 
> just plain -rc7. No?
> 
> That said, of the various patches posted, the "don't bother allocating 
> bridging windows for transparent bridges" one is not just the simplest, 
> but the only one that actually makes sense so far.
> 
> So I'm happy it's apparently working for you, I'm just wondering about 
> whather your success means a lot. It seems that Rafael is the one who had 
> more failures?

This most probably is correct and I got a resume failure with that patch
applied, so it evidently doesn't fix the problem. :-(

> > > > Also, I would be happy to actually understand _why_ this happens.
> > >
> > > 100% agreed. I do _not_ see why it should ever matter how we set up a
> > > PCI bridging window - whether prefetchable or not - on a bridge that
> > > should be transparent. It sounds really odd. I'm wondering if there is
> > > something we're missing here.
> > 
> > The theory that it is really a resume issue and not a device layout issue 
> > sounds logical. Especially as everything always works correctly after a 
> > normal boot.
> 
> Yes, that does sound like a convincing argument. Usually real PCI resource 
> clashes result in some kind of run-time problems, and wouldn't necessarily 
> be suspend-specific per se.
> 
> That said, suspend/resume does a lot of unusual things, so it could still 
> be some odd PCI resource clash that only triggers problems in the 
> suspend/resume case. But since the exact layouts and the sizing of the 
> resources doesn't really seem to matter, a simple PCI resource clash seems 
> rather unlikely.

I agree.

That said the "don't bother allocating bridging windows for transparent
bridges" patch resulted in the following layout on my box (from /proc/iomem):

88000000-8807ffff : 0000:00:02.1
88080000-88083fff : 0000:00:1b.0
  88080000-88083fff : ICH HD audio
88084000-88087fff : 0000:03:0b.1
88088000-88088fff : 0000:03:0b.0
  88088000-88088fff : yenta_socket
88089000-880897ff : 0000:03:0b.1
  88089000-880897ff : firewire_ohci
88089800-880898ff : 0000:03:0b.3
  88089800-880898ff : mmc0
8808a000-8808afff : Intel Flush Page
8c000000-8fffffff : PCI CardBus 0000:04
90000000-93ffffff : PCI CardBus 0000:04

while my "don't allocate bridging windows for cardbus bridges behind
transparent bridges" patch I've just sent (appended for easier reference)
results in the layout:

88000000-880fffff : PCI Bus 0000:03
  88000000-88003fff : 0000:03:0b.1
  88004000-88004fff : 0000:03:0b.0
    88004000-88004fff : yenta_socket
  88005000-880057ff : 0000:03:0b.1
    88005000-880057ff : firewire_ohci
  88005800-880058ff : 0000:03:0b.3
    88005800-880058ff : mmc0
88100000-8817ffff : 0000:00:02.1
88180000-88183fff : 0000:00:1b.0
  88180000-88183fff : ICH HD audio
88184000-88184fff : Intel Flush Page
8c000000-8fffffff : PCI CardBus 0000:04
90000000-93ffffff : PCI CardBus 0000:04

where devices behind the transparent bridge (PCI Bus 0000:03) are located
_before_ ICH HD audio in the memory address space, and this one appears to
work.  So there _may_ be an effect of the layout too.

> So some kind of resume-time ordering or timing issue does seem like the 
> most likely thing. But that still leaves us not knowing what the real 
> _root_ cause of this all is - very irritating. Even if not allocating the 
> unnecessary bridging windows "fixes" things, it would be really really 
> good to know exactly what it is that causes problems.

Well, given that both affected boxes have the same chipset (945GM), I seriously
suspect a nastiness in that chipset we're not aware of.  Especially that
the problem is not reproducible without snd_hda_intel (at least on my box).

> > Below info from 3 kernels, all based on 2.6.28-rc7-91:
> > A) unpatched
> > B) with the revert/debug patch
> > C) with the oneliner "ignore transparent bridges" patch
> > 
> > AFAICT all results are probably as expected.
> > 
> > From lspci -vvxxx:
> > 00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge
> > - for A)
> > 	I/O behind bridge: 00003000-00003fff
> > 	Memory behind bridge: e0100000-e03fffff
> > 	Prefetchable memory behind bridge: 0000000080000000-0000000083ffffff
> > - for B)
> > 	I/O behind bridge: 00003000-00003fff
> > 	Memory behind bridge: e0100000-e03fffff
> > - for C)
> > 	Memory behind bridge: e0100000-e03fffff
> 
> And this all makes total sense. The e0100000-e03fffff MMIO bridge range is 
> apparently set up by the firmware, which is why it shows up in all cases. 
> And the (A) case has that prefetchable memory range, because that's the 
> only case that finds - and cares about - the prefetch window for the 
> CardBus controller. 
> 
> And both (A) and (B) have the IO bridging window, because regardless of 
> whether we see a valid CardBus prefetchable memory window with good 
> alignment, we'll always see the IO ports, so we'll try to allocate that 
> bridging window, except in (C) when we decide that due to the transparent 
> nature, we simply don't care.
> 
> So the PCI resources make sense in all three cases, and we understand 
> those. The differences in the actual Cardbus ranges also all make sense. 
> So it all still boils down to the PCI layer doing everything right in 
> _all_ cases, just making slightly different - but all valid - choices 
> depending on essentially random details (eg the revert/debug patch case 
> the "random detail" is just enabling a small incorrect alignment).
> 
> IOW, it really doesn't look like a PCI resource allocator bug. Quite the 
> reverse, I'd say that in the end this whole thread points out just how 
> robust the whole PCI and cardbus resource allocation is, with the code 
> really very gracefully just adjusting in a sane manner to all these 
> different cases.
> 
> Of course, none of that helps us with any kind of idea of what the real 
> problem is. Device ordering bug in setting up PCI resources at resume? 
> Perhaps just a plain bug in PCI bridge resume code (even when you resume 
> things in the right order)?
> 
> And I still worry that perhaps it's just a timing bug, where having a PCI 
> bridging window changes timing of various PCI accesses, and the _real_ bug 
> is actually in the sound card or ethernet driver resume, which happens to 
> work with one timing and not with another.
> 
> Since it's apparently STR, has anybody gotten _anything_ sane out of 
> trying to enable PM_TRACE_RTC, and then doing that 
> 
> 	echo 1 > /sys/power/pm_trace
> 
> because even with the (very limited) set of standard trace-points, it 
> should still be able to tell which device we were trying to resume last in 
> the failure case Maybe that gives some hint?

Well, I think more fine-grained debugging will be necessary.

I've already checked the resume ordering of PCI devices on my box and it
is the following:

pci:0000:00:00.0
pci:0000:00:02.0 <- graphics
pci:0000:00:02.1 <- graphics
pci:0000:00:1b.0 <- snd_hda_intel
pci:0000:00:1c.0 <- PCI Express port 1
pci:0000:00:1c.2 <- PCI Express port 3
pci:0000:00:1d.0 <- USB UHCI
pci:0000:00:1d.1 <- USB UHCI
pci:0000:00:1d.2 <- USB UHCI
pci:0000:00:1d.3 <- USB UHCI
pci:0000:00:1d.7 <- USB EHCI
pci:0000:00:1e.0 <- transparent bridge (Intel Corporation 82801 Mobile PCI Bridge)
pci:0000:00:1f.0 <- ISA bridge
pci:0000:00:1f.2 <- SATA (ahci)
pci:0000:01:00.0 <- e1000e
No Bus:0000:01
pci:0000:02:00.0 <- wireless (iwlagn)
No Bus:0000:02
pci:0000:03:0b.0 <- cardbus bridge
pci:0000:03:0b.1 <- FireWire
pci:0000:03:0b.3 <- SD Host controller (Texas Instruments)
No Bus:0000:04
No Bus:0000:03

So, snd_hda_intel resumes before all of the bridges and the layout of devices
_behind_ the transparent bridge shouldn't affect it at all.

Thanks,
Rafael
