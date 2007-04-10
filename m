Return-Path: <linux-kernel-owner+w=401wt.eu-S1030473AbXDJIPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030473AbXDJIPS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 04:15:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933103AbXDJIOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 04:14:52 -0400
Received: from mga01.intel.com ([192.55.52.88]:2547 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933075AbXDJIOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 04:14:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,389,1170662400"; 
   d="scan'208"; a="227568979:sNHT18805339"
Subject: Re: [patch 2/8] [Intel IOMMU] Some generic search functions
	required to lookup device relationships.
From: Shaohua Li <shaohua.li@intel.com>
To: Greg KH <gregkh@suse.de>
Cc: Ashok Raj <ashok.raj@intel.com>, linux-kernel@vger.kernel.org,
       akpm@osdl.org, ak@suse.de, muli@il.ibm.com, asit.k.mallick@intel.com,
       suresh.b.siddha@intel.com, anil.s.keshavamurthy@intel.com,
       arjan@linux.intel.com
In-Reply-To: <20070410034617.GA30428@suse.de>
References: <20070409215552.221374000@intel.com>
	 <20070409215723.431381000@intel.com>  <20070410034617.GA30428@suse.de>
Content-Type: text/plain
Date: Tue, 10 Apr 2007 16:11:38 +0800
Message-Id: <1176192698.6781.13.camel@sli10-conroe.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-09 at 20:46 -0700, Greg KH wrote:
> On Mon, Apr 09, 2007 at 02:55:54PM -0700, Ashok Raj wrote:
> > +/*
> > + * find the upstream PCIE-to-PCI bridge of a PCI device
> > + * if the device is PCIE, return NULL
> > + * if the device isn't connected to a PCIE bridge (that is its parent is a
> > + * legacy PCI bridge and the bridge is directly connected to bus 0), return its
> > + * parent
> > + */
> > +struct pci_dev *
> > +pci_find_upstream_pcie_bridge(struct pci_dev *pdev)
> > +{
> > +	struct pci_dev *tmp = NULL;
> > +
> > +	if (pdev->is_pcie)
> > +		return NULL;
> > +	while (1) {
> > +		if (!pdev->bus->self)
> > +			break;
> > +		pdev = pdev->bus->self;
> > +		/* a p2p bridge */
> > +		if (!pdev->is_pcie) {
> > +			tmp = pdev;
> > +			continue;
> > +		}
> > +		/* PCI device should connect to a PCIE bridge */
> > +		BUG_ON(pdev->pcie_type != PCI_EXP_TYPE_PCI_BRIDGE);
> > +		return pdev;
> > +	}
> > +
> > +	return tmp;
> > +}
> 
> No locking while you walk up the bus list?
hmm, iommu driver didn't support pci hotplug in current stage. But we can add lock here.

> > --- linux-2.6.21-rc5.orig/include/linux/pci.h	2007-04-03 04:30:51.000000000 -0700
> > +++ linux-2.6.21-rc5/include/linux/pci.h	2007-04-03 06:58:58.000000000 -0700
> > @@ -126,6 +126,7 @@
> >  	unsigned short	subsystem_device;
> >  	unsigned int	class;		/* 3 bytes: (base,sub,prog-if) */
> >  	u8		hdr_type;	/* PCI header type (`multi' flag masked out) */
> > +	u8		pcie_type;	/* PCI-E device/port type */
> >  	u8		rom_base_reg;	/* which config register controls the ROM */
> >  	u8		pin;  		/* which interrupt pin this device uses */
> >  
> > @@ -168,6 +169,7 @@
> >  	unsigned int 	msi_enabled:1;
> >  	unsigned int	msix_enabled:1;
> >  	unsigned int	is_managed:1;
> > +	unsigned int	is_pcie:1;
> 
> Do you really need both fields?  Wouldn't just the pcie_type one work
> (with some NOT_PCIE type being set for it if it isn't I suppose.)
There are some encodings are reserved for future. Just don't want to use
reserved bits, as we don't know which one is proper for NOT_PCIE.

Thanks,
Shaohua
