Return-Path: <linux-kernel-owner+w=401wt.eu-S1753903AbXC0P0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903AbXC0P0O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 11:26:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753902AbXC0P0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 11:26:14 -0400
Received: from colo.lackof.org ([198.49.126.79]:49275 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753901AbXC0P0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 11:26:13 -0400
Date: Tue, 27 Mar 2007 09:25:57 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Mitch Williams <mitch.a.williams@intel.com>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, gregkh@suse.de, ebiederm@xmission.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       auke-jan.h.kok@intel.com
Subject: Re: [PATCH 2.6.21-rc5] MSI: read-flush MSI-X table
Message-ID: <20070327152557.GC7157@colo.lackof.org>
References: <1174951102.22190.15.camel@strongmad>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1174951102.22190.15.camel@strongmad>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2007 at 04:18:22PM -0700, Mitch Williams wrote:
> This patch fixes a kernel bug which is triggered when using the
> irqbalance daemon with MSI-X hardware.
> 
> Because both MSI-X interrupt messages and MSI-X table writes are posted,
> it's possible for them to cross while in-flight.  This results in
> interrupts being received long after the kernel thinks they're disabled,
> and in interrupts being sent to stale vectors after rebalancing.
>
> This patch performs a read flush after writes to the MSI-X table for
> enable/disable and rebalancing operations.

Why wouldn't MSI have the same problems as MSI-X?

...
> diff -urpN -X dontdiff linux-2.6.21-rc4-clean/drivers/pci/msi.c linux-2.6.21-rc4/drivers/pci/msi.c
> --- linux-2.6.21-rc4-clean/drivers/pci/msi.c	2007-03-19 16:16:32.000000000 -0700
> +++ linux-2.6.21-rc4/drivers/pci/msi.c	2007-03-21 12:44:51.000000000 -0700
> @@ -68,6 +68,29 @@ static void msix_set_enable(struct pci_d
>  	}
>  }
>  
> +void msix_flush_writes(unsigned int irq)
> +{
> +	struct msi_desc *entry;
> +
> +	entry = get_irq_msi(irq);
> +	BUG_ON(!entry || !entry->dev);
> +	switch (entry->msi_attrib.type) {
> +	case PCI_CAP_ID_MSI:
> +		/* nothing to do */
> +		break;
> +	case PCI_CAP_ID_MSIX:
> +	{
> +		int offset = entry->msi_attrib.entry_nr * PCI_MSIX_ENTRY_SIZE +
> +			PCI_MSIX_ENTRY_VECTOR_CTRL_OFFSET;
> +		readl(entry->mask_base + offset);
> +		break;
> +	}
> +	default:
> +		BUG();
> +		break;
> +	}
> +}

PCI_CAP_ID_MSI case seems wrong to me.
I was expecting a readl() in that case as well.

thanks,
grant
