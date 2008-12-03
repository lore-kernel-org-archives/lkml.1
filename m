Return-Path: <linux-kernel-owner+w=401wt.eu-S1755363AbYLCABI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363AbYLCABI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 19:01:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753930AbYLCAAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 19:00:51 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43750 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753919AbYLCAAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 19:00:50 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Regression from 2.6.26: Hibernation (possibly suspend) broken on Toshiba R500 (bisected)
Date: Wed, 3 Dec 2008 01:00:17 +0100
User-Agent: KMail/1.9.9
Cc: Frans Pop <elendil@planet.nl>, Greg KH <greg@kroah.com>,
       Ingo Molnar <mingo@elte.hu>, jbarnes@virtuousgeek.org, lenb@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tiwai@suse.de,
       Andrew Morton <akpm@linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <200812022338.51284.rjw@sisk.pl> <alpine.LFD.2.00.0812021518160.3256@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0812021518160.3256@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812030100.18400.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 3 of December 2008, Linus Torvalds wrote:
> 
> On Tue, 2 Dec 2008, Rafael J. Wysocki wrote:
> > 
> > * dmesg output including one hibernation-resume cycle from 2.6.28-rc7 with the
> >   debug patch (appended for completness):
> > 
> >   http://www.sisk.pl/kernel/debug/mainline/2.6.28-rc7/dmesg-rc7-patched-prep.log
> > 
> > * dmesg output including one hibernation-resume cycle from 2.6.28-rc7 without
> >   the debug patch:
> > 
> >   http://www.sisk.pl/kernel/debug/mainline/2.6.28-rc7/dmesg-rc7-nopatch-prep.log
> 
> As with Frans, the debug patch seems to make no difference what-so-ever. 
> Yes, the cardbus regions get allocated differently, but they're fine in 
> either case, and arguably (exactly as with Frans) the debug patch actually 
> makes things uglier by actively getting the alignment wrong, and skipping 
> cardbus setup until later.

Hm, what about (from the copy of /proc/iomem without the patch at
http://www.sisk.pl/kernel/debug/mainline/2.6.28-rc7/rc7-nopatch/iomem):

88000000-8bffffff : PCI Bus 0000:03
  88000000-8bffffff : PCI CardBus 0000:04
8c000000-91ffffff : PCI Bus 0000:03
  8c000000-8fffffff : PCI CardBus 0000:04

(1) Why two ranges are allocated for 0000:03 without the patch while there is
    only one range with the patch:

88000000-880fffff : PCI Bus 0000:03

    (copy of the file at
    http://www.sisk.pl/kernel/debug/mainline/2.6.28-rc7/rc7-patched/iomem)?
    That seems to look like a difference to me.

(2) Why are they so large without the patch while with the patch they are much
    smaller (O(2^28) vs O(2^21) if I'm not mistaken)?

(3) Why are they overlapping with the ranges for CardBus 0000:04, although
    without the patch they aren't?  Is that actually correct at all?

> That's what your patch (without debugging) should have resulted in too, 
> except you'd not have seen the "bad alignment flags" printout, of course 
> (but you probably would have seen the "bad alignment 0: [...]" one).

Yes, I saw that:

bad alignment flags 21200 4000000 (0)
pci 0000:03:0b.0: BAR 9 bad alignment 0: [0x000000-0x3ffffff]
bad alignment flags 20200 4000000 (0)
pci 0000:03:0b.0: BAR 10 bad alignment 0: [0x000000-0x3ffffff]

> In fact, I'm starting to think I know why we set up the prefetch window 
> without the patch, and why we don't with it - because with the patch, the 
> PCI code ends up never seeing any valid prefetchable region for the 
> cardbus controller at all, so it never even bothers to try to set up a 
> prefetchable window.
> 
> So in many ways, the debug patch that gets the alignment wrong (on 
> purpose) is really the inferior one. Plain -rc7 seems to do everything 
> right.

Well, I'm not sure ...

> > * diff between the two:
> > 
> >   http://www.sisk.pl/kernel/debug/mainline/2.6.28-rc7/dmesg-rc7_nopatch-rc7_patched.diff
> 
> Gaah. Using "-U 0" is likely the least readable form of diffs there 
> exists, even if it makes the diff smaller.

Sorry.

To me it's more readable this way, but well.

> > This part of the diff  (+ is the patched one) seems to be particularly
> > interesting to me, especially the overlapping MEM windows for 0000:00:1e.0 and
> > 0000:03:0b.0 (may that be the reason for the observed failures?):
> 
> No, those are very much on purpose. 
> 
> Device 0000:00:1e.0 is the PCI bridge that bridges to PCI bus#3, so the 
> MEM window is very much intentional - exactly because MMIO goes through 
> that PCI bridge bus to get to bus#3, which is where the cardbus controller 
> is.
> 
> IOW, the topology is as follows: 
>  - CPU is on the root bus (bus #0)
>  - device 00:1e.0 is the PCI bridge to bus #3
>  - device 03:0b.0 is the CardBus bridge (to bus #4)
> and any actual cardbus cards (if you had any) would be on that bus #4, so 
> they'd be named "04:xx.y".
> 
> Now, that PCI bridge 00:1e.0 is a transparent bridge (aka "[Subtractive 
> decode]" in your lspci output - as compared to the other bridges that say 
> "[Normal decode]"), which means that you don't actually _have_ to set up 
> any MMIO window on them, since the bridge will forward _any_ PCI cycles 
> that don't get responded to by any other PCI device.
> 
> But having an explicit window is still generally a good idea, since it 
> should allow the PCI bridge to pick up the PCI cycles earlier (no need to 
> wait to see if others respond to it), and possibly allows for better 
> prefetching behavior. So again, the dmesg and the PCI layout actually 
> looks _better_ without the hacky patch.
> 
> So are you saying that the unpatched kernel still reliably doesn't 
> hibernate for you, while the (arguably _incorrect_) patched kernel 
> reliably does hibernate?

Yes, I am.

Thanks,
Rafael
