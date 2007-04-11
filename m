Return-Path: <linux-kernel-owner+w=401wt.eu-S1161209AbXDKGOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161209AbXDKGOA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 02:14:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753671AbXDKGOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 02:14:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:18238 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570AbXDKGN7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 02:13:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,393,1170662400"; 
   d="scan'208"; a="228222322:sNHT18137784"
Subject: Re: [patch 2/8] [Intel IOMMU] Some generic search functions
	required to lookup device relationships.
From: Shaohua Li <shaohua.li@intel.com>
To: Greg KH <gregkh@suse.de>
Cc: Ashok Raj <ashok.raj@intel.com>, linux-kernel@vger.kernel.org,
       akpm@osdl.org, ak@suse.de, muli@il.ibm.com, asit.k.mallick@intel.com,
       suresh.b.siddha@intel.com, anil.s.keshavamurthy@intel.com,
       arjan@linux.intel.com
In-Reply-To: <20070410130334.GA9682@suse.de>
References: <20070409215552.221374000@intel.com>
	 <20070409215723.431381000@intel.com> <20070410034617.GA30428@suse.de>
	 <1176192698.6781.13.camel@sli10-conroe.sh.intel.com>
	 <20070410130334.GA9682@suse.de>
Content-Type: text/plain
Date: Wed, 11 Apr 2007 14:10:46 +0800
Message-Id: <1176271846.32431.3.camel@sli10-conroe.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-04-10 at 06:03 -0700, Greg KH wrote:
> On Tue, Apr 10, 2007 at 04:11:38PM +0800, Shaohua Li wrote:
> > On Mon, 2007-04-09 at 20:46 -0700, Greg KH wrote:
> > > On Mon, Apr 09, 2007 at 02:55:54PM -0700, Ashok Raj wrote:
> > > > +/*
> > > > + * find the upstream PCIE-to-PCI bridge of a PCI device
> > > > + * if the device is PCIE, return NULL
> > > > + * if the device isn't connected to a PCIE bridge (that is its parent is a
> > > > + * legacy PCI bridge and the bridge is directly connected to bus 0), return its
> > > > + * parent
> > > > + */
> > > > +struct pci_dev *
> > > > +pci_find_upstream_pcie_bridge(struct pci_dev *pdev)
> > > > +{
> > > > +	struct pci_dev *tmp = NULL;
> > > > +
> > > > +	if (pdev->is_pcie)
> > > > +		return NULL;
> > > > +	while (1) {
> > > > +		if (!pdev->bus->self)
> > > > +			break;
> > > > +		pdev = pdev->bus->self;
> > > > +		/* a p2p bridge */
> > > > +		if (!pdev->is_pcie) {
> > > > +			tmp = pdev;
> > > > +			continue;
> > > > +		}
> > > > +		/* PCI device should connect to a PCIE bridge */
> > > > +		BUG_ON(pdev->pcie_type != PCI_EXP_TYPE_PCI_BRIDGE);
> > > > +		return pdev;
> > > > +	}
> > > > +
> > > > +	return tmp;
> > > > +}
> > > 
> > > No locking while you walk up the bus list?
> > hmm, iommu driver didn't support pci hotplug in current stage. But we
> > can add lock here.
> 
> Please do, as PCI-E hotplug is much more common than PCI hotplug these
> days (think ExpressCard in millions of laptops...)
Sounds we can't add lock here. pci_bus_sem is a semaphore, but the api
can be called within a spinlock and maybe with interrupt disabled. On
the other hand, there is no hotplug risk here. The pdev is in use (the
driver is doing dma buf allocation) when the api is called, so it's
parent can't be hotpluged too. If you feel others misuse the api, we
could move it to intel_iommu.c.

Thanks,
Shaohua
