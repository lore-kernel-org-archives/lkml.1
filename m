Return-Path: <linux-kernel-owner+w=401wt.eu-S1756198AbZCOQtL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198AbZCOQtL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 12:49:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755191AbZCOQsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 12:48:45 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:28391 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755494AbZCOQso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 12:48:44 -0400
Date: Sun, 15 Mar 2009 10:48:41 -0600
From: Alex Chiang <achiang@hp.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 05/11] PCI: beef up pci_do_scan_bus()
Message-ID: <20090315164841.GA24570@ldl.fc.hp.com>
References: <20090309052933.3918.86601.stgit@bob.kio> <20090309054900.3918.4473.stgit@bob.kio> <49B8D2F4.1030206@jp.fujitsu.com> <20090312232226.GD31042@ldl.fc.hp.com> <49BA235C.4040703@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49BA235C.4040703@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Kenji-san,

* Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
> Alex Chiang wrote:
> > 
> > I hadn't gotten around to verifying/fixing existing callers of
> > pci_do_scan_bus yet. I was focusing on the core first.
> > 
> > There aren't too many callers, but unfortunately, I don't have
> > any hardware that actually uses the existing drivers.
> > 
> > I seem to recall that your machines support shpchp. Would you
> > mind testing this patch and telling me if your machine still
> > behaves properly?
> >
> 
> I have machines that support shpchp. But unfortunately I don't
> have any adapter card that contains bridge, which is needed to
> test your change.

You're right.

The more I think about it though, the more I think that even
without the below patch to clean up the callers of
pci_do_scan_bus, we should be ok, because:

	- all the old code (which I removed below) existed
	  because the old PCI core would refuse to scan PCI buses
	  that had already been discovered

	- that meant that it would never descend past a known
	  bridge to try and find new child bridges

	- that meant that hotplug drivers had to manually
	  discover new bridges and add them, essentially
	  duplicating functionality in pci_scan_bridge

This patch series allows the PCI core to scan existing bridges
and descend down into the children every time, looking for new
bridges and devices, so all the code in shpchp, cpcihp, and other
callers of pci_do_scan_bus shouldn't be necessary anymore.

Also, if we do add new bridges once manually in shpchp, and then
call the new pci_do_scan_bus again, we will _not_ add devices
twice because the core should check each bridge and device for
struct pci_dev.is_added.

So anyway, I think that cleaning up the callers of
pci_do_scan_bus is a good idea, but multiple calls to the
interface definitely should not result in problems. If they do,
then that's a bug in my patch series.

> > I looked at shpchp_configure_device and I think that simply
> > scanning the device's parent bus should work.
> >
> 
> Ok, I'll try it.

I set up a git tree to make it easier to test:

	git://git.kernel.org/pub/scm/linux/kernel/git/achiang/pci-hotplug.git

The 'test-20090313' branch contains all the latest fixes to
enable this patch series. It does not contain the patch below, so
you will have to apply it by hand.

Thanks for testing!

/ac

> 
> > Thanks.
> > 
> > /ac
> > 
> > diff --git a/drivers/pci/hotplug/shpchp_pci.c b/drivers/pci/hotplug/shpchp_pci.c
> > index aa315e5..7e8457b 100644
> > --- a/drivers/pci/hotplug/shpchp_pci.c
> > +++ b/drivers/pci/hotplug/shpchp_pci.c
> > @@ -110,11 +110,7 @@ int __ref shpchp_configure_device(struct slot *p_slot)
> >  		return -EINVAL;
> >  	}
> >  
> > -	num = pci_scan_slot(parent, PCI_DEVFN(p_slot->device, 0));
> > -	if (num == 0) {
> > -		ctrl_err(ctrl, "No new device found\n");
> > -		return -ENODEV;
> > -	}
> > +	pci_do_scan_bus(parent);
> >  
> >  	for (fn = 0; fn < 8; fn++) {
> >  		dev = pci_get_slot(parent, PCI_DEVFN(p_slot->device, fn));
> > @@ -126,40 +122,10 @@ int __ref shpchp_configure_device(struct slot *p_slot)
> >  			pci_dev_put(dev);
> >  			continue;
> >  		}
> > -		if ((dev->hdr_type == PCI_HEADER_TYPE_BRIDGE) ||
> > -				(dev->hdr_type == PCI_HEADER_TYPE_CARDBUS)) {
> > -			/* Find an unused bus number for the new bridge */
> > -			struct pci_bus *child;
> > -			unsigned char busnr, start = parent->secondary;
> > -			unsigned char end = parent->subordinate;
> > -			for (busnr = start; busnr <= end; busnr++) {
> > -				if (!pci_find_bus(pci_domain_nr(parent),
> > -							busnr))
> > -					break;
> > -			}
> > -			if (busnr > end) {
> > -				ctrl_err(ctrl,
> > -					 "No free bus for hot-added bridge\n");
> > -				pci_dev_put(dev);
> > -				continue;
> > -			}
> > -			child = pci_add_new_bus(parent, dev, busnr);
> > -			if (!child) {
> > -				ctrl_err(ctrl, "Cannot add new bus for %s\n",
> > -					 pci_name(dev));
> > -				pci_dev_put(dev);
> > -				continue;
> > -			}
> > -			child->subordinate = pci_do_scan_bus(child);
> > -			pci_bus_size_bridges(child);
> > -		}
> >  		program_fw_provided_values(dev);
> >  		pci_dev_put(dev);
> >  	}
> >  
> > -	pci_bus_assign_resources(parent);
> > -	pci_bus_add_devices(parent);
> > -	pci_enable_bridges(parent);
> >  	return 0;
> >  }
> >  
> > 
> 
