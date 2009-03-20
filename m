Return-Path: <linux-kernel-owner+w=401wt.eu-S1754213AbZCTCFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213AbZCTCFh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 22:05:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752746AbZCTCFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 22:05:25 -0400
Received: from mga02.intel.com ([134.134.136.20]:43926 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767AbZCTCFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 22:05:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,392,1233561600"; 
   d="scan'208";a="499308126"
Date: Fri, 20 Mar 2009 10:06:00 +0800
From: Yu Zhao <yu.zhao@intel.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v11 1/8] PCI: initialize and release SR-IOV capability
Message-ID: <20090320020600.GA23967@yzhao-otc.sh.intel.com>
References: <1236756349-18892-1-git-send-email-yu.zhao@intel.com> <1236756349-18892-2-git-send-email-yu.zhao@intel.com> <20090319195312.GC14127@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090319195312.GC14127@parisc-linux.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 20, 2009 at 03:53:12AM +0800, Matthew Wilcox wrote:
> On Wed, Mar 11, 2009 at 03:25:42PM +0800, Yu Zhao wrote:
> > +config PCI_IOV
> > +	bool "PCI IOV support"
> > +	depends on PCI
> > +	help
> > +	  PCI-SIG I/O Virtualization (IOV) Specifications support.
> > +	  Single Root IOV: allows the creation of virtual PCI devices
> > +	  that share the physical resources from a real device.
> > +
> > +	  When in doubt, say N.
> 
> It's certainly shorter than my text, which is nice.  But I think it
> still has too much spec-ese and not enough explanation.  How about:
> 
> 	help
> 	  I/O Virtualization is a PCI feature supported by some devices
> 	  which allows them to create virtual devices which share their
> 	  physical resources.
> 
> 	  If unsure, say N.

Yes, it's more user-friendly.

> > +	list_for_each_entry(pdev, &dev->bus->devices, bus_list)
> > +		if (pdev->is_physfn)
> > +			break;
> > +	if (list_empty(&dev->bus->devices) || !pdev->is_physfn)
> > +		pdev = NULL;
> 
> This is still wrong.  If the 'break' condition is not hit, pdev is
> pointing to garbage, not to the last pci_dev in the list.

Yes, you are right. I should think it over after you commented on it
last time.

So it looks like we need to make it as:

	ctrl = 0;
	list_for_each_entry(pdev, &dev->bus->devices, bus_list)
		if (pdev->is_physfn)
			goto found;

	pdev = NULL;
	if (pci_ari_enabled(dev->bus))
		ctrl |= PCI_SRIOV_CTRL_ARI;

found:
	pci_write_config_word(dev, pos + PCI_SRIOV_CTRL, ctrl);
	...

> > @@ -270,6 +278,7 @@ struct pci_dev {
> >  	struct list_head msi_list;
> >  #endif
> >  	struct pci_vpd *vpd;
> > +	struct pci_sriov *sriov;	/* SR-IOV capability related */
> 
> Should be ifdeffed?

Yes, will do.


Thank you for reviewing it. The patch series was applied on Xen Domain0
tree 2 days ago, and I'll carry your comments back to Xen tree too.
