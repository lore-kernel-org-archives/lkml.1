Return-Path: <linux-kernel-owner+w=401wt.eu-S1757111AbYHUUxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757111AbYHUUxh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 16:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753561AbYHUUx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 16:53:29 -0400
Received: from ns.suse.de ([195.135.220.2]:46528 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753426AbYHUUx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 16:53:28 -0400
Date: Thu, 21 Aug 2008 13:40:57 -0700
From: Greg KH <gregkh@suse.de>
To: Alex Chiang <achiang@hp.com>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: refcount leak in pci_get_device()?
Message-ID: <20080821204057.GA31543@suse.de>
References: <20080821201918.GA24411@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080821201918.GA24411@ldl.fc.hp.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 02:19:18PM -0600, Alex Chiang wrote:
> Hi Greg,
> 
> While playing around with my slot symlink stuff, I noticed that
> the following sequence is problematic:
> 
> 	1. clean boot
> 	2. modprobe acpiphp
> 	3. echo 0 > /sys/bus/pci/slots/N/power
> 	4. ???
> 
> After step 3, we *should* be seeing pci_release_dev() getting
> called, but we never do because the refcount on the device is
> still quite high (5 or 6, on my ia64 system).
> 
> I'm still trying to track this down, but I did notice, via code
> inspection, at least one suspicious area:
> 
> #define for_each_pci_dev(d) while ((d = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, d)) != NULL)
> 
> That eventually calls pci_get_dev_by_id(), which increases the
> refcount on the device, but never decrements it.
> 
> Looks like that change in behavior happened here:
> 
> 	PCI: clean up search.c a lot
> 	95247b57ed844511a212265b45cf9a919753aea1
> 
> pci_get_device() used to decrement the refcount, but no longer
> does.

No, pci_get_device() never decremented the refcount, and that didn't
change in the above git commit.

The description of pci_get_device() says that a reference is grabbed:
	Iterates through the list of known PCI devices.  If a PCI device
	is found with a matching @vendor and @device, the reference
	count to the device is incremented and a pointer to its device
	structure is returned.  Otherwise, %NULL is returned.  A new
	search is initiated by passing %NULL as the @from argument.
	Otherwise if @from is not %NULL, searches continue from next
	device on the global list.  The reference count for @from is
	always decremented if it is not %NULL.


All of the pci_find* functions should not have grabbed a reference to
the device, as that was the "old" behavior.  All of the pci_get*
functions do grab a reference.

Did I somehow mess up and one of the pci_find* functions now improperly
increment a reference?  Hopefully we shouldn't be using those functions
anymore as they aren't hotplug safe...

thanks,

greg k-h
