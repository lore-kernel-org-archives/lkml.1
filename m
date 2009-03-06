Return-Path: <linux-kernel-owner+w=401wt.eu-S1754816AbZCFUhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816AbZCFUhu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 15:37:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753865AbZCFUhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 15:37:39 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:49040 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794AbZCFUhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 15:37:38 -0500
Date: Fri, 6 Mar 2009 13:37:18 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Yu Zhao <yu.zhao@intel.com>
Cc: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: [PATCH v10 4/7] PCI: add SR-IOV API for Physical Function driver
Message-ID: <20090306203717.GG25995@parisc-linux.org>
References: <1235112888-9524-1-git-send-email-yu.zhao@intel.com> <1235112888-9524-5-git-send-email-yu.zhao@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235112888-9524-5-git-send-email-yu.zhao@intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 20, 2009 at 02:54:45PM +0800, Yu Zhao wrote:
> +	virtfn->sysdata = dev->bus->sysdata;
> +	virtfn->dev.parent = dev->dev.parent;
> +	virtfn->dev.bus = dev->dev.bus;
> +	virtfn->devfn = devfn;
> +	virtfn->hdr_type = PCI_HEADER_TYPE_NORMAL;
> +	virtfn->cfg_size = PCI_CFG_SPACE_EXP_SIZE;
> +	virtfn->error_state = pci_channel_io_normal;
> +	virtfn->current_state = PCI_UNKNOWN;
> +	virtfn->is_pcie = 1;
> +	virtfn->pcie_type = PCI_EXP_TYPE_ENDPOINT;
> +	virtfn->dma_mask = 0xffffffff;
> +	virtfn->vendor = dev->vendor;
> +	virtfn->subsystem_vendor = dev->subsystem_vendor;
> +	virtfn->class = dev->class;

There seems to be a certain amount of commonality between this and
pci_scan_device().  Have you considered trying to make a common helper
function, or does it not work out well?

> +	pci_device_add(virtfn, virtfn->bus);

Greg is probably going to ding you here for adding the device, then
creating the symlinks.  I believe it's now best practice to create the
symlinks first, so there's no window where userspace can get confused.

> +	mutex_unlock(&iov->pdev->sriov->lock);

I question the existance of this mutex now.  What's it protecting?

Aren't we going to be implicitly protected by virtue of the Physical
Function device driver being the only one calling this function, and the
driver will be calling it from the ->probe routine which is not called
simultaneously for the same device.

> +	virtfn->physfn = pci_dev_get(dev);
> +
> +	rc = pci_bus_add_device(virtfn);
> +	if (rc)
> +		goto failed1;
> +	sprintf(buf, "%d", id);

%u, perhaps?  And maybe 'id' should always be unsigned?  Just a thought.

> +	rc = sysfs_create_link(&iov->dev.kobj, &virtfn->dev.kobj, buf);
> +	if (rc)
> +		goto failed1;
> +	rc = sysfs_create_link(&virtfn->dev.kobj, &dev->dev.kobj, "physfn");
> +	if (rc)
> +		goto failed2;

I'm glad to see these symlinks documented in later patches!

> +	nres = 0;
> +	for (i = 0; i < PCI_SRIOV_NUM_BARS; i++) {
> +		res = dev->resource + PCI_SRIOV_RESOURCES + i;
> +		if (!res->parent)
> +			continue;
> +		nres++;
> +	}

Can't this be written more simply as:

	for (i = 0; i < PCI_SRIOV_NUM_BARS; i++) {
		res = dev->resource + PCI_SRIOV_RESOURCES + i;
		if (res->parent)
			nres++;
	}
?

> +	if (nres != iov->nres) {
> +		dev_err(&dev->dev, "no enough MMIO for SR-IOV\n");
> +		return -ENOMEM;
> +	}

Randy, can you help us out with better wording here?

> +		dev_err(&dev->dev, "no enough bus range for SR-IOV\n");

and here.

> +	if (iov->link != dev->devfn) {
> +		rc = -ENODEV;
> +		list_for_each_entry(link, &dev->bus->devices, bus_list) {
> +			if (link->sriov && link->devfn == iov->link)
> +				rc = sysfs_create_link(&iov->dev.kobj,
> +						&link->dev.kobj, "dep_link");

I skipped to the end and read patch 7/7 and I still don't understand
what dep_link is for.  Can you explain please?  In particular, how is it
different from physfn?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
