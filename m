Return-Path: <linux-kernel-owner+w=401wt.eu-S1754088AbYLHXgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088AbYLHXgl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 18:36:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752143AbYLHXgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 18:36:31 -0500
Received: from mu-out-0910.google.com ([209.85.134.190]:42363 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266AbYLHXga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 18:36:30 -0500
Subject: Re: [PATCH] ioc4: automatically load sgiioc4 subordinate module
From: Kay Sievers <kay.sievers@vrfy.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Brent Casavant <bcasavan@sgi.com>, linux-kernel@vger.kernel.org,
       mdr@sgi.com, rw@novell.com, Greg KH <greg@kroah.com>
In-Reply-To: <20081208145507.8d03834e.akpm@linux-foundation.org>
References: <alpine.BSF.1.10.0812051601060.388@pkunk.americas.sgi.com>
	 <20081208145507.8d03834e.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 09 Dec 2008 00:36:03 +0100
Message-Id: <1228779363.5099.41.camel@nga>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-12-08 at 14:55 -0800, Andrew Morton wrote:
> On Fri, 5 Dec 2008 16:04:37 -0600 (CST)
> Brent Casavant <bcasavan@sgi.com> wrote:
> 
> > The main ioc4 driver which manages ownership of the SGI IOC4 PCI device
> > does not automatically load any of the ioc4 submodules (the sgiioc4 IDE
> > and ioc4_serial serial drivers) during PCI device probing.  This causes
> > problems when the root device is a DVD-ROM attached to the IOC4 IDE
> > interface (e.g. during system installation) as the sgiioc4 module
> > will not be loaded and thus the DVD-ROM device will not be available.
> > 
> > Modify ioc4 to always load the sgiioc4 IDE module if the board carrying
> > the IOC4 hardware actually implements the IDE interface (not all boards
> > bring this functionality off the IOC4 chip).
> > 
> > The use of a work procedure is necessary as request_module() cannot be
> > called from the device probe path as it eventually calls out to userspace.
> > 
> 
> This is a fairly common problem, isn't it?

It is, but it's getting better with recent drivers. It is only a
problem, when there is "magic hidden mid-layer device binding" in the
kernel, which is not exposed to the driver core.

In an ideal world, the driver would create a custom bus "ioc4" (struct
bus_type), with the devices hanging off this bus. These devices would
then trigger the loading of the sub-driver modules, and the sub-drivers
would bind to the device created on the "ioc4" bus, just by driver-core
logic.

That would be the proper logic to make it work without any special
magic, just by the generic uevent/modalias/modprobe mechanism.

> Other drivers handle it via
> appropriate udev magic and initrd/initramfs setups.

We recently got rid of almost all custom hacks in udev rules.

Initramfs still has a bunch, but it's also getting smaller. We are down
from hundreds of exceptions/tables/rules, to a few exceptions today.

We have a real problem of maintaining/distributing such exceptions in/to
the installed systems. The exceptions and the magic have been growing,
and every system out there got almost all of these rules installed. Over
the time people completely lost track which of the rules are still
needed, and which are not. The split between the people doing kernel and
userspace work really hits us here.

You are right, that it looks a bit weird if you look at it just from
inside the kernel, but as long as we don't have a sane way to instruct
userspace/udev/initramfs/the installer from the kernel, like dropping
magic instructions along with the driver to the installed system,
changes like this are very welcome, not to bury userspace people in
exceptions.

One other problem is kernel updates on released systems, which we should
make as easy as possible. In some cases the installed magic does no
longer work for some reason, some innocent looking change mostly. So we
very much prefer, if possible, the driver to be self-contained regarding
the special magic it needs.

If it is not possible/too much work to change a driver to integrate
properly with the driver core, which as a result usually does not need
any magic, we welcome every such change that moves the needed magic into
the kernel itself.

Thanks,
Kay

