Return-Path: <linux-kernel-owner+w=401wt.eu-S932962AbXDJDr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932962AbXDJDr1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 23:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030332AbXDJDrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 23:47:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:54670 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932950AbXDJDrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 23:47:24 -0400
Date: Mon, 9 Apr 2007 20:46:17 -0700
From: Greg KH <gregkh@suse.de>
To: Ashok Raj <ashok.raj@intel.com>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, ak@suse.de, muli@il.ibm.com,
       asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       anil.s.keshavamurthy@intel.com, arjan@linux.intel.com,
       shaohua.li@intel.com
Subject: Re: [patch 2/8] [Intel IOMMU] Some generic search functions
	required to lookup device relationships.
Message-ID: <20070410034617.GA30428@suse.de>
References: <20070409215552.221374000@intel.com> <20070409215723.431381000@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070409215723.431381000@intel.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 09, 2007 at 02:55:54PM -0700, Ashok Raj wrote:
> +/*
> + * find the upstream PCIE-to-PCI bridge of a PCI device
> + * if the device is PCIE, return NULL
> + * if the device isn't connected to a PCIE bridge (that is its parent is a
> + * legacy PCI bridge and the bridge is directly connected to bus 0), return its
> + * parent
> + */
> +struct pci_dev *
> +pci_find_upstream_pcie_bridge(struct pci_dev *pdev)
> +{
> +	struct pci_dev *tmp = NULL;
> +
> +	if (pdev->is_pcie)
> +		return NULL;
> +	while (1) {
> +		if (!pdev->bus->self)
> +			break;
> +		pdev = pdev->bus->self;
> +		/* a p2p bridge */
> +		if (!pdev->is_pcie) {
> +			tmp = pdev;
> +			continue;
> +		}
> +		/* PCI device should connect to a PCIE bridge */
> +		BUG_ON(pdev->pcie_type != PCI_EXP_TYPE_PCI_BRIDGE);
> +		return pdev;
> +	}
> +
> +	return tmp;
> +}

No locking while you walk up the bus list?

> --- linux-2.6.21-rc5.orig/include/linux/pci.h	2007-04-03 04:30:51.000000000 -0700
> +++ linux-2.6.21-rc5/include/linux/pci.h	2007-04-03 06:58:58.000000000 -0700
> @@ -126,6 +126,7 @@
>  	unsigned short	subsystem_device;
>  	unsigned int	class;		/* 3 bytes: (base,sub,prog-if) */
>  	u8		hdr_type;	/* PCI header type (`multi' flag masked out) */
> +	u8		pcie_type;	/* PCI-E device/port type */
>  	u8		rom_base_reg;	/* which config register controls the ROM */
>  	u8		pin;  		/* which interrupt pin this device uses */
>  
> @@ -168,6 +169,7 @@
>  	unsigned int 	msi_enabled:1;
>  	unsigned int	msix_enabled:1;
>  	unsigned int	is_managed:1;
> +	unsigned int	is_pcie:1;

Do you really need both fields?  Wouldn't just the pcie_type one work
(with some NOT_PCIE type being set for it if it isn't I suppose.)

thanks,

greg k-h
