Return-Path: <linux-kernel-owner+w=401wt.eu-S1752759AbZCIIYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759AbZCIIYV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 04:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751808AbZCIIYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 04:24:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:62325 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233AbZCIIYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 04:24:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,328,1233561600"; 
   d="scan'208";a="496176828"
Date: Mon, 9 Mar 2009 16:25:05 +0800
From: Yu Zhao <yu.zhao@intel.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: [PATCH v10 4/7] PCI: add SR-IOV API for Physical Function
	driver
Message-ID: <20090309082505.GC4638@yzhao-otc.sh.intel.com>
References: <1235112888-9524-1-git-send-email-yu.zhao@intel.com> <1235112888-9524-5-git-send-email-yu.zhao@intel.com> <20090306203717.GG25995@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090306203717.GG25995@parisc-linux.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 07, 2009 at 04:37:18AM +0800, Matthew Wilcox wrote:
> On Fri, Feb 20, 2009 at 02:54:45PM +0800, Yu Zhao wrote:
> > +	virtfn->sysdata = dev->bus->sysdata;
> > +	virtfn->dev.parent = dev->dev.parent;
> > +	virtfn->dev.bus = dev->dev.bus;
> > +	virtfn->devfn = devfn;
> > +	virtfn->hdr_type = PCI_HEADER_TYPE_NORMAL;
> > +	virtfn->cfg_size = PCI_CFG_SPACE_EXP_SIZE;
> > +	virtfn->error_state = pci_channel_io_normal;
> > +	virtfn->current_state = PCI_UNKNOWN;
> > +	virtfn->is_pcie = 1;
> > +	virtfn->pcie_type = PCI_EXP_TYPE_ENDPOINT;
> > +	virtfn->dma_mask = 0xffffffff;
> > +	virtfn->vendor = dev->vendor;
> > +	virtfn->subsystem_vendor = dev->subsystem_vendor;
> > +	virtfn->class = dev->class;
> 
> There seems to be a certain amount of commonality between this and
> pci_scan_device().  Have you considered trying to make a common helper
> function, or does it not work out well?

It's doable. Will enhance the pci_setup_device and use it to setup the VF.

> > +	pci_device_add(virtfn, virtfn->bus);
> 
> Greg is probably going to ding you here for adding the device, then
> creating the symlinks.  I believe it's now best practice to create the
> symlinks first, so there's no window where userspace can get confused.

Yes, but unfortunately we can't create links before adding a device.
I double checked device_add(), there is no place for those links to be
created before it sends uevent. So for now, we have to trigger another
uevent for those links.

> > +	mutex_unlock(&iov->pdev->sriov->lock);
> 
> I question the existance of this mutex now.  What's it protecting?
> 
> Aren't we going to be implicitly protected by virtue of the Physical
> Function device driver being the only one calling this function, and the
> driver will be calling it from the ->probe routine which is not called
> simultaneously for the same device.

The PF driver patches I listed before support dynamical enabling/disabling
of the SR-IOV through sysfs interface. So we have to protect the VF bus
allocation as I explained before.

> > +	virtfn->physfn = pci_dev_get(dev);
> > +
> > +	rc = pci_bus_add_device(virtfn);
> > +	if (rc)
> > +		goto failed1;
> > +	sprintf(buf, "%d", id);
> 
> %u, perhaps?  And maybe 'id' should always be unsigned?  Just a thought.

Yes, will replace %d to %u.

> > +	rc = sysfs_create_link(&iov->dev.kobj, &virtfn->dev.kobj, buf);
> > +	if (rc)
> > +		goto failed1;
> > +	rc = sysfs_create_link(&virtfn->dev.kobj, &dev->dev.kobj, "physfn");
> > +	if (rc)
> > +		goto failed2;
> 
> I'm glad to see these symlinks documented in later patches!
> 
> > +	nres = 0;
> > +	for (i = 0; i < PCI_SRIOV_NUM_BARS; i++) {
> > +		res = dev->resource + PCI_SRIOV_RESOURCES + i;
> > +		if (!res->parent)
> > +			continue;
> > +		nres++;
> > +	}
> 
> Can't this be written more simply as:
> 
> 	for (i = 0; i < PCI_SRIOV_NUM_BARS; i++) {
> 		res = dev->resource + PCI_SRIOV_RESOURCES + i;
> 		if (res->parent)
> 			nres++;
> 	}

Yes, will do

> ?
> 
> > +	if (nres != iov->nres) {
> > +		dev_err(&dev->dev, "no enough MMIO for SR-IOV\n");
> > +		return -ENOMEM;
> > +	}
> 
> Randy, can you help us out with better wording here?
> 
> > +		dev_err(&dev->dev, "no enough bus range for SR-IOV\n");
> 
> and here.
> 
> > +	if (iov->link != dev->devfn) {
> > +		rc = -ENODEV;
> > +		list_for_each_entry(link, &dev->bus->devices, bus_list) {
> > +			if (link->sriov && link->devfn == iov->link)
> > +				rc = sysfs_create_link(&iov->dev.kobj,
> > +						&link->dev.kobj, "dep_link");
> 
> I skipped to the end and read patch 7/7 and I still don't understand
> what dep_link is for.  Can you explain please?  In particular, how is it
> different from physfn?

It's defined by spec as:

3.3.8. Function Dependency Link (12h)
The programming model for a Device may have vendor specific dependencies
between sets of Functions. The Function Dependency Link field is used to
describe these dependencies. This field describes dependencies between PFs.
VF dependencies are the same as the dependencies of their associated PFs.
If a PF is independent from other PFs of a Device, this field shall
contain its own Function Number. If a PF is dependent on other PFs of a
Device, this field shall contain the Function Number of the next PF in
the same Function Dependency List. The last PF in a Function Dependency
List shall contain the Function Number of the first PF in the Function
Dependency List. If PF p and PF q are in the same Function Dependency
List, than any SI that is assigned VF p,n shall also be assigned to VF q,n.

Thanks,
Yu
