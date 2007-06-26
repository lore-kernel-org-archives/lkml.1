Return-Path: <linux-kernel-owner+w=401wt.eu-S1757970AbXFZOte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757970AbXFZOte (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 10:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754778AbXFZOt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 10:49:27 -0400
Received: from mga03.intel.com ([143.182.124.21]:26733 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753111AbXFZOt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 10:49:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,463,1175497200"; 
   d="scan'208";a="243513748"
Date: Tue, 26 Jun 2007 07:44:53 -0700
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       linux-kernel@vger.kernel.org, ak@suse.de, gregkh@suse.de,
       muli@il.ibm.com, suresh.b.siddha@intel.com, arjan@linux.intel.com,
       ashok.raj@intel.com, davem@davemloft.net, clameter@sgi.com
Subject: Re: [Intel IOMMU 02/10] PCI generic helper function
Message-ID: <20070626144453.GA31186@linux-os.sc.intel.com>
Reply-To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
References: <20070619213701.219910000@askeshav-devel.jf.intel.com> <20070619213808.504997000@askeshav-devel.jf.intel.com> <20070625224937.502d46a0.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070625224937.502d46a0.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2007 at 10:49:37PM -0700, Andrew Morton wrote:
> On Tue, 19 Jun 2007 14:37:03 -0700 "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com> wrote:
> 
> > +struct pci_dev *
> > +pci_find_upstream_pcie_bridge(struct pci_dev *pdev)
> 
> You didn't need a newline there, but that's what the rest of that file
> does.  Hu hum.
> 
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
> 
> I assume that if this bug triggers, we've found some broken hardware?
> 
> Going BUG seems like a pretty rude reaction to this, especially when it
> would be so easy to drop a warning and then recover.
> 
> 
> How's about this?
Looks good, thanks.

> 
> --- a/drivers/pci/search.c~intel-iommu-pci-generic-helper-function-fix
> +++ a/drivers/pci/search.c
> @@ -38,7 +38,11 @@ pci_find_upstream_pcie_bridge(struct pci
>  			continue;
>  		}
>  		/* PCI device should connect to a PCIE bridge */
> -		BUG_ON(pdev->pcie_type != PCI_EXP_TYPE_PCI_BRIDGE);
> +		if (pdev->pcie_type != PCI_EXP_TYPE_PCI_BRIDGE) {
> +			/* Busted hardware? */
> +			WARN_ON_ONCE(1);
> +			return NULL;
> +		}
>  		return pdev;
>  	}
>  
