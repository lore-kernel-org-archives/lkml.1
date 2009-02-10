Return-Path: <linux-kernel-owner+w=401wt.eu-S1757150AbZBJWVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757150AbZBJWVm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 17:21:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756752AbZBJWVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 17:21:30 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:29378 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756780AbZBJWV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 17:21:27 -0500
Date: Tue, 10 Feb 2009 15:21:26 -0700
From: Alex Chiang <achiang@hp.com>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: jbarnes@virtuousgeek.org, djwong@us.ibm.com, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 00/10] PCI core learns 'hotplug'
Message-ID: <20090210222126.GD446@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Trent Piepho <xyzzy@speakeasy.org>, jbarnes@virtuousgeek.org,
	djwong@us.ibm.com, linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20090128213814.28003.34634.stgit@bob.kio> <Pine.LNX.4.58.0901290221480.17300@shell2.speakeasy.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0901290221480.17300@shell2.speakeasy.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Trent,

Sorry for the very long delay. I've been swamped with other
things. :-/

* Trent Piepho <xyzzy@speakeasy.org>:
> On Wed, 28 Jan 2009, Alex Chiang wrote:
> > A while ago, Darrick Wong posted a patch for fakephp that kicked off
> > some controversy:
> >
> > 	http://thread.gmane.org/gmane.linux.kernel/761944
> >
> > The issue was that I broke the fakephp interface back in the 2.6.27
> > timeframe. After some discussion on the lists, Trent Piepho sent some
> > patches, and I proposed a solution incorporating those patches.
> >
> > This is my first cut at making everyone happy. In summary, it:
> >
> > 	- introduces /sys/bus/pci/devices/.../remove for function level
> > 	  hot-remove
> >
> > 	- introduces /sys/bus/pci/devices/.../rescan to rescan the PCI
> > 	  hierarchy, starting at that device and descending to all children
> >
> > 	- introduces /sys/bus/pci/rescan to rescan the entire PCI hierarchy
> >
> > 	- restores the pre-2.6.27 fakephp interface for userspace compatability
> 
> I also continued to work on my patches, but then my reasons for caring
> about PCI hotplug disappeared due to the current economic climate.

:(

> I updated my "remove" patch to include documentation.  I created a patch
> that added "/sys/bus/pci/scan", but not the per-device version.  And I
> updated my new fakephp driver to support rescanning.
> 
> Everything worked, but when a bridge was rescanned there would be annoying
> warning messages.  I never got around to figuring about what to do about
> that.  It seems like the code that assigns bridge resources wasn't intended
> to handle bridges that already had resources assigned to them, though it
> does work.
> 
> Maybe your series can use my latest patches for removal and legacy_fakephp?
> It sounds like your patches for rescanning do more than mine.

I will incorporate your patch for removal (and replace mine).

I've already incorporated your legacy_fakephp patch (although I
took the liberty of just replacing fakephp wholesale).

When (if? :) I work out the kinks, you'll get authorship credit
for both the above.

> > 	- I've been testing this patchset on my ia64 machines, which Linus
> > 	  has called "an insane mess of PCI bridges"[1], and it seems to
> > 	  work well. I'm just starting to test on some x86 machines, and
> > 	  have been noticing some issues with BAR collisions, so this is
> > 	  definitely a work-in-progress.
> 
> Does it not work, or is it just warnings?  I didn't have any problems with
> resources ending up unassigned, but I did get warnings.  I think there was
> also an issue with removed and rescanned devices' resources' ->parent
> pointers not being the same as they were before removal.  Which doesn't
> seem to matter any, but made me feel like the code wasn't right yet.

I'm actually getting errors on my x86 machine:

pci 0000:04:01.0: BAR 8: bogus alignment [0xfa000000-0xfbffffff] flags 0x200
pci 0000:04:01.0: BAR 9: bogus alignment [0xd1100000-0xd11fffff] flags 0x1201
...
pci 0000:07:00.0: BAR 8: bogus alignment [0xfa000000-0xfbffffff] flags 0x200
pci 0000:07:00.0: BAR 9: bogus alignment [0xd1100000-0xd11fffff] flags 0x1201
...
pcieport-driver 0000:04:01.0: irq 57 for MSI/MSI-X
pcieport-driver 0000:04:01.0: device not available because of BAR 8 [0xfa000000-0xfbffffff] collisions
pcieport-driver: probe of 0000:04:01.0 failed with error -22

Obviously, this needs to be figured out before going into
mainline, and even then, I think it might need some soak time in
-mm...

> > 	  If you use the new PCI core removal/rescan and then try to modify
> > 	  the slot using acpiphp, you get an oops. My impression is that
> > 	  this behavior is the same as pre-2.6.27, where you could have
> > 	  loaded fakephp and acpiphp, removed the device with fakephp,
> > 	  and encountered an oops with acpiphp.
> 
> I came to the same conclusion.  fakephp or acpiphp will oops if you use the
> other to remove a pci device.  The drivers just aren't designed to handle a
> pci device being removed out from under them.
> 
> > 	  So, I'm not sure what to do about this. The way that we remove
> > 	  devices today, using pci_remove_bus_device() doesn't lend itself
> > 	  to safety very well, since it will just start removing devices
> > 	  from the bus without checking anything.
> >
> > 	  Maybe we need some other API, or maybe we just live with the
> > 	  limitation of, "if you use PCI core hotplug, don't use the
> > 	  other hotplug drivers and vice versa".
> 
> My new fakephp driver seems to handle this ok, maybe other php drivers
> could do the same thing?

Yeah, I saw what you did by registering a bus notifier, nice
trick.

I don't think every driver wants to do this, it might be better
to change the hotplug core to require some sort of callback that
gets called when some other driver removes a device.

Thanks.

/ac


