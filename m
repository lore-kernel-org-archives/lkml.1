Return-Path: <linux-kernel-owner+w=401wt.eu-S1754060AbZCIQux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060AbZCIQux (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 12:50:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751382AbZCIQuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 12:50:44 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:41179 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbZCIQun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 12:50:43 -0400
Date: Mon, 9 Mar 2009 10:50:10 -0600
From: Alex Chiang <achiang@hp.com>
To: Greg KH <greg@kroah.com>
Cc: kay.sievers@vrfy.org, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: kobj refcounting weirdness
Message-ID: <20090309165010.GB32589@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>, Greg KH <greg@kroah.com>,
	kay.sievers@vrfy.org, rjw@sisk.pl, linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org
References: <20090309063654.GB23137@ldl.fc.hp.com> <20090309150453.GB7627@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090309150453.GB7627@kroah.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg KH <greg@kroah.com>:
> On Mon, Mar 09, 2009 at 12:36:54AM -0600, Alex Chiang wrote:
> > Hi Kay, Greg,
> > 
> > I've been working on this patch series recently that adds
> > function and device level hotplug into the PCI core:
> > 
> > 	http://thread.gmane.org/gmane.linux.kernel.pci/3495
> > 
> > For the last two weeks, I've been beating my head against a
> > refcounting/kobject problem, and was hoping you could give me
> > some advice, since I seem to have run into a wall.
> > 
> > My test case has been removing device 0000:04:00.0, which should
> > remove all the devices below it.
> 
> You are removing the children before the parent device, right?  If not,
> you have to be _very_ careful (personally, I don't think you should be
> allowed to do that, but others, like the scsi developers, like doing
> things like this...)

Yes, I'm removing children before the parent, using the
pci_remove_bus_device() interface.

> > In this data set, I turned on kobject debugging, and managed to
> > capture a trace where we die on the 2nd rescan.
> > 
> > In this data set, we:
> > 
> > 	- create a kobject for 0000:04:00.0 (e00000018cac2920)
> > 	- remove the device
> > 	- observe '0000:04:00.0' (e00000018cac2920): calling ktype release
> > 	- rescan the bus
> > 	- discover that e00000018cac2920 is still hanging around!
> 
> What do you mean by "rescan"?  

By rescan, I mean we're rescanning the entire PCI bus, looking
for new devices.

	for each PCI root bus:
		pci_scan_child_bus()
		pci_bus_add_devices()

> And sure, if you create a new device, it could be allocated at
> the same location, that's what the slab allocators do, right?

I thought about the allocators returning a pointer to the same
location that maybe has some valid looking data hanging around,
but it's not wise for someone like me to go pointing fingers at
the allocator before I've proven the bug isn't in my code. ;)

I'm just hoping for some advice on what else I could instrument
to try and track this down further.

Thanks.

/ac

