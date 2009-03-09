Return-Path: <linux-kernel-owner+w=401wt.eu-S1752371AbZCIILd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371AbZCIILd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 04:11:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751796AbZCIILQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 04:11:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:48348 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233AbZCIILM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 04:11:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,328,1233561600"; 
   d="scan'208";a="496174574"
Date: Mon, 9 Mar 2009 16:12:14 +0800
From: Yu Zhao <yu.zhao@intel.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: [PATCH v10 1/7] PCI: initialize and release SR-IOV capability
Message-ID: <20090309081214.GA4638@yzhao-otc.sh.intel.com>
References: <1235112888-9524-1-git-send-email-yu.zhao@intel.com> <1235112888-9524-2-git-send-email-yu.zhao@intel.com> <20090306200810.GD25995@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090306200810.GD25995@parisc-linux.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 07, 2009 at 04:08:10AM +0800, Matthew Wilcox wrote:
> On Fri, Feb 20, 2009 at 02:54:42PM +0800, Yu Zhao wrote:
> > +config PCI_IOV
> > +	bool "PCI IOV support"
> > +	depends on PCI
> > +	select PCI_MSI
> 
> My understanding is that having 'select' of a config symbol that the
> user can choose is bad.  I think we should probably make this 'depends
> on PCI_MSI'.
> 
> PCI MSI can also be disabled at runtime (and Fedora do by default).
> Since SR-IOV really does require MSI, we need to put in a runtime check
> to see if pci_msi_enabled() is false.

Actually the SR-IOV doesn't really depend on the MSI (e.g. hardware doesn't
implement interrupt at all), but in most case the SR-IOV needs the MSI. The
selection is intended to make life easier. Anyway I'll remove it if people
want more flexibility (and possibility to break the PF driver).

> We don't depend on PCIEPORTBUS (a horribly named symbol).  Should we?
> SR-IOV is only supported for PCI Express machines.  I'm not sure of the
> right answer here, but I thought I should raise the question.

I think we don't need PCIe port bus framework. My understanding is it's for
those capabilities that want to share resources of the PCIe capability.

> > +	default n
> 
> You don't need this -- the default default is n ;-)
> 
> > +	help
> > +	  PCI-SIG I/O Virtualization (IOV) Specifications support.
> > +	  Single Root IOV: allows the Physical Function driver to enable
> > +	  the hardware capability, so the Virtual Function is accessible
> > +	  via the PCI Configuration Space using its own Bus, Device and
> > +	  Function Numbers. Each Virtual Function also has the PCI Memory
> > +	  Space to map the device specific register set.
> 
> I'm not convinced this is the most helpful we could be to the user who's
> configuring their own kernel.  How about something like this?  (Randy, I
> particularly look to you to make my prose less turgid).
> 
> 	help
> 	  IO Virtualisation is a PCI feature supported by some devices
> 	  which allows you to create virtual PCI devices and assign them
> 	  to guest OSes.  This option needs to be selected in the host
> 	  or Dom0 kernel, but does not need to be selected in the guest
> 	  or DomU kernel.  If you don't know whether your hardware supports
> 	  it, you can check by using lspci to look for the SR-IOV capability.
> 
> 	  If you have no idea what any of that means, it is safe to
> 	  answer 'N' here.
> 
> > diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
> > index 3d07ce2..ba99282 100644
> > --- a/drivers/pci/Makefile
> > +++ b/drivers/pci/Makefile
> > @@ -29,6 +29,9 @@ obj-$(CONFIG_DMAR) += dmar.o iova.o intel-iommu.o
> >  
> >  obj-$(CONFIG_INTR_REMAP) += dmar.o intr_remapping.o
> >  
> > +# PCI IOV support
> > +obj-$(CONFIG_PCI_IOV) += iov.o
> 
> I see you're following the gerneal style in this file, but the comments
> really add no value.  I should send a patch to take out the existing ones.
> 
> > +	list_for_each_entry(pdev, &dev->bus->devices, bus_list)
> > +		if (pdev->sriov)
> > +			break;
> > +	if (list_empty(&dev->bus->devices) || !pdev->sriov)
> > +		pdev = NULL;
> > +	ctrl = 0;
> > +	if (!pdev && pci_ari_enabled(dev->bus))
> > +		ctrl |= PCI_SRIOV_CTRL_ARI;
> > +
> 
> I don't like this loop.  At the end of a list_for_each_entry() loop,
> pdev will not be pointing at a pci_device, it'll be pointing to some
> offset from &dev->bus->devices.  So checking pdev->sriov at this point
> is really, really bad.  I would prefer to see something like this:
> 
>         ctrl = 0;
>         list_for_each_entry(pdev, &dev->bus->devices, bus_list) {
>                 if (pdev->sriov)
>                         goto ari_enabled;
>         }
> 
>         if (pci_ari_enabled(dev->bus))
>                 ctrl = PCI_SRIOV_CTRL_ARI;
>  ari_enabled:
>         pci_write_config_word(dev, pos + PCI_SRIOV_CTRL, ctrl);

I guess I should put some comments here. What I want to do is to find the
lowest numbered PF (pdev) if it exists. It has ARI Capable Hierarchy bit,
as you have figured out, and it also keeps the VF bus lock. The lock is
for those VFs who belong to different PFs within a SR-IOV device and reside
on different bus (virtual) than PF's. When the PF driver enables/disables
the SR-IOV of a PF (this may happen anytime, not only at the driver probe
stage), the virtual VF bus will be allocated if it hasn't been allocated
yet. The lock guards the VF bus allocation between different PFs whose VFs
share the VF bus.

> > +	if (pdev)
> > +		iov->pdev = pci_dev_get(pdev);
> > +	else {
> > +		iov->pdev = dev;
> > +		mutex_init(&iov->lock);
> > +	}
> 
> Now I'm confused.  Why don't we need to init the mutex if there's another
> device on the same bus which also has an iov capability?

Yes, that's what it means :-)

> > +static void sriov_release(struct pci_dev *dev)
> > +{
> > +	if (dev == dev->sriov->pdev)
> > +		mutex_destroy(&dev->sriov->lock);
> > +	else
> > +		pci_dev_put(dev->sriov->pdev);
> > +
> > +	kfree(dev->sriov);
> > +	dev->sriov = NULL;
> > +}
> 
> > +void pci_iov_release(struct pci_dev *dev)
> > +{
> > +	if (dev->sriov)
> > +		sriov_release(dev);
> > +}
> 
> This seems to be a bit of a design pattern with you, and I'm not quite sure why you do it like this instead of just doing:
> 
> void pci_iov_release(struct pci_dev *dev)
> {
> 	if (!dev->sriov)
> 		return;
> 	[...]
> }

It's not my design pattern. I just want to leave some space for the MR-IOV,
which would look like:

void pci_iov_release(struct pci_dev *dev)
{
	if (dev->sriov)
		sriov_release(dev);

	if (dev->mriov)
		mriov_release(dev);
}

And that's why I put *_iov_* wrapper on those *_sriov_* functions.

Thank you for the careful review!
Yu
