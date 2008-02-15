Return-Path: <linux-kernel-owner+w=401wt.eu-S933203AbYBOHsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933203AbYBOHsv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 02:48:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751220AbYBOHsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 02:48:41 -0500
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:51377 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbYBOHsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 02:48:40 -0500
Date: Fri, 15 Feb 2008 09:48:27 +0200
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Greg KH <greg@kroah.com>
Cc: jdmason@kudzu.us, bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       discuss@x86-64.org
Subject: Re: pci_get_device_reverse(), why does Calgary need this?
Message-ID: <20080215074827.GE4334@rhun.haifa.ibm.com>
References: <20080213001506.GA13933@kroah.com> <20080213001638.GB13933@kroah.com> <20080213093225.GA16985@rhun.haifa.ibm.com> <20080213173203.GC10733@kroah.com> <20080213174711.GB22274@rhun.haifa.ibm.com> <20080213181459.GA8960@kroah.com> <20080215071703.GA9022@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080215071703.GA9022@kroah.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2008 at 11:17:03PM -0800, Greg KH wrote:

> Hm, that's wierd.  I thought I got something, until I realized that
> you are doing a lot of logic before you ever even determine that
> your hardware is present in the system.  Why are you calling
> calgary_locate_bbars() and doing all of that work?  Or am I mising
> something in the code flow here?

Ok, it's all starting to come back to me. See below.

> Also, it looks like you use the pci_get_device() to find the pci
> device, then you do somethings, and then drop the device, never to
> use it again.
> 
> So, a traditional "probe" might not work as well, but it could be
> used if you want to.

We have a two stage initialization process. First, we need to be
initialized very early in order to be able to allocate relatively
large contiguous chunks of RAM. That requires detecting whether we're
on a Calgary/CalIOC2 system very early (detect_calgary(), called from
pci_iommu_alloc()). Then we have "regular" PCI initialization at a
later stage (calgary_iommu_init(), called from pci_iommu_init()),
which also calls calgary_locate_bbars(). Unlike a regular PCI device
which has its BARs in the configuration space, we need to probe BIOS
provided tables to find where our BARs are before we do anything else
with the "device representation" of the IOMMU. Note that the same
two-stage initialization scheme is used by all other x86 IOMMUs, for
similar reasons.

Now, Calgary is an isolation-capable IOMMU which has per-root-bus (as
opposed to global or per-BDF) IO address space. The reason we want to
access the pci_dev of each Calgary bus is to hang off of it the IOMMU
tables for all devices under that bus so that we end up using the
right translation table when a device asks for a DMA mapping. Hence
the loop in calgary_init, which loops over all pci_dev's of Calgary
busses, raises the ref count for each pci_dev to protect against
hot-unplug, and hooks up the IOMMU table for everything under that bus
to the pci_dev for the bus. Unlike a regular driver, our main entry
points are via the DMA-API, which takes a device's pci_dev, not
Calgary's. We then walk up the bus hierarchy and find the Calgary
pci_dev that is an ancestor of this device, and that gives us the
right IOMMU table to us. Note that this has to occur *before* PCI
device initialization, since we want to turn translation on before any
device will try to DMA.

In conclusion, our usage doesn't seem lika a good fit for the probe
approach, although it could probably converted provided we got the
ordering right with regards to regular PCI device
initialization. Doesn't seem to be worth the effort.

Cheers,
Muli

