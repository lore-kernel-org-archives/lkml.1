Return-Path: <linux-kernel-owner+w=401wt.eu-S1758127AbZA2Kox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758127AbZA2Kox (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 05:44:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752487AbZA2Kop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 05:44:45 -0500
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:43054 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223AbZA2Koo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 05:44:44 -0500
Date: Thu, 29 Jan 2009 02:44:42 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell2.speakeasy.net
To: Alex Chiang <achiang@hp.com>
cc: jbarnes@virtuousgeek.org, djwong@us.ibm.com, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 00/10] PCI core learns 'hotplug'
In-Reply-To: <20090128213814.28003.34634.stgit@bob.kio>
Message-ID: <Pine.LNX.4.58.0901290221480.17300@shell2.speakeasy.net>
References: <20090128213814.28003.34634.stgit@bob.kio>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jan 2009, Alex Chiang wrote:
> A while ago, Darrick Wong posted a patch for fakephp that kicked off
> some controversy:
>
> 	http://thread.gmane.org/gmane.linux.kernel/761944
>
> The issue was that I broke the fakephp interface back in the 2.6.27
> timeframe. After some discussion on the lists, Trent Piepho sent some
> patches, and I proposed a solution incorporating those patches.
>
> This is my first cut at making everyone happy. In summary, it:
>
> 	- introduces /sys/bus/pci/devices/.../remove for function level
> 	  hot-remove
>
> 	- introduces /sys/bus/pci/devices/.../rescan to rescan the PCI
> 	  hierarchy, starting at that device and descending to all children
>
> 	- introduces /sys/bus/pci/rescan to rescan the entire PCI hierarchy
>
> 	- restores the pre-2.6.27 fakephp interface for userspace compatability

I also continued to work on my patches, but then my reasons for caring
about PCI hotplug disappeared due to the current economic climate.

I updated my "remove" patch to include documentation.  I created a patch
that added "/sys/bus/pci/scan", but not the per-device version.  And I
updated my new fakephp driver to support rescanning.

Everything worked, but when a bridge was rescanned there would be annoying
warning messages.  I never got around to figuring about what to do about
that.  It seems like the code that assigns bridge resources wasn't intended
to handle bridges that already had resources assigned to them, though it
does work.

Maybe your series can use my latest patches for removal and legacy_fakephp?
It sounds like your patches for rescanning do more than mine.


> 	- I've been testing this patchset on my ia64 machines, which Linus
> 	  has called "an insane mess of PCI bridges"[1], and it seems to
> 	  work well. I'm just starting to test on some x86 machines, and
> 	  have been noticing some issues with BAR collisions, so this is
> 	  definitely a work-in-progress.

Does it not work, or is it just warnings?  I didn't have any problems with
resources ending up unassigned, but I did get warnings.  I think there was
also an issue with removed and rescanned devices' resources' ->parent
pointers not being the same as they were before removal.  Which doesn't
seem to matter any, but made me feel like the code wasn't right yet.

> 	  If you use the new PCI core removal/rescan and then try to modify
> 	  the slot using acpiphp, you get an oops. My impression is that
> 	  this behavior is the same as pre-2.6.27, where you could have
> 	  loaded fakephp and acpiphp, removed the device with fakephp,
> 	  and encountered an oops with acpiphp.

I came to the same conclusion.  fakephp or acpiphp will oops if you use the
other to remove a pci device.  The drivers just aren't designed to handle a
pci device being removed out from under them.

> 	  So, I'm not sure what to do about this. The way that we remove
> 	  devices today, using pci_remove_bus_device() doesn't lend itself
> 	  to safety very well, since it will just start removing devices
> 	  from the bus without checking anything.
>
> 	  Maybe we need some other API, or maybe we just live with the
> 	  limitation of, "if you use PCI core hotplug, don't use the
> 	  other hotplug drivers and vice versa".

My new fakephp driver seems to handle this ok, maybe other php drivers
could do the same thing?
