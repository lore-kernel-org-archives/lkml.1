Return-Path: <linux-kernel-owner+w=401wt.eu-S1758113AbYLDXrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758113AbYLDXrn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 18:47:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755742AbYLDXqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 18:46:35 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:53520 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755538AbYLDXqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 18:46:34 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Regression from 2.6.26: Hibernation (possibly suspend) broken on Toshiba R500 (bisected)
Date: Fri, 5 Dec 2008 00:45:40 +0100
User-Agent: KMail/1.9.9
Cc: Frans Pop <elendil@planet.nl>, Greg KH <greg@kroah.com>,
       Ingo Molnar <mingo@elte.hu>, jbarnes@virtuousgeek.org, lenb@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tiwai@suse.de,
       Andrew Morton <akpm@linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <200812042340.58694.rjw@sisk.pl> <alpine.LFD.2.00.0812041459120.3543@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0812041459120.3543@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812050045.40928.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 5 of December 2008, Linus Torvalds wrote:
> 
> On Thu, 4 Dec 2008, Rafael J. Wysocki wrote:
> > 
> > That said the "don't bother allocating bridging windows for transparent
> > bridges" patch resulted in the following layout on my box (from /proc/iomem):
> > 
> > 88000000-8807ffff : 0000:00:02.1
> > 88080000-88083fff : 0000:00:1b.0
> >   88080000-88083fff : ICH HD audio
> > 88084000-88087fff : 0000:03:0b.1
> > 88088000-88088fff : 0000:03:0b.0
> >   88088000-88088fff : yenta_socket
> > 88089000-880897ff : 0000:03:0b.1
> >   88089000-880897ff : firewire_ohci
> > 88089800-880898ff : 0000:03:0b.3
> >   88089800-880898ff : mmc0
> > 8808a000-8808afff : Intel Flush Page
> > 8c000000-8fffffff : PCI CardBus 0000:04
> > 90000000-93ffffff : PCI CardBus 0000:04
> > 
> > while my "don't allocate bridging windows for cardbus bridges behind
> > transparent bridges" patch I've just sent (appended for easier reference)
> > results in the layout:
> > 
> > 88000000-880fffff : PCI Bus 0000:03
> >   88000000-88003fff : 0000:03:0b.1
> >   88004000-88004fff : 0000:03:0b.0
> >     88004000-88004fff : yenta_socket
> >   88005000-880057ff : 0000:03:0b.1
> >     88005000-880057ff : firewire_ohci
> >   88005800-880058ff : 0000:03:0b.3
> >     88005800-880058ff : mmc0
> > 88100000-8817ffff : 0000:00:02.1
> > 88180000-88183fff : 0000:00:1b.0
> >   88180000-88183fff : ICH HD audio
> > 88184000-88184fff : Intel Flush Page
> > 8c000000-8fffffff : PCI CardBus 0000:04
> > 90000000-93ffffff : PCI CardBus 0000:04
> 
> Well, this happens because in the second case, you still will allocate a 
> non-prefetchable window due to the _other_ devices behind the bridge (ie 
> the firewire and mmc device.
> 
> So with your "ignore cardbus device resources", you still do end up with a 
> bridge window allocated, but now it will depend entirely on what other 
> devices exist on that PCI bus. Which is why I really dislike that patch, 
> because it really makes no sense at all. 
> 
> And once you've allocated the PCI bridge window, then the alignment 
> requirements are that you end up having at least 1MB of window, and now 
> because a window exists, and will fit, it will then happily put the yenta 
> control mappings into that window even though it didn't size it for them.
> 
> See?
> 
> Also, notice how it doesn't put the actual cardbus bridge windows 
> themselves into that PCI bridge window, because they won't fit. So these 
> resources:
> 
> 	8c000000-8fffffff : PCI CardBus 0000:04
> 	90000000-93ffffff : PCI CardBus 0000:04
> 
> are outside the window, even though that bus is topologically inside the 
> same bus, and they both end up depending on the fact that the PCI bus 
> controller is transparent.
> 
> So the above results are fairly easy to explain.
> 
> The _ordering_ difference comes simply from the allocation order. We'll do 
> bus allocations first (if we do them), which is why _if_ we allocate a 
> window for that PCI bus 03 (ie the one that is bridged to by 0:1e.0, that 
> transparent bridge), then we'll end up allocating it first. So that's why 
> the PCI bridge window shows up at 0x88000000, if it shows up at all 
> (because that's the starting address for PCI allocations).
> 
> Then, we'll do the regular devices in the order we found them, so then 
> we'll allocate the resources for device 0:02.1 and then 0:1b.0. Now, _if_ 
> we did a bus window allocation, they'll end up being after the bus window 
> we allocated. Otherwise they'll end up being the first allocations.
> 
> So then, by the time we actually get to bus#3, and devices 3:0b.*, where 
> they end up is going to depend on whether we allocated that bus window (in 
> which case they'll preferentially get allocated inside the window - ie 
> starting at 0x88000000), or they'll just get allocated inside the parent 
> (root) PCI bus. In the latter case they'll be allocated after the 0:02.1 
> etc devices.
> 
> So the differences in ordering really do make sense, and are a direct 
> consequence of whether we decided to need to allocate a bridging window 
> for that PCI-PCI bridge at 0:1e.0.
> 
> Also note that _if_ PCI bus #3 had had other devices with prefetchable 
> memory resources, then we'd have allocated a prefetchable window for 
> those even with your patch, and then we'd have been back to the original 
> allocation again (although sizing might cause changes, since your patch 
> will make us ignore the cardbus controlle for sizing).

Yes, I do realize all of what you said above.  I only wanted to note that the
layouts of device's memory ranges are different with both patches.

> > where devices behind the transparent bridge (PCI Bus 0000:03) are located
> > _before_ ICH HD audio in the memory address space, and this one appears to
> > work.  So there _may_ be an effect of the layout too.
> 
> I do agree that your patch will affect layout. I just don't think it makes 
> any real amount of sense because of how it essentially does so "randomly" 
> depending on what other devices you'd have behind the transparent bridge.
> 
> Which is why I think we should either not size transparent bridges at all, 
> or we should size _all_ the devices behind them.

I'm not saying it's unreasonable to do this in general.  Still, on this
particular box it appears to break things in a very subtle way.

Also, I do realize that most probably the root cause of that is something
else, but we can make it show up itself or hide by changing the layout of
the memory space.  What is this, though, I don't know.

> Oh, btw, I thought your and Frans' laptops were identical?

No, they are from different vendors. :-)  Mine is a Toshiba one and the Frans'
one is from HP.

> They don't seem to be: in Frans' case, the firmware does seem to set up one
> memory window, so he gets that one even with my "don't size anything" patch,
> just because we'll still honor allocations done by firmware.
> 
> > Well, given that both affected boxes have the same chipset (945GM), I seriously
> > suspect a nastiness in that chipset we're not aware of.  Especially that
> > the problem is not reproducible without snd_hda_intel (at least on my box).
> 
> Well, the counter-argument to that is that the 945GM should be a _very_ 
> common chipset. So I'd not expect a chipset nastiness.

Unless people don't report problems with it, because they are so rare that
are regarded as "random" and "unreproducible".

Also, since the layout of devices in the PCI config space seems to matter,
the problem need not appear on other systems with that chipset at all.

> I'd be more wary about the BIOS doing something odd. Or an ACPI thing. 

Well, unlikely, _unless_ Toshiba and HP both use the same Intel reference
BIOS or something.

> > I've already checked the resume ordering of PCI devices on my box and it
> > is the following:
> >   [snip]
> > So, snd_hda_intel resumes before all of the bridges and the layout of devices
> > _behind_ the transparent bridge shouldn't affect it at all.
> 
> Yes. And in the case of Frans' machine, the e1000e controller was before 
> all the bridges too.

Hm.  And unloading it before suspend made things work?  Interesting.

Rafael
